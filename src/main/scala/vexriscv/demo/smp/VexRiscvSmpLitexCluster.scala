package vexriscv.demo.smp

import spinal.core._
import spinal.lib.bus.bmb._
import spinal.lib.bus.misc.{AddressMapping, DefaultMapping, SizeMapping}
import spinal.lib.sim.SparseMemory
import vexriscv.demo.smp.VexRiscvSmpClusterGen.vexRiscvConfig


case class VexRiscvLitexSmpClusterParameter( cluster : VexRiscvSmpClusterParameter,
                                             liteDram : LiteDramNativeParameter,
                                             liteDramMapping : AddressMapping)


class VexRiscvLitexSmpCluster(p : VexRiscvLitexSmpClusterParameter) extends VexRiscvSmpClusterWithPeripherals(p.cluster) {
  val iArbiter = BmbSmpBridgeGenerator()
  val iBridge = BmbToLiteDramGenerator(p.liteDramMapping)
  val dBridge = BmbToLiteDramGenerator(p.liteDramMapping)

  for(core <- cores) interconnect.addConnection(core.cpu.iBus -> List(iArbiter.bmb))
  interconnect.addConnection(
    iArbiter.bmb               -> List(iBridge.bmb, peripheralBridge.bmb),
    invalidationMonitor.output -> List(dBridge.bmb, peripheralBridge.bmb)
  )
  interconnect.masters(invalidationMonitor.output).withOutOfOrderDecoder()

  dBridge.liteDramParameter.load(p.liteDram)
  iBridge.liteDramParameter.load(p.liteDram)

  // Interconnect pipelining (FMax)
  for(core <- cores) {
    interconnect.setPipelining(core.cpu.dBus)(cmdValid = true, cmdReady = true, rspValid = true)
    interconnect.setPipelining(core.cpu.iBus)(cmdHalfRate = true, rspValid = true)
    interconnect.setPipelining(iArbiter.bmb)(cmdHalfRate = true, rspValid = true)
  }
  interconnect.setPipelining(invalidationMonitor.output)(cmdValid = true, cmdReady = true, rspValid = true)
  interconnect.setPipelining(peripheralBridge.bmb)(cmdHalfRate = true, rspValid = true)
}


object VexRiscvLitexSmpClusterGen extends App {
  for(cpuCount <- List(1,2,4,8)) {
    def parameter = VexRiscvLitexSmpClusterParameter(
      cluster = VexRiscvSmpClusterParameter(
        cpuConfigs = List.tabulate(cpuCount) { hartId =>
          vexRiscvConfig(
            hartId = hartId,
            ioRange = address => address.msb,
            resetVector = 0
          )
        }
      ),
      liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
      liteDramMapping = SizeMapping(0x40000000l, 0x40000000l)
    )

    def dutGen = {
      val toplevel = new VexRiscvLitexSmpCluster(
        p = parameter
      ).toComponent()
      toplevel
    }

    val genConfig = SpinalConfig().addStandardMemBlackboxing(blackboxByteEnables)
    //  genConfig.generateVerilog(Bench.compressIo(dutGen))
    genConfig.generateVerilog(dutGen.setDefinitionName(s"VexRiscvLitexSmpCluster_${cpuCount}c"))
  }
}

////addAttribute("""mark_debug = "true"""")
object VexRiscvLitexSmpClusterOpenSbi extends App{
  import spinal.core.sim._

  val simConfig = SimConfig
  simConfig.withWave
  simConfig.allOptimisation

  val cpuCount = 2

  def parameter = VexRiscvLitexSmpClusterParameter(
    cluster = VexRiscvSmpClusterParameter(
      cpuConfigs = List.tabulate(cpuCount) { hartId =>
        vexRiscvConfig(
          hartId = hartId,
          ioRange =  address => address(31 downto 28) === 0xF,
          resetVector = 0x80000000l
        )
      }
    ),
    liteDram = LiteDramNativeParameter(addressWidth = 32, dataWidth = 128),
    liteDramMapping = SizeMapping(0x80000000l, 0x70000000l)
  )

  def dutGen = {
    val top = new VexRiscvLitexSmpCluster(
      p = parameter
    ).toComponent()
    top.rework{
      top.clintWishbone.setAsDirectionLess.allowDirectionLessIo
      top.peripheral.setAsDirectionLess.allowDirectionLessIo.simPublic()

      val hit = (top.peripheral.ADR <<2 >= 0xF0010000l && top.peripheral.ADR<<2 < 0xF0020000l)
      top.clintWishbone.CYC := top.peripheral.CYC && hit
      top.clintWishbone.STB := top.peripheral.STB
      top.clintWishbone.WE := top.peripheral.WE
      top.clintWishbone.ADR := top.peripheral.ADR.resized
      top.clintWishbone.DAT_MOSI := top.peripheral.DAT_MOSI
      top.peripheral.DAT_MISO := top.clintWishbone.DAT_MISO
      top.peripheral.ACK := top.peripheral.CYC  && (!hit || top.clintWishbone.ACK)
      top.peripheral.ERR := False

//        top.dMemBridge.unburstified.cmd.simPublic()
    }
    top
  }
  simConfig.compile(dutGen).doSimUntilVoid(seed = 42){dut =>
    dut.debugCd.inputClockDomain.get.forkStimulus(10)

    val ram = SparseMemory()
    ram.loadBin(0x80000000l, "../opensbi/build/platform/spinal/vexriscv/sim/smp/firmware/fw_jump.bin")
    ram.loadBin(0xC0000000l, "../buildroot/output/images/Image")
    ram.loadBin(0xC1000000l, "../buildroot/output/images/dtb")
    ram.loadBin(0xC2000000l, "../buildroot/output/images/rootfs.cpio")


    dut.iBridge.dram.simSlave(ram, dut.debugCd.inputClockDomain)
    dut.dBridge.dram.simSlave(ram, dut.debugCd.inputClockDomain/*, dut.dMemBridge.unburstified*/)

    dut.interrupts.get #= 0

    dut.debugCd.inputClockDomain.get.onFallingEdges{
      if(dut.peripheral.CYC.toBoolean){
        (dut.peripheral.ADR.toLong << 2) match {
          case 0xF0000000l => print(dut.peripheral.DAT_MOSI.toLong.toChar)
          case 0xF0000004l => dut.peripheral.DAT_MISO #= (if(System.in.available() != 0) System.in.read() else 0xFFFFFFFFl)
          case _ =>
        }
      }
    }

    fork{
      while(true) {
        disableSimWave()
        sleep(100000 * 10)
        enableSimWave()
        sleep(  100 * 10)
      }
    }
  }
}