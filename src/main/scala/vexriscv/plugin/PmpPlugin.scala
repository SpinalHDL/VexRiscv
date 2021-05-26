/*
 * Copyright (c) 2021 Samuel Lindemer <samuel.lindemer@ri.se>
 *
 * SPDX-License-Identifier: MIT
 */

package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import vexriscv.plugin.MemoryTranslatorPort.{_}
import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

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

trait Pmp {
  def OFF = 0
  def TOR = 1
  def NA4 = 2
  def NAPOT = 3

  def xlen = 32
  def rBit = 0
  def wBit = 1
  def xBit = 2
  def aBits = 4 downto 3
  def lBit = 7
}

class PmpSetter(grain : Int) extends Component with Pmp {
  val io = new Bundle {
    val addr = in UInt(xlen bits)
    val base, mask = out UInt(xlen - grain bits)
  }

  val ones = io.addr & ~(io.addr + 1)
  io.base := io.addr(xlen - 1 - grain downto 0) ^ ones(xlen - 1 - grain downto 0)
  io.mask := ~ones(xlen - grain downto 1)
}

case class ProtectedMemoryTranslatorPort(bus : MemoryTranslatorBus)

class PmpPlugin(regions : Int, granularity : Int, ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator with Pmp {
  assert(regions % 4 == 0 & regions <= 16)
  assert(granularity >= 8)

  var setter : PmpSetter = null
  var dPort, iPort : ProtectedMemoryTranslatorPort = null
  val grain = log2Up(granularity) - 1
  
  override def newTranslationPort(priority : Int, args : Any): MemoryTranslatorBus = {
    val port = ProtectedMemoryTranslatorPort(MemoryTranslatorBus(new MemoryTranslatorBusParameter(0, 0)))
    priority match {
      case PRIORITY_INSTRUCTION => iPort = port
      case PRIORITY_DATA => dPort = port
    }
    port.bus
  }

  override def setup(pipeline: VexRiscv): Unit = {
    setter = new PmpSetter(grain)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline._
    import Riscv._

    val csrService = pipeline.service(classOf[CsrInterface])
    val privilegeService = pipeline.service(classOf[PrivilegeService])

    val pmpaddr = Mem(UInt(xlen bits), regions)
    val pmpcfg = Reg(Bits(8 * regions bits)) init(0)
    val base, mask = Mem(UInt(xlen - grain bits), regions)
    val cfgRegion = pmpcfg.subdivideIn(8 bits)
    val cfgRegister = pmpcfg.subdivideIn(xlen bits)
    val lockMask = Reg(Bits(4 bits)) init(B"4'0")

    object PMPCFG extends Stageable(Bool)
    object PMPADDR extends Stageable(Bool)
    
    decode plug new Area {
      import decode._
      insert(PMPCFG) := input(INSTRUCTION)(31 downto 24) === 0x3a
      insert(PMPADDR) := input(INSTRUCTION)(31 downto 24) === 0x3b
    }

    execute plug new Area {
      import execute._

      val mask0 = mask(U"4'x0")
      val mask1 = mask(U"4'x1")
      val mask2 = mask(U"4'x2")
      val mask3 = mask(U"4'x3")
      val mask4 = mask(U"4'x4")
      val mask5 = mask(U"4'x5")
      val mask6 = mask(U"4'x6")
      val mask7 = mask(U"4'x7")
      val mask8 = mask(U"4'x8")
      val mask9 = mask(U"4'x9")
      val mask10 = mask(U"4'xa")
      val mask11 = mask(U"4'xb")
      val mask12 = mask(U"4'xc")
      val mask13 = mask(U"4'xd")
      val mask14 = mask(U"4'xe")
      val mask15 = mask(U"4'xf")
      val base0 = base(U"4'x0")
      val base1 = base(U"4'x1")
      val base2 = base(U"4'x2")
      val base3 = base(U"4'x3")
      val base4 = base(U"4'x4")
      val base5 = base(U"4'x5")
      val base6 = base(U"4'x6")
      val base7 = base(U"4'x7")
      val base8 = base(U"4'x8")
      val base9 = base(U"4'x9")
      val base10 = base(U"4'xa")
      val base11 = base(U"4'xb")
      val base12 = base(U"4'xc")
      val base13 = base(U"4'xd")
      val base14 = base(U"4'xe")
      val base15 = base(U"4'xf")

      val csrAddress = input(INSTRUCTION)(csrRange)
      val pmpIndex = csrAddress(log2Up(regions) - 1 downto 0).asUInt
      val pmpSelect = pmpIndex(log2Up(regions) - 3 downto 0)
      val writeData = csrService.writeData()

      val enable = RegInit(False)
      for (i <- 0 until regions) csrService.allow(0x3b0 + i)
      for (i <- 0 until (regions / 4)) csrService.allow(0x3a0 + i)
      
      csrService.duringAnyRead {
        when (input(PMPCFG)) { csrService.readData().assignFromBits(cfgRegister(pmpSelect)) }
        when (input(PMPADDR)) { csrService.readData() := pmpaddr.readAsync(pmpIndex).asBits }
      }

      csrService.duringAnyWrite {
        when (input(PMPCFG) | input(PMPADDR)) { enable := True }
      }

      val writer = new Area {
        when (enable & csrService.isHazardFree()) {
          when (input(PMPCFG)) {
            switch(pmpSelect) {
              for (i <- 0 until (regions / 4)) {
                is(i) {
                  for (j <- Range(0, xlen, 8)) {
                    val bitRange = j + xlen * i + lBit downto j + xlen * i
                    val overwrite = writeData.subdivideIn(8 bits)(j / 8)
                    val locked = cfgRegister(i).subdivideIn(8 bits)(j / 8)(lBit)
                    lockMask(j / 8) := locked
                    when (~locked) {
                      pmpcfg(bitRange).assignFromBits(overwrite)
                    }
                  }
                }
              }
            }
          }
        }
        val locked = cfgRegion(pmpIndex)(lBit)
        pmpaddr.write(pmpIndex, writeData.asUInt, ~locked & input(PMPADDR) & enable & csrService.isHazardFree())
      }

      val controller = new StateMachine {
        val counter = Reg(UInt(log2Up(regions) bits)) init(0)

        val stateIdle : State = new State with EntryPoint {
          onEntry {
            lockMask := B"4'x0"
            enable := False
            counter := 0
          }
          onExit (arbitration.haltItself := True)
          whenIsActive {
            when (enable & csrService.isHazardFree()) {
              when (input(PMPCFG)) {
                goto(stateCfg)
              }.elsewhen (input(PMPADDR)) {
                goto(stateAddr)
              }
            }
          }
        }

        val stateCfg : State = new State {
          onEntry (counter := pmpIndex(log2Up(regions) - 3 downto 0) @@ U"2'00")
          whenIsActive {
            counter := counter + 1
            when (counter(1 downto 0) === 3) {
              goto(stateIdle)
            } otherwise {
              arbitration.haltItself := True
            }
          }
        }

        val stateAddr : State = new State {
          onEntry (counter := pmpIndex)
          whenIsActive (goto(stateIdle))
        }

        when (input(PMPCFG)) {
          setter.io.addr := pmpaddr(counter) 
        } otherwise {
          when (counter === pmpIndex) {
            setter.io.addr := writeData.asUInt
          } otherwise {
            setter.io.addr := pmpaddr(counter)
          }
        }
        
        when (enable & csrService.isHazardFree() &
              ((input(PMPCFG) & ~lockMask(counter(1 downto 0))) | 
               (input(PMPADDR) & ~cfgRegion(counter)(lBit)))) {
          base(counter) := setter.io.base
          mask(counter) := setter.io.mask
        }
      }
    }

    pipeline plug new Area {
      def getHits(address : UInt) = {
        (0 until regions).map(i =>
            ((address & mask(U(i, log2Up(regions) bits))) === base(U(i, log2Up(regions) bits))) & 
            (cfgRegion(i)(lBit) | ~privilegeService.isMachine()) & cfgRegion(i)(aBits) === NAPOT
        )
      }

      val dGuard = new Area {
        val address = dPort.bus.cmd(0).virtualAddress
        dPort.bus.rsp.physicalAddress := address
        dPort.bus.rsp.isIoAccess := ioRange(address)
        dPort.bus.rsp.isPaging := False
        dPort.bus.rsp.exception := False
        dPort.bus.rsp.refilling := False
        dPort.bus.rsp.allowExecute := False
        dPort.bus.busy := False

        val hits = getHits(address(31 downto grain))

        when(~hits.orR) {
          dPort.bus.rsp.allowRead := privilegeService.isMachine()
          dPort.bus.rsp.allowWrite := privilegeService.isMachine()
        } otherwise {
          dPort.bus.rsp.allowRead := (hits zip cfgRegion).map({ case (i, cfg) => i & cfg(rBit) }).orR
          dPort.bus.rsp.allowWrite := (hits zip cfgRegion).map({ case (i, cfg) => i & cfg(wBit) }).orR
        }
      }

      val iGuard = new Area {
        val address = iPort.bus.cmd(0).virtualAddress
        iPort.bus.rsp.physicalAddress := address
        iPort.bus.rsp.isIoAccess := ioRange(address)
        iPort.bus.rsp.isPaging := False
        iPort.bus.rsp.exception := False
        iPort.bus.rsp.refilling := False
        iPort.bus.rsp.allowRead := False
        iPort.bus.rsp.allowWrite := False
        iPort.bus.busy := False

        val hits = getHits(address(31 downto grain))

        when(~hits.orR) {
          iPort.bus.rsp.allowExecute := privilegeService.isMachine()
        } otherwise {
          iPort.bus.rsp.allowExecute := (hits zip cfgRegion).map({ case (i, cfg) => i & cfg(xBit) }).orR
        }
      }
    }
  }
}