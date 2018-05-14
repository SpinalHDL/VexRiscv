package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import vexriscv.Riscv.IMM
import StreamVexPimper._
import scala.collection.mutable.ArrayBuffer


abstract class IBusFetcherImpl(val catchAccessFault : Boolean,
                               val resetVector : BigInt,
                               val keepPcPlus4 : Boolean,
                               val decodePcGen : Boolean,
                               val compressedGen : Boolean,
                               val cmdToRspStageCount : Int,
                               val injectorReadyCutGen : Boolean,
                               val relaxedPcCalculation : Boolean,
                               val prediction : BranchPrediction,
                               val catchAddressMisaligned : Boolean,
                               val injectorStage : Boolean) extends Plugin[VexRiscv] with JumpService with IBusFetcher{
  var prefetchExceptionPort : Flow[ExceptionCause] = null

  var decodePrediction : DecodePredictionBus = null
  assert(cmdToRspStageCount >= 1)
  assert(!(cmdToRspStageCount == 1 && !injectorStage))
  assert(!(compressedGen && !decodePcGen))
  var fetcherHalt : Bool = null
  lazy val decodeNextPcValid = Bool //TODO remove me ?
  lazy val decodeNextPc = UInt(32 bits)
  def nextPc() = (False, decodeNextPc)
  var incomingInstruction : Bool = null
  override def incoming() = incomingInstruction

  var injectionPort : Stream[Bits] = null
  override def getInjectionPort() = {
    injectionPort = Stream(Bits(32 bits))
    injectionPort
  }

  var predictionJumpInterface : Flow[UInt] = null

  override def haltIt(): Unit = fetcherHalt := True

  case class JumpInfo(interface :  Flow[UInt], stage: Stage, priority : Int)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def createJumpInterface(stage: Stage, priority : Int = 0): Flow[UInt] = {
    val interface = Flow(UInt(32 bits))
    jumpInfos += JumpInfo(interface,stage, priority)
    interface
  }


//  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    fetcherHalt = False
    incomingInstruction = False
    if(catchAccessFault || catchAddressMisaligned) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
//      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1).setName("iBusErrorExceptionnPort")
    }

    pipeline(RVC_GEN) = compressedGen

    prediction match {
      case NONE =>
      case STATIC | DYNAMIC => {
        predictionJumpInterface = createJumpInterface(pipeline.decode)
        decodePrediction = pipeline.service(classOf[PredictionInterface]).askDecodePrediction()
      }
    }
  }


  class FetchArea(pipeline : VexRiscv) extends Area {
    import pipeline._
    import pipeline.config._

    //JumpService hardware implementation
    val jump = new Area {
      val sortedByStage = jumpInfos.sortWith((a, b) => {
        (pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage)) ||
          (pipeline.indexOf(a.stage) == pipeline.indexOf(b.stage) && a.priority > b.priority)
      })
      val valids = sortedByStage.map(_.interface.valid)
      val pcs = sortedByStage.map(_.interface.payload)

      val pcLoad = Flow(UInt(32 bits))
      pcLoad.valid := jumpInfos.map(_.interface.valid).orR
      pcLoad.payload := MuxOH(OHMasking.first(valids.asBits), pcs)
    }



    val killLastStage = jump.pcLoad.valid || decode.arbitration.isRemoved
    def flush = killLastStage

    class PcFetch extends Area{
      val preOutput = Stream(UInt(32 bits))
      val output = preOutput.haltWhen(fetcherHalt)
    }

    val fetchPc = if(relaxedPcCalculation) new PcFetch {
      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init (resetVector) addAttribute (Verilator.public)
      val pcPlus4 = pcReg + 4
      if (keepPcPlus4) KeepAttribute(pcPlus4)
      when(preOutput.fire) {
        pcReg := pcPlus4
      }

      //Realign
      if(compressedGen){
        when(preOutput.fire){
          pcReg(1 downto 0) := 0
        }
      }

      //application of the selected jump request
      when(jump.pcLoad.valid) {
        pcReg := jump.pcLoad.payload
      }

      preOutput.valid := RegNext(True) init (False) // && !jump.pcLoad.valid
      preOutput.payload := pcReg
    } else new PcFetch{
      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init(resetVector) addAttribute(Verilator.public)
      val inc = RegInit(False)

      val pc = pcReg + (inc ## B"00").asUInt
      val samplePcNext = False

      when(jump.pcLoad.valid) {
        inc := False
        samplePcNext := True
        pc := jump.pcLoad.payload
      }


      when(preOutput.fire){
        inc := True
        samplePcNext := True
      }


      when(samplePcNext) {
        pcReg := pc
      }

      if(compressedGen) {
        when(preOutput.fire) {
          pcReg(1 downto 0) := 0
          when(pc(1)){
            inc := True
          }
        }
      }

      preOutput.valid := RegNext(True) init (False)
      preOutput.payload := pc
    }

    val decodePc = ifGen(decodePcGen)(new Area {
      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init (resetVector) addAttribute (Verilator.public)
      val pcPlus = if(compressedGen)
        pcReg + ((decode.input(IS_RVC)) ? U(2) | U(4))
      else
        pcReg + 4

      if (keepPcPlus4) KeepAttribute(pcPlus)
      val injectedDecode = False
      when(decode.arbitration.isFiring && !injectedDecode) {
        pcReg := pcPlus
      }

      //application of the selected jump request
      when(jump.pcLoad.valid) {
        pcReg := jump.pcLoad.payload
      }
    })


//    val iBusCmd = new Area {
//      def input = fetchPc.output
//
//      // ...
//
//      val output = Stream(UInt(32 bits))
//    }

    case class FetchRsp() extends Bundle {
      val pc = UInt(32 bits)
      val rsp = IBusSimpleRsp()
      val isRvc = Bool
    }


    val iBusRsp = new Area {
      val input = Stream(UInt(32 bits))
      val inputPipeline = Vec(Stream(UInt(32 bits)), cmdToRspStageCount)
      for(i <- 0 until cmdToRspStageCount) {
        //          val doFlush = if(i == cmdToRspStageCount- 1 && ???) killLastStage else flush
        inputPipeline(i) << {i match {
          case 0 => input.m2sPipeWithFlush(flush, relaxedPcCalculation, collapsBubble = false)
          case _ => inputPipeline(i-1)/*.haltWhen(fetcherHalt)*/.m2sPipeWithFlush(flush,collapsBubble = false)
        }}
      }

      // ...

      val readyForError = True
      val output = Stream(FetchRsp())
      incomingInstruction setWhen(inputPipeline.map(_.valid).orR)
    }

    val decompressor = ifGen(decodePcGen)(new Area{
      def input = iBusRsp.output
      val output = Stream(FetchRsp())

      val bufferValid = RegInit(False)
      val bufferData = Reg(Bits(16 bits))

      val raw = Mux(
        sel = bufferValid,
        whenTrue = input.rsp.inst(15 downto 0) ## bufferData,
        whenFalse = input.rsp.inst(31 downto 16) ## (input.pc(1) ? input.rsp.inst(31 downto 16) | input.rsp.inst(15 downto 0))
      )
      val isRvc = raw(1 downto 0) =/= 3
      val decompressed = RvcDecompressor(raw(15 downto 0))
      output.valid := (isRvc ? (bufferValid || input.valid) | (input.valid && (bufferValid || !input.pc(1))))
      output.pc := input.pc
      output.isRvc := isRvc
      output.rsp.inst := isRvc ? decompressed | raw
      input.ready := (bufferValid ? (!isRvc && output.ready) | (input.pc(1) || output.ready))


      bufferValid clearWhen(output.fire)
      when(input.ready){
        when(input.valid) {
          bufferValid := !(!isRvc && !input.pc(1) && !bufferValid) && !(isRvc && input.pc(1) && output.ready)
          bufferData := input.rsp.inst(31 downto 16)
        }
      }
      bufferValid.clearWhen(flush)
      iBusRsp.readyForError.clearWhen(bufferValid && isRvc)
      incomingInstruction setWhen(bufferValid && bufferData(1 downto 0) =/= 3)
    })


    def condApply[T](that : T, cond : Boolean)(func : (T) => T) = if(cond)func(that) else that
    val injector = new Area {
      val inputBeforeHalt = condApply(if (decodePcGen) decompressor.output else iBusRsp.output, injectorReadyCutGen)(_.s2mPipe(flush))
      if (injectorReadyCutGen) {
        iBusRsp.readyForError.clearWhen(inputBeforeHalt.valid)
        incomingInstruction setWhen (inputBeforeHalt.valid)
      }
      val decodeInput = (if (injectorStage) {
        val decodeInput = inputBeforeHalt.m2sPipeWithFlush(killLastStage, collapsBubble = false)
        decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), inputBeforeHalt.rsp.inst)
        iBusRsp.readyForError.clearWhen(decodeInput.valid)
        incomingInstruction setWhen (decodeInput.valid)
        decodeInput
      } else {
        inputBeforeHalt
      })

      if (decodePcGen) {
        decodeNextPcValid := True
        decodeNextPc := decodePc.pcReg
      } else {
        val lastStageStream = if (injectorStage) inputBeforeHalt
        else if (cmdToRspStageCount > 1) iBusRsp.inputPipeline(cmdToRspStageCount - 2)
        else throw new Exception("Fetch should at least have two stages")

        //          when(fetcherHalt){
        //            lastStageStream.valid := False
        //            lastStageStream.ready := False
        //          }
        decodeNextPcValid := RegNext(lastStageStream.isStall)
        decodeNextPc := decode.input(PC)
      }

      decodeInput.ready := !decode.arbitration.isStuck
      decode.arbitration.isValid := decodeInput.valid
      decode.insert(PC) := (if (decodePcGen) decodePc.pcReg else decodeInput.pc)
      decode.insert(INSTRUCTION) := decodeInput.rsp.inst
      decode.insert(INSTRUCTION_READY) := True
      if (compressedGen) decode.insert(IS_RVC) := decodeInput.isRvc

      //      if(catchAccessFault){
      //        decodeExceptionPort.valid := decode.arbitration.isValid && decodeInput.rsp.error
      //        decodeExceptionPort.code  := 1
      //        decodeExceptionPort.badAddr := decode.input(PC)
      //      }

      if (injectionPort != null) {
        Component.current.addPrePopTask(() => {
          val state = RegInit(U"000")

          injectionPort.ready := False
          if(decodePcGen){
            decodePc.injectedDecode setWhen(state =/= 0)
          }
          switch(state) {
            is(0) { //request pipelining
              when(injectionPort.valid) {
                state := 1
              }
            }
            is(1) { //Give time to propagate the payload
              state := 2
            }
            is(2){ //read regfile delay
              decode.arbitration.isValid := True
              decode.arbitration.haltItself := True
              state := 3
            }
            is(3){ //Do instruction
              decode.arbitration.isValid := True
              when(!decode.arbitration.isStuck) {
                state := 4
              }
            }
            is(4){ //request pipelining
              injectionPort.ready := True
              state := 0
            }
          }

          //Check if the decode instruction is driven by a register
          val instructionDriver = try {
            decode.input(INSTRUCTION).getDrivingReg
          } catch {
            case _: Throwable => null
          }
          if (instructionDriver != null) { //If yes =>
            //Insert the instruction by writing the "fetch to decode instruction register",
            // Work even if it need to cross some hierarchy (caches)
            instructionDriver.component.rework {
              when(state.pull() =/= 0) {
                instructionDriver := injectionPort.payload.pull()
              }
            }
          } else {
            //Insert the instruction via a mux in the decode stage
            when(state =/= 0) {
              decode.input(INSTRUCTION) := RegNext(injectionPort.payload)
            }
          }
        })
      }
    }

    prediction match {
      case NONE =>
      case STATIC | DYNAMIC => {
        def historyWidth = 2
        def historyRamSizeLog2 = 10
        //          if(prediction == DYNAMIC) {
        //            case class BranchPredictorLine()  extends Bundle{
        //              val history = SInt(historyWidth bits)
        //            }
        //
        //            val historyCache = if(prediction == DYNAMIC) Mem(BranchPredictorLine(), 1 << historyRamSizeLog2) setName("branchCache") else null
        //            val historyCacheWrite = if(prediction == DYNAMIC) historyCache.writePort else null
        //
        //
        //            val readAddress = (2, historyRamSizeLog2 bits)
        //            fetch.insert(HISTORY_LINE) := historyCache.readSync(readAddress,!prefetch.arbitration.isStuckByOthers)
        //
        //          }


        val imm = IMM(decode.input(INSTRUCTION))

        val conditionalBranchPrediction = (prediction match {
          case STATIC =>  imm.b_sext.msb
          //            case DYNAMIC => decodeHistory.history.msb
        })
        decodePrediction.cmd.hadBranch := decode.input(BRANCH_CTRL) === BranchCtrlEnum.JAL || (decode.input(BRANCH_CTRL) === BranchCtrlEnum.B && conditionalBranchPrediction)

        predictionJumpInterface.valid := decodePrediction.cmd.hadBranch && decode.arbitration.isFiring //TODO OH Doublon de priorité
        predictionJumpInterface.payload := decode.input(PC) + ((decode.input(BRANCH_CTRL) === BranchCtrlEnum.JAL) ? imm.j_sext | imm.b_sext).asUInt


        if(catchAddressMisaligned) {
          ???
          //                          predictionExceptionPort.valid := input(INSTRUCTION_READY) && input(PREDICTION_HAD_BRANCHED) && arbitration.isValid && predictionJumpInterface.payload(1 downto 0) =/= 0
          //                          predictionExceptionPort.code := 0
          //                          predictionExceptionPort.badAddr := predictionJumpInterface.payload
        }
      }
    }
  }
}