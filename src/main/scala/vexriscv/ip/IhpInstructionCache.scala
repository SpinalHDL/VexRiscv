package vexriscv.ip

import vexriscv._
import vexriscv.ihp.sg13g2._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4ReadOnly}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbAccessParameter, BmbParameter, BmbSourceParameter}
import spinal.lib.bus.wishbone.{AddressGranularity, Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.plugin.{IBusSimpleBus, IBusSimplePlugin}


class IhpInstructionCache(p : InstructionCacheConfig, mmuParameter : MemoryTranslatorBusParameter) extends Component with InstructionCacheIp{
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

  case class LineTagNoAddr() extends Bundle {
    val valid = Bool
    val error = Bool
  }

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

  val banks = Seq.fill(bankCount)(new Area {
    val bank = Memory(memDataWidth, cacheSize)
    bank.connectDefaults()
    bank.A_MEN := True
    bank.A_REN := False
    bank.B_MEN := True
    bank.B_WEN := False
    bank.B_DIN := B(0)
  })

  val ways = Seq.fill(wayCount)(new Area{
    val tags = Mem(LineTagNoAddr(), wayLineCount)
    val addr = Memory(22, cacheSize)
    addr.connectDefaults()
    addr.A_ADDR := io.cpu.prefetch.pc(lineRange).asBits
    addr.A_MEN := True
    addr.A_REN := True
    addr.A_DIN := B(0)
    addr.A_WEN := False
    addr.B_MEN := True
    addr.B_REN := False

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
    }

    for(wayId <- 0 until wayCount) {
      val wayHit = wayToAllocate === wayId
      val tag = write.tag(wayId)
      tag.valid := ((wayHit && fire) || !flushCounter.msb)
      tag.address := (flushCounter.msb ? address(lineRange) | flushCounter(flushCounter.high-1 downto 0))
      tag.data.valid := flushCounter.msb
      tag.data.error := hadError || io.mem.rsp.error
      val addr = ways(wayId).addr
      addr.B_ADDR := (flushCounter.msb ? address(lineRange) | flushCounter(flushCounter.high-1 downto 0)).asBits
      addr.B_WEN := ((wayHit && fire) || !flushCounter.msb)
      addr.B_DIN := address(tagRange).asBits // TODO
    }

    for((writeBank, bankId) <- banks.zipWithIndex){
      if(!reducedBankWidth) {
        writeBank.bank.A_WEN := io.mem.rsp.valid && wayToAllocate === bankId
        writeBank.bank.A_ADDR := (address(lineRange) @@ wordIndex).asBits.resized
        writeBank.bank.A_DIN := io.mem.rsp.data
      } else {
        val sel = U(bankId) - wayToAllocate.value
        val groupSel = wayToAllocate(log2Up(bankCount)-1 downto log2Up(bankCount/memToBankRatio))
        val subSel = sel(log2Up(bankCount/memToBankRatio) -1 downto 0)
        writeBank.bank.A_WEN := io.mem.rsp.valid && groupSel === (bankId >> log2Up(bankCount/memToBankRatio))
        writeBank.bank.A_ADDR := (address(lineRange) @@ wordIndex @@ (subSel)).asBits
        writeBank.bank.A_DIN := io.mem.rsp.data.subdivideIn(bankCount/memToBankRatio slices)(subSel)
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
      val banksValue = for(readBank <- banks) yield new Area{
        readBank.bank.B_REN := !io.cpu.fetch.isStuck
        readBank.bank.B_ADDR := io.cpu.prefetch.pc(lineRange.high downto log2Up(bankWidth/8)).asBits
        val dataMem = readBank.bank.B_DOUT
        val data = if(!twoCycleRamInnerMux) dataMem.subdivideIn(cpuDataWidth bits).read(io.cpu.fetch.pc(bankWordToCpuWordRange)) else dataMem
      }

      val waysValues = for((way, wayId) <- ways.zipWithIndex) yield new Area{
        val tag = new LineTag()
        if(asyncTagMemory) {
          tag.valid := way.tags.readAsync(io.cpu.fetch.pc(lineRange)).valid
          tag.error := way.tags.readAsync(io.cpu.fetch.pc(lineRange)).error
        } else {
          tag.valid := way.tags.readSync(io.cpu.prefetch.pc(lineRange), !io.cpu.fetch.isStuck).valid
          tag.error := way.tags.readSync(io.cpu.prefetch.pc(lineRange), !io.cpu.fetch.isStuck).error
        }
        tag.address := way.addr.A_DOUT(21 downto 0).asUInt.resized
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
    def stage[T <: Data](that : T) = RegNextWhen(that, !io.cpu.decode.isStuck)
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
