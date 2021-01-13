package vexriscv.demo

import spinal.core._
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/**
 * Created by spinalvm on 15.06.17.
 */

//make clean run DBUS=SIMPLE IBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no CUSTOM_CSR=yes
object GenCustomCsr extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new CustomCsrDemoPlugin,
        new CsrPlugin(CsrPluginConfig.small),
        new CustomCsrDemoGpioPlugin,
        new IBusSimplePlugin(
          resetVector = 0x00000000l,
          cmdForkOnSecondStage = false,
          cmdForkPersistence = false,
          prediction = NONE,
          catchInstructionAccess = false,
          compressedGen = false
        ),
        new DBusSimplePlugin(
          catchAddressMisaligned = false,
          catchInstructionAccess = false
        ),
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
        new FullBarrelShifterPlugin,
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new BranchPlugin(
          earlyBranch = false,
          catchAddressMisaligned = false
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )
  SpinalVerilog(cpu())
}
