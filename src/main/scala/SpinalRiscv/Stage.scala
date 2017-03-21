package SpinalRiscv

import spinal.core._
import spinal.lib._

import scala.collection.mutable


class Stageable[T <: Data](val dataType : T) extends HardType[T](dataType) with Nameable{
  setWeakName(this.getClass.getSimpleName.replace("$",""))
}

class Stage() extends Area{
  def outsideCondScope[T](that : => T) : T = {
    val condStack = GlobalData.get.conditionalAssignStack.stack.toList
    val switchStack = GlobalData.get.switchStack.stack.toList
    GlobalData.get.conditionalAssignStack.stack.clear()
    GlobalData.get.switchStack.stack.clear()
    val ret = that
    GlobalData.get.conditionalAssignStack.stack.pushAll(condStack.reverseIterator)
    GlobalData.get.switchStack.stack.pushAll(switchStack.reverseIterator)
    ret
  }

  def input[T <: Data](key : Stageable[T]) : T = {
    inputs.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],outsideCondScope{
      val input,inputDefault = key()
      inputsDefault(key.asInstanceOf[Stageable[Data]]) = inputDefault
      input := inputDefault
      input.setPartialName(this,"input_" + key.getName())
    }).asInstanceOf[T]
  }

  def output[T <: Data](key : Stageable[T]) : T = {
    outputs.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],outsideCondScope{
      val output,outputDefault = key()
      outputsDefault(key.asInstanceOf[Stageable[Data]]) = outputDefault
      output := outputDefault
      output.setPartialName(this,"output_" + key.getName())
    }).asInstanceOf[T]
  }

  def insert[T <: Data](key : Stageable[T]) : T = inserts.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],outsideCondScope(key())).asInstanceOf[T].setPartialName(this,key.getName())
//  def apply[T <: Data](key : Stageable[T]) : T = ???


  val arbitration = new Area{
    val haltIt = False
    val removeIt = False
    val flushIt = False
    val isValid = RegInit(False)
    val isStuck = Bool
    val isStuckByOthers = Bool
    val isFiring = Bool
  }


  val inputs   = mutable.HashMap[Stageable[Data],Data]()
  val outputs  = mutable.HashMap[Stageable[Data],Data]()
  val signals  = mutable.HashMap[Stageable[Data],Data]()
  val inserts  = mutable.HashMap[Stageable[Data],Data]()

  val inputsDefault   = mutable.HashMap[Stageable[Data],Data]()
  val outputsDefault  = mutable.HashMap[Stageable[Data],Data]()

  def inputInit[T <: BaseType](stageable : Stageable[T],initValue : T) =
    Component.current.addPrePopTask(() => inputsDefault(stageable.asInstanceOf[Stageable[Data]]).asInstanceOf[T].getDrivingReg.init(initValue))
}