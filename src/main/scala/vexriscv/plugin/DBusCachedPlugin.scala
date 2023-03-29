package vexriscv.plugin

import vexriscv.ip._
import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.Axi4
import spinal.lib.bus.misc.SizeMapping

import scala.collection.mutable.ArrayBuffer


class DAxiCachedPlugin(config : DataCacheConfig, memoryTranslatorPortConfig : Any = null) extends DBusCachedPlugin(config, memoryTranslatorPortConfig) {
  var dAxi  : Axi4 = null

  override def build(pipeline: VexRiscv): Unit = {
    super.build(pipeline)
    dBus.setAsDirectionLess()
    dAxi = master(dBus.toAxi4Shared().toAxi4()).setName("dAxi")
    dBus = null //For safety, as nobody should use it anymore :)
  }
}

trait DBusEncodingService {
  def addLoadWordEncoding(key: MaskedLiteral): Unit
  def addStoreWordEncoding(key: MaskedLiteral): Unit
  def bypassStore(data : Bits) : Unit
  def loadData() : Bits
}


case class TightlyCoupledDataBus() extends Bundle with IMasterSlave {
  val enable = Bool()
  val address = UInt(32 bits)
  val write_enable = Bool()
  val write_data = Bits(32 bits)
  val write_mask = Bits(4 bits)
  val read_data = Bits(32 bits)

  override def asMaster(): Unit = {
    out(enable, address, write_enable, write_data, write_mask)
    in(read_data)
  }
}

case class TightlyCoupledDataPortParameter(name : String, hit : UInt => Bool)
case class TightlyCoupledDataPort(p : TightlyCoupledDataPortParameter, var bus : TightlyCoupledDataBus)

class DBusCachedPlugin(val config : DataCacheConfig,
                       memoryTranslatorPortConfig : Any = null,
                       var dBusCmdMasterPipe : Boolean = false,
                       dBusCmdSlavePipe : Boolean = false,
                       dBusRspSlavePipe : Boolean = false,
                       relaxedMemoryTranslationRegister : Boolean = false,
                       csrInfo : Boolean = false,
                       tightlyCoupledAddressStage : Boolean = false)  extends Plugin[VexRiscv] with DBusAccessService with DBusEncodingService with VexRiscvRegressionArg {
  import config._
  assert(!(config.withExternalAmo && !dBusRspSlavePipe))
  assert(isPow2(cacheSize))
  assert(!(memoryTranslatorPortConfig != null && config.cacheSize/config.wayCount > 4096), "When the D$ is used with MMU, each way can't be bigger than a page (4096 bytes)")

  var dBus  : DataCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var exceptionBus : Flow[ExceptionCause] = null
  var privilegeService : PrivilegeService = null
  var redoBranch : Flow[UInt] = null

  @dontName var dBusAccess : DBusAccess = null
  override def newDBusAccess(): DBusAccess = {
    assert(dBusAccess == null)
    dBusAccess = DBusAccess()
    dBusAccess
  }

  override def getVexRiscvRegressionArgs(): Seq[String] = {
    var args = List[String]()
    args :+= "DBUS=CACHED"
    args :+= s"DBUS_LOAD_DATA_WIDTH=$memDataWidth"
    args :+= s"DBUS_STORE_DATA_WIDTH=$cpuDataWidth"
    if(withLrSc) args :+= "LRSC=yes"
    if(withAmo)  args :+= "AMO=yes"
    if(config.withExclusive && config.withInvalidate)  args ++= List("DBUS_EXCLUSIVE=yes", "DBUS_INVALIDATE=yes")
    args
  }

  val tightlyCoupledPorts = ArrayBuffer[TightlyCoupledDataPort]()
  def tightlyGen = tightlyCoupledPorts.nonEmpty

  def newTightlyCoupledPort(mapping : UInt => Bool) = {
    val port = TightlyCoupledDataPort(TightlyCoupledDataPortParameter(null, mapping), TightlyCoupledDataBus())
    tightlyCoupledPorts += port
    port.bus
  }

  override def addLoadWordEncoding(key : MaskedLiteral): Unit = {
    val decoderService = pipeline.service(classOf[DecoderService])
    val cfg = pipeline.config
    import cfg._

    decoderService.add(
      key,
      List(
        SRC1_CTRL         -> Src1CtrlEnum.RS,
        SRC_USE_SUB_LESS  -> False,
        MEMORY_ENABLE     -> True,
        RS1_USE          -> True,
        IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB,
        SRC2_CTRL -> Src2CtrlEnum.IMI,
        //        REGFILE_WRITE_VALID -> True,
        //        BYPASSABLE_EXECUTE_STAGE -> False,
        //        BYPASSABLE_MEMORY_STAGE -> False,
        MEMORY_WR -> False,
        HAS_SIDE_EFFECT -> True
      )
    )

    if(withLrSc) decoderService.add(key, Seq(MEMORY_LRSC -> False))
    if(withAmo)  decoderService.add(key, Seq(MEMORY_AMO -> False))
  }
  override def addStoreWordEncoding(key : MaskedLiteral): Unit = {
    val decoderService = pipeline.service(classOf[DecoderService])
    val cfg = pipeline.config
    import cfg._

    decoderService.add(
      key,
      List(
        SRC1_CTRL         -> Src1CtrlEnum.RS,
        SRC_USE_SUB_LESS  -> False,
        MEMORY_ENABLE     -> True,
        RS1_USE          -> True,
        IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB,
        SRC2_CTRL -> Src2CtrlEnum.IMS,
//        RS2_USE -> True,
        MEMORY_WR -> True,
        HAS_SIDE_EFFECT -> True
      )
    )

    if(withLrSc) decoderService.add(key, Seq(MEMORY_LRSC -> False))
    if(withAmo)  decoderService.add(key, Seq(MEMORY_AMO -> False))
  }

  val bypassStoreList = ArrayBuffer[(Bool, Bits)]()

  override def bypassStore(data: Bits): Unit = {
    val prefix = s"DBusBypass${bypassStoreList.size}"
    bypassStoreList += ConditionalContext.isTrue().setName(prefix + "_cond") -> CombInit(data).setName(prefix + "_value")
    assert(config.cpuDataWidth >= data.getWidth, "Data cache word width is too small for that")
  }


  override def loadData(): Bits = pipeline.stages.last.output(MEMORY_LOAD_DATA)

  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_MANAGMENT extends Stageable(Bool)
  object MEMORY_WR extends Stageable(Bool)
  object MEMORY_TIGHTLY extends Stageable(Bits(tightlyCoupledPorts.size bits))
  object MEMORY_TIGHTLY_DATA extends Stageable(Bits(32 bits))
  object MEMORY_LRSC extends Stageable(Bool)
  object MEMORY_AMO extends Stageable(Bool)
  object MEMORY_FENCE extends Stageable(Bool)
  object MEMORY_FENCE_WR extends Stageable(Bool)
  object MEMORY_FORCE_CONSTISTENCY extends Stageable(Bool)
  object IS_DBUS_SHARING extends Stageable(Bool())
  object MEMORY_VIRTUAL_ADDRESS extends Stageable(UInt(32 bits))
  object MEMORY_STORE_DATA_RF extends Stageable(Bits(32 bits))
//  object MEMORY_STORE_DATA_CPU extends Stageable(Bits(config.cpuDataWidth bits))
  object MEMORY_LOAD_DATA extends Stageable(Bits(config.cpuDataWidth bits))

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    dBus = master(DataCacheMemBus(this.config)).setName("dBus")

    val decoderService = pipeline.service(classOf[DecoderService])

    val stdActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> False,
      MEMORY_ENABLE     -> True,
      RS1_USE          -> True,
      IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB
    )

    val loadActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE -> False,
      MEMORY_WR -> False,
      HAS_SIDE_EFFECT -> True
    )

    val storeActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMS,
      RS2_USE -> True,
      MEMORY_WR -> True,
      HAS_SIDE_EFFECT -> True
    )

    decoderService.addDefault(MEMORY_ENABLE, False)
    decoderService.add(
      List(LB, LH, LW, LBU, LHU).map(_ -> loadActions) ++
      List(SB, SH, SW).map(_ -> storeActions)
    )

    if(withLrSc){
      List(LB, LH, LW, LBU, LHU, SB, SH, SW).foreach(e =>
        decoderService.add(e, Seq(MEMORY_LRSC -> False))
      )
      decoderService.add(
        key = LR,
        values = loadActions.filter(_._1 != SRC2_CTRL) ++ Seq(
          SRC_ADD_ZERO -> True,
          MEMORY_LRSC -> True
        )
      )
      decoderService.add(
        key = SC,
        values = storeActions.filter(_._1 != SRC2_CTRL) ++ Seq(
          SRC_ADD_ZERO -> True,
          REGFILE_WRITE_VALID -> True,
          BYPASSABLE_EXECUTE_STAGE -> False,
          BYPASSABLE_MEMORY_STAGE -> False,
          MEMORY_LRSC -> True
        )
      )
    }

    if(withAmo){
      List(LB, LH, LW, LBU, LHU, SB, SH, SW).foreach(e =>
        decoderService.add(e, Seq(MEMORY_AMO -> False))
      )
      val amoActions = storeActions.filter(_._1 != SRC2_CTRL) ++ Seq(
        SRC_ADD_ZERO -> True,
        REGFILE_WRITE_VALID -> True,
        BYPASSABLE_EXECUTE_STAGE -> False,
        BYPASSABLE_MEMORY_STAGE -> False,
        MEMORY_AMO -> True
      )

      for(i <- List(AMOSWAP, AMOADD, AMOXOR, AMOAND, AMOOR, AMOMIN, AMOMAX, AMOMINU, AMOMAXU)){
        decoderService.add(i, amoActions)
      }
    }

    if(withAmo && withLrSc){
      for(i <- List(AMOSWAP, AMOADD, AMOXOR, AMOAND, AMOOR, AMOMIN, AMOMAX, AMOMINU, AMOMAXU)){
        decoderService.add(i, List(MEMORY_LRSC -> False))
      }
      for(i <- List(LR, SC)){
        decoderService.add(i, List(MEMORY_AMO -> False))
      }
    }

    def MANAGEMENT  = M"-------00000-----101-----0001111"

    decoderService.addDefault(MEMORY_MANAGMENT, False)
    decoderService.add(MANAGEMENT, List(
      MEMORY_MANAGMENT -> True,
      RS1_USE -> True
    ))

    withWriteResponse match {
      case false => decoderService.add(FENCE, Nil)
      case true => {
        decoderService.addDefault(MEMORY_FENCE, False)
        decoderService.add(FENCE, List(MEMORY_FENCE -> True))
        decoderService.addDefault(MEMORY_FENCE_WR, False)
        decoderService.add(FENCE_I, List(MEMORY_FENCE_WR -> True))
      }
    }

    mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_DATA ,memoryTranslatorPortConfig)
    redoBranch = pipeline.service(classOf[JumpService]).createJumpInterface(if(pipeline.writeBack != null) pipeline.writeBack else pipeline.memory)

    if(catchSomething)
      exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(if(pipeline.writeBack == null) pipeline.memory else pipeline.writeBack)

    if(pipeline.serviceExist(classOf[PrivilegeService]))
      privilegeService = pipeline.service(classOf[PrivilegeService])

    pipeline.update(DEBUG_BYPASS_CACHE, False)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val twoStageMmu = mmuBus.p.latency match {
      case 0 => false
      case 1 => true
    }

    val cache = new DataCache(
      this.config.copy(
        mergeExecuteMemory = writeBack == null,
        rfDataWidth = 32
      ),
      mmuParameter = mmuBus.p
    )

    //Interconnect the plugin dBus with the cache dBus with some optional pipelining
    def optionPipe[T](cond : Boolean, on : T)(f : T => T) : T = if(cond) f(on) else on
    def cmdBuf = optionPipe(dBusCmdSlavePipe, cache.io.mem.cmd)(_.s2mPipe())
    dBus.cmd << optionPipe(dBusCmdMasterPipe, cmdBuf)(_.m2sPipe())
    cache.io.mem.rsp << (dBusRspSlavePipe match {
      case false => dBus.rsp
      case true if !withExternalAmo => dBus.rsp.m2sPipe()
      case true if  withExternalAmo => {
        val rsp = Flow (DataCacheMemRsp(cache.p))
        rsp.valid := RegNext(dBus.rsp.valid) init(False)
        rsp.exclusive := RegNext(dBus.rsp.exclusive)
        rsp.error := RegNext(dBus.rsp.error)
        rsp.last := RegNext(dBus.rsp.last)
        rsp.aggregated := RegNext(dBus.rsp.aggregated)
        rsp.data := RegNextWhen(dBus.rsp.data, dBus.rsp.valid && !cache.io.cpu.writeBack.keepMemRspData)
        rsp
      }
    })

    if(withInvalidate) {
      cache.io.mem.inv  << dBus.inv
      cache.io.mem.ack  >> dBus.ack
      cache.io.mem.sync << dBus.sync
    }

    pipeline plug new Area{
      //Memory bandwidth counter
      val rspCounter = Reg(UInt(32 bits)) init(0)
      when(dBus.rsp.valid){
        rspCounter := rspCounter + 1
      }
    }

    decode plug new Area {
      import decode._

      when(mmuBus.busy && arbitration.isValid && input(MEMORY_ENABLE)) {
        arbitration.haltItself := True
      }


      //Manage write to read hit ordering (ensure invalidation timings)
      val fence = new Area {
        insert(MEMORY_FORCE_CONSTISTENCY) := False
        when(input(INSTRUCTION)(25)) { //RL
          if (withLrSc) insert(MEMORY_FORCE_CONSTISTENCY) setWhen (input(MEMORY_LRSC))
          if (withAmo) insert(MEMORY_FORCE_CONSTISTENCY) setWhen (input(MEMORY_AMO))
        }
      }
    }

    execute plug new Area {
      import execute._

      val size = input(INSTRUCTION)(13 downto 12).asUInt
      cache.io.cpu.execute.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.execute.address := input(SRC_ADD).asUInt
      cache.io.cpu.execute.args.wr := input(MEMORY_WR)
      insert(MEMORY_STORE_DATA_RF) := size.mux(
        U(0)    -> input(RS2)( 7 downto 0) ## input(RS2)( 7 downto 0) ## input(RS2)(7 downto 0) ## input(RS2)(7 downto 0),
        U(1)    -> input(RS2)(15 downto 0) ## input(RS2)(15 downto 0),
        default -> input(RS2)(31 downto 0)
      )
      cache.io.cpu.execute.args.size := size.resized

      if(twoStageMmu) {
        mmuBus.cmd(0).isValid := cache.io.cpu.execute.isValid
        mmuBus.cmd(0).isStuck := arbitration.isStuck
        mmuBus.cmd(0).virtualAddress := input(SRC_ADD).asUInt
        mmuBus.cmd(0).bypassTranslation := False
//        KeepAttribute(mmuBus.cmd(0))
//        KeepAttribute(mmuBus.cmd(1))
      }

      cache.io.cpu.flush.valid := arbitration.isValid && input(MEMORY_MANAGMENT)
      cache.io.cpu.flush.singleLine := input(INSTRUCTION)(Riscv.rs1Range) =/= 0
      cache.io.cpu.flush.lineId := U(input(RS1) >> log2Up(bytePerLine)).resized
      cache.io.cpu.execute.args.totalyConsistent := input(MEMORY_FORCE_CONSTISTENCY)
      arbitration.haltItself setWhen(cache.io.cpu.flush.isStall || cache.io.cpu.execute.haltIt)

      if(withLrSc) {
        cache.io.cpu.execute.args.isLrsc := False
        when(input(MEMORY_LRSC)){
          cache.io.cpu.execute.args.isLrsc := True
        }
      }

      if(withAmo){
        cache.io.cpu.execute.isAmo := input(MEMORY_AMO)
        cache.io.cpu.execute.amoCtrl.alu := input(INSTRUCTION)(31 downto 29)
        cache.io.cpu.execute.amoCtrl.swap := input(INSTRUCTION)(27)
      }


      when(cache.io.cpu.execute.refilling && arbitration.isValid){
        arbitration.haltByOther := True
      }

      if(relaxedMemoryTranslationRegister) {
        insert(MEMORY_VIRTUAL_ADDRESS) := cache.io.cpu.execute.address
        memory.input(MEMORY_VIRTUAL_ADDRESS)
        if(writeBack != null) addPrePopTask( () =>
          KeepAttribute(memory.input(MEMORY_VIRTUAL_ADDRESS).getDrivingReg())
        )
      }

      if(withWriteResponse){
        when(arbitration.isValid && input(MEMORY_FENCE_WR) && cache.io.cpu.writesPending){
          arbitration.haltItself := True
        }
      }

      if(tightlyGen){
        tightlyCoupledAddressStage match {
          case false =>
          case true => {
            val go = RegInit(False) setWhen(arbitration.isValid) clearWhen(!arbitration.isStuck)
            arbitration.haltItself.setWhen(arbitration.isValid && input(MEMORY_ENABLE) && input(MEMORY_TIGHTLY).orR && !go)
          }
        }

        insert(MEMORY_TIGHTLY) := B(tightlyCoupledPorts.map(_.p.hit(input(SRC_ADD).asUInt)))
        when(insert(MEMORY_TIGHTLY).orR){
          cache.io.cpu.execute.isValid := False
          arbitration.haltItself setWhen(stages.dropWhile(_ != execute).tail.map(s => s.arbitration.isValid && s.input(HAS_SIDE_EFFECT)).orR)
        }
        for((port, sel) <- (tightlyCoupledPorts, input(MEMORY_TIGHTLY).asBools).zipped){
          port.bus.enable       := arbitration.isValid && input(MEMORY_ENABLE) && sel && !arbitration.isStuck

          port.bus.address      := Delay(input(SRC_ADD), tightlyCoupledAddressStage.toInt).asUInt.resized
          port.bus.write_enable := input(MEMORY_WR)
          port.bus.write_data   := input(MEMORY_STORE_DATA_RF)
          port.bus.write_mask   := size.mux (
            U(0)    -> B"0001",
            U(1)    -> B"0011",
            default -> B"1111"
          ) |<< port.bus.address(1 downto 0)
        }
      }
    }

    val mmuAndBufferStage = if(writeBack != null) memory else execute
    mmuAndBufferStage plug new Area {
      import mmuAndBufferStage._

      cache.io.cpu.memory.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.memory.isStuck := arbitration.isStuck
      cache.io.cpu.memory.address := (if(relaxedMemoryTranslationRegister) input(MEMORY_VIRTUAL_ADDRESS) else if(mmuAndBufferStage == execute) cache.io.cpu.execute.address else U(input(REGFILE_WRITE_DATA)))

      mmuBus.cmd.last.isValid := cache.io.cpu.memory.isValid
      mmuBus.cmd.last.isStuck := cache.io.cpu.memory.isStuck
      mmuBus.cmd.last.virtualAddress := cache.io.cpu.memory.address
      mmuBus.cmd.last.bypassTranslation := False
      mmuBus.end := !arbitration.isStuck || arbitration.removeIt
      cache.io.cpu.memory.mmuRsp := mmuBus.rsp
      cache.io.cpu.memory.mmuRsp.isIoAccess setWhen(pipeline(DEBUG_BYPASS_CACHE) && !cache.io.cpu.memory.isWrite)

      if(tightlyGen){
        when(input(MEMORY_TIGHTLY).orR){
          cache.io.cpu.memory.isValid := False
          input(HAS_SIDE_EFFECT) := False
        }
        insert(MEMORY_TIGHTLY_DATA) := OhMux(input(MEMORY_TIGHTLY), tightlyCoupledPorts.map(_.bus.read_data))
        KeepAttribute(insert(MEMORY_TIGHTLY_DATA))      }
    }

    val managementStage = stages.last
    val mgs = managementStage plug new Area{
      import managementStage._
      cache.io.cpu.writeBack.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.writeBack.isStuck := arbitration.isStuck
      cache.io.cpu.writeBack.isFiring := arbitration.isFiring
      cache.io.cpu.writeBack.isUser  := (if(privilegeService != null) privilegeService.isUser() else False)
      cache.io.cpu.writeBack.address := U(input(REGFILE_WRITE_DATA))
      cache.io.cpu.writeBack.storeData.subdivideIn(32 bits).foreach(_ := input(MEMORY_STORE_DATA_RF))
      afterElaboration(for((cond, value) <- bypassStoreList) when(cond){
        cache.io.cpu.writeBack.storeData.subdivideIn(widthOf(value) bits).foreach(_ := value) //Not optimal, but ok
      })

      val fence = if(withInvalidate) new Area {
        cache.io.cpu.writeBack.fence := input(INSTRUCTION)(31 downto 20).as(FenceFlags())
        val aquire = False
        if(withWriteResponse) when(input(MEMORY_ENABLE) && input(INSTRUCTION)(26)) { //AQ
          if(withLrSc) when(input(MEMORY_LRSC)){
            aquire := True
          }
          if(withAmo) when(input(MEMORY_AMO)){
            aquire := True
          }
        }

        when(aquire){
          cache.io.cpu.writeBack.fence.forceAll()
        }

        when(!input(MEMORY_FENCE) || !arbitration.isFiring){
          cache.io.cpu.writeBack.fence.clearAll()
        }

        when(arbitration.isValid && (input(MEMORY_FENCE) || aquire)){
          mmuAndBufferStage.arbitration.haltByOther := True //Ensure that the fence affect the memory stage instruction by stoping it
        }
      }

      redoBranch.valid := False
      redoBranch.payload := input(PC)
      arbitration.flushIt setWhen(redoBranch.valid)
      arbitration.flushNext setWhen(redoBranch.valid)

      if(catchSomething) {
        exceptionBus.valid := False //cache.io.cpu.writeBack.mmuMiss || cache.io.cpu.writeBack.accessError || cache.io.cpu.writeBack.illegalAccess || cache.io.cpu.writeBack.unalignedAccess
        exceptionBus.badAddr := U(input(REGFILE_WRITE_DATA))
        exceptionBus.code.assignDontCare()
      }


      when(arbitration.isValid && input(MEMORY_ENABLE)) {
        if (catchAccessError) when(cache.io.cpu.writeBack.accessError) {
          exceptionBus.valid := True
          exceptionBus.code := (input(MEMORY_WR) ? U(7) | U(5)).resized
        }
        if(catchIllegal) when (cache.io.cpu.writeBack.mmuException) {
          exceptionBus.valid := True
          exceptionBus.code := (input(MEMORY_WR) ? U(15) | U(13)).resized
        }
        if (catchUnaligned) when(cache.io.cpu.writeBack.unalignedAccess) {
          exceptionBus.valid := True
          exceptionBus.code := (input(MEMORY_WR) ? U(6) | U(4)).resized
        }

        when(cache.io.cpu.redo) {
          redoBranch.valid := True
          if(catchSomething) exceptionBus.valid := False
        }
      }

      arbitration.haltItself.setWhen(cache.io.cpu.writeBack.isValid && cache.io.cpu.writeBack.haltIt)

      val rspData = CombInit(cache.io.cpu.writeBack.data)
      val rspSplits = rspData.subdivideIn(8 bits)
      val rspShifted = Bits(cpuDataWidth bits)
      //Generate minimal mux to move from a wide aligned memory read to the register file shifter representation
      for(i <- 0 until cpuDataWidth/8){
        val srcSize = 1 << (log2Up(cpuDataBytes) - log2Up(i+1))
        val srcZipped = rspSplits.zipWithIndex.filter{case (v, b) => b % (cpuDataBytes/srcSize) == i}
        val src = srcZipped.map(_._1)
        val range = cache.cpuWordToRfWordRange.high downto cache.cpuWordToRfWordRange.high+1-log2Up(srcSize)
        val sel = cache.io.cpu.writeBack.address(range)
//        println(s"$i $srcSize $range ${srcZipped.map(_._2).mkString(",")}")
        rspShifted(i*8, 8 bits) := src.read(sel)
      }

      val rspRf = CombInit(rspShifted(31 downto 0))
      if(withLrSc) when(input(MEMORY_LRSC) && input(MEMORY_WR)){
        rspRf := B(!cache.io.cpu.writeBack.exclusiveOk).resized
      }

      val rspFormated = input(INSTRUCTION)(13 downto 12).mux(
        0 -> B((31 downto 8) -> (rspRf(7) && !input(INSTRUCTION)(14)),(7 downto 0) -> rspRf(7 downto 0)),
        1 -> B((31 downto 16) -> (rspRf(15) && ! input(INSTRUCTION)(14)),(15 downto 0) -> rspRf(15 downto 0)),
        default -> rspRf //W
      )

      when(arbitration.isValid && input(MEMORY_ENABLE)) {
        output(REGFILE_WRITE_DATA) := rspFormated
      }

      insert(MEMORY_LOAD_DATA) := rspShifted

      if(tightlyGen){
        when(input(MEMORY_TIGHTLY).orR){
          cache.io.cpu.writeBack.isValid := False
          exceptionBus.valid := False
          redoBranch.valid := False
          rspData := input(MEMORY_TIGHTLY_DATA)
          input(HAS_SIDE_EFFECT) := False
        }
      }
    }

    //Share access to the dBus (used by self refilled MMU)
    if(dBusAccess != null) pipeline plug new Area{
      dBusAccess.cmd.ready := False
      val forceDatapath = False
      when(dBusAccess.cmd.valid){
        decode.arbitration.haltByOther := True
        val exceptionService = pipeline.service(classOf[ExceptionService])
        when(!stagesFromExecute.map(s => s.arbitration.isValid || exceptionService.isExceptionPending(s)).orR){
          when(!cache.io.cpu.execute.refilling) {
            cache.io.cpu.execute.isValid := True
            dBusAccess.cmd.ready := !execute.arbitration.isStuck
          }
          cache.io.cpu.execute.args.wr := False                         //dBusAccess.cmd.write
//          execute.insert(MEMORY_STORE_DATA_RF) := dBusAccess.cmd.data //Not implemented
          cache.io.cpu.execute.args.size := dBusAccess.cmd.size.resized
          if(withLrSc) execute.input(MEMORY_LRSC) := False
          if(withAmo)  execute.input(MEMORY_AMO) := False
          cache.io.cpu.execute.address := dBusAccess.cmd.address  //Will only be 12 muxes
          forceDatapath := True
        }
      }
      execute.insert(IS_DBUS_SHARING) := dBusAccess.cmd.fire
      mmuBus.cmd.last.bypassTranslation setWhen(mmuAndBufferStage.input(IS_DBUS_SHARING))
      if(twoStageMmu) mmuBus.cmd(0).bypassTranslation setWhen(execute.input(IS_DBUS_SHARING))

      if(mmuAndBufferStage != execute) (cache.io.cpu.memory.isValid setWhen(mmuAndBufferStage.input(IS_DBUS_SHARING)))
      cache.io.cpu.writeBack.isValid setWhen(managementStage.input(IS_DBUS_SHARING))
      dBusAccess.rsp.valid := managementStage.input(IS_DBUS_SHARING) && !cache.io.cpu.writeBack.isWrite && (cache.io.cpu.redo || !cache.io.cpu.writeBack.haltIt)
      dBusAccess.rsp.data := mgs.rspRf
      dBusAccess.rsp.error := cache.io.cpu.writeBack.unalignedAccess || cache.io.cpu.writeBack.accessError
      dBusAccess.rsp.redo := cache.io.cpu.redo
      component.addPrePopTask{() =>
        managementStage.input(IS_DBUS_SHARING).getDrivingReg() clearWhen(dBusAccess.rsp.fire)
        when(forceDatapath){
          execute.output(REGFILE_WRITE_DATA) := dBusAccess.cmd.address.asBits
        }
        if(mmuAndBufferStage != execute) mmuAndBufferStage.input(IS_DBUS_SHARING) init(False)
        managementStage.input(IS_DBUS_SHARING) init(False)
        when(dBusAccess.rsp.valid){
          managementStage.input(IS_DBUS_SHARING).getDrivingReg() := False
        }
      }
    }

    when(stages.last.arbitration.haltByOther){
      cache.io.cpu.writeBack.isValid := False
    }

    if(csrInfo){
      val csr = service(classOf[CsrPlugin])
      csr.r(0xCC0, 0 ->  U(cacheSize/wayCount),  20 ->  U(bytePerLine))
    }
  }
}


class IBusDBusCachedTightlyCoupledRam(mapping : SizeMapping, withIBus : Boolean = true, withDBus : Boolean = true) extends Plugin[VexRiscv]{
  var dbus : TightlyCoupledDataBus = null
  var ibus : TightlyCoupledBus = null

  override def setup(pipeline: VexRiscv) = {
    if(withDBus) {
      dbus = pipeline.service(classOf[DBusCachedPlugin]).newTightlyCoupledPort(addr => mapping.hit(addr))
      dbus.setCompositeName(this, "dbus").setAsDirectionLess()
    }

    if(withIBus){
      ibus = pipeline.service(classOf[IBusCachedPlugin]).newTightlyCoupledPortV2(
        TightlyCoupledPortParameter(
          name = "tightlyCoupledIbus",
          hit = addr => mapping.hit(addr)
        )
      )
      ibus.setCompositeName(this, "ibus").setAsDirectionLess()
    }
  }

  override def build(pipeline: VexRiscv) = {
    val logic = pipeline plug new Area {
      val ram = Mem(Bits(32 bits), mapping.size.toInt/4)
      ram.generateAsBlackBox()
      val d = withDBus generate new Area {
        dbus.read_data := ram.readWriteSync(
          address = (dbus.address >> 2).resized,
          data    = dbus.write_data,
          enable  = dbus.enable,
          write   = dbus.write_enable
        )
      }
      val i = withIBus generate new Area {
        ibus.data := ram.readWriteSync(
          address = (ibus.address >> 2).resized,
          data    = B(32 bits, default -> False),
          enable  = ibus.enable,
          write   = False
        )
      }
    }
  }
}
