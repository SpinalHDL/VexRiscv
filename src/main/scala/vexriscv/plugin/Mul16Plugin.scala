package vexriscv.plugin

import vexriscv._
import vexriscv.plugin._
import spinal.core._

/**
  * A multiplication plugin using only 16-bit multiplications
  */
class Mul16Plugin extends Plugin[VexRiscv]{

  object MUL_LL extends Stageable(UInt(32 bits))
  object MUL_LH extends Stageable(UInt(32 bits))
  object MUL_HL extends Stageable(UInt(32 bits))
  object MUL_HH extends Stageable(UInt(32 bits))

  object MUL     extends Stageable(Bits(64 bits))

  object IS_MUL  extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._


    val actions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> False,
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
      val a,b = Bits(32 bit)

      a := input(SRC1)
      b := input(SRC2)

      val aLow = a(15 downto 0).asUInt
      val bLow = b(15 downto 0).asUInt
      val aHigh = a(31 downto 16).asUInt
      val bHigh = b(31 downto 16).asUInt

      insert(MUL_LL) := aLow * bLow
      insert(MUL_LH) := aLow * bHigh
      insert(MUL_HL) := aHigh * bLow
      insert(MUL_HH) := aHigh * bHigh
    }

    memory plug new Area {
      import memory._

      val ll = UInt(32 bits)
      val lh = UInt(33 bits)
      val hl = UInt(32 bits)
      val hh = UInt(32 bits)

      ll := input(MUL_LL)
      lh := input(MUL_LH).resized
      hl := input(MUL_HL)
      hh := input(MUL_HH)

      val hllh = lh + hl
      insert(MUL) := ((hh ## ll(31 downto 16)).asUInt + hllh) ## ll(15 downto 0)
    }

    writeBack plug new Area {
      import writeBack._
      val aSigned,bSigned = Bool
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

      val a = (aSigned && input(SRC1).msb) ? input(SRC2).asUInt | U(0)
      val b = (bSigned && input(SRC2).msb) ? input(SRC1).asUInt | U(0)

      when(arbitration.isValid && input(IS_MUL)){
        switch(input(INSTRUCTION)(13 downto 12)){
          is(B"00"){
            output(REGFILE_WRITE_DATA) := input(MUL)(31 downto 0)
          }
          is(B"01",B"10",B"11"){
            output(REGFILE_WRITE_DATA) := (((input(MUL)(63 downto 32)).asUInt + ~a) + (~b + 2)).asBits
          }
        }
      }
    }
  }
}
