/*
 * SpinalHDL
 * Copyright (c) Dolu, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

package vexriscv

import vexriscv.plugin._
import vexriscv.demo.SimdAddPlugin
import spinal.core._
import spinal.lib._
import vexriscv.ip._
import spinal.lib.bus.avalon.AvalonMM
import spinal.lib.eda.altera.{InterruptReceiverTag, ResetEmitterTag}

object TestsWorkspace {
  def main(args: Array[String]) {
    def configFull = {
      val config = VexRiscvConfig(
        plugins = List(
          //          new IBusSimplePlugin(
          //            resetVector = 0x80000000l,
          //            cmdForkOnSecondStage = false,
          //            cmdForkPersistence = false,
          //            prediction = NONE,
          //            historyRamSizeLog2 = 10,
          //            catchAccessFault = false,
          //            compressedGen = false,
          //            busLatencyMin = 1,
          //            injectorStage = true
          //          ),
          new IBusCachedPlugin(
            resetVector = 0x80000000l,
            compressedGen = false,
            prediction = NONE,
            injectorStage = true,
            config = InstructionCacheConfig(
              cacheSize = 4096,
              bytePerLine = 32,
              wayCount = 1,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchIllegalAccess = true,
              catchAccessFault = true,
              asyncTagMemory = false,
              twoCycleRam = false,
              twoCycleCache = true
            ),
            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
              portTlbSize = 4
            )
          ),
//          ).newTightlyCoupledPort(TightlyCoupledPortParameter("iBusTc", a => a(30 downto 28) === 0x0 && a(5))),
          //          new DBusSimplePlugin(
          //            catchAddressMisaligned = true,
          //            catchAccessFault = false,
          //            earlyInjection = false
          //          ),
          new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize         = 4096,
              bytePerLine       = 32,
              wayCount          = 1,
              addressWidth      = 32,
              cpuDataWidth      = 32,
              memDataWidth      = 32,
              catchAccessError  = true,
              catchIllegal      = true,
              catchUnaligned    = true,
              withLrSc = true
            ),
            //            memoryTranslatorPortConfig = null
            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
              portTlbSize = 6
            )
          ),
          //          new StaticMemoryTranslatorPlugin(
          //            ioRange      = _(31 downto 28) === 0xF
          //          ),
          new MemoryTranslatorPlugin(
            tlbSize = 32,
            virtualRange = _(31 downto 28) === 0xC,
            ioRange      = _(31 downto 28) === 0xF
          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = true
          ),
          new RegFilePlugin(
            regFileReadyKind = plugin.ASYNC,
            zeroBoot = true
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false
          ),
          new FullBarrelShifterPlugin(earlyInjection = true),
          //        new LightShifterPlugin,
          new HazardSimplePlugin(
            bypassExecute           = true,
            bypassMemory            = true,
            bypassWriteBack         = true,
            bypassWriteBackBuffer   = true,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
          //        new HazardSimplePlugin(false, true, false, true),
          //        new HazardSimplePlugin(false, false, false, false),
          new MulPlugin,
          new MulDivIterativePlugin(
            genMul = false,
            genDiv = true,
            mulUnrollFactor = 32,
            divUnrollFactor = 1
          ),
          //          new DivPlugin,
          new CsrPlugin(CsrPluginConfig.all(0x80000020l)),
          //          new CsrPlugin(//CsrPluginConfig.all2(0x80000020l).copy(ebreakGen = true)/*
          //             CsrPluginConfig(
          //            catchIllegalAccess = false,
          //            mvendorid      = null,
          //            marchid        = null,
          //            mimpid         = null,
          //            mhartid        = null,
          //            misaExtensionsInit = 0,
          //            misaAccess     = CsrAccess.READ_ONLY,
          //            mtvecAccess    = CsrAccess.WRITE_ONLY,
          //            mtvecInit      = 0x80000020l,
          //            mepcAccess     = CsrAccess.READ_WRITE,
          //            mscratchGen    = true,
          //            mcauseAccess   = CsrAccess.READ_ONLY,
          //            mbadaddrAccess = CsrAccess.READ_ONLY,
          //            mcycleAccess   = CsrAccess.NONE,
          //            minstretAccess = CsrAccess.NONE,
          //            ecallGen       = true,
          //            ebreakGen      = true,
          //            wfiGenAsWait   = false,
          //            wfiGenAsNop    = true,
          //            ucycleAccess   = CsrAccess.NONE
          //          )),
          new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
          new BranchPlugin(
            earlyBranch = true,
            catchAddressMisaligned = true,
            fenceiGenAsAJump = true
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )
      config
    }


//    import spinal.core.sim._
//    SimConfig.withConfig(SpinalConfig(mergeAsyncProcess = false, anonymSignalPrefix = "zz_")).allOptimisation.compile(new VexRiscv(configFull)).doSimUntilVoid{ dut =>
//      dut.clockDomain.forkStimulus(10)
//      dut.clockDomain.forkSimSpeedPrinter(4)
//      var iBus : InstructionCacheMemBus = null
//
//      dut.plugins.foreach{
//        case plugin: IBusCachedPlugin => iBus = plugin.iBus
//        case _ =>
//      }
//      dut.clockDomain.onSamplings{
////        iBus.cmd.ready.randomize()
//        iBus.rsp.data #= 0x13
//      }
//    }

    SpinalConfig(mergeAsyncProcess = false, anonymSignalPrefix = "zz_").generateVerilog {


      val toplevel = new VexRiscv(configFull)
//      val toplevel = new VexRiscv(configLight)
//      val toplevel = new VexRiscv(configTest)

      /*toplevel.rework {
        var iBus : AvalonMM = null
        for (plugin <- toplevel.config.plugins) plugin match {
          case plugin: IBusSimplePlugin => {
            plugin.iBus.asDirectionLess() //Unset IO properties of iBus
            iBus = master(plugin.iBus.toAvalon())
              .setName("iBusAvalon")
              .addTag(ClockDomainTag(ClockDomain.current)) //Specify a clock domain to the iBus (used by QSysify)
          }
          case plugin: IBusCachedPlugin => {
            plugin.iBus.asDirectionLess() //Unset IO properties of iBus
            iBus = master(plugin.iBus.toAvalon())
              .setName("iBusAvalon")
              .addTag(ClockDomainTag(ClockDomain.current)) //Specify a clock domain to the iBus (used by QSysify)
          }
          case plugin: DBusSimplePlugin => {
            plugin.dBus.asDirectionLess()
            master(plugin.dBus.toAvalon())
              .setName("dBusAvalon")
              .addTag(ClockDomainTag(ClockDomain.current))
          }
          case plugin: DBusCachedPlugin => {
            plugin.dBus.asDirectionLess()
            master(plugin.dBus.toAvalon())
              .setName("dBusAvalon")
              .addTag(ClockDomainTag(ClockDomain.current))
          }
          case plugin: DebugPlugin => {
            plugin.io.bus.asDirectionLess()
            slave(plugin.io.bus.fromAvalon())
              .setName("debugBusAvalon")
              .addTag(ClockDomainTag(plugin.debugClockDomain))
              .parent = null  //Avoid the io bundle to be interpreted as a QSys conduit
            plugin.io.resetOut
              .addTag(ResetEmitterTag(plugin.debugClockDomain))
              .parent = null //Avoid the io bundle to be interpreted as a QSys conduit
          }
          case _ =>
        }
        for (plugin <- toplevel.config.plugins) plugin match {
          case plugin: CsrPlugin => {
            plugin.externalInterrupt
              .addTag(InterruptReceiverTag(iBus, ClockDomain.current))
            plugin.timerInterrupt
              .addTag(InterruptReceiverTag(iBus, ClockDomain.current))
          }
          case _ =>
        }
      }*/
//      toplevel.writeBack.input(config.PC).addAttribute(Verilator.public)
//      toplevel.service(classOf[DecoderSimplePlugin]).bench(toplevel)
     // toplevel.children.find(_.isInstanceOf[DataCache]).get.asInstanceOf[DataCache].io.cpu.execute.addAttribute(Verilator.public)
      toplevel
    }
  }
}

//TODO DivPlugin should not used MixedDivider (double twoComplement)
//TODO DivPlugin should register the twoComplement output before pipeline insertion
//TODO MulPlugin doesn't fit well on Artix (FMAX)
//TODO PcReg design is unoptimized by Artix synthesis
//TODO FMAX SRC mux + bipass mux prioriti
//TODO FMAX, isFiring is to pesimisstinc in some cases(include removeIt flushed ..)