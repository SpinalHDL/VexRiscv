package vexriscv.periph.gcd

import spinal.core._
import spinal.lib._
import spinal.lib.slave

//Hardware definition
class GCDData() extends Component {
  val io = new Bundle {
    val a = in(UInt(32 bits))
    val b = in(UInt(32 bits))
    val res = out(UInt(32 bits))
    val dataCtrl = slave(GCDDataControl())
  }
  /*
  *
  * // Pseudocode of the Euclids algorithm for calculating the GCD
  *  inputs:  [a, b, start]
  *  outputs: [done, a]
  *  done := False
  *  while(!done):
  *    if(a > b):
  *      a := a - b
  *    else if(b > a):
  *      b := b - a
  *    else:
  *      done := True
  */
  //registers
  val regA = Reg(UInt(32 bits)) init(0)
  val regB = Reg(UInt(32 bits)) init(0)
  // compare
  val xGTy = regA > regB
  val xLTy = regA < regB
  // mux
  val chX = io.dataCtrl.selL ? regB | regA
  val chY = io.dataCtrl.selR ? regB | regA
  // subtract
  val subXY = chX - chY
  // load logic
  when(io.dataCtrl.init){
    regA := io.a
    regB := io.b
  }
  when(io.dataCtrl.loadA){
    regA := subXY
  }
  when(io.dataCtrl.loadB){
    regB := subXY
  }
  io.dataCtrl.cmpAgtB := xGTy
  io.dataCtrl.cmpAltB := xLTy
  io.res := regA
}