VERILOG = ../../../Murax.v toplevel.v

generate :
	(cd ../../..; sbt "runMain vexriscv.demo.MuraxWithRamInit")

../../../Murax.v :
	(cd ../../..; sbt "runMain vexriscv.demo.MuraxWithRamInit")

../../../Murax.v*.bin:

bin/toplevel.json : ${VERILOG} ../../../Murax.v*.bin
	mkdir -p bin
	rm -f Murax.v*.bin
	cp ../../../Murax.v*.bin . | true
	yosys -v3 -p "synth_ice40 -device u -top toplevel -json bin/toplevel.json" ${VERILOG}

bin/toplevel.asc : io.pcf bin/toplevel.json
	nextpnr-ice40 --up5k --pcf io.pcf --package sg48 --json bin/toplevel.json --asc bin/toplevel.asc

bin/toplevel.bin : bin/toplevel.asc
	icepack bin/toplevel.asc bin/toplevel.bin

compile : bin/toplevel.bin

time: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

prog : bin/toplevel.bin
	icesprog bin/toplevel.bin

clean :
	rm -f ../../../Murax.v
	rm -rf bin
	rm -f Murax.v*.bin
