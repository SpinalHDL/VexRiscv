package SpinalRiscv.Plugin

import SpinalRiscv.Riscv._
import SpinalRiscv._
import spinal.core._
import spinal.lib._

trait BranchPrediction
object DISABLE extends BranchPrediction
object STATIC  extends BranchPrediction
object DYNAMIC extends BranchPrediction

class NoPredictionBranchPlugin(earlyBranch : Boolean,prediction : BranchPrediction) extends Plugin[VexRiscv]{
  object BranchCtrlEnum extends SpinalEnum(binarySequential){
    val INC,B,JAL,JALR = newElement()
  }

  object BRANCH_CTRL extends Stageable(BranchCtrlEnum())
  object BRANCH_CALC extends Stageable(UInt(32 bits))
  object BRANCH_DO extends Stageable(Bool)

  var jumpInterface : Flow[UInt] = null
  var predictionJumpInterface : Flow[UInt] = null

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

    val  pcManagerService = pipeline.service(classOf[PcManagerService])
    jumpInterface = pcManagerService.createJumpInterface(pipeline.execute)
    if(prediction != DISABLE) predictionJumpInterface = pcManagerService.createJumpInterface(pipeline.decode)
  }
  override def build(pipeline: VexRiscv): Unit = prediction match {
    case `DISABLE` => buildWithoutPrediction(pipeline)
    case `STATIC` => buildWithPrediction(pipeline)
    case `DYNAMIC` => buildWithPrediction(pipeline)
  }

  def buildWithoutPrediction(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    execute plug new Area {
      import execute._

      val less = input(SRC_LESS)
      val eq = input(SRC1) === input(SRC2)

      insert(BRANCH_DO) := input(BRANCH_CTRL).mux(
        BranchCtrlEnum.INC  -> False,
        BranchCtrlEnum.JAL  -> True,
        BranchCtrlEnum.JALR -> True,
        BranchCtrlEnum.B    -> input(INSTRUCTION)(14 downto 12).mux(
          B"000"  -> eq  ,
          B"001"  -> !eq  ,
          M"1-1"  -> !less,
          default -> less
        )
      )

      val imm = IMM(input(INSTRUCTION))
      val branch_src1 = (input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? input(REG1).asUInt | input(PC)
      val branch_src2 = input(BRANCH_CTRL).mux(
        BranchCtrlEnum.JAL  -> imm.j_sext,
        BranchCtrlEnum.JALR -> imm.i_sext,
        default             -> imm.b_sext
      ).asUInt
      insert(BRANCH_CALC) := branch_src1 + branch_src2
    }

    val branchStage = if(earlyBranch) execute else memory
    branchStage plug new Area {
      import branchStage._
      jumpInterface.valid := arbitration.isFiring && input(BRANCH_DO)
      jumpInterface.payload := input(BRANCH_CALC)

      when(jumpInterface.valid) {
        //prefetch.arbitration.removeIt := True
        fetch.arbitration.removeIt := True
        decode.arbitration.removeIt := True
        if(!earlyBranch) execute.arbitration.removeIt := True
      }
    }
  }

  object PREDICTION_HAD_BRANCHED extends Stageable(Bool)

  def buildWithPrediction(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    decode plug new Area{
      import decode._
      val imm = IMM(input(INSTRUCTION))

      // branch prediction
      val staticBranchPrediction = (imm.b_sext.msb && input(BRANCH_CTRL) === BranchCtrlEnum.B) || input(BRANCH_CTRL) === BranchCtrlEnum.JAL
      insert(PREDICTION_HAD_BRANCHED) := (prediction match {
        case `STATIC` =>
          staticBranchPrediction
      })


      predictionJumpInterface.valid := input(PREDICTION_HAD_BRANCHED) && arbitration.isFiring //TODO OH Doublon de priorité
      predictionJumpInterface.payload := input(PC) + ((input(BRANCH_CTRL) === BranchCtrlEnum.JAL) ? imm.j_sext | imm.b_sext).asUInt
      when(predictionJumpInterface.valid) {
        fetch.arbitration.removeIt := True
      }
    }

    execute plug new Area {
      import execute._

      val less = input(SRC_LESS)
      val eq = input(SRC1) === input(SRC2)

      insert(BRANCH_DO) := input(PREDICTION_HAD_BRANCHED) =/= input(BRANCH_CTRL).mux(
        BranchCtrlEnum.INC  -> False,
        BranchCtrlEnum.JAL  -> True,
        BranchCtrlEnum.JALR -> True,
        BranchCtrlEnum.B    -> input(INSTRUCTION)(14 downto 12).mux(
          B"000"  -> eq  ,
          B"001"  -> !eq  ,
          M"1-1"  -> !less,
          default -> less
        )
      )

      val imm = IMM(input(INSTRUCTION))
      val branch_src1,branch_src2 = UInt(32 bits)
      switch(input(BRANCH_CTRL)){
        is(BranchCtrlEnum.JALR){
          branch_src1 := input(REG1).asUInt
          branch_src2 := imm.i_sext.asUInt
        }
        default{
          branch_src1 := input(PC)
          branch_src2 := (input(PREDICTION_HAD_BRANCHED) ? B(4) | imm.b_sext).asUInt
        }
      }
      insert(BRANCH_CALC) := branch_src1 + branch_src2
    }

    val branchStage = if(earlyBranch) execute else memory
    branchStage plug new Area {
      import branchStage._
      jumpInterface.valid := input(BRANCH_DO) && arbitration.isFiring
      jumpInterface.payload := input(BRANCH_CALC)

      when(jumpInterface.valid) {
        fetch.arbitration.removeIt := True
        decode.arbitration.removeIt := True
        if(!earlyBranch) execute.arbitration.removeIt := True
      }
    }
  }
}