/**
  * Thanks Efinix for funding the official RISC-V debug implementation on VexRiscv !
  */


package vexriscv.plugin

import spinal.core._
import spinal.lib._
import spinal.lib.com.jtag._
import spinal.lib.cpu.riscv.debug._
import vexriscv._


class EmbeddedRiscvJtag(var p : DebugTransportModuleParameter,
                        var withTap : Boolean = true,
                        var withTunneling : Boolean = false
                        ) extends Plugin[VexRiscv] with VexRiscvRegressionArg{


  override def getVexRiscvRegressionArgs() = List("DEBUG_PLUGIN=RISCV")

  var jtag : Jtag = null
  var jtagInstruction : JtagTapInstructionCtrl = null
  var ndmreset : Bool = null

//  val debugCd = Handle[ClockDomain].setName("debugCd")
//  val noTapCd = Handle[ClockDomain].setName("jtagCd")

  override def setup(pipeline: VexRiscv): Unit = {
    jtag = withTap generate slave(Jtag()).setName("jtag")
    jtagInstruction = !withTap generate slave(JtagTapInstructionCtrl()).setName("jtagInstruction")
    ndmreset = Bool().setName("ndmreset")
  }

  override def build(pipeline: VexRiscv): Unit = {
    val XLEN = 32
    val dm = DebugModule(
      DebugModuleParameter(
        version = p.version + 1,
        harts = 1,
        progBufSize = 2,
        datacount   = XLEN/32,
        xlens = List(XLEN)
      )
    )

    ndmreset := dm.io.ndmreset

    val dmiDirect = if(withTap && !withTunneling) new Area {
      val logic = DebugTransportModuleJtagTap(
        p.copy(addressWidth = 7),
        debugCd = ClockDomain.current
      )
      dm.io.ctrl <> logic.io.bus
      logic.io.jtag <> jtag
    }
    val dmiTunneled = if(withTap && withTunneling) new Area {
      val logic = DebugTransportModuleJtagTapWithTunnel(
        p.copy(addressWidth = 7),
        debugCd = ClockDomain.current
      )
      dm.io.ctrl <> logic.io.bus
      logic.io.jtag <> jtag
    }

    val privBus = pipeline.service(classOf[CsrPlugin]).debugBus.setAsDirectionLess()
    privBus <> dm.io.harts(0)
    privBus.dmToHart.removeAssignments() <-< dm.io.harts(0).dmToHart
  }
}

/*
make IBUS=CACHED IBUS_DATA_WIDTH=64 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=64 DBUS_STORE_DATA_WIDTH=64 LRSC=yes AMO=yes DBUS_EXCLUSIVE=yes DBUS_INVALIDATE=yes MUL=yes DIV=yes RVF=yes RVD=yes RISCV_JTAG=yes  REDO=1 WITH_RISCV_REF=no DEBUG_PLUGIN_EXTERNAL=yes DEBUG_PLUGIN=no
src/openocd -f ../VexRiscvOoo/src/main/tcl/openocd/naxriscv_sim.tcl -c "sleep 5000" -c "reg pc 0x80000000" -c "exit" -d3

mdw 0x1000 16
mww 0x1000 0x12345678
mdw 0x1000 16

load_image /media/data/open/VexRiscv/src/test/resources/hex/dhrystoneO3.hex 0 ihex
mdw 0x80000000 16
reg pc 0x80000000
bp 0x80000114 4
resume


mdw 0x1000 16
mww 0x1000 0x12345678
mdw 0x1000 16

#load_image /media/data/open/VexRiscv/src/test/resources/hex/dhrystoneO3.hex 0 ihex
mww 0x80000000 0x13
mww 0x80000004 0x13
reg pc 0x80000000
step; reg pc
*/
