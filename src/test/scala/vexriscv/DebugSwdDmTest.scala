package vexriscv

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib.cpu.riscv.debug._

/**
 * Two truly asynchronous clocks: the bench bit-bangs SWCLK through SwdHostDriver while
 * the debug domain free-runs via forkStimulus. DMI completions therefore take a variable
 * number of SWCLK cycles — the helpers retry on WAIT exactly like a host would.
 *
 * Run: sbt "testOnly vexriscv.DebugSwdDmTest"
 */

case class SwdDmTestTop(dpidr : BigInt, apIdr : BigInt) extends Component {
  val p = DebugTransportModuleParameter(addressWidth = 7, version = 1, idle = 7)

  val io = new Bundle {
    val swclk = in Bool()
    val swdio = new Bundle {
      val i  = in  Bool()
      val o  = out Bool()
      val oe = out Bool()
    }
  }

  val dm = DebugModule(DebugModuleParameter(
    version     = p.version + 1,
    harts       = 1,
    progBufSize = 2,
    datacount   = 1,
    hartsConfig = List(DebugModuleCpuConfig(xlen = 32, flen = 0, withFpuRegAccess = false))
  ))

  // Stubbed hart: never halted, always running, never resets (step 2 needs no CPU).
  val hart = dm.io.harts(0)
  hart.halted      := False
  hart.running     := True
  hart.unavailable := False
  hart.haveReset   := False
  hart.exception   := False
  hart.commit      := False
  hart.ebreak      := False
  hart.redo        := False
  hart.regSuccess  := False
  hart.hartToDm.setIdle()
  hart.resume.rsp.setIdle()

  val transport = DebugTransportModuleSwd(
    p = p, debugCd = ClockDomain.current, dpidr = dpidr, apIdr = apIdr)
  transport.io.swd.swclk   := io.swclk
  transport.io.swd.swdio.i := io.swdio.i
  io.swdio.o  := transport.io.swd.swdio.o
  io.swdio.oe := transport.io.swd.swdio.oe

  dm.io.ctrl <> transport.io.bus
}

class DebugSwdDmTest extends AnyFunSuite {
  import SwdAckSim._

  val DPIDR  = BigInt("0BA11AAB", 16)
  val AP_IDR = BigInt("74726976", 16)

  lazy val compiled = SimConfig.compile(SwdDmTestTop(DPIDR, AP_IDR))

  class Harness(val dut: SwdDmTestTop) {
    val swdCd = ClockDomain(dut.io.swclk)
    val drv = new SwdHostDriver(swdCd, dut.io.swdio.i, dut.io.swdio.o, dut.io.swdio.oe)

    def start(): Unit = {
      dut.io.swclk #= false
      dut.io.swdio.i #= false
      dut.clockDomain.forkStimulus(period = 10)   // free-running async debug domain
      dut.clockDomain.waitSampling(10)            // let its reset deassert
    }

    def dpRead(addr: Int): (Int, Option[BigInt]) = drv.transactRead(apNdp = false, addr)

    /** On an unexpected ACK, report CTRL/STAT so the guilty sticky flag is visible. */
    def ackCheck(ack: Int, what: String): Unit = {
      if (ack != WAIT) {
        val (a, d) = dpRead(1)
        val cs = if (a == OK) s"CTRL/STAT=0x${d.get.toString(16)}" else s"CTRL/STAT unreadable ack=$a"
        throw new AssertionError(s"unexpected ack=$ack on $what ($cs)")
      }
    }

    /** Poll RDBUFF until the outstanding DMI access completes; returns the result. */
    def rdbuff(max: Int = 100): BigInt = {
      var tries = 0
      while (tries < max) {
        val (ack, data) = dpRead(3)
        if (ack == OK) return data.get
        ackCheck(ack, "RDBUFF poll")
        tries += 1
        drv.idle(2)
      }
      throw new AssertionError("RDBUFF never completed")
    }

    /** AP write with host-style WAIT retry (the previous access may still be in flight). */
    def apWriteRetry(addr: Int, data: BigInt, max: Int = 100): Unit = {
      var tries = 0
      while (tries < max) {
        val ack = drv.transactWrite(apNdp = true, addr, data)
        if (ack == OK) return
        ackCheck(ack, s"AP write @$addr")
        tries += 1
        drv.idle(2)
      }
      throw new AssertionError("AP write never accepted")
    }

    /** AP read launch with WAIT retry (posted data returned by OK reads is stale). */
    def apReadRetry(addr: Int, max: Int = 100): Unit = {
      var tries = 0
      while (tries < max) {
        val (ack, _) = drv.transactRead(apNdp = true, addr)
        if (ack == OK) return
        ackCheck(ack, s"AP read @$addr")
        tries += 1
        drv.idle(2)
      }
      throw new AssertionError("AP read never accepted")
    }

    def dmiRead(dmiAddr: Int): BigInt = {
      apWriteRetry(1, dmiAddr)                    // DMI_ADDR
      apReadRetry(2)                              // launch DMI_DATA read (posted)
      rdbuff()                                    // collect the completed result
    }

    def dmiWrite(dmiAddr: Int, data: BigInt): Unit = {
      apWriteRetry(1, dmiAddr)
      apWriteRetry(2, data)                       // completion covered by later retries
    }
  }

  def sim(name: String, seed: Int = -1)(body: Harness => Unit): Unit = test(name) {
    def run(dut: SwdDmTestTop): Unit = {
      val h = new Harness(dut)
      h.start()
      h.drv.idle(4)                               // BOOT state RESET_WAIT -> IDLE
      body(h)
    }
    if (seed >= 0) compiled.doSim(name.replace(' ', '_'), seed)(run)
    else compiled.doSim(name.replace(' ', '_'))(run)
  }

  sim("DPIDR reads through the assembled transport") { h =>
    val (ack, data) = h.dpRead(0)
    assert(ack == OK && data.contains(DPIDR))
  }

  sim("AP IDR via posted read") { h =>
    h.apReadRetry(0)
    assert(h.rdbuff() == AP_IDR)
  }

  sim("DMI_ADDR write and readback") { h =>
    h.apWriteRetry(1, 0x11)
    h.apReadRetry(1)
    assert(h.rdbuff() == 0x11)
  }

  sim("dmstatus read over SWD - step 2 exit criterion") { h =>
    val dmstatus = h.dmiRead(0x11)
    assert((dmstatus & 0xF) == 2, s"dmstatus.version, got 0x${dmstatus.toString(16)}")
    assert(((dmstatus >> 7) & 1) == 1, "dmstatus.authenticated must be set")
  }

  sim("dmcontrol dmactive write and readback over SWD") { h =>
    assert((h.dmiRead(0x10) & 1) == 0, "dmactive must reset low")
    h.dmiWrite(0x10, 1)
    assert((h.dmiRead(0x10) & 1) == 1, "dmactive must read back set")
  }

  sim("abstractauto write and readback over SWD") { h =>
    // Note: data0/progbuf cannot round-trip with a stubbed hart — DM writes forward to
    // the hart and reads return the hart-written Mem (needs a CPU; later integration).
    // abstractauto is a plain read/write DM register: WARL bits [0] and [17:16] here.
    h.dmiWrite(0x10, 1)                           // dmactive
    h.dmiWrite(0x18, BigInt("00030001", 16))
    assert(h.dmiRead(0x18) == BigInt("00030001", 16))
    h.dmiWrite(0x18, 0)
    assert(h.dmiRead(0x18) == 0)
  }

  sim("POSTED_READ returns the last DMI read result") { h =>
    val dmstatus = h.dmiRead(0x11)
    h.apReadRetry(3)
    assert(h.rdbuff() == dmstatus)
  }
}
