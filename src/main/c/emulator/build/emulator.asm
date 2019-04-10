
build/emulator.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00001117          	auipc	sp,0x1
80000004:	12810113          	addi	sp,sp,296 # 80001128 <_sp>
80000008:	00001517          	auipc	a0,0x1
8000000c:	87c50513          	addi	a0,a0,-1924 # 80000884 <__init_array_end>
80000010:	00001597          	auipc	a1,0x1
80000014:	87458593          	addi	a1,a1,-1932 # 80000884 <__init_array_end>
80000018:	00001617          	auipc	a2,0x1
8000001c:	91060613          	addi	a2,a2,-1776 # 80000928 <__bss_start>
80000020:	00c5fc63          	bgeu	a1,a2,80000038 <_start+0x38>
80000024:	00052283          	lw	t0,0(a0)
80000028:	0055a023          	sw	t0,0(a1)
8000002c:	00450513          	addi	a0,a0,4
80000030:	00458593          	addi	a1,a1,4
80000034:	fec5e8e3          	bltu	a1,a2,80000024 <_start+0x24>
80000038:	00001517          	auipc	a0,0x1
8000003c:	8f050513          	addi	a0,a0,-1808 # 80000928 <__bss_start>
80000040:	00001597          	auipc	a1,0x1
80000044:	8e858593          	addi	a1,a1,-1816 # 80000928 <__bss_start>
80000048:	00b57863          	bgeu	a0,a1,80000058 <_start+0x58>
8000004c:	00052023          	sw	zero,0(a0)
80000050:	00450513          	addi	a0,a0,4
80000054:	feb56ce3          	bltu	a0,a1,8000004c <_start+0x4c>
80000058:	784000ef          	jal	ra,800007dc <__libc_init_array>
8000005c:	178000ef          	jal	ra,800001d4 <init>
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
800000f8:	2bc000ef          	jal	ra,800003b4 <trap>
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
80000198:	608000ef          	jal	ra,800007a0 <putC>
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
800001c4:	30529073          	csrw	mtvec,t0
800001c8:	3b071073          	csrw	pmpaddr0,a4
800001cc:	3a079073          	csrw	pmpcfg0,a5
800001d0:	00008067          	ret

800001d4 <init>:
800001d4:	ff010113          	addi	sp,sp,-16
800001d8:	00112623          	sw	ra,12(sp)
800001dc:	00812423          	sw	s0,8(sp)
800001e0:	01f00793          	li	a5,31
800001e4:	fff00713          	li	a4,-1
800001e8:	00000297          	auipc	t0,0x0
800001ec:	01428293          	addi	t0,t0,20 # 800001fc <init+0x28>
800001f0:	30529073          	csrw	mtvec,t0
800001f4:	3b071073          	csrw	pmpaddr0,a4
800001f8:	3a079073          	csrw	pmpcfg0,a5
800001fc:	80001437          	lui	s0,0x80001
80000200:	5d8000ef          	jal	ra,800007d8 <halInit>
80000204:	8f840413          	addi	s0,s0,-1800 # 800008f8 <_sp+0xfffff7d0>
80000208:	02a00513          	li	a0,42
8000020c:	00140413          	addi	s0,s0,1
80000210:	590000ef          	jal	ra,800007a0 <putC>
80000214:	00044503          	lbu	a0,0(s0)
80000218:	fe051ae3          	bnez	a0,8000020c <init+0x38>
8000021c:	800007b7          	lui	a5,0x80000
80000220:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef54>
80000224:	30579073          	csrw	mtvec,a5
80000228:	800017b7          	lui	a5,0x80001
8000022c:	0a878793          	addi	a5,a5,168 # 800010a8 <_sp+0xffffff80>
80000230:	34079073          	csrw	mscratch,a5
80000234:	000017b7          	lui	a5,0x1
80000238:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
8000023c:	30079073          	csrw	mstatus,a5
80000240:	30405073          	csrwi	mie,0
80000244:	c00007b7          	lui	a5,0xc0000
80000248:	34179073          	csrw	mepc,a5
8000024c:	0000b7b7          	lui	a5,0xb
80000250:	10078793          	addi	a5,a5,256 # b100 <__stack_size+0xa900>
80000254:	30279073          	csrw	medeleg,a5
80000258:	22200793          	li	a5,546
8000025c:	30379073          	csrw	mideleg,a5
80000260:	14305073          	csrwi	stval,0
80000264:	80001437          	lui	s0,0x80001
80000268:	91040413          	addi	s0,s0,-1776 # 80000910 <_sp+0xfffff7e8>
8000026c:	02a00513          	li	a0,42
80000270:	00140413          	addi	s0,s0,1
80000274:	52c000ef          	jal	ra,800007a0 <putC>
80000278:	00044503          	lbu	a0,0(s0)
8000027c:	fe051ae3          	bnez	a0,80000270 <init+0x9c>
80000280:	00c12083          	lw	ra,12(sp)
80000284:	00812403          	lw	s0,8(sp)
80000288:	01010113          	addi	sp,sp,16
8000028c:	00008067          	ret

80000290 <readRegister>:
80000290:	800017b7          	lui	a5,0x80001
80000294:	0a878793          	addi	a5,a5,168 # 800010a8 <_sp+0xffffff80>
80000298:	00251513          	slli	a0,a0,0x2
8000029c:	00f50533          	add	a0,a0,a5
800002a0:	00052503          	lw	a0,0(a0)
800002a4:	00008067          	ret

800002a8 <writeRegister>:
800002a8:	800017b7          	lui	a5,0x80001
800002ac:	00251513          	slli	a0,a0,0x2
800002b0:	0a878793          	addi	a5,a5,168 # 800010a8 <_sp+0xffffff80>
800002b4:	00f50533          	add	a0,a0,a5
800002b8:	00b52023          	sw	a1,0(a0)
800002bc:	00008067          	ret

800002c0 <redirectTrap>:
800002c0:	ff010113          	addi	sp,sp,-16
800002c4:	00112623          	sw	ra,12(sp)
800002c8:	4d0000ef          	jal	ra,80000798 <stopSim>
800002cc:	343027f3          	csrr	a5,mtval
800002d0:	14379073          	csrw	stval,a5
800002d4:	341027f3          	csrr	a5,mepc
800002d8:	14179073          	csrw	sepc,a5
800002dc:	342027f3          	csrr	a5,mcause
800002e0:	14279073          	csrw	scause,a5
800002e4:	105027f3          	csrr	a5,stvec
800002e8:	34179073          	csrw	mepc,a5
800002ec:	00c12083          	lw	ra,12(sp)
800002f0:	01010113          	addi	sp,sp,16
800002f4:	00008067          	ret

800002f8 <emulationTrapToSupervisorTrap>:
800002f8:	800007b7          	lui	a5,0x80000
800002fc:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef54>
80000300:	30579073          	csrw	mtvec,a5
80000304:	343027f3          	csrr	a5,mtval
80000308:	14379073          	csrw	stval,a5
8000030c:	342027f3          	csrr	a5,mcause
80000310:	14279073          	csrw	scause,a5
80000314:	14151073          	csrw	sepc,a0
80000318:	105027f3          	csrr	a5,stvec
8000031c:	34179073          	csrw	mepc,a5
80000320:	10000793          	li	a5,256
80000324:	1007b073          	csrc	sstatus,a5
80000328:	0035d593          	srli	a1,a1,0x3
8000032c:	1005f593          	andi	a1,a1,256
80000330:	1005a073          	csrs	sstatus,a1
80000334:	000027b7          	lui	a5,0x2
80000338:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
8000033c:	3007b073          	csrc	mstatus,a5
80000340:	000017b7          	lui	a5,0x1
80000344:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
80000348:	3007a073          	csrs	mstatus,a5
8000034c:	00008067          	ret

80000350 <readWord>:
80000350:	00020737          	lui	a4,0x20
80000354:	30072073          	csrs	mstatus,a4
80000358:	00000717          	auipc	a4,0x0
8000035c:	01870713          	addi	a4,a4,24 # 80000370 <readWord+0x20>
80000360:	30571073          	csrw	mtvec,a4
80000364:	00100693          	li	a3,1
80000368:	00052783          	lw	a5,0(a0)
8000036c:	00000693          	li	a3,0
80000370:	00020737          	lui	a4,0x20
80000374:	30073073          	csrc	mstatus,a4
80000378:	00068513          	mv	a0,a3
8000037c:	00f5a023          	sw	a5,0(a1) # c3000000 <_sp+0x42ffeed8>
80000380:	00008067          	ret

80000384 <writeWord>:
80000384:	00020737          	lui	a4,0x20
80000388:	30072073          	csrs	mstatus,a4
8000038c:	00000717          	auipc	a4,0x0
80000390:	01870713          	addi	a4,a4,24 # 800003a4 <writeWord+0x20>
80000394:	30571073          	csrw	mtvec,a4
80000398:	00100793          	li	a5,1
8000039c:	00b52023          	sw	a1,0(a0)
800003a0:	00000793          	li	a5,0
800003a4:	00020737          	lui	a4,0x20
800003a8:	30073073          	csrc	mstatus,a4
800003ac:	00078513          	mv	a0,a5
800003b0:	00008067          	ret

800003b4 <trap>:
800003b4:	fe010113          	addi	sp,sp,-32
800003b8:	00112e23          	sw	ra,28(sp)
800003bc:	00812c23          	sw	s0,24(sp)
800003c0:	00912a23          	sw	s1,20(sp)
800003c4:	01212823          	sw	s2,16(sp)
800003c8:	01312623          	sw	s3,12(sp)
800003cc:	342027f3          	csrr	a5,mcause
800003d0:	0807cc63          	bltz	a5,80000468 <trap+0xb4>
800003d4:	00200713          	li	a4,2
800003d8:	0ce78463          	beq	a5,a4,800004a0 <trap+0xec>
800003dc:	00900693          	li	a3,9
800003e0:	04d79463          	bne	a5,a3,80000428 <trap+0x74>
800003e4:	80001437          	lui	s0,0x80001
800003e8:	12840413          	addi	s0,s0,296 # 80001128 <_sp+0x0>
800003ec:	fc442783          	lw	a5,-60(s0)
800003f0:	00100693          	li	a3,1
800003f4:	fa842503          	lw	a0,-88(s0)
800003f8:	2ed78463          	beq	a5,a3,800006e0 <trap+0x32c>
800003fc:	2ee78e63          	beq	a5,a4,800006f8 <trap+0x344>
80000400:	2a078c63          	beqz	a5,800006b8 <trap+0x304>
80000404:	01812403          	lw	s0,24(sp)
80000408:	01c12083          	lw	ra,28(sp)
8000040c:	01412483          	lw	s1,20(sp)
80000410:	01012903          	lw	s2,16(sp)
80000414:	00c12983          	lw	s3,12(sp)
80000418:	02010113          	addi	sp,sp,32
8000041c:	37c0006f          	j	80000798 <stopSim>
80000420:	00777713          	andi	a4,a4,7
80000424:	12f70c63          	beq	a4,a5,8000055c <trap+0x1a8>
80000428:	370000ef          	jal	ra,80000798 <stopSim>
8000042c:	343027f3          	csrr	a5,mtval
80000430:	14379073          	csrw	stval,a5
80000434:	341027f3          	csrr	a5,mepc
80000438:	14179073          	csrw	sepc,a5
8000043c:	342027f3          	csrr	a5,mcause
80000440:	14279073          	csrw	scause,a5
80000444:	105027f3          	csrr	a5,stvec
80000448:	34179073          	csrw	mepc,a5
8000044c:	01c12083          	lw	ra,28(sp)
80000450:	01812403          	lw	s0,24(sp)
80000454:	01412483          	lw	s1,20(sp)
80000458:	01012903          	lw	s2,16(sp)
8000045c:	00c12983          	lw	s3,12(sp)
80000460:	02010113          	addi	sp,sp,32
80000464:	00008067          	ret
80000468:	0ff7f793          	andi	a5,a5,255
8000046c:	00700713          	li	a4,7
80000470:	fae79ce3          	bne	a5,a4,80000428 <trap+0x74>
80000474:	02000793          	li	a5,32
80000478:	1447a073          	csrs	sip,a5
8000047c:	08000793          	li	a5,128
80000480:	3047b073          	csrc	mie,a5
80000484:	01c12083          	lw	ra,28(sp)
80000488:	01812403          	lw	s0,24(sp)
8000048c:	01412483          	lw	s1,20(sp)
80000490:	01012903          	lw	s2,16(sp)
80000494:	00c12983          	lw	s3,12(sp)
80000498:	02010113          	addi	sp,sp,32
8000049c:	00008067          	ret
800004a0:	341024f3          	csrr	s1,mepc
800004a4:	300025f3          	csrr	a1,mstatus
800004a8:	34302473          	csrr	s0,mtval
800004ac:	02f00613          	li	a2,47
800004b0:	07f47693          	andi	a3,s0,127
800004b4:	00c45713          	srli	a4,s0,0xc
800004b8:	f6c684e3          	beq	a3,a2,80000420 <trap+0x6c>
800004bc:	07300613          	li	a2,115
800004c0:	f6c694e3          	bne	a3,a2,80000428 <trap+0x74>
800004c4:	00377713          	andi	a4,a4,3
800004c8:	10f70c63          	beq	a4,a5,800005e0 <trap+0x22c>
800004cc:	00300793          	li	a5,3
800004d0:	10f70863          	beq	a4,a5,800005e0 <trap+0x22c>
800004d4:	00100993          	li	s3,1
800004d8:	03370463          	beq	a4,s3,80000500 <trap+0x14c>
800004dc:	2bc000ef          	jal	ra,80000798 <stopSim>
800004e0:	343027f3          	csrr	a5,mtval
800004e4:	14379073          	csrw	stval,a5
800004e8:	341027f3          	csrr	a5,mepc
800004ec:	14179073          	csrw	sepc,a5
800004f0:	342027f3          	csrr	a5,mcause
800004f4:	14279073          	csrw	scause,a5
800004f8:	105027f3          	csrr	a5,stvec
800004fc:	34179073          	csrw	mepc,a5
80000500:	00001737          	lui	a4,0x1
80000504:	01445793          	srli	a5,s0,0x14
80000508:	c0070693          	addi	a3,a4,-1024 # c00 <__stack_size+0x400>
8000050c:	0ed7e263          	bltu	a5,a3,800005f0 <trap+0x23c>
80000510:	c0270713          	addi	a4,a4,-1022
80000514:	0cf77063          	bgeu	a4,a5,800005d4 <trap+0x220>
80000518:	fffff737          	lui	a4,0xfffff
8000051c:	38070713          	addi	a4,a4,896 # fffff380 <_sp+0x7fffe258>
80000520:	00e787b3          	add	a5,a5,a4
80000524:	00200713          	li	a4,2
80000528:	0cf76463          	bltu	a4,a5,800005f0 <trap+0x23c>
8000052c:	28c000ef          	jal	ra,800007b8 <rdtimeh>
80000530:	00050913          	mv	s2,a0
80000534:	1c099e63          	bnez	s3,80000710 <trap+0x35c>
80000538:	00545413          	srli	s0,s0,0x5
8000053c:	800017b7          	lui	a5,0x80001
80000540:	0a878793          	addi	a5,a5,168 # 800010a8 <_sp+0xffffff80>
80000544:	07c47413          	andi	s0,s0,124
80000548:	00f40433          	add	s0,s0,a5
8000054c:	01242023          	sw	s2,0(s0)
80000550:	00448493          	addi	s1,s1,4
80000554:	34149073          	csrw	mepc,s1
80000558:	ef5ff06f          	j	8000044c <trap+0x98>
8000055c:	00d45713          	srli	a4,s0,0xd
80000560:	01245793          	srli	a5,s0,0x12
80000564:	800016b7          	lui	a3,0x80001
80000568:	0a868693          	addi	a3,a3,168 # 800010a8 <_sp+0xffffff80>
8000056c:	07c77713          	andi	a4,a4,124
80000570:	07c7f793          	andi	a5,a5,124
80000574:	00d70733          	add	a4,a4,a3
80000578:	00d787b3          	add	a5,a5,a3
8000057c:	00072703          	lw	a4,0(a4)
80000580:	0007a603          	lw	a2,0(a5)
80000584:	00020537          	lui	a0,0x20
80000588:	30052073          	csrs	mstatus,a0
8000058c:	00000517          	auipc	a0,0x0
80000590:	01850513          	addi	a0,a0,24 # 800005a4 <trap+0x1f0>
80000594:	30551073          	csrw	mtvec,a0
80000598:	00100793          	li	a5,1
8000059c:	00072803          	lw	a6,0(a4)
800005a0:	00000793          	li	a5,0
800005a4:	00020537          	lui	a0,0x20
800005a8:	30053073          	csrc	mstatus,a0
800005ac:	18079663          	bnez	a5,80000738 <trap+0x384>
800005b0:	01b45793          	srli	a5,s0,0x1b
800005b4:	01c00513          	li	a0,28
800005b8:	e6f568e3          	bltu	a0,a5,80000428 <trap+0x74>
800005bc:	80001537          	lui	a0,0x80001
800005c0:	00279793          	slli	a5,a5,0x2
800005c4:	88450513          	addi	a0,a0,-1916 # 80000884 <_sp+0xfffff75c>
800005c8:	00a787b3          	add	a5,a5,a0
800005cc:	0007a783          	lw	a5,0(a5)
800005d0:	00078067          	jr	a5
800005d4:	1dc000ef          	jal	ra,800007b0 <rdtime>
800005d8:	00050913          	mv	s2,a0
800005dc:	f59ff06f          	j	80000534 <trap+0x180>
800005e0:	00f45993          	srli	s3,s0,0xf
800005e4:	01f9f993          	andi	s3,s3,31
800005e8:	013039b3          	snez	s3,s3
800005ec:	f15ff06f          	j	80000500 <trap+0x14c>
800005f0:	1a8000ef          	jal	ra,80000798 <stopSim>
800005f4:	343027f3          	csrr	a5,mtval
800005f8:	14379073          	csrw	stval,a5
800005fc:	341027f3          	csrr	a5,mepc
80000600:	14179073          	csrw	sepc,a5
80000604:	342027f3          	csrr	a5,mcause
80000608:	14279073          	csrw	scause,a5
8000060c:	105027f3          	csrr	a5,stvec
80000610:	34179073          	csrw	mepc,a5
80000614:	f21ff06f          	j	80000534 <trap+0x180>
80000618:	01067463          	bgeu	a2,a6,80000620 <trap+0x26c>
8000061c:	00080613          	mv	a2,a6
80000620:	00020537          	lui	a0,0x20
80000624:	30052073          	csrs	mstatus,a0
80000628:	00000517          	auipc	a0,0x0
8000062c:	01850513          	addi	a0,a0,24 # 80000640 <trap+0x28c>
80000630:	30551073          	csrw	mtvec,a0
80000634:	00100793          	li	a5,1
80000638:	00c72023          	sw	a2,0(a4)
8000063c:	00000793          	li	a5,0
80000640:	00020537          	lui	a0,0x20
80000644:	30053073          	csrc	mstatus,a0
80000648:	80000737          	lui	a4,0x80000
8000064c:	07c70713          	addi	a4,a4,124 # 8000007c <_sp+0xffffef54>
80000650:	14079063          	bnez	a5,80000790 <trap+0x3dc>
80000654:	00545793          	srli	a5,s0,0x5
80000658:	07c7f793          	andi	a5,a5,124
8000065c:	00d786b3          	add	a3,a5,a3
80000660:	0106a023          	sw	a6,0(a3)
80000664:	00448493          	addi	s1,s1,4
80000668:	34149073          	csrw	mepc,s1
8000066c:	30571073          	csrw	mtvec,a4
80000670:	dddff06f          	j	8000044c <trap+0x98>
80000674:	01064633          	xor	a2,a2,a6
80000678:	fa9ff06f          	j	80000620 <trap+0x26c>
8000067c:	fac872e3          	bgeu	a6,a2,80000620 <trap+0x26c>
80000680:	00080613          	mv	a2,a6
80000684:	f9dff06f          	j	80000620 <trap+0x26c>
80000688:	f9065ce3          	bge	a2,a6,80000620 <trap+0x26c>
8000068c:	00080613          	mv	a2,a6
80000690:	f91ff06f          	j	80000620 <trap+0x26c>
80000694:	f8c856e3          	bge	a6,a2,80000620 <trap+0x26c>
80000698:	00080613          	mv	a2,a6
8000069c:	f85ff06f          	j	80000620 <trap+0x26c>
800006a0:	01067633          	and	a2,a2,a6
800006a4:	f7dff06f          	j	80000620 <trap+0x26c>
800006a8:	01066633          	or	a2,a2,a6
800006ac:	f75ff06f          	j	80000620 <trap+0x26c>
800006b0:	01060633          	add	a2,a2,a6
800006b4:	f6dff06f          	j	80000620 <trap+0x26c>
800006b8:	fac42583          	lw	a1,-84(s0)
800006bc:	104000ef          	jal	ra,800007c0 <setMachineTimerCmp>
800006c0:	08000793          	li	a5,128
800006c4:	3047a073          	csrs	mie,a5
800006c8:	02000793          	li	a5,32
800006cc:	1447b073          	csrc	sip,a5
800006d0:	341027f3          	csrr	a5,mepc
800006d4:	00478793          	addi	a5,a5,4
800006d8:	34179073          	csrw	mepc,a5
800006dc:	d71ff06f          	j	8000044c <trap+0x98>
800006e0:	0ff57513          	andi	a0,a0,255
800006e4:	0bc000ef          	jal	ra,800007a0 <putC>
800006e8:	341027f3          	csrr	a5,mepc
800006ec:	00478793          	addi	a5,a5,4
800006f0:	34179073          	csrw	mepc,a5
800006f4:	d59ff06f          	j	8000044c <trap+0x98>
800006f8:	0b0000ef          	jal	ra,800007a8 <getC>
800006fc:	faa42423          	sw	a0,-88(s0)
80000700:	341027f3          	csrr	a5,mepc
80000704:	00478793          	addi	a5,a5,4
80000708:	34179073          	csrw	mepc,a5
8000070c:	d41ff06f          	j	8000044c <trap+0x98>
80000710:	088000ef          	jal	ra,80000798 <stopSim>
80000714:	343027f3          	csrr	a5,mtval
80000718:	14379073          	csrw	stval,a5
8000071c:	341027f3          	csrr	a5,mepc
80000720:	14179073          	csrw	sepc,a5
80000724:	342027f3          	csrr	a5,mcause
80000728:	14279073          	csrw	scause,a5
8000072c:	105027f3          	csrr	a5,stvec
80000730:	34179073          	csrw	mepc,a5
80000734:	e05ff06f          	j	80000538 <trap+0x184>
80000738:	800007b7          	lui	a5,0x80000
8000073c:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xffffef54>
80000740:	30579073          	csrw	mtvec,a5
80000744:	343027f3          	csrr	a5,mtval
80000748:	14379073          	csrw	stval,a5
8000074c:	342027f3          	csrr	a5,mcause
80000750:	14279073          	csrw	scause,a5
80000754:	14149073          	csrw	sepc,s1
80000758:	105027f3          	csrr	a5,stvec
8000075c:	34179073          	csrw	mepc,a5
80000760:	10000793          	li	a5,256
80000764:	1007b073          	csrc	sstatus,a5
80000768:	0035d793          	srli	a5,a1,0x3
8000076c:	1007f793          	andi	a5,a5,256
80000770:	1007a073          	csrs	sstatus,a5
80000774:	000027b7          	lui	a5,0x2
80000778:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
8000077c:	3007b073          	csrc	mstatus,a5
80000780:	000017b7          	lui	a5,0x1
80000784:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
80000788:	3007a073          	csrs	mstatus,a5
8000078c:	cc1ff06f          	j	8000044c <trap+0x98>
80000790:	30571073          	csrw	mtvec,a4
80000794:	fb1ff06f          	j	80000744 <trap+0x390>

80000798 <stopSim>:
80000798:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7fffeed4>
8000079c:	0000006f          	j	8000079c <stopSim+0x4>

800007a0 <putC>:
800007a0:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7fffeed0>
800007a4:	00008067          	ret

800007a8 <getC>:
800007a8:	ff802503          	lw	a0,-8(zero) # fffffff8 <_sp+0x7fffeed0>
800007ac:	00008067          	ret

800007b0 <rdtime>:
800007b0:	fe002503          	lw	a0,-32(zero) # ffffffe0 <_sp+0x7fffeeb8>
800007b4:	00008067          	ret

800007b8 <rdtimeh>:
800007b8:	fe402503          	lw	a0,-28(zero) # ffffffe4 <_sp+0x7fffeebc>
800007bc:	00008067          	ret

800007c0 <setMachineTimerCmp>:
800007c0:	fec00793          	li	a5,-20
800007c4:	fff00713          	li	a4,-1
800007c8:	00e7a023          	sw	a4,0(a5)
800007cc:	fea02423          	sw	a0,-24(zero) # ffffffe8 <_sp+0x7fffeec0>
800007d0:	00b7a023          	sw	a1,0(a5)
800007d4:	00008067          	ret

800007d8 <halInit>:
800007d8:	00008067          	ret

800007dc <__libc_init_array>:
800007dc:	ff010113          	addi	sp,sp,-16
800007e0:	00000797          	auipc	a5,0x0
800007e4:	0a478793          	addi	a5,a5,164 # 80000884 <__init_array_end>
800007e8:	00812423          	sw	s0,8(sp)
800007ec:	00000417          	auipc	s0,0x0
800007f0:	09840413          	addi	s0,s0,152 # 80000884 <__init_array_end>
800007f4:	40f40433          	sub	s0,s0,a5
800007f8:	00912223          	sw	s1,4(sp)
800007fc:	01212023          	sw	s2,0(sp)
80000800:	00112623          	sw	ra,12(sp)
80000804:	40245413          	srai	s0,s0,0x2
80000808:	00000493          	li	s1,0
8000080c:	00078913          	mv	s2,a5
80000810:	04849263          	bne	s1,s0,80000854 <__libc_init_array+0x78>
80000814:	865ff0ef          	jal	ra,80000078 <_init>
80000818:	00000797          	auipc	a5,0x0
8000081c:	06c78793          	addi	a5,a5,108 # 80000884 <__init_array_end>
80000820:	00000417          	auipc	s0,0x0
80000824:	06440413          	addi	s0,s0,100 # 80000884 <__init_array_end>
80000828:	40f40433          	sub	s0,s0,a5
8000082c:	40245413          	srai	s0,s0,0x2
80000830:	00000493          	li	s1,0
80000834:	00078913          	mv	s2,a5
80000838:	02849a63          	bne	s1,s0,8000086c <__libc_init_array+0x90>
8000083c:	00c12083          	lw	ra,12(sp)
80000840:	00812403          	lw	s0,8(sp)
80000844:	00412483          	lw	s1,4(sp)
80000848:	00012903          	lw	s2,0(sp)
8000084c:	01010113          	addi	sp,sp,16
80000850:	00008067          	ret
80000854:	00249793          	slli	a5,s1,0x2
80000858:	00f907b3          	add	a5,s2,a5
8000085c:	0007a783          	lw	a5,0(a5)
80000860:	00148493          	addi	s1,s1,1
80000864:	000780e7          	jalr	a5
80000868:	fa9ff06f          	j	80000810 <__libc_init_array+0x34>
8000086c:	00249793          	slli	a5,s1,0x2
80000870:	00f907b3          	add	a5,s2,a5
80000874:	0007a783          	lw	a5,0(a5)
80000878:	00148493          	addi	s1,s1,1
8000087c:	000780e7          	jalr	a5
80000880:	fb9ff06f          	j	80000838 <__libc_init_array+0x5c>
