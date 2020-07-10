package vexriscv.demo

import spinal.core.SpinalVerilog
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}
import vexriscv.plugin.{BranchPlugin, CsrPlugin, CsrPluginConfig, DBusSimplePlugin, DecoderSimplePlugin, DivPlugin, FullBarrelShifterPlugin, HazardSimplePlugin, IBusSimplePlugin, IntAluPlugin, LightShifterPlugin, MulPlugin, MulSimplePlugin, NONE, RegFilePlugin, SrcPlugin, YamlPlugin}

object GenTwoStage extends App{
  def cpu(withMulDiv : Boolean,
          bypass : Boolean,
          barrielShifter : Boolean) = new VexRiscv(
    config = VexRiscvConfig(
      withMemoryStage = false,
      withWriteBackStage = false,
      plugins = List(
        new IBusSimplePlugin(
          resetVector = 0x80000000l,
          cmdForkOnSecondStage = false,
          cmdForkPersistence = false,
          prediction = NONE,
          catchAccessFault = false,
          compressedGen = false,
          injectorStage = false
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
          regFileReadyKind = plugin.SYNC,
          readInExecute = true,
          zeroBoot = true,
          x0Init = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new HazardSimplePlugin(
          bypassExecute           = bypass,
          bypassMemory            = false,
          bypassWriteBack         = false,
          bypassWriteBackBuffer   = bypass,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new BranchPlugin(
          earlyBranch = true,
          catchAddressMisaligned = false
        ),
        new YamlPlugin("cpu0.yaml")
      ) ++ (if(!withMulDiv) Nil else List(
        new MulSimplePlugin,
        new DivPlugin
      )) ++ List(if(!barrielShifter)
        new LightShifterPlugin
      else
        new FullBarrelShifterPlugin(
          earlyInjection = true
        )
      )
    )
  )

  SpinalVerilog(cpu(false,false,false))
}
