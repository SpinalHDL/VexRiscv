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


//Tool stuff
//https://www.reddit.com/r/yosys/comments/77g5hn/unsupported_cell_type_error_adff/
//rd_addr == 0  => no rd_wdata check
//instruction that doesn't use RSx have to force the formal port address to zero

//feature added
//Halt CPU on decoding exception

//VexRiscv changes
//

//VexRiscv bug
//1) pcManagerService.createJumpInterface(pipeline.execute)
//   pcManagerService.createJumpInterface(if(earlyBranch) pipeline.execute else pipeline.memory)
//2) JALR => clear PC(0)
//3) input(INSTRUCTION)(5)  REGFILE_WRITE_VALID  memory read with exception would not fire properly

class FormalPlugin extends Plugin[VexRiscv]{

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
      rvfi.insn := output(FORMAL_INSTRUCTION)
      rvfi.trap := False
      rvfi.halt := False
      rvfi.intr := False
//      rvfi.rs1.addr  := output(INSTRUCTION)(rs1Range).asUInt
//      rvfi.rs2.addr  := output(INSTRUCTION)(rs2Range).asUInt
//      rvfi.rs1.rdata := output(RS1)
//      rvfi.rs2.rdata := output(RS2)
      rvfi.rs1.addr := output(RS1_USE) ? output(INSTRUCTION)(rs1Range).asUInt | U(0)
      rvfi.rs2.addr := output(RS2_USE) ? output(INSTRUCTION)(rs2Range).asUInt | U(0)
      rvfi.rs1.rdata := output(RS1_USE) ? output(RS1) | B(0)
      rvfi.rs2.rdata := output(RS2_USE) ? output(RS2) | B(0)
      rvfi.rd.addr := output(REGFILE_WRITE_VALID) ? (output(INSTRUCTION)(rdRange).asUInt) | U(0)
      rvfi.rd.wdata := output(REGFILE_WRITE_VALID) ? output(REGFILE_WRITE_DATA) | B(0)
      rvfi.pc.rdata := output(PC)
      rvfi.pc.wdata := output(FORMAL_PC_NEXT)
      rvfi.mem.addr  := output(FORMAL_MEM_ADDR)
      rvfi.mem.rmask := output(FORMAL_MEM_RMASK)
      rvfi.mem.wmask := output(FORMAL_MEM_WMASK)
      rvfi.mem.rdata := output(FORMAL_MEM_RDATA)
      rvfi.mem.wdata := output(FORMAL_MEM_WDATA)

      val haltRequest = False
      stages.map(s => {
        when(s.arbitration.isValid && s.output(FORMAL_HALT)){ //Stage is exception halted
          when(stages.drop(indexOf(s) + 1).map(!_.arbitration.isValid).foldLeft(True)(_ && _)){ //There nothing in futher stages
            haltRequest := True
          }
        }
      })

      when(Delay(haltRequest, 5, init=False)){ //Give time for value propagation from decode stage to writeback stage
        rvfi.valid := True
        rvfi.trap := True
        rvfi.halt := True
      }

      val haltFired = RegInit(False) setWhen(rvfi.valid && rvfi.halt)
      rvfi.valid clearWhen(haltFired)
    }
  }
}
