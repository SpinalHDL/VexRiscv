package SpinalRiscv.demo


import SpinalRiscv.Plugin._
import SpinalRiscv._
import SpinalRiscv.ip.{DataCacheConfig, InstructionCacheConfig}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.com.jtag.Jtag
import spinal.lib.com.uart.{Uart, UartCtrlGenerics, UartCtrlMemoryMappedConfig, Apb3UartCtrl}
import spinal.lib.graphic.RgbConfig
import spinal.lib.graphic.vga.{Vga, Axi4VgaCtrlGenerics, Axi4VgaCtrl}
import spinal.lib.io.TriStateArray
import spinal.lib.memory.sdram._
import spinal.lib.soc.pinsec.{PinsecTimerCtrlExternal, PinsecTimerCtrl}
import spinal.lib.system.debugger.{JtagAxi4SharedDebugger, SystemDebuggerConfig}


case class BrieyConfig(axiFrequency : HertzNumber,
                        onChipRamSize : BigInt,
                        sdramLayout: SdramLayout,
                        sdramTimings: SdramTimings)

object BrieyConfig{
  def default = {
    val config = BrieyConfig(
      axiFrequency = 50 MHz,
      onChipRamSize  = 4 kB,
      sdramLayout = IS42x320D.layout,
      sdramTimings = IS42x320D.timingGrade7
    )
    config
  }
}



class Briey(config: BrieyConfig) extends Component{

  //Legacy constructor
  def this(axiFrequency: HertzNumber) {
    this(BrieyConfig.default.copy(axiFrequency = axiFrequency))
  }

  import config._
  val debug = true
  val interruptCount = 4
  def vgaRgbConfig = RgbConfig(5,6,5)

  val io = new Bundle{
    //Clocks / reset
    val asyncReset = in Bool
    val axiClk     = in Bool
    val vgaClk     = in Bool

    //Main components IO
    val jtag       = slave(Jtag())
    val sdram      = master(SdramInterface(sdramLayout))

    //Peripherals IO
    val gpioA      = master(TriStateArray(32 bits))
    val gpioB      = master(TriStateArray(32 bits))
    val uart       = master(Uart())
    val vga        = master(Vga(vgaRgbConfig))
    val timerExternal = in(PinsecTimerCtrlExternal())
  }

  val resetCtrlClockDomain = ClockDomain(
    clock = io.axiClk,
    config = ClockDomainConfig(
      resetKind = BOOT
    )
  )

  val resetCtrl = new ClockingArea(resetCtrlClockDomain) {
    val axiResetUnbuffered  = False
    val coreResetUnbuffered = False

    //Implement an counter to keep the reset axiResetOrder high 64 cycles
    // Also this counter will automaticly do a reset when the system boot.
    val axiResetCounter = Reg(UInt(6 bits)) init(0)
    when(axiResetCounter =/= U(axiResetCounter.range -> true)){
      axiResetCounter := axiResetCounter + 1
      axiResetUnbuffered := True
    }
    when(BufferCC(io.asyncReset)){
      axiResetCounter := 0
    }

    //When an axiResetOrder happen, the core reset will as well
    when(axiResetUnbuffered){
      coreResetUnbuffered := True
    }

    //Create all reset used later in the design
    val axiReset  = RegNext(axiResetUnbuffered)
    val coreReset = RegNext(coreResetUnbuffered)
    val vgaReset  = BufferCC(axiResetUnbuffered)
  }

  val axiClockDomain = ClockDomain(
    clock = io.axiClk,
    reset = resetCtrl.axiReset,
    frequency = FixedFrequency(axiFrequency) //The frequency information is used by the SDRAM controller
  )

  val coreClockDomain = ClockDomain(
    clock = io.axiClk,
    reset = resetCtrl.coreReset
  )

  val vgaClockDomain = ClockDomain(
    clock = io.vgaClk,
    reset = resetCtrl.vgaReset
  )

  val jtagClockDomain = ClockDomain(
    clock = io.jtag.tck
  )

  val axi = new ClockingArea(axiClockDomain) {
    val core = new ClockingArea(coreClockDomain){
      val configLight = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, false),
//          new IBusSimplePlugin(
//            interfaceKeepData = false,
//            catchAccessFault = false
//          ),
          new IBusCachedPlugin(
            config = InstructionCacheConfig(
              cacheSize = 4096,
              bytePerLine =32,
              wayCount = 1,
              wrappedMemAccess = true,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchIllegalAccess = false,
              catchAccessFault = false,
              catchMemoryTranslationMiss = false,
              asyncTagMemory = false,
              twoStageLogic = true
            )
//            askMemoryTranslation = true,
//            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
//              portTlbSize = 4
//            )
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false
          ),
//          new DBusCachedPlugin(
//            config = new DataCacheConfig(
//              cacheSize         = 4096,
//              bytePerLine       = 32,
//              wayCount          = 1,
//              addressWidth      = 32,
//              cpuDataWidth      = 32,
//              memDataWidth      = 32,
//              catchAccessError  = false,
//              catchIllegal      = false,
//              catchUnaligned    = false,
//              catchMemoryTranslationMiss = false
//            ),
//            memoryTranslatorPortConfig = null
//            //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
//            //              portTlbSize = 6
//            //            )
//          ),
//          new StaticMemoryTranslatorPlugin(
//            ioRange      = _(31 downto 28) === 0xF
//          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = false
          ),
          new RegFilePlugin(
            regFileReadyKind = Plugin.SYNC,
            zeroBoot = false
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false
          ),
          new LightShifterPlugin,
          new HazardSimplePlugin(
            bypassExecute           = false,
            bypassMemory            = false,
            bypassWriteBack         = false,
            bypassWriteBackBuffer   = false,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
          new DebugPlugin(axiClockDomain),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = false,
            prediction = NONE
          )
        )
      )

      val cpu = new VexRiscv(configLight)
      var iBus : Axi4Bus = null
      var dBus : Axi4Bus = null
      var debugBus : Apb3 = null
      for(plugin <- configLight.plugins) plugin match{
        case plugin : IBusSimplePlugin => iBus = plugin.iBus.toAxi4ReadOnly()
        case plugin : IBusCachedPlugin => iBus = plugin.iBus.toAxi4ReadOnly()
        case plugin : DBusSimplePlugin => dBus = plugin.dBus.toAxi4Shared()
        case plugin : DBusCachedPlugin => dBus = plugin.dBus.toAxi4Shared()
        case plugin : DebugPlugin => {
          resetCtrl.coreResetUnbuffered setWhen(plugin.io.resetOut)
          debugBus = plugin.io.bus.toApb3()
        }
        case _ =>
      }
    }

    val ram = Axi4SharedOnChipRam(
      dataWidth = 32,
      byteCount = onChipRamSize,
      idWidth = 4
    )

    val sdramCtrl = Axi4SharedSdramCtrl(
      axiDataWidth = 32,
      axiIdWidth   = 4,
      layout       = sdramLayout,
      timing       = sdramTimings,
      CAS          = 3
    )

    val jtagCtrl = JtagAxi4SharedDebugger(SystemDebuggerConfig(
      memAddressWidth = 32,
      memDataWidth    = 32,
      remoteCmdWidth  = 1
    ))


    val apbBridge = Axi4SharedToApb3Bridge(
      addressWidth = 20,
      dataWidth    = 32,
      idWidth      = 4
    )

    val gpioACtrl = Apb3Gpio(
      gpioWidth = 32
    )
    val gpioBCtrl = Apb3Gpio(
      gpioWidth = 32
    )
    val timerCtrl = PinsecTimerCtrl()

    val uartCtrlConfig = UartCtrlMemoryMappedConfig(
      uartCtrlConfig = UartCtrlGenerics(
        dataWidthMax      = 8,
        clockDividerWidth = 20,
        preSamplingSize   = 1,
        samplingSize      = 5,
        postSamplingSize  = 2
      ),
      txFifoDepth = 16,
      rxFifoDepth = 16
    )
    val uartCtrl = Apb3UartCtrl(uartCtrlConfig)


    val vgaCtrlConfig = Axi4VgaCtrlGenerics(
      axiAddressWidth = 32,
      axiDataWidth    = 32,
      burstLength     = 8,
      frameSizeMax    = 2048*1512*2,
      fifoSize        = 512,
      rgbConfig       = vgaRgbConfig,
      vgaClock        = vgaClockDomain
    )
    val vgaCtrl = Axi4VgaCtrl(vgaCtrlConfig)

    val axiCrossbar = Axi4CrossbarFactory()

    axiCrossbar.addSlaves(
      ram.io.axi       -> (0x00000000L,   onChipRamSize),
      sdramCtrl.io.axi -> (0x40000000L,   sdramLayout.capacity),
      apbBridge.io.axi -> (0xF0000000L,   1 MB)
    )

    axiCrossbar.addConnections(
      core.iBus       -> List(ram.io.axi, sdramCtrl.io.axi),
      core.dBus       -> List(ram.io.axi, sdramCtrl.io.axi, apbBridge.io.axi),
      jtagCtrl.io.axi -> List(ram.io.axi, sdramCtrl.io.axi, apbBridge.io.axi),
      vgaCtrl.io.axi  -> List(                              sdramCtrl.io.axi)
    )


    axiCrossbar.addPipelining(apbBridge.io.axi,(crossbar,bridge) => {
      crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
      crossbar.writeData.halfPipe() >> bridge.writeData
      crossbar.writeRsp             << bridge.writeRsp
      crossbar.readRsp              << bridge.readRsp
    })

    axiCrossbar.addPipelining(sdramCtrl.io.axi,(crossbar,ctrl) => {
      crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
      crossbar.writeData            >/-> ctrl.writeData
      crossbar.writeRsp              <<  ctrl.writeRsp
      crossbar.readRsp               <<  ctrl.readRsp
    })

    axiCrossbar.build()


    val apbDecoder = Apb3Decoder(
      master = apbBridge.io.apb,
      slaves = List(
        gpioACtrl.io.apb -> (0x00000, 4 kB),
        gpioBCtrl.io.apb -> (0x01000, 4 kB),
        uartCtrl.io.apb  -> (0x10000, 4 kB),
        timerCtrl.io.apb -> (0x20000, 4 kB),
        vgaCtrl.io.apb   -> (0x30000, 4 kB),
        core.debugBus    -> (0xF0000, 4 kB)
      )
    )
  }

  io.gpioA          <> axi.gpioACtrl.io.gpio
  io.gpioB          <> axi.gpioBCtrl.io.gpio
  io.timerExternal  <> axi.timerCtrl.io.external
  io.jtag           <> axi.jtagCtrl.io.jtag
  io.uart           <> axi.uartCtrl.io.uart
  io.sdram          <> axi.sdramCtrl.io.sdram
  io.vga            <> axi.vgaCtrl.io.vga
}


object Briey{
  def main(args: Array[String]) {
    val config = SpinalConfig().dumpWave()
    config.generateVerilog({
      val toplevel = new Briey(BrieyConfig.default)
      toplevel
    })
  }
}