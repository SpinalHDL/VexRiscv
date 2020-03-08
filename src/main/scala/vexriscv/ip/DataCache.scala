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
                           mergeExecuteMemory : Boolean = false){
  assert(!(mergeExecuteMemory && (earlyDataMux || earlyWaysHits)))
  assert(!(earlyDataMux && !earlyWaysHits))
  def burstSize = bytePerLine*8/memDataWidth
  val burstLength = bytePerLine/(memDataWidth/8)
  def catchSomething = catchUnaligned || catchIllegal || catchAccessError

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
    contextWidth = 1,
    canRead = true,
    canWrite = true,
    alignment  = BmbParameter.BurstAlignement.LENGTH,
    maximumPendingTransactionPerId = Int.MaxValue
  )
}

object DataCacheCpuExecute{
  implicit def implArgs(that : DataCacheCpuExecute) = that.args
}

case class DataCacheCpuExecute(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val address = UInt(p.addressWidth bit)
  //  val haltIt = Bool
  val args = DataCacheCpuExecuteArgs(p)

  override def asMaster(): Unit = {
    out(isValid, args, address)
    //    in(haltIt)
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

  override def asMaster(): Unit = {
    out(isValid, isStuck, isRemoved, address)
    in(isWrite)
    slave(mmuBus)
  }
}


case class DataCacheCpuWriteBack(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val isStuck = Bool
  val isUser = Bool
  val haltIt = Bool
  val isWrite = Bool
  val data = Bits(p.cpuDataWidth bit)
  val address = UInt(p.addressWidth bit)
  val mmuException, unalignedAccess , accessError = Bool
  val clearLrsc = ifGen(p.withLrSc) {Bool}

  //  val exceptionBus = if(p.catchSomething) Flow(ExceptionCause()) else null

  override def asMaster(): Unit = {
    out(isValid,isStuck,isUser, address)
    in(haltIt, data, mmuException, unalignedAccess, accessError, isWrite)
    outWithNull(clearLrsc)
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
  val last = Bool
}
case class DataCacheMemRsp(p : DataCacheConfig) extends Bundle{
  val data = Bits(p.memDataWidth bit)
  val error = Bool
}

case class DataCacheMemBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val cmd = Stream (DataCacheMemCmd(p))
  val rsp = Flow (DataCacheMemRsp(p))

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
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
    val bus = Bmb(pipelinedMemoryBusConfig)

    bus.cmd.valid := cmd.valid
    bus.cmd.last := cmd.last
    bus.cmd.context(0) := cmd.wr
    bus.cmd.opcode := (cmd.wr ? B(Bmb.Cmd.Opcode.WRITE) | B(Bmb.Cmd.Opcode.READ))
    bus.cmd.address := cmd.address.resized
    bus.cmd.data := cmd.data
    bus.cmd.length := (cmd.length << 2) | 3 //TODO better sub word access
    bus.cmd.mask := cmd.mask

    cmd.ready := bus.cmd.ready

    rsp.valid := bus.rsp.valid && !bus.rsp.context(0)
    rsp.data  := bus.rsp.data
    rsp.error := bus.rsp.isError
    bus.rsp.ready := True

    bus
  }

}


class DataCache(p : DataCacheConfig) extends Component{
  import p._
  assert(cpuDataWidth == memDataWidth)

  val io = new Bundle{
    val cpu = slave(DataCacheCpuBus(p))
    val mem = master(DataCacheMemBus(p))
    //    val flushDone = out Bool //It pulse at the same time than the manager.request.fire
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


  class LineInfo() extends Bundle{
    val valid, error = Bool()
    val address = UInt(tagRange.length bit)
  }

  val tagsReadCmd =  Flow(UInt(log2Up(wayLineCount) bits))
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

  val stage0 = new Area{
    val mask = io.cpu.execute.size.mux (
      U(0)    -> B"0001",
      U(1)    -> B"0011",
      default -> B"1111"
    ) |<< io.cpu.execute.address(1 downto 0)
    val colisions = collisionProcess(io.cpu.execute.address(lineRange.high downto wordRange.low), mask)
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
    val colisions = if(mergeExecuteMemory){
      stagePipe(stage0.colisions)
    } else {
      //Assume the writeback stage will never be unstall memory acces while memory stage is stalled
      stagePipe(stage0.colisions) | collisionProcess(io.cpu.memory.address(lineRange.high downto wordRange.low), mask)
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
    val waysHits = if(earlyWaysHits) stagePipe(B(stageA.wayHits)) else B(tagsReadRsp.map(tag => mmuRsp.physicalAddress(tagRange) === tag.address && tag.valid).asBits())
    val waysHit = waysHits.orR
    val dataMux = if(earlyDataMux) stagePipe(stageA.dataMux) else MuxOH(waysHits, dataReadRsp)
    val mask = stagePipe(stageA.mask)
    val colisions = stagePipe(stageA.colisions)

    //Loader interface
    val loaderValid = False



    io.cpu.writeBack.haltIt := io.cpu.writeBack.isValid

    //Evict the cache after reset logics
    val flusher = new Area {
      val valid = RegInit(False)
      when(valid) {
        tagsWriteCmd.valid := valid
        tagsWriteCmd.address := mmuRsp.physicalAddress(lineRange)
        tagsWriteCmd.way.setAll()
        tagsWriteCmd.data.valid := False
        io.cpu.writeBack.haltIt := True
        when(mmuRsp.physicalAddress(lineRange) =/= wayLineCount - 1) {
          mmuRsp.physicalAddress.getDrivingReg(lineRange) := mmuRsp.physicalAddress(lineRange) + 1
        } otherwise {
          valid := False
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


    val lrsc = withLrSc generate new Area{
      val reserved = RegInit(False)
      when(io.cpu.writeBack.isValid && !io.cpu.writeBack.isStuck && !io.cpu.redo && request.isLrsc && !request.wr){
        reserved := True
      }
      when(io.cpu.writeBack.clearLrsc){
        reserved := False
      }
    }

    val requestDataBypass = CombInit(request.data)
    val isAmo = if(withAmo) request.isAmo else False
    val amo = withAmo generate new Area{
      def rf = request.data
      def mem = dataMux

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
      val resultRegValid = RegNext(True) clearWhen(!io.cpu.writeBack.isStuck)
      val resultReg = RegNext(result)
    }


    val memCmdSent = RegInit(False) setWhen (io.mem.cmd.ready) clearWhen (!io.cpu.writeBack.isStuck)
    io.cpu.redo := False
    io.cpu.writeBack.accessError := False
    io.cpu.writeBack.mmuException := io.cpu.writeBack.isValid && (if(catchIllegal) mmuRsp.exception || (!mmuRsp.allowWrite && request.wr) || (!mmuRsp.allowRead && (!request.wr || isAmo)) else False)
    io.cpu.writeBack.unalignedAccess := io.cpu.writeBack.isValid && (if(catchUnaligned) ((request.size === 2 && mmuRsp.physicalAddress(1 downto 0) =/= 0) || (request.size === 1 && mmuRsp.physicalAddress(0 downto 0) =/= 0)) else False)
    io.cpu.writeBack.isWrite := request.wr

    io.mem.cmd.valid := False
    io.mem.cmd.address.assignDontCare()
    io.mem.cmd.length.assignDontCare()
    io.mem.cmd.last.assignDontCare()
    io.mem.cmd.wr := request.wr
    io.mem.cmd.mask := mask
    io.mem.cmd.data := requestDataBypass

    when(io.cpu.writeBack.isValid) {
      when(mmuRsp.isIoAccess) {
        io.cpu.writeBack.haltIt.clearWhen(request.wr ? io.mem.cmd.ready | io.mem.rsp.valid)

        io.mem.cmd.valid := !memCmdSent
        io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto wordRange.low) @@ U(0, wordRange.low bit)
        io.mem.cmd.length := 0
        io.mem.cmd.last := True

        if(withLrSc) when(request.isLrsc && !lrsc.reserved){
          io.mem.cmd.valid := False
          io.cpu.writeBack.haltIt := False
        }
      } otherwise {
        when(waysHit || request.wr && !isAmo) {   //Do not require a cache refill ?
          //Data cache update
          dataWriteCmd.valid setWhen(request.wr && waysHit)
          dataWriteCmd.address := mmuRsp.physicalAddress(lineRange.high downto wordRange.low)
          dataWriteCmd.data := requestDataBypass
          dataWriteCmd.mask := mask
          dataWriteCmd.way := waysHits

          //Write through
          io.mem.cmd.valid setWhen(request.wr)
          io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto wordRange.low) @@ U(0, wordRange.low bit)
          io.mem.cmd.length := 0
          io.mem.cmd.last := True
          io.cpu.writeBack.haltIt clearWhen(!request.wr || io.mem.cmd.ready)

          if(withAmo) when(isAmo){
            when(!amo.resultRegValid) {
              io.mem.cmd.valid := False
              dataWriteCmd.valid := False
              io.cpu.writeBack.haltIt := True
            }
          }

          //On write to read colisions
          when((!request.wr || isAmo) && (colisions & waysHits) =/= 0){
            io.cpu.redo := True
            if(withAmo) io.mem.cmd.valid := False
          }

          if(withLrSc) when(request.isLrsc && !lrsc.reserved){
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
          io.mem.cmd.last := True

          loaderValid setWhen(io.mem.cmd.ready)
        }
      }
    }

    when(mmuRsp.isIoAccess){
      io.cpu.writeBack.data :=  io.mem.rsp.data
      if(catchAccessError) io.cpu.writeBack.accessError := io.mem.rsp.valid && io.mem.rsp.error
    } otherwise {
      io.cpu.writeBack.data :=  dataMux
      if(catchAccessError) io.cpu.writeBack.accessError := (waysHits & B(tagsReadRsp.map(_.error))) =/= 0
    }

    //remove side effects on exceptions
    when(mmuRsp.refilling || io.cpu.writeBack.accessError || io.cpu.writeBack.mmuException || io.cpu.writeBack.unalignedAccess){
      io.mem.cmd.valid := False
      tagsWriteCmd.valid := False
      dataWriteCmd.valid := False
      loaderValid := False
      io.cpu.writeBack.haltIt := False
    }
    io.cpu.redo setWhen(io.cpu.writeBack.isValid && mmuRsp.refilling)

    assert(!(io.cpu.writeBack.isValid && !io.cpu.writeBack.haltIt && io.cpu.writeBack.isStuck), "writeBack stuck by another plugin is not allowed")

    if(withLrSc){
      when(request.isLrsc && request.wr){
        io.cpu.writeBack.data := (!lrsc.reserved).asBits.resized
      }
    }
    if(withAmo){
      when(request.isAmo){
        requestDataBypass := amo.resultReg
      }
    }
  }

  val loader = new Area{
    val valid = RegInit(False) setWhen(stageB.loaderValid)
    val baseAddress =  stageB.mmuRsp.physicalAddress

    val counter = Counter(memTransactionPerLine)
    val waysAllocator = Reg(Bits(wayCount bits)) init(1)
    val error = RegInit(False)

    when(valid && io.mem.rsp.valid){
      dataWriteCmd.valid := True
      dataWriteCmd.address := baseAddress(lineRange) @@ counter
      dataWriteCmd.data := io.mem.rsp.data
      dataWriteCmd.mask.setAll()
      dataWriteCmd.way := waysAllocator
      error := error | io.mem.rsp.error
      counter.increment()
    }


    when(counter.willOverflow){
      valid := False

      //Update tags
      tagsWriteCmd.valid := True
      tagsWriteCmd.address := baseAddress(lineRange)
      tagsWriteCmd.data.valid := True
      tagsWriteCmd.data.address := baseAddress(tagRange)
      tagsWriteCmd.data.error := error || io.mem.rsp.error
      tagsWriteCmd.way := waysAllocator

      error := False
    }

    when(!valid){
      waysAllocator := (waysAllocator ## waysAllocator.msb).resized
    }

    io.cpu.redo setWhen(valid)
    stageB.mmuRspFreeze setWhen(stageB.loaderValid || valid)
  }
}