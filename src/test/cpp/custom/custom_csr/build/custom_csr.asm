
build/custom_csr.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

00000000 <_start>:
   0:	00100e13          	li	t3,1
   4:	b04020f3          	csrr	ra,mhpmcounter4
   8:	b0402173          	csrr	sp,mhpmcounter4
   c:	b04021f3          	csrr	gp,mhpmcounter4
  10:	06114863          	blt	sp,ra,80 <fail>
  14:	0621c663          	blt	gp,sp,80 <fail>
  18:	00200e13          	li	t3,2
  1c:	005dc0b7          	lui	ra,0x5dc
  20:	98a08093          	addi	ra,ra,-1654 # 5db98a <pass+0x5db8fe>
  24:	b0409073          	csrw	mhpmcounter4,ra
  28:	b0402173          	csrr	sp,mhpmcounter4
  2c:	04114a63          	blt	sp,ra,80 <fail>
  30:	00300e13          	li	t3,3
  34:	b05020f3          	csrr	ra,mhpmcounter5
  38:	b0502173          	csrr	sp,mhpmcounter5
  3c:	b05021f3          	csrr	gp,mhpmcounter5
  40:	0420d063          	ble	sp,ra,80 <fail>
  44:	02315e63          	ble	gp,sp,80 <fail>
  48:	00400e13          	li	t3,4
  4c:	b0609073          	csrw	mhpmcounter6,ra
  50:	b04020f3          	csrr	ra,mhpmcounter4
  54:	10000113          	li	sp,256
  58:	0220f463          	bleu	sp,ra,80 <fail>
  5c:	00500e13          	li	t3,5
  60:	b07020f3          	csrr	ra,mhpmcounter7
  64:	b04020f3          	csrr	ra,mhpmcounter4
  68:	40000137          	lui	sp,0x40000
  6c:	10010113          	addi	sp,sp,256 # 40000100 <pass+0x40000074>
  70:	400001b7          	lui	gp,0x40000
  74:	0020f663          	bleu	sp,ra,80 <fail>
  78:	0030e463          	bltu	ra,gp,80 <fail>
  7c:	0100006f          	j	8c <pass>

00000080 <fail>:
  80:	f0100137          	lui	sp,0xf0100
  84:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0xf00ffe98>
  88:	01c12023          	sw	t3,0(sp)

0000008c <pass>:
  8c:	f0100137          	lui	sp,0xf0100
  90:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0xf00ffe94>
  94:	00012023          	sw	zero,0(sp)
  98:	00000013          	nop
  9c:	00000013          	nop
  a0:	00000013          	nop
  a4:	00000013          	nop
  a8:	00000013          	nop
  ac:	00000013          	nop
