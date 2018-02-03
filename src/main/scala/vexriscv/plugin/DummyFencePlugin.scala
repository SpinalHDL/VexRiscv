package vexriscv.plugin

import spinal.core._
import vexriscv.{VexRiscv, _}

class DummyFencePlugin extends Plugin[VexRiscv]{

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.add(FENCE_I, Nil)
    decoderService.add(FENCE, Nil)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    //Dummy
  }
}
