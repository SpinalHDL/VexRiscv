package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._

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
                            wfiGen              : Boolean,
                            ecallGen            : Boolean,
                            deterministicInteruptionEntry : Boolean = false //Only used for simulatation purposes

                          ){
  assert(!ucycleAccess.canWrite)

  def noException = this.copy(ecallGen = false, catchIllegalAccess = false)
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
    wfiGen         = true,
    ucycleAccess   = CsrAccess.READ_ONLY
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
    wfiGen         = false,
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
    wfiGen         = false,
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
  def r [T <: Data](csrAddress : Int, thats : (Int, Data)*) : Unit = for(that <- thats) r(csrAddress,that._1, that._2)
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

class CsrPlugin(config : CsrPluginConfig) extends Plugin[VexRiscv] with ExceptionService with PrivilegeService with InterruptionInhibitor with ExceptionInhibitor with IContextSwitching with CsrInterface{
  import config._
  import CsrAccess._

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
  var pluginExceptionPort : Flow[ExceptionCause] = null
  var timerInterrupt : Bool = null
  var externalInterrupt : Bool = null
  var privilege : Bits = null
  var selfException : Flow[ExceptionCause] = null
  var contextSwitching : Bool = null
  override def isContextSwitching = contextSwitching

  object EnvCtrlEnum extends SpinalEnum(binarySequential){
    val NONE, EBREAK, MRET= newElement()
    val WFI = if(wfiGen) newElement() else null
    val ECALL = if(ecallGen) newElement() else null
  }

  object ENV_CTRL extends Stageable(EnvCtrlEnum())
  object IS_CSR extends Stageable(Bool)
  object CSR_WRITE_OPCODE extends Stageable(Bool)
  object CSR_READ_OPCODE extends Stageable(Bool)

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
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True
    )

    val nonImmediatActions = defaultCsrActions ++ List(
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      RS1_USE                 -> True
    )

    val immediatActions = defaultCsrActions

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
      // EBREAK -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.EBREAK)), //TODO
      MRET   -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.MRET))
    ))
    if(wfiGen)   decoderService.add(WFI,  defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.WFI))
    if(ecallGen) decoderService.add(ECALL,  defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.ECALL))

    val  pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(pipeline.writeBack)
    jumpInterface.valid := False
    jumpInterface.payload.assignDontCare()

    if(ecallGen) {
      pluginExceptionPort = newExceptionPort(pipeline.execute)
      pluginExceptionPort.valid := False
      pluginExceptionPort.payload.assignDontCare()
    }

    timerInterrupt    = in Bool() setName("timerInterrupt")
    externalInterrupt = in Bool() setName("externalInterrupt")
    contextSwitching = Bool().setName("contextSwitching")

    privilege = RegInit(B"11")

    if(catchIllegalAccess)
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

    pipeline plug new Area{
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


      //Define CSR registers
      val misa = new Area{
        val base = Reg(UInt(2 bits)) init(U"01") allowUnsetRegToAvoidLatch
        val extensions = Reg(Bits(26 bits)) init(misaExtensionsInit) allowUnsetRegToAvoidLatch
      }
      val mtvec = Reg(UInt(xlen bits)).allowUnsetRegToAvoidLatch
      if(mtvecInit != null) mtvec init(mtvecInit)
      val mepc = Reg(UInt(xlen bits))
      val mstatus = new Area{
        val MIE, MPIE = RegInit(False)
        val MPP = RegInit(B"11")
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
      val mbadaddr = Reg(UInt(xlen bits))
      val mcycle   = Reg(UInt(64 bits)) randBoot()
      val minstret = Reg(UInt(64 bits)) randBoot()



      //Define CSR registers accessibility
      if(mvendorid != null) READ_ONLY(CSR.MVENDORID, U(mvendorid))
      if(marchid   != null) READ_ONLY(CSR.MARCHID  , U(marchid  ))
      if(mimpid    != null) READ_ONLY(CSR.MIMPID   , U(mimpid   ))
      if(mhartid   != null) READ_ONLY(CSR.MHARTID  , U(mhartid  ))

      //Machine CSR
      misaAccess(CSR.MISA, xlen-2 -> misa.base , 0 -> misa.extensions)
      READ_ONLY(CSR.MIP, 11 -> mip.MEIP, 7 -> mip.MTIP)
      READ_WRITE(CSR.MIP, 3 -> mip.MSIP)
      READ_WRITE(CSR.MIE, 11 -> mie.MEIE, 7 -> mie.MTIE, 3 -> mie.MSIE)

      mtvecAccess(CSR.MTVEC, mtvec)
      mepcAccess(CSR.MEPC, mepc)
      READ_WRITE(CSR.MSTATUS,11 -> mstatus.MPP, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
      if(mscratchGen) READ_WRITE(CSR.MSCRATCH, mscratch)
      mcauseAccess(CSR.MCAUSE, xlen-1 -> mcause.interrupt, 0 -> mcause.exceptionCode)
      mbadaddrAccess(CSR.MBADADDR, mbadaddr)
      mcycleAccess(CSR.MCYCLE, mcycle(31 downto 0))
      mcycleAccess(CSR.MCYCLEH, mcycle(63 downto 32))
      minstretAccess(CSR.MINSTRET, minstret(31 downto 0))
      minstretAccess(CSR.MINSTRETH, minstret(63 downto 32))

      //User CSR
      ucycleAccess(CSR.UCYCLE, mcycle(31 downto 0))



      //Manage counters
      mcycle := mcycle + 1
      when(writeBack.arbitration.isFiring) {
        minstret := minstret + 1
      }

      val mepcCaptureStage = if(exceptionPortsInfos.nonEmpty) writeBack else decode


      //Aggregate all exception port and remove required instructions
      val exceptionPortCtrl = if(exceptionPortsInfos.nonEmpty) new Area{
        val firstStageIndexWithExceptionPort = exceptionPortsInfos.map(i => indexOf(i.stage)).min
        val exceptionValids = Vec(stages.map(s => Bool().setPartialName(s.getName())))
        val exceptionValidsRegs = Vec(stages.map(s => Reg(Bool).init(False).setPartialName(s.getName()))).allowUnsetRegToAvoidLatch
        val exceptionContext = Reg(ExceptionCause())

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
//            if(indexOf(stage) != 0) stages(indexOf(stage) - 1).arbitration.flushAll := True
            stage.arbitration.removeIt := True
            exceptionValids(stageId) := True
            when(!exceptionValidsRegs.takeRight(stages.length-stageId-1).fold(False)(_ || _)) {
              exceptionContext := port.payload
            }
          }
        }

        for(stageId <- firstStageIndexWithExceptionPort until stages.length; stage = stages(stageId) ){
          when(stage.arbitration.isFlushed){
            exceptionValids(stageId) := False
          }
          val previousStage = if(stageId == firstStageIndexWithExceptionPort) stage else stages(stageId-1)
          when(!stage.arbitration.isStuck){
            exceptionValidsRegs(stageId) := (if(stageId != firstStageIndexWithExceptionPort) exceptionValids(stageId-1) && !previousStage.arbitration.isStuck else False)
          }otherwise{
            exceptionValidsRegs(stageId) := exceptionValids(stageId)
          }

          if(stageId != 0){
            when(exceptionValidsRegs(stageId)){
              stages(stageId-1).arbitration.haltByOther := True
            }
          }
        }
      } else null



      val interruptRequest = ((mip.MSIP && mie.MSIE) || (mip.MEIP && mie.MEIE) || (mip.MTIP && mie.MTIE)) && mstatus.MIE
      val interrupt = interruptRequest && allowInterrupts
      val exception = if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionValids.last && allowException else False
      val writeBackWasWfi = if(wfiGen) RegNext(writeBack.arbitration.isFiring && writeBack.input(ENV_CTRL) === EnvCtrlEnum.WFI) init(False) else False



      val deteriministicLogic = if(deterministicInteruptionEntry) new Area{
        val counter = Reg(UInt(4 bits)) init(0)

        when(!interruptRequest || !mstatus.MIE){
          counter := 0
        } otherwise {
          when(counter < 6){
            when(writeBack.arbitration.isFiring){
              counter := counter + 1
            }
          }
          val counterPlusPending = counter + CountOne(stages.tail.map(_.arbitration.isValid))
          when(counterPlusPending < 6){
            inhibateInterrupts()
          }
        }
      }


      //Used to make the pipeline empty softly (for interrupts)
      val pipelineLiberator = new Area{
        when(interrupt && decode.arbitration.isValid){
          decode.arbitration.haltByOther := True
        }

        val done = !List(execute, memory, writeBack).map(_.arbitration.isValid).orR && fetcher.pcValid(mepcCaptureStage)
        if(exceptionPortCtrl != null) done.clearWhen(exceptionPortCtrl.exceptionValidsRegs.tail.orR)
      }

      //Interrupt/Exception entry logic
      val interruptCode = ((mip.MEIP && mie.MEIE) ? U(11) | ((mip.MSIP && mie.MSIE) ? U(3) | U(7))).addTag(Verilator.public)
      val interruptJump = Bool.addTag(Verilator.public)
      interruptJump := interrupt && pipelineLiberator.done

      when(exception || interruptJump){
        jumpInterface.valid := True
        jumpInterface.payload := mtvec
        memory.arbitration.flushAll := True
        if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionValidsRegs.last := False
        mstatus.MIE  := False
        mstatus.MPIE := mstatus.MIE
        mstatus.MPP  := privilege
        mepc := mepcCaptureStage.input(PC)
        mcause.interrupt := interruptJump
        mcause.exceptionCode := interruptCode
      }

      when(RegNext(exception)){
        mbadaddr := (if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionContext.badAddr else U(0))
        mcause.exceptionCode := (if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionContext.code else U(0))
      }


      //Manage MRET instructions
      when(execute.arbitration.isValid && execute.input(ENV_CTRL) === EnvCtrlEnum.MRET) {
        when(memory.arbitration.isValid || writeBack.arbitration.isValid){
          execute.arbitration.haltItself := True
        } otherwise {
          jumpInterface.valid := True
          jumpInterface.payload := mepc
          decode.arbitration.flushAll := True
          mstatus.MIE := mstatus.MPIE
          privilege := mstatus.MPP
        }
      }

      //Manage ECALL instructions
      if(ecallGen) when(execute.arbitration.isValid && execute.input(ENV_CTRL) === EnvCtrlEnum.ECALL){
        pluginExceptionPort.valid := True
        pluginExceptionPort.code := 11
      }

      //Manage WFI instructions
      if(wfiGen) when(execute.arbitration.isValid && execute.input(ENV_CTRL) === EnvCtrlEnum.WFI){
        when(!interrupt){
          execute.arbitration.haltItself := True
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
        //Assure that the CSR access are in the execute stage when there is nothing left in memory/writeback stages to avoid exception hazard
        arbitration.haltItself setWhen(arbitration.isValid && input(IS_CSR) && (execute.arbitration.isValid || memory.arbitration.isValid))
      }
      execute plug new Area {
        import execute._

        val illegalAccess =  arbitration.isValid && input(IS_CSR)
        if(catchIllegalAccess) {
          val illegalInstruction = arbitration.isValid && privilege === 0 && (input(ENV_CTRL) === EnvCtrlEnum.EBREAK || input(ENV_CTRL) === EnvCtrlEnum.MRET)

          selfException.valid := illegalAccess || illegalInstruction
          selfException.code := 2
          selfException.badAddr.assignDontCare()
        }

        val imm = IMM(input(INSTRUCTION))
        val writeSrc = input(INSTRUCTION)(14) ? imm.z.asBits.resized | input(SRC1)
        val readData = B(0, 32 bits)
        def readDataReg = memory.input(REGFILE_WRITE_DATA)  //PIPE OPT
        val readDataRegValid = Reg(Bool) setWhen(arbitration.isValid) clearWhen(!arbitration.isStuck)
        val writeData = input(INSTRUCTION)(13).mux(
          False -> writeSrc,
          True -> Mux(input(INSTRUCTION)(12), readDataReg & ~writeSrc, readDataReg | writeSrc)
        )

        val writeInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_WRITE_OPCODE)
        val readInstruction = arbitration.isValid && input(IS_CSR) && input(CSR_READ_OPCODE)

        arbitration.haltItself setWhen(writeInstruction && !readDataRegValid)
        val writeEnable = writeInstruction &&  readDataRegValid
        val readEnable  = readInstruction  && !readDataRegValid

        when(arbitration.isValid && input(IS_CSR)) {
          output(REGFILE_WRITE_DATA) := readData
        }

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
          illegalAccess setWhen(privilege.asUInt < csrAddress(9 downto 8).asUInt)
        })
      }
    }
  }
}
