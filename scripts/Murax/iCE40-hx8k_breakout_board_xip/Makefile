
VBASE = ../../..
VNAME = Murax_iCE40_hx8k_breakout_board_xip
VERILOG = ${VBASE}/${VNAME}.v

all: prog

${VERILOG} :
	(cd ${VBASE}; sbt "runMain vexriscv.demo.${VNAME}")

generate : ${VERILOG}

${VERILOG}*.bin:

bin/Murax_iCE40_hx8k_breakout_board_xip.blif : ${VERILOG} ${VERILOG}*.bin
	mkdir -p bin
	rm -f Murax_iCE40_hx8k_breakout_board_xip.v*.bin
	cp ${VERILOG}*.bin . | true
	yosys -v3 -p "synth_ice40 -top Murax_iCE40_hx8k_breakout_board_xip -blif bin/Murax_iCE40_hx8k_breakout_board_xip.blif" ${VERILOG}

bin/Murax_iCE40_hx8k_breakout_board_xip.asc : Murax_iCE40_hx8k_breakout_board_xip.pcf bin/Murax_iCE40_hx8k_breakout_board_xip.blif
	arachne-pnr -p Murax_iCE40_hx8k_breakout_board_xip.pcf -d 8k --max-passes 600 -P ct256 bin/Murax_iCE40_hx8k_breakout_board_xip.blif -o bin/Murax_iCE40_hx8k_breakout_board_xip.asc

bin/Murax_iCE40_hx8k_breakout_board_xip.bin : bin/Murax_iCE40_hx8k_breakout_board_xip.asc
	icepack bin/Murax_iCE40_hx8k_breakout_board_xip.asc bin/Murax_iCE40_hx8k_breakout_board_xip.bin

compile : bin/Murax_iCE40_hx8k_breakout_board_xip.bin

time: bin/Murax_iCE40_hx8k_breakout_board_xip.bin
	icetime -tmd hx8k bin/Murax_iCE40_hx8k_breakout_board_xip.asc

prog : bin/Murax_iCE40_hx8k_breakout_board_xip.bin
	lsusb -d 0403:6010
	iceprog -S bin/Murax_iCE40_hx8k_breakout_board_xip.bin

sudo-prog : bin/Murax_iCE40_hx8k_breakout_board_xip.bin
	sudo lsusb -d 0403:6010
	sudo iceprog -S bin/Murax_iCE40_hx8k_breakout_board_xip.bin

clean :
	rm -rf bin
	rm -f Murax_iCE40_hx8k_breakout_board_xip.v*.bin
	rm -f ${VERILOG}*.bin
	rm -f ${VERILOG}
