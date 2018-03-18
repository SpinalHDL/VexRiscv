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

class BranchPlugin(earlyBranch : Boolean,
                   catchAddressMisaligned : Boolean,
                   prediction : BranchPrediction,
                   historyRamSizeLog2 : Int = 10,
                   historyWidth : Int = 2) extends Plugin[VexRiscv]{
  object BranchCtrlEnum extends SpinalEnum(binarySequential){
    val INC,B,JAL,JALR = newElement()
  }

  object BRANCH_CTRL extends Stageable(BranchCtrlEnum())
  object BRANCH_CALC extends Stageable(UInt(32 bits))
  object BRANCH_DO extends Stageable(Bool)
  object BRANCH_COND_RESULT extends Stageable(Bool)

  var jumpInterface : Flow[UInt] = null
  var predictionJumpInterface : Flow[UInt] = null
  var predictionExceptionPort : Flow[ExceptionCause] = null
  var branchExceptionPort : Flow[ExceptionCause] = null

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])

    val bActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC2_CTRL         -> Src2CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> True,
      RS1_USE          -> True,
      RS2_USE          -> True
    )

    val jActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL           -> Src1CtrlEnum.FOUR,
      SRC2_CTRL           -> Src2CtrlEnum.PC,
      SRC_USE_SUB_LESS    -> False,
      REGFILE_WRITE_VALID -> True
    )

    import IntAluPlugin._

    decoderService.addDefault(BRANCH_CTRL, BranchCtrlEnum.INC)
    decoderService.add(List(
      JAL -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JAL, ALU_CTRL -> AluCtrlEnum.ADD_SUB)),
      JALR -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JALR, ALU_CTRL -> AluCtrlEnum.ADD_SUB, RS1_USE -> True)),
      BEQ -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BNE -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BLT -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BGE -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BLTU -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True)),
      BGEU -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True))
    ))

    val pcManagerService = pipeline.service(classOf[JumpService])
    jumpInterface = pcManagerService.createJumpInterface(if(earlyBranch) pipeline.execute else pipeline.memory)

    prediction match {
      case NONE =>
//      case STATIC | DYNAMIC => predictionJumpInterface = pcManagerService.createJumpInterface(pipeline.decode)
//      case DYNAMIC_TARGET => predictionJumpInterface = pcManagerService.createJumpInterface(pipeline.fetch)
    }

    if (catchAddressMisaligned) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      branchExceptionPort = exceptionService.newExceptionPort(if (earlyBranch) pipeline.execute else pipeline.memory)
      prediction match {
        case NONE =>
//        case STATIC | DYNAMIC => predictionExceptionPort = exceptionService.newExceptionPort(pipeline.decode)
//        case DYNAMIC_TARGET =>
      }
    }
  }

  override def build(pipeline: VexRiscv): Unit = prediction match {
    case `NONE` => buildWithoutPrediction(pipeline)
//    case `STATIC` => buildWithPrediction(pipeline)
//    case `DYNAMIC` => buildWithPrediction(pipeline)
//    case `DYNAMIC_TARGET` => buildDynamicTargetPrediction(pipeline)
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
      insert(BRANCH_CALC) := branchAdder(31 downto 1) @@ ((input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? False | branchAdder(0))
    }

    //Apply branchs (JAL,JALR, Bxx)
    val branchStage = if(earlyBranch) execute else memory
    branchStage plug new Area {
      import branchStage._
      jumpInterface.valid := arbitration.isFiring && input(BRANCH_DO)
      jumpInterface.payload := input(BRANCH_CALC)

      when(jumpInterface.valid) {
        stages(indexOf(branchStage) - 1).arbitration.flushAll := True
      }

      if(catchAddressMisaligned) { //TODO conflict with instruction cache two stage
        branchExceptionPort.valid := arbitration.isValid && input(BRANCH_DO) && jumpInterface.payload(1 downto 0) =/= 0
        branchExceptionPort.code := 0
        branchExceptionPort.badAddr := jumpInterface.payload
      }
    }
  }


//  def buildWithPrediction(pipeline: VexRiscv): Unit = {
//    case class BranchPredictorLine()  extends Bundle{
//      val history = SInt(historyWidth bits)
//    }
//
//    object PREDICTION_HAD_BRANCHED extends Stageable(Bool)
//    object HISTORY_LINE extends Stageable(BranchPredictorLine())
//
//    import pipeline._
//    import pipeline.config._
//
//    val historyCache = if(prediction == DYNAMIC) Mem(BranchPredictorLine(), 1 << historyRamSizeLog2) setName("branchCache") else null
//    val historyCacheWrite = if(prediction == DYNAMIC) historyCache.writePort else null
//
//    //Read historyCache
//    if(prediction == DYNAMIC) fetch plug new Area{
//      val readAddress = prefetch.output(PC)(2, historyRamSizeLog2 bits)
//      fetch.insert(HISTORY_LINE) := historyCache.readSync(readAddress,!prefetch.arbitration.isStuckByOthers)
//
//      //WriteFirst bypass TODO long combinatorial path
////      val writePortReg = RegNext(historyCacheWrite)
////      when(writePortReg.valid && writePortReg.address === readAddress){
////        fetch.insert(HISTORY_LINE) := writePortReg.data
////      }
//    }
//
//    //Branch JAL, predict Bxx and branch it
//    decode plug new Area{
//      import decode._
//      val imm = IMM(input(INSTRUCTION))
//
//      val conditionalBranchPrediction = (prediction match {
//        case `STATIC` =>  imm.b_sext.msb
//        case `DYNAMIC` => input(HISTORY_LINE).history.msb
//      })
//      insert(PREDICTION_HAD_BRANCHED) := input(BRANCH_CTRL) === BranchCtrlEnum.JAL || (input(BRANCH_CTRL) === BranchCtrlEnum.B && conditionalBranchPrediction)
//
//      predictionJumpInterface.valid := input(PREDICTION_HAD_BRANCHED) && arbitration.isFiring //TODO OH Doublon de priorité
//      predictionJumpInterface.payload := input(PC) + ((input(BRANCH_CTRL) === BranchCtrlEnum.JAL) ? imm.j_sext | imm.b_sext).asUInt
//      when(predictionJumpInterface.valid) {
//        fetch.arbitration.flushAll := True
//      }
//
//      if(catchAddressMisaligned) {
//        predictionExceptionPort.valid := input(INSTRUCTION_READY) && input(PREDICTION_HAD_BRANCHED) && arbitration.isValid && predictionJumpInterface.payload(1 downto 0) =/= 0
//        predictionExceptionPort.code := 0
//        predictionExceptionPort.badAddr := predictionJumpInterface.payload
//      }
//    }
//
//    //Do real branch calculation
//    execute plug new Area {
//      import execute._
//
//      val less = input(SRC_LESS)
//      val eq = input(SRC1) === input(SRC2)
//
//      insert(BRANCH_COND_RESULT) := input(BRANCH_CTRL).mux(
//        BranchCtrlEnum.INC  -> False,
//        BranchCtrlEnum.JAL  -> True,
//        BranchCtrlEnum.JALR -> True,
//        BranchCtrlEnum.B    -> input(INSTRUCTION)(14 downto 12).mux(
//          B"000"  -> eq  ,
//          B"001"  -> !eq  ,
//          M"1-1"  -> !less,
//          default -> less
//        )
//      )
//
//      insert(BRANCH_DO) := input(PREDICTION_HAD_BRANCHED) =/= insert(BRANCH_COND_RESULT)
//
//      //Calculation of the branch target / correction
//      val imm = IMM(input(INSTRUCTION))
//      val branch_src1,branch_src2 = UInt(32 bits)
//      switch(input(BRANCH_CTRL)){
//        is(BranchCtrlEnum.JALR){
//          branch_src1 := input(RS1).asUInt
//          branch_src2 := imm.i_sext.asUInt
//        }
//        default{
//          branch_src1 := input(PC)
//          branch_src2 := (input(PREDICTION_HAD_BRANCHED) ? B(4) | imm.b_sext).asUInt
//        }
//      }
//      val branchAdder = branch_src1 + branch_src2
//      insert(BRANCH_CALC) := branchAdder(31 downto 1) @@ ((input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? False | branchAdder(0))
//    }
//
//
//    // branch JALR or JAL/Bxx prediction miss corrections
//    val branchStage = if(earlyBranch) execute else memory
//    branchStage plug new Area {
//      import branchStage._
//      jumpInterface.valid := input(BRANCH_DO) && arbitration.isFiring
//      jumpInterface.payload := input(BRANCH_CALC)
//
//      when(jumpInterface.valid) {
//        stages(indexOf(branchStage) - 1).arbitration.flushAll := True
//      }
//
//      if(catchAddressMisaligned) {
//        branchExceptionPort.valid := input(INSTRUCTION_READY) && arbitration.isValid && input(BRANCH_DO) && jumpInterface.payload(1 downto 0) =/= 0
//        branchExceptionPort.code := 0
//        branchExceptionPort.badAddr := jumpInterface.payload
//      }
//    }
//
//    //Update historyCache
//    if(prediction == DYNAMIC) branchStage plug new Area {
//      import branchStage._
//      val newHistory = input(HISTORY_LINE).history.resize(historyWidth + 1) + Mux(input(BRANCH_COND_RESULT),S(-1),S(1))
//      val noOverflow = newHistory(newHistory.high downto newHistory.high - 1) =/= S"10" && newHistory(newHistory.high downto newHistory.high - 1) =/= S"01"
//
//      historyCacheWrite.valid := arbitration.isFiring && input(BRANCH_CTRL) === BranchCtrlEnum.B && noOverflow
//      historyCacheWrite.address := input(PC)(2, historyRamSizeLog2 bits)
//      historyCacheWrite.data.history := newHistory.resized
//    }
//  }





//  def buildDynamicTargetPrediction(pipeline: VexRiscv): Unit = {
//    import pipeline._
//    import pipeline.config._
//
//    case class BranchPredictorLine()  extends Bundle{
//      val source = Bits(31 - historyRamSizeLog2 bits)
//      val confidence = UInt(2 bits)
//      val target = UInt(32 bits)
//    }
//
//    object PREDICTION_WRITE_HAZARD extends Stageable(Bool)
//    object PREDICTION extends Stageable(BranchPredictorLine())
//    object PREDICTION_HIT extends Stageable(Bool)
//
//    val history = Mem(BranchPredictorLine(), 1 << historyRamSizeLog2)
//    val historyWrite = history.writePort
//
//
//    fetch plug new Area{
//      import fetch._
//      val line = history.readSync((prefetch.output(PC) >> 2).resized, prefetch.arbitration.isFiring)
////      val line = history.readAsync((fetch.output(PC) >> 2).resized)
//      val hit = line.source === (input(PC).asBits >>  1 + historyRamSizeLog2)
//
//      //Avoid write to read hazard
//      val historyWriteLast = RegNext(historyWrite)
//      val hazard = historyWriteLast.valid && historyWriteLast.address === (output(PC) >> 2).resized
//      insert(PREDICTION_WRITE_HAZARD) := hazard
//
//      predictionJumpInterface.valid := line.confidence.msb && hit && arbitration.isFiring && !hazard
//      predictionJumpInterface.payload := line.target
//
//      insert(PREDICTION) := line
//      insert(PREDICTION_HIT) := hit
//    }
//
//
//
//    //Do branch calculations (conditions + target PC)
//    execute plug new Area {
//      import execute._
//
//      val less = input(SRC_LESS)
//      val eq = input(SRC1) === input(SRC2)
//
//      insert(BRANCH_DO) := input(BRANCH_CTRL).mux(
//        BranchCtrlEnum.INC  -> False,
//        BranchCtrlEnum.JAL  -> True,
//        BranchCtrlEnum.JALR -> True,
//        BranchCtrlEnum.B    -> input(INSTRUCTION)(14 downto 12).mux(
//          B"000"  -> eq  ,
//          B"001"  -> !eq  ,
//          M"1-1"  -> !less,
//          default -> less
//        )
//      )
//
//      val imm = IMM(input(INSTRUCTION))
//      val branch_src1 = (input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? input(RS1).asUInt | input(PC)
//      val branch_src2 = input(BRANCH_CTRL).mux(
//        BranchCtrlEnum.JAL  -> imm.j_sext,
//        BranchCtrlEnum.JALR -> imm.i_sext,
//        default             -> imm.b_sext
//      ).asUInt
//
//      val branchAdder = branch_src1 + branch_src2
//      insert(BRANCH_CALC) := branchAdder(31 downto 1) @@ ((input(BRANCH_CTRL) === BranchCtrlEnum.JALR) ? False | branchAdder(0))
//    }
//
//    //Apply branchs (JAL,JALR, Bxx)
//    val branchStage = if(earlyBranch) execute else memory
//    branchStage plug new Area {
//      import branchStage._
//
//      val predictionMissmatch = input(PREDICTION).confidence.msb =/= input(BRANCH_DO) || (input(BRANCH_DO) && input(PREDICTION).target =/= input(BRANCH_CALC))
//
//      historyWrite.valid := False
//      historyWrite.address := (branchStage.output(PC) >> 2).resized
//      historyWrite.data.source := input(PC).asBits >> 1 + historyRamSizeLog2
//      historyWrite.data.target := input(BRANCH_CALC)
//
//      jumpInterface.valid := False
//      jumpInterface.payload := input(BRANCH_CALC)
//
//
//      when(!input(BRANCH_DO)){
//        historyWrite.valid := arbitration.isFiring && input(PREDICTION_HIT)
//        historyWrite.data.confidence := input(PREDICTION).confidence - (input(PREDICTION).confidence =/= 0).asUInt
//        historyWrite.data.target := input(BRANCH_CALC)
//
//
//        jumpInterface.valid := input(PREDICTION_HIT) && input(PREDICTION).confidence.msb && !input(PREDICTION_WRITE_HAZARD) && arbitration.isFiring
//        jumpInterface.payload := input(PC) + 4
//      } otherwise{
//        when(!input(PREDICTION_HIT) || input(PREDICTION_WRITE_HAZARD)){
//          jumpInterface.valid := arbitration.isFiring
//          historyWrite.valid := arbitration.isFiring
//          historyWrite.data.confidence := "10"
//        } otherwise {
//          historyWrite.valid := arbitration.isFiring
//          historyWrite.data.confidence := input(PREDICTION).confidence + (input(PREDICTION).confidence =/= 3).asUInt
//          when(!input(PREDICTION).confidence.msb || input(PREDICTION).target =/= input(BRANCH_CALC)){
//            jumpInterface.valid := arbitration.isFiring
//          }
//        }
//      }
//
//      //Prevent rewriting an history which already had hazard
//      historyWrite.valid clearWhen(input(PREDICTION_WRITE_HAZARD))
//
//
//
//      when(jumpInterface.valid) {
//        stages(indexOf(branchStage) - 1).arbitration.flushAll := True
//      }
//
//      if(catchAddressMisaligned) {
//        branchExceptionPort.valid := arbitration.isValid && input(BRANCH_DO) && jumpInterface.payload(1 downto 0) =/= 0
//        branchExceptionPort.code := 0
//        branchExceptionPort.badAddr := jumpInterface.payload
//      }
//    }
//
//    //Init History
//    val historyInit = pipeline plug new Area{
//      val counter = Reg(UInt(historyRamSizeLog2 + 1 bits)) init(0)
//      when(!counter.msb){
//        prefetch.arbitration.haltByOther := True
//        historyWrite.valid := True
//        historyWrite.address := counter.resized
//        historyWrite.data.confidence := 0
//        counter := counter + 1
//      }
//    }
//  }
}