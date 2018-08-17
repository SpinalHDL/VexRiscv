#!/usr/bin/env python3

from os import system
from sys import argv

with open("disasm.s", "w") as f:
	instr = int(argv[1], 16)
	print(".word 0x%04x" % (instr), file=f)

system("riscv64-unknown-elf-gcc -c disasm.s")
system("riscv64-unknown-elf-objdump -d -M numeric,no-aliases disasm.o")
