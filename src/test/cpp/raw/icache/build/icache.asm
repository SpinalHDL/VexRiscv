
build/icache.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	05408093          	addi	ra,ra,84 # 80000054 <fail>
80000008:	30509073          	csrw	mtvec,ra

8000000c <test1>:
8000000c:	00100e13          	li	t3,1
80000010:	00100093          	li	ra,1
80000014:	00300113          	li	sp,3
80000018:	00208093          	addi	ra,ra,2
8000001c:	02209c63          	bne	ra,sp,80000054 <fail>

80000020 <test2>:
80000020:	00200e13          	li	t3,2
80000024:	01300093          	li	ra,19
80000028:	00000117          	auipc	sp,0x0
8000002c:	02410113          	addi	sp,sp,36 # 8000004c <test2_trigger>
80000030:	0100006f          	j	80000040 <test2_aligned>
80000034:	00000013          	nop
80000038:	00000013          	nop
8000003c:	00000013          	nop

80000040 <test2_aligned>:
80000040:	00112023          	sw	ra,0(sp)
80000044:	0000100f          	fence.i
80000048:	0040006f          	j	8000004c <test2_trigger>

8000004c <test2_trigger>:
8000004c:	0080006f          	j	80000054 <fail>
80000050:	0100006f          	j	80000060 <pass>

80000054 <fail>:
80000054:	f0100137          	lui	sp,0xf0100
80000058:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffec4>
8000005c:	01c12023          	sw	t3,0(sp)

80000060 <pass>:
80000060:	f0100137          	lui	sp,0xf0100
80000064:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffec0>
80000068:	00012023          	sw	zero,0(sp)
8000006c:	00000013          	nop
80000070:	00000013          	nop
80000074:	00000013          	nop
80000078:	00000013          	nop
8000007c:	00000013          	nop
80000080:	00000013          	nop
	...
