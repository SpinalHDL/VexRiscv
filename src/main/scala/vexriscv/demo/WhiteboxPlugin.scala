package vexriscv.demo

import spinal.core._
import vexriscv.plugin.Plugin
import vexriscv.{DecoderService, Stageable, VexRiscv}

class WhiteboxPlugin extends Plugin[VexRiscv]{
  override def build(pipeline: VexRiscv): Unit = {
    Component.current.afterElaboration {
      def export(name : String): Unit = out(Component.current.reflectBaseType(name))
      export("IBusCachedPlugin_fetchPc_pc")
    }
  }
}
