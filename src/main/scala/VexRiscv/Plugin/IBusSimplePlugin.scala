package VexRiscv.Plugin

import VexRiscv.{Stageable, ExceptionService, ExceptionCause, VexRiscv}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._


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

object IBusSimpleBus{
  def getAxi4Config() = Axi4Config(
    addressWidth = 32,
    dataWidth = 32,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false,
    useLen = false,
    useResp = true,
    useSize = false
  )
}
case class IBusSimpleBus(interfaceKeepData : Boolean) extends Bundle with IMasterSlave{
  var cmd = Stream(IBusSimpleCmd())
  var rsp = IBusSimpleRsp()

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }


  def toAxi4ReadOnly(): Axi4ReadOnly = {
    assert(!interfaceKeepData)
    val axi = Axi4ReadOnly(IBusSimpleBus.getAxi4Config())

    axi.ar.valid := cmd.valid
    axi.ar.addr  := cmd.pc(axi.readCmd.addr.getWidth -1 downto 2) @@ U"00"
    axi.ar.prot  := "110"
    axi.ar.cache := "1111"
    cmd.ready := axi.ar.ready


    rsp.ready := axi.r.valid
    rsp.inst := axi.r.data
    rsp.error := !axi.r.isOKAY()
    axi.r.ready := True


    //TODO remove
    val axi2 = Axi4ReadOnly(IBusSimpleBus.getAxi4Config())
    axi.ar >-> axi2.ar
    axi.r << axi2.r
//    axi2 << axi
    axi2
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
    iBus = master(IBusSimpleBus(interfaceKeepData)).setName("iBus")
    prefetch plug new Area {
      val pendingCmd = RegInit(False) clearWhen (iBus.rsp.ready) setWhen (iBus.cmd.fire)

      //Emit iBus.cmd request
      iBus.cmd.valid := prefetch.arbitration.isValid && !prefetch.arbitration.isStuckByOthers && !(pendingCmd && !iBus.rsp.ready) //prefetch.arbitration.isValid && !prefetch.arbitration.isStuckByOthers
      iBus.cmd.pc := prefetch.output(PC)
      prefetch.arbitration.haltIt setWhen (!iBus.cmd.ready || (pendingCmd && !iBus.rsp.ready))
    }

    //Bus rsp buffer
    val rspBuffer = if(!interfaceKeepData) new Area{
      val valid = RegInit(False) setWhen(iBus.rsp.ready) clearWhen(!fetch.arbitration.isStuck)
      val error = Reg(Bool)
      val data = Reg(Bits(32 bits))
      when(!valid) {
        data := iBus.rsp.inst
        error := iBus.rsp.error
      }
    } else null

    //Insert iBus.rsp into INSTRUCTION
    fetch.insert(INSTRUCTION) := iBus.rsp.inst
    fetch.insert(IBUS_ACCESS_ERROR) := iBus.rsp.error
    if(!interfaceKeepData) {
      when(rspBuffer.valid) {
        fetch.insert(INSTRUCTION) := rspBuffer.data
        fetch.insert(IBUS_ACCESS_ERROR) := rspBuffer.error
      }
    }

    if(interfaceKeepData)
      fetch.arbitration.haltIt setWhen(fetch.arbitration.isValid && !iBus.rsp.ready)
    else
      fetch.arbitration.haltIt setWhen(fetch.arbitration.isValid && !iBus.rsp.ready && !rspBuffer.valid)

    decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck,decode.input(INSTRUCTION),fetch.output(INSTRUCTION))
    decode.insert(INSTRUCTION_READY) := True

    if(catchAccessFault){
      decodeExceptionPort.valid := decode.arbitration.isValid && decode.input(IBUS_ACCESS_ERROR)
      decodeExceptionPort.code  := 1
      decodeExceptionPort.badAddr := decode.input(PC)
    }
  }
}
