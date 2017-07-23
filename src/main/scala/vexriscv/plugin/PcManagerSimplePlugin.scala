package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer

class PcManagerSimplePlugin(resetVector : BigInt, fastPcCalculation : Boolean) extends Plugin[VexRiscv] with JumpService{


  //FetchService interface
  case class JumpInfo(interface :  Flow[UInt], stage: Stage)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def createJumpInterface(stage: Stage): Flow[UInt] = {
    val interface = Flow(UInt(32 bits))
    jumpInfos += JumpInfo(interface,stage)
    interface
  }
  var prefetchExceptionPort : Flow[ExceptionCause] = null
  
  override def setup(pipeline: VexRiscv): Unit = {
    pipeline.unremovableStages += pipeline.prefetch
  }


  override def build(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline.prefetch

    prefetch plug new Area {
      import prefetch._
      //Stage always valid
      arbitration.isValid := True

      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init(resetVector) addAttribute(Verilator.public)
      val inc = RegInit(False)
      val pcBeforeJumps = if(fastPcCalculation){
        val pcPlus4 = pcReg + U(4)
        pcPlus4.addAttribute("keep")
        Mux(inc,pcPlus4,pcReg)
      }else{
        pcReg + Mux[UInt](inc,4,0)
      }

      insert(PC_CALC_WITHOUT_JUMP) := pcBeforeJumps
      val pc = UInt(32 bits)
      pc := input(PC_CALC_WITHOUT_JUMP)

      val samplePcNext = False //TODO FMAX

      //JumpService hardware implementation
      val jump = if(jumpInfos.length != 0) new Area {
        val sortedByStage = jumpInfos.sortWith((a, b) => pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage))
        val valids = sortedByStage.map(_.interface.valid)
        val pcs = sortedByStage.map(_.interface.payload)

        val pcLoad = Flow(UInt(32 bits))
        pcLoad.valid := jumpInfos.map(_.interface.valid).orR
        pcLoad.payload := MuxOH(OHMasking.first(valids.asBits), pcs)

        //application of the selected jump request
        when(pcLoad.valid) {
          inc := False
          samplePcNext := True
          pc := pcLoad.payload
        }
      }

      when(arbitration.isFiring){
        inc := True
        samplePcNext := True
      }

      when(samplePcNext) { pcReg := pc }

      insert(PC) := pc
    }
  }
}