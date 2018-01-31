package vexriscv.demo

import spinal.core._
import vexriscv.plugin.{CsrInterface, Plugin}
import vexriscv.{DecoderService, Stageable, VexRiscv}


case class CustomCsrDemoArea(csrService : CsrInterface) extends Area{
  val instructionCounter = Reg(UInt(32 bits))
  val cycleCounter = Reg(UInt(32 bits))

  csrService.rw(0xB04, instructionCounter)
  csrService.r(0xB05, cycleCounter)
}

class CustomCsrDemoPlugin extends Plugin[VexRiscv]{
  var csrStruct : CustomCsrDemoArea = null

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    val csrService = pipeline.service(classOf[CsrInterface])
    csrStruct = pipeline plug CustomCsrDemoArea(csrService)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    csrStruct.cycleCounter := csrStruct.cycleCounter + 1
    when(writeBack.arbitration.isFiring) {
      csrStruct.instructionCounter := csrStruct.instructionCounter + 1
    }
  }
}
