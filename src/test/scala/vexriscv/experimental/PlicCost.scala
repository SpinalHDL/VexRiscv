package vexriscv.experimental

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.eda.bench.{Bench, Rtl, XilinxStdTargets}
import spinal.lib.eda.icestorm.IcestormStdTargets
import spinal.lib.misc.plic._
import vexriscv.VexRiscv
import vexriscv.demo.LinuxGen

import scala.collection.mutable.ArrayBuffer

class PlicBench(inputCount : Int) extends Component{
  val io = new Bundle {
    val apb = slave(Apb3(addressWidth = 16, dataWidth = 32))
    val interrupts = in Bits(inputCount bits)
    val cpuInterrupt = out Bool()
  }


  val priorityWidth = 1
  val gateways = ArrayBuffer[PlicGateway]()

  for(i <- 0 until inputCount) {
    gateways += PlicGatewayActiveHigh(
      source = io.interrupts(i),
      id = 1 + i,
      priorityWidth = priorityWidth
    )
  }


  val targets = Seq(
    PlicTarget(
      gateways = gateways,
      priorityWidth = priorityWidth
    )
  )
  io.cpuInterrupt := targets(0).iep

  val plicMapping = PlicMapping.light.copy(
//      gatewayPriorityReadGen = true,
//      gatewayPendingReadGen = true,
//      targetThresholdReadGen = true
  )

  gateways.foreach(_.priority := 1)
  targets.foreach(_.threshold := 0)
  //      targets.foreach(_.ie.foreach(_ := True))

  val bus = Apb3SlaveFactory(io.apb)
  val mapping = PlicMapper(bus, plicMapping)(
    gateways = gateways,
    targets = targets
  )
}


object PlicCost extends App{
  def rtlGen(inputCount : Int) = new Rtl {
    override def getName(): String = s"PlicBench$inputCount"
    override def getRtlPath(): String = s"PlicBench$inputCount.v"
    SpinalVerilog(new PlicBench(inputCount).setDefinitionName(getRtlPath().split("\\.").head))
  }

  val rtls = List(8, 12, 16, 32).map(rtlGen)
  //    val rtls = List(smallestNoCsr, smallest, smallAndProductive, smallAndProductiveWithICache)
  //      val rtls = List(smallAndProductive, smallAndProductiveWithICache, fullNoMmuMaxPerf, fullNoMmu, full)
  //    val rtls = List(fullNoMmu)

  val targets = IcestormStdTargets().take(1)


  Bench(rtls, targets, "/eda/tmp")
}
