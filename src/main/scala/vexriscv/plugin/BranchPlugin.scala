package vexriscv.plugin

import vexriscv.Riscv._
import vexriscv._
import spinal.core._
import spinal.lib._

trait BranchPrediction
object NONE extends BranchPrediction
object STATIC  extends BranchPrediction
object DYNAMIC extends BranchPrediction
object DYNAMIC_TARGET extends BranchPrediction

object BranchCtrlEnum extends SpinalEnum(binarySequential){
  val INC,B,JAL,JALR = newElement()
}
object BRANCH_CTRL extends Stageable(BranchCtrlEnum())


case class DecodePredictionCmd() extends Bundle {
  val hadBranch = Bool
}
case class DecodePredictionRsp(stage : Stage) extends Bundle {
  val wasWrong = Bool
}
case class DecodePredictionBus(stage : Stage) extends Bundle {
  val cmd = DecodePredictionCmd()
  val rsp = DecodePredictionRsp(stage)
}

case class FetchPredictionCmd() extends Bundle{
  val hadBranch = Bool
  val targetPc = UInt(32 bits)
}
case class FetchPredictionRsp() extends Bundle{
  val wasRight = Bool
  val finalPc = UInt(32 bits)
  val sourceLastWord = UInt(32 bits)
}
case class FetchPredictionBus(stage : Stage) extends Bundle {
  val cmd = FetchPredictionCmd()
  val rsp = FetchPredictionRsp()
}


trait PredictionInterface{
  def askFetchPrediction() : FetchPredictionBus
  def askDecodePrediction() : DecodePredictionBus
}



class BranchPlugin(earlyBranch : Boolean,
                   catchAddressMisaligned : Boolean = false,
                   fenceiGenAsAJump : Boolean = false,
                   fenceiGenAsANop : Boolean = false,
                   decodeBranchSrc2 : Boolean = false) extends Plugin[VexRiscv] with PredictionInterface{


  def catchAddressMisalignedForReal = catchAddressMisaligned && !pipeline(RVC_GEN)
  lazy val branchStage = if(earlyBranch) pipeline.execute else pipeline.memory

  object BRANCH_CALC extends Stageable(UInt(32 bits))
  object BRANCH_DO extends Stageable(Bool)
  object BRANCH_COND_RESULT extends Stageable(Bool)
  object IS_FENCEI extends Stageable(Bool)

  var jumpInterface : Flow[UInt] = null
  var predictionJumpInterface : Flow[UInt] = null
  var predictionExceptionPort : Flow[ExceptionCause] = null
  var branchExceptionPort : Flow[ExceptionCause] = null


  var decodePrediction : DecodePredictionBus = null
  var fetchPrediction : FetchPredictionBus = null


  override def askFetchPrediction() = {
    fetchPrediction = FetchPredictionBus(branchStage)
    fetchPrediction
  }

  override def askDecodePrediction() = {
    decodePrediction = DecodePredictionBus(branchStage)
    decodePrediction
  }

  def hasHazardOnBranch = if(earlyBranch) pipeline.service(classOf[HazardService]).hazardOnExecuteRS else False

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    import IntAluPlugin._

    assert(earlyBranch || withMemoryStage, "earlyBranch must be true when memory stage is disabled!")

    val bActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC2_CTRL         -> Src2CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> True,
      RS1_USE          -> True,
      RS2_USE          -> True,
      HAS_SIDE_EFFECT -> True
    )

    val jActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL           -> Src1CtrlEnum.PC_INCREMENT,
      SRC2_CTRL           -> Src2CtrlEnum.PC,
      SRC_USE_SUB_LESS    -> False,
      REGFILE_WRITE_VALID -> True,
      HAS_SIDE_EFFECT -> True
    )

    val decoderService = pipeline.service(classOf[DecoderService])


    decoderService.addDefault(BRANCH_CTRL, BranchCtrlEnum.INC)
    val rvc = pipeline(RVC_GEN)
    decoderService.add(List(
      JAL(true)  -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JAL, ALU_CTRL -> AluCtrlEnum.ADD_SUB)),
      JALR       -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JALR, ALU_CTRL -> AluCtrlEnum.ADD_SUB, RS1_USE -> True)),
      BEQ(true)  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BNE(true)  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BLT(true)  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BGE(true)  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BLTU(true) -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True)),
      BGEU(true) -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True))
    ))

    if(fenceiGenAsAJump) {
      decoderService.addDefault(IS_FENCEI, False)
      decoderService.add(List(
        FENCEI -> (List(IS_FENCEI -> True,HAS_SIDE_EFFECT -> True, BRANCH_CTRL -> BranchCtrlEnum.JAL))
      ))
    }

    if(fenceiGenAsANop){
      decoderService.add(List(FENCEI -> List()))
    }

    val pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(branchStage)


    if (catchAddressMisalignedForReal) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      branchExceptionPort = exceptionService.newExceptionPort(branchStage)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    (fetchPrediction,decodePrediction) match {
      case (null, null) => buildWithoutPrediction(pipeline)
      case (_   , null) => buildFetchPrediction(pipeline)
      case (null, _) => buildDecodePrediction(pipeline)
    }
    if(fenceiGenAsAJump) {
      import pipeline._
      import pipeline.config._
      when(decode.input(IS_FENCEI)) {
        decode.output(INSTRUCTION)(12) := False
        decode.output(INSTRUCTION)(22) := True
      }
      execute.arbitration.haltByOther setWhen(execute.arbitration.isValid && execute.input(IS_FENCEI) && stagesFromExecute.tail.map(_.arbitration.isValid).asBits.orR)
    }
  }

  def buildWithoutPrediction(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Do branch calculations (conditions + target PC)
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
      val branch_src1 = (input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? input(RS1).asUInt | input(PC)
      val branch_src2 = input(BRANCH_CTRL).mux(
        BranchCtrlEnum.JAL  -> imm.j_sext,
        BranchCtrlEnum.JALR -> imm.i_sext,
        default             -> imm.b_sext
      ).asUInt

      val branchAdder = branch_src1 + branch_src2
      insert(BRANCH_CALC) := branchAdder(31 downto 1) @@ U"0"
    }

    //Apply branchs (JAL,JALR, Bxx)
    branchStage plug new Area {
      import branchStage._
      jumpInterface.valid := arbitration.isValid && input(BRANCH_DO) && !hasHazardOnBranch
      jumpInterface.payload := input(BRANCH_CALC)
      arbitration.flushNext setWhen(jumpInterface.valid)

      if(catchAddressMisalignedForReal) {
        branchExceptionPort.valid := arbitration.isValid  && input(BRANCH_DO) && jumpInterface.payload(1)
        branchExceptionPort.code := 0
        branchExceptionPort.badAddr := jumpInterface.payload

        if(branchStage == execute) branchExceptionPort.valid clearWhen(service(classOf[HazardService]).hazardOnExecuteRS)
      }
    }
  }


  def buildDecodePrediction(pipeline: VexRiscv): Unit = {
    object PREDICTION_HAD_BRANCHED extends Stageable(Bool)

    import pipeline._
    import pipeline.config._


    decode plug new Area {
      import decode._
      insert(PREDICTION_HAD_BRANCHED) := (if(fenceiGenAsAJump) decodePrediction.cmd.hadBranch && !decode.input(IS_FENCEI) else decodePrediction.cmd.hadBranch)
    }

    //Do real branch calculation
    execute plug new Area {
      import execute._

      val less = input(SRC_LESS)
      val eq = input(SRC1) === input(SRC2)

      insert(BRANCH_COND_RESULT) := input(BRANCH_CTRL).mux(
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
      val missAlignedTarget = if(pipeline(RVC_GEN)) False else (input(BRANCH_COND_RESULT) && input(BRANCH_CTRL).mux(
        BranchCtrlEnum.JALR -> (imm.i_sext(1) ^ input(RS1)(1)),
        BranchCtrlEnum.JAL  ->  imm.j_sext(1),
        default             ->  imm.b_sext(1)
      ))

      insert(BRANCH_DO) := input(PREDICTION_HAD_BRANCHED) =/= input(BRANCH_COND_RESULT) || missAlignedTarget

      //Calculation of the branch target / correction
      val branch_src1,branch_src2 = UInt(32 bits)
      switch(input(BRANCH_CTRL)){
        is(BranchCtrlEnum.JALR){
          branch_src1 := input(RS1).asUInt
          branch_src2 := imm.i_sext.asUInt
        }
        default{
          branch_src1 := input(PC)
          branch_src2 := ((input(BRANCH_CTRL) === BranchCtrlEnum.JAL) ? imm.j_sext | imm.b_sext).asUInt
          when(input(PREDICTION_HAD_BRANCHED)){ //Assume the predictor never predict missaligned stuff, this avoid the need to know if the instruction should branch or not
            branch_src2 := (if(pipeline(RVC_GEN)) Mux(input(IS_RVC), B(2), B(4)) else B(4)).asUInt.resized
          }
        }
      }
      val branchAdder = branch_src1 + branch_src2
      insert(BRANCH_CALC) := branchAdder(31 downto 1) @@ U"0"
    }


    // branch JALR or JAL/Bxx prediction miss corrections
    val branchStage = if(earlyBranch) execute else memory
    branchStage plug new Area {
      import branchStage._
      jumpInterface.valid := arbitration.isValid && input(BRANCH_DO) && !hasHazardOnBranch
      jumpInterface.payload := input(BRANCH_CALC)
      arbitration.flushNext setWhen(jumpInterface.valid)

      if(catchAddressMisalignedForReal) {
        val unalignedJump = input(BRANCH_DO) && input(BRANCH_CALC)(1)
        branchExceptionPort.valid := arbitration.isValid && unalignedJump
        branchExceptionPort.code := 0
        branchExceptionPort.badAddr := input(BRANCH_CALC) //pipeline.stages(pipeline.indexOf(branchStage)-1).input

        if(branchStage == execute) branchExceptionPort.valid clearWhen(service(classOf[HazardService]).hazardOnExecuteRS)
      }
    }

    decodePrediction.rsp.wasWrong := jumpInterface.valid
  }





  def buildFetchPrediction(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    //Do branch calculations (conditions + target PC)
    object NEXT_PC extends Stageable(UInt(32 bits))
    object TARGET_MISSMATCH extends Stageable(Bool)
    object BRANCH_SRC2 extends Stageable(UInt(32 bits))
    val branchSrc2Stage = if(decodeBranchSrc2) decode else execute
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

      val branch_src1 = (input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? input(RS1).asUInt | input(PC)

      val imm = IMM(branchSrc2Stage.input(INSTRUCTION))
      branchSrc2Stage.insert(BRANCH_SRC2) := branchSrc2Stage.input(BRANCH_CTRL).mux(
        BranchCtrlEnum.JAL  -> imm.j_sext,
        BranchCtrlEnum.JALR -> imm.i_sext,
        default             -> imm.b_sext
      ).asUInt

      val branchAdder = branch_src1 + input(BRANCH_SRC2)
      insert(BRANCH_CALC) := branchAdder(31 downto 1) @@ U"0"
      insert(NEXT_PC) := input(PC) + (if(pipeline(RVC_GEN)) ((input(IS_RVC)) ? U(2) | U(4)) else 4)
      insert(TARGET_MISSMATCH) := decode.input(PC) =/= input(BRANCH_CALC)
    }

    //Apply branchs (JAL,JALR, Bxx)
    val branchStage = if(earlyBranch) execute else memory
    branchStage plug new Area {
      import branchStage._

      val predictionMissmatch = fetchPrediction.cmd.hadBranch =/= input(BRANCH_DO) || (input(BRANCH_DO) && input(TARGET_MISSMATCH))
      fetchPrediction.rsp.wasRight := ! predictionMissmatch
      fetchPrediction.rsp.finalPc := input(BRANCH_CALC)
      fetchPrediction.rsp.sourceLastWord := {
        if(pipeline(RVC_GEN))
          ((!input(IS_RVC) && input(PC)(1)) ? input(NEXT_PC) | input(PC))
        else
          input(PC)
      }

      jumpInterface.valid := arbitration.isValid && predictionMissmatch && !hasHazardOnBranch
      jumpInterface.payload := (input(BRANCH_DO) ? input(BRANCH_CALC) | input(NEXT_PC))
      arbitration.flushNext setWhen(jumpInterface.valid)


      if(catchAddressMisalignedForReal) {
        branchExceptionPort.valid := arbitration.isValid && input(BRANCH_DO) && input(BRANCH_CALC)(1)
        branchExceptionPort.code := 0
        branchExceptionPort.badAddr := input(BRANCH_CALC)

        if(branchStage == execute) branchExceptionPort.valid clearWhen(service(classOf[HazardService]).hazardOnExecuteRS)
      }
    }
  }
}
