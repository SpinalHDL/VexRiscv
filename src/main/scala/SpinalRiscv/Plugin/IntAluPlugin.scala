package SpinalRiscv.Plugin

import SpinalRiscv._
import spinal.core._
object IntAluPlugin{
  object AluCtrlEnum extends SpinalEnum(binarySequential){
    val ADD_SUB, SLT_SLTU, XOR, OR, AND, SRC1 = newElement()
  }

  object ALU_CTRL extends Stageable(AluCtrlEnum())
}

class IntAluPlugin extends Plugin[VexRiscv]{
  import IntAluPlugin._


  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val immediateActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      REG1_USE -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      REG1_USE -> True,
      REG2_USE -> True
    )

    val otherAction = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION        -> True,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True
    )



    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(REGFILE_WRITE_VALID,False)
    decoderService.add(List(
      ADD  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> False)),
      SUB  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> True)),
      SLT  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> False)),
      SLTU -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> True)),
      XOR  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.XOR)),
      OR   -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.OR)),
      AND  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.AND))
    ))

    decoderService.add(List(
      ADDI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> False)),
      SLTI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> False)),
      SLTIU -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> True)),
      XORI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.XOR)),
      ORI   -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.OR)),
      ANDI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.AND))
    ))

    decoderService.add(List(
      LUI   -> (otherAction ++ List(ALU_CTRL -> AluCtrlEnum.SRC1, SRC1_CTRL -> Src1CtrlEnum.IMU)),
      AUIPC -> (otherAction ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB, SRC_USE_SUB_LESS -> False, SRC1_CTRL -> Src1CtrlEnum.IMU, SRC2_CTRL -> Src2CtrlEnum.PC))
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    execute plug new Area{
      import execute._

      // mux results
      insert(REGFILE_WRITE_DATA) := input(ALU_CTRL).mux(
        AluCtrlEnum.AND      -> (input(SRC1) & input(SRC2)),
        AluCtrlEnum.OR       -> (input(SRC1) | input(SRC2)),
        AluCtrlEnum.XOR      -> (input(SRC1) ^ input(SRC2)),
        AluCtrlEnum.SRC1     -> input(SRC1),
        AluCtrlEnum.SLT_SLTU -> input(SRC_LESS).asBits(32 bit),
        AluCtrlEnum.ADD_SUB  -> input(SRC_ADD_SUB)
      )
    }
  }
}
