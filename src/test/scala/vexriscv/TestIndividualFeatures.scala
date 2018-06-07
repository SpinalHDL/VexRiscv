package vexriscv

import java.io.File

import org.scalatest.FunSuite
import spinal.core._
import vexriscv.demo._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.plugin._

import scala.collection.mutable.ArrayBuffer
import scala.sys.process._


abstract class  ConfigDimension[T](val name: String) {
  def positions: Seq[T]
  def default : Seq[T] = List(positions(0))
}

abstract class  VexRiscvDimension(name: String) extends ConfigDimension[VexRiscvPosition](name)

class ShiftDimension extends VexRiscvDimension("Shift") {
  override val positions = List(
    new VexRiscvPosition("FullLate") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new FullBarrielShifterPlugin(earlyInjection = false)
    },
    new VexRiscvPosition("FullEarly") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new FullBarrielShifterPlugin(earlyInjection = true)
    },
    new VexRiscvPosition("Light") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new LightShifterPlugin
    }
  )
}

class BranchDimension extends VexRiscvDimension("Branch") {
  override val positions = List(
    new VexRiscvPosition("Late") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new BranchPlugin(
        earlyBranch = false,
        catchAddressMisaligned = false
      )
    },
    new VexRiscvPosition("Early") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new BranchPlugin(
        earlyBranch = true,
        catchAddressMisaligned = false
      )
    }
  )
}



class MulDivDimension extends VexRiscvDimension("MulDiv") {
  override val positions = List(
    new VexRiscvPosition("NoMulDiv") {
      override def applyOn(config: VexRiscvConfig): Unit = {}
      override def testParam = "MUL=no DIV=no"
    },
    new VexRiscvPosition("MulDivFpga") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new MulPlugin
        config.plugins += new MulDivIterativePlugin(
          genMul = false,
          genDiv = true,
          mulUnroolFactor = 32,
          divUnroolFactor = 1
        )
      }
    },
    new VexRiscvPosition("MulDivAsic") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new MulDivIterativePlugin(
          genMul = true,
          genDiv = true,
          mulUnroolFactor = 32,
          divUnroolFactor = 1
        )
      }
    }
  )
}

class RegFileDimension extends VexRiscvDimension("RegFile") {
  override val positions = List(
    new VexRiscvPosition("Async") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new RegFilePlugin(
        regFileReadyKind = plugin.ASYNC
      )
    },
    new VexRiscvPosition("Sync") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new RegFilePlugin(
        regFileReadyKind = plugin.SYNC
      )
    }
  )
}



class HazardDimension extends VexRiscvDimension("Hazard") {
  override val positions = List(
    new VexRiscvPosition("Interlock") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new HazardSimplePlugin(
        bypassExecute = false,
        bypassMemory = false,
        bypassWriteBack = false,
        bypassWriteBackBuffer = false,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      )
    },
    new VexRiscvPosition("BypassAll") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new HazardSimplePlugin(
        bypassExecute = true,
        bypassMemory = true,
        bypassWriteBack = true,
        bypassWriteBackBuffer = true,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      )
    },
    new VexRiscvPosition("BypassExecute") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new HazardSimplePlugin(
        bypassExecute = true,
        bypassMemory = false,
        bypassWriteBack = false,
        bypassWriteBackBuffer = false,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      )
    },
    new VexRiscvPosition("BypassMemory") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new HazardSimplePlugin(
        bypassExecute = false,
        bypassMemory = true,
        bypassWriteBack = false,
        bypassWriteBackBuffer = false,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      )
    },
    new VexRiscvPosition("BypassWriteBack") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new HazardSimplePlugin(
        bypassExecute = false,
        bypassMemory = false,
        bypassWriteBack = true,
        bypassWriteBackBuffer = false,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      )
    },
    new VexRiscvPosition("BypassWriteBackBuffer") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new HazardSimplePlugin(
        bypassExecute = false,
        bypassMemory = false,
        bypassWriteBack = false,
        bypassWriteBackBuffer = true,
        pessimisticUseSrc = false,
        pessimisticWriteRegFile = false,
        pessimisticAddressMatch = false
      )
    }
  )
}


class SrcDimension extends VexRiscvDimension("Src") {
  override val positions = List(
    new VexRiscvPosition("Early") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new SrcPlugin(
        separatedAddSub = false,
        executeInsertion = false
      )
    },
    new VexRiscvPosition("Late") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new SrcPlugin(
        separatedAddSub = false,
        executeInsertion = true
      )
    },
    new VexRiscvPosition("AddSub") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new SrcPlugin(
        separatedAddSub = true,
        executeInsertion = false
      )
    }
  )
}


class IBusDimension extends VexRiscvDimension("IBus") {
  override val positions = ((for(prediction <- List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET);
                                latency <- List(1,3);
                                compressed <- List(false, true);
                                injectorStage <- List(false, true);
                                relaxedPcCalculation <- List(false, true);
                                if latency > 1 || injectorStage) yield new VexRiscvPosition("Simple" + latency + (if(relaxedPcCalculation) "Relax" else "") + (if(injectorStage) "InjStage" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) {
    override def testParam = "IBUS=SIMPLE" + (if(compressed) " COMPRESSED=yes" else "")
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
      resetVector = 0x80000000l,
      relaxedPcCalculation = relaxedPcCalculation,
      prediction = prediction,
      catchAccessFault = false,
      compressedGen = compressed,
      busLatencyMin = latency,
      injectorStage = injectorStage
    )
  }) :+ new VexRiscvPosition("SimpleFullRelaxedDeep"){
    override def testParam = "IBUS=SIMPLE COMPRESSED=yes"
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
      resetVector = 0x80000000l,
      relaxedPcCalculation = true,
      relaxedBusCmdValid = true,
      prediction = STATIC,
      catchAccessFault = false,
      compressedGen = true,
      busLatencyMin = 3,
      injectorStage = false
    )
  } :+ new VexRiscvPosition("SimpleFullRelaxedStd") {
    override def testParam = "IBUS=SIMPLE"
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
      resetVector = 0x80000000l,
      relaxedPcCalculation = true,
      relaxedBusCmdValid = true,
      prediction = STATIC,
      catchAccessFault = false,
      compressedGen = false,
      busLatencyMin = 1,
      injectorStage = true
    )
  }) ++ (for(prediction <- List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET);
             twoCycleCache <- List(false, true);
             twoCycleRam <- List(false, true);
             wayCount <- List(1, 4);
             cacheSize <- List(512, 4096);
             compressed <- List(false, true);
             relaxedPcCalculation <- List(false, true);
            if !(!twoCycleCache && twoCycleRam ) && !(prediction != NONE && (wayCount == 1 || cacheSize == 4096 ))) yield new VexRiscvPosition("Cached" + (if(twoCycleCache) "2cc" else "") + (if(twoCycleRam) "2cr" else "")  + "S" + cacheSize + "W" + wayCount + (if(relaxedPcCalculation) "Relax" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) {
    override def testParam = "IBUS=CACHED" + (if(compressed) " COMPRESSED=yes" else "")
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusCachedPlugin(
      resetVector = 0x80000000l,
      compressedGen = compressed,
      prediction = prediction,
      relaxedPcCalculation = relaxedPcCalculation,
      config = InstructionCacheConfig(
        cacheSize = cacheSize,
        bytePerLine = 32,
        wayCount = wayCount,
        addressWidth = 32,
        cpuDataWidth = 32,
        memDataWidth = 32,
        catchIllegalAccess = false,
        catchAccessFault = false,
        catchMemoryTranslationMiss = false,
        asyncTagMemory = false,
        twoCycleRam = twoCycleRam,
        twoCycleCache = twoCycleCache
      )
    )
  })

//  override def default = List(positions.last)
}




class DBusDimension extends VexRiscvDimension("DBus") {
  override val positions = List(
    new VexRiscvPosition("SimpleLate") {
      override def testParam = "DBUS=SIMPLE"
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DBusSimplePlugin(
        catchAddressMisaligned = false,
        catchAccessFault = false,
        earlyInjection = false
      )
    },
    new VexRiscvPosition("SimpleEarly") {
      override def testParam = "DBUS=SIMPLE"
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DBusSimplePlugin(
        catchAddressMisaligned = false,
        catchAccessFault = false,
        earlyInjection = true
      )
    }
  ) ++ (for(wayCount <- List(1);
            cacheSize <- List(512, 4096)) yield new VexRiscvPosition("Cached" + "S" + cacheSize + "W" + wayCount) {
    override def testParam = "DBUS=CACHED"
    override def applyOn(config: VexRiscvConfig): Unit = {
      config.plugins += new DBusCachedPlugin(
        config = new DataCacheConfig(
          cacheSize         = cacheSize,
          bytePerLine       = 32,
          wayCount          = wayCount,
          addressWidth      = 32,
          cpuDataWidth      = 32,
          memDataWidth      = 32,
          catchAccessError  = false,
          catchIllegal      = false,
          catchUnaligned    = false,
          catchMemoryTranslationMiss = false,
          atomicEntriesCount = 0
        ),
        memoryTranslatorPortConfig = null
      )
      config.plugins += new StaticMemoryTranslatorPlugin(
        ioRange      = _(31 downto 28) === 0xF
      )
    }
  })
}



abstract class ConfigPosition[T](val name: String) {
  def applyOn(config: T): Unit
  var dimension : ConfigDimension[_] = null
}

abstract class  VexRiscvPosition(name: String) extends ConfigPosition[VexRiscvConfig](name){
  def testParam : String = ""
}

class TestIndividualFeatures extends FunSuite {
  def doCmd(cmd: String): String = {
    val stdOut = new StringBuilder()
    class Logger extends ProcessLogger {
      override def err(s: => String): Unit = {
        if (!s.startsWith("ar: creating ")) println(s)
      }

      override def out(s: => String): Unit = {
        println(s)
        stdOut ++= s
      }

      override def buffer[T](f: => T) = f
    }
    Process(cmd, new File("src/test/cpp/regression")).!(new Logger)
    stdOut.toString()
  }


  val dimensions = List(
    new MulDivDimension,
    new ShiftDimension,
    new BranchDimension,
    new HazardDimension,
    new RegFileDimension,
    new SrcDimension,
    new IBusDimension,
    new DBusDimension
  )


  def genDefaultsPositions(dims : Seq[VexRiscvDimension], stack : List[VexRiscvPosition] = Nil) : Seq[List[VexRiscvPosition]] = dims match {
    case head :: tail => head.default.flatMap(p => genDefaultsPositions(tail, p :: stack))
    case Nil => List(stack)
  }

  dimensions.foreach(d => d.positions.foreach(_.dimension = d))

  for (dimension <- dimensions) {
    for (position <- dimension.positions/* if position.name.contains("Cached")*/) {
      for(defaults <- genDefaultsPositions(dimensions.filter(_ != dimension))){
        def gen = {
          val config = VexRiscvConfig(
            plugins = List(
              new DecoderSimplePlugin(
                catchIllegalInstruction = false
              ),
              new IntAluPlugin,
              new YamlPlugin("cpu0.yaml")
            )
          )
          position.applyOn(config)
          for (dimensionOthers <- defaults) dimensionOthers.applyOn(config)

          SpinalVerilog(new VexRiscv(config))
        }
        val name = dimension.name + "_ " + position.name + "_" + defaults.map(d => d.dimension.name + "_" + d.name).mkString("_")
        test(name + "_gen") {
          gen
        }
        test(name + "_test") {
          val testCmd = "make clean run REDO=10 CSR=no MMU=no DEBUG_PLUGIN=no " + (position :: defaults).map(_.testParam).mkString(" ")
          val str = doCmd(testCmd)
          assert(!str.contains("FAIL"))
          val intFind = "(\\d+\\.?)+".r
          val dmips = intFind.findFirstIn("DMIPS per Mhz\\:                              (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
        }
      }
    }
  }

}
