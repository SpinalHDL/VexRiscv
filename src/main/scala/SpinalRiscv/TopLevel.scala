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

      config.plugins ++= List(
        new PcManagerSimplePlugin(0, false),
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
        new MulPlugin,
        new DivPlugin,
        new NoPredictionBranchPlugin(false)
      )

      val toplevel = new VexRiscv(config)



      //      toplevel.service(classOf[DecoderSimplePlugin]).bench(toplevel)


      toplevel
    }
  }
}

