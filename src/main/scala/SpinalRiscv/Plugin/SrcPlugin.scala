package SpinalRiscv.Plugin

import SpinalRiscv.{Riscv, VexRiscv}
import spinal.core._


class SrcPlugin extends Plugin[VexRiscv]{
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    decode plug new Area{
      import decode._

      val imm = Riscv.IMM(input(INSTRUCTION))
      insert(SRC1) := input(SRC1_CTRL).mux(
        Src1CtrlEnum.RS   -> output(REG1),
        Src1CtrlEnum.FOUR -> B(4),
        Src1CtrlEnum.IMU  -> imm.u.resized
        //        Src1CtrlEnum.IMZ -> imm.z.resized,
        //        Src1CtrlEnum.IMJB -> B(0)
      )
      insert(SRC2) := input(SRC2_CTRL).mux(
        Src2CtrlEnum.RS -> output(REG2),
        Src2CtrlEnum.IMI -> imm.i_sext.resized,
        Src2CtrlEnum.IMS -> imm.s_sext.resized,
        Src2CtrlEnum.PC -> output(PC).asBits
      )
    }

    execute plug new Area{
      import execute._

      // ADD, SUB
      val addSub = (input(SRC1).asSInt + Mux(input(SRC_USE_SUB_LESS), ~input(SRC2), input(SRC2)).asSInt + Mux(input(SRC_USE_SUB_LESS),S(1),S(0))).asBits

      // SLT, SLTU
      val less  = Mux(input(SRC1).msb === input(SRC2).msb, addSub.msb,
        Mux(input(SRC_LESS_UNSIGNED), input(SRC2).msb, input(SRC1).msb))

      insert(SRC_ADD_SUB) := addSub.resized
      insert(SRC_LESS) := less
    }
  }
}
