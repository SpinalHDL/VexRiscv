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

litex: CFLAGS += -DLITEX -I${LITEX_GENERATED} -I${LITEX_BASE}/litex/soc/software/include
litex: | check_litex all
check_litex:
	@[ "${LITEX_BASE}" ] || ( echo ">> LITEX_BASE is not set"; exit 1 )
	@[ "${LITEX_GENERATED}" ] || ( echo ">> LITEX_GENERATED is not set"; exit 1 )

include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

