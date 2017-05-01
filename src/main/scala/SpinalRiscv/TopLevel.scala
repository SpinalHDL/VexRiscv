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

package SpinalRiscv

import SpinalRiscv.Plugin._
import spinal.core._
import spinal.lib._


object TopLevel {
  def main(args: Array[String]) {
    SpinalVerilog {


//      val iCacheConfig = InstructionCacheConfig(
//        cacheSize =4096,
//        bytePerLine =32,
//        wayCount = 1,
//        wrappedMemAccess = true,
//        addressWidth = 32,
//        cpuDataWidth = 32,
//        memDataWidth = 32
//      )


      val csrConfigAll = MachineCsrConfig(
        mvendorid      = 11,
        marchid        = 22,
        mimpid         = 33,
        mhartid        = 0,
        misaExtensionsInit = 66,
        misaAccess     = CsrAccess.READ_WRITE,
        mtvecAccess    = CsrAccess.READ_WRITE,
        mtvecInit      = 0x00000020l,
        mepcAccess     = CsrAccess.READ_WRITE,
        mscratchGen    = true,
        mcauseAccess   = CsrAccess.READ_WRITE,
        mbadaddrAccess = CsrAccess.READ_WRITE,
        mcycleAccess   = CsrAccess.READ_WRITE,
        minstretAccess = CsrAccess.READ_WRITE,
        ecallGen       = true,
        wfiGen         = true
      )

      val csrConfigSmall = MachineCsrConfig(
        mvendorid      = null,
        marchid        = null,
        mimpid         = null,
        mhartid        = null,
        misaExtensionsInit = 66,
        misaAccess     = CsrAccess.NONE,
        mtvecAccess    = CsrAccess.NONE,
        mtvecInit      = 0x00000020l,
        mepcAccess     = CsrAccess.READ_WRITE,
        mscratchGen    = false,
        mcauseAccess   = CsrAccess.READ_ONLY,
        mbadaddrAccess = CsrAccess.READ_ONLY,
        mcycleAccess   = CsrAccess.NONE,
        minstretAccess = CsrAccess.NONE,
        ecallGen       = false,
        wfiGen         = false
      )

      val csrConfigSmallest = MachineCsrConfig(
        mvendorid      = null,
        marchid        = null,
        mimpid         = null,
        mhartid        = null,
        misaExtensionsInit = 66,
        misaAccess     = CsrAccess.NONE,
        mtvecAccess    = CsrAccess.NONE,
        mtvecInit      = 0x00000020l,
        mepcAccess     = CsrAccess.READ_ONLY,
        mscratchGen    = false,
        mcauseAccess   = CsrAccess.READ_ONLY,
        mbadaddrAccess = CsrAccess.NONE,
        mcycleAccess   = CsrAccess.NONE,
        minstretAccess = CsrAccess.NONE,
        ecallGen       = false,
        wfiGen         = false
      )

      val configFull = VexRiscvConfig(
        plugins = List(
          new PcManagerSimplePlugin(0x00000000l, false),
          new IBusSimplePlugin(
            interfaceKeepData = true,
            catchAccessFault = true
          ),
  //        new IBusCachedPlugin(
  //          config = InstructionCacheConfig(
  //            cacheSize = 4096,
  //            bytePerLine =32,
  //            wayCount = 1,
  //            wrappedMemAccess = true,
  //            addressWidth = 32,
  //            cpuDataWidth = 32,
  //            memDataWidth = 32,
  //            catchAccessFault = true,
  //            asyncTagMemory = false,
  //            twoStageLogic = true
  //          )
  //        ),
  //        new DBusSimplePlugin(
  //          catchAddressMisaligned = true,
  //          catchAccessFault = true
  //        ),
          new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize         = 4096,
              bytePerLine       = 32,
              wayCount          = 1,
              addressWidth      = 32,
              cpuDataWidth      = 32,
              memDataWidth      = 32,
              catchAccessFault  = false,
              catchMemoryTranslationMiss = false
            )
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
          new MachineCsr(csrConfigAll),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = true,
            prediction = DYNAMIC
          )
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
  //        new HazardSimplePlugin(
  //          bypassExecute           = false,
  //          bypassMemory            = false,
  //          bypassWriteBack         = false,
  //          bypassWriteBackBuffer   = false,
  //          pessimisticUseSrc       = false,
  //          pessimisticWriteRegFile = false,
  //          pessimisticAddressMatch = false
  //        ),
          new HazardPessimisticPlugin,
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
  //        new IBusSimplePlugin(
  //          interfaceKeepData = true,
  //          catchAccessFault = false
  //        ),
          new IBusCachedPlugin(
            config = InstructionCacheConfig(
              cacheSize = 4096,
              bytePerLine =32,
              wayCount = 1,
              wrappedMemAccess = true,
              addressWidth = 32,
              cpuDataWidth = 32,
              memDataWidth = 32,
              catchAccessFault = false,
              asyncTagMemory = false,
              twoStageLogic = true
            )
          ),

  //        new DBusSimplePlugin(
  //          catchAddressMisaligned = false,
  //          catchAccessFault = false
  //        ),
  //        new DBusCachedPlugin(
  //          config = new DataCacheConfig(
  //            cacheSize         = 2048,
  //            bytePerLine       = 32,
  //            wayCount          = 1,
  //            addressWidth      = 32,
  //            cpuDataWidth      = 32,
  //            memDataWidth      = 32,
  //            catchAccessFault  = false
  //          )
  //        ),
          new DBusCachedPlugin(
            config = new DataCacheConfig(
              cacheSize         = 4096,
              bytePerLine       = 32,
              wayCount          = 1,
              addressWidth      = 32,
              cpuDataWidth      = 32,
              memDataWidth      = 32,
              catchAccessFault  = false,
              catchMemoryTranslationMiss = true,
              tagSizeShift      = 2
            ),
            askMemoryTranslation = true,
            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
              portTlbSize = 6
            )
          ),

          new MemoryTranslatorPlugin(
            tlbSize = 32,
            mmuRange = _(31 downto 28) === 0xC
          ),
          new MachineCsr(csrConfigSmall),
          new DecoderSimplePlugin(
            catchIllegalInstruction = false
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

//      val toplevel = new VexRiscv(configFull)
//      val toplevel = new VexRiscv(configLight)
      val toplevel = new VexRiscv(configTest)
      toplevel.decode.input(toplevel.config.INSTRUCTION).addAttribute(Verilator.public)
      toplevel.decode.input(toplevel.config.PC).addAttribute(Verilator.public)
      toplevel.decode.arbitration.isValid.addAttribute(Verilator.public)
      toplevel.decode.arbitration.haltIt.addAttribute(Verilator.public)
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