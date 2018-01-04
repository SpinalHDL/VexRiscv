
build/atomic.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <trap_entry-0x20>:
   0:	04c0006f          	j	4c <_start>
   4:	00000013          	nop
   8:	00000013          	nop
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop

00000020 <trap_entry>:
  20:	30002ef3          	csrr	t4,mstatus
  24:	080efe93          	andi	t4,t4,128
  28:	000e8a63          	beqz	t4,3c <notExternalInterrupt>
  2c:	00002eb7          	lui	t4,0x2
  30:	800e8e93          	addi	t4,t4,-2048 # 1800 <pass+0x1498>
  34:	300e9073          	csrw	mstatus,t4
  38:	30200073          	mret

0000003c <notExternalInterrupt>:
  3c:	34102ef3          	csrr	t4,mepc
  40:	004e8e93          	addi	t4,t4,4
  44:	341e9073          	csrw	mepc,t4
  48:	30200073          	mret

0000004c <_start>:
  4c:	00100e13          	li	t3,1
  50:	10000537          	lui	a0,0x10000
  54:	06400593          	li	a1,100
  58:	06500613          	li	a2,101
  5c:	06600693          	li	a3,102
  60:	00d52023          	sw	a3,0(a0) # 10000000 <pass+0xffffc98>
  64:	18b5262f          	sc.w	a2,a1,(a0)
  68:	00100713          	li	a4,1
  6c:	2ee61863          	bne	a2,a4,35c <fail>
  70:	00052703          	lw	a4,0(a0)
  74:	2ee69463          	bne	a3,a4,35c <fail>
  78:	00200e13          	li	t3,2
  7c:	10000537          	lui	a0,0x10000
  80:	00450513          	addi	a0,a0,4 # 10000004 <pass+0xffffc9c>
  84:	06700593          	li	a1,103
  88:	06800613          	li	a2,104
  8c:	06900693          	li	a3,105
  90:	00d52023          	sw	a3,0(a0)
  94:	18b5262f          	sc.w	a2,a1,(a0)
  98:	00100713          	li	a4,1
  9c:	2ce61063          	bne	a2,a4,35c <fail>
  a0:	00052703          	lw	a4,0(a0)
  a4:	2ae69c63          	bne	a3,a4,35c <fail>
  a8:	00300e13          	li	t3,3
  ac:	10000537          	lui	a0,0x10000
  b0:	00450513          	addi	a0,a0,4 # 10000004 <pass+0xffffc9c>
  b4:	06700593          	li	a1,103
  b8:	06800613          	li	a2,104
  bc:	06900693          	li	a3,105
  c0:	18b5262f          	sc.w	a2,a1,(a0)
  c4:	00100713          	li	a4,1
  c8:	28e61a63          	bne	a2,a4,35c <fail>
  cc:	00052703          	lw	a4,0(a0)
  d0:	28e69663          	bne	a3,a4,35c <fail>
  d4:	00400e13          	li	t3,4
  d8:	10000537          	lui	a0,0x10000
  dc:	00850513          	addi	a0,a0,8 # 10000008 <pass+0xffffca0>
  e0:	06a00593          	li	a1,106
  e4:	06b00613          	li	a2,107
  e8:	06c00693          	li	a3,108
  ec:	00d52023          	sw	a3,0(a0)
  f0:	100527af          	lr.w	a5,(a0)
  f4:	18b5262f          	sc.w	a2,a1,(a0)
  f8:	26d79263          	bne	a5,a3,35c <fail>
  fc:	26061063          	bnez	a2,35c <fail>
 100:	00052703          	lw	a4,0(a0)
 104:	24e59c63          	bne	a1,a4,35c <fail>
 108:	00500e13          	li	t3,5
 10c:	10000537          	lui	a0,0x10000
 110:	00850513          	addi	a0,a0,8 # 10000008 <pass+0xffffca0>
 114:	06d00593          	li	a1,109
 118:	06e00613          	li	a2,110
 11c:	06f00693          	li	a3,111
 120:	00d52023          	sw	a3,0(a0)
 124:	18b5262f          	sc.w	a2,a1,(a0)
 128:	22061a63          	bnez	a2,35c <fail>
 12c:	00052703          	lw	a4,0(a0)
 130:	22e59663          	bne	a1,a4,35c <fail>
 134:	00600e13          	li	t3,6
 138:	10000537          	lui	a0,0x10000
 13c:	00c50513          	addi	a0,a0,12 # 1000000c <pass+0xffffca4>
 140:	07000593          	li	a1,112
 144:	07100613          	li	a2,113
 148:	07200693          	li	a3,114
 14c:	10000437          	lui	s0,0x10000
 150:	01040413          	addi	s0,s0,16 # 10000010 <pass+0xffffca8>
 154:	07300493          	li	s1,115
 158:	07400913          	li	s2,116
 15c:	07500993          	li	s3,117
 160:	00d52023          	sw	a3,0(a0)
 164:	01342023          	sw	s3,0(s0)
 168:	100527af          	lr.w	a5,(a0)
 16c:	10042aaf          	lr.w	s5,(s0)
 170:	18b5262f          	sc.w	a2,a1,(a0)
 174:	1894292f          	sc.w	s2,s1,(s0)
 178:	1ed79263          	bne	a5,a3,35c <fail>
 17c:	1e061063          	bnez	a2,35c <fail>
 180:	00052703          	lw	a4,0(a0)
 184:	1ce59c63          	bne	a1,a4,35c <fail>
 188:	1d3a9a63          	bne	s5,s3,35c <fail>
 18c:	1c091863          	bnez	s2,35c <fail>
 190:	00042a03          	lw	s4,0(s0)
 194:	1d449463          	bne	s1,s4,35c <fail>
 198:	00700e13          	li	t3,7
 19c:	10000537          	lui	a0,0x10000
 1a0:	01450513          	addi	a0,a0,20 # 10000014 <pass+0xffffcac>
 1a4:	07800593          	li	a1,120
 1a8:	07900613          	li	a2,121
 1ac:	07a00693          	li	a3,122
 1b0:	01000e93          	li	t4,16

000001b4 <test7>:
 1b4:	00d52023          	sw	a3,0(a0)
 1b8:	100527af          	lr.w	a5,(a0)
 1bc:	18b5262f          	sc.w	a2,a1,(a0)
 1c0:	18d79e63          	bne	a5,a3,35c <fail>
 1c4:	18061c63          	bnez	a2,35c <fail>
 1c8:	00052703          	lw	a4,0(a0)
 1cc:	18e59863          	bne	a1,a4,35c <fail>
 1d0:	fffe8e93          	addi	t4,t4,-1
 1d4:	00450513          	addi	a0,a0,4
 1d8:	00358593          	addi	a1,a1,3
 1dc:	00360613          	addi	a2,a2,3
 1e0:	00368693          	addi	a3,a3,3
 1e4:	fc0e98e3          	bnez	t4,1b4 <test7>
 1e8:	00800e13          	li	t3,8
 1ec:	10000537          	lui	a0,0x10000
 1f0:	01850513          	addi	a0,a0,24 # 10000018 <pass+0xffffcb0>
 1f4:	07800593          	li	a1,120
 1f8:	07900613          	li	a2,121
 1fc:	07a00693          	li	a3,122
 200:	00052783          	lw	a5,0(a0)
 204:	18b5262f          	sc.w	a2,a1,(a0)
 208:	00100713          	li	a4,1
 20c:	14e61863          	bne	a2,a4,35c <fail>
 210:	00052703          	lw	a4,0(a0)
 214:	14e79463          	bne	a5,a4,35c <fail>
 218:	00900e13          	li	t3,9
 21c:	10000537          	lui	a0,0x10000
 220:	10050513          	addi	a0,a0,256 # 10000100 <pass+0xffffd98>
 224:	07b00593          	li	a1,123
 228:	07c00613          	li	a2,124
 22c:	07d00693          	li	a3,125
 230:	00d52023          	sw	a3,0(a0)
 234:	100527af          	lr.w	a5,(a0)
 238:	00000073          	ecall
 23c:	18b5262f          	sc.w	a2,a1,(a0)
 240:	00100713          	li	a4,1
 244:	10e61c63          	bne	a2,a4,35c <fail>
 248:	00052703          	lw	a4,0(a0)
 24c:	10e69863          	bne	a3,a4,35c <fail>
 250:	00a00e13          	li	t3,10
 254:	10000537          	lui	a0,0x10000
 258:	20050513          	addi	a0,a0,512 # 10000200 <pass+0xffffe98>
 25c:	10000837          	lui	a6,0x10000
 260:	20480813          	addi	a6,a6,516 # 10000204 <pass+0xffffe9c>
 264:	07e00593          	li	a1,126
 268:	07f00613          	li	a2,127
 26c:	08000693          	li	a3,128
 270:	08100893          	li	a7,129
 274:	00d52023          	sw	a3,0(a0)
 278:	01182023          	sw	a7,0(a6)
 27c:	100827af          	lr.w	a5,(a6)
 280:	18b5262f          	sc.w	a2,a1,(a0)
 284:	00100713          	li	a4,1
 288:	0ce61a63          	bne	a2,a4,35c <fail>
 28c:	00082703          	lw	a4,0(a6)
 290:	0ce89663          	bne	a7,a4,35c <fail>
 294:	00b00e13          	li	t3,11
 298:	10000537          	lui	a0,0x10000
 29c:	30050513          	addi	a0,a0,768 # 10000300 <pass+0xfffff98>
 2a0:	08200593          	li	a1,130
 2a4:	08300613          	li	a2,131
 2a8:	08400693          	li	a3,132
 2ac:	00d52023          	sw	a3,0(a0)
 2b0:	00001eb7          	lui	t4,0x1
 2b4:	800e8e93          	addi	t4,t4,-2048 # 800 <pass+0x498>
 2b8:	304e9073          	csrw	mie,t4
 2bc:	00800e93          	li	t4,8
 2c0:	100527af          	lr.w	a5,(a0)
 2c4:	300e9073          	csrw	mstatus,t4
 2c8:	00000013          	nop
 2cc:	00000013          	nop
 2d0:	00000013          	nop
 2d4:	00000013          	nop
 2d8:	00000013          	nop
 2dc:	00000013          	nop
 2e0:	18b5262f          	sc.w	a2,a1,(a0)
 2e4:	00100713          	li	a4,1
 2e8:	06e61a63          	bne	a2,a4,35c <fail>
 2ec:	00052703          	lw	a4,0(a0)
 2f0:	06e69663          	bne	a3,a4,35c <fail>
 2f4:	00c00e13          	li	t3,12
 2f8:	10000537          	lui	a0,0x10000
 2fc:	40050513          	addi	a0,a0,1024 # 10000400 <pass+0x10000098>
 300:	08c00593          	li	a1,140
 304:	08d00613          	li	a2,141
 308:	08e00693          	li	a3,142
 30c:	00d52023          	sw	a3,0(a0)
 310:	00001eb7          	lui	t4,0x1
 314:	800e8e93          	addi	t4,t4,-2048 # 800 <pass+0x498>
 318:	304e9073          	csrw	mie,t4
 31c:	00002eb7          	lui	t4,0x2
 320:	808e8e93          	addi	t4,t4,-2040 # 1808 <pass+0x14a0>
 324:	100527af          	lr.w	a5,(a0)
 328:	300e9073          	csrw	mstatus,t4
 32c:	00000013          	nop
 330:	00000013          	nop
 334:	00000013          	nop
 338:	00000013          	nop
 33c:	00000013          	nop
 340:	00000013          	nop
 344:	18b5262f          	sc.w	a2,a1,(a0)
 348:	00100713          	li	a4,1
 34c:	00e61863          	bne	a2,a4,35c <fail>
 350:	00052703          	lw	a4,0(a0)
 354:	00e69463          	bne	a3,a4,35c <fail>
 358:	0100006f          	j	368 <pass>

0000035c <fail>:
 35c:	f0100137          	lui	sp,0xf0100
 360:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffbbc>
 364:	01c12023          	sw	t3,0(sp)

00000368 <pass>:
 368:	f0100137          	lui	sp,0xf0100
 36c:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffbb8>
 370:	00012023          	sw	zero,0(sp)
 374:	00000013          	nop
 378:	00000013          	nop
 37c:	00000013          	nop
 380:	00000013          	nop
 384:	00000013          	nop
 388:	00000013          	nop
