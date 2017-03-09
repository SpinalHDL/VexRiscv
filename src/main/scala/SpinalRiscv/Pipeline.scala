package SpinalRiscv

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
    val filtered = plugins.filter(o => classOf[PcManagerService].isAssignableFrom(o.getClass))
    assert(filtered.length == 1)
    filtered.head.asInstanceOf[T]
  }

  def build(): Unit ={
    //Build plugins
    plugins.foreach(_.build(this.asInstanceOf[T]))

    //Interconnect stages
    class KeyInfo{
      var insertStageId = Int.MaxValue
      var lastInputStageId = Int.MinValue
      var lastOutputStageId = Int.MinValue

      def addInputStageIndex(stageId : Int): Unit = {
        require(stageId > insertStageId)
        lastInputStageId = Math.max(lastInputStageId,stageId)
        lastOutputStageId = Math.max(lastOutputStageId,stageId-1)
      }


      def addOutputStageIndex(stageId : Int): Unit = {
        require(stageId >= insertStageId)
        if(stageId != insertStageId) lastInputStageId = Math.min(lastInputStageId,stageId)
        lastOutputStageId = Math.max(lastOutputStageId,stageId)
      }

      def setInsertStageId(stageId : Int) = insertStageId = stageId
    }

    val inputOutputKeys = mutable.HashMap[Stageable[Data],KeyInfo]()
    for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
      stage.inserts.keysIterator.foreach(signal => inputOutputKeys.getOrElseUpdate(signal,new KeyInfo).setInsertStageId(stageIndex))
    }

    for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
      stage.inputs.keysIterator.foreach(key => inputOutputKeys.getOrElseUpdate(key,new KeyInfo).addInputStageIndex(stageIndex))
      stage.outputs.keysIterator.foreach(key => inputOutputKeys.getOrElseUpdate(key,new KeyInfo).addOutputStageIndex(stageIndex))
    }

    for((key,info) <- inputOutputKeys){
      //Interconnect inputs -> outputs
      for(stageIndex <- info.insertStageId to info.lastOutputStageId;
           stage = stages(stageIndex)) {
        stage.output(key)
        val outputDefault = stage.outputsDefault.getOrElse(key, null)
        if (outputDefault != null) {
          if (stageIndex == info.insertStageId) {
            outputDefault := stage.inserts(key)
          } else {
            outputDefault := stage.input(key)
          }
        }
      }

      //Interconnect outputs -> inputs
      for(stageIndex <- info.insertStageId + 1 to info.lastInputStageId) {
        val stageBefore = stages(stageIndex - 1)
        val stage = stages(stageIndex)
        stage.input(key)
        val inputDefault = stage.inputsDefault.getOrElse(key, null)
        if (inputDefault != null) {
          inputDefault := RegNextWhen(stageBefore.output(key),!stageBefore.arbitration.isStuck) //!stage.input.valid || stage.input.ready
        }
      }

      //Arbitration
      for(stageIndex <- 0 until stages.length; stage = stages(stageIndex)){
        stage.arbitration.isStuck := stages.takeRight(stages.length - stageIndex).map(_.arbitration.haltIt).reduce(_ || _)
        stage.arbitration.isFiring := stage.arbitration.isValid && !stage.arbitration.isStuck && !stage.arbitration.removeIt
      }

      for(stageIndex <- 1 until stages.length){
        val stageBefore = stages(stageIndex - 1)
        val stage = stages(stageIndex)

        stage.arbitration.isStuck := stages.takeRight(stages.length-stageIndex).map(_.arbitration.haltIt).reduce(_ || _)
        when(!stageBefore.arbitration.isStuck) {
          stage.arbitration.isValid := stage.arbitration.isValid && !stage.arbitration.removeIt
        }
        when(stage.arbitration.removeIt){
          stage.arbitration.isValid := False
        }
      }
    }
  }


  Component.current.addPrePopTask(() => build())
}
