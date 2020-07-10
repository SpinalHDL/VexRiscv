package vexriscv.demo

import spinal.core._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.{Riscv, VexRiscv, VexRiscvConfig, plugin}
import vexriscv.plugin.{BranchPlugin, CsrAccess, CsrPlugin, CsrPluginConfig, DBusCachedPlugin, DecoderSimplePlugin, FullBarrelShifterPlugin, HazardSimplePlugin, IBusCachedPlugin, IntAluPlugin, MmuPlugin, MmuPortConfig, MulDivIterativePlugin, MulPlugin, RegFilePlugin, STATIC, SrcPlugin, YamlPlugin}

object OpenRoad extends App{

  def linuxConfig = VexRiscvConfig(
    withMemoryStage = true,
    withWriteBackStage = true,
    List(
      //      new SingleInstructionLimiterPlugin(),
      new IBusCachedPlugin(
        resetVector = 0,
        compressedGen = false,
        prediction = vexriscv.plugin.NONE,
        injectorStage = false,
        config = InstructionCacheConfig(
          cacheSize = 4096,
          bytePerLine = 64,
          wayCount = 1,
          addressWidth = 32,
          cpuDataWidth = 32,
          memDataWidth = 32,
          catchIllegalAccess = true,
          catchAccessFault = true,
          asyncTagMemory = true,
          twoCycleRam = false,
          twoCycleCache = true
        ),
        memoryTranslatorPortConfig = MmuPortConfig(
          portTlbSize = 4
        )
      ),
      new DBusCachedPlugin(
        dBusCmdMasterPipe = true,
        dBusCmdSlavePipe = true,
        dBusRspSlavePipe = true,
        config = new DataCacheConfig(
          cacheSize         = 4096,
          bytePerLine       = 64,
          wayCount          = 1,
          addressWidth      = 32,
          cpuDataWidth      = 32,
          memDataWidth      = 32,
          catchAccessError  = true,
          catchIllegal      = true,
          catchUnaligned    = true,
          asyncTagMemory = true,
          withLrSc = true,
          withAmo = true
          //          )
        ),
        memoryTranslatorPortConfig = MmuPortConfig(
          portTlbSize = 4
        )
      ),
      new DecoderSimplePlugin(
        catchIllegalInstruction = true
      ),
      new RegFilePlugin(
        regFileReadyKind = plugin.SYNC,
        zeroBoot = false,
        x0Init = true
      ),
      new IntAluPlugin,
      new SrcPlugin(
        separatedAddSub = false
      ),
      new FullBarrelShifterPlugin(earlyInjection = true),
      new HazardSimplePlugin(
        bypassExecute           = true,
        bypassMemory            = true,
        bypassWriteBack         = true,
        bypassWriteBackBuffer   = true,
        pessimisticUseSrc       = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      ),
      new MulDivIterativePlugin(
        genMul = true,
        genDiv = true,
        mulUnrollFactor = 32,
        divUnrollFactor = 8
      ),
      new CsrPlugin(CsrPluginConfig.openSbi(0,Riscv.misaToInt("imas")).copy(ebreakGen = false, mtvecAccess = CsrAccess.READ_WRITE)), //mtvecAccess read required by freertos

      new BranchPlugin(
        earlyBranch = true,
        catchAddressMisaligned = true,
        fenceiGenAsAJump = false
      ),
      new MmuPlugin(
        ioRange = (x => x(31))
      ),
      new YamlPlugin("cpu0.yaml")
    )
  )

  SpinalConfig().addStandardMemBlackboxing(blackboxAllWhatsYouCan).generateVerilog(new VexRiscv(linuxConfig).setDefinitionName("VexRiscvMsuI4D4"))
}
