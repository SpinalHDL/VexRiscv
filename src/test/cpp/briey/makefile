DEBUG?=no
TRACE?=no
TRACE_INSTRUCTION?=no
TRACE_REG?=no
PRINT_PERF?=no
VGA?=yes
TRACE_START=0
ADDCFLAGS += -CFLAGS -pthread 
ADDCFLAGS += -CFLAGS -lSDL2
ADDCFLAGS += -LDFLAGS -lSDL2



ifeq ($(TRACE),yes)
	VERILATOR_ARGS += --trace
	ADDCFLAGS += -CFLAGS -DTRACE
endif
ifeq ($(DEBUG),yes)
	ADDCFLAGS += -CFLAGS "-g3 -O0"
endif
ifneq ($(DEBUG),yes)
	ADDCFLAGS += -CFLAGS "-O3"
endif
ifeq ($(PRINT_PERF),yes)
	ADDCFLAGS += -CFLAGS -DPRINT_PERF
endif

ifeq ($(VGA),yes)
	ADDCFLAGS += -CFLAGS -DVGA
endif
ifeq ($(TRACE_INSTRUCTION),yes)
	ADDCFLAGS += -CFLAGS -DTRACE_INSTRUCTION
endif

ifeq ($(TRACE_REG),yes)
	ADDCFLAGS += -CFLAGS -DTRACE_REG
endif

ADDCFLAGS += -CFLAGS -DTRACE_START=${TRACE_START}



all: clean compile

run: compile
	./obj_dir/VBriey

verilate: ../../../../Briey.v
	rm -f Briey.v*.bin
	cp ../../../../Briey.v*.bin . | true
	verilator -cc  ../../../../Briey.v -CFLAGS -std=c++11  ${ADDCFLAGS} --gdbbt ${VERILATOR_ARGS} -Wno-WIDTH -Wno-UNOPTFLAT --x-assign unique --exe main.cpp
 	
compile: verilate
	make  -j  -C obj_dir/ -f VBriey.mk VBriey
 	
clean:
	rm -f Briey.v*.bin
	rm -rf obj_dir
 	
