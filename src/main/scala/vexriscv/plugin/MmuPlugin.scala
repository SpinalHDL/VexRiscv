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
  val redo = Bool()
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

class MmuPlugin(ioRange : UInt => Bool,
                virtualRange : UInt => Bool = address => True,
//                allowUserIo : Boolean = false,
                enableMmuInMachineMode : Boolean = false) extends Plugin[VexRiscv] with MemoryTranslator {

  var dBusAccess : DBusAccess = null
  val portsInfo = ArrayBuffer[MmuPort]()

  override def newTranslationPort(priority : Int,args : Any): MemoryTranslatorBus = {
    val port = MmuPort(MemoryTranslatorBus(),priority,args.asInstanceOf[MmuPortConfig], portsInfo.length)
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


    dBusAccess = pipeline.service(classOf[DBusAccessService]).newDBusAccess()
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._
    val csrService = pipeline.service(classOf[CsrInterface])

    //Sorted by priority
    val sortedPortsInfo = portsInfo.sortWith((a,b) => a.priority > b.priority)

    case class CacheLine() extends Bundle {
      val valid, exception, superPage = Bool
      val virtualAddress = Vec(UInt(10 bits), UInt(10 bits))
      val physicalAddress = Vec(UInt(10 bits), UInt(10 bits))
      val allowRead, allowWrite, allowExecute, allowUser = Bool

      def init = {
        valid init (False)
        this
      }
    }

    val csr = pipeline plug new Area{
      val status = new Area{
        val sum, mxr, mprv = RegInit(False)
      }
      val satp = new Area {
        val mode = RegInit(False)
        val ppn = Reg(UInt(20 bits))
      }

      for(offset <- List(CSR.MSTATUS, CSR.SSTATUS)) csrService.rw(offset, 19 -> status.mxr, 18 -> status.sum, 17 -> status.mprv)
      csrService.rw(CSR.SATP, 31 -> satp.mode, 0 -> satp.ppn)
    }

    val core = pipeline plug new Area {
      val ports = for (port <- sortedPortsInfo) yield new Area {
        val handle = port
        val id = port.id
        val cache = Vec(Reg(CacheLine()) init, port.args.portTlbSize)
        val cacheHits = cache.map(line => line.valid && line.virtualAddress(1) === port.bus.cmd.virtualAddress(31 downto 22) && (line.superPage || line.virtualAddress(0) === port.bus.cmd.virtualAddress(21 downto 12)))
        val cacheHit = cacheHits.asBits.orR
        val cacheLine = MuxOH(cacheHits, cache)
        val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())
        val entryToReplace = Counter(port.args.portTlbSize)
        val requireMmuLockup = virtualRange(port.bus.cmd.virtualAddress) && !port.bus.cmd.bypassTranslation && csr.satp.mode
        if(!enableMmuInMachineMode) {
          requireMmuLockup clearWhen(!csr.status.mprv && privilegeService.isMachine())
          when(privilegeService.isMachine()) {
            if (port.priority == MmuPort.PRIORITY_DATA) {
              requireMmuLockup clearWhen (!csr.status.mprv || pipeline(MPP) === 3)
            } else {
              requireMmuLockup := False
            }
          }
        }

        when(requireMmuLockup) {
          port.bus.rsp.physicalAddress := cacheLine.physicalAddress(1) @@ (cacheLine.superPage ? port.bus.cmd.virtualAddress(21 downto 12) | cacheLine.physicalAddress(0)) @@ port.bus.cmd.virtualAddress(11 downto 0)
          port.bus.rsp.allowRead := cacheLine.allowRead  || csr.status.mxr && cacheLine.allowExecute
          port.bus.rsp.allowWrite := cacheLine.allowWrite
          port.bus.rsp.allowExecute := cacheLine.allowExecute
          port.bus.rsp.exception := cacheHit && (cacheLine.exception || cacheLine.allowUser && privilegeService.isSupervisor() && !csr.status.sum || !cacheLine.allowUser && privilegeService.isUser())
          port.bus.rsp.refilling := !cacheHit
        } otherwise {
          port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress
          port.bus.rsp.allowRead := True
          port.bus.rsp.allowWrite := True
          port.bus.rsp.allowExecute := True
          port.bus.rsp.exception := False
          port.bus.rsp.refilling := False
        }
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)

        // Avoid keeping any invalid line in the cache after an exception.
        // https://github.com/riscv/riscv-linux/blob/8fe28cb58bcb235034b64cbbb7550a8a43fd88be/arch/riscv/include/asm/pgtable.h#L276
        when(service(classOf[IContextSwitching]).isContextSwitching) {
          for (line <- cache) {
            when(line.exception) {
              line.valid := False
            }
          }
        }
      }

      val shared = new Area {
        val State = new SpinalEnum{
          val IDLE, L1_CMD, L1_RSP, L0_CMD, L0_RSP = newElement()
        }
        val state = RegInit(State.IDLE)
        val vpn = Reg(Vec(UInt(10 bits), UInt(10 bits)))
        val portId = Reg(UInt(log2Up(portsInfo.length) bits))
        case class PTE() extends Bundle {
          val V, R, W ,X, U, G, A, D = Bool()
          val RSW = Bits(2 bits)
          val PPN0 = UInt(10 bits)
          val PPN1 = UInt(12 bits)
        }
        val dBusRsp = new Area{
          val pte = PTE()
          pte.assignFromBits(dBusAccess.rsp.data)
          val exception = !pte.V || (!pte.R && pte.W) || dBusAccess.rsp.error
          val leaf = pte.R || pte.X
        }

        val pteBuffer = RegNextWhen(dBusRsp.pte, dBusAccess.rsp.valid && !dBusAccess.rsp.redo)

        dBusAccess.cmd.valid := False
        dBusAccess.cmd.write := False
        dBusAccess.cmd.size := 2
        dBusAccess.cmd.address.assignDontCare()
        dBusAccess.cmd.data.assignDontCare()
        dBusAccess.cmd.writeMask.assignDontCare()
        switch(state){
          is(State.IDLE){
            for(port <- portsInfo.sortBy(_.priority)){
              when(port.bus.cmd.isValid && port.bus.rsp.refilling){
                vpn(1) := port.bus.cmd.virtualAddress(31 downto 22)
                vpn(0) := port.bus.cmd.virtualAddress(21 downto 12)
                portId := port.id
                state := State.L1_CMD
              }
            }
          }
          is(State.L1_CMD){
            dBusAccess.cmd.valid := True
            dBusAccess.cmd.address := csr.satp.ppn @@ vpn(1) @@ U"00"
            when(dBusAccess.cmd.ready){
              state := State.L1_RSP
            }
          }
          is(State.L1_RSP){
            when(dBusAccess.rsp.valid){
              state := State.L0_CMD
              when(dBusRsp.leaf || dBusRsp.exception){
                state := State.IDLE
              }
              when(dBusAccess.rsp.redo){
                state := State.L1_CMD
              }
            }
          }
          is(State.L0_CMD){
            dBusAccess.cmd.valid := True
            dBusAccess.cmd.address := pteBuffer.PPN1(9 downto 0) @@ pteBuffer.PPN0 @@ vpn(0) @@ U"00"
            when(dBusAccess.cmd.ready){
              state := State.L0_RSP
            }
          }
          is(State.L0_RSP){
            when(dBusAccess.rsp.valid) {
              state := State.IDLE
              when(dBusAccess.rsp.redo){
                state := State.L0_CMD
              }
            }
          }
        }

        for(port <- ports) {
          port.handle.bus.busy := state =/= State.IDLE && portId === port.id
        }

        when(dBusAccess.rsp.valid && !dBusAccess.rsp.redo && (dBusRsp.leaf || dBusRsp.exception)){
          for(port <- ports){
            when(portId === port.id) {
              port.entryToReplace.increment()
              for ((line, lineId) <- port.cache.zipWithIndex) {
                when(port.entryToReplace === lineId){
                  val superPage = state === State.L1_RSP
                  line.valid := True
                  line.exception := dBusRsp.exception || (superPage && dBusRsp.pte.PPN0 =/= 0)
                  line.virtualAddress := vpn
                  line.physicalAddress := Vec(dBusRsp.pte.PPN0, dBusRsp.pte.PPN1(9 downto 0))
                  line.allowRead := dBusRsp.pte.R
                  line.allowWrite := dBusRsp.pte.W
                  line.allowExecute := dBusRsp.pte.X
                  line.allowUser := dBusRsp.pte.U
                  line.superPage := state === State.L1_RSP
                }
              }
            }
          }
        }
      }
    }

    val fenceStage = stages.last
    fenceStage plug new Area{
      import fenceStage._
      when(arbitration.isValid && input(IS_SFENCE_VMA)){ // || csrService.isWriting(CSR.SATP)
        for(port <- core.ports; line <- port.cache) line.valid := False //Assume that the instruction already fetched into the pipeline are ok
      }
    }
  }
}
