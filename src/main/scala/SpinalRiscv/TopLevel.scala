/*
 * SpinalHDL
 * Copyright (c) Dolu, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

package SpinalRiscv

import java.io.File

import spinal.core._
import spinal.lib._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


object Riscv{
  def funct7Range = 31 downto 25
  def rdRange = 11 downto 7
  def funct3Range = 14 downto 12
  def rs1Range = 19 downto 15
  def rs2Range = 24 downto 20

  case class IMM(instruction  : Bits) extends Area{
    // immediates
    def i = instruction(31 downto 20)
    def s = instruction(31, 25) ## instruction(11, 7)
    def b = instruction(31) ## instruction(7) ## instruction(30 downto 25) ## instruction(11 downto 8)
    def u = instruction(31 downto 12) ## U"x000"
    def j = instruction(31) ## instruction(19 downto 12) ## instruction(20) ## instruction(30 downto 21)
    def z = instruction(19 downto 15)

    // sign-extend immediates
    def i_sext = B((19 downto 0) -> i(11)) ## i
    def s_sext = B((19 downto 0) -> s(11)) ## s
    def b_sext = B((18 downto 0) -> b(11)) ## b ## False
    def j_sext = B((10 downto 0) -> j(19)) ## j ## False
  }


  def ADD                = M"0000000----------000-----0110011"
  def SUB                = M"0100000----------000-----0110011"
  def SLL                = M"0000000----------001-----0110011"
  def SLT                = M"0000000----------010-----0110011"
  def SLTU               = M"0000000----------011-----0110011"
  def XOR                = M"0000000----------100-----0110011"
  def SRL                = M"0000000----------101-----0110011"
  def SRA                = M"0100000----------101-----0110011"
  def OR                 = M"0000000----------110-----0110011"
  def AND                = M"0000000----------111-----0110011"

  def ADDI               = M"-----------------000-----0010011"
  def SLLI               = M"000000-----------001-----0010011"
  def SLTI               = M"-----------------010-----0010011"
  def SLTIU              = M"-----------------011-----0010011"
  def XORI               = M"-----------------100-----0010011"
  def SRLI               = M"000000-----------101-----0010011"
  def SRAI               = M"010000-----------101-----0010011"
  def ORI                = M"-----------------110-----0010011"
  def ANDI               = M"-----------------111-----0010011"
}



case class VexRiscvConfig(pcWidth : Int){
  val plugins = ArrayBuffer[Plugin[VexRiscv]]()

  //Default Stageables
  object BYPASSABLE_EXECUTE_STAGE   extends Stageable(Bool)
  object BYPASSABLE_MEMORY_STAGE   extends Stageable(Bool)
  object Execute1Bypass   extends Stageable(Bool)
  object REG1   extends Stageable(Bits(32 bits))
  object REG2   extends Stageable(Bits(32 bits))
  object RESULT extends Stageable(UInt(32 bits))
  object PC extends Stageable(UInt(pcWidth bits))
  object INSTRUCTION extends Stageable(Bits(32 bits))
  object LEGAL_INSTRUCTION extends Stageable(Bool)
  object REGFILE_WRITE_VALID extends Stageable(Bool)
  object REGFILE_WRITE_DATA extends Stageable(Bits(32 bits))

  object SRC1   extends Stageable(Bits(32 bits))
  object SRC2   extends Stageable(Bits(32 bits))
  object SRC_ADD_SUB extends Stageable(Bits(32 bits))
  object SRC_LESS extends Stageable(Bool)
  object SRC_USE_SUB_LESS extends Stageable(Bool)
  object SRC_LESS_UNSIGNED extends Stageable(Bool)


  object ALU_RESULT extends Stageable(Bits(32 bits))

  object Src1CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMU, IMZ, IMJB = newElement()
  }

  object Src2CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMI, IMS, PC = newElement()
  }
  object SRC1_CTRL  extends Stageable(Src1CtrlEnum())
  object SRC2_CTRL  extends Stageable(Src2CtrlEnum())
}



class VexRiscv(val config : VexRiscvConfig) extends Component with Pipeline{
  type  T = VexRiscv

  stages ++= List.fill(6)(new Stage())
  val prefetch :: fetch :: decode :: execute :: memory :: writeBack :: Nil = stages.toList
  plugins ++= config.plugins
}


trait DecoderService{
  def add(key : MaskedLiteral,values : Seq[(Stageable[_ <: Data],Any)])
  def add(encoding :Seq[(MaskedLiteral,Seq[(Stageable[_ <: Data],Any)])])
}

class DecoderSimplePlugin extends Plugin[VexRiscv] with DecoderService {
  override def add(encoding: Seq[(MaskedLiteral, Seq[(Stageable[_ <: Data], Any)])]): Unit = encoding.foreach(e => this.add(e._1,e._2))
  override def add(key: MaskedLiteral, values: Seq[(Stageable[_ <: Data], Any)]): Unit = {
    require(!encodings.contains(key))
    encodings(key) = values.map{case (a,b) => (a,b match{
      case e : SpinalEnumElement[_] => e()
      case e => e
    })}
  }

  val encodings = mutable.HashMap[MaskedLiteral,Seq[(Stageable[_ <: Data], Any)]]()

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.decode._
    import pipeline.config._

    val stageables = encodings.flatMap(_._2.map(_._1)).toSet
    stageables.foreach(e => (insert(e).asInstanceOf[Data] := e().asInstanceOf[Data].getZero))
    stageables.foreach(insert(_) match{
      case e : Bits => println(e.getWidth)
      case _ =>
    })
    for((key,values) <- encodings){
      when(input(INSTRUCTION) === key){
        for((stageable,value) <- values){
          insert(stageable).assignFrom(value.asInstanceOf[AnyRef],false)
        }
      }
    }
  }
}

trait PcManagerService{
  def jumpTo(pc : UInt,cond : Bool,stage : Stage) : Unit
}

class PcManagerSimplePlugin(resetVector : BigInt,fastFetchCmdPcCalculation : Boolean) extends Plugin[VexRiscv] with PcManagerService{


  //FetchService interface
  case class JumpInfo(pc: UInt, cond: Bool, stage: Stage)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def jumpTo(pc: UInt, cond: Bool, stage: Stage): Unit = jumpInfos += JumpInfo(pc,cond,stage)


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.prefetch
    import pipeline.config._

    prefetch plug new Area {
      import prefetch._
      //Stage always valid
      arbitration.isValid := True

      //PC calculation without Jump
      val pc = Reg(UInt(pcWidth bits)) init(resetVector)
      when(arbitration.isValid && !arbitration.isStuck){
        val pcPlus4 = pc + 4
        if(fastFetchCmdPcCalculation) pcPlus4.addAttribute("keep") //Disallow to use the carry in as enable
        pc := pcPlus4
      }

      //FetchService hardware implementation
      val jump = if(jumpInfos.length != 0) {
        val sortedByStage = jumpInfos.sortWith((a, b) => pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage))
        val valids = sortedByStage.map(_.cond)
        val pcs = sortedByStage.map(_.pc)

        val pcLoad = Flow(UInt(pcWidth bits))
        pcLoad.valid := jumpInfos.foldLeft(False)(_ || _.cond)
        pcLoad.payload := MuxOH(valids, pcs)

        //Register managments
        when(pcLoad.valid) {
          pc := pcLoad.payload
          arbitration.removeIt := True
        }
      }

      //Pipeline insertions
      insert(PC) := pc
    }
  }
}

case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle{
  val inst = Bits(32 bits)
}

class IBusSimplePlugin extends Plugin[VexRiscv]{
  var iCmd  : Stream[IBusSimpleCmd] = null
  var iRsp  : IBusSimpleRsp = null

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    iCmd = master(Stream(IBusSimpleCmd()))
    iCmd.valid := prefetch.arbitration.isFiring
    iCmd.pc := prefetch.output(PC)

    iRsp = in(IBusSimpleRsp())
    fetch.insert(INSTRUCTION) := iRsp.inst
  }
}

trait RegFileReadKind
object ASYNC extends RegFileReadKind
object SYNC extends RegFileReadKind

class RegFilePlugin(regFileReadyKind : RegFileReadKind) extends Plugin[VexRiscv]{

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val global = pipeline plug new Area{
      val regFile = Mem(Bits(32 bits),32)
    }

    decode plug new Area{
      import decode._
      
      val rs1 = input(INSTRUCTION)(Riscv.rs1Range).asUInt
      val rs2 = input(INSTRUCTION)(Riscv.rs2Range).asUInt

      //read register file
      val srcInstruction = regFileReadyKind match{
        case `ASYNC` => input(INSTRUCTION)
        case `SYNC` =>  Mux(arbitration.isStuck,input(INSTRUCTION),fetch.output(INSTRUCTION))
      }

      val regFileReadAddress1 = srcInstruction(Riscv.rs1Range).asUInt
      val regFileReadAddress2 = srcInstruction(Riscv.rs2Range).asUInt

      val (rs1Data,rs2Data) = regFileReadyKind match{
        case `ASYNC` => (global.regFile.readAsync(regFileReadAddress1),global.regFile.readAsync(regFileReadAddress2))
        case `SYNC` =>  (global.regFile.readSync(regFileReadAddress1),global.regFile.readSync(regFileReadAddress2))
      }
      
      insert(REG1) := Mux(rs1 =/= 0, rs1Data, B(0, 32 bit))
      insert(REG2) := Mux(rs2 =/= 0, rs2Data, B(0, 32 bit))
    }
    
    writeBack plug new Area{
      import writeBack._
      //TODO write regfile
    }
  }
}



class SrcPlugin extends Plugin[VexRiscv]{
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    decode plug new Area{
      import decode._

      val imm = Riscv.IMM(input(INSTRUCTION))
      insert(SRC1) := input(SRC1_CTRL).mux(
        Src1CtrlEnum.RS -> output(REG1),
        Src1CtrlEnum.IMU -> imm.u.resized,
        Src1CtrlEnum.IMZ -> imm.z.resized,
        Src1CtrlEnum.IMJB -> B(0) //TODO
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

class IntAluPlugin extends Plugin[VexRiscv]{

  object AluCtrlEnum extends SpinalEnum(binarySequential){
    val ADD_SUB, SLT_SLTU, XOR, OR, AND = newElement()
  }

  object ALU_CTRL extends Stageable(AluCtrlEnum())

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import Riscv._

    val immediateActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True
    )

    pipeline.service(classOf[DecoderService]).add(List(
      ADD  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> False)),
      SUB  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> True)),
      SLT  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> False)),
      SLTU -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> True)),
      XOR  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.XOR)),
      OR   -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.OR)),
      AND  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.AND))
    ))

    pipeline.service(classOf[DecoderService]).add(List(
      ADDI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> False)),
      SLTI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> False)),
      SLTIU -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> True)),
      XORI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.XOR)),
      ORI   -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.OR)),
      ANDI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.AND))
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    execute plug new Area{
      import execute._

      // mux results
      insert(ALU_RESULT) := input(ALU_CTRL).mux(
        AluCtrlEnum.AND      -> (input(SRC1) & input(SRC2)),
        AluCtrlEnum.OR       -> (input(SRC1) | input(SRC2)),
        AluCtrlEnum.XOR      -> (input(SRC1) ^ input(SRC2)),
        AluCtrlEnum.SLT_SLTU -> input(SRC_LESS).asBits(32 bit),
        AluCtrlEnum.ADD_SUB  -> input(SRC_ADD_SUB)
      )
    }
  }
}


class FullBarrielShifterPlugin extends Plugin[VexRiscv]{
  object ShiftCtrlEnum extends SpinalEnum(binarySequential){
    val DISABLE, SLL, SRL, SRA = newElement() //TODO default
  }

  object SHIFT_CTRL extends Stageable(ShiftCtrlEnum())
  object SHIFT_RIGHT extends Stageable(Bits(32 bits))

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import Riscv._

    val immediateActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> True
    )

    pipeline.service(classOf[DecoderService]).add(List(
      SLL  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SLL)),
      SRL  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRL)),
      SRA  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRA))
    ))

    pipeline.service(classOf[DecoderService]).add(List(
      SLLI  -> (immediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SLL)),
      SRLI  -> (immediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRL)),
      SRAI  -> (immediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRA))
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    execute plug new Area{
      import execute._
      val amplitude  = input(SRC2)(4 downto 0).asUInt
      val reversed   = Mux(input(SHIFT_CTRL) === ShiftCtrlEnum.SLL, Reverse(input(SRC1)), input(SRC1))
      insert(SHIFT_RIGHT) := (Cat(input(SHIFT_CTRL) === ShiftCtrlEnum.SRA & reversed.msb, reversed).asSInt >> amplitude)(31 downto 0).asBits
    }

    memory plug new Area{
      import memory._
      switch(input(SHIFT_CTRL)){
        is(ShiftCtrlEnum.SLL){
          output(ALU_RESULT) := Reverse(input(SHIFT_RIGHT))
        }
        is(ShiftCtrlEnum.SRL,ShiftCtrlEnum.SRA){
          output(ALU_RESULT) := input(SHIFT_RIGHT)
        }
      }
    }
  }
}

class OutputAluResult extends Plugin[VexRiscv]{
  override def build(pipeline: VexRiscv): Unit = {
    out(pipeline.writeBack.input(pipeline.config.ALU_RESULT))
  }
}


object TopLevel {
  def main(args: Array[String]) {
    SpinalVhdl{
      val config = VexRiscvConfig(
        pcWidth = 32
      )

      config.plugins ++= List(
        new PcManagerSimplePlugin(0,true),
        new IBusSimplePlugin,
        new DecoderSimplePlugin,
        new RegFilePlugin(SYNC),
        new IntAluPlugin,
        new SrcPlugin,
        new FullBarrielShifterPlugin,
        new OutputAluResult
      )

      new VexRiscv(config)
    }
  }
}

