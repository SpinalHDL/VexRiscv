package SpinalRiscv.Plugin

import SpinalRiscv.Plugin.IntAluPlugin.{AluCtrlEnum, ALU_CTRL}
import SpinalRiscv._
import SpinalRiscv.ip._
import spinal.core._
import spinal.lib._


case class DebugExtensionCmd() extends Bundle{
  val wr = Bool
  val address = UInt(8 bit)
  val data = Bits(32 bit)
}
case class DebugExtensionRsp() extends Bundle{
  val data = Bits(32 bit)
}

case class DebugExtensionBus() extends Bundle with IMasterSlave{
  val cmd = Stream(DebugExtensionCmd())
  val rsp = DebugExtensionRsp() //One cycle latency

  override def asMaster(): Unit = {
    master(cmd)
    in(rsp)
  }
}

case class DebugExtensionIo() extends Bundle with IMasterSlave{
  val bus = DebugExtensionBus()
  val resetOut = Bool

  override def asMaster(): Unit = {
    master(bus)
    in(resetOut)
  }
}

class DebugPlugin() extends Plugin[VexRiscv] {

  var io : DebugExtensionIo = null


  object IS_EBREAK extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    io = slave(DebugExtensionIo())

    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(IS_EBREAK, False)
    decoderService.add(EBREAK,List(
      IS_EBREAK -> True,
      SRC_USE_SUB_LESS -> False,
      SRC1_CTRL -> Src1CtrlEnum.RS, // Zero
      SRC2_CTRL -> Src2CtrlEnum.PC,
      ALU_CTRL  -> AluCtrlEnum.ADD_SUB //Used to get the PC value in busReadDataReg
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val busReadDataReg = Reg(Bits(32 bit))
    when(writeBack.arbitration.isValid){
      busReadDataReg := writeBack.output(REGFILE_WRITE_DATA)
    }
    io.bus.cmd.ready := True
    io.bus.rsp.data := busReadDataReg

    val insertDecodeInstruction = False
    val firstCycle = RegNext(False) setWhen(io.bus.cmd.ready)
    val resetIt = RegInit(False)
    val haltIt = RegInit(False)
    val flushIt = RegNext(False)
    val stepIt = RegInit(False)

    val isPipActive = RegNext(List(fetch,decode,execute,memory,writeBack).map(_.arbitration.isValid).orR)
    val isPipBusy = isPipActive || RegNext(isPipActive)
    val haltedByBreak = RegInit(False)

    when(io.bus.cmd.valid) {
      switch(io.bus.cmd.address(2 downto 2)) {
        is(0){
          when(io.bus.cmd.wr){
            flushIt := io.bus.cmd.data(2)
            stepIt := io.bus.cmd.data(4)
            resetIt setWhen(io.bus.cmd.data(16)) clearWhen(io.bus.cmd.data(24))
            haltIt  setWhen(io.bus.cmd.data(17)) clearWhen(io.bus.cmd.data(25))
            haltedByBreak clearWhen(io.bus.cmd.data(25))
          } otherwise{
            busReadDataReg(0) := resetIt
            busReadDataReg(1) := haltIt
            busReadDataReg(2) := isPipBusy
            busReadDataReg(3) := haltedByBreak
            busReadDataReg(4) := stepIt
          }
        }
        is(1) {
          when(io.bus.cmd.wr){
            insertDecodeInstruction := True
            val injectedInstructionSent = RegNext(decode.arbitration.isFiring) init(False)
            decode.arbitration.haltIt setWhen(!injectedInstructionSent && !RegNext(decode.arbitration.isValid).init(False))
            decode.arbitration.isValid setWhen(firstCycle)
            io.bus.cmd.ready := injectedInstructionSent
          }
        }
      }
    }

    //Assign the bus write data into the register who drive the decode instruction, even if it need to cross some hierarchy (caches)
    Component.current.addPrePopTask(() => {
      val reg = decode.input(INSTRUCTION).getDrivingReg
      reg.component.rework{
        when(insertDecodeInstruction.pull()) {
          reg := io.bus.cmd.data.pull()
        }
      }
    })


    when(execute.arbitration.isFiring && execute.input(IS_EBREAK)){
      prefetch.arbitration.haltIt := True
      decode.arbitration.flushAll := True
      haltIt := True
      haltedByBreak := True
    }

    when(haltIt){
      prefetch.arbitration.haltIt := True
    }

    when(stepIt && prefetch.arbitration.isFiring){
      haltIt := True
    }

    io.resetOut := RegNext(resetIt)

    when(haltIt || stepIt){
      service(classOf[InterruptionInhibitor]).inhibateInterrupts()
    }
  }
}
