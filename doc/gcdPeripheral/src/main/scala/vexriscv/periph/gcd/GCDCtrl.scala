package vexriscv.periph.gcd

import spinal.core._
import spinal.lib._
import spinal.lib.master
import spinal.lib.fsm._

//Hardware definition
class GCDCtrl() extends Component {
  val io = new Bundle {
    val valid = in Bool()
    val ready = out Bool()
    val dataCtrl = master(GCDDataControl())
  }
  val fsm = new StateMachine{
    io.dataCtrl.loadA := False
    io.dataCtrl.loadB := False
    io.dataCtrl.init := False
    io.dataCtrl.selL := False
    io.dataCtrl.selR := False
    io.ready := False
    val idle : State = new State with EntryPoint{
      whenIsActive{
        when(io.valid){
          io.dataCtrl.init := True
          goto(calculate)
        }
      }
    }
    val calculate : State = new State{
      whenIsActive{
        when(io.dataCtrl.cmpAgtB){
          goto(calcA)
        }.elsewhen(io.dataCtrl.cmpAltB){
          goto(calcB)
        }.elsewhen(!io.dataCtrl.cmpAgtB & !io.dataCtrl.cmpAgtB){
          goto(calcDone)
        }
      }
    }
    val calcA : State = new State{
      whenIsActive{
        io.dataCtrl.selR := True
        io.dataCtrl.loadA := True
        goto(calculate)
      }
    }
    val calcB : State = new State{
      whenIsActive{
        io.dataCtrl.selL := True
        io.dataCtrl.loadB := True
        goto(calculate)
      }
    }
    val calcDone : State = new State{
      whenIsActive{
        io.ready := True
        goto(idle)
      }
    }
  }
}

object GCDCtrlVerilog {
  def main(args: Array[String]) {
    SpinalVerilog(new GCDCtrl)
  }
}