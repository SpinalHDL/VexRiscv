package vexriscv.plugin

import spinal.lib.com.jtag.Jtag
import spinal.lib.system.debugger.{JtagBridge, SystemDebugger, SystemDebuggerConfig}
import vexriscv.plugin.IntAluPlugin.{ALU_CTRL, AluCtrlEnum}
import vexriscv._
import vexriscv.ip._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config}
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}

import scala.collection.mutable.ArrayBuffer


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
  val rsp = DebugExtensionRsp() //one cycle latency

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
    cmd.address := debugger.io.mem.cmd.address.resized
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



class DebugPlugin(val debugClockDomain : ClockDomain, hardwareBreakpointCount : Int = 0) extends Plugin[VexRiscv] {

  var io : DebugExtensionIo = null
  val injectionAsks = ArrayBuffer[(Stage, Bool)]()
  var injectionPort : Stream[Bits] = null


  object IS_EBREAK extends Stageable(Bool)
  object DO_EBREAK extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._

    io = slave(DebugExtensionIo()).setName("debug")

    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(IS_EBREAK, False)
    decoderService.add(EBREAK,List(IS_EBREAK -> True))

    injectionPort = pipeline.service(classOf[IBusFetcher]).getInjectionPort()

    if(pipeline.serviceExist(classOf[ReportService])){
      val report = pipeline.service(classOf[ReportService])
      report.add("debug" -> {
        val e = new DebugReport()
        e.hardwareBreakpointCount = hardwareBreakpointCount
        e
      })
    }
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val logic = debugClockDomain {pipeline plug new Area{
      val iBusFetcher = service(classOf[IBusFetcher])
      val firstCycle = RegNext(False) setWhen (io.bus.cmd.ready)
      val secondCycle = RegNext(firstCycle)
      val resetIt = RegInit(False)
      val haltIt = RegInit(False)
      val stepIt = RegInit(False)

      val isPipBusy = RegNext(stages.map(_.arbitration.isValid).orR || iBusFetcher.incoming())
      val godmode = RegInit(False) setWhen(haltIt && !isPipBusy)
      val haltedByBreak = RegInit(False)

      val hardwareBreakpoints = Vec(Reg(new Bundle{
        val valid = Bool()
        val pc = UInt(31 bits)
      }), hardwareBreakpointCount)
      hardwareBreakpoints.foreach(_.valid init(False))

      val busReadDataReg = Reg(Bits(32 bit))
      when(stages.last.arbitration.isValid) {
        busReadDataReg := stages.last.output(REGFILE_WRITE_DATA)
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

      injectionPort.valid := False
      injectionPort.payload := io.bus.cmd.data

      when(io.bus.cmd.valid) {
        switch(io.bus.cmd.address(7 downto 2)) {
          is(0x0) {
            when(io.bus.cmd.wr) {
              stepIt := io.bus.cmd.data(4)
              resetIt setWhen (io.bus.cmd.data(16)) clearWhen (io.bus.cmd.data(24))
              haltIt setWhen (io.bus.cmd.data(17)) clearWhen (io.bus.cmd.data(25))
              haltedByBreak clearWhen (io.bus.cmd.data(25))
              godmode clearWhen(io.bus.cmd.data(25))
            }
          }
          is(0x1) {
            when(io.bus.cmd.wr) {
              injectionPort.valid := True
              io.bus.cmd.ready := injectionPort.ready
            }
          }
          for(i <- 0 until hardwareBreakpointCount){
            is(0x10 + i){
              when(io.bus.cmd.wr){
                hardwareBreakpoints(i).assignFromBits(io.bus.cmd.data)
              }
            }
          }
        }
      }

      val allowEBreak = if(!pipeline.serviceExist(classOf[PrivilegeService])) True else pipeline.service(classOf[PrivilegeService]).isMachine()

      decode.insert(DO_EBREAK) := !haltIt && (decode.input(IS_EBREAK) || hardwareBreakpoints.map(hb => hb.valid && hb.pc === (decode.input(PC) >> 1)).foldLeft(False)(_ || _)) && allowEBreak
      when(execute.arbitration.isValid && execute.input(DO_EBREAK)){
        execute.arbitration.haltByOther := True
        busReadDataReg := execute.input(PC).asBits
        when(stagesFromExecute.tail.map(_.arbitration.isValid).orR === False){
          iBusFetcher.haltIt()
          execute.arbitration.flushIt   := True
          execute.arbitration.flushNext := True
          haltIt := True
          haltedByBreak := True
        }
      }

      when(haltIt) {
        iBusFetcher.haltIt()
      }

      when(stepIt && iBusFetcher.incoming()) {
        iBusFetcher.haltIt()
        when(decode.arbitration.isValid) {
          haltIt := True
        }
      }

      //Avoid having two C instruction executed in a single step
      if(pipeline(RVC_GEN)){
        val cleanStep = RegNext(stepIt && decode.arbitration.isFiring) init(False)
        execute.arbitration.flushNext setWhen(cleanStep)
      }

      io.resetOut := RegNext(resetIt)

      if(serviceExist(classOf[InterruptionInhibitor])) {
        when(haltIt || stepIt) {
          service(classOf[InterruptionInhibitor]).inhibateInterrupts()
        }
      }

      when(godmode) {
        pipeline.plugins.foreach{
          case p : ExceptionInhibitor => p.inhibateException()
          case _ =>
        }
        pipeline.plugins.foreach{
          case p : PrivilegeService => p.forceMachine()
          case _ =>
        }
        if(pipeline.things.contains(DEBUG_BYPASS_CACHE)) pipeline(DEBUG_BYPASS_CACHE) := True
      }

      val wakeService = serviceElse(classOf[IWake], null)
      if(wakeService != null) when(haltIt){
        wakeService.askWake()
      }
    }}
  }
}
