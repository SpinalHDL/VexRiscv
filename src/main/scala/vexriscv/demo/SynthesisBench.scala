package vexriscv.demo

import spinal.core._
import spinal.lib._
import spinal.lib.com.jtag.Jtag
import spinal.lib.cpu.riscv.debug.DebugTransportModuleParameter
import spinal.lib.eda.bench._
import spinal.lib.eda.icestorm.IcestormStdTargets
import spinal.lib.eda.xilinx.VivadoFlow
import spinal.lib.io.InOutWrapper
import vexriscv.demo.smp.VexRiscvSmpClusterGen
import vexriscv.plugin.CsrAccess.{READ_ONLY, READ_WRITE, WRITE_ONLY}
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}
import vexriscv.plugin.{BranchPlugin, CsrPlugin, CsrPluginConfig, DBusSimplePlugin, DebugPlugin, DecoderSimplePlugin, EmbeddedRiscvJtag, FullBarrelShifterPlugin, HazardSimplePlugin, IBusSimplePlugin, IntAluPlugin, LightShifterPlugin, NONE, Plugin, RegFilePlugin, SrcPlugin, YamlPlugin}

import scala.collection.mutable.ArrayBuffer
import scala.util.Random

/**
 * Created by PIC32F_USER on 16/07/2017.
 */
object VexRiscvSynthesisBench {
  def main(args: Array[String]) {

    def wrap(that : => Component) : Component = that
//    def wrap(that : => Component) : Component = {
//      val c = that
//      c.getAllIo.foreach(io => KeepAttribute(io.asDirectionLess()))
//      c
//    }
//    Wrap with input/output registers
//        def wrap(that : => Component) : Component = {
//          //new WrapWithReg.Wrapper(that)
//          val c = that
//          c.rework {
//            for (e <- c.getOrdredNodeIo) {
//              if (e.isInput) {
//                e.asDirectionLess()
//                e := RegNext(RegNext(in(cloneOf(e))))
//
//              } else {
//                e.asDirectionLess()
//                out(cloneOf(e)) := RegNext(RegNext(e))
//              }
//            }
//          }
//          c
//        }

   // Wrap to do a decoding bench
//    def wrap(that : => VexRiscv) : VexRiscv = {
//      val top = that
//      top.service(classOf[DecoderSimplePlugin]).bench(top)
//      top
//    }

    val twoStage = new Rtl {
      override def getName(): String = "VexRiscv two stages"
      override def getRtlPath(): String = "VexRiscvTwoStages.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = false,
        bypass = false,
        barrielShifter = false,
        withMemoryStage = false
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val twoStageBarell = new Rtl {
      override def getName(): String = "VexRiscv two stages with barriel"
      override def getRtlPath(): String = "VexRiscvTwoStagesBar.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = false,
        bypass = true,
        barrielShifter = true,
        withMemoryStage = false
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val twoStageMulDiv = new Rtl {
      override def getName(): String = "VexRiscv two stages with Mul Div"
      override def getRtlPath(): String = "VexRiscvTwoStagesMD.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = true,
        bypass = false,
        barrielShifter = false,
        withMemoryStage = false
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val twoStageAll = new Rtl {
      override def getName(): String = "VexRiscv two stages with Mul Div fast"
      override def getRtlPath(): String = "VexRiscvTwoStagesMDfast.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = true,
        bypass = true,
        barrielShifter = true,
        withMemoryStage = false
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }


    val threeStage = new Rtl {
      override def getName(): String = "VexRiscv three stages"
      override def getRtlPath(): String = "VexRiscvThreeStages.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = false,
        bypass = false,
        barrielShifter = false,
        withMemoryStage = true
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val threeStageBarell = new Rtl {
      override def getName(): String = "VexRiscv three stages with barriel"
      override def getRtlPath(): String = "VexRiscvThreeStagesBar.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = false,
        bypass = true,
        barrielShifter = true,
        withMemoryStage = true
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val threeStageMulDiv = new Rtl {
      override def getName(): String = "VexRiscv three stages with Mul Div"
      override def getRtlPath(): String = "VexRiscvThreeStagesMD.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = true,
        bypass = false,
        barrielShifter = false,
        withMemoryStage = true
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val threeStageAll = new Rtl {
      override def getName(): String = "VexRiscv three stages with Mul Div fast"
      override def getRtlPath(): String = "VexRiscvThreeStagesMDfast.v"
      SpinalVerilog(wrap(GenTwoThreeStage.cpu(
        withMulDiv = true,
        bypass = true,
        barrielShifter = true,
        withMemoryStage = true
      )).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val smallestNoCsr = new Rtl {
      override def getName(): String = "VexRiscv smallest no CSR"
      override def getRtlPath(): String = "VexRiscvSmallestNoCsr.v"
      SpinalVerilog(wrap(GenSmallestNoCsr.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val smallest = new Rtl {
      override def getName(): String = "VexRiscv smallest"
      override def getRtlPath(): String = "VexRiscvSmallest.v"
      SpinalVerilog(wrap(GenSmallest.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val smallAndProductive = new Rtl {
      override def getName(): String = "VexRiscv small and productive"
      override def getRtlPath(): String = "VexRiscvSmallAndProductive.v"
      SpinalVerilog(wrap(GenSmallAndProductive.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val smallAndProductiveWithICache = new Rtl {
      override def getName(): String = "VexRiscv small and productive with instruction cache"
      override def getRtlPath(): String = "VexRiscvSmallAndProductiveICache.v"
      SpinalVerilog(wrap(GenSmallAndProductiveICache.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val fullNoMmuNoCache = new Rtl {
      override def getName(): String = "VexRiscv full no MMU no cache"
      override def getRtlPath(): String = "VexRiscvFullNoMmuNoCache.v"
      SpinalVerilog(wrap(GenFullNoMmuNoCache.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }
    val fullNoMmu = new Rtl {
      override def getName(): String = "VexRiscv full no MMU"
      override def getRtlPath(): String = "VexRiscvFullNoMmu.v"
      SpinalVerilog(wrap(GenFullNoMmu.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val noCacheNoMmuMaxPerf= new Rtl {
      override def getName(): String = "VexRiscv no cache no MMU max perf"
      override def getRtlPath(): String = "VexRiscvNoCacheNoMmuMaxPerf.v"
      SpinalVerilog(wrap(GenNoCacheNoMmuMaxPerf.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val fullNoMmuMaxPerf= new Rtl {
      override def getName(): String = "VexRiscv full no MMU max perf"
      override def getRtlPath(): String = "VexRiscvFullNoMmuMaxPerf.v"
      SpinalVerilog(wrap(GenFullNoMmuMaxPerf.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val full = new Rtl {
      override def getName(): String = "VexRiscv full with MMU"
      override def getRtlPath(): String = "VexRiscvFull.v"
      SpinalVerilog(wrap(GenFull.cpu()).setDefinitionName(getRtlPath().split("\\.").head))
    }


    val linuxBalanced = new Rtl {
      override def getName(): String = "VexRiscv linux balanced"
      override def getRtlPath(): String = "VexRiscvLinuxBalanced.v"
      SpinalConfig(inlineRom = true).generateVerilog(wrap(new VexRiscv(LinuxGen.configFull(false, true))).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val linuxBalancedSmp = new Rtl {
      override def getName(): String = "VexRiscv linux balanced SMP"
      override def getRtlPath(): String = "VexRiscvLinuxBalancedSmp.v"
      SpinalConfig(inlineRom = true).generateVerilog(wrap(new VexRiscv(LinuxGen.configFull(false, true, withSmp = true))).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val linuxFpuSmp = new Rtl {
      override def getName(): String = "VexRiscv linux Fpu SMP"
      override def getRtlPath(): String = "VexRiscvLinuxFpuSmp.v"
      SpinalConfig(inlineRom = true).generateVerilog(wrap(new VexRiscv(
        VexRiscvSmpClusterGen.vexRiscvConfig(
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
        simHalt = true
      ))).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val linuxFpuSmpNoDecoder = new Rtl {
      override def getName(): String = "VexRiscv linux Fpu SMP without decoder"
      override def getRtlPath(): String = "VexRiscvLinuxFpuSmpNoDecoder.v"
      SpinalConfig(inlineRom = true).generateVerilog(wrap(new VexRiscv(
        VexRiscvSmpClusterGen.vexRiscvConfig(
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
          decoderIsolationBench = true
        ))).setDefinitionName(getRtlPath().split("\\.").head))
    }

    val linuxFpuSmpStupidDecoder = new Rtl {
      override def getName(): String = "VexRiscv linux Fpu SMP stupid decoder"
      override def getRtlPath(): String = "VexRiscvLinuxFpuSmpStupidDecoder.v"
      SpinalConfig(inlineRom = true).generateVerilog(wrap(new VexRiscv(
        VexRiscvSmpClusterGen.vexRiscvConfig(
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
          decoderStupid = true
        ))).setDefinitionName(getRtlPath().split("\\.").head))
    }



    val rtls = List(
//      linuxFpuSmp, linuxFpuSmpNoDecoder, linuxFpuSmpStupidDecoder
      twoStage, twoStageBarell, twoStageMulDiv, twoStageAll,
      threeStage, threeStageBarell, threeStageMulDiv, threeStageAll,
      smallestNoCsr, smallest, smallAndProductive, smallAndProductiveWithICache, fullNoMmuNoCache, noCacheNoMmuMaxPerf, fullNoMmuMaxPerf, fullNoMmu, full, linuxBalanced, linuxBalancedSmp
    )
//    val rtls = List(linuxBalanced, linuxBalancedSmp)
//    val rtls = List(smallest)
    val targets = XilinxStdTargets() ++ AlteraStdTargets() ++  IcestormStdTargets().take(1)  ++ List(
      new Target {
        override def getFamilyName(): String = "Kintex UltraScale"
        override def synthesise(rtl: Rtl, workspace: String): Report = {
          VivadoFlow(
            frequencyTarget = 50 MHz,
            vivadoPath=sys.env.getOrElse("VIVADO_ARTIX_7_BIN", null),
            workspacePath=workspace + "_area",
            rtl=rtl,
            family=getFamilyName(),
            device="xcku035-fbva900-3-e"
          )
        }
      },
      new Target {
        override def getFamilyName(): String = "Kintex UltraScale"
        override def synthesise(rtl: Rtl, workspace: String): Report = {
          VivadoFlow(
            frequencyTarget = 800 MHz,
            vivadoPath=sys.env.getOrElse("VIVADO_ARTIX_7_BIN", null),
            workspacePath=workspace + "_fmax",
            rtl=rtl,
            family=getFamilyName(),
            device="xcku035-fbva900-3-e"
          )
        }
      },
      new Target {
        override def getFamilyName(): String = "Kintex UltraScale+"
        override def synthesise(rtl: Rtl, workspace: String): Report = {
          VivadoFlow(
            frequencyTarget = 50 MHz,
            vivadoPath=sys.env.getOrElse("VIVADO_ARTIX_7_BIN", null),
            workspacePath=workspace + "_area",
            rtl=rtl,
            family=getFamilyName(),
            device="xcku3p-ffvd900-3-e"
          )
        }
      },
      new Target {
        override def getFamilyName(): String = "Kintex UltraScale+"
        override def synthesise(rtl: Rtl, workspace: String): Report = {
          VivadoFlow(
            frequencyTarget = 800 MHz,
            vivadoPath=sys.env.getOrElse("VIVADO_ARTIX_7_BIN", null),
            workspacePath=workspace + "_fmax",
            rtl=rtl,
            family=getFamilyName(),
            device="xcku3p-ffvd900-3-e"
          )
        }
      }
    )
    //    val targets = IcestormStdTargets()
    Bench(rtls, targets)
  }
}


object BrieySynthesisBench {
  def main(args: Array[String]) {
    val briey = new Rtl {
      override def getName(): String = "Briey"
      override def getRtlPath(): String = "Briey.v"
      SpinalVerilog({
        val briey = InOutWrapper(new Briey(BrieyConfig.default).setDefinitionName(getRtlPath().split("\\.").head))
        briey.io.axiClk.setName("clk")
        briey
      })
    }


    val rtls = List(briey)

    val targets = XilinxStdTargets() ++ AlteraStdTargets() ++ IcestormStdTargets().take(1)

    Bench(rtls, targets)
  }
}




object MuraxSynthesisBench {
  def main(args: Array[String]) {
    val murax = new Rtl {
      override def getName(): String = "Murax"
      override def getRtlPath(): String = "Murax.v"
      SpinalVerilog({
        val murax = InOutWrapper(new Murax(MuraxConfig.default.copy(gpioWidth = 8)).setDefinitionName(getRtlPath().split("\\.").head))
        murax.io.mainClk.setName("clk")
        murax
      })
    }


    val muraxFast = new Rtl {
      override def getName(): String = "MuraxFast"
      override def getRtlPath(): String = "MuraxFast.v"
      SpinalVerilog({
        val murax = InOutWrapper(new Murax(MuraxConfig.fast.copy(gpioWidth = 8)).setDefinitionName(getRtlPath().split("\\.").head))
        murax.io.mainClk.setName("clk")
        murax
      })
    }

    val rtls = List(murax, muraxFast)

    val targets = XilinxStdTargets() ++ AlteraStdTargets() ++  IcestormStdTargets().take(1)

    Bench(rtls, targets)
  }
}

object AllSynthesisBench {
  def main(args: Array[String]): Unit = {
    VexRiscvSynthesisBench.main(args)
    BrieySynthesisBench.main(args)
    MuraxSynthesisBench.main(args)

  }
}



object VexRiscvCustomSynthesisBench {
  def main(args: Array[String]) {


    def gen(csr : CsrPlugin, p : Plugin[VexRiscv]) = {
      val cpu = new VexRiscv(
        config = VexRiscvConfig(
          plugins = List(
            p,
            new IBusSimplePlugin(
              resetVector = 0x80000000l,
              cmdForkOnSecondStage = false,
              cmdForkPersistence = false,
              prediction = NONE,
              catchAccessFault = false,
              compressedGen = false
            ),
            new DBusSimplePlugin(
              catchAddressMisaligned = false,
              catchAccessFault = false
            ),
            new DecoderSimplePlugin(
              catchIllegalInstruction = false
            ),
            new RegFilePlugin(
              regFileReadyKind = plugin.SYNC,
              zeroBoot = false
            ),
            new IntAluPlugin,
            new SrcPlugin(
              separatedAddSub = false,
              executeInsertion = true
            ),
            csr,
            new FullBarrelShifterPlugin(),
            new HazardSimplePlugin(
              bypassExecute           = true,
              bypassMemory            = true,
              bypassWriteBack         = true,
              bypassWriteBackBuffer   = true,
              pessimisticUseSrc       = false,
              pessimisticWriteRegFile = false,
              pessimisticAddressMatch = false
            ),
            new BranchPlugin(
              earlyBranch = false,
              catchAddressMisaligned = false
            ),
            new YamlPlugin("cpu0.yaml")
          )
        )
      )
      cpu.rework {
        for (plugin <- cpu.config.plugins) plugin match {
          case plugin: DebugPlugin => plugin.debugClockDomain {
            plugin.io.bus.setAsDirectionLess()
            val jtag = slave(new Jtag())
              .setName("jtag")
            jtag <> plugin.io.bus.fromJtag()
          }
          case _ =>
        }
      }
      cpu
    }

    
    val vexDebug = new Rtl {
      override def getName(): String = "vexDebug"
      override def getRtlPath(): String = "vexDebug.v"
      SpinalVerilog(gen(new CsrPlugin(CsrPluginConfig.smallest(0x80000000l)),
        new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset")))
      ).setDefinitionName(getRtlPath().split("\\.").head))
    }


    //    val rtls = List(twoStage, twoStageBarell, twoStageMulDiv, twoStageAll, smallestNoCsr, smallest, smallAndProductive, smallAndProductiveWithICache, fullNoMmuNoCache, noCacheNoMmuMaxPerf, fullNoMmuMaxPerf, fullNoMmu, full, linuxBalanced, linuxBalancedSmp)
    val rtls = List(vexDebug)
    //    val rtls = List(smallest)
    val targets = XilinxStdTargets() ++ AlteraStdTargets() ++  IcestormStdTargets().take(1)

    //    val targets = IcestormStdTargets()
    Bench(rtls, targets)
  }
}