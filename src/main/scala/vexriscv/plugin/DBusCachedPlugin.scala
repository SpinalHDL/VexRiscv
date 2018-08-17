package vexriscv.plugin

import vexriscv.ip._
import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.Axi4


class DAxiCachedPlugin(config : DataCacheConfig, memoryTranslatorPortConfig : Any = null) extends DBusCachedPlugin(config, memoryTranslatorPortConfig){
  var dAxi  : Axi4 = null

  override def build(pipeline: VexRiscv): Unit = {
    super.build(pipeline)
    dBus.asDirectionLess()
    dAxi = master(dBus.toAxi4Shared().toAxi4()).setName("dAxi")
    dBus = null //For safety, as nobody should use it anymore :)
  }
}

class DBusCachedPlugin(config : DataCacheConfig,
                       memoryTranslatorPortConfig : Any = null,
                       csrInfo : Boolean = false)  extends Plugin[VexRiscv]{
  import config._
  var dBus  : DataCacheMemBus = null
  var mmuBus : MemoryTranslatorBus = null
  var exceptionBus : Flow[ExceptionCause] = null
  var privilegeService : PrivilegeService = null

  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_MANAGMENT extends Stageable(Bool)
  object MEMORY_WR extends Stageable(Bool)
  object MEMORY_ADDRESS_LOW extends Stageable(UInt(2 bits))
  object MEMORY_ATOMIC extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])

    val stdActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> False,
      MEMORY_ENABLE     -> True,
      RS1_USE          -> True
    ) ++ (if (catchUnaligned) List(IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB) else Nil) //Used for access fault bad address in memory stage

    val loadActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE -> False,
      MEMORY_WR -> False,
      MEMORY_MANAGMENT -> False
    )

    val storeActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMS,
      RS2_USE -> True,
      MEMORY_WR -> True,
      MEMORY_MANAGMENT -> False
    )

    decoderService.addDefault(MEMORY_ENABLE, False)
    decoderService.add(
      List(LB, LH, LW, LBU, LHU, LWU).map(_ -> loadActions) ++
      List(SB, SH, SW).map(_ -> storeActions)
    )

    if(genAtomic){
      List(LB, LH, LW, LBU, LHU, LWU, SB, SH, SW).foreach(e =>
        decoderService.add(e, Seq(MEMORY_ATOMIC -> False))
      )
      decoderService.add(
        key = LR,
        values = loadActions.filter(_._1 != SRC2_CTRL) ++ Seq(
          SRC2_CTRL -> Src2CtrlEnum.RS,
          MEMORY_ATOMIC -> True
        )
      )
      decoderService.add(
        key = SC,
        values = storeActions.filter(_._1 != SRC2_CTRL) ++ Seq(
          REGFILE_WRITE_VALID -> True,
          BYPASSABLE_EXECUTE_STAGE -> False,
          BYPASSABLE_MEMORY_STAGE -> False,
          MEMORY_ATOMIC -> True
        )
      )
    }

    def MANAGEMENT  = M"-------00000-----101-----0001111"
    decoderService.add(MANAGEMENT, stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.RS,
      RS2_USE -> True,
      MEMORY_MANAGMENT -> True
    ))

    mmuBus = pipeline.service(classOf[MemoryTranslator]).newTranslationPort(MemoryTranslatorPort.PRIORITY_DATA ,memoryTranslatorPortConfig)

    if(catchSomething)
      exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(pipeline.writeBack)

    if(pipeline.serviceExist(classOf[PrivilegeService]))
      privilegeService = pipeline.service(classOf[PrivilegeService])

    if(pipeline.serviceExist(classOf[ReportService])){
      val report = pipeline.service(classOf[ReportService])
      report.add("dBus" -> {
        val e = new BusReport()
        val c = new CacheReport()
        e.kind = "cached"
        e.flushInstructions.add(0x13 | (1 << 7)) ////ADDI x1, x0, 0
        for(idx <- 0 until cacheSize by bytePerLine){
          e.flushInstructions.add(0x7000500F + (1 << 15)) //Clean invalid data cache way x1
          e.flushInstructions.add(0x13 + (1 << 7)  + (1 << 15) + (bytePerLine << 20)) //ADDI x1, x1, 32
        }

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

    dBus = master(DataCacheMemBus(this.config)).setName("dBus")

    val cache = new DataCache(this.config)
    cache.io.mem <> dBus

    execute plug new Area {
      import execute._

      val size = input(INSTRUCTION)(13 downto 12).asUInt
      cache.io.cpu.execute.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.execute.isStuck := arbitration.isStuck
      cache.io.cpu.execute.args.wr := input(MEMORY_WR)
      cache.io.cpu.execute.args.address := input(SRC_ADD).asUInt
      cache.io.cpu.execute.args.data := size.mux(
        U(0)    -> input(RS2)( 7 downto 0) ## input(RS2)( 7 downto 0) ## input(RS2)(7 downto 0) ## input(RS2)(7 downto 0),
        U(1)    -> input(RS2)(15 downto 0) ## input(RS2)(15 downto 0),
        default -> input(RS2)(31 downto 0)
      )
      cache.io.cpu.execute.args.size := size
      cache.io.cpu.execute.args.forceUncachedAccess := False 
      cache.io.cpu.execute.args.kind := input(MEMORY_MANAGMENT) ? DataCacheCpuCmdKind.MANAGMENT | DataCacheCpuCmdKind.MEMORY
      cache.io.cpu.execute.args.clean := input(INSTRUCTION)(28)
      cache.io.cpu.execute.args.invalidate := input(INSTRUCTION)(29)
      cache.io.cpu.execute.args.way := input(INSTRUCTION)(30)
      if(genAtomic) {
        cache.io.cpu.execute.args.isAtomic := False
        when(input(MEMORY_ATOMIC)){
          cache.io.cpu.execute.args.isAtomic := True
          cache.io.cpu.execute.args.address := input(SRC1).asUInt
        }
      }

      insert(MEMORY_ADDRESS_LOW) := cache.io.cpu.execute.args.address(1 downto 0)
    }

    memory plug new Area{
      import memory._
      cache.io.cpu.memory.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.memory.isStuck := arbitration.isStuck
      cache.io.cpu.memory.isRemoved := arbitration.removeIt
      arbitration.haltItself setWhen(cache.io.cpu.memory.haltIt)

      cache.io.cpu.memory.mmuBus <> mmuBus
      arbitration.haltItself setWhen (mmuBus.cmd.isValid && !mmuBus.rsp.hit && !mmuBus.rsp.miss)
    }

    writeBack plug new Area{
      import writeBack._
      cache.io.cpu.writeBack.isValid := arbitration.isValid && input(MEMORY_ENABLE)
      cache.io.cpu.writeBack.isStuck := arbitration.isStuck
      cache.io.cpu.writeBack.isUser  := (if(privilegeService != null) privilegeService.isUser(writeBack) else False)
      if(genAtomic) cache.io.cpu.writeBack.clearAtomicEntries := service(classOf[IContextSwitching]).isContextSwitching

      if(catchSomething) {
        exceptionBus.valid := cache.io.cpu.writeBack.mmuMiss || cache.io.cpu.writeBack.accessError || cache.io.cpu.writeBack.illegalAccess || cache.io.cpu.writeBack.unalignedAccess
        exceptionBus.badAddr := cache.io.cpu.writeBack.badAddr
        exceptionBus.code.assignDontCare()
        when(cache.io.cpu.writeBack.illegalAccess || cache.io.cpu.writeBack.accessError){
          exceptionBus.code := (input(MEMORY_WR) ? U(7) | U(5)).resized
        }
        when(cache.io.cpu.writeBack.unalignedAccess){
          exceptionBus.code := (input(MEMORY_WR) ? U(6) | U(4)).resized
        }
        when(cache.io.cpu.writeBack.mmuMiss){
          exceptionBus.code := 13
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

    if(csrInfo){
      val csr = service(classOf[CsrPlugin])
      csr.r(0xCC0, 0 ->  U(cacheSize/wayCount),  20 ->  U(bytePerLine))
    }
  }
}


