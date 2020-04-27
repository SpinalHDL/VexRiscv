package vexriscv.demo.smp

import spinal.core._
import spinal.lib.bus.bmb._
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig, WishboneSlaveFactory}
import spinal.lib.com.jtag.Jtag
import spinal.lib._
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.misc.Clint
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig
import vexriscv.{VexRiscv, VexRiscvConfig}
import vexriscv.plugin.{CsrPlugin, DBusCachedPlugin, DebugPlugin, IBusCachedPlugin}

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

  def fromBmb(bmb : Bmb): Unit = new Area{
    val resized = bmb.resize(p.dataWidth)
    val unburstified = resized.unburstify()
    case class Context() extends Bundle {
      val context = Bits(unburstified.p.contextWidth bits)
      val source  = UInt(unburstified.p.sourceWidth bits)
      val isWrite = Bool()
    }
    val (queueFork, cmdFork, dataFork) = StreamFork3(unburstified.cmd)
    cmd.arbitrationFrom(cmdFork)
    cmd.addr := (cmdFork.address >> log2Up(bmb.p.byteCount)).resized
    cmd.we := cmdFork.isWrite

    if(bmb.p.canWrite) {
      wdata.arbitrationFrom(dataFork.throwWhen(dataFork.isRead))
      wdata.data := cmdFork.data
      wdata.we := cmdFork.mask
    } else {
      dataFork.ready := True
      wdata.valid := False
      wdata.data.assignDontCare()
      wdata.we.assignDontCare()
    }

    val cmdContext = Stream(Context())
    cmdContext.arbitrationFrom(queueFork)
    cmdContext.context := unburstified.cmd.context
    cmdContext.source  := unburstified.cmd.source
    cmdContext.isWrite := unburstified.cmd.isWrite

    val rspContext = cmdContext.queue(64)

    rdata.ready := unburstified.rsp.fire && !rspContext.isWrite
    rspContext.ready := unburstified.rsp.fire
    unburstified.rsp.valid := rspContext.valid && (rspContext.isWrite || rdata.valid)
    unburstified.rsp.setSuccess()
    unburstified.rsp.last := True
    unburstified.rsp.source := rspContext.source
    unburstified.rsp.context := rspContext.context
    unburstified.rsp.data := rdata.data
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
  dBusDecoder.io.input << cluster.io.dMem.pipelined(cmdValid = true, cmdReady = true, rspValid = true)
  io.dMem.fromBmb(dBusDecoder.io.outputs(1))

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
  iBusDecoder.io.input << iBusArbiter.io.output
  io.iMem.fromBmb(iBusDecoder.io.outputs(1))

  val peripheralArbiter = BmbArbiter(
    p = dBusDecoder.io.outputs(0).p.copy(sourceWidth = dBusDecoder.io.outputs(0).p.sourceWidth + 1),
    portCount = 2,
    lowerFirstPriority = true
  )
  peripheralArbiter.io.inputs(0) << iBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)
  peripheralArbiter.io.inputs(1) << dBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)

  val peripheralWishbone = peripheralArbiter.io.output.toWishbone()
  io.peripheral << peripheralWishbone
}


object VexRiscvLitexSmpClusterOpenSbi extends App{
    import spinal.core.sim._

    val simConfig = SimConfig
    simConfig.withWave
    simConfig.allOptimisation
    simConfig.addSimulatorFlag("--threads 1")

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
      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 32),
      liteDramMapping = SizeMapping(0x40000000l, 0x40000000l)
    )

    def dutGen = VexRiscvLitexSmpCluster(
      p = parameter,
      debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn"))
    )
    simConfig.compile(dutGen).doSimUntilVoid(seed = 42){dut =>
      //    dut.clockDomain.forkSimSpeedPrinter(1.0)
//      VexRiscvSmpClusterTestInfrastructure.init(dut)
//      val ram = VexRiscvSmpClusterTestInfrastructure.ram(dut, withStall)
      //    ram.memory.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_payload.bin")
//      ram.memory.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin")
//      ram.memory.loadBin(0xC0000000l, "../buildroot/output/images/Image")
//      ram.memory.loadBin(0xC1000000l, "../buildroot/output/images/dtb")
//      ram.memory.loadBin(0xC2000000l, "../buildroot/output/images/rootfs.cpio")

      //    fork{
      //      disableSimWave()
      //      val atMs = 130
      //      val durationMs = 15
      //      sleep(atMs*1000000)
      //      enableSimWave()
      //      println("** enableSimWave **")
      //      sleep(durationMs*1000000)
      //      println("** disableSimWave **")
      //      while(true) {
      //        disableSimWave()
      //        sleep(100000 * 10)
      //        enableSimWave()
      //        sleep(  100 * 10)
      //      }
      ////      simSuccess()
      //    }

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