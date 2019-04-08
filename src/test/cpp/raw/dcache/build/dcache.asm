
build/dcache.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	0b408093          	addi	ra,ra,180 # 800000b4 <fail>

80000008 <test1>:
80000008:	00100e13          	li	t3,1
8000000c:	00100093          	li	ra,1
80000010:	00300113          	li	sp,3
80000014:	00208093          	addi	ra,ra,2
80000018:	08209e63          	bne	ra,sp,800000b4 <fail>

8000001c <test2>:
8000001c:	00200e13          	li	t3,2
80000020:	f56700b7          	lui	ra,0xf5670
80000024:	900ff137          	lui	sp,0x900ff
80000028:	40000313          	li	t1,1024

8000002c <test2_repeat>:
8000002c:	00100193          	li	gp,1
80000030:	00200293          	li	t0,2
80000034:	006303b3          	add	t2,t1,t1
80000038:	007181b3          	add	gp,gp,t2
8000003c:	007282b3          	add	t0,t0,t2
80000040:	00312023          	sw	gp,0(sp) # 900ff000 <pass+0x100fef40>
80000044:	0000a023          	sw	zero,0(ra) # f5670000 <pass+0x7566ff40>
80000048:	00012203          	lw	tp,0(sp)
8000004c:	06429463          	bne	t0,tp,800000b4 <fail>
80000050:	ffc30313          	addi	t1,t1,-4
80000054:	01008093          	addi	ra,ra,16
80000058:	01010113          	addi	sp,sp,16
8000005c:	0000500f          	0x500f
80000060:	fc0316e3          	bnez	t1,8000002c <test2_repeat>

80000064 <test3>:
80000064:	00300e13          	li	t3,3
80000068:	f56700b7          	lui	ra,0xf5670
8000006c:	900ff137          	lui	sp,0x900ff
80000070:	40000313          	li	t1,1024

80000074 <test3_repeat>:
80000074:	00200193          	li	gp,2
80000078:	00300293          	li	t0,3
8000007c:	006303b3          	add	t2,t1,t1
80000080:	007181b3          	add	gp,gp,t2
80000084:	007282b3          	add	t0,t0,t2
80000088:	00012203          	lw	tp,0(sp) # 900ff000 <pass+0x100fef40>
8000008c:	00312023          	sw	gp,0(sp)
80000090:	0000a023          	sw	zero,0(ra) # f5670000 <pass+0x7566ff40>
80000094:	0000500f          	0x500f
80000098:	00012203          	lw	tp,0(sp)
8000009c:	00429c63          	bne	t0,tp,800000b4 <fail>
800000a0:	ffc30313          	addi	t1,t1,-4
800000a4:	01008093          	addi	ra,ra,16
800000a8:	01010113          	addi	sp,sp,16
800000ac:	fc0314e3          	bnez	t1,80000074 <test3_repeat>
800000b0:	0100006f          	j	800000c0 <pass>

800000b4 <fail>:
800000b4:	f0100137          	lui	sp,0xf0100
800000b8:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffe64>
800000bc:	01c12023          	sw	t3,0(sp)

800000c0 <pass>:
800000c0:	f0100137          	lui	sp,0xf0100
800000c4:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffe60>
800000c8:	00012023          	sw	zero,0(sp)
800000cc:	00000013          	nop
800000d0:	00000013          	nop
800000d4:	00000013          	nop
800000d8:	00000013          	nop
800000dc:	00000013          	nop
800000e0:	00000013          	nop
