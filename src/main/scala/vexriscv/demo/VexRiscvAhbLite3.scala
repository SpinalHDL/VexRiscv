package vexriscv.demo


import spinal.core._
import spinal.lib._
import spinal.lib.bus.avalon.AvalonMM
import spinal.lib.com.jtag.Jtag
import spinal.lib.eda.altera.{InterruptReceiverTag, QSysify, ResetEmitterTag}
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/**
 * Created by spinalvm on 14.07.17.
 */
//class VexRiscvAvalon(debugClockDomain : ClockDomain) extends Component{
//
//}

//make clean run DBUS=SIMPLE_AHBLITE3 IBUS=SIMPLE_AHBLITE3 MMU=no CSR=no DEBUG_PLUGIN=STD

object VexRiscvAhbLite3{
  def main(args: Array[String]) {
    val report = SpinalConfig(mode = if(args.contains("--vhdl")) VHDL else Verilog).generate{

      //CPU configuration
      val cpuConfig = VexRiscvConfig(
        plugins = List(
          new IBusSimplePlugin(
            resetVector = 0x80000000l,
            cmdForkOnSecondStage = false,
            cmdForkPersistence = true,
            prediction = STATIC,
            catchAccessFault = false,
            compressedGen = false
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false
          ),
//          new IBusCachedPlugin(
//            config = InstructionCacheConfig(
//              cacheSize = 4096,
//              bytePerLine =32,
//              wayCount = 1,
//              addressWidth = 32,
//              cpuDataWidth = 32,
//              memDataWidth = 32,
//              catchIllegalAccess = true,
//              catchAccessFault = true,
//              catchMemoryTranslationMiss = true,
//              asyncTagMemory = false,
//              twoCycleRam = true
//            )
//            //            askMemoryTranslation = true,
//            //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
//            //              portTlbSize = 4
//            //            )
//          ),
//          new DBusCachedPlugin(
//            config = new DataCacheConfig(
//              cacheSize         = 4096,
//              bytePerLine       = 32,
//              wayCount          = 1,
//              addressWidth      = 32,
//              cpuDataWidth      = 32,
//              memDataWidth      = 32,
//              catchAccessError  = true,
//              catchIllegal      = true,
//              catchUnaligned    = true,
//              catchMemoryTranslationMiss = true
//            ),
//            memoryTranslatorPortConfig = null
//            //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
//            //              portTlbSize = 6
//            //            )
//          ),
          new StaticMemoryTranslatorPlugin(
            ioRange      = _(31 downto 28) === 0xF
          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = true
          ),
          new RegFilePlugin(
            regFileReadyKind = plugin.SYNC,
            zeroBoot = false
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false,
            executeInsertion = true
          ),
          new FullBarrelShifterPlugin,
          new MulPlugin,
          new DivPlugin,
          new HazardSimplePlugin(
            bypassExecute           = true,
            bypassMemory            = true,
            bypassWriteBack         = true,
            bypassWriteBackBuffer   = true,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
          new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = true
          ),
          new CsrPlugin(
            config = CsrPluginConfig(
              catchIllegalAccess = false,
              mvendorid      = null,
              marchid        = null,
              mimpid         = null,
              mhartid        = null,
              misaExtensionsInit = 66,
              misaAccess     = CsrAccess.NONE,
              mtvecAccess    = CsrAccess.NONE,
              mtvecInit      = 0x00000020l,
              mepcAccess     = CsrAccess.READ_WRITE,
              mscratchGen    = false,
              mcauseAccess   = CsrAccess.READ_ONLY,
              mbadaddrAccess = CsrAccess.READ_ONLY,
              mcycleAccess   = CsrAccess.NONE,
              minstretAccess = CsrAccess.NONE,
              ecallGen       = false,
              wfiGenAsWait         = false,
              ucycleAccess   = CsrAccess.NONE,
              uinstretAccess = CsrAccess.NONE
            )
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )

      //CPU instanciation
      val cpu = new VexRiscv(cpuConfig)

      //CPU modifications to be an AhbLite3 one
      cpu.rework {
        for (plugin <- cpuConfig.plugins) plugin match {
          case plugin: IBusSimplePlugin => {
            plugin.iBus.setAsDirectionLess() //Unset IO properties of iBus
            master(plugin.iBus.toAhbLite3Master()).setName("iBusAhbLite3")
          }
          case plugin: DBusSimplePlugin => {
            plugin.dBus.setAsDirectionLess()
            master(plugin.dBus.toAhbLite3Master(avoidWriteToReadHazard = true)).setName("dBusAhbLite3")
          }
//          case plugin: IBusCachedPlugin => {
//            plugin.iBus.setAsDirectionLess() //Unset IO properties of iBus
//            iBus = master(plugin.iBus.toAvalon())
//              .setName("iBusAvalon")
//              .addTag(ClockDomainTag(ClockDomain.current)) //Specify a clock domain to the iBus (used by QSysify)
//          }
//          case plugin: DBusCachedPlugin => {
//            plugin.dBus.setAsDirectionLess()
//            master(plugin.dBus.toAvalon())
//              .setName("dBusAvalon")
//              .addTag(ClockDomainTag(ClockDomain.current))
//          }
          case plugin: DebugPlugin if args.contains("--jtag")=> plugin.debugClockDomain {
            plugin.io.bus.setAsDirectionLess()
            val jtag = slave(new Jtag()).setName("jtag")
            jtag <> plugin.io.bus.fromJtag()
          }
          case _ =>
        }
      }
      cpu
    }
  }
}

