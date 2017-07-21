/*
 * SpinalHDL
 * Copyright (c) Dolu, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

package VexRiscv

import VexRiscv.Plugin._
import VexRiscv.demo.SimdAddPlugin
import spinal.core._
import spinal.lib._
import VexRiscv.ip._
import spinal.lib.bus.avalon.AvalonMM
import spinal.lib.eda.altera.{InterruptReceiverTag, ResetEmitterTag}

object TestsWorkspace {
  def main(args: Array[String]) {
    SpinalVerilog {
      val configFull = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, false),
//          new IBusSimplePlugin(
//            interfaceKeepData = true,
//            catchAccessFault = true
//          ),
          new IBusCachedPlugin(
            config = InstructionCacheConfig(
              cacheSize = 4096,
              bytePerLine =32,
              wayCount = 1,
              wrappedMemAccess = true,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchIllegalAccess = true,
              catchAccessFault = true,
              catchMemoryTranslationMiss = true,
              asyncTagMemory = false,
              twoStageLogic = true
            ),
            askMemoryTranslation = true,
            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
              portTlbSize = 4
            )
          ),
//          new DBusSimplePlugin(
//            catchAddressMisaligned = true,
//            catchAccessFault = true
//          ),
          new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize         = 4096,
              bytePerLine       = 32,
              wayCount          = 1,
              addressWidth      = 32,
              cpuDataWidth      = 32,
              memDataWidth      = 32,
              catchAccessError  = true,
              catchIllegal      = true,
              catchUnaligned    = true,
              catchMemoryTranslationMiss = true
            ),
//            memoryTranslatorPortConfig = null
            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
              portTlbSize = 6
            )
          ),
//          new StaticMemoryTranslatorPlugin(
//            ioRange      = _(31 downto 28) === 0xF
//          ),
          new MemoryTranslatorPlugin(
            tlbSize = 32,
            virtualRange = _(31 downto 28) === 0xC,
            ioRange      = _(31 downto 28) === 0xF
          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = true
          ),
          new RegFilePlugin(
            regFileReadyKind = Plugin.SYNC,
            zeroBoot = true
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false
          ),
          new FullBarrielShifterPlugin,
  //        new LightShifterPlugin,
          new HazardSimplePlugin(
            bypassExecute           = true,
            bypassMemory            = true,
            bypassWriteBack         = true,
            bypassWriteBackBuffer   = true,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
  //        new HazardSimplePlugin(false, true, false, true),
  //        new HazardSimplePlugin(false, false, false, false),
          new MulPlugin,
          new DivPlugin,
          new CsrPlugin(CsrPluginConfig.all),
          new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = true,
            prediction = DYNAMIC
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )


      val configLight = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, false),
          new IBusSimplePlugin(
            interfaceKeepData = true,
            catchAccessFault = false
          ),

          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false
          ),
          new DecoderSimplePlugin(
            catchIllegalInstruction = false
          ),
          new RegFilePlugin(
            regFileReadyKind = Plugin.ASYNC,
            zeroBoot = false
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false
          ),
  //        new FullBarrielShifterPlugin,
          new LightShifterPlugin,
  //        new HazardSimplePlugin(true, true, true, true),
          //        new HazardSimplePlugin(false, true, false, true),
          new HazardSimplePlugin(
            bypassExecute           = false,
            bypassMemory            = false,
            bypassWriteBack         = false,
            bypassWriteBackBuffer   = false,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
//          new HazardPessimisticPlugin,
          new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
  //        new MulPlugin,
  //        new DivPlugin,
  //        new MachineCsr(csrConfig),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = false,
            prediction = NONE
          )
        )
      )



      val configTest = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, true),
          new IBusSimplePlugin(
            interfaceKeepData = true,
            catchAccessFault = true
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = true,
            catchAccessFault = true
          ),
          new CsrPlugin(CsrPluginConfig.small),
          new DecoderSimplePlugin(
            catchIllegalInstruction = true
          ),
          new RegFilePlugin(
            regFileReadyKind = Plugin.SYNC,
            zeroBoot = true
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false
          ),
          new FullBarrielShifterPlugin,
  //        new LightShifterPlugin,
          //        new HazardSimplePlugin(true, true, true, true),
          //        new HazardSimplePlugin(false, true, false, true),
          new HazardSimplePlugin(
            bypassExecute           = false,
            bypassMemory            = false,
            bypassWriteBack         = false,
            bypassWriteBackBuffer   = false,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
//          new MulPlugin,
//          new DivPlugin,
          //        new MachineCsr(csrConfig),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = true,
            prediction = NONE
          )
        )
      )

      val toplevel = new VexRiscv(configFull)
//      val toplevel = new VexRiscv(configLight)
//      val toplevel = new VexRiscv(configTest)

      toplevel.rework {
        var iBus : AvalonMM = null
        for (plugin <- toplevel.config.plugins) plugin match {
          case plugin: IBusCachedPlugin => {
            plugin.iBus.asDirectionLess() //Unset IO properties of iBus
            iBus = master(plugin.iBus.toAvalon())
              .setName("iBusAvalon")
              .addTag(ClockDomainTag(ClockDomain.current)) //Specify a clock domain to the iBus (used by QSysify)
          }
          case plugin: DBusCachedPlugin => {
            plugin.dBus.asDirectionLess()
            master(plugin.dBus.toAvalon())
              .setName("dBusAvalon")
              .addTag(ClockDomainTag(ClockDomain.current))
          }
          case plugin: DebugPlugin => {
            plugin.io.bus.asDirectionLess()
            slave(plugin.io.bus.fromAvalon())
              .setName("debugBusAvalon")
              .addTag(ClockDomainTag(plugin.debugClockDomain))
              .parent = null  //Avoid the io bundle to be interpreted as a QSys conduit
            plugin.io.resetOut
              .addTag(ResetEmitterTag(plugin.debugClockDomain))
              .parent = null //Avoid the io bundle to be interpreted as a QSys conduit
          }
          case _ =>
        }
        for (plugin <- toplevel.config.plugins) plugin match {
          case plugin: CsrPlugin => {
            plugin.externalInterrupt
              .addTag(InterruptReceiverTag(iBus, ClockDomain.current))
            plugin.timerInterrupt
              .addTag(InterruptReceiverTag(iBus, ClockDomain.current))
          }
          case _ =>
        }
      }
//      toplevel.writeBack.input(config.PC).addAttribute(Verilator.public)
//      toplevel.service(classOf[DecoderSimplePlugin]).bench(toplevel)

      toplevel
    }
  }
}

//TODO DivPlugin should not used MixedDivider (double twoComplement)
//TODO DivPlugin should register the twoComplement output before pipeline insertion
//TODO MulPlugin doesn't fit well on Artix (FMAX)
//TODO PcReg design is unoptimized by Artix synthesis
//TODO FMAX SRC mux + bipass mux prioriti
//TODO FMAX, isFiring is to pesimisstinc in some cases(include removeIt flushed ..)