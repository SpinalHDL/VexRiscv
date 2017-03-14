run: compile
	./obj_dir/VVexRiscv

verilate:
	verilator -cc  ../../../../VexRiscv.v -O3 -CFLAGS -std=c++11  --gdbbt --trace -Wno-WIDTH --x-assign unique --exe main.cpp
 	
compile: verilate
	make  -j -C obj_dir/ -f VVexRiscv.mk VVexRiscv
 	
clean:
	rm -rf obj_dir
 	
