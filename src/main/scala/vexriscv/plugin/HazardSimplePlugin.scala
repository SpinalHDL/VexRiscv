package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._


class HazardSimplePlugin(bypassExecute : Boolean = false,
                         bypassMemory: Boolean = false,
                         bypassWriteBack: Boolean = false,
                         bypassWriteBackBuffer : Boolean = false,
                         pessimisticUseSrc : Boolean = false,
                         pessimisticWriteRegFile : Boolean = false,
                         pessimisticAddressMatch : Boolean = false) extends Plugin[VexRiscv] {
  import Riscv._
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    val src0Hazard = False
    val src1Hazard = False

    def trackHazardWithStage(stage : Stage,bypassable : Boolean, runtimeBypassable : Stageable[Bool]): Unit ={
      val runtimeBypassableValue = if(runtimeBypassable != null) stage.input(runtimeBypassable) else True
      val addr0Match = if(pessimisticAddressMatch) True else stage.input(INSTRUCTION)(rdRange) === decode.input(INSTRUCTION)(rs1Range)
      val addr1Match = if(pessimisticAddressMatch) True else stage.input(INSTRUCTION)(rdRange) === decode.input(INSTRUCTION)(rs2Range)
      when(stage.arbitration.isValid && stage.input(REGFILE_WRITE_VALID)) {
        if (bypassable) {
          when(runtimeBypassableValue) {
            when(addr0Match) {
              decode.input(RS1) := stage.output(REGFILE_WRITE_DATA)
            }
            when(addr1Match) {
              decode.input(RS2) := stage.output(REGFILE_WRITE_DATA)
            }
          }
        }
      }
      when(stage.arbitration.isValid && (if(pessimisticWriteRegFile) True else stage.input(REGFILE_WRITE_VALID))) {
        when((Bool(!bypassable) || !runtimeBypassableValue)) {
          when(addr0Match) {
            src0Hazard := True
          }
          when(addr1Match) {
            src1Hazard := True
          }
        }
      }
    }


    val writeBackWrites = Flow(cloneable(new Bundle{
      val address = Bits(5 bits)
      val data = Bits(32 bits)
    }))
    writeBackWrites.valid := writeBack.output(REGFILE_WRITE_VALID) && writeBack.arbitration.isFiring
    writeBackWrites.address := writeBack.output(INSTRUCTION)(rdRange)
    writeBackWrites.data := writeBack.output(REGFILE_WRITE_DATA)
    val writeBackBuffer = writeBackWrites.stage()

    val addr0Match = if(pessimisticAddressMatch) True else writeBackBuffer.address === decode.input(INSTRUCTION)(rs1Range)
    val addr1Match = if(pessimisticAddressMatch) True else writeBackBuffer.address === decode.input(INSTRUCTION)(rs2Range)
    when(writeBackBuffer.valid) {
      if (bypassWriteBackBuffer) {
        when(addr0Match) {
          decode.input(RS1) := writeBackBuffer.data
        }
        when(addr1Match) {
          decode.input(RS2) := writeBackBuffer.data
        }
      } else {
        when(addr0Match) {
          src0Hazard := True
        }
        when(addr1Match) {
          src1Hazard := True
        }
      }
    }

    trackHazardWithStage(writeBack,bypassWriteBack,null)
    trackHazardWithStage(memory   ,bypassMemory   ,BYPASSABLE_MEMORY_STAGE)
    trackHazardWithStage(execute  ,bypassExecute  ,BYPASSABLE_EXECUTE_STAGE)


    if(!pessimisticUseSrc) {
      when(!decode.input(RS1_USE)) {
        src0Hazard := False
      }
      when(!decode.input(RS2_USE)) {
        src1Hazard := False
      }
    }

    when(decode.arbitration.isValid && (src0Hazard || src1Hazard)){
      decode.arbitration.haltItself := True
    }
  }
}
