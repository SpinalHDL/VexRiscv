package vexriscv.ip.fpu

import spinal.core._
import spinal.lib._
import spinal.lib.eda.bench.{Bench, Rtl, XilinxStdTargets}

import scala.collection.mutable.ArrayBuffer

case class FpuCore(p : FpuParameter) extends Component{
  val io = new Bundle {
    val port = slave(FpuPort(p))
  }

  val rfLockCount = 5
  val lockIdType = HardType(UInt(log2Up(rfLockCount) bits))

  io.port.rsp.valid := False
  io.port.rsp.payload.assignDontCare()

  case class RfReadInput() extends Bundle{
    val source = p.source()
    val opcode = p.Opcode()
    val rs1, rs2, rs3 = p.rfAddress()
    val rd = p.rfAddress()
  }

  case class RfReadOutput() extends Bundle{
    val source = p.source()
    val opcode = p.Opcode()
    val lockId = lockIdType()
    val rs1, rs2, rs3 = p.internalFloating()
    val rd = p.rfAddress()
  }


  case class LoadInput() extends Bundle{
    val source = p.source()
    val rs1 = p.internalFloating()
    val rd = p.rfAddress()
    val lockId = lockIdType()
  }

  case class StoreInput() extends Bundle{
    val source = p.source()
    val rs2 = p.internalFloating()
  }

  case class MulInput() extends Bundle{
    val source = p.source()
    val rs1, rs2, rs3 = p.internalFloating()
    val rd = p.rfAddress()
    val lockId = lockIdType()
    val add = Bool()
    val minus = Bool()
  }

  case class AddInput() extends Bundle{
    val source = p.source()
    val rs1, rs2 = p.internalFloating()
    val rd = p.rfAddress()
    val lockId = lockIdType()
  }
  
  case class WriteInput() extends Bundle{
    val source = p.source()
    val lockId = lockIdType()
    val rd = p.rfAddress()
    val value = p.internalFloating()
  }


  val rf = new Area{
    val ram = Mem(p.internalFloating, 32*(1 << p.sourceWidth))
    val lock = for(i <- 0 until rfLockCount) yield new Area{
      val valid = RegInit(False)
      val source = Reg(p.source)
      val address = Reg(p.rfAddress)
    }
    val lockFree = !lock.map(_.valid).andR
    val lockFreeId = OHMasking.first(lock.map(!_.valid))
  }

  val read = new Area{
    val s0 = Stream(RfReadInput())
    s0.arbitrationFrom(io.port.cmd)
    s0.payload.assignSomeByName(io.port.cmd.payload)

    val useRs1, useRs2, useRs3, useRd = False
    switch(s0.opcode){
      is(p.Opcode.LOAD){
        useRd := True
      }
      is(p.Opcode.STORE){
        useRs2 := True
      }
      is(p.Opcode.ADD){
        useRs1 := True
        useRs2 := True
        useRd  := True
      }
      is(p.Opcode.MUL){
        useRs1 := True
        useRs2 := True
        useRd  := True
      }
      is(p.Opcode.FMA){
        useRs1 := True
        useRs2 := True
        useRs3 := True //Can be delayed to have less hazard
        useRd  := True
      }
    }

    val hits = List((useRs1, s0.rs1), (useRs2, s0.rs2), (useRs3, s0.rs3), (useRd, s0.rd)).map{case (use, reg) => use && rf.lock.map(l => l.valid && l.source === s0.source && l.address === reg).orR}
    val hazard = hits.orR
    when(s0.fire && useRd){
      for(i <- 0 until rfLockCount){
        when(rf.lockFreeId(i)){
          rf.lock(i).valid := True
          rf.lock(i).source := s0.source
          rf.lock(i).address := s0.rd
        }
      }
    }

    val s1 = s0.haltWhen(hazard || !rf.lockFree).m2sPipe()
    val output = s1.swapPayload(RfReadOutput())
    val s1LockId = RegNextWhen(OHToUInt(rf.lockFreeId), !output.isStall)
    output.source := s1.source
    output.opcode := s1.opcode
    output.lockId := s1LockId
    output.rd := s1.rd
    output.rs1 := rf.ram.readSync(s0.rs1,enable = !output.isStall)
    output.rs2 := rf.ram.readSync(s0.rs2,enable = !output.isStall)
    output.rs3 := rf.ram.readSync(s0.rs3,enable = !output.isStall)
  }

  val decode = new Area{
    val input = read.output.combStage()
    input.ready := False

    val loadHit = input.opcode === p.Opcode.LOAD
    val load = Stream(LoadInput())
    load.valid := input.valid && loadHit
    input.ready setWhen(loadHit && load.ready)
    load.source := read.output.source
    load.rd     := read.output.rd
    load.rs1    := read.output.rs1
    load.lockId := read.output.lockId

    val storeHit = input.opcode === p.Opcode.STORE
    val store = Stream(StoreInput())
    input.ready setWhen(storeHit && store.ready)
    store.valid := input.valid && storeHit
    store.source := read.output.source
    store.rs2    := read.output.rs2


    val fmaHit = input.opcode === p.Opcode.FMA
    val mulHit = input.opcode === p.Opcode.MUL || fmaHit
    val mul = Stream(MulInput())
    input.ready setWhen(mulHit && mul.ready)
    mul.valid := input.valid && mulHit
    mul.source := read.output.source
    mul.rs1    := read.output.rs1
    mul.rs2    := read.output.rs2
    mul.rs3    := read.output.rs3
    mul.rd     := read.output.rd
    mul.lockId := read.output.lockId
    mul.add    := fmaHit
    mul.minus  := False //TODO

    val addHit = input.opcode === p.Opcode.ADD
    val add = Stream(AddInput())
    val mulToAdd = Stream(AddInput())

    input.ready setWhen(addHit && add.ready && !mulToAdd.valid)
    add.valid := input.valid && addHit || mulToAdd.valid


    mulToAdd.ready := add.ready
    add.payload := mulToAdd.payload
    when(!mulToAdd.valid) {
      add.payload.assignSomeByName(read.output.payload)
    }


  }

  val load = new Area{
    def input = decode.load

    val output = input.stage()
  }


  val store = new Area{
    val input = decode.store.stage()

    input.ready := io.port.rsp.ready
    when(input.valid){
      io.port.rsp.valid := True
      io.port.rsp.source := input.source
      io.port.rsp.value := input.rs2.asBits
    }
  }

  val mul = new Area{
    val input = decode.mul.stage()

    val math = new Area {
      val mulA = U"1" @@ input.rs1.mantissa
      val mulB = U"1" @@ input.rs2.mantissa
      val mulC = mulA * mulB
      val exp = input.rs1.exponent +^ input.rs2.exponent - ((1 << p.internalExponentSize - 1) - 1)
    }

    val norm = new Area{
      val needShift = math.mulC.msb
      val exp = math.exp + U(needShift)
      val man = needShift ? math.mulC(p.internalMantissaSize + 1, p.internalMantissaSize bits) | math.mulC(p.internalMantissaSize, p.internalMantissaSize bits)

      val output = FpuFloat(p.internalExponentSize, p.internalMantissaSize)
      output.sign := input.rs1.sign ^ input.rs2.sign
      output.exponent := exp.resized
      output.mantissa := man
    }

    val output = Stream(WriteInput())
    output.valid  := input.valid && !input.add
    output.source := input.source
    output.lockId := input.lockId
    output.rd     := input.rd
    output.value  := norm.output

    decode.mulToAdd.valid := input.valid && input.add
    decode.mulToAdd.source := input.source
    decode.mulToAdd.rs1.mantissa := norm.output.mantissa
    decode.mulToAdd.rs1.exponent := norm.output.exponent
    decode.mulToAdd.rs1.sign := norm.output.sign ^ input.minus
    decode.mulToAdd.rs2 := input.rs3
    decode.mulToAdd.rd := input.rd
    decode.mulToAdd.lockId := input.lockId

    input.ready := (input.add ? decode.mulToAdd.ready | output.ready)
  }

  val add = new Area{
    val input = decode.add.stage()

    val shifter = new Area {
      val exp21 = input.rs2.exponent - input.rs1.exponent
      val rs1ExponentBigger = exp21.msb
      val rs1ExponentEqual = input.rs1.exponent === input.rs2.exponent
      val rs1MantissaBigger = input.rs1.mantissa > input.rs2.mantissa
      val absRs1Bigger = rs1ExponentBigger|| rs1ExponentEqual && rs1MantissaBigger
      val shiftBy = rs1ExponentBigger ? (0-exp21) | exp21

      //Note that rs1ExponentBigger can be replaced by absRs1Bigger bellow to avoid xsigned two complement in math block at expense of combinatorial path
      val xySign = absRs1Bigger ? input.rs1.sign | input.rs2.sign
      val xSign = xySign ^ (rs1ExponentBigger ? input.rs1.sign | input.rs2.sign)
      val ySign = xySign ^ (rs1ExponentBigger ? input.rs2.sign | input.rs1.sign)
      val xMantissa = U"1" @@ (rs1ExponentBigger ? input.rs1.mantissa | input.rs2.mantissa)
      val yMantissaUnshifted = U"1" @@ (rs1ExponentBigger ? input.rs2.mantissa | input.rs1.mantissa)
      val yMantissa = yMantissaUnshifted >> shiftBy
      val xyExponent = rs1ExponentBigger ? input.rs1.exponent | input.rs2.exponent
    }

    val math = new Area {
      def xSign = shifter.xSign
      def ySign = shifter.ySign
      def xMantissa = shifter.xMantissa
      def yMantissa = shifter.yMantissa
      def xyExponent = shifter.xyExponent
      def xySign = shifter.xySign

      val xSigned = xMantissa.twoComplement(xSign)
      val ySigned = yMantissa.twoComplement(ySign)
      val xyMantissa = U(xSigned +^ ySigned).trim(1 bits)
    }

    val norm = new Area{
      def xyExponent = math.xyExponent
      def xyMantissa = math.xyMantissa
      def xySign = math.xySign

      val shiftOh = OHMasking.first(xyMantissa.asBools.reverse)
      val shift = OHToUInt(shiftOh)
      val mantissa = (xyMantissa |<< shift) >> 1
      val exponent = xyExponent - shift + 1
    }


    val output = input.swapPayload(WriteInput())
    output.source := input.source
    output.lockId := input.lockId
    output.rd     := input.rd
    output.value.sign := norm.xySign
    output.value.mantissa := norm.mantissa.resized
    output.value.exponent := norm.exponent
  }


  val write = new Area{
    val port = rf.ram.writePort
    port.valid := False
    port.payload.assignDontCare()


    val lockFree = Flow(lockIdType)
    lockFree.valid := port.fire
    lockFree.payload.assignDontCare()

    load.output.ready := False
    mul.output.ready := False
    add.output.ready := True
    io.port.commit.ready := False
    when(add.output.valid) {
      port.valid := True
      port.address := add.output.source @@ add.output.rd
      port.data := add.output.value

      lockFree.payload := add.output.lockId
    } elsewhen(mul.output.valid) {
      port.valid := True
      port.address := mul.output.source @@ mul.output.rd
      port.data := mul.output.value

      mul.output.ready := True
      lockFree.payload := mul.output.lockId
    } elsewhen(load.output.valid && io.port.commit.valid) {
      port.valid := io.port.commit.write
      port.address := load.output.source @@ load.output.rd
      port.data.assignFromBits(io.port.commit.value)

      load.output.ready := True
      io.port.commit.ready := True
      lockFree.payload := load.output.lockId
    }

    when(lockFree.fire){
      for(i <- 0 until rfLockCount) when(lockFree.payload === i){
        rf.lock(i).valid := False
      }
    }
  }
}




object StreamFifoMultiChannelBench extends App{
  val payloadType = HardType(Bits(8 bits))
  class Fpu(name : String, p : FpuParameter) extends Rtl{
    override def getName(): String = "Fpu_" + name
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new FpuCore(p){

      setDefinitionName(Fpu.this.getName())
    })
  }



  val rtls = ArrayBuffer[Fpu]()
  rtls += new Fpu(
    "32",
    FpuParameter(
      internalMantissaSize = 23,
      withDouble = false,
      sourceWidth = 0
    )
  )
  rtls += new Fpu(
    "64",
    FpuParameter(
      internalMantissaSize = 52,
      withDouble = true,
      sourceWidth = 0
    )
  )

  val targets = XilinxStdTargets()// ++ AlteraStdTargets()


  Bench(rtls, targets)
}