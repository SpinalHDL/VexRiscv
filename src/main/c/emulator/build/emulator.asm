
build/emulator.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00001117          	auipc	sp,0x1
80000004:	11010113          	addi	sp,sp,272 # 80001110 <_sp>
80000008:	00001517          	auipc	a0,0x1
8000000c:	86850513          	addi	a0,a0,-1944 # 80000870 <__init_array_end>
80000010:	00001597          	auipc	a1,0x1
80000014:	86058593          	addi	a1,a1,-1952 # 80000870 <__init_array_end>
80000018:	00001617          	auipc	a2,0x1
8000001c:	8f860613          	addi	a2,a2,-1800 # 80000910 <__bss_start>
80000020:	00c5fc63          	bgeu	a1,a2,80000038 <_start+0x38>
80000024:	00052283          	lw	t0,0(a0)
80000028:	0055a023          	sw	t0,0(a1)
8000002c:	00450513          	addi	a0,a0,4
80000030:	00458593          	addi	a1,a1,4
80000034:	fec5e8e3          	bltu	a1,a2,80000024 <_start+0x24>
80000038:	00001517          	auipc	a0,0x1
8000003c:	8d850513          	addi	a0,a0,-1832 # 80000910 <__bss_start>
80000040:	00001597          	auipc	a1,0x1
80000044:	8d058593          	addi	a1,a1,-1840 # 80000910 <__bss_start>
80000048:	00b57863          	bgeu	a0,a1,80000058 <_start+0x58>
8000004c:	00052023          	sw	zero,0(a0)
80000050:	00450513          	addi	a0,a0,4
80000054:	feb56ce3          	bltu	a0,a1,8000004c <_start+0x4c>
80000058:	770000ef          	jal	ra,800007c8 <__libc_init_array>
8000005c:	17c000ef          	jal	ra,800001d8 <init>
80000060:	00000097          	auipc	ra,0x0
80000064:	01408093          	addi	ra,ra,20 # 80000074 <done>
80000068:	00000513          	li	a0,0
8000006c:	c30005b7          	lui	a1,0xc3000
80000070:	30200073          	mret

80000074 <done>:
80000074:	0000006f          	j	80000074 <done>

80000078 <_init>:
80000078:	00008067          	ret

8000007c <trapEntry>:
8000007c:	34011173          	csrrw	sp,mscratch,sp
80000080:	00112223          	sw	ra,4(sp)
80000084:	00312623          	sw	gp,12(sp)
80000088:	00412823          	sw	tp,16(sp)
8000008c:	00512a23          	sw	t0,20(sp)
80000090:	00612c23          	sw	t1,24(sp)
80000094:	00712e23          	sw	t2,28(sp)
80000098:	02812023          	sw	s0,32(sp)
8000009c:	02912223          	sw	s1,36(sp)
800000a0:	02a12423          	sw	a0,40(sp)
800000a4:	02b12623          	sw	a1,44(sp)
800000a8:	02c12823          	sw	a2,48(sp)
800000ac:	02d12a23          	sw	a3,52(sp)
800000b0:	02e12c23          	sw	a4,56(sp)
800000b4:	02f12e23          	sw	a5,60(sp)
800000b8:	05012023          	sw	a6,64(sp)
800000bc:	05112223          	sw	a7,68(sp)
800000c0:	05212423          	sw	s2,72(sp)
800000c4:	05312623          	sw	s3,76(sp)
800000c8:	05412823          	sw	s4,80(sp)
800000cc:	05512a23          	sw	s5,84(sp)
800000d0:	05612c23          	sw	s6,88(sp)
800000d4:	05712e23          	sw	s7,92(sp)
800000d8:	07812023          	sw	s8,96(sp)
800000dc:	07912223          	sw	s9,100(sp)
800000e0:	07a12423          	sw	s10,104(sp)
800000e4:	07b12623          	sw	s11,108(sp)
800000e8:	07c12823          	sw	t3,112(sp)
800000ec:	07d12a23          	sw	t4,116(sp)
800000f0:	07e12c23          	sw	t5,120(sp)
800000f4:	07f12e23          	sw	t6,124(sp)
800000f8:	2c4000ef          	jal	ra,800003bc <trap>
800000fc:	00412083          	lw	ra,4(sp)
80000100:	00c12183          	lw	gp,12(sp)
80000104:	01012203          	lw	tp,16(sp)
80000108:	01412283          	lw	t0,20(sp)
8000010c:	01812303          	lw	t1,24(sp)
80000110:	01c12383          	lw	t2,28(sp)
80000114:	02012403          	lw	s0,32(sp)
80000118:	02412483          	lw	s1,36(sp)
8000011c:	02812503          	lw	a0,40(sp)
80000120:	02c12583          	lw	a1,44(sp)
80000124:	03012603          	lw	a2,48(sp)
80000128:	03412683          	lw	a3,52(sp)
8000012c:	03812703          	lw	a4,56(sp)
80000130:	03c12783          	lw	a5,60(sp)
80000134:	04012803          	lw	a6,64(sp)
80000138:	04412883          	lw	a7,68(sp)
8000013c:	04812903          	lw	s2,72(sp)
80000140:	04c12983          	lw	s3,76(sp)
80000144:	05012a03          	lw	s4,80(sp)
80000148:	05412a83          	lw	s5,84(sp)
8000014c:	05812b03          	lw	s6,88(sp)
80000150:	05c12b83          	lw	s7,92(sp)
80000154:	06012c03          	lw	s8,96(sp)
80000158:	06412c83          	lw	s9,100(sp)
8000015c:	06812d03          	lw	s10,104(sp)
80000160:	06c12d83          	lw	s11,108(sp)
80000164:	07012e03          	lw	t3,112(sp)
80000168:	07412e83          	lw	t4,116(sp)
8000016c:	07812f03          	lw	t5,120(sp)
80000170:	07c12f83          	lw	t6,124(sp)
80000174:	34011173          	csrrw	sp,mscratch,sp
80000178:	30200073          	mret

Disassembly of section .text:

8000017c <putString>:
8000017c:	ff010113          	addi	sp,sp,-16
80000180:	00812423          	sw	s0,8(sp)
80000184:	00112623          	sw	ra,12(sp)
80000188:	00050413          	mv	s0,a0
8000018c:	00054503          	lbu	a0,0(a0)
80000190:	00050a63          	beqz	a0,800001a4 <putString+0x28>
80000194:	00140413          	addi	s0,s0,1
80000198:	5f4000ef          	jal	ra,8000078c <putC>
8000019c:	00044503          	lbu	a0,0(s0)
800001a0:	fe051ae3          	bnez	a0,80000194 <putString+0x18>
800001a4:	00c12083          	lw	ra,12(sp)
800001a8:	00812403          	lw	s0,8(sp)
800001ac:	01010113          	addi	sp,sp,16
800001b0:	00008067          	ret

800001b4 <setup_pmp>:
800001b4:	01f00793          	li	a5,31
800001b8:	fff00713          	li	a4,-1
800001bc:	00000297          	auipc	t0,0x0
800001c0:	01428293          	addi	t0,t0,20 # 800001d0 <setup_pmp+0x1c>
800001c4:	305292f3          	csrrw	t0,mtvec,t0
800001c8:	3b071073          	csrw	pmpaddr0,a4
800001cc:	3a079073          	csrw	pmpcfg0,a5
800001d0:	30529073          	csrw	mtvec,t0
800001d4:	00008067          	ret

800001d8 <init>:
800001d8:	ff010113          	addi	sp,sp,-16
800001dc:	00112623          	sw	ra,12(sp)
800001e0:	00812423          	sw	s0,8(sp)
800001e4:	01f00793          	li	a5,31
800001e8:	fff00713          	li	a4,-1
800001ec:	00000297          	auipc	t0,0x0
800001f0:	01428293          	addi	t0,t0,20 # 80000200 <init+0x28>
800001f4:	305292f3          	csrrw	t0,mtvec,t0
800001f8:	3b071073          	csrw	pmpaddr0,a4
800001fc:	3a079073          	csrw	pmpcfg0,a5
80000200:	30529073          	csrw	mtvec,t0
80000204:	80001437          	lui	s0,0x80001
80000208:	5bc000ef          	jal	ra,800007c4 <halInit>
8000020c:	8e440413          	addi	s0,s0,-1820 # 800008e4 <_sp+0xfffff7d4>
80000210:	02a00513          	li	a0,42
80000214:	00140413          	addi	s0,s0,1
80000218:	574000ef          	jal	ra,8000078c <putC>
8000021c:	00044503          	lbu	a0,0(s0)
80000220:	fe051ae3          	bnez	a0,80000214 <init+0x3c>
80000224:	800007b7          	lui	a5,0x80000
80000228:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef6c>
8000022c:	30579073          	csrw	mtvec,a5
80000230:	800017b7          	lui	a5,0x80001
80000234:	09078793          	addi	a5,a5,144 # 80001090 <_sp+0xffffff80>
80000238:	34079073          	csrw	mscratch,a5
8000023c:	000017b7          	lui	a5,0x1
80000240:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
80000244:	30079073          	csrw	mstatus,a5
80000248:	30405073          	csrwi	mie,0
8000024c:	c00007b7          	lui	a5,0xc0000
80000250:	34179073          	csrw	mepc,a5
80000254:	0000b7b7          	lui	a5,0xb
80000258:	10078793          	addi	a5,a5,256 # b100 <__stack_size+0xa900>
8000025c:	30279073          	csrw	medeleg,a5
80000260:	22200793          	li	a5,546
80000264:	30379073          	csrw	mideleg,a5
80000268:	14305073          	csrwi	stval,0
8000026c:	80001437          	lui	s0,0x80001
80000270:	8fc40413          	addi	s0,s0,-1796 # 800008fc <_sp+0xfffff7ec>
80000274:	02a00513          	li	a0,42
80000278:	00140413          	addi	s0,s0,1
8000027c:	510000ef          	jal	ra,8000078c <putC>
80000280:	00044503          	lbu	a0,0(s0)
80000284:	fe051ae3          	bnez	a0,80000278 <init+0xa0>
80000288:	00c12083          	lw	ra,12(sp)
8000028c:	00812403          	lw	s0,8(sp)
80000290:	01010113          	addi	sp,sp,16
80000294:	00008067          	ret

80000298 <readRegister>:
80000298:	800017b7          	lui	a5,0x80001
8000029c:	09078793          	addi	a5,a5,144 # 80001090 <_sp+0xffffff80>
800002a0:	00251513          	slli	a0,a0,0x2
800002a4:	00f50533          	add	a0,a0,a5
800002a8:	00052503          	lw	a0,0(a0)
800002ac:	00008067          	ret

800002b0 <writeRegister>:
800002b0:	800017b7          	lui	a5,0x80001
800002b4:	00251513          	slli	a0,a0,0x2
800002b8:	09078793          	addi	a5,a5,144 # 80001090 <_sp+0xffffff80>
800002bc:	00f50533          	add	a0,a0,a5
800002c0:	00b52023          	sw	a1,0(a0)
800002c4:	00008067          	ret

800002c8 <redirectTrap>:
800002c8:	ff010113          	addi	sp,sp,-16
800002cc:	00112623          	sw	ra,12(sp)
800002d0:	4b4000ef          	jal	ra,80000784 <stopSim>
800002d4:	343027f3          	csrr	a5,mtval
800002d8:	14379073          	csrw	stval,a5
800002dc:	341027f3          	csrr	a5,mepc
800002e0:	14179073          	csrw	sepc,a5
800002e4:	342027f3          	csrr	a5,mcause
800002e8:	14279073          	csrw	scause,a5
800002ec:	105027f3          	csrr	a5,stvec
800002f0:	34179073          	csrw	mepc,a5
800002f4:	00c12083          	lw	ra,12(sp)
800002f8:	01010113          	addi	sp,sp,16
800002fc:	00008067          	ret

80000300 <emulationTrapToSupervisorTrap>:
80000300:	800007b7          	lui	a5,0x80000
80000304:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef6c>
80000308:	30579073          	csrw	mtvec,a5
8000030c:	343027f3          	csrr	a5,mtval
80000310:	14379073          	csrw	stval,a5
80000314:	342027f3          	csrr	a5,mcause
80000318:	14279073          	csrw	scause,a5
8000031c:	14151073          	csrw	sepc,a0
80000320:	105027f3          	csrr	a5,stvec
80000324:	34179073          	csrw	mepc,a5
80000328:	10000793          	li	a5,256
8000032c:	1007b073          	csrc	sstatus,a5
80000330:	0035d593          	srli	a1,a1,0x3
80000334:	1005f593          	andi	a1,a1,256
80000338:	1005a073          	csrs	sstatus,a1
8000033c:	000027b7          	lui	a5,0x2
80000340:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
80000344:	3007b073          	csrc	mstatus,a5
80000348:	000017b7          	lui	a5,0x1
8000034c:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
80000350:	3007a073          	csrs	mstatus,a5
80000354:	00008067          	ret

80000358 <readWord>:
80000358:	00020737          	lui	a4,0x20
8000035c:	30072073          	csrs	mstatus,a4
80000360:	00000717          	auipc	a4,0x0
80000364:	01870713          	addi	a4,a4,24 # 80000378 <readWord+0x20>
80000368:	30571073          	csrw	mtvec,a4
8000036c:	00100693          	li	a3,1
80000370:	00052783          	lw	a5,0(a0)
80000374:	00000693          	li	a3,0
80000378:	00020737          	lui	a4,0x20
8000037c:	30073073          	csrc	mstatus,a4
80000380:	00068513          	mv	a0,a3
80000384:	00f5a023          	sw	a5,0(a1) # c3000000 <_sp+0x42ffeef0>
80000388:	00008067          	ret

8000038c <writeWord>:
8000038c:	00020737          	lui	a4,0x20
80000390:	30072073          	csrs	mstatus,a4
80000394:	00000717          	auipc	a4,0x0
80000398:	01870713          	addi	a4,a4,24 # 800003ac <writeWord+0x20>
8000039c:	30571073          	csrw	mtvec,a4
800003a0:	00100793          	li	a5,1
800003a4:	00b52023          	sw	a1,0(a0)
800003a8:	00000793          	li	a5,0
800003ac:	00020737          	lui	a4,0x20
800003b0:	30073073          	csrc	mstatus,a4
800003b4:	00078513          	mv	a0,a5
800003b8:	00008067          	ret

800003bc <trap>:
800003bc:	fe010113          	addi	sp,sp,-32
800003c0:	00112e23          	sw	ra,28(sp)
800003c4:	00812c23          	sw	s0,24(sp)
800003c8:	00912a23          	sw	s1,20(sp)
800003cc:	01212823          	sw	s2,16(sp)
800003d0:	01312623          	sw	s3,12(sp)
800003d4:	342027f3          	csrr	a5,mcause
800003d8:	0807cc63          	bltz	a5,80000470 <trap+0xb4>
800003dc:	00200713          	li	a4,2
800003e0:	0ce78463          	beq	a5,a4,800004a8 <trap+0xec>
800003e4:	00900693          	li	a3,9
800003e8:	04d79463          	bne	a5,a3,80000430 <trap+0x74>
800003ec:	80001437          	lui	s0,0x80001
800003f0:	11040413          	addi	s0,s0,272 # 80001110 <_sp+0x0>
800003f4:	fc442783          	lw	a5,-60(s0)
800003f8:	00100693          	li	a3,1
800003fc:	fa842503          	lw	a0,-88(s0)
80000400:	2ed78663          	beq	a5,a3,800006ec <trap+0x330>
80000404:	2ae78463          	beq	a5,a4,800006ac <trap+0x2f0>
80000408:	2a078e63          	beqz	a5,800006c4 <trap+0x308>
8000040c:	01812403          	lw	s0,24(sp)
80000410:	01c12083          	lw	ra,28(sp)
80000414:	01412483          	lw	s1,20(sp)
80000418:	01012903          	lw	s2,16(sp)
8000041c:	00c12983          	lw	s3,12(sp)
80000420:	02010113          	addi	sp,sp,32
80000424:	3600006f          	j	80000784 <stopSim>
80000428:	00777713          	andi	a4,a4,7
8000042c:	14f70063          	beq	a4,a5,8000056c <trap+0x1b0>
80000430:	354000ef          	jal	ra,80000784 <stopSim>
80000434:	343027f3          	csrr	a5,mtval
80000438:	14379073          	csrw	stval,a5
8000043c:	341027f3          	csrr	a5,mepc
80000440:	14179073          	csrw	sepc,a5
80000444:	342027f3          	csrr	a5,mcause
80000448:	14279073          	csrw	scause,a5
8000044c:	105027f3          	csrr	a5,stvec
80000450:	34179073          	csrw	mepc,a5
80000454:	01c12083          	lw	ra,28(sp)
80000458:	01812403          	lw	s0,24(sp)
8000045c:	01412483          	lw	s1,20(sp)
80000460:	01012903          	lw	s2,16(sp)
80000464:	00c12983          	lw	s3,12(sp)
80000468:	02010113          	addi	sp,sp,32
8000046c:	00008067          	ret
80000470:	0ff7f793          	andi	a5,a5,255
80000474:	00700713          	li	a4,7
80000478:	fae79ce3          	bne	a5,a4,80000430 <trap+0x74>
8000047c:	02000793          	li	a5,32
80000480:	1447a073          	csrs	sip,a5
80000484:	08000793          	li	a5,128
80000488:	3047b073          	csrc	mie,a5
8000048c:	01c12083          	lw	ra,28(sp)
80000490:	01812403          	lw	s0,24(sp)
80000494:	01412483          	lw	s1,20(sp)
80000498:	01012903          	lw	s2,16(sp)
8000049c:	00c12983          	lw	s3,12(sp)
800004a0:	02010113          	addi	sp,sp,32
800004a4:	00008067          	ret
800004a8:	341024f3          	csrr	s1,mepc
800004ac:	300025f3          	csrr	a1,mstatus
800004b0:	34302473          	csrr	s0,mtval
800004b4:	02f00613          	li	a2,47
800004b8:	07f47693          	andi	a3,s0,127
800004bc:	00c45713          	srli	a4,s0,0xc
800004c0:	f6c684e3          	beq	a3,a2,80000428 <trap+0x6c>
800004c4:	07300613          	li	a2,115
800004c8:	f6c694e3          	bne	a3,a2,80000430 <trap+0x74>
800004cc:	00377713          	andi	a4,a4,3
800004d0:	12f70063          	beq	a4,a5,800005f0 <trap+0x234>
800004d4:	00300793          	li	a5,3
800004d8:	10f70c63          	beq	a4,a5,800005f0 <trap+0x234>
800004dc:	00100993          	li	s3,1
800004e0:	03370463          	beq	a4,s3,80000508 <trap+0x14c>
800004e4:	2a0000ef          	jal	ra,80000784 <stopSim>
800004e8:	343027f3          	csrr	a5,mtval
800004ec:	14379073          	csrw	stval,a5
800004f0:	341027f3          	csrr	a5,mepc
800004f4:	14179073          	csrw	sepc,a5
800004f8:	342027f3          	csrr	a5,mcause
800004fc:	14279073          	csrw	scause,a5
80000500:	105027f3          	csrr	a5,stvec
80000504:	34179073          	csrw	mepc,a5
80000508:	000017b7          	lui	a5,0x1
8000050c:	01445713          	srli	a4,s0,0x14
80000510:	c0178693          	addi	a3,a5,-1023 # c01 <__stack_size+0x401>
80000514:	0ed70663          	beq	a4,a3,80000600 <trap+0x244>
80000518:	c8178793          	addi	a5,a5,-895
8000051c:	0cf70463          	beq	a4,a5,800005e4 <trap+0x228>
80000520:	264000ef          	jal	ra,80000784 <stopSim>
80000524:	343027f3          	csrr	a5,mtval
80000528:	14379073          	csrw	stval,a5
8000052c:	341027f3          	csrr	a5,mepc
80000530:	14179073          	csrw	sepc,a5
80000534:	342027f3          	csrr	a5,mcause
80000538:	14279073          	csrw	scause,a5
8000053c:	105027f3          	csrr	a5,stvec
80000540:	34179073          	csrw	mepc,a5
80000544:	1c099063          	bnez	s3,80000704 <trap+0x348>
80000548:	00545413          	srli	s0,s0,0x5
8000054c:	800017b7          	lui	a5,0x80001
80000550:	09078793          	addi	a5,a5,144 # 80001090 <_sp+0xffffff80>
80000554:	07c47413          	andi	s0,s0,124
80000558:	00f40433          	add	s0,s0,a5
8000055c:	01242023          	sw	s2,0(s0)
80000560:	00448493          	addi	s1,s1,4
80000564:	34149073          	csrw	mepc,s1
80000568:	eedff06f          	j	80000454 <trap+0x98>
8000056c:	00d45713          	srli	a4,s0,0xd
80000570:	01245793          	srli	a5,s0,0x12
80000574:	800016b7          	lui	a3,0x80001
80000578:	09068693          	addi	a3,a3,144 # 80001090 <_sp+0xffffff80>
8000057c:	07c77713          	andi	a4,a4,124
80000580:	07c7f793          	andi	a5,a5,124
80000584:	00d70733          	add	a4,a4,a3
80000588:	00d787b3          	add	a5,a5,a3
8000058c:	00072703          	lw	a4,0(a4) # 20000 <__stack_size+0x1f800>
80000590:	0007a603          	lw	a2,0(a5)
80000594:	00020537          	lui	a0,0x20
80000598:	30052073          	csrs	mstatus,a0
8000059c:	00000517          	auipc	a0,0x0
800005a0:	01850513          	addi	a0,a0,24 # 800005b4 <trap+0x1f8>
800005a4:	30551073          	csrw	mtvec,a0
800005a8:	00100793          	li	a5,1
800005ac:	00072803          	lw	a6,0(a4)
800005b0:	00000793          	li	a5,0
800005b4:	00020537          	lui	a0,0x20
800005b8:	30053073          	csrc	mstatus,a0
800005bc:	16079863          	bnez	a5,8000072c <trap+0x370>
800005c0:	01b45793          	srli	a5,s0,0x1b
800005c4:	01c00513          	li	a0,28
800005c8:	e6f564e3          	bltu	a0,a5,80000430 <trap+0x74>
800005cc:	80001537          	lui	a0,0x80001
800005d0:	00279793          	slli	a5,a5,0x2
800005d4:	87050513          	addi	a0,a0,-1936 # 80000870 <_sp+0xfffff760>
800005d8:	00a787b3          	add	a5,a5,a0
800005dc:	0007a783          	lw	a5,0(a5)
800005e0:	00078067          	jr	a5
800005e4:	1c0000ef          	jal	ra,800007a4 <rdtimeh>
800005e8:	00050913          	mv	s2,a0
800005ec:	f59ff06f          	j	80000544 <trap+0x188>
800005f0:	00f45993          	srli	s3,s0,0xf
800005f4:	01f9f993          	andi	s3,s3,31
800005f8:	013039b3          	snez	s3,s3
800005fc:	f0dff06f          	j	80000508 <trap+0x14c>
80000600:	19c000ef          	jal	ra,8000079c <rdtime>
80000604:	00050913          	mv	s2,a0
80000608:	f3dff06f          	j	80000544 <trap+0x188>
8000060c:	01067463          	bgeu	a2,a6,80000614 <trap+0x258>
80000610:	00080613          	mv	a2,a6
80000614:	00545413          	srli	s0,s0,0x5
80000618:	07c47413          	andi	s0,s0,124
8000061c:	00d406b3          	add	a3,s0,a3
80000620:	0106a023          	sw	a6,0(a3)
80000624:	000207b7          	lui	a5,0x20
80000628:	3007a073          	csrs	mstatus,a5
8000062c:	00000797          	auipc	a5,0x0
80000630:	01878793          	addi	a5,a5,24 # 80000644 <trap+0x288>
80000634:	30579073          	csrw	mtvec,a5
80000638:	00100693          	li	a3,1
8000063c:	00c72023          	sw	a2,0(a4)
80000640:	00000693          	li	a3,0
80000644:	000207b7          	lui	a5,0x20
80000648:	3007b073          	csrc	mstatus,a5
8000064c:	800007b7          	lui	a5,0x80000
80000650:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef6c>
80000654:	0e069063          	bnez	a3,80000734 <trap+0x378>
80000658:	00448493          	addi	s1,s1,4
8000065c:	34149073          	csrw	mepc,s1
80000660:	30579073          	csrw	mtvec,a5
80000664:	df1ff06f          	j	80000454 <trap+0x98>
80000668:	01064633          	xor	a2,a2,a6
8000066c:	fa9ff06f          	j	80000614 <trap+0x258>
80000670:	01060633          	add	a2,a2,a6
80000674:	fa1ff06f          	j	80000614 <trap+0x258>
80000678:	01067633          	and	a2,a2,a6
8000067c:	f99ff06f          	j	80000614 <trap+0x258>
80000680:	01066633          	or	a2,a2,a6
80000684:	f91ff06f          	j	80000614 <trap+0x258>
80000688:	f8c876e3          	bgeu	a6,a2,80000614 <trap+0x258>
8000068c:	00080613          	mv	a2,a6
80000690:	f85ff06f          	j	80000614 <trap+0x258>
80000694:	f90650e3          	bge	a2,a6,80000614 <trap+0x258>
80000698:	00080613          	mv	a2,a6
8000069c:	f79ff06f          	j	80000614 <trap+0x258>
800006a0:	f6c85ae3          	bge	a6,a2,80000614 <trap+0x258>
800006a4:	00080613          	mv	a2,a6
800006a8:	f6dff06f          	j	80000614 <trap+0x258>
800006ac:	0e8000ef          	jal	ra,80000794 <getC>
800006b0:	faa42423          	sw	a0,-88(s0)
800006b4:	341027f3          	csrr	a5,mepc
800006b8:	00478793          	addi	a5,a5,4
800006bc:	34179073          	csrw	mepc,a5
800006c0:	d95ff06f          	j	80000454 <trap+0x98>
800006c4:	fac42583          	lw	a1,-84(s0)
800006c8:	0e4000ef          	jal	ra,800007ac <setMachineTimerCmp>
800006cc:	08000793          	li	a5,128
800006d0:	3047a073          	csrs	mie,a5
800006d4:	02000793          	li	a5,32
800006d8:	1447b073          	csrc	sip,a5
800006dc:	341027f3          	csrr	a5,mepc
800006e0:	00478793          	addi	a5,a5,4
800006e4:	34179073          	csrw	mepc,a5
800006e8:	d6dff06f          	j	80000454 <trap+0x98>
800006ec:	0ff57513          	andi	a0,a0,255
800006f0:	09c000ef          	jal	ra,8000078c <putC>
800006f4:	341027f3          	csrr	a5,mepc
800006f8:	00478793          	addi	a5,a5,4
800006fc:	34179073          	csrw	mepc,a5
80000700:	d55ff06f          	j	80000454 <trap+0x98>
80000704:	080000ef          	jal	ra,80000784 <stopSim>
80000708:	343027f3          	csrr	a5,mtval
8000070c:	14379073          	csrw	stval,a5
80000710:	341027f3          	csrr	a5,mepc
80000714:	14179073          	csrw	sepc,a5
80000718:	342027f3          	csrr	a5,mcause
8000071c:	14279073          	csrw	scause,a5
80000720:	105027f3          	csrr	a5,stvec
80000724:	34179073          	csrw	mepc,a5
80000728:	e21ff06f          	j	80000548 <trap+0x18c>
8000072c:	800007b7          	lui	a5,0x80000
80000730:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef6c>
80000734:	30579073          	csrw	mtvec,a5
80000738:	343027f3          	csrr	a5,mtval
8000073c:	14379073          	csrw	stval,a5
80000740:	342027f3          	csrr	a5,mcause
80000744:	14279073          	csrw	scause,a5
80000748:	14149073          	csrw	sepc,s1
8000074c:	105027f3          	csrr	a5,stvec
80000750:	34179073          	csrw	mepc,a5
80000754:	10000793          	li	a5,256
80000758:	1007b073          	csrc	sstatus,a5
8000075c:	0035d793          	srli	a5,a1,0x3
80000760:	1007f793          	andi	a5,a5,256
80000764:	1007a073          	csrs	sstatus,a5
80000768:	000027b7          	lui	a5,0x2
8000076c:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
80000770:	3007b073          	csrc	mstatus,a5
80000774:	000017b7          	lui	a5,0x1
80000778:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
8000077c:	3007a073          	csrs	mstatus,a5
80000780:	cd5ff06f          	j	80000454 <trap+0x98>

80000784 <stopSim>:
80000784:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7fffeeec>
80000788:	0000006f          	j	80000788 <stopSim+0x4>

8000078c <putC>:
8000078c:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7fffeee8>
80000790:	00008067          	ret

80000794 <getC>:
80000794:	ff802503          	lw	a0,-8(zero) # fffffff8 <_sp+0x7fffeee8>
80000798:	00008067          	ret

8000079c <rdtime>:
8000079c:	fe002503          	lw	a0,-32(zero) # ffffffe0 <_sp+0x7fffeed0>
800007a0:	00008067          	ret

800007a4 <rdtimeh>:
800007a4:	fe402503          	lw	a0,-28(zero) # ffffffe4 <_sp+0x7fffeed4>
800007a8:	00008067          	ret

800007ac <setMachineTimerCmp>:
800007ac:	fec00793          	li	a5,-20
800007b0:	fff00713          	li	a4,-1
800007b4:	00e7a023          	sw	a4,0(a5)
800007b8:	fea02423          	sw	a0,-24(zero) # ffffffe8 <_sp+0x7fffeed8>
800007bc:	00b7a023          	sw	a1,0(a5)
800007c0:	00008067          	ret

800007c4 <halInit>:
800007c4:	00008067          	ret

800007c8 <__libc_init_array>:
800007c8:	ff010113          	addi	sp,sp,-16
800007cc:	00000797          	auipc	a5,0x0
800007d0:	0a478793          	addi	a5,a5,164 # 80000870 <__init_array_end>
800007d4:	00812423          	sw	s0,8(sp)
800007d8:	00000417          	auipc	s0,0x0
800007dc:	09840413          	addi	s0,s0,152 # 80000870 <__init_array_end>
800007e0:	40f40433          	sub	s0,s0,a5
800007e4:	00912223          	sw	s1,4(sp)
800007e8:	01212023          	sw	s2,0(sp)
800007ec:	00112623          	sw	ra,12(sp)
800007f0:	40245413          	srai	s0,s0,0x2
800007f4:	00000493          	li	s1,0
800007f8:	00078913          	mv	s2,a5
800007fc:	04849263          	bne	s1,s0,80000840 <__libc_init_array+0x78>
80000800:	879ff0ef          	jal	ra,80000078 <_init>
80000804:	00000797          	auipc	a5,0x0
80000808:	06c78793          	addi	a5,a5,108 # 80000870 <__init_array_end>
8000080c:	00000417          	auipc	s0,0x0
80000810:	06440413          	addi	s0,s0,100 # 80000870 <__init_array_end>
80000814:	40f40433          	sub	s0,s0,a5
80000818:	40245413          	srai	s0,s0,0x2
8000081c:	00000493          	li	s1,0
80000820:	00078913          	mv	s2,a5
80000824:	02849a63          	bne	s1,s0,80000858 <__libc_init_array+0x90>
80000828:	00c12083          	lw	ra,12(sp)
8000082c:	00812403          	lw	s0,8(sp)
80000830:	00412483          	lw	s1,4(sp)
80000834:	00012903          	lw	s2,0(sp)
80000838:	01010113          	addi	sp,sp,16
8000083c:	00008067          	ret
80000840:	00249793          	slli	a5,s1,0x2
80000844:	00f907b3          	add	a5,s2,a5
80000848:	0007a783          	lw	a5,0(a5)
8000084c:	00148493          	addi	s1,s1,1
80000850:	000780e7          	jalr	a5
80000854:	fa9ff06f          	j	800007fc <__libc_init_array+0x34>
80000858:	00249793          	slli	a5,s1,0x2
8000085c:	00f907b3          	add	a5,s2,a5
80000860:	0007a783          	lw	a5,0(a5)
80000864:	00148493          	addi	s1,s1,1
80000868:	000780e7          	jalr	a5
8000086c:	fb9ff06f          	j	80000824 <__libc_init_array+0x5c>
