package vexriscv.periph.gcd

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config, Apb3SlaveFactory}
import spinal.lib.eda.altera.QSysify
import spinal.lib.slave

object Apb3GCDCtrl {
  def getApb3Config = Apb3Config(
    addressWidth = 5,
    dataWidth = 32,
    selWidth = 1,
    useSlaveError = false
  )
}

class Apb3GCDCtrl(apb3Config : Apb3Config) extends Component {
  val io = new Bundle {
      val apb = slave(Apb3(Apb3GCDCtrl.getApb3Config))
      // maybe later
      // val interrupt = out Bool
  }
  val gcdCtrl = new GCDTop()
  val apbCtrl = Apb3SlaveFactory(io.apb)
  apbCtrl.driveAndRead(gcdCtrl.io.a, address=0)
  apbCtrl.driveAndRead(gcdCtrl.io.b, address=4)
  // when result of calculation ready, synchronize it into memory mapped register
  val resSyncBuf = RegNextWhen(gcdCtrl.io.res, gcdCtrl.io.ready)
  apbCtrl.read(resSyncBuf, address=8)
  // if result is read, it will be consumed, set ready to 0
  apbCtrl.onRead(8)(resSyncBuf := 0)
  apbCtrl.onRead(8)(rdySyncBuf := False)
  // synchronize ready signal into memory mapped register
  val rdySyncBuf = RegNextWhen(gcdCtrl.io.ready, gcdCtrl.io.ready)
  apbCtrl.read(rdySyncBuf, address=12)
  // set valid based on memory mapped register but clear/consume it after 1 cycle <s
  gcdCtrl.io.valid := apbCtrl.setOnSet(RegNext(False) init(False), address=16, 0)
}
