
build/custom_simd_add.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <_start>:
   0:	00100e13          	li	t3,1
   4:	060000b3          	0x60000b3
   8:	08009c63          	bnez	ra,a0 <fail>
   c:	00200e13          	li	t3,2
  10:	00000093          	li	ra,0
  14:	00000113          	li	sp,0
  18:	062080b3          	0x62080b3
  1c:	08009263          	bnez	ra,a0 <fail>
  20:	00300e13          	li	t3,3
  24:	010200b7          	lui	ra,0x1020
  28:	30408093          	addi	ra,ra,772 # 1020304 <pass+0x1020258>
  2c:	00000113          	li	sp,0
  30:	062081b3          	0x62081b3
  34:	06119663          	bne	gp,ra,a0 <fail>
  38:	00400e13          	li	t3,4
  3c:	03061237          	lui	tp,0x3061
  40:	90c20213          	addi	tp,tp,-1780 # 306090c <pass+0x3060860>
  44:	010200b7          	lui	ra,0x1020
  48:	30408093          	addi	ra,ra,772 # 1020304 <pass+0x1020258>
  4c:	02040137          	lui	sp,0x2040
  50:	60810113          	addi	sp,sp,1544 # 2040608 <pass+0x204055c>
  54:	062081b3          	0x62081b3
  58:	04419463          	bne	gp,tp,a0 <fail>
  5c:	00500e13          	li	t3,5
  60:	ff000237          	lui	tp,0xff000
  64:	10220213          	addi	tp,tp,258 # ff000102 <pass+0xff000056>
  68:	fff00093          	li	ra,-1
  6c:	00010137          	lui	sp,0x10
  70:	20310113          	addi	sp,sp,515 # 10203 <pass+0x10157>
  74:	062081b3          	0x62081b3
  78:	02419463          	bne	gp,tp,a0 <fail>
  7c:	00600e13          	li	t3,6
  80:	00600293          	li	t0,6
  84:	00100093          	li	ra,1
  88:	00200113          	li	sp,2
  8c:	00300193          	li	gp,3
  90:	062080b3          	0x62080b3
  94:	063080b3          	0x63080b3
  98:	00509463          	bne	ra,t0,a0 <fail>
  9c:	0100006f          	j	ac <pass>

000000a0 <fail>:
  a0:	f0100137          	lui	sp,0xf0100
  a4:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffe78>
  a8:	01c12023          	sw	t3,0(sp)

000000ac <pass>:
  ac:	f0100137          	lui	sp,0xf0100
  b0:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffe74>
  b4:	00012023          	sw	zero,0(sp)
  b8:	00000013          	nop
  bc:	00000013          	nop
  c0:	00000013          	nop
  c4:	00000013          	nop
  c8:	00000013          	nop
  cc:	00000013          	nop
