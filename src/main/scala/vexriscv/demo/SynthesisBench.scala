package vexriscv.demo

import spinal.core.SpinalVerilog
import spinal.lib.eda.bench.{XilinxStdTargets, Bench, AlteraStdTargets, Rtl}

/**
 * Created by PIC32F_USER on 16/07/2017.
 */
object VexRiscvSynthesisBench {
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

    val smallAndProductive = new Rtl {
      override def getName(): String = "VexRiscv small and productive"
      override def getRtlPath(): String = "VexRiscvSmallAndProductive.v"
      SpinalVerilog(GenSmallAndProductive.cpu().setDefinitionName(getRtlPath().split("\\.").head))
    }

    val fullNoMmuNoCache = new Rtl {
      override def getName(): String = "VexRiscv full no MMU no cache"
      override def getRtlPath(): String = "VexRiscvFullNoMmuNoCache.v"
      SpinalVerilog(GenFullNoMmuNoCache.cpu().setDefinitionName(getRtlPath().split("\\.").head))
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

    val rtls = List(smallestNoCsr, smallest, smallAndProductive, fullNoMmuNoCache, fullNoMmu, full)

    val targets = XilinxStdTargets(
      vivadoArtix7Path = "E:\\Xilinx\\Vivado\\2016.3\\bin"
    ) ++ AlteraStdTargets(
      quartusCycloneIIPath = "D:/altera/13.0sp1/quartus/bin64",
      quartusCycloneIVPath = "D:/altera_lite/15.1/quartus/bin64",
      quartusCycloneVPath  = "D:/altera_lite/15.1/quartus/bin64"
    )

    Bench(rtls, targets, "E:/tmp/")
  }
}


object BrieySynthesisBench {
  def main(args: Array[String]) {
    val briey = new Rtl {
      override def getName(): String = "Briey"
      override def getRtlPath(): String = "Briey.v"
      SpinalVerilog({
        val briey = new Briey(BrieyConfig.default).setDefinitionName(getRtlPath().split("\\.").head)
        briey.io.axiClk.setName("clk")
        briey
      })
    }



    val rtls = List(briey)

    val targets = XilinxStdTargets(
      vivadoArtix7Path = "E:\\Xilinx\\Vivado\\2016.3\\bin"
    ) ++ AlteraStdTargets(
      quartusCycloneIIPath = "D:/altera/13.0sp1/quartus/bin64",
      quartusCycloneIVPath = "D:/altera_lite/15.1/quartus/bin64",
      quartusCycloneVPath  = "D:/altera_lite/15.1/quartus/bin64"
    )

    Bench(rtls, targets, "E:/tmp/")
  }
}




object MuraxSynthesisBench {
  def main(args: Array[String]) {
    val murax = new Rtl {
      override def getName(): String = "Murax"
      override def getRtlPath(): String = "Murax.v"
      SpinalVerilog({
        val murax = new Murax(MuraxConfig.default).setDefinitionName(getRtlPath().split("\\.").head)
        murax.io.mainClk.setName("clk")
        murax
      })
    }


    val muraxFast = new Rtl {
      override def getName(): String = "MuraxFast"
      override def getRtlPath(): String = "MuraxFast.v"
      SpinalVerilog({
        val murax = new Murax(MuraxConfig.fast).setDefinitionName(getRtlPath().split("\\.").head)
        murax.io.mainClk.setName("clk")
        murax
      })
    }

    val rtls = List(murax, muraxFast)

    val targets = XilinxStdTargets(
      vivadoArtix7Path = "E:\\Xilinx\\Vivado\\2016.3\\bin"
    ) ++ AlteraStdTargets(
      quartusCycloneIIPath = "D:/altera/13.0sp1/quartus/bin64",
      quartusCycloneIVPath = "D:/altera_lite/15.1/quartus/bin64",
      quartusCycloneVPath  = "D:/altera_lite/15.1/quartus/bin64"
    )

    Bench(rtls, targets, "E:/tmp/")
  }
}