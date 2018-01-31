package vexriscv.demo

import spinal.core._
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/**
 * Created by spinalvm on 15.06.17.
 */

//make clean run DBUS=SIMPLE IBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no
object GenCustomCsr extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new CustomCsrDemoPlugin,
        new CsrPlugin(CsrPluginConfig.small),
        new PcManagerSimplePlugin(
          resetVector = 0x00000000l,
          relaxedPcCalculation = false
        ),
        new IBusSimplePlugin(
          interfaceKeepData = false,
          catchAccessFault = false
        ),
        new DBusSimplePlugin(
          catchAddressMisaligned = false,
          catchAccessFault = false
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
        new FullBarrielShifterPlugin,
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
          catchAddressMisaligned = false,
          prediction = NONE
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )
  SpinalVerilog(cpu())
}
