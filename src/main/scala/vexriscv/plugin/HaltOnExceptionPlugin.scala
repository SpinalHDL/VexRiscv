
package vexriscv.plugin

import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable


class HaltOnExceptionPlugin() extends Plugin[VexRiscv] with ExceptionService {
  def xlen = 32

  //Mannage ExceptionService calls
  val exceptionPortsInfos = ArrayBuffer[ExceptionPortInfo]()
  def exceptionCodeWidth = 4
  override def newExceptionPort(stage : Stage, priority : Int = 0) = {
    val interface = Flow(ExceptionCause())
    exceptionPortsInfos += ExceptionPortInfo(interface,stage,priority)
    interface
  }
  override def isExceptionPending(stage : Stage): Bool = False


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    stages.head.insert(FORMAL_HALT) := False
    stages.foreach(stage => {
      val stagePorts = exceptionPortsInfos.filter(_.stage == stage)
      if(stagePorts.nonEmpty) {
        when(stagePorts.map(info => info.port.valid).orR) {
          stage.output(FORMAL_HALT) := True
          stage.arbitration.haltItself := True
        }
        for(stage <- stages){
          stage.output(FORMAL_HALT) clearWhen(stage.arbitration.isFlushed)
        }
      }
    })
  }
}
