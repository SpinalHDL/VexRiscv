package SpinalRiscv.Plugin

import SpinalRiscv.{Stageable, ExceptionService, ExceptionCause, VexRiscv}
import spinal.core._
import spinal.lib._


case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle{
  val ready = Bool
  val error = Bool
  val inst  = Bits(32 bits)
}

class IBusSimplePlugin(interfaceKeepData : Boolean, catchAccessFault : Boolean) extends Plugin[VexRiscv]{
  var iCmd  : Stream[IBusSimpleCmd] = null
  var iRsp  : IBusSimpleRsp = null

  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    pipeline.unremovableStages += pipeline.prefetch

    if(catchAccessFault) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Emit iCmd request
    require(interfaceKeepData)
    iCmd = master(Stream(IBusSimpleCmd())).setName("iCmd")
    iCmd.valid := prefetch.arbitration.isFiring //prefetch.arbitration.isValid && !prefetch.arbitration.isStuckByOthers
    iCmd.pc := prefetch.output(PC)
    prefetch.arbitration.haltIt setWhen(!iCmd.ready)

    //Insert iRsp into INSTRUCTION
    iRsp = in(IBusSimpleRsp()).setName("iRsp")
    fetch.insert(INSTRUCTION) := iRsp.inst
    fetch.arbitration.haltIt setWhen(fetch.arbitration.isValid && !iRsp.ready)
    fetch.insert(IBUS_ACCESS_ERROR) := iRsp.error

    if(catchAccessFault){
      decodeExceptionPort.valid := decode.arbitration.isValid && decode.input(IBUS_ACCESS_ERROR)
      decodeExceptionPort.code  := 1
      decodeExceptionPort.badAddr := decode.input(PC)
    }
  }
}
