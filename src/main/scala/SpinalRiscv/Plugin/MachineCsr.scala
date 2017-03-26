package SpinalRiscv.Plugin

import spinal.core._
import spinal.lib._
import SpinalRiscv._
import SpinalRiscv.Riscv._

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable

/**
 * Created by spinalvm on 21.03.17.
 */

trait CsrAccess
object CsrAccess {
  object WRITE_ONLY extends CsrAccess
  object READ_ONLY extends CsrAccess
  object READ_WRITE extends CsrAccess
  object NONE extends CsrAccess
}

case class ExceptionPortInfo(port : Flow[ExceptionCause],stage : Stage)
case class MachineCsrConfig(
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
  wfiGen              : Boolean,
  ecallGen            : Boolean
)


case class CsrWrite(that : Data, bitOffset : Int)
case class CsrRead(that : Data , bitOffset : Int)
case class CsrMapping(){
  val mapping = mutable.HashMap[Int,ArrayBuffer[Any]]()
  def addMappingAt(address : Int,that : Any) = mapping.getOrElseUpdate(address,new ArrayBuffer[Any]) += that
  def r(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrRead(that,bitOffset))
  def w(csrAddress : Int, bitOffset : Int, that : Data): Unit = addMappingAt(csrAddress, CsrWrite(that,bitOffset))
  def rw(csrAddress : Int, bitOffset : Int,that : Data): Unit ={
    r(csrAddress,bitOffset,that)
    w(csrAddress,bitOffset,that)
  }

  def rw(csrAddress : Int, thats : (Int, Data)*) : Unit = for(that <- thats) rw(csrAddress,that._1, that._2)
  def r [T <: Data](csrAddress : Int, thats : (Int, Data)*) : Unit = for(that <- thats) r(csrAddress,that._1, that._2)
  def rw[T <: Data](csrAddress : Int, that : T): Unit = rw(csrAddress,0,that)
  def r [T <: Data](csrAddress : Int, that : T): Unit = r(csrAddress,0,that)
}




class MachineCsr(config : MachineCsrConfig) extends Plugin[VexRiscv] with ExceptionService {
  import config._
  import CsrAccess._

  def xlen = 32

  //Mannage ExceptionService calls
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  def exceptionCodeWidth = 4
  override def newExceptionPort(stage : Stage) = {
    val interface = Flow(ExceptionCause())
    exceptionPortsInfos += ExceptionPortInfo(interface,stage)
    interface
  }

  var jumpInterface : Flow[UInt] = null
  var pluginExceptionPort : Flow[ExceptionCause] = null
  var timerInterrupt : Bool = null
  var externalInterrupt : Bool = null

  object EnvCtrlEnum extends SpinalEnum(binarySequential){
    val NONE, EBREAK, MRET= newElement()
    val WFI = if(wfiGen) newElement() else null
    val ECALL = if(ecallGen) newElement() else null
  }

  object ENV_CTRL extends Stageable(EnvCtrlEnum())
  object IS_CSR extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    val defaultEnv = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True
    )

    val defaultCsrActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      IS_CSR                   -> True,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> False
    )

    val nonImmediatActions = defaultCsrActions ++ List(
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      REG1_USE                 -> True
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
    jumpInterface = pcManagerService.createJumpInterface(pipeline.execute)
    jumpInterface.valid := False
    jumpInterface.payload.assignDontCare()

    if(ecallGen) {
      pluginExceptionPort = newExceptionPort(pipeline.execute)
      pluginExceptionPort.valid := False
      pluginExceptionPort.payload.assignDontCare()
    }

    timerInterrupt    = in Bool() setName("timerInterrupt")
    externalInterrupt = in Bool() setName("externalInterrupt")
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    pipeline plug new Area{
      //Define CSR mapping utilities
      val csrMapping = new CsrMapping()
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
        val base = Reg(UInt(2 bits)) init(U"01")
        val extensions = Reg(Bits(26 bits)) init(misaExtensionsInit)
      }
      val mtvec = RegInit(U(mtvecInit,xlen bits))
      val mepc = Reg(UInt(xlen bits))
      val mstatus = new Area{
        val MIE, MPIE = RegInit(False)
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

      misaAccess(CSR.MISA, xlen-2 -> misa.base , 0 -> misa.extensions)
      READ_ONLY(CSR.MIP, 11 -> mip.MEIP, 7 -> mip.MTIP)
      READ_WRITE(CSR.MIP, 3 -> mip.MSIP)
      READ_WRITE(CSR.MIE, 11 -> mie.MEIE, 7 -> mie.MTIE, 3 -> mie.MSIE)

      mtvecAccess(CSR.MTVEC, mtvec)
      mepcAccess(CSR.MEPC, mepc)
      READ_WRITE(CSR.MSTATUS, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
      if(mscratchGen) READ_WRITE(CSR.MSCRATCH, mscratch)
      mcauseAccess(CSR.MCAUSE, xlen-1 -> mcause.interrupt, 0 -> mcause.exceptionCode)
      mbadaddrAccess(CSR.MBADADDR, mbadaddr)
      mcycleAccess(CSR.MCYCLE, mcycle(31 downto 0))
      mcycleAccess(CSR.MCYCLEH, mcycle(63 downto 32))
      minstretAccess(CSR.MINSTRET, minstret(31 downto 0))
      minstretAccess(CSR.MINSTRETH, minstret(63 downto 32))



      //Manage counters
      mcycle := mcycle + 1
      when(writeBack.arbitration.isFiring) {
        minstret := minstret + 1
      }



      //Used to make the pipeline empty softly (for interrupts)
      val pipelineLiberator = new Area{
        val enable = False
        prefetch.arbitration.haltIt setWhen(enable)
        val done = ! List(fetch, decode, execute, memory).map(_.arbitration.isValid).orR
      }



      //Aggregate all exception port and remove required instructions
      val exceptionPortCtrl = if(exceptionPortsInfos.nonEmpty) new Area{
        val firstStageIndexWithExceptionPort = exceptionPortsInfos.map(i => indexOf(i.stage)).min
        val exceptionValids = Vec(Bool,stages.length)
        val exceptionValidsRegs = Vec(Reg(Bool) init(False), stages.length)
        val exceptionContext = Reg(ExceptionCause())
        val pipelineHasException = exceptionValids.orR

        pipelineLiberator.enable setWhen(pipelineHasException)

        val groupedByStage = exceptionPortsInfos.map(_.stage).distinct.map(s => {
          assert(s != writeBack)
          val stagePortsInfos = exceptionPortsInfos.filter(_.stage == s)
          val stagePort = stagePortsInfos.length match{
            case 1 => stagePortsInfos.head.port
            case _ => {
              val groupedPort = Flow(ExceptionCause())
              val valids = stagePortsInfos.map(_.port.valid)
              val codes = stagePortsInfos.map(_.port.payload)
              groupedPort.valid := valids.orR
              groupedPort.payload := MuxOH(stagePortsInfos.map(_.port.valid), codes)
              groupedPort
            }
          }
          ExceptionPortInfo(stagePort,s)
        })

        val sortedByStage = groupedByStage.sortWith((a, b) => pipeline.indexOf(a.stage) < pipeline.indexOf(b.stage))

        exceptionValids := exceptionValidsRegs
        for(portInfo <- sortedByStage; port = portInfo.port ; stage = portInfo.stage; stageId = indexOf(portInfo.stage)) {
          when(port.valid) {
            stages(indexOf(stage) - 1).arbitration.flushAll := True
            stage.arbitration.removeIt := True
            exceptionValids(stageId) := True
            exceptionContext := port.payload
          }
        }
        for(stageId <- firstStageIndexWithExceptionPort until stages.length; stage = stages(stageId) ){
        when(stage.arbitration.isFlushed){
            exceptionValids(stageId) := False
          }
          when(!stage.arbitration.isStuck){
            exceptionValidsRegs(stageId) := (if(stageId != firstStageIndexWithExceptionPort) exceptionValids(stageId-1) else False)
          }otherwise{
            exceptionValidsRegs(stageId) := exceptionValids(stageId)
          }
        }


      } else null



      val interrupt = ((mip.MSIP && mie.MSIE) || (mip.MEIP && mie.MEIE) || (mip.MTIP && mie.MTIE)) && mstatus.MIE
      val exception = if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionValids.last else False
      val writeBackWfi = if(wfiGen) writeBack.arbitration.isValid && writeBack.input(ENV_CTRL) === EnvCtrlEnum.WFI else False

      //Interrupt/Exception entry logic
      pipelineLiberator.enable setWhen(interrupt)
      when(exception || (interrupt && pipelineLiberator.done)){
        jumpInterface.valid := True
        jumpInterface.payload := mtvec
        mstatus.MIE := False
        mstatus.MPIE := mstatus.MIE
        mepc := exception mux(
          True  -> writeBack.input(PC),
          False -> (writeBackWfi ? (writeBack.input(PC) + 4) | prefetch.input(PC_CALC_WITHOUT_JUMP)) //TODO ? WFI could emulate J PC + 4
        )

        mcause.interrupt := interrupt
        mcause.exceptionCode := interrupt.mux(
          True  -> ((mip.MEIP && mie.MEIE) ? U(11) | ((mip.MSIP && mie.MSIE) ? U(3) | U(7))),
          False -> (if(exceptionPortCtrl != null) exceptionPortCtrl.exceptionContext.code else U(0))
        )
      }


      //Manage MRET instructions
      when(memory.arbitration.isFiring && memory.input(ENV_CTRL) === EnvCtrlEnum.MRET){
        jumpInterface.valid := True
        jumpInterface.payload := mepc
        execute.arbitration.flushAll := True
        mstatus.MIE := mstatus.MPIE
      }

      //Manage ECALL instructions
      if(ecallGen) when(execute.arbitration.isValid && execute.input(ENV_CTRL) === EnvCtrlEnum.ECALL){
        pluginExceptionPort.valid := True
        pluginExceptionPort.code := 11
      }

      //Manage WFI instructions
      if(wfiGen) when(execute.arbitration.isValid && execute.input(ENV_CTRL) === EnvCtrlEnum.WFI){
        when(!interrupt){
          execute.arbitration.haltIt := True
          decode.arbitration.flushAll := True
        }
      }

      //CSR read/write instructions management
      execute plug new Area {
        import execute._

        val imm = IMM(input(INSTRUCTION))

        val writeEnable = arbitration.isValid && !arbitration.isStuckByOthers && !arbitration.removeIt && input(IS_CSR) &&
                          (!((input(INSTRUCTION)(14 downto 13) === "01" && input(INSTRUCTION)(rs1Range) === 0)
                          || (input(INSTRUCTION)(14 downto 13) === "11" && imm.z === 0)))


        val writeSrc = input(INSTRUCTION)(14) ? imm.z.asBits.resized | input(SRC1)
        val readData = B(0, 32 bits)
        val writeData = input(INSTRUCTION)(13).mux(
          False -> writeSrc,
          True -> Mux(input(INSTRUCTION)(12), readData & ~writeSrc, readData | writeSrc)
        )

        when(arbitration.isValid && input(IS_CSR)) {
          output(REGFILE_WRITE_DATA) := readData
        }


        //Translation of the csrMapping into real logic
        val csrAddress = input(INSTRUCTION)(csrRange)

        for ((address, jobs) <- csrMapping.mapping) {
          when(csrAddress === address) {
            when(writeEnable) {
              for (element <- jobs) element match {
                case element: CsrWrite => element.that.assignFromBits(writeData(element.bitOffset, element.that.getBitsWidth bits))
                case _ =>
              }
            }

            for (element <- jobs) element match {
              case element: CsrRead if element.that.getBitsWidth != 0 => readData(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
              case _ =>
            }
          }
        }
      }
    }
  }
}
