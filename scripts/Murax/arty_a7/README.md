This example is for the Digilent ARTY A7 35T board.

# Using the example

## Before Starting

You should make sure you have the following tools installed:
 * vivado 2018.1 or later
 * riscv toolchain (riscv64-unknown-elf)
 * sbt

## Board setup
Make sure you have a rev E board. If you have a later version check that the
flash part is S25FL128SAGMF100.

Jumper settings for board rev E:
 * Disconnect anything from the connectors (Pmod, Arduino)
 * Jumpers: JP1 and JP2 on, others off.

## Building

You should be able to just type `make` and get output similar to this;
```
...
Memory region         Used Size  Region Size  %age Used
             RAM:         896 B         2 KB     43.75%
...
---------------------------------------------------------------------------------
Finished RTL Elaboration : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1457.785 ; gain = 243.430 ; free physical = 17940 ; free virtual = 57159
---------------------------------------------------------------------------------
...
---------------------------------------------------------------------------------
Finished Technology Mapping : Time (s): cpu = 00:02:42 ; elapsed = 00:02:58 . Memory (MB): peak = 1986.879 ; gain = 772.523 ; free physical = 17454 ; free virtual = 56670
---------------------------------------------------------------------------------
...
---------------------------------------------------------------------------------
Finished Writing Synthesis Report : Time (s): cpu = 00:02:45 ; elapsed = 00:03:01 . Memory (MB): peak = 1986.879 ; gain = 772.523 ; free physical = 17457 ; free virtual = 56673
---------------------------------------------------------------------------------
...
Writing bitstream ./toplevel.bit...
...
mmi files generated
...
********************************************
  ./soc_latest_sw.bit correctly generated
********************************************
...
********************************************
  ./soc_latest_sw.mcs correctly generated
********************************************

INFO: [Common 17-206] Exiting Vivado at Thu Nov 28 04:00:50 2019...
```

The process should take around 8 minutes on a reasonably fast computer.

## Programming

### Direct FPGA RAM programming

Run `make prog` to program the bit file directly to FPGA RAM.

You should get output like the following;
```
...
****** Xilinx hw_server v2018.1
  **** Build date : Apr  4 2018-18:56:09
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

INFO: [Labtoolstcl 44-466] Opening hw_target localhost:3121/xilinx_tcf/Digilent/210319AB569AA
INFO: [Labtools 27-1434] Device xc7a35t (JTAG device index = 0) is programmed with a design that has no supported debug core(s) in it.
WARNING: [Labtools 27-3361] The debug hub core was not detected.
Resolution:
1. Make sure the clock connected to the debug hub (dbg_hub) core is a free running clock and is active.
2. Make sure the BSCAN_SWITCH_USER_MASK device property in Vivado Hardware Manager reflects the user scan chain setting in the design and refresh the device.  To determine the user scan chain setting in the design, open the implemented design and use 'get_property C_USER_SCAN_CHAIN [get_debug_cores dbg_hub]'.
For more details on setting the scan chain property, consult the Vivado Debug and Programming User Guide (UG908).
INFO: [Labtools 27-3164] End of startup status: HIGH
INFO: [Common 17-206] Exiting Vivado at Thu Nov 28 04:01:36 2019...
```

After programming the LED4~LED7 shall show some activity.

### QSPI flash programming

Run `make flash` to program the bit file to the QSPI flash.

You should get output like the following;
```
...
****** Xilinx hw_server v2018.1
  **** Build date : Apr  4 2018-18:56:09
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.


INFO: [Labtoolstcl 44-466] Opening hw_target localhost:3121/xilinx_tcf/Digilent/210319AB569AA
INFO: [Labtools 27-1434] Device xc7a35t (JTAG device index = 0) is programmed with a design that has no supported debug core(s) in it.
...
INFO: [Labtools 27-3164] End of startup status: HIGH
Mfg ID : 1   Memory Type : 20   Memory Capacity : 18   Device ID 1 : 0   Device ID 2 : 0
Performing Erase Operation...
Erase Operation successful.
Performing Program and Verify Operations...
Program/Verify Operation successful.
INFO: [Labtoolstcl 44-377] Flash programming completed successfully
program_hw_cfgmem: Time (s): cpu = 00:00:00.11 ; elapsed = 00:00:52 . Memory (MB): peak = 1792.711 ; gain = 8.000 ; free physical = 17712 ; free virtual = 56943
INFO: [Labtoolstcl 44-464] Closing hw_target localhost:3121/xilinx_tcf/Digilent/210319AB569AA
...
INFO: [Common 17-206] Exiting Vivado at Thu Nov 28 04:06:28 2019...
```

After programming the flash you need to press the "PROG" button on the board. Then after a second or so the "DONE" LED shall be ON and LED4~LED7 shall show some activity.


## Connect

After programming you should be able to connect to the serial port and have some output.

On Linux you can do this using a command like `screen /dev/ttyUSB1`. Other good alternatives:

* moserial (GUI)
* picocom (can be launched via the file "picocom_arty")

Parameters:
* port is        : /dev/ttyUSB1
* flowcontrol    : none
* baudrate is    : 115200
* parity is      : none
* databits are   : 8
* stopbits are   : 1
