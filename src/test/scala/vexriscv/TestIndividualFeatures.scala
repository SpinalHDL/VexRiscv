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
  val FORCE_MULDIV = new VexRiscvUniverse
  val SUPERVISOR = new VexRiscvUniverse
  val NO_WRITEBACK = new VexRiscvUniverse
  val NO_MEMORY = new VexRiscvUniverse
  val EXECUTE_RF = new VexRiscvUniverse
}


object Hack{
  var dCounter = 0
}

class ShiftDimension extends VexRiscvDimension("Shift") {
  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    var l = List(
      new VexRiscvPosition("FullEarly") {
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new FullBarrelShifterPlugin(earlyInjection = true)
      },
      new VexRiscvPosition("Light") {
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new LightShifterPlugin
      }
    )

    if(!universes.contains(VexRiscvUniverse.NO_MEMORY)) l = new VexRiscvPosition("FullLate") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new FullBarrelShifterPlugin(earlyInjection = false)
    } :: l

    random(r, l)
  }
}

class BranchDimension extends VexRiscvDimension("Branch") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val early = r.nextBoolean() || universes.contains(VexRiscvUniverse.NO_MEMORY)
    new VexRiscvPosition(if(early) "Early" else "Late") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new BranchPlugin(
        earlyBranch = early,
        catchAddressMisaligned = catchAll
      )
    }
  }
}



class MulDivDimension extends VexRiscvDimension("MulDiv") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val noMemory = universes.contains(VexRiscvUniverse.NO_MEMORY)
    val noWriteBack = universes.contains(VexRiscvUniverse.NO_WRITEBACK)

    var l = List[VexRiscvPosition]()
    if(!noMemory) {
      l =  new VexRiscvPosition("MulDivAsic") {
        override def testParam = "MUL=yes DIV=yes"
        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new MulDivIterativePlugin(
            genMul = true,
            genDiv = true,
            mulUnrollFactor = 32,
            divUnrollFactor = 4
          )
        }
      } :: new VexRiscvPosition("MulDivFpgaNoDsp") {
        override def testParam = "MUL=yes DIV=yes"
        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new MulDivIterativePlugin(
            genMul = true,
            genDiv = true,
            mulUnrollFactor = 1,
            divUnrollFactor = 1
          )
        }
      } :: new VexRiscvPosition("MulDivFpgaNoDspFastMul") {
        override def testParam = "MUL=yes DIV=yes"
        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new MulDivIterativePlugin(
            genMul = true,
            genDiv = true,
            mulUnrollFactor = 8,
            divUnrollFactor = 1
          )
        }
      } :: l
    }

    if(!universes.contains(VexRiscvUniverse.FORCE_MULDIV)) l = new VexRiscvPosition("NoMulDiv") {
      override def applyOn(config: VexRiscvConfig): Unit = {}
      override def testParam = "MUL=no DIV=no"
    } :: l


    if(!noMemory && !noWriteBack) l =
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
      } :: l

    random(r, l)
  }
}

trait InstructionAnticipatedPosition{
  def instructionAnticipatedOk() : Boolean
}

class RegFileDimension extends VexRiscvDimension("RegFile") {
  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val executeRf = universes.contains(VexRiscvUniverse.EXECUTE_RF)
    random(r, List(
      new VexRiscvPosition("Async" + (if(executeRf) "ER" else "DR")) {
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new RegFilePlugin(
          regFileReadyKind = plugin.ASYNC,
          zeroBoot = true,
          readInExecute = executeRf
        )
      },
      new VexRiscvPosition("Sync" + (if(executeRf) "ER" else "DR")) {
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new RegFilePlugin(
          regFileReadyKind = plugin.SYNC,
          zeroBoot = true,
          readInExecute = executeRf
        )

        override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = executeRf || positions.exists{
          case p : InstructionAnticipatedPosition => p.instructionAnticipatedOk()
          case _ => false
        }
      }
    ))
  }
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
    val separatedAddSub = r.nextBoolean()
    val executeInsertion = universes.contains(VexRiscvUniverse.EXECUTE_RF) || r.nextBoolean()
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
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val mmuConfig = if(universes.contains(VexRiscvUniverse.MMU)) MmuPortConfig( portTlbSize = 4) else null

    if(r.nextDouble() < 0.5){
      val latency = r.nextInt(5) + 1
      val compressed = r.nextBoolean()
      val injectorStage = r.nextBoolean() || latency == 1
      val prediction = random(r, List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET))
      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      val cmdForkOnSecondStage = r.nextBoolean()
      val cmdForkPersistence = r.nextBoolean()
      new VexRiscvPosition("Simple" + latency + (if(cmdForkOnSecondStage) "S2" else "") + (if(cmdForkPersistence) "P" else "")  + (if(injectorStage) "InjStage" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")) with InstructionAnticipatedPosition{
        override def testParam = "IBUS=SIMPLE" + (if(compressed) " COMPRESSED=yes" else "")
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new IBusSimplePlugin(
          resetVector = 0x80000000l,
          cmdForkOnSecondStage = cmdForkOnSecondStage,
          cmdForkPersistence = cmdForkPersistence,
          prediction = prediction,
          catchAccessFault = catchAll,
          compressedGen = compressed,
          busLatencyMin = latency,
          injectorStage = injectorStage,
          memoryTranslatorPortConfig = mmuConfig
        )
        override def instructionAnticipatedOk() = injectorStage
      }
    } else {
      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      val compressed = r.nextBoolean()
      val tighlyCoupled = r.nextBoolean() && !catchAll
//      val tighlyCoupled = false
      val prediction = random(r, List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET))
      val relaxedPcCalculation, twoCycleCache, injectorStage = r.nextBoolean()
      val twoCycleRam = r.nextBoolean() && twoCycleCache
      val bytePerLine = List(8,16,32,64)(r.nextInt(4))
      var cacheSize = 0
      var wayCount = 0
      do{
        cacheSize = 512 << r.nextInt(5)
        wayCount = 1 << r.nextInt(3)
      }while(cacheSize/wayCount < 512 || (catchAll && cacheSize/wayCount > 4096))

      new VexRiscvPosition("Cached" + (if(twoCycleCache) "2cc" else "") + (if(injectorStage) "Injstage" else "") + (if(twoCycleRam) "2cr" else "")  + "S" + cacheSize + "W" + wayCount + "BPL" + bytePerLine + (if(relaxedPcCalculation) "Relax" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")+ (if(tighlyCoupled)"Tc" else "")) with InstructionAnticipatedPosition{
        override def testParam = "IBUS=CACHED" + (if(compressed) " COMPRESSED=yes" else "") + (if(tighlyCoupled)" IBUS_TC=yes" else "")
        override def applyOn(config: VexRiscvConfig): Unit = {
          val p = new IBusCachedPlugin(
            resetVector = 0x80000000l,
            compressedGen = compressed,
            prediction = prediction,
            relaxedPcCalculation = relaxedPcCalculation,
            injectorStage = injectorStage,
            memoryTranslatorPortConfig = mmuConfig,
            config = InstructionCacheConfig(
              cacheSize = cacheSize,
              bytePerLine = bytePerLine,
              wayCount = wayCount,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchIllegalAccess = catchAll,
              catchAccessFault = catchAll,
              asyncTagMemory = false,
              twoCycleRam = twoCycleRam,
              twoCycleCache = twoCycleCache
            )
          )
          if(tighlyCoupled) p.newTightlyCoupledPort(TightlyCoupledPortParameter("iBusTc", a => a(30 downto 28) === 0x0))
          config.plugins += p
        }
        override def instructionAnticipatedOk() = !twoCycleCache || ((!twoCycleRam || wayCount == 1) && !compressed)
      }
    }
  }
}




class DBusDimension extends VexRiscvDimension("DBus") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val mmuConfig = if(universes.contains(VexRiscvUniverse.MMU)) MmuPortConfig( portTlbSize = 4) else null
    val noMemory = universes.contains(VexRiscvUniverse.NO_MEMORY)
    val noWriteBack = universes.contains(VexRiscvUniverse.NO_WRITEBACK)



    if(r.nextDouble() < 0.4 || noMemory || noWriteBack){
      val withLrSc = catchAll
      val earlyInjection = r.nextBoolean() && !universes.contains(VexRiscvUniverse.NO_WRITEBACK)
      new VexRiscvPosition("Simple" + (if(earlyInjection) "Early" else "Late")) {
        override def testParam = "DBUS=SIMPLE " + (if(withLrSc) "LRSC=yes " else "")
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DBusSimplePlugin(
          catchAddressMisaligned = catchAll,
          catchAccessFault = catchAll,
          earlyInjection = earlyInjection,
          memoryTranslatorPortConfig = mmuConfig,
          withLrSc = withLrSc
        )
//        override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
      }
    } else {
      val bytePerLine = List(8,16,32,64)(r.nextInt(4))
      var cacheSize = 0
      var wayCount = 0
      val withLrSc = catchAll
      val withAmo = catchAll && r.nextBoolean()
      val dBusRspSlavePipe, relaxedMemoryTranslationRegister, earlyWaysHits = r.nextBoolean()
      val dBusCmdMasterPipe, dBusCmdSlavePipe = false //As it create test bench issues

      do{
        cacheSize = 512 << r.nextInt(5)
        wayCount = 1 << r.nextInt(3)
      }while(cacheSize/wayCount < 512 || (catchAll && cacheSize/wayCount > 4096))
      new VexRiscvPosition("Cached" + "S" + cacheSize + "W" + wayCount + "BPL" + bytePerLine + (if(dBusCmdMasterPipe) "Cmp " else "") + (if(dBusCmdSlavePipe) "Csp " else "") + (if(dBusRspSlavePipe) "Rsp " else "") + (if(relaxedMemoryTranslationRegister) "Rmtr " else "") + (if(earlyWaysHits) "Ewh " else "")) {
        override def testParam = "DBUS=CACHED " + (if(withLrSc) "LRSC=yes " else "")  + (if(withAmo) "AMO=yes " else "")

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize = cacheSize,
              bytePerLine = bytePerLine,
              wayCount = wayCount,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchAccessError = catchAll,
              catchIllegal = catchAll,
              catchUnaligned = catchAll,
              withLrSc = withLrSc,
              withAmo = withAmo,
              earlyWaysHits = earlyWaysHits
            ),
            dBusCmdMasterPipe = dBusCmdMasterPipe,
            dBusCmdSlavePipe = dBusCmdSlavePipe,
            dBusRspSlavePipe = dBusRspSlavePipe,
            relaxedMemoryTranslationRegister = relaxedMemoryTranslationRegister,
            memoryTranslatorPortConfig = mmuConfig
          )
        }
      }
    }
  }
}


class MmuDimension extends VexRiscvDimension("DBus") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    if(universes.contains(VexRiscvUniverse.MMU)) {
      new VexRiscvPosition("WithMmu") {
        override def testParam = "MMU=yes"

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new MmuPlugin(
            ioRange = (x => x(31 downto 28) === 0xF)
          )
        }
      }
    } else {
      new VexRiscvPosition("NoMmu") {
        override def testParam = "MMU=no"

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new StaticMemoryTranslatorPlugin(
            ioRange = _ (31 downto 28) === 0xF
          )
        }
      }
    }
  }
}



trait CatchAllPosition


class CsrDimension(freertos : String, zephyr : String) extends VexRiscvDimension("Csr") {
  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val supervisor = universes.contains(VexRiscvUniverse.SUPERVISOR)
    if(supervisor){
      new VexRiscvPosition("Supervisor") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.linuxFull(0x80000020l))
        override def testParam = s"FREERTOS=$freertos ZEPHYR=$zephyr LINUX_REGRESSION=yes SUPERVISOR=yes"
      }
    } else if(catchAll){
      new VexRiscvPosition("MachineOs") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l))
        override def testParam = s"CSR=yes FREERTOS=$freertos ZEPHYR=$zephyr"
      }
    } else if(r.nextDouble() < 0.3){
      new VexRiscvPosition("AllNoException") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l).noException)
        override def testParam = s"CSR=yes CSR_SKIP_TEST=yes FREERTOS=$freertos"
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
    new CsrDimension(sys.env.getOrElse("VEXRISCV_REGRESSION_FREERTOS_COUNT", "1"), sys.env.getOrElse("VEXRISCV_REGRESSION_ZEPHYR_COUNT", "4")),
    new DecoderDimension,
    new DebugDimension,
    new MmuDimension
  )


//  def genDefaultsPositions(dims : Seq[VexRiscvDimension], stack : List[VexRiscvPosition] = Nil) : Seq[List[VexRiscvPosition]] = dims match {
//    case head :: tail => head.default.flatMap(p => genDefaultsPositions(tail, p :: stack))
//    case Nil => List(stack)
//  }

//  val usedPositions = mutable.HashSet[VexRiscvPosition]();
//  val positionsCount = dimensions.map(d => d.positions.length).sum

  def doTest(positionsToApply : List[VexRiscvPosition], prefix : String = "", testSeed : Int, universes : mutable.HashSet[VexRiscvUniverse]): Unit ={
//    usedPositions ++= positionsToApply
    val noMemory = universes.contains(VexRiscvUniverse.NO_MEMORY)
    val noWriteback = universes.contains(VexRiscvUniverse.NO_WRITEBACK)
    def gen = {
      FileUtils.deleteQuietly(new File("VexRiscv.v"))
      SpinalVerilog{
        val config = VexRiscvConfig(
          withMemoryStage = !noMemory,
          withWriteBackStage = !noWriteback,
          plugins = List(
            new IntAluPlugin,
            new YamlPlugin("cpu0.yaml")
          )
        )
        for (positionToApply <- positionsToApply) positionToApply.applyOn(config)
        new VexRiscv(config)
      }
    }

    val name = (if(noMemory) "noMemoryStage_" else "") + (if(noWriteback) "noWritebackStage_" else "") + positionsToApply.map(d => d.dimension.name + "_" + d.name).mkString("_")
    test(prefix + name + "_gen") {
      gen
    }


    test(prefix + name + "_test") {
      val debug = true
      val stdCmd = (s"make clean run WITH_USER_IO=no REDO=10 TRACE=${if(debug) "yes" else "no"} TRACE_START=9999924910246l FLOW_INFO=no STOP_ON_ERROR=no DHRYSTONE=yes COREMARK=yes THREAD_COUNT=${sys.env.getOrElse("VEXRISCV_REGRESSION_THREAD_COUNT", 1)} ") + s" SEED=${testSeed} "
      val testCmd = stdCmd + (positionsToApply).map(_.testParam).mkString(" ")
      println(testCmd)
      val str = doCmd(testCmd)
      assert(str.contains("REGRESSION SUCCESS") && !str.contains("Broken pipe"))
    }
  }

//  dimensions.foreach(d => d.positions.foreach(p => p.dimension = d))

  val testId : Option[mutable.HashSet[Int]] = None
  val seed = Random.nextLong()

//  val testId = Some(mutable.HashSet(18,34,77,85,118,129,132,134,152,167,175,188,191,198,199)) //37/29 sp_flop_rv32i_O3
//val testId = Some(mutable.HashSet(0))
//  val testId = Some(mutable.HashSet(4))
//  val seed = -8309068850561113754l


  val rand = new Random(seed)

  test("Info"){
    println(s"MAIN_SEED=$seed")
  }
  println(s"Seed=$seed")
  for(i <- 0 until sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_COUNT", "100").toInt){
    var positions : List[VexRiscvPosition] = null
    var universe = mutable.HashSet[VexRiscvUniverse]()
    if(rand.nextDouble() < 0.5) universe += VexRiscvUniverse.EXECUTE_RF
    if(sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_LINUX_RATE", "0.3").toDouble > rand.nextDouble()) {
      universe += VexRiscvUniverse.CATCH_ALL
      universe += VexRiscvUniverse.MMU
      universe += VexRiscvUniverse.FORCE_MULDIV
      universe += VexRiscvUniverse.SUPERVISOR
    } else {
      if(sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_MACHINE_OS_RATE", "0.5").toDouble > rand.nextDouble()) {
        universe += VexRiscvUniverse.CATCH_ALL
      }
      var tmp = rand.nextDouble()
      if(sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_DEMW_RATE", "0.6").toDouble > rand.nextDouble()){
      }else if(sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_DEM_RATE", "0.5").toDouble > rand.nextDouble()){
        universe += VexRiscvUniverse.NO_WRITEBACK
      } else {
        universe += VexRiscvUniverse.NO_WRITEBACK
        universe += VexRiscvUniverse.NO_MEMORY
      }
    }

    do{
      positions = dimensions.map(d => d.randomPosition(universe.toList, rand))
    }while(!positions.forall(_.isCompatibleWith(positions)))

    val testSeed = rand.nextInt()
    if(testId.isEmpty || testId.get.contains(i))
      doTest(positions," random_" + i + "_", testSeed, universe)
    Hack.dCounter += 1
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