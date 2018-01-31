
build/custom_csr.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <_start>:
   0:	00100e13          	li	t3,1
   4:	b04020f3          	csrr	ra,mhpmcounter4
   8:	b0402173          	csrr	sp,mhpmcounter4
   c:	b04021f3          	csrr	gp,mhpmcounter4
  10:	00208093          	addi	ra,ra,2
  14:	00110113          	addi	sp,sp,1
  18:	02309e63          	bne	ra,gp,54 <fail>
  1c:	02311c63          	bne	sp,gp,54 <fail>
  20:	00200e13          	li	t3,2
  24:	005dc0b7          	lui	ra,0x5dc
  28:	98a08093          	addi	ra,ra,-1654 # 5db98a <pass+0x5db92a>
  2c:	b0409073          	csrw	mhpmcounter4,ra
  30:	b0402173          	csrr	sp,mhpmcounter4
  34:	02209063          	bne	ra,sp,54 <fail>
  38:	00300e13          	li	t3,3
  3c:	b05020f3          	csrr	ra,mhpmcounter5
  40:	b0502173          	csrr	sp,mhpmcounter5
  44:	b05021f3          	csrr	gp,mhpmcounter5
  48:	0020d663          	ble	sp,ra,54 <fail>
  4c:	00315463          	ble	gp,sp,54 <fail>
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
