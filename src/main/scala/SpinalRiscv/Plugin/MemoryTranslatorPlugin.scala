package SpinalRiscv.Plugin

import SpinalRiscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer
case class MemoryTranslatorPort(bus : MemoryTranslatorBus, stage : Stage, args : MemoryTranslatorPortConfig/*, exceptionBus: Flow[ExceptionCause]*/)

case class MemoryTranslatorPortConfig(portTlbSize : Int)

class MemoryTranslatorPlugin(tlbSize : Int,
                             virtualRange : UInt => Bool,
                             ioRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator {
  assert(isPow2(tlbSize))

  val portsInfo = ArrayBuffer[MemoryTranslatorPort]()

  override def newTranslationPort(stage : Stage,args : Any): MemoryTranslatorBus = {
//    val exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(stage)
    val port = MemoryTranslatorPort(MemoryTranslatorBus(),stage,args.asInstanceOf[MemoryTranslatorPortConfig]/*,exceptionBus*/)
    portsInfo += port
    port.bus
  }

  object IS_TLB extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    def TLBW0  = M"0000000----------111-----0001111"
    def TLBW1  = M"0000001----------111-----0001111"
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
      val allowRead, allowWrite, allowExecute, allowUser = Bool

      def init = {
        valid init (False)
        this
      }
    }

    val core = pipeline plug new Area {
      val shared = new Area {
        val cache = Mem(CacheLine(), tlbSize)
        var free = True
        val readAddr = cache.addressType.assignDontCare()
        val readData = RegNext(cache.readSync(readAddr))
      }

      val ports = for ((port, portId) <- sortedPortsInfo.zipWithIndex) yield new Area {
        val cache = Vec(Reg(CacheLine()) init, port.args.portTlbSize)
        val cacheHits = cache.map(line => line.valid && line.virtualAddress === port.bus.cmd.virtualAddress(31 downto 12))
        val cacheHit = cacheHits.asBits.orR
        val cacheLine = MuxOH(cacheHits, cache)
        val isInMmuRange = virtualRange(port.bus.cmd.virtualAddress) && !port.bus.cmd.bypassTranslation

        val sharedMiss = RegInit(False)
        val sharedIterator = Reg(UInt(log2Up(tlbSize + 1) bits))
        val sharedAccessed = RegInit(B"00")
        val entryToReplace = Counter(port.args.portTlbSize)

        val sharedAccessAsked = RegNext(port.bus.cmd.isValid && !cacheHit && sharedIterator < tlbSize && isInMmuRange)
        val sharedAccessGranted = sharedAccessAsked && shared.free
        when(sharedAccessGranted) {
          shared.readAddr := sharedIterator.resized
          sharedIterator := sharedIterator + 1
        }
        sharedAccessed := (sharedAccessed ## sharedAccessGranted).resized
        when(sharedAccessAsked){
          shared.free \= False
        }

        when(sharedAccessed.msb){
          when(shared.readData.virtualAddress === port.bus.cmd.virtualAddress(31 downto 12)){
            cache(entryToReplace) := shared.readData
            entryToReplace.increment()
          }
        }

        sharedMiss.setWhen(sharedIterator >= tlbSize && sharedAccessed === B"00")
        when(!port.stage.arbitration.isStuck){
          sharedIterator := 0
          sharedMiss.clear()
          sharedAccessAsked.clear()
          sharedAccessed := 0
        }


        when(isInMmuRange) {
          port.bus.rsp.physicalAddress := cacheLine.physicalAddress @@ port.bus.cmd.virtualAddress(11 downto 0)
          port.bus.rsp.allowRead := cacheLine.allowRead
          port.bus.rsp.allowWrite := cacheLine.allowWrite
          port.bus.rsp.allowExecute := cacheLine.allowExecute
          port.bus.rsp.allowUser := cacheLine.allowUser
          port.stage.arbitration.haltIt setWhen (port.bus.cmd.isValid && !cacheHit && !sharedMiss)
        } otherwise {
          port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress
          port.bus.rsp.allowRead := True
          port.bus.rsp.allowWrite := True
          port.bus.rsp.allowExecute := True
          port.bus.rsp.allowUser := True
        }
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.miss := sharedMiss
      }
    }

    //Manage TLBW0 and TLBW1 instructions
    execute plug new Area{
      import execute._
      val tlbWriteBuffer = Reg(UInt(20 bits))
      when(arbitration.isFiring && input(IS_TLB)){
        switch(input(INSTRUCTION)(25 downto 25)){
          is(0){
            tlbWriteBuffer := input(SRC1).asUInt.resized
          }
          is(1){
            val line = CacheLine()
            line.virtualAddress := tlbWriteBuffer
            line.physicalAddress := input(REG2)(19 downto 0).asUInt
            line.allowUser := input(REG2)(27)
            line.allowRead := input(REG2)(28)
            line.allowWrite := input(REG2)(29)
            line.allowExecute := input(REG2)(30)
            line.valid := input(REG2)(31)
            core.shared.cache(input(SRC1)(log2Up(tlbSize)-1 downto 0).asUInt) := line

            core.ports.foreach(_.cache.foreach(_.valid := False)) //Invalidate all ports caches
          }
        }
      }
    }
  }
}
