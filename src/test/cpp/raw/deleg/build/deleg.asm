
build/deleg.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00100e93          	li	t4,1
80000004:	00000097          	auipc	ra,0x0
80000008:	6fc08093          	addi	ra,ra,1788 # 80000700 <mtrap>
8000000c:	30509073          	csrw	mtvec,ra
80000010:	00000097          	auipc	ra,0x0
80000014:	72808093          	addi	ra,ra,1832 # 80000738 <strap>
80000018:	10509073          	csrw	stvec,ra
8000001c:	f00110b7          	lui	ra,0xf0011
80000020:	00000113          	li	sp,0
80000024:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>

80000028 <test1>:
80000028:	00100e13          	li	t3,1
8000002c:	00000f17          	auipc	t5,0x0
80000030:	00cf0f13          	addi	t5,t5,12 # 80000038 <test2>
80000034:	00000073          	ecall

80000038 <test2>:
80000038:	00200e13          	li	t3,2
8000003c:	000020b7          	lui	ra,0x2
80000040:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000044:	00000113          	li	sp,0
80000048:	3000b073          	csrc	mstatus,ra
8000004c:	30012073          	csrs	mstatus,sp
80000050:	00000097          	auipc	ra,0x0
80000054:	01408093          	addi	ra,ra,20 # 80000064 <test2+0x2c>
80000058:	34109073          	csrw	mepc,ra
8000005c:	30200073          	mret
80000060:	6880006f          	j	800006e8 <fail>
80000064:	00000f17          	auipc	t5,0x0
80000068:	024f0f13          	addi	t5,t5,36 # 80000088 <test4>
8000006c:	00000073          	ecall
80000070:	6780006f          	j	800006e8 <fail>

80000074 <test3>:
80000074:	00300e13          	li	t3,3
80000078:	00000f17          	auipc	t5,0x0
8000007c:	010f0f13          	addi	t5,t5,16 # 80000088 <test4>
80000080:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000084:	6640006f          	j	800006e8 <fail>

80000088 <test4>:
80000088:	00400e13          	li	t3,4
8000008c:	000020b7          	lui	ra,0x2
80000090:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000094:	00001137          	lui	sp,0x1
80000098:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
8000009c:	3000b073          	csrc	mstatus,ra
800000a0:	30012073          	csrs	mstatus,sp
800000a4:	00000097          	auipc	ra,0x0
800000a8:	01408093          	addi	ra,ra,20 # 800000b8 <test4+0x30>
800000ac:	34109073          	csrw	mepc,ra
800000b0:	30200073          	mret
800000b4:	6340006f          	j	800006e8 <fail>
800000b8:	00000f17          	auipc	t5,0x0
800000bc:	010f0f13          	addi	t5,t5,16 # 800000c8 <test5>
800000c0:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
800000c4:	6240006f          	j	800006e8 <fail>

800000c8 <test5>:
800000c8:	00500e13          	li	t3,5
800000cc:	000020b7          	lui	ra,0x2
800000d0:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
800000d4:	00000113          	li	sp,0
800000d8:	3000b073          	csrc	mstatus,ra
800000dc:	30012073          	csrs	mstatus,sp
800000e0:	00000097          	auipc	ra,0x0
800000e4:	01408093          	addi	ra,ra,20 # 800000f4 <test5+0x2c>
800000e8:	34109073          	csrw	mepc,ra
800000ec:	30200073          	mret
800000f0:	5f80006f          	j	800006e8 <fail>
800000f4:	00000f17          	auipc	t5,0x0
800000f8:	010f0f13          	addi	t5,t5,16 # 80000104 <test6>
800000fc:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000100:	5e80006f          	j	800006e8 <fail>

80000104 <test6>:
80000104:	00600e13          	li	t3,6
80000108:	01000093          	li	ra,16
8000010c:	30209073          	csrw	medeleg,ra

80000110 <test7>:
80000110:	00700e13          	li	t3,7
80000114:	00000f17          	auipc	t5,0x0
80000118:	010f0f13          	addi	t5,t5,16 # 80000124 <test8>
8000011c:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000120:	5c80006f          	j	800006e8 <fail>

80000124 <test8>:
80000124:	00800e13          	li	t3,8
80000128:	00000f17          	auipc	t5,0x0
8000012c:	03cf0f13          	addi	t5,t5,60 # 80000164 <test9>
80000130:	000020b7          	lui	ra,0x2
80000134:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000138:	00001137          	lui	sp,0x1
8000013c:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
80000140:	3000b073          	csrc	mstatus,ra
80000144:	30012073          	csrs	mstatus,sp
80000148:	00000097          	auipc	ra,0x0
8000014c:	01408093          	addi	ra,ra,20 # 8000015c <test8+0x38>
80000150:	34109073          	csrw	mepc,ra
80000154:	30200073          	mret
80000158:	5900006f          	j	800006e8 <fail>
8000015c:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000160:	5880006f          	j	800006e8 <fail>

80000164 <test9>:
80000164:	00900e13          	li	t3,9
80000168:	00000f17          	auipc	t5,0x0
8000016c:	038f0f13          	addi	t5,t5,56 # 800001a0 <test10>
80000170:	000020b7          	lui	ra,0x2
80000174:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000178:	00000113          	li	sp,0
8000017c:	3000b073          	csrc	mstatus,ra
80000180:	30012073          	csrs	mstatus,sp
80000184:	00000097          	auipc	ra,0x0
80000188:	01408093          	addi	ra,ra,20 # 80000198 <test9+0x34>
8000018c:	34109073          	csrw	mepc,ra
80000190:	30200073          	mret
80000194:	5540006f          	j	800006e8 <fail>
80000198:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
8000019c:	54c0006f          	j	800006e8 <fail>

800001a0 <test10>:
800001a0:	00a00e13          	li	t3,10
800001a4:	00000f17          	auipc	t5,0x0
800001a8:	03cf0f13          	addi	t5,t5,60 # 800001e0 <test11>
800001ac:	f00110b7          	lui	ra,0xf0011
800001b0:	00000113          	li	sp,0
800001b4:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>
800001b8:	00800093          	li	ra,8
800001bc:	30009073          	csrw	mstatus,ra
800001c0:	000010b7          	lui	ra,0x1
800001c4:	80008093          	addi	ra,ra,-2048 # 800 <_start-0x7ffff800>
800001c8:	30409073          	csrw	mie,ra
800001cc:	f00110b7          	lui	ra,0xf0011
800001d0:	00100113          	li	sp,1
800001d4:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>
800001d8:	10500073          	wfi
800001dc:	50c0006f          	j	800006e8 <fail>

800001e0 <test11>:
800001e0:	00b00e13          	li	t3,11
800001e4:	00000f17          	auipc	t5,0x0
800001e8:	068f0f13          	addi	t5,t5,104 # 8000024c <test12>
800001ec:	f00110b7          	lui	ra,0xf0011
800001f0:	00000113          	li	sp,0
800001f4:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>
800001f8:	00800093          	li	ra,8
800001fc:	30009073          	csrw	mstatus,ra
80000200:	000010b7          	lui	ra,0x1
80000204:	80008093          	addi	ra,ra,-2048 # 800 <_start-0x7ffff800>
80000208:	30409073          	csrw	mie,ra
8000020c:	000020b7          	lui	ra,0x2
80000210:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000214:	00001137          	lui	sp,0x1
80000218:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
8000021c:	3000b073          	csrc	mstatus,ra
80000220:	30012073          	csrs	mstatus,sp
80000224:	00000097          	auipc	ra,0x0
80000228:	01408093          	addi	ra,ra,20 # 80000238 <test11+0x58>
8000022c:	34109073          	csrw	mepc,ra
80000230:	30200073          	mret
80000234:	4b40006f          	j	800006e8 <fail>
80000238:	f00110b7          	lui	ra,0xf0011
8000023c:	00100113          	li	sp,1
80000240:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>
80000244:	10500073          	wfi
80000248:	4a00006f          	j	800006e8 <fail>

8000024c <test12>:
8000024c:	00c00e13          	li	t3,12
80000250:	00000f17          	auipc	t5,0x0
80000254:	064f0f13          	addi	t5,t5,100 # 800002b4 <test14>
80000258:	f00110b7          	lui	ra,0xf0011
8000025c:	00000113          	li	sp,0
80000260:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>
80000264:	00800093          	li	ra,8
80000268:	30009073          	csrw	mstatus,ra
8000026c:	000010b7          	lui	ra,0x1
80000270:	80008093          	addi	ra,ra,-2048 # 800 <_start-0x7ffff800>
80000274:	30409073          	csrw	mie,ra
80000278:	000020b7          	lui	ra,0x2
8000027c:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000280:	00000113          	li	sp,0
80000284:	3000b073          	csrc	mstatus,ra
80000288:	30012073          	csrs	mstatus,sp
8000028c:	00000097          	auipc	ra,0x0
80000290:	01408093          	addi	ra,ra,20 # 800002a0 <test12+0x54>
80000294:	34109073          	csrw	mepc,ra
80000298:	30200073          	mret
8000029c:	44c0006f          	j	800006e8 <fail>
800002a0:	f00110b7          	lui	ra,0xf0011
800002a4:	00100113          	li	sp,1
800002a8:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x700108c8>
800002ac:	10500073          	wfi
800002b0:	4380006f          	j	800006e8 <fail>

800002b4 <test14>:
800002b4:	00200093          	li	ra,2
800002b8:	10009073          	csrw	sstatus,ra
800002bc:	00e00e13          	li	t3,14
800002c0:	00000f17          	auipc	t5,0x0
800002c4:	040f0f13          	addi	t5,t5,64 # 80000300 <test15>
800002c8:	f00120b7          	lui	ra,0xf0012
800002cc:	00000113          	li	sp,0
800002d0:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800002d4:	00200093          	li	ra,2
800002d8:	30009073          	csrw	mstatus,ra
800002dc:	20000093          	li	ra,512
800002e0:	30409073          	csrw	mie,ra
800002e4:	00000e93          	li	t4,0
800002e8:	f00120b7          	lui	ra,0xf0012
800002ec:	00100113          	li	sp,1
800002f0:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800002f4:	06400093          	li	ra,100
800002f8:	fff08093          	addi	ra,ra,-1
800002fc:	fe104ee3          	bgtz	ra,800002f8 <test14+0x44>

80000300 <test15>:
80000300:	00f00e13          	li	t3,15
80000304:	00000f17          	auipc	t5,0x0
80000308:	068f0f13          	addi	t5,t5,104 # 8000036c <test16>
8000030c:	f00120b7          	lui	ra,0xf0012
80000310:	00000113          	li	sp,0
80000314:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000318:	00200093          	li	ra,2
8000031c:	30009073          	csrw	mstatus,ra
80000320:	20000093          	li	ra,512
80000324:	30409073          	csrw	mie,ra
80000328:	000020b7          	lui	ra,0x2
8000032c:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000330:	00001137          	lui	sp,0x1
80000334:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
80000338:	3000b073          	csrc	mstatus,ra
8000033c:	30012073          	csrs	mstatus,sp
80000340:	00000097          	auipc	ra,0x0
80000344:	01408093          	addi	ra,ra,20 # 80000354 <test15+0x54>
80000348:	34109073          	csrw	mepc,ra
8000034c:	30200073          	mret
80000350:	3980006f          	j	800006e8 <fail>
80000354:	00100e93          	li	t4,1
80000358:	f00120b7          	lui	ra,0xf0012
8000035c:	00100113          	li	sp,1
80000360:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000364:	10500073          	wfi
80000368:	3800006f          	j	800006e8 <fail>

8000036c <test16>:
8000036c:	01000e13          	li	t3,16
80000370:	00000f17          	auipc	t5,0x0
80000374:	060f0f13          	addi	t5,t5,96 # 800003d0 <test17>
80000378:	f00120b7          	lui	ra,0xf0012
8000037c:	00000113          	li	sp,0
80000380:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000384:	00200093          	li	ra,2
80000388:	30009073          	csrw	mstatus,ra
8000038c:	20000093          	li	ra,512
80000390:	30409073          	csrw	mie,ra
80000394:	000020b7          	lui	ra,0x2
80000398:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
8000039c:	00000113          	li	sp,0
800003a0:	3000b073          	csrc	mstatus,ra
800003a4:	30012073          	csrs	mstatus,sp
800003a8:	00000097          	auipc	ra,0x0
800003ac:	01408093          	addi	ra,ra,20 # 800003bc <test16+0x50>
800003b0:	34109073          	csrw	mepc,ra
800003b4:	30200073          	mret
800003b8:	3300006f          	j	800006e8 <fail>
800003bc:	f00120b7          	lui	ra,0xf0012
800003c0:	00100113          	li	sp,1
800003c4:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800003c8:	10500073          	wfi
800003cc:	31c0006f          	j	800006e8 <fail>

800003d0 <test17>:
800003d0:	01100e13          	li	t3,17
800003d4:	20000093          	li	ra,512
800003d8:	30309073          	csrw	mideleg,ra
800003dc:	00000f17          	auipc	t5,0x0
800003e0:	040f0f13          	addi	t5,t5,64 # 8000041c <test18>
800003e4:	f00120b7          	lui	ra,0xf0012
800003e8:	00000113          	li	sp,0
800003ec:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800003f0:	00200093          	li	ra,2
800003f4:	30009073          	csrw	mstatus,ra
800003f8:	20000093          	li	ra,512
800003fc:	30409073          	csrw	mie,ra
80000400:	00000e93          	li	t4,0
80000404:	f00120b7          	lui	ra,0xf0012
80000408:	00100113          	li	sp,1
8000040c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000410:	06400093          	li	ra,100
80000414:	fff08093          	addi	ra,ra,-1
80000418:	fe104ee3          	bgtz	ra,80000414 <test17+0x44>

8000041c <test18>:
8000041c:	01200e13          	li	t3,18
80000420:	00000f17          	auipc	t5,0x0
80000424:	068f0f13          	addi	t5,t5,104 # 80000488 <test19>
80000428:	f00120b7          	lui	ra,0xf0012
8000042c:	00000113          	li	sp,0
80000430:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000434:	00200093          	li	ra,2
80000438:	30009073          	csrw	mstatus,ra
8000043c:	20000093          	li	ra,512
80000440:	30409073          	csrw	mie,ra
80000444:	000020b7          	lui	ra,0x2
80000448:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
8000044c:	00001137          	lui	sp,0x1
80000450:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
80000454:	3000b073          	csrc	mstatus,ra
80000458:	30012073          	csrs	mstatus,sp
8000045c:	00000097          	auipc	ra,0x0
80000460:	01408093          	addi	ra,ra,20 # 80000470 <test18+0x54>
80000464:	34109073          	csrw	mepc,ra
80000468:	30200073          	mret
8000046c:	27c0006f          	j	800006e8 <fail>
80000470:	00100e93          	li	t4,1
80000474:	f00120b7          	lui	ra,0xf0012
80000478:	00100113          	li	sp,1
8000047c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000480:	10500073          	wfi
80000484:	2640006f          	j	800006e8 <fail>

80000488 <test19>:
80000488:	01300e13          	li	t3,19
8000048c:	00000f17          	auipc	t5,0x0
80000490:	060f0f13          	addi	t5,t5,96 # 800004ec <test20>
80000494:	f00120b7          	lui	ra,0xf0012
80000498:	00000113          	li	sp,0
8000049c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800004a0:	00200093          	li	ra,2
800004a4:	30009073          	csrw	mstatus,ra
800004a8:	20000093          	li	ra,512
800004ac:	30409073          	csrw	mie,ra
800004b0:	000020b7          	lui	ra,0x2
800004b4:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
800004b8:	00000113          	li	sp,0
800004bc:	3000b073          	csrc	mstatus,ra
800004c0:	30012073          	csrs	mstatus,sp
800004c4:	00000097          	auipc	ra,0x0
800004c8:	01408093          	addi	ra,ra,20 # 800004d8 <test19+0x50>
800004cc:	34109073          	csrw	mepc,ra
800004d0:	30200073          	mret
800004d4:	2140006f          	j	800006e8 <fail>
800004d8:	f00120b7          	lui	ra,0xf0012
800004dc:	00100113          	li	sp,1
800004e0:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800004e4:	10500073          	wfi
800004e8:	2000006f          	j	800006e8 <fail>

800004ec <test20>:
800004ec:	f00120b7          	lui	ra,0xf0012
800004f0:	00000113          	li	sp,0
800004f4:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
800004f8:	01400e13          	li	t3,20
800004fc:	00000f17          	auipc	t5,0x0
80000500:	030f0f13          	addi	t5,t5,48 # 8000052c <test21>
80000504:	00200093          	li	ra,2
80000508:	30009073          	csrw	mstatus,ra
8000050c:	20000093          	li	ra,512
80000510:	30409073          	csrw	mie,ra
80000514:	00000e93          	li	t4,0
80000518:	20000093          	li	ra,512
8000051c:	1440a073          	csrs	sip,ra
80000520:	06400093          	li	ra,100
80000524:	fff08093          	addi	ra,ra,-1
80000528:	fe104ee3          	bgtz	ra,80000524 <test20+0x38>

8000052c <test21>:
8000052c:	01500e13          	li	t3,21
80000530:	00000f17          	auipc	t5,0x0
80000534:	060f0f13          	addi	t5,t5,96 # 80000590 <test22>
80000538:	20000093          	li	ra,512
8000053c:	1440b073          	csrc	sip,ra
80000540:	00200093          	li	ra,2
80000544:	30009073          	csrw	mstatus,ra
80000548:	20000093          	li	ra,512
8000054c:	30409073          	csrw	mie,ra
80000550:	000020b7          	lui	ra,0x2
80000554:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000558:	00001137          	lui	sp,0x1
8000055c:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
80000560:	3000b073          	csrc	mstatus,ra
80000564:	30012073          	csrs	mstatus,sp
80000568:	00000097          	auipc	ra,0x0
8000056c:	01408093          	addi	ra,ra,20 # 8000057c <test21+0x50>
80000570:	34109073          	csrw	mepc,ra
80000574:	30200073          	mret
80000578:	1700006f          	j	800006e8 <fail>
8000057c:	00100e93          	li	t4,1
80000580:	20000093          	li	ra,512
80000584:	1440a073          	csrs	sip,ra
80000588:	10500073          	wfi
8000058c:	15c0006f          	j	800006e8 <fail>

80000590 <test22>:
80000590:	01600e13          	li	t3,22
80000594:	00000f17          	auipc	t5,0x0
80000598:	058f0f13          	addi	t5,t5,88 # 800005ec <test23>
8000059c:	20000093          	li	ra,512
800005a0:	1440b073          	csrc	sip,ra
800005a4:	00200093          	li	ra,2
800005a8:	30009073          	csrw	mstatus,ra
800005ac:	20000093          	li	ra,512
800005b0:	30409073          	csrw	mie,ra
800005b4:	20000093          	li	ra,512
800005b8:	1440a073          	csrs	sip,ra
800005bc:	000020b7          	lui	ra,0x2
800005c0:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
800005c4:	00000113          	li	sp,0
800005c8:	3000b073          	csrc	mstatus,ra
800005cc:	30012073          	csrs	mstatus,sp
800005d0:	00000097          	auipc	ra,0x0
800005d4:	01408093          	addi	ra,ra,20 # 800005e4 <test22+0x54>
800005d8:	34109073          	csrw	mepc,ra
800005dc:	30200073          	mret
800005e0:	1080006f          	j	800006e8 <fail>
800005e4:	10500073          	wfi
800005e8:	1000006f          	j	800006e8 <fail>

800005ec <test23>:
800005ec:	01700e13          	li	t3,23
800005f0:	00000e93          	li	t4,0
800005f4:	f00120b7          	lui	ra,0xf0012
800005f8:	00000113          	li	sp,0
800005fc:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000600:	20000093          	li	ra,512
80000604:	1440b073          	csrc	sip,ra
80000608:	344021f3          	csrr	gp,mip
8000060c:	f00120b7          	lui	ra,0xf0012
80000610:	00100113          	li	sp,1
80000614:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000618:	20000093          	li	ra,512
8000061c:	1440b073          	csrc	sip,ra
80000620:	344021f3          	csrr	gp,mip
80000624:	f00120b7          	lui	ra,0xf0012
80000628:	00000113          	li	sp,0
8000062c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000630:	20000093          	li	ra,512
80000634:	1440b073          	csrc	sip,ra
80000638:	344021f3          	csrr	gp,mip
8000063c:	f00120b7          	lui	ra,0xf0012
80000640:	00000113          	li	sp,0
80000644:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000648:	20000093          	li	ra,512
8000064c:	1440a073          	csrs	sip,ra
80000650:	344021f3          	csrr	gp,mip
80000654:	f00120b7          	lui	ra,0xf0012
80000658:	00100113          	li	sp,1
8000065c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>
80000660:	20000093          	li	ra,512
80000664:	1440a073          	csrs	sip,ra
80000668:	344021f3          	csrr	gp,mip
8000066c:	f00120b7          	lui	ra,0xf0012
80000670:	00000113          	li	sp,0
80000674:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x700118c8>

80000678 <test24>:
80000678:	01800e13          	li	t3,24
8000067c:	00200093          	li	ra,2
80000680:	3040a073          	csrs	mie,ra
80000684:	3440a073          	csrs	mip,ra
80000688:	3000a073          	csrs	mstatus,ra
8000068c:	00100e93          	li	t4,1
80000690:	00000f17          	auipc	t5,0x0
80000694:	03cf0f13          	addi	t5,t5,60 # 800006cc <test25>
80000698:	000020b7          	lui	ra,0x2
8000069c:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
800006a0:	00001137          	lui	sp,0x1
800006a4:	80010113          	addi	sp,sp,-2048 # 800 <_start-0x7ffff800>
800006a8:	3000b073          	csrc	mstatus,ra
800006ac:	30012073          	csrs	mstatus,sp
800006b0:	00000097          	auipc	ra,0x0
800006b4:	01408093          	addi	ra,ra,20 # 800006c4 <test24_s>
800006b8:	34109073          	csrw	mepc,ra
800006bc:	30200073          	mret
800006c0:	0280006f          	j	800006e8 <fail>

800006c4 <test24_s>:
800006c4:	10500073          	wfi
800006c8:	0200006f          	j	800006e8 <fail>

800006cc <test25>:
800006cc:	01900e13          	li	t3,25
800006d0:	00000f17          	auipc	t5,0x0
800006d4:	014f0f13          	addi	t5,t5,20 # 800006e4 <test26>
800006d8:	30046073          	csrsi	mstatus,8
800006dc:	10500073          	wfi
800006e0:	0080006f          	j	800006e8 <fail>

800006e4 <test26>:
800006e4:	0100006f          	j	800006f4 <pass>

800006e8 <fail>:
800006e8:	f0100137          	lui	sp,0xf0100
800006ec:	f2410113          	addi	sp,sp,-220 # f00fff24 <strap+0x700ff7ec>
800006f0:	01c12023          	sw	t3,0(sp)

800006f4 <pass>:
800006f4:	f0100137          	lui	sp,0xf0100
800006f8:	f2010113          	addi	sp,sp,-224 # f00fff20 <strap+0x700ff7e8>
800006fc:	00012023          	sw	zero,0(sp)

80000700 <mtrap>:
80000700:	fe0e84e3          	beqz	t4,800006e8 <fail>
80000704:	342020f3          	csrr	ra,mcause
80000708:	341020f3          	csrr	ra,mepc
8000070c:	300020f3          	csrr	ra,mstatus
80000710:	343020f3          	csrr	ra,mtval
80000714:	08000093          	li	ra,128
80000718:	3000b073          	csrc	mstatus,ra
8000071c:	00200093          	li	ra,2
80000720:	fc1e8ae3          	beq	t4,ra,800006f4 <pass>
80000724:	000020b7          	lui	ra,0x2
80000728:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
8000072c:	3000a073          	csrs	mstatus,ra
80000730:	341f1073          	csrw	mepc,t5
80000734:	30200073          	mret

80000738 <strap>:
80000738:	fa0e88e3          	beqz	t4,800006e8 <fail>
8000073c:	142020f3          	csrr	ra,scause
80000740:	141020f3          	csrr	ra,sepc
80000744:	100020f3          	csrr	ra,sstatus
80000748:	143020f3          	csrr	ra,stval
8000074c:	00000073          	ecall
80000750:	00000013          	nop
80000754:	00000013          	nop
80000758:	00000013          	nop
8000075c:	00000013          	nop
80000760:	00000013          	nop
80000764:	00000013          	nop
