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
                           pendingMax : Int = 64,
                           mergeExecuteMemory : Boolean = false){
  assert(!(mergeExecuteMemory && (earlyDataMux || earlyWaysHits)))
  assert(!(earlyDataMux && !earlyWaysHits))
  def withWriteResponse = withExclusive
  def burstSize = bytePerLine*8/memDataWidth
  val burstLength = bytePerLine/(memDataWidth/8)
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
  val totalyConsistent = Bool()

  override def asMaster(): Unit = {
    out(isValid, args, address, totalyConsistent)
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
}

case class DataCacheCpuMemory(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val isStuck = Bool
  val isRemoved = Bool
  val isWrite = Bool
  val address = UInt(p.addressWidth bit)
  val mmuBus  = MemoryTranslatorBus()
  val fenceValid = Bool()

  override def asMaster(): Unit = {
    out(isValid, isStuck, isRemoved, address, fenceValid)
    in(isWrite)
    slave(mmuBus)
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
  val fenceValid = Bool()
  val fenceFire = Bool()

  //  val exceptionBus = if(p.catchSomething) Flow(ExceptionCause()) else null

  override def asMaster(): Unit = {
    out(isValid,isStuck,isUser, address, fenceValid, fenceFire)
    in(haltIt, data, mmuException, unalignedAccess, accessError, isWrite, keepMemRspData)
  }
}

case class DataCacheCpuBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val execute   = DataCacheCpuExecute(p)
  val memory    = DataCacheCpuMemory(p)
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
  val address = UInt(p.addressWidth bit)
  val data = Bits(p.memDataWidth bits)
  val mask = Bits(p.memDataWidth/8 bits)
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
class DataCache(val p : DataCacheConfig) extends Component{
  import p._
  assert(cpuDataWidth == memDataWidth)

  val io = new Bundle{
    val cpu = slave(DataCacheCpuBus(p))
    val mem = master(DataCacheMemBus(p))
  }

  val haltCpu = False
  val lineWidth = bytePerLine*8
  val lineCount = cacheSize/bytePerLine
  val wordWidth = Math.max(memDataWidth,cpuDataWidth)
  val wordWidthLog2 = log2Up(wordWidth)
  val wordPerLine = lineWidth/wordWidth
  val bytePerWord = wordWidth/8
  val wayLineCount = lineCount/wayCount
  val wayLineLog2 = log2Up(wayLineCount)
  val wayWordCount = wayLineCount * wordPerLine
  val memTransactionPerLine = p.bytePerLine / (p.memDataWidth/8)

  val tagRange = addressWidth-1 downto log2Up(wayLineCount*bytePerLine)
  val lineRange = tagRange.low-1 downto log2Up(bytePerLine)
  val wordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerWord)
  val hitRange = tagRange.high downto lineRange.low


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

  val dataReadCmd =  Flow(UInt(log2Up(wayWordCount) bits))
  val dataWriteCmd = Flow(new Bundle{
    val way = Bits(wayCount bits)
    val address = UInt(log2Up(wayWordCount) bits)
    val data = Bits(wordWidth bits)
    val mask = Bits(wordWidth/8 bits)
  })



  val ways = for(i <- 0 until wayCount) yield new Area{
    val tags = Mem(new LineInfo(), wayLineCount)
    val data = Mem(Bits(wordWidth bit), wayWordCount)

    //Reads
    val tagsReadRsp = tags.readSync(tagsReadCmd.payload, tagsReadCmd.valid && !io.cpu.memory.isStuck)
    val dataReadRsp = data.readSync(dataReadCmd.payload, dataReadCmd.valid && !io.cpu.memory.isStuck)

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
    dataReadCmd.payload := io.cpu.execute.address(lineRange.high downto wordRange.low)
  }

  def collisionProcess(readAddress : UInt, readMask : Bits): Bits ={
    val ret = Bits(wayCount bits)
    for(i <- 0 until wayCount){
      ret(i) := dataWriteCmd.valid && dataWriteCmd.way(i) && dataWriteCmd.address === readAddress && (readMask & dataWriteCmd.mask) =/= 0
    }
    ret
  }


  io.cpu.execute.haltIt := False

  val rspSync = True
  val rspLast = True
  val memCmdSent = RegInit(False) setWhen (io.mem.cmd.ready) clearWhen (!io.cpu.writeBack.isStuck)
  val pending = withExclusive generate new Area{
    val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
    counter := counter + U(io.mem.cmd.fire && io.mem.cmd.last) - U(io.mem.rsp.valid  && io.mem.rsp.last)

    val done = counter === 0
    val full = RegNext(counter.msb)
    val last = counter === 1

    if(!withInvalidate) {
      io.cpu.execute.haltIt setWhen(full)
    }

    rspSync clearWhen (!last || !memCmdSent)
    rspLast clearWhen (!last)
  }

  val sync = withInvalidate generate new Area{
    io.mem.sync.ready := True

    val pendingSync = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
    val pendingSyncNext = pendingSync + U(io.mem.cmd.fire && io.mem.cmd.wr) - U(io.mem.sync.fire)
    pendingSync := pendingSyncNext

    val full = RegNext(pendingSync.msb)
    io.cpu.execute.haltIt setWhen(full)


    val incoerentSync = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
    incoerentSync := incoerentSync - U(io.mem.sync.fire && incoerentSync =/= 0)
    when(io.cpu.writeBack.fenceValid){ incoerentSync := pendingSyncNext }


    val totalyConsistent = pendingSync === 0
    val fenceConsistent = incoerentSync === 0
  }




  val stage0 = new Area{
    val mask = io.cpu.execute.size.mux (
      U(0)    -> B"0001",
      U(1)    -> B"0011",
      default -> B"1111"
    ) |<< io.cpu.execute.address(1 downto 0)
    val dataColisions = collisionProcess(io.cpu.execute.address(lineRange.high downto wordRange.low), mask)
    val wayInvalidate = B(0, wayCount bits) //Used if invalidate enabled

    val isAmo = if(withAmo) io.cpu.execute.isAmo else False

    //Ensure write to read consistency
    val consistancyIssue = False
    val consistancyCheck = (withInvalidate || withWriteResponse) generate new Area {
      val fenceConsistent =  (if(withInvalidate) sync.fenceConsistent else pending.done) && !io.cpu.writeBack.fenceValid && (if(mergeExecuteMemory) True else !io.cpu.memory.fenceValid) //Pessimistic fence tracking
      val totalyConsistent = (if(withInvalidate) sync.totalyConsistent else pending.done) && (if(mergeExecuteMemory) True else !(io.cpu.memory.isValid && io.cpu.memory.isWrite)) && !(io.cpu.writeBack.isValid && io.cpu.memory.isWrite)
      when(io.cpu.execute.isValid /*&& (!io.cpu.execute.args.wr || isAmo)*/){
        when(!fenceConsistent || io.cpu.execute.totalyConsistent && !totalyConsistent){
          consistancyIssue := True
        }
      }
    }
  }

  val stageA = new Area{
    def stagePipe[T <: Data](that : T) = if(mergeExecuteMemory) CombInit(that) else RegNextWhen(that, !io.cpu.memory.isStuck)
    val request = stagePipe(io.cpu.execute.args)
    val mask = stagePipe(stage0.mask)
    io.cpu.memory.mmuBus.cmd.isValid := io.cpu.memory.isValid
    io.cpu.memory.mmuBus.cmd.virtualAddress := io.cpu.memory.address
    io.cpu.memory.mmuBus.cmd.bypassTranslation := False
    io.cpu.memory.mmuBus.end := !io.cpu.memory.isStuck || io.cpu.memory.isRemoved
    io.cpu.memory.isWrite := request.wr

    val wayHits = earlyWaysHits generate ways.map(way => (io.cpu.memory.mmuBus.rsp.physicalAddress(tagRange) === way.tagsReadRsp.address && way.tagsReadRsp.valid))
    val dataMux = earlyDataMux generate MuxOH(wayHits, ways.map(_.dataReadRsp))
    val wayInvalidate = stagePipe(stage0. wayInvalidate)
    val consistancyIssue = stagePipe(stage0.consistancyIssue)
    val dataColisions = if(mergeExecuteMemory){
      stagePipe(stage0.dataColisions)
    } else {
      //Assume the writeback stage will never be unstall memory acces while memory stage is stalled
      stagePipe(stage0.dataColisions) | collisionProcess(io.cpu.memory.address(lineRange.high downto wordRange.low), mask)
    }
  }

  val stageB = new Area {
    def stagePipe[T <: Data](that : T) = RegNextWhen(that, !io.cpu.writeBack.isStuck)
    def ramPipe[T <: Data](that : T) = if(mergeExecuteMemory) CombInit(that) else  RegNextWhen(that, !io.cpu.writeBack.isStuck)
    val request = RegNextWhen(stageA.request, !io.cpu.writeBack.isStuck)
    val mmuRspFreeze = False
    val mmuRsp = RegNextWhen(io.cpu.memory.mmuBus.rsp, !io.cpu.writeBack.isStuck && !mmuRspFreeze)
    val tagsReadRsp = ways.map(w => ramPipe(w.tagsReadRsp))
    val dataReadRsp = !earlyDataMux generate ways.map(w => ramPipe(w.dataReadRsp))
    val wayInvalidate = stagePipe(stageA. wayInvalidate)
    val consistancyIssue = stagePipe(stageA.consistancyIssue)
    val dataColisions = stagePipe(stageA.dataColisions)
    val waysHitsBeforeInvalidate = if(earlyWaysHits) stagePipe(B(stageA.wayHits)) else B(tagsReadRsp.map(tag => mmuRsp.physicalAddress(tagRange) === tag.address && tag.valid).asBits())
    val waysHits = waysHitsBeforeInvalidate & ~wayInvalidate
    val waysHit = waysHits.orR
    val dataMux = if(earlyDataMux) stagePipe(stageA.dataMux) else MuxOH(waysHits, dataReadRsp)
    val mask = stagePipe(stageA.mask)

    //Loader interface
    val loaderValid = False



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
      def mem = if(withInternalAmo) dataMux else io.mem.rsp.data
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
      dataWriteCmd.address := mmuRsp.physicalAddress(lineRange.high downto wordRange.low)
      dataWriteCmd.data := requestDataBypass
      dataWriteCmd.mask := mask
      dataWriteCmd.way := waysHits
    }

    io.cpu.redo := False
    io.cpu.writeBack.accessError := False
    io.cpu.writeBack.mmuException := io.cpu.writeBack.isValid && (if(catchIllegal) mmuRsp.exception || (!mmuRsp.allowWrite && request.wr) || (!mmuRsp.allowRead && (!request.wr || isAmo)) else False)
    io.cpu.writeBack.unalignedAccess := io.cpu.writeBack.isValid && (if(catchUnaligned) ((request.size === 2 && mmuRsp.physicalAddress(1 downto 0) =/= 0) || (request.size === 1 && mmuRsp.physicalAddress(0 downto 0) =/= 0)) else False)
    io.cpu.writeBack.isWrite := request.wr

    io.mem.cmd.valid := False
    io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto wordRange.low) @@ U(0, wordRange.low bit)
    io.mem.cmd.length := 0
    io.mem.cmd.last := True
    io.mem.cmd.wr := request.wr
    io.mem.cmd.mask := mask
    io.mem.cmd.data := requestDataBypass
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
          io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto wordRange.low) @@ U(0, wordRange.low bit)
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
      io.cpu.writeBack.data :=  io.mem.rsp.data
      if(catchAccessError) io.cpu.writeBack.accessError := io.mem.rsp.valid && io.mem.rsp.error
    } otherwise {
      io.cpu.writeBack.data :=  dataMux
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
    when(consistancyIssue || mmuRsp.refilling || io.cpu.writeBack.accessError || io.cpu.writeBack.mmuException || io.cpu.writeBack.unalignedAccess){
      io.mem.cmd.valid := False
      tagsWriteCmd.valid := False
      dataWriteCmd.valid := False
      loaderValid := False
      io.cpu.writeBack.haltIt := False
      if(withInternalLrSc) lrSc.reserved := lrSc.reserved
      if(withExternalAmo) amo.external.state := LR_CMD
    }
    io.cpu.redo setWhen(io.cpu.writeBack.isValid && (mmuRsp.refilling || consistancyIssue))

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