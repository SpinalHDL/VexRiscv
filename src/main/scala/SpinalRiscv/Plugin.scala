package SpinalRiscv

import spinal.core.Area

/**
 * Created by PIC32F_USER on 03/03/2017.
 */
trait Plugin[T <: Pipeline] {
  def getName() = this.getClass.getSimpleName.replace("$","")

  def setup(pipeline: T) : Unit = {}
  def build(pipeline: T) : Unit

  implicit class implicits(stage: Stage){
    def plug(area : Area) = area.setCompositeName(stage,getName()).reflectNames()
  }
}
