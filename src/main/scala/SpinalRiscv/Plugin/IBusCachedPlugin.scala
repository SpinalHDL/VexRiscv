package SpinalRiscv.Plugin

import SpinalRiscv._
import spinal.core._
import spinal.lib._


case class InstructionCacheConfig( cacheSize : Int,
                                   bytePerLine : Int,
                                   wayCount : Int,
                                   wrappedMemAccess : Boolean,
                                   addressWidth : Int,
                                   cpuDataWidth : Int,
                                   memDataWidth : Int,
                                   catchAccessFault : Boolean,
                                   asyncTagMemory : Boolean){
  def burstSize = bytePerLine*8/memDataWidth
}



class IBusCachedPlugin(config : InstructionCacheConfig) extends Plugin[VexRiscv]{
  import config._
  var iBus  : InstructionCacheMemBus = null

  object IBUS_ACCESS_ERROR extends Stageable(Bool)
  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    pipeline.unremovableStages += pipeline.prefetch

    if(catchAccessFault) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val cache = new InstructionCache(this.config)
    iBus = master(new InstructionCacheMemBus(this.config)).setName("iBus")
    iBus <> cache.io.mem


    //Connect prefetch cache side
    cache.io.cpu.prefetch.isValid := prefetch.arbitration.isValid
    cache.io.cpu.prefetch.isFiring := prefetch.arbitration.isFiring
    cache.io.cpu.prefetch.address := prefetch.output(PC)
    prefetch.arbitration.haltIt setWhen(cache.io.cpu.prefetch.haltIt)

    //Connect fetch cache side
    cache.io.cpu.fetch.isValid  := fetch.arbitration.isValid
    cache.io.cpu.fetch.isStuck  := fetch.arbitration.isStuck
    cache.io.cpu.fetch.address  := fetch.output(PC)
    fetch.arbitration.haltIt setWhen(cache.io.cpu.fetch.haltIt)
    fetch.insert(INSTRUCTION) := cache.io.cpu.fetch.data

    cache.io.flush.cmd.valid := False


    if(catchAccessFault){
      fetch.insert(IBUS_ACCESS_ERROR) := cache.io.cpu.fetch.error

      decodeExceptionPort.valid   := decode.arbitration.isValid && decode.input(IBUS_ACCESS_ERROR)
      decodeExceptionPort.code    := 1
      decodeExceptionPort.badAddr := decode.input(PC)
    }
  }
}



case class InstructionCacheCpuCmd(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val isValid    = Bool
  val isFiring = Bool
  val haltIt   = Bool
  val address  = UInt(p.addressWidth bit)

  override def asMaster(): Unit = {
    out(isValid, isFiring, address)
    in(haltIt)
  }
}

case class InstructionCacheCpuRsp(p : InstructionCacheConfig) extends Bundle with IMasterSlave {
  val isValid = Bool
  val haltIt  = Bool
  val isStuck = Bool
  val address = UInt(p.addressWidth bit)
  val data    = Bits(32 bit)
  val error   = if(p.catchAccessFault) Bool else null

  override def asMaster(): Unit = {
    out(isValid, isStuck, address)
    in(haltIt, data)
    if(p.catchAccessFault) in(error)
  }
}


case class InstructionCacheCpuBus(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val prefetch = InstructionCacheCpuCmd(p)
  val fetch = InstructionCacheCpuRsp(p)

  override def asMaster(): Unit = {
    master(prefetch)
    master(fetch)
  }
}

case class InstructionCacheTranslationBus(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val virtualAddress  = UInt(32 bits)
  val physicalAddress = UInt(32 bits)
  val error           = if(p.catchAccessFault) Bool else null

  override def asMaster(): Unit = {
    out(virtualAddress)
    in(physicalAddress)
    if(p.catchAccessFault) in(error)
  }
}

case class InstructionCacheMemCmd(p : InstructionCacheConfig) extends Bundle{
  val address = UInt(p.addressWidth bit)
}
case class InstructionCacheMemRsp(p : InstructionCacheConfig) extends Bundle{
  val data = Bits(32 bit)
  val error = if(p.catchAccessFault) Bool else null
}

case class InstructionCacheMemBus(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val cmd = Stream (InstructionCacheMemCmd(p))
  val rsp = Flow (InstructionCacheMemRsp(p))

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
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
  assert(wayCount == 1)
  assert(cpuDataWidth == memDataWidth)
  val io = new Bundle{
    val flush = slave(InstructionCacheFlushBus())
//    val translator = master(InstructionCacheTranslationBus(p))
    val cpu = slave(InstructionCacheCpuBus(p))
    val mem = master(InstructionCacheMemBus(p))
  }
//  val haltCpu = False
  val lineWidth = bytePerLine*8
  val lineCount = cacheSize/bytePerLine
  val wordWidth = Math.max(memDataWidth,32)
  val wordWidthLog2 = log2Up(wordWidth)
  val wordPerLine = lineWidth/wordWidth
  val bytePerWord = wordWidth/8
  val wayLineCount = lineCount/wayCount
  val wayLineLog2 = log2Up(wayLineCount)
  val wayWordCount = wayLineCount * wordPerLine

  val tagRange = addressWidth-1 downto log2Up(wayLineCount*bytePerLine)
  val lineRange = tagRange.low-1 downto log2Up(bytePerLine)
  val wordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerWord)
  val tagLineRange = tagRange.high downto lineRange.low

  class LineInfo extends Bundle{
    val valid = Bool
    val error = if(catchAccessFault) Bool else null
    val address = UInt(tagRange.length bit)
  }

//  class LineWord extends Bundle{
//    val data  = Bits(wordWidth bits)
//    val error = Bool
//  }

  val ways = Array.fill(wayCount)(new Area{
    val tags = Mem(new LineInfo(),wayLineCount)
    val datas = Mem(Bits(wordWidth bits),wayWordCount)
  })


  io.cpu.prefetch.haltIt := False

  val lineLoader = new Area{
    val requestIn = Stream(wrap(new Bundle{
      val addr = UInt(addressWidth bits)
    }))


    if(wrappedMemAccess)
      io.mem.cmd.address := requestIn.addr(tagRange.high downto wordRange.low) @@ U(0,wordRange.low bit)
    else
      io.mem.cmd.address := requestIn.addr(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)


    val flushCounter = Reg(UInt(log2Up(wayLineCount) + 1 bit)) init(0)
    when(!flushCounter.msb){
      io.cpu.prefetch.haltIt := True
      flushCounter := flushCounter + 1
    }
    when(!RegNext(flushCounter.msb)){
      io.cpu.prefetch.haltIt := True
    }
    val flushFromInterface = RegInit(False)
    when(io.flush.cmd.valid){
      io.cpu.prefetch.haltIt := True
      when(io.flush.cmd.ready){
        flushCounter := 0
        flushFromInterface := True
      }
    }

    io.flush.rsp := flushCounter.msb.rise && flushFromInterface

    val loadingWithErrorReg = if(catchAccessFault) RegInit(False) else null
    val loadingWithError    = if(catchAccessFault) loadingWithErrorReg else null
    if(catchAccessFault) loadingWithErrorReg := loadingWithError



    val request = requestIn.haltWhen(!io.mem.cmd.ready).stage()

    val lineInfoWrite = new LineInfo()
    lineInfoWrite.valid := flushCounter.msb
    lineInfoWrite.address := request.addr(tagRange)
    if(catchAccessFault) lineInfoWrite.error := loadingWithError


    io.mem.cmd.valid := requestIn.valid && !request.isStall
    val wordIndex = Reg(UInt(log2Up(wordPerLine) bit))
    val loadedWordsNext = Bits(wordPerLine bit)
    val loadedWords = RegNext(loadedWordsNext)
    val loadedWordsReadable = RegNext(loadedWords)
    loadedWordsNext := loadedWords
    when(io.mem.rsp.valid){
      wordIndex := wordIndex + 1
      loadedWordsNext(wordIndex) := True
      ways(0).datas(request.addr(lineRange) @@ wordIndex) := io.mem.rsp.data   //TODO
      if(catchAccessFault) loadingWithError setWhen io.mem.rsp.error
    }

    val memRspLast = loadedWordsNext === B(loadedWordsNext.range -> true)

    val readyDelay = Reg(UInt(1 bit))
    when(memRspLast){
      readyDelay := readyDelay + 1
    }
    request.ready := readyDelay === 1


    when((request.valid && memRspLast) || !flushCounter.msb){
      val tagsAddress = Mux(flushCounter.msb,request.addr(lineRange),flushCounter(flushCounter.high-1 downto 0))
      ways(0).tags(tagsAddress) := lineInfoWrite  //TODO
    }

    when(requestIn.ready){
      wordIndex := io.mem.cmd.address(wordRange)
      loadedWords := 0
      loadedWordsReadable := 0
      readyDelay := 0
      if(catchAccessFault) loadingWithErrorReg := False
    }
  }

  val task = new Area{
    val waysHitValid = False
    val waysHitError = Bool.assignDontCare()
    val waysHitWord = Bits(wordWidth bit)
//    waysHitWord.assignDontCare()

    val waysRead = for(way <- ways) yield new Area{
      val readAddress = Mux(io.cpu.fetch.isStuck,io.cpu.fetch.address,io.cpu.prefetch.address)
//      val readAddress = io.cpu.prefetch.address
      val tag = if(asyncTagMemory)
        way.tags.readAsync(io.cpu.fetch.address(lineRange))
      else
        way.tags.readSync(readAddress(lineRange))

      val data = way.datas.readSync(readAddress(lineRange.high downto wordRange.low))
      //      val readAddress = request.address
      //      val tag = way.tags.readAsync(readAddress(lineRange))
      //      val data = way.datas.readAsync(readAddress(lineRange.high downto wordRange.low))
      //      way.tags.add(new AttributeString("ramstyle","no_rw_check"))
      //      way.datas.add(new AttributeString("ramstyle","no_rw_check"))
      waysHitWord := data //Not applicable to multi way
      when(tag.valid && tag.address === io.cpu.fetch.address(tagRange)) {
        waysHitValid := True
        if(catchAccessFault) waysHitError := tag.error
      }

      when(lineLoader.request.valid && lineLoader.request.addr(lineRange) === io.cpu.fetch.address(lineRange)){
        waysHitValid := False //Not applicable to multi way
      }
    }


    val loaderHitValid = lineLoader.request.valid && lineLoader.request.addr(tagLineRange) === io.cpu.fetch.address(tagLineRange)
    val loaderHitReady = lineLoader.loadedWordsReadable(io.cpu.fetch.address(wordRange))


    io.cpu.fetch.haltIt := io.cpu.fetch.isValid && !(waysHitValid || (loaderHitValid && loaderHitReady))
    io.cpu.fetch.data := waysHitWord //TODO
    if(catchAccessFault) io.cpu.fetch.error := (waysHitValid && waysHitError) ||  (loaderHitValid && loaderHitReady && lineLoader.loadingWithErrorReg)
    lineLoader.requestIn.valid := io.cpu.fetch.isValid && ! waysHitValid
    lineLoader.requestIn.addr := io.cpu.fetch.address
  }

  io.flush.cmd.ready := !(lineLoader.request.valid || io.cpu.fetch.isValid)
}
//
//object InstructionCacheMain{
//
//  def main(args: Array[String]) {
//    implicit val p = InstructionCacheConfig(
//      cacheSize =4096,
//      bytePerLine =32,
//      wayCount = 1,
//      wrappedMemAccess = true,
//      addressWidth = 32,
//      cpuDataWidth = 32,
//      memDataWidth = 32,
//      catchAccessFault = true)
//    //    val io = new Bundle{
//    //      val cpu = slave(InstructionCacheCpuBus())
//    //      val mem = master(InstructionCacheMemBus())
//    //    }
//
//    SpinalVhdl(new InstructionCache(p))
//  }
//}
//
