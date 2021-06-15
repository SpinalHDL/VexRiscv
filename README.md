## Index

- [Index](#index)
- [Description](#description)
- [Area usage and maximal frequency](#area-usage-and-maximal-frequency)
- [Dependencies](#dependencies)
- [CPU generation](#cpu-generation)
- [Regression tests](#regression-tests)
- [Interactive debug of the simulated CPU via GDB OpenOCD and Verilator](#interactive-debug-of-the-simulated-cpu-via-gdb-openocd-and-verilator)
- [Using Eclipse to run and debug the software](#using-eclipse-to-run-and-debug-the-software)
  - [By using gnu-mcu-eclipse](#by-using-gnu-mcu-eclipse)
  - [By using Zylin plugin (old)](#by-using-zylin-plugin-old)
- [Briey SoC](#briey-soc)
- [Murax SoC](#murax-soc)
- [Running Linux](#running-linux)
- [Build the RISC-V GCC](#build-the-risc-v-gcc)
- [CPU parametrization and instantiation example](#cpu-parametrization-and-instantiation-example)
- [Add a custom instruction to the CPU via the plugin system](#add-a-custom-instruction-to-the-cpu-via-the-plugin-system)
- [Adding a new CSR via the plugin system](#adding-a-new-csr-via-the-plugin-system)
- [CPU clock and resets](#cpu-clock-and-resets)
- [VexRiscv Architecture](#vexriscv-architecture)
  - [FPU](#fpu)
  - [Plugins](#plugins)
    - [IBusSimplePlugin](#ibussimpleplugin)
    - [IBusCachedPlugin](#ibuscachedplugin)
    - [DecoderSimplePlugin](#decodersimpleplugin)
    - [RegFilePlugin](#regfileplugin)
    - [HazardSimplePlugin](#hazardsimpleplugin)
    - [SrcPlugin](#srcplugin)
    - [IntAluPlugin](#intaluplugin)
    - [LightShifterPlugin](#lightshifterplugin)
    - [FullBarrelShifterPlugin](#fullbarrelshifterplugin)
    - [BranchPlugin](#branchplugin)
      - [Prediction NONE](#prediction-none)
      - [Prediction STATIC](#prediction-static)
      - [Prediction DYNAMIC](#prediction-dynamic)
      - [Prediction DYNAMIC_TARGET](#prediction-dynamic_target)
    - [DBusSimplePlugin](#dbussimpleplugin)
    - [DBusCachedPlugin](#dbuscachedplugin)
    - [MulPlugin](#mulplugin)
    - [DivPlugin](#divplugin)
    - [MulDivIterativePlugin](#muldiviterativeplugin)
    - [CsrPlugin](#csrplugin)
    - [StaticMemoryTranslatorPlugin](#staticmemorytranslatorplugin)
    - [MmuPlugin](#mmuplugin)
    - [PmpPlugin](#pmpplugin)
    - [DebugPlugin](#debugplugin)
    - [YamlPlugin](#yamlplugin)
    - [FpuPlugin](#fpuplugin)
    - [AesPlugin](#aesplugin)



## Description

This repository hosts a RISC-V implementation written in SpinalHDL. Here are some specs :

- RV32I[M][A][F[D]][C] instruction set
- Pipelined from 2 to 5+ stages ([Fetch*X], Decode, Execute, [Memory], [WriteBack])
- 1.44 DMIPS/Mhz --no-inline when nearly all features are enabled (1.57 DMIPS/Mhz when the divider lookup table is enabled)
- Optimized for FPGA, does not use any vendor specific IP block / primitive
- AXI4, Avalon, wishbone ready
- Optional MUL/DIV extensions
- Optional F32/F64 FPU (require data cache for now)
- Optional instruction and data caches
- Optional hardware refilled MMU
- Optional debug extension allowing Eclipse debugging via a GDB >> openOCD >> JTAG connection
- Optional interrupts and exception handling with Machine, [Supervisor] and [User] modes as defined in the [RISC-V Privileged ISA Specification v1.10](https://riscv.org/specifications/privileged-isa/).
- Two implementations of shift instructions: single cycle (full barrel shifter) and shiftNumber cycles
- Each stage can have optional bypass or interlock hazard logic
- Linux compatible (SoC : https://github.com/enjoy-digital/linux-on-litex-vexriscv)
- Zephyr compatible
- [FreeRTOS port](https://github.com/Dolu1990/FreeRTOS-RISCV)

The hardware description of this CPU is done by using a very software oriented approach
(without any overhead in the generated hardware). Here is a list of software concepts used:

- There are very few fixed things. Nearly everything is plugin based. The PC manager is a plugin, the register file is a plugin, the hazard controller is a plugin, ...
- There is an automatic a tool which allows plugins to insert data in the pipeline at a given stage, and allows other plugins to read it in another stage through automatic pipelining.
- There is a service system which provides a very dynamic framework. For instance, a plugin could provide an exception service which can then be used by other plugins to emit exceptions from the pipeline.

There is a gitter channel for all questions about VexRiscv :<br>
[![Gitter](https://badges.gitter.im/SpinalHDL/VexRiscv.svg)](https://gitter.im/SpinalHDL/VexRiscv?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

For commercial support, please contact spinalhdl@gmail.com.

## Area usage and maximal frequency

The following numbers were obtained by synthesizing the CPU as toplevel on the fastest speed grade without any specific synthesis options to save area or to get better maximal frequency (neutral).<br>
The clock constraint is set to an unattainable value, which tends to increase the design area.<br>
The dhrystone benchmark was compiled with the `-O3 -fno-inline` option.<br>
All the cached configurations have some cache trashing during the dhrystone benchmark except the `VexRiscv full max perf` one. This, of course, reduces the performance. It is possible to produce
dhrystone binaries which fit inside a 4KB I$ and 4KB D$ (I already had this case once) but currently it isn't the case.<br>
The CPU configurations used below can be found in the `src/scala/vexriscv/demo` directory.

```
VexRiscv small (RV32I, 0.52 DMIPS/Mhz, no datapath bypass, no interrupt) ->
    Artix 7     -> 243 Mhz 504 LUT 505 FF 
    Cyclone V   -> 174 Mhz 352 ALMs
    Cyclone IV  -> 179 Mhz 731 LUT 494 FF 
    iCE40       -> 92 Mhz 1130 LC

VexRiscv small (RV32I, 0.52 DMIPS/Mhz, no datapath bypass) ->
    Artix 7     -> 240 Mhz 556 LUT 566 FF 
    Cyclone V   -> 194 Mhz 394 ALMs
    Cyclone IV  -> 174 Mhz 831 LUT 555 FF 
    iCE40       -> 85 Mhz 1292 LC

VexRiscv small and productive (RV32I, 0.82 DMIPS/Mhz)  ->
    Artix 7     -> 232 Mhz 816 LUT 534 FF 
    Cyclone V   -> 155 Mhz 492 ALMs
    Cyclone IV  -> 155 Mhz 1,111 LUT 530 FF 
    iCE40       -> 63 Mhz 1596 LC

VexRiscv small and productive with I$ (RV32I, 0.70 DMIPS/Mhz, 4KB-I$)  ->
    Artix 7     -> 220 Mhz 730 LUT 570 FF 
    Cyclone V   -> 142 Mhz 501 ALMs
    Cyclone IV  -> 150 Mhz 1,139 LUT 536 FF 
    iCE40       -> 66 Mhz 1680 LC

VexRiscv full no cache (RV32IM, 1.21 DMIPS/Mhz 2.30 Coremark/Mhz, single cycle barrel shifter, debug module, catch exceptions, static branch) ->
    Artix 7     -> 216 Mhz 1418 LUT 949 FF 
    Cyclone V   -> 133 Mhz 933 ALMs
    Cyclone IV  -> 143 Mhz 2,076 LUT 972 FF 

VexRiscv full (RV32IM, 1.21 DMIPS/Mhz 2.30 Coremark/Mhz with cache trashing, 4KB-I$,4KB-D$, single cycle barrel shifter, debug module, catch exceptions, static branch) ->
    Artix 7     -> 199 Mhz 1840 LUT 1158 FF 
    Cyclone V   -> 141 Mhz 1,166 ALMs
    Cyclone IV  -> 131 Mhz 2,407 LUT 1,067 FF 

VexRiscv full max perf (HZ*IPC) -> (RV32IM, 1.38 DMIPS/Mhz 2.57 Coremark/Mhz, 8KB-I$,8KB-D$, single cycle barrel shifter, debug module, catch exceptions, dynamic branch prediction in the fetch stage, branch and shift operations done in the Execute stage) ->
    Artix 7     -> 200 Mhz 1935 LUT 1216 FF 
    Cyclone V   -> 130 Mhz 1,166 ALMs
    Cyclone IV  -> 126 Mhz 2,484 LUT 1,120 FF 

VexRiscv full with MMU (RV32IM, 1.24 DMIPS/Mhz 2.35 Coremark/Mhz, with cache trashing, 4KB-I$, 4KB-D$, single cycle barrel shifter, debug module, catch exceptions, dynamic branch, MMU) ->
    Artix 7     -> 151 Mhz 2021 LUT 1541 FF 
    Cyclone V   -> 124 Mhz 1,368 ALMs
    Cyclone IV -> 128 Mhz 2,826 LUT 1,474 FF 

VexRiscv linux balanced (RV32IMA, 1.21 DMIPS/Mhz 2.27 Coremark/Mhz, with cache trashing, 4KB-I$, 4KB-D$, single cycle barrel shifter, catch exceptions, static branch, MMU, Supervisor, Compatible with mainstream linux) ->
    Artix 7     -> 180 Mhz 2883 LUT 2130 FF 
    Cyclone V   -> 131 Mhz 1,764 ALMs
    Cyclone IV  -> 121 Mhz 3,608 LUT 2,082 FF 
```

The following configuration results in 1.44 DMIPS/MHz:

- 5 stage: F -> D -> E -> M  -> WB
- single cycle ADD/SUB/Bitwise/Shift ALU
- branch/jump done in the E stage
- memory load values are bypassed in the WB stage (late result)
- 33 cycle division with bypassing in the M stage (late result)
- single cycle multiplication with bypassing in the WB stage (late result)
- dynamic branch prediction done in the F stage with a direct mapped target buffer cache (no penalties on correct predictions)

Note that, recently, the capability to remove the Fetch/Memory/WriteBack stage was added to reduce the area of the CPU, which ends up with a smaller CPU and a better DMIPS/Mhz for the small configurations.

## Dependencies

On Ubuntu 14:

```sh
# JAVA JDK 8
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java
sudo update-alternatives --config javac

# Install SBT - https://www.scala-sbt.org/
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt

# Verilator (for sim only, really needs 3.9+, in general apt-get will give you 3.8)
sudo apt-get install git make autoconf g++ flex bison
git clone http://git.veripool.org/git/verilator   # Only first time
unsetenv VERILATOR_ROOT  # For csh; ignore error if on bash
unset VERILATOR_ROOT  # For bash
cd verilator
git pull        # Make sure we're up-to-date
git checkout v4.040
autoconf        # Create ./configure script
./configure
make
sudo make install
```

## CPU generation
You can find two example CPU instances in:
- `src/main/scala/vexriscv/demo/GenFull.scala`
- `src/main/scala/vexriscv/demo/GenSmallest.scala`

To generate the corresponding RTL as a `VexRiscv.v` file, run the following commands in the root directory of this repository:

```sh
sbt "runMain vexriscv.demo.GenFull"
```

or

```sh
sbt "runMain vexriscv.demo.GenSmallest"
```

NOTES:
- It could take time the first time you run it.
- The VexRiscv project may need an unreleased master-head of the SpinalHDL repo. If it fails to compile, just get the SpinalHDL repository and
   do a "sbt clean compile publishLocal" in it as described in the dependencies chapter.

## Regression tests

[![Build Status](https://travis-ci.org/SpinalHDL/VexRiscv.svg?branch=master)](https://travis-ci.org/SpinalHDL/VexRiscv)

To run tests (need java, scala, verilator), just do :

```sh
export VEXRISCV_REGRESSION_SEED=42
export VEXRISCV_REGRESSION_TEST_ID=
sbt "testOnly vexriscv.TestIndividualFeatures"
```

This will generate random VexRiscv configuration and test them with: 
- ISA tests from https://github.com/riscv/riscv-tests/tree/master/isa and  https://github.com/riscv/riscv-compliance
- Dhrystone benchmark
- Coremark benchmark
- Zephyr os
- Buildroot/Linux os
- Some handwritten tests to check the CSR, debug module and MMU plugins

You can rerun some specific test by setting VEXRISCV_REGRESSION_TEST_ID by their id. For instance, if you want to rerun :
- test_id_5_test_IBus_CachedS1024W1BPL32Relaxvexriscv.plugin.DYNAMIC_DBus_CachedS8192W2BPL16_MulDiv_MulDivFpga_Shift_FullLate_Branch_Late_Hazard_BypassAll_RegFile_SyncDR_Src__Csr_AllNoException_Decoder__Debug_None_DBus_NoMmu
- test_id_9_test_IBus_Simple1S2InjStagevexriscv.plugin.STATIC_DBus_SimpleLate_MulDiv_MulDivFpgaSimple_Shift_FullEarly_Branch_Late_Hazard_Interlock_RegFile_AsyncER_Src_AddSubExecute_Csr_None_Decoder__Debug_None_DBus_NoMmu

then :

```
export VEXRISCV_REGRESSION_TEST_ID=5,9
```

Also there is a few environnement variable that you can use to modulate the random generation : 

| Parameters                                  | range              | description |
| ------------------------------------------- | ------------------ | ----------- |
| VEXRISCV_REGRESSION_SEED                    | Int                | Seed used to generate the random configurations |        
| VEXRISCV_REGRESSION_TEST_ID                 | \[Int\[,\Int\]\*\] | Random configuration that should be keeped and tested |                        
| VEXRISCV_REGRESSION_CONFIG_COUNT            | Int                | Number of random configurations |                        
| VEXRISCV_REGRESSION_CONFIG_RVC_RATE         | 0.0-1.0            | Chance to generate a RVC config |                               
| VEXRISCV_REGRESSION_CONFIG_LINUX_RATE       | 0.0-1.0            | Chance to generate a linux ready config |            
| VEXRISCV_REGRESSION_CONFIG_MACHINE_OS_RATE  | 0.0-1.0            | Chance to generate a machine mode OS ready config |            
| VEXRISCV_REGRESSION_LINUX_REGRESSION        | yes/no             | Enable the linux test |           
| VEXRISCV_REGRESSION_COREMARK                | yes/no             | Enable the Coremark test |           
| VEXRISCV_REGRESSION_ZEPHYR_COUNT            | Int                | Number of zephyr tests to run on capable configs |        
| VEXRISCV_REGRESSION_CONFIG_DEMW_RATE        | 0.0-1.0            | Chance to generate a config with writeback stage |            
| VEXRISCV_REGRESSION_CONFIG_DEM_RATE         | 0.0-1.0            | Chance to generate a config with memory stage |            

## Interactive debug of the simulated CPU via GDB OpenOCD and Verilator
To use this, you just need to use the same command as with running tests, but adding `DEBUG_PLUGIN_EXTERNAL=yes` in the make arguments.
This works for the `GenFull` configuration, but not for `GenSmallest`, as this configuration has no debug module.

Then, you can use the [OpenOCD RISC-V](https://github.com/SpinalHDL/openocd_riscv) tool to create a GDB server connected to the target (the simulated CPU), as follows:

```sh
#In the VexRiscv repository, to run the simulation on which one OpenOCD can connect itself =>
sbt "runMain vexriscv.demo.GenFull"
cd src/test/cpp/regression
make run DEBUG_PLUGIN_EXTERNAL=yes

#In the openocd git, after building it =>
src/openocd -c "set VEXRISCV_YAML PATH_TO_THE_GENERATED_CPU0_YAML_FILE" -f tcl/target/vexriscv_sim.cfg

#Run a GDB session with an elf RISCV executable (GenFull CPU)
YourRiscvToolsPath/bin/riscv32-unknown-elf-gdb VexRiscvRepo/src/test/resources/elf/uart.elf
target remote localhost:3333
monitor reset halt
load
continue

# Now it should print messages in the Verilator simulation of the CPU
```

## Using Eclipse to run and debug the software

### By using gnu-mcu-eclipse

You can download releases of the IDE here: <https://github.com/gnu-mcu-eclipse/org.eclipse.epp.packages/releases>

In the IDE, you can import a makefile project by:
- file -> import -> C/C++ -> existing Code as Makefile Project
- Select the folder which contains the makefile, then select "Cross GCC" (not "RISC-V Cross GCC")

To create a new debug configuration:
- run -> Debug Configurations -> GDB OpenOCD Debugging double click
- Look at https://drive.google.com/open?id=1c46tyEV0xLwOsk76b0y2qqs8CYy7Zq3f for a configuration example

### By using Zylin plugin (old)
You can use the Eclipse + Zylin embedded CDT plugin to do it (http://opensource.zylin.com/embeddedcdt.html). Tested with Helios Service Release 2 (http://www.Eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/Eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz) and the corresponding zylin plugin.

To following commands will download Eclipse and install the plugin.
```sh
wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz
tar -xvzf download.php?file=%2Ftechnology%2Fepp%2Fdownloads%2Frelease%2Fhelios%2FSR2%2Feclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz
cd eclipse
./eclipse -application org.eclipse.equinox.p2.director -repository http://opensource.zylin.com/zylincdt -installIU com.zylin.cdt.feature.feature.group/
```

See https://drive.google.com/drive/folders/1NseNHH05B6lmIXqQFVwK8xRjWE4ydeG-?usp=sharing to import a makefile project and create a debug configuration.

Note that sometimes Eclipse needs to be restarted in order to be able to place new breakpoints.

## Briey SoC
As a demonstration, a SoC named Briey is implemented in `src/main/scala/vexriscv/demo/Briey.scala`. This SoC is very similar to
the [Pinsec SoC](https://spinalhdl.github.io/SpinalDoc-RTD/SpinalHDL/Legacy/pinsec/hardware_toplevel.html#):

![Briey SoC](assets/brieySoc.png?raw=true "")

To generate the Briey SoC Hardware:

```sh
sbt "runMain vexriscv.demo.Briey"
```

To run the verilator simulation of the Briey SoC, which can then be connected to OpenOCD/GDB, first get these dependencies:

```sh
sudo apt-get install build-essential xorg-dev libudev-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev libpulse-dev libopenal-dev libogg-dev libvorbis-dev libaudiofile-dev libpng12-dev libfreetype6-dev libusb-dev libdbus-1-dev zlib1g-dev libdirectfb-dev libsdl2-dev
```

Then go in `src/test/cpp/briey` and run the simulation with (UART TX is printed in the terminal, VGA is displayed in a GUI):

```sh
make clean run
```

To connect OpenOCD (https://github.com/SpinalHDL/openocd_riscv) to the simulation :

```sh
src/openocd -f tcl/interface/jtag_tcp.cfg -c "set BRIEY_CPU0_YAML /home/spinalvm/Spinal/VexRiscv/cpu0.yaml" -f tcl/target/briey.cfg
```

You can find multiple software examples and demos here: <https://github.com/SpinalHDL/VexRiscvSocSoftware/tree/master/projects/briey>

You can find some FPGA projects which instantiate the Briey SoC here (DE1-SoC, DE0-Nano): https://drive.google.com/drive/folders/0B-CqLXDTaMbKZGdJZlZ5THAxRTQ?usp=sharing

Here are some measurements of Briey SoC timings and area:

```
Artix 7     -> 181 Mhz 3220 LUT 3181 FF 
Cyclone V   -> 142 Mhz 2,222 ALMs
Cyclone IV  -> 130 Mhz 4,538 LUT 3,211 FF 
```

## Murax SoC

Murax is a very light SoC (it fits in an ICE40 FPGA) which can work without any external components:
- VexRiscv RV32I[M]
- JTAG debugger (Eclipse/GDB/openocd ready)
- 8 kB of on-chip ram
- Interrupt support
- APB bus for peripherals
- 32 GPIO pin
- one 16 bits prescaler, two 16 bits timers
- one UART with tx/rx fifo

Depending on the CPU configuration, on the ICE40-hx8k FPGA with icestorm for synthesis, the full SoC has the following area/performance:
- RV32I interlocked stages => 51 Mhz, 2387 LC 0.45 DMIPS/Mhz
- RV32I bypassed stages    => 45 Mhz, 2718 LC 0.65 DMIPS/Mhz

Its implementation can be found here: `src/main/scala/vexriscv/demo/Murax.scala`.

To generate the Murax SoC Hardware:

```sh
# To generate the SoC without any content in the ram
sbt "runMain vexriscv.demo.Murax"

# To generate the SoC with a demo program already in ram
sbt "runMain vexriscv.demo.MuraxWithRamInit"
```

The demo program included by default with `MuraxWithRamInit` will blink the
LEDs and echo characters received on the UART back to the user. To see this
when running the Verilator sim, type some text and press enter.

Then go in `src/test/cpp/murax` and run the simulation with:

```sh
make clean run
```

To connect OpenOCD (https://github.com/SpinalHDL/openocd_riscv) to the simulation:

```sh
src/openocd -f tcl/interface/jtag_tcp.cfg -c "set MURAX_CPU0_YAML /home/spinalvm/Spinal/VexRiscv/cpu0.yaml" -f tcl/target/murax.cfg
```

You can find multiple software examples and demos here: https://github.com/SpinalHDL/VexRiscvSocSoftware/tree/master/projects/murax

Here are some timing and area measurements of the Murax SoC:

```
Murax interlocked stages (0.45 DMIPS/Mhz, 8 bits GPIO) ->
    Artix 7     -> 216 Mhz 1109 LUT 1201 FF 
    Cyclone V   -> 182 Mhz 725 ALMs
    Cyclone IV  -> 147 Mhz 1,551 LUT 1,223 FF 
    iCE40       ->  64 Mhz 2422 LC (nextpnr)

MuraxFast bypassed stages (0.65 DMIPS/Mhz, 8 bits GPIO) ->
    Artix 7     -> 224 Mhz 1278 LUT 1300 FF 
    Cyclone V   -> 173 Mhz 867 ALMs
    Cyclone IV  -> 143 Mhz 1,755 LUT 1,258 FF 
    iCE40       ->  66 Mhz 2799 LC (nextpnr)
```

Some scripts to generate the SoC and call the icestorm toolchain can be found here: `scripts/Murax/`

A top level simulation testbench with the same features + a GUI are implemented with SpinalSim. You can find it in `src/test/scala/vexriscv/MuraxSim.scala`.

To run it :

```sh
# This will generate the Murax RTL + run its testbench. You need Verilator 3.9xx installated.
sbt "test:runMain vexriscv.MuraxSim"
```

## Running Linux

A default configuration is located in `src/main/scala/vexriscv/demo/Linux.scala`.

This file also contains 
- The commands to compile the buildroot image
- How to run the Verilator simulation in interative mode

There is currently no SoC to run it on hardware, it is WIP. But the CPU simulation can already boot linux and run user space applications (even python).

Note that VexRiscv can run Linux on both cache full and cache less design.

## Build the RISC-V GCC

A prebuild GCC toolsuite can be found here:

- https://www.sifive.com/software/  => Prebuilt RISC‑V GCC Toolchain and Emulator

The VexRiscvSocSoftware makefiles are expecting to find this prebuild version in /opt/riscv/__contentOfThisPreBuild__

```sh
version=riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14
wget -O riscv64-unknown-elf-gcc.tar.gz riscv https://static.dev.sifive.com/dev-tools/$version.tar.gz
tar -xzvf riscv64-unknown-elf-gcc.tar.gz
sudo mv $version /opt/riscv
echo 'export PATH=/opt/riscv/bin:$PATH' >> ~/.bashrc
```

If you want to compile the rv32i and rv32im GCC toolchain from source code and install them in `/opt/`, do the following (will take one hour):

```sh
# Be carefull, sometime the git clone has issue to successfully clone riscv-gnu-toolchain.
sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev -y

git clone --recursive https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain
cd riscv-gnu-toolchain

echo "Starting RISC-V Toolchain build process"

ARCH=rv32im
rmdir -rf $ARCH
mkdir $ARCH; cd $ARCH
../configure  --prefix=/opt/$ARCH --with-arch=$ARCH --with-abi=ilp32
sudo make -j4
cd ..


ARCH=rv32i
rmdir -rf $ARCH
mkdir $ARCH; cd $ARCH
../configure  --prefix=/opt/$ARCH --with-arch=$ARCH --with-abi=ilp32
sudo make -j4
cd ..

echo -e "\\nRISC-V Toolchain installation completed!"
```

## CPU parametrization and instantiation example

You can find many examples of different configurations in the https://github.com/SpinalHDL/VexRiscv/tree/master/src/main/scala/vexriscv/demo folder.

Here is one such example:

```scala
import vexriscv._
import vexriscv.plugin._

//Instanciate one VexRiscv
val cpu = new VexRiscv(
  //Provide a configuration instance
  config = VexRiscvConfig(
    //Provide a list of plugins which will futher add their logic into the CPU
    plugins = List(
      new IBusSimplePlugin(
        resetVector = 0x00000000l,
        cmdForkOnSecondStage = true,
        cmdForkPersistence  = true
      ),
      new DBusSimplePlugin(
        catchAddressMisaligned = false,
        catchAccessFault = false
      ),
      new DecoderSimplePlugin(
        catchIllegalInstruction = false
      ),
      new RegFilePlugin(
        regFileReadyKind = Plugin.SYNC,
        zeroBoot = true
      ),
      new IntAluPlugin,
      new SrcPlugin(
        separatedAddSub = false,
        executeInsertion = false
      ),
      new LightShifterPlugin,
      new HazardSimplePlugin(
        bypassExecute           = false,
        bypassMemory            = false,
        bypassWriteBack         = false,
        bypassWriteBackBuffer   = false
      ),
      new BranchPlugin(
        earlyBranch = false,
        catchAddressMisaligned = false
      ),
      new YamlPlugin("cpu0.yaml")
    )
  )
)
```

## Add a custom instruction to the CPU via the plugin system

Here is an example of a simple plugin which adds a simple SIMD_ADD instruction:

```scala
import spinal.core._
import vexriscv.plugin.Plugin
import vexriscv.{Stageable, DecoderService, VexRiscv}

//This plugin example will add a new instruction named SIMD_ADD which does the following:
//
//RD : Regfile Destination, RS : Regfile Source
//RD( 7 downto  0) = RS1( 7 downto  0) + RS2( 7 downto  0)
//RD(16 downto  8) = RS1(16 downto  8) + RS2(16 downto  8)
//RD(23 downto 16) = RS1(23 downto 16) + RS2(23 downto 16)
//RD(31 downto 24) = RS1(31 downto 24) + RS2(31 downto 24)
//
//Instruction encoding :
//0000011----------000-----0110011
//       |RS2||RS1|   |RD |
//
//Note :  RS1, RS2, RD positions follow the RISC-V spec and are common for all instruction of the ISA

class SimdAddPlugin extends Plugin[VexRiscv]{
  //Define the concept of IS_SIMD_ADD signals, which specify if the current instruction is destined for this plugin
  object IS_SIMD_ADD extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    //Retrieve the DecoderService instance
    val decoderService = pipeline.service(classOf[DecoderService])

    //Specify the IS_SIMD_ADD default value when instructions are decoded
    decoderService.addDefault(IS_SIMD_ADD, False)

    //Specify the instruction decoding which should be applied when the instruction matches the 'key' parttern
    decoderService.add(
      //Bit pattern of the new SIMD_ADD instruction
      key = M"0000011----------000-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_SIMD_ADD              -> True,
        REGFILE_WRITE_VALID      -> True, //Enable the register file write
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction uses the RS1 value
        RS2_USE                  -> True  //Same as above but for RS2.
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Add a new scope on the execute stage (used to give a name to signals)
    execute plug new Area {
      //Define some signals used internally by the plugin
      val rs1 = execute.input(RS1).asUInt
      //32 bits UInt value of the regfile[RS1]
      val rs2 = execute.input(RS2).asUInt
      val rd = UInt(32 bits)

      //Do some computations
      rd(7 downto 0) := rs1(7 downto 0) + rs2(7 downto 0)
      rd(16 downto 8) := rs1(16 downto 8) + rs2(16 downto 8)
      rd(23 downto 16) := rs1(23 downto 16) + rs2(23 downto 16)
      rd(31 downto 24) := rs1(31 downto 24) + rs2(31 downto 24)

      //When the instruction is a SIMD_ADD, write the result into the register file data path.
      when(execute.input(IS_SIMD_ADD)) {
        execute.output(REGFILE_WRITE_DATA) := rd.asBits
      }
    }
  }
}
```

If you want to add this plugin to a given CPU, you just need to add it to its parameterized plugin list.

This example is a very simple one, but each plugin can really have access to the whole CPU:
- Halt a given stage of the CPU
- Unschedule instructions
- Emit an exception
- Introduce a new instruction decoding specification
- Ask to jump the PC somewhere
- Read signals published by other plugins
- Override published signals values
- Provide an alternative implementation
- ...

As a demonstration, this SimdAddPlugin was integrated in the `src/main/scala/vexriscv/demo/GenCustomSimdAdd.scala` CPU configuration
and is self-tested by the `src/test/cpp/custom/simd_add` application by running the following commands:

```sh
# Generate the CPU
sbt "runMain vexriscv.demo.GenCustomSimdAdd"

cd src/test/cpp/regression/

# Optionally add TRACE=yes if you want to get the VCD waveform from the simulation.
# Also you have to know that, by default, the testbench introduce instruction/data bus stall.
# Note the CUSTOM_SIMD_ADD flag is set to yes.
make clean run IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no DHRYSTONE=no REDO=2 CUSTOM_SIMD_ADD=yes
```

To retrieve the plugin related signals in your waveform viewer, just filter with `simd`.

## Adding a new CSR via the plugin system

Here are two examples about how to add a custom CSR to the CPU via the plugin system:
https://github.com/SpinalHDL/VexRiscv/blob/master/src/main/scala/vexriscv/demo/CustomCsrDemoPlugin.scala

The first one (`CustomCsrDemoPlugin`) adds an instruction counter and a clock cycle counter into the CSR mapping (and also do tricky stuff as a demonstration).

The second one (`CustomCsrDemoGpioPlugin`) creates a GPIO peripheral directly mapped into the CSR.

## CPU clock and resets

Without the debug plugin, the CPU will have a standard `clk` input and a `reset` input. But with the debug plugin the situation is the following:

- `clk`: as before, the clock which drives the whole CPU design, including the debug logic
- `reset`: reset all the CPU states except the debug logic
- `debugReset`: reset the debug logic of the CPU
- `debug_resetOut`: a CPU output signal which allows the JTAG to reset the CPU + the memory interconnect + the peripherals

So here is the reset interconnect, in case you use the debug plugin:

```
                                VexRiscv
                            +------------------+
                            |                  |
toplevelReset >----+--------> debugReset       |
                   |        |                  |
                   |  +-----< debug_resetOut   |
                   |  |     |                  |
                   +--or>-+-> reset            |
                          | |                  |
                          | +------------------+
                          |
                          +-> Interconnect / Peripherals
```


## VexRiscv Architecture

VexRiscv is implemented via a 5 stage in-order pipeline on which many optional and complementary plugins add functionalities to provide a functional RISC-V CPU.
This approach is completely unconventional and only possible through meta hardware description languages (SpinalHDL, in the current case) but has proven its advantages
via the VexRiscv implementation:

- You can swap/turn on/turn off parts of the CPU directly via the plugin system
- You can add new functionalities/instructions without having to modify any of the sources of the CPU
- It allows the CPU configuration to cover a very large spectrum of implementations without cooking spaghetti code
- It allows your codebase to truly produce a parametrized CPU design

If you generate the CPU without any plugin, it will only contain the definition of the 5 pipeline stages and their basic arbitration, but nothing else,
and everything else, including the program counter is added into the CPU via plugins.

### FPU

Features : 

- Support IEEE 754 float and optionaly double
- Implement Subnormal (few cycles lost in case of subnormal load/store)
- Implement exceptions flags
- The FPU can be shared between multiple CPU
- Can be integrated inside or outside the CPU via the FpuPlugin
- Fully pipelined, can produce one result per cycle for most operations (add,sub, mul, fma, load, store), as long there is no inter-dependancies
- Implement multiplication using multiple sub multiplication operations in parallel ("FPGA friendly")
- Division done with radix 4 (2 bits per cycle)
- Square root done with radix 2 (1 bit per cycle)
- Currently only compatible with the DBusCachedPlugin for load and store
- 64 bits Load and store can be done in one cycle via the DBusCachedPlugin (even if VexRiscv is RV32)

Accuracy, roundings (RNE, RTZ, RDN, RUP, RMM) and compliance: 

- Fully implemented excepted in the cases specified bellow
- In FMA, the result of the multiplication is rounded before the addition (keep mantissa width + 2 bits)
- A very special corner case of underflow flag do not follow IEEE 754 (rounding from subnormal to normal number)
- Very specific, but SGNJ instruction will not mutate the value from/to F32/F64 (no NaN-boxing mutation)
 
 There is a diagram of the FPU design and its CPU integration : 
 
 ![fpuDesign](assets/fpuDesign.png?raw=true "")
 
 The FPU can be parametrized with FpuParameter data structure : 
 
 | Parameters | type | description |
 | ------ | ----------- | ------ |
 | withDouble   | Boolean | Enable 64 bits floating point (32 bits always enabled) |
 | asyncRegFile   | Boolean | Implement the register file using combinatorial reads (instead of syncronous reads) |
 | mulWidthA   | Boolean | Specify the width of the left operand of multiplication blocks |
 | mulWidthB   | Boolean | Same than above but the the right operand |

Synthesis results of the FPU itself, without the CPU integration, on the fast speed grade : 

```
Fpu 32 bits ->
  Artix 7 relaxed -> 135 Mhz 1786 LUT 1778 FF 
  Artix 7 FMax    -> 205 Mhz 2101 LUT 1778 FF 
Fpu 64/32 bits ->
  Artix 7 relaxed -> 101 Mhz 3336 LUT 3033 FF 
  Artix 7 FMax    -> 165 Mhz 3728 LUT 3175 FF 
```

### Plugins

This chapter describes the currently implemented plugins.

- [IBusSimplePlugin](#ibussimpleplugin)
- [IBusCachedPlugin](#ibuscachedplugin)
- [DecoderSimplePlugin](#decodersimpleplugin)
- [RegFilePlugin](#regfileplugin)
- [HazardSimplePlugin](#hazardsimpleplugin)
- [SrcPlugin](#srcplugin)
- [IntAluPlugin](#intaluplugin)
- [LightShifterPlugin](#lightshifterplugin)
- [FullBarrelShifterPlugin](#fullbarrelshifterplugin)
- [BranchPlugin](#branchplugin)
- [DBusSimplePlugin](#dbussimpleplugin)
- [DBusCachedPlugin](#dbuscachedplugin)
- [MulPlugin](#mulplugin)
- [DivPlugin](#divplugin)
- [MulDivIterativePlugin](#muldiviterativeplugin)
- [CsrPlugin](#csrplugin)
- [StaticMemoryTranslatorPlugin](#staticmemorytranslatorplugin)
- [MemoryTranslatorPlugin](#memorytranslatorplugin)
- [DebugPlugin](#debugplugin)
- [YamlPlugin](#yamlplugin)
- [FpuPlugin](#fpuplugin)


#### IBusSimplePlugin

This plugin implements the CPU frontend (instruction fetch) via a very simple and neutral memory interface going outside the CPU.

| Parameters | type | description |
| ------ | ----------- | ------ |
| catchAccessFault | Boolean | When true, an instruction read response with read error asserted results in a CPU exception trap. |
| resetVector | BigInt | Address of the program counter after the reset. |
| cmdForkOnSecondStage | Boolean | When false, branches immediately update the program counter. This minimizes branch penalties but might reduce FMax because the instruction bus address signal is a combinatorial path. When true, this combinatorial path is removed and the program counter is updated one cycle after a branch is detected. While FMax may improve, an additional branch penalty will be incurred as well. |
| cmdForkPersistence  | Boolean | When false, requests on the iBus can disappear/change before they are acknowledged. This reduces area but isn't safe/supported by many arbitration/slaves. When true, once initiated, iBus requests will stay until they are acknowledged. |
| compressedGen | Boolean | Enable RISC-V compressed instruction (RVC) support. |
| busLatencyMin | Int | Specifies the minimal latency between the iBus.cmd and iBus.rsp. A corresponding number of stages are added to the frontend to keep the IPC to 1.|
| injectorStage | Boolean | When true, a stage between the frontend and the decode stage of the CPU is added to improve FMax. (busLatencyMin + injectorStage) should be at least two. |
| prediction | BranchPrediction | Can be set to NONE/STATIC/DYNAMIC/DYNAMIC_TARGET to specify the branch predictor implementation. See below for more details. |
| historyRamSizeLog2 | Int | Specify the number of entries in the direct mapped prediction cache of DYNAMIC/DYNAMIC_TARGET implementation. 2 pow historyRamSizeLog2 entries. |

Here is the SimpleBus interface definition:

```scala
case class IBusSimpleCmd() extends Bundle{
  val pc = UInt(32 bits)
}

case class IBusSimpleRsp() extends Bundle with IMasterSlave{
  val error = Bool
  val inst  = Bits(32 bits)

  override def asMaster(): Unit = {
    out(error,inst)
  }
}

case class IBusSimpleBus(interfaceKeepData : Boolean) extends Bundle with IMasterSlave{
  var cmd = Stream(IBusSimpleCmd())
  var rsp = Flow(IBusSimpleRsp())

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}
```

**Important** : check out the cmdForkPersistence parameter, because if it is not set, it can break the iBus compatibility with your memory system (unless you externaly add some buffers).

Setting cmdForkPersistence and cmdForkOnSecondStage improves iBus cmd timings.

The iBusSimplePlugin includes bridges to convert from the IBusSimpleBus to AXI4, Avalon, and Wishbone interfaces.

This plugin implements a jump interface that allows all other plugins to issue a jump:

```scala
trait JumpService{
  def createJumpInterface(stage : Stage) : Flow[UInt]
}
```

The stage argument specifies the stage from which the jump is asked. This allows the PcManagerSimplePlugin plugin to manage priorities between jump requests from
diffent stages.

#### IBusCachedPlugin

Simple and light multi-way instruction cache.

| Parameters | type | description |
| ------ | ----------- | ------ |
| resetVector | BigInt | Address of the program counter after the reset. |
| relaxedPcCalculation | Boolean | When false, branches immediately update the program counter. This minimizes branch penalties but might reduce FMax because the instruction bus address signal is a combinatorial path. When true, this combinatorial path is removed and the program counter is updated one cycle after a branch is detected. While FMax may improve, an additional branch penalty will be incurred as well. |
| prediction | BranchPrediction | Can be set to NONE/STATIC/DYNAMIC/DYNAMIC_TARGET to specify the branch predictor implementation. See below for more details. |
| historyRamSizeLog2 | Int | Specify the number of entries in the direct mapped prediction cache of DYNAMIC/DYNAMIC_TARGET implementation. 2 pow historyRamSizeLog2 entries |
| compressedGen | Boolean | Enable RISC-V compressed instruction (RVC) support. |
| config.cacheSize  | Int | Total storage capacity of the cache in bytes. |
| config.bytePerLine  | Int | Number of bytes per cache line  |
| config.wayCount  | Int | Number of cache ways |
| config.twoCycleRam  | Boolean | Check the tags values in the decode stage instead of the fetch stage to relax timings |
| config.asyncTagMemory  | Boolean | Read the cache tags in an asynchronous manner instead of syncronous one |
| config.addressWidth  | Int | CPU address width. Should be 32 |
| config.cpuDataWidth  | Int | CPU data width. Should be 32 |
| config.memDataWidth  | Int | Memory data width. Could potentialy be something else than 32, but only 32 is currently tested |
| config.catchIllegalAccess  | Boolean  | Catch when a memory access is done on non-valid memory address (MMU) |
| config.catchAccessFault  | Boolean | Catch when the memeory bus is responding with an error  |
| config.catchMemoryTranslationMiss  | Boolean  |  Catch when the MMU miss a TLB |

Note: If you enable the twoCycleRam option and if wayCount is bigger than one, then the register file plugin should be configured to read the regFile in an asynchronous manner.

#### DecoderSimplePlugin

This plugin provides instruction decoding capabilities to other plugins.

For instance, for a given instruction, the pipeline hazard plugin needs to know if it uses the register file source 1/2 in order to stall the pipeline until the hazard is gone.
Each plugin that implements an instruction provides this kind of information to the DecoderSimplePlugin plugin.

| Parameters | type | description |
| ------ | ----------- | ------ |
| catchIllegalInstruction | Boolean | When true, instructions that don't match a decoding specification will generate a trap exception  |

Here is a usage example:

```scala
    //Specify the instruction decoding which should be applied when the instruction matches the 'key' pattern
    decoderService.add(
      //Bit pattern of the new instruction
      key = M"0000011----------000-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_SIMD_ADD              -> True, //Inform the pipeline that the current instruction is a SIMD_ADD instruction
        REGFILE_WRITE_VALID      -> True, //Notify the hazard management unit that this instruction writes to the register file
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction uses the RS1 value
        RS2_USE                  -> True  //Same than above but for RS2.
      )
    )
  }
```

This plugin operates in the Decode stage.

#### RegFilePlugin

This plugin implements the register file.

| Parameters | type | description |
| ------ | ----------- | ------ |
| regFileReadyKind | RegFileReadKind | Can be set to ASYNC or SYNC. Specifies the kind of memory read used to implement the register file. ASYNC means zero cycle latency memory read, while SYNC means one cycle latency memory read which can be mapped into standard FPGA memory blocks   |
| zeroBoot | Boolean | Load all registers with zeroes at the beginning of the simulation to keep everything deterministic in logs/traces|

This register file use a `don't care` read-during-write policy, so the bypassing/hazard plugin should take care of this.

If you get a `Missing inserts : INSTRUCTION_ANTICIPATE` error, that's because the RegFilePlugin is configured to use SYNC memory read ports to access the register file, but the IBus plugin configuration can't provide the instruction's register file read address one cycle before the decode stage. To workaround that you can :

- Configure the RegFilePlugin to implement the register file read in a asyncronus manner (ASYNC), if your target device support such things
- If you use the IBusSimplePlugin, you need to enable the injectorStage configuration
- If you use the IBusCachedPlugin, you can either enable the injectorStage, or set twoCycleCache + twoCycleRam to false.

#### HazardSimplePlugin

This plugin checks the pipeline instruction dependencies and, if necessary or possible, will stop the instruction in the decoding stage or bypass the instruction results
from the later stages of the decode stage.

Since the register file is implemented with a `don't care` read-during-write policy, this plugin also manages these kind of hazards.

| Parameters | type | description |
| ------ | ----------- | ------ |
| bypassExecute | Boolean | Enable the bypassing of instruction results coming from the Execute stage |
| bypassMemory | Boolean | Enable the bypassing of instruction results coming from the Memory stage |
| bypassWriteBack | Boolean | Enable the bypassing of instruction results coming from the WriteBack stage |
| bypassWriteBackBuffer | Boolean | Enable the bypassing of the previous cycle register file written value  |

#### SrcPlugin

This plugin muxes different input values to produce SRC1/SRC2/SRC_ADD/SRC_SUB/SRC_LESS values which are common values used by many plugins in the execute stage (ALU/Branch/Load/Store).

| Parameters | type | description |
| ------ | ----------- | ------ |
| separatedAddSub | RegFileReadKind | By default SRC_ADD/SRC_SUB are generated from a single controllable adder/substractor, but if this is set to true, it use separate adder/substractors |
| executeInsertion | Boolean | By default SRC1/SRC2 are generated in the Decode stage, but if this parameter is true, it is done in the Execute stage (It will relax the bypassing network) |

Except for SRC1/SRC2, this plugin does everything at the begining of Execute stage.

#### IntAluPlugin

This plugin implements all ADD/SUB/SLT/SLTU/XOR/OR/AND/LUI/AUIPC instructions in the execute stage by using the SrcPlugin outputs. It is a really simple plugin.

The result is injected into the pipeline directly at the end of the execute stage.

#### LightShifterPlugin

Implements SLL/SRL/SRA instructions by using an iterative shifter register, while using one cycle per bit shift.

The result is injected into the pipeline directly at the end of the execute stage.

#### FullBarrelShifterPlugin

Implements SLL/SRL/SRA instructions by using a full barrel shifter, so it executes all shifts in a single cycle.

| Parameters | type | description |
| ------ | ----------- | ------ |
| earlyInjection | Boolean | By default the result of the shift is injected into the pipeline in the Memory stage to relax timings, but if this option is true it will be done in the Execute stage |

#### BranchPlugin

This plugin implements all branch/jump instructions (JAL/JALR/BEQ/BNE/BLT/BGE/BLTU/BGEU) with primitives used by the cpu frontend plugins to implement branch prediction. The prediction implementation is set in the frontend plugins (IBusX).

| Parameters | type | description |
| ------ | ----------- | ------ |
| earlyBranch | Boolean | By default the branch is done in the Memory stage to relax timings, but if this option is set it's done in the Execute stage|
| catchAddressMisaligned | Boolean | If a jump/branch is done in an unaligned PC address, it will fire an trap exception |

Each miss predicted jumps will produce between 2 and 4 cycles penalty depending the `earlyBranch` and the `PcManagerSimplePlugin.relaxedPcCalculation` configurations

##### Prediction NONE

No prediction: each PC change due to a jump/branch will produce a penalty.

##### Prediction STATIC

In the decode stage, a conditional branch pointing backwards or a JAL is branched speculatively. If the speculation is right, the branch penalty is reduced to a single cycle,
otherwise the standard penalty is applied.

##### Prediction DYNAMIC

Same as the STATIC prediction, except that to do the prediction, it uses a direct mapped 2 bit history cache (BHT) which remembers if the branch is more likely to be taken or not.

##### Prediction DYNAMIC_TARGET

This predictor uses a direct mapped branch target buffer (BTB) in the Fetch stage which stores the PC of the instruction, the target PC of the instruction and a 2 bit history to remember
if the branch is more likely to be taken or not. This is actually the most efficient branch predictor implemented on VexRiscv, because when the branch prediction is right, it produces no branch penalty.
The downside is that this predictor has a long combinatorial path coming from the prediction cache read port to the programm counter, passing through the jump interface.

#### DBusSimplePlugin

This plugin implements the load and store instructions (LB/LH/LW/LBU/LHU/LWU/SB/SH/SW) via a simple memory bus going out of the CPU.

| Parameters | type | description |
| ------ | ----------- | ------ |
| catchAddressMisaligned | Boolean | If a memory access is done to an unaligned memory address, it will fire a trap exception |
| catchAccessFault | Boolean | If a memory read returns an error, it will fire a trap exception  |
| earlyInjection | Boolean | By default, the memory read values are injected into the pipeline in the WriteBack stage to relax the timings. If this parameter is true, it's done in the Memory stage |

Here is the DBusSimpleBus

```scala
case class DBusSimpleCmd() extends Bundle{
  val wr = Bool
  val address = UInt(32 bits)
  val data = Bits(32 bit)
  val size = UInt(2 bit)
}

case class DBusSimpleRsp() extends Bundle with IMasterSlave{
  val ready = Bool
  val error = Bool
  val data = Bits(32 bit)

  override def asMaster(): Unit = {
    out(ready,error,data)
  }
}


case class DBusSimpleBus() extends Bundle with IMasterSlave{
  val cmd = Stream(DBusSimpleCmd())
  val rsp = DBusSimpleRsp()

  override def asMaster(): Unit = {
    master(cmd)
    slave(rsp)
  }
}
```

Note that there are bridges available that can convert this interface into AXI4 and Avalon.

There is at least one cycle latency between a cmd and the corresponding rsp. The rsp.ready flag should be false after a read cmd until the rsp is present.

#### DBusCachedPlugin

Multi way cache implementation with writh-through and allocate on read strategy. (Documentation is WIP)

#### MulPlugin

Implements the multiplication instruction from the RISC-V M extension. Its implementation was done in a FPGA friendly way by using 4 17*17 bit multiplications.
The processing is fully pipelined between the Execute/Memory/Writeback stage. The results of the instructions are always inserted in the WriteBack stage.

#### DivPlugin

Implements the division/modulo instruction from the RISC-V M extension. It is done in a simple iterative way which always takes 34 cycles. The result is inserted into the
Memory stage.

This plugin is now based on MulDivIterativePlugin.

#### MulDivIterativePlugin

This plugin implements the multiplication, division and modulo of the RISC-V M extension in an iterative way, which is friendly for small FPGAs that don't have DSP blocks.

This plugin is able to unroll the iterative calculation process to reduce the number of cycles used to execute mul/div instructions.

| Parameters | type | description |
| ------ | ----------- | ------ |
| genMul    | Boolean | Enables multiplication support. Can be set to false if you want to use the MulPlugin instead |
| genDiv    | Boolean |  Enables division support |
| mulUnrollFactor    | Int | Number of combinatorial stages used to speed up the multiplication, should be > 0 |
| divUnrollFactor    | Int | Number of combinatorial stages used to speed up the division, should be > 0 |

The number of cycles used to execute a multiplication is '32/mulUnrollFactor'
The number of cycles used to execute a division is '32/divUnrollFactor + 1'

Both mul/div are processed in the memory stage (late result).

#### CsrPlugin

Implements most of the Machine mode and a few of the User mode registers, as specified in the RISC-V priviledged spec.
The access mode of most of the CSR is parameterizable to reduce the area usage of unneeded features.

(CsrAccess can be `NONE/READ_ONLY/WRITE_ONLY/READ_WRITE`)

| Parameters | type | description |
| ------ | ----------- | ------ |
| catchIllegalAccess   | Boolean |  |
| mvendorid            | BigInt |  |
| marchid              | BigInt |  |
| mimpid               | BigInt |  |
| mhartid              | BigInt |  |
| misaExtensionsInit   | Int |  |
| misaAccess           | CsrAccess |  |
| mtvecAccess          | CsrAccess |  |
| mtvecInit            | BigInt |  |
| mepcAccess           | CsrAccess |  |
| mscratchGen          | Boolean |  |
| mcauseAccess         | CsrAccess |  |
| mbadaddrAccess       | CsrAccess |  |
| mcycleAccess         | CsrAccess |  |
| minstretAccess       | CsrAccess |  |
| ucycleAccess         | CsrAccess |  |
| wfiGen               | Boolean |  |
| ecallGen             | Boolean |  |

If an interrupt occurs, before jumping to mtvec, the plugin will stop the Prefetch stage and wait for all the instructions in the later pipeline stages to complete their execution.

If an exception occur, the plugin will kill the corresponding instruction, flush all previous instructions, and wait until the previously killed instructions reach the WriteBack
stage before jumping to mtvec.

#### StaticMemoryTranslatorPlugin

Static memory translator plugin which allows to specify which range of the memory addresses is I/O mapped and shouldn't be cached.

| Parameters | type | description |
| ------ | ----------- | ------ |
| ioRange   | UInt => Bool | Function reference which eat an address and return true if the address should be uncached. ex : ioRange= _(31 downto 28) === 0xF => all 0xFXXXXXXX will be uncached|


#### MmuPlugin

Hardware refilled MMU implementation. Allows other plugins such as DBusCachedPlugin/IBusCachedPlugin to instanciate memory address translation ports. Each port has a small dedicated
fully associative TLB cache which is refilled automaticaly via a dbus access sharing.

#### PmpPlugin

This is a physical memory protection (PMP) plugin which conforms to the latest RISC-V privilege specification. PMP is configured by writing two special CSRs: `pmpcfg#` and `pmpaddr#`. The former contains the permissions and addressing modes for four protection regions, and the latter contains the encoded start address for a single region. Since the actual region bounds must be computed from the values written to these registers, writing them takes a few CPU cylces. This delay is necessary in order to centralize all of the decoding logic into a single component. Otherwise, it would have to be duplicated for each region, even though the decoding operation happens only when PMP is reprogrammed (e.g., on some context switches).

#### DebugPlugin

This plugin implements enough CPU debug features to allow comfortable GDB/Eclipse debugging. To access those debug features, it provides a simple memory bus interface.
The JTAG interface is provided by another bridge, which makes it possible to efficiently connect multiple CPUs to the same JTAG.

| Parameters | type | description |
| ------ | ----------- | ------ |
| debugClockDomain   | ClockDomain | As the debug unit is able to reset the CPU itself, it should use another clock domain to avoid killing itself (only the reset wire should differ) |

The internals of the debug plugin are done in a manner which reduces the area usage and the FMax impact of this plugin.

Here is the simple bus to access it, the rsp comes one cycle after the request:

```scala
case class DebugExtensionCmd() extends Bundle{
  val wr = Bool
  val address = UInt(8 bit)
  val data = Bits(32 bit)
}
case class DebugExtensionRsp() extends Bundle{
  val data = Bits(32 bit)
}

case class DebugExtensionBus() extends Bundle with IMasterSlave{
  val cmd = Stream(DebugExtensionCmd())
  val rsp = DebugExtensionRsp()

  override def asMaster(): Unit = {
    master(cmd)
    in(rsp)
  }
}
```


Here is the register mapping:

```
Read address 0x00 ->
  bit 0  : resetIt
  bit 1  : haltIt
  bit 2  : isPipBusy
  bit 3  : haltedByBreak
  bit 4  : stepIt
Write address 0x00 ->
  bit 4  : stepIt
  bit 16 : set resetIt
  bit 17 : set haltIt
  bit 24 : clear resetIt
  bit 25 : clear haltIt and haltedByBreak

Read Address 0x04 ->
  bits (31 downto 0) : Last value written into the register file
Write Address 0x04 ->
  bits (31 downto 0) : Instruction that should be pushed into the CPU pipeline for debug purposes
```

The OpenOCD port is here: <https://github.com/SpinalHDL/openocd_riscv>

#### YamlPlugin

This plugin offers a service to other plugins to generate a useful Yaml file describing the CPU configuration. It contains, for instance, the sequence of instructions required
to flush the data cache (information used by openocd).


#### FpuPlugin

Allow the integration of a internal or a external FPU into VexRiscv (See the FPU chapter)

| Parameters | type | description |
| ------ | ----------- | ------ |
| externalFpu   | Boolean | When false the FPU is instanciated in Vex, else the plugin has a `port` interface to which you can connect an external FPU |
| p   | FpuParameter | Parameter with which the connected FPU will be created |

#### AesPlugin

This plugin allow to accelerate AES encryption/decryption by using an internal ROM to solve SBOX and permutations, allowing in practice to execute one AES round in about 21 cycles.

For more documentation, check src/main/scala/vexriscv/plugin/AesPlugin.scala, a software C driver can be found here : <https://github.com/SpinalHDL/SaxonSoc/blob/dev-0.3/software/standalone/driver/aes_custom.h>

It was also ported on libressl via the following patch :
<https://github.com/SpinalHDL/buildroot-spinal-saxon/blob/main/patches/libressl/0000-vexriscv-aes.patch>

Speed up of 4 was observed in libressl running in linux. <https://github.com/SpinalHDL/SaxonSoc/pull/53#issuecomment-730133020>