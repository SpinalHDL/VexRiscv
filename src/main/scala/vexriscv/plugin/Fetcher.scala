package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import vexriscv.Riscv.IMM
import StreamVexPimper._
import scala.collection.mutable.ArrayBuffer


//TODO val killLastStage = jump.pcLoad.valid || decode.arbitration.isRemoved
// DBUSSimple check memory halt execute optimization

abstract class IBusFetcherImpl(val resetVector : BigInt,
                               val keepPcPlus4 : Boolean,
                               val decodePcGen : Boolean,
                               val compressedGen : Boolean,
                               val cmdToRspStageCount : Int,
                               val pcRegReusedForSecondStage : Boolean,
                               val injectorReadyCutGen : Boolean,
                               val prediction : BranchPrediction,
                               val historyRamSizeLog2 : Int,
                               val injectorStage : Boolean) extends Plugin[VexRiscv] with JumpService with IBusFetcher{
  var prefetchExceptionPort : Flow[ExceptionCause] = null
  var decodePrediction : DecodePredictionBus = null
  var fetchPrediction : FetchPredictionBus = null
  var dynamicTargetFailureCorrection : Flow[UInt] = null
  var externalResetVector : UInt = null
  assert(cmdToRspStageCount >= 1)
//  assert(!(cmdToRspStageCount == 1 && !injectorStage))
  assert(!(compressedGen && !decodePcGen))
  var fetcherHalt : Bool = null
  var fetcherflushIt : Bool = null
  var pcValids : Vec[Bool] = null
  def pcValid(stage : Stage) = pcValids(pipeline.indexOf(stage))
  var incomingInstruction : Bool = null
  override def incoming() = incomingInstruction

  var injectionPort : Stream[Bits] = null
  override def getInjectionPort() = {
    injectionPort = Stream(Bits(32 bits))
    injectionPort
  }

  var predictionJumpInterface : Flow[UInt] = null

  override def haltIt(): Unit = fetcherHalt := True
  override def flushIt(): Unit = fetcherflushIt := True

  case class JumpInfo(interface :  Flow[UInt], stage: Stage, priority : Int)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def createJumpInterface(stage: Stage, priority : Int = 0): Flow[UInt] = {
    assert(stage != null)
    val interface = Flow(UInt(32 bits))
    jumpInfos += JumpInfo(interface,stage, priority)
    interface
  }


//  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    fetcherHalt = False
    fetcherflushIt = False
    incomingInstruction = False
    if(resetVector == null) externalResetVector = in(UInt(32 bits).setName("externalResetVector"))

    pipeline(RVC_GEN) = compressedGen

    prediction match {
      case NONE =>
      case STATIC | DYNAMIC => {
        predictionJumpInterface = createJumpInterface(pipeline.decode)
        decodePrediction = pipeline.service(classOf[PredictionInterface]).askDecodePrediction()
      }
      case DYNAMIC_TARGET => {
        fetchPrediction = pipeline.service(classOf[PredictionInterface]).askFetchPrediction()
        if(compressedGen && cmdToRspStageCount > 1){
          dynamicTargetFailureCorrection = createJumpInterface(pipeline.decode)
        }
      }
    }

    pcValids = Vec(Bool, pipeline.stages.size)
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

    def flush = jump.pcLoad.valid || fetcherflushIt

    class PcFetch extends Area{
      val preOutput = Stream(UInt(32 bits))
      val output = preOutput.haltWhen(fetcherHalt)
      val predictionPcLoad = ifGen(prediction == DYNAMIC_TARGET) (Flow(UInt(32 bits)))
    }

    val fetchPc = new PcFetch{
      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init(if(resetVector != null) resetVector else externalResetVector) addAttribute(Verilator.public)
      val inc = RegInit(False)
      val propagatePc = False

      val pc = pcReg + (inc ## B"00").asUInt
      val samplePcNext = False

      if(compressedGen) {
        when(inc) {
          pc(1) := False
        }
      }

      when(propagatePc){
        samplePcNext := True
        inc := False
      }

      if(predictionPcLoad != null) {
        when(predictionPcLoad.valid) {
          inc := False
          samplePcNext := True
          pc := predictionPcLoad.payload
        }
      }
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

      pc(0) := False
      if(!pipeline(RVC_GEN)) pc(1) := False

      preOutput.valid := RegNext(True) init (False)
      preOutput.payload := pc

    }

    val decodePc = ifGen(decodePcGen)(new Area {
      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init(if(resetVector != null) resetVector else externalResetVector) addAttribute(Verilator.public)
      val pcPlus = if(compressedGen)
        pcReg + ((decode.input(IS_RVC)) ? U(2) | U(4))
      else
        pcReg + 4

      if (keepPcPlus4) KeepAttribute(pcPlus)
      val injectedDecode = False
      when(decode.arbitration.isFiring && !injectedDecode) {
        pcReg := pcPlus
      }

      val predictionPcLoad = ifGen(prediction == DYNAMIC_TARGET) (Flow(UInt(32 bits)))
      if(prediction == DYNAMIC_TARGET) {
        when(predictionPcLoad.valid) {
          pcReg := predictionPcLoad.payload
        }
      }

      //application of the selected jump request
      when(jump.pcLoad.valid) {
        pcReg := jump.pcLoad.payload
      }
    })


    case class FetchRsp() extends Bundle {
      val pc = UInt(32 bits)
      val rsp = IBusSimpleRsp()
      val isRvc = Bool
    }


    val iBusRsp = new Area {
//      val input = Stream(UInt(32 bits))
//      val inputPipeline = Vec(Stream(UInt(32 bits)), cmdToRspStageCount)
//      val inputPipelineHalt = Vec(False, cmdToRspStageCount-1)
//      for(i <- 0 until cmdToRspStageCount) {
//        inputPipeline(i) << {i match {
//          case 0 => input.m2sPipeWithFlush(flush, false, collapsBubble = false)
//          case _ => inputPipeline(i-1).haltWhen(inputPipelineHalt(i-1)).m2sPipeWithFlush(flush,collapsBubble = false)
//        }}
//      }

//      val stages = Array.fill(cmdToRspStageCount)(Stream(UInt(32 bits)))
      val stages = Array.fill(cmdToRspStageCount + 1)(new Bundle {
        val input = Stream(UInt(32 bits))
        val output = Stream(UInt(32 bits))
        val halt = Bool
        val inputSample = Bool
      })

      stages(0).input << fetchPc.output
      stages(0).inputSample := True
      for(s <- stages) {
        s.halt := False
        s.output << s.input.haltWhen(s.halt)
      }

      for((s,sNext) <- (stages, stages.tail).zipped) {
        if(s == stages.head && pcRegReusedForSecondStage) {
          sNext.input.arbitrationFrom(s.output.toEvent().m2sPipeWithFlush(flush, s != stages.head, collapsBubble = false))
          sNext.input.payload := fetchPc.pcReg
          fetchPc.propagatePc setWhen(sNext.input.fire)
        } else {
          sNext.input << s.output.m2sPipeWithFlush(flush, s != stages.head, collapsBubble = false)
        }
      }

//
//      val pipeline = Vec(Stream(UInt(32 bits)), cmdToRspStageCount + 1)
//      val halts = Vec(False, cmdToRspStageCount)
//      for(i <- 0 until cmdToRspStageCount + 1) {
//        pipeline(i) << {i match {
//          case 0 => pipeline(0) << fetchPc.output.haltWhen(halts(i))
//          case 1 => pipeline(1).m2sPipeWithFlush(flush, false, collapsBubble = false)
//          case _ => inputPipeline(i-1).haltWhen(inputPipelineHalt(i-1)).m2sPipeWithFlush(flush,collapsBubble = false)
//        }}
//      }

      // ...

      val readyForError = True
      val output = Stream(FetchRsp())
      incomingInstruction setWhen(stages.tail.map(_.input.valid).reduce(_ || _))
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
//      input.ready := (bufferValid ? (!isRvc && output.ready) | (input.pc(1) || output.ready))
      input.ready := !output.valid || !(!output.ready || (isRvc && !input.pc(1) && input.rsp.inst(16, 2 bits) =/= 3) || (!isRvc && bufferValid && input.rsp.inst(16, 2 bits) =/= 3))
      addPrePopTask(() => {
        when(!input.ready && output.fire && !flush /* && ((isRvc && !bufferValid && !input.pc(1)) || (!isRvc && bufferValid && input.rsp.inst(16, 2 bits) =/= 3))*/) {
          input.pc.getDrivingReg(1) := True
        }
      })

      bufferValid clearWhen(output.fire)
      when(input.fire){
//        bufferValid := !(!isRvc && !input.pc(1) && !bufferValid) && !(isRvc && input.pc(1) && output.ready)
        bufferValid := !(!isRvc && !input.pc(1) && !bufferValid) && !(isRvc && input.pc(1) && output.ready)
        bufferData := input.rsp.inst(31 downto 16)
      }
      bufferValid.clearWhen(flush)
      iBusRsp.readyForError.clearWhen(bufferValid && isRvc)
      incomingInstruction setWhen(bufferValid && bufferData(1 downto 0) =/= 3)
    })


    def condApply[T](that : T, cond : Boolean)(func : (T) => T) = if(cond)func(that) else that
    val injector = new Area {
      val inputBeforeStage = condApply(if (decodePcGen) decompressor.output else iBusRsp.output, injectorReadyCutGen)(_.s2mPipe(flush))
      if (injectorReadyCutGen) {
        iBusRsp.readyForError.clearWhen(inputBeforeStage.valid)
        incomingInstruction setWhen (inputBeforeStage.valid)
      }
      val decodeInput = (if (injectorStage) {
        val decodeInput = inputBeforeStage.m2sPipeWithFlush(flush, collapsBubble = false)
        decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), inputBeforeStage.rsp.inst)
        iBusRsp.readyForError.clearWhen(decodeInput.valid)
        incomingInstruction setWhen (decodeInput.valid)
        decodeInput
      } else {
        inputBeforeStage
      })


      def pcUpdatedGen(input : Bool, stucks : Seq[Bool], relaxedInput : Boolean) : Seq[Bool] = {
        stucks.scanLeft(input)((i, stuck) => {
          val reg = RegInit(False)
          if(!relaxedInput) when(flush) {
            reg := False
          }
          when(!stuck) {
            reg := i
          }
          if(relaxedInput || i != input) when(flush) {
            reg := False
          }
          reg
        }).tail
      }

      val stagesFromExecute = stages.dropWhile(_ != execute).toList
      val nextPcCalc = if (decodePcGen) new Area{
        val valids = pcUpdatedGen(True, False :: stagesFromExecute.map(_.arbitration.isStuck), true)
        pcValids := Vec(valids.takeRight(stages.size))
      } else new Area{
        val valids = pcUpdatedGen(True, iBusRsp.stages.tail.map(!_.input.ready) ++ (if (injectorStage) List(!decodeInput.ready) else Nil) ++ stagesFromExecute.map(_.arbitration.isStuck), false)
        pcValids := Vec(valids.takeRight(stages.size))
      }

      val decodeRemoved = RegInit(False) setWhen(decode.arbitration.isRemoved) clearWhen(flush) //!decode.arbitration.isStuck || decode.arbitration.isFlushed

      decodeInput.ready := !decode.arbitration.isStuck
      decode.arbitration.isValid := decodeInput.valid && !decodeRemoved
      decode.insert(PC) := (if (decodePcGen) decodePc.pcReg else decodeInput.pc)
      decode.insert(INSTRUCTION) := decodeInput.rsp.inst
      decode.insert(INSTRUCTION_READY) := True
      if (compressedGen) decode.insert(IS_RVC) := decodeInput.isRvc

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


      //Formal verification signals generation, miss prediction stuff ?
      val formal = new Area {
        val raw = if(compressedGen) decompressor.raw else inputBeforeStage.rsp.inst
        val rawInDecode = Delay(raw, if(injectorStage) 1 else 0, when = decodeInput.ready)
        decode.insert(FORMAL_INSTRUCTION) := rawInDecode

        decode.insert(FORMAL_PC_NEXT) := (if (compressedGen)
          decode.input(PC) + ((decode.input(IS_RVC)) ? U(2) | U(4))
        else
          decode.input(PC) + 4)

        if(decodePc != null && decodePc.predictionPcLoad != null){
          when(decodePc.predictionPcLoad.valid){
            decode.insert(FORMAL_PC_NEXT) := decodePc.predictionPcLoad.payload
          }
        }

        jumpInfos.foreach(info => {
          when(info.interface.valid) {
            info.stage.output(FORMAL_PC_NEXT) := info.interface.payload
          }
        })
      }
    }

    def stage1ToInjectorPipe[T <: Data](input : T): (T,T) ={
      val iBusRspContext = iBusRsp.stages.drop(1).dropRight(1).foldLeft(input)((data,stage) => RegNextWhen(data, stage.output.ready))
//      val decompressorContext = ifGen(compressedGen)(new Area{
//        val lastContext = RegNextWhen(iBusRspContext, decompressor.input.fire)
//        val output = decompressor.bufferValid ? lastContext | iBusRspContext
//      })
      val decompressorContext = cloneOf(input)
      decompressorContext := iBusRspContext
      val injectorContext = Delay(if(compressedGen) decompressorContext else iBusRspContext, cycleCount=if(injectorStage) 1 else 0, when=injector.decodeInput.ready)
      val injectorContextWire = cloneOf(input) //Allow combinatorial override
      injectorContextWire := injectorContext
      (ifGen(compressedGen)(decompressorContext), injectorContextWire)
    }

    val predictor = prediction match {
      case NONE =>
      case STATIC | DYNAMIC => {
        def historyWidth = 2
        val dynamic = ifGen(prediction == DYNAMIC) (new Area {
          case class BranchPredictorLine()  extends Bundle{
            val history = SInt(historyWidth bits)
          }

          val historyCache = Mem(BranchPredictorLine(), 1 << historyRamSizeLog2)
          val historyWrite = historyCache.writePort
          val historyWriteLast = RegNextWhen(historyWrite, iBusRsp.stages(0).output.ready)
          val hazard = historyWriteLast.valid && historyWriteLast.address === (iBusRsp.stages(0).input.payload >> 2).resized

          case class DynamicContext() extends Bundle{
            val hazard = Bool
            val line = BranchPredictorLine()
          }
          val fetchContext = DynamicContext()
          fetchContext.hazard := hazard
          fetchContext.line := historyCache.readSync((fetchPc.output.payload >> 2).resized, iBusRsp.stages(0).output.ready || flush)

          object PREDICTION_CONTEXT extends Stageable(DynamicContext())
          decode.insert(PREDICTION_CONTEXT) := stage1ToInjectorPipe(fetchContext)._2
          val decodeContextPrediction = decode.input(PREDICTION_CONTEXT).line.history.msb

          val branchStage = decodePrediction.stage
          val branchContext = branchStage.input(PREDICTION_CONTEXT)
          val moreJump = decodePrediction.rsp.wasWrong ^ branchContext.line.history.msb

          historyWrite.address := branchStage.input(PC)(2, historyRamSizeLog2 bits) + (if(pipeline(RVC_GEN))
            ((!branchStage.input(IS_RVC) && branchStage.input(PC)(1)) ? U(1) | U(0))
          else
            U(0))

          historyWrite.data.history := branchContext.line.history + (moreJump ? S(-1) | S(1))
          val sat = (branchContext.line.history === (moreJump ? S(branchContext.line.history.minValue) | S(branchContext.line.history.maxValue)))
          historyWrite.valid := !branchContext.hazard && branchStage.arbitration.isFiring && branchStage.input(BRANCH_CTRL) === BranchCtrlEnum.B && !sat
        })


        val imm = IMM(decode.input(INSTRUCTION))

        val conditionalBranchPrediction = prediction match {
          case STATIC =>  imm.b_sext.msb
          case DYNAMIC => dynamic.decodeContextPrediction
        }

        decodePrediction.cmd.hadBranch := decode.input(BRANCH_CTRL) === BranchCtrlEnum.JAL || (decode.input(BRANCH_CTRL) === BranchCtrlEnum.B && conditionalBranchPrediction)

        predictionJumpInterface.valid := decodePrediction.cmd.hadBranch && decode.arbitration.isFiring //TODO OH Doublon de priorité
        predictionJumpInterface.payload := decode.input(PC) + ((decode.input(BRANCH_CTRL) === BranchCtrlEnum.JAL) ? imm.j_sext | imm.b_sext).asUInt

//        when(predictionJumpInterface.payload((if(pipeline(RVC_GEN)) 0 else 1) downto 0) =/= 0){
//          decodePrediction.cmd.hadBranch := False
//        }
      }
      case DYNAMIC_TARGET => new Area{
//        assert(!compressedGen || cmdToRspStageCount == 1, "Can't combine DYNAMIC_TARGET and RVC as it could stop the instruction fetch mid-air")

        case class BranchPredictorLine()  extends Bundle{
          val source = Bits(30 - historyRamSizeLog2 bits)
          val branchWish = UInt(2 bits)
          val target = UInt(32 bits)
          val unaligned = ifGen(compressedGen)(Bool)
        }

        val history = Mem(BranchPredictorLine(), 1 << historyRamSizeLog2)
        val historyWrite = history.writePort

        val line = history.readSync((iBusRsp.stages(0).input.payload >> 2).resized, iBusRsp.stages(0).output.ready || flush)
        val hit = line.source === (iBusRsp.stages(1).input.payload.asBits >> 2 + historyRamSizeLog2) && (if(compressedGen)(!(!line.unaligned && iBusRsp.stages(1).input.payload(1))) else True)

        //Avoid stoping instruction fetch in the middle patch
        if(compressedGen && cmdToRspStageCount == 1){
          hit clearWhen(!decompressor.output.valid)
        }

        //Avoid write to read hazard
        val historyWriteLast = RegNextWhen(historyWrite, iBusRsp.stages(0).output.ready)
        val hazard = historyWriteLast.valid && historyWriteLast.address === (iBusRsp.stages(1).input.payload >> 2).resized
        //TODO improve predictionPcLoad way of doing things
        fetchPc.predictionPcLoad.valid := line.branchWish.msb && hit && !hazard && iBusRsp.stages(1).output.fire //XXX && !(!line.unaligned && iBusRsp.inputPipeline(0).payload(1))
        fetchPc.predictionPcLoad.payload := line.target

        case class PredictionResult()  extends Bundle{
          val hazard = Bool
          val hit = Bool
          val line = BranchPredictorLine()
        }

        val fetchContext = PredictionResult()
        fetchContext.hazard := hazard
        fetchContext.hit := hit
        fetchContext.line := line

        val (decompressorContext, injectorContext) = stage1ToInjectorPipe(fetchContext)
        if(compressedGen) {
          //prediction hit on the right instruction into words
          decompressorContext.hit clearWhen(decompressorContext.line.unaligned && (decompressor.bufferValid || (decompressor.isRvc && !decompressor.input.pc(1))))

         // if(compressedGen) injectorContext.hit clearWhen(decodePc.pcReg(1) =/= injectorContext.line.unaligned)

          decodePc.predictionPcLoad.valid := injectorContext.line.branchWish.msb && injectorContext.hit && !injectorContext.hazard && injector.decodeInput.fire
          decodePc.predictionPcLoad.payload := injectorContext.line.target


          when(decompressorContext.line.branchWish.msb && decompressorContext.hit && !decompressorContext.hazard && decompressor.output.fire){
            decompressor.bufferValid := False
            decompressor.input.ready := True
          }
        }

        object PREDICTION_CONTEXT extends Stageable(PredictionResult())
        pipeline.decode.insert(PREDICTION_CONTEXT) := injectorContext
        val branchStage = fetchPrediction.stage
        val branchContext = branchStage.input(PREDICTION_CONTEXT)

        fetchPrediction.cmd.hadBranch := branchContext.hit && !branchContext.hazard && branchContext.line.branchWish.msb
        fetchPrediction.cmd.targetPc := branchContext.line.target


        historyWrite.valid := False
        historyWrite.address := fetchPrediction.rsp.sourceLastWord(2, historyRamSizeLog2 bits)
        historyWrite.data.source := fetchPrediction.rsp.sourceLastWord.asBits >> 2 + historyRamSizeLog2
        historyWrite.data.target := fetchPrediction.rsp.finalPc
        if(compressedGen) historyWrite.data.unaligned := !fetchPrediction.stage.input(PC)(1) ^ fetchPrediction.stage.input(IS_RVC)

        when(fetchPrediction.rsp.wasRight) {
          historyWrite.valid := branchContext.hit
          historyWrite.data.branchWish := branchContext.line.branchWish + (branchContext.line.branchWish === 2).asUInt - (branchContext.line.branchWish === 1).asUInt
        } otherwise {
          when(branchContext.hit) {
            historyWrite.valid := True
            historyWrite.data.branchWish := branchContext.line.branchWish - (branchContext.line.branchWish.msb).asUInt + (!branchContext.line.branchWish.msb).asUInt
          } otherwise {
            historyWrite.valid := True
            historyWrite.data.branchWish := "10"
          }
        }

        historyWrite.valid clearWhen(branchContext.hazard || !branchStage.arbitration.isFiring)



        val predictionFailure = ifGen(compressedGen && cmdToRspStageCount > 1)(new Area{
          val decompressorFailure = RegInit(False)
          when(decompressor.input.fire){
            decompressorFailure := decompressorContext.hit && !decompressorContext.hazard && !decompressor.output.valid && decompressorContext.line.branchWish(1)
          }
          decompressorFailure clearWhen(flush || decompressor.output.fire)

          val injectorFailure = Delay(decompressorFailure, cycleCount=if(injectorStage) 1 else 0, when=injector.decodeInput.ready)

          dynamicTargetFailureCorrection.valid := False
          dynamicTargetFailureCorrection.payload := decode.input(PC)
          when(injector.decodeInput.valid && injectorFailure){
            historyWrite.valid := True
            historyWrite.address := (decode.input(PC) >> 2).resized
            historyWrite.data.branchWish := 0

            decode.arbitration.isValid := False
            dynamicTargetFailureCorrection.valid := True
          }
        })
      }
    }
  }
}