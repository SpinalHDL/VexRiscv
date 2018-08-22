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

abstract class  ConfigDimension[T <: ConfigPosition[_]](val name: String) {
  def randomPosition(universes : Seq[ConfigUniverse], r : Random) : T = {
    val ret = randomPositionImpl(universes, r)
    ret.dimension = this
    ret
  }

  protected def randomPositionImpl(universes : Seq[ConfigUniverse], r : Random) : T
  protected def random[X](r : Random, positions : List[X]) : X = positions(r.nextInt(positions.length))
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
  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = random(r, List(
    new VexRiscvPosition("FullLate") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new FullBarrelShifterPlugin(earlyInjection = false)
    },
    new VexRiscvPosition("FullEarly") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new FullBarrelShifterPlugin(earlyInjection = true)
    },
    new VexRiscvPosition("Light") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new LightShifterPlugin
    }
  ))
}

class BranchDimension extends VexRiscvDimension("Branch") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val early = r.nextBoolean()
    new VexRiscvPosition(if(early) "Early" else "Late") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new BranchPlugin(
        earlyBranch = early,
        catchAddressMisaligned = catchAll
      )
    }
  }
}



class MulDivDimension extends VexRiscvDimension("MulDiv") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = random(r, List(
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
          mulUnrollFactor = 32,
          divUnrollFactor = 1
        )
      }
    },
    new VexRiscvPosition("MulDivAsic") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new MulDivIterativePlugin(
          genMul = true,
          genDiv = true,
          mulUnrollFactor = 32,
          divUnrollFactor = 4
        )
      }
    },
    new VexRiscvPosition("MulDivFpgaNoDsp") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new MulDivIterativePlugin(
          genMul = true,
          genDiv = true,
          mulUnrollFactor = 1,
          divUnrollFactor = 1
        )
      }
    },
    new VexRiscvPosition("MulDivFpgaNoDspFastMul") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new MulDivIterativePlugin(
          genMul = true,
          genDiv = true,
          mulUnrollFactor = 8,
          divUnrollFactor = 1
        )
      }
    }
  ))
}

trait InstructionAnticipatedPosition{
  def instructionAnticipatedOk() : Boolean
}

class RegFileDimension extends VexRiscvDimension("RegFile") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = random(r, List(
    new VexRiscvPosition("Async") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new RegFilePlugin(
        regFileReadyKind = plugin.ASYNC,
        zeroBoot = true
      )
    },
    new VexRiscvPosition("Sync") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new RegFilePlugin(
        regFileReadyKind = plugin.SYNC,
        zeroBoot = true
      )

      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = positions.exists{
        case p : InstructionAnticipatedPosition => p.instructionAnticipatedOk()
        case _ => false
      }
    }
  ))
}



class HazardDimension extends VexRiscvDimension("Hazard") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) : VexRiscvPosition = {
    if(r.nextDouble() < 0.8){
      random(r, List(
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
        }
      ))
    }else {
      random(r, List(
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
      ))
    }
  }}


class SrcDimension extends VexRiscvDimension("Src") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val separatedAddSub, executeInsertion = r.nextBoolean()
    new VexRiscvPosition((if (separatedAddSub) "AddSub" else "") + (if (executeInsertion) "Execute" else "")) {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new SrcPlugin(
        separatedAddSub = separatedAddSub,
        executeInsertion = executeInsertion
      )
    }
  }
}


class IBusDimension extends VexRiscvDimension("IBus") {


  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    if(r.nextDouble() < 0.5){
      val latency = r.nextInt(5) + 1
      val compressed = r.nextBoolean()
      val injectorStage = r.nextBoolean() || latency == 1
      val prediction = random(r, List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET))
      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      val relaxedPcCalculation = r.nextBoolean()
      val relaxedBusCmdValid =false // r.nextBoolean() && relaxedPcCalculation && prediction != DYNAMIC_TARGET
      new VexRiscvPosition("Simple" + latency + (if(relaxedPcCalculation) "Relax" else "") + (if(relaxedBusCmdValid) "Valid" else "") + (if(injectorStage) "InjStage" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) with InstructionAnticipatedPosition{
        override def testParam = "IBUS=SIMPLE" + (if(compressed) " COMPRESSED=yes" else "")
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
          resetVector = 0x80000000l,
          relaxedPcCalculation = relaxedPcCalculation,
          relaxedBusCmdValid = relaxedBusCmdValid,
          prediction = prediction,
          catchAccessFault = catchAll,
          compressedGen = compressed,
          busLatencyMin = latency,
          injectorStage = injectorStage
        )
        override def instructionAnticipatedOk() = injectorStage
      }
    } else {
      val compressed = r.nextBoolean()
      val prediction = random(r, List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET))
      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      val relaxedPcCalculation, twoCycleCache, injectorStage = r.nextBoolean()
      val twoCycleRam = r.nextBoolean() && twoCycleCache
      var cacheSize = 0
      var wayCount = 0
      do{
        cacheSize = 512 << r.nextInt(5)
        wayCount = 1 << r.nextInt(3)
      }while(cacheSize/wayCount < 512)

      new VexRiscvPosition("Cached" + (if(twoCycleCache) "2cc" else "") + (if(injectorStage) "Injstage" else "") + (if(twoCycleRam) "2cr" else "")  + "S" + cacheSize + "W" + wayCount + (if(relaxedPcCalculation) "Relax" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) with InstructionAnticipatedPosition{
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
        override def instructionAnticipatedOk() = !twoCycleCache || ((!twoCycleRam || wayCount == 1) && !compressed)
      }
    }
  }
}




class DBusDimension extends VexRiscvDimension("DBus") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    if(r.nextDouble() < 0.4){
      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      val earlyInjection = r.nextBoolean()
      new VexRiscvPosition("Simple" + (if(earlyInjection) "Early" else "Late")) {
        override def testParam = "DBUS=SIMPLE"
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DBusSimplePlugin(
          catchAddressMisaligned = catchAll,
          catchAccessFault = catchAll,
          earlyInjection = earlyInjection
        )
//        override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
      }
    } else {
      val cacheSize = 512 << r.nextInt(5)
      val wayCount = 1
      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      new VexRiscvPosition("Cached" + "S" + cacheSize + "W" + wayCount) {
        override def testParam = "DBUS=CACHED"

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize = cacheSize,
              bytePerLine = 32,
              wayCount = wayCount,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchAccessError = catchAll,
              catchIllegal = catchAll,
              catchUnaligned = catchAll,
              catchMemoryTranslationMiss = catchAll,
              atomicEntriesCount = 0
            ),
            memoryTranslatorPortConfig = null
          )
          config.plugins += new StaticMemoryTranslatorPlugin(
            ioRange = _ (31 downto 28) === 0xF
          )
        }
      }
    }
  }
}



trait CatchAllPosition

//TODO CSR without exception
class CsrDimension(freertos : String) extends VexRiscvDimension("Csr") {
  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    if(catchAll){
      new VexRiscvPosition("All") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l))
        override def testParam = s"FREERTOS=$freertos"
      }
    } else if(r.nextDouble() < 0.2){
      new VexRiscvPosition("AllNoException") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l).noException)
        override def testParam = "CSR=no FREERTOS=no"
      }
    } else {
      new VexRiscvPosition("None") {
        override def applyOn(config: VexRiscvConfig): Unit = {}
        override def testParam = "CSR=no"
      }
    }
  }
}

class DebugDimension extends VexRiscvDimension("Debug") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = random(r, List(
    new VexRiscvPosition("None") {
      override def applyOn(config: VexRiscvConfig): Unit = {}
      override def testParam = "DEBUG_PLUGIN=no"
    },
    new VexRiscvPosition("Enable") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset")))
    }
  ))
}

class DecoderDimension extends VexRiscvDimension("Decoder") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    new VexRiscvPosition("") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DecoderSimplePlugin(
        catchIllegalInstruction = catchAll
      )

//      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    }
  }
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
    new CsrDimension(sys.env.getOrElse("VEXRISCV_REGRESSION_FREERTOS_COUNT", "yes")),
    new DecoderDimension,
    new DebugDimension
  )


//  def genDefaultsPositions(dims : Seq[VexRiscvDimension], stack : List[VexRiscvPosition] = Nil) : Seq[List[VexRiscvPosition]] = dims match {
//    case head :: tail => head.default.flatMap(p => genDefaultsPositions(tail, p :: stack))
//    case Nil => List(stack)
//  }

//  val usedPositions = mutable.HashSet[VexRiscvPosition]();
//  val positionsCount = dimensions.map(d => d.positions.length).sum

  def doTest(positionsToApply : List[VexRiscvPosition], prefix : String = "", testSeed : Int): Unit ={
//    usedPositions ++= positionsToApply
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
      val stdCmd = (if(debug) "make clean run REDO=1 TRACE=yes TRACE_ACCESS=yes MMU=no STOP_ON_ERROR=yes DHRYSTONE=no THREAD_COUNT=1 TRACE_START=0 " else s"make clean run REDO=10 TRACE=no MMU=no THREAD_COUNT=${sys.env.getOrElse("VEXRISCV_REGRESSION_THREAD_COUNT", Runtime.getRuntime().availableProcessors().toString)} ") + s" SEED=${testSeed} "
//      val stdCmd = "make clean run REDO=40 DHRYSTONE=no STOP_ON_ERROR=yes TRACE=yess MMU=no"

      val testCmd = stdCmd + (positionsToApply).map(_.testParam).mkString(" ")
      println(testCmd)
      val str = doCmd(testCmd)
      assert(!str.contains("FAIL"))
//      val intFind = "(\\d+\\.?)+".r
//      val dmips = intFind.findFirstIn("DMIPS per Mhz\\:                              (\\d+.?)+".r.findAllIn(str).toList.last).get.toDouble
    }
  }

//  dimensions.foreach(d => d.positions.foreach(p => p.dimension = d))

  val testId : Option[mutable.HashSet[Int]] = None
  val seed = Random.nextLong()

//  val testId = Some(mutable.HashSet(18,34,77,85,118,129,132,134,152,167,175,188,191,198,199)) //37/29 sp_flop_rv32i_O3
//val testId = Some(mutable.HashSet(18))
//  val testId = Some(mutable.HashSet(129, 134))
//  val seed = -2412372746600605141l


//  val testId = Some(mutable.HashSet[Int](15))
//  val seed = -8861778219266506530l


  val rand = new Random(seed)

  test("Info"){
    println(s"MAIN_SEED=$seed")
  }
  println(s"Seed=$seed")
  for(i <- 0 until sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_COUNT", "100").toInt){
    var positions : List[VexRiscvPosition] = null
    val universe = VexRiscvUniverse.universes.filter(e => rand.nextBoolean())

    do{
      positions = dimensions.map(d => d.randomPosition(universe, rand))
    }while(!positions.forall(_.isCompatibleWith(positions)))

    val testSeed = rand.nextInt()
    if(testId.isEmpty || testId.get.contains(i))
      doTest(positions," random_" + i + "_", testSeed)
  }

//  println(s"${usedPositions.size}/$positionsCount positions")

//  for (dimension <- dimensions) {
//    for (position <- dimension.positions/* if position.name.contains("Cached")*/) {
//      for(defaults <- genDefaultsPositions(dimensions.filter(_ != dimension))){
//        doTest(position :: defaults)
//      }
//    }
//  }
}



/*
val seed = -2412372746600605141l

129
FAIL AltQTest_rv32i_O3
FAIL AltQTest_rv32ic_O3
FAIL GenQTest_rv32i_O0

134
FAIL AltQTest_rv32i_O3

  val seed = 4331444545509090137l
1 => flops i O0
 */