package vexriscv.plugin

import spinal.core._
import spinal.lib._

object RvcDecompressor{

  def main(args: Array[String]): Unit = {
    SpinalVerilog(new Component{
      out(Delay((apply(Delay(in Bits(16 bits),2), false, false)),2))
    }.setDefinitionName("Decompressor"))
  }

  def apply(i : Bits, rvf : Boolean, rvd : Boolean): Bits ={
    val ret = Bits(32 bits).assignDontCare()

    val rch = B"01" ## i(9 downto 7)
    val rcl = B"01" ## i(4 downto 2)

    val addi5spnImm = B"00" ## i(10 downto 7) ## i(12 downto 11) ## i(5) ## i(6) ## B"00"
    val lwImm = B"00000" ## i(5) ## i(12 downto 10)  ## i(6) ## B"00"
    def swImm = lwImm
    val ldImm = B"0000" ## i(6 downto 5) ## i(12 downto 10) ## B"000"
    def sdImm = ldImm
    val addImm = B((11 downto 5) -> i(12), (4 downto 0) -> i(6 downto 2))
    def lImm = addImm
    val jalImm = B((9 downto 0) -> i(12)) ## i(8) ## i(10 downto 9) ## i(6) ## i(7) ## i(2) ## i(11) ## i(5 downto 3) ## B"0"
    val luiImm = B((14 downto 0) -> i(12)) ## i(6 downto 2) ## B"0000_0000_0000"
    val shiftImm = i(6 downto 2)
    val addi16spImm = B((2 downto 0) -> i(12)) ## i(4 downto 3) ## i(5) ## i(2) ## i(6) ## B"0000"
    val jImm = B((9 downto 0) -> i(12)) ## i(8) ## i(10 downto 9) ## i(6) ## i(7) ## i(2) ## i(11) ## i(5 downto 3) ## B"0"
    val bImm = B((4 downto 0) -> i(12)) ## i(6 downto 5) ## i(2) ## i(11 downto 10) ## i(4 downto 3) ## B"0"

    def lwspImm = B"0000" ## i(3 downto 2) ## i(12) ## i(6 downto 4) ## B"00"
    def swspImm = B"0000" ## i(8 downto 7) ## i(12 downto 9) ## B"00"
    def ldspImm = B"000" ## i(4 downto 2) ## i(12) ## i(6 downto 5) ## B"000"
    def sdspImm = B"000" ## i(9 downto 7) ## i(12 downto 10) ## B"000"


    val x0 = B"00000"
    val x1 = B"00001"
    val x2 = B"00010"

    switch(i(1 downto 0) ## i(15 downto 13)){
      is(0){ret := addi5spnImm ## B"00010" ## B"000" ## rcl ## B"0010011"} //C.ADDI4SPN -> addi rd0, x2, nzuimm[9:2].
      if(rvd) is(1){ret := ldImm ## rch ##  B"011" ## rcl ## B"0000111"} // C.FLD
      is(2){ret := lwImm ## rch ## B"010" ## rcl ## B"0000011"} //C.LW -> lw rd', offset[6:2](rs1')
      if(rvf) is(3){ret := lwImm ## rch ##  B"010" ## rcl ## B"0000111"} // C.FLW
      if(rvd) is(5){ret := sdImm(11 downto 5) ## rcl  ## rch ## B"011" ## sdImm(4 downto 0) ## B"0100111"} // C.FSD
      is(6){ret := swImm(11 downto 5) ## rcl  ## rch ## B"010" ## swImm(4 downto 0) ## B"0100011"} //C.SW -> sw rs2',offset[6:2](rs1')
      if(rvf) is(7){ret := swImm(11 downto 5) ## rcl  ## rch ## B"010" ## swImm(4 downto 0) ## B"0100111"} // C.FSW
      is(8){ret := addImm ## i(11 downto 7) ## B"000" ## i(11 downto 7) ## B"0010011"} //C.ADDI -> addi rd, rd, nzimm[5:0].
      is(9){ret := jalImm(20) ## jalImm(10 downto 1) ## jalImm(11) ## jalImm(19 downto 12) ## x1 ## B"1101111"} //C.JAL -> jalr x1, rs1, 0.
      is(10){ret := lImm ## B"00000" ## B"000" ## i(11 downto 7) ## B"0010011"} //C.LI -> addi rd, x0, imm[5:0].
      is(11){  //C.ADDI16SP    C.LUI ->
        val addi16sp =  addi16spImm ## i(11 downto 7) ## B"000" ## i(11 downto 7) ## B"0010011"
        val lui      =  luiImm(31 downto 12) ## i(11 downto 7) ## B"0110111"
        ret := (i(11 downto 7) === 2) ? addi16sp | lui
      }
      is(12){
        val isImmediate = i(11 downto 10) =/= B"11"
        val isShift = !i(11)
        val func3 = i(11 downto 10).mux(
          0 -> B"101",
          1 -> B"101",
          2 -> B"111",
          3 -> i(6 downto 5).mux(
            0 -> B"000",
            1 -> B"100",
            2 -> B"110",
            3 -> B"111"
          )
        )
        val msbs = Mux(
          sel = i(11 downto 10) === B"10",
          whenTrue = B((6 downto 0) -> i(12)), //andi
          whenFalse = B"0" ## (i(11 downto 10) === B"01" || (i(11 downto 10) === B"11" && i(6 downto 5) === B"00")) ## B"00000"
        )
        val rs2Shift = (isShift || isImmediate) ? shiftImm | rcl
        val opc = (isImmediate ? B"0010011" | B"0110011")
        ret := msbs ## rs2Shift ## rch ## func3 ## rch ## opc
      }
      is(13){ ret := jImm(20) ## jImm(10 downto 1) ## jImm(11) ## jImm(19 downto 12) ## x0 ## B"1101111"}
      is(14){ ret := bImm(12) ## bImm(10 downto 5) ## x0 ## rch ## B"000" ## bImm(4 downto 1) ## bImm(11) ## B"1100011" }
      is(15){ ret := bImm(12) ## bImm(10 downto 5) ## x0 ## rch ## B"001" ## bImm(4 downto 1) ## bImm(11) ## B"1100011" }
      is(16){ ret := B"0000000" ## i(6 downto 2) ## i(11 downto 7) ## B"001" ## i(11 downto 7) ## B"0010011"   }
      if(rvd) is(17){ret := ldspImm ## x2 ## B"011" ## i(11 downto 7) ## B"0000111" } // C.FLDSP
      is(18){ ret := lwspImm ## x2 ## B"010" ## i(11 downto 7) ## B"0000011" }
      if(rvf) is(19){ret := lwspImm ## x2 ## B"010" ## i(11 downto 7) ## B"0000111" } // C.FLWSP
      is(20) {
        val add = B"000_0000" ## i(6 downto 2) ## (i(12) ? i(11 downto 7) | x0) ## B"000" ## i(11 downto 7) ## B"0110011"   //add => add rd, rd, rs2  mv => add rd, x0, rs2
        val j =  B"0000_0000_0000" ## i(11 downto 7) ## B"000" ## (i(12) ? x1 | x0)  ## B"1100111"  //jr => jalr x0, rs1, 0.    jalr => jalr x1, rs1, 0.
        val ebreak = B"000000000001_00000_000_00000_1110011" //EBREAK
        val addJ = (i(6 downto 2) === 0) ? j | add
        ret := (i(12 downto 2) === B"100_0000_0000") ? ebreak | addJ
      }

      if(rvd) is(21){ret := sdspImm(11 downto 5) ## i(6 downto 2)  ## x2 ## B"011" ## sdspImm(4 downto 0) ## B"0100111" } // C.FSDSP
      is(22){ ret := swspImm(11 downto 5) ## i(6 downto 2)  ## x2 ## B"010" ## swspImm(4 downto 0) ## B"0100011" }
      if(rvf) is(23){ret := swspImm(11 downto 5) ## i(6 downto 2)  ## x2 ## B"010" ## swspImm(4 downto 0) ## B"0100111" } // C.FSwSP
    }

    ret
  }
}


object StreamForkVex{
  def apply[T <: Data](input : Stream[T], portCount: Int, flush : Bool/*, flushDiscardInput : Boolean*/) : Vec[Stream[T]] = {
    val outputs = Vec(cloneOf(input), portCount)
    val linkEnable = Vec(RegInit(True), portCount)

    input.ready := True
    for (i <- 0 until portCount) {
      when(!outputs(i).ready && linkEnable(i)) {
        input.ready := False
      }
    }

    for (i <- 0 until portCount) {
      outputs(i).valid := input.valid && linkEnable(i)
      outputs(i).payload := input.payload
      when(outputs(i).fire) {
        linkEnable(i) := False
      }
    }

    when(input.ready || flush) {
      linkEnable.foreach(_ := True)
    }
    outputs
  }
}


object StreamVexPimper{
  implicit class StreamFlushPimper[T <: Data](pimped : Stream[T]){
    def m2sPipeWithFlush(flush : Bool, discardInput : Boolean = true, collapsBubble : Boolean = true, flushInput : Bool = null): Stream[T] = {
      val ret = cloneOf(pimped).setCompositeName(pimped, "m2sPipe", true)

      val rValid = RegInit(False)
      val rData = Reg(pimped.payloadType)
      if(!discardInput) rValid.clearWhen(flush)

      pimped.ready := (Bool(collapsBubble) && !ret.valid) || ret.ready

      when(pimped.ready) {
        if(flushInput == null)
          rValid := pimped.valid
        else
          rValid := pimped.valid && !flushInput
        rData := pimped.payload
      }

      ret.valid := rValid
      ret.payload := rData

      if(discardInput) rValid.clearWhen(flush)

      ret
    }

    def s2mPipe(flush : Bool): Stream[T] = {
      val ret = cloneOf(pimped)

      val rValid = RegInit(False)
      val rBits = Reg(pimped.payloadType)

      ret.valid := pimped.valid || rValid
      pimped.ready := !rValid
      ret.payload := Mux(rValid, rBits, pimped.payload)

      when(ret.ready) {
        rValid := False
      }

      when(pimped.ready && (!ret.ready)) {
        rValid := pimped.valid
        rBits := pimped.payload
      }

      rValid.clearWhen(flush)

      ret
    }
  }

}



//case class FlowFifoLowLatency[T <: Data](dataType: T, depth: Int) extends Component {
//  require(depth >= 1)
//  val io = new Bundle {
//    val push = slave Flow (dataType)
//    val pop = master Stream (dataType)
//    val flush = in Bool()
//  }
//
//
//  val mem = Vec(Reg(dataType), depth)
//  val rPtr, wPtr = Counter(depth + 1)
//  when(io.push.valid){
//    mem(wPtr) := io.push.payload
//    wPtr.increment()
//  }
//
//  when(io.pop.fire){
//    rPtr.increment()
//  }
//  io.pop.valid := rPtr =/= wPtr
//
//
//}