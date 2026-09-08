package vexriscv

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib.cpu.riscv.debug._

import scala.collection.mutable

/**
 * Run: sbt "testOnly vexriscv.DebugSwdDpTest"
 */
class DebugSwdDpTest extends AnyFunSuite {
  import SwdAckSim._

  val DPIDR = BigInt("0BA11AAB", 16)              // matches the SwdDp default (placeholder)
  val STICKYERR = BigInt(1) << 5
  val WDATAERR  = BigInt(1) << 7
  val PWR_REQ   = BigInt("50000000", 16)          // CDBGPWRUPREQ | CSYSPWRUPREQ
  val PWR_ALL   = BigInt("F0000000", 16)          // REQs + mirrored ACKs

  lazy val compiled = SimConfig.compile(SwdPhyDp(DPIDR))

  class Harness(val dut: SwdPhyDp) {
    val cd  = dut.clockDomain
    val drv = new SwdHostDriver(cd, dut.io.swdio.i, dut.io.swdio.o, dut.io.swdio.oe)
    val apCmds = mutable.Queue[(Boolean, Int, BigInt)]()   // (rnw, A[3:2], wdata)

    def start(): Unit = {
      dut.io.swdio.i #= false
      dut.io.ap.rsp.valid #= false
      dut.io.ap.rsp.payload.error #= false
      dut.io.ap.rsp.payload.data #= 0
      cd.assertReset()
      for (_ <- 0 until 4) { cd.fallingEdge(); sleep(2); cd.risingEdge(); sleep(2) }
      cd.deassertReset()
      sleep(2)
      fork {                                       // AP-side observer (record only)
        while (true) {
          cd.waitSampling()
          if (dut.io.ap.cmd.valid.toBoolean) {
            apCmds += ((dut.io.ap.cmd.payload.rnw.toBoolean,
                        dut.io.ap.cmd.payload.addr.toInt,
                        dut.io.ap.cmd.payload.wdata.toBigInt))
          }
        }
      }
    }

    /** Complete the outstanding AP transaction (test-controlled latency). */
    def apComplete(data: BigInt, error: Boolean = false): Unit = {
      dut.io.ap.rsp.payload.data #= data
      dut.io.ap.rsp.payload.error #= error
      dut.io.ap.rsp.valid #= true
      drv.idle(1)                                  // one SWCLK edge to deliver it
      dut.io.ap.rsp.valid #= false
    }

    def dpRead(addr: Int): (Int, Option[BigInt]) = drv.transactRead(apNdp = false, addr)
    def apRead(addr: Int): (Int, Option[BigInt]) = drv.transactRead(apNdp = true, addr)
    def dpWrite(addr: Int, data: BigInt, flipDataParity: Boolean = false): Int =
      drv.transactWrite(apNdp = false, addr, data, flipDataParity)
    def apWrite(addr: Int, data: BigInt): Int = drv.transactWrite(apNdp = true, addr, data)
  }

  def sim(name: String)(body: Harness => Unit): Unit = test(name) {
    compiled.doSim(name.replace(' ', '_')) { dut =>
      val h = new Harness(dut)
      h.start()
      h.drv.idle(4)
      body(h)
    }
  }

  sim("DPIDR read returns the configured value") { h =>
    val (ack, data) = h.dpRead(0)
    assert(ack == OK && data.contains(DPIDR))
  }

  sim("CTRL STAT power-up requests mirror ACKs") { h =>
    assert(h.dpRead(1) == ((OK, Some(BigInt(0)))))
    assert(h.dpWrite(1, PWR_REQ) == OK)
    val (ack, data) = h.dpRead(1)
    assert(ack == OK && data.contains(PWR_ALL))
  }

  sim("SELECT DPBANKSEL banks CTRL STAT") { h =>
    assert(h.dpWrite(1, PWR_REQ) == OK)
    assert(h.dpWrite(2, 1) == OK)                       // SELECT.DPBANKSEL = 1
    assert(h.dpRead(1) == ((OK, Some(BigInt(0)))))      // unimplemented bank: RAZ
    assert(h.dpWrite(2, 0) == OK)                       // back to bank 0
    val (ack, data) = h.dpRead(1)
    assert(ack == OK && data.contains(PWR_ALL))
  }

  sim("AP read is posted and RDBUFF returns the completed result") { h =>
    val (a1, d1) = h.apRead(1)
    assert(a1 == OK && d1.contains(BigInt(0)))          // stale buffer on first posted read
    h.drv.idle(1)
    val c1 = h.apCmds.dequeue()
    assert(c1._1 && c1._2 == 1, "AP read must be launched at the request")
    h.apComplete(BigInt("DEADBEEF", 16))
    val (a2, d2) = h.dpRead(3)                          // RDBUFF
    assert(a2 == OK && d2.contains(BigInt("DEADBEEF", 16)))
    val (a3, d3) = h.apRead(2)                          // posted: previous result again
    assert(a3 == OK && d3.contains(BigInt("DEADBEEF", 16)))
    h.apComplete(BigInt("11111111", 16))
    val (a4, d4) = h.dpRead(3)
    assert(a4 == OK && d4.contains(BigInt("11111111", 16)))
  }

  sim("WAIT while an AP access is outstanding but DP accesses stay OK") { h =>
    assert(h.apRead(0)._1 == OK)                        // launches; no completion yet
    assert(h.apRead(0)._1 == WAIT)
    assert(h.dpRead(3)._1 == WAIT)                      // RDBUFF is gated too
    assert(h.dpRead(1)._1 == OK)                        // CTRL/STAT poll still works
    h.apComplete(BigInt("22222222", 16))
    val (ack, data) = h.dpRead(3)
    assert(ack == OK && data.contains(BigInt("22222222", 16)))
  }

  sim("AP completion error sets STICKYERR and FAULTs until ABORT clears") { h =>
    assert(h.apRead(0)._1 == OK)
    h.apComplete(0, error = true)                       // -> STICKYERR
    assert(h.apRead(0)._1 == FAULT)
    assert(h.dpRead(3)._1 == FAULT)                     // RDBUFF FAULTs too
    val (ai, di) = h.dpRead(0)
    assert(ai == OK && di.contains(DPIDR), "DP accesses must keep working under sticky")
    val (ac, dc) = h.dpRead(1)
    assert(ac == OK && (dc.get & STICKYERR) != 0)
    assert(h.dpWrite(0, 4) == OK)                       // ABORT.STKERRCLR
    assert((h.dpRead(1)._2.get & STICKYERR) == 0)
    assert(h.apRead(0)._1 == OK)
    h.apComplete(0)
  }

  sim("write data parity error sets WDATAERR and drops the commit") { h =>
    assert(h.dpWrite(1, PWR_REQ, flipDataParity = true) == OK)   // ACK precedes WDATA
    val (ack, data) = h.dpRead(1)
    assert(ack == OK && data.contains(WDATAERR), "flag set, power bits NOT committed")
    assert(h.apRead(0)._1 == FAULT)
    assert(h.dpWrite(0, 8) == OK)                       // ABORT.WDERRCLR
    assert(h.dpRead(1) == ((OK, Some(BigInt(0)))))
    assert(h.apRead(0)._1 == OK)
    h.apComplete(0)
  }

  sim("AP write commits after the data phase and holds busy until completion") { h =>
    assert(h.apWrite(2, BigInt("CAFEBABE", 16)) == OK)
    h.drv.idle(2)
    val c = h.apCmds.dequeue()
    assert(!c._1 && c._2 == 2 && c._3 == BigInt("CAFEBABE", 16))
    assert(h.apRead(0)._1 == WAIT)                      // write still outstanding
    h.apComplete(0)                                     // write completion (no data)
    assert(h.apRead(0)._1 == OK)
    h.apComplete(BigInt("33333333", 16))
    assert(h.dpRead(3)._2.contains(BigInt("33333333", 16)))
  }

  sim("RESEND returns the same value as RDBUFF") { h =>
    assert(h.apRead(0)._1 == OK)
    h.apComplete(BigInt("A5A5A5A5", 16))
    assert(h.dpRead(2)._2.contains(BigInt("A5A5A5A5", 16)))   // RESEND
    assert(h.dpRead(3)._2.contains(BigInt("A5A5A5A5", 16)))   // RDBUFF
  }
}
