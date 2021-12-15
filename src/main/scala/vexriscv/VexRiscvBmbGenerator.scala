package vexriscv

import spinal.core._
import spinal.lib.bus.bmb.{Bmb, BmbAccessCapabilities, BmbAccessParameter, BmbImplicitDebugDecoder, BmbInvalidationParameter, BmbParameter, BmbInterconnectGenerator}
import spinal.lib.bus.misc.AddressMapping
import spinal.lib.com.jtag.{Jtag, JtagTapInstructionCtrl}
import spinal.lib.generator._
import spinal.lib.slave
import vexriscv.plugin._
import spinal.core.fiber._

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
  }

  def enableJtag(debugCd : ClockDomainResetGenerator, resetCd : ClockDomainResetGenerator) : Unit = debugCd.rework{
    this.debugClockDomain.load(debugCd.outputClockDomain)
    val resetBridge = resetCd.asyncReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_JTAG)
  }

  def enableJtagInstructionCtrl(debugCd : ClockDomainResetGenerator, resetCd : ClockDomainResetGenerator) : Unit = debugCd.rework{
    this.debugClockDomain.load(debugCd.outputClockDomain)
    val resetBridge = resetCd.asyncReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_JTAG_CTRL)
  }

  def enableDebugBus(debugCd : ClockDomainResetGenerator, resetCd : ClockDomainResetGenerator) : Unit = debugCd.rework{
    this.debugClockDomain.load(debugCd.outputClockDomain)
    val resetBridge = resetCd.asyncReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_BUS)
  }

  val debugBmbAccessSource = Handle[BmbAccessCapabilities]
  val debugBmbAccessRequirements = Handle[BmbAccessParameter]
  def enableDebugBmb(debugCd : Handle[ClockDomain], resetCd : ClockDomainResetGenerator, mapping : AddressMapping)(implicit debugMaster : BmbImplicitDebugDecoder = null) : Unit = debugCd.on{
    this.debugClockDomain.load(debugCd)
    val resetBridge = resetCd.asyncReset(debugReset, ResetSensitivity.HIGH)
    debugAskReset.loadNothing()
    withDebug.load(DEBUG_BMB)
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
  val jtagClockDomain = Handle[ClockDomain]

  val logic = Handle(new Area {
    withDebug.get != DEBUG_NONE generate new Area {
      config.add(new DebugPlugin(debugClockDomain, hardwareBreakpointCount))
    }

    val cpu = new VexRiscv(config)
    for (plugin <- cpu.plugins) plugin match {
      case plugin: IBusSimplePlugin => iBus.load(plugin.iBus.toBmb())
      case plugin: DBusSimplePlugin => dBus.load(plugin.dBus.toBmb())
      case plugin: IBusCachedPlugin => iBus.load(plugin.iBus.toBmb())
      case plugin: DBusCachedPlugin => dBus.load(plugin.dBus.toBmb())
      case plugin: CsrPlugin => {
        externalInterrupt load plugin.externalInterrupt
        timerInterrupt load plugin.timerInterrupt
        softwareInterrupt load plugin.softwareInterrupt
        if (plugin.config.supervisorGen) externalSupervisorInterrupt load plugin.externalInterruptS
      }
      case plugin: DebugPlugin => plugin.debugClockDomain {
        if(debugAskReset.get != null) when(RegNext(plugin.io.resetOut)) {
          debugAskReset.get()
        } else {
          debugReset.load(RegNext(plugin.io.resetOut))
        }

        withDebug.get match {
          case DEBUG_JTAG => jtag <> plugin.io.bus.fromJtag()
          case DEBUG_JTAG_CTRL => jtagInstructionCtrl <> plugin.io.bus.fromJtagInstructionCtrl(jtagClockDomain)
          case DEBUG_BUS => debugBus <> plugin.io.bus
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
