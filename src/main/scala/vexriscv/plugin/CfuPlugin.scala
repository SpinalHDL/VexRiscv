package vexriscv.plugin

import vexriscv.{DecoderService, Stageable, VexRiscv}
import spinal.core._
import spinal.lib._

case class CfuParameter(latency : Int,
                        dropWidth : Int,
                        CFU_VERSION : Int,
                        CFU_INTERFACE_ID_W : Int,
                        CFU_FUNCTION_ID_W : Int,
                        CFU_REORDER_ID_W : Int,
                        CFU_REQ_RESP_ID_W : Int,
                        CFU_INPUTS : Int,
                        CFU_INPUT_DATA_W : Int,
                        CFU_OUTPUTS : Int,
                        CFU_OUTPUT_DATA_W : Int,
                        CFU_FLOW_REQ_READY_ALWAYS : Int,
                        CFU_FLOW_RESP_READY_ALWAYS : Int)

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
  val interface_id = UInt(p.CFU_INTERFACE_ID_W bits)
  val cmd = Stream(CfuCmd(p))
  val rsp = Stream(CfuRsp(p))

  override def asMaster(): Unit = {
    out(interface_id)
    master(cmd)
    slave(rsp)
  }
}

class CfuPlugin(val p: CfuParameter) extends Plugin[VexRiscv]{
  assert(p.CFU_INPUTS <= 2)
  assert(p.CFU_OUTPUTS == 1)
  assert(p.CFU_FLOW_REQ_READY_ALWAYS == false)
  assert(p.CFU_FLOW_RESP_READY_ALWAYS == false)

  var bus : CfuBus = null

  object CFU_ENABLE extends Stageable(Bool())
  object CFU_FUNCTION extends Stageable(UInt(p.CFU_FUNCTION_ID_W bits))
  object CFU_IN_FLIGHT extends Stageable(Bool())

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    bus = CfuBus(p)

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.add(List(
      M"000000-----------000-----0010011"  -> List(
        CFU_ENABLE -> True,
        CFU_FUNCTION -> U"00",
        REGFILE_WRITE_VALID      -> ???,
        BYPASSABLE_EXECUTE_STAGE -> ???,
        BYPASSABLE_MEMORY_STAGE  -> ???,
        RS1_USE -> ???,
        RS2_USE -> ???
      ),
      M"000000-----------001-----0010011"  -> List(
        CFU_ENABLE -> True,
        CFU_FUNCTION -> U"01",
        REGFILE_WRITE_VALID      -> ???,
        BYPASSABLE_EXECUTE_STAGE -> ???,
        BYPASSABLE_MEMORY_STAGE  -> ???,
        RS1_USE -> ???,
        RS2_USE -> ???
      )
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val forkStage = execute
    val joinStageId = Math.min(stages.length - 1, pipeline.indexOf(execute) + p.latency - 1)
    val joinStage = stages(joinStageId)

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
      when(input(CFU_IN_FLIGHT)){
        arbitration.haltItself setWhen(!bus.rsp.valid)
        bus.rsp.ready := arbitration.isStuckByOthers
        output(REGFILE_WRITE_DATA) := bus.rsp.outputs(0)
      }
    }
  }
}
