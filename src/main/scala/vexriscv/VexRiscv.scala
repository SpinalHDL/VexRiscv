package vexriscv

import vexriscv.plugin._
import spinal.core._

import scala.collection.mutable.ArrayBuffer

object VexRiscvConfig{
  def apply(withMemoryStage : Boolean, withWriteBackStage : Boolean, plugins : Seq[Plugin[VexRiscv]]): VexRiscvConfig = {
    val config = VexRiscvConfig()
    config.plugins ++= plugins
    config.withMemoryStage = withMemoryStage
    config.withWriteBackStage = withWriteBackStage
    config
  }

  def apply(plugins : Seq[Plugin[VexRiscv]] = ArrayBuffer()) : VexRiscvConfig = apply(true,true,plugins)
}

case class VexRiscvConfig(){
  var withMemoryStage = true
  var withWriteBackStage = true
  val plugins = ArrayBuffer[Plugin[VexRiscv]]()

  def add(that : Plugin[VexRiscv]) : this.type = {plugins += that;this}

  //Default Stageables
  object IS_RVC extends Stageable(Bool)
  object BYPASSABLE_EXECUTE_STAGE   extends Stageable(Bool)
  object BYPASSABLE_MEMORY_STAGE   extends Stageable(Bool)
  object RS1   extends Stageable(Bits(32 bits))
  object RS2   extends Stageable(Bits(32 bits))
  object RS1_USE extends Stageable(Bool)
  object RS2_USE extends Stageable(Bool)
  object RESULT extends Stageable(UInt(32 bits))
  object PC extends Stageable(UInt(32 bits))
  object PC_CALC_WITHOUT_JUMP extends Stageable(UInt(32 bits))
  object INSTRUCTION extends Stageable(Bits(32 bits))
  object INSTRUCTION_ANTICIPATED extends Stageable(Bits(32 bits))
  object LEGAL_INSTRUCTION extends Stageable(Bool)
  object REGFILE_WRITE_VALID extends Stageable(Bool)
  object REGFILE_WRITE_DATA extends Stageable(Bits(32 bits))

  object MPP extends PipelineThing[UInt]
  object DEBUG_BYPASS_CACHE extends PipelineThing[Bool]

  object SRC1   extends Stageable(Bits(32 bits))
  object SRC2   extends Stageable(Bits(32 bits))
  object SRC_ADD_SUB extends Stageable(Bits(32 bits))
  object SRC_ADD extends Stageable(Bits(32 bits))
  object SRC_SUB extends Stageable(Bits(32 bits))
  object SRC_LESS extends Stageable(Bool)
  object SRC_USE_SUB_LESS extends Stageable(Bool)
  object SRC_LESS_UNSIGNED extends Stageable(Bool)
  object SRC_ADD_ZERO extends Stageable(Bool)


  object HAS_SIDE_EFFECT extends Stageable(Bool)

  //Formal verification purposes
  object FORMAL_HALT       extends Stageable(Bool)
  object FORMAL_PC_NEXT    extends Stageable(UInt(32 bits))
  object FORMAL_MEM_ADDR   extends Stageable(UInt(32 bits))
  object FORMAL_MEM_RMASK  extends Stageable(Bits(4 bits))
  object FORMAL_MEM_WMASK  extends Stageable(Bits(4 bits))
  object FORMAL_MEM_RDATA  extends Stageable(Bits(32 bits))
  object FORMAL_MEM_WDATA  extends Stageable(Bits(32 bits))
  object FORMAL_INSTRUCTION extends Stageable(Bits(32 bits))


  object Src1CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMU, PC_INCREMENT, URS1 = newElement()   //IMU, IMZ IMJB
  }

  object Src2CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMI, IMS, PC = newElement() //TODO remplacing ZERO could avoid 32 muxes if SRC_ADD can be disabled
  }
  object SRC1_CTRL  extends Stageable(Src1CtrlEnum())
  object SRC2_CTRL  extends Stageable(Src2CtrlEnum())
}



object RVC_GEN extends PipelineThing[Boolean]
class VexRiscv(val config : VexRiscvConfig) extends Component with Pipeline{
  type  T = VexRiscv
  import config._

  //Define stages
  def newStage(): Stage = { val s = new Stage; stages += s; s }
  val decode    = newStage()
  val execute   = newStage()
  val memory    = ifGen(config.withMemoryStage)    (newStage())
  val writeBack = ifGen(config.withWriteBackStage) (newStage())

  def stagesFromExecute = stages.dropWhile(_ != execute)

  plugins ++= config.plugins

  //regression usage
  val lastStageInstruction = CombInit(stages.last.input(config.INSTRUCTION)) keep() addAttribute (Verilator.public)
  val lastStagePc = CombInit(stages.last.input(config.PC)) keep() addAttribute (Verilator.public)
  val lastStageIsValid = CombInit(stages.last.arbitration.isValid) keep() addAttribute (Verilator.public)
  val lastStageIsFiring = CombInit(stages.last.arbitration.isFiring) keep() addAttribute (Verilator.public)

  //Verilator perf
  decode.arbitration.removeIt.noBackendCombMerge
  if(withMemoryStage){
    memory.arbitration.removeIt.noBackendCombMerge
  }
  execute.arbitration.flushNext.noBackendCombMerge

  this(RVC_GEN) = false
}


