/*
 * Copyright (c) 2021 Samuel Lindemer <samuel.lindemer@ri.se>
 *
 * SPDX-License-Identifier: MIT
 */

package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import vexriscv.plugin.CsrPlugin.{_}
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

class PmpSetter() extends Component with Pmp {
  val io = new Bundle {
    val a = in Bits(2 bits)
    val addr = in UInt(xlen bits)
    val prevHi = in UInt(30 bits)
    val boundLo, boundHi = out UInt(30 bits)
  }

  val shifted = io.addr(29 downto 0)
  io.boundLo := shifted
  io.boundHi := shifted

  switch (io.a) {
    is (TOR) {
      io.boundLo := io.prevHi
    }
    is (NA4) {
      io.boundHi := shifted + 1
    }
    is (NAPOT) {
      val mask = io.addr & ~(io.addr + 1)
      val boundLo = (io.addr ^ mask)(29 downto 0)
      io.boundLo := boundLo
      io.boundHi := boundLo + ((mask + 1) |<< 3)(29 downto 0)
    }
  }
}

case class ProtectedMemoryTranslatorPort(bus : MemoryTranslatorBus)

class PmpPlugin(regions : Int, ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator with Pmp {
  assert(regions % 4 == 0)
  assert(regions <= 16)

  var setter : PmpSetter = null
  var dPort, iPort : ProtectedMemoryTranslatorPort = null
  
  override def newTranslationPort(priority : Int, args : Any): MemoryTranslatorBus = {
    val port = ProtectedMemoryTranslatorPort(MemoryTranslatorBus(new MemoryTranslatorBusParameter(0, 0)))
    priority match {
      case PRIORITY_INSTRUCTION => iPort = port
      case PRIORITY_DATA => dPort = port
    }
    port.bus
  }

  override def setup(pipeline: VexRiscv): Unit = {
    setter = new PmpSetter()
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline._
    import Riscv._

    val csrService = pipeline.service(classOf[CsrInterface])
    val privilegeService = pipeline.service(classOf[PrivilegeService])

    val pmpaddr = Mem(UInt(xlen bits), regions)
    val pmpcfg = Reg(Bits(8 * regions bits)) init(0)
    val boundLo, boundHi = Mem(UInt(30 bits), regions)
    val cfgRegion = pmpcfg.subdivideIn(8 bits)
    val cfgRegister = pmpcfg.subdivideIn(xlen bits)
    val lockMask = Reg(Bits(4 bits)) init(B"4'0")

    execute plug new Area {
      import execute._

      val csrAddress = input(INSTRUCTION)(csrRange)
      val accessAddr = input(IS_PMP_ADDR)
      val accessCfg = input(IS_PMP_CFG)
      val pmpWrite = arbitration.isValid && input(IS_CSR) && input(CSR_WRITE_OPCODE) & (accessAddr | accessCfg)
      val pmpRead = arbitration.isValid && input(IS_CSR) && input(CSR_READ_OPCODE) & (accessAddr | accessCfg)
      val pmpIndex = csrAddress(log2Up(regions) - 1 downto 0).asUInt
      val pmpSelect = pmpIndex(log2Up(regions) - 3 downto 0)

      val readAddr = pmpaddr.readAsync(pmpIndex).asBits
      val readCfg = cfgRegister(pmpSelect)
      val readToWrite = Mux(accessCfg, readCfg, readAddr)
      val writeSrc = input(SRC1)
      val writeData = input(INSTRUCTION)(13).mux(
        False -> writeSrc,
        True -> Mux(
          input(INSTRUCTION)(12),
          readToWrite & ~writeSrc,
          readToWrite | writeSrc
        )
      )
      
      val writer = new Area {
        when (accessCfg) {
          when (pmpRead) {
            output(REGFILE_WRITE_DATA).assignFromBits(readCfg)
          }
          when (pmpWrite) {
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
                      if (j != 0 || i != 0) {
                        when (overwrite(lBit) & overwrite(aBits) === TOR) {
                          pmpcfg(j + xlen * i - 1) := True
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }.elsewhen (accessAddr) {
          when (pmpRead) {
            output(REGFILE_WRITE_DATA) := readAddr
          }
        }
        val locked = cfgRegion(pmpIndex)(lBit)
        pmpaddr.write(pmpIndex, writeData.asUInt, ~locked & pmpWrite & accessAddr)
      }

      val controller = new StateMachine {
        val counter = Reg(UInt(log2Up(regions) bits)) init(0)
        val enable = RegInit(False)

        val stateIdle : State = new State with EntryPoint {
          onEntry {
            lockMask := B"4'x0"
            enable := False
            counter := 0
          }
          onExit {
            enable := True
            arbitration.haltItself := True
          }
          whenIsActive {
            when (pmpWrite) {
              when (accessCfg) {
                goto(stateCfg)
              }.elsewhen (accessAddr) {
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
          whenIsActive {
            counter := counter + 1
            when (counter === (pmpIndex + 1) | counter === 0) {
              goto(stateIdle)
            } otherwise {
              arbitration.haltItself := True
            }
          }
        }

        when (accessCfg) {
          setter.io.a := writeData.subdivideIn(8 bits)(counter(1 downto 0))(aBits)
          setter.io.addr := pmpaddr(counter) 
        } otherwise {
          setter.io.a := cfgRegion(counter)(aBits)
          when (counter === pmpIndex) {
            setter.io.addr := writeData.asUInt
          } otherwise {
            setter.io.addr := pmpaddr(counter)
          }
        }
        
        when (counter === 0) {
          setter.io.prevHi := 0
        } otherwise {
          setter.io.prevHi := boundHi(counter - 1)
        }
        
        when (enable & 
              ((accessCfg & ~lockMask(counter(1 downto 0))) | 
               (accessAddr & ~cfgRegion(counter)(lBit)))) {
          boundLo(counter) := setter.io.boundLo
          boundHi(counter) := setter.io.boundHi
        }
      }
    }

    pipeline plug new Area {
      def getHits(address : UInt) = {
        (0 until regions).map(i =>
            address >= boundLo(U(i, log2Up(regions) bits)) & 
            address < boundHi(U(i, log2Up(regions) bits)) &
            (cfgRegion(i)(lBit) | ~privilegeService.isMachine()) & 
            cfgRegion(i)(aBits) =/= 0
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

        val hits = getHits(address(31 downto 2))

        when(~hits.orR) {
          dPort.bus.rsp.allowRead := privilegeService.isMachine()
          dPort.bus.rsp.allowWrite := privilegeService.isMachine()
        } otherwise {
          val oneHot = OHMasking.first(hits)
          dPort.bus.rsp.allowRead := MuxOH(oneHot, cfgRegion.map(cfg => cfg(rBit)))
          dPort.bus.rsp.allowWrite := MuxOH(oneHot, cfgRegion.map(cfg => cfg(wBit)))
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

        val hits = getHits(address(31 downto 2))

        when(~hits.orR) {
          iPort.bus.rsp.allowExecute := privilegeService.isMachine()
        } otherwise {
          val oneHot = OHMasking.first(hits)
          iPort.bus.rsp.allowExecute := MuxOH(oneHot, cfgRegion.map(cfg => cfg(xBit)))
        }
      }
    }
  }
}