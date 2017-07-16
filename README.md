This repository host an RISC-V implementation written in SpinalHDL. There is some specs :

- RV32IM instruction set
- Interrupts and exception handling with the Machine mode from the riscv-privileged-v1.9.1 specification.
- Pipelined on 5 stages (Fetch, Decode, Execute, Memory, WriteBack)
- 1.17 DMIPS/Mhz when all features are enabled extension
- Optimized for FPGA
- Optional MUL/DIV/REM extension
- Optional instruction and data caches
- Optional MMU
- Two implementation of shift instructions, Single cycle / shiftNumber cycle
- Each stage could have bypass or interlock hazard logic
- FreeRTOS port https://github.com/Dolu1990/FreeRTOS-RISCV

The hardware description of this CPU is done by using an very software oriented approach
(without any overhead in the generated hardware). There is a list of software concepts used :

- There is very few fixed things. Nearly everything is plugin based. The PC manager is a plugin, the register file is a plugin, the hazard controller is a plugin ...
- There is an automatic a tool which allow plugins to insert data in the pipeline at a given stage, and allow other plugins to read it in another stages through automatic pipelining.
- There is an service system which provide a very dynamic framework. As instance, a plugin could provide an exception service which could then be used by others plugins to emit exceptions from the pipeline.

## Area / FMax 

The following number where obtains by synthesis the CPU as toplevel without any specific synthesis option to save area or to get better maximal frequency (neutral).
The used CPU corresponding configuration can be find in src/scala/VexRiscv/demo.

```
VexRiscv smallest no CSR ->
  Artix 7    -> 324 Mhz 478 LUT 539 FF 
  Cyclone V  -> 187 Mhz 341 ALMs
  Cyclone IV -> 180 Mhz 736 LUT 529 FF 
  Cyclone II -> 156 Mhz 740 LUT 528 FF 
  
VexRiscv smallest ->
  Artix 7    -> 335 Mhz 560 LUT 589 FF 
  Cyclone V  -> 182 Mhz 420 ALMs
  Cyclone IV -> 160 Mhz 852 LUT 579 FF 
  Cyclone II -> 144 Mhz 844 LUT 578 FF 
  
VexRiscv full no MMU ->
  Artix 7    -> 227 Mhz 2280 LUT 1728 FF 
  Cyclone V  -> 120 Mhz 1,540 ALMs
  Cyclone IV -> 120 Mhz 3,282 LUT 1,987 FF 
  Cyclone II -> 101 Mhz 3,347 LUT 1,986 FF 
  
VexRiscv full ->
  Artix 7    -> 210 Mhz 2542 LUT 2246 FF 
  Cyclone V  -> 114 Mhz 1,815 ALMs
  Cyclone IV -> 96 Mhz 3,717 LUT 2,505 FF 
  Cyclone II -> 94 Mhz 3,772 LUT 2,506 FF 
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

## Tests
To run tests (need the verilator simulator), go in the src/test/cpp/regression folder and run :

```sh
# To test the GenFull CPU
make clean run

# To test the GenSmallest CPU
make clean run IBUS=IBUS_SIMPLE DBUS=DBUS_SIMPLE CSR=no MMU=no DEBUG_PLUGIN=no MUL=no DIV=no
```

## Interactive debug of the simulated CPU via GDB/OpenOCD in Verilator
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
You can use the eclipse + zilin embedded CDT plugin to do it.

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

## Cpu plugin structure

There is an example of an pseudo ALU plugin :

```scala
//Define an signal name/type which could be used in the pipeline
object ALU_ENABLE extends Stageable(Bool)
object ALU_OP     extends Stageable(Bits(2  bits))  // ADD, SUB, AND, OR
object ALU_SRC1   extends Stageable(UInt(32 bits))
object ALU_SRC2   extends Stageable(UInt(32 bits))
object ALU_RESULT extends Stageable(UInt(32 bits))

class AluPlugin() extends Plugin[VexRiscv]{

  //Callback to setup the plugin and ask for different services
  override def setup(pipeline: VexRiscv): Unit = {
    import pipeline.config._
    //Do some setups as for example specifying some instruction decoding by using the Decoding service
    val decoderService = pipeline.service(classOf[DecoderService])

    decoderService.addDefault(ALU_ENABLE,False)
    decodingService.add(List(
        M"0100----------" -> List(ALU_ENABLE -> True, ALU_OP -> B"01"),
        M"0110---11-----" -> List(ALU_ENABLE -> True, ...)
    ))
  }


  //Callback to build the hardware logic
  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._

    execute plug new Area {
      import execute._
      //Add some logic in the execute stage
      insert(ALU_RESULT) := input(ALU_OP).mux(
        B"00" -> input(ALU_SRC1) + input(ALU_SRC2),
        B"01" -> input(ALU_SRC1) - input(ALU_SRC2),
        B"10" -> input(ALU_SRC1) & input(ALU_SRC2),
        B"11" -> input(ALU_SRC1) | input(ALU_SRC2),
      )
    }

    writeBack plug new Area {
      import writeBack._
      //Add some logic in the execute stage
      when(input(ALU_ENABLE)){
        input(REGFILE_WRITE_DATA) := input(ALU_RESULT)
      }
    }
  }
}
```
