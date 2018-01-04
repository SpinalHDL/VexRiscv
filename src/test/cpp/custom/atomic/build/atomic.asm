
build/atomic.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <_start>:
   0:	00100e13          	li	t3,1
   4:	10000537          	lui	a0,0x10000
   8:	06400593          	li	a1,100
   c:	06500613          	li	a2,101
  10:	06600693          	li	a3,102
  14:	00d52023          	sw	a3,0(a0) # 10000000 <pass+0xfffffa0>
  18:	18b5262f          	sc.w	a2,a1,(a0)
  1c:	02060c63          	beqz	a2,54 <fail>
  20:	00052703          	lw	a4,0(a0)
  24:	02e69863          	bne	a3,a4,54 <fail>
  28:	00200e13          	li	t3,2
  2c:	10000537          	lui	a0,0x10000
  30:	06400593          	li	a1,100
  34:	06500613          	li	a2,101
  38:	06600693          	li	a3,102
  3c:	00d52023          	sw	a3,0(a0) # 10000000 <pass+0xfffffa0>
  40:	18b5262f          	sc.w	a2,a1,(a0)
  44:	00060863          	beqz	a2,54 <fail>
  48:	00052703          	lw	a4,0(a0)
  4c:	00e69463          	bne	a3,a4,54 <fail>
  50:	0100006f          	j	60 <pass>

00000054 <fail>:
  54:	f0100137          	lui	sp,0xf0100
  58:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffec4>
  5c:	01c12023          	sw	t3,0(sp)

00000060 <pass>:
  60:	f0100137          	lui	sp,0xf0100
  64:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffec0>
  68:	00012023          	sw	zero,0(sp)
  6c:	00000013          	nop
  70:	00000013          	nop
  74:	00000013          	nop
  78:	00000013          	nop
  7c:	00000013          	nop
  80:	00000013          	nop
