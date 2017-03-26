TRACE=no
TRACE_START=0
CSR=yes
DHRYSTONE=yes
FREE_RTOS=yes
REDO=10
REF=no
TRACE_WITH_TIME=no

ADDCFLAGS += -CFLAGS -DREDO=${REDO}
ifeq ($(DHRYSTONE),yes)
	ADDCFLAGS += -CFLAGS -DDHRYSTONE
endif

ifeq ($(TRACE),yes)
	VERILATOR_ARGS += --trace
	ADDCFLAGS += -CFLAGS -DTRACE
endif

ifeq ($(CSR),yes)
	ADDCFLAGS += -CFLAGS -DCSR
endif

ifeq ($(TRACE_WITH_TIME),yes)
	ADDCFLAGS += -CFLAGS -DTRACE_WITH_TIME
endif

ifeq ($(REF),yes)
	ADDCFLAGS += -CFLAGS -DREF
endif

ADDCFLAGS += -CFLAGS -DTRACE_START=${TRACE_START}
ifeq ($(FREE_RTOS),yes)
	ADDCFLAGS += -CFLAGS -DFREE_RTOS
endif


run: compile
	./obj_dir/VVexRiscv

verilate:
	verilator -cc  ../../../../VexRiscv.v  -O3 -CFLAGS -std=c++11  ${ADDCFLAGS} --gdbbt ${VERILATOR_ARGS} -Wno-WIDTH --x-assign unique --exe main.cpp
 	
compile: verilate
	make  -j -C obj_dir/ -f VVexRiscv.mk VVexRiscv
 	
clean:
	rm -rf obj_dir
 	
