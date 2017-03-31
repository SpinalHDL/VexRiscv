package SpinalRiscv.Plugin

import SpinalRiscv._
import spinal.core._
import spinal.lib._


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

case class DBusSimpleBus() extends Bundle with IMasterSlave{
  val cmd = Stream(DBusSimpleCmd())
  val rsp = DBusSimpleRsp()

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}

class DBusSimplePlugin(catchAddressMisaligned : Boolean, catchAccessFault : Boolean) extends Plugin[VexRiscv]{

  var dBus  : DBusSimpleBus = null

  object MemoryCtrlEnum extends SpinalEnum{
    val WR, RD = newElement()
  }

  object MEMORY_ENABLE extends Stageable(Bool)
  object MEMORY_CTRL extends Stageable(MemoryCtrlEnum())
  object MEMORY_READ_DATA extends Stageable(Bits(32 bits))
  object MEMORY_ADDRESS_LOW extends Stageable(UInt(2 bits))

  var executeExceptionPort : Flow[ExceptionCause] = null
  var memoryExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    val decoderService = pipeline.service(classOf[DecoderService])

    val stdActions = List[(Stageable[_ <: BaseType],Any)](
      LEGAL_INSTRUCTION -> True,
      SRC1_CTRL         -> Src1CtrlEnum.RS,
      SRC_USE_SUB_LESS  -> False,
      MEMORY_ENABLE     -> True,
      REG1_USE          -> True
    ) ++ (if(catchAccessFault) List(IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB) else Nil) //Used for access fault bad address in memory stage

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
    decoderService.add(List(
      LB   -> (loadActions),
      LH   -> (loadActions),
      LW   -> (loadActions),
      LBU  -> (loadActions),
      LHU  -> (loadActions),
      LWU  -> (loadActions),
      SB   -> (storeActions),
      SH   -> (storeActions),
      SW   -> (storeActions)
    ))

    if(catchAddressMisaligned) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      executeExceptionPort = exceptionService.newExceptionPort(pipeline.execute)
    }

    if(catchAccessFault) {
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

      dBus.cmd.valid := arbitration.isValid && input(MEMORY_ENABLE) && !arbitration.isStuckByOthers && !arbitration.removeIt
      dBus.cmd.wr := input(INSTRUCTION)(5)
      dBus.cmd.address := input(SRC_ADD_SUB).asUInt
      dBus.cmd.size := input(INSTRUCTION)(13 downto 12).asUInt
      dBus.cmd.payload.data := dBus.cmd.size.mux (
        U(0) -> input(REG2)(7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0),
        U(1) -> input(REG2)(15 downto 0) ## input(REG2)(15 downto 0),
        default -> input(REG2)(31 downto 0)
      )
      when(arbitration.isValid && input(MEMORY_ENABLE) && !dBus.cmd.ready){
        arbitration.haltIt := True
      }

      insert(MEMORY_ADDRESS_LOW) := dBus.cmd.address(1 downto 0)

      if(catchAddressMisaligned){
        executeExceptionPort.code := (dBus.cmd.wr ? U(6) | U(4)).resized
        executeExceptionPort.badAddr := dBus.cmd.address
        executeExceptionPort.valid := (arbitration.isValid && input(MEMORY_ENABLE)
          && ((dBus.cmd.size === 2 && dBus.cmd.address(1 downto 0) =/= 0) || (dBus.cmd.size === 1 && dBus.cmd.address(0 downto 0) =/= 0)))
      }
    }

    //Collect dBus.rsp read responses
    memory plug new Area {
      import memory._


      insert(MEMORY_READ_DATA) := dBus.rsp.data
      arbitration.haltIt setWhen(arbitration.isValid && input(MEMORY_ENABLE) && !dBus.rsp.ready)

      if(catchAccessFault){
        memoryExceptionPort.valid := arbitration.isValid && input(MEMORY_ENABLE) && dBus.rsp.ready && dBus.rsp.error
        memoryExceptionPort.code  := 5
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

      assert(!(input(MEMORY_ENABLE) && !input(INSTRUCTION)(5) && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
    }
  }
}
