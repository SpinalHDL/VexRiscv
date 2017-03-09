package SpinalRiscv

import spinal.core._
import spinal.lib._

import scala.collection.mutable


class Stageable[T <: Data](dataType : T) extends HardType[T](dataType) with Nameable{
  setWeakName(this.getClass.getSimpleName.replace("$",""))
}

class Stage() extends Area{
  def input[T <: Data](key : Stageable[T]) : T = {
    inputs.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],{
      val input,inputDefault = key()
      inputsDefault(key.asInstanceOf[Stageable[Data]]) = inputDefault
      input := inputDefault
      input.setPartialName(this,"input_" + key.getName())
    }).asInstanceOf[T]
  }

  def output[T <: Data](key : Stageable[T]) : T = {
    outputs.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],{
      val output,outputDefault = key()
      outputsDefault(key.asInstanceOf[Stageable[Data]]) = outputDefault
      output := outputDefault
      output.setPartialName(this,"output_" + key.getName())
    }).asInstanceOf[T]
  }

  def insert[T <: Data](key : Stageable[T]) : T = inserts.getOrElseUpdate(key.asInstanceOf[Stageable[Data]],key()).asInstanceOf[T].setPartialName(this,key.getName())
//  def apply[T <: Data](key : Stageable[T]) : T = ???


  val arbitration = new Bundle{
    val haltIt = False
    val removeIt = False
    val isValid = RegInit(False)
    val isStuck = Bool
    val isFiring = Bool
  }


  val inputs   = mutable.HashMap[Stageable[Data],Data]()
  val outputs  = mutable.HashMap[Stageable[Data],Data]()
  val signals  = mutable.HashMap[Stageable[Data],Data]()
  val inserts  = mutable.HashMap[Stageable[Data],Data]()

  val inputsDefault   = mutable.HashMap[Stageable[Data],Data]()
  val outputsDefault  = mutable.HashMap[Stageable[Data],Data]()
}


//object StageMain{
//
//  object OpEnum extends SpinalEnum{
//    val AND,OR = newElement()
//  }
//  object OP  extends Stageable(OpEnum())
//  object SRC1  extends Stageable(Bits(32 bits))
//  object SRC2  extends Stageable(Bits(32 bits))
//  object RESULT extends Stageable(Bits(32 bits))
//  def main(args: Array[String]) {
//    val E = List.fill(2)(new Stage(9))
//    val E0 = E(0)
//    import E0._
//    output(RESULT) := E(0).input(OP).mux(
//      OpEnum.AND -> (E(0).input(SRC1) & E(0).input(SRC2)),
//      OpEnum.OR  -> (E(0).input(SRC1) | E(0).input(SRC2))
//    )
//  }
//}
