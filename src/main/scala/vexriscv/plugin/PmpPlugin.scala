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
 * 
 * N.B. THIS IMPLEMENTATION ONLY SUPPORTS NAPOT ADDRESSING. REGIONS ARE NOT
 * ORDERED BY PRIORITY. A PERMISSION IS GRANTED TO AN ACCESS IF ANY MATCHING
 * PMP REGION HAS THAT PERMISSION ENABLED.
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

class PmpSetter(cutoff : Int) extends Component with Pmp {
  val io = new Bundle {
    val addr = in UInt(xlen bits)
    val base, mask = out UInt(xlen - cutoff bits)
  }

  val ones = io.addr & ~(io.addr + 1)
  io.base := io.addr(xlen - 3 downto cutoff - 2) ^ ones(xlen - 3 downto cutoff - 2)
  io.mask := ~(ones(xlen - 4 downto cutoff - 2) @@ U"1")
}

case class ProtectedMemoryTranslatorPort(bus : MemoryTranslatorBus)

class PmpPlugin(regions : Int, granularity : Int, ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator with Pmp {
  assert(regions % 4 == 0 & regions <= 16)
  assert(granularity >= 8)

  var setter : PmpSetter = null
  var dPort, iPort : ProtectedMemoryTranslatorPort = null
  val cutoff = log2Up(granularity) - 1
  
  override def newTranslationPort(priority : Int, args : Any): MemoryTranslatorBus = {
    val port = ProtectedMemoryTranslatorPort(MemoryTranslatorBus(new MemoryTranslatorBusParameter(0, 0)))
    priority match {
      case PRIORITY_INSTRUCTION => iPort = port
      case PRIORITY_DATA => dPort = port
    }
    port.bus
  }

  override def setup(pipeline: VexRiscv): Unit = {
    setter = new PmpSetter(cutoff)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline._
    import Riscv._

    val csrService = pipeline.service(classOf[CsrInterface])
    val privilegeService = pipeline.service(classOf[PrivilegeService])

    val state = pipeline plug new Area {
      val pmpaddr = Mem(UInt(xlen bits), regions)
      val pmpcfg = Vector.fill(regions)(Reg(Bits(8 bits)) init (0))
      val base, mask = Vector.fill(regions)(Reg(UInt(xlen - cutoff bits)))
    }

    def machineMode : Bool = privilegeService.isMachine()

    execute plug new Area {
      import execute._

      val fsmPending = RegInit(False) clearWhen(!arbitration.isStuck)
      val fsmComplete = False
      val hazardFree = csrService.isHazardFree()

      val csrAddress = input(INSTRUCTION)(csrRange)
      val pmpNcfg = csrAddress(log2Up(regions) - 1 downto 0).asUInt
      val pmpcfgN = pmpNcfg(log2Up(regions) - 3 downto 0)
      val pmpcfgCsr = input(INSTRUCTION)(31 downto 24) === 0x3a
      val pmpaddrCsr = input(INSTRUCTION)(31 downto 24) === 0x3b

      val pmpNcfg_ = Reg(UInt(log2Up(regions) bits))
      val pmpcfgN_ = Reg(UInt(log2Up(regions) - 2 bits))
      val pmpcfgCsr_ = RegInit(False)
      val pmpaddrCsr_ = RegInit(False)
      val writeData_ = Reg(Bits(xlen bits))

      csrService.duringAnyRead {
        when (machineMode) {
          when (pmpcfgCsr) {
            csrService.allowCsr()
            csrService.readData() :=
              state.pmpcfg(pmpcfgN @@ U(3, 2 bits)) ##
              state.pmpcfg(pmpcfgN @@ U(2, 2 bits)) ##
              state.pmpcfg(pmpcfgN @@ U(1, 2 bits)) ##
              state.pmpcfg(pmpcfgN @@ U(0, 2 bits))
          }
          when (pmpaddrCsr) {
            csrService.allowCsr()
            csrService.readData() := state.pmpaddr(pmpNcfg).asBits
          }
        }
      }

      csrService.duringAnyWrite {
        when ((pmpcfgCsr | pmpaddrCsr) & machineMode) {
          csrService.allowCsr()
          arbitration.haltItself := !fsmComplete
          when (!fsmPending && hazardFree) {
            fsmPending := True
            writeData_ := csrService.writeData()
            pmpNcfg_ := pmpNcfg
            pmpcfgN_ := pmpcfgN
            pmpcfgCsr_ := pmpcfgCsr
            pmpaddrCsr_ := pmpaddrCsr
          }
        }
      }

      val fsm = new StateMachine {
        val fsmEnable = RegInit(False)
        val fsmCounter = Reg(UInt(log2Up(regions) bits)) init(0)

        val stateIdle : State = new State with EntryPoint {
          onEntry {
            fsmPending := False
            fsmEnable := False
            fsmComplete := True
            fsmCounter := 0
          }
          whenIsActive {
            when (fsmPending) {
              goto(stateWrite)
            }
          }
        }

        val stateWrite : State = new State {
          whenIsActive {
            when (pmpcfgCsr_) {
              val overwrite = writeData_.subdivideIn(8 bits)
              for (i <- 0 until 4) {
                when (~state.pmpcfg(pmpcfgN_ @@ U(i, 2 bits))(lBit)) {
                  state.pmpcfg(pmpcfgN_ @@ U(i, 2 bits)).assignFromBits(overwrite(i))
                }
              }
              goto(stateCfg)
            }
            when (pmpaddrCsr_) {
              when (~state.pmpcfg(pmpNcfg_)(lBit)) {
                state.pmpaddr(pmpNcfg_) := writeData_.asUInt
              }
              goto(stateAddr)
            }
          }
          onExit (fsmEnable := True)
        }

        val stateCfg : State = new State {
          onEntry (fsmCounter := pmpcfgN_ @@ U(0, 2 bits))
          whenIsActive {
            fsmCounter := fsmCounter + 1
            when (fsmCounter(1 downto 0) === 3) {
              goto(stateIdle)
            }
          }
        }

        val stateAddr : State = new State {
          onEntry (fsmCounter := pmpNcfg_)
          whenIsActive (goto(stateIdle))
        }

        when (pmpaddrCsr_) {
          setter.io.addr := writeData_.asUInt
        } otherwise {
          setter.io.addr := state.pmpaddr(fsmCounter)
        }
        
        when (fsmEnable & ~state.pmpcfg(fsmCounter)(lBit)) {
          state.base(fsmCounter) := setter.io.base
          state.mask(fsmCounter) := setter.io.mask
        }
      }
    }

    pipeline plug new Area {
      def getHits(address : UInt) = {
        (0 until regions).map(i =>
            ((address & state.mask(U(i, log2Up(regions) bits))) === state.base(U(i, log2Up(regions) bits))) &
            (state.pmpcfg(i)(lBit) | ~machineMode) & (state.pmpcfg(i)(aBits) === NAPOT)
        )
      }

      def getPermission(hits : IndexedSeq[Bool], bit : Int) = {
        MuxOH(OHMasking.first(hits), state.pmpcfg.map(_(bit)))
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

        val hits = getHits(address(31 downto cutoff))

        when(~hits.orR) {
          dPort.bus.rsp.allowRead := machineMode
          dPort.bus.rsp.allowWrite := machineMode
        } otherwise {
          dPort.bus.rsp.allowRead := getPermission(hits, rBit)
          dPort.bus.rsp.allowWrite := getPermission(hits, wBit)
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

        val hits = getHits(address(31 downto cutoff))

        when(~hits.orR) {
          iPort.bus.rsp.allowExecute := machineMode
        } otherwise {
          iPort.bus.rsp.allowExecute := getPermission(hits, xBit)
        }
      }
    }
  }
}