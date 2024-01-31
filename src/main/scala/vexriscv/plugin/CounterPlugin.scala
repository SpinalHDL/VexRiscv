package vexriscv.plugin

import spinal.core._

import vexriscv._
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

      utimeAccess           : CsrAccess = CsrAccess.READ_ONLY,

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

object Priv{
  val M = 3
  val S = 1
  val U = 0
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

  var time : UInt = null

  implicit class PrivilegeHelper(p : PrivilegeService){
    def canMachine() : Bool = p.isMachine()
    def canSupervisor() : Bool = p.isMachine() || p.isSupervisor()
  }

  implicit class CsrAccessHelper(csrAccess : CsrAccess){
    import CsrAccess._
    import Priv._
    def apply(csrService : CsrInterface, csrAddress : Int, that : Data) : Unit = {
      if(csrAccess == `WRITE_ONLY` || csrAccess ==  `READ_WRITE`) csrService.w(csrAddress, 0, that)
      if(csrAccess == `READ_ONLY`  || csrAccess ==  `READ_WRITE`) csrService.r(csrAddress, 0, that)
    }
    def apply(
      csrSrv : CsrInterface,
      prvSrv : PrivilegeService,
      csrAddress : Int,
      that : Data,
      privAllows : (Int, Bool)*
    ) : Unit = {
      apply(csrSrv, csrAddress, that)
      if(csrAccess != CsrAccess.NONE) csrSrv.during(csrAddress){
        for (ii <- privAllows) {
          if (ii._1 == M)
            when (~prvSrv.canMachine() || ~ii._2) { csrSrv.forceFailCsr() }
          if (ii._1 == S && prvSrv.hasSupervisor())
            when (~prvSrv.canSupervisor() || ~ii._2) { csrSrv.forceFailCsr() }
          if (prvSrv.hasUser())
            when (~ii._2) { csrSrv.forceFailCsr() }
        }
      }
    }
  }

  override def getCondition(eventId : BigInt) : Bool = {
    if (!eventType.contains(eventId)) {
      eventType(eventId) = new Bool()
    }

    eventType(eventId)
  }

  override def setup(pipeline : VexRiscv) : Unit = {
    import pipeline._
    import pipeline.config._

    if (utimeAccess != CsrAccess.NONE) time = in UInt(64 bits) setName("utime")
  }

  override def build(pipeline : VexRiscv) : Unit = {
    import pipeline._
    import pipeline.config._

    pipeline plug new Area{
      val csrSrv = pipeline.service(classOf[CsrInterface])
      val dbgSrv = pipeline.service(classOf[DebugService])
      val prvSrv = pipeline.service(classOf[PrivilegeService])

      val dbgCtrEn = ~(dbgSrv.inDebugMode() && dbgSrv.debugState().dcsr.stopcount)

      val cycle = Reg(UInt(64 bits)) init(0)
      cycle := cycle + U(dbgCtrEn)
      val instret = Reg(UInt(64 bits)) init(0)
      when(pipeline.stages.last.arbitration.isFiring) {
        instret := instret + U(dbgCtrEn)
      }
      
      val menable = RegInit(Bits(3 + NumOfCounters bits).getAllTrue)
      val senable = RegInit(Bits(3 + NumOfCounters bits).getAllTrue)
      
      val expose = new Area {
        import Priv._
        // enable
        mcounterenAccess(csrSrv, prvSrv, MCOUNTEREN, menable.resize(32), S -> False, U -> False)
        scounterenAccess(csrSrv, prvSrv, SCOUNTEREN, senable.resize(32), U -> False)

        // fixed counters
        ucycleAccess(csrSrv, prvSrv, UCYCLE,  cycle(31 downto 0),
          S -> menable(0),
          U -> (if (prvSrv.hasSupervisor()) senable(0) else True),
          U -> menable(0)
        )
        ucycleAccess(csrSrv, prvSrv, UCYCLEH, cycle(63 downto 32),
          S -> menable(0),
          U -> (if (prvSrv.hasSupervisor()) senable(0) else True),
          U -> menable(0)
        )
        
        mcycleAccess(csrSrv, prvSrv, MCYCLE,  cycle(31 downto 0),  S -> False, U -> False)
        mcycleAccess(csrSrv, prvSrv, MCYCLEH, cycle(63 downto 32), S -> False, U -> False)

        utimeAccess(csrSrv, prvSrv, UTIME, time(31 downto 0),
          S -> menable(1),
          U -> (if (prvSrv.hasSupervisor()) senable(1) else True),
          U -> menable(1)
        )
        utimeAccess(csrSrv, prvSrv, UTIMEH, time(63 downto 32),
          S -> menable(1),
          U -> (if (prvSrv.hasSupervisor()) senable(1) else True),
          U -> menable(1)
        )
        
        uinstretAccess(csrSrv, prvSrv, UINSTRET, instret(31 downto 0),
          S -> menable(2),
          U -> (if (prvSrv.hasSupervisor()) senable(2) else True),
          U -> menable(2)
        )
        uinstretAccess(csrSrv, prvSrv, UINSTRETH, instret(63 downto 32),
          S -> menable(2),
          U -> (if (prvSrv.hasSupervisor()) senable(2) else True),
          U -> menable(2)
        )

        minstretAccess(csrSrv, prvSrv, MINSTRET,  instret(31 downto 0),  S -> False, U -> False)
        minstretAccess(csrSrv, prvSrv, MINSTRETH, instret(63 downto 32), S -> False, U -> False)
      }

      // TODO counters
    }
  }
}
