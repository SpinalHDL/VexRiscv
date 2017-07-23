package vexriscv.plugin

import vexriscv.{Pipeline, Stage}
import spinal.core.Area

/**
 * Created by PIC32F_USER on 03/03/2017.
 */
trait Plugin[T <: Pipeline] {
  var pipeline : T = null.asInstanceOf[T]
  def getName() = this.getClass.getSimpleName.replace("$","")

  def setup(pipeline: T) : Unit = {}
  def build(pipeline: T) : Unit

  implicit class implicitsStage(stage: Stage){
    def plug[T <: Area](area : T) : T = {area.setCompositeName(stage,getName()).reflectNames();area}
  }
  implicit class implicitsPipeline(stage: Pipeline){
    def plug[T <: Area](area : T) = {area.setName(getName()).reflectNames();area}
  }
}
