package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.ahblite.{AhbLite3Config, AhbLite3Master}
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbParameter}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.ip.DataCacheMemCmd

import scala.collection.mutable.ArrayBuffer


case class DBusSimpleCmd() extends Bundle{
  val wr = Bool
  val address = UInt(32 bits)
  val data = Bits(32 bit)
  val size = UInt(2 bit)
}

case class DBusSimpleRsp() extends Bundle with IMasterSlave{
  val ready = Bool
  val error = Bool
  val data = Bits(32 bit)

  override def asMaster(): Unit = {
    out(ready,error,data)
  }
}


object DBusSimpleBus{
  def getAxi4Config() = Axi4Config(
    addressWidth = 32,
    dataWidth = 32,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false,
    useLen = false,
    useResp = true
  )

  def getAvalonConfig() = AvalonMMConfig.pipelined(
    addressWidth = 32,
    dataWidth = 32).copy(
    useByteEnable = true,
    useResponse = true,
    maximumPendingReadTransactions = 1
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
  def getBmbParameter() = BmbParameter(
    addressWidth = 32,
    dataWidth = 32,
    lengthWidth = 2,
    sourceWidth = 0,
    contextWidth = 1,
    alignment     = BmbParameter.BurstAlignement.LENGTH
  )
}

case class DBusSimpleBus(bigEndian : Boolean = false) extends Bundle with IMasterSlave{
  val cmd = Stream(DBusSimpleCmd())
  val rsp = DBusSimpleRsp()

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }

  def cmdS2mPipe() : DBusSimpleBus = {
    val s = DBusSimpleBus(bigEndian)
    s.cmd    << this.cmd.s2mPipe()
    this.rsp := s.rsp
    s
  }

  def genMask(cmd : DBusSimpleCmd) = {
    if(bigEndian)
      cmd.size.mux(
        U(0) -> B"1000",
        U(1) -> B"1100",
        default -> B"1111"
      ) |>> cmd.address(1 downto 0)
    else
      cmd.size.mux(
        U(0) -> B"0001",
        U(1) -> B"0011",
        default -> B"1111"
      ) |<< cmd.address(1 downto 0)
  }

  def toAxi4Shared(stageCmd : Boolean = false, pendingWritesMax : Int = 7): Axi4Shared = {
    val axi = Axi4Shared(DBusSimpleBus.getAxi4Config())

    val cmdPreFork = if (stageCmd) cmd.stage.stage().s2mPipe() else cmd

    val pendingWrites = CounterUpDown(
      stateCount = pendingWritesMax + 1,
      incWhen = cmdPreFork.fire && cmdPreFork.wr,
      decWhen = axi.writeRsp.fire
    )

    val hazard = (pendingWrites =/= 0 && cmdPreFork.valid && !cmdPreFork.wr) || pendingWrites === pendingWritesMax
    val (cmdFork, dataFork) = StreamFork2(cmdPreFork.haltWhen(hazard))
    axi.sharedCmd.arbitrationFrom(cmdFork)
    axi.sharedCmd.write := cmdFork.wr
    axi.sharedCmd.prot := "010"
    axi.sharedCmd.cache := "1111"
    axi.sharedCmd.size := cmdFork.size.resized
    axi.sharedCmd.addr := cmdFork.address

    val dataStage = dataFork.throwWhen(!dataFork.wr)
    axi.writeData.arbitrationFrom(dataStage)
    axi.writeData.last := True
    axi.writeData.data := dataStage.data
    axi.writeData.strb := genMask(dataStage).resized


    rsp.ready := axi.r.valid
    rsp.error := !axi.r.isOKAY()
    rsp.data := axi.r.data

    axi.r.ready := True
    axi.b.ready := True
    axi
  }

  def toAxi4(stageCmd : Boolean = true) = this.toAxi4Shared(stageCmd).toAxi4()



  def toAvalon(stageCmd : Boolean = true): AvalonMM = {
    val avalonConfig = DBusSimpleBus.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)
    val cmdStage = if(stageCmd) cmd.stage else cmd
    mm.read := cmdStage.valid && !cmdStage.wr
    mm.write := cmdStage.valid && cmdStage.wr
    mm.address := (cmdStage.address >> 2) @@ U"00"
    mm.writeData := cmdStage.data(31 downto 0)
    mm.byteEnable := genMask(cmdStage).resized


    cmdStage.ready := mm.waitRequestn
    rsp.ready :=mm.readDataValid
    rsp.error := mm.response =/= AvalonMM.Response.OKAY
    rsp.data := mm.readData

    mm
  }

  def toWishbone(): Wishbone = {
    val wishboneConfig = DBusSimpleBus.getWishboneConfig()
    val bus = Wishbone(wishboneConfig)
    val cmdStage = cmd.halfPipe()

    bus.ADR := cmdStage.address >> 2
    bus.CTI :=B"000"
    bus.BTE := "00"
    bus.SEL := genMask(cmdStage).resized
    when(!cmdStage.wr) {
      bus.SEL := "1111"
    }
    bus.WE  := cmdStage.wr
    bus.DAT_MOSI := cmdStage.data

    cmdStage.ready := cmdStage.valid && bus.ACK
    bus.CYC := cmdStage.valid
    bus.STB := cmdStage.valid

    rsp.ready := cmdStage.valid && !bus.WE && bus.ACK
    rsp.data  := bus.DAT_MISO
    rsp.error := False //TODO
    bus
  }

  def toPipelinedMemoryBus() : PipelinedMemoryBus = {
    val pipelinedMemoryBusConfig = DBusSimpleBus.getPipelinedMemoryBusConfig()
    val bus = PipelinedMemoryBus(pipelinedMemoryBusConfig)
    bus.cmd.valid := cmd.valid
    bus.cmd.write := cmd.wr
    bus.cmd.address := cmd.address.resized
    bus.cmd.data := cmd.data
    bus.cmd.mask := genMask(cmd)
    cmd.ready := bus.cmd.ready

    rsp.ready := bus.rsp.valid
    rsp.data := bus.rsp.data

    bus
  }

  def toAhbLite3Master(avoidWriteToReadHazard : Boolean): AhbLite3Master = {
    val bus = AhbLite3Master(DBusSimpleBus.getAhbLite3Config())
    bus.HADDR     := this.cmd.address
    bus.HWRITE    := this.cmd.wr
    bus.HSIZE     := B(this.cmd.size, 3 bits)
    bus.HBURST    := 0
    bus.HPROT     := "1111"
    bus.HTRANS    := this.cmd.valid ## B"0"
    bus.HMASTLOCK := False
    bus.HWDATA    := RegNextWhen(this.cmd.data, bus.HREADY)
    this.cmd.ready := bus.HREADY

    val pending = RegInit(False) clearWhen(bus.HREADY) setWhen(this.cmd.fire && !this.cmd.wr)
    this.rsp.ready := bus.HREADY && pending
    this.rsp.data := bus.HRDATA
    this.rsp.error := bus.HRESP

    if(avoidWriteToReadHazard) {
      val writeDataPhase = RegNextWhen(bus.HTRANS === 2 && bus.HWRITE, bus.HREADY) init (False)
      val potentialHazard = this.cmd.valid && !this.cmd.wr && writeDataPhase
      when(potentialHazard) {
        bus.HTRANS := 0
        this.cmd.ready := False
      }
    }
    bus
  }
  
  def toBmb() : Bmb = {
    val pipelinedMemoryBusConfig = DBusSimpleBus.getBmbParameter()
    val bus = Bmb(pipelinedMemoryBusConfig)

    bus.cmd.valid := cmd.valid
    bus.cmd.last := True
    bus.cmd.context(0) := cmd.wr
    bus.cmd.opcode := (cmd.wr ? B(Bmb.Cmd.Opcode.WRITE) | B(Bmb.Cmd.Opcode.READ))
    bus.cmd.address := cmd.address.resized
    bus.cmd.data := cmd.data
    bus.cmd.length := cmd.size.mux(
      0       -> U"00",
      1       -> U"01",
      default -> U"11"
    )
    bus.cmd.mask := genMask(cmd)

    cmd.ready := bus.cmd.ready

    rsp.ready := bus.rsp.valid && !bus.rsp.context(0)
    rsp.data  := bus.rsp.data
    rsp.error := bus.rsp.isError
    bus.rsp.ready := True

    bus
  }
}


class DBusSimplePlugin(catchAddressMisaligned : Boolean = false,
                       catchAccessFault : Boolean = false,
                       earlyInjection : Boolean = false, /*, idempotentRegions : (UInt) => Bool = (x) => False*/
                       emitCmdInMemoryStage : Boolean = false,
                       onlyLoadWords : Boolean = false,
                       withLrSc : Boolean = false,
                       val bigEndian : Boolean = false,
                       memoryTranslatorPortConfig : Any = null) extends Plugin[VexRiscv] with DBusAccessService {

  var dBus  : DBusSimpleBus = null
  assert(!(emitCmdInMemoryStage && earlyInjection))
  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_READ_DATA extends Stageable(Bits(32 bits))
  object MEMORY_ADDRESS_LOW extends Stageable(UInt(2 bits))
  object ALIGNEMENT_FAULT extends Stageable(Bool)
  object MMU_FAULT extends Stageable(Bool)
  object MEMORY_ATOMIC extends Stageable(Bool)
  object ATOMIC_HIT extends Stageable(Bool)
  object MEMORY_STORE extends Stageable(Bool)

  var memoryExceptionPort : Flow[ExceptionCause] = null
  var rspStage : Stage = null
  var mmuBus : MemoryTranslatorBus = null
  var redoBranch : Flow[UInt] = null
  val catchSomething = catchAccessFault || catchAddressMisaligned || memoryTranslatorPortConfig != null

  @dontName var dBusAccess : DBusAccess = null
  override def newDBusAccess(): DBusAccess = {
    assert(dBusAccess == null)
    dBusAccess = DBusAccess()
    dBusAccess
  }

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    import pipeline._

    val decoderService = pipeline.service(classOf[DecoderService])

    val stdActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> False,
      MEMORY_ENABLE     -> True,
      RS1_USE          -> True
    ) ++ (if(catchAccessFault || catchAddressMisaligned) List(IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB) else Nil) //Used for access fault bad address in memory stage

    val loadActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> Bool(earlyInjection),
      MEMORY_STORE -> False,
      HAS_SIDE_EFFECT -> True
    )

    val storeActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMS,
      RS2_USE -> True,
      MEMORY_STORE -> True,
      HAS_SIDE_EFFECT -> True
    )

    decoderService.addDefault(MEMORY_ENABLE, False)
    decoderService.add(
      (if(onlyLoadWords) List(LW) else List(LB, LH, LW, LBU, LHU)).map(_ -> loadActions) ++
      List(SB, SH, SW).map(_ -> storeActions)
    )


    if(withLrSc){
      List(LB, LH, LW, LBU, LHU, SB, SH, SW).foreach(e =>
        decoderService.add(e, Seq(MEMORY_ATOMIC -> False))
      )
      decoderService.add(
        key = LR,
        values = loadActions.filter(_._1 != SRC2_CTRL) ++ Seq(
          SRC_ADD_ZERO -> True,
          MEMORY_ATOMIC -> True
        )
      )

      decoderService.add(
        key = SC,
        values = storeActions.filter(_._1 != SRC2_CTRL) ++ Seq(
          SRC_ADD_ZERO -> True,
          REGFILE_WRITE_VALID -> True,
          BYPASSABLE_EXECUTE_STAGE -> False,
          BYPASSABLE_MEMORY_STAGE -> False,
          MEMORY_ATOMIC -> True
        )
      )
    }

    decoderService.add(FENCE, Nil)

    rspStage = if(stages.last == execute) execute else (if(emitCmdInMemoryStage) writeBack else memory)
    if(catchSomething) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      memoryExceptionPort = exceptionService.newExceptionPort(rspStage)
    }

    if(memoryTranslatorPortConfig != null) {
      mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_DATA, memoryTranslatorPortConfig)
      redoBranch = pipeline.service(classOf[JumpService]).createJumpInterface(if(pipeline.memory != null) pipeline.memory else pipeline.execute)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    object MMU_RSP extends Stageable(MemoryTranslatorRsp(mmuBus.p))

    dBus = master(DBusSimpleBus(bigEndian)).setName("dBus")


    decode plug new Area {
      import decode._

      if(mmuBus != null) when(mmuBus.busy && arbitration.isValid && input(MEMORY_ENABLE)) {
        arbitration.haltItself := True
      }
    }

    //Emit dBus.cmd request
    val cmdSent =  if(rspStage == execute) RegInit(False) setWhen(dBus.cmd.fire) clearWhen(!execute.arbitration.isStuck) else False
    val cmdStage = if(emitCmdInMemoryStage) memory else execute
    cmdStage plug new Area{
      import cmdStage._
      val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())


      if (catchAddressMisaligned)
        insert(ALIGNEMENT_FAULT) := (dBus.cmd.size === 2 && dBus.cmd.address(1 downto 0) =/= 0) || (dBus.cmd.size === 1 && dBus.cmd.address(0 downto 0) =/= 0)
      else
        insert(ALIGNEMENT_FAULT) := False


      val skipCmd = False
      skipCmd setWhen(input(ALIGNEMENT_FAULT))

      dBus.cmd.valid := arbitration.isValid && input(MEMORY_ENABLE) && !arbitration.isStuckByOthers && !arbitration.isFlushed && !skipCmd && !cmdSent
      dBus.cmd.wr := input(MEMORY_STORE)
      dBus.cmd.size := input(INSTRUCTION)(13 downto 12).asUInt
      dBus.cmd.payload.data := dBus.cmd.size.mux (
        U(0) -> input(RS2)(7 downto 0) ## input(RS2)(7 downto 0) ## input(RS2)(7 downto 0) ## input(RS2)(7 downto 0),
        U(1) -> input(RS2)(15 downto 0) ## input(RS2)(15 downto 0),
        default -> input(RS2)(31 downto 0)
      )
      when(arbitration.isValid && input(MEMORY_ENABLE) && !dBus.cmd.ready && !skipCmd && !cmdSent){
        arbitration.haltItself := True
      }

      insert(MEMORY_ADDRESS_LOW) := dBus.cmd.address(1 downto 0)

      //formal
      val formalMask = dBus.genMask(dBus.cmd)

      insert(FORMAL_MEM_ADDR) := dBus.cmd.address & U"xFFFFFFFC"
      insert(FORMAL_MEM_WMASK) := (dBus.cmd.valid &&  dBus.cmd.wr) ? formalMask | B"0000"
      insert(FORMAL_MEM_RMASK) := (dBus.cmd.valid && !dBus.cmd.wr) ? formalMask | B"0000"
      insert(FORMAL_MEM_WDATA) := dBus.cmd.payload.data

      val mmu = (mmuBus != null) generate new Area {
        mmuBus.cmd.last.isValid := arbitration.isValid && input(MEMORY_ENABLE)
        mmuBus.cmd.last.isStuck := arbitration.isStuck
        mmuBus.cmd.last.virtualAddress := input(SRC_ADD).asUInt
        mmuBus.cmd.last.bypassTranslation := False
        mmuBus.end := !arbitration.isStuck || arbitration.isRemoved
        dBus.cmd.address := mmuBus.rsp.physicalAddress

        //do not emit memory request if MMU refilling
        insert(MMU_FAULT) := input(MMU_RSP).exception || (!input(MMU_RSP).allowWrite && input(MEMORY_STORE)) || (!input(MMU_RSP).allowRead && !input(MEMORY_STORE))
        skipCmd.setWhen(input(MMU_FAULT) || input(MMU_RSP).refilling)

        insert(MMU_RSP) := mmuBus.rsp
      }

      val mmuLess = (mmuBus == null) generate new Area{
        dBus.cmd.address := input(SRC_ADD).asUInt
      }


      val atomic = withLrSc generate new Area{
        val reserved = RegInit(False)
        insert(ATOMIC_HIT) := reserved
        when(arbitration.isFiring &&  input(MEMORY_ENABLE) && (if(mmuBus != null) !input(MMU_FAULT) else True) && !skipCmd){
          reserved setWhen(input(MEMORY_ATOMIC))
          reserved clearWhen(input(MEMORY_STORE))
        }
        when(input(MEMORY_STORE) && input(MEMORY_ATOMIC) && !input(ATOMIC_HIT)){
          skipCmd := True
        }
      }
    }

    //Collect dBus.rsp read responses
    rspStage plug new Area {
      val s = rspStage; import s._


      insert(MEMORY_READ_DATA) := dBus.rsp.data

      arbitration.haltItself setWhen(arbitration.isValid && input(MEMORY_ENABLE) && !input(MEMORY_STORE) && (!dBus.rsp.ready || (if(rspStage == execute) !cmdSent else False)))

      if(catchSomething) {
        memoryExceptionPort.valid := False
        memoryExceptionPort.code.assignDontCare()
        memoryExceptionPort.badAddr := input(REGFILE_WRITE_DATA).asUInt

        if(catchAccessFault) when(dBus.rsp.ready && dBus.rsp.error && !input(MEMORY_STORE)) {
          memoryExceptionPort.valid := True
          memoryExceptionPort.code := 5
        }

        if(catchAddressMisaligned) when(input(ALIGNEMENT_FAULT)){
          memoryExceptionPort.code := (input(MEMORY_STORE) ? U(6) | U(4)).resized
          memoryExceptionPort.valid := True
        }

        if(memoryTranslatorPortConfig != null) {
          redoBranch.valid := False
          redoBranch.payload := input(PC)

          when(input(MMU_RSP).refilling){
            redoBranch.valid := True
            memoryExceptionPort.valid := False
          } elsewhen(input(MMU_FAULT)) {
            memoryExceptionPort.valid := True
            memoryExceptionPort.code := (input(MEMORY_STORE) ? U(15) | U(13)).resized
          }

          arbitration.flushIt setWhen(redoBranch.valid)
          arbitration.flushNext setWhen(redoBranch.valid)
        }

        when(!(arbitration.isValid && input(MEMORY_ENABLE) && (Bool(cmdStage != rspStage) || !arbitration.isStuckByOthers))){
          if(catchSomething) memoryExceptionPort.valid := False
          if(memoryTranslatorPortConfig != null) redoBranch.valid := False
        }

      }
    }

    //Reformat read responses, REGFILE_WRITE_DATA overriding
    val injectionStage = if(earlyInjection) memory else stages.last
    injectionStage plug new Area {
      import injectionStage._


      val rspShifted = MEMORY_READ_DATA()
      rspShifted := input(MEMORY_READ_DATA)
      if(bigEndian)
        switch(input(MEMORY_ADDRESS_LOW)){
          is(1){rspShifted(31 downto 24) := input(MEMORY_READ_DATA)(23 downto 16)}
          is(2){rspShifted(31 downto 16) := input(MEMORY_READ_DATA)(15 downto 0)}
          is(3){rspShifted(31 downto 24) := input(MEMORY_READ_DATA)(7 downto 0)}
        }
      else
        switch(input(MEMORY_ADDRESS_LOW)){
          is(1){rspShifted(7 downto 0) := input(MEMORY_READ_DATA)(15 downto 8)}
          is(2){rspShifted(15 downto 0) := input(MEMORY_READ_DATA)(31 downto 16)}
          is(3){rspShifted(7 downto 0) := input(MEMORY_READ_DATA)(31 downto 24)}
        }

      val rspFormated =
        if(bigEndian)
          input(INSTRUCTION)(13 downto 12).mux(
                0 -> B((31 downto 8) -> (rspShifted(31) && !input(INSTRUCTION)(14)),(7 downto 0) -> rspShifted(31 downto 24)),
                1 -> B((31 downto 16) -> (rspShifted(31) && ! input(INSTRUCTION)(14)),(15 downto 0) -> rspShifted(31 downto 16)),
                default -> rspShifted //W
          )
        else
          input(INSTRUCTION)(13 downto 12).mux(
                0 -> B((31 downto 8) -> (rspShifted(7) && !input(INSTRUCTION)(14)),(7 downto 0) -> rspShifted(7 downto 0)),
                1 -> B((31 downto 16) -> (rspShifted(15) && ! input(INSTRUCTION)(14)),(15 downto 0) -> rspShifted(15 downto 0)),
                default -> rspShifted //W
          )

      when(arbitration.isValid && input(MEMORY_ENABLE)) {
        output(REGFILE_WRITE_DATA) := (if(!onlyLoadWords) rspFormated else input(MEMORY_READ_DATA))
        if(withLrSc){
          when(input(MEMORY_ATOMIC) && input(MEMORY_STORE)){
            output(REGFILE_WRITE_DATA)  := (!input(ATOMIC_HIT)).asBits.resized
          }
        }
      }

//      if(!earlyInjection && !emitCmdInMemoryStage && config.withWriteBackStage)
//        assert(!(arbitration.isValid && input(MEMORY_ENABLE) && !input(MEMORY_STORE) && arbitration.isStuck),"DBusSimplePlugin doesn't allow writeback stage stall when read happend")

      //formal
      insert(FORMAL_MEM_RDATA) := input(MEMORY_READ_DATA)
    }

    //Share access to the dBus (used by self refilled MMU)
    val dBusSharing = (dBusAccess != null) generate new Area{
      val state = Reg(UInt(2 bits)) init(0)
      dBusAccess.cmd.ready := False
      dBusAccess.rsp.valid := False
      dBusAccess.rsp.data := dBus.rsp.data
      dBusAccess.rsp.error := dBus.rsp.error
      dBusAccess.rsp.redo := False

      switch(state){
        is(0){
          when(dBusAccess.cmd.valid){
            decode.arbitration.haltItself := True
            when(!stages.dropWhile(_ != execute).map(_.arbitration.isValid).orR){
              state := 1
            }
          }
        }
        is(1){
          decode.arbitration.haltItself := True
          dBus.cmd.valid := True
          dBus.cmd.address := dBusAccess.cmd.address
          dBus.cmd.wr := dBusAccess.cmd.write
          dBus.cmd.data := dBusAccess.cmd.data
          dBus.cmd.size := dBusAccess.cmd.size
          when(dBus.cmd.ready){
            state := (dBusAccess.cmd.write ? U(0) | U(2))
            dBusAccess.cmd.ready := True
          }
        }
        is(2){
          decode.arbitration.haltItself := True
          when(dBus.rsp.ready){
            dBusAccess.rsp.valid := True
            state := 0
          }
        }
      }
    }
  }
}
