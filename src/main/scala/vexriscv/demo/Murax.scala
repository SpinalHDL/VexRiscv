package vexriscv.demo

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.bus.simple.PipelinedMemoryBus
import spinal.lib.com.jtag.Jtag
import spinal.lib.com.spi.ddr.SpiXdrMaster
import spinal.lib.com.uart._
import spinal.lib.io.{InOutWrapper, TriStateArray}
import spinal.lib.misc.{InterruptCtrl, Prescaler, Timer}
import spinal.lib.soc.pinsec.{PinsecTimerCtrl, PinsecTimerCtrlExternal}
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}
import spinal.lib.com.spi.ddr._
import spinal.lib.bus.simple._
import scala.collection.mutable.ArrayBuffer

/**
 * Created by PIC32F_USER on 28/07/2017.
 *
 * Murax is a very light SoC which could work without any external component.
 * - ICE40-hx8k + icestorm =>  53 Mhz, 2142 LC
 * - 0.37 DMIPS/Mhz
 * - 8 kB of on-chip ram
 * - JTAG debugger (eclipse/GDB/openocd ready)
 * - Interrupt support
 * - APB bus for peripherals
 * - 32 GPIO pin
 * - one 16 bits prescaler, two 16 bits timers
 * - one UART with tx/rx fifo
 */


case class MuraxConfig(coreFrequency : HertzNumber,
                       onChipRamSize      : BigInt,
                       onChipRamHexFile   : String,
                       pipelineDBus       : Boolean,
                       pipelineMainBus    : Boolean,
                       pipelineApbBridge  : Boolean,
                       gpioWidth          : Int,
                       uartCtrlConfig     : UartCtrlMemoryMappedConfig,
                       xipConfig          : SpiXdrMasterCtrl.MemoryMappingParameters,
                       hardwareBreakpointCount : Int,
                       cpuPlugins         : ArrayBuffer[Plugin[VexRiscv]]){
  require(pipelineApbBridge || pipelineMainBus, "At least pipelineMainBus or pipelineApbBridge should be enable to avoid wipe transactions")
  val genXip = xipConfig != null

}



object MuraxConfig{
  def default : MuraxConfig = default(false, false)
  def default(withXip : Boolean = false, bigEndian : Boolean = false) =  MuraxConfig(
    coreFrequency         = 12 MHz,
    onChipRamSize         = 8 kB,
    onChipRamHexFile      = null,
    pipelineDBus          = true,
    pipelineMainBus       = false,
    pipelineApbBridge     = true,
    gpioWidth = 32,
    xipConfig = ifGen(withXip) (SpiXdrMasterCtrl.MemoryMappingParameters(
      SpiXdrMasterCtrl.Parameters(8, 12, SpiXdrParameter(2, 2, 1)).addFullDuplex(0,1,false),
      cmdFifoDepth = 32,
      rspFifoDepth = 32,
      xip = SpiXdrMasterCtrl.XipBusParameters(addressWidth = 24, lengthWidth = 2)
    )),
    hardwareBreakpointCount = if(withXip) 3 else 0,
    cpuPlugins = ArrayBuffer( //DebugPlugin added by the toplevel
      new IBusSimplePlugin(
        resetVector = if(withXip) 0xF001E000l else 0x80000000l,
        cmdForkOnSecondStage = true,
        cmdForkPersistence = withXip, //Required by the Xip controller
        prediction = NONE,
        catchAccessFault = false,
        compressedGen = false,
        bigEndian = bigEndian
      ),
      new DBusSimplePlugin(
        catchAddressMisaligned = false,
        catchAccessFault = false,
        earlyInjection = false,
        bigEndian = bigEndian
      ),
      new CsrPlugin(CsrPluginConfig.smallest(mtvecInit = if(withXip) 0xE0040020l else 0x80000020l)),
      new DecoderSimplePlugin(
        catchIllegalInstruction = false
      ),
      new RegFilePlugin(
        regFileReadyKind = plugin.SYNC,
        zeroBoot = false
      ),
      new IntAluPlugin,
      new SrcPlugin(
        separatedAddSub = false,
        executeInsertion = false
      ),
      new LightShifterPlugin,
      new HazardSimplePlugin(
        bypassExecute = false,
        bypassMemory = false,
        bypassWriteBack = false,
        bypassWriteBackBuffer = false,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      ),
      new BranchPlugin(
        earlyBranch = false,
        catchAddressMisaligned = false
      ),
      new YamlPlugin("cpu0.yaml")
    ),
    uartCtrlConfig = UartCtrlMemoryMappedConfig(
      uartCtrlConfig = UartCtrlGenerics(
        dataWidthMax      = 8,
        clockDividerWidth = 20,
        preSamplingSize   = 1,
        samplingSize      = 3,
        postSamplingSize  = 1
      ),
      initConfig = UartCtrlInitConfig(
        baudrate = 115200,
        dataLength = 7,  //7 => 8 bits
        parity = UartParityType.NONE,
        stop = UartStopType.ONE
      ),
      busCanWriteClockDividerConfig = false,
      busCanWriteFrameConfig = false,
      txFifoDepth = 16,
      rxFifoDepth = 16
    )

  )

  def fast = {
    val config = default

    //Replace HazardSimplePlugin to get datapath bypass
    config.cpuPlugins(config.cpuPlugins.indexWhere(_.isInstanceOf[HazardSimplePlugin])) = new HazardSimplePlugin(
      bypassExecute = true,
      bypassMemory = true,
      bypassWriteBack = true,
      bypassWriteBackBuffer = true
    )
//    config.cpuPlugins(config.cpuPlugins.indexWhere(_.isInstanceOf[LightShifterPlugin])) = new FullBarrelShifterPlugin()

    config
  }
}


case class Murax(config : MuraxConfig) extends Component{
  import config._

  val io = new Bundle {
    //Clocks / reset
    val asyncReset = in Bool
    val mainClk = in Bool

    //Main components IO
    val jtag = slave(Jtag())

    //Peripherals IO
    val gpioA = master(TriStateArray(gpioWidth bits))
    val uart = master(Uart())

    val xip = ifGen(genXip)(master(SpiXdrMaster(xipConfig.ctrl.spi)))
  }


  val resetCtrlClockDomain = ClockDomain(
    clock = io.mainClk,
    config = ClockDomainConfig(
      resetKind = BOOT
    )
  )

  val resetCtrl = new ClockingArea(resetCtrlClockDomain) {
    val mainClkResetUnbuffered  = False

    //Implement an counter to keep the reset axiResetOrder high 64 cycles
    // Also this counter will automatically do a reset when the system boot.
    val systemClkResetCounter = Reg(UInt(6 bits)) init(0)
    when(systemClkResetCounter =/= U(systemClkResetCounter.range -> true)){
      systemClkResetCounter := systemClkResetCounter + 1
      mainClkResetUnbuffered := True
    }
    when(BufferCC(io.asyncReset)){
      systemClkResetCounter := 0
    }

    //Create all reset used later in the design
    val mainClkReset = RegNext(mainClkResetUnbuffered)
    val systemReset  = RegNext(mainClkResetUnbuffered)
  }


  val systemClockDomain = ClockDomain(
    clock = io.mainClk,
    reset = resetCtrl.systemReset,
    frequency = FixedFrequency(coreFrequency)
  )

  val debugClockDomain = ClockDomain(
    clock = io.mainClk,
    reset = resetCtrl.mainClkReset,
    frequency = FixedFrequency(coreFrequency)
  )

  val system = new ClockingArea(systemClockDomain) {
    val pipelinedMemoryBusConfig = PipelinedMemoryBusConfig(
      addressWidth = 32,
      dataWidth = 32
    )

    val bigEndianDBus = config.cpuPlugins.exists(_ match{ case plugin : DBusSimplePlugin => plugin.bigEndian case _ => false})

    //Arbiter of the cpu dBus/iBus to drive the mainBus
    //Priority to dBus, !! cmd transactions can change on the fly !!
    val mainBusArbiter = new MuraxMasterArbiter(pipelinedMemoryBusConfig, bigEndianDBus)

    //Instanciate the CPU
    val cpu = new VexRiscv(
      config = VexRiscvConfig(
        plugins = cpuPlugins += new DebugPlugin(debugClockDomain, hardwareBreakpointCount)
      )
    )

    //Checkout plugins used to instanciate the CPU to connect them to the SoC
    val timerInterrupt = False
    val externalInterrupt = False
    for(plugin <- cpu.plugins) plugin match{
      case plugin : IBusSimplePlugin =>
        mainBusArbiter.io.iBus.cmd <> plugin.iBus.cmd
        mainBusArbiter.io.iBus.rsp <> plugin.iBus.rsp
      case plugin : DBusSimplePlugin => {
        if(!pipelineDBus)
          mainBusArbiter.io.dBus <> plugin.dBus
        else {
          mainBusArbiter.io.dBus.cmd << plugin.dBus.cmd.halfPipe()
          mainBusArbiter.io.dBus.rsp <> plugin.dBus.rsp
        }
      }
      case plugin : CsrPlugin        => {
        plugin.externalInterrupt := externalInterrupt
        plugin.timerInterrupt := timerInterrupt
      }
      case plugin : DebugPlugin         => plugin.debugClockDomain{
        resetCtrl.systemReset setWhen(RegNext(plugin.io.resetOut))
        io.jtag <> plugin.io.bus.fromJtag()
      }
      case _ =>
    }



    //****** MainBus slaves ********
    val mainBusMapping = ArrayBuffer[(PipelinedMemoryBus,SizeMapping)]()
    val ram = new MuraxPipelinedMemoryBusRam(
      onChipRamSize = onChipRamSize,
      onChipRamHexFile = onChipRamHexFile,
      pipelinedMemoryBusConfig = pipelinedMemoryBusConfig,
      bigEndian = bigEndianDBus
    )
    mainBusMapping += ram.io.bus -> (0x80000000l, onChipRamSize)

    val apbBridge = new PipelinedMemoryBusToApbBridge(
      apb3Config = Apb3Config(
        addressWidth = 20,
        dataWidth = 32
      ),
      pipelineBridge = pipelineApbBridge,
      pipelinedMemoryBusConfig = pipelinedMemoryBusConfig
    )
    mainBusMapping += apbBridge.io.pipelinedMemoryBus -> (0xF0000000l, 1 MB)



    //******** APB peripherals *********
    val apbMapping = ArrayBuffer[(Apb3, SizeMapping)]()
    val gpioACtrl = Apb3Gpio(gpioWidth = gpioWidth, withReadSync = true)
    io.gpioA <> gpioACtrl.io.gpio
    apbMapping += gpioACtrl.io.apb -> (0x00000, 4 kB)

    val uartCtrl = Apb3UartCtrl(uartCtrlConfig)
    uartCtrl.io.uart <> io.uart
    externalInterrupt setWhen(uartCtrl.io.interrupt)
    apbMapping += uartCtrl.io.apb  -> (0x10000, 4 kB)

    val timer = new MuraxApb3Timer()
    timerInterrupt setWhen(timer.io.interrupt)
    apbMapping += timer.io.apb     -> (0x20000, 4 kB)

    val xip = ifGen(genXip)(new Area{
      val ctrl = Apb3SpiXdrMasterCtrl(xipConfig)
      ctrl.io.spi <> io.xip
      externalInterrupt setWhen(ctrl.io.interrupt)
      apbMapping += ctrl.io.apb     -> (0x1F000, 4 kB)

      val accessBus = new PipelinedMemoryBus(PipelinedMemoryBusConfig(24,32))
      mainBusMapping += accessBus -> (0xE0000000l, 16 MB)

      ctrl.io.xip.fromPipelinedMemoryBus() << accessBus
      val bootloader = Apb3Rom("src/main/c/murax/xipBootloader/crt.bin")
      apbMapping += bootloader.io.apb     -> (0x1E000, 4 kB)
    })



    //******** Memory mappings *********
    val apbDecoder = Apb3Decoder(
      master = apbBridge.io.apb,
      slaves = apbMapping
    )

    val mainBusDecoder = new Area {
      val logic = new MuraxPipelinedMemoryBusDecoder(
        master = mainBusArbiter.io.masterBus,
        specification = mainBusMapping,
        pipelineMaster = pipelineMainBus
      )
    }
  }
}



object Murax{
  def main(args: Array[String]) {
    SpinalVerilog(Murax(MuraxConfig.default))
  }
}

object Murax_iCE40_hx8k_breakout_board_xip{

  case class SB_GB() extends BlackBox{
    val USER_SIGNAL_TO_GLOBAL_BUFFER = in Bool()
    val GLOBAL_BUFFER_OUTPUT = out Bool()
  }

  case class SB_IO_SCLK() extends BlackBox{
    addGeneric("PIN_TYPE", B"010000")
    val PACKAGE_PIN = out Bool()
    val OUTPUT_CLK = in Bool()
    val CLOCK_ENABLE = in Bool()
    val D_OUT_0 = in Bool()
    val D_OUT_1 = in Bool()
    setDefinitionName("SB_IO")
  }

  case class SB_IO_DATA() extends BlackBox{
    addGeneric("PIN_TYPE", B"110000")
    val PACKAGE_PIN = inout(Analog(Bool))
    val CLOCK_ENABLE = in Bool()
    val INPUT_CLK = in Bool()
    val OUTPUT_CLK = in Bool()
    val OUTPUT_ENABLE = in Bool()
    val D_OUT_0 = in Bool()
    val D_OUT_1 = in Bool()
    val D_IN_0 = out Bool()
    val D_IN_1 = out Bool()
    setDefinitionName("SB_IO")
  }

  case class Murax_iCE40_hx8k_breakout_board_xip() extends Component{
    val io = new Bundle {
      val mainClk  = in  Bool()
      val jtag_tck = in  Bool()
      val jtag_tdi = in  Bool()
      val jtag_tdo = out Bool()
      val jtag_tms = in  Bool()
      val uart_txd = out Bool()
      val uart_rxd = in  Bool()

      val mosi = inout(Analog(Bool))
      val miso = inout(Analog(Bool))
      val sclk = out Bool()
      val spis = out Bool()

      val led = out Bits(8 bits)
    }
    val murax = Murax(MuraxConfig.default(withXip = true).copy(onChipRamSize = 8 kB))
    murax.io.asyncReset := False

    val mainClkBuffer = SB_GB()
    mainClkBuffer.USER_SIGNAL_TO_GLOBAL_BUFFER <> io.mainClk
    mainClkBuffer.GLOBAL_BUFFER_OUTPUT <> murax.io.mainClk

    val jtagClkBuffer = SB_GB()
    jtagClkBuffer.USER_SIGNAL_TO_GLOBAL_BUFFER <> io.jtag_tck
    jtagClkBuffer.GLOBAL_BUFFER_OUTPUT <> murax.io.jtag.tck

    io.led <> murax.io.gpioA.write(7 downto 0)

    murax.io.jtag.tdi <> io.jtag_tdi
    murax.io.jtag.tdo <> io.jtag_tdo
    murax.io.jtag.tms <> io.jtag_tms
    murax.io.gpioA.read <> 0
    murax.io.uart.txd <> io.uart_txd
    murax.io.uart.rxd <> io.uart_rxd



    val xip = new ClockingArea(murax.systemClockDomain) {
      RegNext(murax.io.xip.ss.asBool) <> io.spis

      val sclkIo = SB_IO_SCLK()
      sclkIo.PACKAGE_PIN <> io.sclk
      sclkIo.CLOCK_ENABLE := True

      sclkIo.OUTPUT_CLK := ClockDomain.current.readClockWire
      sclkIo.D_OUT_0 <> murax.io.xip.sclk.write(0)
      sclkIo.D_OUT_1 <> RegNext(murax.io.xip.sclk.write(1))

      val datas = for ((data, pin) <- (murax.io.xip.data, List(io.mosi, io.miso)).zipped) yield new Area {
        val dataIo = SB_IO_DATA()
        dataIo.PACKAGE_PIN := pin
        dataIo.CLOCK_ENABLE := True

        dataIo.OUTPUT_CLK := ClockDomain.current.readClockWire
        dataIo.OUTPUT_ENABLE <> data.writeEnable
        dataIo.D_OUT_0 <> data.write(0)
        dataIo.D_OUT_1 <> RegNext(data.write(1))

        dataIo.INPUT_CLK := ClockDomain.current.readClockWire
        data.read(0) := dataIo.D_IN_0
        data.read(1) := RegNext(dataIo.D_IN_1)
      }
    }

  }

  def main(args: Array[String]) {
    SpinalVerilog(Murax_iCE40_hx8k_breakout_board_xip())
  }
}

object MuraxDhrystoneReady{
  def main(args: Array[String]) {
    SpinalVerilog(Murax(MuraxConfig.fast.copy(onChipRamSize = 256 kB)))
  }
}

object MuraxDhrystoneReadyMulDivStatic{
  def main(args: Array[String]) {
    SpinalVerilog({
      val config = MuraxConfig.fast.copy(onChipRamSize = 256 kB)
      config.cpuPlugins += new MulPlugin
      config.cpuPlugins += new DivPlugin
      config.cpuPlugins.remove(config.cpuPlugins.indexWhere(_.isInstanceOf[BranchPlugin]))
      config.cpuPlugins +=new BranchPlugin(
        earlyBranch = false,
        catchAddressMisaligned = false
      )
      config.cpuPlugins += new IBusSimplePlugin(
        resetVector = 0x80000000l,
        cmdForkOnSecondStage = true,
        cmdForkPersistence = false,
        prediction = STATIC,
        catchAccessFault = false,
        compressedGen = false
      )
      config.cpuPlugins.remove(config.cpuPlugins.indexWhere(_.isInstanceOf[LightShifterPlugin]))
      config.cpuPlugins += new FullBarrelShifterPlugin
      Murax(config)
    })
  }
}

//Will blink led and echo UART RX to UART TX   (in the verilator sim, type some text and press enter to send UART frame to the Murax RX pin)
object MuraxWithRamInit{
  def main(args: Array[String]) {
    SpinalVerilog(Murax(MuraxConfig.default.copy(onChipRamSize = 4 kB, onChipRamHexFile = "src/main/ressource/hex/muraxDemo.hex")))
  }
}

object Murax_arty{
  def main(args: Array[String]) {
    val hex = "src/main/c/murax/hello_world/build/hello_world.hex"
    SpinalVerilog(Murax(MuraxConfig.default(false).copy(coreFrequency = 100 MHz,onChipRamSize = 32 kB, onChipRamHexFile = hex)))
  }
}


object MuraxAsicBlackBox extends App{
  println("Warning this soc do not has any rom to boot on.")
  val config = SpinalConfig()
  config.addStandardMemBlackboxing(blackboxAll)
  config.generateVerilog(Murax(MuraxConfig.default()))
}

