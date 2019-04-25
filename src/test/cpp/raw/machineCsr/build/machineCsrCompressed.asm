
build/machineCsrCompressed.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <trap_entry-0x20>:
80000000:	a071                	j	8000008c <_start>
80000002:	0001                	nop
80000004:	00000013          	nop
80000008:	00000013          	nop
8000000c:	00000013          	nop
80000010:	00000013          	nop
80000014:	00000013          	nop
80000018:	00000013          	nop
8000001c:	00000013          	nop

80000020 <trap_entry>:
80000020:	34202e73          	csrr	t3,mcause
80000024:	000e1c63          	bnez	t3,8000003c <notICmdAlignementException>
80000028:	ffc00f13          	li	t5,-4
8000002c:	34102ef3          	csrr	t4,mepc
80000030:	01eefeb3          	and	t4,t4,t5
80000034:	0e91                	addi	t4,t4,4
80000036:	341e9073          	csrw	mepc,t4
8000003a:	a821                	j	80000052 <mepcFixed>

8000003c <notICmdAlignementException>:
8000003c:	80000eb7          	lui	t4,0x80000
80000040:	01de7f33          	and	t5,t3,t4
80000044:	000f1763          	bnez	t5,80000052 <mepcFixed>
80000048:	34102ef3          	csrr	t4,mepc
8000004c:	0e91                	addi	t4,t4,4
8000004e:	341e9073          	csrw	mepc,t4

80000052 <mepcFixed>:
80000052:	80000eb7          	lui	t4,0x80000
80000056:	003e8e93          	addi	t4,t4,3 # 80000003 <_start+0xffffff77>
8000005a:	01ce9763          	bne	t4,t3,80000068 <noSoftwareInterrupt>
8000005e:	f0013c37          	lui	s8,0xf0013
80000062:	4c81                	li	s9,0
80000064:	019c2023          	sw	s9,0(s8) # f0013000 <_start+0x70012f74>

80000068 <noSoftwareInterrupt>:
80000068:	80000eb7          	lui	t4,0x80000
8000006c:	007e8e93          	addi	t4,t4,7 # 80000007 <_start+0xffffff7b>
80000070:	01ce9463          	bne	t4,t3,80000078 <noTimerInterrupt>
80000074:	30405073          	csrwi	mie,0

80000078 <noTimerInterrupt>:
80000078:	80000eb7          	lui	t4,0x80000
8000007c:	00be8e93          	addi	t4,t4,11 # 8000000b <_start+0xffffff7f>
80000080:	01ce9463          	bne	t4,t3,80000088 <noExernalInterrupt>
80000084:	30405073          	csrwi	mie,0

80000088 <noExernalInterrupt>:
80000088:	30200073          	mret

8000008c <_start>:
8000008c:	4e05                	li	t3,1
8000008e:	00000073          	ecall
80000092:	4e09                	li	t3,2
80000094:	42a1                	li	t0,8
80000096:	3002a073          	csrs	mstatus,t0
8000009a:	42a1                	li	t0,8
8000009c:	30429073          	csrw	mie,t0
800000a0:	f0013c37          	lui	s8,0xf0013
800000a4:	4c85                	li	s9,1
800000a6:	019c2023          	sw	s9,0(s8) # f0013000 <_start+0x70012f74>
800000aa:	0001                	nop
800000ac:	0001                	nop
800000ae:	0001                	nop
800000b0:	0001                	nop
800000b2:	0001                	nop
800000b4:	0001                	nop
800000b6:	0001                	nop
800000b8:	0001                	nop
800000ba:	0001                	nop
800000bc:	0001                	nop
800000be:	0001                	nop
800000c0:	0001                	nop
800000c2:	4e0d                	li	t3,3
800000c4:	08000293          	li	t0,128
800000c8:	30429073          	csrw	mie,t0
800000cc:	0001                	nop
800000ce:	0001                	nop
800000d0:	0001                	nop
800000d2:	0001                	nop
800000d4:	0001                	nop
800000d6:	0001                	nop
800000d8:	0001                	nop
800000da:	4e11                	li	t3,4
800000dc:	000012b7          	lui	t0,0x1
800000e0:	80028293          	addi	t0,t0,-2048 # 800 <trap_entry-0x7ffff820>
800000e4:	30429073          	csrw	mie,t0
800000e8:	0001                	nop
800000ea:	0001                	nop
800000ec:	0001                	nop
800000ee:	0001                	nop
800000f0:	0001                	nop
800000f2:	0001                	nop
800000f4:	0001                	nop
800000f6:	4e15                	li	t3,5
800000f8:	f01001b7          	lui	gp,0xf0100
800000fc:	f4018193          	addi	gp,gp,-192 # f00fff40 <_start+0x700ffeb4>
80000100:	0001a203          	lw	tp,0(gp)
80000104:	0041a283          	lw	t0,4(gp)
80000108:	3ff20213          	addi	tp,tp,1023 # 3ff <trap_entry-0x7ffffc21>
8000010c:	0041a423          	sw	tp,8(gp)
80000110:	0051a623          	sw	t0,12(gp)
80000114:	4e19                	li	t3,6
80000116:	08000213          	li	tp,128
8000011a:	30421073          	csrw	mie,tp
8000011e:	4e1d                	li	t3,7
80000120:	10500073          	wfi
80000124:	4e21                	li	t3,8
80000126:	4185                	li	gp,1
80000128:	0041a023          	sw	tp,0(gp)
8000012c:	4e25                	li	t3,9
8000012e:	00419023          	sh	tp,0(gp)
80000132:	4e29                	li	t3,10
80000134:	0001a203          	lw	tp,0(gp)
80000138:	4e2d                	li	t3,11
8000013a:	00019203          	lh	tp,0(gp)
8000013e:	4e31                	li	t3,12
80000140:	4e35                	li	t3,13
80000142:	00002083          	lw	ra,0(zero) # 0 <trap_entry-0x80000020>
80000146:	00002083          	lw	ra,0(zero) # 0 <trap_entry-0x80000020>
8000014a:	4e39                	li	t3,14
8000014c:	20200073          	hret
80000150:	4e3d                	li	t3,15
80000152:	f01000b7          	lui	ra,0xf0100
80000156:	f6008093          	addi	ra,ra,-160 # f00fff60 <_start+0x700ffed4>
8000015a:	0000a103          	lw	sp,0(ra)
8000015e:	4e41                	li	t3,16
80000160:	0020a023          	sw	sp,0(ra)
80000164:	4e45                	li	t3,17
80000166:	8082                	ret
	...
