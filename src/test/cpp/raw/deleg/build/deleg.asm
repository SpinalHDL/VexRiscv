
build/deleg.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00100e93          	li	t4,1
80000004:	00000097          	auipc	ra,0x0
80000008:	50408093          	addi	ra,ra,1284 # 80000508 <mtrap>
8000000c:	30509073          	csrw	mtvec,ra
80000010:	00000097          	auipc	ra,0x0
80000014:	52c08093          	addi	ra,ra,1324 # 8000053c <strap>
80000018:	10509073          	csrw	stvec,ra
8000001c:	f00110b7          	lui	ra,0xf0011
80000020:	00000113          	li	sp,0
80000024:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>

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
80000060:	4900006f          	j	800004f0 <fail>
80000064:	00000f17          	auipc	t5,0x0
80000068:	024f0f13          	addi	t5,t5,36 # 80000088 <test4>
8000006c:	00000073          	ecall
80000070:	4800006f          	j	800004f0 <fail>

80000074 <test3>:
80000074:	00300e13          	li	t3,3
80000078:	00000f17          	auipc	t5,0x0
8000007c:	010f0f13          	addi	t5,t5,16 # 80000088 <test4>
80000080:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000084:	46c0006f          	j	800004f0 <fail>

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
800000b4:	43c0006f          	j	800004f0 <fail>
800000b8:	00000f17          	auipc	t5,0x0
800000bc:	010f0f13          	addi	t5,t5,16 # 800000c8 <test5>
800000c0:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
800000c4:	42c0006f          	j	800004f0 <fail>

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
800000f0:	4000006f          	j	800004f0 <fail>
800000f4:	00000f17          	auipc	t5,0x0
800000f8:	010f0f13          	addi	t5,t5,16 # 80000104 <test6>
800000fc:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000100:	3f00006f          	j	800004f0 <fail>

80000104 <test6>:
80000104:	00600e13          	li	t3,6
80000108:	01000093          	li	ra,16
8000010c:	30209073          	csrw	medeleg,ra

80000110 <test7>:
80000110:	00700e13          	li	t3,7
80000114:	00000f17          	auipc	t5,0x0
80000118:	010f0f13          	addi	t5,t5,16 # 80000124 <test8>
8000011c:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000120:	3d00006f          	j	800004f0 <fail>

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
80000158:	3980006f          	j	800004f0 <fail>
8000015c:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
80000160:	3900006f          	j	800004f0 <fail>

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
80000194:	35c0006f          	j	800004f0 <fail>
80000198:	00102083          	lw	ra,1(zero) # 1 <_start-0x7fffffff>
8000019c:	3540006f          	j	800004f0 <fail>

800001a0 <test10>:
800001a0:	00a00e13          	li	t3,10
800001a4:	00000f17          	auipc	t5,0x0
800001a8:	03cf0f13          	addi	t5,t5,60 # 800001e0 <test11>
800001ac:	f00110b7          	lui	ra,0xf0011
800001b0:	00000113          	li	sp,0
800001b4:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>
800001b8:	00800093          	li	ra,8
800001bc:	30009073          	csrw	mstatus,ra
800001c0:	000010b7          	lui	ra,0x1
800001c4:	80008093          	addi	ra,ra,-2048 # 800 <_start-0x7ffff800>
800001c8:	30409073          	csrw	mie,ra
800001cc:	f00110b7          	lui	ra,0xf0011
800001d0:	00100113          	li	sp,1
800001d4:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>
800001d8:	10500073          	wfi
800001dc:	3140006f          	j	800004f0 <fail>

800001e0 <test11>:
800001e0:	00b00e13          	li	t3,11
800001e4:	00000f17          	auipc	t5,0x0
800001e8:	068f0f13          	addi	t5,t5,104 # 8000024c <test12>
800001ec:	f00110b7          	lui	ra,0xf0011
800001f0:	00000113          	li	sp,0
800001f4:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>
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
80000234:	2bc0006f          	j	800004f0 <fail>
80000238:	f00110b7          	lui	ra,0xf0011
8000023c:	00100113          	li	sp,1
80000240:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>
80000244:	10500073          	wfi
80000248:	2a80006f          	j	800004f0 <fail>

8000024c <test12>:
8000024c:	00c00e13          	li	t3,12
80000250:	00000f17          	auipc	t5,0x0
80000254:	064f0f13          	addi	t5,t5,100 # 800002b4 <test14>
80000258:	f00110b7          	lui	ra,0xf0011
8000025c:	00000113          	li	sp,0
80000260:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>
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
8000029c:	2540006f          	j	800004f0 <fail>
800002a0:	f00110b7          	lui	ra,0xf0011
800002a4:	00100113          	li	sp,1
800002a8:	0020a023          	sw	sp,0(ra) # f0011000 <strap+0x70010ac4>
800002ac:	10500073          	wfi
800002b0:	2400006f          	j	800004f0 <fail>

800002b4 <test14>:
800002b4:	00200093          	li	ra,2
800002b8:	10009073          	csrw	sstatus,ra
800002bc:	00e00e13          	li	t3,14
800002c0:	00000f17          	auipc	t5,0x0
800002c4:	040f0f13          	addi	t5,t5,64 # 80000300 <test15>
800002c8:	f00120b7          	lui	ra,0xf0012
800002cc:	00000113          	li	sp,0
800002d0:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
800002d4:	00200093          	li	ra,2
800002d8:	30009073          	csrw	mstatus,ra
800002dc:	20000093          	li	ra,512
800002e0:	30409073          	csrw	mie,ra
800002e4:	00000e93          	li	t4,0
800002e8:	f00120b7          	lui	ra,0xf0012
800002ec:	00100113          	li	sp,1
800002f0:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
800002f4:	06400093          	li	ra,100
800002f8:	fff08093          	addi	ra,ra,-1
800002fc:	fe104ee3          	bgtz	ra,800002f8 <test14+0x44>

80000300 <test15>:
80000300:	00f00e13          	li	t3,15
80000304:	00000f17          	auipc	t5,0x0
80000308:	068f0f13          	addi	t5,t5,104 # 8000036c <test16>
8000030c:	f00120b7          	lui	ra,0xf0012
80000310:	00000113          	li	sp,0
80000314:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
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
80000350:	1a00006f          	j	800004f0 <fail>
80000354:	00100e93          	li	t4,1
80000358:	f00120b7          	lui	ra,0xf0012
8000035c:	00100113          	li	sp,1
80000360:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
80000364:	10500073          	wfi
80000368:	1880006f          	j	800004f0 <fail>

8000036c <test16>:
8000036c:	01000e13          	li	t3,16
80000370:	00000f17          	auipc	t5,0x0
80000374:	060f0f13          	addi	t5,t5,96 # 800003d0 <test17>
80000378:	f00120b7          	lui	ra,0xf0012
8000037c:	00000113          	li	sp,0
80000380:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
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
800003b8:	1380006f          	j	800004f0 <fail>
800003bc:	f00120b7          	lui	ra,0xf0012
800003c0:	00100113          	li	sp,1
800003c4:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
800003c8:	10500073          	wfi
800003cc:	1240006f          	j	800004f0 <fail>

800003d0 <test17>:
800003d0:	01100e13          	li	t3,17
800003d4:	20000093          	li	ra,512
800003d8:	30309073          	csrw	mideleg,ra
800003dc:	00000f17          	auipc	t5,0x0
800003e0:	040f0f13          	addi	t5,t5,64 # 8000041c <test18>
800003e4:	f00120b7          	lui	ra,0xf0012
800003e8:	00000113          	li	sp,0
800003ec:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
800003f0:	00200093          	li	ra,2
800003f4:	30009073          	csrw	mstatus,ra
800003f8:	20000093          	li	ra,512
800003fc:	30409073          	csrw	mie,ra
80000400:	00000e93          	li	t4,0
80000404:	f00120b7          	lui	ra,0xf0012
80000408:	00100113          	li	sp,1
8000040c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
80000410:	06400093          	li	ra,100
80000414:	fff08093          	addi	ra,ra,-1
80000418:	fe104ee3          	bgtz	ra,80000414 <test17+0x44>

8000041c <test18>:
8000041c:	01200e13          	li	t3,18
80000420:	00000f17          	auipc	t5,0x0
80000424:	068f0f13          	addi	t5,t5,104 # 80000488 <test19>
80000428:	f00120b7          	lui	ra,0xf0012
8000042c:	00000113          	li	sp,0
80000430:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
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
8000046c:	0840006f          	j	800004f0 <fail>
80000470:	00100e93          	li	t4,1
80000474:	f00120b7          	lui	ra,0xf0012
80000478:	00100113          	li	sp,1
8000047c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
80000480:	10500073          	wfi
80000484:	06c0006f          	j	800004f0 <fail>

80000488 <test19>:
80000488:	01300e13          	li	t3,19
8000048c:	00000f17          	auipc	t5,0x0
80000490:	060f0f13          	addi	t5,t5,96 # 800004ec <test20>
80000494:	f00120b7          	lui	ra,0xf0012
80000498:	00000113          	li	sp,0
8000049c:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
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
800004d4:	01c0006f          	j	800004f0 <fail>
800004d8:	f00120b7          	lui	ra,0xf0012
800004dc:	00100113          	li	sp,1
800004e0:	0020a023          	sw	sp,0(ra) # f0012000 <strap+0x70011ac4>
800004e4:	10500073          	wfi
800004e8:	0080006f          	j	800004f0 <fail>

800004ec <test20>:
800004ec:	0100006f          	j	800004fc <pass>

800004f0 <fail>:
800004f0:	f0100137          	lui	sp,0xf0100
800004f4:	f2410113          	addi	sp,sp,-220 # f00fff24 <strap+0x700ff9e8>
800004f8:	01c12023          	sw	t3,0(sp)

800004fc <pass>:
800004fc:	f0100137          	lui	sp,0xf0100
80000500:	f2010113          	addi	sp,sp,-224 # f00fff20 <strap+0x700ff9e4>
80000504:	00012023          	sw	zero,0(sp)

80000508 <mtrap>:
80000508:	fe0e84e3          	beqz	t4,800004f0 <fail>
8000050c:	342020f3          	csrr	ra,mcause
80000510:	341020f3          	csrr	ra,mepc
80000514:	300020f3          	csrr	ra,mstatus
80000518:	08000093          	li	ra,128
8000051c:	3000b073          	csrc	mstatus,ra
80000520:	00200093          	li	ra,2
80000524:	fc1e8ce3          	beq	t4,ra,800004fc <pass>
80000528:	000020b7          	lui	ra,0x2
8000052c:	80008093          	addi	ra,ra,-2048 # 1800 <_start-0x7fffe800>
80000530:	3000a073          	csrs	mstatus,ra
80000534:	341f1073          	csrw	mepc,t5
80000538:	30200073          	mret

8000053c <strap>:
8000053c:	fa0e8ae3          	beqz	t4,800004f0 <fail>
80000540:	142020f3          	csrr	ra,scause
80000544:	141020f3          	csrr	ra,sepc
80000548:	100020f3          	csrr	ra,sstatus
8000054c:	00000073          	ecall
80000550:	00000013          	nop
80000554:	00000013          	nop
80000558:	00000013          	nop
8000055c:	00000013          	nop
80000560:	00000013          	nop
80000564:	00000013          	nop
