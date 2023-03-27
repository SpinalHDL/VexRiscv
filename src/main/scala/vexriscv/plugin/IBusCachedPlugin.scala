package vexriscv.plugin

import vexriscv.{plugin, _}
import vexriscv.ip._
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer

//class IBusCachedPlugin(config : InstructionCacheConfig, memoryTranslatorPortConfig : Any = null) extends Plugin[VexRiscv] {
//  var iBus  : InstructionCacheMemBus = null
//  override def build(pipeline: VexRiscv): Unit = ???
//}

case class TightlyCoupledBus() extends Bundle with IMasterSlave {
  val enable = Bool()
  val address = UInt(32 bits)
  val data = Bits(32 bits)

  override def asMaster(): Unit = {
    out(enable, address)
    in(data)
  }
}

case class TightlyCoupledPortParameter(name : String, hit : UInt => Bool)
case class TightlyCoupledPort(p : TightlyCoupledPortParameter, var bus : TightlyCoupledBus)
class IBusCachedPlugin(resetVector : BigInt = 0x80000000l,
                       relaxedPcCalculation : Boolean = false,
                       prediction : BranchPrediction = NONE,
                       historyRamSizeLog2 : Int = 10,
                       compressedGen : Boolean = false,
                       keepPcPlus4 : Boolean = false,
                       val config : InstructionCacheConfig,
                       memoryTranslatorPortConfig : Any = null,
                       injectorStage : Boolean = false,
                       withoutInjectorStage : Boolean = false,
                       relaxPredictorAddress : Boolean = true,
                       predictionBuffer : Boolean = true)  extends IBusFetcherImpl(
  resetVector = resetVector,
  keepPcPlus4 = keepPcPlus4,
  decodePcGen = compressedGen,
  compressedGen = compressedGen,
  cmdToRspStageCount = (if(config.twoCycleCache) 2 else 1) + (if(relaxedPcCalculation) 1 else 0),
  allowPcRegReusedForSecondStage = true,
  injectorReadyCutGen = false,
  prediction = prediction,
  historyRamSizeLog2 = historyRamSizeLog2,
  injectorStage = (!config.twoCycleCache && !withoutInjectorStage) || injectorStage,
  relaxPredictorAddress = relaxPredictorAddress,
  fetchRedoGen = true,
  predictionBuffer = predictionBuffer) with VexRiscvRegressionArg{
  import config._



  assert(isPow2(cacheSize))
  assert(!(memoryTranslatorPortConfig != null && config.cacheSize/config.wayCount > 4096), "When the I$ is used with MMU, each way can't be bigger than a page (4096 bytes)")


  assert(!(withoutInjectorStage && injectorStage))


  override def getVexRiscvRegressionArgs(): Seq[String] = {
    var args = List[String]()
    args :+= "IBUS=CACHED"
    args :+= s"IBUS_DATA_WIDTH=$memDataWidth"
    args :+= s"COMPRESSED=${if(compressedGen) "yes" else "no"}"
    args
  }

  var iBus  : InstructionCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var privilegeService : PrivilegeService = null
  var decodeExceptionPort : Flow[ExceptionCause] = null
  val tightlyCoupledPorts = ArrayBuffer[TightlyCoupledPort]()
  def tightlyGen = tightlyCoupledPorts.nonEmpty

  def newTightlyCoupledPort(p : TightlyCoupledPortParameter) = {
    val port = TightlyCoupledPort(p, null)
    tightlyCoupledPorts += port
    this
  }

  def newTightlyCoupledPortV2(p : TightlyCoupledPortParameter) = {
    val port = TightlyCoupledPort(p, master(TightlyCoupledBus()))
    tightlyCoupledPorts += port
    port.bus
  }


  object FLUSH_ALL extends Stageable(Bool)
  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  object IBUS_MMU_MISS extends Stageable(Bool)
  object IBUS_ILLEGAL_ACCESS extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    super.setup(pipeline)

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FLUSH_ALL, False)
    decoderService.add(FENCE_I,  List(
        FLUSH_ALL -> True
    ))

    if(catchSomething) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }

    if(pipeline.serviceExist(classOf[MemoryTranslator]))
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_INSTRUCTION, memoryTranslatorPortConfig)

    privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())

    if(pipeline.serviceExist(classOf[ReportService])){
      val report = pipeline.service(classOf[ReportService])
      report.add("iBus" -> {
        val e = new BusReport()
        val c = new CacheReport()
        e.kind = "cached"
        e.flushInstructions.add(0x100F) //FENCE.I
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
      val cache = new InstructionCache(IBusCachedPlugin.this.config.copy(bypassGen = tightlyGen), if(mmuBus != null) mmuBus.p else MemoryTranslatorBusParameter(0,0))
      iBus = master(new InstructionCacheMemBus(IBusCachedPlugin.this.config)).setName("iBus")
      iBus <> cache.io.mem
      iBus.cmd.address.allowOverride := cache.io.mem.cmd.address

      //Memory bandwidth counter
      val rspCounter = Reg(UInt(32 bits)) init(0)
      when(iBus.rsp.valid){
        rspCounter := rspCounter + 1
      }

      val stageOffset = if(relaxedPcCalculation) 1 else 0
      def stages = iBusRsp.stages.drop(stageOffset)

      tightlyCoupledPorts.filter(_.bus == null).foreach(p => p.bus = master(TightlyCoupledBus()).setName(p.p.name))

      val s0 = new Area {
        //address decoding
        val tightlyCoupledHits = Vec(tightlyCoupledPorts.map(_.p.hit(stages(0).input.payload)))
        val tightlyCoupledHit = tightlyCoupledHits.orR

        for((port, hit) <- (tightlyCoupledPorts, tightlyCoupledHits).zipped){
          port.bus.enable := stages(0).input.fire && hit
          port.bus.address := stages(0).input.payload(31 downto 2) @@ U"00"
        }

        //Connect prefetch cache side
        cache.io.cpu.prefetch.isValid := stages(0).input.valid && !tightlyCoupledHit
        cache.io.cpu.prefetch.pc := stages(0).input.payload
        stages(0).halt setWhen (cache.io.cpu.prefetch.haltIt)

        if(mmuBus != null && mmuBus.p.latency == 1) {
          stages(0).halt setWhen(mmuBus.busy)
          mmuBus.cmd(0).isValid := cache.io.cpu.prefetch.isValid
          mmuBus.cmd(0).isStuck := !stages(0).input.ready
          mmuBus.cmd(0).virtualAddress := cache.io.cpu.prefetch.pc
          mmuBus.cmd(0).bypassTranslation := False
        }
      }


      val s1 = new Area {
        val tightlyCoupledHits = RegNextWhen(s0.tightlyCoupledHits, stages(1).input.ready)
        val tightlyCoupledHit = RegNextWhen(s0.tightlyCoupledHit, stages(1).input.ready)

        if(tightlyGen) cache.io.cpu.fetch.dataBypassValid := tightlyCoupledHit
        if(tightlyGen) cache.io.cpu.fetch.dataBypass := MuxOH(tightlyCoupledHits, tightlyCoupledPorts.map(e => CombInit(e.bus.data)))

        //Connect fetch cache side
        cache.io.cpu.fetch.isValid := stages(1).input.valid && !tightlyCoupledHit
        cache.io.cpu.fetch.isStuck := !stages(1).input.ready
        cache.io.cpu.fetch.pc := stages(1).input.payload

        if(mmuBus != null) {
          mmuBus.cmd.last.isValid := cache.io.cpu.fetch.isValid
          mmuBus.cmd.last.isStuck := !stages(1).input.ready
          mmuBus.cmd.last.virtualAddress := cache.io.cpu.fetch.pc
          mmuBus.cmd.last.bypassTranslation := False
          mmuBus.end := stages(1).input.ready || externalFlush
          if (mmuBus.p.latency == 0) stages(1).halt setWhen (mmuBus.busy)
        }


        if (!twoCycleCache) {
          cache.io.cpu.fetch.isUser := privilegeService.isUser()
        }
      }

      val s2 = twoCycleCache generate new Area {
        val tightlyCoupledHit = RegNextWhen(s1.tightlyCoupledHit, stages(2).input.ready)
        cache.io.cpu.decode.isValid := stages(2).input.valid && !tightlyCoupledHit
        cache.io.cpu.decode.isStuck := !stages(2).input.ready
        cache.io.cpu.decode.pc := stages(2).input.payload
        cache.io.cpu.decode.isUser := privilegeService.isUser()

        if ((!twoCycleRam || wayCount == 1) && !compressedGen && !injectorStage) {
          decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), cache.io.cpu.fetch.data)
        }
      }

      val rsp = new Area {
        val iBusRspOutputHalt = False

        val cacheRsp = if (twoCycleCache) cache.io.cpu.decode else cache.io.cpu.fetch
        val cacheRspArbitration = stages(if (twoCycleCache) 2 else 1)
        var issueDetected = False
        val redoFetch = False


        //Refill / redo
        assert(decodePcGen == compressedGen)
        cache.io.cpu.fill.valid := redoFetch && !cacheRsp.mmuRefilling
        cache.io.cpu.fill.payload := cacheRsp.physicalAddress


        if (catchSomething) {
          decodeExceptionPort.valid := False
          decodeExceptionPort.code.assignDontCare()
          decodeExceptionPort.badAddr := cacheRsp.pc(31 downto 2) @@ U"00"
        }

        when(cacheRsp.isValid && cacheRsp.mmuRefilling && !issueDetected) {
          issueDetected \= True
          redoFetch := True
        }

        if(catchIllegalAccess) when(cacheRsp.isValid && cacheRsp.mmuException && !issueDetected) {
          issueDetected \= True
          decodeExceptionPort.valid := iBusRsp.readyForError
          decodeExceptionPort.code := 12
        }

        when(cacheRsp.isValid && cacheRsp.cacheMiss && !issueDetected) {
          issueDetected \= True
          cache.io.cpu.fill.valid := True
          redoFetch := True
        }

        if(catchAccessFault) when(cacheRsp.isValid && cacheRsp.error && !issueDetected) {
          issueDetected \= True
          decodeExceptionPort.valid := iBusRsp.readyForError
          decodeExceptionPort.code := 1
        }

        when(redoFetch) {
          iBusRsp.redoFetch := True
        }


        cacheRspArbitration.halt setWhen (issueDetected || iBusRspOutputHalt)
        iBusRsp.output.valid := cacheRspArbitration.output.valid
        cacheRspArbitration.output.ready := iBusRsp.output.ready
        iBusRsp.output.rsp.inst := cacheRsp.data
        iBusRsp.output.pc := cacheRspArbitration.output.payload
      }

      if (mmuBus != null) {
        cache.io.cpu.fetch.mmuRsp <> mmuBus.rsp
      } else {
        cache.io.cpu.fetch.mmuRsp.physicalAddress := cache.io.cpu.fetch.pc
        cache.io.cpu.fetch.mmuRsp.allowExecute := True
        cache.io.cpu.fetch.mmuRsp.allowRead := True
        cache.io.cpu.fetch.mmuRsp.allowWrite := True
        cache.io.cpu.fetch.mmuRsp.isIoAccess := False
        cache.io.cpu.fetch.mmuRsp.exception := False
        cache.io.cpu.fetch.mmuRsp.refilling := False
      }

      val flushStage = decode
      cache.io.flush := flushStage.arbitration.isValid && flushStage.input(FLUSH_ALL)
    }
  }
}
