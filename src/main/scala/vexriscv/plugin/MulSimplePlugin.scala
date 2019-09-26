package vexriscv.plugin
import vexriscv._
import vexriscv.VexRiscv
import spinal.core._

class MulSimplePlugin extends Plugin[VexRiscv]{
  object MUL_OPA extends Stageable(SInt(33 bits))
  object MUL_OPB extends Stageable(SInt(33 bits))
  object MUL     extends Stageable(Bits(64 bits))

  object IS_MUL  extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._


    val actions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> Bool(pipeline.stages.last == pipeline.execute),
      BYPASSABLE_MEMORY_STAGE  -> Bool(pipeline.stages.last == pipeline.memory),
      RS1_USE                  -> True,
      RS2_USE                  -> True,
      IS_MUL                   -> True
    )

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(IS_MUL, False)
    decoderService.add(List(
      MULX  -> actions
    ))

  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    // Prepare signed inputs for the multiplier in the next stage.
    // This will map them best to an FPGA DSP.
    execute plug new Area {
      import execute._
      val aSigned,bSigned = Bool
      val a,b = Bits(32 bit)

      a := input(SRC1)
      b := input(SRC2)
      switch(input(INSTRUCTION)(13 downto 12)) {
        is(B"01") {
          aSigned := True
          bSigned := True
        }
        is(B"10") {
          aSigned := True
          bSigned := False
        }
        default {
          aSigned := False
          bSigned := False
        }
      }

      insert(MUL_OPA) := ((aSigned ? a.msb | False) ## a).asSInt
      insert(MUL_OPB) := ((bSigned ? b.msb | False) ## b).asSInt
    }

    val injectionStage = if(pipeline.memory != null) pipeline.memory else pipeline.execute
    injectionStage plug new Area {
      import injectionStage._

      insert(MUL) := (input(MUL_OPA) * input(MUL_OPB))(63 downto 0).asBits
    }

    val memStage = stages.last
    memStage plug new Area {
      import memStage._

      when(arbitration.isValid && input(IS_MUL)){
        switch(input(INSTRUCTION)(13 downto 12)){
          is(B"00"){
            output(REGFILE_WRITE_DATA) := input(MUL)(31 downto 0)
          }
          is(B"01",B"10",B"11"){
            output(REGFILE_WRITE_DATA) := input(MUL)(63 downto 32)
          }
        }
      }
    }
  }
}
