package vexriscv.plugin

import vexriscv._
import vexriscv.ip._
import spinal.core._
import spinal.lib._


class IBusCachedPlugin(config : InstructionCacheConfig, memoryTranslatorPortConfig : Any = null) extends Plugin[VexRiscv] {
  import config._

  var iBus  : InstructionCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var decodeExceptionPort : Flow[ExceptionCause] = null
  var privilegeService : PrivilegeService = null
  var redoBranch : Flow[UInt] = null

  object FLUSH_ALL extends Stageable(Bool)
  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  object IBUS_MMU_MISS extends Stageable(Bool)
  object IBUS_ILLEGAL_ACCESS extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

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
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(pipeline.fetch, memoryTranslatorPortConfig)

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
//    val debugAddressOffset = 28
    val cache = new InstructionCache(this.config)
    iBus = master(new InstructionCacheMemBus(this.config)).setName("iBus")
    iBus <> cache.io.mem
    iBus.cmd.address.allowOverride := cache.io.mem.cmd.address // - debugAddressOffset

    //Connect prefetch cache side
    cache.io.cpu.prefetch.isValid := prefetch.arbitration.isValid
    cache.io.cpu.prefetch.pc := prefetch.output(PC)// + debugAddressOffset
    prefetch.arbitration.haltItself setWhen(cache.io.cpu.prefetch.haltIt)

    //Connect fetch cache side
    cache.io.cpu.fetch.isValid  := fetch.arbitration.isValid
    cache.io.cpu.fetch.isStuck  := fetch.arbitration.isStuck
    cache.io.cpu.fetch.pc  := fetch.output(PC) // + debugAddressOffset

    if (mmuBus != null) {
      cache.io.cpu.fetch.mmuBus <> mmuBus
    } else {
      cache.io.cpu.fetch.mmuBus.rsp.physicalAddress := cache.io.cpu.fetch.mmuBus.cmd.virtualAddress //- debugAddressOffset
      cache.io.cpu.fetch.mmuBus.rsp.allowExecute := True
      cache.io.cpu.fetch.mmuBus.rsp.allowRead := True
      cache.io.cpu.fetch.mmuBus.rsp.allowWrite := True
      cache.io.cpu.fetch.mmuBus.rsp.allowUser := True
      cache.io.cpu.fetch.mmuBus.rsp.isIoAccess := False
      cache.io.cpu.fetch.mmuBus.rsp.miss := False
    }

    if(dataOnDecode){
      decode.insert(INSTRUCTION) := cache.io.cpu.decode.data
    }else{
      fetch.insert(INSTRUCTION) := cache.io.cpu.fetch.data
      decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck,decode.input(INSTRUCTION),fetch.output(INSTRUCTION))
    }
    decode.insert(INSTRUCTION_READY) := True

    cache.io.cpu.decode.pc  := decode.output(PC)

    val ownDecode = pipeline.plugins.filter(_.isInstanceOf[InstructionInjector]).foldLeft(True)(_ && !_.asInstanceOf[InstructionInjector].isInjecting(decode))
    cache.io.cpu.decode.isValid  := decode.arbitration.isValid && ownDecode
    cache.io.cpu.decode.isStuck  := decode.arbitration.isStuck
    cache.io.cpu.decode.isUser  := (if(privilegeService != null) privilegeService.isUser(decode) else False)
//    cache.io.cpu.decode.pc  := decode.input(PC)

    redoBranch.valid := decode.arbitration.isValid && ownDecode && cache.io.cpu.decode.cacheMiss && !cache.io.cpu.decode.mmuMiss && !cache.io.cpu.decode.illegalAccess
    redoBranch.payload := decode.input(PC)
    when(redoBranch.valid){
      decode.arbitration.redoIt := True
      decode.arbitration.flushAll := True
    }

//    val redo = RegInit(False) clearWhen(decode.arbitration.isValid) setWhen(redoBranch.valid)
//    when(redoBranch.valid || redo){
//      service(classOf[InterruptionInhibitor]).inhibateInterrupts()
//    }

    if(catchSomething){
      val accessFault = if(catchAccessFault) cache.io.cpu.decode.error else False
      val mmuMiss = if(catchMemoryTranslationMiss) cache.io.cpu.decode.mmuMiss else False
      val illegalAccess = if(catchIllegalAccess) cache.io.cpu.decode.illegalAccess else False

      decodeExceptionPort.valid   := decode.arbitration.isValid && ownDecode && (accessFault || mmuMiss || illegalAccess)
      decodeExceptionPort.code    := mmuMiss ? U(14) | 1
      decodeExceptionPort.badAddr := decode.input(PC)
    }

    memory plug new Area{
      import memory._
      cache.io.flush.cmd.valid := False
      when(arbitration.isValid && input(FLUSH_ALL)){
        cache.io.flush.cmd.valid := True
        decode.arbitration.flushAll := True

        when(!cache.io.flush.cmd.ready){
          arbitration.haltItself := True
        }
      }
    }
  }
}
