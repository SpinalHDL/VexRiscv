package vexriscv.plugin
import vexriscv._
import vexriscv.VexRiscv
import spinal.core._
import spinal.lib.KeepAttribute

//Input buffer generaly avoid the FPGA synthesis to duplicate reg inside the DSP cell, which could stress timings quite much.
class MulPlugin(inputBuffer : Boolean = false) extends Plugin[VexRiscv]{
  object MUL_LL extends Stageable(UInt(32 bits))
  object MUL_LH extends Stageable(SInt(34 bits))
  object MUL_HL extends Stageable(SInt(34 bits))
  object MUL_HH extends Stageable(SInt(34 bits))

  object MUL_LOW extends Stageable(SInt(34+16+2 bits))

  object IS_MUL extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._


    val actions = List[(Stageable[_ <: BaseType],Any)](
//      SRC1_CTRL                -> Src1CtrlEnum.RS,
//      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> False,
      RS1_USE                 -> True,
      RS2_USE                 -> True,
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


    //Do partial multiplication, four times 16 bits * 16 bits
    execute plug new Area {
      import execute._
      val aSigned,bSigned = Bool
      val a,b = Bits(32 bit)

//      a := input(SRC1)
//      b := input(SRC2)

      val withInputBuffer = inputBuffer generate new Area{
        val rs1 = RegNext(input(RS1))
        val rs2 = RegNext(input(RS2))
        a := rs1
        b := rs2

        val delay = RegNext(arbitration.isStuck)
        when(arbitration.isValid && input(IS_MUL) && !delay){
          arbitration.haltItself := True
        }
      }

      val noInputBuffer = (!inputBuffer) generate new Area{
        a := input(RS1)
        b := input(RS2)
      }

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

      val aULow = a(15 downto 0).asUInt
      val bULow = b(15 downto 0).asUInt
      val aSLow = (False ## a(15 downto 0)).asSInt
      val bSLow = (False ## b(15 downto 0)).asSInt
      val aHigh = (((aSigned && a.msb) ## a(31 downto 16))).asSInt
      val bHigh = (((bSigned && b.msb) ## b(31 downto 16))).asSInt
      insert(MUL_LL) := aULow * bULow
      insert(MUL_LH) := aSLow * bHigh
      insert(MUL_HL) := aHigh * bSLow
      insert(MUL_HH) := aHigh * bHigh

      Component.current.afterElaboration{
        //Avoid synthesis tools to retime RS1 RS2 from execute stage to decode stage leading to bad timings (ex : Vivado, even if retiming is disabled)
        KeepAttribute(input(RS1))
        KeepAttribute(input(RS2))
      }
    }

    //First aggregation of partial multiplication
    memory plug new Area {
      import memory._
      insert(MUL_LOW) := S(0, MUL_HL.dataType.getWidth + 16 + 2 bit) + (False ## input(MUL_LL)).asSInt + (input(MUL_LH) << 16) + (input(MUL_HL) << 16)
    }

    //Final aggregation of partial multiplications, REGFILE_WRITE_DATA overriding
    writeBack plug new Area {
      import writeBack._
      val result = input(MUL_LOW) + (input(MUL_HH) << 32)


      when(arbitration.isValid && input(IS_MUL)){
        switch(input(INSTRUCTION)(13 downto 12)){
          is(B"00"){
            output(REGFILE_WRITE_DATA) := input(MUL_LOW)(31 downto 0).asBits
          }
          is(B"01",B"10",B"11"){
            output(REGFILE_WRITE_DATA) := result(63 downto 32).asBits
          }
        }
      }
    }
  }
}
