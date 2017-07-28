package vexriscv.demo

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3Decoder, Apb3Gpio, Apb3}
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.com.jtag.Jtag
import spinal.lib.com.uart.Uart
import spinal.lib.io.TriStateArray
import vexriscv.plugin._
import vexriscv.{plugin, VexRiscvConfig, VexRiscv}

/**
 * Created by PIC32F_USER on 28/07/2017.
 *
 * Murax is a very light SoC which could work without any external component.
 * Should fit in ICE40 devices
 */


case class MuraxConfig(coreFrequency : HertzNumber,
                       onChipRamSize : BigInt)

object MuraxConfig{
  def default =  MuraxConfig(
      coreFrequency = 12 MHz,
      onChipRamSize  = 4 kB
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
   // val uart = master(Uart())
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
    // Also this counter will automaticly do a reset when the system boot.
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
    val cpu = new VexRiscv(
      config = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(
            resetVector = 0x00000000l,
            fastPcCalculation = true
          ),
          new IBusSimplePlugin(
            interfaceKeepData = false,
            catchAccessFault = false
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false
          ),
         // new CsrPlugin(CsrPluginConfig.smallest),
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
            executeInsertion = true
          ),
          new LightShifterPlugin,
          new DebugPlugin(debugClockDomain),
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
            catchAddressMisaligned = false,
            prediction = NONE
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )
    )

    var iBus : IBusSimpleBus = null
    var dBus : DBusSimpleBus = null
    var debugBus : DebugExtensionBus = null
    for(plugin <- cpu.plugins) plugin match{
      case plugin : IBusSimplePlugin => iBus = plugin.iBus
      case plugin : DBusSimplePlugin => dBus = plugin.dBus
   /*   case plugin : CsrPlugin        => {
        plugin.externalInterrupt := BufferCC(io.coreInterrupt)
        plugin.timerInterrupt := timerCtrl.io.interrupt
      }*/
      case plugin : DebugPlugin         => plugin.debugClockDomain{
        resetCtrl.systemReset setWhen(RegNext(plugin.io.resetOut))
        io.jtag <> plugin.io.bus.fromJtag()
      }
      case _ =>
    }


    val mainBus = SimpleBus()

    //Priority to dBus, cmd transactions can change on the fly !
    val cpuToMainBusBridge = new Area{
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

      val rspTarget = RegInit(False)
      when(mainBus.cmd.fire){
        rspTarget := dBus.cmd.valid
      }
      iBus.rsp.ready := mainBus.rsp.valid && !rspTarget
      iBus.rsp.inst  := mainBus.rsp.data
      iBus.rsp.error := False

      dBus.rsp.ready := mainBus.rsp.valid && rspTarget
      dBus.rsp.data  := mainBus.rsp.data
      dBus.rsp.error := False

      //Default states
     /* mainBus.cmd.ready := False
      mainBus.rsp.valid := False
      mainBus.rsp.payload.assignDontCare()*/
    }

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
    }



    val apbBridge = new Area{
      val bus = SimpleBus()
      val apb = Apb3(
        addressWidth = 20,
        dataWidth    = 32
      )
      val cmdStage = bus.cmd.halfPipe()
      val state = RegInit(False)
      cmdStage.ready := False

      apb.PSEL(0) := cmdStage.valid
      apb.PENABLE := state
      apb.PWRITE  := cmdStage.wr
      apb.PADDR   := cmdStage.address.resized
      apb.PWDATA  := cmdStage.data

      bus.rsp.valid := False
      bus.rsp.data  := apb.PRDATA
      when(!state){
        state := cmdStage.valid
      } otherwise{
        when(apb.PREADY){
          state := False
          bus.rsp.valid := !cmdStage.wr
          cmdStage.ready := True
        }
      }
    }

    val interconnect = new Area {
      def masterBus = mainBus
      val specification = List[(SimpleBus,SizeMapping)](
        ram.bus       -> (0x00000000l, onChipRamSize kB),
        apbBridge.bus -> (0xF0000000l, 1 MB)
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

    val apbDecoder = Apb3Decoder(
      master = apbBridge.apb,
      slaves = List(
        gpioACtrl.io.apb -> (0x00000, 4 kB)
      )
    )


  }
}



object Murax{
  def main(args: Array[String]) {
    SpinalVerilog(Murax(MuraxConfig.default))
  }
}