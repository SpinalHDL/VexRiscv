package vexriscv.plugin

import spinal.core._
import vexriscv.VexRiscv

class ExternalInterruptArrayPlugin(arrayWidth : Int = 32, maskCsrId : Int = 0xBC0, pendingsCsrId : Int = 0xFC0) extends Plugin[VexRiscv]{
  var externalInterruptArray : Bits = null

  override def setup(pipeline: VexRiscv): Unit = {
    externalInterruptArray = in(Bits(arrayWidth bits)).setName("externalInterruptArray")
  }

  override def build(pipeline: VexRiscv): Unit = {
    val csr = pipeline.service(classOf[CsrPlugin])
    val mask = Reg(Bits(arrayWidth bits)) init(0)
    val pendings = mask & RegNext(externalInterruptArray)
    csr.externalInterrupt.setAsDirectionLess() := pendings.orR
    csr.rw(maskCsrId, mask)
    csr.r(pendingsCsrId, pendings)
  }
}
