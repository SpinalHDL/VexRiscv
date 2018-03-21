
build/machineCsr.elf:     file format elf32-littleriscv


Disassembly of section .yolo:

80000000 <trap_entry-0x20>:
  j _start
80000000:	0900006f          	j	80000090 <_start>
  nop
80000004:	00000013          	nop
  nop
80000008:	00000013          	nop
  nop
8000000c:	00000013          	nop
  nop
80000010:	00000013          	nop
  nop
80000014:	00000013          	nop
  nop
80000018:	00000013          	nop
  nop
8000001c:	00000013          	nop

80000020 <trap_entry>:

.global  trap_entry
trap_entry:
  csrr x28, mcause
80000020:	34202e73          	csrr	t3,mcause

  bnez x28, notICmdAlignementException  
80000024:	000e1e63          	bnez	t3,80000040 <notICmdAlignementException>
  li   x30, 0xFFFFFFFC  
80000028:	ffc00f13          	li	t5,-4
  csrr x29, mepc
8000002c:	34102ef3          	csrr	t4,mepc
  and  x29,x29,x30
80000030:	01eefeb3          	and	t4,t4,t5
  addi x29, x29, 4
80000034:	004e8e93          	addi	t4,t4,4
  csrw mepc, x29
80000038:	341e9073          	csrw	mepc,t4
  j mepcFixed
8000003c:	01c0006f          	j	80000058 <mepcFixed>

80000040 <notICmdAlignementException>:

notICmdAlignementException:
  li   x29, 0x80000000
80000040:	80000eb7          	lui	t4,0x80000
  and  x30, x28, x29
80000044:	01de7f33          	and	t5,t3,t4
  bnez x30, mepcFixed
80000048:	000f1863          	bnez	t5,80000058 <mepcFixed>
  csrr x29, mepc
8000004c:	34102ef3          	csrr	t4,mepc
  addi x29, x29, 4
80000050:	004e8e93          	addi	t4,t4,4 # 80000004 <_etext+0xfffffdf8>
  csrw mepc, x29
80000054:	341e9073          	csrw	mepc,t4

80000058 <mepcFixed>:
mepcFixed:


  li   x29, 0x80000003u
80000058:	80000eb7          	lui	t4,0x80000
8000005c:	003e8e93          	addi	t4,t4,3 # 80000003 <_etext+0xfffffdf7>
  bne  x29, x28, noSoftwareInterrupt
80000060:	01ce9663          	bne	t4,t3,8000006c <noSoftwareInterrupt>
  li x29, 0x008
80000064:	00800e93          	li	t4,8
  csrc mip, x29
80000068:	344eb073          	csrc	mip,t4

8000006c <noSoftwareInterrupt>:

noSoftwareInterrupt:

  li   x29, 0x80000007u
8000006c:	80000eb7          	lui	t4,0x80000
80000070:	007e8e93          	addi	t4,t4,7 # 80000007 <_etext+0xfffffdfb>
  bne  x29, x28, noTimerInterrupt
80000074:	01ce9463          	bne	t4,t3,8000007c <noTimerInterrupt>
  csrw mie, 0
80000078:	30405073          	csrwi	mie,0

8000007c <noTimerInterrupt>:
noTimerInterrupt:

  li   x29, 0x8000000bu
8000007c:	80000eb7          	lui	t4,0x80000
80000080:	00be8e93          	addi	t4,t4,11 # 8000000b <_etext+0xfffffdff>
  bne  x29, x28, noExernalInterrupt
80000084:	01ce9463          	bne	t4,t3,8000008c <noExernalInterrupt>
  csrw mie, 0
80000088:	30405073          	csrwi	mie,0

8000008c <noExernalInterrupt>:
noExernalInterrupt:

  mret
8000008c:	30200073          	mret

80000090 <_start>:
  
  
  .text
  .globl _start
_start:
  li x28, 1
80000090:	00100e13          	li	t3,1
  scall
80000094:	00000073          	ecall

  li x28, 2
80000098:	00200e13          	li	t3,2
  li t0, 0x008
8000009c:	00800293          	li	t0,8
  csrs mstatus,t0
800000a0:	3002a073          	csrs	mstatus,t0
  li t0, 0x008
800000a4:	00800293          	li	t0,8
  csrw mie,t0
800000a8:	30429073          	csrw	mie,t0
  li t0, 0x008
800000ac:	00800293          	li	t0,8
  csrs mip,t0
800000b0:	3442a073          	csrs	mip,t0
  nop
800000b4:	00000013          	nop
  nop
800000b8:	00000013          	nop
  nop
800000bc:	00000013          	nop
  nop
800000c0:	00000013          	nop
  nop
800000c4:	00000013          	nop
  nop
800000c8:	00000013          	nop
  nop
800000cc:	00000013          	nop
  nop
800000d0:	00000013          	nop
  nop
800000d4:	00000013          	nop
  nop
800000d8:	00000013          	nop
  nop
800000dc:	00000013          	nop
  nop
800000e0:	00000013          	nop


  li x28, 3
800000e4:	00300e13          	li	t3,3
  li t0, 0x080
800000e8:	08000293          	li	t0,128
  csrw mie,t0
800000ec:	30429073          	csrw	mie,t0
  nop
800000f0:	00000013          	nop
  nop
800000f4:	00000013          	nop
  nop
800000f8:	00000013          	nop
  nop
800000fc:	00000013          	nop
  nop
80000100:	00000013          	nop
  nop
80000104:	00000013          	nop
  nop
80000108:	00000013          	nop

  li x28, 4
8000010c:	00400e13          	li	t3,4
  li t0, 0x800
80000110:	000012b7          	lui	t0,0x1
80000114:	80028293          	addi	t0,t0,-2048 # 800 <_stack_size>
  csrw mie,t0
80000118:	30429073          	csrw	mie,t0
  nop
8000011c:	00000013          	nop
  nop
80000120:	00000013          	nop
  nop
80000124:	00000013          	nop
  nop
80000128:	00000013          	nop
  nop
8000012c:	00000013          	nop
  nop
80000130:	00000013          	nop
  nop
80000134:	00000013          	nop

  li x28, 5
80000138:	00500e13          	li	t3,5
  li x3, 0xF00FFF40
8000013c:	f01001b7          	lui	gp,0xf0100
80000140:	f4018193          	addi	gp,gp,-192 # f00fff40 <_etext+0x700ffd34>
  lw x4, 0(x3)
80000144:	0001a203          	lw	tp,0(gp)
  lw x5, 4(x3)
80000148:	0041a283          	lw	t0,4(gp)
  addi x4, x4, 1023
8000014c:	3ff20213          	addi	tp,tp,1023 # 3ff <_stack_size-0x401>
  sw x4, 8(x3)
80000150:	0041a423          	sw	tp,8(gp)
  sw x5, 12(x3)
80000154:	0051a623          	sw	t0,12(gp)
  li x28, 6
80000158:	00600e13          	li	t3,6
  li x4, 0x080
8000015c:	08000213          	li	tp,128
  csrw mie,x4
80000160:	30421073          	csrw	mie,tp
  li x28, 7
80000164:	00700e13          	li	t3,7
  wfi
80000168:	10500073          	wfi


  li x28, 8
8000016c:	00800e13          	li	t3,8
  li x3, 1
80000170:	00100193          	li	gp,1
  sw x4,0(x3)
80000174:	0041a023          	sw	tp,0(gp)
  li x28, 9
80000178:	00900e13          	li	t3,9
  sh x4,0(x3)
8000017c:	00419023          	sh	tp,0(gp)
  li x28, 10
80000180:	00a00e13          	li	t3,10
  lw x4,0(x3)
80000184:	0001a203          	lw	tp,0(gp)
  li x28, 11
80000188:	00b00e13          	li	t3,11
  lh x4,0(x3)
8000018c:	00019203          	lh	tp,0(gp)
  li x28, 12
80000190:	00c00e13          	li	t3,12



  li x28, 13
80000194:	00d00e13          	li	t3,13
  lw x1,0(x0)
80000198:	00002083          	lw	ra,0(zero) # 0 <_stack_size-0x800>
//unalignedPcA:
  //j unalignedPcA+2
  //lw x1,0(x0)

  li x28, 14
8000019c:	00e00e13          	li	t3,14
  hret  
800001a0:	20200073          	hret
  li x28, 15
800001a4:	00f00e13          	li	t3,15


  li x1, 0xF00FFF60
800001a8:	f01000b7          	lui	ra,0xf0100
800001ac:	f6008093          	addi	ra,ra,-160 # f00fff60 <_etext+0x700ffd54>
  lw x2, 0(x1)
800001b0:	0000a103          	lw	sp,0(ra)
  li x28, 16
800001b4:	01000e13          	li	t3,16
  sw x2, 0(x1)
800001b8:	0020a023          	sw	sp,0(ra)
  li x28, 17
800001bc:	01100e13          	li	t3,17
  jr  x1
800001c0:	00008067          	ret

Disassembly of section .text:

800001c4 <irqCpp>:
}


void irqCpp(int irq){

}
800001c4:	00008067          	ret

800001c8 <main>:
}
800001c8:	00000513          	li	a0,0
800001cc:	00008067          	ret
800001d0:	0010                	0x10
800001d2:	0000                	unimp
800001d4:	0000                	unimp
800001d6:	0000                	unimp
800001d8:	7a01                	lui	s4,0xfffe0
800001da:	0052                	c.slli	zero,0x14
800001dc:	7c01                	lui	s8,0xfffe0
800001de:	0101                	addi	sp,sp,0
800001e0:	00020d1b          	0x20d1b
800001e4:	0010                	0x10
800001e6:	0000                	unimp
800001e8:	0018                	0x18
800001ea:	0000                	unimp
800001ec:	ffdc                	fsw	fa5,60(a5)
800001ee:	ffff                	0xffff
800001f0:	0008                	0x8
800001f2:	0000                	unimp
800001f4:	0000                	unimp
800001f6:	0000                	unimp
800001f8:	0010                	0x10
800001fa:	0000                	unimp
800001fc:	002c                	addi	a1,sp,8
800001fe:	0000                	unimp
80000200:	ffc4                	fsw	fs1,60(a5)
80000202:	ffff                	0xffff
80000204:	0004                	0x4
80000206:	0000                	unimp
80000208:	0000                	unimp
	...
