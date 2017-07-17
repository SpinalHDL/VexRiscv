## Index

- [Description](#description)
- [Area usage and maximal frequency](#area-usage-and-maximal-frequency)
- [Dependencies](#dependencies)
- [CPU generation](#cpu-generation)
- [Regression tests](#regression-tests)
- [Interactive debug of the simulated CPU via GDB OpenOCD and Verilator](#interactive-debug-of-the-simulated-cpu-via-gdb-openocd-and-verilator)
- [Using eclipse to run the software and debug it](#using-eclipse-to-run-the-software-and-debug-it)
- [Briey SoC](#briey-soc)
- [Build the RISC-V GCC](#build-the-risc-v-gcc)
- [CPU parametrization and instantiation example](#cpu-parametrization-and-instantiation-example)
- [Add a custom instruction to the CPU via the plugin system](#add-a-custom-instruction-to-the-cpu-via-the-plugin-system)

## Description

This repository host an RISC-V implementation written in SpinalHDL. There is some specs :

- RV32IM instruction set
- Pipelined on 5 stages (Fetch, Decode, Execute, Memory, WriteBack)
- 1.16 DMIPS/Mhz when all features are enabled
- Optimized for FPGA
- Optional MUL/DIV extension
- Optional instruction and data caches
- Optional MMU
- Optional debug extension allowing GDB debugging via an openOCD JTAG connection
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

The following number where obtains by synthesis the CPU as toplevel without any specific synthesis option to save area or to get better maximal frequency (neutral).
The used CPU corresponding configuration can be find in src/scala/VexRiscv/demo.

```
VexRiscv smallest (RV32I, 0.47 DMIPS/Mhz, no datapath bypass, no interrupt) ->
  Artix 7    -> 324 Mhz 478 LUT 539 FF 
  Cyclone V  -> 187 Mhz 341 ALMs
  Cyclone IV -> 180 Mhz 736 LUT 529 FF 
  Cyclone II -> 156 Mhz 740 LUT 528 FF 
  
VexRiscv smallest (RV32I, 0.47 DMIPS/Mhz, no datapath bypass) ->
  Artix 7    -> 335 Mhz 560 LUT 589 FF 
  Cyclone V  -> 182 Mhz 420 ALMs
  Cyclone IV -> 160 Mhz 852 LUT 579 FF 
  Cyclone II -> 144 Mhz 844 LUT 578 FF 
  
VexRiscv small and productive (RV32I, 0.78 DMIPS/Mhz)  ->
  Artix 7 -> 330 Mhz 719 LUT 557 FF 
  Cyclone V -> 153 Mhz 539 ALMs
  Cyclone IV -> 148 Mhz 1,127 LUT 552 FF 
  Cyclone II -> 114 Mhz 1,133 LUT 551 FF 

VexRiscv full no cache (RV32IM, 1.14 DMIPS/Mhz, single cycle barrel shifter, debug module, catch exceptions, static branch) ->
  Artix 7 -> 291 Mhz 1403 LUT 936 FF 
  Cyclone V -> 147 Mhz 928 ALMs
  Cyclone IV -> 137 Mhz 1,910 LUT 959 FF 
  Cyclone II -> 110 Mhz 1,940 LUT 958 FF 

VexRiscv full (RV32IM, 1.14 DMIPS/Mhz, I$, D$, single cycle barrel shifter, debug module, catch exceptions, static branch) ->
  Artix 7    -> 249 Mhz 1862 LUT 1498 FF 
  Cyclone V  -> 133 Mhz 1272 ALMs
  Cyclone IV -> 116 Mhz 2727 LUT 1759 FF 
  Cyclone II -> 105 Mhz 2771 LUT 1758 FF 
    
VexRiscv full with MMU (RV32IM, 1.16 DMIPS/Mhz, I$, D$, single cycle barrel shifter, debug module, catch exceptions, dynamic branch, MMU) ->
  Artix 7    -> 210 Mhz 2104 LUT 2017 FF 
  Cyclone V  -> 115 Mhz 1503 ALMs
  Cyclone IV -> 100 Mhz 3145 LUT 2278 FF 
  Cyclone II -> 92 Mhz 3195 LUT 2279 FF 
```

## Dependencies

On Ubuntu 14 :

```sh
# JAVA JDK 7 or 8
sudo apt-get install openjdk-7-jdk

# SBT
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt

# Verilator (for sim only)
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

## CPU generation
You can find two example of CPU instantiation in :
- src/main/scala/VexRiscv/GenFull.scala
- src/main/scala/VexRiscv/GenSmallest.scala

To generate the corresponding RTL as a VexRiscv.v file, run (it could take time the first time you run it):

NOTE :
The VexRiscv could need the unreleased master-head of SpinalHDL. If it fail to compile, just get the SpinalHDL repository and do a "sbt publish-local" in it.

```sh
sbt "run-main VexRiscv.demo.GenFull"

# or
sbt "run-main VexRiscv.demo.GenSmallest"
```

## Regression tests
To run tests (need the verilator simulator), go in the src/test/cpp/regression folder and run :

```sh
# To test the GenFull CPU
make clean run

# To test the GenSmallest CPU
make clean run IBUS=IBUS_SIMPLE DBUS=DBUS_SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no
```

## Interactive debug of the simulated CPU via GDB OpenOCD and Verilator
It's as described to run tests, but you just have to add DEBUG_PLUGIN_EXTERNAL=yes in the make arguments.
Work for the GenFull, but not for the GenSmallest as this configuration has no debug module.

Then you can use the https://github.com/SpinalHDL/openocd_riscv tool to create a GDB server connected to the target (the simulated CPU)

```sh
#in the VexRiscv repository, to run the simulation on which one OpenOCD can connect itself =>
sbt "run-main VexRiscv.demo.GenFull"
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
You can use the eclipse + zilin embedded CDT plugin to do it (http://opensource.zylin.com/embeddedcdt.html). Tested with Helios Service Release 2 and the corresponding zylin plugin.

## Briey SoC
As a demonstrator, a SoC named Briey is implemented in src/main/scala/VexRiscv/demo/Briey.scala. This SoC is very similar to the Pinsec one  :

<img src="http://cdn.rawgit.com/SpinalHDL/SpinalDoc/dd17971aa549ccb99168afd55aad274bbdff1e88/asset/picture/pinsec_hardware.svg"   align="middle" width="300">


To generate the Briey SoC Hardware :

```sh
sbt "run-main VexRiscv.demo.Briey"
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

You can find multiples software examples and demo there : https://github.com/SpinalHDL/BrieySoftware

You can find some FPGA project which instantiate the Briey SoC there (DE1-SoC, DE0-Nano): https://drive.google.com/drive/folders/0B-CqLXDTaMbKZGdJZlZ5THAxRTQ?usp=sharing

## Build the RISC-V GCC

To install in /opt/ the rv32i and rv32im gcc, do the following (will take hours):

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

You can find many example of different config in the https://github.com/SpinalHDL/VexRiscv/tree/master/src/main/scala/VexRiscv/demo folder. There is one :

```scala
//Instanciate one VexRiscv
val cpu = new VexRiscv(
  //Provide a configuration instance
  config = VexRiscvConfig(
    //Provide a list of plugins which will futher add their logic into the CPU
    plugins = List(
      new PcManagerSimplePlugin(
        resetVector = 0x00000000l,
        fastPcCalculation = true
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
import VexRiscv.Plugin.Plugin
import VexRiscv.{Stageable, DecoderService, VexRiscv}

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

    //Define some signals used internally to the plugin
    val rs1 = execute.input(RS1).asUInt //32 bits UInt value of the regfile[RS1]
    val rs2 = execute.input(RS2).asUInt
    val rd = UInt(32 bits)

    //Do some computation
    rd( 7 downto  0) := rs1( 7 downto  0) + rs2( 7 downto  0)
    rd(16 downto  8) := rs1(16 downto  8) + rs2(16 downto  8)
    rd(23 downto 16) := rs1(23 downto 16) + rs2(23 downto 16)
    rd(31 downto 24) := rs1(31 downto 24) + rs2(31 downto 24)

    //When the instruction is a SIMD_ADD one, then write the result into the register file data path.
    when(execute.input(IS_SIMD_ADD)){
      execute.output(REGFILE_WRITE_DATA) := rd.asBits
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