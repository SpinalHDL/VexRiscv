
build/pmp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	01008093          	addi	ra,ra,16 # 80000010 <trap>
80000008:	30509073          	csrw	mtvec,ra
8000000c:	00c0006f          	j	80000018 <test0>

80000010 <trap>:
80000010:	341f1073          	csrw	mepc,t5
80000014:	30200073          	mret

80000018 <test0>:
80000018:	00000e13          	li	t3,0
8000001c:	00000f17          	auipc	t5,0x0
80000020:	330f0f13          	addi	t5,t5,816 # 8000034c <fail>
80000024:	800000b7          	lui	ra,0x80000
80000028:	80008237          	lui	tp,0x80008
8000002c:	deadc137          	lui	sp,0xdeadc
80000030:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb97>
80000034:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffca8>
80000038:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7ca8>
8000003c:	0000a183          	lw	gp,0(ra)
80000040:	30311663          	bne	sp,gp,8000034c <fail>
80000044:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000048:	30311263          	bne	sp,gp,8000034c <fail>
8000004c:	071202b7          	lui	t0,0x7120
80000050:	3a029073          	csrw	pmpcfg0,t0
80000054:	3a002373          	csrr	t1,pmpcfg0
80000058:	2e629a63          	bne	t0,t1,8000034c <fail>
8000005c:	191f02b7          	lui	t0,0x191f0
80000060:	30428293          	addi	t0,t0,772 # 191f0304 <_start-0x66e0fcfc>
80000064:	3a129073          	csrw	pmpcfg1,t0
80000068:	000f12b7          	lui	t0,0xf1
8000006c:	90a28293          	addi	t0,t0,-1782 # f090a <_start-0x7ff0f6f6>
80000070:	3a229073          	csrw	pmpcfg2,t0
80000074:	0f1e22b7          	lui	t0,0xf1e2
80000078:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
8000007c:	3a329073          	csrw	pmpcfg3,t0
80000080:	200002b7          	lui	t0,0x20000
80000084:	3b029073          	csrw	pmpaddr0,t0
80000088:	3b002373          	csrr	t1,pmpaddr0
8000008c:	2c629063          	bne	t0,t1,8000034c <fail>
80000090:	fff00293          	li	t0,-1
80000094:	3b129073          	csrw	pmpaddr1,t0
80000098:	200022b7          	lui	t0,0x20002
8000009c:	3b229073          	csrw	pmpaddr2,t0
800000a0:	200042b7          	lui	t0,0x20004
800000a4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000a8:	3b329073          	csrw	pmpaddr3,t0
800000ac:	200042b7          	lui	t0,0x20004
800000b0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000b4:	3b429073          	csrw	pmpaddr4,t0
800000b8:	200042b7          	lui	t0,0x20004
800000bc:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c0:	3b529073          	csrw	pmpaddr5,t0
800000c4:	200022b7          	lui	t0,0x20002
800000c8:	fff28293          	addi	t0,t0,-1 # 20001fff <_start-0x5fffe001>
800000cc:	3b629073          	csrw	pmpaddr6,t0
800000d0:	200062b7          	lui	t0,0x20006
800000d4:	fff28293          	addi	t0,t0,-1 # 20005fff <_start-0x5fffa001>
800000d8:	3b729073          	csrw	pmpaddr7,t0
800000dc:	2000c2b7          	lui	t0,0x2000c
800000e0:	3b829073          	csrw	pmpaddr8,t0
800000e4:	2000d2b7          	lui	t0,0x2000d
800000e8:	3b929073          	csrw	pmpaddr9,t0
800000ec:	fff00293          	li	t0,-1
800000f0:	3ba29073          	csrw	pmpaddr10,t0
800000f4:	00000293          	li	t0,0
800000f8:	3bb29073          	csrw	pmpaddr11,t0
800000fc:	00000293          	li	t0,0
80000100:	3bc29073          	csrw	pmpaddr12,t0
80000104:	00000293          	li	t0,0
80000108:	3bd29073          	csrw	pmpaddr13,t0
8000010c:	00000293          	li	t0,0
80000110:	3be29073          	csrw	pmpaddr14,t0
80000114:	00000293          	li	t0,0
80000118:	3bf29073          	csrw	pmpaddr15,t0
8000011c:	00c10137          	lui	sp,0xc10
80000120:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000124:	0020a023          	sw	sp,0(ra)
80000128:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
8000012c:	0000a183          	lw	gp,0(ra)
80000130:	20311e63          	bne	sp,gp,8000034c <fail>
80000134:	00000193          	li	gp,0
80000138:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
8000013c:	20311863          	bne	sp,gp,8000034c <fail>

80000140 <test1>:
80000140:	00100e13          	li	t3,1
80000144:	00000f17          	auipc	t5,0x0
80000148:	208f0f13          	addi	t5,t5,520 # 8000034c <fail>
8000014c:	079212b7          	lui	t0,0x7921
80000150:	80828293          	addi	t0,t0,-2040 # 7920808 <_start-0x786df7f8>
80000154:	3a029073          	csrw	pmpcfg0,t0
80000158:	3a002373          	csrr	t1,pmpcfg0
8000015c:	1e629863          	bne	t0,t1,8000034c <fail>
80000160:	800080b7          	lui	ra,0x80008
80000164:	deadc137          	lui	sp,0xdeadc
80000168:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb97>
8000016c:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7ca8>
80000170:	00000f17          	auipc	t5,0x0
80000174:	010f0f13          	addi	t5,t5,16 # 80000180 <test2>
80000178:	0000a183          	lw	gp,0(ra)
8000017c:	1d00006f          	j	8000034c <fail>

80000180 <test2>:
80000180:	00200e13          	li	t3,2
80000184:	00000f17          	auipc	t5,0x0
80000188:	1c8f0f13          	addi	t5,t5,456 # 8000034c <fail>
8000018c:	071202b7          	lui	t0,0x7120
80000190:	3a029073          	csrw	pmpcfg0,t0
80000194:	3a002373          	csrr	t1,pmpcfg0
80000198:	1a628a63          	beq	t0,t1,8000034c <fail>
8000019c:	200042b7          	lui	t0,0x20004
800001a0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800001a4:	3b305073          	csrwi	pmpaddr3,0
800001a8:	3b302373          	csrr	t1,pmpaddr3
800001ac:	1a031063          	bnez	t1,8000034c <fail>
800001b0:	18628e63          	beq	t0,t1,8000034c <fail>
800001b4:	200022b7          	lui	t0,0x20002
800001b8:	3b205073          	csrwi	pmpaddr2,0
800001bc:	3b202373          	csrr	t1,pmpaddr2
800001c0:	18030663          	beqz	t1,8000034c <fail>
800001c4:	18629463          	bne	t0,t1,8000034c <fail>
800001c8:	800080b7          	lui	ra,0x80008
800001cc:	deadc137          	lui	sp,0xdeadc
800001d0:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb97>
800001d4:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7ca8>
800001d8:	00000f17          	auipc	t5,0x0
800001dc:	010f0f13          	addi	t5,t5,16 # 800001e8 <test3>
800001e0:	0000a183          	lw	gp,0(ra)
800001e4:	1680006f          	j	8000034c <fail>

800001e8 <test3>:
800001e8:	00300e13          	li	t3,3
800001ec:	00000f17          	auipc	t5,0x0
800001f0:	160f0f13          	addi	t5,t5,352 # 8000034c <fail>
800001f4:	00ff02b7          	lui	t0,0xff0
800001f8:	3b32a073          	csrs	pmpaddr3,t0
800001fc:	3b302373          	csrr	t1,pmpaddr3
80000200:	14629663          	bne	t0,t1,8000034c <fail>
80000204:	0ff00293          	li	t0,255
80000208:	3b32a073          	csrs	pmpaddr3,t0
8000020c:	3b302373          	csrr	t1,pmpaddr3
80000210:	00ff02b7          	lui	t0,0xff0
80000214:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
80000218:	12629a63          	bne	t0,t1,8000034c <fail>
8000021c:	00ff02b7          	lui	t0,0xff0
80000220:	3b32b073          	csrc	pmpaddr3,t0
80000224:	3b302373          	csrr	t1,pmpaddr3
80000228:	0ff00293          	li	t0,255
8000022c:	12629063          	bne	t0,t1,8000034c <fail>
80000230:	00ff02b7          	lui	t0,0xff0
80000234:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
80000238:	3a02b073          	csrc	pmpcfg0,t0
8000023c:	3a002373          	csrr	t1,pmpcfg0
80000240:	079202b7          	lui	t0,0x7920
80000244:	10629463          	bne	t0,t1,8000034c <fail>
80000248:	00ff02b7          	lui	t0,0xff0
8000024c:	70728293          	addi	t0,t0,1799 # ff0707 <_start-0x7f00f8f9>
80000250:	3a02a073          	csrs	pmpcfg0,t0
80000254:	3a002373          	csrr	t1,pmpcfg0
80000258:	079202b7          	lui	t0,0x7920
8000025c:	70728293          	addi	t0,t0,1799 # 7920707 <_start-0x786df8f9>
80000260:	0e629663          	bne	t0,t1,8000034c <fail>

80000264 <test4>:
80000264:	00400e13          	li	t3,4
80000268:	00000f17          	auipc	t5,0x0
8000026c:	0e4f0f13          	addi	t5,t5,228 # 8000034c <fail>
80000270:	00000117          	auipc	sp,0x0
80000274:	01010113          	addi	sp,sp,16 # 80000280 <test5>
80000278:	34111073          	csrw	mepc,sp
8000027c:	30200073          	mret

80000280 <test5>:
80000280:	00500e13          	li	t3,5
80000284:	00000f17          	auipc	t5,0x0
80000288:	0c8f0f13          	addi	t5,t5,200 # 8000034c <fail>
8000028c:	deadc137          	lui	sp,0xdeadc
80000290:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb97>
80000294:	800080b7          	lui	ra,0x80008
80000298:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7ca8>
8000029c:	00000f17          	auipc	t5,0x0
800002a0:	010f0f13          	addi	t5,t5,16 # 800002ac <test6>
800002a4:	0000a183          	lw	gp,0(ra)
800002a8:	0a40006f          	j	8000034c <fail>

800002ac <test6>:
800002ac:	00600e13          	li	t3,6
800002b0:	00000f17          	auipc	t5,0x0
800002b4:	09cf0f13          	addi	t5,t5,156 # 8000034c <fail>
800002b8:	deadc137          	lui	sp,0xdeadc
800002bc:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb97>
800002c0:	800000b7          	lui	ra,0x80000
800002c4:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffca8>
800002c8:	0000a183          	lw	gp,0(ra)
800002cc:	08311063          	bne	sp,gp,8000034c <fail>

800002d0 <test7>:
800002d0:	00700e13          	li	t3,7
800002d4:	00000f17          	auipc	t5,0x0
800002d8:	078f0f13          	addi	t5,t5,120 # 8000034c <fail>
800002dc:	800400b7          	lui	ra,0x80040
800002e0:	0000a183          	lw	gp,0(ra) # 80040000 <pass+0x3fca8>
800002e4:	00000f17          	auipc	t5,0x0
800002e8:	074f0f13          	addi	t5,t5,116 # 80000358 <pass>
800002ec:	0030a023          	sw	gp,0(ra)
800002f0:	05c0006f          	j	8000034c <fail>

800002f4 <test8>:
800002f4:	00800e13          	li	t3,8
800002f8:	00000f17          	auipc	t5,0x0
800002fc:	054f0f13          	addi	t5,t5,84 # 8000034c <fail>
80000300:	deadc137          	lui	sp,0xdeadc
80000304:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb97>
80000308:	800300b7          	lui	ra,0x80030
8000030c:	ff808093          	addi	ra,ra,-8 # 8002fff8 <pass+0x2fca0>
80000310:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000314:	00000f17          	auipc	t5,0x0
80000318:	010f0f13          	addi	t5,t5,16 # 80000324 <test9>
8000031c:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000320:	02c0006f          	j	8000034c <fail>

80000324 <test9>:
80000324:	00900e13          	li	t3,9
80000328:	00000f17          	auipc	t5,0x0
8000032c:	024f0f13          	addi	t5,t5,36 # 8000034c <fail>
80000330:	800400b7          	lui	ra,0x80040
80000334:	ff808093          	addi	ra,ra,-8 # 8003fff8 <pass+0x3fca0>
80000338:	0000a183          	lw	gp,0(ra)
8000033c:	00000f17          	auipc	t5,0x0
80000340:	01cf0f13          	addi	t5,t5,28 # 80000358 <pass>
80000344:	0030a023          	sw	gp,0(ra)
80000348:	0040006f          	j	8000034c <fail>

8000034c <fail>:
8000034c:	f0100137          	lui	sp,0xf0100
80000350:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffbcc>
80000354:	01c12023          	sw	t3,0(sp)

80000358 <pass>:
80000358:	f0100137          	lui	sp,0xf0100
8000035c:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffbc8>
80000360:	00012023          	sw	zero,0(sp)
