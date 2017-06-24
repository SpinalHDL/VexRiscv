package VexRiscv.Plugin

import VexRiscv._
import spinal.core._
import spinal.lib._


class SingleInstructionLimiterPlugin() extends Plugin[VexRiscv] {
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    prefetch.arbitration.haltIt.setWhen(List(fetch,decode,execute,memory,writeBack).map(_.arbitration.isValid).orR)
  }
}
