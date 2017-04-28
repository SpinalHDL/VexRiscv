package SpinalRiscv.Plugin

import SpinalRiscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer
case class MemoryTranslatorPort(bus : MemoryTranslatorBus, stage : Stage, cacheSize : Int, exceptionBus: Flow[ExceptionCause])

class MemoryTranslatorPlugin(tlbSize : Int, exceptionCode : Int, mmuRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator {
  assert(isPow2(tlbSize))

  val portsInfo = ArrayBuffer[MemoryTranslatorPort]()

  override def newTranslationPort(stage : Stage,cacheSize : Int): MemoryTranslatorBus = {
    val exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(stage)
    val port = MemoryTranslatorPort(MemoryTranslatorBus(),stage,cacheSize,exceptionBus)
    portsInfo += port
    port.bus
  }

  object IS_TLB extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    def TLBW0  = M"0000000----------000-----0101011"
    def TLBW1  = M"0000000----------001-----0101011"
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(IS_TLB, False)
    decoderService.add(TLBW0, List(IS_TLB -> True, REG1_USE -> True, SRC1_CTRL -> Src1CtrlEnum.RS))
    decoderService.add(TLBW1, List(IS_TLB -> True, REG1_USE -> True, REG2_USE -> True, SRC1_CTRL -> Src1CtrlEnum.RS))
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._

    //Sorted by priority
    val sortedPortsInfo = portsInfo.sortWith((a,b) => indexOf(a.stage) > indexOf(b.stage))

    case class CacheLine() extends Bundle {
      val valid = Bool
      val virtualAddress = UInt(20 bits)
      val physicalAddress = UInt(20 bits)
      val allowRead, allowWrite, allowExecute = Bool

      def init = {
        valid init (False)
        this
      }
    }

    val core = pipeline plug new Area {
      val shared = new Area {
        val cache = Mem(CacheLine(), tlbSize)
        val cmd = Stream(UInt(log2Up(sortedPortsInfo.length) bits))
        val rsp = new Bundle {
          val portId = UInt()
          val hit = Bool
          val line = CacheLine()
        }

        val cmdVirtualAddress = RegNext(sortedPortsInfo.map(_.bus).read(cmd.payload).cmd.virtualAddress(31 downto 12))
        val ptr = Counter(tlbSize)
        val setup = RegNext(False) init (False)
        val last = RegNext(ptr.willOverflowIfInc)
        rsp.portId := RegNext(cmd.payload)
        rsp.line := cache.readSync(ptr)
        rsp.hit := rsp.line.valid && rsp.line.virtualAddress === cmdVirtualAddress
        cmd.ready := !setup && (rsp.hit || last)

        when(cmd.valid) {
          ptr.increment()
        }

        when(!cmd.valid || cmd.ready || sortedPortsInfo.map(_.stage.arbitration.removeIt).read(cmd.payload)) {
          ptr.clear()
          last := False
          setup := True
        }
      }


      val ports = for ((port, portId) <- sortedPortsInfo.zipWithIndex) yield new Area {
        val cache = Vec(Reg(CacheLine()) init, port.cacheSize)
        val entryToReplace = Counter(port.cacheSize)

        val sharedMiss = RegInit(False)
        when(shared.cmd.fire && shared.rsp.portId === portId) {
          cache(entryToReplace) := shared.rsp.line  //TODO FMAX pipelining
          sharedMiss := !shared.rsp.hit
          entryToReplace.increment()
        }
        sharedMiss clearWhen (!port.stage.arbitration.isStuck)

        val sharedRequest = Stream(UInt(log2Up(sortedPortsInfo.length) bits))
        sharedRequest.valid   := False
        sharedRequest.payload := portId

        port.exceptionBus.valid   := False
        port.exceptionBus.code    := exceptionCode
        port.exceptionBus.badAddr := port.bus.cmd.virtualAddress

        val cacheHits = cache.map(line => line.valid && line.virtualAddress === port.bus.cmd.virtualAddress(31 downto 12))
        val cacheHit = cacheHits.asBits.orR
        val cacheLine = MuxOH(cacheHits, cache)
        val isInMmuRange = mmuRange(port.bus.cmd.virtualAddress)

        when(isInMmuRange) {
          port.bus.rsp.physicalAddress := cacheLine.physicalAddress @@ port.bus.cmd.virtualAddress(11 downto 0)
          port.bus.rsp.allowRead := cacheLine.allowRead
          port.bus.rsp.allowWrite := cacheLine.allowWrite
          port.bus.rsp.allowExecute := cacheLine.allowExecute
          port.stage.arbitration.haltIt setWhen (port.bus.cmd.isValid && !cacheHit)
          port.exceptionBus.valid   := sharedMiss
          sharedRequest.valid := port.bus.cmd.isValid && !cacheHit && !sharedMiss
        } otherwise {
          port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress
          port.bus.rsp.allowRead := True
          port.bus.rsp.allowWrite := True
          port.bus.rsp.allowExecute := True
        }
      }

      shared.cmd << StreamArbiterFactory.lowerFirst.noLock.on(ports.map(_.sharedRequest))
    }

    //Manage TLBW0 and TLBW1 instructions
    execute plug new Area{
      import execute._
      val tlbWriteBuffer = Reg(UInt(20 bits))
      when(arbitration.isFiring && input(IS_TLB)){
        switch(input(INSTRUCTION)(funct3Range)){
          is(0){
            tlbWriteBuffer := input(SRC1).asUInt.resized
          }
          is(1){
            val line = CacheLine()
            line.virtualAddress := tlbWriteBuffer
            line.physicalAddress := input(REG2)(19 downto 0).asUInt
            line.valid := input(REG2)(31)
            line.allowRead := input(REG2)(28)
            line.allowWrite := input(REG2)(29)
            line.allowExecute := input(REG2)(30)
            core.shared.cache(input(SRC1)(log2Up(tlbSize)-1 downto 0).asUInt) := line

            core.ports.foreach(_.cache.foreach(_.valid := False)) //Invalidate all ports caches
          }
        }
      }
    }
  }
}
