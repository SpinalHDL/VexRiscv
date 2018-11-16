package vexriscv.ip

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4ReadOnly}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import vexriscv.demo.{SimpleBus, SimpleBusConfig}


case class InstructionCacheConfig( cacheSize : Int,
                                   bytePerLine : Int,
                                   wayCount : Int,
                                   addressWidth : Int,
                                   cpuDataWidth : Int,
                                   memDataWidth : Int,
                                   catchIllegalAccess : Boolean,
                                   catchAccessFault : Boolean,
                                   catchMemoryTranslationMiss : Boolean,
                                   asyncTagMemory : Boolean,
                                   twoCycleCache : Boolean = true,
                                   twoCycleRam : Boolean = false,
                                   preResetFlush : Boolean = false){

  assert(!(twoCycleRam && !twoCycleCache))

  def burstSize = bytePerLine*8/memDataWidth
  def catchSomething = catchAccessFault || catchMemoryTranslationMiss || catchIllegalAccess

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

  def getSimpleBusConfig() = SimpleBusConfig(
    addressWidth = 32,
    dataWidth = 32
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
  val cacheMiss, error, mmuMiss, illegalAccess,isUser : Bool
}

case class InstructionCacheCpuFetch(p : InstructionCacheConfig) extends Bundle with IMasterSlave with InstructionCacheCommons {
  val isValid = Bool
  val isStuck = Bool
  val isRemoved = Bool
  val pc = UInt(p.addressWidth bits)
  val data    =  Bits(p.cpuDataWidth bits)
  val mmuBus  = MemoryTranslatorBus()
  val physicalAddress = UInt(p.addressWidth bits)
  val cacheMiss, error, mmuMiss, illegalAccess,isUser  = ifGen(!p.twoCycleCache)(Bool)

  override def asMaster(): Unit = {
    out(isValid, isStuck, isRemoved, pc)
    inWithNull(error,mmuMiss,illegalAccess,data, cacheMiss,physicalAddress)
    outWithNull(isUser)
    slaveWithNull(mmuBus)
  }
}


case class InstructionCacheCpuDecode(p : InstructionCacheConfig) extends Bundle with IMasterSlave with InstructionCacheCommons {
  val isValid = Bool
  val isStuck  = Bool
  val pc = UInt(p.addressWidth bits)
  val physicalAddress = UInt(p.addressWidth bits)
  val data  =  Bits(p.cpuDataWidth bits)
  val cacheMiss, error, mmuMiss, illegalAccess, isUser  = ifGen(p.twoCycleCache)(Bool)

  override def asMaster(): Unit = {
    out(isValid, isStuck, pc)
    outWithNull(isUser)
    inWithNull(error,mmuMiss,illegalAccess,data, cacheMiss, physicalAddress)
  }
}

case class InstructionCacheCpuBus(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val prefetch = InstructionCacheCpuPrefetch(p)
  val fetch = InstructionCacheCpuFetch(p)
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


  def toSimpleBus(): SimpleBus = {
    val simpleBusConfig = p.getSimpleBusConfig()
    val bus = SimpleBus(simpleBusConfig)
    val counter = Counter(p.burstSize, bus.cmd.fire)
    bus.cmd.valid := cmd.valid
    bus.cmd.address := cmd.address(31 downto widthOf(counter.value) + 2) @@ counter @@ U"00"
    bus.cmd.wr := False
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

    bus.ADR := (cmd.address >> widthOf(counter) + 2) @@ counter
    bus.CTI := lastCycle ? B"111" | B"010"
    bus.BTE := "00"
    bus.SEL := "1111"
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
}


case class InstructionCacheFlushBus() extends Bundle with IMasterSlave{
  val cmd = Event
  val rsp = Bool

  override def asMaster(): Unit = {
    master(cmd)
    in(rsp)
  }
}

class InstructionCache(p : InstructionCacheConfig) extends Component{
  import p._
  assert(cpuDataWidth == memDataWidth, "Need testing")
  val io = new Bundle{
    val flush = slave(InstructionCacheFlushBus())
    val cpu = slave(InstructionCacheCpuBus(p))
    val mem = master(InstructionCacheMemBus(p))
  }

  val lineWidth = bytePerLine*8
  val lineCount = cacheSize/bytePerLine
  val wordWidth = Math.max(memDataWidth,32)
  val wordWidthLog2 = log2Up(wordWidth)
  val wordPerLine = lineWidth/wordWidth
  val memWordPerLine = lineWidth/memDataWidth
  val bytePerWord = wordWidth/8
  val bytePerMemWord = memDataWidth/8
  val wayLineCount = lineCount/wayCount
  val wayLineLog2 = log2Up(wayLineCount)
  val wayWordCount = wayLineCount * wordPerLine

  val tagRange = addressWidth-1 downto log2Up(wayLineCount*bytePerLine)
  val lineRange = tagRange.low-1 downto log2Up(bytePerLine)
  val wordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerWord)
  val memWordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerMemWord)
  val memWordToCpuWordRange = log2Up(bytePerMemWord)-1 downto log2Up(bytePerWord)
  val tagLineRange = tagRange.high downto lineRange.low
  val lineWordRange = lineRange.high downto wordRange.low

  case class LineTag() extends Bundle{
    val valid = Bool
    val error = Bool
    val address = UInt(tagRange.length bit)
  }


  val ways = Seq.fill(wayCount)(new Area{
    val tags = Mem(LineTag(),wayLineCount)
    val datas = Mem(Bits(memDataWidth bits),wayWordCount)

    if(preResetFlush){
      tags.initBigInt(List.fill(wayLineCount)(BigInt(0)))
    }
  })

  io.cpu.prefetch.haltIt := False




  val lineLoader = new Area{
    val fire = False
    val valid = RegInit(False) clearWhen(fire)
    val address = Reg(UInt(addressWidth bits))
    val hadError = RegInit(False) clearWhen(fire)

    when(io.cpu.fill.valid){
      valid := True
      address := io.cpu.fill.payload
    }

    io.cpu.prefetch.haltIt setWhen(valid)

    val flushCounter = Reg(UInt(log2Up(wayLineCount) + 1 bit)) init(if(preResetFlush) wayLineCount else 0)
    when(!flushCounter.msb){
      io.cpu.prefetch.haltIt := True
      flushCounter := flushCounter + 1
    }
    when(!RegNext(flushCounter.msb)){
      io.cpu.prefetch.haltIt := True
    }
    val flushFromInterface = RegInit(False)
    io.flush.cmd.ready := !(valid || io.cpu.fetch.isValid) //io.cpu.fetch.isValid will avoid bug on first cycle miss
    when(io.flush.cmd.valid){
      io.cpu.prefetch.haltIt := True
      when(io.flush.cmd.ready){
        flushCounter := 0
        flushFromInterface := True
      }
    }

    io.flush.rsp := flushCounter.msb.rise && flushFromInterface



    val cmdSent = RegInit(False) setWhen(io.mem.cmd.fire) clearWhen(fire)
    io.mem.cmd.valid := valid && !cmdSent
    io.mem.cmd.address := address(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
    io.mem.cmd.size := log2Up(p.bytePerLine)

    val wayToAllocate = Counter(wayCount, fire)
    val wordIndex = Reg(UInt(log2Up(memWordPerLine) bits)) init(0)


    val write = new Area{
      val tag = ways.map(_.tags.writePort)
      val data = ways.map(_.datas.writePort)
    }

    for(wayId <- 0 until wayCount){
      val wayHit = wayToAllocate === wayId
      val tag = write.tag(wayId)
      tag.valid := ((wayHit && fire) || !flushCounter.msb)
      tag.address := (flushCounter.msb ? address(lineRange) | flushCounter(flushCounter.high-1 downto 0))
      tag.data.valid := flushCounter.msb
      tag.data.error := hadError || io.mem.rsp.error
      tag.data.address := address(tagRange)

      val data = write.data(wayId)
      data.valid   := io.mem.rsp.valid && wayHit
      data.address := address(lineRange) @@ wordIndex
      data.data    := io.mem.rsp.data
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
      val waysValues = for(way <- ways) yield new Area{
        val tag = if(asyncTagMemory) {
          way.tags.readAsync(io.cpu.fetch.pc(lineRange))
        }else {
          way.tags.readSync(io.cpu.prefetch.pc(lineRange), !io.cpu.fetch.isStuck)
        }
        val data = way.datas.readSync(io.cpu.prefetch.pc(lineRange.high downto memWordRange.low), !io.cpu.fetch.isStuck)
      }
    }


    val hit = if(!twoCycleRam) new Area{
      val hits = read.waysValues.map(way => way.tag.valid && way.tag.address === io.cpu.fetch.mmuBus.rsp.physicalAddress(tagRange))
      val valid = Cat(hits).orR
      val id = OHToUInt(hits)
      val error = read.waysValues.map(_.tag.error).read(id)
      val data = read.waysValues.map(_.data).read(id)
      val word = data.subdivideIn(cpuDataWidth bits).read(io.cpu.fetch.pc(memWordToCpuWordRange))
      io.cpu.fetch.data := word
      if(twoCycleCache){
        io.cpu.decode.data := RegNextWhen(io.cpu.fetch.data,!io.cpu.decode.isStuck)
      }
    } else null

    if(twoCycleRam && wayCount == 1){
      io.cpu.fetch.data := read.waysValues.head.data.subdivideIn(cpuDataWidth bits).read(io.cpu.fetch.pc(memWordToCpuWordRange))
    }

    io.cpu.fetch.mmuBus.cmd.isValid := io.cpu.fetch.isValid
    io.cpu.fetch.mmuBus.cmd.virtualAddress := io.cpu.fetch.pc
    io.cpu.fetch.mmuBus.cmd.bypassTranslation := False
    io.cpu.fetch.mmuBus.end := !io.cpu.fetch.isStuck || io.cpu.fetch.isRemoved
    io.cpu.fetch.physicalAddress := io.cpu.fetch.mmuBus.rsp.physicalAddress

    val resolution = ifGen(!twoCycleCache)( new Area{
//      def stage[T <: Data](that : T) = RegNextWhen(that,!io.cpu.decode.isStuck)
      val mmuRsp = io.cpu.fetch.mmuBus.rsp

      io.cpu.fetch.cacheMiss := !hit.valid
      io.cpu.fetch.error := hit.error
      io.cpu.fetch.mmuMiss := mmuRsp.miss
      io.cpu.fetch.illegalAccess := !mmuRsp.allowExecute || (io.cpu.fetch.isUser && !mmuRsp.allowUser)
    })
  }



  val decodeStage = ifGen(twoCycleCache) (new Area{
    def stage[T <: Data](that : T) = RegNextWhen(that,!io.cpu.decode.isStuck)
    val mmuRsp = stage(io.cpu.fetch.mmuBus.rsp)

    val hit = if(!twoCycleRam) new Area{
      val valid = stage(fetchStage.hit.valid)
      val error = stage(fetchStage.hit.error)
    } else new Area{
      val tags = fetchStage.read.waysValues.map(way => stage(way.tag))
      val hits = tags.map(tag => tag.valid && tag.address === mmuRsp.physicalAddress(tagRange))
      val valid = Cat(hits).orR
      val id = OHToUInt(hits)
      val error = tags(id).error
      val data = fetchStage.read.waysValues.map(way => stage(way.data)).read(id)
      val word = data.subdivideIn(cpuDataWidth bits).read(io.cpu.decode.pc(memWordToCpuWordRange))
      io.cpu.decode.data := word
    }

    io.cpu.decode.cacheMiss := !hit.valid
//    when( io.cpu.decode.isValid && io.cpu.decode.cacheMiss){
//      io.cpu.prefetch.haltIt := True
//      lineLoader.valid := True
//      lineLoader.address := mmuRsp.physicalAddress //Could be optimise if mmu not used
//    }
//    when(io.cpu)

    io.cpu.decode.error := hit.error
    io.cpu.decode.mmuMiss := mmuRsp.miss
    io.cpu.decode.illegalAccess := !mmuRsp.allowExecute || (io.cpu.decode.isUser && !mmuRsp.allowUser)
    io.cpu.decode.physicalAddress := mmuRsp.physicalAddress
  })
}

