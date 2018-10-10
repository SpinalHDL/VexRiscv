package vexriscv.experimental

import spinal.core._
import spinal.lib.eda.bench.{AlteraStdTargets, Bench, Rtl, XilinxStdTargets}
import spinal.lib.eda.icestorm.IcestormStdTargets
import vexriscv.demo.{GenSmallestNoCsr, Murax, MuraxConfig}
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/**
 * Created by spinalvm on 15.06.17.
 */
object GenMicro extends App{
  def cpu() = {
    val removeOneFetchStage = true
    val writeBackOpt = true
    val onlyLoadWords = false
    val rspHoldValue = true
    val earlyBranch = false
    val noShifter = false
    val pessimisticHazard = true
    new VexRiscv(
      config = VexRiscvConfig(
        plugins = List(
          //        new PcManagerSimplePlugin(
          //          resetVector = 0x00000000l,
          //          relaxedPcCalculation = false
          //        ),

          new IBusSimplePlugin(
            resetVector = 0x80000000l,
            cmdForkOnSecondStage = false,
            cmdForkPersistence = false,
            prediction = NONE,
            catchAccessFault = false,
            compressedGen = false,
            injectorStage = !removeOneFetchStage,
            rspHoldValue = rspHoldValue
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false,
            earlyInjection = writeBackOpt,
            onlyLoadWords = onlyLoadWords
          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = false
          ),
          new RegFilePlugin(
            regFileReadyKind = plugin.SYNC,
            zeroBoot = false,
            readInExecute = removeOneFetchStage,
            writeRfInMemoryStage = writeBackOpt
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false,
            executeInsertion = removeOneFetchStage
          ),
          if(!pessimisticHazard)
            new HazardSimplePlugin(
              bypassExecute = false,
              bypassMemory = false,
              bypassWriteBack = false,
              bypassWriteBackBuffer = false,
              pessimisticUseSrc = false,
              pessimisticWriteRegFile = false,
              pessimisticAddressMatch = false
            )
          else
            new HazardPessimisticPlugin(),
          new BranchPlugin(
            earlyBranch = earlyBranch,
            catchAddressMisaligned = false
          ),
          new YamlPlugin("cpu0.yaml")
        ) ++ (if(noShifter) Nil else List(new LightShifterPlugin))
      )
    )
  }
  SpinalConfig(mergeAsyncProcess = false).generateVerilog(cpu())
}



object GenMicroSynthesis {
  def main(args: Array[String]) {
    val microNoCsr = new Rtl {
      override def getName(): String = "MicroNoCsr"
      override def getRtlPath(): String = "MicroNoCsr.v"
      SpinalVerilog(GenMicro.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val smallestNoCsr = new Rtl {
      override def getName(): String = "SmallestNoCsr"
      override def getRtlPath(): String = "SmallestNoCsr.v"
      SpinalVerilog(GenSmallestNoCsr.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val rtls = List(microNoCsr)
//    val rtls = List(smallestNoCsr)

    val targets = IcestormStdTargets().take(1) ++ XilinxStdTargets(
      vivadoArtix7Path = "/eda/Xilinx/Vivado/2017.2/bin"
    ) ++ AlteraStdTargets(
      quartusCycloneIVPath = "/eda/intelFPGA_lite/17.0/quartus/bin/",
      quartusCycloneVPath  = "/eda/intelFPGA_lite/17.0/quartus/bin/"
    )


    Bench(rtls, targets, "/eda/tmp/")
  }
}