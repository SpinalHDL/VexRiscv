package vexriscv.demo

import java.nio.{ByteBuffer, ByteOrder}

import spinal.core._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config, Apb3SlaveFactory}
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.misc.{HexTools, InterruptCtrl, Prescaler, Timer}
import spinal.lib._
import vexriscv.plugin.{DBusSimpleBus, IBusSimpleBus}

class MuraxMasterArbiter(simpleBusConfig : SimpleBusConfig) extends Component{
  val io = new Bundle{
    val iBus = slave(IBusSimpleBus(false))
    val dBus = slave(DBusSimpleBus())
    val masterBus = master(SimpleBus(simpleBusConfig))
  }

  io.masterBus.cmd.valid   := io.iBus.cmd.valid || io.dBus.cmd.valid
  io.masterBus.cmd.wr      := io.dBus.cmd.valid && io.dBus.cmd.wr
  io.masterBus.cmd.address := io.dBus.cmd.valid ? io.dBus.cmd.address | io.iBus.cmd.pc
  io.masterBus.cmd.data    := io.dBus.cmd.data
  io.masterBus.cmd.mask    := io.dBus.cmd.size.mux(
    0 -> B"0001",
    1 -> B"0011",
    default -> B"1111"
  ) |<< io.dBus.cmd.address(1 downto 0)
  io.iBus.cmd.ready := io.masterBus.cmd.ready && !io.dBus.cmd.valid
  io.dBus.cmd.ready := io.masterBus.cmd.ready


  val rspPending = RegInit(False) clearWhen(io.masterBus.rsp.valid)
  val rspTarget = RegInit(False)
  when(io.masterBus.cmd.fire && !io.masterBus.cmd.wr){
    rspTarget  := io.dBus.cmd.valid
    rspPending := True
  }

  when(rspPending && !io.masterBus.rsp.valid){
    io.iBus.cmd.ready := False
    io.dBus.cmd.ready := False
    io.masterBus.cmd.valid := False
  }

  io.iBus.rsp.valid := io.masterBus.rsp.valid && !rspTarget
  io.iBus.rsp.inst  := io.masterBus.rsp.data
  io.iBus.rsp.error := False

  io.dBus.rsp.ready := io.masterBus.rsp.valid && rspTarget
  io.dBus.rsp.data  := io.masterBus.rsp.data
  io.dBus.rsp.error := False
}


case class MuraxSimpleBusRam(onChipRamSize : BigInt, onChipRamHexFile : String, simpleBusConfig : SimpleBusConfig) extends Component{
  val io = new Bundle{
    val bus = slave(SimpleBus(simpleBusConfig))
  }

  val ram = Mem(Bits(32 bits), onChipRamSize / 4)
  io.bus.rsp.valid := RegNext(io.bus.cmd.fire && !io.bus.cmd.wr) init(False)
  io.bus.rsp.data := ram.readWriteSync(
    address = (io.bus.cmd.address >> 2).resized,
    data  = io.bus.cmd.data,
    enable  = io.bus.cmd.valid,
    write  = io.bus.cmd.wr,
    mask  = io.bus.cmd.mask
  )
  io.bus.cmd.ready := True

  if(onChipRamHexFile != null){
    HexTools.initRam(ram, onChipRamHexFile, 0x80000000l)
  }
}



case class Apb3Rom(onChipRamBinFile : String) extends Component{
  import java.nio.file.{Files, Paths}
  val byteArray = Files.readAllBytes(Paths.get(onChipRamBinFile))
  val wordCount = (byteArray.length+3)/4
  val buffer = ByteBuffer.wrap(Files.readAllBytes(Paths.get(onChipRamBinFile))).order(ByteOrder.LITTLE_ENDIAN);
  val wordArray = (0 until wordCount).map(i => {
    val v = buffer.getInt
    if(v < 0)  BigInt(v.toLong & 0xFFFFFFFFl) else  BigInt(v)
  })

  val io = new Bundle{
    val apb = slave(Apb3(log2Up(wordCount*4),32))
  }

  val rom = Mem(Bits(32 bits), wordCount) initBigInt(wordArray)
//  io.apb.PRDATA := rom.readSync(io.apb.PADDR >> 2)
  io.apb.PRDATA := rom.readAsync(RegNext(io.apb.PADDR >> 2))
  io.apb.PREADY := True
}

class MuraxSimpleBusToApbBridge(apb3Config: Apb3Config, pipelineBridge : Boolean, simpleBusConfig : SimpleBusConfig) extends Component{
  assert(apb3Config.dataWidth == simpleBusConfig.dataWidth)

  val io = new Bundle {
    val simpleBus = slave(SimpleBus(simpleBusConfig))
    val apb = master(Apb3(apb3Config))
  }

  val simpleBusStage = SimpleBus(simpleBusConfig)
  simpleBusStage.cmd << (if(pipelineBridge) io.simpleBus.cmd.halfPipe() else io.simpleBus.cmd)
  simpleBusStage.rsp >-> io.simpleBus.rsp

  val state = RegInit(False)
  simpleBusStage.cmd.ready := False

  io.apb.PSEL(0) := simpleBusStage.cmd.valid
  io.apb.PENABLE := state
  io.apb.PWRITE  := simpleBusStage.cmd.wr
  io.apb.PADDR   := simpleBusStage.cmd.address.resized
  io.apb.PWDATA  := simpleBusStage.cmd.data

  simpleBusStage.rsp.valid := False
  simpleBusStage.rsp.data  := io.apb.PRDATA
  when(!state) {
    state := simpleBusStage.cmd.valid
  } otherwise {
    when(io.apb.PREADY){
      state := False
      simpleBusStage.rsp.valid := !simpleBusStage.cmd.wr
      simpleBusStage.cmd.ready := True
    }
  }
}

class MuraxSimpleBusDecoder(master : SimpleBus, val specification : Seq[(SimpleBus,SizeMapping)], pipelineMaster : Boolean) extends Area{
  val masterPipelined = SimpleBus(master.config)
  if(!pipelineMaster) {
    masterPipelined.cmd << master.cmd
    masterPipelined.rsp >> master.rsp
  } else {
    masterPipelined.cmd <-< master.cmd
    masterPipelined.rsp >> master.rsp
  }

  val slaveBuses = specification.map(_._1)
  val memorySpaces = specification.map(_._2)

  val hits = for((slaveBus, memorySpace) <- specification) yield {
    val hit = memorySpace.hit(masterPipelined.cmd.address)
    slaveBus.cmd.valid   := masterPipelined.cmd.valid && hit
    slaveBus.cmd.payload := masterPipelined.cmd.payload.resized
    hit
  }
  val noHit = !hits.orR
  masterPipelined.cmd.ready := (hits,slaveBuses).zipped.map(_ && _.cmd.ready).orR || noHit

  val rspPending  = RegInit(False) clearWhen(masterPipelined.rsp.valid) setWhen(masterPipelined.cmd.fire && !masterPipelined.cmd.wr)
  val rspNoHit    = RegNext(False) init(False) setWhen(noHit)
  val rspSourceId = RegNextWhen(OHToUInt(hits), masterPipelined.cmd.fire)
  masterPipelined.rsp.valid   := slaveBuses.map(_.rsp.valid).orR || (rspPending && rspNoHit)
  masterPipelined.rsp.payload := slaveBuses.map(_.rsp.payload).read(rspSourceId)

  when(rspPending && !masterPipelined.rsp.valid) { //Only one pending read request is allowed
    masterPipelined.cmd.ready := False
    slaveBuses.foreach(_.cmd.valid := False)
  }
}

class MuraxApb3Timer extends Component{
  val io = new Bundle {
    val apb = slave(Apb3(
      addressWidth = 8,
      dataWidth = 32
    ))
    val interrupt = out Bool
  }

  val prescaler = Prescaler(16)
  val timerA,timerB = Timer(16)

  val busCtrl = Apb3SlaveFactory(io.apb)
  val prescalerBridge = prescaler.driveFrom(busCtrl,0x00)

  val timerABridge = timerA.driveFrom(busCtrl,0x40)(
    ticks  = List(True, prescaler.io.overflow),
    clears = List(timerA.io.full)
  )

  val timerBBridge = timerB.driveFrom(busCtrl,0x50)(
    ticks  = List(True, prescaler.io.overflow),
    clears = List(timerB.io.full)
  )

  val interruptCtrl = InterruptCtrl(2)
  val interruptCtrlBridge = interruptCtrl.driveFrom(busCtrl,0x10)
  interruptCtrl.io.inputs(0) := timerA.io.full
  interruptCtrl.io.inputs(1) := timerB.io.full
  io.interrupt := interruptCtrl.io.pendings.orR
}
