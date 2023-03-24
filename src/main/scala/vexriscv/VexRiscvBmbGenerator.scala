package vexriscv

import spinal.core._
import spinal.lib.bus.bmb.{Bmb, BmbAccessCapabilities, BmbAccessParameter, BmbImplicitDebugDecoder, BmbInterconnectGenerator, BmbInvalidationParameter, BmbParameter}
import spinal.lib.bus.misc.AddressMapping
import spinal.lib.com.jtag.{Jtag, JtagTapInstructionCtrl}
import spinal.lib.generator._
import spinal.lib.{sexport, slave}
import vexriscv.plugin._
import spinal.core.fiber._
import spinal.lib.cpu.riscv.debug.DebugHartBus

object VexRiscvBmbGenerator{
  val DEBUG_NONE = 0
  val DEBUG_JTAG = 1
  val DEBUG_JTAG_CTRL = 2
  val DEBUG_BUS = 3
  val DEBUG_BMB = 4
}

case class VexRiscvBmbGenerator()(implicit interconnectSmp: BmbInterconnectGenerator = null) extends Area {
  import VexRiscvBmbGenerator._

  val config = Handle[VexRiscvConfig]
  val withDebug = Handle[Int]
  val withRiscvDebug = Handle[Boolean]
  val debugClockDomain = Handle[ClockDomain]
  val debugReset = Handle[Bool]
  val debugAskReset = Handle[() => Unit]
  val hardwareBreakpointCount = Handle.sync(0)

  val iBus, dBus = Handle[Bmb]

  val externalInterrupt = Handle[Bool]
  val externalSupervisorInterrupt = Handle[Bool]
  val timerInterrupt = Handle[Bool]
  val softwareInterrupt = Handle[Bool]

  def setTimerInterrupt(that: Handle[Bool]) =    Dependable(that, timerInterrupt){timerInterrupt := that}
  def setSoftwareInterrupt(that: Handle[Bool]) = Dependable(that, softwareInterrupt){softwareInterrupt := that}


  def disableDebug() = {
    withDebug.load(DEBUG_NONE)
    withRiscvDebug.load(false)
  }

  def enableJtag(debugCd : ClockDomainResetGeneratorIf, resetCd : ClockDomainResetGeneratorIf) : Unit = debugCd.rework{
    this.debugClockDomain.load(debugCd.outputClockDomain)
    val resetBridge = resetCd.relaxedReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_JTAG)
    if(!withRiscvDebug.isLoaded) withRiscvDebug.load(false)
  }

  def enableJtagInstructionCtrl(debugCd : ClockDomainResetGeneratorIf, resetCd : ClockDomainResetGeneratorIf) : Unit = debugCd.rework{
    this.debugClockDomain.load(debugCd.outputClockDomain)
    val resetBridge = resetCd.relaxedReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_JTAG_CTRL)
    if(!withRiscvDebug.isLoaded) withRiscvDebug.load(false)
  }

  def enableDebugBus(debugCd : ClockDomainResetGeneratorIf, resetCd : ClockDomainResetGeneratorIf) : Unit = debugCd.rework{
    this.debugClockDomain.load(debugCd.outputClockDomain)
    val resetBridge = resetCd.relaxedReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_BUS)
    if(!withRiscvDebug.isLoaded) withRiscvDebug.load(false)
  }

  def enableRiscvDebug(debugCd :  Handle[ClockDomain], resetCd : ClockDomainResetGeneratorIf) : Unit = debugCd.on{
    this.debugClockDomain.load(debugCd)
    debugAskReset.loadNothing()
    withRiscvDebug.load(true)
    if(!withDebug.isLoaded) withDebug.load(DEBUG_NONE)
  }

//  def enableRiscvAndBusDebugPlus(debugCd :  Handle[ClockDomain], resetCd : ClockDomainResetGenerator) : Unit = debugCd.on{
//    this.debugClockDomain.load(debugCd)
//    val resetBridge = resetCd.asyncReset(debugReset, ResetSensitivity.HIGH)
//    debugAskReset.loadNothing()
//    withRiscvDebug.load(true)
//  }

  val debugBmbAccessSource = Handle[BmbAccessCapabilities]
  val debugBmbAccessRequirements = Handle[BmbAccessParameter]
  def enableDebugBmb(debugCd : Handle[ClockDomain], resetCd : ClockDomainResetGeneratorIf, mapping : AddressMapping)(implicit debugMaster : BmbImplicitDebugDecoder = null) : Unit = debugCd.on{
    this.debugClockDomain.load(debugCd)
    val resetBridge = resetCd.relaxedReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_BMB)
    if(!withRiscvDebug.isLoaded) withRiscvDebug.load(false)
    val slaveModel = debugCd on interconnectSmp.addSlave(
      accessSource = debugBmbAccessSource,
      accessCapabilities = debugBmbAccessSource.derivate(DebugExtensionBus.getBmbAccessParameter(_)),
      accessRequirements = debugBmbAccessRequirements,
      bus = debugBmb,
      mapping = mapping
    )
    debugBmb.derivatedFrom(debugBmbAccessRequirements)(Bmb(_))
    if(debugMaster != null) interconnectSmp.addConnection(debugMaster.bus, debugBmb)
  }

  val jtag = Handle(withDebug.get == DEBUG_JTAG generate slave(Jtag()))
  val jtagInstructionCtrl = withDebug.produce(withDebug.get == DEBUG_JTAG_CTRL generate JtagTapInstructionCtrl())
  val debugBus = withDebug.produce(withDebug.get == DEBUG_BUS generate DebugExtensionBus())
  val debugBmb = Handle[Bmb]
  val debugRiscv = withRiscvDebug.produce(withRiscvDebug.get generate DebugHartBus())
  val jtagClockDomain = Handle[ClockDomain]

  val logic = Handle(new Area {
    withDebug.get match {
      case DEBUG_NONE =>
      case _ => config.add(new DebugPlugin(debugClockDomain, hardwareBreakpointCount))
    }

    for (e <- config.plugins) e match {
      case e: CsrPlugin => e.config.debugTriggers = hardwareBreakpointCount
      case _ =>
    }

    val cpu = new VexRiscv(config)
    def doExport(value : => Any, postfix : String) = {
      sexport(Handle(value).setCompositeName(VexRiscvBmbGenerator.this, postfix))
    }

    doExport(cpu.plugins.exists(_.isInstanceOf[CfuPlugin]), "cfu")
    doExport(cpu.plugins.exists(_.isInstanceOf[FpuPlugin]), "fpu")
    for (plugin <- cpu.plugins) plugin match {
      case plugin: IBusSimplePlugin => iBus.load(plugin.iBus.toBmb())
      case plugin: DBusSimplePlugin => dBus.load(plugin.dBus.toBmb())
      case plugin: IBusCachedPlugin => {
        iBus.load(plugin.iBus.toBmb())
        doExport(plugin.config.wayCount, "icacheWays")
        doExport(plugin.config.cacheSize, "icacheSize")
        doExport(plugin.config.bytePerLine, "bytesPerLine")
      }
      case plugin: DBusCachedPlugin => {
        dBus.load(plugin.dBus.toBmb())
        doExport(plugin.config.wayCount, "dcacheWays")
        doExport(plugin.config.cacheSize, "dcacheSize")
        doExport(plugin.config.bytePerLine, "bytesPerLine")
      }
      case plugin: MmuPlugin => {
        doExport(true, "mmu")
      }
      case plugin: StaticMemoryTranslatorPlugin => {
        doExport(false, "mmu")
      }
      case plugin: CsrPlugin => {
        doExport(plugin.config.supervisorGen, "supervisor")
        externalInterrupt load plugin.externalInterrupt
        timerInterrupt load plugin.timerInterrupt
        softwareInterrupt load plugin.softwareInterrupt
        if (plugin.config.supervisorGen) externalSupervisorInterrupt load plugin.externalInterruptS
        if(withRiscvDebug.get) {
          assert(plugin.debugBus != null, "You need to enable CsrPluginConfig.withPrivilegedDebug")
          debugRiscv <> plugin.debugBus
        }
      }
      case plugin: DebugPlugin => plugin.debugClockDomain {
        if(debugAskReset.get != null) when(RegNext(plugin.io.resetOut)) {
          debugAskReset.get()
        } else {
          debugReset.load(RegNext(plugin.io.resetOut))
        }

        withDebug.get match {
          case DEBUG_JTAG => jtag <> plugin.io.bus.fromJtag()
          case DEBUG_JTAG_CTRL => jtagInstructionCtrl <> plugin.io.bus.fromJtagInstructionCtrl(jtagClockDomain, 0)
          case DEBUG_BUS  => debugBus <> plugin.io.bus
          case DEBUG_BMB => debugBmb >> plugin.io.bus.fromBmb()
        }
      }
      case _ =>
    }
  })


  logic.soon(debugReset)

  val parameterGenerator = new Generator {
    val iBusParameter, dBusParameter = product[BmbParameter]
    dependencies += config

    add task {
      for (plugin <- config.plugins) plugin match {
        case plugin: IBusSimplePlugin => iBusParameter.load(IBusSimpleBus.getBmbParameter())
        case plugin: DBusSimplePlugin => dBusParameter.load(DBusSimpleBus.getBmbParameter())
        case plugin: IBusCachedPlugin => iBusParameter.load(plugin.config.getBmbParameter())
        case plugin: DBusCachedPlugin => dBusParameter.load(plugin.config.getBmbParameter())
        case _ =>
      }
    }
  }

  val invalidationSource = Handle[BmbInvalidationParameter]
  val invalidationRequirements = Handle[BmbInvalidationParameter]
  if(interconnectSmp != null){
    interconnectSmp.addMaster(accessRequirements = parameterGenerator.iBusParameter.derivate(_.access), bus = iBus)
    interconnectSmp.addMaster(
      accessRequirements = parameterGenerator.dBusParameter.derivate(_.access),
      invalidationSource = invalidationSource,
      invalidationCapabilities = invalidationSource,
      invalidationRequirements = invalidationRequirements,
      bus = dBus
    )
  }

}
