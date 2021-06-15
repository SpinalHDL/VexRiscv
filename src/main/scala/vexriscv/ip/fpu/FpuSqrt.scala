package vexriscv.ip.fpu

import spinal.core._
import spinal.lib._
import spinal.lib.sim.{StreamDriver, StreamMonitor, StreamReadyRandomizer}

import scala.collection.mutable
import scala.util.Random

case class FpuSqrtCmd(mantissaWidth : Int) extends Bundle{
  val a = UInt(mantissaWidth+2 bits)
}

case class FpuSqrtRsp(mantissaWidth : Int) extends Bundle{
  val result = UInt(mantissaWidth+1 bits)
  val remain = UInt(mantissaWidth+5 bits)
}

case class FpuSqrt(val mantissaWidth : Int) extends Component {
  val io = new Bundle{
    val input = slave Stream(FpuSqrtCmd(mantissaWidth))
    val output = master Stream(FpuSqrtRsp(mantissaWidth))
  }

  val iterations = mantissaWidth+2
  val counter = Reg(UInt(log2Up(iterations ) bits))
  val busy = RegInit(False) clearWhen(io.output.fire)
  val done = RegInit(False) setWhen(busy && counter === iterations-1) clearWhen(io.output.fire)

  val a = Reg(UInt(mantissaWidth+5 bits))
  val x = Reg(UInt(mantissaWidth bits))
  val q = Reg(UInt(mantissaWidth+1 bits))
  val t = a-(q @@ U"01")


  io.output.valid := done
  io.output.result := (q << 0).resized
  io.output.remain := a
  io.input.ready := !busy

  when(!done){
    counter := counter + 1
    val sel = CombInit(a)
    when(!t.msb){
      sel := t.resized
    }
    q := (q @@ !t.msb).resized
    a := (sel @@ x(widthOf(x)-2,2 bits)).resized
    x := x |<< 2
  }

  when(!busy){
    q := 0
    a := io.input.a(widthOf(io.input.a)-2,2 bits).resized
    x := (io.input.a).resized
    counter := 0
    when(io.input.valid){
      busy := True
    }
  }
}


object FpuSqrtTester extends App{
  import spinal.core.sim._

  for(w <- List(16)) {
    val config = SimConfig
    config.withFstWave
    config.compile(new FpuSqrt(w)).doSim(seed=2){dut =>
      dut.clockDomain.forkStimulus(10)


      val (cmdDriver, cmdQueue) = StreamDriver.queue(dut.io.input, dut.clockDomain)
      val rspQueue = mutable.Queue[FpuSqrtRsp => Unit]()
      StreamMonitor(dut.io.output, dut.clockDomain)( rspQueue.dequeue()(_))
      StreamReadyRandomizer(dut.io.output, dut.clockDomain)

      def test(a : Int): Unit ={
        cmdQueue +={p =>
          p.a #= a
        }
        rspQueue += {p =>
//          val x = (a * (1l << dut.mantissaWidth)).toLong
//          val result = Math.sqrt(x).toLong/(1 << dut.mantissaWidth/2)
//          val remain = a-x*x
          val x = a.toDouble / (1 << dut.mantissaWidth)
          val result = (Math.sqrt(x)*(1 << dut.mantissaWidth+1)).toLong
          val filtred = result  % (1 << dut.mantissaWidth+1)
//          val remain = (a-(result*result)).toLong
          assert(p.result.toLong == filtred, f"$a%x=${p.result.toLong}%x instead of $filtred%x")
//          assert(p.remain.toLong == remain, f"$a%x=${p.remain.toLong}%x instead of $remain%x")
        }
      }

      val s = dut.mantissaWidth-16
      val f = (1 << dut.mantissaWidth)-1
//      test(121)
      test(0x20000)
      test(0x18000)
//      test(0,0)
//      test(0,f)
//      test(f,0)
//      test(f,f)

      for(i <- 0 until 10000){
        test(Random.nextInt(3 << dut.mantissaWidth) + (1 << dut.mantissaWidth))
      }

      waitUntil(rspQueue.isEmpty)

      dut.clockDomain.waitSampling(100)

    }
  }
}