package vexriscv

import java.io.File

import org.scalatest.{FunSuite}
import vexriscv.demo._

import scala.sys.process._

class DhrystoneBench extends FunSuite{
  def doCmd(cmd : String) : String = {
    val stdOut = new StringBuilder()
    class Logger extends ProcessLogger {override def err(s: => String): Unit = {if(!s.startsWith("ar: creating ")) println(s)}
      override def out(s: => String): Unit = {
        println(s)
        stdOut ++= s
      }
      override def buffer[T](f: => T) = f
    }
    Process(cmd, new File("src/test/cpp/regression")).!(new Logger)
    stdOut.toString()
  }
  val report = new StringBuilder()
  def getDmips(name : String, gen : => Unit, testCmd : String): Unit = {
    var genPassed = false
    test(name + "_gen") {
      gen
      genPassed = true
    }
    test(name + "_test"){
      assert(genPassed)
      val str = doCmd(testCmd)
      assert(!str.contains("FAIL"))
      val intFind = "(\\d+\\.?)+".r
      val dmips = intFind.findFirstIn("DMIPS per Mhz\\:                              (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
      val coremarkTicks = intFind.findFirstIn("Total ticks      \\: (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
      val coremarkIterations = intFind.findFirstIn("Iterations       \\: (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
      val coremarkHzs = intFind.findFirstIn("DCLOCKS_PER_SEC=(\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
      val coremarkPerMhz =1e6*coremarkIterations/coremarkTicks
      report ++= s"$name -> $dmips DMIPS/Mhz $coremarkPerMhz Coremark/Mhz\n"
    }

  }

  getDmips(
    name = "GenSmallestNoCsr",
    gen = GenSmallestNoCsr.main(null),
    testCmd = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no  COREMARK=yes"
  )


  getDmips(
    name = "GenSmallest",
    gen = GenSmallest.main(null),
    testCmd = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no  COREMARK=yes"
  )


  getDmips(
    name = "GenSmallAndProductive",
    gen = GenSmallAndProductive.main(null),
    testCmd = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no  COREMARK=yes"
  )

  getDmips(
    name = "GenSmallAndProductiveWithICache",
    gen = GenSmallAndProductiveICache.main(null),
    testCmd = "make clean run REDO=10 IBUS=CACHED DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no  COREMARK=yes"
  )


  getDmips(
    name = "GenFullNoMmuNoCache",
    gen = GenFullNoMmuNoCache.main(null),
    testCmd = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no  COREMARK=yes"
  )

  getDmips(
    name = "GenNoCacheNoMmuMaxPerf",
    gen = GenNoCacheNoMmuMaxPerf.main(null),
    testCmd = "make clean run REDO=10 MMU=no CSR=no DBUS=SIMPLE IBUS=SIMPLE  COREMARK=yes"
  )


  getDmips(
    name = "GenFullNoMmuMaxPerf",
    gen = GenFullNoMmuMaxPerf.main(null),
    testCmd = "make clean run REDO=10 MMU=no CSR=no  COREMARK=yes"
  )
  getDmips(
    name = "GenFullNoMmu",
    gen = GenFullNoMmu.main(null),
    testCmd = "make clean run REDO=10 MMU=no CSR=no  COREMARK=yes"
  )

  getDmips(
    name = "GenFull",
    gen = GenFull.main(null),
    testCmd = "make clean run REDO=10 CSR=no MMU=no  COREMARK=yes"
  )

  getDmips(
    name = "GenLinuxBalenced",
    gen = LinuxGen.main(Array.fill[String](0)("")),
    testCmd = "make clean run IBUS=CACHED DBUS=CACHED DEBUG_PLUGIN=STD DHRYSTONE=yes SUPERVISOR=yes MMU=no CSR=yes CSR_SKIP_TEST=yes  COMPRESSED=no MUL=yes DIV=yes LRSC=yes AMO=yes REDO=10 TRACE=no COREMARK=yes LINUX_REGRESSION=no"
  )
  //make run  IBUS=CACHED DBUS=CACHED DEBUG_PLUGIN=STD DHRYSTONE=yess SUPERVISOR=yes CSR=yes COMPRESSED=no MUL=yes DIV=yes LRSC=yes AMO=yes REDO=1 TRACE=no LINUX_REGRESSION=yes SEED=42


  test("final_report") {
    println(report)
  }
}
