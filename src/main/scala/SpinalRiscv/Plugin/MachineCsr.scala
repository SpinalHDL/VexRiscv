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

case class ExceptionPortInfo(port : Flow[UInt],stage : Stage)
case class MachineCsrConfig(
  mvendorid           : BigInt,
  marchid             : BigInt,
  mimpid              : BigInt,
  mhartid             : BigInt,
  misaExtensions      : Int,
  misaAccess          : CsrAccess,
  mtvecAccess         : CsrAccess,
  mtvecInit           : BigInt,
  mepcAccess          : CsrAccess,
  mscratchGen         : Boolean,
  mcauseAccess        : CsrAccess,
  mbadaddrAccess      : CsrAccess

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
  def rx [T <: Data](csrAddress : Int, thats : (Int, Data)*)(writable : Boolean) : Unit =
    if(writable)
      for(that <- thats) rw(csrAddress,that._1, that._2)
    else
      for(that <- thats) r(csrAddress,that._1, that._2)
}



class MachineCsr(config : MachineCsrConfig) extends Plugin[VexRiscv] with ExceptionService {
  import config._
  import CsrAccess._

  //Mannage ExceptionService calls
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  def exceptionCodeWidth = 4
  override def newExceptionPort(stage : Stage) = {
    val interface = Flow(UInt(exceptionCodeWidth bits))
    exceptionPortsInfos += ExceptionPortInfo(interface,stage)
    interface
  }

  var jumpInterface : Flow[UInt] = null
  var pluginExceptionPort : Flow[UInt] = null

  object EnvCtrlEnum extends SpinalEnum(binarySequential){
    val NONE, EBREAK, ECALL, MRET = newElement()
  }

  object ENV_CTRL extends Stageable(EnvCtrlEnum())
  object EXCEPTION extends Stageable(Bool)
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
      ECALL  -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.ECALL)),
      EBREAK -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.EBREAK)),
      MRET   -> (defaultEnv ++ List(ENV_CTRL -> EnvCtrlEnum.MRET))
    ))


    val  pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(pipeline.execute)
    jumpInterface.valid := False
    jumpInterface.payload.assignDontCare()

    pluginExceptionPort = newExceptionPort(pipeline.execute)
    pluginExceptionPort.valid := False
    pluginExceptionPort.payload.assignDontCare()
  }
  def xlen = 32
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Manage ECALL instructions
    when(execute.arbitration.isValid && execute.input(ENV_CTRL) === EnvCtrlEnum.ECALL){
      pluginExceptionPort.valid := True
      pluginExceptionPort.payload := 3
    }

    pipeline plug new Area{
      //Define CSR registers
      val csrMapping = new CsrMapping()
      implicit class CsrAccessPimper(csrAccess : CsrAccess){
        def apply(csrAddress : Int, thats : (Int, Data)*) : Unit = csrAccess match{
          case `WRITE_ONLY` | `READ_WRITE` => for(that <- thats) csrMapping.w(csrAddress,that._1, that._2)
          case `READ_ONLY`  | `READ_WRITE` => for(that <- thats) csrMapping.r(csrAddress,that._1, that._2)
        }
        def apply(csrAddress : Int, that : Data) : Unit = csrAccess match{
          case `WRITE_ONLY` | `READ_WRITE` => csrMapping.w(csrAddress, 0, that)
          case `READ_ONLY`  | `READ_WRITE` => csrMapping.r(csrAddress, 0, that)
        }
      }

      //Define CSR registers
      val mtvec = RegInit(U(mtvecInit,xlen bits))
      val mepc = Reg(UInt(xlen bits))
      val mstatus = new Area{
        val MIE, MPIE = RegInit(False)
      }
      val mip = new Area{
        val MEIP, MTIP, MSIP = False //TODO
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

      //Define CSR registers accessibility
      if(mvendorid != null) READ_ONLY(CSR.MVENDORID, U(mvendorid))
      if(marchid   != null) READ_ONLY(CSR.MARCHID  , U(marchid  ))
      if(mimpid    != null) READ_ONLY(CSR.MIMPID   , U(mimpid   ))
      if(mhartid   != null) READ_ONLY(CSR.MHARTID  , U(mhartid  ))

      misaAccess(CSR.MISA, xlen-2 -> U"01" , 0 -> U(misaExtensions))
      READ_ONLY(CSR.MIP, 11 -> mip.MEIP, 7 -> mip.MTIP, 3 -> mip.MSIP)
      READ_WRITE(CSR.MIE, 11 -> mie.MEIE, 7 -> mie.MTIE, 3 -> mie.MSIE)

      mtvecAccess(CSR.MTVEC  , mtvec)
      mepcAccess(CSR.MEPC   , mepc)
      READ_ONLY(CSR.MSTATUS, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
      if(mscratchGen) READ_WRITE(CSR.MSCRATCH, mscratch)
      mcauseAccess(CSR.MCAUSE, xlen-1 -> mcause.interrupt, 0 -> mcause.exceptionCode)
      mbadaddrAccess(CSR.MBADADDR, mbadaddr)



      //Used to make the pipeline empty softly (for interrupts)
      val pipelineLiberator = new Area{
        val enable = False
        decode.arbitration.haltIt setWhen(enable)
        val done = ! List(fetch, decode, execute, memory, writeBack).map(_.arbitration.isValid).orR
      }

      //Aggregate all exception port and remove required instructions
      val exceptionPortCtrl = if(exceptionPortsInfos.nonEmpty) new Area{
        val firstStageIndexWithExceptionPort = exceptionPortsInfos.map(i => indexOf(i.stage)).min
        val pipelineHasException = stages.drop(firstStageIndexWithExceptionPort).map(s => s.arbitration.isValid && s.input(EXCEPTION)).orR
        decode.arbitration.haltIt setWhen(pipelineHasException)

        val groupedByStage = exceptionPortsInfos.map(_.stage).distinct.map(s => {
          val stagePortsInfos = exceptionPortsInfos.filter(_.stage == s)
          val stagePort = stagePortsInfos.length match{
            case 1 => stagePortsInfos.head.port
            case _ => {
              val groupedPort = Flow(UInt(exceptionCodeWidth bits))
              val valids = stagePortsInfos.map(_.port.valid)
              val codes = stagePortsInfos.map(_.port.payload)
              groupedPort.valid := valids.orR
              groupedPort.payload := MuxOH(stagePortsInfos.map(_.port.valid), codes)
              groupedPort
            }
          }
          ExceptionPortInfo(stagePort,s)
        })
        val sortedByStage = groupedByStage.sortWith((a, b) => pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage))

        sortedByStage.head.stage.insert(EXCEPTION) := False
        for(portInfo <- sortedByStage; port = portInfo.port ; stage = portInfo.stage){
          when(port.valid){
            stages(indexOf(stage) - 1).arbitration.flushIt := True
            stage.input(EXCEPTION) := True
          }
        }
      } else null

      val interrupt = False
      val exception = if(exceptionPortsInfos.nonEmpty)
        writeBack.arbitration.isValid && writeBack.input(EXCEPTION)
      else
        False

      when(mstatus.MIE){
        pipelineLiberator.enable := interrupt
        when(exception || (interrupt && pipelineLiberator.done)){
          jumpInterface.valid := True
          jumpInterface.payload := mtvec
          mstatus.MIE := False
          mstatus.MPIE := mstatus.MIE
          mepc := exception ? writeBack.input(PC) | prefetch.input(PC_CALC_WITHOUT_JUMP)
        }
      }

      when(memory.arbitration.isFiring && memory.input(ENV_CTRL) === EnvCtrlEnum.MRET){
        jumpInterface.valid := True
        jumpInterface.payload := mepc
        mstatus.MIE := mstatus.MPIE
      }



      execute plug new Area {

        import execute._

        val imm = IMM(input(INSTRUCTION))

        val writeEnable = !((input(INSTRUCTION)(14 downto 13) === "01" && input(INSTRUCTION)(rs1Range) === 0)
          || (input(INSTRUCTION)(14 downto 13) === "10" && imm.z === 0))
        val readEnable = input(INSTRUCTION)(rdRange) =/= 0

        val writeSrc = input(INSTRUCTION)(14) ? imm.z.asBits.resized | input(SRC1)
        val readData = B(0, 32 bits)
        val writeData = input(INSTRUCTION)(12).mux(
          False -> writeSrc,
          True -> Mux(input(INSTRUCTION)(13), readData & ~writeSrc, readData | writeSrc)
        )

        when(arbitration.isValid && input(IS_CSR)) {
          when(writeEnable) {
            output(REGFILE_WRITE_DATA) := writeData
          }
        }


        val csrAddress = input(INSTRUCTION)(csrRange)
        when(arbitration.isValid && input(IS_CSR)) {
          for ((address, jobs) <- csrMapping.mapping) {
            when(csrAddress === address) {
              when(writeEnable) {
                for (element <- jobs) element match {
                  case element: CsrWrite => element.that.assignFromBits(writeData(element.bitOffset, element.that.getBitsWidth bits))
                  //                case element: BusSlaveFactoryOnWriteAtAddress => element.doThat()
                  case _ =>
                }
              }

              for (element <- jobs) element match {
                case element: CsrRead => readData(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
                //              case element: BusSlaveFactoryOnReadAtAddress => when(readEnable) { element.doThat() }
                case _ =>
              }
            }
          }
        }
      }
    }
  }
}
