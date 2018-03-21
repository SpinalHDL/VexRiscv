package vexriscv.plugin

import vexriscv._
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.avalon.{AvalonMM, AvalonMMConfig}

import scala.collection.mutable.ArrayBuffer


case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle with IMasterSlave{
  val error = Bool
  val inst  = Bits(32 bits)

  override def asMaster(): Unit = {
    out(error,inst)
  }
}

object StreamVexPimper{
  implicit class StreamFlushPimper[T <: Data](pimped : Stream[T]){
    def m2sPipe(flush : Bool, collapsBubble : Boolean = true): Stream[T] = {
      val ret = cloneOf(pimped)

      val rValid = RegInit(False)
      val rData = Reg(pimped.dataType)

      pimped.ready := (Bool(collapsBubble) && !ret.valid) || ret.ready

      when(pimped.ready) {
        rValid := pimped.valid
        rData := pimped.payload
      }

      ret.valid := rValid
      ret.payload := rData

      rValid.clearWhen(flush)

      ret
    }

    def s2mPipe(flush : Bool): Stream[T] = {
      val ret = cloneOf(pimped)

      val rValid = RegInit(False)
      val rBits = Reg(pimped.dataType)

      ret.valid := pimped.valid || rValid
      pimped.ready := !rValid
      ret.payload := Mux(rValid, rBits, pimped.payload)

      when(ret.ready) {
        rValid := False
      }

      when(pimped.ready && (!ret.ready)) {
        rValid := pimped.valid
        rBits := pimped.payload
      }

      rValid.clearWhen(flush)

      ret
    }
  }

}

import StreamVexPimper._

object IBusSimpleBus{
  def getAxi4Config() = Axi4Config(
    addressWidth = 32,
    dataWidth = 32,
    useId = false,
    useRegion = false,
    useBurst = false,
    useLock = false,
    useQos = false,
    useLen = false,
    useResp = true,
    useSize = false
  )

  def getAvalonConfig() = AvalonMMConfig.pipelined(
    addressWidth = 32,
    dataWidth = 32
  ).getReadOnlyConfig.copy(
    useResponse = true,
    maximumPendingReadTransactions = 8
  )
}


case class IBusSimpleBus(interfaceKeepData : Boolean) extends Bundle with IMasterSlave {
  var cmd = Stream(IBusSimpleCmd())
  var rsp = Flow(IBusSimpleRsp())

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }


  def toAxi4ReadOnly(): Axi4ReadOnly = {
    assert(!interfaceKeepData)
    val axi = Axi4ReadOnly(IBusSimpleBus.getAxi4Config())

    axi.ar.valid := cmd.valid
    axi.ar.addr  := cmd.pc(axi.readCmd.addr.getWidth -1 downto 2) @@ U"00"
    axi.ar.prot  := "110"
    axi.ar.cache := "1111"
    cmd.ready := axi.ar.ready


    rsp.valid := axi.r.valid
    rsp.inst := axi.r.data
    rsp.error := !axi.r.isOKAY()
    axi.r.ready := True


    //TODO remove
    val axi2 = Axi4ReadOnly(IBusSimpleBus.getAxi4Config())
    axi.ar >-> axi2.ar
    axi.r << axi2.r
//    axi2 << axi
    axi2
  }

  def toAvalon(): AvalonMM = {
    assert(!interfaceKeepData)
    val avalonConfig = IBusSimpleBus.getAvalonConfig()
    val mm = AvalonMM(avalonConfig)

    mm.read := cmd.valid
    mm.address := (cmd.pc >> 2) @@ U"00"
    cmd.ready := mm.waitRequestn

    rsp.valid := mm.readDataValid
    rsp.inst := mm.readData
    rsp.error := mm.response =/= AvalonMM.Response.OKAY

    mm
  }
}

trait IBusFetcher{
  def haltIt() : Unit
  def nextPc() : (Bool, UInt)
}

object RvcDecompressor{

  def main(args: Array[String]): Unit = {
    SpinalVerilog(new Component{
      out(Delay((apply(Delay(in Bits(16 bits),2))),2))
    }.setDefinitionName("Decompressor"))
  }

  def apply(i : Bits): Bits ={
    val ret = Bits(32 bits).assignDontCare()

    val rch = B"01" ## i(9 downto 7)
    val rcl = B"01" ## i(4 downto 2)

    val addi5spnImm = B"00" ## i(10 downto 7) ## i(12 downto 11) ## i(5) ## i(6) ## B"00"
    val lwImm = B"00000" ## i(5) ## i(12 downto 10)  ## i(6) ## B"00"
    def swImm = lwImm
    val addImm = B((11 downto 5) -> i(12), (4 downto 0) -> i(6 downto 2))
    def lImm = addImm
    val jalImm = B((9 downto 0) -> i(12)) ## i(8) ## i(10 downto 9) ## i(6) ## i(7) ## i(2) ## i(11) ## i(5 downto 3) ## B"0"
    val luiImm = B((14 downto 0) -> i(12)) ## i(6 downto 2) ## B"0000_0000_0000"
    val shiftImm = i(6 downto 2)
    val addi16spImm = B((2 downto 0) -> i(12)) ## i(4 downto 3) ## i(5) ## i(2) ## i(6) ## B"0000"
    val jImm = B((9 downto 0) -> i(12)) ## i(8) ## i(10 downto 9) ## i(6) ## i(7) ## i(2) ## i(11) ## i(5 downto 3) ## B"0"
    val bImm = B((4 downto 0) -> i(12)) ## i(6 downto 5) ## i(2) ## i(11 downto 10) ## i(4 downto 3) ## B"0"

    def lwspImm = B"0000" ## i(3 downto 2) ## i(12) ## i(6 downto 4) ## B"00"
    def swspImm = B"0000" ## i(8 downto 7) ## i(12 downto 9) ## B"00"


    val x0 = B"00000"
    val x1 = B"00001"
    val x2 = B"00010"

    switch(i(1 downto 0) ## i(15 downto 13)){
      is(0){ret := addi5spnImm ## B"00010" ## B"000" ## rcl ## B"0010011"} //C.ADDI4SPN -> addi rd0, x2, nzuimm[9:2].
      is(2){ret := lwImm ## rch ## B"010" ## rcl ## B"0000011"} //C.LW -> lw rd', offset[6:2](rs1')
      is(6){ret := swImm(11 downto 5) ## rcl  ## rch ## B"010" ## swImm(4 downto 0) ## B"0100011"} //C.SW -> sw rs2',offset[6:2](rs1')
      is(8){ret := addImm ## i(11 downto 7) ## B"000" ## i(11 downto 7) ## B"0010011"} //C.ADDI -> addi rd, rd, nzimm[5:0].
      is(9){ret := jalImm(20) ## jalImm(10 downto 1) ## jalImm(11) ## jalImm(19 downto 12) ## x1 ## B"1101111"} //C.JAL -> jalr x1, rs1, 0.
      is(10){ret := lImm ## B"00000" ## B"000" ## i(11 downto 7) ## B"0010011"} //C.LI -> addi rd, x0, imm[5:0].
      is(11){  //C.ADDI16SP    C.LUI ->
        val addi16sp =  addi16spImm ## i(11 downto 7) ## B"000" ## i(11 downto 7) ## B"0010011"
        val lui      =  luiImm(31 downto 12) ## i(11 downto 7) ## B"0110111"
        ret := (i(11 downto 7) === 2) ? addi16sp | lui
      }
      is(12){
        val isImmediate = i(11 downto 10) =/= "11"
        val isShift = !i(11)
        val func3 = i(11 downto 10).mux(
          0 -> B"101",
          1 -> B"101",
          2 -> B"111",
          3 -> i(6 downto 5).mux(
            0 -> B"000",
            1 -> B"100",
            2 -> B"110",
            3 -> B"111"
          )
        )
        val msbs = Mux(
          sel = i(11 downto 10) === "10",
          whenTrue = B((6 downto 0) -> i(12)), //andi
          whenFalse = B"0" ## (i(11 downto 10) === B"01" || (i(11 downto 10) === B"11" && i(6 downto 5) === B"00")) ## B"00000"
        )
        val rs2Shift = isShift ? shiftImm | rcl
        val opc = (isImmediate ? B"0010011" | B"0110011")
        ret := msbs ## rs2Shift ## rch ## func3 ## rch ## opc
      }
      is(13){ ret := jImm(20) ## jImm(10 downto 1) ## jImm(11) ## jImm(19 downto 12) ## x0 ## B"1101111"}
      is(14){ ret := bImm(12) ## bImm(10 downto 5) ## x0 ## rch ## B"000" ## bImm(4 downto 1) ## bImm(11) ## B"1100011" }
      is(15){ ret := bImm(12) ## bImm(10 downto 5) ## x0 ## rch ## B"001" ## bImm(4 downto 1) ## bImm(11) ## B"1100011" }
      is(16){ ret := B"0000000" ## i(6 downto 2) ## i(11 downto 7) ## B"001" ## i(11 downto 7) ## B"0010011"   }
      is(18){ ret := lwspImm ## x2 ## B"010" ## i(11 downto 7) ## B"0000011" }
      is(20) {
        val add = B"000_0000" ## i(6 downto 2) ## (i(12) ? i(11 downto 7) | x0) ## B"000" ## i(11 downto 7) ## B"0110011"   //add => add rd, rd, rs2  mv => add rd, x0, rs2
        val j =  B"0000_0000_0000" ## i(11 downto 7) ## B"000" ## (i(12) ? x1 | x0)  ## B"1100111"  //jr => jalr x0, rs1, 0.    jalr => jalr x1, rs1, 0.
        val ebreak = B"000000000001_00000_000_00000_1110011" //EBREAK
        val addJ = (i(6 downto 2) === 0) ? j | add
        ret := (i(12 downto 2) === B"100_0000_0000") ? ebreak | addJ
      }
      is(22){ ret := swspImm(11 downto 5) ## i(6 downto 2)  ## x2 ## B"010" ## swspImm(4 downto 0) ## B"0100011" }
    }

    ret
  }
}

class IBusSimplePlugin(interfaceKeepData : Boolean, catchAccessFault : Boolean, pendingMax : Int = 7) extends Plugin[VexRiscv] with JumpService with IBusFetcher{
  var iBus : IBusSimpleBus = null
  var prefetchExceptionPort : Flow[ExceptionCause] = null
  def resetVector = BigInt(0x80000000l)
  def keepPcPlus4 = false
  def decodePcGen = true
  def compressedGen = true
  assert(!(compressedGen && !decodePcGen))
  lazy val fetcherHalt = False
  lazy val decodeNextPcValid = Bool
  lazy val decodeNextPc = UInt(32 bits)
  def nextPc() = (decodeNextPcValid, decodeNextPc)

  override def haltIt(): Unit = fetcherHalt := True

  case class JumpInfo(interface :  Flow[UInt], stage: Stage, priority : Int)
  val jumpInfos = ArrayBuffer[JumpInfo]()
  override def createJumpInterface(stage: Stage, priority : Int = 0): Flow[UInt] = {
    val interface = Flow(UInt(32 bits))
    jumpInfos += JumpInfo(interface,stage, priority)
    interface
  }


  var decodeExceptionPort : Flow[ExceptionCause] = null
  override def setup(pipeline: VexRiscv): Unit = {
    iBus = master(IBusSimpleBus(interfaceKeepData)).setName("iBus")
    if(catchAccessFault) {
      val exceptionService = pipeline.service(classOf[ExceptionService])
      decodeExceptionPort = exceptionService.newExceptionPort(pipeline.decode,1).setName("iBusErrorExceptionnPort")
    }

    pipeline(RVC_GEN) = compressedGen
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new Area {

      //JumpService hardware implementation
      val jump = new Area {
        val sortedByStage = jumpInfos.sortWith((a, b) => {
          (pipeline.indexOf(a.stage) > pipeline.indexOf(b.stage)) ||
            (pipeline.indexOf(a.stage) == pipeline.indexOf(b.stage) && a.priority > b.priority)
        })
        val valids = sortedByStage.map(_.interface.valid)
        val pcs = sortedByStage.map(_.interface.payload)

        val pcLoad = Flow(UInt(32 bits))
        pcLoad.valid := jumpInfos.map(_.interface.valid).orR
        pcLoad.payload := MuxOH(OHMasking.first(valids.asBits), pcs)
      }


      def flush = jump.pcLoad.valid

      val fetchPc = new Area {
        val output = Stream(UInt(32 bits))

        //PC calculation without Jump
        val pcReg = Reg(UInt(32 bits)) init (resetVector) addAttribute (Verilator.public)
        val pcPlus4 = pcReg + 4
        if (keepPcPlus4) KeepAttribute(pcPlus4)
        when(output.fire) {
          pcReg := pcPlus4
        }

        //Realign
        if(compressedGen){
          when(output.fire){
            pcReg(1 downto 0) := 0
          }
        }

        //application of the selected jump request
        when(jump.pcLoad.valid) {
          pcReg := jump.pcLoad.payload
        }



        output.valid := (RegNext(True) init (False)) // && !jump.pcLoad.valid
        output.payload := pcReg
      }

      val decodePc = ifGen(decodePcGen)(new Area {
        //PC calculation without Jump
        val pcReg = Reg(UInt(32 bits)) init (resetVector) addAttribute (Verilator.public)
        val pcPlus = if(compressedGen)
          pcReg + ((decode.input(IS_RVC)) ? U(2) | U(4))
        else
          pcReg + 4

        if (keepPcPlus4) KeepAttribute(pcPlus)
        when(decode.arbitration.isFiring) {
          pcReg := pcPlus
        }

        //application of the selected jump request
        when(jump.pcLoad.valid) {
          pcReg := jump.pcLoad.payload
        }
      })


      val iBusCmd = new Area {
        def input = fetchPc.output

        val output = input.continueWhen(iBus.cmd.fire)

        //Avoid sending to many iBus cmd
        val pendingCmd = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
        val pendingCmdNext = pendingCmd + iBus.cmd.fire.asUInt - iBus.rsp.fire.asUInt
        pendingCmd := pendingCmdNext

        iBus.cmd.valid := input.valid && output.ready && pendingCmd =/= pendingMax
        iBus.cmd.pc := input.payload(31 downto 2) @@ "00"
      }

      case class FetchRsp() extends Bundle {
        val pc = UInt(32 bits)
        val rsp = IBusSimpleRsp()
        val isRvc = Bool
      }


      val iBusRsp = new Area {
        val input = iBusCmd.output.m2sPipe(flush)// ASYNC .throwWhen(flush)

        //Manage flush for iBus transactions in flight
        val discardCounter = Reg(UInt(log2Up(pendingMax + 1) bits)) init (0)
        discardCounter := discardCounter - (iBus.rsp.fire && discardCounter =/= 0).asUInt
        when(flush) {
          discardCounter := iBusCmd.pendingCmdNext
        }

        val rsp = iBus.rsp.throwWhen(discardCounter =/= 0).toStream.s2mPipe(flush)


        val fetchRsp = FetchRsp()
        fetchRsp.pc := input.payload
        fetchRsp.rsp := rsp.payload
        fetchRsp.rsp.error.clearWhen(!rsp.valid) //Avoid interference with instruction injection from the debug plugin


        val output = StreamJoin(Seq(input, rsp), fetchRsp)
      }

      val decompressor = ifGen(decodePcGen)(new Area{
        def input = iBusRsp.output
        val output = Stream(FetchRsp())

        val bufferValid = RegInit(False)
        val bufferError = Reg(Bool)
        val bufferData = Reg(Bits(16 bits))

        val raw = Mux(
          sel = bufferValid,
          whenTrue = input.rsp.inst(15 downto 0) ## bufferData,
          whenFalse = input.rsp.inst(31 downto 16) ## (input.pc(1) ? input.rsp.inst(31 downto 16) | input.rsp.inst(15 downto 0))
        )
        val isRvc = raw(1 downto 0) =/= 3
        val decompressed = RvcDecompressor(raw(15 downto 0))
        output.valid := isRvc ? (bufferValid || input.valid) | (input.valid && (bufferValid || !input.pc(1)))
        output.pc := input.pc
        output.isRvc := isRvc
        output.rsp.inst := isRvc ? decompressed | raw
        output.rsp.error := (bufferValid && bufferError) || (input.valid && input.rsp.error && (!isRvc || (isRvc && !bufferValid)))
        input.ready := (bufferValid ? (!isRvc && output.ready) | (input.pc(1) || output.ready))


        bufferValid clearWhen(output.fire)
        when(input.ready){
          when(input.valid) {
            bufferValid := !(!isRvc && !input.pc(1) && !bufferValid) && !(isRvc && input.pc(1))
          }
          bufferError := input.rsp.error
          bufferData := input.rsp.inst(31 downto 16)
        }
        bufferValid.clearWhen(flush)
      })

      val injector = new Area {
        val inputBeforeHalt = if(decodePcGen) decompressor.output else iBusRsp.output//.s2mPipe(flush)
        val input =  inputBeforeHalt.haltWhen(fetcherHalt)
        val stage = input.m2sPipe(flush || decode.arbitration.isRemoved)

        if(decodePcGen){
          decodeNextPcValid := True
          decodeNextPc := decodePc.pcReg
        }else {
          decodeNextPcValid := RegNext(inputBeforeHalt.isStall)
          decodeNextPc := decode.input(PC)
        }

        stage.ready := !decode.arbitration.isStuck
        decode.arbitration.isValid := stage.valid
        decode.insert(PC) := (if(decodePcGen) decodePc.pcReg else stage.pc)
        decode.insert(INSTRUCTION) := stage.rsp.inst
        decode.insert(INSTRUCTION_ANTICIPATED) := Mux(decode.arbitration.isStuck, decode.input(INSTRUCTION), input.rsp.inst)
        decode.insert(INSTRUCTION_READY) := True
        if(compressedGen) decode.insert(IS_RVC) := stage.isRvc

        if(catchAccessFault){
          decodeExceptionPort.valid := decode.arbitration.isValid && stage.rsp.error
          decodeExceptionPort.code  := 1
          decodeExceptionPort.badAddr := decode.input(PC)
        }
      }
    }
  }
}