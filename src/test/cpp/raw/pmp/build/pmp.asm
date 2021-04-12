
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
8000002c:	3a4f0f13          	addi	t5,t5,932 # 800003cc <fail>
80000030:	800000b7          	lui	ra,0x80000
80000034:	80008237          	lui	tp,0x80008
80000038:	deadc137          	lui	sp,0xdeadc
8000003c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb17>
80000040:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffc28>
80000044:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7c28>
80000048:	0000a183          	lw	gp,0(ra)
8000004c:	38311063          	bne	sp,gp,800003cc <fail>
80000050:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000054:	36311c63          	bne	sp,gp,800003cc <fail>
80000058:	071202b7          	lui	t0,0x7120
8000005c:	3a029073          	csrw	pmpcfg0,t0
80000060:	3a002373          	csrr	t1,pmpcfg0
80000064:	36629463          	bne	t0,t1,800003cc <fail>
80000068:	191f02b7          	lui	t0,0x191f0
8000006c:	30428293          	addi	t0,t0,772 # 191f0304 <_start-0x66e0fcfc>
80000070:	3a129073          	csrw	pmpcfg1,t0
80000074:	000f12b7          	lui	t0,0xf1
80000078:	90a28293          	addi	t0,t0,-1782 # f090a <_start-0x7ff0f6f6>
8000007c:	3a229073          	csrw	pmpcfg2,t0
80000080:	0f1e22b7          	lui	t0,0xf1e2
80000084:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
80000088:	3a329073          	csrw	pmpcfg3,t0
8000008c:	200002b7          	lui	t0,0x20000
80000090:	3b029073          	csrw	pmpaddr0,t0
80000094:	3b002373          	csrr	t1,pmpaddr0
80000098:	32629a63          	bne	t0,t1,800003cc <fail>
8000009c:	fff00293          	li	t0,-1
800000a0:	3b129073          	csrw	pmpaddr1,t0
800000a4:	200022b7          	lui	t0,0x20002
800000a8:	3b229073          	csrw	pmpaddr2,t0
800000ac:	200042b7          	lui	t0,0x20004
800000b0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000b4:	3b329073          	csrw	pmpaddr3,t0
800000b8:	200042b7          	lui	t0,0x20004
800000bc:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c0:	3b429073          	csrw	pmpaddr4,t0
800000c4:	200042b7          	lui	t0,0x20004
800000c8:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000cc:	3b529073          	csrw	pmpaddr5,t0
800000d0:	200022b7          	lui	t0,0x20002
800000d4:	fff28293          	addi	t0,t0,-1 # 20001fff <_start-0x5fffe001>
800000d8:	3b629073          	csrw	pmpaddr6,t0
800000dc:	200062b7          	lui	t0,0x20006
800000e0:	fff28293          	addi	t0,t0,-1 # 20005fff <_start-0x5fffa001>
800000e4:	3b729073          	csrw	pmpaddr7,t0
800000e8:	200d02b7          	lui	t0,0x200d0
800000ec:	3b829073          	csrw	pmpaddr8,t0
800000f0:	200e02b7          	lui	t0,0x200e0
800000f4:	3b929073          	csrw	pmpaddr9,t0
800000f8:	fff00293          	li	t0,-1
800000fc:	3ba29073          	csrw	pmpaddr10,t0
80000100:	00000293          	li	t0,0
80000104:	3bb29073          	csrw	pmpaddr11,t0
80000108:	00000293          	li	t0,0
8000010c:	3bc29073          	csrw	pmpaddr12,t0
80000110:	00000293          	li	t0,0
80000114:	3bd29073          	csrw	pmpaddr13,t0
80000118:	00000293          	li	t0,0
8000011c:	3be29073          	csrw	pmpaddr14,t0
80000120:	00000293          	li	t0,0
80000124:	3bf29073          	csrw	pmpaddr15,t0
80000128:	00c10137          	lui	sp,0xc10
8000012c:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000130:	0020a023          	sw	sp,0(ra)
80000134:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000138:	0000a183          	lw	gp,0(ra)
8000013c:	28311863          	bne	sp,gp,800003cc <fail>
80000140:	00000193          	li	gp,0
80000144:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000148:	28311263          	bne	sp,gp,800003cc <fail>

8000014c <test1>:
8000014c:	00100e13          	li	t3,1
80000150:	00000f17          	auipc	t5,0x0
80000154:	27cf0f13          	addi	t5,t5,636 # 800003cc <fail>
80000158:	079212b7          	lui	t0,0x7921
8000015c:	80828293          	addi	t0,t0,-2040 # 7920808 <_start-0x786df7f8>
80000160:	3a029073          	csrw	pmpcfg0,t0
80000164:	3a002373          	csrr	t1,pmpcfg0
80000168:	26629263          	bne	t0,t1,800003cc <fail>
8000016c:	800080b7          	lui	ra,0x80008
80000170:	deadc137          	lui	sp,0xdeadc
80000174:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb17>
80000178:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7c28>
8000017c:	00000f17          	auipc	t5,0x0
80000180:	010f0f13          	addi	t5,t5,16 # 8000018c <test2>
80000184:	0000a183          	lw	gp,0(ra)
80000188:	2440006f          	j	800003cc <fail>

8000018c <test2>:
8000018c:	00200e13          	li	t3,2
80000190:	00000f17          	auipc	t5,0x0
80000194:	23cf0f13          	addi	t5,t5,572 # 800003cc <fail>
80000198:	071202b7          	lui	t0,0x7120
8000019c:	3a029073          	csrw	pmpcfg0,t0
800001a0:	3a002373          	csrr	t1,pmpcfg0
800001a4:	22628463          	beq	t0,t1,800003cc <fail>
800001a8:	200042b7          	lui	t0,0x20004
800001ac:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800001b0:	3b305073          	csrwi	pmpaddr3,0
800001b4:	3b302373          	csrr	t1,pmpaddr3
800001b8:	20031a63          	bnez	t1,800003cc <fail>
800001bc:	20628863          	beq	t0,t1,800003cc <fail>
800001c0:	200022b7          	lui	t0,0x20002
800001c4:	3b205073          	csrwi	pmpaddr2,0
800001c8:	3b202373          	csrr	t1,pmpaddr2
800001cc:	20030063          	beqz	t1,800003cc <fail>
800001d0:	1e629e63          	bne	t0,t1,800003cc <fail>
800001d4:	800080b7          	lui	ra,0x80008
800001d8:	deadc137          	lui	sp,0xdeadc
800001dc:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb17>
800001e0:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7c28>
800001e4:	00000f17          	auipc	t5,0x0
800001e8:	010f0f13          	addi	t5,t5,16 # 800001f4 <test3>
800001ec:	0000a183          	lw	gp,0(ra)
800001f0:	1dc0006f          	j	800003cc <fail>

800001f4 <test3>:
800001f4:	00300e13          	li	t3,3
800001f8:	00000f17          	auipc	t5,0x0
800001fc:	1d4f0f13          	addi	t5,t5,468 # 800003cc <fail>
80000200:	00ff02b7          	lui	t0,0xff0
80000204:	3b32a073          	csrs	pmpaddr3,t0
80000208:	3b302373          	csrr	t1,pmpaddr3
8000020c:	1c629063          	bne	t0,t1,800003cc <fail>
80000210:	0ff00293          	li	t0,255
80000214:	3b32a073          	csrs	pmpaddr3,t0
80000218:	3b302373          	csrr	t1,pmpaddr3
8000021c:	00ff02b7          	lui	t0,0xff0
80000220:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
80000224:	1a629463          	bne	t0,t1,800003cc <fail>
80000228:	00ff02b7          	lui	t0,0xff0
8000022c:	3b32b073          	csrc	pmpaddr3,t0
80000230:	3b302373          	csrr	t1,pmpaddr3
80000234:	0ff00293          	li	t0,255
80000238:	18629a63          	bne	t0,t1,800003cc <fail>
8000023c:	00ff02b7          	lui	t0,0xff0
80000240:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
80000244:	3a02b073          	csrc	pmpcfg0,t0
80000248:	3a002373          	csrr	t1,pmpcfg0
8000024c:	079202b7          	lui	t0,0x7920
80000250:	16629e63          	bne	t0,t1,800003cc <fail>
80000254:	00ff02b7          	lui	t0,0xff0
80000258:	70728293          	addi	t0,t0,1799 # ff0707 <_start-0x7f00f8f9>
8000025c:	3a02a073          	csrs	pmpcfg0,t0
80000260:	3a002373          	csrr	t1,pmpcfg0
80000264:	079202b7          	lui	t0,0x7920
80000268:	70728293          	addi	t0,t0,1799 # 7920707 <_start-0x786df8f9>
8000026c:	16629063          	bne	t0,t1,800003cc <fail>

80000270 <test4>:
80000270:	00400e13          	li	t3,4
80000274:	00000f17          	auipc	t5,0x0
80000278:	158f0f13          	addi	t5,t5,344 # 800003cc <fail>
8000027c:	00000117          	auipc	sp,0x0
80000280:	01010113          	addi	sp,sp,16 # 8000028c <test5>
80000284:	34111073          	csrw	mepc,sp
80000288:	30200073          	mret

8000028c <test5>:
8000028c:	00500e13          	li	t3,5
80000290:	00000f17          	auipc	t5,0x0
80000294:	13cf0f13          	addi	t5,t5,316 # 800003cc <fail>
80000298:	deadc137          	lui	sp,0xdeadc
8000029c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb17>
800002a0:	800080b7          	lui	ra,0x80008
800002a4:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7c28>
800002a8:	00000f17          	auipc	t5,0x0
800002ac:	010f0f13          	addi	t5,t5,16 # 800002b8 <test6>
800002b0:	0000a183          	lw	gp,0(ra)
800002b4:	1180006f          	j	800003cc <fail>

800002b8 <test6>:
800002b8:	00600e13          	li	t3,6
800002bc:	00000f17          	auipc	t5,0x0
800002c0:	110f0f13          	addi	t5,t5,272 # 800003cc <fail>
800002c4:	deadc137          	lui	sp,0xdeadc
800002c8:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb17>
800002cc:	800000b7          	lui	ra,0x80000
800002d0:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffc28>
800002d4:	0000a183          	lw	gp,0(ra)
800002d8:	0e311a63          	bne	sp,gp,800003cc <fail>

800002dc <test7>:
800002dc:	00700e13          	li	t3,7
800002e0:	00000f17          	auipc	t5,0x0
800002e4:	0ecf0f13          	addi	t5,t5,236 # 800003cc <fail>
800002e8:	800400b7          	lui	ra,0x80040
800002ec:	0000a183          	lw	gp,0(ra) # 80040000 <pass+0x3fc28>
800002f0:	00000f17          	auipc	t5,0x0
800002f4:	010f0f13          	addi	t5,t5,16 # 80000300 <test8>
800002f8:	0030a023          	sw	gp,0(ra)
800002fc:	0d00006f          	j	800003cc <fail>

80000300 <test8>:
80000300:	00800e13          	li	t3,8
80000304:	00000f17          	auipc	t5,0x0
80000308:	0c8f0f13          	addi	t5,t5,200 # 800003cc <fail>
8000030c:	deadc137          	lui	sp,0xdeadc
80000310:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb17>
80000314:	803400b7          	lui	ra,0x80340
80000318:	ff808093          	addi	ra,ra,-8 # 8033fff8 <pass+0x33fc20>
8000031c:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000320:	00000f17          	auipc	t5,0x0
80000324:	010f0f13          	addi	t5,t5,16 # 80000330 <test9>
80000328:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
8000032c:	0a00006f          	j	800003cc <fail>

80000330 <test9>:
80000330:	00900e13          	li	t3,9
80000334:	00000f17          	auipc	t5,0x0
80000338:	098f0f13          	addi	t5,t5,152 # 800003cc <fail>
8000033c:	803800b7          	lui	ra,0x80380
80000340:	ff808093          	addi	ra,ra,-8 # 8037fff8 <pass+0x37fc20>
80000344:	0000a183          	lw	gp,0(ra)
80000348:	00000f17          	auipc	t5,0x0
8000034c:	010f0f13          	addi	t5,t5,16 # 80000358 <test10a>
80000350:	0030a023          	sw	gp,0(ra)
80000354:	0780006f          	j	800003cc <fail>

80000358 <test10a>:
80000358:	00a00e13          	li	t3,10
8000035c:	00000f17          	auipc	t5,0x0
80000360:	014f0f13          	addi	t5,t5,20 # 80000370 <test10b>
80000364:	00100493          	li	s1,1
80000368:	3a305073          	csrwi	pmpcfg3,0
8000036c:	0600006f          	j	800003cc <fail>

80000370 <test10b>:
80000370:	00a00e13          	li	t3,10
80000374:	0f1e22b7          	lui	t0,0xf1e2
80000378:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
8000037c:	3a302373          	csrr	t1,pmpcfg3
80000380:	04629663          	bne	t0,t1,800003cc <fail>

80000384 <test11a>:
80000384:	00b00e13          	li	t3,11
80000388:	00000f17          	auipc	t5,0x0
8000038c:	044f0f13          	addi	t5,t5,68 # 800003cc <fail>
80000390:	00000493          	li	s1,0
80000394:	00000117          	auipc	sp,0x0
80000398:	01010113          	addi	sp,sp,16 # 800003a4 <test11b>
8000039c:	34111073          	csrw	mepc,sp
800003a0:	30200073          	mret

800003a4 <test11b>:
800003a4:	00b00e13          	li	t3,11
800003a8:	00000f17          	auipc	t5,0x0
800003ac:	014f0f13          	addi	t5,t5,20 # 800003bc <test11c>
800003b0:	00100493          	li	s1,1
800003b4:	3ba05073          	csrwi	pmpaddr10,0
800003b8:	0140006f          	j	800003cc <fail>

800003bc <test11c>:
800003bc:	00b00e13          	li	t3,11
800003c0:	fff00293          	li	t0,-1
800003c4:	3ba02373          	csrr	t1,pmpaddr10
800003c8:	00628863          	beq	t0,t1,800003d8 <pass>

800003cc <fail>:
800003cc:	f0100137          	lui	sp,0xf0100
800003d0:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffb4c>
800003d4:	01c12023          	sw	t3,0(sp)

800003d8 <pass>:
800003d8:	f0100137          	lui	sp,0xf0100
800003dc:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffb48>
800003e0:	00012023          	sw	zero,0(sp)
