package vexriscv

import vexriscv.plugin._
import spinal.core._

import scala.collection.mutable.ArrayBuffer

object VexRiscvConfig{
  def apply(plugins : Seq[Plugin[VexRiscv]] = ArrayBuffer()) : VexRiscvConfig = {
    val config = VexRiscvConfig()
    config.plugins ++= plugins
    config
  }
}

case class VexRiscvConfig(){
  val plugins = ArrayBuffer[Plugin[VexRiscv]]()

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
  object INSTRUCTION_READY extends Stageable(Bool)
  object INSTRUCTION_ANTICIPATED extends Stageable(Bits(32 bits))
  object LEGAL_INSTRUCTION extends Stageable(Bool)
  object REGFILE_WRITE_VALID extends Stageable(Bool)
  object REGFILE_WRITE_DATA extends Stageable(Bits(32 bits))


  object SRC1   extends Stageable(Bits(32 bits))
  object SRC2   extends Stageable(Bits(32 bits))
  object SRC_ADD_SUB extends Stageable(Bits(32 bits))
  object SRC_ADD extends Stageable(Bits(32 bits))
  object SRC_SUB extends Stageable(Bits(32 bits))
  object SRC_LESS extends Stageable(Bool)
  object SRC_USE_SUB_LESS extends Stageable(Bool)
  object SRC_LESS_UNSIGNED extends Stageable(Bool)

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
    val RS, IMU, PC_INCREMENT = newElement()   //IMU, IMZ IMJB
  }

  object Src2CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMI, IMS, PC = newElement()
  }
  object SRC1_CTRL  extends Stageable(Src1CtrlEnum())
  object SRC2_CTRL  extends Stageable(Src2CtrlEnum())
}



object RVC_GEN extends PipelineConfig[Boolean]
class VexRiscv(val config : VexRiscvConfig) extends Component with Pipeline{
  type  T = VexRiscv
  import config._

  stages ++= List.fill(4)(new Stage())
  val /*prefetch :: fetch :: */decode :: execute :: memory :: writeBack :: Nil = stages.toList
  plugins ++= config.plugins

  //regression usage
  decode.input(config.INSTRUCTION).addAttribute(Verilator.public)
  decode.input(config.PC).addAttribute(Verilator.public)
  decode.arbitration.isValid.addAttribute(Verilator.public)
  decode.arbitration.flushAll.addAttribute(Verilator.public)
  decode.arbitration.haltItself.addAttribute(Verilator.public)
  writeBack.input(config.INSTRUCTION) keep() addAttribute(Verilator.public)
  writeBack.input(config.PC) keep() addAttribute(Verilator.public)
  writeBack.arbitration.isValid keep() addAttribute(Verilator.public)
  writeBack.arbitration.isFiring keep() addAttribute(Verilator.public)
  decode.arbitration.removeIt.noBackendCombMerge //Verilator perf
  memory.arbitration.removeIt.noBackendCombMerge
  execute.arbitration.flushAll.noBackendCombMerge

  this(RVC_GEN) = false
}


