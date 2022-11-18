# Intel VJTAG
*By Levi Walker (@LYWalker)*

Intel VJTAG allows JTAG communication with the FPGA fabric of Altera devices through the standard USB cable using the onboard USB-Blaster. This avoids the needs to breakout the JTAG signals to the GPIO and use a dedicated external debugger. 

## How to use VJTAG with Briey
In Briey.scala remove the following lines (note: line numbers may differ, depending on edits):

```
[185] val jtag = slave(Jtag())
...
[466] val tcpJtag = JtagTcp(
[467]   jtag = dut.io.jtag,
[468]   jtagClkPeriod = jtagClkPeriod
[469] )
```

Then VJAG can be added in two ways.

### Method 1
Replace the following line in Briey.scala:

```
[311] io.jtag <> plugin.io.bus.fromJtag()
```
with
```
[311] plugin.io.bus.fromVJtag()
```

### Method 2
Replace the following line in Briey.scala:

```
[311] io.jtag <> plugin.io.bus.fromJtag()
```
with
```
[311] val tap = new sld_virtual_jtag(2)
[312] val jtagCtrl = tap.toJtagTapInstructionCtrl()          
[313] jtagCtrl <> plugin.io.bus.fromJtagInstructionCtrl(ClockDomain(tap.io.tck),0)
```
And add 
```
import spinal.lib.blackbox.altera.sld_virtual_jtag
```
to the imports at the top of the file.

This uses the existing JtagInstructionCtrl architecture and communicates using DR headers.

## Using OpenOCD

First, clone and setup openocd with the steps as provided by https://github.com/SpinalHDL/openocd_riscv

Then in tcl/target/Briey.cfg set `_USE_VJTAG` to 1:
```
[3] set _USE_VJTAG 1
```

Then if you used Method 1 above uncomment line 25:
```
[25] vexriscv jtagMapping 0 1 0 0 0 0
``` 
If you used Method 2 uncomment line 27:
```
[27] vexriscv jtagMapping 0 0 0 1 2 2
```

If the board uses USB-Blaster2 then run OpenOCD in shell using:
```
openocd -c "set CPU0_YAML ../VexRiscv/cpu0.yaml"	\
-f tcl/interface/altera-usb-blaster2.cfg	\
-f tcl/interface/soc_init.cfg
```
Note: you may need to edit `tcl/interface/altera-usb-blaster2.cfg` with your quartus path.

If using an older board using USB-Blaster run using:
```
openocd -c "set CPU0_YAML ../VexRiscv/cpu0.yaml" -f tcl/interface/altera-usb-blaster.cfg -f tcl/interface/Briey.cfg
```

On success it should look something like:
```
Open On-Chip Debugger 0.11.0+dev-02588-gb10abb4b1 (2022-11-07-13:38)
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
../../Verilog/cpu0.yaml
Info : only one transport option; autoselect 'jtag'
DEPRECATED! use 'adapter speed' not 'adapter_khz'
DEPRECATED! use 'adapter srst delay' not 'adapter_nsrst_delay'
Info : set servers polling period to 50ms
Info : usb blaster interface using libftdi
Info : This adapter doesn't support configurable speed
Info : JTAG tap: fpgasoc.fpga.tap tap/device found: 0x020f20dd (mfg: 0x06e (Altera), part: 0x20f2, ver: 0x0)
[fpga_spinal.cpu0] Target successfully examined.
Info : starting gdb server for fpga_spinal.cpu0 on 3333
Info : Listening on port 3333 for gdb connections
requesting target halt and executing a soft reset
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
```

From this point on attach a gdb connection and debug the board as usual.

*NOTE: You may need to add your boards FPGA ID to line [21] of Briey.cfg, simply append it to the other expected ids using: `-expected-id <your id>`. The IDs for the DE1-SoC and DE0 have already been added.*