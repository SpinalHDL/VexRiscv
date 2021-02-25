package vexriscv.ip.fpu


import spinal.core._
import spinal.lib.math.{UnsignedDividerCmd, UnsignedDividerRsp}
import spinal.lib._
import spinal.lib.sim.{StreamDriver, StreamMonitor, StreamReadyRandomizer}

import scala.collection.mutable
import scala.util.Random

case class FpuDivCmd(mantissaWidth : Int) extends Bundle{
  val a,b = UInt(mantissaWidth bits)
}

case class FpuDivRsp(mantissaWidth : Int) extends Bundle{
  val result = UInt(mantissaWidth+1 + 2 bits)
  val remain = UInt(mantissaWidth+1 bits)
}

case class FpuDiv(val mantissaWidth : Int) extends Component {
  assert(mantissaWidth % 2 == 0)
  val io = new Bundle{
    val input = slave Stream(FpuDivCmd(mantissaWidth))
    val output = master Stream(FpuDivRsp(mantissaWidth))
  }

  val iterations = (mantissaWidth+2+2)/2
  val counter = Reg(UInt(log2Up(iterations) bits))
  val busy = RegInit(False) clearWhen(io.output.fire)
  val done = RegInit(False) setWhen(busy && counter === iterations-1) clearWhen(io.output.fire)

  val shifter = Reg(UInt(mantissaWidth + 3 bits))
  val result = Reg(UInt(mantissaWidth+1+2 bits))

  val div1, div3 = Reg(UInt(mantissaWidth+3 bits))
  val div2 = div1 |<< 1

  val sub1 = shifter -^ div1
  val sub2 = shifter -^ div2
  val sub3 = shifter -^ div3

  io.output.valid := done
  io.output.result := (result << 0).resized
  io.output.remain := (shifter >> 2).resized
  io.input.ready := !busy

  when(!done){
    counter := counter + 1
    val sel = CombInit(shifter)
    result := result |<< 2
    when(!sub1.msb){
      sel := sub1.resized
      result(1 downto 0) := 1
    }
    when(!sub2.msb){
      sel := sub2.resized
      result(1 downto 0) := 2
    }
    when(!sub3.msb){
      sel := sub3.resized
      result(1 downto 0) := 3
    }
    shifter := sel |<< 2
  }

  when(!busy){
    counter := 0
    shifter := (U"1" @@ io.input.a @@ U"").resized
    div1    := (U"1" @@ io.input.b).resized
    div3    := (U"1" @@ io.input.b) +^ (((U"1" @@ io.input.b)) << 1)
    busy := io.input.valid
  }
}


object FpuDivTester extends App{
  import spinal.core.sim._

  for(w <- List(16, 20)) {
    val config = SimConfig
    config.withFstWave
    config.compile(new FpuDiv(w)).doSim(seed=2){dut =>
      dut.clockDomain.forkStimulus(10)


      val (cmdDriver, cmdQueue) = StreamDriver.queue(dut.io.input, dut.clockDomain)
      val rspQueue = mutable.Queue[FpuDivRsp => Unit]()
      StreamMonitor(dut.io.output, dut.clockDomain)( rspQueue.dequeue()(_))
      StreamReadyRandomizer(dut.io.output, dut.clockDomain)

      def test(a : Int, b : Int): Unit ={
        cmdQueue +={p =>
          p.a #= a
          p.b #= b
        }
        rspQueue += {p =>
          val x = (a | (1 << dut.mantissaWidth)).toLong
          val y = (b | (1 << dut.mantissaWidth)).toLong
          val result = (x << dut.mantissaWidth+2) / y
          val remain = (x << dut.mantissaWidth+2) % y

          assert(p.result.toLong == result, f"$x%x/$y%x=${p.result.toLong}%x instead of $result%x")
          assert(p.remain.toLong == remain, f"$x%x %% $y%x=${p.remain.toLong}%x instead of $remain%x")
        }
      }

      val s = dut.mantissaWidth-16
      val f = (1 << dut.mantissaWidth)-1
      test(0xE000 << s, 0x8000 << s)
      test(0xC000 << s, 0x4000 << s)
      test(0xC835 << s, 0x4742 << s)
      test(0,0)
      test(0,f)
      test(f,0)
      test(f,f)

      for(i <- 0 until 10000){
        test(Random.nextInt(1 << dut.mantissaWidth), Random.nextInt(1 << dut.mantissaWidth))
      }

      waitUntil(rspQueue.isEmpty)

      dut.clockDomain.waitSampling(100)

    }
  }
}

object FpuDivTester2 extends App{
  val mantissaWidth = 52
  val a = BigInt(0xfffffff810000l)
  val b = BigInt(0x0000000000FF0l)
  val x = (a | (1l << mantissaWidth))
  val y = (b | (1l << mantissaWidth))
  val result = (x << mantissaWidth+2) / y
  val remain = (x << mantissaWidth+2) % y
  println("done")

}