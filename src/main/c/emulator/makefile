PROJ_NAME=emulator
DEBUG=no
MULDIV=no
COMPRESSED=no
STANDALONE = ..


SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp)  \
		$(wildcard src/*.S)


LDSCRIPT = ${STANDALONE}/common/ram.ld

sim: CFLAGS += -DSIM
sim: all

qemu: CFLAGS += -DQEMU
qemu: all

include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

