package vexriscv.plugin

import spinal.lib.com.jtag.Jtag
import spinal.lib.system.debugger.{SystemDebugger, JtagBridge, SystemDebuggerConfig}
import vexriscv.plugin.IntAluPlugin.{AluCtrlEnum, ALU_CTRL}
import vexriscv._
import vexriscv.ip._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3Config, Apb3}
import spinal.lib.bus.avalon.{AvalonMMConfig, AvalonMM}


case class DebugExtensionCmd() extends Bundle{
  val wr = Bool
  val address = UInt(8 bit)
  val data = Bits(32 bit)
}
case class DebugExtensionRsp() extends Bundle{
  val data = Bits(32 bit)
}

case class DebugExtensionBus() extends Bundle with IMasterSlave{
  val cmd = Stream(DebugExtensionCmd())
  val rsp = DebugExtensionRsp() //zero cycle latency

  override def asMaster(): Unit = {
    master(cmd)
    in(rsp)
  }

  def fromApb3(): Apb3 ={
    val apb = Apb3(Apb3Config(
      addressWidth = 8,
      dataWidth = 32,
      useSlaveError = false
    ))

    cmd.valid := apb.PSEL(0) && apb.PENABLE
    cmd.wr := apb.PWRITE
    cmd.address := apb.PADDR
    cmd.data := apb.PWDATA

    apb.PREADY := cmd.ready
    apb.PRDATA := rsp.data

    apb
  }

  def fromAvalon(): AvalonMM ={
    val bus = AvalonMM(AvalonMMConfig.fixed(addressWidth = 8,dataWidth = 32, readLatency = 1))

    cmd.valid := bus.read || bus.write
    cmd.wr := bus.write
    cmd.address := bus.address
    cmd.data := bus.writeData

    bus.waitRequestn := cmd.ready
    bus.readData := rsp.data

    bus
  }

  def fromJtag(): Jtag ={
    val jtagConfig = SystemDebuggerConfig(
      memAddressWidth = 32,
      memDataWidth    = 32,
      remoteCmdWidth  = 1
    )
    val jtagBridge = new JtagBridge(jtagConfig)
    val debugger = new SystemDebugger(jtagConfig)
    debugger.io.remote <> jtagBridge.io.remote
    debugger.io.mem.cmd.valid           <> cmd.valid
    debugger.io.mem.cmd.ready           <> cmd.ready
    debugger.io.mem.cmd.wr              <> cmd.wr
    debugger.io.mem.cmd.address.resized <> cmd.address
    debugger.io.mem.cmd.data            <> cmd.data
    debugger.io.mem.rsp.valid           <> RegNext(cmd.fire).init(False)
    debugger.io.mem.rsp.payload         <> rsp.data

    jtagBridge.io.jtag
  }
}

case class DebugExtensionIo() extends Bundle with IMasterSlave{
  val bus = DebugExtensionBus()
  val resetOut = Bool

  override def asMaster(): Unit = {
    master(bus)
    in(resetOut)
  }
}

class DebugPlugin(val debugClockDomain : ClockDomain) extends Plugin[VexRiscv] {

  var io : DebugExtensionIo = null


  object IS_EBREAK extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    io = slave(DebugExtensionIo()).setName("debug")

    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(IS_EBREAK, False)
    decoderService.add(EBREAK,List(
      IS_EBREAK -> True,
      SRC_USE_SUB_LESS -> False,
      SRC1_CTRL -> Src1CtrlEnum.RS, // Zero
      SRC2_CTRL -> Src2CtrlEnum.PC,
      ALU_CTRL  -> AluCtrlEnum.ADD_SUB //Used to get the PC value in busReadDataReg
    ))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    debugClockDomain {pipeline plug new Area{
      val insertDecodeInstruction = False
      val firstCycle = RegNext(False) setWhen (io.bus.cmd.ready)
      val secondCycle = RegNext(firstCycle)
      val resetIt = RegInit(False)
      val haltIt = RegInit(False)
      val stepIt = RegInit(False)

      val isPipActive = RegNext(List(fetch, decode, execute, memory, writeBack).map(_.arbitration.isValid).orR)
      val isPipBusy = isPipActive || RegNext(isPipActive)
      val haltedByBreak = RegInit(False)


      val busReadDataReg = Reg(Bits(32 bit))
      when(writeBack.arbitration.isValid) {
        busReadDataReg := writeBack.output(REGFILE_WRITE_DATA)
      }
      io.bus.cmd.ready := True
      io.bus.rsp.data := busReadDataReg
      when(!RegNext(io.bus.cmd.address(2))){
        io.bus.rsp.data(0) := resetIt
        io.bus.rsp.data(1) := haltIt
        io.bus.rsp.data(2) := isPipBusy
        io.bus.rsp.data(3) := haltedByBreak
        io.bus.rsp.data(4) := stepIt
      }

      when(io.bus.cmd.valid) {
        switch(io.bus.cmd.address(2 downto 2)) {
          is(0) {
            when(io.bus.cmd.wr) {
              stepIt := io.bus.cmd.data(4)
              resetIt setWhen (io.bus.cmd.data(16)) clearWhen (io.bus.cmd.data(24))
              haltIt setWhen (io.bus.cmd.data(17)) clearWhen (io.bus.cmd.data(25))
              haltedByBreak clearWhen (io.bus.cmd.data(25))
            }
          }
          is(1) {
            when(io.bus.cmd.wr) {
              insertDecodeInstruction := True
              decode.arbitration.isValid setWhen (firstCycle)
              decode.arbitration.haltItself setWhen (secondCycle)
              io.bus.cmd.ready := !(firstCycle || secondCycle || decode.arbitration.isValid)
            }
          }
        }
      }

      //Assign the bus write data into the register who drive the decode instruction, even if it need to cross some hierarchy (caches)
      Component.current.addPrePopTask(() => {
        val reg = decode.input(INSTRUCTION).getDrivingReg
        reg.component.rework {
          when(insertDecodeInstruction.pull()) {
            reg := io.bus.cmd.data.pull()
          }
        }
      })


      when(execute.arbitration.isFiring && execute.input(IS_EBREAK)) {
        prefetch.arbitration.haltByOther := True
        decode.arbitration.flushAll := True
        haltIt := True
        haltedByBreak := True
      }

      when(haltIt) {
        prefetch.arbitration.haltByOther := True
      }

      when(stepIt && prefetch.arbitration.isFiring) {
        haltIt := True
      }

      io.resetOut := RegNext(resetIt)

      if(serviceExist(classOf[InterruptionInhibitor])) {
        when(haltIt || stepIt) {
          service(classOf[InterruptionInhibitor]).inhibateInterrupts()
        }
      }
    }}
  }
}
