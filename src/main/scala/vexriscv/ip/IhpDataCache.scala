package vexriscv.ip

import vexriscv._
import vexriscv.ihp.sg13g2._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi.{Axi4Config, Axi4Shared}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}
import spinal.lib.bus.bmb.{Bmb, BmbAccessParameter, BmbCmd, BmbInvalidationParameter, BmbParameter, BmbSourceParameter}
import spinal.lib.bus.wishbone.{AddressGranularity, Wishbone, WishboneConfig}
import spinal.lib.bus.simple._
import vexriscv.plugin.DBusSimpleBus


class IhpDataCache(val p : DataCacheConfig, mmuParameter : MemoryTranslatorBusParameter) extends Component with DataCacheIp{
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
  val cpuWordToRfWordRange = log2Up(bytePerWord)-1 downto log2Up(p.rfDataBytes)


  class LineInfoNoAddr() extends Bundle{
    val valid, error = Bool()
  }

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
    val tags = Mem(new LineInfoNoAddr(), wayLineCount)
    //val data = Mem(Bits(memDataWidth bit), wayMemWordCount)
    val addr = Memory(22, cacheSize)
    addr.connectDefaults()
    addr.A_MEN := True
    addr.A_REN := False
    addr.A_WEN := False
    addr.A_DIN := B(0)
    addr.B_MEN := True
    addr.B_REN := False
    addr.B_WEN := False
    val data = Memory(memDataWidth, cacheSize)
    data.connectDefaults()
    data.A_MEN := True
    data.A_REN := False
    data.A_WEN := False
    data.A_DIN := B(0)
    data.B_MEN := True
    data.B_REN := False
    data.B_WEN := False

    //Reads
    val tagsReadRsp = new LineInfo()
    val tagsReadRspMem = tags.readSync(tagsReadCmd.payload, tagsReadCmd.valid && !io.cpu.memory.isStuck)
    tagsReadRsp.valid := tagsReadRspMem.valid
    tagsReadRsp.error := tagsReadRspMem.error
    tagsReadRsp.address := addr.A_DOUT.asUInt
    addr.A_ADDR := tagsReadCmd.payload.asBits
    when (tagsReadCmd.valid && !io.cpu.memory.isStuck) {
      addr.A_REN := True
    }
    data.A_ADDR := dataReadCmd.payload.asBits
    when (dataReadCmd.valid && !io.cpu.memory.isStuck) {
      data.A_REN := True
    }
    val dataReadRspMem = data.A_DOUT
    val dataReadRspSel = if(mergeExecuteMemory) io.cpu.writeBack.address else io.cpu.memory.address
    val dataReadRsp = dataReadRspMem.subdivideIn(cpuDataWidth bits).read(dataReadRspSel(memWordToCpuWordRange))

    require(withInvalidate == false, "withInvalidate not supported")
    val tagsInvReadRsp = withInvalidate generate({
      val tagsReadRsp = new LineInfo()
      val tagsReadRspMem = tags.readSync(tagsInvReadCmd.payload, tagsInvReadCmd.valid)
      tagsReadRsp.valid := tagsReadRspMem.valid
      tagsReadRsp.error := tagsReadRspMem.error
      // Would require third memory port
      tagsReadRsp.address := U(0)
      tagsReadRsp
    })

    //Writes
    when(tagsWriteCmd.valid && tagsWriteCmd.way(i)){
      val tagNoAddr = new LineInfoNoAddr()
      tagNoAddr.valid := tagsWriteCmd.data.valid
      tagNoAddr.error := tagsWriteCmd.data.error
      tags.write(tagsWriteCmd.address, tagNoAddr)
      addr.B_WEN := True
    }
    addr.B_ADDR := tagsWriteCmd.address.asBits
    addr.B_DIN := tagsWriteCmd.data.address.asBits

    when(dataWriteCmd.valid && dataWriteCmd.way(i)){
      data.B_WEN := True
    }
    data.B_ADDR := dataWriteCmd.address.asBits
    data.B_DIN := dataWriteCmd.data
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
  val memCmdSent = RegInit(False) setWhen (io.mem.cmd.fire) clearWhen (!io.cpu.writeBack.isStuck)
  val pending = withExclusive generate new Area{
    val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
    val counterNext = counter + U(io.mem.cmd.fire && io.mem.cmd.last) - ((io.mem.rsp.valid  && io.mem.rsp.last) ? (io.mem.rsp.aggregated +^ 1) | 0)
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
    val syncCount = io.mem.sync.aggregated +^ 1
    val syncContext = new Area{
      val history = Mem(Bool, pendingMax)
      val wPtr, rPtr = Reg(UInt(log2Up(pendingMax)+1 bits)) init(0)
      when(io.mem.cmd.fire && io.mem.cmd.wr){
        history.write(wPtr.resized, io.mem.cmd.uncached)
        wPtr := wPtr + 1
      }

      when(io.mem.sync.fire){
        rPtr := rPtr + syncCount
      }
      val uncached = history.readAsync(rPtr.resized)
      val full = RegNext(wPtr - rPtr >= pendingMax-1)
      val empty = wPtr === rPtr
      io.cpu.writesPending := !empty
      io.cpu.execute.haltIt setWhen(full)
    }

    def pending(inc : Bool, dec : Bool) = new Area {
      val pendingSync = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
      val pendingSyncNext = pendingSync + U(io.mem.cmd.fire && io.mem.cmd.wr && inc) - ((io.mem.sync.fire && dec) ? syncCount | 0)
      pendingSync := pendingSyncNext
    }

    val writeCached = pending(inc = !io.mem.cmd.uncached, dec = !syncContext.uncached)
    val writeUncached = pending(inc = io.mem.cmd.uncached, dec = syncContext.uncached)

    def track(load : Bool, uncached : Boolean) = new Area {
      val counter = Reg(UInt(log2Up(pendingMax) + 1 bits)) init(0)
      counter := counter - ((io.mem.sync.fire && counter =/= 0 && (if(uncached) syncContext.uncached else !syncContext.uncached)) ? syncCount | 0)
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
//    val mask = io.cpu.execute.size.mux (
//      U(0)    -> B"0001",
//      U(1)    -> B"0011",
//      default -> B"1111"
//    ) |<< io.cpu.execute.address(1 downto 0)

    val mask = io.cpu.execute.size.muxListDc((0 to log2Up(p.cpuDataBytes)).map(i => U(i) -> B((1 << (1 << i)) -1, p.cpuDataBytes bits))) |<< io.cpu.execute.address(log2Up(p.cpuDataBytes)-1 downto 0)


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
//    val unaligned = if(!catchUnaligned) False else stagePipe((stageA.request.size === 2 && io.cpu.memory.address(1 downto 0) =/= 0) || (stageA.request.size === 1 && io.cpu.memory.address(0 downto 0) =/= 0))
    val unaligned = if(!catchUnaligned) False else stagePipe((1 to log2Up(p.cpuDataBytes)).map(i => stageA.request.size === i && io.cpu.memory.address(i-1 downto 0) =/= 0).orR)
    val waysHitsBeforeInvalidate = if(earlyWaysHits) stagePipe(B(stageA.wayHits)) else B(tagsReadRsp.map(tag => mmuRsp.physicalAddress(tagRange) === tag.address && tag.valid).asBits())
    val waysHits = waysHitsBeforeInvalidate & ~wayInvalidate
    val waysHit = waysHits.orR
    val dataMux = if(earlyDataMux) stagePipe(stageA.dataMux) else MuxOH(waysHits, dataReadRsp)
    val mask = stagePipe(stageA.mask)

    //Loader interface
    val loaderValid = False

    val ioMemRspMuxed = io.mem.rsp.data.subdivideIn(cpuDataWidth bits).read(io.cpu.writeBack.address(memWordToCpuWordRange))

    io.cpu.writeBack.haltIt := True

    //Evict the cache after reset logics
    val flusher = new Area {
      val waitDone = RegInit(False) clearWhen(io.cpu.flush.ready)
      val hold = False
      val counter = Reg(UInt(lineRange.size + 1 bits)) init(0)
      when(!counter.msb) {
        tagsWriteCmd.valid := True
        tagsWriteCmd.address := counter.resized
        tagsWriteCmd.way.setAll()
        tagsWriteCmd.data.valid := False
        io.cpu.execute.haltIt := True
        when(!hold) {
          counter := counter + 1
          when(io.cpu.flush.valid && io.cpu.flush.singleLine){
            counter.msb := True
          }
        }
      }

      io.cpu.flush.ready := waitDone && counter.msb

      val start = RegInit(True) //Used to relax timings
      start := !waitDone && !start && io.cpu.flush.valid && !io.cpu.execute.isValid && !io.cpu.memory.isValid && !io.cpu.writeBack.isValid && !io.cpu.redo

      when(start){
        waitDone := True
        counter := 0
        when(io.cpu.flush.valid && io.cpu.flush.singleLine){
          counter := U"0" @@ io.cpu.flush.lineId
        }
      }
    }

    val lrSc = withInternalLrSc generate new Area{
      val reserved = RegInit(False)
      when(io.cpu.writeBack.isValid && io.cpu.writeBack.isFiring){
        reserved setWhen(request.isLrsc)
        reserved clearWhen(request.wr)
      }
    }

    val isAmo = if(withAmo) request.isAmo else False
    val isAmoCached = if(withInternalAmo) isAmo else False
    val isExternalLsrc = if(withExternalLrSc) request.isLrsc else False
    val isExternalAmo  = if(withExternalAmo)  request.isAmo  else False

    val requestDataBypass = CombInit(io.cpu.writeBack.storeData)
    import DataCacheExternalAmoStates._
    val amo = withAmo generate new Area{
      def rf = io.cpu.writeBack.storeData(p.rfDataWidth-1 downto 0)
      def memLarger = if(withInternalAmo) dataMux else ioMemRspMuxed
      def mem = memLarger.subdivideIn(rfDataWidth bits).read(io.cpu.writeBack.address(cpuWordToRfWordRange))
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

    val badPermissions = (!mmuRsp.allowWrite && request.wr) || (!mmuRsp.allowRead && (!request.wr || isAmo))
    val loadStoreFault = io.cpu.writeBack.isValid && (mmuRsp.exception || badPermissions)

    io.cpu.redo := False
    io.cpu.writeBack.accessError := False
    io.cpu.writeBack.mmuException :=  loadStoreFault && (if(catchIllegal) mmuRsp.isPaging else False)
    io.cpu.writeBack.unalignedAccess := io.cpu.writeBack.isValid && unaligned
    io.cpu.writeBack.isWrite := request.wr


    io.mem.cmd.valid := False
    io.mem.cmd.address := mmuRsp.physicalAddress
    io.mem.cmd.last := True
    io.mem.cmd.wr := request.wr
    io.mem.cmd.mask := mask
    io.mem.cmd.data := requestDataBypass
    io.mem.cmd.uncached := mmuRsp.isIoAccess
    io.mem.cmd.size := request.size.resized
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
          io.mem.cmd.address(0, lineRange.low bits) := 0
          io.mem.cmd.size := log2Up(p.bytePerLine)

          loaderValid setWhen(io.mem.cmd.ready)
        }
      }
    }

    when(bypassCache){
      io.cpu.writeBack.data := ioMemRspMuxed
      def isLast = if(pending != null) pending.last else True
      if(catchAccessError) io.cpu.writeBack.accessError := !request.wr && isLast && io.mem.rsp.valid && io.mem.rsp.error
    } otherwise {
      io.cpu.writeBack.data := dataMux
      if(catchAccessError) io.cpu.writeBack.accessError := (waysHits & B(tagsReadRsp.map(_.error))) =/= 0 || (loadStoreFault && !mmuRsp.isPaging)
    }

    if(withLrSc) {
      val success = if(withInternalLrSc)lrSc.reserved else io.mem.rsp.exclusive
      io.cpu.writeBack.exclusiveOk := success
      when(request.isLrsc && request.wr){
        //      io.cpu.writeBack.data := B(!success).resized
        if(withExternalLrSc) when(io.cpu.writeBack.isValid && io.mem.rsp.valid && rspSync && success && waysHit){
          cpuWriteToCache := True
        }
      }
    }
    if(withAmo) when(request.isAmo){
      requestDataBypass.subdivideIn(p.rfDataWidth bits).foreach(_ := amo.resultReg)
    }

    //remove side effects on exceptions
    when(io.cpu.writeBack.isValid) {
      when(consistancyHazard || mmuRsp.refilling || io.cpu.writeBack.accessError || io.cpu.writeBack.mmuException || io.cpu.writeBack.unalignedAccess) {
        io.mem.cmd.valid := False
        tagsWriteCmd.valid := False
        dataWriteCmd.valid := False
        loaderValid := False
        io.cpu.writeBack.haltIt := False
        if (withInternalLrSc) lrSc.reserved := lrSc.reserved
        if (withExternalAmo) amo.external.state := LR_CMD
      }
      io.cpu.redo setWhen((mmuRsp.refilling || consistancyHazard))
    }

    assert(!(io.cpu.writeBack.isValid && !io.cpu.writeBack.haltIt && io.cpu.writeBack.isStuck), "writeBack stuck by another plugin is not allowed", ERROR)
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

    io.cpu.redo setWhen(valid.rise())
    io.cpu.execute.refilling := valid

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
      io.mem.ack.last := input.last

      //Manage invalidation read during write hazard
      s1.invalidations := RegNextWhen((input.valid && input.enable && input.address(lineRange) === s0.input.address(lineRange)) ? wayHits | 0, s0.input.ready)
    }
  }
}
