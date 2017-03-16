package SpinalRiscv

import SpinalRiscv.Plugin.Plugin
import spinal.core._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


trait Pipeline {
  type T <: Pipeline
  val plugins = ArrayBuffer[Plugin[T]]()
  var stages = ArrayBuffer[Stage]()
//  val services = ArrayBuffer[Any]()

  def indexOf(stage : Stage) = stages.indexOf(stage)

  def service[T](clazz : Class[T]) = {
    val filtered = plugins.filter(o => clazz.isAssignableFrom(o.getClass))
    assert(filtered.length == 1)
    filtered.head.asInstanceOf[T]
  }

  def build(): Unit ={
    plugins.foreach(_.setup(this.asInstanceOf[T]))

    //Build plugins
    plugins.foreach(_.build(this.asInstanceOf[T]))

    //Interconnect stages
    class KeyInfo{
      var insertStageId = Int.MaxValue
      var lastInputStageId = Int.MinValue
      var lastOutputStageId = Int.MinValue

      def addInputStageIndex(stageId : Int): Unit = {
        require(stageId >= insertStageId)
        lastInputStageId = Math.max(lastInputStageId,stageId)
        lastOutputStageId = Math.max(lastOutputStageId,stageId-1)
      }


      def addOutputStageIndex(stageId : Int): Unit = {
        require(stageId >= insertStageId)
        lastInputStageId = Math.max(lastInputStageId,stageId)
        lastOutputStageId = Math.max(lastOutputStageId,stageId)
      }

      def setInsertStageId(stageId : Int) = insertStageId = stageId
    }

    val inputOutputKeys = mutable.HashMap[Stageable[Data],KeyInfo]()
    val insertedStageable = mutable.Set[Stageable[Data]]()
    for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
      stage.inserts.keysIterator.foreach(signal => inputOutputKeys.getOrElseUpdate(signal,new KeyInfo).setInsertStageId(stageIndex))
      stage.inserts.keysIterator.foreach(insertedStageable += _)
    }

    val missingInserts = mutable.Set[Stageable[Data]]()
    for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
      stage.inputs.keysIterator.foreach(key => if(!insertedStageable.contains(key)) missingInserts += key)
      stage.outputs.keysIterator.foreach(key => if(!insertedStageable.contains(key)) missingInserts += key)
    }

    if(missingInserts.nonEmpty){
      throw new Exception("Missing inserts : " + missingInserts.map(_.getName()).mkString(", "))
    }

    for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
      stage.inputs.keysIterator.foreach(key => inputOutputKeys.getOrElseUpdate(key,new KeyInfo).addInputStageIndex(stageIndex))
      stage.outputs.keysIterator.foreach(key => inputOutputKeys.getOrElseUpdate(key,new KeyInfo).addOutputStageIndex(stageIndex))
    }

    for((key,info) <- inputOutputKeys) {
      //Interconnect inputs -> outputs
      for (stageIndex <- info.insertStageId to info.lastOutputStageId;
           stage = stages(stageIndex)) {
        stage.output(key)
        val outputDefault = stage.outputsDefault.getOrElse(key, null)
        if (outputDefault != null) {
          outputDefault := stage.input(key)
        }
      }

      //Interconnect outputs -> inputs
      for (stageIndex <- info.insertStageId to info.lastInputStageId) {
        val stage = stages(stageIndex)
        stage.input(key)
        val inputDefault = stage.inputsDefault.getOrElse(key, null)
        if (inputDefault != null) {
          if (stageIndex == info.insertStageId) {
            inputDefault := stage.inserts(key)
          } else {
            val stageBefore = stages(stageIndex - 1)
            inputDefault := RegNextWhen(stageBefore.output(key), !stage.arbitration.isStuck) //!stage.input.valid || stage.input.ready
          }
        }
      }
    }

    //Arbitration
    for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
      stage.arbitration.isStuckByOthers := stages.takeRight(stages.length - stageIndex - 1).map(_.arbitration.haltIt).foldLeft(False)(_ || _)
      stage.arbitration.isStuck := stage.arbitration.haltIt || stage.arbitration.isStuckByOthers
      stage.arbitration.isFiring := stage.arbitration.isValid && !stage.arbitration.isStuck && !stage.arbitration.removeIt
    }

    for(stageIndex <- 1 until stages.length){
      val stageBefore = stages(stageIndex - 1)
      val stage = stages(stageIndex)

      when(!stage.arbitration.isStuck || stage.arbitration.removeIt) {
        stage.arbitration.isValid := False
      }
      when(!stageBefore.arbitration.isStuck && !stageBefore.arbitration.removeIt) {
        stage.arbitration.isValid := stageBefore.arbitration.isValid
      }
    }
  }


  Component.current.addPrePopTask(() => build())
}
