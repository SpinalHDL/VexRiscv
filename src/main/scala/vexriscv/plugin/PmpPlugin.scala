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
 * These section numbers contain flags which apply to region defined by the
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
 * NAPOT: Each 32-bit pmpaddr# register defines the regionStart address and the size
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

case class PmpRegister() extends Bundle {

  // CSR segments
  val x, w, r = Reg(Bool)
  val l = Reg(Bool) init(False)
  val a = Reg(UInt(2 bits)) init(0)
  val address = Reg(UInt(32 bits))

  // Computed region bounds
  val regionStart = UInt(32 bits)
  val regionEnd = UInt(32 bits)
  val valid = Bool

  // Addressing options
  def NA4 = 2
  def NAPOT = 3

  switch(a) {
    is(NA4) {
      regionStart := address |<< 2
      regionEnd := regionStart + 4
      valid := True
    }
    is(NAPOT) {
      val mask = address & ~(address + 1)
      regionStart := (address & ~mask) |<< 2
      regionEnd := regionStart + ((mask + 1) |<< 3)
      valid := True
    }
    default {
      regionStart := 0
      regionEnd := 0
      valid := False
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
    import pipeline._
    import pipeline.config._
    import Riscv._

    val csrService = pipeline.service(classOf[CsrInterface])
    val privilegeService = pipeline.service(classOf[PrivilegeService])

    val core = pipeline plug new Area {

      // Instantiate pmpaddr0 ... pmpaddr# CSRs.
      for (n <- 0 until regions) {
        pmps += PmpRegister() 
        csrService.rw(0x3B0 + n, pmps(n).address)
      }

      // Instantiate pmpcfg0 ... pmpcfg# CSRs.
      for (n <- 0 until (regions / 4)) {
        csrService.rw(0x3A0 + n, 
          31 -> pmps((n * 4) + 3).l, 27 -> pmps((n * 4) + 3).a,
          26 -> pmps((n * 4) + 3).x, 25 -> pmps((n * 4) + 3).w, 24 -> pmps((n * 4) + 3).r,
          23 -> pmps((n * 4) + 2).l, 19 -> pmps((n * 4) + 2).a,
          18 -> pmps((n * 4) + 2).x, 17 -> pmps((n * 4) + 2).w, 16 -> pmps((n * 4) + 2).r,
          15 -> pmps((n * 4) + 1).l, 11 -> pmps((n * 4) + 1).a,
          10 -> pmps((n * 4) + 1).x,  9 -> pmps((n * 4) + 1).w,  8 -> pmps((n * 4) + 1).r,
           7 -> pmps((n * 4)    ).l,  3 -> pmps((n * 4)    ).a,
           2 -> pmps((n * 4)    ).x,  1 -> pmps((n * 4)    ).w,  0 -> pmps((n * 4)    ).r
        )
      }

      // Connect memory ports to PMP logic.
      val ports = for ((port, portId) <- portsInfo.zipWithIndex) yield new Area {

        val address = port.bus.cmd.virtualAddress
        port.bus.rsp.physicalAddress := address

        // Only the first matching PMP region is applied.
        val hits = pmps.map(pmp => pmp.valid && 
                                   pmp.regionStart <= address && 
                                   pmp.regionEnd > address &&
                                   (pmp.l || ~privilegeService.isMachine()))

        // M-mode has full access by default. All others have none by default.
        when(CountOne(hits) === 0) {
          port.bus.rsp.allowRead := privilegeService.isMachine()
          port.bus.rsp.allowWrite := privilegeService.isMachine()
          port.bus.rsp.allowExecute := privilegeService.isMachine()
        } otherwise {
          port.bus.rsp.allowRead := MuxOH(OHMasking.first(hits), pmps).r
          port.bus.rsp.allowWrite := MuxOH(OHMasking.first(hits), pmps).w
          port.bus.rsp.allowExecute := MuxOH(OHMasking.first(hits), pmps).x
        }

        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.exception := False
        port.bus.rsp.refilling := False
        port.bus.busy := False

      }
    }
  }
}

