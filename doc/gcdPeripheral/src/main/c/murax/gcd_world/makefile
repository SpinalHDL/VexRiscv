PROJ_NAME=gcd_world
DEBUG=no
BENCH=no
MULDIV=no

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp)  \
		$(wildcard src/*.S)

OBJDIR = build

INC  =
LIBS =
LIBSINC = -L$(OBJDIR)
LDSCRIPT = ./src/linker.ld

#include ../../../resources/gcc.mk
# Set it to yes if you are using the sifive precompiled GCC pack
SIFIVE_GCC_PACK ?= no

ifeq ($(SIFIVE_GCC_PACK),yes)
	RISCV_NAME ?= riscv64-unknown-elf
	RISCV_PATH ?= /home/sallar/tools/riscv-64-newlib-dist/
else
	RISCV_NAME ?= riscv32-unknown-elf
	ifeq ($(MULDIV),yes)
		RISCV_PATH ?= /home/sallar/tools/riscv-32-imac-ilp32-newlib-dist/
	else
		RISCV_PATH ?= /home/sallar/tools/rv32i-ilp32-dist/
	endif
endif

MABI=ilp32
MARCH := rv32i
ifeq ($(MULDIV),yes)
	MARCH := $(MARCH)m
endif
ifeq ($(COMPRESSED),yes)
	MARCH := $(MARCH)ac
endif

CFLAGS += -march=$(MARCH)  -mabi=$(MABI) -DNDEBUG
LDFLAGS += -march=$(MARCH)  -mabi=$(MABI)



#include ../../../resources/subproject.mk


ifeq ($(DEBUG),yes)
	CFLAGS += -g3 -O0
endif

ifeq ($(DEBUG),no)
	CFLAGS += -g -Os
endif

ifeq ($(BENCH),yes)
	CFLAGS += -fno-inline
endif

ifeq ($(SIFIVE_GCC_PACK),yes)
	RISCV_CLIB=$(RISCV_PATH)/$(RISCV_NAME)/lib/$(MARCH)/$(MABI)/
else
	RISCV_CLIB=$(RISCV_PATH)/$(RISCV_NAME)/lib/
endif





RISCV_OBJCOPY = $(RISCV_PATH)/bin/$(RISCV_NAME)-objcopy
RISCV_OBJDUMP = $(RISCV_PATH)/bin/$(RISCV_NAME)-objdump
RISCV_CC=$(RISCV_PATH)/bin/$(RISCV_NAME)-gcc

CFLAGS +=  -MD -fstrict-volatile-bitfields -fno-strict-aliasing
LDFLAGS +=  -nostdlib -lgcc -mcmodel=medany -nostartfiles -ffreestanding -Wl,-Bstatic,-T,$(LDSCRIPT),-Map,$(OBJDIR)/$(PROJ_NAME).map,--print-memory-usage
#LDFLAGS += -lgcc -lc -lg -nostdlib  -lgcc  -msave-restore    --strip-debug,

OBJS := $(SRCS)
OBJS := $(OBJS:.c=.o)
OBJS := $(OBJS:.cpp=.o)
OBJS := $(OBJS:.S=.o)
OBJS := $(OBJS:..=miaou)
OBJS := $(addprefix $(OBJDIR)/,$(OBJS))


all: $(OBJDIR)/$(PROJ_NAME).elf $(OBJDIR)/$(PROJ_NAME).hex $(OBJDIR)/$(PROJ_NAME).asm $(OBJDIR)/$(PROJ_NAME).v

$(OBJDIR)/%.elf: $(OBJS) | $(OBJDIR)
	$(RISCV_CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBSINC) $(LIBS)

%.hex: %.elf
	$(RISCV_OBJCOPY) -O ihex $^ $@

%.bin: %.elf
	$(RISCV_OBJCOPY) -O binary $^ $@

%.v: %.elf
	$(RISCV_OBJCOPY) -O verilog $^ $@

%.asm: %.elf
	$(RISCV_OBJDUMP) -S -d $^ > $@

$(OBJDIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(RISCV_CC) -c $(CFLAGS)  $(INC) -o $@ $^
	$(RISCV_CC) -S $(CFLAGS)  $(INC) -o $@.disasm $^

$(OBJDIR)/%.o: %.cpp
	mkdir -p $(dir $@)
	$(RISCV_CC) -c $(CFLAGS)  $(INC) -o $@ $^

$(OBJDIR)/%.o: %.S
	mkdir -p $(dir $@)
	$(RISCV_CC) -c $(CFLAGS) -o $@ $^ -D__ASSEMBLY__=1

$(OBJDIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(OBJDIR)/src
	rm -f $(OBJDIR)/$(PROJ_NAME).elf
	rm -f $(OBJDIR)/$(PROJ_NAME).hex
	rm -f $(OBJDIR)/$(PROJ_NAME).map
	rm -f $(OBJDIR)/$(PROJ_NAME).v
	rm -f $(OBJDIR)/$(PROJ_NAME).asm
	find $(OBJDIR) -type f -name '*.o' -print0 | xargs -0 -r rm
	find $(OBJDIR) -type f -name '*.d' -print0 | xargs -0 -r rm

clean-all : clean 

.SECONDARY: $(OBJS)
