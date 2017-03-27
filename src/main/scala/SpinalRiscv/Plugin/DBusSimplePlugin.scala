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

case class DBusSimpleRsp() extends Bundle{
  val ready = Bool
  val error = Bool
  val data = Bits(32 bit)
}

class DBusSimplePlugin(catchUnalignedException : Boolean, catchAccessFault : Boolean) extends Plugin[VexRiscv]{

  var dCmd  : Stream[DBusSimpleCmd] = null
  var dRsp  : DBusSimpleRsp = null

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
      REG1_USE          -> True,
      IntAluPlugin.ALU_CTRL -> IntAluPlugin.AluCtrlEnum.ADD_SUB //Used for assess fault bad address in memory stage
    )

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

    if(catchUnalignedException) {
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

    //Emit dCmd request
    execute plug new Area{
      import execute._

      dCmd = master(Stream(DBusSimpleCmd())).setName("dCmd")
      dCmd.valid := arbitration.isValid && input(MEMORY_ENABLE) && !arbitration.isStuckByOthers && !arbitration.removeIt
      dCmd.wr := input(INSTRUCTION)(5)
      dCmd.address := input(SRC_ADD_SUB).asUInt
      dCmd.size := input(INSTRUCTION)(13 downto 12).asUInt
      dCmd.payload.data := dCmd.size.mux (
        U(0) -> input(REG2)(7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0) ## input(REG2)(7 downto 0),
        U(1) -> input(REG2)(15 downto 0) ## input(REG2)(15 downto 0),
        default -> input(REG2)(31 downto 0)
      )
      when(arbitration.isValid && input(MEMORY_ENABLE) && !dCmd.ready){
        arbitration.haltIt := True
      }

      insert(MEMORY_ADDRESS_LOW) := dCmd.address(1 downto 0)

      if(catchUnalignedException){
        executeExceptionPort.code := (dCmd.wr ? U(6) | U(4)).resized
        executeExceptionPort.badAddr := dCmd.address
        executeExceptionPort.valid := (arbitration.isValid && input(MEMORY_ENABLE)
          && ((dCmd.size === 2 && dCmd.address(1 downto 0) =/= 0) || (dCmd.size === 1 && dCmd.address(0 downto 0) =/= 0)))
      }
    }

    //Collect dRsp read responses
    memory plug new Area {
      import memory._

      dRsp = in(DBusSimpleRsp()).setName("dRsp")
      insert(MEMORY_READ_DATA) := dRsp.data
      arbitration.haltIt setWhen(arbitration.isValid && input(MEMORY_ENABLE) && !dRsp.ready)

      if(catchAccessFault){
        memoryExceptionPort.valid := arbitration.isValid && input(MEMORY_ENABLE) && dRsp.ready && dRsp.error
        memoryExceptionPort.code  := 5
        memoryExceptionPort.badAddr := input(REGFILE_WRITE_DATA).asUInt  //Drived by IntAluPlugin
      }

      assert(!(dRsp.ready && input(MEMORY_ENABLE) && arbitration.isValid && arbitration.isStuck),"DBusSimplePlugin doesn't allow memory stage stall when read happend")
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
