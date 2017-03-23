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


      import CsrAccess._
      val csrConfig = MachineCsrConfig(
        mvendorid      = 11,
        marchid        = 22,
        mimpid         = 33,
        mhartid        = 44,
        misaExtensionsInit = 66,
        misaAccess     = READ_WRITE,
        mtvecAccess    = READ_WRITE,
        mtvecInit      = 0x00000020l,
        mepcAccess     = READ_WRITE,
        mscratchGen    = true,
        mcauseAccess   = READ_WRITE,
        mbadaddrAccess = READ_WRITE,
        mcycleAccess   = READ_WRITE,
        minstretAccess = READ_WRITE
      )

      config.plugins ++= List(
        new PcManagerSimplePlugin(0x00000000l, false),
        new IBusSimplePlugin(true),
        new DecoderSimplePlugin,
        new RegFilePlugin(Plugin.SYNC),
        new IntAluPlugin,
        new SrcPlugin,
        new FullBarrielShifterPlugin,
//        new LightShifterPlugin,
        new DBusSimplePlugin,
//        new HazardSimplePlugin(false, true, false, true),
        new HazardSimplePlugin(true, true, true, true),
//        new HazardSimplePlugin(false, false, false, false),
        new MulPlugin,
        new DivPlugin,
        new MachineCsr(csrConfig),
        new BranchPlugin(false, DYNAMIC)
      )

      val toplevel = new VexRiscv(config)



      //      toplevel.service(classOf[DecoderSimplePlugin]).bench(toplevel)


      toplevel
    }
  }
}

