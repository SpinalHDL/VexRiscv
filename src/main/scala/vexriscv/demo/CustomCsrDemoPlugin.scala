package vexriscv.demo

import spinal.core._
import spinal.lib.io.TriStateArray
import spinal.lib.{Flow, master}
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


class CustomCsrDemoGpioPlugin extends Plugin[VexRiscv]{
  var gpio : TriStateArray = null


  override def setup(pipeline: VexRiscv): Unit = {
    gpio = master(TriStateArray(32 bits)).setName("gpio")
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new Area{
      val writeReg, writeEnableReg = Reg(Bits(32 bits))

      val csrService = pipeline.service(classOf[CsrInterface])
      csrService.rw(0xB08, writeReg)
      csrService.rw(0xB09, writeEnableReg)
      csrService.r(0xB0A, gpio.read)

      gpio.writeEnable := writeEnableReg
      gpio.write := writeReg
    }
  }
}
