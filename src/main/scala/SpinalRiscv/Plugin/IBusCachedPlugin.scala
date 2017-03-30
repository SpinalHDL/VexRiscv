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
                                   memDataWidth : Int){
  def burstSize = bytePerLine*8/memDataWidth
}




class IBusCachedPlugin(catchAccessFault : Boolean, cacheConfig : InstructionCacheConfig) extends Plugin[VexRiscv]{
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

    assert(catchAccessFault == false) //unimplemented


    val cache = new InstructionCache(cacheConfig)
    iBus = master(new InstructionCacheMemBus(cacheConfig)).setName("iBus")
    iBus <> cache.io.mem


    //Connect prefetch cache side
    cache.io.cpu.cmd.isValid := prefetch.arbitration.isValid
    cache.io.cpu.cmd.isFiring := prefetch.arbitration.isFiring
    cache.io.cpu.cmd.address := prefetch.output(PC)
    prefetch.arbitration.haltIt setWhen(cache.io.cpu.cmd.haltIt)

    //Connect fetch cache side
    cache.io.cpu.rsp.isValid  := fetch.arbitration.isValid
    cache.io.cpu.rsp.isStuck  := fetch.arbitration.isStuck
    cache.io.cpu.rsp.address  := fetch.output(PC)
    fetch.arbitration.haltIt setWhen(cache.io.cpu.rsp.haltIt)
    fetch.insert(INSTRUCTION) := cache.io.cpu.rsp.data

    cache.io.flush.cmd.valid := False

//    fetch.insert(IBUS_ACCESS_ERROR) := iRsp.error

//    if(catchAccessFault){
//      decodeExceptionPort.valid   := decode.arbitration.isValid && decode.input(IBUS_ACCESS_ERROR)
//      decodeExceptionPort.code    := 1
//      decodeExceptionPort.badAddr := decode.input(PC)
//    }
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
  val isValid   = Bool
  val haltIt  = Bool
  val isStuck  = Bool
  val address = UInt(p.addressWidth bit)
  val data    = Bits(32 bit)

  override def asMaster(): Unit = {
    out(isValid, isStuck, address)
    in(haltIt, data)
  }
}


case class InstructionCacheCpuBus(p : InstructionCacheConfig) extends Bundle with IMasterSlave{
  val cmd = InstructionCacheCpuCmd(p)
  val rsp = InstructionCacheCpuRsp(p)

  override def asMaster(): Unit = {
    master(cmd)
    master(rsp)
  }
}


case class InstructionCacheMemCmd(p : InstructionCacheConfig) extends Bundle{
  val address = UInt(p.addressWidth bit)
}
case class InstructionCacheMemRsp(p : InstructionCacheConfig) extends Bundle{
  val data = Bits(32 bit)
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


  class LineInfo() extends Bundle{
    val valid = Bool
    val address = UInt(tagRange.length bit)
  }

  val ways = Array.fill(wayCount)(new Area{
    val tags = Mem(new LineInfo(),wayLineCount)
    val datas = Mem(Bits(wordWidth bit),wayWordCount)
  })


  io.cpu.cmd.haltIt := False

  val lineLoader = new Area{
    val requestIn = Stream(wrap(new Bundle{
      val addr = UInt(addressWidth bit)
    }))


    if(wrappedMemAccess)
      io.mem.cmd.address := requestIn.addr(tagRange.high downto wordRange.low) @@ U(0,wordRange.low bit)
    else
      io.mem.cmd.address := requestIn.addr(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)


    val flushCounter = Reg(UInt(log2Up(wayLineCount) + 1 bit)) init(0)
    when(!flushCounter.msb){
      io.cpu.cmd.haltIt := True
      flushCounter := flushCounter + 1
    }
    when(!RegNext(flushCounter.msb)){
      io.cpu.cmd.haltIt := True
    }
    val flushFromInterface = RegInit(False)
    when(io.flush.cmd.valid){
      io.cpu.cmd.haltIt := True
      when(io.flush.cmd.ready){
        flushCounter := 0
        flushFromInterface := True
      }
    }

    io.flush.rsp := flushCounter.msb.rise && flushFromInterface

    val lineInfoWrite = new LineInfo()
    lineInfoWrite.valid := flushCounter.msb
    lineInfoWrite.address := requestIn.addr(tagRange)
    when(requestIn.fire || !flushCounter.msb){
      val tagsAddress = Mux(flushCounter.msb,requestIn.addr(lineRange),flushCounter(flushCounter.high-1 downto 0))
      ways(0).tags(tagsAddress) := lineInfoWrite  //TODO
    }


    val request = requestIn.haltWhen(!io.mem.cmd.ready).stage()
    io.mem.cmd.valid := requestIn.valid && !request.isStall
    val wordIndex = Reg(UInt(log2Up(wordPerLine) bit))
    val loadedWordsNext = Bits(wordPerLine bit)
    val loadedWords = RegNext(loadedWordsNext)
    val loadedWordsReadable = RegNext(loadedWords)
    loadedWordsNext := loadedWords
    when(io.mem.rsp.fire){
      wordIndex := wordIndex + 1
      loadedWordsNext(wordIndex) := True
      ways(0).datas(request.addr(lineRange) @@ wordIndex) := io.mem.rsp.data   //TODO
    }

    val readyDelay = Reg(UInt(1 bit))
    when(loadedWordsNext === B(loadedWordsNext.range -> true)){
      readyDelay := readyDelay + 1
    }
    request.ready := readyDelay === 1

    when(requestIn.ready){
      wordIndex := io.mem.cmd.address(wordRange)
      loadedWords := 0
      loadedWordsReadable := 0
      readyDelay := 0
    }
  }

  val task = new Area{
    val waysHitValid = False
    val waysHitWord = Bits(wordWidth bit)
    waysHitWord.assignDontCare()

    val waysRead = for(way <- ways) yield new Area{
      val readAddress = Mux(io.cpu.rsp.isStuck,io.cpu.rsp.address,io.cpu.cmd.address)
      val tag = way.tags.readSync(readAddress(lineRange))
      val data = way.datas.readSync(readAddress(lineRange.high downto wordRange.low))
      //      val readAddress = request.address
      //      val tag = way.tags.readAsync(readAddress(lineRange))
      //      val data = way.datas.readAsync(readAddress(lineRange.high downto wordRange.low))
      //      way.tags.add(new AttributeString("ramstyle","no_rw_check"))
      //      way.datas.add(new AttributeString("ramstyle","no_rw_check"))
      when(tag.valid && tag.address === io.cpu.rsp.address(tagRange)) {
        waysHitValid := True
        waysHitWord := data
      }
    }

    val loaderHitValid = lineLoader.request.valid && lineLoader.request.addr(tagRange) === io.cpu.rsp.address(tagRange)
    val loaderHitReady = lineLoader.loadedWordsReadable(io.cpu.rsp.address(wordRange))


    io.cpu.rsp.haltIt := io.cpu.rsp.isValid && !( waysHitValid && !(loaderHitValid && !loaderHitReady))
    io.cpu.rsp.data := waysHitWord //TODO
    lineLoader.requestIn.valid := io.cpu.rsp.isValid && ! waysHitValid
    lineLoader.requestIn.addr := io.cpu.rsp.address
  }

  io.flush.cmd.ready := !(lineLoader.request.valid || io.cpu.rsp.isValid)
}

object InstructionCacheMain{
  class TopLevel extends Component{
    implicit val p = InstructionCacheConfig(
      cacheSize =4096,
      bytePerLine =32,
      wayCount = 1,
      wrappedMemAccess = true,
      addressWidth = 32,
      cpuDataWidth = 32,
      memDataWidth = 32)
//    val io = new Bundle{
//      val cpu = slave(InstructionCacheCpuBus())
//      val mem = master(InstructionCacheMemBus())
//    }
    val cache = new InstructionCache(p)

//    cache.io.cpu.cmd <-< io.cpu.cmd
//    cache.io.mem.cmd >-> io.mem.cmd
//    cache.io.mem.rsp <-< io.mem.rsp
//    cache.io.cpu.rsp >-> io.cpu.rsp
    //    when(cache.io.cpu.rsp.valid){
    //      cache.io.cpu.cmd.valid := RegNext(cache.io.cpu.cmd.valid)
    //      cache.io.cpu.cmd.address := RegNext(cache.io.cpu.cmd.address)
    //    }
  }
  def main(args: Array[String]) {
    implicit val p = InstructionCacheConfig(
      cacheSize =4096,
      bytePerLine =32,
      wayCount = 1,
      wrappedMemAccess = true,
      addressWidth = 32,
      cpuDataWidth = 32,
      memDataWidth = 32)
    //    val io = new Bundle{
    //      val cpu = slave(InstructionCacheCpuBus())
    //      val mem = master(InstructionCacheMemBus())
    //    }

    SpinalVhdl(new InstructionCache(p))
  }
}

