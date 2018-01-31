
build/custom_csr.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <_start>:
   0:	00100e13          	li	t3,1
   4:	b04020f3          	csrr	ra,mhpmcounter4
   8:	b0402173          	csrr	sp,mhpmcounter4
   c:	b04021f3          	csrr	gp,mhpmcounter4
  10:	02114e63          	blt	sp,ra,4c <fail>
  14:	0221cc63          	blt	gp,sp,4c <fail>
  18:	00200e13          	li	t3,2
  1c:	005dc0b7          	lui	ra,0x5dc
  20:	98a08093          	addi	ra,ra,-1654 # 5db98a <pass+0x5db932>
  24:	b0409073          	csrw	mhpmcounter4,ra
  28:	b0402173          	csrr	sp,mhpmcounter4
  2c:	02114063          	blt	sp,ra,4c <fail>
  30:	00300e13          	li	t3,3
  34:	b05020f3          	csrr	ra,mhpmcounter5
  38:	b0502173          	csrr	sp,mhpmcounter5
  3c:	b05021f3          	csrr	gp,mhpmcounter5
  40:	0020d663          	ble	sp,ra,4c <fail>
  44:	00315463          	ble	gp,sp,4c <fail>
  48:	0100006f          	j	58 <pass>

0000004c <fail>:
  4c:	f0100137          	lui	sp,0xf0100
  50:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffecc>
  54:	01c12023          	sw	t3,0(sp)

00000058 <pass>:
  58:	f0100137          	lui	sp,0xf0100
  5c:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffec8>
  60:	00012023          	sw	zero,0(sp)
  64:	00000013          	nop
  68:	00000013          	nop
  6c:	00000013          	nop
  70:	00000013          	nop
  74:	00000013          	nop
  78:	00000013          	nop
