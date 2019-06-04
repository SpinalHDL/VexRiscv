package vexriscv.plugin

import spinal.core._
import vexriscv.VexRiscv

class ExternalInterruptArrayPlugin(arrayWidth : Int = 32,
                                   machineMaskCsrId : Int = 0xBC0,
                                   machinePendingsCsrId : Int = 0xFC0,
                                   supervisorMaskCsrId : Int = 0x9C0,
                                   supervisorPendingsCsrId : Int = 0xDC0) extends Plugin[VexRiscv]{
  var externalInterruptArray : Bits = null

  override def setup(pipeline: VexRiscv): Unit = {
    externalInterruptArray = in(Bits(arrayWidth bits)).setName("externalInterruptArray")
  }

  override def build(pipeline: VexRiscv): Unit = {
    val csr = pipeline.service(classOf[CsrPlugin])
    val externalInterruptArrayBuffer = RegNext(externalInterruptArray)
    def gen(maskCsrId : Int, pendingsCsrId : Int, interruptPin : Bool) = new Area {
      val mask = Reg(Bits(arrayWidth bits)) init(0)
      val pendings = mask & externalInterruptArrayBuffer
      interruptPin.setAsDirectionLess() := pendings.orR
      csr.rw(maskCsrId, mask)
      csr.r(pendingsCsrId, pendings)
    }
    gen(machineMaskCsrId, machinePendingsCsrId, csr.externalInterrupt)
    if(csr.config.supervisorGen) gen(supervisorMaskCsrId, supervisorPendingsCsrId, csr.externalInterruptS)
  }
}
