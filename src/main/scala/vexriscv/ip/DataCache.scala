package vexriscv.ip

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4Shared}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbParameter}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.plugin.DBusSimpleBus


case class DataCacheConfig(cacheSize : Int,
                           bytePerLine : Int,
                           wayCount : Int,
                           addressWidth : Int,
                           cpuDataWidth : Int,
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
                           pendingMax : Int = 32,
                           directTlbHit : Boolean = false,
                           mergeExecuteMemory : Boolean = false){
  assert(!(mergeExecuteMemory && (earlyDataMux || earlyWaysHits)))
  assert(!(earlyDataMux && !earlyWaysHits))
  assert(isPow2(pendingMax))
  def withWriteResponse = withExclusive
  def burstSize = bytePerLine*8/memDataWidth
  val burstLength = bytePerLine/(cpuDataWidth/8)
  def catchSomething = catchUnaligned || catchIllegal || catchAccessError
  def withInternalAmo = withAmo && !withExclusive
  def withInternalLrSc = withLrSc && !withExclusive
  def withExternalLrSc = withLrSc && withExclusive
  def withExternalAmo = withAmo && withExclusive
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

  def getBmbParameter() = BmbParameter(
    addressWidth = 32,
    dataWidth = 32,
    lengthWidth = log2Up(this.bytePerLine),
    sourceWidth = 0,
    contextWidth = if(!withWriteResponse) 1 else 0,
    canRead = true,
    canWrite = true,
    alignment  = BmbParameter.BurstAlignement.LENGTH,
    maximumPendingTransactionPerId = Int.MaxValue,
    canInvalidate = withInvalidate,
    canSync = withInvalidate,
    canExclusive = withExclusive,
    invalidateLength = log2Up(this.bytePerLine),
    invalidateAlignment = BmbParameter.BurstAlignement.LENGTH
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

  override def asMaster(): Unit = {
    out(isValid, args, address)
    in(haltIt)
  }
}

case class DataCacheCpuExecuteArgs(p : DataCacheConfig) extends Bundle{
  val wr = Bool
  val data = Bits(p.cpuDataWidth bit)
  val size = UInt(2 bits)
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
  val isUser = Bool()
  val haltIt = Bool()
  val isWrite = Bool()
  val data = Bits(p.cpuDataWidth bit)
  val address = UInt(p.addressWidth bit)
  val mmuException, unalignedAccess, accessError = Bool()
  val keepMemRspData = Bool() //Used by external AMO to avoid having an internal buffer
  val fence = FenceFlags()

  override def asMaster(): Unit = {
    out(isValid,isStuck,isUser, address, fence)
    in(haltIt, data, mmuException, unalignedAccess, accessError, isWrite, keepMemRspData)
  }
}

case class DataCacheCpuBus(p : DataCacheConfig, mmu : MemoryTranslatorBusParameter) extends Bundle with IMasterSlave{
  val execute   = DataCacheCpuExecute(p)
  val memory    = DataCacheCpuMemory(p, mmu)
  val writeBack = DataCacheCpuWriteBack(p)

  val redo = Bool()
  val flush = Event

  override def asMaster(): Unit = {
    master(execute)
    master(memory)
    master(writeBack)
    master(flush)
    in(redo)
  }
}


case class DataCacheMemCmd(p : DataCacheConfig) extends Bundle{
  val wr = Bool
  val uncached = Bool
  val address = UInt(p.addressWidth bit)
  val data = Bits(p.cpuDataWidth bits)
  val mask = Bits(p.cpuDataWidth/8 bits)
  val length = UInt(log2Up(p.burstLength) bits)
  val exclusive = p.withExclusive generate Bool()
  val last = Bool
}
case class DataCacheMemRsp(p : DataCacheConfig) extends Bundle{
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

}

case class DataCacheMemBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val cmd = Stream (DataCacheMemCmd(p))
  val rsp = Flow (DataCacheMemRsp(p))

  val inv = p.withInvalidate generate Stream(DataCacheInv(p))
  val ack = p.withInvalidate generate Stream(DataCacheAck(p))
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
    val axi = Axi4Shared(p.getAxi4SharedConfig())

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
    axi.sharedCmd.size := log2Up(p.memDataWidth/8)
    axi.sharedCmd.addr := cmdStage.address
    axi.sharedCmd.len  := cmdStage.length.resized

    axi.writeData.arbitrationFrom(dataStage)
    axi.writeData.data := dataStage.data
    axi.writeData.strb := dataStage.mask
    axi.writeData.last := dataStage.last

    rsp.valid := axi.r.valid
    rsp.error := !axi.r.isOKAY()
    rsp.data := axi.r.data

    axi.r.ready := True
    axi.b.ready := True


    //TODO remove
    val axi2 = cloneOf(axi)
    //    axi.arw >/-> axi2.arw
    //    axi.w >/-> axi2.w
    //    axi.r <-/< axi2.r
    //    axi.b <-/< axi2.b
    axi2 << axi
    axi2
  }


  def toAvalon(): AvalonMM = {
    val avalonConfig = p.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)
    mm.read := cmd.valid && !cmd.wr
    mm.write := cmd.valid && cmd.wr
    mm.address := cmd.address(cmd.address.high downto log2Up(p.memDataWidth/8)) @@ U(0,log2Up(p.memDataWidth/8) bits)
    mm.burstCount := cmd.length + U(1, widthOf(mm.burstCount) bits)
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

    val cmdBridge = Stream (DataCacheMemCmd(p))
    val isBurst = cmdBridge.length =/= 0
    cmdBridge.valid := cmd.valid
    cmdBridge.address := (isBurst ? (cmd.address(31 downto widthOf(counter) + 2) @@ counter @@ U"00") | (cmd.address(31 downto 2) @@ U"00"))
    cmdBridge.wr := cmd.wr
    cmdBridge.mask := cmd.mask
    cmdBridge.data := cmd.data
    cmdBridge.length := cmd.length
    cmdBridge.last := counter === cmd.length
    cmd.ready := cmdBridge.ready && (cmdBridge.wr || cmdBridge.last)


    when(cmdBridge.fire){
      counter := counter + 1
      when(cmdBridge.last){
        counter := 0
      }
    }


    bus.ADR := cmdBridge.address >> 2
    bus.CTI := Mux(isBurst, cmdBridge.last ? B"111" | B"010", B"000")
    bus.BTE := B"00"
    bus.SEL := cmdBridge.wr ? cmdBridge.mask | B"1111"
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
    cmd.ready := bus.cmd.ready && (cmd.wr || counter === cmd.length)
    rsp.valid := bus.rsp.valid
    rsp.data  := bus.rsp.payload.data
    rsp.error := False
    bus
  }


  def toBmb() : Bmb = {
    val pipelinedMemoryBusConfig = p.getBmbParameter()
    val bus = Bmb(pipelinedMemoryBusConfig).setCompositeName(this,"toBmb", true)

    bus.cmd.valid := cmd.valid
    bus.cmd.last := cmd.last
    if(!p.withWriteResponse) bus.cmd.context(0) := cmd.wr
    bus.cmd.opcode := (cmd.wr ? B(Bmb.Cmd.Opcode.WRITE) | B(Bmb.Cmd.Opcode.READ))
    bus.cmd.address := cmd.address.resized
    bus.cmd.data := cmd.data
    bus.cmd.length := (cmd.length << 2) | 3 //TODO better sub word access
    bus.cmd.mask := cmd.mask
    if(p.withExclusive) bus.cmd.exclusive := cmd.exclusive

    cmd.ready := bus.cmd.ready

    rsp.valid := bus.rsp.valid
    if(!p.withWriteResponse) rsp.valid clearWhen(bus.rsp.context(0))
    rsp.data  := bus.rsp.data
    rsp.error := bus.rsp.isError
    rsp.last := bus.rsp.last
    if(p.withExclusive) rsp.exclusive := bus.rsp.exclusive
    bus.rsp.ready := True

    if(p.withInvalidate){
      inv.arbitrationFrom(bus.inv)
      inv.address := bus.inv.address
      inv.enable  := bus.inv.all

      bus.ack.arbitrationFrom(ack)

      sync.arbitrationFrom(bus.sync)

//      bus.ack.arbitrationFrom(ack)
//      //TODO manage lenght ?
//      inv.address := bus.inv.address
////      inv.opcode := bus.inv.opcode
//      ???
//
//      bus.ack.arbitrationFrom(ack)
    }


    bus
  }

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
    val tagsReadRsp = tags.readSync(tagsReadCmd.payload, tagsReadCmd.valid && !io.cpu.memory.isStuck)
    val dataReadRspMem = data.readSync(dataReadCmd.payload, dataReadCmd.valid && !io.cpu.memory.isStuck)
    val dataReadRspSel = if(mergeExecuteMemory) io.cpu.writeBack.address else io.cpu.memory.address
    val dataReadRsp = dataReadRspMem.subdivideIn(cpuDataWidth bits).read(dataReadRspSel(memWordToCpuWordRange))

    val tagsInvReadRsp = withInvalidate generate tags.readSync(tagsInvReadCmd.payload, tagsInvReadCmd.valid)

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
  val memCmdSent = RegInit(False) setWhen (io.mem.cmd.ready) clearWhen (!io.cpu.writeBack.isStuck)
  val pending = withExclusive generate new Area{
    val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
    val counterNext = counter + U(io.mem.cmd.fire && io.mem.cmd.last) - U(io.mem.rsp.valid  && io.mem.rsp.last)
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

    val syncContext = new Area{
      val history = Mem(Bool, pendingMax)
      val wPtr, rPtr = Reg(UInt(log2Up(pendingMax)+1 bits)) init(0)
      when(io.mem.cmd.fire && io.mem.cmd.wr){
        history.write(wPtr.resized, io.mem.cmd.uncached)
        wPtr := wPtr + 1
      }

      when(io.mem.sync.fire){
        rPtr := rPtr + 1
      }
      val uncached = history.readAsync(rPtr.resized)
      val full = RegNext(wPtr - rPtr >= pendingMax-1)
      io.cpu.execute.haltIt setWhen(full)
    }

    def pending(inc : Bool, dec : Bool) = new Area {
      val pendingSync = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
      val pendingSyncNext = pendingSync + U(io.mem.cmd.fire && io.mem.cmd.wr && inc) - U(io.mem.sync.fire && dec)
      pendingSync := pendingSyncNext
    }

    val writeCached = pending(inc = !io.mem.cmd.uncached, dec = !syncContext.uncached)
    val writeUncached = pending(inc = io.mem.cmd.uncached, dec = syncContext.uncached)

    def track(load : Bool, uncached : Boolean) = new Area {
      val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
      counter := counter - U(io.mem.sync.fire && counter =/= 0 && (if(uncached) syncContext.uncached else !syncContext.uncached))
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
    val mask = io.cpu.execute.size.mux (
      U(0)    -> B"0001",
      U(1)    -> B"0011",
      default -> B"1111"
    ) |<< io.cpu.execute.address(1 downto 0)
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
    val waysHitsBeforeInvalidate = if(earlyWaysHits) stagePipe(B(stageA.wayHits)) else B(tagsReadRsp.map(tag => mmuRsp.physicalAddress(tagRange) === tag.address && tag.valid).asBits())
    val waysHits = waysHitsBeforeInvalidate & ~wayInvalidate
    val waysHit = waysHits.orR
    val dataMux = if(earlyDataMux) stagePipe(stageA.dataMux) else MuxOH(waysHits, dataReadRsp)
    val mask = stagePipe(stageA.mask)

    //Loader interface
    val loaderValid = False

    val ioMemRspMuxed = io.mem.rsp.data.subdivideIn(cpuDataWidth bits).read(io.cpu.writeBack.address(memWordToCpuWordRange))

    io.cpu.writeBack.haltIt := io.cpu.writeBack.isValid

    //Evict the cache after reset logics
    val flusher = new Area {
      val valid = RegInit(False)
      val hold = False
      when(valid) {
        tagsWriteCmd.valid := valid
        tagsWriteCmd.address := mmuRsp.physicalAddress(lineRange)
        tagsWriteCmd.way.setAll()
        tagsWriteCmd.data.valid := False
        io.cpu.writeBack.haltIt := True
        when(!hold) {
          when(mmuRsp.physicalAddress(lineRange) =/= wayLineCount - 1) {
            mmuRsp.physicalAddress.getDrivingReg(lineRange) := mmuRsp.physicalAddress(lineRange) + 1
          } otherwise {
            valid := False
          }
        }
      }

      io.cpu.flush.ready := False
      val start = RegInit(True) //Used to relax timings
      start := !start && io.cpu.flush.valid && !io.cpu.execute.isValid && !io.cpu.memory.isValid && !io.cpu.writeBack.isValid && !io.cpu.redo

      when(start){
        io.cpu.flush.ready := True
        mmuRsp.physicalAddress.getDrivingReg(lineRange) := 0
        valid := True
      }
    }

    val lrSc = withInternalLrSc generate new Area{
      val reserved = RegInit(False)
      when(io.cpu.writeBack.isValid && !io.cpu.writeBack.isStuck && request.isLrsc){
        reserved := !request.wr
      }
    }

    val isAmo = if(withAmo) request.isAmo else False
    val isAmoCached = if(withInternalAmo) isAmo else False
    val isExternalLsrc = if(withExternalLrSc) request.isLrsc else False
    val isExternalAmo  = if(withExternalAmo)  request.isAmo  else False

    val requestDataBypass = CombInit(request.data)
    import DataCacheExternalAmoStates._
    val amo = withAmo generate new Area{
      def rf = request.data
      def mem = if(withInternalAmo) dataMux else ioMemRspMuxed
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

    io.cpu.redo := False
    io.cpu.writeBack.accessError := False
    io.cpu.writeBack.mmuException := io.cpu.writeBack.isValid && (if(catchIllegal) mmuRsp.exception || (!mmuRsp.allowWrite && request.wr) || (!mmuRsp.allowRead && (!request.wr || isAmo)) else False)
    io.cpu.writeBack.unalignedAccess := io.cpu.writeBack.isValid && (if(catchUnaligned) ((request.size === 2 && mmuRsp.physicalAddress(1 downto 0) =/= 0) || (request.size === 1 && mmuRsp.physicalAddress(0 downto 0) =/= 0)) else False)
    io.cpu.writeBack.isWrite := request.wr

    io.mem.cmd.valid := False
    io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto cpuWordRange.low) @@ U(0, cpuWordRange.low bits)
    io.mem.cmd.length := 0
    io.mem.cmd.last := True
    io.mem.cmd.wr := request.wr
    io.mem.cmd.mask := mask
    io.mem.cmd.data := requestDataBypass
    io.mem.cmd.uncached := mmuRsp.isIoAccess
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
          io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto cpuWordRange.low) @@ U(0, cpuWordRange.low bits)
          io.mem.cmd.length := 0
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
          io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
          io.mem.cmd.length := p.burstLength-1

          loaderValid setWhen(io.mem.cmd.ready)
        }
      }
    }

    when(bypassCache){
      io.cpu.writeBack.data := ioMemRspMuxed
      if(catchAccessError) io.cpu.writeBack.accessError := io.mem.rsp.valid && io.mem.rsp.error
    } otherwise {
      io.cpu.writeBack.data := dataMux
      if(catchAccessError) io.cpu.writeBack.accessError := (waysHits & B(tagsReadRsp.map(_.error))) =/= 0
    }

    if(withLrSc) when(request.isLrsc && request.wr){
      val success = if(withInternalLrSc)lrSc.reserved else io.mem.rsp.exclusive
      io.cpu.writeBack.data := B(!success).resized
      if(withExternalLrSc) when(io.cpu.writeBack.isValid && io.mem.rsp.valid && rspSync && success && waysHit){
        cpuWriteToCache := True
      }
    }
    if(withAmo) when(request.isAmo){
      requestDataBypass := amo.resultReg
    }

    //remove side effects on exceptions
    when(consistancyHazard || mmuRsp.refilling || io.cpu.writeBack.accessError || io.cpu.writeBack.mmuException || io.cpu.writeBack.unalignedAccess){
      io.mem.cmd.valid := False
      tagsWriteCmd.valid := False
      dataWriteCmd.valid := False
      loaderValid := False
      io.cpu.writeBack.haltIt := False
      if(withInternalLrSc) lrSc.reserved := lrSc.reserved
      if(withExternalAmo) amo.external.state := LR_CMD
    }
    io.cpu.redo setWhen(io.cpu.writeBack.isValid && (mmuRsp.refilling || consistancyHazard))

    assert(!(io.cpu.writeBack.isValid && !io.cpu.writeBack.haltIt && io.cpu.writeBack.isStuck), "writeBack stuck by another plugin is not allowed")
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

    io.cpu.redo setWhen(valid)
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

      //Manage invalidation read during write hazard
      s1.invalidations := RegNextWhen((input.valid && input.enable && input.address(lineRange) === s0.input.address(lineRange)) ? wayHits | 0, s0.input.ready)
    }
  }
}