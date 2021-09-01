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

  val state = new Area {
    val r, w, x = Reg(Bool)
    val l = RegInit(False)
    val a = Reg(UInt(2 bits)) init(0)
    val addr = Reg(UInt(32 bits))
  }

  // CSR writes connect to these signals rather than the internal state
  // registers. This makes locking and WARL possible.
  val csr = new Area {
    val r, w, x = Bool
    val l = Bool
    val a = UInt(2 bits)
    val addr = UInt(32 bits)
  }

  // Last valid assignment wins; nothing happens if a user-initiated write did
  // not occur on this clock cycle.
  csr.r    := state.r
  csr.w    := state.w
  csr.x    := state.x
  csr.l    := state.l
  csr.a    := state.a
  csr.addr := state.addr

  // Computed PMP region bounds
  val region = new Area {
    val valid, locked = Bool
    val start, end = UInt(32 bits)
  }

  when(~state.l) {
    state.r    := csr.r
    state.w    := csr.w
    state.x    := csr.x
    state.l    := csr.l
    state.a    := csr.a
    state.addr := csr.addr

    if (csr.l == True & csr.a == TOR) {
      previous.state.l := True
    }
  }

  val shifted = state.addr |<< 2
  val mask = state.addr & ~(state.addr + 1)
  val masked = (state.addr & ~mask) |<< 2

  // PMP changes take effect two clock cycles after the initial CSR write (i.e.,
  // settings propagate from csr -> state -> region).
  region.locked := state.l
  region.valid := True

  switch(csr.a) {
    is(TOR) {
      if (previous == null) region.start := 0
      else region.start := previous.region.end
      region.end := shifted
    }
    is(NA4) {
      region.start := shifted
      region.end := shifted + 4
    }
    is(NAPOT) {
      region.start := masked
      region.end := masked + ((mask + 1) |<< 3)
    }
    default {
      region.start := 0
      region.end := shifted
      region.valid := False
    }
  }
}


class PmpPluginOld(regions : Int, ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator {

  // Each pmpcfg# CSR configures four regions.
  assert((regions % 4) == 0)

  val pmps = ArrayBuffer[PmpRegister]()
  val portsInfo = ArrayBuffer[ProtectedMemoryTranslatorPort]()

  override def newTranslationPort(priority : Int, args : Any): MemoryTranslatorBus = {
    val port = ProtectedMemoryTranslatorPort(MemoryTranslatorBus(new MemoryTranslatorBusParameter(0, 0)))
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
        csrService.r(0x3b0 + i, pmps(i).state.addr)
        csrService.w(0x3b0 + i, pmps(i).csr.addr)
      }

      // Instantiate pmpcfg0 ... pmpcfg# CSRs.
      for (i <- 0 until (regions / 4)) {
        csrService.r(0x3a0 + i,
          31 -> pmps((i * 4) + 3).state.l, 23 -> pmps((i * 4) + 2).state.l,
          15 -> pmps((i * 4) + 1).state.l,  7 -> pmps((i * 4)    ).state.l,
          27 -> pmps((i * 4) + 3).state.a, 26 -> pmps((i * 4) + 3).state.x,
          25 -> pmps((i * 4) + 3).state.w, 24 -> pmps((i * 4) + 3).state.r,
          19 -> pmps((i * 4) + 2).state.a, 18 -> pmps((i * 4) + 2).state.x,
          17 -> pmps((i * 4) + 2).state.w, 16 -> pmps((i * 4) + 2).state.r,
          11 -> pmps((i * 4) + 1).state.a, 10 -> pmps((i * 4) + 1).state.x,
          9 -> pmps((i * 4) + 1).state.w,  8 -> pmps((i * 4) + 1).state.r,
          3 -> pmps((i * 4)    ).state.a,  2 -> pmps((i * 4)    ).state.x,
          1 -> pmps((i * 4)    ).state.w,  0 -> pmps((i * 4)    ).state.r
        )
        csrService.w(0x3a0 + i,
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

        val address = port.bus.cmd(0).virtualAddress
        port.bus.rsp.physicalAddress := address

        // Only the first matching PMP region applies.
        val hits = pmps.map(pmp => pmp.region.valid &
          pmp.region.start <= address &
          pmp.region.end > address &
          (pmp.region.locked | ~privilegeService.isMachine()))

        // M-mode has full access by default, others have none.
        when(CountOne(hits) === 0) {
          port.bus.rsp.allowRead := privilegeService.isMachine()
          port.bus.rsp.allowWrite := privilegeService.isMachine()
          port.bus.rsp.allowExecute := privilegeService.isMachine()
        } otherwise {
          port.bus.rsp.allowRead := MuxOH(OHMasking.first(hits), pmps.map(_.state.r))
          port.bus.rsp.allowWrite := MuxOH(OHMasking.first(hits), pmps.map(_.state.w))
          port.bus.rsp.allowExecute := MuxOH(OHMasking.first(hits), pmps.map(_.state.x))
        }

        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.isPaging := False
        port.bus.rsp.exception := False
        port.bus.rsp.refilling := False
        port.bus.busy := False

      }
    }
  }
}
