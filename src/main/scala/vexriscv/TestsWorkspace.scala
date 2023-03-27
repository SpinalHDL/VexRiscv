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
import vexriscv.demo.{GenFull, SimdAddPlugin}
import spinal.core._
import spinal.lib._
import vexriscv.ip._
import spinal.lib.bus.avalon.AvalonMM
import spinal.lib.cpu.riscv.debug.DebugTransportModuleParameter
import spinal.lib.eda.altera.{InterruptReceiverTag, ResetEmitterTag}
import vexriscv.demo.smp.VexRiscvSmpClusterGen
import vexriscv.ip.fpu.FpuParameter


// make clean all SEED=42 MMU=no STOP_ON_ERROR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes SUPERVISOR=yes REDO=1 DHRYSTONE=yes LRSC=yes AMO=yes LINUX_REGRESSION=yes TRACE=yes TRACE_START=1000000000 FLOW_INFO=ye IBUS_DATA_WIDTH=128  DBUS_DATA_WIDTH=128
// make clean all IBUS=CACHED IBUS_DATA_WIDTH=64 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 LRSC=yes AMO=yes SUPERVISOR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes MUL=yes DIV=yes RVF=yes RVD=yes DEBUG_PLUGIN=no LINUX_SOC_SMP=yes EMULATOR=$IMAGES/fw_jump.bin VMLINUX=$IMAGES/Image DTB=$IMAGES/linux.dtb RAMDISK=$IMAGES/rootfs.cpio  TRACE=ye REDO=1 DEBUG=ye WITH_USER_IO=yes SEED=42
object TestsWorkspace {
  def main(args: Array[String]) {
    SpinalConfig().generateVerilog {

      // make clean all REDO=10 CSR=no MMU=no  COREMARK=no RVF=yes RVD=yes REDO=1 DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 DEBUG=ye TRACE=ye
//      val config = VexRiscvConfig(
//        plugins = List(
//          new IBusCachedPlugin(
//            prediction = DYNAMIC,
//            config = InstructionCacheConfig(
//              cacheSize = 4096,
//              bytePerLine =32,
//              wayCount = 1,
//              addressWidth = 32,
//              cpuDataWidth = 32,
//              memDataWidth = 32,
//              catchIllegalAccess = true,
//              catchAccessFault = true,
//              asyncTagMemory = false,
//              twoCycleRam = true,
//              twoCycleCache = true
//            ),
//            memoryTranslatorPortConfig = MmuPortConfig(
//              portTlbSize = 4
//            )
//          ),
//          new DBusCachedPlugin(
//            config = new DataCacheConfig(
//              cacheSize         = 4096,
//              bytePerLine       = 32,
//              wayCount          = 1,
//              addressWidth      = 32,
//              cpuDataWidth      = 64,
//              memDataWidth      = 64,
//              catchAccessError  = true,
//              catchIllegal      = true,
//              catchUnaligned    = true
//            ),
//            memoryTranslatorPortConfig = MmuPortConfig(
//              portTlbSize = 6
//            )
//          ),
//          new MmuPlugin(
//            virtualRange = _(31 downto 28) === 0xC,
//            ioRange      = _(31 downto 28) === 0xF
//          ),
//          new DecoderSimplePlugin(
//            catchIllegalInstruction = true
//          ),
//          new RegFilePlugin(
//            regFileReadyKind = plugin.SYNC,
//            zeroBoot = false
//          ),
//          new IntAluPlugin,
//          new SrcPlugin(
//            separatedAddSub = false,
//            executeInsertion = true
//          ),
//          new FullBarrelShifterPlugin,
//          new HazardSimplePlugin(
//            bypassExecute           = true,
//            bypassMemory            = true,
//            bypassWriteBack         = true,
//            bypassWriteBackBuffer   = true,
//            pessimisticUseSrc       = false,
//            pessimisticWriteRegFile = false,
//            pessimisticAddressMatch = false
//          ),
//          new MulPlugin,
//          new DivPlugin,
//          new CsrPlugin(CsrPluginConfig.small(0x80000020l)),
//          new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
//          new BranchPlugin(
//            earlyBranch = false,
//            catchAddressMisaligned = true
//          ),
//          new YamlPlugin("cpu0.yaml")
//        )
//      )
//      config.plugins += new FpuPlugin(
//        externalFpu = false,
//        p = FpuParameter(
//          withDouble = true
//        )
//      )

//       mkdir buildroot-build
//       cd buildroot-build/
//       make O=$PWD  BR2_EXTERNAL=../buildroot-spinal-saxon  -C ../buildroot saxon_regression_defconfig

      //make clean all IBUS=CACHED IBUS_DATA_WIDTH=64 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 LRSC=yes AMO=yes SUPERVISOR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes MUL=yes DIV=yes RVF=yes RVD=yes DEBUG_PLUGIN=no TRACE=yes REDO=1 DEBUG=ye WITH_USER_IO=no  FLOW_INFO=no TRACE_START=565000000000ll SEED=45

      //make clean all IBUS=CACHED IBUS_DATA_WIDTH=64 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 LRSC=yes AMO=yes SUPERVISOR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes MUL=yes DIV=yes RVF=yes RVD=yes DEBUG_PLUGIN=no TRACE=yes REDO=100 DEBUG=ye WITH_USER_IO=no  FLOW_INFO=no TRACE_START=5600000000000ll SEED=45 STOP_ON_ERROR=ye

      // export IMAGES=/media/data/open/SaxonSoc/artyA7SmpUpdate/buildroot-regression/buildroot-build/images
      // make clean all IBUS=CACHED IBUS_DATA_WIDTH=64 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 LRSC=yes AMO=yes SUPERVISOR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes MUL=yes DIV=yes RVF=yes RVD=yes DEBUG_PLUGIN=no LINUX_SOC_SMP=yes EMULATOR=$IMAGES/fw_jump.bin VMLINUX=$IMAGES/Image DTB=$IMAGES/linux.dtb RAMDISK=$IMAGES/rootfs.cpio  TRACE=yes REDO=1 DEBUG=ye WITH_USER_IO=no  FLOW_INFO=no TRACE_START=565000000000ll SEED=45
      // make clean all IBUS=CACHED IBUS_DATA_WIDTH=64 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 LRSC=yes AMO=yes SUPERVISOR=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes MUL=yes DIV=yes RVF=yes RVD=yes DEBUG_PLUGIN=no    RUN_HEX=/media/data/open/VexRiscv/src/test/cpp/raw/play/build/play.hex TRACE=yes
      val config = VexRiscvSmpClusterGen.vexRiscvConfig(
        hartId = 0,
        ioRange = _ (31 downto 28) === 0xF,
        resetVector = 0x80000000l,
        iBusWidth = 64,
        dBusWidth = 64,
        loadStoreWidth = 64,
        iCacheSize = 4096*2,
        dCacheSize = 4096*2,
        iCacheWays = 2,
        dCacheWays = 2,
        withFloat = true,
        withDouble = true,
        externalFpu = false,
        simHalt = true,
        privilegedDebug = false
      )

//      config.plugins += new EmbeddedRiscvJtag(
//        p = DebugTransportModuleParameter(
//          addressWidth = 7,
//          version      = 1,
//          idle         = 7
//        ),
//        debugCd = ClockDomain.current.copy(reset = Bool().setName("debugReset")),
//        withTunneling = false,
//        withTap = true
//      )

//      l.foreach{
//        case p : EmbeddedRiscvJtag => p.debugCd.load(ClockDomain.current.copy(reset = Bool().setName("debug_reset")))
//        case _ =>
//      }

      println("Args :")
      println(config.getRegressionArgs().mkString(" "))

      val toplevel = new VexRiscv(config)
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
