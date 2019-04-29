RISCV_BIN ?= riscv64-unknown-elf-
RISCV_CC=${RISCV_BIN}gcc
RISCV_OBJCOPY=${RISCV_BIN}objcopy
RISCV_OBJDUMP=${RISCV_BIN}objdump

MARCH := rv32i
ifeq ($(MULDIV),yes)
	MARCH := $(MARCH)M
endif
ifeq ($(COMPRESSED),yes)
	MARCH := $(MARCH)AC
endif

CFLAGS += -march=$(MARCH) -mabi=ilp32 -DUSE_GP
LDFLAGS += -march=$(MARCH) -mabi=ilp32

