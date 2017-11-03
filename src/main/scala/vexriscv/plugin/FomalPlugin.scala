package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv.VexRiscv

case class RvfiPortRsRead() extends Bundle{
  val addr = UInt(5 bits)
  val rdata = Bits(32 bits)
}

case class RvfiPortRsWrite() extends Bundle{
  val addr = UInt(5 bits)
  val wdata = Bits(32 bits)
}

case class RvfiPortPc() extends Bundle{
  val rdata = UInt(32 bits)
  val wdata = UInt(32 bits)
}


case class RvfiPortMem() extends Bundle{
  val addr  = UInt(32 bits)
  val rmask = Bits(4 bits)
  val wmask = Bits(4 bits)
  val rdata = Bits(32 bits)
  val wdata = Bits(32 bits)
}

case class RvfiPort() extends Bundle with IMasterSlave {
  val valid = Bool
  val order = UInt(64 bits)
  val insn = Bits(32 bits)
  val trap = Bool
  val halt = Bool
  val intr = Bool
  val rs1 = RvfiPortRsRead()
  val rs2 = RvfiPortRsRead()
  val rd = RvfiPortRsWrite()
  val pc = RvfiPortPc()
  val mem = RvfiPortMem()

  override def asMaster(): Unit = out(this)
}




class FomalPlugin extends Plugin[VexRiscv]{

  var rvfi : RvfiPort = null


  override def setup(pipeline: VexRiscv): Unit = {
    rvfi = master(RvfiPort()).setName("rvfi")
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import vexriscv.Riscv._

    writeBack plug new Area{
      import writeBack._

      val order = Reg(UInt(64 bits)) init(0)
      when(arbitration.isFiring){
        order := order + 1
      }

      rvfi.valid :=  arbitration.isFiring
      rvfi.order := order
      rvfi.insn := output(INSTRUCTION)
      rvfi.trap := False
      rvfi.halt := False
      rvfi.intr := False
      rvfi.rs1.addr := output(INSTRUCTION)(rs1Range).asUInt
      rvfi.rs2.addr := output(INSTRUCTION)(rs2Range).asUInt
      rvfi.rs1.rdata := output(RS1)
      rvfi.rs2.rdata := output(RS2)
      rvfi.rd.addr := output(REGFILE_WRITE_VALID) ? output(INSTRUCTION)(rdRange).asUInt | U(0)
      rvfi.rd.wdata := output(REGFILE_WRITE_DATA)
      rvfi.pc.rdata := output(PC)
      rvfi.pc.wdata := output(FORMAL_PC_NEXT)
      rvfi.mem.addr  := output(FORMAL_MEM_ADDR)
      rvfi.mem.rmask := output(FORMAL_MEM_RMASK)
      rvfi.mem.wmask := output(FORMAL_MEM_WMASK)
      rvfi.mem.rdata := output(FORMAL_MEM_RDATA)
      rvfi.mem.wdata := output(FORMAL_MEM_WDATA)
    }
  }
}
