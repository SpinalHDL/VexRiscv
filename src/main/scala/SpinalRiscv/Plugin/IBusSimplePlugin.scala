package SpinalRiscv.Plugin

import SpinalRiscv.{Stageable, ExceptionService, ExceptionCause, VexRiscv}
import spinal.core._
import spinal.lib._


case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle with IMasterSlave{
  val ready = Bool
  val error = Bool
  val inst  = Bits(32 bits)

  override def asMaster(): Unit = {
    out(ready,error,inst)
  }
}


case class IBusSimpleBus() extends Bundle with IMasterSlave{
  var cmd = Stream(IBusSimpleCmd())
  var rsp = IBusSimpleRsp()

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}

class IBusSimplePlugin(interfaceKeepData : Boolean, catchAccessFault : Boolean) extends Plugin[VexRiscv]{
  var iBus : IBusSimpleBus = null

  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    if(catchAccessFault) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    require(interfaceKeepData)
    iBus = master(IBusSimpleBus()).setName("iBus")
    
    //Emit iBus.cmd request
    iBus.cmd.valid := prefetch.arbitration.isFiring //prefetch.arbitration.isValid && !prefetch.arbitration.isStuckByOthers
    iBus.cmd.pc := prefetch.output(PC)
    prefetch.arbitration.haltIt setWhen(!iBus.cmd.ready)

    //Insert iBus.rsp into INSTRUCTION
    fetch.insert(INSTRUCTION) := iBus.rsp.inst
    fetch.insert(IBUS_ACCESS_ERROR) := iBus.rsp.error
    fetch.arbitration.haltIt setWhen(fetch.arbitration.isValid && !iBus.rsp.ready)
    decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck,decode.input(INSTRUCTION),fetch.output(INSTRUCTION))
    decode.insert(INSTRUCTION_READY) := True

    if(catchAccessFault){
      decodeExceptionPort.valid := decode.arbitration.isValid && decode.input(IBUS_ACCESS_ERROR)
      decodeExceptionPort.code  := 1
      decodeExceptionPort.badAddr := decode.input(PC)
    }
  }
}
