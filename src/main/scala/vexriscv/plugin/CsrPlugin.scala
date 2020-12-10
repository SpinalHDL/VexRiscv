package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._
import vexriscv.plugin.IntAluPlugin.{ALU_BITWISE_CTRL, ALU_CTRL, AluBitwiseCtrlEnum, AluCtrlEnum}

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable

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

case class ExceptionPortInfo(port : Flow[ExceptionCause],stage : Stage, priority : Int)
case class CsrPluginConfig(
                            catchIllegalAccess  : Boolean,
                            mvendorid           : BigInt,
                            marchid             : BigInt,
                            mimpid              : BigInt,
                            mhartid             : BigInt,
                            misaExtensionsInit  : Int,
                            misaAccess          : CsrAccess,
                            mtvecAccess         : CsrAccess,
                            mtvecInit           : BigInt,
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
                            medelegAccess       : CsrAccess = CsrAccess.NONE,
                            midelegAccess       : CsrAccess = CsrAccess.NONE,
                            pipelineCsrRead     : Boolean = false,
                            pipelinedInterrupt  : Boolean = true,
                            csrOhDecoder        : Boolean = true,
                            deterministicInteruptionEntry : Boolean = false, //Only used for simulatation purposes
                            wfiOutput           : Boolean = false
                          ){
  assert(!ucycleAccess.canWrite)
  def privilegeGen = userGen || supervisorGen
  def noException = this.copy(ecallGen = false, ebreakGen = false, catchIllegalAccess = false)
  def noExceptionButEcall = this.copy(ecallGen = true, ebreakGen = false, catchIllegalAccess = false)
}

object CsrPluginConfig{
  def all : CsrPluginConfig = all(0x00000020l)
  def small : CsrPluginConfig = small(0x00000020l)
  def smallest : CsrPluginConfig = smallest(0x00000020l)
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
case class CsrOnRead(doThat : () => Unit)
case class CsrMapping() extends CsrInterface{
  val mapping = mutable.LinkedHashMap[Int,ArrayBuffer[Any]]()
  def addMappingAt(address : Int,that : Any) = mapping.getOrElseUpdate(address,new ArrayBuffer[Any]) += that
  override def r(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrRead(that,bitOffset))
  override def w(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrWrite(that,bitOffset))
  override def r2w(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrReadToWriteOverride(that,bitOffset))
  override def onWrite(csrAddress: Int)(body: => Unit): Unit = addMappingAt(csrAddress, CsrOnWrite(() => body))
  override def onRead(csrAddress: Int)(body: => Unit): Unit =  addMappingAt(csrAddress, CsrOnRead(() => {body}))
}


trait CsrInterface{
  def onWrite(csrAddress : Int)(doThat : => Unit) : Unit
  def onRead(csrAddress : Int)(doThat : => Unit) : Unit
  def r(csrAddress : Int, bitOffset : Int, that : Data): Unit
  def w(csrAddress : Int, bitOffset : Int, that : Data): Unit
  def rw(csrAddress : Int, bitOffset : Int,that : Data): Unit ={
    r(csrAddress,bitOffset,that)
    w(csrAddress,bitOffset,that)
  }

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
}


trait IContextSwitching{
  def isContextSwitching : Bool
}
trait IWake{
  def askWake() : Unit
}

class CsrPlugin(val config: CsrPluginConfig) extends Plugin[VexRiscv] with ExceptionService with PrivilegeService with InterruptionInhibitor with ExceptionInhibitor with IContextSwitching with CsrInterface with IWake{
  import config._
  import CsrAccess._

  assert(!(wfiGenAsNop && wfiGenAsWait))

  def xlen = 32

  //Mannage ExceptionService calls
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  override def newExceptionPort(stage : Stage, priority : Int = 0) = {
    val interface = Flow(ExceptionCause())
    exceptionPortsInfos += ExceptionPortInfo(interface,stage,priority)
    interface
  }

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

  override def askWake(): Unit = thirdPartyWake := True

  override def isContextSwitching = contextSwitching

  object EnvCtrlEnum extends SpinalEnum(binarySequential){
    val NONE, XRET = newElement()
    val WFI = if(wfiGenAsWait) newElement() else null
    val ECALL = if(ecallGen) newElement() else null
    val EBREAK = if(ebreakGen) newElement() else null
  }

  object ENV_CTRL extends Stageable(EnvCtrlEnum())
  object IS_CSR extends Stageable(Bool)
  object CSR_WRITE_OPCODE extends Stageable(Bool)
  object CSR_READ_OPCODE extends Stageable(Bool)
  object PIPELINED_CSR_READ extends Stageable(Bits(32 bits))

  var allowInterrupts : Bool = null
  var allowException  : Bool = null

  val csrMapping = new CsrMapping()

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
  override def onRead(csrAddress: Int)(body: => Unit): Unit = csrMapping.onRead(csrAddress)(body)

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

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
    if(ebreakGen) decoderService.add(EBREAK,  defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.EBREAK, HAS_SIDE_EFFECT -> True))

    val  pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(pipeline.stages.last)
    jumpInterface.valid := False
    jumpInterface.payload.assignDontCare()


    if(supervisorGen) {
      redoInterface = pcManagerService.createJumpInterface(pipeline.execute, -1)
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
    forceMachineWire = False

    if(catchIllegalAccess || ecallGen || ebreakGen)
      selfException = newExceptionPort(pipeline.execute)

    allowInterrupts = True
    allowException = True

    for (i <- interruptSpecs) i.cond = i.cond.pull()


    pipeline.update(MPP, UInt(2 bits))
  }

  def inhibateInterrupts() : Unit = allowInterrupts := False
  def inhibateException() : Unit  = allowException  := False

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


    case class Xtvec() extends Bundle {
      val mode = Bits(2 bits)
      val base = UInt(xlen-2 bits)
    }

    val privilegeReg = privilegeGen generate RegInit(U"11")
    privilege := (if(privilegeGen) privilegeReg else U"11")

    when(forceMachineWire) { privilege := 3 }

    val machineCsr = pipeline plug new Area{
      //Define CSR registers
      // Status => MXR, SUM, TVM, TW, TSE ?
      val misa = new Area{
        val base = Reg(UInt(2 bits)) init(U"01") allowUnsetRegToAvoidLatch
        val extensions = Reg(Bits(26 bits)) init(misaExtensionsInit) allowUnsetRegToAvoidLatch
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
      val mcycle   = Reg(UInt(64 bits)) randBoot()
      val minstret = Reg(UInt(64 bits)) randBoot()


      val medeleg = supervisorGen generate new Area {
        val IAM, IAF, II, LAM, LAF, SAM, SAF, EU, ES, IPF, LPF, SPF = RegInit(False)
        val mapping = mutable.HashMap(0 -> IAM, 1 -> IAF, 2 -> II, 4 -> LAM, 5 -> LAF, 6 -> SAM, 7 -> SAF, 8 -> EU, 9 -> ES, 12 -> IPF, 13 -> LPF, 15 -> SPF)
      }
      val mideleg = supervisorGen generate new Area {
        val ST, SE, SS = RegInit(False)
      }

      if(mvendorid != null) READ_ONLY(CSR.MVENDORID, U(mvendorid))
      if(marchid   != null) READ_ONLY(CSR.MARCHID  , U(marchid  ))
      if(mimpid    != null) READ_ONLY(CSR.MIMPID   , U(mimpid   ))
      if(mhartid   != null) READ_ONLY(CSR.MHARTID  , U(mhartid  ))
      misaAccess(CSR.MISA, xlen-2 -> misa.base , 0 -> misa.extensions)

      //Machine CSR
      READ_WRITE(CSR.MSTATUS,11 -> mstatus.MPP, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
      READ_ONLY(CSR.MIP, 11 -> mip.MEIP, 7 -> mip.MTIP)
      READ_WRITE(CSR.MIP, 3 -> mip.MSIP)
      READ_WRITE(CSR.MIE, 11 -> mie.MEIE, 7 -> mie.MTIE, 3 -> mie.MSIE)

      mtvecAccess(CSR.MTVEC, 2 -> mtvec.base, 0 -> mtvec.mode)
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


        stvecAccess(CSR.STVEC, 2 -> stvec.base, 0 -> stvec.mode)
        sepcAccess(CSR.SEPC, sepc)
        if(sscratchGen) READ_WRITE(CSR.SSCRATCH, sscratch)
        scauseAccess(CSR.SCAUSE, xlen-1 -> scause.interrupt, 0 -> scause.exceptionCode)
        sbadaddrAccess(CSR.SBADADDR, stval)
        satpAccess(CSR.SATP, 31 -> satp.MODE, 22 -> satp.ASID, 0 -> satp.PPN)


        if(supervisorGen) {
          redoInterface.valid := False
          redoInterface.payload := decode.input(PC)
          onWrite(CSR.SATP){
            execute.arbitration.flushNext := True
            redoInterface.valid := True
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
      mcycle := mcycle + 1
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
        val firstStageIndexWithExceptionPort = exceptionPortsInfos.map(i => indexOf(i.stage)).min
        val exceptionValids = Vec(stages.map(s => Bool().setPartialName(s.getName())))
        val exceptionValidsRegs = Vec(stages.map(s => Reg(Bool).init(False).setPartialName(s.getName()))).allowUnsetRegToAvoidLatch
        val exceptionContext = Reg(ExceptionCause())
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
            case 1 => stagePortsInfos.head.port
            case _ => {
              val groupedPort = Flow(ExceptionCause())
              val valids = stagePortsInfos.map(_.port.valid)
              val codes = stagePortsInfos.map(_.port.payload)
              groupedPort.valid := valids.orR
              groupedPort.payload := MuxOH(OHMasking.first(stagePortsInfos.map(_.port.valid).asBits), codes)
              groupedPort
            }
          }
          ExceptionPortInfo(stagePort,s,0)
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
        val privilegeAllowInterrupts = mutable.HashMap[Int, Bool]()
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

      val hadException = RegNext(exception) init(False)
      pipelineLiberator.done.clearWhen(hadException)


      val targetPrivilege = CombInit(interrupt.targetPrivilege)
      if(exceptionPortCtrl != null) when(hadException) {
        targetPrivilege := exceptionPortCtrl.exceptionTargetPrivilege
      }

      val trapCause = CombInit(interrupt.code)
      if(exceptionPortCtrl != null) when( hadException){
        trapCause := exceptionPortCtrl.exceptionContext.code
      }

      val xtvec = Xtvec().assignDontCare()
      switch(targetPrivilege){
        if(supervisorGen) is(1) { xtvec := supervisorCsr.stvec }
        is(3){ xtvec := machineCsr.mtvec }
      }

      when(hadException || interruptJump){
        fetcher.haltIt() //Avoid having the fetch confused by the incomming privilege switch

        jumpInterface.valid         := True
        jumpInterface.payload       := (if(!xtvecModeGen) xtvec.base @@ U"00" else (xtvec.mode === 0 || hadException) ? (xtvec.base @@ U"00") | ((xtvec.base + trapCause) @@ U"00") )
        lastStage.arbitration.flushNext := True

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
              if(privilegeGen) privilegeReg := mstatus.MPP
            }
            if(supervisorGen) is(1){
              sstatus.SPP := U"0"
              sstatus.SIE := sstatus.SPIE
              sstatus.SPIE := True
              jumpInterface.payload := sepc
              if(privilegeGen) privilegeReg := U"0" @@ sstatus.SPP
            }
          }
        }
      }


      contextSwitching := jumpInterface.valid

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
        val blockedBySideEffects =  stagesFromExecute.tail.map(s => s.arbitration.isValid).asBits().orR // && s.input(HAS_SIDE_EFFECT)  to improve be less pessimistic

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


        if(ebreakGen) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.EBREAK){
          selfException.valid := True
          selfException.code := 3
        }


        val imm = IMM(input(INSTRUCTION))
        def writeSrc = input(SRC1)
      //  val readDataValid = True
        val readData = Bits(32 bits)
        val writeInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_WRITE_OPCODE)
        val readInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_READ_OPCODE)
        val writeEnable = writeInstruction && !arbitration.isStuck
        val readEnable  = readInstruction  && !arbitration.isStuck

        val readToWriteData = CombInit(readData)
        val writeData = if(noCsrAlu) writeSrc else input(INSTRUCTION)(13).mux(
          False -> writeSrc,
          True -> Mux(input(INSTRUCTION)(12), readToWriteData & ~writeSrc, readToWriteData | writeSrc)
        )



//        arbitration.haltItself setWhen(writeInstruction && !readDataRegValid)


        when(arbitration.isValid && input(IS_CSR)) {
          if(!pipelineCsrRead) output(REGFILE_WRITE_DATA) := readData
          arbitration.haltItself setWhen(blockedBySideEffects)
        }
        if(pipelineCsrRead){
          insert(PIPELINED_CSR_READ) := readData
          when(memory.arbitration.isValid && memory.input(IS_CSR)) {
            memory.output(REGFILE_WRITE_DATA) := memory.input(PIPELINED_CSR_READ)
          }
        }
//
//        Component.current.rework{
//          when(arbitration.isFiring && input(IS_CSR)) {
//            memory.input(REGFILE_WRITE_DATA).getDrivingReg := readData
//          }
//        }

        //Translation of the csrMapping into real logic
        val csrAddress = input(INSTRUCTION)(csrRange)
        Component.current.afterElaboration{
          def doJobs(jobs : ArrayBuffer[Any]): Unit ={
            val withWrite = jobs.exists(j => j.isInstanceOf[CsrWrite] || j.isInstanceOf[CsrOnWrite])
            val withRead = jobs.exists(j => j.isInstanceOf[CsrRead] || j.isInstanceOf[CsrOnRead])
            if(withRead && withWrite) {
              illegalAccess := False
            } else {
              if (withWrite) illegalAccess.clearWhen(input(CSR_WRITE_OPCODE))
              if (withRead) illegalAccess.clearWhen(input(CSR_READ_OPCODE))
            }

            when(writeEnable) {
              for (element <- jobs) element match {
                case element: CsrWrite => element.that.assignFromBits(writeData(element.bitOffset, element.that.getBitsWidth bits))
                case element: CsrOnWrite =>
                  element.doThat()
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
              readData := 0
              switch(csrAddress) {
                for ((address, jobs) <- csrMapping.mapping) {
                  is(address) {
                    doJobs(jobs)
                    for (element <- jobs) element match {
                      case element: CsrRead if element.that.getBitsWidth != 0 => readData(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
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
              readData := readDatas.reduceBalancedTree(_ | _)
              for ((address, jobs) <- csrMapping.mapping) {
                when(oh(address)){
                  doJobsOverride(jobs)
                }
              }
            }
          }

          when(privilege < csrAddress(9 downto 8).asUInt){
            illegalAccess := True
            readInstruction := False
            writeInstruction := False
          }
          illegalAccess clearWhen(!arbitration.isValid || !input(IS_CSR))
        }
      }
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
    csr.addInterrupt(interruptPending , code, privilege, Nil)
    csr.r(csrAddress = CSR.MIP, bitOffset = code,interruptPending)
    csr.rw(csrAddress = CSR.MIE, bitOffset = code, interruptEnable)
  }
  override def build(pipeline: VexRiscv): Unit = {}
}
