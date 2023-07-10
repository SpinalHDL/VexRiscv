package vexriscv

import java.util

import spinal.core._
import spinal.lib._

import scala.beans.BeanProperty

trait JumpService{
  def createJumpInterface(stage : Stage, priority : Int = 0) : Flow[UInt] //High priority win
}

trait IBusFetcher{
  def haltIt() : Unit
  def incoming() : Bool
  def pcValid(stage : Stage) : Bool
  def getInjectionPort() : Stream[Bits]
  def withRvc() : Boolean
  def forceNoDecode() : Unit
}


trait DecoderService{
  def add(key : MaskedLiteral,values : Seq[(Stageable[_ <: BaseType],Any)])
  def add(encoding :Seq[(MaskedLiteral,Seq[(Stageable[_ <: BaseType],Any)])])
  def addDefault(key : Stageable[_ <: BaseType], value : Any)
  def forceIllegal() : Unit
}

case class ExceptionCause(codeWidth : Int) extends Bundle{
  val code = UInt(codeWidth bits)
  val badAddr = UInt(32 bits)

  def resizeCode(width : Int): ExceptionCause ={
    val ret = ExceptionCause(width)
    ret.badAddr := badAddr
    ret.code := code.resized
    ret
  }
}

trait ExceptionService{
  def newExceptionPort(stage : Stage, priority : Int = 0, codeWidth : Int = 4) : Flow[ExceptionCause]
  def isExceptionPending(stage : Stage) : Bool
}

trait PrivilegeService{
  def isUser() : Bool
  def isSupervisor() : Bool
  def isMachine() : Bool
  def forceMachine() : Unit

  def encodeBits() : Bits = {
    val encoded = Bits(2 bits)

    when(this.isUser()) {
      encoded := "00"
    }.elsewhen(this.isSupervisor()) {
      encoded := "01"
    }.otherwise {
      encoded := "11"
    }

    encoded
  }
}

case class PrivilegeServiceDefault() extends PrivilegeService{
  override def isUser(): Bool = False
  override def isSupervisor(): Bool = False
  override def isMachine(): Bool = True
  override def forceMachine(): Unit = {}
}

trait InterruptionInhibitor{
  def inhibateInterrupts() : Unit
}

trait ExceptionInhibitor{
  def inhibateException() : Unit
  def inhibateEbreakException() : Unit
}


trait RegFileService{
  def readStage() : Stage
}


case class MemoryTranslatorCmd() extends Bundle{
  val isValid = Bool
  val isStuck = Bool
  val virtualAddress  = UInt(32 bits)
  val bypassTranslation = Bool
}
case class MemoryTranslatorRsp(p : MemoryTranslatorBusParameter) extends Bundle{
  val physicalAddress = UInt(32 bits)
  val isIoAccess = Bool
  val isPaging = Bool
  val allowRead, allowWrite, allowExecute = Bool
  val exception = Bool
  val refilling = Bool
  val bypassTranslation = Bool
  val ways = Vec(MemoryTranslatorRspWay(), p.wayCount)
}
case class MemoryTranslatorRspWay() extends Bundle{
  val sel = Bool()
  val physical = UInt(32 bits)
}

case class MemoryTranslatorBusParameter(wayCount : Int = 0, latency : Int = 0)
case class MemoryTranslatorBus(p : MemoryTranslatorBusParameter) extends Bundle with IMasterSlave{
  val cmd = Vec(MemoryTranslatorCmd(), p.latency + 1)
  val rsp = MemoryTranslatorRsp(p)
  val end = Bool
  val busy = Bool

  override def asMaster() : Unit = {
    out(cmd, end)
    in(rsp, busy)
  }
}

trait MemoryTranslator{
  def newTranslationPort(priority : Int, args : Any) : MemoryTranslatorBus
}


trait ReportService{
  def add(that : (String,Object)) : Unit
}

class BusReport{
  @BeanProperty var kind = ""
  @BeanProperty var flushInstructions = new util.LinkedList[Int]()
  @BeanProperty var info : Object = null
}
class CacheReport {
  @BeanProperty var size = 0
  @BeanProperty var bytePerLine = 0
}

class DebugReport {
  @BeanProperty var hardwareBreakpointCount = 0
}