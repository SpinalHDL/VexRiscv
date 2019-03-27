
build/emulator.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00001117          	auipc	sp,0x1
80000004:	03010113          	addi	sp,sp,48 # 80001030 <_sp>
80000008:	00000517          	auipc	a0,0x0
8000000c:	7b050513          	addi	a0,a0,1968 # 800007b8 <__init_array_end>
80000010:	00000597          	auipc	a1,0x0
80000014:	7a858593          	addi	a1,a1,1960 # 800007b8 <__init_array_end>
80000018:	00001617          	auipc	a2,0x1
8000001c:	81860613          	addi	a2,a2,-2024 # 80000830 <__bss_start>
80000020:	00c5fc63          	bleu	a2,a1,80000038 <_start+0x38>
80000024:	00052283          	lw	t0,0(a0)
80000028:	0055a023          	sw	t0,0(a1)
8000002c:	00450513          	addi	a0,a0,4
80000030:	00458593          	addi	a1,a1,4
80000034:	fec5e8e3          	bltu	a1,a2,80000024 <_start+0x24>
80000038:	00000517          	auipc	a0,0x0
8000003c:	7f850513          	addi	a0,a0,2040 # 80000830 <__bss_start>
80000040:	00000597          	auipc	a1,0x0
80000044:	7f058593          	addi	a1,a1,2032 # 80000830 <__bss_start>
80000048:	00b57863          	bleu	a1,a0,80000058 <_start+0x58>
8000004c:	00052023          	sw	zero,0(a0)
80000050:	00450513          	addi	a0,a0,4
80000054:	feb56ce3          	bltu	a0,a1,8000004c <_start+0x4c>
80000058:	6c8000ef          	jal	ra,80000720 <__libc_init_array>
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
80000180:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff04c>
80000184:	30579073          	csrw	mtvec,a5
80000188:	800017b7          	lui	a5,0x80001
8000018c:	fb078793          	addi	a5,a5,-80 # 80000fb0 <_sp+0xffffff80>
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
800001b8:	02000793          	li	a5,32
800001bc:	30379073          	csrw	mideleg,a5
800001c0:	14305073          	csrwi	sbadaddr,0
800001c4:	00008067          	ret

800001c8 <readRegister>:
800001c8:	800017b7          	lui	a5,0x80001
800001cc:	fb078793          	addi	a5,a5,-80 # 80000fb0 <_sp+0xffffff80>
800001d0:	00251513          	slli	a0,a0,0x2
800001d4:	00f50533          	add	a0,a0,a5
800001d8:	00052503          	lw	a0,0(a0)
800001dc:	00008067          	ret

800001e0 <writeRegister>:
800001e0:	800017b7          	lui	a5,0x80001
800001e4:	00251513          	slli	a0,a0,0x2
800001e8:	fb078793          	addi	a5,a5,-80 # 80000fb0 <_sp+0xffffff80>
800001ec:	00f50533          	add	a0,a0,a5
800001f0:	00b52023          	sw	a1,0(a0)
800001f4:	00008067          	ret

800001f8 <redirectTrap>:
800001f8:	ff010113          	addi	sp,sp,-16
800001fc:	00112623          	sw	ra,12(sp)
80000200:	4e8000ef          	jal	ra,800006e8 <stopSim>
80000204:	343027f3          	csrr	a5,mbadaddr
80000208:	14379073          	csrw	sbadaddr,a5
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
80000234:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff04c>
80000238:	30579073          	csrw	mtvec,a5
8000023c:	343027f3          	csrr	a5,mbadaddr
80000240:	14379073          	csrw	sbadaddr,a5
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
800002b4:	00f5a023          	sw	a5,0(a1) # 81000000 <_sp+0xffefd0>
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
80000308:	1407ce63          	bltz	a5,80000464 <trap+0x178>
8000030c:	00200713          	li	a4,2
80000310:	04e78463          	beq	a5,a4,80000358 <trap+0x6c>
80000314:	00900693          	li	a3,9
80000318:	10d79663          	bne	a5,a3,80000424 <trap+0x138>
8000031c:	800017b7          	lui	a5,0x80001
80000320:	03078793          	addi	a5,a5,48 # 80001030 <_sp+0x0>
80000324:	fc47a683          	lw	a3,-60(a5)
80000328:	00100613          	li	a2,1
8000032c:	fa87a503          	lw	a0,-88(a5)
80000330:	1ec68663          	beq	a3,a2,8000051c <trap+0x230>
80000334:	22e68463          	beq	a3,a4,8000055c <trap+0x270>
80000338:	1e068e63          	beqz	a3,80000534 <trap+0x248>
8000033c:	01812403          	lw	s0,24(sp)
80000340:	01c12083          	lw	ra,28(sp)
80000344:	01412483          	lw	s1,20(sp)
80000348:	01012903          	lw	s2,16(sp)
8000034c:	00c12983          	lw	s3,12(sp)
80000350:	02010113          	addi	sp,sp,32
80000354:	3940006f          	j	800006e8 <stopSim>
80000358:	341024f3          	csrr	s1,mepc
8000035c:	300025f3          	csrr	a1,mstatus
80000360:	34302473          	csrr	s0,mbadaddr
80000364:	02f00613          	li	a2,47
80000368:	07f47693          	andi	a3,s0,127
8000036c:	00c45713          	srli	a4,s0,0xc
80000370:	12c68663          	beq	a3,a2,8000049c <trap+0x1b0>
80000374:	07300613          	li	a2,115
80000378:	0ac69663          	bne	a3,a2,80000424 <trap+0x138>
8000037c:	00377713          	andi	a4,a4,3
80000380:	24f70663          	beq	a4,a5,800005cc <trap+0x2e0>
80000384:	00300793          	li	a5,3
80000388:	24f70263          	beq	a4,a5,800005cc <trap+0x2e0>
8000038c:	00100993          	li	s3,1
80000390:	03370463          	beq	a4,s3,800003b8 <trap+0xcc>
80000394:	354000ef          	jal	ra,800006e8 <stopSim>
80000398:	343027f3          	csrr	a5,mbadaddr
8000039c:	14379073          	csrw	sbadaddr,a5
800003a0:	341027f3          	csrr	a5,mepc
800003a4:	14179073          	csrw	sepc,a5
800003a8:	342027f3          	csrr	a5,mcause
800003ac:	14279073          	csrw	scause,a5
800003b0:	105027f3          	csrr	a5,stvec
800003b4:	34179073          	csrw	mepc,a5
800003b8:	000017b7          	lui	a5,0x1
800003bc:	01445713          	srli	a4,s0,0x14
800003c0:	c0178693          	addi	a3,a5,-1023 # c01 <__stack_size+0x401>
800003c4:	30d70463          	beq	a4,a3,800006cc <trap+0x3e0>
800003c8:	c8178793          	addi	a5,a5,-895
800003cc:	2cf71c63          	bne	a4,a5,800006a4 <trap+0x3b8>
800003d0:	330000ef          	jal	ra,80000700 <rdtimeh>
800003d4:	00050913          	mv	s2,a0
800003d8:	02098463          	beqz	s3,80000400 <trap+0x114>
800003dc:	30c000ef          	jal	ra,800006e8 <stopSim>
800003e0:	343027f3          	csrr	a5,mbadaddr
800003e4:	14379073          	csrw	sbadaddr,a5
800003e8:	341027f3          	csrr	a5,mepc
800003ec:	14179073          	csrw	sepc,a5
800003f0:	342027f3          	csrr	a5,mcause
800003f4:	14279073          	csrw	scause,a5
800003f8:	105027f3          	csrr	a5,stvec
800003fc:	34179073          	csrw	mepc,a5
80000400:	00545413          	srli	s0,s0,0x5
80000404:	800017b7          	lui	a5,0x80001
80000408:	fb078793          	addi	a5,a5,-80 # 80000fb0 <_sp+0xffffff80>
8000040c:	07c47413          	andi	s0,s0,124
80000410:	00f40433          	add	s0,s0,a5
80000414:	01242023          	sw	s2,0(s0)
80000418:	00448493          	addi	s1,s1,4
8000041c:	34149073          	csrw	mepc,s1
80000420:	0280006f          	j	80000448 <trap+0x15c>
80000424:	2c4000ef          	jal	ra,800006e8 <stopSim>
80000428:	343027f3          	csrr	a5,mbadaddr
8000042c:	14379073          	csrw	sbadaddr,a5
80000430:	341027f3          	csrr	a5,mepc
80000434:	14179073          	csrw	sepc,a5
80000438:	342027f3          	csrr	a5,mcause
8000043c:	14279073          	csrw	scause,a5
80000440:	105027f3          	csrr	a5,stvec
80000444:	34179073          	csrw	mepc,a5
80000448:	01c12083          	lw	ra,28(sp)
8000044c:	01812403          	lw	s0,24(sp)
80000450:	01412483          	lw	s1,20(sp)
80000454:	01012903          	lw	s2,16(sp)
80000458:	00c12983          	lw	s3,12(sp)
8000045c:	02010113          	addi	sp,sp,32
80000460:	00008067          	ret
80000464:	0ff7f793          	andi	a5,a5,255
80000468:	00700713          	li	a4,7
8000046c:	fae79ce3          	bne	a5,a4,80000424 <trap+0x138>
80000470:	02000793          	li	a5,32
80000474:	1447a073          	csrs	sip,a5
80000478:	08000793          	li	a5,128
8000047c:	3047b073          	csrc	mie,a5
80000480:	01c12083          	lw	ra,28(sp)
80000484:	01812403          	lw	s0,24(sp)
80000488:	01412483          	lw	s1,20(sp)
8000048c:	01012903          	lw	s2,16(sp)
80000490:	00c12983          	lw	s3,12(sp)
80000494:	02010113          	addi	sp,sp,32
80000498:	00008067          	ret
8000049c:	00777713          	andi	a4,a4,7
800004a0:	f8f712e3          	bne	a4,a5,80000424 <trap+0x138>
800004a4:	00d45713          	srli	a4,s0,0xd
800004a8:	01245793          	srli	a5,s0,0x12
800004ac:	800016b7          	lui	a3,0x80001
800004b0:	fb068693          	addi	a3,a3,-80 # 80000fb0 <_sp+0xffffff80>
800004b4:	07c77713          	andi	a4,a4,124
800004b8:	07c7f793          	andi	a5,a5,124
800004bc:	00d70733          	add	a4,a4,a3
800004c0:	00d787b3          	add	a5,a5,a3
800004c4:	00072703          	lw	a4,0(a4) # 20000 <__stack_size+0x1f800>
800004c8:	0007a603          	lw	a2,0(a5)
800004cc:	00020537          	lui	a0,0x20
800004d0:	30052073          	csrs	mstatus,a0
800004d4:	00000517          	auipc	a0,0x0
800004d8:	01850513          	addi	a0,a0,24 # 800004ec <trap+0x200>
800004dc:	30551073          	csrw	mtvec,a0
800004e0:	00100793          	li	a5,1
800004e4:	00072803          	lw	a6,0(a4)
800004e8:	00000793          	li	a5,0
800004ec:	00020537          	lui	a0,0x20
800004f0:	30053073          	csrc	mstatus,a0
800004f4:	08079063          	bnez	a5,80000574 <trap+0x288>
800004f8:	01b45793          	srli	a5,s0,0x1b
800004fc:	01c00513          	li	a0,28
80000500:	f2f562e3          	bltu	a0,a5,80000424 <trap+0x138>
80000504:	80000537          	lui	a0,0x80000
80000508:	00279793          	slli	a5,a5,0x2
8000050c:	7b850513          	addi	a0,a0,1976 # 800007b8 <_sp+0xfffff788>
80000510:	00a787b3          	add	a5,a5,a0
80000514:	0007a783          	lw	a5,0(a5)
80000518:	00078067          	jr	a5
8000051c:	0ff57513          	andi	a0,a0,255
80000520:	1d0000ef          	jal	ra,800006f0 <putC>
80000524:	341027f3          	csrr	a5,mepc
80000528:	00478793          	addi	a5,a5,4
8000052c:	34179073          	csrw	mepc,a5
80000530:	f19ff06f          	j	80000448 <trap+0x15c>
80000534:	fac7a583          	lw	a1,-84(a5)
80000538:	1d0000ef          	jal	ra,80000708 <setMachineTimerCmp>
8000053c:	08000793          	li	a5,128
80000540:	3047a073          	csrs	mie,a5
80000544:	02000793          	li	a5,32
80000548:	1447b073          	csrc	sip,a5
8000054c:	341027f3          	csrr	a5,mepc
80000550:	00478793          	addi	a5,a5,4
80000554:	34179073          	csrw	mepc,a5
80000558:	ef1ff06f          	j	80000448 <trap+0x15c>
8000055c:	fff00713          	li	a4,-1
80000560:	fae7a423          	sw	a4,-88(a5)
80000564:	341027f3          	csrr	a5,mepc
80000568:	00478793          	addi	a5,a5,4
8000056c:	34179073          	csrw	mepc,a5
80000570:	ed9ff06f          	j	80000448 <trap+0x15c>
80000574:	800007b7          	lui	a5,0x80000
80000578:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff04c>
8000057c:	30579073          	csrw	mtvec,a5
80000580:	343027f3          	csrr	a5,mbadaddr
80000584:	14379073          	csrw	sbadaddr,a5
80000588:	342027f3          	csrr	a5,mcause
8000058c:	14279073          	csrw	scause,a5
80000590:	14149073          	csrw	sepc,s1
80000594:	105027f3          	csrr	a5,stvec
80000598:	34179073          	csrw	mepc,a5
8000059c:	10000793          	li	a5,256
800005a0:	1007b073          	csrc	sstatus,a5
800005a4:	0035d593          	srli	a1,a1,0x3
800005a8:	1005f593          	andi	a1,a1,256
800005ac:	1005a073          	csrs	sstatus,a1
800005b0:	000027b7          	lui	a5,0x2
800005b4:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
800005b8:	3007b073          	csrc	mstatus,a5
800005bc:	000017b7          	lui	a5,0x1
800005c0:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
800005c4:	3007a073          	csrs	mstatus,a5
800005c8:	e81ff06f          	j	80000448 <trap+0x15c>
800005cc:	00f45993          	srli	s3,s0,0xf
800005d0:	01f9f993          	andi	s3,s3,31
800005d4:	013039b3          	snez	s3,s3
800005d8:	de1ff06f          	j	800003b8 <trap+0xcc>
800005dc:	01060633          	add	a2,a2,a6
800005e0:	00545413          	srli	s0,s0,0x5
800005e4:	07c47413          	andi	s0,s0,124
800005e8:	00d406b3          	add	a3,s0,a3
800005ec:	0106a023          	sw	a6,0(a3)
800005f0:	000207b7          	lui	a5,0x20
800005f4:	3007a073          	csrs	mstatus,a5
800005f8:	00000797          	auipc	a5,0x0
800005fc:	01878793          	addi	a5,a5,24 # 80000610 <trap+0x324>
80000600:	30579073          	csrw	mtvec,a5
80000604:	00100693          	li	a3,1
80000608:	00c72023          	sw	a2,0(a4)
8000060c:	00000693          	li	a3,0
80000610:	000207b7          	lui	a5,0x20
80000614:	3007b073          	csrc	mstatus,a5
80000618:	800007b7          	lui	a5,0x80000
8000061c:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff04c>
80000620:	0a068c63          	beqz	a3,800006d8 <trap+0x3ec>
80000624:	30579073          	csrw	mtvec,a5
80000628:	343027f3          	csrr	a5,mbadaddr
8000062c:	14379073          	csrw	sbadaddr,a5
80000630:	342027f3          	csrr	a5,mcause
80000634:	14279073          	csrw	scause,a5
80000638:	14149073          	csrw	sepc,s1
8000063c:	105027f3          	csrr	a5,stvec
80000640:	34179073          	csrw	mepc,a5
80000644:	10000793          	li	a5,256
80000648:	1007b073          	csrc	sstatus,a5
8000064c:	0035d793          	srli	a5,a1,0x3
80000650:	1007f793          	andi	a5,a5,256
80000654:	1007a073          	csrs	sstatus,a5
80000658:	f59ff06f          	j	800005b0 <trap+0x2c4>
8000065c:	f90672e3          	bleu	a6,a2,800005e0 <trap+0x2f4>
80000660:	00080613          	mv	a2,a6
80000664:	f7dff06f          	j	800005e0 <trap+0x2f4>
80000668:	f6c87ce3          	bleu	a2,a6,800005e0 <trap+0x2f4>
8000066c:	00080613          	mv	a2,a6
80000670:	f71ff06f          	j	800005e0 <trap+0x2f4>
80000674:	01066633          	or	a2,a2,a6
80000678:	f69ff06f          	j	800005e0 <trap+0x2f4>
8000067c:	01064633          	xor	a2,a2,a6
80000680:	f61ff06f          	j	800005e0 <trap+0x2f4>
80000684:	f4c85ee3          	ble	a2,a6,800005e0 <trap+0x2f4>
80000688:	00080613          	mv	a2,a6
8000068c:	f55ff06f          	j	800005e0 <trap+0x2f4>
80000690:	01067633          	and	a2,a2,a6
80000694:	f4dff06f          	j	800005e0 <trap+0x2f4>
80000698:	f50654e3          	ble	a6,a2,800005e0 <trap+0x2f4>
8000069c:	00080613          	mv	a2,a6
800006a0:	f41ff06f          	j	800005e0 <trap+0x2f4>
800006a4:	044000ef          	jal	ra,800006e8 <stopSim>
800006a8:	343027f3          	csrr	a5,mbadaddr
800006ac:	14379073          	csrw	sbadaddr,a5
800006b0:	341027f3          	csrr	a5,mepc
800006b4:	14179073          	csrw	sepc,a5
800006b8:	342027f3          	csrr	a5,mcause
800006bc:	14279073          	csrw	scause,a5
800006c0:	105027f3          	csrr	a5,stvec
800006c4:	34179073          	csrw	mepc,a5
800006c8:	d11ff06f          	j	800003d8 <trap+0xec>
800006cc:	02c000ef          	jal	ra,800006f8 <rdtime>
800006d0:	00050913          	mv	s2,a0
800006d4:	d05ff06f          	j	800003d8 <trap+0xec>
800006d8:	00448493          	addi	s1,s1,4
800006dc:	34149073          	csrw	mepc,s1
800006e0:	30579073          	csrw	mtvec,a5
800006e4:	d65ff06f          	j	80000448 <trap+0x15c>

800006e8 <stopSim>:
800006e8:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7fffefcc>
800006ec:	00008067          	ret

800006f0 <putC>:
800006f0:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7fffefc8>
800006f4:	00008067          	ret

800006f8 <rdtime>:
800006f8:	fe002503          	lw	a0,-32(zero) # ffffffe0 <_sp+0x7fffefb0>
800006fc:	00008067          	ret

80000700 <rdtimeh>:
80000700:	fe402503          	lw	a0,-28(zero) # ffffffe4 <_sp+0x7fffefb4>
80000704:	00008067          	ret

80000708 <setMachineTimerCmp>:
80000708:	fec00793          	li	a5,-20
8000070c:	fff00713          	li	a4,-1
80000710:	00e7a023          	sw	a4,0(a5)
80000714:	fea02423          	sw	a0,-24(zero) # ffffffe8 <_sp+0x7fffefb8>
80000718:	00b7a023          	sw	a1,0(a5)
8000071c:	00008067          	ret

80000720 <__libc_init_array>:
80000720:	ff010113          	addi	sp,sp,-16
80000724:	00812423          	sw	s0,8(sp)
80000728:	00912223          	sw	s1,4(sp)
8000072c:	00000417          	auipc	s0,0x0
80000730:	08c40413          	addi	s0,s0,140 # 800007b8 <__init_array_end>
80000734:	00000497          	auipc	s1,0x0
80000738:	08448493          	addi	s1,s1,132 # 800007b8 <__init_array_end>
8000073c:	408484b3          	sub	s1,s1,s0
80000740:	01212023          	sw	s2,0(sp)
80000744:	00112623          	sw	ra,12(sp)
80000748:	4024d493          	srai	s1,s1,0x2
8000074c:	00000913          	li	s2,0
80000750:	04991063          	bne	s2,s1,80000790 <__libc_init_array+0x70>
80000754:	00000417          	auipc	s0,0x0
80000758:	06440413          	addi	s0,s0,100 # 800007b8 <__init_array_end>
8000075c:	00000497          	auipc	s1,0x0
80000760:	05c48493          	addi	s1,s1,92 # 800007b8 <__init_array_end>
80000764:	408484b3          	sub	s1,s1,s0
80000768:	911ff0ef          	jal	ra,80000078 <_init>
8000076c:	4024d493          	srai	s1,s1,0x2
80000770:	00000913          	li	s2,0
80000774:	02991863          	bne	s2,s1,800007a4 <__libc_init_array+0x84>
80000778:	00c12083          	lw	ra,12(sp)
8000077c:	00812403          	lw	s0,8(sp)
80000780:	00412483          	lw	s1,4(sp)
80000784:	00012903          	lw	s2,0(sp)
80000788:	01010113          	addi	sp,sp,16
8000078c:	00008067          	ret
80000790:	00042783          	lw	a5,0(s0)
80000794:	00190913          	addi	s2,s2,1
80000798:	00440413          	addi	s0,s0,4
8000079c:	000780e7          	jalr	a5
800007a0:	fb1ff06f          	j	80000750 <__libc_init_array+0x30>
800007a4:	00042783          	lw	a5,0(s0)
800007a8:	00190913          	addi	s2,s2,1
800007ac:	00440413          	addi	s0,s0,4
800007b0:	000780e7          	jalr	a5
800007b4:	fc1ff06f          	j	80000774 <__libc_init_array+0x54>
