package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv.{VexRiscv, _}

class MulDivIterativePlugin(mulUnroolFactor : Int = 1) extends Plugin[VexRiscv]{
  object IS_MUL extends Stageable(Bool)
  object IS_RS1_SIGNED extends Stageable(Bool)
  object IS_RS2_SIGNED extends Stageable(Bool)

  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._


    val commonActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> True,
      RS1_USE                 -> True,
      RS2_USE                 -> True
    )

    val mulActions = commonActions ++ List(IS_MUL -> True)

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(IS_MUL, False)
    decoderService.add(List(
      MUL    -> (mulActions ++ List(IS_RS1_SIGNED -> False, IS_RS2_SIGNED -> False)),
      MULH   -> (mulActions ++ List(IS_RS1_SIGNED -> True,  IS_RS2_SIGNED -> True)),
      MULHSU -> (mulActions ++ List(IS_RS1_SIGNED -> True,  IS_RS2_SIGNED -> False)),
      MULHU  -> (mulActions ++ List(IS_RS1_SIGNED -> False, IS_RS2_SIGNED -> False))
    ))

  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    memory plug new Area {
      import memory._
      val rs1 = Reg(UInt(33 bits))
      val rs2 = Reg(UInt(32 bits))
      val accumulator = Reg(UInt(65 bits))
      val mul = new Area{
        assert(isPow2(mulUnroolFactor))
        val counter = Counter(32 / mulUnroolFactor + 1)
        val done = counter.willOverflowIfInc
        when(input(IS_MUL)){
          when(!done){
            arbitration.haltItself := True
            counter.increment()
            rs2 := rs2 |>> mulUnroolFactor
            val sumElements = ((0 until mulUnroolFactor).map(i => rs2(i) ? (rs1 << i) | U(0)) :+ (accumulator >> 32))
            val sumResult =  sumElements.map(_.asSInt.resize(32 + mulUnroolFactor + 1).asUInt).reduceBalancedTree(_ + _)
            accumulator := (sumResult @@ accumulator(31 downto 0)) >> mulUnroolFactor
          }
          output(REGFILE_WRITE_DATA) := ((input(INSTRUCTION)(13 downto 12) === B"00") ? accumulator(31 downto 0) | accumulator(63 downto 32)).asBits
        }
      }

      when(!arbitration.isStuck){
        accumulator := 0
        def twoComplement(that : Bits, enable: Bool): UInt = (Mux(enable, ~that, that).asUInt + enable.asUInt)
        val rs2NeedRevert =  execute.input(RS2).msb && execute.input(IS_RS2_SIGNED)
        val rs1Extended = B((32 downto 32) -> (execute.input(IS_RS1_SIGNED) && execute.input(RS1).msb), (31 downto 0) -> execute.input(RS1))
        rs1 := twoComplement(rs1Extended, rs2NeedRevert).resized
        rs2 := twoComplement(execute.input(RS2), rs2NeedRevert)
        mul.counter.clear()
      }
    }
  }
}



//            val mulEnables = rs2.subdivideIn(mulUnroolFactor bits)(counter(log2Up(32/mulUnroolFactor)-1 downto 0))