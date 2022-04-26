package vexriscv.periph.gcd

import spinal.core._
import spinal.lib._
import spinal.lib.IMasterSlave

case class GCDDataControl() extends Bundle with IMasterSlave{
  val cmpAgtB = Bool
  val cmpAltB = Bool
  val loadA = Bool
  val loadB = Bool
  val init = Bool
  val selL = Bool
  val selR = Bool
  // define <> semantic
  override def asMaster(): Unit = {
    // as controller: output, input
    out(loadA, loadB, selL, selR, init)
    in(cmpAgtB, cmpAltB)
  }
}

//Hardware definition
class GCDTop() extends Component {
  val io = new Bundle {
    val valid = in Bool()
    val ready = out Bool()
    val a = in(UInt(32 bits))
    val b = in(UInt(32 bits))
    val res = out(UInt(32 bits))
  }
  val gcdCtr = new GCDCtrl()
  gcdCtr.io.valid := io.valid
  io.ready := gcdCtr.io.ready
  val gcdDat = new GCDData()
  gcdDat.io.a := io.a
  gcdDat.io.b := io.b
  io.res := gcdDat.io.res 
  gcdCtr.io.dataCtrl <> gcdDat.io.dataCtrl
}

object GCDTopVerilog {
  def main(args: Array[String]) {
    SpinalVerilog(new GCDTop)
  }
}