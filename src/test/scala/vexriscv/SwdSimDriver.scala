package vexriscv

import spinal.core.{Bool, ClockDomain}
import spinal.core.sim._

/** ACK codes as read LSB-first off the wire (= the ADI register values). */
object SwdAckSim {
  val OK    = 1
  val WAIT  = 2
  val FAULT = 4
}

/**
 *
 * The bench owns SWCLK (the DUT clock) and reproduces OpenOCD's bitbang model: the host
 * sets SWDIO while SWCLK is low and samples target data while low; the target acts on
 * rising edges. All values are sent/collected LSB first. Protocol assertions (turnaround
 * positions, no-drive during requests, read parity, WAIT/FAULT data-phase skip) are
 * embedded in the transaction helpers.
 */
class SwdHostDriver(cd: ClockDomain, swdioI: Bool, swdioO: Bool, swdioOe: Bool) {
  import SwdAckSim._

  /** One SWCLK cycle. Host drives `bit`; returns (targetData, targetOe) as the host
    * would sample them during the low phase (i.e. what the target registered on the
    * previous rising edge). */
  def step(bit: Boolean): (Boolean, Boolean) = {
    cd.fallingEdge(); sleep(1)
    swdioI #= bit
    sleep(1)
    val oe = swdioOe.toBoolean
    val o  = swdioO.toBoolean
    cd.risingEdge(); sleep(2)
    (o, oe)
  }

  def idle(n: Int): Unit = for (_ <- 0 until n) step(false)
  def ones(n: Int): Unit = for (_ <- 0 until n) step(true)
  def lineReset(): Unit = { ones(52); idle(2) }

  /** 8-bit packet request, LSB first. The target must not drive during it. */
  def header(apNdp: Boolean, rnw: Boolean, addr: Int,
             flipParity: Boolean = false, badStop: Boolean = false, badPark: Boolean = false): Unit = {
    val a2 = (addr & 1) != 0
    val a3 = (addr & 2) != 0
    val par = (apNdp ^ rnw ^ a2 ^ a3) ^ flipParity
    val bits = Seq(true, apNdp, rnw, a2, a3, par, badStop, !badPark)
    for (b <- bits) {
      val (_, oe) = step(b)
      assert(!oe, "target must not drive during the packet request")
    }
  }

  def readTargetBit(): (Boolean, Boolean) = step(false)

  def readAck(): (Int, Boolean) = {
    var v = 0
    var oeAll = true
    for (i <- 0 until 3) {
      val (b, oe) = readTargetBit()
      if (b) v |= 1 << i
      oeAll &= oe
    }
    (v, oeAll)
  }

  def transactRead(apNdp: Boolean, addr: Int): (Int, Option[BigInt]) = {
    header(apNdp, rnw = true, addr)
    step(false)                                   // turnaround host -> target
    val (ack, ackOe) = readAck()
    assert(ackOe, "target must drive all 3 ACK bits")
    if (ack == OK) {
      var data = BigInt(0)
      var oeAll = true
      for (i <- 0 until 32) {
        val (b, oe) = readTargetBit()
        if (b) data |= BigInt(1) << i
        oeAll &= oe
      }
      val (pBit, pOe) = readTargetBit()
      oeAll &= pOe
      assert(oeAll, "target must drive all 33 data-phase bits")
      val parityCalc = (0 until 32).map(i => ((data >> i) & 1) != 0).reduce(_ ^ _)
      assert(parityCalc == pBit, "read data parity mismatch")
      val (_, trnOe) = step(false)                // turnaround target -> host
      assert(!trnOe, "target must release the line after the read data phase")
      (ack, Some(data))
    } else {
      val (_, oeAfter) = step(false)
      assert(!oeAfter, s"data phase must be skipped on WAIT/FAULT (ack=$ack)")
      (ack, None)
    }
  }

  def transactWrite(apNdp: Boolean, addr: Int, data: BigInt,
                    flipDataParity: Boolean = false): Int = {
    header(apNdp, rnw = false, addr)
    step(false)                                   // turnaround host -> target
    val (ack, ackOe) = readAck()
    assert(ackOe, "target must drive all 3 ACK bits")
    if (ack == OK) {
      val (_, trnOe) = step(false)                // turnaround target -> host
      assert(!trnOe, "target must release the line before WDATA")
      var par = false
      for (i <- 0 until 32) {
        val b = ((data >> i) & 1) != 0
        par ^= b
        step(b)
      }
      step(par ^ flipDataParity)
    } else {
      val (_, oeAfter) = step(false)
      assert(!oeAfter, s"data phase must be skipped on WAIT/FAULT (ack=$ack)")
    }
    ack
  }
}
