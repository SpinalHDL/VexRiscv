package vexriscv

import spinal.core._
import spinal.lib._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


class Stageable[T <: Data](_dataType : => T) extends HardType[T](_dataType) with Nameable{
  def dataType = apply()
  setWeakName(this.getClass.getSimpleName.replace("$",""))
}

class Stage() extends Area{
  def outsideCondScope[T](that : => T) : T = {
    val body = Component.current.dslBody  // Get the head of the current component symboles tree (AST in other words)
    val ctx = body.push()                           // Now all access to the SpinalHDL API will be append to it (instead of the current context)
    val swapContext = body.swap()         // Empty the symbole tree (but keep a reference to the old content)
    val ret = that                        // Execute the block of code (will be added to the recently empty body)
    ctx.restore()                            // Restore the original context in which this function was called
    swapContext.appendBack()              // append the original symboles tree to the modified body
    ret                                   // return the value returned by that
  }

  def input[T <: Data](key : Stageable[T]) : T = {
    inputs.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],outsideCondScope{
      val input,inputDefault = key()
      inputsDefault(key.asInstanceOf[Stageable[Data]]) = inputDefault
      input := inputDefault
      input.setPartialName(this, key.getName())
    }).asInstanceOf[T]
  }

  def output[T <: Data](key : Stageable[T]) : T = {
    outputs.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],outsideCondScope{
      val output,outputDefault = key()
      outputsDefault(key.asInstanceOf[Stageable[Data]]) = outputDefault
      output := outputDefault
      output //.setPartialName(this,"output_" + key.getName())
    }).asInstanceOf[T]
  }

  def insert[T <: Data](key : Stageable[T]) : T = inserts.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],outsideCondScope(key())).asInstanceOf[T] //.setPartialName(this,key.getName())
//  def apply[T <: Data](key : Stageable[T]) : T = ???


  val arbitration = new Area{
    val haltItself  = False   //user settable, stuck the instruction, should only be set by the instruction itself
    val haltByOther = False   //When settable, stuck the instruction, should only be set by something else than the stucked instruction
    val removeIt    = False   //When settable, unschedule the instruction as if it was never executed (no side effect)
    val flushIt    = False   //When settable, unschedule the current instruction
    val flushNext    = False   //When settable, unschedule instruction above in the pipeline
    val isValid     = Bool //Inform if a instruction is in the current stage
    val isStuck     = Bool           //Inform if the instruction is stuck (haltItself || haltByOther)
    val isStuckByOthers = Bool       //Inform if the instruction is stuck by sombody else
    def isRemoved   = removeIt       //Inform if the instruction is going to be unschedule the current cycle
    val isFlushed   = Bool           //Inform if the instruction is flushed (flushAll set in the current or subsequents stages)
    val isMoving     = Bool           //Inform if the instruction is going somewere else (next stage or unscheduled)
    val isFiring    = Bool           //Inform if the current instruction will go to the next stage the next cycle (isValid && !isStuck && !removeIt)
  }


  val inputs   = mutable.LinkedHashMap[Stageable[Data],Data]()
  val outputs  = mutable.LinkedHashMap[Stageable[Data],Data]()
  val signals  = mutable.LinkedHashMap[Stageable[Data],Data]()
  val inserts  = mutable.LinkedHashMap[Stageable[Data],Data]()

  val inputsDefault   = mutable.LinkedHashMap[Stageable[Data],Data]()
  val outputsDefault  = mutable.LinkedHashMap[Stageable[Data],Data]()

  val dontSample      = mutable.LinkedHashMap[Stageable[_], ArrayBuffer[Bool]]()

  def dontSampleStageable(s : Stageable[_], cond : Bool): Unit ={
    dontSample.getOrElseUpdate(s, ArrayBuffer[Bool]()) += cond
  }
  def inputInit[T <: BaseType](stageable : Stageable[T],initValue : T) =
    Component.current.addPrePopTask(() => inputsDefault(stageable.asInstanceOf[Stageable[Data]]).asInstanceOf[T].getDrivingReg.init(initValue))
}