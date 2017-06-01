package SpinalRiscv.Plugin

import SpinalRiscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer
case class StaticMemoryTranslatorPort(bus : MemoryTranslatorBus, stage : Stage)

class StaticMemoryTranslatorPlugin(ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator {
  val portsInfo = ArrayBuffer[StaticMemoryTranslatorPort]()

  override def newTranslationPort(stage : Stage,args : Any): MemoryTranslatorBus = {
//    val exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(stage)
    val port = StaticMemoryTranslatorPort(MemoryTranslatorBus(),stage)
    portsInfo += port
    port.bus
  }

  override def setup(pipeline: VexRiscv): Unit = {
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._

    val core = pipeline plug new Area {
      val ports = for ((port, portId) <- portsInfo.zipWithIndex) yield new Area {
        port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress
        port.bus.rsp.allowRead := True
        port.bus.rsp.allowWrite := True
        port.bus.rsp.allowExecute := True
        port.bus.rsp.allowUser := True
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.miss := False
      }
    }
  }
}
