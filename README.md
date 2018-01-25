## Index

- [Description](#description)
- [Area usage and maximal frequency](#area-usage-and-maximal-frequency)
- [Dependencies](#dependencies)
- [CPU generation](#cpu-generation)
- [Regression tests](#regression-tests)
- [Interactive debug of the simulated CPU via GDB OpenOCD and Verilator](#interactive-debug-of-the-simulated-cpu-via-gdb-openocd-and-verilator)
- [Using eclipse to run the software and debug it](#using-eclipse-to-run-the-software-and-debug-it)
- [Briey SoC](#briey-soc)
- [Murax SoC](#murax-soc)
- [Build the RISC-V GCC](#build-the-risc-v-gcc)
- [CPU parametrization and instantiation example](#cpu-parametrization-and-instantiation-example)
- [Add a custom instruction to the CPU via the plugin system](#add-a-custom-instruction-to-the-cpu-via-the-plugin-system)
- [CPU clock and resets](#cpu-clock-and-resets)


## Description

This repository host an RISC-V implementation written in SpinalHDL. There is some specs :

- RV32IM instruction set
- Pipelined on 5 stages (Fetch, Decode, Execute, Memory, WriteBack)
- 1.29 DMIPS/Mhz when all features are enabled
- Optimized for FPGA, fully portable
- AXI4 and Avalon ready
- Optional MUL/DIV extension
- Optional instruction and data caches
- Optional MMU
- Optional debug extension allowing eclipse debugging via an GDB >> openOCD >> JTAG connection
- Optional interrupts and exception handling with the Machine and the User mode from the riscv-privileged-v1.9.1 spec.
- Two implementation of shift instructions, Single cycle / shiftNumber cycles
- Each stage could have bypass or interlock hazard logic
- FreeRTOS port https://github.com/Dolu1990/FreeRTOS-RISCV

The hardware description of this CPU is done by using an very software oriented approach
(without any overhead in the generated hardware). There is a list of software concepts used :

- There is very few fixed things. Nearly everything is plugin based. The PC manager is a plugin, the register file is a plugin, the hazard controller is a plugin ...
- There is an automatic a tool which allow plugins to insert data in the pipeline at a given stage, and allow other plugins to read it in another stages through automatic pipelining.
- There is an service system which provide a very dynamic framework. As instance, a plugin could provide an exception service which could then be used by others plugins to emit exceptions from the pipeline.

## Area usage and maximal frequency 

The following number where obtains by synthesis the CPU as toplevel without any specific synthesis option to save area or to get better maximal frequency (neutral).<br>
The clock constraint is set to a unattainable value, which tends to increase the design area.<br>
The dhrystone benchmark were compiled with -O3 -fno-inline<br>
All the cached configuration have some cache trashing during the dhrystone benchmark except the `VexRiscv full max perf` one. This of course reduce the performance. It is possible to produce dhrystone binaries which fit inside a 4KB I$ and 4KB D$ (I already had this case once) but currently it isn't the case.<br>
The used CPU corresponding configuration can be find in src/scala/vexriscv/demo.

```
VexRiscv smallest (RV32I, 0.51 DMIPS/Mhz, no datapath bypass, no interrupt) ->
  Artix 7    -> 346 Mhz 481 LUT 539 FF
  Cyclone V  -> 201 Mhz 347 ALMs
  Cyclone IV -> 190 Mhz 673 LUT 529 FF 
  Cyclone II -> 154 Mhz 673 LUT 528 FF 
  
VexRiscv smallest (RV32I, 0.51 DMIPS/Mhz, no datapath bypass) ->
  Artix 7    -> 340 Mhz 562 LUT 589 FF 
  Cyclone V  -> 202 Mhz 387 ALMs
  Cyclone IV -> 180 Mhz 780 LUT 579 FF 
  Cyclone II -> 149 Mhz 780 LUT 578 FF 
  
VexRiscv small and productive (RV32I, 0.82 DMIPS/Mhz)  ->
  Artix 7    -> 309 Mhz 703 LUT 557 FF 
  Cyclone V  -> 152 Mhz 502 ALMs
  Cyclone IV -> 147 Mhz 1,062 LUT 552 FF 
  Cyclone II -> 120 Mhz 1,072 LUT 551 FF 

VexRiscv full no cache (RV32IM, 1.20 DMIPS/Mhz, single cycle barrel shifter, debug module, catch exceptions, static branch) ->
  Artix 7    -> 310 Mhz 1391 LUT 934 FF 
  Cyclone V  -> 143 Mhz 935 ALMs
  Cyclone IV -> 123 Mhz 1,916 LUT 960 FF 
  Cyclone II -> 108 Mhz 1,939 LUT 959 FF 
  
VexRiscv full (RV32IM, 1.13 DMIPS/Mhz with cache trashing, 4KB-I$,4KB-D$, single cycle barrel shifter, debug module, catch exceptions, static branch) ->
  Artix 7    -> 250 Mhz 1911 LUT 1501 FF 
  Cyclone V  -> 132 Mhz 1,266 ALMs
  Cyclone IV -> 127 Mhz 2,733 LUT 1,762 FF 
  Cyclone II -> 103 Mhz 2,791 LUT 1,760 FF 
  
VexRiscv full max perf -> (RV32IM, 1.29 DMIPS/Mhz, 16KB-I$,16KB-D$, single cycle barrel shifter, debug module, catch exceptions, dynamic branch, branch and shift operations done in the Execute stage) ->
  Artix 7    -> 216 Mhz 1978 LUT 1442 FF 
  Cyclone V  -> 105 Mhz 1,222 ALMs
  Cyclone IV -> 94 Mhz 2,735 LUT 1,702 FF 

VexRiscv full with MMU (RV32IM, 1.17 DMIPS/Mhz with cache trashing, 4KB-I$, 4KB-D$, single cycle barrel shifter, debug module, catch exceptions, dynamic branch, MMU) ->
  Artix 7    -> 223 Mhz 2085 LUT 2020 FF 
  Cyclone V  -> 110 Mhz 1,503 ALMs
  Cyclone IV -> 108 Mhz 3,153 LUT 2,281 FF 
  Cyclone II -> 94 Mhz 3,187 LUT 2,281 FF 
```

There is the a summary of the configuration which produce 1.29 DMIPS : 

- 5 stage : F -> D -> E -> M  -> WB
- single cycle ADD/SUB/Bitwise/Shift ALU
- branch/jump done in the E stage
- memory load values are bypassed in the WB stage (late result) 
- 33 cycle division with bypassing in the M stage (late result)
- single cycle multiplication with bypassing in the WB stage (late result)
- dynamic branch prediction done in the D stage with an direct mapped 2 bit branch history cache

## Dependencies

On Ubuntu 14 :

```sh
# JAVA JDK 7 or 8
sudo apt-get install openjdk-8-jdk

# SBT
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt

# Verilator (for sim only, realy need 3.9+, in general apt-get will give you 3.8)
sudo apt-get install git make autoconf g++ flex bison
git clone http://git.veripool.org/git/verilator   # Only first time
unsetenv VERILATOR_ROOT  # For csh; ignore error if on bash
unset VERILATOR_ROOT  # For bash
cd verilator
git pull        # Make sure we're up-to-date
git tag         # See what versions exist
autoconf        # Create ./configure script
./configure
make
sudo make install
```

The VexRiscv need the unreleased master-head of SpinalHDL :

```sh
# Compile and localy publish the latest SpinalHDL
rm -rf SpinalHDL
git clone https://github.com/SpinalHDL/SpinalHDL.git
cd SpinalHDL
sbt clean compile publish-local
cd ..
```

## CPU generation
You can find two example of CPU instantiation in :
- src/main/scala/vexriscv/GenFull.scala
- src/main/scala/vexriscv/GenSmallest.scala

To generate the corresponding RTL as a VexRiscv.v file, run (it could take time the first time you run it):

NOTE :
The VexRiscv could need the unreleased master-head of SpinalHDL. If it fail to compile, just get the SpinalHDL repository and do a "sbt clean compile publish-local" in it as described in the dependencies chapter.

```sh
sbt "run-main vexriscv.demo.GenFull"

# or
sbt "run-main vexriscv.demo.GenSmallest"
```

## Regression tests
To run tests (need the verilator simulator), go in the src/test/cpp/regression folder and run :

```sh
# To test the GenFull CPU 
# (Don't worry about the CSR test not passing, basicaly the GenFull isn't the truly full version of the CPU, some CSR feature are disable in it)
make clean run

# To test the GenSmallest CPU
make clean run IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no
```

Those self tested tests include :
- ISA tests from https://github.com/riscv/riscv-tests/tree/master/isa
- Dhrystone benchmark
- 24 tests FreeRTOS tests
- Some handwritten tests to check the CSR, debug module and MMU plugins

You can enable FreeRTOS tests by adding 'FREERTOS=yes' in the command line, will take time. Also, it use THREAD_COUNT host CPU threads to run multiple regression in parallel.

## Interactive debug of the simulated CPU via GDB OpenOCD and Verilator
It's as described to run tests, but you just have to add DEBUG_PLUGIN_EXTERNAL=yes in the make arguments.
Work for the GenFull, but not for the GenSmallest as this configuration has no debug module.

Then you can use the https://github.com/SpinalHDL/openocd_riscv tool to create a GDB server connected to the target (the simulated CPU)

```sh
#in the VexRiscv repository, to run the simulation on which one OpenOCD can connect itself =>
sbt "run-main vexriscv.demo.GenFull"
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

## Using eclipse to run the software and debug it

### By using Zylin plugin
You can use the eclipse + Zylin embedded CDT plugin to do it (http://opensource.zylin.com/embeddedcdt.html). Tested with Helios Service Release 2 (http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz) and the corresponding zylin plugin.

To following commands will download eclipse and install the plugin.
```sh
wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz
tar -xvzf download.php?file=%2Ftechnology%2Fepp%2Fdownloads%2Frelease%2Fhelios%2FSR2%2Feclipse-cpp-helios-SR2-linux-gtk-x86_64.tar.gz
cd eclipse
./eclipse -application org.eclipse.equinox.p2.director -repository http://opensource.zylin.com/zylincdt -installIU com.zylin.cdt.feature.feature.group/
```

See https://drive.google.com/drive/folders/1NseNHH05B6lmIXqQFVwK8xRjWE4ydeG-?usp=sharing to import a makefile project and create a debug configuration.

Note that sometime this eclipse need to be restarted in order to be able to place new breakpoints.

### By using FreedomStudio

You can get FreedomStudio (which is package with eclipse and some plugins) there https://www.sifive.com/products/tools/

See https://drive.google.com/drive/folders/1a7FyMOYgFc9UDhfsWUSCjyqDCvOrts2J?usp=sharing to import a makefile project and create a debug configuration.


## Briey SoC
As a demonstrator, a SoC named Briey is implemented in src/main/scala/vexriscv/demo/Briey.scala. This SoC is very similar to the Pinsec one  :

![Alt text](assets/brieySoc.png?raw=true "")


To generate the Briey SoC Hardware :

```sh
sbt "run-main vexriscv.demo.Briey"
```

To run the verilator simulation of the Briey SoC which can be then connected to OpenOCD/GDB, first get those dependencies :

```sh
sudo apt-get install build-essential xorg-dev libudev-dev libts-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev libpulse-dev libopenal-dev libogg-dev libvorbis-dev libaudiofile-dev libpng12-dev libfreetype6-dev libusb-dev libdbus-1-dev zlib1g-dev libdirectfb-dev libsdl2-dev
```

Then go in src/test/cpp/briey and run the simulation with (UART TX is printed in the terminal, VGA is displayed in a GUI):

```sh
make clean run
```

To connect OpenOCD (https://github.com/SpinalHDL/openocd_riscv) to the simulation :

```sh
src/openocd -f tcl/interface/jtag_tcp.cfg -c "set BRIEY_CPU0_YAML /home/spinalvm/Spinal/VexRiscv/cpu0.yaml" -f tcl/target/briey.cfg
```

You can find multiples software examples and demo there : https://github.com/SpinalHDL/VexRiscvSocSoftware/tree/master/projects/briey

You can find some FPGA project which instantiate the Briey SoC there (DE1-SoC, DE0-Nano): https://drive.google.com/drive/folders/0B-CqLXDTaMbKZGdJZlZ5THAxRTQ?usp=sharing

There is some measurements of Briey SoC timings and area : 

```
  Artix 7    -> 231 Mhz 3339 LUT 3533 FF
  Cyclone V  -> 124 Mhz 2,264 ALMs
  Cyclone IV -> 124 Mhz 4,709 LUT 3,716 FF
```

## Murax SoC

Murax is a very light SoC (fit in ICE40 FPGA) which could work without any external component.
- VexRiscv RV32I[M]
- JTAG debugger (eclipse/GDB/openocd ready)
- 8 kB of on-chip ram
- Interrupt support
- APB bus for peripherals
- 32 GPIO pin
- one 16 bits prescaler, two 16 bits timers
- one UART with tx/rx fifo

Depending the CPU configuration, on the ICE40-hx8k FPGA with icestorm for synthesis, the full SoC will get following area/performance :
- RV32I interlocked stages => 51 Mhz, 2387 LC 0.37 DMIPS/Mhz
- RV32I bypassed stages    => 45 Mhz, 2718 LC 0.55 DMIPS/Mhz

You can find its implementation there : src/main/scala/vexriscv/demo/Murax.scala


To generate the Murax SoC Hardware :

```sh
# To generate the SoC without any content in the ram
sbt "run-main vexriscv.demo.Murax"

# To generate the SoC with a demo program in the SoC
# Will blink led and echo UART RX to UART TX   (in the verilator sim, type some text and press enter to send UART frames to the Murax RX pin)
sbt "run-main vexriscv.demo.MuraxWithRamInit"
```

Then go in src/test/cpp/murax and run the simulation with :

```sh
make clean run
```

To connect OpenOCD (https://github.com/SpinalHDL/openocd_riscv) to the simulation :

```sh
src/openocd -f tcl/interface/jtag_tcp.cfg -c "set MURAX_CPU0_YAML /home/spinalvm/Spinal/VexRiscv/cpu0.yaml" -f tcl/target/murax.cfg
```

You can find multiples software examples and demo there : https://github.com/SpinalHDL/VexRiscvSocSoftware/tree/master/projects/murax

There is some measurements of Murax SoC timings and area  :

```
Murax interlocked stages (0.37 DMIPS/Mhz) ->
  Artix 7    -> 304 Mhz 1016 LUT 1296 FF
  Cyclone V  -> 165 Mhz 736 ALMs
  Cyclone IV -> 151 Mhz 1,463 LUT 1,254 FF
  ICE40-HX   ->  51 Mhz 2387 LC (icestorm)

MuraxFast bypassed stages (0.55 DMIPS/Mhz) ->
  Artix 7    -> 301 Mhz 1248 LUT 1393 FF
  Cyclone V  -> 163 Mhz 872 ALMs
  Cyclone IV -> 145 Mhz 1,712 LUT 1,288 FF
  ICE40-HX   ->  45 Mhz, 2718 LC  (icestorm)
```

There is some scripts to generate the SoC and call the icestorm toolchain there : scripts/Murax/

Note that now a toplevel simulation testbench with the same feature + a GUI is implemented with SpinalSim. You can find it in src/test/scala/vexriscv/MuraxSim.scala.

To run it : 

```sh
#This will generate the Murax RTL + run its testbench. You need Verilator 3.9xx installated.
sbt "test:runMain vexriscv.MuraxSim"
```

## Build the RISC-V GCC

In fact, now you can find some prebuild GCC : <br>
- https://www.sifive.com/products/tools/   =>   SiFive GNU Embedded Toolchain
The VexRiscvSocSoftware makefiles are expecting to find this prebuild version in /opt/riscv/__contentOfThisPreBuild__

```sh
wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6.tar.gz
tar -xzvf riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6.tar.gz
sudo mv riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6 /opt/riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6
sudo mv /opt/riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6 /opt/riscv
echo 'export PATH=/opt/riscv/bin:$PATH' >> ~/.bashrc 
```

But if you want to compile from sources in /opt/ the rv32i and rv32im gcc, do the following (will take one hour):

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

You can find many example of different config in the https://github.com/SpinalHDL/VexRiscv/tree/master/src/main/scala/vexriscv/demo folder. There is one :

```scala
import vexriscv._
import vexriscv.plugin._

//Instanciate one VexRiscv
val cpu = new VexRiscv(
  //Provide a configuration instance
  config = VexRiscvConfig(
    //Provide a list of plugins which will futher add their logic into the CPU
    plugins = List(
      new PcManagerSimplePlugin(
        resetVector = 0x00000000l,
        relaxedPcCalculation = true
      ),
      new IBusSimplePlugin(
        interfaceKeepData = false,
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
        catchAddressMisaligned = false,
        prediction = NONE
      ),
      new YamlPlugin("cpu0.yaml")
    )
  )
)
```

## Add a custom instruction to the CPU via the plugin system

There is an example of an simple plugin which add an simple SIMD_ADD instruction :

```scala
import spinal.core._
import vexriscv.plugin.Plugin
import vexriscv.{Stageable, DecoderService, VexRiscv}

//This plugin example will add a new instruction named SIMD_ADD which do the following :
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
  //Define the concept of IS_SIMD_ADD signals, which specify if the current instruction is destined for ths plugin
  object IS_SIMD_ADD extends Stageable(Bool)

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._

    //Retrieve the DecoderService instance
    val decoderService = pipeline.service(classOf[DecoderService])

    //Specify the IS_SIMD_ADD default value when instruction are decoded
    decoderService.addDefault(IS_SIMD_ADD, False)

    //Specify the instruction decoding which should be applied when the instruction match the 'key' parttern
    decoderService.add(
      //Bit pattern of the new SIMD_ADD instruction
      key = M"0000011----------000-----0110011",

      //Decoding specification when the 'key' pattern is recognized in the instruction
      List(
        IS_SIMD_ADD              -> True,
        REGFILE_WRITE_VALID      -> True, //Enable the register file write
        BYPASSABLE_EXECUTE_STAGE -> True, //Notify the hazard management unit that the instruction result is already accessible in the EXECUTE stage (Bypass ready)
        BYPASSABLE_MEMORY_STAGE  -> True, //Same as above but for the memory stage
        RS1_USE                  -> True, //Notify the hazard management unit that this instruction use the RS1 value
        RS2_USE                  -> True  //Same than above but for RS2.
      )
    )
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._

    //Add a new scope on the execute stage (used to give a name to signals)
    execute plug new Area {
      //Define some signals used internally to the plugin
      val rs1 = execute.input(RS1).asUInt
      //32 bits UInt value of the regfile[RS1]
      val rs2 = execute.input(RS2).asUInt
      val rd = UInt(32 bits)

      //Do some computation
      rd(7 downto 0) := rs1(7 downto 0) + rs2(7 downto 0)
      rd(16 downto 8) := rs1(16 downto 8) + rs2(16 downto 8)
      rd(23 downto 16) := rs1(23 downto 16) + rs2(23 downto 16)
      rd(31 downto 24) := rs1(31 downto 24) + rs2(31 downto 24)

      //When the instruction is a SIMD_ADD one, then write the result into the register file data path.
      when(execute.input(IS_SIMD_ADD)) {
        execute.output(REGFILE_WRITE_DATA) := rd.asBits
      }
    }
  }
}
```

Then if you want to add this plugin to a given CPU, you just need to add it in its parameterized plugin list.

This example is a very simple one, but each plugin can really have access to the whole CPU
- Halt a given stage of the CPU
- Unschedule instructions
- Emit an exception
- Introduce new instruction decoding specification
- Ask to jump the PC somewhere
- Read signals published by other plugins
- override published signals values
- Provide an alternative implementation
- ...

As a demonstrator, this SimdAddPlugin was integrated in the src/main/scala/vexriscv/demo/GenCustomSimdAdd.scala CPU configuration and is self tested by the src/test/cpp/custom/simd_add application by running the following commands :

```sh
# Generate the CPU
sbt "run-main vexriscv.demo.GenCustomSimdAdd"

cd src/test/cpp/regression/

# Optionally add TRACE=yes if you want to get the VCD waveform from the simulation.
# Also you have to know that by default, the testbench introduce instruction/data bus stall.
# Note the CUSTOM_SIMD_ADD flag is set to yes.
make clean run IBUS=SIMPLE DBUS=SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no DHRYSTONE=no REDO=2 CUSTOM_SIMD_ADD=yes
```

To retrieve the plugin related signals in the wave, just filter with `simd`.

## CPU clock and resets

Without the debug plugin, the CPU will have `clk` input and a `reset` input, which is very standard. But with the debug plugin the situation is the following :

- clk : As before, the clock which drive the whole CPU design, including the debug logic
- reset : Reset all the CPU states excepted the debug logics
- debugReset : Reset the debug logic of the CPU
- debug_resetOut : It is a CPU output signal which allow the JTAG to reset the CPU + the memory interconnect + the peripherals

So there is the reset interconnect in case you use the debug plugin :

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
