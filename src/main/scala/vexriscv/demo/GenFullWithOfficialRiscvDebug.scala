package vexriscv.demo

import spinal.core._
import spinal.lib.cpu.riscv.debug.DebugTransportModuleParameter
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/**
 * This an example of VexRiscv configuration which can run the official RISC-V debug.
 * You can for instance :
 * - sbt "runMain vexriscv.demo.GenFullWithOfficialRiscvDebug"
 * - cd src/test/cpp/regression
 * - make IBUS=CACHED IBUS_DATA_WIDTH=32 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=32 DBUS_STORE_DATA_WIDTH=32 MUL=yes DIV=yes SUPERVISOR=no CSR=yes DEBUG_PLUGIN=RISCV WITH_RISCV_REF=no DEBUG_PLUGIN_EXTERNAL=yes DEBUG_PLUGIN=no VEXRISCV_JTAG=yes
 *
 * This will run a simulation of the CPU which wait for a tcp-jtag connection from openocd.
 * That con connection can be done via openocd :
 * - src/openocd -f config.tcl
 *
 * Were config.tcl is the following :
 *
 * ##############################################
 * interface jtag_tcp
 * adapter speed 5000
 *
 * set _CHIPNAME riscv
 * jtag newtap $_CHIPNAME cpu -irlen 5 -expected-id 0x10002FFF
 *
 * set _TARGETNAME $_CHIPNAME.cpu
 *
 * target create $_TARGETNAME.0 riscv -chain-position $_TARGETNAME
 *
 * init
 * halt
 *
 * echo "Ready for Remote Connections"
 * ##############################################
 */

object GenFullWithOfficialRiscvDebug extends App{
  def config = VexRiscvConfig(
    plugins = List(
      new IBusCachedPlugin(
        prediction = DYNAMIC,
        config = InstructionCacheConfig(
          cacheSize = 4096,
          bytePerLine =32,
          wayCount = 1,
          addressWidth = 32,
          cpuDataWidth = 32,
          memDataWidth = 32,
          catchIllegalAccess = true,
          catchAccessFault = true,
          asyncTagMemory = false,
          twoCycleRam = true,
          twoCycleCache = true
        ),
        memoryTranslatorPortConfig = MmuPortConfig(
          portTlbSize = 4
        )
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
          catchUnaligned    = true
        ),
        memoryTranslatorPortConfig = MmuPortConfig(
          portTlbSize = 6
        )
      ),
      new MmuPlugin(
        virtualRange = _(31 downto 28) === 0xC,
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
      new HazardSimplePlugin(
        bypassExecute           = true,
        bypassMemory            = true,
        bypassWriteBack         = true,
        bypassWriteBackBuffer   = true,
        pessimisticUseSrc       = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      ),
      new MulPlugin,
      new DivPlugin,
      new CsrPlugin(CsrPluginConfig.small(0x80000020l).copy(withPrivilegedDebug = true)),
      new EmbeddedRiscvJtag(
        p = DebugTransportModuleParameter(
          addressWidth = 7,
          version = 1,
          idle = 7
        ),
        debugCd = ClockDomain.current.copy(reset = Bool().setName("debugReset")),
        withTunneling = false,
        withTap = true
      ),
      new BranchPlugin(
        earlyBranch = false,
        catchAddressMisaligned = true
      ),
      new YamlPlugin("cpu0.yaml")
    )
  )

  def cpu() = new VexRiscv(config)

  SpinalVerilog(cpu())
}
