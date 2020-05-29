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
import vexriscv.demo.smp.VexRiscvLitexSmpDevClusterOpenSbi.{cpuCount, parameter}
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig
import vexriscv.{VexRiscv, VexRiscvConfig}
import vexriscv.plugin.{CsrPlugin, DBusCachedPlugin, DebugPlugin, IBusCachedPlugin}

import scala.collection.mutable
import scala.util.Random


case class VexRiscvLitexSmpDevClusterParameter( cluster : VexRiscvSmpClusterParameter,
                                             liteDram : LiteDramNativeParameter,
                                             liteDramMapping : AddressMapping)

//addAttribute("""mark_debug = "true"""")
case class VexRiscvLitexSmpDevCluster(p : VexRiscvLitexSmpDevClusterParameter,
                                   debugClockDomain : ClockDomain) extends Component{

  val peripheralWishboneConfig = WishboneConfig(
    addressWidth = 30,
    dataWidth = 32,
    selWidth = 4,
    useERR = true,
    useBTE = true,
    useCTI = true
  )

  val cpuCount = p.cluster.cpuConfigs.size

  val io = new Bundle {
    val dMem = Vec(master(LiteDramNative(p.liteDram)), cpuCount)
    val iMem =  Vec(master(LiteDramNative(p.liteDram)), cpuCount)
    val peripheral = master(Wishbone(peripheralWishboneConfig))
    val clint = slave(Wishbone(Clint.getWisboneConfig()))
    val externalInterrupts = in Bits(p.cluster.cpuConfigs.size bits)
    val externalSupervisorInterrupts  = in Bits(p.cluster.cpuConfigs.size bits)
    val jtag = slave(Jtag())
    val debugReset = out Bool()
  }
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


  val perIBus = for(id <- 0 until cpuCount) yield new Area{
    val decoder = BmbDecoder(
      p            = cluster.io.iMems(id).p,
      mappings     = Seq(DefaultMapping, p.liteDramMapping),
      capabilities = Seq(cluster.io.iMems(id).p,cluster.io.iMems(id).p),
      pendingMax   = 15
    )

    decoder.io.input << cluster.io.iMems(id)
    io.iMem(id).fromBmb(decoder.io.outputs(1), wdataFifoSize = 0, rdataFifoSize = 32)
    val toPeripheral = decoder.io.outputs(0).resize(dataWidth = 32)
  }

  val dBusDecoderToPeripheral = dBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)

  val peripheralAccessLength = Math.max(perIBus(0).toPeripheral.p.lengthWidth, dBusDecoder.io.outputs(0).p.lengthWidth)
  val peripheralArbiter = BmbArbiter(
    p = dBusDecoder.io.outputs(0).p.copy(
      sourceWidth = List(perIBus(0).toPeripheral, dBusDecoderToPeripheral).map(_.p.sourceWidth).max + log2Up(cpuCount + 1),
      contextWidth = List(perIBus(0).toPeripheral, dBusDecoderToPeripheral).map(_.p.contextWidth).max,
      lengthWidth = peripheralAccessLength,
      dataWidth = 32
    ),
    portCount = cpuCount+1,
    lowerFirstPriority = true
  )

  for(id <- 0 until cpuCount){
    peripheralArbiter.io.inputs(id) << perIBus(id).toPeripheral
  }
  peripheralArbiter.io.inputs(cpuCount) << dBusDecoderToPeripheral

  val peripheralWishbone = peripheralArbiter.io.output.pipelined(cmdValid = true).toWishbone()
  io.peripheral << peripheralWishbone


  val dBusDemux = BmbSourceDecoder(dBusDecoder.io.outputs(1).p)
  dBusDemux.io.input << dBusDecoder.io.outputs(1)
  val dMemBridge = for(id <- 0 until cpuCount)  yield {
    io.dMem(id).fromBmb(dBusDemux.io.outputs(id), wdataFifoSize = 32, rdataFifoSize = 32)
  }

}

object VexRiscvLitexSmpDevClusterGen extends App {
  for(cpuCount <- List(1,2,4,8)) {
    def parameter = VexRiscvLitexSmpDevClusterParameter(
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
      val toplevel = VexRiscvLitexSmpDevCluster(
        p = parameter,
        debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn"))
      )
      toplevel
    }

    val genConfig = SpinalConfig().addStandardMemBlackboxing(blackboxByteEnables)
    //  genConfig.generateVerilog(Bench.compressIo(dutGen))
    genConfig.generateVerilog(dutGen.setDefinitionName(s"VexRiscvLitexSmpDevCluster_${cpuCount}c"))
  }

}


object VexRiscvLitexSmpDevClusterOpenSbi extends App{
    import spinal.core.sim._

    val simConfig = SimConfig
    simConfig.withWave
    simConfig.allOptimisation

    val cpuCount = 4

    def parameter = VexRiscvLitexSmpDevClusterParameter(
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
      val top = VexRiscvLitexSmpDevCluster(
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

//        top.dMemBridge.unburstified.cmd.simPublic()
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

      for(id <- 0 until cpuCount) {
        dut.io.iMem(id).simSlave(ram, dut.clockDomain)
        dut.io.dMem(id).simSlave(ram, dut.clockDomain)
      }

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