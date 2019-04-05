
build/dcache.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	0b808093          	addi	ra,ra,184 # 800000b8 <fail>
80000008:	30509073          	csrw	mtvec,ra

8000000c <test1>:
8000000c:	00100e13          	li	t3,1
80000010:	00100093          	li	ra,1
80000014:	00300113          	li	sp,3
80000018:	00208093          	addi	ra,ra,2
8000001c:	08209e63          	bne	ra,sp,800000b8 <fail>

80000020 <test2>:
80000020:	00200e13          	li	t3,2
80000024:	f56700b7          	lui	ra,0xf5670
80000028:	900ff137          	lui	sp,0x900ff
8000002c:	40000313          	li	t1,1024

80000030 <test2_repeat>:
80000030:	00100193          	li	gp,1
80000034:	00200293          	li	t0,2
80000038:	006303b3          	add	t2,t1,t1
8000003c:	007181b3          	add	gp,gp,t2
80000040:	007282b3          	add	t0,t0,t2
80000044:	00312023          	sw	gp,0(sp) # 900ff000 <pass+0x100fef3c>
80000048:	0000a023          	sw	zero,0(ra) # f5670000 <pass+0x7566ff3c>
8000004c:	00012203          	lw	tp,0(sp)
80000050:	06429463          	bne	t0,tp,800000b8 <fail>
80000054:	fff30313          	addi	t1,t1,-1
80000058:	00408093          	addi	ra,ra,4
8000005c:	00410113          	addi	sp,sp,4
80000060:	0000500f          	0x500f
80000064:	fc0316e3          	bnez	t1,80000030 <test2_repeat>

80000068 <test3>:
80000068:	00300e13          	li	t3,3
8000006c:	f56700b7          	lui	ra,0xf5670
80000070:	900ff137          	lui	sp,0x900ff
80000074:	40000313          	li	t1,1024

80000078 <test3_repeat>:
80000078:	00200193          	li	gp,2
8000007c:	00300293          	li	t0,3
80000080:	006303b3          	add	t2,t1,t1
80000084:	007181b3          	add	gp,gp,t2
80000088:	007282b3          	add	t0,t0,t2
8000008c:	00012203          	lw	tp,0(sp) # 900ff000 <pass+0x100fef3c>
80000090:	00312023          	sw	gp,0(sp)
80000094:	0000a023          	sw	zero,0(ra) # f5670000 <pass+0x7566ff3c>
80000098:	0000500f          	0x500f
8000009c:	00012203          	lw	tp,0(sp)
800000a0:	00429c63          	bne	t0,tp,800000b8 <fail>
800000a4:	fff30313          	addi	t1,t1,-1
800000a8:	00408093          	addi	ra,ra,4
800000ac:	00410113          	addi	sp,sp,4
800000b0:	fc0314e3          	bnez	t1,80000078 <test3_repeat>
800000b4:	0100006f          	j	800000c4 <pass>

800000b8 <fail>:
800000b8:	f0100137          	lui	sp,0xf0100
800000bc:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffe60>
800000c0:	01c12023          	sw	t3,0(sp)

800000c4 <pass>:
800000c4:	f0100137          	lui	sp,0xf0100
800000c8:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffe5c>
800000cc:	00012023          	sw	zero,0(sp)
800000d0:	00000013          	nop
800000d4:	00000013          	nop
800000d8:	00000013          	nop
800000dc:	00000013          	nop
800000e0:	00000013          	nop
800000e4:	00000013          	nop
