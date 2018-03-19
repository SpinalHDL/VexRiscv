package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}

import scala.collection.mutable.ArrayBuffer


case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle with IMasterSlave{
  val error = Bool
  val inst  = Bits(32 bits)

  override def asMaster(): Unit = {
    out(error,inst)
  }
}

object StreamVexPimper{
  implicit class StreamFlushPimper[T <: Data](pimped : Stream[T]){
    def m2sPipe(flush : Bool, collapsBubble : Boolean = true): Stream[T] = {
      val ret = cloneOf(pimped)

      val rValid = RegInit(False)
      val rData = Reg(pimped.dataType)

      pimped.ready := (Bool(collapsBubble) && !ret.valid) || ret.ready

      when(pimped.ready) {
        rValid := pimped.valid
        rData := pimped.payload
      }

      ret.valid := rValid
      ret.payload := rData

      rValid.clearWhen(flush)

      ret
    }

    def s2mPipe(flush : Bool): Stream[T] = {
      val ret = cloneOf(pimped)

      val rValid = RegInit(False)
      val rBits = Reg(pimped.dataType)

      ret.valid := pimped.valid || rValid
      pimped.ready := !rValid
      ret.payload := Mux(rValid, rBits, pimped.payload)

      when(ret.ready) {
        rValid := False
      }

      when(pimped.ready && (!ret.ready)) {
        rValid := pimped.valid
        rBits := pimped.payload
      }

      rValid.clearWhen(flush)

      ret
    }
  }

}

import StreamVexPimper._

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

  def getAvalonConfig() = AvalonMMConfig.pipelined(
    addressWidth = 32,
    dataWidth = 32
  ).getReadOnlyConfig.copy(
    useResponse = true,
    maximumPendingReadTransactions = 8
  )
}


case class IBusSimpleBus(interfaceKeepData : Boolean) extends Bundle with IMasterSlave {
  var cmd = Stream(IBusSimpleCmd())
  var rsp = Flow(IBusSimpleRsp())

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


    rsp.valid := axi.r.valid
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

  def toAvalon(): AvalonMM = {
    assert(!interfaceKeepData)
    val avalonConfig = IBusSimpleBus.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)

    mm.read := cmd.valid
    mm.address := (cmd.pc >> 2) @@ U"00"
    cmd.ready := mm.waitRequestn

    rsp.valid := mm.readDataValid
    rsp.inst := mm.readData
    rsp.error := mm.response =/= AvalonMM.Response.OKAY

    mm
  }
}

trait IBusFetcher{
  def haltIt() : Unit
  def nextPc() : (Bool, UInt)
}

class IBusSimplePlugin(interfaceKeepData : Boolean, catchAccessFault : Boolean, pendingMax : Int = 7) extends Plugin[VexRiscv] with JumpService with IBusFetcher{
  var iBus : IBusSimpleBus = null
  var prefetchExceptionPort : Flow[ExceptionCause] = null
  def resetVector = BigInt(0x80000000l)
  def keepPcPlus4 = false

  lazy val fetcherHalt = False
  lazy val decodeNextPcValid = Bool
  lazy val decodeNextPc = UInt(32 bits)
  def nextPc() = (decodeNextPcValid, decodeNextPc)

  override def haltIt(): Unit = fetcherHalt := True

  case class JumpInfo(interface :  Flow[UInt], stage: Stage, priority : Int)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def createJumpInterface(stage: Stage, priority : Int = 0): Flow[UInt] = {
    val interface = Flow(UInt(32 bits))
    jumpInfos += JumpInfo(interface,stage, priority)
    interface
  }


  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    iBus = master(IBusSimpleBus(interfaceKeepData)).setName("iBus")
    if(catchAccessFault) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1).setName("iBusErrorExceptionnPort")
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new Area {
      val pcCalc = new Area {
        val output = Stream(UInt(32 bits))

        //PC calculation without Jump
        val pcReg = Reg(UInt(32 bits)) init (resetVector) addAttribute (Verilator.public)
        val pcPlus4 = pcReg + 4
        if (keepPcPlus4) KeepAttribute(pcPlus4)
        when(output.fire) {
          pcReg := pcPlus4
        }

        //JumpService hardware implementation
        val jump = new Area {
          val sortedByStage = jumpInfos.sortWith((a, b) => {
            (pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage)) ||
              (pipeline.indexOf(a.stage) == pipeline.indexOf(b.stage) && a.priority > b.priority)
          })
          val valids = sortedByStage.map(_.interface.valid)
          val pcs = sortedByStage.map(_.interface.payload)

          val pcLoad = Flow(UInt(32 bits))
          pcLoad.valid := jumpInfos.map(_.interface.valid).orR
          pcLoad.payload := MuxOH(OHMasking.first(valids.asBits), pcs)

          //application of the selected jump request
          when(pcLoad.valid) {
            pcReg := pcLoad.payload
          }
        }


        output.valid := (RegNext(True) init (False)) // && !jump.pcLoad.valid
        output.payload := pcReg
      }

      def flush = pcCalc.jump.pcLoad.valid


      val iBusCmd = new Area {
        def input = pcCalc.output

        val output = input.continueWhen(iBus.cmd.fire)

        //Avoid sending to many iBus cmd
        val pendingCmd = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
        val pendingCmdNext = pendingCmd + iBus.cmd.fire.asUInt - iBus.rsp.fire.asUInt
        pendingCmd := pendingCmdNext

        iBus.cmd.valid := input.valid && output.ready && pendingCmd =/= pendingMax
        iBus.cmd.pc := input.payload
      }

      val iBusRsp = new Area {
        val input = iBusCmd.output.m2sPipe(flush)// ASYNC .throwWhen(flush)

        //Manage flush for iBus transactions in flight
        val discardCounter = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
        discardCounter := discardCounter - (iBus.rsp.fire && discardCounter =/= 0).asUInt
        when(flush) {
          discardCounter := iBusCmd.pendingCmdNext
        }

        val rsp = iBus.rsp.throwWhen(discardCounter =/= 0).toStream.s2mPipe(flush)

        case class FetchRsp() extends Bundle {
          val pc = UInt(32 bits)
          val rsp = IBusSimpleRsp()
        }

        val fetchRsp = FetchRsp()
        fetchRsp.pc := input.payload
        fetchRsp.rsp := rsp.payload
        fetchRsp.rsp.error.clearWhen(!rsp.valid) //Avoid interference with instruction injection from the debug plugin


        val output = StreamJoin(Seq(input, rsp), fetchRsp)

      }


      val injector = new Area {
        val inputBeforeHalt =  iBusRsp.output.s2mPipe(flush)
        val input =  inputBeforeHalt.haltWhen(fetcherHalt)
        val stage = input.m2sPipe(flush || decode.arbitration.isRemoved)

        decodeNextPcValid := RegNext(inputBeforeHalt.isStall)
        decodeNextPc := decode.input(PC)

        stage.ready := !decode.arbitration.isStuck
        decode.arbitration.isValid := stage.valid
        decode.insert(PC) := stage.pc
        decode.insert(INSTRUCTION) := stage.rsp.inst
        decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), input.rsp.inst)
        decode.insert(INSTRUCTION_READY) := True

        if(catchAccessFault){
          decodeExceptionPort.valid := decode.arbitration.isValid && stage.rsp.error
          decodeExceptionPort.code  := 1
          decodeExceptionPort.badAddr := decode.input(PC)
        }
      }
    }
  }
}

//class IBusSimplePlugin(interfaceKeepData : Boolean, catchAccessFault : Boolean) extends Plugin[VexRiscv]{
//  var iBus : IBusSimpleBus = null
//
//  object IBUS_ACCESS_ERROR extends Stageable(Bool)
//  var decodeExceptionPort : Flow[ExceptionCause] = null
//  override def setup(pipeline: VexRiscv): Unit = {
//    if(catchAccessFault) {
//      val exceptionService = pipeline.service(classOf[ExceptionService])
//      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
//    }
//  }
//
//  override def build(pipeline: VexRiscv): Unit = {
//    import pipeline._
//    import pipeline.config._
//    iBus = master(IBusSimpleBus(interfaceKeepData)).setName("iBus")
//    prefetch plug new Area {
//      val pendingCmd = RegInit(False) clearWhen (iBus.rsp.ready) setWhen (iBus.cmd.fire)
//
//      //Emit iBus.cmd request
//      iBus.cmd.valid := prefetch.arbitration.isValid && !prefetch.arbitration.removeIt && !prefetch.arbitration.isStuckByOthers && !(pendingCmd && !iBus.rsp.ready) //prefetch.arbitration.isValid && !prefetch.arbitration.isStuckByOthers
//      iBus.cmd.pc := prefetch.output(PC)
//      prefetch.arbitration.haltItself setWhen (!iBus.cmd.ready || (pendingCmd && !iBus.rsp.ready))
//    }
//
//    //Bus rsp buffer
//    val rspBuffer = if(!interfaceKeepData) new Area{
//      val valid = RegInit(False) setWhen(iBus.rsp.ready) clearWhen(!fetch.arbitration.isStuck)
//      val error = Reg(Bool)
//      val data = Reg(Bits(32 bits))
//      when(!valid) {
//        data := iBus.rsp.inst
//        error := iBus.rsp.error
//      }
//    } else null
//
//    //Insert iBus.rsp into INSTRUCTION
//    fetch.insert(INSTRUCTION) := iBus.rsp.inst
//    fetch.insert(IBUS_ACCESS_ERROR) := iBus.rsp.error
//    if(!interfaceKeepData) {
//      when(rspBuffer.valid) {
//        fetch.insert(INSTRUCTION) := rspBuffer.data
//        fetch.insert(IBUS_ACCESS_ERROR) := rspBuffer.error
//      }
//    }
//
//    fetch.insert(IBUS_ACCESS_ERROR) clearWhen(!fetch.arbitration.isValid) //Avoid interference with instruction injection from the debug plugin
//
//    if(interfaceKeepData)
//      fetch.arbitration.haltItself setWhen(fetch.arbitration.isValid && !iBus.rsp.ready)
//    else
//      fetch.arbitration.haltItself setWhen(fetch.arbitration.isValid && !iBus.rsp.ready && !rspBuffer.valid)
//
//    decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck,decode.input(INSTRUCTION),fetch.output(INSTRUCTION))
//    decode.insert(INSTRUCTION_READY) := True
//
//    if(catchAccessFault){
//      decodeExceptionPort.valid := decode.arbitration.isValid && decode.input(IBUS_ACCESS_ERROR)
//      decodeExceptionPort.code  := 1
//      decodeExceptionPort.badAddr := decode.input(PC)
//    }
//  }
//}
