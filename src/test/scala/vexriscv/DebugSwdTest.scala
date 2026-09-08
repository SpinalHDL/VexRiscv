package vexriscv

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib.cpu.riscv.debug._

import scala.collection.mutable

/**
 * Run: sbt "testOnly vexriscv.DebugSwdTest"
 */
class DebugSwdTest extends AnyFunSuite {
  val ACK_OK    = SwdAckSim.OK
  val ACK_WAIT  = SwdAckSim.WAIT
  val ACK_FAULT = SwdAckSim.FAULT

  lazy val compiled = SimConfig.compile(SwdPhy())

  class Harness(val dut: SwdPhy) {
    val cd  = dut.clockDomain
    val drv = new SwdHostDriver(cd, dut.io.swdio.i, dut.io.swdio.o, dut.io.swdio.oe)

    // Stub DP programming + observation
    var stubAck   = ACK_OK
    var stubRdata = BigInt(0)
    val cmds = mutable.Queue[(Boolean, Boolean, Int)]()   // (apNdp, rnw, A[3:2])
    val wrs  = mutable.Queue[(BigInt, Boolean)]()         // (data, parityOk)

    def start(): Unit = {
      dut.io.swdio.i #= false
      dut.io.dp.rsp.valid #= false
      dut.io.dp.rsp.payload.ack #= 0
      dut.io.dp.rsp.payload.rdata #= 0
      cd.assertReset()
      for (_ <- 0 until 4) { cd.fallingEdge(); sleep(2); cd.risingEdge(); sleep(2) }
      cd.deassertReset()
      sleep(2)
      // Always-ready DP model: the ADI contract requires the DP to answer within the
      // turnaround cycle, so the stub holds its programmed response valid continuously
      // (reacting to cmd from a sim thread is one clock too late by design).
      fork {
        while (true) {
          cd.waitSampling()
          dut.io.dp.rsp.valid #= true
          dut.io.dp.rsp.payload.ack #= stubAck
          dut.io.dp.rsp.payload.rdata #= stubRdata
          if (dut.io.dp.cmd.valid.toBoolean) {
            cmds += ((dut.io.dp.cmd.payload.apNdp.toBoolean,
                      dut.io.dp.cmd.payload.rnw.toBoolean,
                      dut.io.dp.cmd.payload.addr.toInt))
          }
          if (dut.io.dp.wr.valid.toBoolean) {
            wrs += ((dut.io.dp.wr.payload.data.toBigInt,
                     dut.io.dp.wr.payload.parityOk.toBoolean))
          }
        }
      }
    }

    // Delegates so the test bodies read at protocol level
    def step(bit: Boolean): (Boolean, Boolean) = drv.step(bit)
    def idle(n: Int): Unit = drv.idle(n)
    def ones(n: Int): Unit = drv.ones(n)
    def lineReset(): Unit = drv.lineReset()
    def header(apNdp: Boolean, rnw: Boolean, addr: Int,
               flipParity: Boolean = false, badStop: Boolean = false, badPark: Boolean = false): Unit =
      drv.header(apNdp, rnw, addr, flipParity, badStop, badPark)
    def transactRead(apNdp: Boolean, addr: Int): (Int, Option[BigInt]) = drv.transactRead(apNdp, addr)
    def transactWrite(apNdp: Boolean, addr: Int, data: BigInt, flipDataParity: Boolean = false): Int =
      drv.transactWrite(apNdp, addr, data, flipDataParity)
  }

  def sim(name: String)(body: Harness => Unit): Unit = test(name) {
    compiled.doSim(name.replace(' ', '_')) { dut =>
      val h = new Harness(dut)
      h.start()
      h.idle(4)
      body(h)
    }
  }

  sim("write reaches stub bit-exact") { h =>
    val ack = h.transactWrite(apNdp = false, addr = 2, data = BigInt("CAFE1234", 16))
    assert(ack == ACK_OK)
    h.idle(2)
    assert(h.cmds.dequeue() == ((false, false, 2)))
    val (d, pOk) = h.wrs.dequeue()
    assert(d == BigInt("CAFE1234", 16) && pOk)
  }

  sim("read returns stub data bit-exact with parity") { h =>
    h.stubRdata = BigInt("12345678", 16)
    val (ack, data) = h.transactRead(apNdp = true, addr = 1)
    assert(ack == ACK_OK)
    assert(data.contains(BigInt("12345678", 16)))
    assert(h.cmds.dequeue() == ((true, true, 1)))
  }

  sim("DPIDR smoke read") { h =>
    h.stubRdata = BigInt("0BC12477", 16)            // stub stands in for the 2B DPIDR
    val (ack, data) = h.transactRead(apNdp = false, addr = 0)
    assert(ack == ACK_OK)
    assert(data.contains(BigInt("0BC12477", 16)))
    assert(h.cmds.dequeue() == ((false, true, 0)))
  }

  sim("header parity error silences target until line reset") { h =>
    h.header(apNdp = false, rnw = true, addr = 0, flipParity = true)
    for (_ <- 0 until 10) { val (_, oe) = h.step(false); assert(!oe) }
    h.header(apNdp = false, rnw = true, addr = 0)   // good header, but still in error
    for (_ <- 0 until 10) { val (_, oe) = h.step(false); assert(!oe) }
    assert(h.cmds.isEmpty, "no request may reach the DP while in protocol error")
    h.lineReset()
    h.stubRdata = BigInt("55AA55AA", 16)
    val (ack, data) = h.transactRead(apNdp = false, addr = 0)
    assert(ack == ACK_OK && data.contains(BigInt("55AA55AA", 16)))
  }

  sim("stop bit error silences target until line reset") { h =>
    h.header(apNdp = false, rnw = false, addr = 3, badStop = true)
    for (_ <- 0 until 10) { val (_, oe) = h.step(false); assert(!oe) }
    assert(h.cmds.isEmpty)
    h.lineReset()
    assert(h.transactWrite(apNdp = false, addr = 3, data = 7) == ACK_OK)
  }

  sim("WAIT and FAULT skip the data phase") { h =>
    h.stubAck = ACK_WAIT
    val (a1, d1) = h.transactRead(apNdp = true, addr = 3)
    assert(a1 == ACK_WAIT && d1.isEmpty)
    assert(h.transactWrite(apNdp = true, addr = 3, data = 1) == ACK_WAIT)
    h.stubAck = ACK_FAULT
    val (a2, d2) = h.transactRead(apNdp = true, addr = 3)
    assert(a2 == ACK_FAULT && d2.isEmpty)
    h.stubAck = ACK_OK
    h.stubRdata = 42
    val (a3, d3) = h.transactRead(apNdp = true, addr = 3)
    assert(a3 == ACK_OK && d3.contains(BigInt(42)))
    h.idle(2)
    assert(h.cmds.size == 4 && h.wrs.isEmpty)
  }

  sim("back-to-back transactions without idle cycles") { h =>
    h.stubRdata = BigInt("A5A5A5A5", 16)
    assert(h.transactWrite(apNdp = false, addr = 1, data = BigInt("DEADBEEF", 16)) == ACK_OK)
    val (ack, data) = h.transactRead(apNdp = false, addr = 1)   // header starts immediately
    assert(ack == ACK_OK && data.contains(BigInt("A5A5A5A5", 16)))
    h.idle(2)
    assert(h.wrs.dequeue()._1 == BigInt("DEADBEEF", 16))
  }

  sim("write data parity error is flagged and recoverable") { h =>
    assert(h.transactWrite(apNdp = false, addr = 0, data = BigInt("00FF00FF", 16),
                           flipDataParity = true) == ACK_OK)
    h.idle(2)
    val (d, pOk) = h.wrs.dequeue()
    assert(d == BigInt("00FF00FF", 16) && !pOk, "commit must carry parityOk=false")
    h.stubRdata = 3
    val (ack, data) = h.transactRead(apNdp = false, addr = 0)   // no line reset needed
    assert(ack == ACK_OK && data.contains(BigInt(3)))
  }

  sim("49 high cycles are not a line reset, 50 are") { h =>
    h.header(apNdp = false, rnw = true, addr = 0, flipParity = true)   // enter error
    h.idle(2)                       // break the run of 1s ending in the park bit
    h.ones(49); h.idle(2)
    h.header(apNdp = false, rnw = true, addr = 0)
    for (_ <- 0 until 10) { val (_, oe) = h.step(false); assert(!oe) }
    assert(h.cmds.isEmpty, "49 high cycles must not reset the line state")
    h.ones(50); h.idle(2)
    h.stubRdata = 9
    val (ack, data) = h.transactRead(apNdp = false, addr = 0)
    assert(ack == ACK_OK && data.contains(BigInt(9)))
  }
}
