package vexriscv.demo

import spinal.core._
import vexriscv.plugin.{CsrInterface, Plugin}
import vexriscv.{DecoderService, Stageable, VexRiscv}



class CustomCsrDemoPlugin extends Plugin[VexRiscv]{
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new Area{
      val instructionCounter = Reg(UInt(32 bits))
      val cycleCounter = Reg(UInt(32 bits))

      cycleCounter := cycleCounter + 1
      when(writeBack.arbitration.isFiring) {
        instructionCounter := instructionCounter + 1
      }

      val csrService = pipeline.service(classOf[CsrInterface])
      csrService.rw(0xB04, instructionCounter)
      csrService.r(0xB05, cycleCounter)
      csrService.onWrite(0xB06){
        instructionCounter := 0
      }
      csrService.onRead(0xB07){
        instructionCounter := 0x40000000
      }
    }
  }
}
