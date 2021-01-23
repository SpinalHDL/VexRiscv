package vexriscv.demo.smp

import spinal.core
import spinal.core._
import spinal.core.sim.{onSimEnd, simSuccess}
import spinal.lib._
import spinal.lib.bus.bmb.sim.BmbMemoryAgent
import spinal.lib.bus.bmb._
import spinal.lib.bus.misc.{DefaultMapping, SizeMapping}
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig, WishboneToBmb, WishboneToBmbGenerator}
import spinal.lib.com.jtag.{Jtag, JtagInstructionDebuggerGenerator, JtagTapInstructionCtrl}
import spinal.lib.com.jtag.sim.JtagTcp
import spinal.lib.com.jtag.xilinx.Bscane2BmbMasterGenerator
import spinal.lib.generator.Handle
import spinal.lib.misc.plic.PlicMapping
import spinal.lib.system.debugger.SystemDebuggerConfig
import vexriscv.ip.{DataCacheAck, DataCacheConfig, DataCacheMemBus, InstructionCache, InstructionCacheConfig}
import vexriscv.plugin.{BranchPlugin, CsrAccess, CsrPlugin, CsrPluginConfig, DBusCachedPlugin, DBusSimplePlugin, DYNAMIC_TARGET, DebugPlugin, DecoderSimplePlugin, FullBarrelShifterPlugin, HazardSimplePlugin, IBusCachedPlugin, IBusSimplePlugin, IntAluPlugin, MmuPlugin, MmuPortConfig, MulDivIterativePlugin, MulPlugin, RegFilePlugin, STATIC, SrcPlugin, StaticMemoryTranslatorPlugin, YamlPlugin}
import vexriscv.{Riscv, VexRiscv, VexRiscvBmbGenerator, VexRiscvConfig, plugin}

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import spinal.lib.generator._

case class VexRiscvSmpClusterParameter(cpuConfigs : Seq[VexRiscvConfig], withExclusiveAndInvalidation : Boolean, forcePeripheralWidth : Boolean = true, outOfOrderDecoder : Boolean = true)

class VexRiscvSmpClusterBase(p : VexRiscvSmpClusterParameter) extends Generator{
  val cpuCount = p.cpuConfigs.size

  val debugCd = ClockDomainResetGenerator()
  debugCd.holdDuration.load(4095)
  debugCd.makeExternal()

  val systemCd = ClockDomainResetGenerator()
  systemCd.holdDuration.load(63)
  systemCd.setInput(debugCd)

  this.onClockDomain(systemCd.outputClockDomain)

  implicit val interconnect = BmbInterconnectGenerator()

  val debugBridge = JtagInstructionDebuggerGenerator() onClockDomain(debugCd.outputClockDomain)
  debugBridge.jtagClockDomain.load(ClockDomain.external("jtag", withReset = false))

  val debugPort = debugBridge.produceIo(debugBridge.logic.jtagBridge.io.ctrl)

  val dBusCoherent = BmbBridgeGenerator()
  val dBusNonCoherent = BmbBridgeGenerator()

  val smp = p.withExclusiveAndInvalidation generate new Area{
    val exclusiveMonitor = BmbExclusiveMonitorGenerator()
    interconnect.addConnection(dBusCoherent.bmb, exclusiveMonitor.input)

    val invalidationMonitor = BmbInvalidateMonitorGenerator()
    interconnect.addConnection(exclusiveMonitor.output, invalidationMonitor.input)
    interconnect.addConnection(invalidationMonitor.output, dBusNonCoherent.bmb)
    if(p.outOfOrderDecoder) interconnect.masters(invalidationMonitor.output).withOutOfOrderDecoder()
  }

  val noSmp = !p.withExclusiveAndInvalidation generate new Area{
    interconnect.addConnection(dBusCoherent.bmb, dBusNonCoherent.bmb)
  }

  val cores = for(cpuId <- 0 until cpuCount) yield new Area{
    val cpu = VexRiscvBmbGenerator()
    cpu.config.load(p.cpuConfigs(cpuId))
    interconnect.addConnection(
      cpu.dBus -> List(dBusCoherent.bmb)
    )
    cpu.enableDebugBmb(
      debugCd = debugCd,
      resetCd = systemCd,
      mapping = SizeMapping(cpuId*0x1000, 0x1000)
    )
    interconnect.addConnection(debugBridge.bmb, cpu.debugBmb)
  }
}


class VexRiscvSmpClusterWithPeripherals(p : VexRiscvSmpClusterParameter) extends VexRiscvSmpClusterBase(p) {
  val peripheralBridge = BmbToWishboneGenerator(DefaultMapping)
  val peripheral = peripheralBridge.produceIo(peripheralBridge.logic.io.output)
  if(p.forcePeripheralWidth) interconnect.slaves(peripheralBridge.bmb).forceAccessSourceDataWidth(32)

  val plic = BmbPlicGenerator()(interconnect = null)
  plic.priorityWidth.load(2)
  plic.mapping.load(PlicMapping.sifive)

  val plicWishboneBridge = new Generator{
    dependencies += plic.ctrl

    plic.accessRequirements.load(BmbAccessParameter(
      addressWidth = 22,
      dataWidth = 32
    ).addSources(1, BmbSourceParameter(
      contextWidth = 0,
      lengthWidth = 2,
      alignment =  BmbParameter.BurstAlignement.LENGTH
    )))

    val logic = add task new Area{
      val bridge = WishboneToBmb(WishboneConfig(20, 32))
      bridge.io.output >> plic.ctrl
    }
  }
  val plicWishbone = plicWishboneBridge.produceIo(plicWishboneBridge.logic.bridge.io.input)

  val clint = BmbClintGenerator(0)(interconnect = null)
  val clintWishboneBridge = new Generator{
    dependencies += clint.ctrl

    clint.accessRequirements.load(BmbAccessParameter(
      addressWidth = 16,
      dataWidth = 32
    ).addSources(1, BmbSourceParameter(
      contextWidth = 0,
      lengthWidth = 2,
      alignment =  BmbParameter.BurstAlignement.LENGTH
    )))

    val logic = add task new Area{
      val bridge = WishboneToBmb(WishboneConfig(14, 32))
      bridge.io.output >> clint.ctrl
    }
  }
  val clintWishbone = clintWishboneBridge.produceIo(clintWishboneBridge.logic.bridge.io.input)

  val interrupts = add task (in Bits(32 bits))
  for(i <- 1 to 31) yield plic.addInterrupt(interrupts.derivate(_.apply(i)), i)

  for ((core, cpuId) <- cores.zipWithIndex) {
    core.cpu.setTimerInterrupt(clint.timerInterrupt(cpuId))
    core.cpu.setSoftwareInterrupt(clint.softwareInterrupt(cpuId))
    plic.priorityWidth.load(2)
    plic.mapping.load(PlicMapping.sifive)
    plic.addTarget(core.cpu.externalInterrupt)
    plic.addTarget(core.cpu.externalSupervisorInterrupt)
    List(clint.logic, core.cpu.logic).produce {
      for (plugin <- core.cpu.config.plugins) plugin match {
        case plugin: CsrPlugin if plugin.utime != null => plugin.utime := clint.logic.io.time
        case _ =>
      }
    }
  }

  clint.cpuCount.load(cpuCount)
}


object VexRiscvSmpClusterGen {
  def vexRiscvConfig(hartId : Int,
                     ioRange : UInt => Bool = (x => x(31 downto 28) === 0xF),
                     resetVector : Long = 0x80000000l,
                     iBusWidth : Int = 128,
                     dBusWidth : Int = 64,
                     coherency : Boolean = true,
                     iCacheSize : Int = 8192,
                     dCacheSize : Int = 8192,
                     iCacheWays : Int = 2,
                     dCacheWays : Int = 2,
                     iBusRelax : Boolean = false,
                     earlyBranch : Boolean = false,
                     dBusCmdMasterPipe : Boolean = false,
                     withMmu : Boolean = true,
                     withSupervisor : Boolean = true
                    ) = {
    assert(iCacheSize/iCacheWays <= 4096, "Instruction cache ways can't be bigger than 4096 bytes")
    assert(dCacheSize/dCacheWays <= 4096, "Data cache ways can't be bigger than 4096 bytes")
    val config = VexRiscvConfig(
      plugins = List(
        if(withMmu)new MmuPlugin(
          ioRange = ioRange
        )else new StaticMemoryTranslatorPlugin(
          ioRange = ioRange
        ),
        //Uncomment the whole IBusCachedPlugin and comment IBusSimplePlugin if you want cached iBus config
        new IBusCachedPlugin(
          resetVector = resetVector,
          compressedGen = false,
          prediction = vexriscv.plugin.NONE,
          historyRamSizeLog2 = 9,
          relaxPredictorAddress = true,
          injectorStage = false,
          relaxedPcCalculation = iBusRelax,
          config = InstructionCacheConfig(
            cacheSize = iCacheSize,
            bytePerLine = 64,
            wayCount = iCacheWays,
            addressWidth = 32,
            cpuDataWidth = 32,
            memDataWidth = iBusWidth,
            catchIllegalAccess = true,
            catchAccessFault = true,
            asyncTagMemory = false,
            twoCycleRam = false,
            twoCycleCache = true,
            reducedBankWidth = true
          ),
          memoryTranslatorPortConfig = MmuPortConfig(
            portTlbSize = 4,
            latency = 1,
            earlyRequireMmuLockup = true,
            earlyCacheHits = true
          )
        ),
        new DBusCachedPlugin(
          dBusCmdMasterPipe = dBusCmdMasterPipe || dBusWidth == 32,
          dBusCmdSlavePipe = true,
          dBusRspSlavePipe = true,
          relaxedMemoryTranslationRegister = true,
          config = new DataCacheConfig(
            cacheSize         = dCacheSize,
            bytePerLine       = 64,
            wayCount          = dCacheWays,
            addressWidth      = 32,
            cpuDataWidth      = 32,
            memDataWidth      = dBusWidth,
            catchAccessError  = true,
            catchIllegal      = true,
            catchUnaligned    = true,
            withLrSc = true,
            withAmo = true,
            withExclusive = coherency,
            withInvalidate = coherency,
            aggregationWidth = if(dBusWidth == 32) 0 else log2Up(dBusWidth/8)
            //          )
          ),
          memoryTranslatorPortConfig = MmuPortConfig(
            portTlbSize = 4,
            latency = 1,
            earlyRequireMmuLockup = true,
            earlyCacheHits = true
          )
        ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.ASYNC,
          zeroBoot = false,
          x0Init = true
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false
        ),
        new FullBarrelShifterPlugin(earlyInjection = true),
        //        new LightShifterPlugin,
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new MulPlugin,
        new MulDivIterativePlugin(
          genMul = false,
          genDiv = true,
          mulUnrollFactor = 32,
          divUnrollFactor = 1
        ),
        new CsrPlugin(CsrPluginConfig.openSbi(mhartid = hartId, misa = Riscv.misaToInt("imas")).copy(utimeAccess = CsrAccess.READ_ONLY)),
        new BranchPlugin(
          earlyBranch = earlyBranch,
          catchAddressMisaligned = true,
          fenceiGenAsAJump = false
        ),
        new YamlPlugin(s"cpu$hartId.yaml")
      )
    )
    config
  }


//  def vexRiscvCluster(cpuCount : Int, resetVector : Long = 0x80000000l) = VexRiscvSmpCluster(
//    debugClockDomain = ClockDomain.current.copy(reset = Bool().setName("debugResetIn")),
//    p = VexRiscvSmpClusterParameter(
//      cpuConfigs = List.tabulate(cpuCount) {
//        vexRiscvConfig(_, resetVector = resetVector)
//      }
//    )
//  )
//  def main(args: Array[String]): Unit = {
//    SpinalVerilog {
//      vexRiscvCluster(4)
//    }
//  }
}
//
//
//
//object VexRiscvSmpClusterTestInfrastructure{
//  val REPORT_OFFSET = 0xF8000000
//  val REPORT_THREAD_ID = 0x00
//  val REPORT_THREAD_COUNT = 0x04
//  val REPORT_END = 0x08
//  val REPORT_BARRIER_START = 0x0C
//  val REPORT_BARRIER_END   = 0x10
//  val REPORT_CONSISTENCY_VALUES = 0x14
//
//  val PUTC = 0x00
//  val GETC = 0x04
//  val CLINT_ADDR = 0x10000
//  val CLINT_IPI_ADDR = CLINT_ADDR+0x0000
//  val CLINT_CMP_ADDR = CLINT_ADDR+0x4000
//  val CLINT_TIME_ADDR = CLINT_ADDR+0xBFF8
//
//  def ram(dut : VexRiscvSmpCluster, withStall : Boolean) = {
//    import spinal.core.sim._
//    val cpuCount = dut.cpus.size
//    val ram = new BmbMemoryAgent(0x100000000l){
//      case class Report(hart : Int, code : Int, data : Int){
//        override def toString: String = {
//          f"CPU:$hart%2d ${code}%3x -> $data%3d"
//        }
//      }
//      val reports = ArrayBuffer.fill(cpuCount)(ArrayBuffer[Report]())
//
//
//      val writeTable = mutable.HashMap[Int, Int => Unit]()
//      val readTable = mutable.HashMap[Int, () => Int]()
//      def onWrite(address : Int)(body : Int => Unit) = writeTable(address) = body
//      def onRead(address : Int)(body : => Int) = readTable(address) = () => body
//
//      var writeData = 0
//      var readData = 0
//      var reportWatchdog = 0
//      val cpuEnd = Array.fill(cpuCount)(false)
//      val barriers = mutable.HashMap[Int, Int]()
//      var consistancyCounter = 0
//      var consistancyLast = 0
//      var consistancyA = 0
//      var consistancyB = 0
//      var consistancyAB = 0
//      var consistancyNone = 0
//
//      onSimEnd{
//        for((list, hart) <- reports.zipWithIndex){
//          println(f"\n\n**** CPU $hart%2d ****")
//          for((report, reportId) <- list.zipWithIndex){
//            println(f"  $reportId%3d : ${report.code}%3x -> ${report.data}%3d")
//          }
//        }
//
//        println(s"consistancy NONE:$consistancyNone A:$consistancyA B:$consistancyB AB:$consistancyAB")
//      }
//
//      override def setByte(address: Long, value: Byte): Unit = {
//        if((address & 0xF0000000l) != 0xF0000000l) return  super.setByte(address, value)
//        val byteId = address & 3
//        val mask = 0xFF << (byteId*8)
//        writeData = (writeData & ~mask) | ((value.toInt << (byteId*8)) & mask)
//        if(byteId != 3) return
//        val offset = (address & ~0xF0000000l)-3
//        //        println(s"W[0x${offset.toHexString}] = $writeData @${simTime()}")
//        offset match {
//          case _ if offset >= 0x8000000 && offset < 0x9000000 => {
//            val report = Report(
//              hart = ((offset & 0xFF0000) >> 16).toInt,
//              code = (offset & 0x00FFFF).toInt,
//              data = writeData
//            )
////            println(report)
//            reports(report.hart) += report
//            reportWatchdog += 1
//            import report._
//            code match {
//              case REPORT_THREAD_ID => assert(data == hart)
//              case REPORT_THREAD_COUNT => assert(data == cpuCount)
//              case REPORT_END => assert(data == 0); assert(cpuEnd(hart) == false); cpuEnd(hart) = true; if(!cpuEnd.exists(_ == false)) simSuccess()
//              case REPORT_BARRIER_START => {
//                val counter = barriers.getOrElse(data, 0)
//                assert(counter < cpuCount)
//                barriers(data) = counter + 1
//              }
//              case REPORT_BARRIER_END => {
//                val counter = barriers.getOrElse(data, 0)
//                assert(counter == cpuCount)
//              }
//              case REPORT_CONSISTENCY_VALUES => consistancyCounter match {
//                case 0 => {
//                  consistancyCounter = 1
//                  consistancyLast = data
//                }
//                case 1 => {
//                  consistancyCounter =  0
//                  (data, consistancyLast) match {
//                    case (666, 0) => consistancyA += 1
//                    case (0, 666) => consistancyB += 1
//                    case (666, 666)  => consistancyAB += 1
//                    case (0,0) => consistancyNone += 1; simFailure("Consistancy issue :(")
//                  }
//                }
//              }
//            }
//          }
//          case _ => writeTable.get(offset.toInt) match {
//            case Some(x) => x(writeData)
//            case _ => simFailure(f"\n\nWrite at ${address-3}%8x with $writeData%8x")
//          }
//        }
//      }
//
//      override def getByte(address: Long): Byte = {
//        if((address & 0xF0000000l) != 0xF0000000l) return super.getByte(address)
//        val byteId = address & 3
//        val offset = (address & ~0xF0000000l)
//        if(byteId == 0) readData = readTable.get(offset.toInt) match {
//          case Some(x) => x()
//          case _ => simFailure(f"\n\nRead at $address%8x")
//        }
//        (readData >> (byteId*8)).toByte
//      }
//
//      val clint = new {
//        val cmp = Array.fill(cpuCount)(0l)
//        var time = 0l
//        periodicaly(100){
//          time += 10
//          var timerInterrupts = 0l
//          for(i <- 0 until cpuCount){
//            if(cmp(i) < time) timerInterrupts |= 1l << i
//          }
//          dut.io.timerInterrupts #= timerInterrupts
//        }
//
////        delayed(200*1000000){
////          dut.io.softwareInterrupts #= 0xE
////          enableSimWave()
////          println("force IPI")
////        }
//      }
//
//      onWrite(PUTC)(data => print(data.toChar))
//      onRead(GETC)( if(System.in.available() != 0) System.in.read() else -1)
//
//      dut.io.softwareInterrupts #= 0
//      dut.io.timerInterrupts #= 0
//      dut.io.externalInterrupts #= 0
//      dut.io.externalSupervisorInterrupts #= 0
//      onRead(CLINT_TIME_ADDR)(clint.time.toInt)
//      onRead(CLINT_TIME_ADDR+4)((clint.time >> 32).toInt)
//      for(hartId <- 0 until cpuCount){
//        onWrite(CLINT_IPI_ADDR + hartId*4) {data =>
//          val mask = 1l << hartId
//          val value = (dut.io.softwareInterrupts.toLong & ~mask) | (if(data == 1) mask else 0)
//          dut.io.softwareInterrupts #= value
//        }
////        onRead(CLINT_CMP_ADDR + hartId*8)(clint.cmp(hartId).toInt)
////        onRead(CLINT_CMP_ADDR + hartId*8+4)((clint.cmp(hartId) >> 32).toInt)
//        onWrite(CLINT_CMP_ADDR + hartId*8){data => clint.cmp(hartId) = (clint.cmp(hartId) & 0xFFFFFFFF00000000l) | data}
//        onWrite(CLINT_CMP_ADDR + hartId*8+4){data => clint.cmp(hartId) = (clint.cmp(hartId) & 0x00000000FFFFFFFFl) | (data.toLong << 32)}
//      }
//
//
//
//    }
//    dut.io.iMems.foreach(ram.addPort(_,0,dut.clockDomain,true, withStall))
//    ram.addPort(dut.io.dMem,0,dut.clockDomain,true, withStall)
//    ram
//  }
//  def init(dut : VexRiscvSmpCluster): Unit ={
//    import spinal.core.sim._
//    dut.clockDomain.forkStimulus(10)
//    dut.debugClockDomain.forkStimulus(10)
//    dut.io.debugBus.cmd.valid #= false
//  }
//}
//
//object VexRiscvSmpClusterTest extends App{
//  import spinal.core.sim._
//
//  val simConfig = SimConfig
//  simConfig.withWave
//  simConfig.allOptimisation
//  simConfig.addSimulatorFlag("--threads 1")
//
//  val cpuCount = 4
//  val withStall = true
//
//  simConfig.compile(VexRiscvSmpClusterGen.vexRiscvCluster(cpuCount)).doSimUntilVoid(seed = 42){dut =>
//    disableSimWave()
//    SimTimeout(100000000l*10*cpuCount)
//    dut.clockDomain.forkSimSpeedPrinter(1.0)
//    VexRiscvSmpClusterTestInfrastructure.init(dut)
//    val ram = VexRiscvSmpClusterTestInfrastructure.ram(dut, withStall)
//    ram.memory.loadBin(0x80000000l, "src/test/cpp/raw/smp/build/smp.bin")
//    periodicaly(20000*10){
//      assert(ram.reportWatchdog != 0)
//      ram.reportWatchdog = 0
//    }
//  }
//}
//
//// echo "echo 10000 | dhrystone >> log" > test
//// time sh test &
//// top -b -n 1
//
//// TODO
//// MultiChannelFifo.toStream arbitration
//// BmbDecoderOutOfOrder arbitration
//// DataCache to bmb invalidation that are more than single line
//object VexRiscvSmpClusterOpenSbi extends App{
//  import spinal.core.sim._
//
//  val simConfig = SimConfig
//  simConfig.withWave
//  simConfig.allOptimisation
//  simConfig.addSimulatorFlag("--threads 1")
//
//  val cpuCount = 2
//  val withStall = false
//
//  def gen = {
//    val dut = VexRiscvSmpClusterGen.vexRiscvCluster(cpuCount, resetVector = 0x80000000l)
//    dut.cpus.foreach{cpu =>
//      cpu.core.children.foreach{
//        case cache : InstructionCache => cache.io.cpu.decode.simPublic()
//        case _ =>
//      }
//    }
//    dut
//  }
//
//  simConfig.workspaceName("rawr_4c").compile(gen).doSimUntilVoid(seed = 42){dut =>
////    dut.clockDomain.forkSimSpeedPrinter(1.0)
//    VexRiscvSmpClusterTestInfrastructure.init(dut)
//    val ram = VexRiscvSmpClusterTestInfrastructure.ram(dut, withStall)
////    ram.memory.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_payload.bin")
//
////    ram.memory.loadBin(0x40F00000l, "/media/data/open/litex_smp/litex_vexriscv_smp/images/fw_jump.bin")
////    ram.memory.loadBin(0x40000000l, "/media/data/open/litex_smp/litex_vexriscv_smp/images/Image")
////    ram.memory.loadBin(0x40EF0000l, "/media/data/open/litex_smp/litex_vexriscv_smp/images/dtb")
////    ram.memory.loadBin(0x41000000l, "/media/data/open/litex_smp/litex_vexriscv_smp/images/rootfs.cpio")
//
//    ram.memory.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin")
//    ram.memory.loadBin(0xC0000000l, "../buildroot/output/images/Image")
//    ram.memory.loadBin(0xC1000000l, "../buildroot/output/images/dtb")
//    ram.memory.loadBin(0xC2000000l, "../buildroot/output/images/rootfs.cpio")
//
//    import spinal.core.sim._
//    var iMemReadBytes, dMemReadBytes, dMemWriteBytes, iMemSequencial,iMemRequests, iMemPrefetchHit = 0l
//    var reportTimer = 0
//    var reportCycle = 0
//    val iMemFetchDelta = mutable.HashMap[Long, Long]()
//    var iMemFetchDeltaSorted : Seq[(Long, Long)] = null
//    var dMemWrites, dMemWritesCached = 0l
//    val dMemWriteCacheCtx = List(4,8,16,32,64).map(bytes => new {
//      var counter = 0l
//      var address = 0l
//      val mask = ~((1 << log2Up(bytes))-1)
//    })
//
//    import java.io._
//    val csv = new PrintWriter(new File("bench.csv" ))
//    val iMemCtx = Array.tabulate(cpuCount)(i => new {
//      var sequencialPrediction = 0l
//      val cache = dut.cpus(i).core.children.find(_.isInstanceOf[InstructionCache]).head.asInstanceOf[InstructionCache].io.cpu.decode
//      var lastAddress = 0l
//    })
//    dut.clockDomain.onSamplings{
//      dut.io.time #= simTime()/10
//
//
//      for(i <- 0 until cpuCount; iMem = dut.io.iMems(i); ctx = iMemCtx(i)){
////        if(iMem.cmd.valid.toBoolean && iMem.cmd.ready.toBoolean){
////          val length = iMem.cmd.length.toInt + 1
////          val address = iMem.cmd.address.toLong
////          iMemReadBytes += length
////          iMemRequests += 1
////        }
//        if(ctx.cache.isValid.toBoolean && !ctx.cache.mmuRefilling.toBoolean && !ctx.cache.mmuException.toBoolean){
//          val address = ctx.cache.physicalAddress.toLong
//          val length = ctx.cache.p.bytePerLine.toLong
//          val mask = ~(length-1)
//          if(ctx.cache.cacheMiss.toBoolean) {
//            iMemReadBytes += length
//            if ((address & mask) == (ctx.sequencialPrediction & mask)) {
//              iMemSequencial += 1
//            }
//          }
//          if(!ctx.cache.isStuck.toBoolean) {
//            ctx.sequencialPrediction = address + length
//          }
//        }
//
//        if(iMem.cmd.valid.toBoolean && iMem.cmd.ready.toBoolean){
//          val address = iMem.cmd.address.toLong
//          iMemRequests += 1
//          if(iMemCtx(i).lastAddress + ctx.cache.p.bytePerLine == address){
//            iMemPrefetchHit += 1
//          }
//          val delta = address-iMemCtx(i).lastAddress
//          iMemFetchDelta(delta) = iMemFetchDelta.getOrElse(delta, 0l) + 1l
//          if(iMemRequests % 1000 == 999) iMemFetchDeltaSorted = iMemFetchDelta.toSeq.sortBy(_._1)
//          iMemCtx(i).lastAddress = address
//        }
//      }
//      if(dut.io.dMem.cmd.valid.toBoolean && dut.io.dMem.cmd.ready.toBoolean){
//        if(dut.io.dMem.cmd.opcode.toInt == Bmb.Cmd.Opcode.WRITE){
//          dMemWriteBytes += dut.io.dMem.cmd.length.toInt+1
//          val address = dut.io.dMem.cmd.address.toLong
//          dMemWrites += 1
//          for(ctx <- dMemWriteCacheCtx){
//            if((address & ctx.mask) == (ctx.address & ctx.mask)){
//              ctx.counter += 1
//            } else {
//              ctx.address = address
//            }
//          }
//        }else {
//          dMemReadBytes += dut.io.dMem.cmd.length.toInt+1
//          for(ctx <- dMemWriteCacheCtx) ctx.address = -1
//        }
//      }
//      reportTimer = reportTimer + 1
//      reportCycle = reportCycle + 1
//      if(reportTimer == 400000){
//        reportTimer = 0
////        println(f"\n** c=${reportCycle} ir=${iMemReadBytes*1e-6}%5.2f dr=${dMemReadBytes*1e-6}%5.2f dw=${dMemWriteBytes*1e-6}%5.2f **\n")
//
//
//        csv.write(s"$reportCycle,$iMemReadBytes,$dMemReadBytes,$dMemWriteBytes,$iMemRequests,$iMemSequencial,$dMemWrites,${dMemWriteCacheCtx.map(_.counter).mkString(",")},$iMemPrefetchHit\n")
//        csv.flush()
//        reportCycle = 0
//        iMemReadBytes = 0
//        dMemReadBytes = 0
//        dMemWriteBytes = 0
//        iMemRequests = 0
//        iMemSequencial = 0
//        dMemWrites = 0
//        iMemPrefetchHit = 0
//        for(ctx <- dMemWriteCacheCtx) ctx.counter = 0
//      }
//    }
//
//
////    fork{
////      disableSimWave()
////      val atMs = 3790
////      val durationMs = 5
////      sleep(atMs*1000000)
////      enableSimWave()
////      println("** enableSimWave **")
////      sleep(durationMs*1000000)
////      println("** disableSimWave **")
////      while(true) {
////        disableSimWave()
////        sleep(100000 * 10)
////        enableSimWave()
////        sleep(  100 * 10)
////      }
//////      simSuccess()
////    }
//
//    fork{
//      while(true) {
//        disableSimWave()
//        sleep(100000 * 10)
//        enableSimWave()
//        sleep(  100 * 10)
//      }
//    }
//  }
//}
