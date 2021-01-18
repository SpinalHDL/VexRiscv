package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._
import vexriscv.ip.fpu._

class FpuPlugin(externalFpu : Boolean = false,
                p : FpuParameter) extends Plugin[VexRiscv]{

  object FPU_ENABLE extends Stageable(Bool())
  object FPU_COMMIT extends Stageable(Bool())
  object FPU_LOAD extends Stageable(Bool())
  object FPU_RSP extends Stageable(Bool())
  object FPU_ALU extends Stageable(Bool())
  object FPU_FORKED extends Stageable(Bool())
  object FPU_OPCODE extends Stageable(FpuOpcode())

  var port : FpuPort = null

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FPU_ENABLE, False)
    decoderService.add(List(
      FADD_S    -> List(FPU_ENABLE -> True, FPU_OPCODE -> FpuOpcode.ADD,   FPU_COMMIT -> True,  FPU_ALU -> True , FPU_LOAD -> False,  FPU_RSP -> False),
      FLW       -> List(FPU_ENABLE -> True, FPU_OPCODE -> FpuOpcode.LOAD,  FPU_COMMIT -> True,  FPU_ALU -> False, FPU_LOAD -> True ,  FPU_RSP -> False),
      FSW       -> List(FPU_ENABLE -> True, FPU_OPCODE -> FpuOpcode.STORE, FPU_COMMIT -> False, FPU_ALU -> False, FPU_LOAD -> False,  FPU_RSP -> True),
      FCVT_WU_S -> List(FPU_ENABLE -> True, FPU_OPCODE -> FpuOpcode.F2I  , FPU_COMMIT -> False, FPU_ALU -> False, FPU_LOAD -> False,  FPU_RSP -> True,  REGFILE_WRITE_VALID -> True, BYPASSABLE_EXECUTE_STAGE -> False, BYPASSABLE_MEMORY_STAGE  -> False),
      FLE_S     -> List(FPU_ENABLE -> True, FPU_OPCODE -> FpuOpcode.CMP  , FPU_COMMIT -> False, FPU_ALU -> False, FPU_LOAD -> False,  FPU_RSP -> True,  REGFILE_WRITE_VALID -> True, BYPASSABLE_EXECUTE_STAGE -> False, BYPASSABLE_MEMORY_STAGE  -> False)
    ))

    port = FpuPort(p)
    if(externalFpu) master(port)

    val dBusEncoding =  pipeline.service(classOf[DBusEncodingService])
    dBusEncoding.addLoadWordEncoding(FLW)
    dBusEncoding.addStoreWordEncoding(FSW)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val internal = !externalFpu generate pipeline plug new Area{
      val fpu = FpuCore(1, p)
      fpu.io.port(0).cmd << port.cmd
      fpu.io.port(0).commit << port.commit
      fpu.io.port(0).rsp >> port.rsp
    }


    decode plug new Area{
      import decode._

      //Maybe it might be better to not fork before fire to avoid RF stall on commits
      val forked = Reg(Bool) setWhen(port.cmd.fire) clearWhen(!arbitration.isStuck) init(False)

      arbitration.haltItself setWhen(port.cmd.isStall)
      port.cmd.valid := arbitration.isValid && input(FPU_ENABLE) && !forked
      port.cmd.opcode   := input(FPU_OPCODE)
      port.cmd.value    := output(RS1)
      port.cmd.function := 0
      port.cmd.rs1      := input(INSTRUCTION)(rs1Range).asUInt
      port.cmd.rs2      := input(INSTRUCTION)(rs2Range).asUInt
      port.cmd.rs3      := input(INSTRUCTION)(rs3Range).asUInt
      port.cmd.rd       := input(INSTRUCTION)(rdRange).asUInt
      port.cmd.format   := FpuFormat.FLOAT

      insert(FPU_FORKED) := forked || port.cmd.fire
    }

    writeBack plug new Area{
      import writeBack._

      val dBusEncoding =  pipeline.service(classOf[DBusEncodingService])
      val isRsp = input(FPU_FORKED) && input(FPU_RSP)
      val isCommit = input(FPU_FORKED) && input(FPU_COMMIT)

      //Manage $store and port.rsp
      port.rsp.ready := False
      when(isRsp){
        port.rsp.ready := True
        when(arbitration.isValid) {
          dBusEncoding.bypassStore(port.rsp.value)
          output(REGFILE_WRITE_DATA) := port.rsp.value
        }
        when(!port.rsp.valid){
          arbitration.haltByOther := True
        }
      }

      // Manage $load
      val commit = Stream(FpuCommit(p))
      commit.valid := isCommit && arbitration.isMoving
      commit.value.assignFromBits(output(DBUS_DATA))
      commit.write := arbitration.isValid
      commit.load := input(FPU_LOAD)

      when(arbitration.isValid && !commit.ready){
        arbitration.haltByOther := True
      }

      port.commit <-/< commit
    }

    Component.current.afterElaboration{
      pipeline.stages.tail.foreach(_.input(FPU_FORKED).init(False))
    }
  }
}
