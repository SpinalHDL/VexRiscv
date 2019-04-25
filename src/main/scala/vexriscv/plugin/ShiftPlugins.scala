package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib.Reverse



class FullBarrelShifterPlugin(earlyInjection : Boolean = false) extends Plugin[VexRiscv]{
  object ShiftCtrlEnum extends SpinalEnum(binarySequential){
    val DISABLE, SLL, SRL, SRA = newElement()
  }

  object SHIFT_CTRL extends Stageable(ShiftCtrlEnum())
  object SHIFT_RIGHT extends Stageable(Bits(32 bits))

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._



    val immediateActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> Bool(earlyInjection),
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE                  -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> Bool(earlyInjection),
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE                  -> True,
      RS2_USE                  -> True
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

    val injectionStage = if(earlyInjection) execute else memory
    injectionStage plug new Area{
      import injectionStage._
      when(arbitration.isValid){
        switch(input(SHIFT_CTRL)) {
          is(ShiftCtrlEnum.SLL) {
            output(REGFILE_WRITE_DATA) := Reverse(input(SHIFT_RIGHT))
          }
          is(ShiftCtrlEnum.SRL, ShiftCtrlEnum.SRA) {
            output(REGFILE_WRITE_DATA) := input(SHIFT_RIGHT)
          }
        }
      }
    }
  }
}










class LightShifterPlugin extends Plugin[VexRiscv]{
  object ShiftCtrlEnum extends SpinalEnum(binarySequential){
    val DISABLE, SLL, SRL, SRA = newElement()
  }

  object SHIFT_CTRL extends Stageable(ShiftCtrlEnum())

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    import IntAluPlugin._

    val immediateActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE                 -> True,

      //Get SRC1 through the MMU to the RF write path
      ALU_CTRL                 -> AluCtrlEnum.ADD_SUB,
      SRC_USE_SUB_LESS         -> False,
      SRC_ADD_ZERO             -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE                 -> True,
      RS2_USE                 -> True,

      //Get SRC1 through the MMU to the RF write path
      ALU_CTRL                 -> AluCtrlEnum.ADD_SUB,
      SRC_USE_SUB_LESS         -> False,
      SRC_ADD_ZERO             -> True
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

      val isActive = RegInit(False)
      val isShift = input(SHIFT_CTRL) =/= ShiftCtrlEnum.DISABLE
      val amplitudeReg = Reg(UInt(5 bits))
      val amplitude = isActive ? amplitudeReg | input(SRC2)(4 downto 0).asUInt
      val shiftReg = ifGen(!withMemoryStage) (RegNextWhen(execute.output(REGFILE_WRITE_DATA), !arbitration.isStuckByOthers))
      val shiftInput = isActive ? (if(withMemoryStage) memory.input(REGFILE_WRITE_DATA) else shiftReg) | input(SRC1)
      val done = amplitude(4 downto 1) === 0

      if(withMemoryStage) memory.dontSampleStageable(REGFILE_WRITE_DATA, arbitration.isStuckByOthers)

      when(arbitration.isValid && isShift && input(SRC2)(4 downto 0) =/= 0){
        output(REGFILE_WRITE_DATA) := input(SHIFT_CTRL).mux(
          ShiftCtrlEnum.SLL -> (shiftInput |<<  1),
          default -> (((input(SHIFT_CTRL) === ShiftCtrlEnum.SRA && shiftInput.msb) ## shiftInput).asSInt >> 1).asBits  //ALU.SRL,ALU.SRA
        )

        when(!arbitration.isStuckByOthers){
          isActive := True
          amplitudeReg := amplitude - 1

          when(done){
            isActive := False
          } otherwise{
            arbitration.haltItself := True
          }
        }
      }
      when(arbitration.removeIt){
        isActive := False
      }
    }
  }
}
