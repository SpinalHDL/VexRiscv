package vexriscv.plugin

import spinal.core._
import spinal.core.internals.{BoolLiteral, Literal}
import spinal.lib._
import spinal.lib.fsm._
import vexriscv._
import vexriscv.Riscv._
import vexriscv.ip.fpu._

import scala.collection.mutable.ArrayBuffer

class FpuAcessPort(val p : FpuParameter) extends Bundle{
  val start = Bool()
  val regId = UInt(5 bits)
  val size  = UInt(3 bits)
  val write = Bool()
  val writeData = p.storeLoadType()
  val readData  = Bits(32 bits)
  val readDataValid = Bool()
  val readDataChunk = UInt(1 bits)
  val done = Bool()
}

class FpuPlugin(externalFpu : Boolean = false,
                var simHalt : Boolean = false,
                val p : FpuParameter) extends Plugin[VexRiscv] with VexRiscvRegressionArg {

  object FPU_ENABLE extends Stageable(Bool())
  object FPU_COMMIT extends Stageable(Bool())
  object FPU_COMMIT_SYNC extends Stageable(Bool())
  object FPU_COMMIT_LOAD extends Stageable(Bool())
  object FPU_RSP extends Stageable(Bool())
  object FPU_FORKED extends Stageable(Bool())
  object FPU_OPCODE extends Stageable(FpuOpcode())
  object FPU_ARG extends Stageable(Bits(2 bits))
  object FPU_FORMAT extends Stageable(FpuFormat())

  var port : FpuPort = null //Commit port is already isolated
  var access : FpuAcessPort = null //Meant to be used for debuging features only

  def requireAccessPort(): Unit = {
    access = new FpuAcessPort(p).setName("fpuAccess")
  }

  override def getVexRiscvRegressionArgs(): Seq[String] = {
    var args = List[String]()
    args :+= "RVF=yes"
    if(p.withDouble) args :+= "RVD=yes"
    args
  }

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
    val fcvtxx  = floatRfWrite :+ FPU_OPCODE -> FpuOpcode.FCVT_X_X

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


    def arg(v : Int) = FPU_ARG -> B(v, 2 bits)
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(FPU_ENABLE, False)

    val f32 = FPU_FORMAT -> FpuFormat.FLOAT
    val f64 = FPU_FORMAT -> FpuFormat.DOUBLE

    decoderService.add(List(
      FADD_S    -> (addSub  :+ f32 :+ arg(0)),
      FSUB_S    -> (addSub  :+ f32 :+ arg(1)),
      FMADD_S   -> (fma     :+ f32 :+ arg(0)),
      FMSUB_S   -> (fma     :+ f32 :+ arg(2)),
      FNMADD_S  -> (fma     :+ f32 :+ arg(3)),
      FNMSUB_S  -> (fma     :+ f32 :+ arg(1)),
      FMUL_S    -> (mul     :+ f32 :+ arg(0)),
      FDIV_S    -> (div     :+ f32 ),
      FSQRT_S   -> (sqrt    :+ f32 ),
      FLW       -> (fl      :+ f32 ),
      FSW       -> (fs      :+ f32 ),
      FCVT_S_WU -> (fcvtI2f :+ f32 :+ arg(0)),
      FCVT_S_W  -> (fcvtI2f :+ f32 :+ arg(1)),
      FCVT_WU_S -> (fcvtF2i :+ f32 :+ arg(0)),
      FCVT_W_S ->  (fcvtF2i :+ f32 :+ arg(1)),
      FCLASS_S  -> (fclass  :+ f32 ),
      FLE_S     -> (fcmp    :+ f32 :+ arg(0)),
      FEQ_S     -> (fcmp    :+ f32 :+ arg(2)),
      FLT_S     -> (fcmp    :+ f32 :+ arg(1)),
      FSGNJ_S   -> (fsgnj   :+ f32 :+ arg(0)),
      FSGNJN_S  -> (fsgnj   :+ f32 :+ arg(1)),
      FSGNJX_S  -> (fsgnj   :+ f32 :+ arg(2)),
      FMIN_S    -> (fminMax :+ f32 :+ arg(0)),
      FMAX_S    -> (fminMax :+ f32 :+ arg(1)),
      FMV_X_W   -> (fmvXw   :+ f32 ),
      FMV_W_X   -> (fmvWx   :+ f32 )
    ))

    if(p.withDouble){
      decoderService.add(List(
        FADD_D    -> (addSub  :+ f64 :+ arg(0)),
        FSUB_D    -> (addSub  :+ f64 :+ arg(1)),
        FMADD_D   -> (fma     :+ f64 :+ arg(0)),
        FMSUB_D   -> (fma     :+ f64 :+ arg(2)),
        FNMADD_D  -> (fma     :+ f64 :+ arg(3)),
        FNMSUB_D  -> (fma     :+ f64 :+ arg(1)),
        FMUL_D    -> (mul     :+ f64 :+ arg(0)),
        FDIV_D    -> (div     :+ f64 ),
        FSQRT_D   -> (sqrt    :+ f64 ),
        FLD       -> (fl      :+ f64 ),
        FSD       -> (fs      :+ f64 ),
        FCVT_D_WU -> (fcvtI2f :+ f64 :+ arg(0)),
        FCVT_D_W  -> (fcvtI2f :+ f64 :+ arg(1)),
        FCVT_WU_D -> (fcvtF2i :+ f64 :+ arg(0)),
        FCVT_W_D  -> (fcvtF2i :+ f64 :+ arg(1)),
        FCLASS_D  -> (fclass  :+ f64 ),
        FLE_D     -> (fcmp    :+ f64 :+ arg(0)),
        FEQ_D     -> (fcmp    :+ f64 :+ arg(2)),
        FLT_D     -> (fcmp    :+ f64 :+ arg(1)),
        FSGNJ_D   -> (fsgnj   :+ f64 :+ arg(0)),
        FSGNJN_D  -> (fsgnj   :+ f64 :+ arg(1)),
        FSGNJX_D  -> (fsgnj   :+ f64 :+ arg(2)),
        FMIN_D    -> (fminMax :+ f64 :+ arg(0)),
        FMAX_D    -> (fminMax :+ f64 :+ arg(1)),
        FCVT_D_S  -> (fcvtxx :+ f32),
        FCVT_S_D  -> (fcvtxx :+ f64)
      ))
    }
    //TODO FMV_X_X + doubles

    port = FpuPort(p).addTag(Verilator.public)
    if(externalFpu) master(port)

    val dBusEncoding =  pipeline.service(classOf[DBusEncodingService])
    dBusEncoding.addLoadWordEncoding(FLW)
    dBusEncoding.addStoreWordEncoding(FSW)
    if(p.withDouble) {
      dBusEncoding.addLoadWordEncoding(FLD)
      dBusEncoding.addStoreWordEncoding(FSD)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._

    val internal = (!externalFpu).generate (pipeline plug new Area{
      val fpu = FpuCore(1, p)
      if(simHalt) {
        val cmdHalt = in(Bool).setName("fpuCmdHalt").addAttribute(Verilator.public)
        val commitHalt = in(Bool).setName("fpuCommitHalt").addAttribute(Verilator.public)
        val rspHalt = in(Bool).setName("fpuRspHalt").addAttribute(Verilator.public)
        fpu.io.port(0).cmd << port.cmd.haltWhen(cmdHalt)
        fpu.io.port(0).commit << port.commit.haltWhen(commitHalt)
        fpu.io.port(0).rsp.haltWhen(rspHalt) >> port.rsp
        fpu.io.port(0).completion <> port.completion
      } else {
        fpu.io.port(0).cmd << port.cmd
        fpu.io.port(0).commit << port.commit
        fpu.io.port(0).rsp >> port.rsp
        fpu.io.port(0).completion <> port.completion
      }
    })

    val csrService = pipeline.service(classOf[CsrInterface])
    val csr = pipeline plug new Area{
      val pendings = Reg(UInt(6 bits)) init(0)
      pendings := pendings + U(port.cmd.fire) - U(port.completion.fire) - U(port.rsp.fire)

      val hasPending = pendings =/= 0

      val flags = Reg(FpuFlags())
      flags.NV init(False) setWhen(port.completion.fire && port.completion.flags.NV)
      flags.DZ init(False) setWhen(port.completion.fire && port.completion.flags.DZ)
      flags.OF init(False) setWhen(port.completion.fire && port.completion.flags.OF)
      flags.UF init(False) setWhen(port.completion.fire && port.completion.flags.UF)
      flags.NX init(False) setWhen(port.completion.fire && port.completion.flags.NX)

      val rm = Reg(Bits(3 bits)) init(0)

      csrService.rw(CSR.FCSR,   5, rm)
      csrService.rw(CSR.FCSR,   0, flags)
      csrService.rw(CSR.FRM,    0, rm)
      csrService.rw(CSR.FFLAGS, 0, flags)

      val csrActive = csrService.duringAny()
      execute.arbitration.haltByOther setWhen(csrActive && hasPending) // pessimistic

      val fs = Reg(Bits(2 bits)) init(1)
      val sd = fs === 3

      when(port.completion.fire && (port.completion.written || port.completion.flags.any)){
        fs := 3
      }
      when(List(CSR.FRM, CSR.FCSR, CSR.FFLAGS).map(id => csrService.isWriting(id)).orR){
        fs := 3
      }

      csrService.rw(CSR.SSTATUS, 13, fs)
      csrService.rw(CSR.MSTATUS, 13, fs)

      csrService.r(CSR.SSTATUS, 31, sd)
      csrService.r(CSR.MSTATUS, 31, sd)

      val accessFpuCsr = False
      for (csr <- List(CSR.FRM, CSR.FCSR, CSR.FFLAGS)) {
        csrService.during(csr) {
          accessFpuCsr := True
        }
      }
      when(accessFpuCsr && fs === 0 && !csrService.inDebugMode()) {
        csrService.forceFailCsr()
      }
    }

    val inAccess = False
    decode plug new Area{
      import decode._

      val trap = insert(FPU_ENABLE) && csr.fs === 0 && !csrService.inDebugMode() && !stagesFromExecute.map(_.arbitration.isValid).orR
      when(trap){
        pipeline.service(classOf[DecoderService]).forceIllegal()
      }

      //Maybe it might be better to not fork before fire to avoid RF stall on commits
      val forked = Reg(Bool) setWhen(port.cmd.fire && !inAccess) clearWhen(!arbitration.isStuck) init(False)

      val hazard = csr.pendings.msb || csr.csrActive || csr.fs === 0 && !csrService.inDebugMode()

      input(FPU_ENABLE).clearWhen(!input(LEGAL_INSTRUCTION))
      arbitration.haltItself setWhen(arbitration.isValid && input(FPU_ENABLE) && hazard)
      arbitration.haltItself setWhen(port.cmd.isStall)

      val iRoundMode = input(INSTRUCTION)(funct3Range)
      val roundMode = (input(INSTRUCTION)(funct3Range) === B"111") ? csr.rm | input(INSTRUCTION)(funct3Range)

      port.cmd.valid     := arbitration.isValid && input(FPU_ENABLE) && !forked && !hazard
      port.cmd.opcode    := input(FPU_OPCODE)
      port.cmd.arg       := input(FPU_ARG)
      port.cmd.rs1       := input(INSTRUCTION)(rs1Range).asUInt
      port.cmd.rs2       := input(INSTRUCTION)(rs2Range).asUInt
      port.cmd.rs3       := input(INSTRUCTION)(rs3Range).asUInt
      port.cmd.rd        := input(INSTRUCTION)(rdRange).asUInt
      port.cmd.format    := (if(p.withDouble) input(FPU_FORMAT) else FpuFormat.FLOAT())
      port.cmd.roundMode := roundMode.as(FpuRoundMode())

      insert(FPU_FORKED) := forked || port.cmd.fire &&  !inAccess

      insert(FPU_COMMIT_SYNC) := List(FpuOpcode.LOAD, FpuOpcode.FMV_W_X, FpuOpcode.I2F).map(_ === input(FPU_OPCODE)).orR
      insert(FPU_COMMIT_LOAD) := input(FPU_OPCODE) === FpuOpcode.LOAD

      if(serviceExist(classOf[IWake])) when(forked){
        service(classOf[IWake]).askWake() //Ensure that no WFI followed by a FPU stall the FPU interface for other CPU
      }
    }

    writeBack plug new Area{ //WARNING IF STAGE CHANGE, update the regression rsp capture filter for the golden model (top->VexRiscv->lastStageIsFiring)
      import writeBack._

      val dBusEncoding =  pipeline.service(classOf[DBusEncodingService])
      val isRsp = input(FPU_FORKED) && input(FPU_RSP)
      val isCommit = input(FPU_FORKED) && input(FPU_COMMIT)
      val storeFormated = CombInit(port.rsp.value)
      if(p.withDouble) when(!input(INSTRUCTION)(12)){
        storeFormated(32, 32 bits) := port.rsp.value(0, 32 bits)
      }
      //Manage $store and port.rsp
      port.rsp.ready := False
      when(isRsp){
        when(arbitration.isValid) {
          dBusEncoding.bypassStore(storeFormated)
          output(REGFILE_WRITE_DATA) := port.rsp.value(31 downto 0)
          when(!arbitration.isStuck && !arbitration.isRemoved){
            csr.flags.NV setWhen(port.rsp.NV)
            csr.flags.NX setWhen(port.rsp.NX)
            when(port.rsp.NV || port.rsp.NX){
              csr.fs := 3
            }
          }
        }
        when(!port.rsp.valid){
          arbitration.haltByOther := True
        } elsewhen(!arbitration.haltItself){
          port.rsp.ready := True
        }
      }

      // Manage $load
      val commit = Stream(FpuCommit(p)).addTag(Verilator.public)
      commit.valid := isCommit && !arbitration.isStuck
      commit.value(31 downto 0) := (input(FPU_COMMIT_LOAD) ? dBusEncoding.loadData()(31 downto 0)  | input(RS1))
      if(p.withDouble) commit.value(63 downto 32) :=  dBusEncoding.loadData()(63 downto 32)
      commit.write := arbitration.isValid && !arbitration.removeIt
      commit.opcode := input(FPU_OPCODE)
      commit.rd := input(INSTRUCTION)(rdRange).asUInt

      when(isCommit && !commit.ready){
        arbitration.haltByOther := True
      }

      port.commit << commit.pipelined(s2m = true, m2s = false)
    }

    if(access != null) pipeline plug new StateMachine{
      val IDLE, CMD, RSP, RSP_0, RSP_1, COMMIT, DONE = State()
      setEntry(IDLE)

      inAccess setWhen(!this.isActive(IDLE))
      IDLE.whenIsActive{
        when(access.start){
          goto(CMD)
        }
      }

      CMD.whenIsActive{
        port.cmd.valid := True
        port.cmd.rs2 := access.regId
        port.cmd.rd := access.regId
        port.cmd.format := access.size.muxListDc(List(
          2 -> FpuFormat.FLOAT(),
          3 -> FpuFormat.DOUBLE()
        ))
        when(access.write) {
          port.cmd.opcode := FpuOpcode.LOAD
          when(port.cmd.ready){
            goto(COMMIT)
          }
        } otherwise {
          port.cmd.opcode := FpuOpcode.STORE
          when(port.cmd.ready){
            goto(RSP)
          }
        }
      }

      access.done := False
      COMMIT.whenIsActive{
        port.commit.valid := True
        port.commit.opcode := FpuOpcode.LOAD
        port.commit.rd     := access.regId
        port.commit.write  := True
        port.commit.value  := access.writeData
        when(port.commit.ready){
          goto(DONE)
        }
      }

      access.readDataValid := False
      access.readDataChunk.assignDontCare()
      access.readData.assignDontCare()
      RSP.whenIsActive {
        when(port.rsp.valid) {
          goto(RSP_0)
        }
      }
      RSP_0.whenIsActive {
        access.readDataValid := True
        access.readDataChunk := 0
        access.readData := port.rsp.value(31 downto 0)
        when(access.size > 2) {
          goto(RSP_1)
        } otherwise {
          goto(DONE)
        }
      }
      RSP_1.whenIsActive {
        access.readDataValid := True
        access.readDataChunk := 1
        access.readData := port.rsp.value(63 downto 32)
        goto(DONE)
      }
      DONE whenIsActive{
        port.rsp.ready := True
        access.done := True
        goto(IDLE)
      }
    }

    pipeline.stages.dropRight(1).foreach(s => s.output(FPU_FORKED) clearWhen(s.arbitration.isStuck))

    Component.current.afterElaboration{
      pipeline.stages.tail.foreach(_.input(FPU_FORKED).init(False))
    }
  }
}
