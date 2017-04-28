package SpinalRiscv

import spinal.core._
import spinal.lib._

trait JumpService{
  def createJumpInterface(stage : Stage) : Flow[UInt]
}

trait DecoderService{
  def add(key : MaskedLiteral,values : Seq[(Stageable[_ <: BaseType],Any)])
  def add(encoding :Seq[(MaskedLiteral,Seq[(Stageable[_ <: BaseType],Any)])])
  def addDefault(key : Stageable[_ <: BaseType], value : Any)
}

case class ExceptionCause() extends Bundle{
  val code = UInt(4 bits)
  val badAddr = UInt(32 bits)
}

trait ExceptionService{
  def newExceptionPort(stage : Stage, priority : Int = 0) : Flow[ExceptionCause]
}

case class MemoryTranslatorCmd() extends Bundle{
  val isValid = Bool
  val virtualAddress  = UInt(32 bits)
}
case class MemoryTranslatorRsp() extends Bundle{
  val physicalAddress = UInt(32 bits)
  val allowRead, allowWrite, allowExecute = Bool
}

case class MemoryTranslatorBus() extends Bundle with IMasterSlave{
  val cmd = MemoryTranslatorCmd()
  val rsp = MemoryTranslatorRsp()

  override def asMaster() : Unit = {
    out(cmd)
    in(rsp)
  }
}

trait MemoryTranslator{
  def newTranslationPort(stage : Stage, cacheSize : Int) : MemoryTranslatorBus
}
