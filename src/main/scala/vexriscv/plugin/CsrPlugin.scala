package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._
import vexriscv.plugin.IntAluPlugin.{ALU_BITWISE_CTRL, ALU_CTRL, AluBitwiseCtrlEnum, AluCtrlEnum}

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable
import spinal.core.sim._
import spinal.lib.cpu.riscv.debug._
import spinal.lib.fsm.{State, StateMachine}

/**
  * Created by spinalvm on 21.03.17.
  */

trait CsrAccess{
  def canWrite : Boolean = false
  def canRead : Boolean = false
}
object CsrAccess {
  object WRITE_ONLY extends CsrAccess{
    override def canWrite : Boolean = true
  }
  object READ_ONLY extends CsrAccess{
    override def canRead : Boolean = true
  }
  object READ_WRITE extends CsrAccess{
    override def canWrite : Boolean = true
    override def canRead : Boolean = true
  }
  object NONE extends CsrAccess
}



case class ExceptionPortInfo(port : Flow[ExceptionCause],stage : Stage, priority : Int, codeWidth : Int)
case class CsrPluginConfig(
                            catchIllegalAccess  : Boolean,
                            var mvendorid       : BigInt,
                            var marchid         : BigInt,
                            var mimpid          : BigInt,
                            var mhartid         : BigInt,
                            misaExtensionsInit  : Int,
                            misaAccess          : CsrAccess,
                            mtvecAccess         : CsrAccess,
                            var mtvecInit       : BigInt,
                            mepcAccess          : CsrAccess,
                            mscratchGen         : Boolean,
                            mcauseAccess        : CsrAccess,
                            mbadaddrAccess      : CsrAccess,
                            mcycleAccess        : CsrAccess,
                            minstretAccess      : CsrAccess,
                            ucycleAccess        : CsrAccess,
                            uinstretAccess      : CsrAccess = CsrAccess.NONE,
                            wfiGenAsWait        : Boolean,
                            ecallGen            : Boolean,
                            xtvecModeGen        : Boolean = false,
                            noCsrAlu            : Boolean = false,
                            wfiGenAsNop         : Boolean = false,
                            ebreakGen           : Boolean = false,
                            userGen             : Boolean = false,
                            supervisorGen       : Boolean = false,
                            sscratchGen         : Boolean = false,
                            stvecAccess         : CsrAccess = CsrAccess.NONE,
                            sepcAccess          : CsrAccess = CsrAccess.NONE,
                            scauseAccess        : CsrAccess = CsrAccess.NONE,
                            sbadaddrAccess      : CsrAccess = CsrAccess.NONE,
                            scycleAccess        : CsrAccess = CsrAccess.NONE,
                            sinstretAccess      : CsrAccess = CsrAccess.NONE,
                            satpAccess          : CsrAccess = CsrAccess.NONE,
                            utimeAccess         :CsrAccess = CsrAccess.NONE,
                            medelegAccess       : CsrAccess = CsrAccess.NONE,
                            midelegAccess       : CsrAccess = CsrAccess.NONE,
                            withExternalMhartid : Boolean = false,
                            mhartidWidth        : Int = 0,
                            pipelineCsrRead     : Boolean = false,
                            pipelinedInterrupt  : Boolean = true,
                            csrOhDecoder        : Boolean = true,
                            deterministicInteruptionEntry : Boolean = false, //Only used for simulatation purposes
                            wfiOutput           : Boolean = false,
                            exportPrivilege     : Boolean = false,
                            var withPrivilegedDebug : Boolean = false, //For the official RISC-V debug spec implementation
                            var debugTriggers       : Int     = 2
                          ){
  assert(!ucycleAccess.canWrite)
  def privilegeGen = userGen || supervisorGen || withPrivilegedDebug
  def noException = this.copy(ecallGen = false, ebreakGen = false, catchIllegalAccess = false)
  def noExceptionButEcall = this.copy(ecallGen = true, ebreakGen = false, catchIllegalAccess = false)
  def withEbreak = ebreakGen || withPrivilegedDebug
}

object CsrPluginConfig{
  def all : CsrPluginConfig = all(0x00000020l)
  def small : CsrPluginConfig = small(0x00000020l)
  def smallest : CsrPluginConfig = smallest(0x00000020l)

  def openSbi(mhartid : Int, misa : Int) = CsrPluginConfig(
    catchIllegalAccess  = true,
    mvendorid           = 0,
    marchid             = 0,
    mimpid              = 0,
    mhartid             = mhartid,
    misaExtensionsInit  = misa,
    misaAccess          = CsrAccess.READ_ONLY,
    mtvecAccess         = CsrAccess.READ_WRITE,   //Could have been WRITE_ONLY :(
    mtvecInit           = null,
    mepcAccess          = CsrAccess.READ_WRITE,
    mscratchGen         = true,
    mcauseAccess        = CsrAccess.READ_ONLY,
    mbadaddrAccess      = CsrAccess.READ_ONLY,
    mcycleAccess        = CsrAccess.NONE,
    minstretAccess      = CsrAccess.NONE,
    ucycleAccess        = CsrAccess.NONE,
    wfiGenAsWait        = true,
    ecallGen            = true,
    xtvecModeGen        = false,
    noCsrAlu            = false,
    wfiGenAsNop         = false,
    ebreakGen           = true,
    userGen             = true,
    supervisorGen       = true,
    sscratchGen         = true,
    stvecAccess         = CsrAccess.READ_WRITE,
    sepcAccess          = CsrAccess.READ_WRITE,
    scauseAccess        = CsrAccess.READ_WRITE,
    sbadaddrAccess      = CsrAccess.READ_WRITE,
    scycleAccess        = CsrAccess.NONE,
    sinstretAccess      = CsrAccess.NONE,
    satpAccess          = CsrAccess.NONE,
    medelegAccess       = CsrAccess.READ_WRITE,  //Could have been WRITE_ONLY :(
    midelegAccess       = CsrAccess.READ_WRITE,  //Could have been WRITE_ONLY :(
    pipelineCsrRead     = false,
    deterministicInteruptionEntry  = false
  )

  def linuxMinimal(mtVecInit : BigInt) = CsrPluginConfig(
    catchIllegalAccess  = true,
    mvendorid           = 1,
    marchid             = 2,
    mimpid              = 3,
    mhartid             = 0,
    misaExtensionsInit  = 0, //TODO
    misaAccess          = CsrAccess.NONE, //Read required by some regressions
    mtvecAccess         = CsrAccess.WRITE_ONLY, //Read required by some regressions
    mtvecInit           = mtVecInit,
    mepcAccess          = CsrAccess.READ_WRITE,
    mscratchGen         = true,
    mcauseAccess        = CsrAccess.READ_ONLY,
    mbadaddrAccess      = CsrAccess.READ_ONLY,
    mcycleAccess        = CsrAccess.NONE,
    minstretAccess      = CsrAccess.NONE,
    ucycleAccess        = CsrAccess.NONE,
    uinstretAccess      = CsrAccess.NONE,
    wfiGenAsWait        = true,
    ecallGen            = true,
    xtvecModeGen        = false,
    noCsrAlu            = false,
    wfiGenAsNop         = false,
    ebreakGen           = true,
    userGen             = true,
    supervisorGen       = true,
    sscratchGen         = true,
    stvecAccess         = CsrAccess.READ_WRITE,
    sepcAccess          = CsrAccess.READ_WRITE,
    scauseAccess        = CsrAccess.READ_WRITE,
    sbadaddrAccess      = CsrAccess.READ_WRITE,
    scycleAccess        = CsrAccess.NONE,
    sinstretAccess      = CsrAccess.NONE,
    satpAccess          = CsrAccess.NONE, //Implemented into the MMU plugin
    medelegAccess       = CsrAccess.WRITE_ONLY,
    midelegAccess       = CsrAccess.WRITE_ONLY,
    pipelineCsrRead     = false,
    deterministicInteruptionEntry  = false
  )


  def linuxFull(mtVecInit : BigInt) = CsrPluginConfig(
    catchIllegalAccess  = true,
    mvendorid           = 1,
    marchid             = 2,
    mimpid              = 3,
    mhartid             = 0,
    misaExtensionsInit  = 0, //TODO
    misaAccess          = CsrAccess.READ_WRITE,
    mtvecAccess         = CsrAccess.READ_WRITE,
    mtvecInit           = mtVecInit,
    mepcAccess          = CsrAccess.READ_WRITE,
    mscratchGen         = true,
    mcauseAccess        = CsrAccess.READ_WRITE,
    mbadaddrAccess      = CsrAccess.READ_WRITE,
    mcycleAccess        = CsrAccess.READ_WRITE,
    minstretAccess      = CsrAccess.READ_WRITE,
    ucycleAccess        = CsrAccess.READ_ONLY,
    uinstretAccess      = CsrAccess.READ_ONLY,
    wfiGenAsWait        = true,
    ecallGen            = true,
    xtvecModeGen        = false,
    noCsrAlu            = false,
    wfiGenAsNop         = false,
    ebreakGen           = false,
    userGen             = true,
    supervisorGen       = true,
    sscratchGen         = true,
    stvecAccess         = CsrAccess.READ_WRITE,
    sepcAccess          = CsrAccess.READ_WRITE,
    scauseAccess        = CsrAccess.READ_WRITE,
    sbadaddrAccess      = CsrAccess.READ_WRITE,
    scycleAccess        = CsrAccess.READ_WRITE,
    sinstretAccess      = CsrAccess.READ_WRITE,
    satpAccess          = CsrAccess.NONE, //Implemented into the MMU plugin
    medelegAccess       = CsrAccess.READ_WRITE,
    midelegAccess       = CsrAccess.READ_WRITE,
    pipelineCsrRead     = false,
    deterministicInteruptionEntry  = false
  )

  def all(mtvecInit : BigInt) : CsrPluginConfig = CsrPluginConfig(
    catchIllegalAccess = true,
    mvendorid          = 11,
    marchid            = 22,
    mimpid             = 33,
    mhartid            = 0,
    misaExtensionsInit = 66,
    misaAccess         = CsrAccess.READ_WRITE,
    mtvecAccess        = CsrAccess.READ_WRITE,
    mtvecInit          = mtvecInit,
    mepcAccess         = CsrAccess.READ_WRITE,
    mscratchGen        = true,
    mcauseAccess       = CsrAccess.READ_WRITE,
    mbadaddrAccess     = CsrAccess.READ_WRITE,
    mcycleAccess       = CsrAccess.READ_WRITE,
    minstretAccess     = CsrAccess.READ_WRITE,
    ecallGen           = true,
    wfiGenAsWait       = true,
    ucycleAccess       = CsrAccess.READ_ONLY,
    uinstretAccess     = CsrAccess.READ_ONLY
  )

  def all2(mtvecInit : BigInt) : CsrPluginConfig = CsrPluginConfig(
    catchIllegalAccess = true,
    mvendorid      = 11,
    marchid        = 22,
    mimpid         = 33,
    mhartid        = 0,
    misaExtensionsInit = 66,
    misaAccess     = CsrAccess.READ_WRITE,
    mtvecAccess    = CsrAccess.READ_WRITE,
    mtvecInit      = mtvecInit,
    mepcAccess     = CsrAccess.READ_WRITE,
    mscratchGen    = true,
    mcauseAccess   = CsrAccess.READ_WRITE,
    mbadaddrAccess = CsrAccess.READ_WRITE,
    mcycleAccess   = CsrAccess.READ_WRITE,
    minstretAccess = CsrAccess.READ_WRITE,
    ecallGen       = true,
    wfiGenAsWait         = true,
    ucycleAccess   = CsrAccess.READ_ONLY,
    uinstretAccess = CsrAccess.READ_ONLY,
    supervisorGen  = true,
    sscratchGen    = true,
    stvecAccess    = CsrAccess.READ_WRITE,
    sepcAccess     = CsrAccess.READ_WRITE,
    scauseAccess   = CsrAccess.READ_WRITE,
    sbadaddrAccess = CsrAccess.READ_WRITE,
    scycleAccess   = CsrAccess.READ_WRITE,
    sinstretAccess = CsrAccess.READ_WRITE,
    satpAccess     = CsrAccess.READ_WRITE,
    medelegAccess = CsrAccess.READ_WRITE,
    midelegAccess = CsrAccess.READ_WRITE
  )

  def small(mtvecInit : BigInt)  = CsrPluginConfig(
    catchIllegalAccess = false,
    mvendorid      = null,
    marchid        = null,
    mimpid         = null,
    mhartid        = null,
    misaExtensionsInit = 66,
    misaAccess     = CsrAccess.NONE,
    mtvecAccess    = CsrAccess.NONE,
    mtvecInit      = mtvecInit,
    mepcAccess     = CsrAccess.READ_WRITE,
    mscratchGen    = false,
    mcauseAccess   = CsrAccess.READ_ONLY,
    mbadaddrAccess = CsrAccess.READ_ONLY,
    mcycleAccess   = CsrAccess.NONE,
    minstretAccess = CsrAccess.NONE,
    ecallGen       = false,
    wfiGenAsWait         = false,
    ucycleAccess   = CsrAccess.NONE,
    uinstretAccess = CsrAccess.NONE
  )

  def smallest(mtvecInit : BigInt)  = CsrPluginConfig(
    catchIllegalAccess = false,
    mvendorid      = null,
    marchid        = null,
    mimpid         = null,
    mhartid        = null,
    misaExtensionsInit = 66,
    misaAccess     = CsrAccess.NONE,
    mtvecAccess    = CsrAccess.NONE,
    mtvecInit      = mtvecInit,
    mepcAccess     = CsrAccess.NONE,
    mscratchGen    = false,
    mcauseAccess   = CsrAccess.READ_ONLY,
    mbadaddrAccess = CsrAccess.NONE,
    mcycleAccess   = CsrAccess.NONE,
    minstretAccess = CsrAccess.NONE,
    ecallGen       = false,
    wfiGenAsWait         = false,
    ucycleAccess   = CsrAccess.NONE,
    uinstretAccess = CsrAccess.NONE
  )

  def secure(mtvecInit : BigInt) = CsrPluginConfig(
    catchIllegalAccess = true,
    mvendorid           = 1,
    marchid             = 2,
    mimpid              = 3,
    mhartid             = 0,
    misaExtensionsInit  = 0x101064, // RV32GCFMU
    misaAccess          = CsrAccess.READ_WRITE,
    mtvecAccess         = CsrAccess.READ_WRITE,
    mtvecInit           = mtvecInit,
    mepcAccess          = CsrAccess.READ_WRITE,
    mscratchGen         = true,
    mcauseAccess        = CsrAccess.READ_WRITE,
    mbadaddrAccess      = CsrAccess.READ_WRITE,
    mcycleAccess        = CsrAccess.READ_WRITE,
    minstretAccess      = CsrAccess.READ_WRITE,
    ucycleAccess        = CsrAccess.READ_ONLY,
    uinstretAccess      = CsrAccess.READ_ONLY,
    wfiGenAsWait        = true,
    ecallGen            = true,
    userGen             = true,
    medelegAccess       = CsrAccess.READ_WRITE,
    midelegAccess       = CsrAccess.READ_WRITE
  )

}
case class CsrWrite(that : Data, bitOffset : Int)
case class CsrRead(that : Data , bitOffset : Int)
case class CsrReadToWriteOverride(that : Data, bitOffset : Int) //Used for special cases, as MIP where there shadow stuff
case class CsrOnWrite(doThat :() => Unit)
case class CsrDuringWrite(doThat :() => Unit)
case class CsrDuringRead(doThat :() => Unit)
case class CsrDuring(doThat :() => Unit)
case class CsrOnRead(doThat : () => Unit)


case class CsrMapping() extends Area with CsrInterface {
  val mapping = mutable.LinkedHashMap[Int,ArrayBuffer[Any]]()
  val always = ArrayBuffer[Any]()
  val readDataSignal, readDataInit, writeDataSignal = Bits(32 bits)
  val allowCsrSignal = False
  val hazardFree = Bool()
  val doForceFailCsr = False

  readDataSignal := readDataInit
  def addMappingAt(address : Int,that : Any) = mapping.getOrElseUpdate(address,new ArrayBuffer[Any]) += that
  override def r(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrRead(that,bitOffset))
  override def w(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrWrite(that,bitOffset))
  override def r2w(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrReadToWriteOverride(that,bitOffset))
  override def onWrite(csrAddress: Int)(body: => Unit): Unit = addMappingAt(csrAddress, CsrOnWrite(() => body))
  override def duringWrite(csrAddress: Int)(body: => Unit): Unit = addMappingAt(csrAddress, CsrDuringWrite(() => body))
  override def duringRead(csrAddress: Int)(body: => Unit): Unit = addMappingAt(csrAddress, CsrDuringRead(() => body))
  override def during(csrAddress: Int)(body: => Unit): Unit = addMappingAt(csrAddress, CsrDuring(() => body))
  override def onRead(csrAddress: Int)(body: => Unit): Unit =  addMappingAt(csrAddress, CsrOnRead(() => {body}))
  override def duringAny(): Bool = ???
  override def duringAnyRead(body: => Unit) : Unit = always += CsrDuringRead(() => body)
  override def duringAnyWrite(body: => Unit) : Unit = always += CsrDuringWrite(() => body)
  override def onAnyRead(body: => Unit) : Unit = always += CsrOnRead(() => body)
  override def onAnyWrite(body: => Unit) : Unit = always += CsrOnWrite(() => body)
  override def readData() = readDataSignal
  override def writeData() = writeDataSignal
  override def allowCsr() = allowCsrSignal := True
  override def isHazardFree() = hazardFree
  override def forceFailCsr() = doForceFailCsr := True
  override def inDebugMode(): Bool = ???
}


trait CsrInterface{
  def onWrite(csrAddress : Int)(doThat : => Unit) : Unit
  def onRead(csrAddress : Int)(doThat : => Unit) : Unit
  def duringWrite(csrAddress: Int)(body: => Unit): Unit
  def duringRead(csrAddress: Int)(body: => Unit): Unit
  def during(csrAddress: Int)(body: => Unit): Unit
  def duringAny(): Bool
  def r(csrAddress : Int, bitOffset : Int, that : Data): Unit
  def w(csrAddress : Int, bitOffset : Int, that : Data): Unit
  def rw(csrAddress : Int, bitOffset : Int,that : Data): Unit ={
    r(csrAddress,bitOffset,that)
    w(csrAddress,bitOffset,that)
  }
  def duringAnyRead(body: => Unit) : Unit //Called all the durration of a Csr write instruction in the execute stage
  def duringAnyWrite(body: => Unit) : Unit //same than above for read
  def onAnyRead(body: => Unit) : Unit
  def onAnyWrite(body: => Unit) : Unit
  def allowCsr() : Unit  //In case your csr do not use the regular API with csrAddress but is implemented using "side channels", you can call that if the current csr is implemented
  def isHazardFree() : Bool // You should not have any side effect nor use readData() until this return True
  def forceFailCsr() : Unit

  def r2w(csrAddress : Int, bitOffset : Int,that : Data): Unit

  def rw(csrAddress : Int, thats : (Int, Data)*) : Unit = for(that <- thats) rw(csrAddress,that._1, that._2)
  def w(csrAddress : Int, thats : (Int, Data)*) : Unit = for(that <- thats) w(csrAddress,that._1, that._2)
  def r(csrAddress : Int, thats : (Int, Data)*) : Unit = for(that <- thats) r(csrAddress,that._1, that._2)
  def rw[T <: Data](csrAddress : Int, that : T): Unit = rw(csrAddress,0,that)
  def w[T <: Data](csrAddress : Int, that : T): Unit = w(csrAddress,0,that)
  def r [T <: Data](csrAddress : Int, that : T): Unit = r(csrAddress,0,that)
  def isWriting(csrAddress : Int) : Bool = {
    val ret = False
    onWrite(csrAddress){
      ret := True
    }
    ret
  }

  def isReading(csrAddress : Int) : Bool = {
    val ret = False
    onRead(csrAddress){
      ret := True
    }
    ret
  }

  def readData() : Bits //Return the 32 bits internal signal of the CsrPlugin for you to override (if you want)
  def writeData() : Bits //Return the 32 bits value that the CsrPlugin want to write in the CSR (depend on readData combinatorialy)
  def inDebugMode() : Bool
}


trait IContextSwitching{
  def isContextSwitching : Bool
}
trait IWake{
  def askWake() : Unit
}

class CsrPlugin(val config: CsrPluginConfig) extends Plugin[VexRiscv] with ExceptionService with PrivilegeService with InterruptionInhibitor with ExceptionInhibitor with IContextSwitching with CsrInterface with IWake with VexRiscvRegressionArg {
  import config._
  import CsrAccess._

  assert(!(wfiGenAsNop && wfiGenAsWait))

  def xlen = 32

  //Mannage ExceptionService calls
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  override def newExceptionPort(stage : Stage, priority : Int = 0, codeWidth : Int = 4) = {
    val interface = Flow(ExceptionCause(codeWidth))
    exceptionPortsInfos += ExceptionPortInfo(interface,stage,priority,codeWidth)
    interface
  }


  override def getVexRiscvRegressionArgs() = List(s"SUPERVISOR=${if(config.supervisorGen) "yes" else "no"} CSR=yes")

  var exceptionPendings : Vec[Bool] = null
  override def isExceptionPending(stage : Stage): Bool = exceptionPendings(pipeline.stages.indexOf(stage))

  var redoInterface : Flow[UInt] = null
  var jumpInterface : Flow[UInt] = null
  var timerInterrupt, externalInterrupt, softwareInterrupt : Bool = null
  var externalInterruptS : Bool = null
  var forceMachineWire : Bool = null
  var privilege : UInt = null
  var selfException : Flow[ExceptionCause] = null
  var contextSwitching : Bool = null
  var thirdPartyWake : Bool = null
  var inWfi : Bool = null
  var externalMhartId : UInt = null
  var utime : UInt = null
  var stoptime : Bool = null
  var xretAwayFromMachine : Bool = null

  var debugBus : DebugHartBus = null
  var debugMode : Bool = null
  var injectionPort : Stream[Bits] = null

  override def askWake(): Unit = thirdPartyWake := True

  override def isContextSwitching = contextSwitching

  override def inDebugMode(): Bool = if(withPrivilegedDebug) debugMode else False

  object EnvCtrlEnum extends SpinalEnum(binarySequential){
    val NONE, XRET = newElement()
    val WFI = if(wfiGenAsWait) newElement() else null
    val ECALL = if(ecallGen) newElement() else null
    val EBREAK = if(withEbreak) newElement() else null
  }

  object ENV_CTRL extends Stageable(EnvCtrlEnum())
  object IS_CSR extends Stageable(Bool)
  object RESCHEDULE_NEXT extends Stageable(Bool)
  object CSR_WRITE_OPCODE extends Stageable(Bool)
  object CSR_READ_OPCODE extends Stageable(Bool)
  object PIPELINED_CSR_READ extends Stageable(Bits(32 bits))

  var allowInterrupts : Bool = null
  var allowException  : Bool = null
  var allowEbreakException : Bool = null

  var csrMapping : CsrMapping = null

  //Print CSR mapping
  def printCsr() {
    for ((address, things) <- csrMapping.mapping) {
      println("0x" + address.toHexString + " => ")
      for (thing <- things) {
        println(" - " + thing)
      }
    }
  }


  //Interruption and exception data model
  case class Delegator(var enable : Bool, privilege : Int)
  case class InterruptSpec(var cond : Bool, id : Int, privilege : Int, delegators : List[Delegator])
  case class ExceptionSpec(id : Int, delegators : List[Delegator])
  var interruptSpecs = ArrayBuffer[InterruptSpec]()
  var exceptionSpecs = ArrayBuffer[ExceptionSpec]()

  def addInterrupt(cond : Bool, id : Int, privilege : Int, delegators : List[Delegator]): Unit = {
    interruptSpecs += InterruptSpec(cond, id, privilege, delegators)
  }

  override def r(csrAddress: Int, bitOffset: Int, that: Data): Unit = csrMapping.r(csrAddress, bitOffset, that)
  override def w(csrAddress: Int, bitOffset: Int, that: Data): Unit = csrMapping.w(csrAddress, bitOffset, that)
  override def r2w(csrAddress: Int, bitOffset: Int, that: Data): Unit = csrMapping.r2w(csrAddress, bitOffset, that)
  override def onWrite(csrAddress: Int)(body: => Unit): Unit = csrMapping.onWrite(csrAddress)(body)
  override def duringWrite(csrAddress: Int)(body: => Unit): Unit = csrMapping.duringWrite(csrAddress)(body)
  override def onRead(csrAddress: Int)(body: => Unit): Unit = csrMapping.onRead(csrAddress)(body)
  override def duringRead(csrAddress: Int)(body: => Unit): Unit = csrMapping.duringRead(csrAddress)(body)
  override def during(csrAddress: Int)(body: => Unit): Unit = csrMapping.during(csrAddress)(body)
  override def duringAny(): Bool = pipeline.execute.arbitration.isValid && pipeline.execute.input(IS_CSR)
  override def duringAnyRead(body: => Unit) = csrMapping.duringAnyRead(body)
  override def duringAnyWrite(body: => Unit) = csrMapping.duringAnyWrite(body)
  override def onAnyRead(body: => Unit) = csrMapping.onAnyRead(body)
  override def onAnyWrite(body: => Unit) = csrMapping.onAnyWrite(body)
  override def allowCsr() = csrMapping.allowCsr()
  override def readData() = csrMapping.readData()
  override def writeData() = csrMapping.writeData()
  override def isHazardFree() = csrMapping.isHazardFree()
  override def forceFailCsr() = csrMapping.forceFailCsr()

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    if(!config.withEbreak) {
      SpinalWarning("This VexRiscv configuration is set without software ebreak instruction support. Some software may rely on it (ex: Rust). (This isn't related to JTAG ebreak)")
    }

    csrMapping = new CsrMapping()

    inWfi = False.addTag(Verilator.public)

    thirdPartyWake = False

    val defaultEnv = List[(Stageable[_ <: BaseType],Any)](
    )

    val defaultCsrActions = List[(Stageable[_ <: BaseType],Any)](
      IS_CSR                   -> True,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> True
    ) ++ (if(catchIllegalAccess) List(HAS_SIDE_EFFECT -> True) else Nil)

    val nonImmediatActions = defaultCsrActions ++ List(
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      RS1_USE                 -> True
    )

    val immediatActions = defaultCsrActions ++ List(
      SRC1_CTRL -> Src1CtrlEnum.URS1
    )

    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(ENV_CTRL, EnvCtrlEnum.NONE)
    decoderService.addDefault(IS_CSR, False)
    decoderService.add(List(
      CSRRW  -> nonImmediatActions,
      CSRRS  -> nonImmediatActions,
      CSRRC  -> nonImmediatActions,
      CSRRWI -> immediatActions,
      CSRRSI -> immediatActions,
      CSRRCI -> immediatActions,
      MRET   -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.XRET, HAS_SIDE_EFFECT -> True)),
      SRET   -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.XRET, HAS_SIDE_EFFECT -> True))
    ))
    if(wfiGenAsWait)   decoderService.add(WFI,  defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.WFI))
    if(wfiGenAsNop)   decoderService.add(WFI, Nil)
    if(ecallGen) decoderService.add(ECALL,  defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.ECALL, HAS_SIDE_EFFECT -> True))
    if(withEbreak) decoderService.add(EBREAK,  defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.EBREAK, HAS_SIDE_EFFECT -> True))

    val  pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(pipeline.stages.last)
    jumpInterface.valid := False
    jumpInterface.payload.assignDontCare()


    if(supervisorGen) {
      redoInterface = pcManagerService.createJumpInterface(pipeline.execute, -20) //Should lose against dynamic_target branch prediction correction
    }

    exceptionPendings = Vec(Bool, pipeline.stages.length)
    timerInterrupt    = in Bool() setName("timerInterrupt")
    externalInterrupt = in Bool() setName("externalInterrupt")
    softwareInterrupt = in Bool() setName("softwareInterrupt") default(False)
    if(supervisorGen){
//      timerInterruptS    = in Bool() setName("timerInterruptS")
      externalInterruptS = in Bool() setName("externalInterruptS")
    }
    contextSwitching = Bool().setName("contextSwitching")

    privilege = UInt(2 bits).setName("CsrPlugin_privilege")
    if (exportPrivilege) out(privilege)
    forceMachineWire = False

    if(catchIllegalAccess || ecallGen || withEbreak)
      selfException = newExceptionPort(pipeline.execute)

    allowInterrupts = True
    allowException = True
    allowEbreakException = True

    for (i <- interruptSpecs) i.cond = i.cond.pull()


    pipeline.update(MPP, UInt(2 bits))

    if(withExternalMhartid) externalMhartId = in UInt(mhartidWidth bits)
    if(utimeAccess != CsrAccess.NONE) utime = in UInt(64 bits) setName("utime")

    if(supervisorGen) {
      decoderService.addDefault(RESCHEDULE_NEXT, False)
      decoderService.add(SFENCE_VMA, List(RESCHEDULE_NEXT -> True))
      decoderService.add(FENCE_I, List(RESCHEDULE_NEXT -> True))
    }

    xretAwayFromMachine = False

    if(withPrivilegedDebug && pipeline.config.FLEN == 64) pipeline.service(classOf[FpuPlugin]).requireAccessPort()

    injectionPort = withPrivilegedDebug generate pipeline.service(classOf[IBusFetcher]).getInjectionPort().setCompositeName(this, "injectionPort")
    debugMode = withPrivilegedDebug generate Bool().setName("debugMode")
    debugBus = withPrivilegedDebug generate slave(DebugHartBus()).setName("debugBus")
  }

  def inhibateInterrupts() : Unit = allowInterrupts := False
  def inhibateException() : Unit  = allowException  := False
  def inhibateEbreakException() : Unit  = allowEbreakException  := False

  override def isUser() : Bool = privilege === 0
  override def isSupervisor(): Bool = privilege === 1
  override def isMachine(): Bool = privilege === 3
  override def forceMachine(): Unit = forceMachineWire := True

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    val fetcher = service(classOf[IBusFetcher])
    val trapCodeWidth = log2Up((List(16) ++ interruptSpecs.map(_.id + 1) ++ exceptionPortsInfos.map(p => 1 << widthOf(p.port.code))).max)

    //Define CSR mapping utilities
    implicit class CsrAccessPimper(csrAccess : CsrAccess){
      def apply(csrAddress : Int, thats : (Int, Data)*) : Unit = {
        if(csrAccess == `WRITE_ONLY` || csrAccess ==  `READ_WRITE`) for(that <- thats) csrMapping.w(csrAddress,that._1, that._2)
        if(csrAccess == `READ_ONLY`  || csrAccess ==  `READ_WRITE`) for(that <- thats) csrMapping.r(csrAddress,that._1, that._2)
      }
      def apply(csrAddress : Int, that : Data) : Unit = {
        if(csrAccess == `WRITE_ONLY` || csrAccess ==  `READ_WRITE`) csrMapping.w(csrAddress, 0, that)
        if(csrAccess == `READ_ONLY`  || csrAccess ==  `READ_WRITE`) csrMapping.r(csrAddress, 0, that)
      }
    }

    // The CSR plugin will invoke a trap handler on exception, which does not
    // count as halt-state by the RVFI spec, and neither do other instructions
    // such as `wfi`, etc. Hence statically drive the output:
    pipeline.stages.head.insert(FORMAL_HALT) := False

    case class Xtvec() extends Bundle {
      val mode = Bits(2 bits)
      val base = UInt(xlen-2 bits)
    }

    val trapEvent = False

    val privilegeReg = privilegeGen generate RegInit(U"11")
    privilege := (if(privilegeGen) privilegeReg else U"11")

    when(forceMachineWire) { privilege := 3 }

    val debug = withPrivilegedDebug generate pipeline.plug(new Area{
      val iBusFetcher = service(classOf[IBusFetcher])
      def bus = debugBus


      val running = RegInit(True)
      debugMode := !running


      when(!running) {
        iBusFetcher.haltIt()
      }

      bus.resume.rsp.valid := False

      bus.running :=  running
      bus.halted  := !running
      bus.unavailable := BufferCC(ClockDomain.current.isResetActive)
      when(debugMode){
        inhibateInterrupts()
      }

      val reseting   = RegNext(False) init(True)
      bus.haveReset := RegInit(False) setWhen(reseting) clearWhen(bus.ackReset)

      val enterHalt = running.getAheadValue().fall(False)

      val doHalt = RegInit(False) setWhen(bus.haltReq && bus.running && !debugMode) clearWhen(enterHalt)
      val forceResume = False
      val doResume = forceResume || bus.resume.isPending(1)

      // Pipeline execution timeout used to trigger some redo
      val timeout = Timeout(7)
      when(pipeline.stages.tail.map(_.arbitration.isValid).orR){
        timeout.clear()
      }

      val dataCsrr = new Area{
        bus.hartToDm.valid   := isWriting(DebugModule.CSR_DATA)
        bus.hartToDm.address := 0
        bus.hartToDm.data    := execute.input(SRC1)
      }

      val withDebugFpuAccess = withPrivilegedDebug && pipeline.config.FLEN == 64
      val dataCsrw = new Area{
        val value = Vec.fill(1+withDebugFpuAccess.toInt)(Reg(Bits(32 bits)))

        val fromDm = new Area{
          when(bus.dmToHart.valid && bus.dmToHart.op === DebugDmToHartOp.DATA){
            value(bus.dmToHart.address.resized) := bus.dmToHart.data
          }
        }

        val toHart = new Area{
          r(DebugModule.CSR_DATA, value(0))
        }
      }

      val inject = new Area{
        val cmd = bus.dmToHart.takeWhen(bus.dmToHart.op === DebugDmToHartOp.EXECUTE || bus.dmToHart.op === DebugDmToHartOp.REG_READ || bus.dmToHart.op === DebugDmToHartOp.REG_WRITE)
        val buffer = cmd.toStream.stage
        injectionPort.valid := buffer.valid && buffer.op === DebugDmToHartOp.EXECUTE
        injectionPort.payload := buffer.data

        buffer.ready := injectionPort.fire
        val fpu = withDebugFpuAccess generate new Area {
          val access = service(classOf[FpuPlugin]).access
          access.start := buffer.valid && buffer.op === DebugDmToHartOp.REG_READ || buffer.op === DebugDmToHartOp.REG_WRITE
          access.regId := buffer.address
          access.write := buffer.op === DebugDmToHartOp.REG_WRITE
          access.writeData := dataCsrw.value.take(2).asBits
          access.size := buffer.size

          when(access.readDataValid) {
            bus.hartToDm.valid := True
            bus.hartToDm.address := access.readDataChunk.resized
            bus.hartToDm.data := access.readData
          }
          bus.regSuccess := access.done
          buffer.ready setWhen(access.done)
        }

        if(!withDebugFpuAccess) bus.regSuccess := False

        val pending = RegInit(False) setWhen(cmd.valid && bus.dmToHart.op === DebugDmToHartOp.EXECUTE) clearWhen(bus.exception || bus.commit || bus.ebreak || bus.redo)
        when(cmd.valid){ timeout.clear() }
        bus.redo := pending && timeout.state
      }

      val dpc = Reg(UInt(32 bits))
      val dcsr = new Area{
        rw(CSR.DPC, dpc)
        val prv = RegInit(U"11")
        val step = RegInit(False) //TODO
        val nmip = False
        val mprven = True
        val cause = RegInit(U"000")
        val stoptime = RegInit(False)
        val stopcount = RegInit(False)
        val stepie = RegInit(False) //TODO
        val ebreaku = userGen generate RegInit(False)
        val ebreaks = supervisorGen generate RegInit(False)
        val ebreakm = RegInit(False)
        val xdebugver = U(4, 4 bits)

        val stepLogic = new StateMachine{
          val IDLE, SINGLE, WAIT = new State()
          setEntry(IDLE)

          IDLE whenIsActive{
            when(step && bus.resume.rsp.valid){
              goto(SINGLE)
            }
          }
          SINGLE whenIsActive{
            timeout.clear()
            when(trapEvent){
              doHalt := True
              goto(WAIT)
            }
            when(decode.arbitration.isFiring) {
              goto(WAIT)
            }
          }

          WAIT whenIsActive{
            decode.arbitration.haltByOther setWhen(decode.arbitration.isValid)
            //re resume the execution in case of timeout (ex cache miss)
            when(!doHalt && timeout.state){
              goto(SINGLE)
            } otherwise {
              when(stages.last.arbitration.isFiring) {
                doHalt := True
              }
            }
          }

          always{
            when(enterHalt){
              goto(IDLE)
            }
          }
          build()
        }


        r(CSR.DCSR, 3 -> nmip, 6 -> cause, 28 -> xdebugver, 4 -> mprven)
        rw(CSR.DCSR, 0 -> prv, 2 -> step, 9 -> stoptime, 10 -> stopcount, 11 -> stepie, 15 -> ebreakm)
        if(supervisorGen) rw(CSR.DCSR, 13 -> ebreaks)
        if(userGen)       rw(CSR.DCSR, 12 -> ebreaku)


        when(debugMode) {
          pipeline.plugins.foreach{
            case p : PredictionInterface => p.inDebugNoFetch()
            case _ =>
          }
        }

        val wakeService = serviceElse(classOf[IWake], null)
        if(wakeService != null) when(debugMode || step || bus.haltReq){
          wakeService.askWake()
        }
      }
      stoptime = out(debugMode && dcsr.stoptime).setName("stoptime")

      //Very limited subset of the trigger spec
      val trigger = (debugTriggers > 0) generate new Area {
        val tselect = new Area{
          val index = Reg(UInt(log2Up(debugTriggers) bits))
          rw(CSR.TSELECT, index)

          val outOfRange = if(isPow2(debugTriggers)) False else index < debugTriggers
        }

        val tinfo = new Area{
          r(CSR.TINFO, 0 -> tselect.outOfRange, 2 -> !tselect.outOfRange)
        }

        val decodeBreak = new Area {
          val enabled = False
          val timeout = Timeout(3).clearWhen(!enabled || stages.tail.map(_.arbitration.isValid).orR)
          when(enabled) {
            decode.arbitration.haltByOther := True
            when(timeout.state) {
              trapEvent := True
              decode.arbitration.flushNext := True
              decode.arbitration.removeIt := True
              dpc := decode.input(PC)
              running := False
              dcsr.cause := 2
              dcsr.prv := privilege
              privilegeReg := 3
            }
          }
        }

        val slots = for(slotId <- 0 until debugTriggers) yield new Area {
          val selected = tselect.index === slotId
          def csrw(csrId : Int, thats : (Int, Data)*): Unit ={
            onWrite(csrId){
              when(selected) {
                for((offset, data) <- thats){
                  data.assignFromBits(writeData()(offset, widthOf(data) bits))
                }
              }
            }
          }
          def csrr(csrId : Int, read : Bits, thats : (Int, Data)*): Unit ={
            when(selected) {
              for((offset, data) <- thats){
                read(offset, widthOf(data) bits) := data.asBits
              }
            }
          }
          def csrrw(csrId : Int, read : Bits, thats : (Int, Data)*) : Unit = {
            csrw(csrId, thats :_*)
            csrr(csrId, read, thats :_*)
          }

          val tdata1 = new Area{
            val read = B(0, 32 bits)
            val tpe = U(2, 4 bits)
            val dmode = Reg(Bool()) init(False)

            val execute = RegInit(False)
            val m, s, u = RegInit(False)
            val action = RegInit(U"0000")
            val privilegeHit = !debugMode && privilege.mux(
              0 -> u,
              1 -> s,
              3 -> m,
              default -> False
            )

            csrrw(CSR.TDATA1, read, 2 -> execute , 3 -> u, 4-> s, 6 -> m, 32 - 5 -> dmode, 12 -> action)
            csrr(CSR.TDATA1, read, 32 - 4 -> tpe)
            csrr(CSR.TDATA1, read, 20 -> B"011111")

            //TODO action sizelo timing select sizehi maskmax
          }

          val tdata2 = new Area{
            val value = Reg(PC)
            csrw(CSR.TDATA2, 0 -> value)

            val execute = new Area{
              val enabled = !debugMode && tdata1.action === 1 && tdata1.execute && tdata1.privilegeHit
              val hit =  enabled && value === decode.input(PC)
              decodeBreak.enabled.setWhen(hit)
            }
          }
        }

        r(CSR.TDATA1, 0 -> slots.map(_.tdata1.read).read(tselect.index))

        decodeBreak.enabled clearWhen(!decode.arbitration.isValid)
      }
    })

    def guardedWrite(csrId : Int, bitRange: Range, allowed : Seq[Int], target : Bits) = {
      onWrite(csrId){
        when(allowed.map(writeData()(bitRange) === _).orR){
          target := writeData()(bitRange)
        }
      }
    }

    val machineCsr = pipeline plug new Area{
      //Define CSR registers
      // Status => MXR, SUM, TVM, TW, TSE ?
      val misa = new Area{
        val base = U"01"
        val extensions = B(misaExtensionsInit, 26 bits)
      }

      val mtvec = Reg(Xtvec()).allowUnsetRegToAvoidLatch

      if(mtvecInit != null) mtvec.mode init(mtvecInit & 0x3)
      if(mtvecInit != null) mtvec.base init(mtvecInit / 4)
      val mepc = Reg(UInt(xlen bits))
      val mstatus = new Area{
        val MIE, MPIE = RegInit(False)
        val MPP = RegInit(U"11")
      }
      val mip = new Area{
        val MEIP = RegNext(externalInterrupt)
        val MTIP = RegNext(timerInterrupt)
        val MSIP = RegNext(softwareInterrupt)
      }
      val mie = new Area{
        val MEIE, MTIE, MSIE = RegInit(False)
      }
      val mscratch = if(mscratchGen) Reg(Bits(xlen bits)) else null
      val mcause   = new Area{
        val interrupt = Reg(Bool)
        val exceptionCode = Reg(UInt(trapCodeWidth bits))
      }
      val mtval = Reg(UInt(xlen bits))
      val mcycle   = Reg(UInt(64 bits)) init(0)
      val minstret = Reg(UInt(64 bits)) init(0)


      val medeleg = supervisorGen generate new Area {
        val IAM, IAF, II, LAM, LAF, SAM, SAF, EU, ES, IPF, LPF, SPF = RegInit(False)
        val mapping = mutable.LinkedHashMap(0 -> IAM, 1 -> IAF, 2 -> II, 4 -> LAM, 5 -> LAF, 6 -> SAM, 7 -> SAF, 8 -> EU, 9 -> ES, 12 -> IPF, 13 -> LPF, 15 -> SPF)
      }
      val mideleg = supervisorGen generate new Area {
        val ST, SE, SS = RegInit(False)
      }

      if(mvendorid != null) READ_ONLY(CSR.MVENDORID, U(mvendorid))
      if(marchid   != null) READ_ONLY(CSR.MARCHID  , U(marchid  ))
      if(mimpid    != null) READ_ONLY(CSR.MIMPID   , U(mimpid   ))
      if(mhartid   != null && !withExternalMhartid) READ_ONLY(CSR.MHARTID  , U(mhartid  ))
      if(withExternalMhartid) READ_ONLY(CSR.MHARTID  , externalMhartId)
      if(misaAccess.canRead) {
        READ_ONLY(CSR.MISA, xlen-2 -> misa.base , 0 -> misa.extensions)
        onWrite(CSR.MISA){}
      }

      //Machine CSR
      READ_WRITE(CSR.MSTATUS, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
      READ_ONLY(CSR.MIP, 11 -> mip.MEIP, 7 -> mip.MTIP)
      READ_WRITE(CSR.MIP, 3 -> mip.MSIP)
      READ_WRITE(CSR.MIE, 11 -> mie.MEIE, 7 -> mie.MTIE, 3 -> mie.MSIE)

      r(CSR.MSTATUS, 11 -> mstatus.MPP)
      onWrite(CSR.MSTATUS){
        switch(writeData()(12 downto 11)){
          is(3){ mstatus.MPP := 3 }
          if(supervisorGen) is(1){ mstatus.MPP := 1 }
          if(userGen) is(0){ mstatus.MPP := 0 }
        }
      }

      mtvecAccess(CSR.MTVEC, 2 -> mtvec.base)
      if(mtvecAccess.canWrite && xtvecModeGen) {
        guardedWrite(CSR.MTVEC, 1 downto 0, List(0, 1), mtvec.mode)
      }

      mepcAccess(CSR.MEPC, mepc)
      if(mscratchGen) READ_WRITE(CSR.MSCRATCH, mscratch)
      mcauseAccess(CSR.MCAUSE, xlen-1 -> mcause.interrupt, 0 -> mcause.exceptionCode)
      mbadaddrAccess(CSR.MBADADDR, mtval)
      mcycleAccess(CSR.MCYCLE, mcycle(31 downto 0))
      mcycleAccess(CSR.MCYCLEH, mcycle(63 downto 32))
      minstretAccess(CSR.MINSTRET, minstret(31 downto 0))
      minstretAccess(CSR.MINSTRETH, minstret(63 downto 32))

      if(supervisorGen) {
        for((id, enable) <- medeleg.mapping) medelegAccess(CSR.MEDELEG, id -> enable)
        midelegAccess(CSR.MIDELEG, 9 -> mideleg.SE, 5 -> mideleg.ST, 1 -> mideleg.SS)
      }

      //User CSR
      ucycleAccess(CSR.UCYCLE, mcycle(31 downto 0))
      ucycleAccess(CSR.UCYCLEH, mcycle(63 downto 32))
      uinstretAccess(CSR.UINSTRET, minstret(31 downto 0))
      uinstretAccess(CSR.UINSTRETH, minstret(63 downto 32))

      if(utimeAccess != CsrAccess.NONE) {
        utimeAccess(CSR.UTIME,  utime(31 downto 0))
        utimeAccess(CSR.UTIMEH, utime(63 downto 32))
      }

      class Xcounteren(csrId : Int) extends Area{
        val IR,TM,CY = RegInit(True) //For backward compatibility
        if(ucycleAccess != CsrAccess.NONE)   rw(csrId, 0 -> CY)
        if(utimeAccess != CsrAccess.NONE)    rw(csrId, 1 -> TM)
        if(uinstretAccess != CsrAccess.NONE) rw(csrId, 2 -> IR)
      }
      def xcounterChecks(access : CsrAccess, csrId : Int, enable : Xcounteren => Bool) = {
        if(access != CsrAccess.NONE) during(csrId){
          if(userGen) when(privilege < 3 && !enable(mcounteren)){ forceFailCsr() }
          if(supervisorGen) when(privilege < 1 && !enable(scounteren)){ forceFailCsr() }
        }
      }

      val mcounteren = userGen generate new Xcounteren(CSR.MCOUNTEREN)
      val scounteren = supervisorGen generate new Xcounteren(CSR.SCOUNTEREN)
      xcounterChecks(ucycleAccess  , CSR.UCYCLE   , _.CY)
      xcounterChecks(ucycleAccess  , CSR.UCYCLEH  , _.CY)
      xcounterChecks(utimeAccess   , CSR.UTIME    , _.TM)
      xcounterChecks(utimeAccess   , CSR.UTIMEH   , _.TM)
      xcounterChecks(uinstretAccess, CSR.UINSTRET , _.IR)
      xcounterChecks(uinstretAccess, CSR.UINSTRETH, _.IR)

      pipeline(MPP) := mstatus.MPP
    }

    val supervisorCsr = ifGen(supervisorGen) {
      pipeline plug new Area {
        val sstatus = new Area {
          val SIE, SPIE = RegInit(False)
          val SPP = RegInit(U"1")
        }

        val sip = new Area {
          val SEIP_SOFT = RegInit(False)
          val SEIP_INPUT = RegNext(externalInterruptS)
          val SEIP_OR = SEIP_SOFT || SEIP_INPUT
          val STIP = RegInit(False)
          val SSIP = RegInit(False)
        }
        val sie = new Area {
          val SEIE, STIE, SSIE = RegInit(False)
        }
        val stvec = Reg(Xtvec()).allowUnsetRegToAvoidLatch
        val sscratch = if (sscratchGen) Reg(Bits(xlen bits)) else null

        val scause = new Area {
          val interrupt = Reg(Bool)
          val exceptionCode = Reg(UInt(trapCodeWidth bits))
        }
        val stval = Reg(UInt(xlen bits))
        val sepc = Reg(UInt(xlen bits))
        val satp = new Area {
          val PPN = Reg(Bits(22 bits))
          val ASID = Reg(Bits(9 bits))
          val MODE = Reg(Bits(1 bits))
        }

        //Supervisor CSR
        for(offset <- List(CSR.MSTATUS, CSR.SSTATUS)) READ_WRITE(offset,8 -> sstatus.SPP, 5 -> sstatus.SPIE, 1 -> sstatus.SIE)
        for(offset <- List(CSR.MIP, CSR.SIP)) {
          READ_WRITE(offset, 5 -> sip.STIP, 1 -> sip.SSIP)
          READ_ONLY(offset,  9 -> sip.SEIP_OR)
          WRITE_ONLY(offset,  9 -> sip.SEIP_SOFT)
          r2w(offset, 9, sip.SEIP_SOFT)
        }

        for(offset <- List(CSR.MIE, CSR.SIE)) READ_WRITE(offset, 9 -> sie.SEIE, 5 -> sie.STIE, 1 -> sie.SSIE)


        stvecAccess(CSR.STVEC, 2 -> stvec.base)
        if(mtvecAccess.canWrite && xtvecModeGen) {
          guardedWrite(CSR.STVEC, 1 downto 0, List(0, 1), stvec.mode)
        }
        sepcAccess(CSR.SEPC, sepc)
        if(sscratchGen) READ_WRITE(CSR.SSCRATCH, sscratch)
        scauseAccess(CSR.SCAUSE, xlen-1 -> scause.interrupt, 0 -> scause.exceptionCode)
        sbadaddrAccess(CSR.SBADADDR, stval)
        satpAccess(CSR.SATP, 31 -> satp.MODE, 22 -> satp.ASID, 0 -> satp.PPN)


        val rescheduleLogic = supervisorGen generate new Area {
          redoInterface.valid := False
          redoInterface.payload := decode.input(PC)

          val rescheduleNext = False
          when(execute.arbitration.isValid && execute.input(RESCHEDULE_NEXT)) { rescheduleNext := True }
          duringWrite(CSR.SATP) { rescheduleNext := True }

          when(rescheduleNext){
            redoInterface.valid := True
            execute.arbitration.flushNext := True
            decode.arbitration.haltByOther := True
          }
        }
      }
    }



    pipeline plug new Area{
      import machineCsr._
      import supervisorCsr._

      val lastStage = pipeline.stages.last
      val beforeLastStage = pipeline.stages(pipeline.stages.size-2)
      val stagesFromExecute = pipeline.stages.dropWhile(_ != execute)

      //Manage counters
      mcycle := mcycle + (if(withPrivilegedDebug) U(!debugMode || !debug.dcsr.stopcount) else U(1))
      when(lastStage.arbitration.isFiring) {
        minstret := minstret + 1
      }


      if(supervisorGen) {
        addInterrupt(sip.STIP && sie.STIE,    id = 5, privilege = 1, delegators = List(Delegator(mideleg.ST, 3)))
        addInterrupt(sip.SSIP && sie.SSIE,    id = 1, privilege = 1, delegators = List(Delegator(mideleg.SS, 3)))
        addInterrupt(sip.SEIP_OR && sie.SEIE, id = 9, privilege = 1, delegators = List(Delegator(mideleg.SE, 3)))

        for((id, enable) <- medeleg.mapping) exceptionSpecs += ExceptionSpec(id, List(Delegator(enable, 3)))
      }

      addInterrupt(mip.MTIP && mie.MTIE, id = 7, privilege = 3, delegators = Nil)
      addInterrupt(mip.MSIP && mie.MSIE, id = 3, privilege = 3, delegators = Nil)
      addInterrupt(mip.MEIP && mie.MEIE, id = 11, privilege = 3, delegators = Nil)


      val mepcCaptureStage = if(exceptionPortsInfos.nonEmpty) lastStage else decode


      //Aggregate all exception port and remove required instructions
      val exceptionPortCtrl = exceptionPortsInfos.nonEmpty generate new Area{
        val codeWidth = exceptionPortsInfos.map(_.codeWidth).max
        val firstStageIndexWithExceptionPort = exceptionPortsInfos.map(i => indexOf(i.stage)).min
        val exceptionValids = Vec(stages.map(s => Bool().setPartialName(s.getName())))
        val exceptionValidsRegs = Vec(stages.map(s => Reg(Bool).init(False).setPartialName(s.getName()))).allowUnsetRegToAvoidLatch
        val exceptionContext = Reg(ExceptionCause(codeWidth))
        val exceptionTargetPrivilegeUncapped = U"11"

        switch(exceptionContext.code){
          for(s <- exceptionSpecs){
            is(s.id){
              var exceptionPrivilegs = if (supervisorGen) List(1, 3) else List(3)
              while(exceptionPrivilegs.length != 1){
                val p = exceptionPrivilegs.head
                if (exceptionPrivilegs.tail.forall(e => s.delegators.exists(_.privilege == e))) {
                  val delegUpOn = s.delegators.filter(_.privilege > p).map(_.enable).fold(True)(_ && _)
                  val delegDownOff = !s.delegators.filter(_.privilege <= p).map(_.enable).orR
                  when(delegUpOn && delegDownOff) {
                    exceptionTargetPrivilegeUncapped := p
                  }
                }
                exceptionPrivilegs = exceptionPrivilegs.tail
              }
            }
          }
        }
        val exceptionTargetPrivilege = privilege.max(exceptionTargetPrivilegeUncapped)

        val groupedByStage = exceptionPortsInfos.map(_.stage).distinct.map(s => {
          val stagePortsInfos = exceptionPortsInfos.filter(_.stage == s).sortWith(_.priority > _.priority)
          val stagePort = stagePortsInfos.length match{
            case 1 => {
              stagePortsInfos.head.port.translateWith(stagePortsInfos.head.port.payload.resizeCode(codeWidth))
            }
            case _ => {
              val groupedPort = Flow(ExceptionCause(codeWidth))
              val valids = stagePortsInfos.map(_.port.valid)
              val codes = stagePortsInfos.map(_.port.payload.resizeCode(codeWidth))
              groupedPort.valid := valids.orR
              groupedPort.payload := MuxOH(OHMasking.first(stagePortsInfos.map(_.port.valid).asBits), codes)
              groupedPort
            }
          }
          ExceptionPortInfo(stagePort,s,0, codeWidth)
        })

        val sortedByStage = groupedByStage.sortWith((a, b) => pipeline.indexOf(a.stage) < pipeline.indexOf(b.stage))
//        sortedByStage.zipWithIndex.foreach(e => e._1.port.setName(e._1.stage.getName() + "_exception_agregat"))
        exceptionValids := exceptionValidsRegs
        for(portInfo <- sortedByStage; port = portInfo.port ; stage = portInfo.stage; stageId = indexOf(portInfo.stage)) {
          when(port.valid) {
            stage.arbitration.flushNext := True
            stage.arbitration.removeIt := True
            exceptionValids(stageId) := True
            exceptionContext := port.payload
          }
        }

        for(stageId <- firstStageIndexWithExceptionPort until stages.length; stage = stages(stageId) ){
          val previousStage = if(stageId == firstStageIndexWithExceptionPort) stage else stages(stageId-1)
          when(!stage.arbitration.isStuck){
            exceptionValidsRegs(stageId) := (if(stageId != firstStageIndexWithExceptionPort) exceptionValids(stageId-1) && !previousStage.arbitration.isStuck else False)
          }otherwise{
            if(stage != stages.last)
              exceptionValidsRegs(stageId) := exceptionValids(stageId)
            else
              exceptionValidsRegs(stageId) := False
          }
          when(stage.arbitration.isFlushed){
            exceptionValids(stageId) := False
          }
        }

        when(exceptionValids.orR){
          fetcher.haltIt()
        }

        //Avoid the PC register of the last stage to change durring an exception handleing (Used to fill Xepc)
        stages.last.dontSample.getOrElseUpdate(PC, ArrayBuffer[Bool]()) += exceptionValids.last
        exceptionPendings := exceptionValidsRegs
      }





      //Process interrupt request, code and privilege
      val interrupt = new Area {
        val valid = if(pipelinedInterrupt) RegNext(False) init(False) else False
        val code = if(pipelinedInterrupt) Reg(UInt(trapCodeWidth bits)) else UInt(trapCodeWidth bits).assignDontCare()
        var privilegs = if (supervisorGen) List(1, 3) else List(3)
        val targetPrivilege = if(pipelinedInterrupt) Reg(UInt(2 bits)) else UInt(2 bits).assignDontCare()
        val privilegeAllowInterrupts = mutable.LinkedHashMap[Int, Bool]()
        if (supervisorGen) privilegeAllowInterrupts += 1 -> ((sstatus.SIE && privilege === U"01") || privilege < U"01")
        privilegeAllowInterrupts += 3 -> (mstatus.MIE || privilege < U"11")
        while (privilegs.nonEmpty) {
          val p = privilegs.head
          when(privilegeAllowInterrupts(p)) {
            for (i <- interruptSpecs
                 if i.privilege <= p //EX : Machine timer interrupt can't go into supervisor mode
                 if privilegs.tail.forall(e => i.delegators.exists(_.privilege == e))) { // EX : Supervisor timer need to have machine mode delegator
              val delegUpOn = i.delegators.filter(_.privilege > p).map(_.enable).fold(True)(_ && _)
              val delegDownOff = !i.delegators.filter(_.privilege <= p).map(_.enable).orR
              when(i.cond && delegUpOn && delegDownOff) {
                valid := True
                code := i.id
                targetPrivilege := p
              }
            }
          }
          privilegs = privilegs.tail
        }

        code.addTag(Verilator.public)

        if(withPrivilegedDebug) {
          valid clearWhen(debug.dcsr.step && !debug.dcsr.stepie)
          valid setWhen(debug.doHalt)
        }
      }




      val exception = if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionValids.last && allowException else False
      val lastStageWasWfi = if(wfiGenAsWait) RegNext(lastStage.arbitration.isFiring && lastStage.input(ENV_CTRL) === EnvCtrlEnum.WFI) init(False) else False



      //Used to make the pipeline empty softly (for interrupts)
      val pipelineLiberator = new Area{
        val pcValids = Vec(RegInit(False), stagesFromExecute.length)
        val active = interrupt.valid && allowInterrupts && decode.arbitration.isValid
        when(active){
          decode.arbitration.haltByOther := True
          for((stage, reg, previous) <- (stagesFromExecute, pcValids, True :: pcValids.toList).zipped){
            when(!stage.arbitration.isStuck){
              reg := previous
            }
          }
        }
        when(!active || decode.arbitration.isRemoved) {
          pcValids.foreach(_ := False)
        }

//        val pcValids = for(stage <- stagesFromExecute) yield RegInit(False) clearWhen(!started) setWhen(!stage.arbitration.isValid)
        val done = CombInit(pcValids.last)
        if(exceptionPortCtrl != null) done.clearWhen(exceptionPortCtrl.exceptionValidsRegs.tail.orR)
      }

      //Interrupt/Exception entry logic
      val interruptJump = Bool.addTag(Verilator.public)
      interruptJump := interrupt.valid && pipelineLiberator.done && allowInterrupts
      if(pipelinedInterrupt) interrupt.valid clearWhen(interruptJump) //avoid double fireing

      val hadException = RegNext(exception) init(False) addTag(Verilator.public)
      pipelineLiberator.done.clearWhen(hadException)

      if(withPrivilegedDebug) {
        debugBus.commit := debugMode && pipeline.stages.last.arbitration.isFiring
        debugBus.exception := debugMode && hadException
        debugBus.ebreak := False
      }

      val targetPrivilege = CombInit(interrupt.targetPrivilege)
      if(exceptionPortCtrl != null) when(hadException) {
        targetPrivilege := exceptionPortCtrl.exceptionTargetPrivilege
      }

      val trapCause = CombInit(interrupt.code.resize(trapCodeWidth))
      val trapCauseEbreakDebug = False
      if(exceptionPortCtrl != null) when( hadException){
        trapCause := exceptionPortCtrl.exceptionContext.code.resized
        if(withPrivilegedDebug) {
          when(exceptionPortCtrl.exceptionContext.code === 3){
            trapCauseEbreakDebug setWhen(debugMode)
            trapCauseEbreakDebug setWhen(privilege === 3 && debug.dcsr.ebreakm)
            if (userGen) trapCauseEbreakDebug setWhen (privilege === 0 && debug.dcsr.ebreaku)
            if (supervisorGen) trapCauseEbreakDebug setWhen (privilege === 1 && debug.dcsr.ebreaks)
          }
        }
      }

      val xtvec = Xtvec().assignDontCare()
      switch(targetPrivilege){
        if(supervisorGen) is(1) { xtvec := supervisorCsr.stvec }
        is(3){ xtvec := machineCsr.mtvec }
      }

      val trapEnterDebug = False
      if(withPrivilegedDebug) trapEnterDebug setWhen(debug.doHalt || trapCauseEbreakDebug || !hadException && debug.doHalt || !debug.running)
      when(hadException || interruptJump){
        trapEvent := True
        fetcher.haltIt() //Avoid having the fetch confused by the incomming privilege switch

        jumpInterface.valid         := True
        jumpInterface.payload       := (if(!xtvecModeGen) xtvec.base @@ U"00" else (xtvec.mode === 0 || hadException) ? (xtvec.base @@ U"00") | ((xtvec.base + trapCause) @@ U"00") )
        lastStage.arbitration.flushNext := True

        when(!trapEnterDebug){
          if(privilegeGen) privilegeReg := targetPrivilege
          switch(targetPrivilege){
            if(supervisorGen) is(1) {
              sstatus.SIE := False
              sstatus.SPIE := sstatus.SIE
              sstatus.SPP := privilege(0 downto 0)
              scause.interrupt := !hadException
              scause.exceptionCode := trapCause
              sepc := mepcCaptureStage.input(PC)
              if (exceptionPortCtrl != null) when(hadException){
                stval := exceptionPortCtrl.exceptionContext.badAddr
              }
            }

            is(3){
              mstatus.MIE  := False
              mstatus.MPIE := mstatus.MIE
              mstatus.MPP  := privilege
              mcause.interrupt := !hadException
              mcause.exceptionCode := trapCause
              mepc := mepcCaptureStage.input(PC)
              if(exceptionPortCtrl != null) when(hadException){
                mtval := exceptionPortCtrl.exceptionContext.badAddr
              }
            }
          }
        } otherwise {
          if(withPrivilegedDebug) {
            debug.running := False
            when(!debugMode) {
              debug.dpc := mepcCaptureStage.input(PC)
              debug.dcsr.cause := 3
              when(debug.dcsr.step) {
                debug.dcsr.cause := 4
              }
              when(trapCauseEbreakDebug) {
                debug.dcsr.cause := 1
              }
              debug.dcsr.prv := privilege
            } otherwise {
              debugBus.exception := !trapCauseEbreakDebug //TODO mask interrupt while in debug mode
              debugBus.ebreak := trapCauseEbreakDebug
            }
            privilegeReg := 3
          }
        }
      }

      if(exceptionPortCtrl == null){
        if(mbadaddrAccess == CsrAccess.READ_ONLY) mtval := 0
        if(sbadaddrAccess == CsrAccess.READ_ONLY) stval := 0
      }

      lastStage plug new Area{
        import lastStage._

        //Manage MRET / SRET instructions
        when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.XRET) {
          fetcher.haltIt()
          jumpInterface.valid := True
          lastStage.arbitration.flushNext := True
          switch(input(INSTRUCTION)(29 downto 28)){
            is(3){
              mstatus.MPP := U"00"
              mstatus.MIE := mstatus.MPIE
              mstatus.MPIE := True
              jumpInterface.payload := mepc
              if(privilegeGen) {
                privilegeReg := mstatus.MPP
                xretAwayFromMachine setWhen(mstatus.MPP < 3)
              }
            }
            if(supervisorGen) is(1){
              sstatus.SPP := U"0"
              sstatus.SIE := sstatus.SPIE
              sstatus.SPIE := True
              jumpInterface.payload := sepc
              if(privilegeGen) {
                privilegeReg := U"0" @@ sstatus.SPP
                xretAwayFromMachine := True
              }
            }
          }
        }
      }

      contextSwitching := jumpInterface.valid

      // Debug resume
      if(withPrivilegedDebug) {
        when(debug.doResume) {
          jumpInterface.valid   := True
          jumpInterface.payload := debug.dpc
          lastStage.arbitration.flushIt := True

          privilegeReg := debug.dcsr.prv
          debug.running := True
          debug.bus.resume.rsp.valid := True
        }
      }


      //CSR read/write instructions management
      decode plug new Area{
        import decode._

        val imm = IMM(input(INSTRUCTION))
        insert(CSR_WRITE_OPCODE) := ! (
             (input(INSTRUCTION)(14 downto 13) === B"01" && input(INSTRUCTION)(rs1Range) === 0)
          || (input(INSTRUCTION)(14 downto 13) === B"11" && imm.z === 0)
        )
        insert(CSR_READ_OPCODE) := input(INSTRUCTION)(13 downto 7) =/= B"0100000"
      }


      execute plug new Area{
        import execute._
        //Manage WFI instructions
        if(wfiOutput) out(inWfi)
        val wfiWake = RegNext(interruptSpecs.map(_.cond).orR || thirdPartyWake) init(False)
        if(wfiGenAsWait) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.WFI){
          inWfi := True
          when(!wfiWake){
            arbitration.haltItself := True
          }
        }
      }

      decode.arbitration.haltByOther setWhen(stagesFromExecute.map(s => s.arbitration.isValid && s.input(ENV_CTRL) === EnvCtrlEnum.XRET).asBits.orR)

      execute plug new Area {
        import execute._
        def previousStage = decode
        val blockedBySideEffects =  stagesFromExecute.tail.map(s => s.arbitration.isValid).asBits().orR || pipeline.service(classOf[HazardService]).hazardOnExecuteRS// && s.input(HAS_SIDE_EFFECT)  to improve be less pessimistic

        val illegalAccess = True
        val illegalInstruction = False
        if(selfException != null) {
          selfException.valid := False
          selfException.code.assignDontCare()
          selfException.badAddr := input(INSTRUCTION).asUInt
          if(catchIllegalAccess) when(illegalAccess || illegalInstruction){
            selfException.valid := True
            selfException.code := 2
          }
        }

        //Manage MRET / SRET instructions
        when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.XRET) {
          when(input(INSTRUCTION)(29 downto 28).asUInt > privilege) {
            illegalInstruction := True
          }
        }


        //Manage ECALL instructions
        if(ecallGen) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.ECALL){
          selfException.valid := True
          switch(privilege) {
            is(0) { selfException.code := 8 }
            if(supervisorGen) is(1) { selfException.code := 9 }
            default { selfException.code := 11 }
          }
        }


        if(withEbreak) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.EBREAK && allowEbreakException){
          selfException.valid := True
          selfException.code := 3
        }


        val imm = IMM(input(INSTRUCTION))
        def writeSrc = input(SRC1)
        def readData = csrMapping.readDataSignal
        def writeData = csrMapping.writeDataSignal
        val writeInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_WRITE_OPCODE)
        val readInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_READ_OPCODE)
        val writeEnable = writeInstruction && !arbitration.isStuck
        val readEnable  = readInstruction  && !arbitration.isStuck
        csrMapping.hazardFree := !blockedBySideEffects

        val readToWriteData = CombInit(readData)
        writeData := (if(noCsrAlu) writeSrc else input(INSTRUCTION)(13).mux(
          False -> writeSrc,
          True -> Mux(input(INSTRUCTION)(12), readToWriteData & ~writeSrc, readToWriteData | writeSrc)
        ))

        when(arbitration.isValid && input(IS_CSR)) {
          if(!pipelineCsrRead) output(REGFILE_WRITE_DATA) := readData
        }

        when(arbitration.isValid && (input(IS_CSR) || (if(supervisorGen) input(RESCHEDULE_NEXT) else False))) {
          arbitration.haltItself setWhen(blockedBySideEffects)
        }

        if(pipelineCsrRead){
          insert(PIPELINED_CSR_READ) := readData
          when(memory.arbitration.isValid && memory.input(IS_CSR)) {
            memory.output(REGFILE_WRITE_DATA) := memory.input(PIPELINED_CSR_READ)
          }
        }

        //Translation of the csrMapping into real logic
        val csrAddress = input(INSTRUCTION)(csrRange)
        Component.current.afterElaboration{
          def doJobs(jobs : ArrayBuffer[Any]): Unit ={
            val withWrite = jobs.exists(j => j.isInstanceOf[CsrWrite] || j.isInstanceOf[CsrOnWrite] || j.isInstanceOf[CsrDuringWrite])
            val withRead = jobs.exists(j => j.isInstanceOf[CsrRead] || j.isInstanceOf[CsrOnRead])
            if(withRead && withWrite) {
              illegalAccess := False
            } else {
              if (withWrite) illegalAccess.clearWhen(input(CSR_WRITE_OPCODE))
              if (withRead) illegalAccess.clearWhen(input(CSR_READ_OPCODE))
            }


            for (element <- jobs) element match {
              case element : CsrDuringWrite => when(writeInstruction){element.doThat()}
              case element : CsrDuringRead => when(readInstruction){element.doThat()}
              case element : CsrDuring => {element.doThat()}
              case _ =>
            }
            when(writeEnable) {
              for (element <- jobs) element match {
                case element: CsrWrite => element.that.assignFromBits(writeData(element.bitOffset, element.that.getBitsWidth bits))
                case element: CsrOnWrite => element.doThat()
                case _ =>
              }
            }

            when(readEnable) {
              for (element <- jobs) element match {
                case element: CsrOnRead =>
                  element.doThat()
                case _ =>
              }
            }
          }

          def doJobsOverride(jobs : ArrayBuffer[Any]): Unit ={
            for (element <- jobs) element match {
              case element: CsrReadToWriteOverride if element.that.getBitsWidth != 0 => readToWriteData(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
              case _ =>
            }
          }

          csrOhDecoder match {
            case false => {
              csrMapping.readDataInit := 0
              switch(csrAddress) {
                for ((address, jobs) <- csrMapping.mapping) {
                  is(address) {
                    doJobs(jobs)
                    for (element <- jobs) element match {
                      case element: CsrRead if element.that.getBitsWidth != 0 => csrMapping.readDataInit (element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
                      case _ =>
                    }
                  }
                }
              }
              switch(csrAddress) {
                for ((address, jobs) <- csrMapping.mapping if jobs.exists(_.isInstanceOf[CsrReadToWriteOverride])) {
                  is(address) {
                    doJobsOverride(jobs)
                  }
                }
              }
            }
            case true => {
              val oh = csrMapping.mapping.keys.toList.distinct.map(address => address -> RegNextWhen(decode.input(INSTRUCTION)(csrRange) === address, !execute.arbitration.isStuck).setCompositeName(this, "csr_" + address)).toMap
              val readDatas = ArrayBuffer[Bits]()
              for ((address, jobs) <- csrMapping.mapping) {
                when(oh(address)){
                  doJobs(jobs)
                }
                if(jobs.exists(_.isInstanceOf[CsrRead])) {
                  val masked = B(0, 32 bits)
                  when(oh(address)) (for (element <- jobs) element match {
                    case element: CsrRead if element.that.getBitsWidth != 0 => masked(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
                    case _ =>
                  })
                  readDatas += masked
                }
              }
              csrMapping.readDataInit := readDatas.reduceBalancedTree(_ | _)
              for ((address, jobs) <- csrMapping.mapping) {
                when(oh(address)){
                  doJobsOverride(jobs)
                }
              }
            }
          }

          csrMapping.always.foreach {
            case element : CsrDuringWrite => when(writeInstruction){element.doThat()}
            case element : CsrDuringRead => when(readInstruction){element.doThat()}
            case element : CsrOnWrite => when(writeEnable){element.doThat()}
            case element : CsrOnRead => when(readEnable){element.doThat()}
          }

          //When no PMP =>
          if(!csrMapping.mapping.contains(0x3A0)){
            when(arbitration.isValid && input(IS_CSR) && (csrAddress(11 downto 2) ## B"00" === 0x3A0  || csrAddress(11 downto 4) ## B"0000" === 0x3B0)){
              csrMapping.allowCsrSignal := True
            }
          }

          illegalAccess clearWhen(csrMapping.allowCsrSignal)

          val forceFail = CombInit(csrMapping.doForceFailCsr)
          forceFail setWhen(privilege < csrAddress(9 downto 8).asUInt)
          if(withPrivilegedDebug) forceFail setWhen(!debugMode && csrAddress >> 4 === 0x7B)
          when(forceFail){
            illegalAccess := True
            readInstruction := False
            writeInstruction := False
          }

          illegalAccess clearWhen(!arbitration.isValid || !input(IS_CSR))
        }
      }

//      val csrs = (0x7A0 to 0x7A5)
//      val miaouRead = csrs.map(v => isReading(v)).orR
//      val miaouWrite = csrs.map(v => isWriting(v)).orR
//
//      Component.toplevel.rework{
//        out(CombInit(miaouRead.pull())).setName("debug0")
//        out(CombInit(miaouWrite.pull())).setName("debug1")
//      }
    }
  }
}


class UserInterruptPlugin(interruptName : String, code : Int, privilege : Int = 3) extends Plugin[VexRiscv]{
  var interrupt, interruptEnable : Bool = null
  override def setup(pipeline: VexRiscv): Unit = {
    val csr = pipeline.service(classOf[CsrPlugin])
    interrupt = in.Bool().setName(interruptName)
    val interruptPending =  RegNext(interrupt) init(False)
    val interruptEnable = RegInit(False).setName(interruptName + "_enable")
    csr.addInterrupt(interruptPending && interruptEnable, code, privilege, Nil)
    csr.r(csrAddress = CSR.MIP, bitOffset = code,interruptPending)
    csr.rw(csrAddress = CSR.MIE, bitOffset = code, interruptEnable)
  }
  override def build(pipeline: VexRiscv): Unit = {}
}
