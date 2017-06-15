package VexRiscv

import VexRiscv.Plugin._
import VexRiscv.ip.{DataCacheConfig, InstructionCacheConfig}
import spinal.core._

/**
 * Created by spinalvm on 15.06.17.
 */
object GenSmallest extends App{
  SpinalVerilog(
    gen = new VexRiscv(
      config = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, true),
          new IBusSimplePlugin(
            interfaceKeepData = false,
            catchAccessFault = false
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false
          ),
          new CsrPlugin(CsrPluginConfig.smallest),
          new DecoderSimplePlugin(
            catchIllegalInstruction = false
          ),
          new RegFilePlugin(
            regFileReadyKind = Plugin.SYNC,
            zeroBoot = true
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
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = false,
            prediction = NONE
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )
    )
  )
}
