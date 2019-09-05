package vexriscv.plugin

import vexriscv.{DecoderService, ExceptionCause, ExceptionService, Stage, Stageable, VexRiscv}
import spinal.core._
import spinal.lib._

case class CfuParameter(stageCount : Int,
                        allowZeroLatency : Boolean,
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

case class CfuCmd(p : CfuParameter) extends Bundle{
  val function_id = UInt(p.CFU_FUNCTION_ID_W bits)
  val reorder_id = UInt(p.CFU_REORDER_ID_W bits)
  val request_id = UInt(p.CFU_REQ_RESP_ID_W bits)
  val inputs = Vec(Bits(p.CFU_INPUT_DATA_W bits), p.CFU_INPUTS)
}

case class CfuRsp(p : CfuParameter) extends Bundle{
  val response_ok = Bool()
  val response_id = UInt(p.CFU_REQ_RESP_ID_W bits)
  val outputs = Vec(Bits(p.CFU_OUTPUT_DATA_W bits), p.CFU_OUTPUTS)
}

case class CfuBus(p : CfuParameter) extends Bundle with IMasterSlave{
  val cmd = Stream(CfuCmd(p))
  val rsp = Stream(CfuRsp(p))

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}

class CfuPlugin(val p: CfuParameter) extends Plugin[VexRiscv]{
  assert(p.CFU_INPUTS <= 2)
  assert(p.CFU_OUTPUTS == 1)

  var bus : CfuBus = null
  var joinException : Flow[ExceptionCause] = null

  lazy val forkStage = pipeline.execute
  lazy val joinStage = pipeline.stages(Math.min(pipeline.stages.length - 1, pipeline.indexOf(forkStage) + p.stageCount - 1))


  object CFU_ENABLE extends Stageable(Bool())
  object CFU_FUNCTION extends Stageable(UInt(p.CFU_FUNCTION_ID_W bits))
  object CFU_IN_FLIGHT extends Stageable(Bool())

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    bus = master(CfuBus(p))
    joinException = pipeline.service(classOf[ExceptionService]).newExceptionPort(joinStage)

    val decoderService = pipeline.service(classOf[DecoderService])

    //custom-0
    decoderService.add(List(
      M"000000-----------000-----0001011"  -> List(
        CFU_ENABLE -> True,
        CFU_FUNCTION -> U"00",
        REGFILE_WRITE_VALID      -> True,
        BYPASSABLE_EXECUTE_STAGE -> Bool(p.stageCount == 0),
        BYPASSABLE_MEMORY_STAGE  -> Bool(p.stageCount <= 1),
        RS1_USE -> True,
        RS2_USE -> True
      ),
      M"000000-----------001-----0001011"  -> List(
        CFU_ENABLE -> True,
        CFU_FUNCTION -> U"01",
        REGFILE_WRITE_VALID      -> True,
        BYPASSABLE_EXECUTE_STAGE -> Bool(p.stageCount == 0),
        BYPASSABLE_MEMORY_STAGE  -> Bool(p.stageCount <= 1),
        RS1_USE -> True,
        RS2_USE -> True
      )
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    forkStage plug new Area{
      import forkStage._
      val schedule = arbitration.isValid && input(CFU_ENABLE)
      val hold = RegInit(False) setWhen(schedule) clearWhen(bus.cmd.ready)
      val fired = RegInit(False) setWhen(bus.cmd.fire) clearWhen(!arbitration.isStuckByOthers)
      insert(CFU_IN_FLIGHT) := schedule || hold || fired

      bus.cmd.valid := (schedule || hold) && !fired
      arbitration.haltItself setWhen(bus.cmd.valid && !bus.cmd.ready)

      bus.cmd.function_id := input(CFU_FUNCTION)
      bus.cmd.reorder_id := 0
      bus.cmd.request_id := 0
      if(p.CFU_INPUTS >= 1) bus.cmd.inputs(0) := input(RS1)
      if(p.CFU_INPUTS >= 2) bus.cmd.inputs(1) := input(RS2)
    }

    joinStage plug new Area{
      import joinStage._

      //If the CFU interface can produce a result combinatorialy and the fork stage isn't the same than the join stage
      //Then it is required to add a buffer on rsp to not propagate the fork stage ready := False in the CPU pipeline.
      val rsp = if(p.CFU_FLOW_RESP_READY_ALWAYS){
        bus.rsp.toFlow.toStream.queueLowLatency(
          size = p.stageCount + 1,
          latency = 0
        )
      } else if(forkStage != joinStage && p.allowZeroLatency) {
        bus.rsp.m2sPipe()
      } else {
        bus.rsp.combStage()
      }

      joinException.valid := False
      joinException.code := 15
      joinException.badAddr := 0

      rsp.ready := False
      when(input(CFU_IN_FLIGHT)){
        arbitration.haltItself setWhen(!rsp.valid)
        rsp.ready := arbitration.isStuckByOthers
        output(REGFILE_WRITE_DATA) := rsp.outputs(0)

        when(arbitration.isValid){
          joinException.valid := !rsp.response_ok
        }
      }
    }
  }
}
