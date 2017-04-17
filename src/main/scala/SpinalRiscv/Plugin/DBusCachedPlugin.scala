//package SpinalRiscv.Plugin
//
//import SpinalRiscv.Riscv._
//import SpinalRiscv.{Stageable, DecoderService, Riscv, VexRiscv}
//import spinal.core._
//import spinal.lib._
//
//
//case class DataCacheConfig( cacheSize : Int,
//                            bytePerLine : Int,
//                            wayCount : Int,
//                            addressWidth : Int,
//                            cpuDataWidth : Int,
//                            memDataWidth : Int,
//                            catchAccessFault : Boolean = false){
//  def burstSize = bytePerLine*8/memDataWidth
//  val burstLength = bytePerLine/(memDataWidth/8)
//  assert(catchAccessFault == false)
//}
//
//
//class DBusCachedPlugin(config : DataCacheConfig)  extends Plugin[VexRiscv]{
//  import config._
//  var dBus  : DataCacheMemBus = null
//
//  object MEMORY_ENABLE extends Stageable(Bool)
//  object MEMORY_ADDRESS_LOW extends Stageable(UInt(2 bits))
//
//  override def setup(pipeline: VexRiscv): Unit = {
//    import Riscv._
//    import pipeline.config._
//
//    val decoderService = pipeline.service(classOf[DecoderService])
//
//    val stdActions = List[(Stageable[_ <: BaseType],Any)](
//      SRC1_CTRL         -> Src1CtrlEnum.RS,
//      SRC_USE_SUB_LESS  -> False,
//      MEMORY_ENABLE     -> True,
//      REG1_USE          -> True
//    ) ++ (if (catchAccessFault) List(IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB) else Nil) //Used for access fault bad address in memory stage
//
//    val loadActions = stdActions ++ List(
//      SRC2_CTRL -> Src2CtrlEnum.IMI,
//      REGFILE_WRITE_VALID -> True,
//      BYPASSABLE_EXECUTE_STAGE -> False,
//      BYPASSABLE_MEMORY_STAGE -> False
//    )
//
//    val storeActions = stdActions ++ List(
//      SRC2_CTRL -> Src2CtrlEnum.IMS,
//      REG2_USE -> True
//    )
//
//    decoderService.addDefault(MEMORY_ENABLE, False)
//    decoderService.add(
//      List(LB, LH, LW, LBU, LHU, LWU).map(_ -> loadActions) ++
//      List(SB, SH, SW).map(_ -> storeActions)
//    )
//  }
//
//  override def build(pipeline: VexRiscv): Unit = {
//    import pipeline._
//    import pipeline.config._
//
//    dBus = master(DataCacheMemBus(this.config)).setName("dBus")
//
//    val cache = new DataCache(this.config)
//    cache.io.mem <> dBus
//
//    execute plug new Area {
//      import execute._
//      //TODO manage removeIt
//
//      val size = input(INSTRUCTION)(13 downto 12).asUInt
//      cache.io.cpu.execute.isValid := arbitration.isValid && input(MEMORY_ENABLE)
//      cache.io.cpu.execute.isStuck := arbitration.isStuck
////      arbitration.haltIt.setWhen(cache.io.cpu.execute.haltIt)
//      cache.io.cpu.execute.args.wr := input(INSTRUCTION)(5)
//      cache.io.cpu.execute.args.address := input(SRC_ADD).asUInt
//      cache.io.cpu.execute.args.data := size.mux(
//        U(0)    -> input(REG2)( 7 downto 0) ## input(REG2)( 7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0),
//        U(1)    -> input(REG2)(15 downto 0) ## input(REG2)(15 downto 0),
//        default -> input(REG2)(31 downto 0)
//      )
//      cache.io.cpu.execute.args.mask := (size.mux (
//        U(0)    -> B"0001",
//        U(1)    -> B"0011",
//        default -> B"1111"
//      ) << cache.io.cpu.execute.args.address(1 downto 0)).resized
//      cache.io.cpu.execute.args.bypass := cache.io.cpu.execute.args.address(31 downto 28) === 0xF
//      cache.io.cpu.execute.args.all := False
//      cache.io.cpu.execute.args.kind := DataCacheCpuCmdKind.MEMORY
//
//      insert(MEMORY_ADDRESS_LOW) := cache.io.cpu.execute.args.address(1 downto 0)
//    }
//
//    memory plug new Area{
//      import memory._
//      cache.io.cpu.memory.isValid := arbitration.isValid && input(MEMORY_ENABLE)
//      cache.io.cpu.memory.isStuck := arbitration.isStuck
//    }
//
//    writeBack plug new Area{
//      import writeBack._
//      assert(! arbitration.isStuck)
//      cache.io.cpu.writeBack.isValid := arbitration.isValid && input(MEMORY_ENABLE)
//      arbitration.haltIt.setWhen(cache.io.cpu.writeBack.haltIt)
//
//      val rspShifted = Bits(32 bits)
//      rspShifted := cache.io.cpu.writeBack.data
//      switch(input(MEMORY_ADDRESS_LOW)){
//        is(1){rspShifted(7 downto 0) := cache.io.cpu.writeBack.data(15 downto 8)}
//        is(2){rspShifted(15 downto 0) := cache.io.cpu.writeBack.data(31 downto 16)}
//        is(3){rspShifted(7 downto 0) := cache.io.cpu.writeBack.data(31 downto 24)}
//      }
//
//      val rspFormated = input(INSTRUCTION)(13 downto 12).mux(
//        0 -> B((31 downto 8) -> (rspShifted(7) && !input(INSTRUCTION)(14)),(7 downto 0) -> rspShifted(7 downto 0)),
//        1 -> B((31 downto 16) -> (rspShifted(15) && ! input(INSTRUCTION)(14)),(15 downto 0) -> rspShifted(15 downto 0)),
//        default -> rspShifted //W
//      )
//
//      when(arbitration.isValid && input(MEMORY_ENABLE)) {
//        input(REGFILE_WRITE_DATA) := rspFormated
//      }
//
//      assert(!(arbitration.isValid && input(MEMORY_ENABLE) && !input(INSTRUCTION)(5) && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
//    }
//  }
//}
//
//
//
//object DataCacheCpuCmdKind extends SpinalEnum{
//  val MEMORY,FLUSH,EVICT = newElement()
//}
//
//object DataCacheCpuExecute{
//  implicit def implArgs(that : DataCacheCpuExecute) = that.args
//}
//
//case class DataCacheCpuExecute(p : DataCacheConfig) extends Bundle with IMasterSlave{
//  val isValid = Bool
//  val isStuck = Bool
////  val haltIt = Bool
//  val args = DataCacheCpuExecuteArgs(p)
//
//  override def asMaster(): Unit = {
//    out(isValid, isStuck, args)
////    in(haltIt)
//  }
//}
//
//case class DataCacheCpuExecuteArgs(p : DataCacheConfig) extends Bundle{
//  val kind = DataCacheCpuCmdKind()
//  val wr = Bool
//  val address = UInt(p.addressWidth bit)
//  val data = Bits(p.cpuDataWidth bit)
//  val mask = Bits(p.cpuDataWidth/8 bit)
//  val bypass = Bool
//  val all = Bool                      //Address should be zero when "all" is used
//}
//
//case class DataCacheCpuMemory(p : DataCacheConfig) extends Bundle with IMasterSlave{
//  val isValid = Bool
//  val isStuck = Bool
//
//  override def asMaster(): Unit = {
//    out(isValid, isStuck)
//  }
//}
//
//
//case class DataCacheCpuWriteBack(p : DataCacheConfig) extends Bundle with IMasterSlave{
//  val isValid = Bool
//  val isStuck = Bool
//  val haltIt = Bool
//  val data = Bits(p.cpuDataWidth bit)
//
//  override def asMaster(): Unit = {
//    out(isValid,isStuck)
//    in(haltIt, data)
//  }
//}
//
//case class DataCacheCpuBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
//  val execute   = DataCacheCpuExecute(p)
//  val memory    = DataCacheCpuMemory(p)
//  val writeBack = DataCacheCpuWriteBack(p)
//
//  override def asMaster(): Unit = {
//    master(execute)
//    master(memory)
//    master(writeBack)
//  }
//}
//
//
//case class DataCacheMemCmd(p : DataCacheConfig) extends Bundle{
//  val wr = Bool
//  val address = UInt(p.addressWidth bit)
//  val data = Bits(p.memDataWidth bits)
//  val mask = Bits(p.memDataWidth/8 bits)
//  val length = UInt(log2Up(p.burstLength+1) bit)
//}
//case class DataCacheMemRsp(p : DataCacheConfig) extends Bundle{
//  val data = Bits(p.memDataWidth bit)
//}
//
//case class DataCacheMemBus(p : DataCacheConfig) extends Bundle with IMasterSlave{
//  val cmd = Stream (DataCacheMemCmd(p))
//  val rsp = Flow (DataCacheMemRsp(p))
//
//  override def asMaster(): Unit = {
//    master(cmd)
//    slave(rsp)
//  }
//}
//
//
//class DataCache(p : DataCacheConfig) extends Component{
//  import p._
//  assert(wayCount == 1)
//  assert(cpuDataWidth == memDataWidth)
//
//  val io = new Bundle{
//    val cpu = slave(DataCacheCpuBus(p))
//    val mem = master(DataCacheMemBus(p))
//    val flushDone = out Bool //It pulse at the same time than the manager.request.fire
//  }
//  val haltCpu = False
//  val lineWidth = bytePerLine*8
//  val lineCount = cacheSize/bytePerLine
//  val wordWidth = Math.max(memDataWidth,cpuDataWidth)
//  val wordWidthLog2 = log2Up(wordWidth)
//  val wordPerLine = lineWidth/wordWidth
//  val bytePerWord = wordWidth/8
//  val wayLineCount = lineCount/wayCount
//  val wayLineLog2 = log2Up(wayLineCount)
//  val wayWordCount = wayLineCount * wordPerLine
//  val memTransactionPerLine = p.bytePerLine / (p.memDataWidth/8)
//
//  val tagRange = addressWidth-1 downto log2Up(wayLineCount*bytePerLine)
//  val lineRange = tagRange.low-1 downto log2Up(bytePerLine)
//  val wordRange = log2Up(bytePerLine)-1 downto log2Up(bytePerWord)
//
//
//  class LineInfo() extends Bundle{
//    val used = Bool
//    val dirty = Bool
//    val address = UInt(tagRange.length bit)
//  }
//
//  val tagsReadCmd =  UInt(log2Up(wayLineCount) bits)
//  val tagsWriteCmd = Flow(new Bundle{
//    val way = UInt(log2Up(wayCount) bits)
//    val address = UInt(log2Up(wayLineCount) bits)
//    val data = new LineInfo()
//  })
//
//  val tagsWriteLastCmd = RegNext(tagsWriteCmd)
//
//  val dataReadCmd =  Flow(UInt(log2Up(wayWordCount) bits))
//  val dataWriteCmd = Flow(new Bundle{
//    val way = UInt(log2Up(wayCount) bits)
//    val address = UInt(log2Up(wayWordCount) bits)
//    val data = Bits(wordWidth bits)
//    val mask = Bits(wordWidth/8 bits)
//  })
//
//  dataReadCmd.valid := False
//  dataReadCmd.payload.assignDontCare()
//  tagsWriteCmd.valid := False
//  tagsWriteCmd.payload.assignDontCare()
//  dataWriteCmd.valid := False
//  dataWriteCmd.payload.assignDontCare()
//  io.mem.cmd.valid := False
//  io.mem.cmd.payload.assignDontCare()
//
//
//
//
//  val ways = Array.tabulate(wayCount)(id => new Area{
//    val tags = Mem(new LineInfo(),wayLineCount)
//    val data = Mem(Bits(wordWidth bit),wayWordCount)
//
//    when(tagsWriteCmd.valid && tagsWriteCmd.way === id){
//      tags(tagsWriteCmd.address) := tagsWriteCmd.data
//    }
//    when(dataWriteCmd.valid && dataWriteCmd.way === id){
//      data.write(
//        address = dataWriteCmd.address,
//        data = dataWriteCmd.data,
//        mask = dataWriteCmd.mask
//      )
//    }
//    val dataReadRsp = data.readSync(dataReadCmd.payload,dataReadCmd.valid)
//  })
//
////  val dataReadedValue = Vec(id => RegNext(ways(id).dataReadRsp),ways.length)
//
//
//  def coherentWrap[T <: Data](readAddress : UInt, readData : T, writeValid : Bool, writeAddress : UInt, writeData : T, writeMask : Bits) : T = {
//    if(writeMask == null){
//      (writeValid && writeAddress === readAddress) ? writeData | readData
//    } else {
//
//    }
//  }
//
//  val victim = new Area{//TODO! restor data read after usage
//    val requestIn = Stream(cloneable(new Bundle{
//      val way = UInt(log2Up(wayCount) bits)
//      val address = UInt(p.addressWidth bits)
//    }))
//    requestIn.valid := False
//    requestIn.payload.assignDontCare()
//
//    val request = requestIn.stage() //TODO FMAX AREA half pipe ?
//    request.ready := False
//
//    val buffer = Mem(Bits(p.memDataWidth bits),memTransactionPerLine << 1)  // << 1 because of cyclone II issue, should be removed //.add(new AttributeString("ramstyle","M4K"))
//
//    //Send line read commands to fill the buffer
//    val readLineCmdCounter = Reg(UInt(log2Up(memTransactionPerLine + 1) bits)) init(0)
//    val dataReadCmdOccure = False
//    val dataReadCmdOccureLast = RegNext(dataReadCmdOccure)
//
//    when(request.valid && !readLineCmdCounter.msb){
//      readLineCmdCounter := readLineCmdCounter + 1
//      //dataReadCmd := request.address(lineRange.high downto wordRange.low)   Done in the manager
//      dataReadCmdOccure := True
//      dataReadCmd.valid := True
//      dataReadCmd.payload := request.address(lineRange) @@ readLineCmdCounter(readLineCmdCounter.high-1 downto 0)
//    }
//
//    //Fill the buffer with line read responses
//    val readLineRspCounter = Reg(UInt(log2Up(memTransactionPerLine + 1) bits)) init(0)
//    when(readLineCmdCounter >= 2 && !readLineRspCounter.msb && Delay(dataReadCmdOccure,2)){
//      buffer(readLineRspCounter.resized) := dataReadedValue(request.way)
//      readLineRspCounter := readLineRspCounter + 1
//    }
//
//    //Send buffer read commands
//    val bufferReadCounter = Reg(UInt(log2Up(memTransactionPerLine + 1) bits)) init(0)
//    val bufferReadStream = Stream(buffer.addressType)
//    bufferReadStream.valid := readLineRspCounter > bufferReadCounter
//    bufferReadStream.payload := bufferReadCounter.resized
//    when(bufferReadStream.fire){
//      bufferReadCounter := bufferReadCounter + 1
//    }
//    val bufferReaded = buffer.streamReadSync(bufferReadStream).stage
//    bufferReaded.ready := False
//
//    //Send memory writes from bufffer read responses
//    val bufferReadedCounter = Reg(UInt(log2Up(memTransactionPerLine) bits)) init(0)
//    val memCmdAlreadyUsed = False
//    when(bufferReaded.valid) {
//      io.mem.cmd.valid := True
//      io.mem.cmd.wr := True
//      io.mem.cmd.address := request.address(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
//      io.mem.cmd.length := p.burstLength
//      io.mem.cmd.data := bufferReaded.payload
//      io.mem.cmd.mask := (1<<(wordWidth/8))-1
//
//      when(!memCmdAlreadyUsed && io.mem.cmd.ready){
//        bufferReaded.ready := True
//        bufferReadedCounter := bufferReadedCounter + 1
//        when(bufferReadedCounter === bufferReadedCounter.maxValue){
//          request.ready := True
//        }
//      }
//    }
//
//
//    val counter = Counter(memTransactionPerLine)
//    when(request.ready){
//      readLineCmdCounter.msb := False
//      readLineRspCounter.msb := False
//      bufferReadCounter.msb := False
//    }
//  }
//
//  val stageA = new Area{
//    val request = RegNextWhen(io.cpu.execute.args, !io.cpu.memory.isStuck)
//
//    tagsReadCmd := request.address(lineRange)
//    when(!io.cpu.memory.isStuck){
//      dataReadCmd.valid := True
//      dataReadCmd.payload := request.address(lineRange.high downto wordRange.low)  //TODO FMAX mayybe critical path could be default
//    }
//
//    val waysHitValid = False
//    val waysHitOneHot = Bits(wayCount bits)
//    val waysHitId = OHToUInt(waysHitOneHot)
//    val waysHitInfo = new LineInfo().assignDontCare()
//
//    val waysRead = for ((way,id) <- ways.zipWithIndex) yield new Area {
//      val tag = way.tags.readSync(tagsReadCmd)
//      //Write first
//      when(tagsWriteLastCmd.valid && tagsWriteLastCmd.way === id && tagsWriteLastCmd.address === RegNext(request.address(lineRange))){
//        tag := tagsWriteLastCmd.data
//      }
//      waysHitOneHot(id) := tag.used && tag.address === request.address(tagRange)
//      when(waysHitOneHot(id)) {
//        waysHitValid := True
//        waysHitInfo := tag
//      }
//    }
//  }
//
//  val stageB = new Area {
//    io.flushDone := False
//
//    val request = RegNextWhen(stageA.request, !io.cpu.writeBack.isStuck)
//    val waysHit = RegNextWhen(stageA.waysHitValid, !io.cpu.writeBack.isStuck)
//    val waysId = RegNextWhen(stageA.waysHitId, !io.cpu.writeBack.isStuck)
//    val waysInfo = RegNextWhen(stageA.waysHitInfo, !io.cpu.writeBack.isStuck)
//    val waysData = Reg(Bits(32 bits))
//
//    //Evict the cache after reset
//    val requestValid = io.cpu.writeBack.isValid || RegNextWhen(False, !io.cpu.writeBack.isStuck, True)
////    val requestHazard = RegNext( //TODO!
////      !io.cpu.memory.isStuck &&
////      io.cpu.execute.address === request.address && requestValid &&
////      request.kind === DataCacheCpuCmdKind.MEMORY && request.wr &&
////      io.cpu.execute.kind === DataCacheCpuCmdKind.MEMORY && !io.cpu.execute.wr
////    ) init(False)
//    request.kind.init(DataCacheCpuCmdKind.EVICT)
//    request.all.init(True)
//    request.address.init(0)
//
//    io.cpu.writeBack.haltIt := requestValid
//
//
//    //Loader interface
//    val loaderValid = False
//    val loaderReady = False
//    val loadingDone = RegNext(loaderValid && loaderReady) init(False) //one cycle pulse
//
//
////    val flushAllState = RegInit(False) //Used to keep logic timings fast
////    val flushAllDone = RegNext(False) init(False)
//
//    val victimNotSent  = RegInit(False) clearWhen(victim.requestIn.ready) setWhen(!io.cpu.memory.isStuck)
//    val loadingNotDone = RegInit(False) clearWhen(loaderReady) setWhen(!io.cpu.memory.isStuck)
//
//    import DataCacheCpuCmdKind._
//    when(requestValid) {
//      switch(request.kind) {
//        is(EVICT){
//          when(request.all){
//            tagsWriteCmd.valid := True
//            tagsWriteCmd.way := 0
//            tagsWriteCmd.address := request.address(lineRange)
//            tagsWriteCmd.data.used := False
//            when(request.address(lineRange) =/= lineCount-1){
//              request.address.getDrivingReg(lineRange) := request.address(lineRange) + 1
//            }otherwise{
//              io.cpu.writeBack.haltIt := False
//            }
//          }otherwise{
//            when(waysHit) {
//              tagsWriteCmd.valid := True
//              tagsWriteCmd.way := waysId
//              tagsWriteCmd.address := request.address(lineRange)
//              tagsWriteCmd.data.used := False
//            }
//            io.cpu.writeBack.haltIt := False
//          }
//        }
////        is(FLUSH) { //TODO!
////          when(request.all) {
////            when(!flushAllState){
////              victim.requestIn.valid := waysRead(0).tag.used && waysRead(0).tag.dirty
////              victim.requestIn.way := writebackWayId
////              victim.requestIn.address := writebackWayInfo.address @@ request.address(lineRange) @@ U((lineRange.low - 1 downto 0) -> false)
////
////              tagsWriteCmd.way := writebackWayId
////              tagsWriteCmd.address := request.address(lineRange)
////              tagsWriteCmd.data.used := False
////
////              when(!victim.requestIn.isStall) {
////                request.address.getDrivingReg(lineRange) := request.address(lineRange) + 1
////                flushAllDone :=  request.address(lineRange) === lineCount-1
////                flushAllState := True
////                tagsWriteCmd.valid := True
////              }
////            } otherwise{
////              //Wait tag read
////              flushAllState := False
////              io.cpu.memory.haltIt.clearWhen(flushAllDone)
////              io.flushDone := flushAllDone
////            }
////          } otherwise {
////            when(delayedValid) {
////              when(delayedWaysHitValid) {
////                io.cpu.memory.haltIt.clearWhen(victim.requestIn.ready)
////
////                victim.requestIn.valid := True
////                victim.requestIn.way := writebackWayId
////                victim.requestIn.address := writebackWayInfo.address @@ request.address(lineRange) @@ U((lineRange.low - 1 downto 0) -> false)
////
////                tagsWriteCmd.valid := victim.requestIn.ready
////                tagsWriteCmd.way := writebackWayId
////                tagsWriteCmd.address := request.address(lineRange)
////                tagsWriteCmd.data.used := False
////              } otherwise{
////                io.cpu.memory.haltIt := False
////                io.flushDone := True
////              }
////            }
////          }
////        }
//        is(MEMORY) {
//          when(request.bypass) {
//            when(!victim.request.valid) {
//              //Can't+rite burst
//              val memCmdValid = RegInit(False) clearWhen(io.mem.cmd.ready) setWhen(!io.cpu.writeBack.isStuck)
//              io.mem.cmd.valid := memCmdValid
//              io.mem.cmd.wr := request.wr
//              io.mem.cmd.address := request.address(tagRange.high downto wordRange.low) @@ U(0,wordRange.low bit)
//              io.mem.cmd.mask := request.mask
//              io.mem.cmd.data := request.data
//              io.mem.cmd.length := 1
//
//              io.cpu.writeBack.haltIt.clearWhen(io.mem.rsp.fire || (!memCmdValid && request.wr)) //Cut mem.cmd.ready path but insert one cycle stall when write
//            }
//          } otherwise {
//            when(waysHit || !loadingNotDone){
//              io.cpu.writeBack.haltIt := False
//              dataWriteCmd.way := waysId
//              dataWriteCmd.address := request.address(lineRange.high downto wordRange.low)
//              dataWriteCmd.data := request.data
//              dataWriteCmd.mask := request.mask
//
//              tagsWriteCmd.way := waysId
//              tagsWriteCmd.address := request.address(lineRange)
//              tagsWriteCmd.data.used := True
//              tagsWriteCmd.data.dirty := True
//              tagsWriteCmd.data.address := request.address(tagRange)
//              when(request.wr) {
//                dataWriteCmd.valid := True
//                tagsWriteCmd.valid := True
//              }
//            } otherwise {
//              loaderValid := loadingNotDone && !(victimNotSent && victim.request.isStall)
//              when(waysInfo.used && waysInfo.dirty) {
//                victim.requestIn.valid := victimNotSent
//                victim.requestIn.way  := waysId
//                victim.requestIn.address := waysInfo.address @@ request.address(lineRange) @@ U((lineRange.low - 1 downto 0) -> false)
//              }
//            }
//          }
//        }
//      }
//    }
//
//
//
//
////    io.cpu.memory.haltIt.setWhen(requestHazard) //TODO!
//
//
//    io.cpu.writeBack.data := request.bypass ? io.mem.rsp.data | waysData //not multi ways
//  }
//
//  //The whole life of a loading task, the corresponding manager request is present
//  val loader = new Area{
//    val valid = RegNext(stageB.loaderValid) init(False)
//    val wayId = RegNext(stageB.waysId)
//    val baseAddress =  stageB.request.address
//
//    val memCmdSent = RegInit(False)
//    when(valid && !memCmdSent) {
//      io.mem.cmd.valid := True
//      io.mem.cmd.wr := False
//      io.mem.cmd.address := baseAddress(tagRange.high downto lineRange.low) @@ U(0,lineRange.low bit)
//      io.mem.cmd.length := p.burstLength
//    }
//
//    when(valid && io.mem.cmd.ready){
//      memCmdSent := True
//    }
//
//    when(valid && !memCmdSent) {
//      victim.memCmdAlreadyUsed := True
//    }
//
//    val counter = Counter(memTransactionPerLine)
//    when(valid && io.mem.rsp.valid){
//      dataWriteCmd.valid := True
//      dataWriteCmd.way := wayId
//      dataWriteCmd.address := baseAddress(lineRange) @@ counter
//      dataWriteCmd.data := io.mem.rsp.data
//      dataWriteCmd.mask := (1<<(wordWidth/8))-1
//      counter.increment()
//    }
//
//    when(counter.willOverflow){
//      memCmdSent := False
//      valid := False
//      tagsWriteCmd.valid := True
//      tagsWriteCmd.way := wayId
//      tagsWriteCmd.address := baseAddress(lineRange)
//      tagsWriteCmd.data.used := True
//      tagsWriteCmd.data.dirty := False
//      tagsWriteCmd.data.address := baseAddress(tagRange)
//      stageB.loaderReady := True
//    }
//  }
//
//  //Avoid read after write data hazard
//  //TODO FIX it to not stall write after read ? , requestValid is pessimistic ?
//  //io.cpu.execute.haltIt := io.cpu.execute.address === manager.request.address && manager.requestValid && io.cpu.execute.isValid
//}
//
//object DataCacheMain{
//  def main(args: Array[String]) {
//
//    SpinalVhdl({
//      implicit val p = DataCacheConfig(
//        cacheSize =4096,
//        bytePerLine =32,
//        wayCount = 1,
//        addressWidth = 32,
//        cpuDataWidth = 32,
//        memDataWidth = 32)
//      new WrapWithReg.Wrapper(new DataCache(p)).setDefinitionName("TopLevel")
//    })
////    SpinalVhdl({
////      implicit val p = DataCacheConfig(
////        cacheSize =512,
////        bytePerLine =16,
////        wayCount = 1,
////        addressWidth = 12,
////        cpuDataWidth = 16,
////        memDataWidth = 16)
////      new DataCache(p)
////    })
//  }
//}