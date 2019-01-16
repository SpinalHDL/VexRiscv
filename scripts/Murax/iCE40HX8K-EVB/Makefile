

VERILOG = ../../../Murax.v toplevel.v toplevel_pll.v

generate :
	(cd ../../..; sbt "runMain vexriscv.demo.MuraxWithRamInit")

../../../Murax.v :
	(cd ../../..; sbt "runMain vexriscv.demo.MuraxWithRamInit")

../../../Murax.v*.bin:

bin/toplevel.blif : ${VERILOG} ../../../Murax.v*.bin
	mkdir -p bin
	rm -f Murax.v*.bin
	cp ../../../Murax.v*.bin . | true
	yosys -v3 -p "synth_ice40 -top toplevel -blif bin/toplevel.blif" ${VERILOG}

bin/toplevel.asc : toplevel.pcf bin/toplevel.blif
	arachne-pnr -p toplevel.pcf -d 8k --max-passes 600 -P ct256 bin/toplevel.blif -o bin/toplevel.asc

bin/toplevel.bin : bin/toplevel.asc
	icepack bin/toplevel.asc bin/toplevel.bin

compile : bin/toplevel.bin

time: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

prog : bin/toplevel.bin
	iceprogduino bin/toplevel.bin

sudo-prog : bin/toplevel.bin
	sudo iceprogduino bin/toplevel.bin

clean :
	rm -rf bin
	rm -f Murax.v*.bin
