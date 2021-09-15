package vexriscv.ip

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4ReadOnly}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbAccessParameter, BmbParameter, BmbSourceParameter}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.plugin.{IBusSimpleBus, IBusSimplePlugin}


case class InstructionCacheConfig( cacheSize : Int,
                                   bytePerLine : Int,
                                   wayCount : Int,
                                   addressWidth : Int,
                                   cpuDataWidth : Int,
                                   memDataWidth : Int,
                                   catchIllegalAccess : Boolean,
                                   catchAccessFault : Boolean,
                                   asyncTagMemory : Boolean,
                                   twoCycleCache : Boolean = true,
                                   twoCycleRam : Boolean = false,
                                   twoCycleRamInnerMux : Boolean = false,
                                   preResetFlush : Boolean = false,
                                   bypassGen : Boolean = false,
                                   reducedBankWidth : Boolean = false){

  assert(!(twoCycleRam && !twoCycleCache))

  def burstSize = bytePerLine*8/memDataWidth
  def catchSomething = catchAccessFault || catchIllegalAccess

  def getAxi4Config() = Axi4Config(
    addressWidth = addressWidth,
    dataWidth = memDataWidth,
    useId = false,
    useRegion = false,
    useLock = false,
    useQos = false,
    useSize = false
  )

  def getAvalonConfig() = AvalonMMConfig.bursted(
    addressWidth = addressWidth,
    dataWidth = memDataWidth,
    burstCountWidth = log2Up(burstSize + 1)).getReadOnlyConfig.copy(
    useResponse = true,
    constantBurstBehavior = true
  )

  def getPipelinedMemoryBusConfig() = PipelinedMemoryBusConfig(
    addressWidth = 32,
    dataWidth = 32
  )

  def getWishboneConfig() = WishboneConfig(
    addressWidth = 32-log2Up(memDataWidth/8),
    dataWidth = memDataWidth,
    selWidth = memDataWidth/8,
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
      contextWidth = 0,
      canWrite = false,
      alignment = BmbParameter.BurstAlignement.LENGTH,
      maximumPendingTransaction = 1
    ))
  )
}



case class InstructionCacheCpuPrefetch(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val isValid  = Bool
  val haltIt   = Bool
  val pc  = UInt(p.addressWidth bit)

  override def asMaster(): Unit = {
    out(isValid, pc)
    in(haltIt)
  }
}

trait InstructionCacheCommons{
  val isValid : Bool
  val isStuck : Bool
  val pc : UInt
  val physicalAddress : UInt
  val data   : Bits
  val cacheMiss, error,  mmuRefilling, mmuException, isUser : Bool
}

case class InstructionCacheCpuFetch(p : InstructionCacheConfig, mmuParameter : MemoryTranslatorBusParameter) extends Bundle with IMasterSlave with InstructionCacheCommons {
  val isValid = Bool()
  val isStuck = Bool()
  val isRemoved = Bool()
  val pc = UInt(p.addressWidth bits)
  val data = Bits(p.cpuDataWidth bits)
  val dataBypassValid = p.bypassGen generate Bool()
  val dataBypass = p.bypassGen generate Bits(p.cpuDataWidth bits)
  val mmuRsp  = MemoryTranslatorRsp(mmuParameter)
  val physicalAddress = UInt(p.addressWidth bits)
  val cacheMiss, error, mmuRefilling, mmuException, isUser  = ifGen(!p.twoCycleCache)(Bool)

  override def asMaster(): Unit = {
    out(isValid, isStuck, isRemoved, pc)
    inWithNull(error,mmuRefilling,mmuException,data, cacheMiss,physicalAddress)
    outWithNull(isUser, dataBypass, dataBypassValid)
    out(mmuRsp)
  }
}


case class InstructionCacheCpuDecode(p : InstructionCacheConfig) extends Bundle with IMasterSlave with InstructionCacheCommons {
  val isValid = Bool
  val isStuck  = Bool
  val pc = UInt(p.addressWidth bits)
  val physicalAddress = UInt(p.addressWidth bits)
  val data  =  Bits(p.cpuDataWidth bits)
  val cacheMiss, error, mmuRefilling, mmuException, isUser  = ifGen(p.twoCycleCache)(Bool)

  override def asMaster(): Unit = {
    out(isValid, isStuck, pc)
    outWithNull(isUser)
    inWithNull(error, mmuRefilling, mmuException,data, cacheMiss, physicalAddress)
  }
}

case class InstructionCacheCpuBus(p : InstructionCacheConfig, mmuParameter : MemoryTranslatorBusParameter) extends Bundle with IMasterSlave{
  val prefetch = InstructionCacheCpuPrefetch(p)
  val fetch = InstructionCacheCpuFetch(p, mmuParameter)
  val decode = InstructionCacheCpuDecode(p)
  val fill = Flow(UInt(p.addressWidth bits))

  override def asMaster(): Unit = {
    master(prefetch, fetch, decode, fill)
  }
}

case class InstructionCacheMemCmd(p : InstructionCacheConfig) extends Bundle{
  val address = UInt(p.addressWidth bit)
  val size = UInt(log2Up(log2Up(p.bytePerLine) + 1) bits)
}

case class InstructionCacheMemRsp(p : InstructionCacheConfig) extends Bundle{
  val data = Bits(p.memDataWidth bit)
  val error = Bool
}

case class InstructionCacheMemBus(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val cmd = Stream (InstructionCacheMemCmd(p))
  val rsp = Flow (InstructionCacheMemRsp(p))

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }

  def toAxi4ReadOnly(): Axi4ReadOnly = {
    val axiConfig = p.getAxi4Config()
    val mm = Axi4ReadOnly(axiConfig)

    mm.readCmd.valid := cmd.valid
    mm.readCmd.len := p.burstSize-1
    mm.readCmd.addr := cmd.address
    mm.readCmd.prot  := "110"
    mm.readCmd.cache := "1111"
    mm.readCmd.setBurstINCR()
    cmd.ready := mm.readCmd.ready
    rsp.valid := mm.readRsp.valid
    rsp.data  := mm.readRsp.data
    rsp.error := !mm.readRsp.isOKAY()
    mm.readRsp.ready := True
    mm
  }

  def toAvalon(): AvalonMM = {
    val avalonConfig = p.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)
    mm.read := cmd.valid
    mm.burstCount := U(p.burstSize)
    mm.address := cmd.address
    cmd.ready := mm.waitRequestn
    rsp.valid := mm.readDataValid
    rsp.data := mm.readData
    rsp.error := mm.response =/= AvalonMM.Response.OKAY
    mm
  }


  def toPipelinedMemoryBus(): PipelinedMemoryBus = {
    val pipelinedMemoryBusConfig = p.getPipelinedMemoryBusConfig()
    val bus = PipelinedMemoryBus(pipelinedMemoryBusConfig)
    val counter = Counter(p.burstSize, bus.cmd.fire)
    bus.cmd.valid := cmd.valid
    bus.cmd.address := cmd.address(31 downto widthOf(counter.value) + 2) @@ counter @@ U"00"
    bus.cmd.write := False
    bus.cmd.mask.assignDontCare()
    bus.cmd.data.assignDontCare()
    cmd.ready := counter.willOverflow
    rsp.valid := bus.rsp.valid
    rsp.data := bus.rsp.payload.data
    rsp.error := False
    bus
  }


  def toWishbone(): Wishbone = {
    val wishboneConfig = p.getWishboneConfig()
    val bus = Wishbone(wishboneConfig)
    val counter = Reg(UInt(log2Up(p.burstSize) bits)) init(0)
    val pending = counter =/= 0
    val lastCycle = counter === counter.maxValue

    bus.ADR := (cmd.address >> widthOf(counter) + log2Up(p.memDataWidth/8)) @@ counter
    bus.CTI := lastCycle ? B"111" | B"010"
    bus.BTE := "00"
    bus.SEL.setAll()
    bus.WE  := False
    bus.DAT_MOSI.assignDontCare()
    bus.CYC := False
    bus.STB := False
    when(cmd.valid || pending){
      bus.CYC := True
      bus.STB := True
      when(bus.ACK){
        counter := counter + 1
      }
    }

    cmd.ready := cmd.valid && bus.ACK
    rsp.valid := RegNext(bus.CYC && bus.ACK) init(False)
    rsp.data := RegNext(bus.DAT_MISO)
    rsp.error := False //TODO
    bus
  }

  def toBmb() : Bmb = {
    val busParameter = p.getBmbParameter
    val bus = Bmb(busParameter).setCompositeName(this,"toBmb", true)
    bus.cmd.arbitrationFrom(cmd)
    bus.cmd.opcode := Bmb.Cmd.Opcode.READ
    bus.cmd.address := cmd.address.resized
    bus.cmd.length := p.bytePerLine - 1
    bus.cmd.last := True
    rsp.valid := bus.rsp.valid
    rsp.data := bus.rsp.data
    rsp.error := bus.rsp.isError
    bus.rsp.ready := True
    bus
  }
}


case class InstructionCacheFlushBus() extends Bundle with IMasterSlave{
  val cmd = Event
  val rsp = Bool

  override def asMaster(): Unit = {
    master(cmd)
    in(rsp)
  }
}

class InstructionCache(p : InstructionCacheConfig, mmuParameter : MemoryTranslatorBusParameter) extends Component{
  import p._
  val io = new Bundle{
    val flush = in Bool()
    val cpu = slave(InstructionCacheCpuBus(p, mmuParameter))
    val mem = master(InstructionCacheMemBus(p))
  }

  val lineWidth = bytePerLine*8
  val lineCount = cacheSize/bytePerLine
  val cpuWordWidth = cpuDataWidth
  val memWordPerLine = lineWidth/memDataWidth
  val bytePerCpuWord = cpuWordWidth/8
  val wayLineCount = lineCount/wayCount

  val tagRange = addressWidth-1 downto log2Up(wayLineCount*bytePerLine)
  val lineRange = tagRange.low-1 downto log2Up(bytePerLine)

  case class LineTag() extends Bundle{
    val valid = Bool
    val error = Bool
    val address = UInt(tagRange.length bit)
  }

  val bankCount = wayCount
  val bankWidth = if(!reducedBankWidth) memDataWidth else Math.max(cpuDataWidth, memDataWidth/wayCount)
  val bankByteSize = cacheSize/bankCount
  val bankWordCount = bankByteSize*8/bankWidth
  val bankWordToCpuWordRange = log2Up(bankWidth/8)-1 downto log2Up(bytePerCpuWord)
  val memToBankRatio = bankWidth*bankCount / memDataWidth

  val banks = Seq.fill(bankCount)(Mem(Bits(bankWidth bits), bankWordCount))

  val ways = Seq.fill(wayCount)(new Area{
    val tags = Mem(LineTag(),wayLineCount)

    if(preResetFlush){
      tags.initBigInt(List.fill(wayLineCount)(BigInt(0)))
    }
  })


  val lineLoader = new Area{
    val fire = False
    val valid = RegInit(False) clearWhen(fire)
    val address = KeepAttribute(Reg(UInt(addressWidth bits)))
    val hadError = RegInit(False) clearWhen(fire)
    val flushPending = RegInit(True)

    when(io.cpu.fill.valid){
      valid := True
      address := io.cpu.fill.payload
    }

    io.cpu.prefetch.haltIt := valid || flushPending

    val flushCounter = Reg(UInt(log2Up(wayLineCount) + 1 bit))
    when(!flushCounter.msb){
      io.cpu.prefetch.haltIt := True
      flushCounter := flushCounter + 1
    }
    when(!RegNext(flushCounter.msb)){
      io.cpu.prefetch.haltIt := True
    }

    when(io.flush){
      io.cpu.prefetch.haltIt := True
      flushPending := True
    }

    when(flushPending && !(valid || io.cpu.fetch.isValid) ){
      flushCounter := 0
      flushPending := False
    }



    val cmdSent = RegInit(False) setWhen(io.mem.cmd.fire) clearWhen(fire)
    io.mem.cmd.valid := valid && !cmdSent
    io.mem.cmd.address := address(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
    io.mem.cmd.size := log2Up(p.bytePerLine)

    val wayToAllocate = Counter(wayCount, !valid)
    val wordIndex = KeepAttribute(Reg(UInt(log2Up(memWordPerLine) bits)) init(0))


    val write = new Area{
      val tag = ways.map(_.tags.writePort)
      val data = banks.map(_.writePort)
    }

    for(wayId <- 0 until wayCount){
      val wayHit = wayToAllocate === wayId
      val tag = write.tag(wayId)
      tag.valid := ((wayHit && fire) || !flushCounter.msb)
      tag.address := (flushCounter.msb ? address(lineRange) | flushCounter(flushCounter.high-1 downto 0))
      tag.data.valid := flushCounter.msb
      tag.data.error := hadError || io.mem.rsp.error
      tag.data.address := address(tagRange)
    }

    for((writeBank, bankId) <- write.data.zipWithIndex){
      if(!reducedBankWidth) {
        writeBank.valid := io.mem.rsp.valid && wayToAllocate === bankId
        writeBank.address := address(lineRange) @@ wordIndex
        writeBank.data := io.mem.rsp.data
      } else {
        val sel = U(bankId) - wayToAllocate.value
        val groupSel = wayToAllocate(log2Up(bankCount)-1 downto log2Up(bankCount/memToBankRatio))
        val subSel = sel(log2Up(bankCount/memToBankRatio) -1 downto 0)
        writeBank.valid := io.mem.rsp.valid && groupSel === (bankId >> log2Up(bankCount/memToBankRatio))
        writeBank.address := address(lineRange) @@ wordIndex @@ (subSel)
        writeBank.data := io.mem.rsp.data.subdivideIn(bankCount/memToBankRatio slices)(subSel)
      }
    }


    when(io.mem.rsp.valid) {
      wordIndex := (wordIndex + 1).resized
      hadError.setWhen(io.mem.rsp.error)
      when(wordIndex === wordIndex.maxValue) {
        fire := True
      }
    }
  }

  val fetchStage = new Area{
    val read = new Area{
      val banksValue = for(bank <- banks) yield new Area{
        val dataMem = bank.readSync(io.cpu.prefetch.pc(lineRange.high downto log2Up(bankWidth/8)), !io.cpu.fetch.isStuck)
        val data = if(!twoCycleRamInnerMux) dataMem.subdivideIn(cpuDataWidth bits).read(io.cpu.fetch.pc(bankWordToCpuWordRange)) else dataMem
      }

      val waysValues = for((way, wayId) <- ways.zipWithIndex) yield new Area{
        val tag = if(asyncTagMemory) {
          way.tags.readAsync(io.cpu.fetch.pc(lineRange))
        }else {
          way.tags.readSync(io.cpu.prefetch.pc(lineRange), !io.cpu.fetch.isStuck)
        }
//        val data = CombInit(banksValue(wayId).data)
      }
    }


    val hit = (!twoCycleRam) generate new Area{
      val hits = read.waysValues.map(way => way.tag.valid && way.tag.address === io.cpu.fetch.mmuRsp.physicalAddress(tagRange))
      val valid = Cat(hits).orR
      val wayId = OHToUInt(hits)
      val bankId = if(!reducedBankWidth) wayId else (wayId >> log2Up(bankCount/memToBankRatio)) @@ ((wayId + (io.cpu.fetch.mmuRsp.physicalAddress(log2Up(bankWidth/8), log2Up(bankCount) bits))).resize(log2Up(bankCount/memToBankRatio)))
      val error = read.waysValues.map(_.tag.error).read(wayId)
      val data = read.banksValue.map(_.data).read(bankId)
      val word = if(cpuDataWidth == memDataWidth || !twoCycleRamInnerMux) CombInit(data) else data.subdivideIn(cpuDataWidth bits).read(io.cpu.fetch.pc(bankWordToCpuWordRange))
      io.cpu.fetch.data := (if(p.bypassGen) (io.cpu.fetch.dataBypassValid ? io.cpu.fetch.dataBypass | word) else word)
      if(twoCycleCache){
        io.cpu.decode.data := RegNextWhen(io.cpu.fetch.data,!io.cpu.decode.isStuck)
      }
    }

    if(twoCycleRam && wayCount == 1){
      val cacheData = if(cpuDataWidth == memDataWidth || !twoCycleRamInnerMux) CombInit(read.banksValue.head.data) else read.banksValue.head.data.subdivideIn(cpuDataWidth bits).read(io.cpu.fetch.pc(bankWordToCpuWordRange))
      io.cpu.fetch.data := (if(p.bypassGen) (io.cpu.fetch.dataBypassValid ? io.cpu.fetch.dataBypass | cacheData) else cacheData)
    }

    io.cpu.fetch.physicalAddress := io.cpu.fetch.mmuRsp.physicalAddress

    val resolution = ifGen(!twoCycleCache)( new Area{
      val mmuRsp = io.cpu.fetch.mmuRsp

      io.cpu.fetch.cacheMiss := !hit.valid
      io.cpu.fetch.error := hit.error || (!mmuRsp.isPaging && (mmuRsp.exception || !mmuRsp.allowExecute))
      io.cpu.fetch.mmuRefilling := mmuRsp.refilling
      io.cpu.fetch.mmuException := !mmuRsp.refilling && mmuRsp.isPaging && (mmuRsp.exception || !mmuRsp.allowExecute)
    })
  }



  val decodeStage = ifGen(twoCycleCache) (new Area{
    def stage[T <: Data](that : T) = RegNextWhen(that,!io.cpu.decode.isStuck)
    val mmuRsp = stage(io.cpu.fetch.mmuRsp)

    val hit = if(!twoCycleRam) new Area{
      val valid = stage(fetchStage.hit.valid)
      val error = stage(fetchStage.hit.error)
    } else new Area{
      val tags = fetchStage.read.waysValues.map(way => stage(way.tag))
      val hits = tags.map(tag => tag.valid && tag.address === mmuRsp.physicalAddress(tagRange))
      val valid = Cat(hits).orR
      val wayId = OHToUInt(hits)
      val bankId = if(!reducedBankWidth) wayId else (wayId >> log2Up(bankCount/memToBankRatio)) @@ ((wayId + (mmuRsp.physicalAddress(log2Up(bankWidth/8), log2Up(bankCount) bits))).resize(log2Up(bankCount/memToBankRatio)))
      val error = tags(wayId).error
      val data = fetchStage.read.banksValue.map(bank => stage(bank.data)).read(bankId)
      val word = if(cpuDataWidth == memDataWidth || !twoCycleRamInnerMux) data else data.subdivideIn(cpuDataWidth bits).read(io.cpu.decode.pc(bankWordToCpuWordRange))
      if(p.bypassGen) when(stage(io.cpu.fetch.dataBypassValid)){
        word := stage(io.cpu.fetch.dataBypass)
      }
      io.cpu.decode.data := word
    }

    io.cpu.decode.cacheMiss := !hit.valid
    io.cpu.decode.error := hit.error || (!mmuRsp.isPaging && (mmuRsp.exception || !mmuRsp.allowExecute))
    io.cpu.decode.mmuRefilling := mmuRsp.refilling
    io.cpu.decode.mmuException := !mmuRsp.refilling && mmuRsp.isPaging && (mmuRsp.exception || !mmuRsp.allowExecute)
    io.cpu.decode.physicalAddress := mmuRsp.physicalAddress
  })
}

