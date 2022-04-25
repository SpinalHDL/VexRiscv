package vexriscv.periph.gcd

import spinal.core._
import spinal.sim._
import spinal.core.sim._

//import scala.util.Random
import java.util.concurrent.ThreadLocalRandom
object GCDTopSim {
  def main(args: Array[String]) { 

    SimConfig.withWave.doSim(new GCDTop()){dut =>
    // SimConfig.doSim(new GCDTop()){dut =>
      def gcd(a: Long,b: Long): Long = {
        if(b==0) a else gcd(b, a%b)
      }
      def RndNextUInt32(): Long = {
        ThreadLocalRandom.current().nextLong(Math.pow(2, 32).toLong - 1)
      }
      var a = 0L
      var b = 0L
      var model = 0L
      dut.io.a #= 0
      dut.io.b #= 0
      dut.io.valid #= false

      dut.clockDomain.forkStimulus(period = 10)
      dut.clockDomain.waitRisingEdge()

      for(idx <- 0 to 500){
        // generate 2 random ints
        a = RndNextUInt32()
        b = RndNextUInt32()
        // calculate the model value (software)
        model = gcd(a,b)
        // apply stimulus with random ints
        dut.io.a #= a
        dut.io.b #= b
        dut.io.valid #= true
        dut.clockDomain.waitRisingEdge()
        dut.io.valid #= false
        // wait until calculation of hardware is done
        waitUntil(dut.io.ready.toBoolean)
        assert(
          assertion = (dut.io.res.toBigInt == model),
          message = "test " + idx + " failed. Expected " + model + ", retrieved: " + dut.io.res.toBigInt
        )
        waitUntil(!dut.io.ready.toBoolean)
      }
    }
  }
}
