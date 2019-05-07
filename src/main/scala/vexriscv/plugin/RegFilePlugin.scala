package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._

import scala.collection.mutable


trait RegFileReadKind
object ASYNC extends RegFileReadKind
object SYNC extends RegFileReadKind


class RegFilePlugin(regFileReadyKind : RegFileReadKind,
                    zeroBoot : Boolean = false,
                    x0Init : Boolean = true,
                    writeRfInMemoryStage : Boolean = false,
                    readInExecute : Boolean = false,
                    syncUpdateOnStall : Boolean = true,
                    withShadow : Boolean = false //shadow registers aren't transition hazard free
                   ) extends Plugin[VexRiscv] with RegFileService{
  import Riscv._

  override def readStage(): Stage = if(readInExecute) pipeline.execute else pipeline.decode

  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(RS1_USE,False)
    decoderService.addDefault(RS2_USE,False)
    decoderService.addDefault(REGFILE_WRITE_VALID,False)
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    val readStage = if(readInExecute) execute else decode
    val writeStage = if(writeRfInMemoryStage) memory else stages.last

    val global = pipeline plug new Area{
      val regFileSize = if(withShadow) 64 else 32
      val regFile = Mem(Bits(32 bits),regFileSize) addAttribute(Verilator.public)
      if(zeroBoot) regFile.init(List.fill(regFileSize)(B(0, 32 bits)))

      val shadow = ifGen(withShadow)(new Area{
        val write, read, clear = RegInit(False)

        read  clearWhen(clear && !readStage.arbitration.isStuck)
        write clearWhen(clear && !writeStage.arbitration.isStuck)

        val csrService = pipeline.service(classOf[CsrInterface])
        csrService.w(0x7C0,2 -> clear, 1 -> read, 0 -> write)
      })
    }

    //Disable rd0 write in decoding stage
    when(decode.input(INSTRUCTION)(rdRange) === 0) {
      decode.input(REGFILE_WRITE_VALID) := False
    }

    //Read register file
    readStage plug new Area{
      import readStage._

      //read register file
      val srcInstruction = regFileReadyKind match{
        case `ASYNC` => input(INSTRUCTION)
        case `SYNC` if !readInExecute =>  input(INSTRUCTION_ANTICIPATED)
        case `SYNC` if readInExecute =>   if(syncUpdateOnStall) Mux(execute.arbitration.isStuck, execute.input(INSTRUCTION), decode.input(INSTRUCTION)) else  decode.input(INSTRUCTION)
      }

      def shadowPrefix(that : Bits) = if(withShadow) global.shadow.read ## that else that
      val regFileReadAddress1 = U(shadowPrefix(srcInstruction(Riscv.rs1Range)))
      val regFileReadAddress2 = U(shadowPrefix(srcInstruction(Riscv.rs2Range)))

      val (rs1Data,rs2Data) = regFileReadyKind match{
        case `ASYNC` => (global.regFile.readAsync(regFileReadAddress1),global.regFile.readAsync(regFileReadAddress2))
        case `SYNC` =>
          val enable = if(!syncUpdateOnStall) !readStage.arbitration.isStuck else null
          (global.regFile.readSync(regFileReadAddress1, enable),global.regFile.readSync(regFileReadAddress2, enable))
      }

      insert(RS1) := rs1Data
      insert(RS2) := rs2Data
    }

    //Write register file
    writeStage plug new Area {
      import writeStage._

      def shadowPrefix(that : Bits) = if(withShadow) global.shadow.write ## that else that
      val regFileWrite = global.regFile.writePort.addAttribute(Verilator.public).setName("lastStageRegFileWrite")
      regFileWrite.valid := output(REGFILE_WRITE_VALID) && arbitration.isFiring
      regFileWrite.address := U(shadowPrefix(output(INSTRUCTION)(rdRange)))
      regFileWrite.data := output(REGFILE_WRITE_DATA)

      //CPU will initialise constant register zero in the first cycle
      if(x0Init) {
        val boot = RegNext(False) init (True)
        regFileWrite.valid setWhen (boot)
        if (writeStage != execute) {
          inputInit[Bits](REGFILE_WRITE_DATA, 0)
          inputInit[Bits](INSTRUCTION, 0)
        } else {
          when(boot) {
            regFileWrite.address := 0
            regFileWrite.data := 0
          }
        }
      }
    }
  }
}