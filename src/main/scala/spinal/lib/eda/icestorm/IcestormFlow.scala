package spinal.lib.eda.icestorm
import spinal.lib.eda._
import spinal.lib.eda.bench.{Report, Rtl, Target}

import scala.collection.mutable.ArrayBuffer
import java.io.File
import java.nio.file.Paths

import org.apache.commons.io.FileUtils
import spinal.core._
import spinal.lib.StreamFifo
import spinal.lib.eda.bench.Report

import scala.sys.process._

import scala.collection.Seq

object IcestormFlow {
  def doCmd(cmd : Seq[String], path : String): String ={
    println(cmd)
    val str =  new StringBuilder()
    val log = new ProcessLogger {
      override def err(s: => String): Unit = {
        str ++= s
        stderr.println(s)
      }

      override def out(s: => String): Unit = {
        str ++= s
        stdout.println(s)
      }

      override def buffer[T](f: => T) = f
    }
    if(isWindows)
      Process("cmd /C " + cmd, new java.io.File(path)) !(log)
    else
      Process.apply(cmd, new java.io.File(path)) !(log)

    return str.toString()
  }

  val isWindows = System.getProperty("os.name").toLowerCase().contains("win")

  def apply(workspacePath : String,toplevelPath : String,family : String,device : String, pack : String) : Report = {
    val projectName = toplevelPath.split("/").last.split("[.]").head

//ifeq ($(NEXTPNR),yes)
//%.json: ${VERILOGS}
//	rm -f ${TOPLEVEL}.v*.bin
//	cp -f  ${ROOT}/hardware/netlist/${TOPLEVEL}.v*.bin . | true
//	yosys -p 'synth_ice40 -top $(TOPLEVEL) -json $@' $<
//
//%.asc: $(PIN_DEF) %.json constraint.py
//	nextpnr-ice40 --$(DEVICE) --json $(TOPLEVEL).json --pcf $(PIN_DEF) --asc $(TOPLEVEL).asc --pre-pack constraint.py $(NEXTPNR_ARG)
//else
//%.blif: ${VERILOGS}
//	rm -f ${TOPLEVEL}.v*.bin
//	cp -f  ${ROOT}/hardware/netlist/${TOPLEVEL}.v*.bin . | true
//	yosys -p 'synth_ice40 -top ${TOPLEVEL} -blif $@' $<
//
//%.asc: $(PIN_DEF) %.blif
//	arachne-pnr -d $(subst up,,$(subst hx,,$(subst lp,,$(DEVICE)))) -o $@ -p $^
//endif

    val workspacePathFile = new File(workspacePath)
    FileUtils.deleteDirectory(workspacePathFile)
    workspacePathFile.mkdir()
    FileUtils.copyFileToDirectory(new File(toplevelPath), workspacePathFile)
    doCmd(List("yosys", "-v3", "-p", s"synth_ice40 -top $projectName -json ${projectName}.json", s"$projectName.v" ), workspacePath)
    val arachne = doCmd(List("nextpnr-ice40", s"--$device", "--json", s"${projectName}.json","--asc", s"$projectName.asc"), workspacePath)
    doCmd(List("icepack", s"$projectName.asc", s"$projectName.bin"), workspacePath)
    val icetime = doCmd(List("icetime", "-tmd", device, s"${projectName}.asc"), workspacePath)
    new Report{
      val intFind = "(\\d+,?)+".r
      val fMaxReg = """[-+]?(\d*[.])?\d+""".r
      override def getFMax() = {
        try {
          fMaxReg.findAllMatchIn("Total path delay: [^\\n]* MHz".r.findFirstIn(icetime).get).drop(1).next.toString().toDouble * 1e6
        } catch {
          case e : Throwable => -1
        }
      }
      override def getArea() = {
        try {
          intFind.findFirstIn("ICESTORM_LC\\:[^\\n]*\\/".r.findFirstIn(arachne).get).get.toString() + " LC"
        } catch {
          case e : Throwable => "error"
        }
      }
    }
//    mkdir -p bin
//      rm -f Murax.v*.bin
//    cp ../../../Murax.v*.bin . | true
//    yosys -v3 -p "synth_ice40 -top toplevel -blif bin/toplevel.blif" ${VERILOG}
//
//    val isVhdl = toplevelPath.endsWith(".vhd") || toplevelPath.endsWith(".vhdl")
//
//    val tcl = new java.io.FileWriter(Paths.get(workspacePath,"doit.tcl").toFile)
//    tcl.write(
//      s"""read_${if(isVhdl) "vhdl" else "verilog"} $toplevelPath
//read_xdc doit.xdc
//
//synth_design -part $device -top ${toplevelPath.split("\\.").head}
//opt_design
//place_design
//route_design
//
//report_utilization
//report_timing"""
//    )
//
//    tcl.flush();
//    tcl.close();
//
//
//    val xdc = new java.io.FileWriter(Paths.get(workspacePath,"doit.xdc").toFile)
//    xdc.write(s"""create_clock -period ${(targetPeriod*1e9) toBigDecimal} [get_ports clk]""")
//
//    xdc.flush();
//    xdc.close();
//
//    doCmd(s"$vivadoPath/vivado -nojournal -log doit.log -mode batch -source doit.tcl", workspacePath)
//
//    new Report{
//      override def getFMax(): Double =  {
//        import scala.io.Source
//        val report = Source.fromFile(Paths.get(workspacePath,"doit.log").toFile).getLines.mkString
//        val intFind = "-?(\\d+\\.?)+".r
//        val slack = try {
//          (family match {
//            case "Artix 7" =>
//              intFind.findFirstIn("-?(\\d+.?)+ns  \\(required time - arrival time\\)".r.findFirstIn(report).get).get
//          }).toDouble
//        }catch{
//          case e : Exception => -1.0
//        }
//        return 1.0/(targetPeriod.toDouble-slack*1e-9)
//      }
//      override def getArea(): String =  {
//        import scala.io.Source
//        val report = Source.fromFile(Paths.get(workspacePath,"doit.log").toFile).getLines.mkString
//        val intFind = "(\\d+,?)+".r
//        val leArea = try {
//          family match {
//            case "Artix 7" =>
//              intFind.findFirstIn("Slice LUTs[ ]*\\|[ ]*(\\d+,?)+".r.findFirstIn(report).get).get + " LUT " +
//                intFind.findFirstIn("Slice Registers[ ]*\\|[ ]*(\\d+,?)+".r.findFirstIn(report).get).get + " FF "
//          }
//        }catch{
//          case e : Exception => "???"
//        }
//        return leArea
//      }
//    }
  }

  def main(args: Array[String]) {
//    SpinalVerilog(StreamFifo(Bits(8 bits), 64))
//    val report = IcestormFlow(
//      workspacePath="/home/spinalvm/tmp",
//      toplevelPath="StreamFifo.v",
//      family="iCE40",
//      device="hx8k",
//      pack = "ct256"
//    )
//    println(report.getArea())
//    println(report.getFMax())
//  }
    SpinalVerilog(StreamFifo(Bits(8 bits), 64))
    val report = IcestormFlow(
      workspacePath="/media/miaou/HD/linux/tmp",
      toplevelPath="StreamFifo.v",
      family="iCE40",
      device="up5k",
      pack = "sg48"
    )
    println(report.getArea())
    println(report.getFMax())
  }
}

object IcestormStdTargets {
  def apply(): Seq[Target] = {
    val targets = ArrayBuffer[Target]()
    targets += new Target {
      override def getFamilyName(): String = "iCE40"
      override def synthesise(rtl: Rtl, workspace: String): Report = {
         IcestormFlow(
          workspacePath=workspace,
          toplevelPath=rtl.getRtlPath(),
          family=getFamilyName(),
           device="hx8k",
           pack = "ct256"
        )
      }
    }

    targets += new Target {
      override def getFamilyName(): String = "iCE40Ultra"
      override def synthesise(rtl: Rtl, workspace: String): Report = {
        IcestormFlow(
          workspacePath=workspace,
          toplevelPath=rtl.getRtlPath(),
          family=getFamilyName(),
          device="up5k",
          pack = "sg48"
        )
      }
    }
    targets
  }
}