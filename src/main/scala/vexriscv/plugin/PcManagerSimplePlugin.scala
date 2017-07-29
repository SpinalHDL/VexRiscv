package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer

class PcManagerSimplePlugin(resetVector       : BigInt,
                            relaxedPcCalculation : Boolean = false) extends Plugin[VexRiscv] with JumpService{
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
    if(!relaxedPcCalculation) pipeline.unremovableStages += pipeline.prefetch
  }


  override def build(pipeline: VexRiscv): Unit = {
    if(relaxedPcCalculation)
      relaxedImpl(pipeline)
    else
      cycleEffectiveImpl(pipeline)
  }

  //reduce combinatorial path, and expose the PC to the pipeline as a register
  def relaxedImpl(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline.prefetch

    prefetch plug new Area {
      import prefetch._
      //Stage always valid
      arbitration.isValid := True

      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init(resetVector) addAttribute(Verilator.public)
      when(arbitration.isFiring){
        pcReg := pcReg + 4
      }

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
          pcReg := pcLoad.payload
        }
      }

      insert(PC_CALC_WITHOUT_JUMP)  := pcReg
      insert(PC) := pcReg
    }
  }

  //Jump take effect instantly (save one cycle), but expose the PC to the pipeline as a 'long' combinatorial path
  def cycleEffectiveImpl(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    import pipeline.prefetch

    prefetch plug new Area {
      import prefetch._
      //Stage always valid
      arbitration.isValid := True

      //PC calculation without Jump
      val pcReg = Reg(UInt(32 bits)) init(resetVector) addAttribute(Verilator.public)
      val inc = RegInit(False)
      val pcBeforeJumps = pcReg + (inc ## B"00").asUInt
      insert(PC_CALC_WITHOUT_JUMP) := pcBeforeJumps
      val pc = UInt(32 bits)
      pc := input(PC_CALC_WITHOUT_JUMP)

      val samplePcNext = False

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