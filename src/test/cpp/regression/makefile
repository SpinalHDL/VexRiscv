IBUS=IBUS_CACHED
DBUS=DBUS_SIMPLE
TRACE?=no
TRACE_ACCESS?=no
TRACE_START=0
CSR=yes
MMU=yes
DEBUG_PLUGIN=yes
DEBUG_PLUGIN_EXTERNAL?=no
DHRYSTONE=yes
FREE_RTOS=no
REDO=10
REF=no
TRACE_WITH_TIME=no
REF_TIME=no

ADDCFLAGS += -CFLAGS -D${IBUS}
ADDCFLAGS += -CFLAGS -D${DBUS}
ADDCFLAGS += -CFLAGS -DREDO=${REDO}
ADDCFLAGS += -CFLAGS -pthread


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

ifeq ($(REF_TIME),yes)
	ADDCFLAGS += -CFLAGS -DREF_TIME
endif

ifeq ($(MMU),yes)
	ADDCFLAGS += -CFLAGS -DMMU
endif

ifeq ($(TRACE_ACCESS),yes)
	ADDCFLAGS += -CFLAGS -DTRACE_ACCESS
endif

ifeq ($(DEBUG_PLUGIN),yes)
	ADDCFLAGS += -CFLAGS -DDEBUG_PLUGIN
endif

ifeq ($(DEBUG_PLUGIN_EXTERNAL),yes)
	ADDCFLAGS += -CFLAGS -DDEBUG_PLUGIN_EXTERNAL
endif

ifeq ($(REF),yes)
	ADDCFLAGS += -CFLAGS -DREF
endif

ADDCFLAGS += -CFLAGS -DTRACE_START=${TRACE_START}
ifeq ($(FREE_RTOS),yes)
	ADDCFLAGS += -CFLAGS -DFREE_RTOS
endif

all: clean run

run: compile
	./obj_dir/VVexRiscv

verilate:
	verilator -cc  ../../../../VexRiscv.v  -O3 -CFLAGS -std=c++11 -LDFLAGS -pthread  ${ADDCFLAGS} --gdbbt ${VERILATOR_ARGS} -Wno-WIDTH --x-assign unique --exe main.cpp
 	
compile: verilate
	make  -j  -C obj_dir/ -f VVexRiscv.mk VVexRiscv
 	
clean:
	rm -rf obj_dir
 	
