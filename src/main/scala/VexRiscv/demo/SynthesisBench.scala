package VexRiscv.demo

import spinal.core.SpinalVerilog
import spinal.lib.eda.bench.{Bench, AlteraStdTargets, Rtl}

/**
 * Created by PIC32F_USER on 16/07/2017.
 */
object SynthesisBench {
  def main(args: Array[String]) {
    val smallestNoCsr = new Rtl {
      override def getName(): String = "VexRiscv smallest no CSR"
      override def getRtlPath(): String = "VexRiscvSmallestNoCsr.v"
      SpinalVerilog(GenSmallestNoCsr.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val smallest = new Rtl {
      override def getName(): String = "VexRiscv smallest"
      override def getRtlPath(): String = "VexRiscvSmallest.v"
      SpinalVerilog(GenSmallest.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val fullNoMmu = new Rtl {
      override def getName(): String = "VexRiscv full no MMU"
      override def getRtlPath(): String = "VexRiscvFullNoMmu.v"
      SpinalVerilog(GenFullNoMmu.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val full = new Rtl {
      override def getName(): String = "VexRiscv full"
      override def getRtlPath(): String = "VexRiscvFull.v"
      SpinalVerilog(GenFull.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val rtls = List(smallestNoCsr, smallest, fullNoMmu, full)

    val targets = AlteraStdTargets(
      quartusCycloneIIPath = "D:/altera/13.0sp1/quartus/bin64",
      quartusCycloneIVPath = "D:/altera_lite/15.1/quartus/bin64",
      quartusCycloneVPath  = "D:/altera_lite/15.1/quartus/bin64"
    )

    Bench(rtls, targets, "E:/tmp/")
  }
}
