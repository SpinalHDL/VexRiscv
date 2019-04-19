
build/icache.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	04c08093          	addi	ra,ra,76 # 8000004c <fail>

80000008 <test1>:
80000008:	00100e13          	li	t3,1
8000000c:	00100093          	li	ra,1
80000010:	00300113          	li	sp,3
80000014:	00208093          	addi	ra,ra,2
80000018:	02209a63          	bne	ra,sp,8000004c <fail>

8000001c <test2>:
8000001c:	00200e13          	li	t3,2
80000020:	01300093          	li	ra,19
80000024:	00000117          	auipc	sp,0x0
80000028:	02010113          	addi	sp,sp,32 # 80000044 <test2_trigger>
8000002c:	0040006f          	j	80000030 <test2_aligned>

80000030 <test2_aligned>:
80000030:	00112023          	sw	ra,0(sp)
80000034:	0000100f          	fence.i
80000038:	00800a13          	li	s4,8
8000003c:	fffa0a13          	addi	s4,s4,-1
80000040:	fe0a1ee3          	bnez	s4,8000003c <test2_aligned+0xc>

80000044 <test2_trigger>:
80000044:	0080006f          	j	8000004c <fail>
80000048:	0100006f          	j	80000058 <pass>

8000004c <fail>:
8000004c:	f0100137          	lui	sp,0xf0100
80000050:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffecc>
80000054:	01c12023          	sw	t3,0(sp)

80000058 <pass>:
80000058:	f0100137          	lui	sp,0xf0100
8000005c:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffec8>
80000060:	00012023          	sw	zero,0(sp)
80000064:	00000013          	nop
80000068:	00000013          	nop
8000006c:	00000013          	nop
80000070:	00000013          	nop
80000074:	00000013          	nop
80000078:	00000013          	nop
	...
