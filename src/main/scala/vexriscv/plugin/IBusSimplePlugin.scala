package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.ahblite.{AhbLite3, AhbLite3Config, AhbLite3Master}
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbParameter}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.Riscv.{FENCE, FENCE_I}


case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle with IMasterSlave{
  val error = Bool
  val inst  = Bits(32 bits)

  override def asMaster(): Unit = {
    out(error,inst)
  }
}


object IBusSimpleBus{
  def getAxi4Config() = Axi4Config(
    addressWidth = 32,
    dataWidth = 32,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false,
    useLen = false,
    useResp = true,
    useSize = false
  )

  def getAvalonConfig() = AvalonMMConfig.pipelined(
    addressWidth = 32,
    dataWidth = 32
  ).getReadOnlyConfig.copy(
    useResponse = true,
    maximumPendingReadTransactions = 8
  )

  def getWishboneConfig() = WishboneConfig(
    addressWidth = 30,
    dataWidth = 32,
    selWidth = 4,
    useSTALL = false,
    useLOCK = false,
    useERR = true,
    useRTY = false,
    tgaWidth = 0,
    tgcWidth = 0,
    tgdWidth = 0,
    useBTE = true,
    useCTI = true
  )

  def getPipelinedMemoryBusConfig() = PipelinedMemoryBusConfig(
    addressWidth = 32,
    dataWidth = 32
  )


  def getAhbLite3Config() = AhbLite3Config(
    addressWidth = 32,
    dataWidth = 32
  )

  def getBmbParameter(plugin : IBusSimplePlugin = null) = BmbParameter(
    addressWidth = 32,
    dataWidth = 32,
    lengthWidth = 2,
    sourceWidth = 0,
    contextWidth = 0,
    canRead = true,
    canWrite = false,
    alignment     = BmbParameter.BurstAlignement.LENGTH,
    maximumPendingTransaction = if(plugin != null) plugin.pendingMax else Int.MaxValue
  )
}


case class IBusSimpleBus(plugin: IBusSimplePlugin) extends Bundle with IMasterSlave {
  var cmd = Stream(IBusSimpleCmd())
  var rsp = Flow(IBusSimpleRsp())

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }


  def cmdS2mPipe() : IBusSimpleBus = {
    val s = IBusSimpleBus(plugin)
    s.cmd    << this.cmd.s2mPipe()
    this.rsp << s.rsp
    s
  }


  def toAxi4ReadOnly(): Axi4ReadOnly = {
    assert(plugin.cmdForkPersistence)
    val axi = Axi4ReadOnly(IBusSimpleBus.getAxi4Config())

    axi.ar.valid := cmd.valid
    axi.ar.addr  := cmd.pc(axi.readCmd.addr.getWidth -1 downto 2) @@ U"00"
    axi.ar.prot  := "110"
    axi.ar.cache := "1111"
    cmd.ready := axi.ar.ready


    rsp.valid := axi.r.valid
    rsp.inst := axi.r.data
    rsp.error := !axi.r.isOKAY()
    axi.r.ready := True

    axi
  }

  def toAvalon(): AvalonMM = {
    assert(plugin.cmdForkPersistence)
    val avalonConfig = IBusSimpleBus.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)

    mm.read := cmd.valid
    mm.address := (cmd.pc >> 2) @@ U"00"
    cmd.ready := mm.waitRequestn

    rsp.valid := mm.readDataValid
    rsp.inst := mm.readData
    rsp.error := mm.response =/= AvalonMM.Response.OKAY

    mm
  }

  def toWishbone(): Wishbone = {
    val wishboneConfig = IBusSimpleBus.getWishboneConfig()
    val bus = Wishbone(wishboneConfig)
    val cmdPipe = cmd.stage()

    bus.ADR := (cmdPipe.pc >>  2)
    bus.CTI := B"000"
    bus.BTE := "00"
    bus.SEL := "1111"
    bus.WE  := False
    bus.DAT_MOSI.assignDontCare()
    bus.CYC := cmdPipe.valid
    bus.STB := cmdPipe.valid


    cmdPipe.ready := cmdPipe.valid && bus.ACK
    rsp.valid := bus.CYC && bus.ACK
    rsp.inst := bus.DAT_MISO
    rsp.error := False //TODO
    bus
  }

  def toPipelinedMemoryBus(): PipelinedMemoryBus = {
    val pipelinedMemoryBusConfig = IBusSimpleBus.getPipelinedMemoryBusConfig()
    val bus = PipelinedMemoryBus(pipelinedMemoryBusConfig)
    bus.cmd.arbitrationFrom(cmd)
    bus.cmd.address := cmd.pc.resized
    bus.cmd.write := False
    bus.cmd.mask.assignDontCare()
    bus.cmd.data.assignDontCare()
    rsp.valid := bus.rsp.valid
    rsp.inst := bus.rsp.payload.data
    rsp.error := False
    bus
  }


  //cmdForkPersistence need to bet set
  def toAhbLite3Master(): AhbLite3Master = {
    assert(plugin.cmdForkPersistence)
    val bus = AhbLite3Master(IBusSimpleBus.getAhbLite3Config())
    bus.HADDR     := this.cmd.pc
    bus.HWRITE    := False
    bus.HSIZE     := 2
    bus.HBURST    := 0
    bus.HPROT     := "1110"
    bus.HTRANS    := this.cmd.valid ## B"0"
    bus.HMASTLOCK := False
    bus.HWDATA.assignDontCare()
    this.cmd.ready := bus.HREADY

    val pending = RegInit(False) clearWhen(bus.HREADY) setWhen(this.cmd.fire)
    this.rsp.valid := bus.HREADY && pending
    this.rsp.inst := bus.HRDATA
    this.rsp.error := bus.HRESP
    bus
  }
  
  def toBmb() : Bmb = {
    val pipelinedMemoryBusConfig = IBusSimpleBus.getBmbParameter(plugin)
    val bus = Bmb(pipelinedMemoryBusConfig)
    bus.cmd.arbitrationFrom(cmd)
    bus.cmd.opcode := Bmb.Cmd.Opcode.READ
    bus.cmd.address := cmd.pc.resized
    bus.cmd.length := 3
    bus.cmd.last := True
    rsp.valid := bus.rsp.valid
    rsp.inst := bus.rsp.data
    rsp.error := bus.rsp.isError
    bus.rsp.ready := True
    bus
  }
}






class IBusSimplePlugin(    resetVector : BigInt,
                       val cmdForkOnSecondStage : Boolean,
                       val cmdForkPersistence : Boolean,
                       val catchAccessFault : Boolean = false,
                           prediction : BranchPrediction = NONE,
                           historyRamSizeLog2 : Int = 10,
                           keepPcPlus4 : Boolean = false,
                           compressedGen : Boolean = false,
                       val busLatencyMin : Int = 1,
                       val pendingMax : Int = 7,
                           injectorStage : Boolean = true,
                       val rspHoldValue : Boolean = false,
                       val singleInstructionPipeline : Boolean = false,
                       val memoryTranslatorPortConfig : Any = null,
                           relaxPredictorAddress : Boolean = true,
                           predictionBuffer : Boolean = true,
                           bigEndian : Boolean = false,
                           vecRspBuffer : Boolean = false
                      ) extends IBusFetcherImpl(
    resetVector = resetVector,
    keepPcPlus4 = keepPcPlus4,
    decodePcGen = compressedGen,
    compressedGen = compressedGen,
    cmdToRspStageCount = busLatencyMin + (if(cmdForkOnSecondStage) 1 else 0),
    allowPcRegReusedForSecondStage = !(cmdForkOnSecondStage && cmdForkPersistence),
    injectorReadyCutGen = false,
    prediction = prediction,
    historyRamSizeLog2 = historyRamSizeLog2,
    injectorStage = injectorStage,
    relaxPredictorAddress = relaxPredictorAddress,
    fetchRedoGen = memoryTranslatorPortConfig != null,
  predictionBuffer = predictionBuffer){

  var iBus : IBusSimpleBus = null
  var decodeExceptionPort : Flow[ExceptionCause] = null
  val catchSomething = memoryTranslatorPortConfig != null || catchAccessFault
  var mmuBus : MemoryTranslatorBus = null

//  if(rspHoldValue) assert(busLatencyMin <= 1)
  assert(!rspHoldValue, "rspHoldValue not supported yet")
  assert(!singleInstructionPipeline)

  override def setup(pipeline: VexRiscv): Unit = {
    super.setup(pipeline)
    iBus = master(IBusSimpleBus(this)).setName("iBus")

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.add(FENCE_I, Nil)

    if(catchSomething) {
      decodeExceptionPort = pipeline.service(classOf[ExceptionService]).newExceptionPort(pipeline.decode,1)
    }

    if(memoryTranslatorPortConfig != null) {
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_INSTRUCTION, memoryTranslatorPortConfig)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new FetchArea(pipeline) {
      var cmd = Stream(IBusSimpleCmd())
      val cmdWithS2mPipe = cmdForkPersistence && (!cmdForkOnSecondStage || mmuBus != null)
      iBus.cmd << (if(cmdWithS2mPipe) cmd.s2mPipe() else cmd)

      //Avoid sending to many iBus cmd
      val pending = new Area{
        val inc, dec = Bool()
        val value = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
        val next = value + U(inc) - U(dec)
        value := next
      }

      val secondStagePersistence = cmdForkPersistence && cmdForkOnSecondStage && !cmdWithS2mPipe
      def cmdForkStage = if(!secondStagePersistence) iBusRsp.stages(if(cmdForkOnSecondStage) 1 else 0) else iBusRsp.stages(1)

      val cmdFork = if(!secondStagePersistence) new Area {
        //This implementation keep the cmd on the bus until it's executed or the the pipeline is flushed
        def stage = cmdForkStage
        val canEmit = stage.output.ready && pending.value =/= pendingMax
        stage.halt setWhen(stage.input.valid && (!canEmit || !cmd.ready))
        cmd.valid := stage.input.valid && canEmit
        pending.inc := cmd.fire
      } else new Area{
        //This implementation keep the cmd on the bus until it's executed, even if the pipeline is flushed
        def stage = cmdForkStage
        val pendingFull = pending.value === pendingMax
        val enterTheMarket = Bool()
        val cmdKeep = RegInit(False) setWhen(enterTheMarket) clearWhen(cmd.ready)
        val cmdFired = RegInit(False) setWhen(cmd.fire) clearWhen(stage.input.ready)
        enterTheMarket := stage.input.valid && !pendingFull && !cmdFired && !cmdKeep
//        stage.halt setWhen(cmd.isStall || (pendingFull && !cmdFired)) //(cmd.isStall)
        stage.halt setWhen(pendingFull && !cmdFired && !cmdKeep)
        stage.halt setWhen(!cmd.ready && !cmdFired)
        cmd.valid := enterTheMarket || cmdKeep
        pending.inc := enterTheMarket
      }

      val mmu = (mmuBus != null) generate new Area {
        mmuBus.cmd.last.isValid := cmdForkStage.input.valid
        mmuBus.cmd.last.virtualAddress := cmdForkStage.input.payload
        mmuBus.cmd.last.bypassTranslation := False
        mmuBus.end := cmdForkStage.output.fire || externalFlush

        cmd.pc := mmuBus.rsp.physicalAddress(31 downto 2) @@ U"00"

        //do not emit memory request if MMU had issues
        when(cmdForkStage.input.valid) {
          when(mmuBus.rsp.refilling) {
            cmdForkStage.halt := True
            cmd.valid := False
          }
          when(mmuBus.rsp.exception) {
            cmdForkStage.halt := False
            cmd.valid := False
          }
        }

        val joinCtx = stageXToIBusRsp(cmdForkStage, mmuBus.rsp)
      }

      val mmuLess = (mmuBus == null) generate new Area{
        cmd.pc := cmdForkStage.input.payload(31 downto 2) @@ U"00"
      }

      val rspJoin = new Area {
        import iBusRsp._
        //Manage flush for iBus transactions in flight
        val rspBuffer = new Area {
          val output = Stream(IBusSimpleRsp())
          val c = new StreamFifoLowLatency(IBusSimpleRsp(), busLatencyMin + (if(cmdForkOnSecondStage && cmdForkPersistence) 1 else 0), useVec = vecRspBuffer)
          val discardCounter = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
          discardCounter := discardCounter - (c.io.pop.valid && discardCounter =/= 0).asUInt
          when(iBusRsp.flush) {
            discardCounter := (if(cmdForkOnSecondStage) pending.next else pending.value - U(pending.dec))
          }

          c.io.push << iBus.rsp.toStream
//          if(compressedGen) c.io.flush setWhen(decompressor.consumeCurrent)
//          if(!compressedGen && isDrivingDecode(IBUS_RSP)) c.io.flush setWhen(decode.arbitration.flushNext && iBusRsp.output.ready)
          val flush = discardCounter =/= 0 || iBusRsp.flush
          output.valid := c.io.pop.valid && discardCounter === 0
          output.payload := c.io.pop.payload
          c.io.pop.ready := output.ready || flush

          pending.dec := c.io.pop.fire // iBus.rsp.valid && flush || c.io.pop.valid && output.ready instead to avoid unecessary dependancies ?
        }

        val fetchRsp = FetchRsp()
        fetchRsp.pc := stages.last.output.payload
        fetchRsp.rsp := rspBuffer.output.payload
        fetchRsp.rsp.error.clearWhen(!rspBuffer.output.valid) //Avoid interference with instruction injection from the debug plugin
        if(bigEndian){
          // instructions are stored in little endian byteorder
          fetchRsp.rsp.inst.allowOverride
          fetchRsp.rsp.inst := EndiannessSwap(rspBuffer.output.payload.inst)
        }

        val join = Stream(FetchRsp())
        val exceptionDetected = False
        join.valid := stages.last.output.valid && rspBuffer.output.valid
        join.payload := fetchRsp
        stages.last.output.ready := stages.last.output.valid ? join.fire | join.ready
        rspBuffer.output.ready := join.fire
        output << join.haltWhen(exceptionDetected)

        if(memoryTranslatorPortConfig != null){
          when(stages.last.input.valid && mmu.joinCtx.refilling) {
            iBusRsp.redoFetch := True
          }
        }


        if(catchSomething){
          decodeExceptionPort.code.assignDontCare()
          decodeExceptionPort.badAddr := join.pc(31 downto 2) @@ U"00"

          if(catchAccessFault) when(join.valid && join.rsp.error){
            decodeExceptionPort.code  := 1
            exceptionDetected := True
          }
          if(memoryTranslatorPortConfig != null) {
            val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())
            when(stages.last.input.valid && !mmu.joinCtx.refilling && (mmu.joinCtx.exception || !mmu.joinCtx.allowExecute)){
              decodeExceptionPort.code  := 12
              exceptionDetected := True
            }
          }
          decodeExceptionPort.valid  :=  exceptionDetected && iBusRsp.readyForError
        }
      }
    }
  }
}
