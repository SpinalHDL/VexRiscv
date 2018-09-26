

VERILOG = ../../../Murax_iCE40_hx8k_breakout_board_xip.v

generate :
	#(cd ../../..; sbt "run-main vexriscv.demo.Murax_iCE40_hx8k_breakout_board_xip")

../../../Murax_iCE40_hx8k_breakout_board_xip.v :
	#(cd ../../..; sbt "run-main vexriscv.demo.Murax_iCE40_hx8k_breakout_board_xip")

../../../Murax_iCE40_hx8k_breakout_board_xip.v*.bin:

bin/Murax_iCE40_hx8k_breakout_board_xip.blif : ${VERILOG} ../../../Murax_iCE40_hx8k_breakout_board_xip.v*.bin
	mkdir -p bin
	rm -f Murax_iCE40_hx8k_breakout_board_xip.v*.bin
	cp ../../../Murax_iCE40_hx8k_breakout_board_xip.v*.bin . | true
	yosys -v3 -p "synth_ice40 -top Murax_iCE40_hx8k_breakout_board_xip -blif bin/Murax_iCE40_hx8k_breakout_board_xip.blif" ${VERILOG}

bin/Murax_iCE40_hx8k_breakout_board_xip.asc : Murax_iCE40_hx8k_breakout_board_xip.pcf bin/Murax_iCE40_hx8k_breakout_board_xip.blif
	arachne-pnr -p Murax_iCE40_hx8k_breakout_board_xip.pcf -d 8k --max-passes 600 -P ct256 bin/Murax_iCE40_hx8k_breakout_board_xip.blif -o bin/Murax_iCE40_hx8k_breakout_board_xip.asc

bin/Murax_iCE40_hx8k_breakout_board_xip.bin : bin/Murax_iCE40_hx8k_breakout_board_xip.asc
	icepack bin/Murax_iCE40_hx8k_breakout_board_xip.asc bin/Murax_iCE40_hx8k_breakout_board_xip.bin

compile : bin/Murax_iCE40_hx8k_breakout_board_xip.bin

time: bin/Murax_iCE40_hx8k_breakout_board_xip.bin
	icetime -tmd hx8k bin/Murax_iCE40_hx8k_breakout_board_xip.asc

prog : bin/Murax_iCE40_hx8k_breakout_board_xip.bin
	iceprog -S bin/Murax_iCE40_hx8k_breakout_board_xip.bin

sudo-prog : bin/Murax_iCE40_hx8k_breakout_board_xip.bin
	sudo iceprog -S bin/Murax_iCE40_hx8k_breakout_board_xip.bin

clean :
	rm -rf bin
	rm -f Murax_iCE40_hx8k_breakout_board_xip.v*.bin
