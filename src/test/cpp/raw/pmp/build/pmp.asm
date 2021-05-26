
build/pmp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000493          	li	s1,0
80000004:	00000097          	auipc	ra,0x0
80000008:	01008093          	addi	ra,ra,16 # 80000014 <trap>
8000000c:	30509073          	csrw	mtvec,ra
80000010:	0140006f          	j	80000024 <test0>

80000014 <trap>:
80000014:	341f1073          	csrw	mepc,t5
80000018:	00049463          	bnez	s1,80000020 <trap_exit>
8000001c:	30200073          	mret

80000020 <trap_exit>:
80000020:	000f0067          	jr	t5

80000024 <test0>:
80000024:	00000e13          	li	t3,0
80000028:	00000f17          	auipc	t5,0x0
8000002c:	39cf0f13          	addi	t5,t5,924 # 800003c4 <fail>
80000030:	800000b7          	lui	ra,0x80000
80000034:	80008237          	lui	tp,0x80008
80000038:	deadc137          	lui	sp,0xdeadc
8000003c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb1f>
80000040:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffc30>
80000044:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7c30>
80000048:	0000a183          	lw	gp,0(ra)
8000004c:	36311c63          	bne	sp,gp,800003c4 <fail>
80000050:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000054:	36311863          	bne	sp,gp,800003c4 <fail>
80000058:	071202b7          	lui	t0,0x7120
8000005c:	3a029073          	csrw	pmpcfg0,t0
80000060:	3a002373          	csrr	t1,pmpcfg0
80000064:	191f02b7          	lui	t0,0x191f0
80000068:	30428293          	addi	t0,t0,772 # 191f0304 <_start-0x66e0fcfc>
8000006c:	3a129073          	csrw	pmpcfg1,t0
80000070:	000f12b7          	lui	t0,0xf1
80000074:	90a28293          	addi	t0,t0,-1782 # f090a <_start-0x7ff0f6f6>
80000078:	3a229073          	csrw	pmpcfg2,t0
8000007c:	0f1e22b7          	lui	t0,0xf1e2
80000080:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
80000084:	3a329073          	csrw	pmpcfg3,t0
80000088:	200002b7          	lui	t0,0x20000
8000008c:	3b029073          	csrw	pmpaddr0,t0
80000090:	3b002373          	csrr	t1,pmpaddr0
80000094:	fff00293          	li	t0,-1
80000098:	3b129073          	csrw	pmpaddr1,t0
8000009c:	200022b7          	lui	t0,0x20002
800000a0:	3b229073          	csrw	pmpaddr2,t0
800000a4:	200042b7          	lui	t0,0x20004
800000a8:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000ac:	3b329073          	csrw	pmpaddr3,t0
800000b0:	200042b7          	lui	t0,0x20004
800000b4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000b8:	3b429073          	csrw	pmpaddr4,t0
800000bc:	200042b7          	lui	t0,0x20004
800000c0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c4:	3b529073          	csrw	pmpaddr5,t0
800000c8:	200022b7          	lui	t0,0x20002
800000cc:	fff28293          	addi	t0,t0,-1 # 20001fff <_start-0x5fffe001>
800000d0:	3b629073          	csrw	pmpaddr6,t0
800000d4:	200062b7          	lui	t0,0x20006
800000d8:	fff28293          	addi	t0,t0,-1 # 20005fff <_start-0x5fffa001>
800000dc:	3b729073          	csrw	pmpaddr7,t0
800000e0:	200d02b7          	lui	t0,0x200d0
800000e4:	3b829073          	csrw	pmpaddr8,t0
800000e8:	200e02b7          	lui	t0,0x200e0
800000ec:	3b929073          	csrw	pmpaddr9,t0
800000f0:	fff00293          	li	t0,-1
800000f4:	3ba29073          	csrw	pmpaddr10,t0
800000f8:	00000293          	li	t0,0
800000fc:	3bb29073          	csrw	pmpaddr11,t0
80000100:	00000293          	li	t0,0
80000104:	3bc29073          	csrw	pmpaddr12,t0
80000108:	00000293          	li	t0,0
8000010c:	3bd29073          	csrw	pmpaddr13,t0
80000110:	00000293          	li	t0,0
80000114:	3be29073          	csrw	pmpaddr14,t0
80000118:	00000293          	li	t0,0
8000011c:	3bf29073          	csrw	pmpaddr15,t0
80000120:	00c10137          	lui	sp,0xc10
80000124:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000128:	0020a023          	sw	sp,0(ra)
8000012c:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000130:	0000a183          	lw	gp,0(ra)
80000134:	28311863          	bne	sp,gp,800003c4 <fail>
80000138:	00000193          	li	gp,0
8000013c:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000140:	28311263          	bne	sp,gp,800003c4 <fail>

80000144 <test1>:
80000144:	00100e13          	li	t3,1
80000148:	00000f17          	auipc	t5,0x0
8000014c:	27cf0f13          	addi	t5,t5,636 # 800003c4 <fail>
80000150:	079212b7          	lui	t0,0x7921
80000154:	80828293          	addi	t0,t0,-2040 # 7920808 <_start-0x786df7f8>
80000158:	3a029073          	csrw	pmpcfg0,t0
8000015c:	3a002373          	csrr	t1,pmpcfg0
80000160:	26629263          	bne	t0,t1,800003c4 <fail>
80000164:	800080b7          	lui	ra,0x80008
80000168:	deadc137          	lui	sp,0xdeadc
8000016c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb1f>
80000170:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7c30>
80000174:	00000f17          	auipc	t5,0x0
80000178:	010f0f13          	addi	t5,t5,16 # 80000184 <test2>
8000017c:	0000a183          	lw	gp,0(ra)
80000180:	2440006f          	j	800003c4 <fail>

80000184 <test2>:
80000184:	00200e13          	li	t3,2
80000188:	00000f17          	auipc	t5,0x0
8000018c:	23cf0f13          	addi	t5,t5,572 # 800003c4 <fail>
80000190:	071202b7          	lui	t0,0x7120
80000194:	3a029073          	csrw	pmpcfg0,t0
80000198:	3a002373          	csrr	t1,pmpcfg0
8000019c:	22628463          	beq	t0,t1,800003c4 <fail>
800001a0:	200042b7          	lui	t0,0x20004
800001a4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800001a8:	3b305073          	csrwi	pmpaddr3,0
800001ac:	3b302373          	csrr	t1,pmpaddr3
800001b0:	20031a63          	bnez	t1,800003c4 <fail>
800001b4:	20628863          	beq	t0,t1,800003c4 <fail>
800001b8:	200022b7          	lui	t0,0x20002
800001bc:	3b205073          	csrwi	pmpaddr2,0
800001c0:	3b202373          	csrr	t1,pmpaddr2
800001c4:	20030063          	beqz	t1,800003c4 <fail>
800001c8:	1e629e63          	bne	t0,t1,800003c4 <fail>
800001cc:	800080b7          	lui	ra,0x80008
800001d0:	deadc137          	lui	sp,0xdeadc
800001d4:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb1f>
800001d8:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7c30>
800001dc:	00000f17          	auipc	t5,0x0
800001e0:	010f0f13          	addi	t5,t5,16 # 800001ec <test3>
800001e4:	0000a183          	lw	gp,0(ra)
800001e8:	1dc0006f          	j	800003c4 <fail>

800001ec <test3>:
800001ec:	00300e13          	li	t3,3
800001f0:	00000f17          	auipc	t5,0x0
800001f4:	1d4f0f13          	addi	t5,t5,468 # 800003c4 <fail>
800001f8:	00ff02b7          	lui	t0,0xff0
800001fc:	3b32a073          	csrs	pmpaddr3,t0
80000200:	3b302373          	csrr	t1,pmpaddr3
80000204:	1c629063          	bne	t0,t1,800003c4 <fail>
80000208:	0ff00293          	li	t0,255
8000020c:	3b32a073          	csrs	pmpaddr3,t0
80000210:	3b302373          	csrr	t1,pmpaddr3
80000214:	00ff02b7          	lui	t0,0xff0
80000218:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
8000021c:	1a629463          	bne	t0,t1,800003c4 <fail>
80000220:	00ff02b7          	lui	t0,0xff0
80000224:	3b32b073          	csrc	pmpaddr3,t0
80000228:	3b302373          	csrr	t1,pmpaddr3
8000022c:	0ff00293          	li	t0,255
80000230:	18629a63          	bne	t0,t1,800003c4 <fail>
80000234:	00ff02b7          	lui	t0,0xff0
80000238:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
8000023c:	3a02b073          	csrc	pmpcfg0,t0
80000240:	3a002373          	csrr	t1,pmpcfg0
80000244:	079202b7          	lui	t0,0x7920
80000248:	16629e63          	bne	t0,t1,800003c4 <fail>
8000024c:	00ff02b7          	lui	t0,0xff0
80000250:	70728293          	addi	t0,t0,1799 # ff0707 <_start-0x7f00f8f9>
80000254:	3a02a073          	csrs	pmpcfg0,t0
80000258:	3a002373          	csrr	t1,pmpcfg0
8000025c:	079202b7          	lui	t0,0x7920
80000260:	70728293          	addi	t0,t0,1799 # 7920707 <_start-0x786df8f9>
80000264:	16629063          	bne	t0,t1,800003c4 <fail>

80000268 <test4>:
80000268:	00400e13          	li	t3,4
8000026c:	00000f17          	auipc	t5,0x0
80000270:	158f0f13          	addi	t5,t5,344 # 800003c4 <fail>
80000274:	00000117          	auipc	sp,0x0
80000278:	01010113          	addi	sp,sp,16 # 80000284 <test5>
8000027c:	34111073          	csrw	mepc,sp
80000280:	30200073          	mret

80000284 <test5>:
80000284:	00500e13          	li	t3,5
80000288:	00000f17          	auipc	t5,0x0
8000028c:	13cf0f13          	addi	t5,t5,316 # 800003c4 <fail>
80000290:	deadc137          	lui	sp,0xdeadc
80000294:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb1f>
80000298:	800080b7          	lui	ra,0x80008
8000029c:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7c30>
800002a0:	00000f17          	auipc	t5,0x0
800002a4:	010f0f13          	addi	t5,t5,16 # 800002b0 <test6>
800002a8:	0000a183          	lw	gp,0(ra)
800002ac:	1180006f          	j	800003c4 <fail>

800002b0 <test6>:
800002b0:	00600e13          	li	t3,6
800002b4:	00000f17          	auipc	t5,0x0
800002b8:	110f0f13          	addi	t5,t5,272 # 800003c4 <fail>
800002bc:	deadc137          	lui	sp,0xdeadc
800002c0:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb1f>
800002c4:	800000b7          	lui	ra,0x80000
800002c8:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffc30>
800002cc:	0000a183          	lw	gp,0(ra)
800002d0:	0e311a63          	bne	sp,gp,800003c4 <fail>

800002d4 <test7>:
800002d4:	00700e13          	li	t3,7
800002d8:	00000f17          	auipc	t5,0x0
800002dc:	0ecf0f13          	addi	t5,t5,236 # 800003c4 <fail>
800002e0:	800400b7          	lui	ra,0x80040
800002e4:	0000a183          	lw	gp,0(ra) # 80040000 <pass+0x3fc30>
800002e8:	00000f17          	auipc	t5,0x0
800002ec:	010f0f13          	addi	t5,t5,16 # 800002f8 <test8>
800002f0:	0030a023          	sw	gp,0(ra)
800002f4:	0d00006f          	j	800003c4 <fail>

800002f8 <test8>:
800002f8:	00800e13          	li	t3,8
800002fc:	00000f17          	auipc	t5,0x0
80000300:	0c8f0f13          	addi	t5,t5,200 # 800003c4 <fail>
80000304:	deadc137          	lui	sp,0xdeadc
80000308:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb1f>
8000030c:	803400b7          	lui	ra,0x80340
80000310:	ff808093          	addi	ra,ra,-8 # 8033fff8 <pass+0x33fc28>
80000314:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000318:	00000f17          	auipc	t5,0x0
8000031c:	010f0f13          	addi	t5,t5,16 # 80000328 <test9>
80000320:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000324:	0a00006f          	j	800003c4 <fail>

80000328 <test9>:
80000328:	00900e13          	li	t3,9
8000032c:	00000f17          	auipc	t5,0x0
80000330:	098f0f13          	addi	t5,t5,152 # 800003c4 <fail>
80000334:	803800b7          	lui	ra,0x80380
80000338:	ff808093          	addi	ra,ra,-8 # 8037fff8 <pass+0x37fc28>
8000033c:	0000a183          	lw	gp,0(ra)
80000340:	00000f17          	auipc	t5,0x0
80000344:	010f0f13          	addi	t5,t5,16 # 80000350 <test10a>
80000348:	0030a023          	sw	gp,0(ra)
8000034c:	0780006f          	j	800003c4 <fail>

80000350 <test10a>:
80000350:	00a00e13          	li	t3,10
80000354:	00000f17          	auipc	t5,0x0
80000358:	014f0f13          	addi	t5,t5,20 # 80000368 <test10b>
8000035c:	00100493          	li	s1,1
80000360:	3a305073          	csrwi	pmpcfg3,0
80000364:	0600006f          	j	800003c4 <fail>

80000368 <test10b>:
80000368:	00a00e13          	li	t3,10
8000036c:	0f1e22b7          	lui	t0,0xf1e2
80000370:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
80000374:	3a302373          	csrr	t1,pmpcfg3
80000378:	04629663          	bne	t0,t1,800003c4 <fail>

8000037c <test11a>:
8000037c:	00b00e13          	li	t3,11
80000380:	00000f17          	auipc	t5,0x0
80000384:	044f0f13          	addi	t5,t5,68 # 800003c4 <fail>
80000388:	00000493          	li	s1,0
8000038c:	00000117          	auipc	sp,0x0
80000390:	01010113          	addi	sp,sp,16 # 8000039c <test11b>
80000394:	34111073          	csrw	mepc,sp
80000398:	30200073          	mret

8000039c <test11b>:
8000039c:	00b00e13          	li	t3,11
800003a0:	00000f17          	auipc	t5,0x0
800003a4:	014f0f13          	addi	t5,t5,20 # 800003b4 <test11c>
800003a8:	00100493          	li	s1,1
800003ac:	3ba05073          	csrwi	pmpaddr10,0
800003b0:	0140006f          	j	800003c4 <fail>

800003b4 <test11c>:
800003b4:	00b00e13          	li	t3,11
800003b8:	fff00293          	li	t0,-1
800003bc:	3ba02373          	csrr	t1,pmpaddr10
800003c0:	00628863          	beq	t0,t1,800003d0 <pass>

800003c4 <fail>:
800003c4:	f0100137          	lui	sp,0xf0100
800003c8:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffb54>
800003cc:	01c12023          	sw	t3,0(sp)

800003d0 <pass>:
800003d0:	f0100137          	lui	sp,0xf0100
800003d4:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffb50>
800003d8:	00012023          	sw	zero,0(sp)
