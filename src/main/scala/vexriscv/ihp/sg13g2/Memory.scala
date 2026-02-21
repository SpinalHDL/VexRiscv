package vexriscv.ihp.sg13g2

import spinal.core._

object Memory {
  def apply(width: Int, size: Int): IHPSG13Memory = (width, size) match {
    case (32, 1024) => RM_IHPSG13_2P_256x32_c2_bm_bist()
    case (22, 1024) => RM_IHPSG13_2P_64x22_c2()
    case _ => throw new IllegalArgumentException(s"Unsupported width and size: $width x $size")
  }

  abstract class IHPSG13Memory(val addrWidth: Int, val dataWidth: Int) extends BlackBox {
    val A_CLK = in(Bool())
    val A_MEN = in(Bool())
    val A_WEN = in(Bool())
    val A_REN = in(Bool())
    val A_ADDR = in(Bits(addrWidth bits))
    val A_DIN = in(Bits(dataWidth bits))
    val A_DLY = in(Bool())
    val A_DOUT = out(Bits(dataWidth bits))

    val B_CLK = in(Bool())
    val B_MEN = in(Bool())
    val B_WEN = in(Bool())
    val B_REN = in(Bool())
    val B_ADDR = in(Bits(addrWidth bits))
    val B_DIN = in(Bits(dataWidth bits))
    val B_DLY = in(Bool())
    val B_DOUT = out(Bits(dataWidth bits))

    def connectDefaults() {
      this.A_DLY := True
      this.B_DLY := True
    }


    mapCurrentClockDomain(A_CLK)
    mapCurrentClockDomain(B_CLK)
  }

  case class RM_IHPSG13_2P_256x32_c2_bm_bist()
      extends IHPSG13Memory(addrWidth = 8, dataWidth = 32) {

    val A_BM = in(Bits(dataWidth bits))
    val B_BM = in(Bits(dataWidth bits))

    val A_BIST_CLK = in(Bool())
    val A_BIST_EN = in(Bool())
    val A_BIST_MEN = in(Bool())
    val A_BIST_WEN = in(Bool())
    val A_BIST_REN = in(Bool())
    val A_BIST_ADDR = in(Bits(addrWidth bits))
    val A_BIST_DIN = in(Bits(dataWidth bits))
    val A_BIST_BM = in(Bits(dataWidth bits))

    val B_BIST_CLK = in(Bool())
    val B_BIST_EN = in(Bool())
    val B_BIST_MEN = in(Bool())
    val B_BIST_WEN = in(Bool())
    val B_BIST_REN = in(Bool())
    val B_BIST_ADDR = in(Bits(addrWidth bits))
    val B_BIST_DIN = in(Bits(dataWidth bits))
    val B_BIST_BM = in(Bits(dataWidth bits))

    override def connectDefaults() {
      this.A_DLY := True
      this.B_DLY := True

      this.A_BM := B(dataWidth bits, default -> True)
      this.B_BM := B(dataWidth bits, default -> True)

      this.A_BIST_CLK := False
      this.A_BIST_EN := False
      this.A_BIST_MEN := False
      this.A_BIST_WEN := False
      this.A_BIST_REN := False
      this.A_BIST_ADDR := 0
      this.A_BIST_DIN := 0
      this.A_BIST_BM := 0

      this.B_BIST_CLK := False
      this.B_BIST_EN := False
      this.B_BIST_MEN := False
      this.B_BIST_WEN := False
      this.B_BIST_REN := False
      this.B_BIST_ADDR := 0
      this.B_BIST_DIN := 0
      this.B_BIST_BM := 0
    }

    addRTLPath(
      System.getenv("VEXRISCV_ROOT") +
      "src/main/scala/vexriscv/ihp/sg13g2/RM_IHPSG13_2P_core_behavioral_ideal.v"
    )
    addRTLPath(
      System.getenv("VEXRISCV_ROOT") +
      "src/main/scala/vexriscv/ihp/sg13g2/RM_IHPSG13_2P_256x32_c2_bm_bist.v"
    )
  }

  case class RM_IHPSG13_2P_64x22_c2()
      extends IHPSG13Memory(addrWidth = 6, dataWidth = 22) {
    addRTLPath(
      System.getenv("VEXRISCV_ROOT") +
      "src/main/scala/vexriscv/ihp/sg13g2/RM_IHPSG13_2P_core_behavioral_bm_bist_ideal.v"
    )
    addRTLPath(
      System.getenv("VEXRISCV_ROOT") +
      "src/main/scala/vexriscv/ihp/sg13g2/RM_IHPSG13_2P_64x22_c2.v"
    )
  }
}
