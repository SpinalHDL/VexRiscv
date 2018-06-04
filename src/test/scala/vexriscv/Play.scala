package vexriscv

import spinal.core._
import spinal.lib.master
import vexriscv.ip.InstructionCacheConfig
import vexriscv.plugin._

object PlayGen extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new IBusCachedPlugin(
          config = InstructionCacheConfig(
            cacheSize = 16,
            bytePerLine = 4,
            wayCount = 1,
            addressWidth = 32,
            cpuDataWidth = 32,
            memDataWidth = 32,
            catchIllegalAccess = false,
            catchAccessFault = false,
            catchMemoryTranslationMiss = false,
            asyncTagMemory = false,
            twoCycleRam = false,
            preResetFlush = false
          )
        ),
        new FormalPlugin,
        new HaltOnExceptionPlugin,
        new PcManagerSimplePlugin(
          resetVector = 0x00000000l,
          relaxedPcCalculation = false
        ),
//        new IBusSimplePlugin(
//          interfaceKeepData = false,
//          catchAccessFault = false
//        ),
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
        new FullBarrelShifterPlugin,
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
          catchAddressMisaligned = true,
          prediction = NONE
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )
  //    Wrap with input/output registers
  def wrap(that : => VexRiscv) : Component = {
    val c = that
//    c.rework {
//      for (e <- c.getOrdredNodeIo) {
//        if (e.isInput) {
//          e.asDirectionLess()
//          e := RegNext(RegNext(in(cloneOf(e))))
//
//        } else {
//          e.asDirectionLess()
//          out(cloneOf(e)) := RegNext(RegNext(e))
//        }
//      }
//    }

    c.rework{
      c.config.plugins.foreach{
        case p : IBusCachedPlugin => {
          p.iBus.asDirectionLess().unsetName()
          val iBusNew = master(IBusSimpleBus(false)).setName("iBus")

          iBusNew.cmd.valid := p.iBus.cmd.valid
          iBusNew.cmd.pc := p.iBus.cmd.address
          p.iBus.cmd.ready := iBusNew.cmd.ready

          val pending = RegInit(False) clearWhen(iBusNew.rsp.ready) setWhen (iBusNew.cmd.fire)
          p.iBus.rsp.valid := iBusNew.rsp.ready & pending
          p.iBus.rsp.error := iBusNew.rsp.error
          p.iBus.rsp.data := iBusNew.rsp.inst
        }
        case _ =>
      }
    }
    c
  }
  SpinalConfig(
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind = spinal.core.SYNC,
      resetActiveLevel = spinal.core.HIGH
    ),
    inlineRom = true
  ).generateVerilog(wrap(cpu()))
}
