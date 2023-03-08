package vexriscv.ip.fpu

import spinal.core._
import spinal.lib._
import spinal.lib.eda.bench.{Bench, Rtl, XilinxStdTargets}
import spinal.lib.math.UnsignedDivider

import scala.collection.mutable.ArrayBuffer

object FpuDivSqrtIterationState extends SpinalEnum{
  val IDLE, YY, XYY, Y2_XYY, DIV, _15_XYY2, Y_15_XYY2, Y_15_XYY2_RESULT, SQRT = newElement()
}


case class FpuCore( portCount : Int, p : FpuParameter) extends Component{
  val io = new Bundle {
    val port = Vec(slave(FpuPort(p)), portCount)
  }

  val portCountWidth = log2Up(portCount)
  val Source = HardType(UInt(portCountWidth bits))
  val exponentOne = (1 << p.internalExponentSize-1) - 1
  val exponentF32Subnormal = exponentOne-127
  val exponentF64Subnormal = exponentOne-1023
  val exponentF32Infinity = exponentOne+127+1
  val exponentF64Infinity = exponentOne+1023+1



  def whenDouble(format : FpuFormat.C)(yes : => Unit)(no : => Unit): Unit ={
    if(p.withDouble) when(format === FpuFormat.DOUBLE) { yes } otherwise{ no }
    if(!p.withDouble) no
  }

  def muxDouble[T <: Data](format : FpuFormat.C)(yes : => T)(no : => T): T ={
    if(p.withDouble) ((format === FpuFormat.DOUBLE) ? { yes } | { no })
    else no
  }

  case class RfReadInput() extends Bundle{
    val source = Source()
    val opcode = p.Opcode()
    val rs1, rs2, rs3 = p.rfAddress()
    val rd = p.rfAddress()
    val arg = p.Arg()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
  }

  case class RfReadOutput() extends Bundle{
    val source = Source()
    val opcode = p.Opcode()
    val rs1, rs2, rs3 = p.internalFloating()
    val rd = p.rfAddress()
    val arg = p.Arg()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
    val rs1Boxed, rs2Boxed = p.withDouble generate Bool()
  }


  case class LoadInput() extends Bundle{
    val source = Source()
    val rd = p.rfAddress()
    val i2f = Bool()
    val arg = Bits(2 bits)
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
  }

  case class ShortPipInput() extends Bundle{
    val source = Source()
    val opcode = p.Opcode()
    val rs1, rs2 = p.internalFloating()
    val rd = p.rfAddress()
    val value = Bits(32 bits)
    val arg = Bits(2 bits)
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
    val rs1Boxed, rs2Boxed = p.withDouble generate Bool()
  }

  class MulInput() extends Bundle{
    val source = Source()
    val rs1, rs2, rs3 = p.internalFloating()
    val rd = p.rfAddress()
    val add = Bool()
    val divSqrt = Bool()
    val msb1, msb2 = Bool() //allow usage of msb bits of mul
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
  }


  case class DivSqrtInput() extends Bundle{
    val source = Source()
    val rs1, rs2 = p.internalFloating()
    val rd = p.rfAddress()
    val div = Bool()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
  }

  case class DivInput() extends Bundle{
    val source = Source()
    val rs1, rs2 = p.internalFloating()
    val rd = p.rfAddress()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
  }


  case class SqrtInput() extends Bundle{
    val source = Source()
    val rs1 = p.internalFloating()
    val rd = p.rfAddress()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
  }


  val addExtraBits = 2
  case class AddInput() extends Bundle{
    val source = Source()
    val rs1, rs2 = FpuFloat(exponentSize = p.internalExponentSize, mantissaSize = p.internalMantissaSize+addExtraBits)
    val rd = p.rfAddress()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
    val needCommit = Bool()
  }


  class MergeInput() extends Bundle{
    val source = Source()
    val rd = p.rfAddress()
    val value = p.writeFloating()
    val scrap = Bool()
    val roundMode = FpuRoundMode()
    val format = p.withDouble generate FpuFormat()
    val NV = Bool()
    val DZ = Bool()
  }

  case class RoundOutput() extends Bundle{
    val source = Source()
    val rd = p.rfAddress()
    val value = p.internalFloating()
    val format = p.withDouble generate FpuFormat()
    val NV, NX, OF, UF, DZ = Bool()
    val write = Bool()
  }

  val rf = new Area{
    case class Entry() extends Bundle{
      val value = p.internalFloating()
      val boxed = p.withDouble generate Bool()
    }
    val ram = Mem(Entry(), 32*portCount)

    val init = new Area{
      val counter = Reg(UInt(6 bits)) init(0)
      val done = CombInit(counter.msb)
      when(!done){
        counter := counter + 1
      }
      def apply(port : Flow[MemWriteCmd[Bool]]) = {
        port.valid := !done
        port.address := counter.resized
        port.data := False
        port
      }
    }

    val scoreboards = Array.fill(portCount)(new Area{
      val target, hit = Mem(Bool, 32) // XOR
      val writes = Mem(Bool, 32)

      val targetWrite = init(target.writePort)
      val hitWrite = init(hit.writePort)
    })
  }

  val commitFork = new Area{
    val load, commit = Vec(Stream(FpuCommit(p)), portCount)
    for(i <- 0 until portCount){
      val fork = new StreamFork(FpuCommit(p), 2, synchronous = true)
      fork.io.input << io.port(i).commit
      fork.io.outputs(0) >> load(i)
      fork.io.outputs(1).pipelined(m2s = false, s2m = true) >> commit(i) //Pipelining here is light, as it only use the flags of the payload
    }
  }

  class Tracker(width : Int) extends Area{
    val counter = Reg(UInt(width bits)) init(0)
    val full = counter.andR
    val notEmpty = counter.orR
    val inc = False
    val dec = False
    counter := counter + U(inc) - U(dec)
  }

  class CommitArea(source : Int) extends Area{
    val pending = new Tracker(4)
    val add, mul, div, sqrt, short = new Tracker(4)
    val input = commitFork.commit(source).haltWhen(List(add, mul, div, sqrt, short).map(_.full).orR || !pending.notEmpty).toFlow

    when(input.fire){
      add.inc   setWhen(List(FpuOpcode.ADD).map(input.opcode === _).orR)
      mul.inc   setWhen(List(FpuOpcode.MUL, FpuOpcode.FMA).map(input.opcode === _).orR)
      div.inc   setWhen(List(FpuOpcode.DIV).map(input.opcode === _).orR)
      sqrt.inc  setWhen(List(FpuOpcode.SQRT).map(input.opcode === _).orR)
      short.inc setWhen(List(FpuOpcode.SGNJ, FpuOpcode.MIN_MAX, FpuOpcode.FCVT_X_X).map(input.opcode === _).orR)
      rf.scoreboards(source).writes(input.rd) := input.write
      pending.dec := True
    }
  }

  val commitLogic = for(source <- 0 until portCount) yield new CommitArea(source)

  def commitConsume(what : CommitArea => Tracker, source : UInt, fire : Bool) : Bool = {
    for(i <- 0 until portCount) what(commitLogic(i)).dec setWhen(fire && source === i)
    commitLogic.map(what(_).notEmpty).read(source)
  }


  val scheduler = for(portId <- 0 until portCount;
                      scoreboard = rf.scoreboards(portId)) yield new Area{
    val input = io.port(portId).cmd.pipelined(s2m = true)
    val useRs1, useRs2, useRs3, useRd = False
    switch(input.opcode){
      is(p.Opcode.LOAD)      { useRd := True }
      is(p.Opcode.STORE)     { useRs2 := True }
      is(p.Opcode.ADD)       { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.MUL)       { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.DIV)       { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.SQRT)      { useRd  := True; useRs1 := True }
      is(p.Opcode.FMA)       { useRd  := True; useRs1 := True; useRs2 := True; useRs3 := True }
      is(p.Opcode.I2F)       { useRd  := True }
      is(p.Opcode.F2I)       { useRs1 := True }
      is(p.Opcode.MIN_MAX)   { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.CMP)       { useRs1 := True; useRs2 := True }
      is(p.Opcode.SGNJ)      { useRd  := True; useRs1 := True; useRs2 := True }
      is(p.Opcode.FMV_X_W)   { useRs1 := True }
      is(p.Opcode.FMV_W_X)   { useRd  := True }
      is(p.Opcode.FCLASS )   { useRs1  := True }
      is(p.Opcode.FCVT_X_X ) { useRd  := True; useRs1  := True }
    }

    val uses = List(useRs1, useRs2, useRs3, useRd)
    val regs = List(input.rs1, input.rs2, input.rs3, input.rd)
    val rfHits = regs.map(scoreboard.hit.readAsync(_))
    val rfTargets = regs.map(scoreboard.target.readAsync(_))
    val rfBusy = (rfHits, rfTargets).zipped.map(_ ^ _)

    val hits = (0 to 3).map(id => uses(id) && rfBusy(id))
    val hazard = hits.orR || !rf.init.done || commitLogic(portId).pending.full
    val output = input.haltWhen(hazard)
    when(input.opcode === p.Opcode.STORE){
      output.rs1 := input.rs2 //Datapath optimisation to unify rs source in the store pipeline
    }
    when(input.valid && rf.init.done){
      scoreboard.targetWrite.address := input.rd
      scoreboard.targetWrite.data := !rfTargets.last
    }
    when(output.fire && useRd){
      scoreboard.targetWrite.valid := True
      commitLogic(portId).pending.inc := True
    }
  }


  val cmdArbiter = new Area{
    val arbiter = StreamArbiterFactory.noLock.roundRobin.build(FpuCmd(p), portCount)
    arbiter.io.inputs <> Vec(scheduler.map(_.output.pipelined(m2s = p.schedulerM2sPipe)))

    val output = arbiter.io.output.swapPayload(RfReadInput())
    output.source := arbiter.io.chosen
    output.payload.assignSomeByName(arbiter.io.output.payload)
  }

  val read = new Area{
    val s0 = cmdArbiter.output.pipelined()
    val s1 = s0.m2sPipe()
    val output = s1.swapPayload(RfReadOutput())
    val rs = if(p.asyncRegFile){
      List(s1.rs1, s1.rs2, s1.rs3).map(a =>  rf.ram.readAsync(s1.source @@ a))
    } else {
      List(s0.rs1, s0.rs2, s0.rs3).map(a =>  rf.ram.readSync(s0.source @@ a, enable = !output.isStall))
    }
    output.source := s1.source
    output.opcode := s1.opcode
    output.arg := s1.arg
    output.roundMode := s1.roundMode
    output.rd := s1.rd
    output.rs1 := rs(0).value
    output.rs2 := rs(1).value
    output.rs3 := rs(2).value
    if(p.withDouble){
      output.rs1Boxed := rs(0).boxed
      output.rs2Boxed := rs(1).boxed
      output.format := s1.format
      val store = s1.opcode === FpuOpcode.STORE ||s1.opcode === FpuOpcode.FMV_X_W
      val sgnjBypass = s1.opcode === FpuOpcode.SGNJ && s1.format === FpuFormat.DOUBLE
      when(!sgnjBypass) {
        when(store) { //Pass through
          output.format := rs(0).boxed ? FpuFormat.FLOAT | FpuFormat.DOUBLE
        } elsewhen (s1.format === FpuFormat.FLOAT =/= rs(0).boxed) {
          output.rs1.setNanQuiet
          output.rs1.sign := False
        }
      }
      when(s1.format === FpuFormat.FLOAT =/= rs(1).boxed) {
        output.rs2.setNanQuiet
        output.rs2.sign := False
      }
      when(s1.format === FpuFormat.FLOAT =/= rs(2).boxed) {
        output.rs3.setNanQuiet
      }
    }
  }

  val decode = new Area{
    val input = read.output/*.s2mPipe()*/.combStage()
    input.ready := False

    val loadHit = List(FpuOpcode.LOAD, FpuOpcode.FMV_W_X, FpuOpcode.I2F).map(input.opcode === _).orR
    val load = Stream(LoadInput())
    load.valid := input.valid && loadHit
    input.ready setWhen(loadHit && load.ready)
    load.payload.assignSomeByName(input.payload)
    load.i2f := input.opcode === FpuOpcode.I2F

    val shortPipHit = List(FpuOpcode.STORE, FpuOpcode.F2I, FpuOpcode.CMP, FpuOpcode.MIN_MAX, FpuOpcode.SGNJ, FpuOpcode.FMV_X_W, FpuOpcode.FCLASS, FpuOpcode.FCVT_X_X).map(input.opcode === _).orR
    val shortPip = Stream(ShortPipInput())
    input.ready setWhen(shortPipHit && shortPip.ready)
    shortPip.valid := input.valid && shortPipHit
    shortPip.payload.assignSomeByName(input.payload)

    val divSqrtHit = input.opcode === p.Opcode.DIV ||  input.opcode === p.Opcode.SQRT
    val divSqrt = Stream(DivSqrtInput())
    if(p.withDivSqrt) {
      input.ready setWhen (divSqrtHit && divSqrt.ready)
      divSqrt.valid := input.valid && divSqrtHit
      divSqrt.payload.assignSomeByName(input.payload)
      divSqrt.div := input.opcode === p.Opcode.DIV
    }

    val divHit = input.opcode === p.Opcode.DIV
    val div = Stream(DivInput())
    if(p.withDiv) {
      input.ready setWhen (divHit && div.ready)
      div.valid := input.valid && divHit
      div.payload.assignSomeByName(input.payload)
    }

    val sqrtHit = input.opcode === p.Opcode.SQRT
    val sqrt = Stream(SqrtInput())
    if(p.withSqrt) {
      input.ready setWhen (sqrtHit && sqrt.ready)
      sqrt.valid := input.valid && sqrtHit
      sqrt.payload.assignSomeByName(input.payload)
    }


    val fmaHit = input.opcode === p.Opcode.FMA
    val mulHit = input.opcode === p.Opcode.MUL || fmaHit
    val mul = Stream(new MulInput())
    val divSqrtToMul = Stream(new MulInput())
    if(!p.withDivSqrt){
      divSqrtToMul.valid := False
      divSqrtToMul.payload.assignDontCare()
    }

    if(p.withMul) {
      input.ready setWhen (mulHit && mul.ready && !divSqrtToMul.valid)
      mul.valid := input.valid && mulHit || divSqrtToMul.valid

      divSqrtToMul.ready := mul.ready
      mul.payload := divSqrtToMul.payload
      when(!divSqrtToMul.valid) {
        mul.payload.assignSomeByName(input.payload)
        mul.add := fmaHit
        mul.divSqrt := False
        mul.msb1 := True
        mul.msb2 := True
        mul.rs2.sign.allowOverride();
        mul.rs2.sign := input.rs2.sign ^ input.arg(0)
        mul.rs3.sign.allowOverride();
        mul.rs3.sign := input.rs3.sign ^ input.arg(1)
      }
    }

    val addHit = input.opcode === p.Opcode.ADD
    val add = Stream(AddInput())
    val mulToAdd = Stream(AddInput())


    if(p.withAdd) {
      input.ready setWhen (addHit && add.ready && !mulToAdd.valid)
      add.valid := input.valid && addHit || mulToAdd.valid

      mulToAdd.ready := add.ready
      add.payload := mulToAdd.payload
      when(!mulToAdd.valid) {
        add.source := input.source
        add.rd := input.rd
        add.roundMode := input.roundMode
        if(p.withDouble) add.format := input.format
        add.needCommit := True
        add.rs1.special := input.rs1.special
        add.rs2.special := input.rs2.special
        add.rs1.exponent := input.rs1.exponent
        add.rs2.exponent := input.rs2.exponent
        add.rs1.sign := input.rs1.sign
        add.rs2.sign := input.rs2.sign ^ input.arg(0)
        add.rs1.mantissa := input.rs1.mantissa << addExtraBits
        add.rs2.mantissa := input.rs2.mantissa << addExtraBits
      }
    }
  }

  val load = new Area{

    case class S0() extends Bundle{
      val source = Source()
      val rd = p.rfAddress()
      val value = p.storeLoadType()
      val i2f = Bool()
      val arg = Bits(2 bits)
      val roundMode = FpuRoundMode()
      val format = p.withDouble generate FpuFormat()
    }

    val s0 = new Area{
      val input = decode.load.pipelined(m2s = true, s2m = true).stage()
      val filtred = commitFork.load.map(port => port.takeWhen(List(FpuOpcode.LOAD, FpuOpcode.FMV_W_X, FpuOpcode.I2F).map(_ === port.opcode).orR))
      def feed = filtred(input.source)
      val hazard = !feed.valid


      val output = input.haltWhen(hazard).swapPayload(S0())
      filtred.foreach(_.ready := False)
      feed.ready := input.valid && output.ready
      output.source := input.source
      output.rd := input.rd
      output.value := feed.value
      output.i2f := input.i2f
      output.arg := input.arg
      output.roundMode := input.roundMode
      if(p.withDouble) {
        output.format := input.format
        when(!input.i2f && input.format === FpuFormat.DOUBLE && output.value(63 downto 32).andR){ //Detect boxing
          output.format := FpuFormat.FLOAT
        }
      }
    }

    val s1 = new Area{
      val input = s0.output.stage()
      val busy = False

      val f32 = new Area{
        val mantissa = input.value(0, 23 bits).asUInt
        val exponent = input.value(23, 8 bits).asUInt
        val sign     = input.value(31)
      }
      val f64 = p.withDouble generate new Area{
        val mantissa = input.value(0, 52 bits).asUInt
        val exponent = input.value(52, 11 bits).asUInt
        val sign     = input.value(63)
      }

      val recodedExpOffset = UInt(p.internalExponentSize bits)
      val passThroughFloat = p.internalFloating()
      passThroughFloat.special := False

      whenDouble(input.format){
        passThroughFloat.sign := f64.sign
        passThroughFloat.exponent := f64.exponent.resized
        passThroughFloat.mantissa := f64.mantissa
        recodedExpOffset := exponentF64Subnormal
      } {
        passThroughFloat.sign := f32.sign
        passThroughFloat.exponent := f32.exponent.resized
        passThroughFloat.mantissa := f32.mantissa << (if (p.withDouble) 29 else 0)
        recodedExpOffset := exponentF32Subnormal
      }


      val manZero = passThroughFloat.mantissa === 0
      val expZero = passThroughFloat.exponent === 0
      val expOne =  passThroughFloat.exponent(7 downto 0).andR
      if(p.withDouble) {
        expZero.clearWhen(input.format === FpuFormat.DOUBLE && input.value(62 downto 60) =/= 0)
        expOne.clearWhen(input.format === FpuFormat.DOUBLE && input.value(62 downto 60) =/= 7)
      }

      val isZero      =  expZero &&  manZero
      val isSubnormal =  expZero && !manZero
      val isInfinity  =  expOne  &&  manZero
      val isNan       =  expOne  && !manZero


      val fsm = new Area{
        val done, boot, patched = Reg(Bool())
        val ohInputWidth = 32 max p.internalMantissaSize
        val ohInput = Bits(ohInputWidth bits).assignDontCare()
        when(!input.i2f) {
          if(!p.withDouble) ohInput := input.value(0, 23 bits) << 9
          if( p.withDouble) ohInput := passThroughFloat.mantissa.asBits
        } otherwise {
          ohInput(ohInputWidth-32-1 downto 0) := 0
          ohInput(ohInputWidth-32, 32 bits) := input.value(31 downto 0)
        }

        val i2fZero = Reg(Bool)

        val shift = new Area{
          val by = Reg(UInt(log2Up(ohInputWidth) bits))
          val input = UInt(ohInputWidth bits).assignDontCare()
          var logic = input
          for(i <- by.range){
            logic \= by(i) ? (logic |<< (BigInt(1) << i)) | logic
          }
          val output = RegNextWhen(logic, !done)
        }
        shift.input := (ohInput.asUInt |<< 1).resized

        when(input.valid && (input.i2f || isSubnormal) && !done){
          busy := True
          when(boot){
            when(input.i2f && !patched && input.value(31) && input.arg(0)){
              input.value.getDrivingReg()(0, 32 bits) := B(input.value.asUInt.twoComplement(True).resize(32 bits))
              patched := True
            } otherwise {
              shift.by := OHToUInt(OHMasking.first((ohInput).reversed))
              boot := False
              i2fZero := input.value(31 downto 0) === 0
            }
          } otherwise {
            done := True
          }
        }

        val expOffset = (UInt(p.internalExponentSize bits))
        expOffset := 0
        when(isSubnormal){
          expOffset := shift.by.resized
        }

        when(!input.isStall){
          done := False
          boot := True
          patched := False
        }
      }


      val i2fSign = fsm.patched
      val (i2fHigh, i2fLow) = fsm.shift.output.splitAt(if(p.withDouble) 0 else widthOf(input.value)-24)
      val scrap = i2fLow =/= 0

      val recoded = p.internalFloating()
      recoded.mantissa := passThroughFloat.mantissa
      recoded.exponent := (passThroughFloat.exponent -^ fsm.expOffset + recodedExpOffset).resized
      recoded.sign     := passThroughFloat.sign
      recoded.setNormal
      when(isZero){recoded.setZero}
      when(isInfinity){recoded.setInfinity}
      when(isNan){recoded.setNan}

      val output = input.haltWhen(busy).swapPayload(new MergeInput())
      output.source := input.source
      output.roundMode := input.roundMode
      if(p.withDouble) {
        output.format := input.format
      }
      output.rd := input.rd
      output.value.sign      := recoded.sign
      output.value.exponent  := recoded.exponent
      output.value.mantissa  := recoded.mantissa @@ U"0"
      output.value.special   := recoded.special
      output.scrap := False
      output.NV := False
      output.DZ := False
      when(input.i2f){
        output.value.sign := i2fSign
        output.value.exponent := (U(exponentOne+31) - fsm.shift.by).resized
        output.value.setNormal
        output.scrap := scrap
        when(fsm.i2fZero) { output.value.setZero }
      }

      when(input.i2f || isSubnormal){
        output.value.mantissa := U(i2fHigh) @@ (if(p.withDouble) U"0" else U"")
      }
    }

  }

  val shortPip = new Area{
    val input = decode.shortPip.stage()

    val toFpuRf = List(FpuOpcode.MIN_MAX, FpuOpcode.SGNJ, FpuOpcode.FCVT_X_X).map(input.opcode === _).orR
    val rfOutput = Stream(new MergeInput())

    val isCommited = commitConsume(_.short, input.source, input.fire && toFpuRf)
    val output = rfOutput.haltWhen(!isCommited)

    val result = p.storeLoadType().assignDontCare()

    val halt = False
    val recodedResult =  p.storeLoadType()
    val f32 = new Area{
      val exp = (input.rs1.exponent - (exponentOne-127)).resize(8 bits)
      val man = CombInit(input.rs1.mantissa(if(p.withDouble) 51 downto 29 else 22 downto 0))
    }
    val f64 = p.withDouble generate new Area{
      val exp = (input.rs1.exponent - (exponentOne-1023)).resize(11 bits)
      val man = CombInit(input.rs1.mantissa)
    }

    whenDouble(input.format){
      recodedResult := input.rs1.sign ## f64.exp ## f64.man
    } {
      recodedResult := (if(p.withDouble) B"xFFFFFFFF" else B"") ## input.rs1.sign ## f32.exp ## f32.man
    }

    val expSubnormalThreshold = muxDouble[UInt](input.format)(exponentF64Subnormal)(exponentF32Subnormal)
    val expInSubnormalRange = input.rs1.exponent <= expSubnormalThreshold
    val isSubnormal = !input.rs1.special && expInSubnormalRange
    val isNormal = !input.rs1.special && !expInSubnormalRange
    val fsm = new Area{
      val f2iShift = input.rs1.exponent - U(exponentOne)
      val isF2i = input.opcode === FpuOpcode.F2I
      val needRecoding = List(FpuOpcode.FMV_X_W, FpuOpcode.STORE).map(_ === input.opcode).orR && isSubnormal
      val done, boot = Reg(Bool())
      val isZero = input.rs1.isZero// || input.rs1.exponent < exponentOne-1

      val shift = new Area{
        val by = Reg(UInt(log2Up(p.internalMantissaSize+1 max 33) bits))
        val input = UInt(p.internalMantissaSize+1 max 33 bits).assignDontCare()
        var logic = input
        val scrap = Reg(Bool)
        for(i <- by.range.reverse){
          scrap setWhen(by(i) && logic(0, 1 << i bits) =/= 0)
          logic \= by(i) ? (logic |>> (BigInt(1) << i)) | logic
        }
        when(boot){
          scrap := False
        }
        val output = RegNextWhen(logic, !done)
      }

      shift.input := (U(!isZero) @@ input.rs1.mantissa) << (if(p.withDouble) 0 else 9)

      val formatShiftOffset = muxDouble[UInt](input.format)(exponentOne-1023+1)(exponentOne - (if(p.withDouble) (127+34) else (127-10)))
      when(input.valid && (needRecoding || isF2i) && !done){
        halt := True
        when(boot){
          when(isF2i){
            shift.by := ((U(exponentOne + 31) - input.rs1.exponent).min(U(33)) + (if(p.withDouble) 20 else 0)).resized //TODO merge
          } otherwise {
            shift.by := (formatShiftOffset - input.rs1.exponent).resized
          }
          boot := False
        } otherwise {
          done := True
        }
      }

      when(!input.isStall){
        done := False
        boot := True
      }
    }

    val mantissaForced = False
    val exponentForced = False
    val mantissaForcedValue = Bool().assignDontCare()
    val exponentForcedValue = Bool().assignDontCare()
    val cononicalForced = False


    when(input.rs1.special){
      switch(input.rs1.exponent(1 downto 0)){
        is(FpuFloat.ZERO){
          mantissaForced      := True
          exponentForced      := True
          mantissaForcedValue := False
          exponentForcedValue := False
        }
        is(FpuFloat.INFINITY){
          mantissaForced      := True
          exponentForced      := True
          mantissaForcedValue := False
          exponentForcedValue := True
        }
        is(FpuFloat.NAN){
          exponentForced      := True
          exponentForcedValue := True
          when(input.rs1.isCanonical){
            cononicalForced := True
            mantissaForced      := True
            mantissaForcedValue := False
          }
        }
      }
    }



    when(isSubnormal){
      exponentForced      := True
      exponentForcedValue := False
      recodedResult(0,23 bits) := fsm.shift.output(22 downto 0).asBits
      whenDouble(input.format){
        recodedResult(51 downto 23) := fsm.shift.output(51 downto 23).asBits
      }{}
    }
    when(mantissaForced){
      recodedResult(0,23 bits) := (default -> mantissaForcedValue)
      whenDouble(input.format){
        recodedResult(23, 52-23 bits) := (default -> mantissaForcedValue)
      }{}
    }
    when(exponentForced){
      whenDouble(input.format){
        recodedResult(52, 11 bits) := (default -> exponentForcedValue)
      }  {
        recodedResult(23, 8 bits) := (default -> exponentForcedValue)
      }
    }
    when(cononicalForced){
      whenDouble(input.format){
        recodedResult(63) := False
        recodedResult(51) := True
      }  {
        recodedResult(31) := False
        recodedResult(22) := True
      }
    }

    val rspNv = False
    val rspNx = False

    val f2i = new Area{ //Will not work for 64 bits float max value rounding
      val unsigned = fsm.shift.output(32 downto 0) >> 1
      val resign = input.arg(0) && input.rs1.sign
      val round = fsm.shift.output(0) ## fsm.shift.scrap
      val increment = input.roundMode.mux(
        FpuRoundMode.RNE -> (round(1) && (round(0) || unsigned(0))),
        FpuRoundMode.RTZ -> False,
        FpuRoundMode.RDN -> (round =/= 0 &&  input.rs1.sign),
        FpuRoundMode.RUP -> (round =/= 0 && !input.rs1.sign),
        FpuRoundMode.RMM -> (round(1))
      )
      val result = (Mux(resign, ~unsigned, unsigned) + (resign ^ increment).asUInt)
      val overflow  = (input.rs1.exponent > (input.arg(0) ? U(exponentOne+30) | U(exponentOne+31)) || input.rs1.isInfinity) && !input.rs1.sign || input.rs1.isNan
      val underflow = (input.rs1.exponent > U(exponentOne+31) || input.arg(0) && unsigned.msb && (unsigned(30 downto 0) =/= 0 || increment) || !input.arg(0) && (unsigned =/= 0 || increment) || input.rs1.isInfinity) && input.rs1.sign
      val isZero = input.rs1.isZero
      if(p.withDouble){
        overflow setWhen(!input.rs1.sign && increment && unsigned(30 downto 0).andR && (input.arg(0) || unsigned(31)))
      }
      when(isZero){
        result := 0
      } elsewhen(underflow || overflow) {
        val low = overflow
        val high = input.arg(0) ^ overflow
        result := (31 -> high, default -> low)
        rspNv := input.valid && input.opcode === FpuOpcode.F2I && fsm.done && !isZero
      } otherwise {
        rspNx := input.valid && input.opcode === FpuOpcode.F2I && fsm.done && round =/= 0
      }
    }

    val bothZero = input.rs1.isZero && input.rs2.isZero
    val rs1Equal = input.rs1 === input.rs2
    val rs1AbsSmaller = (input.rs1.exponent @@ input.rs1.mantissa) < (input.rs2.exponent @@ input.rs2.mantissa)
    rs1AbsSmaller.setWhen(input.rs2.isInfinity)
    rs1AbsSmaller.setWhen(input.rs1.isZero)
    rs1AbsSmaller.clearWhen(input.rs2.isZero)
    rs1AbsSmaller.clearWhen(input.rs1.isInfinity)
    rs1Equal setWhen(input.rs1.sign === input.rs2.sign && input.rs1.isInfinity && input.rs2.isInfinity)
    val rs1Smaller = (input.rs1.sign ## input.rs2.sign).mux(
      0 -> rs1AbsSmaller,
      1 -> False,
      2 -> True,
      3 -> (!rs1AbsSmaller && !rs1Equal)
    )


    val minMaxSelectRs2 = !(((rs1Smaller ^ input.arg(0)) && !input.rs1.isNan || input.rs2.isNan))
    val minMaxSelectNanQuiet = input.rs1.isNan && input.rs2.isNan
    val cmpResult = B(rs1Smaller && !bothZero && !input.arg(1) || (rs1Equal || bothZero) && !input.arg(0))
    when(input.rs1.isNan || input.rs2.isNan) { cmpResult := 0 }
    val sgnjRs1Sign = CombInit(input.rs1.sign)
    val sgnjRs2Sign = CombInit(input.rs2.sign)
    if(p.withDouble){
      sgnjRs2Sign setWhen(input.rs2Boxed && input.format === FpuFormat.DOUBLE)
    }
    val sgnjResult = (sgnjRs1Sign && input.arg(1)) ^ sgnjRs2Sign ^ input.arg(0)
    val fclassResult = B(0, 32 bits)
    val decoded = input.rs1.decode()
    fclassResult(0) :=  input.rs1.sign &&  decoded.isInfinity
    fclassResult(1) :=  input.rs1.sign &&  isNormal
    fclassResult(2) :=  input.rs1.sign &&  isSubnormal
    fclassResult(3) :=  input.rs1.sign &&  decoded.isZero
    fclassResult(4) := !input.rs1.sign &&  decoded.isZero
    fclassResult(5) := !input.rs1.sign &&  isSubnormal
    fclassResult(6) := !input.rs1.sign &&  isNormal
    fclassResult(7) := !input.rs1.sign &&  decoded.isInfinity
    fclassResult(8) :=   decoded.isNan && !decoded.isQuiet
    fclassResult(9) :=   decoded.isNan &&  decoded.isQuiet


    switch(input.opcode){
      is(FpuOpcode.STORE)   { result := recodedResult }
      is(FpuOpcode.FMV_X_W) { result := recodedResult }
      is(FpuOpcode.F2I)     { result(31 downto 0) := f2i.result.asBits }
      is(FpuOpcode.CMP)     { result(31 downto 0) := cmpResult.resized }
      is(FpuOpcode.FCLASS)  { result(31 downto 0) := fclassResult.resized }
    }


    rfOutput.valid := input.valid && toFpuRf && !halt
    rfOutput.source := input.source
    rfOutput.rd := input.rd
    rfOutput.roundMode := input.roundMode
    if(p.withDouble) rfOutput.format := input.format
    rfOutput.scrap := False
    rfOutput.value.sign     := input.rs1.sign
    rfOutput.value.exponent := input.rs1.exponent
    rfOutput.value.mantissa := input.rs1.mantissa @@ U"0"
    rfOutput.value.special  := input.rs1.special

    switch(input.opcode){
      is(FpuOpcode.MIN_MAX){
        when(minMaxSelectRs2) {
          rfOutput.value.sign := input.rs2.sign
          rfOutput.value.exponent := input.rs2.exponent
          rfOutput.value.mantissa := input.rs2.mantissa @@ U"0"
          rfOutput.value.special := input.rs2.special
        }
        when(minMaxSelectNanQuiet){
          rfOutput.value.setNanQuiet
        }
      }
      is(FpuOpcode.SGNJ){
        when(!input.rs1.isNan) {
          rfOutput.value.sign := sgnjResult
        }
        if(p.withDouble) when(input.rs1Boxed && input.format === FpuFormat.DOUBLE){
          rfOutput.value.sign := input.rs1.sign
          rfOutput.format := FpuFormat.FLOAT
        }
      }
      if(p.withDouble) is(FpuOpcode.FCVT_X_X){
        rfOutput.format := ((input.format === FpuFormat.FLOAT) ? FpuFormat.DOUBLE | FpuFormat.FLOAT)
        when(input.rs1.isNan){
          rfOutput.value.setNanQuiet
        }
      }
    }

    val signalQuiet = input.opcode === FpuOpcode.CMP && input.arg =/= 2
    val rs1Nan = input.rs1.isNan
    val rs2Nan = input.rs2.isNan
    val rs1NanNv = input.rs1.isNan && (!input.rs1.isQuiet || signalQuiet)
    val rs2NanNv = input.rs2.isNan && (!input.rs2.isQuiet || signalQuiet)
    val NV = List(FpuOpcode.CMP, FpuOpcode.MIN_MAX, FpuOpcode.FCVT_X_X).map(input.opcode === _).orR && rs1NanNv ||
             List(FpuOpcode.CMP, FpuOpcode.MIN_MAX).map(input.opcode === _).orR && rs2NanNv
    rspNv setWhen(NV)

    val rspStreams = Vec(Stream(FpuRsp(p)), portCount)
    input.ready := !halt && (toFpuRf ? rfOutput.ready | rspStreams.map(_.ready).read(input.source))
    for(i <- 0 until portCount){
      def rsp = rspStreams(i)
      rsp.valid := input.valid && input.source === i && !toFpuRf && !halt
      rsp.value := result
      rsp.NV := rspNv
      rsp.NX := rspNx
      io.port(i).rsp << rsp.stage()
    }


    rfOutput.NV := NV
    rfOutput.DZ := False
  }

  val mul = p.withMul generate new Area{
    val inWidthA = p.internalMantissaSize+1
    val inWidthB = p.internalMantissaSize+1
    val outWidth = p.internalMantissaSize*2+2

    case class MulSplit(offsetA : Int, offsetB : Int, widthA : Int, widthB : Int, id : Int){
      val offsetC = offsetA+offsetB
      val widthC = widthA + widthB
      val endC = offsetC+widthC
    }
    val splitsUnordered = for(offsetA <- 0 until inWidthA by p.mulWidthA;
                     offsetB <- 0 until inWidthB by p.mulWidthB;
                     widthA = (inWidthA - offsetA) min p.mulWidthA;
                     widthB = (inWidthB - offsetB) min p.mulWidthB) yield {
     MulSplit(offsetA, offsetB, widthA, widthB, -1)
    }
    val splits = splitsUnordered.sortWith(_.endC < _.endC).zipWithIndex.map(e => e._1.copy(id=e._2))

    class MathWithExp extends MulInput{
      val exp  = UInt(p.internalExponentSize+1 bits)
    }
    val preMul = new Area{
      val input = decode.mul.stage()
      val output = input.swapPayload(new MathWithExp())
      output.payload.assignSomeByName(input.payload)
      output.exp := input.rs1.exponent +^ input.rs2.exponent
    }
    class MathWithMul extends MathWithExp{
      val muls  = Vec(splits.map(e => UInt(e.widthA + e.widthB bits)))
    }
    val mul = new Area{
      val input = preMul.output.stage()
      val output = input.swapPayload(new MathWithMul())
      val mulA = U(input.msb1) @@ input.rs1.mantissa
      val mulB = U(input.msb2) @@ input.rs2.mantissa
      output.payload.assignSomeByName(input.payload)
      splits.foreach(e => output.muls(e.id) := mulA(e.offsetA, e.widthA bits) * mulB(e.offsetB, e.widthB bits))
    }

    val sumSplitAt = splits.size/2//splits.filter(e => e.endC <= p.internalMantissaSize).size

    class Sum1Output extends MathWithExp{
      val muls2  = Vec(splits.drop(sumSplitAt).map(e => UInt(e.widthA + e.widthB bits)))
      val mulC2 = UInt(p.internalMantissaSize*2+2 bits)
    }
    class Sum2Output extends MathWithExp{
      val mulC = UInt(p.internalMantissaSize*2+2 bits)
    }

    val sum1 = new Area {
      val input = mul.output.stage()
      val sum = splits.take(sumSplitAt).map(e => (input.muls(e.id) << e.offsetC).resize(outWidth)).reduceBalancedTree(_ + _)

      val output = input.swapPayload(new Sum1Output())
      output.payload.assignSomeByName(input.payload)
      output.mulC2 := sum.resized
      output.muls2 := Vec(input.muls.drop(sumSplitAt))
    }

    val sum2 = new Area {
      val input = sum1.output.stage()
      val sum = input.mulC2 + splits.drop(sumSplitAt).map(e => (input.muls2(e.id-sumSplitAt) << e.offsetC).resize(outWidth)).reduceBalancedTree(_ + _)

      val isCommited = commitConsume(_.mul, input.source, input.fire)
      val output = input.haltWhen(!isCommited).swapPayload(new Sum2Output())
      output.payload.assignSomeByName(input.payload)
      output.mulC := sum
    }

    val norm = new Area{
      val input = sum2.output.stage()
      val (mulHigh, mulLow) = input.mulC.splitAt(p.internalMantissaSize-1)
      val scrap = mulLow =/= 0
      val needShift = mulHigh.msb
      val exp = input.exp + U(needShift)
      val man = needShift ? mulHigh(1, p.internalMantissaSize+1 bits) | mulHigh(0, p.internalMantissaSize+1 bits)
      scrap setWhen(needShift && mulHigh(0))
      val forceZero = input.rs1.isZero || input.rs2.isZero
      val underflowThreshold = muxDouble[UInt](input.format)(exponentOne + exponentOne - 1023 - 53) (exponentOne + exponentOne - 127 - 24)
      val underflowExp = muxDouble[UInt](input.format)(exponentOne - 1023 - 54) (exponentOne - 127 - 25)
      val forceUnderflow = exp <  underflowThreshold
      val forceOverflow = input.rs1.isInfinity || input.rs2.isInfinity
      val infinitynan = ((input.rs1.isInfinity || input.rs2.isInfinity) && (input.rs1.isZero || input.rs2.isZero))
      val forceNan = input.rs1.isNan || input.rs2.isNan || infinitynan

      val output = p.writeFloating()
      output.sign := input.rs1.sign ^ input.rs2.sign
      output.exponent := (exp - exponentOne).resized
      output.mantissa := man.asUInt
      output.setNormal
      val NV = False

      when(exp(exp.getWidth-3, 3 bits) >= 5) { output.exponent(p.internalExponentSize-2, 2 bits) := 3 }

      when(forceNan) {
        output.setNanQuiet
        NV setWhen(infinitynan || input.rs1.isNanSignaling || input.rs2.isNanSignaling)
      } elsewhen(forceOverflow) {
        output.setInfinity
      } elsewhen(forceZero) {
        output.setZero
      } elsewhen(forceUnderflow) {
        output.exponent := underflowExp.resized
      }
    }

    val result = new Area {
      def input = norm.input
      def NV = norm.NV

      val notMul = new Area {
        val output = Flow(UInt(p.internalMantissaSize + 1 bits))
        output.valid := input.valid && input.divSqrt
        output.payload := input.mulC(p.internalMantissaSize, p.internalMantissaSize + 1 bits)
      }

      val output = Stream(new MergeInput())
      output.valid := input.valid && !input.add && !input.divSqrt
      output.source := input.source
      output.rd := input.rd
      if (p.withDouble) output.format := input.format
      output.roundMode := input.roundMode
      output.scrap := norm.scrap
      output.value := norm.output
      output.NV := NV
      output.DZ := False

      val mulToAdd = Stream(AddInput())
      decode.mulToAdd << mulToAdd.stage()

      mulToAdd.valid := input.valid && input.add
      mulToAdd.source := input.source
      mulToAdd.rs1.mantissa := norm.output.mantissa @@ norm.scrap //FMA Precision lost
      mulToAdd.rs1.exponent := norm.output.exponent
      mulToAdd.rs1.sign := norm.output.sign
      mulToAdd.rs1.special := norm.output.special
      mulToAdd.rs2 := input.rs3
      mulToAdd.rs2.mantissa.removeAssignments() := input.rs3.mantissa << addExtraBits
      mulToAdd.rd := input.rd
      mulToAdd.roundMode := input.roundMode
      mulToAdd.needCommit := False
      if (p.withDouble) mulToAdd.format := input.format

      when(NV){
        mulToAdd.rs1.mantissa.msb := False
      }

      input.ready := (input.add ? mulToAdd.ready | output.ready) || input.divSqrt
    }
  }


  val div = p.withDiv generate new Area{
    val input = decode.div.halfPipe()
    val haltIt = True
    val isCommited = RegNext(commitConsume(_.div, input.source, input.fire))
    val output = input.haltWhen(haltIt || !isCommited).swapPayload(new MergeInput())

    val dividerShift = if(p.withDouble) 0 else 1
    val divider = FpuDiv(p.internalMantissaSize + dividerShift)
    divider.io.input.a := input.rs1.mantissa << dividerShift
    divider.io.input.b := input.rs2.mantissa << dividerShift
    val dividerResult = divider.io.output.result >> dividerShift
    val dividerScrap = divider.io.output.remain =/= 0 || divider.io.output.result(0, dividerShift bits) =/= 0

    val cmdSent = RegInit(False) setWhen(divider.io.input.fire) clearWhen(!haltIt)
    divider.io.input.valid := input.valid && !cmdSent
    divider.io.output.ready := input.ready
    output.payload.assignSomeByName(input.payload)

    val needShift = !dividerResult.msb
    val mantissa = needShift ? dividerResult(0, p.internalMantissaSize + 1 bits) |  dividerResult(1, p.internalMantissaSize + 1 bits)
    val scrap = dividerScrap || !needShift && dividerResult(0)
    val exponentOffset = 1 << (p.internalExponentSize + 1)
    val exponent = input.rs1.exponent + U(exponentOffset | exponentOne) - input.rs2.exponent - U(needShift)

    output.value.setNormal
    output.value.sign := input.rs1.sign ^ input.rs2.sign
    output.value.exponent := exponent.resized
    output.value.mantissa := mantissa
    output.scrap := scrap
    when(exponent.takeHigh(2) === 3){ output.value.exponent(p.internalExponentSize-3, 3 bits) := 7} //Handle overflow



    val underflowThreshold = muxDouble[UInt](input.format)(exponentOne + exponentOffset - 1023 - 53) (exponentOne + exponentOffset - 127 - 24)
    val underflowExp = muxDouble[UInt](input.format)(exponentOne + exponentOffset - 1023 - 54) (exponentOne + exponentOffset - 127 - 25)
    val forceUnderflow = exponent <  underflowThreshold
    val forceOverflow = input.rs1.isInfinity || input.rs2.isZero
    val infinitynan = input.rs1.isZero && input.rs2.isZero || input.rs1.isInfinity && input.rs2.isInfinity
    val forceNan = input.rs1.isNan || input.rs2.isNan || infinitynan
    val forceZero = input.rs1.isZero || input.rs2.isInfinity



    output.NV := False
    output.DZ := !forceNan && !input.rs1.isInfinity && input.rs2.isZero

    when(exponent(exponent.getWidth-3, 3 bits) === 7) { output.value.exponent(p.internalExponentSize-2, 2 bits) := 3 }

    when(forceNan) {
      output.value.setNanQuiet
      output.NV setWhen((infinitynan || input.rs1.isNanSignaling || input.rs2.isNanSignaling))
    } elsewhen(forceOverflow) {
      output.value.setInfinity
    } elsewhen(forceZero) {
      output.value.setZero
    } elsewhen(forceUnderflow) {
      output.value.exponent := underflowExp.resized
    }


    haltIt clearWhen(divider.io.output.valid)
  }



  val sqrt = p.withSqrt generate new Area{
    val input = decode.sqrt.halfPipe()
    val haltIt = True
    val isCommited = RegNext(commitConsume(_.sqrt, input.source, input.fire))
    val output = input.haltWhen(haltIt || !isCommited).swapPayload(new MergeInput())

    val needShift = !input.rs1.exponent.lsb
    val sqrt = FpuSqrt(p.internalMantissaSize)
    sqrt.io.input.a := (needShift ? (U"1" @@ input.rs1.mantissa @@ U"0") | (U"01" @@ input.rs1.mantissa))

    val cmdSent = RegInit(False) setWhen(sqrt.io.input.fire) clearWhen(!haltIt)
    sqrt.io.input.valid := input.valid && !cmdSent
    sqrt.io.output.ready := input.ready
    output.payload.assignSomeByName(input.payload)


    val scrap = sqrt.io.output.remain =/= 0
    val exponent =   RegNext(exponentOne-exponentOne/2 -1 +^ (input.rs1.exponent >> 1) + U(input.rs1.exponent.lsb))

    output.value.setNormal
    output.value.sign := input.rs1.sign
    output.value.exponent := exponent
    output.value.mantissa := sqrt.io.output.result
    output.scrap := scrap
    output.NV := False
    output.DZ := False

    val negative  = !input.rs1.isNan && !input.rs1.isZero && input.rs1.sign

    when(input.rs1.isInfinity){
      output.value.setInfinity
    }
    when(negative){
      output.value.setNanQuiet
      output.NV := True
    }
    when(input.rs1.isNan){
      output.value.setNanQuiet
      output.NV := !input.rs1.isQuiet
    }
    when(input.rs1.isZero){
      output.value.setZero
    }


//    val underflowThreshold = muxDouble[UInt](input.format)(exponentOne + exponentOffset - 1023 - 53) (exponentOne + exponentOffset - 127 - 24)
//    val underflowExp = muxDouble[UInt](input.format)(exponentOne + exponentOffset - 1023 - 54) (exponentOne + exponentOffset - 127 - 25)
//    val forceUnderflow = exponent <  underflowThreshold
//    val forceOverflow = input.rs1.isInfinity// || input.rs2.isInfinity
//    val infinitynan = input.rs1.isZero && input.rs2.isZero
//    val forceNan = input.rs1.isNan || input.rs2.isNan || infinitynan
//    val forceZero = input.rs1.isZero
//
//
//
//    output.NV := False
//    output.DZ := !forceNan && input.rs2.isZero
//
//    when(exponent(exponent.getWidth-3, 3 bits) === 7) { output.value.exponent(p.internalExponentSize-2, 2 bits) := 3 }
//
//    when(forceNan) {
//      output.value.setNanQuiet
//      output.NV setWhen((infinitynan || input.rs1.isNanSignaling || input.rs2.isNanSignaling))
//    } elsewhen(forceOverflow) {
//      output.value.setInfinity
//    } elsewhen(forceZero) {
//      output.value.setZero
//    } elsewhen(forceUnderflow) {
//      output.value.exponent := underflowExp.resized
//    }


    haltIt clearWhen(sqrt.io.output.valid)
  }

  //divSqrt isn't realy used anymore
  val divSqrt = p.withDivSqrt generate new Area {
    val input = decode.divSqrt.halfPipe()
    assert(false, "Need to implement commit tracking")
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
    decode.divSqrtToMul.add := False
    decode.divSqrtToMul.divSqrt := True
    decode.divSqrtToMul.msb1 := True
    decode.divSqrtToMul.msb2 := True
    decode.divSqrtToMul.rs1.special := False //TODO
    decode.divSqrtToMul.rs2.special := False
    decode.divSqrtToMul.roundMode := input.roundMode
    if(p.withDouble) decode.divSqrtToMul.format := input.format


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

    val mulBuffer = mul.result.notMul.output.toStream.stage
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
          mulBuffer.payload.getDrivingReg() := (U"11" << mulWidth-2) - (mulBuffer.payload)
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

  val add = p.withAdd generate new Area{


    class PreShifterOutput extends AddInput{
      val absRs1Bigger = Bool()
      val rs1ExponentBigger = Bool()
    }

    val preShifter = new Area{
      val input = decode.add.combStage()
      val output = input.swapPayload(new PreShifterOutput)

      val exp21 = input.rs2.exponent -^ input.rs1.exponent
      val rs1ExponentBigger = (exp21.msb || input.rs2.isZero) && !input.rs1.isZero
      val rs1ExponentEqual = input.rs1.exponent === input.rs2.exponent
      val rs1MantissaBigger = input.rs1.mantissa > input.rs2.mantissa
      val absRs1Bigger = ((rs1ExponentBigger || rs1ExponentEqual && rs1MantissaBigger) && !input.rs1.isZero || input.rs1.isInfinity) && !input.rs2.isInfinity

      output.payload.assignSomeByName(input.payload)
      output.absRs1Bigger := absRs1Bigger
      output.rs1ExponentBigger := rs1ExponentBigger
    }

    class ShifterOutput extends AddInput{
      val xSign, ySign = Bool()
      val xMantissa, yMantissa = UInt(p.internalMantissaSize+1+addExtraBits bits)
      val xyExponent = UInt(p.internalExponentSize bits)
      val xySign = Bool()
      val roundingScrap = Bool()
    }

    val shifter = new Area {
      val input = preShifter.output.stage()
      val output = input.swapPayload(new ShifterOutput)
      output.payload.assignSomeByName(input.payload)

      val exp21 = input.rs2.exponent -^ input.rs1.exponent
      val shiftBy = exp21.asSInt.abs//rs1ExponentBigger ? (0-exp21) | exp21
      val shiftOverflow = (shiftBy >= p.internalMantissaSize+1+addExtraBits)
      val passThrough = shiftOverflow || (input.rs1.isZero) || (input.rs2.isZero)

      def absRs1Bigger = input.absRs1Bigger
      def rs1ExponentBigger = input.rs1ExponentBigger

      //Note that rs1ExponentBigger can be replaced by absRs1Bigger bellow to avoid xsigned two complement in math block at expense of combinatorial path
      val xySign = absRs1Bigger ? input.rs1.sign | input.rs2.sign
      output.xSign := xySign ^ (rs1ExponentBigger ? input.rs1.sign | input.rs2.sign)
      output.ySign := xySign ^ (rs1ExponentBigger ? input.rs2.sign | input.rs1.sign)
      val xMantissa = U"1" @@ (rs1ExponentBigger ? input.rs1.mantissa | input.rs2.mantissa)
      val yMantissaUnshifted = U"1" @@ (rs1ExponentBigger ? input.rs2.mantissa | input.rs1.mantissa)
      var yMantissa = CombInit(yMantissaUnshifted)
      val roundingScrap = False
      for(i <- log2Up(p.internalMantissaSize) - 1 downto 0){
        roundingScrap setWhen(shiftBy(i) && yMantissa(0, 1 << i bits) =/= 0)
        yMantissa \= shiftBy(i) ? (yMantissa |>> (BigInt(1) << i)) | yMantissa
      }
      when(passThrough) { yMantissa := 0 }
      when(shiftOverflow) { roundingScrap := True }
      when(input.rs1.special || input.rs2.special){ roundingScrap := False }
      output.xyExponent := rs1ExponentBigger ? input.rs1.exponent | input.rs2.exponent
      output.xMantissa := xMantissa
      output.yMantissa := yMantissa
      output.xySign := xySign
      output.roundingScrap := roundingScrap
    }

    class MathOutput extends ShifterOutput{
      val xyMantissa = UInt(p.internalMantissaSize+1+addExtraBits+1 bits)
    }

    val math = new Area {
      val input = shifter.output.stage()
      val output = input.swapPayload(new MathOutput)
      output.payload.assignSomeByName(input.payload)
      import input.payload._

      val xSigned = xMantissa.twoComplement(xSign) //TODO Is that necessary ?
      val ySigned = ((ySign ## Mux(ySign, ~yMantissa, yMantissa)).asUInt + (ySign && !roundingScrap).asUInt).asSInt //rounding here
      output.xyMantissa := U(xSigned +^ ySigned).trim(1 bits)

    }

    class OhOutput extends MathOutput{
      val shift = UInt(log2Up(p.internalMantissaSize+1+addExtraBits+1) bits)
    }

    val oh = new Area {
      val input = math.output.stage()
      val isCommited = commitConsume(_.add, input.source, input.fire && input.needCommit)
      val output = input.haltWhen(input.needCommit && !isCommited).swapPayload(new OhOutput)
      output.payload.assignSomeByName(input.payload)
      import input.payload._

      val shiftOh = OHMasking.first(output.xyMantissa.asBools.reverse) //The OhMasking.first can be processed in parallel to the xyMantissa carry chaine
//      output.shiftOh := shiftOh

      val shift = OHToUInt(shiftOh)
      output.shift := shift
    }


    class NormOutput extends AddInput{
      val mantissa = UInt(p.internalMantissaSize+1+addExtraBits+1 bits)
      val exponent = UInt(p.internalExponentSize+1 bits)
      val infinityNan, forceNan, forceZero, forceInfinity = Bool()
      val xySign, roundingScrap = Bool()
      val xyMantissaZero = Bool()
    }

    val norm = new Area{
      val input = oh.output.stage()
      val output = input.swapPayload(new NormOutput)
      output.payload.assignSomeByName(input.payload)
      import input.payload._

      output.mantissa := (xyMantissa |<< shift)
      output.exponent := xyExponent -^ shift + 1
      output.forceInfinity := (input.rs1.isInfinity || input.rs2.isInfinity)
      output.forceZero := xyMantissa === 0 || (input.rs1.isZero && input.rs2.isZero)
      output.infinityNan :=  (input.rs1.isInfinity && input.rs2.isInfinity && (input.rs1.sign ^ input.rs2.sign))
      output.forceNan := input.rs1.isNan || input.rs2.isNan || output.infinityNan
      output.xyMantissaZero := xyMantissa === 0
    }

    val result = new Area {
      val input = norm.output.pipelined()
      val output = input.swapPayload(new MergeInput())
      import input.payload._

      output.source := input.source
      output.rd := input.rd
      output.value.sign := xySign
      output.value.mantissa := (mantissa >> addExtraBits).resized
      output.value.exponent := exponent.resized
      output.value.special := False
      output.roundMode := input.roundMode
      if (p.withDouble) output.format := input.format
      output.scrap := (mantissa(1) | mantissa(0) | roundingScrap)

      output.NV := infinityNan || input.rs1.isNanSignaling || input.rs2.isNanSignaling
      output.DZ := False
      when(forceNan) {
        output.value.setNanQuiet
      } elsewhen (forceInfinity) {
        output.value.setInfinity
      } elsewhen (forceZero) {
        output.value.setZero
        when(xyMantissaZero || input.rs1.isZero && input.rs2.isZero) {
          output.value.sign := input.rs1.sign && input.rs2.sign
        }
        when((input.rs1.sign || input.rs2.sign) && input.roundMode === FpuRoundMode.RDN) {
          output.value.sign := True
        }
      }
    }
  }


  val merge = new Area {
    val inputs = ArrayBuffer[Stream[MergeInput]]()
    inputs += load.s1.output.stage()
    if(p.withSqrt) (inputs += sqrt.output)
    if(p.withDiv) (inputs += div.output)
    if(p.withAdd) (inputs += add.result.output)
    if(p.withMul) (inputs += mul.result.output)
    if(p.withShortPipMisc) (inputs += shortPip.output.pipelined(m2s = true))
    val arbitrated = StreamArbiterFactory.lowerFirst.noLock.on(inputs).toFlow
  }

  class RoundFront extends MergeInput{
    val mantissaIncrement = Bool()
    val roundAdjusted = Bits(2 bits)
    val exactMask = UInt(p.internalMantissaSize + 2 bits)
  }

  val roundFront = new Area {
    val input = merge.arbitrated.stage()
    val output = input.swapPayload(new RoundFront())
    output.payload.assignSomeByName(input.payload)

    val manAggregate = input.value.mantissa @@ input.scrap
    val expBase = muxDouble[UInt](input.format)(exponentF64Subnormal + 1)(exponentF32Subnormal + 1)
    val expDif = expBase -^ input.value.exponent
    val expSubnormal = !input.value.special && !expDif.msb
    var discardCount = (expSubnormal ? expDif.resize(log2Up(p.internalMantissaSize) bits) | U(0))
    if (p.withDouble) when(input.format === FpuFormat.FLOAT) {
      discardCount \= discardCount + 29
    }
    val exactMask = (List(True) ++ (0 until p.internalMantissaSize + 1).map(_ < discardCount)).asBits.asUInt
    val roundAdjusted = (True ## (manAggregate >> 1)) (discardCount) ## ((manAggregate & exactMask) =/= 0)

    val mantissaIncrement = !input.value.special && input.roundMode.mux(
      FpuRoundMode.RNE -> (roundAdjusted(1) && (roundAdjusted(0) || (U"01" ## (manAggregate >> 2)) (discardCount))),
      FpuRoundMode.RTZ -> False,
      FpuRoundMode.RDN -> (roundAdjusted =/= 0 && input.value.sign),
      FpuRoundMode.RUP -> (roundAdjusted =/= 0 && !input.value.sign),
      FpuRoundMode.RMM -> (roundAdjusted(1))
    )

    output.mantissaIncrement := mantissaIncrement
    output.roundAdjusted := roundAdjusted
    output.exactMask := exactMask
  }

  val roundBack = new Area{
    val input = roundFront.output.stage()
    val output = input.swapPayload(RoundOutput())
    import input.payload._

    val math = p.internalFloating()
    val mantissaRange = p.internalMantissaSize downto 1
    val adderMantissa = input.value.mantissa(mantissaRange) & (mantissaIncrement ? ~(exactMask.trim(1) >> 1) | input.value.mantissa(mantissaRange).maxValue)
    val adderRightOp = (mantissaIncrement ? (exactMask >> 1)| U(0)).resize(p.internalMantissaSize bits)
    val adder = KeepAttribute(KeepAttribute(input.value.exponent @@ adderMantissa) + KeepAttribute(adderRightOp) + KeepAttribute(U(mantissaIncrement)))
    val masked = adder & ~((exactMask >> 1).resize(p.internalMantissaSize).resize(widthOf(adder)))
    math.special := input.value.special
    math.sign := input.value.sign
    math.exponent := masked(p.internalMantissaSize, p.internalExponentSize bits)
    math.mantissa := masked(0, p.internalMantissaSize bits)

    val patched = CombInit(math)
    val nx,of,uf = False

    val ufSubnormalThreshold = muxDouble[UInt](input.format)(exponentF64Subnormal)(exponentF32Subnormal)
    val ufThreshold = muxDouble[UInt](input.format)(exponentF64Subnormal-52+1)(exponentF32Subnormal-23+1)
    val ofThreshold = muxDouble[UInt](input.format)(exponentF64Infinity-1)(exponentF32Infinity-1)

    //catch exact 1.17549435E-38 underflow, but, who realy care ?
//    val borringCase = input.value.exponent === ufSubnormalThreshold && roundAdjusted.asUInt < U"11"
//    when(!math.special && (math.exponent <= ufSubnormalThreshold || borringCase) && roundAdjusted.asUInt =/= 0){
//      uf := True
//    }
    val threshold = input.roundMode.mux(
      FpuRoundMode.RNE -> U"110",
      FpuRoundMode.RTZ -> U"110",
      FpuRoundMode.RDN -> (input.value.sign ? U"101" | U"111"),
      FpuRoundMode.RUP -> (input.value.sign ? U"111" | U"101"),
      FpuRoundMode.RMM -> U"110"
    )
    val borringRound = (input.value.mantissa(1 downto 0) ## input.scrap)
    if(p.withDouble) when(input.format === FpuFormat.FLOAT) { borringRound := (input.value.mantissa(30 downto 29) ## input.value.mantissa(28 downto 0).orR)}

    val borringCase = input.value.exponent === ufSubnormalThreshold && borringRound.asUInt < threshold
    when(!math.special && (math.exponent <= ufSubnormalThreshold || borringCase) && roundAdjusted.asUInt =/= 0){
      uf := True
    }
    when(!math.special && math.exponent > ofThreshold){
      nx := True
      of := True
      val doMax = input.roundMode.mux(
        FpuRoundMode.RNE -> (False),
        FpuRoundMode.RTZ -> (True),
        FpuRoundMode.RDN -> (!math.sign),
        FpuRoundMode.RUP -> (math.sign),
        FpuRoundMode.RMM -> (False)
      )
      when(doMax){
        patched.exponent := ofThreshold
        patched.mantissa.setAll()
      } otherwise {
        patched.setInfinity
      }
    }


    when(!math.special && math.exponent < ufThreshold){
      nx := True
      uf := True
      val doMin = input.roundMode.mux(
        FpuRoundMode.RNE -> (False),
        FpuRoundMode.RTZ -> (False),
        FpuRoundMode.RDN -> (math.sign),
        FpuRoundMode.RUP -> (!math.sign),
        FpuRoundMode.RMM -> (False)
      )
      when(doMin){
        patched.exponent := ufThreshold.resized
        patched.mantissa := 0
      } otherwise {
        patched.setZero
      }
    }


    nx setWhen(!input.value.special && (roundAdjusted =/= 0))
    val writes = rf.scoreboards.map(_.writes.readAsync(input.rd))
    val write = writes.toList.read(input.source)
    output.NX := nx & write
    output.OF := of & write
    output.UF := uf & write
    output.NV := input.NV & write
    output.DZ := input.DZ & write
    output.source := input.source
    output.rd := input.rd
    output.write := write
    if(p.withDouble) output.format := input.format
    output.value := patched
  }

  val writeback = new Area{
    val input = roundBack.output.stage()

    for(i <- 0 until portCount){
      val c = io.port(i).completion
      c.valid := input.fire && input.source === i
      c.flags.NX := input.NX
      c.flags.OF := input.OF
      c.flags.UF := input.UF
      c.flags.NV := input.NV
      c.flags.DZ := input.DZ
      c.written := input.write
    }

    when(input.valid){
      for(i <- 0 until portCount) {
        val port = rf.scoreboards(i).hitWrite
        port.valid setWhen(input.source === i)
        port.address := input.rd
        port.data := !rf.scoreboards(i).hit(input.rd) //TODO improve
      }
    }

    val port = rf.ram.writePort
    port.valid := input.valid && input.write
    port.address := input.source @@ input.rd
    port.data.value := input.value
    if(p.withDouble) {
      port.data.boxed := input.format === FpuFormat.FLOAT
      when(port.data.boxed){
        port.data.value.mantissa(p.internalMantissaSize-23-1 downto 0) := 0
      }
    }

    val randomSim = p.sim generate (in UInt(p.internalMantissaSize bits))
    if(p.sim) when(port.data.value.isZero || port.data.value.isInfinity){
      port.data.value.mantissa := randomSim
    }
    if(p.sim) when(input.value.special){
      port.data.value.exponent(p.internalExponentSize-1 downto 3) := randomSim.resized
      when(!input.value.isNan){
        port.data.value.exponent(2 downto 2) := randomSim.resized
      }
    }

    when(port.valid){
      assert(!(port.data.value.exponent === 0 && !port.data.value.special), "Special violation")
      assert(!(port.data.value.exponent === port.data.value.exponent.maxValue && !port.data.value.special), "Special violation")
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

  class Div(width : Int) extends Rtl{
    override def getName(): String = "div_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new UnsignedDivider(width,width, false).setDefinitionName(Div.this.getName()))
  }

  class Add(width : Int) extends Rtl{
    override def getName(): String = "add_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new Component{
      val a, b = in UInt(width bits)
      val result = out(a + b)
      setDefinitionName(Add.this.getName())
    })
  }

  class DivSqrtRtl(width : Int) extends Rtl{
    override def getName(): String = "DivSqrt_" + width
    override def getRtlPath(): String = getName() + ".v"
    SpinalVerilog(new FpuDiv(width).setDefinitionName(DivSqrtRtl.this.getName()))
  }

  val rtls = ArrayBuffer[Rtl]()
  rtls += new Fpu(
    "32",
    portCount = 1,
    FpuParameter(
//      withDivSqrt = false,
      withDouble = false
    )
  )
  rtls += new Fpu(
    "64",
    portCount = 1,
    FpuParameter(
//      withDivSqrt = false,
      withDouble = true
    )
  )

//  rtls += new Div(52)
//  rtls += new Div(23)
//  rtls += new Add(64)
//  rtls += new DivSqrtRtl(52)
//  rtls += new DivSqrtRtl(23)

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

//Fpu_32 ->
//Artix 7 -> 136 Mhz 1471 LUT 1336 FF
//Artix 7 -> 196 Mhz 1687 LUT 1371 FF
//Fpu_64 ->
//Artix 7 -> 105 Mhz 2822 LUT 2132 FF
//Artix 7 -> 161 Mhz 3114 LUT 2272 FF
//
//
//
//Fpu_32 ->
//Artix 7 -> 128 Mhz 1693 LUT 1481 FF
//Artix 7 -> 203 Mhz 1895 LUT 1481 FF
//Fpu_64 ->
//Artix 7 -> 99 Mhz 3073 LUT 2396 FF
//Artix 7 -> 164 Mhz 3433 LUT 2432 FF


//Fpu_32 ->
//Artix 7 -> 112 Mhz 1790 LUT 1666 FF
//Artix 7 -> 158 Mhz 1989 LUT 1701 FF
//Fpu_64 ->
//Artix 7 -> 100 Mhz 3294 LUT 2763 FF
//Artix 7 -> 151 Mhz 3708 LUT 2904 FF

//Fpu_32 ->
//Artix 7 -> 139 Mhz 1879 LUT 1713 FF
//Artix 7 -> 206 Mhz 2135 LUT 1723 FF
//Fpu_64 ->
//Artix 7 -> 106 Mhz 3502 LUT 2811 FF
//Artix 7 -> 163 Mhz 3905 LUT 2951 FF

//Fpu_32 ->
//Artix 7 -> 130 Mhz 1889 LUT 1835 FF
//Artix 7 -> 210 Mhz 2131 LUT 1845 FF
//Fpu_64 ->
//Artix 7 -> 106 Mhz 3322 LUT 3023 FF
//Artix 7 -> 161 Mhz 3675 LUT 3163 FF

//Fpu_32 ->
//Artix 7 -> 132 Mhz 1891 LUT 1837 FF
//Artix 7 -> 209 Mhz 2132 LUT 1847 FF
//Fpu_64 ->
//Artix 7 -> 105 Mhz 3348 LUT 3024 FF
//Artix 7 -> 162 Mhz 3712 LUT 3165 FF

//Fpu_32 ->
//Artix 7 -> 128 Mhz 1796 LUT 1727 FF
//Artix 7 -> 208 Mhz 2049 LUT 1727 FF
//Fpu_64 ->
//Artix 7 -> 109 Mhz 3417 LUT 2913 FF
//Artix 7 -> 168 Mhz 3844 LUT 3053 FF

/*
testfloat  -tininessafter -all1 > all1.txt
cat all1.txt | grep "Errors found in"

testfloat  -tininessafter -all2 > all2.txt
cat all2.txt | grep "Errors found in"

testfloat  -tininessafter -f32_mulAdd > fma.txt

testfloat  -tininessafter -all2  -level 2 -checkall  > all2.txt



all1 =>
Errors found in f32_to_ui64_rx_minMag:
Errors found in f32_to_i64_rx_minMag:
Errors found in f64_to_ui64_rx_minMag:
Errors found in f64_to_i64_rx_minMag:

all2 =>


Errors found in f32_mulAdd, rounding min:
+00.7FFFFF  +67.000001  -01.000000
        => -01.000000 ...ux  expected -01.000000 ....x
+67.000001  +00.7FFFFF  -01.000000
        => -01.000000 ...ux  expected -01.000000 ....x
-00.7FFFFF  -67.000001  -01.000000
        => -01.000000 ...ux  expected -01.000000 ....x
-67.000001  -00.7FFFFF  -01.000000
        => -01.000000 ...ux  expected -01.000000 ....x
Errors found in f32_mulAdd, rounding max:
+00.7FFFFF  -67.000001  +01.000000
        => +01.000000 ...ux  expected +01.000000 ....x
+67.000001  -00.7FFFFF  +01.000000
        => +01.000000 ...ux  expected +01.000000 ....x
+66.7FFFFE  -01.000001  +01.000000
        => +01.000000 ...ux  expected +01.000000 ....x
-00.7FFFFF  +67.000001  +01.000000
        => +01.000000 ...ux  expected +01.000000 ....x
-67.000001  +00.7FFFFF  +01.000000
        => +01.000000 ...ux  expected +01.000000 ....x



 */