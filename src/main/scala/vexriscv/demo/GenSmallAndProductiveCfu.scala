package vexriscv.demo

import spinal.core._
import vexriscv.plugin._
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/**
 * Created by spinalvm on 15.06.17.
 */
object GenSmallAndProductiveCfu extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new IBusSimplePlugin(
          resetVector = 0x80000000l,
          cmdForkOnSecondStage = false,
          cmdForkPersistence = false,
          prediction = NONE,
          catchAccessFault = false,
          compressedGen = false
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
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new LightShifterPlugin,
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
        new CfuPlugin(
          stageCount = 1,
          allowZeroLatency = true,
          encodings = List(
            CfuPluginEncoding (
              instruction = M"-------------------------0001011",
              functionId = List(14 downto 12),
              input2Kind = CfuPlugin.Input2Kind.RS
            )
          ),
          busParameter = CfuBusParameter(
            CFU_VERSION = 0,
            CFU_INTERFACE_ID_W = 0,
            CFU_FUNCTION_ID_W = 3,
            CFU_REORDER_ID_W = 0,
            CFU_REQ_RESP_ID_W = 0,
            CFU_INPUTS = 2,
            CFU_INPUT_DATA_W = 32,
            CFU_OUTPUTS = 1,
            CFU_OUTPUT_DATA_W = 32,
            CFU_FLOW_REQ_READY_ALWAYS = false,
            CFU_FLOW_RESP_READY_ALWAYS = false,
            CFU_WITH_STATUS = true,
            CFU_RAW_INSN_W = 32,
            CFU_CFU_ID_W = 4,
            CFU_STATE_INDEX_NUM = 5
          )
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )

  SpinalVerilog(cpu())
}
