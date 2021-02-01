package vexriscv.plugin

import vexriscv.ip._
import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.Axi4


class DAxiCachedPlugin(config : DataCacheConfig, memoryTranslatorPortConfig : Any = null) extends DBusCachedPlugin(config, memoryTranslatorPortConfig) {
  var dAxi  : Axi4 = null

  override def build(pipeline: VexRiscv): Unit = {
    super.build(pipeline)
    dBus.setAsDirectionLess()
    dAxi = master(dBus.toAxi4Shared().toAxi4()).setName("dAxi")
    dBus = null //For safety, as nobody should use it anymore :)
  }
}

class DBusCachedPlugin(val config : DataCacheConfig,
                       memoryTranslatorPortConfig : Any = null,
                       dBusCmdMasterPipe : Boolean = false,
                       dBusCmdSlavePipe : Boolean = false,
                       dBusRspSlavePipe : Boolean = false,
                       relaxedMemoryTranslationRegister : Boolean = false,
                       csrInfo : Boolean = false)  extends Plugin[VexRiscv] with DBusAccessService {
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

  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_MANAGMENT extends Stageable(Bool)
  object MEMORY_WR extends Stageable(Bool)
  object MEMORY_ADDRESS_LOW extends Stageable(UInt(2 bits))
  object MEMORY_LRSC extends Stageable(Bool)
  object MEMORY_AMO extends Stageable(Bool)
  object MEMORY_FENCE extends Stageable(Bool)
  object MEMORY_FORCE_CONSTISTENCY extends Stageable(Bool)
  object IS_DBUS_SHARING extends Stageable(Bool())
  object MEMORY_VIRTUAL_ADDRESS extends Stageable(UInt(32 bits))

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
      MEMORY_WR -> False
    ) ++ (if(catchSomething) List(HAS_SIDE_EFFECT -> True) else Nil)

    val storeActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMS,
      RS2_USE -> True,
      MEMORY_WR -> True
    )

    decoderService.addDefault(MEMORY_ENABLE, False)
    decoderService.add(
      List(LB, LH, LW, LBU, LHU, LWU).map(_ -> loadActions) ++
      List(SB, SH, SW).map(_ -> storeActions)
    )

    if(withLrSc){
      List(LB, LH, LW, LBU, LHU, LWU, SB, SH, SW).foreach(e =>
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
      List(LB, LH, LW, LBU, LHU, LWU, SB, SH, SW).foreach(e =>
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
      MEMORY_MANAGMENT -> True
    ))

    withWriteResponse match {
      case false => decoderService.add(FENCE, Nil)
      case true => {
        decoderService.addDefault(MEMORY_FENCE, False)
        decoderService.add(FENCE, List(MEMORY_FENCE -> True))
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
        mergeExecuteMemory = writeBack == null
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
      val rspCounter = RegInit(UInt(32 bits)) init(0)
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
      cache.io.cpu.execute.args.data := size.mux(
        U(0)    -> input(RS2)( 7 downto 0) ## input(RS2)( 7 downto 0) ## input(RS2)(7 downto 0) ## input(RS2)(7 downto 0),
        U(1)    -> input(RS2)(15 downto 0) ## input(RS2)(15 downto 0),
        default -> input(RS2)(31 downto 0)
      )
      cache.io.cpu.execute.args.size := size

      if(twoStageMmu) {
        mmuBus.cmd(0).isValid := cache.io.cpu.execute.isValid
        mmuBus.cmd(0).isStuck := arbitration.isStuck
        mmuBus.cmd(0).virtualAddress := input(SRC_ADD).asUInt
        mmuBus.cmd(0).bypassTranslation := False
//        KeepAttribute(mmuBus.cmd(0))
//        KeepAttribute(mmuBus.cmd(1))
      }

      cache.io.cpu.flush.valid := arbitration.isValid && input(MEMORY_MANAGMENT)
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

      insert(MEMORY_ADDRESS_LOW) := cache.io.cpu.execute.address(1 downto 0)

      when(cache.io.cpu.execute.refilling && arbitration.isValid){
        arbitration.haltByOther := True
      }

      if(relaxedMemoryTranslationRegister) {
        insert(MEMORY_VIRTUAL_ADDRESS) := cache.io.cpu.execute.address
        memory.input(MEMORY_VIRTUAL_ADDRESS)
        if(writeBack != null) addPrePopTask( () =>
          KeepAttribute(memory.input(MEMORY_VIRTUAL_ADDRESS).getDrivingReg)
        )
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
    }

    val managementStage = stages.last
    managementStage plug new Area{
      import managementStage._
      cache.io.cpu.writeBack.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.writeBack.isStuck := arbitration.isStuck
      cache.io.cpu.writeBack.isUser  := (if(privilegeService != null) privilegeService.isUser() else False)
      cache.io.cpu.writeBack.address := U(input(REGFILE_WRITE_DATA))

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

      arbitration.haltItself.setWhen(cache.io.cpu.writeBack.haltIt)

      val rspShifted = Bits(32 bits)
      rspShifted := cache.io.cpu.writeBack.data
      switch(input(MEMORY_ADDRESS_LOW)){
        is(1){rspShifted(7 downto 0) := cache.io.cpu.writeBack.data(15 downto 8)}
        is(2){rspShifted(15 downto 0) := cache.io.cpu.writeBack.data(31 downto 16)}
        is(3){rspShifted(7 downto 0) := cache.io.cpu.writeBack.data(31 downto 24)}
      }

      val rspFormated = input(INSTRUCTION)(13 downto 12).mux(
        0 -> B((31 downto 8) -> (rspShifted(7) && !input(INSTRUCTION)(14)),(7 downto 0) -> rspShifted(7 downto 0)),
        1 -> B((31 downto 16) -> (rspShifted(15) && ! input(INSTRUCTION)(14)),(15 downto 0) -> rspShifted(15 downto 0)),
        default -> rspShifted //W
      )

      when(arbitration.isValid && input(MEMORY_ENABLE)) {
        output(REGFILE_WRITE_DATA) := rspFormated
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
          cache.io.cpu.execute.args.wr := dBusAccess.cmd.write
          cache.io.cpu.execute.args.data := dBusAccess.cmd.data
          cache.io.cpu.execute.args.size := dBusAccess.cmd.size
          if(withLrSc) cache.io.cpu.execute.args.isLrsc := False
          if(withAmo) cache.io.cpu.execute.args.isAmo := False
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
      dBusAccess.rsp.data := cache.io.cpu.writeBack.data
      dBusAccess.rsp.error := cache.io.cpu.writeBack.unalignedAccess || cache.io.cpu.writeBack.accessError
      dBusAccess.rsp.redo := cache.io.cpu.redo
      component.addPrePopTask{() =>
        when(forceDatapath){
          execute.output(REGFILE_WRITE_DATA) := dBusAccess.cmd.address.asBits
        }
        if(mmuAndBufferStage != execute) mmuAndBufferStage.input(IS_DBUS_SHARING) init(False)
        managementStage.input(IS_DBUS_SHARING) init(False)
        when(dBusAccess.rsp.valid){
          managementStage.input(IS_DBUS_SHARING).getDrivingReg := False
        }
      }
    }

    if(csrInfo){
      val csr = service(classOf[CsrPlugin])
      csr.r(0xCC0, 0 ->  U(cacheSize/wayCount),  20 ->  U(bytePerLine))
    }
  }
}


