

VERILOG = ../../../Murax.v toplevel.v

generate :
	(cd ../../..; sbt "run-main vexriscv.demo.Murax")

../../../Murax.v :
	(cd ../../..; sbt "run-main vexriscv.demo.Murax")

bin/toplevel.blif : ${VERILOG}
	mkdir -p bin
	yosys -v3 -p "synth_ice40 -top toplevel -blif bin/toplevel.blif" ${VERILOG}

bin/toplevel.asc : toplevel.pcf bin/toplevel.blif
	arachne-pnr -p toplevel.pcf -d 8k --max-passes 600 -P ct256 bin/toplevel.blif -o bin/toplevel.asc

bin/toplevel.bin : bin/toplevel.asc
	icepack bin/toplevel.asc bin/toplevel.bin

compile : bin/toplevel.bin

time: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

prog : bin/toplevel.bin
	sudo iceprog -S bin/toplevel.bin

clean :
	rm -rf bin