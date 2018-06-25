package vexriscv

import java.io.File

import org.apache.commons.io.FileUtils
import org.scalatest.FunSuite
import spinal.core._
import vexriscv.demo._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.plugin._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import scala.sys.process._
import scala.util.Random


abstract class ConfigUniverse

abstract class  ConfigDimension[T](val name: String) {
  def positions: Seq[T]
  def default : Seq[T] = List(positions(0))
  def random(universes : Seq[ConfigUniverse], r : Random) : T = positions(r.nextInt(positions.length))
}

abstract class  VexRiscvDimension(name: String) extends ConfigDimension[VexRiscvPosition](name)

abstract class ConfigPosition[T](val name: String) {
  def applyOn(config: T): Unit
  var dimension : ConfigDimension[_] = null
  def isCompatibleWith(positions : Seq[ConfigPosition[T]]) : Boolean = true
}

abstract class  VexRiscvPosition(name: String) extends ConfigPosition[VexRiscvConfig](name){
  def testParam : String = ""
}

class VexRiscvUniverse extends ConfigUniverse

object VexRiscvUniverse{
  val CATCH_ALL = new VexRiscvUniverse
  val MMU = new VexRiscvUniverse

  val universes = List(CATCH_ALL, MMU)
}

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
  override val positions = (for(catchAll <- List(false,true)) yield List(
    new VexRiscvPosition("Late") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new BranchPlugin(
        earlyBranch = false,
        catchAddressMisaligned = catchAll
      )

      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    },
    new VexRiscvPosition("Early") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new BranchPlugin(
        earlyBranch = true,
        catchAddressMisaligned = catchAll
      )
      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    }
  )).flatten
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

trait InstructionAnticipatedPosition{
  def instructionAnticipatedOk() : Boolean
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

      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = positions.exists{
        case p : InstructionAnticipatedPosition => p.instructionAnticipatedOk()
        case _ => false
      }
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
  override val positions = (for(catchAll <- List(false,true)) yield ((for(prediction <- List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET);
                                latency <- List(1,3);
                                compressed <- List(false, true);
                                injectorStage <- List(false, true);
                                relaxedPcCalculation <- List(false, true);
                                if latency > 1 || injectorStage) yield new VexRiscvPosition("Simple" + latency + (if(relaxedPcCalculation) "Relax" else "") + (if(injectorStage) "InjStage" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) with InstructionAnticipatedPosition{
    override def testParam = "IBUS=SIMPLE" + (if(compressed) " COMPRESSED=yes" else "")
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
      resetVector = 0x80000000l,
      relaxedPcCalculation = relaxedPcCalculation,
      prediction = prediction,
      catchAccessFault = catchAll,
      compressedGen = compressed,
      busLatencyMin = latency,
      injectorStage = injectorStage
    )
    override def instructionAnticipatedOk() = injectorStage
    override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
  }) :+ new VexRiscvPosition("SimpleFullRelaxedDeep"){
    override def testParam = "IBUS=SIMPLE COMPRESSED=yes"
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
      resetVector = 0x80000000l,
      relaxedPcCalculation = true,
      relaxedBusCmdValid = true,
      prediction = STATIC,
      catchAccessFault = catchAll,
      compressedGen = true,
      busLatencyMin = 3,
      injectorStage = false
    )
    override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
  } :+ new VexRiscvPosition("SimpleFullRelaxedStd") with InstructionAnticipatedPosition{
    override def testParam = "IBUS=SIMPLE"
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
      resetVector = 0x80000000l,
      relaxedPcCalculation = true,
      relaxedBusCmdValid = true,
      prediction = STATIC,
      catchAccessFault = catchAll,
      compressedGen = false,
      busLatencyMin = 1,
      injectorStage = true
    )
    override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    override def instructionAnticipatedOk() = true
  }) ++ (for(prediction <- List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET);
             twoCycleCache <- List(false, true);
             twoCycleRam <- List(false, true);
             wayCount <- List(1, 4);
             cacheSize <- List(512, 4096);
             compressed <- List(false, true);
             injectorStage <- List(false, true);
             relaxedPcCalculation <- List(false, true);
            if !(!twoCycleCache && twoCycleRam ) && !(prediction != NONE && (wayCount == 1 || cacheSize == 4096 ))) yield new VexRiscvPosition("Cached" + (if(twoCycleCache) "2cc" else "") + (if(injectorStage) "Injstage" else "") + (if(twoCycleRam) "2cr" else "")  + "S" + cacheSize + "W" + wayCount + (if(relaxedPcCalculation) "Relax" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) with InstructionAnticipatedPosition{
    override def testParam = "IBUS=CACHED" + (if(compressed) " COMPRESSED=yes" else "")
    override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusCachedPlugin(
      resetVector = 0x80000000l,
      compressedGen = compressed,
      prediction = prediction,
      relaxedPcCalculation = relaxedPcCalculation,
      injectorStage = injectorStage,
      config = InstructionCacheConfig(
        cacheSize = cacheSize,
        bytePerLine = 32,
        wayCount = wayCount,
        addressWidth = 32,
        cpuDataWidth = 32,
        memDataWidth = 32,
        catchIllegalAccess = catchAll,
        catchAccessFault = catchAll,
        catchMemoryTranslationMiss = catchAll,
        asyncTagMemory = false,
        twoCycleRam = twoCycleRam,
        twoCycleCache = twoCycleCache
      )
    )
    override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    override def instructionAnticipatedOk() = !twoCycleCache || ((!twoCycleRam || wayCount == 1) && !compressed)
  })).flatten

//  override def default = List(positions.last)
}




class DBusDimension extends VexRiscvDimension("DBus") {
  override val positions = (for(catchAll <- List(false,true)) yield List(
    new VexRiscvPosition("SimpleLate") {
      override def testParam = "DBUS=SIMPLE"
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DBusSimplePlugin(
        catchAddressMisaligned = catchAll,
        catchAccessFault = catchAll,
        earlyInjection = false
      )
      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    },
    new VexRiscvPosition("SimpleEarly") {
      override def testParam = "DBUS=SIMPLE"
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DBusSimplePlugin(
        catchAddressMisaligned = catchAll,
        catchAccessFault = catchAll,
        earlyInjection = true
      )
      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
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
          catchAccessError  = catchAll,
          catchIllegal      = catchAll,
          catchUnaligned    = catchAll,
          catchMemoryTranslationMiss = catchAll,
          atomicEntriesCount = 0
        ),
        memoryTranslatorPortConfig = null
      )
      config.plugins += new StaticMemoryTranslatorPlugin(
        ioRange      = _(31 downto 28) === 0xF
      )
    }
    override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
  })).flatten
}



trait CatchAllPosition

//TODO CSR without exception
//TODO FREERTOS
class CsrDimension extends VexRiscvDimension("Csr") {
  override val positions = List(
    new VexRiscvPosition("None") {
      override def applyOn(config: VexRiscvConfig): Unit = {}
      override def testParam = "CSR=no"
    },
    new VexRiscvPosition("All") with CatchAllPosition{
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l))
    }
  )
}

class DebugDimension extends VexRiscvDimension("Debug") {
  override val positions = List(
    new VexRiscvPosition("None") {
      override def applyOn(config: VexRiscvConfig): Unit = {}
      override def testParam = "DEBUG_PLUGIN=no"
    },
    new VexRiscvPosition("Enable") with CatchAllPosition{
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset")))
    }
  )
}

class DecoderDimension extends VexRiscvDimension("Decoder") {
  override val positions = (for(catchAll <- List(false,true)) yield List(
    new VexRiscvPosition("") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DecoderSimplePlugin(
        catchIllegalInstruction = catchAll
      )
      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    }
  )).flatten
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
    new IBusDimension,
    new DBusDimension,
    new MulDivDimension,
    new ShiftDimension,
    new BranchDimension,
    new HazardDimension,
    new RegFileDimension,
    new SrcDimension,
    new CsrDimension,
    new DecoderDimension,
    new DebugDimension
  )


  def genDefaultsPositions(dims : Seq[VexRiscvDimension], stack : List[VexRiscvPosition] = Nil) : Seq[List[VexRiscvPosition]] = dims match {
    case head :: tail => head.default.flatMap(p => genDefaultsPositions(tail, p :: stack))
    case Nil => List(stack)
  }

  val usedPositions = mutable.HashSet[VexRiscvPosition]();
  val positionsCount = dimensions.map(d => d.positions.length).sum

  def doTest(positionsToApply : List[VexRiscvPosition], prefix : String = ""): Unit ={
    usedPositions ++= positionsToApply
    def gen = {
      FileUtils.deleteQuietly(new File("VexRiscv.v"))
      SpinalVerilog{
        val config = VexRiscvConfig(
          plugins = List(
            new IntAluPlugin,
            new YamlPlugin("cpu0.yaml")
          )
        )
        for (positionToApply <- positionsToApply) positionToApply.applyOn(config)
        new VexRiscv(config)
      }
    }
    val name = positionsToApply.map(d => d.dimension.name + "_" + d.name).mkString("_")
    test(prefix + name + "_gen") {
      gen
    }
    test(prefix + name + "_test") {
      val debug = false
      val stdCmd = if(debug) "make clean run REDO=1 TRACE=yes MMU=no DHRYSTONE=no " else "make clean run REDO=10 TRACE=no MMU=no "
//      val stdCmd = "make clean run REDO=40 DHRYSTONE=no STOP_ON_FAIL=yes TRACE=yess MMU=no"

      val testCmd = stdCmd + (positionsToApply).map(_.testParam).mkString(" ")
      val str = doCmd(testCmd)
      assert(!str.contains("FAIL"))
//      val intFind = "(\\d+\\.?)+".r
//      val dmips = intFind.findFirstIn("DMIPS per Mhz\\:                              (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
    }
  }

  dimensions.foreach(d => d.positions.foreach(p => p.dimension = d))

  val testId = None
  val seed = Random.nextLong()

//  val testId = Some(6)
//  val seed = -6369023953274056616l

  val rand = new Random(seed)

  println(s"Seed=$seed")
  for(i <- 0 until 200){
    var positions : List[VexRiscvPosition] = null
    val universe = VexRiscvUniverse.universes.filter(e => rand.nextBoolean())
    do{
      positions = dimensions.map(d => d.random(universe, rand))
    }while(!positions.forall(_.isCompatibleWith(positions)))

    if(testId.isEmpty || testId.get == i)
      doTest(positions," random_" + i + "_")
  }

  println(s"${usedPositions.size}/$positionsCount positions")

//  for (dimension <- dimensions) {
//    for (position <- dimension.positions/* if position.name.contains("Cached")*/) {
//      for(defaults <- genDefaultsPositions(dimensions.filter(_ != dimension))){
//        doTest(position :: defaults)
//      }
//    }
//  }
}
