package vexriscv.demo.smp

import spinal.core._
import spinal.lib.bus.bmb._
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig, WishboneSlaveFactory}
import spinal.lib.com.jtag.{Jtag, JtagTapInstructionCtrl}
import spinal.lib._
import spinal.lib.bus.bmb.sim.{BmbMemoryMultiPort, BmbMemoryTester}
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.eda.bench.Bench
import spinal.lib.misc.Clint
import spinal.lib.misc.plic.{PlicGatewayActiveHigh, PlicMapper, PlicMapping, PlicTarget}
import spinal.lib.sim.{SimData, SparseMemory, StreamDriver, StreamMonitor, StreamReadyRandomizer}
import spinal.lib.system.debugger.{JtagBridgeNoTap, SystemDebugger, SystemDebuggerConfig}
import vexriscv.demo.smp.VexRiscvLitexSmpClusterOpenSbi.{cpuCount, parameter}
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig
import vexriscv.{VexRiscv, VexRiscvConfig}
import vexriscv.plugin.{CsrPlugin, DBusCachedPlugin, DebugPlugin, IBusCachedPlugin}

import scala.collection.mutable
import scala.util.Random


case class VexRiscvLitexSmpClusterParameter( cluster : VexRiscvSmpClusterParameter,
                                             liteDram : LiteDramNativeParameter,
                                             liteDramMapping : AddressMapping)

//addAttribute("""mark_debug = "true"""")
case class VexRiscvLitexSmpCluster(p : VexRiscvLitexSmpClusterParameter,
                                   debugClockDomain : ClockDomain,
                                   jtagClockDomain : ClockDomain) extends Component{

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
    val plic  = slave(Wishbone(WishboneConfig(addressWidth = 20, dataWidth = 32)))
    val interrupts  = in Bits(32 bits)
    val jtagInstruction = slave(JtagTapInstructionCtrl())
    val debugReset = out Bool()
  }
  val cpuCount = p.cluster.cpuConfigs.size
  val clint = Clint(cpuCount)
  clint.driveFrom(WishboneSlaveFactory(io.clint))

  val cluster = VexRiscvSmpCluster(p.cluster, debugClockDomain)
  cluster.io.debugReset <> io.debugReset
  cluster.io.timerInterrupts <> B(clint.harts.map(_.timerInterrupt))
  cluster.io.softwareInterrupts <> B(clint.harts.map(_.softwareInterrupt))
  cluster.io.time := clint.time

  val debug = debugClockDomain on new Area{
    val jtagConfig = SystemDebuggerConfig()
    val jtagBridge = new JtagBridgeNoTap(
      c = jtagConfig,
      jtagClockDomain = jtagClockDomain
    )
    jtagBridge.io.ctrl << io.jtagInstruction

    val debugger = new SystemDebugger(jtagConfig)
    debugger.io.remote <> jtagBridge.io.remote

    cluster.io.debugBus << debugger.io.mem.toBmb()
  }

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
  io.iMem.fromBmb(iBusDecoder.io.outputs(1), wdataFifoSize = 0, rdataFifoSize = 32)


  val iBusDecoderToPeripheral = iBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)
  val dBusDecoderToPeripheral = dBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)

  val peripheralAccessLength = Math.max(iBusDecoder.io.outputs(0).p.lengthWidth, dBusDecoder.io.outputs(0).p.lengthWidth)
  val peripheralArbiter = BmbArbiter(
    p = dBusDecoder.io.outputs(0).p.copy(
      sourceWidth = List(iBusDecoderToPeripheral, dBusDecoderToPeripheral).map(_.p.sourceWidth).max + 1,
      contextWidth = List(iBusDecoderToPeripheral, dBusDecoderToPeripheral).map(_.p.contextWidth).max,
      lengthWidth = peripheralAccessLength,
      dataWidth = 32
    ),
    portCount = 2,
    lowerFirstPriority = true
  )
  peripheralArbiter.io.inputs(0) << iBusDecoderToPeripheral
  peripheralArbiter.io.inputs(1) << dBusDecoderToPeripheral

  val peripheralWishbone = peripheralArbiter.io.output.pipelined(cmdValid = true).toWishbone()
  io.peripheral << peripheralWishbone

  val plic = new Area{
    val priorityWidth = 2

    val gateways = for(i <- 1 until 32) yield PlicGatewayActiveHigh(
      source = io.interrupts(i),
      id = i,
      priorityWidth = priorityWidth
    )

    val bus = WishboneSlaveFactory(io.plic)

    val targets = for(i <- 0 until cpuCount) yield new Area{
      val machine = PlicTarget(
        gateways = gateways,
        priorityWidth = priorityWidth
      )
      val supervisor = PlicTarget(
        gateways = gateways,
        priorityWidth = priorityWidth
      )

      cluster.io.externalInterrupts(i) := machine.iep
      cluster.io.externalSupervisorInterrupts(i) := supervisor.iep
    }

    val bridge = PlicMapper(bus, PlicMapping.sifive)(
      gateways = gateways,
      targets = targets.flatMap(t => List(t.machine, t.supervisor))
    )
  }
}

object VexRiscvLitexSmpClusterGen extends App {
  for(cpuCount <- List(1,2,4,8)) {
    def parameter = VexRiscvLitexSmpClusterParameter(
      cluster = VexRiscvSmpClusterParameter(
        cpuConfigs = List.tabulate(cpuCount) { hartId =>
          vexRiscvConfig(
            hartId = hartId,
            ioRange = address => address.msb,
            resetVector = 0
          )
        }
      ),
      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
      liteDramMapping = SizeMapping(0x40000000l, 0x40000000l)
    )

    def dutGen = {
      val toplevel = VexRiscvLitexSmpCluster(
        p = parameter,
        debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn")),
        jtagClockDomain = ClockDomain.external("jtag", withReset = false)
      )
      toplevel
    }

    val genConfig = SpinalConfig().addStandardMemBlackboxing(blackboxByteEnables)
    //  genConfig.generateVerilog(Bench.compressIo(dutGen))
    genConfig.generateVerilog(dutGen.setDefinitionName(s"VexRiscvLitexSmpCluster_${cpuCount}c"))
  }

}


object VexRiscvLitexSmpClusterOpenSbi extends App{
    import spinal.core.sim._

    val simConfig = SimConfig
    simConfig.withWave
    simConfig.allOptimisation

    val cpuCount = 2

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
        debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn")),
        jtagClockDomain = ClockDomain.external("jtag", withReset = false)
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

      dut.io.interrupts #= 0

      dut.clockDomain.onFallingEdges{
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
//        val atMs = 3790
//        val durationMs = 5
//        sleep(atMs*1000000l)
//        enableSimWave()
//        println("** enableSimWave **")
//        sleep(durationMs*1000000l)
//        println("** disableSimWave **")
//        while(true) {
//          disableSimWave()
//          sleep(100000 * 10)
//          enableSimWave()
//          sleep(  100 * 10)
//        }
//        //      simSuccess()
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