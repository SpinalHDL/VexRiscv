package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer

trait DBusAccessService{
  def newDBusAccess() : DBusAccess
}

case class DBusAccessCmd() extends Bundle {
  val address = UInt(32 bits)
  val size = UInt(2 bits)
  val write = Bool
  val data = Bits(32 bits)
  val writeMask = Bits(4 bits)
}

case class DBusAccessRsp() extends Bundle {
  val data = Bits(32 bits)
  val error = Bool()
}

case class DBusAccess() extends Bundle {
  val cmd = Stream(DBusAccessCmd())
  val rsp = Flow(DBusAccessRsp())
}


object MmuPort{
  val PRIORITY_DATA = 1
  val PRIORITY_INSTRUCTION = 0
}
case class MmuPort(bus : MemoryTranslatorBus, priority : Int, args : MmuPortConfig, id : Int/*, exceptionBus: Flow[ExceptionCause]*/)

case class MmuPortConfig(portTlbSize : Int)

class MmuPlugin(virtualRange : UInt => Bool,
                ioRange : UInt => Bool,
                allowUserIo : Boolean) extends Plugin[VexRiscv] with MemoryTranslator {

  var dBus : DBusAccess = null
  val portsInfo = ArrayBuffer[MmuPort]()

  override def newTranslationPort(priority : Int,args : Any): MemoryTranslatorBus = {
//    val exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(stage)
    val port = MmuPort(MemoryTranslatorBus(),priority,args.asInstanceOf[MmuPortConfig], portsInfo.length /*,exceptionBus*/)
    portsInfo += port
    port.bus
  }

  object IS_SFENCE_VMA extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(IS_SFENCE_VMA, False)
    decoderService.add(SFENCE_VMA, List(IS_SFENCE_VMA -> True))


    dBus = pipeline.service(classOf[DBusAccessService]).newDBusAccess()
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._
    val csrService = pipeline.service(classOf[CsrInterface])

    //Sorted by priority
    val sortedPortsInfo = portsInfo.sortWith((a,b) => a.priority > b.priority)

    case class CacheLine() extends Bundle {
      val valid, exception = Bool
      val virtualAddress = UInt(20 bits)
      val physicalAddress = UInt(20 bits)
      val allowRead, allowWrite, allowExecute, allowUser = Bool

      def init = {
        valid init (False)
        this
      }
    }

    val core = pipeline plug new Area {
      val ports = for (port <- sortedPortsInfo) yield new Area {
        val id = port.id
        val cache = Vec(Reg(CacheLine()) init, port.args.portTlbSize)
        val cacheHits = cache.map(line => line.valid && line.virtualAddress === port.bus.cmd.virtualAddress(31 downto 12))
        val cacheHit = cacheHits.asBits.orR
        val cacheLine = MuxOH(cacheHits, cache)
        val isInMmuRange = virtualRange(port.bus.cmd.virtualAddress) && !port.bus.cmd.bypassTranslation
        val entryToReplace = Counter(port.args.portTlbSize)


        when(isInMmuRange) {
          port.bus.rsp.physicalAddress := cacheLine.physicalAddress @@ port.bus.cmd.virtualAddress(11 downto 0)
          port.bus.rsp.allowRead := cacheLine.allowRead
          port.bus.rsp.allowWrite := cacheLine.allowWrite
          port.bus.rsp.allowExecute := cacheLine.allowExecute
          port.bus.rsp.allowUser := cacheLine.allowUser
          port.bus.rsp.exception := cacheHit && cacheLine.exception
          port.bus.rsp.refilling := !cacheHit

        } otherwise {
          port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress
          port.bus.rsp.allowRead := True
          port.bus.rsp.allowWrite := True
          port.bus.rsp.allowExecute := True
          port.bus.rsp.allowUser := Bool(allowUserIo)
          port.bus.rsp.exception := False
          port.bus.rsp.refilling := False
        }
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
      }

      val shared = new Area {
        val busy = Reg(Bool) init(False)

        val satp = new Bundle {
          val mode = Bool()
          val ppn = UInt(20 bits)
        }
        csrService.rw(CSR.SATP, 31 -> satp.mode, 0 -> satp.ppn)  //TODO write only ?
        val State = new SpinalEnum{
          val IDLE, L1_CMD, L1_RSP, L0_CMD, L0_RSP = newElement()
        }
        val state = RegInit(State.IDLE)
        val vpn1, vpn0 = Reg(UInt(10 bits))
        val portId = Reg(UInt(log2Up(portsInfo.length) bits))
        case class PTE() extends Bundle {
          val V, R, W ,X, U, G, A, D = Bool()
          val RSW = Bits(2 bits)
          val PPN0 = UInt(10 bits)
          val PPN1 = UInt(12 bits)
        }
        val dBusRsp = new Area{
          val pte = PTE()
          pte.assignFromBits(dBus.rsp.data)
          val exception = !pte.V || (!pte.R && pte.W) || dBus.rsp.error
          val leaf = pte.R || pte.X
        }

        val pteBuffer = RegNextWhen(dBusRsp.pte, dBus.rsp.valid)

        dBus.cmd.write := False
        dBus.cmd.size := 2
        dBus.cmd.address.assignDontCare()
        dBus.cmd.data.assignDontCare()
        dBus.cmd.writeMask.assignDontCare()
        switch(state){
          is(State.IDLE){
            for(port <- portsInfo.sortBy(_.priority)){
              when(port.bus.cmd.isValid && port.bus.rsp.refilling){
                busy := True
                vpn1 := port.bus.cmd.virtualAddress(31 downto 22)
                vpn0 := port.bus.cmd.virtualAddress(21 downto 12)
                portId := port.id
                state := State.L1_CMD
              }
            }
          }
          is(State.L1_CMD){
            dBus.cmd.valid := True
            dBus.cmd.address := satp.ppn @@ vpn1 @@ U"00"
            when(dBus.cmd.ready){
              state := State.L1_RSP
            }
          }
          is(State.L1_RSP){
            when(dBus.rsp.valid){
              when(dBusRsp.leaf || dBusRsp.exception){
                state := State.IDLE
              } otherwise {
                state := State.L0_CMD
              }
            }
          }
          is(State.L0_CMD){
            dBus.cmd.valid := True
            dBus.cmd.address := pteBuffer.PPN1(9 downto 0) @@ pteBuffer.PPN0 @@ vpn0 @@ U"00"
            when(dBus.cmd.ready){
              state := State.L0_RSP
            }
          }
          is(State.L0_RSP){
            when(dBus.rsp.valid) {
              state := State.IDLE
            }
          }
        }

        when(dBus.rsp.valid && (dBusRsp.leaf || dBusRsp.exception)){
          for(port <- ports){
            when(portId === port.id) {
              port.entryToReplace.increment()
              for ((line, lineId) <- port.cache.zipWithIndex) {
                when(port.entryToReplace === lineId){
                  line.valid := True
                  line.exception := dBusRsp.exception
                  line.virtualAddress := vpn1 @@ vpn0
                  line.physicalAddress := dBusRsp.pte.PPN1(9 downto 0) @@ dBusRsp.pte.PPN0
                  line.allowRead := dBusRsp.pte.R
                  line.allowWrite := dBusRsp.pte.W
                  line.allowExecute := dBusRsp.pte.X
                  line.allowUser := dBusRsp.pte.U
                }
              }
            }
          }
        }
      }
    }

    execute plug new Area{
      import execute._
      val tlbWriteBuffer = Reg(UInt(20 bits))
      when(arbitration.isFiring && input(IS_SFENCE_VMA)){
        for(port <- core.ports; line <- port.cache) line.valid := False //Assume that the instruction already fetched into the pipeline are ok
      }
    }
  }
}
