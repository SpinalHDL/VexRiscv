package vexriscv.demo

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import spinal.core._

/**
  * Created by spinalvm on 15.06.17.
  */
object FormalSimple extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new FormalPlugin,
        new HaltOnExceptionPlugin,
        new IBusSimplePlugin(
          resetVector = 0x00000000l,
          relaxedPcCalculation = false,
          prediction = NONE,
          catchAccessFault = false,
          compressedGen = true
        ),

        new DBusSimplePlugin(
          catchAddressMisaligned = true,
          catchAccessFault = false
        ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true,
          forceLegalInstructionComputation = true
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
          catchAddressMisaligned = true
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )
  SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = spinal.core.SYNC,
      resetActiveLevel = spinal.core.HIGH
    )
  ).generateVerilog(cpu())
}
