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

import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer


object Riscv{
  def funct7Range = 31 downto 25
  def rdRange = 11 downto 7
  def funct3Range = 14 downto 12
  def rs1Range = 19 downto 15
  def rs2Range = 24 downto 20
}


case class VexRiscvConfig(pcWidth : Int){
  val plugins = ArrayBuffer[Plugin[VexRiscv]]()

  //Default Stageables
  object Execute0Bypass   extends Stageable(Bool)
  object Execute1Bypass   extends Stageable(Bool)
  object SRC1   extends Stageable(Bits(32 bits))
  object SRC2   extends Stageable(Bits(32 bits))
  object RESULT extends Stageable(UInt(32 bits))
  object PC extends Stageable(UInt(pcWidth bits))
  object INSTRUCTION extends Stageable(Bits(32 bits))
}



class VexRiscv(val config : VexRiscvConfig) extends Component with Pipeline{
  type  T = VexRiscv

  stages ++= List.fill(6)(new Stage())
  val prefetch :: fetch :: decode :: execute :: memory :: writeBack :: Nil = stages.toList
  plugins ++= config.plugins
}


trait DecoderService{
  def add(key : MaskedLiteral,values : Seq[(Stageable[_],BaseType)])
  def add(encoding :Seq[(MaskedLiteral,Seq[(Stageable[_],BaseType)])])
}

class DecoderSimplePlugin extends Plugin[VexRiscv] with DecoderService {
  override def add(encoding: Seq[(MaskedLiteral, Seq[(Stageable[_], BaseType)])]): Unit = encoding.foreach(e => this.add(e._1,e._2))
  override def add(key: MaskedLiteral, values: Seq[(Stageable[_], BaseType)]): Unit = {
    ???
  }

  override def build(pipeline: VexRiscv): Unit = ???
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
      
      val addr0 = input(INSTRUCTION)(Riscv.rs1Range).asUInt
      val addr1 = input(INSTRUCTION)(Riscv.rs2Range).asUInt

      //read register file
      val srcInstruction = regFileReadyKind match{
        case `ASYNC` => input(INSTRUCTION)
        case `SYNC` =>  Mux(arbitration.isStuck,input(INSTRUCTION),fetch.output(INSTRUCTION))
      }

      val regFileReadAddress0 = srcInstruction(Riscv.rs1Range).asUInt
      val regFileReadAddress1 = srcInstruction(Riscv.rs2Range).asUInt

      val (src0,src1) = regFileReadyKind match{
        case `ASYNC` => (global.regFile.readAsync(regFileReadAddress0),global.regFile.readAsync(regFileReadAddress1))
        case `SYNC` =>  (global.regFile.readSync(regFileReadAddress0),global.regFile.readSync(regFileReadAddress1))
      }
      
      insert(SRC1) := Mux(addr0 =/= 0, src0, B(0, 32 bit))
      insert(SRC2) := Mux(addr1 =/= 0, src1, B(0, 32 bit))
    }
    
    writeBack plug new Area{
      import writeBack._
      //TODO write regfile
    }
  }
}

class IntAluPlugin extends Plugin[VexRiscv]{



//  override def setup(pipeline: VexRiscv): Unit = {
//    pipeline.service(classOf[DecoderService]).add(List(
//      M"0101010---" ->
//        List(
//          Execute0Bypass -> True,
//          Execute1Bypass -> True
//        )
//      )
//    )
//  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    out(execute.input(SRC1) & execute.input(SRC2))

  }


}


object MyTopLevel {
  def main(args: Array[String]) {
    SpinalVhdl{
      val config = VexRiscvConfig(
        pcWidth = 32
      )

      config.plugins ++= List(
        new PcManagerSimplePlugin(0,true),
        new IBusSimplePlugin,
        new RegFilePlugin(SYNC),
        new IntAluPlugin
      )

      new VexRiscv(config)
    }
  }
}

