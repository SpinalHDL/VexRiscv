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
                            misaExtensionsInit   : Int,
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
                            wfiGenAsWait        : Boolean,
                            ecallGen            : Boolean,
                            mtvecModeGen        : Boolean = false,
                            noCsrAlu            : Boolean = false,
                            wfiGenAsNop         : Boolean = false,
                            ebreakGen           : Boolean = false,
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
                            deterministicInteruptionEntry : Boolean = false //Only used for simulatation purposes
                          ){
  assert(!ucycleAccess.canWrite)

  def noException = this.copy(ecallGen = false, ebreakGen = false, catchIllegalAccess = false)
}

object CsrPluginConfig{
  def all : CsrPluginConfig = all(0x00000020l)
  def small : CsrPluginConfig = small(0x00000020l)
  def smallest : CsrPluginConfig = smallest(0x00000020l)

  def all(mtvecInit : BigInt) : CsrPluginConfig = CsrPluginConfig(
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
    ucycleAccess   = CsrAccess.READ_ONLY
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
    ucycleAccess   = CsrAccess.NONE
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
    ucycleAccess   = CsrAccess.NONE
  )

}
case class CsrWrite(that : Data, bitOffset : Int)
case class CsrRead(that : Data , bitOffset : Int)
case class CsrOnWrite(doThat :() => Unit)
case class CsrOnRead(doThat : () => Unit)
case class CsrMapping() extends CsrInterface{
  val mapping = mutable.HashMap[Int,ArrayBuffer[Any]]()
  def addMappingAt(address : Int,that : Any) = mapping.getOrElseUpdate(address,new ArrayBuffer[Any]) += that
  override def r(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrRead(that,bitOffset))
  override def w(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrWrite(that,bitOffset))
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

class CsrPlugin(config: CsrPluginConfig) extends Plugin[VexRiscv] with ExceptionService with PrivilegeService with InterruptionInhibitor with ExceptionInhibitor with IContextSwitching with CsrInterface{
  import config._
  import CsrAccess._

  assert(!(wfiGenAsNop && wfiGenAsWait))

  def xlen = 32

  //Mannage ExceptionService calls
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  def exceptionCodeWidth = 4
  override def newExceptionPort(stage : Stage, priority : Int = 0) = {
    val interface = Flow(ExceptionCause())
    exceptionPortsInfos += ExceptionPortInfo(interface,stage,priority)
    interface
  }

  var jumpInterface : Flow[UInt] = null
  var timerInterrupt, externalInterrupt : Bool = null
  var timerInterruptS, externalInterruptS : Bool = null
  var privilege : UInt = null
  var selfException : Flow[ExceptionCause] = null
  var contextSwitching : Bool = null
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


  override def r(csrAddress: Int, bitOffset: Int, that: Data): Unit = csrMapping.r(csrAddress, bitOffset, that)
  override def w(csrAddress: Int, bitOffset: Int, that: Data): Unit = csrMapping.w(csrAddress, bitOffset, that)
  override def onWrite(csrAddress: Int)(body: => Unit): Unit = csrMapping.onWrite(csrAddress)(body)
  override def onRead(csrAddress: Int)(body: => Unit): Unit = csrMapping.onRead(csrAddress)(body)

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

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


    timerInterrupt    = in Bool() setName("timerInterrupt")
    externalInterrupt = in Bool() setName("externalInterrupt")
    if(supervisorGen){
      timerInterruptS    = in Bool() setName("timerInterruptS")
      externalInterruptS = in Bool() setName("externalInterruptS")
    }
    contextSwitching = Bool().setName("contextSwitching")

    privilege = RegInit(U"11").setName("CsrPlugin_privilege")

    if(catchIllegalAccess || ecallGen || ebreakGen)
      selfException = newExceptionPort(pipeline.execute)

    allowInterrupts = True
    allowException = True
  }

  def inhibateInterrupts() : Unit = allowInterrupts := False
  def inhibateException() : Unit  = allowException  := False

  def isUser(stage : Stage) : Bool = privilege === 0

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    val fetcher = service(classOf[IBusFetcher])

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


    val machineCsr = pipeline plug new Area{
      //Define CSR registers
      // Status => MXR, SUM, TVM, TW, TSE ?
      val misa = new Area{
        val base = Reg(UInt(2 bits)) init(U"01") allowUnsetRegToAvoidLatch
        val extensions = Reg(Bits(26 bits)) init(misaExtensionsInit) allowUnsetRegToAvoidLatch
      }


      val mtvec = new Area{
        val mode = Reg(Bits(2 bits)).allowUnsetRegToAvoidLatch
        val base = Reg(UInt(xlen-2 bits)).allowUnsetRegToAvoidLatch
      }

      if(mtvecInit != null) mtvec.mode init(mtvecInit & 0x3)
      if(mtvecInit != null) mtvec.base init(mtvecInit / 4)
      val mepc = Reg(UInt(xlen bits))
      val mstatus = new Area{
        val MIE, MPIE = RegInit(False)
        val MPP = RegInit(U"11")
      }
      val mip = new Area{
        val MEIP = RegNext(externalInterrupt) init(False)
        val MTIP = RegNext(timerInterrupt) init(False)
        val MSIP = RegInit(False)
      }
      val mie = new Area{
        val MEIE, MTIE, MSIE = RegInit(False)
      }
      val mscratch = if(mscratchGen) Reg(Bits(xlen bits)) else null
      val mcause   = new Area{
        val interrupt = Reg(Bool)
        val exceptionCode = Reg(UInt(exceptionCodeWidth bits))
      }
      val mtval = Reg(UInt(xlen bits))
      val mcycle   = Reg(UInt(64 bits)) randBoot()
      val minstret = Reg(UInt(64 bits)) randBoot()



      val medeleg = Reg(Bits(32 bits)) init(0)
      val mideleg = Reg(Bits(32 bits)) init(0)

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

      medelegAccess(CSR.MEDELEG, medeleg)
      midelegAccess(CSR.MIDELEG, mideleg)

      //User CSR
      ucycleAccess(CSR.UCYCLE, mcycle(31 downto 0))
      ucycleAccess(CSR.UCYCLEH, mcycle(31 downto 0))
    }

    val supervisorCsr = ifGen(supervisorGen) {
      pipeline plug new Area {
        val sstatus = new Area {
          val SIE, SPIE = RegInit(False)
          val SPP = RegInit(U"1")
        }

        val sip = new Area {
          val SEIP = RegNext(externalInterruptS) init (False)
          val STIP = RegNext(timerInterruptS) init (False)
          val SSIP = RegInit(False)
        }
        val sie = new Area {
          val SEIE, STIE, SSIE = RegInit(False)
        }
        val stvec = Reg(UInt(xlen bits)).allowUnsetRegToAvoidLatch
        val sscratch = if (sscratchGen) Reg(Bits(xlen bits)) else null

        val scause = new Area {
          val interrupt = Reg(Bool)
          val exceptionCode = Reg(UInt(exceptionCodeWidth bits))
        }
        val stval = Reg(UInt(xlen bits))
        val sepc = Reg(UInt(xlen bits))
        val satp = new Area {
          val PPN = Reg(Bits(22 bits))
          val ASID = Reg(Bits(9 bits))
          val MODE = Reg(Bits(1 bits))
        }

        //Supervisor CSR
        WRITE_ONLY(CSR.SSTATUS,8 -> sstatus.SPP, 5 -> sstatus.SPIE, 1 -> sstatus.SIE)
        for(offset <- List(0, 0x200)) {
          READ_ONLY(CSR.SSTATUS,8 -> sstatus.SPP, 5 -> sstatus.SPIE, 1 -> sstatus.SIE)
        }
        READ_ONLY(CSR.SIP, 9 -> sip.SEIP, 5 -> sip.STIP)
        READ_WRITE(CSR.SIP, 1 -> sip.SSIP)
        READ_WRITE(CSR.SIE, 9 -> sie.SEIE, 5 -> sie.STIE, 1 -> sie.SSIE)

        stvecAccess(CSR.STVEC, stvec)
        sepcAccess(CSR.SEPC, sepc)
        if(sscratchGen) READ_WRITE(CSR.SSCRATCH, sscratch)
        scauseAccess(CSR.SCAUSE, xlen-1 -> scause.interrupt, 0 -> scause.exceptionCode)
        sbadaddrAccess(CSR.SBADADDR, stval)
        satpAccess(CSR.SATP, 31 -> satp.MODE, 22 -> satp.ASID, 0 -> satp.PPN)
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

      case class InterruptSource(cond : Bool, id : Int)
      case class InterruptModel(privilege : Int, privilegeCond : Bool, sources : ArrayBuffer[InterruptSource])
      val interruptModel = ArrayBuffer[InterruptModel]()
      if(supervisorGen) interruptModel += InterruptModel(1, sstatus.SIE && privilege <= "01", ArrayBuffer(
        InterruptSource(sip.STIP && sie.STIE,  5),
        InterruptSource(sip.SSIP && sie.SSIE,  1),
        InterruptSource(sip.SEIP && sie.SEIE,  9)
      ))

      interruptModel += InterruptModel(3, mstatus.MIE , ArrayBuffer(
        InterruptSource(mip.MTIP && mie.MTIE,  7),
        InterruptSource(mip.MSIP && mie.MSIE,  3),
        InterruptSource(mip.MEIP && mie.MEIE, 11)
      ))

      case class DelegatorModel(value : Bits, source : Int, target : Int)
      def solveDelegators(delegators : Seq[DelegatorModel], id : Int, lowerBound : Int): UInt = {
        val filtredDelegators = delegators.filter(_.target >= lowerBound)
        val ret = U(lowerBound, 2 bits)
        for(d <- filtredDelegators){
          when(!d.value(id)){
            ret := d.source
          }
        }
        ret
      }

      def solveDelegators(delegators : Seq[DelegatorModel], id : UInt, lowerBound : UInt): UInt = {
        if(delegators.isEmpty) return CombInit(lowerBound)
        val ret = U(delegators.last.target, 2 bits)
        for(d <- delegators){
          when(!d.value(id) || d.target < lowerBound){
            ret := d.source
          }
        }
        ret
      }

      val interruptDelegators = ArrayBuffer[DelegatorModel]()
      if(midelegAccess.canWrite) interruptDelegators += DelegatorModel(mideleg,3, 1)

      val exceptionDelegators = ArrayBuffer[DelegatorModel]()
      if(medelegAccess.canWrite) exceptionDelegators += DelegatorModel(medeleg,3, 1)


      val mepcCaptureStage = if(exceptionPortsInfos.nonEmpty) lastStage else decode


      //Aggregate all exception port and remove required instructions
      val exceptionPortCtrl = if(exceptionPortsInfos.nonEmpty) new Area{
        val firstStageIndexWithExceptionPort = exceptionPortsInfos.map(i => indexOf(i.stage)).min
        val exceptionValids = Vec(stages.map(s => Bool().setPartialName(s.getName())))
        val exceptionValidsRegs = Vec(stages.map(s => Reg(Bool).init(False).setPartialName(s.getName()))).allowUnsetRegToAvoidLatch
        val exceptionContext = Reg(ExceptionCause())
        val exceptionTargetPrivilege = solveDelegators(exceptionDelegators, exceptionContext.code, privilege)

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
        sortedByStage.zipWithIndex.foreach(e => e._1.port.setName(e._1.stage.getName() + "_exception_agregat"))
        exceptionValids := exceptionValidsRegs
        for(portInfo <- sortedByStage; port = portInfo.port ; stage = portInfo.stage; stageId = indexOf(portInfo.stage)) {
          when(port.valid) {
            if(indexOf(stage) != 0) stages(indexOf(stage) - 1).arbitration.flushAll := True
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
          if(stage != stages.last) when(stage.arbitration.isFlushed){
            exceptionValids(stageId) := False
          }
        }

        when(exceptionValidsRegs.orR){
          fetcher.haltIt()
//          fetcher.flushIt()
        }
      } else null





      val interrupt = False
      val interruptCode = UInt(4 bits).assignDontCare().addTag(Verilator.public)
      val interruptTargetPrivilege = UInt(2 bits).assignDontCare()


      for(model <- interruptModel){
        when(model.privilegeCond){
          when(model.sources.map(_.cond).orR){
            interrupt := True
          }
          for(source <- model.sources){
            when(source.cond){
              interruptCode := source.id
              interruptTargetPrivilege := solveDelegators(interruptDelegators, source.id, model.privilege)
            }
          }
        }
      }
      interrupt.clearWhen(!allowInterrupts)

      val exception = if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionValids.last && allowException else False
      val lastStageWasWfi = if(wfiGenAsWait) RegNext(lastStage.arbitration.isFiring && lastStage.input(ENV_CTRL) === EnvCtrlEnum.WFI) init(False) else False



      //Used to make the pipeline empty softly (for interrupts)
      val pipelineLiberator = new Area{
        when(interrupt && decode.arbitration.isValid){
          decode.arbitration.haltByOther := True
        }

        val done = !stagesFromExecute.map(_.arbitration.isValid).orR && fetcher.pcValid(mepcCaptureStage)
        if(exceptionPortCtrl != null) done.clearWhen(exceptionPortCtrl.exceptionValidsRegs.tail.orR)
      }

      //Interrupt/Exception entry logic
      val interruptJump = Bool.addTag(Verilator.public)
      interruptJump := interrupt && pipelineLiberator.done

      val hadException = RegNext(exception) init(False)
      pipelineLiberator.done.clearWhen(hadException)


      val targetPrivilege = CombInit(interruptTargetPrivilege)
      if(exceptionPortCtrl != null) when(hadException) {
        targetPrivilege := exceptionPortCtrl.exceptionTargetPrivilege
      }

      val trapCause = CombInit(interruptCode)
      if(exceptionPortCtrl != null) when( hadException){
        trapCause := exceptionPortCtrl.exceptionContext.code
      }

      when(exception || interruptJump){
        switch(privilege){
          if(supervisorGen) is(1) {
            sepc := mepcCaptureStage.input(PC)
          }
          is(3){
            mepc := mepcCaptureStage.input(PC)
          }
        }
      }

      when(hadException || interruptJump){
        jumpInterface.valid         := True
        jumpInterface.payload       := (if(!mtvecModeGen) mtvec.base @@ "00" else (mtvec.mode === 0 || hadException) ? (mtvec.base @@ "00") | ((mtvec.base + trapCause) @@ "00") )
        beforeLastStage.arbitration.flushAll := True

        switch(targetPrivilege){
          if(supervisorGen) is(1) {
            sstatus.SIE := False
            sstatus.SPIE := sstatus.SIE
            sstatus.SPP := privilege(0 downto 0)
            scause.interrupt := !hadException
            scause.exceptionCode := trapCause
            if (exceptionPortCtrl != null) {
              stval := exceptionPortCtrl.exceptionContext.badAddr
            }
          }

          is(3){
            mstatus.MIE  := False
            mstatus.MPIE := mstatus.MIE
            mstatus.MPP  := privilege
            mcause.interrupt := !hadException
            mcause.exceptionCode := trapCause
            if(exceptionPortCtrl != null) {
              mtval := exceptionPortCtrl.exceptionContext.badAddr
            }
          }
        }
      }

      lastStage plug new Area{
        import lastStage._

        //Manage MRET / SRET instructions
        when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.XRET) {
        jumpInterface.payload := mepc
          jumpInterface.valid := True
          beforeLastStage.arbitration.flushAll := True
          switch(input(INSTRUCTION)(29 downto 28)){
            is(3){
              mstatus.MIE := mstatus.MPIE
              mstatus.MPP := U"00"
              mstatus.MPIE := True
              privilege := mstatus.MPP
            }
            if(supervisorGen) is(1){
              sstatus.SIE := sstatus.SPIE
              sstatus.SPP := U"0"
              sstatus.SPIE := True
              privilege := U"0" @@ sstatus.SPP
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
             (input(INSTRUCTION)(14 downto 13) === "01" && input(INSTRUCTION)(rs1Range) === 0)
          || (input(INSTRUCTION)(14 downto 13) === "11" && imm.z === 0)
        )
        insert(CSR_READ_OPCODE) := input(INSTRUCTION)(13 downto 7) =/= B"0100000"
      }


      execute plug new Area{
        import execute._
        //Manage WFI instructions
        if(wfiGenAsWait) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.WFI){
          when(!interrupt){
            arbitration.haltItself := True
          }
        }
      }

      decode.arbitration.haltByOther setWhen(stagesFromExecute.dropRight(1).map(s => s.arbitration.isValid && s.input(ENV_CTRL) === EnvCtrlEnum.XRET).asBits.orR)

      execute plug new Area {
        import execute._
        def previousStage = decode
        val blockedBySideEffects =  stagesFromExecute.tail.map(s => s.arbitration.isValid).asBits().orR // && s.input(HAS_SIDE_EFFECT)  to improve be less pessimistic

        val illegalAccess = True
        val illegalInstruction = False
        if(selfException != null) {
          selfException.valid := False
          selfException.code.assignDontCare()
          selfException.badAddr.assignDontCare()
          if(catchIllegalAccess) when(illegalAccess || illegalInstruction){
            selfException.valid := True
            selfException.code := 2
          }
        }

        //Manage MRET / SRET instructions
        when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.XRET) {
          //TODO check MPP value too
          when(input(INSTRUCTION)(29 downto 28).asUInt =/= privilege) {
            illegalInstruction := True
          }
        }


        //Manage ECALL instructions
        if(ecallGen) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.ECALL){
          selfException.valid := True
          selfException.code := 11
        }


        if(ebreakGen) when(arbitration.isValid && input(ENV_CTRL) === EnvCtrlEnum.EBREAK){
          selfException.valid := True
          selfException.code := 3
        }


        val imm = IMM(input(INSTRUCTION))
        def writeSrc = input(SRC1)
      //  val readDataValid = True
        val readData = B(0, 32 bits)
        val writeInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_WRITE_OPCODE)
        val readInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_READ_OPCODE)
        val writeEnable = writeInstruction && ! blockedBySideEffects && !arbitration.isStuckByOthers// &&  readDataRegValid
        val readEnable  = readInstruction  && ! blockedBySideEffects && !arbitration.isStuckByOthers// && !readDataRegValid
        //arbitration.isStuckByOthers, in case of the hazardPlugin is in the executeStage


//        def readDataReg = memory.input(REGFILE_WRITE_DATA)  //PIPE OPT
//        val readDataRegValid = Reg(Bool) setWhen(arbitration.isValid) clearWhen(!arbitration.isStuck)
//        val writeDataEnable = input(INSTRUCTION)(13) ? writeSrc | B"xFFFFFFFF"
//        val writeData = if(noCsrAlu) writeSrc else input(INSTRUCTION)(13).mux(
//          False -> writeSrc,
//          True -> Mux(input(INSTRUCTION)(12), ~writeSrc,  writeSrc)
//        )
        val writeData = if(noCsrAlu) writeSrc else input(INSTRUCTION)(13).mux(
          False -> writeSrc,
          True -> Mux(input(INSTRUCTION)(12), readData & ~writeSrc, readData | writeSrc)
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
        Component.current.addPrePopTask(() => {
          switch(csrAddress) {
            for ((address, jobs) <- csrMapping.mapping) {
              is(address) {
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

                for (element <- jobs) element match {
                  case element: CsrRead if element.that.getBitsWidth != 0 => readData(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
                  case _ =>
                }

                when(readEnable) {
                  for (element <- jobs) element match {
                    case element: CsrOnRead =>
                      element.doThat()
                    case _ =>
                  }
                }
              }
            }
          }

          illegalAccess setWhen(privilege < csrAddress(9 downto 8).asUInt)
          illegalAccess clearWhen(!arbitration.isValid || !input(IS_CSR))
        })
      }
    }
  }
}
