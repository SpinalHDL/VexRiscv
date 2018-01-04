
build/atomic.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <_start>:
   0:	00100e13          	li	t3,1
   4:	10000537          	lui	a0,0x10000
   8:	06400593          	li	a1,100
   c:	06500613          	li	a2,101
  10:	06600693          	li	a3,102
  14:	00d52023          	sw	a3,0(a0) # 10000000 <pass+0xfffff34>
  18:	18b5262f          	sc.w	a2,a1,(a0)
  1c:	00100713          	li	a4,1
  20:	0ae61063          	bne	a2,a4,c0 <fail>
  24:	00052703          	lw	a4,0(a0)
  28:	08e69c63          	bne	a3,a4,c0 <fail>
  2c:	00200e13          	li	t3,2
  30:	10000537          	lui	a0,0x10000
  34:	00450513          	addi	a0,a0,4 # 10000004 <pass+0xfffff38>
  38:	06700593          	li	a1,103
  3c:	06800613          	li	a2,104
  40:	06900693          	li	a3,105
  44:	00d52023          	sw	a3,0(a0)
  48:	18b5262f          	sc.w	a2,a1,(a0)
  4c:	00100713          	li	a4,1
  50:	06e61863          	bne	a2,a4,c0 <fail>
  54:	00052703          	lw	a4,0(a0)
  58:	06e69463          	bne	a3,a4,c0 <fail>
  5c:	00300e13          	li	t3,3
  60:	10000537          	lui	a0,0x10000
  64:	00450513          	addi	a0,a0,4 # 10000004 <pass+0xfffff38>
  68:	06700593          	li	a1,103
  6c:	06800613          	li	a2,104
  70:	06900693          	li	a3,105
  74:	18b5262f          	sc.w	a2,a1,(a0)
  78:	00100713          	li	a4,1
  7c:	04e61263          	bne	a2,a4,c0 <fail>
  80:	00052703          	lw	a4,0(a0)
  84:	02e69e63          	bne	a3,a4,c0 <fail>
  88:	00400e13          	li	t3,4
  8c:	10000537          	lui	a0,0x10000
  90:	00850513          	addi	a0,a0,8 # 10000008 <pass+0xfffff3c>
  94:	06a00593          	li	a1,106
  98:	06b00613          	li	a2,107
  9c:	06c00693          	li	a3,108
  a0:	00d52023          	sw	a3,0(a0)
  a4:	100527af          	lr.w	a5,(a0)
  a8:	18b5262f          	sc.w	a2,a1,(a0)
  ac:	00d79a63          	bne	a5,a3,c0 <fail>
  b0:	00061863          	bnez	a2,c0 <fail>
  b4:	00052703          	lw	a4,0(a0)
  b8:	00e59463          	bne	a1,a4,c0 <fail>
  bc:	0100006f          	j	cc <pass>

000000c0 <fail>:
  c0:	f0100137          	lui	sp,0xf0100
  c4:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffe58>
  c8:	01c12023          	sw	t3,0(sp)

000000cc <pass>:
  cc:	f0100137          	lui	sp,0xf0100
  d0:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffe54>
  d4:	00012023          	sw	zero,0(sp)
  d8:	00000013          	nop
  dc:	00000013          	nop
  e0:	00000013          	nop
  e4:	00000013          	nop
  e8:	00000013          	nop
  ec:	00000013          	nop
