package vexriscv.plugin

import spinal.core._

import vexriscv.VexRiscv
import vexriscv.Riscv.CSR._

import scala.collection.mutable._

trait CounterService{
  def getCondition(eventId : BigInt) : Bool
}

case class CounterPluginConfig(
      NumOfCounters         : Byte = 29,
      
      mcycleAccess          : CsrAccess = CsrAccess.READ_WRITE,
      ucycleAccess          : CsrAccess = CsrAccess.READ_ONLY,
      
      minstretAccess        : CsrAccess = CsrAccess.READ_WRITE,
      uinstretAccess        : CsrAccess = CsrAccess.READ_ONLY,

      mcounterenAccess      : CsrAccess = CsrAccess.READ_WRITE,
      scounterenAccess      : CsrAccess = CsrAccess.READ_WRITE,
      
      mcounterAccess        : CsrAccess = CsrAccess.READ_WRITE,
      ucounterAccess        : CsrAccess = CsrAccess.READ_ONLY,
      
      // management
      meventAccess          : CsrAccess = CsrAccess.READ_WRITE,
      mcounterinhibitAccess : CsrAccess = CsrAccess.READ_WRITE
    ) {
  assert(!ucycleAccess.canWrite)
}

class CounterPlugin(config : CounterPluginConfig) extends Plugin[VexRiscv] with CounterService {
  import config._

  def xlen = 32

  assert(NumOfCounters <= 29, "Cannot create more than 29 custom counters")
  assert(NumOfCounters >= 0, "Cannot create less than 0 custom counters")

//  counters  : Array[Reg] = null
//  event     : Array[Reg] = null
  
//  mcouen    : Reg = null
//  scouen    : Reg = null
  
//  inhibit   : Reg = null

  val eventType : Map[BigInt, Bool] = new HashMap()

  implicit class CsrAccessPimper(csrAccess : CsrAccess){
    import CsrAccess._
    def apply(csrService : CsrInterface, csrAddress : Int, thats : (Int, Data)*) : Unit = {
      if(csrAccess == `WRITE_ONLY` || csrAccess ==  `READ_WRITE`) for(that <- thats) csrService.w(csrAddress,that._1, that._2)
      if(csrAccess == `READ_ONLY`  || csrAccess ==  `READ_WRITE`) for(that <- thats) csrService.r(csrAddress,that._1, that._2)
    }
    def apply(csrService : CsrInterface, csrAddress : Int, that : Data) : Unit = {
      if(csrAccess == `WRITE_ONLY` || csrAccess ==  `READ_WRITE`) csrService.w(csrAddress, 0, that)
      if(csrAccess == `READ_ONLY`  || csrAccess ==  `READ_WRITE`) csrService.r(csrAddress, 0, that)
    }
  }

  override def getCondition(eventId : BigInt) : Bool = {
    if (!eventType.contains(eventId)) {
      eventType(eventId) = new Bool()
    }

    eventType(eventId)
  }

  override def build(pipeline : VexRiscv) : Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new Area{
      val csrService = pipeline.service(classOf[CsrInterface])

      // cycle
      val cycle = Reg(UInt(64 bits)) init(0)
      cycle := cycle + 1
      ucycleAccess(csrService, UCYCLE, cycle(31 downto 0))
      ucycleAccess(csrService, UCYCLEH, cycle(63 downto 32))
      mcycleAccess(csrService, MCYCLE, cycle(31 downto 0))
      mcycleAccess(csrService, MCYCLEH, cycle(63 downto 32))
      // instret
      val instret = Reg(UInt(64 bits)) init(0)
      when(pipeline.stages.last.arbitration.isFiring) {
        instret := instret + 1
      }
      uinstretAccess(csrService, UINSTRET, instret(31 downto 0))
      uinstretAccess(csrService, UINSTRETH, instret(63 downto 32))
      minstretAccess(csrService, MINSTRET, instret(31 downto 0))
      minstretAccess(csrService, MINSTRETH, instret(63 downto 32))

      // TODO counters
    }
  }
}
