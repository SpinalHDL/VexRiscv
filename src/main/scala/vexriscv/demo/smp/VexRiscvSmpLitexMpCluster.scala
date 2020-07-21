package vexriscv.demo.smp

import spinal.core._
import spinal.lib.bus.bmb._
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.bus.wishbone.{WishboneConfig, WishboneToBmbGenerator}
import spinal.lib.sim.SparseMemory
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig

//case class VexRiscvLitexSmpMpClusterParameter( cluster : VexRiscvSmpClusterParameter,
//                                             liteDram : LiteDramNativeParameter,
//                                             liteDramMapping : AddressMapping)
//
//class VexRiscvLitexSmpMpCluster(p : VexRiscvLitexSmpMpClusterParameter) extends VexRiscvSmpClusterWithPeripherals(p.cluster) {
//  val iArbiter = BmbBridgeGenerator()
//  val iBridge = BmbToLiteDramGenerator(p.liteDramMapping)
//  val dBridge = BmbToLiteDramGenerator(p.liteDramMapping)
//
//  for(core <- cores) interconnect.addConnection(core.cpu.iBus -> List(iArbiter.bmb))
//  interconnect.addConnection(
//    iArbiter.bmb               -> List(iBridge.bmb, peripheralBridge.bmb),
//    invalidationMonitor.output -> List(dBridge.bmb, peripheralBridge.bmb)
//  )
//  interconnect.masters(invalidationMonitor.output).withOutOfOrderDecoder()
//
//  dBridge.liteDramParameter.load(p.liteDram)
//  iBridge.liteDramParameter.load(p.liteDram)
//
//  // Interconnect pipelining (FMax)
//  for(core <- cores) {
//    interconnect.setPipelining(core.cpu.dBus)(cmdValid = true, cmdReady = true, rspValid = true)
//    interconnect.setPipelining(core.cpu.iBus)(cmdHalfRate = true, rspValid = true)
//    interconnect.setPipelining(iArbiter.bmb)(cmdHalfRate = true, rspValid = true)
//  }
//  interconnect.setPipelining(invalidationMonitor.output)(cmdValid = true, cmdReady = true, rspValid = true)
//  interconnect.setPipelining(peripheralBridge.bmb)(cmdHalfRate = true, rspValid = true)
//}
//
//
//object VexRiscvLitexSmpMpClusterGen extends App {
//  for(cpuCount <- List(1,2,4,8)) {
//    def parameter = VexRiscvLitexSmpMpClusterParameter(
//      cluster = VexRiscvSmpClusterParameter(
//        cpuConfigs = List.tabulate(cpuCount) { hartId =>
//          vexRiscvConfig(
//            hartId = hartId,
//            ioRange = address => address.msb,
//            resetVector = 0
//          )
//        }
//      ),
//      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
//      liteDramMapping = SizeMapping(0x40000000l, 0x40000000l)
//    )
//
//    def dutGen = {
//      val toplevel = new VexRiscvLitexSmpMpCluster(
//        p = parameter
//      ).toComponent()
//      toplevel
//    }
//
//    val genConfig = SpinalConfig().addStandardMemBlackboxing(blackboxByteEnables)
//    //  genConfig.generateVerilog(Bench.compressIo(dutGen))
//    genConfig.generateVerilog(dutGen.setDefinitionName(s"VexRiscvLitexSmpMpCluster_${cpuCount}c"))
//  }
//}



//
////addAttribute("""mark_debug = "true"""")
//class VexRiscvLitexSmpMpCluster(val p : VexRiscvLitexSmpMpClusterParameter,
//                                val debugClockDomain : ClockDomain,
//                                val jtagClockDomain : ClockDomain) extends Component{
//
//  val peripheralWishboneConfig = WishboneConfig(
//    addressWidth = 30,
//    dataWidth = 32,
//    selWidth = 4,
//    useERR = true,
//    useBTE = true,
//    useCTI = true
//  )
//
//  val cpuCount = p.cluster.cpuConfigs.size
//
//  val io = new Bundle {
//    val dMem = Vec(master(LiteDramNative(p.liteDram)), cpuCount)
//    val iMem =  Vec(master(LiteDramNative(p.liteDram)), cpuCount)
//    val peripheral = master(Wishbone(peripheralWishboneConfig))
//    val clint = slave(Wishbone(Clint.getWisboneConfig()))
//    val plic  = slave(Wishbone(WishboneConfig(addressWidth = 20, dataWidth = 32)))
//    val interrupts = in Bits(32 bits)
//    val jtagInstruction = slave(JtagTapInstructionCtrl())
//    val debugReset = out Bool()
//  }
//  val clint = Clint(cpuCount)
//  clint.driveFrom(WishboneSlaveFactory(io.clint))
//
//  val cluster = VexRiscvSmpCluster(p.cluster, debugClockDomain)
//  cluster.io.debugReset <> io.debugReset
//  cluster.io.timerInterrupts <> B(clint.harts.map(_.timerInterrupt))
//  cluster.io.softwareInterrupts <> B(clint.harts.map(_.softwareInterrupt))
//  cluster.io.time := clint.time
//
//  val debug = debugClockDomain on new Area{
//    val jtagConfig = SystemDebuggerConfig()
//
//    val jtagBridge = new JtagBridgeNoTap(jtagConfig, jtagClockDomain)
//    jtagBridge.io.ctrl << io.jtagInstruction
//
//    val debugger = new SystemDebugger(jtagConfig)
//    debugger.io.remote <> jtagBridge.io.remote
//
//    cluster.io.debugBus << debugger.io.mem.toBmb()
//
////    io.jtagInstruction.allowDirectionLessIo.setAsDirectionLess
////    val bridge = Bscane2BmbMaster(1)
////    cluster.io.debugBus << bridge.io.bmb
//
//
////    val bscane2 = BSCANE2(usedId)
////    val jtagClockDomain = ClockDomain(bscane2.TCK)
////
////    val jtagBridge = new JtagBridgeNoTap(jtagConfig, jtagClockDomain)
////    jtagBridge.io.ctrl << bscane2.toJtagTapInstructionCtrl()
////
////    val debugger = new SystemDebugger(jtagConfig)
////    debugger.io.remote <> jtagBridge.io.remote
////
////    io.bmb << debugger.io.mem.toBmb()
//  }
//
//  val dBusDecoder = BmbDecoderOutOfOrder(
//    p            = cluster.io.dMem.p,
//    mappings     = Seq(DefaultMapping, p.liteDramMapping),
//    capabilities = Seq(cluster.io.dMem.p, cluster.io.dMem.p),
//    pendingRspTransactionMax = 32
//  )
////  val dBusDecoder = BmbDecoderOut(
////    p            = cluster.io.dMem.p,
////    mappings     = Seq(DefaultMapping, p.liteDramMapping),
////    capabilities = Seq(cluster.io.dMem.p, cluster.io.dMem.p),
////    pendingMax = 31
////  )
//  dBusDecoder.io.input << cluster.io.dMem.pipelined(cmdValid = true, cmdReady = true, rspValid = true)
//
//
//  val perIBus = for(id <- 0 until cpuCount) yield new Area{
//    val decoder = BmbDecoder(
//      p            = cluster.io.iMems(id).p,
//      mappings     = Seq(DefaultMapping, p.liteDramMapping),
//      capabilities = Seq(cluster.io.iMems(id).p,cluster.io.iMems(id).p),
//      pendingMax   = 15
//    )
//
//    decoder.io.input << cluster.io.iMems(id)
//    io.iMem(id).fromBmb(decoder.io.outputs(1).pipelined(cmdHalfRate = true), wdataFifoSize = 0, rdataFifoSize = 32)
//    val toPeripheral = decoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)
//  }
//
//  val dBusDecoderToPeripheral = dBusDecoder.io.outputs(0).resize(dataWidth = 32).pipelined(cmdHalfRate = true, rspValid = true)
//
//  val peripheralAccessLength = Math.max(perIBus(0).toPeripheral.p.lengthWidth, dBusDecoder.io.outputs(0).p.lengthWidth)
//  val peripheralArbiter = BmbArbiter(
//    p = dBusDecoder.io.outputs(0).p.copy(
//      sourceWidth = List(perIBus(0).toPeripheral, dBusDecoderToPeripheral).map(_.p.sourceWidth).max + log2Up(cpuCount + 1),
//      contextWidth = List(perIBus(0).toPeripheral, dBusDecoderToPeripheral).map(_.p.contextWidth).max,
//      lengthWidth = peripheralAccessLength,
//      dataWidth = 32
//    ),
//    portCount = cpuCount+1,
//    lowerFirstPriority = true
//  )
//
//  for(id <- 0 until cpuCount){
//    peripheralArbiter.io.inputs(id) << perIBus(id).toPeripheral
//  }
//  peripheralArbiter.io.inputs(cpuCount) << dBusDecoderToPeripheral
//
//  val peripheralWishbone = peripheralArbiter.io.output.pipelined(cmdValid = true).toWishbone()
//  io.peripheral << peripheralWishbone
//
//
//  val dBusDemux = BmbSourceDecoder(dBusDecoder.io.outputs(1).p)
//  dBusDemux.io.input << dBusDecoder.io.outputs(1).pipelined(cmdValid = true, cmdReady = true,rspValid = true)
//  val dMemBridge = for(id <- 0 until cpuCount)  yield {
//    io.dMem(id).fromBmb(dBusDemux.io.outputs(id), wdataFifoSize = 32, rdataFifoSize = 32)
//  }
//
//
//  val plic = new Area{
//    val priorityWidth = 2
//
//    val gateways = for(i <- 1 until 32) yield PlicGatewayActiveHigh(
//      source = io.interrupts(i),
//      id = i,
//      priorityWidth = priorityWidth
//    )
//
//    val bus = WishboneSlaveFactory(io.plic)
//
//    val targets = for(i <- 0 until cpuCount) yield new Area{
//      val machine = PlicTarget(
//        gateways = gateways,
//        priorityWidth = priorityWidth
//      )
//      val supervisor = PlicTarget(
//        gateways = gateways,
//        priorityWidth = priorityWidth
//      )
//
//      cluster.io.externalInterrupts(i) := machine.iep
//      cluster.io.externalSupervisorInterrupts(i) := supervisor.iep
//    }
//
//    val bridge = PlicMapper(bus, PlicMapping.sifive)(
//      gateways = gateways,
//      targets = targets.flatMap(t => List(t.machine, t.supervisor))
//    )
//  }
////
////  io.dMem.foreach(_.cmd.valid.addAttribute("""mark_debug = "true""""))
////  io.dMem.foreach(_.cmd.ready.addAttribute("""mark_debug = "true""""))
////  io.iMem.foreach(_.cmd.valid.addAttribute("""mark_debug = "true""""))
////  io.iMem.foreach(_.cmd.ready.addAttribute("""mark_debug = "true""""))
////
////  cluster.io.dMem.cmd.valid.addAttribute("""mark_debug = "true"""")
////  cluster.io.dMem.cmd.ready.addAttribute("""mark_debug = "true"""")
////  cluster.io.dMem.rsp.valid.addAttribute("""mark_debug = "true"""")
////  cluster.io.dMem.rsp.ready.addAttribute("""mark_debug = "true"""")
//}
//
//object VexRiscvLitexSmpMpClusterGen extends App {
//  for(cpuCount <- List(1,2,4,8)) {
//    def parameter = VexRiscvLitexSmpMpClusterParameter(
//      cluster = VexRiscvSmpClusterParameter(
//        cpuConfigs = List.tabulate(cpuCount) { hartId =>
//          vexRiscvConfig(
//            hartId = hartId,
//            ioRange = address => address.msb,
//            resetVector = 0
//          )
//        }
//      ),
//      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
//      liteDramMapping = SizeMapping(0x40000000l, 0x40000000l)
//    )
//
//    def dutGen = {
//      val toplevel = new VexRiscvLitexSmpMpCluster(
//        p = parameter,
//        debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn")),
//        jtagClockDomain = ClockDomain.external("jtag", withReset = false)
//      )
//      toplevel
//    }
//
//    val genConfig = SpinalConfig().addStandardMemBlackboxing(blackboxByteEnables)
//    //  genConfig.generateVerilog(Bench.compressIo(dutGen))
//    genConfig.generateVerilog(dutGen.setDefinitionName(s"VexRiscvLitexSmpMpCluster_${cpuCount}c"))
//  }
//
//}
//
//
//object VexRiscvLitexSmpMpClusterOpenSbi extends App{
//  import spinal.core.sim._
//
//  val simConfig = SimConfig
//  simConfig.withWave
//  simConfig.withFstWave
//  simConfig.allOptimisation
//
//  val cpuCount = 2
//
//  def parameter = VexRiscvLitexSmpMpClusterParameter(
//    cluster = VexRiscvSmpClusterParameter(
//      cpuConfigs = List.tabulate(cpuCount) { hartId =>
//        vexRiscvConfig(
//          hartId = hartId,
//          ioRange =  address => address(31 downto 28) === 0xF,
//          resetVector = 0x80000000l
//        )
//      }
//    ),
//    liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
//    liteDramMapping = SizeMapping(0x80000000l, 0x70000000l)
//  )
//
//  def dutGen = {
//    val top = new VexRiscvLitexSmpMpCluster(
//      p = parameter,
//      debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn")),
//      jtagClockDomain = ClockDomain.external("jtag", withReset = false)
//    ){
//      io.jtagInstruction.allowDirectionLessIo.setAsDirectionLess
//      val jtag = slave(Jtag())
//      jtagClockDomain.readClockWire.setAsDirectionLess() := jtag.tck
//      val jtagLogic = jtagClockDomain on new Area{
//        val tap = new JtagTap(jtag, 4)
//        val idcodeArea = tap.idcode(B"x10001FFF")(1)
//        val wrapper = tap.map(io.jtagInstruction, instructionId = 2)
//      }
//    }
//    top.rework{
//      top.io.clint.setAsDirectionLess.allowDirectionLessIo
//      top.io.peripheral.setAsDirectionLess.allowDirectionLessIo.simPublic()
//
//      val hit = (top.io.peripheral.ADR <<2 >= 0xF0010000l && top.io.peripheral.ADR<<2 < 0xF0020000l)
//      top.io.clint.CYC := top.io.peripheral.CYC && hit
//      top.io.clint.STB := top.io.peripheral.STB
//      top.io.clint.WE := top.io.peripheral.WE
//      top.io.clint.ADR := top.io.peripheral.ADR.resized
//      top.io.clint.DAT_MOSI := top.io.peripheral.DAT_MOSI
//      top.io.peripheral.DAT_MISO := top.io.clint.DAT_MISO
//      top.io.peripheral.ACK := top.io.peripheral.CYC  && (!hit || top.io.clint.ACK)
//      top.io.peripheral.ERR := False
//
////        top.dMemBridge.unburstified.cmd.simPublic()
//    }
//    top
//  }
//  simConfig.compile(dutGen).doSimUntilVoid(seed = 42){dut =>
//    dut.clockDomain.forkStimulus(10)
//    fork {
//      dut.debugClockDomain.resetSim #= false
//      sleep (0)
//      dut.debugClockDomain.resetSim #= true
//      sleep (10)
//      dut.debugClockDomain.resetSim #= false
//    }
//
//    JtagTcp(dut.jtag, 10*20)
//
//    val ram = SparseMemory()
//    ram.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin")
//    ram.loadBin(0xC0000000l, "../buildroot/output/images/Image")
//    ram.loadBin(0xC1000000l, "../buildroot/output/images/dtb")
//    ram.loadBin(0xC2000000l, "../buildroot/output/images/rootfs.cpio")
//
//    for(id <- 0 until cpuCount) {
//      dut.io.iMem(id).simSlave(ram, dut.clockDomain)
//      dut.io.dMem(id).simSlave(ram, dut.clockDomain)
//    }
//
//    dut.io.interrupts #= 0
//
//
////      val stdin = mutable.Queue[Byte]()
////      def stdInPush(str : String) = stdin ++= str.toCharArray.map(_.toByte)
////      fork{
////        sleep(4000*1000000l)
////        stdInPush("root\n")
////        sleep(1000*1000000l)
////        stdInPush("ping localhost -i 0.01 > /dev/null &\n")
////        stdInPush("ping localhost -i 0.01 > /dev/null &\n")
////        stdInPush("ping localhost -i 0.01 > /dev/null &\n")
////        stdInPush("ping localhost -i 0.01 > /dev/null &\n")
////        sleep(500*1000000l)
////        while(true){
////          sleep(500*1000000l)
////          stdInPush("uptime\n")
////          printf("\n** uptime **")
////        }
////      }
//    dut.clockDomain.onFallingEdges {
//      if (dut.io.peripheral.CYC.toBoolean) {
//        (dut.io.peripheral.ADR.toLong << 2) match {
//          case 0xF0000000l => print(dut.io.peripheral.DAT_MOSI.toLong.toChar)
//          case 0xF0000004l => dut.io.peripheral.DAT_MISO #= (if (System.in.available() != 0) System.in.read() else 0xFFFFFFFFl)
//          case _ =>
//          //            case 0xF0000004l => {
//          //              val c = if(stdin.nonEmpty) {
//          //                stdin.dequeue().toInt & 0xFF
//          //              } else {
//          //                0xFFFFFFFFl
//          //              }
//          //              dut.io.peripheral.DAT_MISO #= c
//          //            }
//          //            case _ =>
//          //          }
//          //          println(f"${dut.io.peripheral.ADR.toLong}%x")
//        }
//      }
//    }
//
//    fork{
//      val at = 0
//      val duration = 1000
//      while(simTime() < at*1000000l) {
//        disableSimWave()
//        sleep(100000 * 10)
//        enableSimWave()
//        sleep(  200 * 10)
//      }
//      println("\n\n********************")
//      sleep(duration*1000000l)
//      println("********************\n\n")
//      while(true) {
//        disableSimWave()
//        sleep(100000 * 10)
//        enableSimWave()
//        sleep(  400 * 10)
//      }
//    }
//  }
//}