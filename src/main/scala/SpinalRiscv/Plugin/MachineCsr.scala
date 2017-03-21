package SpinalRiscv.Plugin

import spinal.core._
import spinal.lib._
import SpinalRiscv._
import SpinalRiscv.Riscv._

import scala.collection.mutable.ArrayBuffer

/**
 * Created by spinalvm on 21.03.17.
 */



case class ExceptionPortInfo(port : Flow[UInt],stage : Stage)
case class MachineCsrConfig()

class MachineCsr extends Plugin[VexRiscv] with ExceptionService{
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  def exceptionCodeWidth = 4
  override def newExceptionPort(stage : Stage) = {
    val interface = Flow(UInt(exceptionCodeWidth bits))
    exceptionPortsInfos += ExceptionPortInfo(interface,stage)
    interface
  }

  var jumpInterface : Flow[UInt] = null

  object EnvCtrlEnum extends SpinalEnum(binarySequential){
    val NONE, EBREAK, ECALL, MRET = newElement()
  }

  object ENV_CTRL extends Stageable(EnvCtrlEnum())
  object EXCEPTION extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    val defaultEnv = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True
    )

    val defaultActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> False
    )

    val nonImmediatActions = defaultActions ++ List(
      SRC1_CTRL                -> Src1CtrlEnum.RS
    )

    val immediatActions = defaultActions

    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(ENV_CTRL, EnvCtrlEnum.NONE)
    decoderService.add(List(
      CSRRW  -> nonImmediatActions,
      CSRRS  -> nonImmediatActions,
      CSRRC  -> nonImmediatActions,
      CSRRWI -> immediatActions,
      CSRRSI -> immediatActions,
      CSRRCI -> immediatActions,
      ECALL  -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.ECALL)),
      EBREAK -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.EBREAK)),
      MRET   -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.MRET))
    ))

    pipeline.fetch.insert(EXCEPTION) := False

    val  pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(pipeline.execute)
    jumpInterface.valid := False
    jumpInterface.payload.assignDontCare()
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._



    val mtvec = UInt(32 bits)
    val mepc = Reg(UInt(32 bits))

    val mstatus = new Area{
      val MIE, MPIE = Reg(Bool) init(False)
    }

    val pipelineLiberator = new Area{
      val enable = False
      decode.arbitration.haltIt setWhen(enable)
      val done = ! List(fetch, decode, execute, memory, writeBack).map(_.arbitration.isValid).orR
    }

    val exceptionPortCtrl = new Area{
      val pipelineHasException = List(fetch, decode, execute, memory, writeBack).map(s => s.arbitration.isValid && s.input(EXCEPTION)).orR
      decode.arbitration.haltIt setWhen(pipelineHasException)

      val groupedByStage = exceptionPortsInfos.map(_.stage).distinct.map(s => {
        val stagePortsInfos = exceptionPortsInfos.filter(_.stage == s)
        val stagePort = stagePortsInfos.length match{
          case 1 => stagePortsInfos.head.port
          case _ => {
            val groupedPort = Flow(UInt(exceptionCodeWidth bits))
            val valids = stagePortsInfos.map(_.port.valid)
            val codes = stagePortsInfos.map(_.port.payload)
            groupedPort.valid := valids.orR
            groupedPort.payload := MuxOH(stagePortsInfos.map(_.port.valid), codes)
            groupedPort
          }
        }
        ExceptionPortInfo(stagePort,s)
      })
      val sortedByStage = groupedByStage.sortWith((a, b) => pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage))

      for(portInfo <- sortedByStage; port = portInfo.port ; stage = portInfo.stage){
        when(port.valid){
          stages(indexOf(stage)).arbitration.flushIt := True
          stage.input(EXCEPTION) := True
        }
      }
    }

    val interrupt = False
    val exception = writeBack.arbitration.isValid && writeBack.input(EXCEPTION)

    when(mstatus.MIE){
      pipelineLiberator.enable := True
      when(exception || (interrupt && pipelineLiberator.done)){
        jumpInterface.valid := True
        jumpInterface.payload := mtvec
        mstatus.MIE := False
        mstatus.MPIE := mstatus.MIE
        mepc := exception ? writeBack.input(PC) | prefetch.input(PC_CALC_WITHOUT_JUMP)
      }
    }

    when(memory.arbitration.isFiring && memory.input(ENV_CTRL) === EnvCtrlEnum.MRET){
      jumpInterface.valid := True
      jumpInterface.payload := mepc
      mstatus.MIE := mstatus.MPIE
    }
  }
}
