package vexriscv.experimental

import spinal.core._

class Stageable[T <: Data](val dataType : T) extends HardType[T](dataType) with Nameable{
  setWeakName(this.getClass.getSimpleName.replace("$",""))
}

trait Stage{
  def read[T <: Data](stageable : Stageable[T]) : T
  def write[T <: Data](stageable : Stageable[T], value : T, cond : Bool = null) : Unit

  def haltBySelf   : Bool   //user settable, stuck the instruction, should only be set by the instruction itself
  def haltByOthers : Bool   //When settable, stuck the instruction, should only be set by something else than the stucked instruction
  def removeIt     : Bool   //When settable, unschedule the instruction as if it was never executed (no side effect)
  def flushAll     : Bool   //When settable, unschedule instructions in the current stage and all prior ones

  def isValid        : Bool //Inform if a instruction is in the current stage
  def isStuck        : Bool //Inform if the instruction is stuck (haltItself || haltByOther)
  def isStuckByOthers: Bool //Inform if the instruction is stuck by sombody else
  def isRemoved      : Bool //Inform if the instruction is going to be unschedule the current cycle
  def isFlushed      : Bool //Inform if the instruction is flushed (flushAll set in the current or subsequents stages)
  def isFiring       : Bool //Inform if the current instruction will go to the next stage the next cycle (isValid && !isStuck && !removeIt)
}

abstract class UnusedStage extends Stage
abstract class AsyncStage extends Stage
abstract class CycleStage extends Stage
abstract class SyncStage extends Stage
abstract class CutStage extends Stage

abstract class PipelineStd{
  val prefetch, fetch, decode, execute, memory, writeback = 0
}