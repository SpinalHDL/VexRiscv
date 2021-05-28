
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
8000002c:	340f0f13          	addi	t5,t5,832 # 80000368 <fail>
80000030:	800000b7          	lui	ra,0x80000
80000034:	80008237          	lui	tp,0x80008
80000038:	deadc137          	lui	sp,0xdeadc
8000003c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb7b>
80000040:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffc8c>
80000044:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7c8c>
80000048:	0000a183          	lw	gp,0(ra)
8000004c:	30311e63          	bne	sp,gp,80000368 <fail>
80000050:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000054:	30311a63          	bne	sp,gp,80000368 <fail>
80000058:	071a02b7          	lui	t0,0x71a0
8000005c:	3a029073          	csrw	pmpcfg0,t0
80000060:	3a002373          	csrr	t1,pmpcfg0
80000064:	30629263          	bne	t0,t1,80000368 <fail>
80000068:	1a1902b7          	lui	t0,0x1a190
8000006c:	30428293          	addi	t0,t0,772 # 1a190304 <_start-0x65e6fcfc>
80000070:	3a129073          	csrw	pmpcfg1,t0
80000074:	000f12b7          	lui	t0,0xf1
80000078:	90a28293          	addi	t0,t0,-1782 # f090a <_start-0x7ff0f6f6>
8000007c:	3a229073          	csrw	pmpcfg2,t0
80000080:	3a202373          	csrr	t1,pmpcfg2
80000084:	2e629263          	bne	t0,t1,80000368 <fail>
80000088:	1c1e22b7          	lui	t0,0x1c1e2
8000008c:	90028293          	addi	t0,t0,-1792 # 1c1e1900 <_start-0x63e1e700>
80000090:	3a329073          	csrw	pmpcfg3,t0
80000094:	200002b7          	lui	t0,0x20000
80000098:	3b029073          	csrw	pmpaddr0,t0
8000009c:	3b002373          	csrr	t1,pmpaddr0
800000a0:	2c629463          	bne	t0,t1,80000368 <fail>
800000a4:	fff00293          	li	t0,-1
800000a8:	3b129073          	csrw	pmpaddr1,t0
800000ac:	202002b7          	lui	t0,0x20200
800000b0:	3b229073          	csrw	pmpaddr2,t0
800000b4:	200042b7          	lui	t0,0x20004
800000b8:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000bc:	3b329073          	csrw	pmpaddr3,t0
800000c0:	200042b7          	lui	t0,0x20004
800000c4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c8:	3b429073          	csrw	pmpaddr4,t0
800000cc:	200042b7          	lui	t0,0x20004
800000d0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000d4:	3b529073          	csrw	pmpaddr5,t0
800000d8:	230002b7          	lui	t0,0x23000
800000dc:	fff28293          	addi	t0,t0,-1 # 22ffffff <_start-0x5d000001>
800000e0:	3b629073          	csrw	pmpaddr6,t0
800000e4:	220402b7          	lui	t0,0x22040
800000e8:	fff28293          	addi	t0,t0,-1 # 2203ffff <_start-0x5dfc0001>
800000ec:	3b729073          	csrw	pmpaddr7,t0
800000f0:	200d02b7          	lui	t0,0x200d0
800000f4:	3b829073          	csrw	pmpaddr8,t0
800000f8:	200e02b7          	lui	t0,0x200e0
800000fc:	3b929073          	csrw	pmpaddr9,t0
80000100:	fff00293          	li	t0,-1
80000104:	3ba29073          	csrw	pmpaddr10,t0
80000108:	00000293          	li	t0,0
8000010c:	3bb29073          	csrw	pmpaddr11,t0
80000110:	00000293          	li	t0,0
80000114:	3bc29073          	csrw	pmpaddr12,t0
80000118:	00000293          	li	t0,0
8000011c:	3bd29073          	csrw	pmpaddr13,t0
80000120:	00000293          	li	t0,0
80000124:	3be29073          	csrw	pmpaddr14,t0
80000128:	fff00293          	li	t0,-1
8000012c:	3bf29073          	csrw	pmpaddr15,t0
80000130:	00c10137          	lui	sp,0xc10
80000134:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000138:	0020a023          	sw	sp,0(ra)
8000013c:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000140:	0000a183          	lw	gp,0(ra)
80000144:	22311263          	bne	sp,gp,80000368 <fail>
80000148:	00000193          	li	gp,0
8000014c:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000150:	20311c63          	bne	sp,gp,80000368 <fail>

80000154 <test1>:
80000154:	00100e13          	li	t3,1
80000158:	00000f17          	auipc	t5,0x0
8000015c:	210f0f13          	addi	t5,t5,528 # 80000368 <fail>
80000160:	079a12b7          	lui	t0,0x79a1
80000164:	80828293          	addi	t0,t0,-2040 # 79a0808 <_start-0x7865f7f8>
80000168:	3a029073          	csrw	pmpcfg0,t0
8000016c:	3a002373          	csrr	t1,pmpcfg0
80000170:	1e629c63          	bne	t0,t1,80000368 <fail>
80000174:	808000b7          	lui	ra,0x80800
80000178:	deadc137          	lui	sp,0xdeadc
8000017c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb7b>
80000180:	0020a023          	sw	sp,0(ra) # 80800000 <pass+0x7ffc8c>
80000184:	00000f17          	auipc	t5,0x0
80000188:	010f0f13          	addi	t5,t5,16 # 80000194 <test2>
8000018c:	0000a183          	lw	gp,0(ra)
80000190:	1d80006f          	j	80000368 <fail>

80000194 <test2>:
80000194:	00200e13          	li	t3,2
80000198:	00000f17          	auipc	t5,0x0
8000019c:	1d0f0f13          	addi	t5,t5,464 # 80000368 <fail>
800001a0:	071a02b7          	lui	t0,0x71a0
800001a4:	3a029073          	csrw	pmpcfg0,t0
800001a8:	3a002373          	csrr	t1,pmpcfg0
800001ac:	1a628e63          	beq	t0,t1,80000368 <fail>
800001b0:	3b305073          	csrwi	pmpaddr3,0
800001b4:	3b302373          	csrr	t1,pmpaddr3
800001b8:	1a031863          	bnez	t1,80000368 <fail>
800001bc:	3b205073          	csrwi	pmpaddr2,0
800001c0:	3b202373          	csrr	t1,pmpaddr2
800001c4:	1a030263          	beqz	t1,80000368 <fail>
800001c8:	808000b7          	lui	ra,0x80800
800001cc:	deadc137          	lui	sp,0xdeadc
800001d0:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb7b>
800001d4:	0020a023          	sw	sp,0(ra) # 80800000 <pass+0x7ffc8c>
800001d8:	00000f17          	auipc	t5,0x0
800001dc:	010f0f13          	addi	t5,t5,16 # 800001e8 <test3>
800001e0:	0000a183          	lw	gp,0(ra)
800001e4:	1840006f          	j	80000368 <fail>

800001e8 <test3>:
800001e8:	00300e13          	li	t3,3
800001ec:	00000f17          	auipc	t5,0x0
800001f0:	17cf0f13          	addi	t5,t5,380 # 80000368 <fail>
800001f4:	00ff02b7          	lui	t0,0xff0
800001f8:	3b32a073          	csrs	pmpaddr3,t0
800001fc:	3b302373          	csrr	t1,pmpaddr3
80000200:	16629463          	bne	t0,t1,80000368 <fail>
80000204:	0ff00293          	li	t0,255
80000208:	3b32a073          	csrs	pmpaddr3,t0
8000020c:	3b302373          	csrr	t1,pmpaddr3
80000210:	00ff02b7          	lui	t0,0xff0
80000214:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
80000218:	14629863          	bne	t0,t1,80000368 <fail>
8000021c:	00ff02b7          	lui	t0,0xff0
80000220:	3b32b073          	csrc	pmpaddr3,t0
80000224:	3b302373          	csrr	t1,pmpaddr3
80000228:	0ff00293          	li	t0,255
8000022c:	12629e63          	bne	t0,t1,80000368 <fail>
80000230:	00ff02b7          	lui	t0,0xff0
80000234:	0ff28293          	addi	t0,t0,255 # ff00ff <_start-0x7f00ff01>
80000238:	3a02b073          	csrc	pmpcfg0,t0
8000023c:	3a002373          	csrr	t1,pmpcfg0
80000240:	079a02b7          	lui	t0,0x79a0
80000244:	12629263          	bne	t0,t1,80000368 <fail>
80000248:	00ff02b7          	lui	t0,0xff0
8000024c:	70728293          	addi	t0,t0,1799 # ff0707 <_start-0x7f00f8f9>
80000250:	3a02a073          	csrs	pmpcfg0,t0
80000254:	3a002373          	csrr	t1,pmpcfg0
80000258:	079a02b7          	lui	t0,0x79a0
8000025c:	70728293          	addi	t0,t0,1799 # 79a0707 <_start-0x7865f8f9>
80000260:	10629463          	bne	t0,t1,80000368 <fail>

80000264 <test4>:
80000264:	00400e13          	li	t3,4
80000268:	00000f17          	auipc	t5,0x0
8000026c:	100f0f13          	addi	t5,t5,256 # 80000368 <fail>
80000270:	00000117          	auipc	sp,0x0
80000274:	01010113          	addi	sp,sp,16 # 80000280 <test5>
80000278:	34111073          	csrw	mepc,sp
8000027c:	30200073          	mret

80000280 <test5>:
80000280:	00500e13          	li	t3,5
80000284:	00000f17          	auipc	t5,0x0
80000288:	0e4f0f13          	addi	t5,t5,228 # 80000368 <fail>
8000028c:	deadc137          	lui	sp,0xdeadc
80000290:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb7b>
80000294:	808000b7          	lui	ra,0x80800
80000298:	0020a023          	sw	sp,0(ra) # 80800000 <pass+0x7ffc8c>
8000029c:	00000f17          	auipc	t5,0x0
800002a0:	010f0f13          	addi	t5,t5,16 # 800002ac <test6>
800002a4:	0000a183          	lw	gp,0(ra)
800002a8:	0c00006f          	j	80000368 <fail>

800002ac <test6>:
800002ac:	00600e13          	li	t3,6
800002b0:	00000f17          	auipc	t5,0x0
800002b4:	0b8f0f13          	addi	t5,t5,184 # 80000368 <fail>
800002b8:	deadc137          	lui	sp,0xdeadc
800002bc:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbb7b>
800002c0:	880000b7          	lui	ra,0x88000
800002c4:	0020a023          	sw	sp,0(ra) # 88000000 <pass+0x7fffc8c>
800002c8:	0000a183          	lw	gp,0(ra)

800002cc <test7>:
800002cc:	00700e13          	li	t3,7
800002d0:	00000f17          	auipc	t5,0x0
800002d4:	098f0f13          	addi	t5,t5,152 # 80000368 <fail>
800002d8:	890000b7          	lui	ra,0x89000
800002dc:	ff008093          	addi	ra,ra,-16 # 88fffff0 <pass+0x8fffc7c>
800002e0:	0000a183          	lw	gp,0(ra)
800002e4:	00000f17          	auipc	t5,0x0
800002e8:	010f0f13          	addi	t5,t5,16 # 800002f4 <test8a>
800002ec:	0030a023          	sw	gp,0(ra)
800002f0:	0780006f          	j	80000368 <fail>

800002f4 <test8a>:
800002f4:	00800e13          	li	t3,8
800002f8:	00000f17          	auipc	t5,0x0
800002fc:	014f0f13          	addi	t5,t5,20 # 8000030c <test8b>
80000300:	00100493          	li	s1,1
80000304:	3a305073          	csrwi	pmpcfg3,0
80000308:	0600006f          	j	80000368 <fail>

8000030c <test8b>:
8000030c:	00800e13          	li	t3,8
80000310:	1c1e22b7          	lui	t0,0x1c1e2
80000314:	90028293          	addi	t0,t0,-1792 # 1c1e1900 <_start-0x63e1e700>
80000318:	3a302373          	csrr	t1,pmpcfg3
8000031c:	04629663          	bne	t0,t1,80000368 <fail>

80000320 <test9a>:
80000320:	00900e13          	li	t3,9
80000324:	00000f17          	auipc	t5,0x0
80000328:	044f0f13          	addi	t5,t5,68 # 80000368 <fail>
8000032c:	00000493          	li	s1,0
80000330:	00000117          	auipc	sp,0x0
80000334:	01010113          	addi	sp,sp,16 # 80000340 <test9b>
80000338:	34111073          	csrw	mepc,sp
8000033c:	30200073          	mret

80000340 <test9b>:
80000340:	00900e13          	li	t3,9
80000344:	00000f17          	auipc	t5,0x0
80000348:	014f0f13          	addi	t5,t5,20 # 80000358 <test9c>
8000034c:	00100493          	li	s1,1
80000350:	3ba05073          	csrwi	pmpaddr10,0
80000354:	0140006f          	j	80000368 <fail>

80000358 <test9c>:
80000358:	00900e13          	li	t3,9
8000035c:	fff00293          	li	t0,-1
80000360:	3ba02373          	csrr	t1,pmpaddr10
80000364:	00628863          	beq	t0,t1,80000374 <pass>

80000368 <fail>:
80000368:	f0100137          	lui	sp,0xf0100
8000036c:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffbb0>
80000370:	01c12023          	sw	t3,0(sp)

80000374 <pass>:
80000374:	f0100137          	lui	sp,0xf0100
80000378:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffbac>
8000037c:	00012023          	sw	zero,0(sp)
