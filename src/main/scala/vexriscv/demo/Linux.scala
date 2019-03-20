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

object LinuxGen {
  def configFull(withMmu : Boolean = true) = {
    val config = VexRiscvConfig(
      plugins = List(
        new IBusSimplePlugin(
          resetVector = 0x80000000l,
          cmdForkOnSecondStage = false,
          cmdForkPersistence = false,
          prediction = NONE,
          historyRamSizeLog2 = 10,
          catchAccessFault = true,
          compressedGen = true,
          busLatencyMin = 1,
          injectorStage = true,
          memoryTranslatorPortConfig = withMmu generate MmuPortConfig(
            portTlbSize = 4
          )
        ),
        //          new IBusCachedPlugin(
        //            resetVector = 0x80000000l,
        //            compressedGen = false,
        //            prediction = NONE,
        //            injectorStage = true,
        //            config = InstructionCacheConfig(
        //              cacheSize = 4096,
        //              bytePerLine = 32,
        //              wayCount = 1,
        //              addressWidth = 32,
        //              cpuDataWidth = 32,
        //              memDataWidth = 32,
        //              catchIllegalAccess = true,
        //              catchAccessFault = true,
        //              catchMemoryTranslationMiss = true,
        //              asyncTagMemory = false,
        //              twoCycleRam = false,
        //              twoCycleCache = true
        //            ),
        //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
        //              portTlbSize = 4
        //            )
        //          ),
        //          ).newTightlyCoupledPort(TightlyCoupledPortParameter("iBusTc", a => a(30 downto 28) === 0x0 && a(5))),
        new DBusSimplePlugin(
          catchAddressMisaligned = true,
          catchAccessFault = true,
          earlyInjection = false,
          memoryTranslatorPortConfig = withMmu generate MmuPortConfig(
            portTlbSize = 4
          )
        ),
        //          new DBusCachedPlugin(
        //            config = new DataCacheConfig(
        //              cacheSize         = 4096,
        //              bytePerLine       = 32,
        //              wayCount          = 1,
        //              addressWidth      = 32,
        //              cpuDataWidth      = 32,
        //              memDataWidth      = 32,
        //              catchAccessError  = true,
        //              catchIllegal      = true,
        //              catchUnaligned    = true,
        //              catchMemoryTranslationMiss = true,
        //              atomicEntriesCount = 2
        //            ),
        //            //            memoryTranslatorPortConfig = null
        //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
        //              portTlbSize = 6
        //            )
        //          ),
        //          new StaticMemoryTranslatorPlugin(
        //            ioRange      = _(31 downto 28) === 0xF
        //          ),
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
        new CsrPlugin(CsrPluginConfig.linux(0x80000020l)),
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
    if(withMmu) config.plugins += new MmuPlugin(
      virtualRange = _(31 downto 28) === 0xC,
      ioRange = _(31 downto 28) === 0xF,
      allowUserIo = true
    )
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

    SpinalConfig(mergeAsyncProcess = true).generateVerilog {


      val toplevel = new VexRiscv(configFull())
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
    SpinalVerilog(new VexRiscv(LinuxGen.configFull(withMmu=false)).setDefinitionName(getRtlPath().split("\\.").head))
  }

  val withMmu = new Rtl {
    override def getName(): String = "VexRiscv With Mmu"
    override def getRtlPath(): String = "VexRiscvWithMmu.v"
    SpinalVerilog(new VexRiscv(LinuxGen.configFull(withMmu=true)).setDefinitionName(getRtlPath().split("\\.").head))
  }

  val rtls = List(withoutMmu, withMmu)
  //    val rtls = List(smallestNoCsr, smallest, smallAndProductive, smallAndProductiveWithICache)
  //      val rtls = List(smallAndProductive, smallAndProductiveWithICache, fullNoMmuMaxPerf, fullNoMmu, full)
  //    val rtls = List(fullNoMmu)

  val targets = XilinxStdTargets(
    vivadoArtix7Path = "/eda/Xilinx/Vivado/2017.2/bin"
  ) ++ AlteraStdTargets(
    quartusCycloneIVPath = "/eda/intelFPGA_lite/17.0/quartus/bin",
    quartusCycloneVPath  = "/eda/intelFPGA_lite/17.0/quartus/bin"
  ) ++  IcestormStdTargets().take(1)


  Bench(rtls, targets, "/eda/tmp")
}

object LinuxSim extends App{
  import spinal.core.sim._

  SimConfig.allOptimisation.compile(new VexRiscv(LinuxGen.configFull())).doSim{dut =>
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