package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._


class HazardPessimisticPlugin() extends Plugin[VexRiscv] {
  import Riscv._

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(HAS_SIDE_EFFECT, False)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val writesInPipeline = stages.dropWhile(_ != execute).map(s => s.arbitration.isValid && s.input(REGFILE_WRITE_VALID)) :+ RegNext(stages.last.arbitration.isValid && stages.last.input(REGFILE_WRITE_VALID))
    decode.arbitration.haltByOther.setWhen(decode.arbitration.isValid && writesInPipeline.orR)
  }
}
