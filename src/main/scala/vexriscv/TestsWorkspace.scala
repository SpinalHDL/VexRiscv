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


// make clean all SEED=42 MMU=no STOP_ON_ERROR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes SUPERVISOR=yes REDO=1 DHRYSTONE=yes LRSC=yes AMO=yes LINUX_REGRESSION=yes TRACE=yes TRACE_START=1000000000 FLOW_INFO=ye IBUS_DATA_WIDTH=128  DBUS_DATA_WIDTH=128
//make clean all SEED=42 MMU=no STOP_ON_ERROR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes SUPERVISOR=yes REDO=1 DHRYSTONE=yes LRSC=yes AMO=yes  TRACE=yes TRACE_START=1000000000 FLOW_INFO=ye IBUS_DATA_WIDTH=128  DBUS_DATA_WIDTH=128 LINUX_SOC_SMP=yes VMLINUX=../../../../../buildroot/output/images/Image RAMDISK=../../../../../buildroot/output/images/rootfs.cpio  DTB=../../../../../buildroot/output/images/dtb EMULATOR=../../../../../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin
object TestsWorkspace {
  def main(args: Array[String]) {
    def configFull = {
      val config = VexRiscvConfig(
        plugins = List(
          new MmuPlugin(
            ioRange = x => x(31 downto 28) === 0xF
          ),
          //Uncomment the whole IBusSimplePlugin and comment IBusCachedPlugin if you want uncached iBus config
          //        new IBusSimplePlugin(
          //          resetVector = 0x80000000l,
          //          cmdForkOnSecondStage = false,
          //          cmdForkPersistence = false,
          //          prediction = DYNAMIC_TARGET,
          //          historyRamSizeLog2 = 10,
          //          catchAccessFault = true,
          //          compressedGen = true,
          //          busLatencyMin = 1,
          //          injectorStage = true,
          //          memoryTranslatorPortConfig = withMmu generate MmuPortConfig(
          //            portTlbSize = 4
          //          )
          //        ),

          //Uncomment the whole IBusCachedPlugin and comment IBusSimplePlugin if you want cached iBus config
          new IBusCachedPlugin(
            resetVector = 0x80000000l,
            compressedGen = false,
            prediction = STATIC,
            injectorStage = false,
            config = InstructionCacheConfig(
              cacheSize = 4096*2,
              bytePerLine = 64,
              wayCount = 2,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 128,
              catchIllegalAccess = true,
              catchAccessFault = true,
              asyncTagMemory = false,
              twoCycleRam = true,
              twoCycleCache = true,
              reducedBankWidth = true
              //          )
            ),
            memoryTranslatorPortConfig = MmuPortConfig(
              portTlbSize = 4,
              latency = 1,
              earlyRequireMmuLockup = true,
              earlyCacheHits = true
            )
          ),
          //          ).newTightlyCoupledPort(TightlyCoupledPortParameter("iBusTc", a => a(30 downto 28) === 0x0 && a(5))),
          //        new DBusSimplePlugin(
          //          catchAddressMisaligned = true,
          //          catchAccessFault = true,
          //          earlyInjection = false,
          //          withLrSc = true,
          //          memoryTranslatorPortConfig = withMmu generate MmuPortConfig(
          //            portTlbSize = 4
          //          )
          //        ),
          new DBusCachedPlugin(
            dBusCmdMasterPipe = true,
            dBusCmdSlavePipe = true,
            dBusRspSlavePipe = true,
            config = new DataCacheConfig(
              cacheSize         = 4096*1,
              bytePerLine       = 64,
              wayCount          = 1,
              addressWidth      = 32,
              cpuDataWidth      = 32,
              memDataWidth      = 128,
              catchAccessError  = true,
              catchIllegal      = true,
              catchUnaligned    = true,
              withLrSc = true,
              withAmo = true,
              withExclusive = true,
              withInvalidate = true,
              pendingMax = 32
              //          )
            ),
            memoryTranslatorPortConfig = MmuPortConfig(
              portTlbSize = 4,
              latency = 1,
              earlyRequireMmuLockup = true,
              earlyCacheHits = true
            )
          ),

          //          new MemoryTranslatorPlugin(
          //            tlbSize = 32,
          //            virtualRange = _(31 downto 28) === 0xC,
          //            ioRange      = _(31 downto 28) === 0xF
          //          ),

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
          new FullBarrelShifterPlugin(earlyInjection = false),
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
          new CsrPlugin(CsrPluginConfig.all2(0x80000020l).copy(ebreakGen = false, misaExtensionsInit = Riscv.misaToInt("imas"))),
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
            earlyBranch = false,
            catchAddressMisaligned = true,
            fenceiGenAsAJump = false
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
