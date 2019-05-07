package vexriscv.plugin

import vexriscv._
import spinal.core._


class SrcPlugin(separatedAddSub : Boolean = false, executeInsertion : Boolean = false, decodeAddSub : Boolean = false) extends Plugin[VexRiscv]{
  object SRC2_FORCE_ZERO extends Stageable(Bool)


  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(SRC_ADD_ZERO, False) //TODO avoid this default to simplify decoding ?
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    decode.insert(SRC2_FORCE_ZERO) := decode.input(SRC_ADD_ZERO) && !decode.input(SRC_USE_SUB_LESS)

    val insertionStage = if(executeInsertion) execute else decode
    insertionStage plug new Area{
      import insertionStage._

      val imm = Riscv.IMM(input(INSTRUCTION))
      insert(SRC1) := input(SRC1_CTRL).mux(
        Src1CtrlEnum.RS   -> output(RS1),
        Src1CtrlEnum.PC_INCREMENT -> (if(pipeline(RVC_GEN)) Mux(input(IS_RVC), B(2), B(4)) else B(4)).resized,
        Src1CtrlEnum.IMU  -> imm.u.resized,
        Src1CtrlEnum.URS1 -> input(INSTRUCTION)(Riscv.rs1Range).resized
      )
      insert(SRC2) := input(SRC2_CTRL).mux(
        Src2CtrlEnum.RS -> output(RS2),
        Src2CtrlEnum.IMI -> imm.i_sext.resized,
        Src2CtrlEnum.IMS -> imm.s_sext.resized,
        Src2CtrlEnum.PC -> output(PC).asBits
      )
    }

    val addSubStage = if(decodeAddSub) decode else execute
    if(separatedAddSub) {
      addSubStage plug new Area {
        import addSubStage._

        // ADD, SUB
        val add = (U(input(SRC1)) + U(input(SRC2))).asBits.addAttribute("keep")
        val sub = (U(input(SRC1)) - U(input(SRC2))).asBits.addAttribute("keep")
        when(input(SRC_ADD_ZERO)){ add := input(SRC1) }

        // SLT, SLTU
        val less = Mux(input(SRC1).msb === input(SRC2).msb, sub.msb,
          Mux(input(SRC_LESS_UNSIGNED), input(SRC2).msb, input(SRC1).msb))

        insert(SRC_ADD_SUB) := input(SRC_USE_SUB_LESS) ? sub | add
        insert(SRC_ADD) := add
        insert(SRC_SUB) := sub
        insert(SRC_LESS) := less
      }
    }else{
      addSubStage plug new Area {
        import addSubStage._

        // ADD, SUB
        val addSub = (input(SRC1).asSInt + Mux(input(SRC_USE_SUB_LESS), ~input(SRC2), input(SRC2)).asSInt + Mux(input(SRC_USE_SUB_LESS), S(1, 32 bits), S(0, 32 bits))).asBits
        when(input(SRC2_FORCE_ZERO)){ addSub := input(SRC1) }


        // SLT, SLTU
        val less = Mux(input(SRC1).msb === input(SRC2).msb, addSub.msb,
          Mux(input(SRC_LESS_UNSIGNED), input(SRC2).msb, input(SRC1).msb))

        insert(SRC_ADD_SUB) := addSub
        insert(SRC_ADD) := addSub
        insert(SRC_SUB) := addSub
        insert(SRC_LESS) := less
      }
    }
  }
}
