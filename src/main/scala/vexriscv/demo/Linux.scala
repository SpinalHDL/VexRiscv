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

package vexriscv.demo

import spinal.core._
import spinal.lib.eda.bench.{AlteraStdTargets, Bench, Rtl, XilinxStdTargets}
import spinal.lib.eda.icestorm.IcestormStdTargets
import spinal.lib.master
import vexriscv._
import vexriscv.ip._
import vexriscv.plugin._

/*
prerequired stuff =>
- JAVA JDK >= 8
- SBT
- Verilator

Setup things =>
git clone https://github.com/SpinalHDL/SpinalHDL.git -b dev
git clone https://github.com/SpinalHDL/VexRiscv.git -b linux
cd VexRiscv

Run regressions =>
sbt "runMain vexriscv.demo.LinuxGen -r"
cd src/test/cpp/regression
make clean run  IBUS=CACHED DBUS=CACHED DEBUG_PLUGIN=STD DHRYSTONE=yes SUPERVISOR=yes MMU=yes CSR=yes DEBUG_PLUGIN=no COMPRESSED=no MUL=yes DIV=yes LRSC=yes AMO=yes REDO=10 TRACE=no COREMARK=yes LINUX_REGRESSION=yes

Run linux in simulation (Require the machine mode emulator compiled in SIM mode) =>
sbt "runMain vexriscv.demo.LinuxGen"
cd src/test/cpp/regression
export BUILDROOT=/home/miaou/pro/riscv/buildrootSpinal
make clean run IBUS=CACHED DBUS=CACHED  DEBUG_PLUGIN=STD SUPERVISOR=yes CSR=yes DEBUG_PLUGIN=no  COMPRESSED=no LRSC=yes AMO=yes REDO=0 DHRYSTONE=no LINUX_SOC=yes EMULATOR=../../../main/c/emulator/build/emulator.bin VMLINUX=$BUILDROOT/output/images/Image DTB=$BUILDROOT/board/spinal/vexriscv_sim/rv32.dtb RAMDISK=$BUILDROOT/output/images/rootfs.cpio WITH_USER_IO=yes TRACE=no FLOW_INFO=no

Run linux with QEMU (Require the machine mode emulator compiled in QEMU mode)
export BUILDROOT=/home/miaou/pro/riscv/buildrootSpinal
qemu-system-riscv32 -nographic -machine virt -m 1536M -device loader,file=src/main/c/emulator/build/emulator.bin,addr=0x80000000,cpu-num=0 -device loader,file=$BUILDROOT/board/spinal/vexriscv_sim/rv32.dtb,addr=0xC3000000 -device loader,file=$BUILDROOT/output/images/Image,addr=0xC0000000  -device loader,file=$BUILDROOT/output/images/rootfs.cpio,addr=0xc2000000


Buildroot =>
git clone https://github.com/SpinalHDL/buildroot.git -b vexriscv
cd buildroot
make spinal_vexriscv_sim_defconfig
make -j$(nproc)
output/host/bin/riscv32-linux-objcopy  -O binary output/images/vmlinux output/images/Image

After changing a kernel config into buildroot =>
cd buildroot
make spinal_vexriscv_sim_defconfig
make linux-dirclean linux-rebuild -j8
output/host/bin/riscv32-linux-objcopy  -O binary output/images/vmlinux output/images/Image

Compiling the machine mode emulator (check the config.h file to know the mode) =>
cd src/main/c/emulator
make clean all

Changing the emulator mode =>
Edit the src/main/c/emulator/src/config.h file, and comment/uncomment the SIM/QEMU flags

Other commands (Memo):
decompile file and split it
riscv64-unknown-elf-objdump -S -d vmlinux > vmlinux.asm; split -b 1M vmlinux.asm

Kernel compilation command =>
ARCH=riscv CROSS_COMPILE=riscv32-unknown-linux-gnu- make menuconfig
ARCH=riscv CROSS_COMPILE=riscv32-unknown-linux-gnu- make -j`nproc`; riscv32-unknown-linux-gnu-objcopy  -O binary vmlinux vmlinux.bin

Generate a DTB from a DTS =>
dtc -O dtb -o rv32.dtb rv32.dts

https://github.com/riscv/riscv-qemu/wiki#build-and-install


memo :
export DATA=/home/miaou/Downloads/Binaries-master
cd src/test/cpp/regression
rm VexRiscv.v
cp $DATA/VexRiscv.v ../../../..
make run IBUS=CACHED DBUS=CACHED  DEBUG_PLUGIN=STD SUPERVISOR=yes CSR=yes COMPRESSED=no LRSC=yes AMO=yes REDO=0 DHRYSTONE=no LINUX_SOC=yes EMULATOR=$DATA/emulator.bin VMLINUX=$DATA/vmlinux.bin DTB=$DATA/rv32.dtb RAMDISK=$DATA/rootfs.cpio TRACE=no FLOW_INFO=no

make clean run  IBUS=CACHED DBUS=CACHED DEBUG_PLUGIN=STD DHRYSTONE=no SUPERVISOR=yes CSR=yes COMPRESSED=no MUL=yes DIV=yes LRSC=yes AMO=yes MMU=yes  REDO=1 TRACE=no LINUX_REGRESSION=yes

qemu-system-riscv32 -nographic -machine virt -m 1536M -device loader,file=$DATA/emulator.bin,addr=0x80000000,cpu-num=0 -device loader,file=$DATA/rv32.dtb,addr=0xC3000000 -device loader,file=$DATA/vmlinux.bin,addr=0xC0000000  -device loader,file=$DATA/rootfs.cpio,addr=0xc2000000


make run  IBUS=CACHED DBUS=CACHED DEBUG_PLUGIN=STD DHRYSTONE=yess SUPERVISOR=yes CSR=yes COMPRESSED=yes MUL=yes DIV=yes LRSC=yes AMO=yes REDO=1 TRACE=no LINUX_REGRESSION=yes

program ../../../main/c/emulator/build/emulator.bin  0x80000000 verify
		soc.loadBin(EMULATOR, 0x80000000);
		soc.loadBin(VMLINUX,  0xC0000000);
		soc.loadBin(DTB,      0xC3000000);
		soc.loadBin(RAMDISK,  0xC2000000);

export BUILDROOT=/home/miaou/pro/riscv/buildrootSpinal
make run IBUS=CACHED DBUS=CACHED  DEBUG_PLUGIN=STD SUPERVISOR=yes CSR=yes COMPRESSED=no LRSC=yes AMO=yes REDO=0 DHRYSTONE=no LINUX_SOC=yes
EMULATOR=../../../main/c/emulator/build/emulator.bin
VMLINUX=/home/miaou/pro/riscv/buildrootSpinal/output/images/Image
DTB=/home/miaou/pro/riscv/buildrootSpinal/board/spinal/vexriscv_sim/rv32.dtb
RAMDISK=/home/miaou/pro/riscv/buildrootSpinal/output/images/rootfs.cpio TRACE=no FLOW_INFO=no

make run IBUS=CACHED DBUS=CACHED  DEBUG_PLUGIN=STD SUPERVISOR=yes CSR=yes COMPRESSED=no LRSC=yes AMO=yes REDO=0 DHRYSTONE=no LINUX_SOC=yes DEBUG_PLUGIN_EXTERNAL=yes

rm -rf cpio
mkdir cpio
cd cpio
sudo cpio -i < ../rootfs.cpio
cd ..

rm rootfs.cpio
cd cpio
sudo find | sudo cpio -H newc -o > ../rootfs.cpio
cd ..

make clean run  IBUS=CACHED DBUS=CACHED DEBUG_PLUGIN=STD DHRYSTONE=yes SUPERVISOR=yes MMU=yes CSR=yes COMPRESSED=no MUL=yes DIV=yes LRSC=yes AMO=yes REDO=10 TRACE=no COREMARK=yes LINUX_REGRESSION=yes RUN_HEX=~/pro/riscv/zephyr/samples/synchronization/build/zephyr/zephyr.hex


*/


object LinuxGen {
  def configFull(litex : Boolean, withMmu : Boolean, withSmp : Boolean = false) = {
    val config = VexRiscvConfig(
      plugins = List(
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
            cacheSize = 4096*1,
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
//          )
          ),
          memoryTranslatorPortConfig = withMmu generate MmuPortConfig(
            portTlbSize = 4
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
            bytePerLine       = 32,
            wayCount          = 1,
            addressWidth      = 32,
            cpuDataWidth      = 32,
            memDataWidth      = 32,
            catchAccessError  = true,
            catchIllegal      = true,
            catchUnaligned    = true,
            withExclusive = withSmp,
            withInvalidate = withSmp,
            withLrSc = true,
            withAmo = true
//          )
          ),
          memoryTranslatorPortConfig = withMmu generate MmuPortConfig(
            portTlbSize = 4
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
          regFileReadyKind = plugin.SYNC,
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
        new CsrPlugin(CsrPluginConfig.linuxMinimal(0x80000020l).copy(ebreakGen = false)),
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
    if(withMmu) config.plugins += new MmuPlugin(
      ioRange = (x => if(litex) x(31 downto 28) === 0xB || x(31 downto 28) === 0xE || x(31 downto 28) === 0xF else x(31 downto 28) === 0xF)
    ) else {
      config.plugins += new StaticMemoryTranslatorPlugin(
        ioRange      = _(31 downto 28) === 0xF
      )
    }
    config
  }



  def main(args: Array[String]) {
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

    SpinalConfig(mergeAsyncProcess = false, anonymSignalPrefix = "_zz").generateVerilog {


      val toplevel = new VexRiscv(configFull(
        litex = !args.contains("-r"),
        withMmu = true
      ))
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


//      toplevel.rework {
//        for (plugin <- toplevel.config.plugins) plugin match {
//          case plugin: IBusSimplePlugin => {
//            plugin.iBus.setAsDirectionLess().unsetName() //Unset IO properties of iBus
//            val iBus = master(IBusSimpleBus()).setName("iBus")
//
//            iBus.cmd << plugin.iBus.cmd.halfPipe()
//            iBus.rsp.stage >> plugin.iBus.rsp
//          }
//          case plugin: DBusSimplePlugin => {
//            plugin.dBus.setAsDirectionLess().unsetName()
//            val dBus = master(DBusSimpleBus()).setName("dBus")
//            val pending = RegInit(False) setWhen(plugin.dBus.cmd.fire) clearWhen(plugin.dBus.rsp.ready)
//            dBus.cmd << plugin.dBus.cmd.haltWhen(pending).halfPipe()
//            plugin.dBus.rsp := RegNext(dBus.rsp)
//            plugin.dBus.rsp.ready clearWhen(!pending)
//          }
//
//          case _ =>
//        }
//      }

      toplevel
    }
  }
}

object LinuxSyntesisBench extends App{
  val withoutMmu = new Rtl {
    override def getName(): String = "VexRiscv Without Mmu"
    override def getRtlPath(): String = "VexRiscvWithoutMmu.v"
    SpinalConfig(inlineRom=true).generateVerilog(new VexRiscv(LinuxGen.configFull(litex = false, withMmu = false)).setDefinitionName(getRtlPath().split("\\.").head))
  }

  val withMmu = new Rtl {
    override def getName(): String = "VexRiscv With Mmu"
    override def getRtlPath(): String = "VexRiscvWithMmu.v"
    SpinalConfig(inlineRom=true).generateVerilog(new VexRiscv(LinuxGen.configFull(litex = false, withMmu = true)).setDefinitionName(getRtlPath().split("\\.").head))
  }

  val rtls = List(withoutMmu,withMmu)
  //    val rtls = List(smallestNoCsr, smallest, smallAndProductive, smallAndProductiveWithICache)
  //      val rtls = List(smallAndProductive, smallAndProductiveWithICache, fullNoMmuMaxPerf, fullNoMmu, full)
  //    val rtls = List(fullNoMmu)

  val targets = XilinxStdTargets(
    vivadoArtix7Path = "/media/miaou/HD/linux/Xilinx/Vivado/2018.3/bin"
  ) ++ AlteraStdTargets(
    quartusCycloneIVPath = "/media/miaou/HD/linux/intelFPGA_lite/18.1/quartus/bin",
    quartusCycloneVPath  = "/media/miaou/HD/linux/intelFPGA_lite/18.1/quartus/bin"
  ) //++  IcestormStdTargets().take(1)

  Bench(rtls, targets, "/media/miaou/HD/linux/tmp")
}

object LinuxSim extends App{
  import spinal.core.sim._

  SimConfig.allOptimisation.compile(new VexRiscv(LinuxGen.configFull(litex = false, withMmu = true))).doSim{dut =>
//    dut.clockDomain.forkStimulus(10)
//    dut.clockDomain.forkSimSpeedPrinter()
//    dut.plugins.foreach{
//      case p : IBusSimplePlugin => dut.clockDomain.onRisingEdges{
//        p.iBus.cmd.ready #= ! p.iBus.cmd.ready.toBoolean
////        p.iBus.rsp.valid.randomize()
////        p.iBus.rsp.inst.randomize()
////        p.iBus.rsp.error.randomize()
//      }
//      case p : DBusSimplePlugin => dut.clockDomain.onRisingEdges{
//          p.dBus.cmd.ready #= ! p.dBus.cmd.ready.toBoolean
////        p.dBus.cmd.ready.randomize()
////        p.dBus.rsp.ready.randomize()
////        p.dBus.rsp.data.randomize()
////        p.dBus.rsp.error.randomize()
//      }
//      case _ =>
//    }
//    sleep(10*10000000)


    var cycleCounter = 0l
    var lastTime = System.nanoTime()




    var iBus : IBusSimpleBus = null
    var dBus : DBusSimpleBus = null
    dut.plugins.foreach{
      case p : IBusSimplePlugin =>
        iBus = p.iBus
//        p.iBus.rsp.valid.randomize()
//        p.iBus.rsp.inst.randomize()
//        p.iBus.rsp.error.randomize()
      case p : DBusSimplePlugin =>
        dBus = p.dBus
//        p.dBus.cmd.ready.randomize()
//        p.dBus.rsp.ready.randomize()
//        p.dBus.rsp.data.randomize()
//        p.dBus.rsp.error.randomize()
      case _ =>
    }

    dut.clockDomain.resetSim #= false
    dut.clockDomain.clockSim #= false
    sleep(1)
    dut.clockDomain.resetSim #= true
    sleep(1)

    def f(): Unit ={
      cycleCounter += 1

      if((cycleCounter & 8191) == 0){
        val currentTime = System.nanoTime()
        val deltaTime = (currentTime - lastTime)*1e-9
        if(deltaTime > 2.0) {
          println(f"[Info] Simulation speed : ${cycleCounter / deltaTime * 1e-3}%4.0f kcycles/s")
          lastTime = currentTime
          cycleCounter = 0
        }
      }
      dut.clockDomain.clockSim #= false
      iBus.cmd.ready #= ! iBus.cmd.ready.toBoolean
      dBus.cmd.ready #= ! dBus.cmd.ready.toBoolean
      delayed(1)(f2)
    }
    def f2(): Unit ={
      dut.clockDomain.clockSim #= true
      delayed(1)(f)
    }

    delayed(1)(f)

    sleep(100000000)
  }
}