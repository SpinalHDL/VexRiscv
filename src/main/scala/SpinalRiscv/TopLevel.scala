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
      val config = VexRiscvConfig(
        pcWidth = 32
      )


      val csrConfig = MachineCsrConfig(
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

//      val csrConfig = MachineCsrConfig(
//        mvendorid      = null,
//        marchid        = null,
//        mimpid         = null,
//        mhartid        = null,
//        misaExtensionsInit = 66,
//        misaAccess     = CsrAccess.NONE,
//        mtvecAccess    = CsrAccess.NONE,
//        mtvecInit      = 0x00000020l,
//        mepcAccess     = CsrAccess.READ_ONLY,
//        mscratchGen    = false,
//        mcauseAccess   = CsrAccess.READ_ONLY,
//        mbadaddrAccess = CsrAccess.NONE,
//        mcycleAccess   = CsrAccess.NONE,
//        minstretAccess = CsrAccess.NONE
//      )

      config.plugins ++= List(
        new PcManagerSimplePlugin(0x00000000l, false),
        new IBusSimplePlugin(
          interfaceKeepData = true
        ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true
        ),
        new RegFilePlugin(
          regFileReadyKind = Plugin.SYNC,
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin,
        new FullBarrielShifterPlugin,
//        new LightShifterPlugin,
        new DBusSimplePlugin(
          catchUnalignedException = true
        ),
        new HazardSimplePlugin(true, true, true, true),
//        new HazardSimplePlugin(false, true, false, true),
//        new HazardSimplePlugin(false, false, false, false),
        new MulPlugin,
        new DivPlugin,
        new MachineCsr(csrConfig),
        new BranchPlugin(
          earlyBranch = false,
          catchUnalignedException = true,
          prediction = DYNAMIC
        )
      )

//      config.plugins ++= List(
//        new PcManagerSimplePlugin(0x00000000l, false),
//        new IBusSimplePlugin(
//          interfaceKeepData = true
//        ),
//        new DecoderSimplePlugin(
//          catchIllegalInstruction = false
//        ),
//        new RegFilePlugin(
//          regFileReadyKind = Plugin.SYNC,
//          zeroBoot = false
//        ),
//        new IntAluPlugin,
//        new SrcPlugin,
////        new FullBarrielShifterPlugin,
//        new LightShifterPlugin,
//        new DBusSimplePlugin(
//          catchUnalignedException = false
//        ),
////        new HazardSimplePlugin(true, true, true, true),
//        //        new HazardSimplePlugin(false, true, false, true),
//        new HazardSimplePlugin(false, false, false, false),
////        new MulPlugin,
////        new DivPlugin,
////        new MachineCsr(csrConfig),
//        new BranchPlugin(
//          earlyBranch = false,
//          catchUnalignedException = false,
//          prediction = NONE
//        )
//      )

      val toplevel = new VexRiscv(config)

//      toplevel.service(classOf[DecoderSimplePlugin]).bench(toplevel)

      toplevel
    }
  }
}

