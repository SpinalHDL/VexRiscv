package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._

import scala.collection.mutable


trait RegFileReadKind
object ASYNC extends RegFileReadKind
object SYNC extends RegFileReadKind

class RegFilePlugin(regFileReadyKind : RegFileReadKind,zeroBoot : Boolean = false, writeRfInMemoryStage : Boolean = false) extends Plugin[VexRiscv]{
  import Riscv._

  assert(!writeRfInMemoryStage)

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

    val global = pipeline plug new Area{
      val regFile = Mem(Bits(32 bits),32) addAttribute(Verilator.public)
      if(zeroBoot) regFile.init(List.fill(32)(B(0, 32 bits)))
    }

    //Read register file
    decode plug new Area{
      import decode._

      //Disable rd0 write in decoding stage
      when(decode.input(INSTRUCTION)(rdRange) === 0) {
        decode.input(REGFILE_WRITE_VALID) := False
      }

      //read register file
      val srcInstruction = regFileReadyKind match{
        case `ASYNC` => input(INSTRUCTION)
        case `SYNC` =>  input(INSTRUCTION_ANTICIPATED)
      }

      val regFileReadAddress1 = srcInstruction(Riscv.rs1Range).asUInt
      val regFileReadAddress2 = srcInstruction(Riscv.rs2Range).asUInt

      val (rs1Data,rs2Data) = regFileReadyKind match{
        case `ASYNC` => (global.regFile.readAsync(regFileReadAddress1),global.regFile.readAsync(regFileReadAddress2))
        case `SYNC` =>  (global.regFile.readSync(regFileReadAddress1),global.regFile.readSync(regFileReadAddress2))
      }

      insert(RS1) := rs1Data
      insert(RS2) := rs2Data
    }

    //Write register file
    (if(writeRfInMemoryStage) memory else writeBack) plug new Area {
      import writeBack._

      val regFileWrite = global.regFile.writePort.addAttribute(Verilator.public)
      regFileWrite.valid := output(REGFILE_WRITE_VALID) && arbitration.isFiring
      regFileWrite.address := output(INSTRUCTION)(rdRange).asUInt
      regFileWrite.data := output(REGFILE_WRITE_DATA)

      //CPU will initialise constant register zero in the first cycle
      regFileWrite.valid setWhen(RegNext(False) init(True))
      inputInit[Bits](REGFILE_WRITE_DATA, 0)
      inputInit[Bits](INSTRUCTION, 0)
    }
  }
}