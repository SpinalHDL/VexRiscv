
.ONESHELL:

verilator/configure:
	rm -rf verilator*
	wget https://www.veripool.org/ftp/verilator-4.012.tgz
	tar xvzf verilator*.t*gz
	mv verilator-4.012 verilator

verilator/Makefile: verilator/configure
	cd verilator
	./configure

verilator/bin/verilator_bin: verilator/Makefile
	cd verilator
	make -j$(shell nproc)
	rm -rf src/obj_dbg
	rm -rf src/obj_opt

verilator_binary: verilator/bin/verilator_bin
