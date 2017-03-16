package SpinalRiscv.Plugin

import SpinalRiscv.VexRiscv
import spinal.core._
import spinal.lib._


case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle{
  val inst = Bits(32 bits)
}

class IBusSimplePlugin(interfaceKeepData : Boolean) extends Plugin[VexRiscv]{
  var iCmd  : Stream[IBusSimpleCmd] = null
  var iRsp  : IBusSimpleRsp = null

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    require(interfaceKeepData)
    iCmd = master(Stream(IBusSimpleCmd())).setName("iCmd")
    iCmd.valid := prefetch.arbitration.isValid && !prefetch.arbitration.isStuckByOthers
    iCmd.pc := prefetch.output(PC)
    prefetch.arbitration.haltIt setWhen(!iCmd.ready)

    iRsp = in(IBusSimpleRsp()).setName("iRsp")
    fetch.insert(INSTRUCTION) := iRsp.inst
  }
}
