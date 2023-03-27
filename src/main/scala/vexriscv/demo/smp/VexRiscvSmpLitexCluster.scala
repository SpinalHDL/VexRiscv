package vexriscv.demo.smp

import spinal.core._
import spinal.core.fiber._
import spinal.lib.bus.bmb._
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.bus.wishbone.{WishboneConfig, WishboneToBmbGenerator}
import spinal.lib.generator.GeneratorComponent
import spinal.lib.sim.SparseMemory
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig
import vexriscv.ip.fpu.{FpuCore, FpuParameter}
import vexriscv.plugin.{AesPlugin, DBusCachedPlugin, FpuPlugin}


case class VexRiscvLitexSmpClusterParameter( cluster : VexRiscvSmpClusterParameter,
                                             liteDram : LiteDramNativeParameter,
                                             liteDramMapping : AddressMapping,
                                             coherentDma : Boolean,
                                             wishboneMemory : Boolean,
                                             cpuPerFpu : Int)


class VexRiscvLitexSmpCluster(p : VexRiscvLitexSmpClusterParameter) extends VexRiscvSmpClusterWithPeripherals(p.cluster) {
  val iArbiter = BmbBridgeGenerator()
  val iBridge = !p.wishboneMemory generate BmbToLiteDramGenerator(p.liteDramMapping)
  val dBridge = !p.wishboneMemory generate BmbToLiteDramGenerator(p.liteDramMapping)

  for(core <- cores) interconnect.addConnection(core.cpu.iBus -> List(iArbiter.bmb))
  !p.wishboneMemory generate interconnect.addConnection(
    iArbiter.bmb        -> List(iBridge.bmb),
    dBusNonCoherent.bmb -> List(dBridge.bmb)
  )
  interconnect.addConnection(
    iArbiter.bmb        -> List(peripheralBridge.bmb),
    dBusNonCoherent.bmb -> List(peripheralBridge.bmb)
  )

  val fpuGroups = (cores.reverse.grouped(p.cpuPerFpu)).toList.reverse
  val fpu = p.cluster.fpu generate { for(group <- fpuGroups) yield new Area{
    val extraStage = group.size > 2

    val logic = Handle{
      new FpuCore(
        portCount = group.size,
        p =  FpuParameter(
          withDouble = true,
          asyncRegFile = false,
          schedulerM2sPipe = extraStage
        )
      )
    }

    val connect = Handle{
      for(i <- 0 until group.size;
          vex = group(i).cpu.logic.cpu;
          port = logic.io.port(i)) {
        val plugin = vex.service(classOf[FpuPlugin])
        plugin.port.cmd.pipelined(m2s = false, s2m = false) >> port.cmd
        plugin.port.commit.pipelined(m2s = extraStage, s2m = false) >> port.commit
        plugin.port.completion := port.completion.m2sPipe()
        plugin.port.rsp << port.rsp
      }
    }
  }}

  if(p.cluster.withExclusiveAndInvalidation) interconnect.masters(dBusNonCoherent.bmb).withOutOfOrderDecoder()

  if(!p.wishboneMemory) {
    dBridge.liteDramParameter.load(p.liteDram)
    iBridge.liteDramParameter.load(p.liteDram)
  }

  // Coherent DMA interface
  val dma = p.coherentDma generate new Area {
    val bridge = WishboneToBmbGenerator()
    val wishbone = Handle(bridge.logic.io.input.toIo)
    val dataWidth = p.cluster.cpuConfigs.head.find(classOf[DBusCachedPlugin]).get.config.memDataWidth
    bridge.config.load(WishboneConfig(
      addressWidth = 32 - log2Up(dataWidth / 8),
      dataWidth = dataWidth,
      useSTALL = true,
      selWidth = dataWidth/8
    ))
    interconnect.addConnection(bridge.bmb, dBusCoherent.bmb)
  }

  // Interconnect pipelining (FMax)
  for(core <- cores) {
    interconnect.setPipelining(core.cpu.dBus)(cmdValid = true, cmdReady = true, rspValid = true, invValid = true, ackValid = true, syncValid = true)
    interconnect.setPipelining(core.cpu.iBus)(cmdHalfRate = true, rspValid = true)
    interconnect.setPipelining(iArbiter.bmb)(cmdHalfRate = true, rspValid = true)
  }
  interconnect.setPipelining(dBusCoherent.bmb)(cmdValid = true, cmdReady = true)
  interconnect.setPipelining(dBusNonCoherent.bmb)(cmdValid = true, cmdReady = true, rspValid = true)
  interconnect.setPipelining(peripheralBridge.bmb)(cmdHalfRate = !p.wishboneMemory, cmdValid = p.wishboneMemory, cmdReady = p.wishboneMemory, rspValid = true)
  if(!p.wishboneMemory) {
    interconnect.setPipelining(iBridge.bmb)(cmdHalfRate = true)
    interconnect.setPipelining(dBridge.bmb)(cmdReady = true)
  }
}


object VexRiscvLitexSmpClusterCmdGen extends App {
  var cpuCount = 1
  var iBusWidth = 64
  var dBusWidth = 64
  var iCacheSize = 8192
  var dCacheSize = 8192
  var iCacheWays = 2
  var dCacheWays = 2
  var liteDramWidth = 128
  var coherentDma = false
  var wishboneMemory = false
  var outOfOrderDecoder = true
  var aesInstruction = false
  var fpu = false
  var cpuPerFpu = 4
  var rvc = false
  var netlistDirectory = "."
  var netlistName = "VexRiscvLitexSmpCluster"
  var iTlbSize = 4
  var dTlbSize = 4
  var wishboneForce32b = false
  assert(new scopt.OptionParser[Unit]("VexRiscvLitexSmpClusterCmdGen") {
    help("help").text("prints this usage text")
    opt[Unit]("coherent-dma") action { (v, c) => coherentDma = true }
    opt[String]("cpu-count") action { (v, c) => cpuCount = v.toInt }
    opt[String]("ibus-width") action { (v, c) => iBusWidth = v.toInt }
    opt[String]("dbus-width") action { (v, c) => dBusWidth = v.toInt }
    opt[String]("icache-size") action { (v, c) => iCacheSize = v.toInt }
    opt[String]("dcache-size") action { (v, c) => dCacheSize = v.toInt }
    opt[String]("icache-ways") action { (v, c) => iCacheWays = v.toInt }
    opt[String]("dcache-ways") action { (v, c) => dCacheWays = v.toInt }
    opt[String]("litedram-width") action { (v, c) => liteDramWidth = v.toInt }
    opt[String]("netlist-directory") action { (v, c) => netlistDirectory = v }
    opt[String]("netlist-name") action { (v, c) => netlistName = v }
    opt[String]("aes-instruction") action { (v, c) => aesInstruction = v.toBoolean }
    opt[String]("out-of-order-decoder") action { (v, c) => outOfOrderDecoder = v.toBoolean  }
    opt[String]("wishbone-memory" ) action { (v, c) => wishboneMemory = v.toBoolean  }
    opt[String]("wishbone-force-32b" ) action { (v, c) => wishboneForce32b = v.toBoolean  }
    opt[String]("fpu" ) action { (v, c) => fpu = v.toBoolean  }
    opt[String]("cpu-per-fpu") action { (v, c) => cpuPerFpu = v.toInt }
    opt[String]("rvc") action { (v, c) => rvc = v.toBoolean }
    opt[String]("itlb-size") action { (v, c) => iTlbSize = v.toInt }
    opt[String]("dtlb-size") action { (v, c) => dTlbSize = v.toInt }
  }.parse(args, Unit).nonEmpty)

  val coherency = coherentDma || cpuCount > 1
  def parameter = VexRiscvLitexSmpClusterParameter(
    cluster = VexRiscvSmpClusterParameter(
      cpuConfigs = List.tabulate(cpuCount) { hartId => {
        val c = vexRiscvConfig(
          hartId = hartId,
          ioRange = address => address.msb,
          resetVector = 0,
          iBusWidth = iBusWidth,
          dBusWidth = dBusWidth,
          iCacheSize = iCacheSize,
          dCacheSize = dCacheSize,
          iCacheWays = iCacheWays,
          dCacheWays = dCacheWays,
          coherency = coherency,
          iBusRelax = true,
          earlyBranch = true,
          withFloat = fpu,
          withDouble = fpu,
          externalFpu = fpu,
          loadStoreWidth = if(fpu) 64 else 32,
          rvc = rvc,
          injectorStage = rvc,
	  iTlbSize = iTlbSize,
	  dTlbSize = dTlbSize
        )
        if(aesInstruction) c.add(new AesPlugin)
        c
      }},
      withExclusiveAndInvalidation = coherency,
      forcePeripheralWidth = !wishboneMemory || wishboneForce32b,
      outOfOrderDecoder = outOfOrderDecoder,
      fpu = fpu,
      jtagHeaderIgnoreWidth = 0
    ),
    liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = liteDramWidth),
    liteDramMapping = SizeMapping(0x40000000l, 0x40000000l),
    coherentDma = coherentDma,
    wishboneMemory = wishboneMemory,
    cpuPerFpu = cpuPerFpu
  )

  def dutGen = {
    val toplevel = new Component {
      val body = new VexRiscvLitexSmpCluster(
        p = parameter
      )
      body.setName("")
    }
    toplevel
  }

  val genConfig = SpinalConfig(targetDirectory = netlistDirectory, inlineRom = true).addStandardMemBlackboxing(blackboxByteEnables)
  genConfig.generateVerilog(dutGen.setDefinitionName(netlistName))

}


//object VexRiscvLitexSmpClusterGen extends App {
//  for(cpuCount <- List(1,2,4,8)) {
//    def parameter = VexRiscvLitexSmpClusterParameter(
//      cluster = VexRiscvSmpClusterParameter(
//        cpuConfigs = List.tabulate(cpuCount) { hartId =>
//          vexRiscvConfig(
//            hartId = hartId,
//            ioRange = address => address.msb,
//            resetVector = 0
//          )
//        },
//        withExclusiveAndInvalidation = true
//      ),
//      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
//      liteDramMapping = SizeMapping(0x40000000l, 0x40000000l),
//      coherentDma = false
//    )
//
//    def dutGen = {
//      val toplevel = new VexRiscvLitexSmpCluster(
//        p = parameter
//      ).toComponent()
//      toplevel
//    }
//
//    val genConfig = SpinalConfig().addStandardMemBlackboxing(blackboxByteEnables)
//    //  genConfig.generateVerilog(Bench.compressIo(dutGen))
//    genConfig.generateVerilog(dutGen.setDefinitionName(s"VexRiscvLitexSmpCluster_${cpuCount}c"))
//  }
//}

////addAttribute("""mark_debug = "true"""")
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
      },
      withExclusiveAndInvalidation = true,
      jtagHeaderIgnoreWidth = 0
    ),
    liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
    liteDramMapping = SizeMapping(0x80000000l, 0x70000000l),
    coherentDma = false,
    wishboneMemory = false,
    cpuPerFpu = 4
  )

  def dutGen = {
    import GeneratorComponent.toGenerator
    val top = new Component {
      val body = new VexRiscvLitexSmpCluster(
        p = parameter
      )
    }
    top.rework{
      top.body.clintWishbone.setAsDirectionLess.allowDirectionLessIo
      top.body.peripheral.setAsDirectionLess.allowDirectionLessIo.simPublic()

      val hit = (top.body.peripheral.ADR <<2 >= 0xF0010000l && top.body.peripheral.ADR<<2 < 0xF0020000l)
      top.body.clintWishbone.CYC := top.body.peripheral.CYC && hit
      top.body.clintWishbone.STB := top.body.peripheral.STB
      top.body.clintWishbone.WE := top.body.peripheral.WE
      top.body.clintWishbone.ADR := top.body.peripheral.ADR.resized
      top.body.clintWishbone.DAT_MOSI := top.body.peripheral.DAT_MOSI
      top.body.peripheral.DAT_MISO := top.body.clintWishbone.DAT_MISO
      top.body.peripheral.ACK := top.body.peripheral.CYC  && (!hit || top.body.clintWishbone.ACK)
      top.body.peripheral.ERR := False
    }
    top
  }
  
  simConfig.compile(dutGen).doSimUntilVoid(seed = 42){dut =>
    dut.body.debugCd.inputClockDomain.get.forkStimulus(10)

    val ram = SparseMemory()
    ram.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin")
    ram.loadBin(0xC0000000l, "../buildroot/output/images/Image")
    ram.loadBin(0xC1000000l, "../buildroot/output/images/dtb")
    ram.loadBin(0xC2000000l, "../buildroot/output/images/rootfs.cpio")


    dut.body.iBridge.dram.simSlave(ram, dut.body.debugCd.inputClockDomain)
    dut.body.dBridge.dram.simSlave(ram, dut.body.debugCd.inputClockDomain/*, dut.body.dMemBridge.unburstified*/)

    dut.body.interrupts #= 0

    dut.body.debugCd.inputClockDomain.get.onFallingEdges{
      if(dut.body.peripheral.CYC.toBoolean){
        (dut.body.peripheral.ADR.toLong << 2) match {
          case 0xF0000000l => print(dut.body.peripheral.DAT_MOSI.toLong.toChar)
          case 0xF0000004l => dut.body.peripheral.DAT_MISO #= (if(System.in.available() != 0) System.in.read() else 0xFFFFFFFFl)
          case _ =>
        }
      }
    }

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