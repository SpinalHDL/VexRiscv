package vexriscv.demo.smp

import spinal.core._
import spinal.lib.bus.bmb._
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig, WishboneSlaveFactory}
import spinal.lib.com.jtag.Jtag
import spinal.lib._
import spinal.lib.bus.bmb.sim.{BmbMemoryMultiPort, BmbMemoryTester}
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.eda.bench.Bench
import spinal.lib.misc.Clint
import spinal.lib.sim.{SimData, SparseMemory, StreamDriver, StreamMonitor, StreamReadyRandomizer}
import vexriscv.demo.smp.VexRiscvLitexSmpClusterOpenSbi.{cpuCount, parameter}
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig
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
    StreamReadyRandomizer(bus.cmd, cd)
    StreamMonitor(bus.cmd, cd) { t =>
      cmdQueue.enqueue(Cmd(t.addr.toLong * (p.dataWidth/8) , t.we.toBoolean))
      if(t.we.toBoolean) writeCmdCounter += 1
    }

    StreamReadyRandomizer(bus.wdata, cd)
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
    val context = Bits(unburstified.p.contextWidth bits)
    val source  = UInt(unburstified.p.sourceWidth bits)
    val isWrite = Bool()
  }

  assert(isPow2(rdataFifoSize))
  val pendingRead = Reg(UInt(log2Up(rdataFifoSize) + 1 bits)) init(0)

  val halt = Bool()
  val (cmdFork, dataFork) = StreamFork2(unburstified.cmd.haltWhen(halt))
  io.output.cmd.arbitrationFrom(cmdFork.haltWhen(pendingRead.msb))
  io.output.cmd.addr := (cmdFork.address >> log2Up(liteDramParameter.dataWidth/8)).resized
  io.output.cmd.we := cmdFork.isWrite

  if(bmbParameter.canWrite) {
    val wData = Stream(LiteDramNativeWData(liteDramParameter))
    wData.arbitrationFrom(dataFork.throwWhen(dataFork.isRead))
    wData.data := dataFork.data
    wData.we := dataFork.mask
    io.output.wdata << wData.queue(wdataFifoSize)
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

  rdataFifo.ready := unburstified.rsp.fire && !rspContext.isWrite
  rspContext.ready := unburstified.rsp.fire
  unburstified.rsp.valid := rspContext.valid && (rspContext.isWrite || rdataFifo.valid)
  unburstified.rsp.setSuccess()
  unburstified.rsp.last := True
  unburstified.rsp.source := rspContext.source
  unburstified.rsp.context := rspContext.context
  unburstified.rsp.data := rdataFifo.data


  pendingRead := pendingRead + U(io.output.cmd.fire && !io.output.cmd.we) - U(rdataFifo.fire)
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

case class VexRiscvLitexSmpClusterParameter( cluster : VexRiscvSmpClusterParameter,
                                             liteDram : LiteDramNativeParameter,
                                             liteDramMapping : AddressMapping)

case class VexRiscvLitexSmpCluster(p : VexRiscvLitexSmpClusterParameter,
                                   debugClockDomain : ClockDomain) extends Component{

  val peripheralWishboneConfig = WishboneConfig(
    addressWidth = 30,
    dataWidth = 32,
    selWidth = 4,
    useERR = true,
    useBTE = true,
    useCTI = true
  )

  val io = new Bundle {
    val dMem = master(LiteDramNative(p.liteDram))
    val iMem = master(LiteDramNative(p.liteDram))
    val peripheral = master(Wishbone(peripheralWishboneConfig))
    val clint = slave(Wishbone(Clint.getWisboneConfig()))
    val externalInterrupts = in Bits(p.cluster.cpuConfigs.size bits)
    val externalSupervisorInterrupts  = in Bits(p.cluster.cpuConfigs.size bits)
    val jtag = slave(Jtag())
    val debugReset = out Bool()
  }
  val cpuCount = p.cluster.cpuConfigs.size
  val clint = Clint(cpuCount)
  clint.driveFrom(WishboneSlaveFactory(io.clint))

  val cluster = VexRiscvSmpCluster(p.cluster, debugClockDomain)
  cluster.io.externalInterrupts <> io.externalInterrupts
  cluster.io.externalSupervisorInterrupts <> io.externalSupervisorInterrupts
  cluster.io.jtag <> io.jtag
  cluster.io.debugReset <> io.debugReset
  cluster.io.timerInterrupts <> B(clint.harts.map(_.timerInterrupt))
  cluster.io.softwareInterrupts <> B(clint.harts.map(_.softwareInterrupt))

  val dBusDecoder = BmbDecoderOutOfOrder(
    p            = cluster.io.dMem.p,
    mappings     = Seq(DefaultMapping, p.liteDramMapping),
    capabilities = Seq(cluster.io.dMem.p, cluster.io.dMem.p),
    pendingRspTransactionMax = 32
  )
//  val dBusDecoder = BmbDecoderOut(
//    p            = cluster.io.dMem.p,
//    mappings     = Seq(DefaultMapping, p.liteDramMapping),
//    capabilities = Seq(cluster.io.dMem.p, cluster.io.dMem.p),
//    pendingMax = 31
//  )
  dBusDecoder.io.input << cluster.io.dMem.pipelined(cmdValid = true, cmdReady = true, rspValid = true)
  val dMemBridge = io.dMem.fromBmb(dBusDecoder.io.outputs(1), wdataFifoSize = 32, rdataFifoSize = 32)

  val iBusArbiterParameter = cluster.iBusParameter.copy(sourceWidth = log2Up(cpuCount))
  val iBusArbiter = BmbArbiter(
    p = iBusArbiterParameter,
    portCount = cpuCount,
    lowerFirstPriority = false
  )

  (iBusArbiter.io.inputs, cluster.io.iMems).zipped.foreach(_ << _.pipelined(cmdHalfRate = true, rspValid = true))

  val iBusDecoder = BmbDecoder(
    p            = iBusArbiter.io.output.p,
    mappings     = Seq(DefaultMapping, p.liteDramMapping),
    capabilities = Seq(iBusArbiterParameter, iBusArbiterParameter),
    pendingMax   = 15
  )
  iBusDecoder.io.input << iBusArbiter.io.output.pipelined(cmdValid = true)

  val iMem = LiteDramNative(p.liteDram)
  val iMemBridge = iMem.fromBmb(iBusDecoder.io.outputs(1), wdataFifoSize = 0, rdataFifoSize = 32)
  iMem.cmd   >-> io.iMem.cmd
  iMem.wdata >> io.iMem.wdata
  iMem.rdata << io.iMem.rdata


  val peripheralAccessLength = Math.max(iBusDecoder.io.outputs(0).p.lengthWidth, dBusDecoder.io.outputs(0).p.lengthWidth)
  val peripheralArbiter = BmbArbiter(
    p = dBusDecoder.io.outputs(0).p.copy(sourceWidth = dBusDecoder.io.outputs(0).p.sourceWidth + 1, lengthWidth = peripheralAccessLength),
    portCount = 2,
    lowerFirstPriority = true
  )
  peripheralArbiter.io.inputs(0) << iBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)
  peripheralArbiter.io.inputs(1) << dBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)

  val peripheralWishbone = peripheralArbiter.io.output.pipelined(cmdValid = true).toWishbone()
  io.peripheral << peripheralWishbone
}

object VexRiscvLitexSmpClusterGen extends App {
  val cpuCount = 4
  val withStall = false

  def parameter = VexRiscvLitexSmpClusterParameter(
    cluster = VexRiscvSmpClusterParameter(
      cpuConfigs = List.tabulate(cpuCount) { hartId =>
        vexRiscvConfig(
          hartId = hartId,
          ioRange =  address => address.msb,
          resetVector = 0
        )
      }
    ),
    liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
    liteDramMapping = SizeMapping(0x40000000l, 0x40000000l)
  )

  def dutGen = VexRiscvLitexSmpCluster(
    p = parameter,
    debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn"))
  )

//  SpinalVerilog(Bench.compressIo(dutGen))
  SpinalVerilog(dutGen)

}


object VexRiscvLitexSmpClusterOpenSbi extends App{
    import spinal.core.sim._

    val simConfig = SimConfig
    simConfig.withWave
    simConfig.allOptimisation

    val cpuCount = 4
    val withStall = false

    def parameter = VexRiscvLitexSmpClusterParameter(
      cluster = VexRiscvSmpClusterParameter(
        cpuConfigs = List.tabulate(cpuCount) { hartId =>
          vexRiscvConfig(
            hartId = hartId,
            ioRange =  address => address(31 downto 28) === 0xF,
            resetVector = 0x80000000l
          )
        }
      ),
      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
      liteDramMapping = SizeMapping(0x80000000l, 0x70000000l)
    )

    def dutGen = {
      val top = VexRiscvLitexSmpCluster(
        p = parameter,
        debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn"))
      )
      top.rework{
        top.io.clint.setAsDirectionLess.allowDirectionLessIo
        top.io.peripheral.setAsDirectionLess.allowDirectionLessIo.simPublic()

        val hit = (top.io.peripheral.ADR <<2 >= 0xF0010000l && top.io.peripheral.ADR<<2 < 0xF0020000l)
        top.io.clint.CYC := top.io.peripheral.CYC && hit
        top.io.clint.STB := top.io.peripheral.STB
        top.io.clint.WE := top.io.peripheral.WE
        top.io.clint.ADR := top.io.peripheral.ADR.resized
        top.io.clint.DAT_MOSI := top.io.peripheral.DAT_MOSI
        top.io.peripheral.DAT_MISO := top.io.clint.DAT_MISO
        top.io.peripheral.ACK := top.io.peripheral.CYC  && (!hit || top.io.clint.ACK)
        top.io.peripheral.ERR := False

        top.dMemBridge.unburstified.cmd.simPublic()
      }
      top
    }
    simConfig.compile(dutGen).doSimUntilVoid(seed = 42){dut =>
      dut.clockDomain.forkStimulus(10)
      fork {
        dut.debugClockDomain.resetSim #= false
        sleep (0)
        dut.debugClockDomain.resetSim #= true
        sleep (10)
        dut.debugClockDomain.resetSim #= false
      }


      val ram = SparseMemory()
      ram.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin")
      ram.loadBin(0xC0000000l, "../buildroot/output/images/Image")
      ram.loadBin(0xC1000000l, "../buildroot/output/images/dtb")
      ram.loadBin(0xC2000000l, "../buildroot/output/images/rootfs.cpio")


      dut.io.iMem.simSlave(ram, dut.clockDomain)
      dut.io.dMem.simSlave(ram, dut.clockDomain, dut.dMemBridge.unburstified)

      dut.io.externalInterrupts #= 0
      dut.io.externalSupervisorInterrupts  #= 0

      dut.clockDomain.onSamplings{
        if(dut.io.peripheral.CYC.toBoolean){
          (dut.io.peripheral.ADR.toLong << 2) match {
            case 0xF0000000l => print(dut.io.peripheral.DAT_MOSI.toLong.toChar)
            case 0xF0000004l => dut.io.peripheral.DAT_MISO #= (if(System.in.available() != 0) System.in.read() else 0xFFFFFFFFl)
            case _ =>
          }
//          println(f"${dut.io.peripheral.ADR.toLong}%x")
        }
      }

//      fork{
//        disableSimWave()
//        val atMs = 8
//        val durationMs = 3
//        sleep(atMs*1000000)
//        enableSimWave()
//        println("** enableSimWave **")
//        sleep(durationMs*1000000)
//        println("** disableSimWave **")
//        while(true) {
//          disableSimWave()
//          sleep(100000 * 10)
//          enableSimWave()
//          sleep(  100 * 10)
//        }
//  //      simSuccess()
//      }

      fork{
        while(true) {
          disableSimWave()
          sleep(100000 * 10)
          enableSimWave()
          sleep(  100 * 10)
        }
      }
    }
  }