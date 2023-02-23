package vexriscv

import java.io.{File, OutputStream}
import java.util.concurrent.{ForkJoinPool, TimeUnit}
import org.apache.commons.io.FileUtils
import org.scalatest.{BeforeAndAfterAll, ParallelTestExecution, Tag, Transformer}
import org.scalatest.funsuite.AnyFunSuite

import spinal.core._
import spinal.lib.DoCmd
import vexriscv.demo._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.plugin._

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, ExecutionContext, Future}
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
  val CACHE_ALL = new VexRiscvUniverse
  val CATCH_ALL = new VexRiscvUniverse
  val MMU = new VexRiscvUniverse
  val PMP = new VexRiscvUniverse
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



    l = new VexRiscvPosition("MulDivFpgaSimple") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new MulSimplePlugin
        config.plugins += new MulDivIterativePlugin(
          genMul = false,
          genDiv = true,
          mulUnrollFactor = 32,
          divUnrollFactor = 1
        )
      }
    } :: l

    if(!noMemory && !noWriteBack) l = new VexRiscvPosition("MulDivFpga16BitsDsp") {
      override def testParam = "MUL=yes DIV=yes"
      override def applyOn(config: VexRiscvConfig): Unit = {
        config.plugins += new Mul16Plugin
        config.plugins += new MulDivIterativePlugin(
          genMul = false,
          genDiv = true,
          mulUnrollFactor = 32,
          divUnrollFactor = 1
        )
      }
    } :: l

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


    if(!noMemory && !noWriteBack) {
      val inputBuffer = r.nextBoolean()
      val outputBuffer = r.nextBoolean()
      l = new VexRiscvPosition(s"MulDivFpga$inputBuffer$outputBuffer") {
          override def testParam = "MUL=yes DIV=yes"

          override def applyOn(config: VexRiscvConfig): Unit = {
            config.plugins += new MulPlugin(
              inputBuffer = inputBuffer,
              outputBuffer = outputBuffer
            )
            config.plugins += new MulDivIterativePlugin(
              genMul = false,
              genDiv = true,
              mulUnrollFactor = 32,
              divUnrollFactor = 1
            )
          }
        } :: l
    }

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


class IBusDimension(rvcRate : Double) extends VexRiscvDimension("IBus") {


  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val cacheAll = universes.contains(VexRiscvUniverse.CACHE_ALL)

    if(r.nextDouble() < 0.5 && !cacheAll){
      val mmuConfig = if(universes.contains(VexRiscvUniverse.MMU)) MmuPortConfig( portTlbSize = 4) else null

      val latency = r.nextInt(5) + 1
      val compressed = r.nextDouble() < rvcRate
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
      val twoStageMmu = r.nextBoolean()
      val asyncTagMemory = r.nextBoolean()
      val mmuConfig = if(universes.contains(VexRiscvUniverse.MMU)) MmuPortConfig(portTlbSize = 4, latency = if(twoStageMmu) 1 else 0, earlyRequireMmuLockup = Random.nextBoolean() && twoStageMmu, earlyCacheHits = Random.nextBoolean() && twoStageMmu) else null

      val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
      val compressed = r.nextDouble() < rvcRate
      val tighlyCoupled = r.nextBoolean() && !catchAll
      val reducedBankWidth = r.nextBoolean()
//      val tighlyCoupled = false
      val prediction = random(r, List(NONE, STATIC, DYNAMIC, DYNAMIC_TARGET))
      val relaxedPcCalculation, twoCycleCache, injectorStage = r.nextBoolean()
      val twoCycleRam = r.nextBoolean() && twoCycleCache
      val twoCycleRamInnerMux = r.nextBoolean() && twoCycleRam
      val memDataWidth = List(32,64,128)(r.nextInt(3))
      val bytePerLine = Math.max(memDataWidth/8, List(8,16,32,64)(r.nextInt(4)))
      var cacheSize = 0
      var wayCount = 0
      do{
        cacheSize = 512 << r.nextInt(5)
        wayCount = 1 << r.nextInt(3)
      }while(cacheSize/wayCount < 512 || (catchAll && cacheSize/wayCount > 4096))

      new VexRiscvPosition(s"Cached${memDataWidth}d" + (if(twoCycleCache) "2cc" else "") + (if(injectorStage) "Injstage" else "") + (if(twoCycleRam) "2cr" else "")  + "S" + cacheSize + "W" + wayCount + "BPL" + bytePerLine + (if(relaxedPcCalculation) "Relax" else "") + (if(compressed) "Rvc" else "") + prediction.getClass.getTypeName().replace("$","")+ (if(tighlyCoupled)"Tc" else "") + (if(asyncTagMemory) "Atm" else "")) with InstructionAnticipatedPosition{
        override def testParam = s"IBUS=CACHED IBUS_DATA_WIDTH=$memDataWidth" + (if(compressed) " COMPRESSED=yes" else "") + (if(tighlyCoupled)" IBUS_TC=yes" else "")
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
              memDataWidth = memDataWidth,
              catchIllegalAccess = catchAll,
              catchAccessFault = catchAll,
              asyncTagMemory = asyncTagMemory,
              twoCycleRam = twoCycleRam,
              twoCycleCache = twoCycleCache,
              twoCycleRamInnerMux = twoCycleRamInnerMux,
              reducedBankWidth = reducedBankWidth
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
    val cacheAll = universes.contains(VexRiscvUniverse.CACHE_ALL)
    val noMemory = universes.contains(VexRiscvUniverse.NO_MEMORY)
    val noWriteBack = universes.contains(VexRiscvUniverse.NO_WRITEBACK)

    if((r.nextDouble() < 0.4 || noMemory) && !cacheAll){
      val mmuConfig = if(universes.contains(VexRiscvUniverse.MMU)) MmuPortConfig( portTlbSize = 4, latency = 0) else null
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
      val twoStageMmu = r.nextBoolean() && !noMemory && !noWriteBack
      val mmuConfig = if(universes.contains(VexRiscvUniverse.MMU)) MmuPortConfig(portTlbSize = 4, latency = if(twoStageMmu) 1 else 0, earlyRequireMmuLockup = Random.nextBoolean() && twoStageMmu, earlyCacheHits = Random.nextBoolean() && twoStageMmu) else null
      val memDataWidth = List(32,64,128)(r.nextInt(3))
      val cpuDataWidthChoices = List(32,64,128).filter(_ <= memDataWidth)
      val cpuDataWidth = cpuDataWidthChoices(r.nextInt(cpuDataWidthChoices.size))
      val bytePerLine = Math.max(memDataWidth/8, List(8,16,32,64)(r.nextInt(4)))
      var cacheSize = 0
      var wayCount = 0
      val withLrSc = catchAll
      val withSmp = withLrSc && r.nextBoolean()
      val withAmo = catchAll && r.nextBoolean() || withSmp
      val dBusRspSlavePipe = r.nextBoolean() || withSmp
      val relaxedMemoryTranslationRegister = r.nextBoolean()
      val earlyWaysHits = r.nextBoolean() && !noWriteBack
      val directTlbHit = r.nextBoolean() && mmuConfig.isInstanceOf[MmuPortConfig]
      val dBusCmdMasterPipe, dBusCmdSlavePipe = false //As it create test bench issues
      val asyncTagMemory = r.nextBoolean()

      do{
        cacheSize = 512 << r.nextInt(5)
        wayCount = 1 << r.nextInt(3)
      }while(cacheSize/wayCount < 512 || (catchAll && cacheSize/wayCount > 4096))
      new VexRiscvPosition(s"Cached${memDataWidth}d${cpuDataWidth}c" + "S" + cacheSize + "W" + wayCount + "BPL" + bytePerLine + (if(dBusCmdMasterPipe) "Cmp " else "") + (if(dBusCmdSlavePipe) "Csp " else "") + (if(dBusRspSlavePipe) "Rsp " else "") + (if(relaxedMemoryTranslationRegister) "Rmtr " else "") + (if(earlyWaysHits) "Ewh " else "") + (if(withAmo) "Amo " else "") + (if(withSmp) "Smp " else "") + (if(directTlbHit) "Dtlb " else "") + (if(twoStageMmu) "Tsmmu " else "") + (if(asyncTagMemory) "Atm" else "")) {
        override def testParam = s"DBUS=CACHED DBUS_LOAD_DATA_WIDTH=$memDataWidth DBUS_STORE_DATA_WIDTH=$cpuDataWidth " + (if(withLrSc) "LRSC=yes " else "")  + (if(withAmo) "AMO=yes " else "")  + (if(withSmp) "DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes " else "")

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize = cacheSize,
              bytePerLine = bytePerLine,
              wayCount = wayCount,
              addressWidth = 32,
              cpuDataWidth = cpuDataWidth, //Not tested
              memDataWidth = memDataWidth,
              catchAccessError = catchAll,
              catchIllegal = catchAll,
              catchUnaligned = catchAll,
              withLrSc = withLrSc,
              withAmo = withAmo,
              earlyWaysHits = earlyWaysHits,
              withExclusive = withSmp,
              withInvalidate = withSmp,
              directTlbHit = directTlbHit,
              asyncTagMemory = asyncTagMemory
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


class MmuPmpDimension extends VexRiscvDimension("DBus") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    if(universes.contains(VexRiscvUniverse.MMU)) {
      new VexRiscvPosition("WithMmu") {
        override def testParam = "MMU=yes PMP=no"

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new MmuPlugin(
            ioRange = (x => x(31 downto 28) === 0xF)
          )
        }
      }
    } else if (universes.contains(VexRiscvUniverse.PMP)) {
      new VexRiscvPosition("WithPmp") {
        override def testParam = "MMU=no PMP=yes"

        override def applyOn(config: VexRiscvConfig): Unit = {
          config.plugins += new PmpPlugin(
            regions = 16,
            granularity = 32,
            ioRange = _ (31 downto 28) === 0xF
          )
        }
      }
    } else {
      new VexRiscvPosition("NoMemProtect") {
        override def testParam = "MMU=no PMP=no"

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


class CsrDimension(freertos : String, zephyr : String, linux : String) extends VexRiscvDimension("Csr") {
  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val pmp = universes.contains(VexRiscvUniverse.PMP)
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    val supervisor = universes.contains(VexRiscvUniverse.SUPERVISOR)
    if(supervisor){
      new VexRiscvPosition("Supervisor") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.linuxFull(0x80000020l))
        override def testParam = s"FREERTOS=$freertos ZEPHYR=$zephyr LINUX_REGRESSION=$linux SUPERVISOR=yes CSR=yes"
      }
    } else if(pmp){
      new VexRiscvPosition("Secure") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.secure(0x80000020l))
        override def testParam = s"CSR=yes CSR_SKIP_TEST=yes FREERTOS=$freertos ZEPHYR=$zephyr"
      }
    } else if(catchAll){
      new VexRiscvPosition("MachineOs") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l))
        override def testParam = s"CSR=yes CSR_SKIP_TEST=yes FREERTOS=$freertos ZEPHYR=$zephyr"
      }
    } else if(r.nextDouble() < 0.3){
      new VexRiscvPosition("AllNoException") with CatchAllPosition{
        override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new CsrPlugin(CsrPluginConfig.all(0x80000020l).noExceptionButEcall)
        override def testParam = s"CSR=yes CSR_SKIP_TEST=yes FREERTOS=$freertos ZEPHYR=$zephyr"
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
      override def testParam = "CONCURRENT_OS_EXECUTIONS=yes"
    }
  ))
}

class DecoderDimension extends VexRiscvDimension("Decoder") {

  override def randomPositionImpl(universes: Seq[ConfigUniverse], r: Random) = {
    val catchAll = universes.contains(VexRiscvUniverse.CATCH_ALL)
    new VexRiscvPosition("") {
      override def applyOn(config: VexRiscvConfig): Unit = config.plugins += new DecoderSimplePlugin(
        catchIllegalInstruction = catchAll,
        throwIllegalInstruction = false
      )

//      override def isCompatibleWith(positions: Seq[ConfigPosition[VexRiscvConfig]]) = catchAll == positions.exists(_.isInstanceOf[CatchAllPosition])
    }
  }
}

object PlayFuture extends App{
  implicit val ec = ExecutionContext.global
  val x =  for(i <- 0 until 160) yield Future {
    print(s"$i ")
    Thread.sleep(1000)
  }

  Thread.sleep(8000)
}

class MultithreadedFunSuite(threadCount : Int) extends AnyFunSuite {
  val finalThreadCount = if(threadCount > 0) threadCount else {
    new oshi.SystemInfo().getHardware.getProcessor.getLogicalProcessorCount
  }
  implicit val ec = ExecutionContext.fromExecutorService(
    new ForkJoinPool(finalThreadCount, ForkJoinPool.defaultForkJoinWorkerThreadFactory, null, true)
  )
  class Job(body : => Unit){
    val originalOutput = Console.out
    val buffer = mutable.Queue[Char]()
    var bufferEnabled = true
    def redirector() = new OutputStream{
      override def write(i: Int): Unit = synchronized {
        if(bufferEnabled) buffer += i.toChar
        else originalOutput.print(i.toChar)
      }
    }
    val future = Future{
      Console.withOut(redirector()){
        Console.withErr(redirector())(body)
      }
    }

    def join(): Unit = {
      Thread.sleep(50)
      synchronized{
        bufferEnabled = false
        buffer.foreach(originalOutput.print)
      }
      Await.result(future, Duration.Inf)
    }
  }

  def testMp(testName: String, testTags: Tag*)(testFun: => Unit) {
    val job = new Job(testFun)
    super.test(testName, testTags :_*)(job.join())
  }
  protected def testSingleThread(testName: String, testTags: Tag*)(testFun: => Unit) {
    super.test(testName, testTags :_*)(testFun)
  }
}


class FunTestPara extends MultithreadedFunSuite(3){
  def createTest(name : String): Unit ={
    testMp(name){
      for(i <- 0 to 4) {
        println(s"$name $i")
        Thread.sleep(500)
      }
    }
  }
  (0 to 80).map(_.toString).foreach(createTest)
}

//class FunTestPlay extends FunSuite {
//  def createTest(name : String): Unit ={
//    test(name){
//      Thread.sleep(500)
//      for(i <- 0 to 4) {
//        println(s"$name    $i")
//        Thread.sleep(500)
//      }
//    }
//  }
//  (0 to 80).map(_.toString).foreach(createTest)
//}

class TestIndividualFeatures extends MultithreadedFunSuite(sys.env.getOrElse("VEXRISCV_REGRESSION_THREAD_COUNT", "0").toInt) {
  val testCount = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_COUNT", "100").toInt
  val seed = sys.env.getOrElse("VEXRISCV_REGRESSION_SEED", Random.nextLong().toString).toLong
  val testId : Set[Int] =  sys.env.get("VEXRISCV_REGRESSION_TEST_ID") match {
    case Some(x) if x != "" => x.split(',').map(_.toInt).toSet
    case _ => (0 until testCount).toSet
  }
  val rvcRate = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_RVC_RATE", "0.5").toDouble
  val linuxRate = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_LINUX_RATE", "0.3").toDouble
  val machineOsRate = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_MACHINE_OS_RATE", "0.5").toDouble
  val secureRate = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_SECURE_RATE", "0.2").toDouble
  val linuxRegression = sys.env.getOrElse("VEXRISCV_REGRESSION_LINUX_REGRESSION", "yes")
  val coremarkRegression = sys.env.getOrElse("VEXRISCV_REGRESSION_COREMARK", "yes")
  val zephyrCount = sys.env.getOrElse("VEXRISCV_REGRESSION_ZEPHYR_COUNT", "4")
  val demwRate = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_DEMW_RATE", "0.6").toDouble
  val demRate = sys.env.getOrElse("VEXRISCV_REGRESSION_CONFIG_DEM_RATE", "0.5").toDouble
  val stopOnError = sys.env.getOrElse("VEXRISCV_REGRESSION_STOP_ON_ERROR", "no")
  val lock = new{}



  val dimensions = List(
    new IBusDimension(rvcRate),
    new DBusDimension,
    new MulDivDimension,
    new ShiftDimension,
    new BranchDimension,
    new HazardDimension,
    new RegFileDimension,
    new SrcDimension,
    new CsrDimension(/*sys.env.getOrElse("VEXRISCV_REGRESSION_FREERTOS_COUNT", "1")*/ "0", zephyrCount, linuxRegression), //Freertos old port software is broken
    new DecoderDimension,
    new DebugDimension,
    new MmuPmpDimension
  )

  var clockCounter = 0l
  var startAt = System.currentTimeMillis()
  def doTest(positionsToApply : List[VexRiscvPosition], prefix : String = "", testSeed : Int, universes : mutable.HashSet[VexRiscvUniverse]): Unit ={
    val noMemory = universes.contains(VexRiscvUniverse.NO_MEMORY)
    val noWriteback = universes.contains(VexRiscvUniverse.NO_WRITEBACK)
    val name = (if(noMemory) "noMemoryStage_" else "") + (if(noWriteback) "noWritebackStage_" else "") + positionsToApply.map(d => d.dimension.name + "_" + d.name).mkString("_")
    val workspace = "simWorkspace"
    val project = s"$workspace/$prefix"
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
      Process(cmd, new File(project)).!(new Logger)
      stdOut.toString()
    }

    testMp(prefix + name) {
      println("START TEST " + prefix + name)

      //Cleanup
      FileUtils.deleteDirectory(new File(project))
      FileUtils.forceMkdir(new File(project))

      //Generate RTL
      FileUtils.deleteQuietly(new File("VexRiscv.v"))
      SpinalConfig(targetDirectory = project).generateVerilog{
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

      //Setup test
      val files = List("main.cpp", "jtag.h", "encoding.h" ,"makefile", "dhrystoneO3.logRef", "dhrystoneO3C.logRef","dhrystoneO3MC.logRef","dhrystoneO3M.logRef")
      files.foreach(f => FileUtils.copyFileToDirectory(new File(s"src/test/cpp/regression/$f"), new File(project)))

      //Test RTL
      val debug = true
      val stdCmd = (s"make run REGRESSION_PATH=../../src/test/cpp/regression VEXRISCV_FILE=VexRiscv.v WITH_USER_IO=no REDO=10 TRACE=${if(debug) "yes" else "no"} TRACE_START=100000000000ll FLOW_INFO=no STOP_ON_ERROR=$stopOnError DHRYSTONE=yes COREMARK=${coremarkRegression} THREAD_COUNT=1 ") + s" SEED=${testSeed} "
      val testCmd = stdCmd + (positionsToApply).map(_.testParam).mkString(" ")
      println(testCmd)
      val str = doCmd(testCmd)
      assert(str.contains("REGRESSION SUCCESS") && !str.contains("Broken pipe"))
      val pattern = "Had simulate ([0-9]+)".r
      val hit = pattern.findFirstMatchIn(str)

      lock.synchronized(clockCounter += hit.get.group(1).toLong)
    }
  }

  val rand = new Random(seed)

  testMp("Info"){
    println(s"MAIN_SEED=$seed")
  }
  println(s"Seed=$seed")
  for(i <- 0 until testCount){
    var positions : List[VexRiscvPosition] = null
    var universe = mutable.HashSet[VexRiscvUniverse]()
    if(rand.nextDouble() < 0.5) universe += VexRiscvUniverse.EXECUTE_RF
    if(linuxRate > rand.nextDouble()) {
      universe += VexRiscvUniverse.CATCH_ALL
      universe += VexRiscvUniverse.MMU
      universe += VexRiscvUniverse.FORCE_MULDIV
      universe += VexRiscvUniverse.SUPERVISOR
      if(demwRate < rand.nextDouble()){
        universe += VexRiscvUniverse.NO_WRITEBACK
      }
    } else if (secureRate > rand.nextDouble()) {
        universe += VexRiscvUniverse.CACHE_ALL
        universe += VexRiscvUniverse.CATCH_ALL
        universe += VexRiscvUniverse.PMP
        if(demwRate < rand.nextDouble()){
          universe += VexRiscvUniverse.NO_WRITEBACK
        }
    } else {
      if(machineOsRate > rand.nextDouble()) {
        universe += VexRiscvUniverse.CATCH_ALL
        if(demwRate < rand.nextDouble()){
          universe += VexRiscvUniverse.NO_WRITEBACK
        }
      }
      if(demwRate > rand.nextDouble()){
      }else if(demRate > rand.nextDouble()){
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
    if(testId.contains(i))
      doTest(positions,"test_id_" + i + "_", testSeed, universe)
    Hack.dCounter += 1
  }
  testSingleThread("report"){
    val time = (System.currentTimeMillis() - startAt)*1e-3
    val clockPerSecond = (clockCounter/time*1e-3).toLong
    println(s"Duration=${(time/60).toInt}mn clocks=${(clockCounter*1e-6).toLong}M clockPerSecond=${clockPerSecond}K")
  }
}


object TestIndividualExplore extends App{
  val seeds = mutable.HashSet[Int]()
  val futures = mutable.ArrayBuffer[Future[Unit]]()
  implicit val ec = ExecutionContext.fromExecutorService(
    new ForkJoinPool(24, ForkJoinPool.defaultForkJoinWorkerThreadFactory, null, true)
  )
  for(i <- 0 until 1000){
    val seed = Random.nextInt(1000000) + 1
    futures += Future {
      if (!seeds.contains(seed)) {
//        val cmd = s"make run REGRESSION_PATH=../../src/test/cpp/regression VEXRISCV_FILE=VexRiscv.v WITH_USER_IO=no REDO=1 TRACE=yes TRACE_START=100000000000ll FLOW_INFO=no STOP_ON_ERROR=no DHRYSTONE=yes COREMARK=mo THREAD_COUNT=1   IBUS=CACHED IBUS_DATA_WIDTH=128 COMPRESSED=yes DBUS=SIMPLE LRSC=yes  MUL=yes DIV=yes      FREERTOS=0 ZEPHYR=0 LINUX_REGRESSION=no SUPERVISOR=yes  CONCURRENT_OS_EXECUTIONS=yes MMU=yes PMP=no SEED=$seed"
        val cmd = s"make run REGRESSION_PATH=../../src/test/cpp/regression VEXRISCV_FILE=VexRiscv.v WITH_USER_IO=no REDO=10 TRACE=yes TRACE_START=100000000000ll FLOW_INFO=no STOP_ON_ERROR=no DHRYSTONE=yes COREMARK=yes THREAD_COUNT=1   IBUS=CACHED IBUS_DATA_WIDTH=128 COMPRESSED=yes DBUS=SIMPLE LRSC=yes  MUL=yes DIV=yes      FREERTOS=0 ZEPHYR=2 LINUX_REGRESSION=yes SUPERVISOR=yes  CONCURRENT_OS_EXECUTIONS=yes MMU=yes PMP=no SEED=$seed"
        val workspace = s"explor/seed_$seed"
        FileUtils.copyDirectory(new File("simWorkspace/ref"), new File(workspace))
        val str = DoCmd.doCmdWithLog(cmd, workspace)
        if(!str.contains("REGRESSION SUCCESS")){
          println(s"seed $seed FAILED with\n\n$str")
          sys.exit(1)
        }
        FileUtils.deleteDirectory(new File(workspace))
        println(s"seed $seed PASSED")
      }
    }
  }

  futures.foreach(Await.result(_, Duration.Inf))

}