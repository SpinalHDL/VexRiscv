package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
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
}


case class IBusSimpleBus(interfaceKeepData : Boolean = false) extends Bundle with IMasterSlave {
  var cmd = Stream(IBusSimpleCmd())
  var rsp = Flow(IBusSimpleRsp())

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }


  def toAxi4ReadOnly(): Axi4ReadOnly = {
    assert(!interfaceKeepData)
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


    //TODO remove
    val axi2 = Axi4ReadOnly(IBusSimpleBus.getAxi4Config())
    axi.ar >-> axi2.ar
    axi.r << axi2.r
//    axi2 << axi
    axi2
  }

  def toAvalon(): AvalonMM = {
    assert(!interfaceKeepData)
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
}






class IBusSimplePlugin(resetVector : BigInt,
                       cmdForkOnSecondStage : Boolean,
                       cmdForkPersistence : Boolean,
                       catchAccessFault : Boolean = false,
                       prediction : BranchPrediction = NONE,
                       historyRamSizeLog2 : Int = 10,
                       keepPcPlus4 : Boolean = false,
                       compressedGen : Boolean = false,
                       busLatencyMin : Int = 1,
                       pendingMax : Int = 7,
                       injectorStage : Boolean = true,
                       rspHoldValue : Boolean = false,
                       singleInstructionPipeline : Boolean = false,
                       memoryTranslatorPortConfig : Any = null,
                       relaxPredictorAddress : Boolean = true
                      ) extends IBusFetcherImpl(
    resetVector = resetVector,
    keepPcPlus4 = keepPcPlus4,
    decodePcGen = compressedGen,
    compressedGen = compressedGen,
    cmdToRspStageCount = busLatencyMin + (if(cmdForkOnSecondStage) 1 else 0),
    pcRegReusedForSecondStage = !(cmdForkOnSecondStage && cmdForkPersistence),
    injectorReadyCutGen = false,
    prediction = prediction,
    historyRamSizeLog2 = historyRamSizeLog2,
    injectorStage = injectorStage,
  relaxPredictorAddress = relaxPredictorAddress){

  var iBus : IBusSimpleBus = null
  var decodeExceptionPort : Flow[ExceptionCause] = null
  val catchSomething = memoryTranslatorPortConfig != null || catchAccessFault
  var mmuBus : MemoryTranslatorBus = null
  var redoBranch : Flow[UInt] = null

  if(rspHoldValue) assert(busLatencyMin <= 1)

  override def setup(pipeline: VexRiscv): Unit = {
    super.setup(pipeline)
    iBus = master(IBusSimpleBus(false)).setName("iBus")

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.add(FENCE_I, Nil)

    if(catchSomething) {
      decodeExceptionPort = pipeline.service(classOf[ExceptionService]).newExceptionPort(pipeline.decode,1)
    }

    if(memoryTranslatorPortConfig != null) {
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_INSTRUCTION, memoryTranslatorPortConfig)
      redoBranch = pipeline.service(classOf[JumpService]).createJumpInterface(pipeline.decode, priority = 1) //Priority 1 will win against branch predictor
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
      val pendingCmd = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
      val pendingCmdNext = pendingCmd + cmd.fire.asUInt - iBus.rsp.fire.asUInt
      pendingCmd := pendingCmdNext

      val secondStagePersistence = cmdForkPersistence && cmdForkOnSecondStage && !cmdWithS2mPipe
      def cmdForkStage = if(!secondStagePersistence) iBusRsp.stages(if(cmdForkOnSecondStage) 1 else 0) else iBusRsp.stages(1)

      val cmdFork = if(!secondStagePersistence) new Area {
        //This implementation keep the cmd on the bus until it's executed or the the pipeline is flushed
        def stage = cmdForkStage
        stage.halt setWhen(stage.input.valid && (!cmd.valid || !cmd.ready))
        if(singleInstructionPipeline) {
          cmd.valid := stage.input.valid && pendingCmd =/= pendingMax && !stages.map(_.arbitration.isValid).orR
          assert(injectorStage == false)
          assert(iBusRsp.stages.dropWhile(_ != stage).length <= 2)
        }else {
          cmd.valid := stage.input.valid && stage.output.ready && pendingCmd =/= pendingMax
        }
      } else new Area{
        //This implementation keep the cmd on the bus until it's executed, even if the pipeline is flushed
        def stage = cmdForkStage
        val pendingFull = pendingCmd === pendingMax
        val cmdKeep = RegInit(False) setWhen(cmd.valid) clearWhen(cmd.ready)
        val cmdFired = RegInit(False) setWhen(cmd.fire) clearWhen(stage.input.ready)
        stage.halt setWhen(cmd.isStall || (pendingFull && !cmdFired))
        cmd.valid := (stage.input.valid || cmdKeep) && !pendingFull && !cmdFired
      }

      val mmu = (mmuBus != null) generate new Area {
        mmuBus.cmd.isValid := cmdForkStage.input.valid
        mmuBus.cmd.virtualAddress := cmdForkStage.input.payload
        mmuBus.cmd.bypassTranslation := False
        mmuBus.end := cmdForkStage.output.fire || flush

        cmd.pc := mmuBus.rsp.physicalAddress(31 downto 2) @@ "00"

        //do not emit memory request if MMU miss
        when(mmuBus.rsp.exception || mmuBus.rsp.refilling){
          cmdForkStage.halt := False
          cmd.valid := False
        }

        when(mmuBus.busy){
          cmdForkStage.input.valid := False
          cmdForkStage.input.ready := False
        }

        val joinCtx = stageXToIBusRsp(cmdForkStage, mmuBus.rsp)
      }

      val mmuLess = (mmuBus == null) generate new Area{
        cmd.pc := cmdForkStage.input.payload(31 downto 2) @@ "00"
      }

      val rspJoin = new Area {
        import iBusRsp._
        //Manage flush for iBus transactions in flight
        val discardCounter = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
        discardCounter := discardCounter - (iBus.rsp.fire && discardCounter =/= 0).asUInt
        when(flush) {
          if(secondStagePersistence)
            discardCounter := pendingCmd + cmd.valid.asUInt - iBus.rsp.fire.asUInt
          else
            discardCounter := (if(cmdForkOnSecondStage) pendingCmdNext else pendingCmd - iBus.rsp.fire.asUInt)
        }

        val rspBufferOutput = Stream(IBusSimpleRsp())

        val rspBuffer = if(!rspHoldValue) new Area{
          val c = StreamFifoLowLatency(IBusSimpleRsp(), busLatencyMin + (if(cmdForkOnSecondStage && cmdForkPersistence) 1 else 0))
          c.io.push << iBus.rsp.throwWhen(discardCounter =/= 0).toStream
          c.io.flush := flush
          rspBufferOutput << c.io.pop
        } else new Area{
          val rspStream = iBus.rsp.throwWhen(discardCounter =/= 0).toStream
          val validReg = RegInit(False) setWhen(rspStream.valid) clearWhen(rspBufferOutput.ready)
          rspBufferOutput << rspStream
          rspBufferOutput.valid setWhen(validReg)
        }

        val fetchRsp = FetchRsp()
        fetchRsp.pc := stages.last.output.payload
        fetchRsp.rsp := rspBufferOutput.payload
        fetchRsp.rsp.error.clearWhen(!rspBufferOutput.valid) //Avoid interference with instruction injection from the debug plugin


        val join = Stream(FetchRsp())
        val exceptionDetected = False
        val redoRequired = False
        join.valid := stages.last.output.valid && rspBufferOutput.valid
        join.payload := fetchRsp
        stages.last.output.ready := stages.last.output.valid ? join.fire | join.ready
        rspBufferOutput.ready := join.fire
        output << join.haltWhen(exceptionDetected || redoRequired)

        if(memoryTranslatorPortConfig != null){
          redoRequired setWhen( stages.last.input.valid && mmu.joinCtx.refilling)
          redoBranch.valid := redoRequired && iBusRsp.readyForError
          redoBranch.payload := decode.input(PC)
          decode.arbitration.flushAll setWhen(redoBranch.valid)
        }


        if(catchSomething){
          decodeExceptionPort.code.assignDontCare()
          decodeExceptionPort.badAddr := join.pc(31 downto 2) @@ "00"

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
          decodeExceptionPort.valid  :=  exceptionDetected && iBusRsp.readyForError && !fetcherHalt
        }
      }
    }
  }
}
