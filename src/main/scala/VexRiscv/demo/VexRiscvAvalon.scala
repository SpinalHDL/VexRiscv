package VexRiscv.demo

import VexRiscv.Plugin._
import VexRiscv.{VexRiscv, Plugin, VexRiscvConfig}
import VexRiscv.ip.{DataCacheConfig, InstructionCacheConfig}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.Apb3
import spinal.lib.bus.amba4.axi.{Axi4Shared, Axi4ReadOnly}

/**
 * Created by spinalvm on 14.07.17.
 */
//class VexRiscvAvalon(debugClockDomain : ClockDomain) extends Component{
//
//}


object VexRiscvAvalon{
  def main(args: Array[String]) {
    SpinalVhdl{
      val configLight = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, false),
          new IBusCachedPlugin(
            config = InstructionCacheConfig(
              cacheSize = 4096,
              bytePerLine =32,
              wayCount = 1,
              wrappedMemAccess = true,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchIllegalAccess = true,
              catchAccessFault = true,
              catchMemoryTranslationMiss = true,
              asyncTagMemory = false,
              twoStageLogic = true
            )
            //            askMemoryTranslation = true,
            //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
            //              portTlbSize = 4
            //            )
          ),
          new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize         = 4096,
              bytePerLine       = 32,
              wayCount          = 1,
              addressWidth      = 32,
              cpuDataWidth      = 32,
              memDataWidth      = 32,
              catchAccessError  = true,
              catchIllegal      = true,
              catchUnaligned    = true,
              catchMemoryTranslationMiss = true
            ),
            memoryTranslatorPortConfig = null
            //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
            //              portTlbSize = 6
            //            )
          ),
          new StaticMemoryTranslatorPlugin(
            ioRange      = _(31 downto 28) === 0xF
          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = true
          ),
          new RegFilePlugin(
            regFileReadyKind = Plugin.SYNC,
            zeroBoot = false
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false,
            executeInsertion = true
          ),
          new FullBarrielShifterPlugin,
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
            catchAddressMisaligned = true,
            prediction = STATIC
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
              wfiGen         = false,
              ucycleAccess   = CsrAccess.NONE
            )
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )

      val cpu = new VexRiscv(configLight)

      cpu.setDefinitionName("VexRiscvAvalon")
      cpu.rework {
        for (plugin <- configLight.plugins) plugin match {
          case plugin: IBusCachedPlugin => {
            plugin.iBus.asDirectionLess()
            master(plugin.iBus.toAvalon()).setName("iBusAvalon")
          }
          case plugin: DBusCachedPlugin => {
            plugin.dBus.asDirectionLess()
            master(plugin.dBus.toAvalon()).setName("dBusAvalon")
          }
          case plugin: DebugPlugin => {
            plugin.io.bus.asDirectionLess()
            slave(plugin.io.bus.fromAvalon()).setName("debugBusAvalon")
          }
          case _ =>
        }
      }
      cpu
    }
  }
}