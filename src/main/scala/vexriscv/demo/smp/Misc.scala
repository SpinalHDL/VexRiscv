package vexriscv.demo.smp


import spinal.core._
import spinal.core.fiber._
import spinal.lib.bus.bmb._
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig, WishboneSlaveFactory}
import spinal.lib.com.jtag.Jtag
import spinal.lib._
import spinal.lib.bus.bmb.sim.{BmbMemoryMultiPort, BmbMemoryTester}
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.eda.bench.Bench
import spinal.lib.generator._
import spinal.lib.misc.Clint
import spinal.lib.sim.{SimData, SparseMemory, StreamDriver, StreamMonitor, StreamReadyRandomizer}
import vexriscv.{VexRiscv, VexRiscvConfig}
import vexriscv.plugin.{CsrPlugin, DBusCachedPlugin, DebugPlugin, IBusCachedPlugin}

import scala.collection.mutable
import scala.util.Random

case class LiteDramNativeParameter(addressWidth : Int, dataWidth : Int)

case class LiteDramNativeCmd(p : LiteDramNativeParameter) extends Bundle{
  val we = Bool()
  val addr = UInt(p.addressWidth bits)
}

case class LiteDramNativeWData(p : LiteDramNativeParameter) extends Bundle{
  val data = Bits(p.dataWidth bits)
  val we = Bits(p.dataWidth/8 bits)
}

case class LiteDramNativeRData(p : LiteDramNativeParameter) extends Bundle{
  val data = Bits(p.dataWidth bits)
}


case class LiteDramNative(p : LiteDramNativeParameter) extends Bundle with IMasterSlave {
  val cmd = Stream(LiteDramNativeCmd(p))
  val wdata = Stream(LiteDramNativeWData(p))
  val rdata = Stream(LiteDramNativeRData(p))
  override def asMaster(): Unit = {
    master(cmd, wdata)
    slave(rdata)
  }

  def fromBmb(bmb : Bmb, wdataFifoSize : Int, rdataFifoSize : Int) = {
    val bridge = BmbToLiteDram(
      bmbParameter = bmb.p,
      liteDramParameter = this.p,
      wdataFifoSize = wdataFifoSize,
      rdataFifoSize = rdataFifoSize
    )
    bridge.io.input << bmb
    bridge.io.output <> this
    bridge
  }

  def simSlave(ram : SparseMemory,cd : ClockDomain, bmb : Bmb = null): Unit ={
    import spinal.core.sim._
    def bus = this
    case class Cmd(address : Long, we : Boolean)
    case class WData(data : BigInt, we : Long)
    val cmdQueue = mutable.Queue[Cmd]()
    val wdataQueue = mutable.Queue[WData]()
    val rdataQueue = mutable.Queue[BigInt]()


    case class Ref(address : Long, data : BigInt, we : Long, time : Long)
    val ref = mutable.Queue[Ref]()
    if(bmb != null) StreamMonitor(bmb.cmd, cd){p =>
      if(bmb.cmd.opcode.toInt == 1) ref.enqueue(Ref(p.fragment.address.toLong, p.fragment.data.toBigInt, p.fragment.mask.toLong, simTime()))
    }

    var writeCmdCounter, writeDataCounter = 0
    StreamReadyRandomizer(bus.cmd, cd).factor = 0.5f
    StreamMonitor(bus.cmd, cd) { t =>
      cmdQueue.enqueue(Cmd(t.addr.toLong * (p.dataWidth/8) , t.we.toBoolean))
      if(t.we.toBoolean) writeCmdCounter += 1
    }

    StreamReadyRandomizer(bus.wdata, cd).factor = 0.5f
    StreamMonitor(bus.wdata, cd) { p =>
      writeDataCounter += 1
      //      if(p.data.toBigInt == BigInt("00000002000000020000000200000002",16)){
      //        println("ASD")
      //      }
      wdataQueue.enqueue(WData(p.data.toBigInt, p.we.toLong))
    }

    //    new SimStreamAssert(cmd,cd)
    //    new SimStreamAssert(wdata,cd)
    //    new SimStreamAssert(rdata,cd)

    cd.onSamplings{
      if(writeDataCounter-writeCmdCounter > 2){
        println("miaou")
      }
      if(cmdQueue.nonEmpty && Random.nextFloat() < 0.5){
        val cmd = cmdQueue.head
        if(cmd.we){
          if(wdataQueue.nonEmpty){
            //            if(cmd.address == 0xc02ae850l) {
            //              println(s"! $writeCmdCounter $writeDataCounter")
            //            }
            cmdQueue.dequeue()
            val wdata = wdataQueue.dequeue()
            val raw = wdata.data.toByteArray
            val left = wdata.data.toByteArray.size-1
            if(bmb != null){
              assert(ref.nonEmpty)
              assert((ref.head.address & 0xFFFFFFF0l) == cmd.address)
              assert(ref.head.data == wdata.data)
              assert(ref.head.we == wdata.we)
              ref.dequeue()
            }
            //            if(cmd.address == 0xc02ae850l) {
            //              println(s"$cmd $wdata ${simTime()}")
            //            }
            for(i <- 0 until p.dataWidth/8){


              if(((wdata.we >> i) & 1) != 0) {
                //                if(cmd.address == 0xc02ae850l) {
                //                  println(s"W $i ${ if (left - i >= 0) raw(left - i) else 0}")
                //                }
                ram.write(cmd.address + i, if (left - i >= 0) raw(left - i) else 0)
              }
            }
          }
        } else {
          cmdQueue.dequeue()
          val value = new Array[Byte](p.dataWidth/8+1)
          val left = value.size-1
          for(i <- 0 until p.dataWidth/8) {
            value(left-i) = ram.read(cmd.address+i)
          }
          rdataQueue.enqueue(BigInt(value))
        }
      }
    }

    StreamDriver(bus.rdata, cd){ p =>
      if(rdataQueue.isEmpty){
        false
      } else {
        p.data #= rdataQueue.dequeue()
        true
      }
    }
  }
}



case class BmbToLiteDram(bmbParameter : BmbParameter,
                         liteDramParameter : LiteDramNativeParameter,
                         wdataFifoSize : Int,
                         rdataFifoSize : Int) extends Component{
  val io = new Bundle {
    val input = slave(Bmb(bmbParameter))
    val output = master(LiteDramNative(liteDramParameter))
  }

  val resized = io.input.resize(liteDramParameter.dataWidth)
  val unburstified = resized.unburstify()
  case class Context() extends Bundle {
    val context = Bits(unburstified.p.access.contextWidth bits)
    val source  = UInt(unburstified.p.access.sourceWidth bits)
    val isWrite = Bool()
  }

  assert(isPow2(rdataFifoSize))
  val pendingRead = Reg(UInt(log2Up(rdataFifoSize) + 1 bits)) init(0)

  val halt = Bool()
  val (cmdFork, dataFork) = StreamFork2(unburstified.cmd.haltWhen(halt))
  val outputCmd =  Stream(LiteDramNativeCmd(liteDramParameter))
  outputCmd.arbitrationFrom(cmdFork.haltWhen(pendingRead.msb))
  outputCmd.addr := (cmdFork.address >> log2Up(liteDramParameter.dataWidth/8)).resized
  outputCmd.we := cmdFork.isWrite

  io.output.cmd <-< outputCmd

  if(bmbParameter.access.canWrite) {
    val wData = Stream(LiteDramNativeWData(liteDramParameter))
    wData.arbitrationFrom(dataFork.throwWhen(dataFork.isRead))
    wData.data := dataFork.data
    wData.we := dataFork.mask
    io.output.wdata << wData.queueLowLatency(wdataFifoSize, latency = 1)
  } else {
    dataFork.ready := True
    io.output.wdata.valid := False
    io.output.wdata.data.assignDontCare()
    io.output.wdata.we.assignDontCare()
  }

  val cmdContext = Stream(Context())
  cmdContext.valid := unburstified.cmd.fire
  cmdContext.context := unburstified.cmd.context
  cmdContext.source  := unburstified.cmd.source
  cmdContext.isWrite := unburstified.cmd.isWrite
  halt := !cmdContext.ready

  val rspContext = cmdContext.queue(rdataFifoSize)
  val rdataFifo = io.output.rdata.queueLowLatency(rdataFifoSize, latency = 1)
  val writeTocken = CounterUpDown(
    stateCount = rdataFifoSize*2,
    incWhen = io.output.wdata.fire,
    decWhen = rspContext.fire && rspContext.isWrite
  )
  val canRspWrite = writeTocken =/= 0
  val canRspRead = CombInit(rdataFifo.valid)

  rdataFifo.ready := unburstified.rsp.fire && !rspContext.isWrite
  rspContext.ready := unburstified.rsp.fire
  unburstified.rsp.valid := rspContext.valid && (rspContext.isWrite  ? canRspWrite | canRspRead)
  unburstified.rsp.setSuccess()
  unburstified.rsp.last := True
  unburstified.rsp.source := rspContext.source
  unburstified.rsp.context := rspContext.context
  unburstified.rsp.data := rdataFifo.data


  pendingRead := pendingRead + U(outputCmd.fire && !outputCmd.we) - U(rdataFifo.fire)
}

object BmbToLiteDramTester extends App{
  import spinal.core.sim._
  SimConfig.withWave.compile(BmbToLiteDram(
    bmbParameter = BmbParameter(
      addressWidth = 20,
      dataWidth = 32,
      lengthWidth = 6,
      sourceWidth = 4,
      contextWidth = 16
    ),
    liteDramParameter = LiteDramNativeParameter(
      addressWidth = 20,
      dataWidth = 128
    ),
    wdataFifoSize = 16,
    rdataFifoSize = 16
  )).doSimUntilVoid(seed = 42){dut =>
    val tester = new BmbMemoryTester(dut.io.input, dut.clockDomain, rspCounterTarget = 3000)
    dut.io.output.simSlave(tester.memory.memory, dut.clockDomain)
  }
}

case class BmbToLiteDramGenerator(mapping : AddressMapping)(implicit interconnect : BmbInterconnectGenerator) extends Area{
  val liteDramParameter = Handle[LiteDramNativeParameter]
  val bmb = Handle(logic.io.input)
  val dram = Handle(logic.io.output.toIo)

  val accessSource = Handle[BmbAccessCapabilities]
  val accessRequirements = Handle[BmbAccessParameter]
  interconnect.addSlave(
    accessSource             = accessSource,
    accessCapabilities       = accessSource,
    accessRequirements       = accessRequirements,
    bus                      = bmb,
    mapping                  = mapping
  )
  val logic = Handle(BmbToLiteDram(
    bmbParameter = accessRequirements.toBmbParameter(),
    liteDramParameter = liteDramParameter,
    wdataFifoSize = 32,
    rdataFifoSize = 32
  ))
}

case class BmbToWishboneGenerator(mapping : AddressMapping)(implicit interconnect : BmbInterconnectGenerator) extends Area{
  val bmb = Handle(logic.io.input)
  val wishbone = Handle(logic.io.output)

  val accessSource = Handle[BmbAccessCapabilities]
  val accessRequirements = Handle[BmbAccessParameter]
  interconnect.addSlave(
    accessSource             = accessSource,
    accessCapabilities       = accessSource,
    accessRequirements       = accessRequirements,
    bus                      = bmb,
    mapping                  = mapping
  )
  val logic = Handle(BmbToWishbone(
    p = accessRequirements.toBmbParameter()
  ))
}
