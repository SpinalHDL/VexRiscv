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
case class MmuPort(bus : MemoryTranslatorBus, priority : Int, args : MmuPortConfig, id : Int)

case class MmuPortConfig(portTlbSize : Int, latency : Int = 0, earlyRequireMmuLockup : Boolean = false, earlyCacheHits : Boolean = false)

class MmuPlugin(ioRange : UInt => Bool,
                virtualRange : UInt => Bool = address => True,
//                allowUserIo : Boolean = false,
                enableMmuInMachineMode : Boolean = false) extends Plugin[VexRiscv] with MemoryTranslator {

  var dBusAccess : DBusAccess = null
  val portsInfo = ArrayBuffer[MmuPort]()

  override def newTranslationPort(priority : Int,args : Any): MemoryTranslatorBus = {
    val config = args.asInstanceOf[MmuPortConfig]
    val port = MmuPort(MemoryTranslatorBus(MemoryTranslatorBusParameter(wayCount = config.portTlbSize, latency = config.latency)),priority, config, portsInfo.length)
    portsInfo += port
    port.bus
  }

  object IS_SFENCE_VMA2 extends Stageable(Bool)
  override def setup(pipeline: VexRiscv): Unit = {
    import Riscv._
    import pipeline.config._
    val decoderService = pipeline.service(classOf[DecoderService])
    decoderService.addDefault(IS_SFENCE_VMA2, False)
    decoderService.add(SFENCE_VMA, List(IS_SFENCE_VMA2 -> True))


    dBusAccess = pipeline.service(classOf[DBusAccessService]).newDBusAccess()
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._
    val csrService = pipeline.service(classOf[CsrInterface])

    //Sorted by priority
    val sortedPortsInfo = portsInfo.sortBy(_.priority)

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
        val asid = Reg(Bits(9 bits))
        val ppn = Reg(UInt(20 bits))
      }

      for(offset <- List(CSR.MSTATUS, CSR.SSTATUS)) csrService.rw(offset, 19 -> status.mxr, 18 -> status.sum, 17 -> status.mprv)
      csrService.rw(CSR.SATP, 31 -> satp.mode, 22 -> satp.asid, 0 -> satp.ppn)
    }

    val core = pipeline plug new Area {
      val ports = for (port <- sortedPortsInfo) yield new Area {
        val handle = port
        val id = port.id
        val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())
        val cache = Vec(Reg(CacheLine()) init, port.args.portTlbSize)
        val dirty = RegInit(False).allowUnsetRegToAvoidLatch
        if(port.args.earlyRequireMmuLockup){
          dirty clearWhen(!port.bus.cmd.last.isStuck)
        }

        def toRsp[T <: Data](data : T, from : MemoryTranslatorCmd) : T = from match {
          case _ if from == port.bus.cmd.last => data
          case _ =>  {
            val next = port.bus.cmd.dropWhile(_ != from)(1)
            toRsp(RegNextWhen(data, !next.isStuck), next)
          }
        }
        val requireMmuLockupCmd = port.bus.cmd.takeRight(if(port.args.earlyRequireMmuLockup) 2 else 1).head

        val requireMmuLockupCalc = virtualRange(requireMmuLockupCmd.virtualAddress) && !requireMmuLockupCmd.bypassTranslation && csr.satp.mode
        if(!enableMmuInMachineMode) {
          requireMmuLockupCalc clearWhen(!csr.status.mprv && privilegeService.isMachine())
          when(privilegeService.isMachine()) {
            if (port.priority == MmuPort.PRIORITY_DATA) {
              requireMmuLockupCalc clearWhen (!csr.status.mprv || pipeline(MPP) === 3)
            } else {
              requireMmuLockupCalc := False
            }
          }
        }

        val cacheHitsCmd = port.bus.cmd.takeRight(if(port.args.earlyCacheHits) 2 else 1).head
        val cacheHitsCalc = B(cache.map(line => line.valid && line.virtualAddress(1) === cacheHitsCmd.virtualAddress(31 downto 22) && (line.superPage || line.virtualAddress(0) === cacheHitsCmd.virtualAddress(21 downto 12))))


        val requireMmuLockup = toRsp(requireMmuLockupCalc, requireMmuLockupCmd)
        val cacheHits = toRsp(cacheHitsCalc, cacheHitsCmd)

        val cacheHit = cacheHits.asBits.orR
        val cacheLine = MuxOH(cacheHits, cache)
        val entryToReplace = Counter(port.args.portTlbSize)


        when(requireMmuLockup) {
          port.bus.rsp.physicalAddress := cacheLine.physicalAddress(1) @@ (cacheLine.superPage ? port.bus.cmd.last.virtualAddress(21 downto 12) | cacheLine.physicalAddress(0)) @@ port.bus.cmd.last.virtualAddress(11 downto 0)
          port.bus.rsp.allowRead := cacheLine.allowRead  || csr.status.mxr && cacheLine.allowExecute
          port.bus.rsp.allowWrite := cacheLine.allowWrite
          port.bus.rsp.allowExecute := cacheLine.allowExecute
          port.bus.rsp.exception := !dirty &&  cacheHit && (cacheLine.exception || cacheLine.allowUser && privilegeService.isSupervisor() && !csr.status.sum || !cacheLine.allowUser && privilegeService.isUser())
          port.bus.rsp.refilling :=  dirty || !cacheHit
          port.bus.rsp.isPaging := True
        } otherwise {
          port.bus.rsp.physicalAddress := port.bus.cmd.last.virtualAddress
          port.bus.rsp.allowRead := True
          port.bus.rsp.allowWrite := True
          port.bus.rsp.allowExecute := True
          port.bus.rsp.exception := False
          port.bus.rsp.refilling := False
          port.bus.rsp.isPaging := False
        }
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)

        port.bus.rsp.bypassTranslation := !requireMmuLockup
        for(wayId <- 0 until port.args.portTlbSize){
          port.bus.rsp.ways(wayId).sel := cacheHits(wayId)
          port.bus.rsp.ways(wayId).physical := cache(wayId).physicalAddress(1) @@ (cache(wayId).superPage ? port.bus.cmd.last.virtualAddress(21 downto 12) | cache(wayId).physicalAddress(0)) @@ port.bus.cmd.last.virtualAddress(11 downto 0)
        }

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
        val portSortedOh = Reg(Bits(portsInfo.length bits))
        case class PTE() extends Bundle {
          val V, R, W ,X, U, G, A, D = Bool()
          val RSW = Bits(2 bits)
          val PPN0 = UInt(10 bits)
          val PPN1 = UInt(12 bits)
        }

        val dBusRspStaged = dBusAccess.rsp.stage()
        val dBusRsp = new Area{
          val pte = PTE()
          pte.assignFromBits(dBusRspStaged.data)
          val exception = !pte.V || (!pte.R && pte.W) || dBusRspStaged.error
          val leaf = pte.R || pte.X
        }

        val pteBuffer = RegNextWhen(dBusRsp.pte, dBusRspStaged.valid && !dBusRspStaged.redo)

        dBusAccess.cmd.valid := False
        dBusAccess.cmd.write := False
        dBusAccess.cmd.size := 2
        dBusAccess.cmd.address.assignDontCare()
        dBusAccess.cmd.data.assignDontCare()
        dBusAccess.cmd.writeMask.assignDontCare()

        val refills = OHMasking.last(B(ports.map(port => port.handle.bus.cmd.last.isValid && port.requireMmuLockup && !port.dirty && !port.cacheHit)))
        switch(state){
          is(State.IDLE){
            when(refills.orR){
              portSortedOh := refills
              state := State.L1_CMD
              val address = MuxOH(refills, sortedPortsInfo.map(_.bus.cmd.last.virtualAddress))
              vpn(1) := address(31 downto 22)
              vpn(0) := address(21 downto 12)
            }
//            for(port <- portsInfo.sortBy(_.priority)){
//              when(port.bus.cmd.isValid && port.bus.rsp.refilling){
//                vpn(1) := port.bus.cmd.virtualAddress(31 downto 22)
//                vpn(0) := port.bus.cmd.virtualAddress(21 downto 12)
//                portId := port.id
//                state := State.L1_CMD
//              }
//            }
          }
          is(State.L1_CMD){
            dBusAccess.cmd.valid := True
            dBusAccess.cmd.address := csr.satp.ppn @@ vpn(1) @@ U"00"
            when(dBusAccess.cmd.ready){
              state := State.L1_RSP
            }
          }
          is(State.L1_RSP){
            when(dBusRspStaged.valid){
              state := State.L0_CMD
              when(dBusRsp.leaf || dBusRsp.exception){
                state := State.IDLE
              }
              when(dBusRspStaged.redo){
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
            when(dBusRspStaged.valid) {
              state := State.IDLE
              when(dBusRspStaged.redo){
                state := State.L0_CMD
              }
            }
          }
        }

        for((port, id) <- sortedPortsInfo.zipWithIndex) {
          port.bus.busy := state =/= State.IDLE && portSortedOh(id)
        }

        when(dBusRspStaged.valid && !dBusRspStaged.redo && (dBusRsp.leaf || dBusRsp.exception)){
          for((port, id) <- ports.zipWithIndex) {
            when(portSortedOh(id)) {
              port.entryToReplace.increment()
              if(port.handle.args.earlyRequireMmuLockup) {
                port.dirty := True
              } //Avoid having non coherent TLB lookup
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

    val fenceStage = execute

    //Both SFENCE_VMA and SATP reschedule the next instruction in the CsrPlugin itself with one extra cycle to ensure side effect propagation.
    fenceStage plug new Area{
      import fenceStage._
      when(arbitration.isValid && arbitration.isFiring && input(IS_SFENCE_VMA2)){
        for(port <- core.ports; line <- port.cache) line.valid := False
      }

      csrService.onWrite(CSR.SATP){
        for(port <- core.ports; line <- port.cache) line.valid := False
      }
    }
  }
}
