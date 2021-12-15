package vexriscv.plugin

import vexriscv.{DecoderService, ExceptionCause, ExceptionService, Stage, Stageable, VexRiscv}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.bmb.WeakConnector
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping}
import vexriscv.Riscv.IMM

case class CfuPluginParameter(
                        CFU_VERSION : Int,
                        CFU_INTERFACE_ID_W : Int,
                        CFU_FUNCTION_ID_W : Int,
                        CFU_REORDER_ID_W : Int,
                        CFU_REQ_RESP_ID_W : Int,
                        CFU_INPUTS : Int,
                        CFU_INPUT_DATA_W : Int,
                        CFU_OUTPUTS : Int,
                        CFU_OUTPUT_DATA_W : Int,
                        CFU_FLOW_REQ_READY_ALWAYS : Boolean,
                        CFU_FLOW_RESP_READY_ALWAYS : Boolean)

case class CfuBusParameter(CFU_VERSION : Int = 0,
                           CFU_INTERFACE_ID_W : Int = 0,
                           CFU_FUNCTION_ID_W : Int,
                           CFU_REORDER_ID_W : Int = 0,
                           CFU_REQ_RESP_ID_W : Int = 0,
                           CFU_STATE_INDEX_NUM : Int = 0,
                           CFU_INPUTS : Int,
                           CFU_INPUT_DATA_W : Int,
                           CFU_OUTPUTS : Int,
                           CFU_OUTPUT_DATA_W : Int,
                           CFU_FLOW_REQ_READY_ALWAYS : Boolean,
                           CFU_FLOW_RESP_READY_ALWAYS : Boolean)

case class CfuCmd( p : CfuBusParameter ) extends Bundle{
  val function_id = UInt(p.CFU_FUNCTION_ID_W bits)
  val reorder_id = UInt(p.CFU_REORDER_ID_W bits)
  val request_id = UInt(p.CFU_REQ_RESP_ID_W bits)
  val inputs = Vec(Bits(p.CFU_INPUT_DATA_W bits), p.CFU_INPUTS)
  val state_index = UInt(log2Up(p.CFU_STATE_INDEX_NUM) bits)
  def weakAssignFrom(m : CfuCmd): Unit ={
    def s = this
    WeakConnector(m, s, m.function_id, s.function_id, defaultValue = null, allowUpSize = false, allowDownSize = true , allowDrop = true)
    WeakConnector(m, s, m.reorder_id,  s.reorder_id,  defaultValue = null, allowUpSize = false , allowDownSize = false, allowDrop = false)
    WeakConnector(m, s, m.request_id,  s.request_id,  defaultValue = null, allowUpSize = false, allowDownSize = false, allowDrop = false)
    s.inputs := m.inputs
  }
}

case class CfuRsp(p : CfuBusParameter) extends Bundle{
  val response_id = UInt(p.CFU_REQ_RESP_ID_W bits)
  val outputs = Vec(Bits(p.CFU_OUTPUT_DATA_W bits), p.CFU_OUTPUTS)

  def weakAssignFrom(m : CfuRsp): Unit ={
    def s = this
    s.response_id := m.response_id
    s.outputs := m.outputs
  }
}

case class CfuBus(p : CfuBusParameter) extends Bundle with IMasterSlave{
  val cmd = Stream(CfuCmd(p))
  val rsp = Stream(CfuRsp(p))

  def <<(m : CfuBus) : Unit = {
    val s = this
    s.cmd.arbitrationFrom(m.cmd)
    m.rsp.arbitrationFrom(s.rsp)

    s.cmd.weakAssignFrom(m.cmd)
    m.rsp.weakAssignFrom(s.rsp)
  }

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}

object CfuPlugin{
  object Input2Kind extends SpinalEnum{
    val RS, IMM_I = newElement()
  }
}

case class CfuPluginEncoding(instruction : MaskedLiteral,
                             functionId : List[Range],
                             input2Kind : CfuPlugin.Input2Kind.E){
  val functionIdWidth = functionId.map(_.size).sum
}

class CfuPlugin(val stageCount : Int,
                val allowZeroLatency : Boolean,
                val busParameter : CfuBusParameter,
                val encodings : List[CfuPluginEncoding] = null,
                val stateAndIndexCsrOffset : Int = 0xBC0,
                val cfuIndexWidth : Int = 0) extends Plugin[VexRiscv]{
  def p = busParameter

  assert(p.CFU_INPUTS <= 2)
  assert(p.CFU_OUTPUTS == 1)
//  assert(p.CFU_FUNCTION_ID_W == 3)

  var bus : CfuBus = null

  lazy val forkStage = pipeline.execute
  lazy val joinStage = pipeline.stages(Math.min(pipeline.stages.length - 1, pipeline.indexOf(forkStage) + stageCount))


  val CFU_ENABLE = new Stageable(Bool()).setCompositeName(this, "CFU_ENABLE")
  val CFU_IN_FLIGHT = new Stageable(Bool()).setCompositeName(this, "CFU_IN_FLIGHT")
  val CFU_ENCODING = new Stageable(UInt(log2Up(encodings.size) bits)).setCompositeName(this, "CFU_ENCODING")
  val CFU_INPUT_2_KIND = new Stageable(CfuPlugin.Input2Kind()).setCompositeName(this, "CFU_INPUT_2_KIND")

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    bus = master(CfuBus(p))

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(CFU_ENABLE, False)

    for((encoding, id) <- encodings.zipWithIndex){
      var actions = List(
        CFU_ENABLE -> True,
        REGFILE_WRITE_VALID      -> True,
        BYPASSABLE_EXECUTE_STAGE -> Bool(stageCount == 0),
        BYPASSABLE_MEMORY_STAGE  -> Bool(stageCount <= 1),
        RS1_USE -> True,
        CFU_ENCODING -> U(id),
        CFU_INPUT_2_KIND -> encoding.input2Kind()
      )

      encoding.input2Kind match {
        case CfuPlugin.Input2Kind.RS =>
          actions :+= RS2_USE -> True
        case CfuPlugin.Input2Kind.IMM_I =>
      }

      decoderService.add(
        key = encoding.instruction,
        values = actions
      )
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val csr = pipeline plug new Area{
      val stateId = Reg(UInt(log2Up(p.CFU_STATE_INDEX_NUM) bits)) init(0)
      if(p.CFU_STATE_INDEX_NUM > 1) {
        assert(stateAndIndexCsrOffset != -1, "CfuPlugin stateCsrIndex need to be set in the parameters")
        pipeline.service(classOf[CsrInterface]).rw(stateAndIndexCsrOffset, 16, stateId)
      }
      bus.cmd.state_index := stateId
      val cfuIndex = Reg(UInt(cfuIndexWidth bits)) init(0)
      if(cfuIndexWidth != 0){
        pipeline.service(classOf[CsrInterface]).rw(stateAndIndexCsrOffset, 0, cfuIndex)
      }
    }


    forkStage plug new Area{
      import forkStage._
      val hazard = stages.dropWhile(_ != forkStage).tail.map(s => s.arbitration.isValid && s.input(HAS_SIDE_EFFECT)).orR
      val scheduleWish = arbitration.isValid && input(CFU_ENABLE)
      val schedule = scheduleWish && !hazard
      arbitration.haltItself setWhen(scheduleWish && hazard)

      val hold = RegInit(False) setWhen(schedule) clearWhen(bus.cmd.ready)
      val fired = RegInit(False) setWhen(bus.cmd.fire) clearWhen(!arbitration.isStuckByOthers)
      insert(CFU_IN_FLIGHT) := schedule || hold || fired

      bus.cmd.valid := (schedule || hold) && !fired
      arbitration.haltItself setWhen(bus.cmd.valid && !bus.cmd.ready)

//      bus.cmd.function_id := U(input(INSTRUCTION)(14 downto 12)).resized
      val functionIdFromInstructinoWidth = encodings.map(_.functionIdWidth).max
      val functionsIds = encodings.map(e => U(Cat(e.functionId.map(r => input(INSTRUCTION)(r))), functionIdFromInstructinoWidth bits))
      bus.cmd.function_id := csr.cfuIndex @@ functionsIds.read(input(CFU_ENCODING))
      bus.cmd.reorder_id := 0
      bus.cmd.request_id := 0
      if(p.CFU_INPUTS >= 1) bus.cmd.inputs(0) := input(RS1)
      if(p.CFU_INPUTS >= 2)  bus.cmd.inputs(1) := input(CFU_INPUT_2_KIND).mux(
        CfuPlugin.Input2Kind.RS -> input(RS2),
        CfuPlugin.Input2Kind.IMM_I -> IMM(input(INSTRUCTION)).h_sext
      )
    }

    joinStage plug new Area{
      import joinStage._

      //If the CFU interface can produce a result combinatorialy and the fork stage isn't the same than the join stage
      //Then it is required to add a buffer on rsp to not propagate the fork stage ready := False in the CPU pipeline.
      val rsp = if(p.CFU_FLOW_RESP_READY_ALWAYS){
        bus.rsp.toFlow.toStream.queueLowLatency(
          size = stageCount + 1,
          latency = 0
        )
      } else if(forkStage != joinStage && allowZeroLatency) {
        bus.rsp.s2mPipe()
      } else {
        bus.rsp.combStage()
      }

      rsp.ready := False
      when(input(CFU_IN_FLIGHT)){
        arbitration.haltItself setWhen(!rsp.valid)
        rsp.ready := !arbitration.isStuckByOthers
        output(REGFILE_WRITE_DATA) := rsp.outputs(0)
      }
    }

    pipeline.stages.drop(1).foreach(s => s.output(CFU_IN_FLIGHT) clearWhen(s.arbitration.isStuck))
    addPrePopTask(() => stages.dropWhile(_ != memory).reverse.dropWhile(_ != joinStage).foreach(s => s.input(CFU_IN_FLIGHT).init(False)))
  }
}


object CfuTest{

//  stageCount = 0,
//  allowZeroLatency = true,
  def getCfuParameter() = CfuBusParameter(
    CFU_VERSION = 0,
    CFU_INTERFACE_ID_W = 0,
    CFU_FUNCTION_ID_W = 3,
    CFU_REORDER_ID_W = 0,
    CFU_REQ_RESP_ID_W = 0,
    CFU_INPUTS = 2,
    CFU_INPUT_DATA_W = 32,
    CFU_OUTPUTS = 1,
    CFU_OUTPUT_DATA_W = 32,
    CFU_FLOW_REQ_READY_ALWAYS = false,
    CFU_FLOW_RESP_READY_ALWAYS = false
  )
}
case class CfuTest() extends Component{
  val io = new Bundle {
    val bus = slave(CfuBus(CfuTest.getCfuParameter()))
  }
  io.bus.rsp.arbitrationFrom(io.bus.cmd)
  io.bus.rsp.response_id := io.bus.cmd.request_id
  io.bus.rsp.outputs(0) := ~(io.bus.cmd.inputs(0) & io.bus.cmd.inputs(1))
}


case class CfuBb(p : CfuBusParameter) extends BlackBox{
  val io = new Bundle {
    val clk, reset = in Bool()
    val bus = slave(CfuBus(p))
  }

  mapCurrentClockDomain(io.clk, io.reset)
}

//case class CfuGray(p : CfuBusParameter) extends BlackBox{
//  val req_function_id = in Bits(p.CFU_FUNCTION_ID_W)
//  val req_data = in Bits(p.CFU_REQ_INPUTS)
//  val resp_data = in Bits(p.CFU_FUNCTION_ID_W)
//  input `CFU_FUNCTION_ID req_function_id,
//  input [CFU_REQ_INPUTS-1:0]`CFU_REQ_DATA req_data,
//  output [CFU_RESP_OUTPUTS-1:0]`CFU_RESP_DATA resp_data
//  io.bus.rsp.arbitrationFrom(io.bus.cmd)
//  io.bus.rsp.response_ok := True
//  io.bus.rsp.response_id := io.bus.cmd.request_id
//  io.bus.rsp.outputs(0) := ~(io.bus.cmd.inputs(0) & io.bus.cmd.inputs(1))
//}


case class CfuDecoder(p : CfuBusParameter,
                      mappings : Seq[AddressMapping],
                      pendingMax : Int = 3) extends Component{
  val io = new Bundle {
    val input = slave(CfuBus(p))
    val outputs = Vec(master(CfuBus(p)), mappings.size)
  }
  val hasDefault = mappings.contains(DefaultMapping)
  val logic = if(hasDefault && mappings.size == 1){
    io.outputs(0) << io.input
  } else new Area {
    val hits = Vec(Bool, mappings.size)
    for (portId <- 0 until mappings.length) yield {
      val slaveBus = io.outputs(portId)
      val memorySpace = mappings(portId)
      val hit = hits(portId)
      hit := (memorySpace match {
        case DefaultMapping => !hits.filterNot(_ == hit).orR
        case _ => memorySpace.hit(io.input.cmd.function_id)
      })
      slaveBus.cmd.valid := io.input.cmd.valid && hit
      slaveBus.cmd.payload := io.input.cmd.payload.resized
    }
    val noHit = if (!hasDefault) !hits.orR else False
    io.input.cmd.ready := (hits, io.outputs).zipped.map(_ && _.cmd.ready).orR || noHit

    val rspPendingCounter = Reg(UInt(log2Up(pendingMax + 1) bits)) init(0)
    rspPendingCounter := rspPendingCounter + U(io.input.cmd.fire) - U(io.input.rsp.fire)
    val rspHits = RegNextWhen(hits, io.input.cmd.fire)
    val rspPending = rspPendingCounter =/= 0
    val rspNoHitValid = if (!hasDefault) !rspHits.orR else False
    val rspNoHit = !hasDefault generate new Area{
      val doIt = RegInit(False) clearWhen(io.input.rsp.fire) setWhen(io.input.cmd.fire && noHit)
      val response_id = RegNextWhen(io.input.cmd.request_id, io.input.cmd.fire)
    }

    io.input.rsp.valid := io.outputs.map(_.rsp.valid).orR || (rspPending && rspNoHitValid)
    io.input.rsp.payload := io.outputs.map(_.rsp.payload).read(OHToUInt(rspHits))
    if(!hasDefault) when(rspNoHit.doIt) {
      io.input.rsp.valid := True
      io.input.rsp.response_id := rspNoHit.response_id
    }
    for(output <- io.outputs) output.rsp.ready := io.input.rsp.ready

    val cmdWait = (rspPending && (hits =/= rspHits || rspNoHitValid)) || rspPendingCounter === pendingMax
    when(cmdWait) {
      io.input.cmd.ready := False
      io.outputs.foreach(_.cmd.valid := False)
    }
  }
}
