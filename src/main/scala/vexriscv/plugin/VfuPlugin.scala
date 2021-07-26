package vexriscv.plugin

import vexriscv.{DecoderService, ExceptionCause, ExceptionService, Stage, Stageable, VexRiscv}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.bmb.WeakConnector
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping}
import vexriscv.Riscv.IMM


object VfuPlugin{
  val ROUND_MODE_WIDTH = 3

}


case class VfuParameter() //Empty for now

case class VfuCmd( p : VfuParameter ) extends Bundle{
  val instruction = Bits(32 bits)
  val inputs = Vec(Bits(32 bits), 2)
  val rounding = Bits(VfuPlugin.ROUND_MODE_WIDTH bits)
}

case class VfuRsp(p : VfuParameter) extends Bundle{
  val output = Bits(32 bits)
}

case class VfuBus(p : VfuParameter) extends Bundle with IMasterSlave{
  val cmd = Stream(VfuCmd(p))
  val rsp = Stream(VfuRsp(p))

  def <<(m : VfuBus) : Unit = {
    val s = this
    s.cmd << m.cmd
    m.rsp << s.rsp
  }

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}



class VfuPlugin(val stageCount : Int,
                val allowZeroLatency : Boolean,
                val parameter : VfuParameter) extends Plugin[VexRiscv]{
  def p = parameter
  
  var bus : VfuBus = null

  lazy val forkStage = pipeline.execute
  lazy val joinStage = pipeline.stages(Math.min(pipeline.stages.length - 1, pipeline.indexOf(forkStage) + stageCount))


  object VFU_ENABLE extends Stageable(Bool())
  object VFU_IN_FLIGHT extends Stageable(Bool())

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    bus = master(VfuBus(p))

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(VFU_ENABLE, False)

    decoderService.add(
      key = M"-------------------------0001011",
      values = List(
        VFU_ENABLE -> True,
        REGFILE_WRITE_VALID      -> True, //If you want to write something back into the integer register file
        BYPASSABLE_EXECUTE_STAGE -> Bool(stageCount == 0),
        BYPASSABLE_MEMORY_STAGE  -> Bool(stageCount <= 1),
        RS1_USE -> True,
        RS2_USE -> True
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val csr = pipeline plug new Area{
      val factory = pipeline.service(classOf[CsrInterface])
      val rounding = Reg(Bits(VfuPlugin.ROUND_MODE_WIDTH bits))

      factory.rw(csrAddress = 0xBC0, bitOffset = 0, that = rounding)
    }


    forkStage plug new Area{
      import forkStage._
      val hazard = stages.dropWhile(_ != forkStage).tail.map(s => s.arbitration.isValid && s.input(HAS_SIDE_EFFECT)).orR
      val scheduleWish = arbitration.isValid && input(VFU_ENABLE)
      val schedule = scheduleWish && !hazard
      arbitration.haltItself setWhen(scheduleWish && hazard)

      val hold = RegInit(False) setWhen(schedule) clearWhen(bus.cmd.ready)
      val fired = RegInit(False) setWhen(bus.cmd.fire) clearWhen(!arbitration.isStuckByOthers)
      insert(VFU_IN_FLIGHT) := schedule || hold || fired

      bus.cmd.valid := (schedule || hold) && !fired
      arbitration.haltItself setWhen(bus.cmd.valid && !bus.cmd.ready)

      bus.cmd.instruction := input(INSTRUCTION)
      bus.cmd.inputs(0) := input(RS1)
      bus.cmd.inputs(1) := input(RS2)
      bus.cmd.rounding := csr.rounding
    }

    joinStage plug new Area{
      import joinStage._

      val rsp = if(forkStage != joinStage && allowZeroLatency) {
        bus.rsp.s2mPipe()
      } else {
        bus.rsp.combStage()
      }

      rsp.ready := False
      when(input(VFU_IN_FLIGHT) && input(REGFILE_WRITE_VALID)){
        arbitration.haltItself setWhen(!bus.rsp.valid)
        rsp.ready := !arbitration.isStuckByOthers
        output(REGFILE_WRITE_DATA) := bus.rsp.output
      }
    }

    pipeline.stages.drop(1).foreach(s => s.output(VFU_IN_FLIGHT) clearWhen(s.arbitration.isStuck))
    addPrePopTask(() => stages.dropWhile(_ != memory).reverse.dropWhile(_ != joinStage).foreach(s => s.input(VFU_IN_FLIGHT).init(False)))
  }
}

