
build/atomic.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <trap_entry-0x20>:
   0:	0300006f          	j	30 <_start>
   4:	00000013          	nop
   8:	00000013          	nop
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop

00000020 <trap_entry>:
  20:	34102ef3          	csrr	t4,mepc
  24:	004e8e93          	addi	t4,t4,4
  28:	341e9073          	csrw	mepc,t4
  2c:	30200073          	mret

00000030 <_start>:
  30:	00100e13          	li	t3,1
  34:	10000537          	lui	a0,0x10000
  38:	06400593          	li	a1,100
  3c:	06500613          	li	a2,101
  40:	06600693          	li	a3,102
  44:	00d52023          	sw	a3,0(a0) # 10000000 <pass+0xffffd78>
  48:	18b5262f          	sc.w	a2,a1,(a0)
  4c:	00100713          	li	a4,1
  50:	22e61663          	bne	a2,a4,27c <fail>
  54:	00052703          	lw	a4,0(a0)
  58:	22e69263          	bne	a3,a4,27c <fail>
  5c:	00200e13          	li	t3,2
  60:	10000537          	lui	a0,0x10000
  64:	00450513          	addi	a0,a0,4 # 10000004 <pass+0xffffd7c>
  68:	06700593          	li	a1,103
  6c:	06800613          	li	a2,104
  70:	06900693          	li	a3,105
  74:	00d52023          	sw	a3,0(a0)
  78:	18b5262f          	sc.w	a2,a1,(a0)
  7c:	00100713          	li	a4,1
  80:	1ee61e63          	bne	a2,a4,27c <fail>
  84:	00052703          	lw	a4,0(a0)
  88:	1ee69a63          	bne	a3,a4,27c <fail>
  8c:	00300e13          	li	t3,3
  90:	10000537          	lui	a0,0x10000
  94:	00450513          	addi	a0,a0,4 # 10000004 <pass+0xffffd7c>
  98:	06700593          	li	a1,103
  9c:	06800613          	li	a2,104
  a0:	06900693          	li	a3,105
  a4:	18b5262f          	sc.w	a2,a1,(a0)
  a8:	00100713          	li	a4,1
  ac:	1ce61863          	bne	a2,a4,27c <fail>
  b0:	00052703          	lw	a4,0(a0)
  b4:	1ce69463          	bne	a3,a4,27c <fail>
  b8:	00400e13          	li	t3,4
  bc:	10000537          	lui	a0,0x10000
  c0:	00850513          	addi	a0,a0,8 # 10000008 <pass+0xffffd80>
  c4:	06a00593          	li	a1,106
  c8:	06b00613          	li	a2,107
  cc:	06c00693          	li	a3,108
  d0:	00d52023          	sw	a3,0(a0)
  d4:	100527af          	lr.w	a5,(a0)
  d8:	18b5262f          	sc.w	a2,a1,(a0)
  dc:	1ad79063          	bne	a5,a3,27c <fail>
  e0:	18061e63          	bnez	a2,27c <fail>
  e4:	00052703          	lw	a4,0(a0)
  e8:	18e59a63          	bne	a1,a4,27c <fail>
  ec:	00500e13          	li	t3,5
  f0:	10000537          	lui	a0,0x10000
  f4:	00850513          	addi	a0,a0,8 # 10000008 <pass+0xffffd80>
  f8:	06d00593          	li	a1,109
  fc:	06e00613          	li	a2,110
 100:	06f00693          	li	a3,111
 104:	00d52023          	sw	a3,0(a0)
 108:	18b5262f          	sc.w	a2,a1,(a0)
 10c:	16061863          	bnez	a2,27c <fail>
 110:	00052703          	lw	a4,0(a0)
 114:	16e59463          	bne	a1,a4,27c <fail>
 118:	00600e13          	li	t3,6
 11c:	10000537          	lui	a0,0x10000
 120:	00c50513          	addi	a0,a0,12 # 1000000c <pass+0xffffd84>
 124:	07000593          	li	a1,112
 128:	07100613          	li	a2,113
 12c:	07200693          	li	a3,114
 130:	10000437          	lui	s0,0x10000
 134:	01040413          	addi	s0,s0,16 # 10000010 <pass+0xffffd88>
 138:	07300493          	li	s1,115
 13c:	07400913          	li	s2,116
 140:	07500993          	li	s3,117
 144:	00d52023          	sw	a3,0(a0)
 148:	01342023          	sw	s3,0(s0)
 14c:	100527af          	lr.w	a5,(a0)
 150:	10042aaf          	lr.w	s5,(s0)
 154:	18b5262f          	sc.w	a2,a1,(a0)
 158:	1894292f          	sc.w	s2,s1,(s0)
 15c:	12d79063          	bne	a5,a3,27c <fail>
 160:	10061e63          	bnez	a2,27c <fail>
 164:	00052703          	lw	a4,0(a0)
 168:	10e59a63          	bne	a1,a4,27c <fail>
 16c:	113a9863          	bne	s5,s3,27c <fail>
 170:	10091663          	bnez	s2,27c <fail>
 174:	00042a03          	lw	s4,0(s0)
 178:	11449263          	bne	s1,s4,27c <fail>
 17c:	00700e13          	li	t3,7
 180:	10000537          	lui	a0,0x10000
 184:	01450513          	addi	a0,a0,20 # 10000014 <pass+0xffffd8c>
 188:	07800593          	li	a1,120
 18c:	07900613          	li	a2,121
 190:	07a00693          	li	a3,122
 194:	01000e93          	li	t4,16

00000198 <test7>:
 198:	00d52023          	sw	a3,0(a0)
 19c:	100527af          	lr.w	a5,(a0)
 1a0:	18b5262f          	sc.w	a2,a1,(a0)
 1a4:	0cd79c63          	bne	a5,a3,27c <fail>
 1a8:	0c061a63          	bnez	a2,27c <fail>
 1ac:	00052703          	lw	a4,0(a0)
 1b0:	0ce59663          	bne	a1,a4,27c <fail>
 1b4:	fffe8e93          	addi	t4,t4,-1
 1b8:	00450513          	addi	a0,a0,4
 1bc:	00358593          	addi	a1,a1,3
 1c0:	00360613          	addi	a2,a2,3
 1c4:	00368693          	addi	a3,a3,3
 1c8:	fc0e98e3          	bnez	t4,198 <test7>
 1cc:	00800e13          	li	t3,8
 1d0:	10000537          	lui	a0,0x10000
 1d4:	01850513          	addi	a0,a0,24 # 10000018 <pass+0xffffd90>
 1d8:	07800593          	li	a1,120
 1dc:	07900613          	li	a2,121
 1e0:	07a00693          	li	a3,122
 1e4:	00052783          	lw	a5,0(a0)
 1e8:	18b5262f          	sc.w	a2,a1,(a0)
 1ec:	00100713          	li	a4,1
 1f0:	08e61663          	bne	a2,a4,27c <fail>
 1f4:	00052703          	lw	a4,0(a0)
 1f8:	08e79263          	bne	a5,a4,27c <fail>
 1fc:	00900e13          	li	t3,9
 200:	10000537          	lui	a0,0x10000
 204:	10050513          	addi	a0,a0,256 # 10000100 <pass+0xffffe78>
 208:	07b00593          	li	a1,123
 20c:	07c00613          	li	a2,124
 210:	07d00693          	li	a3,125
 214:	00d52023          	sw	a3,0(a0)
 218:	100527af          	lr.w	a5,(a0)
 21c:	00000073          	ecall
 220:	18b5262f          	sc.w	a2,a1,(a0)
 224:	00100713          	li	a4,1
 228:	04e61a63          	bne	a2,a4,27c <fail>
 22c:	00052703          	lw	a4,0(a0)
 230:	04e69663          	bne	a3,a4,27c <fail>
 234:	00900e13          	li	t3,9
 238:	10000537          	lui	a0,0x10000
 23c:	20050513          	addi	a0,a0,512 # 10000200 <pass+0xfffff78>
 240:	10000837          	lui	a6,0x10000
 244:	20480813          	addi	a6,a6,516 # 10000204 <pass+0xfffff7c>
 248:	07e00593          	li	a1,126
 24c:	07f00613          	li	a2,127
 250:	08000693          	li	a3,128
 254:	08100893          	li	a7,129
 258:	00d52023          	sw	a3,0(a0)
 25c:	01182023          	sw	a7,0(a6)
 260:	100827af          	lr.w	a5,(a6)
 264:	18b5262f          	sc.w	a2,a1,(a0)
 268:	00100713          	li	a4,1
 26c:	00e61863          	bne	a2,a4,27c <fail>
 270:	00082703          	lw	a4,0(a6)
 274:	00e89463          	bne	a7,a4,27c <fail>
 278:	0100006f          	j	288 <pass>

0000027c <fail>:
 27c:	f0100137          	lui	sp,0xf0100
 280:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffc9c>
 284:	01c12023          	sw	t3,0(sp)

00000288 <pass>:
 288:	f0100137          	lui	sp,0xf0100
 28c:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffc98>
 290:	00012023          	sw	zero,0(sp)
 294:	00000013          	nop
 298:	00000013          	nop
 29c:	00000013          	nop
 2a0:	00000013          	nop
 2a4:	00000013          	nop
 2a8:	00000013          	nop
