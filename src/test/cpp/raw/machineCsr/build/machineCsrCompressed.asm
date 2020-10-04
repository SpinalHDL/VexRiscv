
build/machineCsrCompressed.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <trap_entry-0x20>:
80000000:	0940006f          	j	80000094 <_start>
80000004:	00000013          	nop
80000008:	00000013          	nop
8000000c:	00000013          	nop
80000010:	00000013          	nop
80000014:	00000013          	nop
80000018:	00000013          	nop
8000001c:	00000013          	nop

80000020 <trap_entry>:
80000020:	34202e73          	csrr	t3,mcause
80000024:	000e1e63          	bnez	t3,80000040 <notICmdAlignementException>
80000028:	ffc00f13          	li	t5,-4
8000002c:	34102ef3          	csrr	t4,mepc
80000030:	01eefeb3          	and	t4,t4,t5
80000034:	004e8e93          	addi	t4,t4,4
80000038:	341e9073          	csrw	mepc,t4
8000003c:	01c0006f          	j	80000058 <mepcFixed>

80000040 <notICmdAlignementException>:
80000040:	80000eb7          	lui	t4,0x80000
80000044:	01de7f33          	and	t5,t3,t4
80000048:	000f1863          	bnez	t5,80000058 <mepcFixed>
8000004c:	34102ef3          	csrr	t4,mepc
80000050:	004e8e93          	addi	t4,t4,4 # 80000004 <unalignedPcA+0xfffffe28>
80000054:	341e9073          	csrw	mepc,t4

80000058 <mepcFixed>:
80000058:	80000eb7          	lui	t4,0x80000
8000005c:	003e8e93          	addi	t4,t4,3 # 80000003 <unalignedPcA+0xfffffe27>
80000060:	01ce9863          	bne	t4,t3,80000070 <noSoftwareInterrupt>
80000064:	f0013c37          	lui	s8,0xf0013
80000068:	00000c93          	li	s9,0
8000006c:	019c2023          	sw	s9,0(s8) # f0013000 <unalignedPcA+0x70012e24>

80000070 <noSoftwareInterrupt>:
80000070:	80000eb7          	lui	t4,0x80000
80000074:	007e8e93          	addi	t4,t4,7 # 80000007 <unalignedPcA+0xfffffe2b>
80000078:	01ce9463          	bne	t4,t3,80000080 <noTimerInterrupt>
8000007c:	30405073          	csrwi	mie,0

80000080 <noTimerInterrupt>:
80000080:	80000eb7          	lui	t4,0x80000
80000084:	00be8e93          	addi	t4,t4,11 # 8000000b <unalignedPcA+0xfffffe2f>
80000088:	01ce9463          	bne	t4,t3,80000090 <noExernalInterrupt>
8000008c:	30405073          	csrwi	mie,0

80000090 <noExernalInterrupt>:
80000090:	30200073          	mret

80000094 <_start>:
80000094:	00100e13          	li	t3,1
80000098:	00000073          	ecall
8000009c:	00200e13          	li	t3,2
800000a0:	00800293          	li	t0,8
800000a4:	3002a073          	csrs	mstatus,t0
800000a8:	00800293          	li	t0,8
800000ac:	30429073          	csrw	mie,t0
800000b0:	f0013c37          	lui	s8,0xf0013
800000b4:	00100c93          	li	s9,1
800000b8:	019c2023          	sw	s9,0(s8) # f0013000 <unalignedPcA+0x70012e24>
800000bc:	00000013          	nop
800000c0:	00000013          	nop
800000c4:	00000013          	nop
800000c8:	00000013          	nop
800000cc:	00000013          	nop
800000d0:	00000013          	nop
800000d4:	00000013          	nop
800000d8:	00000013          	nop
800000dc:	00000013          	nop
800000e0:	00000013          	nop
800000e4:	00000013          	nop
800000e8:	00000013          	nop
800000ec:	00300e13          	li	t3,3
800000f0:	08000293          	li	t0,128
800000f4:	30429073          	csrw	mie,t0
800000f8:	00000013          	nop
800000fc:	00000013          	nop
80000100:	00000013          	nop
80000104:	00000013          	nop
80000108:	00000013          	nop
8000010c:	00000013          	nop
80000110:	00000013          	nop
80000114:	00400e13          	li	t3,4
80000118:	000012b7          	lui	t0,0x1
8000011c:	80028293          	addi	t0,t0,-2048 # 800 <trap_entry-0x7ffff820>
80000120:	30429073          	csrw	mie,t0
80000124:	00000013          	nop
80000128:	00000013          	nop
8000012c:	00000013          	nop
80000130:	00000013          	nop
80000134:	00000013          	nop
80000138:	00000013          	nop
8000013c:	00000013          	nop
80000140:	00500e13          	li	t3,5
80000144:	f01001b7          	lui	gp,0xf0100
80000148:	f4018193          	addi	gp,gp,-192 # f00fff40 <unalignedPcA+0x700ffd64>
8000014c:	0001a203          	lw	tp,0(gp)
80000150:	0041a283          	lw	t0,4(gp)
80000154:	3ff20213          	addi	tp,tp,1023 # 3ff <trap_entry-0x7ffffc21>
80000158:	0041a423          	sw	tp,8(gp)
8000015c:	0051a623          	sw	t0,12(gp)
80000160:	00000013          	nop
80000164:	00000013          	nop
80000168:	00000013          	nop
8000016c:	00000013          	nop
80000170:	00000013          	nop
80000174:	00000013          	nop
80000178:	00000013          	nop
8000017c:	00000013          	nop
80000180:	00000013          	nop
80000184:	00000013          	nop
80000188:	00000013          	nop
8000018c:	00000013          	nop
80000190:	00000013          	nop
80000194:	00000013          	nop
80000198:	00600e13          	li	t3,6
8000019c:	08000213          	li	tp,128
800001a0:	30421073          	csrw	mie,tp
800001a4:	00700e13          	li	t3,7
800001a8:	10500073          	wfi
800001ac:	00800e13          	li	t3,8
800001b0:	00100193          	li	gp,1
800001b4:	0041a023          	sw	tp,0(gp)
800001b8:	00900e13          	li	t3,9
800001bc:	00419023          	sh	tp,0(gp)
800001c0:	00a00e13          	li	t3,10
800001c4:	0001a203          	lw	tp,0(gp)
800001c8:	00b00e13          	li	t3,11
800001cc:	00019203          	lh	tp,0(gp)
800001d0:	00c00e13          	li	t3,12
800001d4:	00d00e13          	li	t3,13
800001d8:	00002083          	lw	ra,0(zero) # 0 <trap_entry-0x80000020>

800001dc <unalignedPcA>:
800001dc:	0020006f          	j	800001de <unalignedPcA+0x2>
800001e0:	00002083          	lw	ra,0(zero) # 0 <trap_entry-0x80000020>
800001e4:	00e00e13          	li	t3,14
800001e8:	20200073          	hret
800001ec:	00f00e13          	li	t3,15
800001f0:	f01000b7          	lui	ra,0xf0100
800001f4:	f6008093          	addi	ra,ra,-160 # f00fff60 <unalignedPcA+0x700ffd84>
800001f8:	0000a103          	lw	sp,0(ra)
800001fc:	01000e13          	li	t3,16
80000200:	0020a023          	sw	sp,0(ra)
80000204:	01100e13          	li	t3,17
80000208:	00008067          	ret
	...
