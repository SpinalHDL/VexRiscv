package SpinalRiscv

import SpinalRiscv.Plugin.Plugin
import spinal.core._
import spinal.lib._
import scala.collection.mutable.ArrayBuffer

case class VexRiscvConfig(pcWidth : Int){
  val plugins = ArrayBuffer[Plugin[VexRiscv]]()
  //TODO apply defaults to decoder
  //Default Stageables
  object BYPASSABLE_EXECUTE_STAGE   extends Stageable(Bool)
  object BYPASSABLE_MEMORY_STAGE   extends Stageable(Bool)
  object REG1   extends Stageable(Bits(32 bits))
  object REG2   extends Stageable(Bits(32 bits))
  object REG1_USE extends Stageable(Bool)
  object REG2_USE extends Stageable(Bool)
  object RESULT extends Stageable(UInt(32 bits))
  object PC extends Stageable(UInt(pcWidth bits))
  object PC_CALC_WITHOUT_JUMP extends Stageable(UInt(pcWidth bits))
  object INSTRUCTION extends Stageable(Bits(32 bits))
  object LEGAL_INSTRUCTION extends Stageable(Bool)
  object REGFILE_WRITE_VALID extends Stageable(Bool)
  object REGFILE_WRITE_DATA extends Stageable(Bits(32 bits))

  object SRC1   extends Stageable(Bits(32 bits))
  object SRC2   extends Stageable(Bits(32 bits))
  object SRC_ADD_SUB extends Stageable(Bits(32 bits))
  object SRC_LESS extends Stageable(Bool)
  object SRC_USE_SUB_LESS extends Stageable(Bool)
  object SRC_LESS_UNSIGNED extends Stageable(Bool)


  object Src1CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMU, FOUR = newElement()   //IMU, IMZ IMJB
  }

  object Src2CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMI, IMS, PC = newElement()
  }
  object SRC1_CTRL  extends Stageable(Src1CtrlEnum())
  object SRC2_CTRL  extends Stageable(Src2CtrlEnum())
}



class VexRiscv(val config : VexRiscvConfig) extends Component with Pipeline{
  type  T = VexRiscv
  import config._

  stages ++= List.fill(6)(new Stage())
  val prefetch :: fetch :: decode :: execute :: memory :: writeBack :: Nil = stages.toList
  plugins ++= config.plugins

  //regression usage
  writeBack.input(config.INSTRUCTION) keep() addAttribute("verilator public")
  writeBack.input(config.PC) keep() addAttribute("verilator public")
  writeBack.arbitration.isValid keep() addAttribute("verilator public")
}


