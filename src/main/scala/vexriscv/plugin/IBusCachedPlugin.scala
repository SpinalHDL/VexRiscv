package vexriscv.plugin

import vexriscv.{plugin, _}
import vexriscv.ip._
import spinal.core._
import spinal.lib._

//class IBusCachedPlugin(config : InstructionCacheConfig, memoryTranslatorPortConfig : Any = null) extends Plugin[VexRiscv] {
//  var iBus  : InstructionCacheMemBus = null
//  override def build(pipeline: VexRiscv): Unit = ???
//}
class IBusCachedPlugin(resetVector : BigInt = 0x80000000l,
                       relaxedPcCalculation : Boolean = false,
                       prediction : BranchPrediction = NONE,
                       historyRamSizeLog2 : Int = 10,
                       compressedGen : Boolean = false,
                       keepPcPlus4 : Boolean = false,
                       config : InstructionCacheConfig,
                       memoryTranslatorPortConfig : Any = null,
                       injectorStage : Boolean = false)  extends IBusFetcherImpl(
  catchAccessFault = config.catchAccessFault,
  resetVector = resetVector,
  keepPcPlus4 = keepPcPlus4,
  decodePcGen = compressedGen,
  compressedGen = compressedGen,
  cmdToRspStageCount = (if(config.twoCycleCache) 2 else 1),
  injectorReadyCutGen = false,
  relaxedPcCalculation = relaxedPcCalculation,
  prediction = prediction,
  historyRamSizeLog2 = historyRamSizeLog2,
  injectorStage = !config.twoCycleCache || injectorStage){
  import config._

  var iBus  : InstructionCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var privilegeService : PrivilegeService = null
  var redoBranch : Flow[UInt] = null
  var decodeExceptionPort : Flow[ExceptionCause] = null

  object FLUSH_ALL extends Stageable(Bool)
  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  object IBUS_MMU_MISS extends Stageable(Bool)
  object IBUS_ILLEGAL_ACCESS extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    super.setup(pipeline)

    def MANAGEMENT  = M"-----------------100-----0001111"

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FLUSH_ALL, False)
    decoderService.add(MANAGEMENT,  List(
        FLUSH_ALL -> True
    ))


    redoBranch = pipeline.service(classOf[JumpService]).createJumpInterface(pipeline.decode, priority = 1) //Priority 1 will win against branch predictor

    if(catchSomething) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }

    if(pipeline.serviceExist(classOf[MemoryTranslator]))
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_INSTRUCTION, memoryTranslatorPortConfig)

    if(pipeline.serviceExist(classOf[PrivilegeService]))
      privilegeService = pipeline.service(classOf[PrivilegeService])

    if(pipeline.serviceExist(classOf[ReportService])){
      val report = pipeline.service(classOf[ReportService])
      report.add("iBus" -> {
        val e = new BusReport()
        val c = new CacheReport()
        e.kind = "cached"
        e.flushInstructions.add(0x400F) //invalid instruction cache
        e.flushInstructions.add(0x13)
        e.flushInstructions.add(0x13)
        e.flushInstructions.add(0x13)

        e.info = c
        c.size = cacheSize
        c.bytePerLine = bytePerLine

        e
      })
    }
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new FetchArea(pipeline) {
      val cache = new InstructionCache(IBusCachedPlugin.this.config)
      iBus = master(new InstructionCacheMemBus(IBusCachedPlugin.this.config)).setName("iBus")
      iBus <> cache.io.mem
      iBus.cmd.address.allowOverride := cache.io.mem.cmd.address // - debugAddressOffset

      //Connect prefetch cache side
      cache.io.cpu.prefetch.isValid := fetchPc.output.valid
      cache.io.cpu.prefetch.pc := fetchPc.output.payload
      iBusRsp.input << fetchPc.output.haltWhen(cache.io.cpu.prefetch.haltIt)


      cache.io.cpu.fetch.isRemoved := flush
      val iBusRspOutputHalt = False
      if (mmuBus != null) {
        cache.io.cpu.fetch.mmuBus <> mmuBus
        (if(twoCycleCache) iBusRsp.inputPipelineHalt(0) else iBusRspOutputHalt) setWhen(mmuBus.cmd.isValid && !mmuBus.rsp.hit && !mmuBus.rsp.miss)
      } else {
        cache.io.cpu.fetch.mmuBus.rsp.physicalAddress := cache.io.cpu.fetch.mmuBus.cmd.virtualAddress
        cache.io.cpu.fetch.mmuBus.rsp.allowExecute := True
        cache.io.cpu.fetch.mmuBus.rsp.allowRead := True
        cache.io.cpu.fetch.mmuBus.rsp.allowWrite := True
        cache.io.cpu.fetch.mmuBus.rsp.allowUser := True
        cache.io.cpu.fetch.mmuBus.rsp.isIoAccess := False
        cache.io.cpu.fetch.mmuBus.rsp.miss := False
        cache.io.cpu.fetch.mmuBus.rsp.hit := False
      }

      //Connect fetch cache side
      cache.io.cpu.fetch.isValid := iBusRsp.inputPipeline(0).valid
      cache.io.cpu.fetch.isStuck := !iBusRsp.inputPipeline(0).ready
      cache.io.cpu.fetch.pc := iBusRsp.inputPipeline(0).payload


      if(twoCycleCache){
        cache.io.cpu.decode.isValid := iBusRsp.inputPipeline(1).valid
        cache.io.cpu.decode.isStuck := !iBusRsp.inputPipeline(1).ready
        cache.io.cpu.decode.pc := iBusRsp.inputPipeline(1).payload
        cache.io.cpu.decode.isUser := (if (privilegeService != null) privilegeService.isUser(decode) else False)

        if((!twoCycleRam || wayCount == 1) && !compressedGen && !injectorStage){
          decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), cache.io.cpu.fetch.data)
        }
      } else {
        cache.io.cpu.fetch.isUser := (if (privilegeService != null) privilegeService.isUser(decode) else False)
      }



//      val missHalt = cache.io.cpu.fetch.isValid && cache.io.cpu.fetch.cacheMiss
      val cacheRsp = if(twoCycleCache) cache.io.cpu.decode else cache.io.cpu.fetch
      val cacheRspArbitration = iBusRsp.inputPipeline(if(twoCycleCache) 1 else 0)
      var issueDetected = False
      val redoFetch = False //RegNext(False) init(False)
      when(cacheRsp.isValid && cacheRsp.cacheMiss && !issueDetected){
        issueDetected \= True
        redoFetch := iBusRsp.readyForError
      }


      assert(decodePcGen == compressedGen)
      cache.io.cpu.fill.valid  := redoFetch
      redoBranch.valid   := redoFetch
      redoBranch.payload := (if(decodePcGen) decode.input(PC) else cacheRsp.pc)
      cache.io.cpu.fill.payload := cacheRsp.physicalAddress

      if(catchSomething){
        val accessFault = if (catchAccessFault) cacheRsp.error else False
        val mmuMiss = if (catchMemoryTranslationMiss) cacheRsp.mmuMiss else False
        val illegalAccess = if (catchIllegalAccess) cacheRsp.illegalAccess else False

        decodeExceptionPort.valid := False
        decodeExceptionPort.code  := mmuMiss ? U(14) | 1
        decodeExceptionPort.badAddr := cacheRsp.pc
        when(cacheRsp.isValid && (accessFault || mmuMiss || illegalAccess) && !issueDetected){
          issueDetected \= True
          decodeExceptionPort.valid  := iBusRsp.readyForError
        }
      }


      iBusRsp.output.arbitrationFrom(cacheRspArbitration.haltWhen(issueDetected || iBusRspOutputHalt))
      iBusRsp.output.rsp.inst := cacheRsp.data
      iBusRsp.output.pc := cacheRspArbitration.payload


//      if (dataOnDecode) {
//        decode.insert(INSTRUCTION) := cache.io.cpu.decode.data
//      } else {
//        iBusRsp.outputBeforeStage.arbitrationFrom(iBusRsp.inputPipeline(0))
//        iBusRsp.outputBeforeStage.rsp.inst := cache.io.cpu.fetch.data
//        iBusRsp.outputBeforeStage.pc := iBusRsp.inputPipeline(0).payload
//      }
//
//      cache.io.cpu.decode.pc := injector.inputBeforeHalt.pc
//
//      val ownDecode = pipeline.plugins.filter(_.isInstanceOf[InstructionInjector]).foldLeft(True)(_ && !_.asInstanceOf[InstructionInjector].isInjecting(decode))
//      cache.io.cpu.decode.isValid := decode.arbitration.isValid && ownDecode
//      cache.io.cpu.decode.isStuck := !injector.inputBeforeHalt.ready
//      cache.io.cpu.decode.isUser := (if (privilegeService != null) privilegeService.isUser(decode) else False)
//      //    cache.io.cpu.decode.pc  := decode.input(PC)
//
//      redoBranch.valid := decode.arbitration.isValid && ownDecode && cache.io.cpu.decode.cacheMiss && !cache.io.cpu.decode.mmuMiss && !cache.io.cpu.decode.illegalAccess
//      redoBranch.payload := decode.input(PC)
//      when(redoBranch.valid) {
//        decode.arbitration.redoIt := True
//        decode.arbitration.flushAll := True
//      }

      //    val redo = RegInit(False) clearWhen(decode.arbitration.isValid) setWhen(redoBranch.valid)
      //    when(redoBranch.valid || redo){
      //      service(classOf[InterruptionInhibitor]).inhibateInterrupts()
      //    }

//      if (catchSomething) {
//        val accessFault = if (catchAccessFault) cache.io.cpu.decode.error else False
//        val mmuMiss = if (catchMemoryTranslationMiss) cache.io.cpu.decode.mmuMiss else False
//        val illegalAccess = if (catchIllegalAccess) cache.io.cpu.decode.illegalAccess else False

//        decodeExceptionPort.valid := decode.arbitration.isValid && ownDecode && (accessFault || mmuMiss || illegalAccess)
//        decodeExceptionPort.code := mmuMiss ? U(14) | 1
//        decodeExceptionPort.badAddr := decode.input(PC)
//      }

      memory plug new Area {

        import memory._

        cache.io.flush.cmd.valid := False
        when(arbitration.isValid && input(FLUSH_ALL)) {
          cache.io.flush.cmd.valid := True
          decode.arbitration.flushAll := True

          when(!cache.io.flush.cmd.ready) {
            arbitration.haltItself := True
          }
        }
      }
    }
  }
}
