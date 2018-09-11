package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv.{VexRiscv, _}

class MulDivIterativePlugin(genMul : Boolean = true, genDiv : Boolean = true, mulUnrollFactor : Int = 1, divUnrollFactor : Int = 1) extends Plugin[VexRiscv]{
  object IS_MUL extends Stageable(Bool)
  object IS_DIV extends Stageable(Bool)
  object IS_REM extends Stageable(Bool)
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


    val decoderService = pipeline.service(classOf[DecoderService])

    if(genMul) {
      val mulActions = commonActions ++ List(IS_MUL -> True)
      decoderService.addDefault(IS_MUL, False)
      decoderService.add(List(
        MUL -> (mulActions ++ List(IS_RS1_SIGNED -> False, IS_RS2_SIGNED -> False)),
        MULH -> (mulActions ++ List(IS_RS1_SIGNED -> True, IS_RS2_SIGNED -> True)),
        MULHSU -> (mulActions ++ List(IS_RS1_SIGNED -> True, IS_RS2_SIGNED -> False)),
        MULHU -> (mulActions ++ List(IS_RS1_SIGNED -> False, IS_RS2_SIGNED -> False))
      ))
    }

    if(genDiv) {
      val divActions = commonActions ++ List(IS_DIV -> True)
      decoderService.addDefault(IS_DIV, False)
      decoderService.add(List(
        DIV -> (divActions ++ List(IS_RS1_SIGNED -> True, IS_RS2_SIGNED -> True)),
        DIVU -> (divActions ++ List(IS_RS1_SIGNED -> False, IS_RS2_SIGNED -> False)),
        REM -> (divActions ++ List(IS_RS1_SIGNED -> True, IS_RS2_SIGNED -> True)),
        REMU -> (divActions ++ List(IS_RS1_SIGNED -> False, IS_RS2_SIGNED -> False))
      ))
    }

  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    if(!genMul && !genDiv) return

    memory plug new Area {
      import memory._

      //Shared ressources
      val rs1 = Reg(UInt(33 bits))
      val rs2 = Reg(UInt(32 bits))
      val accumulator = Reg(UInt(65 bits))


      val mul = ifGen(genMul) (new Area{
        assert(isPow2(mulUnrollFactor))
        val counter = Counter(32 / mulUnrollFactor + 1)
        val done = counter.willOverflowIfInc
        when(arbitration.isValid && input(IS_MUL)){
          when(!done){
            arbitration.haltItself := True
            counter.increment()
            rs2 := rs2 |>> mulUnrollFactor
            val sumElements = ((0 until mulUnrollFactor).map(i => rs2(i) ? (rs1 << i) | U(0)) :+ (accumulator >> 32))
            val sumResult =  sumElements.map(_.asSInt.resize(32 + mulUnrollFactor + 1).asUInt).reduceBalancedTree(_ + _)
            accumulator := (sumResult @@ accumulator(31 downto 0)) >> mulUnrollFactor
          }
          output(REGFILE_WRITE_DATA) := ((input(INSTRUCTION)(13 downto 12) === B"00") ? accumulator(31 downto 0) | accumulator(63 downto 32)).asBits
        }
      })


      val div = ifGen(genDiv) (new Area{
        assert(isPow2(divUnrollFactor))

        //register allocation
        def numerator = rs1(31 downto 0)
        def denominator = rs2
        def remainder = accumulator(31 downto 0)

        val needRevert = Reg(Bool)
        val counter = Counter(32 / divUnrollFactor + 2)
        val done = counter.willOverflowIfInc
        val result = Reg(Bits(32 bits))
        when(arbitration.isValid && input(IS_DIV)){
          when(!done){
            arbitration.haltItself := True
            counter.increment()

            def stages(inNumerator: UInt, inRemainder: UInt, stage: Int): Unit = stage match {
              case 0 => {
                numerator := inNumerator
                remainder := inRemainder
              }
              case _ => {
                val remainderShifted = (inRemainder ## inNumerator.msb).asUInt
                val remainderMinusDenominator = remainderShifted - denominator
                val outRemainder = !remainderMinusDenominator.msb ? remainderMinusDenominator.resize(32 bits) | remainderShifted.resize(32 bits)
                val outNumerator = (inNumerator ## !remainderMinusDenominator.msb).asUInt.resize(32 bits)
                stages(outNumerator, outRemainder, stage - 1)
              }
            }

            stages(numerator, remainder, divUnrollFactor)

            when(counter === 32 / divUnrollFactor){
              val selectedResult = (input(INSTRUCTION)(13) ? remainder | numerator)
              result := selectedResult.twoComplement(needRevert).asBits.resized
            }
          }

          output(REGFILE_WRITE_DATA) := result
        }
      })

      //Execute stage logic to drive memory stage's input regs
      when(!arbitration.isStuck){
        accumulator := 0
        def twoComplement(that : Bits, enable: Bool): UInt = (Mux(enable, ~that, that).asUInt + enable.asUInt)
        val rs2NeedRevert =  execute.input(RS2).msb && execute.input(IS_RS2_SIGNED)
        val rs1NeedRevert =  (if(genMul)(execute.input(IS_MUL) && rs2NeedRevert) else False) ||
                             (if(genDiv)(execute.input(IS_DIV) && execute.input(RS1).msb && execute.input(IS_RS1_SIGNED)) else False)
        val rs1Extended   = B((32 downto 32) -> (execute.input(IS_RS1_SIGNED) && execute.input(RS1).msb), (31 downto 0) -> execute.input(RS1))

        rs1 := twoComplement(rs1Extended, rs1NeedRevert).resized
        rs2 := twoComplement(execute.input(RS2), rs2NeedRevert)
        if(genMul) mul.counter.clear()
        if(genDiv) div.needRevert := rs1NeedRevert ^ (rs2NeedRevert && !execute.input(INSTRUCTION)(13))
        if(genDiv) div.counter.clear()
      }
    }
  }
}
