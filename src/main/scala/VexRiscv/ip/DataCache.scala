package VexRiscv.ip

import VexRiscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Shared, Axi4Config}


case class DataCacheConfig( cacheSize : Int,
                            bytePerLine : Int,
                            wayCount : Int,
                            addressWidth : Int,
                            cpuDataWidth : Int,
                            memDataWidth : Int,
                            catchAccessError : Boolean,
                            catchIllegal : Boolean,
                            catchUnaligned : Boolean,
                            catchMemoryTranslationMiss : Boolean,
                            clearTagsAfterReset : Boolean = true,
                            waysHitRetime : Boolean = true,
                            tagSizeShift : Int = 0){ //Used to force infering ram
  def burstSize = bytePerLine*8/memDataWidth
  val burstLength = bytePerLine/(memDataWidth/8)
  def catchSomething = catchUnaligned || catchMemoryTranslationMiss || catchIllegal || catchAccessError

  def getAxi4SharedConfig() = Axi4Config(
    addressWidth = addressWidth,
    dataWidth = memDataWidth,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false
  )
}


object Bypasser{

  //shot readValid path
  def writeFirstMemWrap[T <: Data](readValid : Bool, readLastAddress : UInt, readLastData : T,writeValid : Bool, writeAddress : UInt, writeData : T) : T = {
    val writeSample     = readValid || (writeValid && writeAddress === readLastAddress)
    val writeValidReg   = RegNextWhen(writeValid,writeSample)
    val writeAddressReg = RegNextWhen(writeAddress,writeSample)
    val writeDataReg    = RegNextWhen(writeData,writeSample)
    (writeValidReg && writeAddressReg === readLastAddress) ? writeDataReg | readLastData
  }


  //shot readValid path
  def writeFirstMemWrap(readValid : Bool, readLastAddress : UInt, readLastData : Bits,writeValid : Bool, writeAddress : UInt, writeData : Bits,writeMask : Bits) : Bits = {
    val writeHit    = writeValid && writeAddress === readLastAddress
    val writeSample = readValid || writeHit
    val writeValidReg   = RegNextWhen(writeValid,writeSample)
    val writeAddressReg = RegNextWhen(writeAddress,writeSample)
    val writeDataReg    = Reg(writeData)
    val writeMaskReg    = Reg(Bits(widthOf(writeData)/8 bits))
    val writeDataRegBytes = writeDataReg.subdivideIn(8 bits)
    val writeDataBytes = writeData.subdivideIn(8 bits)
    val ret = cloneOf(readLastData)
    val retBytes = ret.subdivideIn(8 bits)
    val readLastDataBytes = readLastData.subdivideIn(8 bits)
    val writeRegHit = writeValidReg && writeAddressReg === readLastAddress
    for(b <- writeMask.range){
      when(writeHit && writeMask(b)){
        writeMaskReg(b) := True
      }
      when(readValid) {
        writeMaskReg(b) := writeMask(b)
      }
      when(readValid || (writeHit && writeMask(b))){
        writeDataRegBytes(b) := writeDataBytes(b)
      }

      retBytes(b) := (writeRegHit && writeMaskReg(b)) ? writeDataRegBytes(b) | readLastDataBytes(b)
    }
    ret
  }

  //Long sample path
  //    def writeFirstRegWrap[T <: Data](sample : Bool, sampleAddress : UInt,lastAddress : UInt, readData : T, writeValid : Bool, writeAddress : UInt, writeData : T) : (T,T) = {
  //      val hit = writeValid && (sample ? sampleAddress | lastAddress) === writeAddress
  //      val bypass = hit ? writeData | readData
  //      val reg = RegNextWhen(bypass,sample || hit)
  //      (reg,bypass)
  //    }

  //Short sample path
  def writeFirstRegWrap[T <: Data](sample : Bool, sampleAddress : UInt,sampleLastAddress : UInt, sampleData : T, writeValid : Bool, writeAddress : UInt, writeData : T) = {
    val bypass = (!sample || (writeValid && sampleAddress === writeAddress)) ? writeData | sampleData
    val regEn = sample || (writeValid && sampleLastAddress === writeAddress)
    val reg = RegNextWhen(bypass,regEn)
    reg
  }

  def writeFirstRegWrap(sample : Bool, sampleAddress : UInt,sampleLastAddress : UInt, sampleData : Bits, writeValid : Bool, writeAddress : UInt, writeData : Bits,writeMask : Bits) = {
    val byteCount = widthOf(writeMask)
    val sampleWriteHit = writeValid && sampleAddress === writeAddress
    val sampleLastHit = writeValid && sampleLastAddress === writeAddress
    val regBytes = Vec(Bits(8 bits),byteCount)
    for(b <- writeMask.range){
      val bypass = Mux(!sample || (sampleWriteHit && writeMask(b)), writeData(b*8, 8 bits), sampleData(b*8, 8 bits))
      val regEn = sample || (sampleLastHit && writeMask(b))
      regBytes(b) := RegNextWhen(bypass,regEn)
    }
    regBytes.asBits
  }
}

object DataCacheCpuCmdKind extends SpinalEnum{
  val MEMORY,MANAGMENT = newElement()
}

object DataCacheCpuExecute{
  implicit def implArgs(that : DataCacheCpuExecute) = that.args
}

case class DataCacheCpuExecute(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val isStuck = Bool
  //  val haltIt = Bool
  val args = DataCacheCpuExecuteArgs(p)

  override def asMaster(): Unit = {
    out(isValid, isStuck, args)
    //    in(haltIt)
  }
}

case class DataCacheCpuExecuteArgs(p : DataCacheConfig) extends Bundle{
  val kind = DataCacheCpuCmdKind()
  val wr = Bool
  val address = UInt(p.addressWidth bit)
  val data = Bits(p.cpuDataWidth bit)
  val size = UInt(2 bits)
  val forceUncachedAccess = Bool
  val clean, invalidate, way = Bool
  //  val all = Bool                      //Address should be zero when "all" is used
}

case class DataCacheCpuMemory(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val isStuck = Bool
  val isRemoved = Bool
  val haltIt = Bool
  val mmuBus  = MemoryTranslatorBus()

  override def asMaster(): Unit = {
    out(isValid, isStuck, isRemoved)
    in(haltIt)
    slave(mmuBus)
  }
}


case class DataCacheCpuWriteBack(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val isValid = Bool
  val isStuck = Bool
  val isUser = Bool
  val haltIt = Bool
  val data = Bits(p.cpuDataWidth bit)
  val mmuMiss, illegalAccess, unalignedAccess , accessError = Bool
  val badAddr = UInt(32 bits)
  //  val exceptionBus = if(p.catchSomething) Flow(ExceptionCause()) else null

  override def asMaster(): Unit = {
    out(isValid,isStuck,isUser)
    in(haltIt, data, mmuMiss,illegalAccess , unalignedAccess, accessError, badAddr)
  }
}

case class DataCacheCpuBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
  val execute   = DataCacheCpuExecute(p)
  val memory    = DataCacheCpuMemory(p)
  val writeBack = DataCacheCpuWriteBack(p)

  override def asMaster(): Unit = {
    master(execute)
    master(memory)
    master(writeBack)
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

  def toAxi4Shared(stageCmd : Boolean = false): Axi4Shared = {
    val axi = Axi4Shared(p.getAxi4SharedConfig())
    val pendingWritesMax = 7
    val pendingWrites = CounterUpDown(
      stateCount = pendingWritesMax + 1,
      incWhen = axi.sharedCmd.fire && axi.sharedCmd.write,
      decWhen = axi.writeRsp.fire
    )

    val cmdPreFork = if (stageCmd) cmd.stage.stage().s2mPipe() else cmd
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
}


class DataCache(p : DataCacheConfig) extends Component{
  import p._
  import DataCacheCpuCmdKind._
  assert(wayCount == 1)
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
    val used = Bool
    val dirty = Bool
    val address = UInt(tagRange.length bit)
  }

  val tagsReadCmd =  Flow(UInt(log2Up(wayLineCount) bits))
  val tagsWriteCmd = Flow(new Bundle{
    //    val way = UInt(log2Up(wayCount) bits)
    val address = UInt(log2Up(wayLineCount) bits)
    val data = new LineInfo()
  })

  val tagsWriteLastCmd = RegNext(tagsWriteCmd)

  val dataReadCmd =  Flow(UInt(log2Up(wayWordCount) bits))
  val dataWriteCmd = Flow(new Bundle{
    //    val way = UInt(log2Up(wayCount) bits)
    val address = UInt(log2Up(wayWordCount) bits)
    val data = Bits(wordWidth bits)
    val mask = Bits(wordWidth/8 bits)
  })


  tagsReadCmd.valid := False
  tagsReadCmd.payload.assignDontCare()
  dataReadCmd.valid := False
  dataReadCmd.payload.assignDontCare()
  tagsWriteCmd.valid := False
  tagsWriteCmd.payload.assignDontCare()
  dataWriteCmd.valid := False
  dataWriteCmd.payload.assignDontCare()
  io.mem.cmd.valid := False
  io.mem.cmd.payload.assignDontCare()


  val way = new Area{
    val tags = Mem(new LineInfo(),wayLineCount)
    val data = Mem(Bits(wordWidth bit),wayWordCount)

    when(tagsWriteCmd.valid){
      tags(tagsWriteCmd.address) := tagsWriteCmd.data
    }
    when(dataWriteCmd.valid){
      data.write(
        address = dataWriteCmd.address,
        data = dataWriteCmd.data,
        mask = dataWriteCmd.mask
      )
    }

    val tagReadRspOneAddress = RegNextWhen(tagsReadCmd.payload, tagsReadCmd.valid)
    val tagReadRspOne = Bypasser.writeFirstMemWrap(
      readValid = tagsReadCmd.valid,
      readLastAddress = tagReadRspOneAddress,
      readLastData = tags.readSync(tagsReadCmd.payload,enable = tagsReadCmd.valid),
      writeValid = tagsWriteCmd.valid,
      writeAddress = tagsWriteCmd.address,
      writeData = tagsWriteCmd.data
    )

    val dataReadRspOneKeepAddress = False
    val dataReadRspOneAddress = RegNextWhen(dataReadCmd.payload, dataReadCmd.valid && !dataReadRspOneKeepAddress)
    val dataReadRspOneWithoutBypass = data.readSync(dataReadCmd.payload,enable = dataReadCmd.valid)
    val dataReadRspOne = Bypasser.writeFirstMemWrap(
      readValid = dataReadCmd.valid,
      readLastAddress = dataReadRspOneAddress,
      readLastData = dataReadRspOneWithoutBypass,
      writeValid = dataWriteCmd.valid,
      writeAddress = dataWriteCmd.address,
      writeData = dataWriteCmd.data,
      writeMask = dataWriteCmd.mask
    )

    val tagReadRspTwoEnable = !io.cpu.writeBack.isStuck
    val tagReadRspTwoRegIn = (tagsWriteCmd.valid && tagsWriteCmd.address === tagReadRspOneAddress) ? tagsWriteCmd.data | tagReadRspOne
    val tagReadRspTwo = RegNextWhen(tagReadRspTwoRegIn ,tagReadRspTwoEnable)


    val dataReadRspTwoEnable = !io.cpu.writeBack.isStuck
    val dataReadRspTwo = Bypasser.writeFirstRegWrap(
      sample = dataReadRspTwoEnable,
      sampleAddress = dataReadRspOneAddress,
      sampleLastAddress = RegNextWhen(dataReadRspOneAddress, dataReadRspTwoEnable),
      sampleData = dataReadRspOne,
      writeValid = dataWriteCmd.valid,
      writeAddress = dataWriteCmd.address,
      writeData = dataWriteCmd.data,
      writeMask = dataWriteCmd.mask
    )
  }

  when(io.cpu.execute.isValid && !io.cpu.execute.isStuck){
    tagsReadCmd.valid := True
    tagsReadCmd.payload := io.cpu.execute.address(lineRange)

    dataReadCmd.valid := True
    dataReadCmd.payload := io.cpu.execute.address(lineRange.high downto wordRange.low)  //TODO FMAX maybe critical path could be default
  }


  val victim = new Area{
    val requestIn = Stream(cloneable(new Bundle{
      //      val way = UInt(log2Up(wayCount) bits)
      val address = UInt(p.addressWidth bits)
    }))
    requestIn.valid := False
    requestIn.payload.assignDontCare()

    val request = requestIn.stage() //TODO FMAX half pipe ?
    request.ready := False

    val buffer = Mem(Bits(p.memDataWidth bits),memTransactionPerLine << tagSizeShift)  // WARNING << tagSizeShift could resolve cyclone II issue, //.add(new AttributeString("ramstyle","M4K"))

    //Send line read commands to fill the buffer
    val readLineCmdCounter = Reg(UInt(log2Up(memTransactionPerLine + 1) bits)) init(0)
    val dataReadCmdOccure = False
    val dataReadRestored = RegInit(False)
    when(request.valid){
      when(!readLineCmdCounter.msb) {
        readLineCmdCounter := readLineCmdCounter + 1
        //dataReadCmd := request.address(lineRange.high downto wordRange.low)   Done in the manager
        dataReadCmdOccure := True
        dataReadCmd.valid := True
        dataReadCmd.payload := request.address(lineRange) @@ readLineCmdCounter(readLineCmdCounter.high - 1 downto 0)
        way.dataReadRspOneKeepAddress := True
      } otherwise {
        when(!dataReadRestored) {
          dataReadCmd.valid := True
          dataReadCmd.payload := way.dataReadRspOneAddress //Restore stage one readed value
        }
        dataReadRestored := True
      }
    }

    dataReadRestored clearWhen(request.ready)

    //Fill the buffer with line read responses
    val readLineRspCounter = Reg(UInt(log2Up(memTransactionPerLine + 1) bits)) init(0)
    when(Delay(dataReadCmdOccure,1, init=False)){
      buffer(readLineRspCounter.resized) := way.dataReadRspOneWithoutBypass
      readLineRspCounter := readLineRspCounter + 1
    }

    //Send buffer read commands
    val bufferReadCounter = Reg(UInt(log2Up(memTransactionPerLine + 1) bits)) init(0)
    val bufferReadStream = Stream(buffer.addressType)
    bufferReadStream.valid := readLineRspCounter > bufferReadCounter
    bufferReadStream.payload := bufferReadCounter.resized
    when(bufferReadStream.fire){
      bufferReadCounter := bufferReadCounter + 1
    }
    val bufferReaded = buffer.streamReadSync(bufferReadStream).stage
    bufferReaded.ready := False

    //Send memory writes from bufffer read responses
    val bufferReadedCounter = Reg(UInt(log2Up(memTransactionPerLine) bits)) init(0)
    val memCmdAlreadyUsed = False
    when(bufferReaded.valid) {
      io.mem.cmd.valid := True
      io.mem.cmd.wr := True
      io.mem.cmd.address := request.address(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
      io.mem.cmd.length := p.burstLength-1
      io.mem.cmd.data := bufferReaded.payload
      io.mem.cmd.mask := (1<<(wordWidth/8))-1
      io.mem.cmd.last := bufferReadedCounter === bufferReadedCounter.maxValue

      when(!memCmdAlreadyUsed && io.mem.cmd.ready){
        bufferReaded.ready := True
        bufferReadedCounter := bufferReadedCounter + 1
        when(bufferReadedCounter === bufferReadedCounter.maxValue){
          request.ready := True
        }
      }
    }


    val counter = Counter(memTransactionPerLine)
    when(request.ready){
      readLineCmdCounter.msb := False
      readLineRspCounter.msb := False
      bufferReadCounter.msb := False
    }
  }



  val stageA = new Area{
    val request = RegNextWhen(io.cpu.execute.args, !io.cpu.memory.isStuck)
    io.cpu.memory.mmuBus.cmd.isValid := io.cpu.memory.isValid  && request.kind === MEMORY //TODO filter request kind
    io.cpu.memory.mmuBus.cmd.virtualAddress := request.address
    io.cpu.memory.mmuBus.cmd.bypassTranslation := request.way

    io.cpu.memory.haltIt := io.cpu.memory.isValid && request.kind === MEMORY && !request.wr && victim.request.valid && !victim.dataReadRestored
  }

  val stageB = new Area {
    val request = RegNextWhen(stageA.request, !io.cpu.writeBack.isStuck)
    val mmuRsp = RegNextWhen(io.cpu.memory.mmuBus.rsp, !io.cpu.writeBack.isStuck)
    val waysHit = if(waysHitRetime)
      RegNextWhen(way.tagReadRspTwoRegIn.used && io.cpu.memory.mmuBus.rsp.physicalAddress(tagRange) === way.tagReadRspTwoRegIn.address,!io.cpu.writeBack.isStuck)  //Manual retiming
    else
      way.tagReadRspTwo.used && mmuRsp.physicalAddress(tagRange) === way.tagReadRspTwo.address


    //Loader interface
    val loaderValid = False
    val loaderReady = False
    val loadingDone = RegNext(loaderValid && loaderReady) init(False) //one cycle pulse

    //delayedXX are used to relax logic timings in flush and evict modes
    val delayedIsStuck      = RegNext(io.cpu.writeBack.isStuck)
    val delayedWaysHitValid = RegNext(waysHit)

    val victimNotSent  = RegInit(False) clearWhen(victim.requestIn.ready) setWhen(!io.cpu.memory.isStuck)
    val loadingNotDone = RegInit(False) clearWhen(loaderReady) setWhen(!io.cpu.memory.isStuck)

    val writeMask = request.size.mux (
      U(0)    -> B"0001",
      U(1)    -> B"0011",
      default -> B"1111"
    ) |<< mmuRsp.physicalAddress(1 downto 0)

    io.cpu.writeBack.haltIt := io.cpu.writeBack.isValid
    io.cpu.writeBack.mmuMiss := False
    io.cpu.writeBack.illegalAccess := False
    io.cpu.writeBack.unalignedAccess := False
    io.cpu.writeBack.accessError := (if(catchAccessError) io.mem.rsp.valid && io.mem.rsp.error else False)
    io.cpu.writeBack.badAddr := request.address

    //Evict the cache after reset logics
    val bootEvicts = if(clearTagsAfterReset) new Area {
      val valid = RegInit(True)
      mmuRsp.physicalAddress init (0)
      when(valid) {
        tagsWriteCmd.valid := valid
        tagsWriteCmd.address := mmuRsp.physicalAddress(lineRange)
        tagsWriteCmd.data.used := False
        when(mmuRsp.physicalAddress(lineRange) =/= lineCount - 1) {
          mmuRsp.physicalAddress.getDrivingReg(lineRange) := mmuRsp.physicalAddress(lineRange) + 1
          io.cpu.writeBack.haltIt := True
        } otherwise {
          valid := False
        }
      }
    }

    when(io.cpu.writeBack.isValid) {
      if (catchMemoryTranslationMiss) {
        io.cpu.writeBack.mmuMiss := mmuRsp.miss
      }
      switch(request.kind) {
        is(MANAGMENT) {
          when(delayedIsStuck && !mmuRsp.miss) {
            when(delayedWaysHitValid || (request.way && way.tagReadRspTwo.used)) {
              io.cpu.writeBack.haltIt.clearWhen(!(victim.requestIn.valid && !victim.requestIn.ready))
              victim.requestIn.valid := request.clean && way.tagReadRspTwo.dirty
              tagsWriteCmd.valid      := victim.requestIn.ready
            } otherwise{
              io.cpu.writeBack.haltIt := False
            }
          }

          victim.requestIn.address := way.tagReadRspTwo.address @@ mmuRsp.physicalAddress(lineRange) @@ U((lineRange.low - 1 downto 0) -> false)
          tagsWriteCmd.address     := mmuRsp.physicalAddress(lineRange)
          tagsWriteCmd.data.used   := !request.invalidate
          tagsWriteCmd.data.dirty  := !request.clean
        }
        is(MEMORY) {
          val illegal = if(catchIllegal) (request.wr && !mmuRsp.allowWrite) || (!request.wr && !mmuRsp.allowRead) || (io.cpu.writeBack.isUser && !mmuRsp.allowUser) else False
          val unaligned = if(catchUnaligned) ((request.size === 2 && mmuRsp.physicalAddress(1 downto 0) =/= 0) || (request.size === 1 && mmuRsp.physicalAddress(0 downto 0) =/= 0)) else False
          io.cpu.writeBack.illegalAccess := illegal
          io.cpu.writeBack.unalignedAccess := unaligned
          when((Bool(!catchMemoryTranslationMiss) || !mmuRsp.miss) && !illegal && !unaligned) {
            when(request.forceUncachedAccess || mmuRsp.isIoAccess) {
              val memCmdSent = RegInit(False)
              when(!victim.request.valid) {
                //Avoid mixing memory request while victim is pending
                io.mem.cmd.wr := request.wr
                io.mem.cmd.address := mmuRsp.physicalAddress(tagRange.high downto wordRange.low) @@ U(0, wordRange.low bit)
                io.mem.cmd.mask := writeMask
                io.mem.cmd.data := request.data
                io.mem.cmd.length := 0
                io.mem.cmd.last := True

                when(!memCmdSent) {
                  io.mem.cmd.valid := True
                  memCmdSent setWhen (io.mem.cmd.ready)
                }

                io.cpu.writeBack.haltIt.clearWhen(memCmdSent && (io.mem.rsp.fire || request.wr)) //Cut mem.cmd.ready path but insert one cycle stall when write
              }
              memCmdSent clearWhen (!io.cpu.writeBack.isStuck)
            } otherwise {
              when(waysHit || !loadingNotDone) {
                io.cpu.writeBack.haltIt := False
                dataWriteCmd.valid := request.wr
                dataWriteCmd.address := mmuRsp.physicalAddress(lineRange.high downto wordRange.low)
                dataWriteCmd.data := request.data
                dataWriteCmd.mask := writeMask

                tagsWriteCmd.valid := (!loadingNotDone) || request.wr
                tagsWriteCmd.address := mmuRsp.physicalAddress(lineRange)
                tagsWriteCmd.data.used := True
                tagsWriteCmd.data.dirty := request.wr
                tagsWriteCmd.data.address := mmuRsp.physicalAddress(tagRange)
              } otherwise {
                val victimRequired = way.tagReadRspTwo.used && way.tagReadRspTwo.dirty
                loaderValid := loadingNotDone && !(victimNotSent && victim.request.isStall) //Additional condition used to be sure of that all previous victim are written into the  RAM
                victim.requestIn.valid := victimRequired && victimNotSent
                victim.requestIn.address := way.tagReadRspTwo.address @@ mmuRsp.physicalAddress(lineRange) @@ U((lineRange.low - 1 downto 0) -> false)
              }
            }
          }
        }
      }
    }


    assert(!(io.cpu.writeBack.isValid && !io.cpu.writeBack.haltIt && io.cpu.writeBack.isStuck), "writeBack stuck by another plugin is not allowed")
    io.cpu.writeBack.data := (request.forceUncachedAccess || mmuRsp.isIoAccess) ? io.mem.rsp.data | way.dataReadRspTwo //not multi ways
  }

  //The whole life of a loading task, the corresponding manager request is present
  val loader = new Area{
    val valid = RegNext(stageB.loaderValid) init(False)
    val baseAddress =  stageB.mmuRsp.physicalAddress

    val memCmdSent = RegInit(False)
    when(valid && !memCmdSent) {
      io.mem.cmd.valid := True
      io.mem.cmd.wr := False
      io.mem.cmd.address := baseAddress(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
      io.mem.cmd.length := p.burstLength-1
      io.mem.cmd.last := True
    }

    when(valid && io.mem.cmd.ready){
      memCmdSent := True
    }

    when(valid && !memCmdSent) {
      victim.memCmdAlreadyUsed := True
    }

    val counter = Counter(memTransactionPerLine)
    when(valid && io.mem.rsp.valid){
      dataWriteCmd.valid := True
      dataWriteCmd.address := baseAddress(lineRange) @@ counter
      dataWriteCmd.data := io.mem.rsp.data
      dataWriteCmd.mask := (1<<(wordWidth/8))-1
      counter.increment()
    }

    when(counter.willOverflow){
      memCmdSent := False
      valid := False
      stageB.loaderReady := True
    }
  }
}