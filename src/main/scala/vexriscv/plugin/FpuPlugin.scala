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
  object FPU_COMMIT_SYNC extends Stageable(Bool())
  object FPU_COMMIT_LOAD extends Stageable(Bool())
  object FPU_RSP extends Stageable(Bool())
  object FPU_FORKED extends Stageable(Bool())
  object FPU_OPCODE extends Stageable(FpuOpcode())
  object FPU_ARG extends Stageable(Bits(2 bits))

  var port : FpuPort = null

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    type ENC = (Stageable[_ <: BaseType],Any)

    val intRfWrite = List[ENC](
      FPU_ENABLE -> True,
      FPU_COMMIT -> False,
      FPU_RSP -> True,
      REGFILE_WRITE_VALID -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> False
    )

    val floatRfWrite = List[ENC](
      FPU_ENABLE -> True,
      FPU_COMMIT -> True,
      FPU_RSP -> False
    )

    val addSub  = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.ADD
    val mul     = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.MUL
    val fma     = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.FMA
    val div     = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.DIV
    val sqrt    = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.SQRT
    val fsgnj   = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.SGNJ
    val fminMax = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.MIN_MAX
    val fmvWx   = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.FMV_W_X :+ RS1_USE -> True
    val fcvtI2f = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.I2F     :+ RS1_USE -> True

    val fcmp    = intRfWrite   :+ FPU_OPCODE -> FpuOpcode.CMP
    val fclass  = intRfWrite   :+ FPU_OPCODE -> FpuOpcode.FCLASS
    val fmvXw   = intRfWrite   :+ FPU_OPCODE -> FpuOpcode.FMV_X_W
    val fcvtF2i = intRfWrite   :+ FPU_OPCODE -> FpuOpcode.F2I

    val fl = List[ENC](
      FPU_ENABLE -> True,
      FPU_OPCODE -> FpuOpcode.LOAD,
      FPU_COMMIT -> True,
      FPU_RSP -> False
    )

    val fs = List[ENC](
      FPU_ENABLE -> True,
      FPU_OPCODE -> FpuOpcode.STORE,
      FPU_COMMIT -> False,
      FPU_RSP -> True
    )


    def arg(v : Int) = FPU_ARG -> U(v, 2 bits)
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FPU_ENABLE, False)
    decoderService.add(List(
      FADD_S    -> (addSub :+ arg(0)),
      FSUB_S    -> (addSub :+ arg(1)),
      FMADD_S   -> (fma :+ arg(0)),
      FMSUB_S   -> (fma :+ arg(2)),
      FNMADD_S  -> (fma :+ arg(1)),
      FNMSUB_S  -> (fma :+ arg(3)),
      FMUL_S    -> (mul :+ arg(0)),
      FDIV_S    -> (div),
      FSQRT_S   -> (sqrt),
      FLW       -> (fl),
      FSW       -> (fs),
      FCVT_S_WU -> (fcvtI2f :+ arg(0)),
      FCVT_S_W  -> (fcvtI2f :+ arg(1)),
      FCVT_WU_S -> (fcvtF2i :+ arg(0)),
      FCVT_W_S ->  (fcvtF2i :+ arg(1)),
      FCLASS_S  -> (fclass),
      FLE_S     -> (fcmp :+ arg(0)),
      FEQ_S     -> (fcmp :+ arg(2)),
      FLT_S     -> (fcmp :+ arg(1)),
      FSGNJ_S   -> (fsgnj :+ arg(0)),
      FSGNJN_S  -> (fsgnj :+ arg(1)),
      FSGNJX_S  -> (fsgnj :+ arg(2)),
      FMIN_S    -> (fminMax :+ arg(0)),
      FMAX_S    -> (fminMax :+ arg(1)),
      FMV_X_W   -> (fmvXw),
      FMV_W_X   -> (fmvWx)
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
    import Riscv._

    val internal = !externalFpu generate pipeline plug new Area{
      val fpu = FpuCore(1, p)
      fpu.io.port(0).cmd << port.cmd
      fpu.io.port(0).commit << port.commit
      fpu.io.port(0).rsp >> port.rsp
      fpu.io.port(0).completion <> port.completion
    }


    val csr = pipeline plug new Area{
      val pendings = Reg(UInt(5 bits)) init(0)
      pendings := pendings + U(port.cmd.fire) - port.completion.count

      val hasPending = pendings =/= 0

      val flags = Reg(FpuFlags())
      flags.NV init(False) setWhen(port.completion.flag.NV)
      flags.DZ init(False) setWhen(port.completion.flag.DZ)
      flags.OF init(False) setWhen(port.completion.flag.OF)
      flags.UF init(False) setWhen(port.completion.flag.UF)
      flags.NX init(False) setWhen(port.completion.flag.NX)

      val service = pipeline.service(classOf[CsrInterface])
      val rm = Reg(Bits(3 bits))

      service.rw(CSR.FCSR,   5, rm)
      service.rw(CSR.FCSR,   0, flags)
      service.rw(CSR.FRM,    5, rm)
      service.rw(CSR.FFLAGS, 0, flags)

      val csrActive = service.duringAny()
      execute.arbitration.haltByOther setWhen(csrActive && hasPending) // pessimistic

      val fs = Reg(Bits(2 bits)) init(1)
      when(hasPending){
        fs := 3 //DIRTY
      }
      service.rw(CSR.SSTATUS, 13, fs)
    }

    decode plug new Area{
      import decode._

      //Maybe it might be better to not fork before fire to avoid RF stall on commits
      val forked = Reg(Bool) setWhen(port.cmd.fire) clearWhen(!arbitration.isStuck) init(False)

      val hazard = csr.pendings.msb || csr.csrActive

      arbitration.haltItself setWhen(arbitration.isValid && input(FPU_ENABLE) && hazard)
      arbitration.haltItself setWhen(port.cmd.isStall)

      val iRoundMode = input(INSTRUCTION)(funct3Range)
      val roundMode = (input(INSTRUCTION)(funct3Range) === B"111") ? csr.rm | input(INSTRUCTION)(funct3Range)

      port.cmd.valid     := arbitration.isValid && input(FPU_ENABLE) && !forked && !hazard
      port.cmd.opcode    := input(FPU_OPCODE)
      port.cmd.arg       := input(FPU_ARG)
      port.cmd.rs1       := ((input(FPU_OPCODE) === FpuOpcode.STORE) ? input(INSTRUCTION)(rs2Range).asUInt | input(INSTRUCTION)(rs1Range).asUInt)
      port.cmd.rs2       := input(INSTRUCTION)(rs2Range).asUInt
      port.cmd.rs3       := input(INSTRUCTION)(rs3Range).asUInt
      port.cmd.rd        := input(INSTRUCTION)(rdRange).asUInt
      port.cmd.format    := FpuFormat.FLOAT
      port.cmd.roundMode := roundMode.as(FpuRoundMode())

      insert(FPU_FORKED) := forked || port.cmd.fire

      insert(FPU_COMMIT_SYNC) := List(FpuOpcode.LOAD, FpuOpcode.FMV_W_X, FpuOpcode.I2F).map(_ === input(FPU_OPCODE)).orR
      insert(FPU_COMMIT_LOAD) := input(FPU_OPCODE) === FpuOpcode.LOAD
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
      commit.value := (input(FPU_COMMIT_LOAD) ? output(DBUS_DATA) | input(RS1))
      commit.write := arbitration.isValid
      commit.sync := input(FPU_COMMIT_SYNC)

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
