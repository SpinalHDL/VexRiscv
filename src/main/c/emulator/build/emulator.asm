
build/emulator.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00001117          	auipc	sp,0x1
80000004:	00810113          	addi	sp,sp,8 # 80001008 <_sp>
80000008:	00000517          	auipc	a0,0x0
8000000c:	78c50513          	addi	a0,a0,1932 # 80000794 <__init_array_end>
80000010:	00000597          	auipc	a1,0x0
80000014:	78458593          	addi	a1,a1,1924 # 80000794 <__init_array_end>
80000018:	00000617          	auipc	a2,0x0
8000001c:	7f060613          	addi	a2,a2,2032 # 80000808 <__bss_start>
80000020:	00c5fc63          	bgeu	a1,a2,80000038 <_start+0x38>
80000024:	00052283          	lw	t0,0(a0)
80000028:	0055a023          	sw	t0,0(a1)
8000002c:	00450513          	addi	a0,a0,4
80000030:	00458593          	addi	a1,a1,4
80000034:	fec5e8e3          	bltu	a1,a2,80000024 <_start+0x24>
80000038:	00000517          	auipc	a0,0x0
8000003c:	7d050513          	addi	a0,a0,2000 # 80000808 <__bss_start>
80000040:	00000597          	auipc	a1,0x0
80000044:	7c858593          	addi	a1,a1,1992 # 80000808 <__bss_start>
80000048:	00b57863          	bgeu	a0,a1,80000058 <_start+0x58>
8000004c:	00052023          	sw	zero,0(a0)
80000050:	00450513          	addi	a0,a0,4
80000054:	feb56ce3          	bltu	a0,a1,8000004c <_start+0x4c>
80000058:	694000ef          	jal	ra,800006ec <__libc_init_array>
8000005c:	120000ef          	jal	ra,8000017c <init>
80000060:	00000097          	auipc	ra,0x0
80000064:	01408093          	addi	ra,ra,20 # 80000074 <done>
80000068:	00000513          	li	a0,0
8000006c:	810005b7          	lui	a1,0x81000
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
800000f8:	1f4000ef          	jal	ra,800002ec <trap>
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

8000017c <init>:
8000017c:	800007b7          	lui	a5,0x80000
80000180:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff074>
80000184:	30579073          	csrw	mtvec,a5
80000188:	800017b7          	lui	a5,0x80001
8000018c:	f8878793          	addi	a5,a5,-120 # 80000f88 <_sp+0xffffff80>
80000190:	34079073          	csrw	mscratch,a5
80000194:	000017b7          	lui	a5,0x1
80000198:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
8000019c:	30079073          	csrw	mstatus,a5
800001a0:	30405073          	csrwi	mie,0
800001a4:	c00007b7          	lui	a5,0xc0000
800001a8:	34179073          	csrw	mepc,a5
800001ac:	0000b7b7          	lui	a5,0xb
800001b0:	10078793          	addi	a5,a5,256 # b100 <__stack_size+0xa900>
800001b4:	30279073          	csrw	medeleg,a5
800001b8:	22200793          	li	a5,546
800001bc:	30379073          	csrw	mideleg,a5
800001c0:	14305073          	csrwi	stval,0
800001c4:	00008067          	ret

800001c8 <readRegister>:
800001c8:	800017b7          	lui	a5,0x80001
800001cc:	f8878793          	addi	a5,a5,-120 # 80000f88 <_sp+0xffffff80>
800001d0:	00251513          	slli	a0,a0,0x2
800001d4:	00f50533          	add	a0,a0,a5
800001d8:	00052503          	lw	a0,0(a0)
800001dc:	00008067          	ret

800001e0 <writeRegister>:
800001e0:	800017b7          	lui	a5,0x80001
800001e4:	00251513          	slli	a0,a0,0x2
800001e8:	f8878793          	addi	a5,a5,-120 # 80000f88 <_sp+0xffffff80>
800001ec:	00f50533          	add	a0,a0,a5
800001f0:	00b52023          	sw	a1,0(a0)
800001f4:	00008067          	ret

800001f8 <redirectTrap>:
800001f8:	ff010113          	addi	sp,sp,-16
800001fc:	00112623          	sw	ra,12(sp)
80000200:	4b4000ef          	jal	ra,800006b4 <stopSim>
80000204:	343027f3          	csrr	a5,mtval
80000208:	14379073          	csrw	stval,a5
8000020c:	341027f3          	csrr	a5,mepc
80000210:	14179073          	csrw	sepc,a5
80000214:	342027f3          	csrr	a5,mcause
80000218:	14279073          	csrw	scause,a5
8000021c:	105027f3          	csrr	a5,stvec
80000220:	34179073          	csrw	mepc,a5
80000224:	00c12083          	lw	ra,12(sp)
80000228:	01010113          	addi	sp,sp,16
8000022c:	00008067          	ret

80000230 <emulationTrapToSupervisorTrap>:
80000230:	800007b7          	lui	a5,0x80000
80000234:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff074>
80000238:	30579073          	csrw	mtvec,a5
8000023c:	343027f3          	csrr	a5,mtval
80000240:	14379073          	csrw	stval,a5
80000244:	342027f3          	csrr	a5,mcause
80000248:	14279073          	csrw	scause,a5
8000024c:	14151073          	csrw	sepc,a0
80000250:	105027f3          	csrr	a5,stvec
80000254:	34179073          	csrw	mepc,a5
80000258:	10000793          	li	a5,256
8000025c:	1007b073          	csrc	sstatus,a5
80000260:	0035d593          	srli	a1,a1,0x3
80000264:	1005f593          	andi	a1,a1,256
80000268:	1005a073          	csrs	sstatus,a1
8000026c:	000027b7          	lui	a5,0x2
80000270:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
80000274:	3007b073          	csrc	mstatus,a5
80000278:	000017b7          	lui	a5,0x1
8000027c:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
80000280:	3007a073          	csrs	mstatus,a5
80000284:	00008067          	ret

80000288 <readWord>:
80000288:	00020737          	lui	a4,0x20
8000028c:	30072073          	csrs	mstatus,a4
80000290:	00000717          	auipc	a4,0x0
80000294:	01870713          	addi	a4,a4,24 # 800002a8 <readWord+0x20>
80000298:	30571073          	csrw	mtvec,a4
8000029c:	00100693          	li	a3,1
800002a0:	00052783          	lw	a5,0(a0)
800002a4:	00000693          	li	a3,0
800002a8:	00020737          	lui	a4,0x20
800002ac:	30073073          	csrc	mstatus,a4
800002b0:	00068513          	mv	a0,a3
800002b4:	00f5a023          	sw	a5,0(a1) # 81000000 <_sp+0xffeff8>
800002b8:	00008067          	ret

800002bc <writeWord>:
800002bc:	00020737          	lui	a4,0x20
800002c0:	30072073          	csrs	mstatus,a4
800002c4:	00000717          	auipc	a4,0x0
800002c8:	01870713          	addi	a4,a4,24 # 800002dc <writeWord+0x20>
800002cc:	30571073          	csrw	mtvec,a4
800002d0:	00100793          	li	a5,1
800002d4:	00b52023          	sw	a1,0(a0)
800002d8:	00000793          	li	a5,0
800002dc:	00020737          	lui	a4,0x20
800002e0:	30073073          	csrc	mstatus,a4
800002e4:	00078513          	mv	a0,a5
800002e8:	00008067          	ret

800002ec <trap>:
800002ec:	fe010113          	addi	sp,sp,-32
800002f0:	00112e23          	sw	ra,28(sp)
800002f4:	00812c23          	sw	s0,24(sp)
800002f8:	00912a23          	sw	s1,20(sp)
800002fc:	01212823          	sw	s2,16(sp)
80000300:	01312623          	sw	s3,12(sp)
80000304:	342027f3          	csrr	a5,mcause
80000308:	0807cc63          	bltz	a5,800003a0 <trap+0xb4>
8000030c:	00200713          	li	a4,2
80000310:	0ce78463          	beq	a5,a4,800003d8 <trap+0xec>
80000314:	00900693          	li	a3,9
80000318:	04d79463          	bne	a5,a3,80000360 <trap+0x74>
8000031c:	800017b7          	lui	a5,0x80001
80000320:	00878793          	addi	a5,a5,8 # 80001008 <_sp+0x0>
80000324:	fc47a683          	lw	a3,-60(a5)
80000328:	00100613          	li	a2,1
8000032c:	fa87a503          	lw	a0,-88(a5)
80000330:	2ec68663          	beq	a3,a2,8000061c <trap+0x330>
80000334:	2ae68463          	beq	a3,a4,800005dc <trap+0x2f0>
80000338:	2a068e63          	beqz	a3,800005f4 <trap+0x308>
8000033c:	01812403          	lw	s0,24(sp)
80000340:	01c12083          	lw	ra,28(sp)
80000344:	01412483          	lw	s1,20(sp)
80000348:	01012903          	lw	s2,16(sp)
8000034c:	00c12983          	lw	s3,12(sp)
80000350:	02010113          	addi	sp,sp,32
80000354:	3600006f          	j	800006b4 <stopSim>
80000358:	00777713          	andi	a4,a4,7
8000035c:	14f70063          	beq	a4,a5,8000049c <trap+0x1b0>
80000360:	354000ef          	jal	ra,800006b4 <stopSim>
80000364:	343027f3          	csrr	a5,mtval
80000368:	14379073          	csrw	stval,a5
8000036c:	341027f3          	csrr	a5,mepc
80000370:	14179073          	csrw	sepc,a5
80000374:	342027f3          	csrr	a5,mcause
80000378:	14279073          	csrw	scause,a5
8000037c:	105027f3          	csrr	a5,stvec
80000380:	34179073          	csrw	mepc,a5
80000384:	01c12083          	lw	ra,28(sp)
80000388:	01812403          	lw	s0,24(sp)
8000038c:	01412483          	lw	s1,20(sp)
80000390:	01012903          	lw	s2,16(sp)
80000394:	00c12983          	lw	s3,12(sp)
80000398:	02010113          	addi	sp,sp,32
8000039c:	00008067          	ret
800003a0:	0ff7f793          	andi	a5,a5,255
800003a4:	00700713          	li	a4,7
800003a8:	fae79ce3          	bne	a5,a4,80000360 <trap+0x74>
800003ac:	02000793          	li	a5,32
800003b0:	1447a073          	csrs	sip,a5
800003b4:	08000793          	li	a5,128
800003b8:	3047b073          	csrc	mie,a5
800003bc:	01c12083          	lw	ra,28(sp)
800003c0:	01812403          	lw	s0,24(sp)
800003c4:	01412483          	lw	s1,20(sp)
800003c8:	01012903          	lw	s2,16(sp)
800003cc:	00c12983          	lw	s3,12(sp)
800003d0:	02010113          	addi	sp,sp,32
800003d4:	00008067          	ret
800003d8:	341024f3          	csrr	s1,mepc
800003dc:	300025f3          	csrr	a1,mstatus
800003e0:	34302473          	csrr	s0,mtval
800003e4:	02f00613          	li	a2,47
800003e8:	07f47693          	andi	a3,s0,127
800003ec:	00c45713          	srli	a4,s0,0xc
800003f0:	f6c684e3          	beq	a3,a2,80000358 <trap+0x6c>
800003f4:	07300613          	li	a2,115
800003f8:	f6c694e3          	bne	a3,a2,80000360 <trap+0x74>
800003fc:	00377713          	andi	a4,a4,3
80000400:	12f70063          	beq	a4,a5,80000520 <trap+0x234>
80000404:	00300793          	li	a5,3
80000408:	10f70c63          	beq	a4,a5,80000520 <trap+0x234>
8000040c:	00100993          	li	s3,1
80000410:	03370463          	beq	a4,s3,80000438 <trap+0x14c>
80000414:	2a0000ef          	jal	ra,800006b4 <stopSim>
80000418:	343027f3          	csrr	a5,mtval
8000041c:	14379073          	csrw	stval,a5
80000420:	341027f3          	csrr	a5,mepc
80000424:	14179073          	csrw	sepc,a5
80000428:	342027f3          	csrr	a5,mcause
8000042c:	14279073          	csrw	scause,a5
80000430:	105027f3          	csrr	a5,stvec
80000434:	34179073          	csrw	mepc,a5
80000438:	000017b7          	lui	a5,0x1
8000043c:	01445713          	srli	a4,s0,0x14
80000440:	c0178693          	addi	a3,a5,-1023 # c01 <__stack_size+0x401>
80000444:	0ed70663          	beq	a4,a3,80000530 <trap+0x244>
80000448:	c8178793          	addi	a5,a5,-895
8000044c:	0cf70463          	beq	a4,a5,80000514 <trap+0x228>
80000450:	264000ef          	jal	ra,800006b4 <stopSim>
80000454:	343027f3          	csrr	a5,mtval
80000458:	14379073          	csrw	stval,a5
8000045c:	341027f3          	csrr	a5,mepc
80000460:	14179073          	csrw	sepc,a5
80000464:	342027f3          	csrr	a5,mcause
80000468:	14279073          	csrw	scause,a5
8000046c:	105027f3          	csrr	a5,stvec
80000470:	34179073          	csrw	mepc,a5
80000474:	1c099063          	bnez	s3,80000634 <trap+0x348>
80000478:	00545413          	srli	s0,s0,0x5
8000047c:	800017b7          	lui	a5,0x80001
80000480:	f8878793          	addi	a5,a5,-120 # 80000f88 <_sp+0xffffff80>
80000484:	07c47413          	andi	s0,s0,124
80000488:	00f40433          	add	s0,s0,a5
8000048c:	01242023          	sw	s2,0(s0)
80000490:	00448493          	addi	s1,s1,4
80000494:	34149073          	csrw	mepc,s1
80000498:	eedff06f          	j	80000384 <trap+0x98>
8000049c:	00d45713          	srli	a4,s0,0xd
800004a0:	01245793          	srli	a5,s0,0x12
800004a4:	800016b7          	lui	a3,0x80001
800004a8:	f8868693          	addi	a3,a3,-120 # 80000f88 <_sp+0xffffff80>
800004ac:	07c77713          	andi	a4,a4,124
800004b0:	07c7f793          	andi	a5,a5,124
800004b4:	00d70733          	add	a4,a4,a3
800004b8:	00d787b3          	add	a5,a5,a3
800004bc:	00072703          	lw	a4,0(a4) # 20000 <__stack_size+0x1f800>
800004c0:	0007a603          	lw	a2,0(a5)
800004c4:	00020537          	lui	a0,0x20
800004c8:	30052073          	csrs	mstatus,a0
800004cc:	00000517          	auipc	a0,0x0
800004d0:	01850513          	addi	a0,a0,24 # 800004e4 <trap+0x1f8>
800004d4:	30551073          	csrw	mtvec,a0
800004d8:	00100793          	li	a5,1
800004dc:	00072803          	lw	a6,0(a4)
800004e0:	00000793          	li	a5,0
800004e4:	00020537          	lui	a0,0x20
800004e8:	30053073          	csrc	mstatus,a0
800004ec:	16079863          	bnez	a5,8000065c <trap+0x370>
800004f0:	01b45793          	srli	a5,s0,0x1b
800004f4:	01c00513          	li	a0,28
800004f8:	e6f564e3          	bltu	a0,a5,80000360 <trap+0x74>
800004fc:	80000537          	lui	a0,0x80000
80000500:	00279793          	slli	a5,a5,0x2
80000504:	79450513          	addi	a0,a0,1940 # 80000794 <_sp+0xfffff78c>
80000508:	00a787b3          	add	a5,a5,a0
8000050c:	0007a783          	lw	a5,0(a5)
80000510:	00078067          	jr	a5
80000514:	1b8000ef          	jal	ra,800006cc <rdtimeh>
80000518:	00050913          	mv	s2,a0
8000051c:	f59ff06f          	j	80000474 <trap+0x188>
80000520:	00f45993          	srli	s3,s0,0xf
80000524:	01f9f993          	andi	s3,s3,31
80000528:	013039b3          	snez	s3,s3
8000052c:	f0dff06f          	j	80000438 <trap+0x14c>
80000530:	194000ef          	jal	ra,800006c4 <rdtime>
80000534:	00050913          	mv	s2,a0
80000538:	f3dff06f          	j	80000474 <trap+0x188>
8000053c:	01067463          	bgeu	a2,a6,80000544 <trap+0x258>
80000540:	00080613          	mv	a2,a6
80000544:	00545413          	srli	s0,s0,0x5
80000548:	07c47413          	andi	s0,s0,124
8000054c:	00d406b3          	add	a3,s0,a3
80000550:	0106a023          	sw	a6,0(a3)
80000554:	000207b7          	lui	a5,0x20
80000558:	3007a073          	csrs	mstatus,a5
8000055c:	00000797          	auipc	a5,0x0
80000560:	01878793          	addi	a5,a5,24 # 80000574 <trap+0x288>
80000564:	30579073          	csrw	mtvec,a5
80000568:	00100693          	li	a3,1
8000056c:	00c72023          	sw	a2,0(a4)
80000570:	00000693          	li	a3,0
80000574:	000207b7          	lui	a5,0x20
80000578:	3007b073          	csrc	mstatus,a5
8000057c:	800007b7          	lui	a5,0x80000
80000580:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff074>
80000584:	0e069063          	bnez	a3,80000664 <trap+0x378>
80000588:	00448493          	addi	s1,s1,4
8000058c:	34149073          	csrw	mepc,s1
80000590:	30579073          	csrw	mtvec,a5
80000594:	df1ff06f          	j	80000384 <trap+0x98>
80000598:	01064633          	xor	a2,a2,a6
8000059c:	fa9ff06f          	j	80000544 <trap+0x258>
800005a0:	01060633          	add	a2,a2,a6
800005a4:	fa1ff06f          	j	80000544 <trap+0x258>
800005a8:	01067633          	and	a2,a2,a6
800005ac:	f99ff06f          	j	80000544 <trap+0x258>
800005b0:	01066633          	or	a2,a2,a6
800005b4:	f91ff06f          	j	80000544 <trap+0x258>
800005b8:	f8c876e3          	bgeu	a6,a2,80000544 <trap+0x258>
800005bc:	00080613          	mv	a2,a6
800005c0:	f85ff06f          	j	80000544 <trap+0x258>
800005c4:	f90650e3          	bge	a2,a6,80000544 <trap+0x258>
800005c8:	00080613          	mv	a2,a6
800005cc:	f79ff06f          	j	80000544 <trap+0x258>
800005d0:	f6c85ae3          	bge	a6,a2,80000544 <trap+0x258>
800005d4:	00080613          	mv	a2,a6
800005d8:	f6dff06f          	j	80000544 <trap+0x258>
800005dc:	fff00713          	li	a4,-1
800005e0:	fae7a423          	sw	a4,-88(a5)
800005e4:	341027f3          	csrr	a5,mepc
800005e8:	00478793          	addi	a5,a5,4
800005ec:	34179073          	csrw	mepc,a5
800005f0:	d95ff06f          	j	80000384 <trap+0x98>
800005f4:	fac7a583          	lw	a1,-84(a5)
800005f8:	0dc000ef          	jal	ra,800006d4 <setMachineTimerCmp>
800005fc:	08000793          	li	a5,128
80000600:	3047a073          	csrs	mie,a5
80000604:	02000793          	li	a5,32
80000608:	1447b073          	csrc	sip,a5
8000060c:	341027f3          	csrr	a5,mepc
80000610:	00478793          	addi	a5,a5,4
80000614:	34179073          	csrw	mepc,a5
80000618:	d6dff06f          	j	80000384 <trap+0x98>
8000061c:	0ff57513          	andi	a0,a0,255
80000620:	09c000ef          	jal	ra,800006bc <putC>
80000624:	341027f3          	csrr	a5,mepc
80000628:	00478793          	addi	a5,a5,4
8000062c:	34179073          	csrw	mepc,a5
80000630:	d55ff06f          	j	80000384 <trap+0x98>
80000634:	080000ef          	jal	ra,800006b4 <stopSim>
80000638:	343027f3          	csrr	a5,mtval
8000063c:	14379073          	csrw	stval,a5
80000640:	341027f3          	csrr	a5,mepc
80000644:	14179073          	csrw	sepc,a5
80000648:	342027f3          	csrr	a5,mcause
8000064c:	14279073          	csrw	scause,a5
80000650:	105027f3          	csrr	a5,stvec
80000654:	34179073          	csrw	mepc,a5
80000658:	e21ff06f          	j	80000478 <trap+0x18c>
8000065c:	800007b7          	lui	a5,0x80000
80000660:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff074>
80000664:	30579073          	csrw	mtvec,a5
80000668:	343027f3          	csrr	a5,mtval
8000066c:	14379073          	csrw	stval,a5
80000670:	342027f3          	csrr	a5,mcause
80000674:	14279073          	csrw	scause,a5
80000678:	14149073          	csrw	sepc,s1
8000067c:	105027f3          	csrr	a5,stvec
80000680:	34179073          	csrw	mepc,a5
80000684:	10000793          	li	a5,256
80000688:	1007b073          	csrc	sstatus,a5
8000068c:	0035d793          	srli	a5,a1,0x3
80000690:	1007f793          	andi	a5,a5,256
80000694:	1007a073          	csrs	sstatus,a5
80000698:	000027b7          	lui	a5,0x2
8000069c:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
800006a0:	3007b073          	csrc	mstatus,a5
800006a4:	000017b7          	lui	a5,0x1
800006a8:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
800006ac:	3007a073          	csrs	mstatus,a5
800006b0:	cd5ff06f          	j	80000384 <trap+0x98>

800006b4 <stopSim>:
800006b4:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7fffeff4>
800006b8:	00008067          	ret

800006bc <putC>:
800006bc:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7fffeff0>
800006c0:	00008067          	ret

800006c4 <rdtime>:
800006c4:	fe002503          	lw	a0,-32(zero) # ffffffe0 <_sp+0x7fffefd8>
800006c8:	00008067          	ret

800006cc <rdtimeh>:
800006cc:	fe402503          	lw	a0,-28(zero) # ffffffe4 <_sp+0x7fffefdc>
800006d0:	00008067          	ret

800006d4 <setMachineTimerCmp>:
800006d4:	fec00793          	li	a5,-20
800006d8:	fff00713          	li	a4,-1
800006dc:	00e7a023          	sw	a4,0(a5)
800006e0:	fea02423          	sw	a0,-24(zero) # ffffffe8 <_sp+0x7fffefe0>
800006e4:	00b7a023          	sw	a1,0(a5)
800006e8:	00008067          	ret

800006ec <__libc_init_array>:
800006ec:	ff010113          	addi	sp,sp,-16
800006f0:	00000797          	auipc	a5,0x0
800006f4:	0a478793          	addi	a5,a5,164 # 80000794 <__init_array_end>
800006f8:	00812423          	sw	s0,8(sp)
800006fc:	00000417          	auipc	s0,0x0
80000700:	09840413          	addi	s0,s0,152 # 80000794 <__init_array_end>
80000704:	40f40433          	sub	s0,s0,a5
80000708:	00912223          	sw	s1,4(sp)
8000070c:	01212023          	sw	s2,0(sp)
80000710:	00112623          	sw	ra,12(sp)
80000714:	40245413          	srai	s0,s0,0x2
80000718:	00000493          	li	s1,0
8000071c:	00078913          	mv	s2,a5
80000720:	04849263          	bne	s1,s0,80000764 <__libc_init_array+0x78>
80000724:	955ff0ef          	jal	ra,80000078 <_init>
80000728:	00000797          	auipc	a5,0x0
8000072c:	06c78793          	addi	a5,a5,108 # 80000794 <__init_array_end>
80000730:	00000417          	auipc	s0,0x0
80000734:	06440413          	addi	s0,s0,100 # 80000794 <__init_array_end>
80000738:	40f40433          	sub	s0,s0,a5
8000073c:	40245413          	srai	s0,s0,0x2
80000740:	00000493          	li	s1,0
80000744:	00078913          	mv	s2,a5
80000748:	02849a63          	bne	s1,s0,8000077c <__libc_init_array+0x90>
8000074c:	00c12083          	lw	ra,12(sp)
80000750:	00812403          	lw	s0,8(sp)
80000754:	00412483          	lw	s1,4(sp)
80000758:	00012903          	lw	s2,0(sp)
8000075c:	01010113          	addi	sp,sp,16
80000760:	00008067          	ret
80000764:	00249793          	slli	a5,s1,0x2
80000768:	00f907b3          	add	a5,s2,a5
8000076c:	0007a783          	lw	a5,0(a5)
80000770:	00148493          	addi	s1,s1,1
80000774:	000780e7          	jalr	a5
80000778:	fa9ff06f          	j	80000720 <__libc_init_array+0x34>
8000077c:	00249793          	slli	a5,s1,0x2
80000780:	00f907b3          	add	a5,s2,a5
80000784:	0007a783          	lw	a5,0(a5)
80000788:	00148493          	addi	s1,s1,1
8000078c:	000780e7          	jalr	a5
80000790:	fb9ff06f          	j	80000748 <__libc_init_array+0x5c>
