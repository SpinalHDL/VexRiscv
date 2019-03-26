
build/emulator.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00001117          	auipc	sp,0x1
80000004:	00010113          	mv	sp,sp
80000008:	00000517          	auipc	a0,0x0
8000000c:	78450513          	addi	a0,a0,1924 # 8000078c <__init_array_end>
80000010:	00000597          	auipc	a1,0x0
80000014:	77c58593          	addi	a1,a1,1916 # 8000078c <__init_array_end>
80000018:	00000617          	auipc	a2,0x0
8000001c:	7e860613          	addi	a2,a2,2024 # 80000800 <__bss_start>
80000020:	00c5fc63          	bleu	a2,a1,80000038 <_start+0x38>
80000024:	00052283          	lw	t0,0(a0)
80000028:	0055a023          	sw	t0,0(a1)
8000002c:	00450513          	addi	a0,a0,4
80000030:	00458593          	addi	a1,a1,4
80000034:	fec5e8e3          	bltu	a1,a2,80000024 <_start+0x24>
80000038:	00000517          	auipc	a0,0x0
8000003c:	7c850513          	addi	a0,a0,1992 # 80000800 <__bss_start>
80000040:	00000597          	auipc	a1,0x0
80000044:	7c058593          	addi	a1,a1,1984 # 80000800 <__bss_start>
80000048:	00b57863          	bleu	a1,a0,80000058 <_start+0x58>
8000004c:	00052023          	sw	zero,0(a0)
80000050:	00450513          	addi	a0,a0,4
80000054:	feb56ce3          	bltu	a0,a1,8000004c <_start+0x4c>
80000058:	69c000ef          	jal	ra,800006f4 <__libc_init_array>
8000005c:	128000ef          	jal	ra,80000184 <init>
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
80000080:	00012023          	sw	zero,0(sp) # 80001000 <_sp>
80000084:	00112223          	sw	ra,4(sp)
80000088:	00312623          	sw	gp,12(sp)
8000008c:	00412823          	sw	tp,16(sp)
80000090:	00512a23          	sw	t0,20(sp)
80000094:	00612c23          	sw	t1,24(sp)
80000098:	00712e23          	sw	t2,28(sp)
8000009c:	02812023          	sw	s0,32(sp)
800000a0:	02912223          	sw	s1,36(sp)
800000a4:	02a12423          	sw	a0,40(sp)
800000a8:	02b12623          	sw	a1,44(sp)
800000ac:	02c12823          	sw	a2,48(sp)
800000b0:	02d12a23          	sw	a3,52(sp)
800000b4:	02e12c23          	sw	a4,56(sp)
800000b8:	02f12e23          	sw	a5,60(sp)
800000bc:	05012023          	sw	a6,64(sp)
800000c0:	05112223          	sw	a7,68(sp)
800000c4:	05212423          	sw	s2,72(sp)
800000c8:	05312623          	sw	s3,76(sp)
800000cc:	05412823          	sw	s4,80(sp)
800000d0:	05512a23          	sw	s5,84(sp)
800000d4:	05612c23          	sw	s6,88(sp)
800000d8:	05712e23          	sw	s7,92(sp)
800000dc:	07812023          	sw	s8,96(sp)
800000e0:	07912223          	sw	s9,100(sp)
800000e4:	07a12423          	sw	s10,104(sp)
800000e8:	07b12623          	sw	s11,108(sp)
800000ec:	07c12823          	sw	t3,112(sp)
800000f0:	07d12a23          	sw	t4,116(sp)
800000f4:	07e12c23          	sw	t5,120(sp)
800000f8:	07f12e23          	sw	t6,124(sp)
800000fc:	1ec000ef          	jal	ra,800002e8 <trap>
80000100:	00012003          	lw	zero,0(sp)
80000104:	00412083          	lw	ra,4(sp)
80000108:	00c12183          	lw	gp,12(sp)
8000010c:	01012203          	lw	tp,16(sp)
80000110:	01412283          	lw	t0,20(sp)
80000114:	01812303          	lw	t1,24(sp)
80000118:	01c12383          	lw	t2,28(sp)
8000011c:	02012403          	lw	s0,32(sp)
80000120:	02412483          	lw	s1,36(sp)
80000124:	02812503          	lw	a0,40(sp)
80000128:	02c12583          	lw	a1,44(sp)
8000012c:	03012603          	lw	a2,48(sp)
80000130:	03412683          	lw	a3,52(sp)
80000134:	03812703          	lw	a4,56(sp)
80000138:	03c12783          	lw	a5,60(sp)
8000013c:	04012803          	lw	a6,64(sp)
80000140:	04412883          	lw	a7,68(sp)
80000144:	04812903          	lw	s2,72(sp)
80000148:	04c12983          	lw	s3,76(sp)
8000014c:	05012a03          	lw	s4,80(sp)
80000150:	05412a83          	lw	s5,84(sp)
80000154:	05812b03          	lw	s6,88(sp)
80000158:	05c12b83          	lw	s7,92(sp)
8000015c:	06012c03          	lw	s8,96(sp)
80000160:	06412c83          	lw	s9,100(sp)
80000164:	06812d03          	lw	s10,104(sp)
80000168:	06c12d83          	lw	s11,108(sp)
8000016c:	07012e03          	lw	t3,112(sp)
80000170:	07412e83          	lw	t4,116(sp)
80000174:	07812f03          	lw	t5,120(sp)
80000178:	07c12f83          	lw	t6,124(sp)
8000017c:	34011173          	csrrw	sp,mscratch,sp
80000180:	30200073          	mret

Disassembly of section .text:

80000184 <init>:
80000184:	800007b7          	lui	a5,0x80000
80000188:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff07c>
8000018c:	30579073          	csrw	mtvec,a5
80000190:	800017b7          	lui	a5,0x80001
80000194:	f8078793          	addi	a5,a5,-128 # 80000f80 <_sp+0xffffff80>
80000198:	34079073          	csrw	mscratch,a5
8000019c:	000017b7          	lui	a5,0x1
800001a0:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
800001a4:	30079073          	csrw	mstatus,a5
800001a8:	30405073          	csrwi	mie,0
800001ac:	c00007b7          	lui	a5,0xc0000
800001b0:	34179073          	csrw	mepc,a5
800001b4:	0000b7b7          	lui	a5,0xb
800001b8:	10078793          	addi	a5,a5,256 # b100 <__stack_size+0xa900>
800001bc:	30279073          	csrw	medeleg,a5
800001c0:	02000793          	li	a5,32
800001c4:	30379073          	csrw	mideleg,a5
800001c8:	14305073          	csrwi	sbadaddr,0
800001cc:	00008067          	ret

800001d0 <readRegister>:
800001d0:	800017b7          	lui	a5,0x80001
800001d4:	f8078793          	addi	a5,a5,-128 # 80000f80 <_sp+0xffffff80>
800001d8:	00251513          	slli	a0,a0,0x2
800001dc:	00f50533          	add	a0,a0,a5
800001e0:	00052503          	lw	a0,0(a0)
800001e4:	00008067          	ret

800001e8 <writeRegister>:
800001e8:	800017b7          	lui	a5,0x80001
800001ec:	00251513          	slli	a0,a0,0x2
800001f0:	f8078793          	addi	a5,a5,-128 # 80000f80 <_sp+0xffffff80>
800001f4:	00f50533          	add	a0,a0,a5
800001f8:	00b52023          	sw	a1,0(a0)
800001fc:	00008067          	ret

80000200 <redirectTrap>:
80000200:	ff010113          	addi	sp,sp,-16
80000204:	00112623          	sw	ra,12(sp)
80000208:	4b4000ef          	jal	ra,800006bc <stopSim>
8000020c:	343027f3          	csrr	a5,mbadaddr
80000210:	14379073          	csrw	sbadaddr,a5
80000214:	341027f3          	csrr	a5,mepc
80000218:	14179073          	csrw	sepc,a5
8000021c:	342027f3          	csrr	a5,mcause
80000220:	14279073          	csrw	scause,a5
80000224:	105027f3          	csrr	a5,stvec
80000228:	34179073          	csrw	mepc,a5
8000022c:	00c12083          	lw	ra,12(sp)
80000230:	01010113          	addi	sp,sp,16
80000234:	00008067          	ret

80000238 <emulationTrapToSupervisorTrap>:
80000238:	343027f3          	csrr	a5,mbadaddr
8000023c:	14379073          	csrw	sbadaddr,a5
80000240:	342027f3          	csrr	a5,mcause
80000244:	14279073          	csrw	scause,a5
80000248:	14151073          	csrw	sepc,a0
8000024c:	105027f3          	csrr	a5,stvec
80000250:	34179073          	csrw	mepc,a5
80000254:	10000793          	li	a5,256
80000258:	1007b073          	csrc	sstatus,a5
8000025c:	0035d593          	srli	a1,a1,0x3
80000260:	1005f593          	andi	a1,a1,256
80000264:	1005a073          	csrs	sstatus,a1
80000268:	000027b7          	lui	a5,0x2
8000026c:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
80000270:	3007b073          	csrc	mstatus,a5
80000274:	000087b7          	lui	a5,0x8
80000278:	08078793          	addi	a5,a5,128 # 8080 <__stack_size+0x7880>
8000027c:	3007a073          	csrs	mstatus,a5
80000280:	00008067          	ret

80000284 <readWord>:
80000284:	00020737          	lui	a4,0x20
80000288:	30072073          	csrs	mstatus,a4
8000028c:	00000717          	auipc	a4,0x0
80000290:	01870713          	addi	a4,a4,24 # 800002a4 <readWord+0x20>
80000294:	34171073          	csrw	mepc,a4
80000298:	00100693          	li	a3,1
8000029c:	00052783          	lw	a5,0(a0)
800002a0:	00000693          	li	a3,0
800002a4:	00020737          	lui	a4,0x20
800002a8:	30073073          	csrc	mstatus,a4
800002ac:	00068513          	mv	a0,a3
800002b0:	00f5a023          	sw	a5,0(a1) # 81000000 <_sp+0xfff000>
800002b4:	00008067          	ret

800002b8 <writeWord>:
800002b8:	00020737          	lui	a4,0x20
800002bc:	30072073          	csrs	mstatus,a4
800002c0:	00000717          	auipc	a4,0x0
800002c4:	01870713          	addi	a4,a4,24 # 800002d8 <writeWord+0x20>
800002c8:	34171073          	csrw	mepc,a4
800002cc:	00100793          	li	a5,1
800002d0:	00b52023          	sw	a1,0(a0)
800002d4:	00000793          	li	a5,0
800002d8:	00020737          	lui	a4,0x20
800002dc:	30073073          	csrc	mstatus,a4
800002e0:	00078513          	mv	a0,a5
800002e4:	00008067          	ret

800002e8 <trap>:
800002e8:	fe010113          	addi	sp,sp,-32
800002ec:	00112e23          	sw	ra,28(sp)
800002f0:	00812c23          	sw	s0,24(sp)
800002f4:	00912a23          	sw	s1,20(sp)
800002f8:	01212823          	sw	s2,16(sp)
800002fc:	01312623          	sw	s3,12(sp)
80000300:	342027f3          	csrr	a5,mcause
80000304:	1407ce63          	bltz	a5,80000460 <trap+0x178>
80000308:	00200713          	li	a4,2
8000030c:	04e78463          	beq	a5,a4,80000354 <trap+0x6c>
80000310:	00900693          	li	a3,9
80000314:	10d79663          	bne	a5,a3,80000420 <trap+0x138>
80000318:	800017b7          	lui	a5,0x80001
8000031c:	00078793          	mv	a5,a5
80000320:	fc47a683          	lw	a3,-60(a5) # 80000fc4 <_sp+0xffffffc4>
80000324:	00100613          	li	a2,1
80000328:	fa87a503          	lw	a0,-88(a5)
8000032c:	1ec68663          	beq	a3,a2,80000518 <trap+0x230>
80000330:	22e68463          	beq	a3,a4,80000558 <trap+0x270>
80000334:	1e068e63          	beqz	a3,80000530 <trap+0x248>
80000338:	01812403          	lw	s0,24(sp)
8000033c:	01c12083          	lw	ra,28(sp)
80000340:	01412483          	lw	s1,20(sp)
80000344:	01012903          	lw	s2,16(sp)
80000348:	00c12983          	lw	s3,12(sp)
8000034c:	02010113          	addi	sp,sp,32
80000350:	36c0006f          	j	800006bc <stopSim>
80000354:	341024f3          	csrr	s1,mepc
80000358:	300025f3          	csrr	a1,mstatus
8000035c:	34302473          	csrr	s0,mbadaddr
80000360:	02f00613          	li	a2,47
80000364:	07f47693          	andi	a3,s0,127
80000368:	00c45713          	srli	a4,s0,0xc
8000036c:	12c68663          	beq	a3,a2,80000498 <trap+0x1b0>
80000370:	07300613          	li	a2,115
80000374:	0ac69663          	bne	a3,a2,80000420 <trap+0x138>
80000378:	00377713          	andi	a4,a4,3
8000037c:	24f70063          	beq	a4,a5,800005bc <trap+0x2d4>
80000380:	00300793          	li	a5,3
80000384:	22f70c63          	beq	a4,a5,800005bc <trap+0x2d4>
80000388:	00100993          	li	s3,1
8000038c:	03370463          	beq	a4,s3,800003b4 <trap+0xcc>
80000390:	32c000ef          	jal	ra,800006bc <stopSim>
80000394:	343027f3          	csrr	a5,mbadaddr
80000398:	14379073          	csrw	sbadaddr,a5
8000039c:	341027f3          	csrr	a5,mepc
800003a0:	14179073          	csrw	sepc,a5
800003a4:	342027f3          	csrr	a5,mcause
800003a8:	14279073          	csrw	scause,a5
800003ac:	105027f3          	csrr	a5,stvec
800003b0:	34179073          	csrw	mepc,a5
800003b4:	000017b7          	lui	a5,0x1
800003b8:	01445713          	srli	a4,s0,0x14
800003bc:	c0178693          	addi	a3,a5,-1023 # c01 <__stack_size+0x401>
800003c0:	2ed70863          	beq	a4,a3,800006b0 <trap+0x3c8>
800003c4:	c8178793          	addi	a5,a5,-895
800003c8:	2cf71063          	bne	a4,a5,80000688 <trap+0x3a0>
800003cc:	308000ef          	jal	ra,800006d4 <rdtimeh>
800003d0:	00050913          	mv	s2,a0
800003d4:	02098463          	beqz	s3,800003fc <trap+0x114>
800003d8:	2e4000ef          	jal	ra,800006bc <stopSim>
800003dc:	343027f3          	csrr	a5,mbadaddr
800003e0:	14379073          	csrw	sbadaddr,a5
800003e4:	341027f3          	csrr	a5,mepc
800003e8:	14179073          	csrw	sepc,a5
800003ec:	342027f3          	csrr	a5,mcause
800003f0:	14279073          	csrw	scause,a5
800003f4:	105027f3          	csrr	a5,stvec
800003f8:	34179073          	csrw	mepc,a5
800003fc:	00545413          	srli	s0,s0,0x5
80000400:	800017b7          	lui	a5,0x80001
80000404:	07c47413          	andi	s0,s0,124
80000408:	f8078793          	addi	a5,a5,-128 # 80000f80 <_sp+0xffffff80>
8000040c:	00f40433          	add	s0,s0,a5
80000410:	01242023          	sw	s2,0(s0)
80000414:	00448493          	addi	s1,s1,4
80000418:	34149073          	csrw	mepc,s1
8000041c:	0280006f          	j	80000444 <trap+0x15c>
80000420:	29c000ef          	jal	ra,800006bc <stopSim>
80000424:	343027f3          	csrr	a5,mbadaddr
80000428:	14379073          	csrw	sbadaddr,a5
8000042c:	341027f3          	csrr	a5,mepc
80000430:	14179073          	csrw	sepc,a5
80000434:	342027f3          	csrr	a5,mcause
80000438:	14279073          	csrw	scause,a5
8000043c:	105027f3          	csrr	a5,stvec
80000440:	34179073          	csrw	mepc,a5
80000444:	01c12083          	lw	ra,28(sp)
80000448:	01812403          	lw	s0,24(sp)
8000044c:	01412483          	lw	s1,20(sp)
80000450:	01012903          	lw	s2,16(sp)
80000454:	00c12983          	lw	s3,12(sp)
80000458:	02010113          	addi	sp,sp,32
8000045c:	00008067          	ret
80000460:	0ff7f793          	andi	a5,a5,255
80000464:	00700713          	li	a4,7
80000468:	fae79ce3          	bne	a5,a4,80000420 <trap+0x138>
8000046c:	02000793          	li	a5,32
80000470:	1447a073          	csrs	sip,a5
80000474:	08000793          	li	a5,128
80000478:	3047b073          	csrc	mie,a5
8000047c:	01c12083          	lw	ra,28(sp)
80000480:	01812403          	lw	s0,24(sp)
80000484:	01412483          	lw	s1,20(sp)
80000488:	01012903          	lw	s2,16(sp)
8000048c:	00c12983          	lw	s3,12(sp)
80000490:	02010113          	addi	sp,sp,32
80000494:	00008067          	ret
80000498:	00777713          	andi	a4,a4,7
8000049c:	f8f712e3          	bne	a4,a5,80000420 <trap+0x138>
800004a0:	00d45713          	srli	a4,s0,0xd
800004a4:	01245793          	srli	a5,s0,0x12
800004a8:	800016b7          	lui	a3,0x80001
800004ac:	f8068693          	addi	a3,a3,-128 # 80000f80 <_sp+0xffffff80>
800004b0:	07c77713          	andi	a4,a4,124
800004b4:	07c7f793          	andi	a5,a5,124
800004b8:	00d70733          	add	a4,a4,a3
800004bc:	00d787b3          	add	a5,a5,a3
800004c0:	00072703          	lw	a4,0(a4) # 20000 <__stack_size+0x1f800>
800004c4:	0007a603          	lw	a2,0(a5)
800004c8:	00020537          	lui	a0,0x20
800004cc:	30052073          	csrs	mstatus,a0
800004d0:	00000517          	auipc	a0,0x0
800004d4:	01850513          	addi	a0,a0,24 # 800004e8 <trap+0x200>
800004d8:	34151073          	csrw	mepc,a0
800004dc:	00100793          	li	a5,1
800004e0:	00072803          	lw	a6,0(a4)
800004e4:	00000793          	li	a5,0
800004e8:	00020537          	lui	a0,0x20
800004ec:	30053073          	csrc	mstatus,a0
800004f0:	08079063          	bnez	a5,80000570 <trap+0x288>
800004f4:	01b45793          	srli	a5,s0,0x1b
800004f8:	01c00513          	li	a0,28
800004fc:	f2f562e3          	bltu	a0,a5,80000420 <trap+0x138>
80000500:	80000537          	lui	a0,0x80000
80000504:	00279793          	slli	a5,a5,0x2
80000508:	78c50513          	addi	a0,a0,1932 # 8000078c <_sp+0xfffff78c>
8000050c:	00a787b3          	add	a5,a5,a0
80000510:	0007a783          	lw	a5,0(a5)
80000514:	00078067          	jr	a5
80000518:	0ff57513          	andi	a0,a0,255
8000051c:	1a8000ef          	jal	ra,800006c4 <putC>
80000520:	341027f3          	csrr	a5,mepc
80000524:	00478793          	addi	a5,a5,4
80000528:	34179073          	csrw	mepc,a5
8000052c:	f19ff06f          	j	80000444 <trap+0x15c>
80000530:	fac7a583          	lw	a1,-84(a5)
80000534:	1a8000ef          	jal	ra,800006dc <setMachineTimerCmp>
80000538:	08000793          	li	a5,128
8000053c:	3047a073          	csrs	mie,a5
80000540:	02000793          	li	a5,32
80000544:	1447b073          	csrc	sip,a5
80000548:	341027f3          	csrr	a5,mepc
8000054c:	00478793          	addi	a5,a5,4
80000550:	34179073          	csrw	mepc,a5
80000554:	ef1ff06f          	j	80000444 <trap+0x15c>
80000558:	fff00713          	li	a4,-1
8000055c:	fae7a423          	sw	a4,-88(a5)
80000560:	341027f3          	csrr	a5,mepc
80000564:	00478793          	addi	a5,a5,4
80000568:	34179073          	csrw	mepc,a5
8000056c:	ed9ff06f          	j	80000444 <trap+0x15c>
80000570:	343027f3          	csrr	a5,mbadaddr
80000574:	14379073          	csrw	sbadaddr,a5
80000578:	342027f3          	csrr	a5,mcause
8000057c:	14279073          	csrw	scause,a5
80000580:	14149073          	csrw	sepc,s1
80000584:	105027f3          	csrr	a5,stvec
80000588:	34179073          	csrw	mepc,a5
8000058c:	10000793          	li	a5,256
80000590:	1007b073          	csrc	sstatus,a5
80000594:	0035d593          	srli	a1,a1,0x3
80000598:	1005f593          	andi	a1,a1,256
8000059c:	1005a073          	csrs	sstatus,a1
800005a0:	000027b7          	lui	a5,0x2
800005a4:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
800005a8:	3007b073          	csrc	mstatus,a5
800005ac:	000087b7          	lui	a5,0x8
800005b0:	08078793          	addi	a5,a5,128 # 8080 <__stack_size+0x7880>
800005b4:	3007a073          	csrs	mstatus,a5
800005b8:	e8dff06f          	j	80000444 <trap+0x15c>
800005bc:	00f45993          	srli	s3,s0,0xf
800005c0:	01f9f993          	andi	s3,s3,31
800005c4:	013039b3          	snez	s3,s3
800005c8:	dedff06f          	j	800003b4 <trap+0xcc>
800005cc:	01060633          	add	a2,a2,a6
800005d0:	00545413          	srli	s0,s0,0x5
800005d4:	07c47413          	andi	s0,s0,124
800005d8:	00d406b3          	add	a3,s0,a3
800005dc:	0106a023          	sw	a6,0(a3)
800005e0:	000206b7          	lui	a3,0x20
800005e4:	3006a073          	csrs	mstatus,a3
800005e8:	00000697          	auipc	a3,0x0
800005ec:	01868693          	addi	a3,a3,24 # 80000600 <trap+0x318>
800005f0:	34169073          	csrw	mepc,a3
800005f4:	00100793          	li	a5,1
800005f8:	00c72023          	sw	a2,0(a4)
800005fc:	00000793          	li	a5,0
80000600:	000206b7          	lui	a3,0x20
80000604:	3006b073          	csrc	mstatus,a3
80000608:	e00786e3          	beqz	a5,80000414 <trap+0x12c>
8000060c:	343027f3          	csrr	a5,mbadaddr
80000610:	14379073          	csrw	sbadaddr,a5
80000614:	342027f3          	csrr	a5,mcause
80000618:	14279073          	csrw	scause,a5
8000061c:	14149073          	csrw	sepc,s1
80000620:	105027f3          	csrr	a5,stvec
80000624:	34179073          	csrw	mepc,a5
80000628:	10000793          	li	a5,256
8000062c:	1007b073          	csrc	sstatus,a5
80000630:	0035d793          	srli	a5,a1,0x3
80000634:	1007f793          	andi	a5,a5,256
80000638:	1007a073          	csrs	sstatus,a5
8000063c:	f65ff06f          	j	800005a0 <trap+0x2b8>
80000640:	f90678e3          	bleu	a6,a2,800005d0 <trap+0x2e8>
80000644:	00080613          	mv	a2,a6
80000648:	f89ff06f          	j	800005d0 <trap+0x2e8>
8000064c:	01066633          	or	a2,a2,a6
80000650:	f81ff06f          	j	800005d0 <trap+0x2e8>
80000654:	01064633          	xor	a2,a2,a6
80000658:	f79ff06f          	j	800005d0 <trap+0x2e8>
8000065c:	f6c87ae3          	bleu	a2,a6,800005d0 <trap+0x2e8>
80000660:	00080613          	mv	a2,a6
80000664:	f6dff06f          	j	800005d0 <trap+0x2e8>
80000668:	f70654e3          	ble	a6,a2,800005d0 <trap+0x2e8>
8000066c:	00080613          	mv	a2,a6
80000670:	f61ff06f          	j	800005d0 <trap+0x2e8>
80000674:	f4c85ee3          	ble	a2,a6,800005d0 <trap+0x2e8>
80000678:	00080613          	mv	a2,a6
8000067c:	f55ff06f          	j	800005d0 <trap+0x2e8>
80000680:	01067633          	and	a2,a2,a6
80000684:	f4dff06f          	j	800005d0 <trap+0x2e8>
80000688:	034000ef          	jal	ra,800006bc <stopSim>
8000068c:	343027f3          	csrr	a5,mbadaddr
80000690:	14379073          	csrw	sbadaddr,a5
80000694:	341027f3          	csrr	a5,mepc
80000698:	14179073          	csrw	sepc,a5
8000069c:	342027f3          	csrr	a5,mcause
800006a0:	14279073          	csrw	scause,a5
800006a4:	105027f3          	csrr	a5,stvec
800006a8:	34179073          	csrw	mepc,a5
800006ac:	d29ff06f          	j	800003d4 <trap+0xec>
800006b0:	01c000ef          	jal	ra,800006cc <rdtime>
800006b4:	00050913          	mv	s2,a0
800006b8:	d1dff06f          	j	800003d4 <trap+0xec>

800006bc <stopSim>:
800006bc:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7fffeffc>
800006c0:	00008067          	ret

800006c4 <putC>:
800006c4:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7fffeff8>
800006c8:	00008067          	ret

800006cc <rdtime>:
800006cc:	fe002503          	lw	a0,-32(zero) # ffffffe0 <_sp+0x7fffefe0>
800006d0:	00008067          	ret

800006d4 <rdtimeh>:
800006d4:	fe402503          	lw	a0,-28(zero) # ffffffe4 <_sp+0x7fffefe4>
800006d8:	00008067          	ret

800006dc <setMachineTimerCmp>:
800006dc:	fec00793          	li	a5,-20
800006e0:	fff00713          	li	a4,-1
800006e4:	00e7a023          	sw	a4,0(a5)
800006e8:	fea02423          	sw	a0,-24(zero) # ffffffe8 <_sp+0x7fffefe8>
800006ec:	00b7a023          	sw	a1,0(a5)
800006f0:	00008067          	ret

800006f4 <__libc_init_array>:
800006f4:	ff010113          	addi	sp,sp,-16
800006f8:	00812423          	sw	s0,8(sp)
800006fc:	00912223          	sw	s1,4(sp)
80000700:	00000417          	auipc	s0,0x0
80000704:	08c40413          	addi	s0,s0,140 # 8000078c <__init_array_end>
80000708:	00000497          	auipc	s1,0x0
8000070c:	08448493          	addi	s1,s1,132 # 8000078c <__init_array_end>
80000710:	408484b3          	sub	s1,s1,s0
80000714:	01212023          	sw	s2,0(sp)
80000718:	00112623          	sw	ra,12(sp)
8000071c:	4024d493          	srai	s1,s1,0x2
80000720:	00000913          	li	s2,0
80000724:	04991063          	bne	s2,s1,80000764 <__libc_init_array+0x70>
80000728:	00000417          	auipc	s0,0x0
8000072c:	06440413          	addi	s0,s0,100 # 8000078c <__init_array_end>
80000730:	00000497          	auipc	s1,0x0
80000734:	05c48493          	addi	s1,s1,92 # 8000078c <__init_array_end>
80000738:	408484b3          	sub	s1,s1,s0
8000073c:	93dff0ef          	jal	ra,80000078 <_init>
80000740:	4024d493          	srai	s1,s1,0x2
80000744:	00000913          	li	s2,0
80000748:	02991863          	bne	s2,s1,80000778 <__libc_init_array+0x84>
8000074c:	00c12083          	lw	ra,12(sp)
80000750:	00812403          	lw	s0,8(sp)
80000754:	00412483          	lw	s1,4(sp)
80000758:	00012903          	lw	s2,0(sp)
8000075c:	01010113          	addi	sp,sp,16
80000760:	00008067          	ret
80000764:	00042783          	lw	a5,0(s0)
80000768:	00190913          	addi	s2,s2,1
8000076c:	00440413          	addi	s0,s0,4
80000770:	000780e7          	jalr	a5
80000774:	fb1ff06f          	j	80000724 <__libc_init_array+0x30>
80000778:	00042783          	lw	a5,0(s0)
8000077c:	00190913          	addi	s2,s2,1
80000780:	00440413          	addi	s0,s0,4
80000784:	000780e7          	jalr	a5
80000788:	fc1ff06f          	j	80000748 <__libc_init_array+0x54>
