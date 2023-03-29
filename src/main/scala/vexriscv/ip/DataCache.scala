package vexriscv.ip

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4Shared}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbAccessParameter, BmbCmd, BmbInvalidationParameter, BmbParameter, BmbSourceParameter}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.plugin.DBusSimpleBus


case class DataCacheConfig(cacheSize : Int,
                           bytePerLine : Int,
                           wayCount : Int,
                           addressWidth : Int,
                           cpuDataWidth : Int,
                           var rfDataWidth : Int = -1, //-1 mean cpuDataWidth
                           memDataWidth : Int,
                           catchAccessError : Boolean,
                           catchIllegal : Boolean,
                           catchUnaligned : Boolean,
                           earlyWaysHits : Boolean = true,
                           earlyDataMux : Boolean = false,
                           tagSizeShift : Int = 0, //Used to force infering ram
                           withLrSc : Boolean = false,
                           withAmo : Boolean = false,
                           withExclusive : Boolean = false,
                           withInvalidate : Boolean = false,
                           pendingMax : Int = 64,
                           directTlbHit : Boolean = false,
                           mergeExecuteMemory : Boolean = false,
                           asyncTagMemory : Boolean = false,
                           withWriteAggregation : Boolean = false){

  if(rfDataWidth == -1)  rfDataWidth = cpuDataWidth 
  assert(!(mergeExecuteMemory && (earlyDataMux || earlyWaysHits)))
  assert(!(earlyDataMux && !earlyWaysHits))
  assert(isPow2(pendingMax))
  assert(rfDataWidth <= memDataWidth)

  def lineCount = cacheSize/bytePerLine/wayCount
  def sizeMax = log2Up(bytePerLine)
  def sizeWidth = log2Up(sizeMax + 1)
  val aggregationWidth = if(withWriteAggregation) log2Up(memDataBytes+1) else 0
  def withWriteResponse = withExclusive
  def burstSize = bytePerLine*8/memDataWidth
  val burstLength = bytePerLine/(cpuDataWidth/8)
  def catchSomething = catchUnaligned || catchIllegal || catchAccessError
  def withInternalAmo = withAmo && !withExclusive
  def withInternalLrSc = withLrSc && !withExclusive
  def withExternalLrSc = withLrSc && withExclusive
  def withExternalAmo = withAmo && withExclusive
  def cpuDataBytes = cpuDataWidth/8
  def rfDataBytes = rfDataWidth/8
  def memDataBytes = memDataWidth/8
  def getAxi4SharedConfig() = Axi4Config(
    addressWidth = addressWidth,
    dataWidth = memDataWidth,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false
  )


  def getAvalonConfig() = AvalonMMConfig.bursted(
    addressWidth = addressWidth,
    dataWidth = memDataWidth,
    burstCountWidth = log2Up(burstSize + 1)).copy(
    useByteEnable = true,
    constantBurstBehavior = true,
    burstOnBurstBoundariesOnly = true,
    useResponse = true,
    maximumPendingReadTransactions = 2
  )

  def getWishboneConfig() = WishboneConfig(
    addressWidth = 32-log2Up(memDataWidth/8),
    dataWidth = memDataWidth,
    selWidth = memDataBytes,
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

  def getBmbParameter() = BmbParameter(
    BmbAccessParameter(
      addressWidth = 32,
      dataWidth = memDataWidth
    ).addSources(1, BmbSourceParameter(
      lengthWidth = log2Up(this.bytePerLine),
      contextWidth = (if(!withWriteResponse) 1 else 0) + aggregationWidth,
      alignment  = BmbParameter.BurstAlignement.LENGTH,
      canExclusive = withExclusive,
      withCachedRead = true,
      canInvalidate = withInvalidate,
      canSync = withInvalidate
    )),
    BmbInvalidationParameter(
      invalidateLength = log2Up(this.bytePerLine),
      invalidateAlignment = BmbParameter.BurstAlignement.LENGTH
    )
  )
}

object DataCacheCpuExecute{
  implicit def implArgs(that : DataCacheCpuExecute) = that.args
}

case class DataCacheCpuExecute(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val address = UInt(p.addressWidth bit)
  val haltIt = Bool
  val args = DataCacheCpuExecuteArgs(p)
  val refilling = Bool

  override def asMaster(): Unit = {
    out(isValid, args, address)
    in(haltIt, refilling)
  }
}

case class DataCacheCpuExecuteArgs(p : DataCacheConfig) extends Bundle{
  val wr = Bool
  val size = UInt(log2Up(log2Up(p.cpuDataBytes)+1) bits)
  val isLrsc = p.withLrSc generate Bool()
  val isAmo = p.withAmo generate Bool()
  val amoCtrl = p.withAmo generate new Bundle {
    val swap = Bool()
    val alu = Bits(3 bits)
  }

  val totalyConsistent = Bool() //Only for AMO/LRSC
}

case class DataCacheCpuMemory(p : DataCacheConfig, mmu : MemoryTranslatorBusParameter) extends Bundle with IMasterSlave{
  val isValid = Bool
  val isStuck = Bool
  val isWrite = Bool
  val address = UInt(p.addressWidth bit)
  val mmuRsp  = MemoryTranslatorRsp(mmu)

  override def asMaster(): Unit = {
    out(isValid, isStuck, address)
    in(isWrite)
    out(mmuRsp)
  }
}


case class FenceFlags() extends Bundle {
  val SW,SR,SO,SI,PW,PR,PO,PI = Bool()
  val FM = Bits(4 bits)

  def SL = SR || SI
  def SS = SW || SO
  def PL = PR || PI
  def PS = PW || PO
  def forceAll(): Unit ={
    List(SW,SR,SO,SI,PW,PR,PO,PI).foreach(_ := True)
  }
  def clearAll(): Unit ={
    List(SW,SR,SO,SI,PW,PR,PO,PI).foreach(_ := False)
  }
}

case class DataCacheCpuWriteBack(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool()
  val isStuck = Bool()
  val isFiring = Bool()
  val isUser = Bool()
  val haltIt = Bool()
  val isWrite = Bool()
  val storeData = Bits(p.cpuDataWidth bit)
  val data = Bits(p.cpuDataWidth bit)
  val address = UInt(p.addressWidth bit)
  val mmuException, unalignedAccess, accessError = Bool()
  val keepMemRspData = Bool() //Used by external AMO to avoid having an internal buffer
  val fence = FenceFlags()
  val exclusiveOk = Bool()

  override def asMaster(): Unit = {
    out(isValid,isStuck,isUser, address, fence, storeData, isFiring)
    in(haltIt, data, mmuException, unalignedAccess, accessError, isWrite, keepMemRspData, exclusiveOk)
  }
}

case class DataCacheFlush(lineCount : Int) extends Bundle{
  val singleLine = Bool()
  val lineId = UInt(log2Up(lineCount) bits)
}

case class DataCacheCpuBus(p : DataCacheConfig, mmu : MemoryTranslatorBusParameter) extends Bundle with IMasterSlave{
  val execute   = DataCacheCpuExecute(p)
  val memory    = DataCacheCpuMemory(p, mmu)
  val writeBack = DataCacheCpuWriteBack(p)

  val redo = Bool()
  val flush = Stream(DataCacheFlush(p.lineCount))

  val writesPending = Bool()

  override def asMaster(): Unit = {
    master(execute)
    master(memory)
    master(writeBack)
    master(flush)
    in(redo, writesPending)
  }
}


case class DataCacheMemCmd(p : DataCacheConfig) extends Bundle{
  val wr = Bool
  val uncached = Bool
  val address = UInt(p.addressWidth bit)
  val data = Bits(p.cpuDataWidth bits)
  val mask = Bits(p.cpuDataWidth/8 bits)
  val size   = UInt(p.sizeWidth bits) //... 1 => 2 bytes ... 2 => 4 bytes ...
  val exclusive = p.withExclusive generate Bool()
  val last = Bool

//  def beatCountMinusOne = size.muxListDc((0 to p.sizeMax).map(i => i -> U((1 << i)/p.memDataBytes)))
//  def beatCount = size.muxListDc((0 to p.sizeMax).map(i => i -> U((1 << i)/p.memDataBytes-1)))

  //Utilities which does quite a few assumtions about the bus utilisation
  def byteCountMinusOne = size.muxListDc((0 to p.sizeMax).map(i => i -> U((1 << i)-1, log2Up(p.bytePerLine) bits)))
  def beatCountMinusOne = (size === log2Up(p.bytePerLine)) ? U(p.burstSize-1) | U(0)
  def beatCount         = (size === log2Up(p.bytePerLine)) ? U(p.burstSize) | U(1)
  def isBurst           = size === log2Up(p.bytePerLine)
}
case class DataCacheMemRsp(p : DataCacheConfig) extends Bundle{
  val aggregated = UInt(p.aggregationWidth bits)
  val last = Bool()
  val data = Bits(p.memDataWidth bit)
  val error = Bool
  val exclusive = p.withExclusive generate Bool()
}
case class DataCacheInv(p : DataCacheConfig) extends Bundle{
  val enable = Bool()
  val address = UInt(p.addressWidth bit)
}
case class DataCacheAck(p : DataCacheConfig) extends Bundle{
  val hit = Bool()
}

case class DataCacheSync(p : DataCacheConfig) extends Bundle{
  val aggregated = UInt(p.aggregationWidth bits)
}

case class DataCacheMemBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val cmd = Stream (DataCacheMemCmd(p))
  val rsp = Flow (DataCacheMemRsp(p))

  val inv = p.withInvalidate generate Stream(Fragment(DataCacheInv(p)))
  val ack = p.withInvalidate generate Stream(Fragment(DataCacheAck(p)))
  val sync = p.withInvalidate generate Stream(DataCacheSync(p))

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)

    if(p.withInvalidate) {
      slave(inv)
      master(ack)
      slave(sync)
    }
  }

  def toAxi4Shared(stageCmd : Boolean = false, pendingWritesMax  : Int = 7): Axi4Shared = {
    val axi = Axi4Shared(p.getAxi4SharedConfig()).setName("dbus_axi")

    val cmdPreFork = if (stageCmd) cmd.stage.stage().s2mPipe() else cmd

    val pendingWrites = CounterUpDown(
      stateCount = pendingWritesMax + 1,
      incWhen = cmdPreFork.fire && cmdPreFork.wr,
      decWhen = axi.writeRsp.fire
    )

    val hazard = (pendingWrites =/= 0 && !cmdPreFork.wr) || pendingWrites === pendingWritesMax
    val (cmdFork, dataFork) = StreamFork2(cmdPreFork.haltWhen(hazard))
    val cmdStage  = cmdFork.throwWhen(RegNextWhen(!cmdFork.last,cmdFork.fire).init(False))
    val dataStage = dataFork.throwWhen(!dataFork.wr)

    axi.sharedCmd.arbitrationFrom(cmdStage)
    axi.sharedCmd.write := cmdStage.wr
    axi.sharedCmd.prot := "010"
    axi.sharedCmd.cache := "1111"
    axi.sharedCmd.size := log2Up(p.memDataBytes)
    axi.sharedCmd.addr := cmdStage.address
    axi.sharedCmd.len  := cmdStage.beatCountMinusOne.resized

    axi.writeData.arbitrationFrom(dataStage)
    axi.writeData.data := dataStage.data
    axi.writeData.strb := dataStage.mask
    axi.writeData.last := dataStage.last

    rsp.valid := axi.r.valid
    rsp.error := !axi.r.isOKAY()
    rsp.data := axi.r.data

    axi.r.ready := True
    axi.b.ready := True

    axi
  }


  def toAvalon(): AvalonMM = {
    val avalonConfig = p.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)
    mm.read := cmd.valid && !cmd.wr
    mm.write := cmd.valid && cmd.wr
    mm.address := cmd.address(cmd.address.high downto log2Up(p.memDataWidth/8)) @@ U(0,log2Up(p.memDataWidth/8) bits)
    mm.burstCount := cmd.beatCount
    mm.byteEnable := cmd.mask
    mm.writeData := cmd.data

    cmd.ready := mm.waitRequestn
    rsp.valid := mm.readDataValid
    rsp.data  := mm.readData
    rsp.error := mm.response =/= AvalonMM.Response.OKAY

    mm
  }

  def toWishbone(): Wishbone = {
    val wishboneConfig = p.getWishboneConfig()
    val bus = Wishbone(wishboneConfig)
    val counter = Reg(UInt(log2Up(p.burstSize) bits)) init(0)
    val addressShift = log2Up(p.memDataWidth/8)

    val cmdBridge = Stream (DataCacheMemCmd(p))
    val isBurst = cmdBridge.isBurst
    cmdBridge.valid := cmd.valid
    cmdBridge.address := (isBurst ? (cmd.address(31 downto widthOf(counter) + addressShift) @@ counter @@ U(0, addressShift bits)) | (cmd.address(31 downto addressShift) @@ U(0, addressShift bits)))
    cmdBridge.wr := cmd.wr
    cmdBridge.mask := cmd.mask
    cmdBridge.data := cmd.data
    cmdBridge.size := cmd.size
    cmdBridge.last := !isBurst || counter === p.burstSize-1
    cmd.ready := cmdBridge.ready && (cmdBridge.wr || cmdBridge.last)


    when(cmdBridge.fire){
      counter := counter + 1
      when(cmdBridge.last){
        counter := 0
      }
    }


    bus.ADR := cmdBridge.address >> addressShift
    bus.CTI := Mux(isBurst, cmdBridge.last ? B"111" | B"010", B"000")
    bus.BTE := B"00"
    bus.SEL := cmdBridge.wr ? cmdBridge.mask | B((1 << p.memDataBytes)-1)
    bus.WE  := cmdBridge.wr
    bus.DAT_MOSI := cmdBridge.data

    cmdBridge.ready := cmdBridge.valid && bus.ACK
    bus.CYC := cmdBridge.valid
    bus.STB := cmdBridge.valid

    rsp.valid := RegNext(cmdBridge.valid && !bus.WE && bus.ACK) init(False)
    rsp.data  := RegNext(bus.DAT_MISO)
    rsp.error := False //TODO
    bus
  }



  def toPipelinedMemoryBus(): PipelinedMemoryBus = {
    val bus = PipelinedMemoryBus(32,32)

    val counter = Reg(UInt(log2Up(p.burstSize) bits)) init(0)
    when(bus.cmd.fire){ counter := counter + 1 }
    when(    cmd.fire && cmd.last){ counter := 0 }

    bus.cmd.valid := cmd.valid
    bus.cmd.address := (cmd.address(31 downto 2) | counter.resized) @@ U"00"
    bus.cmd.write := cmd.wr
    bus.cmd.mask := cmd.mask
    bus.cmd.data := cmd.data
    cmd.ready := bus.cmd.ready && (cmd.wr || counter === p.burstSize-1)
    rsp.valid := bus.rsp.valid
    rsp.data  := bus.rsp.payload.data
    rsp.error := False
    bus
  }


  def toBmb(syncPendingMax : Int = 32,
            timeoutCycles : Int = 16) : Bmb = new Area{
    setCompositeName(DataCacheMemBus.this, "Bridge", true)
    val pipelinedMemoryBusConfig = p.getBmbParameter()
    val bus = Bmb(pipelinedMemoryBusConfig).setCompositeName(this,"toBmb", true)

    case class Context() extends Bundle{
      val isWrite = !p.withWriteResponse generate Bool()
      val rspCount = (p.aggregationWidth != 0) generate UInt(p.aggregationWidth bits)
    }


    def sizeToLength(size : UInt) = size.muxListDc((0 to log2Up(p.cpuDataBytes)).map(i => U(i) -> U((1 << i)-1, log2Up(p.cpuDataBytes) bits)))

    val withoutWriteBuffer = if(p.aggregationWidth == 0) new Area {
      val busCmdContext = Context()

      bus.cmd.valid := cmd.valid
      bus.cmd.last := cmd.last
      bus.cmd.opcode := (cmd.wr ? B(Bmb.Cmd.Opcode.WRITE) | B(Bmb.Cmd.Opcode.READ))
      bus.cmd.address := cmd.address.resized
      bus.cmd.data := cmd.data
      bus.cmd.length := cmd.byteCountMinusOne
      bus.cmd.mask := cmd.mask
      if (p.withExclusive) bus.cmd.exclusive := cmd.exclusive
      if (!p.withWriteResponse) busCmdContext.isWrite := cmd.wr
      bus.cmd.context := B(busCmdContext)

      cmd.ready := bus.cmd.ready
      if(p.withInvalidate) sync.arbitrationFrom(bus.sync)
    }

    val withWriteBuffer = if(p.aggregationWidth != 0) new Area {
      val buffer = new Area {
        val stream = cmd.toEvent().m2sPipe()
        val address = Reg(UInt(p.addressWidth bits))
        val length = Reg(UInt(pipelinedMemoryBusConfig.access.lengthWidth bits))
        val write  = Reg(Bool)
        val exclusive = Reg(Bool)
        val data = Reg(Bits(p.memDataWidth bits))
        val mask = Reg(Bits(p.memDataWidth/8 bits)) init(0)
      }

      val aggregationRange = log2Up(p.memDataWidth/8)-1 downto log2Up(p.cpuDataWidth/8)
      val tagRange = p.addressWidth-1 downto aggregationRange.high+1
      val aggregationEnabled = Reg(Bool)
      val aggregationCounter = Reg(UInt(p.aggregationWidth bits)) init(0)
      val aggregationCounterFull = aggregationCounter === aggregationCounter.maxValue
      val timer = Reg(UInt(log2Up(timeoutCycles)+1 bits)) init(0)
      val timerFull = timer.msb
      val hit = cmd.address(tagRange) === buffer.address(tagRange)
      val cmdExclusive = if(p.withExclusive) cmd.exclusive else False
      val canAggregate = cmd.valid && cmd.wr && !cmd.uncached && !cmdExclusive && !timerFull && !aggregationCounterFull && (!buffer.stream.valid || aggregationEnabled && hit)
      val doFlush = cmd.valid && !canAggregate || timerFull || aggregationCounterFull || !aggregationEnabled
//      val canAggregate = False
//      val doFlush = True
      val busCmdContext = Context()
      val halt = False

      when(cmd.fire){
        aggregationCounter := aggregationCounter + 1
      }
      when(buffer.stream.valid && !timerFull){
        timer := timer + 1
      }
      when(bus.cmd.fire || !buffer.stream.valid){
        buffer.mask := 0
        aggregationCounter := 0
        timer := 0
      }

      buffer.stream.ready := (bus.cmd.ready && doFlush || canAggregate) && !halt
      bus.cmd.valid := buffer.stream.valid && doFlush && !halt
      bus.cmd.last := True
      bus.cmd.opcode := (buffer.write ? B(Bmb.Cmd.Opcode.WRITE) | B(Bmb.Cmd.Opcode.READ))
      bus.cmd.address := buffer.address
      bus.cmd.length := buffer.length
      bus.cmd.data := buffer.data
      bus.cmd.mask := buffer.mask

      if (p.withExclusive) bus.cmd.exclusive := buffer.exclusive
      bus.cmd.context.removeAssignments() := B(busCmdContext)
      if (!p.withWriteResponse) busCmdContext.isWrite := bus.cmd.isWrite
      busCmdContext.rspCount := aggregationCounter

      val aggregationSel = cmd.address(aggregationRange)
      when(cmd.fire){
        val dIn = cmd.data.subdivideIn(8 bits)
        val dReg = buffer.data.subdivideIn(8 bits)
        for(byteId <- 0 until p.memDataBytes){
          when(aggregationSel === byteId / p.cpuDataBytes && cmd.mask(byteId % p.cpuDataBytes)){
            dReg.write(byteId, dIn(byteId % p.cpuDataBytes))
            buffer.mask(byteId) := True
          }
        }
      }

      when(cmd.fire){
        buffer.write := cmd.wr
        buffer.address := cmd.address.resized
        buffer.length := cmd.byteCountMinusOne
        if (p.withExclusive) buffer.exclusive := cmd.exclusive

        when(cmd.wr && !cmd.uncached && !cmdExclusive){
          aggregationEnabled := True
          buffer.address(aggregationRange.high downto 0) := 0
          buffer.length := p.memDataBytes-1
        } otherwise {
          aggregationEnabled := False
        }
      }


      val rspCtx = bus.rsp.context.as(Context())
      rsp.aggregated := rspCtx.rspCount

      val syncLogic = p.withInvalidate generate new Area{
        val cmdCtx = Stream(UInt(p.aggregationWidth bits))
        cmdCtx.valid := bus.cmd.fire && bus.cmd.isWrite
        cmdCtx.payload := aggregationCounter
        halt setWhen(!cmdCtx.ready)

        val syncCtx = cmdCtx.queue(syncPendingMax).s2mPipe().m2sPipe() //Assume latency of sync is at least 3 cycles
        syncCtx.ready := bus.sync.fire

        sync.arbitrationFrom(bus.sync)
        sync.aggregated := syncCtx.payload
      }
    }


    rsp.valid := bus.rsp.valid
    if(!p.withWriteResponse) rsp.valid clearWhen(bus.rsp.context(0))
    rsp.data  := bus.rsp.data
    rsp.error := bus.rsp.isError
    rsp.last := bus.rsp.last
    if(p.withExclusive) rsp.exclusive := bus.rsp.exclusive
    bus.rsp.ready := True

    val invalidateLogic = p.withInvalidate generate new Area{
      val beatCountMinusOne = bus.inv.transferBeatCountMinusOne(p.bytePerLine)
      val counter = Reg(UInt(widthOf(beatCountMinusOne) bits)) init(0)

      inv.valid := bus.inv.valid
      inv.address := bus.inv.address + (counter << log2Up(p.bytePerLine))
      inv.enable  := bus.inv.all
      inv.last := counter === beatCountMinusOne
      bus.inv.ready := inv.last && inv.ready

      if(widthOf(counter) != 0) when(inv.fire){
        counter := counter + 1
        when(inv.last){
          counter := 0
        }
      }

      bus.ack.arbitrationFrom(ack.throwWhen(!ack.last))
    }
  }.bus

}

object DataCacheExternalAmoStates extends SpinalEnum{
  val LR_CMD, LR_RSP, SC_CMD, SC_RSP = newElement();
}

//If external amo, mem rsp should stay
class DataCache(val p : DataCacheConfig, mmuParameter : MemoryTranslatorBusParameter) extends Component{
  import p._

  val io = new Bundle{
    val cpu = slave(DataCacheCpuBus(p, mmuParameter))
    val mem = master(DataCacheMemBus(p))
  }

  val haltCpu = False
  val lineWidth = bytePerLine*8
  val lineCount = cacheSize/bytePerLine
  val wordWidth = cpuDataWidth
  val wordWidthLog2 = log2Up(wordWidth)
  val wordPerLine = lineWidth/wordWidth
  val bytePerWord = wordWidth/8
  val wayLineCount = lineCount/wayCount
  val wayLineLog2 = log2Up(wayLineCount)
  val wayWordCount = wayLineCount * wordPerLine
  val memWordPerLine = lineWidth/memDataWidth
  val memTransactionPerLine = p.bytePerLine / (p.memDataWidth/8)
  val bytePerMemWord = memDataWidth/8
  val wayMemWordCount = wayLineCount * memWordPerLine

  val tagRange = addressWidth-1 downto log2Up(wayLineCount*bytePerLine)
  val lineRange = tagRange.low-1 downto log2Up(bytePerLine)
  val cpuWordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerWord)
  val memWordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerMemWord)
  val hitRange = tagRange.high downto lineRange.low
  val memWordToCpuWordRange = log2Up(bytePerMemWord)-1 downto log2Up(bytePerWord)
  val cpuWordToRfWordRange = log2Up(bytePerWord)-1 downto log2Up(p.rfDataBytes)


  class LineInfo() extends Bundle{
    val valid, error = Bool()
    val address = UInt(tagRange.length bit)
  }

  val tagsReadCmd =  Flow(UInt(log2Up(wayLineCount) bits))
  val tagsInvReadCmd = withInvalidate generate Flow(UInt(log2Up(wayLineCount) bits))
  val tagsWriteCmd = Flow(new Bundle{
    val way = Bits(wayCount bits)
    val address = UInt(log2Up(wayLineCount) bits)
    val data = new LineInfo()
  })

  val tagsWriteLastCmd = RegNext(tagsWriteCmd)

  val dataReadCmd =  Flow(UInt(log2Up(wayMemWordCount) bits))
  val dataWriteCmd = Flow(new Bundle{
    val way = Bits(wayCount bits)
    val address = UInt(log2Up(wayMemWordCount) bits)
    val data = Bits(memDataWidth bits)
    val mask = Bits(memDataWidth/8 bits)
  })


  val ways = for(i <- 0 until wayCount) yield new Area{
    val tags = Mem(new LineInfo(), wayLineCount)
    val data = Mem(Bits(memDataWidth bit), wayMemWordCount)

    //Reads
    val tagsReadRsp = asyncTagMemory match {
      case false => tags.readSync(tagsReadCmd.payload, tagsReadCmd.valid && !io.cpu.memory.isStuck)
      case true => tags.readAsync(RegNextWhen(tagsReadCmd.payload, io.cpu.execute.isValid && !io.cpu.memory.isStuck))
    }
    val dataReadRspMem = data.readSync(dataReadCmd.payload, dataReadCmd.valid && !io.cpu.memory.isStuck)
    val dataReadRspSel = if(mergeExecuteMemory) io.cpu.writeBack.address else io.cpu.memory.address
    val dataReadRsp = dataReadRspMem.subdivideIn(cpuDataWidth bits).read(dataReadRspSel(memWordToCpuWordRange))

    val tagsInvReadRsp = withInvalidate generate(asyncTagMemory match {
      case false => tags.readSync(tagsInvReadCmd.payload, tagsInvReadCmd.valid)
      case true => tags.readAsync(RegNextWhen(tagsInvReadCmd.payload, tagsInvReadCmd.valid))
    })

    //Writes
    when(tagsWriteCmd.valid && tagsWriteCmd.way(i)){
      tags.write(tagsWriteCmd.address, tagsWriteCmd.data)
    }
    when(dataWriteCmd.valid && dataWriteCmd.way(i)){
      data.write(
        address = dataWriteCmd.address,
        data = dataWriteCmd.data,
        mask = dataWriteCmd.mask
      )
    }
  }


  tagsReadCmd.valid := False
  tagsReadCmd.payload.assignDontCare()
  dataReadCmd.valid := False
  dataReadCmd.payload.assignDontCare()
  tagsWriteCmd.valid := False
  tagsWriteCmd.payload.assignDontCare()
  dataWriteCmd.valid := False
  dataWriteCmd.payload.assignDontCare()

  when(io.cpu.execute.isValid && !io.cpu.memory.isStuck){
    tagsReadCmd.valid   := True
    dataReadCmd.valid   := True
    tagsReadCmd.payload := io.cpu.execute.address(lineRange)
    dataReadCmd.payload := io.cpu.execute.address(lineRange.high downto memWordRange.low)
  }

  def collisionProcess(readAddress : UInt, readMask : Bits): Bits ={
    val ret = Bits(wayCount bits)
    val readAddressAligned = (readAddress >> log2Up(memDataWidth/cpuDataWidth))
    val dataWriteMaskAligned = dataWriteCmd.mask.subdivideIn(memDataWidth/cpuDataWidth slices).read(readAddress(log2Up(memDataWidth/cpuDataWidth)-1 downto 0))
    for(i <- 0 until wayCount){
      ret(i) := dataWriteCmd.valid && dataWriteCmd.way(i) && dataWriteCmd.address === readAddressAligned && (readMask & dataWriteMaskAligned) =/= 0
    }
    ret
  }


  io.cpu.execute.haltIt := False

  val rspSync = True
  val rspLast = True
  val memCmdSent = RegInit(False) setWhen (io.mem.cmd.fire) clearWhen (!io.cpu.writeBack.isStuck)
  val pending = withExclusive generate new Area{
    val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
    val counterNext = counter + U(io.mem.cmd.fire && io.mem.cmd.last) - ((io.mem.rsp.valid  && io.mem.rsp.last) ? (io.mem.rsp.aggregated +^ 1) | 0)
    counter := counterNext

    val done = RegNext(counterNext === 0)
    val full = RegNext(counter.msb)       //Has margin
    val last = RegNext(counterNext === 1) //Equivalent to counter === 1 but pipelined

    if(!withInvalidate) {
      io.cpu.execute.haltIt setWhen(full)
    }

    rspSync clearWhen (!last || !memCmdSent)
    rspLast clearWhen (!last)
  }

  val sync = withInvalidate generate new Area{
    io.mem.sync.ready := True
    val syncCount = io.mem.sync.aggregated +^ 1
    val syncContext = new Area{
      val history = Mem(Bool, pendingMax)
      val wPtr, rPtr = Reg(UInt(log2Up(pendingMax)+1 bits)) init(0)
      when(io.mem.cmd.fire && io.mem.cmd.wr){
        history.write(wPtr.resized, io.mem.cmd.uncached)
        wPtr := wPtr + 1
      }

      when(io.mem.sync.fire){
        rPtr := rPtr + syncCount
      }
      val uncached = history.readAsync(rPtr.resized)
      val full = RegNext(wPtr - rPtr >= pendingMax-1)
      val empty = wPtr === rPtr
      io.cpu.writesPending := !empty
      io.cpu.execute.haltIt setWhen(full)
    }

    def pending(inc : Bool, dec : Bool) = new Area {
      val pendingSync = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
      val pendingSyncNext = pendingSync + U(io.mem.cmd.fire && io.mem.cmd.wr && inc) - ((io.mem.sync.fire && dec) ? syncCount | 0)
      pendingSync := pendingSyncNext
    }

    val writeCached = pending(inc = !io.mem.cmd.uncached, dec = !syncContext.uncached)
    val writeUncached = pending(inc = io.mem.cmd.uncached, dec = syncContext.uncached)

    def track(load : Bool, uncached : Boolean) = new Area {
      val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
      counter := counter - ((io.mem.sync.fire && counter =/= 0 && (if(uncached) syncContext.uncached else !syncContext.uncached)) ? syncCount | 0)
      when(load){ counter := (if(uncached) writeUncached.pendingSyncNext else writeCached.pendingSyncNext) }

      val busy = counter =/= 0
    }

    val w2w = track(load = io.cpu.writeBack.fence.PW && io.cpu.writeBack.fence.SW, uncached = false)
    val w2r = track(load = io.cpu.writeBack.fence.PW && io.cpu.writeBack.fence.SR, uncached = false)
    val w2i = track(load = io.cpu.writeBack.fence.PW && io.cpu.writeBack.fence.SI, uncached = false)
    val w2o = track(load = io.cpu.writeBack.fence.PW && io.cpu.writeBack.fence.SO, uncached = false)
    val o2w = track(load = io.cpu.writeBack.fence.PO && io.cpu.writeBack.fence.SW, uncached =  true)
    val o2r = track(load = io.cpu.writeBack.fence.PO && io.cpu.writeBack.fence.SR, uncached =  true)
    //Assume o2i and o2o are ordered by the interconnect

    val notTotalyConsistent = w2w.busy || w2r.busy || w2i.busy || w2o.busy || o2w.busy || o2r.busy
  }




  val stage0 = new Area{
//    val mask = io.cpu.execute.size.mux (
//      U(0)    -> B"0001",
//      U(1)    -> B"0011",
//      default -> B"1111"
//    ) |<< io.cpu.execute.address(1 downto 0)

    val mask = io.cpu.execute.size.muxListDc((0 to log2Up(p.cpuDataBytes)).map(i => U(i) -> B((1 << (1 << i)) -1, p.cpuDataBytes bits))) |<< io.cpu.execute.address(log2Up(p.cpuDataBytes)-1 downto 0)


    val dataColisions = collisionProcess(io.cpu.execute.address(lineRange.high downto cpuWordRange.low), mask)
    val wayInvalidate = B(0, wayCount bits) //Used if invalidate enabled

    val isAmo = if(withAmo) io.cpu.execute.isAmo else False
  }

  val stageA = new Area{
    def stagePipe[T <: Data](that : T) = if(mergeExecuteMemory) CombInit(that) else RegNextWhen(that, !io.cpu.memory.isStuck)
    val request = stagePipe(io.cpu.execute.args)
    val mask = stagePipe(stage0.mask)
    io.cpu.memory.isWrite := request.wr

    val isAmo = if(withAmo) request.isAmo else False
    val isLrsc = if(withAmo) request.isLrsc else False
    val consistancyCheck = (withInvalidate || withWriteResponse) generate new Area {
      val hazard = False
      val w = sync.w2w.busy || sync.o2w.busy
      val r = stagePipe(sync.w2r.busy || sync.o2r.busy) || sync.w2r.busy || sync.o2r.busy // As it use the cache, need to check against the execute stage status too
      val o = CombInit(sync.w2o.busy)
      val i = CombInit(sync.w2i.busy)

      val s = io.cpu.memory.mmuRsp.isIoAccess ? o | w
      val l = io.cpu.memory.mmuRsp.isIoAccess ? i | r

      when(isAmo? (s || l) | (request.wr ? s | l)){
        hazard := True
      }
      when(request.totalyConsistent && (sync.notTotalyConsistent || io.cpu.writeBack.isValid && io.cpu.writeBack.isWrite)){
        hazard := True
      }
    }

    val wayHits = earlyWaysHits generate Bits(wayCount bits)
    val indirectTlbHitGen = (earlyWaysHits && !directTlbHit) generate new Area {
      wayHits := B(ways.map(way => (io.cpu.memory.mmuRsp.physicalAddress(tagRange) === way.tagsReadRsp.address && way.tagsReadRsp.valid)))
    }
    val directTlbHitGen = (earlyWaysHits && directTlbHit) generate new Area {
      val wayTlbHits = for (way <- ways) yield for (tlb <- io.cpu.memory.mmuRsp.ways) yield {
        way.tagsReadRsp.address === tlb.physical(tagRange) && tlb.sel
      }
      val translatedHits = B(wayTlbHits.map(_.orR))
      val bypassHits = B(ways.map(_.tagsReadRsp.address === io.cpu.memory.address(tagRange)))
      wayHits := (io.cpu.memory.mmuRsp.bypassTranslation ? bypassHits | translatedHits) & B(ways.map(_.tagsReadRsp.valid))
    }

    val dataMux = earlyDataMux generate MuxOH(wayHits, ways.map(_.dataReadRsp))
    val wayInvalidate = stagePipe(stage0. wayInvalidate)
    val dataColisions = if(mergeExecuteMemory){
      stagePipe(stage0.dataColisions)
    } else {
      //Assume the writeback stage will never be unstall memory acces while memory stage is stalled
      stagePipe(stage0.dataColisions) | collisionProcess(io.cpu.memory.address(lineRange.high downto cpuWordRange.low), mask)
    }
  }

  val stageB = new Area {
    def stagePipe[T <: Data](that : T) = RegNextWhen(that, !io.cpu.writeBack.isStuck)
    def ramPipe[T <: Data](that : T) = if(mergeExecuteMemory) CombInit(that) else  RegNextWhen(that, !io.cpu.writeBack.isStuck)
    val request = RegNextWhen(stageA.request, !io.cpu.writeBack.isStuck)
    val mmuRspFreeze = False
    val mmuRsp = RegNextWhen(io.cpu.memory.mmuRsp, !io.cpu.writeBack.isStuck && !mmuRspFreeze)
    val tagsReadRsp = ways.map(w => ramPipe(w.tagsReadRsp))
    val dataReadRsp = !earlyDataMux generate ways.map(w => ramPipe(w.dataReadRsp))
    val wayInvalidate = stagePipe(stageA. wayInvalidate)
    val consistancyHazard = if(stageA.consistancyCheck != null) stagePipe(stageA.consistancyCheck.hazard) else False
    val dataColisions = stagePipe(stageA.dataColisions)
//    val unaligned = if(!catchUnaligned) False else stagePipe((stageA.request.size === 2 && io.cpu.memory.address(1 downto 0) =/= 0) || (stageA.request.size === 1 && io.cpu.memory.address(0 downto 0) =/= 0))
    val unaligned = if(!catchUnaligned) False else stagePipe((1 to log2Up(p.cpuDataBytes)).map(i => stageA.request.size === i && io.cpu.memory.address(i-1 downto 0) =/= 0).orR)
    val waysHitsBeforeInvalidate = if(earlyWaysHits) stagePipe(B(stageA.wayHits)) else B(tagsReadRsp.map(tag => mmuRsp.physicalAddress(tagRange) === tag.address && tag.valid).asBits())
    val waysHits = waysHitsBeforeInvalidate & ~wayInvalidate
    val waysHit = waysHits.orR
    val dataMux = if(earlyDataMux) stagePipe(stageA.dataMux) else MuxOH(waysHits, dataReadRsp)
    val mask = stagePipe(stageA.mask)

    //Loader interface
    val loaderValid = False

    val ioMemRspMuxed = io.mem.rsp.data.subdivideIn(cpuDataWidth bits).read(io.cpu.writeBack.address(memWordToCpuWordRange))

    io.cpu.writeBack.haltIt := True

    //Evict the cache after reset logics
    val flusher = new Area {
      val waitDone = RegInit(False) clearWhen(io.cpu.flush.ready)
      val hold = False
      val counter = Reg(UInt(lineRange.size + 1 bits)) init(0)
      when(!counter.msb) {
        tagsWriteCmd.valid := True
        tagsWriteCmd.address := counter.resized
        tagsWriteCmd.way.setAll()
        tagsWriteCmd.data.valid := False
        io.cpu.execute.haltIt := True
        when(!hold) {
          counter := counter + 1
          when(io.cpu.flush.valid && io.cpu.flush.singleLine){
            counter.msb := True
          }
        }
      }

      io.cpu.flush.ready := waitDone && counter.msb

      val start = RegInit(True) //Used to relax timings
      start := !waitDone && !start && io.cpu.flush.valid && !io.cpu.execute.isValid && !io.cpu.memory.isValid && !io.cpu.writeBack.isValid && !io.cpu.redo

      when(start){
        waitDone := True
        counter := 0
        when(io.cpu.flush.valid && io.cpu.flush.singleLine){
          counter := U"0" @@ io.cpu.flush.lineId
        }
      }
    }

    val lrSc = withInternalLrSc generate new Area{
      val reserved = RegInit(False)
      when(io.cpu.writeBack.isValid && io.cpu.writeBack.isFiring){
        reserved setWhen(request.isLrsc)
        reserved clearWhen(request.wr)
      }
    }

    val isAmo = if(withAmo) request.isAmo else False
    val isAmoCached = if(withInternalAmo) isAmo else False
    val isExternalLsrc = if(withExternalLrSc) request.isLrsc else False
    val isExternalAmo  = if(withExternalAmo)  request.isAmo  else False

    val requestDataBypass = CombInit(io.cpu.writeBack.storeData)
    import DataCacheExternalAmoStates._
    val amo = withAmo generate new Area{
      def rf = io.cpu.writeBack.storeData(p.rfDataWidth-1 downto 0)
      def memLarger = if(withInternalAmo) dataMux else ioMemRspMuxed
      def mem = memLarger.subdivideIn(rfDataWidth bits).read(io.cpu.writeBack.address(cpuWordToRfWordRange))
      val compare = request.amoCtrl.alu.msb
      val unsigned = request.amoCtrl.alu(2 downto 1) === B"11"
      val addSub = (rf.asSInt + Mux(compare, ~mem, mem).asSInt + Mux(compare, S(1), S(0))).asBits
      val less = Mux(rf.msb === mem.msb, addSub.msb, Mux(unsigned, mem.msb, rf.msb))
      val selectRf = request.amoCtrl.swap ? True | (request.amoCtrl.alu.lsb ^ less)

      val result = (request.amoCtrl.alu | (request.amoCtrl.swap ## B"00")).mux(
        B"000"  -> addSub,
        B"001"  -> (rf ^ mem),
        B"010"  -> (rf | mem),
        B"011"  -> (rf & mem),
        default -> (selectRf ? rf | mem)
      )
      //      val resultRegValid = RegNext(True) clearWhen(!io.cpu.writeBack.isStuck)
      //      val resultReg = RegNext(result)
      val resultReg = Reg(Bits(32 bits))

      val internal = withInternalAmo generate new Area{
        val resultRegValid = RegNext(io.cpu.writeBack.isStuck)
        resultReg := result
      }
      val external = !withInternalAmo generate new Area{
        val state = RegInit(LR_CMD)
      }
    }


    val cpuWriteToCache = False
    when(cpuWriteToCache){
      dataWriteCmd.valid setWhen(request.wr && waysHit)
      dataWriteCmd.address := mmuRsp.physicalAddress(lineRange.high downto memWordRange.low)
      dataWriteCmd.data.subdivideIn(cpuDataWidth bits).foreach(_ := requestDataBypass)
      dataWriteCmd.mask := 0
      dataWriteCmd.mask.subdivideIn(cpuDataWidth/8 bits).write(io.cpu.writeBack.address(memWordToCpuWordRange), mask)
      dataWriteCmd.way := waysHits
    }

    val badPermissions = (!mmuRsp.allowWrite && request.wr) || (!mmuRsp.allowRead && (!request.wr || isAmo))
    val loadStoreFault = io.cpu.writeBack.isValid && (mmuRsp.exception || badPermissions)
    
    io.cpu.redo := False
    io.cpu.writeBack.accessError := False
    io.cpu.writeBack.mmuException :=  loadStoreFault && (if(catchIllegal) mmuRsp.isPaging else False)
    io.cpu.writeBack.unalignedAccess := io.cpu.writeBack.isValid && unaligned
    io.cpu.writeBack.isWrite := request.wr


    io.mem.cmd.valid := False
    io.mem.cmd.address := mmuRsp.physicalAddress
    io.mem.cmd.last := True
    io.mem.cmd.wr := request.wr
    io.mem.cmd.mask := mask
    io.mem.cmd.data := requestDataBypass
    io.mem.cmd.uncached := mmuRsp.isIoAccess
    io.mem.cmd.size := request.size.resized
    if(withExternalLrSc) io.mem.cmd.exclusive := request.isLrsc || isAmo


    val bypassCache = mmuRsp.isIoAccess || isExternalLsrc || isExternalAmo

    io.cpu.writeBack.keepMemRspData := False
    when(io.cpu.writeBack.isValid) {
      when(isExternalAmo){
        if(withExternalAmo) switch(amo.external.state){
          is(LR_CMD){
            io.mem.cmd.valid := True
            io.mem.cmd.wr := False
            when(io.mem.cmd.ready) {
              amo.external.state := LR_RSP
            }
          }
          is(LR_RSP){
            when(io.mem.rsp.valid && pending.last) {
              amo.external.state := SC_CMD
              amo.resultReg := amo.result
            }
          }
          is(SC_CMD){
            io.mem.cmd.valid := True
            when(io.mem.cmd.ready) {
              amo.external.state := SC_RSP
            }
          }
          is(SC_RSP){
            io.cpu.writeBack.keepMemRspData := True
            when(io.mem.rsp.valid) {
              amo.external.state := LR_CMD
              when(io.mem.rsp.exclusive){ //Success
                cpuWriteToCache := True
                io.cpu.writeBack.haltIt := False
              }
            }
          }
        }
      } elsewhen(mmuRsp.isIoAccess || isExternalLsrc) {
        val waitResponse = !request.wr
        if(withExternalLrSc) waitResponse setWhen(request.isLrsc)

        io.cpu.writeBack.haltIt.clearWhen(waitResponse ? (io.mem.rsp.valid && rspSync) | io.mem.cmd.ready)

        io.mem.cmd.valid := !memCmdSent

        if(withInternalLrSc) when(request.isLrsc && !lrSc.reserved){
          io.mem.cmd.valid := False
          io.cpu.writeBack.haltIt := False
        }
      } otherwise {
        when(waysHit || request.wr && !isAmoCached) {   //Do not require a cache refill ?
          cpuWriteToCache := True

          //Write through
          io.mem.cmd.valid setWhen(request.wr)
          io.cpu.writeBack.haltIt clearWhen(!request.wr || io.mem.cmd.ready)

          if(withInternalAmo) when(isAmo){
            when(!amo.internal.resultRegValid) {
              io.mem.cmd.valid := False
              dataWriteCmd.valid := False
              io.cpu.writeBack.haltIt := True
            }
          }

          //On write to read dataColisions
          when((!request.wr || isAmoCached) && (dataColisions & waysHits) =/= 0){
            io.cpu.redo := True
            if(withAmo) io.mem.cmd.valid := False
          }

          if(withInternalLrSc) when(request.isLrsc && !lrSc.reserved){
            io.mem.cmd.valid := False
            dataWriteCmd.valid := False
            io.cpu.writeBack.haltIt := False
          }
        } otherwise { //Do refill
          //Emit cmd
          io.mem.cmd.valid setWhen(!memCmdSent)
          io.mem.cmd.wr := False
          io.mem.cmd.address(0, lineRange.low bits) := 0
          io.mem.cmd.size := log2Up(p.bytePerLine)

          loaderValid setWhen(io.mem.cmd.ready)
        }
      }
    }

    when(bypassCache){
      io.cpu.writeBack.data := ioMemRspMuxed
      def isLast = if(pending != null) pending.last else True
      if(catchAccessError) io.cpu.writeBack.accessError := !request.wr && isLast && io.mem.rsp.valid && io.mem.rsp.error
    } otherwise {
      io.cpu.writeBack.data := dataMux
      if(catchAccessError) io.cpu.writeBack.accessError := (waysHits & B(tagsReadRsp.map(_.error))) =/= 0 || (loadStoreFault && !mmuRsp.isPaging)
    }

    if(withLrSc) {
      val success = if(withInternalLrSc)lrSc.reserved else io.mem.rsp.exclusive
      io.cpu.writeBack.exclusiveOk := success
      when(request.isLrsc && request.wr){
        //      io.cpu.writeBack.data := B(!success).resized
        if(withExternalLrSc) when(io.cpu.writeBack.isValid && io.mem.rsp.valid && rspSync && success && waysHit){
          cpuWriteToCache := True
        }
      }
    }
    if(withAmo) when(request.isAmo){
      requestDataBypass.subdivideIn(p.rfDataWidth bits).foreach(_ := amo.resultReg)
    }

    //remove side effects on exceptions
    when(io.cpu.writeBack.isValid) {
      when(consistancyHazard || mmuRsp.refilling || io.cpu.writeBack.accessError || io.cpu.writeBack.mmuException || io.cpu.writeBack.unalignedAccess) {
        io.mem.cmd.valid := False
        tagsWriteCmd.valid := False
        dataWriteCmd.valid := False
        loaderValid := False
        io.cpu.writeBack.haltIt := False
        if (withInternalLrSc) lrSc.reserved := lrSc.reserved
        if (withExternalAmo) amo.external.state := LR_CMD
      }
      io.cpu.redo setWhen((mmuRsp.refilling || consistancyHazard))
    }

    assert(!(io.cpu.writeBack.isValid && !io.cpu.writeBack.haltIt && io.cpu.writeBack.isStuck), "writeBack stuck by another plugin is not allowed", ERROR)
  }

  val loader = new Area{
    val valid = RegInit(False) setWhen(stageB.loaderValid)
    val baseAddress =  stageB.mmuRsp.physicalAddress

    val counter = Counter(memTransactionPerLine)
    val waysAllocator = Reg(Bits(wayCount bits)) init(1)
    val error = RegInit(False)
    val kill = False
    val killReg = RegInit(False) setWhen(kill)

    when(valid && io.mem.rsp.valid && rspLast){
      dataWriteCmd.valid := True
      dataWriteCmd.address := baseAddress(lineRange) @@ counter
      dataWriteCmd.data := io.mem.rsp.data
      dataWriteCmd.mask.setAll()
      dataWriteCmd.way := waysAllocator
      error := error | io.mem.rsp.error
      counter.increment()
    }

    val done = CombInit(counter.willOverflow)
    if(withInvalidate) done setWhen(valid && pending.counter === 0) //Used to solve invalidate write request at the same time

    when(done){
      valid := False

      //Update tags
      tagsWriteCmd.valid := True
      tagsWriteCmd.address := baseAddress(lineRange)
      tagsWriteCmd.data.valid := !(kill || killReg)
      tagsWriteCmd.data.address := baseAddress(tagRange)
      tagsWriteCmd.data.error := error || (io.mem.rsp.valid && io.mem.rsp.error)
      tagsWriteCmd.way := waysAllocator

      error := False
      killReg := False
    }

    when(!valid){
      waysAllocator := (waysAllocator ## waysAllocator.msb).resized
    }

    io.cpu.redo setWhen(valid.rise())
    io.cpu.execute.refilling := valid

    stageB.mmuRspFreeze setWhen(stageB.loaderValid || valid)
  }

  val invalidate = withInvalidate generate new Area{
    val s0 = new Area{
      val input = io.mem.inv
      tagsInvReadCmd.valid := input.fire
      tagsInvReadCmd.payload := input.address(lineRange)

      val loaderTagHit = input.address(tagRange) === loader.baseAddress(tagRange)
      val loaderLineHit =  input.address(lineRange) === loader.baseAddress(lineRange)
      when(input.valid && input.enable && loader.valid && loaderLineHit && loaderTagHit){
        loader.kill := True
      }
    }
    val s1 = new Area{
      val input = s0.input.stage()
      val loaderValid = RegNextWhen(loader.valid, s0.input.ready)
      val loaderWay = RegNextWhen(loader.waysAllocator, s0.input.ready)
      val loaderTagHit = RegNextWhen(s0.loaderTagHit, s0.input.ready)
      val loaderLineHit = RegNextWhen(s0.loaderLineHit, s0.input.ready)
      val invalidations = Bits(wayCount bits)

      var wayHits = B(ways.map(way => (input.address(tagRange) === way.tagsInvReadRsp.address && way.tagsInvReadRsp.valid))) & ~invalidations

      //Handle invalider read during loader write hazard
      when(loaderValid && loaderLineHit && !loaderTagHit){
        wayHits \= wayHits & ~loaderWay
      }
    }
    val s2 = new Area{
      val input = s1.input.stage()
      val wayHits = RegNextWhen(s1.wayHits, s1.input.ready)
      val wayHit = wayHits.orR

      when(input.valid && input.enable) {
        //Manage invalidate write during cpu read hazard
        when(input.address(lineRange) === io.cpu.execute.address(lineRange)) {
          stage0.wayInvalidate := wayHits
        }

        //Invalidate cache tag
        when(wayHit) {
          tagsWriteCmd.valid := True
          stageB.flusher.hold := True
          tagsWriteCmd.address := input.address(lineRange)
          tagsWriteCmd.data.valid := False
          tagsWriteCmd.way := wayHits
          loader.done := False //Hold loader tags write
        }
      }
      io.mem.ack.arbitrationFrom(input)
      io.mem.ack.hit := wayHit
      io.mem.ack.last := input.last

      //Manage invalidation read during write hazard
      s1.invalidations := RegNextWhen((input.valid && input.enable && input.address(lineRange) === s0.input.address(lineRange)) ? wayHits | 0, s0.input.ready)
    }
  }
}
