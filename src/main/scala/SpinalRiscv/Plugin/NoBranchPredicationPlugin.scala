package SpinalRiscv.Plugin

import SpinalRiscv.Riscv._
import SpinalRiscv._
import spinal.core._
import spinal.lib._


class NoPredictionBranchPlugin(earlyBranch : Boolean) extends Plugin[VexRiscv]{
  object BranchCtrlEnum extends SpinalEnum(binarySequential){
    val INC,B,JAL,JALR = newElement()
  }

  object BRANCH_CTRL extends Stageable(BranchCtrlEnum())
  object BRANCH_SOLVED extends Stageable(BranchCtrlEnum())
  object BRANCH_CALC extends Stageable(UInt(32 bits))

  var jumpInterface : Flow[UInt] = null

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])

    val bActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION -> True,
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC2_CTRL         -> Src2CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> True,
      REG1_USE          -> True,
      REG2_USE          -> True
    )

    val jActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION   -> True,
      SRC1_CTRL           -> Src1CtrlEnum.FOUR,
      SRC2_CTRL           -> Src2CtrlEnum.PC,
      SRC_USE_SUB_LESS    -> False,
      REGFILE_WRITE_VALID -> True
    )

    decoderService.addDefault(BRANCH_CTRL, BranchCtrlEnum.INC)
    decoderService.add(List(
      JAL  -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JAL)),
      JALR -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JALR, REG1_USE -> True)),
      BEQ  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BNE  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BLT  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BGE  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BLTU -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True)),
      BGEU -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True))
    ))

    jumpInterface = pipeline.service(classOf[PcManagerService]).createJumpInterface(pipeline.execute)
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    execute plug new Area {
      import execute._

      val less = input(SRC_LESS)
      val eq = input(SRC1) === input(SRC2)

      insert(BRANCH_SOLVED) := input(BRANCH_CTRL).mux[BranchCtrlEnum.C](
        BranchCtrlEnum.INC  -> BranchCtrlEnum.INC,
        BranchCtrlEnum.JAL  -> BranchCtrlEnum.JAL,
        BranchCtrlEnum.JALR -> BranchCtrlEnum.JALR,
        BranchCtrlEnum.B    -> input(INSTRUCTION)(14 downto 12).mux(
          B"000"  -> Mux( eq  , BranchCtrlEnum.B, BranchCtrlEnum.INC),
          B"001"  -> Mux(!eq  , BranchCtrlEnum.B, BranchCtrlEnum.INC),
          M"1-1"  -> Mux(!less, BranchCtrlEnum.B, BranchCtrlEnum.INC),
          default -> Mux( less, BranchCtrlEnum.B, BranchCtrlEnum.INC)
        )
      )

      val imm = IMM(input(INSTRUCTION))
      insert(BRANCH_CALC) := input(BRANCH_SOLVED).mux(
        BranchCtrlEnum.JAL  -> (input(PC)          + imm.j_sext.asUInt),
        BranchCtrlEnum.JALR -> (input(REG1).asUInt + imm.i_sext.asUInt),
        default             -> (input(PC)          + imm.b_sext.asUInt)    //B
      )
    }

    val branchStage = if(earlyBranch) execute else memory
    branchStage plug new Area {
      import branchStage._
      jumpInterface.valid := arbitration.isFiring && input(BRANCH_SOLVED) =/= BranchCtrlEnum.INC
      jumpInterface.payload := input(BRANCH_CALC)

      when(jumpInterface.valid) {
        //prefetch.arbitration.removeIt := True
        fetch.arbitration.removeIt := True
        decode.arbitration.removeIt := True
        if(!earlyBranch) execute.arbitration.removeIt := True
      }
    }
  }
}