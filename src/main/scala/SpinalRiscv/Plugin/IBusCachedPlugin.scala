package SpinalRiscv.Plugin

import SpinalRiscv._
import SpinalRiscv.ip._
import spinal.core._
import spinal.lib._


class IBusCachedPlugin(config : InstructionCacheConfig, askMemoryTranslation : Boolean = false, memoryTranslatorPortConfig : Any = null) extends Plugin[VexRiscv] {
  import config._
  assert(twoStageLogic || !askMemoryTranslation)

  var iBus  : InstructionCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var decodeExceptionPort : Flow[ExceptionCause] = null
  var privilegeService : PrivilegeService = null

  object FLUSH_ALL extends Stageable(Bool)
  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    def MANAGEMENT  = M"-----------------100-----0001111"

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FLUSH_ALL, False)
    decoderService.add(MANAGEMENT,  List(
        FLUSH_ALL -> True
    ))

    if(catchSomething) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }

    if(askMemoryTranslation)
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(pipeline.fetch, memoryTranslatorPortConfig)

    if(pipeline.serviceExist(classOf[PrivilegeService]))
      privilegeService = pipeline.service(classOf[PrivilegeService])
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val cache = new InstructionCache(this.config)
    iBus = master(new InstructionCacheMemBus(this.config)).setName("iBus")
    iBus <> cache.io.mem


    //Connect prefetch cache side
    cache.io.cpu.prefetch.isValid := prefetch.arbitration.isValid
    cache.io.cpu.prefetch.isFiring := prefetch.arbitration.isFiring
    cache.io.cpu.prefetch.address := prefetch.output(PC)
    prefetch.arbitration.haltIt setWhen(cache.io.cpu.prefetch.haltIt)

    //Connect fetch cache side
    cache.io.cpu.fetch.isValid  := fetch.arbitration.isValid
    cache.io.cpu.fetch.isStuck  := fetch.arbitration.isStuck
    if(!twoStageLogic) cache.io.cpu.fetch.isStuckByOthers  := fetch.arbitration.isStuckByOthers
    cache.io.cpu.fetch.address  := fetch.output(PC)
    if(!twoStageLogic) {
      fetch.arbitration.haltIt setWhen (cache.io.cpu.fetch.haltIt)
      fetch.insert(INSTRUCTION) := cache.io.cpu.fetch.data
      decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck,decode.input(INSTRUCTION),fetch.output(INSTRUCTION))
      decode.insert(INSTRUCTION_READY) := True
    }else {
      if (mmuBus != null) {
        cache.io.cpu.fetch.mmuBus <> mmuBus
      } else {
        cache.io.cpu.fetch.mmuBus.rsp.physicalAddress := cache.io.cpu.fetch.mmuBus.cmd.virtualAddress
        cache.io.cpu.fetch.mmuBus.rsp.allowExecute := True
        cache.io.cpu.fetch.mmuBus.rsp.allowRead := True
        cache.io.cpu.fetch.mmuBus.rsp.allowWrite := True
      }
    }



    if(twoStageLogic){
      cache.io.cpu.decode.isValid := decode.arbitration.isValid && RegNextWhen(fetch.arbitration.isValid, !decode.arbitration.isStuck) //avoid inserted instruction from debug module
      decode.arbitration.haltIt.setWhen(cache.io.cpu.decode.haltIt)
      cache.io.cpu.decode.isStuck := decode.arbitration.isStuck
      cache.io.cpu.decode.isUser  := (if(privilegeService != null) privilegeService.isUser(writeBack) else False)
      cache.io.cpu.decode.address := decode.input(PC)
      decode.insert(INSTRUCTION)  := cache.io.cpu.decode.data
      decode.insert(INSTRUCTION_ANTICIPATED) := cache.io.cpu.decode.dataAnticipated
      decode.insert(INSTRUCTION_READY) := !cache.io.cpu.decode.haltIt
    }


    if(catchSomething){
      if(catchAccessFault) {
        if (!twoStageLogic) fetch.insert(IBUS_ACCESS_ERROR) := cache.io.cpu.fetch.error
        if (twoStageLogic) decode.insert(IBUS_ACCESS_ERROR) := cache.io.cpu.decode.error
      }

      val accessFault = if(catchAccessFault) decode.input(IBUS_ACCESS_ERROR) else False
      val mmuMiss = if(catchMemoryTranslationMiss) cache.io.cpu.decode.mmuMiss else False
      val illegalAccess = if(catchIllegalAccess) cache.io.cpu.decode.illegalAccess else False

      decodeExceptionPort.valid   := decode.arbitration.isValid && (accessFault || mmuMiss || illegalAccess)
      decodeExceptionPort.code    := mmuMiss ? U(14) | 1
      decodeExceptionPort.badAddr := decode.input(PC)
    }

    memory plug new Area{
      import memory._
      cache.io.flush.cmd.valid := False
      when(arbitration.isValid && input(FLUSH_ALL)){
        cache.io.flush.cmd.valid := True

        when(!cache.io.flush.cmd.ready){
          arbitration.haltIt := True
        } otherwise {
          decode.arbitration.flushAll := True
        }
      }
    }
  }
}
