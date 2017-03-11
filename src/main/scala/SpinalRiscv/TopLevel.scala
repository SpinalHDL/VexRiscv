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

import SpinalRiscv.Riscv.IMM
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

  def LB                 = M"-----------------000-----0000011"
  def LH                 = M"-----------------001-----0000011"
  def LW                 = M"-----------------010-----0000011"
  def LBU                = M"-----------------100-----0000011"
  def LHU                = M"-----------------101-----0000011"
  def LWU                = M"-----------------110-----0000011"
  def SB                 = M"-----------------000-----0100011"
  def SH                 = M"-----------------001-----0100011"
  def SW                 = M"-----------------010-----0100011"

  def BEQ                = M"-----------------000-----1100011"
  def BNE                = M"-----------------001-----1100011"
  def BLT                = M"-----------------100-----1100011"
  def BGE                = M"-----------------101-----1100011"
  def BLTU               = M"-----------------110-----1100011"
  def BGEU               = M"-----------------111-----1100011"
  def JALR               = M"-----------------000-----1100111"
  def JAL                = M"-------------------------1101111"
  def LUI                = M"-------------------------0110111"
  def AUIPC              = M"-------------------------0010111"
}



case class VexRiscvConfig(pcWidth : Int){
  val plugins = ArrayBuffer[Plugin[VexRiscv]]()
//TODO apply defaults to decoder
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

  object SRC1_USE extends Stageable(Bool)
  object SRC2_USE extends Stageable(Bool)
  object SRC1   extends Stageable(Bits(32 bits))
  object SRC2   extends Stageable(Bits(32 bits))
  object SRC_ADD_SUB extends Stageable(Bits(32 bits))
  object SRC_LESS extends Stageable(Bool)
  object SRC_USE_SUB_LESS extends Stageable(Bool)
  object SRC_LESS_UNSIGNED extends Stageable(Bool)


  object Src1CtrlEnum extends SpinalEnum(binarySequential){
    val RS, IMU, FOUR = newElement()   //IMU, IMZ IMJB
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
  def addDefault(key : Stageable[_ <: Data], value : Any)
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

  override def addDefault(key: Stageable[_  <: Data], value: Any): Unit = {
    require(!defaults.contains(key))
    defaults(key) = value match{
      case e : SpinalEnumElement[_] => e()
      case e : Data => e
    }
  }

  val defaults = mutable.HashMap[Stageable[_ <: Data], Data]()
  val encodings = mutable.HashMap[MaskedLiteral,Seq[(Stageable[_ <: Data], Any)]]()

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.decode._
    import pipeline.config._

    val stageables = encodings.flatMap(_._2.map(_._1)).toSet
    stageables.foreach(e => if(defaults.contains(e.asInstanceOf[Stageable[Data]]))
      insert(e.asInstanceOf[Stageable[Data]]) := defaults(e.asInstanceOf[Stageable[Data]])
    else
      insert(e).assignDontCare())

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

class NoPredictionBranchPlugin extends Plugin[VexRiscv]{
  object BranchCtrlEnum extends SpinalEnum(binarySequential){
    val INC,B,JAL,JALR = newElement()
  }

  object BRANCH_CTRL extends Stageable(BranchCtrlEnum())
  object BRANCH_SOLVED extends Stageable(BranchCtrlEnum())

  var jumpInterface : Flow[UInt] = null

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import Riscv._

    val decoderService = pipeline.service(classOf[DecoderService])

    val bActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION -> True,
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC2_CTRL         -> Src2CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> True,
      SRC1_USE          -> True,
      SRC2_USE          -> True
    )

    val jActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION   -> True,
      SRC1_CTRL           -> Src1CtrlEnum.FOUR,
      SRC2_CTRL           -> Src2CtrlEnum.PC,
      SRC_USE_SUB_LESS    -> False,
      REGFILE_WRITE_VALID -> True,
      SRC2_USE            -> True
    )

    decoderService.addDefault(BRANCH_CTRL, BranchCtrlEnum.INC)
    decoderService.add(List(
      JAL  -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JAL)),
      JALR -> (jActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.JALR)),
      BEQ  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BNE  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B)),
      BLT  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BGE  -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> False)),
      BLTU -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True)),
      BGEU -> (bActions ++ List(BRANCH_CTRL -> BranchCtrlEnum.B, SRC_LESS_UNSIGNED -> True))
    ))

    jumpInterface = pipeline.service(classOf[PcManagerService]).createJumpInterface(pipeline.execute)
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    execute plug new Area {
      import execute._

      val less = input(SRC_LESS)
      val eq = input(SRC1) === input(SRC2)

      insert(BRANCH_SOLVED) := input(BRANCH_CTRL).mux[BranchCtrlEnum.C](
        BranchCtrlEnum.INC  -> BranchCtrlEnum.INC,
        BranchCtrlEnum.JAL  -> BranchCtrlEnum.JAL,
        BranchCtrlEnum.JALR -> BranchCtrlEnum.JALR,
        BranchCtrlEnum.B    -> input(INSTRUCTION)(14 downto 12).mux(
          B"000"  -> Mux( eq  , BranchCtrlEnum.B, BranchCtrlEnum.INC),
          B"001"  -> Mux(!eq  , BranchCtrlEnum.B, BranchCtrlEnum.INC),
          M"1-1"  -> Mux(!less, BranchCtrlEnum.B, BranchCtrlEnum.INC),
          default -> Mux( less, BranchCtrlEnum.B, BranchCtrlEnum.INC)
        )
      )

      val imm = IMM(input(INSTRUCTION))
      jumpInterface.valid := arbitration.isFiring && input(BRANCH_SOLVED) =/= BranchCtrlEnum.INC
      jumpInterface.payload := input(BRANCH_SOLVED).mux(
        BranchCtrlEnum.JAL  -> (input(PC)          + imm.j_sext.asUInt),
        BranchCtrlEnum.JALR -> (input(REG1).asUInt + imm.i_sext.asUInt),
        default             -> (input(PC)          + imm.b_sext.asUInt)    //B
      )
    }
  }
}



trait PcManagerService{
  def createJumpInterface(stage : Stage) : Flow[UInt]
}

class PcManagerSimplePlugin(resetVector : BigInt,fastFetchCmdPcCalculation : Boolean) extends Plugin[VexRiscv] with PcManagerService{


  //FetchService interface
  case class JumpInfo(interface :  Flow[UInt], stage: Stage)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def createJumpInterface(stage: Stage): Flow[UInt] = {
    val interface = Flow(UInt(32 bits))
    jumpInfos += JumpInfo(interface,stage)
    interface
  }


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
        val valids = sortedByStage.map(_.interface.valid)
        val pcs = sortedByStage.map(_.interface.payload)

        val pcLoad = Flow(UInt(pcWidth bits))
        pcLoad.valid := jumpInfos.foldLeft(False)(_ || _.interface.valid)
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

case class DBusSimpleCmd() extends Bundle{
  val wr = Bool
  val address = UInt(32 bits)
  val data = Bits(32 bit)
  val size = UInt(2 bit)
}

case class DBusSimpleRsp() extends Bundle{
  val data = Bits(32 bit)
}

class DBusSimplePlugin extends Plugin[VexRiscv]{

  var dCmd  : Stream[DBusSimpleCmd] = null
  var dRsp  : DBusSimpleRsp = null

  object MemoryCtrlEnum extends SpinalEnum{
    val WR, RD = newElement()
  }

  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_CTRL extends Stageable(MemoryCtrlEnum())
  object MEMORY_READ_DATA extends Stageable(Bits(32 bits))

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import Riscv._

    val decoderService = pipeline.service(classOf[DecoderService])

    val stdActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC_USE_SUB_LESS         -> False,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      MEMORY_ENABLE -> True,
      SRC1_USE -> True
    )

    decoderService.addDefault(MEMORY_ENABLE, False)
    decoderService.add(List(
      LB  -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMI,  REGFILE_WRITE_VALID -> True)),
      LH  -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMI,  REGFILE_WRITE_VALID -> True)),
      LW  -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMI,  REGFILE_WRITE_VALID -> True)),
      LBU  -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMI, REGFILE_WRITE_VALID -> True)),
      LHU  -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMI, REGFILE_WRITE_VALID -> True)),
      LWU  -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMI, REGFILE_WRITE_VALID -> True)),
      SB   -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMS, SRC2_USE -> True)),
      SH   -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMS, SRC2_USE -> True)),
      SW   -> (stdActions ++ List(SRC2_CTRL -> Src2CtrlEnum.IMS, SRC2_USE -> True))
    ))

  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    execute plug new Area{
      import execute._

      dCmd = master Stream(DBusSimpleCmd())
      dCmd.valid := input(MEMORY_ENABLE) && arbitration.isFiring
      dCmd.wr := input(INSTRUCTION)(5)
      dCmd.address := input(SRC_ADD_SUB).asUInt
      dCmd.payload.data := input(SRC2)
      dCmd.size := input(INSTRUCTION)(13 downto 12).asUInt
      when(input(MEMORY_ENABLE) && !dCmd.ready){
        arbitration.haltIt := True
      }
    }

    memory plug new Area {
      import memory._

      dRsp = in(DBusSimpleRsp())
      insert(MEMORY_READ_DATA) := dRsp.data
      assert(!(input(MEMORY_ENABLE) && !input(INSTRUCTION)(5) && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
    }

    writeBack plug new Area {
      import memory._

      dRsp = in(DBusSimpleRsp())
      val rspFormated = input(INSTRUCTION)(13 downto 12).mux(
        default -> input(MEMORY_READ_DATA), //W
        1 -> B((31 downto 8) -> (input(MEMORY_READ_DATA)(7) && !input(INSTRUCTION)(14)),(7 downto 0) -> input(MEMORY_READ_DATA)(7 downto 0)),
        2 -> B((31 downto 16) -> (input(MEMORY_READ_DATA)(15) && ! input(INSTRUCTION)(14)),(15 downto 0) -> input(MEMORY_READ_DATA)(15 downto 0))
      )

      when(input(MEMORY_ENABLE)) {
        input(REGFILE_WRITE_DATA) := rspFormated
      }

      assert(!(input(MEMORY_ENABLE) && !input(INSTRUCTION)(5) && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
    }
  }
}


class HazardSimplePlugin(bypassExecute : Boolean,bypassMemory: Boolean,bypassWriteBack: Boolean, bypassWriteBackBuffer : Boolean) extends Plugin[VexRiscv] {
  import Riscv._
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline._
    val src0Hazard = False
    val src1Hazard = False

    def trackHazardWithStage(stage : Stage,bypassable : Boolean, runtimeBypassable : Stageable[Bool]): Unit ={
      val runtimeBypassableValue = if(runtimeBypassable != null) stage.input(runtimeBypassable) else True
      val addr0Match = stage.input(INSTRUCTION)(rdRange) === decode.input(INSTRUCTION)(rs1Range)
      val addr1Match = stage.input(INSTRUCTION)(rdRange) === decode.input(INSTRUCTION)(rs2Range)
      when(stage.arbitration.isValid && stage.input(REGFILE_WRITE_VALID)) {
        if (bypassable) {
          when(runtimeBypassableValue) {
            when(addr0Match) {
              decode.input(REG1) := stage.output(REGFILE_WRITE_DATA)
            }
            when(addr1Match) {
              decode.input(REG2) := stage.output(REGFILE_WRITE_DATA)
            }
          }
        }
        when((Bool(!bypassable) || !runtimeBypassableValue)) {
          when(addr0Match) {
            src0Hazard := True
          }
          when(addr1Match) {
            src1Hazard := True
          }
        }
      }
    }


    val writeBackWrites = Flow(cloneable(new Bundle{
      val address = Bits(5 bits)
      val data = Bits(32 bits)
    }))
    writeBackWrites.valid := writeBack.output(REGFILE_WRITE_VALID) && writeBack.arbitration.isFiring
    writeBackWrites.address := writeBack.output(INSTRUCTION)(rdRange)
    writeBackWrites.data := writeBack.output(REGFILE_WRITE_DATA)
    val writeBackBuffer = writeBackWrites.stage()

    val addr0Match = writeBackBuffer.address === decode.input(INSTRUCTION)(rs1Range)
    val addr1Match = writeBackBuffer.address === decode.input(INSTRUCTION)(rs2Range)
    when(writeBackBuffer.valid) {
      if (bypassWriteBackBuffer) {
        when(addr0Match) {
          decode.input(REG1) := writeBackWrites.data
        }
        when(addr1Match) {
          decode.input(REG2) := writeBackWrites.data
        }
      } else {
        when(addr0Match) {
          src0Hazard := True
        }
        when(addr1Match) {
          src1Hazard := True
        }
      }
    }

    trackHazardWithStage(writeBack,bypassWriteBack,null)
    trackHazardWithStage(memory,bypassMemory,BYPASSABLE_MEMORY_STAGE)
    trackHazardWithStage(execute,bypassExecute,BYPASSABLE_EXECUTE_STAGE)


    when(decode.input(INSTRUCTION)(rs1Range) === 0 || !decode.input(SRC1_USE)){
      src0Hazard := False
    }
    when(decode.input(INSTRUCTION)(rs2Range) === 0 || !decode.input(SRC2_USE)){
      src1Hazard := False
    }

    when(src0Hazard || src1Hazard){
      decode.arbitration.haltIt := True
    }
  }
}

trait RegFileReadKind
object ASYNC extends RegFileReadKind
object SYNC extends RegFileReadKind

class RegFilePlugin(regFileReadyKind : RegFileReadKind) extends Plugin[VexRiscv]{
  import Riscv._
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
    
    writeBack plug new Area {
      import writeBack._

      val regFileWrite = global.regFile.writePort
      regFileWrite.valid := input(REGFILE_WRITE_VALID) && arbitration.isFiring
      regFileWrite.address := input(INSTRUCTION)(rdRange).asUInt
      regFileWrite.data := input(REGFILE_WRITE_DATA)
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

class IntAluPlugin extends Plugin[VexRiscv]{

  object AluCtrlEnum extends SpinalEnum(binarySequential){
    val ADD_SUB, SLT_SLTU, XOR, OR, AND, SRC1 = newElement()
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
      BYPASSABLE_MEMORY_STAGE  -> True,
      SRC1_USE -> True
    )

    val nonImmediateActions = List[(Stageable[_ <: Data],Any)](
      LEGAL_INSTRUCTION        -> True,
      SRC1_CTRL                -> Src1CtrlEnum.RS,
      SRC2_CTRL                -> Src2CtrlEnum.RS,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True,
      SRC1_USE -> True,
      SRC2_USE -> True
    )

    val otherAction = List(
      LEGAL_INSTRUCTION        -> True,
      REGFILE_WRITE_VALID      -> True,
      BYPASSABLE_EXECUTE_STAGE -> True,
      BYPASSABLE_MEMORY_STAGE  -> True
    )



    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.add(List(
      ADD  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> False)),
      SUB  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> True)),
      SLT  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> False)),
      SLTU -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> True)),
      XOR  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.XOR)),
      OR   -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.OR)),
      AND  -> (nonImmediateActions ++ List(ALU_CTRL -> AluCtrlEnum.AND))
    ))

    decoderService.add(List(
      ADDI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB,  SRC_USE_SUB_LESS -> False)),
      SLTI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> False)),
      SLTIU -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.SLT_SLTU, SRC_USE_SUB_LESS -> True, SRC_LESS_UNSIGNED -> True)),
      XORI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.XOR)),
      ORI   -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.OR)),
      ANDI  -> (immediateActions ++ List(ALU_CTRL -> AluCtrlEnum.AND))
    ))

    decoderService.add(List(
      LUI   -> (otherAction ++ List(ALU_CTRL -> AluCtrlEnum.SRC1)),
      AUIPC -> (otherAction ++ List(ALU_CTRL -> AluCtrlEnum.ADD_SUB, SRC_USE_SUB_LESS -> False, SRC1_CTRL -> Src1CtrlEnum.IMU, SRC2_CTRL -> Src2CtrlEnum.PC))
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._


    execute plug new Area{
      import execute._

      // mux results
      insert(REGFILE_WRITE_DATA) := input(ALU_CTRL).mux(
        AluCtrlEnum.AND      -> (input(SRC1) & input(SRC2)),
        AluCtrlEnum.OR       -> (input(SRC1) | input(SRC2)),
        AluCtrlEnum.XOR      -> (input(SRC1) ^ input(SRC2)),
        AluCtrlEnum.SRC1     -> input(SRC1),
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

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(SHIFT_CTRL, ShiftCtrlEnum.DISABLE)
    decoderService.add(List(
      SLL  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SLL)),
      SRL  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRL)),
      SRA  -> (nonImmediateActions ++ List(SHIFT_CTRL -> ShiftCtrlEnum.SRA))
    ))

    decoderService.add(List(
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
          output(REGFILE_WRITE_DATA) := Reverse(input(SHIFT_RIGHT))
        }
        is(ShiftCtrlEnum.SRL,ShiftCtrlEnum.SRA){
          output(REGFILE_WRITE_DATA) := input(SHIFT_RIGHT)
        }
      }
    }
  }
}

class OutputAluResult extends Plugin[VexRiscv]{
  override def build(pipeline: VexRiscv): Unit = {
    out(pipeline.writeBack.input(pipeline.config.REGFILE_WRITE_DATA))
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
        new DBusSimplePlugin,
        new HazardSimplePlugin(true,true,true,true),
//        new HazardSimplePlugin(false,false,false,false),
        new NoPredictionBranchPlugin,
        new OutputAluResult
      )

      new VexRiscv(config)
    }
  }
}

