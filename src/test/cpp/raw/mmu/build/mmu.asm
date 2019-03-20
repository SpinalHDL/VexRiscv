
build/mmu.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <trap_entry-0x20>:
80000000:	0280006f          	j	80000028 <_start>
80000004:	00000013          	nop
80000008:	00000013          	nop
8000000c:	00000013          	nop
80000010:	00000013          	nop
80000014:	00000013          	nop
80000018:	00000013          	nop
8000001c:	00000013          	nop

80000020 <trap_entry>:
80000020:	0200006f          	j	80000040 <fail>
80000024:	30200073          	mret

80000028 <_start>:
80000028:	00000097          	auipc	ra,0x0
8000002c:	01808093          	addi	ra,ra,24 # 80000040 <fail>
80000030:	30509073          	csrw	mtvec,ra
80000034:	10509073          	csrw	stvec,ra
80000038:	00100e13          	li	t3,1
8000003c:	0100006f          	j	8000004c <pass>

80000040 <fail>:
80000040:	f0100137          	lui	sp,0xf0100
80000044:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffed8>
80000048:	01c12023          	sw	t3,0(sp)

8000004c <pass>:
8000004c:	f0100137          	lui	sp,0xf0100
80000050:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffed4>
80000054:	00012023          	sw	zero,0(sp)
80000058:	00000013          	nop
8000005c:	00000013          	nop
80000060:	00000013          	nop
80000064:	00000013          	nop
80000068:	00000013          	nop
8000006c:	00000013          	nop
