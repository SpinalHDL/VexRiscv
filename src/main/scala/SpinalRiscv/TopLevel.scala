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

object StandardStageables{
  object Execute0Bypass   extends Stageable(Bool)
  object Execute1Bypass   extends Stageable(Bool)
  object SRC1   extends Stageable(UInt(32 bits))
  object SRC2   extends Stageable(UInt(32 bits))
  object RESULT extends Stageable(UInt(32 bits))
  object PC extends Stageable(UInt())
  object INST extends Stageable(Bits(32 bits))
}

class SpinalRiscv(pluginConfig : Seq[Plugin[SpinalRiscv]]) extends Component with Pipeline{
  type  T = SpinalRiscv

  stages ++= List.fill(6)(new Stage())
  val prefetch :: fetch :: decode :: execute :: memory :: writeBack :: Nil = stages.toList
  plugins ++= pluginConfig
}


trait DecoderService{
  def add(key : MaskedLiteral,values : Seq[(Stageable[_],BaseType)])
  def add(encoding :Seq[(MaskedLiteral,Seq[(Stageable[_],BaseType)])])
}

class DecoderSimplePlugin extends Plugin[SpinalRiscv] with DecoderService {
  override def add(encoding: Seq[(MaskedLiteral, Seq[(Stageable[_], BaseType)])]): Unit = encoding.foreach(e => this.add(e._1,e._2))
  override def add(key: MaskedLiteral, values: Seq[(Stageable[_], BaseType)]): Unit = {
    ???
  }

  override def build(pipeline: SpinalRiscv): Unit = ???
}

trait PcManagerService{
  def jumpTo(pc : UInt,cond : Bool,stage : Stage) : Unit
}

class PcManagerSimplePlugin(resetVector : BigInt,pcWidth : Int,fastFetchCmdPcCalculation : Boolean) extends Plugin[SpinalRiscv] with PcManagerService{
  import StandardStageables._

  //FetchService interface
  case class JumpInfo(pc: UInt, cond: Bool, stage: Stage)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def jumpTo(pc: UInt, cond: Bool, stage: Stage): Unit = jumpInfos += JumpInfo(pc,cond,stage)


  override def build(pipeline: SpinalRiscv): Unit = {
    import pipeline.prefetch

    prefetch.plug(new Area {
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
    })
  }
}

case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle{
  val inst = Bits(32 bits)
}

class IBusSimplePlugin extends Plugin[SpinalRiscv]{
  import StandardStageables._
  var iCmd  : Stream[IBusSimpleCmd] = null
  var iRsp  : IBusSimpleRsp = null

  override def build(pipeline: SpinalRiscv): Unit = {
    import pipeline._

    iCmd = master(Stream(IBusSimpleCmd()))
    iCmd.valid := prefetch.arbitration.isFiring
    iCmd.pc := prefetch.output(PC)

    iRsp = IBusSimpleRsp()
    fetch.insert(INST) := iRsp.inst
  }
}

class IntAluPlugin extends Plugin[SpinalRiscv]{
  import StandardStageables._


  override def setup(pipeline: SpinalRiscv): Unit = {
    pipeline.service(classOf[DecoderService]).add(List(
      M"0101010---" ->
        List(
          Execute0Bypass -> True,
          Execute1Bypass -> True
        )
      )
    )
  }

  override def build(pipeline: SpinalRiscv): Unit = {
    import pipeline._


  }


}


object MyTopLevel {
  def main(args: Array[String]) {
    SpinalVhdl(new SpinalRiscv(List(
//        new IntAluPlugin
      new PcManagerSimplePlugin(0,32,true),
      new IBusSimplePlugin
    )))
  }
}

