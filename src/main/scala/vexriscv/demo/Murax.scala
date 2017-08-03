package vexriscv.demo

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3SlaveFactory, Apb3Decoder, Apb3Gpio, Apb3}
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.com.jtag.Jtag
import spinal.lib.com.uart._
import spinal.lib.io.TriStateArray
import spinal.lib.misc.{InterruptCtrl, Timer, Prescaler}
import spinal.lib.soc.pinsec.{PinsecTimerCtrlExternal, PinsecTimerCtrl}
import vexriscv.plugin._
import vexriscv.{plugin, VexRiscvConfig, VexRiscv}

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
                       onChipRamSize : BigInt,
                       onChipRamHexFile : String,
                       bypassExecute : Boolean,
                       bypassMemory: Boolean,
                       bypassWriteBack: Boolean,
                       bypassWriteBackBuffer : Boolean,
                       pipelineDBus : Boolean,
                       pipelineMainBus : Boolean,
                       pipelineApbBridge : Boolean){
  require(pipelineApbBridge || pipelineMainBus, "At least pipelineMainBus or pipelineApbBridge should be enable to avoid wipe transactions")
}

object MuraxConfig{
  def default =  MuraxConfig(
      coreFrequency         = 12 MHz,
      onChipRamSize         = 8 kB,
      onChipRamHexFile      = null,
      bypassExecute         = false,
      bypassMemory          = false,
      bypassWriteBack       = false,
      bypassWriteBackBuffer = false,
      pipelineDBus          = true,
      pipelineMainBus       = false,
      pipelineApbBridge     = true
  )
}

case class SimpleBusCmd() extends Bundle{
  val wr = Bool
  val address = UInt(32 bits)
  val data = Bits(32 bit)
  val mask = Bits(4 bit)
}

case class SimpleBusRsp() extends Bundle{
  val data = Bits(32 bit)
}


case class SimpleBus() extends Bundle with IMasterSlave {
  val cmd = Stream(SimpleBusCmd())
  val rsp = Flow(SimpleBusRsp())

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
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
    val gpioA = master(TriStateArray(32 bits))
    val uart = master(Uart())
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

    //Instanciate the CPU
    val cpu = new VexRiscv(
      config = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(
            resetVector = 0x00000000l,
            relaxedPcCalculation = true
          ),
          new IBusSimplePlugin(
            interfaceKeepData = false,
            catchAccessFault = false
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false,
            earlyInjection = false
          ),
          new CsrPlugin(CsrPluginConfig.smallest),
          new DecoderSimplePlugin(
            catchIllegalInstruction = false
          ),
          new RegFilePlugin(
            regFileReadyKind = plugin.SYNC,
            zeroBoot = true
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false,
            executeInsertion = false
          ),
          new LightShifterPlugin,
          new DebugPlugin(debugClockDomain),
          new HazardSimplePlugin(
            bypassExecute = bypassExecute,
            bypassMemory = bypassMemory,
            bypassWriteBack = bypassWriteBack,
            bypassWriteBackBuffer = bypassWriteBackBuffer,
            pessimisticUseSrc = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = false,
            prediction = NONE
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )
    )

    //Checkout plugins used to instanciate the CPU to connect them to the SoC
    val timerInterrupt = False
    val externalInterrupt = False
    var iBus : IBusSimpleBus = null
    var dBus : DBusSimpleBus = null
    var debugBus : DebugExtensionBus = null
    for(plugin <- cpu.plugins) plugin match{
      case plugin : IBusSimplePlugin => iBus = plugin.iBus
      case plugin : DBusSimplePlugin => {
        if(!pipelineDBus)
          dBus = plugin.dBus
        else {
          dBus = cloneOf(plugin.dBus)
          dBus.cmd << plugin.dBus.cmd.halfPipe()
          dBus.rsp <> plugin.dBus.rsp
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


    val mainBus = SimpleBus()

    //Arbiter of the cpu dBus/iBus to drive the mainBus
    //Priority to dBus, !! cmd transactions can change on the fly !!
    val mainBusArbiter = new Area{
      mainBus.cmd.valid   := iBus.cmd.valid || dBus.cmd.valid
      mainBus.cmd.wr      := dBus.cmd.valid && dBus.cmd.wr
      mainBus.cmd.address := dBus.cmd.valid ? dBus.cmd.address | iBus.cmd.pc
      mainBus.cmd.data    := dBus.cmd.data
      mainBus.cmd.mask    := dBus.cmd.size.mux(
        0 -> B"0001",
        1 -> B"0011",
        default -> B"1111"
      ) |<< dBus.cmd.address(1 downto 0)
      iBus.cmd.ready := mainBus.cmd.ready && !dBus.cmd.valid
      dBus.cmd.ready := mainBus.cmd.ready


      val rspPending = RegInit(False) clearWhen(mainBus.rsp.valid)
      val rspTarget = RegInit(False)
      when(mainBus.cmd.fire && !mainBus.cmd.wr){
        rspTarget  := dBus.cmd.valid
        rspPending := True
      }

      when(rspPending && !mainBus.rsp.valid){
        iBus.cmd.ready := False
        dBus.cmd.ready := False
        mainBus.cmd.valid := False
      }

      iBus.rsp.ready := mainBus.rsp.valid && !rspTarget
      iBus.rsp.inst  := mainBus.rsp.data
      iBus.rsp.error := False

      dBus.rsp.ready := mainBus.rsp.valid && rspTarget
      dBus.rsp.data  := mainBus.rsp.data
      dBus.rsp.error := False
    }

    //Create an SimpleBus mapped RAM
    val ram = new Area{
      val bus = SimpleBus()
      val ram = Mem(Bits(32 bits), onChipRamSize / 4)
      bus.rsp.valid := RegNext(bus.cmd.fire && !bus.cmd.wr) init(False)
      bus.rsp.data := ram.readWriteSync(
        address = (bus.cmd.address >> 2).resized,
        data  = bus.cmd.data,
        enable  = bus.cmd.valid,
        write  = bus.cmd.wr,
        mask  = bus.cmd.mask
      )
      bus.cmd.ready := True

      if(onChipRamHexFile != null){
        def readHexFile(path : String, callback : (Int, Int) => Unit): Unit ={
          import scala.io.Source
          def hToI(that : String, start : Int, size : Int) = Integer.parseInt(that.substring(start,start + size), 16)

          var offset = 0
          for (line <- Source.fromFile(path).getLines) {
            if (line.charAt(0) == ':'){
              val byteCount = hToI(line, 1, 2)
              val nextAddr = hToI(line, 3, 4) + offset
              val key = hToI(line, 7, 2)
              key match {
                case 0 =>
                  for(i <- 0 until byteCount){
                    callback(nextAddr + i, hToI(line, 9 + i * 2, 2))
                  }
                case 2 =>
                  offset = hToI(line, 9, 4) << 4
                case 4 =>
                  offset = hToI(line, 9, 4) << 16
                case 3 =>
                case 1 =>
              }
            }
          }
        }

        val initContent = Array.fill[BigInt](ram.wordCount)(0)
        readHexFile(onChipRamHexFile,(address,data) => {
          initContent(address >> 2) |= BigInt(data) << ((address & 3)*8)
        })
        ram.initBigInt(initContent)
      }
    }



    //Bridge simpleBus to apb
    val apbBridge = new Area{
      val simpleBus = SimpleBus()
      val apb = Apb3(
        addressWidth = 20,
        dataWidth    = 32
      )
      val simpleBusStage = SimpleBus()
      simpleBusStage.cmd << (if(pipelineApbBridge) simpleBus.cmd.halfPipe() else simpleBus.cmd)
      simpleBusStage.rsp >-> simpleBus.rsp

      val state = RegInit(False)
      simpleBusStage.cmd.ready := False

      apb.PSEL(0) := simpleBusStage.cmd.valid
      apb.PENABLE := state
      apb.PWRITE  := simpleBusStage.cmd.wr
      apb.PADDR   := simpleBusStage.cmd.address.resized
      apb.PWDATA  := simpleBusStage.cmd.data

      simpleBusStage.rsp.valid := False
      simpleBusStage.rsp.data  := apb.PRDATA
      when(!state){
        state := simpleBusStage.cmd.valid
      } otherwise{
        when(apb.PREADY){
          state := False
          simpleBusStage.rsp.valid := !simpleBusStage.cmd.wr
          simpleBusStage.cmd.ready := True
        }
      }
    }

    //Connect the mainBus to all slaves (ram, apbBridge)
    val mainBusDecoder = new Area {
      val masterBus = SimpleBus()
      if(!pipelineMainBus) {
        masterBus.cmd << mainBus.cmd
        masterBus.rsp >> mainBus.rsp
      } else {
        masterBus.cmd <-< mainBus.cmd
        masterBus.rsp >> mainBus.rsp
      }

      val specification = List[(SimpleBus,SizeMapping)](
        ram.bus             -> (0x00000000l, onChipRamSize kB),
        apbBridge.simpleBus -> (0xF0000000l, 1 MB)
      )
      
      val slaveBuses = specification.map(_._1)
      val memorySpaces = specification.map(_._2)

      val hits = for((slaveBus, memorySpace) <- specification) yield {
        val hit = memorySpace.hit(masterBus.cmd.address)
        slaveBus.cmd.valid   := masterBus.cmd.valid && hit
        slaveBus.cmd.payload := masterBus.cmd.payload
        hit
      }
      masterBus.cmd.ready := (hits,slaveBuses).zipped.map(_ && _.cmd.ready).orR

      val rspPending = RegInit(False) clearWhen(masterBus.rsp.valid) setWhen(masterBus.cmd.fire && !masterBus.cmd.wr)
      val rspSourceId = RegNextWhen(OHToUInt(hits), masterBus.cmd.fire)
      masterBus.rsp.valid   := slaveBuses.map(_.rsp.valid).orR
      masterBus.rsp.payload := slaveBuses.map(_.rsp.payload).read(rspSourceId)

      when(rspPending && !masterBus.rsp.valid) { //Only one pending read request is allowed
        masterBus.cmd.ready := False
        slaveBuses.foreach(_.cmd.valid := False)
      }
    }

    val gpioACtrl = Apb3Gpio(
      gpioWidth = 32
    )
    io.gpioA <> gpioACtrl.io.gpio

    val uartCtrlConfig = UartCtrlMemoryMappedConfig(
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

    val uartCtrl = Apb3UartCtrl(uartCtrlConfig)
    uartCtrl.io.uart <> io.uart
    externalInterrupt setWhen(uartCtrl.io.interrupt)

    val timer = new Area{
      val apb = Apb3(
        addressWidth = 8,
        dataWidth = 32
      )

      val prescaler = Prescaler(16)
      val timerA,timerB = Timer(16)

      val busCtrl = Apb3SlaveFactory(apb)
      val prescalerBridge = prescaler.driveFrom(busCtrl,0x00)

      val timerABridge = timerA.driveFrom(busCtrl,0x40)(
        ticks  = List(True, prescaler.io.overflow),
        clears = List(timerA.io.full)
      )

      val timerBBridge = timerB.driveFrom(busCtrl,0x50)(
        ticks  = List(True, prescaler.io.overflow),
        clears = List(timerB.io.full)
      )

      val interruptCtrl = InterruptCtrl(2)
      val interruptCtrlBridge = interruptCtrl.driveFrom(busCtrl,0x10)
      interruptCtrl.io.inputs(0) := timerA.io.full
      interruptCtrl.io.inputs(1) := timerB.io.full
      timerInterrupt setWhen(interruptCtrl.io.pendings.orR)
    }



    val apbDecoder = Apb3Decoder(
      master = apbBridge.apb,
      slaves = List(
        gpioACtrl.io.apb -> (0x00000, 4 kB),
        uartCtrl.io.apb  -> (0x10000, 4 kB),
        timer.apb        -> (0x20000, 4 kB)
      )
    )
  }
}



object Murax{
  def main(args: Array[String]) {
    SpinalVerilog(Murax(MuraxConfig.default))
  }
}


//Will blink led and echo UART RX to UART TX   (in the verilator sim, type some text and press enter to send UART frame to the Murax RX pin)
object MuraxWithRamInit{
  def main(args: Array[String]) {
    SpinalVerilog(Murax(MuraxConfig.default.copy(onChipRamSize = 4 kB, onChipRamHexFile = "src/main/ressource/hex/muraxDemo.hex")))
  }
}