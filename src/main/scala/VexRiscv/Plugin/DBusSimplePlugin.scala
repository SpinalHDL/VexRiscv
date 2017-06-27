package VexRiscv.Plugin

import VexRiscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._


case class DBusSimpleCmd() extends Bundle{
  val wr = Bool
  val address = UInt(32 bits)
  val data = Bits(32 bit)
  val size = UInt(2 bit)
}

case class DBusSimpleRsp() extends Bundle with IMasterSlave{
  val ready = Bool
  val error = Bool
  val data = Bits(32 bit)

  override def asMaster(): Unit = {
    out(ready,error,data)
  }
}


object DBusSimpleBus{
  def getAxi4Config() = Axi4Config(
    addressWidth = 32,
    dataWidth = 32,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false,
    useLen = false,
    useResp = true
  )
}
case class DBusSimpleBus() extends Bundle with IMasterSlave{
  val cmd = Stream(DBusSimpleCmd())
  val rsp = DBusSimpleRsp()

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }

  def toAxi4Shared(stageCmd : Boolean = true): Axi4Shared = {
    val axi = Axi4Shared(DBusSimpleBus.getAxi4Config())
    val pendingWritesMax = 7
    val pendingWrites = CounterUpDown(
      stateCount = pendingWritesMax + 1,
      incWhen = axi.sharedCmd.fire && axi.sharedCmd.write,
      decWhen = axi.writeRsp.fire
    )

    val cmdPreFork = if (stageCmd) cmd.stage.stage().s2mPipe() else cmd
    val (cmdFork, dataFork) = StreamFork2(cmdPreFork.haltWhen((pendingWrites =/= 0 && !cmdPreFork.wr) || pendingWrites === pendingWritesMax))
    axi.sharedCmd.arbitrationFrom(cmdFork)
    axi.sharedCmd.write := cmdFork.wr
    axi.sharedCmd.prot := "010"
    axi.sharedCmd.cache := "1111"
    axi.sharedCmd.size := cmdFork.size.resized
    axi.sharedCmd.addr := cmdFork.address

    val dataStage = dataFork.throwWhen(!dataFork.wr)
    axi.writeData.arbitrationFrom(dataStage)
    axi.writeData.last := True
    axi.writeData.data := dataStage.data
    axi.writeData.strb := (dataStage.size.mux(
      U(0) -> B"0001",
      U(1) -> B"0011",
      default -> B"1111"
    ) << dataStage.address(1 downto 0)).resized


    rsp.ready := axi.r.valid
    rsp.error := !axi.r.isOKAY()
    rsp.data := axi.r.data

    axi.r.ready := True
    axi.b.ready := True


    //TODO remove
    val axi2 = Axi4Shared(DBusSimpleBus.getAxi4Config())
    axi.arw >-> axi2.arw
    axi.w >> axi2.w
    axi.r << axi2.r
    axi.b << axi2.b
//    axi2 << axi
    axi2
  }
}


class DBusSimplePlugin(catchAddressMisaligned : Boolean, catchAccessFault : Boolean) extends Plugin[VexRiscv]{

  var dBus  : DBusSimpleBus = null


  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_READ_DATA extends Stageable(Bits(32 bits))
  object MEMORY_ADDRESS_LOW extends Stageable(UInt(2 bits))
  object ALIGNEMENT_FAULT extends Stageable(Bool)

  var memoryExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])

    val stdActions = List[(Stageable[_ <: BaseType],Any)](
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> False,
      MEMORY_ENABLE     -> True,
      REG1_USE          -> True
    ) ++ (if(catchAccessFault || catchAddressMisaligned) List(IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB) else Nil) //Used for access fault bad address in memory stage

    val loadActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMI,
      REGFILE_WRITE_VALID -> True,
      BYPASSABLE_EXECUTE_STAGE -> False,
      BYPASSABLE_MEMORY_STAGE  -> False
    )

    val storeActions = stdActions ++ List(
      SRC2_CTRL -> Src2CtrlEnum.IMS,
      REG2_USE -> True
    )

    decoderService.addDefault(MEMORY_ENABLE, False)
    decoderService.add(
      List(LB, LH, LW, LBU, LHU, LWU).map(_ -> loadActions) ++
      List(SB, SH, SW).map(_ -> storeActions)
    )


    if(catchAccessFault || catchAddressMisaligned) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      memoryExceptionPort = exceptionService.newExceptionPort(pipeline.memory)
    }
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    dBus = master(DBusSimpleBus()).setName("dBus")

    //Emit dBus.cmd request
    execute plug new Area{
      import execute._

      insert(ALIGNEMENT_FAULT) := {
        if (catchAddressMisaligned)
          (dBus.cmd.size === 2 && dBus.cmd.address(1 downto 0) =/= 0) || (dBus.cmd.size === 1 && dBus.cmd.address(0 downto 0) =/= 0)
        else
          False
      }

      dBus.cmd.valid := arbitration.isValid && input(MEMORY_ENABLE) && !arbitration.isStuckByOthers && !arbitration.removeIt && !input(ALIGNEMENT_FAULT)
      dBus.cmd.wr := input(INSTRUCTION)(5)
      dBus.cmd.address := input(SRC_ADD).asUInt
      dBus.cmd.size := input(INSTRUCTION)(13 downto 12).asUInt
      dBus.cmd.payload.data := dBus.cmd.size.mux (
        U(0) -> input(REG2)(7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0),
        U(1) -> input(REG2)(15 downto 0) ## input(REG2)(15 downto 0),
        default -> input(REG2)(31 downto 0)
      )
      when(arbitration.isValid && input(MEMORY_ENABLE) && !dBus.cmd.ready && !input(ALIGNEMENT_FAULT)){
        arbitration.haltIt := True
      }

      insert(MEMORY_ADDRESS_LOW) := dBus.cmd.address(1 downto 0)
    }

    //Collect dBus.rsp read responses
    memory plug new Area {
      import memory._


      insert(MEMORY_READ_DATA) := dBus.rsp.data
      arbitration.haltIt setWhen(arbitration.isValid && input(MEMORY_ENABLE) && input(REGFILE_WRITE_VALID) && !dBus.rsp.ready)

      if(catchAccessFault || catchAddressMisaligned){
        if(!catchAccessFault){
          memoryExceptionPort.code := (input(INSTRUCTION)(5) ? U(6) | U(4)).resized
          memoryExceptionPort.valid := input(ALIGNEMENT_FAULT)
        } else if(!catchAddressMisaligned){
          memoryExceptionPort.valid := dBus.rsp.ready && dBus.rsp.error
          memoryExceptionPort.code  := 5
        } else {
          memoryExceptionPort.valid := dBus.rsp.ready && dBus.rsp.error
          memoryExceptionPort.code  := 5
          when(input(ALIGNEMENT_FAULT)){
            memoryExceptionPort.code := (input(INSTRUCTION)(5) ? U(6) | U(4)).resized
            memoryExceptionPort.valid := True
          }
        }
        when(!(arbitration.isValid && input(MEMORY_ENABLE))){
          memoryExceptionPort.valid := False
        }
        memoryExceptionPort.badAddr := input(REGFILE_WRITE_DATA).asUInt  //Drived by IntAluPlugin
      }


      assert(!(dBus.rsp.ready && input(MEMORY_ENABLE) && arbitration.isValid && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
    }

    //Reformat read responses, REGFILE_WRITE_DATA overriding
    writeBack plug new Area {
      import writeBack._


      val rspShifted = MEMORY_READ_DATA()
      rspShifted := input(MEMORY_READ_DATA)
      switch(input(MEMORY_ADDRESS_LOW)){
        is(1){rspShifted(7 downto 0) := input(MEMORY_READ_DATA)(15 downto 8)}
        is(2){rspShifted(15 downto 0) := input(MEMORY_READ_DATA)(31 downto 16)}
        is(3){rspShifted(7 downto 0) := input(MEMORY_READ_DATA)(31 downto 24)}
      }

      val rspFormated = input(INSTRUCTION)(13 downto 12).mux(
        0 -> B((31 downto 8) -> (rspShifted(7) && !input(INSTRUCTION)(14)),(7 downto 0) -> rspShifted(7 downto 0)),
        1 -> B((31 downto 16) -> (rspShifted(15) && ! input(INSTRUCTION)(14)),(15 downto 0) -> rspShifted(15 downto 0)),
        default -> rspShifted //W
      )

      when(arbitration.isValid && input(MEMORY_ENABLE)) {
        input(REGFILE_WRITE_DATA) := rspFormated
      }

      assert(!(arbitration.isValid && input(MEMORY_ENABLE) && !input(INSTRUCTION)(5) && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
    }
  }
}
