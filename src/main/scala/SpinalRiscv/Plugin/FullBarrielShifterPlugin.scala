package SpinalRiscv.Plugin

import SpinalRiscv._
import spinal.core._
import spinal.lib.Reverse



class FullBarrielShifterPlugin extends Plugin[VexRiscv]{
  object ShiftCtrlEnum extends SpinalEnum(binarySequential){
    val DISABLE, SLL, SRL, SRA = newElement()
  }

  object SHIFT_CTRL extends Stageable(ShiftCtrlEnum())
  object SHIFT_RIGHT extends Stageable(Bits(32 bits))

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._



    val immediateActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> True,
      REG1_USE                 -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> True,
      REG1_USE                 -> True,
      REG2_USE                 -> True
    )

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(SHIFT_CTRL, ShiftCtrlEnum.DISABLE)
    decoderService.add(List(
      SLL  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SLL)),
      SRL  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRL)),
      SRA  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRA))
    ))

    decoderService.add(List(
      SLLI  -> (immediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SLL)),
      SRLI  -> (immediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRL)),
      SRAI  -> (immediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRA))
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    execute plug new Area{
      import execute._
      val amplitude  = input(SRC2)(4 downto 0).asUInt
      val reversed   = Mux(input(SHIFT_CTRL) === ShiftCtrlEnum.SLL, Reverse(input(SRC1)), input(SRC1))
      insert(SHIFT_RIGHT) := (Cat(input(SHIFT_CTRL) === ShiftCtrlEnum.SRA & reversed.msb, reversed).asSInt >> amplitude)(31 downto 0).asBits
    }

    memory plug new Area{
      import memory._
      switch(input(SHIFT_CTRL)){
        is(ShiftCtrlEnum.SLL){
          output(REGFILE_WRITE_DATA) := Reverse(input(SHIFT_RIGHT))
        }
        is(ShiftCtrlEnum.SRL,ShiftCtrlEnum.SRA){
          output(REGFILE_WRITE_DATA) := input(SHIFT_RIGHT)
        }
      }
    }
  }
}