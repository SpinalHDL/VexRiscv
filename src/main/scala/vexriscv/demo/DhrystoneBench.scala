package vexriscv.demo
import scala.sys.process._
import java.io.File

object DhrystoneBench extends App{
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
  def getDmips(name : String, gen : => Unit, test : String): Unit ={
    gen
    val str = doCmd(test)
    assert(!str.contains("FAIL"))
    val intFind = "(\\d+\\.?)+".r
    val dmips = intFind.findFirstIn("DMIPS per Mhz\\:                              (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
    report ++= name + " -> " + dmips + "\n"

  }

  getDmips(
    name = "GenSmallestNoCsr",
    gen = GenSmallestNoCsr.main(null),
    test = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no"
  )


  getDmips(
    name = "GenSmallest",
    gen = GenSmallest.main(null),
    test = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no"
  )


  getDmips(
    name = "GenSmallAndProductive",
    gen = GenSmallAndProductive.main(null),
    test = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no"
  )


  getDmips(
    name = "GenFullNoMmuNoCache",
    gen = GenFullNoMmuNoCache.main(null),
    test = "make clean run REDO=10 IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no"
  )

  getDmips(
    name = "GenNoCacheNoMmuMaxPerf",
    gen = GenNoCacheNoMmuMaxPerf.main(null),
    test = "make clean run REDO=10 MMU=no CSR=no DBUS=SIMPLE IBUS=SIMPLE"
  )


  getDmips(
    name = "GenFullNoMmuMaxPerf",
    gen = GenFullNoMmuMaxPerf.main(null),
    test = "make clean run REDO=10 MMU=no CSR=no"
  )
  getDmips(
    name = "GenFullNoMmu",
    gen = GenFullNoMmu.main(null),
    test = "make clean run REDO=10 MMU=no CSR=no"
  )

  getDmips(
    name = "GenFull",
    gen = GenFull.main(null),
    test = "make clean run REDO=10 CSR=no MMU=no"
  )

  println(report)
}
