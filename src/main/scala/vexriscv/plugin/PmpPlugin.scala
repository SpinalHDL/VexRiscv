/*
 * Copyright (c) 2020 Samuel Lindemer <samuel.lindemer@ri.se>
 *
 * SPDX-License-Identifier: MIT
 */

package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._
import scala.collection.mutable.ArrayBuffer

/* Each 32-bit pmpcfg# register contains four 8-bit configuration sections.
 * These section numbers contain flags which apply to regions defined by the
 * corresponding pmpaddr# register.
 *
 *    3                   2                   1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * |    pmp3cfg    |    pmp2cfg    |    pmp1cfg    |    pmp0cfg    | pmpcfg0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * |    pmp7cfg    |    pmp6cfg    |    pmp5cfg    |    pmp4cfg    | pmpcfg2
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 *     7       6       5       4       3       2       1       0
 * +-------+-------+-------+-------+-------+-------+-------+-------+
 * |   L   |       0       |       A       |   X   |   W   |   R   | pmp#cfg
 * +-------+-------+-------+-------+-------+-------+-------+-------+
 *
 *	  L: locks configuration until system reset (including M-mode)
 *	  0: hardwired to zero
 *	  A: 0 = OFF (null region / disabled)
 *	     1 = TOR (top of range)
 * 	     2 = NA4 (naturally aligned four-byte region)
 *	     3 = NAPOT (naturally aligned power-of-two region, > 7 bytes)
 *	  X: execute
 *	  W: write
 *	  R: read
 *
 * TOR: Each 32-bit pmpaddr# register defines the upper bound of the pmp region
 * right-shifted by two bits. The lower bound of the region is the previous
 * pmpaddr# register. In the case of pmpaddr0, the lower bound is address 0x0.
 *
 *    3                   2                   1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * |                        address[33:2]                          | pmpaddr#
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 * NAPOT: Each 32-bit pmpaddr# register defines the region address and the size
 * of the pmp region. The number of concurrent 1s begging at the LSB indicates
 * the size of the region as a power of two (e.g. 0x...0 = 8-byte, 0x...1 =
 * 16-byte, 0x...11 = 32-byte, etc.).
 *
 *    3                   2                   1
 *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 * |                        address[33:2]                |0|1|1|1|1| pmpaddr#
 * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *
 * NA4: This is essentially an edge case of NAPOT where the entire pmpaddr#
 * register defines a 4-byte wide region.
 */

case class PmpRegister(previous : PmpRegister) extends Area {

  def OFF = 0
  def TOR = 1
  def NA4 = 2
  def NAPOT = 3

  // Software-accessible CSR interface
  val csr = new Area {
    val r, w, x = Reg(Bool)
    val l = RegInit(False)
    val a = Reg(UInt(2 bits)) init(0)
    val addr = Reg(UInt(32 bits))
  }

  // Active region bounds and permissions (internal)
  val region = new Area {
    val r, w, x = Reg(Bool)
    val l, valid = RegInit(False)
    val start, end = Reg(UInt(32 bits))
  }
  
  when(~region.l) {
    region.r := csr.r
    region.w := csr.w
    region.x := csr.x
    region.l := csr.l

    val shifted = csr.addr |<< 2
    region.valid := True

    switch(csr.a) {

      is(TOR) {
        if (previous == null) {
          region.start := 0
        } else {
          region.start := previous.region.end
        }
        if (csr.l == True) {
          previous.region.l := True
        }
        region.end := shifted
      }

      is(NA4) {
        region.start := shifted
        region.end := shifted + 4
      }

      is(NAPOT) {
        val mask = csr.addr & ~(csr.addr + 1)
        val masked = (csr.addr & ~mask) |<< 2
        region.start := masked
        region.end := masked + ((mask + 1) |<< 3)
      }

      default {
        region.end := shifted
        region.valid := False
      }

    }
  }
}

case class ProtectedMemoryTranslatorPort(bus : MemoryTranslatorBus)

class PmpPlugin(regions : Int, ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator {

  // Each pmpcfg# CSR configures four regions.
  assert((regions % 4) == 0)
   
  val pmps = ArrayBuffer[PmpRegister]()
  val portsInfo = ArrayBuffer[ProtectedMemoryTranslatorPort]()

  override def newTranslationPort(priority : Int, args : Any): MemoryTranslatorBus = {
    val port = ProtectedMemoryTranslatorPort(MemoryTranslatorBus())
    portsInfo += port
    port.bus
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline._
    import Riscv._

    val csrService = pipeline.service(classOf[CsrInterface])
    val privilegeService = pipeline.service(classOf[PrivilegeService])

    val core = pipeline plug new Area {

      // Instantiate pmpaddr0 ... pmpaddr# CSRs.
      for (i <- 0 until regions) {
        if (i == 0) {
          pmps += PmpRegister(null)
        } else {
          pmps += PmpRegister(pmps.last)
        }
        csrService.rw(0x3b0 + i, pmps(i).csr.addr)
      }

      // Instantiate pmpcfg0 ... pmpcfg# CSRs.
      for (i <- 0 until (regions / 4)) {
        csrService.rw(0x3a0 + i,
          31 -> pmps((i * 4) + 3).csr.l, 23 -> pmps((i * 4) + 2).csr.l,
          15 -> pmps((i * 4) + 1).csr.l,  7 -> pmps((i * 4)    ).csr.l,
          27 -> pmps((i * 4) + 3).csr.a, 26 -> pmps((i * 4) + 3).csr.x,
          25 -> pmps((i * 4) + 3).csr.w, 24 -> pmps((i * 4) + 3).csr.r,
          19 -> pmps((i * 4) + 2).csr.a, 18 -> pmps((i * 4) + 2).csr.x,
          17 -> pmps((i * 4) + 2).csr.w, 16 -> pmps((i * 4) + 2).csr.r,
          11 -> pmps((i * 4) + 1).csr.a, 10 -> pmps((i * 4) + 1).csr.x,
           9 -> pmps((i * 4) + 1).csr.w,  8 -> pmps((i * 4) + 1).csr.r,
           3 -> pmps((i * 4)    ).csr.a,  2 -> pmps((i * 4)    ).csr.x,
           1 -> pmps((i * 4)    ).csr.w,  0 -> pmps((i * 4)    ).csr.r
        )
      }

      // Connect memory ports to PMP logic.
      val ports = for ((port, portId) <- portsInfo.zipWithIndex) yield new Area {

        val address = port.bus.cmd.virtualAddress
        port.bus.rsp.physicalAddress := address

        // Only the first matching PMP region applies.
        val hits = pmps.map(pmp => pmp.region.valid && 
                                   pmp.region.start <= address && 
                                   pmp.region.end > address &&
                                  (pmp.region.l || ~privilegeService.isMachine()))

        // M-mode has full access by default, others have none.
        when(CountOne(hits) === 0) {
          port.bus.rsp.allowRead := privilegeService.isMachine()
          port.bus.rsp.allowWrite := privilegeService.isMachine()
          port.bus.rsp.allowExecute := privilegeService.isMachine()
        } otherwise {
          port.bus.rsp.allowRead := MuxOH(OHMasking.first(hits), pmps.map(_.region.r))
          port.bus.rsp.allowWrite := MuxOH(OHMasking.first(hits), pmps.map(_.region.w))
          port.bus.rsp.allowExecute := MuxOH(OHMasking.first(hits), pmps.map(_.region.x))
        }

        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.exception := False
        port.bus.rsp.refilling := False
        port.bus.busy := False

      }
    }
  }
}

