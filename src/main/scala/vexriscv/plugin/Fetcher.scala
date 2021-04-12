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
                               val allowPcRegReusedForSecondStage : Boolean,
                               val injectorReadyCutGen : Boolean,
                               val prediction : BranchPrediction,
                               val historyRamSizeLog2 : Int,
                               val injectorStage : Boolean,
                               val relaxPredictorAddress : Boolean,
                               val fetchRedoGen : Boolean,
                               val predictionBuffer : Boolean = true) extends Plugin[VexRiscv] with JumpService with IBusFetcher{
  var prefetchExceptionPort : Flow[ExceptionCause] = null
  var decodePrediction : DecodePredictionBus = null
  var fetchPrediction : FetchPredictionBus = null
  var dynamicTargetFailureCorrection : Flow[UInt] = null
  var externalResetVector : UInt = null
  assert(cmdToRspStageCount >= 1)
//  assert(!(cmdToRspStageCount == 1 && !injectorStage))
  assert(!(compressedGen && !decodePcGen))
  var fetcherHalt : Bool = null
  var pcValids : Vec[Bool] = null
  def pcValid(stage : Stage) = pcValids(pipeline.indexOf(stage))
  var incomingInstruction : Bool = null
  override def incoming() = incomingInstruction


  override def withRvc(): Boolean = compressedGen

  var injectionPort : Stream[Bits] = null
  override def getInjectionPort() = {
    injectionPort = Stream(Bits(32 bits))
    injectionPort
  }
  def pcRegReusedForSecondStage = allowPcRegReusedForSecondStage && prediction != DYNAMIC_TARGET //TODO might not be required for  DYNAMIC_TARGET
  var predictionJumpInterface : Flow[UInt] = null

  override def haltIt(): Unit = fetcherHalt := True
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
    incomingInstruction = False
    if(resetVector == null) externalResetVector = in(UInt(32 bits).setName("externalResetVector"))

    prediction match {
      case NONE =>
      case STATIC | DYNAMIC => {
        predictionJumpInterface = createJumpInterface(pipeline.decode)
        decodePrediction = pipeline.service(classOf[PredictionInterface]).askDecodePrediction()
      }
      case DYNAMIC_TARGET => {
        fetchPrediction = pipeline.service(classOf[PredictionInterface]).askFetchPrediction()
      }
    }

    pcValids = Vec(Bool, pipeline.stages.size)
  }

  object IBUS_RSP
  object DECOMPRESSOR
  object INJECTOR_M2S

  def isDrivingDecode(s : Any): Boolean = {
    if(injectorStage) return s == INJECTOR_M2S
    s == IBUS_RSP || s == DECOMPRESSOR
  }



  class FetchArea(pipeline : VexRiscv) extends Area {
    import pipeline._
    import pipeline.config._
    val externalFlush = stages.map(_.arbitration.flushNext).orR

    def getFlushAt(s : Any, lastCond : Boolean = true): Bool = {
      if(isDrivingDecode(s) && lastCond)  pipeline.decode.arbitration.isRemoved else externalFlush
    }

    //Arbitrate jump requests into pcLoad
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



    //The fetchPC pcReg can also be use for the second stage of the fetch
    //When the fetcherHalt is set and the pipeline isn't stalled,, the pc is propagated to to the pcReg, which allow
    //using the pc pipeline to get the next PC value for interrupts
    val fetchPc = new Area{
      //PC calculation without Jump
      val output = Stream(UInt(32 bits))
      val pcReg = Reg(UInt(32 bits)) init(if(resetVector != null) resetVector else externalResetVector) addAttribute(Verilator.public)
      val correction = False
      val correctionReg = RegInit(False) setWhen(correction) clearWhen(output.fire)
      val corrected = correction || correctionReg
      val pcRegPropagate = False
      val booted = RegNext(True) init (False)
      val inc = RegInit(False) clearWhen(correction || pcRegPropagate) setWhen(output.fire) clearWhen(!output.valid && output.ready)
      val pc = pcReg + (inc ## B"00").asUInt
      val predictionPcLoad = ifGen(prediction == DYNAMIC_TARGET) (Flow(UInt(32 bits)))
      val redo = (fetchRedoGen || prediction == DYNAMIC_TARGET) generate Flow(UInt(32 bits))
      val flushed = False

      if(compressedGen) when(inc) {
        pc(1) := False
      }

      if(predictionPcLoad != null) {
        when(predictionPcLoad.valid) {
          correction := True
          pc := predictionPcLoad.payload
        }
      }
      if(redo != null) when(redo.valid){
        correction := True
        pc := redo.payload
        flushed := True
      }
      when(jump.pcLoad.valid) {
        correction := True
        pc := jump.pcLoad.payload
        flushed := True
      }

      when(booted && (output.ready || correction || pcRegPropagate)){
        pcReg := pc
      }

      pc(0) := False
      if(!compressedGen) pc(1) := False

      output.valid := !fetcherHalt && booted
      output.payload := pc
    }

    val decodePc = ifGen(decodePcGen)(new Area {
      //PC calculation without Jump
      val flushed = False
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
      when(jump.pcLoad.valid && (!decode.arbitration.isStuck || decode.arbitration.isRemoved)) {
        pcReg := jump.pcLoad.payload
        flushed := True
      }
    })


    case class FetchRsp() extends Bundle {
      val pc = UInt(32 bits)
      val rsp = IBusSimpleRsp()
      val isRvc = Bool()
    }


    val iBusRsp = new Area {
      val redoFetch = False
      val stages = Array.fill(cmdToRspStageCount + 1)(new Bundle {
        val input = Stream(UInt(32 bits))
        val output = Stream(UInt(32 bits))
        val halt = Bool()
      })

      stages(0).input << fetchPc.output
      for(s <- stages) {
        s.halt := False
        s.output << s.input.haltWhen(s.halt)
      }

      if(fetchPc.redo != null) {
        fetchPc.redo.valid := redoFetch
        fetchPc.redo.payload := stages.last.input.payload
      }

      val flush = (if(isDrivingDecode(IBUS_RSP)) pipeline.decode.arbitration.isRemoved || decode.arbitration.flushNext && !decode.arbitration.isStuck else externalFlush) || redoFetch
      for((s,sNext) <- (stages, stages.tail).zipped) {
        val sFlushed = if(s != stages.head) flush else False
        val sNextFlushed = flush
        if(s == stages.head && pcRegReusedForSecondStage) {
          sNext.input.arbitrationFrom(s.output.toEvent().m2sPipeWithFlush(sNextFlushed, false, collapsBubble = false, flushInput = sFlushed))
          sNext.input.payload := fetchPc.pcReg
          fetchPc.pcRegPropagate setWhen(sNext.input.ready)
        } else {
          sNext.input << s.output.m2sPipeWithFlush(sNextFlushed, false, collapsBubble = false, flushInput = sFlushed)
        }
      }

      val readyForError = True
      val output = Stream(FetchRsp())
      incomingInstruction setWhen(stages.tail.map(_.input.valid).reduce(_ || _))
    }

    val decompressor = ifGen(decodePcGen)(new Area{
      val input = iBusRsp.output.clearValidWhen(iBusRsp.redoFetch)
      val output = Stream(FetchRsp())
      val flush = getFlushAt(DECOMPRESSOR)
      val flushNext = if(isDrivingDecode(DECOMPRESSOR)) decode.arbitration.flushNext else False
      val consumeCurrent = if(isDrivingDecode(DECOMPRESSOR)) flushNext && output.ready else False

      val bufferValid = RegInit(False)
      val bufferData = Reg(Bits(16 bits))

      val isInputLowRvc = input.rsp.inst(1 downto 0) =/= 3
      val isInputHighRvc = input.rsp.inst(17 downto 16) =/= 3
      val throw2BytesReg = RegInit(False)
      val throw2Bytes = throw2BytesReg || input.pc(1)
      val unaligned = throw2Bytes || bufferValid
      def aligned = !unaligned

      //Latch and patches are there to ensure that the decoded instruction do not mutate while being halted and unscheduled to ensure FpuPlugin cmd fork from consistancy
      val bufferValidLatch = RegNextWhen(bufferValid, input.valid)
      val throw2BytesLatch = RegNextWhen(throw2Bytes, input.valid)
      val bufferValidPatched = input.valid ? bufferValid | bufferValidLatch
      val throw2BytesPatched = input.valid ? throw2Bytes | throw2BytesLatch

      val raw = Mux(
        sel = bufferValidPatched,
        whenTrue = input.rsp.inst(15 downto 0) ## bufferData,
        whenFalse = input.rsp.inst(31 downto 16) ## (throw2BytesPatched ? input.rsp.inst(31 downto 16) | input.rsp.inst(15 downto 0))
      )
      val isRvc = raw(1 downto 0) =/= 3
      val decompressed = RvcDecompressor(raw(15 downto 0), pipeline.config.withRvf, pipeline.config.withRvd)
      output.valid := input.valid && !(throw2Bytes && !bufferValid && !isInputHighRvc)
      output.pc := input.pc
      output.isRvc := isRvc
      output.rsp.inst := isRvc ? decompressed | raw
      input.ready := output.ready && (!iBusRsp.stages.last.input.valid || flushNext || (!(bufferValid && isInputHighRvc) && !(aligned && isInputLowRvc && isInputHighRvc)))

      when(output.fire){
        throw2BytesReg := (aligned && isInputLowRvc && isInputHighRvc) || (bufferValid && isInputHighRvc)
      }
      val bufferFill = (aligned && isInputLowRvc && !isInputHighRvc) || (bufferValid && !isInputHighRvc) || (throw2Bytes && !isRvc && !isInputHighRvc)
      when(output.ready && input.valid){
        bufferValid := False
      }
      when(output.ready && input.valid){
        bufferData := input.rsp.inst(31 downto 16)
        bufferValid setWhen(bufferFill)
      }

      when(flush || consumeCurrent){
        throw2BytesReg := False
        bufferValid := False
      }

      if(fetchPc.redo != null) {
        fetchPc.redo.payload(1) setWhen(throw2BytesReg)
      }
    })


    def condApply[T](that : T, cond : Boolean)(func : (T) => T) = if(cond)func(that) else that
    val injector = new Area {
      val inputBeforeStage = condApply(if (decodePcGen) decompressor.output else iBusRsp.output, injectorReadyCutGen)(_.s2mPipe(externalFlush))
      if (injectorReadyCutGen) {
        iBusRsp.readyForError.clearWhen(inputBeforeStage.valid) //Can't emit error if there is a instruction pending in the s2mPipe
        incomingInstruction setWhen (inputBeforeStage.valid)
      }
      val decodeInput = (if (injectorStage) {
        val flushStage = getFlushAt(INJECTOR_M2S)
        val decodeInput = inputBeforeStage.m2sPipeWithFlush(flushStage, false, collapsBubble = false, flushInput = externalFlush)
        decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), inputBeforeStage.rsp.inst)
        iBusRsp.readyForError.clearWhen(decodeInput.valid) //Can't emit error when there is a instruction pending in the injector stage buffer
        incomingInstruction setWhen (decodeInput.valid)
        decodeInput
      } else {
        inputBeforeStage
      })

      if(!decodePcGen) iBusRsp.readyForError.clearWhen(!pcValid(decode)) //Need to wait a valid PC on the decode stage, as it is use to fill CSR xEPC


      def pcUpdatedGen(input : Bool, stucks : Seq[Bool], relaxedInput : Boolean, flush : Bool) : Seq[Bool] = {
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
        val valids = pcUpdatedGen(True, False :: stagesFromExecute.map(_.arbitration.isStuck), true, decodePc.flushed)
        pcValids := Vec(valids.takeRight(stages.size))
      } else new Area{
        val valids = pcUpdatedGen(True, iBusRsp.stages.tail.map(!_.input.ready) ++ (if (injectorStage) List(!decodeInput.ready) else Nil) ++ stagesFromExecute.map(_.arbitration.isStuck), false, fetchPc.flushed)
        pcValids := Vec(valids.takeRight(stages.size))
      }

      decodeInput.ready := !decode.arbitration.isStuck
      decode.arbitration.isValid := decodeInput.valid
      decode.insert(PC) := (if (decodePcGen) decodePc.pcReg else decodeInput.pc)
      decode.insert(INSTRUCTION) := decodeInput.rsp.inst
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

    def stage1ToInjectorPipe[T <: Data](input : T): (T, T, T) ={
      val iBusRspContext = iBusRsp.stages.drop(1).dropRight(1).foldLeft(input)((data,stage) => RegNextWhen(data, stage.output.ready))

      val iBusRspContextOutput = cloneOf(input)
      iBusRspContextOutput := iBusRspContext
      val injectorContext = Delay(iBusRspContextOutput, cycleCount=if(injectorStage) 1 else 0, when=injector.decodeInput.ready)
      val injectorContextWire = cloneOf(input) //Allow combinatorial override
      injectorContextWire := injectorContext
      (iBusRspContext, iBusRspContextOutput, injectorContextWire)
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
          fetchContext.line := historyCache.readSync((fetchPc.output.payload >> 2).resized, iBusRsp.stages(0).output.ready || externalFlush)

          object PREDICTION_CONTEXT extends Stageable(DynamicContext())
          decode.insert(PREDICTION_CONTEXT) := stage1ToInjectorPipe(fetchContext)._3
          val decodeContextPrediction = decode.input(PREDICTION_CONTEXT).line.history.msb

          val branchStage = decodePrediction.stage
          val branchContext = branchStage.input(PREDICTION_CONTEXT)
          val moreJump = decodePrediction.rsp.wasWrong ^ branchContext.line.history.msb

          historyWrite.address := branchStage.input(PC)(2, historyRamSizeLog2 bits) + (if(pipeline.config.withRvc)
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

        val noPredictionOnMissaligned = (!pipeline.config.withRvc) generate new Area{
          val missaligned = decode.input(BRANCH_CTRL).mux(
            BranchCtrlEnum.JAL  ->  imm.j_sext(1),
            default             ->  imm.b_sext(1)
          )
          decodePrediction.cmd.hadBranch clearWhen(missaligned)
        }

        //TODO no more fireing depedancies
        predictionJumpInterface.valid := decode.arbitration.isValid && decodePrediction.cmd.hadBranch
        predictionJumpInterface.payload := decode.input(PC) + ((decode.input(BRANCH_CTRL) === BranchCtrlEnum.JAL) ? imm.j_sext | imm.b_sext).asUInt
        decode.arbitration.flushNext setWhen(predictionJumpInterface.valid)

        if(relaxPredictorAddress) KeepAttribute(predictionJumpInterface.payload)
      }
      case DYNAMIC_TARGET => new Area{
//        assert(!compressedGen || cmdToRspStageCount == 1, "Can't combine DYNAMIC_TARGET and RVC as it could stop the instruction fetch mid-air")

        case class BranchPredictorLine()  extends Bundle{
          val source = Bits(30 - historyRamSizeLog2 bits)
          val branchWish = UInt(2 bits)
          val last2Bytes = ifGen(compressedGen)(Bool)
          val target = UInt(32 bits)
        }

        val history = Mem(BranchPredictorLine(), 1 << historyRamSizeLog2)
        val historyWriteDelayPatched = history.writePort
        val historyWrite = cloneOf(historyWriteDelayPatched)
        historyWriteDelayPatched.valid := historyWrite.valid
        historyWriteDelayPatched.address := (if(predictionBuffer) historyWrite.address - 1 else historyWrite.address)
        historyWriteDelayPatched.data := historyWrite.data


        val writeLast = RegNextWhen(historyWriteDelayPatched, iBusRsp.stages(0).output.ready)

        //Avoid write to read hazard
        val buffer = predictionBuffer generate new Area{
          val line = history.readSync((iBusRsp.stages(0).input.payload >> 2).resized, iBusRsp.stages(0).output.ready)
          val pcCorrected = RegNextWhen(fetchPc.corrected, iBusRsp.stages(0).input.ready)
          val hazard = (writeLast.valid && writeLast.address === (iBusRsp.stages(1).input.payload >> 2).resized)
        }

        val (line, hazard) = predictionBuffer match {
          case true =>
            (RegNextWhen(buffer.line, iBusRsp.stages(0).output.ready),
             RegNextWhen(buffer.hazard, iBusRsp.stages(0).output.ready) || buffer.pcCorrected)
          case false =>
            (history.readSync((iBusRsp.stages(0).input.payload >> 2).resized,
             iBusRsp.stages(0).output.ready), writeLast.valid && writeLast.address === (iBusRsp.stages(1).input.payload >> 2).resized)
        }

        val hit = line.source === (iBusRsp.stages(1).input.payload.asBits >> 2 + historyRamSizeLog2)
        if(compressedGen) hit clearWhen(!line.last2Bytes && iBusRsp.stages(1).input.payload(1))

        fetchPc.predictionPcLoad.valid := line.branchWish.msb && hit && !hazard && iBusRsp.stages(1).input.valid
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

        val (iBusRspContext, iBusRspContextOutput, injectorContext) = stage1ToInjectorPipe(fetchContext)

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
        if(compressedGen) historyWrite.data.last2Bytes := fetchPrediction.stage.input(PC)(1) && fetchPrediction.stage.input(IS_RVC)

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

        val compressor = compressedGen generate new Area{
          val predictionBranch =  iBusRspContext.hit && !iBusRspContext.hazard && iBusRspContext.line.branchWish(1)
          val unalignedWordIssue = iBusRsp.output.valid && predictionBranch && iBusRspContext.line.last2Bytes && Mux(decompressor.unaligned, !decompressor.isInputHighRvc, decompressor.isInputLowRvc && !decompressor.isInputHighRvc)

          when(unalignedWordIssue){
            historyWrite.valid := True
            historyWrite.address := (iBusRsp.stages(1).input.payload >> 2).resized
            historyWrite.data.branchWish := 0

            iBusRsp.redoFetch := True
          }

          //Do not trigger prediction hit when it is one for the upper RVC word and we aren't there yet
          iBusRspContextOutput.hit clearWhen(iBusRspContext.line.last2Bytes && (decompressor.bufferValid || (!decompressor.throw2Bytes && decompressor.isInputLowRvc)))

          decodePc.predictionPcLoad.valid := injectorContext.line.branchWish.msb && injectorContext.hit && !injectorContext.hazard && injector.decodeInput.fire
          decodePc.predictionPcLoad.payload := injectorContext.line.target

          //Clean the RVC buffer when a prediction was made
          when(iBusRspContext.line.branchWish.msb && iBusRspContextOutput.hit && !iBusRspContext.hazard && decompressor.output.fire){
            decompressor.bufferValid := False
            decompressor.throw2BytesReg := False
            decompressor.input.ready := True //Drop the remaining byte if any
          }
        }
      }
    }

    def stageXToIBusRsp[T <: Data](stage : Any, input : T): (T) ={
      iBusRsp.stages.dropWhile(_ != stage).tail.foldLeft(input)((data,stage) => RegNextWhen(data, stage.output.ready))
    }

  }
}