package vexriscv.ip.fpu

import spinal.core._
import spinal.lib._
import spinal.lib.eda.bench.{Bench, Rtl, XilinxStdTargets}

import scala.collection.mutable.ArrayBuffer

object FpuDivSqrtIterationState extends SpinalEnum{
  val IDLE, YY, XYY, Y2_XYY, DIV, _15_XYY2, Y_15_XYY2, Y_15_XYY2_RESULT, SQRT = newElement()
}

//TODO cleanup rounding
case class FpuCore( portCount : Int, p : FpuParameter) extends Component{
  val io = new Bundle {
    val port = Vec(slave(FpuPort(p)), portCount)
  }

  val portCountWidth = log2Up(portCount)
  val Source = HardType(UInt(portCountWidth bits))
  val exponentOne = (1 << p.internalExponentSize-1) - 1

  val rfLockCount = 5
  val lockIdType = HardType(UInt(log2Up(rfLockCount) bits))

  case class RfReadInput() extends Bundle{
    val source = Source()
    val opcode = p.Opcode()
    val rs1, rs2, rs3 = p.rfAddress()
    val rd = p.rfAddress()
    val value = Bits(32 bits)
    val arg = p.Arg()
  }

  case class RfReadOutput() extends Bundle{
    val source = Source()
    val opcode = p.Opcode()
    val lockId = lockIdType()
    val rs1, rs2, rs3 = p.internalFloating()
    val rd = p.rfAddress()
    val value = Bits(32 bits)
    val arg = p.Arg()
  }


  case class LoadInput() extends Bundle{
    val source = Source()
    val rd = p.rfAddress()
    val lockId = lockIdType()
    val i2f = Bool()
    val arg = Bits(2 bits)
  }

  case class ShortPipInput() extends Bundle{
    val source = Source()
    val opcode = p.Opcode()
    val rs2 = p.internalFloating()
    val rs1Raw = Bits(widthOf(rs2) bits)
    val lockId = lockIdType()
    val rd = p.rfAddress()
    val value = Bits(32 bits)
    val arg = Bits(2 bits)
    def rs1 = rs1Raw.as(p.internalFloating)
  }

  case class MulInput() extends Bundle{
    val source = Source()
    val rs1, rs2, rs3 = p.internalFloating()
    val rd = p.rfAddress()
    val lockId = lockIdType()
    val add = Bool()
    val divSqrt = Bool()
    val msb1, msb2 = Bool() //allow usage of msb bits of mul
  }


  case class DivSqrtInput() extends Bundle{
    val source = Source()
    val rs1, rs2 = p.internalFloating()
    val rd = p.rfAddress()
    val lockId = lockIdType()
    val div = Bool()
  }


  case class AddInput() extends Bundle{
    val source = Source()
    val rs1, rs2 = p.internalFloating()
    val rd = p.rfAddress()
    val lockId = lockIdType()
  }

  case class WriteInput() extends Bundle{
    val source = Source()
    val lockId = lockIdType()
    val rd = p.rfAddress()
    val value = p.internalFloating()
  }


  val rf = new Area{
    val ram = Mem(p.internalFloating, 32*portCount)
    val lock = for(i <- 0 until rfLockCount) yield new Area{
      val valid = RegInit(False)
      val source = Reg(Source())
      val address = Reg(p.rfAddress)
      val id = Reg(UInt(log2Up(rfLockCount) bits))
      val commited = Reg(Bool)
      val write = Reg(Bool)
    }
    val lockFree = !lock.map(_.valid).andR
    val lockFreeId = OHMasking.first(lock.map(!_.valid))
  }

  val completion = for(source <- 0 until portCount) yield new Area{
    def port = io.port(source)
    port.completion.flag.NV := False
    port.completion.flag.DZ := False
    port.completion.flag.OF := False
    port.completion.flag.UF := False
    port.completion.flag.NX := False

    val increments = ArrayBuffer[Bool]()

//    def increment(): Unit ={
//      //This is a SpinalHDL trick which allow to go back in time
//      val swapContext =  dslBody.swap()
//      val cond = False
//      swapContext.appendBack()
//
//      cond := True
//      incs += cond
//    }

    afterElaboration{
      port.completion.count := increments.map(_.asUInt.resize(log2Up(increments.size + 1))).reduceBalancedTree(_ + _)
    }
  }

  val commitFork = new Area{
    val load, commit = Vec(Stream(FpuCommit(p)), portCount)
    for(i <- 0 until portCount){
      val fork = new StreamFork(FpuCommit(p), 2)
      fork.io.input << io.port(i).commit
      fork.io.outputs(0) >> load(i)
      fork.io.outputs(1) >> commit(i)
    }
  }

  val commitLogic = for(source <- 0 until portCount) yield new Area{
    val fire = False
    val target, hit = Reg(UInt(log2Up(rfLockCount) bits)) init(0)
    when(fire){
      hit := hit + 1
    }

    commitFork.commit(source).ready := False
    when(commitFork.commit(source).valid) {
      for (lock <- rf.lock) {
        when(lock.valid && lock.source === source && lock.id === hit) {
          fire := True
          lock.commited := True
          lock.write := commitFork.commit(source).write
          commitFork.commit(source).ready := True
        }
      }
    }
  }

  val read = new Area{
    val arbiter = StreamArbiterFactory.noLock.lowerFirst.build(FpuCmd(p), portCount)
    arbiter.io.inputs <> Vec(io.port.map(_.cmd))

    val s0 = Stream(RfReadInput())
    s0.arbitrationFrom(arbiter.io.output)
    s0.source := arbiter.io.chosen
    s0.payload.assignSomeByName(arbiter.io.output.payload)

    val useRs1, useRs2, useRs3, useRd = False
    switch(s0.opcode){
      is(p.Opcode.LOAD)    {  useRd := True }
      is(p.Opcode.STORE)   { useRs1 := True }
      is(p.Opcode.ADD)     { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.MUL)     { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.DIV)     { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.SQRT)    { useRd  := True; useRs1 := True }
      is(p.Opcode.FMA)     { useRd  := True; useRs1 := True; useRs2 := True; useRs3 := True }
      is(p.Opcode.I2F)     { useRd  := True }
      is(p.Opcode.F2I)     { useRs1 := True }
      is(p.Opcode.MIN_MAX) { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.CMP)     { useRs1 := True; useRs2 := True }
      is(p.Opcode.SGNJ)    { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.FMV_X_W) { useRs1 := True }
      is(p.Opcode.FMV_W_X) { useRd  := True }
      is(p.Opcode.FCLASS ) { useRs1  := True }
    }

    val hits = List((useRs1, s0.rs1), (useRs2, s0.rs2), (useRs3, s0.rs3), (useRd, s0.rd)).map{case (use, reg) => use && rf.lock.map(l => l.valid && l.source === s0.source && l.address === reg).orR}
    val hazard = hits.orR
    when(s0.fire && useRd){
      for(i <- 0 until portCount){
        when(s0.source === i){
          commitLogic(i).target := commitLogic(i).target + 1
        }
      }
      for(i <- 0 until rfLockCount){
        when(rf.lockFreeId(i)){
          rf.lock(i).valid := True
          rf.lock(i).source := s0.source
          rf.lock(i).address := s0.rd
          rf.lock(i).id := commitLogic.map(_.target).read(s0.source)
          rf.lock(i).commited := False
        }
      }
    }

    val s1 = s0.haltWhen(hazard || !rf.lockFree).m2sPipe()
    val output = s1.swapPayload(RfReadOutput())
    val s1LockId = RegNextWhen(OHToUInt(rf.lockFreeId), !output.isStall)
    output.source := s1.source
    output.opcode := s1.opcode
    output.lockId := s1LockId
    output.value := s1.value
    output.arg := s1.arg
    output.rd := s1.rd
    output.rs1 := rf.ram.readSync(s0.source @@ s0.rs1,enable = !output.isStall)
    output.rs2 := rf.ram.readSync(s0.source @@ s0.rs2,enable = !output.isStall)
    output.rs3 := rf.ram.readSync(s0.source @@ s0.rs3,enable = !output.isStall)
  }

  val decode = new Area{
    val input = read.output.combStage()
    input.ready := False

    val loadHit = List(FpuOpcode.LOAD, FpuOpcode.FMV_W_X, FpuOpcode.I2F).map(input.opcode === _).orR
    val load = Stream(LoadInput())
    load.valid := input.valid && loadHit
    input.ready setWhen(loadHit && load.ready)
    load.payload.assignSomeByName(read.output.payload)
    load.i2f := input.opcode === FpuOpcode.I2F

    val shortPipHit = List(FpuOpcode.STORE, FpuOpcode.F2I, FpuOpcode.CMP, FpuOpcode.MIN_MAX, FpuOpcode.SGNJ, FpuOpcode.FMV_X_W, FpuOpcode.FCLASS).map(input.opcode === _).orR
    val shortPip = Stream(ShortPipInput())
    input.ready setWhen(shortPipHit && shortPip.ready)
    shortPip.valid := input.valid && shortPipHit
    shortPip.payload.assignSomeByName(read.output.payload)
    shortPip.rs1Raw := read.output.rs1.asBits

    val divSqrtHit = input.opcode === p.Opcode.DIV ||  input.opcode === p.Opcode.SQRT
    val divSqrt = Stream(DivSqrtInput())
    input.ready setWhen(divSqrtHit && divSqrt.ready)
    divSqrt.valid := input.valid && divSqrtHit
    divSqrt.payload.assignSomeByName(read.output.payload)
    divSqrt.div    := input.opcode === p.Opcode.DIV

    val fmaHit = input.opcode === p.Opcode.FMA
    val mulHit = input.opcode === p.Opcode.MUL || fmaHit
    val mul = Stream(MulInput())
    val divSqrtToMul = Stream(MulInput())

    input.ready setWhen(mulHit && mul.ready && !divSqrtToMul.valid)
    mul.valid := input.valid && mulHit || divSqrtToMul.valid

    divSqrtToMul.ready := mul.ready
    mul.payload := divSqrtToMul.payload
    when(!divSqrtToMul.valid) {
      mul.payload.assignSomeByName(read.output.payload)
      mul.add := fmaHit
      mul.divSqrt := False
      mul.msb1 := True
      mul.msb2 := True
      mul.rs2.sign.allowOverride(); mul.rs2.sign := read.output.rs2.sign ^ input.arg(0)
      mul.rs3.sign.allowOverride(); mul.rs3.sign := read.output.rs3.sign ^ input.arg(1)
    }

    val addHit = input.opcode === p.Opcode.ADD
    val add = Stream(AddInput())
    val mulToAdd = Stream(AddInput())

    input.ready setWhen(addHit && add.ready && !mulToAdd.valid)
    add.valid := input.valid && addHit || mulToAdd.valid


    mulToAdd.ready := add.ready
    add.payload := mulToAdd.payload
    when(!mulToAdd.valid) {
      add.payload.assignSomeByName(read.output.payload)
      add.rs2.sign.allowOverride; add.rs2.sign := read.output.rs2.sign ^ input.arg(0)
    }
  }

  val load = new Area{

    case class S0() extends Bundle{
      val source = Source()
      val lockId = lockIdType()
      val rd = p.rfAddress()
      val value = p.storeLoadType()
      val i2f = Bool()
      val arg = Bits(2 bits)
    }

    val s0 = new Area{
      val input = decode.load.stage()
      val filtred = commitFork.load.map(port => port.takeWhen(port.sync))
      def feed = filtred(input.source)
      val hazard = !feed.valid

      val output = input.haltWhen(hazard).swapPayload(S0())
      filtred.foreach(_.ready := False)
      feed.ready := input.valid && output.ready
      output.source := input.source
      output.lockId := input.lockId
      output.rd := input.rd
      output.value := feed.value
      output.i2f := input.i2f
      output.arg := input.arg
    }


//    val i2fSign = input.arg(0) && input.value.msb
//    val i2fUnsigned = input.value.asUInt.twoComplement(i2fSign).resize(32 bits)
//    val i2fLog2 = OHToUInt(OHMasking.last(i2fUnsigned))
//    val i2fShifted = (i2fUnsigned << p.internalMantissaSize) >> i2fLog2
//    rfOutput.value.sign := i2fSign
//    rfOutput.value.exponent := i2fLog2 +^ exponentOne
//    rfOutput.value.mantissa := U(i2fShifted).resized
//    rfOutput.value.special := False //TODO

    val s1 = new Area{
      val input = s0.output.stage()
      val busy = False

      val f32Mantissa = input.value(0, 23 bits).asUInt
      val f32Exponent = input.value(23, 8 bits).asUInt
      val f32Sign     = input.value(31)

      val expZero = f32Exponent === 0
      val expOne =  f32Exponent === 255
      val manZeroReject = Reg(Bool()) setWhen(busy) clearWhen(!input.isStall)
      val manZero = f32Mantissa === 0 && !manZeroReject

      val isZero      =  expZero &&  manZero
      val isSubnormal =  expZero && !manZero
      val isNormal    = !expOne  && !expZero
      val isInfinity  =  expOne  &&  manZero
      val isNan       =  expOne  && !manZero
      val isQuiet     = f32Mantissa.msb

      val fsm = new Area{
        val manTop = Reg(UInt(log2Up(p.internalMantissaSize) bits))
        val shift =  CombInit(manTop)
        val counter = Reg(UInt(log2Up(p.internalMantissaSize+1) bits))
        val done, boot, patched = Reg(Bool())
        val ohInput = CombInit(input.value(0, 32 max p.internalMantissaSize bits))
        when(!input.i2f) { ohInput(9, 23 bits) := input.value(0, 23 bits) }
        val i2fZero = Reg(Bool)
        when(input.valid && (input.i2f || isSubnormal) && !done){
          busy := True
          when(boot){
            when(input.i2f && !patched && input.value.msb && input.arg(0)){
              input.value.getDrivingReg(0, 32 bits) := B(input.value.asUInt.twoComplement(True).resize(32 bits))
              patched := True
            } otherwise {
              manTop := OHToUInt(OHMasking.first((ohInput).reversed))
              boot := False
              i2fZero := input.value(31 downto 0) === 0
            }
          } otherwise {
            when(input.i2f){
              input.value.getDrivingReg(0, 32 bits) := input.value(0, 32 bits) |<< 1
            } otherwise {
              input.value.getDrivingReg(0, 23 bits) := input.value(0, 23 bits) |<< 1
            }
            counter := counter + 1
            when(counter === shift) {
              done := True
            }
          }
        }

        val expOffset = (UInt(p.internalExponentSize bits))
        expOffset := 0
        when(isSubnormal){
          expOffset := manTop.resized
        }

        when(!input.isStall){
          counter := 0
          done := False
          boot := True
          patched := False
        }
      }


      val i2fSign = fsm.patched
      val i2fShifted = input.value.takeHigh(23)

      val recoded = p.internalFloating()
      recoded.mantissa := f32Mantissa
      recoded.exponent := (f32Exponent -^ fsm.expOffset + (exponentOne - 127)).resized
      recoded.sign     := f32Sign
      recoded.setNormal
      when(isZero){recoded.setZero}
      when(isInfinity){recoded.setInfinity}
      when(isNan){recoded.setNan}

      val output = input.haltWhen(busy).swapPayload(WriteInput())
      output.source := input.source
      output.lockId := input.lockId
      output.rd := input.rd
      output.value := recoded
      when(input.i2f){
        output.value.sign := i2fSign
        output.value.exponent := (U(exponentOne+31) - fsm.manTop).resized
        output.value.mantissa := U(i2fShifted)
        output.value.setNormal
        when(fsm.i2fZero) { output.value.setZero }
      }
    }
  }

  val shortPip = new Area{
    val input = decode.shortPip.stage()

    val rfOutput = Stream(WriteInput())

    val result = p.storeLoadType().assignDontCare()

    val recoded = CombInit(input.rs1)


    val halt = False
    val recodedResult =  Bits(32 bits)//recoded.asBits.resize(32 bits)
    val f32 = new Area{
      val exp = (recoded.exponent - (exponentOne-127)).resize(8 bits)
      val man = recoded.mantissa
    }
    recodedResult := recoded.sign ## f32.exp ## f32.man

    val isSubnormal = !recoded.special && recoded.exponent <= exponentOne - 127
    val fsm = new Area{
      val f2iShift = input.rs1.exponent - U(exponentOne)
      val isF2i = input.opcode === FpuOpcode.F2I
      val needRecoding = List(FpuOpcode.FMV_X_W, FpuOpcode.STORE).map(_ === input.opcode).orR && isSubnormal
      val manTop = Reg(UInt(log2Up(p.internalMantissaSize) bits))
      val counter = Reg(UInt(log2Up(p.internalMantissaSize+1) bits))
      val done, boot = Reg(Bool())
      val isZero = input.rs1.isZero// || input.rs1.exponent < exponentOne-1
      val overflow = input.rs1.exponent > (input.arg(0) ? U(exponentOne+30) | U(exponentOne+31)) && !input.rs1.sign
      val underflow = input.rs1.exponent > (input.arg(0) ? U(exponentOne+30) | U(exponentOne-1)) && input.rs1.sign  // && !(input.arg(0) && input.rs1.exponent === exponentOne-31 && input.rs)

      when(input.valid && (needRecoding || isF2i) && !done){
        halt := True
        when(boot){
          when(isF2i){
            when(underflow || overflow){
              done := True
              val low = overflow
              val high = input.arg(0) ^ overflow
              input.rs1Raw.getDrivingReg(0, 32 bits) := (31 -> high, default -> low)
            } otherwise {
              manTop := (U(exponentOne + 31) - input.rs1.exponent).resized //TODO merge
              input.rs1Raw.getDrivingReg(0, 32 bits) := input.rs1Raw(0, 23 bits) << 9
            }
          } otherwise {
            manTop := (U(exponentOne - 127) - recoded.exponent).resized
          }
          boot := False

        } otherwise {
          when(isF2i){
            input.rs1Raw.getDrivingReg(0, 32 bits) := (B(counter === 0 && !isZero) ## input.rs1Raw(0, 32 bits)) >> 1
          } otherwise {
            input.rs1Raw.getDrivingReg(0, 23 bits) := (B(counter === 0) ## input.rs1Raw(0, 23 bits)) >> 1
          }
          counter := counter + 1
          when(counter === manTop) {
            done := True
          }
        }
      }

      when(isSubnormal){
        f32.exp := 0
      }
      when(!input.isStall){
        counter := 0
        done := False
        boot := True
      }
    }

    when(recoded.special){
      switch(input.rs1.exponent(1 downto 0)){
        is(FpuFloat.ZERO){
          recodedResult(0,23 bits).clearAll()
          recodedResult(23, 8 bits).clearAll()
        }
        is(FpuFloat.INFINITY){
          recodedResult(0, 23 bits).clearAll()
          recodedResult(23, 8 bits).setAll()
        }
        is(FpuFloat.NAN){
          recodedResult(23, 8 bits).setAll()
        }
      }
    }


//    val f2iShift = input.rs1.exponent - U(exponentOne)
//    val f2iShifted = (U"1" @@ input.rs1.mantissa) << (f2iShift.resize(5 bits))
//    val f2iUnsigned = f2iShifted >> p.internalMantissaSize
//    val f2iResult = (f2iUnsigned.twoComplement(input.arg(0) && input.rs1.sign)).asBits.resize(32 bits)
    val f2iUnsigned = input.rs1Raw(0, 32 bits).asUInt
    val f2iResult = (f2iUnsigned.twoComplement(input.arg(0) && input.rs1.sign)).asBits.resize(32 bits)

    val bothZero = input.rs1.isZero && input.rs2.isZero
    val rs1Equal = input.rs1 === input.rs2
    val rs1AbsSmaller = (input.rs1.exponent @@ input.rs1.mantissa) < (input.rs2.exponent @@ input.rs2.mantissa)
    rs1AbsSmaller.setWhen(input.rs2.isInfinity)
    rs1AbsSmaller.setWhen(input.rs1.isZero)
    rs1AbsSmaller.clearWhen(input.rs2.isZero)
    rs1AbsSmaller.clearWhen(input.rs1.isInfinity)
    val rs1Smaller = (input.rs1.sign ## input.rs2.sign).mux(
      0 -> rs1AbsSmaller,
      1 -> False,
      2 -> True,
      3 -> (!rs1AbsSmaller && !rs1Equal)
    )


    val minMaxResult = ((rs1Smaller ^ input.arg(0)) && !input.rs1.isNan || input.rs2.isNan) ? input.rs1 | input.rs2
    val cmpResult = B(rs1Smaller && !bothZero && !input.arg(1) || (rs1Equal || bothZero) && !input.arg(0))
    when(input.rs1.isNan || input.rs2.isNan) { cmpResult := 0 }
    val sgnjResult = (input.rs1.sign && input.arg(1)) ^ input.rs2.sign ^ input.arg(0)
    val fclassResult = B(0, 32 bits)
    val decoded = input.rs1.decode()
    fclassResult(0) :=  input.rs1.sign &&  decoded.isInfinity
    fclassResult(1) :=  input.rs1.sign &&  decoded.isNormal
    fclassResult(2) :=  input.rs1.sign &&  isSubnormal //TODO
    fclassResult(3) :=  input.rs1.sign &&  decoded.isZero
    fclassResult(4) := !input.rs1.sign &&  decoded.isZero
    fclassResult(5) := !input.rs1.sign &&  isSubnormal //TODO
    fclassResult(6) := !input.rs1.sign &&  decoded.isNormal
    fclassResult(7) := !input.rs1.sign &&  decoded.isInfinity
    fclassResult(8) :=   decoded.isNan && !decoded.isQuiet
    fclassResult(9) :=   decoded.isNan &&  decoded.isQuiet


    switch(input.opcode){
      is(FpuOpcode.STORE)   { result := recodedResult }
      is(FpuOpcode.FMV_X_W) { result := recodedResult } //TODO
      is(FpuOpcode.F2I)     { result := f2iResult }
      is(FpuOpcode.CMP)     { result := cmpResult.resized } //TODO
      is(FpuOpcode.FCLASS)  { result := fclassResult.resized }
    }

    val toFpuRf = List(FpuOpcode.MIN_MAX, FpuOpcode.SGNJ).map(input.opcode === _).orR

    rfOutput.valid := input.valid && toFpuRf && !halt
    rfOutput.source := input.source
    rfOutput.lockId := input.lockId
    rfOutput.rd := input.rd
    rfOutput.value.assignDontCare()
    switch(input.opcode){
      is(FpuOpcode.MIN_MAX){
        rfOutput.value := minMaxResult
      }
      is(FpuOpcode.SGNJ){
        rfOutput.value.sign     := sgnjResult
        rfOutput.value.exponent := input.rs1.exponent
        rfOutput.value.mantissa := input.rs1.mantissa
        rfOutput.value.special := False //TODO
      }
    }

    input.ready := !halt && (toFpuRf ? rfOutput.ready | io.port.map(_.rsp.ready).read(input.source))
    for(i <- 0 until portCount){
      def rsp = io.port(i).rsp
      rsp.valid := input.valid && input.source === i && !toFpuRf && !halt
      rsp.value := result
      completion(i).increments += (RegNext(rsp.fire) init(False))
    }
  }

  val mul = new Area{
    val input = decode.mul.stage()

    val math = new Area {
      val mulA = U(input.msb1) @@ input.rs1.mantissa
      val mulB = U(input.msb2) @@ input.rs2.mantissa
      val mulC = mulA * mulB
      val exp = input.rs1.exponent +^ input.rs2.exponent
    }

    val norm = new Area{
//      val needShift = math.mulC.msb
//      val exp = math.exp + U(needShift)
//      val man = needShift ? math.mulC(p.internalMantissaSize + 1, p.internalMantissaSize bits) | math.mulC(p.internalMantissaSize, p.internalMantissaSize bits)

      val mulRounded = (math.mulC >> p.internalMantissaSize)  + math.mulC(p.internalMantissaSize-1).asUInt
      val needShift = mulRounded.msb
      val exp = math.exp + U(needShift)
      val man = needShift ? mulRounded(1, p.internalMantissaSize bits) | mulRounded(0, p.internalMantissaSize bits)

      val forceZero = input.rs1.isZero || input.rs2.isZero
      val forceUnderflow = exp <= exponentOne + exponentOne - 127 - 23  // 0x6A //TODO
      val forceOverflow = exp > exponentOne + exponentOne + 127 || input.rs1.isInfinity || input.rs2.isInfinity
      val forceNan = input.rs1.isNan || input.rs2.isNan || ((input.rs1.isInfinity || input.rs2.isInfinity) && (input.rs1.isZero || input.rs2.isZero))

      val output = FpuFloat(p.internalExponentSize, p.internalMantissaSize)
      output.sign := input.rs1.sign ^ input.rs2.sign
      output.exponent := (exp - exponentOne).resized
      output.mantissa := man
      output.setNormal

      when(forceNan) {
        output.setNanQuiet
      } elsewhen(forceOverflow) {
        output.setInfinity
      } elsewhen(forceZero) {
        output.setZero
      } elsewhen(forceUnderflow) {
        output.setZero
      }

    }

    val notMul = new Area{
      val output = Flow(UInt(p.internalMantissaSize + 1 bits))
      output.valid := input.valid && input.divSqrt
      output.payload := math.mulC(p.internalMantissaSize, p.internalMantissaSize+1 bits)
    }

    val output = Stream(WriteInput())
    output.valid  := input.valid && !input.add && !input.divSqrt
    output.source := input.source
    output.lockId := input.lockId
    output.rd     := input.rd
    output.value  := norm.output

    decode.mulToAdd.valid := input.valid && input.add
    decode.mulToAdd.source := input.source
    decode.mulToAdd.rs1.mantissa := norm.output.mantissa
    decode.mulToAdd.rs1.exponent := norm.output.exponent
    decode.mulToAdd.rs1.sign := norm.output.sign
    decode.mulToAdd.rs1.special := False //TODO
    decode.mulToAdd.rs2 := input.rs3
    decode.mulToAdd.rd := input.rd
    decode.mulToAdd.lockId := input.lockId

    input.ready := (input.add ? decode.mulToAdd.ready | output.ready) || input.divSqrt
  }

  val divSqrt = new Area {
    val input = decode.divSqrt.stage()

    val aproxWidth = 8
    val aproxDepth = 64
    val divIterationCount = 3
    val sqrtIterationCount = 3

    val mulWidth = p.internalMantissaSize + 1

    import FpuDivSqrtIterationState._
    val state     = RegInit(FpuDivSqrtIterationState.IDLE())
    val iteration = Reg(UInt(log2Up(divIterationCount max sqrtIterationCount) bits))

    decode.divSqrtToMul.valid := False
    decode.divSqrtToMul.source := input.source
    decode.divSqrtToMul.rs1.assignDontCare()
    decode.divSqrtToMul.rs2.assignDontCare()
    decode.divSqrtToMul.rs3.assignDontCare()
    decode.divSqrtToMul.rd := input.rd
    decode.divSqrtToMul.lockId := input.lockId
    decode.divSqrtToMul.add := False
    decode.divSqrtToMul.divSqrt := True
    decode.divSqrtToMul.msb1 := True
    decode.divSqrtToMul.msb2 := True
    decode.divSqrtToMul.rs1.special := False //TODO
    decode.divSqrtToMul.rs2.special := False


    val aprox = new Area {
      val rom = Mem(UInt(aproxWidth bits), aproxDepth * 2)
      val divTable, sqrtTable = ArrayBuffer[Double]()
      for(i <- 0 until aproxDepth){
        val value = 1+(i+0.5)/aproxDepth
        divTable += 1/value
      }
      for(i <- 0 until aproxDepth){
        val scale = if(i < aproxDepth/2) 2 else 1
        val value = scale+(scale*(i%(aproxDepth/2)+0.5)/aproxDepth*2)
//        println(s"$i => $value" )
        sqrtTable += 1/Math.sqrt(value)
      }
      val romElaboration = (sqrtTable ++ divTable).map(v => BigInt(((v-0.5)*2*(1 << aproxWidth)).round))

      rom.initBigInt(romElaboration)
      val div = input.rs2.mantissa.takeHigh(log2Up(aproxDepth))
      val sqrt = U(input.rs1.exponent.lsb ## input.rs1.mantissa).takeHigh(log2Up(aproxDepth))
      val address = U(input.div ## (input.div ? div | sqrt))
      val raw = rom.readAsync(address)
      val result = U"01" @@ (raw << (mulWidth-aproxWidth-2))
    }

    val divExp = new Area{
      val value = (1 << p.internalExponentSize) - 3 - input.rs2.exponent
    }
    val sqrtExp = new Area{
      val value = ((1 << p.internalExponentSize-1) + (1 << p.internalExponentSize-2) - 2 -1) - (input.rs1.exponent >> 1) + U(!input.rs1.exponent.lsb)
    }

    def mulArg(rs1 : UInt, rs2 : UInt): Unit ={
      decode.divSqrtToMul.rs1.mantissa := rs1.resized
      decode.divSqrtToMul.rs2.mantissa := rs2.resized
      decode.divSqrtToMul.msb1 := rs1.msb
      decode.divSqrtToMul.msb2 := rs2.msb
    }

    val mulBuffer = mul.notMul.output.toStream.stage
    mulBuffer.ready := False

    val iterationValue = Reg(UInt(mulWidth bits))

    input.ready := False
    switch(state){
      is(IDLE){
        iterationValue := aprox.result
        iteration := 0
        when(input.valid) {
          state := YY
        }
      }
      is(YY){
        decode.divSqrtToMul.valid := True
        mulArg(iterationValue, iterationValue)
        when(decode.divSqrtToMul.ready) {
          state := XYY
        }
      }
      is(XYY){
        decode.divSqrtToMul.valid := mulBuffer.valid
        val sqrtIn = !input.rs1.exponent.lsb ? (U"1" @@ input.rs1.mantissa) | ((U"1" @@ input.rs1.mantissa) |>> 1)
        val divIn = U"1" @@ input.rs2.mantissa
        mulArg(input.div ? divIn| sqrtIn, mulBuffer.payload)
        when(mulBuffer.valid && decode.divSqrtToMul.ready) {
          state := (input.div ? Y2_XYY | _15_XYY2)
          mulBuffer.ready := True
        }
      }
      is(Y2_XYY){
        mulBuffer.ready := True
        when(mulBuffer.valid) {
          iterationValue := ((iterationValue << 1) - mulBuffer.payload).resized
          mulBuffer.ready := True
          iteration := iteration + 1
          when(iteration =/= divIterationCount-1){ //TODO
            state := YY
          } otherwise {
            state := DIV
          }
        }
      }
      is(DIV){
        decode.divSqrtToMul.valid := True
        decode.divSqrtToMul.divSqrt := False
        decode.divSqrtToMul.rs1 := input.rs1
        decode.divSqrtToMul.rs2.sign := input.rs2.sign
        decode.divSqrtToMul.rs2.exponent := divExp.value + iterationValue.msb.asUInt
        decode.divSqrtToMul.rs2.mantissa := (iterationValue << 1).resized
        val zero = input.rs2.isInfinity
        val overflow = input.rs2.isZero
        val nan = input.rs2.isNan || (input.rs1.isZero && input.rs2.isZero)

        when(nan){
          decode.divSqrtToMul.rs2.setNanQuiet
        } elsewhen(overflow) {
          decode.divSqrtToMul.rs2.setInfinity
        } elsewhen(zero) {
          decode.divSqrtToMul.rs2.setZero
        }
        when(decode.divSqrtToMul.ready) {
          state := IDLE
          input.ready := True
        }
      }
      is(_15_XYY2){
        when(mulBuffer.valid) {
          state := Y_15_XYY2
          mulBuffer.payload.getDrivingReg := (U"11" << mulWidth-2) - (mulBuffer.payload)
        }
      }
      is(Y_15_XYY2){
        decode.divSqrtToMul.valid := True
        mulArg(iterationValue, mulBuffer.payload)
        when(decode.divSqrtToMul.ready) {
          mulBuffer.ready := True
          state := Y_15_XYY2_RESULT
        }
      }
      is(Y_15_XYY2_RESULT){
        iterationValue := mulBuffer.payload
        mulBuffer.ready := True
        when(mulBuffer.valid) {
          iteration := iteration + 1
          when(iteration =/= sqrtIterationCount-1){
            state := YY
          } otherwise {
            state := SQRT
          }
        }
      }
      is(SQRT){
        decode.divSqrtToMul.valid := True
        decode.divSqrtToMul.divSqrt := False
        decode.divSqrtToMul.rs1 := input.rs1
        decode.divSqrtToMul.rs2.sign := False
        decode.divSqrtToMul.rs2.exponent := sqrtExp.value + iterationValue.msb.asUInt
        decode.divSqrtToMul.rs2.mantissa := (iterationValue << 1).resized

        val nan       = input.rs1.sign && !input.rs1.isZero

        when(nan){
          decode.divSqrtToMul.rs2.setNanQuiet
        }

        when(decode.divSqrtToMul.ready) {
          state := IDLE
          input.ready := True
        }
      }
    }
  }

  val add = new Area{
    val input = decode.add.stage()

    val shifter = new Area {
      val exp21 = input.rs2.exponent -^ input.rs1.exponent
      val rs1ExponentBigger = (exp21.msb || input.rs2.isZero) && !input.rs1.isZero
      val rs1ExponentEqual = input.rs1.exponent === input.rs2.exponent
      val rs1MantissaBigger = input.rs1.mantissa > input.rs2.mantissa
      val absRs1Bigger = ((rs1ExponentBigger || rs1ExponentEqual && rs1MantissaBigger) && !input.rs1.isZero || input.rs1.isInfinity) && !input.rs2.isInfinity
      val shiftBy = rs1ExponentBigger ? (0-exp21) | exp21
      val passThrough = shiftBy >= p.internalMantissaSize || (input.rs1.isZero) || (input.rs2.isZero)

      //Note that rs1ExponentBigger can be replaced by absRs1Bigger bellow to avoid xsigned two complement in math block at expense of combinatorial path
      val xySign = absRs1Bigger ? input.rs1.sign | input.rs2.sign
      val xSign = xySign ^ (rs1ExponentBigger ? input.rs1.sign | input.rs2.sign)
      val ySign = xySign ^ (rs1ExponentBigger ? input.rs2.sign | input.rs1.sign)
      val xMantissa = U"1" @@ (rs1ExponentBigger ? input.rs1.mantissa | input.rs2.mantissa) @@ U"0"
      val yMantissaUnshifted = U"1" @@ (rs1ExponentBigger ? input.rs2.mantissa | input.rs1.mantissa) @@ U"0"
      val yMantissa = yMantissaUnshifted >> (passThrough.asUInt @@ shiftBy.resize(log2Up(p.internalMantissaSize)))
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
//      val ySigned = (yMantissa +^ (yMantissa.lsb && !ySign).asUInt).twoComplement(ySign)
      val ySigned = ((ySign ## Mux(ySign, ~yMantissa, yMantissa)).asUInt +^ (ySign || yMantissa.lsb).asUInt).asSInt //rounding here
      val xyMantissa = U(xSigned + ySigned).trim(1 bits)
    }

    val norm = new Area{
      def xyExponent = math.xyExponent
      def xyMantissa = math.xyMantissa
      val xySign = CombInit(math.xySign)

      val shiftOh = OHMasking.first(xyMantissa.asBools.reverse)
      val shift = OHToUInt(shiftOh)
      val mantissa = (xyMantissa |<< shift) >> 2
//      val mantissaShifted = (xyMantissa |<< shift)
//      val mantissa = ((xyMantissa ) >> 2) + U(xyMantissa(1))
      val exponent = xyExponent -^ shift + 1
      xySign clearWhen(input.rs1.isZero && input.rs2.isZero)
      val forceZero = xyMantissa === 0 || exponent.msb || (input.rs1.isZero && input.rs2.isZero)
      val forceOverflow = exponent === exponentOne + 128 ||  (input.rs1.isInfinity || input.rs2.isInfinity)
      val forceNan = input.rs1.isNan || input.rs2.isNan || (input.rs1.isInfinity && input.rs2.isInfinity && (input.rs1.sign ^ input.rs2.sign))
    }


    val output = input.swapPayload(WriteInput())
    output.source := input.source
    output.lockId := input.lockId
    output.rd     := input.rd
    output.value.sign := norm.xySign
    output.value.mantissa := norm.mantissa.resized
    output.value.exponent := norm.exponent.resized
    output.value.special := False

    when(norm.forceNan) {
      output.value.setNanQuiet
    } elsewhen(norm.forceZero) {
      output.value.setZero
      when(norm.xyMantissa === 0 || input.rs1.isZero && input.rs2.isZero){
        output.value.sign := input.rs1.sign && input.rs2.sign
      }
    } elsewhen(norm.forceOverflow) {
      output.value.setInfinity
    }
  }


  val write = new Area{
    val arbitrated = StreamArbiterFactory.lowerFirst.noLock.on(List(load.s1.output, add.output, mul.output, shortPip.rfOutput))
    val isCommited = rf.lock.map(_.commited).read(arbitrated.lockId)
    val commited = arbitrated.haltWhen(!isCommited).toFlow

    for(i <- 0 until portCount){
      completion(i).increments += (RegNext(commited.fire && commited.source === i) init(False))
    }

    when(commited.valid){
      for(i <- 0 until rfLockCount) when(commited.lockId === i){
        rf.lock(i).valid := False
      }
    }

    val port = rf.ram.writePort
    port.valid := commited.valid && rf.lock.map(_.write).read(commited.lockId)
    port.address := commited.source @@ commited.rd
    port.data := commited.value

    when(port.valid){
      assert(!(port.data.exponent === 0 && !port.data.special), "Special violation")
      assert(!(port.data.exponent === port.data.exponent.maxValue && !port.data.special), "Special violation")
    }
  }
}




object FpuSynthesisBench extends App{
  val payloadType = HardType(Bits(8 bits))
  class Fpu(name : String, portCount : Int, p : FpuParameter) extends Rtl{
    override def getName(): String = "Fpu_" + name
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new FpuCore(portCount, p){

      setDefinitionName(Fpu.this.getName())
    })
  }

  class Shifter(width : Int) extends Rtl{
    override def getName(): String = "shifter_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new Component{
      val a = in UInt(width bits)
      val sel = in UInt(log2Up(width) bits)
      val result = out(a >> sel)
      setDefinitionName(Shifter.this.getName())
    })
  }

  class Rotate(width : Int) extends Rtl{
    override def getName(): String = "rotate_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new Component{
      val a = in UInt(width bits)
      val sel = in UInt(log2Up(width) bits)
      val result = out(Delay(Delay(a,3).rotateLeft(Delay(sel,3)),3))
      setDefinitionName(Rotate.this.getName())
    })
  }

//    rotate2_24 ->
//    Artix 7 -> 233 Mhz 96 LUT 167 FF
//  Artix 7 -> 420 Mhz 86 LUT 229 FF
//  rotate2_32 ->
//    Artix 7 -> 222 Mhz 108 LUT 238 FF
//  Artix 7 -> 399 Mhz 110 LUT 300 FF
//  rotate2_52 ->
//    Artix 7 -> 195 Mhz 230 LUT 362 FF
//  Artix 7 -> 366 Mhz 225 LUT 486 FF
//  rotate2_64 ->
//    Artix 7 -> 182 Mhz 257 LUT 465 FF
//  Artix 7 -> 359 Mhz 266 LUT 591 FF
  class Rotate2(width : Int) extends Rtl{
    override def getName(): String = "rotate2_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new Component{
      val a = in UInt(width bits)
      val sel = in UInt(log2Up(width) bits)
      val result = out(Delay((U(0, width bits) @@ Delay(a,3)).rotateLeft(Delay(sel,3)),3))
      setDefinitionName(Rotate2.this.getName())
    })
  }

  class Rotate3(width : Int) extends Rtl{
    override def getName(): String = "rotate3_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new Component{
      val a = Delay(in UInt(width bits), 3)
      val sel = Delay(in UInt(log2Up(width) bits),3)
//      val result =
//      val output = Delay(result, 3)
      setDefinitionName(Rotate3.this.getName())
    })
  }


  val rtls = ArrayBuffer[Rtl]()
  rtls += new Fpu(
    "32",
    portCount = 1,
    FpuParameter(
      internalMantissaSize = 23,
      withDouble = false
    )
  )
//  rtls += new Fpu(
//    "64",
//    portCount = 1,
//    FpuParameter(
//      internalMantissaSize = 52,
//      withDouble = true
//    )
//  )

//  rtls += new Shifter(24)
//  rtls += new Shifter(32)
//  rtls += new Shifter(52)
//  rtls += new Shifter(64)
//  rtls += new Rotate(24)
//  rtls += new Rotate(32)
//  rtls += new Rotate(52)
//  rtls += new Rotate(64)
//  rtls += new Rotate3(24)
//  rtls += new Rotate3(32)
//  rtls += new Rotate3(52)
//  rtls += new Rotate3(64)

  val targets = XilinxStdTargets()// ++ AlteraStdTargets()


  Bench(rtls, targets)
}