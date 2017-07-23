package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._


class HazardPessimisticPlugin() extends Plugin[VexRiscv] {
  import Riscv._
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val writesInPipeline = List(execute,memory,writeBack).map(s => s.arbitration.isValid && s.input(REGFILE_WRITE_VALID)) :+ RegNext(writeBack.arbitration.isValid && writeBack.input(REGFILE_WRITE_VALID))
    decode.arbitration.haltIt.setWhen(decode.arbitration.isValid && writesInPipeline.orR)
  }
}
