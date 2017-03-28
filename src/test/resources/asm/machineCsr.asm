
build/machineCsr.elf:     file format elf32-littleriscv


Disassembly of section .yolo:

00000000 <trap_entry-0x20>:
  j _start
   0:	0900006f          	j	90 <_start>
  nop
   4:	00000013          	nop
  nop
   8:	00000013          	nop
  nop
   c:	00000013          	nop
  nop
  10:	00000013          	nop
  nop
  14:	00000013          	nop
  nop
  18:	00000013          	nop
  nop
  1c:	00000013          	nop

00000020 <trap_entry>:

.global  trap_entry
trap_entry:
  csrr x28, mcause
  20:	34202e73          	csrr	t3,mcause

  bnez x28, notICmdAlignementException  
  24:	000e1e63          	bnez	t3,40 <notICmdAlignementException>
  li   x30, 0xFFFFFFFC  
  28:	ffc00f13          	li	t5,-4
  csrr x29, mepc
  2c:	34102ef3          	csrr	t4,mepc
  and  x29,x29,x30
  30:	01eefeb3          	and	t4,t4,t5
  addi x29, x29, 4
  34:	004e8e93          	addi	t4,t4,4
  csrw mepc, x29
  38:	341e9073          	csrw	mepc,t4
  j mepcFixed
  3c:	01c0006f          	j	58 <mepcFixed>

00000040 <notICmdAlignementException>:

notICmdAlignementException:
  li   x29, 0x80000000
  40:	80000eb7          	lui	t4,0x80000
  and  x30, x28, x29
  44:	01de7f33          	and	t5,t3,t4
  bnez x30, mepcFixed
  48:	000f1863          	bnez	t5,58 <mepcFixed>
  csrr x29, mepc
  4c:	34102ef3          	csrr	t4,mepc
  addi x29, x29, 4
  50:	004e8e93          	addi	t4,t4,4 # 80000004 <_bss_end+0x3fff397c>
  csrw mepc, x29
  54:	341e9073          	csrw	mepc,t4

00000058 <mepcFixed>:
mepcFixed:


  li   x29, 0x80000003u
  58:	80000eb7          	lui	t4,0x80000
  5c:	003e8e93          	addi	t4,t4,3 # 80000003 <_bss_end+0x3fff397b>
  bne  x29, x28, noSoftwareInterrupt
  60:	01ce9663          	bne	t4,t3,6c <noSoftwareInterrupt>
  li x29, 0x008
  64:	00800e93          	li	t4,8
  csrc mip, x29
  68:	344eb073          	csrc	mip,t4

0000006c <noSoftwareInterrupt>:

noSoftwareInterrupt:

  li   x29, 0x80000007u
  6c:	80000eb7          	lui	t4,0x80000
  70:	007e8e93          	addi	t4,t4,7 # 80000007 <_bss_end+0x3fff397f>
  bne  x29, x28, noTimerInterrupt
  74:	01ce9463          	bne	t4,t3,7c <noTimerInterrupt>
  csrw mie, 0
  78:	30405073          	csrwi	mie,0

0000007c <noTimerInterrupt>:
noTimerInterrupt:

  li   x29, 0x8000000bu
  7c:	80000eb7          	lui	t4,0x80000
  80:	00be8e93          	addi	t4,t4,11 # 8000000b <_bss_end+0x3fff3983>
  bne  x29, x28, noExernalInterrupt
  84:	01ce9463          	bne	t4,t3,8c <noExernalInterrupt>
  csrw mie, 0
  88:	30405073          	csrwi	mie,0

0000008c <noExernalInterrupt>:
noExernalInterrupt:

  mret
  8c:	30200073          	mret

00000090 <_start>:
  
  
  .text
  .globl _start
_start:
  li x28, 1
  90:	00100e13          	li	t3,1
  scall
  94:	00000073          	ecall

  li x28, 2
  98:	00200e13          	li	t3,2
  li t0, 0x008
  9c:	00800293          	li	t0,8
  csrs mstatus,t0
  a0:	3002a073          	csrs	mstatus,t0
  li t0, 0x008
  a4:	00800293          	li	t0,8
  csrw mie,t0
  a8:	30429073          	csrw	mie,t0
  li t0, 0x008
  ac:	00800293          	li	t0,8
  csrs mip,t0
  b0:	3442a073          	csrs	mip,t0
  nop
  b4:	00000013          	nop
  nop
  b8:	00000013          	nop
  nop
  bc:	00000013          	nop
  nop
  c0:	00000013          	nop
  nop
  c4:	00000013          	nop
  nop
  c8:	00000013          	nop
  nop
  cc:	00000013          	nop
  nop
  d0:	00000013          	nop
  nop
  d4:	00000013          	nop
  nop
  d8:	00000013          	nop
  nop
  dc:	00000013          	nop
  nop
  e0:	00000013          	nop


  li x28, 3
  e4:	00300e13          	li	t3,3
  li t0, 0x080
  e8:	08000293          	li	t0,128
  csrw mie,t0
  ec:	30429073          	csrw	mie,t0
  nop
  f0:	00000013          	nop
  nop
  f4:	00000013          	nop
  nop
  f8:	00000013          	nop
  nop
  fc:	00000013          	nop
  nop
 100:	00000013          	nop
  nop
 104:	00000013          	nop
  nop
 108:	00000013          	nop

  li x28, 4
 10c:	00400e13          	li	t3,4
  li t0, 0x800
 110:	000012b7          	lui	t0,0x1
 114:	80028293          	addi	t0,t0,-2048 # 800 <_stack_size>
  csrw mie,t0
 118:	30429073          	csrw	mie,t0
  nop
 11c:	00000013          	nop
  nop
 120:	00000013          	nop
  nop
 124:	00000013          	nop
  nop
 128:	00000013          	nop
  nop
 12c:	00000013          	nop
  nop
 130:	00000013          	nop
  nop
 134:	00000013          	nop

  li x28, 5
 138:	00500e13          	li	t3,5
  li x3, 0xF00FFF40
 13c:	f01001b7          	lui	gp,0xf0100
 140:	f4018193          	addi	gp,gp,-192 # f00fff40 <_bss_end+0xb00f38b8>
  lw x4, 0(x3)
 144:	0001a203          	lw	tp,0(gp)
  lw x5, 4(x3)
 148:	0041a283          	lw	t0,4(gp)
  addi x4, x4, 1023
 14c:	3ff20213          	addi	tp,tp,1023 # 3ff <unalignedPcA+0x263>
  sw x4, 8(x3)
 150:	0041a423          	sw	tp,8(gp)
  sw x5, 12(x3)
 154:	0051a623          	sw	t0,12(gp)
  li x28, 6
 158:	00600e13          	li	t3,6
  li x4, 0x080
 15c:	08000213          	li	tp,128
  csrw mie,x4
 160:	30421073          	csrw	mie,tp
  li x28, 7
 164:	00700e13          	li	t3,7
  wfi
 168:	10500073          	wfi


  li x28, 8
 16c:	00800e13          	li	t3,8
  li x3, 1
 170:	00100193          	li	gp,1
  sw x4,0(x3)
 174:	0041a023          	sw	tp,0(gp)
  li x28, 9
 178:	00900e13          	li	t3,9
  sh x4,0(x3)
 17c:	00419023          	sh	tp,0(gp)
  li x28, 10
 180:	00a00e13          	li	t3,10
  lw x4,0(x3)
 184:	0001a203          	lw	tp,0(gp)
  li x28, 11
 188:	00b00e13          	li	t3,11
  lh x4,0(x3)
 18c:	00019203          	lh	tp,0(gp)
  li x28, 12
 190:	00c00e13          	li	t3,12



  li x28, 13
 194:	00d00e13          	li	t3,13
  lw x1,0(x0)
 198:	00002083          	lw	ra,0(zero) # 0 <trap_entry-0x20>

0000019c <unalignedPcA>:
unalignedPcA:
  j unalignedPcA+2
 19c:	0020006f          	j	19e <unalignedPcA+0x2>
  lw x1,0(x0)
 1a0:	00002083          	lw	ra,0(zero) # 0 <trap_entry-0x20>

  li x28, 14
 1a4:	00e00e13          	li	t3,14
  hret  
 1a8:	20200073          	hret
  li x28, 15
 1ac:	00f00e13          	li	t3,15


  li x1, 0xF00FFF60
 1b0:	f01000b7          	lui	ra,0xf0100
 1b4:	f6008093          	addi	ra,ra,-160 # f00fff60 <_bss_end+0xb00f38d8>
  lw x2, 0(x1)
 1b8:	0000a103          	lw	sp,0(ra)
  li x28, 16
 1bc:	01000e13          	li	t3,16
  sw x2, 0(x1)
 1c0:	0020a023          	sw	sp,0(ra)
  li x28, 17
 1c4:	01100e13          	li	t3,17
  jr  x1
 1c8:	00008067          	ret

Disassembly of section .text:

40000000 <fstat>:
	return 0;
}

int fstat(int fd, struct _stat *buffer) {
	return 0;
}
40000000:	00000513          	li	a0,0
40000004:	00008067          	ret

40000008 <isatty>:

int isatty(int fd) {
	return 0;
}
40000008:	00000513          	li	a0,0
4000000c:	00008067          	ret

40000010 <close>:
40000010:	00000297          	auipc	t0,0x0
40000014:	ff828067          	jr	-8(t0) # 40000008 <isatty>

40000018 <lseek>:

long lseek(int fd, long offset, int origin) {
	return 0;
}
40000018:	00000513          	li	a0,0
4000001c:	00008067          	ret

40000020 <read>:

int read(int fd, void *buffer, unsigned int count) {
	return 0;
}
40000020:	00000513          	li	a0,0
40000024:	00008067          	ret

40000028 <writeChar>:

extern UartCtrl *uartStdio;
void writeChar(char value) {
	TEST_COM_BASE[0] = value;
40000028:	f01007b7          	lui	a5,0xf0100
4000002c:	f0a7a023          	sw	a0,-256(a5) # f00fff00 <_bss_end+0xb00f3878>
40000030:	00008067          	ret

40000034 <writeChars>:
}

void writeChars(char* value) {
40000034:	ff010113          	addi	sp,sp,-16
40000038:	00812423          	sw	s0,8(sp)
4000003c:	00112623          	sw	ra,12(sp)
40000040:	00050413          	mv	s0,a0
	while (*value) {
40000044:	00054503          	lbu	a0,0(a0)
40000048:	00050c63          	beqz	a0,40000060 <writeChars+0x2c>
		writeChar(*(value++));
4000004c:	00140413          	addi	s0,s0,1
40000050:	00000297          	auipc	t0,0x0
40000054:	fd8280e7          	jalr	-40(t0) # 40000028 <writeChar>
	while (*value) {
40000058:	00044503          	lbu	a0,0(s0)
4000005c:	fe0518e3          	bnez	a0,4000004c <writeChars+0x18>
	}
}
40000060:	00c12083          	lw	ra,12(sp)
40000064:	00812403          	lw	s0,8(sp)
40000068:	01010113          	addi	sp,sp,16
4000006c:	00008067          	ret

40000070 <write>:

int write(int fd, const void *buffer, unsigned int count) {
40000070:	ff010113          	addi	sp,sp,-16
40000074:	00912223          	sw	s1,4(sp)
40000078:	01212023          	sw	s2,0(sp)
4000007c:	00112623          	sw	ra,12(sp)
40000080:	00812423          	sw	s0,8(sp)
40000084:	00060913          	mv	s2,a2
40000088:	00c584b3          	add	s1,a1,a2
	for (int idx = 0; idx < count; idx++) {
4000008c:	00060e63          	beqz	a2,400000a8 <write+0x38>
40000090:	00058413          	mv	s0,a1
		writeChar(((char*) buffer)[idx]);
40000094:	00044503          	lbu	a0,0(s0)
40000098:	00140413          	addi	s0,s0,1
4000009c:	00000297          	auipc	t0,0x0
400000a0:	f8c280e7          	jalr	-116(t0) # 40000028 <writeChar>
	for (int idx = 0; idx < count; idx++) {
400000a4:	fe8498e3          	bne	s1,s0,40000094 <write+0x24>
	}
	return count;
}
400000a8:	00c12083          	lw	ra,12(sp)
400000ac:	00090513          	mv	a0,s2
400000b0:	00812403          	lw	s0,8(sp)
400000b4:	00412483          	lw	s1,4(sp)
400000b8:	00012903          	lw	s2,0(sp)
400000bc:	01010113          	addi	sp,sp,16
400000c0:	00008067          	ret

400000c4 <irqCpp>:
	printf("Miaou !!");
	TEST_COM_BASE[8] = 0;
}


void irqCpp(uint32_t irq){
400000c4:	00008067          	ret

400000c8 <main>:
	printf("Miaou !!");
400000c8:	4000b537          	lui	a0,0x4000b
int main() {
400000cc:	ff010113          	addi	sp,sp,-16
	printf("Miaou !!");
400000d0:	61050513          	addi	a0,a0,1552 # 4000b610 <__clzsi2+0x70>
int main() {
400000d4:	00112623          	sw	ra,12(sp)
	printf("Miaou !!");
400000d8:	00000297          	auipc	t0,0x0
400000dc:	064280e7          	jalr	100(t0) # 4000013c <printf>
}
400000e0:	00c12083          	lw	ra,12(sp)
	TEST_COM_BASE[8] = 0;
400000e4:	f01007b7          	lui	a5,0xf0100
}
400000e8:	00000513          	li	a0,0
	TEST_COM_BASE[8] = 0;
400000ec:	f207a023          	sw	zero,-224(a5) # f00fff20 <_bss_end+0xb00f3898>
}
400000f0:	01010113          	addi	sp,sp,16
400000f4:	00008067          	ret

400000f8 <_printf_r>:
400000f8:	fc010113          	addi	sp,sp,-64
400000fc:	02c12423          	sw	a2,40(sp)
40000100:	02d12623          	sw	a3,44(sp)
40000104:	02f12a23          	sw	a5,52(sp)
40000108:	02e12823          	sw	a4,48(sp)
4000010c:	03012c23          	sw	a6,56(sp)
40000110:	03112e23          	sw	a7,60(sp)
40000114:	00058613          	mv	a2,a1
40000118:	00852583          	lw	a1,8(a0)
4000011c:	02810793          	addi	a5,sp,40
40000120:	00078693          	mv	a3,a5
40000124:	00112e23          	sw	ra,28(sp)
40000128:	00f12623          	sw	a5,12(sp)
4000012c:	064000ef          	jal	ra,40000190 <_vfprintf_r>
40000130:	01c12083          	lw	ra,28(sp)
40000134:	04010113          	addi	sp,sp,64
40000138:	00008067          	ret

4000013c <printf>:
4000013c:	4000c337          	lui	t1,0x4000c
40000140:	62c32303          	lw	t1,1580(t1) # 4000c62c <_impure_ptr>
40000144:	fc010113          	addi	sp,sp,-64
40000148:	02c12423          	sw	a2,40(sp)
4000014c:	02d12623          	sw	a3,44(sp)
40000150:	02f12a23          	sw	a5,52(sp)
40000154:	02b12223          	sw	a1,36(sp)
40000158:	02e12823          	sw	a4,48(sp)
4000015c:	03012c23          	sw	a6,56(sp)
40000160:	03112e23          	sw	a7,60(sp)
40000164:	00832583          	lw	a1,8(t1)
40000168:	02410793          	addi	a5,sp,36
4000016c:	00050613          	mv	a2,a0
40000170:	00078693          	mv	a3,a5
40000174:	00030513          	mv	a0,t1
40000178:	00112e23          	sw	ra,28(sp)
4000017c:	00f12623          	sw	a5,12(sp)
40000180:	010000ef          	jal	ra,40000190 <_vfprintf_r>
40000184:	01c12083          	lw	ra,28(sp)
40000188:	04010113          	addi	sp,sp,64
4000018c:	00008067          	ret

40000190 <_vfprintf_r>:
40000190:	eb010113          	addi	sp,sp,-336
40000194:	14112623          	sw	ra,332(sp)
40000198:	14812423          	sw	s0,328(sp)
4000019c:	13412c23          	sw	s4,312(sp)
400001a0:	13512a23          	sw	s5,308(sp)
400001a4:	00058a13          	mv	s4,a1
400001a8:	00060413          	mv	s0,a2
400001ac:	02d12023          	sw	a3,32(sp)
400001b0:	14912223          	sw	s1,324(sp)
400001b4:	15212023          	sw	s2,320(sp)
400001b8:	13312e23          	sw	s3,316(sp)
400001bc:	13612823          	sw	s6,304(sp)
400001c0:	13712623          	sw	s7,300(sp)
400001c4:	13812423          	sw	s8,296(sp)
400001c8:	13912223          	sw	s9,292(sp)
400001cc:	13a12023          	sw	s10,288(sp)
400001d0:	11b12e23          	sw	s11,284(sp)
400001d4:	00050a93          	mv	s5,a0
400001d8:	1bc040ef          	jal	ra,40004394 <_localeconv_r>
400001dc:	00052783          	lw	a5,0(a0)
400001e0:	00078513          	mv	a0,a5
400001e4:	04f12423          	sw	a5,72(sp)
400001e8:	12c060ef          	jal	ra,40006314 <strlen>
400001ec:	04a12023          	sw	a0,64(sp)
400001f0:	000a8663          	beqz	s5,400001fc <_vfprintf_r+0x6c>
400001f4:	038aa783          	lw	a5,56(s5)
400001f8:	220784e3          	beqz	a5,40000c20 <_vfprintf_r+0xa90>
400001fc:	00ca1703          	lh	a4,12(s4)
40000200:	01071793          	slli	a5,a4,0x10
40000204:	0107d793          	srli	a5,a5,0x10
40000208:	01279693          	slli	a3,a5,0x12
4000020c:	0206c663          	bltz	a3,40000238 <_vfprintf_r+0xa8>
40000210:	064a2683          	lw	a3,100(s4)
40000214:	000027b7          	lui	a5,0x2
40000218:	00f767b3          	or	a5,a4,a5
4000021c:	ffffe737          	lui	a4,0xffffe
40000220:	fff70713          	addi	a4,a4,-1 # ffffdfff <_bss_end+0xbfff1977>
40000224:	00e6f733          	and	a4,a3,a4
40000228:	00fa1623          	sh	a5,12(s4)
4000022c:	01079793          	slli	a5,a5,0x10
40000230:	06ea2223          	sw	a4,100(s4)
40000234:	0107d793          	srli	a5,a5,0x10
40000238:	0087f713          	andi	a4,a5,8
4000023c:	7a070c63          	beqz	a4,400009f4 <_vfprintf_r+0x864>
40000240:	010a2703          	lw	a4,16(s4)
40000244:	7a070863          	beqz	a4,400009f4 <_vfprintf_r+0x864>
40000248:	01a7f793          	andi	a5,a5,26
4000024c:	00a00713          	li	a4,10
40000250:	7ce78263          	beq	a5,a4,40000a14 <_vfprintf_r+0x884>
40000254:	4000c7b7          	lui	a5,0x4000c
40000258:	c387a703          	lw	a4,-968(a5) # 4000bc38 <__clz_tab+0x104>
4000025c:	c3c7a783          	lw	a5,-964(a5)
40000260:	0d010c13          	addi	s8,sp,208
40000264:	04e12823          	sw	a4,80(sp)
40000268:	00078693          	mv	a3,a5
4000026c:	04f12a23          	sw	a5,84(sp)
40000270:	4000b7b7          	lui	a5,0x4000b
40000274:	61c78793          	addi	a5,a5,1564 # 4000b61c <__clzsi2+0x7c>
40000278:	09812e23          	sw	s8,156(sp)
4000027c:	0a012223          	sw	zero,164(sp)
40000280:	0a012023          	sw	zero,160(sp)
40000284:	02012a23          	sw	zero,52(sp)
40000288:	02012c23          	sw	zero,56(sp)
4000028c:	02012e23          	sw	zero,60(sp)
40000290:	000c0313          	mv	t1,s8
40000294:	04012223          	sw	zero,68(sp)
40000298:	04012623          	sw	zero,76(sp)
4000029c:	00012c23          	sw	zero,24(sp)
400002a0:	02f12223          	sw	a5,36(sp)
400002a4:	04e12c23          	sw	a4,88(sp)
400002a8:	04d12e23          	sw	a3,92(sp)
400002ac:	00044783          	lbu	a5,0(s0)
400002b0:	4e078e63          	beqz	a5,400007ac <_vfprintf_r+0x61c>
400002b4:	02500713          	li	a4,37
400002b8:	00040493          	mv	s1,s0
400002bc:	00e79663          	bne	a5,a4,400002c8 <_vfprintf_r+0x138>
400002c0:	0540006f          	j	40000314 <_vfprintf_r+0x184>
400002c4:	00e78863          	beq	a5,a4,400002d4 <_vfprintf_r+0x144>
400002c8:	00148493          	addi	s1,s1,1
400002cc:	0004c783          	lbu	a5,0(s1)
400002d0:	fe079ae3          	bnez	a5,400002c4 <_vfprintf_r+0x134>
400002d4:	40848933          	sub	s2,s1,s0
400002d8:	02090e63          	beqz	s2,40000314 <_vfprintf_r+0x184>
400002dc:	0a412703          	lw	a4,164(sp)
400002e0:	0a012783          	lw	a5,160(sp)
400002e4:	00832023          	sw	s0,0(t1)
400002e8:	01270733          	add	a4,a4,s2
400002ec:	00178793          	addi	a5,a5,1
400002f0:	01232223          	sw	s2,4(t1)
400002f4:	0ae12223          	sw	a4,164(sp)
400002f8:	0af12023          	sw	a5,160(sp)
400002fc:	00700713          	li	a4,7
40000300:	00830313          	addi	t1,t1,8
40000304:	06f744e3          	blt	a4,a5,40000b6c <_vfprintf_r+0x9dc>
40000308:	01812783          	lw	a5,24(sp)
4000030c:	012787b3          	add	a5,a5,s2
40000310:	00f12c23          	sw	a5,24(sp)
40000314:	0004c783          	lbu	a5,0(s1)
40000318:	52078663          	beqz	a5,40000844 <_vfprintf_r+0x6b4>
4000031c:	fff00c93          	li	s9,-1
40000320:	00148413          	addi	s0,s1,1
40000324:	06010fa3          	sb	zero,127(sp)
40000328:	00000613          	li	a2,0
4000032c:	00000593          	li	a1,0
40000330:	00000493          	li	s1,0
40000334:	00000d93          	li	s11,0
40000338:	05800713          	li	a4,88
4000033c:	00900693          	li	a3,9
40000340:	02a00893          	li	a7,42
40000344:	000c8f13          	mv	t5,s9
40000348:	00100513          	li	a0,1
4000034c:	02000e93          	li	t4,32
40000350:	02b00813          	li	a6,43
40000354:	00044983          	lbu	s3,0(s0)
40000358:	00140413          	addi	s0,s0,1
4000035c:	fe098793          	addi	a5,s3,-32
40000360:	56f768e3          	bltu	a4,a5,400010d0 <_vfprintf_r+0xf40>
40000364:	02412e03          	lw	t3,36(sp)
40000368:	00279793          	slli	a5,a5,0x2
4000036c:	01c787b3          	add	a5,a5,t3
40000370:	0007a783          	lw	a5,0(a5)
40000374:	00078067          	jr	a5
40000378:	010ded93          	ori	s11,s11,16
4000037c:	fd9ff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000380:	010ded93          	ori	s11,s11,16
40000384:	010df793          	andi	a5,s11,16
40000388:	00078463          	beqz	a5,40000390 <_vfprintf_r+0x200>
4000038c:	0980106f          	j	40001424 <_vfprintf_r+0x1294>
40000390:	040df793          	andi	a5,s11,64
40000394:	02012683          	lw	a3,32(sp)
40000398:	520792e3          	bnez	a5,400010bc <_vfprintf_r+0xf2c>
4000039c:	0006a783          	lw	a5,0(a3)
400003a0:	00468693          	addi	a3,a3,4
400003a4:	00000713          	li	a4,0
400003a8:	02d12023          	sw	a3,32(sp)
400003ac:	06010fa3          	sb	zero,127(sp)
400003b0:	00000613          	li	a2,0
400003b4:	fff00693          	li	a3,-1
400003b8:	08dc8e63          	beq	s9,a3,40000454 <_vfprintf_r+0x2c4>
400003bc:	f7fdf693          	andi	a3,s11,-129
400003c0:	00d12823          	sw	a3,16(sp)
400003c4:	08079c63          	bnez	a5,4000045c <_vfprintf_r+0x2cc>
400003c8:	780c9263          	bnez	s9,40000b4c <_vfprintf_r+0x9bc>
400003cc:	120710e3          	bnez	a4,40000cec <_vfprintf_r+0xb5c>
400003d0:	001df793          	andi	a5,s11,1
400003d4:	00f12e23          	sw	a5,28(sp)
400003d8:	000c0913          	mv	s2,s8
400003dc:	0a078e63          	beqz	a5,40000498 <_vfprintf_r+0x308>
400003e0:	03000793          	li	a5,48
400003e4:	0cf107a3          	sb	a5,207(sp)
400003e8:	0cf10913          	addi	s2,sp,207
400003ec:	0ac0006f          	j	40000498 <_vfprintf_r+0x308>
400003f0:	010ded93          	ori	s11,s11,16
400003f4:	010df793          	andi	a5,s11,16
400003f8:	04079263          	bnez	a5,4000043c <_vfprintf_r+0x2ac>
400003fc:	040df793          	andi	a5,s11,64
40000400:	02012683          	lw	a3,32(sp)
40000404:	02078e63          	beqz	a5,40000440 <_vfprintf_r+0x2b0>
40000408:	0006d783          	lhu	a5,0(a3)
4000040c:	00468693          	addi	a3,a3,4
40000410:	00100713          	li	a4,1
40000414:	02d12023          	sw	a3,32(sp)
40000418:	f95ff06f          	j	400003ac <_vfprintf_r+0x21c>
4000041c:	02012783          	lw	a5,32(sp)
40000420:	0007a483          	lw	s1,0(a5)
40000424:	00478793          	addi	a5,a5,4
40000428:	02f12023          	sw	a5,32(sp)
4000042c:	f204d4e3          	bgez	s1,40000354 <_vfprintf_r+0x1c4>
40000430:	409004b3          	neg	s1,s1
40000434:	004ded93          	ori	s11,s11,4
40000438:	f1dff06f          	j	40000354 <_vfprintf_r+0x1c4>
4000043c:	02012683          	lw	a3,32(sp)
40000440:	0006a783          	lw	a5,0(a3)
40000444:	00468693          	addi	a3,a3,4
40000448:	00100713          	li	a4,1
4000044c:	02d12023          	sw	a3,32(sp)
40000450:	f5dff06f          	j	400003ac <_vfprintf_r+0x21c>
40000454:	6e078e63          	beqz	a5,40000b50 <_vfprintf_r+0x9c0>
40000458:	01b12823          	sw	s11,16(sp)
4000045c:	00100693          	li	a3,1
40000460:	48d704e3          	beq	a4,a3,400010e8 <_vfprintf_r+0xf58>
40000464:	00200693          	li	a3,2
40000468:	76d71463          	bne	a4,a3,40000bd0 <_vfprintf_r+0xa40>
4000046c:	04412683          	lw	a3,68(sp)
40000470:	000c0913          	mv	s2,s8
40000474:	00f7f713          	andi	a4,a5,15
40000478:	00e68733          	add	a4,a3,a4
4000047c:	00074703          	lbu	a4,0(a4)
40000480:	fff90913          	addi	s2,s2,-1
40000484:	0047d793          	srli	a5,a5,0x4
40000488:	00e90023          	sb	a4,0(s2)
4000048c:	fe0794e3          	bnez	a5,40000474 <_vfprintf_r+0x2e4>
40000490:	412c07b3          	sub	a5,s8,s2
40000494:	00f12e23          	sw	a5,28(sp)
40000498:	01c12783          	lw	a5,28(sp)
4000049c:	000c8b93          	mv	s7,s9
400004a0:	00fcd463          	ble	a5,s9,400004a8 <_vfprintf_r+0x318>
400004a4:	00078b93          	mv	s7,a5
400004a8:	02012823          	sw	zero,48(sp)
400004ac:	30061c63          	bnez	a2,400007c4 <_vfprintf_r+0x634>
400004b0:	01012783          	lw	a5,16(sp)
400004b4:	0027f793          	andi	a5,a5,2
400004b8:	02f12423          	sw	a5,40(sp)
400004bc:	00078463          	beqz	a5,400004c4 <_vfprintf_r+0x334>
400004c0:	002b8b93          	addi	s7,s7,2
400004c4:	01012783          	lw	a5,16(sp)
400004c8:	0847f793          	andi	a5,a5,132
400004cc:	02f12623          	sw	a5,44(sp)
400004d0:	2e079e63          	bnez	a5,400007cc <_vfprintf_r+0x63c>
400004d4:	41748b33          	sub	s6,s1,s7
400004d8:	2f605a63          	blez	s6,400007cc <_vfprintf_r+0x63c>
400004dc:	4000b6b7          	lui	a3,0x4000b
400004e0:	01000813          	li	a6,16
400004e4:	0a412783          	lw	a5,164(sp)
400004e8:	0a012703          	lw	a4,160(sp)
400004ec:	78068d13          	addi	s10,a3,1920 # 4000b780 <blanks.4138>
400004f0:	07685263          	ble	s6,a6,40000554 <_vfprintf_r+0x3c4>
400004f4:	00700d93          	li	s11,7
400004f8:	00c0006f          	j	40000504 <_vfprintf_r+0x374>
400004fc:	ff0b0b13          	addi	s6,s6,-16
40000500:	05685a63          	ble	s6,a6,40000554 <_vfprintf_r+0x3c4>
40000504:	01078793          	addi	a5,a5,16
40000508:	00170713          	addi	a4,a4,1
4000050c:	01a32023          	sw	s10,0(t1)
40000510:	01032223          	sw	a6,4(t1)
40000514:	0af12223          	sw	a5,164(sp)
40000518:	0ae12023          	sw	a4,160(sp)
4000051c:	00830313          	addi	t1,t1,8
40000520:	fceddee3          	ble	a4,s11,400004fc <_vfprintf_r+0x36c>
40000524:	09c10613          	addi	a2,sp,156
40000528:	000a0593          	mv	a1,s4
4000052c:	000a8513          	mv	a0,s5
40000530:	01012a23          	sw	a6,20(sp)
40000534:	769050ef          	jal	ra,4000649c <__sprint_r>
40000538:	32051263          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
4000053c:	01412803          	lw	a6,20(sp)
40000540:	ff0b0b13          	addi	s6,s6,-16
40000544:	0a412783          	lw	a5,164(sp)
40000548:	0a012703          	lw	a4,160(sp)
4000054c:	000c0313          	mv	t1,s8
40000550:	fb684ae3          	blt	a6,s6,40000504 <_vfprintf_r+0x374>
40000554:	00fb07b3          	add	a5,s6,a5
40000558:	00170713          	addi	a4,a4,1
4000055c:	01a32023          	sw	s10,0(t1)
40000560:	01632223          	sw	s6,4(t1)
40000564:	0af12223          	sw	a5,164(sp)
40000568:	0ae12023          	sw	a4,160(sp)
4000056c:	00700693          	li	a3,7
40000570:	3ae6c2e3          	blt	a3,a4,40001114 <_vfprintf_r+0xf84>
40000574:	07f14603          	lbu	a2,127(sp)
40000578:	00830313          	addi	t1,t1,8
4000057c:	02060a63          	beqz	a2,400005b0 <_vfprintf_r+0x420>
40000580:	0a012703          	lw	a4,160(sp)
40000584:	07f10693          	addi	a3,sp,127
40000588:	00d32023          	sw	a3,0(t1)
4000058c:	00178793          	addi	a5,a5,1
40000590:	00100693          	li	a3,1
40000594:	00170713          	addi	a4,a4,1
40000598:	00d32223          	sw	a3,4(t1)
4000059c:	0af12223          	sw	a5,164(sp)
400005a0:	0ae12023          	sw	a4,160(sp)
400005a4:	00700693          	li	a3,7
400005a8:	00830313          	addi	t1,t1,8
400005ac:	5ce6ce63          	blt	a3,a4,40000b88 <_vfprintf_r+0x9f8>
400005b0:	02812703          	lw	a4,40(sp)
400005b4:	02070a63          	beqz	a4,400005e8 <_vfprintf_r+0x458>
400005b8:	0a012703          	lw	a4,160(sp)
400005bc:	08010693          	addi	a3,sp,128
400005c0:	00d32023          	sw	a3,0(t1)
400005c4:	00278793          	addi	a5,a5,2
400005c8:	00200693          	li	a3,2
400005cc:	00170713          	addi	a4,a4,1
400005d0:	00d32223          	sw	a3,4(t1)
400005d4:	0af12223          	sw	a5,164(sp)
400005d8:	0ae12023          	sw	a4,160(sp)
400005dc:	00700693          	li	a3,7
400005e0:	00830313          	addi	t1,t1,8
400005e4:	5ce6c263          	blt	a3,a4,40000ba8 <_vfprintf_r+0xa18>
400005e8:	02c12683          	lw	a3,44(sp)
400005ec:	08000713          	li	a4,128
400005f0:	34e68263          	beq	a3,a4,40000934 <_vfprintf_r+0x7a4>
400005f4:	01c12703          	lw	a4,28(sp)
400005f8:	40ec8cb3          	sub	s9,s9,a4
400005fc:	0b905863          	blez	s9,400006ac <_vfprintf_r+0x51c>
40000600:	4000b6b7          	lui	a3,0x4000b
40000604:	01000d93          	li	s11,16
40000608:	0a012703          	lw	a4,160(sp)
4000060c:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
40000610:	059dde63          	ble	s9,s11,4000066c <_vfprintf_r+0x4dc>
40000614:	00700d13          	li	s10,7
40000618:	00c0006f          	j	40000624 <_vfprintf_r+0x494>
4000061c:	ff0c8c93          	addi	s9,s9,-16
40000620:	059dd663          	ble	s9,s11,4000066c <_vfprintf_r+0x4dc>
40000624:	01078793          	addi	a5,a5,16
40000628:	00170713          	addi	a4,a4,1
4000062c:	01632023          	sw	s6,0(t1)
40000630:	01b32223          	sw	s11,4(t1)
40000634:	0af12223          	sw	a5,164(sp)
40000638:	0ae12023          	sw	a4,160(sp)
4000063c:	00830313          	addi	t1,t1,8
40000640:	fced5ee3          	ble	a4,s10,4000061c <_vfprintf_r+0x48c>
40000644:	09c10613          	addi	a2,sp,156
40000648:	000a0593          	mv	a1,s4
4000064c:	000a8513          	mv	a0,s5
40000650:	64d050ef          	jal	ra,4000649c <__sprint_r>
40000654:	20051463          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000658:	ff0c8c93          	addi	s9,s9,-16
4000065c:	0a412783          	lw	a5,164(sp)
40000660:	0a012703          	lw	a4,160(sp)
40000664:	000c0313          	mv	t1,s8
40000668:	fb9dcee3          	blt	s11,s9,40000624 <_vfprintf_r+0x494>
4000066c:	019787b3          	add	a5,a5,s9
40000670:	00170713          	addi	a4,a4,1
40000674:	01632023          	sw	s6,0(t1)
40000678:	01932223          	sw	s9,4(t1)
4000067c:	0af12223          	sw	a5,164(sp)
40000680:	0ae12023          	sw	a4,160(sp)
40000684:	00700693          	li	a3,7
40000688:	00830313          	addi	t1,t1,8
4000068c:	02e6d063          	ble	a4,a3,400006ac <_vfprintf_r+0x51c>
40000690:	09c10613          	addi	a2,sp,156
40000694:	000a0593          	mv	a1,s4
40000698:	000a8513          	mv	a0,s5
4000069c:	601050ef          	jal	ra,4000649c <__sprint_r>
400006a0:	1a051e63          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
400006a4:	0a412783          	lw	a5,164(sp)
400006a8:	000c0313          	mv	t1,s8
400006ac:	01012703          	lw	a4,16(sp)
400006b0:	10077713          	andi	a4,a4,256
400006b4:	1e071a63          	bnez	a4,400008a8 <_vfprintf_r+0x718>
400006b8:	01c12683          	lw	a3,28(sp)
400006bc:	0a012703          	lw	a4,160(sp)
400006c0:	01232023          	sw	s2,0(t1)
400006c4:	00d787b3          	add	a5,a5,a3
400006c8:	00170713          	addi	a4,a4,1
400006cc:	00d32223          	sw	a3,4(t1)
400006d0:	0af12223          	sw	a5,164(sp)
400006d4:	0ae12023          	sw	a4,160(sp)
400006d8:	00700693          	li	a3,7
400006dc:	14e6c463          	blt	a3,a4,40000824 <_vfprintf_r+0x694>
400006e0:	00830313          	addi	t1,t1,8
400006e4:	01012703          	lw	a4,16(sp)
400006e8:	00477b13          	andi	s6,a4,4
400006ec:	080b0c63          	beqz	s6,40000784 <_vfprintf_r+0x5f4>
400006f0:	41748933          	sub	s2,s1,s7
400006f4:	09205863          	blez	s2,40000784 <_vfprintf_r+0x5f4>
400006f8:	4000b6b7          	lui	a3,0x4000b
400006fc:	01000993          	li	s3,16
40000700:	0a012703          	lw	a4,160(sp)
40000704:	78068d13          	addi	s10,a3,1920 # 4000b780 <blanks.4138>
40000708:	0529de63          	ble	s2,s3,40000764 <_vfprintf_r+0x5d4>
4000070c:	00700b13          	li	s6,7
40000710:	00c0006f          	j	4000071c <_vfprintf_r+0x58c>
40000714:	ff090913          	addi	s2,s2,-16
40000718:	0529d663          	ble	s2,s3,40000764 <_vfprintf_r+0x5d4>
4000071c:	01078793          	addi	a5,a5,16
40000720:	00170713          	addi	a4,a4,1
40000724:	01a32023          	sw	s10,0(t1)
40000728:	01332223          	sw	s3,4(t1)
4000072c:	0af12223          	sw	a5,164(sp)
40000730:	0ae12023          	sw	a4,160(sp)
40000734:	00830313          	addi	t1,t1,8
40000738:	fceb5ee3          	ble	a4,s6,40000714 <_vfprintf_r+0x584>
4000073c:	09c10613          	addi	a2,sp,156
40000740:	000a0593          	mv	a1,s4
40000744:	000a8513          	mv	a0,s5
40000748:	555050ef          	jal	ra,4000649c <__sprint_r>
4000074c:	10051863          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000750:	ff090913          	addi	s2,s2,-16
40000754:	0a412783          	lw	a5,164(sp)
40000758:	0a012703          	lw	a4,160(sp)
4000075c:	000c0313          	mv	t1,s8
40000760:	fb29cee3          	blt	s3,s2,4000071c <_vfprintf_r+0x58c>
40000764:	012787b3          	add	a5,a5,s2
40000768:	00170713          	addi	a4,a4,1
4000076c:	01a32023          	sw	s10,0(t1)
40000770:	01232223          	sw	s2,4(t1)
40000774:	0af12223          	sw	a5,164(sp)
40000778:	0ae12023          	sw	a4,160(sp)
4000077c:	00700693          	li	a3,7
40000780:	12e6c0e3          	blt	a3,a4,400010a0 <_vfprintf_r+0xf10>
40000784:	0174d463          	ble	s7,s1,4000078c <_vfprintf_r+0x5fc>
40000788:	000b8493          	mv	s1,s7
4000078c:	01812703          	lw	a4,24(sp)
40000790:	00970733          	add	a4,a4,s1
40000794:	00e12c23          	sw	a4,24(sp)
40000798:	38079e63          	bnez	a5,40000b34 <_vfprintf_r+0x9a4>
4000079c:	00044783          	lbu	a5,0(s0)
400007a0:	0a012023          	sw	zero,160(sp)
400007a4:	000c0313          	mv	t1,s8
400007a8:	b00796e3          	bnez	a5,400002b4 <_vfprintf_r+0x124>
400007ac:	00040493          	mv	s1,s0
400007b0:	b65ff06f          	j	40000314 <_vfprintf_r+0x184>
400007b4:	02d00793          	li	a5,45
400007b8:	06f10fa3          	sb	a5,127(sp)
400007bc:	02d00613          	li	a2,45
400007c0:	00000c93          	li	s9,0
400007c4:	001b8b93          	addi	s7,s7,1
400007c8:	ce9ff06f          	j	400004b0 <_vfprintf_r+0x320>
400007cc:	0a412783          	lw	a5,164(sp)
400007d0:	dadff06f          	j	4000057c <_vfprintf_r+0x3ec>
400007d4:	012787b3          	add	a5,a5,s2
400007d8:	00198993          	addi	s3,s3,1
400007dc:	016ca023          	sw	s6,0(s9)
400007e0:	012ca223          	sw	s2,4(s9)
400007e4:	0af12223          	sw	a5,164(sp)
400007e8:	0b312023          	sw	s3,160(sp)
400007ec:	00700713          	li	a4,7
400007f0:	53374863          	blt	a4,s3,40000d20 <_vfprintf_r+0xb90>
400007f4:	008c8c93          	addi	s9,s9,8
400007f8:	04c12683          	lw	a3,76(sp)
400007fc:	08c10713          	addi	a4,sp,140
40000800:	00198993          	addi	s3,s3,1
40000804:	00f687b3          	add	a5,a3,a5
40000808:	00eca023          	sw	a4,0(s9)
4000080c:	00dca223          	sw	a3,4(s9)
40000810:	0af12223          	sw	a5,164(sp)
40000814:	0b312023          	sw	s3,160(sp)
40000818:	00700713          	li	a4,7
4000081c:	008c8313          	addi	t1,s9,8
40000820:	ed3752e3          	ble	s3,a4,400006e4 <_vfprintf_r+0x554>
40000824:	09c10613          	addi	a2,sp,156
40000828:	000a0593          	mv	a1,s4
4000082c:	000a8513          	mv	a0,s5
40000830:	46d050ef          	jal	ra,4000649c <__sprint_r>
40000834:	02051463          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000838:	0a412783          	lw	a5,164(sp)
4000083c:	000c0313          	mv	t1,s8
40000840:	ea5ff06f          	j	400006e4 <_vfprintf_r+0x554>
40000844:	0a412783          	lw	a5,164(sp)
40000848:	00078a63          	beqz	a5,4000085c <_vfprintf_r+0x6cc>
4000084c:	09c10613          	addi	a2,sp,156
40000850:	000a0593          	mv	a1,s4
40000854:	000a8513          	mv	a0,s5
40000858:	445050ef          	jal	ra,4000649c <__sprint_r>
4000085c:	00ca5783          	lhu	a5,12(s4)
40000860:	0407f793          	andi	a5,a5,64
40000864:	680794e3          	bnez	a5,400016ec <_vfprintf_r+0x155c>
40000868:	14c12083          	lw	ra,332(sp)
4000086c:	01812503          	lw	a0,24(sp)
40000870:	14812403          	lw	s0,328(sp)
40000874:	14412483          	lw	s1,324(sp)
40000878:	14012903          	lw	s2,320(sp)
4000087c:	13c12983          	lw	s3,316(sp)
40000880:	13812a03          	lw	s4,312(sp)
40000884:	13412a83          	lw	s5,308(sp)
40000888:	13012b03          	lw	s6,304(sp)
4000088c:	12c12b83          	lw	s7,300(sp)
40000890:	12812c03          	lw	s8,296(sp)
40000894:	12412c83          	lw	s9,292(sp)
40000898:	12012d03          	lw	s10,288(sp)
4000089c:	11c12d83          	lw	s11,284(sp)
400008a0:	15010113          	addi	sp,sp,336
400008a4:	00008067          	ret
400008a8:	06500713          	li	a4,101
400008ac:	19375663          	ble	s3,a4,40000a38 <_vfprintf_r+0x8a8>
400008b0:	03812683          	lw	a3,56(sp)
400008b4:	03c12703          	lw	a4,60(sp)
400008b8:	00000613          	li	a2,0
400008bc:	00068513          	mv	a0,a3
400008c0:	00070593          	mv	a1,a4
400008c4:	00000693          	li	a3,0
400008c8:	00612e23          	sw	t1,28(sp)
400008cc:	00f12a23          	sw	a5,20(sp)
400008d0:	354090ef          	jal	ra,40009c24 <__eqdf2>
400008d4:	01412783          	lw	a5,20(sp)
400008d8:	01c12303          	lw	t1,28(sp)
400008dc:	34051863          	bnez	a0,40000c2c <_vfprintf_r+0xa9c>
400008e0:	0a012703          	lw	a4,160(sp)
400008e4:	4000b6b7          	lui	a3,0x4000b
400008e8:	7e068693          	addi	a3,a3,2016 # 4000b7e0 <zeroes.4139+0x50>
400008ec:	00178793          	addi	a5,a5,1
400008f0:	00d32023          	sw	a3,0(t1)
400008f4:	00170713          	addi	a4,a4,1
400008f8:	00100693          	li	a3,1
400008fc:	00d32223          	sw	a3,4(t1)
40000900:	0af12223          	sw	a5,164(sp)
40000904:	0ae12023          	sw	a4,160(sp)
40000908:	00700793          	li	a5,7
4000090c:	00830313          	addi	t1,t1,8
40000910:	52e7c4e3          	blt	a5,a4,40001638 <_vfprintf_r+0x14a8>
40000914:	08412783          	lw	a5,132(sp)
40000918:	03412703          	lw	a4,52(sp)
4000091c:	00e7cee3          	blt	a5,a4,40001138 <_vfprintf_r+0xfa8>
40000920:	01012783          	lw	a5,16(sp)
40000924:	0017f793          	andi	a5,a5,1
40000928:	000798e3          	bnez	a5,40001138 <_vfprintf_r+0xfa8>
4000092c:	0a412783          	lw	a5,164(sp)
40000930:	db5ff06f          	j	400006e4 <_vfprintf_r+0x554>
40000934:	41748d33          	sub	s10,s1,s7
40000938:	cba05ee3          	blez	s10,400005f4 <_vfprintf_r+0x464>
4000093c:	4000b6b7          	lui	a3,0x4000b
40000940:	01000d93          	li	s11,16
40000944:	0a012703          	lw	a4,160(sp)
40000948:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
4000094c:	07add263          	ble	s10,s11,400009b0 <_vfprintf_r+0x820>
40000950:	00700813          	li	a6,7
40000954:	00c0006f          	j	40000960 <_vfprintf_r+0x7d0>
40000958:	ff0d0d13          	addi	s10,s10,-16
4000095c:	05adda63          	ble	s10,s11,400009b0 <_vfprintf_r+0x820>
40000960:	01078793          	addi	a5,a5,16
40000964:	00170713          	addi	a4,a4,1
40000968:	01632023          	sw	s6,0(t1)
4000096c:	01b32223          	sw	s11,4(t1)
40000970:	0af12223          	sw	a5,164(sp)
40000974:	0ae12023          	sw	a4,160(sp)
40000978:	00830313          	addi	t1,t1,8
4000097c:	fce85ee3          	ble	a4,a6,40000958 <_vfprintf_r+0x7c8>
40000980:	09c10613          	addi	a2,sp,156
40000984:	000a0593          	mv	a1,s4
40000988:	000a8513          	mv	a0,s5
4000098c:	01012a23          	sw	a6,20(sp)
40000990:	30d050ef          	jal	ra,4000649c <__sprint_r>
40000994:	ec0514e3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000998:	ff0d0d13          	addi	s10,s10,-16
4000099c:	0a412783          	lw	a5,164(sp)
400009a0:	0a012703          	lw	a4,160(sp)
400009a4:	000c0313          	mv	t1,s8
400009a8:	01412803          	lw	a6,20(sp)
400009ac:	fbadcae3          	blt	s11,s10,40000960 <_vfprintf_r+0x7d0>
400009b0:	01a787b3          	add	a5,a5,s10
400009b4:	00170713          	addi	a4,a4,1
400009b8:	01632023          	sw	s6,0(t1)
400009bc:	01a32223          	sw	s10,4(t1)
400009c0:	0af12223          	sw	a5,164(sp)
400009c4:	0ae12023          	sw	a4,160(sp)
400009c8:	00700693          	li	a3,7
400009cc:	00830313          	addi	t1,t1,8
400009d0:	c2e6d2e3          	ble	a4,a3,400005f4 <_vfprintf_r+0x464>
400009d4:	09c10613          	addi	a2,sp,156
400009d8:	000a0593          	mv	a1,s4
400009dc:	000a8513          	mv	a0,s5
400009e0:	2bd050ef          	jal	ra,4000649c <__sprint_r>
400009e4:	e6051ce3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
400009e8:	0a412783          	lw	a5,164(sp)
400009ec:	000c0313          	mv	t1,s8
400009f0:	c05ff06f          	j	400005f4 <_vfprintf_r+0x464>
400009f4:	000a0593          	mv	a1,s4
400009f8:	000a8513          	mv	a0,s5
400009fc:	404010ef          	jal	ra,40001e00 <__swsetup_r>
40000a00:	4e0516e3          	bnez	a0,400016ec <_vfprintf_r+0x155c>
40000a04:	00ca5783          	lhu	a5,12(s4)
40000a08:	00a00713          	li	a4,10
40000a0c:	01a7f793          	andi	a5,a5,26
40000a10:	84e792e3          	bne	a5,a4,40000254 <_vfprintf_r+0xc4>
40000a14:	00ea1783          	lh	a5,14(s4)
40000a18:	8207cee3          	bltz	a5,40000254 <_vfprintf_r+0xc4>
40000a1c:	02012683          	lw	a3,32(sp)
40000a20:	00040613          	mv	a2,s0
40000a24:	000a0593          	mv	a1,s4
40000a28:	000a8513          	mv	a0,s5
40000a2c:	314010ef          	jal	ra,40001d40 <__sbprintf>
40000a30:	00a12c23          	sw	a0,24(sp)
40000a34:	e35ff06f          	j	40000868 <_vfprintf_r+0x6d8>
40000a38:	03412683          	lw	a3,52(sp)
40000a3c:	00100713          	li	a4,1
40000a40:	00178793          	addi	a5,a5,1
40000a44:	18d754e3          	ble	a3,a4,400013cc <_vfprintf_r+0x123c>
40000a48:	0a012983          	lw	s3,160(sp)
40000a4c:	00100713          	li	a4,1
40000a50:	00e32223          	sw	a4,4(t1)
40000a54:	00198993          	addi	s3,s3,1
40000a58:	01232023          	sw	s2,0(t1)
40000a5c:	0af12223          	sw	a5,164(sp)
40000a60:	0b312023          	sw	s3,160(sp)
40000a64:	00700713          	li	a4,7
40000a68:	00830313          	addi	t1,t1,8
40000a6c:	19374ae3          	blt	a4,s3,40001400 <_vfprintf_r+0x1270>
40000a70:	04012703          	lw	a4,64(sp)
40000a74:	04812683          	lw	a3,72(sp)
40000a78:	00198993          	addi	s3,s3,1
40000a7c:	00f707b3          	add	a5,a4,a5
40000a80:	00e32223          	sw	a4,4(t1)
40000a84:	00d32023          	sw	a3,0(t1)
40000a88:	0af12223          	sw	a5,164(sp)
40000a8c:	0b312023          	sw	s3,160(sp)
40000a90:	00700713          	li	a4,7
40000a94:	00830c93          	addi	s9,t1,8
40000a98:	19374ae3          	blt	a4,s3,4000142c <_vfprintf_r+0x129c>
40000a9c:	03c12703          	lw	a4,60(sp)
40000aa0:	03812683          	lw	a3,56(sp)
40000aa4:	00000613          	li	a2,0
40000aa8:	00070593          	mv	a1,a4
40000aac:	00068513          	mv	a0,a3
40000ab0:	00000693          	li	a3,0
40000ab4:	00f12a23          	sw	a5,20(sp)
40000ab8:	16c090ef          	jal	ra,40009c24 <__eqdf2>
40000abc:	01412783          	lw	a5,20(sp)
40000ac0:	03412703          	lw	a4,52(sp)
40000ac4:	22051a63          	bnez	a0,40000cf8 <_vfprintf_r+0xb68>
40000ac8:	fff70913          	addi	s2,a4,-1
40000acc:	d32056e3          	blez	s2,400007f8 <_vfprintf_r+0x668>
40000ad0:	4000b6b7          	lui	a3,0x4000b
40000ad4:	01000d13          	li	s10,16
40000ad8:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
40000adc:	cf2d5ce3          	ble	s2,s10,400007d4 <_vfprintf_r+0x644>
40000ae0:	00700d93          	li	s11,7
40000ae4:	00c0006f          	j	40000af0 <_vfprintf_r+0x960>
40000ae8:	ff090913          	addi	s2,s2,-16
40000aec:	cf2d54e3          	ble	s2,s10,400007d4 <_vfprintf_r+0x644>
40000af0:	01078793          	addi	a5,a5,16
40000af4:	00198993          	addi	s3,s3,1
40000af8:	016ca023          	sw	s6,0(s9)
40000afc:	01aca223          	sw	s10,4(s9)
40000b00:	0af12223          	sw	a5,164(sp)
40000b04:	0b312023          	sw	s3,160(sp)
40000b08:	008c8c93          	addi	s9,s9,8
40000b0c:	fd3ddee3          	ble	s3,s11,40000ae8 <_vfprintf_r+0x958>
40000b10:	09c10613          	addi	a2,sp,156
40000b14:	000a0593          	mv	a1,s4
40000b18:	000a8513          	mv	a0,s5
40000b1c:	181050ef          	jal	ra,4000649c <__sprint_r>
40000b20:	d2051ee3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000b24:	0a412783          	lw	a5,164(sp)
40000b28:	0a012983          	lw	s3,160(sp)
40000b2c:	000c0c93          	mv	s9,s8
40000b30:	fb9ff06f          	j	40000ae8 <_vfprintf_r+0x958>
40000b34:	09c10613          	addi	a2,sp,156
40000b38:	000a0593          	mv	a1,s4
40000b3c:	000a8513          	mv	a0,s5
40000b40:	15d050ef          	jal	ra,4000649c <__sprint_r>
40000b44:	c4050ce3          	beqz	a0,4000079c <_vfprintf_r+0x60c>
40000b48:	d15ff06f          	j	4000085c <_vfprintf_r+0x6cc>
40000b4c:	01012d83          	lw	s11,16(sp)
40000b50:	00100693          	li	a3,1
40000b54:	6ad70a63          	beq	a4,a3,40001208 <_vfprintf_r+0x1078>
40000b58:	00200793          	li	a5,2
40000b5c:	06f71663          	bne	a4,a5,40000bc8 <_vfprintf_r+0xa38>
40000b60:	01b12823          	sw	s11,16(sp)
40000b64:	00000793          	li	a5,0
40000b68:	905ff06f          	j	4000046c <_vfprintf_r+0x2dc>
40000b6c:	09c10613          	addi	a2,sp,156
40000b70:	000a0593          	mv	a1,s4
40000b74:	000a8513          	mv	a0,s5
40000b78:	125050ef          	jal	ra,4000649c <__sprint_r>
40000b7c:	ce0510e3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000b80:	000c0313          	mv	t1,s8
40000b84:	f84ff06f          	j	40000308 <_vfprintf_r+0x178>
40000b88:	09c10613          	addi	a2,sp,156
40000b8c:	000a0593          	mv	a1,s4
40000b90:	000a8513          	mv	a0,s5
40000b94:	109050ef          	jal	ra,4000649c <__sprint_r>
40000b98:	cc0512e3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000b9c:	0a412783          	lw	a5,164(sp)
40000ba0:	000c0313          	mv	t1,s8
40000ba4:	a0dff06f          	j	400005b0 <_vfprintf_r+0x420>
40000ba8:	09c10613          	addi	a2,sp,156
40000bac:	000a0593          	mv	a1,s4
40000bb0:	000a8513          	mv	a0,s5
40000bb4:	0e9050ef          	jal	ra,4000649c <__sprint_r>
40000bb8:	ca0512e3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000bbc:	0a412783          	lw	a5,164(sp)
40000bc0:	000c0313          	mv	t1,s8
40000bc4:	a25ff06f          	j	400005e8 <_vfprintf_r+0x458>
40000bc8:	01b12823          	sw	s11,16(sp)
40000bcc:	00000793          	li	a5,0
40000bd0:	000c0693          	mv	a3,s8
40000bd4:	0080006f          	j	40000bdc <_vfprintf_r+0xa4c>
40000bd8:	00090693          	mv	a3,s2
40000bdc:	0077f713          	andi	a4,a5,7
40000be0:	03070713          	addi	a4,a4,48
40000be4:	fee68fa3          	sb	a4,-1(a3)
40000be8:	0037d793          	srli	a5,a5,0x3
40000bec:	fff68913          	addi	s2,a3,-1
40000bf0:	fe0794e3          	bnez	a5,40000bd8 <_vfprintf_r+0xa48>
40000bf4:	01012783          	lw	a5,16(sp)
40000bf8:	0017f793          	andi	a5,a5,1
40000bfc:	88078ae3          	beqz	a5,40000490 <_vfprintf_r+0x300>
40000c00:	03000793          	li	a5,48
40000c04:	88f706e3          	beq	a4,a5,40000490 <_vfprintf_r+0x300>
40000c08:	ffe68693          	addi	a3,a3,-2
40000c0c:	fef90fa3          	sb	a5,-1(s2)
40000c10:	40dc07b3          	sub	a5,s8,a3
40000c14:	00f12e23          	sw	a5,28(sp)
40000c18:	00068913          	mv	s2,a3
40000c1c:	87dff06f          	j	40000498 <_vfprintf_r+0x308>
40000c20:	000a8513          	mv	a0,s5
40000c24:	0dc030ef          	jal	ra,40003d00 <__sinit>
40000c28:	dd4ff06f          	j	400001fc <_vfprintf_r+0x6c>
40000c2c:	08412683          	lw	a3,132(sp)
40000c30:	22d052e3          	blez	a3,40001654 <_vfprintf_r+0x14c4>
40000c34:	03012703          	lw	a4,48(sp)
40000c38:	03412683          	lw	a3,52(sp)
40000c3c:	00070993          	mv	s3,a4
40000c40:	00e6d463          	ble	a4,a3,40000c48 <_vfprintf_r+0xab8>
40000c44:	00068993          	mv	s3,a3
40000c48:	03305663          	blez	s3,40000c74 <_vfprintf_r+0xae4>
40000c4c:	0a012703          	lw	a4,160(sp)
40000c50:	013787b3          	add	a5,a5,s3
40000c54:	01232023          	sw	s2,0(t1)
40000c58:	00170713          	addi	a4,a4,1
40000c5c:	01332223          	sw	s3,4(t1)
40000c60:	0af12223          	sw	a5,164(sp)
40000c64:	0ae12023          	sw	a4,160(sp)
40000c68:	00700693          	li	a3,7
40000c6c:	00830313          	addi	t1,t1,8
40000c70:	28e6cae3          	blt	a3,a4,40001704 <_vfprintf_r+0x1574>
40000c74:	5009cee3          	bltz	s3,40001990 <_vfprintf_r+0x1800>
40000c78:	03012703          	lw	a4,48(sp)
40000c7c:	413709b3          	sub	s3,a4,s3
40000c80:	5f305263          	blez	s3,40001264 <_vfprintf_r+0x10d4>
40000c84:	4000b6b7          	lui	a3,0x4000b
40000c88:	01000c93          	li	s9,16
40000c8c:	0a012703          	lw	a4,160(sp)
40000c90:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
40000c94:	593cd863          	ble	s3,s9,40001224 <_vfprintf_r+0x1094>
40000c98:	00700d13          	li	s10,7
40000c9c:	00c0006f          	j	40000ca8 <_vfprintf_r+0xb18>
40000ca0:	ff098993          	addi	s3,s3,-16
40000ca4:	593cd063          	ble	s3,s9,40001224 <_vfprintf_r+0x1094>
40000ca8:	01078793          	addi	a5,a5,16
40000cac:	00170713          	addi	a4,a4,1
40000cb0:	01632023          	sw	s6,0(t1)
40000cb4:	01932223          	sw	s9,4(t1)
40000cb8:	0af12223          	sw	a5,164(sp)
40000cbc:	0ae12023          	sw	a4,160(sp)
40000cc0:	00830313          	addi	t1,t1,8
40000cc4:	fced5ee3          	ble	a4,s10,40000ca0 <_vfprintf_r+0xb10>
40000cc8:	09c10613          	addi	a2,sp,156
40000ccc:	000a0593          	mv	a1,s4
40000cd0:	000a8513          	mv	a0,s5
40000cd4:	7c8050ef          	jal	ra,4000649c <__sprint_r>
40000cd8:	b80512e3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000cdc:	0a412783          	lw	a5,164(sp)
40000ce0:	0a012703          	lw	a4,160(sp)
40000ce4:	000c0313          	mv	t1,s8
40000ce8:	fb9ff06f          	j	40000ca0 <_vfprintf_r+0xb10>
40000cec:	00012e23          	sw	zero,28(sp)
40000cf0:	000c0913          	mv	s2,s8
40000cf4:	fa4ff06f          	j	40000498 <_vfprintf_r+0x308>
40000cf8:	fff70713          	addi	a4,a4,-1
40000cfc:	00e787b3          	add	a5,a5,a4
40000d00:	00190913          	addi	s2,s2,1
40000d04:	00198993          	addi	s3,s3,1
40000d08:	00eca223          	sw	a4,4(s9)
40000d0c:	012ca023          	sw	s2,0(s9)
40000d10:	0af12223          	sw	a5,164(sp)
40000d14:	0b312023          	sw	s3,160(sp)
40000d18:	00700713          	li	a4,7
40000d1c:	ad375ce3          	ble	s3,a4,400007f4 <_vfprintf_r+0x664>
40000d20:	09c10613          	addi	a2,sp,156
40000d24:	000a0593          	mv	a1,s4
40000d28:	000a8513          	mv	a0,s5
40000d2c:	770050ef          	jal	ra,4000649c <__sprint_r>
40000d30:	b20516e3          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40000d34:	0a412783          	lw	a5,164(sp)
40000d38:	0a012983          	lw	s3,160(sp)
40000d3c:	000c0c93          	mv	s9,s8
40000d40:	ab9ff06f          	j	400007f8 <_vfprintf_r+0x668>
40000d44:	00050613          	mv	a2,a0
40000d48:	00080593          	mv	a1,a6
40000d4c:	e08ff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000d50:	00060463          	beqz	a2,40000d58 <_vfprintf_r+0xbc8>
40000d54:	7a50006f          	j	40001cf8 <_vfprintf_r+0x1b68>
40000d58:	010df793          	andi	a5,s11,16
40000d5c:	64079a63          	bnez	a5,400013b0 <_vfprintf_r+0x1220>
40000d60:	040dfd93          	andi	s11,s11,64
40000d64:	640d8663          	beqz	s11,400013b0 <_vfprintf_r+0x1220>
40000d68:	02012703          	lw	a4,32(sp)
40000d6c:	00072783          	lw	a5,0(a4)
40000d70:	00470713          	addi	a4,a4,4
40000d74:	02e12023          	sw	a4,32(sp)
40000d78:	01815703          	lhu	a4,24(sp)
40000d7c:	00e79023          	sh	a4,0(a5)
40000d80:	d2cff06f          	j	400002ac <_vfprintf_r+0x11c>
40000d84:	02012783          	lw	a5,32(sp)
40000d88:	06010fa3          	sb	zero,127(sp)
40000d8c:	0007a903          	lw	s2,0(a5)
40000d90:	00478b13          	addi	s6,a5,4
40000d94:	400902e3          	beqz	s2,40001998 <_vfprintf_r+0x1808>
40000d98:	fff00793          	li	a5,-1
40000d9c:	00612823          	sw	t1,16(sp)
40000da0:	2cfc8ae3          	beq	s9,a5,40001874 <_vfprintf_r+0x16e4>
40000da4:	000c8613          	mv	a2,s9
40000da8:	00000593          	li	a1,0
40000dac:	00090513          	mv	a0,s2
40000db0:	735030ef          	jal	ra,40004ce4 <memchr>
40000db4:	01012303          	lw	t1,16(sp)
40000db8:	52050ae3          	beqz	a0,40001aec <_vfprintf_r+0x195c>
40000dbc:	412507b3          	sub	a5,a0,s2
40000dc0:	00f12e23          	sw	a5,28(sp)
40000dc4:	00078b93          	mv	s7,a5
40000dc8:	2c07c2e3          	bltz	a5,4000188c <_vfprintf_r+0x16fc>
40000dcc:	07f14603          	lbu	a2,127(sp)
40000dd0:	03612023          	sw	s6,32(sp)
40000dd4:	01b12823          	sw	s11,16(sp)
40000dd8:	02012823          	sw	zero,48(sp)
40000ddc:	00000c93          	li	s9,0
40000de0:	ec060863          	beqz	a2,400004b0 <_vfprintf_r+0x320>
40000de4:	9e1ff06f          	j	400007c4 <_vfprintf_r+0x634>
40000de8:	720610e3          	bnez	a2,40001d08 <_vfprintf_r+0x1b78>
40000dec:	010ded93          	ori	s11,s11,16
40000df0:	010df793          	andi	a5,s11,16
40000df4:	64079e63          	bnez	a5,40001450 <_vfprintf_r+0x12c0>
40000df8:	040df793          	andi	a5,s11,64
40000dfc:	02012703          	lw	a4,32(sp)
40000e00:	58078863          	beqz	a5,40001390 <_vfprintf_r+0x1200>
40000e04:	00071783          	lh	a5,0(a4)
40000e08:	00470713          	addi	a4,a4,4
40000e0c:	02e12023          	sw	a4,32(sp)
40000e10:	6607c463          	bltz	a5,40001478 <_vfprintf_r+0x12e8>
40000e14:	07f14603          	lbu	a2,127(sp)
40000e18:	00100713          	li	a4,1
40000e1c:	d98ff06f          	j	400003b4 <_vfprintf_r+0x224>
40000e20:	6e0610e3          	bnez	a2,40001d00 <_vfprintf_r+0x1b70>
40000e24:	008df793          	andi	a5,s11,8
40000e28:	7e078463          	beqz	a5,40001610 <_vfprintf_r+0x1480>
40000e2c:	02012703          	lw	a4,32(sp)
40000e30:	06010513          	addi	a0,sp,96
40000e34:	00612823          	sw	t1,16(sp)
40000e38:	00072783          	lw	a5,0(a4)
40000e3c:	00470693          	addi	a3,a4,4
40000e40:	02d12023          	sw	a3,32(sp)
40000e44:	0007a703          	lw	a4,0(a5)
40000e48:	06e12023          	sw	a4,96(sp)
40000e4c:	0047a703          	lw	a4,4(a5)
40000e50:	06e12223          	sw	a4,100(sp)
40000e54:	0087a703          	lw	a4,8(a5)
40000e58:	06e12423          	sw	a4,104(sp)
40000e5c:	00c7a783          	lw	a5,12(a5)
40000e60:	06f12623          	sw	a5,108(sp)
40000e64:	33c0a0ef          	jal	ra,4000b1a0 <__trunctfdf2>
40000e68:	01012303          	lw	t1,16(sp)
40000e6c:	02a12c23          	sw	a0,56(sp)
40000e70:	02b12e23          	sw	a1,60(sp)
40000e74:	03c12783          	lw	a5,60(sp)
40000e78:	80000937          	lui	s2,0x80000
40000e7c:	03812b03          	lw	s6,56(sp)
40000e80:	fff94913          	not	s2,s2
40000e84:	05012603          	lw	a2,80(sp)
40000e88:	05412683          	lw	a3,84(sp)
40000e8c:	0127f933          	and	s2,a5,s2
40000e90:	000b0513          	mv	a0,s6
40000e94:	00090593          	mv	a1,s2
40000e98:	00612823          	sw	t1,16(sp)
40000e9c:	06c0a0ef          	jal	ra,4000af08 <__unorddf2>
40000ea0:	01012303          	lw	t1,16(sp)
40000ea4:	5e051663          	bnez	a0,40001490 <_vfprintf_r+0x1300>
40000ea8:	05812603          	lw	a2,88(sp)
40000eac:	05c12683          	lw	a3,92(sp)
40000eb0:	000b0513          	mv	a0,s6
40000eb4:	00090593          	mv	a1,s2
40000eb8:	6fd080ef          	jal	ra,40009db4 <__ledf2>
40000ebc:	01012303          	lw	t1,16(sp)
40000ec0:	5ca05863          	blez	a0,40001490 <_vfprintf_r+0x1300>
40000ec4:	03812703          	lw	a4,56(sp)
40000ec8:	03c12783          	lw	a5,60(sp)
40000ecc:	00000613          	li	a2,0
40000ed0:	00070513          	mv	a0,a4
40000ed4:	00078593          	mv	a1,a5
40000ed8:	00000693          	li	a3,0
40000edc:	00612823          	sw	t1,16(sp)
40000ee0:	6d5080ef          	jal	ra,40009db4 <__ledf2>
40000ee4:	01012303          	lw	t1,16(sp)
40000ee8:	2e0546e3          	bltz	a0,400019d4 <_vfprintf_r+0x1844>
40000eec:	07f14603          	lbu	a2,127(sp)
40000ef0:	04700793          	li	a5,71
40000ef4:	0137d2e3          	ble	s3,a5,400016f8 <_vfprintf_r+0x1568>
40000ef8:	4000b937          	lui	s2,0x4000b
40000efc:	7a490913          	addi	s2,s2,1956 # 4000b7a4 <zeroes.4139+0x14>
40000f00:	00300b93          	li	s7,3
40000f04:	f7fdf793          	andi	a5,s11,-129
40000f08:	00f12823          	sw	a5,16(sp)
40000f0c:	01712e23          	sw	s7,28(sp)
40000f10:	02012823          	sw	zero,48(sp)
40000f14:	00000c93          	li	s9,0
40000f18:	d8060c63          	beqz	a2,400004b0 <_vfprintf_r+0x320>
40000f1c:	8a9ff06f          	j	400007c4 <_vfprintf_r+0x634>
40000f20:	008ded93          	ori	s11,s11,8
40000f24:	c30ff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000f28:	00044983          	lbu	s3,0(s0)
40000f2c:	00140413          	addi	s0,s0,1
40000f30:	59198ae3          	beq	s3,a7,40001cc4 <_vfprintf_r+0x1b34>
40000f34:	fd098e13          	addi	t3,s3,-48
40000f38:	00000c93          	li	s9,0
40000f3c:	c3c6e063          	bltu	a3,t3,4000035c <_vfprintf_r+0x1cc>
40000f40:	00140413          	addi	s0,s0,1
40000f44:	002c9793          	slli	a5,s9,0x2
40000f48:	fff44983          	lbu	s3,-1(s0)
40000f4c:	019787b3          	add	a5,a5,s9
40000f50:	00179793          	slli	a5,a5,0x1
40000f54:	01c78cb3          	add	s9,a5,t3
40000f58:	fd098e13          	addi	t3,s3,-48
40000f5c:	ffc6f2e3          	bleu	t3,a3,40000f40 <_vfprintf_r+0xdb0>
40000f60:	bfcff06f          	j	4000035c <_vfprintf_r+0x1cc>
40000f64:	080ded93          	ori	s11,s11,128
40000f68:	becff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000f6c:	02012683          	lw	a3,32(sp)
40000f70:	03000713          	li	a4,48
40000f74:	08e10023          	sb	a4,128(sp)
40000f78:	07800713          	li	a4,120
40000f7c:	08e100a3          	sb	a4,129(sp)
40000f80:	00468713          	addi	a4,a3,4
40000f84:	02e12023          	sw	a4,32(sp)
40000f88:	4000b737          	lui	a4,0x4000b
40000f8c:	7c470713          	addi	a4,a4,1988 # 4000b7c4 <zeroes.4139+0x34>
40000f90:	04e12223          	sw	a4,68(sp)
40000f94:	0006a783          	lw	a5,0(a3)
40000f98:	002ded93          	ori	s11,s11,2
40000f9c:	00200713          	li	a4,2
40000fa0:	07800993          	li	s3,120
40000fa4:	c08ff06f          	j	400003ac <_vfprintf_r+0x21c>
40000fa8:	00000493          	li	s1,0
40000fac:	fd098e13          	addi	t3,s3,-48
40000fb0:	00140413          	addi	s0,s0,1
40000fb4:	00249793          	slli	a5,s1,0x2
40000fb8:	fff44983          	lbu	s3,-1(s0)
40000fbc:	009787b3          	add	a5,a5,s1
40000fc0:	00179793          	slli	a5,a5,0x1
40000fc4:	00fe04b3          	add	s1,t3,a5
40000fc8:	fd098e13          	addi	t3,s3,-48
40000fcc:	ffc6f2e3          	bleu	t3,a3,40000fb0 <_vfprintf_r+0xe20>
40000fd0:	b8cff06f          	j	4000035c <_vfprintf_r+0x1cc>
40000fd4:	001ded93          	ori	s11,s11,1
40000fd8:	b7cff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000fdc:	b6059c63          	bnez	a1,40000354 <_vfprintf_r+0x1c4>
40000fe0:	00050613          	mv	a2,a0
40000fe4:	000e8593          	mv	a1,t4
40000fe8:	b6cff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000fec:	040ded93          	ori	s11,s11,64
40000ff0:	b64ff06f          	j	40000354 <_vfprintf_r+0x1c4>
40000ff4:	520616e3          	bnez	a2,40001d20 <_vfprintf_r+0x1b90>
40000ff8:	4000b7b7          	lui	a5,0x4000b
40000ffc:	7c478793          	addi	a5,a5,1988 # 4000b7c4 <zeroes.4139+0x34>
40001000:	04f12223          	sw	a5,68(sp)
40001004:	010df793          	andi	a5,s11,16
40001008:	44079e63          	bnez	a5,40001464 <_vfprintf_r+0x12d4>
4000100c:	040df793          	andi	a5,s11,64
40001010:	02012703          	lw	a4,32(sp)
40001014:	38078663          	beqz	a5,400013a0 <_vfprintf_r+0x1210>
40001018:	00075783          	lhu	a5,0(a4)
4000101c:	00470713          	addi	a4,a4,4
40001020:	02e12023          	sw	a4,32(sp)
40001024:	001df693          	andi	a3,s11,1
40001028:	00200713          	li	a4,2
4000102c:	b8068063          	beqz	a3,400003ac <_vfprintf_r+0x21c>
40001030:	b6078e63          	beqz	a5,400003ac <_vfprintf_r+0x21c>
40001034:	03000693          	li	a3,48
40001038:	08d10023          	sb	a3,128(sp)
4000103c:	093100a3          	sb	s3,129(sp)
40001040:	00ededb3          	or	s11,s11,a4
40001044:	b68ff06f          	j	400003ac <_vfprintf_r+0x21c>
40001048:	4c0618e3          	bnez	a2,40001d18 <_vfprintf_r+0x1b88>
4000104c:	4000b7b7          	lui	a5,0x4000b
40001050:	7b078793          	addi	a5,a5,1968 # 4000b7b0 <zeroes.4139+0x20>
40001054:	04f12223          	sw	a5,68(sp)
40001058:	fadff06f          	j	40001004 <_vfprintf_r+0xe74>
4000105c:	02012703          	lw	a4,32(sp)
40001060:	00100b93          	li	s7,1
40001064:	06010fa3          	sb	zero,127(sp)
40001068:	00072783          	lw	a5,0(a4)
4000106c:	0af10423          	sb	a5,168(sp)
40001070:	00470793          	addi	a5,a4,4
40001074:	02f12023          	sw	a5,32(sp)
40001078:	01b12823          	sw	s11,16(sp)
4000107c:	00000613          	li	a2,0
40001080:	01712e23          	sw	s7,28(sp)
40001084:	00000c93          	li	s9,0
40001088:	02012823          	sw	zero,48(sp)
4000108c:	0a810913          	addi	s2,sp,168
40001090:	c20ff06f          	j	400004b0 <_vfprintf_r+0x320>
40001094:	d4060ee3          	beqz	a2,40000df0 <_vfprintf_r+0xc60>
40001098:	06b10fa3          	sb	a1,127(sp)
4000109c:	d55ff06f          	j	40000df0 <_vfprintf_r+0xc60>
400010a0:	09c10613          	addi	a2,sp,156
400010a4:	000a0593          	mv	a1,s4
400010a8:	000a8513          	mv	a0,s5
400010ac:	3f0050ef          	jal	ra,4000649c <__sprint_r>
400010b0:	fa051663          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
400010b4:	0a412783          	lw	a5,164(sp)
400010b8:	eccff06f          	j	40000784 <_vfprintf_r+0x5f4>
400010bc:	0006d783          	lhu	a5,0(a3)
400010c0:	00468693          	addi	a3,a3,4
400010c4:	00000713          	li	a4,0
400010c8:	02d12023          	sw	a3,32(sp)
400010cc:	ae0ff06f          	j	400003ac <_vfprintf_r+0x21c>
400010d0:	440610e3          	bnez	a2,40001d10 <_vfprintf_r+0x1b80>
400010d4:	f6098863          	beqz	s3,40000844 <_vfprintf_r+0x6b4>
400010d8:	00100b93          	li	s7,1
400010dc:	0b310423          	sb	s3,168(sp)
400010e0:	06010fa3          	sb	zero,127(sp)
400010e4:	f95ff06f          	j	40001078 <_vfprintf_r+0xee8>
400010e8:	00900713          	li	a4,9
400010ec:	000c0913          	mv	s2,s8
400010f0:	00a00693          	li	a3,10
400010f4:	10f77863          	bleu	a5,a4,40001204 <_vfprintf_r+0x1074>
400010f8:	02d7f733          	remu	a4,a5,a3
400010fc:	fff90913          	addi	s2,s2,-1
40001100:	02d7d7b3          	divu	a5,a5,a3
40001104:	03070713          	addi	a4,a4,48
40001108:	00e90023          	sb	a4,0(s2)
4000110c:	fe0796e3          	bnez	a5,400010f8 <_vfprintf_r+0xf68>
40001110:	b80ff06f          	j	40000490 <_vfprintf_r+0x300>
40001114:	09c10613          	addi	a2,sp,156
40001118:	000a0593          	mv	a1,s4
4000111c:	000a8513          	mv	a0,s5
40001120:	37c050ef          	jal	ra,4000649c <__sprint_r>
40001124:	f2051c63          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001128:	07f14603          	lbu	a2,127(sp)
4000112c:	0a412783          	lw	a5,164(sp)
40001130:	000c0313          	mv	t1,s8
40001134:	c48ff06f          	j	4000057c <_vfprintf_r+0x3ec>
40001138:	04812783          	lw	a5,72(sp)
4000113c:	04012683          	lw	a3,64(sp)
40001140:	0a012703          	lw	a4,160(sp)
40001144:	00f32023          	sw	a5,0(t1)
40001148:	0a412783          	lw	a5,164(sp)
4000114c:	00170713          	addi	a4,a4,1
40001150:	00d32223          	sw	a3,4(t1)
40001154:	00f687b3          	add	a5,a3,a5
40001158:	0af12223          	sw	a5,164(sp)
4000115c:	0ae12023          	sw	a4,160(sp)
40001160:	00700693          	li	a3,7
40001164:	00830313          	addi	t1,t1,8
40001168:	6ee6c463          	blt	a3,a4,40001850 <_vfprintf_r+0x16c0>
4000116c:	03412703          	lw	a4,52(sp)
40001170:	fff70913          	addi	s2,a4,-1
40001174:	d7205863          	blez	s2,400006e4 <_vfprintf_r+0x554>
40001178:	4000b6b7          	lui	a3,0x4000b
4000117c:	01000993          	li	s3,16
40001180:	0a012703          	lw	a4,160(sp)
40001184:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
40001188:	0529dc63          	ble	s2,s3,400011e0 <_vfprintf_r+0x1050>
4000118c:	00700c93          	li	s9,7
40001190:	00c0006f          	j	4000119c <_vfprintf_r+0x100c>
40001194:	ff090913          	addi	s2,s2,-16
40001198:	0529d463          	ble	s2,s3,400011e0 <_vfprintf_r+0x1050>
4000119c:	01078793          	addi	a5,a5,16
400011a0:	00170713          	addi	a4,a4,1
400011a4:	01632023          	sw	s6,0(t1)
400011a8:	01332223          	sw	s3,4(t1)
400011ac:	0af12223          	sw	a5,164(sp)
400011b0:	0ae12023          	sw	a4,160(sp)
400011b4:	00830313          	addi	t1,t1,8
400011b8:	fcecdee3          	ble	a4,s9,40001194 <_vfprintf_r+0x1004>
400011bc:	09c10613          	addi	a2,sp,156
400011c0:	000a0593          	mv	a1,s4
400011c4:	000a8513          	mv	a0,s5
400011c8:	2d4050ef          	jal	ra,4000649c <__sprint_r>
400011cc:	e8051863          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
400011d0:	0a412783          	lw	a5,164(sp)
400011d4:	0a012703          	lw	a4,160(sp)
400011d8:	000c0313          	mv	t1,s8
400011dc:	fb9ff06f          	j	40001194 <_vfprintf_r+0x1004>
400011e0:	01632023          	sw	s6,0(t1)
400011e4:	01232223          	sw	s2,4(t1)
400011e8:	012787b3          	add	a5,a5,s2
400011ec:	00170713          	addi	a4,a4,1
400011f0:	0af12223          	sw	a5,164(sp)
400011f4:	0ae12023          	sw	a4,160(sp)
400011f8:	00700693          	li	a3,7
400011fc:	cee6d263          	ble	a4,a3,400006e0 <_vfprintf_r+0x550>
40001200:	e24ff06f          	j	40000824 <_vfprintf_r+0x694>
40001204:	01012d83          	lw	s11,16(sp)
40001208:	03078793          	addi	a5,a5,48
4000120c:	0cf107a3          	sb	a5,207(sp)
40001210:	00100793          	li	a5,1
40001214:	01b12823          	sw	s11,16(sp)
40001218:	00f12e23          	sw	a5,28(sp)
4000121c:	0cf10913          	addi	s2,sp,207
40001220:	a78ff06f          	j	40000498 <_vfprintf_r+0x308>
40001224:	013787b3          	add	a5,a5,s3
40001228:	00170713          	addi	a4,a4,1
4000122c:	01632023          	sw	s6,0(t1)
40001230:	01332223          	sw	s3,4(t1)
40001234:	0af12223          	sw	a5,164(sp)
40001238:	0ae12023          	sw	a4,160(sp)
4000123c:	00700693          	li	a3,7
40001240:	00830313          	addi	t1,t1,8
40001244:	02e6d063          	ble	a4,a3,40001264 <_vfprintf_r+0x10d4>
40001248:	09c10613          	addi	a2,sp,156
4000124c:	000a0593          	mv	a1,s4
40001250:	000a8513          	mv	a0,s5
40001254:	248050ef          	jal	ra,4000649c <__sprint_r>
40001258:	e0051263          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
4000125c:	0a412783          	lw	a5,164(sp)
40001260:	000c0313          	mv	t1,s8
40001264:	08412703          	lw	a4,132(sp)
40001268:	03412683          	lw	a3,52(sp)
4000126c:	0cd74863          	blt	a4,a3,4000133c <_vfprintf_r+0x11ac>
40001270:	01012683          	lw	a3,16(sp)
40001274:	0016f693          	andi	a3,a3,1
40001278:	0c069263          	bnez	a3,4000133c <_vfprintf_r+0x11ac>
4000127c:	03412683          	lw	a3,52(sp)
40001280:	03012603          	lw	a2,48(sp)
40001284:	40e68733          	sub	a4,a3,a4
40001288:	40c689b3          	sub	s3,a3,a2
4000128c:	01375463          	ble	s3,a4,40001294 <_vfprintf_r+0x1104>
40001290:	00070993          	mv	s3,a4
40001294:	03305a63          	blez	s3,400012c8 <_vfprintf_r+0x1138>
40001298:	0a012603          	lw	a2,160(sp)
4000129c:	03012683          	lw	a3,48(sp)
400012a0:	013787b3          	add	a5,a5,s3
400012a4:	00160613          	addi	a2,a2,1
400012a8:	00d906b3          	add	a3,s2,a3
400012ac:	00d32023          	sw	a3,0(t1)
400012b0:	01332223          	sw	s3,4(t1)
400012b4:	0af12223          	sw	a5,164(sp)
400012b8:	0ac12023          	sw	a2,160(sp)
400012bc:	00700693          	li	a3,7
400012c0:	00830313          	addi	t1,t1,8
400012c4:	46c6c063          	blt	a3,a2,40001724 <_vfprintf_r+0x1594>
400012c8:	7009c263          	bltz	s3,400019cc <_vfprintf_r+0x183c>
400012cc:	41370933          	sub	s2,a4,s3
400012d0:	c1205a63          	blez	s2,400006e4 <_vfprintf_r+0x554>
400012d4:	4000b6b7          	lui	a3,0x4000b
400012d8:	01000993          	li	s3,16
400012dc:	0a012703          	lw	a4,160(sp)
400012e0:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
400012e4:	ef29dee3          	ble	s2,s3,400011e0 <_vfprintf_r+0x1050>
400012e8:	00700c93          	li	s9,7
400012ec:	00c0006f          	j	400012f8 <_vfprintf_r+0x1168>
400012f0:	ff090913          	addi	s2,s2,-16
400012f4:	ef29d6e3          	ble	s2,s3,400011e0 <_vfprintf_r+0x1050>
400012f8:	01078793          	addi	a5,a5,16
400012fc:	00170713          	addi	a4,a4,1
40001300:	01632023          	sw	s6,0(t1)
40001304:	01332223          	sw	s3,4(t1)
40001308:	0af12223          	sw	a5,164(sp)
4000130c:	0ae12023          	sw	a4,160(sp)
40001310:	00830313          	addi	t1,t1,8
40001314:	fcecdee3          	ble	a4,s9,400012f0 <_vfprintf_r+0x1160>
40001318:	09c10613          	addi	a2,sp,156
4000131c:	000a0593          	mv	a1,s4
40001320:	000a8513          	mv	a0,s5
40001324:	178050ef          	jal	ra,4000649c <__sprint_r>
40001328:	d2051a63          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
4000132c:	0a412783          	lw	a5,164(sp)
40001330:	0a012703          	lw	a4,160(sp)
40001334:	000c0313          	mv	t1,s8
40001338:	fb9ff06f          	j	400012f0 <_vfprintf_r+0x1160>
4000133c:	04812683          	lw	a3,72(sp)
40001340:	04012603          	lw	a2,64(sp)
40001344:	00830313          	addi	t1,t1,8
40001348:	fed32c23          	sw	a3,-8(t1)
4000134c:	0a012683          	lw	a3,160(sp)
40001350:	00c787b3          	add	a5,a5,a2
40001354:	fec32e23          	sw	a2,-4(t1)
40001358:	00168693          	addi	a3,a3,1
4000135c:	0af12223          	sw	a5,164(sp)
40001360:	0ad12023          	sw	a3,160(sp)
40001364:	00700613          	li	a2,7
40001368:	f0d65ae3          	ble	a3,a2,4000127c <_vfprintf_r+0x10ec>
4000136c:	09c10613          	addi	a2,sp,156
40001370:	000a0593          	mv	a1,s4
40001374:	000a8513          	mv	a0,s5
40001378:	124050ef          	jal	ra,4000649c <__sprint_r>
4000137c:	ce051063          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001380:	08412703          	lw	a4,132(sp)
40001384:	0a412783          	lw	a5,164(sp)
40001388:	000c0313          	mv	t1,s8
4000138c:	ef1ff06f          	j	4000127c <_vfprintf_r+0x10ec>
40001390:	00072783          	lw	a5,0(a4)
40001394:	00470713          	addi	a4,a4,4
40001398:	02e12023          	sw	a4,32(sp)
4000139c:	a75ff06f          	j	40000e10 <_vfprintf_r+0xc80>
400013a0:	00072783          	lw	a5,0(a4)
400013a4:	00470713          	addi	a4,a4,4
400013a8:	02e12023          	sw	a4,32(sp)
400013ac:	c79ff06f          	j	40001024 <_vfprintf_r+0xe94>
400013b0:	02012703          	lw	a4,32(sp)
400013b4:	00072783          	lw	a5,0(a4)
400013b8:	00470713          	addi	a4,a4,4
400013bc:	02e12023          	sw	a4,32(sp)
400013c0:	01812703          	lw	a4,24(sp)
400013c4:	00e7a023          	sw	a4,0(a5)
400013c8:	ee5fe06f          	j	400002ac <_vfprintf_r+0x11c>
400013cc:	01012683          	lw	a3,16(sp)
400013d0:	00e6f6b3          	and	a3,a3,a4
400013d4:	e6069a63          	bnez	a3,40000a48 <_vfprintf_r+0x8b8>
400013d8:	0a012983          	lw	s3,160(sp)
400013dc:	00e32223          	sw	a4,4(t1)
400013e0:	01232023          	sw	s2,0(t1)
400013e4:	00198993          	addi	s3,s3,1
400013e8:	0af12223          	sw	a5,164(sp)
400013ec:	0b312023          	sw	s3,160(sp)
400013f0:	00700713          	li	a4,7
400013f4:	00830c93          	addi	s9,t1,8
400013f8:	c1375063          	ble	s3,a4,400007f8 <_vfprintf_r+0x668>
400013fc:	925ff06f          	j	40000d20 <_vfprintf_r+0xb90>
40001400:	09c10613          	addi	a2,sp,156
40001404:	000a0593          	mv	a1,s4
40001408:	000a8513          	mv	a0,s5
4000140c:	090050ef          	jal	ra,4000649c <__sprint_r>
40001410:	c4051663          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001414:	0a412783          	lw	a5,164(sp)
40001418:	0a012983          	lw	s3,160(sp)
4000141c:	000c0313          	mv	t1,s8
40001420:	e50ff06f          	j	40000a70 <_vfprintf_r+0x8e0>
40001424:	02012683          	lw	a3,32(sp)
40001428:	f75fe06f          	j	4000039c <_vfprintf_r+0x20c>
4000142c:	09c10613          	addi	a2,sp,156
40001430:	000a0593          	mv	a1,s4
40001434:	000a8513          	mv	a0,s5
40001438:	064050ef          	jal	ra,4000649c <__sprint_r>
4000143c:	c2051063          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001440:	0a412783          	lw	a5,164(sp)
40001444:	0a012983          	lw	s3,160(sp)
40001448:	000c0c93          	mv	s9,s8
4000144c:	e50ff06f          	j	40000a9c <_vfprintf_r+0x90c>
40001450:	02012703          	lw	a4,32(sp)
40001454:	00072783          	lw	a5,0(a4)
40001458:	00470713          	addi	a4,a4,4
4000145c:	02e12023          	sw	a4,32(sp)
40001460:	9b1ff06f          	j	40000e10 <_vfprintf_r+0xc80>
40001464:	02012703          	lw	a4,32(sp)
40001468:	00072783          	lw	a5,0(a4)
4000146c:	00470713          	addi	a4,a4,4
40001470:	02e12023          	sw	a4,32(sp)
40001474:	bb1ff06f          	j	40001024 <_vfprintf_r+0xe94>
40001478:	02d00713          	li	a4,45
4000147c:	06e10fa3          	sb	a4,127(sp)
40001480:	40f007b3          	neg	a5,a5
40001484:	02d00613          	li	a2,45
40001488:	00100713          	li	a4,1
4000148c:	f29fe06f          	j	400003b4 <_vfprintf_r+0x224>
40001490:	03812803          	lw	a6,56(sp)
40001494:	03c12583          	lw	a1,60(sp)
40001498:	00612823          	sw	t1,16(sp)
4000149c:	00080613          	mv	a2,a6
400014a0:	00080513          	mv	a0,a6
400014a4:	00058693          	mv	a3,a1
400014a8:	261090ef          	jal	ra,4000af08 <__unorddf2>
400014ac:	01012303          	lw	t1,16(sp)
400014b0:	72051663          	bnez	a0,40001bdc <_vfprintf_r+0x1a4c>
400014b4:	fff00793          	li	a5,-1
400014b8:	52fc8663          	beq	s9,a5,400019e4 <_vfprintf_r+0x1854>
400014bc:	fdf9f793          	andi	a5,s3,-33
400014c0:	00078713          	mv	a4,a5
400014c4:	00f12a23          	sw	a5,20(sp)
400014c8:	04700793          	li	a5,71
400014cc:	32f70c63          	beq	a4,a5,40001804 <_vfprintf_r+0x1674>
400014d0:	100de793          	ori	a5,s11,256
400014d4:	00f12823          	sw	a5,16(sp)
400014d8:	03c12783          	lw	a5,60(sp)
400014dc:	00000b13          	li	s6,0
400014e0:	00078b93          	mv	s7,a5
400014e4:	5407ca63          	bltz	a5,40001a38 <_vfprintf_r+0x18a8>
400014e8:	06600793          	li	a5,102
400014ec:	50f98463          	beq	s3,a5,400019f4 <_vfprintf_r+0x1864>
400014f0:	04600793          	li	a5,70
400014f4:	28f98263          	beq	s3,a5,40001778 <_vfprintf_r+0x15e8>
400014f8:	01412783          	lw	a5,20(sp)
400014fc:	03812703          	lw	a4,56(sp)
40001500:	000b8693          	mv	a3,s7
40001504:	fbb78f13          	addi	t5,a5,-69
40001508:	001f3f13          	seqz	t5,t5
4000150c:	01ec8f33          	add	t5,s9,t5
40001510:	09410793          	addi	a5,sp,148
40001514:	00070613          	mv	a2,a4
40001518:	00f12023          	sw	a5,0(sp)
4000151c:	08810893          	addi	a7,sp,136
40001520:	000f0793          	mv	a5,t5
40001524:	08410813          	addi	a6,sp,132
40001528:	00200713          	li	a4,2
4000152c:	000a8513          	mv	a0,s5
40001530:	02612423          	sw	t1,40(sp)
40001534:	01e12e23          	sw	t5,28(sp)
40001538:	409000ef          	jal	ra,40002140 <_dtoa_r>
4000153c:	06700793          	li	a5,103
40001540:	00050913          	mv	s2,a0
40001544:	01c12f03          	lw	t5,28(sp)
40001548:	02812303          	lw	t1,40(sp)
4000154c:	56f99663          	bne	s3,a5,40001ab8 <_vfprintf_r+0x1928>
40001550:	001df793          	andi	a5,s11,1
40001554:	01e50d33          	add	s10,a0,t5
40001558:	66078263          	beqz	a5,40001bbc <_vfprintf_r+0x1a2c>
4000155c:	03812783          	lw	a5,56(sp)
40001560:	000b8593          	mv	a1,s7
40001564:	00000613          	li	a2,0
40001568:	00078513          	mv	a0,a5
4000156c:	00000693          	li	a3,0
40001570:	00612e23          	sw	t1,28(sp)
40001574:	6b0080ef          	jal	ra,40009c24 <__eqdf2>
40001578:	000d0793          	mv	a5,s10
4000157c:	01c12303          	lw	t1,28(sp)
40001580:	02050263          	beqz	a0,400015a4 <_vfprintf_r+0x1414>
40001584:	09412783          	lw	a5,148(sp)
40001588:	01a7fe63          	bleu	s10,a5,400015a4 <_vfprintf_r+0x1414>
4000158c:	03000693          	li	a3,48
40001590:	00178713          	addi	a4,a5,1
40001594:	08e12a23          	sw	a4,148(sp)
40001598:	00d78023          	sb	a3,0(a5)
4000159c:	09412783          	lw	a5,148(sp)
400015a0:	ffa7e8e3          	bltu	a5,s10,40001590 <_vfprintf_r+0x1400>
400015a4:	412787b3          	sub	a5,a5,s2
400015a8:	02f12a23          	sw	a5,52(sp)
400015ac:	01412783          	lw	a5,20(sp)
400015b0:	04700713          	li	a4,71
400015b4:	2ee78063          	beq	a5,a4,40001894 <_vfprintf_r+0x1704>
400015b8:	06500793          	li	a5,101
400015bc:	5337d263          	ble	s3,a5,40001ae0 <_vfprintf_r+0x1950>
400015c0:	06600793          	li	a5,102
400015c4:	4cf98863          	beq	s3,a5,40001a94 <_vfprintf_r+0x1904>
400015c8:	08412783          	lw	a5,132(sp)
400015cc:	02f12823          	sw	a5,48(sp)
400015d0:	03412703          	lw	a4,52(sp)
400015d4:	03012783          	lw	a5,48(sp)
400015d8:	46e7c863          	blt	a5,a4,40001a48 <_vfprintf_r+0x18b8>
400015dc:	001dfd93          	andi	s11,s11,1
400015e0:	480d9863          	bnez	s11,40001a70 <_vfprintf_r+0x18e0>
400015e4:	00078b93          	mv	s7,a5
400015e8:	6e07ca63          	bltz	a5,40001cdc <_vfprintf_r+0x1b4c>
400015ec:	03012783          	lw	a5,48(sp)
400015f0:	06700993          	li	s3,103
400015f4:	00f12e23          	sw	a5,28(sp)
400015f8:	9a0b1e63          	bnez	s6,400007b4 <_vfprintf_r+0x624>
400015fc:	07f14603          	lbu	a2,127(sp)
40001600:	00000c93          	li	s9,0
40001604:	00061463          	bnez	a2,4000160c <_vfprintf_r+0x147c>
40001608:	ea9fe06f          	j	400004b0 <_vfprintf_r+0x320>
4000160c:	9b8ff06f          	j	400007c4 <_vfprintf_r+0x634>
40001610:	02012783          	lw	a5,32(sp)
40001614:	00778793          	addi	a5,a5,7
40001618:	ff87f793          	andi	a5,a5,-8
4000161c:	0007a703          	lw	a4,0(a5)
40001620:	00878793          	addi	a5,a5,8
40001624:	02e12c23          	sw	a4,56(sp)
40001628:	ffc7a703          	lw	a4,-4(a5)
4000162c:	02f12023          	sw	a5,32(sp)
40001630:	02e12e23          	sw	a4,60(sp)
40001634:	841ff06f          	j	40000e74 <_vfprintf_r+0xce4>
40001638:	09c10613          	addi	a2,sp,156
4000163c:	000a0593          	mv	a1,s4
40001640:	000a8513          	mv	a0,s5
40001644:	659040ef          	jal	ra,4000649c <__sprint_r>
40001648:	a0051a63          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
4000164c:	000c0313          	mv	t1,s8
40001650:	ac4ff06f          	j	40000914 <_vfprintf_r+0x784>
40001654:	0a012703          	lw	a4,160(sp)
40001658:	4000b637          	lui	a2,0x4000b
4000165c:	7e060613          	addi	a2,a2,2016 # 4000b7e0 <zeroes.4139+0x50>
40001660:	00c32023          	sw	a2,0(t1)
40001664:	00178793          	addi	a5,a5,1
40001668:	00100613          	li	a2,1
4000166c:	00170713          	addi	a4,a4,1
40001670:	00c32223          	sw	a2,4(t1)
40001674:	0af12223          	sw	a5,164(sp)
40001678:	0ae12023          	sw	a4,160(sp)
4000167c:	00700613          	li	a2,7
40001680:	00830313          	addi	t1,t1,8
40001684:	0ce64663          	blt	a2,a4,40001750 <_vfprintf_r+0x15c0>
40001688:	00069e63          	bnez	a3,400016a4 <_vfprintf_r+0x1514>
4000168c:	03412703          	lw	a4,52(sp)
40001690:	00071a63          	bnez	a4,400016a4 <_vfprintf_r+0x1514>
40001694:	01012703          	lw	a4,16(sp)
40001698:	00177713          	andi	a4,a4,1
4000169c:	00071463          	bnez	a4,400016a4 <_vfprintf_r+0x1514>
400016a0:	844ff06f          	j	400006e4 <_vfprintf_r+0x554>
400016a4:	04812703          	lw	a4,72(sp)
400016a8:	04012603          	lw	a2,64(sp)
400016ac:	00830313          	addi	t1,t1,8
400016b0:	fee32c23          	sw	a4,-8(t1)
400016b4:	0a012703          	lw	a4,160(sp)
400016b8:	00f607b3          	add	a5,a2,a5
400016bc:	fec32e23          	sw	a2,-4(t1)
400016c0:	00170713          	addi	a4,a4,1
400016c4:	0af12223          	sw	a5,164(sp)
400016c8:	0ae12023          	sw	a4,160(sp)
400016cc:	00700613          	li	a2,7
400016d0:	10e64463          	blt	a2,a4,400017d8 <_vfprintf_r+0x1648>
400016d4:	4206c263          	bltz	a3,40001af8 <_vfprintf_r+0x1968>
400016d8:	03412683          	lw	a3,52(sp)
400016dc:	00170713          	addi	a4,a4,1
400016e0:	01232023          	sw	s2,0(t1)
400016e4:	00f687b3          	add	a5,a3,a5
400016e8:	fe5fe06f          	j	400006cc <_vfprintf_r+0x53c>
400016ec:	fff00793          	li	a5,-1
400016f0:	00f12c23          	sw	a5,24(sp)
400016f4:	974ff06f          	j	40000868 <_vfprintf_r+0x6d8>
400016f8:	4000b937          	lui	s2,0x4000b
400016fc:	7a090913          	addi	s2,s2,1952 # 4000b7a0 <zeroes.4139+0x10>
40001700:	801ff06f          	j	40000f00 <_vfprintf_r+0xd70>
40001704:	09c10613          	addi	a2,sp,156
40001708:	000a0593          	mv	a1,s4
4000170c:	000a8513          	mv	a0,s5
40001710:	58d040ef          	jal	ra,4000649c <__sprint_r>
40001714:	94051463          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001718:	0a412783          	lw	a5,164(sp)
4000171c:	000c0313          	mv	t1,s8
40001720:	d54ff06f          	j	40000c74 <_vfprintf_r+0xae4>
40001724:	09c10613          	addi	a2,sp,156
40001728:	000a0593          	mv	a1,s4
4000172c:	000a8513          	mv	a0,s5
40001730:	56d040ef          	jal	ra,4000649c <__sprint_r>
40001734:	92051463          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001738:	08412703          	lw	a4,132(sp)
4000173c:	03412683          	lw	a3,52(sp)
40001740:	0a412783          	lw	a5,164(sp)
40001744:	000c0313          	mv	t1,s8
40001748:	40e68733          	sub	a4,a3,a4
4000174c:	b7dff06f          	j	400012c8 <_vfprintf_r+0x1138>
40001750:	09c10613          	addi	a2,sp,156
40001754:	000a0593          	mv	a1,s4
40001758:	000a8513          	mv	a0,s5
4000175c:	541040ef          	jal	ra,4000649c <__sprint_r>
40001760:	8e051e63          	bnez	a0,4000085c <_vfprintf_r+0x6cc>
40001764:	08412683          	lw	a3,132(sp)
40001768:	0a412783          	lw	a5,164(sp)
4000176c:	000c0313          	mv	t1,s8
40001770:	f2069ae3          	bnez	a3,400016a4 <_vfprintf_r+0x1514>
40001774:	f19ff06f          	j	4000168c <_vfprintf_r+0x14fc>
40001778:	03812703          	lw	a4,56(sp)
4000177c:	09410793          	addi	a5,sp,148
40001780:	00f12023          	sw	a5,0(sp)
40001784:	00070613          	mv	a2,a4
40001788:	000b8693          	mv	a3,s7
4000178c:	08810893          	addi	a7,sp,136
40001790:	08410813          	addi	a6,sp,132
40001794:	000c8793          	mv	a5,s9
40001798:	00300713          	li	a4,3
4000179c:	000a8513          	mv	a0,s5
400017a0:	00612e23          	sw	t1,28(sp)
400017a4:	19d000ef          	jal	ra,40002140 <_dtoa_r>
400017a8:	01c12303          	lw	t1,28(sp)
400017ac:	00050913          	mv	s2,a0
400017b0:	000c8f13          	mv	t5,s9
400017b4:	04600793          	li	a5,70
400017b8:	01e90d33          	add	s10,s2,t5
400017bc:	daf990e3          	bne	s3,a5,4000155c <_vfprintf_r+0x13cc>
400017c0:	00094703          	lbu	a4,0(s2)
400017c4:	03000793          	li	a5,48
400017c8:	04f70463          	beq	a4,a5,40001810 <_vfprintf_r+0x1680>
400017cc:	08412f03          	lw	t5,132(sp)
400017d0:	01ed0d33          	add	s10,s10,t5
400017d4:	d89ff06f          	j	4000155c <_vfprintf_r+0x13cc>
400017d8:	09c10613          	addi	a2,sp,156
400017dc:	000a0593          	mv	a1,s4
400017e0:	000a8513          	mv	a0,s5
400017e4:	4b9040ef          	jal	ra,4000649c <__sprint_r>
400017e8:	00050463          	beqz	a0,400017f0 <_vfprintf_r+0x1660>
400017ec:	870ff06f          	j	4000085c <_vfprintf_r+0x6cc>
400017f0:	08412683          	lw	a3,132(sp)
400017f4:	0a412783          	lw	a5,164(sp)
400017f8:	0a012703          	lw	a4,160(sp)
400017fc:	000c0313          	mv	t1,s8
40001800:	ed5ff06f          	j	400016d4 <_vfprintf_r+0x1544>
40001804:	cc0c96e3          	bnez	s9,400014d0 <_vfprintf_r+0x1340>
40001808:	00100c93          	li	s9,1
4000180c:	cc5ff06f          	j	400014d0 <_vfprintf_r+0x1340>
40001810:	03812703          	lw	a4,56(sp)
40001814:	000b8593          	mv	a1,s7
40001818:	00000613          	li	a2,0
4000181c:	00070513          	mv	a0,a4
40001820:	00000693          	li	a3,0
40001824:	02612423          	sw	t1,40(sp)
40001828:	01e12e23          	sw	t5,28(sp)
4000182c:	3f8080ef          	jal	ra,40009c24 <__eqdf2>
40001830:	02812303          	lw	t1,40(sp)
40001834:	f8050ce3          	beqz	a0,400017cc <_vfprintf_r+0x163c>
40001838:	01c12f03          	lw	t5,28(sp)
4000183c:	00100793          	li	a5,1
40001840:	41e78f33          	sub	t5,a5,t5
40001844:	09e12223          	sw	t5,132(sp)
40001848:	01ed0d33          	add	s10,s10,t5
4000184c:	d11ff06f          	j	4000155c <_vfprintf_r+0x13cc>
40001850:	09c10613          	addi	a2,sp,156
40001854:	000a0593          	mv	a1,s4
40001858:	000a8513          	mv	a0,s5
4000185c:	441040ef          	jal	ra,4000649c <__sprint_r>
40001860:	00050463          	beqz	a0,40001868 <_vfprintf_r+0x16d8>
40001864:	ff9fe06f          	j	4000085c <_vfprintf_r+0x6cc>
40001868:	0a412783          	lw	a5,164(sp)
4000186c:	000c0313          	mv	t1,s8
40001870:	8fdff06f          	j	4000116c <_vfprintf_r+0xfdc>
40001874:	00090513          	mv	a0,s2
40001878:	29d040ef          	jal	ra,40006314 <strlen>
4000187c:	00a12e23          	sw	a0,28(sp)
40001880:	00050b93          	mv	s7,a0
40001884:	01012303          	lw	t1,16(sp)
40001888:	d4055263          	bgez	a0,40000dcc <_vfprintf_r+0xc3c>
4000188c:	00000b93          	li	s7,0
40001890:	d3cff06f          	j	40000dcc <_vfprintf_r+0xc3c>
40001894:	08412783          	lw	a5,132(sp)
40001898:	00078713          	mv	a4,a5
4000189c:	02f12823          	sw	a5,48(sp)
400018a0:	ffd00793          	li	a5,-3
400018a4:	00f74463          	blt	a4,a5,400018ac <_vfprintf_r+0x171c>
400018a8:	d2ecd4e3          	ble	a4,s9,400015d0 <_vfprintf_r+0x1440>
400018ac:	ffe98993          	addi	s3,s3,-2
400018b0:	03012783          	lw	a5,48(sp)
400018b4:	09310623          	sb	s3,140(sp)
400018b8:	fff78793          	addi	a5,a5,-1
400018bc:	08f12223          	sw	a5,132(sp)
400018c0:	3a07c663          	bltz	a5,40001c6c <_vfprintf_r+0x1adc>
400018c4:	02b00713          	li	a4,43
400018c8:	08e106a3          	sb	a4,141(sp)
400018cc:	00900513          	li	a0,9
400018d0:	2ef55a63          	ble	a5,a0,40001bc4 <_vfprintf_r+0x1a34>
400018d4:	09b10813          	addi	a6,sp,155
400018d8:	00080713          	mv	a4,a6
400018dc:	00a00593          	li	a1,10
400018e0:	0080006f          	j	400018e8 <_vfprintf_r+0x1758>
400018e4:	00060713          	mv	a4,a2
400018e8:	02b7e6b3          	rem	a3,a5,a1
400018ec:	fff70613          	addi	a2,a4,-1
400018f0:	02b7c7b3          	div	a5,a5,a1
400018f4:	03068693          	addi	a3,a3,48
400018f8:	fed70fa3          	sb	a3,-1(a4)
400018fc:	fef544e3          	blt	a0,a5,400018e4 <_vfprintf_r+0x1754>
40001900:	03078793          	addi	a5,a5,48
40001904:	0ff7f793          	andi	a5,a5,255
40001908:	ffe70713          	addi	a4,a4,-2
4000190c:	fef60fa3          	sb	a5,-1(a2)
40001910:	3d077a63          	bleu	a6,a4,40001ce4 <_vfprintf_r+0x1b54>
40001914:	08e10693          	addi	a3,sp,142
40001918:	0080006f          	j	40001920 <_vfprintf_r+0x1790>
4000191c:	00074783          	lbu	a5,0(a4)
40001920:	00168693          	addi	a3,a3,1
40001924:	00170713          	addi	a4,a4,1
40001928:	fef68fa3          	sb	a5,-1(a3)
4000192c:	ff0718e3          	bne	a4,a6,4000191c <_vfprintf_r+0x178c>
40001930:	09c10793          	addi	a5,sp,156
40001934:	40c787b3          	sub	a5,a5,a2
40001938:	08e10713          	addi	a4,sp,142
4000193c:	00f707b3          	add	a5,a4,a5
40001940:	08c10713          	addi	a4,sp,140
40001944:	03412683          	lw	a3,52(sp)
40001948:	40e787b3          	sub	a5,a5,a4
4000194c:	00078713          	mv	a4,a5
40001950:	00e68733          	add	a4,a3,a4
40001954:	04f12623          	sw	a5,76(sp)
40001958:	00e12e23          	sw	a4,28(sp)
4000195c:	00100793          	li	a5,1
40001960:	2ed7d863          	ble	a3,a5,40001c50 <_vfprintf_r+0x1ac0>
40001964:	01c12783          	lw	a5,28(sp)
40001968:	04012703          	lw	a4,64(sp)
4000196c:	00e787b3          	add	a5,a5,a4
40001970:	00f12e23          	sw	a5,28(sp)
40001974:	00078b93          	mv	s7,a5
40001978:	0007c663          	bltz	a5,40001984 <_vfprintf_r+0x17f4>
4000197c:	02012823          	sw	zero,48(sp)
40001980:	c79ff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001984:	00000b93          	li	s7,0
40001988:	02012823          	sw	zero,48(sp)
4000198c:	c6dff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001990:	00000993          	li	s3,0
40001994:	ae4ff06f          	j	40000c78 <_vfprintf_r+0xae8>
40001998:	00600793          	li	a5,6
4000199c:	000c8b93          	mv	s7,s9
400019a0:	0197f463          	bleu	s9,a5,400019a8 <_vfprintf_r+0x1818>
400019a4:	00078b93          	mv	s7,a5
400019a8:	4000b937          	lui	s2,0x4000b
400019ac:	03612023          	sw	s6,32(sp)
400019b0:	01712e23          	sw	s7,28(sp)
400019b4:	01b12823          	sw	s11,16(sp)
400019b8:	00000613          	li	a2,0
400019bc:	00000c93          	li	s9,0
400019c0:	02012823          	sw	zero,48(sp)
400019c4:	7d890913          	addi	s2,s2,2008 # 4000b7d8 <zeroes.4139+0x48>
400019c8:	ae9fe06f          	j	400004b0 <_vfprintf_r+0x320>
400019cc:	00000993          	li	s3,0
400019d0:	8fdff06f          	j	400012cc <_vfprintf_r+0x113c>
400019d4:	02d00793          	li	a5,45
400019d8:	06f10fa3          	sb	a5,127(sp)
400019dc:	02d00613          	li	a2,45
400019e0:	d10ff06f          	j	40000ef0 <_vfprintf_r+0xd60>
400019e4:	fdf9f793          	andi	a5,s3,-33
400019e8:	00f12a23          	sw	a5,20(sp)
400019ec:	00600c93          	li	s9,6
400019f0:	ae1ff06f          	j	400014d0 <_vfprintf_r+0x1340>
400019f4:	03812703          	lw	a4,56(sp)
400019f8:	09410793          	addi	a5,sp,148
400019fc:	00f12023          	sw	a5,0(sp)
40001a00:	00070613          	mv	a2,a4
40001a04:	000b8693          	mv	a3,s7
40001a08:	08810893          	addi	a7,sp,136
40001a0c:	08410813          	addi	a6,sp,132
40001a10:	000c8793          	mv	a5,s9
40001a14:	00300713          	li	a4,3
40001a18:	000a8513          	mv	a0,s5
40001a1c:	00612e23          	sw	t1,28(sp)
40001a20:	720000ef          	jal	ra,40002140 <_dtoa_r>
40001a24:	00050913          	mv	s2,a0
40001a28:	01950d33          	add	s10,a0,s9
40001a2c:	000c8f13          	mv	t5,s9
40001a30:	01c12303          	lw	t1,28(sp)
40001a34:	d8dff06f          	j	400017c0 <_vfprintf_r+0x1630>
40001a38:	80000eb7          	lui	t4,0x80000
40001a3c:	01d7cbb3          	xor	s7,a5,t4
40001a40:	02d00b13          	li	s6,45
40001a44:	aa5ff06f          	j	400014e8 <_vfprintf_r+0x1358>
40001a48:	04012703          	lw	a4,64(sp)
40001a4c:	03412783          	lw	a5,52(sp)
40001a50:	00e787b3          	add	a5,a5,a4
40001a54:	03012703          	lw	a4,48(sp)
40001a58:	00f12e23          	sw	a5,28(sp)
40001a5c:	1ce05e63          	blez	a4,40001c38 <_vfprintf_r+0x1aa8>
40001a60:	00078b93          	mv	s7,a5
40001a64:	0207c263          	bltz	a5,40001a88 <_vfprintf_r+0x18f8>
40001a68:	06700993          	li	s3,103
40001a6c:	b8dff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001a70:	03012783          	lw	a5,48(sp)
40001a74:	04012703          	lw	a4,64(sp)
40001a78:	00e787b3          	add	a5,a5,a4
40001a7c:	00f12e23          	sw	a5,28(sp)
40001a80:	00078b93          	mv	s7,a5
40001a84:	fe07d2e3          	bgez	a5,40001a68 <_vfprintf_r+0x18d8>
40001a88:	00000b93          	li	s7,0
40001a8c:	06700993          	li	s3,103
40001a90:	b69ff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001a94:	08412783          	lw	a5,132(sp)
40001a98:	02f12823          	sw	a5,48(sp)
40001a9c:	1ef05a63          	blez	a5,40001c90 <_vfprintf_r+0x1b00>
40001aa0:	160c9a63          	bnez	s9,40001c14 <_vfprintf_r+0x1a84>
40001aa4:	001dfd93          	andi	s11,s11,1
40001aa8:	160d9663          	bnez	s11,40001c14 <_vfprintf_r+0x1a84>
40001aac:	00078b93          	mv	s7,a5
40001ab0:	00f12e23          	sw	a5,28(sp)
40001ab4:	b45ff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001ab8:	04700793          	li	a5,71
40001abc:	01e50d33          	add	s10,a0,t5
40001ac0:	a8f99ee3          	bne	s3,a5,4000155c <_vfprintf_r+0x13cc>
40001ac4:	001df793          	andi	a5,s11,1
40001ac8:	ce0796e3          	bnez	a5,400017b4 <_vfprintf_r+0x1624>
40001acc:	09412783          	lw	a5,148(sp)
40001ad0:	412787b3          	sub	a5,a5,s2
40001ad4:	02f12a23          	sw	a5,52(sp)
40001ad8:	01412783          	lw	a5,20(sp)
40001adc:	db378ce3          	beq	a5,s3,40001894 <_vfprintf_r+0x1704>
40001ae0:	08412783          	lw	a5,132(sp)
40001ae4:	02f12823          	sw	a5,48(sp)
40001ae8:	dc9ff06f          	j	400018b0 <_vfprintf_r+0x1720>
40001aec:	000c8b93          	mv	s7,s9
40001af0:	01912e23          	sw	s9,28(sp)
40001af4:	ad8ff06f          	j	40000dcc <_vfprintf_r+0xc3c>
40001af8:	ff000613          	li	a2,-16
40001afc:	40d009b3          	neg	s3,a3
40001b00:	06c6d463          	ble	a2,a3,40001b68 <_vfprintf_r+0x19d8>
40001b04:	4000b6b7          	lui	a3,0x4000b
40001b08:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
40001b0c:	01000c93          	li	s9,16
40001b10:	00700d13          	li	s10,7
40001b14:	00c0006f          	j	40001b20 <_vfprintf_r+0x1990>
40001b18:	ff098993          	addi	s3,s3,-16
40001b1c:	053cda63          	ble	s3,s9,40001b70 <_vfprintf_r+0x19e0>
40001b20:	01078793          	addi	a5,a5,16
40001b24:	00170713          	addi	a4,a4,1
40001b28:	01632023          	sw	s6,0(t1)
40001b2c:	01932223          	sw	s9,4(t1)
40001b30:	0af12223          	sw	a5,164(sp)
40001b34:	0ae12023          	sw	a4,160(sp)
40001b38:	00830313          	addi	t1,t1,8
40001b3c:	fced5ee3          	ble	a4,s10,40001b18 <_vfprintf_r+0x1988>
40001b40:	09c10613          	addi	a2,sp,156
40001b44:	000a0593          	mv	a1,s4
40001b48:	000a8513          	mv	a0,s5
40001b4c:	151040ef          	jal	ra,4000649c <__sprint_r>
40001b50:	00050463          	beqz	a0,40001b58 <_vfprintf_r+0x19c8>
40001b54:	d09fe06f          	j	4000085c <_vfprintf_r+0x6cc>
40001b58:	0a412783          	lw	a5,164(sp)
40001b5c:	0a012703          	lw	a4,160(sp)
40001b60:	000c0313          	mv	t1,s8
40001b64:	fb5ff06f          	j	40001b18 <_vfprintf_r+0x1988>
40001b68:	4000b6b7          	lui	a3,0x4000b
40001b6c:	79068b13          	addi	s6,a3,1936 # 4000b790 <zeroes.4139>
40001b70:	013787b3          	add	a5,a5,s3
40001b74:	00170713          	addi	a4,a4,1
40001b78:	01632023          	sw	s6,0(t1)
40001b7c:	01332223          	sw	s3,4(t1)
40001b80:	0af12223          	sw	a5,164(sp)
40001b84:	0ae12023          	sw	a4,160(sp)
40001b88:	00700693          	li	a3,7
40001b8c:	00830313          	addi	t1,t1,8
40001b90:	b4e6d4e3          	ble	a4,a3,400016d8 <_vfprintf_r+0x1548>
40001b94:	09c10613          	addi	a2,sp,156
40001b98:	000a0593          	mv	a1,s4
40001b9c:	000a8513          	mv	a0,s5
40001ba0:	0fd040ef          	jal	ra,4000649c <__sprint_r>
40001ba4:	00050463          	beqz	a0,40001bac <_vfprintf_r+0x1a1c>
40001ba8:	cb5fe06f          	j	4000085c <_vfprintf_r+0x6cc>
40001bac:	0a412783          	lw	a5,164(sp)
40001bb0:	0a012703          	lw	a4,160(sp)
40001bb4:	000c0313          	mv	t1,s8
40001bb8:	b21ff06f          	j	400016d8 <_vfprintf_r+0x1548>
40001bbc:	09412783          	lw	a5,148(sp)
40001bc0:	9e5ff06f          	j	400015a4 <_vfprintf_r+0x1414>
40001bc4:	03078793          	addi	a5,a5,48
40001bc8:	03000713          	li	a4,48
40001bcc:	08f107a3          	sb	a5,143(sp)
40001bd0:	08e10723          	sb	a4,142(sp)
40001bd4:	09010793          	addi	a5,sp,144
40001bd8:	d69ff06f          	j	40001940 <_vfprintf_r+0x17b0>
40001bdc:	04700793          	li	a5,71
40001be0:	0b37c263          	blt	a5,s3,40001c84 <_vfprintf_r+0x1af4>
40001be4:	4000b937          	lui	s2,0x4000b
40001be8:	7a890913          	addi	s2,s2,1960 # 4000b7a8 <zeroes.4139+0x18>
40001bec:	07f14603          	lbu	a2,127(sp)
40001bf0:	00300b93          	li	s7,3
40001bf4:	f7fdf793          	andi	a5,s11,-129
40001bf8:	00f12823          	sw	a5,16(sp)
40001bfc:	01712e23          	sw	s7,28(sp)
40001c00:	02012823          	sw	zero,48(sp)
40001c04:	00000c93          	li	s9,0
40001c08:	00061463          	bnez	a2,40001c10 <_vfprintf_r+0x1a80>
40001c0c:	8a5fe06f          	j	400004b0 <_vfprintf_r+0x320>
40001c10:	bb5fe06f          	j	400007c4 <_vfprintf_r+0x634>
40001c14:	03012783          	lw	a5,48(sp)
40001c18:	04012703          	lw	a4,64(sp)
40001c1c:	00e787b3          	add	a5,a5,a4
40001c20:	019787b3          	add	a5,a5,s9
40001c24:	00f12e23          	sw	a5,28(sp)
40001c28:	00078b93          	mv	s7,a5
40001c2c:	9c07d6e3          	bgez	a5,400015f8 <_vfprintf_r+0x1468>
40001c30:	00000b93          	li	s7,0
40001c34:	9c5ff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001c38:	01c12783          	lw	a5,28(sp)
40001c3c:	03012703          	lw	a4,48(sp)
40001c40:	40e78cb3          	sub	s9,a5,a4
40001c44:	001c8793          	addi	a5,s9,1
40001c48:	00f12e23          	sw	a5,28(sp)
40001c4c:	e15ff06f          	j	40001a60 <_vfprintf_r+0x18d0>
40001c50:	00fdf7b3          	and	a5,s11,a5
40001c54:	02f12823          	sw	a5,48(sp)
40001c58:	d00796e3          	bnez	a5,40001964 <_vfprintf_r+0x17d4>
40001c5c:	00070b93          	mv	s7,a4
40001c60:	98075ce3          	bgez	a4,400015f8 <_vfprintf_r+0x1468>
40001c64:	00000b93          	li	s7,0
40001c68:	991ff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001c6c:	03012703          	lw	a4,48(sp)
40001c70:	00100793          	li	a5,1
40001c74:	40e787b3          	sub	a5,a5,a4
40001c78:	02d00713          	li	a4,45
40001c7c:	08e106a3          	sb	a4,141(sp)
40001c80:	c4dff06f          	j	400018cc <_vfprintf_r+0x173c>
40001c84:	4000b937          	lui	s2,0x4000b
40001c88:	7ac90913          	addi	s2,s2,1964 # 4000b7ac <zeroes.4139+0x1c>
40001c8c:	f61ff06f          	j	40001bec <_vfprintf_r+0x1a5c>
40001c90:	000c9a63          	bnez	s9,40001ca4 <_vfprintf_r+0x1b14>
40001c94:	00100b93          	li	s7,1
40001c98:	017dfdb3          	and	s11,s11,s7
40001c9c:	01712e23          	sw	s7,28(sp)
40001ca0:	940d8ce3          	beqz	s11,400015f8 <_vfprintf_r+0x1468>
40001ca4:	04012783          	lw	a5,64(sp)
40001ca8:	00178793          	addi	a5,a5,1
40001cac:	019787b3          	add	a5,a5,s9
40001cb0:	00f12e23          	sw	a5,28(sp)
40001cb4:	00078b93          	mv	s7,a5
40001cb8:	9407d0e3          	bgez	a5,400015f8 <_vfprintf_r+0x1468>
40001cbc:	00000b93          	li	s7,0
40001cc0:	939ff06f          	j	400015f8 <_vfprintf_r+0x1468>
40001cc4:	02012783          	lw	a5,32(sp)
40001cc8:	0007ac83          	lw	s9,0(a5)
40001ccc:	00478793          	addi	a5,a5,4
40001cd0:	000cce63          	bltz	s9,40001cec <_vfprintf_r+0x1b5c>
40001cd4:	02f12023          	sw	a5,32(sp)
40001cd8:	e7cfe06f          	j	40000354 <_vfprintf_r+0x1c4>
40001cdc:	00000b93          	li	s7,0
40001ce0:	90dff06f          	j	400015ec <_vfprintf_r+0x145c>
40001ce4:	08e10793          	addi	a5,sp,142
40001ce8:	c59ff06f          	j	40001940 <_vfprintf_r+0x17b0>
40001cec:	000f0c93          	mv	s9,t5
40001cf0:	02f12023          	sw	a5,32(sp)
40001cf4:	e60fe06f          	j	40000354 <_vfprintf_r+0x1c4>
40001cf8:	06b10fa3          	sb	a1,127(sp)
40001cfc:	85cff06f          	j	40000d58 <_vfprintf_r+0xbc8>
40001d00:	06b10fa3          	sb	a1,127(sp)
40001d04:	920ff06f          	j	40000e24 <_vfprintf_r+0xc94>
40001d08:	06b10fa3          	sb	a1,127(sp)
40001d0c:	8e0ff06f          	j	40000dec <_vfprintf_r+0xc5c>
40001d10:	06b10fa3          	sb	a1,127(sp)
40001d14:	bc0ff06f          	j	400010d4 <_vfprintf_r+0xf44>
40001d18:	06b10fa3          	sb	a1,127(sp)
40001d1c:	b30ff06f          	j	4000104c <_vfprintf_r+0xebc>
40001d20:	06b10fa3          	sb	a1,127(sp)
40001d24:	ad4ff06f          	j	40000ff8 <_vfprintf_r+0xe68>

40001d28 <vfprintf>:
40001d28:	4000c7b7          	lui	a5,0x4000c
40001d2c:	00060693          	mv	a3,a2
40001d30:	00058613          	mv	a2,a1
40001d34:	00050593          	mv	a1,a0
40001d38:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
40001d3c:	c54fe06f          	j	40000190 <_vfprintf_r>

40001d40 <__sbprintf>:
40001d40:	00c5d783          	lhu	a5,12(a1)
40001d44:	0645ae03          	lw	t3,100(a1)
40001d48:	00e5d303          	lhu	t1,14(a1)
40001d4c:	01c5a883          	lw	a7,28(a1)
40001d50:	0245a803          	lw	a6,36(a1)
40001d54:	b8010113          	addi	sp,sp,-1152
40001d58:	ffd7f793          	andi	a5,a5,-3
40001d5c:	40000713          	li	a4,1024
40001d60:	46812c23          	sw	s0,1144(sp)
40001d64:	00f11a23          	sh	a5,20(sp)
40001d68:	00058413          	mv	s0,a1
40001d6c:	07010793          	addi	a5,sp,112
40001d70:	00810593          	addi	a1,sp,8
40001d74:	46912a23          	sw	s1,1140(sp)
40001d78:	47212823          	sw	s2,1136(sp)
40001d7c:	46112e23          	sw	ra,1148(sp)
40001d80:	00050913          	mv	s2,a0
40001d84:	07c12623          	sw	t3,108(sp)
40001d88:	00611b23          	sh	t1,22(sp)
40001d8c:	03112223          	sw	a7,36(sp)
40001d90:	03012623          	sw	a6,44(sp)
40001d94:	00f12423          	sw	a5,8(sp)
40001d98:	00f12c23          	sw	a5,24(sp)
40001d9c:	00e12823          	sw	a4,16(sp)
40001da0:	00e12e23          	sw	a4,28(sp)
40001da4:	02012023          	sw	zero,32(sp)
40001da8:	be8fe0ef          	jal	ra,40000190 <_vfprintf_r>
40001dac:	00050493          	mv	s1,a0
40001db0:	00054a63          	bltz	a0,40001dc4 <__sbprintf+0x84>
40001db4:	00810593          	addi	a1,sp,8
40001db8:	00090513          	mv	a0,s2
40001dbc:	381010ef          	jal	ra,4000393c <_fflush_r>
40001dc0:	02051c63          	bnez	a0,40001df8 <__sbprintf+0xb8>
40001dc4:	01415783          	lhu	a5,20(sp)
40001dc8:	0407f793          	andi	a5,a5,64
40001dcc:	00078863          	beqz	a5,40001ddc <__sbprintf+0x9c>
40001dd0:	00c45783          	lhu	a5,12(s0)
40001dd4:	0407e793          	ori	a5,a5,64
40001dd8:	00f41623          	sh	a5,12(s0)
40001ddc:	47c12083          	lw	ra,1148(sp)
40001de0:	00048513          	mv	a0,s1
40001de4:	47812403          	lw	s0,1144(sp)
40001de8:	47412483          	lw	s1,1140(sp)
40001dec:	47012903          	lw	s2,1136(sp)
40001df0:	48010113          	addi	sp,sp,1152
40001df4:	00008067          	ret
40001df8:	fff00493          	li	s1,-1
40001dfc:	fc9ff06f          	j	40001dc4 <__sbprintf+0x84>

40001e00 <__swsetup_r>:
40001e00:	4000c7b7          	lui	a5,0x4000c
40001e04:	62c7a783          	lw	a5,1580(a5) # 4000c62c <_impure_ptr>
40001e08:	ff010113          	addi	sp,sp,-16
40001e0c:	00812423          	sw	s0,8(sp)
40001e10:	00912223          	sw	s1,4(sp)
40001e14:	00112623          	sw	ra,12(sp)
40001e18:	00050493          	mv	s1,a0
40001e1c:	00058413          	mv	s0,a1
40001e20:	00078663          	beqz	a5,40001e2c <__swsetup_r+0x2c>
40001e24:	0387a703          	lw	a4,56(a5)
40001e28:	0c070c63          	beqz	a4,40001f00 <__swsetup_r+0x100>
40001e2c:	00c41703          	lh	a4,12(s0)
40001e30:	01071793          	slli	a5,a4,0x10
40001e34:	0107d793          	srli	a5,a5,0x10
40001e38:	0087f693          	andi	a3,a5,8
40001e3c:	04068063          	beqz	a3,40001e7c <__swsetup_r+0x7c>
40001e40:	01042683          	lw	a3,16(s0)
40001e44:	06068063          	beqz	a3,40001ea4 <__swsetup_r+0xa4>
40001e48:	0017f713          	andi	a4,a5,1
40001e4c:	06070e63          	beqz	a4,40001ec8 <__swsetup_r+0xc8>
40001e50:	01442783          	lw	a5,20(s0)
40001e54:	00042423          	sw	zero,8(s0)
40001e58:	00000513          	li	a0,0
40001e5c:	40f007b3          	neg	a5,a5
40001e60:	00f42c23          	sw	a5,24(s0)
40001e64:	08068063          	beqz	a3,40001ee4 <__swsetup_r+0xe4>
40001e68:	00c12083          	lw	ra,12(sp)
40001e6c:	00812403          	lw	s0,8(sp)
40001e70:	00412483          	lw	s1,4(sp)
40001e74:	01010113          	addi	sp,sp,16
40001e78:	00008067          	ret
40001e7c:	0107f693          	andi	a3,a5,16
40001e80:	0c068063          	beqz	a3,40001f40 <__swsetup_r+0x140>
40001e84:	0047f793          	andi	a5,a5,4
40001e88:	08079263          	bnez	a5,40001f0c <__swsetup_r+0x10c>
40001e8c:	01042683          	lw	a3,16(s0)
40001e90:	00876793          	ori	a5,a4,8
40001e94:	00f41623          	sh	a5,12(s0)
40001e98:	01079793          	slli	a5,a5,0x10
40001e9c:	0107d793          	srli	a5,a5,0x10
40001ea0:	fa0694e3          	bnez	a3,40001e48 <__swsetup_r+0x48>
40001ea4:	2807f713          	andi	a4,a5,640
40001ea8:	20000613          	li	a2,512
40001eac:	f8c70ee3          	beq	a4,a2,40001e48 <__swsetup_r+0x48>
40001eb0:	00040593          	mv	a1,s0
40001eb4:	00048513          	mv	a0,s1
40001eb8:	5d8020ef          	jal	ra,40004490 <__smakebuf_r>
40001ebc:	00c45783          	lhu	a5,12(s0)
40001ec0:	01042683          	lw	a3,16(s0)
40001ec4:	f85ff06f          	j	40001e48 <__swsetup_r+0x48>
40001ec8:	0027f793          	andi	a5,a5,2
40001ecc:	00000713          	li	a4,0
40001ed0:	00079463          	bnez	a5,40001ed8 <__swsetup_r+0xd8>
40001ed4:	01442703          	lw	a4,20(s0)
40001ed8:	00e42423          	sw	a4,8(s0)
40001edc:	00000513          	li	a0,0
40001ee0:	f80694e3          	bnez	a3,40001e68 <__swsetup_r+0x68>
40001ee4:	00c41783          	lh	a5,12(s0)
40001ee8:	0807f713          	andi	a4,a5,128
40001eec:	f6070ee3          	beqz	a4,40001e68 <__swsetup_r+0x68>
40001ef0:	0407e793          	ori	a5,a5,64
40001ef4:	00f41623          	sh	a5,12(s0)
40001ef8:	fff00513          	li	a0,-1
40001efc:	f6dff06f          	j	40001e68 <__swsetup_r+0x68>
40001f00:	00078513          	mv	a0,a5
40001f04:	5fd010ef          	jal	ra,40003d00 <__sinit>
40001f08:	f25ff06f          	j	40001e2c <__swsetup_r+0x2c>
40001f0c:	03042583          	lw	a1,48(s0)
40001f10:	00058e63          	beqz	a1,40001f2c <__swsetup_r+0x12c>
40001f14:	04040793          	addi	a5,s0,64
40001f18:	00f58863          	beq	a1,a5,40001f28 <__swsetup_r+0x128>
40001f1c:	00048513          	mv	a0,s1
40001f20:	765010ef          	jal	ra,40003e84 <_free_r>
40001f24:	00c41703          	lh	a4,12(s0)
40001f28:	02042823          	sw	zero,48(s0)
40001f2c:	01042683          	lw	a3,16(s0)
40001f30:	fdb77713          	andi	a4,a4,-37
40001f34:	00042223          	sw	zero,4(s0)
40001f38:	00d42023          	sw	a3,0(s0)
40001f3c:	f55ff06f          	j	40001e90 <__swsetup_r+0x90>
40001f40:	00900793          	li	a5,9
40001f44:	00f4a023          	sw	a5,0(s1)
40001f48:	04076713          	ori	a4,a4,64
40001f4c:	00e41623          	sh	a4,12(s0)
40001f50:	fff00513          	li	a0,-1
40001f54:	f15ff06f          	j	40001e68 <__swsetup_r+0x68>

40001f58 <quorem>:
40001f58:	fe010113          	addi	sp,sp,-32
40001f5c:	01212823          	sw	s2,16(sp)
40001f60:	01052783          	lw	a5,16(a0)
40001f64:	0105a903          	lw	s2,16(a1)
40001f68:	00112e23          	sw	ra,28(sp)
40001f6c:	00812c23          	sw	s0,24(sp)
40001f70:	00912a23          	sw	s1,20(sp)
40001f74:	01312623          	sw	s3,12(sp)
40001f78:	01412423          	sw	s4,8(sp)
40001f7c:	01512223          	sw	s5,4(sp)
40001f80:	1b27cc63          	blt	a5,s2,40002138 <quorem+0x1e0>
40001f84:	fff90913          	addi	s2,s2,-1
40001f88:	00291e93          	slli	t4,s2,0x2
40001f8c:	01458413          	addi	s0,a1,20
40001f90:	01d409b3          	add	s3,s0,t4
40001f94:	01450a13          	addi	s4,a0,20
40001f98:	01da0eb3          	add	t4,s4,t4
40001f9c:	0009a783          	lw	a5,0(s3)
40001fa0:	000ea483          	lw	s1,0(t4) # 80000000 <_bss_end+0x3fff3978>
40001fa4:	00178793          	addi	a5,a5,1
40001fa8:	02f4d4b3          	divu	s1,s1,a5
40001fac:	0a048e63          	beqz	s1,40002068 <quorem+0x110>
40001fb0:	000108b7          	lui	a7,0x10
40001fb4:	00040e13          	mv	t3,s0
40001fb8:	000a0313          	mv	t1,s4
40001fbc:	00000f13          	li	t5,0
40001fc0:	00000793          	li	a5,0
40001fc4:	fff88893          	addi	a7,a7,-1 # ffff <_heap_size+0xdfff>
40001fc8:	004e0e13          	addi	t3,t3,4
40001fcc:	ffce2603          	lw	a2,-4(t3)
40001fd0:	00032703          	lw	a4,0(t1)
40001fd4:	00430313          	addi	t1,t1,4
40001fd8:	01167833          	and	a6,a2,a7
40001fdc:	02980833          	mul	a6,a6,s1
40001fe0:	01065693          	srli	a3,a2,0x10
40001fe4:	01177fb3          	and	t6,a4,a7
40001fe8:	01075713          	srli	a4,a4,0x10
40001fec:	029686b3          	mul	a3,a3,s1
40001ff0:	01e80833          	add	a6,a6,t5
40001ff4:	01085f13          	srli	t5,a6,0x10
40001ff8:	01187633          	and	a2,a6,a7
40001ffc:	40c787b3          	sub	a5,a5,a2
40002000:	01f78633          	add	a2,a5,t6
40002004:	41065813          	srai	a6,a2,0x10
40002008:	01167633          	and	a2,a2,a7
4000200c:	01e686b3          	add	a3,a3,t5
40002010:	0116f7b3          	and	a5,a3,a7
40002014:	40f707b3          	sub	a5,a4,a5
40002018:	010787b3          	add	a5,a5,a6
4000201c:	01079713          	slli	a4,a5,0x10
40002020:	00c76633          	or	a2,a4,a2
40002024:	fec32e23          	sw	a2,-4(t1)
40002028:	0106df13          	srli	t5,a3,0x10
4000202c:	4107d793          	srai	a5,a5,0x10
40002030:	f9c9fce3          	bleu	t3,s3,40001fc8 <quorem+0x70>
40002034:	000ea783          	lw	a5,0(t4)
40002038:	02079863          	bnez	a5,40002068 <quorem+0x110>
4000203c:	ffce8793          	addi	a5,t4,-4
40002040:	02fa7263          	bleu	a5,s4,40002064 <quorem+0x10c>
40002044:	ffcea703          	lw	a4,-4(t4)
40002048:	00070863          	beqz	a4,40002058 <quorem+0x100>
4000204c:	0180006f          	j	40002064 <quorem+0x10c>
40002050:	0007a703          	lw	a4,0(a5)
40002054:	00071863          	bnez	a4,40002064 <quorem+0x10c>
40002058:	ffc78793          	addi	a5,a5,-4
4000205c:	fff90913          	addi	s2,s2,-1
40002060:	fefa68e3          	bltu	s4,a5,40002050 <quorem+0xf8>
40002064:	01252823          	sw	s2,16(a0)
40002068:	00050a93          	mv	s5,a0
4000206c:	015030ef          	jal	ra,40005880 <__mcmp>
40002070:	0a054063          	bltz	a0,40002110 <quorem+0x1b8>
40002074:	00010837          	lui	a6,0x10
40002078:	00148493          	addi	s1,s1,1
4000207c:	000a0593          	mv	a1,s4
40002080:	00000793          	li	a5,0
40002084:	fff80813          	addi	a6,a6,-1 # ffff <_heap_size+0xdfff>
40002088:	00440413          	addi	s0,s0,4
4000208c:	ffc42603          	lw	a2,-4(s0)
40002090:	0005a703          	lw	a4,0(a1)
40002094:	00458593          	addi	a1,a1,4
40002098:	010676b3          	and	a3,a2,a6
4000209c:	40d787b3          	sub	a5,a5,a3
400020a0:	010776b3          	and	a3,a4,a6
400020a4:	00d786b3          	add	a3,a5,a3
400020a8:	01065613          	srli	a2,a2,0x10
400020ac:	01075793          	srli	a5,a4,0x10
400020b0:	40c787b3          	sub	a5,a5,a2
400020b4:	4106d713          	srai	a4,a3,0x10
400020b8:	00e787b3          	add	a5,a5,a4
400020bc:	01079713          	slli	a4,a5,0x10
400020c0:	0106f6b3          	and	a3,a3,a6
400020c4:	00d766b3          	or	a3,a4,a3
400020c8:	fed5ae23          	sw	a3,-4(a1)
400020cc:	4107d793          	srai	a5,a5,0x10
400020d0:	fa89fce3          	bleu	s0,s3,40002088 <quorem+0x130>
400020d4:	00291713          	slli	a4,s2,0x2
400020d8:	00ea0733          	add	a4,s4,a4
400020dc:	00072783          	lw	a5,0(a4)
400020e0:	02079863          	bnez	a5,40002110 <quorem+0x1b8>
400020e4:	ffc70793          	addi	a5,a4,-4
400020e8:	02fa7263          	bleu	a5,s4,4000210c <quorem+0x1b4>
400020ec:	ffc72703          	lw	a4,-4(a4)
400020f0:	00070863          	beqz	a4,40002100 <quorem+0x1a8>
400020f4:	0180006f          	j	4000210c <quorem+0x1b4>
400020f8:	0007a703          	lw	a4,0(a5)
400020fc:	00071863          	bnez	a4,4000210c <quorem+0x1b4>
40002100:	ffc78793          	addi	a5,a5,-4
40002104:	fff90913          	addi	s2,s2,-1
40002108:	fefa68e3          	bltu	s4,a5,400020f8 <quorem+0x1a0>
4000210c:	012aa823          	sw	s2,16(s5)
40002110:	00048513          	mv	a0,s1
40002114:	01c12083          	lw	ra,28(sp)
40002118:	01812403          	lw	s0,24(sp)
4000211c:	01412483          	lw	s1,20(sp)
40002120:	01012903          	lw	s2,16(sp)
40002124:	00c12983          	lw	s3,12(sp)
40002128:	00812a03          	lw	s4,8(sp)
4000212c:	00412a83          	lw	s5,4(sp)
40002130:	02010113          	addi	sp,sp,32
40002134:	00008067          	ret
40002138:	00000513          	li	a0,0
4000213c:	fd9ff06f          	j	40002114 <quorem+0x1bc>

40002140 <_dtoa_r>:
40002140:	04052303          	lw	t1,64(a0)
40002144:	f4010113          	addi	sp,sp,-192
40002148:	0a812c23          	sw	s0,184(sp)
4000214c:	0a912a23          	sw	s1,180(sp)
40002150:	0b212823          	sw	s2,176(sp)
40002154:	0b312623          	sw	s3,172(sp)
40002158:	0b412423          	sw	s4,168(sp)
4000215c:	0b612023          	sw	s6,160(sp)
40002160:	09912a23          	sw	s9,148(sp)
40002164:	09b12623          	sw	s11,140(sp)
40002168:	0a112e23          	sw	ra,188(sp)
4000216c:	0b512223          	sw	s5,164(sp)
40002170:	09712e23          	sw	s7,156(sp)
40002174:	09812c23          	sw	s8,152(sp)
40002178:	09a12823          	sw	s10,144(sp)
4000217c:	01012623          	sw	a6,12(sp)
40002180:	00050d93          	mv	s11,a0
40002184:	00060493          	mv	s1,a2
40002188:	00068913          	mv	s2,a3
4000218c:	00070c93          	mv	s9,a4
40002190:	00078b13          	mv	s6,a5
40002194:	00088993          	mv	s3,a7
40002198:	00060a13          	mv	s4,a2
4000219c:	00068413          	mv	s0,a3
400021a0:	02030263          	beqz	t1,400021c4 <_dtoa_r+0x84>
400021a4:	04452703          	lw	a4,68(a0)
400021a8:	00100793          	li	a5,1
400021ac:	00030593          	mv	a1,t1
400021b0:	00e797b3          	sll	a5,a5,a4
400021b4:	00e32223          	sw	a4,4(t1)
400021b8:	00f32423          	sw	a5,8(t1)
400021bc:	6a9020ef          	jal	ra,40005064 <_Bfree>
400021c0:	040da023          	sw	zero,64(s11)
400021c4:	00090a93          	mv	s5,s2
400021c8:	0e044863          	bltz	s0,400022b8 <_dtoa_r+0x178>
400021cc:	0009a023          	sw	zero,0(s3)
400021d0:	7ff007b7          	lui	a5,0x7ff00
400021d4:	00faf733          	and	a4,s5,a5
400021d8:	08f70263          	beq	a4,a5,4000225c <_dtoa_r+0x11c>
400021dc:	00048513          	mv	a0,s1
400021e0:	00040593          	mv	a1,s0
400021e4:	00000613          	li	a2,0
400021e8:	00000693          	li	a3,0
400021ec:	239070ef          	jal	ra,40009c24 <__eqdf2>
400021f0:	0e051263          	bnez	a0,400022d4 <_dtoa_r+0x194>
400021f4:	00c12703          	lw	a4,12(sp)
400021f8:	00100793          	li	a5,1
400021fc:	00f72023          	sw	a5,0(a4)
40002200:	0c012783          	lw	a5,192(sp)
40002204:	6a078263          	beqz	a5,400028a8 <_dtoa_r+0x768>
40002208:	0c012703          	lw	a4,192(sp)
4000220c:	4000b7b7          	lui	a5,0x4000b
40002210:	7e178793          	addi	a5,a5,2017 # 4000b7e1 <zeroes.4139+0x51>
40002214:	4000b537          	lui	a0,0x4000b
40002218:	00f72023          	sw	a5,0(a4)
4000221c:	7e050513          	addi	a0,a0,2016 # 4000b7e0 <zeroes.4139+0x50>
40002220:	0bc12083          	lw	ra,188(sp)
40002224:	0b812403          	lw	s0,184(sp)
40002228:	0b412483          	lw	s1,180(sp)
4000222c:	0b012903          	lw	s2,176(sp)
40002230:	0ac12983          	lw	s3,172(sp)
40002234:	0a812a03          	lw	s4,168(sp)
40002238:	0a412a83          	lw	s5,164(sp)
4000223c:	0a012b03          	lw	s6,160(sp)
40002240:	09c12b83          	lw	s7,156(sp)
40002244:	09812c03          	lw	s8,152(sp)
40002248:	09412c83          	lw	s9,148(sp)
4000224c:	09012d03          	lw	s10,144(sp)
40002250:	08c12d83          	lw	s11,140(sp)
40002254:	0c010113          	addi	sp,sp,192
40002258:	00008067          	ret
4000225c:	00c12703          	lw	a4,12(sp)
40002260:	000027b7          	lui	a5,0x2
40002264:	70f78793          	addi	a5,a5,1807 # 270f <_heap_size+0x70f>
40002268:	00f72023          	sw	a5,0(a4)
4000226c:	020a1863          	bnez	s4,4000229c <_dtoa_r+0x15c>
40002270:	00ca9793          	slli	a5,s5,0xc
40002274:	02079463          	bnez	a5,4000229c <_dtoa_r+0x15c>
40002278:	0c012783          	lw	a5,192(sp)
4000227c:	4000b537          	lui	a0,0x4000b
40002280:	7e450513          	addi	a0,a0,2020 # 4000b7e4 <zeroes.4139+0x54>
40002284:	f8078ee3          	beqz	a5,40002220 <_dtoa_r+0xe0>
40002288:	4000b7b7          	lui	a5,0x4000b
4000228c:	7ec78793          	addi	a5,a5,2028 # 4000b7ec <zeroes.4139+0x5c>
40002290:	0c012703          	lw	a4,192(sp)
40002294:	00f72023          	sw	a5,0(a4)
40002298:	f89ff06f          	j	40002220 <_dtoa_r+0xe0>
4000229c:	0c012783          	lw	a5,192(sp)
400022a0:	4000b537          	lui	a0,0x4000b
400022a4:	7f050513          	addi	a0,a0,2032 # 4000b7f0 <zeroes.4139+0x60>
400022a8:	f6078ce3          	beqz	a5,40002220 <_dtoa_r+0xe0>
400022ac:	4000b7b7          	lui	a5,0x4000b
400022b0:	7f378793          	addi	a5,a5,2035 # 4000b7f3 <zeroes.4139+0x63>
400022b4:	fddff06f          	j	40002290 <_dtoa_r+0x150>
400022b8:	80000437          	lui	s0,0x80000
400022bc:	fff44413          	not	s0,s0
400022c0:	01247433          	and	s0,s0,s2
400022c4:	00100793          	li	a5,1
400022c8:	00f9a023          	sw	a5,0(s3)
400022cc:	00040a93          	mv	s5,s0
400022d0:	f01ff06f          	j	400021d0 <_dtoa_r+0x90>
400022d4:	00048613          	mv	a2,s1
400022d8:	00040693          	mv	a3,s0
400022dc:	07810793          	addi	a5,sp,120
400022e0:	07c10713          	addi	a4,sp,124
400022e4:	000d8513          	mv	a0,s11
400022e8:	185030ef          	jal	ra,40005c6c <__d2b>
400022ec:	014ad913          	srli	s2,s5,0x14
400022f0:	00050d13          	mv	s10,a0
400022f4:	56090463          	beqz	s2,4000285c <_dtoa_r+0x71c>
400022f8:	001005b7          	lui	a1,0x100
400022fc:	fff58593          	addi	a1,a1,-1 # fffff <_heap_size+0xfdfff>
40002300:	07812983          	lw	s3,120(sp)
40002304:	0085f5b3          	and	a1,a1,s0
40002308:	3ff00bb7          	lui	s7,0x3ff00
4000230c:	00048793          	mv	a5,s1
40002310:	0175e5b3          	or	a1,a1,s7
40002314:	c0190913          	addi	s2,s2,-1023
40002318:	00000a93          	li	s5,0
4000231c:	4000c737          	lui	a4,0x4000c
40002320:	c4072603          	lw	a2,-960(a4) # 4000bc40 <__clz_tab+0x10c>
40002324:	c4472683          	lw	a3,-956(a4)
40002328:	00078513          	mv	a0,a5
4000232c:	25c080ef          	jal	ra,4000a588 <__subdf3>
40002330:	4000c7b7          	lui	a5,0x4000c
40002334:	c487a603          	lw	a2,-952(a5) # 4000bc48 <__clz_tab+0x114>
40002338:	c4c7a683          	lw	a3,-948(a5)
4000233c:	37d070ef          	jal	ra,40009eb8 <__muldf3>
40002340:	4000c7b7          	lui	a5,0x4000c
40002344:	c507a603          	lw	a2,-944(a5) # 4000bc50 <__clz_tab+0x11c>
40002348:	c547a683          	lw	a3,-940(a5)
4000234c:	750060ef          	jal	ra,40008a9c <__adddf3>
40002350:	00a12823          	sw	a0,16(sp)
40002354:	00090513          	mv	a0,s2
40002358:	00b12a23          	sw	a1,20(sp)
4000235c:	485080ef          	jal	ra,4000afe0 <__floatsidf>
40002360:	4000c7b7          	lui	a5,0x4000c
40002364:	c587a603          	lw	a2,-936(a5) # 4000bc58 <__clz_tab+0x124>
40002368:	c5c7a683          	lw	a3,-932(a5)
4000236c:	34d070ef          	jal	ra,40009eb8 <__muldf3>
40002370:	01012803          	lw	a6,16(sp)
40002374:	01412883          	lw	a7,20(sp)
40002378:	00050613          	mv	a2,a0
4000237c:	00058693          	mv	a3,a1
40002380:	00080513          	mv	a0,a6
40002384:	00088593          	mv	a1,a7
40002388:	714060ef          	jal	ra,40008a9c <__adddf3>
4000238c:	00b12e23          	sw	a1,28(sp)
40002390:	00a12c23          	sw	a0,24(sp)
40002394:	3c9080ef          	jal	ra,4000af5c <__fixdfsi>
40002398:	00a12823          	sw	a0,16(sp)
4000239c:	01c12583          	lw	a1,28(sp)
400023a0:	01812503          	lw	a0,24(sp)
400023a4:	00000613          	li	a2,0
400023a8:	00000693          	li	a3,0
400023ac:	209070ef          	jal	ra,40009db4 <__ledf2>
400023b0:	02054ee3          	bltz	a0,40002bec <_dtoa_r+0xaac>
400023b4:	01012b83          	lw	s7,16(sp)
400023b8:	00100713          	li	a4,1
400023bc:	01600793          	li	a5,22
400023c0:	02e12423          	sw	a4,40(sp)
400023c4:	0377ec63          	bltu	a5,s7,400023fc <_dtoa_r+0x2bc>
400023c8:	4000c737          	lui	a4,0x4000c
400023cc:	003b9793          	slli	a5,s7,0x3
400023d0:	81870713          	addi	a4,a4,-2024 # 4000b818 <__mprec_tens>
400023d4:	00e787b3          	add	a5,a5,a4
400023d8:	0007a503          	lw	a0,0(a5)
400023dc:	0047a583          	lw	a1,4(a5)
400023e0:	00048613          	mv	a2,s1
400023e4:	00040693          	mv	a3,s0
400023e8:	0c9070ef          	jal	ra,40009cb0 <__gedf2>
400023ec:	04a05ee3          	blez	a0,40002c48 <_dtoa_r+0xb08>
400023f0:	fffb8793          	addi	a5,s7,-1 # 3fefffff <_heap_size+0x3fefdfff>
400023f4:	00f12823          	sw	a5,16(sp)
400023f8:	02012423          	sw	zero,40(sp)
400023fc:	41298933          	sub	s2,s3,s2
40002400:	fff90b93          	addi	s7,s2,-1
40002404:	00000c13          	li	s8,0
40002408:	000bcae3          	bltz	s7,40002c1c <_dtoa_r+0xadc>
4000240c:	01012783          	lw	a5,16(sp)
40002410:	7c07c463          	bltz	a5,40002bd8 <_dtoa_r+0xa98>
40002414:	00fb8bb3          	add	s7,s7,a5
40002418:	02f12623          	sw	a5,44(sp)
4000241c:	00000993          	li	s3,0
40002420:	00900793          	li	a5,9
40002424:	4997e863          	bltu	a5,s9,400028b4 <_dtoa_r+0x774>
40002428:	00500793          	li	a5,5
4000242c:	00100913          	li	s2,1
40002430:	0197d663          	ble	s9,a5,4000243c <_dtoa_r+0x2fc>
40002434:	ffcc8c93          	addi	s9,s9,-4
40002438:	00000913          	li	s2,0
4000243c:	00300793          	li	a5,3
40002440:	56fc8ae3          	beq	s9,a5,400031b4 <_dtoa_r+0x1074>
40002444:	4b97dee3          	ble	s9,a5,40003100 <_dtoa_r+0xfc0>
40002448:	00400793          	li	a5,4
4000244c:	34fc86e3          	beq	s9,a5,40002f98 <_dtoa_r+0xe58>
40002450:	00100713          	li	a4,1
40002454:	00500793          	li	a5,5
40002458:	02e12223          	sw	a4,36(sp)
4000245c:	4afc98e3          	bne	s9,a5,4000310c <_dtoa_r+0xfcc>
40002460:	01012783          	lw	a5,16(sp)
40002464:	016787b3          	add	a5,a5,s6
40002468:	02f12c23          	sw	a5,56(sp)
4000246c:	00178793          	addi	a5,a5,1
40002470:	00f12c23          	sw	a5,24(sp)
40002474:	00078613          	mv	a2,a5
40002478:	3ef058e3          	blez	a5,40003068 <_dtoa_r+0xf28>
4000247c:	01812803          	lw	a6,24(sp)
40002480:	040da223          	sw	zero,68(s11)
40002484:	01700793          	li	a5,23
40002488:	00000593          	li	a1,0
4000248c:	02c7f263          	bleu	a2,a5,400024b0 <_dtoa_r+0x370>
40002490:	00100713          	li	a4,1
40002494:	00400793          	li	a5,4
40002498:	00179793          	slli	a5,a5,0x1
4000249c:	01478693          	addi	a3,a5,20
400024a0:	00070593          	mv	a1,a4
400024a4:	00170713          	addi	a4,a4,1
400024a8:	fed678e3          	bleu	a3,a2,40002498 <_dtoa_r+0x358>
400024ac:	04bda223          	sw	a1,68(s11)
400024b0:	000d8513          	mv	a0,s11
400024b4:	03012823          	sw	a6,48(sp)
400024b8:	309020ef          	jal	ra,40004fc0 <_Balloc>
400024bc:	03012803          	lw	a6,48(sp)
400024c0:	02a12023          	sw	a0,32(sp)
400024c4:	04ada023          	sw	a0,64(s11)
400024c8:	00e00793          	li	a5,14
400024cc:	4107ee63          	bltu	a5,a6,400028e8 <_dtoa_r+0x7a8>
400024d0:	40090c63          	beqz	s2,400028e8 <_dtoa_r+0x7a8>
400024d4:	01012703          	lw	a4,16(sp)
400024d8:	02912e23          	sw	s1,60(sp)
400024dc:	04812423          	sw	s0,72(sp)
400024e0:	5ee050e3          	blez	a4,400032c0 <_dtoa_r+0x1180>
400024e4:	00f77793          	andi	a5,a4,15
400024e8:	40475a13          	srai	s4,a4,0x4
400024ec:	4000c737          	lui	a4,0x4000c
400024f0:	81870713          	addi	a4,a4,-2024 # 4000b818 <__mprec_tens>
400024f4:	00379793          	slli	a5,a5,0x3
400024f8:	00e787b3          	add	a5,a5,a4
400024fc:	02912823          	sw	s1,48(sp)
40002500:	010a7713          	andi	a4,s4,16
40002504:	02812a23          	sw	s0,52(sp)
40002508:	0007a803          	lw	a6,0(a5)
4000250c:	0047a883          	lw	a7,4(a5)
40002510:	00200913          	li	s2,2
40002514:	02070e63          	beqz	a4,40002550 <_dtoa_r+0x410>
40002518:	4000c7b7          	lui	a5,0x4000c
4000251c:	9287a603          	lw	a2,-1752(a5) # 4000b928 <__mprec_bigtens+0x20>
40002520:	92c7a683          	lw	a3,-1748(a5)
40002524:	00048513          	mv	a0,s1
40002528:	00040593          	mv	a1,s0
4000252c:	05012023          	sw	a6,64(sp)
40002530:	05112223          	sw	a7,68(sp)
40002534:	6b5060ef          	jal	ra,400093e8 <__divdf3>
40002538:	04012803          	lw	a6,64(sp)
4000253c:	04412883          	lw	a7,68(sp)
40002540:	02a12823          	sw	a0,48(sp)
40002544:	02b12a23          	sw	a1,52(sp)
40002548:	00fa7a13          	andi	s4,s4,15
4000254c:	00300913          	li	s2,3
40002550:	040a0063          	beqz	s4,40002590 <_dtoa_r+0x450>
40002554:	4000c437          	lui	s0,0x4000c
40002558:	90840413          	addi	s0,s0,-1784 # 4000b908 <__mprec_bigtens>
4000255c:	001a7793          	andi	a5,s4,1
40002560:	00080513          	mv	a0,a6
40002564:	401a5a13          	srai	s4,s4,0x1
40002568:	00088593          	mv	a1,a7
4000256c:	00078e63          	beqz	a5,40002588 <_dtoa_r+0x448>
40002570:	00042603          	lw	a2,0(s0)
40002574:	00442683          	lw	a3,4(s0)
40002578:	00190913          	addi	s2,s2,1
4000257c:	13d070ef          	jal	ra,40009eb8 <__muldf3>
40002580:	00050813          	mv	a6,a0
40002584:	00058893          	mv	a7,a1
40002588:	00840413          	addi	s0,s0,8
4000258c:	fc0a18e3          	bnez	s4,4000255c <_dtoa_r+0x41c>
40002590:	03012503          	lw	a0,48(sp)
40002594:	03412583          	lw	a1,52(sp)
40002598:	00080613          	mv	a2,a6
4000259c:	00088693          	mv	a3,a7
400025a0:	649060ef          	jal	ra,400093e8 <__divdf3>
400025a4:	02a12823          	sw	a0,48(sp)
400025a8:	02b12a23          	sw	a1,52(sp)
400025ac:	02812783          	lw	a5,40(sp)
400025b0:	02078263          	beqz	a5,400025d4 <_dtoa_r+0x494>
400025b4:	4000c7b7          	lui	a5,0x4000c
400025b8:	c607a603          	lw	a2,-928(a5) # 4000bc60 <__clz_tab+0x12c>
400025bc:	c647a683          	lw	a3,-924(a5)
400025c0:	03012503          	lw	a0,48(sp)
400025c4:	03412583          	lw	a1,52(sp)
400025c8:	7ec070ef          	jal	ra,40009db4 <__ledf2>
400025cc:	00055463          	bgez	a0,400025d4 <_dtoa_r+0x494>
400025d0:	7910006f          	j	40003560 <_dtoa_r+0x1420>
400025d4:	00090513          	mv	a0,s2
400025d8:	209080ef          	jal	ra,4000afe0 <__floatsidf>
400025dc:	03012603          	lw	a2,48(sp)
400025e0:	03412683          	lw	a3,52(sp)
400025e4:	fcc004b7          	lui	s1,0xfcc00
400025e8:	0d1070ef          	jal	ra,40009eb8 <__muldf3>
400025ec:	4000c7b7          	lui	a5,0x4000c
400025f0:	c707a603          	lw	a2,-912(a5) # 4000bc70 <__clz_tab+0x13c>
400025f4:	c747a683          	lw	a3,-908(a5)
400025f8:	4a4060ef          	jal	ra,40008a9c <__adddf3>
400025fc:	01812783          	lw	a5,24(sp)
40002600:	00050413          	mv	s0,a0
40002604:	00b484b3          	add	s1,s1,a1
40002608:	3e0782e3          	beqz	a5,400031ec <_dtoa_r+0x10ac>
4000260c:	01012783          	lw	a5,16(sp)
40002610:	01812903          	lw	s2,24(sp)
40002614:	04f12623          	sw	a5,76(sp)
40002618:	02412783          	lw	a5,36(sp)
4000261c:	5a0782e3          	beqz	a5,400033c0 <_dtoa_r+0x1280>
40002620:	fff90793          	addi	a5,s2,-1
40002624:	4000c737          	lui	a4,0x4000c
40002628:	81870713          	addi	a4,a4,-2024 # 4000b818 <__mprec_tens>
4000262c:	00379793          	slli	a5,a5,0x3
40002630:	00e787b3          	add	a5,a5,a4
40002634:	0007a603          	lw	a2,0(a5)
40002638:	0047a683          	lw	a3,4(a5)
4000263c:	4000c7b7          	lui	a5,0x4000c
40002640:	c807a503          	lw	a0,-896(a5) # 4000bc80 <__clz_tab+0x14c>
40002644:	c847a583          	lw	a1,-892(a5)
40002648:	02012783          	lw	a5,32(sp)
4000264c:	00178a13          	addi	s4,a5,1
40002650:	599060ef          	jal	ra,400093e8 <__divdf3>
40002654:	00040613          	mv	a2,s0
40002658:	00048693          	mv	a3,s1
4000265c:	72d070ef          	jal	ra,4000a588 <__subdf3>
40002660:	04a12023          	sw	a0,64(sp)
40002664:	04b12223          	sw	a1,68(sp)
40002668:	03012503          	lw	a0,48(sp)
4000266c:	03412583          	lw	a1,52(sp)
40002670:	0ed080ef          	jal	ra,4000af5c <__fixdfsi>
40002674:	00050413          	mv	s0,a0
40002678:	169080ef          	jal	ra,4000afe0 <__floatsidf>
4000267c:	00050613          	mv	a2,a0
40002680:	00058693          	mv	a3,a1
40002684:	03012503          	lw	a0,48(sp)
40002688:	03412583          	lw	a1,52(sp)
4000268c:	6fd070ef          	jal	ra,4000a588 <__subdf3>
40002690:	02012783          	lw	a5,32(sp)
40002694:	00050613          	mv	a2,a0
40002698:	00058693          	mv	a3,a1
4000269c:	03040713          	addi	a4,s0,48
400026a0:	04a12823          	sw	a0,80(sp)
400026a4:	04b12a23          	sw	a1,84(sp)
400026a8:	04012503          	lw	a0,64(sp)
400026ac:	04412583          	lw	a1,68(sp)
400026b0:	0ff77413          	andi	s0,a4,255
400026b4:	00878023          	sb	s0,0(a5)
400026b8:	5f8070ef          	jal	ra,40009cb0 <__gedf2>
400026bc:	16a04263          	bgtz	a0,40002820 <_dtoa_r+0x6e0>
400026c0:	4000c7b7          	lui	a5,0x4000c
400026c4:	05012603          	lw	a2,80(sp)
400026c8:	05412683          	lw	a3,84(sp)
400026cc:	c607a503          	lw	a0,-928(a5) # 4000bc60 <__clz_tab+0x12c>
400026d0:	c647a583          	lw	a1,-924(a5)
400026d4:	02f12823          	sw	a5,48(sp)
400026d8:	6b1070ef          	jal	ra,4000a588 <__subdf3>
400026dc:	04012603          	lw	a2,64(sp)
400026e0:	04412683          	lw	a3,68(sp)
400026e4:	6d0070ef          	jal	ra,40009db4 <__ledf2>
400026e8:	00055463          	bgez	a0,400026f0 <_dtoa_r+0x5b0>
400026ec:	7490006f          	j	40003634 <_dtoa_r+0x14f4>
400026f0:	00100713          	li	a4,1
400026f4:	03012783          	lw	a5,48(sp)
400026f8:	3ae90ee3          	beq	s2,a4,400032b4 <_dtoa_r+0x1174>
400026fc:	4000c4b7          	lui	s1,0x4000c
40002700:	c684a703          	lw	a4,-920(s1) # 4000bc68 <__clz_tab+0x134>
40002704:	c6c4a483          	lw	s1,-916(s1)
40002708:	05812e23          	sw	s8,92(sp)
4000270c:	00070693          	mv	a3,a4
40002710:	c607a703          	lw	a4,-928(a5)
40002714:	c647a783          	lw	a5,-924(a5)
40002718:	07312023          	sw	s3,96(sp)
4000271c:	02e12823          	sw	a4,48(sp)
40002720:	02f12a23          	sw	a5,52(sp)
40002724:	02012783          	lw	a5,32(sp)
40002728:	00068713          	mv	a4,a3
4000272c:	07712223          	sw	s7,100(sp)
40002730:	012787b3          	add	a5,a5,s2
40002734:	07512423          	sw	s5,104(sp)
40002738:	05a12c23          	sw	s10,88(sp)
4000273c:	07912623          	sw	s9,108(sp)
40002740:	04012c03          	lw	s8,64(sp)
40002744:	00068913          	mv	s2,a3
40002748:	05612023          	sw	s6,64(sp)
4000274c:	00078a93          	mv	s5,a5
40002750:	000d8b13          	mv	s6,s11
40002754:	04412c83          	lw	s9,68(sp)
40002758:	05012d03          	lw	s10,80(sp)
4000275c:	05412d83          	lw	s11,84(sp)
40002760:	00070993          	mv	s3,a4
40002764:	00048b93          	mv	s7,s1
40002768:	0280006f          	j	40002790 <_dtoa_r+0x650>
4000276c:	03012503          	lw	a0,48(sp)
40002770:	03412583          	lw	a1,52(sp)
40002774:	615070ef          	jal	ra,4000a588 <__subdf3>
40002778:	000c0613          	mv	a2,s8
4000277c:	000c8693          	mv	a3,s9
40002780:	634070ef          	jal	ra,40009db4 <__ledf2>
40002784:	00055463          	bgez	a0,4000278c <_dtoa_r+0x64c>
40002788:	6a50006f          	j	4000362c <_dtoa_r+0x14ec>
4000278c:	315a04e3          	beq	s4,s5,40003294 <_dtoa_r+0x1154>
40002790:	00098613          	mv	a2,s3
40002794:	00048693          	mv	a3,s1
40002798:	000c0513          	mv	a0,s8
4000279c:	000c8593          	mv	a1,s9
400027a0:	718070ef          	jal	ra,40009eb8 <__muldf3>
400027a4:	00090613          	mv	a2,s2
400027a8:	000b8693          	mv	a3,s7
400027ac:	00050c13          	mv	s8,a0
400027b0:	00058c93          	mv	s9,a1
400027b4:	000d0513          	mv	a0,s10
400027b8:	000d8593          	mv	a1,s11
400027bc:	6fc070ef          	jal	ra,40009eb8 <__muldf3>
400027c0:	00058d93          	mv	s11,a1
400027c4:	00050d13          	mv	s10,a0
400027c8:	794080ef          	jal	ra,4000af5c <__fixdfsi>
400027cc:	00050413          	mv	s0,a0
400027d0:	011080ef          	jal	ra,4000afe0 <__floatsidf>
400027d4:	00050613          	mv	a2,a0
400027d8:	00058693          	mv	a3,a1
400027dc:	000d0513          	mv	a0,s10
400027e0:	000d8593          	mv	a1,s11
400027e4:	03040413          	addi	s0,s0,48
400027e8:	5a1070ef          	jal	ra,4000a588 <__subdf3>
400027ec:	001a0a13          	addi	s4,s4,1
400027f0:	0ff47413          	andi	s0,s0,255
400027f4:	000c0613          	mv	a2,s8
400027f8:	000c8693          	mv	a3,s9
400027fc:	fe8a0fa3          	sb	s0,-1(s4)
40002800:	00050d13          	mv	s10,a0
40002804:	00058d93          	mv	s11,a1
40002808:	5ac070ef          	jal	ra,40009db4 <__ledf2>
4000280c:	000d0613          	mv	a2,s10
40002810:	000d8693          	mv	a3,s11
40002814:	f4055ce3          	bgez	a0,4000276c <_dtoa_r+0x62c>
40002818:	05812d03          	lw	s10,88(sp)
4000281c:	000b0d93          	mv	s11,s6
40002820:	04c12783          	lw	a5,76(sp)
40002824:	00f12823          	sw	a5,16(sp)
40002828:	000d0593          	mv	a1,s10
4000282c:	000d8513          	mv	a0,s11
40002830:	035020ef          	jal	ra,40005064 <_Bfree>
40002834:	01012783          	lw	a5,16(sp)
40002838:	000a0023          	sb	zero,0(s4)
4000283c:	00178713          	addi	a4,a5,1
40002840:	00c12783          	lw	a5,12(sp)
40002844:	00e7a023          	sw	a4,0(a5)
40002848:	0c012783          	lw	a5,192(sp)
4000284c:	1e078ee3          	beqz	a5,40003248 <_dtoa_r+0x1108>
40002850:	0147a023          	sw	s4,0(a5)
40002854:	02012503          	lw	a0,32(sp)
40002858:	9c9ff06f          	j	40002220 <_dtoa_r+0xe0>
4000285c:	07812983          	lw	s3,120(sp)
40002860:	07c12903          	lw	s2,124(sp)
40002864:	02000793          	li	a5,32
40002868:	01298933          	add	s2,s3,s2
4000286c:	43290713          	addi	a4,s2,1074
40002870:	3ce7d663          	ble	a4,a5,40002c3c <_dtoa_r+0xafc>
40002874:	04000793          	li	a5,64
40002878:	41290513          	addi	a0,s2,1042
4000287c:	40e787b3          	sub	a5,a5,a4
40002880:	00a4d533          	srl	a0,s1,a0
40002884:	00fa9ab3          	sll	s5,s5,a5
40002888:	01556533          	or	a0,a0,s5
4000288c:	04d080ef          	jal	ra,4000b0d8 <__floatunsidf>
40002890:	fe100bb7          	lui	s7,0xfe100
40002894:	00050793          	mv	a5,a0
40002898:	00bb85b3          	add	a1,s7,a1
4000289c:	fff90913          	addi	s2,s2,-1
400028a0:	00100a93          	li	s5,1
400028a4:	a79ff06f          	j	4000231c <_dtoa_r+0x1dc>
400028a8:	4000b537          	lui	a0,0x4000b
400028ac:	7e050513          	addi	a0,a0,2016 # 4000b7e0 <zeroes.4139+0x50>
400028b0:	971ff06f          	j	40002220 <_dtoa_r+0xe0>
400028b4:	040da223          	sw	zero,68(s11)
400028b8:	00000593          	li	a1,0
400028bc:	000d8513          	mv	a0,s11
400028c0:	700020ef          	jal	ra,40004fc0 <_Balloc>
400028c4:	fff00793          	li	a5,-1
400028c8:	02f12c23          	sw	a5,56(sp)
400028cc:	00f12c23          	sw	a5,24(sp)
400028d0:	00100793          	li	a5,1
400028d4:	02a12023          	sw	a0,32(sp)
400028d8:	04ada023          	sw	a0,64(s11)
400028dc:	00000c93          	li	s9,0
400028e0:	00000b13          	li	s6,0
400028e4:	02f12223          	sw	a5,36(sp)
400028e8:	07c12783          	lw	a5,124(sp)
400028ec:	1c07cc63          	bltz	a5,40002ac4 <_dtoa_r+0x984>
400028f0:	01012683          	lw	a3,16(sp)
400028f4:	00e00713          	li	a4,14
400028f8:	1cd74663          	blt	a4,a3,40002ac4 <_dtoa_r+0x984>
400028fc:	4000c737          	lui	a4,0x4000c
40002900:	00369793          	slli	a5,a3,0x3
40002904:	81870713          	addi	a4,a4,-2024 # 4000b818 <__mprec_tens>
40002908:	00e787b3          	add	a5,a5,a4
4000290c:	0007ac03          	lw	s8,0(a5)
40002910:	0047ac83          	lw	s9,4(a5)
40002914:	6a0b4263          	bltz	s6,40002fb8 <_dtoa_r+0xe78>
40002918:	000c0613          	mv	a2,s8
4000291c:	000c8693          	mv	a3,s9
40002920:	000a0513          	mv	a0,s4
40002924:	00040593          	mv	a1,s0
40002928:	2c1060ef          	jal	ra,400093e8 <__divdf3>
4000292c:	630080ef          	jal	ra,4000af5c <__fixdfsi>
40002930:	00050493          	mv	s1,a0
40002934:	6ac080ef          	jal	ra,4000afe0 <__floatsidf>
40002938:	000c0613          	mv	a2,s8
4000293c:	000c8693          	mv	a3,s9
40002940:	578070ef          	jal	ra,40009eb8 <__muldf3>
40002944:	00058693          	mv	a3,a1
40002948:	00050613          	mv	a2,a0
4000294c:	00040593          	mv	a1,s0
40002950:	000a0513          	mv	a0,s4
40002954:	435070ef          	jal	ra,4000a588 <__subdf3>
40002958:	02012683          	lw	a3,32(sp)
4000295c:	03048793          	addi	a5,s1,48
40002960:	00100713          	li	a4,1
40002964:	00f68023          	sb	a5,0(a3)
40002968:	01812783          	lw	a5,24(sp)
4000296c:	00050813          	mv	a6,a0
40002970:	00058893          	mv	a7,a1
40002974:	00e68a33          	add	s4,a3,a4
40002978:	0ce78463          	beq	a5,a4,40002a40 <_dtoa_r+0x900>
4000297c:	4000c4b7          	lui	s1,0x4000c
40002980:	c684a603          	lw	a2,-920(s1) # 4000bc68 <__clz_tab+0x134>
40002984:	c6c4a683          	lw	a3,-916(s1)
40002988:	530070ef          	jal	ra,40009eb8 <__muldf3>
4000298c:	00000613          	li	a2,0
40002990:	00000693          	li	a3,0
40002994:	00050913          	mv	s2,a0
40002998:	00058993          	mv	s3,a1
4000299c:	288070ef          	jal	ra,40009c24 <__eqdf2>
400029a0:	e80504e3          	beqz	a0,40002828 <_dtoa_r+0x6e8>
400029a4:	02012783          	lw	a5,32(sp)
400029a8:	01812703          	lw	a4,24(sp)
400029ac:	c684ab03          	lw	s6,-920(s1)
400029b0:	c6c4ab83          	lw	s7,-916(s1)
400029b4:	00278413          	addi	s0,a5,2
400029b8:	00e78ab3          	add	s5,a5,a4
400029bc:	0240006f          	j	400029e0 <_dtoa_r+0x8a0>
400029c0:	4f8070ef          	jal	ra,40009eb8 <__muldf3>
400029c4:	00000613          	li	a2,0
400029c8:	00000693          	li	a3,0
400029cc:	00050913          	mv	s2,a0
400029d0:	00058993          	mv	s3,a1
400029d4:	00140413          	addi	s0,s0,1
400029d8:	24c070ef          	jal	ra,40009c24 <__eqdf2>
400029dc:	e40506e3          	beqz	a0,40002828 <_dtoa_r+0x6e8>
400029e0:	000c0613          	mv	a2,s8
400029e4:	000c8693          	mv	a3,s9
400029e8:	00090513          	mv	a0,s2
400029ec:	00098593          	mv	a1,s3
400029f0:	1f9060ef          	jal	ra,400093e8 <__divdf3>
400029f4:	568080ef          	jal	ra,4000af5c <__fixdfsi>
400029f8:	00050493          	mv	s1,a0
400029fc:	5e4080ef          	jal	ra,4000afe0 <__floatsidf>
40002a00:	000c0613          	mv	a2,s8
40002a04:	000c8693          	mv	a3,s9
40002a08:	4b0070ef          	jal	ra,40009eb8 <__muldf3>
40002a0c:	00050613          	mv	a2,a0
40002a10:	00058693          	mv	a3,a1
40002a14:	00090513          	mv	a0,s2
40002a18:	00098593          	mv	a1,s3
40002a1c:	36d070ef          	jal	ra,4000a588 <__subdf3>
40002a20:	03048793          	addi	a5,s1,48
40002a24:	fef40fa3          	sb	a5,-1(s0)
40002a28:	00050813          	mv	a6,a0
40002a2c:	00058893          	mv	a7,a1
40002a30:	000b0613          	mv	a2,s6
40002a34:	000b8693          	mv	a3,s7
40002a38:	00040a13          	mv	s4,s0
40002a3c:	f88a92e3          	bne	s5,s0,400029c0 <_dtoa_r+0x880>
40002a40:	00080613          	mv	a2,a6
40002a44:	00088693          	mv	a3,a7
40002a48:	00080513          	mv	a0,a6
40002a4c:	00088593          	mv	a1,a7
40002a50:	04c060ef          	jal	ra,40008a9c <__adddf3>
40002a54:	00050913          	mv	s2,a0
40002a58:	00058993          	mv	s3,a1
40002a5c:	00050613          	mv	a2,a0
40002a60:	00058693          	mv	a3,a1
40002a64:	000c0513          	mv	a0,s8
40002a68:	000c8593          	mv	a1,s9
40002a6c:	348070ef          	jal	ra,40009db4 <__ledf2>
40002a70:	02054263          	bltz	a0,40002a94 <_dtoa_r+0x954>
40002a74:	00090613          	mv	a2,s2
40002a78:	00098693          	mv	a3,s3
40002a7c:	000c0513          	mv	a0,s8
40002a80:	000c8593          	mv	a1,s9
40002a84:	1a0070ef          	jal	ra,40009c24 <__eqdf2>
40002a88:	da0510e3          	bnez	a0,40002828 <_dtoa_r+0x6e8>
40002a8c:	0014f493          	andi	s1,s1,1
40002a90:	d8048ce3          	beqz	s1,40002828 <_dtoa_r+0x6e8>
40002a94:	fffa4403          	lbu	s0,-1(s4)
40002a98:	03900613          	li	a2,57
40002a9c:	02012783          	lw	a5,32(sp)
40002aa0:	0100006f          	j	40002ab0 <_dtoa_r+0x970>
40002aa4:	0af68ee3          	beq	a3,a5,40003360 <_dtoa_r+0x1220>
40002aa8:	fff6c403          	lbu	s0,-1(a3)
40002aac:	00068a13          	mv	s4,a3
40002ab0:	fffa0693          	addi	a3,s4,-1
40002ab4:	fec408e3          	beq	s0,a2,40002aa4 <_dtoa_r+0x964>
40002ab8:	00140713          	addi	a4,s0,1
40002abc:	00e68023          	sb	a4,0(a3)
40002ac0:	d69ff06f          	j	40002828 <_dtoa_r+0x6e8>
40002ac4:	02412703          	lw	a4,36(sp)
40002ac8:	16070263          	beqz	a4,40002c2c <_dtoa_r+0xaec>
40002acc:	00100713          	li	a4,1
40002ad0:	59975263          	ble	s9,a4,40003054 <_dtoa_r+0xf14>
40002ad4:	01812783          	lw	a5,24(sp)
40002ad8:	fff78913          	addi	s2,a5,-1
40002adc:	7729ca63          	blt	s3,s2,40003250 <_dtoa_r+0x1110>
40002ae0:	41298933          	sub	s2,s3,s2
40002ae4:	01812703          	lw	a4,24(sp)
40002ae8:	000c0a93          	mv	s5,s8
40002aec:	00070793          	mv	a5,a4
40002af0:	240742e3          	bltz	a4,40003534 <_dtoa_r+0x13f4>
40002af4:	00100593          	li	a1,1
40002af8:	000d8513          	mv	a0,s11
40002afc:	00fc0c33          	add	s8,s8,a5
40002b00:	00fb8bb3          	add	s7,s7,a5
40002b04:	0d9020ef          	jal	ra,400053dc <__i2b>
40002b08:	00050493          	mv	s1,a0
40002b0c:	01505e63          	blez	s5,40002b28 <_dtoa_r+0x9e8>
40002b10:	01705c63          	blez	s7,40002b28 <_dtoa_r+0x9e8>
40002b14:	000a8793          	mv	a5,s5
40002b18:	455bc663          	blt	s7,s5,40002f64 <_dtoa_r+0xe24>
40002b1c:	40fc0c33          	sub	s8,s8,a5
40002b20:	40fa8ab3          	sub	s5,s5,a5
40002b24:	40fb8bb3          	sub	s7,s7,a5
40002b28:	04098a63          	beqz	s3,40002b7c <_dtoa_r+0xa3c>
40002b2c:	02412783          	lw	a5,36(sp)
40002b30:	4e078263          	beqz	a5,40003014 <_dtoa_r+0xed4>
40002b34:	05205063          	blez	s2,40002b74 <_dtoa_r+0xa34>
40002b38:	00048593          	mv	a1,s1
40002b3c:	00090613          	mv	a2,s2
40002b40:	000d8513          	mv	a0,s11
40002b44:	2ad020ef          	jal	ra,400055f0 <__pow5mult>
40002b48:	000d0613          	mv	a2,s10
40002b4c:	00050593          	mv	a1,a0
40002b50:	00050493          	mv	s1,a0
40002b54:	000d8513          	mv	a0,s11
40002b58:	0b9020ef          	jal	ra,40005410 <__multiply>
40002b5c:	02a12823          	sw	a0,48(sp)
40002b60:	000d0593          	mv	a1,s10
40002b64:	000d8513          	mv	a0,s11
40002b68:	4fc020ef          	jal	ra,40005064 <_Bfree>
40002b6c:	03012783          	lw	a5,48(sp)
40002b70:	00078d13          	mv	s10,a5
40002b74:	41298633          	sub	a2,s3,s2
40002b78:	4a061063          	bnez	a2,40003018 <_dtoa_r+0xed8>
40002b7c:	00100593          	li	a1,1
40002b80:	000d8513          	mv	a0,s11
40002b84:	059020ef          	jal	ra,400053dc <__i2b>
40002b88:	02c12783          	lw	a5,44(sp)
40002b8c:	00050993          	mv	s3,a0
40002b90:	0cf05063          	blez	a5,40002c50 <_dtoa_r+0xb10>
40002b94:	00078613          	mv	a2,a5
40002b98:	00050593          	mv	a1,a0
40002b9c:	000d8513          	mv	a0,s11
40002ba0:	251020ef          	jal	ra,400055f0 <__pow5mult>
40002ba4:	00100793          	li	a5,1
40002ba8:	00050993          	mv	s3,a0
40002bac:	3d97d063          	ble	s9,a5,40002f6c <_dtoa_r+0xe2c>
40002bb0:	00000913          	li	s2,0
40002bb4:	0109a783          	lw	a5,16(s3)
40002bb8:	00378793          	addi	a5,a5,3
40002bbc:	00279793          	slli	a5,a5,0x2
40002bc0:	00f987b3          	add	a5,s3,a5
40002bc4:	0047a503          	lw	a0,4(a5)
40002bc8:	6e4020ef          	jal	ra,400052ac <__hi0bits>
40002bcc:	02000793          	li	a5,32
40002bd0:	40a787b3          	sub	a5,a5,a0
40002bd4:	0940006f          	j	40002c68 <_dtoa_r+0xb28>
40002bd8:	01012783          	lw	a5,16(sp)
40002bdc:	02012623          	sw	zero,44(sp)
40002be0:	40fc0c33          	sub	s8,s8,a5
40002be4:	40f009b3          	neg	s3,a5
40002be8:	839ff06f          	j	40002420 <_dtoa_r+0x2e0>
40002bec:	01012b83          	lw	s7,16(sp)
40002bf0:	000b8513          	mv	a0,s7
40002bf4:	3ec080ef          	jal	ra,4000afe0 <__floatsidf>
40002bf8:	00050613          	mv	a2,a0
40002bfc:	00058693          	mv	a3,a1
40002c00:	01812503          	lw	a0,24(sp)
40002c04:	01c12583          	lw	a1,28(sp)
40002c08:	01c070ef          	jal	ra,40009c24 <__eqdf2>
40002c0c:	00a03533          	snez	a0,a0
40002c10:	40ab87b3          	sub	a5,s7,a0
40002c14:	00f12823          	sw	a5,16(sp)
40002c18:	f9cff06f          	j	400023b4 <_dtoa_r+0x274>
40002c1c:	00100c13          	li	s8,1
40002c20:	412c0c33          	sub	s8,s8,s2
40002c24:	00000b93          	li	s7,0
40002c28:	fe4ff06f          	j	4000240c <_dtoa_r+0x2cc>
40002c2c:	00098913          	mv	s2,s3
40002c30:	000c0a93          	mv	s5,s8
40002c34:	00000493          	li	s1,0
40002c38:	ed5ff06f          	j	40002b0c <_dtoa_r+0x9cc>
40002c3c:	40e787b3          	sub	a5,a5,a4
40002c40:	00f49533          	sll	a0,s1,a5
40002c44:	c49ff06f          	j	4000288c <_dtoa_r+0x74c>
40002c48:	02012423          	sw	zero,40(sp)
40002c4c:	fb0ff06f          	j	400023fc <_dtoa_r+0x2bc>
40002c50:	00100793          	li	a5,1
40002c54:	00000913          	li	s2,0
40002c58:	4997d663          	ble	s9,a5,400030e4 <_dtoa_r+0xfa4>
40002c5c:	02c12703          	lw	a4,44(sp)
40002c60:	00100793          	li	a5,1
40002c64:	f40718e3          	bnez	a4,40002bb4 <_dtoa_r+0xa74>
40002c68:	017787b3          	add	a5,a5,s7
40002c6c:	01f7f793          	andi	a5,a5,31
40002c70:	1a078663          	beqz	a5,40002e1c <_dtoa_r+0xcdc>
40002c74:	02000713          	li	a4,32
40002c78:	40f70733          	sub	a4,a4,a5
40002c7c:	00400693          	li	a3,4
40002c80:	20e6dce3          	ble	a4,a3,40003698 <_dtoa_r+0x1558>
40002c84:	01c00713          	li	a4,28
40002c88:	40f707b3          	sub	a5,a4,a5
40002c8c:	00fc0c33          	add	s8,s8,a5
40002c90:	00fa8ab3          	add	s5,s5,a5
40002c94:	00fb8bb3          	add	s7,s7,a5
40002c98:	01805c63          	blez	s8,40002cb0 <_dtoa_r+0xb70>
40002c9c:	000d0593          	mv	a1,s10
40002ca0:	000c0613          	mv	a2,s8
40002ca4:	000d8513          	mv	a0,s11
40002ca8:	291020ef          	jal	ra,40005738 <__lshift>
40002cac:	00050d13          	mv	s10,a0
40002cb0:	01705c63          	blez	s7,40002cc8 <_dtoa_r+0xb88>
40002cb4:	00098593          	mv	a1,s3
40002cb8:	000b8613          	mv	a2,s7
40002cbc:	000d8513          	mv	a0,s11
40002cc0:	279020ef          	jal	ra,40005738 <__lshift>
40002cc4:	00050993          	mv	s3,a0
40002cc8:	02812783          	lw	a5,40(sp)
40002ccc:	16079263          	bnez	a5,40002e30 <_dtoa_r+0xcf0>
40002cd0:	01812783          	lw	a5,24(sp)
40002cd4:	46f05663          	blez	a5,40003140 <_dtoa_r+0x1000>
40002cd8:	02412783          	lw	a5,36(sp)
40002cdc:	1a078463          	beqz	a5,40002e84 <_dtoa_r+0xd44>
40002ce0:	01505c63          	blez	s5,40002cf8 <_dtoa_r+0xbb8>
40002ce4:	00048593          	mv	a1,s1
40002ce8:	000a8613          	mv	a2,s5
40002cec:	000d8513          	mv	a0,s11
40002cf0:	249020ef          	jal	ra,40005738 <__lshift>
40002cf4:	00050493          	mv	s1,a0
40002cf8:	00048b13          	mv	s6,s1
40002cfc:	68091263          	bnez	s2,40003380 <_dtoa_r+0x1240>
40002d00:	02012783          	lw	a5,32(sp)
40002d04:	01812703          	lw	a4,24(sp)
40002d08:	00a00b93          	li	s7,10
40002d0c:	00178413          	addi	s0,a5,1
40002d10:	00e787b3          	add	a5,a5,a4
40002d14:	02f12623          	sw	a5,44(sp)
40002d18:	001a7793          	andi	a5,s4,1
40002d1c:	02f12223          	sw	a5,36(sp)
40002d20:	00098593          	mv	a1,s3
40002d24:	000d0513          	mv	a0,s10
40002d28:	a30ff0ef          	jal	ra,40001f58 <quorem>
40002d2c:	00050c13          	mv	s8,a0
40002d30:	00048593          	mv	a1,s1
40002d34:	000d0513          	mv	a0,s10
40002d38:	349020ef          	jal	ra,40005880 <__mcmp>
40002d3c:	00050913          	mv	s2,a0
40002d40:	000b0613          	mv	a2,s6
40002d44:	00098593          	mv	a1,s3
40002d48:	000d8513          	mv	a0,s11
40002d4c:	38d020ef          	jal	ra,400058d8 <__mdiff>
40002d50:	00c52683          	lw	a3,12(a0)
40002d54:	fff40713          	addi	a4,s0,-1
40002d58:	02e12423          	sw	a4,40(sp)
40002d5c:	00050793          	mv	a5,a0
40002d60:	030c0a93          	addi	s5,s8,48
40002d64:	00100a13          	li	s4,1
40002d68:	00069e63          	bnez	a3,40002d84 <_dtoa_r+0xc44>
40002d6c:	00050593          	mv	a1,a0
40002d70:	00a12c23          	sw	a0,24(sp)
40002d74:	000d0513          	mv	a0,s10
40002d78:	309020ef          	jal	ra,40005880 <__mcmp>
40002d7c:	01812783          	lw	a5,24(sp)
40002d80:	00050a13          	mv	s4,a0
40002d84:	00078593          	mv	a1,a5
40002d88:	000d8513          	mv	a0,s11
40002d8c:	2d8020ef          	jal	ra,40005064 <_Bfree>
40002d90:	019a67b3          	or	a5,s4,s9
40002d94:	00079663          	bnez	a5,40002da0 <_dtoa_r+0xc60>
40002d98:	02412783          	lw	a5,36(sp)
40002d9c:	2c078a63          	beqz	a5,40003070 <_dtoa_r+0xf30>
40002da0:	2e094c63          	bltz	s2,40003098 <_dtoa_r+0xf58>
40002da4:	01996933          	or	s2,s2,s9
40002da8:	00091663          	bnez	s2,40002db4 <_dtoa_r+0xc74>
40002dac:	02412783          	lw	a5,36(sp)
40002db0:	2e078463          	beqz	a5,40003098 <_dtoa_r+0xf58>
40002db4:	77404263          	bgtz	s4,40003518 <_dtoa_r+0x13d8>
40002db8:	02c12783          	lw	a5,44(sp)
40002dbc:	ff540fa3          	sb	s5,-1(s0)
40002dc0:	00040a13          	mv	s4,s0
40002dc4:	76878263          	beq	a5,s0,40003528 <_dtoa_r+0x13e8>
40002dc8:	000d0593          	mv	a1,s10
40002dcc:	00000693          	li	a3,0
40002dd0:	000b8613          	mv	a2,s7
40002dd4:	000d8513          	mv	a0,s11
40002dd8:	2b0020ef          	jal	ra,40005088 <__multadd>
40002ddc:	00050d13          	mv	s10,a0
40002de0:	00000693          	li	a3,0
40002de4:	000b8613          	mv	a2,s7
40002de8:	00048593          	mv	a1,s1
40002dec:	000d8513          	mv	a0,s11
40002df0:	2f648e63          	beq	s1,s6,400030ec <_dtoa_r+0xfac>
40002df4:	294020ef          	jal	ra,40005088 <__multadd>
40002df8:	000b0593          	mv	a1,s6
40002dfc:	00050493          	mv	s1,a0
40002e00:	00000693          	li	a3,0
40002e04:	000b8613          	mv	a2,s7
40002e08:	000d8513          	mv	a0,s11
40002e0c:	27c020ef          	jal	ra,40005088 <__multadd>
40002e10:	00050b13          	mv	s6,a0
40002e14:	00140413          	addi	s0,s0,1
40002e18:	f09ff06f          	j	40002d20 <_dtoa_r+0xbe0>
40002e1c:	01c00793          	li	a5,28
40002e20:	00fc0c33          	add	s8,s8,a5
40002e24:	00fa8ab3          	add	s5,s5,a5
40002e28:	00fb8bb3          	add	s7,s7,a5
40002e2c:	e6dff06f          	j	40002c98 <_dtoa_r+0xb58>
40002e30:	00098593          	mv	a1,s3
40002e34:	000d0513          	mv	a0,s10
40002e38:	249020ef          	jal	ra,40005880 <__mcmp>
40002e3c:	e8055ae3          	bgez	a0,40002cd0 <_dtoa_r+0xb90>
40002e40:	000d0593          	mv	a1,s10
40002e44:	00000693          	li	a3,0
40002e48:	00a00613          	li	a2,10
40002e4c:	000d8513          	mv	a0,s11
40002e50:	238020ef          	jal	ra,40005088 <__multadd>
40002e54:	01012783          	lw	a5,16(sp)
40002e58:	00050d13          	mv	s10,a0
40002e5c:	fff78793          	addi	a5,a5,-1
40002e60:	00f12823          	sw	a5,16(sp)
40002e64:	02412783          	lw	a5,36(sp)
40002e68:	7e079463          	bnez	a5,40003650 <_dtoa_r+0x1510>
40002e6c:	03812783          	lw	a5,56(sp)
40002e70:	00f04863          	bgtz	a5,40002e80 <_dtoa_r+0xd40>
40002e74:	00200793          	li	a5,2
40002e78:	0197cae3          	blt	a5,s9,4000368c <_dtoa_r+0x154c>
40002e7c:	03812783          	lw	a5,56(sp)
40002e80:	00f12c23          	sw	a5,24(sp)
40002e84:	02012b03          	lw	s6,32(sp)
40002e88:	00a00913          	li	s2,10
40002e8c:	01812a03          	lw	s4,24(sp)
40002e90:	000b0413          	mv	s0,s6
40002e94:	00c0006f          	j	40002ea0 <_dtoa_r+0xd60>
40002e98:	1f0020ef          	jal	ra,40005088 <__multadd>
40002e9c:	00050d13          	mv	s10,a0
40002ea0:	00098593          	mv	a1,s3
40002ea4:	000d0513          	mv	a0,s10
40002ea8:	8b0ff0ef          	jal	ra,40001f58 <quorem>
40002eac:	00140413          	addi	s0,s0,1
40002eb0:	03050a93          	addi	s5,a0,48
40002eb4:	ff540fa3          	sb	s5,-1(s0)
40002eb8:	416407b3          	sub	a5,s0,s6
40002ebc:	00000693          	li	a3,0
40002ec0:	00090613          	mv	a2,s2
40002ec4:	000d0593          	mv	a1,s10
40002ec8:	000d8513          	mv	a0,s11
40002ecc:	fd47c6e3          	blt	a5,s4,40002e98 <_dtoa_r+0xd58>
40002ed0:	01812783          	lw	a5,24(sp)
40002ed4:	66f05663          	blez	a5,40003540 <_dtoa_r+0x1400>
40002ed8:	02012703          	lw	a4,32(sp)
40002edc:	00000413          	li	s0,0
40002ee0:	00f70a33          	add	s4,a4,a5
40002ee4:	000d0593          	mv	a1,s10
40002ee8:	00100613          	li	a2,1
40002eec:	000d8513          	mv	a0,s11
40002ef0:	049020ef          	jal	ra,40005738 <__lshift>
40002ef4:	00098593          	mv	a1,s3
40002ef8:	00050d13          	mv	s10,a0
40002efc:	185020ef          	jal	ra,40005880 <__mcmp>
40002f00:	12a05663          	blez	a0,4000302c <_dtoa_r+0xeec>
40002f04:	fffa4683          	lbu	a3,-1(s4)
40002f08:	03900613          	li	a2,57
40002f0c:	02012783          	lw	a5,32(sp)
40002f10:	0100006f          	j	40002f20 <_dtoa_r+0xde0>
40002f14:	28f70263          	beq	a4,a5,40003198 <_dtoa_r+0x1058>
40002f18:	fff74683          	lbu	a3,-1(a4)
40002f1c:	00070a13          	mv	s4,a4
40002f20:	fffa0713          	addi	a4,s4,-1
40002f24:	fec688e3          	beq	a3,a2,40002f14 <_dtoa_r+0xdd4>
40002f28:	00168693          	addi	a3,a3,1
40002f2c:	00d70023          	sb	a3,0(a4)
40002f30:	00098593          	mv	a1,s3
40002f34:	000d8513          	mv	a0,s11
40002f38:	12c020ef          	jal	ra,40005064 <_Bfree>
40002f3c:	8e0486e3          	beqz	s1,40002828 <_dtoa_r+0x6e8>
40002f40:	00040a63          	beqz	s0,40002f54 <_dtoa_r+0xe14>
40002f44:	00940863          	beq	s0,s1,40002f54 <_dtoa_r+0xe14>
40002f48:	00040593          	mv	a1,s0
40002f4c:	000d8513          	mv	a0,s11
40002f50:	114020ef          	jal	ra,40005064 <_Bfree>
40002f54:	00048593          	mv	a1,s1
40002f58:	000d8513          	mv	a0,s11
40002f5c:	108020ef          	jal	ra,40005064 <_Bfree>
40002f60:	8c9ff06f          	j	40002828 <_dtoa_r+0x6e8>
40002f64:	000b8793          	mv	a5,s7
40002f68:	bb5ff06f          	j	40002b1c <_dtoa_r+0x9dc>
40002f6c:	c40a12e3          	bnez	s4,40002bb0 <_dtoa_r+0xa70>
40002f70:	00c41793          	slli	a5,s0,0xc
40002f74:	00000913          	li	s2,0
40002f78:	ce0792e3          	bnez	a5,40002c5c <_dtoa_r+0xb1c>
40002f7c:	7ff007b7          	lui	a5,0x7ff00
40002f80:	00f47433          	and	s0,s0,a5
40002f84:	cc040ce3          	beqz	s0,40002c5c <_dtoa_r+0xb1c>
40002f88:	001c0c13          	addi	s8,s8,1
40002f8c:	001b8b93          	addi	s7,s7,1 # fe100001 <_bss_end+0xbe0f3979>
40002f90:	00100913          	li	s2,1
40002f94:	cc9ff06f          	j	40002c5c <_dtoa_r+0xb1c>
40002f98:	00100793          	li	a5,1
40002f9c:	02f12223          	sw	a5,36(sp)
40002fa0:	2d605663          	blez	s6,4000326c <_dtoa_r+0x112c>
40002fa4:	000b0613          	mv	a2,s6
40002fa8:	000b0813          	mv	a6,s6
40002fac:	03612c23          	sw	s6,56(sp)
40002fb0:	01612c23          	sw	s6,24(sp)
40002fb4:	cccff06f          	j	40002480 <_dtoa_r+0x340>
40002fb8:	01812783          	lw	a5,24(sp)
40002fbc:	94f04ee3          	bgtz	a5,40002918 <_dtoa_r+0x7d8>
40002fc0:	26079e63          	bnez	a5,4000323c <_dtoa_r+0x10fc>
40002fc4:	4000c7b7          	lui	a5,0x4000c
40002fc8:	c787a603          	lw	a2,-904(a5) # 4000bc78 <__clz_tab+0x144>
40002fcc:	c7c7a683          	lw	a3,-900(a5)
40002fd0:	000c0513          	mv	a0,s8
40002fd4:	000c8593          	mv	a1,s9
40002fd8:	6e1060ef          	jal	ra,40009eb8 <__muldf3>
40002fdc:	000a0613          	mv	a2,s4
40002fe0:	00040693          	mv	a3,s0
40002fe4:	4cd060ef          	jal	ra,40009cb0 <__gedf2>
40002fe8:	00000993          	li	s3,0
40002fec:	00000493          	li	s1,0
40002ff0:	18054463          	bltz	a0,40003178 <_dtoa_r+0x1038>
40002ff4:	02012a03          	lw	s4,32(sp)
40002ff8:	fffb4793          	not	a5,s6
40002ffc:	00f12823          	sw	a5,16(sp)
40003000:	00098593          	mv	a1,s3
40003004:	000d8513          	mv	a0,s11
40003008:	05c020ef          	jal	ra,40005064 <_Bfree>
4000300c:	80048ee3          	beqz	s1,40002828 <_dtoa_r+0x6e8>
40003010:	f45ff06f          	j	40002f54 <_dtoa_r+0xe14>
40003014:	00098613          	mv	a2,s3
40003018:	000d0593          	mv	a1,s10
4000301c:	000d8513          	mv	a0,s11
40003020:	5d0020ef          	jal	ra,400055f0 <__pow5mult>
40003024:	00050d13          	mv	s10,a0
40003028:	b55ff06f          	j	40002b7c <_dtoa_r+0xa3c>
4000302c:	00051663          	bnez	a0,40003038 <_dtoa_r+0xef8>
40003030:	001afa93          	andi	s5,s5,1
40003034:	ec0a98e3          	bnez	s5,40002f04 <_dtoa_r+0xdc4>
40003038:	03000613          	li	a2,48
4000303c:	0080006f          	j	40003044 <_dtoa_r+0xf04>
40003040:	00070a13          	mv	s4,a4
40003044:	fffa4783          	lbu	a5,-1(s4)
40003048:	fffa0713          	addi	a4,s4,-1
4000304c:	fec78ae3          	beq	a5,a2,40003040 <_dtoa_r+0xf00>
40003050:	ee1ff06f          	j	40002f30 <_dtoa_r+0xdf0>
40003054:	4e0a8a63          	beqz	s5,40003548 <_dtoa_r+0x1408>
40003058:	43378793          	addi	a5,a5,1075
4000305c:	00098913          	mv	s2,s3
40003060:	000c0a93          	mv	s5,s8
40003064:	a91ff06f          	j	40002af4 <_dtoa_r+0x9b4>
40003068:	00100613          	li	a2,1
4000306c:	c10ff06f          	j	4000247c <_dtoa_r+0x33c>
40003070:	03900793          	li	a5,57
40003074:	04fa8863          	beq	s5,a5,400030c4 <_dtoa_r+0xf84>
40003078:	01205463          	blez	s2,40003080 <_dtoa_r+0xf40>
4000307c:	031c0a93          	addi	s5,s8,49
40003080:	02812783          	lw	a5,40(sp)
40003084:	00048413          	mv	s0,s1
40003088:	000b0493          	mv	s1,s6
4000308c:	00178a13          	addi	s4,a5,1
40003090:	01578023          	sb	s5,0(a5)
40003094:	e9dff06f          	j	40002f30 <_dtoa_r+0xdf0>
40003098:	ff4054e3          	blez	s4,40003080 <_dtoa_r+0xf40>
4000309c:	000d0593          	mv	a1,s10
400030a0:	00100613          	li	a2,1
400030a4:	000d8513          	mv	a0,s11
400030a8:	690020ef          	jal	ra,40005738 <__lshift>
400030ac:	00098593          	mv	a1,s3
400030b0:	00050d13          	mv	s10,a0
400030b4:	7cc020ef          	jal	ra,40005880 <__mcmp>
400030b8:	58a05463          	blez	a0,40003640 <_dtoa_r+0x1500>
400030bc:	03900793          	li	a5,57
400030c0:	fafa9ee3          	bne	s5,a5,4000307c <_dtoa_r+0xf3c>
400030c4:	02812783          	lw	a5,40(sp)
400030c8:	03900713          	li	a4,57
400030cc:	00048413          	mv	s0,s1
400030d0:	00178a13          	addi	s4,a5,1
400030d4:	00e78023          	sb	a4,0(a5)
400030d8:	000b0493          	mv	s1,s6
400030dc:	03900693          	li	a3,57
400030e0:	e29ff06f          	j	40002f08 <_dtoa_r+0xdc8>
400030e4:	b60a1ce3          	bnez	s4,40002c5c <_dtoa_r+0xb1c>
400030e8:	e89ff06f          	j	40002f70 <_dtoa_r+0xe30>
400030ec:	79d010ef          	jal	ra,40005088 <__multadd>
400030f0:	00050493          	mv	s1,a0
400030f4:	00050b13          	mv	s6,a0
400030f8:	00140413          	addi	s0,s0,1
400030fc:	c25ff06f          	j	40002d20 <_dtoa_r+0xbe0>
40003100:	00200793          	li	a5,2
40003104:	02012223          	sw	zero,36(sp)
40003108:	e8fc8ce3          	beq	s9,a5,40002fa0 <_dtoa_r+0xe60>
4000310c:	040da223          	sw	zero,68(s11)
40003110:	00000593          	li	a1,0
40003114:	000d8513          	mv	a0,s11
40003118:	6a9010ef          	jal	ra,40004fc0 <_Balloc>
4000311c:	fff00793          	li	a5,-1
40003120:	02f12c23          	sw	a5,56(sp)
40003124:	00f12c23          	sw	a5,24(sp)
40003128:	00100793          	li	a5,1
4000312c:	02a12023          	sw	a0,32(sp)
40003130:	04ada023          	sw	a0,64(s11)
40003134:	00000b13          	li	s6,0
40003138:	02f12223          	sw	a5,36(sp)
4000313c:	facff06f          	j	400028e8 <_dtoa_r+0x7a8>
40003140:	00200793          	li	a5,2
40003144:	b997dae3          	ble	s9,a5,40002cd8 <_dtoa_r+0xb98>
40003148:	01812783          	lw	a5,24(sp)
4000314c:	ea0794e3          	bnez	a5,40002ff4 <_dtoa_r+0xeb4>
40003150:	00098593          	mv	a1,s3
40003154:	00000693          	li	a3,0
40003158:	00500613          	li	a2,5
4000315c:	000d8513          	mv	a0,s11
40003160:	729010ef          	jal	ra,40005088 <__multadd>
40003164:	00050993          	mv	s3,a0
40003168:	00050593          	mv	a1,a0
4000316c:	000d0513          	mv	a0,s10
40003170:	710020ef          	jal	ra,40005880 <__mcmp>
40003174:	e8a050e3          	blez	a0,40002ff4 <_dtoa_r+0xeb4>
40003178:	02012783          	lw	a5,32(sp)
4000317c:	03100713          	li	a4,49
40003180:	00178a13          	addi	s4,a5,1
40003184:	00e78023          	sb	a4,0(a5)
40003188:	01012783          	lw	a5,16(sp)
4000318c:	00178793          	addi	a5,a5,1
40003190:	00f12823          	sw	a5,16(sp)
40003194:	e6dff06f          	j	40003000 <_dtoa_r+0xec0>
40003198:	01012783          	lw	a5,16(sp)
4000319c:	03100713          	li	a4,49
400031a0:	00178793          	addi	a5,a5,1
400031a4:	00f12823          	sw	a5,16(sp)
400031a8:	02012783          	lw	a5,32(sp)
400031ac:	00e78023          	sb	a4,0(a5)
400031b0:	d81ff06f          	j	40002f30 <_dtoa_r+0xdf0>
400031b4:	02012223          	sw	zero,36(sp)
400031b8:	aa8ff06f          	j	40002460 <_dtoa_r+0x320>
400031bc:	00090513          	mv	a0,s2
400031c0:	621070ef          	jal	ra,4000afe0 <__floatsidf>
400031c4:	03012603          	lw	a2,48(sp)
400031c8:	03412683          	lw	a3,52(sp)
400031cc:	fcc004b7          	lui	s1,0xfcc00
400031d0:	4e9060ef          	jal	ra,40009eb8 <__muldf3>
400031d4:	4000c7b7          	lui	a5,0x4000c
400031d8:	c707a603          	lw	a2,-912(a5) # 4000bc70 <__clz_tab+0x13c>
400031dc:	c747a683          	lw	a3,-908(a5)
400031e0:	0bd050ef          	jal	ra,40008a9c <__adddf3>
400031e4:	00050413          	mv	s0,a0
400031e8:	00b484b3          	add	s1,s1,a1
400031ec:	4000c7b7          	lui	a5,0x4000c
400031f0:	c787a603          	lw	a2,-904(a5) # 4000bc78 <__clz_tab+0x144>
400031f4:	c7c7a683          	lw	a3,-900(a5)
400031f8:	03012503          	lw	a0,48(sp)
400031fc:	03412583          	lw	a1,52(sp)
40003200:	388070ef          	jal	ra,4000a588 <__subdf3>
40003204:	00040613          	mv	a2,s0
40003208:	00048693          	mv	a3,s1
4000320c:	02a12823          	sw	a0,48(sp)
40003210:	02b12a23          	sw	a1,52(sp)
40003214:	29d060ef          	jal	ra,40009cb0 <__gedf2>
40003218:	2ea04a63          	bgtz	a0,4000350c <_dtoa_r+0x13cc>
4000321c:	800007b7          	lui	a5,0x80000
40003220:	03012503          	lw	a0,48(sp)
40003224:	03412583          	lw	a1,52(sp)
40003228:	00f4c4b3          	xor	s1,s1,a5
4000322c:	00040613          	mv	a2,s0
40003230:	00048693          	mv	a3,s1
40003234:	381060ef          	jal	ra,40009db4 <__ledf2>
40003238:	06055e63          	bgez	a0,400032b4 <_dtoa_r+0x1174>
4000323c:	00000993          	li	s3,0
40003240:	00000493          	li	s1,0
40003244:	db1ff06f          	j	40002ff4 <_dtoa_r+0xeb4>
40003248:	02012503          	lw	a0,32(sp)
4000324c:	fd5fe06f          	j	40002220 <_dtoa_r+0xe0>
40003250:	02c12783          	lw	a5,44(sp)
40003254:	413909b3          	sub	s3,s2,s3
40003258:	013787b3          	add	a5,a5,s3
4000325c:	02f12623          	sw	a5,44(sp)
40003260:	00090993          	mv	s3,s2
40003264:	00000913          	li	s2,0
40003268:	87dff06f          	j	40002ae4 <_dtoa_r+0x9a4>
4000326c:	040da223          	sw	zero,68(s11)
40003270:	00000593          	li	a1,0
40003274:	000d8513          	mv	a0,s11
40003278:	549010ef          	jal	ra,40004fc0 <_Balloc>
4000327c:	00100b13          	li	s6,1
40003280:	02a12023          	sw	a0,32(sp)
40003284:	04ada023          	sw	a0,64(s11)
40003288:	03612c23          	sw	s6,56(sp)
4000328c:	01612c23          	sw	s6,24(sp)
40003290:	a40ff06f          	j	400024d0 <_dtoa_r+0x390>
40003294:	000b0d93          	mv	s11,s6
40003298:	05c12c03          	lw	s8,92(sp)
4000329c:	06012983          	lw	s3,96(sp)
400032a0:	06412b83          	lw	s7,100(sp)
400032a4:	06812a83          	lw	s5,104(sp)
400032a8:	05812d03          	lw	s10,88(sp)
400032ac:	06c12c83          	lw	s9,108(sp)
400032b0:	04012b03          	lw	s6,64(sp)
400032b4:	03c12a03          	lw	s4,60(sp)
400032b8:	04812403          	lw	s0,72(sp)
400032bc:	e2cff06f          	j	400028e8 <_dtoa_r+0x7a8>
400032c0:	01012783          	lw	a5,16(sp)
400032c4:	02912823          	sw	s1,48(sp)
400032c8:	02812a23          	sw	s0,52(sp)
400032cc:	00200913          	li	s2,2
400032d0:	ac078e63          	beqz	a5,400025ac <_dtoa_r+0x46c>
400032d4:	40f007b3          	neg	a5,a5
400032d8:	00f7f713          	andi	a4,a5,15
400032dc:	4000c6b7          	lui	a3,0x4000c
400032e0:	81868693          	addi	a3,a3,-2024 # 4000b818 <__mprec_tens>
400032e4:	00371713          	slli	a4,a4,0x3
400032e8:	00d70733          	add	a4,a4,a3
400032ec:	00072603          	lw	a2,0(a4)
400032f0:	00472683          	lw	a3,4(a4)
400032f4:	00040593          	mv	a1,s0
400032f8:	00048513          	mv	a0,s1
400032fc:	4047d413          	srai	s0,a5,0x4
40003300:	3b9060ef          	jal	ra,40009eb8 <__muldf3>
40003304:	02a12823          	sw	a0,48(sp)
40003308:	02b12a23          	sw	a1,52(sp)
4000330c:	aa040063          	beqz	s0,400025ac <_dtoa_r+0x46c>
40003310:	4000c4b7          	lui	s1,0x4000c
40003314:	90848493          	addi	s1,s1,-1784 # 4000b908 <__mprec_bigtens>
40003318:	00050613          	mv	a2,a0
4000331c:	00058693          	mv	a3,a1
40003320:	00147793          	andi	a5,s0,1
40003324:	00060513          	mv	a0,a2
40003328:	40145413          	srai	s0,s0,0x1
4000332c:	00068593          	mv	a1,a3
40003330:	00078e63          	beqz	a5,4000334c <_dtoa_r+0x120c>
40003334:	0004a603          	lw	a2,0(s1)
40003338:	0044a683          	lw	a3,4(s1)
4000333c:	00190913          	addi	s2,s2,1
40003340:	379060ef          	jal	ra,40009eb8 <__muldf3>
40003344:	00050613          	mv	a2,a0
40003348:	00058693          	mv	a3,a1
4000334c:	00848493          	addi	s1,s1,8
40003350:	fc0418e3          	bnez	s0,40003320 <_dtoa_r+0x11e0>
40003354:	02c12823          	sw	a2,48(sp)
40003358:	02d12a23          	sw	a3,52(sp)
4000335c:	a50ff06f          	j	400025ac <_dtoa_r+0x46c>
40003360:	02012783          	lw	a5,32(sp)
40003364:	03000713          	li	a4,48
40003368:	00e78023          	sb	a4,0(a5) # 80000000 <_bss_end+0x3fff3978>
4000336c:	01012783          	lw	a5,16(sp)
40003370:	fffa4403          	lbu	s0,-1(s4)
40003374:	00178793          	addi	a5,a5,1
40003378:	00f12823          	sw	a5,16(sp)
4000337c:	f3cff06f          	j	40002ab8 <_dtoa_r+0x978>
40003380:	0044a583          	lw	a1,4(s1)
40003384:	000d8513          	mv	a0,s11
40003388:	439010ef          	jal	ra,40004fc0 <_Balloc>
4000338c:	0104a603          	lw	a2,16(s1)
40003390:	00050413          	mv	s0,a0
40003394:	00c48593          	addi	a1,s1,12
40003398:	00260613          	addi	a2,a2,2
4000339c:	00261613          	slli	a2,a2,0x2
400033a0:	00c50513          	addi	a0,a0,12
400033a4:	21d010ef          	jal	ra,40004dc0 <memcpy>
400033a8:	00100613          	li	a2,1
400033ac:	00040593          	mv	a1,s0
400033b0:	000d8513          	mv	a0,s11
400033b4:	384020ef          	jal	ra,40005738 <__lshift>
400033b8:	00050b13          	mv	s6,a0
400033bc:	945ff06f          	j	40002d00 <_dtoa_r+0xbc0>
400033c0:	fff90793          	addi	a5,s2,-1
400033c4:	4000c737          	lui	a4,0x4000c
400033c8:	81870713          	addi	a4,a4,-2024 # 4000b818 <__mprec_tens>
400033cc:	00379793          	slli	a5,a5,0x3
400033d0:	00e787b3          	add	a5,a5,a4
400033d4:	0007a503          	lw	a0,0(a5)
400033d8:	0047a583          	lw	a1,4(a5)
400033dc:	00040613          	mv	a2,s0
400033e0:	00048693          	mv	a3,s1
400033e4:	2d5060ef          	jal	ra,40009eb8 <__muldf3>
400033e8:	04a12023          	sw	a0,64(sp)
400033ec:	04b12223          	sw	a1,68(sp)
400033f0:	03012503          	lw	a0,48(sp)
400033f4:	03412583          	lw	a1,52(sp)
400033f8:	4000c4b7          	lui	s1,0x4000c
400033fc:	361070ef          	jal	ra,4000af5c <__fixdfsi>
40003400:	00050413          	mv	s0,a0
40003404:	3dd070ef          	jal	ra,4000afe0 <__floatsidf>
40003408:	00050613          	mv	a2,a0
4000340c:	00058693          	mv	a3,a1
40003410:	03012503          	lw	a0,48(sp)
40003414:	03412583          	lw	a1,52(sp)
40003418:	03040413          	addi	s0,s0,48
4000341c:	16c070ef          	jal	ra,4000a588 <__subdf3>
40003420:	02012783          	lw	a5,32(sp)
40003424:	00100713          	li	a4,1
40003428:	00050813          	mv	a6,a0
4000342c:	00878023          	sb	s0,0(a5)
40003430:	00058893          	mv	a7,a1
40003434:	00e78a33          	add	s4,a5,a4
40003438:	01278433          	add	s0,a5,s2
4000343c:	08e90063          	beq	s2,a4,400034bc <_dtoa_r+0x137c>
40003440:	c684a703          	lw	a4,-920(s1) # 4000bc68 <__clz_tab+0x134>
40003444:	c6c4a783          	lw	a5,-916(s1)
40003448:	05612823          	sw	s6,80(sp)
4000344c:	02e12823          	sw	a4,48(sp)
40003450:	000a8b13          	mv	s6,s5
40003454:	02f12a23          	sw	a5,52(sp)
40003458:	00098a93          	mv	s5,s3
4000345c:	03012603          	lw	a2,48(sp)
40003460:	03412683          	lw	a3,52(sp)
40003464:	00080513          	mv	a0,a6
40003468:	00088593          	mv	a1,a7
4000346c:	24d060ef          	jal	ra,40009eb8 <__muldf3>
40003470:	00058993          	mv	s3,a1
40003474:	00050913          	mv	s2,a0
40003478:	2e5070ef          	jal	ra,4000af5c <__fixdfsi>
4000347c:	00050493          	mv	s1,a0
40003480:	361070ef          	jal	ra,4000afe0 <__floatsidf>
40003484:	00050613          	mv	a2,a0
40003488:	00058693          	mv	a3,a1
4000348c:	00090513          	mv	a0,s2
40003490:	00098593          	mv	a1,s3
40003494:	001a0a13          	addi	s4,s4,1
40003498:	03048493          	addi	s1,s1,48
4000349c:	0ec070ef          	jal	ra,4000a588 <__subdf3>
400034a0:	fe9a0fa3          	sb	s1,-1(s4)
400034a4:	00050813          	mv	a6,a0
400034a8:	00058893          	mv	a7,a1
400034ac:	fa8a18e3          	bne	s4,s0,4000345c <_dtoa_r+0x131c>
400034b0:	000a8993          	mv	s3,s5
400034b4:	000b0a93          	mv	s5,s6
400034b8:	05012b03          	lw	s6,80(sp)
400034bc:	4000c437          	lui	s0,0x4000c
400034c0:	c8042603          	lw	a2,-896(s0) # 4000bc80 <__clz_tab+0x14c>
400034c4:	c8442683          	lw	a3,-892(s0)
400034c8:	04012503          	lw	a0,64(sp)
400034cc:	04412583          	lw	a1,68(sp)
400034d0:	03012823          	sw	a6,48(sp)
400034d4:	03112a23          	sw	a7,52(sp)
400034d8:	5c4050ef          	jal	ra,40008a9c <__adddf3>
400034dc:	03012803          	lw	a6,48(sp)
400034e0:	03412883          	lw	a7,52(sp)
400034e4:	00080613          	mv	a2,a6
400034e8:	00088693          	mv	a3,a7
400034ec:	0c9060ef          	jal	ra,40009db4 <__ledf2>
400034f0:	03012803          	lw	a6,48(sp)
400034f4:	03412883          	lw	a7,52(sp)
400034f8:	0e055263          	bgez	a0,400035dc <_dtoa_r+0x149c>
400034fc:	04c12783          	lw	a5,76(sp)
40003500:	fffa4403          	lbu	s0,-1(s4)
40003504:	00f12823          	sw	a5,16(sp)
40003508:	d90ff06f          	j	40002a98 <_dtoa_r+0x958>
4000350c:	00000993          	li	s3,0
40003510:	00000493          	li	s1,0
40003514:	c65ff06f          	j	40003178 <_dtoa_r+0x1038>
40003518:	03900793          	li	a5,57
4000351c:	bafa84e3          	beq	s5,a5,400030c4 <_dtoa_r+0xf84>
40003520:	001a8a93          	addi	s5,s5,1
40003524:	b5dff06f          	j	40003080 <_dtoa_r+0xf40>
40003528:	00048413          	mv	s0,s1
4000352c:	000b0493          	mv	s1,s6
40003530:	9b5ff06f          	j	40002ee4 <_dtoa_r+0xda4>
40003534:	40ec0ab3          	sub	s5,s8,a4
40003538:	00000793          	li	a5,0
4000353c:	db8ff06f          	j	40002af4 <_dtoa_r+0x9b4>
40003540:	00100793          	li	a5,1
40003544:	995ff06f          	j	40002ed8 <_dtoa_r+0xd98>
40003548:	07812703          	lw	a4,120(sp)
4000354c:	03600793          	li	a5,54
40003550:	00098913          	mv	s2,s3
40003554:	40e787b3          	sub	a5,a5,a4
40003558:	000c0a93          	mv	s5,s8
4000355c:	d98ff06f          	j	40002af4 <_dtoa_r+0x9b4>
40003560:	01812783          	lw	a5,24(sp)
40003564:	c4078ce3          	beqz	a5,400031bc <_dtoa_r+0x107c>
40003568:	03812a03          	lw	s4,56(sp)
4000356c:	d54054e3          	blez	s4,400032b4 <_dtoa_r+0x1174>
40003570:	4000c4b7          	lui	s1,0x4000c
40003574:	01012783          	lw	a5,16(sp)
40003578:	c684a603          	lw	a2,-920(s1) # 4000bc68 <__clz_tab+0x134>
4000357c:	c6c4a683          	lw	a3,-916(s1)
40003580:	03012503          	lw	a0,48(sp)
40003584:	03412583          	lw	a1,52(sp)
40003588:	fff78793          	addi	a5,a5,-1
4000358c:	04f12623          	sw	a5,76(sp)
40003590:	129060ef          	jal	ra,40009eb8 <__muldf3>
40003594:	00050413          	mv	s0,a0
40003598:	02a12823          	sw	a0,48(sp)
4000359c:	00190513          	addi	a0,s2,1
400035a0:	00058493          	mv	s1,a1
400035a4:	02b12a23          	sw	a1,52(sp)
400035a8:	239070ef          	jal	ra,4000afe0 <__floatsidf>
400035ac:	00040613          	mv	a2,s0
400035b0:	00048693          	mv	a3,s1
400035b4:	105060ef          	jal	ra,40009eb8 <__muldf3>
400035b8:	4000c7b7          	lui	a5,0x4000c
400035bc:	c707a603          	lw	a2,-912(a5) # 4000bc70 <__clz_tab+0x13c>
400035c0:	c747a683          	lw	a3,-908(a5)
400035c4:	fcc004b7          	lui	s1,0xfcc00
400035c8:	000a0913          	mv	s2,s4
400035cc:	4d0050ef          	jal	ra,40008a9c <__adddf3>
400035d0:	00050413          	mv	s0,a0
400035d4:	00b484b3          	add	s1,s1,a1
400035d8:	840ff06f          	j	40002618 <_dtoa_r+0x4d8>
400035dc:	04012603          	lw	a2,64(sp)
400035e0:	04412683          	lw	a3,68(sp)
400035e4:	c8042503          	lw	a0,-896(s0)
400035e8:	c8442583          	lw	a1,-892(s0)
400035ec:	03012823          	sw	a6,48(sp)
400035f0:	03112a23          	sw	a7,52(sp)
400035f4:	795060ef          	jal	ra,4000a588 <__subdf3>
400035f8:	03012803          	lw	a6,48(sp)
400035fc:	03412883          	lw	a7,52(sp)
40003600:	00080613          	mv	a2,a6
40003604:	00088693          	mv	a3,a7
40003608:	6a8060ef          	jal	ra,40009cb0 <__gedf2>
4000360c:	03000613          	li	a2,48
40003610:	00a04663          	bgtz	a0,4000361c <_dtoa_r+0x14dc>
40003614:	ca1ff06f          	j	400032b4 <_dtoa_r+0x1174>
40003618:	00070a13          	mv	s4,a4
4000361c:	fffa4783          	lbu	a5,-1(s4)
40003620:	fffa0713          	addi	a4,s4,-1
40003624:	fec78ae3          	beq	a5,a2,40003618 <_dtoa_r+0x14d8>
40003628:	9f8ff06f          	j	40002820 <_dtoa_r+0x6e0>
4000362c:	05812d03          	lw	s10,88(sp)
40003630:	000b0d93          	mv	s11,s6
40003634:	04c12783          	lw	a5,76(sp)
40003638:	00f12823          	sw	a5,16(sp)
4000363c:	c5cff06f          	j	40002a98 <_dtoa_r+0x958>
40003640:	a40510e3          	bnez	a0,40003080 <_dtoa_r+0xf40>
40003644:	001af793          	andi	a5,s5,1
40003648:	a2078ce3          	beqz	a5,40003080 <_dtoa_r+0xf40>
4000364c:	a71ff06f          	j	400030bc <_dtoa_r+0xf7c>
40003650:	00048593          	mv	a1,s1
40003654:	00000693          	li	a3,0
40003658:	00a00613          	li	a2,10
4000365c:	000d8513          	mv	a0,s11
40003660:	229010ef          	jal	ra,40005088 <__multadd>
40003664:	03812783          	lw	a5,56(sp)
40003668:	00050493          	mv	s1,a0
4000366c:	00f05663          	blez	a5,40003678 <_dtoa_r+0x1538>
40003670:	00f12c23          	sw	a5,24(sp)
40003674:	e6cff06f          	j	40002ce0 <_dtoa_r+0xba0>
40003678:	00200793          	li	a5,2
4000367c:	0197c863          	blt	a5,s9,4000368c <_dtoa_r+0x154c>
40003680:	03812783          	lw	a5,56(sp)
40003684:	00f12c23          	sw	a5,24(sp)
40003688:	e58ff06f          	j	40002ce0 <_dtoa_r+0xba0>
4000368c:	03812783          	lw	a5,56(sp)
40003690:	00f12c23          	sw	a5,24(sp)
40003694:	ab5ff06f          	j	40003148 <_dtoa_r+0x1008>
40003698:	e0d70063          	beq	a4,a3,40002c98 <_dtoa_r+0xb58>
4000369c:	03c00713          	li	a4,60
400036a0:	40f707b3          	sub	a5,a4,a5
400036a4:	f7cff06f          	j	40002e20 <_dtoa_r+0xce0>

400036a8 <__sflush_r>:
400036a8:	00c59783          	lh	a5,12(a1)
400036ac:	fe010113          	addi	sp,sp,-32
400036b0:	00912a23          	sw	s1,20(sp)
400036b4:	01079713          	slli	a4,a5,0x10
400036b8:	01075713          	srli	a4,a4,0x10
400036bc:	01312623          	sw	s3,12(sp)
400036c0:	00112e23          	sw	ra,28(sp)
400036c4:	00812c23          	sw	s0,24(sp)
400036c8:	01212823          	sw	s2,16(sp)
400036cc:	00877693          	andi	a3,a4,8
400036d0:	00058493          	mv	s1,a1
400036d4:	00050993          	mv	s3,a0
400036d8:	10069a63          	bnez	a3,400037ec <__sflush_r+0x144>
400036dc:	00001737          	lui	a4,0x1
400036e0:	80070713          	addi	a4,a4,-2048 # 800 <_stack_size>
400036e4:	0045a683          	lw	a3,4(a1)
400036e8:	00e7e7b3          	or	a5,a5,a4
400036ec:	00f59623          	sh	a5,12(a1)
400036f0:	1ed05263          	blez	a3,400038d4 <__sflush_r+0x22c>
400036f4:	0284a803          	lw	a6,40(s1) # fcc00028 <_bss_end+0xbcbf39a0>
400036f8:	0c080a63          	beqz	a6,400037cc <__sflush_r+0x124>
400036fc:	01079793          	slli	a5,a5,0x10
40003700:	0107d793          	srli	a5,a5,0x10
40003704:	0009a403          	lw	s0,0(s3)
40003708:	01379713          	slli	a4,a5,0x13
4000370c:	0009a023          	sw	zero,0(s3)
40003710:	1c075863          	bgez	a4,400038e0 <__sflush_r+0x238>
40003714:	0504a603          	lw	a2,80(s1)
40003718:	41f65693          	srai	a3,a2,0x1f
4000371c:	0047f793          	andi	a5,a5,4
40003720:	04078263          	beqz	a5,40003764 <__sflush_r+0xbc>
40003724:	0044a783          	lw	a5,4(s1)
40003728:	0304a583          	lw	a1,48(s1)
4000372c:	40f60733          	sub	a4,a2,a5
40003730:	41f7d793          	srai	a5,a5,0x1f
40003734:	00e63533          	sltu	a0,a2,a4
40003738:	40f686b3          	sub	a3,a3,a5
4000373c:	00070613          	mv	a2,a4
40003740:	40a686b3          	sub	a3,a3,a0
40003744:	02058063          	beqz	a1,40003764 <__sflush_r+0xbc>
40003748:	03c4a783          	lw	a5,60(s1)
4000374c:	40f70733          	sub	a4,a4,a5
40003750:	41f7d793          	srai	a5,a5,0x1f
40003754:	00e635b3          	sltu	a1,a2,a4
40003758:	40f686b3          	sub	a3,a3,a5
4000375c:	00070613          	mv	a2,a4
40003760:	40b686b3          	sub	a3,a3,a1
40003764:	01c4a583          	lw	a1,28(s1)
40003768:	00000713          	li	a4,0
4000376c:	00098513          	mv	a0,s3
40003770:	000800e7          	jalr	a6
40003774:	fff00793          	li	a5,-1
40003778:	0ef50c63          	beq	a0,a5,40003870 <__sflush_r+0x1c8>
4000377c:	00c4d783          	lhu	a5,12(s1)
40003780:	fffff737          	lui	a4,0xfffff
40003784:	7ff70713          	addi	a4,a4,2047 # fffff7ff <_bss_end+0xbfff3177>
40003788:	00e7f7b3          	and	a5,a5,a4
4000378c:	0104a683          	lw	a3,16(s1)
40003790:	01079793          	slli	a5,a5,0x10
40003794:	4107d793          	srai	a5,a5,0x10
40003798:	00f49623          	sh	a5,12(s1)
4000379c:	0004a223          	sw	zero,4(s1)
400037a0:	00d4a023          	sw	a3,0(s1)
400037a4:	01379713          	slli	a4,a5,0x13
400037a8:	12074263          	bltz	a4,400038cc <__sflush_r+0x224>
400037ac:	0304a583          	lw	a1,48(s1)
400037b0:	0089a023          	sw	s0,0(s3)
400037b4:	00058c63          	beqz	a1,400037cc <__sflush_r+0x124>
400037b8:	04048793          	addi	a5,s1,64
400037bc:	00f58663          	beq	a1,a5,400037c8 <__sflush_r+0x120>
400037c0:	00098513          	mv	a0,s3
400037c4:	6c0000ef          	jal	ra,40003e84 <_free_r>
400037c8:	0204a823          	sw	zero,48(s1)
400037cc:	00000513          	li	a0,0
400037d0:	01c12083          	lw	ra,28(sp)
400037d4:	01812403          	lw	s0,24(sp)
400037d8:	01412483          	lw	s1,20(sp)
400037dc:	01012903          	lw	s2,16(sp)
400037e0:	00c12983          	lw	s3,12(sp)
400037e4:	02010113          	addi	sp,sp,32
400037e8:	00008067          	ret
400037ec:	0105a903          	lw	s2,16(a1)
400037f0:	fc090ee3          	beqz	s2,400037cc <__sflush_r+0x124>
400037f4:	0005a403          	lw	s0,0(a1)
400037f8:	00377713          	andi	a4,a4,3
400037fc:	0125a023          	sw	s2,0(a1)
40003800:	41240433          	sub	s0,s0,s2
40003804:	00000793          	li	a5,0
40003808:	00071463          	bnez	a4,40003810 <__sflush_r+0x168>
4000380c:	0145a783          	lw	a5,20(a1)
40003810:	00f4a423          	sw	a5,8(s1)
40003814:	00804863          	bgtz	s0,40003824 <__sflush_r+0x17c>
40003818:	fb5ff06f          	j	400037cc <__sflush_r+0x124>
4000381c:	00a90933          	add	s2,s2,a0
40003820:	fa8056e3          	blez	s0,400037cc <__sflush_r+0x124>
40003824:	0244a783          	lw	a5,36(s1)
40003828:	01c4a583          	lw	a1,28(s1)
4000382c:	00040693          	mv	a3,s0
40003830:	00090613          	mv	a2,s2
40003834:	00098513          	mv	a0,s3
40003838:	000780e7          	jalr	a5
4000383c:	40a40433          	sub	s0,s0,a0
40003840:	fca04ee3          	bgtz	a0,4000381c <__sflush_r+0x174>
40003844:	00c4d783          	lhu	a5,12(s1)
40003848:	01c12083          	lw	ra,28(sp)
4000384c:	fff00513          	li	a0,-1
40003850:	0407e793          	ori	a5,a5,64
40003854:	00f49623          	sh	a5,12(s1)
40003858:	01812403          	lw	s0,24(sp)
4000385c:	01412483          	lw	s1,20(sp)
40003860:	01012903          	lw	s2,16(sp)
40003864:	00c12983          	lw	s3,12(sp)
40003868:	02010113          	addi	sp,sp,32
4000386c:	00008067          	ret
40003870:	f0a596e3          	bne	a1,a0,4000377c <__sflush_r+0xd4>
40003874:	0009a683          	lw	a3,0(s3)
40003878:	01d00793          	li	a5,29
4000387c:	fcd7e4e3          	bltu	a5,a3,40003844 <__sflush_r+0x19c>
40003880:	204007b7          	lui	a5,0x20400
40003884:	00178793          	addi	a5,a5,1 # 20400001 <_heap_size+0x203fe001>
40003888:	00d7d7b3          	srl	a5,a5,a3
4000388c:	fff7c793          	not	a5,a5
40003890:	0017f793          	andi	a5,a5,1
40003894:	fa0798e3          	bnez	a5,40003844 <__sflush_r+0x19c>
40003898:	00c4d783          	lhu	a5,12(s1)
4000389c:	fffff737          	lui	a4,0xfffff
400038a0:	7ff70713          	addi	a4,a4,2047 # fffff7ff <_bss_end+0xbfff3177>
400038a4:	00e7f7b3          	and	a5,a5,a4
400038a8:	0104a603          	lw	a2,16(s1)
400038ac:	01079793          	slli	a5,a5,0x10
400038b0:	4107d793          	srai	a5,a5,0x10
400038b4:	00f49623          	sh	a5,12(s1)
400038b8:	0004a223          	sw	zero,4(s1)
400038bc:	00c4a023          	sw	a2,0(s1)
400038c0:	01379713          	slli	a4,a5,0x13
400038c4:	ee0754e3          	bgez	a4,400037ac <__sflush_r+0x104>
400038c8:	ee0692e3          	bnez	a3,400037ac <__sflush_r+0x104>
400038cc:	04a4a823          	sw	a0,80(s1)
400038d0:	eddff06f          	j	400037ac <__sflush_r+0x104>
400038d4:	03c5a703          	lw	a4,60(a1)
400038d8:	e0e04ee3          	bgtz	a4,400036f4 <__sflush_r+0x4c>
400038dc:	ef1ff06f          	j	400037cc <__sflush_r+0x124>
400038e0:	01c4a583          	lw	a1,28(s1)
400038e4:	00000613          	li	a2,0
400038e8:	00000693          	li	a3,0
400038ec:	00100713          	li	a4,1
400038f0:	00098513          	mv	a0,s3
400038f4:	000800e7          	jalr	a6
400038f8:	fff00793          	li	a5,-1
400038fc:	00050613          	mv	a2,a0
40003900:	00058693          	mv	a3,a1
40003904:	00f50863          	beq	a0,a5,40003914 <__sflush_r+0x26c>
40003908:	00c4d783          	lhu	a5,12(s1)
4000390c:	0284a803          	lw	a6,40(s1)
40003910:	e0dff06f          	j	4000371c <__sflush_r+0x74>
40003914:	fea59ae3          	bne	a1,a0,40003908 <__sflush_r+0x260>
40003918:	0009a783          	lw	a5,0(s3)
4000391c:	fe0786e3          	beqz	a5,40003908 <__sflush_r+0x260>
40003920:	01d00713          	li	a4,29
40003924:	00e78663          	beq	a5,a4,40003930 <__sflush_r+0x288>
40003928:	01600713          	li	a4,22
4000392c:	f0e79ce3          	bne	a5,a4,40003844 <__sflush_r+0x19c>
40003930:	0089a023          	sw	s0,0(s3)
40003934:	00000513          	li	a0,0
40003938:	e99ff06f          	j	400037d0 <__sflush_r+0x128>

4000393c <_fflush_r>:
4000393c:	fe010113          	addi	sp,sp,-32
40003940:	00812c23          	sw	s0,24(sp)
40003944:	00112e23          	sw	ra,28(sp)
40003948:	00050413          	mv	s0,a0
4000394c:	00050663          	beqz	a0,40003958 <_fflush_r+0x1c>
40003950:	03852783          	lw	a5,56(a0)
40003954:	02078a63          	beqz	a5,40003988 <_fflush_r+0x4c>
40003958:	00c59783          	lh	a5,12(a1)
4000395c:	00079c63          	bnez	a5,40003974 <_fflush_r+0x38>
40003960:	01c12083          	lw	ra,28(sp)
40003964:	00000513          	li	a0,0
40003968:	01812403          	lw	s0,24(sp)
4000396c:	02010113          	addi	sp,sp,32
40003970:	00008067          	ret
40003974:	00040513          	mv	a0,s0
40003978:	01c12083          	lw	ra,28(sp)
4000397c:	01812403          	lw	s0,24(sp)
40003980:	02010113          	addi	sp,sp,32
40003984:	d25ff06f          	j	400036a8 <__sflush_r>
40003988:	00b12623          	sw	a1,12(sp)
4000398c:	374000ef          	jal	ra,40003d00 <__sinit>
40003990:	00c12583          	lw	a1,12(sp)
40003994:	fc5ff06f          	j	40003958 <_fflush_r+0x1c>

40003998 <fflush>:
40003998:	00050593          	mv	a1,a0
4000399c:	00050863          	beqz	a0,400039ac <fflush+0x14>
400039a0:	4000c7b7          	lui	a5,0x4000c
400039a4:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
400039a8:	f95ff06f          	j	4000393c <_fflush_r>
400039ac:	4000c7b7          	lui	a5,0x4000c
400039b0:	6287a503          	lw	a0,1576(a5) # 4000c628 <_global_impure_ptr>
400039b4:	400045b7          	lui	a1,0x40004
400039b8:	93c58593          	addi	a1,a1,-1732 # 4000393c <_fflush_r>
400039bc:	0750006f          	j	40004230 <_fwalk_reent>

400039c0 <__fp_unlock>:
400039c0:	00000513          	li	a0,0
400039c4:	00008067          	ret

400039c8 <_cleanup_r>:
400039c8:	400075b7          	lui	a1,0x40007
400039cc:	5fc58593          	addi	a1,a1,1532 # 400075fc <_fclose_r>
400039d0:	0610006f          	j	40004230 <_fwalk_reent>

400039d4 <__sinit.part.1>:
400039d4:	fe010113          	addi	sp,sp,-32
400039d8:	400047b7          	lui	a5,0x40004
400039dc:	00112e23          	sw	ra,28(sp)
400039e0:	00812c23          	sw	s0,24(sp)
400039e4:	00912a23          	sw	s1,20(sp)
400039e8:	00452403          	lw	s0,4(a0)
400039ec:	01212823          	sw	s2,16(sp)
400039f0:	01312623          	sw	s3,12(sp)
400039f4:	01412423          	sw	s4,8(sp)
400039f8:	01512223          	sw	s5,4(sp)
400039fc:	01612023          	sw	s6,0(sp)
40003a00:	9c878793          	addi	a5,a5,-1592 # 400039c8 <_cleanup_r>
40003a04:	02f52e23          	sw	a5,60(a0)
40003a08:	2ec50713          	addi	a4,a0,748
40003a0c:	00300793          	li	a5,3
40003a10:	2ee52423          	sw	a4,744(a0)
40003a14:	2ef52223          	sw	a5,740(a0)
40003a18:	2e052023          	sw	zero,736(a0)
40003a1c:	00400793          	li	a5,4
40003a20:	00050913          	mv	s2,a0
40003a24:	00f41623          	sh	a5,12(s0)
40003a28:	00800613          	li	a2,8
40003a2c:	00000593          	li	a1,0
40003a30:	00042023          	sw	zero,0(s0)
40003a34:	00042223          	sw	zero,4(s0)
40003a38:	00042423          	sw	zero,8(s0)
40003a3c:	06042223          	sw	zero,100(s0)
40003a40:	00041723          	sh	zero,14(s0)
40003a44:	00042823          	sw	zero,16(s0)
40003a48:	00042a23          	sw	zero,20(s0)
40003a4c:	00042c23          	sw	zero,24(s0)
40003a50:	05c40513          	addi	a0,s0,92
40003a54:	488010ef          	jal	ra,40004edc <memset>
40003a58:	40006b37          	lui	s6,0x40006
40003a5c:	00892483          	lw	s1,8(s2)
40003a60:	40006ab7          	lui	s5,0x40006
40003a64:	40006a37          	lui	s4,0x40006
40003a68:	400069b7          	lui	s3,0x40006
40003a6c:	034b0b13          	addi	s6,s6,52 # 40006034 <__sread>
40003a70:	098a8a93          	addi	s5,s5,152 # 40006098 <__swrite>
40003a74:	11ca0a13          	addi	s4,s4,284 # 4000611c <__sseek>
40003a78:	19098993          	addi	s3,s3,400 # 40006190 <__sclose>
40003a7c:	03642023          	sw	s6,32(s0)
40003a80:	03542223          	sw	s5,36(s0)
40003a84:	03442423          	sw	s4,40(s0)
40003a88:	03342623          	sw	s3,44(s0)
40003a8c:	00842e23          	sw	s0,28(s0)
40003a90:	00900793          	li	a5,9
40003a94:	00f49623          	sh	a5,12(s1)
40003a98:	00100793          	li	a5,1
40003a9c:	00f49723          	sh	a5,14(s1)
40003aa0:	00800613          	li	a2,8
40003aa4:	00000593          	li	a1,0
40003aa8:	0004a023          	sw	zero,0(s1)
40003aac:	0004a223          	sw	zero,4(s1)
40003ab0:	0004a423          	sw	zero,8(s1)
40003ab4:	0604a223          	sw	zero,100(s1)
40003ab8:	0004a823          	sw	zero,16(s1)
40003abc:	0004aa23          	sw	zero,20(s1)
40003ac0:	0004ac23          	sw	zero,24(s1)
40003ac4:	05c48513          	addi	a0,s1,92
40003ac8:	414010ef          	jal	ra,40004edc <memset>
40003acc:	00c92403          	lw	s0,12(s2)
40003ad0:	01200793          	li	a5,18
40003ad4:	0364a023          	sw	s6,32(s1)
40003ad8:	0354a223          	sw	s5,36(s1)
40003adc:	0344a423          	sw	s4,40(s1)
40003ae0:	0334a623          	sw	s3,44(s1)
40003ae4:	0094ae23          	sw	s1,28(s1)
40003ae8:	00f41623          	sh	a5,12(s0)
40003aec:	00200793          	li	a5,2
40003af0:	00f41723          	sh	a5,14(s0)
40003af4:	00042023          	sw	zero,0(s0)
40003af8:	00042223          	sw	zero,4(s0)
40003afc:	00042423          	sw	zero,8(s0)
40003b00:	06042223          	sw	zero,100(s0)
40003b04:	00042823          	sw	zero,16(s0)
40003b08:	00042a23          	sw	zero,20(s0)
40003b0c:	00042c23          	sw	zero,24(s0)
40003b10:	05c40513          	addi	a0,s0,92
40003b14:	00800613          	li	a2,8
40003b18:	00000593          	li	a1,0
40003b1c:	3c0010ef          	jal	ra,40004edc <memset>
40003b20:	01c12083          	lw	ra,28(sp)
40003b24:	03642023          	sw	s6,32(s0)
40003b28:	03542223          	sw	s5,36(s0)
40003b2c:	03442423          	sw	s4,40(s0)
40003b30:	03342623          	sw	s3,44(s0)
40003b34:	00842e23          	sw	s0,28(s0)
40003b38:	00100793          	li	a5,1
40003b3c:	02f92c23          	sw	a5,56(s2)
40003b40:	01812403          	lw	s0,24(sp)
40003b44:	01412483          	lw	s1,20(sp)
40003b48:	01012903          	lw	s2,16(sp)
40003b4c:	00c12983          	lw	s3,12(sp)
40003b50:	00812a03          	lw	s4,8(sp)
40003b54:	00412a83          	lw	s5,4(sp)
40003b58:	00012b03          	lw	s6,0(sp)
40003b5c:	02010113          	addi	sp,sp,32
40003b60:	00008067          	ret

40003b64 <__fp_lock>:
40003b64:	00000513          	li	a0,0
40003b68:	00008067          	ret

40003b6c <__sfmoreglue>:
40003b6c:	ff010113          	addi	sp,sp,-16
40003b70:	00912223          	sw	s1,4(sp)
40003b74:	06800613          	li	a2,104
40003b78:	fff58493          	addi	s1,a1,-1
40003b7c:	02c484b3          	mul	s1,s1,a2
40003b80:	01212023          	sw	s2,0(sp)
40003b84:	00058913          	mv	s2,a1
40003b88:	00812423          	sw	s0,8(sp)
40003b8c:	00112623          	sw	ra,12(sp)
40003b90:	07448593          	addi	a1,s1,116
40003b94:	205000ef          	jal	ra,40004598 <_malloc_r>
40003b98:	00050413          	mv	s0,a0
40003b9c:	02050063          	beqz	a0,40003bbc <__sfmoreglue+0x50>
40003ba0:	00c50513          	addi	a0,a0,12
40003ba4:	00042023          	sw	zero,0(s0)
40003ba8:	01242223          	sw	s2,4(s0)
40003bac:	00a42423          	sw	a0,8(s0)
40003bb0:	06848613          	addi	a2,s1,104
40003bb4:	00000593          	li	a1,0
40003bb8:	324010ef          	jal	ra,40004edc <memset>
40003bbc:	00c12083          	lw	ra,12(sp)
40003bc0:	00040513          	mv	a0,s0
40003bc4:	00412483          	lw	s1,4(sp)
40003bc8:	00812403          	lw	s0,8(sp)
40003bcc:	00012903          	lw	s2,0(sp)
40003bd0:	01010113          	addi	sp,sp,16
40003bd4:	00008067          	ret

40003bd8 <__sfp>:
40003bd8:	fe010113          	addi	sp,sp,-32
40003bdc:	4000c7b7          	lui	a5,0x4000c
40003be0:	01212823          	sw	s2,16(sp)
40003be4:	6287a903          	lw	s2,1576(a5) # 4000c628 <_global_impure_ptr>
40003be8:	01312623          	sw	s3,12(sp)
40003bec:	00112e23          	sw	ra,28(sp)
40003bf0:	03892783          	lw	a5,56(s2)
40003bf4:	00812c23          	sw	s0,24(sp)
40003bf8:	00912a23          	sw	s1,20(sp)
40003bfc:	01412423          	sw	s4,8(sp)
40003c00:	00050993          	mv	s3,a0
40003c04:	0a078c63          	beqz	a5,40003cbc <__sfp+0xe4>
40003c08:	2e090913          	addi	s2,s2,736
40003c0c:	fff00493          	li	s1,-1
40003c10:	00400a13          	li	s4,4
40003c14:	00492783          	lw	a5,4(s2)
40003c18:	00892403          	lw	s0,8(s2)
40003c1c:	fff78793          	addi	a5,a5,-1
40003c20:	0007da63          	bgez	a5,40003c34 <__sfp+0x5c>
40003c24:	0880006f          	j	40003cac <__sfp+0xd4>
40003c28:	fff78793          	addi	a5,a5,-1
40003c2c:	06840413          	addi	s0,s0,104
40003c30:	06978e63          	beq	a5,s1,40003cac <__sfp+0xd4>
40003c34:	00c41703          	lh	a4,12(s0)
40003c38:	fe0718e3          	bnez	a4,40003c28 <__sfp+0x50>
40003c3c:	fff00793          	li	a5,-1
40003c40:	00f41723          	sh	a5,14(s0)
40003c44:	00100793          	li	a5,1
40003c48:	00f41623          	sh	a5,12(s0)
40003c4c:	06042223          	sw	zero,100(s0)
40003c50:	00042023          	sw	zero,0(s0)
40003c54:	00042423          	sw	zero,8(s0)
40003c58:	00042223          	sw	zero,4(s0)
40003c5c:	00042823          	sw	zero,16(s0)
40003c60:	00042a23          	sw	zero,20(s0)
40003c64:	00042c23          	sw	zero,24(s0)
40003c68:	00800613          	li	a2,8
40003c6c:	00000593          	li	a1,0
40003c70:	05c40513          	addi	a0,s0,92
40003c74:	268010ef          	jal	ra,40004edc <memset>
40003c78:	02042823          	sw	zero,48(s0)
40003c7c:	02042a23          	sw	zero,52(s0)
40003c80:	04042223          	sw	zero,68(s0)
40003c84:	04042423          	sw	zero,72(s0)
40003c88:	01c12083          	lw	ra,28(sp)
40003c8c:	00040513          	mv	a0,s0
40003c90:	01412483          	lw	s1,20(sp)
40003c94:	01812403          	lw	s0,24(sp)
40003c98:	01012903          	lw	s2,16(sp)
40003c9c:	00c12983          	lw	s3,12(sp)
40003ca0:	00812a03          	lw	s4,8(sp)
40003ca4:	02010113          	addi	sp,sp,32
40003ca8:	00008067          	ret
40003cac:	00092503          	lw	a0,0(s2)
40003cb0:	00050c63          	beqz	a0,40003cc8 <__sfp+0xf0>
40003cb4:	00050913          	mv	s2,a0
40003cb8:	f5dff06f          	j	40003c14 <__sfp+0x3c>
40003cbc:	00090513          	mv	a0,s2
40003cc0:	d15ff0ef          	jal	ra,400039d4 <__sinit.part.1>
40003cc4:	f45ff06f          	j	40003c08 <__sfp+0x30>
40003cc8:	000a0593          	mv	a1,s4
40003ccc:	00098513          	mv	a0,s3
40003cd0:	e9dff0ef          	jal	ra,40003b6c <__sfmoreglue>
40003cd4:	00a92023          	sw	a0,0(s2)
40003cd8:	fc051ee3          	bnez	a0,40003cb4 <__sfp+0xdc>
40003cdc:	00c00793          	li	a5,12
40003ce0:	00f9a023          	sw	a5,0(s3)
40003ce4:	00000413          	li	s0,0
40003ce8:	fa1ff06f          	j	40003c88 <__sfp+0xb0>

40003cec <_cleanup>:
40003cec:	4000c7b7          	lui	a5,0x4000c
40003cf0:	6287a503          	lw	a0,1576(a5) # 4000c628 <_global_impure_ptr>
40003cf4:	400075b7          	lui	a1,0x40007
40003cf8:	5fc58593          	addi	a1,a1,1532 # 400075fc <_fclose_r>
40003cfc:	5340006f          	j	40004230 <_fwalk_reent>

40003d00 <__sinit>:
40003d00:	03852783          	lw	a5,56(a0)
40003d04:	00078463          	beqz	a5,40003d0c <__sinit+0xc>
40003d08:	00008067          	ret
40003d0c:	cc9ff06f          	j	400039d4 <__sinit.part.1>

40003d10 <__sfp_lock_acquire>:
40003d10:	00008067          	ret

40003d14 <__sfp_lock_release>:
40003d14:	00008067          	ret

40003d18 <__sinit_lock_acquire>:
40003d18:	00008067          	ret

40003d1c <__sinit_lock_release>:
40003d1c:	00008067          	ret

40003d20 <__fp_lock_all>:
40003d20:	4000c7b7          	lui	a5,0x4000c
40003d24:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
40003d28:	400045b7          	lui	a1,0x40004
40003d2c:	b6458593          	addi	a1,a1,-1180 # 40003b64 <__fp_lock>
40003d30:	4500006f          	j	40004180 <_fwalk>

40003d34 <__fp_unlock_all>:
40003d34:	4000c7b7          	lui	a5,0x4000c
40003d38:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
40003d3c:	400045b7          	lui	a1,0x40004
40003d40:	9c058593          	addi	a1,a1,-1600 # 400039c0 <__fp_unlock>
40003d44:	43c0006f          	j	40004180 <_fwalk>

40003d48 <_malloc_trim_r>:
40003d48:	fe010113          	addi	sp,sp,-32
40003d4c:	01212823          	sw	s2,16(sp)
40003d50:	4000c937          	lui	s2,0x4000c
40003d54:	00812c23          	sw	s0,24(sp)
40003d58:	00912a23          	sw	s1,20(sp)
40003d5c:	01312623          	sw	s3,12(sp)
40003d60:	01412423          	sw	s4,8(sp)
40003d64:	00112e23          	sw	ra,28(sp)
40003d68:	00058a13          	mv	s4,a1
40003d6c:	00050993          	mv	s3,a0
40003d70:	22090913          	addi	s2,s2,544 # 4000c220 <__malloc_av_>
40003d74:	244010ef          	jal	ra,40004fb8 <__malloc_lock>
40003d78:	00892703          	lw	a4,8(s2)
40003d7c:	000017b7          	lui	a5,0x1
40003d80:	fef78413          	addi	s0,a5,-17 # fef <_stack_size+0x7ef>
40003d84:	00472483          	lw	s1,4(a4)
40003d88:	41440433          	sub	s0,s0,s4
40003d8c:	ffc4f493          	andi	s1,s1,-4
40003d90:	00940433          	add	s0,s0,s1
40003d94:	00c45413          	srli	s0,s0,0xc
40003d98:	fff40413          	addi	s0,s0,-1
40003d9c:	00c41413          	slli	s0,s0,0xc
40003da0:	00f44e63          	blt	s0,a5,40003dbc <_malloc_trim_r+0x74>
40003da4:	00000593          	li	a1,0
40003da8:	00098513          	mv	a0,s3
40003dac:	228020ef          	jal	ra,40005fd4 <_sbrk_r>
40003db0:	00892783          	lw	a5,8(s2)
40003db4:	009787b3          	add	a5,a5,s1
40003db8:	02f50863          	beq	a0,a5,40003de8 <_malloc_trim_r+0xa0>
40003dbc:	00098513          	mv	a0,s3
40003dc0:	1fc010ef          	jal	ra,40004fbc <__malloc_unlock>
40003dc4:	01c12083          	lw	ra,28(sp)
40003dc8:	00000513          	li	a0,0
40003dcc:	01812403          	lw	s0,24(sp)
40003dd0:	01412483          	lw	s1,20(sp)
40003dd4:	01012903          	lw	s2,16(sp)
40003dd8:	00c12983          	lw	s3,12(sp)
40003ddc:	00812a03          	lw	s4,8(sp)
40003de0:	02010113          	addi	sp,sp,32
40003de4:	00008067          	ret
40003de8:	408005b3          	neg	a1,s0
40003dec:	00098513          	mv	a0,s3
40003df0:	1e4020ef          	jal	ra,40005fd4 <_sbrk_r>
40003df4:	fff00793          	li	a5,-1
40003df8:	04f50863          	beq	a0,a5,40003e48 <_malloc_trim_r+0x100>
40003dfc:	4000c737          	lui	a4,0x4000c
40003e00:	65c72783          	lw	a5,1628(a4) # 4000c65c <__malloc_current_mallinfo>
40003e04:	00892683          	lw	a3,8(s2)
40003e08:	408484b3          	sub	s1,s1,s0
40003e0c:	0014e493          	ori	s1,s1,1
40003e10:	40878433          	sub	s0,a5,s0
40003e14:	00098513          	mv	a0,s3
40003e18:	0096a223          	sw	s1,4(a3)
40003e1c:	64872e23          	sw	s0,1628(a4)
40003e20:	19c010ef          	jal	ra,40004fbc <__malloc_unlock>
40003e24:	01c12083          	lw	ra,28(sp)
40003e28:	00100513          	li	a0,1
40003e2c:	01812403          	lw	s0,24(sp)
40003e30:	01412483          	lw	s1,20(sp)
40003e34:	01012903          	lw	s2,16(sp)
40003e38:	00c12983          	lw	s3,12(sp)
40003e3c:	00812a03          	lw	s4,8(sp)
40003e40:	02010113          	addi	sp,sp,32
40003e44:	00008067          	ret
40003e48:	00000593          	li	a1,0
40003e4c:	00098513          	mv	a0,s3
40003e50:	184020ef          	jal	ra,40005fd4 <_sbrk_r>
40003e54:	00892703          	lw	a4,8(s2)
40003e58:	00f00693          	li	a3,15
40003e5c:	40e507b3          	sub	a5,a0,a4
40003e60:	f4f6dee3          	ble	a5,a3,40003dbc <_malloc_trim_r+0x74>
40003e64:	4000c6b7          	lui	a3,0x4000c
40003e68:	6346a683          	lw	a3,1588(a3) # 4000c634 <__malloc_sbrk_base>
40003e6c:	0017e793          	ori	a5,a5,1
40003e70:	00f72223          	sw	a5,4(a4)
40003e74:	40d50533          	sub	a0,a0,a3
40003e78:	4000c6b7          	lui	a3,0x4000c
40003e7c:	64a6ae23          	sw	a0,1628(a3) # 4000c65c <__malloc_current_mallinfo>
40003e80:	f3dff06f          	j	40003dbc <_malloc_trim_r+0x74>

40003e84 <_free_r>:
40003e84:	0e058e63          	beqz	a1,40003f80 <_free_r+0xfc>
40003e88:	ff010113          	addi	sp,sp,-16
40003e8c:	00812423          	sw	s0,8(sp)
40003e90:	00912223          	sw	s1,4(sp)
40003e94:	00058413          	mv	s0,a1
40003e98:	00050493          	mv	s1,a0
40003e9c:	00112623          	sw	ra,12(sp)
40003ea0:	118010ef          	jal	ra,40004fb8 <__malloc_lock>
40003ea4:	ffc42503          	lw	a0,-4(s0)
40003ea8:	ff840693          	addi	a3,s0,-8
40003eac:	4000c5b7          	lui	a1,0x4000c
40003eb0:	ffe57793          	andi	a5,a0,-2
40003eb4:	00f68633          	add	a2,a3,a5
40003eb8:	22058593          	addi	a1,a1,544 # 4000c220 <__malloc_av_>
40003ebc:	00462703          	lw	a4,4(a2)
40003ec0:	0085a803          	lw	a6,8(a1)
40003ec4:	ffc77713          	andi	a4,a4,-4
40003ec8:	15060e63          	beq	a2,a6,40004024 <_free_r+0x1a0>
40003ecc:	00e62223          	sw	a4,4(a2)
40003ed0:	00157513          	andi	a0,a0,1
40003ed4:	02051663          	bnez	a0,40003f00 <_free_r+0x7c>
40003ed8:	ff842883          	lw	a7,-8(s0)
40003edc:	4000c537          	lui	a0,0x4000c
40003ee0:	22850513          	addi	a0,a0,552 # 4000c228 <__malloc_av_+0x8>
40003ee4:	411686b3          	sub	a3,a3,a7
40003ee8:	0086a803          	lw	a6,8(a3)
40003eec:	011787b3          	add	a5,a5,a7
40003ef0:	18a80863          	beq	a6,a0,40004080 <_free_r+0x1fc>
40003ef4:	00c6a503          	lw	a0,12(a3)
40003ef8:	00a82623          	sw	a0,12(a6)
40003efc:	01052423          	sw	a6,8(a0)
40003f00:	00e60533          	add	a0,a2,a4
40003f04:	00452503          	lw	a0,4(a0)
40003f08:	00157513          	andi	a0,a0,1
40003f0c:	0e050263          	beqz	a0,40003ff0 <_free_r+0x16c>
40003f10:	0017e713          	ori	a4,a5,1
40003f14:	00e6a223          	sw	a4,4(a3)
40003f18:	00f68733          	add	a4,a3,a5
40003f1c:	00f72023          	sw	a5,0(a4)
40003f20:	1ff00713          	li	a4,511
40003f24:	06f76063          	bltu	a4,a5,40003f84 <_free_r+0x100>
40003f28:	0037d793          	srli	a5,a5,0x3
40003f2c:	00178713          	addi	a4,a5,1
40003f30:	00371713          	slli	a4,a4,0x3
40003f34:	0045a803          	lw	a6,4(a1)
40003f38:	00e58733          	add	a4,a1,a4
40003f3c:	00072503          	lw	a0,0(a4)
40003f40:	4027d613          	srai	a2,a5,0x2
40003f44:	00100793          	li	a5,1
40003f48:	00c797b3          	sll	a5,a5,a2
40003f4c:	0107e7b3          	or	a5,a5,a6
40003f50:	ff870613          	addi	a2,a4,-8
40003f54:	00c6a623          	sw	a2,12(a3)
40003f58:	00a6a423          	sw	a0,8(a3)
40003f5c:	00f5a223          	sw	a5,4(a1)
40003f60:	00d72023          	sw	a3,0(a4)
40003f64:	00d52623          	sw	a3,12(a0)
40003f68:	00048513          	mv	a0,s1
40003f6c:	00c12083          	lw	ra,12(sp)
40003f70:	00812403          	lw	s0,8(sp)
40003f74:	00412483          	lw	s1,4(sp)
40003f78:	01010113          	addi	sp,sp,16
40003f7c:	0400106f          	j	40004fbc <__malloc_unlock>
40003f80:	00008067          	ret
40003f84:	0097d713          	srli	a4,a5,0x9
40003f88:	00400613          	li	a2,4
40003f8c:	12e66663          	bltu	a2,a4,400040b8 <_free_r+0x234>
40003f90:	0067d713          	srli	a4,a5,0x6
40003f94:	03970513          	addi	a0,a4,57
40003f98:	03870613          	addi	a2,a4,56
40003f9c:	00351513          	slli	a0,a0,0x3
40003fa0:	00a58533          	add	a0,a1,a0
40003fa4:	00052703          	lw	a4,0(a0)
40003fa8:	ff850513          	addi	a0,a0,-8
40003fac:	12e50263          	beq	a0,a4,400040d0 <_free_r+0x24c>
40003fb0:	00472603          	lw	a2,4(a4)
40003fb4:	ffc67613          	andi	a2,a2,-4
40003fb8:	0cc7f063          	bleu	a2,a5,40004078 <_free_r+0x1f4>
40003fbc:	00872703          	lw	a4,8(a4)
40003fc0:	fee518e3          	bne	a0,a4,40003fb0 <_free_r+0x12c>
40003fc4:	00c52783          	lw	a5,12(a0)
40003fc8:	00a6a423          	sw	a0,8(a3)
40003fcc:	00f6a623          	sw	a5,12(a3)
40003fd0:	00d7a423          	sw	a3,8(a5)
40003fd4:	00d52623          	sw	a3,12(a0)
40003fd8:	00c12083          	lw	ra,12(sp)
40003fdc:	00048513          	mv	a0,s1
40003fe0:	00812403          	lw	s0,8(sp)
40003fe4:	00412483          	lw	s1,4(sp)
40003fe8:	01010113          	addi	sp,sp,16
40003fec:	7d10006f          	j	40004fbc <__malloc_unlock>
40003ff0:	00862503          	lw	a0,8(a2)
40003ff4:	4000c837          	lui	a6,0x4000c
40003ff8:	22880813          	addi	a6,a6,552 # 4000c228 <__malloc_av_+0x8>
40003ffc:	00e787b3          	add	a5,a5,a4
40004000:	0f050863          	beq	a0,a6,400040f0 <_free_r+0x26c>
40004004:	00c62803          	lw	a6,12(a2)
40004008:	0017e613          	ori	a2,a5,1
4000400c:	00f68733          	add	a4,a3,a5
40004010:	01052623          	sw	a6,12(a0)
40004014:	00a82423          	sw	a0,8(a6)
40004018:	00c6a223          	sw	a2,4(a3)
4000401c:	00f72023          	sw	a5,0(a4)
40004020:	f01ff06f          	j	40003f20 <_free_r+0x9c>
40004024:	00157513          	andi	a0,a0,1
40004028:	00e787b3          	add	a5,a5,a4
4000402c:	02051063          	bnez	a0,4000404c <_free_r+0x1c8>
40004030:	ff842503          	lw	a0,-8(s0)
40004034:	40a686b3          	sub	a3,a3,a0
40004038:	00c6a703          	lw	a4,12(a3)
4000403c:	0086a603          	lw	a2,8(a3)
40004040:	00a787b3          	add	a5,a5,a0
40004044:	00e62623          	sw	a4,12(a2)
40004048:	00c72423          	sw	a2,8(a4)
4000404c:	4000c737          	lui	a4,0x4000c
40004050:	0017e613          	ori	a2,a5,1
40004054:	63872703          	lw	a4,1592(a4) # 4000c638 <__malloc_trim_threshold>
40004058:	00c6a223          	sw	a2,4(a3)
4000405c:	00d5a423          	sw	a3,8(a1)
40004060:	f0e7e4e3          	bltu	a5,a4,40003f68 <_free_r+0xe4>
40004064:	4000c7b7          	lui	a5,0x4000c
40004068:	6547a583          	lw	a1,1620(a5) # 4000c654 <__malloc_top_pad>
4000406c:	00048513          	mv	a0,s1
40004070:	cd9ff0ef          	jal	ra,40003d48 <_malloc_trim_r>
40004074:	ef5ff06f          	j	40003f68 <_free_r+0xe4>
40004078:	00070513          	mv	a0,a4
4000407c:	f49ff06f          	j	40003fc4 <_free_r+0x140>
40004080:	00e605b3          	add	a1,a2,a4
40004084:	0045a583          	lw	a1,4(a1)
40004088:	0015f593          	andi	a1,a1,1
4000408c:	0e059263          	bnez	a1,40004170 <_free_r+0x2ec>
40004090:	00862583          	lw	a1,8(a2)
40004094:	00c62603          	lw	a2,12(a2)
40004098:	00f707b3          	add	a5,a4,a5
4000409c:	0017e713          	ori	a4,a5,1
400040a0:	00c5a623          	sw	a2,12(a1)
400040a4:	00b62423          	sw	a1,8(a2)
400040a8:	00e6a223          	sw	a4,4(a3)
400040ac:	00f686b3          	add	a3,a3,a5
400040b0:	00f6a023          	sw	a5,0(a3)
400040b4:	eb5ff06f          	j	40003f68 <_free_r+0xe4>
400040b8:	01400613          	li	a2,20
400040bc:	04e66c63          	bltu	a2,a4,40004114 <_free_r+0x290>
400040c0:	05c70513          	addi	a0,a4,92
400040c4:	05b70613          	addi	a2,a4,91
400040c8:	00351513          	slli	a0,a0,0x3
400040cc:	ed5ff06f          	j	40003fa0 <_free_r+0x11c>
400040d0:	0045a803          	lw	a6,4(a1)
400040d4:	40265713          	srai	a4,a2,0x2
400040d8:	00100793          	li	a5,1
400040dc:	00e797b3          	sll	a5,a5,a4
400040e0:	0107e7b3          	or	a5,a5,a6
400040e4:	00f5a223          	sw	a5,4(a1)
400040e8:	00050793          	mv	a5,a0
400040ec:	eddff06f          	j	40003fc8 <_free_r+0x144>
400040f0:	00d5aa23          	sw	a3,20(a1)
400040f4:	00d5a823          	sw	a3,16(a1)
400040f8:	0017e713          	ori	a4,a5,1
400040fc:	00a6a623          	sw	a0,12(a3)
40004100:	00a6a423          	sw	a0,8(a3)
40004104:	00e6a223          	sw	a4,4(a3)
40004108:	00f686b3          	add	a3,a3,a5
4000410c:	00f6a023          	sw	a5,0(a3)
40004110:	e59ff06f          	j	40003f68 <_free_r+0xe4>
40004114:	05400613          	li	a2,84
40004118:	00e66c63          	bltu	a2,a4,40004130 <_free_r+0x2ac>
4000411c:	00c7d713          	srli	a4,a5,0xc
40004120:	06f70513          	addi	a0,a4,111
40004124:	06e70613          	addi	a2,a4,110
40004128:	00351513          	slli	a0,a0,0x3
4000412c:	e75ff06f          	j	40003fa0 <_free_r+0x11c>
40004130:	15400613          	li	a2,340
40004134:	00e66c63          	bltu	a2,a4,4000414c <_free_r+0x2c8>
40004138:	00f7d713          	srli	a4,a5,0xf
4000413c:	07870513          	addi	a0,a4,120
40004140:	07770613          	addi	a2,a4,119
40004144:	00351513          	slli	a0,a0,0x3
40004148:	e59ff06f          	j	40003fa0 <_free_r+0x11c>
4000414c:	55400813          	li	a6,1364
40004150:	3f800513          	li	a0,1016
40004154:	07e00613          	li	a2,126
40004158:	e4e864e3          	bltu	a6,a4,40003fa0 <_free_r+0x11c>
4000415c:	0127d713          	srli	a4,a5,0x12
40004160:	07d70513          	addi	a0,a4,125
40004164:	07c70613          	addi	a2,a4,124
40004168:	00351513          	slli	a0,a0,0x3
4000416c:	e35ff06f          	j	40003fa0 <_free_r+0x11c>
40004170:	0017e713          	ori	a4,a5,1
40004174:	00e6a223          	sw	a4,4(a3)
40004178:	00f62023          	sw	a5,0(a2)
4000417c:	dedff06f          	j	40003f68 <_free_r+0xe4>

40004180 <_fwalk>:
40004180:	fe010113          	addi	sp,sp,-32
40004184:	01512223          	sw	s5,4(sp)
40004188:	00112e23          	sw	ra,28(sp)
4000418c:	00812c23          	sw	s0,24(sp)
40004190:	00912a23          	sw	s1,20(sp)
40004194:	01212823          	sw	s2,16(sp)
40004198:	01312623          	sw	s3,12(sp)
4000419c:	01412423          	sw	s4,8(sp)
400041a0:	01612023          	sw	s6,0(sp)
400041a4:	2e050a93          	addi	s5,a0,736
400041a8:	080a8063          	beqz	s5,40004228 <_fwalk+0xa8>
400041ac:	00058b13          	mv	s6,a1
400041b0:	00000a13          	li	s4,0
400041b4:	00100993          	li	s3,1
400041b8:	fff00913          	li	s2,-1
400041bc:	004aa483          	lw	s1,4(s5)
400041c0:	008aa403          	lw	s0,8(s5)
400041c4:	fff48493          	addi	s1,s1,-1
400041c8:	0204c663          	bltz	s1,400041f4 <_fwalk+0x74>
400041cc:	00c45783          	lhu	a5,12(s0)
400041d0:	fff48493          	addi	s1,s1,-1
400041d4:	00f9fc63          	bleu	a5,s3,400041ec <_fwalk+0x6c>
400041d8:	00e41783          	lh	a5,14(s0)
400041dc:	00040513          	mv	a0,s0
400041e0:	01278663          	beq	a5,s2,400041ec <_fwalk+0x6c>
400041e4:	000b00e7          	jalr	s6
400041e8:	00aa6a33          	or	s4,s4,a0
400041ec:	06840413          	addi	s0,s0,104
400041f0:	fd249ee3          	bne	s1,s2,400041cc <_fwalk+0x4c>
400041f4:	000aaa83          	lw	s5,0(s5)
400041f8:	fc0a92e3          	bnez	s5,400041bc <_fwalk+0x3c>
400041fc:	01c12083          	lw	ra,28(sp)
40004200:	000a0513          	mv	a0,s4
40004204:	01812403          	lw	s0,24(sp)
40004208:	01412483          	lw	s1,20(sp)
4000420c:	01012903          	lw	s2,16(sp)
40004210:	00c12983          	lw	s3,12(sp)
40004214:	00812a03          	lw	s4,8(sp)
40004218:	00412a83          	lw	s5,4(sp)
4000421c:	00012b03          	lw	s6,0(sp)
40004220:	02010113          	addi	sp,sp,32
40004224:	00008067          	ret
40004228:	00000a13          	li	s4,0
4000422c:	fd1ff06f          	j	400041fc <_fwalk+0x7c>

40004230 <_fwalk_reent>:
40004230:	fd010113          	addi	sp,sp,-48
40004234:	01612823          	sw	s6,16(sp)
40004238:	02112623          	sw	ra,44(sp)
4000423c:	02812423          	sw	s0,40(sp)
40004240:	02912223          	sw	s1,36(sp)
40004244:	03212023          	sw	s2,32(sp)
40004248:	01312e23          	sw	s3,28(sp)
4000424c:	01412c23          	sw	s4,24(sp)
40004250:	01512a23          	sw	s5,20(sp)
40004254:	01712623          	sw	s7,12(sp)
40004258:	2e050b13          	addi	s6,a0,736
4000425c:	080b0663          	beqz	s6,400042e8 <_fwalk_reent+0xb8>
40004260:	00058b93          	mv	s7,a1
40004264:	00050a93          	mv	s5,a0
40004268:	00000a13          	li	s4,0
4000426c:	00100993          	li	s3,1
40004270:	fff00913          	li	s2,-1
40004274:	004b2483          	lw	s1,4(s6)
40004278:	008b2403          	lw	s0,8(s6)
4000427c:	fff48493          	addi	s1,s1,-1
40004280:	0204c863          	bltz	s1,400042b0 <_fwalk_reent+0x80>
40004284:	00c45783          	lhu	a5,12(s0)
40004288:	fff48493          	addi	s1,s1,-1
4000428c:	00f9fe63          	bleu	a5,s3,400042a8 <_fwalk_reent+0x78>
40004290:	00e41783          	lh	a5,14(s0)
40004294:	00040593          	mv	a1,s0
40004298:	000a8513          	mv	a0,s5
4000429c:	01278663          	beq	a5,s2,400042a8 <_fwalk_reent+0x78>
400042a0:	000b80e7          	jalr	s7
400042a4:	00aa6a33          	or	s4,s4,a0
400042a8:	06840413          	addi	s0,s0,104
400042ac:	fd249ce3          	bne	s1,s2,40004284 <_fwalk_reent+0x54>
400042b0:	000b2b03          	lw	s6,0(s6)
400042b4:	fc0b10e3          	bnez	s6,40004274 <_fwalk_reent+0x44>
400042b8:	02c12083          	lw	ra,44(sp)
400042bc:	000a0513          	mv	a0,s4
400042c0:	02812403          	lw	s0,40(sp)
400042c4:	02412483          	lw	s1,36(sp)
400042c8:	02012903          	lw	s2,32(sp)
400042cc:	01c12983          	lw	s3,28(sp)
400042d0:	01812a03          	lw	s4,24(sp)
400042d4:	01412a83          	lw	s5,20(sp)
400042d8:	01012b03          	lw	s6,16(sp)
400042dc:	00c12b83          	lw	s7,12(sp)
400042e0:	03010113          	addi	sp,sp,48
400042e4:	00008067          	ret
400042e8:	00000a13          	li	s4,0
400042ec:	fcdff06f          	j	400042b8 <_fwalk_reent+0x88>

400042f0 <_setlocale_r>:
400042f0:	ff010113          	addi	sp,sp,-16
400042f4:	00912223          	sw	s1,4(sp)
400042f8:	00112623          	sw	ra,12(sp)
400042fc:	00812423          	sw	s0,8(sp)
40004300:	4000b4b7          	lui	s1,0x4000b
40004304:	02060063          	beqz	a2,40004324 <_setlocale_r+0x34>
40004308:	4000b5b7          	lui	a1,0x4000b
4000430c:	7f858593          	addi	a1,a1,2040 # 4000b7f8 <zeroes.4139+0x68>
40004310:	00060513          	mv	a0,a2
40004314:	00060413          	mv	s0,a2
40004318:	681010ef          	jal	ra,40006198 <strcmp>
4000431c:	4000b4b7          	lui	s1,0x4000b
40004320:	00051e63          	bnez	a0,4000433c <_setlocale_r+0x4c>
40004324:	7f448513          	addi	a0,s1,2036 # 4000b7f4 <zeroes.4139+0x64>
40004328:	00c12083          	lw	ra,12(sp)
4000432c:	00812403          	lw	s0,8(sp)
40004330:	00412483          	lw	s1,4(sp)
40004334:	01010113          	addi	sp,sp,16
40004338:	00008067          	ret
4000433c:	7f448593          	addi	a1,s1,2036
40004340:	00040513          	mv	a0,s0
40004344:	655010ef          	jal	ra,40006198 <strcmp>
40004348:	fc050ee3          	beqz	a0,40004324 <_setlocale_r+0x34>
4000434c:	4000b5b7          	lui	a1,0x4000b
40004350:	61858593          	addi	a1,a1,1560 # 4000b618 <__clzsi2+0x78>
40004354:	00040513          	mv	a0,s0
40004358:	641010ef          	jal	ra,40006198 <strcmp>
4000435c:	fc0504e3          	beqz	a0,40004324 <_setlocale_r+0x34>
40004360:	00000513          	li	a0,0
40004364:	fc5ff06f          	j	40004328 <_setlocale_r+0x38>

40004368 <__locale_charset>:
40004368:	4000c537          	lui	a0,0x4000c
4000436c:	1a850513          	addi	a0,a0,424 # 4000c1a8 <lc_ctype_charset>
40004370:	00008067          	ret

40004374 <__locale_mb_cur_max>:
40004374:	4000c7b7          	lui	a5,0x4000c
40004378:	6307a503          	lw	a0,1584(a5) # 4000c630 <__mb_cur_max>
4000437c:	00008067          	ret

40004380 <__locale_msgcharset>:
40004380:	4000c537          	lui	a0,0x4000c
40004384:	1c850513          	addi	a0,a0,456 # 4000c1c8 <lc_message_charset>
40004388:	00008067          	ret

4000438c <__locale_cjk_lang>:
4000438c:	00000513          	li	a0,0
40004390:	00008067          	ret

40004394 <_localeconv_r>:
40004394:	4000c537          	lui	a0,0x4000c
40004398:	1e850513          	addi	a0,a0,488 # 4000c1e8 <lconv>
4000439c:	00008067          	ret

400043a0 <setlocale>:
400043a0:	4000c7b7          	lui	a5,0x4000c
400043a4:	00058613          	mv	a2,a1
400043a8:	00050593          	mv	a1,a0
400043ac:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
400043b0:	f41ff06f          	j	400042f0 <_setlocale_r>

400043b4 <localeconv>:
400043b4:	4000c537          	lui	a0,0x4000c
400043b8:	1e850513          	addi	a0,a0,488 # 4000c1e8 <lconv>
400043bc:	00008067          	ret

400043c0 <__swhatbuf_r>:
400043c0:	f8010113          	addi	sp,sp,-128
400043c4:	06812c23          	sw	s0,120(sp)
400043c8:	00058413          	mv	s0,a1
400043cc:	00e59583          	lh	a1,14(a1)
400043d0:	06912a23          	sw	s1,116(sp)
400043d4:	07212823          	sw	s2,112(sp)
400043d8:	06112e23          	sw	ra,124(sp)
400043dc:	00060493          	mv	s1,a2
400043e0:	00068913          	mv	s2,a3
400043e4:	0405ca63          	bltz	a1,40004438 <__swhatbuf_r+0x78>
400043e8:	00810613          	addi	a2,sp,8
400043ec:	500030ef          	jal	ra,400078ec <_fstat_r>
400043f0:	04054463          	bltz	a0,40004438 <__swhatbuf_r+0x78>
400043f4:	01812783          	lw	a5,24(sp)
400043f8:	0000f737          	lui	a4,0xf
400043fc:	07c12083          	lw	ra,124(sp)
40004400:	00e7f7b3          	and	a5,a5,a4
40004404:	ffffe737          	lui	a4,0xffffe
40004408:	00e787b3          	add	a5,a5,a4
4000440c:	0017b793          	seqz	a5,a5
40004410:	00f92023          	sw	a5,0(s2)
40004414:	00001537          	lui	a0,0x1
40004418:	40000793          	li	a5,1024
4000441c:	00f4a023          	sw	a5,0(s1)
40004420:	80050513          	addi	a0,a0,-2048 # 800 <_stack_size>
40004424:	07812403          	lw	s0,120(sp)
40004428:	07412483          	lw	s1,116(sp)
4000442c:	07012903          	lw	s2,112(sp)
40004430:	08010113          	addi	sp,sp,128
40004434:	00008067          	ret
40004438:	00c45783          	lhu	a5,12(s0)
4000443c:	00092023          	sw	zero,0(s2)
40004440:	0807f793          	andi	a5,a5,128
40004444:	02078463          	beqz	a5,4000446c <__swhatbuf_r+0xac>
40004448:	07c12083          	lw	ra,124(sp)
4000444c:	04000793          	li	a5,64
40004450:	00f4a023          	sw	a5,0(s1)
40004454:	00000513          	li	a0,0
40004458:	07812403          	lw	s0,120(sp)
4000445c:	07412483          	lw	s1,116(sp)
40004460:	07012903          	lw	s2,112(sp)
40004464:	08010113          	addi	sp,sp,128
40004468:	00008067          	ret
4000446c:	07c12083          	lw	ra,124(sp)
40004470:	40000793          	li	a5,1024
40004474:	00f4a023          	sw	a5,0(s1)
40004478:	00000513          	li	a0,0
4000447c:	07812403          	lw	s0,120(sp)
40004480:	07412483          	lw	s1,116(sp)
40004484:	07012903          	lw	s2,112(sp)
40004488:	08010113          	addi	sp,sp,128
4000448c:	00008067          	ret

40004490 <__smakebuf_r>:
40004490:	00c5d703          	lhu	a4,12(a1)
40004494:	fe010113          	addi	sp,sp,-32
40004498:	00812c23          	sw	s0,24(sp)
4000449c:	00112e23          	sw	ra,28(sp)
400044a0:	00912a23          	sw	s1,20(sp)
400044a4:	01212823          	sw	s2,16(sp)
400044a8:	00277713          	andi	a4,a4,2
400044ac:	00058413          	mv	s0,a1
400044b0:	02070863          	beqz	a4,400044e0 <__smakebuf_r+0x50>
400044b4:	04358713          	addi	a4,a1,67
400044b8:	00e5a023          	sw	a4,0(a1)
400044bc:	00e5a823          	sw	a4,16(a1)
400044c0:	00100713          	li	a4,1
400044c4:	00e5aa23          	sw	a4,20(a1)
400044c8:	01c12083          	lw	ra,28(sp)
400044cc:	01812403          	lw	s0,24(sp)
400044d0:	01412483          	lw	s1,20(sp)
400044d4:	01012903          	lw	s2,16(sp)
400044d8:	02010113          	addi	sp,sp,32
400044dc:	00008067          	ret
400044e0:	00c10693          	addi	a3,sp,12
400044e4:	00810613          	addi	a2,sp,8
400044e8:	00050493          	mv	s1,a0
400044ec:	ed5ff0ef          	jal	ra,400043c0 <__swhatbuf_r>
400044f0:	00812583          	lw	a1,8(sp)
400044f4:	00050913          	mv	s2,a0
400044f8:	00048513          	mv	a0,s1
400044fc:	09c000ef          	jal	ra,40004598 <_malloc_r>
40004500:	00c41783          	lh	a5,12(s0)
40004504:	06050663          	beqz	a0,40004570 <__smakebuf_r+0xe0>
40004508:	40004737          	lui	a4,0x40004
4000450c:	9c870713          	addi	a4,a4,-1592 # 400039c8 <_cleanup_r>
40004510:	02e4ae23          	sw	a4,60(s1)
40004514:	00812703          	lw	a4,8(sp)
40004518:	00c12683          	lw	a3,12(sp)
4000451c:	0807e793          	ori	a5,a5,128
40004520:	00f41623          	sh	a5,12(s0)
40004524:	00a42023          	sw	a0,0(s0)
40004528:	00a42823          	sw	a0,16(s0)
4000452c:	00e42a23          	sw	a4,20(s0)
40004530:	02069263          	bnez	a3,40004554 <__smakebuf_r+0xc4>
40004534:	01c12083          	lw	ra,28(sp)
40004538:	0127e7b3          	or	a5,a5,s2
4000453c:	00f41623          	sh	a5,12(s0)
40004540:	01412483          	lw	s1,20(sp)
40004544:	01812403          	lw	s0,24(sp)
40004548:	01012903          	lw	s2,16(sp)
4000454c:	02010113          	addi	sp,sp,32
40004550:	00008067          	ret
40004554:	00e41583          	lh	a1,14(s0)
40004558:	00048513          	mv	a0,s1
4000455c:	09d030ef          	jal	ra,40007df8 <_isatty_r>
40004560:	00c41783          	lh	a5,12(s0)
40004564:	fc0508e3          	beqz	a0,40004534 <__smakebuf_r+0xa4>
40004568:	0017e793          	ori	a5,a5,1
4000456c:	fc9ff06f          	j	40004534 <__smakebuf_r+0xa4>
40004570:	2007f713          	andi	a4,a5,512
40004574:	f4071ae3          	bnez	a4,400044c8 <__smakebuf_r+0x38>
40004578:	0027e793          	ori	a5,a5,2
4000457c:	04340713          	addi	a4,s0,67
40004580:	00f41623          	sh	a5,12(s0)
40004584:	00100793          	li	a5,1
40004588:	00e42023          	sw	a4,0(s0)
4000458c:	00e42823          	sw	a4,16(s0)
40004590:	00f42a23          	sw	a5,20(s0)
40004594:	f35ff06f          	j	400044c8 <__smakebuf_r+0x38>

40004598 <_malloc_r>:
40004598:	fd010113          	addi	sp,sp,-48
4000459c:	02912223          	sw	s1,36(sp)
400045a0:	01312e23          	sw	s3,28(sp)
400045a4:	02112623          	sw	ra,44(sp)
400045a8:	02812423          	sw	s0,40(sp)
400045ac:	03212023          	sw	s2,32(sp)
400045b0:	01412c23          	sw	s4,24(sp)
400045b4:	01512a23          	sw	s5,20(sp)
400045b8:	01612823          	sw	s6,16(sp)
400045bc:	01712623          	sw	s7,12(sp)
400045c0:	01812423          	sw	s8,8(sp)
400045c4:	01912223          	sw	s9,4(sp)
400045c8:	00b58493          	addi	s1,a1,11
400045cc:	01600793          	li	a5,22
400045d0:	00050993          	mv	s3,a0
400045d4:	1a97fa63          	bleu	s1,a5,40004788 <_malloc_r+0x1f0>
400045d8:	ff84f493          	andi	s1,s1,-8
400045dc:	2404c063          	bltz	s1,4000481c <_malloc_r+0x284>
400045e0:	22b4ee63          	bltu	s1,a1,4000481c <_malloc_r+0x284>
400045e4:	1d5000ef          	jal	ra,40004fb8 <__malloc_lock>
400045e8:	1f700793          	li	a5,503
400045ec:	6e97f663          	bleu	s1,a5,40004cd8 <_malloc_r+0x740>
400045f0:	0094d793          	srli	a5,s1,0x9
400045f4:	04000593          	li	a1,64
400045f8:	20000693          	li	a3,512
400045fc:	03f00513          	li	a0,63
40004600:	22079663          	bnez	a5,4000482c <_malloc_r+0x294>
40004604:	4000c937          	lui	s2,0x4000c
40004608:	22090913          	addi	s2,s2,544 # 4000c220 <__malloc_av_>
4000460c:	00d906b3          	add	a3,s2,a3
40004610:	0046a403          	lw	s0,4(a3)
40004614:	ff868693          	addi	a3,a3,-8
40004618:	02868c63          	beq	a3,s0,40004650 <_malloc_r+0xb8>
4000461c:	00442783          	lw	a5,4(s0)
40004620:	00f00613          	li	a2,15
40004624:	ffc7f793          	andi	a5,a5,-4
40004628:	40978733          	sub	a4,a5,s1
4000462c:	02e64063          	blt	a2,a4,4000464c <_malloc_r+0xb4>
40004630:	22075c63          	bgez	a4,40004868 <_malloc_r+0x2d0>
40004634:	00c42403          	lw	s0,12(s0)
40004638:	00868c63          	beq	a3,s0,40004650 <_malloc_r+0xb8>
4000463c:	00442783          	lw	a5,4(s0)
40004640:	ffc7f793          	andi	a5,a5,-4
40004644:	40978733          	sub	a4,a5,s1
40004648:	fee654e3          	ble	a4,a2,40004630 <_malloc_r+0x98>
4000464c:	00050593          	mv	a1,a0
40004650:	01092403          	lw	s0,16(s2)
40004654:	00890813          	addi	a6,s2,8
40004658:	45040c63          	beq	s0,a6,40004ab0 <_malloc_r+0x518>
4000465c:	00442783          	lw	a5,4(s0)
40004660:	00f00693          	li	a3,15
40004664:	ffc7f793          	andi	a5,a5,-4
40004668:	40978733          	sub	a4,a5,s1
4000466c:	42e6cc63          	blt	a3,a4,40004aa4 <_malloc_r+0x50c>
40004670:	01092a23          	sw	a6,20(s2)
40004674:	01092823          	sw	a6,16(s2)
40004678:	1c075863          	bgez	a4,40004848 <_malloc_r+0x2b0>
4000467c:	1ff00713          	li	a4,511
40004680:	3cf76263          	bltu	a4,a5,40004a44 <_malloc_r+0x4ac>
40004684:	0037d793          	srli	a5,a5,0x3
40004688:	00178713          	addi	a4,a5,1
4000468c:	00371713          	slli	a4,a4,0x3
40004690:	00492503          	lw	a0,4(s2)
40004694:	00e90733          	add	a4,s2,a4
40004698:	00072603          	lw	a2,0(a4)
4000469c:	4027d693          	srai	a3,a5,0x2
400046a0:	00100793          	li	a5,1
400046a4:	00d797b3          	sll	a5,a5,a3
400046a8:	00a7e7b3          	or	a5,a5,a0
400046ac:	ff870693          	addi	a3,a4,-8
400046b0:	00d42623          	sw	a3,12(s0)
400046b4:	00c42423          	sw	a2,8(s0)
400046b8:	00f92223          	sw	a5,4(s2)
400046bc:	00872023          	sw	s0,0(a4)
400046c0:	00862623          	sw	s0,12(a2)
400046c4:	4025d713          	srai	a4,a1,0x2
400046c8:	00100693          	li	a3,1
400046cc:	00e696b3          	sll	a3,a3,a4
400046d0:	1ad7e263          	bltu	a5,a3,40004874 <_malloc_r+0x2dc>
400046d4:	00f6f733          	and	a4,a3,a5
400046d8:	02071463          	bnez	a4,40004700 <_malloc_r+0x168>
400046dc:	00169693          	slli	a3,a3,0x1
400046e0:	ffc5f593          	andi	a1,a1,-4
400046e4:	00f6f733          	and	a4,a3,a5
400046e8:	00458593          	addi	a1,a1,4
400046ec:	00071a63          	bnez	a4,40004700 <_malloc_r+0x168>
400046f0:	00169693          	slli	a3,a3,0x1
400046f4:	00f6f733          	and	a4,a3,a5
400046f8:	00458593          	addi	a1,a1,4
400046fc:	fe070ae3          	beqz	a4,400046f0 <_malloc_r+0x158>
40004700:	00f00513          	li	a0,15
40004704:	00359893          	slli	a7,a1,0x3
40004708:	011908b3          	add	a7,s2,a7
4000470c:	00088613          	mv	a2,a7
40004710:	00058313          	mv	t1,a1
40004714:	00c62403          	lw	s0,12(a2)
40004718:	00861a63          	bne	a2,s0,4000472c <_malloc_r+0x194>
4000471c:	39c0006f          	j	40004ab8 <_malloc_r+0x520>
40004720:	3a075e63          	bgez	a4,40004adc <_malloc_r+0x544>
40004724:	00c42403          	lw	s0,12(s0)
40004728:	38860863          	beq	a2,s0,40004ab8 <_malloc_r+0x520>
4000472c:	00442783          	lw	a5,4(s0)
40004730:	ffc7f793          	andi	a5,a5,-4
40004734:	40978733          	sub	a4,a5,s1
40004738:	fee554e3          	ble	a4,a0,40004720 <_malloc_r+0x188>
4000473c:	00c42683          	lw	a3,12(s0)
40004740:	00842603          	lw	a2,8(s0)
40004744:	0014e593          	ori	a1,s1,1
40004748:	00b42223          	sw	a1,4(s0)
4000474c:	00d62623          	sw	a3,12(a2)
40004750:	00c6a423          	sw	a2,8(a3)
40004754:	009404b3          	add	s1,s0,s1
40004758:	00992a23          	sw	s1,20(s2)
4000475c:	00992823          	sw	s1,16(s2)
40004760:	00176693          	ori	a3,a4,1
40004764:	0104a623          	sw	a6,12(s1)
40004768:	0104a423          	sw	a6,8(s1)
4000476c:	00d4a223          	sw	a3,4(s1)
40004770:	00f407b3          	add	a5,s0,a5
40004774:	00098513          	mv	a0,s3
40004778:	00e7a023          	sw	a4,0(a5)
4000477c:	041000ef          	jal	ra,40004fbc <__malloc_unlock>
40004780:	00840513          	addi	a0,s0,8
40004784:	0640006f          	j	400047e8 <_malloc_r+0x250>
40004788:	01000493          	li	s1,16
4000478c:	08b4e863          	bltu	s1,a1,4000481c <_malloc_r+0x284>
40004790:	029000ef          	jal	ra,40004fb8 <__malloc_lock>
40004794:	01800793          	li	a5,24
40004798:	00200593          	li	a1,2
4000479c:	4000c937          	lui	s2,0x4000c
400047a0:	22090913          	addi	s2,s2,544 # 4000c220 <__malloc_av_>
400047a4:	00f907b3          	add	a5,s2,a5
400047a8:	0047a403          	lw	s0,4(a5)
400047ac:	ff878713          	addi	a4,a5,-8
400047b0:	30e40e63          	beq	s0,a4,40004acc <_malloc_r+0x534>
400047b4:	00442783          	lw	a5,4(s0)
400047b8:	00c42683          	lw	a3,12(s0)
400047bc:	00842603          	lw	a2,8(s0)
400047c0:	ffc7f793          	andi	a5,a5,-4
400047c4:	00f407b3          	add	a5,s0,a5
400047c8:	0047a703          	lw	a4,4(a5)
400047cc:	00d62623          	sw	a3,12(a2)
400047d0:	00c6a423          	sw	a2,8(a3)
400047d4:	00176713          	ori	a4,a4,1
400047d8:	00098513          	mv	a0,s3
400047dc:	00e7a223          	sw	a4,4(a5)
400047e0:	7dc000ef          	jal	ra,40004fbc <__malloc_unlock>
400047e4:	00840513          	addi	a0,s0,8
400047e8:	02c12083          	lw	ra,44(sp)
400047ec:	02812403          	lw	s0,40(sp)
400047f0:	02412483          	lw	s1,36(sp)
400047f4:	02012903          	lw	s2,32(sp)
400047f8:	01c12983          	lw	s3,28(sp)
400047fc:	01812a03          	lw	s4,24(sp)
40004800:	01412a83          	lw	s5,20(sp)
40004804:	01012b03          	lw	s6,16(sp)
40004808:	00c12b83          	lw	s7,12(sp)
4000480c:	00812c03          	lw	s8,8(sp)
40004810:	00412c83          	lw	s9,4(sp)
40004814:	03010113          	addi	sp,sp,48
40004818:	00008067          	ret
4000481c:	00c00793          	li	a5,12
40004820:	00f9a023          	sw	a5,0(s3)
40004824:	00000513          	li	a0,0
40004828:	fc1ff06f          	j	400047e8 <_malloc_r+0x250>
4000482c:	00400713          	li	a4,4
40004830:	1ef76863          	bltu	a4,a5,40004a20 <_malloc_r+0x488>
40004834:	0064d513          	srli	a0,s1,0x6
40004838:	03950593          	addi	a1,a0,57
4000483c:	00359693          	slli	a3,a1,0x3
40004840:	03850513          	addi	a0,a0,56
40004844:	dc1ff06f          	j	40004604 <_malloc_r+0x6c>
40004848:	00f407b3          	add	a5,s0,a5
4000484c:	0047a703          	lw	a4,4(a5)
40004850:	00098513          	mv	a0,s3
40004854:	00176713          	ori	a4,a4,1
40004858:	00e7a223          	sw	a4,4(a5)
4000485c:	760000ef          	jal	ra,40004fbc <__malloc_unlock>
40004860:	00840513          	addi	a0,s0,8
40004864:	f85ff06f          	j	400047e8 <_malloc_r+0x250>
40004868:	00c42683          	lw	a3,12(s0)
4000486c:	00842603          	lw	a2,8(s0)
40004870:	f55ff06f          	j	400047c4 <_malloc_r+0x22c>
40004874:	00892403          	lw	s0,8(s2)
40004878:	00442783          	lw	a5,4(s0)
4000487c:	ffc7fa93          	andi	s5,a5,-4
40004880:	009ae863          	bltu	s5,s1,40004890 <_malloc_r+0x2f8>
40004884:	409a87b3          	sub	a5,s5,s1
40004888:	00f00713          	li	a4,15
4000488c:	16f74663          	blt	a4,a5,400049f8 <_malloc_r+0x460>
40004890:	4000c7b7          	lui	a5,0x4000c
40004894:	4000ccb7          	lui	s9,0x4000c
40004898:	6547aa03          	lw	s4,1620(a5) # 4000c654 <__malloc_top_pad>
4000489c:	634ca703          	lw	a4,1588(s9) # 4000c634 <__malloc_sbrk_base>
400048a0:	fff00793          	li	a5,-1
400048a4:	01540b33          	add	s6,s0,s5
400048a8:	01448a33          	add	s4,s1,s4
400048ac:	36f70263          	beq	a4,a5,40004c10 <_malloc_r+0x678>
400048b0:	000017b7          	lui	a5,0x1
400048b4:	00f78793          	addi	a5,a5,15 # 100f <_stack_size+0x80f>
400048b8:	00fa0a33          	add	s4,s4,a5
400048bc:	fffff7b7          	lui	a5,0xfffff
400048c0:	00fa7a33          	and	s4,s4,a5
400048c4:	000a0593          	mv	a1,s4
400048c8:	00098513          	mv	a0,s3
400048cc:	708010ef          	jal	ra,40005fd4 <_sbrk_r>
400048d0:	fff00793          	li	a5,-1
400048d4:	00050b93          	mv	s7,a0
400048d8:	24f50e63          	beq	a0,a5,40004b34 <_malloc_r+0x59c>
400048dc:	25656a63          	bltu	a0,s6,40004b30 <_malloc_r+0x598>
400048e0:	4000cc37          	lui	s8,0x4000c
400048e4:	65cc0c13          	addi	s8,s8,1628 # 4000c65c <__malloc_current_mallinfo>
400048e8:	000c2703          	lw	a4,0(s8)
400048ec:	00ea0733          	add	a4,s4,a4
400048f0:	00ec2023          	sw	a4,0(s8)
400048f4:	34ab0c63          	beq	s6,a0,40004c4c <_malloc_r+0x6b4>
400048f8:	634ca683          	lw	a3,1588(s9)
400048fc:	fff00793          	li	a5,-1
40004900:	38f68463          	beq	a3,a5,40004c88 <_malloc_r+0x6f0>
40004904:	416b8b33          	sub	s6,s7,s6
40004908:	00eb0733          	add	a4,s6,a4
4000490c:	00ec2023          	sw	a4,0(s8)
40004910:	007bf793          	andi	a5,s7,7
40004914:	00001737          	lui	a4,0x1
40004918:	00078a63          	beqz	a5,4000492c <_malloc_r+0x394>
4000491c:	40fb8bb3          	sub	s7,s7,a5
40004920:	00870713          	addi	a4,a4,8 # 1008 <_stack_size+0x808>
40004924:	008b8b93          	addi	s7,s7,8
40004928:	40f70733          	sub	a4,a4,a5
4000492c:	000016b7          	lui	a3,0x1
40004930:	014b87b3          	add	a5,s7,s4
40004934:	fff68693          	addi	a3,a3,-1 # fff <_stack_size+0x7ff>
40004938:	00d7f7b3          	and	a5,a5,a3
4000493c:	40f70a33          	sub	s4,a4,a5
40004940:	000a0593          	mv	a1,s4
40004944:	00098513          	mv	a0,s3
40004948:	68c010ef          	jal	ra,40005fd4 <_sbrk_r>
4000494c:	fff00793          	li	a5,-1
40004950:	32f50663          	beq	a0,a5,40004c7c <_malloc_r+0x6e4>
40004954:	417507b3          	sub	a5,a0,s7
40004958:	014787b3          	add	a5,a5,s4
4000495c:	0017e793          	ori	a5,a5,1
40004960:	000c2703          	lw	a4,0(s8)
40004964:	01792423          	sw	s7,8(s2)
40004968:	00fba223          	sw	a5,4(s7)
4000496c:	00ea0733          	add	a4,s4,a4
40004970:	00ec2023          	sw	a4,0(s8)
40004974:	03240c63          	beq	s0,s2,400049ac <_malloc_r+0x414>
40004978:	00f00613          	li	a2,15
4000497c:	27567063          	bleu	s5,a2,40004bdc <_malloc_r+0x644>
40004980:	00442683          	lw	a3,4(s0)
40004984:	ff4a8793          	addi	a5,s5,-12
40004988:	ff87f793          	andi	a5,a5,-8
4000498c:	0016f693          	andi	a3,a3,1
40004990:	00f6e6b3          	or	a3,a3,a5
40004994:	00d42223          	sw	a3,4(s0)
40004998:	00500593          	li	a1,5
4000499c:	00f406b3          	add	a3,s0,a5
400049a0:	00b6a223          	sw	a1,4(a3)
400049a4:	00b6a423          	sw	a1,8(a3)
400049a8:	2cf66063          	bltu	a2,a5,40004c68 <_malloc_r+0x6d0>
400049ac:	4000c7b7          	lui	a5,0x4000c
400049b0:	6507a683          	lw	a3,1616(a5) # 4000c650 <__malloc_max_sbrked_mem>
400049b4:	00e6f463          	bleu	a4,a3,400049bc <_malloc_r+0x424>
400049b8:	64e7a823          	sw	a4,1616(a5)
400049bc:	4000c7b7          	lui	a5,0x4000c
400049c0:	64c7a683          	lw	a3,1612(a5) # 4000c64c <__malloc_max_total_mem>
400049c4:	00892403          	lw	s0,8(s2)
400049c8:	00e6f463          	bleu	a4,a3,400049d0 <_malloc_r+0x438>
400049cc:	64e7a623          	sw	a4,1612(a5)
400049d0:	00442703          	lw	a4,4(s0)
400049d4:	ffc77713          	andi	a4,a4,-4
400049d8:	409707b3          	sub	a5,a4,s1
400049dc:	00976663          	bltu	a4,s1,400049e8 <_malloc_r+0x450>
400049e0:	00f00713          	li	a4,15
400049e4:	00f74a63          	blt	a4,a5,400049f8 <_malloc_r+0x460>
400049e8:	00098513          	mv	a0,s3
400049ec:	5d0000ef          	jal	ra,40004fbc <__malloc_unlock>
400049f0:	00000513          	li	a0,0
400049f4:	df5ff06f          	j	400047e8 <_malloc_r+0x250>
400049f8:	0014e713          	ori	a4,s1,1
400049fc:	00e42223          	sw	a4,4(s0)
40004a00:	009404b3          	add	s1,s0,s1
40004a04:	00992423          	sw	s1,8(s2)
40004a08:	0017e793          	ori	a5,a5,1
40004a0c:	00098513          	mv	a0,s3
40004a10:	00f4a223          	sw	a5,4(s1)
40004a14:	5a8000ef          	jal	ra,40004fbc <__malloc_unlock>
40004a18:	00840513          	addi	a0,s0,8
40004a1c:	dcdff06f          	j	400047e8 <_malloc_r+0x250>
40004a20:	01400713          	li	a4,20
40004a24:	0ef77463          	bleu	a5,a4,40004b0c <_malloc_r+0x574>
40004a28:	05400713          	li	a4,84
40004a2c:	16f76a63          	bltu	a4,a5,40004ba0 <_malloc_r+0x608>
40004a30:	00c4d513          	srli	a0,s1,0xc
40004a34:	06f50593          	addi	a1,a0,111
40004a38:	00359693          	slli	a3,a1,0x3
40004a3c:	06e50513          	addi	a0,a0,110
40004a40:	bc5ff06f          	j	40004604 <_malloc_r+0x6c>
40004a44:	0097d713          	srli	a4,a5,0x9
40004a48:	00400693          	li	a3,4
40004a4c:	0ce6f863          	bleu	a4,a3,40004b1c <_malloc_r+0x584>
40004a50:	01400693          	li	a3,20
40004a54:	1ce6e263          	bltu	a3,a4,40004c18 <_malloc_r+0x680>
40004a58:	05c70613          	addi	a2,a4,92
40004a5c:	05b70693          	addi	a3,a4,91
40004a60:	00361613          	slli	a2,a2,0x3
40004a64:	00c90633          	add	a2,s2,a2
40004a68:	00062703          	lw	a4,0(a2)
40004a6c:	ff860613          	addi	a2,a2,-8
40004a70:	14e60663          	beq	a2,a4,40004bbc <_malloc_r+0x624>
40004a74:	00472683          	lw	a3,4(a4)
40004a78:	ffc6f693          	andi	a3,a3,-4
40004a7c:	10d7fe63          	bleu	a3,a5,40004b98 <_malloc_r+0x600>
40004a80:	00872703          	lw	a4,8(a4)
40004a84:	fee618e3          	bne	a2,a4,40004a74 <_malloc_r+0x4dc>
40004a88:	00c62703          	lw	a4,12(a2)
40004a8c:	00492783          	lw	a5,4(s2)
40004a90:	00e42623          	sw	a4,12(s0)
40004a94:	00c42423          	sw	a2,8(s0)
40004a98:	00872423          	sw	s0,8(a4)
40004a9c:	00862623          	sw	s0,12(a2)
40004aa0:	c25ff06f          	j	400046c4 <_malloc_r+0x12c>
40004aa4:	0014e693          	ori	a3,s1,1
40004aa8:	00d42223          	sw	a3,4(s0)
40004aac:	ca9ff06f          	j	40004754 <_malloc_r+0x1bc>
40004ab0:	00492783          	lw	a5,4(s2)
40004ab4:	c11ff06f          	j	400046c4 <_malloc_r+0x12c>
40004ab8:	00130313          	addi	t1,t1,1
40004abc:	00337793          	andi	a5,t1,3
40004ac0:	00860613          	addi	a2,a2,8
40004ac4:	c40798e3          	bnez	a5,40004714 <_malloc_r+0x17c>
40004ac8:	0880006f          	j	40004b50 <_malloc_r+0x5b8>
40004acc:	00c7a403          	lw	s0,12(a5)
40004ad0:	00258593          	addi	a1,a1,2
40004ad4:	b6878ee3          	beq	a5,s0,40004650 <_malloc_r+0xb8>
40004ad8:	cddff06f          	j	400047b4 <_malloc_r+0x21c>
40004adc:	00f407b3          	add	a5,s0,a5
40004ae0:	0047a703          	lw	a4,4(a5)
40004ae4:	00c42683          	lw	a3,12(s0)
40004ae8:	00842603          	lw	a2,8(s0)
40004aec:	00176713          	ori	a4,a4,1
40004af0:	00e7a223          	sw	a4,4(a5)
40004af4:	00d62623          	sw	a3,12(a2)
40004af8:	00098513          	mv	a0,s3
40004afc:	00c6a423          	sw	a2,8(a3)
40004b00:	4bc000ef          	jal	ra,40004fbc <__malloc_unlock>
40004b04:	00840513          	addi	a0,s0,8
40004b08:	ce1ff06f          	j	400047e8 <_malloc_r+0x250>
40004b0c:	05c78593          	addi	a1,a5,92
40004b10:	05b78513          	addi	a0,a5,91
40004b14:	00359693          	slli	a3,a1,0x3
40004b18:	aedff06f          	j	40004604 <_malloc_r+0x6c>
40004b1c:	0067d693          	srli	a3,a5,0x6
40004b20:	03968613          	addi	a2,a3,57
40004b24:	00361613          	slli	a2,a2,0x3
40004b28:	03868693          	addi	a3,a3,56
40004b2c:	f39ff06f          	j	40004a64 <_malloc_r+0x4cc>
40004b30:	11240263          	beq	s0,s2,40004c34 <_malloc_r+0x69c>
40004b34:	00892403          	lw	s0,8(s2)
40004b38:	00442703          	lw	a4,4(s0)
40004b3c:	ffc77713          	andi	a4,a4,-4
40004b40:	e99ff06f          	j	400049d8 <_malloc_r+0x440>
40004b44:	0088a783          	lw	a5,8(a7)
40004b48:	fff58593          	addi	a1,a1,-1
40004b4c:	18f89263          	bne	a7,a5,40004cd0 <_malloc_r+0x738>
40004b50:	0035f793          	andi	a5,a1,3
40004b54:	ff888893          	addi	a7,a7,-8
40004b58:	fe0796e3          	bnez	a5,40004b44 <_malloc_r+0x5ac>
40004b5c:	00492703          	lw	a4,4(s2)
40004b60:	fff6c793          	not	a5,a3
40004b64:	00e7f7b3          	and	a5,a5,a4
40004b68:	00f92223          	sw	a5,4(s2)
40004b6c:	00169693          	slli	a3,a3,0x1
40004b70:	d0d7e2e3          	bltu	a5,a3,40004874 <_malloc_r+0x2dc>
40004b74:	d00680e3          	beqz	a3,40004874 <_malloc_r+0x2dc>
40004b78:	00f6f733          	and	a4,a3,a5
40004b7c:	00030593          	mv	a1,t1
40004b80:	b80712e3          	bnez	a4,40004704 <_malloc_r+0x16c>
40004b84:	00169693          	slli	a3,a3,0x1
40004b88:	00f6f733          	and	a4,a3,a5
40004b8c:	00458593          	addi	a1,a1,4
40004b90:	fe070ae3          	beqz	a4,40004b84 <_malloc_r+0x5ec>
40004b94:	b71ff06f          	j	40004704 <_malloc_r+0x16c>
40004b98:	00070613          	mv	a2,a4
40004b9c:	eedff06f          	j	40004a88 <_malloc_r+0x4f0>
40004ba0:	15400713          	li	a4,340
40004ba4:	04f76263          	bltu	a4,a5,40004be8 <_malloc_r+0x650>
40004ba8:	00f4d513          	srli	a0,s1,0xf
40004bac:	07850593          	addi	a1,a0,120
40004bb0:	00359693          	slli	a3,a1,0x3
40004bb4:	07750513          	addi	a0,a0,119
40004bb8:	a4dff06f          	j	40004604 <_malloc_r+0x6c>
40004bbc:	00492703          	lw	a4,4(s2)
40004bc0:	4026d693          	srai	a3,a3,0x2
40004bc4:	00100793          	li	a5,1
40004bc8:	00d797b3          	sll	a5,a5,a3
40004bcc:	00e7e7b3          	or	a5,a5,a4
40004bd0:	00f92223          	sw	a5,4(s2)
40004bd4:	00060713          	mv	a4,a2
40004bd8:	eb9ff06f          	j	40004a90 <_malloc_r+0x4f8>
40004bdc:	00100793          	li	a5,1
40004be0:	00fba223          	sw	a5,4(s7)
40004be4:	e05ff06f          	j	400049e8 <_malloc_r+0x450>
40004be8:	55400713          	li	a4,1364
40004bec:	07f00593          	li	a1,127
40004bf0:	3f800693          	li	a3,1016
40004bf4:	07e00513          	li	a0,126
40004bf8:	a0f766e3          	bltu	a4,a5,40004604 <_malloc_r+0x6c>
40004bfc:	0124d513          	srli	a0,s1,0x12
40004c00:	07d50593          	addi	a1,a0,125
40004c04:	00359693          	slli	a3,a1,0x3
40004c08:	07c50513          	addi	a0,a0,124
40004c0c:	9f9ff06f          	j	40004604 <_malloc_r+0x6c>
40004c10:	010a0a13          	addi	s4,s4,16
40004c14:	cb1ff06f          	j	400048c4 <_malloc_r+0x32c>
40004c18:	05400693          	li	a3,84
40004c1c:	06e6ea63          	bltu	a3,a4,40004c90 <_malloc_r+0x6f8>
40004c20:	00c7d693          	srli	a3,a5,0xc
40004c24:	06f68613          	addi	a2,a3,111
40004c28:	00361613          	slli	a2,a2,0x3
40004c2c:	06e68693          	addi	a3,a3,110
40004c30:	e35ff06f          	j	40004a64 <_malloc_r+0x4cc>
40004c34:	4000cc37          	lui	s8,0x4000c
40004c38:	65cc0c13          	addi	s8,s8,1628 # 4000c65c <__malloc_current_mallinfo>
40004c3c:	000c2703          	lw	a4,0(s8)
40004c40:	00ea0733          	add	a4,s4,a4
40004c44:	00ec2023          	sw	a4,0(s8)
40004c48:	cb1ff06f          	j	400048f8 <_malloc_r+0x360>
40004c4c:	014b1793          	slli	a5,s6,0x14
40004c50:	ca0794e3          	bnez	a5,400048f8 <_malloc_r+0x360>
40004c54:	00892683          	lw	a3,8(s2)
40004c58:	014a87b3          	add	a5,s5,s4
40004c5c:	0017e793          	ori	a5,a5,1
40004c60:	00f6a223          	sw	a5,4(a3)
40004c64:	d49ff06f          	j	400049ac <_malloc_r+0x414>
40004c68:	00840593          	addi	a1,s0,8
40004c6c:	00098513          	mv	a0,s3
40004c70:	a14ff0ef          	jal	ra,40003e84 <_free_r>
40004c74:	000c2703          	lw	a4,0(s8)
40004c78:	d35ff06f          	j	400049ac <_malloc_r+0x414>
40004c7c:	00100793          	li	a5,1
40004c80:	00000a13          	li	s4,0
40004c84:	cddff06f          	j	40004960 <_malloc_r+0x3c8>
40004c88:	637caa23          	sw	s7,1588(s9)
40004c8c:	c85ff06f          	j	40004910 <_malloc_r+0x378>
40004c90:	15400693          	li	a3,340
40004c94:	00e6ec63          	bltu	a3,a4,40004cac <_malloc_r+0x714>
40004c98:	00f7d693          	srli	a3,a5,0xf
40004c9c:	07868613          	addi	a2,a3,120
40004ca0:	00361613          	slli	a2,a2,0x3
40004ca4:	07768693          	addi	a3,a3,119
40004ca8:	dbdff06f          	j	40004a64 <_malloc_r+0x4cc>
40004cac:	55400513          	li	a0,1364
40004cb0:	3f800613          	li	a2,1016
40004cb4:	07e00693          	li	a3,126
40004cb8:	dae566e3          	bltu	a0,a4,40004a64 <_malloc_r+0x4cc>
40004cbc:	0127d693          	srli	a3,a5,0x12
40004cc0:	07d68613          	addi	a2,a3,125
40004cc4:	00361613          	slli	a2,a2,0x3
40004cc8:	07c68693          	addi	a3,a3,124
40004ccc:	d99ff06f          	j	40004a64 <_malloc_r+0x4cc>
40004cd0:	00492783          	lw	a5,4(s2)
40004cd4:	e99ff06f          	j	40004b6c <_malloc_r+0x5d4>
40004cd8:	0034d593          	srli	a1,s1,0x3
40004cdc:	00848793          	addi	a5,s1,8
40004ce0:	abdff06f          	j	4000479c <_malloc_r+0x204>

40004ce4 <memchr>:
40004ce4:	00357793          	andi	a5,a0,3
40004ce8:	0ff5f813          	andi	a6,a1,255
40004cec:	0c078663          	beqz	a5,40004db8 <memchr+0xd4>
40004cf0:	fff60793          	addi	a5,a2,-1
40004cf4:	04060e63          	beqz	a2,40004d50 <memchr+0x6c>
40004cf8:	00054703          	lbu	a4,0(a0)
40004cfc:	fff00693          	li	a3,-1
40004d00:	01071c63          	bne	a4,a6,40004d18 <memchr+0x34>
40004d04:	0500006f          	j	40004d54 <memchr+0x70>
40004d08:	fff78793          	addi	a5,a5,-1
40004d0c:	04d78263          	beq	a5,a3,40004d50 <memchr+0x6c>
40004d10:	00054703          	lbu	a4,0(a0)
40004d14:	05070063          	beq	a4,a6,40004d54 <memchr+0x70>
40004d18:	00150513          	addi	a0,a0,1
40004d1c:	00357713          	andi	a4,a0,3
40004d20:	fe0714e3          	bnez	a4,40004d08 <memchr+0x24>
40004d24:	00300713          	li	a4,3
40004d28:	02f76863          	bltu	a4,a5,40004d58 <memchr+0x74>
40004d2c:	02078263          	beqz	a5,40004d50 <memchr+0x6c>
40004d30:	00054703          	lbu	a4,0(a0)
40004d34:	03070063          	beq	a4,a6,40004d54 <memchr+0x70>
40004d38:	00f507b3          	add	a5,a0,a5
40004d3c:	00c0006f          	j	40004d48 <memchr+0x64>
40004d40:	00054703          	lbu	a4,0(a0)
40004d44:	01070863          	beq	a4,a6,40004d54 <memchr+0x70>
40004d48:	00150513          	addi	a0,a0,1
40004d4c:	fea79ae3          	bne	a5,a0,40004d40 <memchr+0x5c>
40004d50:	00000513          	li	a0,0
40004d54:	00008067          	ret
40004d58:	000106b7          	lui	a3,0x10
40004d5c:	00859613          	slli	a2,a1,0x8
40004d60:	fff68693          	addi	a3,a3,-1 # ffff <_heap_size+0xdfff>
40004d64:	00d67633          	and	a2,a2,a3
40004d68:	0ff5f593          	andi	a1,a1,255
40004d6c:	00b66633          	or	a2,a2,a1
40004d70:	01061693          	slli	a3,a2,0x10
40004d74:	feff0337          	lui	t1,0xfeff0
40004d78:	808088b7          	lui	a7,0x80808
40004d7c:	00d66633          	or	a2,a2,a3
40004d80:	eff30313          	addi	t1,t1,-257 # fefefeff <_bss_end+0xbefe3877>
40004d84:	08088893          	addi	a7,a7,128 # 80808080 <_bss_end+0x407fb9f8>
40004d88:	00070593          	mv	a1,a4
40004d8c:	00052703          	lw	a4,0(a0)
40004d90:	00e64733          	xor	a4,a2,a4
40004d94:	006706b3          	add	a3,a4,t1
40004d98:	fff74713          	not	a4,a4
40004d9c:	00e6f733          	and	a4,a3,a4
40004da0:	01177733          	and	a4,a4,a7
40004da4:	f80716e3          	bnez	a4,40004d30 <memchr+0x4c>
40004da8:	ffc78793          	addi	a5,a5,-4
40004dac:	00450513          	addi	a0,a0,4
40004db0:	fcf5eee3          	bltu	a1,a5,40004d8c <memchr+0xa8>
40004db4:	f79ff06f          	j	40004d2c <memchr+0x48>
40004db8:	00060793          	mv	a5,a2
40004dbc:	f69ff06f          	j	40004d24 <memchr+0x40>

40004dc0 <memcpy>:
40004dc0:	00a5c7b3          	xor	a5,a1,a0
40004dc4:	0037f793          	andi	a5,a5,3
40004dc8:	00c508b3          	add	a7,a0,a2
40004dcc:	0e079863          	bnez	a5,40004ebc <memcpy+0xfc>
40004dd0:	00300793          	li	a5,3
40004dd4:	0ec7f463          	bleu	a2,a5,40004ebc <memcpy+0xfc>
40004dd8:	00357793          	andi	a5,a0,3
40004ddc:	00050713          	mv	a4,a0
40004de0:	04079863          	bnez	a5,40004e30 <memcpy+0x70>
40004de4:	ffc8f813          	andi	a6,a7,-4
40004de8:	fe080793          	addi	a5,a6,-32
40004dec:	06f76c63          	bltu	a4,a5,40004e64 <memcpy+0xa4>
40004df0:	03077c63          	bleu	a6,a4,40004e28 <memcpy+0x68>
40004df4:	00058693          	mv	a3,a1
40004df8:	00070793          	mv	a5,a4
40004dfc:	0006a603          	lw	a2,0(a3)
40004e00:	00478793          	addi	a5,a5,4
40004e04:	00468693          	addi	a3,a3,4
40004e08:	fec7ae23          	sw	a2,-4(a5)
40004e0c:	ff07e8e3          	bltu	a5,a6,40004dfc <memcpy+0x3c>
40004e10:	fff74793          	not	a5,a4
40004e14:	010787b3          	add	a5,a5,a6
40004e18:	ffc7f793          	andi	a5,a5,-4
40004e1c:	00478793          	addi	a5,a5,4
40004e20:	00f70733          	add	a4,a4,a5
40004e24:	00f585b3          	add	a1,a1,a5
40004e28:	09176e63          	bltu	a4,a7,40004ec4 <memcpy+0x104>
40004e2c:	00008067          	ret
40004e30:	0005c683          	lbu	a3,0(a1)
40004e34:	00170713          	addi	a4,a4,1
40004e38:	00377793          	andi	a5,a4,3
40004e3c:	fed70fa3          	sb	a3,-1(a4)
40004e40:	00158593          	addi	a1,a1,1
40004e44:	fa0780e3          	beqz	a5,40004de4 <memcpy+0x24>
40004e48:	0005c683          	lbu	a3,0(a1)
40004e4c:	00170713          	addi	a4,a4,1
40004e50:	00377793          	andi	a5,a4,3
40004e54:	fed70fa3          	sb	a3,-1(a4)
40004e58:	00158593          	addi	a1,a1,1
40004e5c:	fc079ae3          	bnez	a5,40004e30 <memcpy+0x70>
40004e60:	f85ff06f          	j	40004de4 <memcpy+0x24>
40004e64:	0005a383          	lw	t2,0(a1)
40004e68:	0045a283          	lw	t0,4(a1)
40004e6c:	0085af83          	lw	t6,8(a1)
40004e70:	00c5af03          	lw	t5,12(a1)
40004e74:	0105ae83          	lw	t4,16(a1)
40004e78:	0145ae03          	lw	t3,20(a1)
40004e7c:	0185a303          	lw	t1,24(a1)
40004e80:	01c5a603          	lw	a2,28(a1)
40004e84:	02458593          	addi	a1,a1,36
40004e88:	02470713          	addi	a4,a4,36
40004e8c:	ffc5a683          	lw	a3,-4(a1)
40004e90:	fc772e23          	sw	t2,-36(a4)
40004e94:	fe572023          	sw	t0,-32(a4)
40004e98:	fff72223          	sw	t6,-28(a4)
40004e9c:	ffe72423          	sw	t5,-24(a4)
40004ea0:	ffd72623          	sw	t4,-20(a4)
40004ea4:	ffc72823          	sw	t3,-16(a4)
40004ea8:	fe672a23          	sw	t1,-12(a4)
40004eac:	fec72c23          	sw	a2,-8(a4)
40004eb0:	fed72e23          	sw	a3,-4(a4)
40004eb4:	faf768e3          	bltu	a4,a5,40004e64 <memcpy+0xa4>
40004eb8:	f39ff06f          	j	40004df0 <memcpy+0x30>
40004ebc:	00050713          	mv	a4,a0
40004ec0:	f71576e3          	bleu	a7,a0,40004e2c <memcpy+0x6c>
40004ec4:	0005c783          	lbu	a5,0(a1)
40004ec8:	00170713          	addi	a4,a4,1
40004ecc:	00158593          	addi	a1,a1,1
40004ed0:	fef70fa3          	sb	a5,-1(a4)
40004ed4:	ff1768e3          	bltu	a4,a7,40004ec4 <memcpy+0x104>
40004ed8:	00008067          	ret

40004edc <memset>:
40004edc:	00f00813          	li	a6,15
40004ee0:	00050713          	mv	a4,a0
40004ee4:	02c87e63          	bleu	a2,a6,40004f20 <memset+0x44>
40004ee8:	00f77793          	andi	a5,a4,15
40004eec:	0a079063          	bnez	a5,40004f8c <memset+0xb0>
40004ef0:	08059263          	bnez	a1,40004f74 <memset+0x98>
40004ef4:	ff067693          	andi	a3,a2,-16
40004ef8:	00f67613          	andi	a2,a2,15
40004efc:	00e686b3          	add	a3,a3,a4
40004f00:	00b72023          	sw	a1,0(a4)
40004f04:	00b72223          	sw	a1,4(a4)
40004f08:	00b72423          	sw	a1,8(a4)
40004f0c:	00b72623          	sw	a1,12(a4)
40004f10:	01070713          	addi	a4,a4,16
40004f14:	fed766e3          	bltu	a4,a3,40004f00 <memset+0x24>
40004f18:	00061463          	bnez	a2,40004f20 <memset+0x44>
40004f1c:	00008067          	ret
40004f20:	40c806b3          	sub	a3,a6,a2
40004f24:	00269693          	slli	a3,a3,0x2
40004f28:	00000297          	auipc	t0,0x0
40004f2c:	005686b3          	add	a3,a3,t0
40004f30:	00c68067          	jr	12(a3)
40004f34:	00b70723          	sb	a1,14(a4)
40004f38:	00b706a3          	sb	a1,13(a4)
40004f3c:	00b70623          	sb	a1,12(a4)
40004f40:	00b705a3          	sb	a1,11(a4)
40004f44:	00b70523          	sb	a1,10(a4)
40004f48:	00b704a3          	sb	a1,9(a4)
40004f4c:	00b70423          	sb	a1,8(a4)
40004f50:	00b703a3          	sb	a1,7(a4)
40004f54:	00b70323          	sb	a1,6(a4)
40004f58:	00b702a3          	sb	a1,5(a4)
40004f5c:	00b70223          	sb	a1,4(a4)
40004f60:	00b701a3          	sb	a1,3(a4)
40004f64:	00b70123          	sb	a1,2(a4)
40004f68:	00b700a3          	sb	a1,1(a4)
40004f6c:	00b70023          	sb	a1,0(a4)
40004f70:	00008067          	ret
40004f74:	0ff5f593          	andi	a1,a1,255
40004f78:	00859693          	slli	a3,a1,0x8
40004f7c:	00d5e5b3          	or	a1,a1,a3
40004f80:	01059693          	slli	a3,a1,0x10
40004f84:	00d5e5b3          	or	a1,a1,a3
40004f88:	f6dff06f          	j	40004ef4 <memset+0x18>
40004f8c:	00279693          	slli	a3,a5,0x2
40004f90:	00000297          	auipc	t0,0x0
40004f94:	005686b3          	add	a3,a3,t0
40004f98:	00008293          	mv	t0,ra
40004f9c:	fa0680e7          	jalr	-96(a3)
40004fa0:	00028093          	mv	ra,t0
40004fa4:	ff078793          	addi	a5,a5,-16
40004fa8:	40f70733          	sub	a4,a4,a5
40004fac:	00f60633          	add	a2,a2,a5
40004fb0:	f6c878e3          	bleu	a2,a6,40004f20 <memset+0x44>
40004fb4:	f3dff06f          	j	40004ef0 <memset+0x14>

40004fb8 <__malloc_lock>:
40004fb8:	00008067          	ret

40004fbc <__malloc_unlock>:
40004fbc:	00008067          	ret

40004fc0 <_Balloc>:
40004fc0:	04c52783          	lw	a5,76(a0)
40004fc4:	ff010113          	addi	sp,sp,-16
40004fc8:	00812423          	sw	s0,8(sp)
40004fcc:	00912223          	sw	s1,4(sp)
40004fd0:	00112623          	sw	ra,12(sp)
40004fd4:	01212023          	sw	s2,0(sp)
40004fd8:	00050413          	mv	s0,a0
40004fdc:	00058493          	mv	s1,a1
40004fe0:	02078e63          	beqz	a5,4000501c <_Balloc+0x5c>
40004fe4:	00249513          	slli	a0,s1,0x2
40004fe8:	00a787b3          	add	a5,a5,a0
40004fec:	0007a503          	lw	a0,0(a5)
40004ff0:	04050663          	beqz	a0,4000503c <_Balloc+0x7c>
40004ff4:	00052703          	lw	a4,0(a0)
40004ff8:	00e7a023          	sw	a4,0(a5)
40004ffc:	00052823          	sw	zero,16(a0)
40005000:	00052623          	sw	zero,12(a0)
40005004:	00c12083          	lw	ra,12(sp)
40005008:	00812403          	lw	s0,8(sp)
4000500c:	00412483          	lw	s1,4(sp)
40005010:	00012903          	lw	s2,0(sp)
40005014:	01010113          	addi	sp,sp,16
40005018:	00008067          	ret
4000501c:	02100613          	li	a2,33
40005020:	00400593          	li	a1,4
40005024:	4cc020ef          	jal	ra,400074f0 <_calloc_r>
40005028:	04a42623          	sw	a0,76(s0)
4000502c:	00050793          	mv	a5,a0
40005030:	fa051ae3          	bnez	a0,40004fe4 <_Balloc+0x24>
40005034:	00000513          	li	a0,0
40005038:	fcdff06f          	j	40005004 <_Balloc+0x44>
4000503c:	00100593          	li	a1,1
40005040:	00959933          	sll	s2,a1,s1
40005044:	00590613          	addi	a2,s2,5
40005048:	00261613          	slli	a2,a2,0x2
4000504c:	00040513          	mv	a0,s0
40005050:	4a0020ef          	jal	ra,400074f0 <_calloc_r>
40005054:	fe0500e3          	beqz	a0,40005034 <_Balloc+0x74>
40005058:	00952223          	sw	s1,4(a0)
4000505c:	01252423          	sw	s2,8(a0)
40005060:	f9dff06f          	j	40004ffc <_Balloc+0x3c>

40005064 <_Bfree>:
40005064:	02058063          	beqz	a1,40005084 <_Bfree+0x20>
40005068:	0045a703          	lw	a4,4(a1)
4000506c:	04c52783          	lw	a5,76(a0)
40005070:	00271713          	slli	a4,a4,0x2
40005074:	00e787b3          	add	a5,a5,a4
40005078:	0007a703          	lw	a4,0(a5)
4000507c:	00e5a023          	sw	a4,0(a1)
40005080:	00b7a023          	sw	a1,0(a5)
40005084:	00008067          	ret

40005088 <__multadd>:
40005088:	fd010113          	addi	sp,sp,-48
4000508c:	00010837          	lui	a6,0x10
40005090:	02812423          	sw	s0,40(sp)
40005094:	02912223          	sw	s1,36(sp)
40005098:	03212023          	sw	s2,32(sp)
4000509c:	00058493          	mv	s1,a1
400050a0:	0105a403          	lw	s0,16(a1)
400050a4:	00050913          	mv	s2,a0
400050a8:	02112623          	sw	ra,44(sp)
400050ac:	01312e23          	sw	s3,28(sp)
400050b0:	01458593          	addi	a1,a1,20
400050b4:	00000513          	li	a0,0
400050b8:	fff80813          	addi	a6,a6,-1 # ffff <_heap_size+0xdfff>
400050bc:	0005a783          	lw	a5,0(a1)
400050c0:	00458593          	addi	a1,a1,4
400050c4:	00150513          	addi	a0,a0,1
400050c8:	0107f733          	and	a4,a5,a6
400050cc:	02c70733          	mul	a4,a4,a2
400050d0:	0107d793          	srli	a5,a5,0x10
400050d4:	02c787b3          	mul	a5,a5,a2
400050d8:	00d706b3          	add	a3,a4,a3
400050dc:	0106d893          	srli	a7,a3,0x10
400050e0:	0106f733          	and	a4,a3,a6
400050e4:	011786b3          	add	a3,a5,a7
400050e8:	01069793          	slli	a5,a3,0x10
400050ec:	00e78733          	add	a4,a5,a4
400050f0:	fee5ae23          	sw	a4,-4(a1)
400050f4:	0106d693          	srli	a3,a3,0x10
400050f8:	fc8542e3          	blt	a0,s0,400050bc <__multadd+0x34>
400050fc:	02068263          	beqz	a3,40005120 <__multadd+0x98>
40005100:	0084a783          	lw	a5,8(s1)
40005104:	02f45e63          	ble	a5,s0,40005140 <__multadd+0xb8>
40005108:	00440793          	addi	a5,s0,4
4000510c:	00279793          	slli	a5,a5,0x2
40005110:	00f487b3          	add	a5,s1,a5
40005114:	00d7a223          	sw	a3,4(a5)
40005118:	00140413          	addi	s0,s0,1
4000511c:	0084a823          	sw	s0,16(s1)
40005120:	02c12083          	lw	ra,44(sp)
40005124:	00048513          	mv	a0,s1
40005128:	02812403          	lw	s0,40(sp)
4000512c:	02412483          	lw	s1,36(sp)
40005130:	02012903          	lw	s2,32(sp)
40005134:	01c12983          	lw	s3,28(sp)
40005138:	03010113          	addi	sp,sp,48
4000513c:	00008067          	ret
40005140:	0044a583          	lw	a1,4(s1)
40005144:	00090513          	mv	a0,s2
40005148:	00d12623          	sw	a3,12(sp)
4000514c:	00158593          	addi	a1,a1,1
40005150:	e71ff0ef          	jal	ra,40004fc0 <_Balloc>
40005154:	0104a603          	lw	a2,16(s1)
40005158:	00050993          	mv	s3,a0
4000515c:	00c48593          	addi	a1,s1,12
40005160:	00260613          	addi	a2,a2,2
40005164:	00c50513          	addi	a0,a0,12
40005168:	00261613          	slli	a2,a2,0x2
4000516c:	c55ff0ef          	jal	ra,40004dc0 <memcpy>
40005170:	0044a703          	lw	a4,4(s1)
40005174:	04c92783          	lw	a5,76(s2)
40005178:	00c12683          	lw	a3,12(sp)
4000517c:	00271713          	slli	a4,a4,0x2
40005180:	00e787b3          	add	a5,a5,a4
40005184:	0007a703          	lw	a4,0(a5)
40005188:	00e4a023          	sw	a4,0(s1)
4000518c:	0097a023          	sw	s1,0(a5)
40005190:	00098493          	mv	s1,s3
40005194:	f75ff06f          	j	40005108 <__multadd+0x80>

40005198 <__s2b>:
40005198:	fe010113          	addi	sp,sp,-32
4000519c:	00900793          	li	a5,9
400051a0:	01412423          	sw	s4,8(sp)
400051a4:	00068a13          	mv	s4,a3
400051a8:	00868693          	addi	a3,a3,8
400051ac:	02f6c6b3          	div	a3,a3,a5
400051b0:	00812c23          	sw	s0,24(sp)
400051b4:	00912a23          	sw	s1,20(sp)
400051b8:	01212823          	sw	s2,16(sp)
400051bc:	01312623          	sw	s3,12(sp)
400051c0:	00112e23          	sw	ra,28(sp)
400051c4:	01512223          	sw	s5,4(sp)
400051c8:	01612023          	sw	s6,0(sp)
400051cc:	00100793          	li	a5,1
400051d0:	00058413          	mv	s0,a1
400051d4:	00050913          	mv	s2,a0
400051d8:	00060993          	mv	s3,a2
400051dc:	00070493          	mv	s1,a4
400051e0:	00000593          	li	a1,0
400051e4:	00d7d863          	ble	a3,a5,400051f4 <__s2b+0x5c>
400051e8:	00179793          	slli	a5,a5,0x1
400051ec:	00158593          	addi	a1,a1,1
400051f0:	fed7cce3          	blt	a5,a3,400051e8 <__s2b+0x50>
400051f4:	00090513          	mv	a0,s2
400051f8:	dc9ff0ef          	jal	ra,40004fc0 <_Balloc>
400051fc:	00100793          	li	a5,1
40005200:	00f52823          	sw	a5,16(a0)
40005204:	00952a23          	sw	s1,20(a0)
40005208:	00900793          	li	a5,9
4000520c:	0937da63          	ble	s3,a5,400052a0 <__s2b+0x108>
40005210:	00f40b33          	add	s6,s0,a5
40005214:	000b0493          	mv	s1,s6
40005218:	01340433          	add	s0,s0,s3
4000521c:	00a00a93          	li	s5,10
40005220:	00148493          	addi	s1,s1,1
40005224:	fff4c683          	lbu	a3,-1(s1)
40005228:	00050593          	mv	a1,a0
4000522c:	000a8613          	mv	a2,s5
40005230:	fd068693          	addi	a3,a3,-48
40005234:	00090513          	mv	a0,s2
40005238:	e51ff0ef          	jal	ra,40005088 <__multadd>
4000523c:	fe8492e3          	bne	s1,s0,40005220 <__s2b+0x88>
40005240:	ff898413          	addi	s0,s3,-8
40005244:	008b0433          	add	s0,s6,s0
40005248:	413a04b3          	sub	s1,s4,s3
4000524c:	009404b3          	add	s1,s0,s1
40005250:	00a00a93          	li	s5,10
40005254:	0349d263          	ble	s4,s3,40005278 <__s2b+0xe0>
40005258:	00140413          	addi	s0,s0,1
4000525c:	fff44683          	lbu	a3,-1(s0)
40005260:	00050593          	mv	a1,a0
40005264:	000a8613          	mv	a2,s5
40005268:	fd068693          	addi	a3,a3,-48
4000526c:	00090513          	mv	a0,s2
40005270:	e19ff0ef          	jal	ra,40005088 <__multadd>
40005274:	fe8492e3          	bne	s1,s0,40005258 <__s2b+0xc0>
40005278:	01c12083          	lw	ra,28(sp)
4000527c:	01812403          	lw	s0,24(sp)
40005280:	01412483          	lw	s1,20(sp)
40005284:	01012903          	lw	s2,16(sp)
40005288:	00c12983          	lw	s3,12(sp)
4000528c:	00812a03          	lw	s4,8(sp)
40005290:	00412a83          	lw	s5,4(sp)
40005294:	00012b03          	lw	s6,0(sp)
40005298:	02010113          	addi	sp,sp,32
4000529c:	00008067          	ret
400052a0:	00a40413          	addi	s0,s0,10
400052a4:	00078993          	mv	s3,a5
400052a8:	fa1ff06f          	j	40005248 <__s2b+0xb0>

400052ac <__hi0bits>:
400052ac:	ffff0737          	lui	a4,0xffff0
400052b0:	00e57733          	and	a4,a0,a4
400052b4:	00050793          	mv	a5,a0
400052b8:	00000513          	li	a0,0
400052bc:	00071663          	bnez	a4,400052c8 <__hi0bits+0x1c>
400052c0:	01079793          	slli	a5,a5,0x10
400052c4:	01000513          	li	a0,16
400052c8:	ff000737          	lui	a4,0xff000
400052cc:	00e7f733          	and	a4,a5,a4
400052d0:	00071663          	bnez	a4,400052dc <__hi0bits+0x30>
400052d4:	00850513          	addi	a0,a0,8
400052d8:	00879793          	slli	a5,a5,0x8
400052dc:	f0000737          	lui	a4,0xf0000
400052e0:	00e7f733          	and	a4,a5,a4
400052e4:	00071663          	bnez	a4,400052f0 <__hi0bits+0x44>
400052e8:	00450513          	addi	a0,a0,4
400052ec:	00479793          	slli	a5,a5,0x4
400052f0:	c0000737          	lui	a4,0xc0000
400052f4:	00e7f733          	and	a4,a5,a4
400052f8:	00071663          	bnez	a4,40005304 <__hi0bits+0x58>
400052fc:	00250513          	addi	a0,a0,2
40005300:	00279793          	slli	a5,a5,0x2
40005304:	0007c863          	bltz	a5,40005314 <__hi0bits+0x68>
40005308:	00179713          	slli	a4,a5,0x1
4000530c:	00074663          	bltz	a4,40005318 <__hi0bits+0x6c>
40005310:	02000513          	li	a0,32
40005314:	00008067          	ret
40005318:	00150513          	addi	a0,a0,1
4000531c:	00008067          	ret

40005320 <__lo0bits>:
40005320:	00052783          	lw	a5,0(a0)
40005324:	0077f713          	andi	a4,a5,7
40005328:	02070663          	beqz	a4,40005354 <__lo0bits+0x34>
4000532c:	0017f693          	andi	a3,a5,1
40005330:	00000713          	li	a4,0
40005334:	00069c63          	bnez	a3,4000534c <__lo0bits+0x2c>
40005338:	0027f713          	andi	a4,a5,2
4000533c:	08071663          	bnez	a4,400053c8 <__lo0bits+0xa8>
40005340:	0027d793          	srli	a5,a5,0x2
40005344:	00f52023          	sw	a5,0(a0)
40005348:	00200713          	li	a4,2
4000534c:	00070513          	mv	a0,a4
40005350:	00008067          	ret
40005354:	01079693          	slli	a3,a5,0x10
40005358:	0106d693          	srli	a3,a3,0x10
4000535c:	00000713          	li	a4,0
40005360:	00069663          	bnez	a3,4000536c <__lo0bits+0x4c>
40005364:	0107d793          	srli	a5,a5,0x10
40005368:	01000713          	li	a4,16
4000536c:	0ff7f693          	andi	a3,a5,255
40005370:	00069663          	bnez	a3,4000537c <__lo0bits+0x5c>
40005374:	00870713          	addi	a4,a4,8 # c0000008 <_bss_end+0x7fff3980>
40005378:	0087d793          	srli	a5,a5,0x8
4000537c:	00f7f693          	andi	a3,a5,15
40005380:	00069663          	bnez	a3,4000538c <__lo0bits+0x6c>
40005384:	00470713          	addi	a4,a4,4
40005388:	0047d793          	srli	a5,a5,0x4
4000538c:	0037f693          	andi	a3,a5,3
40005390:	00069663          	bnez	a3,4000539c <__lo0bits+0x7c>
40005394:	00270713          	addi	a4,a4,2
40005398:	0027d793          	srli	a5,a5,0x2
4000539c:	0017f693          	andi	a3,a5,1
400053a0:	00069e63          	bnez	a3,400053bc <__lo0bits+0x9c>
400053a4:	0017d793          	srli	a5,a5,0x1
400053a8:	00079863          	bnez	a5,400053b8 <__lo0bits+0x98>
400053ac:	02000713          	li	a4,32
400053b0:	00070513          	mv	a0,a4
400053b4:	00008067          	ret
400053b8:	00170713          	addi	a4,a4,1
400053bc:	00f52023          	sw	a5,0(a0)
400053c0:	00070513          	mv	a0,a4
400053c4:	00008067          	ret
400053c8:	0017d793          	srli	a5,a5,0x1
400053cc:	00100713          	li	a4,1
400053d0:	00f52023          	sw	a5,0(a0)
400053d4:	00070513          	mv	a0,a4
400053d8:	00008067          	ret

400053dc <__i2b>:
400053dc:	ff010113          	addi	sp,sp,-16
400053e0:	00812423          	sw	s0,8(sp)
400053e4:	00058413          	mv	s0,a1
400053e8:	00100593          	li	a1,1
400053ec:	00112623          	sw	ra,12(sp)
400053f0:	bd1ff0ef          	jal	ra,40004fc0 <_Balloc>
400053f4:	00c12083          	lw	ra,12(sp)
400053f8:	00100713          	li	a4,1
400053fc:	00852a23          	sw	s0,20(a0)
40005400:	00e52823          	sw	a4,16(a0)
40005404:	00812403          	lw	s0,8(sp)
40005408:	01010113          	addi	sp,sp,16
4000540c:	00008067          	ret

40005410 <__multiply>:
40005410:	fe010113          	addi	sp,sp,-32
40005414:	01312623          	sw	s3,12(sp)
40005418:	01412423          	sw	s4,8(sp)
4000541c:	0105a983          	lw	s3,16(a1)
40005420:	01062a03          	lw	s4,16(a2)
40005424:	00912a23          	sw	s1,20(sp)
40005428:	01212823          	sw	s2,16(sp)
4000542c:	00112e23          	sw	ra,28(sp)
40005430:	00812c23          	sw	s0,24(sp)
40005434:	00058913          	mv	s2,a1
40005438:	00060493          	mv	s1,a2
4000543c:	0149dc63          	ble	s4,s3,40005454 <__multiply+0x44>
40005440:	00098713          	mv	a4,s3
40005444:	00060913          	mv	s2,a2
40005448:	000a0993          	mv	s3,s4
4000544c:	00058493          	mv	s1,a1
40005450:	00070a13          	mv	s4,a4
40005454:	00892783          	lw	a5,8(s2)
40005458:	00492583          	lw	a1,4(s2)
4000545c:	01498433          	add	s0,s3,s4
40005460:	0087a7b3          	slt	a5,a5,s0
40005464:	00f585b3          	add	a1,a1,a5
40005468:	b59ff0ef          	jal	ra,40004fc0 <_Balloc>
4000546c:	01450313          	addi	t1,a0,20
40005470:	00241893          	slli	a7,s0,0x2
40005474:	011308b3          	add	a7,t1,a7
40005478:	00030793          	mv	a5,t1
4000547c:	01137863          	bleu	a7,t1,4000548c <__multiply+0x7c>
40005480:	0007a023          	sw	zero,0(a5)
40005484:	00478793          	addi	a5,a5,4
40005488:	ff17ece3          	bltu	a5,a7,40005480 <__multiply+0x70>
4000548c:	01448813          	addi	a6,s1,20
40005490:	002a1e13          	slli	t3,s4,0x2
40005494:	01490e93          	addi	t4,s2,20
40005498:	00299593          	slli	a1,s3,0x2
4000549c:	00010637          	lui	a2,0x10
400054a0:	01c80e33          	add	t3,a6,t3
400054a4:	00be85b3          	add	a1,t4,a1
400054a8:	fff60613          	addi	a2,a2,-1 # ffff <_heap_size+0xdfff>
400054ac:	0fc87c63          	bleu	t3,a6,400055a4 <__multiply+0x194>
400054b0:	00082383          	lw	t2,0(a6)
400054b4:	00c3f4b3          	and	s1,t2,a2
400054b8:	06048663          	beqz	s1,40005524 <__multiply+0x114>
400054bc:	00030f93          	mv	t6,t1
400054c0:	000e8293          	mv	t0,t4
400054c4:	00000393          	li	t2,0
400054c8:	0002a703          	lw	a4,0(t0) # 40004f90 <memset+0xb4>
400054cc:	000faf03          	lw	t5,0(t6)
400054d0:	004f8f93          	addi	t6,t6,4
400054d4:	00c776b3          	and	a3,a4,a2
400054d8:	029686b3          	mul	a3,a3,s1
400054dc:	01075793          	srli	a5,a4,0x10
400054e0:	00cf7733          	and	a4,t5,a2
400054e4:	010f5f13          	srli	t5,t5,0x10
400054e8:	00428293          	addi	t0,t0,4
400054ec:	029787b3          	mul	a5,a5,s1
400054f0:	00e686b3          	add	a3,a3,a4
400054f4:	007686b3          	add	a3,a3,t2
400054f8:	0106d713          	srli	a4,a3,0x10
400054fc:	00c6f6b3          	and	a3,a3,a2
40005500:	01e787b3          	add	a5,a5,t5
40005504:	00e787b3          	add	a5,a5,a4
40005508:	01079713          	slli	a4,a5,0x10
4000550c:	00d766b3          	or	a3,a4,a3
40005510:	fedfae23          	sw	a3,-4(t6)
40005514:	0107d393          	srli	t2,a5,0x10
40005518:	fab2e8e3          	bltu	t0,a1,400054c8 <__multiply+0xb8>
4000551c:	007fa023          	sw	t2,0(t6)
40005520:	00082383          	lw	t2,0(a6)
40005524:	0103d393          	srli	t2,t2,0x10
40005528:	06038863          	beqz	t2,40005598 <__multiply+0x188>
4000552c:	00032703          	lw	a4,0(t1)
40005530:	00030f13          	mv	t5,t1
40005534:	000e8693          	mv	a3,t4
40005538:	00070293          	mv	t0,a4
4000553c:	00000f93          	li	t6,0
40005540:	0006a783          	lw	a5,0(a3)
40005544:	0102d913          	srli	s2,t0,0x10
40005548:	00c77733          	and	a4,a4,a2
4000554c:	00c7f7b3          	and	a5,a5,a2
40005550:	027787b3          	mul	a5,a5,t2
40005554:	004f0f13          	addi	t5,t5,4
40005558:	00468693          	addi	a3,a3,4
4000555c:	000f2283          	lw	t0,0(t5)
40005560:	00c2f4b3          	and	s1,t0,a2
40005564:	012787b3          	add	a5,a5,s2
40005568:	01f787b3          	add	a5,a5,t6
4000556c:	01079f93          	slli	t6,a5,0x10
40005570:	00efe733          	or	a4,t6,a4
40005574:	feef2e23          	sw	a4,-4(t5)
40005578:	ffe6d703          	lhu	a4,-2(a3)
4000557c:	0107d793          	srli	a5,a5,0x10
40005580:	02770733          	mul	a4,a4,t2
40005584:	00970733          	add	a4,a4,s1
40005588:	00f70733          	add	a4,a4,a5
4000558c:	01075f93          	srli	t6,a4,0x10
40005590:	fab6e8e3          	bltu	a3,a1,40005540 <__multiply+0x130>
40005594:	00ef2023          	sw	a4,0(t5)
40005598:	00480813          	addi	a6,a6,4
4000559c:	00430313          	addi	t1,t1,4
400055a0:	f1c868e3          	bltu	a6,t3,400054b0 <__multiply+0xa0>
400055a4:	02805463          	blez	s0,400055cc <__multiply+0x1bc>
400055a8:	ffc8a783          	lw	a5,-4(a7)
400055ac:	ffc88893          	addi	a7,a7,-4
400055b0:	00078863          	beqz	a5,400055c0 <__multiply+0x1b0>
400055b4:	0180006f          	j	400055cc <__multiply+0x1bc>
400055b8:	0008a783          	lw	a5,0(a7)
400055bc:	00079863          	bnez	a5,400055cc <__multiply+0x1bc>
400055c0:	fff40413          	addi	s0,s0,-1
400055c4:	ffc88893          	addi	a7,a7,-4
400055c8:	fe0418e3          	bnez	s0,400055b8 <__multiply+0x1a8>
400055cc:	01c12083          	lw	ra,28(sp)
400055d0:	00852823          	sw	s0,16(a0)
400055d4:	01412483          	lw	s1,20(sp)
400055d8:	01812403          	lw	s0,24(sp)
400055dc:	01012903          	lw	s2,16(sp)
400055e0:	00c12983          	lw	s3,12(sp)
400055e4:	00812a03          	lw	s4,8(sp)
400055e8:	02010113          	addi	sp,sp,32
400055ec:	00008067          	ret

400055f0 <__pow5mult>:
400055f0:	fe010113          	addi	sp,sp,-32
400055f4:	00812c23          	sw	s0,24(sp)
400055f8:	01312623          	sw	s3,12(sp)
400055fc:	01412423          	sw	s4,8(sp)
40005600:	00112e23          	sw	ra,28(sp)
40005604:	00912a23          	sw	s1,20(sp)
40005608:	01212823          	sw	s2,16(sp)
4000560c:	00367793          	andi	a5,a2,3
40005610:	00060413          	mv	s0,a2
40005614:	00050993          	mv	s3,a0
40005618:	00058a13          	mv	s4,a1
4000561c:	0c079463          	bnez	a5,400056e4 <__pow5mult+0xf4>
40005620:	40245413          	srai	s0,s0,0x2
40005624:	000a0913          	mv	s2,s4
40005628:	06040863          	beqz	s0,40005698 <__pow5mult+0xa8>
4000562c:	0489a483          	lw	s1,72(s3)
40005630:	0c048e63          	beqz	s1,4000570c <__pow5mult+0x11c>
40005634:	00147793          	andi	a5,s0,1
40005638:	000a0913          	mv	s2,s4
4000563c:	02079063          	bnez	a5,4000565c <__pow5mult+0x6c>
40005640:	40145413          	srai	s0,s0,0x1
40005644:	04040a63          	beqz	s0,40005698 <__pow5mult+0xa8>
40005648:	0004a503          	lw	a0,0(s1)
4000564c:	06050863          	beqz	a0,400056bc <__pow5mult+0xcc>
40005650:	00050493          	mv	s1,a0
40005654:	00147793          	andi	a5,s0,1
40005658:	fe0784e3          	beqz	a5,40005640 <__pow5mult+0x50>
4000565c:	00048613          	mv	a2,s1
40005660:	00090593          	mv	a1,s2
40005664:	00098513          	mv	a0,s3
40005668:	da9ff0ef          	jal	ra,40005410 <__multiply>
4000566c:	06090863          	beqz	s2,400056dc <__pow5mult+0xec>
40005670:	00492703          	lw	a4,4(s2)
40005674:	04c9a783          	lw	a5,76(s3)
40005678:	40145413          	srai	s0,s0,0x1
4000567c:	00271713          	slli	a4,a4,0x2
40005680:	00e787b3          	add	a5,a5,a4
40005684:	0007a703          	lw	a4,0(a5)
40005688:	00e92023          	sw	a4,0(s2)
4000568c:	0127a023          	sw	s2,0(a5)
40005690:	00050913          	mv	s2,a0
40005694:	fa041ae3          	bnez	s0,40005648 <__pow5mult+0x58>
40005698:	01c12083          	lw	ra,28(sp)
4000569c:	00090513          	mv	a0,s2
400056a0:	01812403          	lw	s0,24(sp)
400056a4:	01412483          	lw	s1,20(sp)
400056a8:	01012903          	lw	s2,16(sp)
400056ac:	00c12983          	lw	s3,12(sp)
400056b0:	00812a03          	lw	s4,8(sp)
400056b4:	02010113          	addi	sp,sp,32
400056b8:	00008067          	ret
400056bc:	00048613          	mv	a2,s1
400056c0:	00048593          	mv	a1,s1
400056c4:	00098513          	mv	a0,s3
400056c8:	d49ff0ef          	jal	ra,40005410 <__multiply>
400056cc:	00a4a023          	sw	a0,0(s1)
400056d0:	00052023          	sw	zero,0(a0)
400056d4:	00050493          	mv	s1,a0
400056d8:	f7dff06f          	j	40005654 <__pow5mult+0x64>
400056dc:	00050913          	mv	s2,a0
400056e0:	f61ff06f          	j	40005640 <__pow5mult+0x50>
400056e4:	fff78793          	addi	a5,a5,-1
400056e8:	4000c737          	lui	a4,0x4000c
400056ec:	80870713          	addi	a4,a4,-2040 # 4000b808 <p05.2481>
400056f0:	00279793          	slli	a5,a5,0x2
400056f4:	00f707b3          	add	a5,a4,a5
400056f8:	0007a603          	lw	a2,0(a5)
400056fc:	00000693          	li	a3,0
40005700:	989ff0ef          	jal	ra,40005088 <__multadd>
40005704:	00050a13          	mv	s4,a0
40005708:	f19ff06f          	j	40005620 <__pow5mult+0x30>
4000570c:	00100593          	li	a1,1
40005710:	00098513          	mv	a0,s3
40005714:	8adff0ef          	jal	ra,40004fc0 <_Balloc>
40005718:	27100793          	li	a5,625
4000571c:	00f52a23          	sw	a5,20(a0)
40005720:	00100793          	li	a5,1
40005724:	00f52823          	sw	a5,16(a0)
40005728:	04a9a423          	sw	a0,72(s3)
4000572c:	00050493          	mv	s1,a0
40005730:	00052023          	sw	zero,0(a0)
40005734:	f01ff06f          	j	40005634 <__pow5mult+0x44>

40005738 <__lshift>:
40005738:	fe010113          	addi	sp,sp,-32
4000573c:	01412423          	sw	s4,8(sp)
40005740:	0105aa03          	lw	s4,16(a1)
40005744:	00812c23          	sw	s0,24(sp)
40005748:	0085a783          	lw	a5,8(a1)
4000574c:	40565413          	srai	s0,a2,0x5
40005750:	01440a33          	add	s4,s0,s4
40005754:	00912a23          	sw	s1,20(sp)
40005758:	01212823          	sw	s2,16(sp)
4000575c:	01312623          	sw	s3,12(sp)
40005760:	01512223          	sw	s5,4(sp)
40005764:	00112e23          	sw	ra,28(sp)
40005768:	001a0493          	addi	s1,s4,1
4000576c:	00058993          	mv	s3,a1
40005770:	00060913          	mv	s2,a2
40005774:	00050a93          	mv	s5,a0
40005778:	0045a583          	lw	a1,4(a1)
4000577c:	0097d863          	ble	s1,a5,4000578c <__lshift+0x54>
40005780:	00179793          	slli	a5,a5,0x1
40005784:	00158593          	addi	a1,a1,1
40005788:	fe97cce3          	blt	a5,s1,40005780 <__lshift+0x48>
4000578c:	000a8513          	mv	a0,s5
40005790:	831ff0ef          	jal	ra,40004fc0 <_Balloc>
40005794:	01450793          	addi	a5,a0,20
40005798:	0e805063          	blez	s0,40005878 <__lshift+0x140>
4000579c:	00241713          	slli	a4,s0,0x2
400057a0:	00e78733          	add	a4,a5,a4
400057a4:	00478793          	addi	a5,a5,4
400057a8:	fe07ae23          	sw	zero,-4(a5)
400057ac:	fee79ce3          	bne	a5,a4,400057a4 <__lshift+0x6c>
400057b0:	0109a803          	lw	a6,16(s3)
400057b4:	01498793          	addi	a5,s3,20
400057b8:	01f97613          	andi	a2,s2,31
400057bc:	00281813          	slli	a6,a6,0x2
400057c0:	01078833          	add	a6,a5,a6
400057c4:	08060463          	beqz	a2,4000584c <__lshift+0x114>
400057c8:	02000893          	li	a7,32
400057cc:	40c888b3          	sub	a7,a7,a2
400057d0:	00000593          	li	a1,0
400057d4:	0007a683          	lw	a3,0(a5)
400057d8:	00470713          	addi	a4,a4,4
400057dc:	00478793          	addi	a5,a5,4
400057e0:	00c696b3          	sll	a3,a3,a2
400057e4:	00b6e6b3          	or	a3,a3,a1
400057e8:	fed72e23          	sw	a3,-4(a4)
400057ec:	ffc7a683          	lw	a3,-4(a5)
400057f0:	0116d5b3          	srl	a1,a3,a7
400057f4:	ff07e0e3          	bltu	a5,a6,400057d4 <__lshift+0x9c>
400057f8:	00b72023          	sw	a1,0(a4)
400057fc:	00058463          	beqz	a1,40005804 <__lshift+0xcc>
40005800:	002a0493          	addi	s1,s4,2
40005804:	0049a703          	lw	a4,4(s3)
40005808:	04caa783          	lw	a5,76(s5)
4000580c:	fff48493          	addi	s1,s1,-1
40005810:	00271713          	slli	a4,a4,0x2
40005814:	00e787b3          	add	a5,a5,a4
40005818:	0007a703          	lw	a4,0(a5)
4000581c:	01c12083          	lw	ra,28(sp)
40005820:	00952823          	sw	s1,16(a0)
40005824:	00e9a023          	sw	a4,0(s3)
40005828:	0137a023          	sw	s3,0(a5)
4000582c:	01812403          	lw	s0,24(sp)
40005830:	01412483          	lw	s1,20(sp)
40005834:	01012903          	lw	s2,16(sp)
40005838:	00c12983          	lw	s3,12(sp)
4000583c:	00812a03          	lw	s4,8(sp)
40005840:	00412a83          	lw	s5,4(sp)
40005844:	02010113          	addi	sp,sp,32
40005848:	00008067          	ret
4000584c:	00478793          	addi	a5,a5,4
40005850:	ffc7a683          	lw	a3,-4(a5)
40005854:	00470713          	addi	a4,a4,4
40005858:	fed72e23          	sw	a3,-4(a4)
4000585c:	fb07f4e3          	bleu	a6,a5,40005804 <__lshift+0xcc>
40005860:	00478793          	addi	a5,a5,4
40005864:	ffc7a683          	lw	a3,-4(a5)
40005868:	00470713          	addi	a4,a4,4
4000586c:	fed72e23          	sw	a3,-4(a4)
40005870:	fd07eee3          	bltu	a5,a6,4000584c <__lshift+0x114>
40005874:	f91ff06f          	j	40005804 <__lshift+0xcc>
40005878:	00078713          	mv	a4,a5
4000587c:	f35ff06f          	j	400057b0 <__lshift+0x78>

40005880 <__mcmp>:
40005880:	01052683          	lw	a3,16(a0)
40005884:	0105a703          	lw	a4,16(a1)
40005888:	00050813          	mv	a6,a0
4000588c:	40e68533          	sub	a0,a3,a4
40005890:	04051263          	bnez	a0,400058d4 <__mcmp+0x54>
40005894:	00271713          	slli	a4,a4,0x2
40005898:	01480813          	addi	a6,a6,20
4000589c:	01458593          	addi	a1,a1,20
400058a0:	00e807b3          	add	a5,a6,a4
400058a4:	00e58733          	add	a4,a1,a4
400058a8:	0080006f          	j	400058b0 <__mcmp+0x30>
400058ac:	02f87463          	bleu	a5,a6,400058d4 <__mcmp+0x54>
400058b0:	ffc78793          	addi	a5,a5,-4
400058b4:	ffc70713          	addi	a4,a4,-4
400058b8:	0007a683          	lw	a3,0(a5)
400058bc:	00072603          	lw	a2,0(a4)
400058c0:	fec686e3          	beq	a3,a2,400058ac <__mcmp+0x2c>
400058c4:	00c6b6b3          	sltu	a3,a3,a2
400058c8:	40d006b3          	neg	a3,a3
400058cc:	0016e513          	ori	a0,a3,1
400058d0:	00008067          	ret
400058d4:	00008067          	ret

400058d8 <__mdiff>:
400058d8:	fe010113          	addi	sp,sp,-32
400058dc:	01212823          	sw	s2,16(sp)
400058e0:	01062703          	lw	a4,16(a2)
400058e4:	0105a903          	lw	s2,16(a1)
400058e8:	01312623          	sw	s3,12(sp)
400058ec:	01412423          	sw	s4,8(sp)
400058f0:	00112e23          	sw	ra,28(sp)
400058f4:	00812c23          	sw	s0,24(sp)
400058f8:	00912a23          	sw	s1,20(sp)
400058fc:	40e90933          	sub	s2,s2,a4
40005900:	00058993          	mv	s3,a1
40005904:	00060a13          	mv	s4,a2
40005908:	04091863          	bnez	s2,40005958 <__mdiff+0x80>
4000590c:	00271713          	slli	a4,a4,0x2
40005910:	01458313          	addi	t1,a1,20
40005914:	01460493          	addi	s1,a2,20
40005918:	00e307b3          	add	a5,t1,a4
4000591c:	00e48733          	add	a4,s1,a4
40005920:	0080006f          	j	40005928 <__mdiff+0x50>
40005924:	16f37863          	bleu	a5,t1,40005a94 <__mdiff+0x1bc>
40005928:	ffc78793          	addi	a5,a5,-4
4000592c:	ffc70713          	addi	a4,a4,-4
40005930:	0007a583          	lw	a1,0(a5)
40005934:	00072683          	lw	a3,0(a4)
40005938:	fed586e3          	beq	a1,a3,40005924 <__mdiff+0x4c>
4000593c:	18d5f663          	bleu	a3,a1,40005ac8 <__mdiff+0x1f0>
40005940:	00098793          	mv	a5,s3
40005944:	00030413          	mv	s0,t1
40005948:	000a0993          	mv	s3,s4
4000594c:	00100913          	li	s2,1
40005950:	00078a13          	mv	s4,a5
40005954:	0140006f          	j	40005968 <__mdiff+0x90>
40005958:	16094e63          	bltz	s2,40005ad4 <__mdiff+0x1fc>
4000595c:	01498493          	addi	s1,s3,20
40005960:	014a0413          	addi	s0,s4,20
40005964:	00000913          	li	s2,0
40005968:	0049a583          	lw	a1,4(s3)
4000596c:	e54ff0ef          	jal	ra,40004fc0 <_Balloc>
40005970:	0109ae03          	lw	t3,16(s3)
40005974:	010a2f03          	lw	t5,16(s4)
40005978:	00010637          	lui	a2,0x10
4000597c:	002e1e93          	slli	t4,t3,0x2
40005980:	002f1f13          	slli	t5,t5,0x2
40005984:	01252623          	sw	s2,12(a0)
40005988:	01d48eb3          	add	t4,s1,t4
4000598c:	01e40f33          	add	t5,s0,t5
40005990:	01450593          	addi	a1,a0,20
40005994:	00040893          	mv	a7,s0
40005998:	00048313          	mv	t1,s1
4000599c:	00000793          	li	a5,0
400059a0:	fff60613          	addi	a2,a2,-1 # ffff <_heap_size+0xdfff>
400059a4:	0080006f          	j	400059ac <__mdiff+0xd4>
400059a8:	00080313          	mv	t1,a6
400059ac:	00032703          	lw	a4,0(t1)
400059b0:	0008a803          	lw	a6,0(a7)
400059b4:	00458593          	addi	a1,a1,4
400059b8:	00c776b3          	and	a3,a4,a2
400059bc:	00f686b3          	add	a3,a3,a5
400059c0:	00c877b3          	and	a5,a6,a2
400059c4:	40f686b3          	sub	a3,a3,a5
400059c8:	01085813          	srli	a6,a6,0x10
400059cc:	01075793          	srli	a5,a4,0x10
400059d0:	410787b3          	sub	a5,a5,a6
400059d4:	4106d713          	srai	a4,a3,0x10
400059d8:	00e787b3          	add	a5,a5,a4
400059dc:	01079713          	slli	a4,a5,0x10
400059e0:	00c6f6b3          	and	a3,a3,a2
400059e4:	00d766b3          	or	a3,a4,a3
400059e8:	00488893          	addi	a7,a7,4
400059ec:	fed5ae23          	sw	a3,-4(a1)
400059f0:	00430813          	addi	a6,t1,4
400059f4:	4107d793          	srai	a5,a5,0x10
400059f8:	fbe8e8e3          	bltu	a7,t5,400059a8 <__mdiff+0xd0>
400059fc:	05d87e63          	bleu	t4,a6,40005a58 <__mdiff+0x180>
40005a00:	00010f37          	lui	t5,0x10
40005a04:	00058893          	mv	a7,a1
40005a08:	ffff0f13          	addi	t5,t5,-1 # ffff <_heap_size+0xdfff>
40005a0c:	00082703          	lw	a4,0(a6)
40005a10:	00488893          	addi	a7,a7,4
40005a14:	00480813          	addi	a6,a6,4
40005a18:	01e77633          	and	a2,a4,t5
40005a1c:	00f60633          	add	a2,a2,a5
40005a20:	41065693          	srai	a3,a2,0x10
40005a24:	01075793          	srli	a5,a4,0x10
40005a28:	00d787b3          	add	a5,a5,a3
40005a2c:	01079693          	slli	a3,a5,0x10
40005a30:	01e67633          	and	a2,a2,t5
40005a34:	00c6e6b3          	or	a3,a3,a2
40005a38:	fed8ae23          	sw	a3,-4(a7)
40005a3c:	4107d793          	srai	a5,a5,0x10
40005a40:	fdd866e3          	bltu	a6,t4,40005a0c <__mdiff+0x134>
40005a44:	406e87b3          	sub	a5,t4,t1
40005a48:	ffb78793          	addi	a5,a5,-5
40005a4c:	ffc7f793          	andi	a5,a5,-4
40005a50:	00478793          	addi	a5,a5,4
40005a54:	00f585b3          	add	a1,a1,a5
40005a58:	ffc58593          	addi	a1,a1,-4
40005a5c:	00069a63          	bnez	a3,40005a70 <__mdiff+0x198>
40005a60:	ffc58593          	addi	a1,a1,-4
40005a64:	0005a783          	lw	a5,0(a1)
40005a68:	fffe0e13          	addi	t3,t3,-1
40005a6c:	fe078ae3          	beqz	a5,40005a60 <__mdiff+0x188>
40005a70:	01c12083          	lw	ra,28(sp)
40005a74:	01812403          	lw	s0,24(sp)
40005a78:	01412483          	lw	s1,20(sp)
40005a7c:	01012903          	lw	s2,16(sp)
40005a80:	00c12983          	lw	s3,12(sp)
40005a84:	00812a03          	lw	s4,8(sp)
40005a88:	01c52823          	sw	t3,16(a0)
40005a8c:	02010113          	addi	sp,sp,32
40005a90:	00008067          	ret
40005a94:	00000593          	li	a1,0
40005a98:	d28ff0ef          	jal	ra,40004fc0 <_Balloc>
40005a9c:	01c12083          	lw	ra,28(sp)
40005aa0:	00100793          	li	a5,1
40005aa4:	01812403          	lw	s0,24(sp)
40005aa8:	01412483          	lw	s1,20(sp)
40005aac:	01012903          	lw	s2,16(sp)
40005ab0:	00c12983          	lw	s3,12(sp)
40005ab4:	00812a03          	lw	s4,8(sp)
40005ab8:	00f52823          	sw	a5,16(a0)
40005abc:	00052a23          	sw	zero,20(a0)
40005ac0:	02010113          	addi	sp,sp,32
40005ac4:	00008067          	ret
40005ac8:	00048413          	mv	s0,s1
40005acc:	00030493          	mv	s1,t1
40005ad0:	e99ff06f          	j	40005968 <__mdiff+0x90>
40005ad4:	01460493          	addi	s1,a2,20
40005ad8:	01458413          	addi	s0,a1,20
40005adc:	00100913          	li	s2,1
40005ae0:	00060993          	mv	s3,a2
40005ae4:	00058a13          	mv	s4,a1
40005ae8:	e81ff06f          	j	40005968 <__mdiff+0x90>

40005aec <__ulp>:
40005aec:	7ff007b7          	lui	a5,0x7ff00
40005af0:	00b7f5b3          	and	a1,a5,a1
40005af4:	fcc007b7          	lui	a5,0xfcc00
40005af8:	00f585b3          	add	a1,a1,a5
40005afc:	00b05863          	blez	a1,40005b0c <__ulp+0x20>
40005b00:	00000793          	li	a5,0
40005b04:	00078513          	mv	a0,a5
40005b08:	00008067          	ret
40005b0c:	40b005b3          	neg	a1,a1
40005b10:	4145d593          	srai	a1,a1,0x14
40005b14:	01300793          	li	a5,19
40005b18:	02b7d463          	ble	a1,a5,40005b40 <__ulp+0x54>
40005b1c:	fec58713          	addi	a4,a1,-20
40005b20:	01e00693          	li	a3,30
40005b24:	00000593          	li	a1,0
40005b28:	00100793          	li	a5,1
40005b2c:	fce6cce3          	blt	a3,a4,40005b04 <__ulp+0x18>
40005b30:	fff74713          	not	a4,a4
40005b34:	00e797b3          	sll	a5,a5,a4
40005b38:	00078513          	mv	a0,a5
40005b3c:	00008067          	ret
40005b40:	000807b7          	lui	a5,0x80
40005b44:	40b7d5b3          	sra	a1,a5,a1
40005b48:	fb9ff06f          	j	40005b00 <__ulp+0x14>

40005b4c <__b2d>:
40005b4c:	fe010113          	addi	sp,sp,-32
40005b50:	00812c23          	sw	s0,24(sp)
40005b54:	01052403          	lw	s0,16(a0)
40005b58:	00912a23          	sw	s1,20(sp)
40005b5c:	01450493          	addi	s1,a0,20
40005b60:	00241413          	slli	s0,s0,0x2
40005b64:	00848433          	add	s0,s1,s0
40005b68:	01212823          	sw	s2,16(sp)
40005b6c:	ffc42903          	lw	s2,-4(s0)
40005b70:	01312623          	sw	s3,12(sp)
40005b74:	01412423          	sw	s4,8(sp)
40005b78:	00090513          	mv	a0,s2
40005b7c:	00058a13          	mv	s4,a1
40005b80:	00112e23          	sw	ra,28(sp)
40005b84:	f28ff0ef          	jal	ra,400052ac <__hi0bits>
40005b88:	02000713          	li	a4,32
40005b8c:	40a707b3          	sub	a5,a4,a0
40005b90:	00fa2023          	sw	a5,0(s4)
40005b94:	00a00793          	li	a5,10
40005b98:	ffc40993          	addi	s3,s0,-4
40005b9c:	04a7ce63          	blt	a5,a0,40005bf8 <__b2d+0xac>
40005ba0:	00b00693          	li	a3,11
40005ba4:	40a686b3          	sub	a3,a3,a0
40005ba8:	3ff007b7          	lui	a5,0x3ff00
40005bac:	00d95733          	srl	a4,s2,a3
40005bb0:	00f76733          	or	a4,a4,a5
40005bb4:	00000793          	li	a5,0
40005bb8:	0134f663          	bleu	s3,s1,40005bc4 <__b2d+0x78>
40005bbc:	ff842783          	lw	a5,-8(s0)
40005bc0:	00d7d7b3          	srl	a5,a5,a3
40005bc4:	01550513          	addi	a0,a0,21
40005bc8:	00a91533          	sll	a0,s2,a0
40005bcc:	00f567b3          	or	a5,a0,a5
40005bd0:	01c12083          	lw	ra,28(sp)
40005bd4:	00078513          	mv	a0,a5
40005bd8:	00070593          	mv	a1,a4
40005bdc:	01812403          	lw	s0,24(sp)
40005be0:	01412483          	lw	s1,20(sp)
40005be4:	01012903          	lw	s2,16(sp)
40005be8:	00c12983          	lw	s3,12(sp)
40005bec:	00812a03          	lw	s4,8(sp)
40005bf0:	02010113          	addi	sp,sp,32
40005bf4:	00008067          	ret
40005bf8:	ff550513          	addi	a0,a0,-11
40005bfc:	0534f063          	bleu	s3,s1,40005c3c <__b2d+0xf0>
40005c00:	ff842783          	lw	a5,-8(s0)
40005c04:	04050063          	beqz	a0,40005c44 <__b2d+0xf8>
40005c08:	40a706b3          	sub	a3,a4,a0
40005c0c:	00a91933          	sll	s2,s2,a0
40005c10:	3ff00737          	lui	a4,0x3ff00
40005c14:	00e96933          	or	s2,s2,a4
40005c18:	ff840613          	addi	a2,s0,-8
40005c1c:	00d7d733          	srl	a4,a5,a3
40005c20:	00e96733          	or	a4,s2,a4
40005c24:	04c4f063          	bleu	a2,s1,40005c64 <__b2d+0x118>
40005c28:	ff442603          	lw	a2,-12(s0)
40005c2c:	00a797b3          	sll	a5,a5,a0
40005c30:	00d656b3          	srl	a3,a2,a3
40005c34:	00f6e7b3          	or	a5,a3,a5
40005c38:	f99ff06f          	j	40005bd0 <__b2d+0x84>
40005c3c:	00000793          	li	a5,0
40005c40:	00051863          	bnez	a0,40005c50 <__b2d+0x104>
40005c44:	3ff00737          	lui	a4,0x3ff00
40005c48:	00e96733          	or	a4,s2,a4
40005c4c:	f85ff06f          	j	40005bd0 <__b2d+0x84>
40005c50:	00a91533          	sll	a0,s2,a0
40005c54:	3ff00737          	lui	a4,0x3ff00
40005c58:	00e56733          	or	a4,a0,a4
40005c5c:	00000793          	li	a5,0
40005c60:	f71ff06f          	j	40005bd0 <__b2d+0x84>
40005c64:	00a797b3          	sll	a5,a5,a0
40005c68:	f69ff06f          	j	40005bd0 <__b2d+0x84>

40005c6c <__d2b>:
40005c6c:	fd010113          	addi	sp,sp,-48
40005c70:	00100593          	li	a1,1
40005c74:	02812423          	sw	s0,40(sp)
40005c78:	02912223          	sw	s1,36(sp)
40005c7c:	00068413          	mv	s0,a3
40005c80:	03212023          	sw	s2,32(sp)
40005c84:	01312e23          	sw	s3,28(sp)
40005c88:	01412c23          	sw	s4,24(sp)
40005c8c:	01512a23          	sw	s5,20(sp)
40005c90:	00070a13          	mv	s4,a4
40005c94:	00060a93          	mv	s5,a2
40005c98:	00078993          	mv	s3,a5
40005c9c:	02112623          	sw	ra,44(sp)
40005ca0:	b20ff0ef          	jal	ra,40004fc0 <_Balloc>
40005ca4:	00100737          	lui	a4,0x100
40005ca8:	01445493          	srli	s1,s0,0x14
40005cac:	fff70793          	addi	a5,a4,-1 # fffff <_heap_size+0xfdfff>
40005cb0:	7ff4f493          	andi	s1,s1,2047
40005cb4:	00050913          	mv	s2,a0
40005cb8:	000a8613          	mv	a2,s5
40005cbc:	0087f6b3          	and	a3,a5,s0
40005cc0:	00048463          	beqz	s1,40005cc8 <__d2b+0x5c>
40005cc4:	00e6e6b3          	or	a3,a3,a4
40005cc8:	00d12623          	sw	a3,12(sp)
40005ccc:	08060263          	beqz	a2,40005d50 <__d2b+0xe4>
40005cd0:	00810513          	addi	a0,sp,8
40005cd4:	01512423          	sw	s5,8(sp)
40005cd8:	e48ff0ef          	jal	ra,40005320 <__lo0bits>
40005cdc:	00050793          	mv	a5,a0
40005ce0:	00c12703          	lw	a4,12(sp)
40005ce4:	0a051463          	bnez	a0,40005d8c <__d2b+0x120>
40005ce8:	00812683          	lw	a3,8(sp)
40005cec:	00d92a23          	sw	a3,20(s2)
40005cf0:	00e03433          	snez	s0,a4
40005cf4:	00140413          	addi	s0,s0,1
40005cf8:	00e92c23          	sw	a4,24(s2)
40005cfc:	00892823          	sw	s0,16(s2)
40005d00:	06049863          	bnez	s1,40005d70 <__d2b+0x104>
40005d04:	00241713          	slli	a4,s0,0x2
40005d08:	00e90733          	add	a4,s2,a4
40005d0c:	01072503          	lw	a0,16(a4)
40005d10:	bce78793          	addi	a5,a5,-1074 # 3feffbce <_heap_size+0x3fefdbce>
40005d14:	00fa2023          	sw	a5,0(s4)
40005d18:	d94ff0ef          	jal	ra,400052ac <__hi0bits>
40005d1c:	00541413          	slli	s0,s0,0x5
40005d20:	40a40433          	sub	s0,s0,a0
40005d24:	0089a023          	sw	s0,0(s3)
40005d28:	02c12083          	lw	ra,44(sp)
40005d2c:	00090513          	mv	a0,s2
40005d30:	02812403          	lw	s0,40(sp)
40005d34:	02412483          	lw	s1,36(sp)
40005d38:	02012903          	lw	s2,32(sp)
40005d3c:	01c12983          	lw	s3,28(sp)
40005d40:	01812a03          	lw	s4,24(sp)
40005d44:	01412a83          	lw	s5,20(sp)
40005d48:	03010113          	addi	sp,sp,48
40005d4c:	00008067          	ret
40005d50:	00c10513          	addi	a0,sp,12
40005d54:	dccff0ef          	jal	ra,40005320 <__lo0bits>
40005d58:	00c12783          	lw	a5,12(sp)
40005d5c:	00100413          	li	s0,1
40005d60:	00892823          	sw	s0,16(s2)
40005d64:	00f92a23          	sw	a5,20(s2)
40005d68:	02050793          	addi	a5,a0,32
40005d6c:	f8048ce3          	beqz	s1,40005d04 <__d2b+0x98>
40005d70:	bcd48493          	addi	s1,s1,-1075
40005d74:	00f484b3          	add	s1,s1,a5
40005d78:	03500713          	li	a4,53
40005d7c:	009a2023          	sw	s1,0(s4)
40005d80:	40f707b3          	sub	a5,a4,a5
40005d84:	00f9a023          	sw	a5,0(s3)
40005d88:	fa1ff06f          	j	40005d28 <__d2b+0xbc>
40005d8c:	02000693          	li	a3,32
40005d90:	00812603          	lw	a2,8(sp)
40005d94:	40a686b3          	sub	a3,a3,a0
40005d98:	00d716b3          	sll	a3,a4,a3
40005d9c:	00c6e6b3          	or	a3,a3,a2
40005da0:	00a75733          	srl	a4,a4,a0
40005da4:	00d92a23          	sw	a3,20(s2)
40005da8:	00e12623          	sw	a4,12(sp)
40005dac:	f45ff06f          	j	40005cf0 <__d2b+0x84>

40005db0 <__ratio>:
40005db0:	fd010113          	addi	sp,sp,-48
40005db4:	03212023          	sw	s2,32(sp)
40005db8:	00058913          	mv	s2,a1
40005dbc:	00810593          	addi	a1,sp,8
40005dc0:	02112623          	sw	ra,44(sp)
40005dc4:	02812423          	sw	s0,40(sp)
40005dc8:	02912223          	sw	s1,36(sp)
40005dcc:	01312e23          	sw	s3,28(sp)
40005dd0:	00050993          	mv	s3,a0
40005dd4:	d79ff0ef          	jal	ra,40005b4c <__b2d>
40005dd8:	00050493          	mv	s1,a0
40005ddc:	00058413          	mv	s0,a1
40005de0:	00090513          	mv	a0,s2
40005de4:	00c10593          	addi	a1,sp,12
40005de8:	d65ff0ef          	jal	ra,40005b4c <__b2d>
40005dec:	01092783          	lw	a5,16(s2)
40005df0:	0109a703          	lw	a4,16(s3)
40005df4:	00812683          	lw	a3,8(sp)
40005df8:	40f70733          	sub	a4,a4,a5
40005dfc:	00c12783          	lw	a5,12(sp)
40005e00:	00571713          	slli	a4,a4,0x5
40005e04:	40f686b3          	sub	a3,a3,a5
40005e08:	00d707b3          	add	a5,a4,a3
40005e0c:	02f05e63          	blez	a5,40005e48 <__ratio+0x98>
40005e10:	01479793          	slli	a5,a5,0x14
40005e14:	00878433          	add	s0,a5,s0
40005e18:	00050613          	mv	a2,a0
40005e1c:	00058693          	mv	a3,a1
40005e20:	00048513          	mv	a0,s1
40005e24:	00040593          	mv	a1,s0
40005e28:	5c0030ef          	jal	ra,400093e8 <__divdf3>
40005e2c:	02c12083          	lw	ra,44(sp)
40005e30:	02812403          	lw	s0,40(sp)
40005e34:	02412483          	lw	s1,36(sp)
40005e38:	02012903          	lw	s2,32(sp)
40005e3c:	01c12983          	lw	s3,28(sp)
40005e40:	03010113          	addi	sp,sp,48
40005e44:	00008067          	ret
40005e48:	01479713          	slli	a4,a5,0x14
40005e4c:	40e585b3          	sub	a1,a1,a4
40005e50:	fc9ff06f          	j	40005e18 <__ratio+0x68>

40005e54 <_mprec_log10>:
40005e54:	ff010113          	addi	sp,sp,-16
40005e58:	00812423          	sw	s0,8(sp)
40005e5c:	00112623          	sw	ra,12(sp)
40005e60:	01212223          	sw	s2,4(sp)
40005e64:	01312023          	sw	s3,0(sp)
40005e68:	01700793          	li	a5,23
40005e6c:	00050413          	mv	s0,a0
40005e70:	04a7d463          	ble	a0,a5,40005eb8 <_mprec_log10+0x64>
40005e74:	4000c7b7          	lui	a5,0x4000c
40005e78:	c607a503          	lw	a0,-928(a5) # 4000bc60 <__clz_tab+0x12c>
40005e7c:	c647a583          	lw	a1,-924(a5)
40005e80:	4000c7b7          	lui	a5,0x4000c
40005e84:	c687a903          	lw	s2,-920(a5) # 4000bc68 <__clz_tab+0x134>
40005e88:	c6c7a983          	lw	s3,-916(a5)
40005e8c:	fff40413          	addi	s0,s0,-1
40005e90:	00090613          	mv	a2,s2
40005e94:	00098693          	mv	a3,s3
40005e98:	020040ef          	jal	ra,40009eb8 <__muldf3>
40005e9c:	fe0418e3          	bnez	s0,40005e8c <_mprec_log10+0x38>
40005ea0:	00c12083          	lw	ra,12(sp)
40005ea4:	00812403          	lw	s0,8(sp)
40005ea8:	00412903          	lw	s2,4(sp)
40005eac:	00012983          	lw	s3,0(sp)
40005eb0:	01010113          	addi	sp,sp,16
40005eb4:	00008067          	ret
40005eb8:	4000c7b7          	lui	a5,0x4000c
40005ebc:	00c12083          	lw	ra,12(sp)
40005ec0:	00351413          	slli	s0,a0,0x3
40005ec4:	80878793          	addi	a5,a5,-2040 # 4000b808 <p05.2481>
40005ec8:	00878433          	add	s0,a5,s0
40005ecc:	01042503          	lw	a0,16(s0)
40005ed0:	01442583          	lw	a1,20(s0)
40005ed4:	00412903          	lw	s2,4(sp)
40005ed8:	00812403          	lw	s0,8(sp)
40005edc:	00012983          	lw	s3,0(sp)
40005ee0:	01010113          	addi	sp,sp,16
40005ee4:	00008067          	ret

40005ee8 <__copybits>:
40005ee8:	01062683          	lw	a3,16(a2)
40005eec:	fff58813          	addi	a6,a1,-1
40005ef0:	40585813          	srai	a6,a6,0x5
40005ef4:	00180813          	addi	a6,a6,1
40005ef8:	01460793          	addi	a5,a2,20
40005efc:	00269693          	slli	a3,a3,0x2
40005f00:	00281813          	slli	a6,a6,0x2
40005f04:	00d786b3          	add	a3,a5,a3
40005f08:	01050833          	add	a6,a0,a6
40005f0c:	02d7f863          	bleu	a3,a5,40005f3c <__copybits+0x54>
40005f10:	00050713          	mv	a4,a0
40005f14:	00478793          	addi	a5,a5,4
40005f18:	ffc7a583          	lw	a1,-4(a5)
40005f1c:	00470713          	addi	a4,a4,4
40005f20:	feb72e23          	sw	a1,-4(a4)
40005f24:	fed7e8e3          	bltu	a5,a3,40005f14 <__copybits+0x2c>
40005f28:	40c687b3          	sub	a5,a3,a2
40005f2c:	feb78793          	addi	a5,a5,-21
40005f30:	ffc7f793          	andi	a5,a5,-4
40005f34:	00478793          	addi	a5,a5,4
40005f38:	00f50533          	add	a0,a0,a5
40005f3c:	01057863          	bleu	a6,a0,40005f4c <__copybits+0x64>
40005f40:	00450513          	addi	a0,a0,4
40005f44:	fe052e23          	sw	zero,-4(a0)
40005f48:	ff056ce3          	bltu	a0,a6,40005f40 <__copybits+0x58>
40005f4c:	00008067          	ret

40005f50 <__any_on>:
40005f50:	01052783          	lw	a5,16(a0)
40005f54:	4055d713          	srai	a4,a1,0x5
40005f58:	01450693          	addi	a3,a0,20
40005f5c:	02e7da63          	ble	a4,a5,40005f90 <__any_on+0x40>
40005f60:	00279793          	slli	a5,a5,0x2
40005f64:	00f687b3          	add	a5,a3,a5
40005f68:	06f6f263          	bleu	a5,a3,40005fcc <__any_on+0x7c>
40005f6c:	ffc7a503          	lw	a0,-4(a5)
40005f70:	ffc78793          	addi	a5,a5,-4
40005f74:	00051a63          	bnez	a0,40005f88 <__any_on+0x38>
40005f78:	04f6f863          	bleu	a5,a3,40005fc8 <__any_on+0x78>
40005f7c:	ffc78793          	addi	a5,a5,-4
40005f80:	0007a703          	lw	a4,0(a5)
40005f84:	fe070ae3          	beqz	a4,40005f78 <__any_on+0x28>
40005f88:	00100513          	li	a0,1
40005f8c:	00008067          	ret
40005f90:	02f75663          	ble	a5,a4,40005fbc <__any_on+0x6c>
40005f94:	00271793          	slli	a5,a4,0x2
40005f98:	01f5f593          	andi	a1,a1,31
40005f9c:	00f687b3          	add	a5,a3,a5
40005fa0:	fc0584e3          	beqz	a1,40005f68 <__any_on+0x18>
40005fa4:	0007a603          	lw	a2,0(a5)
40005fa8:	00100513          	li	a0,1
40005fac:	00b65733          	srl	a4,a2,a1
40005fb0:	00b715b3          	sll	a1,a4,a1
40005fb4:	fab60ae3          	beq	a2,a1,40005f68 <__any_on+0x18>
40005fb8:	00008067          	ret
40005fbc:	00271793          	slli	a5,a4,0x2
40005fc0:	00f687b3          	add	a5,a3,a5
40005fc4:	fa5ff06f          	j	40005f68 <__any_on+0x18>
40005fc8:	00008067          	ret
40005fcc:	00000513          	li	a0,0
40005fd0:	00008067          	ret

40005fd4 <_sbrk_r>:
40005fd4:	ff010113          	addi	sp,sp,-16
40005fd8:	00812423          	sw	s0,8(sp)
40005fdc:	00912223          	sw	s1,4(sp)
40005fe0:	4000c437          	lui	s0,0x4000c
40005fe4:	00050493          	mv	s1,a0
40005fe8:	00058513          	mv	a0,a1
40005fec:	00112623          	sw	ra,12(sp)
40005ff0:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
40005ff4:	275020ef          	jal	ra,40008a68 <sbrk>
40005ff8:	fff00793          	li	a5,-1
40005ffc:	00f50c63          	beq	a0,a5,40006014 <_sbrk_r+0x40>
40006000:	00c12083          	lw	ra,12(sp)
40006004:	00812403          	lw	s0,8(sp)
40006008:	00412483          	lw	s1,4(sp)
4000600c:	01010113          	addi	sp,sp,16
40006010:	00008067          	ret
40006014:	68442783          	lw	a5,1668(s0)
40006018:	fe0784e3          	beqz	a5,40006000 <_sbrk_r+0x2c>
4000601c:	00c12083          	lw	ra,12(sp)
40006020:	00f4a023          	sw	a5,0(s1)
40006024:	00812403          	lw	s0,8(sp)
40006028:	00412483          	lw	s1,4(sp)
4000602c:	01010113          	addi	sp,sp,16
40006030:	00008067          	ret

40006034 <__sread>:
40006034:	ff010113          	addi	sp,sp,-16
40006038:	00812423          	sw	s0,8(sp)
4000603c:	00058413          	mv	s0,a1
40006040:	00e59583          	lh	a1,14(a1)
40006044:	00112623          	sw	ra,12(sp)
40006048:	799010ef          	jal	ra,40007fe0 <_read_r>
4000604c:	02054063          	bltz	a0,4000606c <__sread+0x38>
40006050:	05042783          	lw	a5,80(s0)
40006054:	00c12083          	lw	ra,12(sp)
40006058:	00a787b3          	add	a5,a5,a0
4000605c:	04f42823          	sw	a5,80(s0)
40006060:	00812403          	lw	s0,8(sp)
40006064:	01010113          	addi	sp,sp,16
40006068:	00008067          	ret
4000606c:	00c45783          	lhu	a5,12(s0)
40006070:	fffff737          	lui	a4,0xfffff
40006074:	00c12083          	lw	ra,12(sp)
40006078:	fff70713          	addi	a4,a4,-1 # ffffefff <_bss_end+0xbfff2977>
4000607c:	00e7f7b3          	and	a5,a5,a4
40006080:	00f41623          	sh	a5,12(s0)
40006084:	00812403          	lw	s0,8(sp)
40006088:	01010113          	addi	sp,sp,16
4000608c:	00008067          	ret

40006090 <__seofread>:
40006090:	00000513          	li	a0,0
40006094:	00008067          	ret

40006098 <__swrite>:
40006098:	00c59783          	lh	a5,12(a1)
4000609c:	fe010113          	addi	sp,sp,-32
400060a0:	00812c23          	sw	s0,24(sp)
400060a4:	00912a23          	sw	s1,20(sp)
400060a8:	01212823          	sw	s2,16(sp)
400060ac:	01312623          	sw	s3,12(sp)
400060b0:	00112e23          	sw	ra,28(sp)
400060b4:	1007f713          	andi	a4,a5,256
400060b8:	00058413          	mv	s0,a1
400060bc:	00050493          	mv	s1,a0
400060c0:	00060913          	mv	s2,a2
400060c4:	00068993          	mv	s3,a3
400060c8:	00070c63          	beqz	a4,400060e0 <__swrite+0x48>
400060cc:	00e59583          	lh	a1,14(a1)
400060d0:	00200693          	li	a3,2
400060d4:	00000613          	li	a2,0
400060d8:	581010ef          	jal	ra,40007e58 <_lseek_r>
400060dc:	00c41783          	lh	a5,12(s0)
400060e0:	fffff737          	lui	a4,0xfffff
400060e4:	fff70713          	addi	a4,a4,-1 # ffffefff <_bss_end+0xbfff2977>
400060e8:	00e7f7b3          	and	a5,a5,a4
400060ec:	00e41583          	lh	a1,14(s0)
400060f0:	00f41623          	sh	a5,12(s0)
400060f4:	00098693          	mv	a3,s3
400060f8:	00090613          	mv	a2,s2
400060fc:	00048513          	mv	a0,s1
40006100:	01c12083          	lw	ra,28(sp)
40006104:	01812403          	lw	s0,24(sp)
40006108:	01412483          	lw	s1,20(sp)
4000610c:	01012903          	lw	s2,16(sp)
40006110:	00c12983          	lw	s3,12(sp)
40006114:	02010113          	addi	sp,sp,32
40006118:	36c0106f          	j	40007484 <_write_r>

4000611c <__sseek>:
4000611c:	ff010113          	addi	sp,sp,-16
40006120:	00812423          	sw	s0,8(sp)
40006124:	00058413          	mv	s0,a1
40006128:	00e59583          	lh	a1,14(a1)
4000612c:	00070693          	mv	a3,a4
40006130:	00112623          	sw	ra,12(sp)
40006134:	525010ef          	jal	ra,40007e58 <_lseek_r>
40006138:	fff00793          	li	a5,-1
4000613c:	02f50663          	beq	a0,a5,40006168 <__sseek+0x4c>
40006140:	00c45783          	lhu	a5,12(s0)
40006144:	00c12083          	lw	ra,12(sp)
40006148:	00001737          	lui	a4,0x1
4000614c:	00e7e7b3          	or	a5,a5,a4
40006150:	04a42823          	sw	a0,80(s0)
40006154:	00f41623          	sh	a5,12(s0)
40006158:	41f55593          	srai	a1,a0,0x1f
4000615c:	00812403          	lw	s0,8(sp)
40006160:	01010113          	addi	sp,sp,16
40006164:	00008067          	ret
40006168:	00c45783          	lhu	a5,12(s0)
4000616c:	fffff737          	lui	a4,0xfffff
40006170:	00c12083          	lw	ra,12(sp)
40006174:	fff70713          	addi	a4,a4,-1 # ffffefff <_bss_end+0xbfff2977>
40006178:	00e7f7b3          	and	a5,a5,a4
4000617c:	00f41623          	sh	a5,12(s0)
40006180:	41f55593          	srai	a1,a0,0x1f
40006184:	00812403          	lw	s0,8(sp)
40006188:	01010113          	addi	sp,sp,16
4000618c:	00008067          	ret

40006190 <__sclose>:
40006190:	00e59583          	lh	a1,14(a1)
40006194:	4080106f          	j	4000759c <_close_r>

40006198 <strcmp>:
40006198:	00b56733          	or	a4,a0,a1
4000619c:	fff00393          	li	t2,-1
400061a0:	00377713          	andi	a4,a4,3
400061a4:	10071063          	bnez	a4,400062a4 <strcmp+0x10c>
400061a8:	7f7f8e37          	lui	t3,0x7f7f8
400061ac:	f7fe0e13          	addi	t3,t3,-129 # 7f7f7f7f <_bss_end+0x3f7eb8f7>
400061b0:	00052603          	lw	a2,0(a0)
400061b4:	0005a683          	lw	a3,0(a1)
400061b8:	01c672b3          	and	t0,a2,t3
400061bc:	01c66333          	or	t1,a2,t3
400061c0:	01c282b3          	add	t0,t0,t3
400061c4:	0062e2b3          	or	t0,t0,t1
400061c8:	10729263          	bne	t0,t2,400062cc <strcmp+0x134>
400061cc:	08d61663          	bne	a2,a3,40006258 <strcmp+0xc0>
400061d0:	00452603          	lw	a2,4(a0)
400061d4:	0045a683          	lw	a3,4(a1)
400061d8:	01c672b3          	and	t0,a2,t3
400061dc:	01c66333          	or	t1,a2,t3
400061e0:	01c282b3          	add	t0,t0,t3
400061e4:	0062e2b3          	or	t0,t0,t1
400061e8:	0c729e63          	bne	t0,t2,400062c4 <strcmp+0x12c>
400061ec:	06d61663          	bne	a2,a3,40006258 <strcmp+0xc0>
400061f0:	00852603          	lw	a2,8(a0)
400061f4:	0085a683          	lw	a3,8(a1)
400061f8:	01c672b3          	and	t0,a2,t3
400061fc:	01c66333          	or	t1,a2,t3
40006200:	01c282b3          	add	t0,t0,t3
40006204:	0062e2b3          	or	t0,t0,t1
40006208:	0c729863          	bne	t0,t2,400062d8 <strcmp+0x140>
4000620c:	04d61663          	bne	a2,a3,40006258 <strcmp+0xc0>
40006210:	00c52603          	lw	a2,12(a0)
40006214:	00c5a683          	lw	a3,12(a1)
40006218:	01c672b3          	and	t0,a2,t3
4000621c:	01c66333          	or	t1,a2,t3
40006220:	01c282b3          	add	t0,t0,t3
40006224:	0062e2b3          	or	t0,t0,t1
40006228:	0c729263          	bne	t0,t2,400062ec <strcmp+0x154>
4000622c:	02d61663          	bne	a2,a3,40006258 <strcmp+0xc0>
40006230:	01052603          	lw	a2,16(a0)
40006234:	0105a683          	lw	a3,16(a1)
40006238:	01c672b3          	and	t0,a2,t3
4000623c:	01c66333          	or	t1,a2,t3
40006240:	01c282b3          	add	t0,t0,t3
40006244:	0062e2b3          	or	t0,t0,t1
40006248:	0a729c63          	bne	t0,t2,40006300 <strcmp+0x168>
4000624c:	01450513          	addi	a0,a0,20
40006250:	01458593          	addi	a1,a1,20
40006254:	f4d60ee3          	beq	a2,a3,400061b0 <strcmp+0x18>
40006258:	01061713          	slli	a4,a2,0x10
4000625c:	01069793          	slli	a5,a3,0x10
40006260:	00f71e63          	bne	a4,a5,4000627c <strcmp+0xe4>
40006264:	01065713          	srli	a4,a2,0x10
40006268:	0106d793          	srli	a5,a3,0x10
4000626c:	40f70533          	sub	a0,a4,a5
40006270:	0ff57593          	andi	a1,a0,255
40006274:	02059063          	bnez	a1,40006294 <strcmp+0xfc>
40006278:	00008067          	ret
4000627c:	01075713          	srli	a4,a4,0x10
40006280:	0107d793          	srli	a5,a5,0x10
40006284:	40f70533          	sub	a0,a4,a5
40006288:	0ff57593          	andi	a1,a0,255
4000628c:	00059463          	bnez	a1,40006294 <strcmp+0xfc>
40006290:	00008067          	ret
40006294:	0ff77713          	andi	a4,a4,255
40006298:	0ff7f793          	andi	a5,a5,255
4000629c:	40f70533          	sub	a0,a4,a5
400062a0:	00008067          	ret
400062a4:	00054603          	lbu	a2,0(a0)
400062a8:	0005c683          	lbu	a3,0(a1)
400062ac:	00150513          	addi	a0,a0,1
400062b0:	00158593          	addi	a1,a1,1
400062b4:	00d61463          	bne	a2,a3,400062bc <strcmp+0x124>
400062b8:	fe0616e3          	bnez	a2,400062a4 <strcmp+0x10c>
400062bc:	40d60533          	sub	a0,a2,a3
400062c0:	00008067          	ret
400062c4:	00450513          	addi	a0,a0,4
400062c8:	00458593          	addi	a1,a1,4
400062cc:	fcd61ce3          	bne	a2,a3,400062a4 <strcmp+0x10c>
400062d0:	00000513          	li	a0,0
400062d4:	00008067          	ret
400062d8:	00850513          	addi	a0,a0,8
400062dc:	00858593          	addi	a1,a1,8
400062e0:	fcd612e3          	bne	a2,a3,400062a4 <strcmp+0x10c>
400062e4:	00000513          	li	a0,0
400062e8:	00008067          	ret
400062ec:	00c50513          	addi	a0,a0,12
400062f0:	00c58593          	addi	a1,a1,12
400062f4:	fad618e3          	bne	a2,a3,400062a4 <strcmp+0x10c>
400062f8:	00000513          	li	a0,0
400062fc:	00008067          	ret
40006300:	01050513          	addi	a0,a0,16
40006304:	01058593          	addi	a1,a1,16
40006308:	f8d61ee3          	bne	a2,a3,400062a4 <strcmp+0x10c>
4000630c:	00000513          	li	a0,0
40006310:	00008067          	ret

40006314 <strlen>:
40006314:	00357713          	andi	a4,a0,3
40006318:	00050793          	mv	a5,a0
4000631c:	00050693          	mv	a3,a0
40006320:	04071c63          	bnez	a4,40006378 <strlen+0x64>
40006324:	7f7f8637          	lui	a2,0x7f7f8
40006328:	f7f60613          	addi	a2,a2,-129 # 7f7f7f7f <_bss_end+0x3f7eb8f7>
4000632c:	fff00593          	li	a1,-1
40006330:	00468693          	addi	a3,a3,4
40006334:	ffc6a703          	lw	a4,-4(a3)
40006338:	00c777b3          	and	a5,a4,a2
4000633c:	00c787b3          	add	a5,a5,a2
40006340:	00c76733          	or	a4,a4,a2
40006344:	00e7e7b3          	or	a5,a5,a4
40006348:	feb784e3          	beq	a5,a1,40006330 <strlen+0x1c>
4000634c:	ffc6c703          	lbu	a4,-4(a3)
40006350:	40a687b3          	sub	a5,a3,a0
40006354:	ffd6c603          	lbu	a2,-3(a3)
40006358:	ffe6c503          	lbu	a0,-2(a3)
4000635c:	04070063          	beqz	a4,4000639c <strlen+0x88>
40006360:	02060a63          	beqz	a2,40006394 <strlen+0x80>
40006364:	00a03533          	snez	a0,a0
40006368:	00f50533          	add	a0,a0,a5
4000636c:	ffe50513          	addi	a0,a0,-2
40006370:	00008067          	ret
40006374:	02068863          	beqz	a3,400063a4 <strlen+0x90>
40006378:	0007c703          	lbu	a4,0(a5)
4000637c:	00178793          	addi	a5,a5,1
40006380:	0037f693          	andi	a3,a5,3
40006384:	fe0718e3          	bnez	a4,40006374 <strlen+0x60>
40006388:	40a787b3          	sub	a5,a5,a0
4000638c:	fff78513          	addi	a0,a5,-1
40006390:	00008067          	ret
40006394:	ffd78513          	addi	a0,a5,-3
40006398:	00008067          	ret
4000639c:	ffc78513          	addi	a0,a5,-4
400063a0:	00008067          	ret
400063a4:	00078693          	mv	a3,a5
400063a8:	f7dff06f          	j	40006324 <strlen+0x10>

400063ac <__sprint_r.part.0>:
400063ac:	0645a783          	lw	a5,100(a1)
400063b0:	fd010113          	addi	sp,sp,-48
400063b4:	01612823          	sw	s6,16(sp)
400063b8:	02112623          	sw	ra,44(sp)
400063bc:	02812423          	sw	s0,40(sp)
400063c0:	02912223          	sw	s1,36(sp)
400063c4:	03212023          	sw	s2,32(sp)
400063c8:	01312e23          	sw	s3,28(sp)
400063cc:	01412c23          	sw	s4,24(sp)
400063d0:	01512a23          	sw	s5,20(sp)
400063d4:	01712623          	sw	s7,12(sp)
400063d8:	01812423          	sw	s8,8(sp)
400063dc:	01279713          	slli	a4,a5,0x12
400063e0:	00060b13          	mv	s6,a2
400063e4:	0a075863          	bgez	a4,40006494 <__sprint_r.part.0+0xe8>
400063e8:	00862783          	lw	a5,8(a2)
400063ec:	00058a13          	mv	s4,a1
400063f0:	00050a93          	mv	s5,a0
400063f4:	00062b83          	lw	s7,0(a2)
400063f8:	fff00913          	li	s2,-1
400063fc:	08078863          	beqz	a5,4000648c <__sprint_r.part.0+0xe0>
40006400:	004bac03          	lw	s8,4(s7)
40006404:	000ba483          	lw	s1,0(s7)
40006408:	00000413          	li	s0,0
4000640c:	002c5993          	srli	s3,s8,0x2
40006410:	00099863          	bnez	s3,40006420 <__sprint_r.part.0+0x74>
40006414:	0640006f          	j	40006478 <__sprint_r.part.0+0xcc>
40006418:	00448493          	addi	s1,s1,4
4000641c:	04898c63          	beq	s3,s0,40006474 <__sprint_r.part.0+0xc8>
40006420:	0004a583          	lw	a1,0(s1)
40006424:	000a0613          	mv	a2,s4
40006428:	000a8513          	mv	a0,s5
4000642c:	414010ef          	jal	ra,40007840 <_fputwc_r>
40006430:	00140413          	addi	s0,s0,1
40006434:	ff2512e3          	bne	a0,s2,40006418 <__sprint_r.part.0+0x6c>
40006438:	00090513          	mv	a0,s2
4000643c:	02c12083          	lw	ra,44(sp)
40006440:	000b2423          	sw	zero,8(s6)
40006444:	000b2223          	sw	zero,4(s6)
40006448:	02812403          	lw	s0,40(sp)
4000644c:	02412483          	lw	s1,36(sp)
40006450:	02012903          	lw	s2,32(sp)
40006454:	01c12983          	lw	s3,28(sp)
40006458:	01812a03          	lw	s4,24(sp)
4000645c:	01412a83          	lw	s5,20(sp)
40006460:	01012b03          	lw	s6,16(sp)
40006464:	00c12b83          	lw	s7,12(sp)
40006468:	00812c03          	lw	s8,8(sp)
4000646c:	03010113          	addi	sp,sp,48
40006470:	00008067          	ret
40006474:	008b2783          	lw	a5,8(s6)
40006478:	ffcc7c13          	andi	s8,s8,-4
4000647c:	418787b3          	sub	a5,a5,s8
40006480:	00fb2423          	sw	a5,8(s6)
40006484:	008b8b93          	addi	s7,s7,8
40006488:	f6079ce3          	bnez	a5,40006400 <__sprint_r.part.0+0x54>
4000648c:	00000513          	li	a0,0
40006490:	fadff06f          	j	4000643c <__sprint_r.part.0+0x90>
40006494:	4c0010ef          	jal	ra,40007954 <__sfvwrite_r>
40006498:	fa5ff06f          	j	4000643c <__sprint_r.part.0+0x90>

4000649c <__sprint_r>:
4000649c:	00862703          	lw	a4,8(a2)
400064a0:	00070463          	beqz	a4,400064a8 <__sprint_r+0xc>
400064a4:	f09ff06f          	j	400063ac <__sprint_r.part.0>
400064a8:	00062223          	sw	zero,4(a2)
400064ac:	00000513          	li	a0,0
400064b0:	00008067          	ret

400064b4 <_vfiprintf_r>:
400064b4:	f1010113          	addi	sp,sp,-240
400064b8:	0d312e23          	sw	s3,220(sp)
400064bc:	0d512a23          	sw	s5,212(sp)
400064c0:	0d612823          	sw	s6,208(sp)
400064c4:	0e112623          	sw	ra,236(sp)
400064c8:	0e812423          	sw	s0,232(sp)
400064cc:	0e912223          	sw	s1,228(sp)
400064d0:	0f212023          	sw	s2,224(sp)
400064d4:	0d412c23          	sw	s4,216(sp)
400064d8:	0d712623          	sw	s7,204(sp)
400064dc:	0d812423          	sw	s8,200(sp)
400064e0:	0d912223          	sw	s9,196(sp)
400064e4:	0da12023          	sw	s10,192(sp)
400064e8:	0bb12e23          	sw	s11,188(sp)
400064ec:	00d12623          	sw	a3,12(sp)
400064f0:	00050a93          	mv	s5,a0
400064f4:	00058993          	mv	s3,a1
400064f8:	00060b13          	mv	s6,a2
400064fc:	00050663          	beqz	a0,40006508 <_vfiprintf_r+0x54>
40006500:	03852783          	lw	a5,56(a0)
40006504:	24078a63          	beqz	a5,40006758 <_vfiprintf_r+0x2a4>
40006508:	00c99703          	lh	a4,12(s3)
4000650c:	01071793          	slli	a5,a4,0x10
40006510:	0107d793          	srli	a5,a5,0x10
40006514:	01279693          	slli	a3,a5,0x12
40006518:	0206c663          	bltz	a3,40006544 <_vfiprintf_r+0x90>
4000651c:	0649a683          	lw	a3,100(s3)
40006520:	000027b7          	lui	a5,0x2
40006524:	00f767b3          	or	a5,a4,a5
40006528:	ffffe737          	lui	a4,0xffffe
4000652c:	fff70713          	addi	a4,a4,-1 # ffffdfff <_bss_end+0xbfff1977>
40006530:	00e6f733          	and	a4,a3,a4
40006534:	00f99623          	sh	a5,12(s3)
40006538:	01079793          	slli	a5,a5,0x10
4000653c:	06e9a223          	sw	a4,100(s3)
40006540:	0107d793          	srli	a5,a5,0x10
40006544:	0087f713          	andi	a4,a5,8
40006548:	18070863          	beqz	a4,400066d8 <_vfiprintf_r+0x224>
4000654c:	0109a703          	lw	a4,16(s3)
40006550:	18070463          	beqz	a4,400066d8 <_vfiprintf_r+0x224>
40006554:	01a7f793          	andi	a5,a5,26
40006558:	00a00713          	li	a4,10
4000655c:	18e78e63          	beq	a5,a4,400066f8 <_vfiprintf_r+0x244>
40006560:	4000cbb7          	lui	s7,0x4000c
40006564:	07010c13          	addi	s8,sp,112
40006568:	930b8793          	addi	a5,s7,-1744 # 4000b930 <__mprec_bigtens+0x28>
4000656c:	4000ce37          	lui	t3,0x4000c
40006570:	4000c337          	lui	t1,0x4000c
40006574:	03812e23          	sw	s8,60(sp)
40006578:	04012223          	sw	zero,68(sp)
4000657c:	04012023          	sw	zero,64(sp)
40006580:	000c0413          	mv	s0,s8
40006584:	00012e23          	sw	zero,28(sp)
40006588:	00012423          	sw	zero,8(sp)
4000658c:	00f12823          	sw	a5,16(sp)
40006590:	a94e0c93          	addi	s9,t3,-1388 # 4000ba94 <blanks.4081>
40006594:	aa430b93          	addi	s7,t1,-1372 # 4000baa4 <zeroes.4082>
40006598:	000b4783          	lbu	a5,0(s6)
4000659c:	460788e3          	beqz	a5,4000720c <_vfiprintf_r+0xd58>
400065a0:	02500713          	li	a4,37
400065a4:	000b0493          	mv	s1,s6
400065a8:	00e79663          	bne	a5,a4,400065b4 <_vfiprintf_r+0x100>
400065ac:	0540006f          	j	40006600 <_vfiprintf_r+0x14c>
400065b0:	00e78863          	beq	a5,a4,400065c0 <_vfiprintf_r+0x10c>
400065b4:	00148493          	addi	s1,s1,1
400065b8:	0004c783          	lbu	a5,0(s1)
400065bc:	fe079ae3          	bnez	a5,400065b0 <_vfiprintf_r+0xfc>
400065c0:	41648933          	sub	s2,s1,s6
400065c4:	02090e63          	beqz	s2,40006600 <_vfiprintf_r+0x14c>
400065c8:	04412703          	lw	a4,68(sp)
400065cc:	04012783          	lw	a5,64(sp)
400065d0:	01642023          	sw	s6,0(s0)
400065d4:	00e90733          	add	a4,s2,a4
400065d8:	00178793          	addi	a5,a5,1 # 2001 <_heap_size+0x1>
400065dc:	01242223          	sw	s2,4(s0)
400065e0:	04e12223          	sw	a4,68(sp)
400065e4:	04f12023          	sw	a5,64(sp)
400065e8:	00700693          	li	a3,7
400065ec:	00840413          	addi	s0,s0,8
400065f0:	06f6ca63          	blt	a3,a5,40006664 <_vfiprintf_r+0x1b0>
400065f4:	00812783          	lw	a5,8(sp)
400065f8:	012787b3          	add	a5,a5,s2
400065fc:	00f12423          	sw	a5,8(sp)
40006600:	0004c783          	lbu	a5,0(s1)
40006604:	120788e3          	beqz	a5,40006f34 <_vfiprintf_r+0xa80>
40006608:	fff00693          	li	a3,-1
4000660c:	00148493          	addi	s1,s1,1
40006610:	02010ba3          	sb	zero,55(sp)
40006614:	00000e93          	li	t4,0
40006618:	00000f93          	li	t6,0
4000661c:	00000913          	li	s2,0
40006620:	00000f13          	li	t5,0
40006624:	05800593          	li	a1,88
40006628:	00900513          	li	a0,9
4000662c:	02a00a13          	li	s4,42
40006630:	00068d93          	mv	s11,a3
40006634:	00100293          	li	t0,1
40006638:	02000d13          	li	s10,32
4000663c:	02b00393          	li	t2,43
40006640:	0004c703          	lbu	a4,0(s1)
40006644:	00148b13          	addi	s6,s1,1
40006648:	fe070793          	addi	a5,a4,-32
4000664c:	6cf5e463          	bltu	a1,a5,40006d14 <_vfiprintf_r+0x860>
40006650:	01012603          	lw	a2,16(sp)
40006654:	00279793          	slli	a5,a5,0x2
40006658:	00c787b3          	add	a5,a5,a2
4000665c:	0007a783          	lw	a5,0(a5)
40006660:	00078067          	jr	a5
40006664:	2a071ae3          	bnez	a4,40007118 <_vfiprintf_r+0xc64>
40006668:	04012023          	sw	zero,64(sp)
4000666c:	000c0413          	mv	s0,s8
40006670:	f85ff06f          	j	400065f4 <_vfiprintf_r+0x140>
40006674:	010f6f13          	ori	t5,t5,16
40006678:	000b0493          	mv	s1,s6
4000667c:	fc5ff06f          	j	40006640 <_vfiprintf_r+0x18c>
40006680:	010f6f13          	ori	t5,t5,16
40006684:	010f7793          	andi	a5,t5,16
40006688:	64079e63          	bnez	a5,40006ce4 <_vfiprintf_r+0x830>
4000668c:	040f7793          	andi	a5,t5,64
40006690:	00c12703          	lw	a4,12(sp)
40006694:	64078a63          	beqz	a5,40006ce8 <_vfiprintf_r+0x834>
40006698:	00075783          	lhu	a5,0(a4)
4000669c:	00470713          	addi	a4,a4,4
400066a0:	00100613          	li	a2,1
400066a4:	00e12623          	sw	a4,12(sp)
400066a8:	5400006f          	j	40006be8 <_vfiprintf_r+0x734>
400066ac:	010f6f13          	ori	t5,t5,16
400066b0:	010f7793          	andi	a5,t5,16
400066b4:	64079463          	bnez	a5,40006cfc <_vfiprintf_r+0x848>
400066b8:	040f7793          	andi	a5,t5,64
400066bc:	00c12703          	lw	a4,12(sp)
400066c0:	64078063          	beqz	a5,40006d00 <_vfiprintf_r+0x84c>
400066c4:	00075783          	lhu	a5,0(a4)
400066c8:	00470713          	addi	a4,a4,4
400066cc:	00000613          	li	a2,0
400066d0:	00e12623          	sw	a4,12(sp)
400066d4:	5140006f          	j	40006be8 <_vfiprintf_r+0x734>
400066d8:	00098593          	mv	a1,s3
400066dc:	000a8513          	mv	a0,s5
400066e0:	f20fb0ef          	jal	ra,40001e00 <__swsetup_r>
400066e4:	06051ae3          	bnez	a0,40006f58 <_vfiprintf_r+0xaa4>
400066e8:	00c9d783          	lhu	a5,12(s3)
400066ec:	00a00713          	li	a4,10
400066f0:	01a7f793          	andi	a5,a5,26
400066f4:	e6e796e3          	bne	a5,a4,40006560 <_vfiprintf_r+0xac>
400066f8:	00e99783          	lh	a5,14(s3)
400066fc:	e607c2e3          	bltz	a5,40006560 <_vfiprintf_r+0xac>
40006700:	00c12683          	lw	a3,12(sp)
40006704:	000b0613          	mv	a2,s6
40006708:	00098593          	mv	a1,s3
4000670c:	000a8513          	mv	a0,s5
40006710:	4b5000ef          	jal	ra,400073c4 <__sbprintf>
40006714:	00a12423          	sw	a0,8(sp)
40006718:	0ec12083          	lw	ra,236(sp)
4000671c:	00812503          	lw	a0,8(sp)
40006720:	0e812403          	lw	s0,232(sp)
40006724:	0e412483          	lw	s1,228(sp)
40006728:	0e012903          	lw	s2,224(sp)
4000672c:	0dc12983          	lw	s3,220(sp)
40006730:	0d812a03          	lw	s4,216(sp)
40006734:	0d412a83          	lw	s5,212(sp)
40006738:	0d012b03          	lw	s6,208(sp)
4000673c:	0cc12b83          	lw	s7,204(sp)
40006740:	0c812c03          	lw	s8,200(sp)
40006744:	0c412c83          	lw	s9,196(sp)
40006748:	0c012d03          	lw	s10,192(sp)
4000674c:	0bc12d83          	lw	s11,188(sp)
40006750:	0f010113          	addi	sp,sp,240
40006754:	00008067          	ret
40006758:	da8fd0ef          	jal	ra,40003d00 <__sinit>
4000675c:	dadff06f          	j	40006508 <_vfiprintf_r+0x54>
40006760:	00c12783          	lw	a5,12(sp)
40006764:	0007a903          	lw	s2,0(a5)
40006768:	00478793          	addi	a5,a5,4
4000676c:	00f12623          	sw	a5,12(sp)
40006770:	f00954e3          	bgez	s2,40006678 <_vfiprintf_r+0x1c4>
40006774:	41200933          	neg	s2,s2
40006778:	004f6f13          	ori	t5,t5,4
4000677c:	000b0493          	mv	s1,s6
40006780:	ec1ff06f          	j	40006640 <_vfiprintf_r+0x18c>
40006784:	00028e93          	mv	t4,t0
40006788:	00038f93          	mv	t6,t2
4000678c:	000b0493          	mv	s1,s6
40006790:	eb1ff06f          	j	40006640 <_vfiprintf_r+0x18c>
40006794:	080f6f13          	ori	t5,t5,128
40006798:	000b0493          	mv	s1,s6
4000679c:	ea5ff06f          	j	40006640 <_vfiprintf_r+0x18c>
400067a0:	00000913          	li	s2,0
400067a4:	fd070793          	addi	a5,a4,-48
400067a8:	001b0b13          	addi	s6,s6,1
400067ac:	00291613          	slli	a2,s2,0x2
400067b0:	fffb4703          	lbu	a4,-1(s6)
400067b4:	01260933          	add	s2,a2,s2
400067b8:	00191913          	slli	s2,s2,0x1
400067bc:	01278933          	add	s2,a5,s2
400067c0:	fd070793          	addi	a5,a4,-48
400067c4:	fef572e3          	bleu	a5,a0,400067a8 <_vfiprintf_r+0x2f4>
400067c8:	e81ff06f          	j	40006648 <_vfiprintf_r+0x194>
400067cc:	000b4703          	lbu	a4,0(s6)
400067d0:	001b0493          	addi	s1,s6,1
400067d4:	394704e3          	beq	a4,s4,4000735c <_vfiprintf_r+0xea8>
400067d8:	fd070793          	addi	a5,a4,-48
400067dc:	00048b13          	mv	s6,s1
400067e0:	00000693          	li	a3,0
400067e4:	e6f562e3          	bltu	a0,a5,40006648 <_vfiprintf_r+0x194>
400067e8:	001b0b13          	addi	s6,s6,1
400067ec:	00269493          	slli	s1,a3,0x2
400067f0:	fffb4703          	lbu	a4,-1(s6)
400067f4:	00d484b3          	add	s1,s1,a3
400067f8:	00149493          	slli	s1,s1,0x1
400067fc:	00f486b3          	add	a3,s1,a5
40006800:	fd070793          	addi	a5,a4,-48
40006804:	fef572e3          	bleu	a5,a0,400067e8 <_vfiprintf_r+0x334>
40006808:	e41ff06f          	j	40006648 <_vfiprintf_r+0x194>
4000680c:	360e9ce3          	bnez	t4,40007384 <_vfiprintf_r+0xed0>
40006810:	010f7793          	andi	a5,t5,16
40006814:	1c079ee3          	bnez	a5,400071f0 <_vfiprintf_r+0xd3c>
40006818:	040f7f13          	andi	t5,t5,64
4000681c:	1c0f0ae3          	beqz	t5,400071f0 <_vfiprintf_r+0xd3c>
40006820:	00c12703          	lw	a4,12(sp)
40006824:	00072783          	lw	a5,0(a4)
40006828:	00470713          	addi	a4,a4,4
4000682c:	00e12623          	sw	a4,12(sp)
40006830:	00815703          	lhu	a4,8(sp)
40006834:	00e79023          	sh	a4,0(a5)
40006838:	d61ff06f          	j	40006598 <_vfiprintf_r+0xe4>
4000683c:	00c12783          	lw	a5,12(sp)
40006840:	02010ba3          	sb	zero,55(sp)
40006844:	0007ad03          	lw	s10,0(a5)
40006848:	00478493          	addi	s1,a5,4
4000684c:	2c0d00e3          	beqz	s10,4000730c <_vfiprintf_r+0xe58>
40006850:	fff00793          	li	a5,-1
40006854:	24f68ee3          	beq	a3,a5,400072b0 <_vfiprintf_r+0xdfc>
40006858:	00068613          	mv	a2,a3
4000685c:	00000593          	li	a1,0
40006860:	000d0513          	mv	a0,s10
40006864:	01e12623          	sw	t5,12(sp)
40006868:	00d12223          	sw	a3,4(sp)
4000686c:	c78fe0ef          	jal	ra,40004ce4 <memchr>
40006870:	00412683          	lw	a3,4(sp)
40006874:	00c12f03          	lw	t5,12(sp)
40006878:	2c0502e3          	beqz	a0,4000733c <_vfiprintf_r+0xe88>
4000687c:	03714583          	lbu	a1,55(sp)
40006880:	41a50db3          	sub	s11,a0,s10
40006884:	00912623          	sw	s1,12(sp)
40006888:	01e12223          	sw	t5,4(sp)
4000688c:	00000693          	li	a3,0
40006890:	00068a13          	mv	s4,a3
40006894:	01b6d463          	ble	s11,a3,4000689c <_vfiprintf_r+0x3e8>
40006898:	000d8a13          	mv	s4,s11
4000689c:	00b035b3          	snez	a1,a1
400068a0:	00ba0a33          	add	s4,s4,a1
400068a4:	00412783          	lw	a5,4(sp)
400068a8:	0027f393          	andi	t2,a5,2
400068ac:	00038463          	beqz	t2,400068b4 <_vfiprintf_r+0x400>
400068b0:	002a0a13          	addi	s4,s4,2
400068b4:	00412783          	lw	a5,4(sp)
400068b8:	0847f293          	andi	t0,a5,132
400068bc:	4c029863          	bnez	t0,40006d8c <_vfiprintf_r+0x8d8>
400068c0:	414904b3          	sub	s1,s2,s4
400068c4:	4c905463          	blez	s1,40006d8c <_vfiprintf_r+0x8d8>
400068c8:	01000f13          	li	t5,16
400068cc:	04412603          	lw	a2,68(sp)
400068d0:	229f58e3          	ble	s1,t5,40007300 <_vfiprintf_r+0xe4c>
400068d4:	04012503          	lw	a0,64(sp)
400068d8:	00700f93          	li	t6,7
400068dc:	00100793          	li	a5,1
400068e0:	0180006f          	j	400068f8 <_vfiprintf_r+0x444>
400068e4:	00250713          	addi	a4,a0,2
400068e8:	00840413          	addi	s0,s0,8
400068ec:	00058513          	mv	a0,a1
400068f0:	ff048493          	addi	s1,s1,-16
400068f4:	029f5c63          	ble	s1,t5,4000692c <_vfiprintf_r+0x478>
400068f8:	01060613          	addi	a2,a2,16
400068fc:	00150593          	addi	a1,a0,1
40006900:	01942023          	sw	s9,0(s0)
40006904:	01e42223          	sw	t5,4(s0)
40006908:	04c12223          	sw	a2,68(sp)
4000690c:	04b12023          	sw	a1,64(sp)
40006910:	fcbfdae3          	ble	a1,t6,400068e4 <_vfiprintf_r+0x430>
40006914:	42061063          	bnez	a2,40006d34 <_vfiprintf_r+0x880>
40006918:	ff048493          	addi	s1,s1,-16
4000691c:	00000513          	li	a0,0
40006920:	00078713          	mv	a4,a5
40006924:	000c0413          	mv	s0,s8
40006928:	fc9f48e3          	blt	t5,s1,400068f8 <_vfiprintf_r+0x444>
4000692c:	00c487b3          	add	a5,s1,a2
40006930:	01942023          	sw	s9,0(s0)
40006934:	00942223          	sw	s1,4(s0)
40006938:	04f12223          	sw	a5,68(sp)
4000693c:	04e12023          	sw	a4,64(sp)
40006940:	00700613          	li	a2,7
40006944:	6ee64063          	blt	a2,a4,40007024 <_vfiprintf_r+0xb70>
40006948:	03714583          	lbu	a1,55(sp)
4000694c:	00840413          	addi	s0,s0,8
40006950:	00170613          	addi	a2,a4,1
40006954:	44059663          	bnez	a1,40006da0 <_vfiprintf_r+0x8ec>
40006958:	48038063          	beqz	t2,40006dd8 <_vfiprintf_r+0x924>
4000695c:	03810713          	addi	a4,sp,56
40006960:	00278793          	addi	a5,a5,2
40006964:	00e42023          	sw	a4,0(s0)
40006968:	00200713          	li	a4,2
4000696c:	00e42223          	sw	a4,4(s0)
40006970:	04f12223          	sw	a5,68(sp)
40006974:	04c12023          	sw	a2,64(sp)
40006978:	00700713          	li	a4,7
4000697c:	6ec75a63          	ble	a2,a4,40007070 <_vfiprintf_r+0xbbc>
40006980:	7c079e63          	bnez	a5,4000715c <_vfiprintf_r+0xca8>
40006984:	08000593          	li	a1,128
40006988:	00100613          	li	a2,1
4000698c:	00000713          	li	a4,0
40006990:	000c0413          	mv	s0,s8
40006994:	44b29663          	bne	t0,a1,40006de0 <_vfiprintf_r+0x92c>
40006998:	414904b3          	sub	s1,s2,s4
4000699c:	44905263          	blez	s1,40006de0 <_vfiprintf_r+0x92c>
400069a0:	01000f13          	li	t5,16
400069a4:	1a9f58e3          	ble	s1,t5,40007354 <_vfiprintf_r+0xea0>
400069a8:	00700f93          	li	t6,7
400069ac:	00100293          	li	t0,1
400069b0:	0180006f          	j	400069c8 <_vfiprintf_r+0x514>
400069b4:	00270593          	addi	a1,a4,2
400069b8:	00840413          	addi	s0,s0,8
400069bc:	00060713          	mv	a4,a2
400069c0:	ff048493          	addi	s1,s1,-16
400069c4:	029f5c63          	ble	s1,t5,400069fc <_vfiprintf_r+0x548>
400069c8:	01078793          	addi	a5,a5,16
400069cc:	00170613          	addi	a2,a4,1
400069d0:	01742023          	sw	s7,0(s0)
400069d4:	01e42223          	sw	t5,4(s0)
400069d8:	04f12223          	sw	a5,68(sp)
400069dc:	04c12023          	sw	a2,64(sp)
400069e0:	fccfdae3          	ble	a2,t6,400069b4 <_vfiprintf_r+0x500>
400069e4:	5e079c63          	bnez	a5,40006fdc <_vfiprintf_r+0xb28>
400069e8:	ff048493          	addi	s1,s1,-16
400069ec:	00028593          	mv	a1,t0
400069f0:	00000713          	li	a4,0
400069f4:	000c0413          	mv	s0,s8
400069f8:	fc9f48e3          	blt	t5,s1,400069c8 <_vfiprintf_r+0x514>
400069fc:	009787b3          	add	a5,a5,s1
40006a00:	01742023          	sw	s7,0(s0)
40006a04:	00942223          	sw	s1,4(s0)
40006a08:	04f12223          	sw	a5,68(sp)
40006a0c:	04b12023          	sw	a1,64(sp)
40006a10:	00700713          	li	a4,7
40006a14:	78b74063          	blt	a4,a1,40007194 <_vfiprintf_r+0xce0>
40006a18:	41b684b3          	sub	s1,a3,s11
40006a1c:	00840413          	addi	s0,s0,8
40006a20:	00158613          	addi	a2,a1,1
40006a24:	00058713          	mv	a4,a1
40006a28:	3c904063          	bgtz	s1,40006de8 <_vfiprintf_r+0x934>
40006a2c:	00fd87b3          	add	a5,s11,a5
40006a30:	01a42023          	sw	s10,0(s0)
40006a34:	01b42223          	sw	s11,4(s0)
40006a38:	04f12223          	sw	a5,68(sp)
40006a3c:	04c12023          	sw	a2,64(sp)
40006a40:	00700713          	li	a4,7
40006a44:	42c75e63          	ble	a2,a4,40006e80 <_vfiprintf_r+0x9cc>
40006a48:	6a079863          	bnez	a5,400070f8 <_vfiprintf_r+0xc44>
40006a4c:	00412703          	lw	a4,4(sp)
40006a50:	04012023          	sw	zero,64(sp)
40006a54:	00477d13          	andi	s10,a4,4
40006a58:	080d0863          	beqz	s10,40006ae8 <_vfiprintf_r+0x634>
40006a5c:	414904b3          	sub	s1,s2,s4
40006a60:	000c0413          	mv	s0,s8
40006a64:	08905263          	blez	s1,40006ae8 <_vfiprintf_r+0x634>
40006a68:	01000d13          	li	s10,16
40006a6c:	0c9d52e3          	ble	s1,s10,40007330 <_vfiprintf_r+0xe7c>
40006a70:	04012683          	lw	a3,64(sp)
40006a74:	00700d93          	li	s11,7
40006a78:	00100e93          	li	t4,1
40006a7c:	0180006f          	j	40006a94 <_vfiprintf_r+0x5e0>
40006a80:	00268613          	addi	a2,a3,2
40006a84:	00840413          	addi	s0,s0,8
40006a88:	00070693          	mv	a3,a4
40006a8c:	ff048493          	addi	s1,s1,-16
40006a90:	029d5c63          	ble	s1,s10,40006ac8 <_vfiprintf_r+0x614>
40006a94:	01078793          	addi	a5,a5,16
40006a98:	00168713          	addi	a4,a3,1
40006a9c:	01942023          	sw	s9,0(s0)
40006aa0:	01a42223          	sw	s10,4(s0)
40006aa4:	04f12223          	sw	a5,68(sp)
40006aa8:	04e12023          	sw	a4,64(sp)
40006aac:	fceddae3          	ble	a4,s11,40006a80 <_vfiprintf_r+0x5cc>
40006ab0:	4a079a63          	bnez	a5,40006f64 <_vfiprintf_r+0xab0>
40006ab4:	ff048493          	addi	s1,s1,-16
40006ab8:	000e8613          	mv	a2,t4
40006abc:	00000693          	li	a3,0
40006ac0:	000c0413          	mv	s0,s8
40006ac4:	fc9d48e3          	blt	s10,s1,40006a94 <_vfiprintf_r+0x5e0>
40006ac8:	009787b3          	add	a5,a5,s1
40006acc:	01942023          	sw	s9,0(s0)
40006ad0:	00942223          	sw	s1,4(s0)
40006ad4:	04f12223          	sw	a5,68(sp)
40006ad8:	04c12023          	sw	a2,64(sp)
40006adc:	00700713          	li	a4,7
40006ae0:	3ac75c63          	ble	a2,a4,40006e98 <_vfiprintf_r+0x9e4>
40006ae4:	7a079863          	bnez	a5,40007294 <_vfiprintf_r+0xde0>
40006ae8:	01495463          	ble	s4,s2,40006af0 <_vfiprintf_r+0x63c>
40006aec:	000a0913          	mv	s2,s4
40006af0:	00812783          	lw	a5,8(sp)
40006af4:	012787b3          	add	a5,a5,s2
40006af8:	00f12423          	sw	a5,8(sp)
40006afc:	3b40006f          	j	40006eb0 <_vfiprintf_r+0x9fc>
40006b00:	080e9ae3          	bnez	t4,40007394 <_vfiprintf_r+0xee0>
40006b04:	010f6f13          	ori	t5,t5,16
40006b08:	010f7793          	andi	a5,t5,16
40006b0c:	70079463          	bnez	a5,40007214 <_vfiprintf_r+0xd60>
40006b10:	040f7793          	andi	a5,t5,64
40006b14:	00c12703          	lw	a4,12(sp)
40006b18:	68078863          	beqz	a5,400071a8 <_vfiprintf_r+0xcf4>
40006b1c:	00071783          	lh	a5,0(a4)
40006b20:	00470713          	addi	a4,a4,4
40006b24:	00e12623          	sw	a4,12(sp)
40006b28:	7007ca63          	bltz	a5,4000723c <_vfiprintf_r+0xd88>
40006b2c:	fff00713          	li	a4,-1
40006b30:	03714583          	lbu	a1,55(sp)
40006b34:	00100613          	li	a2,1
40006b38:	0ce69063          	bne	a3,a4,40006bf8 <_vfiprintf_r+0x744>
40006b3c:	44078e63          	beqz	a5,40006f98 <_vfiprintf_r+0xae4>
40006b40:	01e12223          	sw	t5,4(sp)
40006b44:	00100713          	li	a4,1
40006b48:	56e60a63          	beq	a2,a4,400070bc <_vfiprintf_r+0xc08>
40006b4c:	00200713          	li	a4,2
40006b50:	46e60063          	beq	a2,a4,40006fb0 <_vfiprintf_r+0xafc>
40006b54:	000c0613          	mv	a2,s8
40006b58:	0080006f          	j	40006b60 <_vfiprintf_r+0x6ac>
40006b5c:	000d0613          	mv	a2,s10
40006b60:	0077f713          	andi	a4,a5,7
40006b64:	03070713          	addi	a4,a4,48
40006b68:	fee60fa3          	sb	a4,-1(a2)
40006b6c:	0037d793          	srli	a5,a5,0x3
40006b70:	fff60d13          	addi	s10,a2,-1
40006b74:	fe0794e3          	bnez	a5,40006b5c <_vfiprintf_r+0x6a8>
40006b78:	00412783          	lw	a5,4(sp)
40006b7c:	0017f793          	andi	a5,a5,1
40006b80:	44078a63          	beqz	a5,40006fd4 <_vfiprintf_r+0xb20>
40006b84:	03000793          	li	a5,48
40006b88:	44f70663          	beq	a4,a5,40006fd4 <_vfiprintf_r+0xb20>
40006b8c:	ffe60613          	addi	a2,a2,-2
40006b90:	fefd0fa3          	sb	a5,-1(s10)
40006b94:	40cc0db3          	sub	s11,s8,a2
40006b98:	00060d13          	mv	s10,a2
40006b9c:	cf5ff06f          	j	40006890 <_vfiprintf_r+0x3dc>
40006ba0:	ac0f9ce3          	bnez	t6,40006678 <_vfiprintf_r+0x1c4>
40006ba4:	00028e93          	mv	t4,t0
40006ba8:	000d0f93          	mv	t6,s10
40006bac:	000b0493          	mv	s1,s6
40006bb0:	a91ff06f          	j	40006640 <_vfiprintf_r+0x18c>
40006bb4:	00c12603          	lw	a2,12(sp)
40006bb8:	03000713          	li	a4,48
40006bbc:	02e10c23          	sb	a4,56(sp)
40006bc0:	07800713          	li	a4,120
40006bc4:	02e10ca3          	sb	a4,57(sp)
40006bc8:	00460713          	addi	a4,a2,4
40006bcc:	00e12623          	sw	a4,12(sp)
40006bd0:	4000b737          	lui	a4,0x4000b
40006bd4:	7c470713          	addi	a4,a4,1988 # 4000b7c4 <zeroes.4139+0x34>
40006bd8:	00062783          	lw	a5,0(a2)
40006bdc:	002f6f13          	ori	t5,t5,2
40006be0:	00e12e23          	sw	a4,28(sp)
40006be4:	00200613          	li	a2,2
40006be8:	02010ba3          	sb	zero,55(sp)
40006bec:	00000593          	li	a1,0
40006bf0:	fff00713          	li	a4,-1
40006bf4:	f4e684e3          	beq	a3,a4,40006b3c <_vfiprintf_r+0x688>
40006bf8:	f7ff7713          	andi	a4,t5,-129
40006bfc:	00e12223          	sw	a4,4(sp)
40006c00:	f40792e3          	bnez	a5,40006b44 <_vfiprintf_r+0x690>
40006c04:	38069863          	bnez	a3,40006f94 <_vfiprintf_r+0xae0>
40006c08:	4e061263          	bnez	a2,400070ec <_vfiprintf_r+0xc38>
40006c0c:	001f7d93          	andi	s11,t5,1
40006c10:	000c0d13          	mv	s10,s8
40006c14:	c60d8ee3          	beqz	s11,40006890 <_vfiprintf_r+0x3dc>
40006c18:	03000793          	li	a5,48
40006c1c:	06f107a3          	sb	a5,111(sp)
40006c20:	06f10d13          	addi	s10,sp,111
40006c24:	c6dff06f          	j	40006890 <_vfiprintf_r+0x3dc>
40006c28:	00c12703          	lw	a4,12(sp)
40006c2c:	00100a13          	li	s4,1
40006c30:	02010ba3          	sb	zero,55(sp)
40006c34:	00072783          	lw	a5,0(a4)
40006c38:	000a0d93          	mv	s11,s4
40006c3c:	04810d13          	addi	s10,sp,72
40006c40:	04f10423          	sb	a5,72(sp)
40006c44:	00470793          	addi	a5,a4,4
40006c48:	00f12623          	sw	a5,12(sp)
40006c4c:	01e12223          	sw	t5,4(sp)
40006c50:	00000693          	li	a3,0
40006c54:	c51ff06f          	j	400068a4 <_vfiprintf_r+0x3f0>
40006c58:	ea0e88e3          	beqz	t4,40006b08 <_vfiprintf_r+0x654>
40006c5c:	03f10ba3          	sb	t6,55(sp)
40006c60:	ea9ff06f          	j	40006b08 <_vfiprintf_r+0x654>
40006c64:	040f6f13          	ori	t5,t5,64
40006c68:	000b0493          	mv	s1,s6
40006c6c:	9d5ff06f          	j	40006640 <_vfiprintf_r+0x18c>
40006c70:	720e9a63          	bnez	t4,400073a4 <_vfiprintf_r+0xef0>
40006c74:	4000b7b7          	lui	a5,0x4000b
40006c78:	7c478793          	addi	a5,a5,1988 # 4000b7c4 <zeroes.4139+0x34>
40006c7c:	00f12e23          	sw	a5,28(sp)
40006c80:	010f7793          	andi	a5,t5,16
40006c84:	5a079263          	bnez	a5,40007228 <_vfiprintf_r+0xd74>
40006c88:	040f7793          	andi	a5,t5,64
40006c8c:	00c12603          	lw	a2,12(sp)
40006c90:	52078463          	beqz	a5,400071b8 <_vfiprintf_r+0xd04>
40006c94:	00065783          	lhu	a5,0(a2)
40006c98:	00460613          	addi	a2,a2,4
40006c9c:	00c12623          	sw	a2,12(sp)
40006ca0:	001f7593          	andi	a1,t5,1
40006ca4:	00200613          	li	a2,2
40006ca8:	f40580e3          	beqz	a1,40006be8 <_vfiprintf_r+0x734>
40006cac:	f2078ee3          	beqz	a5,40006be8 <_vfiprintf_r+0x734>
40006cb0:	03000593          	li	a1,48
40006cb4:	02b10c23          	sb	a1,56(sp)
40006cb8:	02e10ca3          	sb	a4,57(sp)
40006cbc:	00cf6f33          	or	t5,t5,a2
40006cc0:	f29ff06f          	j	40006be8 <_vfiprintf_r+0x734>
40006cc4:	001f6f13          	ori	t5,t5,1
40006cc8:	000b0493          	mv	s1,s6
40006ccc:	975ff06f          	j	40006640 <_vfiprintf_r+0x18c>
40006cd0:	6c0e9663          	bnez	t4,4000739c <_vfiprintf_r+0xee8>
40006cd4:	4000b7b7          	lui	a5,0x4000b
40006cd8:	7b078793          	addi	a5,a5,1968 # 4000b7b0 <zeroes.4139+0x20>
40006cdc:	00f12e23          	sw	a5,28(sp)
40006ce0:	fa1ff06f          	j	40006c80 <_vfiprintf_r+0x7cc>
40006ce4:	00c12703          	lw	a4,12(sp)
40006ce8:	00072783          	lw	a5,0(a4)
40006cec:	00470713          	addi	a4,a4,4
40006cf0:	00100613          	li	a2,1
40006cf4:	00e12623          	sw	a4,12(sp)
40006cf8:	ef1ff06f          	j	40006be8 <_vfiprintf_r+0x734>
40006cfc:	00c12703          	lw	a4,12(sp)
40006d00:	00072783          	lw	a5,0(a4)
40006d04:	00470713          	addi	a4,a4,4
40006d08:	00000613          	li	a2,0
40006d0c:	00e12623          	sw	a4,12(sp)
40006d10:	ed9ff06f          	j	40006be8 <_vfiprintf_r+0x734>
40006d14:	660e9463          	bnez	t4,4000737c <_vfiprintf_r+0xec8>
40006d18:	20070e63          	beqz	a4,40006f34 <_vfiprintf_r+0xa80>
40006d1c:	00100a13          	li	s4,1
40006d20:	04e10423          	sb	a4,72(sp)
40006d24:	02010ba3          	sb	zero,55(sp)
40006d28:	000a0d93          	mv	s11,s4
40006d2c:	04810d13          	addi	s10,sp,72
40006d30:	f1dff06f          	j	40006c4c <_vfiprintf_r+0x798>
40006d34:	03c10613          	addi	a2,sp,60
40006d38:	00098593          	mv	a1,s3
40006d3c:	000a8513          	mv	a0,s5
40006d40:	02f12623          	sw	a5,44(sp)
40006d44:	03f12423          	sw	t6,40(sp)
40006d48:	03e12223          	sw	t5,36(sp)
40006d4c:	02512023          	sw	t0,32(sp)
40006d50:	00712c23          	sw	t2,24(sp)
40006d54:	00d12a23          	sw	a3,20(sp)
40006d58:	e54ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40006d5c:	1e051863          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40006d60:	04012503          	lw	a0,64(sp)
40006d64:	04412603          	lw	a2,68(sp)
40006d68:	000c0413          	mv	s0,s8
40006d6c:	00150713          	addi	a4,a0,1
40006d70:	02c12783          	lw	a5,44(sp)
40006d74:	02812f83          	lw	t6,40(sp)
40006d78:	02412f03          	lw	t5,36(sp)
40006d7c:	02012283          	lw	t0,32(sp)
40006d80:	01812383          	lw	t2,24(sp)
40006d84:	01412683          	lw	a3,20(sp)
40006d88:	b69ff06f          	j	400068f0 <_vfiprintf_r+0x43c>
40006d8c:	04012703          	lw	a4,64(sp)
40006d90:	04412783          	lw	a5,68(sp)
40006d94:	00170613          	addi	a2,a4,1
40006d98:	03714583          	lbu	a1,55(sp)
40006d9c:	ba058ee3          	beqz	a1,40006958 <_vfiprintf_r+0x4a4>
40006da0:	00100593          	li	a1,1
40006da4:	03710713          	addi	a4,sp,55
40006da8:	00b787b3          	add	a5,a5,a1
40006dac:	00e42023          	sw	a4,0(s0)
40006db0:	00b42223          	sw	a1,4(s0)
40006db4:	04f12223          	sw	a5,68(sp)
40006db8:	04c12023          	sw	a2,64(sp)
40006dbc:	00700713          	li	a4,7
40006dc0:	28c75463          	ble	a2,a4,40007048 <_vfiprintf_r+0xb94>
40006dc4:	0e079c63          	bnez	a5,40006ebc <_vfiprintf_r+0xa08>
40006dc8:	28039863          	bnez	t2,40007058 <_vfiprintf_r+0xba4>
40006dcc:	00000713          	li	a4,0
40006dd0:	00100613          	li	a2,1
40006dd4:	000c0413          	mv	s0,s8
40006dd8:	08000593          	li	a1,128
40006ddc:	bab28ee3          	beq	t0,a1,40006998 <_vfiprintf_r+0x4e4>
40006de0:	41b684b3          	sub	s1,a3,s11
40006de4:	c49054e3          	blez	s1,40006a2c <_vfiprintf_r+0x578>
40006de8:	01000f13          	li	t5,16
40006dec:	049f5a63          	ble	s1,t5,40006e40 <_vfiprintf_r+0x98c>
40006df0:	00700f93          	li	t6,7
40006df4:	0180006f          	j	40006e0c <_vfiprintf_r+0x958>
40006df8:	00270613          	addi	a2,a4,2
40006dfc:	00840413          	addi	s0,s0,8
40006e00:	00068713          	mv	a4,a3
40006e04:	ff048493          	addi	s1,s1,-16
40006e08:	029f5c63          	ble	s1,t5,40006e40 <_vfiprintf_r+0x98c>
40006e0c:	01078793          	addi	a5,a5,16
40006e10:	00170693          	addi	a3,a4,1
40006e14:	01742023          	sw	s7,0(s0)
40006e18:	01e42223          	sw	t5,4(s0)
40006e1c:	04f12223          	sw	a5,68(sp)
40006e20:	04d12023          	sw	a3,64(sp)
40006e24:	fcdfdae3          	ble	a3,t6,40006df8 <_vfiprintf_r+0x944>
40006e28:	0c079a63          	bnez	a5,40006efc <_vfiprintf_r+0xa48>
40006e2c:	ff048493          	addi	s1,s1,-16
40006e30:	00100613          	li	a2,1
40006e34:	00000713          	li	a4,0
40006e38:	000c0413          	mv	s0,s8
40006e3c:	fc9f48e3          	blt	t5,s1,40006e0c <_vfiprintf_r+0x958>
40006e40:	009787b3          	add	a5,a5,s1
40006e44:	01742023          	sw	s7,0(s0)
40006e48:	00942223          	sw	s1,4(s0)
40006e4c:	04f12223          	sw	a5,68(sp)
40006e50:	04c12023          	sw	a2,64(sp)
40006e54:	00700713          	li	a4,7
40006e58:	22c74463          	blt	a4,a2,40007080 <_vfiprintf_r+0xbcc>
40006e5c:	00840413          	addi	s0,s0,8
40006e60:	00160613          	addi	a2,a2,1
40006e64:	00fd87b3          	add	a5,s11,a5
40006e68:	01a42023          	sw	s10,0(s0)
40006e6c:	01b42223          	sw	s11,4(s0)
40006e70:	04f12223          	sw	a5,68(sp)
40006e74:	04c12023          	sw	a2,64(sp)
40006e78:	00700713          	li	a4,7
40006e7c:	bcc746e3          	blt	a4,a2,40006a48 <_vfiprintf_r+0x594>
40006e80:	00840413          	addi	s0,s0,8
40006e84:	00412703          	lw	a4,4(sp)
40006e88:	00477d13          	andi	s10,a4,4
40006e8c:	000d0663          	beqz	s10,40006e98 <_vfiprintf_r+0x9e4>
40006e90:	414904b3          	sub	s1,s2,s4
40006e94:	bc904ae3          	bgtz	s1,40006a68 <_vfiprintf_r+0x5b4>
40006e98:	01495463          	ble	s4,s2,40006ea0 <_vfiprintf_r+0x9ec>
40006e9c:	000a0913          	mv	s2,s4
40006ea0:	00812703          	lw	a4,8(sp)
40006ea4:	01270733          	add	a4,a4,s2
40006ea8:	00e12423          	sw	a4,8(sp)
40006eac:	1e079c63          	bnez	a5,400070a4 <_vfiprintf_r+0xbf0>
40006eb0:	04012023          	sw	zero,64(sp)
40006eb4:	000c0413          	mv	s0,s8
40006eb8:	ee0ff06f          	j	40006598 <_vfiprintf_r+0xe4>
40006ebc:	03c10613          	addi	a2,sp,60
40006ec0:	00098593          	mv	a1,s3
40006ec4:	000a8513          	mv	a0,s5
40006ec8:	02512023          	sw	t0,32(sp)
40006ecc:	00712c23          	sw	t2,24(sp)
40006ed0:	00d12a23          	sw	a3,20(sp)
40006ed4:	cd8ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40006ed8:	06051a63          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40006edc:	04012703          	lw	a4,64(sp)
40006ee0:	04412783          	lw	a5,68(sp)
40006ee4:	000c0413          	mv	s0,s8
40006ee8:	00170613          	addi	a2,a4,1
40006eec:	02012283          	lw	t0,32(sp)
40006ef0:	01812383          	lw	t2,24(sp)
40006ef4:	01412683          	lw	a3,20(sp)
40006ef8:	a61ff06f          	j	40006958 <_vfiprintf_r+0x4a4>
40006efc:	03c10613          	addi	a2,sp,60
40006f00:	00098593          	mv	a1,s3
40006f04:	000a8513          	mv	a0,s5
40006f08:	01f12c23          	sw	t6,24(sp)
40006f0c:	01e12a23          	sw	t5,20(sp)
40006f10:	c9cff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40006f14:	02051c63          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40006f18:	04012703          	lw	a4,64(sp)
40006f1c:	04412783          	lw	a5,68(sp)
40006f20:	000c0413          	mv	s0,s8
40006f24:	00170613          	addi	a2,a4,1
40006f28:	01812f83          	lw	t6,24(sp)
40006f2c:	01412f03          	lw	t5,20(sp)
40006f30:	ed5ff06f          	j	40006e04 <_vfiprintf_r+0x950>
40006f34:	04412783          	lw	a5,68(sp)
40006f38:	00078a63          	beqz	a5,40006f4c <_vfiprintf_r+0xa98>
40006f3c:	03c10613          	addi	a2,sp,60
40006f40:	00098593          	mv	a1,s3
40006f44:	000a8513          	mv	a0,s5
40006f48:	c64ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40006f4c:	00c9d783          	lhu	a5,12(s3)
40006f50:	0407f793          	andi	a5,a5,64
40006f54:	fc078263          	beqz	a5,40006718 <_vfiprintf_r+0x264>
40006f58:	fff00793          	li	a5,-1
40006f5c:	00f12423          	sw	a5,8(sp)
40006f60:	fb8ff06f          	j	40006718 <_vfiprintf_r+0x264>
40006f64:	03c10613          	addi	a2,sp,60
40006f68:	00098593          	mv	a1,s3
40006f6c:	000a8513          	mv	a0,s5
40006f70:	01d12223          	sw	t4,4(sp)
40006f74:	c38ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40006f78:	fc051ae3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40006f7c:	04012683          	lw	a3,64(sp)
40006f80:	04412783          	lw	a5,68(sp)
40006f84:	000c0413          	mv	s0,s8
40006f88:	00168613          	addi	a2,a3,1
40006f8c:	00412e83          	lw	t4,4(sp)
40006f90:	afdff06f          	j	40006a8c <_vfiprintf_r+0x5d8>
40006f94:	00412f03          	lw	t5,4(sp)
40006f98:	00100713          	li	a4,1
40006f9c:	1ae60463          	beq	a2,a4,40007144 <_vfiprintf_r+0xc90>
40006fa0:	00200793          	li	a5,2
40006fa4:	18f61863          	bne	a2,a5,40007134 <_vfiprintf_r+0xc80>
40006fa8:	01e12223          	sw	t5,4(sp)
40006fac:	00000793          	li	a5,0
40006fb0:	000c0d13          	mv	s10,s8
40006fb4:	01c12603          	lw	a2,28(sp)
40006fb8:	00f7f713          	andi	a4,a5,15
40006fbc:	fffd0d13          	addi	s10,s10,-1
40006fc0:	00e60733          	add	a4,a2,a4
40006fc4:	00074703          	lbu	a4,0(a4)
40006fc8:	0047d793          	srli	a5,a5,0x4
40006fcc:	00ed0023          	sb	a4,0(s10)
40006fd0:	fe0792e3          	bnez	a5,40006fb4 <_vfiprintf_r+0xb00>
40006fd4:	41ac0db3          	sub	s11,s8,s10
40006fd8:	8b9ff06f          	j	40006890 <_vfiprintf_r+0x3dc>
40006fdc:	03c10613          	addi	a2,sp,60
40006fe0:	00098593          	mv	a1,s3
40006fe4:	000a8513          	mv	a0,s5
40006fe8:	02512223          	sw	t0,36(sp)
40006fec:	03f12023          	sw	t6,32(sp)
40006ff0:	01e12c23          	sw	t5,24(sp)
40006ff4:	00d12a23          	sw	a3,20(sp)
40006ff8:	bb4ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40006ffc:	f40518e3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40007000:	04012703          	lw	a4,64(sp)
40007004:	04412783          	lw	a5,68(sp)
40007008:	000c0413          	mv	s0,s8
4000700c:	00170593          	addi	a1,a4,1
40007010:	02412283          	lw	t0,36(sp)
40007014:	02012f83          	lw	t6,32(sp)
40007018:	01812f03          	lw	t5,24(sp)
4000701c:	01412683          	lw	a3,20(sp)
40007020:	9a1ff06f          	j	400069c0 <_vfiprintf_r+0x50c>
40007024:	22079863          	bnez	a5,40007254 <_vfiprintf_r+0xda0>
40007028:	03714703          	lbu	a4,55(sp)
4000702c:	d8070ee3          	beqz	a4,40006dc8 <_vfiprintf_r+0x914>
40007030:	00100793          	li	a5,1
40007034:	03710713          	addi	a4,sp,55
40007038:	00078613          	mv	a2,a5
4000703c:	06e12823          	sw	a4,112(sp)
40007040:	06f12a23          	sw	a5,116(sp)
40007044:	000c0413          	mv	s0,s8
40007048:	00060713          	mv	a4,a2
4000704c:	00840413          	addi	s0,s0,8
40007050:	00160613          	addi	a2,a2,1
40007054:	905ff06f          	j	40006958 <_vfiprintf_r+0x4a4>
40007058:	00200793          	li	a5,2
4000705c:	03810713          	addi	a4,sp,56
40007060:	06e12823          	sw	a4,112(sp)
40007064:	06f12a23          	sw	a5,116(sp)
40007068:	00100613          	li	a2,1
4000706c:	000c0413          	mv	s0,s8
40007070:	00060713          	mv	a4,a2
40007074:	00840413          	addi	s0,s0,8
40007078:	00160613          	addi	a2,a2,1
4000707c:	d5dff06f          	j	40006dd8 <_vfiprintf_r+0x924>
40007080:	14079463          	bnez	a5,400071c8 <_vfiprintf_r+0xd14>
40007084:	00100713          	li	a4,1
40007088:	000d8793          	mv	a5,s11
4000708c:	07a12823          	sw	s10,112(sp)
40007090:	07b12a23          	sw	s11,116(sp)
40007094:	05b12223          	sw	s11,68(sp)
40007098:	04e12023          	sw	a4,64(sp)
4000709c:	000c0413          	mv	s0,s8
400070a0:	de1ff06f          	j	40006e80 <_vfiprintf_r+0x9cc>
400070a4:	03c10613          	addi	a2,sp,60
400070a8:	00098593          	mv	a1,s3
400070ac:	000a8513          	mv	a0,s5
400070b0:	afcff0ef          	jal	ra,400063ac <__sprint_r.part.0>
400070b4:	de050ee3          	beqz	a0,40006eb0 <_vfiprintf_r+0x9fc>
400070b8:	e95ff06f          	j	40006f4c <_vfiprintf_r+0xa98>
400070bc:	00900713          	li	a4,9
400070c0:	000c0d13          	mv	s10,s8
400070c4:	00a00613          	li	a2,10
400070c8:	06f77c63          	bleu	a5,a4,40007140 <_vfiprintf_r+0xc8c>
400070cc:	02c7f733          	remu	a4,a5,a2
400070d0:	fffd0d13          	addi	s10,s10,-1
400070d4:	02c7d7b3          	divu	a5,a5,a2
400070d8:	03070713          	addi	a4,a4,48
400070dc:	00ed0023          	sb	a4,0(s10)
400070e0:	fe0796e3          	bnez	a5,400070cc <_vfiprintf_r+0xc18>
400070e4:	41ac0db3          	sub	s11,s8,s10
400070e8:	fa8ff06f          	j	40006890 <_vfiprintf_r+0x3dc>
400070ec:	00000d93          	li	s11,0
400070f0:	000c0d13          	mv	s10,s8
400070f4:	f9cff06f          	j	40006890 <_vfiprintf_r+0x3dc>
400070f8:	03c10613          	addi	a2,sp,60
400070fc:	00098593          	mv	a1,s3
40007100:	000a8513          	mv	a0,s5
40007104:	aa8ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40007108:	e40512e3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
4000710c:	04412783          	lw	a5,68(sp)
40007110:	000c0413          	mv	s0,s8
40007114:	d71ff06f          	j	40006e84 <_vfiprintf_r+0x9d0>
40007118:	03c10613          	addi	a2,sp,60
4000711c:	00098593          	mv	a1,s3
40007120:	000a8513          	mv	a0,s5
40007124:	a88ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40007128:	e20512e3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
4000712c:	000c0413          	mv	s0,s8
40007130:	cc4ff06f          	j	400065f4 <_vfiprintf_r+0x140>
40007134:	01e12223          	sw	t5,4(sp)
40007138:	00000793          	li	a5,0
4000713c:	a19ff06f          	j	40006b54 <_vfiprintf_r+0x6a0>
40007140:	00412f03          	lw	t5,4(sp)
40007144:	03078793          	addi	a5,a5,48
40007148:	06f107a3          	sb	a5,111(sp)
4000714c:	01e12223          	sw	t5,4(sp)
40007150:	00100d93          	li	s11,1
40007154:	06f10d13          	addi	s10,sp,111
40007158:	f38ff06f          	j	40006890 <_vfiprintf_r+0x3dc>
4000715c:	03c10613          	addi	a2,sp,60
40007160:	00098593          	mv	a1,s3
40007164:	000a8513          	mv	a0,s5
40007168:	00512c23          	sw	t0,24(sp)
4000716c:	00d12a23          	sw	a3,20(sp)
40007170:	a3cff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40007174:	dc051ce3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40007178:	04012703          	lw	a4,64(sp)
4000717c:	04412783          	lw	a5,68(sp)
40007180:	000c0413          	mv	s0,s8
40007184:	00170613          	addi	a2,a4,1
40007188:	01812283          	lw	t0,24(sp)
4000718c:	01412683          	lw	a3,20(sp)
40007190:	c49ff06f          	j	40006dd8 <_vfiprintf_r+0x924>
40007194:	12079e63          	bnez	a5,400072d0 <_vfiprintf_r+0xe1c>
40007198:	00100613          	li	a2,1
4000719c:	00000713          	li	a4,0
400071a0:	000c0413          	mv	s0,s8
400071a4:	c3dff06f          	j	40006de0 <_vfiprintf_r+0x92c>
400071a8:	00072783          	lw	a5,0(a4)
400071ac:	00470713          	addi	a4,a4,4
400071b0:	00e12623          	sw	a4,12(sp)
400071b4:	975ff06f          	j	40006b28 <_vfiprintf_r+0x674>
400071b8:	00062783          	lw	a5,0(a2)
400071bc:	00460613          	addi	a2,a2,4
400071c0:	00c12623          	sw	a2,12(sp)
400071c4:	addff06f          	j	40006ca0 <_vfiprintf_r+0x7ec>
400071c8:	03c10613          	addi	a2,sp,60
400071cc:	00098593          	mv	a1,s3
400071d0:	000a8513          	mv	a0,s5
400071d4:	9d8ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
400071d8:	d6051ae3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
400071dc:	04012603          	lw	a2,64(sp)
400071e0:	04412783          	lw	a5,68(sp)
400071e4:	000c0413          	mv	s0,s8
400071e8:	00160613          	addi	a2,a2,1
400071ec:	841ff06f          	j	40006a2c <_vfiprintf_r+0x578>
400071f0:	00c12703          	lw	a4,12(sp)
400071f4:	00072783          	lw	a5,0(a4)
400071f8:	00470713          	addi	a4,a4,4
400071fc:	00e12623          	sw	a4,12(sp)
40007200:	00812703          	lw	a4,8(sp)
40007204:	00e7a023          	sw	a4,0(a5)
40007208:	b90ff06f          	j	40006598 <_vfiprintf_r+0xe4>
4000720c:	000b0493          	mv	s1,s6
40007210:	bf0ff06f          	j	40006600 <_vfiprintf_r+0x14c>
40007214:	00c12703          	lw	a4,12(sp)
40007218:	00072783          	lw	a5,0(a4)
4000721c:	00470713          	addi	a4,a4,4
40007220:	00e12623          	sw	a4,12(sp)
40007224:	905ff06f          	j	40006b28 <_vfiprintf_r+0x674>
40007228:	00c12603          	lw	a2,12(sp)
4000722c:	00062783          	lw	a5,0(a2)
40007230:	00460613          	addi	a2,a2,4
40007234:	00c12623          	sw	a2,12(sp)
40007238:	a69ff06f          	j	40006ca0 <_vfiprintf_r+0x7ec>
4000723c:	02d00713          	li	a4,45
40007240:	40f007b3          	neg	a5,a5
40007244:	02e10ba3          	sb	a4,55(sp)
40007248:	02d00593          	li	a1,45
4000724c:	00100613          	li	a2,1
40007250:	9a1ff06f          	j	40006bf0 <_vfiprintf_r+0x73c>
40007254:	03c10613          	addi	a2,sp,60
40007258:	00098593          	mv	a1,s3
4000725c:	000a8513          	mv	a0,s5
40007260:	02512023          	sw	t0,32(sp)
40007264:	00712c23          	sw	t2,24(sp)
40007268:	00d12a23          	sw	a3,20(sp)
4000726c:	940ff0ef          	jal	ra,400063ac <__sprint_r.part.0>
40007270:	cc051ee3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
40007274:	04012703          	lw	a4,64(sp)
40007278:	04412783          	lw	a5,68(sp)
4000727c:	000c0413          	mv	s0,s8
40007280:	00170613          	addi	a2,a4,1
40007284:	02012283          	lw	t0,32(sp)
40007288:	01812383          	lw	t2,24(sp)
4000728c:	01412683          	lw	a3,20(sp)
40007290:	b09ff06f          	j	40006d98 <_vfiprintf_r+0x8e4>
40007294:	03c10613          	addi	a2,sp,60
40007298:	00098593          	mv	a1,s3
4000729c:	000a8513          	mv	a0,s5
400072a0:	90cff0ef          	jal	ra,400063ac <__sprint_r.part.0>
400072a4:	ca0514e3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
400072a8:	04412783          	lw	a5,68(sp)
400072ac:	bedff06f          	j	40006e98 <_vfiprintf_r+0x9e4>
400072b0:	000d0513          	mv	a0,s10
400072b4:	01e12223          	sw	t5,4(sp)
400072b8:	85cff0ef          	jal	ra,40006314 <strlen>
400072bc:	00050d93          	mv	s11,a0
400072c0:	03714583          	lbu	a1,55(sp)
400072c4:	00912623          	sw	s1,12(sp)
400072c8:	00000693          	li	a3,0
400072cc:	dc4ff06f          	j	40006890 <_vfiprintf_r+0x3dc>
400072d0:	03c10613          	addi	a2,sp,60
400072d4:	00098593          	mv	a1,s3
400072d8:	000a8513          	mv	a0,s5
400072dc:	00d12a23          	sw	a3,20(sp)
400072e0:	8ccff0ef          	jal	ra,400063ac <__sprint_r.part.0>
400072e4:	c60514e3          	bnez	a0,40006f4c <_vfiprintf_r+0xa98>
400072e8:	04012703          	lw	a4,64(sp)
400072ec:	04412783          	lw	a5,68(sp)
400072f0:	000c0413          	mv	s0,s8
400072f4:	00170613          	addi	a2,a4,1
400072f8:	01412683          	lw	a3,20(sp)
400072fc:	ae5ff06f          	j	40006de0 <_vfiprintf_r+0x92c>
40007300:	04012703          	lw	a4,64(sp)
40007304:	00170713          	addi	a4,a4,1
40007308:	e24ff06f          	j	4000692c <_vfiprintf_r+0x478>
4000730c:	00600793          	li	a5,6
40007310:	00068d93          	mv	s11,a3
40007314:	00d7f463          	bleu	a3,a5,4000731c <_vfiprintf_r+0xe68>
40007318:	00078d93          	mv	s11,a5
4000731c:	4000beb7          	lui	t4,0x4000b
40007320:	000d8a13          	mv	s4,s11
40007324:	00912623          	sw	s1,12(sp)
40007328:	7d8e8d13          	addi	s10,t4,2008 # 4000b7d8 <zeroes.4139+0x48>
4000732c:	921ff06f          	j	40006c4c <_vfiprintf_r+0x798>
40007330:	04012603          	lw	a2,64(sp)
40007334:	00160613          	addi	a2,a2,1
40007338:	f90ff06f          	j	40006ac8 <_vfiprintf_r+0x614>
4000733c:	00068d93          	mv	s11,a3
40007340:	03714583          	lbu	a1,55(sp)
40007344:	00912623          	sw	s1,12(sp)
40007348:	01e12223          	sw	t5,4(sp)
4000734c:	00000693          	li	a3,0
40007350:	d40ff06f          	j	40006890 <_vfiprintf_r+0x3dc>
40007354:	00060593          	mv	a1,a2
40007358:	ea4ff06f          	j	400069fc <_vfiprintf_r+0x548>
4000735c:	00c12783          	lw	a5,12(sp)
40007360:	0007a683          	lw	a3,0(a5)
40007364:	00478b13          	addi	s6,a5,4
40007368:	0206c263          	bltz	a3,4000738c <_vfiprintf_r+0xed8>
4000736c:	01612623          	sw	s6,12(sp)
40007370:	00048b13          	mv	s6,s1
40007374:	000b0493          	mv	s1,s6
40007378:	ac8ff06f          	j	40006640 <_vfiprintf_r+0x18c>
4000737c:	03f10ba3          	sb	t6,55(sp)
40007380:	999ff06f          	j	40006d18 <_vfiprintf_r+0x864>
40007384:	03f10ba3          	sb	t6,55(sp)
40007388:	c88ff06f          	j	40006810 <_vfiprintf_r+0x35c>
4000738c:	000d8693          	mv	a3,s11
40007390:	fddff06f          	j	4000736c <_vfiprintf_r+0xeb8>
40007394:	03f10ba3          	sb	t6,55(sp)
40007398:	f6cff06f          	j	40006b04 <_vfiprintf_r+0x650>
4000739c:	03f10ba3          	sb	t6,55(sp)
400073a0:	935ff06f          	j	40006cd4 <_vfiprintf_r+0x820>
400073a4:	03f10ba3          	sb	t6,55(sp)
400073a8:	8cdff06f          	j	40006c74 <_vfiprintf_r+0x7c0>

400073ac <vfiprintf>:
400073ac:	4000c7b7          	lui	a5,0x4000c
400073b0:	00060693          	mv	a3,a2
400073b4:	00058613          	mv	a2,a1
400073b8:	00050593          	mv	a1,a0
400073bc:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
400073c0:	8f4ff06f          	j	400064b4 <_vfiprintf_r>

400073c4 <__sbprintf>:
400073c4:	00c5d783          	lhu	a5,12(a1)
400073c8:	0645ae03          	lw	t3,100(a1)
400073cc:	00e5d303          	lhu	t1,14(a1)
400073d0:	01c5a883          	lw	a7,28(a1)
400073d4:	0245a803          	lw	a6,36(a1)
400073d8:	b8010113          	addi	sp,sp,-1152
400073dc:	ffd7f793          	andi	a5,a5,-3
400073e0:	40000713          	li	a4,1024
400073e4:	46812c23          	sw	s0,1144(sp)
400073e8:	00f11a23          	sh	a5,20(sp)
400073ec:	00058413          	mv	s0,a1
400073f0:	07010793          	addi	a5,sp,112
400073f4:	00810593          	addi	a1,sp,8
400073f8:	46912a23          	sw	s1,1140(sp)
400073fc:	47212823          	sw	s2,1136(sp)
40007400:	46112e23          	sw	ra,1148(sp)
40007404:	00050913          	mv	s2,a0
40007408:	07c12623          	sw	t3,108(sp)
4000740c:	00611b23          	sh	t1,22(sp)
40007410:	03112223          	sw	a7,36(sp)
40007414:	03012623          	sw	a6,44(sp)
40007418:	00f12423          	sw	a5,8(sp)
4000741c:	00f12c23          	sw	a5,24(sp)
40007420:	00e12823          	sw	a4,16(sp)
40007424:	00e12e23          	sw	a4,28(sp)
40007428:	02012023          	sw	zero,32(sp)
4000742c:	888ff0ef          	jal	ra,400064b4 <_vfiprintf_r>
40007430:	00050493          	mv	s1,a0
40007434:	00054a63          	bltz	a0,40007448 <__sbprintf+0x84>
40007438:	00810593          	addi	a1,sp,8
4000743c:	00090513          	mv	a0,s2
40007440:	cfcfc0ef          	jal	ra,4000393c <_fflush_r>
40007444:	02051c63          	bnez	a0,4000747c <__sbprintf+0xb8>
40007448:	01415783          	lhu	a5,20(sp)
4000744c:	0407f793          	andi	a5,a5,64
40007450:	00078863          	beqz	a5,40007460 <__sbprintf+0x9c>
40007454:	00c45783          	lhu	a5,12(s0)
40007458:	0407e793          	ori	a5,a5,64
4000745c:	00f41623          	sh	a5,12(s0)
40007460:	47c12083          	lw	ra,1148(sp)
40007464:	00048513          	mv	a0,s1
40007468:	47812403          	lw	s0,1144(sp)
4000746c:	47412483          	lw	s1,1140(sp)
40007470:	47012903          	lw	s2,1136(sp)
40007474:	48010113          	addi	sp,sp,1152
40007478:	00008067          	ret
4000747c:	fff00493          	li	s1,-1
40007480:	fc9ff06f          	j	40007448 <__sbprintf+0x84>

40007484 <_write_r>:
40007484:	ff010113          	addi	sp,sp,-16
40007488:	00058793          	mv	a5,a1
4000748c:	00812423          	sw	s0,8(sp)
40007490:	00912223          	sw	s1,4(sp)
40007494:	00060593          	mv	a1,a2
40007498:	00050493          	mv	s1,a0
4000749c:	4000c437          	lui	s0,0x4000c
400074a0:	00078513          	mv	a0,a5
400074a4:	00068613          	mv	a2,a3
400074a8:	00112623          	sw	ra,12(sp)
400074ac:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
400074b0:	bc1f80ef          	jal	ra,40000070 <write>
400074b4:	fff00793          	li	a5,-1
400074b8:	00f50c63          	beq	a0,a5,400074d0 <_write_r+0x4c>
400074bc:	00c12083          	lw	ra,12(sp)
400074c0:	00812403          	lw	s0,8(sp)
400074c4:	00412483          	lw	s1,4(sp)
400074c8:	01010113          	addi	sp,sp,16
400074cc:	00008067          	ret
400074d0:	68442783          	lw	a5,1668(s0)
400074d4:	fe0784e3          	beqz	a5,400074bc <_write_r+0x38>
400074d8:	00c12083          	lw	ra,12(sp)
400074dc:	00f4a023          	sw	a5,0(s1)
400074e0:	00812403          	lw	s0,8(sp)
400074e4:	00412483          	lw	s1,4(sp)
400074e8:	01010113          	addi	sp,sp,16
400074ec:	00008067          	ret

400074f0 <_calloc_r>:
400074f0:	02c585b3          	mul	a1,a1,a2
400074f4:	ff010113          	addi	sp,sp,-16
400074f8:	00812423          	sw	s0,8(sp)
400074fc:	00112623          	sw	ra,12(sp)
40007500:	898fd0ef          	jal	ra,40004598 <_malloc_r>
40007504:	00050413          	mv	s0,a0
40007508:	04050e63          	beqz	a0,40007564 <_calloc_r+0x74>
4000750c:	ffc52603          	lw	a2,-4(a0)
40007510:	02400713          	li	a4,36
40007514:	ffc67613          	andi	a2,a2,-4
40007518:	ffc60613          	addi	a2,a2,-4
4000751c:	04c76e63          	bltu	a4,a2,40007578 <_calloc_r+0x88>
40007520:	01300693          	li	a3,19
40007524:	00050793          	mv	a5,a0
40007528:	02c6f863          	bleu	a2,a3,40007558 <_calloc_r+0x68>
4000752c:	00052023          	sw	zero,0(a0)
40007530:	00052223          	sw	zero,4(a0)
40007534:	01b00793          	li	a5,27
40007538:	04c7fe63          	bleu	a2,a5,40007594 <_calloc_r+0xa4>
4000753c:	00052423          	sw	zero,8(a0)
40007540:	00052623          	sw	zero,12(a0)
40007544:	01050793          	addi	a5,a0,16
40007548:	00e61863          	bne	a2,a4,40007558 <_calloc_r+0x68>
4000754c:	00052823          	sw	zero,16(a0)
40007550:	01850793          	addi	a5,a0,24
40007554:	00052a23          	sw	zero,20(a0)
40007558:	0007a023          	sw	zero,0(a5)
4000755c:	0007a223          	sw	zero,4(a5)
40007560:	0007a423          	sw	zero,8(a5)
40007564:	00c12083          	lw	ra,12(sp)
40007568:	00040513          	mv	a0,s0
4000756c:	00812403          	lw	s0,8(sp)
40007570:	01010113          	addi	sp,sp,16
40007574:	00008067          	ret
40007578:	00000593          	li	a1,0
4000757c:	961fd0ef          	jal	ra,40004edc <memset>
40007580:	00c12083          	lw	ra,12(sp)
40007584:	00040513          	mv	a0,s0
40007588:	00812403          	lw	s0,8(sp)
4000758c:	01010113          	addi	sp,sp,16
40007590:	00008067          	ret
40007594:	00850793          	addi	a5,a0,8
40007598:	fc1ff06f          	j	40007558 <_calloc_r+0x68>

4000759c <_close_r>:
4000759c:	ff010113          	addi	sp,sp,-16
400075a0:	00812423          	sw	s0,8(sp)
400075a4:	00912223          	sw	s1,4(sp)
400075a8:	4000c437          	lui	s0,0x4000c
400075ac:	00050493          	mv	s1,a0
400075b0:	00058513          	mv	a0,a1
400075b4:	00112623          	sw	ra,12(sp)
400075b8:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
400075bc:	a55f80ef          	jal	ra,40000010 <close>
400075c0:	fff00793          	li	a5,-1
400075c4:	00f50c63          	beq	a0,a5,400075dc <_close_r+0x40>
400075c8:	00c12083          	lw	ra,12(sp)
400075cc:	00812403          	lw	s0,8(sp)
400075d0:	00412483          	lw	s1,4(sp)
400075d4:	01010113          	addi	sp,sp,16
400075d8:	00008067          	ret
400075dc:	68442783          	lw	a5,1668(s0)
400075e0:	fe0784e3          	beqz	a5,400075c8 <_close_r+0x2c>
400075e4:	00c12083          	lw	ra,12(sp)
400075e8:	00f4a023          	sw	a5,0(s1)
400075ec:	00812403          	lw	s0,8(sp)
400075f0:	00412483          	lw	s1,4(sp)
400075f4:	01010113          	addi	sp,sp,16
400075f8:	00008067          	ret

400075fc <_fclose_r>:
400075fc:	ff010113          	addi	sp,sp,-16
40007600:	00112623          	sw	ra,12(sp)
40007604:	00812423          	sw	s0,8(sp)
40007608:	00912223          	sw	s1,4(sp)
4000760c:	01212023          	sw	s2,0(sp)
40007610:	02058063          	beqz	a1,40007630 <_fclose_r+0x34>
40007614:	00050493          	mv	s1,a0
40007618:	00058413          	mv	s0,a1
4000761c:	00050663          	beqz	a0,40007628 <_fclose_r+0x2c>
40007620:	03852783          	lw	a5,56(a0)
40007624:	0a078c63          	beqz	a5,400076dc <_fclose_r+0xe0>
40007628:	00c41783          	lh	a5,12(s0)
4000762c:	02079263          	bnez	a5,40007650 <_fclose_r+0x54>
40007630:	00c12083          	lw	ra,12(sp)
40007634:	00000913          	li	s2,0
40007638:	00090513          	mv	a0,s2
4000763c:	00812403          	lw	s0,8(sp)
40007640:	00412483          	lw	s1,4(sp)
40007644:	00012903          	lw	s2,0(sp)
40007648:	01010113          	addi	sp,sp,16
4000764c:	00008067          	ret
40007650:	00040593          	mv	a1,s0
40007654:	00048513          	mv	a0,s1
40007658:	850fc0ef          	jal	ra,400036a8 <__sflush_r>
4000765c:	02c42783          	lw	a5,44(s0)
40007660:	00050913          	mv	s2,a0
40007664:	00078a63          	beqz	a5,40007678 <_fclose_r+0x7c>
40007668:	01c42583          	lw	a1,28(s0)
4000766c:	00048513          	mv	a0,s1
40007670:	000780e7          	jalr	a5
40007674:	06054863          	bltz	a0,400076e4 <_fclose_r+0xe8>
40007678:	00c45783          	lhu	a5,12(s0)
4000767c:	0807f793          	andi	a5,a5,128
40007680:	06079663          	bnez	a5,400076ec <_fclose_r+0xf0>
40007684:	03042583          	lw	a1,48(s0)
40007688:	00058c63          	beqz	a1,400076a0 <_fclose_r+0xa4>
4000768c:	04040793          	addi	a5,s0,64
40007690:	00f58663          	beq	a1,a5,4000769c <_fclose_r+0xa0>
40007694:	00048513          	mv	a0,s1
40007698:	fecfc0ef          	jal	ra,40003e84 <_free_r>
4000769c:	02042823          	sw	zero,48(s0)
400076a0:	04442583          	lw	a1,68(s0)
400076a4:	00058863          	beqz	a1,400076b4 <_fclose_r+0xb8>
400076a8:	00048513          	mv	a0,s1
400076ac:	fd8fc0ef          	jal	ra,40003e84 <_free_r>
400076b0:	04042223          	sw	zero,68(s0)
400076b4:	e5cfc0ef          	jal	ra,40003d10 <__sfp_lock_acquire>
400076b8:	00041623          	sh	zero,12(s0)
400076bc:	e58fc0ef          	jal	ra,40003d14 <__sfp_lock_release>
400076c0:	00c12083          	lw	ra,12(sp)
400076c4:	00090513          	mv	a0,s2
400076c8:	00812403          	lw	s0,8(sp)
400076cc:	00412483          	lw	s1,4(sp)
400076d0:	00012903          	lw	s2,0(sp)
400076d4:	01010113          	addi	sp,sp,16
400076d8:	00008067          	ret
400076dc:	e24fc0ef          	jal	ra,40003d00 <__sinit>
400076e0:	f49ff06f          	j	40007628 <_fclose_r+0x2c>
400076e4:	fff00913          	li	s2,-1
400076e8:	f91ff06f          	j	40007678 <_fclose_r+0x7c>
400076ec:	01042583          	lw	a1,16(s0)
400076f0:	00048513          	mv	a0,s1
400076f4:	f90fc0ef          	jal	ra,40003e84 <_free_r>
400076f8:	f8dff06f          	j	40007684 <_fclose_r+0x88>

400076fc <fclose>:
400076fc:	4000c7b7          	lui	a5,0x4000c
40007700:	00050593          	mv	a1,a0
40007704:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
40007708:	ef5ff06f          	j	400075fc <_fclose_r>

4000770c <__fputwc>:
4000770c:	fc010113          	addi	sp,sp,-64
40007710:	02812c23          	sw	s0,56(sp)
40007714:	03412423          	sw	s4,40(sp)
40007718:	03512223          	sw	s5,36(sp)
4000771c:	02112e23          	sw	ra,60(sp)
40007720:	02912a23          	sw	s1,52(sp)
40007724:	03212823          	sw	s2,48(sp)
40007728:	03312623          	sw	s3,44(sp)
4000772c:	03612023          	sw	s6,32(sp)
40007730:	01712e23          	sw	s7,28(sp)
40007734:	00050a13          	mv	s4,a0
40007738:	00058a93          	mv	s5,a1
4000773c:	00060413          	mv	s0,a2
40007740:	c35fc0ef          	jal	ra,40004374 <__locale_mb_cur_max>
40007744:	00100793          	li	a5,1
40007748:	0cf50863          	beq	a0,a5,40007818 <__fputwc+0x10c>
4000774c:	00c10493          	addi	s1,sp,12
40007750:	05c40693          	addi	a3,s0,92
40007754:	000a8613          	mv	a2,s5
40007758:	00048593          	mv	a1,s1
4000775c:	000a0513          	mv	a0,s4
40007760:	104010ef          	jal	ra,40008864 <_wcrtomb_r>
40007764:	fff00793          	li	a5,-1
40007768:	00050993          	mv	s3,a0
4000776c:	08f50e63          	beq	a0,a5,40007808 <__fputwc+0xfc>
40007770:	0c050463          	beqz	a0,40007838 <__fputwc+0x12c>
40007774:	00c14703          	lbu	a4,12(sp)
40007778:	00000913          	li	s2,0
4000777c:	fff00b93          	li	s7,-1
40007780:	00a00b13          	li	s6,10
40007784:	0240006f          	j	400077a8 <__fputwc+0x9c>
_ELIDABLE_INLINE int __sputc_r(struct _reent *_ptr, int _c, FILE *_p) {
#ifdef __SCLE
	if ((_p->_flags & __SCLE) && _c == '\n')
	  __sputc_r (_ptr, '\r', _p);
#endif
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
40007788:	00042783          	lw	a5,0(s0)
4000778c:	00178693          	addi	a3,a5,1
		return (*_p->_p++ = _c);
40007790:	00d42023          	sw	a3,0(s0)
40007794:	00e78023          	sb	a4,0(a5)
40007798:	00190913          	addi	s2,s2,1
4000779c:	00148493          	addi	s1,s1,1
400077a0:	09397c63          	bleu	s3,s2,40007838 <__fputwc+0x12c>
400077a4:	0004c703          	lbu	a4,0(s1)
400077a8:	00842783          	lw	a5,8(s0)
400077ac:	fff78793          	addi	a5,a5,-1
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
400077b0:	00f42423          	sw	a5,8(s0)
400077b4:	fc07dae3          	bgez	a5,40007788 <__fputwc+0x7c>
400077b8:	01842683          	lw	a3,24(s0)
400077bc:	00070593          	mv	a1,a4
400077c0:	00040613          	mv	a2,s0
	else
		return (__swbuf_r(_ptr, _c, _p));
400077c4:	000a0513          	mv	a0,s4
400077c8:	00d7c463          	blt	a5,a3,400077d0 <__fputwc+0xc4>
400077cc:	fb671ee3          	bne	a4,s6,40007788 <__fputwc+0x7c>
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
400077d0:	709000ef          	jal	ra,400086d8 <__swbuf_r>
400077d4:	fd7512e3          	bne	a0,s7,40007798 <__fputwc+0x8c>
		return (__swbuf_r(_ptr, _c, _p));
400077d8:	000b8513          	mv	a0,s7
400077dc:	03c12083          	lw	ra,60(sp)
400077e0:	03812403          	lw	s0,56(sp)
400077e4:	03412483          	lw	s1,52(sp)
400077e8:	03012903          	lw	s2,48(sp)
400077ec:	02c12983          	lw	s3,44(sp)
400077f0:	02812a03          	lw	s4,40(sp)
400077f4:	02412a83          	lw	s5,36(sp)
400077f8:	02012b03          	lw	s6,32(sp)
400077fc:	01c12b83          	lw	s7,28(sp)
40007800:	04010113          	addi	sp,sp,64
40007804:	00008067          	ret
40007808:	00c45783          	lhu	a5,12(s0)
4000780c:	0407e793          	ori	a5,a5,64
40007810:	00f41623          	sh	a5,12(s0)
40007814:	fc9ff06f          	j	400077dc <__fputwc+0xd0>
40007818:	fffa8793          	addi	a5,s5,-1
4000781c:	0fe00713          	li	a4,254
40007820:	f2f766e3          	bltu	a4,a5,4000774c <__fputwc+0x40>
40007824:	0ffaf713          	andi	a4,s5,255
40007828:	00e10623          	sb	a4,12(sp)
4000782c:	00050993          	mv	s3,a0
40007830:	00c10493          	addi	s1,sp,12
40007834:	f45ff06f          	j	40007778 <__fputwc+0x6c>
40007838:	000a8513          	mv	a0,s5
4000783c:	fa1ff06f          	j	400077dc <__fputwc+0xd0>

40007840 <_fputwc_r>:
40007840:	00c61783          	lh	a5,12(a2)
40007844:	000026b7          	lui	a3,0x2
40007848:	01279713          	slli	a4,a5,0x12
4000784c:	00074c63          	bltz	a4,40007864 <_fputwc_r+0x24>
40007850:	06462703          	lw	a4,100(a2)
40007854:	00d7e7b3          	or	a5,a5,a3
40007858:	00f61623          	sh	a5,12(a2)
4000785c:	00d767b3          	or	a5,a4,a3
40007860:	06f62223          	sw	a5,100(a2)
40007864:	ea9ff06f          	j	4000770c <__fputwc>

40007868 <fputwc>:
40007868:	ff010113          	addi	sp,sp,-16
4000786c:	4000c7b7          	lui	a5,0x4000c
40007870:	00912223          	sw	s1,4(sp)
40007874:	62c7a483          	lw	s1,1580(a5) # 4000c62c <_impure_ptr>
40007878:	00812423          	sw	s0,8(sp)
4000787c:	01212023          	sw	s2,0(sp)
40007880:	00112623          	sw	ra,12(sp)
40007884:	00050913          	mv	s2,a0
40007888:	00058413          	mv	s0,a1
4000788c:	00048663          	beqz	s1,40007898 <fputwc+0x30>
40007890:	0384a783          	lw	a5,56(s1)
40007894:	04078663          	beqz	a5,400078e0 <fputwc+0x78>
40007898:	00c41783          	lh	a5,12(s0)
4000789c:	000026b7          	lui	a3,0x2
400078a0:	01279713          	slli	a4,a5,0x12
400078a4:	00074c63          	bltz	a4,400078bc <fputwc+0x54>
400078a8:	06442703          	lw	a4,100(s0)
400078ac:	00d7e7b3          	or	a5,a5,a3
400078b0:	00f41623          	sh	a5,12(s0)
400078b4:	00d767b3          	or	a5,a4,a3
400078b8:	06f42223          	sw	a5,100(s0)
400078bc:	00040613          	mv	a2,s0
400078c0:	00090593          	mv	a1,s2
400078c4:	00048513          	mv	a0,s1
400078c8:	00c12083          	lw	ra,12(sp)
400078cc:	00812403          	lw	s0,8(sp)
400078d0:	00412483          	lw	s1,4(sp)
400078d4:	00012903          	lw	s2,0(sp)
400078d8:	01010113          	addi	sp,sp,16
400078dc:	e31ff06f          	j	4000770c <__fputwc>
400078e0:	00048513          	mv	a0,s1
400078e4:	c1cfc0ef          	jal	ra,40003d00 <__sinit>
400078e8:	fb1ff06f          	j	40007898 <fputwc+0x30>

400078ec <_fstat_r>:
400078ec:	ff010113          	addi	sp,sp,-16
400078f0:	00058793          	mv	a5,a1
400078f4:	00812423          	sw	s0,8(sp)
400078f8:	00912223          	sw	s1,4(sp)
400078fc:	4000c437          	lui	s0,0x4000c
40007900:	00050493          	mv	s1,a0
40007904:	00060593          	mv	a1,a2
40007908:	00078513          	mv	a0,a5
4000790c:	00112623          	sw	ra,12(sp)
40007910:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
40007914:	eecf80ef          	jal	ra,40000000 <fstat>
40007918:	fff00793          	li	a5,-1
4000791c:	00f50c63          	beq	a0,a5,40007934 <_fstat_r+0x48>
40007920:	00c12083          	lw	ra,12(sp)
40007924:	00812403          	lw	s0,8(sp)
40007928:	00412483          	lw	s1,4(sp)
4000792c:	01010113          	addi	sp,sp,16
40007930:	00008067          	ret
40007934:	68442783          	lw	a5,1668(s0)
40007938:	fe0784e3          	beqz	a5,40007920 <_fstat_r+0x34>
4000793c:	00c12083          	lw	ra,12(sp)
40007940:	00f4a023          	sw	a5,0(s1)
40007944:	00812403          	lw	s0,8(sp)
40007948:	00412483          	lw	s1,4(sp)
4000794c:	01010113          	addi	sp,sp,16
40007950:	00008067          	ret

40007954 <__sfvwrite_r>:
40007954:	00862783          	lw	a5,8(a2)
40007958:	1c078263          	beqz	a5,40007b1c <__sfvwrite_r+0x1c8>
4000795c:	00c5d703          	lhu	a4,12(a1)
40007960:	fc010113          	addi	sp,sp,-64
40007964:	02812c23          	sw	s0,56(sp)
40007968:	03412423          	sw	s4,40(sp)
4000796c:	03612023          	sw	s6,32(sp)
40007970:	02112e23          	sw	ra,60(sp)
40007974:	02912a23          	sw	s1,52(sp)
40007978:	03212823          	sw	s2,48(sp)
4000797c:	03312623          	sw	s3,44(sp)
40007980:	03512223          	sw	s5,36(sp)
40007984:	01712e23          	sw	s7,28(sp)
40007988:	01812c23          	sw	s8,24(sp)
4000798c:	01912a23          	sw	s9,20(sp)
40007990:	01a12823          	sw	s10,16(sp)
40007994:	01b12623          	sw	s11,12(sp)
40007998:	00877793          	andi	a5,a4,8
4000799c:	00058413          	mv	s0,a1
400079a0:	00050b13          	mv	s6,a0
400079a4:	00060a13          	mv	s4,a2
400079a8:	0a078663          	beqz	a5,40007a54 <__sfvwrite_r+0x100>
400079ac:	0105a783          	lw	a5,16(a1)
400079b0:	0a078263          	beqz	a5,40007a54 <__sfvwrite_r+0x100>
400079b4:	00277793          	andi	a5,a4,2
400079b8:	000a2483          	lw	s1,0(s4)
400079bc:	0a078e63          	beqz	a5,40007a78 <__sfvwrite_r+0x124>
400079c0:	80000ab7          	lui	s5,0x80000
400079c4:	00000993          	li	s3,0
400079c8:	00000913          	li	s2,0
400079cc:	c00aca93          	xori	s5,s5,-1024
400079d0:	00098613          	mv	a2,s3
400079d4:	000b0513          	mv	a0,s6
400079d8:	12090a63          	beqz	s2,40007b0c <__sfvwrite_r+0x1b8>
400079dc:	00090693          	mv	a3,s2
400079e0:	012af463          	bleu	s2,s5,400079e8 <__sfvwrite_r+0x94>
400079e4:	000a8693          	mv	a3,s5
400079e8:	02442783          	lw	a5,36(s0)
400079ec:	01c42583          	lw	a1,28(s0)
400079f0:	000780e7          	jalr	a5
400079f4:	14a05263          	blez	a0,40007b38 <__sfvwrite_r+0x1e4>
400079f8:	008a2783          	lw	a5,8(s4)
400079fc:	00a989b3          	add	s3,s3,a0
40007a00:	40a90933          	sub	s2,s2,a0
40007a04:	40a78533          	sub	a0,a5,a0
40007a08:	00aa2423          	sw	a0,8(s4)
40007a0c:	fc0512e3          	bnez	a0,400079d0 <__sfvwrite_r+0x7c>
40007a10:	00000793          	li	a5,0
40007a14:	03c12083          	lw	ra,60(sp)
40007a18:	00078513          	mv	a0,a5
40007a1c:	03812403          	lw	s0,56(sp)
40007a20:	03412483          	lw	s1,52(sp)
40007a24:	03012903          	lw	s2,48(sp)
40007a28:	02c12983          	lw	s3,44(sp)
40007a2c:	02812a03          	lw	s4,40(sp)
40007a30:	02412a83          	lw	s5,36(sp)
40007a34:	02012b03          	lw	s6,32(sp)
40007a38:	01c12b83          	lw	s7,28(sp)
40007a3c:	01812c03          	lw	s8,24(sp)
40007a40:	01412c83          	lw	s9,20(sp)
40007a44:	01012d03          	lw	s10,16(sp)
40007a48:	00c12d83          	lw	s11,12(sp)
40007a4c:	04010113          	addi	sp,sp,64
40007a50:	00008067          	ret
40007a54:	00040593          	mv	a1,s0
40007a58:	000b0513          	mv	a0,s6
40007a5c:	ba4fa0ef          	jal	ra,40001e00 <__swsetup_r>
40007a60:	fff00793          	li	a5,-1
40007a64:	fa0518e3          	bnez	a0,40007a14 <__sfvwrite_r+0xc0>
40007a68:	00c45703          	lhu	a4,12(s0)
40007a6c:	000a2483          	lw	s1,0(s4)
40007a70:	00277793          	andi	a5,a4,2
40007a74:	f40796e3          	bnez	a5,400079c0 <__sfvwrite_r+0x6c>
40007a78:	00177793          	andi	a5,a4,1
40007a7c:	0c079863          	bnez	a5,40007b4c <__sfvwrite_r+0x1f8>
40007a80:	80000bb7          	lui	s7,0x80000
40007a84:	00000c13          	li	s8,0
40007a88:	00000913          	li	s2,0
40007a8c:	fffbcb93          	not	s7,s7
40007a90:	06090663          	beqz	s2,40007afc <__sfvwrite_r+0x1a8>
40007a94:	20077793          	andi	a5,a4,512
40007a98:	00842983          	lw	s3,8(s0)
40007a9c:	1a078263          	beqz	a5,40007c40 <__sfvwrite_r+0x2ec>
40007aa0:	27396063          	bltu	s2,s3,40007d00 <__sfvwrite_r+0x3ac>
40007aa4:	48077793          	andi	a5,a4,1152
40007aa8:	26079663          	bnez	a5,40007d14 <__sfvwrite_r+0x3c0>
40007aac:	00042503          	lw	a0,0(s0)
40007ab0:	00090a93          	mv	s5,s2
40007ab4:	00098c93          	mv	s9,s3
40007ab8:	000c8613          	mv	a2,s9
40007abc:	000c0593          	mv	a1,s8
40007ac0:	404000ef          	jal	ra,40007ec4 <memmove>
40007ac4:	00842783          	lw	a5,8(s0)
40007ac8:	00042603          	lw	a2,0(s0)
40007acc:	413789b3          	sub	s3,a5,s3
40007ad0:	01960633          	add	a2,a2,s9
40007ad4:	01342423          	sw	s3,8(s0)
40007ad8:	00c42023          	sw	a2,0(s0)
40007adc:	008a2783          	lw	a5,8(s4)
40007ae0:	015c0c33          	add	s8,s8,s5
40007ae4:	41590933          	sub	s2,s2,s5
40007ae8:	415789b3          	sub	s3,a5,s5
40007aec:	013a2423          	sw	s3,8(s4)
40007af0:	f20980e3          	beqz	s3,40007a10 <__sfvwrite_r+0xbc>
40007af4:	00c45703          	lhu	a4,12(s0)
40007af8:	f8091ee3          	bnez	s2,40007a94 <__sfvwrite_r+0x140>
40007afc:	0004ac03          	lw	s8,0(s1)
40007b00:	0044a903          	lw	s2,4(s1)
40007b04:	00848493          	addi	s1,s1,8
40007b08:	f89ff06f          	j	40007a90 <__sfvwrite_r+0x13c>
40007b0c:	0004a983          	lw	s3,0(s1)
40007b10:	0044a903          	lw	s2,4(s1)
40007b14:	00848493          	addi	s1,s1,8
40007b18:	eb9ff06f          	j	400079d0 <__sfvwrite_r+0x7c>
40007b1c:	00000793          	li	a5,0
40007b20:	00078513          	mv	a0,a5
40007b24:	00008067          	ret
40007b28:	00040593          	mv	a1,s0
40007b2c:	000b0513          	mv	a0,s6
40007b30:	e0dfb0ef          	jal	ra,4000393c <_fflush_r>
40007b34:	08050863          	beqz	a0,40007bc4 <__sfvwrite_r+0x270>
40007b38:	00c41783          	lh	a5,12(s0)
40007b3c:	0407e793          	ori	a5,a5,64
40007b40:	00f41623          	sh	a5,12(s0)
40007b44:	fff00793          	li	a5,-1
40007b48:	ecdff06f          	j	40007a14 <__sfvwrite_r+0xc0>
40007b4c:	00000913          	li	s2,0
40007b50:	00000993          	li	s3,0
40007b54:	00000513          	li	a0,0
40007b58:	00000d13          	li	s10,0
40007b5c:	00a00c93          	li	s9,10
40007b60:	00100c13          	li	s8,1
40007b64:	06090e63          	beqz	s2,40007be0 <__sfvwrite_r+0x28c>
40007b68:	08050463          	beqz	a0,40007bf0 <__sfvwrite_r+0x29c>
40007b6c:	00098b93          	mv	s7,s3
40007b70:	01397463          	bleu	s3,s2,40007b78 <__sfvwrite_r+0x224>
40007b74:	00090b93          	mv	s7,s2
40007b78:	00042503          	lw	a0,0(s0)
40007b7c:	01042783          	lw	a5,16(s0)
40007b80:	000b8a93          	mv	s5,s7
40007b84:	01442683          	lw	a3,20(s0)
40007b88:	00a7f863          	bleu	a0,a5,40007b98 <__sfvwrite_r+0x244>
40007b8c:	00842d83          	lw	s11,8(s0)
40007b90:	01b68db3          	add	s11,a3,s11
40007b94:	077dce63          	blt	s11,s7,40007c10 <__sfvwrite_r+0x2bc>
40007b98:	14dbc063          	blt	s7,a3,40007cd8 <__sfvwrite_r+0x384>
40007b9c:	02442783          	lw	a5,36(s0)
40007ba0:	01c42583          	lw	a1,28(s0)
40007ba4:	000d0613          	mv	a2,s10
40007ba8:	000b0513          	mv	a0,s6
40007bac:	000780e7          	jalr	a5
40007bb0:	00050a93          	mv	s5,a0
40007bb4:	f8a052e3          	blez	a0,40007b38 <__sfvwrite_r+0x1e4>
40007bb8:	415989b3          	sub	s3,s3,s5
40007bbc:	000c0513          	mv	a0,s8
40007bc0:	f60984e3          	beqz	s3,40007b28 <__sfvwrite_r+0x1d4>
40007bc4:	008a2783          	lw	a5,8(s4)
40007bc8:	015d0d33          	add	s10,s10,s5
40007bcc:	41590933          	sub	s2,s2,s5
40007bd0:	41578ab3          	sub	s5,a5,s5
40007bd4:	015a2423          	sw	s5,8(s4)
40007bd8:	e20a8ce3          	beqz	s5,40007a10 <__sfvwrite_r+0xbc>
40007bdc:	f80916e3          	bnez	s2,40007b68 <__sfvwrite_r+0x214>
40007be0:	0044a903          	lw	s2,4(s1)
40007be4:	0004ad03          	lw	s10,0(s1)
40007be8:	00848493          	addi	s1,s1,8
40007bec:	fe090ae3          	beqz	s2,40007be0 <__sfvwrite_r+0x28c>
40007bf0:	00090613          	mv	a2,s2
40007bf4:	000c8593          	mv	a1,s9
40007bf8:	000d0513          	mv	a0,s10
40007bfc:	8e8fd0ef          	jal	ra,40004ce4 <memchr>
40007c00:	1e050063          	beqz	a0,40007de0 <__sfvwrite_r+0x48c>
40007c04:	00150513          	addi	a0,a0,1
40007c08:	41a509b3          	sub	s3,a0,s10
40007c0c:	f61ff06f          	j	40007b6c <__sfvwrite_r+0x218>
40007c10:	000d0593          	mv	a1,s10
40007c14:	000d8613          	mv	a2,s11
40007c18:	2ac000ef          	jal	ra,40007ec4 <memmove>
40007c1c:	00042783          	lw	a5,0(s0)
40007c20:	00040593          	mv	a1,s0
40007c24:	000b0513          	mv	a0,s6
40007c28:	01b787b3          	add	a5,a5,s11
40007c2c:	00f42023          	sw	a5,0(s0)
40007c30:	d0dfb0ef          	jal	ra,4000393c <_fflush_r>
40007c34:	f00512e3          	bnez	a0,40007b38 <__sfvwrite_r+0x1e4>
40007c38:	000d8a93          	mv	s5,s11
40007c3c:	f7dff06f          	j	40007bb8 <__sfvwrite_r+0x264>
40007c40:	00042503          	lw	a0,0(s0)
40007c44:	01042783          	lw	a5,16(s0)
40007c48:	00a7e663          	bltu	a5,a0,40007c54 <__sfvwrite_r+0x300>
40007c4c:	01442783          	lw	a5,20(s0)
40007c50:	04f97a63          	bleu	a5,s2,40007ca4 <__sfvwrite_r+0x350>
40007c54:	01397463          	bleu	s3,s2,40007c5c <__sfvwrite_r+0x308>
40007c58:	00090993          	mv	s3,s2
40007c5c:	00098613          	mv	a2,s3
40007c60:	000c0593          	mv	a1,s8
40007c64:	260000ef          	jal	ra,40007ec4 <memmove>
40007c68:	00842783          	lw	a5,8(s0)
40007c6c:	00042703          	lw	a4,0(s0)
40007c70:	413787b3          	sub	a5,a5,s3
40007c74:	01370733          	add	a4,a4,s3
40007c78:	00f42423          	sw	a5,8(s0)
40007c7c:	00e42023          	sw	a4,0(s0)
40007c80:	00078663          	beqz	a5,40007c8c <__sfvwrite_r+0x338>
40007c84:	00098a93          	mv	s5,s3
40007c88:	e55ff06f          	j	40007adc <__sfvwrite_r+0x188>
40007c8c:	00040593          	mv	a1,s0
40007c90:	000b0513          	mv	a0,s6
40007c94:	ca9fb0ef          	jal	ra,4000393c <_fflush_r>
40007c98:	ea0510e3          	bnez	a0,40007b38 <__sfvwrite_r+0x1e4>
40007c9c:	00098a93          	mv	s5,s3
40007ca0:	e3dff06f          	j	40007adc <__sfvwrite_r+0x188>
40007ca4:	00090693          	mv	a3,s2
40007ca8:	012bf463          	bleu	s2,s7,40007cb0 <__sfvwrite_r+0x35c>
40007cac:	000b8693          	mv	a3,s7
40007cb0:	02f6c6b3          	div	a3,a3,a5
40007cb4:	02442703          	lw	a4,36(s0)
40007cb8:	01c42583          	lw	a1,28(s0)
40007cbc:	000c0613          	mv	a2,s8
40007cc0:	000b0513          	mv	a0,s6
40007cc4:	02f686b3          	mul	a3,a3,a5
40007cc8:	000700e7          	jalr	a4
40007ccc:	e6a056e3          	blez	a0,40007b38 <__sfvwrite_r+0x1e4>
40007cd0:	00050a93          	mv	s5,a0
40007cd4:	e09ff06f          	j	40007adc <__sfvwrite_r+0x188>
40007cd8:	000b8613          	mv	a2,s7
40007cdc:	000d0593          	mv	a1,s10
40007ce0:	1e4000ef          	jal	ra,40007ec4 <memmove>
40007ce4:	00842703          	lw	a4,8(s0)
40007ce8:	00042783          	lw	a5,0(s0)
40007cec:	41770733          	sub	a4,a4,s7
40007cf0:	01778bb3          	add	s7,a5,s7
40007cf4:	00e42423          	sw	a4,8(s0)
40007cf8:	01742023          	sw	s7,0(s0)
40007cfc:	ebdff06f          	j	40007bb8 <__sfvwrite_r+0x264>
40007d00:	00042503          	lw	a0,0(s0)
40007d04:	00090993          	mv	s3,s2
40007d08:	00090a93          	mv	s5,s2
40007d0c:	00090c93          	mv	s9,s2
40007d10:	da9ff06f          	j	40007ab8 <__sfvwrite_r+0x164>
40007d14:	01442783          	lw	a5,20(s0)
40007d18:	01042583          	lw	a1,16(s0)
40007d1c:	00042a83          	lw	s5,0(s0)
40007d20:	00179993          	slli	s3,a5,0x1
40007d24:	00f987b3          	add	a5,s3,a5
40007d28:	01f7d993          	srli	s3,a5,0x1f
40007d2c:	40ba8ab3          	sub	s5,s5,a1
40007d30:	00f989b3          	add	s3,s3,a5
40007d34:	001a8793          	addi	a5,s5,1 # 80000001 <_bss_end+0x3fff3979>
40007d38:	4019d993          	srai	s3,s3,0x1
40007d3c:	012787b3          	add	a5,a5,s2
40007d40:	00098613          	mv	a2,s3
40007d44:	00f9f663          	bleu	a5,s3,40007d50 <__sfvwrite_r+0x3fc>
40007d48:	00078993          	mv	s3,a5
40007d4c:	00078613          	mv	a2,a5
40007d50:	40077713          	andi	a4,a4,1024
40007d54:	04070e63          	beqz	a4,40007db0 <__sfvwrite_r+0x45c>
40007d58:	00060593          	mv	a1,a2
40007d5c:	000b0513          	mv	a0,s6
40007d60:	839fc0ef          	jal	ra,40004598 <_malloc_r>
40007d64:	00050c93          	mv	s9,a0
40007d68:	08050063          	beqz	a0,40007de8 <__sfvwrite_r+0x494>
40007d6c:	01042583          	lw	a1,16(s0)
40007d70:	000a8613          	mv	a2,s5
40007d74:	84cfd0ef          	jal	ra,40004dc0 <memcpy>
40007d78:	00c45783          	lhu	a5,12(s0)
40007d7c:	b7f7f793          	andi	a5,a5,-1153
40007d80:	0807e793          	ori	a5,a5,128
40007d84:	00f41623          	sh	a5,12(s0)
40007d88:	015c8533          	add	a0,s9,s5
40007d8c:	41598ab3          	sub	s5,s3,s5
40007d90:	01942823          	sw	s9,16(s0)
40007d94:	01342a23          	sw	s3,20(s0)
40007d98:	01542423          	sw	s5,8(s0)
40007d9c:	00a42023          	sw	a0,0(s0)
40007da0:	00090993          	mv	s3,s2
40007da4:	00090a93          	mv	s5,s2
40007da8:	00090c93          	mv	s9,s2
40007dac:	d0dff06f          	j	40007ab8 <__sfvwrite_r+0x164>
40007db0:	000b0513          	mv	a0,s6
40007db4:	298000ef          	jal	ra,4000804c <_realloc_r>
40007db8:	00050c93          	mv	s9,a0
40007dbc:	fc0516e3          	bnez	a0,40007d88 <__sfvwrite_r+0x434>
40007dc0:	01042583          	lw	a1,16(s0)
40007dc4:	000b0513          	mv	a0,s6
40007dc8:	8bcfc0ef          	jal	ra,40003e84 <_free_r>
40007dcc:	00c41783          	lh	a5,12(s0)
40007dd0:	00c00713          	li	a4,12
40007dd4:	00eb2023          	sw	a4,0(s6)
40007dd8:	f7f7f793          	andi	a5,a5,-129
40007ddc:	d61ff06f          	j	40007b3c <__sfvwrite_r+0x1e8>
40007de0:	00190993          	addi	s3,s2,1
40007de4:	d89ff06f          	j	40007b6c <__sfvwrite_r+0x218>
40007de8:	00c00793          	li	a5,12
40007dec:	00fb2023          	sw	a5,0(s6)
40007df0:	00c41783          	lh	a5,12(s0)
40007df4:	d49ff06f          	j	40007b3c <__sfvwrite_r+0x1e8>

40007df8 <_isatty_r>:
40007df8:	ff010113          	addi	sp,sp,-16
40007dfc:	00812423          	sw	s0,8(sp)
40007e00:	00912223          	sw	s1,4(sp)
40007e04:	4000c437          	lui	s0,0x4000c
40007e08:	00050493          	mv	s1,a0
40007e0c:	00058513          	mv	a0,a1
40007e10:	00112623          	sw	ra,12(sp)
40007e14:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
40007e18:	9f0f80ef          	jal	ra,40000008 <isatty>
40007e1c:	fff00793          	li	a5,-1
40007e20:	00f50c63          	beq	a0,a5,40007e38 <_isatty_r+0x40>
40007e24:	00c12083          	lw	ra,12(sp)
40007e28:	00812403          	lw	s0,8(sp)
40007e2c:	00412483          	lw	s1,4(sp)
40007e30:	01010113          	addi	sp,sp,16
40007e34:	00008067          	ret
40007e38:	68442783          	lw	a5,1668(s0)
40007e3c:	fe0784e3          	beqz	a5,40007e24 <_isatty_r+0x2c>
40007e40:	00c12083          	lw	ra,12(sp)
40007e44:	00f4a023          	sw	a5,0(s1)
40007e48:	00812403          	lw	s0,8(sp)
40007e4c:	00412483          	lw	s1,4(sp)
40007e50:	01010113          	addi	sp,sp,16
40007e54:	00008067          	ret

40007e58 <_lseek_r>:
40007e58:	ff010113          	addi	sp,sp,-16
40007e5c:	00058793          	mv	a5,a1
40007e60:	00812423          	sw	s0,8(sp)
40007e64:	00912223          	sw	s1,4(sp)
40007e68:	00060593          	mv	a1,a2
40007e6c:	00050493          	mv	s1,a0
40007e70:	4000c437          	lui	s0,0x4000c
40007e74:	00078513          	mv	a0,a5
40007e78:	00068613          	mv	a2,a3
40007e7c:	00112623          	sw	ra,12(sp)
40007e80:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
40007e84:	994f80ef          	jal	ra,40000018 <lseek>
40007e88:	fff00793          	li	a5,-1
40007e8c:	00f50c63          	beq	a0,a5,40007ea4 <_lseek_r+0x4c>
40007e90:	00c12083          	lw	ra,12(sp)
40007e94:	00812403          	lw	s0,8(sp)
40007e98:	00412483          	lw	s1,4(sp)
40007e9c:	01010113          	addi	sp,sp,16
40007ea0:	00008067          	ret
40007ea4:	68442783          	lw	a5,1668(s0)
40007ea8:	fe0784e3          	beqz	a5,40007e90 <_lseek_r+0x38>
40007eac:	00c12083          	lw	ra,12(sp)
40007eb0:	00f4a023          	sw	a5,0(s1)
40007eb4:	00812403          	lw	s0,8(sp)
40007eb8:	00412483          	lw	s1,4(sp)
40007ebc:	01010113          	addi	sp,sp,16
40007ec0:	00008067          	ret

40007ec4 <memmove>:
40007ec4:	02a5f663          	bleu	a0,a1,40007ef0 <memmove+0x2c>
40007ec8:	00c587b3          	add	a5,a1,a2
40007ecc:	02f57263          	bleu	a5,a0,40007ef0 <memmove+0x2c>
40007ed0:	00c50733          	add	a4,a0,a2
40007ed4:	04060263          	beqz	a2,40007f18 <memmove+0x54>
40007ed8:	fff78793          	addi	a5,a5,-1
40007edc:	0007c683          	lbu	a3,0(a5)
40007ee0:	fff70713          	addi	a4,a4,-1
40007ee4:	00d70023          	sb	a3,0(a4)
40007ee8:	fef598e3          	bne	a1,a5,40007ed8 <memmove+0x14>
40007eec:	00008067          	ret
40007ef0:	00f00893          	li	a7,15
40007ef4:	00050793          	mv	a5,a0
40007ef8:	02c8e263          	bltu	a7,a2,40007f1c <memmove+0x58>
40007efc:	0c060a63          	beqz	a2,40007fd0 <memmove+0x10c>
40007f00:	00c58633          	add	a2,a1,a2
40007f04:	00158593          	addi	a1,a1,1
40007f08:	fff5c703          	lbu	a4,-1(a1)
40007f0c:	00178793          	addi	a5,a5,1
40007f10:	fee78fa3          	sb	a4,-1(a5)
40007f14:	feb618e3          	bne	a2,a1,40007f04 <memmove+0x40>
40007f18:	00008067          	ret
40007f1c:	00a5e7b3          	or	a5,a1,a0
40007f20:	0037f793          	andi	a5,a5,3
40007f24:	0a079263          	bnez	a5,40007fc8 <memmove+0x104>
40007f28:	00058713          	mv	a4,a1
40007f2c:	00050793          	mv	a5,a0
40007f30:	00060693          	mv	a3,a2
40007f34:	00072803          	lw	a6,0(a4)
40007f38:	01078793          	addi	a5,a5,16
40007f3c:	01070713          	addi	a4,a4,16
40007f40:	ff07a823          	sw	a6,-16(a5)
40007f44:	ff472803          	lw	a6,-12(a4)
40007f48:	ff068693          	addi	a3,a3,-16 # 1ff0 <_stack_size+0x17f0>
40007f4c:	ff07aa23          	sw	a6,-12(a5)
40007f50:	ff872803          	lw	a6,-8(a4)
40007f54:	ff07ac23          	sw	a6,-8(a5)
40007f58:	ffc72803          	lw	a6,-4(a4)
40007f5c:	ff07ae23          	sw	a6,-4(a5)
40007f60:	fcd8eae3          	bltu	a7,a3,40007f34 <memmove+0x70>
40007f64:	ff060713          	addi	a4,a2,-16
40007f68:	ff077713          	andi	a4,a4,-16
40007f6c:	01070713          	addi	a4,a4,16
40007f70:	00f67e13          	andi	t3,a2,15
40007f74:	00300313          	li	t1,3
40007f78:	00e507b3          	add	a5,a0,a4
40007f7c:	00e585b3          	add	a1,a1,a4
40007f80:	05c37a63          	bleu	t3,t1,40007fd4 <memmove+0x110>
40007f84:	00058813          	mv	a6,a1
40007f88:	00078693          	mv	a3,a5
40007f8c:	000e0713          	mv	a4,t3
40007f90:	00480813          	addi	a6,a6,4
40007f94:	ffc82883          	lw	a7,-4(a6)
40007f98:	00468693          	addi	a3,a3,4
40007f9c:	ffc70713          	addi	a4,a4,-4
40007fa0:	ff16ae23          	sw	a7,-4(a3)
40007fa4:	fee366e3          	bltu	t1,a4,40007f90 <memmove+0xcc>
40007fa8:	ffce0713          	addi	a4,t3,-4
40007fac:	ffc77713          	andi	a4,a4,-4
40007fb0:	00470713          	addi	a4,a4,4
40007fb4:	00367613          	andi	a2,a2,3
40007fb8:	00e585b3          	add	a1,a1,a4
40007fbc:	00e787b3          	add	a5,a5,a4
40007fc0:	f40610e3          	bnez	a2,40007f00 <memmove+0x3c>
40007fc4:	00c0006f          	j	40007fd0 <memmove+0x10c>
40007fc8:	00050793          	mv	a5,a0
40007fcc:	f35ff06f          	j	40007f00 <memmove+0x3c>
40007fd0:	00008067          	ret
40007fd4:	000e0613          	mv	a2,t3
40007fd8:	f20614e3          	bnez	a2,40007f00 <memmove+0x3c>
40007fdc:	ff5ff06f          	j	40007fd0 <memmove+0x10c>

40007fe0 <_read_r>:
40007fe0:	ff010113          	addi	sp,sp,-16
40007fe4:	00058793          	mv	a5,a1
40007fe8:	00812423          	sw	s0,8(sp)
40007fec:	00912223          	sw	s1,4(sp)
40007ff0:	00060593          	mv	a1,a2
40007ff4:	00050493          	mv	s1,a0
40007ff8:	4000c437          	lui	s0,0x4000c
40007ffc:	00078513          	mv	a0,a5
40008000:	00068613          	mv	a2,a3
40008004:	00112623          	sw	ra,12(sp)
40008008:	68042223          	sw	zero,1668(s0) # 4000c684 <errno>
4000800c:	814f80ef          	jal	ra,40000020 <read>
40008010:	fff00793          	li	a5,-1
40008014:	00f50c63          	beq	a0,a5,4000802c <_read_r+0x4c>
40008018:	00c12083          	lw	ra,12(sp)
4000801c:	00812403          	lw	s0,8(sp)
40008020:	00412483          	lw	s1,4(sp)
40008024:	01010113          	addi	sp,sp,16
40008028:	00008067          	ret
4000802c:	68442783          	lw	a5,1668(s0)
40008030:	fe0784e3          	beqz	a5,40008018 <_read_r+0x38>
40008034:	00c12083          	lw	ra,12(sp)
40008038:	00f4a023          	sw	a5,0(s1)
4000803c:	00812403          	lw	s0,8(sp)
40008040:	00412483          	lw	s1,4(sp)
40008044:	01010113          	addi	sp,sp,16
40008048:	00008067          	ret

4000804c <_realloc_r>:
4000804c:	1e058c63          	beqz	a1,40008244 <_realloc_r+0x1f8>
40008050:	fd010113          	addi	sp,sp,-48
40008054:	02812423          	sw	s0,40(sp)
40008058:	02912223          	sw	s1,36(sp)
4000805c:	00058413          	mv	s0,a1
40008060:	03212023          	sw	s2,32(sp)
40008064:	01312e23          	sw	s3,28(sp)
40008068:	01412c23          	sw	s4,24(sp)
4000806c:	01512a23          	sw	s5,20(sp)
40008070:	00060493          	mv	s1,a2
40008074:	02112623          	sw	ra,44(sp)
40008078:	01612823          	sw	s6,16(sp)
4000807c:	01712623          	sw	s7,12(sp)
40008080:	01812423          	sw	s8,8(sp)
40008084:	00050a13          	mv	s4,a0
40008088:	f31fc0ef          	jal	ra,40004fb8 <__malloc_lock>
4000808c:	ffc42783          	lw	a5,-4(s0)
40008090:	00b48993          	addi	s3,s1,11
40008094:	01600713          	li	a4,22
40008098:	ff840a93          	addi	s5,s0,-8
4000809c:	ffc7f913          	andi	s2,a5,-4
400080a0:	0b377c63          	bleu	s3,a4,40008158 <_realloc_r+0x10c>
400080a4:	ff89f993          	andi	s3,s3,-8
400080a8:	00098713          	mv	a4,s3
400080ac:	1409c663          	bltz	s3,400081f8 <_realloc_r+0x1ac>
400080b0:	1499e463          	bltu	s3,s1,400081f8 <_realloc_r+0x1ac>
400080b4:	0ae95863          	ble	a4,s2,40008164 <_realloc_r+0x118>
400080b8:	4000cb37          	lui	s6,0x4000c
400080bc:	220b0b13          	addi	s6,s6,544 # 4000c220 <__malloc_av_>
400080c0:	008b2603          	lw	a2,8(s6)
400080c4:	012a86b3          	add	a3,s5,s2
400080c8:	2cc68263          	beq	a3,a2,4000838c <_realloc_r+0x340>
400080cc:	0046a603          	lw	a2,4(a3)
400080d0:	ffe67593          	andi	a1,a2,-2
400080d4:	00b685b3          	add	a1,a3,a1
400080d8:	0045a583          	lw	a1,4(a1)
400080dc:	0015f593          	andi	a1,a1,1
400080e0:	0e058863          	beqz	a1,400081d0 <_realloc_r+0x184>
400080e4:	0017f793          	andi	a5,a5,1
400080e8:	20078663          	beqz	a5,400082f4 <_realloc_r+0x2a8>
400080ec:	00048593          	mv	a1,s1
400080f0:	000a0513          	mv	a0,s4
400080f4:	ca4fc0ef          	jal	ra,40004598 <_malloc_r>
400080f8:	00050493          	mv	s1,a0
400080fc:	08050c63          	beqz	a0,40008194 <_realloc_r+0x148>
40008100:	ffc42783          	lw	a5,-4(s0)
40008104:	ff850713          	addi	a4,a0,-8
40008108:	ffe7f793          	andi	a5,a5,-2
4000810c:	00fa87b3          	add	a5,s5,a5
40008110:	3ef70463          	beq	a4,a5,400084f8 <_realloc_r+0x4ac>
40008114:	ffc90613          	addi	a2,s2,-4
40008118:	02400793          	li	a5,36
4000811c:	38c7ec63          	bltu	a5,a2,400084b4 <_realloc_r+0x468>
40008120:	01300713          	li	a4,19
40008124:	32c76663          	bltu	a4,a2,40008450 <_realloc_r+0x404>
40008128:	00050793          	mv	a5,a0
4000812c:	00040713          	mv	a4,s0
40008130:	00072683          	lw	a3,0(a4)
40008134:	00d7a023          	sw	a3,0(a5)
40008138:	00472683          	lw	a3,4(a4)
4000813c:	00d7a223          	sw	a3,4(a5)
40008140:	00872703          	lw	a4,8(a4)
40008144:	00e7a423          	sw	a4,8(a5)
40008148:	00040593          	mv	a1,s0
4000814c:	000a0513          	mv	a0,s4
40008150:	d35fb0ef          	jal	ra,40003e84 <_free_r>
40008154:	0400006f          	j	40008194 <_realloc_r+0x148>
40008158:	01000713          	li	a4,16
4000815c:	00070993          	mv	s3,a4
40008160:	f51ff06f          	j	400080b0 <_realloc_r+0x64>
40008164:	00040493          	mv	s1,s0
40008168:	413907b3          	sub	a5,s2,s3
4000816c:	00f00713          	li	a4,15
40008170:	08f76c63          	bltu	a4,a5,40008208 <_realloc_r+0x1bc>
40008174:	004aa603          	lw	a2,4(s5)
40008178:	012a8733          	add	a4,s5,s2
4000817c:	00167613          	andi	a2,a2,1
40008180:	01266933          	or	s2,a2,s2
40008184:	012aa223          	sw	s2,4(s5)
40008188:	00472783          	lw	a5,4(a4)
4000818c:	0017e793          	ori	a5,a5,1
40008190:	00f72223          	sw	a5,4(a4)
40008194:	000a0513          	mv	a0,s4
40008198:	e25fc0ef          	jal	ra,40004fbc <__malloc_unlock>
4000819c:	02c12083          	lw	ra,44(sp)
400081a0:	00048513          	mv	a0,s1
400081a4:	02812403          	lw	s0,40(sp)
400081a8:	02412483          	lw	s1,36(sp)
400081ac:	02012903          	lw	s2,32(sp)
400081b0:	01c12983          	lw	s3,28(sp)
400081b4:	01812a03          	lw	s4,24(sp)
400081b8:	01412a83          	lw	s5,20(sp)
400081bc:	01012b03          	lw	s6,16(sp)
400081c0:	00c12b83          	lw	s7,12(sp)
400081c4:	00812c03          	lw	s8,8(sp)
400081c8:	03010113          	addi	sp,sp,48
400081cc:	00008067          	ret
400081d0:	ffc67613          	andi	a2,a2,-4
400081d4:	00c905b3          	add	a1,s2,a2
400081d8:	06e5ca63          	blt	a1,a4,4000824c <_realloc_r+0x200>
400081dc:	00c6a783          	lw	a5,12(a3)
400081e0:	0086a703          	lw	a4,8(a3)
400081e4:	00040493          	mv	s1,s0
400081e8:	00058913          	mv	s2,a1
400081ec:	00f72623          	sw	a5,12(a4)
400081f0:	00e7a423          	sw	a4,8(a5)
400081f4:	f75ff06f          	j	40008168 <_realloc_r+0x11c>
400081f8:	00c00793          	li	a5,12
400081fc:	00fa2023          	sw	a5,0(s4)
40008200:	00000493          	li	s1,0
40008204:	f99ff06f          	j	4000819c <_realloc_r+0x150>
40008208:	004aa703          	lw	a4,4(s5)
4000820c:	013a85b3          	add	a1,s5,s3
40008210:	0017e793          	ori	a5,a5,1
40008214:	00177713          	andi	a4,a4,1
40008218:	013769b3          	or	s3,a4,s3
4000821c:	013aa223          	sw	s3,4(s5)
40008220:	00f5a223          	sw	a5,4(a1)
40008224:	012a8933          	add	s2,s5,s2
40008228:	00492783          	lw	a5,4(s2)
4000822c:	00858593          	addi	a1,a1,8
40008230:	000a0513          	mv	a0,s4
40008234:	0017e793          	ori	a5,a5,1
40008238:	00f92223          	sw	a5,4(s2)
4000823c:	c49fb0ef          	jal	ra,40003e84 <_free_r>
40008240:	f55ff06f          	j	40008194 <_realloc_r+0x148>
40008244:	00060593          	mv	a1,a2
40008248:	b50fc06f          	j	40004598 <_malloc_r>
4000824c:	0017f793          	andi	a5,a5,1
40008250:	e8079ee3          	bnez	a5,400080ec <_realloc_r+0xa0>
40008254:	ff842b83          	lw	s7,-8(s0)
40008258:	417a8bb3          	sub	s7,s5,s7
4000825c:	004ba783          	lw	a5,4(s7) # 80000004 <_bss_end+0x3fff397c>
40008260:	ffc7f793          	andi	a5,a5,-4
40008264:	00f60633          	add	a2,a2,a5
40008268:	01260b33          	add	s6,a2,s2
4000826c:	08eb4c63          	blt	s6,a4,40008304 <_realloc_r+0x2b8>
40008270:	00c6a783          	lw	a5,12(a3)
40008274:	0086a703          	lw	a4,8(a3)
40008278:	ffc90613          	addi	a2,s2,-4
4000827c:	02400693          	li	a3,36
40008280:	00f72623          	sw	a5,12(a4)
40008284:	00e7a423          	sw	a4,8(a5)
40008288:	008ba703          	lw	a4,8(s7)
4000828c:	00cba783          	lw	a5,12(s7)
40008290:	008b8493          	addi	s1,s7,8
40008294:	00f72623          	sw	a5,12(a4)
40008298:	00e7a423          	sw	a4,8(a5)
4000829c:	22c6e263          	bltu	a3,a2,400084c0 <_realloc_r+0x474>
400082a0:	01300793          	li	a5,19
400082a4:	1cc7f863          	bleu	a2,a5,40008474 <_realloc_r+0x428>
400082a8:	00042703          	lw	a4,0(s0)
400082ac:	01b00793          	li	a5,27
400082b0:	00eba423          	sw	a4,8(s7)
400082b4:	00442703          	lw	a4,4(s0)
400082b8:	00eba623          	sw	a4,12(s7)
400082bc:	24c7f863          	bleu	a2,a5,4000850c <_realloc_r+0x4c0>
400082c0:	00842703          	lw	a4,8(s0)
400082c4:	02400793          	li	a5,36
400082c8:	00eba823          	sw	a4,16(s7)
400082cc:	00c42703          	lw	a4,12(s0)
400082d0:	00ebaa23          	sw	a4,20(s7)
400082d4:	08f61663          	bne	a2,a5,40008360 <_realloc_r+0x314>
400082d8:	01042683          	lw	a3,16(s0)
400082dc:	020b8793          	addi	a5,s7,32
400082e0:	01840713          	addi	a4,s0,24
400082e4:	00dbac23          	sw	a3,24(s7)
400082e8:	01442683          	lw	a3,20(s0)
400082ec:	00dbae23          	sw	a3,28(s7)
400082f0:	0780006f          	j	40008368 <_realloc_r+0x31c>
400082f4:	ff842b83          	lw	s7,-8(s0)
400082f8:	417a8bb3          	sub	s7,s5,s7
400082fc:	004ba783          	lw	a5,4(s7)
40008300:	ffc7f793          	andi	a5,a5,-4
40008304:	00f90b33          	add	s6,s2,a5
40008308:	deeb42e3          	blt	s6,a4,400080ec <_realloc_r+0xa0>
4000830c:	00cba783          	lw	a5,12(s7)
40008310:	008ba703          	lw	a4,8(s7)
40008314:	ffc90613          	addi	a2,s2,-4
40008318:	02400693          	li	a3,36
4000831c:	00f72623          	sw	a5,12(a4)
40008320:	00e7a423          	sw	a4,8(a5)
40008324:	008b8493          	addi	s1,s7,8
40008328:	18c6ec63          	bltu	a3,a2,400084c0 <_realloc_r+0x474>
4000832c:	01300793          	li	a5,19
40008330:	14c7f263          	bleu	a2,a5,40008474 <_realloc_r+0x428>
40008334:	00042703          	lw	a4,0(s0)
40008338:	01b00793          	li	a5,27
4000833c:	00eba423          	sw	a4,8(s7)
40008340:	00442703          	lw	a4,4(s0)
40008344:	00eba623          	sw	a4,12(s7)
40008348:	1cc7f263          	bleu	a2,a5,4000850c <_realloc_r+0x4c0>
4000834c:	00842783          	lw	a5,8(s0)
40008350:	00fba823          	sw	a5,16(s7)
40008354:	00c42783          	lw	a5,12(s0)
40008358:	00fbaa23          	sw	a5,20(s7)
4000835c:	f6d60ee3          	beq	a2,a3,400082d8 <_realloc_r+0x28c>
40008360:	018b8793          	addi	a5,s7,24
40008364:	01040713          	addi	a4,s0,16
40008368:	00072683          	lw	a3,0(a4)
4000836c:	000b0913          	mv	s2,s6
40008370:	000b8a93          	mv	s5,s7
40008374:	00d7a023          	sw	a3,0(a5)
40008378:	00472683          	lw	a3,4(a4)
4000837c:	00d7a223          	sw	a3,4(a5)
40008380:	00872703          	lw	a4,8(a4)
40008384:	00e7a423          	sw	a4,8(a5)
40008388:	de1ff06f          	j	40008168 <_realloc_r+0x11c>
4000838c:	0046a683          	lw	a3,4(a3)
40008390:	01098613          	addi	a2,s3,16
40008394:	ffc6f693          	andi	a3,a3,-4
40008398:	012686b3          	add	a3,a3,s2
4000839c:	0ec6d263          	ble	a2,a3,40008480 <_realloc_r+0x434>
400083a0:	0017f793          	andi	a5,a5,1
400083a4:	d40794e3          	bnez	a5,400080ec <_realloc_r+0xa0>
400083a8:	ff842b83          	lw	s7,-8(s0)
400083ac:	417a8bb3          	sub	s7,s5,s7
400083b0:	004ba783          	lw	a5,4(s7)
400083b4:	ffc7f793          	andi	a5,a5,-4
400083b8:	00d78c33          	add	s8,a5,a3
400083bc:	f4cc44e3          	blt	s8,a2,40008304 <_realloc_r+0x2b8>
400083c0:	00cba783          	lw	a5,12(s7)
400083c4:	008ba703          	lw	a4,8(s7)
400083c8:	ffc90613          	addi	a2,s2,-4
400083cc:	02400693          	li	a3,36
400083d0:	00f72623          	sw	a5,12(a4)
400083d4:	00e7a423          	sw	a4,8(a5)
400083d8:	008b8493          	addi	s1,s7,8
400083dc:	16c6e263          	bltu	a3,a2,40008540 <_realloc_r+0x4f4>
400083e0:	01300793          	li	a5,19
400083e4:	14c7f863          	bleu	a2,a5,40008534 <_realloc_r+0x4e8>
400083e8:	00042703          	lw	a4,0(s0)
400083ec:	01b00793          	li	a5,27
400083f0:	00eba423          	sw	a4,8(s7)
400083f4:	00442703          	lw	a4,4(s0)
400083f8:	00eba623          	sw	a4,12(s7)
400083fc:	14c7ea63          	bltu	a5,a2,40008550 <_realloc_r+0x504>
40008400:	010b8793          	addi	a5,s7,16
40008404:	00840713          	addi	a4,s0,8
40008408:	00072683          	lw	a3,0(a4)
4000840c:	00d7a023          	sw	a3,0(a5)
40008410:	00472683          	lw	a3,4(a4)
40008414:	00d7a223          	sw	a3,4(a5)
40008418:	00872703          	lw	a4,8(a4)
4000841c:	00e7a423          	sw	a4,8(a5)
40008420:	013b8733          	add	a4,s7,s3
40008424:	413c07b3          	sub	a5,s8,s3
40008428:	00eb2423          	sw	a4,8(s6)
4000842c:	0017e793          	ori	a5,a5,1
40008430:	00f72223          	sw	a5,4(a4)
40008434:	004ba783          	lw	a5,4(s7)
40008438:	000a0513          	mv	a0,s4
4000843c:	0017f793          	andi	a5,a5,1
40008440:	0137e9b3          	or	s3,a5,s3
40008444:	013ba223          	sw	s3,4(s7)
40008448:	b75fc0ef          	jal	ra,40004fbc <__malloc_unlock>
4000844c:	d51ff06f          	j	4000819c <_realloc_r+0x150>
40008450:	00042683          	lw	a3,0(s0)
40008454:	01b00713          	li	a4,27
40008458:	00d52023          	sw	a3,0(a0)
4000845c:	00442683          	lw	a3,4(s0)
40008460:	00d52223          	sw	a3,4(a0)
40008464:	06c76a63          	bltu	a4,a2,400084d8 <_realloc_r+0x48c>
40008468:	00850793          	addi	a5,a0,8
4000846c:	00840713          	addi	a4,s0,8
40008470:	cc1ff06f          	j	40008130 <_realloc_r+0xe4>
40008474:	00048793          	mv	a5,s1
40008478:	00040713          	mv	a4,s0
4000847c:	eedff06f          	j	40008368 <_realloc_r+0x31c>
40008480:	013a8ab3          	add	s5,s5,s3
40008484:	413687b3          	sub	a5,a3,s3
40008488:	015b2423          	sw	s5,8(s6)
4000848c:	0017e793          	ori	a5,a5,1
40008490:	00faa223          	sw	a5,4(s5)
40008494:	ffc42783          	lw	a5,-4(s0)
40008498:	000a0513          	mv	a0,s4
4000849c:	00040493          	mv	s1,s0
400084a0:	0017f793          	andi	a5,a5,1
400084a4:	0137e9b3          	or	s3,a5,s3
400084a8:	ff342e23          	sw	s3,-4(s0)
400084ac:	b11fc0ef          	jal	ra,40004fbc <__malloc_unlock>
400084b0:	cedff06f          	j	4000819c <_realloc_r+0x150>
400084b4:	00040593          	mv	a1,s0
400084b8:	a0dff0ef          	jal	ra,40007ec4 <memmove>
400084bc:	c8dff06f          	j	40008148 <_realloc_r+0xfc>
400084c0:	00040593          	mv	a1,s0
400084c4:	00048513          	mv	a0,s1
400084c8:	9fdff0ef          	jal	ra,40007ec4 <memmove>
400084cc:	000b0913          	mv	s2,s6
400084d0:	000b8a93          	mv	s5,s7
400084d4:	c95ff06f          	j	40008168 <_realloc_r+0x11c>
400084d8:	00842703          	lw	a4,8(s0)
400084dc:	00e52423          	sw	a4,8(a0)
400084e0:	00c42703          	lw	a4,12(s0)
400084e4:	00e52623          	sw	a4,12(a0)
400084e8:	02f60863          	beq	a2,a5,40008518 <_realloc_r+0x4cc>
400084ec:	01050793          	addi	a5,a0,16
400084f0:	01040713          	addi	a4,s0,16
400084f4:	c3dff06f          	j	40008130 <_realloc_r+0xe4>
400084f8:	ffc52783          	lw	a5,-4(a0)
400084fc:	00040493          	mv	s1,s0
40008500:	ffc7f793          	andi	a5,a5,-4
40008504:	00f90933          	add	s2,s2,a5
40008508:	c61ff06f          	j	40008168 <_realloc_r+0x11c>
4000850c:	010b8793          	addi	a5,s7,16
40008510:	00840713          	addi	a4,s0,8
40008514:	e55ff06f          	j	40008368 <_realloc_r+0x31c>
40008518:	01042683          	lw	a3,16(s0)
4000851c:	01850793          	addi	a5,a0,24
40008520:	01840713          	addi	a4,s0,24
40008524:	00d52823          	sw	a3,16(a0)
40008528:	01442683          	lw	a3,20(s0)
4000852c:	00d52a23          	sw	a3,20(a0)
40008530:	c01ff06f          	j	40008130 <_realloc_r+0xe4>
40008534:	00048793          	mv	a5,s1
40008538:	00040713          	mv	a4,s0
4000853c:	ecdff06f          	j	40008408 <_realloc_r+0x3bc>
40008540:	00040593          	mv	a1,s0
40008544:	00048513          	mv	a0,s1
40008548:	97dff0ef          	jal	ra,40007ec4 <memmove>
4000854c:	ed5ff06f          	j	40008420 <_realloc_r+0x3d4>
40008550:	00842783          	lw	a5,8(s0)
40008554:	00fba823          	sw	a5,16(s7)
40008558:	00c42783          	lw	a5,12(s0)
4000855c:	00fbaa23          	sw	a5,20(s7)
40008560:	00d60863          	beq	a2,a3,40008570 <_realloc_r+0x524>
40008564:	018b8793          	addi	a5,s7,24
40008568:	01040713          	addi	a4,s0,16
4000856c:	e9dff06f          	j	40008408 <_realloc_r+0x3bc>
40008570:	01042683          	lw	a3,16(s0)
40008574:	020b8793          	addi	a5,s7,32
40008578:	01840713          	addi	a4,s0,24
4000857c:	00dbac23          	sw	a3,24(s7)
40008580:	01442683          	lw	a3,20(s0)
40008584:	00dbae23          	sw	a3,28(s7)
40008588:	e81ff06f          	j	40008408 <_realloc_r+0x3bc>

4000858c <cleanup_glue>:
4000858c:	ff010113          	addi	sp,sp,-16
40008590:	00812423          	sw	s0,8(sp)
40008594:	00058413          	mv	s0,a1
40008598:	0005a583          	lw	a1,0(a1)
4000859c:	00912223          	sw	s1,4(sp)
400085a0:	00112623          	sw	ra,12(sp)
400085a4:	00050493          	mv	s1,a0
400085a8:	00058463          	beqz	a1,400085b0 <cleanup_glue+0x24>
400085ac:	fe1ff0ef          	jal	ra,4000858c <cleanup_glue>
400085b0:	00040593          	mv	a1,s0
400085b4:	00048513          	mv	a0,s1
400085b8:	00c12083          	lw	ra,12(sp)
400085bc:	00812403          	lw	s0,8(sp)
400085c0:	00412483          	lw	s1,4(sp)
400085c4:	01010113          	addi	sp,sp,16
400085c8:	8bdfb06f          	j	40003e84 <_free_r>

400085cc <_reclaim_reent>:
400085cc:	4000c7b7          	lui	a5,0x4000c
400085d0:	62c7a783          	lw	a5,1580(a5) # 4000c62c <_impure_ptr>
400085d4:	0ca78663          	beq	a5,a0,400086a0 <_reclaim_reent+0xd4>
400085d8:	04c52703          	lw	a4,76(a0)
400085dc:	fe010113          	addi	sp,sp,-32
400085e0:	00912a23          	sw	s1,20(sp)
400085e4:	00112e23          	sw	ra,28(sp)
400085e8:	00812c23          	sw	s0,24(sp)
400085ec:	01212823          	sw	s2,16(sp)
400085f0:	01312623          	sw	s3,12(sp)
400085f4:	00050493          	mv	s1,a0
400085f8:	04070263          	beqz	a4,4000863c <_reclaim_reent+0x70>
400085fc:	00000913          	li	s2,0
40008600:	08000993          	li	s3,128
40008604:	012707b3          	add	a5,a4,s2
40008608:	0007a583          	lw	a1,0(a5)
4000860c:	00058e63          	beqz	a1,40008628 <_reclaim_reent+0x5c>
40008610:	0005a403          	lw	s0,0(a1)
40008614:	00048513          	mv	a0,s1
40008618:	86dfb0ef          	jal	ra,40003e84 <_free_r>
4000861c:	00040593          	mv	a1,s0
40008620:	fe0418e3          	bnez	s0,40008610 <_reclaim_reent+0x44>
40008624:	04c4a703          	lw	a4,76(s1)
40008628:	00490913          	addi	s2,s2,4
4000862c:	fd391ce3          	bne	s2,s3,40008604 <_reclaim_reent+0x38>
40008630:	00070593          	mv	a1,a4
40008634:	00048513          	mv	a0,s1
40008638:	84dfb0ef          	jal	ra,40003e84 <_free_r>
4000863c:	0404a583          	lw	a1,64(s1)
40008640:	00058663          	beqz	a1,4000864c <_reclaim_reent+0x80>
40008644:	00048513          	mv	a0,s1
40008648:	83dfb0ef          	jal	ra,40003e84 <_free_r>
4000864c:	1484a583          	lw	a1,328(s1)
40008650:	02058063          	beqz	a1,40008670 <_reclaim_reent+0xa4>
40008654:	14c48913          	addi	s2,s1,332
40008658:	01258c63          	beq	a1,s2,40008670 <_reclaim_reent+0xa4>
4000865c:	0005a403          	lw	s0,0(a1)
40008660:	00048513          	mv	a0,s1
40008664:	821fb0ef          	jal	ra,40003e84 <_free_r>
40008668:	00040593          	mv	a1,s0
4000866c:	fe8918e3          	bne	s2,s0,4000865c <_reclaim_reent+0x90>
40008670:	0544a583          	lw	a1,84(s1)
40008674:	00058663          	beqz	a1,40008680 <_reclaim_reent+0xb4>
40008678:	00048513          	mv	a0,s1
4000867c:	809fb0ef          	jal	ra,40003e84 <_free_r>
40008680:	0384a783          	lw	a5,56(s1)
40008684:	02079063          	bnez	a5,400086a4 <_reclaim_reent+0xd8>
40008688:	01c12083          	lw	ra,28(sp)
4000868c:	01812403          	lw	s0,24(sp)
40008690:	01412483          	lw	s1,20(sp)
40008694:	01012903          	lw	s2,16(sp)
40008698:	00c12983          	lw	s3,12(sp)
4000869c:	02010113          	addi	sp,sp,32
400086a0:	00008067          	ret
400086a4:	03c4a783          	lw	a5,60(s1)
400086a8:	00048513          	mv	a0,s1
400086ac:	000780e7          	jalr	a5
400086b0:	2e04a583          	lw	a1,736(s1)
400086b4:	fc058ae3          	beqz	a1,40008688 <_reclaim_reent+0xbc>
400086b8:	00048513          	mv	a0,s1
400086bc:	01c12083          	lw	ra,28(sp)
400086c0:	01812403          	lw	s0,24(sp)
400086c4:	01412483          	lw	s1,20(sp)
400086c8:	01012903          	lw	s2,16(sp)
400086cc:	00c12983          	lw	s3,12(sp)
400086d0:	02010113          	addi	sp,sp,32
400086d4:	eb9ff06f          	j	4000858c <cleanup_glue>

400086d8 <__swbuf_r>:
400086d8:	fe010113          	addi	sp,sp,-32
400086dc:	00812c23          	sw	s0,24(sp)
400086e0:	00912a23          	sw	s1,20(sp)
400086e4:	01212823          	sw	s2,16(sp)
400086e8:	00112e23          	sw	ra,28(sp)
400086ec:	01312623          	sw	s3,12(sp)
400086f0:	00050913          	mv	s2,a0
400086f4:	00058493          	mv	s1,a1
400086f8:	00060413          	mv	s0,a2
400086fc:	00050663          	beqz	a0,40008708 <__swbuf_r+0x30>
40008700:	03852783          	lw	a5,56(a0)
40008704:	14078263          	beqz	a5,40008848 <__swbuf_r+0x170>
40008708:	00c41703          	lh	a4,12(s0)
4000870c:	01842783          	lw	a5,24(s0)
40008710:	01071693          	slli	a3,a4,0x10
40008714:	0106d693          	srli	a3,a3,0x10
40008718:	00f42423          	sw	a5,8(s0)
4000871c:	0086f793          	andi	a5,a3,8
40008720:	10078263          	beqz	a5,40008824 <__swbuf_r+0x14c>
40008724:	01042783          	lw	a5,16(s0)
40008728:	0e078e63          	beqz	a5,40008824 <__swbuf_r+0x14c>
4000872c:	01269613          	slli	a2,a3,0x12
40008730:	0ff4f993          	andi	s3,s1,255
40008734:	0ff4f493          	andi	s1,s1,255
40008738:	06065663          	bgez	a2,400087a4 <__swbuf_r+0xcc>
4000873c:	00042703          	lw	a4,0(s0)
40008740:	01442683          	lw	a3,20(s0)
40008744:	40f707b3          	sub	a5,a4,a5
40008748:	08d7d663          	ble	a3,a5,400087d4 <__swbuf_r+0xfc>
4000874c:	00842683          	lw	a3,8(s0)
40008750:	00170613          	addi	a2,a4,1
40008754:	00c42023          	sw	a2,0(s0)
40008758:	fff68693          	addi	a3,a3,-1
4000875c:	00d42423          	sw	a3,8(s0)
40008760:	01370023          	sb	s3,0(a4)
40008764:	01442703          	lw	a4,20(s0)
40008768:	00178793          	addi	a5,a5,1
4000876c:	0af70063          	beq	a4,a5,4000880c <__swbuf_r+0x134>
40008770:	00c45783          	lhu	a5,12(s0)
40008774:	0017f793          	andi	a5,a5,1
40008778:	00078663          	beqz	a5,40008784 <__swbuf_r+0xac>
4000877c:	00a00793          	li	a5,10
40008780:	08f48663          	beq	s1,a5,4000880c <__swbuf_r+0x134>
40008784:	01c12083          	lw	ra,28(sp)
40008788:	00048513          	mv	a0,s1
4000878c:	01812403          	lw	s0,24(sp)
40008790:	01412483          	lw	s1,20(sp)
40008794:	01012903          	lw	s2,16(sp)
40008798:	00c12983          	lw	s3,12(sp)
4000879c:	02010113          	addi	sp,sp,32
400087a0:	00008067          	ret
400087a4:	06442683          	lw	a3,100(s0)
400087a8:	00002637          	lui	a2,0x2
400087ac:	00c76733          	or	a4,a4,a2
400087b0:	ffffe637          	lui	a2,0xffffe
400087b4:	fff60613          	addi	a2,a2,-1 # ffffdfff <_bss_end+0xbfff1977>
400087b8:	00c6f6b3          	and	a3,a3,a2
400087bc:	00e41623          	sh	a4,12(s0)
400087c0:	00042703          	lw	a4,0(s0)
400087c4:	06d42223          	sw	a3,100(s0)
400087c8:	01442683          	lw	a3,20(s0)
400087cc:	40f707b3          	sub	a5,a4,a5
400087d0:	f6d7cee3          	blt	a5,a3,4000874c <__swbuf_r+0x74>
400087d4:	00040593          	mv	a1,s0
400087d8:	00090513          	mv	a0,s2
400087dc:	960fb0ef          	jal	ra,4000393c <_fflush_r>
400087e0:	02051e63          	bnez	a0,4000881c <__swbuf_r+0x144>
400087e4:	00042703          	lw	a4,0(s0)
400087e8:	00842683          	lw	a3,8(s0)
400087ec:	00100793          	li	a5,1
400087f0:	00170613          	addi	a2,a4,1
400087f4:	fff68693          	addi	a3,a3,-1
400087f8:	00c42023          	sw	a2,0(s0)
400087fc:	00d42423          	sw	a3,8(s0)
40008800:	01370023          	sb	s3,0(a4)
40008804:	01442703          	lw	a4,20(s0)
40008808:	f6f714e3          	bne	a4,a5,40008770 <__swbuf_r+0x98>
4000880c:	00040593          	mv	a1,s0
40008810:	00090513          	mv	a0,s2
40008814:	928fb0ef          	jal	ra,4000393c <_fflush_r>
40008818:	f60506e3          	beqz	a0,40008784 <__swbuf_r+0xac>
4000881c:	fff00493          	li	s1,-1
40008820:	f65ff06f          	j	40008784 <__swbuf_r+0xac>
40008824:	00040593          	mv	a1,s0
40008828:	00090513          	mv	a0,s2
4000882c:	dd4f90ef          	jal	ra,40001e00 <__swsetup_r>
40008830:	fe0516e3          	bnez	a0,4000881c <__swbuf_r+0x144>
40008834:	00c41703          	lh	a4,12(s0)
40008838:	01042783          	lw	a5,16(s0)
4000883c:	01071693          	slli	a3,a4,0x10
40008840:	0106d693          	srli	a3,a3,0x10
40008844:	ee9ff06f          	j	4000872c <__swbuf_r+0x54>
40008848:	cb8fb0ef          	jal	ra,40003d00 <__sinit>
4000884c:	ebdff06f          	j	40008708 <__swbuf_r+0x30>

40008850 <__swbuf>:
40008850:	4000c7b7          	lui	a5,0x4000c
40008854:	00058613          	mv	a2,a1
40008858:	00050593          	mv	a1,a0
4000885c:	62c7a503          	lw	a0,1580(a5) # 4000c62c <_impure_ptr>
40008860:	e79ff06f          	j	400086d8 <__swbuf_r>

40008864 <_wcrtomb_r>:
40008864:	fd010113          	addi	sp,sp,-48
40008868:	02912223          	sw	s1,36(sp)
4000886c:	03212023          	sw	s2,32(sp)
40008870:	02112623          	sw	ra,44(sp)
40008874:	02812423          	sw	s0,40(sp)
40008878:	01312e23          	sw	s3,28(sp)
4000887c:	01412c23          	sw	s4,24(sp)
40008880:	00050493          	mv	s1,a0
40008884:	00068913          	mv	s2,a3
40008888:	06058263          	beqz	a1,400088ec <_wcrtomb_r+0x88>
4000888c:	4000c7b7          	lui	a5,0x4000c
40008890:	63c7aa03          	lw	s4,1596(a5) # 4000c63c <__wctomb>
40008894:	00058413          	mv	s0,a1
40008898:	00060993          	mv	s3,a2
4000889c:	acdfb0ef          	jal	ra,40004368 <__locale_charset>
400088a0:	00050693          	mv	a3,a0
400088a4:	00090713          	mv	a4,s2
400088a8:	00098613          	mv	a2,s3
400088ac:	00040593          	mv	a1,s0
400088b0:	00048513          	mv	a0,s1
400088b4:	000a00e7          	jalr	s4
400088b8:	fff00793          	li	a5,-1
400088bc:	00f51863          	bne	a0,a5,400088cc <_wcrtomb_r+0x68>
400088c0:	00092023          	sw	zero,0(s2)
400088c4:	08a00793          	li	a5,138
400088c8:	00f4a023          	sw	a5,0(s1)
400088cc:	02c12083          	lw	ra,44(sp)
400088d0:	02812403          	lw	s0,40(sp)
400088d4:	02412483          	lw	s1,36(sp)
400088d8:	02012903          	lw	s2,32(sp)
400088dc:	01c12983          	lw	s3,28(sp)
400088e0:	01812a03          	lw	s4,24(sp)
400088e4:	03010113          	addi	sp,sp,48
400088e8:	00008067          	ret
400088ec:	4000c7b7          	lui	a5,0x4000c
400088f0:	63c7a403          	lw	s0,1596(a5) # 4000c63c <__wctomb>
400088f4:	a75fb0ef          	jal	ra,40004368 <__locale_charset>
400088f8:	00050693          	mv	a3,a0
400088fc:	00090713          	mv	a4,s2
40008900:	00000613          	li	a2,0
40008904:	00410593          	addi	a1,sp,4
40008908:	00048513          	mv	a0,s1
4000890c:	000400e7          	jalr	s0
40008910:	fa9ff06f          	j	400088b8 <_wcrtomb_r+0x54>

40008914 <wcrtomb>:
40008914:	fd010113          	addi	sp,sp,-48
40008918:	02912223          	sw	s1,36(sp)
4000891c:	03212023          	sw	s2,32(sp)
40008920:	4000c7b7          	lui	a5,0x4000c
40008924:	02112623          	sw	ra,44(sp)
40008928:	02812423          	sw	s0,40(sp)
4000892c:	01312e23          	sw	s3,28(sp)
40008930:	01412c23          	sw	s4,24(sp)
40008934:	00060913          	mv	s2,a2
40008938:	62c7a483          	lw	s1,1580(a5) # 4000c62c <_impure_ptr>
4000893c:	06050263          	beqz	a0,400089a0 <wcrtomb+0x8c>
40008940:	4000c7b7          	lui	a5,0x4000c
40008944:	63c7aa03          	lw	s4,1596(a5) # 4000c63c <__wctomb>
40008948:	00058993          	mv	s3,a1
4000894c:	00050413          	mv	s0,a0
40008950:	a19fb0ef          	jal	ra,40004368 <__locale_charset>
40008954:	00050693          	mv	a3,a0
40008958:	00090713          	mv	a4,s2
4000895c:	00098613          	mv	a2,s3
40008960:	00040593          	mv	a1,s0
40008964:	00048513          	mv	a0,s1
40008968:	000a00e7          	jalr	s4
4000896c:	fff00793          	li	a5,-1
40008970:	00f51863          	bne	a0,a5,40008980 <wcrtomb+0x6c>
40008974:	00092023          	sw	zero,0(s2)
40008978:	08a00793          	li	a5,138
4000897c:	00f4a023          	sw	a5,0(s1)
40008980:	02c12083          	lw	ra,44(sp)
40008984:	02812403          	lw	s0,40(sp)
40008988:	02412483          	lw	s1,36(sp)
4000898c:	02012903          	lw	s2,32(sp)
40008990:	01c12983          	lw	s3,28(sp)
40008994:	01812a03          	lw	s4,24(sp)
40008998:	03010113          	addi	sp,sp,48
4000899c:	00008067          	ret
400089a0:	4000c7b7          	lui	a5,0x4000c
400089a4:	63c7a403          	lw	s0,1596(a5) # 4000c63c <__wctomb>
400089a8:	9c1fb0ef          	jal	ra,40004368 <__locale_charset>
400089ac:	00050693          	mv	a3,a0
400089b0:	00090713          	mv	a4,s2
400089b4:	00000613          	li	a2,0
400089b8:	00410593          	addi	a1,sp,4
400089bc:	00048513          	mv	a0,s1
400089c0:	000400e7          	jalr	s0
400089c4:	fa9ff06f          	j	4000896c <wcrtomb+0x58>

400089c8 <__ascii_wctomb>:
400089c8:	00058c63          	beqz	a1,400089e0 <__ascii_wctomb+0x18>
400089cc:	0ff00793          	li	a5,255
400089d0:	00c7ec63          	bltu	a5,a2,400089e8 <__ascii_wctomb+0x20>
400089d4:	00c58023          	sb	a2,0(a1)
400089d8:	00100513          	li	a0,1
400089dc:	00008067          	ret
400089e0:	00000513          	li	a0,0
400089e4:	00008067          	ret
400089e8:	08a00793          	li	a5,138
400089ec:	00f52023          	sw	a5,0(a0)
400089f0:	fff00513          	li	a0,-1
400089f4:	00008067          	ret

400089f8 <_wctomb_r>:
400089f8:	fe010113          	addi	sp,sp,-32
400089fc:	4000c7b7          	lui	a5,0x4000c
40008a00:	00812c23          	sw	s0,24(sp)
40008a04:	63c7a403          	lw	s0,1596(a5) # 4000c63c <__wctomb>
40008a08:	00112e23          	sw	ra,28(sp)
40008a0c:	00912a23          	sw	s1,20(sp)
40008a10:	01212823          	sw	s2,16(sp)
40008a14:	01312623          	sw	s3,12(sp)
40008a18:	01412423          	sw	s4,8(sp)
40008a1c:	00050493          	mv	s1,a0
40008a20:	00068a13          	mv	s4,a3
40008a24:	00058913          	mv	s2,a1
40008a28:	00060993          	mv	s3,a2
40008a2c:	93dfb0ef          	jal	ra,40004368 <__locale_charset>
40008a30:	000a0713          	mv	a4,s4
40008a34:	00050693          	mv	a3,a0
40008a38:	00098613          	mv	a2,s3
40008a3c:	00090593          	mv	a1,s2
40008a40:	00048513          	mv	a0,s1
40008a44:	00040313          	mv	t1,s0
40008a48:	01c12083          	lw	ra,28(sp)
40008a4c:	01812403          	lw	s0,24(sp)
40008a50:	01412483          	lw	s1,20(sp)
40008a54:	01012903          	lw	s2,16(sp)
40008a58:	00c12983          	lw	s3,12(sp)
40008a5c:	00812a03          	lw	s4,8(sp)
40008a60:	02010113          	addi	sp,sp,32
40008a64:	00030067          	jr	t1

40008a68 <sbrk>:
40008a68:	4000c737          	lui	a4,0x4000c
40008a6c:	65872783          	lw	a5,1624(a4) # 4000c658 <heap_end.1376>
40008a70:	00078a63          	beqz	a5,40008a84 <sbrk+0x1c>
40008a74:	00a78533          	add	a0,a5,a0
40008a78:	64a72c23          	sw	a0,1624(a4)
40008a7c:	00078513          	mv	a0,a5
40008a80:	00008067          	ret
40008a84:	4000c7b7          	lui	a5,0x4000c
40008a88:	68878793          	addi	a5,a5,1672 # 4000c688 <_bss_end>
40008a8c:	00a78533          	add	a0,a5,a0
40008a90:	64a72c23          	sw	a0,1624(a4)
40008a94:	00078513          	mv	a0,a5
40008a98:	00008067          	ret

40008a9c <__adddf3>:
40008a9c:	001007b7          	lui	a5,0x100
40008aa0:	fff78313          	addi	t1,a5,-1 # fffff <_heap_size+0xfdfff>
40008aa4:	fe010113          	addi	sp,sp,-32
40008aa8:	00b377b3          	and	a5,t1,a1
40008aac:	0145d713          	srli	a4,a1,0x14
40008ab0:	00d37eb3          	and	t4,t1,a3
40008ab4:	0146de13          	srli	t3,a3,0x14
40008ab8:	00379893          	slli	a7,a5,0x3
40008abc:	01d65f13          	srli	t5,a2,0x1d
40008ac0:	00912a23          	sw	s1,20(sp)
40008ac4:	01312623          	sw	s3,12(sp)
40008ac8:	01f5d813          	srli	a6,a1,0x1f
40008acc:	01d55793          	srli	a5,a0,0x1d
40008ad0:	003e9e93          	slli	t4,t4,0x3
40008ad4:	7ff77493          	andi	s1,a4,2047
40008ad8:	7ffe7e13          	andi	t3,t3,2047
40008adc:	00112e23          	sw	ra,28(sp)
40008ae0:	00812c23          	sw	s0,24(sp)
40008ae4:	01212823          	sw	s2,16(sp)
40008ae8:	01f6df93          	srli	t6,a3,0x1f
40008aec:	0117e7b3          	or	a5,a5,a7
40008af0:	00080993          	mv	s3,a6
40008af4:	00351893          	slli	a7,a0,0x3
40008af8:	01df6eb3          	or	t4,t5,t4
40008afc:	00361613          	slli	a2,a2,0x3
40008b00:	41c48733          	sub	a4,s1,t3
40008b04:	1bf80863          	beq	a6,t6,40008cb4 <__adddf3+0x218>
40008b08:	30e05263          	blez	a4,40008e0c <__adddf3+0x370>
40008b0c:	160e1063          	bnez	t3,40008c6c <__adddf3+0x1d0>
40008b10:	00cee6b3          	or	a3,t4,a2
40008b14:	20068063          	beqz	a3,40008d14 <__adddf3+0x278>
40008b18:	fff70693          	addi	a3,a4,-1
40008b1c:	3c069663          	bnez	a3,40008ee8 <__adddf3+0x44c>
40008b20:	40c88933          	sub	s2,a7,a2
40008b24:	41d787b3          	sub	a5,a5,t4
40008b28:	0128b8b3          	sltu	a7,a7,s2
40008b2c:	411787b3          	sub	a5,a5,a7
40008b30:	00100493          	li	s1,1
40008b34:	00879713          	slli	a4,a5,0x8
40008b38:	20075c63          	bgez	a4,40008d50 <__adddf3+0x2b4>
40008b3c:	00800637          	lui	a2,0x800
40008b40:	fff60613          	addi	a2,a2,-1 # 7fffff <_heap_size+0x7fdfff>
40008b44:	00c7f433          	and	s0,a5,a2
40008b48:	30040463          	beqz	s0,40008e50 <__adddf3+0x3b4>
40008b4c:	00040513          	mv	a0,s0
40008b50:	251020ef          	jal	ra,4000b5a0 <__clzsi2>
40008b54:	ff850713          	addi	a4,a0,-8
40008b58:	01f00793          	li	a5,31
40008b5c:	30e7c663          	blt	a5,a4,40008e68 <__adddf3+0x3cc>
40008b60:	02000793          	li	a5,32
40008b64:	40e787b3          	sub	a5,a5,a4
40008b68:	00f957b3          	srl	a5,s2,a5
40008b6c:	00e41633          	sll	a2,s0,a4
40008b70:	00c7e7b3          	or	a5,a5,a2
40008b74:	00e91933          	sll	s2,s2,a4
40008b78:	30974063          	blt	a4,s1,40008e78 <__adddf3+0x3dc>
40008b7c:	40970733          	sub	a4,a4,s1
40008b80:	00170613          	addi	a2,a4,1
40008b84:	01f00693          	li	a3,31
40008b88:	36c6c863          	blt	a3,a2,40008ef8 <__adddf3+0x45c>
40008b8c:	02000713          	li	a4,32
40008b90:	40c70733          	sub	a4,a4,a2
40008b94:	00e916b3          	sll	a3,s2,a4
40008b98:	00c955b3          	srl	a1,s2,a2
40008b9c:	00e79733          	sll	a4,a5,a4
40008ba0:	00b76733          	or	a4,a4,a1
40008ba4:	00d036b3          	snez	a3,a3
40008ba8:	00d76933          	or	s2,a4,a3
40008bac:	00c7d7b3          	srl	a5,a5,a2
40008bb0:	00797713          	andi	a4,s2,7
40008bb4:	00098813          	mv	a6,s3
40008bb8:	00000493          	li	s1,0
40008bbc:	00090893          	mv	a7,s2
40008bc0:	02070063          	beqz	a4,40008be0 <__adddf3+0x144>
40008bc4:	00f97713          	andi	a4,s2,15
40008bc8:	00400693          	li	a3,4
40008bcc:	00090893          	mv	a7,s2
40008bd0:	00d70863          	beq	a4,a3,40008be0 <__adddf3+0x144>
40008bd4:	00d908b3          	add	a7,s2,a3
40008bd8:	0128b6b3          	sltu	a3,a7,s2
40008bdc:	00d787b3          	add	a5,a5,a3
40008be0:	00879713          	slli	a4,a5,0x8
40008be4:	0e075a63          	bgez	a4,40008cd8 <__adddf3+0x23c>
40008be8:	00148713          	addi	a4,s1,1
40008bec:	7ff00693          	li	a3,2047
40008bf0:	2ad70263          	beq	a4,a3,40008e94 <__adddf3+0x3f8>
40008bf4:	ff8006b7          	lui	a3,0xff800
40008bf8:	fff68693          	addi	a3,a3,-1 # ff7fffff <_bss_end+0xbf7f3977>
40008bfc:	00d7f7b3          	and	a5,a5,a3
40008c00:	01d79693          	slli	a3,a5,0x1d
40008c04:	0038d893          	srli	a7,a7,0x3
40008c08:	00979793          	slli	a5,a5,0x9
40008c0c:	0116e6b3          	or	a3,a3,a7
40008c10:	00c7d793          	srli	a5,a5,0xc
40008c14:	7ff77713          	andi	a4,a4,2047
40008c18:	001005b7          	lui	a1,0x100
40008c1c:	fff58593          	addi	a1,a1,-1 # fffff <_heap_size+0xfdfff>
40008c20:	00b7f7b3          	and	a5,a5,a1
40008c24:	801005b7          	lui	a1,0x80100
40008c28:	fff58593          	addi	a1,a1,-1 # 800fffff <_bss_end+0x400f3977>
40008c2c:	00b7f5b3          	and	a1,a5,a1
40008c30:	01471713          	slli	a4,a4,0x14
40008c34:	800007b7          	lui	a5,0x80000
40008c38:	01c12083          	lw	ra,28(sp)
40008c3c:	00e5e5b3          	or	a1,a1,a4
40008c40:	fff7c793          	not	a5,a5
40008c44:	01f81813          	slli	a6,a6,0x1f
40008c48:	00f5f5b3          	and	a1,a1,a5
40008c4c:	0105e5b3          	or	a1,a1,a6
40008c50:	00068513          	mv	a0,a3
40008c54:	01812403          	lw	s0,24(sp)
40008c58:	01412483          	lw	s1,20(sp)
40008c5c:	01012903          	lw	s2,16(sp)
40008c60:	00c12983          	lw	s3,12(sp)
40008c64:	02010113          	addi	sp,sp,32
40008c68:	00008067          	ret
40008c6c:	008005b7          	lui	a1,0x800
40008c70:	7ff00693          	li	a3,2047
40008c74:	00beeeb3          	or	t4,t4,a1
40008c78:	16d48663          	beq	s1,a3,40008de4 <__adddf3+0x348>
40008c7c:	03800693          	li	a3,56
40008c80:	0ae6c663          	blt	a3,a4,40008d2c <__adddf3+0x290>
40008c84:	01f00693          	li	a3,31
40008c88:	2ae6c463          	blt	a3,a4,40008f30 <__adddf3+0x494>
40008c8c:	02000593          	li	a1,32
40008c90:	40e585b3          	sub	a1,a1,a4
40008c94:	00e65933          	srl	s2,a2,a4
40008c98:	00be96b3          	sll	a3,t4,a1
40008c9c:	00b61633          	sll	a2,a2,a1
40008ca0:	0126e6b3          	or	a3,a3,s2
40008ca4:	00c03933          	snez	s2,a2
40008ca8:	0126e6b3          	or	a3,a3,s2
40008cac:	00eedeb3          	srl	t4,t4,a4
40008cb0:	0880006f          	j	40008d38 <__adddf3+0x29c>
40008cb4:	1ee05663          	blez	a4,40008ea0 <__adddf3+0x404>
40008cb8:	0a0e1c63          	bnez	t3,40008d70 <__adddf3+0x2d4>
40008cbc:	00cee6b3          	or	a3,t4,a2
40008cc0:	32069063          	bnez	a3,40008fe0 <__adddf3+0x544>
40008cc4:	7ff00693          	li	a3,2047
40008cc8:	36d70a63          	beq	a4,a3,4000903c <__adddf3+0x5a0>
40008ccc:	00070493          	mv	s1,a4
40008cd0:	00879713          	slli	a4,a5,0x8
40008cd4:	f0074ae3          	bltz	a4,40008be8 <__adddf3+0x14c>
40008cd8:	01d79693          	slli	a3,a5,0x1d
40008cdc:	0038d893          	srli	a7,a7,0x3
40008ce0:	7ff00713          	li	a4,2047
40008ce4:	00d8e6b3          	or	a3,a7,a3
40008ce8:	0037d793          	srli	a5,a5,0x3
40008cec:	10e49663          	bne	s1,a4,40008df8 <__adddf3+0x35c>
40008cf0:	00f6e733          	or	a4,a3,a5
40008cf4:	5a070c63          	beqz	a4,400092ac <__adddf3+0x810>
40008cf8:	00080737          	lui	a4,0x80
40008cfc:	00e7e7b3          	or	a5,a5,a4
40008d00:	00100737          	lui	a4,0x100
40008d04:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
40008d08:	00e7f7b3          	and	a5,a5,a4
40008d0c:	00048713          	mv	a4,s1
40008d10:	f09ff06f          	j	40008c18 <__adddf3+0x17c>
40008d14:	7ff00693          	li	a3,2047
40008d18:	fad71ae3          	bne	a4,a3,40008ccc <__adddf3+0x230>
40008d1c:	0117e6b3          	or	a3,a5,a7
40008d20:	32068263          	beqz	a3,40009044 <__adddf3+0x5a8>
40008d24:	7ff00493          	li	s1,2047
40008d28:	eb9ff06f          	j	40008be0 <__adddf3+0x144>
40008d2c:	00cee633          	or	a2,t4,a2
40008d30:	00c036b3          	snez	a3,a2
40008d34:	00000e93          	li	t4,0
40008d38:	40d88933          	sub	s2,a7,a3
40008d3c:	41d787b3          	sub	a5,a5,t4
40008d40:	0128b8b3          	sltu	a7,a7,s2
40008d44:	411787b3          	sub	a5,a5,a7
40008d48:	00879713          	slli	a4,a5,0x8
40008d4c:	de0748e3          	bltz	a4,40008b3c <__adddf3+0xa0>
40008d50:	00797713          	andi	a4,s2,7
40008d54:	00098813          	mv	a6,s3
40008d58:	e60716e3          	bnez	a4,40008bc4 <__adddf3+0x128>
40008d5c:	01d79893          	slli	a7,a5,0x1d
40008d60:	00395693          	srli	a3,s2,0x3
40008d64:	0116e6b3          	or	a3,a3,a7
40008d68:	0037d793          	srli	a5,a5,0x3
40008d6c:	0840006f          	j	40008df0 <__adddf3+0x354>
40008d70:	008005b7          	lui	a1,0x800
40008d74:	7ff00693          	li	a3,2047
40008d78:	00beeeb3          	or	t4,t4,a1
40008d7c:	06d48463          	beq	s1,a3,40008de4 <__adddf3+0x348>
40008d80:	03800693          	li	a3,56
40008d84:	28e6d463          	ble	a4,a3,4000900c <__adddf3+0x570>
40008d88:	00cee633          	or	a2,t4,a2
40008d8c:	00c036b3          	snez	a3,a2
40008d90:	00000e93          	li	t4,0
40008d94:	01168933          	add	s2,a3,a7
40008d98:	00fe87b3          	add	a5,t4,a5
40008d9c:	011938b3          	sltu	a7,s2,a7
40008da0:	011787b3          	add	a5,a5,a7
40008da4:	00879713          	slli	a4,a5,0x8
40008da8:	fa0754e3          	bgez	a4,40008d50 <__adddf3+0x2b4>
40008dac:	00148493          	addi	s1,s1,1
40008db0:	7ff00713          	li	a4,2047
40008db4:	3ae48663          	beq	s1,a4,40009160 <__adddf3+0x6c4>
40008db8:	ff800737          	lui	a4,0xff800
40008dbc:	fff70713          	addi	a4,a4,-1 # ff7fffff <_bss_end+0xbf7f3977>
40008dc0:	00e7f7b3          	and	a5,a5,a4
40008dc4:	00197693          	andi	a3,s2,1
40008dc8:	00195713          	srli	a4,s2,0x1
40008dcc:	00d766b3          	or	a3,a4,a3
40008dd0:	01f79913          	slli	s2,a5,0x1f
40008dd4:	00d96933          	or	s2,s2,a3
40008dd8:	0017d793          	srli	a5,a5,0x1
40008ddc:	00797713          	andi	a4,s2,7
40008de0:	dddff06f          	j	40008bbc <__adddf3+0x120>
40008de4:	0117e6b3          	or	a3,a5,a7
40008de8:	de069ce3          	bnez	a3,40008be0 <__adddf3+0x144>
40008dec:	00000793          	li	a5,0
40008df0:	7ff00713          	li	a4,2047
40008df4:	eee48ee3          	beq	s1,a4,40008cf0 <__adddf3+0x254>
40008df8:	00100737          	lui	a4,0x100
40008dfc:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
40008e00:	00e7f7b3          	and	a5,a5,a4
40008e04:	7ff4f713          	andi	a4,s1,2047
40008e08:	e11ff06f          	j	40008c18 <__adddf3+0x17c>
40008e0c:	14071a63          	bnez	a4,40008f60 <__adddf3+0x4c4>
40008e10:	00148713          	addi	a4,s1,1
40008e14:	7ff77713          	andi	a4,a4,2047
40008e18:	00100693          	li	a3,1
40008e1c:	2ae6d663          	ble	a4,a3,400090c8 <__adddf3+0x62c>
40008e20:	40c88933          	sub	s2,a7,a2
40008e24:	0128b733          	sltu	a4,a7,s2
40008e28:	41d78433          	sub	s0,a5,t4
40008e2c:	40e40433          	sub	s0,s0,a4
40008e30:	00841713          	slli	a4,s0,0x8
40008e34:	18075a63          	bgez	a4,40008fc8 <__adddf3+0x52c>
40008e38:	41160933          	sub	s2,a2,a7
40008e3c:	40fe87b3          	sub	a5,t4,a5
40008e40:	01263633          	sltu	a2,a2,s2
40008e44:	40c78433          	sub	s0,a5,a2
40008e48:	000f8993          	mv	s3,t6
40008e4c:	d00410e3          	bnez	s0,40008b4c <__adddf3+0xb0>
40008e50:	00090513          	mv	a0,s2
40008e54:	74c020ef          	jal	ra,4000b5a0 <__clzsi2>
40008e58:	02050513          	addi	a0,a0,32
40008e5c:	ff850713          	addi	a4,a0,-8
40008e60:	01f00793          	li	a5,31
40008e64:	cee7dee3          	ble	a4,a5,40008b60 <__adddf3+0xc4>
40008e68:	fd850793          	addi	a5,a0,-40
40008e6c:	00f917b3          	sll	a5,s2,a5
40008e70:	00000913          	li	s2,0
40008e74:	d09754e3          	ble	s1,a4,40008b7c <__adddf3+0xe0>
40008e78:	40e484b3          	sub	s1,s1,a4
40008e7c:	ff800737          	lui	a4,0xff800
40008e80:	fff70713          	addi	a4,a4,-1 # ff7fffff <_bss_end+0xbf7f3977>
40008e84:	00e7f7b3          	and	a5,a5,a4
40008e88:	00098813          	mv	a6,s3
40008e8c:	00797713          	andi	a4,s2,7
40008e90:	d2dff06f          	j	40008bbc <__adddf3+0x120>
40008e94:	00000793          	li	a5,0
40008e98:	00000693          	li	a3,0
40008e9c:	d7dff06f          	j	40008c18 <__adddf3+0x17c>
40008ea0:	26071e63          	bnez	a4,4000911c <__adddf3+0x680>
40008ea4:	00148593          	addi	a1,s1,1
40008ea8:	7ff5f713          	andi	a4,a1,2047
40008eac:	00100693          	li	a3,1
40008eb0:	1ce6da63          	ble	a4,a3,40009084 <__adddf3+0x5e8>
40008eb4:	7ff00713          	li	a4,2047
40008eb8:	30e58463          	beq	a1,a4,400091c0 <__adddf3+0x724>
40008ebc:	00c88633          	add	a2,a7,a2
40008ec0:	011638b3          	sltu	a7,a2,a7
40008ec4:	01d787b3          	add	a5,a5,t4
40008ec8:	011787b3          	add	a5,a5,a7
40008ecc:	01f79693          	slli	a3,a5,0x1f
40008ed0:	00165613          	srli	a2,a2,0x1
40008ed4:	00c6e933          	or	s2,a3,a2
40008ed8:	0017d793          	srli	a5,a5,0x1
40008edc:	00797713          	andi	a4,s2,7
40008ee0:	00058493          	mv	s1,a1
40008ee4:	cd9ff06f          	j	40008bbc <__adddf3+0x120>
40008ee8:	7ff00593          	li	a1,2047
40008eec:	e2b708e3          	beq	a4,a1,40008d1c <__adddf3+0x280>
40008ef0:	00068713          	mv	a4,a3
40008ef4:	d89ff06f          	j	40008c7c <__adddf3+0x1e0>
40008ef8:	fe170713          	addi	a4,a4,-31
40008efc:	02000593          	li	a1,32
40008f00:	00e7d733          	srl	a4,a5,a4
40008f04:	00000693          	li	a3,0
40008f08:	00b60863          	beq	a2,a1,40008f18 <__adddf3+0x47c>
40008f0c:	04000693          	li	a3,64
40008f10:	40c686b3          	sub	a3,a3,a2
40008f14:	00d796b3          	sll	a3,a5,a3
40008f18:	00d966b3          	or	a3,s2,a3
40008f1c:	00d036b3          	snez	a3,a3
40008f20:	00d76933          	or	s2,a4,a3
40008f24:	00000793          	li	a5,0
40008f28:	00000493          	li	s1,0
40008f2c:	e25ff06f          	j	40008d50 <__adddf3+0x2b4>
40008f30:	02000513          	li	a0,32
40008f34:	00eed6b3          	srl	a3,t4,a4
40008f38:	00000593          	li	a1,0
40008f3c:	00a70863          	beq	a4,a0,40008f4c <__adddf3+0x4b0>
40008f40:	04000593          	li	a1,64
40008f44:	40e58733          	sub	a4,a1,a4
40008f48:	00ee95b3          	sll	a1,t4,a4
40008f4c:	00c5e633          	or	a2,a1,a2
40008f50:	00c03933          	snez	s2,a2
40008f54:	0126e6b3          	or	a3,a3,s2
40008f58:	00000e93          	li	t4,0
40008f5c:	dddff06f          	j	40008d38 <__adddf3+0x29c>
40008f60:	0e048863          	beqz	s1,40009050 <__adddf3+0x5b4>
40008f64:	008005b7          	lui	a1,0x800
40008f68:	7ff00693          	li	a3,2047
40008f6c:	40e00733          	neg	a4,a4
40008f70:	00b7e7b3          	or	a5,a5,a1
40008f74:	22de0263          	beq	t3,a3,40009198 <__adddf3+0x6fc>
40008f78:	03800693          	li	a3,56
40008f7c:	22e6ca63          	blt	a3,a4,400091b0 <__adddf3+0x714>
40008f80:	01f00693          	li	a3,31
40008f84:	38e6ca63          	blt	a3,a4,40009318 <__adddf3+0x87c>
40008f88:	02000593          	li	a1,32
40008f8c:	40e585b3          	sub	a1,a1,a4
40008f90:	00b796b3          	sll	a3,a5,a1
40008f94:	00e8d533          	srl	a0,a7,a4
40008f98:	00b895b3          	sll	a1,a7,a1
40008f9c:	00a6e6b3          	or	a3,a3,a0
40008fa0:	00b03933          	snez	s2,a1
40008fa4:	0126e6b3          	or	a3,a3,s2
40008fa8:	00e7d733          	srl	a4,a5,a4
40008fac:	40d60933          	sub	s2,a2,a3
40008fb0:	40ee87b3          	sub	a5,t4,a4
40008fb4:	01263633          	sltu	a2,a2,s2
40008fb8:	40c787b3          	sub	a5,a5,a2
40008fbc:	000e0493          	mv	s1,t3
40008fc0:	000f8993          	mv	s3,t6
40008fc4:	b71ff06f          	j	40008b34 <__adddf3+0x98>
40008fc8:	008966b3          	or	a3,s2,s0
40008fcc:	b6069ee3          	bnez	a3,40008b48 <__adddf3+0xac>
40008fd0:	00000793          	li	a5,0
40008fd4:	00000813          	li	a6,0
40008fd8:	00000493          	li	s1,0
40008fdc:	e15ff06f          	j	40008df0 <__adddf3+0x354>
40008fe0:	fff70693          	addi	a3,a4,-1
40008fe4:	08069863          	bnez	a3,40009074 <__adddf3+0x5d8>
40008fe8:	00c88933          	add	s2,a7,a2
40008fec:	01d787b3          	add	a5,a5,t4
40008ff0:	011938b3          	sltu	a7,s2,a7
40008ff4:	011787b3          	add	a5,a5,a7
40008ff8:	00879713          	slli	a4,a5,0x8
40008ffc:	00100493          	li	s1,1
40009000:	d40758e3          	bgez	a4,40008d50 <__adddf3+0x2b4>
40009004:	00200493          	li	s1,2
40009008:	db1ff06f          	j	40008db8 <__adddf3+0x31c>
4000900c:	01f00693          	li	a3,31
40009010:	0ce6ce63          	blt	a3,a4,400090ec <__adddf3+0x650>
40009014:	02000593          	li	a1,32
40009018:	40e585b3          	sub	a1,a1,a4
4000901c:	00be96b3          	sll	a3,t4,a1
40009020:	00e65533          	srl	a0,a2,a4
40009024:	00b61633          	sll	a2,a2,a1
40009028:	00a6e6b3          	or	a3,a3,a0
4000902c:	00c03933          	snez	s2,a2
40009030:	0126e6b3          	or	a3,a3,s2
40009034:	00eedeb3          	srl	t4,t4,a4
40009038:	d5dff06f          	j	40008d94 <__adddf3+0x2f8>
4000903c:	0117e6b3          	or	a3,a5,a7
40009040:	c80696e3          	bnez	a3,40008ccc <__adddf3+0x230>
40009044:	00000793          	li	a5,0
40009048:	00070493          	mv	s1,a4
4000904c:	da5ff06f          	j	40008df0 <__adddf3+0x354>
40009050:	0117e6b3          	or	a3,a5,a7
40009054:	10069c63          	bnez	a3,4000916c <__adddf3+0x6d0>
40009058:	7ff00793          	li	a5,2047
4000905c:	12fe0e63          	beq	t3,a5,40009198 <__adddf3+0x6fc>
40009060:	000f8813          	mv	a6,t6
40009064:	000e8793          	mv	a5,t4
40009068:	00060893          	mv	a7,a2
4000906c:	000e0493          	mv	s1,t3
40009070:	b71ff06f          	j	40008be0 <__adddf3+0x144>
40009074:	7ff00593          	li	a1,2047
40009078:	fcb702e3          	beq	a4,a1,4000903c <__adddf3+0x5a0>
4000907c:	00068713          	mv	a4,a3
40009080:	d01ff06f          	j	40008d80 <__adddf3+0x2e4>
40009084:	0117e733          	or	a4,a5,a7
40009088:	22049a63          	bnez	s1,400092bc <__adddf3+0x820>
4000908c:	04070a63          	beqz	a4,400090e0 <__adddf3+0x644>
40009090:	00cee733          	or	a4,t4,a2
40009094:	b40706e3          	beqz	a4,40008be0 <__adddf3+0x144>
40009098:	00c88933          	add	s2,a7,a2
4000909c:	01d787b3          	add	a5,a5,t4
400090a0:	011938b3          	sltu	a7,s2,a7
400090a4:	011787b3          	add	a5,a5,a7
400090a8:	00879713          	slli	a4,a5,0x8
400090ac:	ca0752e3          	bgez	a4,40008d50 <__adddf3+0x2b4>
400090b0:	ff800737          	lui	a4,0xff800
400090b4:	fff70713          	addi	a4,a4,-1 # ff7fffff <_bss_end+0xbf7f3977>
400090b8:	00e7f7b3          	and	a5,a5,a4
400090bc:	00068493          	mv	s1,a3
400090c0:	00797713          	andi	a4,s2,7
400090c4:	af9ff06f          	j	40008bbc <__adddf3+0x120>
400090c8:	0117e733          	or	a4,a5,a7
400090cc:	06049a63          	bnez	s1,40009140 <__adddf3+0x6a4>
400090d0:	16071063          	bnez	a4,40009230 <__adddf3+0x794>
400090d4:	00cee6b3          	or	a3,t4,a2
400090d8:	22068a63          	beqz	a3,4000930c <__adddf3+0x870>
400090dc:	000f8813          	mv	a6,t6
400090e0:	000e8793          	mv	a5,t4
400090e4:	00060893          	mv	a7,a2
400090e8:	af9ff06f          	j	40008be0 <__adddf3+0x144>
400090ec:	02000513          	li	a0,32
400090f0:	00eed6b3          	srl	a3,t4,a4
400090f4:	00000593          	li	a1,0
400090f8:	00a70863          	beq	a4,a0,40009108 <__adddf3+0x66c>
400090fc:	04000593          	li	a1,64
40009100:	40e58733          	sub	a4,a1,a4
40009104:	00ee95b3          	sll	a1,t4,a4
40009108:	00c5e633          	or	a2,a1,a2
4000910c:	00c03933          	snez	s2,a2
40009110:	0126e6b3          	or	a3,a3,s2
40009114:	00000e93          	li	t4,0
40009118:	c7dff06f          	j	40008d94 <__adddf3+0x2f8>
4000911c:	0a049a63          	bnez	s1,400091d0 <__adddf3+0x734>
40009120:	0117e6b3          	or	a3,a5,a7
40009124:	22069263          	bnez	a3,40009348 <__adddf3+0x8ac>
40009128:	7ff00793          	li	a5,2047
4000912c:	24fe0263          	beq	t3,a5,40009370 <__adddf3+0x8d4>
40009130:	000e8793          	mv	a5,t4
40009134:	00060893          	mv	a7,a2
40009138:	000e0493          	mv	s1,t3
4000913c:	aa5ff06f          	j	40008be0 <__adddf3+0x144>
40009140:	12071663          	bnez	a4,4000926c <__adddf3+0x7d0>
40009144:	00cee7b3          	or	a5,t4,a2
40009148:	22078a63          	beqz	a5,4000937c <__adddf3+0x8e0>
4000914c:	000f8813          	mv	a6,t6
40009150:	000e8793          	mv	a5,t4
40009154:	00060893          	mv	a7,a2
40009158:	7ff00493          	li	s1,2047
4000915c:	a85ff06f          	j	40008be0 <__adddf3+0x144>
40009160:	00000793          	li	a5,0
40009164:	00000693          	li	a3,0
40009168:	c89ff06f          	j	40008df0 <__adddf3+0x354>
4000916c:	fff74713          	not	a4,a4
40009170:	02071063          	bnez	a4,40009190 <__adddf3+0x6f4>
40009174:	41160933          	sub	s2,a2,a7
40009178:	40fe87b3          	sub	a5,t4,a5
4000917c:	01263633          	sltu	a2,a2,s2
40009180:	40c787b3          	sub	a5,a5,a2
40009184:	000e0493          	mv	s1,t3
40009188:	000f8993          	mv	s3,t6
4000918c:	9a9ff06f          	j	40008b34 <__adddf3+0x98>
40009190:	7ff00693          	li	a3,2047
40009194:	dede12e3          	bne	t3,a3,40008f78 <__adddf3+0x4dc>
40009198:	00cee6b3          	or	a3,t4,a2
4000919c:	000f8813          	mv	a6,t6
400091a0:	f80698e3          	bnez	a3,40009130 <__adddf3+0x694>
400091a4:	00000793          	li	a5,0
400091a8:	000e0493          	mv	s1,t3
400091ac:	c45ff06f          	j	40008df0 <__adddf3+0x354>
400091b0:	0117e7b3          	or	a5,a5,a7
400091b4:	00f036b3          	snez	a3,a5
400091b8:	00000713          	li	a4,0
400091bc:	df1ff06f          	j	40008fac <__adddf3+0x510>
400091c0:	00058493          	mv	s1,a1
400091c4:	00000793          	li	a5,0
400091c8:	00000693          	li	a3,0
400091cc:	c25ff06f          	j	40008df0 <__adddf3+0x354>
400091d0:	008005b7          	lui	a1,0x800
400091d4:	7ff00693          	li	a3,2047
400091d8:	40e00733          	neg	a4,a4
400091dc:	00b7e7b3          	or	a5,a5,a1
400091e0:	18de0863          	beq	t3,a3,40009370 <__adddf3+0x8d4>
400091e4:	03800693          	li	a3,56
400091e8:	1ae6c463          	blt	a3,a4,40009390 <__adddf3+0x8f4>
400091ec:	01f00693          	li	a3,31
400091f0:	1ce6c463          	blt	a3,a4,400093b8 <__adddf3+0x91c>
400091f4:	02000593          	li	a1,32
400091f8:	40e585b3          	sub	a1,a1,a4
400091fc:	00b796b3          	sll	a3,a5,a1
40009200:	00e8d533          	srl	a0,a7,a4
40009204:	00b895b3          	sll	a1,a7,a1
40009208:	00a6e6b3          	or	a3,a3,a0
4000920c:	00b03933          	snez	s2,a1
40009210:	0126e6b3          	or	a3,a3,s2
40009214:	00e7d7b3          	srl	a5,a5,a4
40009218:	00c68933          	add	s2,a3,a2
4000921c:	01d787b3          	add	a5,a5,t4
40009220:	00c93633          	sltu	a2,s2,a2
40009224:	00c787b3          	add	a5,a5,a2
40009228:	000e0493          	mv	s1,t3
4000922c:	b79ff06f          	j	40008da4 <__adddf3+0x308>
40009230:	00cee733          	or	a4,t4,a2
40009234:	9a0706e3          	beqz	a4,40008be0 <__adddf3+0x144>
40009238:	40c88933          	sub	s2,a7,a2
4000923c:	0128b6b3          	sltu	a3,a7,s2
40009240:	41d78733          	sub	a4,a5,t4
40009244:	40d70733          	sub	a4,a4,a3
40009248:	00871693          	slli	a3,a4,0x8
4000924c:	0a06da63          	bgez	a3,40009300 <__adddf3+0x864>
40009250:	41160933          	sub	s2,a2,a7
40009254:	40fe87b3          	sub	a5,t4,a5
40009258:	01263633          	sltu	a2,a2,s2
4000925c:	40c787b3          	sub	a5,a5,a2
40009260:	00797713          	andi	a4,s2,7
40009264:	000f8813          	mv	a6,t6
40009268:	955ff06f          	j	40008bbc <__adddf3+0x120>
4000926c:	00cee633          	or	a2,t4,a2
40009270:	aa060ae3          	beqz	a2,40008d24 <__adddf3+0x288>
40009274:	00feeeb3          	or	t4,t4,a5
40009278:	009e9713          	slli	a4,t4,0x9
4000927c:	12074263          	bltz	a4,400093a0 <__adddf3+0x904>
40009280:	20000737          	lui	a4,0x20000
40009284:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
40009288:	01d79893          	slli	a7,a5,0x1d
4000928c:	00a77533          	and	a0,a4,a0
40009290:	00a8e533          	or	a0,a7,a0
40009294:	ff87f793          	andi	a5,a5,-8
40009298:	01d55713          	srli	a4,a0,0x1d
4000929c:	00e7e7b3          	or	a5,a5,a4
400092a0:	00351893          	slli	a7,a0,0x3
400092a4:	7ff00493          	li	s1,2047
400092a8:	939ff06f          	j	40008be0 <__adddf3+0x144>
400092ac:	00000693          	li	a3,0
400092b0:	00048713          	mv	a4,s1
400092b4:	00000793          	li	a5,0
400092b8:	961ff06f          	j	40008c18 <__adddf3+0x17c>
400092bc:	e8070ae3          	beqz	a4,40009150 <__adddf3+0x6b4>
400092c0:	00cee633          	or	a2,t4,a2
400092c4:	a60600e3          	beqz	a2,40008d24 <__adddf3+0x288>
400092c8:	00feeeb3          	or	t4,t4,a5
400092cc:	009e9713          	slli	a4,t4,0x9
400092d0:	0c074863          	bltz	a4,400093a0 <__adddf3+0x904>
400092d4:	20000737          	lui	a4,0x20000
400092d8:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
400092dc:	01d79893          	slli	a7,a5,0x1d
400092e0:	00a77533          	and	a0,a4,a0
400092e4:	00a8e533          	or	a0,a7,a0
400092e8:	01d55713          	srli	a4,a0,0x1d
400092ec:	ff87f793          	andi	a5,a5,-8
400092f0:	00f767b3          	or	a5,a4,a5
400092f4:	00351893          	slli	a7,a0,0x3
400092f8:	7ff00493          	li	s1,2047
400092fc:	8e5ff06f          	j	40008be0 <__adddf3+0x144>
40009300:	00e966b3          	or	a3,s2,a4
40009304:	00070793          	mv	a5,a4
40009308:	a40694e3          	bnez	a3,40008d50 <__adddf3+0x2b4>
4000930c:	00000793          	li	a5,0
40009310:	00000813          	li	a6,0
40009314:	addff06f          	j	40008df0 <__adddf3+0x354>
40009318:	02000513          	li	a0,32
4000931c:	00e7d6b3          	srl	a3,a5,a4
40009320:	00000593          	li	a1,0
40009324:	00a70863          	beq	a4,a0,40009334 <__adddf3+0x898>
40009328:	04000593          	li	a1,64
4000932c:	40e58733          	sub	a4,a1,a4
40009330:	00e795b3          	sll	a1,a5,a4
40009334:	0115e5b3          	or	a1,a1,a7
40009338:	00b03933          	snez	s2,a1
4000933c:	0126e6b3          	or	a3,a3,s2
40009340:	00000713          	li	a4,0
40009344:	c69ff06f          	j	40008fac <__adddf3+0x510>
40009348:	fff74713          	not	a4,a4
4000934c:	00071e63          	bnez	a4,40009368 <__adddf3+0x8cc>
40009350:	00c88933          	add	s2,a7,a2
40009354:	01d787b3          	add	a5,a5,t4
40009358:	00c93633          	sltu	a2,s2,a2
4000935c:	00c787b3          	add	a5,a5,a2
40009360:	000e0493          	mv	s1,t3
40009364:	a41ff06f          	j	40008da4 <__adddf3+0x308>
40009368:	7ff00693          	li	a3,2047
4000936c:	e6de1ce3          	bne	t3,a3,400091e4 <__adddf3+0x748>
40009370:	00cee6b3          	or	a3,t4,a2
40009374:	da069ee3          	bnez	a3,40009130 <__adddf3+0x694>
40009378:	e2dff06f          	j	400091a4 <__adddf3+0x708>
4000937c:	00000813          	li	a6,0
40009380:	00030793          	mv	a5,t1
40009384:	fff00693          	li	a3,-1
40009388:	7ff00493          	li	s1,2047
4000938c:	a65ff06f          	j	40008df0 <__adddf3+0x354>
40009390:	0117e7b3          	or	a5,a5,a7
40009394:	00f036b3          	snez	a3,a5
40009398:	00000793          	li	a5,0
4000939c:	e7dff06f          	j	40009218 <__adddf3+0x77c>
400093a0:	008007b7          	lui	a5,0x800
400093a4:	00000813          	li	a6,0
400093a8:	ff800893          	li	a7,-8
400093ac:	fff78793          	addi	a5,a5,-1 # 7fffff <_heap_size+0x7fdfff>
400093b0:	7ff00493          	li	s1,2047
400093b4:	82dff06f          	j	40008be0 <__adddf3+0x144>
400093b8:	02000513          	li	a0,32
400093bc:	00e7d6b3          	srl	a3,a5,a4
400093c0:	00000593          	li	a1,0
400093c4:	00a70863          	beq	a4,a0,400093d4 <__adddf3+0x938>
400093c8:	04000593          	li	a1,64
400093cc:	40e58733          	sub	a4,a1,a4
400093d0:	00e795b3          	sll	a1,a5,a4
400093d4:	0115e5b3          	or	a1,a1,a7
400093d8:	00b03933          	snez	s2,a1
400093dc:	0126e6b3          	or	a3,a3,s2
400093e0:	00000793          	li	a5,0
400093e4:	e35ff06f          	j	40009218 <__adddf3+0x77c>

400093e8 <__divdf3>:
400093e8:	fc010113          	addi	sp,sp,-64
400093ec:	02812c23          	sw	s0,56(sp)
400093f0:	0145d713          	srli	a4,a1,0x14
400093f4:	00100437          	lui	s0,0x100
400093f8:	02912a23          	sw	s1,52(sp)
400093fc:	03312623          	sw	s3,44(sp)
40009400:	03512223          	sw	s5,36(sp)
40009404:	01812c23          	sw	s8,24(sp)
40009408:	00050493          	mv	s1,a0
4000940c:	01f5d993          	srli	s3,a1,0x1f
40009410:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
40009414:	02112e23          	sw	ra,60(sp)
40009418:	03212823          	sw	s2,48(sp)
4000941c:	03412423          	sw	s4,40(sp)
40009420:	03612023          	sw	s6,32(sp)
40009424:	01712e23          	sw	s7,28(sp)
40009428:	01912a23          	sw	s9,20(sp)
4000942c:	7ff77513          	andi	a0,a4,2047
40009430:	00060c13          	mv	s8,a2
40009434:	00b47433          	and	s0,s0,a1
40009438:	00098a93          	mv	s5,s3
4000943c:	1c050a63          	beqz	a0,40009610 <__divdf3+0x228>
40009440:	7ff00793          	li	a5,2047
40009444:	08f50a63          	beq	a0,a5,400094d8 <__divdf3+0xf0>
40009448:	01d4d793          	srli	a5,s1,0x1d
4000944c:	00800b37          	lui	s6,0x800
40009450:	00341413          	slli	s0,s0,0x3
40009454:	0167e7b3          	or	a5,a5,s6
40009458:	00349913          	slli	s2,s1,0x3
4000945c:	0087eb33          	or	s6,a5,s0
40009460:	c0150a13          	addi	s4,a0,-1023
40009464:	00000493          	li	s1,0
40009468:	00000c93          	li	s9,0
4000946c:	0146d513          	srli	a0,a3,0x14
40009470:	00100437          	lui	s0,0x100
40009474:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
40009478:	7ff57513          	andi	a0,a0,2047
4000947c:	00d47433          	and	s0,s0,a3
40009480:	01f6db93          	srli	s7,a3,0x1f
40009484:	08050463          	beqz	a0,4000950c <__divdf3+0x124>
40009488:	7ff00793          	li	a5,2047
4000948c:	1cf50e63          	beq	a0,a5,40009668 <__divdf3+0x280>
40009490:	01dc5793          	srli	a5,s8,0x1d
40009494:	00800737          	lui	a4,0x800
40009498:	00e7e7b3          	or	a5,a5,a4
4000949c:	00341413          	slli	s0,s0,0x3
400094a0:	0087e433          	or	s0,a5,s0
400094a4:	003c1693          	slli	a3,s8,0x3
400094a8:	c0150513          	addi	a0,a0,-1023
400094ac:	00000793          	li	a5,0
400094b0:	0097e733          	or	a4,a5,s1
400094b4:	4000c637          	lui	a2,0x4000c
400094b8:	ab460613          	addi	a2,a2,-1356 # 4000bab4 <zeroes.4082+0x10>
400094bc:	00271713          	slli	a4,a4,0x2
400094c0:	00c70733          	add	a4,a4,a2
400094c4:	00072703          	lw	a4,0(a4) # 800000 <_heap_size+0x7fe000>
400094c8:	0179c633          	xor	a2,s3,s7
400094cc:	00060593          	mv	a1,a2
400094d0:	40aa0533          	sub	a0,s4,a0
400094d4:	00070067          	jr	a4
400094d8:	00946b33          	or	s6,s0,s1
400094dc:	1c0b1863          	bnez	s6,400096ac <__divdf3+0x2c4>
400094e0:	00050a13          	mv	s4,a0
400094e4:	00100437          	lui	s0,0x100
400094e8:	0146d513          	srli	a0,a3,0x14
400094ec:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
400094f0:	7ff57513          	andi	a0,a0,2047
400094f4:	00000913          	li	s2,0
400094f8:	00800493          	li	s1,8
400094fc:	00200c93          	li	s9,2
40009500:	00d47433          	and	s0,s0,a3
40009504:	01f6db93          	srli	s7,a3,0x1f
40009508:	f80510e3          	bnez	a0,40009488 <__divdf3+0xa0>
4000950c:	018466b3          	or	a3,s0,s8
40009510:	16068663          	beqz	a3,4000967c <__divdf3+0x294>
40009514:	26040263          	beqz	s0,40009778 <__divdf3+0x390>
40009518:	00040513          	mv	a0,s0
4000951c:	084020ef          	jal	ra,4000b5a0 <__clzsi2>
40009520:	ff550713          	addi	a4,a0,-11
40009524:	01c00793          	li	a5,28
40009528:	24e7c063          	blt	a5,a4,40009768 <__divdf3+0x380>
4000952c:	01d00793          	li	a5,29
40009530:	ff850693          	addi	a3,a0,-8
40009534:	40e787b3          	sub	a5,a5,a4
40009538:	00d41433          	sll	s0,s0,a3
4000953c:	00fc57b3          	srl	a5,s8,a5
40009540:	0087e433          	or	s0,a5,s0
40009544:	00dc16b3          	sll	a3,s8,a3
40009548:	c0d00713          	li	a4,-1011
4000954c:	40a70533          	sub	a0,a4,a0
40009550:	00000793          	li	a5,0
40009554:	f5dff06f          	j	400094b0 <__divdf3+0xc8>
40009558:	7ff00713          	li	a4,2047
4000955c:	00000793          	li	a5,0
40009560:	00000913          	li	s2,0
40009564:	001006b7          	lui	a3,0x100
40009568:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000956c:	00d7f7b3          	and	a5,a5,a3
40009570:	801006b7          	lui	a3,0x80100
40009574:	fff68693          	addi	a3,a3,-1 # 800fffff <_bss_end+0x400f3977>
40009578:	01471713          	slli	a4,a4,0x14
4000957c:	00d7f7b3          	and	a5,a5,a3
40009580:	00e7e7b3          	or	a5,a5,a4
40009584:	80000737          	lui	a4,0x80000
40009588:	fff74713          	not	a4,a4
4000958c:	03c12083          	lw	ra,60(sp)
40009590:	01f61613          	slli	a2,a2,0x1f
40009594:	00e7f7b3          	and	a5,a5,a4
40009598:	00c7e7b3          	or	a5,a5,a2
4000959c:	00090513          	mv	a0,s2
400095a0:	00078593          	mv	a1,a5
400095a4:	03812403          	lw	s0,56(sp)
400095a8:	03412483          	lw	s1,52(sp)
400095ac:	03012903          	lw	s2,48(sp)
400095b0:	02c12983          	lw	s3,44(sp)
400095b4:	02812a03          	lw	s4,40(sp)
400095b8:	02412a83          	lw	s5,36(sp)
400095bc:	02012b03          	lw	s6,32(sp)
400095c0:	01c12b83          	lw	s7,28(sp)
400095c4:	01812c03          	lw	s8,24(sp)
400095c8:	01412c83          	lw	s9,20(sp)
400095cc:	04010113          	addi	sp,sp,64
400095d0:	00008067          	ret
400095d4:	000b8a93          	mv	s5,s7
400095d8:	00040b13          	mv	s6,s0
400095dc:	00068913          	mv	s2,a3
400095e0:	00078c93          	mv	s9,a5
400095e4:	00200793          	li	a5,2
400095e8:	60fc8463          	beq	s9,a5,40009bf0 <__divdf3+0x808>
400095ec:	00300793          	li	a5,3
400095f0:	60fc8a63          	beq	s9,a5,40009c04 <__divdf3+0x81c>
400095f4:	00100793          	li	a5,1
400095f8:	50fc9a63          	bne	s9,a5,40009b0c <__divdf3+0x724>
400095fc:	000a8613          	mv	a2,s5
40009600:	00000713          	li	a4,0
40009604:	00000793          	li	a5,0
40009608:	00000913          	li	s2,0
4000960c:	f59ff06f          	j	40009564 <__divdf3+0x17c>
40009610:	00946b33          	or	s6,s0,s1
40009614:	080b0263          	beqz	s6,40009698 <__divdf3+0x2b0>
40009618:	00d12623          	sw	a3,12(sp)
4000961c:	12040c63          	beqz	s0,40009754 <__divdf3+0x36c>
40009620:	00040513          	mv	a0,s0
40009624:	77d010ef          	jal	ra,4000b5a0 <__clzsi2>
40009628:	00c12683          	lw	a3,12(sp)
4000962c:	ff550b13          	addi	s6,a0,-11
40009630:	01c00793          	li	a5,28
40009634:	1167c863          	blt	a5,s6,40009744 <__divdf3+0x35c>
40009638:	01d00793          	li	a5,29
4000963c:	ff850913          	addi	s2,a0,-8
40009640:	416787b3          	sub	a5,a5,s6
40009644:	01241433          	sll	s0,s0,s2
40009648:	00f4d7b3          	srl	a5,s1,a5
4000964c:	0087eb33          	or	s6,a5,s0
40009650:	01249933          	sll	s2,s1,s2
40009654:	c0d00a13          	li	s4,-1011
40009658:	40aa0a33          	sub	s4,s4,a0
4000965c:	00000493          	li	s1,0
40009660:	00000c93          	li	s9,0
40009664:	e09ff06f          	j	4000946c <__divdf3+0x84>
40009668:	018466b3          	or	a3,s0,s8
4000966c:	02069063          	bnez	a3,4000968c <__divdf3+0x2a4>
40009670:	00000413          	li	s0,0
40009674:	00200793          	li	a5,2
40009678:	e39ff06f          	j	400094b0 <__divdf3+0xc8>
4000967c:	00000413          	li	s0,0
40009680:	00000513          	li	a0,0
40009684:	00100793          	li	a5,1
40009688:	e29ff06f          	j	400094b0 <__divdf3+0xc8>
4000968c:	000c0693          	mv	a3,s8
40009690:	00300793          	li	a5,3
40009694:	e1dff06f          	j	400094b0 <__divdf3+0xc8>
40009698:	00000913          	li	s2,0
4000969c:	00400493          	li	s1,4
400096a0:	00000a13          	li	s4,0
400096a4:	00100c93          	li	s9,1
400096a8:	dc5ff06f          	j	4000946c <__divdf3+0x84>
400096ac:	00048913          	mv	s2,s1
400096b0:	00040b13          	mv	s6,s0
400096b4:	00c00493          	li	s1,12
400096b8:	00050a13          	mv	s4,a0
400096bc:	00300c93          	li	s9,3
400096c0:	dadff06f          	j	4000946c <__divdf3+0x84>
400096c4:	00100737          	lui	a4,0x100
400096c8:	fff70793          	addi	a5,a4,-1 # fffff <_heap_size+0xfdfff>
400096cc:	00000613          	li	a2,0
400096d0:	fff00913          	li	s2,-1
400096d4:	7ff00713          	li	a4,2047
400096d8:	e8dff06f          	j	40009564 <__divdf3+0x17c>
400096dc:	40e40433          	sub	s0,s0,a4
400096e0:	03800793          	li	a5,56
400096e4:	4887d463          	ble	s0,a5,40009b6c <__divdf3+0x784>
400096e8:	0015f613          	andi	a2,a1,1
400096ec:	00000713          	li	a4,0
400096f0:	00000793          	li	a5,0
400096f4:	00000913          	li	s2,0
400096f8:	e6dff06f          	j	40009564 <__divdf3+0x17c>
400096fc:	09646863          	bltu	s0,s6,4000978c <__divdf3+0x3a4>
40009700:	088b0463          	beq	s6,s0,40009788 <__divdf3+0x3a0>
40009704:	00090613          	mv	a2,s2
40009708:	fff50513          	addi	a0,a0,-1
4000970c:	000b0793          	mv	a5,s6
40009710:	00000913          	li	s2,0
40009714:	08c0006f          	j	400097a0 <__divdf3+0x3b8>
40009718:	008b6433          	or	s0,s6,s0
4000971c:	00c41793          	slli	a5,s0,0xc
40009720:	fa07c2e3          	bltz	a5,400096c4 <__divdf3+0x2dc>
40009724:	000807b7          	lui	a5,0x80
40009728:	00100737          	lui	a4,0x100
4000972c:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
40009730:	00fb67b3          	or	a5,s6,a5
40009734:	00e7f7b3          	and	a5,a5,a4
40009738:	00098613          	mv	a2,s3
4000973c:	7ff00713          	li	a4,2047
40009740:	e25ff06f          	j	40009564 <__divdf3+0x17c>
40009744:	fd850413          	addi	s0,a0,-40
40009748:	00849b33          	sll	s6,s1,s0
4000974c:	00000913          	li	s2,0
40009750:	f05ff06f          	j	40009654 <__divdf3+0x26c>
40009754:	00048513          	mv	a0,s1
40009758:	649010ef          	jal	ra,4000b5a0 <__clzsi2>
4000975c:	02050513          	addi	a0,a0,32
40009760:	00c12683          	lw	a3,12(sp)
40009764:	ec9ff06f          	j	4000962c <__divdf3+0x244>
40009768:	fd850413          	addi	s0,a0,-40
4000976c:	008c1433          	sll	s0,s8,s0
40009770:	00000693          	li	a3,0
40009774:	dd5ff06f          	j	40009548 <__divdf3+0x160>
40009778:	000c0513          	mv	a0,s8
4000977c:	625010ef          	jal	ra,4000b5a0 <__clzsi2>
40009780:	02050513          	addi	a0,a0,32
40009784:	d9dff06f          	j	40009520 <__divdf3+0x138>
40009788:	f6d96ee3          	bltu	s2,a3,40009704 <__divdf3+0x31c>
4000978c:	00195713          	srli	a4,s2,0x1
40009790:	01fb1613          	slli	a2,s6,0x1f
40009794:	001b5793          	srli	a5,s6,0x1
40009798:	00e66633          	or	a2,a2,a4
4000979c:	01f91913          	slli	s2,s2,0x1f
400097a0:	0186d813          	srli	a6,a3,0x18
400097a4:	00841413          	slli	s0,s0,0x8
400097a8:	00886833          	or	a6,a6,s0
400097ac:	01085893          	srli	a7,a6,0x10
400097b0:	0317de33          	divu	t3,a5,a7
400097b4:	01081313          	slli	t1,a6,0x10
400097b8:	01035313          	srli	t1,t1,0x10
400097bc:	01065713          	srli	a4,a2,0x10
400097c0:	00869693          	slli	a3,a3,0x8
400097c4:	0317f7b3          	remu	a5,a5,a7
400097c8:	03c30eb3          	mul	t4,t1,t3
400097cc:	01079793          	slli	a5,a5,0x10
400097d0:	00f76733          	or	a4,a4,a5
400097d4:	01d77e63          	bleu	t4,a4,400097f0 <__divdf3+0x408>
400097d8:	01070733          	add	a4,a4,a6
400097dc:	fffe0793          	addi	a5,t3,-1
400097e0:	25076e63          	bltu	a4,a6,40009a3c <__divdf3+0x654>
400097e4:	25d77c63          	bleu	t4,a4,40009a3c <__divdf3+0x654>
400097e8:	ffee0e13          	addi	t3,t3,-2
400097ec:	01070733          	add	a4,a4,a6
400097f0:	41d70733          	sub	a4,a4,t4
400097f4:	03175433          	divu	s0,a4,a7
400097f8:	01061613          	slli	a2,a2,0x10
400097fc:	01065613          	srli	a2,a2,0x10
40009800:	03177733          	remu	a4,a4,a7
40009804:	02830f33          	mul	t5,t1,s0
40009808:	01071713          	slli	a4,a4,0x10
4000980c:	00e66733          	or	a4,a2,a4
40009810:	01e77e63          	bleu	t5,a4,4000982c <__divdf3+0x444>
40009814:	01070733          	add	a4,a4,a6
40009818:	fff40793          	addi	a5,s0,-1
4000981c:	21076c63          	bltu	a4,a6,40009a34 <__divdf3+0x64c>
40009820:	21e77a63          	bleu	t5,a4,40009a34 <__divdf3+0x64c>
40009824:	ffe40413          	addi	s0,s0,-2
40009828:	01070733          	add	a4,a4,a6
4000982c:	010e1e13          	slli	t3,t3,0x10
40009830:	000104b7          	lui	s1,0x10
40009834:	008e6b33          	or	s6,t3,s0
40009838:	fff48e13          	addi	t3,s1,-1 # ffff <_heap_size+0xdfff>
4000983c:	01cb7fb3          	and	t6,s6,t3
40009840:	010b5293          	srli	t0,s6,0x10
40009844:	0106de93          	srli	t4,a3,0x10
40009848:	01c6fe33          	and	t3,a3,t3
4000984c:	03c28633          	mul	a2,t0,t3
40009850:	41e70f33          	sub	t5,a4,t5
40009854:	03cf83b3          	mul	t2,t6,t3
40009858:	03fe87b3          	mul	a5,t4,t6
4000985c:	0103d713          	srli	a4,t2,0x10
40009860:	00c787b3          	add	a5,a5,a2
40009864:	00f707b3          	add	a5,a4,a5
40009868:	03d282b3          	mul	t0,t0,t4
4000986c:	00c7f463          	bleu	a2,a5,40009874 <__divdf3+0x48c>
40009870:	009282b3          	add	t0,t0,s1
40009874:	00010637          	lui	a2,0x10
40009878:	fff60613          	addi	a2,a2,-1 # ffff <_heap_size+0xdfff>
4000987c:	0107d713          	srli	a4,a5,0x10
40009880:	00c7f7b3          	and	a5,a5,a2
40009884:	01079793          	slli	a5,a5,0x10
40009888:	00c3f3b3          	and	t2,t2,a2
4000988c:	005702b3          	add	t0,a4,t0
40009890:	007787b3          	add	a5,a5,t2
40009894:	145f6a63          	bltu	t5,t0,400099e8 <__divdf3+0x600>
40009898:	405f0733          	sub	a4,t5,t0
4000989c:	145f0263          	beq	t5,t0,400099e0 <__divdf3+0x5f8>
400098a0:	40f907b3          	sub	a5,s2,a5
400098a4:	00f93933          	sltu	s2,s2,a5
400098a8:	41270733          	sub	a4,a4,s2
400098ac:	1ce80463          	beq	a6,a4,40009a74 <__divdf3+0x68c>
400098b0:	03175f33          	divu	t5,a4,a7
400098b4:	0107d613          	srli	a2,a5,0x10
400098b8:	03177733          	remu	a4,a4,a7
400098bc:	03e30fb3          	mul	t6,t1,t5
400098c0:	01071713          	slli	a4,a4,0x10
400098c4:	00e66733          	or	a4,a2,a4
400098c8:	01f77e63          	bleu	t6,a4,400098e4 <__divdf3+0x4fc>
400098cc:	01070733          	add	a4,a4,a6
400098d0:	ffff0613          	addi	a2,t5,-1
400098d4:	25076463          	bltu	a4,a6,40009b1c <__divdf3+0x734>
400098d8:	25f77263          	bleu	t6,a4,40009b1c <__divdf3+0x734>
400098dc:	ffef0f13          	addi	t5,t5,-2
400098e0:	01070733          	add	a4,a4,a6
400098e4:	41f70733          	sub	a4,a4,t6
400098e8:	03175933          	divu	s2,a4,a7
400098ec:	01079793          	slli	a5,a5,0x10
400098f0:	0107d793          	srli	a5,a5,0x10
400098f4:	03177733          	remu	a4,a4,a7
400098f8:	03230333          	mul	t1,t1,s2
400098fc:	01071713          	slli	a4,a4,0x10
40009900:	00e7e7b3          	or	a5,a5,a4
40009904:	0067fe63          	bleu	t1,a5,40009920 <__divdf3+0x538>
40009908:	010787b3          	add	a5,a5,a6
4000990c:	fff90713          	addi	a4,s2,-1
40009910:	2107e263          	bltu	a5,a6,40009b14 <__divdf3+0x72c>
40009914:	2067f063          	bleu	t1,a5,40009b14 <__divdf3+0x72c>
40009918:	ffe90913          	addi	s2,s2,-2
4000991c:	010787b3          	add	a5,a5,a6
40009920:	010f1f13          	slli	t5,t5,0x10
40009924:	012f6933          	or	s2,t5,s2
40009928:	01091613          	slli	a2,s2,0x10
4000992c:	01095f13          	srli	t5,s2,0x10
40009930:	01065613          	srli	a2,a2,0x10
40009934:	02ce08b3          	mul	a7,t3,a2
40009938:	406787b3          	sub	a5,a5,t1
4000993c:	02ce8633          	mul	a2,t4,a2
40009940:	0108d713          	srli	a4,a7,0x10
40009944:	03cf0e33          	mul	t3,t5,t3
40009948:	01c60633          	add	a2,a2,t3
4000994c:	00c70733          	add	a4,a4,a2
40009950:	03ee8eb3          	mul	t4,t4,t5
40009954:	01c77663          	bleu	t3,a4,40009960 <__divdf3+0x578>
40009958:	00010637          	lui	a2,0x10
4000995c:	00ce8eb3          	add	t4,t4,a2
40009960:	00010337          	lui	t1,0x10
40009964:	fff30313          	addi	t1,t1,-1 # ffff <_heap_size+0xdfff>
40009968:	01075613          	srli	a2,a4,0x10
4000996c:	00677733          	and	a4,a4,t1
40009970:	01071713          	slli	a4,a4,0x10
40009974:	0068f8b3          	and	a7,a7,t1
40009978:	01d60eb3          	add	t4,a2,t4
4000997c:	01170733          	add	a4,a4,a7
40009980:	09d7fa63          	bleu	t4,a5,40009a14 <__divdf3+0x62c>
40009984:	00f807b3          	add	a5,a6,a5
40009988:	fff90613          	addi	a2,s2,-1
4000998c:	1907fc63          	bleu	a6,a5,40009b24 <__divdf3+0x73c>
40009990:	00060913          	mv	s2,a2
40009994:	0bd78c63          	beq	a5,t4,40009a4c <__divdf3+0x664>
40009998:	00196913          	ori	s2,s2,1
4000999c:	3ff50713          	addi	a4,a0,1023
400099a0:	0ee05063          	blez	a4,40009a80 <__divdf3+0x698>
400099a4:	00797793          	andi	a5,s2,7
400099a8:	14079263          	bnez	a5,40009aec <__divdf3+0x704>
400099ac:	007b1793          	slli	a5,s6,0x7
400099b0:	0007da63          	bgez	a5,400099c4 <__divdf3+0x5dc>
400099b4:	ff0007b7          	lui	a5,0xff000
400099b8:	fff78793          	addi	a5,a5,-1 # feffffff <_bss_end+0xbeff3977>
400099bc:	00fb7b33          	and	s6,s6,a5
400099c0:	40050713          	addi	a4,a0,1024
400099c4:	7fe00793          	li	a5,2046
400099c8:	08e7d663          	ble	a4,a5,40009a54 <__divdf3+0x66c>
400099cc:	0015f613          	andi	a2,a1,1
400099d0:	7ff00713          	li	a4,2047
400099d4:	00000793          	li	a5,0
400099d8:	00000913          	li	s2,0
400099dc:	b89ff06f          	j	40009564 <__divdf3+0x17c>
400099e0:	00000713          	li	a4,0
400099e4:	eaf97ee3          	bleu	a5,s2,400098a0 <__divdf3+0x4b8>
400099e8:	00d90933          	add	s2,s2,a3
400099ec:	00d93633          	sltu	a2,s2,a3
400099f0:	01060633          	add	a2,a2,a6
400099f4:	01e60633          	add	a2,a2,t5
400099f8:	fffb0f13          	addi	t5,s6,-1 # 7fffff <_heap_size+0x7fdfff>
400099fc:	02c87263          	bleu	a2,a6,40009a20 <__divdf3+0x638>
40009a00:	12566a63          	bltu	a2,t0,40009b34 <__divdf3+0x74c>
40009a04:	1cc28e63          	beq	t0,a2,40009be0 <__divdf3+0x7f8>
40009a08:	40560733          	sub	a4,a2,t0
40009a0c:	000f0b13          	mv	s6,t5
40009a10:	e91ff06f          	j	400098a0 <__divdf3+0x4b8>
40009a14:	f9d792e3          	bne	a5,t4,40009998 <__divdf3+0x5b0>
40009a18:	f80702e3          	beqz	a4,4000999c <__divdf3+0x5b4>
40009a1c:	f69ff06f          	j	40009984 <__divdf3+0x59c>
40009a20:	fec814e3          	bne	a6,a2,40009a08 <__divdf3+0x620>
40009a24:	fcd97ee3          	bleu	a3,s2,40009a00 <__divdf3+0x618>
40009a28:	40580733          	sub	a4,a6,t0
40009a2c:	000f0b13          	mv	s6,t5
40009a30:	e71ff06f          	j	400098a0 <__divdf3+0x4b8>
40009a34:	00078413          	mv	s0,a5
40009a38:	df5ff06f          	j	4000982c <__divdf3+0x444>
40009a3c:	00078e13          	mv	t3,a5
40009a40:	db1ff06f          	j	400097f0 <__divdf3+0x408>
40009a44:	10e6e663          	bltu	a3,a4,40009b50 <__divdf3+0x768>
40009a48:	00060913          	mv	s2,a2
40009a4c:	f4d716e3          	bne	a4,a3,40009998 <__divdf3+0x5b0>
40009a50:	f4dff06f          	j	4000999c <__divdf3+0x5b4>
40009a54:	00395913          	srli	s2,s2,0x3
40009a58:	01db1693          	slli	a3,s6,0x1d
40009a5c:	009b1793          	slli	a5,s6,0x9
40009a60:	0126e933          	or	s2,a3,s2
40009a64:	00c7d793          	srli	a5,a5,0xc
40009a68:	7ff77713          	andi	a4,a4,2047
40009a6c:	0015f613          	andi	a2,a1,1
40009a70:	af5ff06f          	j	40009564 <__divdf3+0x17c>
40009a74:	3ff50713          	addi	a4,a0,1023
40009a78:	fff00913          	li	s2,-1
40009a7c:	06e04e63          	bgtz	a4,40009af8 <__divdf3+0x710>
40009a80:	00100413          	li	s0,1
40009a84:	c4071ce3          	bnez	a4,400096dc <__divdf3+0x2f4>
40009a88:	02000793          	li	a5,32
40009a8c:	408787b3          	sub	a5,a5,s0
40009a90:	00fb1733          	sll	a4,s6,a5
40009a94:	008956b3          	srl	a3,s2,s0
40009a98:	00f917b3          	sll	a5,s2,a5
40009a9c:	00f037b3          	snez	a5,a5
40009aa0:	00d76733          	or	a4,a4,a3
40009aa4:	00f76733          	or	a4,a4,a5
40009aa8:	00777793          	andi	a5,a4,7
40009aac:	008b5433          	srl	s0,s6,s0
40009ab0:	02078063          	beqz	a5,40009ad0 <__divdf3+0x6e8>
40009ab4:	00f77793          	andi	a5,a4,15
40009ab8:	00400693          	li	a3,4
40009abc:	00d78a63          	beq	a5,a3,40009ad0 <__divdf3+0x6e8>
40009ac0:	00470793          	addi	a5,a4,4
40009ac4:	00e7b733          	sltu	a4,a5,a4
40009ac8:	00e40433          	add	s0,s0,a4
40009acc:	00078713          	mv	a4,a5
40009ad0:	00841793          	slli	a5,s0,0x8
40009ad4:	0e07d663          	bgez	a5,40009bc0 <__divdf3+0x7d8>
40009ad8:	0015f613          	andi	a2,a1,1
40009adc:	00100713          	li	a4,1
40009ae0:	00000793          	li	a5,0
40009ae4:	00000913          	li	s2,0
40009ae8:	a7dff06f          	j	40009564 <__divdf3+0x17c>
40009aec:	00f97793          	andi	a5,s2,15
40009af0:	00400693          	li	a3,4
40009af4:	ead78ce3          	beq	a5,a3,400099ac <__divdf3+0x5c4>
40009af8:	00490793          	addi	a5,s2,4
40009afc:	0127b933          	sltu	s2,a5,s2
40009b00:	012b0b33          	add	s6,s6,s2
40009b04:	00078913          	mv	s2,a5
40009b08:	ea5ff06f          	j	400099ac <__divdf3+0x5c4>
40009b0c:	000a8593          	mv	a1,s5
40009b10:	e8dff06f          	j	4000999c <__divdf3+0x5b4>
40009b14:	00070913          	mv	s2,a4
40009b18:	e09ff06f          	j	40009920 <__divdf3+0x538>
40009b1c:	00060f13          	mv	t5,a2
40009b20:	dc5ff06f          	j	400098e4 <__divdf3+0x4fc>
40009b24:	03d7e663          	bltu	a5,t4,40009b50 <__divdf3+0x768>
40009b28:	f0fe8ee3          	beq	t4,a5,40009a44 <__divdf3+0x65c>
40009b2c:	00060913          	mv	s2,a2
40009b30:	e69ff06f          	j	40009998 <__divdf3+0x5b0>
40009b34:	00d90933          	add	s2,s2,a3
40009b38:	00d93733          	sltu	a4,s2,a3
40009b3c:	01070733          	add	a4,a4,a6
40009b40:	00c70733          	add	a4,a4,a2
40009b44:	ffeb0b13          	addi	s6,s6,-2
40009b48:	40570733          	sub	a4,a4,t0
40009b4c:	d55ff06f          	j	400098a0 <__divdf3+0x4b8>
40009b50:	00169893          	slli	a7,a3,0x1
40009b54:	00d8b6b3          	sltu	a3,a7,a3
40009b58:	01068833          	add	a6,a3,a6
40009b5c:	ffe90613          	addi	a2,s2,-2
40009b60:	010787b3          	add	a5,a5,a6
40009b64:	00088693          	mv	a3,a7
40009b68:	e29ff06f          	j	40009990 <__divdf3+0x5a8>
40009b6c:	01f00793          	li	a5,31
40009b70:	f087dce3          	ble	s0,a5,40009a88 <__divdf3+0x6a0>
40009b74:	fe100793          	li	a5,-31
40009b78:	40e78733          	sub	a4,a5,a4
40009b7c:	02000693          	li	a3,32
40009b80:	00eb5733          	srl	a4,s6,a4
40009b84:	00000793          	li	a5,0
40009b88:	00d40863          	beq	s0,a3,40009b98 <__divdf3+0x7b0>
40009b8c:	04000793          	li	a5,64
40009b90:	40878433          	sub	s0,a5,s0
40009b94:	008b17b3          	sll	a5,s6,s0
40009b98:	0127e7b3          	or	a5,a5,s2
40009b9c:	00f037b3          	snez	a5,a5
40009ba0:	00f76733          	or	a4,a4,a5
40009ba4:	00777413          	andi	s0,a4,7
40009ba8:	00000793          	li	a5,0
40009bac:	02040063          	beqz	s0,40009bcc <__divdf3+0x7e4>
40009bb0:	00f77793          	andi	a5,a4,15
40009bb4:	00400693          	li	a3,4
40009bb8:	00000413          	li	s0,0
40009bbc:	f0d792e3          	bne	a5,a3,40009ac0 <__divdf3+0x6d8>
40009bc0:	00941793          	slli	a5,s0,0x9
40009bc4:	00c7d793          	srli	a5,a5,0xc
40009bc8:	01d41413          	slli	s0,s0,0x1d
40009bcc:	00375713          	srli	a4,a4,0x3
40009bd0:	00876933          	or	s2,a4,s0
40009bd4:	0015f613          	andi	a2,a1,1
40009bd8:	00000713          	li	a4,0
40009bdc:	989ff06f          	j	40009564 <__divdf3+0x17c>
40009be0:	f4f96ae3          	bltu	s2,a5,40009b34 <__divdf3+0x74c>
40009be4:	000f0b13          	mv	s6,t5
40009be8:	00000713          	li	a4,0
40009bec:	cb5ff06f          	j	400098a0 <__divdf3+0x4b8>
40009bf0:	000a8613          	mv	a2,s5
40009bf4:	7ff00713          	li	a4,2047
40009bf8:	00000793          	li	a5,0
40009bfc:	00000913          	li	s2,0
40009c00:	965ff06f          	j	40009564 <__divdf3+0x17c>
40009c04:	00080737          	lui	a4,0x80
40009c08:	00eb67b3          	or	a5,s6,a4
40009c0c:	00100737          	lui	a4,0x100
40009c10:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
40009c14:	00e7f7b3          	and	a5,a5,a4
40009c18:	000a8613          	mv	a2,s5
40009c1c:	7ff00713          	li	a4,2047
40009c20:	945ff06f          	j	40009564 <__divdf3+0x17c>

40009c24 <__eqdf2>:
40009c24:	0145d713          	srli	a4,a1,0x14
40009c28:	001007b7          	lui	a5,0x100
40009c2c:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
40009c30:	0146d813          	srli	a6,a3,0x14
40009c34:	7ff00893          	li	a7,2047
40009c38:	7ff77713          	andi	a4,a4,2047
40009c3c:	00b7fe33          	and	t3,a5,a1
40009c40:	00050313          	mv	t1,a0
40009c44:	00d7f7b3          	and	a5,a5,a3
40009c48:	00050e93          	mv	t4,a0
40009c4c:	01f5d593          	srli	a1,a1,0x1f
40009c50:	00060f13          	mv	t5,a2
40009c54:	01187833          	and	a6,a6,a7
40009c58:	01f6d693          	srli	a3,a3,0x1f
40009c5c:	01170a63          	beq	a4,a7,40009c70 <__eqdf2+0x4c>
40009c60:	00100513          	li	a0,1
40009c64:	01180463          	beq	a6,a7,40009c6c <__eqdf2+0x48>
40009c68:	03070063          	beq	a4,a6,40009c88 <__eqdf2+0x64>
40009c6c:	00008067          	ret
40009c70:	00ae68b3          	or	a7,t3,a0
40009c74:	00100513          	li	a0,1
40009c78:	fe089ae3          	bnez	a7,40009c6c <__eqdf2+0x48>
40009c7c:	fee818e3          	bne	a6,a4,40009c6c <__eqdf2+0x48>
40009c80:	00c7e633          	or	a2,a5,a2
40009c84:	fe0614e3          	bnez	a2,40009c6c <__eqdf2+0x48>
40009c88:	00100513          	li	a0,1
40009c8c:	fefe10e3          	bne	t3,a5,40009c6c <__eqdf2+0x48>
40009c90:	fdee9ee3          	bne	t4,t5,40009c6c <__eqdf2+0x48>
40009c94:	00000513          	li	a0,0
40009c98:	fcd58ae3          	beq	a1,a3,40009c6c <__eqdf2+0x48>
40009c9c:	00100513          	li	a0,1
40009ca0:	fc0716e3          	bnez	a4,40009c6c <__eqdf2+0x48>
40009ca4:	006e6533          	or	a0,t3,t1
40009ca8:	00a03533          	snez	a0,a0
40009cac:	00008067          	ret

40009cb0 <__gedf2>:
40009cb0:	0145d713          	srli	a4,a1,0x14
40009cb4:	001007b7          	lui	a5,0x100
40009cb8:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
40009cbc:	00050893          	mv	a7,a0
40009cc0:	0146d813          	srli	a6,a3,0x14
40009cc4:	7ff00513          	li	a0,2047
40009cc8:	7ff77713          	andi	a4,a4,2047
40009ccc:	00b7f333          	and	t1,a5,a1
40009cd0:	00088e93          	mv	t4,a7
40009cd4:	00d7f7b3          	and	a5,a5,a3
40009cd8:	01f5d593          	srli	a1,a1,0x1f
40009cdc:	00060f13          	mv	t5,a2
40009ce0:	00a87833          	and	a6,a6,a0
40009ce4:	01f6d693          	srli	a3,a3,0x1f
40009ce8:	06a70a63          	beq	a4,a0,40009d5c <__gedf2+0xac>
40009cec:	7ff00513          	li	a0,2047
40009cf0:	04a80463          	beq	a6,a0,40009d38 <__gedf2+0x88>
40009cf4:	02071263          	bnez	a4,40009d18 <__gedf2+0x68>
40009cf8:	011368b3          	or	a7,t1,a7
40009cfc:	0018be13          	seqz	t3,a7
40009d00:	04081663          	bnez	a6,40009d4c <__gedf2+0x9c>
40009d04:	00c7e633          	or	a2,a5,a2
40009d08:	04061263          	bnez	a2,40009d4c <__gedf2+0x9c>
40009d0c:	00000513          	li	a0,0
40009d10:	00089c63          	bnez	a7,40009d28 <__gedf2+0x78>
40009d14:	00008067          	ret
40009d18:	00081663          	bnez	a6,40009d24 <__gedf2+0x74>
40009d1c:	00c7e633          	or	a2,a5,a2
40009d20:	00060463          	beqz	a2,40009d28 <__gedf2+0x78>
40009d24:	04d58463          	beq	a1,a3,40009d6c <__gedf2+0xbc>
40009d28:	00b035b3          	snez	a1,a1
40009d2c:	40b005b3          	neg	a1,a1
40009d30:	0015e513          	ori	a0,a1,1
40009d34:	00008067          	ret
40009d38:	00c7ee33          	or	t3,a5,a2
40009d3c:	ffe00513          	li	a0,-2
40009d40:	fc0e1ae3          	bnez	t3,40009d14 <__gedf2+0x64>
40009d44:	fc071ae3          	bnez	a4,40009d18 <__gedf2+0x68>
40009d48:	fb1ff06f          	j	40009cf8 <__gedf2+0x48>
40009d4c:	fff68513          	addi	a0,a3,-1
40009d50:	00156513          	ori	a0,a0,1
40009d54:	fc0e08e3          	beqz	t3,40009d24 <__gedf2+0x74>
40009d58:	00008067          	ret
40009d5c:	01136e33          	or	t3,t1,a7
40009d60:	ffe00513          	li	a0,-2
40009d64:	f80e04e3          	beqz	t3,40009cec <__gedf2+0x3c>
40009d68:	00008067          	ret
40009d6c:	02e84063          	blt	a6,a4,40009d8c <__gedf2+0xdc>
40009d70:	01074863          	blt	a4,a6,40009d80 <__gedf2+0xd0>
40009d74:	0067ec63          	bltu	a5,t1,40009d8c <__gedf2+0xdc>
40009d78:	02f30663          	beq	t1,a5,40009da4 <__gedf2+0xf4>
40009d7c:	02f37063          	bleu	a5,t1,40009d9c <__gedf2+0xec>
40009d80:	fff58593          	addi	a1,a1,-1 # 7fffff <_heap_size+0x7fdfff>
40009d84:	0015e513          	ori	a0,a1,1
40009d88:	00008067          	ret
40009d8c:	00b035b3          	snez	a1,a1
40009d90:	40b007b3          	neg	a5,a1
40009d94:	0017e513          	ori	a0,a5,1
40009d98:	00008067          	ret
40009d9c:	00000513          	li	a0,0
40009da0:	00008067          	ret
40009da4:	ffdf64e3          	bltu	t5,t4,40009d8c <__gedf2+0xdc>
40009da8:	00000513          	li	a0,0
40009dac:	fdeeeae3          	bltu	t4,t5,40009d80 <__gedf2+0xd0>
40009db0:	f65ff06f          	j	40009d14 <__gedf2+0x64>

40009db4 <__ledf2>:
40009db4:	0145d713          	srli	a4,a1,0x14
40009db8:	001007b7          	lui	a5,0x100
40009dbc:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
40009dc0:	00050893          	mv	a7,a0
40009dc4:	0146d813          	srli	a6,a3,0x14
40009dc8:	7ff00513          	li	a0,2047
40009dcc:	7ff77713          	andi	a4,a4,2047
40009dd0:	00b7f333          	and	t1,a5,a1
40009dd4:	00088e93          	mv	t4,a7
40009dd8:	00d7f7b3          	and	a5,a5,a3
40009ddc:	01f5d593          	srli	a1,a1,0x1f
40009de0:	00060f13          	mv	t5,a2
40009de4:	00a87833          	and	a6,a6,a0
40009de8:	01f6d693          	srli	a3,a3,0x1f
40009dec:	06a70463          	beq	a4,a0,40009e54 <__ledf2+0xa0>
40009df0:	7ff00513          	li	a0,2047
40009df4:	04a80063          	beq	a6,a0,40009e34 <__ledf2+0x80>
40009df8:	02071263          	bnez	a4,40009e1c <__ledf2+0x68>
40009dfc:	011368b3          	or	a7,t1,a7
40009e00:	0018be13          	seqz	t3,a7
40009e04:	04081063          	bnez	a6,40009e44 <__ledf2+0x90>
40009e08:	00c7e633          	or	a2,a5,a2
40009e0c:	02061c63          	bnez	a2,40009e44 <__ledf2+0x90>
40009e10:	00000513          	li	a0,0
40009e14:	00089863          	bnez	a7,40009e24 <__ledf2+0x70>
40009e18:	00008067          	ret
40009e1c:	04080463          	beqz	a6,40009e64 <__ledf2+0xb0>
40009e20:	04d58863          	beq	a1,a3,40009e70 <__ledf2+0xbc>
40009e24:	00b035b3          	snez	a1,a1
40009e28:	40b005b3          	neg	a1,a1
40009e2c:	0015e513          	ori	a0,a1,1
40009e30:	00008067          	ret
40009e34:	00c7ee33          	or	t3,a5,a2
40009e38:	00200513          	li	a0,2
40009e3c:	fa0e0ee3          	beqz	t3,40009df8 <__ledf2+0x44>
40009e40:	00008067          	ret
40009e44:	fff68513          	addi	a0,a3,-1
40009e48:	00156513          	ori	a0,a0,1
40009e4c:	fc0e0ae3          	beqz	t3,40009e20 <__ledf2+0x6c>
40009e50:	00008067          	ret
40009e54:	01136e33          	or	t3,t1,a7
40009e58:	00200513          	li	a0,2
40009e5c:	f80e0ae3          	beqz	t3,40009df0 <__ledf2+0x3c>
40009e60:	00008067          	ret
40009e64:	00c7e633          	or	a2,a5,a2
40009e68:	fa061ce3          	bnez	a2,40009e20 <__ledf2+0x6c>
40009e6c:	fb9ff06f          	j	40009e24 <__ledf2+0x70>
40009e70:	02e84063          	blt	a6,a4,40009e90 <__ledf2+0xdc>
40009e74:	01074863          	blt	a4,a6,40009e84 <__ledf2+0xd0>
40009e78:	0067ec63          	bltu	a5,t1,40009e90 <__ledf2+0xdc>
40009e7c:	02f30663          	beq	t1,a5,40009ea8 <__ledf2+0xf4>
40009e80:	02f37063          	bleu	a5,t1,40009ea0 <__ledf2+0xec>
40009e84:	fff58593          	addi	a1,a1,-1
40009e88:	0015e513          	ori	a0,a1,1
40009e8c:	00008067          	ret
40009e90:	00b035b3          	snez	a1,a1
40009e94:	40b007b3          	neg	a5,a1
40009e98:	0017e513          	ori	a0,a5,1
40009e9c:	00008067          	ret
40009ea0:	00000513          	li	a0,0
40009ea4:	00008067          	ret
40009ea8:	ffdf64e3          	bltu	t5,t4,40009e90 <__ledf2+0xdc>
40009eac:	00000513          	li	a0,0
40009eb0:	fdeeeae3          	bltu	t4,t5,40009e84 <__ledf2+0xd0>
40009eb4:	f65ff06f          	j	40009e18 <__ledf2+0x64>

40009eb8 <__muldf3>:
40009eb8:	fc010113          	addi	sp,sp,-64
40009ebc:	02812c23          	sw	s0,56(sp)
40009ec0:	0145d813          	srli	a6,a1,0x14
40009ec4:	00100437          	lui	s0,0x100
40009ec8:	03212823          	sw	s2,48(sp)
40009ecc:	03612023          	sw	s6,32(sp)
40009ed0:	01712e23          	sw	s7,28(sp)
40009ed4:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
40009ed8:	02112e23          	sw	ra,60(sp)
40009edc:	02912a23          	sw	s1,52(sp)
40009ee0:	03312623          	sw	s3,44(sp)
40009ee4:	03412423          	sw	s4,40(sp)
40009ee8:	03512223          	sw	s5,36(sp)
40009eec:	01812c23          	sw	s8,24(sp)
40009ef0:	7ff87813          	andi	a6,a6,2047
40009ef4:	00050913          	mv	s2,a0
40009ef8:	00060b93          	mv	s7,a2
40009efc:	00b47433          	and	s0,s0,a1
40009f00:	01f5db13          	srli	s6,a1,0x1f
40009f04:	1c080863          	beqz	a6,4000a0d4 <__muldf3+0x21c>
40009f08:	7ff00793          	li	a5,2047
40009f0c:	08f80e63          	beq	a6,a5,40009fa8 <__muldf3+0xf0>
40009f10:	01d55793          	srli	a5,a0,0x1d
40009f14:	00800737          	lui	a4,0x800
40009f18:	00341413          	slli	s0,s0,0x3
40009f1c:	00e7e7b3          	or	a5,a5,a4
40009f20:	0087e433          	or	s0,a5,s0
40009f24:	00351a93          	slli	s5,a0,0x3
40009f28:	c0180993          	addi	s3,a6,-1023
40009f2c:	00000913          	li	s2,0
40009f30:	00000c13          	li	s8,0
40009f34:	0146d513          	srli	a0,a3,0x14
40009f38:	001004b7          	lui	s1,0x100
40009f3c:	fff48493          	addi	s1,s1,-1 # fffff <_heap_size+0xfdfff>
40009f40:	7ff57513          	andi	a0,a0,2047
40009f44:	00d4f4b3          	and	s1,s1,a3
40009f48:	01f6da13          	srli	s4,a3,0x1f
40009f4c:	08050863          	beqz	a0,40009fdc <__muldf3+0x124>
40009f50:	7ff00793          	li	a5,2047
40009f54:	1cf50c63          	beq	a0,a5,4000a12c <__muldf3+0x274>
40009f58:	01dbd793          	srli	a5,s7,0x1d
40009f5c:	00800737          	lui	a4,0x800
40009f60:	00349493          	slli	s1,s1,0x3
40009f64:	00e7e7b3          	or	a5,a5,a4
40009f68:	0097e4b3          	or	s1,a5,s1
40009f6c:	003b9813          	slli	a6,s7,0x3
40009f70:	c0150513          	addi	a0,a0,-1023
40009f74:	00000693          	li	a3,0
40009f78:	00a98533          	add	a0,s3,a0
40009f7c:	0126e7b3          	or	a5,a3,s2
40009f80:	00f00713          	li	a4,15
40009f84:	014b4633          	xor	a2,s6,s4
40009f88:	00150593          	addi	a1,a0,1
40009f8c:	22f76063          	bltu	a4,a5,4000a1ac <__muldf3+0x2f4>
40009f90:	4000c737          	lui	a4,0x4000c
40009f94:	00279793          	slli	a5,a5,0x2
40009f98:	af470713          	addi	a4,a4,-1292 # 4000baf4 <zeroes.4082+0x50>
40009f9c:	00e787b3          	add	a5,a5,a4
40009fa0:	0007a783          	lw	a5,0(a5)
40009fa4:	00078067          	jr	a5
40009fa8:	00a46ab3          	or	s5,s0,a0
40009fac:	1a0a9463          	bnez	s5,4000a154 <__muldf3+0x29c>
40009fb0:	0146d513          	srli	a0,a3,0x14
40009fb4:	001004b7          	lui	s1,0x100
40009fb8:	fff48493          	addi	s1,s1,-1 # fffff <_heap_size+0xfdfff>
40009fbc:	7ff57513          	andi	a0,a0,2047
40009fc0:	00000413          	li	s0,0
40009fc4:	00800913          	li	s2,8
40009fc8:	00080993          	mv	s3,a6
40009fcc:	00200c13          	li	s8,2
40009fd0:	00d4f4b3          	and	s1,s1,a3
40009fd4:	01f6da13          	srli	s4,a3,0x1f
40009fd8:	f6051ce3          	bnez	a0,40009f50 <__muldf3+0x98>
40009fdc:	0174e833          	or	a6,s1,s7
40009fe0:	18080463          	beqz	a6,4000a168 <__muldf3+0x2b0>
40009fe4:	44048063          	beqz	s1,4000a424 <__muldf3+0x56c>
40009fe8:	00048513          	mv	a0,s1
40009fec:	5b4010ef          	jal	ra,4000b5a0 <__clzsi2>
40009ff0:	ff550713          	addi	a4,a0,-11
40009ff4:	01c00793          	li	a5,28
40009ff8:	40e7ce63          	blt	a5,a4,4000a414 <__muldf3+0x55c>
40009ffc:	01d00793          	li	a5,29
4000a000:	ff850813          	addi	a6,a0,-8
4000a004:	40e787b3          	sub	a5,a5,a4
4000a008:	010494b3          	sll	s1,s1,a6
4000a00c:	00fbd7b3          	srl	a5,s7,a5
4000a010:	0097e4b3          	or	s1,a5,s1
4000a014:	010b9833          	sll	a6,s7,a6
4000a018:	c0d00793          	li	a5,-1011
4000a01c:	40a78533          	sub	a0,a5,a0
4000a020:	00000693          	li	a3,0
4000a024:	f55ff06f          	j	40009f78 <__muldf3+0xc0>
4000a028:	000a0613          	mv	a2,s4
4000a02c:	00200793          	li	a5,2
4000a030:	10f68863          	beq	a3,a5,4000a140 <__muldf3+0x288>
4000a034:	00300793          	li	a5,3
4000a038:	52f68663          	beq	a3,a5,4000a564 <__muldf3+0x6ac>
4000a03c:	00100793          	li	a5,1
4000a040:	48f69063          	bne	a3,a5,4000a4c0 <__muldf3+0x608>
4000a044:	00f67b33          	and	s6,a2,a5
4000a048:	00000593          	li	a1,0
4000a04c:	00000413          	li	s0,0
4000a050:	00000a93          	li	s5,0
4000a054:	001007b7          	lui	a5,0x100
4000a058:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000a05c:	00f47433          	and	s0,s0,a5
4000a060:	01459793          	slli	a5,a1,0x14
4000a064:	801005b7          	lui	a1,0x80100
4000a068:	fff58593          	addi	a1,a1,-1 # 800fffff <_bss_end+0x400f3977>
4000a06c:	00b475b3          	and	a1,s0,a1
4000a070:	03c12083          	lw	ra,60(sp)
4000a074:	80000437          	lui	s0,0x80000
4000a078:	fff44413          	not	s0,s0
4000a07c:	00f5e5b3          	or	a1,a1,a5
4000a080:	01fb1713          	slli	a4,s6,0x1f
4000a084:	0085f5b3          	and	a1,a1,s0
4000a088:	000a8513          	mv	a0,s5
4000a08c:	00e5e5b3          	or	a1,a1,a4
4000a090:	03812403          	lw	s0,56(sp)
4000a094:	03412483          	lw	s1,52(sp)
4000a098:	03012903          	lw	s2,48(sp)
4000a09c:	02c12983          	lw	s3,44(sp)
4000a0a0:	02812a03          	lw	s4,40(sp)
4000a0a4:	02412a83          	lw	s5,36(sp)
4000a0a8:	02012b03          	lw	s6,32(sp)
4000a0ac:	01c12b83          	lw	s7,28(sp)
4000a0b0:	01812c03          	lw	s8,24(sp)
4000a0b4:	04010113          	addi	sp,sp,64
4000a0b8:	00008067          	ret
4000a0bc:	00100437          	lui	s0,0x100
4000a0c0:	00000b13          	li	s6,0
4000a0c4:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
4000a0c8:	fff00a93          	li	s5,-1
4000a0cc:	7ff00593          	li	a1,2047
4000a0d0:	f85ff06f          	j	4000a054 <__muldf3+0x19c>
4000a0d4:	00a46ab3          	or	s5,s0,a0
4000a0d8:	0a0a8663          	beqz	s5,4000a184 <__muldf3+0x2cc>
4000a0dc:	00d12623          	sw	a3,12(sp)
4000a0e0:	36040263          	beqz	s0,4000a444 <__muldf3+0x58c>
4000a0e4:	00040513          	mv	a0,s0
4000a0e8:	4b8010ef          	jal	ra,4000b5a0 <__clzsi2>
4000a0ec:	00c12683          	lw	a3,12(sp)
4000a0f0:	ff550793          	addi	a5,a0,-11
4000a0f4:	01c00713          	li	a4,28
4000a0f8:	32f74e63          	blt	a4,a5,4000a434 <__muldf3+0x57c>
4000a0fc:	01d00713          	li	a4,29
4000a100:	ff850493          	addi	s1,a0,-8
4000a104:	40f70733          	sub	a4,a4,a5
4000a108:	00941433          	sll	s0,s0,s1
4000a10c:	00e95733          	srl	a4,s2,a4
4000a110:	00876433          	or	s0,a4,s0
4000a114:	00991ab3          	sll	s5,s2,s1
4000a118:	c0d00813          	li	a6,-1011
4000a11c:	40a809b3          	sub	s3,a6,a0
4000a120:	00000913          	li	s2,0
4000a124:	00000c13          	li	s8,0
4000a128:	e0dff06f          	j	40009f34 <__muldf3+0x7c>
4000a12c:	0174e833          	or	a6,s1,s7
4000a130:	04081463          	bnez	a6,4000a178 <__muldf3+0x2c0>
4000a134:	00000493          	li	s1,0
4000a138:	00200693          	li	a3,2
4000a13c:	e3dff06f          	j	40009f78 <__muldf3+0xc0>
4000a140:	00167b13          	andi	s6,a2,1
4000a144:	7ff00593          	li	a1,2047
4000a148:	00000413          	li	s0,0
4000a14c:	00000a93          	li	s5,0
4000a150:	f05ff06f          	j	4000a054 <__muldf3+0x19c>
4000a154:	00050a93          	mv	s5,a0
4000a158:	00c00913          	li	s2,12
4000a15c:	00080993          	mv	s3,a6
4000a160:	00300c13          	li	s8,3
4000a164:	dd1ff06f          	j	40009f34 <__muldf3+0x7c>
4000a168:	00000493          	li	s1,0
4000a16c:	00000513          	li	a0,0
4000a170:	00100693          	li	a3,1
4000a174:	e05ff06f          	j	40009f78 <__muldf3+0xc0>
4000a178:	000b8813          	mv	a6,s7
4000a17c:	00300693          	li	a3,3
4000a180:	df9ff06f          	j	40009f78 <__muldf3+0xc0>
4000a184:	00000413          	li	s0,0
4000a188:	00400913          	li	s2,4
4000a18c:	00000993          	li	s3,0
4000a190:	00100c13          	li	s8,1
4000a194:	da1ff06f          	j	40009f34 <__muldf3+0x7c>
4000a198:	00040493          	mv	s1,s0
4000a19c:	000a8813          	mv	a6,s5
4000a1a0:	000b0613          	mv	a2,s6
4000a1a4:	000c0693          	mv	a3,s8
4000a1a8:	e85ff06f          	j	4000a02c <__muldf3+0x174>
4000a1ac:	00010e37          	lui	t3,0x10
4000a1b0:	fffe0713          	addi	a4,t3,-1 # ffff <_heap_size+0xdfff>
4000a1b4:	01085393          	srli	t2,a6,0x10
4000a1b8:	010ad693          	srli	a3,s5,0x10
4000a1bc:	00eaf7b3          	and	a5,s5,a4
4000a1c0:	00e87833          	and	a6,a6,a4
4000a1c4:	03078733          	mul	a4,a5,a6
4000a1c8:	03068333          	mul	t1,a3,a6
4000a1cc:	01075f13          	srli	t5,a4,0x10
4000a1d0:	02f388b3          	mul	a7,t2,a5
4000a1d4:	006888b3          	add	a7,a7,t1
4000a1d8:	011f0f33          	add	t5,t5,a7
4000a1dc:	027688b3          	mul	a7,a3,t2
4000a1e0:	006f7463          	bleu	t1,t5,4000a1e8 <__muldf3+0x330>
4000a1e4:	01c888b3          	add	a7,a7,t3
4000a1e8:	000102b7          	lui	t0,0x10
4000a1ec:	fff28e13          	addi	t3,t0,-1 # ffff <_heap_size+0xdfff>
4000a1f0:	0104df93          	srli	t6,s1,0x10
4000a1f4:	01c4f4b3          	and	s1,s1,t3
4000a1f8:	01cf7333          	and	t1,t5,t3
4000a1fc:	01c77733          	and	a4,a4,t3
4000a200:	01031313          	slli	t1,t1,0x10
4000a204:	02978eb3          	mul	t4,a5,s1
4000a208:	00e30333          	add	t1,t1,a4
4000a20c:	010f5f13          	srli	t5,t5,0x10
4000a210:	02ff8ab3          	mul	s5,t6,a5
4000a214:	010ed713          	srli	a4,t4,0x10
4000a218:	02968e33          	mul	t3,a3,s1
4000a21c:	01ca8ab3          	add	s5,s5,t3
4000a220:	01570ab3          	add	s5,a4,s5
4000a224:	03f687b3          	mul	a5,a3,t6
4000a228:	01caf463          	bleu	t3,s5,4000a230 <__muldf3+0x378>
4000a22c:	005787b3          	add	a5,a5,t0
4000a230:	000106b7          	lui	a3,0x10
4000a234:	fff68913          	addi	s2,a3,-1 # ffff <_heap_size+0xdfff>
4000a238:	01045293          	srli	t0,s0,0x10
4000a23c:	01247733          	and	a4,s0,s2
4000a240:	012afe33          	and	t3,s5,s2
4000a244:	012efeb3          	and	t4,t4,s2
4000a248:	010e1e13          	slli	t3,t3,0x10
4000a24c:	03070433          	mul	s0,a4,a6
4000a250:	01de0e33          	add	t3,t3,t4
4000a254:	010ada93          	srli	s5,s5,0x10
4000a258:	00fa87b3          	add	a5,s5,a5
4000a25c:	01cf0f33          	add	t5,t5,t3
4000a260:	02e38933          	mul	s2,t2,a4
4000a264:	01045e93          	srli	t4,s0,0x10
4000a268:	03028833          	mul	a6,t0,a6
4000a26c:	01090933          	add	s2,s2,a6
4000a270:	012e8eb3          	add	t4,t4,s2
4000a274:	025383b3          	mul	t2,t2,t0
4000a278:	010ef463          	bleu	a6,t4,4000a280 <__muldf3+0x3c8>
4000a27c:	00d383b3          	add	t2,t2,a3
4000a280:	00010937          	lui	s2,0x10
4000a284:	fff90813          	addi	a6,s2,-1 # ffff <_heap_size+0xdfff>
4000a288:	010ef6b3          	and	a3,t4,a6
4000a28c:	01047433          	and	s0,s0,a6
4000a290:	01069693          	slli	a3,a3,0x10
4000a294:	008686b3          	add	a3,a3,s0
4000a298:	010ede93          	srli	t4,t4,0x10
4000a29c:	02970833          	mul	a6,a4,s1
4000a2a0:	007e8eb3          	add	t4,t4,t2
4000a2a4:	02ef8733          	mul	a4,t6,a4
4000a2a8:	01085413          	srli	s0,a6,0x10
4000a2ac:	029284b3          	mul	s1,t0,s1
4000a2b0:	00970733          	add	a4,a4,s1
4000a2b4:	00e40733          	add	a4,s0,a4
4000a2b8:	025f8fb3          	mul	t6,t6,t0
4000a2bc:	00977463          	bleu	s1,a4,4000a2c4 <__muldf3+0x40c>
4000a2c0:	012f8fb3          	add	t6,t6,s2
4000a2c4:	000102b7          	lui	t0,0x10
4000a2c8:	fff28293          	addi	t0,t0,-1 # ffff <_heap_size+0xdfff>
4000a2cc:	00577433          	and	s0,a4,t0
4000a2d0:	00587833          	and	a6,a6,t0
4000a2d4:	01041413          	slli	s0,s0,0x10
4000a2d8:	01e888b3          	add	a7,a7,t5
4000a2dc:	01040433          	add	s0,s0,a6
4000a2e0:	01c8be33          	sltu	t3,a7,t3
4000a2e4:	00f40433          	add	s0,s0,a5
4000a2e8:	011688b3          	add	a7,a3,a7
4000a2ec:	008e02b3          	add	t0,t3,s0
4000a2f0:	00d8b6b3          	sltu	a3,a7,a3
4000a2f4:	005e8833          	add	a6,t4,t0
4000a2f8:	01068f33          	add	t5,a3,a6
4000a2fc:	00f437b3          	sltu	a5,s0,a5
4000a300:	01c2b433          	sltu	s0,t0,t3
4000a304:	0087e433          	or	s0,a5,s0
4000a308:	01d83eb3          	sltu	t4,a6,t4
4000a30c:	00df36b3          	sltu	a3,t5,a3
4000a310:	01075713          	srli	a4,a4,0x10
4000a314:	00e40433          	add	s0,s0,a4
4000a318:	00dee6b3          	or	a3,t4,a3
4000a31c:	00d40433          	add	s0,s0,a3
4000a320:	00989813          	slli	a6,a7,0x9
4000a324:	01f40433          	add	s0,s0,t6
4000a328:	017f5493          	srli	s1,t5,0x17
4000a32c:	00686833          	or	a6,a6,t1
4000a330:	00941413          	slli	s0,s0,0x9
4000a334:	01003833          	snez	a6,a6
4000a338:	0178d893          	srli	a7,a7,0x17
4000a33c:	009464b3          	or	s1,s0,s1
4000a340:	01186833          	or	a6,a6,a7
4000a344:	009f1f13          	slli	t5,t5,0x9
4000a348:	00749793          	slli	a5,s1,0x7
4000a34c:	01e86833          	or	a6,a6,t5
4000a350:	0207d063          	bgez	a5,4000a370 <__muldf3+0x4b8>
4000a354:	00185793          	srli	a5,a6,0x1
4000a358:	00187813          	andi	a6,a6,1
4000a35c:	01f49713          	slli	a4,s1,0x1f
4000a360:	0107e833          	or	a6,a5,a6
4000a364:	00e86833          	or	a6,a6,a4
4000a368:	0014d493          	srli	s1,s1,0x1
4000a36c:	00058513          	mv	a0,a1
4000a370:	3ff50593          	addi	a1,a0,1023
4000a374:	0eb05063          	blez	a1,4000a454 <__muldf3+0x59c>
4000a378:	00787793          	andi	a5,a6,7
4000a37c:	02078063          	beqz	a5,4000a39c <__muldf3+0x4e4>
4000a380:	00f87793          	andi	a5,a6,15
4000a384:	00400713          	li	a4,4
4000a388:	00e78a63          	beq	a5,a4,4000a39c <__muldf3+0x4e4>
4000a38c:	00e807b3          	add	a5,a6,a4
4000a390:	0107b833          	sltu	a6,a5,a6
4000a394:	010484b3          	add	s1,s1,a6
4000a398:	00078813          	mv	a6,a5
4000a39c:	00749793          	slli	a5,s1,0x7
4000a3a0:	0007da63          	bgez	a5,4000a3b4 <__muldf3+0x4fc>
4000a3a4:	ff0007b7          	lui	a5,0xff000
4000a3a8:	fff78793          	addi	a5,a5,-1 # feffffff <_bss_end+0xbeff3977>
4000a3ac:	00f4f4b3          	and	s1,s1,a5
4000a3b0:	40050593          	addi	a1,a0,1024
4000a3b4:	7fe00793          	li	a5,2046
4000a3b8:	d8b7c4e3          	blt	a5,a1,4000a140 <__muldf3+0x288>
4000a3bc:	00385813          	srli	a6,a6,0x3
4000a3c0:	01d49793          	slli	a5,s1,0x1d
4000a3c4:	00949413          	slli	s0,s1,0x9
4000a3c8:	0107eab3          	or	s5,a5,a6
4000a3cc:	00c45413          	srli	s0,s0,0xc
4000a3d0:	7ff5f593          	andi	a1,a1,2047
4000a3d4:	00167b13          	andi	s6,a2,1
4000a3d8:	c7dff06f          	j	4000a054 <__muldf3+0x19c>
4000a3dc:	00040493          	mv	s1,s0
4000a3e0:	000a8813          	mv	a6,s5
4000a3e4:	000c0693          	mv	a3,s8
4000a3e8:	c45ff06f          	j	4000a02c <__muldf3+0x174>
4000a3ec:	009464b3          	or	s1,s0,s1
4000a3f0:	00c49793          	slli	a5,s1,0xc
4000a3f4:	cc07c4e3          	bltz	a5,4000a0bc <__muldf3+0x204>
4000a3f8:	000807b7          	lui	a5,0x80
4000a3fc:	00f46433          	or	s0,s0,a5
4000a400:	001007b7          	lui	a5,0x100
4000a404:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000a408:	00f47433          	and	s0,s0,a5
4000a40c:	7ff00593          	li	a1,2047
4000a410:	c45ff06f          	j	4000a054 <__muldf3+0x19c>
4000a414:	fd850493          	addi	s1,a0,-40
4000a418:	009b94b3          	sll	s1,s7,s1
4000a41c:	00000813          	li	a6,0
4000a420:	bf9ff06f          	j	4000a018 <__muldf3+0x160>
4000a424:	000b8513          	mv	a0,s7
4000a428:	178010ef          	jal	ra,4000b5a0 <__clzsi2>
4000a42c:	02050513          	addi	a0,a0,32
4000a430:	bc1ff06f          	j	40009ff0 <__muldf3+0x138>
4000a434:	fd850413          	addi	s0,a0,-40
4000a438:	00891433          	sll	s0,s2,s0
4000a43c:	00000a93          	li	s5,0
4000a440:	cd9ff06f          	j	4000a118 <__muldf3+0x260>
4000a444:	15c010ef          	jal	ra,4000b5a0 <__clzsi2>
4000a448:	02050513          	addi	a0,a0,32
4000a44c:	00c12683          	lw	a3,12(sp)
4000a450:	ca1ff06f          	j	4000a0f0 <__muldf3+0x238>
4000a454:	00100713          	li	a4,1
4000a458:	06059863          	bnez	a1,4000a4c8 <__muldf3+0x610>
4000a45c:	02000793          	li	a5,32
4000a460:	40e787b3          	sub	a5,a5,a4
4000a464:	00f496b3          	sll	a3,s1,a5
4000a468:	00e855b3          	srl	a1,a6,a4
4000a46c:	00f817b3          	sll	a5,a6,a5
4000a470:	00f037b3          	snez	a5,a5
4000a474:	00b6e6b3          	or	a3,a3,a1
4000a478:	00f6e6b3          	or	a3,a3,a5
4000a47c:	0076f793          	andi	a5,a3,7
4000a480:	00e4d4b3          	srl	s1,s1,a4
4000a484:	02078063          	beqz	a5,4000a4a4 <__muldf3+0x5ec>
4000a488:	00f6f793          	andi	a5,a3,15
4000a48c:	00400713          	li	a4,4
4000a490:	00e78a63          	beq	a5,a4,4000a4a4 <__muldf3+0x5ec>
4000a494:	00068793          	mv	a5,a3
4000a498:	00478693          	addi	a3,a5,4
4000a49c:	00f6b7b3          	sltu	a5,a3,a5
4000a4a0:	00f484b3          	add	s1,s1,a5
4000a4a4:	00849793          	slli	a5,s1,0x8
4000a4a8:	0807dc63          	bgez	a5,4000a540 <__muldf3+0x688>
4000a4ac:	00167b13          	andi	s6,a2,1
4000a4b0:	00100593          	li	a1,1
4000a4b4:	00000413          	li	s0,0
4000a4b8:	00000a93          	li	s5,0
4000a4bc:	b99ff06f          	j	4000a054 <__muldf3+0x19c>
4000a4c0:	00058513          	mv	a0,a1
4000a4c4:	eadff06f          	j	4000a370 <__muldf3+0x4b8>
4000a4c8:	40b70733          	sub	a4,a4,a1
4000a4cc:	03800793          	li	a5,56
4000a4d0:	00e7dc63          	ble	a4,a5,4000a4e8 <__muldf3+0x630>
4000a4d4:	00167b13          	andi	s6,a2,1
4000a4d8:	00000593          	li	a1,0
4000a4dc:	00000413          	li	s0,0
4000a4e0:	00000a93          	li	s5,0
4000a4e4:	b71ff06f          	j	4000a054 <__muldf3+0x19c>
4000a4e8:	01f00793          	li	a5,31
4000a4ec:	f6e7d8e3          	ble	a4,a5,4000a45c <__muldf3+0x5a4>
4000a4f0:	fe100793          	li	a5,-31
4000a4f4:	40b787b3          	sub	a5,a5,a1
4000a4f8:	02000593          	li	a1,32
4000a4fc:	00f4d7b3          	srl	a5,s1,a5
4000a500:	00000693          	li	a3,0
4000a504:	00b70863          	beq	a4,a1,4000a514 <__muldf3+0x65c>
4000a508:	04000693          	li	a3,64
4000a50c:	40e68733          	sub	a4,a3,a4
4000a510:	00e496b3          	sll	a3,s1,a4
4000a514:	0106e733          	or	a4,a3,a6
4000a518:	00e03733          	snez	a4,a4
4000a51c:	00e7e7b3          	or	a5,a5,a4
4000a520:	0077f493          	andi	s1,a5,7
4000a524:	00000413          	li	s0,0
4000a528:	02048463          	beqz	s1,4000a550 <__muldf3+0x698>
4000a52c:	00f7f713          	andi	a4,a5,15
4000a530:	00400693          	li	a3,4
4000a534:	00000493          	li	s1,0
4000a538:	f6d710e3          	bne	a4,a3,4000a498 <__muldf3+0x5e0>
4000a53c:	00078693          	mv	a3,a5
4000a540:	00949413          	slli	s0,s1,0x9
4000a544:	00c45413          	srli	s0,s0,0xc
4000a548:	01d49493          	slli	s1,s1,0x1d
4000a54c:	00068793          	mv	a5,a3
4000a550:	0037d793          	srli	a5,a5,0x3
4000a554:	0097eab3          	or	s5,a5,s1
4000a558:	00167b13          	andi	s6,a2,1
4000a55c:	00000593          	li	a1,0
4000a560:	af5ff06f          	j	4000a054 <__muldf3+0x19c>
4000a564:	000807b7          	lui	a5,0x80
4000a568:	00f4e433          	or	s0,s1,a5
4000a56c:	001007b7          	lui	a5,0x100
4000a570:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000a574:	00f47433          	and	s0,s0,a5
4000a578:	00167b13          	andi	s6,a2,1
4000a57c:	00080a93          	mv	s5,a6
4000a580:	7ff00593          	li	a1,2047
4000a584:	ad1ff06f          	j	4000a054 <__muldf3+0x19c>

4000a588 <__subdf3>:
4000a588:	00100737          	lui	a4,0x100
4000a58c:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000a590:	fe010113          	addi	sp,sp,-32
4000a594:	00b777b3          	and	a5,a4,a1
4000a598:	00d778b3          	and	a7,a4,a3
4000a59c:	0146de13          	srli	t3,a3,0x14
4000a5a0:	00379313          	slli	t1,a5,0x3
4000a5a4:	01d65e93          	srli	t4,a2,0x1d
4000a5a8:	00912a23          	sw	s1,20(sp)
4000a5ac:	01212823          	sw	s2,16(sp)
4000a5b0:	0145d713          	srli	a4,a1,0x14
4000a5b4:	01f5d813          	srli	a6,a1,0x1f
4000a5b8:	01d55793          	srli	a5,a0,0x1d
4000a5bc:	00389893          	slli	a7,a7,0x3
4000a5c0:	7ff00f13          	li	t5,2047
4000a5c4:	00112e23          	sw	ra,28(sp)
4000a5c8:	00812c23          	sw	s0,24(sp)
4000a5cc:	01312623          	sw	s3,12(sp)
4000a5d0:	7ffe7e13          	andi	t3,t3,2047
4000a5d4:	0067e7b3          	or	a5,a5,t1
4000a5d8:	01e774b3          	and	s1,a4,t5
4000a5dc:	00080913          	mv	s2,a6
4000a5e0:	00351313          	slli	t1,a0,0x3
4000a5e4:	01f6d693          	srli	a3,a3,0x1f
4000a5e8:	011ee8b3          	or	a7,t4,a7
4000a5ec:	00361613          	slli	a2,a2,0x3
4000a5f0:	0bee0a63          	beq	t3,t5,4000a6a4 <__subdf3+0x11c>
4000a5f4:	0016c693          	xori	a3,a3,1
4000a5f8:	11068263          	beq	a3,a6,4000a6fc <__subdf3+0x174>
4000a5fc:	41c48eb3          	sub	t4,s1,t3
4000a600:	31d05663          	blez	t4,4000a90c <__subdf3+0x384>
4000a604:	0a0e1863          	bnez	t3,4000a6b4 <__subdf3+0x12c>
4000a608:	00c8e733          	or	a4,a7,a2
4000a60c:	10071a63          	bnez	a4,4000a720 <__subdf3+0x198>
4000a610:	7ff00713          	li	a4,2047
4000a614:	000e8493          	mv	s1,t4
4000a618:	3eee8063          	beq	t4,a4,4000a9f8 <__subdf3+0x470>
4000a61c:	00879713          	slli	a4,a5,0x8
4000a620:	1c075863          	bgez	a4,4000a7f0 <__subdf3+0x268>
4000a624:	00148713          	addi	a4,s1,1
4000a628:	7ff00693          	li	a3,2047
4000a62c:	36d70463          	beq	a4,a3,4000a994 <__subdf3+0x40c>
4000a630:	ff8006b7          	lui	a3,0xff800
4000a634:	fff68693          	addi	a3,a3,-1 # ff7fffff <_bss_end+0xbf7f3977>
4000a638:	00d7f7b3          	and	a5,a5,a3
4000a63c:	01d79693          	slli	a3,a5,0x1d
4000a640:	00335313          	srli	t1,t1,0x3
4000a644:	00979793          	slli	a5,a5,0x9
4000a648:	0066e533          	or	a0,a3,t1
4000a64c:	00c7d793          	srli	a5,a5,0xc
4000a650:	7ff77713          	andi	a4,a4,2047
4000a654:	001005b7          	lui	a1,0x100
4000a658:	fff58593          	addi	a1,a1,-1 # fffff <_heap_size+0xfdfff>
4000a65c:	00b7f7b3          	and	a5,a5,a1
4000a660:	801005b7          	lui	a1,0x80100
4000a664:	fff58593          	addi	a1,a1,-1 # 800fffff <_bss_end+0x400f3977>
4000a668:	00b7f5b3          	and	a1,a5,a1
4000a66c:	01471713          	slli	a4,a4,0x14
4000a670:	800007b7          	lui	a5,0x80000
4000a674:	01c12083          	lw	ra,28(sp)
4000a678:	00e5e5b3          	or	a1,a1,a4
4000a67c:	fff7c793          	not	a5,a5
4000a680:	01f81813          	slli	a6,a6,0x1f
4000a684:	00f5f5b3          	and	a1,a1,a5
4000a688:	0105e5b3          	or	a1,a1,a6
4000a68c:	01812403          	lw	s0,24(sp)
4000a690:	01412483          	lw	s1,20(sp)
4000a694:	01012903          	lw	s2,16(sp)
4000a698:	00c12983          	lw	s3,12(sp)
4000a69c:	02010113          	addi	sp,sp,32
4000a6a0:	00008067          	ret
4000a6a4:	00c8e733          	or	a4,a7,a2
4000a6a8:	f40718e3          	bnez	a4,4000a5f8 <__subdf3+0x70>
4000a6ac:	0016c693          	xori	a3,a3,1
4000a6b0:	f49ff06f          	j	4000a5f8 <__subdf3+0x70>
4000a6b4:	008006b7          	lui	a3,0x800
4000a6b8:	7ff00713          	li	a4,2047
4000a6bc:	00d8e8b3          	or	a7,a7,a3
4000a6c0:	22e48263          	beq	s1,a4,4000a8e4 <__subdf3+0x35c>
4000a6c4:	03800713          	li	a4,56
4000a6c8:	17d74263          	blt	a4,t4,4000a82c <__subdf3+0x2a4>
4000a6cc:	01f00713          	li	a4,31
4000a6d0:	37d74863          	blt	a4,t4,4000aa40 <__subdf3+0x4b8>
4000a6d4:	02000713          	li	a4,32
4000a6d8:	41d70733          	sub	a4,a4,t4
4000a6dc:	01d656b3          	srl	a3,a2,t4
4000a6e0:	00e899b3          	sll	s3,a7,a4
4000a6e4:	00e61633          	sll	a2,a2,a4
4000a6e8:	00d9e9b3          	or	s3,s3,a3
4000a6ec:	00c036b3          	snez	a3,a2
4000a6f0:	00d9e6b3          	or	a3,s3,a3
4000a6f4:	01d8deb3          	srl	t4,a7,t4
4000a6f8:	1400006f          	j	4000a838 <__subdf3+0x2b0>
4000a6fc:	41c48733          	sub	a4,s1,t3
4000a700:	2ae05063          	blez	a4,4000a9a0 <__subdf3+0x418>
4000a704:	160e1663          	bnez	t3,4000a870 <__subdf3+0x2e8>
4000a708:	00c8e6b3          	or	a3,a7,a2
4000a70c:	3e069263          	bnez	a3,4000aaf0 <__subdf3+0x568>
4000a710:	7ff00693          	li	a3,2047
4000a714:	4ad70e63          	beq	a4,a3,4000abd0 <__subdf3+0x648>
4000a718:	00070493          	mv	s1,a4
4000a71c:	f01ff06f          	j	4000a61c <__subdf3+0x94>
4000a720:	fffe8713          	addi	a4,t4,-1
4000a724:	2c071263          	bnez	a4,4000a9e8 <__subdf3+0x460>
4000a728:	40c309b3          	sub	s3,t1,a2
4000a72c:	411787b3          	sub	a5,a5,a7
4000a730:	01333333          	sltu	t1,t1,s3
4000a734:	406787b3          	sub	a5,a5,t1
4000a738:	00100493          	li	s1,1
4000a73c:	00879713          	slli	a4,a5,0x8
4000a740:	10075863          	bgez	a4,4000a850 <__subdf3+0x2c8>
4000a744:	00800637          	lui	a2,0x800
4000a748:	fff60613          	addi	a2,a2,-1 # 7fffff <_heap_size+0x7fdfff>
4000a74c:	00c7f433          	and	s0,a5,a2
4000a750:	20040063          	beqz	s0,4000a950 <__subdf3+0x3c8>
4000a754:	00040513          	mv	a0,s0
4000a758:	649000ef          	jal	ra,4000b5a0 <__clzsi2>
4000a75c:	ff850713          	addi	a4,a0,-8
4000a760:	01f00793          	li	a5,31
4000a764:	20e7c263          	blt	a5,a4,4000a968 <__subdf3+0x3e0>
4000a768:	02000793          	li	a5,32
4000a76c:	40e787b3          	sub	a5,a5,a4
4000a770:	00f9d7b3          	srl	a5,s3,a5
4000a774:	00e41633          	sll	a2,s0,a4
4000a778:	00c7e7b3          	or	a5,a5,a2
4000a77c:	00e999b3          	sll	s3,s3,a4
4000a780:	1e974c63          	blt	a4,s1,4000a978 <__subdf3+0x3f0>
4000a784:	40970733          	sub	a4,a4,s1
4000a788:	00170613          	addi	a2,a4,1
4000a78c:	01f00693          	li	a3,31
4000a790:	26c6cc63          	blt	a3,a2,4000aa08 <__subdf3+0x480>
4000a794:	02000713          	li	a4,32
4000a798:	40c70733          	sub	a4,a4,a2
4000a79c:	00e996b3          	sll	a3,s3,a4
4000a7a0:	00c9d5b3          	srl	a1,s3,a2
4000a7a4:	00e79733          	sll	a4,a5,a4
4000a7a8:	00b76733          	or	a4,a4,a1
4000a7ac:	00d036b3          	snez	a3,a3
4000a7b0:	00d769b3          	or	s3,a4,a3
4000a7b4:	00c7d7b3          	srl	a5,a5,a2
4000a7b8:	0079f713          	andi	a4,s3,7
4000a7bc:	00197813          	andi	a6,s2,1
4000a7c0:	00000493          	li	s1,0
4000a7c4:	00098313          	mv	t1,s3
4000a7c8:	e4070ae3          	beqz	a4,4000a61c <__subdf3+0x94>
4000a7cc:	00f9f713          	andi	a4,s3,15
4000a7d0:	00400693          	li	a3,4
4000a7d4:	00098313          	mv	t1,s3
4000a7d8:	e4d702e3          	beq	a4,a3,4000a61c <__subdf3+0x94>
4000a7dc:	00d98333          	add	t1,s3,a3
4000a7e0:	013336b3          	sltu	a3,t1,s3
4000a7e4:	00d787b3          	add	a5,a5,a3
4000a7e8:	00879713          	slli	a4,a5,0x8
4000a7ec:	e2074ce3          	bltz	a4,4000a624 <__subdf3+0x9c>
4000a7f0:	00335693          	srli	a3,t1,0x3
4000a7f4:	7ff00713          	li	a4,2047
4000a7f8:	01d79313          	slli	t1,a5,0x1d
4000a7fc:	0066e533          	or	a0,a3,t1
4000a800:	0037d793          	srli	a5,a5,0x3
4000a804:	0ee49a63          	bne	s1,a4,4000a8f8 <__subdf3+0x370>
4000a808:	00f56733          	or	a4,a0,a5
4000a80c:	5a070e63          	beqz	a4,4000adc8 <__subdf3+0x840>
4000a810:	00080737          	lui	a4,0x80
4000a814:	00e7e7b3          	or	a5,a5,a4
4000a818:	00100737          	lui	a4,0x100
4000a81c:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000a820:	00e7f7b3          	and	a5,a5,a4
4000a824:	00048713          	mv	a4,s1
4000a828:	e2dff06f          	j	4000a654 <__subdf3+0xcc>
4000a82c:	00c8e633          	or	a2,a7,a2
4000a830:	00c036b3          	snez	a3,a2
4000a834:	00000e93          	li	t4,0
4000a838:	40d309b3          	sub	s3,t1,a3
4000a83c:	41d787b3          	sub	a5,a5,t4
4000a840:	01333333          	sltu	t1,t1,s3
4000a844:	406787b3          	sub	a5,a5,t1
4000a848:	00879713          	slli	a4,a5,0x8
4000a84c:	ee074ce3          	bltz	a4,4000a744 <__subdf3+0x1bc>
4000a850:	0079f713          	andi	a4,s3,7
4000a854:	00197813          	andi	a6,s2,1
4000a858:	f6071ae3          	bnez	a4,4000a7cc <__subdf3+0x244>
4000a85c:	01d79313          	slli	t1,a5,0x1d
4000a860:	0039d693          	srli	a3,s3,0x3
4000a864:	0066e533          	or	a0,a3,t1
4000a868:	0037d793          	srli	a5,a5,0x3
4000a86c:	0840006f          	j	4000a8f0 <__subdf3+0x368>
4000a870:	008005b7          	lui	a1,0x800
4000a874:	7ff00693          	li	a3,2047
4000a878:	00b8e8b3          	or	a7,a7,a1
4000a87c:	06d48463          	beq	s1,a3,4000a8e4 <__subdf3+0x35c>
4000a880:	03800693          	li	a3,56
4000a884:	28e6dc63          	ble	a4,a3,4000ab1c <__subdf3+0x594>
4000a888:	00c8e633          	or	a2,a7,a2
4000a88c:	00c036b3          	snez	a3,a2
4000a890:	00000893          	li	a7,0
4000a894:	006689b3          	add	s3,a3,t1
4000a898:	00f887b3          	add	a5,a7,a5
4000a89c:	0069b333          	sltu	t1,s3,t1
4000a8a0:	006787b3          	add	a5,a5,t1
4000a8a4:	00879713          	slli	a4,a5,0x8
4000a8a8:	fa0754e3          	bgez	a4,4000a850 <__subdf3+0x2c8>
4000a8ac:	00148493          	addi	s1,s1,1
4000a8b0:	7ff00713          	li	a4,2047
4000a8b4:	3ce48463          	beq	s1,a4,4000ac7c <__subdf3+0x6f4>
4000a8b8:	ff800737          	lui	a4,0xff800
4000a8bc:	fff70713          	addi	a4,a4,-1 # ff7fffff <_bss_end+0xbf7f3977>
4000a8c0:	00e7f7b3          	and	a5,a5,a4
4000a8c4:	0019f693          	andi	a3,s3,1
4000a8c8:	0019d713          	srli	a4,s3,0x1
4000a8cc:	00d766b3          	or	a3,a4,a3
4000a8d0:	01f79993          	slli	s3,a5,0x1f
4000a8d4:	00d9e9b3          	or	s3,s3,a3
4000a8d8:	0017d793          	srli	a5,a5,0x1
4000a8dc:	0079f713          	andi	a4,s3,7
4000a8e0:	ee5ff06f          	j	4000a7c4 <__subdf3+0x23c>
4000a8e4:	0067e533          	or	a0,a5,t1
4000a8e8:	d2051ae3          	bnez	a0,4000a61c <__subdf3+0x94>
4000a8ec:	00000793          	li	a5,0
4000a8f0:	7ff00713          	li	a4,2047
4000a8f4:	f0e48ae3          	beq	s1,a4,4000a808 <__subdf3+0x280>
4000a8f8:	00100737          	lui	a4,0x100
4000a8fc:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000a900:	00e7f7b3          	and	a5,a5,a4
4000a904:	7ff4f713          	andi	a4,s1,2047
4000a908:	d4dff06f          	j	4000a654 <__subdf3+0xcc>
4000a90c:	160e9263          	bnez	t4,4000aa70 <__subdf3+0x4e8>
4000a910:	00148713          	addi	a4,s1,1
4000a914:	7ff77713          	andi	a4,a4,2047
4000a918:	00100593          	li	a1,1
4000a91c:	2ce5d463          	ble	a4,a1,4000abe4 <__subdf3+0x65c>
4000a920:	40c309b3          	sub	s3,t1,a2
4000a924:	01333733          	sltu	a4,t1,s3
4000a928:	41178433          	sub	s0,a5,a7
4000a92c:	40e40433          	sub	s0,s0,a4
4000a930:	00841713          	slli	a4,s0,0x8
4000a934:	1a075263          	bgez	a4,4000aad8 <__subdf3+0x550>
4000a938:	406609b3          	sub	s3,a2,t1
4000a93c:	40f887b3          	sub	a5,a7,a5
4000a940:	01363633          	sltu	a2,a2,s3
4000a944:	40c78433          	sub	s0,a5,a2
4000a948:	00068913          	mv	s2,a3
4000a94c:	e00414e3          	bnez	s0,4000a754 <__subdf3+0x1cc>
4000a950:	00098513          	mv	a0,s3
4000a954:	44d000ef          	jal	ra,4000b5a0 <__clzsi2>
4000a958:	02050513          	addi	a0,a0,32
4000a95c:	ff850713          	addi	a4,a0,-8
4000a960:	01f00793          	li	a5,31
4000a964:	e0e7d2e3          	ble	a4,a5,4000a768 <__subdf3+0x1e0>
4000a968:	fd850793          	addi	a5,a0,-40
4000a96c:	00f997b3          	sll	a5,s3,a5
4000a970:	00000993          	li	s3,0
4000a974:	e09758e3          	ble	s1,a4,4000a784 <__subdf3+0x1fc>
4000a978:	40e484b3          	sub	s1,s1,a4
4000a97c:	ff800737          	lui	a4,0xff800
4000a980:	fff70713          	addi	a4,a4,-1 # ff7fffff <_bss_end+0xbf7f3977>
4000a984:	00e7f7b3          	and	a5,a5,a4
4000a988:	00197813          	andi	a6,s2,1
4000a98c:	0079f713          	andi	a4,s3,7
4000a990:	e35ff06f          	j	4000a7c4 <__subdf3+0x23c>
4000a994:	00000793          	li	a5,0
4000a998:	00000513          	li	a0,0
4000a99c:	cb9ff06f          	j	4000a654 <__subdf3+0xcc>
4000a9a0:	28071c63          	bnez	a4,4000ac38 <__subdf3+0x6b0>
4000a9a4:	00148593          	addi	a1,s1,1
4000a9a8:	7ff5f713          	andi	a4,a1,2047
4000a9ac:	00100693          	li	a3,1
4000a9b0:	1ce6de63          	ble	a4,a3,4000ab8c <__subdf3+0x604>
4000a9b4:	7ff00713          	li	a4,2047
4000a9b8:	32e58263          	beq	a1,a4,4000acdc <__subdf3+0x754>
4000a9bc:	00c30633          	add	a2,t1,a2
4000a9c0:	00663333          	sltu	t1,a2,t1
4000a9c4:	011787b3          	add	a5,a5,a7
4000a9c8:	006787b3          	add	a5,a5,t1
4000a9cc:	01f79693          	slli	a3,a5,0x1f
4000a9d0:	00165613          	srli	a2,a2,0x1
4000a9d4:	00c6e9b3          	or	s3,a3,a2
4000a9d8:	0017d793          	srli	a5,a5,0x1
4000a9dc:	0079f713          	andi	a4,s3,7
4000a9e0:	00058493          	mv	s1,a1
4000a9e4:	de1ff06f          	j	4000a7c4 <__subdf3+0x23c>
4000a9e8:	7ff00693          	li	a3,2047
4000a9ec:	00de8663          	beq	t4,a3,4000a9f8 <__subdf3+0x470>
4000a9f0:	00070e93          	mv	t4,a4
4000a9f4:	cd1ff06f          	j	4000a6c4 <__subdf3+0x13c>
4000a9f8:	0067e533          	or	a0,a5,t1
4000a9fc:	14050863          	beqz	a0,4000ab4c <__subdf3+0x5c4>
4000aa00:	7ff00493          	li	s1,2047
4000aa04:	c19ff06f          	j	4000a61c <__subdf3+0x94>
4000aa08:	fe170713          	addi	a4,a4,-31
4000aa0c:	02000593          	li	a1,32
4000aa10:	00e7d733          	srl	a4,a5,a4
4000aa14:	00000693          	li	a3,0
4000aa18:	00b60863          	beq	a2,a1,4000aa28 <__subdf3+0x4a0>
4000aa1c:	04000693          	li	a3,64
4000aa20:	40c686b3          	sub	a3,a3,a2
4000aa24:	00d796b3          	sll	a3,a5,a3
4000aa28:	00d9e6b3          	or	a3,s3,a3
4000aa2c:	00d036b3          	snez	a3,a3
4000aa30:	00d769b3          	or	s3,a4,a3
4000aa34:	00000793          	li	a5,0
4000aa38:	00000493          	li	s1,0
4000aa3c:	e15ff06f          	j	4000a850 <__subdf3+0x2c8>
4000aa40:	02000693          	li	a3,32
4000aa44:	01d8d9b3          	srl	s3,a7,t4
4000aa48:	00000713          	li	a4,0
4000aa4c:	00de8863          	beq	t4,a3,4000aa5c <__subdf3+0x4d4>
4000aa50:	04000713          	li	a4,64
4000aa54:	41d70eb3          	sub	t4,a4,t4
4000aa58:	01d89733          	sll	a4,a7,t4
4000aa5c:	00c76633          	or	a2,a4,a2
4000aa60:	00c036b3          	snez	a3,a2
4000aa64:	00d9e6b3          	or	a3,s3,a3
4000aa68:	00000e93          	li	t4,0
4000aa6c:	dcdff06f          	j	4000a838 <__subdf3+0x2b0>
4000aa70:	0e048463          	beqz	s1,4000ab58 <__subdf3+0x5d0>
4000aa74:	008005b7          	lui	a1,0x800
4000aa78:	7ff00713          	li	a4,2047
4000aa7c:	41d00eb3          	neg	t4,t4
4000aa80:	00b7e7b3          	or	a5,a5,a1
4000aa84:	22ee0863          	beq	t3,a4,4000acb4 <__subdf3+0x72c>
4000aa88:	03800713          	li	a4,56
4000aa8c:	25d74063          	blt	a4,t4,4000accc <__subdf3+0x744>
4000aa90:	01f00713          	li	a4,31
4000aa94:	3bd74063          	blt	a4,t4,4000ae34 <__subdf3+0x8ac>
4000aa98:	02000713          	li	a4,32
4000aa9c:	41d70733          	sub	a4,a4,t4
4000aaa0:	00e799b3          	sll	s3,a5,a4
4000aaa4:	01d355b3          	srl	a1,t1,t4
4000aaa8:	00e31733          	sll	a4,t1,a4
4000aaac:	00b9e9b3          	or	s3,s3,a1
4000aab0:	00e03733          	snez	a4,a4
4000aab4:	00e9e9b3          	or	s3,s3,a4
4000aab8:	01d7deb3          	srl	t4,a5,t4
4000aabc:	413609b3          	sub	s3,a2,s3
4000aac0:	41d887b3          	sub	a5,a7,t4
4000aac4:	01363633          	sltu	a2,a2,s3
4000aac8:	40c787b3          	sub	a5,a5,a2
4000aacc:	000e0493          	mv	s1,t3
4000aad0:	00068913          	mv	s2,a3
4000aad4:	c69ff06f          	j	4000a73c <__subdf3+0x1b4>
4000aad8:	0089e533          	or	a0,s3,s0
4000aadc:	c6051ae3          	bnez	a0,4000a750 <__subdf3+0x1c8>
4000aae0:	00000793          	li	a5,0
4000aae4:	00000813          	li	a6,0
4000aae8:	00000493          	li	s1,0
4000aaec:	e05ff06f          	j	4000a8f0 <__subdf3+0x368>
4000aaf0:	fff70693          	addi	a3,a4,-1
4000aaf4:	08069463          	bnez	a3,4000ab7c <__subdf3+0x5f4>
4000aaf8:	00c309b3          	add	s3,t1,a2
4000aafc:	011787b3          	add	a5,a5,a7
4000ab00:	0069b333          	sltu	t1,s3,t1
4000ab04:	006787b3          	add	a5,a5,t1
4000ab08:	00879713          	slli	a4,a5,0x8
4000ab0c:	00100493          	li	s1,1
4000ab10:	d40750e3          	bgez	a4,4000a850 <__subdf3+0x2c8>
4000ab14:	00200493          	li	s1,2
4000ab18:	da1ff06f          	j	4000a8b8 <__subdf3+0x330>
4000ab1c:	01f00693          	li	a3,31
4000ab20:	0ee6c463          	blt	a3,a4,4000ac08 <__subdf3+0x680>
4000ab24:	02000593          	li	a1,32
4000ab28:	40e585b3          	sub	a1,a1,a4
4000ab2c:	00b896b3          	sll	a3,a7,a1
4000ab30:	00e65533          	srl	a0,a2,a4
4000ab34:	00b61633          	sll	a2,a2,a1
4000ab38:	00a6e6b3          	or	a3,a3,a0
4000ab3c:	00c039b3          	snez	s3,a2
4000ab40:	0136e6b3          	or	a3,a3,s3
4000ab44:	00e8d8b3          	srl	a7,a7,a4
4000ab48:	d4dff06f          	j	4000a894 <__subdf3+0x30c>
4000ab4c:	00000793          	li	a5,0
4000ab50:	000e8493          	mv	s1,t4
4000ab54:	d9dff06f          	j	4000a8f0 <__subdf3+0x368>
4000ab58:	0067e733          	or	a4,a5,t1
4000ab5c:	12071663          	bnez	a4,4000ac88 <__subdf3+0x700>
4000ab60:	7ff00793          	li	a5,2047
4000ab64:	14fe0863          	beq	t3,a5,4000acb4 <__subdf3+0x72c>
4000ab68:	00068813          	mv	a6,a3
4000ab6c:	00088793          	mv	a5,a7
4000ab70:	00060313          	mv	t1,a2
4000ab74:	000e0493          	mv	s1,t3
4000ab78:	aa5ff06f          	j	4000a61c <__subdf3+0x94>
4000ab7c:	7ff00593          	li	a1,2047
4000ab80:	04b70863          	beq	a4,a1,4000abd0 <__subdf3+0x648>
4000ab84:	00068713          	mv	a4,a3
4000ab88:	cf9ff06f          	j	4000a880 <__subdf3+0x2f8>
4000ab8c:	0067e733          	or	a4,a5,t1
4000ab90:	24049463          	bnez	s1,4000add8 <__subdf3+0x850>
4000ab94:	06070463          	beqz	a4,4000abfc <__subdf3+0x674>
4000ab98:	00c8e733          	or	a4,a7,a2
4000ab9c:	a80700e3          	beqz	a4,4000a61c <__subdf3+0x94>
4000aba0:	00c309b3          	add	s3,t1,a2
4000aba4:	011787b3          	add	a5,a5,a7
4000aba8:	0069b333          	sltu	t1,s3,t1
4000abac:	006787b3          	add	a5,a5,t1
4000abb0:	00879713          	slli	a4,a5,0x8
4000abb4:	c8075ee3          	bgez	a4,4000a850 <__subdf3+0x2c8>
4000abb8:	ff800737          	lui	a4,0xff800
4000abbc:	fff70713          	addi	a4,a4,-1 # ff7fffff <_bss_end+0xbf7f3977>
4000abc0:	00e7f7b3          	and	a5,a5,a4
4000abc4:	00068493          	mv	s1,a3
4000abc8:	0079f713          	andi	a4,s3,7
4000abcc:	bf9ff06f          	j	4000a7c4 <__subdf3+0x23c>
4000abd0:	0067e533          	or	a0,a5,t1
4000abd4:	b40512e3          	bnez	a0,4000a718 <__subdf3+0x190>
4000abd8:	00000793          	li	a5,0
4000abdc:	00070493          	mv	s1,a4
4000abe0:	d11ff06f          	j	4000a8f0 <__subdf3+0x368>
4000abe4:	0067e733          	or	a4,a5,t1
4000abe8:	06049a63          	bnez	s1,4000ac5c <__subdf3+0x6d4>
4000abec:	16071063          	bnez	a4,4000ad4c <__subdf3+0x7c4>
4000abf0:	00c8e533          	or	a0,a7,a2
4000abf4:	22050a63          	beqz	a0,4000ae28 <__subdf3+0x8a0>
4000abf8:	00068813          	mv	a6,a3
4000abfc:	00088793          	mv	a5,a7
4000ac00:	00060313          	mv	t1,a2
4000ac04:	a19ff06f          	j	4000a61c <__subdf3+0x94>
4000ac08:	02000513          	li	a0,32
4000ac0c:	00e8d6b3          	srl	a3,a7,a4
4000ac10:	00000593          	li	a1,0
4000ac14:	00a70863          	beq	a4,a0,4000ac24 <__subdf3+0x69c>
4000ac18:	04000593          	li	a1,64
4000ac1c:	40e58733          	sub	a4,a1,a4
4000ac20:	00e895b3          	sll	a1,a7,a4
4000ac24:	00c5e633          	or	a2,a1,a2
4000ac28:	00c039b3          	snez	s3,a2
4000ac2c:	0136e6b3          	or	a3,a3,s3
4000ac30:	00000893          	li	a7,0
4000ac34:	c61ff06f          	j	4000a894 <__subdf3+0x30c>
4000ac38:	0a049a63          	bnez	s1,4000acec <__subdf3+0x764>
4000ac3c:	0067e6b3          	or	a3,a5,t1
4000ac40:	22069263          	bnez	a3,4000ae64 <__subdf3+0x8dc>
4000ac44:	7ff00793          	li	a5,2047
4000ac48:	24fe0263          	beq	t3,a5,4000ae8c <__subdf3+0x904>
4000ac4c:	00088793          	mv	a5,a7
4000ac50:	00060313          	mv	t1,a2
4000ac54:	000e0493          	mv	s1,t3
4000ac58:	9c5ff06f          	j	4000a61c <__subdf3+0x94>
4000ac5c:	12071663          	bnez	a4,4000ad88 <__subdf3+0x800>
4000ac60:	00c8e7b3          	or	a5,a7,a2
4000ac64:	22078a63          	beqz	a5,4000ae98 <__subdf3+0x910>
4000ac68:	00068813          	mv	a6,a3
4000ac6c:	00088793          	mv	a5,a7
4000ac70:	00060313          	mv	t1,a2
4000ac74:	7ff00493          	li	s1,2047
4000ac78:	9a5ff06f          	j	4000a61c <__subdf3+0x94>
4000ac7c:	00000793          	li	a5,0
4000ac80:	00000513          	li	a0,0
4000ac84:	c6dff06f          	j	4000a8f0 <__subdf3+0x368>
4000ac88:	fffece93          	not	t4,t4
4000ac8c:	020e9063          	bnez	t4,4000acac <__subdf3+0x724>
4000ac90:	406609b3          	sub	s3,a2,t1
4000ac94:	40f887b3          	sub	a5,a7,a5
4000ac98:	01363633          	sltu	a2,a2,s3
4000ac9c:	40c787b3          	sub	a5,a5,a2
4000aca0:	000e0493          	mv	s1,t3
4000aca4:	00068913          	mv	s2,a3
4000aca8:	a95ff06f          	j	4000a73c <__subdf3+0x1b4>
4000acac:	7ff00713          	li	a4,2047
4000acb0:	dcee1ce3          	bne	t3,a4,4000aa88 <__subdf3+0x500>
4000acb4:	00c8e533          	or	a0,a7,a2
4000acb8:	00068813          	mv	a6,a3
4000acbc:	f80518e3          	bnez	a0,4000ac4c <__subdf3+0x6c4>
4000acc0:	00000793          	li	a5,0
4000acc4:	000e0493          	mv	s1,t3
4000acc8:	c29ff06f          	j	4000a8f0 <__subdf3+0x368>
4000accc:	0067e9b3          	or	s3,a5,t1
4000acd0:	013039b3          	snez	s3,s3
4000acd4:	00000e93          	li	t4,0
4000acd8:	de5ff06f          	j	4000aabc <__subdf3+0x534>
4000acdc:	00058493          	mv	s1,a1
4000ace0:	00000793          	li	a5,0
4000ace4:	00000513          	li	a0,0
4000ace8:	c09ff06f          	j	4000a8f0 <__subdf3+0x368>
4000acec:	008005b7          	lui	a1,0x800
4000acf0:	7ff00693          	li	a3,2047
4000acf4:	40e00733          	neg	a4,a4
4000acf8:	00b7e7b3          	or	a5,a5,a1
4000acfc:	18de0863          	beq	t3,a3,4000ae8c <__subdf3+0x904>
4000ad00:	03800693          	li	a3,56
4000ad04:	1ae6c663          	blt	a3,a4,4000aeb0 <__subdf3+0x928>
4000ad08:	01f00693          	li	a3,31
4000ad0c:	1ce6c663          	blt	a3,a4,4000aed8 <__subdf3+0x950>
4000ad10:	02000593          	li	a1,32
4000ad14:	40e585b3          	sub	a1,a1,a4
4000ad18:	00b796b3          	sll	a3,a5,a1
4000ad1c:	00e35533          	srl	a0,t1,a4
4000ad20:	00b315b3          	sll	a1,t1,a1
4000ad24:	00a6e6b3          	or	a3,a3,a0
4000ad28:	00b039b3          	snez	s3,a1
4000ad2c:	0136e6b3          	or	a3,a3,s3
4000ad30:	00e7d7b3          	srl	a5,a5,a4
4000ad34:	00c689b3          	add	s3,a3,a2
4000ad38:	011787b3          	add	a5,a5,a7
4000ad3c:	00c9b633          	sltu	a2,s3,a2
4000ad40:	00c787b3          	add	a5,a5,a2
4000ad44:	000e0493          	mv	s1,t3
4000ad48:	b5dff06f          	j	4000a8a4 <__subdf3+0x31c>
4000ad4c:	00c8e733          	or	a4,a7,a2
4000ad50:	8c0706e3          	beqz	a4,4000a61c <__subdf3+0x94>
4000ad54:	40c309b3          	sub	s3,t1,a2
4000ad58:	013335b3          	sltu	a1,t1,s3
4000ad5c:	41178733          	sub	a4,a5,a7
4000ad60:	40b70733          	sub	a4,a4,a1
4000ad64:	00871593          	slli	a1,a4,0x8
4000ad68:	0a05da63          	bgez	a1,4000ae1c <__subdf3+0x894>
4000ad6c:	406609b3          	sub	s3,a2,t1
4000ad70:	40f887b3          	sub	a5,a7,a5
4000ad74:	01363633          	sltu	a2,a2,s3
4000ad78:	40c787b3          	sub	a5,a5,a2
4000ad7c:	0079f713          	andi	a4,s3,7
4000ad80:	00068813          	mv	a6,a3
4000ad84:	a41ff06f          	j	4000a7c4 <__subdf3+0x23c>
4000ad88:	00c8e633          	or	a2,a7,a2
4000ad8c:	c6060ae3          	beqz	a2,4000aa00 <__subdf3+0x478>
4000ad90:	00f8e8b3          	or	a7,a7,a5
4000ad94:	00989713          	slli	a4,a7,0x9
4000ad98:	12074463          	bltz	a4,4000aec0 <__subdf3+0x938>
4000ad9c:	20000737          	lui	a4,0x20000
4000ada0:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
4000ada4:	01d79313          	slli	t1,a5,0x1d
4000ada8:	00a77533          	and	a0,a4,a0
4000adac:	00a36533          	or	a0,t1,a0
4000adb0:	ff87f793          	andi	a5,a5,-8
4000adb4:	01d55713          	srli	a4,a0,0x1d
4000adb8:	00e7e7b3          	or	a5,a5,a4
4000adbc:	00351313          	slli	t1,a0,0x3
4000adc0:	7ff00493          	li	s1,2047
4000adc4:	859ff06f          	j	4000a61c <__subdf3+0x94>
4000adc8:	00000513          	li	a0,0
4000adcc:	00048713          	mv	a4,s1
4000add0:	00000793          	li	a5,0
4000add4:	881ff06f          	j	4000a654 <__subdf3+0xcc>
4000add8:	e8070ae3          	beqz	a4,4000ac6c <__subdf3+0x6e4>
4000addc:	00c8e633          	or	a2,a7,a2
4000ade0:	c20600e3          	beqz	a2,4000aa00 <__subdf3+0x478>
4000ade4:	00f8e8b3          	or	a7,a7,a5
4000ade8:	00989713          	slli	a4,a7,0x9
4000adec:	0c074a63          	bltz	a4,4000aec0 <__subdf3+0x938>
4000adf0:	20000737          	lui	a4,0x20000
4000adf4:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
4000adf8:	01d79313          	slli	t1,a5,0x1d
4000adfc:	00a77533          	and	a0,a4,a0
4000ae00:	00a36533          	or	a0,t1,a0
4000ae04:	01d55713          	srli	a4,a0,0x1d
4000ae08:	ff87f793          	andi	a5,a5,-8
4000ae0c:	00f767b3          	or	a5,a4,a5
4000ae10:	00351313          	slli	t1,a0,0x3
4000ae14:	7ff00493          	li	s1,2047
4000ae18:	805ff06f          	j	4000a61c <__subdf3+0x94>
4000ae1c:	00e9e533          	or	a0,s3,a4
4000ae20:	00070793          	mv	a5,a4
4000ae24:	a20516e3          	bnez	a0,4000a850 <__subdf3+0x2c8>
4000ae28:	00000793          	li	a5,0
4000ae2c:	00000813          	li	a6,0
4000ae30:	ac1ff06f          	j	4000a8f0 <__subdf3+0x368>
4000ae34:	02000593          	li	a1,32
4000ae38:	01d7d9b3          	srl	s3,a5,t4
4000ae3c:	00000713          	li	a4,0
4000ae40:	00be8863          	beq	t4,a1,4000ae50 <__subdf3+0x8c8>
4000ae44:	04000713          	li	a4,64
4000ae48:	41d70eb3          	sub	t4,a4,t4
4000ae4c:	01d79733          	sll	a4,a5,t4
4000ae50:	006767b3          	or	a5,a4,t1
4000ae54:	00f037b3          	snez	a5,a5
4000ae58:	00f9e9b3          	or	s3,s3,a5
4000ae5c:	00000e93          	li	t4,0
4000ae60:	c5dff06f          	j	4000aabc <__subdf3+0x534>
4000ae64:	fff74713          	not	a4,a4
4000ae68:	00071e63          	bnez	a4,4000ae84 <__subdf3+0x8fc>
4000ae6c:	00c309b3          	add	s3,t1,a2
4000ae70:	011787b3          	add	a5,a5,a7
4000ae74:	00c9b633          	sltu	a2,s3,a2
4000ae78:	00c787b3          	add	a5,a5,a2
4000ae7c:	000e0493          	mv	s1,t3
4000ae80:	a25ff06f          	j	4000a8a4 <__subdf3+0x31c>
4000ae84:	7ff00693          	li	a3,2047
4000ae88:	e6de1ce3          	bne	t3,a3,4000ad00 <__subdf3+0x778>
4000ae8c:	00c8e533          	or	a0,a7,a2
4000ae90:	da051ee3          	bnez	a0,4000ac4c <__subdf3+0x6c4>
4000ae94:	e2dff06f          	j	4000acc0 <__subdf3+0x738>
4000ae98:	001007b7          	lui	a5,0x100
4000ae9c:	00000813          	li	a6,0
4000aea0:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000aea4:	fff00513          	li	a0,-1
4000aea8:	7ff00493          	li	s1,2047
4000aeac:	a45ff06f          	j	4000a8f0 <__subdf3+0x368>
4000aeb0:	0067e7b3          	or	a5,a5,t1
4000aeb4:	00f036b3          	snez	a3,a5
4000aeb8:	00000793          	li	a5,0
4000aebc:	e79ff06f          	j	4000ad34 <__subdf3+0x7ac>
4000aec0:	008007b7          	lui	a5,0x800
4000aec4:	00000813          	li	a6,0
4000aec8:	ff800313          	li	t1,-8
4000aecc:	fff78793          	addi	a5,a5,-1 # 7fffff <_heap_size+0x7fdfff>
4000aed0:	7ff00493          	li	s1,2047
4000aed4:	f48ff06f          	j	4000a61c <__subdf3+0x94>
4000aed8:	02000513          	li	a0,32
4000aedc:	00e7d6b3          	srl	a3,a5,a4
4000aee0:	00000593          	li	a1,0
4000aee4:	00a70863          	beq	a4,a0,4000aef4 <__subdf3+0x96c>
4000aee8:	04000593          	li	a1,64
4000aeec:	40e58733          	sub	a4,a1,a4
4000aef0:	00e795b3          	sll	a1,a5,a4
4000aef4:	0065e5b3          	or	a1,a1,t1
4000aef8:	00b039b3          	snez	s3,a1
4000aefc:	0136e6b3          	or	a3,a3,s3
4000af00:	00000793          	li	a5,0
4000af04:	e31ff06f          	j	4000ad34 <__subdf3+0x7ac>

4000af08 <__unorddf2>:
4000af08:	0145d713          	srli	a4,a1,0x14
4000af0c:	001007b7          	lui	a5,0x100
4000af10:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000af14:	fff74713          	not	a4,a4
4000af18:	0146d813          	srli	a6,a3,0x14
4000af1c:	00b7f5b3          	and	a1,a5,a1
4000af20:	00d7f7b3          	and	a5,a5,a3
4000af24:	01571693          	slli	a3,a4,0x15
4000af28:	7ff87813          	andi	a6,a6,2047
4000af2c:	02068063          	beqz	a3,4000af4c <__unorddf2+0x44>
4000af30:	7ff00713          	li	a4,2047
4000af34:	00000513          	li	a0,0
4000af38:	00e80463          	beq	a6,a4,4000af40 <__unorddf2+0x38>
4000af3c:	00008067          	ret
4000af40:	00c7e7b3          	or	a5,a5,a2
4000af44:	00f03533          	snez	a0,a5
4000af48:	00008067          	ret
4000af4c:	00a5e5b3          	or	a1,a1,a0
4000af50:	00100513          	li	a0,1
4000af54:	fc058ee3          	beqz	a1,4000af30 <__unorddf2+0x28>
4000af58:	00008067          	ret

4000af5c <__fixdfsi>:
4000af5c:	0145d793          	srli	a5,a1,0x14
4000af60:	001006b7          	lui	a3,0x100
4000af64:	fff68713          	addi	a4,a3,-1 # fffff <_heap_size+0xfdfff>
4000af68:	7ff7f793          	andi	a5,a5,2047
4000af6c:	3fe00613          	li	a2,1022
4000af70:	00b77733          	and	a4,a4,a1
4000af74:	01f5d593          	srli	a1,a1,0x1f
4000af78:	04f65663          	ble	a5,a2,4000afc4 <__fixdfsi+0x68>
4000af7c:	41d00613          	li	a2,1053
4000af80:	02f64a63          	blt	a2,a5,4000afb4 <__fixdfsi+0x58>
4000af84:	43300613          	li	a2,1075
4000af88:	40f60633          	sub	a2,a2,a5
4000af8c:	01f00813          	li	a6,31
4000af90:	00d76733          	or	a4,a4,a3
4000af94:	02c85c63          	ble	a2,a6,4000afcc <__fixdfsi+0x70>
4000af98:	41300693          	li	a3,1043
4000af9c:	40f687b3          	sub	a5,a3,a5
4000afa0:	00f757b3          	srl	a5,a4,a5
4000afa4:	40f00533          	neg	a0,a5
4000afa8:	02059063          	bnez	a1,4000afc8 <__fixdfsi+0x6c>
4000afac:	00078513          	mv	a0,a5
4000afb0:	00008067          	ret
4000afb4:	80000537          	lui	a0,0x80000
4000afb8:	fff54513          	not	a0,a0
4000afbc:	00a58533          	add	a0,a1,a0
4000afc0:	00008067          	ret
4000afc4:	00000513          	li	a0,0
4000afc8:	00008067          	ret
4000afcc:	bed78793          	addi	a5,a5,-1043
4000afd0:	00c55633          	srl	a2,a0,a2
4000afd4:	00f717b3          	sll	a5,a4,a5
4000afd8:	00c7e7b3          	or	a5,a5,a2
4000afdc:	fc9ff06f          	j	4000afa4 <__fixdfsi+0x48>

4000afe0 <__floatsidf>:
4000afe0:	ff010113          	addi	sp,sp,-16
4000afe4:	00112623          	sw	ra,12(sp)
4000afe8:	00812423          	sw	s0,8(sp)
4000afec:	00912223          	sw	s1,4(sp)
4000aff0:	0c050663          	beqz	a0,4000b0bc <__floatsidf+0xdc>
4000aff4:	00050413          	mv	s0,a0
4000aff8:	01f55493          	srli	s1,a0,0x1f
4000affc:	0c054a63          	bltz	a0,4000b0d0 <__floatsidf+0xf0>
4000b000:	00040513          	mv	a0,s0
4000b004:	59c000ef          	jal	ra,4000b5a0 <__clzsi2>
4000b008:	41e00713          	li	a4,1054
4000b00c:	40a70733          	sub	a4,a4,a0
4000b010:	43300693          	li	a3,1075
4000b014:	40e686b3          	sub	a3,a3,a4
4000b018:	01f00793          	li	a5,31
4000b01c:	06d7dc63          	ble	a3,a5,4000b094 <__floatsidf+0xb4>
4000b020:	41300793          	li	a5,1043
4000b024:	40e787b3          	sub	a5,a5,a4
4000b028:	001006b7          	lui	a3,0x100
4000b02c:	00f417b3          	sll	a5,s0,a5
4000b030:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000b034:	00d7f7b3          	and	a5,a5,a3
4000b038:	7ff77713          	andi	a4,a4,2047
4000b03c:	00048693          	mv	a3,s1
4000b040:	00000413          	li	s0,0
4000b044:	00100537          	lui	a0,0x100
4000b048:	fff50513          	addi	a0,a0,-1 # fffff <_heap_size+0xfdfff>
4000b04c:	80100637          	lui	a2,0x80100
4000b050:	00a7f7b3          	and	a5,a5,a0
4000b054:	fff60613          	addi	a2,a2,-1 # 800fffff <_bss_end+0x400f3977>
4000b058:	01471713          	slli	a4,a4,0x14
4000b05c:	00c7f7b3          	and	a5,a5,a2
4000b060:	00e7e7b3          	or	a5,a5,a4
4000b064:	01f69713          	slli	a4,a3,0x1f
4000b068:	800006b7          	lui	a3,0x80000
4000b06c:	fff6c693          	not	a3,a3
4000b070:	00c12083          	lw	ra,12(sp)
4000b074:	00d7f7b3          	and	a5,a5,a3
4000b078:	00e7e7b3          	or	a5,a5,a4
4000b07c:	00040513          	mv	a0,s0
4000b080:	00078593          	mv	a1,a5
4000b084:	00812403          	lw	s0,8(sp)
4000b088:	00412483          	lw	s1,4(sp)
4000b08c:	01010113          	addi	sp,sp,16
4000b090:	00008067          	ret
4000b094:	00b00793          	li	a5,11
4000b098:	40a787b3          	sub	a5,a5,a0
4000b09c:	00f457b3          	srl	a5,s0,a5
4000b0a0:	00d41433          	sll	s0,s0,a3
4000b0a4:	001006b7          	lui	a3,0x100
4000b0a8:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000b0ac:	00d7f7b3          	and	a5,a5,a3
4000b0b0:	7ff77713          	andi	a4,a4,2047
4000b0b4:	00048693          	mv	a3,s1
4000b0b8:	f8dff06f          	j	4000b044 <__floatsidf+0x64>
4000b0bc:	00000693          	li	a3,0
4000b0c0:	00000713          	li	a4,0
4000b0c4:	00000793          	li	a5,0
4000b0c8:	00000413          	li	s0,0
4000b0cc:	f79ff06f          	j	4000b044 <__floatsidf+0x64>
4000b0d0:	40a00433          	neg	s0,a0
4000b0d4:	f2dff06f          	j	4000b000 <__floatsidf+0x20>

4000b0d8 <__floatunsidf>:
4000b0d8:	ff010113          	addi	sp,sp,-16
4000b0dc:	00112623          	sw	ra,12(sp)
4000b0e0:	00812423          	sw	s0,8(sp)
4000b0e4:	0a050663          	beqz	a0,4000b190 <__floatunsidf+0xb8>
4000b0e8:	00050413          	mv	s0,a0
4000b0ec:	4b4000ef          	jal	ra,4000b5a0 <__clzsi2>
4000b0f0:	41e00693          	li	a3,1054
4000b0f4:	40a686b3          	sub	a3,a3,a0
4000b0f8:	43300713          	li	a4,1075
4000b0fc:	40d70733          	sub	a4,a4,a3
4000b100:	01f00793          	li	a5,31
4000b104:	06e7d463          	ble	a4,a5,4000b16c <__floatunsidf+0x94>
4000b108:	41300793          	li	a5,1043
4000b10c:	40d787b3          	sub	a5,a5,a3
4000b110:	00100737          	lui	a4,0x100
4000b114:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000b118:	00f417b3          	sll	a5,s0,a5
4000b11c:	00e7f7b3          	and	a5,a5,a4
4000b120:	7ff6f693          	andi	a3,a3,2047
4000b124:	00000713          	li	a4,0
4000b128:	00100537          	lui	a0,0x100
4000b12c:	fff50513          	addi	a0,a0,-1 # fffff <_heap_size+0xfdfff>
4000b130:	80100637          	lui	a2,0x80100
4000b134:	00a7f7b3          	and	a5,a5,a0
4000b138:	fff60613          	addi	a2,a2,-1 # 800fffff <_bss_end+0x400f3977>
4000b13c:	01469693          	slli	a3,a3,0x14
4000b140:	00c7f7b3          	and	a5,a5,a2
4000b144:	00d7e7b3          	or	a5,a5,a3
4000b148:	00c12083          	lw	ra,12(sp)
4000b14c:	800006b7          	lui	a3,0x80000
4000b150:	fff6c693          	not	a3,a3
4000b154:	00d7f7b3          	and	a5,a5,a3
4000b158:	00070513          	mv	a0,a4
4000b15c:	00078593          	mv	a1,a5
4000b160:	00812403          	lw	s0,8(sp)
4000b164:	01010113          	addi	sp,sp,16
4000b168:	00008067          	ret
4000b16c:	00b00793          	li	a5,11
4000b170:	40a787b3          	sub	a5,a5,a0
4000b174:	00100637          	lui	a2,0x100
4000b178:	00f457b3          	srl	a5,s0,a5
4000b17c:	fff60613          	addi	a2,a2,-1 # fffff <_heap_size+0xfdfff>
4000b180:	00e41733          	sll	a4,s0,a4
4000b184:	00c7f7b3          	and	a5,a5,a2
4000b188:	7ff6f693          	andi	a3,a3,2047
4000b18c:	f9dff06f          	j	4000b128 <__floatunsidf+0x50>
4000b190:	00000693          	li	a3,0
4000b194:	00000793          	li	a5,0
4000b198:	00000713          	li	a4,0
4000b19c:	f8dff06f          	j	4000b128 <__floatunsidf+0x50>

4000b1a0 <__trunctfdf2>:
4000b1a0:	00c52783          	lw	a5,12(a0)
4000b1a4:	00852883          	lw	a7,8(a0)
4000b1a8:	00452683          	lw	a3,4(a0)
4000b1ac:	00052803          	lw	a6,0(a0)
4000b1b0:	01079713          	slli	a4,a5,0x10
4000b1b4:	fe010113          	addi	sp,sp,-32
4000b1b8:	00088593          	mv	a1,a7
4000b1bc:	01075713          	srli	a4,a4,0x10
4000b1c0:	01112c23          	sw	a7,24(sp)
4000b1c4:	00e12e23          	sw	a4,28(sp)
4000b1c8:	01112423          	sw	a7,8(sp)
4000b1cc:	00371713          	slli	a4,a4,0x3
4000b1d0:	01010893          	addi	a7,sp,16
4000b1d4:	01d5d593          	srli	a1,a1,0x1d
4000b1d8:	00d12a23          	sw	a3,20(sp)
4000b1dc:	00d12223          	sw	a3,4(sp)
4000b1e0:	01012823          	sw	a6,16(sp)
4000b1e4:	00088693          	mv	a3,a7
4000b1e8:	00b76733          	or	a4,a4,a1
4000b1ec:	00179613          	slli	a2,a5,0x1
4000b1f0:	00f12623          	sw	a5,12(sp)
4000b1f4:	01f7d513          	srli	a0,a5,0x1f
4000b1f8:	00e6a623          	sw	a4,12(a3) # 8000000c <_bss_end+0x3fff3984>
4000b1fc:	01012023          	sw	a6,0(sp)
4000b200:	00410793          	addi	a5,sp,4
4000b204:	ffc68693          	addi	a3,a3,-4
4000b208:	01165613          	srli	a2,a2,0x11
4000b20c:	02d78263          	beq	a5,a3,4000b230 <__trunctfdf2+0x90>
4000b210:	00c6a703          	lw	a4,12(a3)
4000b214:	0086a583          	lw	a1,8(a3)
4000b218:	ffc68693          	addi	a3,a3,-4
4000b21c:	00371713          	slli	a4,a4,0x3
4000b220:	01d5d593          	srli	a1,a1,0x1d
4000b224:	00b76733          	or	a4,a4,a1
4000b228:	00e6a823          	sw	a4,16(a3)
4000b22c:	fed792e3          	bne	a5,a3,4000b210 <__trunctfdf2+0x70>
4000b230:	01012683          	lw	a3,16(sp)
4000b234:	00008837          	lui	a6,0x8
4000b238:	00160593          	addi	a1,a2,1
4000b23c:	00369793          	slli	a5,a3,0x3
4000b240:	fff80813          	addi	a6,a6,-1 # 7fff <_heap_size+0x5fff>
4000b244:	00f12823          	sw	a5,16(sp)
4000b248:	0105f5b3          	and	a1,a1,a6
4000b24c:	00100693          	li	a3,1
4000b250:	10b6d063          	ble	a1,a3,4000b350 <__trunctfdf2+0x1b0>
4000b254:	ffffc5b7          	lui	a1,0xffffc
4000b258:	40058593          	addi	a1,a1,1024 # ffffc400 <_bss_end+0xbffefd78>
4000b25c:	00b60633          	add	a2,a2,a1
4000b260:	7fe00593          	li	a1,2046
4000b264:	04c5da63          	ble	a2,a1,4000b2b8 <__trunctfdf2+0x118>
4000b268:	7ff00613          	li	a2,2047
4000b26c:	00000793          	li	a5,0
4000b270:	00000693          	li	a3,0
4000b274:	00100737          	lui	a4,0x100
4000b278:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000b27c:	00e7f7b3          	and	a5,a5,a4
4000b280:	80100737          	lui	a4,0x80100
4000b284:	fff70713          	addi	a4,a4,-1 # 800fffff <_bss_end+0x400f3977>
4000b288:	00e7f7b3          	and	a5,a5,a4
4000b28c:	01461613          	slli	a2,a2,0x14
4000b290:	80000737          	lui	a4,0x80000
4000b294:	00c7e7b3          	or	a5,a5,a2
4000b298:	fff74713          	not	a4,a4
4000b29c:	01f51513          	slli	a0,a0,0x1f
4000b2a0:	00e7f7b3          	and	a5,a5,a4
4000b2a4:	00a7e7b3          	or	a5,a5,a0
4000b2a8:	00078593          	mv	a1,a5
4000b2ac:	00068513          	mv	a0,a3
4000b2b0:	02010113          	addi	sp,sp,32
4000b2b4:	00008067          	ret
4000b2b8:	16c05863          	blez	a2,4000b428 <__trunctfdf2+0x288>
4000b2bc:	01412583          	lw	a1,20(sp)
4000b2c0:	01812803          	lw	a6,24(sp)
4000b2c4:	01c12703          	lw	a4,28(sp)
4000b2c8:	00459693          	slli	a3,a1,0x4
4000b2cc:	00f6e6b3          	or	a3,a3,a5
4000b2d0:	01c5d593          	srli	a1,a1,0x1c
4000b2d4:	00481793          	slli	a5,a6,0x4
4000b2d8:	00f5e5b3          	or	a1,a1,a5
4000b2dc:	00d036b3          	snez	a3,a3
4000b2e0:	00471713          	slli	a4,a4,0x4
4000b2e4:	01c85813          	srli	a6,a6,0x1c
4000b2e8:	00b6e6b3          	or	a3,a3,a1
4000b2ec:	01076733          	or	a4,a4,a6
4000b2f0:	0076f793          	andi	a5,a3,7
4000b2f4:	0e078c63          	beqz	a5,4000b3ec <__trunctfdf2+0x24c>
4000b2f8:	00f6f793          	andi	a5,a3,15
4000b2fc:	00400593          	li	a1,4
4000b300:	0eb78663          	beq	a5,a1,4000b3ec <__trunctfdf2+0x24c>
4000b304:	00468793          	addi	a5,a3,4
4000b308:	00d7b6b3          	sltu	a3,a5,a3
4000b30c:	00d70733          	add	a4,a4,a3
4000b310:	008005b7          	lui	a1,0x800
4000b314:	00b775b3          	and	a1,a4,a1
4000b318:	06058063          	beqz	a1,4000b378 <__trunctfdf2+0x1d8>
4000b31c:	00160613          	addi	a2,a2,1
4000b320:	7ff00693          	li	a3,2047
4000b324:	0ed60c63          	beq	a2,a3,4000b41c <__trunctfdf2+0x27c>
4000b328:	ff8006b7          	lui	a3,0xff800
4000b32c:	fff68693          	addi	a3,a3,-1 # ff7fffff <_bss_end+0xbf7f3977>
4000b330:	00d77733          	and	a4,a4,a3
4000b334:	0037d793          	srli	a5,a5,0x3
4000b338:	01d71693          	slli	a3,a4,0x1d
4000b33c:	00971713          	slli	a4,a4,0x9
4000b340:	00f6e6b3          	or	a3,a3,a5
4000b344:	7ff67613          	andi	a2,a2,2047
4000b348:	00c75793          	srli	a5,a4,0xc
4000b34c:	f29ff06f          	j	4000b274 <__trunctfdf2+0xd4>
4000b350:	04061a63          	bnez	a2,4000b3a4 <__trunctfdf2+0x204>
4000b354:	01812683          	lw	a3,24(sp)
4000b358:	01412703          	lw	a4,20(sp)
4000b35c:	00d76733          	or	a4,a4,a3
4000b360:	01c12683          	lw	a3,28(sp)
4000b364:	00d76733          	or	a4,a4,a3
4000b368:	00f76733          	or	a4,a4,a5
4000b36c:	18070263          	beqz	a4,4000b4f0 <__trunctfdf2+0x350>
4000b370:	00000713          	li	a4,0
4000b374:	00500793          	li	a5,5
4000b378:	01d71693          	slli	a3,a4,0x1d
4000b37c:	0037d793          	srli	a5,a5,0x3
4000b380:	7ff00593          	li	a1,2047
4000b384:	00d7e6b3          	or	a3,a5,a3
4000b388:	00375713          	srli	a4,a4,0x3
4000b38c:	06b60863          	beq	a2,a1,4000b3fc <__trunctfdf2+0x25c>
4000b390:	001007b7          	lui	a5,0x100
4000b394:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b398:	00f777b3          	and	a5,a4,a5
4000b39c:	7ff67613          	andi	a2,a2,2047
4000b3a0:	ed5ff06f          	j	4000b274 <__trunctfdf2+0xd4>
4000b3a4:	01412583          	lw	a1,20(sp)
4000b3a8:	01812803          	lw	a6,24(sp)
4000b3ac:	01c12703          	lw	a4,28(sp)
4000b3b0:	7ff00613          	li	a2,2047
4000b3b4:	0105e8b3          	or	a7,a1,a6
4000b3b8:	00e8e8b3          	or	a7,a7,a4
4000b3bc:	00f8e6b3          	or	a3,a7,a5
4000b3c0:	00000793          	li	a5,0
4000b3c4:	ea0688e3          	beqz	a3,4000b274 <__trunctfdf2+0xd4>
4000b3c8:	01c5d693          	srli	a3,a1,0x1c
4000b3cc:	00471713          	slli	a4,a4,0x4
4000b3d0:	00481593          	slli	a1,a6,0x4
4000b3d4:	01c85793          	srli	a5,a6,0x1c
4000b3d8:	00e7e7b3          	or	a5,a5,a4
4000b3dc:	00b6e6b3          	or	a3,a3,a1
4000b3e0:	00400737          	lui	a4,0x400
4000b3e4:	ff86f693          	andi	a3,a3,-8
4000b3e8:	00e7e733          	or	a4,a5,a4
4000b3ec:	008005b7          	lui	a1,0x800
4000b3f0:	00b775b3          	and	a1,a4,a1
4000b3f4:	00068793          	mv	a5,a3
4000b3f8:	f21ff06f          	j	4000b318 <__trunctfdf2+0x178>
4000b3fc:	00e6e7b3          	or	a5,a3,a4
4000b400:	18078a63          	beqz	a5,4000b594 <__trunctfdf2+0x3f4>
4000b404:	000807b7          	lui	a5,0x80
4000b408:	00f767b3          	or	a5,a4,a5
4000b40c:	00100737          	lui	a4,0x100
4000b410:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000b414:	00e7f7b3          	and	a5,a5,a4
4000b418:	e5dff06f          	j	4000b274 <__trunctfdf2+0xd4>
4000b41c:	00000793          	li	a5,0
4000b420:	00000693          	li	a3,0
4000b424:	e51ff06f          	j	4000b274 <__trunctfdf2+0xd4>
4000b428:	fcc00713          	li	a4,-52
4000b42c:	0ce64663          	blt	a2,a4,4000b4f8 <__trunctfdf2+0x358>
4000b430:	03d00593          	li	a1,61
4000b434:	01c12303          	lw	t1,28(sp)
4000b438:	40c58633          	sub	a2,a1,a2
4000b43c:	40565f13          	srai	t5,a2,0x5
4000b440:	00080737          	lui	a4,0x80
4000b444:	00e36333          	or	t1,t1,a4
4000b448:	002f1813          	slli	a6,t5,0x2
4000b44c:	01f67593          	andi	a1,a2,31
4000b450:	01010713          	addi	a4,sp,16
4000b454:	01010613          	addi	a2,sp,16
4000b458:	00000693          	li	a3,0
4000b45c:	00612e23          	sw	t1,28(sp)
4000b460:	01070733          	add	a4,a4,a6
4000b464:	00460613          	addi	a2,a2,4
4000b468:	00f6e6b3          	or	a3,a3,a5
4000b46c:	00c70a63          	beq	a4,a2,4000b480 <__trunctfdf2+0x2e0>
4000b470:	00062783          	lw	a5,0(a2)
4000b474:	00460613          	addi	a2,a2,4
4000b478:	00f6e6b3          	or	a3,a3,a5
4000b47c:	fec71ae3          	bne	a4,a2,4000b470 <__trunctfdf2+0x2d0>
4000b480:	08059263          	bnez	a1,4000b504 <__trunctfdf2+0x364>
4000b484:	00400793          	li	a5,4
4000b488:	41e787b3          	sub	a5,a5,t5
4000b48c:	00279793          	slli	a5,a5,0x2
4000b490:	01010713          	addi	a4,sp,16
4000b494:	00f707b3          	add	a5,a4,a5
4000b498:	00062703          	lw	a4,0(a2)
4000b49c:	00488893          	addi	a7,a7,4
4000b4a0:	00460613          	addi	a2,a2,4
4000b4a4:	fee8ae23          	sw	a4,-4(a7)
4000b4a8:	ff1798e3          	bne	a5,a7,4000b498 <__trunctfdf2+0x2f8>
4000b4ac:	00400713          	li	a4,4
4000b4b0:	41e70733          	sub	a4,a4,t5
4000b4b4:	01010613          	addi	a2,sp,16
4000b4b8:	00271793          	slli	a5,a4,0x2
4000b4bc:	00f607b3          	add	a5,a2,a5
4000b4c0:	00400613          	li	a2,4
4000b4c4:	0007a023          	sw	zero,0(a5) # 80000 <_heap_size+0x7e000>
4000b4c8:	00170713          	addi	a4,a4,1 # 80001 <_heap_size+0x7e001>
4000b4cc:	00478793          	addi	a5,a5,4
4000b4d0:	fec71ae3          	bne	a4,a2,4000b4c4 <__trunctfdf2+0x324>
4000b4d4:	01012783          	lw	a5,16(sp)
4000b4d8:	00d036b3          	snez	a3,a3
4000b4dc:	01412703          	lw	a4,20(sp)
4000b4e0:	00f6e6b3          	or	a3,a3,a5
4000b4e4:	0076f793          	andi	a5,a3,7
4000b4e8:	00000613          	li	a2,0
4000b4ec:	e09ff06f          	j	4000b2f4 <__trunctfdf2+0x154>
4000b4f0:	00000693          	li	a3,0
4000b4f4:	e9dff06f          	j	4000b390 <__trunctfdf2+0x1f0>
4000b4f8:	00000713          	li	a4,0
4000b4fc:	00000613          	li	a2,0
4000b500:	e05ff06f          	j	4000b304 <__trunctfdf2+0x164>
4000b504:	02010793          	addi	a5,sp,32
4000b508:	01078833          	add	a6,a5,a6
4000b50c:	ff082783          	lw	a5,-16(a6)
4000b510:	02000e93          	li	t4,32
4000b514:	40be8eb3          	sub	t4,t4,a1
4000b518:	00300e13          	li	t3,3
4000b51c:	01d797b3          	sll	a5,a5,t4
4000b520:	41ee0e33          	sub	t3,t3,t5
4000b524:	00f6e6b3          	or	a3,a3,a5
4000b528:	060e0063          	beqz	t3,4000b588 <__trunctfdf2+0x3e8>
4000b52c:	00000713          	li	a4,0
4000b530:	0080006f          	j	4000b538 <__trunctfdf2+0x398>
4000b534:	00080713          	mv	a4,a6
4000b538:	00062783          	lw	a5,0(a2)
4000b53c:	00462303          	lw	t1,4(a2)
4000b540:	00170813          	addi	a6,a4,1
4000b544:	00b7d7b3          	srl	a5,a5,a1
4000b548:	01d31333          	sll	t1,t1,t4
4000b54c:	0067e7b3          	or	a5,a5,t1
4000b550:	00f8a023          	sw	a5,0(a7)
4000b554:	00460613          	addi	a2,a2,4
4000b558:	00488893          	addi	a7,a7,4
4000b55c:	fd0e1ce3          	bne	t3,a6,4000b534 <__trunctfdf2+0x394>
4000b560:	01c12303          	lw	t1,28(sp)
4000b564:	00270713          	addi	a4,a4,2
4000b568:	00281793          	slli	a5,a6,0x2
4000b56c:	02010613          	addi	a2,sp,32
4000b570:	00f607b3          	add	a5,a2,a5
4000b574:	00b355b3          	srl	a1,t1,a1
4000b578:	feb7a823          	sw	a1,-16(a5)
4000b57c:	00300793          	li	a5,3
4000b580:	f2e7dae3          	ble	a4,a5,4000b4b4 <__trunctfdf2+0x314>
4000b584:	f51ff06f          	j	4000b4d4 <__trunctfdf2+0x334>
4000b588:	00000813          	li	a6,0
4000b58c:	00100713          	li	a4,1
4000b590:	fd9ff06f          	j	4000b568 <__trunctfdf2+0x3c8>
4000b594:	00000693          	li	a3,0
4000b598:	00000793          	li	a5,0
4000b59c:	cd9ff06f          	j	4000b274 <__trunctfdf2+0xd4>

4000b5a0 <__clzsi2>:
4000b5a0:	000107b7          	lui	a5,0x10
4000b5a4:	02f57c63          	bleu	a5,a0,4000b5dc <__clzsi2+0x3c>
4000b5a8:	0ff00713          	li	a4,255
4000b5ac:	01800693          	li	a3,24
4000b5b0:	00800793          	li	a5,8
4000b5b4:	00a76663          	bltu	a4,a0,4000b5c0 <__clzsi2+0x20>
4000b5b8:	02000693          	li	a3,32
4000b5bc:	00000793          	li	a5,0
4000b5c0:	4000c737          	lui	a4,0x4000c
4000b5c4:	00f557b3          	srl	a5,a0,a5
4000b5c8:	b3470713          	addi	a4,a4,-1228 # 4000bb34 <__clz_tab>
4000b5cc:	00e787b3          	add	a5,a5,a4
4000b5d0:	0007c503          	lbu	a0,0(a5) # 10000 <_heap_size+0xe000>
4000b5d4:	40a68533          	sub	a0,a3,a0
4000b5d8:	00008067          	ret
4000b5dc:	01000737          	lui	a4,0x1000
4000b5e0:	00800693          	li	a3,8
4000b5e4:	01800793          	li	a5,24
4000b5e8:	fce57ce3          	bleu	a4,a0,4000b5c0 <__clzsi2+0x20>
4000b5ec:	01000693          	li	a3,16
4000b5f0:	00068793          	mv	a5,a3
4000b5f4:	4000c737          	lui	a4,0x4000c
4000b5f8:	00f557b3          	srl	a5,a0,a5
4000b5fc:	b3470713          	addi	a4,a4,-1228 # 4000bb34 <__clz_tab>
4000b600:	00e787b3          	add	a5,a5,a4
4000b604:	0007c503          	lbu	a0,0(a5)
4000b608:	40a68533          	sub	a0,a3,a0
4000b60c:	00008067          	ret
4000b610:	694d                	lui	s2,0x13
4000b612:	6f61                	lui	t5,0x18
4000b614:	2075                	jal	4000b6c0 <__clzsi2+0x120>
4000b616:	2121                	jal	4000ba1e <__mprec_bigtens+0x116>
4000b618:	0000                	unimp
4000b61a:	0000                	unimp
4000b61c:	0fdc                	addi	a5,sp,980
4000b61e:	4000                	lw	s0,0(s0)
4000b620:	10d0                	addi	a2,sp,100
4000b622:	4000                	lw	s0,0(s0)
4000b624:	10d0                	addi	a2,sp,100
4000b626:	4000                	lw	s0,0(s0)
4000b628:	0fd4                	addi	a3,sp,980
4000b62a:	4000                	lw	s0,0(s0)
4000b62c:	10d0                	addi	a2,sp,100
4000b62e:	4000                	lw	s0,0(s0)
4000b630:	10d0                	addi	a2,sp,100
4000b632:	4000                	lw	s0,0(s0)
4000b634:	10d0                	addi	a2,sp,100
4000b636:	4000                	lw	s0,0(s0)
4000b638:	10d0                	addi	a2,sp,100
4000b63a:	4000                	lw	s0,0(s0)
4000b63c:	10d0                	addi	a2,sp,100
4000b63e:	4000                	lw	s0,0(s0)
4000b640:	10d0                	addi	a2,sp,100
4000b642:	4000                	lw	s0,0(s0)
4000b644:	041c                	addi	a5,sp,512
4000b646:	4000                	lw	s0,0(s0)
4000b648:	0d44                	addi	s1,sp,660
4000b64a:	4000                	lw	s0,0(s0)
4000b64c:	10d0                	addi	a2,sp,100
4000b64e:	4000                	lw	s0,0(s0)
4000b650:	0434                	addi	a3,sp,520
4000b652:	4000                	lw	s0,0(s0)
4000b654:	0f28                	addi	a0,sp,920
4000b656:	4000                	lw	s0,0(s0)
4000b658:	10d0                	addi	a2,sp,100
4000b65a:	4000                	lw	s0,0(s0)
4000b65c:	0f64                	addi	s1,sp,924
4000b65e:	4000                	lw	s0,0(s0)
4000b660:	0fa8                	addi	a0,sp,984
4000b662:	4000                	lw	s0,0(s0)
4000b664:	0fa8                	addi	a0,sp,984
4000b666:	4000                	lw	s0,0(s0)
4000b668:	0fa8                	addi	a0,sp,984
4000b66a:	4000                	lw	s0,0(s0)
4000b66c:	0fa8                	addi	a0,sp,984
4000b66e:	4000                	lw	s0,0(s0)
4000b670:	0fa8                	addi	a0,sp,984
4000b672:	4000                	lw	s0,0(s0)
4000b674:	0fa8                	addi	a0,sp,984
4000b676:	4000                	lw	s0,0(s0)
4000b678:	0fa8                	addi	a0,sp,984
4000b67a:	4000                	lw	s0,0(s0)
4000b67c:	0fa8                	addi	a0,sp,984
4000b67e:	4000                	lw	s0,0(s0)
4000b680:	0fa8                	addi	a0,sp,984
4000b682:	4000                	lw	s0,0(s0)
4000b684:	10d0                	addi	a2,sp,100
4000b686:	4000                	lw	s0,0(s0)
4000b688:	10d0                	addi	a2,sp,100
4000b68a:	4000                	lw	s0,0(s0)
4000b68c:	10d0                	addi	a2,sp,100
4000b68e:	4000                	lw	s0,0(s0)
4000b690:	10d0                	addi	a2,sp,100
4000b692:	4000                	lw	s0,0(s0)
4000b694:	10d0                	addi	a2,sp,100
4000b696:	4000                	lw	s0,0(s0)
4000b698:	10d0                	addi	a2,sp,100
4000b69a:	4000                	lw	s0,0(s0)
4000b69c:	10d0                	addi	a2,sp,100
4000b69e:	4000                	lw	s0,0(s0)
4000b6a0:	10d0                	addi	a2,sp,100
4000b6a2:	4000                	lw	s0,0(s0)
4000b6a4:	10d0                	addi	a2,sp,100
4000b6a6:	4000                	lw	s0,0(s0)
4000b6a8:	10d0                	addi	a2,sp,100
4000b6aa:	4000                	lw	s0,0(s0)
4000b6ac:	0de8                	addi	a0,sp,732
4000b6ae:	4000                	lw	s0,0(s0)
4000b6b0:	0e20                	addi	s0,sp,792
4000b6b2:	4000                	lw	s0,0(s0)
4000b6b4:	10d0                	addi	a2,sp,100
4000b6b6:	4000                	lw	s0,0(s0)
4000b6b8:	0e20                	addi	s0,sp,792
4000b6ba:	4000                	lw	s0,0(s0)
4000b6bc:	10d0                	addi	a2,sp,100
4000b6be:	4000                	lw	s0,0(s0)
4000b6c0:	10d0                	addi	a2,sp,100
4000b6c2:	4000                	lw	s0,0(s0)
4000b6c4:	10d0                	addi	a2,sp,100
4000b6c6:	4000                	lw	s0,0(s0)
4000b6c8:	10d0                	addi	a2,sp,100
4000b6ca:	4000                	lw	s0,0(s0)
4000b6cc:	0f20                	addi	s0,sp,920
4000b6ce:	4000                	lw	s0,0(s0)
4000b6d0:	10d0                	addi	a2,sp,100
4000b6d2:	4000                	lw	s0,0(s0)
4000b6d4:	10d0                	addi	a2,sp,100
4000b6d6:	4000                	lw	s0,0(s0)
4000b6d8:	0380                	addi	s0,sp,448
4000b6da:	4000                	lw	s0,0(s0)
4000b6dc:	10d0                	addi	a2,sp,100
4000b6de:	4000                	lw	s0,0(s0)
4000b6e0:	10d0                	addi	a2,sp,100
4000b6e2:	4000                	lw	s0,0(s0)
4000b6e4:	10d0                	addi	a2,sp,100
4000b6e6:	4000                	lw	s0,0(s0)
4000b6e8:	10d0                	addi	a2,sp,100
4000b6ea:	4000                	lw	s0,0(s0)
4000b6ec:	10d0                	addi	a2,sp,100
4000b6ee:	4000                	lw	s0,0(s0)
4000b6f0:	03f0                	addi	a2,sp,460
4000b6f2:	4000                	lw	s0,0(s0)
4000b6f4:	10d0                	addi	a2,sp,100
4000b6f6:	4000                	lw	s0,0(s0)
4000b6f8:	10d0                	addi	a2,sp,100
4000b6fa:	4000                	lw	s0,0(s0)
4000b6fc:	1048                	addi	a0,sp,36
4000b6fe:	4000                	lw	s0,0(s0)
4000b700:	10d0                	addi	a2,sp,100
4000b702:	4000                	lw	s0,0(s0)
4000b704:	10d0                	addi	a2,sp,100
4000b706:	4000                	lw	s0,0(s0)
4000b708:	10d0                	addi	a2,sp,100
4000b70a:	4000                	lw	s0,0(s0)
4000b70c:	10d0                	addi	a2,sp,100
4000b70e:	4000                	lw	s0,0(s0)
4000b710:	10d0                	addi	a2,sp,100
4000b712:	4000                	lw	s0,0(s0)
4000b714:	10d0                	addi	a2,sp,100
4000b716:	4000                	lw	s0,0(s0)
4000b718:	10d0                	addi	a2,sp,100
4000b71a:	4000                	lw	s0,0(s0)
4000b71c:	10d0                	addi	a2,sp,100
4000b71e:	4000                	lw	s0,0(s0)
4000b720:	10d0                	addi	a2,sp,100
4000b722:	4000                	lw	s0,0(s0)
4000b724:	10d0                	addi	a2,sp,100
4000b726:	4000                	lw	s0,0(s0)
4000b728:	105c                	addi	a5,sp,36
4000b72a:	4000                	lw	s0,0(s0)
4000b72c:	1094                	addi	a3,sp,96
4000b72e:	4000                	lw	s0,0(s0)
4000b730:	0e20                	addi	s0,sp,792
4000b732:	4000                	lw	s0,0(s0)
4000b734:	0e20                	addi	s0,sp,792
4000b736:	4000                	lw	s0,0(s0)
4000b738:	0e20                	addi	s0,sp,792
4000b73a:	4000                	lw	s0,0(s0)
4000b73c:	0fec                	addi	a1,sp,988
4000b73e:	4000                	lw	s0,0(s0)
4000b740:	1094                	addi	a3,sp,96
4000b742:	4000                	lw	s0,0(s0)
4000b744:	10d0                	addi	a2,sp,100
4000b746:	4000                	lw	s0,0(s0)
4000b748:	10d0                	addi	a2,sp,100
4000b74a:	4000                	lw	s0,0(s0)
4000b74c:	0378                	addi	a4,sp,396
4000b74e:	4000                	lw	s0,0(s0)
4000b750:	10d0                	addi	a2,sp,100
4000b752:	4000                	lw	s0,0(s0)
4000b754:	0d50                	addi	a2,sp,660
4000b756:	4000                	lw	s0,0(s0)
4000b758:	0384                	addi	s1,sp,448
4000b75a:	4000                	lw	s0,0(s0)
4000b75c:	0f6c                	addi	a1,sp,924
4000b75e:	4000                	lw	s0,0(s0)
4000b760:	0378                	addi	a4,sp,396
4000b762:	4000                	lw	s0,0(s0)
4000b764:	10d0                	addi	a2,sp,100
4000b766:	4000                	lw	s0,0(s0)
4000b768:	0d84                	addi	s1,sp,720
4000b76a:	4000                	lw	s0,0(s0)
4000b76c:	10d0                	addi	a2,sp,100
4000b76e:	4000                	lw	s0,0(s0)
4000b770:	03f4                	addi	a3,sp,460
4000b772:	4000                	lw	s0,0(s0)
4000b774:	10d0                	addi	a2,sp,100
4000b776:	4000                	lw	s0,0(s0)
4000b778:	10d0                	addi	a2,sp,100
4000b77a:	4000                	lw	s0,0(s0)
4000b77c:	0ff4                	addi	a3,sp,988
4000b77e:	4000                	lw	s0,0(s0)

4000b780 <blanks.4138>:
4000b780:	2020 2020 2020 2020 2020 2020 2020 2020                     

4000b790 <zeroes.4139>:
4000b790:	3030 3030 3030 3030 3030 3030 3030 3030     0000000000000000
4000b7a0:	4e49 0046 6e69 0066 414e 004e 616e 006e     INF.inf.NAN.nan.
4000b7b0:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF
4000b7c0:	0000 0000 3130 3332 3534 3736 3938 6261     ....0123456789ab
4000b7d0:	6463 6665 0000 0000 6e28 6c75 296c 0000     cdef....(null)..
4000b7e0:	0030 0000 6e49 6966 696e 7974 0000 0000     0...Infinity....
4000b7f0:	614e 004e 0043 0000 4f50 4953 0058 0000     NaN.C...POSIX...
4000b800:	002e 0000 0000 0000                         ........

4000b808 <p05.2481>:
4000b808:	0005 0000 0019 0000 007d 0000 0000 0000     ........}.......

4000b818 <__mprec_tens>:
4000b818:	0000 0000 0000 3ff0 0000 0000 0000 4024     .......?......$@
4000b828:	0000 0000 0000 4059 0000 0000 4000 408f     ......Y@.....@.@
4000b838:	0000 0000 8800 40c3 0000 0000 6a00 40f8     .......@.....j.@
4000b848:	0000 0000 8480 412e 0000 0000 12d0 4163     .......A......cA
4000b858:	0000 0000 d784 4197 0000 0000 cd65 41cd     .......A....e..A
4000b868:	0000 2000 a05f 4202 0000 e800 4876 4237     ... _..B....vH7B
4000b878:	0000 a200 1a94 426d 0000 e540 309c 42a2     ......mB..@..0.B
4000b888:	0000 1e90 bcc4 42d6 0000 2634 6bf5 430c     .......B..4&.k.C
4000b898:	8000 37e0 c379 4341 a000 85d8 3457 4376     ...7y.AC....W4vC
4000b8a8:	c800 674e c16d 43ab 3d00 6091 58e4 43e1     ..Ngm..C.=.`.X.C
4000b8b8:	8c40 78b5 af1d 4415 ef50 d6e2 1ae4 444b     @..x...DP.....KD
4000b8c8:	d592 064d f0cf 4480 4af6 c7e1 2d02 44b5     ..M....D.J...-.D
4000b8d8:	9db4 79d9 7843 44ea                         ...yCx.D

4000b8e0 <__mprec_tinytens>:
4000b8e0:	89bc 97d8 d2b2 3c9c a733 d5a8 f623 3949     .......<3...#.I9
4000b8f0:	a73d 44f4 0ffd 32a5 979d cf8c ba08 255b     =..D...2......[%
4000b900:	6f43 64ac 0628 0ac8                         Co.d(...

4000b908 <__mprec_bigtens>:
4000b908:	8000 37e0 c379 4341 6e17 b505 b8b5 4693     ...7y.AC.n.....F
4000b918:	f9f5 e93f 4f03 4d38 1d32 f930 7748 5a82     ..?..O8M2.0.Hw.Z
4000b928:	bf3c 7f73 4fdd 7515 6ba0 4000 6d14 4000     <.s..O.u.k.@.m.@
4000b938:	6d14 4000 6cc4 4000 6d14 4000 6d14 4000     .m.@.l.@.m.@.m.@
4000b948:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000b958:	6760 4000 6784 4000 6d14 4000 6778 4000     `g.@.g.@.m.@xg.@
4000b968:	67cc 4000 6d14 4000 6794 4000 67a0 4000     .g.@.m.@.g.@.g.@
4000b978:	67a0 4000 67a0 4000 67a0 4000 67a0 4000     .g.@.g.@.g.@.g.@
4000b988:	67a0 4000 67a0 4000 67a0 4000 67a0 4000     .g.@.g.@.g.@.g.@
4000b998:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000b9a8:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000b9b8:	6d14 4000 6d14 4000 6b00 4000 6d14 4000     .m.@.m.@.k.@.m.@
4000b9c8:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000b9d8:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000b9e8:	6d14 4000 66ac 4000 6d14 4000 6d14 4000     .m.@.f.@.m.@.m.@
4000b9f8:	6d14 4000 6d14 4000 6d14 4000 6680 4000     .m.@.m.@.m.@.f.@
4000ba08:	6d14 4000 6d14 4000 6cd0 4000 6d14 4000     .m.@.m.@.l.@.m.@
4000ba18:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000ba28:	6d14 4000 6d14 4000 6d14 4000 6d14 4000     .m.@.m.@.m.@.m.@
4000ba38:	6d14 4000 6c28 4000 6c58 4000 6d14 4000     .m.@(l.@Xl.@.m.@
4000ba48:	6d14 4000 6d14 4000 6c64 4000 6c58 4000     .m.@.m.@dl.@Xl.@
4000ba58:	6d14 4000 6d14 4000 6674 4000 6d14 4000     .m.@.m.@tf.@.m.@
4000ba68:	680c 4000 66b0 4000 6bb4 4000 6674 4000     .h.@.f.@.k.@tf.@
4000ba78:	6d14 4000 683c 4000 6d14 4000 6684 4000     .m.@<h.@.m.@.f.@
4000ba88:	6d14 4000 6d14 4000 6c70 4000               .m.@.m.@pl.@

4000ba94 <blanks.4081>:
4000ba94:	2020 2020 2020 2020 2020 2020 2020 2020                     

4000baa4 <zeroes.4082>:
4000baa4:	3030 3030 3030 3030 3030 3030 3030 3030     0000000000000000
4000bab4:	96fc 4000 9558 4000 96ec 4000 95d4 4000     ...@X..@...@...@
4000bac4:	96ec 4000 96c4 4000 96ec 4000 95d4 4000     ...@...@...@...@
4000bad4:	9558 4000 9558 4000 96c4 4000 95d4 4000     X..@X..@...@...@
4000bae4:	95e4 4000 95e4 4000 95e4 4000 9718 4000     ...@...@...@...@
4000baf4:	a1ac 4000 a02c 4000 a02c 4000 a028 4000     ...@,..@,..@(..@
4000bb04:	a3dc 4000 a3dc 4000 a0bc 4000 a028 4000     ...@...@...@(..@
4000bb14:	a3dc 4000 a0bc 4000 a3dc 4000 a028 4000     ...@...@...@(..@
4000bb24:	a198 4000 a198 4000 a198 4000 a3ec 4000     ...@...@...@...@

4000bb34 <__clz_tab>:
4000bb34:	0100 0202 0303 0303 0404 0404 0404 0404     ................
4000bb44:	0505 0505 0505 0505 0505 0505 0505 0505     ................
4000bb54:	0606 0606 0606 0606 0606 0606 0606 0606     ................
4000bb64:	0606 0606 0606 0606 0606 0606 0606 0606     ................
4000bb74:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000bb84:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000bb94:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000bba4:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000bbb4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bbc4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bbd4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bbe4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bbf4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bc04:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bc14:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bc24:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000bc34:	0000 0000 ffff ffff ffff 7fef 0000 0000     ................
4000bc44:	0000 3ff8 4361 636f 87a7 3fd2 c8b3 8b60     ...?aCoc...?..`.
4000bc54:	8a28 3fc6 79fb 509f 4413 3fd3 0000 0000     (..?.y.P.D.?....
4000bc64:	0000 3ff0 0000 0000 0000 4024 0000 0000     ...?......$@....
4000bc74:	0000 401c 0000 0000 0000 4014 0000 0000     ...@.......@....
4000bc84:	0000 3fe0 0010 0000 0000 0000 7a01 0052     ...?.........zR.
4000bc94:	0401 0101 0d1b 0002 0010 0000 0018 0000     ................
4000bca4:	435c ffff 0008 0000 0000 0000 0010 0000     \C..............
4000bcb4:	002c 0000 4350 ffff 0008 0000 0000 0000     ,...PC..........
4000bcc4:	0010 0000 0040 0000 4344 ffff 0008 0000     ....@...DC......
4000bcd4:	0000 0000 0010 0000 0054 0000 4338 ffff     ........T...8C..
4000bce4:	0008 0000 0000 0000 0010 0000 0068 0000     ............h...
4000bcf4:	432c ffff 0008 0000 0000 0000 0010 0000     ,C..............
4000bd04:	007c 0000 4320 ffff 000c 0000 0000 0000     |... C..........
4000bd14:	0018 0000 0090 0000 4318 ffff 003c 0000     .........C..<...
4000bd24:	4400 100e 1148 7e08 0111 007f 0020 0000     .D..H..~.... ...
4000bd34:	00ac 0000 4338 ffff 0054 0000 4400 100e     ....8C..T....D..
4000bd44:	1150 7d09 1211 117c 7f01 0811 007e 0000     P..}..|.....~...
4000bd54:	0014 0000 00d0 0000 436c ffff 0030 0000     ........lC..0...
4000bd64:	4800 100e 1148 7f01 0010 0000 00e8 0000     .H..H...........
4000bd74:	4350 ffff 0004 0000 0000 0000               PC..........
