package SpinalRiscv

import spinal.core._
import spinal.lib._

trait PcManagerService{
  def createJumpInterface(stage : Stage) : Flow[UInt]
}

trait DecoderService{
  def add(key : MaskedLiteral,values : Seq[(Stageable[_ <: BaseType],Any)])
  def add(encoding :Seq[(MaskedLiteral,Seq[(Stageable[_ <: BaseType],Any)])])
  def addDefault(key : Stageable[_ <: BaseType], value : Any)
}