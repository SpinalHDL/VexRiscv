
build/icache.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	04408093          	addi	ra,ra,68 # 80000044 <fail>

80000008 <test1>:
80000008:	00100e13          	li	t3,1
8000000c:	00100093          	li	ra,1
80000010:	00300113          	li	sp,3
80000014:	00208093          	addi	ra,ra,2
80000018:	02209663          	bne	ra,sp,80000044 <fail>

8000001c <test2>:
8000001c:	00200e13          	li	t3,2
80000020:	01300093          	li	ra,19
80000024:	00000117          	auipc	sp,0x0
80000028:	01810113          	addi	sp,sp,24 # 8000003c <test2_trigger>
8000002c:	0040006f          	j	80000030 <test2_aligned>

80000030 <test2_aligned>:
80000030:	00112023          	sw	ra,0(sp)
80000034:	0000100f          	fence.i
80000038:	0040006f          	j	8000003c <test2_trigger>

8000003c <test2_trigger>:
8000003c:	0080006f          	j	80000044 <fail>
80000040:	0100006f          	j	80000050 <pass>

80000044 <fail>:
80000044:	f0100137          	lui	sp,0xf0100
80000048:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffed4>
8000004c:	01c12023          	sw	t3,0(sp)

80000050 <pass>:
80000050:	f0100137          	lui	sp,0xf0100
80000054:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffed0>
80000058:	00012023          	sw	zero,0(sp)
8000005c:	00000013          	nop
80000060:	00000013          	nop
80000064:	00000013          	nop
80000068:	00000013          	nop
8000006c:	00000013          	nop
80000070:	00000013          	nop
