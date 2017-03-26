
build/dhrystone.elf:     file format elf32-littleriscv


Disassembly of section .yolo:

00000000 <trap_entry-0x20>:
  j _start
   0:	1380006f          	j	138 <_start>
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
  nop
  20:	00000013          	nop
  addi sp,sp,-128
  24:	f8010113          	addi	sp,sp,-128

  sw gp,   0*4(sp)
  28:	00312023          	sw	gp,0(sp)
  sw x1,   1*4(sp)
  2c:	00112223          	sw	ra,4(sp)
  sw x2,   2*4(sp)
  30:	00212423          	sw	sp,8(sp)
  sw x3,   3*4(sp)
  34:	00312623          	sw	gp,12(sp)
  sw x4,   4*4(sp)
  38:	00412823          	sw	tp,16(sp)
  sw x5,   5*4(sp)
  3c:	00512a23          	sw	t0,20(sp)
  sw x6,   6*4(sp)
  40:	00612c23          	sw	t1,24(sp)
  sw x7,   7*4(sp)
  44:	00712e23          	sw	t2,28(sp)
  sw x8,   8*4(sp)
  48:	02812023          	sw	s0,32(sp)
  sw x9,   9*4(sp)
  4c:	02912223          	sw	s1,36(sp)
  sw x10, 10*4(sp)
  50:	02a12423          	sw	a0,40(sp)
  sw x11, 11*4(sp)
  54:	02b12623          	sw	a1,44(sp)
  sw x12, 12*4(sp)
  58:	02c12823          	sw	a2,48(sp)
  sw x13, 13*4(sp)
  5c:	02d12a23          	sw	a3,52(sp)
  sw x14, 14*4(sp)
  60:	02e12c23          	sw	a4,56(sp)
  sw x15, 15*4(sp)
  64:	02f12e23          	sw	a5,60(sp)
  sw x16, 16*4(sp)
  68:	05012023          	sw	a6,64(sp)
  sw x17, 17*4(sp)
  6c:	05112223          	sw	a7,68(sp)
  sw x18, 18*4(sp)
  70:	05212423          	sw	s2,72(sp)
  sw x19, 19*4(sp)
  74:	05312623          	sw	s3,76(sp)
  sw x20, 20*4(sp)
  78:	05412823          	sw	s4,80(sp)
  sw x21, 21*4(sp)
  7c:	05512a23          	sw	s5,84(sp)
  sw x22, 22*4(sp)
  80:	05612c23          	sw	s6,88(sp)
  sw x23, 23*4(sp)
  84:	05712e23          	sw	s7,92(sp)
  sw x24, 24*4(sp)
  88:	07812023          	sw	s8,96(sp)
  sw x25, 25*4(sp)
  8c:	07912223          	sw	s9,100(sp)
  sw x26, 26*4(sp)
  90:	07a12423          	sw	s10,104(sp)
  sw x27, 27*4(sp)
  94:	07b12623          	sw	s11,108(sp)
  sw x28, 28*4(sp)
  98:	07c12823          	sw	t3,112(sp)
  sw x29, 29*4(sp)
  9c:	07d12a23          	sw	t4,116(sp)
  sw x30, 30*4(sp)
  a0:	07e12c23          	sw	t5,120(sp)
  sw x31, 31*4(sp)
  a4:	07f12e23          	sw	t6,124(sp)
  nop
  a8:	00000013          	nop
  nop
  ac:	00000013          	nop
  nop
  b0:	00000013          	nop
  nop
  b4:	00000013          	nop

  lw x1,   1*4(sp)
  b8:	00412083          	lw	ra,4(sp)
  lw x3,   3*4(sp)
  bc:	00c12183          	lw	gp,12(sp)
  lw x4,   4*4(sp)
  c0:	01012203          	lw	tp,16(sp)
  lw x5,   5*4(sp)
  c4:	01412283          	lw	t0,20(sp)
  lw x6,   6*4(sp)
  c8:	01812303          	lw	t1,24(sp)
  lw x7,   7*4(sp)
  cc:	01c12383          	lw	t2,28(sp)
  lw x8,   8*4(sp)
  d0:	02012403          	lw	s0,32(sp)
  lw x9,   9*4(sp)
  d4:	02412483          	lw	s1,36(sp)
  lw x10, 10*4(sp)
  d8:	02812503          	lw	a0,40(sp)
  lw x11, 11*4(sp)
  dc:	02c12583          	lw	a1,44(sp)
  lw x12, 12*4(sp)
  e0:	03012603          	lw	a2,48(sp)
  lw x13, 13*4(sp)
  e4:	03412683          	lw	a3,52(sp)
  lw x14, 14*4(sp)
  e8:	03812703          	lw	a4,56(sp)
  lw x15, 15*4(sp)
  ec:	03c12783          	lw	a5,60(sp)
  lw x16, 16*4(sp)
  f0:	04012803          	lw	a6,64(sp)
  lw x17, 17*4(sp)
  f4:	04412883          	lw	a7,68(sp)
  lw x18, 18*4(sp)
  f8:	04812903          	lw	s2,72(sp)
  lw x19, 19*4(sp)
  fc:	04c12983          	lw	s3,76(sp)
  lw x20, 20*4(sp)
 100:	05012a03          	lw	s4,80(sp)
  lw x21, 21*4(sp)
 104:	05412a83          	lw	s5,84(sp)
  lw x22, 22*4(sp)
 108:	05812b03          	lw	s6,88(sp)
  lw x23, 23*4(sp)
 10c:	05c12b83          	lw	s7,92(sp)
  lw x24, 24*4(sp)
 110:	06012c03          	lw	s8,96(sp)
  lw x25, 25*4(sp)
 114:	06412c83          	lw	s9,100(sp)
  lw x26, 26*4(sp)
 118:	06812d03          	lw	s10,104(sp)
  lw x27, 27*4(sp)
 11c:	06c12d83          	lw	s11,108(sp)
  lw x28, 28*4(sp)
 120:	07012e03          	lw	t3,112(sp)
  lw x29, 29*4(sp)
 124:	07412e83          	lw	t4,116(sp)
  lw x30, 30*4(sp)
 128:	07812f03          	lw	t5,120(sp)
  lw x31, 31*4(sp)
 12c:	07c12f83          	lw	t6,124(sp)
  addi sp,sp,128
 130:	08010113          	addi	sp,sp,128
  nop
 134:	00000013          	nop

00000138 <_start>:


  .globl _start
_start:

  la sp, _stack_start
 138:	00001117          	auipc	sp,0x1
 13c:	88010113          	addi	sp,sp,-1920 # 9b8 <_stack_start>

00000140 <test_init>:

test_init:
  li a0, 20
 140:	01400513          	li	a0,20

00000144 <test_loop>:
test_loop:
  nop
 144:	00000013          	nop
  nop
 148:	00000013          	nop
  nop
 14c:	00000013          	nop
  addi a0, a0, -1
 150:	fff50513          	addi	a0,a0,-1
  bne a0,x0,test_loop
 154:	fe0518e3          	bnez	a0,144 <test_loop>

00000158 <bss_init>:
test_done:


bss_init:
  la a0, _bss_start
 158:	4000e517          	auipc	a0,0x4000e
 15c:	43850513          	addi	a0,a0,1080 # 4000e590 <_edata>
  la a1, _bss_end
 160:	40011597          	auipc	a1,0x40011
 164:	c7c58593          	addi	a1,a1,-900 # 40010ddc <_bss_end>

00000168 <bss_loop>:
bss_loop:
  beq a0,a1,bss_done
 168:	00b50863          	beq	a0,a1,178 <bss_done>
  sw zero,0(a0)
 16c:	00052023          	sw	zero,0(a0)
  add a0,a0,4
 170:	00450513          	addi	a0,a0,4
  j bss_loop
 174:	ff5ff06f          	j	168 <bss_loop>

00000178 <bss_done>:
  add a0,a0,4
  j data_loop
data_done:*/

ctors_init:
  la a0, _ctors_start
 178:	4000e517          	auipc	a0,0x4000e
 17c:	b5850513          	addi	a0,a0,-1192 # 4000dcd0 <_etext>
  addi sp,sp,-4
 180:	ffc10113          	addi	sp,sp,-4

00000184 <ctors_loop>:
ctors_loop:
  la a1, _ctors_end
 184:	4000e597          	auipc	a1,0x4000e
 188:	b4c58593          	addi	a1,a1,-1204 # 4000dcd0 <_etext>
  beq a0,a1,ctors_done
 18c:	00b50e63          	beq	a0,a1,1a8 <ctors_done>
  lw a3,0(a0)
 190:	00052683          	lw	a3,0(a0)
  add a0,a0,4
 194:	00450513          	addi	a0,a0,4
  sw a0,0(sp)
 198:	00a12023          	sw	a0,0(sp)
  jalr  a3
 19c:	000680e7          	jalr	a3
  lw a0,0(sp)
 1a0:	00012503          	lw	a0,0(sp)
  j ctors_loop
 1a4:	fe1ff06f          	j	184 <ctors_loop>

000001a8 <ctors_done>:
ctors_done:
  addi sp,sp,4
 1a8:	00410113          	addi	sp,sp,4

  call main
 1ac:	40001317          	auipc	t1,0x40001
 1b0:	b20300e7          	jalr	-1248(t1) # 40000ccc <main>

000001b4 <infinitLoop>:
infinitLoop:
  j infinitLoop
 1b4:	0000006f          	j	1b4 <infinitLoop>

Disassembly of section .text:

40000000 <Proc_2>:
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
40000000:	4000e7b7          	lui	a5,0x4000e
40000004:	5a97c703          	lbu	a4,1449(a5) # 4000e5a9 <Ch_1_Glob>
40000008:	04100793          	li	a5,65
4000000c:	00f70463          	beq	a4,a5,40000014 <Proc_2+0x14>
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */
40000010:	00008067          	ret
      Int_Loc -= 1;
40000014:	00052783          	lw	a5,0(a0)
      *Int_Par_Ref = Int_Loc - Int_Glob;
40000018:	4000e737          	lui	a4,0x4000e
4000001c:	5b072703          	lw	a4,1456(a4) # 4000e5b0 <Int_Glob>
      Int_Loc -= 1;
40000020:	00978793          	addi	a5,a5,9
      *Int_Par_Ref = Int_Loc - Int_Glob;
40000024:	40e787b3          	sub	a5,a5,a4
40000028:	00f52023          	sw	a5,0(a0)
} /* Proc_2 */
4000002c:	00008067          	ret

40000030 <Proc_3>:
    /* Ptr_Ref_Par becomes Ptr_Glob */

Rec_Pointer *Ptr_Ref_Par;

{
  if (Ptr_Glob != Null)
40000030:	4000e7b7          	lui	a5,0x4000e
40000034:	5b87a603          	lw	a2,1464(a5) # 4000e5b8 <Ptr_Glob>
40000038:	00060863          	beqz	a2,40000048 <Proc_3+0x18>
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
4000003c:	00062703          	lw	a4,0(a2)
40000040:	00e52023          	sw	a4,0(a0)
40000044:	5b87a603          	lw	a2,1464(a5)
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
40000048:	4000e7b7          	lui	a5,0x4000e
4000004c:	5b07a583          	lw	a1,1456(a5) # 4000e5b0 <Int_Glob>
40000050:	00c60613          	addi	a2,a2,12
40000054:	00a00513          	li	a0,10
40000058:	1850006f          	j	400009dc <Proc_7>

4000005c <Proc_1>:
4000005c:	ff010113          	addi	sp,sp,-16
{
40000060:	01212023          	sw	s2,0(sp)
40000064:	4000e937          	lui	s2,0x4000e
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
40000068:	5b892783          	lw	a5,1464(s2) # 4000e5b8 <Ptr_Glob>
4000006c:	00812423          	sw	s0,8(sp)
{
40000070:	00052403          	lw	s0,0(a0)
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
40000074:	0007a683          	lw	a3,0(a5)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
40000078:	00112623          	sw	ra,12(sp)
{
4000007c:	00912223          	sw	s1,4(sp)
40000080:	00d42023          	sw	a3,0(s0)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
40000084:	0047a683          	lw	a3,4(a5)
40000088:	00050493          	mv	s1,a0
{
4000008c:	00500713          	li	a4,5
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
40000090:	00d42223          	sw	a3,4(s0)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
40000094:	0087a683          	lw	a3,8(a5)
40000098:	00040513          	mv	a0,s0
  Proc_3 (&Next_Record->Ptr_Comp);
4000009c:	00d42423          	sw	a3,8(s0)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
400000a0:	00c7a683          	lw	a3,12(a5)
400000a4:	00d42623          	sw	a3,12(s0)
400000a8:	0107a683          	lw	a3,16(a5)
400000ac:	00d42823          	sw	a3,16(s0)
400000b0:	0147a683          	lw	a3,20(a5)
400000b4:	00d42a23          	sw	a3,20(s0)
400000b8:	0187a683          	lw	a3,24(a5)
400000bc:	00d42c23          	sw	a3,24(s0)
400000c0:	01c7a683          	lw	a3,28(a5)
400000c4:	00d42e23          	sw	a3,28(s0)
400000c8:	0207a683          	lw	a3,32(a5)
400000cc:	02d42023          	sw	a3,32(s0)
400000d0:	0247a683          	lw	a3,36(a5)
400000d4:	02d42223          	sw	a3,36(s0)
400000d8:	0287a683          	lw	a3,40(a5)
400000dc:	02d42423          	sw	a3,40(s0)
400000e0:	02c7a783          	lw	a5,44(a5)
400000e4:	02f42623          	sw	a5,44(s0)
400000e8:	00e4a623          	sw	a4,12(s1)
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
400000ec:	00e42623          	sw	a4,12(s0)
        = Ptr_Val_Par->variant.var_1.Int_Comp;
400000f0:	0004a783          	lw	a5,0(s1)
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
400000f4:	00f42023          	sw	a5,0(s0)
400000f8:	f39ff0ef          	jal	ra,40000030 <Proc_3>
  Proc_3 (&Next_Record->Ptr_Comp);
400000fc:	00442783          	lw	a5,4(s0)
40000100:	08078063          	beqz	a5,40000180 <Proc_1+0x124>
  if (Next_Record->Discr == Ident_1)
40000104:	0004a783          	lw	a5,0(s1)
40000108:	00c12083          	lw	ra,12(sp)
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
4000010c:	00812403          	lw	s0,8(sp)
} /* Proc_1 */
40000110:	0007a703          	lw	a4,0(a5)
40000114:	00012903          	lw	s2,0(sp)
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
40000118:	00e4a023          	sw	a4,0(s1)
} /* Proc_1 */
4000011c:	0047a703          	lw	a4,4(a5)
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
40000120:	00e4a223          	sw	a4,4(s1)
40000124:	0087a703          	lw	a4,8(a5)
40000128:	00e4a423          	sw	a4,8(s1)
4000012c:	00c7a703          	lw	a4,12(a5)
40000130:	00e4a623          	sw	a4,12(s1)
40000134:	0107a703          	lw	a4,16(a5)
40000138:	00e4a823          	sw	a4,16(s1)
4000013c:	0147a703          	lw	a4,20(a5)
40000140:	00e4aa23          	sw	a4,20(s1)
40000144:	0187a703          	lw	a4,24(a5)
40000148:	00e4ac23          	sw	a4,24(s1)
4000014c:	01c7a703          	lw	a4,28(a5)
40000150:	00e4ae23          	sw	a4,28(s1)
40000154:	0207a703          	lw	a4,32(a5)
40000158:	02e4a023          	sw	a4,32(s1)
4000015c:	0247a703          	lw	a4,36(a5)
40000160:	02e4a223          	sw	a4,36(s1)
40000164:	0287a703          	lw	a4,40(a5)
40000168:	02e4a423          	sw	a4,40(s1)
4000016c:	02c7a783          	lw	a5,44(a5)
40000170:	02f4a623          	sw	a5,44(s1)
40000174:	00412483          	lw	s1,4(sp)
40000178:	01010113          	addi	sp,sp,16
} /* Proc_1 */
4000017c:	00008067          	ret
40000180:	00600793          	li	a5,6
40000184:	00f42623          	sw	a5,12(s0)
    Next_Record->variant.var_1.Int_Comp = 6;
40000188:	0084a503          	lw	a0,8(s1)
4000018c:	00840593          	addi	a1,s0,8
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
40000190:	1a5000ef          	jal	ra,40000b34 <Proc_6>
40000194:	5b892783          	lw	a5,1464(s2)
40000198:	00c42503          	lw	a0,12(s0)
4000019c:	00c40613          	addi	a2,s0,12
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
400001a0:	0007a783          	lw	a5,0(a5)
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
400001a4:	00c12083          	lw	ra,12(sp)
400001a8:	00412483          	lw	s1,4(sp)
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
400001ac:	00f42023          	sw	a5,0(s0)
} /* Proc_1 */
400001b0:	00012903          	lw	s2,0(sp)
400001b4:	00812403          	lw	s0,8(sp)
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
400001b8:	00a00593          	li	a1,10
} /* Proc_1 */
400001bc:	01010113          	addi	sp,sp,16
400001c0:	01d0006f          	j	400009dc <Proc_7>

400001c4 <Proc_4>:
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
400001c4:	4000e7b7          	lui	a5,0x4000e
} /* Proc_1 */
400001c8:	5a97c783          	lbu	a5,1449(a5) # 4000e5a9 <Ch_1_Glob>
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
400001cc:	4000e737          	lui	a4,0x4000e
400001d0:	5ac72683          	lw	a3,1452(a4) # 4000e5ac <Bool_Glob>
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
400001d4:	fbf78793          	addi	a5,a5,-65
400001d8:	0017b793          	seqz	a5,a5
  Bool_Glob = Bool_Loc | Bool_Glob;
400001dc:	00d7e7b3          	or	a5,a5,a3
400001e0:	5af72623          	sw	a5,1452(a4)
  Bool_Loc = Ch_1_Glob == 'A';
400001e4:	04200713          	li	a4,66
400001e8:	4000e7b7          	lui	a5,0x4000e
  Bool_Glob = Bool_Loc | Bool_Glob;
400001ec:	5ae78423          	sb	a4,1448(a5) # 4000e5a8 <Ch_2_Glob>
400001f0:	00008067          	ret

400001f4 <Proc_5>:
  Ch_2_Glob = 'B';
400001f4:	04100713          	li	a4,65
400001f8:	4000e7b7          	lui	a5,0x4000e
400001fc:	5ae784a3          	sb	a4,1449(a5) # 4000e5a9 <Ch_1_Glob>
} /* Proc_4 */
40000200:	4000e7b7          	lui	a5,0x4000e

Proc_5 () /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
40000204:	5a07a623          	sw	zero,1452(a5) # 4000e5ac <Bool_Glob>
40000208:	00008067          	ret

4000020c <main2>:
4000020c:	f6010113          	addi	sp,sp,-160
  Bool_Glob = false;
40000210:	03000513          	li	a0,48
40000214:	08112e23          	sw	ra,156(sp)
} /* Proc_5 */
40000218:	08812c23          	sw	s0,152(sp)
{
4000021c:	08912a23          	sw	s1,148(sp)
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
40000220:	09212823          	sw	s2,144(sp)
{
40000224:	09312623          	sw	s3,140(sp)
40000228:	09412423          	sw	s4,136(sp)
4000022c:	09512223          	sw	s5,132(sp)
40000230:	09612023          	sw	s6,128(sp)
40000234:	07712e23          	sw	s7,124(sp)
40000238:	07812c23          	sw	s8,120(sp)
4000023c:	07912a23          	sw	s9,116(sp)
40000240:	07a12823          	sw	s10,112(sp)
40000244:	07b12623          	sw	s11,108(sp)
40000248:	2a9000ef          	jal	ra,40000cf0 <malloc>
4000024c:	4000e7b7          	lui	a5,0x4000e
40000250:	5aa7aa23          	sw	a0,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
40000254:	03000513          	li	a0,48
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
40000258:	299000ef          	jal	ra,40000cf0 <malloc>
4000025c:	4000e7b7          	lui	a5,0x4000e
40000260:	5b47a783          	lw	a5,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
40000264:	4000e737          	lui	a4,0x4000e
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
40000268:	5aa72c23          	sw	a0,1464(a4) # 4000e5b8 <Ptr_Glob>
4000026c:	00f52023          	sw	a5,0(a0)
40000270:	00200793          	li	a5,2
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
40000274:	00f52423          	sw	a5,8(a0)
40000278:	4000d5b7          	lui	a1,0x4000d
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
4000027c:	02800793          	li	a5,40
40000280:	01f00613          	li	a2,31
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
40000284:	ff858593          	addi	a1,a1,-8 # 4000cff8 <__clzsi2+0x70>
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
40000288:	00f52623          	sw	a5,12(a0)
4000028c:	00052223          	sw	zero,4(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
40000290:	01050513          	addi	a0,a0,16
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
40000294:	1c8010ef          	jal	ra,4000145c <memcpy>
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
40000298:	4000d7b7          	lui	a5,0x4000d
4000029c:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
400002a0:	595257b7          	lui	a5,0x59525
  Ptr_Glob->Discr                       = Ident_1;
400002a4:	84478793          	addi	a5,a5,-1980 # 59524844 <end+0x19513a64>
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
400002a8:	02f12023          	sw	a5,32(sp)
400002ac:	4e4f57b7          	lui	a5,0x4e4f5
400002b0:	45378793          	addi	a5,a5,1107 # 4e4f5453 <end+0xe4e4673>
  printf ("\n");
400002b4:	02f12223          	sw	a5,36(sp)
400002b8:	525027b7          	lui	a5,0x52502
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
400002bc:	04578793          	addi	a5,a5,69 # 52502045 <end+0x124f1265>
400002c0:	02f12423          	sw	a5,40(sp)
400002c4:	415247b7          	lui	a5,0x41524
400002c8:	74f78793          	addi	a5,a5,1871 # 4152474f <end+0x151396f>
400002cc:	02f12623          	sw	a5,44(sp)
400002d0:	312037b7          	lui	a5,0x31203
400002d4:	c4d78793          	addi	a5,a5,-947 # 31202c4d <_heap_size+0x31200c4d>
400002d8:	02f12823          	sw	a5,48(sp)
400002dc:	205457b7          	lui	a5,0x20545
400002e0:	32778793          	addi	a5,a5,807 # 20545327 <_heap_size+0x20543327>
400002e4:	02f12a23          	sw	a5,52(sp)
400002e8:	495257b7          	lui	a5,0x49525
400002ec:	45378793          	addi	a5,a5,1107 # 49525453 <end+0x9514673>
400002f0:	02f12c23          	sw	a5,56(sp)
400002f4:	000047b7          	lui	a5,0x4
400002f8:	74e78793          	addi	a5,a5,1870 # 474e <_heap_size+0x274e>
400002fc:	4000e737          	lui	a4,0x4000e
40000300:	5d870713          	addi	a4,a4,1496 # 4000e5d8 <Arr_2_Glob>
40000304:	02f11e23          	sh	a5,60(sp)
40000308:	00a00793          	li	a5,10
4000030c:	64f72e23          	sw	a5,1628(a4)
40000310:	02010f23          	sb	zero,62(sp)
40000314:	2b0010ef          	jal	ra,400015c4 <printf>
  Arr_2_Glob [8][7] = 10;
40000318:	4000d537          	lui	a0,0x4000d
4000031c:	01850513          	addi	a0,a0,24 # 4000d018 <__clzsi2+0x90>
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
40000320:	2a4010ef          	jal	ra,400015c4 <printf>
  Arr_2_Glob [8][7] = 10;
40000324:	4000d7b7          	lui	a5,0x4000d
40000328:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
4000032c:	298010ef          	jal	ra,400015c4 <printf>
  printf ("\n");
40000330:	4000e7b7          	lui	a5,0x4000e
40000334:	5a47a783          	lw	a5,1444(a5) # 4000e5a4 <Reg>
  printf ("Dhrystone Benchmark, Version 2.1 (Language: C)\n");
40000338:	66078063          	beqz	a5,40000998 <main2+0x78c>
4000033c:	4000d537          	lui	a0,0x4000d
40000340:	04850513          	addi	a0,a0,72 # 4000d048 <__clzsi2+0xc0>
40000344:	280010ef          	jal	ra,400015c4 <printf>
  printf ("\n");
40000348:	4000d7b7          	lui	a5,0x4000d
4000034c:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
40000350:	274010ef          	jal	ra,400015c4 <printf>
40000354:	4000d537          	lui	a0,0x4000d
  if (Reg)
40000358:	0a450513          	addi	a0,a0,164 # 4000d0a4 <__clzsi2+0x11c>
4000035c:	268010ef          	jal	ra,400015c4 <printf>
40000360:	4000d7b7          	lui	a5,0x4000d
    printf ("Program compiled with 'register' attribute\n");
40000364:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
40000368:	25c010ef          	jal	ra,400015c4 <printf>
4000036c:	4000d537          	lui	a0,0x4000d
40000370:	0c800593          	li	a1,200
    printf ("\n");
40000374:	0dc50513          	addi	a0,a0,220 # 4000d0dc <__clzsi2+0x154>
40000378:	24c010ef          	jal	ra,400015c4 <printf>
4000037c:	14d000ef          	jal	ra,40000cc8 <clock>
40000380:	4000e7b7          	lui	a5,0x4000e
  printf ("Please give the number of runs through the benchmark: ");
40000384:	5aa7a023          	sw	a0,1440(a5) # 4000e5a0 <Begin_Time>
40000388:	400117b7          	lui	a5,0x40011
4000038c:	ce878793          	addi	a5,a5,-792 # 40010ce8 <Arr_1_Glob>
40000390:	00f12623          	sw	a5,12(sp)
  printf ("\n");
40000394:	322037b7          	lui	a5,0x32203
40000398:	59525cb7          	lui	s9,0x59525
4000039c:	4e4f5c37          	lui	s8,0x4e4f5
400003a0:	52502bb7          	lui	s7,0x52502
  printf ("Execution starts, %d runs through Dhrystone\n", Number_Of_Runs);
400003a4:	41524b37          	lui	s6,0x41524
400003a8:	c4d78793          	addi	a5,a5,-947 # 32202c4d <_heap_size+0x32200c4d>
400003ac:	49525ab7          	lui	s5,0x49525
400003b0:	00004a37          	lui	s4,0x4
400003b4:	20445db7          	lui	s11,0x20445
  Begin_Time = clock();
400003b8:	00100993          	li	s3,1
400003bc:	4000e4b7          	lui	s1,0x4000e
400003c0:	4000ed37          	lui	s10,0x4000e
400003c4:	844c8c93          	addi	s9,s9,-1980 # 59524844 <end+0x19513a64>
400003c8:	453c0c13          	addi	s8,s8,1107 # 4e4f5453 <end+0xe4e4673>
400003cc:	045b8b93          	addi	s7,s7,69 # 52502045 <end+0x124f1265>
400003d0:	74fb0b13          	addi	s6,s6,1871 # 4152474f <end+0x151396f>
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
400003d4:	00f12223          	sw	a5,4(sp)
400003d8:	453a8a93          	addi	s5,s5,1107 # 49525453 <end+0x9514673>
400003dc:	74ea0a13          	addi	s4,s4,1870 # 474e <_heap_size+0x274e>
400003e0:	e15ff0ef          	jal	ra,400001f4 <Proc_5>
400003e4:	de1ff0ef          	jal	ra,400001c4 <Proc_4>
400003e8:	00412783          	lw	a5,4(sp)
400003ec:	00200413          	li	s0,2
400003f0:	04010593          	addi	a1,sp,64
400003f4:	04f12823          	sw	a5,80(sp)
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
400003f8:	204457b7          	lui	a5,0x20445
400003fc:	e2778793          	addi	a5,a5,-473 # 20444e27 <_heap_size+0x20442e27>
40000400:	04f12a23          	sw	a5,84(sp)
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
40000404:	02010513          	addi	a0,sp,32
40000408:	00100793          	li	a5,1
4000040c:	00f12e23          	sw	a5,28(sp)
40000410:	00812a23          	sw	s0,20(sp)
40000414:	05912023          	sw	s9,64(sp)
40000418:	05812223          	sw	s8,68(sp)
4000041c:	05712423          	sw	s7,72(sp)
    Proc_5();
40000420:	05612623          	sw	s6,76(sp)
40000424:	05512c23          	sw	s5,88(sp)
    Proc_4();
40000428:	05411e23          	sh	s4,92(sp)
4000042c:	04010f23          	sb	zero,94(sp)
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
40000430:	684000ef          	jal	ra,40000ab4 <Func_2>
    Int_1_Loc = 2;
40000434:	01412603          	lw	a2,20(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
40000438:	00153513          	seqz	a0,a0
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
4000043c:	4000e7b7          	lui	a5,0x4000e
40000440:	5aa7a623          	sw	a0,1452(a5) # 4000e5ac <Bool_Glob>
40000444:	02c44c63          	blt	s0,a2,4000047c <main2+0x270>
40000448:	00300913          	li	s2,3
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
4000044c:	00261793          	slli	a5,a2,0x2
    Enum_Loc = Ident_2;
40000450:	00c787b3          	add	a5,a5,a2
40000454:	ffd78793          	addi	a5,a5,-3
    Int_1_Loc = 2;
40000458:	00060513          	mv	a0,a2
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
4000045c:	00090593          	mv	a1,s2
40000460:	01810613          	addi	a2,sp,24
40000464:	00f12c23          	sw	a5,24(sp)
40000468:	574000ef          	jal	ra,400009dc <Proc_7>
4000046c:	01412603          	lw	a2,20(sp)
40000470:	00160613          	addi	a2,a2,1
40000474:	00c12a23          	sw	a2,20(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
40000478:	fcc45ae3          	ble	a2,s0,4000044c <main2+0x240>
4000047c:	01812683          	lw	a3,24(sp)
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
40000480:	00c12503          	lw	a0,12(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
40000484:	4000e7b7          	lui	a5,0x4000e
40000488:	5d878593          	addi	a1,a5,1496 # 4000e5d8 <Arr_2_Glob>
4000048c:	560000ef          	jal	ra,400009ec <Proc_8>
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
40000490:	4000e7b7          	lui	a5,0x4000e
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
40000494:	5b87a503          	lw	a0,1464(a5) # 4000e5b8 <Ptr_Glob>
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
40000498:	00300413          	li	s0,3
4000049c:	bc1ff0ef          	jal	ra,4000005c <Proc_1>
400004a0:	5a84c703          	lbu	a4,1448(s1) # 4000e5a8 <Ch_2_Glob>
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
400004a4:	04000793          	li	a5,64
400004a8:	08e7f263          	bleu	a4,a5,4000052c <main2+0x320>
400004ac:	04100913          	li	s2,65
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
400004b0:	0140006f          	j	400004c4 <main2+0x2b8>
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
400004b4:	5a84c783          	lbu	a5,1448(s1)
400004b8:	00190913          	addi	s2,s2,1
      Int_1_Loc += 1;
400004bc:	0ff97913          	andi	s2,s2,255
400004c0:	0727e663          	bltu	a5,s2,4000052c <main2+0x320>
400004c4:	04300593          	li	a1,67
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
400004c8:	00090513          	mv	a0,s2
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
400004cc:	5c4000ef          	jal	ra,40000a90 <Func_1>
400004d0:	01c12783          	lw	a5,28(sp)
400004d4:	fef510e3          	bne	a0,a5,400004b4 <main2+0x2a8>
400004d8:	01c10593          	addi	a1,sp,28
400004dc:	00000513          	li	a0,0
400004e0:	654000ef          	jal	ra,40000b34 <Proc_6>
    Proc_1 (Ptr_Glob);
400004e4:	332037b7          	lui	a5,0x33203
400004e8:	c4d78793          	addi	a5,a5,-947 # 33202c4d <_heap_size+0x33200c4d>
    Int_2_Loc = 3;
400004ec:	04f12823          	sw	a5,80(sp)
    Proc_1 (Ptr_Glob);
400004f0:	5a84c783          	lbu	a5,1448(s1)
400004f4:	227d8713          	addi	a4,s11,551 # 20445227 <_heap_size+0x20443227>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
400004f8:	00190913          	addi	s2,s2,1
400004fc:	05912023          	sw	s9,64(sp)
40000500:	05812223          	sw	s8,68(sp)
40000504:	05712423          	sw	s7,72(sp)
40000508:	05612623          	sw	s6,76(sp)
4000050c:	04e12a23          	sw	a4,84(sp)
40000510:	05512c23          	sw	s5,88(sp)
40000514:	05411e23          	sh	s4,92(sp)
40000518:	04010f23          	sb	zero,94(sp)
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
4000051c:	5b3d2823          	sw	s3,1456(s10) # 4000e5b0 <Int_Glob>
40000520:	0ff97913          	andi	s2,s2,255
40000524:	00098413          	mv	s0,s3
40000528:	f927fee3          	bleu	s2,a5,400004c4 <main2+0x2b8>
4000052c:	01412583          	lw	a1,20(sp)
40000530:	00040513          	mv	a0,s0
        Proc_6 (Ident_1, &Enum_Loc);
40000534:	00198993          	addi	s3,s3,1
40000538:	1790c0ef          	jal	ra,4000ceb0 <__mulsi3>
4000053c:	01812903          	lw	s2,24(sp)
40000540:	00a12423          	sw	a0,8(sp)
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
40000544:	00090593          	mv	a1,s2
40000548:	18d0c0ef          	jal	ra,4000ced4 <__divsi3>
4000054c:	00050413          	mv	s0,a0
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
40000550:	01410513          	addi	a0,sp,20
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
40000554:	00812a23          	sw	s0,20(sp)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
40000558:	aa9ff0ef          	jal	ra,40000000 <Proc_2>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
4000055c:	0c900793          	li	a5,201
40000560:	e8f990e3          	bne	s3,a5,400003e0 <main2+0x1d4>
40000564:	764000ef          	jal	ra,40000cc8 <clock>
40000568:	4000ecb7          	lui	s9,0x4000e
4000056c:	58acae23          	sw	a0,1436(s9) # 4000e59c <End_Time>
40000570:	4000d537          	lui	a0,0x4000d
40000574:	10c50513          	addi	a0,a0,268 # 4000d10c <__clzsi2+0x184>
40000578:	04c010ef          	jal	ra,400015c4 <printf>
        Int_Glob = Run_Index;
4000057c:	4000d7b7          	lui	a5,0x4000d
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
40000580:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
        Int_Glob = Run_Index;
40000584:	040010ef          	jal	ra,400015c4 <printf>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
40000588:	4000d537          	lui	a0,0x4000d
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
4000058c:	11c50513          	addi	a0,a0,284 # 4000d11c <__clzsi2+0x194>
40000590:	034010ef          	jal	ra,400015c4 <printf>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
40000594:	4000d7b7          	lui	a5,0x4000d
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
40000598:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
4000059c:	028010ef          	jal	ra,400015c4 <printf>
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
400005a0:	5b0d2583          	lw	a1,1456(s10)
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
400005a4:	4000d537          	lui	a0,0x4000d
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
400005a8:	15450513          	addi	a0,a0,340 # 4000d154 <__clzsi2+0x1cc>
400005ac:	4000d9b7          	lui	s3,0x4000d
400005b0:	014010ef          	jal	ra,400015c4 <printf>
400005b4:	00500593          	li	a1,5
    Proc_2 (&Int_1_Loc);
400005b8:	17098513          	addi	a0,s3,368 # 4000d170 <__clzsi2+0x1e8>
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
400005bc:	008010ef          	jal	ra,400015c4 <printf>
    Proc_2 (&Int_1_Loc);
400005c0:	4000e7b7          	lui	a5,0x4000e
400005c4:	5ac7a583          	lw	a1,1452(a5) # 4000e5ac <Bool_Glob>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
400005c8:	4000d537          	lui	a0,0x4000d
400005cc:	18c50513          	addi	a0,a0,396 # 4000d18c <__clzsi2+0x204>
  End_Time = clock();
400005d0:	7f5000ef          	jal	ra,400015c4 <printf>
400005d4:	00100593          	li	a1,1
400005d8:	17098513          	addi	a0,s3,368
400005dc:	7e9000ef          	jal	ra,400015c4 <printf>
  printf ("Execution ends\n");
400005e0:	4000e7b7          	lui	a5,0x4000e
400005e4:	5a97c583          	lbu	a1,1449(a5) # 4000e5a9 <Ch_1_Glob>
400005e8:	4000d537          	lui	a0,0x4000d
400005ec:	1a850513          	addi	a0,a0,424 # 4000d1a8 <__clzsi2+0x220>
  printf ("\n");
400005f0:	7d5000ef          	jal	ra,400015c4 <printf>
400005f4:	4000da37          	lui	s4,0x4000d
400005f8:	04100593          	li	a1,65
400005fc:	1c4a0513          	addi	a0,s4,452 # 4000d1c4 <__clzsi2+0x23c>
  printf ("Final values of the variables used in the benchmark:\n");
40000600:	7c5000ef          	jal	ra,400015c4 <printf>
40000604:	5a84c583          	lbu	a1,1448(s1)
40000608:	4000d537          	lui	a0,0x4000d
4000060c:	1e050513          	addi	a0,a0,480 # 4000d1e0 <__clzsi2+0x258>
  printf ("\n");
40000610:	7b5000ef          	jal	ra,400015c4 <printf>
40000614:	04200593          	li	a1,66
40000618:	1c4a0513          	addi	a0,s4,452
4000061c:	7a9000ef          	jal	ra,400015c4 <printf>
  printf ("Int_Glob:            %d\n", Int_Glob);
40000620:	400107b7          	lui	a5,0x40010
40000624:	5d878793          	addi	a5,a5,1496 # 400105d8 <Arr_2_Glob+0x2000>
40000628:	7307a583          	lw	a1,1840(a5)
  printf ("        should be:   %d\n", 5);
4000062c:	4000d537          	lui	a0,0x4000d
  printf ("Int_Glob:            %d\n", Int_Glob);
40000630:	1fc50513          	addi	a0,a0,508 # 4000d1fc <__clzsi2+0x274>
40000634:	791000ef          	jal	ra,400015c4 <printf>
  printf ("        should be:   %d\n", 5);
40000638:	00700593          	li	a1,7
4000063c:	17098513          	addi	a0,s3,368
40000640:	785000ef          	jal	ra,400015c4 <printf>
40000644:	4000e7b7          	lui	a5,0x4000e
  printf ("Bool_Glob:           %d\n", Bool_Glob);
40000648:	5d878793          	addi	a5,a5,1496 # 4000e5d8 <Arr_2_Glob>
4000064c:	65c7a583          	lw	a1,1628(a5)
40000650:	4000d537          	lui	a0,0x4000d
40000654:	21850513          	addi	a0,a0,536 # 4000d218 <__clzsi2+0x290>
40000658:	76d000ef          	jal	ra,400015c4 <printf>
4000065c:	4000d537          	lui	a0,0x4000d
  printf ("        should be:   %d\n", 1);
40000660:	23450513          	addi	a0,a0,564 # 4000d234 <__clzsi2+0x2ac>
40000664:	761000ef          	jal	ra,400015c4 <printf>
40000668:	4000d537          	lui	a0,0x4000d
4000066c:	26050513          	addi	a0,a0,608 # 4000d260 <__clzsi2+0x2d8>
  printf ("Ch_1_Glob:           %c\n", Ch_1_Glob);
40000670:	755000ef          	jal	ra,400015c4 <printf>
40000674:	4000e7b7          	lui	a5,0x4000e
40000678:	5b87a783          	lw	a5,1464(a5) # 4000e5b8 <Ptr_Glob>
4000067c:	4000dd37          	lui	s10,0x4000d
40000680:	26cd0513          	addi	a0,s10,620 # 4000d26c <__clzsi2+0x2e4>
40000684:	0007a583          	lw	a1,0(a5)
  printf ("        should be:   %c\n", 'A');
40000688:	4000dbb7          	lui	s7,0x4000d
4000068c:	4000db37          	lui	s6,0x4000d
40000690:	735000ef          	jal	ra,400015c4 <printf>
40000694:	4000d537          	lui	a0,0x4000d
40000698:	28850513          	addi	a0,a0,648 # 4000d288 <__clzsi2+0x300>
  printf ("Ch_2_Glob:           %c\n", Ch_2_Glob);
4000069c:	729000ef          	jal	ra,400015c4 <printf>
400006a0:	4000e7b7          	lui	a5,0x4000e
400006a4:	5b87a783          	lw	a5,1464(a5) # 4000e5b8 <Ptr_Glob>
400006a8:	2bcb8513          	addi	a0,s7,700 # 4000d2bc <__clzsi2+0x334>
400006ac:	4000dab7          	lui	s5,0x4000d
  printf ("        should be:   %c\n", 'B');
400006b0:	0047a583          	lw	a1,4(a5)
400006b4:	4000da37          	lui	s4,0x4000d
400006b8:	4000d4b7          	lui	s1,0x4000d
400006bc:	709000ef          	jal	ra,400015c4 <printf>
  printf ("Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
400006c0:	00000593          	li	a1,0
400006c4:	17098513          	addi	a0,s3,368
400006c8:	6fd000ef          	jal	ra,400015c4 <printf>
400006cc:	4000e7b7          	lui	a5,0x4000e
400006d0:	5b87a783          	lw	a5,1464(a5) # 4000e5b8 <Ptr_Glob>
400006d4:	2d8b0513          	addi	a0,s6,728 # 4000d2d8 <__clzsi2+0x350>
400006d8:	4000ec37          	lui	s8,0x4000e
  printf ("        should be:   %d\n", 7);
400006dc:	0087a583          	lw	a1,8(a5)
400006e0:	6e5000ef          	jal	ra,400015c4 <printf>
400006e4:	00200593          	li	a1,2
400006e8:	17098513          	addi	a0,s3,368
  printf ("Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
400006ec:	6d9000ef          	jal	ra,400015c4 <printf>
400006f0:	4000e7b7          	lui	a5,0x4000e
400006f4:	5b87a783          	lw	a5,1464(a5) # 4000e5b8 <Ptr_Glob>
400006f8:	2f4a8513          	addi	a0,s5,756 # 4000d2f4 <__clzsi2+0x36c>
400006fc:	00c7a583          	lw	a1,12(a5)
40000700:	6c5000ef          	jal	ra,400015c4 <printf>
40000704:	01100593          	li	a1,17
  printf ("        should be:   Number_Of_Runs + 10\n");
40000708:	17098513          	addi	a0,s3,368
4000070c:	6b9000ef          	jal	ra,400015c4 <printf>
40000710:	4000e7b7          	lui	a5,0x4000e
40000714:	5b87a583          	lw	a1,1464(a5) # 4000e5b8 <Ptr_Glob>
  printf ("Ptr_Glob->\n");
40000718:	310a0513          	addi	a0,s4,784 # 4000d310 <__clzsi2+0x388>
4000071c:	01058593          	addi	a1,a1,16
40000720:	6a5000ef          	jal	ra,400015c4 <printf>
40000724:	32c48513          	addi	a0,s1,812 # 4000d32c <__clzsi2+0x3a4>
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
40000728:	69d000ef          	jal	ra,400015c4 <printf>
4000072c:	4000d537          	lui	a0,0x4000d
40000730:	36450513          	addi	a0,a0,868 # 4000d364 <__clzsi2+0x3dc>
40000734:	691000ef          	jal	ra,400015c4 <printf>
40000738:	4000e7b7          	lui	a5,0x4000e
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
4000073c:	5b47a783          	lw	a5,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
40000740:	26cd0513          	addi	a0,s10,620
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
40000744:	0007a583          	lw	a1,0(a5)
40000748:	67d000ef          	jal	ra,400015c4 <printf>
  printf ("        should be:   (implementation-dependent)\n");
4000074c:	4000d537          	lui	a0,0x4000d
40000750:	37850513          	addi	a0,a0,888 # 4000d378 <__clzsi2+0x3f0>
40000754:	671000ef          	jal	ra,400015c4 <printf>
40000758:	4000e7b7          	lui	a5,0x4000e
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
4000075c:	5b47a783          	lw	a5,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
40000760:	2bcb8513          	addi	a0,s7,700
40000764:	0047a583          	lw	a1,4(a5)
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
40000768:	65d000ef          	jal	ra,400015c4 <printf>
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
4000076c:	00000593          	li	a1,0
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
40000770:	17098513          	addi	a0,s3,368
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
40000774:	651000ef          	jal	ra,400015c4 <printf>
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
40000778:	4000e7b7          	lui	a5,0x4000e
4000077c:	5b47a783          	lw	a5,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
  printf ("        should be:   %d\n", 0);
40000780:	2d8b0513          	addi	a0,s6,728
40000784:	0087a583          	lw	a1,8(a5)
40000788:	63d000ef          	jal	ra,400015c4 <printf>
4000078c:	00100593          	li	a1,1
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
40000790:	17098513          	addi	a0,s3,368
40000794:	631000ef          	jal	ra,400015c4 <printf>
40000798:	4000e7b7          	lui	a5,0x4000e
  User_Time = End_Time - Begin_Time;
4000079c:	5b47a783          	lw	a5,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
400007a0:	2f4a8513          	addi	a0,s5,756
400007a4:	00c7a583          	lw	a1,12(a5)
400007a8:	61d000ef          	jal	ra,400015c4 <printf>
  printf ("        should be:   %d\n", 2);
400007ac:	01200593          	li	a1,18
400007b0:	17098513          	addi	a0,s3,368
400007b4:	611000ef          	jal	ra,400015c4 <printf>
400007b8:	4000e7b7          	lui	a5,0x4000e
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
400007bc:	5b47a583          	lw	a1,1460(a5) # 4000e5b4 <Next_Ptr_Glob>
400007c0:	310a0513          	addi	a0,s4,784
400007c4:	01058593          	addi	a1,a1,16
400007c8:	5fd000ef          	jal	ra,400015c4 <printf>
400007cc:	32c48513          	addi	a0,s1,812
400007d0:	5f5000ef          	jal	ra,400015c4 <printf>
  printf ("        should be:   %d\n", 17);
400007d4:	01412583          	lw	a1,20(sp)
400007d8:	4000d537          	lui	a0,0x4000d
400007dc:	3b850513          	addi	a0,a0,952 # 4000d3b8 <__clzsi2+0x430>
400007e0:	5e5000ef          	jal	ra,400015c4 <printf>
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
400007e4:	00500593          	li	a1,5
400007e8:	17098513          	addi	a0,s3,368
400007ec:	5d9000ef          	jal	ra,400015c4 <printf>
400007f0:	00812783          	lw	a5,8(sp)
400007f4:	4000d537          	lui	a0,0x4000d
400007f8:	3d450513          	addi	a0,a0,980 # 4000d3d4 <__clzsi2+0x44c>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
400007fc:	41278933          	sub	s2,a5,s2
40000800:	00391793          	slli	a5,s2,0x3
40000804:	41278933          	sub	s2,a5,s2
  printf ("Next_Ptr_Glob->\n");
40000808:	408905b3          	sub	a1,s2,s0
4000080c:	5b9000ef          	jal	ra,400015c4 <printf>
40000810:	00d00593          	li	a1,13
40000814:	17098513          	addi	a0,s3,368
  printf ("  Ptr_Comp:          %d\n", (int) Next_Ptr_Glob->Ptr_Comp);
40000818:	5ad000ef          	jal	ra,400015c4 <printf>
4000081c:	01812583          	lw	a1,24(sp)
40000820:	4000d537          	lui	a0,0x4000d
40000824:	3f050513          	addi	a0,a0,1008 # 4000d3f0 <__clzsi2+0x468>
40000828:	59d000ef          	jal	ra,400015c4 <printf>
4000082c:	00700593          	li	a1,7
  printf ("        should be:   (implementation-dependent), same as above\n");
40000830:	17098513          	addi	a0,s3,368
40000834:	591000ef          	jal	ra,400015c4 <printf>
40000838:	01c12583          	lw	a1,28(sp)
4000083c:	4000d537          	lui	a0,0x4000d
  printf ("  Discr:             %d\n", Next_Ptr_Glob->Discr);
40000840:	40c50513          	addi	a0,a0,1036 # 4000d40c <__clzsi2+0x484>
40000844:	581000ef          	jal	ra,400015c4 <printf>
40000848:	00100593          	li	a1,1
4000084c:	17098513          	addi	a0,s3,368
40000850:	575000ef          	jal	ra,400015c4 <printf>
40000854:	4000d537          	lui	a0,0x4000d
  printf ("        should be:   %d\n", 0);
40000858:	02010593          	addi	a1,sp,32
4000085c:	42850513          	addi	a0,a0,1064 # 4000d428 <__clzsi2+0x4a0>
40000860:	565000ef          	jal	ra,400015c4 <printf>
40000864:	4000d537          	lui	a0,0x4000d
  printf ("  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
40000868:	44450513          	addi	a0,a0,1092 # 4000d444 <__clzsi2+0x4bc>
4000086c:	559000ef          	jal	ra,400015c4 <printf>
40000870:	4000d537          	lui	a0,0x4000d
40000874:	04010593          	addi	a1,sp,64
40000878:	47c50513          	addi	a0,a0,1148 # 4000d47c <__clzsi2+0x4f4>
4000087c:	549000ef          	jal	ra,400015c4 <printf>
  printf ("        should be:   %d\n", 1);
40000880:	4000d537          	lui	a0,0x4000d
40000884:	49850513          	addi	a0,a0,1176 # 4000d498 <__clzsi2+0x510>
40000888:	53d000ef          	jal	ra,400015c4 <printf>
4000088c:	4000d7b7          	lui	a5,0x4000d
  printf ("  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
40000890:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
40000894:	531000ef          	jal	ra,400015c4 <printf>
40000898:	4000e7b7          	lui	a5,0x4000e
4000089c:	5a07a703          	lw	a4,1440(a5) # 4000e5a0 <Begin_Time>
400008a0:	59cca583          	lw	a1,1436(s9)
400008a4:	1f300793          	li	a5,499
  printf ("        should be:   %d\n", 18);
400008a8:	40e585b3          	sub	a1,a1,a4
400008ac:	58bc2c23          	sw	a1,1432(s8) # 4000e598 <User_Time>
400008b0:	10b7d263          	ble	a1,a5,400009b4 <main2+0x7a8>
400008b4:	4000d537          	lui	a0,0x4000d
                                Next_Ptr_Glob->variant.var_1.Str_Comp);
400008b8:	52850513          	addi	a0,a0,1320 # 4000d528 <__clzsi2+0x5a0>
400008bc:	509000ef          	jal	ra,400015c4 <printf>
  printf ("  Str_Comp:          %s\n",
400008c0:	598c2503          	lw	a0,1432(s8)
400008c4:	4000e937          	lui	s2,0x4000e
400008c8:	4000e4b7          	lui	s1,0x4000e
400008cc:	3ec090ef          	jal	ra,40009cb8 <__floatsisf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
400008d0:	00050993          	mv	s3,a0
400008d4:	6b10b0ef          	jal	ra,4000c784 <__extendsfdf2>
400008d8:	4000e7b7          	lui	a5,0x4000e
  printf ("Int_1_Loc:           %d\n", Int_1_Loc);
400008dc:	c387a603          	lw	a2,-968(a5) # 4000dc38 <__clz_tab+0x104>
400008e0:	c3c7a683          	lw	a3,-964(a5)
400008e4:	4000d437          	lui	s0,0x4000d
400008e8:	2790a0ef          	jal	ra,4000b360 <__muldf3>
400008ec:	7cd0b0ef          	jal	ra,4000c8b8 <__truncdfsf2>
  printf ("        should be:   %d\n", 5);
400008f0:	4000e7b7          	lui	a5,0x4000e
400008f4:	58a92a23          	sw	a0,1428(s2) # 4000e594 <Microseconds>
400008f8:	c347a503          	lw	a0,-972(a5) # 4000dc34 <__clz_tab+0x100>
400008fc:	00098593          	mv	a1,s3
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
40000900:	6d9080ef          	jal	ra,400097d8 <__divsf3>
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
40000904:	58a4a823          	sw	a0,1424(s1) # 4000e590 <_edata>
40000908:	4000d537          	lui	a0,0x4000d
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
4000090c:	53850513          	addi	a0,a0,1336 # 4000d538 <__clzsi2+0x5b0>
40000910:	4b5000ef          	jal	ra,400015c4 <printf>
40000914:	59492503          	lw	a0,1428(s2)
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
40000918:	66d0b0ef          	jal	ra,4000c784 <__extendsfdf2>
4000091c:	00050613          	mv	a2,a0
40000920:	00058693          	mv	a3,a1
  printf ("        should be:   %d\n", 13);
40000924:	56840513          	addi	a0,s0,1384 # 4000d568 <__clzsi2+0x5e0>
40000928:	49d000ef          	jal	ra,400015c4 <printf>
4000092c:	4000d537          	lui	a0,0x4000d
40000930:	57050513          	addi	a0,a0,1392 # 4000d570 <__clzsi2+0x5e8>
  printf ("Int_3_Loc:           %d\n", Int_3_Loc);
40000934:	491000ef          	jal	ra,400015c4 <printf>
40000938:	5904a503          	lw	a0,1424(s1)
4000093c:	6490b0ef          	jal	ra,4000c784 <__extendsfdf2>
40000940:	00050613          	mv	a2,a0
40000944:	00058693          	mv	a3,a1
  printf ("        should be:   %d\n", 7);
40000948:	56840513          	addi	a0,s0,1384
4000094c:	479000ef          	jal	ra,400015c4 <printf>
40000950:	4000d7b7          	lui	a5,0x4000d
40000954:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
  printf ("Enum_Loc:            %d\n", Enum_Loc);
40000958:	46d000ef          	jal	ra,400015c4 <printf>
4000095c:	09c12083          	lw	ra,156(sp)
40000960:	09812403          	lw	s0,152(sp)
40000964:	09412483          	lw	s1,148(sp)
40000968:	09012903          	lw	s2,144(sp)
  printf ("        should be:   %d\n", 1);
4000096c:	08c12983          	lw	s3,140(sp)
40000970:	08812a03          	lw	s4,136(sp)
40000974:	08412a83          	lw	s5,132(sp)
40000978:	08012b03          	lw	s6,128(sp)
  printf ("Str_1_Loc:           %s\n", Str_1_Loc);
4000097c:	07c12b83          	lw	s7,124(sp)
40000980:	07812c03          	lw	s8,120(sp)
40000984:	07412c83          	lw	s9,116(sp)
40000988:	07012d03          	lw	s10,112(sp)
4000098c:	06c12d83          	lw	s11,108(sp)
  printf ("        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
40000990:	0a010113          	addi	sp,sp,160
40000994:	00008067          	ret
40000998:	4000d537          	lui	a0,0x4000d
4000099c:	07450513          	addi	a0,a0,116 # 4000d074 <__clzsi2+0xec>
  printf ("Str_2_Loc:           %s\n", Str_2_Loc);
400009a0:	425000ef          	jal	ra,400015c4 <printf>
400009a4:	4000d7b7          	lui	a5,0x4000d
400009a8:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
400009ac:	419000ef          	jal	ra,400015c4 <printf>
400009b0:	9a5ff06f          	j	40000354 <main2+0x148>
  printf ("        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
400009b4:	4000d537          	lui	a0,0x4000d
400009b8:	4d050513          	addi	a0,a0,1232 # 4000d4d0 <__clzsi2+0x548>
400009bc:	409000ef          	jal	ra,400015c4 <printf>
400009c0:	4000d537          	lui	a0,0x4000d
  printf ("\n");
400009c4:	50850513          	addi	a0,a0,1288 # 4000d508 <__clzsi2+0x580>
400009c8:	3fd000ef          	jal	ra,400015c4 <printf>
400009cc:	4000d7b7          	lui	a5,0x4000d
400009d0:	25c78513          	addi	a0,a5,604 # 4000d25c <__clzsi2+0x2d4>
  User_Time = End_Time - Begin_Time;
400009d4:	3f1000ef          	jal	ra,400015c4 <printf>
400009d8:	f85ff06f          	j	4000095c <main2+0x750>

400009dc <Proc_7>:
One_Fifty       Int_2_Par_Val;
One_Fifty      *Int_Par_Ref;
{
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 2;
400009dc:	00250513          	addi	a0,a0,2
  *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
400009e0:	00b505b3          	add	a1,a0,a1
400009e4:	00b62023          	sw	a1,0(a2)
} /* Proc_7 */
400009e8:	00008067          	ret

400009ec <Proc_8>:
    /* Int_Par_Val_2 == 7 */
Arr_1_Dim       Arr_1_Par_Ref;
Arr_2_Dim       Arr_2_Par_Ref;
int             Int_1_Par_Val;
int             Int_2_Par_Val;
{
400009ec:	fe010113          	addi	sp,sp,-32
400009f0:	01312623          	sw	s3,12(sp)
  REG One_Fifty Int_Index;
  REG One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 5;
400009f4:	00560993          	addi	s3,a2,5
{
400009f8:	00912a23          	sw	s1,20(sp)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
400009fc:	00299493          	slli	s1,s3,0x2
{
40000a00:	00112e23          	sw	ra,28(sp)
40000a04:	00812c23          	sw	s0,24(sp)
40000a08:	01212823          	sw	s2,16(sp)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
40000a0c:	009504b3          	add	s1,a0,s1
{
40000a10:	00058413          	mv	s0,a1
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
40000a14:	0734ac23          	sw	s3,120(s1)
{
40000a18:	00060913          	mv	s2,a2
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
40000a1c:	00d4a023          	sw	a3,0(s1)
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
40000a20:	00d4a223          	sw	a3,4(s1)
40000a24:	00098513          	mv	a0,s3
40000a28:	0c800593          	li	a1,200
40000a2c:	4840c0ef          	jal	ra,4000ceb0 <__mulsi3>
40000a30:	00291913          	slli	s2,s2,0x2
40000a34:	012507b3          	add	a5,a0,s2
40000a38:	00f407b3          	add	a5,s0,a5
40000a3c:	0107a703          	lw	a4,16(a5)
  for (Int_Index = Int_Loc; Int_Index <= Int_Loc+1; ++Int_Index)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
40000a40:	0137aa23          	sw	s3,20(a5)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
40000a44:	0137ac23          	sw	s3,24(a5)
40000a48:	00170713          	addi	a4,a4,1
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
40000a4c:	00e7a823          	sw	a4,16(a5)
40000a50:	0004a703          	lw	a4,0(s1)
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
40000a54:	00a40433          	add	s0,s0,a0
40000a58:	01240433          	add	s0,s0,s2
40000a5c:	000017b7          	lui	a5,0x1
40000a60:	01c12083          	lw	ra,28(sp)
  Int_Glob = 5;
} /* Proc_8 */
40000a64:	00878433          	add	s0,a5,s0
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
40000a68:	fae42a23          	sw	a4,-76(s0)
40000a6c:	4000e7b7          	lui	a5,0x4000e
  Int_Glob = 5;
40000a70:	00500713          	li	a4,5
40000a74:	01812403          	lw	s0,24(sp)
} /* Proc_8 */
40000a78:	01412483          	lw	s1,20(sp)
40000a7c:	01012903          	lw	s2,16(sp)
40000a80:	00c12983          	lw	s3,12(sp)
40000a84:	5ae7a823          	sw	a4,1456(a5) # 4000e5b0 <Int_Glob>
  Int_Glob = 5;
40000a88:	02010113          	addi	sp,sp,32
} /* Proc_8 */
40000a8c:	00008067          	ret

40000a90 <Func_1>:
40000a90:	0ff57513          	andi	a0,a0,255
    /* second call:     Ch_1_Par_Val == 'A', Ch_2_Par_Val == 'C'    */
    /* third call:      Ch_1_Par_Val == 'B', Ch_2_Par_Val == 'C'    */

Capital_Letter   Ch_1_Par_Val;
Capital_Letter   Ch_2_Par_Val;
{
40000a94:	0ff5f593          	andi	a1,a1,255
40000a98:	00b50663          	beq	a0,a1,40000aa4 <Func_1+0x14>
  Capital_Letter        Ch_1_Loc;
  Capital_Letter        Ch_2_Loc;

  Ch_1_Loc = Ch_1_Par_Val;
  Ch_2_Loc = Ch_1_Loc;
  if (Ch_2_Loc != Ch_2_Par_Val)
40000a9c:	00000513          	li	a0,0
    /* then, executed */
    return (Ident_1);
40000aa0:	00008067          	ret
  else  /* not executed */
  {
    Ch_1_Glob = Ch_1_Loc;
    return (Ident_2);
   }
} /* Func_1 */
40000aa4:	4000e7b7          	lui	a5,0x4000e
    Ch_1_Glob = Ch_1_Loc;
40000aa8:	5aa784a3          	sb	a0,1449(a5) # 4000e5a9 <Ch_1_Glob>
40000aac:	00100513          	li	a0,1
    return (Ident_2);
40000ab0:	00008067          	ret

40000ab4 <Func_2>:
40000ab4:	ff010113          	addi	sp,sp,-16
    /* Str_1_Par_Ref == "DHRYSTONE PROGRAM, 1'ST STRING" */
    /* Str_2_Par_Ref == "DHRYSTONE PROGRAM, 2'ND STRING" */

Str_30  Str_1_Par_Ref;
Str_30  Str_2_Par_Ref;
{
40000ab8:	00812423          	sw	s0,8(sp)
40000abc:	00912223          	sw	s1,4(sp)
40000ac0:	00112623          	sw	ra,12(sp)
40000ac4:	00050413          	mv	s0,a0
40000ac8:	00058493          	mv	s1,a1
40000acc:	0034c583          	lbu	a1,3(s1)
  REG One_Thirty        Int_Loc;
      Capital_Letter    Ch_Loc;

  Int_Loc = 2;
  while (Int_Loc <= 2) /* loop body executed once */
    if (Func_1 (Str_1_Par_Ref[Int_Loc],
40000ad0:	00244503          	lbu	a0,2(s0)
40000ad4:	fbdff0ef          	jal	ra,40000a90 <Func_1>
40000ad8:	fe051ae3          	bnez	a0,40000acc <Func_2+0x18>
40000adc:	00048593          	mv	a1,s1
40000ae0:	00040513          	mv	a0,s0
  if (Ch_Loc == 'R')
    /* then, not executed */
    return (true);
  else /* executed */
  {
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
40000ae4:	395000ef          	jal	ra,40001678 <strcmp>
40000ae8:	02a05463          	blez	a0,40000b10 <Func_2+0x5c>
40000aec:	00c12083          	lw	ra,12(sp)
40000af0:	00a00713          	li	a4,10
40000af4:	4000e7b7          	lui	a5,0x4000e
      return (true);
    }
    else /* executed */
      return (false);
  } /* if Ch_Loc */
} /* Func_2 */
40000af8:	00100513          	li	a0,1
      Int_Glob = Int_Loc;
40000afc:	00812403          	lw	s0,8(sp)
40000b00:	00412483          	lw	s1,4(sp)
      return (true);
40000b04:	5ae7a823          	sw	a4,1456(a5) # 4000e5b0 <Int_Glob>
} /* Func_2 */
40000b08:	01010113          	addi	sp,sp,16
40000b0c:	00008067          	ret
      Int_Glob = Int_Loc;
40000b10:	00c12083          	lw	ra,12(sp)
} /* Func_2 */
40000b14:	00000513          	li	a0,0
40000b18:	00812403          	lw	s0,8(sp)
40000b1c:	00412483          	lw	s1,4(sp)
      return (false);
40000b20:	01010113          	addi	sp,sp,16
} /* Func_2 */
40000b24:	00008067          	ret

40000b28 <Func_3>:
40000b28:	ffe50513          	addi	a0,a0,-2
40000b2c:	00153513          	seqz	a0,a0
40000b30:	00008067          	ret

40000b34 <Proc_6>:
Enumeration Enum_Par_Val;
{
  Enumeration Enum_Loc;

  Enum_Loc = Enum_Par_Val;
  if (Enum_Loc == Ident_3)
40000b34:	ff010113          	addi	sp,sp,-16
    /* then, executed */
    return (true);
  else /* not executed */
    return (false);
} /* Func_3 */
40000b38:	00812423          	sw	s0,8(sp)
40000b3c:	00912223          	sw	s1,4(sp)
{
40000b40:	00112623          	sw	ra,12(sp)
40000b44:	00050413          	mv	s0,a0
40000b48:	00058493          	mv	s1,a1
40000b4c:	fddff0ef          	jal	ra,40000b28 <Func_3>
40000b50:	02050e63          	beqz	a0,40000b8c <Proc_6+0x58>
40000b54:	0084a023          	sw	s0,0(s1)
  if (! Func_3 (Enum_Val_Par))
40000b58:	00100793          	li	a5,1
40000b5c:	04f40063          	beq	s0,a5,40000b9c <Proc_6+0x68>
40000b60:	04040663          	beqz	s0,40000bac <Proc_6+0x78>
  *Enum_Ref_Par = Enum_Val_Par;
40000b64:	00200713          	li	a4,2
  switch (Enum_Val_Par)
40000b68:	04e40e63          	beq	s0,a4,40000bc4 <Proc_6+0x90>
40000b6c:	00400793          	li	a5,4
40000b70:	00f41463          	bne	s0,a5,40000b78 <Proc_6+0x44>
40000b74:	00e4a023          	sw	a4,0(s1)
40000b78:	00c12083          	lw	ra,12(sp)
40000b7c:	00812403          	lw	s0,8(sp)
40000b80:	00412483          	lw	s1,4(sp)
      *Enum_Ref_Par = Ident_3;
40000b84:	01010113          	addi	sp,sp,16
} /* Proc_6 */
40000b88:	00008067          	ret
40000b8c:	00300793          	li	a5,3
40000b90:	00f4a023          	sw	a5,0(s1)
40000b94:	00100793          	li	a5,1
40000b98:	fcf414e3          	bne	s0,a5,40000b60 <Proc_6+0x2c>
    *Enum_Ref_Par = Ident_4;
40000b9c:	4000e7b7          	lui	a5,0x4000e
40000ba0:	5b07a703          	lw	a4,1456(a5) # 4000e5b0 <Int_Glob>
  switch (Enum_Val_Par)
40000ba4:	06400793          	li	a5,100
40000ba8:	02e7da63          	ble	a4,a5,40000bdc <Proc_6+0xa8>
      if (Int_Glob > 100)
40000bac:	00c12083          	lw	ra,12(sp)
40000bb0:	0004a023          	sw	zero,0(s1)
40000bb4:	00812403          	lw	s0,8(sp)
40000bb8:	00412483          	lw	s1,4(sp)
} /* Proc_6 */
40000bbc:	01010113          	addi	sp,sp,16
      *Enum_Ref_Par = Ident_1;
40000bc0:	00008067          	ret
} /* Proc_6 */
40000bc4:	00c12083          	lw	ra,12(sp)
40000bc8:	00f4a023          	sw	a5,0(s1)
40000bcc:	00812403          	lw	s0,8(sp)
40000bd0:	00412483          	lw	s1,4(sp)
40000bd4:	01010113          	addi	sp,sp,16
      *Enum_Ref_Par = Ident_2;
40000bd8:	00008067          	ret
} /* Proc_6 */
40000bdc:	00c12083          	lw	ra,12(sp)
40000be0:	00300793          	li	a5,3
40000be4:	00f4a023          	sw	a5,0(s1)
40000be8:	00812403          	lw	s0,8(sp)
40000bec:	00412483          	lw	s1,4(sp)
      else *Enum_Ref_Par = Ident_4;
40000bf0:	01010113          	addi	sp,sp,16
40000bf4:	00008067          	ret

40000bf8 <isatty.constprop.0>:
	return 0;
}

int isatty(int fd) {
	return 0;
}
40000bf8:	00000513          	li	a0,0
40000bfc:	00008067          	ret

40000c00 <close>:
40000c00:	ff9ff06f          	j	40000bf8 <isatty.constprop.0>

40000c04 <fstat>:
40000c04:	00000513          	li	a0,0
}
40000c08:	00008067          	ret

40000c0c <isatty>:
40000c0c:	00000513          	li	a0,0
}
40000c10:	00008067          	ret

40000c14 <lseek>:
40000c14:	00000513          	li	a0,0

long lseek(int fd, long offset, int origin) {
	return 0;
}
40000c18:	00008067          	ret

40000c1c <read>:
40000c1c:	00000513          	li	a0,0

int read(int fd, void *buffer, unsigned int count) {
	return 0;
}
40000c20:	00008067          	ret

40000c24 <writeChar>:
40000c24:	f01007b7          	lui	a5,0xf0100

extern UartCtrl *uartStdio;
void writeChar(char value) {
	TEST_COM_BASE[0] = value;
40000c28:	f0a7a023          	sw	a0,-256(a5) # f00fff00 <end+0xb00ef120>
40000c2c:	00008067          	ret

40000c30 <writeChars>:
40000c30:	ff010113          	addi	sp,sp,-16
}

void writeChars(char* value) {
40000c34:	00812423          	sw	s0,8(sp)
40000c38:	00112623          	sw	ra,12(sp)
40000c3c:	00050413          	mv	s0,a0
40000c40:	00054503          	lbu	a0,0(a0)
	while (*value) {
40000c44:	00050a63          	beqz	a0,40000c58 <writeChars+0x28>
40000c48:	00140413          	addi	s0,s0,1
		writeChar(*(value++));
40000c4c:	fd9ff0ef          	jal	ra,40000c24 <writeChar>
40000c50:	00044503          	lbu	a0,0(s0)
40000c54:	fe051ae3          	bnez	a0,40000c48 <writeChars+0x18>
	while (*value) {
40000c58:	00c12083          	lw	ra,12(sp)
40000c5c:	00812403          	lw	s0,8(sp)
	}
}
40000c60:	01010113          	addi	sp,sp,16
40000c64:	00008067          	ret

40000c68 <write>:
40000c68:	ff010113          	addi	sp,sp,-16
40000c6c:	00912223          	sw	s1,4(sp)

int write(int fd, const void *buffer, unsigned int count) {
40000c70:	01212023          	sw	s2,0(sp)
40000c74:	00112623          	sw	ra,12(sp)
40000c78:	00812423          	sw	s0,8(sp)
40000c7c:	00060913          	mv	s2,a2
40000c80:	00c584b3          	add	s1,a1,a2
40000c84:	00060c63          	beqz	a2,40000c9c <write+0x34>
40000c88:	00058413          	mv	s0,a1
	for (int idx = 0; idx < count; idx++) {
40000c8c:	00044503          	lbu	a0,0(s0)
40000c90:	00140413          	addi	s0,s0,1
		writeChar(((char*) buffer)[idx]);
40000c94:	f91ff0ef          	jal	ra,40000c24 <writeChar>
40000c98:	fe849ae3          	bne	s1,s0,40000c8c <write+0x24>
40000c9c:	00c12083          	lw	ra,12(sp)
40000ca0:	00090513          	mv	a0,s2
	for (int idx = 0; idx < count; idx++) {
40000ca4:	00812403          	lw	s0,8(sp)
	}
	return count;
}
40000ca8:	00412483          	lw	s1,4(sp)
40000cac:	00012903          	lw	s2,0(sp)
40000cb0:	01010113          	addi	sp,sp,16
40000cb4:	00008067          	ret

40000cb8 <irqCpp>:
40000cb8:	00008067          	ret

40000cbc <times>:
40000cbc:	f01007b7          	lui	a5,0xf0100
40000cc0:	f107a503          	lw	a0,-240(a5) # f00fff10 <end+0xb00ef130>

	TEST_COM_BASE[8] = 0;
}


void irqCpp(uint32_t irq){
40000cc4:	00008067          	ret

40000cc8 <clock>:

}


int     times (){
  return TEST_COM_BASE[4];
40000cc8:	ff5ff06f          	j	40000cbc <times>

40000ccc <main>:
40000ccc:	ff010113          	addi	sp,sp,-16
}
40000cd0:	00112623          	sw	ra,12(sp)
#include <time.h>
clock_t	clock(){
  return times();
40000cd4:	d38ff0ef          	jal	ra,4000020c <main2>
40000cd8:	00c12083          	lw	ra,12(sp)
}
40000cdc:	f01007b7          	lui	a5,0xf0100
	TEST_COM_BASE[8] = 0;
40000ce0:	00000513          	li	a0,0
}
40000ce4:	f207a023          	sw	zero,-224(a5) # f00fff20 <end+0xb00ef140>
	TEST_COM_BASE[8] = 0;
40000ce8:	01010113          	addi	sp,sp,16
}
40000cec:	00008067          	ret

40000cf0 <malloc>:
40000cf0:	4000e7b7          	lui	a5,0x4000e
40000cf4:	00050593          	mv	a1,a0
40000cf8:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
40000cfc:	0140006f          	j	40000d10 <_malloc_r>

40000d00 <free>:
40000d00:	4000e7b7          	lui	a5,0x4000e
40000d04:	00050593          	mv	a1,a0
40000d08:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
40000d0c:	0390406f          	j	40005544 <_free_r>

40000d10 <_malloc_r>:
40000d10:	fd010113          	addi	sp,sp,-48
40000d14:	02912223          	sw	s1,36(sp)
40000d18:	01312e23          	sw	s3,28(sp)
40000d1c:	02112623          	sw	ra,44(sp)
40000d20:	02812423          	sw	s0,40(sp)
40000d24:	03212023          	sw	s2,32(sp)
40000d28:	01412c23          	sw	s4,24(sp)
40000d2c:	01512a23          	sw	s5,20(sp)
40000d30:	01612823          	sw	s6,16(sp)
40000d34:	01712623          	sw	s7,12(sp)
40000d38:	01812423          	sw	s8,8(sp)
40000d3c:	01912223          	sw	s9,4(sp)
40000d40:	00b58493          	addi	s1,a1,11
40000d44:	01600793          	li	a5,22
40000d48:	00050993          	mv	s3,a0
40000d4c:	1a97fa63          	bleu	s1,a5,40000f00 <_malloc_r+0x1f0>
40000d50:	ff84f493          	andi	s1,s1,-8
40000d54:	2404c063          	bltz	s1,40000f94 <_malloc_r+0x284>
40000d58:	22b4ee63          	bltu	s1,a1,40000f94 <_malloc_r+0x284>
40000d5c:	01d000ef          	jal	ra,40001578 <__malloc_lock>
40000d60:	1f700793          	li	a5,503
40000d64:	6e97f663          	bleu	s1,a5,40001450 <_malloc_r+0x740>
40000d68:	0094d793          	srli	a5,s1,0x9
40000d6c:	04000593          	li	a1,64
40000d70:	20000693          	li	a3,512
40000d74:	03f00513          	li	a0,63
40000d78:	22079663          	bnez	a5,40000fa4 <_malloc_r+0x294>
40000d7c:	4000e937          	lui	s2,0x4000e
40000d80:	cd090913          	addi	s2,s2,-816 # 4000dcd0 <_etext>
40000d84:	00d906b3          	add	a3,s2,a3
40000d88:	0046a403          	lw	s0,4(a3)
40000d8c:	ff868693          	addi	a3,a3,-8
40000d90:	02868c63          	beq	a3,s0,40000dc8 <_malloc_r+0xb8>
40000d94:	00442783          	lw	a5,4(s0)
40000d98:	00f00613          	li	a2,15
40000d9c:	ffc7f793          	andi	a5,a5,-4
40000da0:	40978733          	sub	a4,a5,s1
40000da4:	02e64063          	blt	a2,a4,40000dc4 <_malloc_r+0xb4>
40000da8:	22075c63          	bgez	a4,40000fe0 <_malloc_r+0x2d0>
40000dac:	00c42403          	lw	s0,12(s0)
40000db0:	00868c63          	beq	a3,s0,40000dc8 <_malloc_r+0xb8>
40000db4:	00442783          	lw	a5,4(s0)
40000db8:	ffc7f793          	andi	a5,a5,-4
40000dbc:	40978733          	sub	a4,a5,s1
40000dc0:	fee654e3          	ble	a4,a2,40000da8 <_malloc_r+0x98>
40000dc4:	00050593          	mv	a1,a0
40000dc8:	01092403          	lw	s0,16(s2)
40000dcc:	00890813          	addi	a6,s2,8
40000dd0:	45040c63          	beq	s0,a6,40001228 <_malloc_r+0x518>
40000dd4:	00442783          	lw	a5,4(s0)
40000dd8:	00f00693          	li	a3,15
40000ddc:	ffc7f793          	andi	a5,a5,-4
40000de0:	40978733          	sub	a4,a5,s1
40000de4:	42e6cc63          	blt	a3,a4,4000121c <_malloc_r+0x50c>
40000de8:	01092a23          	sw	a6,20(s2)
40000dec:	01092823          	sw	a6,16(s2)
40000df0:	1c075863          	bgez	a4,40000fc0 <_malloc_r+0x2b0>
40000df4:	1ff00713          	li	a4,511
40000df8:	3cf76263          	bltu	a4,a5,400011bc <_malloc_r+0x4ac>
40000dfc:	0037d793          	srli	a5,a5,0x3
40000e00:	00178713          	addi	a4,a5,1
40000e04:	00371713          	slli	a4,a4,0x3
40000e08:	00492503          	lw	a0,4(s2)
40000e0c:	00e90733          	add	a4,s2,a4
40000e10:	00072603          	lw	a2,0(a4)
40000e14:	4027d693          	srai	a3,a5,0x2
40000e18:	00100793          	li	a5,1
40000e1c:	00d797b3          	sll	a5,a5,a3
40000e20:	00a7e7b3          	or	a5,a5,a0
40000e24:	ff870693          	addi	a3,a4,-8
40000e28:	00d42623          	sw	a3,12(s0)
40000e2c:	00c42423          	sw	a2,8(s0)
40000e30:	00f92223          	sw	a5,4(s2)
40000e34:	00872023          	sw	s0,0(a4)
40000e38:	00862623          	sw	s0,12(a2)
40000e3c:	4025d713          	srai	a4,a1,0x2
40000e40:	00100693          	li	a3,1
40000e44:	00e696b3          	sll	a3,a3,a4
40000e48:	1ad7e263          	bltu	a5,a3,40000fec <_malloc_r+0x2dc>
40000e4c:	00f6f733          	and	a4,a3,a5
40000e50:	02071463          	bnez	a4,40000e78 <_malloc_r+0x168>
40000e54:	00169693          	slli	a3,a3,0x1
40000e58:	ffc5f593          	andi	a1,a1,-4
40000e5c:	00f6f733          	and	a4,a3,a5
40000e60:	00458593          	addi	a1,a1,4
40000e64:	00071a63          	bnez	a4,40000e78 <_malloc_r+0x168>
40000e68:	00169693          	slli	a3,a3,0x1
40000e6c:	00f6f733          	and	a4,a3,a5
40000e70:	00458593          	addi	a1,a1,4
40000e74:	fe070ae3          	beqz	a4,40000e68 <_malloc_r+0x158>
40000e78:	00f00513          	li	a0,15
40000e7c:	00359893          	slli	a7,a1,0x3
40000e80:	011908b3          	add	a7,s2,a7
40000e84:	00088613          	mv	a2,a7
40000e88:	00058313          	mv	t1,a1
40000e8c:	00c62403          	lw	s0,12(a2)
40000e90:	00861a63          	bne	a2,s0,40000ea4 <_malloc_r+0x194>
40000e94:	39c0006f          	j	40001230 <_malloc_r+0x520>
40000e98:	3a075e63          	bgez	a4,40001254 <_malloc_r+0x544>
40000e9c:	00c42403          	lw	s0,12(s0)
40000ea0:	38860863          	beq	a2,s0,40001230 <_malloc_r+0x520>
40000ea4:	00442783          	lw	a5,4(s0)
40000ea8:	ffc7f793          	andi	a5,a5,-4
40000eac:	40978733          	sub	a4,a5,s1
40000eb0:	fee554e3          	ble	a4,a0,40000e98 <_malloc_r+0x188>
40000eb4:	00c42683          	lw	a3,12(s0)
40000eb8:	00842603          	lw	a2,8(s0)
40000ebc:	0014e593          	ori	a1,s1,1
40000ec0:	00b42223          	sw	a1,4(s0)
40000ec4:	00d62623          	sw	a3,12(a2)
40000ec8:	00c6a423          	sw	a2,8(a3)
40000ecc:	009404b3          	add	s1,s0,s1
40000ed0:	00992a23          	sw	s1,20(s2)
40000ed4:	00992823          	sw	s1,16(s2)
40000ed8:	00176693          	ori	a3,a4,1
40000edc:	0104a623          	sw	a6,12(s1)
40000ee0:	0104a423          	sw	a6,8(s1)
40000ee4:	00d4a223          	sw	a3,4(s1)
40000ee8:	00f407b3          	add	a5,s0,a5
40000eec:	00098513          	mv	a0,s3
40000ef0:	00e7a023          	sw	a4,0(a5)
40000ef4:	688000ef          	jal	ra,4000157c <__malloc_unlock>
40000ef8:	00840513          	addi	a0,s0,8
40000efc:	0640006f          	j	40000f60 <_malloc_r+0x250>
40000f00:	01000493          	li	s1,16
40000f04:	08b4e863          	bltu	s1,a1,40000f94 <_malloc_r+0x284>
40000f08:	670000ef          	jal	ra,40001578 <__malloc_lock>
40000f0c:	01800793          	li	a5,24
40000f10:	00200593          	li	a1,2
40000f14:	4000e937          	lui	s2,0x4000e
40000f18:	cd090913          	addi	s2,s2,-816 # 4000dcd0 <_etext>
40000f1c:	00f907b3          	add	a5,s2,a5
40000f20:	0047a403          	lw	s0,4(a5)
40000f24:	ff878713          	addi	a4,a5,-8
40000f28:	30e40e63          	beq	s0,a4,40001244 <_malloc_r+0x534>
40000f2c:	00442783          	lw	a5,4(s0)
40000f30:	00c42683          	lw	a3,12(s0)
40000f34:	00842603          	lw	a2,8(s0)
40000f38:	ffc7f793          	andi	a5,a5,-4
40000f3c:	00f407b3          	add	a5,s0,a5
40000f40:	0047a703          	lw	a4,4(a5)
40000f44:	00d62623          	sw	a3,12(a2)
40000f48:	00c6a423          	sw	a2,8(a3)
40000f4c:	00176713          	ori	a4,a4,1
40000f50:	00098513          	mv	a0,s3
40000f54:	00e7a223          	sw	a4,4(a5)
40000f58:	624000ef          	jal	ra,4000157c <__malloc_unlock>
40000f5c:	00840513          	addi	a0,s0,8
40000f60:	02c12083          	lw	ra,44(sp)
40000f64:	02812403          	lw	s0,40(sp)
40000f68:	02412483          	lw	s1,36(sp)
40000f6c:	02012903          	lw	s2,32(sp)
40000f70:	01c12983          	lw	s3,28(sp)
40000f74:	01812a03          	lw	s4,24(sp)
40000f78:	01412a83          	lw	s5,20(sp)
40000f7c:	01012b03          	lw	s6,16(sp)
40000f80:	00c12b83          	lw	s7,12(sp)
40000f84:	00812c03          	lw	s8,8(sp)
40000f88:	00412c83          	lw	s9,4(sp)
40000f8c:	03010113          	addi	sp,sp,48
40000f90:	00008067          	ret
40000f94:	00c00793          	li	a5,12
40000f98:	00f9a023          	sw	a5,0(s3)
40000f9c:	00000513          	li	a0,0
40000fa0:	fc1ff06f          	j	40000f60 <_malloc_r+0x250>
40000fa4:	00400713          	li	a4,4
40000fa8:	1ef76863          	bltu	a4,a5,40001198 <_malloc_r+0x488>
40000fac:	0064d513          	srli	a0,s1,0x6
40000fb0:	03950593          	addi	a1,a0,57
40000fb4:	00359693          	slli	a3,a1,0x3
40000fb8:	03850513          	addi	a0,a0,56
40000fbc:	dc1ff06f          	j	40000d7c <_malloc_r+0x6c>
40000fc0:	00f407b3          	add	a5,s0,a5
40000fc4:	0047a703          	lw	a4,4(a5)
40000fc8:	00098513          	mv	a0,s3
40000fcc:	00176713          	ori	a4,a4,1
40000fd0:	00e7a223          	sw	a4,4(a5)
40000fd4:	5a8000ef          	jal	ra,4000157c <__malloc_unlock>
40000fd8:	00840513          	addi	a0,s0,8
40000fdc:	f85ff06f          	j	40000f60 <_malloc_r+0x250>
40000fe0:	00c42683          	lw	a3,12(s0)
40000fe4:	00842603          	lw	a2,8(s0)
40000fe8:	f55ff06f          	j	40000f3c <_malloc_r+0x22c>
40000fec:	00892403          	lw	s0,8(s2)
40000ff0:	00442783          	lw	a5,4(s0)
40000ff4:	ffc7fa93          	andi	s5,a5,-4
40000ff8:	009ae863          	bltu	s5,s1,40001008 <_malloc_r+0x2f8>
40000ffc:	409a87b3          	sub	a5,s5,s1
40001000:	00f00713          	li	a4,15
40001004:	16f74663          	blt	a4,a5,40001170 <_malloc_r+0x460>
40001008:	4000e7b7          	lui	a5,0x4000e
4000100c:	4000ecb7          	lui	s9,0x4000e
40001010:	5c47aa03          	lw	s4,1476(a5) # 4000e5c4 <__malloc_top_pad>
40001014:	578ca703          	lw	a4,1400(s9) # 4000e578 <__malloc_sbrk_base>
40001018:	fff00793          	li	a5,-1
4000101c:	01540b33          	add	s6,s0,s5
40001020:	01448a33          	add	s4,s1,s4
40001024:	36f70263          	beq	a4,a5,40001388 <_malloc_r+0x678>
40001028:	000017b7          	lui	a5,0x1
4000102c:	00f78793          	addi	a5,a5,15 # 100f <_stack_start+0x657>
40001030:	00fa0a33          	add	s4,s4,a5
40001034:	fffff7b7          	lui	a5,0xfffff
40001038:	00fa7a33          	and	s4,s4,a5
4000103c:	000a0593          	mv	a1,s4
40001040:	00098513          	mv	a0,s3
40001044:	5d4000ef          	jal	ra,40001618 <_sbrk_r>
40001048:	fff00793          	li	a5,-1
4000104c:	00050b93          	mv	s7,a0
40001050:	24f50e63          	beq	a0,a5,400012ac <_malloc_r+0x59c>
40001054:	25656a63          	bltu	a0,s6,400012a8 <_malloc_r+0x598>
40001058:	40011c37          	lui	s8,0x40011
4000105c:	db0c0c13          	addi	s8,s8,-592 # 40010db0 <__malloc_current_mallinfo>
40001060:	000c2703          	lw	a4,0(s8)
40001064:	00ea0733          	add	a4,s4,a4
40001068:	00ec2023          	sw	a4,0(s8)
4000106c:	34ab0c63          	beq	s6,a0,400013c4 <_malloc_r+0x6b4>
40001070:	578ca683          	lw	a3,1400(s9)
40001074:	fff00793          	li	a5,-1
40001078:	38f68463          	beq	a3,a5,40001400 <_malloc_r+0x6f0>
4000107c:	416b8b33          	sub	s6,s7,s6
40001080:	00eb0733          	add	a4,s6,a4
40001084:	00ec2023          	sw	a4,0(s8)
40001088:	007bf793          	andi	a5,s7,7
4000108c:	00001737          	lui	a4,0x1
40001090:	00078a63          	beqz	a5,400010a4 <_malloc_r+0x394>
40001094:	40fb8bb3          	sub	s7,s7,a5
40001098:	00870713          	addi	a4,a4,8 # 1008 <_stack_start+0x650>
4000109c:	008b8b93          	addi	s7,s7,8
400010a0:	40f70733          	sub	a4,a4,a5
400010a4:	000016b7          	lui	a3,0x1
400010a8:	014b87b3          	add	a5,s7,s4
400010ac:	fff68693          	addi	a3,a3,-1 # fff <_stack_start+0x647>
400010b0:	00d7f7b3          	and	a5,a5,a3
400010b4:	40f70a33          	sub	s4,a4,a5
400010b8:	000a0593          	mv	a1,s4
400010bc:	00098513          	mv	a0,s3
400010c0:	558000ef          	jal	ra,40001618 <_sbrk_r>
400010c4:	fff00793          	li	a5,-1
400010c8:	32f50663          	beq	a0,a5,400013f4 <_malloc_r+0x6e4>
400010cc:	417507b3          	sub	a5,a0,s7
400010d0:	014787b3          	add	a5,a5,s4
400010d4:	0017e793          	ori	a5,a5,1
400010d8:	000c2703          	lw	a4,0(s8)
400010dc:	01792423          	sw	s7,8(s2)
400010e0:	00fba223          	sw	a5,4(s7)
400010e4:	00ea0733          	add	a4,s4,a4
400010e8:	00ec2023          	sw	a4,0(s8)
400010ec:	03240c63          	beq	s0,s2,40001124 <_malloc_r+0x414>
400010f0:	00f00613          	li	a2,15
400010f4:	27567063          	bleu	s5,a2,40001354 <_malloc_r+0x644>
400010f8:	00442683          	lw	a3,4(s0)
400010fc:	ff4a8793          	addi	a5,s5,-12
40001100:	ff87f793          	andi	a5,a5,-8
40001104:	0016f693          	andi	a3,a3,1
40001108:	00f6e6b3          	or	a3,a3,a5
4000110c:	00d42223          	sw	a3,4(s0)
40001110:	00500593          	li	a1,5
40001114:	00f406b3          	add	a3,s0,a5
40001118:	00b6a223          	sw	a1,4(a3)
4000111c:	00b6a423          	sw	a1,8(a3)
40001120:	2cf66063          	bltu	a2,a5,400013e0 <_malloc_r+0x6d0>
40001124:	4000e7b7          	lui	a5,0x4000e
40001128:	5c07a683          	lw	a3,1472(a5) # 4000e5c0 <__malloc_max_sbrked_mem>
4000112c:	00e6f463          	bleu	a4,a3,40001134 <_malloc_r+0x424>
40001130:	5ce7a023          	sw	a4,1472(a5)
40001134:	4000e7b7          	lui	a5,0x4000e
40001138:	5bc7a683          	lw	a3,1468(a5) # 4000e5bc <__malloc_max_total_mem>
4000113c:	00892403          	lw	s0,8(s2)
40001140:	00e6f463          	bleu	a4,a3,40001148 <_malloc_r+0x438>
40001144:	5ae7ae23          	sw	a4,1468(a5)
40001148:	00442703          	lw	a4,4(s0)
4000114c:	ffc77713          	andi	a4,a4,-4
40001150:	409707b3          	sub	a5,a4,s1
40001154:	00976663          	bltu	a4,s1,40001160 <_malloc_r+0x450>
40001158:	00f00713          	li	a4,15
4000115c:	00f74a63          	blt	a4,a5,40001170 <_malloc_r+0x460>
40001160:	00098513          	mv	a0,s3
40001164:	418000ef          	jal	ra,4000157c <__malloc_unlock>
40001168:	00000513          	li	a0,0
4000116c:	df5ff06f          	j	40000f60 <_malloc_r+0x250>
40001170:	0014e713          	ori	a4,s1,1
40001174:	00e42223          	sw	a4,4(s0)
40001178:	009404b3          	add	s1,s0,s1
4000117c:	00992423          	sw	s1,8(s2)
40001180:	0017e793          	ori	a5,a5,1
40001184:	00098513          	mv	a0,s3
40001188:	00f4a223          	sw	a5,4(s1)
4000118c:	3f0000ef          	jal	ra,4000157c <__malloc_unlock>
40001190:	00840513          	addi	a0,s0,8
40001194:	dcdff06f          	j	40000f60 <_malloc_r+0x250>
40001198:	01400713          	li	a4,20
4000119c:	0ef77463          	bleu	a5,a4,40001284 <_malloc_r+0x574>
400011a0:	05400713          	li	a4,84
400011a4:	16f76a63          	bltu	a4,a5,40001318 <_malloc_r+0x608>
400011a8:	00c4d513          	srli	a0,s1,0xc
400011ac:	06f50593          	addi	a1,a0,111
400011b0:	00359693          	slli	a3,a1,0x3
400011b4:	06e50513          	addi	a0,a0,110
400011b8:	bc5ff06f          	j	40000d7c <_malloc_r+0x6c>
400011bc:	0097d713          	srli	a4,a5,0x9
400011c0:	00400693          	li	a3,4
400011c4:	0ce6f863          	bleu	a4,a3,40001294 <_malloc_r+0x584>
400011c8:	01400693          	li	a3,20
400011cc:	1ce6e263          	bltu	a3,a4,40001390 <_malloc_r+0x680>
400011d0:	05c70613          	addi	a2,a4,92
400011d4:	05b70693          	addi	a3,a4,91
400011d8:	00361613          	slli	a2,a2,0x3
400011dc:	00c90633          	add	a2,s2,a2
400011e0:	00062703          	lw	a4,0(a2)
400011e4:	ff860613          	addi	a2,a2,-8
400011e8:	14e60663          	beq	a2,a4,40001334 <_malloc_r+0x624>
400011ec:	00472683          	lw	a3,4(a4)
400011f0:	ffc6f693          	andi	a3,a3,-4
400011f4:	10d7fe63          	bleu	a3,a5,40001310 <_malloc_r+0x600>
400011f8:	00872703          	lw	a4,8(a4)
400011fc:	fee618e3          	bne	a2,a4,400011ec <_malloc_r+0x4dc>
40001200:	00c62703          	lw	a4,12(a2)
40001204:	00492783          	lw	a5,4(s2)
40001208:	00e42623          	sw	a4,12(s0)
4000120c:	00c42423          	sw	a2,8(s0)
40001210:	00872423          	sw	s0,8(a4)
40001214:	00862623          	sw	s0,12(a2)
40001218:	c25ff06f          	j	40000e3c <_malloc_r+0x12c>
4000121c:	0014e693          	ori	a3,s1,1
40001220:	00d42223          	sw	a3,4(s0)
40001224:	ca9ff06f          	j	40000ecc <_malloc_r+0x1bc>
40001228:	00492783          	lw	a5,4(s2)
4000122c:	c11ff06f          	j	40000e3c <_malloc_r+0x12c>
40001230:	00130313          	addi	t1,t1,1
40001234:	00337793          	andi	a5,t1,3
40001238:	00860613          	addi	a2,a2,8
4000123c:	c40798e3          	bnez	a5,40000e8c <_malloc_r+0x17c>
40001240:	0880006f          	j	400012c8 <_malloc_r+0x5b8>
40001244:	00c7a403          	lw	s0,12(a5)
40001248:	00258593          	addi	a1,a1,2
4000124c:	b6878ee3          	beq	a5,s0,40000dc8 <_malloc_r+0xb8>
40001250:	cddff06f          	j	40000f2c <_malloc_r+0x21c>
40001254:	00f407b3          	add	a5,s0,a5
40001258:	0047a703          	lw	a4,4(a5)
4000125c:	00c42683          	lw	a3,12(s0)
40001260:	00842603          	lw	a2,8(s0)
40001264:	00176713          	ori	a4,a4,1
40001268:	00e7a223          	sw	a4,4(a5)
4000126c:	00d62623          	sw	a3,12(a2)
40001270:	00098513          	mv	a0,s3
40001274:	00c6a423          	sw	a2,8(a3)
40001278:	304000ef          	jal	ra,4000157c <__malloc_unlock>
4000127c:	00840513          	addi	a0,s0,8
40001280:	ce1ff06f          	j	40000f60 <_malloc_r+0x250>
40001284:	05c78593          	addi	a1,a5,92
40001288:	05b78513          	addi	a0,a5,91
4000128c:	00359693          	slli	a3,a1,0x3
40001290:	aedff06f          	j	40000d7c <_malloc_r+0x6c>
40001294:	0067d693          	srli	a3,a5,0x6
40001298:	03968613          	addi	a2,a3,57
4000129c:	00361613          	slli	a2,a2,0x3
400012a0:	03868693          	addi	a3,a3,56
400012a4:	f39ff06f          	j	400011dc <_malloc_r+0x4cc>
400012a8:	11240263          	beq	s0,s2,400013ac <_malloc_r+0x69c>
400012ac:	00892403          	lw	s0,8(s2)
400012b0:	00442703          	lw	a4,4(s0)
400012b4:	ffc77713          	andi	a4,a4,-4
400012b8:	e99ff06f          	j	40001150 <_malloc_r+0x440>
400012bc:	0088a783          	lw	a5,8(a7)
400012c0:	fff58593          	addi	a1,a1,-1
400012c4:	18f89263          	bne	a7,a5,40001448 <_malloc_r+0x738>
400012c8:	0035f793          	andi	a5,a1,3
400012cc:	ff888893          	addi	a7,a7,-8
400012d0:	fe0796e3          	bnez	a5,400012bc <_malloc_r+0x5ac>
400012d4:	00492703          	lw	a4,4(s2)
400012d8:	fff6c793          	not	a5,a3
400012dc:	00e7f7b3          	and	a5,a5,a4
400012e0:	00f92223          	sw	a5,4(s2)
400012e4:	00169693          	slli	a3,a3,0x1
400012e8:	d0d7e2e3          	bltu	a5,a3,40000fec <_malloc_r+0x2dc>
400012ec:	d00680e3          	beqz	a3,40000fec <_malloc_r+0x2dc>
400012f0:	00f6f733          	and	a4,a3,a5
400012f4:	00030593          	mv	a1,t1
400012f8:	b80712e3          	bnez	a4,40000e7c <_malloc_r+0x16c>
400012fc:	00169693          	slli	a3,a3,0x1
40001300:	00f6f733          	and	a4,a3,a5
40001304:	00458593          	addi	a1,a1,4
40001308:	fe070ae3          	beqz	a4,400012fc <_malloc_r+0x5ec>
4000130c:	b71ff06f          	j	40000e7c <_malloc_r+0x16c>
40001310:	00070613          	mv	a2,a4
40001314:	eedff06f          	j	40001200 <_malloc_r+0x4f0>
40001318:	15400713          	li	a4,340
4000131c:	04f76263          	bltu	a4,a5,40001360 <_malloc_r+0x650>
40001320:	00f4d513          	srli	a0,s1,0xf
40001324:	07850593          	addi	a1,a0,120
40001328:	00359693          	slli	a3,a1,0x3
4000132c:	07750513          	addi	a0,a0,119
40001330:	a4dff06f          	j	40000d7c <_malloc_r+0x6c>
40001334:	00492703          	lw	a4,4(s2)
40001338:	4026d693          	srai	a3,a3,0x2
4000133c:	00100793          	li	a5,1
40001340:	00d797b3          	sll	a5,a5,a3
40001344:	00e7e7b3          	or	a5,a5,a4
40001348:	00f92223          	sw	a5,4(s2)
4000134c:	00060713          	mv	a4,a2
40001350:	eb9ff06f          	j	40001208 <_malloc_r+0x4f8>
40001354:	00100793          	li	a5,1
40001358:	00fba223          	sw	a5,4(s7)
4000135c:	e05ff06f          	j	40001160 <_malloc_r+0x450>
40001360:	55400713          	li	a4,1364
40001364:	07f00593          	li	a1,127
40001368:	3f800693          	li	a3,1016
4000136c:	07e00513          	li	a0,126
40001370:	a0f766e3          	bltu	a4,a5,40000d7c <_malloc_r+0x6c>
40001374:	0124d513          	srli	a0,s1,0x12
40001378:	07d50593          	addi	a1,a0,125
4000137c:	00359693          	slli	a3,a1,0x3
40001380:	07c50513          	addi	a0,a0,124
40001384:	9f9ff06f          	j	40000d7c <_malloc_r+0x6c>
40001388:	010a0a13          	addi	s4,s4,16
4000138c:	cb1ff06f          	j	4000103c <_malloc_r+0x32c>
40001390:	05400693          	li	a3,84
40001394:	06e6ea63          	bltu	a3,a4,40001408 <_malloc_r+0x6f8>
40001398:	00c7d693          	srli	a3,a5,0xc
4000139c:	06f68613          	addi	a2,a3,111
400013a0:	00361613          	slli	a2,a2,0x3
400013a4:	06e68693          	addi	a3,a3,110
400013a8:	e35ff06f          	j	400011dc <_malloc_r+0x4cc>
400013ac:	40011c37          	lui	s8,0x40011
400013b0:	db0c0c13          	addi	s8,s8,-592 # 40010db0 <__malloc_current_mallinfo>
400013b4:	000c2703          	lw	a4,0(s8)
400013b8:	00ea0733          	add	a4,s4,a4
400013bc:	00ec2023          	sw	a4,0(s8)
400013c0:	cb1ff06f          	j	40001070 <_malloc_r+0x360>
400013c4:	014b1793          	slli	a5,s6,0x14
400013c8:	ca0794e3          	bnez	a5,40001070 <_malloc_r+0x360>
400013cc:	00892683          	lw	a3,8(s2)
400013d0:	014a87b3          	add	a5,s5,s4
400013d4:	0017e793          	ori	a5,a5,1
400013d8:	00f6a223          	sw	a5,4(a3)
400013dc:	d49ff06f          	j	40001124 <_malloc_r+0x414>
400013e0:	00840593          	addi	a1,s0,8
400013e4:	00098513          	mv	a0,s3
400013e8:	15c040ef          	jal	ra,40005544 <_free_r>
400013ec:	000c2703          	lw	a4,0(s8)
400013f0:	d35ff06f          	j	40001124 <_malloc_r+0x414>
400013f4:	00100793          	li	a5,1
400013f8:	00000a13          	li	s4,0
400013fc:	cddff06f          	j	400010d8 <_malloc_r+0x3c8>
40001400:	577cac23          	sw	s7,1400(s9)
40001404:	c85ff06f          	j	40001088 <_malloc_r+0x378>
40001408:	15400693          	li	a3,340
4000140c:	00e6ec63          	bltu	a3,a4,40001424 <_malloc_r+0x714>
40001410:	00f7d693          	srli	a3,a5,0xf
40001414:	07868613          	addi	a2,a3,120
40001418:	00361613          	slli	a2,a2,0x3
4000141c:	07768693          	addi	a3,a3,119
40001420:	dbdff06f          	j	400011dc <_malloc_r+0x4cc>
40001424:	55400513          	li	a0,1364
40001428:	3f800613          	li	a2,1016
4000142c:	07e00693          	li	a3,126
40001430:	dae566e3          	bltu	a0,a4,400011dc <_malloc_r+0x4cc>
40001434:	0127d693          	srli	a3,a5,0x12
40001438:	07d68613          	addi	a2,a3,125
4000143c:	00361613          	slli	a2,a2,0x3
40001440:	07c68693          	addi	a3,a3,124
40001444:	d99ff06f          	j	400011dc <_malloc_r+0x4cc>
40001448:	00492783          	lw	a5,4(s2)
4000144c:	e99ff06f          	j	400012e4 <_malloc_r+0x5d4>
40001450:	0034d593          	srli	a1,s1,0x3
40001454:	00848793          	addi	a5,s1,8
40001458:	abdff06f          	j	40000f14 <_malloc_r+0x204>

4000145c <memcpy>:
4000145c:	00a5c7b3          	xor	a5,a1,a0
40001460:	0037f793          	andi	a5,a5,3
40001464:	00c508b3          	add	a7,a0,a2
40001468:	0e079863          	bnez	a5,40001558 <memcpy+0xfc>
4000146c:	00300793          	li	a5,3
40001470:	0ec7f463          	bleu	a2,a5,40001558 <memcpy+0xfc>
40001474:	00357793          	andi	a5,a0,3
40001478:	00050713          	mv	a4,a0
4000147c:	04079863          	bnez	a5,400014cc <memcpy+0x70>
40001480:	ffc8f813          	andi	a6,a7,-4
40001484:	fe080793          	addi	a5,a6,-32
40001488:	06f76c63          	bltu	a4,a5,40001500 <memcpy+0xa4>
4000148c:	03077c63          	bleu	a6,a4,400014c4 <memcpy+0x68>
40001490:	00058693          	mv	a3,a1
40001494:	00070793          	mv	a5,a4
40001498:	0006a603          	lw	a2,0(a3)
4000149c:	00478793          	addi	a5,a5,4
400014a0:	00468693          	addi	a3,a3,4
400014a4:	fec7ae23          	sw	a2,-4(a5)
400014a8:	ff07e8e3          	bltu	a5,a6,40001498 <memcpy+0x3c>
400014ac:	fff74793          	not	a5,a4
400014b0:	010787b3          	add	a5,a5,a6
400014b4:	ffc7f793          	andi	a5,a5,-4
400014b8:	00478793          	addi	a5,a5,4
400014bc:	00f70733          	add	a4,a4,a5
400014c0:	00f585b3          	add	a1,a1,a5
400014c4:	09176e63          	bltu	a4,a7,40001560 <memcpy+0x104>
400014c8:	00008067          	ret
400014cc:	0005c683          	lbu	a3,0(a1)
400014d0:	00170713          	addi	a4,a4,1
400014d4:	00377793          	andi	a5,a4,3
400014d8:	fed70fa3          	sb	a3,-1(a4)
400014dc:	00158593          	addi	a1,a1,1
400014e0:	fa0780e3          	beqz	a5,40001480 <memcpy+0x24>
400014e4:	0005c683          	lbu	a3,0(a1)
400014e8:	00170713          	addi	a4,a4,1
400014ec:	00377793          	andi	a5,a4,3
400014f0:	fed70fa3          	sb	a3,-1(a4)
400014f4:	00158593          	addi	a1,a1,1
400014f8:	fc079ae3          	bnez	a5,400014cc <memcpy+0x70>
400014fc:	f85ff06f          	j	40001480 <memcpy+0x24>
40001500:	0005a383          	lw	t2,0(a1)
40001504:	0045a283          	lw	t0,4(a1)
40001508:	0085af83          	lw	t6,8(a1)
4000150c:	00c5af03          	lw	t5,12(a1)
40001510:	0105ae83          	lw	t4,16(a1)
40001514:	0145ae03          	lw	t3,20(a1)
40001518:	0185a303          	lw	t1,24(a1)
4000151c:	01c5a603          	lw	a2,28(a1)
40001520:	02458593          	addi	a1,a1,36
40001524:	02470713          	addi	a4,a4,36
40001528:	ffc5a683          	lw	a3,-4(a1)
4000152c:	fc772e23          	sw	t2,-36(a4)
40001530:	fe572023          	sw	t0,-32(a4)
40001534:	fff72223          	sw	t6,-28(a4)
40001538:	ffe72423          	sw	t5,-24(a4)
4000153c:	ffd72623          	sw	t4,-20(a4)
40001540:	ffc72823          	sw	t3,-16(a4)
40001544:	fe672a23          	sw	t1,-12(a4)
40001548:	fec72c23          	sw	a2,-8(a4)
4000154c:	fed72e23          	sw	a3,-4(a4)
40001550:	faf768e3          	bltu	a4,a5,40001500 <memcpy+0xa4>
40001554:	f39ff06f          	j	4000148c <memcpy+0x30>
40001558:	00050713          	mv	a4,a0
4000155c:	f71576e3          	bleu	a7,a0,400014c8 <memcpy+0x6c>
40001560:	0005c783          	lbu	a5,0(a1)
40001564:	00170713          	addi	a4,a4,1
40001568:	00158593          	addi	a1,a1,1
4000156c:	fef70fa3          	sb	a5,-1(a4)
40001570:	ff1768e3          	bltu	a4,a7,40001560 <memcpy+0x104>
40001574:	00008067          	ret

40001578 <__malloc_lock>:
40001578:	00008067          	ret

4000157c <__malloc_unlock>:
4000157c:	00008067          	ret

40001580 <_printf_r>:
40001580:	fc010113          	addi	sp,sp,-64
40001584:	02c12423          	sw	a2,40(sp)
40001588:	02d12623          	sw	a3,44(sp)
4000158c:	02f12a23          	sw	a5,52(sp)
40001590:	02e12823          	sw	a4,48(sp)
40001594:	03012c23          	sw	a6,56(sp)
40001598:	03112e23          	sw	a7,60(sp)
4000159c:	00058613          	mv	a2,a1
400015a0:	00852583          	lw	a1,8(a0)
400015a4:	02810793          	addi	a5,sp,40
400015a8:	00078693          	mv	a3,a5
400015ac:	00112e23          	sw	ra,28(sp)
400015b0:	00f12623          	sw	a5,12(sp)
400015b4:	240000ef          	jal	ra,400017f4 <_vfprintf_r>
400015b8:	01c12083          	lw	ra,28(sp)
400015bc:	04010113          	addi	sp,sp,64
400015c0:	00008067          	ret

400015c4 <printf>:
400015c4:	4000e337          	lui	t1,0x4000e
400015c8:	58432303          	lw	t1,1412(t1) # 4000e584 <_impure_ptr>
400015cc:	fc010113          	addi	sp,sp,-64
400015d0:	02c12423          	sw	a2,40(sp)
400015d4:	02d12623          	sw	a3,44(sp)
400015d8:	02f12a23          	sw	a5,52(sp)
400015dc:	02b12223          	sw	a1,36(sp)
400015e0:	02e12823          	sw	a4,48(sp)
400015e4:	03012c23          	sw	a6,56(sp)
400015e8:	03112e23          	sw	a7,60(sp)
400015ec:	00832583          	lw	a1,8(t1)
400015f0:	02410793          	addi	a5,sp,36
400015f4:	00050613          	mv	a2,a0
400015f8:	00078693          	mv	a3,a5
400015fc:	00030513          	mv	a0,t1
40001600:	00112e23          	sw	ra,28(sp)
40001604:	00f12623          	sw	a5,12(sp)
40001608:	1ec000ef          	jal	ra,400017f4 <_vfprintf_r>
4000160c:	01c12083          	lw	ra,28(sp)
40001610:	04010113          	addi	sp,sp,64
40001614:	00008067          	ret

40001618 <_sbrk_r>:
40001618:	ff010113          	addi	sp,sp,-16
4000161c:	00812423          	sw	s0,8(sp)
40001620:	00912223          	sw	s1,4(sp)
40001624:	40011437          	lui	s0,0x40011
40001628:	00050493          	mv	s1,a0
4000162c:	00058513          	mv	a0,a1
40001630:	00112623          	sw	ra,12(sp)
40001634:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40001638:	16c080ef          	jal	ra,400097a4 <sbrk>
4000163c:	fff00793          	li	a5,-1
40001640:	00f50c63          	beq	a0,a5,40001658 <_sbrk_r+0x40>
40001644:	00c12083          	lw	ra,12(sp)
40001648:	00812403          	lw	s0,8(sp)
4000164c:	00412483          	lw	s1,4(sp)
40001650:	01010113          	addi	sp,sp,16
40001654:	00008067          	ret
40001658:	dd842783          	lw	a5,-552(s0)
4000165c:	fe0784e3          	beqz	a5,40001644 <_sbrk_r+0x2c>
40001660:	00c12083          	lw	ra,12(sp)
40001664:	00f4a023          	sw	a5,0(s1)
40001668:	00812403          	lw	s0,8(sp)
4000166c:	00412483          	lw	s1,4(sp)
40001670:	01010113          	addi	sp,sp,16
40001674:	00008067          	ret

40001678 <strcmp>:
40001678:	00b56733          	or	a4,a0,a1
4000167c:	fff00393          	li	t2,-1
40001680:	00377713          	andi	a4,a4,3
40001684:	10071063          	bnez	a4,40001784 <strcmp+0x10c>
40001688:	7f7f8e37          	lui	t3,0x7f7f8
4000168c:	f7fe0e13          	addi	t3,t3,-129 # 7f7f7f7f <end+0x3f7e719f>
40001690:	00052603          	lw	a2,0(a0)
40001694:	0005a683          	lw	a3,0(a1)
40001698:	01c672b3          	and	t0,a2,t3
4000169c:	01c66333          	or	t1,a2,t3
400016a0:	01c282b3          	add	t0,t0,t3
400016a4:	0062e2b3          	or	t0,t0,t1
400016a8:	10729263          	bne	t0,t2,400017ac <strcmp+0x134>
400016ac:	08d61663          	bne	a2,a3,40001738 <strcmp+0xc0>
400016b0:	00452603          	lw	a2,4(a0)
400016b4:	0045a683          	lw	a3,4(a1)
400016b8:	01c672b3          	and	t0,a2,t3
400016bc:	01c66333          	or	t1,a2,t3
400016c0:	01c282b3          	add	t0,t0,t3
400016c4:	0062e2b3          	or	t0,t0,t1
400016c8:	0c729e63          	bne	t0,t2,400017a4 <strcmp+0x12c>
400016cc:	06d61663          	bne	a2,a3,40001738 <strcmp+0xc0>
400016d0:	00852603          	lw	a2,8(a0)
400016d4:	0085a683          	lw	a3,8(a1)
400016d8:	01c672b3          	and	t0,a2,t3
400016dc:	01c66333          	or	t1,a2,t3
400016e0:	01c282b3          	add	t0,t0,t3
400016e4:	0062e2b3          	or	t0,t0,t1
400016e8:	0c729863          	bne	t0,t2,400017b8 <strcmp+0x140>
400016ec:	04d61663          	bne	a2,a3,40001738 <strcmp+0xc0>
400016f0:	00c52603          	lw	a2,12(a0)
400016f4:	00c5a683          	lw	a3,12(a1)
400016f8:	01c672b3          	and	t0,a2,t3
400016fc:	01c66333          	or	t1,a2,t3
40001700:	01c282b3          	add	t0,t0,t3
40001704:	0062e2b3          	or	t0,t0,t1
40001708:	0c729263          	bne	t0,t2,400017cc <strcmp+0x154>
4000170c:	02d61663          	bne	a2,a3,40001738 <strcmp+0xc0>
40001710:	01052603          	lw	a2,16(a0)
40001714:	0105a683          	lw	a3,16(a1)
40001718:	01c672b3          	and	t0,a2,t3
4000171c:	01c66333          	or	t1,a2,t3
40001720:	01c282b3          	add	t0,t0,t3
40001724:	0062e2b3          	or	t0,t0,t1
40001728:	0a729c63          	bne	t0,t2,400017e0 <strcmp+0x168>
4000172c:	01450513          	addi	a0,a0,20
40001730:	01458593          	addi	a1,a1,20
40001734:	f4d60ee3          	beq	a2,a3,40001690 <strcmp+0x18>
40001738:	01061713          	slli	a4,a2,0x10
4000173c:	01069793          	slli	a5,a3,0x10
40001740:	00f71e63          	bne	a4,a5,4000175c <strcmp+0xe4>
40001744:	01065713          	srli	a4,a2,0x10
40001748:	0106d793          	srli	a5,a3,0x10
4000174c:	40f70533          	sub	a0,a4,a5
40001750:	0ff57593          	andi	a1,a0,255
40001754:	02059063          	bnez	a1,40001774 <strcmp+0xfc>
40001758:	00008067          	ret
4000175c:	01075713          	srli	a4,a4,0x10
40001760:	0107d793          	srli	a5,a5,0x10
40001764:	40f70533          	sub	a0,a4,a5
40001768:	0ff57593          	andi	a1,a0,255
4000176c:	00059463          	bnez	a1,40001774 <strcmp+0xfc>
40001770:	00008067          	ret
40001774:	0ff77713          	andi	a4,a4,255
40001778:	0ff7f793          	andi	a5,a5,255
4000177c:	40f70533          	sub	a0,a4,a5
40001780:	00008067          	ret
40001784:	00054603          	lbu	a2,0(a0)
40001788:	0005c683          	lbu	a3,0(a1)
4000178c:	00150513          	addi	a0,a0,1
40001790:	00158593          	addi	a1,a1,1
40001794:	00d61463          	bne	a2,a3,4000179c <strcmp+0x124>
40001798:	fe0616e3          	bnez	a2,40001784 <strcmp+0x10c>
4000179c:	40d60533          	sub	a0,a2,a3
400017a0:	00008067          	ret
400017a4:	00450513          	addi	a0,a0,4
400017a8:	00458593          	addi	a1,a1,4
400017ac:	fcd61ce3          	bne	a2,a3,40001784 <strcmp+0x10c>
400017b0:	00000513          	li	a0,0
400017b4:	00008067          	ret
400017b8:	00850513          	addi	a0,a0,8
400017bc:	00858593          	addi	a1,a1,8
400017c0:	fcd612e3          	bne	a2,a3,40001784 <strcmp+0x10c>
400017c4:	00000513          	li	a0,0
400017c8:	00008067          	ret
400017cc:	00c50513          	addi	a0,a0,12
400017d0:	00c58593          	addi	a1,a1,12
400017d4:	fad618e3          	bne	a2,a3,40001784 <strcmp+0x10c>
400017d8:	00000513          	li	a0,0
400017dc:	00008067          	ret
400017e0:	01050513          	addi	a0,a0,16
400017e4:	01058593          	addi	a1,a1,16
400017e8:	f8d61ee3          	bne	a2,a3,40001784 <strcmp+0x10c>
400017ec:	00000513          	li	a0,0
400017f0:	00008067          	ret

400017f4 <_vfprintf_r>:
400017f4:	eb010113          	addi	sp,sp,-336
400017f8:	14112623          	sw	ra,332(sp)
400017fc:	14812423          	sw	s0,328(sp)
40001800:	13312e23          	sw	s3,316(sp)
40001804:	13412c23          	sw	s4,312(sp)
40001808:	00058993          	mv	s3,a1
4000180c:	00060413          	mv	s0,a2
40001810:	02d12023          	sw	a3,32(sp)
40001814:	14912223          	sw	s1,324(sp)
40001818:	15212023          	sw	s2,320(sp)
4000181c:	13512a23          	sw	s5,308(sp)
40001820:	13612823          	sw	s6,304(sp)
40001824:	13712623          	sw	s7,300(sp)
40001828:	13812423          	sw	s8,296(sp)
4000182c:	13912223          	sw	s9,292(sp)
40001830:	13a12023          	sw	s10,288(sp)
40001834:	11b12e23          	sw	s11,284(sp)
40001838:	00050a13          	mv	s4,a0
4000183c:	218040ef          	jal	ra,40005a54 <_localeconv_r>
40001840:	00052783          	lw	a5,0(a0)
40001844:	00078513          	mv	a0,a5
40001848:	04f12423          	sw	a5,72(sp)
4000184c:	129050ef          	jal	ra,40007174 <strlen>
40001850:	04a12023          	sw	a0,64(sp)
40001854:	000a0663          	beqz	s4,40001860 <_vfprintf_r+0x6c>
40001858:	038a2783          	lw	a5,56(s4)
4000185c:	2a0788e3          	beqz	a5,4000230c <_vfprintf_r+0xb18>
40001860:	00c99703          	lh	a4,12(s3)
40001864:	01071793          	slli	a5,a4,0x10
40001868:	0107d793          	srli	a5,a5,0x10
4000186c:	01279693          	slli	a3,a5,0x12
40001870:	0206c663          	bltz	a3,4000189c <_vfprintf_r+0xa8>
40001874:	0649a683          	lw	a3,100(s3)
40001878:	000027b7          	lui	a5,0x2
4000187c:	00f767b3          	or	a5,a4,a5
40001880:	ffffe737          	lui	a4,0xffffe
40001884:	fff70713          	addi	a4,a4,-1 # ffffdfff <end+0xbffed21f>
40001888:	00e6f733          	and	a4,a3,a4
4000188c:	00f99623          	sh	a5,12(s3)
40001890:	01079793          	slli	a5,a5,0x10
40001894:	06e9a223          	sw	a4,100(s3)
40001898:	0107d793          	srli	a5,a5,0x10
4000189c:	0087f713          	andi	a4,a5,8
400018a0:	040706e3          	beqz	a4,400020ec <_vfprintf_r+0x8f8>
400018a4:	0109a703          	lw	a4,16(s3)
400018a8:	040702e3          	beqz	a4,400020ec <_vfprintf_r+0x8f8>
400018ac:	01a7f793          	andi	a5,a5,26
400018b0:	00a00713          	li	a4,10
400018b4:	04e78ce3          	beq	a5,a4,4000210c <_vfprintf_r+0x918>
400018b8:	4000e7b7          	lui	a5,0x4000e
400018bc:	c407a703          	lw	a4,-960(a5) # 4000dc40 <__clz_tab+0x10c>
400018c0:	c447a783          	lw	a5,-956(a5)
400018c4:	0d010d13          	addi	s10,sp,208
400018c8:	04e12823          	sw	a4,80(sp)
400018cc:	00078693          	mv	a3,a5
400018d0:	04f12a23          	sw	a5,84(sp)
400018d4:	4000d7b7          	lui	a5,0x4000d
400018d8:	5a078793          	addi	a5,a5,1440 # 4000d5a0 <__clzsi2+0x618>
400018dc:	09a12e23          	sw	s10,156(sp)
400018e0:	0a012223          	sw	zero,164(sp)
400018e4:	0a012023          	sw	zero,160(sp)
400018e8:	02012a23          	sw	zero,52(sp)
400018ec:	02012c23          	sw	zero,56(sp)
400018f0:	02012e23          	sw	zero,60(sp)
400018f4:	000d0313          	mv	t1,s10
400018f8:	04012223          	sw	zero,68(sp)
400018fc:	04012623          	sw	zero,76(sp)
40001900:	00012e23          	sw	zero,28(sp)
40001904:	02f12223          	sw	a5,36(sp)
40001908:	04e12c23          	sw	a4,88(sp)
4000190c:	04d12e23          	sw	a3,92(sp)
40001910:	00044783          	lbu	a5,0(s0)
40001914:	50078463          	beqz	a5,40001e1c <_vfprintf_r+0x628>
40001918:	02500713          	li	a4,37
4000191c:	00040493          	mv	s1,s0
40001920:	00e79663          	bne	a5,a4,4000192c <_vfprintf_r+0x138>
40001924:	0540006f          	j	40001978 <_vfprintf_r+0x184>
40001928:	00e78863          	beq	a5,a4,40001938 <_vfprintf_r+0x144>
4000192c:	00148493          	addi	s1,s1,1
40001930:	0004c783          	lbu	a5,0(s1)
40001934:	fe079ae3          	bnez	a5,40001928 <_vfprintf_r+0x134>
40001938:	40848933          	sub	s2,s1,s0
4000193c:	02090e63          	beqz	s2,40001978 <_vfprintf_r+0x184>
40001940:	0a412703          	lw	a4,164(sp)
40001944:	0a012783          	lw	a5,160(sp)
40001948:	00832023          	sw	s0,0(t1)
4000194c:	01270733          	add	a4,a4,s2
40001950:	00178793          	addi	a5,a5,1
40001954:	01232223          	sw	s2,4(t1)
40001958:	0ae12223          	sw	a4,164(sp)
4000195c:	0af12023          	sw	a5,160(sp)
40001960:	00700713          	li	a4,7
40001964:	00830313          	addi	t1,t1,8
40001968:	0ef74ae3          	blt	a4,a5,4000225c <_vfprintf_r+0xa68>
4000196c:	01c12783          	lw	a5,28(sp)
40001970:	012787b3          	add	a5,a5,s2
40001974:	00f12e23          	sw	a5,28(sp)
40001978:	0004c783          	lbu	a5,0(s1)
4000197c:	5a078e63          	beqz	a5,40001f38 <_vfprintf_r+0x744>
40001980:	fff00b13          	li	s6,-1
40001984:	00148413          	addi	s0,s1,1
40001988:	06010fa3          	sb	zero,127(sp)
4000198c:	00000613          	li	a2,0
40001990:	00000593          	li	a1,0
40001994:	00000493          	li	s1,0
40001998:	00000d93          	li	s11,0
4000199c:	05800713          	li	a4,88
400019a0:	00900693          	li	a3,9
400019a4:	02a00893          	li	a7,42
400019a8:	000b0f93          	mv	t6,s6
400019ac:	00100513          	li	a0,1
400019b0:	02000f13          	li	t5,32
400019b4:	02b00813          	li	a6,43
400019b8:	00044a83          	lbu	s5,0(s0)
400019bc:	00140413          	addi	s0,s0,1
400019c0:	fe0a8793          	addi	a5,s5,-32
400019c4:	60f760e3          	bltu	a4,a5,400027c4 <_vfprintf_r+0xfd0>
400019c8:	02412e03          	lw	t3,36(sp)
400019cc:	00279793          	slli	a5,a5,0x2
400019d0:	01c787b3          	add	a5,a5,t3
400019d4:	0007a783          	lw	a5,0(a5)
400019d8:	00078067          	jr	a5
400019dc:	010ded93          	ori	s11,s11,16
400019e0:	fd9ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
400019e4:	010ded93          	ori	s11,s11,16
400019e8:	010df793          	andi	a5,s11,16
400019ec:	00078463          	beqz	a5,400019f4 <_vfprintf_r+0x200>
400019f0:	1940106f          	j	40002b84 <_vfprintf_r+0x1390>
400019f4:	040df793          	andi	a5,s11,64
400019f8:	02012703          	lw	a4,32(sp)
400019fc:	5a079ae3          	bnez	a5,400027b0 <_vfprintf_r+0xfbc>
40001a00:	00072c03          	lw	s8,0(a4)
40001a04:	00470713          	addi	a4,a4,4
40001a08:	00000793          	li	a5,0
40001a0c:	02e12023          	sw	a4,32(sp)
40001a10:	06010fa3          	sb	zero,127(sp)
40001a14:	00000613          	li	a2,0
40001a18:	fff00713          	li	a4,-1
40001a1c:	08eb0c63          	beq	s6,a4,40001ab4 <_vfprintf_r+0x2c0>
40001a20:	f7fdf713          	andi	a4,s11,-129
40001a24:	00e12a23          	sw	a4,20(sp)
40001a28:	080c1a63          	bnez	s8,40001abc <_vfprintf_r+0x2c8>
40001a2c:	000b18e3          	bnez	s6,4000223c <_vfprintf_r+0xa48>
40001a30:	1a0794e3          	bnez	a5,400023d8 <_vfprintf_r+0xbe4>
40001a34:	001dfc13          	andi	s8,s11,1
40001a38:	000d0913          	mv	s2,s10
40001a3c:	0a0c0c63          	beqz	s8,40001af4 <_vfprintf_r+0x300>
40001a40:	03000793          	li	a5,48
40001a44:	0cf107a3          	sb	a5,207(sp)
40001a48:	0cf10913          	addi	s2,sp,207
40001a4c:	0a80006f          	j	40001af4 <_vfprintf_r+0x300>
40001a50:	010ded93          	ori	s11,s11,16
40001a54:	010df793          	andi	a5,s11,16
40001a58:	04079263          	bnez	a5,40001a9c <_vfprintf_r+0x2a8>
40001a5c:	040df793          	andi	a5,s11,64
40001a60:	02012703          	lw	a4,32(sp)
40001a64:	02078e63          	beqz	a5,40001aa0 <_vfprintf_r+0x2ac>
40001a68:	00075c03          	lhu	s8,0(a4)
40001a6c:	00470713          	addi	a4,a4,4
40001a70:	00100793          	li	a5,1
40001a74:	02e12023          	sw	a4,32(sp)
40001a78:	f99ff06f          	j	40001a10 <_vfprintf_r+0x21c>
40001a7c:	02012783          	lw	a5,32(sp)
40001a80:	0007a483          	lw	s1,0(a5)
40001a84:	00478793          	addi	a5,a5,4
40001a88:	02f12023          	sw	a5,32(sp)
40001a8c:	f204d6e3          	bgez	s1,400019b8 <_vfprintf_r+0x1c4>
40001a90:	409004b3          	neg	s1,s1
40001a94:	004ded93          	ori	s11,s11,4
40001a98:	f21ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
40001a9c:	02012703          	lw	a4,32(sp)
40001aa0:	00072c03          	lw	s8,0(a4)
40001aa4:	00470713          	addi	a4,a4,4
40001aa8:	00100793          	li	a5,1
40001aac:	02e12023          	sw	a4,32(sp)
40001ab0:	f61ff06f          	j	40001a10 <_vfprintf_r+0x21c>
40001ab4:	780c0663          	beqz	s8,40002240 <_vfprintf_r+0xa4c>
40001ab8:	01b12a23          	sw	s11,20(sp)
40001abc:	00100713          	li	a4,1
40001ac0:	5ae78ce3          	beq	a5,a4,40002878 <_vfprintf_r+0x1084>
40001ac4:	00200713          	li	a4,2
40001ac8:	7ee79c63          	bne	a5,a4,400022c0 <_vfprintf_r+0xacc>
40001acc:	04412703          	lw	a4,68(sp)
40001ad0:	000d0913          	mv	s2,s10
40001ad4:	00fc7793          	andi	a5,s8,15
40001ad8:	00f707b3          	add	a5,a4,a5
40001adc:	0007c783          	lbu	a5,0(a5)
40001ae0:	fff90913          	addi	s2,s2,-1
40001ae4:	004c5c13          	srli	s8,s8,0x4
40001ae8:	00f90023          	sb	a5,0(s2)
40001aec:	fe0c14e3          	bnez	s8,40001ad4 <_vfprintf_r+0x2e0>
40001af0:	412d0c33          	sub	s8,s10,s2
40001af4:	01612823          	sw	s6,16(sp)
40001af8:	018b5463          	ble	s8,s6,40001b00 <_vfprintf_r+0x30c>
40001afc:	01812823          	sw	s8,16(sp)
40001b00:	02012823          	sw	zero,48(sp)
40001b04:	00060863          	beqz	a2,40001b14 <_vfprintf_r+0x320>
40001b08:	01012783          	lw	a5,16(sp)
40001b0c:	00178793          	addi	a5,a5,1
40001b10:	00f12823          	sw	a5,16(sp)
40001b14:	01412783          	lw	a5,20(sp)
40001b18:	0027f793          	andi	a5,a5,2
40001b1c:	02f12423          	sw	a5,40(sp)
40001b20:	00078863          	beqz	a5,40001b30 <_vfprintf_r+0x33c>
40001b24:	01012783          	lw	a5,16(sp)
40001b28:	00278793          	addi	a5,a5,2
40001b2c:	00f12823          	sw	a5,16(sp)
40001b30:	01412783          	lw	a5,20(sp)
40001b34:	0847f793          	andi	a5,a5,132
40001b38:	02f12623          	sw	a5,44(sp)
40001b3c:	2e079463          	bnez	a5,40001e24 <_vfprintf_r+0x630>
40001b40:	01012783          	lw	a5,16(sp)
40001b44:	40f48bb3          	sub	s7,s1,a5
40001b48:	2d705e63          	blez	s7,40001e24 <_vfprintf_r+0x630>
40001b4c:	4000d6b7          	lui	a3,0x4000d
40001b50:	01000813          	li	a6,16
40001b54:	0a412783          	lw	a5,164(sp)
40001b58:	0a012703          	lw	a4,160(sp)
40001b5c:	70468c93          	addi	s9,a3,1796 # 4000d704 <blanks.4138>
40001b60:	07785263          	ble	s7,a6,40001bc4 <_vfprintf_r+0x3d0>
40001b64:	00700d93          	li	s11,7
40001b68:	00c0006f          	j	40001b74 <_vfprintf_r+0x380>
40001b6c:	ff0b8b93          	addi	s7,s7,-16
40001b70:	05785a63          	ble	s7,a6,40001bc4 <_vfprintf_r+0x3d0>
40001b74:	01078793          	addi	a5,a5,16
40001b78:	00170713          	addi	a4,a4,1
40001b7c:	01932023          	sw	s9,0(t1)
40001b80:	01032223          	sw	a6,4(t1)
40001b84:	0af12223          	sw	a5,164(sp)
40001b88:	0ae12023          	sw	a4,160(sp)
40001b8c:	00830313          	addi	t1,t1,8
40001b90:	fceddee3          	ble	a4,s11,40001b6c <_vfprintf_r+0x378>
40001b94:	09c10613          	addi	a2,sp,156
40001b98:	00098593          	mv	a1,s3
40001b9c:	000a0513          	mv	a0,s4
40001ba0:	01012c23          	sw	a6,24(sp)
40001ba4:	758050ef          	jal	ra,400072fc <__sprint_r>
40001ba8:	3a051463          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001bac:	01812803          	lw	a6,24(sp)
40001bb0:	ff0b8b93          	addi	s7,s7,-16
40001bb4:	0a412783          	lw	a5,164(sp)
40001bb8:	0a012703          	lw	a4,160(sp)
40001bbc:	000d0313          	mv	t1,s10
40001bc0:	fb784ae3          	blt	a6,s7,40001b74 <_vfprintf_r+0x380>
40001bc4:	00fb87b3          	add	a5,s7,a5
40001bc8:	00170713          	addi	a4,a4,1
40001bcc:	01932023          	sw	s9,0(t1)
40001bd0:	01732223          	sw	s7,4(t1)
40001bd4:	0af12223          	sw	a5,164(sp)
40001bd8:	0ae12023          	sw	a4,160(sp)
40001bdc:	00700693          	li	a3,7
40001be0:	4ee6c6e3          	blt	a3,a4,400028cc <_vfprintf_r+0x10d8>
40001be4:	07f14603          	lbu	a2,127(sp)
40001be8:	00830313          	addi	t1,t1,8
40001bec:	02060a63          	beqz	a2,40001c20 <_vfprintf_r+0x42c>
40001bf0:	0a012703          	lw	a4,160(sp)
40001bf4:	07f10693          	addi	a3,sp,127
40001bf8:	00d32023          	sw	a3,0(t1)
40001bfc:	00178793          	addi	a5,a5,1
40001c00:	00100693          	li	a3,1
40001c04:	00170713          	addi	a4,a4,1
40001c08:	00d32223          	sw	a3,4(t1)
40001c0c:	0af12223          	sw	a5,164(sp)
40001c10:	0ae12023          	sw	a4,160(sp)
40001c14:	00700693          	li	a3,7
40001c18:	00830313          	addi	t1,t1,8
40001c1c:	64e6ce63          	blt	a3,a4,40002278 <_vfprintf_r+0xa84>
40001c20:	02812703          	lw	a4,40(sp)
40001c24:	02070a63          	beqz	a4,40001c58 <_vfprintf_r+0x464>
40001c28:	0a012703          	lw	a4,160(sp)
40001c2c:	08010693          	addi	a3,sp,128
40001c30:	00d32023          	sw	a3,0(t1)
40001c34:	00278793          	addi	a5,a5,2
40001c38:	00200693          	li	a3,2
40001c3c:	00170713          	addi	a4,a4,1
40001c40:	00d32223          	sw	a3,4(t1)
40001c44:	0af12223          	sw	a5,164(sp)
40001c48:	0ae12023          	sw	a4,160(sp)
40001c4c:	00700693          	li	a3,7
40001c50:	00830313          	addi	t1,t1,8
40001c54:	64e6c263          	blt	a3,a4,40002298 <_vfprintf_r+0xaa4>
40001c58:	02c12683          	lw	a3,44(sp)
40001c5c:	08000713          	li	a4,128
40001c60:	3ce68463          	beq	a3,a4,40002028 <_vfprintf_r+0x834>
40001c64:	418b0b33          	sub	s6,s6,s8
40001c68:	0b605863          	blez	s6,40001d18 <_vfprintf_r+0x524>
40001c6c:	4000d6b7          	lui	a3,0x4000d
40001c70:	01000d93          	li	s11,16
40001c74:	0a012703          	lw	a4,160(sp)
40001c78:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
40001c7c:	056dde63          	ble	s6,s11,40001cd8 <_vfprintf_r+0x4e4>
40001c80:	00700c93          	li	s9,7
40001c84:	00c0006f          	j	40001c90 <_vfprintf_r+0x49c>
40001c88:	ff0b0b13          	addi	s6,s6,-16
40001c8c:	056dd663          	ble	s6,s11,40001cd8 <_vfprintf_r+0x4e4>
40001c90:	01078793          	addi	a5,a5,16
40001c94:	00170713          	addi	a4,a4,1
40001c98:	01732023          	sw	s7,0(t1)
40001c9c:	01b32223          	sw	s11,4(t1)
40001ca0:	0af12223          	sw	a5,164(sp)
40001ca4:	0ae12023          	sw	a4,160(sp)
40001ca8:	00830313          	addi	t1,t1,8
40001cac:	fcecdee3          	ble	a4,s9,40001c88 <_vfprintf_r+0x494>
40001cb0:	09c10613          	addi	a2,sp,156
40001cb4:	00098593          	mv	a1,s3
40001cb8:	000a0513          	mv	a0,s4
40001cbc:	640050ef          	jal	ra,400072fc <__sprint_r>
40001cc0:	28051863          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001cc4:	ff0b0b13          	addi	s6,s6,-16
40001cc8:	0a412783          	lw	a5,164(sp)
40001ccc:	0a012703          	lw	a4,160(sp)
40001cd0:	000d0313          	mv	t1,s10
40001cd4:	fb6dcee3          	blt	s11,s6,40001c90 <_vfprintf_r+0x49c>
40001cd8:	016787b3          	add	a5,a5,s6
40001cdc:	00170713          	addi	a4,a4,1
40001ce0:	01732023          	sw	s7,0(t1)
40001ce4:	01632223          	sw	s6,4(t1)
40001ce8:	0af12223          	sw	a5,164(sp)
40001cec:	0ae12023          	sw	a4,160(sp)
40001cf0:	00700693          	li	a3,7
40001cf4:	00830313          	addi	t1,t1,8
40001cf8:	02e6d063          	ble	a4,a3,40001d18 <_vfprintf_r+0x524>
40001cfc:	09c10613          	addi	a2,sp,156
40001d00:	00098593          	mv	a1,s3
40001d04:	000a0513          	mv	a0,s4
40001d08:	5f4050ef          	jal	ra,400072fc <__sprint_r>
40001d0c:	24051263          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001d10:	0a412783          	lw	a5,164(sp)
40001d14:	000d0313          	mv	t1,s10
40001d18:	01412703          	lw	a4,20(sp)
40001d1c:	10077713          	andi	a4,a4,256
40001d20:	26071e63          	bnez	a4,40001f9c <_vfprintf_r+0x7a8>
40001d24:	0a012703          	lw	a4,160(sp)
40001d28:	018787b3          	add	a5,a5,s8
40001d2c:	01232023          	sw	s2,0(t1)
40001d30:	00170713          	addi	a4,a4,1
40001d34:	01832223          	sw	s8,4(t1)
40001d38:	0af12223          	sw	a5,164(sp)
40001d3c:	0ae12023          	sw	a4,160(sp)
40001d40:	00700693          	li	a3,7
40001d44:	1ce6ca63          	blt	a3,a4,40001f18 <_vfprintf_r+0x724>
40001d48:	00830313          	addi	t1,t1,8
40001d4c:	01412703          	lw	a4,20(sp)
40001d50:	00477b13          	andi	s6,a4,4
40001d54:	080b0e63          	beqz	s6,40001df0 <_vfprintf_r+0x5fc>
40001d58:	01012703          	lw	a4,16(sp)
40001d5c:	40e48933          	sub	s2,s1,a4
40001d60:	09205863          	blez	s2,40001df0 <_vfprintf_r+0x5fc>
40001d64:	4000d6b7          	lui	a3,0x4000d
40001d68:	01000a93          	li	s5,16
40001d6c:	0a012703          	lw	a4,160(sp)
40001d70:	70468c93          	addi	s9,a3,1796 # 4000d704 <blanks.4138>
40001d74:	052ade63          	ble	s2,s5,40001dd0 <_vfprintf_r+0x5dc>
40001d78:	00700b13          	li	s6,7
40001d7c:	00c0006f          	j	40001d88 <_vfprintf_r+0x594>
40001d80:	ff090913          	addi	s2,s2,-16
40001d84:	052ad663          	ble	s2,s5,40001dd0 <_vfprintf_r+0x5dc>
40001d88:	01078793          	addi	a5,a5,16
40001d8c:	00170713          	addi	a4,a4,1
40001d90:	01932023          	sw	s9,0(t1)
40001d94:	01532223          	sw	s5,4(t1)
40001d98:	0af12223          	sw	a5,164(sp)
40001d9c:	0ae12023          	sw	a4,160(sp)
40001da0:	00830313          	addi	t1,t1,8
40001da4:	fceb5ee3          	ble	a4,s6,40001d80 <_vfprintf_r+0x58c>
40001da8:	09c10613          	addi	a2,sp,156
40001dac:	00098593          	mv	a1,s3
40001db0:	000a0513          	mv	a0,s4
40001db4:	548050ef          	jal	ra,400072fc <__sprint_r>
40001db8:	18051c63          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001dbc:	ff090913          	addi	s2,s2,-16
40001dc0:	0a412783          	lw	a5,164(sp)
40001dc4:	0a012703          	lw	a4,160(sp)
40001dc8:	000d0313          	mv	t1,s10
40001dcc:	fb2acee3          	blt	s5,s2,40001d88 <_vfprintf_r+0x594>
40001dd0:	012787b3          	add	a5,a5,s2
40001dd4:	00170713          	addi	a4,a4,1
40001dd8:	01932023          	sw	s9,0(t1)
40001ddc:	01232223          	sw	s2,4(t1)
40001de0:	0af12223          	sw	a5,164(sp)
40001de4:	0ae12023          	sw	a4,160(sp)
40001de8:	00700693          	li	a3,7
40001dec:	1ae6c4e3          	blt	a3,a4,40002794 <_vfprintf_r+0xfa0>
40001df0:	01012703          	lw	a4,16(sp)
40001df4:	00e4d463          	ble	a4,s1,40001dfc <_vfprintf_r+0x608>
40001df8:	00070493          	mv	s1,a4
40001dfc:	01c12703          	lw	a4,28(sp)
40001e00:	00970733          	add	a4,a4,s1
40001e04:	00e12e23          	sw	a4,28(sp)
40001e08:	40079e63          	bnez	a5,40002224 <_vfprintf_r+0xa30>
40001e0c:	00044783          	lbu	a5,0(s0)
40001e10:	0a012023          	sw	zero,160(sp)
40001e14:	000d0313          	mv	t1,s10
40001e18:	b00790e3          	bnez	a5,40001918 <_vfprintf_r+0x124>
40001e1c:	00040493          	mv	s1,s0
40001e20:	b59ff06f          	j	40001978 <_vfprintf_r+0x184>
40001e24:	0a412783          	lw	a5,164(sp)
40001e28:	dc5ff06f          	j	40001bec <_vfprintf_r+0x3f8>
40001e2c:	0a012703          	lw	a4,160(sp)
40001e30:	4000d637          	lui	a2,0x4000d
40001e34:	76460613          	addi	a2,a2,1892 # 4000d764 <zeroes.4139+0x50>
40001e38:	00c32023          	sw	a2,0(t1)
40001e3c:	00178793          	addi	a5,a5,1
40001e40:	00100613          	li	a2,1
40001e44:	00170713          	addi	a4,a4,1
40001e48:	00c32223          	sw	a2,4(t1)
40001e4c:	0af12223          	sw	a5,164(sp)
40001e50:	0ae12023          	sw	a4,160(sp)
40001e54:	00700613          	li	a2,7
40001e58:	00830313          	addi	t1,t1,8
40001e5c:	02e65263          	ble	a4,a2,40001e80 <_vfprintf_r+0x68c>
40001e60:	09c10613          	addi	a2,sp,156
40001e64:	00098593          	mv	a1,s3
40001e68:	000a0513          	mv	a0,s4
40001e6c:	490050ef          	jal	ra,400072fc <__sprint_r>
40001e70:	0e051063          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001e74:	08412683          	lw	a3,132(sp)
40001e78:	0a412783          	lw	a5,164(sp)
40001e7c:	000d0313          	mv	t1,s10
40001e80:	00069c63          	bnez	a3,40001e98 <_vfprintf_r+0x6a4>
40001e84:	03412703          	lw	a4,52(sp)
40001e88:	00071863          	bnez	a4,40001e98 <_vfprintf_r+0x6a4>
40001e8c:	01412703          	lw	a4,20(sp)
40001e90:	00177713          	andi	a4,a4,1
40001e94:	ea070ce3          	beqz	a4,40001d4c <_vfprintf_r+0x558>
40001e98:	04812703          	lw	a4,72(sp)
40001e9c:	04012603          	lw	a2,64(sp)
40001ea0:	00830313          	addi	t1,t1,8
40001ea4:	fee32c23          	sw	a4,-8(t1)
40001ea8:	0a012703          	lw	a4,160(sp)
40001eac:	00f607b3          	add	a5,a2,a5
40001eb0:	fec32e23          	sw	a2,-4(t1)
40001eb4:	00170713          	addi	a4,a4,1
40001eb8:	0af12223          	sw	a5,164(sp)
40001ebc:	0ae12023          	sw	a4,160(sp)
40001ec0:	00700613          	li	a2,7
40001ec4:	02e65463          	ble	a4,a2,40001eec <_vfprintf_r+0x6f8>
40001ec8:	09c10613          	addi	a2,sp,156
40001ecc:	00098593          	mv	a1,s3
40001ed0:	000a0513          	mv	a0,s4
40001ed4:	428050ef          	jal	ra,400072fc <__sprint_r>
40001ed8:	06051c63          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001edc:	08412683          	lw	a3,132(sp)
40001ee0:	0a412783          	lw	a5,164(sp)
40001ee4:	0a012703          	lw	a4,160(sp)
40001ee8:	000d0313          	mv	t1,s10
40001eec:	0006d463          	bgez	a3,40001ef4 <_vfprintf_r+0x700>
40001ef0:	2900106f          	j	40003180 <_vfprintf_r+0x198c>
40001ef4:	03412683          	lw	a3,52(sp)
40001ef8:	00170713          	addi	a4,a4,1
40001efc:	01232023          	sw	s2,0(t1)
40001f00:	00f687b3          	add	a5,a3,a5
40001f04:	00d32223          	sw	a3,4(t1)
40001f08:	0af12223          	sw	a5,164(sp)
40001f0c:	0ae12023          	sw	a4,160(sp)
40001f10:	00700693          	li	a3,7
40001f14:	e2e6dae3          	ble	a4,a3,40001d48 <_vfprintf_r+0x554>
40001f18:	09c10613          	addi	a2,sp,156
40001f1c:	00098593          	mv	a1,s3
40001f20:	000a0513          	mv	a0,s4
40001f24:	3d8050ef          	jal	ra,400072fc <__sprint_r>
40001f28:	02051463          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40001f2c:	0a412783          	lw	a5,164(sp)
40001f30:	000d0313          	mv	t1,s10
40001f34:	e19ff06f          	j	40001d4c <_vfprintf_r+0x558>
40001f38:	0a412783          	lw	a5,164(sp)
40001f3c:	00078a63          	beqz	a5,40001f50 <_vfprintf_r+0x75c>
40001f40:	09c10613          	addi	a2,sp,156
40001f44:	00098593          	mv	a1,s3
40001f48:	000a0513          	mv	a0,s4
40001f4c:	3b0050ef          	jal	ra,400072fc <__sprint_r>
40001f50:	00c9d783          	lhu	a5,12(s3)
40001f54:	0407f793          	andi	a5,a5,64
40001f58:	640790e3          	bnez	a5,40002d98 <_vfprintf_r+0x15a4>
40001f5c:	14c12083          	lw	ra,332(sp)
40001f60:	01c12503          	lw	a0,28(sp)
40001f64:	14812403          	lw	s0,328(sp)
40001f68:	14412483          	lw	s1,324(sp)
40001f6c:	14012903          	lw	s2,320(sp)
40001f70:	13c12983          	lw	s3,316(sp)
40001f74:	13812a03          	lw	s4,312(sp)
40001f78:	13412a83          	lw	s5,308(sp)
40001f7c:	13012b03          	lw	s6,304(sp)
40001f80:	12c12b83          	lw	s7,300(sp)
40001f84:	12812c03          	lw	s8,296(sp)
40001f88:	12412c83          	lw	s9,292(sp)
40001f8c:	12012d03          	lw	s10,288(sp)
40001f90:	11c12d83          	lw	s11,284(sp)
40001f94:	15010113          	addi	sp,sp,336
40001f98:	00008067          	ret
40001f9c:	06500713          	li	a4,101
40001fa0:	19575863          	ble	s5,a4,40002130 <_vfprintf_r+0x93c>
40001fa4:	03812683          	lw	a3,56(sp)
40001fa8:	03c12703          	lw	a4,60(sp)
40001fac:	00000613          	li	a2,0
40001fb0:	00068513          	mv	a0,a3
40001fb4:	00070593          	mv	a1,a4
40001fb8:	00000693          	li	a3,0
40001fbc:	02612423          	sw	t1,40(sp)
40001fc0:	00f12c23          	sw	a5,24(sp)
40001fc4:	108090ef          	jal	ra,4000b0cc <__eqdf2>
40001fc8:	01812783          	lw	a5,24(sp)
40001fcc:	02812303          	lw	t1,40(sp)
40001fd0:	34051463          	bnez	a0,40002318 <_vfprintf_r+0xb24>
40001fd4:	0a012703          	lw	a4,160(sp)
40001fd8:	4000d6b7          	lui	a3,0x4000d
40001fdc:	76468693          	addi	a3,a3,1892 # 4000d764 <zeroes.4139+0x50>
40001fe0:	00178793          	addi	a5,a5,1
40001fe4:	00d32023          	sw	a3,0(t1)
40001fe8:	00170713          	addi	a4,a4,1
40001fec:	00100693          	li	a3,1
40001ff0:	00d32223          	sw	a3,4(t1)
40001ff4:	0af12223          	sw	a5,164(sp)
40001ff8:	0ae12023          	sw	a4,160(sp)
40001ffc:	00700793          	li	a5,7
40002000:	00830313          	addi	t1,t1,8
40002004:	56e7cce3          	blt	a5,a4,40002d7c <_vfprintf_r+0x1588>
40002008:	08412783          	lw	a5,132(sp)
4000200c:	03412703          	lw	a4,52(sp)
40002010:	0ee7c0e3          	blt	a5,a4,400028f0 <_vfprintf_r+0x10fc>
40002014:	01412783          	lw	a5,20(sp)
40002018:	0017f793          	andi	a5,a5,1
4000201c:	0c079ae3          	bnez	a5,400028f0 <_vfprintf_r+0x10fc>
40002020:	0a412783          	lw	a5,164(sp)
40002024:	d29ff06f          	j	40001d4c <_vfprintf_r+0x558>
40002028:	01012703          	lw	a4,16(sp)
4000202c:	40e48cb3          	sub	s9,s1,a4
40002030:	c3905ae3          	blez	s9,40001c64 <_vfprintf_r+0x470>
40002034:	4000d6b7          	lui	a3,0x4000d
40002038:	01000d93          	li	s11,16
4000203c:	0a012703          	lw	a4,160(sp)
40002040:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
40002044:	079dd263          	ble	s9,s11,400020a8 <_vfprintf_r+0x8b4>
40002048:	00700813          	li	a6,7
4000204c:	00c0006f          	j	40002058 <_vfprintf_r+0x864>
40002050:	ff0c8c93          	addi	s9,s9,-16
40002054:	059dda63          	ble	s9,s11,400020a8 <_vfprintf_r+0x8b4>
40002058:	01078793          	addi	a5,a5,16
4000205c:	00170713          	addi	a4,a4,1
40002060:	01732023          	sw	s7,0(t1)
40002064:	01b32223          	sw	s11,4(t1)
40002068:	0af12223          	sw	a5,164(sp)
4000206c:	0ae12023          	sw	a4,160(sp)
40002070:	00830313          	addi	t1,t1,8
40002074:	fce85ee3          	ble	a4,a6,40002050 <_vfprintf_r+0x85c>
40002078:	09c10613          	addi	a2,sp,156
4000207c:	00098593          	mv	a1,s3
40002080:	000a0513          	mv	a0,s4
40002084:	01012c23          	sw	a6,24(sp)
40002088:	274050ef          	jal	ra,400072fc <__sprint_r>
4000208c:	ec0512e3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002090:	ff0c8c93          	addi	s9,s9,-16
40002094:	0a412783          	lw	a5,164(sp)
40002098:	0a012703          	lw	a4,160(sp)
4000209c:	000d0313          	mv	t1,s10
400020a0:	01812803          	lw	a6,24(sp)
400020a4:	fb9dcae3          	blt	s11,s9,40002058 <_vfprintf_r+0x864>
400020a8:	019787b3          	add	a5,a5,s9
400020ac:	00170713          	addi	a4,a4,1
400020b0:	01732023          	sw	s7,0(t1)
400020b4:	01932223          	sw	s9,4(t1)
400020b8:	0af12223          	sw	a5,164(sp)
400020bc:	0ae12023          	sw	a4,160(sp)
400020c0:	00700693          	li	a3,7
400020c4:	00830313          	addi	t1,t1,8
400020c8:	b8e6dee3          	ble	a4,a3,40001c64 <_vfprintf_r+0x470>
400020cc:	09c10613          	addi	a2,sp,156
400020d0:	00098593          	mv	a1,s3
400020d4:	000a0513          	mv	a0,s4
400020d8:	224050ef          	jal	ra,400072fc <__sprint_r>
400020dc:	e6051ae3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
400020e0:	0a412783          	lw	a5,164(sp)
400020e4:	000d0313          	mv	t1,s10
400020e8:	b7dff06f          	j	40001c64 <_vfprintf_r+0x470>
400020ec:	00098593          	mv	a1,s3
400020f0:	000a0513          	mv	a0,s4
400020f4:	370010ef          	jal	ra,40003464 <__swsetup_r>
400020f8:	4a0510e3          	bnez	a0,40002d98 <_vfprintf_r+0x15a4>
400020fc:	00c9d783          	lhu	a5,12(s3)
40002100:	00a00713          	li	a4,10
40002104:	01a7f793          	andi	a5,a5,26
40002108:	fae79863          	bne	a5,a4,400018b8 <_vfprintf_r+0xc4>
4000210c:	00e99783          	lh	a5,14(s3)
40002110:	fa07c463          	bltz	a5,400018b8 <_vfprintf_r+0xc4>
40002114:	02012683          	lw	a3,32(sp)
40002118:	00040613          	mv	a2,s0
4000211c:	00098593          	mv	a1,s3
40002120:	000a0513          	mv	a0,s4
40002124:	280010ef          	jal	ra,400033a4 <__sbprintf>
40002128:	00a12e23          	sw	a0,28(sp)
4000212c:	e31ff06f          	j	40001f5c <_vfprintf_r+0x768>
40002130:	03412683          	lw	a3,52(sp)
40002134:	00100713          	li	a4,1
40002138:	6cd75063          	ble	a3,a4,400027f8 <_vfprintf_r+0x1004>
4000213c:	0a012a83          	lw	s5,160(sp)
40002140:	00100713          	li	a4,1
40002144:	00178793          	addi	a5,a5,1
40002148:	001a8a93          	addi	s5,s5,1
4000214c:	00e32223          	sw	a4,4(t1)
40002150:	01232023          	sw	s2,0(t1)
40002154:	0af12223          	sw	a5,164(sp)
40002158:	0b512023          	sw	s5,160(sp)
4000215c:	00700713          	li	a4,7
40002160:	00830313          	addi	t1,t1,8
40002164:	1f574ee3          	blt	a4,s5,40002b60 <_vfprintf_r+0x136c>
40002168:	04012703          	lw	a4,64(sp)
4000216c:	001a8a93          	addi	s5,s5,1
40002170:	0b512023          	sw	s5,160(sp)
40002174:	00f70b33          	add	s6,a4,a5
40002178:	04812783          	lw	a5,72(sp)
4000217c:	00e32223          	sw	a4,4(t1)
40002180:	0b612223          	sw	s6,164(sp)
40002184:	00f32023          	sw	a5,0(t1)
40002188:	00700713          	li	a4,7
4000218c:	00830c13          	addi	s8,t1,8
40002190:	235740e3          	blt	a4,s5,40002bb0 <_vfprintf_r+0x13bc>
40002194:	03812683          	lw	a3,56(sp)
40002198:	03c12703          	lw	a4,60(sp)
4000219c:	00000613          	li	a2,0
400021a0:	00068513          	mv	a0,a3
400021a4:	00070593          	mv	a1,a4
400021a8:	00000693          	li	a3,0
400021ac:	721080ef          	jal	ra,4000b0cc <__eqdf2>
400021b0:	03412783          	lw	a5,52(sp)
400021b4:	22051863          	bnez	a0,400023e4 <_vfprintf_r+0xbf0>
400021b8:	fff78913          	addi	s2,a5,-1
400021bc:	25205a63          	blez	s2,40002410 <_vfprintf_r+0xc1c>
400021c0:	4000d6b7          	lui	a3,0x4000d
400021c4:	01000c93          	li	s9,16
400021c8:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
400021cc:	1d2cd0e3          	ble	s2,s9,40002b8c <_vfprintf_r+0x1398>
400021d0:	00700d93          	li	s11,7
400021d4:	00c0006f          	j	400021e0 <_vfprintf_r+0x9ec>
400021d8:	ff090913          	addi	s2,s2,-16
400021dc:	1b2cd8e3          	ble	s2,s9,40002b8c <_vfprintf_r+0x1398>
400021e0:	010b0b13          	addi	s6,s6,16
400021e4:	001a8a93          	addi	s5,s5,1
400021e8:	017c2023          	sw	s7,0(s8)
400021ec:	019c2223          	sw	s9,4(s8)
400021f0:	0b612223          	sw	s6,164(sp)
400021f4:	0b512023          	sw	s5,160(sp)
400021f8:	008c0c13          	addi	s8,s8,8
400021fc:	fd5ddee3          	ble	s5,s11,400021d8 <_vfprintf_r+0x9e4>
40002200:	09c10613          	addi	a2,sp,156
40002204:	00098593          	mv	a1,s3
40002208:	000a0513          	mv	a0,s4
4000220c:	0f0050ef          	jal	ra,400072fc <__sprint_r>
40002210:	d40510e3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002214:	0a412b03          	lw	s6,164(sp)
40002218:	0a012a83          	lw	s5,160(sp)
4000221c:	000d0c13          	mv	s8,s10
40002220:	fb9ff06f          	j	400021d8 <_vfprintf_r+0x9e4>
40002224:	09c10613          	addi	a2,sp,156
40002228:	00098593          	mv	a1,s3
4000222c:	000a0513          	mv	a0,s4
40002230:	0cc050ef          	jal	ra,400072fc <__sprint_r>
40002234:	bc050ce3          	beqz	a0,40001e0c <_vfprintf_r+0x618>
40002238:	d19ff06f          	j	40001f50 <_vfprintf_r+0x75c>
4000223c:	01412d83          	lw	s11,20(sp)
40002240:	00100713          	li	a4,1
40002244:	76e78e63          	beq	a5,a4,400029c0 <_vfprintf_r+0x11cc>
40002248:	00200713          	li	a4,2
4000224c:	06e79663          	bne	a5,a4,400022b8 <_vfprintf_r+0xac4>
40002250:	01b12a23          	sw	s11,20(sp)
40002254:	00000c13          	li	s8,0
40002258:	875ff06f          	j	40001acc <_vfprintf_r+0x2d8>
4000225c:	09c10613          	addi	a2,sp,156
40002260:	00098593          	mv	a1,s3
40002264:	000a0513          	mv	a0,s4
40002268:	094050ef          	jal	ra,400072fc <__sprint_r>
4000226c:	ce0512e3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002270:	000d0313          	mv	t1,s10
40002274:	ef8ff06f          	j	4000196c <_vfprintf_r+0x178>
40002278:	09c10613          	addi	a2,sp,156
4000227c:	00098593          	mv	a1,s3
40002280:	000a0513          	mv	a0,s4
40002284:	078050ef          	jal	ra,400072fc <__sprint_r>
40002288:	cc0514e3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
4000228c:	0a412783          	lw	a5,164(sp)
40002290:	000d0313          	mv	t1,s10
40002294:	98dff06f          	j	40001c20 <_vfprintf_r+0x42c>
40002298:	09c10613          	addi	a2,sp,156
4000229c:	00098593          	mv	a1,s3
400022a0:	000a0513          	mv	a0,s4
400022a4:	058050ef          	jal	ra,400072fc <__sprint_r>
400022a8:	ca0514e3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
400022ac:	0a412783          	lw	a5,164(sp)
400022b0:	000d0313          	mv	t1,s10
400022b4:	9a5ff06f          	j	40001c58 <_vfprintf_r+0x464>
400022b8:	01b12a23          	sw	s11,20(sp)
400022bc:	00000c13          	li	s8,0
400022c0:	000d0713          	mv	a4,s10
400022c4:	0080006f          	j	400022cc <_vfprintf_r+0xad8>
400022c8:	00090713          	mv	a4,s2
400022cc:	007c7793          	andi	a5,s8,7
400022d0:	03078793          	addi	a5,a5,48
400022d4:	fef70fa3          	sb	a5,-1(a4)
400022d8:	003c5c13          	srli	s8,s8,0x3
400022dc:	fff70913          	addi	s2,a4,-1
400022e0:	fe0c14e3          	bnez	s8,400022c8 <_vfprintf_r+0xad4>
400022e4:	01412683          	lw	a3,20(sp)
400022e8:	0016f693          	andi	a3,a3,1
400022ec:	800682e3          	beqz	a3,40001af0 <_vfprintf_r+0x2fc>
400022f0:	03000693          	li	a3,48
400022f4:	fed78e63          	beq	a5,a3,40001af0 <_vfprintf_r+0x2fc>
400022f8:	ffe70713          	addi	a4,a4,-2
400022fc:	fed90fa3          	sb	a3,-1(s2)
40002300:	40ed0c33          	sub	s8,s10,a4
40002304:	00070913          	mv	s2,a4
40002308:	fecff06f          	j	40001af4 <_vfprintf_r+0x300>
4000230c:	000a0513          	mv	a0,s4
40002310:	0b0030ef          	jal	ra,400053c0 <__sinit>
40002314:	d4cff06f          	j	40001860 <_vfprintf_r+0x6c>
40002318:	08412683          	lw	a3,132(sp)
4000231c:	b0d058e3          	blez	a3,40001e2c <_vfprintf_r+0x638>
40002320:	03012703          	lw	a4,48(sp)
40002324:	03412683          	lw	a3,52(sp)
40002328:	00070a93          	mv	s5,a4
4000232c:	00e6d463          	ble	a4,a3,40002334 <_vfprintf_r+0xb40>
40002330:	00068a93          	mv	s5,a3
40002334:	03505663          	blez	s5,40002360 <_vfprintf_r+0xb6c>
40002338:	0a012703          	lw	a4,160(sp)
4000233c:	015787b3          	add	a5,a5,s5
40002340:	01232023          	sw	s2,0(t1)
40002344:	00170713          	addi	a4,a4,1
40002348:	01532223          	sw	s5,4(t1)
4000234c:	0af12223          	sw	a5,164(sp)
40002350:	0ae12023          	sw	a4,160(sp)
40002354:	00700693          	li	a3,7
40002358:	00830313          	addi	t1,t1,8
4000235c:	24e6cae3          	blt	a3,a4,40002db0 <_vfprintf_r+0x15bc>
40002360:	4c0ac4e3          	bltz	s5,40003028 <_vfprintf_r+0x1834>
40002364:	03012703          	lw	a4,48(sp)
40002368:	41570ab3          	sub	s5,a4,s5
4000236c:	6b505663          	blez	s5,40002a18 <_vfprintf_r+0x1224>
40002370:	4000d6b7          	lui	a3,0x4000d
40002374:	01000c13          	li	s8,16
40002378:	0a012703          	lw	a4,160(sp)
4000237c:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
40002380:	655c5c63          	ble	s5,s8,400029d8 <_vfprintf_r+0x11e4>
40002384:	00700c93          	li	s9,7
40002388:	00c0006f          	j	40002394 <_vfprintf_r+0xba0>
4000238c:	ff0a8a93          	addi	s5,s5,-16
40002390:	655c5463          	ble	s5,s8,400029d8 <_vfprintf_r+0x11e4>
40002394:	01078793          	addi	a5,a5,16
40002398:	00170713          	addi	a4,a4,1
4000239c:	01732023          	sw	s7,0(t1)
400023a0:	01832223          	sw	s8,4(t1)
400023a4:	0af12223          	sw	a5,164(sp)
400023a8:	0ae12023          	sw	a4,160(sp)
400023ac:	00830313          	addi	t1,t1,8
400023b0:	fcecdee3          	ble	a4,s9,4000238c <_vfprintf_r+0xb98>
400023b4:	09c10613          	addi	a2,sp,156
400023b8:	00098593          	mv	a1,s3
400023bc:	000a0513          	mv	a0,s4
400023c0:	73d040ef          	jal	ra,400072fc <__sprint_r>
400023c4:	b80516e3          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
400023c8:	0a412783          	lw	a5,164(sp)
400023cc:	0a012703          	lw	a4,160(sp)
400023d0:	000d0313          	mv	t1,s10
400023d4:	fb9ff06f          	j	4000238c <_vfprintf_r+0xb98>
400023d8:	00000c13          	li	s8,0
400023dc:	000d0913          	mv	s2,s10
400023e0:	f14ff06f          	j	40001af4 <_vfprintf_r+0x300>
400023e4:	fff78713          	addi	a4,a5,-1
400023e8:	00eb0b33          	add	s6,s6,a4
400023ec:	00190913          	addi	s2,s2,1
400023f0:	001a8a93          	addi	s5,s5,1
400023f4:	00ec2223          	sw	a4,4(s8)
400023f8:	012c2023          	sw	s2,0(s8)
400023fc:	0b612223          	sw	s6,164(sp)
40002400:	0b512023          	sw	s5,160(sp)
40002404:	00700713          	li	a4,7
40002408:	43574263          	blt	a4,s5,4000282c <_vfprintf_r+0x1038>
4000240c:	008c0c13          	addi	s8,s8,8
40002410:	04c12683          	lw	a3,76(sp)
40002414:	08c10713          	addi	a4,sp,140
40002418:	001a8a93          	addi	s5,s5,1
4000241c:	016687b3          	add	a5,a3,s6
40002420:	00ec2023          	sw	a4,0(s8)
40002424:	00dc2223          	sw	a3,4(s8)
40002428:	0af12223          	sw	a5,164(sp)
4000242c:	0b512023          	sw	s5,160(sp)
40002430:	00700713          	li	a4,7
40002434:	008c0313          	addi	t1,s8,8
40002438:	91575ae3          	ble	s5,a4,40001d4c <_vfprintf_r+0x558>
4000243c:	addff06f          	j	40001f18 <_vfprintf_r+0x724>
40002440:	00050613          	mv	a2,a0
40002444:	00080593          	mv	a1,a6
40002448:	d70ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
4000244c:	700616e3          	bnez	a2,40003358 <_vfprintf_r+0x1b64>
40002450:	010df793          	andi	a5,s11,16
40002454:	6e079863          	bnez	a5,40002b44 <_vfprintf_r+0x1350>
40002458:	040dfe93          	andi	t4,s11,64
4000245c:	6e0e8463          	beqz	t4,40002b44 <_vfprintf_r+0x1350>
40002460:	02012703          	lw	a4,32(sp)
40002464:	00072783          	lw	a5,0(a4)
40002468:	00470713          	addi	a4,a4,4
4000246c:	02e12023          	sw	a4,32(sp)
40002470:	01c15703          	lhu	a4,28(sp)
40002474:	00e79023          	sh	a4,0(a5)
40002478:	c98ff06f          	j	40001910 <_vfprintf_r+0x11c>
4000247c:	02012783          	lw	a5,32(sp)
40002480:	06010fa3          	sb	zero,127(sp)
40002484:	0007a903          	lw	s2,0(a5)
40002488:	00478b93          	addi	s7,a5,4
4000248c:	3a0902e3          	beqz	s2,40003030 <_vfprintf_r+0x183c>
40002490:	fff00793          	li	a5,-1
40002494:	22fb0ae3          	beq	s6,a5,40002ec8 <_vfprintf_r+0x16d4>
40002498:	000b0613          	mv	a2,s6
4000249c:	00000593          	li	a1,0
400024a0:	00090513          	mv	a0,s2
400024a4:	00612823          	sw	t1,16(sp)
400024a8:	7b0030ef          	jal	ra,40005c58 <memchr>
400024ac:	01012303          	lw	t1,16(sp)
400024b0:	4c0502e3          	beqz	a0,40003174 <_vfprintf_r+0x1980>
400024b4:	41250c33          	sub	s8,a0,s2
400024b8:	01812823          	sw	s8,16(sp)
400024bc:	220c44e3          	bltz	s8,40002ee4 <_vfprintf_r+0x16f0>
400024c0:	07f14603          	lbu	a2,127(sp)
400024c4:	03712023          	sw	s7,32(sp)
400024c8:	01b12a23          	sw	s11,20(sp)
400024cc:	00000b13          	li	s6,0
400024d0:	02012823          	sw	zero,48(sp)
400024d4:	e30ff06f          	j	40001b04 <_vfprintf_r+0x310>
400024d8:	680614e3          	bnez	a2,40003360 <_vfprintf_r+0x1b6c>
400024dc:	010ded93          	ori	s11,s11,16
400024e0:	010df793          	andi	a5,s11,16
400024e4:	38079063          	bnez	a5,40002864 <_vfprintf_r+0x1070>
400024e8:	040df793          	andi	a5,s11,64
400024ec:	36078c63          	beqz	a5,40002864 <_vfprintf_r+0x1070>
400024f0:	02012783          	lw	a5,32(sp)
400024f4:	00079c03          	lh	s8,0(a5)
400024f8:	00478793          	addi	a5,a5,4
400024fc:	02f12023          	sw	a5,32(sp)
40002500:	6c0c4a63          	bltz	s8,40002bd4 <_vfprintf_r+0x13e0>
40002504:	07f14603          	lbu	a2,127(sp)
40002508:	00100793          	li	a5,1
4000250c:	d0cff06f          	j	40001a18 <_vfprintf_r+0x224>
40002510:	62061ce3          	bnez	a2,40003348 <_vfprintf_r+0x1b54>
40002514:	008df793          	andi	a5,s11,8
40002518:	02078ee3          	beqz	a5,40002d54 <_vfprintf_r+0x1560>
4000251c:	02012703          	lw	a4,32(sp)
40002520:	06010513          	addi	a0,sp,96
40002524:	00612823          	sw	t1,16(sp)
40002528:	00072783          	lw	a5,0(a4)
4000252c:	00470693          	addi	a3,a4,4
40002530:	02d12023          	sw	a3,32(sp)
40002534:	0007a703          	lw	a4,0(a5)
40002538:	06e12023          	sw	a4,96(sp)
4000253c:	0047a703          	lw	a4,4(a5)
40002540:	06e12223          	sw	a4,100(sp)
40002544:	0087a703          	lw	a4,8(a5)
40002548:	06e12423          	sw	a4,104(sp)
4000254c:	00c7a783          	lw	a5,12(a5)
40002550:	06f12623          	sw	a5,108(sp)
40002554:	55c0a0ef          	jal	ra,4000cab0 <__trunctfdf2>
40002558:	01012303          	lw	t1,16(sp)
4000255c:	02a12c23          	sw	a0,56(sp)
40002560:	02b12e23          	sw	a1,60(sp)
40002564:	03c12783          	lw	a5,60(sp)
40002568:	80000937          	lui	s2,0x80000
4000256c:	03812b83          	lw	s7,56(sp)
40002570:	fff94913          	not	s2,s2
40002574:	05012603          	lw	a2,80(sp)
40002578:	05412683          	lw	a3,84(sp)
4000257c:	0127f933          	and	s2,a5,s2
40002580:	000b8513          	mv	a0,s7
40002584:	00090593          	mv	a1,s2
40002588:	00612823          	sw	t1,16(sp)
4000258c:	761090ef          	jal	ra,4000c4ec <__unorddf2>
40002590:	01012303          	lw	t1,16(sp)
40002594:	64051c63          	bnez	a0,40002bec <_vfprintf_r+0x13f8>
40002598:	05812603          	lw	a2,88(sp)
4000259c:	05c12683          	lw	a3,92(sp)
400025a0:	000b8513          	mv	a0,s7
400025a4:	00090593          	mv	a1,s2
400025a8:	4b5080ef          	jal	ra,4000b25c <__ledf2>
400025ac:	01012303          	lw	t1,16(sp)
400025b0:	62a05e63          	blez	a0,40002bec <_vfprintf_r+0x13f8>
400025b4:	03812703          	lw	a4,56(sp)
400025b8:	03c12783          	lw	a5,60(sp)
400025bc:	00000613          	li	a2,0
400025c0:	00070513          	mv	a0,a4
400025c4:	00078593          	mv	a1,a5
400025c8:	00000693          	li	a3,0
400025cc:	00612823          	sw	t1,16(sp)
400025d0:	48d080ef          	jal	ra,4000b25c <__ledf2>
400025d4:	01012303          	lw	t1,16(sp)
400025d8:	28054ee3          	bltz	a0,40003074 <_vfprintf_r+0x1880>
400025dc:	07f14603          	lbu	a2,127(sp)
400025e0:	04700793          	li	a5,71
400025e4:	7d57d063          	ble	s5,a5,40002da4 <_vfprintf_r+0x15b0>
400025e8:	4000d937          	lui	s2,0x4000d
400025ec:	72890913          	addi	s2,s2,1832 # 4000d728 <zeroes.4139+0x14>
400025f0:	00300793          	li	a5,3
400025f4:	f7fdf713          	andi	a4,s11,-129
400025f8:	00f12823          	sw	a5,16(sp)
400025fc:	00e12a23          	sw	a4,20(sp)
40002600:	00078c13          	mv	s8,a5
40002604:	00000b13          	li	s6,0
40002608:	02012823          	sw	zero,48(sp)
4000260c:	cf8ff06f          	j	40001b04 <_vfprintf_r+0x310>
40002610:	00044a83          	lbu	s5,0(s0)
40002614:	00140413          	addi	s0,s0,1
40002618:	4f1a84e3          	beq	s5,a7,40003300 <_vfprintf_r+0x1b0c>
4000261c:	fd0a8e13          	addi	t3,s5,-48
40002620:	00000b13          	li	s6,0
40002624:	b9c6ee63          	bltu	a3,t3,400019c0 <_vfprintf_r+0x1cc>
40002628:	00140413          	addi	s0,s0,1
4000262c:	002b1793          	slli	a5,s6,0x2
40002630:	fff44a83          	lbu	s5,-1(s0)
40002634:	016787b3          	add	a5,a5,s6
40002638:	00179793          	slli	a5,a5,0x1
4000263c:	01c78b33          	add	s6,a5,t3
40002640:	fd0a8e13          	addi	t3,s5,-48
40002644:	ffc6f2e3          	bleu	t3,a3,40002628 <_vfprintf_r+0xe34>
40002648:	b78ff06f          	j	400019c0 <_vfprintf_r+0x1cc>
4000264c:	080ded93          	ori	s11,s11,128
40002650:	b68ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
40002654:	040ded93          	ori	s11,s11,64
40002658:	b60ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
4000265c:	50061ee3          	bnez	a2,40003378 <_vfprintf_r+0x1b84>
40002660:	4000d7b7          	lui	a5,0x4000d
40002664:	74878793          	addi	a5,a5,1864 # 4000d748 <zeroes.4139+0x34>
40002668:	04f12223          	sw	a5,68(sp)
4000266c:	010df793          	andi	a5,s11,16
40002670:	1e079063          	bnez	a5,40002850 <_vfprintf_r+0x105c>
40002674:	040df793          	andi	a5,s11,64
40002678:	1c078c63          	beqz	a5,40002850 <_vfprintf_r+0x105c>
4000267c:	02012783          	lw	a5,32(sp)
40002680:	0007dc03          	lhu	s8,0(a5)
40002684:	00478793          	addi	a5,a5,4
40002688:	02f12023          	sw	a5,32(sp)
4000268c:	001df713          	andi	a4,s11,1
40002690:	00200793          	li	a5,2
40002694:	b6070e63          	beqz	a4,40001a10 <_vfprintf_r+0x21c>
40002698:	b60c0c63          	beqz	s8,40001a10 <_vfprintf_r+0x21c>
4000269c:	03000713          	li	a4,48
400026a0:	08e10023          	sb	a4,128(sp)
400026a4:	095100a3          	sb	s5,129(sp)
400026a8:	00fdedb3          	or	s11,s11,a5
400026ac:	b64ff06f          	j	40001a10 <_vfprintf_r+0x21c>
400026b0:	001ded93          	ori	s11,s11,1
400026b4:	b04ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
400026b8:	b0059063          	bnez	a1,400019b8 <_vfprintf_r+0x1c4>
400026bc:	00050613          	mv	a2,a0
400026c0:	000f0593          	mv	a1,t5
400026c4:	af4ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
400026c8:	02012703          	lw	a4,32(sp)
400026cc:	03000793          	li	a5,48
400026d0:	08f10023          	sb	a5,128(sp)
400026d4:	07800793          	li	a5,120
400026d8:	08f100a3          	sb	a5,129(sp)
400026dc:	00470793          	addi	a5,a4,4
400026e0:	02f12023          	sw	a5,32(sp)
400026e4:	4000d7b7          	lui	a5,0x4000d
400026e8:	74878793          	addi	a5,a5,1864 # 4000d748 <zeroes.4139+0x34>
400026ec:	04f12223          	sw	a5,68(sp)
400026f0:	00072c03          	lw	s8,0(a4)
400026f4:	002ded93          	ori	s11,s11,2
400026f8:	00200793          	li	a5,2
400026fc:	07800a93          	li	s5,120
40002700:	b10ff06f          	j	40001a10 <_vfprintf_r+0x21c>
40002704:	00000493          	li	s1,0
40002708:	fd0a8e13          	addi	t3,s5,-48
4000270c:	00140413          	addi	s0,s0,1
40002710:	00249793          	slli	a5,s1,0x2
40002714:	fff44a83          	lbu	s5,-1(s0)
40002718:	009787b3          	add	a5,a5,s1
4000271c:	00179793          	slli	a5,a5,0x1
40002720:	00fe04b3          	add	s1,t3,a5
40002724:	fd0a8e13          	addi	t3,s5,-48
40002728:	ffc6f2e3          	bleu	t3,a3,4000270c <_vfprintf_r+0xf18>
4000272c:	a94ff06f          	j	400019c0 <_vfprintf_r+0x1cc>
40002730:	008ded93          	ori	s11,s11,8
40002734:	a84ff06f          	j	400019b8 <_vfprintf_r+0x1c4>
40002738:	02012703          	lw	a4,32(sp)
4000273c:	00100693          	li	a3,1
40002740:	00d12823          	sw	a3,16(sp)
40002744:	00072783          	lw	a5,0(a4)
40002748:	06010fa3          	sb	zero,127(sp)
4000274c:	01b12a23          	sw	s11,20(sp)
40002750:	0af10423          	sb	a5,168(sp)
40002754:	00470793          	addi	a5,a4,4
40002758:	02f12023          	sw	a5,32(sp)
4000275c:	00000613          	li	a2,0
40002760:	00068c13          	mv	s8,a3
40002764:	00000b13          	li	s6,0
40002768:	02012823          	sw	zero,48(sp)
4000276c:	0a810913          	addi	s2,sp,168
40002770:	ba4ff06f          	j	40001b14 <_vfprintf_r+0x320>
40002774:	d60606e3          	beqz	a2,400024e0 <_vfprintf_r+0xcec>
40002778:	06b10fa3          	sb	a1,127(sp)
4000277c:	d65ff06f          	j	400024e0 <_vfprintf_r+0xcec>
40002780:	3e0618e3          	bnez	a2,40003370 <_vfprintf_r+0x1b7c>
40002784:	4000d7b7          	lui	a5,0x4000d
40002788:	73478793          	addi	a5,a5,1844 # 4000d734 <zeroes.4139+0x20>
4000278c:	04f12223          	sw	a5,68(sp)
40002790:	eddff06f          	j	4000266c <_vfprintf_r+0xe78>
40002794:	09c10613          	addi	a2,sp,156
40002798:	00098593          	mv	a1,s3
4000279c:	000a0513          	mv	a0,s4
400027a0:	35d040ef          	jal	ra,400072fc <__sprint_r>
400027a4:	fa051663          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
400027a8:	0a412783          	lw	a5,164(sp)
400027ac:	e44ff06f          	j	40001df0 <_vfprintf_r+0x5fc>
400027b0:	00075c03          	lhu	s8,0(a4)
400027b4:	00470713          	addi	a4,a4,4
400027b8:	00000793          	li	a5,0
400027bc:	02e12023          	sw	a4,32(sp)
400027c0:	a50ff06f          	j	40001a10 <_vfprintf_r+0x21c>
400027c4:	3a0612e3          	bnez	a2,40003368 <_vfprintf_r+0x1b74>
400027c8:	f60a8863          	beqz	s5,40001f38 <_vfprintf_r+0x744>
400027cc:	00100793          	li	a5,1
400027d0:	00f12823          	sw	a5,16(sp)
400027d4:	0b510423          	sb	s5,168(sp)
400027d8:	06010fa3          	sb	zero,127(sp)
400027dc:	01b12a23          	sw	s11,20(sp)
400027e0:	00000613          	li	a2,0
400027e4:	00078c13          	mv	s8,a5
400027e8:	00000b13          	li	s6,0
400027ec:	02012823          	sw	zero,48(sp)
400027f0:	0a810913          	addi	s2,sp,168
400027f4:	b20ff06f          	j	40001b14 <_vfprintf_r+0x320>
400027f8:	01412683          	lw	a3,20(sp)
400027fc:	00e6f6b3          	and	a3,a3,a4
40002800:	92069ee3          	bnez	a3,4000213c <_vfprintf_r+0x948>
40002804:	0a012a83          	lw	s5,160(sp)
40002808:	00178b13          	addi	s6,a5,1
4000280c:	00e32223          	sw	a4,4(t1)
40002810:	001a8a93          	addi	s5,s5,1
40002814:	01232023          	sw	s2,0(t1)
40002818:	0b612223          	sw	s6,164(sp)
4000281c:	0b512023          	sw	s5,160(sp)
40002820:	00700713          	li	a4,7
40002824:	00830c13          	addi	s8,t1,8
40002828:	bf5754e3          	ble	s5,a4,40002410 <_vfprintf_r+0xc1c>
4000282c:	09c10613          	addi	a2,sp,156
40002830:	00098593          	mv	a1,s3
40002834:	000a0513          	mv	a0,s4
40002838:	2c5040ef          	jal	ra,400072fc <__sprint_r>
4000283c:	f0051a63          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002840:	0a412b03          	lw	s6,164(sp)
40002844:	0a012a83          	lw	s5,160(sp)
40002848:	000d0c13          	mv	s8,s10
4000284c:	bc5ff06f          	j	40002410 <_vfprintf_r+0xc1c>
40002850:	02012783          	lw	a5,32(sp)
40002854:	0007ac03          	lw	s8,0(a5)
40002858:	00478793          	addi	a5,a5,4
4000285c:	02f12023          	sw	a5,32(sp)
40002860:	e2dff06f          	j	4000268c <_vfprintf_r+0xe98>
40002864:	02012783          	lw	a5,32(sp)
40002868:	0007ac03          	lw	s8,0(a5)
4000286c:	00478793          	addi	a5,a5,4
40002870:	02f12023          	sw	a5,32(sp)
40002874:	c8dff06f          	j	40002500 <_vfprintf_r+0xd0c>
40002878:	00900793          	li	a5,9
4000287c:	000d0913          	mv	s2,s10
40002880:	00a00b93          	li	s7,10
40002884:	00030c93          	mv	s9,t1
40002888:	00060d93          	mv	s11,a2
4000288c:	1387f863          	bleu	s8,a5,400029bc <_vfprintf_r+0x11c8>
40002890:	000b8593          	mv	a1,s7
40002894:	000c0513          	mv	a0,s8
40002898:	68c0a0ef          	jal	ra,4000cf24 <__umodsi3>
4000289c:	03050513          	addi	a0,a0,48
400028a0:	fff90913          	addi	s2,s2,-1
400028a4:	00a90023          	sb	a0,0(s2)
400028a8:	000b8593          	mv	a1,s7
400028ac:	000c0513          	mv	a0,s8
400028b0:	62c0a0ef          	jal	ra,4000cedc <__udivsi3>
400028b4:	00050c13          	mv	s8,a0
400028b8:	fc051ce3          	bnez	a0,40002890 <_vfprintf_r+0x109c>
400028bc:	000c8313          	mv	t1,s9
400028c0:	000d8613          	mv	a2,s11
400028c4:	412d0c33          	sub	s8,s10,s2
400028c8:	a2cff06f          	j	40001af4 <_vfprintf_r+0x300>
400028cc:	09c10613          	addi	a2,sp,156
400028d0:	00098593          	mv	a1,s3
400028d4:	000a0513          	mv	a0,s4
400028d8:	225040ef          	jal	ra,400072fc <__sprint_r>
400028dc:	e6051a63          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
400028e0:	07f14603          	lbu	a2,127(sp)
400028e4:	0a412783          	lw	a5,164(sp)
400028e8:	000d0313          	mv	t1,s10
400028ec:	b00ff06f          	j	40001bec <_vfprintf_r+0x3f8>
400028f0:	04812783          	lw	a5,72(sp)
400028f4:	04012683          	lw	a3,64(sp)
400028f8:	0a012703          	lw	a4,160(sp)
400028fc:	00f32023          	sw	a5,0(t1)
40002900:	0a412783          	lw	a5,164(sp)
40002904:	00170713          	addi	a4,a4,1
40002908:	00d32223          	sw	a3,4(t1)
4000290c:	00f687b3          	add	a5,a3,a5
40002910:	0af12223          	sw	a5,164(sp)
40002914:	0ae12023          	sw	a4,160(sp)
40002918:	00700693          	li	a3,7
4000291c:	00830313          	addi	t1,t1,8
40002920:	58e6c463          	blt	a3,a4,40002ea8 <_vfprintf_r+0x16b4>
40002924:	03412703          	lw	a4,52(sp)
40002928:	fff70913          	addi	s2,a4,-1
4000292c:	c3205063          	blez	s2,40001d4c <_vfprintf_r+0x558>
40002930:	4000d6b7          	lui	a3,0x4000d
40002934:	01000a93          	li	s5,16
40002938:	0a012703          	lw	a4,160(sp)
4000293c:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
40002940:	052adc63          	ble	s2,s5,40002998 <_vfprintf_r+0x11a4>
40002944:	00700c13          	li	s8,7
40002948:	00c0006f          	j	40002954 <_vfprintf_r+0x1160>
4000294c:	ff090913          	addi	s2,s2,-16
40002950:	052ad463          	ble	s2,s5,40002998 <_vfprintf_r+0x11a4>
40002954:	01078793          	addi	a5,a5,16
40002958:	00170713          	addi	a4,a4,1
4000295c:	01732023          	sw	s7,0(t1)
40002960:	01532223          	sw	s5,4(t1)
40002964:	0af12223          	sw	a5,164(sp)
40002968:	0ae12023          	sw	a4,160(sp)
4000296c:	00830313          	addi	t1,t1,8
40002970:	fcec5ee3          	ble	a4,s8,4000294c <_vfprintf_r+0x1158>
40002974:	09c10613          	addi	a2,sp,156
40002978:	00098593          	mv	a1,s3
4000297c:	000a0513          	mv	a0,s4
40002980:	17d040ef          	jal	ra,400072fc <__sprint_r>
40002984:	dc051663          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002988:	0a412783          	lw	a5,164(sp)
4000298c:	0a012703          	lw	a4,160(sp)
40002990:	000d0313          	mv	t1,s10
40002994:	fb9ff06f          	j	4000294c <_vfprintf_r+0x1158>
40002998:	01732023          	sw	s7,0(t1)
4000299c:	01232223          	sw	s2,4(t1)
400029a0:	012787b3          	add	a5,a5,s2
400029a4:	00170713          	addi	a4,a4,1
400029a8:	0af12223          	sw	a5,164(sp)
400029ac:	0ae12023          	sw	a4,160(sp)
400029b0:	00700693          	li	a3,7
400029b4:	b8e6da63          	ble	a4,a3,40001d48 <_vfprintf_r+0x554>
400029b8:	d60ff06f          	j	40001f18 <_vfprintf_r+0x724>
400029bc:	01412d83          	lw	s11,20(sp)
400029c0:	030c0c13          	addi	s8,s8,48
400029c4:	0d8107a3          	sb	s8,207(sp)
400029c8:	01b12a23          	sw	s11,20(sp)
400029cc:	00100c13          	li	s8,1
400029d0:	0cf10913          	addi	s2,sp,207
400029d4:	920ff06f          	j	40001af4 <_vfprintf_r+0x300>
400029d8:	015787b3          	add	a5,a5,s5
400029dc:	00170713          	addi	a4,a4,1
400029e0:	01732023          	sw	s7,0(t1)
400029e4:	01532223          	sw	s5,4(t1)
400029e8:	0af12223          	sw	a5,164(sp)
400029ec:	0ae12023          	sw	a4,160(sp)
400029f0:	00700693          	li	a3,7
400029f4:	00830313          	addi	t1,t1,8
400029f8:	02e6d063          	ble	a4,a3,40002a18 <_vfprintf_r+0x1224>
400029fc:	09c10613          	addi	a2,sp,156
40002a00:	00098593          	mv	a1,s3
40002a04:	000a0513          	mv	a0,s4
40002a08:	0f5040ef          	jal	ra,400072fc <__sprint_r>
40002a0c:	d4051263          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002a10:	0a412783          	lw	a5,164(sp)
40002a14:	000d0313          	mv	t1,s10
40002a18:	08412703          	lw	a4,132(sp)
40002a1c:	03412683          	lw	a3,52(sp)
40002a20:	0cd74863          	blt	a4,a3,40002af0 <_vfprintf_r+0x12fc>
40002a24:	01412683          	lw	a3,20(sp)
40002a28:	0016f693          	andi	a3,a3,1
40002a2c:	0c069263          	bnez	a3,40002af0 <_vfprintf_r+0x12fc>
40002a30:	03412683          	lw	a3,52(sp)
40002a34:	03012603          	lw	a2,48(sp)
40002a38:	40e68733          	sub	a4,a3,a4
40002a3c:	40c68ab3          	sub	s5,a3,a2
40002a40:	01575463          	ble	s5,a4,40002a48 <_vfprintf_r+0x1254>
40002a44:	00070a93          	mv	s5,a4
40002a48:	03505a63          	blez	s5,40002a7c <_vfprintf_r+0x1288>
40002a4c:	0a012603          	lw	a2,160(sp)
40002a50:	03012683          	lw	a3,48(sp)
40002a54:	015787b3          	add	a5,a5,s5
40002a58:	00160613          	addi	a2,a2,1
40002a5c:	00d906b3          	add	a3,s2,a3
40002a60:	00d32023          	sw	a3,0(t1)
40002a64:	01532223          	sw	s5,4(t1)
40002a68:	0af12223          	sw	a5,164(sp)
40002a6c:	0ac12023          	sw	a2,160(sp)
40002a70:	00700693          	li	a3,7
40002a74:	00830313          	addi	t1,t1,8
40002a78:	34c6cc63          	blt	a3,a2,40002dd0 <_vfprintf_r+0x15dc>
40002a7c:	5e0ac463          	bltz	s5,40003064 <_vfprintf_r+0x1870>
40002a80:	41570933          	sub	s2,a4,s5
40002a84:	ad205463          	blez	s2,40001d4c <_vfprintf_r+0x558>
40002a88:	4000d6b7          	lui	a3,0x4000d
40002a8c:	01000a93          	li	s5,16
40002a90:	0a012703          	lw	a4,160(sp)
40002a94:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
40002a98:	f12ad0e3          	ble	s2,s5,40002998 <_vfprintf_r+0x11a4>
40002a9c:	00700c13          	li	s8,7
40002aa0:	00c0006f          	j	40002aac <_vfprintf_r+0x12b8>
40002aa4:	ff090913          	addi	s2,s2,-16
40002aa8:	ef2ad8e3          	ble	s2,s5,40002998 <_vfprintf_r+0x11a4>
40002aac:	01078793          	addi	a5,a5,16
40002ab0:	00170713          	addi	a4,a4,1
40002ab4:	01732023          	sw	s7,0(t1)
40002ab8:	01532223          	sw	s5,4(t1)
40002abc:	0af12223          	sw	a5,164(sp)
40002ac0:	0ae12023          	sw	a4,160(sp)
40002ac4:	00830313          	addi	t1,t1,8
40002ac8:	fcec5ee3          	ble	a4,s8,40002aa4 <_vfprintf_r+0x12b0>
40002acc:	09c10613          	addi	a2,sp,156
40002ad0:	00098593          	mv	a1,s3
40002ad4:	000a0513          	mv	a0,s4
40002ad8:	025040ef          	jal	ra,400072fc <__sprint_r>
40002adc:	c6051a63          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002ae0:	0a412783          	lw	a5,164(sp)
40002ae4:	0a012703          	lw	a4,160(sp)
40002ae8:	000d0313          	mv	t1,s10
40002aec:	fb9ff06f          	j	40002aa4 <_vfprintf_r+0x12b0>
40002af0:	04812683          	lw	a3,72(sp)
40002af4:	04012603          	lw	a2,64(sp)
40002af8:	00830313          	addi	t1,t1,8
40002afc:	fed32c23          	sw	a3,-8(t1)
40002b00:	0a012683          	lw	a3,160(sp)
40002b04:	00c787b3          	add	a5,a5,a2
40002b08:	fec32e23          	sw	a2,-4(t1)
40002b0c:	00168693          	addi	a3,a3,1
40002b10:	0af12223          	sw	a5,164(sp)
40002b14:	0ad12023          	sw	a3,160(sp)
40002b18:	00700613          	li	a2,7
40002b1c:	f0d65ae3          	ble	a3,a2,40002a30 <_vfprintf_r+0x123c>
40002b20:	09c10613          	addi	a2,sp,156
40002b24:	00098593          	mv	a1,s3
40002b28:	000a0513          	mv	a0,s4
40002b2c:	7d0040ef          	jal	ra,400072fc <__sprint_r>
40002b30:	c2051063          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002b34:	08412703          	lw	a4,132(sp)
40002b38:	0a412783          	lw	a5,164(sp)
40002b3c:	000d0313          	mv	t1,s10
40002b40:	ef1ff06f          	j	40002a30 <_vfprintf_r+0x123c>
40002b44:	02012703          	lw	a4,32(sp)
40002b48:	00072783          	lw	a5,0(a4)
40002b4c:	00470713          	addi	a4,a4,4
40002b50:	02e12023          	sw	a4,32(sp)
40002b54:	01c12703          	lw	a4,28(sp)
40002b58:	00e7a023          	sw	a4,0(a5)
40002b5c:	db5fe06f          	j	40001910 <_vfprintf_r+0x11c>
40002b60:	09c10613          	addi	a2,sp,156
40002b64:	00098593          	mv	a1,s3
40002b68:	000a0513          	mv	a0,s4
40002b6c:	790040ef          	jal	ra,400072fc <__sprint_r>
40002b70:	be051063          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002b74:	0a412783          	lw	a5,164(sp)
40002b78:	0a012a83          	lw	s5,160(sp)
40002b7c:	000d0313          	mv	t1,s10
40002b80:	de8ff06f          	j	40002168 <_vfprintf_r+0x974>
40002b84:	02012703          	lw	a4,32(sp)
40002b88:	e79fe06f          	j	40001a00 <_vfprintf_r+0x20c>
40002b8c:	012b0b33          	add	s6,s6,s2
40002b90:	001a8a93          	addi	s5,s5,1
40002b94:	017c2023          	sw	s7,0(s8)
40002b98:	012c2223          	sw	s2,4(s8)
40002b9c:	0b612223          	sw	s6,164(sp)
40002ba0:	0b512023          	sw	s5,160(sp)
40002ba4:	00700713          	li	a4,7
40002ba8:	875752e3          	ble	s5,a4,4000240c <_vfprintf_r+0xc18>
40002bac:	c81ff06f          	j	4000282c <_vfprintf_r+0x1038>
40002bb0:	09c10613          	addi	a2,sp,156
40002bb4:	00098593          	mv	a1,s3
40002bb8:	000a0513          	mv	a0,s4
40002bbc:	740040ef          	jal	ra,400072fc <__sprint_r>
40002bc0:	b8051863          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002bc4:	0a412b03          	lw	s6,164(sp)
40002bc8:	0a012a83          	lw	s5,160(sp)
40002bcc:	000d0c13          	mv	s8,s10
40002bd0:	dc4ff06f          	j	40002194 <_vfprintf_r+0x9a0>
40002bd4:	02d00793          	li	a5,45
40002bd8:	06f10fa3          	sb	a5,127(sp)
40002bdc:	41800c33          	neg	s8,s8
40002be0:	02d00613          	li	a2,45
40002be4:	00100793          	li	a5,1
40002be8:	e31fe06f          	j	40001a18 <_vfprintf_r+0x224>
40002bec:	03812803          	lw	a6,56(sp)
40002bf0:	03c12583          	lw	a1,60(sp)
40002bf4:	00612823          	sw	t1,16(sp)
40002bf8:	00080613          	mv	a2,a6
40002bfc:	00080513          	mv	a0,a6
40002c00:	00058693          	mv	a3,a1
40002c04:	0e9090ef          	jal	ra,4000c4ec <__unorddf2>
40002c08:	01012303          	lw	t1,16(sp)
40002c0c:	66051e63          	bnez	a0,40003288 <_vfprintf_r+0x1a94>
40002c10:	fff00793          	li	a5,-1
40002c14:	fdfafb93          	andi	s7,s5,-33
40002c18:	44fb0a63          	beq	s6,a5,4000306c <_vfprintf_r+0x1878>
40002c1c:	04700793          	li	a5,71
40002c20:	22fb8e63          	beq	s7,a5,40002e5c <_vfprintf_r+0x1668>
40002c24:	100de793          	ori	a5,s11,256
40002c28:	00f12a23          	sw	a5,20(sp)
40002c2c:	03c12783          	lw	a5,60(sp)
40002c30:	00012c23          	sw	zero,24(sp)
40002c34:	00078c93          	mv	s9,a5
40002c38:	4807c863          	bltz	a5,400030c8 <_vfprintf_r+0x18d4>
40002c3c:	06600793          	li	a5,102
40002c40:	44fa8263          	beq	s5,a5,40003084 <_vfprintf_r+0x1890>
40002c44:	04600793          	li	a5,70
40002c48:	1afa8a63          	beq	s5,a5,40002dfc <_vfprintf_r+0x1608>
40002c4c:	03812703          	lw	a4,56(sp)
40002c50:	fbbb8793          	addi	a5,s7,-69
40002c54:	0017b593          	seqz	a1,a5
40002c58:	00bb0e33          	add	t3,s6,a1
40002c5c:	09410793          	addi	a5,sp,148
40002c60:	00070613          	mv	a2,a4
40002c64:	00f12023          	sw	a5,0(sp)
40002c68:	000c8693          	mv	a3,s9
40002c6c:	000e0793          	mv	a5,t3
40002c70:	08810893          	addi	a7,sp,136
40002c74:	08410813          	addi	a6,sp,132
40002c78:	00200713          	li	a4,2
40002c7c:	000a0513          	mv	a0,s4
40002c80:	02612423          	sw	t1,40(sp)
40002c84:	01c12823          	sw	t3,16(sp)
40002c88:	36d000ef          	jal	ra,400037f4 <_dtoa_r>
40002c8c:	06700793          	li	a5,103
40002c90:	00050913          	mv	s2,a0
40002c94:	01012e03          	lw	t3,16(sp)
40002c98:	02812303          	lw	t1,40(sp)
40002c9c:	4afa9463          	bne	s5,a5,40003144 <_vfprintf_r+0x1950>
40002ca0:	001df793          	andi	a5,s11,1
40002ca4:	01c50c33          	add	s8,a0,t3
40002ca8:	5a078c63          	beqz	a5,40003260 <_vfprintf_r+0x1a6c>
40002cac:	03812783          	lw	a5,56(sp)
40002cb0:	000c8593          	mv	a1,s9
40002cb4:	00000613          	li	a2,0
40002cb8:	00078513          	mv	a0,a5
40002cbc:	00000693          	li	a3,0
40002cc0:	00612823          	sw	t1,16(sp)
40002cc4:	408080ef          	jal	ra,4000b0cc <__eqdf2>
40002cc8:	000c0793          	mv	a5,s8
40002ccc:	01012303          	lw	t1,16(sp)
40002cd0:	02050263          	beqz	a0,40002cf4 <_vfprintf_r+0x1500>
40002cd4:	09412783          	lw	a5,148(sp)
40002cd8:	0187fe63          	bleu	s8,a5,40002cf4 <_vfprintf_r+0x1500>
40002cdc:	03000693          	li	a3,48
40002ce0:	00178713          	addi	a4,a5,1
40002ce4:	08e12a23          	sw	a4,148(sp)
40002ce8:	00d78023          	sb	a3,0(a5)
40002cec:	09412783          	lw	a5,148(sp)
40002cf0:	ff87e8e3          	bltu	a5,s8,40002ce0 <_vfprintf_r+0x14ec>
40002cf4:	412787b3          	sub	a5,a5,s2
40002cf8:	04700713          	li	a4,71
40002cfc:	02f12a23          	sw	a5,52(sp)
40002d00:	20eb8063          	beq	s7,a4,40002f00 <_vfprintf_r+0x170c>
40002d04:	06500793          	li	a5,101
40002d08:	4757d063          	ble	s5,a5,40003168 <_vfprintf_r+0x1974>
40002d0c:	06600793          	li	a5,102
40002d10:	40fa8863          	beq	s5,a5,40003120 <_vfprintf_r+0x192c>
40002d14:	08412783          	lw	a5,132(sp)
40002d18:	02f12823          	sw	a5,48(sp)
40002d1c:	03412703          	lw	a4,52(sp)
40002d20:	03012783          	lw	a5,48(sp)
40002d24:	3ae7cc63          	blt	a5,a4,400030dc <_vfprintf_r+0x18e8>
40002d28:	001dfe93          	andi	t4,s11,1
40002d2c:	3c0e9a63          	bnez	t4,40003100 <_vfprintf_r+0x190c>
40002d30:	00f12823          	sw	a5,16(sp)
40002d34:	6007c663          	bltz	a5,40003340 <_vfprintf_r+0x1b4c>
40002d38:	03012c03          	lw	s8,48(sp)
40002d3c:	06700a93          	li	s5,103
40002d40:	01812783          	lw	a5,24(sp)
40002d44:	1a079463          	bnez	a5,40002eec <_vfprintf_r+0x16f8>
40002d48:	07f14603          	lbu	a2,127(sp)
40002d4c:	00000b13          	li	s6,0
40002d50:	db5fe06f          	j	40001b04 <_vfprintf_r+0x310>
40002d54:	02012783          	lw	a5,32(sp)
40002d58:	00778793          	addi	a5,a5,7
40002d5c:	ff87f793          	andi	a5,a5,-8
40002d60:	0007a703          	lw	a4,0(a5)
40002d64:	00878793          	addi	a5,a5,8
40002d68:	02e12c23          	sw	a4,56(sp)
40002d6c:	ffc7a703          	lw	a4,-4(a5)
40002d70:	02f12023          	sw	a5,32(sp)
40002d74:	02e12e23          	sw	a4,60(sp)
40002d78:	fecff06f          	j	40002564 <_vfprintf_r+0xd70>
40002d7c:	09c10613          	addi	a2,sp,156
40002d80:	00098593          	mv	a1,s3
40002d84:	000a0513          	mv	a0,s4
40002d88:	574040ef          	jal	ra,400072fc <__sprint_r>
40002d8c:	9c051263          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002d90:	000d0313          	mv	t1,s10
40002d94:	a74ff06f          	j	40002008 <_vfprintf_r+0x814>
40002d98:	fff00793          	li	a5,-1
40002d9c:	00f12e23          	sw	a5,28(sp)
40002da0:	9bcff06f          	j	40001f5c <_vfprintf_r+0x768>
40002da4:	4000d937          	lui	s2,0x4000d
40002da8:	72490913          	addi	s2,s2,1828 # 4000d724 <zeroes.4139+0x10>
40002dac:	845ff06f          	j	400025f0 <_vfprintf_r+0xdfc>
40002db0:	09c10613          	addi	a2,sp,156
40002db4:	00098593          	mv	a1,s3
40002db8:	000a0513          	mv	a0,s4
40002dbc:	540040ef          	jal	ra,400072fc <__sprint_r>
40002dc0:	98051863          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002dc4:	0a412783          	lw	a5,164(sp)
40002dc8:	000d0313          	mv	t1,s10
40002dcc:	d94ff06f          	j	40002360 <_vfprintf_r+0xb6c>
40002dd0:	09c10613          	addi	a2,sp,156
40002dd4:	00098593          	mv	a1,s3
40002dd8:	000a0513          	mv	a0,s4
40002ddc:	520040ef          	jal	ra,400072fc <__sprint_r>
40002de0:	96051863          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002de4:	08412703          	lw	a4,132(sp)
40002de8:	03412683          	lw	a3,52(sp)
40002dec:	0a412783          	lw	a5,164(sp)
40002df0:	000d0313          	mv	t1,s10
40002df4:	40e68733          	sub	a4,a3,a4
40002df8:	c85ff06f          	j	40002a7c <_vfprintf_r+0x1288>
40002dfc:	03812703          	lw	a4,56(sp)
40002e00:	09410793          	addi	a5,sp,148
40002e04:	00f12023          	sw	a5,0(sp)
40002e08:	00070613          	mv	a2,a4
40002e0c:	000c8693          	mv	a3,s9
40002e10:	08810893          	addi	a7,sp,136
40002e14:	08410813          	addi	a6,sp,132
40002e18:	000b0793          	mv	a5,s6
40002e1c:	00300713          	li	a4,3
40002e20:	000a0513          	mv	a0,s4
40002e24:	00612823          	sw	t1,16(sp)
40002e28:	1cd000ef          	jal	ra,400037f4 <_dtoa_r>
40002e2c:	01012303          	lw	t1,16(sp)
40002e30:	00050913          	mv	s2,a0
40002e34:	000b0e13          	mv	t3,s6
40002e38:	04600793          	li	a5,70
40002e3c:	01c90c33          	add	s8,s2,t3
40002e40:	e6fa96e3          	bne	s5,a5,40002cac <_vfprintf_r+0x14b8>
40002e44:	00094703          	lbu	a4,0(s2)
40002e48:	03000793          	li	a5,48
40002e4c:	00f70e63          	beq	a4,a5,40002e68 <_vfprintf_r+0x1674>
40002e50:	08412783          	lw	a5,132(sp)
40002e54:	00fc0c33          	add	s8,s8,a5
40002e58:	e55ff06f          	j	40002cac <_vfprintf_r+0x14b8>
40002e5c:	dc0b14e3          	bnez	s6,40002c24 <_vfprintf_r+0x1430>
40002e60:	00100b13          	li	s6,1
40002e64:	dc1ff06f          	j	40002c24 <_vfprintf_r+0x1430>
40002e68:	03812703          	lw	a4,56(sp)
40002e6c:	000c8593          	mv	a1,s9
40002e70:	00000613          	li	a2,0
40002e74:	00070513          	mv	a0,a4
40002e78:	00000693          	li	a3,0
40002e7c:	02612423          	sw	t1,40(sp)
40002e80:	01c12823          	sw	t3,16(sp)
40002e84:	248080ef          	jal	ra,4000b0cc <__eqdf2>
40002e88:	02812303          	lw	t1,40(sp)
40002e8c:	fc0502e3          	beqz	a0,40002e50 <_vfprintf_r+0x165c>
40002e90:	01012e03          	lw	t3,16(sp)
40002e94:	00100793          	li	a5,1
40002e98:	41c787b3          	sub	a5,a5,t3
40002e9c:	08f12223          	sw	a5,132(sp)
40002ea0:	00fc0c33          	add	s8,s8,a5
40002ea4:	e09ff06f          	j	40002cac <_vfprintf_r+0x14b8>
40002ea8:	09c10613          	addi	a2,sp,156
40002eac:	00098593          	mv	a1,s3
40002eb0:	000a0513          	mv	a0,s4
40002eb4:	448040ef          	jal	ra,400072fc <__sprint_r>
40002eb8:	88051c63          	bnez	a0,40001f50 <_vfprintf_r+0x75c>
40002ebc:	0a412783          	lw	a5,164(sp)
40002ec0:	000d0313          	mv	t1,s10
40002ec4:	a61ff06f          	j	40002924 <_vfprintf_r+0x1130>
40002ec8:	00090513          	mv	a0,s2
40002ecc:	00612a23          	sw	t1,20(sp)
40002ed0:	2a4040ef          	jal	ra,40007174 <strlen>
40002ed4:	00a12823          	sw	a0,16(sp)
40002ed8:	00050c13          	mv	s8,a0
40002edc:	01412303          	lw	t1,20(sp)
40002ee0:	de055063          	bgez	a0,400024c0 <_vfprintf_r+0xccc>
40002ee4:	00012823          	sw	zero,16(sp)
40002ee8:	dd8ff06f          	j	400024c0 <_vfprintf_r+0xccc>
40002eec:	02d00793          	li	a5,45
40002ef0:	06f10fa3          	sb	a5,127(sp)
40002ef4:	02d00613          	li	a2,45
40002ef8:	00000b13          	li	s6,0
40002efc:	c0dfe06f          	j	40001b08 <_vfprintf_r+0x314>
40002f00:	08412783          	lw	a5,132(sp)
40002f04:	00078713          	mv	a4,a5
40002f08:	02f12823          	sw	a5,48(sp)
40002f0c:	ffd00793          	li	a5,-3
40002f10:	00f74463          	blt	a4,a5,40002f18 <_vfprintf_r+0x1724>
40002f14:	e0eb54e3          	ble	a4,s6,40002d1c <_vfprintf_r+0x1528>
40002f18:	ffea8a93          	addi	s5,s5,-2
40002f1c:	03012783          	lw	a5,48(sp)
40002f20:	09510623          	sb	s5,140(sp)
40002f24:	fff78b13          	addi	s6,a5,-1
40002f28:	09612223          	sw	s6,132(sp)
40002f2c:	3a0b4e63          	bltz	s6,400032e8 <_vfprintf_r+0x1af4>
40002f30:	02b00713          	li	a4,43
40002f34:	08e106a3          	sb	a4,141(sp)
40002f38:	00900793          	li	a5,9
40002f3c:	3167d663          	ble	s6,a5,40003248 <_vfprintf_r+0x1a54>
40002f40:	09b10c93          	addi	s9,sp,155
40002f44:	02812423          	sw	s0,40(sp)
40002f48:	000c8b93          	mv	s7,s9
40002f4c:	000b0413          	mv	s0,s6
40002f50:	00a00c13          	li	s8,10
40002f54:	00098b13          	mv	s6,s3
40002f58:	00f12823          	sw	a5,16(sp)
40002f5c:	00030993          	mv	s3,t1
40002f60:	0080006f          	j	40002f68 <_vfprintf_r+0x1774>
40002f64:	00068b93          	mv	s7,a3
40002f68:	000c0593          	mv	a1,s8
40002f6c:	00040513          	mv	a0,s0
40002f70:	7e9090ef          	jal	ra,4000cf58 <__modsi3>
40002f74:	03050513          	addi	a0,a0,48
40002f78:	feab8fa3          	sb	a0,-1(s7)
40002f7c:	000c0593          	mv	a1,s8
40002f80:	00040513          	mv	a0,s0
40002f84:	751090ef          	jal	ra,4000ced4 <__divsi3>
40002f88:	01012783          	lw	a5,16(sp)
40002f8c:	00050413          	mv	s0,a0
40002f90:	fffb8693          	addi	a3,s7,-1
40002f94:	fca7c8e3          	blt	a5,a0,40002f64 <_vfprintf_r+0x1770>
40002f98:	03050793          	addi	a5,a0,48
40002f9c:	0ff7f793          	andi	a5,a5,255
40002fa0:	ffeb8b93          	addi	s7,s7,-2
40002fa4:	fef68fa3          	sb	a5,-1(a3)
40002fa8:	00098313          	mv	t1,s3
40002fac:	02812403          	lw	s0,40(sp)
40002fb0:	000b0993          	mv	s3,s6
40002fb4:	399bfe63          	bleu	s9,s7,40003350 <_vfprintf_r+0x1b5c>
40002fb8:	08e10713          	addi	a4,sp,142
40002fbc:	0080006f          	j	40002fc4 <_vfprintf_r+0x17d0>
40002fc0:	000bc783          	lbu	a5,0(s7)
40002fc4:	00170713          	addi	a4,a4,1
40002fc8:	001b8b93          	addi	s7,s7,1
40002fcc:	fef70fa3          	sb	a5,-1(a4)
40002fd0:	ff9b98e3          	bne	s7,s9,40002fc0 <_vfprintf_r+0x17cc>
40002fd4:	09c10793          	addi	a5,sp,156
40002fd8:	40d787b3          	sub	a5,a5,a3
40002fdc:	08e10713          	addi	a4,sp,142
40002fe0:	00f707b3          	add	a5,a4,a5
40002fe4:	08c10713          	addi	a4,sp,140
40002fe8:	03412683          	lw	a3,52(sp)
40002fec:	40e787b3          	sub	a5,a5,a4
40002ff0:	00078713          	mv	a4,a5
40002ff4:	04f12623          	sw	a5,76(sp)
40002ff8:	00100793          	li	a5,1
40002ffc:	00e68c33          	add	s8,a3,a4
40003000:	2cd7d663          	ble	a3,a5,400032cc <_vfprintf_r+0x1ad8>
40003004:	04012783          	lw	a5,64(sp)
40003008:	00fc0c33          	add	s8,s8,a5
4000300c:	01812823          	sw	s8,16(sp)
40003010:	000c4663          	bltz	s8,4000301c <_vfprintf_r+0x1828>
40003014:	02012823          	sw	zero,48(sp)
40003018:	d29ff06f          	j	40002d40 <_vfprintf_r+0x154c>
4000301c:	00012823          	sw	zero,16(sp)
40003020:	02012823          	sw	zero,48(sp)
40003024:	d1dff06f          	j	40002d40 <_vfprintf_r+0x154c>
40003028:	00000a93          	li	s5,0
4000302c:	b38ff06f          	j	40002364 <_vfprintf_r+0xb70>
40003030:	01612823          	sw	s6,16(sp)
40003034:	00600793          	li	a5,6
40003038:	0167f463          	bleu	s6,a5,40003040 <_vfprintf_r+0x184c>
4000303c:	00f12823          	sw	a5,16(sp)
40003040:	4000d937          	lui	s2,0x4000d
40003044:	03712023          	sw	s7,32(sp)
40003048:	01012c03          	lw	s8,16(sp)
4000304c:	01b12a23          	sw	s11,20(sp)
40003050:	00000613          	li	a2,0
40003054:	00000b13          	li	s6,0
40003058:	02012823          	sw	zero,48(sp)
4000305c:	75c90913          	addi	s2,s2,1884 # 4000d75c <zeroes.4139+0x48>
40003060:	ab5fe06f          	j	40001b14 <_vfprintf_r+0x320>
40003064:	00000a93          	li	s5,0
40003068:	a19ff06f          	j	40002a80 <_vfprintf_r+0x128c>
4000306c:	00600b13          	li	s6,6
40003070:	bb5ff06f          	j	40002c24 <_vfprintf_r+0x1430>
40003074:	02d00793          	li	a5,45
40003078:	06f10fa3          	sb	a5,127(sp)
4000307c:	02d00613          	li	a2,45
40003080:	d60ff06f          	j	400025e0 <_vfprintf_r+0xdec>
40003084:	03812703          	lw	a4,56(sp)
40003088:	09410793          	addi	a5,sp,148
4000308c:	00f12023          	sw	a5,0(sp)
40003090:	00070613          	mv	a2,a4
40003094:	000c8693          	mv	a3,s9
40003098:	08810893          	addi	a7,sp,136
4000309c:	08410813          	addi	a6,sp,132
400030a0:	000b0793          	mv	a5,s6
400030a4:	00300713          	li	a4,3
400030a8:	000a0513          	mv	a0,s4
400030ac:	00612823          	sw	t1,16(sp)
400030b0:	744000ef          	jal	ra,400037f4 <_dtoa_r>
400030b4:	00050913          	mv	s2,a0
400030b8:	01650c33          	add	s8,a0,s6
400030bc:	000b0e13          	mv	t3,s6
400030c0:	01012303          	lw	t1,16(sp)
400030c4:	d81ff06f          	j	40002e44 <_vfprintf_r+0x1650>
400030c8:	80000cb7          	lui	s9,0x80000
400030cc:	0197ccb3          	xor	s9,a5,s9
400030d0:	02d00793          	li	a5,45
400030d4:	00f12c23          	sw	a5,24(sp)
400030d8:	b65ff06f          	j	40002c3c <_vfprintf_r+0x1448>
400030dc:	03412783          	lw	a5,52(sp)
400030e0:	04012703          	lw	a4,64(sp)
400030e4:	00e78c33          	add	s8,a5,a4
400030e8:	03012783          	lw	a5,48(sp)
400030ec:	1cf05863          	blez	a5,400032bc <_vfprintf_r+0x1ac8>
400030f0:	01812823          	sw	s8,16(sp)
400030f4:	020c4063          	bltz	s8,40003114 <_vfprintf_r+0x1920>
400030f8:	06700a93          	li	s5,103
400030fc:	c45ff06f          	j	40002d40 <_vfprintf_r+0x154c>
40003100:	03012783          	lw	a5,48(sp)
40003104:	04012703          	lw	a4,64(sp)
40003108:	00e78c33          	add	s8,a5,a4
4000310c:	01812823          	sw	s8,16(sp)
40003110:	fe0c54e3          	bgez	s8,400030f8 <_vfprintf_r+0x1904>
40003114:	00012823          	sw	zero,16(sp)
40003118:	06700a93          	li	s5,103
4000311c:	c25ff06f          	j	40002d40 <_vfprintf_r+0x154c>
40003120:	08412783          	lw	a5,132(sp)
40003124:	02f12823          	sw	a5,48(sp)
40003128:	1ef05863          	blez	a5,40003318 <_vfprintf_r+0x1b24>
4000312c:	120b1e63          	bnez	s6,40003268 <_vfprintf_r+0x1a74>
40003130:	001dfe93          	andi	t4,s11,1
40003134:	120e9a63          	bnez	t4,40003268 <_vfprintf_r+0x1a74>
40003138:	00f12823          	sw	a5,16(sp)
4000313c:	00078c13          	mv	s8,a5
40003140:	c01ff06f          	j	40002d40 <_vfprintf_r+0x154c>
40003144:	04700793          	li	a5,71
40003148:	01c50c33          	add	s8,a0,t3
4000314c:	b6fa90e3          	bne	s5,a5,40002cac <_vfprintf_r+0x14b8>
40003150:	001df793          	andi	a5,s11,1
40003154:	ce0792e3          	bnez	a5,40002e38 <_vfprintf_r+0x1644>
40003158:	09412783          	lw	a5,148(sp)
4000315c:	412787b3          	sub	a5,a5,s2
40003160:	02f12a23          	sw	a5,52(sp)
40003164:	d95b8ee3          	beq	s7,s5,40002f00 <_vfprintf_r+0x170c>
40003168:	08412783          	lw	a5,132(sp)
4000316c:	02f12823          	sw	a5,48(sp)
40003170:	dadff06f          	j	40002f1c <_vfprintf_r+0x1728>
40003174:	01612823          	sw	s6,16(sp)
40003178:	000b0c13          	mv	s8,s6
4000317c:	b44ff06f          	j	400024c0 <_vfprintf_r+0xccc>
40003180:	ff000613          	li	a2,-16
40003184:	40d00ab3          	neg	s5,a3
40003188:	06c6d463          	ble	a2,a3,400031f0 <_vfprintf_r+0x19fc>
4000318c:	4000d6b7          	lui	a3,0x4000d
40003190:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
40003194:	01000c13          	li	s8,16
40003198:	00700c93          	li	s9,7
4000319c:	00c0006f          	j	400031a8 <_vfprintf_r+0x19b4>
400031a0:	ff0a8a93          	addi	s5,s5,-16
400031a4:	055c5a63          	ble	s5,s8,400031f8 <_vfprintf_r+0x1a04>
400031a8:	01078793          	addi	a5,a5,16
400031ac:	00170713          	addi	a4,a4,1
400031b0:	01732023          	sw	s7,0(t1)
400031b4:	01832223          	sw	s8,4(t1)
400031b8:	0af12223          	sw	a5,164(sp)
400031bc:	0ae12023          	sw	a4,160(sp)
400031c0:	00830313          	addi	t1,t1,8
400031c4:	fcecdee3          	ble	a4,s9,400031a0 <_vfprintf_r+0x19ac>
400031c8:	09c10613          	addi	a2,sp,156
400031cc:	00098593          	mv	a1,s3
400031d0:	000a0513          	mv	a0,s4
400031d4:	128040ef          	jal	ra,400072fc <__sprint_r>
400031d8:	00050463          	beqz	a0,400031e0 <_vfprintf_r+0x19ec>
400031dc:	d75fe06f          	j	40001f50 <_vfprintf_r+0x75c>
400031e0:	0a412783          	lw	a5,164(sp)
400031e4:	0a012703          	lw	a4,160(sp)
400031e8:	000d0313          	mv	t1,s10
400031ec:	fb5ff06f          	j	400031a0 <_vfprintf_r+0x19ac>
400031f0:	4000d6b7          	lui	a3,0x4000d
400031f4:	71468b93          	addi	s7,a3,1812 # 4000d714 <zeroes.4139>
400031f8:	015787b3          	add	a5,a5,s5
400031fc:	00170713          	addi	a4,a4,1
40003200:	01732023          	sw	s7,0(t1)
40003204:	01532223          	sw	s5,4(t1)
40003208:	0af12223          	sw	a5,164(sp)
4000320c:	0ae12023          	sw	a4,160(sp)
40003210:	00700693          	li	a3,7
40003214:	00830313          	addi	t1,t1,8
40003218:	00e6c463          	blt	a3,a4,40003220 <_vfprintf_r+0x1a2c>
4000321c:	cd9fe06f          	j	40001ef4 <_vfprintf_r+0x700>
40003220:	09c10613          	addi	a2,sp,156
40003224:	00098593          	mv	a1,s3
40003228:	000a0513          	mv	a0,s4
4000322c:	0d0040ef          	jal	ra,400072fc <__sprint_r>
40003230:	00050463          	beqz	a0,40003238 <_vfprintf_r+0x1a44>
40003234:	d1dfe06f          	j	40001f50 <_vfprintf_r+0x75c>
40003238:	0a412783          	lw	a5,164(sp)
4000323c:	0a012703          	lw	a4,160(sp)
40003240:	000d0313          	mv	t1,s10
40003244:	cb1fe06f          	j	40001ef4 <_vfprintf_r+0x700>
40003248:	030b0793          	addi	a5,s6,48
4000324c:	03000713          	li	a4,48
40003250:	08f107a3          	sb	a5,143(sp)
40003254:	08e10723          	sb	a4,142(sp)
40003258:	09010793          	addi	a5,sp,144
4000325c:	d89ff06f          	j	40002fe4 <_vfprintf_r+0x17f0>
40003260:	09412783          	lw	a5,148(sp)
40003264:	a91ff06f          	j	40002cf4 <_vfprintf_r+0x1500>
40003268:	03012783          	lw	a5,48(sp)
4000326c:	04012703          	lw	a4,64(sp)
40003270:	00e78c33          	add	s8,a5,a4
40003274:	016c0c33          	add	s8,s8,s6
40003278:	01812823          	sw	s8,16(sp)
4000327c:	ac0c52e3          	bgez	s8,40002d40 <_vfprintf_r+0x154c>
40003280:	00012823          	sw	zero,16(sp)
40003284:	abdff06f          	j	40002d40 <_vfprintf_r+0x154c>
40003288:	04700793          	li	a5,71
4000328c:	0557c863          	blt	a5,s5,400032dc <_vfprintf_r+0x1ae8>
40003290:	4000d937          	lui	s2,0x4000d
40003294:	72c90913          	addi	s2,s2,1836 # 4000d72c <zeroes.4139+0x18>
40003298:	00300793          	li	a5,3
4000329c:	f7fdf713          	andi	a4,s11,-129
400032a0:	00f12823          	sw	a5,16(sp)
400032a4:	00e12a23          	sw	a4,20(sp)
400032a8:	07f14603          	lbu	a2,127(sp)
400032ac:	00078c13          	mv	s8,a5
400032b0:	00000b13          	li	s6,0
400032b4:	02012823          	sw	zero,48(sp)
400032b8:	84dfe06f          	j	40001b04 <_vfprintf_r+0x310>
400032bc:	03012783          	lw	a5,48(sp)
400032c0:	40fc0c33          	sub	s8,s8,a5
400032c4:	001c0c13          	addi	s8,s8,1
400032c8:	e29ff06f          	j	400030f0 <_vfprintf_r+0x18fc>
400032cc:	00fdf7b3          	and	a5,s11,a5
400032d0:	02f12823          	sw	a5,48(sp)
400032d4:	fa0782e3          	beqz	a5,40003278 <_vfprintf_r+0x1a84>
400032d8:	d2dff06f          	j	40003004 <_vfprintf_r+0x1810>
400032dc:	4000d937          	lui	s2,0x4000d
400032e0:	73090913          	addi	s2,s2,1840 # 4000d730 <zeroes.4139+0x1c>
400032e4:	fb5ff06f          	j	40003298 <_vfprintf_r+0x1aa4>
400032e8:	03012703          	lw	a4,48(sp)
400032ec:	00100793          	li	a5,1
400032f0:	40e78b33          	sub	s6,a5,a4
400032f4:	02d00713          	li	a4,45
400032f8:	08e106a3          	sb	a4,141(sp)
400032fc:	c3dff06f          	j	40002f38 <_vfprintf_r+0x1744>
40003300:	02012783          	lw	a5,32(sp)
40003304:	0007ab03          	lw	s6,0(a5)
40003308:	00478793          	addi	a5,a5,4
4000330c:	060b4a63          	bltz	s6,40003380 <_vfprintf_r+0x1b8c>
40003310:	02f12023          	sw	a5,32(sp)
40003314:	ea4fe06f          	j	400019b8 <_vfprintf_r+0x1c4>
40003318:	000b1c63          	bnez	s6,40003330 <_vfprintf_r+0x1b3c>
4000331c:	00100793          	li	a5,1
40003320:	00f12823          	sw	a5,16(sp)
40003324:	00fdfeb3          	and	t4,s11,a5
40003328:	00078c13          	mv	s8,a5
4000332c:	a00e8ae3          	beqz	t4,40002d40 <_vfprintf_r+0x154c>
40003330:	04012783          	lw	a5,64(sp)
40003334:	00178c13          	addi	s8,a5,1
40003338:	016c0c33          	add	s8,s8,s6
4000333c:	f3dff06f          	j	40003278 <_vfprintf_r+0x1a84>
40003340:	00012823          	sw	zero,16(sp)
40003344:	9f5ff06f          	j	40002d38 <_vfprintf_r+0x1544>
40003348:	06b10fa3          	sb	a1,127(sp)
4000334c:	9c8ff06f          	j	40002514 <_vfprintf_r+0xd20>
40003350:	08e10793          	addi	a5,sp,142
40003354:	c91ff06f          	j	40002fe4 <_vfprintf_r+0x17f0>
40003358:	06b10fa3          	sb	a1,127(sp)
4000335c:	8f4ff06f          	j	40002450 <_vfprintf_r+0xc5c>
40003360:	06b10fa3          	sb	a1,127(sp)
40003364:	978ff06f          	j	400024dc <_vfprintf_r+0xce8>
40003368:	06b10fa3          	sb	a1,127(sp)
4000336c:	c5cff06f          	j	400027c8 <_vfprintf_r+0xfd4>
40003370:	06b10fa3          	sb	a1,127(sp)
40003374:	c10ff06f          	j	40002784 <_vfprintf_r+0xf90>
40003378:	06b10fa3          	sb	a1,127(sp)
4000337c:	ae4ff06f          	j	40002660 <_vfprintf_r+0xe6c>
40003380:	000f8b13          	mv	s6,t6
40003384:	02f12023          	sw	a5,32(sp)
40003388:	e30fe06f          	j	400019b8 <_vfprintf_r+0x1c4>

4000338c <vfprintf>:
4000338c:	4000e7b7          	lui	a5,0x4000e
40003390:	00060693          	mv	a3,a2
40003394:	00058613          	mv	a2,a1
40003398:	00050593          	mv	a1,a0
4000339c:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
400033a0:	c54fe06f          	j	400017f4 <_vfprintf_r>

400033a4 <__sbprintf>:
400033a4:	00c5d783          	lhu	a5,12(a1)
400033a8:	0645ae03          	lw	t3,100(a1)
400033ac:	00e5d303          	lhu	t1,14(a1)
400033b0:	01c5a883          	lw	a7,28(a1)
400033b4:	0245a803          	lw	a6,36(a1)
400033b8:	b8010113          	addi	sp,sp,-1152
400033bc:	ffd7f793          	andi	a5,a5,-3
400033c0:	40000713          	li	a4,1024
400033c4:	46812c23          	sw	s0,1144(sp)
400033c8:	00f11a23          	sh	a5,20(sp)
400033cc:	00058413          	mv	s0,a1
400033d0:	07010793          	addi	a5,sp,112
400033d4:	00810593          	addi	a1,sp,8
400033d8:	46912a23          	sw	s1,1140(sp)
400033dc:	47212823          	sw	s2,1136(sp)
400033e0:	46112e23          	sw	ra,1148(sp)
400033e4:	00050913          	mv	s2,a0
400033e8:	07c12623          	sw	t3,108(sp)
400033ec:	00611b23          	sh	t1,22(sp)
400033f0:	03112223          	sw	a7,36(sp)
400033f4:	03012623          	sw	a6,44(sp)
400033f8:	00f12423          	sw	a5,8(sp)
400033fc:	00f12c23          	sw	a5,24(sp)
40003400:	00e12823          	sw	a4,16(sp)
40003404:	00e12e23          	sw	a4,28(sp)
40003408:	02012023          	sw	zero,32(sp)
4000340c:	be8fe0ef          	jal	ra,400017f4 <_vfprintf_r>
40003410:	00050493          	mv	s1,a0
40003414:	00054a63          	bltz	a0,40003428 <__sbprintf+0x84>
40003418:	00810593          	addi	a1,sp,8
4000341c:	00090513          	mv	a0,s2
40003420:	3d1010ef          	jal	ra,40004ff0 <_fflush_r>
40003424:	02051c63          	bnez	a0,4000345c <__sbprintf+0xb8>
40003428:	01415783          	lhu	a5,20(sp)
4000342c:	0407f793          	andi	a5,a5,64
40003430:	00078863          	beqz	a5,40003440 <__sbprintf+0x9c>
40003434:	00c45783          	lhu	a5,12(s0)
40003438:	0407e793          	ori	a5,a5,64
4000343c:	00f41623          	sh	a5,12(s0)
40003440:	47c12083          	lw	ra,1148(sp)
40003444:	00048513          	mv	a0,s1
40003448:	47812403          	lw	s0,1144(sp)
4000344c:	47412483          	lw	s1,1140(sp)
40003450:	47012903          	lw	s2,1136(sp)
40003454:	48010113          	addi	sp,sp,1152
40003458:	00008067          	ret
4000345c:	fff00493          	li	s1,-1
40003460:	fc9ff06f          	j	40003428 <__sbprintf+0x84>

40003464 <__swsetup_r>:
40003464:	4000e7b7          	lui	a5,0x4000e
40003468:	5847a783          	lw	a5,1412(a5) # 4000e584 <_impure_ptr>
4000346c:	ff010113          	addi	sp,sp,-16
40003470:	00812423          	sw	s0,8(sp)
40003474:	00912223          	sw	s1,4(sp)
40003478:	00112623          	sw	ra,12(sp)
4000347c:	00050493          	mv	s1,a0
40003480:	00058413          	mv	s0,a1
40003484:	00078663          	beqz	a5,40003490 <__swsetup_r+0x2c>
40003488:	0387a703          	lw	a4,56(a5)
4000348c:	0c070c63          	beqz	a4,40003564 <__swsetup_r+0x100>
40003490:	00c41703          	lh	a4,12(s0)
40003494:	01071793          	slli	a5,a4,0x10
40003498:	0107d793          	srli	a5,a5,0x10
4000349c:	0087f693          	andi	a3,a5,8
400034a0:	04068063          	beqz	a3,400034e0 <__swsetup_r+0x7c>
400034a4:	01042683          	lw	a3,16(s0)
400034a8:	06068063          	beqz	a3,40003508 <__swsetup_r+0xa4>
400034ac:	0017f713          	andi	a4,a5,1
400034b0:	06070e63          	beqz	a4,4000352c <__swsetup_r+0xc8>
400034b4:	01442783          	lw	a5,20(s0)
400034b8:	00042423          	sw	zero,8(s0)
400034bc:	00000513          	li	a0,0
400034c0:	40f007b3          	neg	a5,a5
400034c4:	00f42c23          	sw	a5,24(s0)
400034c8:	08068063          	beqz	a3,40003548 <__swsetup_r+0xe4>
400034cc:	00c12083          	lw	ra,12(sp)
400034d0:	00812403          	lw	s0,8(sp)
400034d4:	00412483          	lw	s1,4(sp)
400034d8:	01010113          	addi	sp,sp,16
400034dc:	00008067          	ret
400034e0:	0107f693          	andi	a3,a5,16
400034e4:	0c068063          	beqz	a3,400035a4 <__swsetup_r+0x140>
400034e8:	0047f793          	andi	a5,a5,4
400034ec:	08079263          	bnez	a5,40003570 <__swsetup_r+0x10c>
400034f0:	01042683          	lw	a3,16(s0)
400034f4:	00876793          	ori	a5,a4,8
400034f8:	00f41623          	sh	a5,12(s0)
400034fc:	01079793          	slli	a5,a5,0x10
40003500:	0107d793          	srli	a5,a5,0x10
40003504:	fa0694e3          	bnez	a3,400034ac <__swsetup_r+0x48>
40003508:	2807f713          	andi	a4,a5,640
4000350c:	20000613          	li	a2,512
40003510:	f8c70ee3          	beq	a4,a2,400034ac <__swsetup_r+0x48>
40003514:	00040593          	mv	a1,s0
40003518:	00048513          	mv	a0,s1
4000351c:	634020ef          	jal	ra,40005b50 <__smakebuf_r>
40003520:	00c45783          	lhu	a5,12(s0)
40003524:	01042683          	lw	a3,16(s0)
40003528:	f85ff06f          	j	400034ac <__swsetup_r+0x48>
4000352c:	0027f793          	andi	a5,a5,2
40003530:	00000713          	li	a4,0
40003534:	00079463          	bnez	a5,4000353c <__swsetup_r+0xd8>
40003538:	01442703          	lw	a4,20(s0)
4000353c:	00e42423          	sw	a4,8(s0)
40003540:	00000513          	li	a0,0
40003544:	f80694e3          	bnez	a3,400034cc <__swsetup_r+0x68>
40003548:	00c41783          	lh	a5,12(s0)
4000354c:	0807f713          	andi	a4,a5,128
40003550:	f6070ee3          	beqz	a4,400034cc <__swsetup_r+0x68>
40003554:	0407e793          	ori	a5,a5,64
40003558:	00f41623          	sh	a5,12(s0)
4000355c:	fff00513          	li	a0,-1
40003560:	f6dff06f          	j	400034cc <__swsetup_r+0x68>
40003564:	00078513          	mv	a0,a5
40003568:	659010ef          	jal	ra,400053c0 <__sinit>
4000356c:	f25ff06f          	j	40003490 <__swsetup_r+0x2c>
40003570:	03042583          	lw	a1,48(s0)
40003574:	00058e63          	beqz	a1,40003590 <__swsetup_r+0x12c>
40003578:	04040793          	addi	a5,s0,64
4000357c:	00f58863          	beq	a1,a5,4000358c <__swsetup_r+0x128>
40003580:	00048513          	mv	a0,s1
40003584:	7c1010ef          	jal	ra,40005544 <_free_r>
40003588:	00c41703          	lh	a4,12(s0)
4000358c:	02042823          	sw	zero,48(s0)
40003590:	01042683          	lw	a3,16(s0)
40003594:	fdb77713          	andi	a4,a4,-37
40003598:	00042223          	sw	zero,4(s0)
4000359c:	00d42023          	sw	a3,0(s0)
400035a0:	f55ff06f          	j	400034f4 <__swsetup_r+0x90>
400035a4:	00900793          	li	a5,9
400035a8:	00f4a023          	sw	a5,0(s1)
400035ac:	04076713          	ori	a4,a4,64
400035b0:	00e41623          	sh	a4,12(s0)
400035b4:	fff00513          	li	a0,-1
400035b8:	f15ff06f          	j	400034cc <__swsetup_r+0x68>

400035bc <quorem>:
400035bc:	fb010113          	addi	sp,sp,-80
400035c0:	03712623          	sw	s7,44(sp)
400035c4:	01052783          	lw	a5,16(a0)
400035c8:	0105ab83          	lw	s7,16(a1)
400035cc:	04112623          	sw	ra,76(sp)
400035d0:	04812423          	sw	s0,72(sp)
400035d4:	04912223          	sw	s1,68(sp)
400035d8:	05212023          	sw	s2,64(sp)
400035dc:	03312e23          	sw	s3,60(sp)
400035e0:	03412c23          	sw	s4,56(sp)
400035e4:	03512a23          	sw	s5,52(sp)
400035e8:	03612823          	sw	s6,48(sp)
400035ec:	03812423          	sw	s8,40(sp)
400035f0:	03912223          	sw	s9,36(sp)
400035f4:	03a12023          	sw	s10,32(sp)
400035f8:	01b12e23          	sw	s11,28(sp)
400035fc:	1f77c863          	blt	a5,s7,400037ec <quorem+0x230>
40003600:	fffb8b93          	addi	s7,s7,-1
40003604:	002b9a93          	slli	s5,s7,0x2
40003608:	01458b13          	addi	s6,a1,20
4000360c:	01450493          	addi	s1,a0,20
40003610:	015b0c33          	add	s8,s6,s5
40003614:	015487b3          	add	a5,s1,s5
40003618:	00b12423          	sw	a1,8(sp)
4000361c:	000c2583          	lw	a1,0(s8)
40003620:	00050913          	mv	s2,a0
40003624:	0007a503          	lw	a0,0(a5)
40003628:	00158593          	addi	a1,a1,1
4000362c:	00f12623          	sw	a5,12(sp)
40003630:	0ad090ef          	jal	ra,4000cedc <__udivsi3>
40003634:	00050413          	mv	s0,a0
40003638:	0c050463          	beqz	a0,40003700 <quorem+0x144>
4000363c:	00010d37          	lui	s10,0x10
40003640:	000b0a13          	mv	s4,s6
40003644:	00048d93          	mv	s11,s1
40003648:	00000c93          	li	s9,0
4000364c:	00000993          	li	s3,0
40003650:	fffd0d13          	addi	s10,s10,-1 # ffff <_heap_size+0xdfff>
40003654:	004a0a13          	addi	s4,s4,4
40003658:	ffca2a83          	lw	s5,-4(s4)
4000365c:	00040593          	mv	a1,s0
40003660:	004d8d93          	addi	s11,s11,4
40003664:	01aaf533          	and	a0,s5,s10
40003668:	049090ef          	jal	ra,4000ceb0 <__mulsi3>
4000366c:	01950cb3          	add	s9,a0,s9
40003670:	00040593          	mv	a1,s0
40003674:	010ad513          	srli	a0,s5,0x10
40003678:	039090ef          	jal	ra,4000ceb0 <__mulsi3>
4000367c:	ffcda783          	lw	a5,-4(s11)
40003680:	010cd693          	srli	a3,s9,0x10
40003684:	01acf733          	and	a4,s9,s10
40003688:	40e98733          	sub	a4,s3,a4
4000368c:	00d50cb3          	add	s9,a0,a3
40003690:	01a7f6b3          	and	a3,a5,s10
40003694:	00d70733          	add	a4,a4,a3
40003698:	0107d793          	srli	a5,a5,0x10
4000369c:	01acf6b3          	and	a3,s9,s10
400036a0:	40d787b3          	sub	a5,a5,a3
400036a4:	41075693          	srai	a3,a4,0x10
400036a8:	00d787b3          	add	a5,a5,a3
400036ac:	01079693          	slli	a3,a5,0x10
400036b0:	01a77733          	and	a4,a4,s10
400036b4:	00e6e733          	or	a4,a3,a4
400036b8:	feedae23          	sw	a4,-4(s11)
400036bc:	010cdc93          	srli	s9,s9,0x10
400036c0:	4107d993          	srai	s3,a5,0x10
400036c4:	f94c78e3          	bleu	s4,s8,40003654 <quorem+0x98>
400036c8:	00c12703          	lw	a4,12(sp)
400036cc:	00072783          	lw	a5,0(a4)
400036d0:	02079863          	bnez	a5,40003700 <quorem+0x144>
400036d4:	ffc70793          	addi	a5,a4,-4
400036d8:	02f4f263          	bleu	a5,s1,400036fc <quorem+0x140>
400036dc:	ffc72703          	lw	a4,-4(a4)
400036e0:	00070863          	beqz	a4,400036f0 <quorem+0x134>
400036e4:	0180006f          	j	400036fc <quorem+0x140>
400036e8:	0007a703          	lw	a4,0(a5)
400036ec:	00071863          	bnez	a4,400036fc <quorem+0x140>
400036f0:	ffc78793          	addi	a5,a5,-4
400036f4:	fffb8b93          	addi	s7,s7,-1
400036f8:	fef4e8e3          	bltu	s1,a5,400036e8 <quorem+0x12c>
400036fc:	01792823          	sw	s7,16(s2)
40003700:	00812583          	lw	a1,8(sp)
40003704:	00090513          	mv	a0,s2
40003708:	068030ef          	jal	ra,40006770 <__mcmp>
4000370c:	0a054063          	bltz	a0,400037ac <quorem+0x1f0>
40003710:	00010537          	lui	a0,0x10
40003714:	00140413          	addi	s0,s0,1
40003718:	00048593          	mv	a1,s1
4000371c:	00000793          	li	a5,0
40003720:	fff50513          	addi	a0,a0,-1 # ffff <_heap_size+0xdfff>
40003724:	004b0b13          	addi	s6,s6,4
40003728:	ffcb2603          	lw	a2,-4(s6)
4000372c:	0005a703          	lw	a4,0(a1)
40003730:	00458593          	addi	a1,a1,4
40003734:	00a676b3          	and	a3,a2,a0
40003738:	40d787b3          	sub	a5,a5,a3
4000373c:	00a776b3          	and	a3,a4,a0
40003740:	00d786b3          	add	a3,a5,a3
40003744:	01065613          	srli	a2,a2,0x10
40003748:	01075793          	srli	a5,a4,0x10
4000374c:	40c787b3          	sub	a5,a5,a2
40003750:	4106d713          	srai	a4,a3,0x10
40003754:	00e787b3          	add	a5,a5,a4
40003758:	01079713          	slli	a4,a5,0x10
4000375c:	00a6f6b3          	and	a3,a3,a0
40003760:	00d766b3          	or	a3,a4,a3
40003764:	fed5ae23          	sw	a3,-4(a1)
40003768:	4107d793          	srai	a5,a5,0x10
4000376c:	fb6c7ce3          	bleu	s6,s8,40003724 <quorem+0x168>
40003770:	002b9713          	slli	a4,s7,0x2
40003774:	00e48733          	add	a4,s1,a4
40003778:	00072783          	lw	a5,0(a4)
4000377c:	02079863          	bnez	a5,400037ac <quorem+0x1f0>
40003780:	ffc70793          	addi	a5,a4,-4
40003784:	02f4f263          	bleu	a5,s1,400037a8 <quorem+0x1ec>
40003788:	ffc72703          	lw	a4,-4(a4)
4000378c:	00070863          	beqz	a4,4000379c <quorem+0x1e0>
40003790:	0180006f          	j	400037a8 <quorem+0x1ec>
40003794:	0007a703          	lw	a4,0(a5)
40003798:	00071863          	bnez	a4,400037a8 <quorem+0x1ec>
4000379c:	ffc78793          	addi	a5,a5,-4
400037a0:	fffb8b93          	addi	s7,s7,-1
400037a4:	fef4e8e3          	bltu	s1,a5,40003794 <quorem+0x1d8>
400037a8:	01792823          	sw	s7,16(s2)
400037ac:	00040513          	mv	a0,s0
400037b0:	04c12083          	lw	ra,76(sp)
400037b4:	04812403          	lw	s0,72(sp)
400037b8:	04412483          	lw	s1,68(sp)
400037bc:	04012903          	lw	s2,64(sp)
400037c0:	03c12983          	lw	s3,60(sp)
400037c4:	03812a03          	lw	s4,56(sp)
400037c8:	03412a83          	lw	s5,52(sp)
400037cc:	03012b03          	lw	s6,48(sp)
400037d0:	02c12b83          	lw	s7,44(sp)
400037d4:	02812c03          	lw	s8,40(sp)
400037d8:	02412c83          	lw	s9,36(sp)
400037dc:	02012d03          	lw	s10,32(sp)
400037e0:	01c12d83          	lw	s11,28(sp)
400037e4:	05010113          	addi	sp,sp,80
400037e8:	00008067          	ret
400037ec:	00000513          	li	a0,0
400037f0:	fc1ff06f          	j	400037b0 <quorem+0x1f4>

400037f4 <_dtoa_r>:
400037f4:	04052303          	lw	t1,64(a0)
400037f8:	f4010113          	addi	sp,sp,-192
400037fc:	0a812c23          	sw	s0,184(sp)
40003800:	0a912a23          	sw	s1,180(sp)
40003804:	0b212823          	sw	s2,176(sp)
40003808:	0b312623          	sw	s3,172(sp)
4000380c:	0b412423          	sw	s4,168(sp)
40003810:	0b612023          	sw	s6,160(sp)
40003814:	09912a23          	sw	s9,148(sp)
40003818:	09b12623          	sw	s11,140(sp)
4000381c:	0a112e23          	sw	ra,188(sp)
40003820:	0b512223          	sw	s5,164(sp)
40003824:	09712e23          	sw	s7,156(sp)
40003828:	09812c23          	sw	s8,152(sp)
4000382c:	09a12823          	sw	s10,144(sp)
40003830:	01012623          	sw	a6,12(sp)
40003834:	00050d93          	mv	s11,a0
40003838:	00060493          	mv	s1,a2
4000383c:	00068913          	mv	s2,a3
40003840:	00070c93          	mv	s9,a4
40003844:	00078b13          	mv	s6,a5
40003848:	00088993          	mv	s3,a7
4000384c:	00060a13          	mv	s4,a2
40003850:	00068413          	mv	s0,a3
40003854:	02030263          	beqz	t1,40003878 <_dtoa_r+0x84>
40003858:	04452703          	lw	a4,68(a0)
4000385c:	00100793          	li	a5,1
40003860:	00030593          	mv	a1,t1
40003864:	00e797b3          	sll	a5,a5,a4
40003868:	00e32223          	sw	a4,4(t1)
4000386c:	00f32423          	sw	a5,8(t1)
40003870:	644020ef          	jal	ra,40005eb4 <_Bfree>
40003874:	040da023          	sw	zero,64(s11)
40003878:	00090a93          	mv	s5,s2
4000387c:	0e044863          	bltz	s0,4000396c <_dtoa_r+0x178>
40003880:	0009a023          	sw	zero,0(s3)
40003884:	7ff007b7          	lui	a5,0x7ff00
40003888:	00faf733          	and	a4,s5,a5
4000388c:	08f70263          	beq	a4,a5,40003910 <_dtoa_r+0x11c>
40003890:	00048513          	mv	a0,s1
40003894:	00040593          	mv	a1,s0
40003898:	00000613          	li	a2,0
4000389c:	00000693          	li	a3,0
400038a0:	02d070ef          	jal	ra,4000b0cc <__eqdf2>
400038a4:	0e051263          	bnez	a0,40003988 <_dtoa_r+0x194>
400038a8:	00c12703          	lw	a4,12(sp)
400038ac:	00100793          	li	a5,1
400038b0:	00f72023          	sw	a5,0(a4)
400038b4:	0c012783          	lw	a5,192(sp)
400038b8:	6a078263          	beqz	a5,40003f5c <_dtoa_r+0x768>
400038bc:	0c012703          	lw	a4,192(sp)
400038c0:	4000d7b7          	lui	a5,0x4000d
400038c4:	76578793          	addi	a5,a5,1893 # 4000d765 <zeroes.4139+0x51>
400038c8:	4000d537          	lui	a0,0x4000d
400038cc:	00f72023          	sw	a5,0(a4)
400038d0:	76450513          	addi	a0,a0,1892 # 4000d764 <zeroes.4139+0x50>
400038d4:	0bc12083          	lw	ra,188(sp)
400038d8:	0b812403          	lw	s0,184(sp)
400038dc:	0b412483          	lw	s1,180(sp)
400038e0:	0b012903          	lw	s2,176(sp)
400038e4:	0ac12983          	lw	s3,172(sp)
400038e8:	0a812a03          	lw	s4,168(sp)
400038ec:	0a412a83          	lw	s5,164(sp)
400038f0:	0a012b03          	lw	s6,160(sp)
400038f4:	09c12b83          	lw	s7,156(sp)
400038f8:	09812c03          	lw	s8,152(sp)
400038fc:	09412c83          	lw	s9,148(sp)
40003900:	09012d03          	lw	s10,144(sp)
40003904:	08c12d83          	lw	s11,140(sp)
40003908:	0c010113          	addi	sp,sp,192
4000390c:	00008067          	ret
40003910:	00c12703          	lw	a4,12(sp)
40003914:	000027b7          	lui	a5,0x2
40003918:	70f78793          	addi	a5,a5,1807 # 270f <_heap_size+0x70f>
4000391c:	00f72023          	sw	a5,0(a4)
40003920:	020a1863          	bnez	s4,40003950 <_dtoa_r+0x15c>
40003924:	00ca9793          	slli	a5,s5,0xc
40003928:	02079463          	bnez	a5,40003950 <_dtoa_r+0x15c>
4000392c:	0c012783          	lw	a5,192(sp)
40003930:	4000d537          	lui	a0,0x4000d
40003934:	76850513          	addi	a0,a0,1896 # 4000d768 <zeroes.4139+0x54>
40003938:	f8078ee3          	beqz	a5,400038d4 <_dtoa_r+0xe0>
4000393c:	4000d7b7          	lui	a5,0x4000d
40003940:	77078793          	addi	a5,a5,1904 # 4000d770 <zeroes.4139+0x5c>
40003944:	0c012703          	lw	a4,192(sp)
40003948:	00f72023          	sw	a5,0(a4)
4000394c:	f89ff06f          	j	400038d4 <_dtoa_r+0xe0>
40003950:	0c012783          	lw	a5,192(sp)
40003954:	4000d537          	lui	a0,0x4000d
40003958:	77450513          	addi	a0,a0,1908 # 4000d774 <zeroes.4139+0x60>
4000395c:	f6078ce3          	beqz	a5,400038d4 <_dtoa_r+0xe0>
40003960:	4000d7b7          	lui	a5,0x4000d
40003964:	77778793          	addi	a5,a5,1911 # 4000d777 <zeroes.4139+0x63>
40003968:	fddff06f          	j	40003944 <_dtoa_r+0x150>
4000396c:	80000437          	lui	s0,0x80000
40003970:	fff44413          	not	s0,s0
40003974:	01247433          	and	s0,s0,s2
40003978:	00100793          	li	a5,1
4000397c:	00f9a023          	sw	a5,0(s3)
40003980:	00040a93          	mv	s5,s0
40003984:	f01ff06f          	j	40003884 <_dtoa_r+0x90>
40003988:	00048613          	mv	a2,s1
4000398c:	00040693          	mv	a3,s0
40003990:	07810793          	addi	a5,sp,120
40003994:	07c10713          	addi	a4,sp,124
40003998:	000d8513          	mv	a0,s11
4000399c:	1c0030ef          	jal	ra,40006b5c <__d2b>
400039a0:	014ad913          	srli	s2,s5,0x14
400039a4:	00050d13          	mv	s10,a0
400039a8:	56090463          	beqz	s2,40003f10 <_dtoa_r+0x71c>
400039ac:	001005b7          	lui	a1,0x100
400039b0:	fff58593          	addi	a1,a1,-1 # fffff <_heap_size+0xfdfff>
400039b4:	07812983          	lw	s3,120(sp)
400039b8:	0085f5b3          	and	a1,a1,s0
400039bc:	3ff00bb7          	lui	s7,0x3ff00
400039c0:	00048793          	mv	a5,s1
400039c4:	0175e5b3          	or	a1,a1,s7
400039c8:	c0190913          	addi	s2,s2,-1023
400039cc:	00000a93          	li	s5,0
400039d0:	4000e737          	lui	a4,0x4000e
400039d4:	c4872603          	lw	a2,-952(a4) # 4000dc48 <__clz_tab+0x114>
400039d8:	c4c72683          	lw	a3,-948(a4)
400039dc:	00078513          	mv	a0,a5
400039e0:	18c080ef          	jal	ra,4000bb6c <__subdf3>
400039e4:	4000e7b7          	lui	a5,0x4000e
400039e8:	c507a603          	lw	a2,-944(a5) # 4000dc50 <__clz_tab+0x11c>
400039ec:	c547a683          	lw	a3,-940(a5)
400039f0:	171070ef          	jal	ra,4000b360 <__muldf3>
400039f4:	4000e7b7          	lui	a5,0x4000e
400039f8:	c587a603          	lw	a2,-936(a5) # 4000dc58 <__clz_tab+0x124>
400039fc:	c5c7a683          	lw	a3,-932(a5)
40003a00:	428060ef          	jal	ra,40009e28 <__adddf3>
40003a04:	00a12823          	sw	a0,16(sp)
40003a08:	00090513          	mv	a0,s2
40003a0c:	00b12a23          	sw	a1,20(sp)
40003a10:	3b5080ef          	jal	ra,4000c5c4 <__floatsidf>
40003a14:	4000e7b7          	lui	a5,0x4000e
40003a18:	c607a603          	lw	a2,-928(a5) # 4000dc60 <__clz_tab+0x12c>
40003a1c:	c647a683          	lw	a3,-924(a5)
40003a20:	141070ef          	jal	ra,4000b360 <__muldf3>
40003a24:	01012803          	lw	a6,16(sp)
40003a28:	01412883          	lw	a7,20(sp)
40003a2c:	00050613          	mv	a2,a0
40003a30:	00058693          	mv	a3,a1
40003a34:	00080513          	mv	a0,a6
40003a38:	00088593          	mv	a1,a7
40003a3c:	3ec060ef          	jal	ra,40009e28 <__adddf3>
40003a40:	00b12e23          	sw	a1,28(sp)
40003a44:	00a12c23          	sw	a0,24(sp)
40003a48:	2f9080ef          	jal	ra,4000c540 <__fixdfsi>
40003a4c:	00a12823          	sw	a0,16(sp)
40003a50:	01c12583          	lw	a1,28(sp)
40003a54:	01812503          	lw	a0,24(sp)
40003a58:	00000613          	li	a2,0
40003a5c:	00000693          	li	a3,0
40003a60:	7fc070ef          	jal	ra,4000b25c <__ledf2>
40003a64:	02054ee3          	bltz	a0,400042a0 <_dtoa_r+0xaac>
40003a68:	01012b83          	lw	s7,16(sp)
40003a6c:	00100713          	li	a4,1
40003a70:	01600793          	li	a5,22
40003a74:	02e12423          	sw	a4,40(sp)
40003a78:	0377ec63          	bltu	a5,s7,40003ab0 <_dtoa_r+0x2bc>
40003a7c:	4000d737          	lui	a4,0x4000d
40003a80:	003b9793          	slli	a5,s7,0x3
40003a84:	79870713          	addi	a4,a4,1944 # 4000d798 <__mprec_tens>
40003a88:	00e787b3          	add	a5,a5,a4
40003a8c:	0007a503          	lw	a0,0(a5)
40003a90:	0047a583          	lw	a1,4(a5)
40003a94:	00048613          	mv	a2,s1
40003a98:	00040693          	mv	a3,s0
40003a9c:	6bc070ef          	jal	ra,4000b158 <__gedf2>
40003aa0:	04a05ee3          	blez	a0,400042fc <_dtoa_r+0xb08>
40003aa4:	fffb8793          	addi	a5,s7,-1 # 3fefffff <_heap_size+0x3fefdfff>
40003aa8:	00f12823          	sw	a5,16(sp)
40003aac:	02012423          	sw	zero,40(sp)
40003ab0:	41298933          	sub	s2,s3,s2
40003ab4:	fff90b93          	addi	s7,s2,-1
40003ab8:	00000c13          	li	s8,0
40003abc:	000bcae3          	bltz	s7,400042d0 <_dtoa_r+0xadc>
40003ac0:	01012783          	lw	a5,16(sp)
40003ac4:	7c07c463          	bltz	a5,4000428c <_dtoa_r+0xa98>
40003ac8:	00fb8bb3          	add	s7,s7,a5
40003acc:	02f12623          	sw	a5,44(sp)
40003ad0:	00000993          	li	s3,0
40003ad4:	00900793          	li	a5,9
40003ad8:	4997e863          	bltu	a5,s9,40003f68 <_dtoa_r+0x774>
40003adc:	00500793          	li	a5,5
40003ae0:	00100913          	li	s2,1
40003ae4:	0197d663          	ble	s9,a5,40003af0 <_dtoa_r+0x2fc>
40003ae8:	ffcc8c93          	addi	s9,s9,-4 # 7ffffffc <end+0x3ffef21c>
40003aec:	00000913          	li	s2,0
40003af0:	00300793          	li	a5,3
40003af4:	56fc8ae3          	beq	s9,a5,40004868 <_dtoa_r+0x1074>
40003af8:	4b97dee3          	ble	s9,a5,400047b4 <_dtoa_r+0xfc0>
40003afc:	00400793          	li	a5,4
40003b00:	34fc86e3          	beq	s9,a5,4000464c <_dtoa_r+0xe58>
40003b04:	00100713          	li	a4,1
40003b08:	00500793          	li	a5,5
40003b0c:	02e12223          	sw	a4,36(sp)
40003b10:	4afc98e3          	bne	s9,a5,400047c0 <_dtoa_r+0xfcc>
40003b14:	01012783          	lw	a5,16(sp)
40003b18:	016787b3          	add	a5,a5,s6
40003b1c:	02f12c23          	sw	a5,56(sp)
40003b20:	00178793          	addi	a5,a5,1
40003b24:	00f12c23          	sw	a5,24(sp)
40003b28:	00078613          	mv	a2,a5
40003b2c:	3ef058e3          	blez	a5,4000471c <_dtoa_r+0xf28>
40003b30:	01812803          	lw	a6,24(sp)
40003b34:	040da223          	sw	zero,68(s11)
40003b38:	01700793          	li	a5,23
40003b3c:	00000593          	li	a1,0
40003b40:	02c7f263          	bleu	a2,a5,40003b64 <_dtoa_r+0x370>
40003b44:	00100713          	li	a4,1
40003b48:	00400793          	li	a5,4
40003b4c:	00179793          	slli	a5,a5,0x1
40003b50:	01478693          	addi	a3,a5,20
40003b54:	00070593          	mv	a1,a4
40003b58:	00170713          	addi	a4,a4,1
40003b5c:	fed678e3          	bleu	a3,a2,40003b4c <_dtoa_r+0x358>
40003b60:	04bda223          	sw	a1,68(s11)
40003b64:	000d8513          	mv	a0,s11
40003b68:	03012823          	sw	a6,48(sp)
40003b6c:	2a4020ef          	jal	ra,40005e10 <_Balloc>
40003b70:	03012803          	lw	a6,48(sp)
40003b74:	02a12023          	sw	a0,32(sp)
40003b78:	04ada023          	sw	a0,64(s11)
40003b7c:	00e00793          	li	a5,14
40003b80:	4107ee63          	bltu	a5,a6,40003f9c <_dtoa_r+0x7a8>
40003b84:	40090c63          	beqz	s2,40003f9c <_dtoa_r+0x7a8>
40003b88:	01012703          	lw	a4,16(sp)
40003b8c:	02912e23          	sw	s1,60(sp)
40003b90:	04812423          	sw	s0,72(sp)
40003b94:	5ee050e3          	blez	a4,40004974 <_dtoa_r+0x1180>
40003b98:	00f77793          	andi	a5,a4,15
40003b9c:	40475a13          	srai	s4,a4,0x4
40003ba0:	4000d737          	lui	a4,0x4000d
40003ba4:	79870713          	addi	a4,a4,1944 # 4000d798 <__mprec_tens>
40003ba8:	00379793          	slli	a5,a5,0x3
40003bac:	00e787b3          	add	a5,a5,a4
40003bb0:	02912823          	sw	s1,48(sp)
40003bb4:	010a7713          	andi	a4,s4,16
40003bb8:	02812a23          	sw	s0,52(sp)
40003bbc:	0007a803          	lw	a6,0(a5)
40003bc0:	0047a883          	lw	a7,4(a5)
40003bc4:	00200913          	li	s2,2
40003bc8:	02070e63          	beqz	a4,40003c04 <_dtoa_r+0x410>
40003bcc:	4000e7b7          	lui	a5,0x4000e
40003bd0:	8a87a603          	lw	a2,-1880(a5) # 4000d8a8 <__mprec_bigtens+0x20>
40003bd4:	8ac7a683          	lw	a3,-1876(a5)
40003bd8:	00048513          	mv	a0,s1
40003bdc:	00040593          	mv	a1,s0
40003be0:	05012023          	sw	a6,64(sp)
40003be4:	05112223          	sw	a7,68(sp)
40003be8:	38d060ef          	jal	ra,4000a774 <__divdf3>
40003bec:	04012803          	lw	a6,64(sp)
40003bf0:	04412883          	lw	a7,68(sp)
40003bf4:	02a12823          	sw	a0,48(sp)
40003bf8:	02b12a23          	sw	a1,52(sp)
40003bfc:	00fa7a13          	andi	s4,s4,15
40003c00:	00300913          	li	s2,3
40003c04:	040a0063          	beqz	s4,40003c44 <_dtoa_r+0x450>
40003c08:	4000e437          	lui	s0,0x4000e
40003c0c:	88840413          	addi	s0,s0,-1912 # 4000d888 <__mprec_bigtens>
40003c10:	001a7793          	andi	a5,s4,1
40003c14:	00080513          	mv	a0,a6
40003c18:	401a5a13          	srai	s4,s4,0x1
40003c1c:	00088593          	mv	a1,a7
40003c20:	00078e63          	beqz	a5,40003c3c <_dtoa_r+0x448>
40003c24:	00042603          	lw	a2,0(s0)
40003c28:	00442683          	lw	a3,4(s0)
40003c2c:	00190913          	addi	s2,s2,1
40003c30:	730070ef          	jal	ra,4000b360 <__muldf3>
40003c34:	00050813          	mv	a6,a0
40003c38:	00058893          	mv	a7,a1
40003c3c:	00840413          	addi	s0,s0,8
40003c40:	fc0a18e3          	bnez	s4,40003c10 <_dtoa_r+0x41c>
40003c44:	03012503          	lw	a0,48(sp)
40003c48:	03412583          	lw	a1,52(sp)
40003c4c:	00080613          	mv	a2,a6
40003c50:	00088693          	mv	a3,a7
40003c54:	321060ef          	jal	ra,4000a774 <__divdf3>
40003c58:	02a12823          	sw	a0,48(sp)
40003c5c:	02b12a23          	sw	a1,52(sp)
40003c60:	02812783          	lw	a5,40(sp)
40003c64:	02078263          	beqz	a5,40003c88 <_dtoa_r+0x494>
40003c68:	4000e7b7          	lui	a5,0x4000e
40003c6c:	c687a603          	lw	a2,-920(a5) # 4000dc68 <__clz_tab+0x134>
40003c70:	c6c7a683          	lw	a3,-916(a5)
40003c74:	03012503          	lw	a0,48(sp)
40003c78:	03412583          	lw	a1,52(sp)
40003c7c:	5e0070ef          	jal	ra,4000b25c <__ledf2>
40003c80:	00055463          	bgez	a0,40003c88 <_dtoa_r+0x494>
40003c84:	7910006f          	j	40004c14 <_dtoa_r+0x1420>
40003c88:	00090513          	mv	a0,s2
40003c8c:	139080ef          	jal	ra,4000c5c4 <__floatsidf>
40003c90:	03012603          	lw	a2,48(sp)
40003c94:	03412683          	lw	a3,52(sp)
40003c98:	fcc004b7          	lui	s1,0xfcc00
40003c9c:	6c4070ef          	jal	ra,4000b360 <__muldf3>
40003ca0:	4000e7b7          	lui	a5,0x4000e
40003ca4:	c787a603          	lw	a2,-904(a5) # 4000dc78 <__clz_tab+0x144>
40003ca8:	c7c7a683          	lw	a3,-900(a5)
40003cac:	17c060ef          	jal	ra,40009e28 <__adddf3>
40003cb0:	01812783          	lw	a5,24(sp)
40003cb4:	00050413          	mv	s0,a0
40003cb8:	00b484b3          	add	s1,s1,a1
40003cbc:	3e0782e3          	beqz	a5,400048a0 <_dtoa_r+0x10ac>
40003cc0:	01012783          	lw	a5,16(sp)
40003cc4:	01812903          	lw	s2,24(sp)
40003cc8:	04f12623          	sw	a5,76(sp)
40003ccc:	02412783          	lw	a5,36(sp)
40003cd0:	5a0782e3          	beqz	a5,40004a74 <_dtoa_r+0x1280>
40003cd4:	fff90793          	addi	a5,s2,-1
40003cd8:	4000d737          	lui	a4,0x4000d
40003cdc:	79870713          	addi	a4,a4,1944 # 4000d798 <__mprec_tens>
40003ce0:	00379793          	slli	a5,a5,0x3
40003ce4:	00e787b3          	add	a5,a5,a4
40003ce8:	0007a603          	lw	a2,0(a5)
40003cec:	0047a683          	lw	a3,4(a5)
40003cf0:	4000e7b7          	lui	a5,0x4000e
40003cf4:	c887a503          	lw	a0,-888(a5) # 4000dc88 <__clz_tab+0x154>
40003cf8:	c8c7a583          	lw	a1,-884(a5)
40003cfc:	02012783          	lw	a5,32(sp)
40003d00:	00178a13          	addi	s4,a5,1
40003d04:	271060ef          	jal	ra,4000a774 <__divdf3>
40003d08:	00040613          	mv	a2,s0
40003d0c:	00048693          	mv	a3,s1
40003d10:	65d070ef          	jal	ra,4000bb6c <__subdf3>
40003d14:	04a12023          	sw	a0,64(sp)
40003d18:	04b12223          	sw	a1,68(sp)
40003d1c:	03012503          	lw	a0,48(sp)
40003d20:	03412583          	lw	a1,52(sp)
40003d24:	01d080ef          	jal	ra,4000c540 <__fixdfsi>
40003d28:	00050413          	mv	s0,a0
40003d2c:	099080ef          	jal	ra,4000c5c4 <__floatsidf>
40003d30:	00050613          	mv	a2,a0
40003d34:	00058693          	mv	a3,a1
40003d38:	03012503          	lw	a0,48(sp)
40003d3c:	03412583          	lw	a1,52(sp)
40003d40:	62d070ef          	jal	ra,4000bb6c <__subdf3>
40003d44:	02012783          	lw	a5,32(sp)
40003d48:	00050613          	mv	a2,a0
40003d4c:	00058693          	mv	a3,a1
40003d50:	03040713          	addi	a4,s0,48
40003d54:	04a12823          	sw	a0,80(sp)
40003d58:	04b12a23          	sw	a1,84(sp)
40003d5c:	04012503          	lw	a0,64(sp)
40003d60:	04412583          	lw	a1,68(sp)
40003d64:	0ff77413          	andi	s0,a4,255
40003d68:	00878023          	sb	s0,0(a5)
40003d6c:	3ec070ef          	jal	ra,4000b158 <__gedf2>
40003d70:	16a04263          	bgtz	a0,40003ed4 <_dtoa_r+0x6e0>
40003d74:	4000e7b7          	lui	a5,0x4000e
40003d78:	05012603          	lw	a2,80(sp)
40003d7c:	05412683          	lw	a3,84(sp)
40003d80:	c687a503          	lw	a0,-920(a5) # 4000dc68 <__clz_tab+0x134>
40003d84:	c6c7a583          	lw	a1,-916(a5)
40003d88:	02f12823          	sw	a5,48(sp)
40003d8c:	5e1070ef          	jal	ra,4000bb6c <__subdf3>
40003d90:	04012603          	lw	a2,64(sp)
40003d94:	04412683          	lw	a3,68(sp)
40003d98:	4c4070ef          	jal	ra,4000b25c <__ledf2>
40003d9c:	00055463          	bgez	a0,40003da4 <_dtoa_r+0x5b0>
40003da0:	7490006f          	j	40004ce8 <_dtoa_r+0x14f4>
40003da4:	00100713          	li	a4,1
40003da8:	03012783          	lw	a5,48(sp)
40003dac:	3ae90ee3          	beq	s2,a4,40004968 <_dtoa_r+0x1174>
40003db0:	4000e4b7          	lui	s1,0x4000e
40003db4:	c704a703          	lw	a4,-912(s1) # 4000dc70 <__clz_tab+0x13c>
40003db8:	c744a483          	lw	s1,-908(s1)
40003dbc:	05812e23          	sw	s8,92(sp)
40003dc0:	00070693          	mv	a3,a4
40003dc4:	c687a703          	lw	a4,-920(a5)
40003dc8:	c6c7a783          	lw	a5,-916(a5)
40003dcc:	07312023          	sw	s3,96(sp)
40003dd0:	02e12823          	sw	a4,48(sp)
40003dd4:	02f12a23          	sw	a5,52(sp)
40003dd8:	02012783          	lw	a5,32(sp)
40003ddc:	00068713          	mv	a4,a3
40003de0:	07712223          	sw	s7,100(sp)
40003de4:	012787b3          	add	a5,a5,s2
40003de8:	07512423          	sw	s5,104(sp)
40003dec:	05a12c23          	sw	s10,88(sp)
40003df0:	07912623          	sw	s9,108(sp)
40003df4:	04012c03          	lw	s8,64(sp)
40003df8:	00068913          	mv	s2,a3
40003dfc:	05612023          	sw	s6,64(sp)
40003e00:	00078a93          	mv	s5,a5
40003e04:	000d8b13          	mv	s6,s11
40003e08:	04412c83          	lw	s9,68(sp)
40003e0c:	05012d03          	lw	s10,80(sp)
40003e10:	05412d83          	lw	s11,84(sp)
40003e14:	00070993          	mv	s3,a4
40003e18:	00048b93          	mv	s7,s1
40003e1c:	0280006f          	j	40003e44 <_dtoa_r+0x650>
40003e20:	03012503          	lw	a0,48(sp)
40003e24:	03412583          	lw	a1,52(sp)
40003e28:	545070ef          	jal	ra,4000bb6c <__subdf3>
40003e2c:	000c0613          	mv	a2,s8
40003e30:	000c8693          	mv	a3,s9
40003e34:	428070ef          	jal	ra,4000b25c <__ledf2>
40003e38:	00055463          	bgez	a0,40003e40 <_dtoa_r+0x64c>
40003e3c:	6a50006f          	j	40004ce0 <_dtoa_r+0x14ec>
40003e40:	315a04e3          	beq	s4,s5,40004948 <_dtoa_r+0x1154>
40003e44:	00098613          	mv	a2,s3
40003e48:	00048693          	mv	a3,s1
40003e4c:	000c0513          	mv	a0,s8
40003e50:	000c8593          	mv	a1,s9
40003e54:	50c070ef          	jal	ra,4000b360 <__muldf3>
40003e58:	00090613          	mv	a2,s2
40003e5c:	000b8693          	mv	a3,s7
40003e60:	00050c13          	mv	s8,a0
40003e64:	00058c93          	mv	s9,a1
40003e68:	000d0513          	mv	a0,s10
40003e6c:	000d8593          	mv	a1,s11
40003e70:	4f0070ef          	jal	ra,4000b360 <__muldf3>
40003e74:	00058d93          	mv	s11,a1
40003e78:	00050d13          	mv	s10,a0
40003e7c:	6c4080ef          	jal	ra,4000c540 <__fixdfsi>
40003e80:	00050413          	mv	s0,a0
40003e84:	740080ef          	jal	ra,4000c5c4 <__floatsidf>
40003e88:	00050613          	mv	a2,a0
40003e8c:	00058693          	mv	a3,a1
40003e90:	000d0513          	mv	a0,s10
40003e94:	000d8593          	mv	a1,s11
40003e98:	03040413          	addi	s0,s0,48
40003e9c:	4d1070ef          	jal	ra,4000bb6c <__subdf3>
40003ea0:	001a0a13          	addi	s4,s4,1
40003ea4:	0ff47413          	andi	s0,s0,255
40003ea8:	000c0613          	mv	a2,s8
40003eac:	000c8693          	mv	a3,s9
40003eb0:	fe8a0fa3          	sb	s0,-1(s4)
40003eb4:	00050d13          	mv	s10,a0
40003eb8:	00058d93          	mv	s11,a1
40003ebc:	3a0070ef          	jal	ra,4000b25c <__ledf2>
40003ec0:	000d0613          	mv	a2,s10
40003ec4:	000d8693          	mv	a3,s11
40003ec8:	f4055ce3          	bgez	a0,40003e20 <_dtoa_r+0x62c>
40003ecc:	05812d03          	lw	s10,88(sp)
40003ed0:	000b0d93          	mv	s11,s6
40003ed4:	04c12783          	lw	a5,76(sp)
40003ed8:	00f12823          	sw	a5,16(sp)
40003edc:	000d0593          	mv	a1,s10
40003ee0:	000d8513          	mv	a0,s11
40003ee4:	7d1010ef          	jal	ra,40005eb4 <_Bfree>
40003ee8:	01012783          	lw	a5,16(sp)
40003eec:	000a0023          	sb	zero,0(s4)
40003ef0:	00178713          	addi	a4,a5,1
40003ef4:	00c12783          	lw	a5,12(sp)
40003ef8:	00e7a023          	sw	a4,0(a5)
40003efc:	0c012783          	lw	a5,192(sp)
40003f00:	1e078ee3          	beqz	a5,400048fc <_dtoa_r+0x1108>
40003f04:	0147a023          	sw	s4,0(a5)
40003f08:	02012503          	lw	a0,32(sp)
40003f0c:	9c9ff06f          	j	400038d4 <_dtoa_r+0xe0>
40003f10:	07812983          	lw	s3,120(sp)
40003f14:	07c12903          	lw	s2,124(sp)
40003f18:	02000793          	li	a5,32
40003f1c:	01298933          	add	s2,s3,s2
40003f20:	43290713          	addi	a4,s2,1074
40003f24:	3ce7d663          	ble	a4,a5,400042f0 <_dtoa_r+0xafc>
40003f28:	04000793          	li	a5,64
40003f2c:	41290513          	addi	a0,s2,1042
40003f30:	40e787b3          	sub	a5,a5,a4
40003f34:	00a4d533          	srl	a0,s1,a0
40003f38:	00fa9ab3          	sll	s5,s5,a5
40003f3c:	01556533          	or	a0,a0,s5
40003f40:	77c080ef          	jal	ra,4000c6bc <__floatunsidf>
40003f44:	fe100bb7          	lui	s7,0xfe100
40003f48:	00050793          	mv	a5,a0
40003f4c:	00bb85b3          	add	a1,s7,a1
40003f50:	fff90913          	addi	s2,s2,-1
40003f54:	00100a93          	li	s5,1
40003f58:	a79ff06f          	j	400039d0 <_dtoa_r+0x1dc>
40003f5c:	4000d537          	lui	a0,0x4000d
40003f60:	76450513          	addi	a0,a0,1892 # 4000d764 <zeroes.4139+0x50>
40003f64:	971ff06f          	j	400038d4 <_dtoa_r+0xe0>
40003f68:	040da223          	sw	zero,68(s11)
40003f6c:	00000593          	li	a1,0
40003f70:	000d8513          	mv	a0,s11
40003f74:	69d010ef          	jal	ra,40005e10 <_Balloc>
40003f78:	fff00793          	li	a5,-1
40003f7c:	02f12c23          	sw	a5,56(sp)
40003f80:	00f12c23          	sw	a5,24(sp)
40003f84:	00100793          	li	a5,1
40003f88:	02a12023          	sw	a0,32(sp)
40003f8c:	04ada023          	sw	a0,64(s11)
40003f90:	00000c93          	li	s9,0
40003f94:	00000b13          	li	s6,0
40003f98:	02f12223          	sw	a5,36(sp)
40003f9c:	07c12783          	lw	a5,124(sp)
40003fa0:	1c07cc63          	bltz	a5,40004178 <_dtoa_r+0x984>
40003fa4:	01012683          	lw	a3,16(sp)
40003fa8:	00e00713          	li	a4,14
40003fac:	1cd74663          	blt	a4,a3,40004178 <_dtoa_r+0x984>
40003fb0:	4000d737          	lui	a4,0x4000d
40003fb4:	00369793          	slli	a5,a3,0x3
40003fb8:	79870713          	addi	a4,a4,1944 # 4000d798 <__mprec_tens>
40003fbc:	00e787b3          	add	a5,a5,a4
40003fc0:	0007ac03          	lw	s8,0(a5)
40003fc4:	0047ac83          	lw	s9,4(a5)
40003fc8:	6a0b4263          	bltz	s6,4000466c <_dtoa_r+0xe78>
40003fcc:	000c0613          	mv	a2,s8
40003fd0:	000c8693          	mv	a3,s9
40003fd4:	000a0513          	mv	a0,s4
40003fd8:	00040593          	mv	a1,s0
40003fdc:	798060ef          	jal	ra,4000a774 <__divdf3>
40003fe0:	560080ef          	jal	ra,4000c540 <__fixdfsi>
40003fe4:	00050493          	mv	s1,a0
40003fe8:	5dc080ef          	jal	ra,4000c5c4 <__floatsidf>
40003fec:	000c0613          	mv	a2,s8
40003ff0:	000c8693          	mv	a3,s9
40003ff4:	36c070ef          	jal	ra,4000b360 <__muldf3>
40003ff8:	00058693          	mv	a3,a1
40003ffc:	00050613          	mv	a2,a0
40004000:	00040593          	mv	a1,s0
40004004:	000a0513          	mv	a0,s4
40004008:	365070ef          	jal	ra,4000bb6c <__subdf3>
4000400c:	02012683          	lw	a3,32(sp)
40004010:	03048793          	addi	a5,s1,48
40004014:	00100713          	li	a4,1
40004018:	00f68023          	sb	a5,0(a3)
4000401c:	01812783          	lw	a5,24(sp)
40004020:	00050813          	mv	a6,a0
40004024:	00058893          	mv	a7,a1
40004028:	00e68a33          	add	s4,a3,a4
4000402c:	0ce78463          	beq	a5,a4,400040f4 <_dtoa_r+0x900>
40004030:	4000e4b7          	lui	s1,0x4000e
40004034:	c704a603          	lw	a2,-912(s1) # 4000dc70 <__clz_tab+0x13c>
40004038:	c744a683          	lw	a3,-908(s1)
4000403c:	324070ef          	jal	ra,4000b360 <__muldf3>
40004040:	00000613          	li	a2,0
40004044:	00000693          	li	a3,0
40004048:	00050913          	mv	s2,a0
4000404c:	00058993          	mv	s3,a1
40004050:	07c070ef          	jal	ra,4000b0cc <__eqdf2>
40004054:	e80504e3          	beqz	a0,40003edc <_dtoa_r+0x6e8>
40004058:	02012783          	lw	a5,32(sp)
4000405c:	01812703          	lw	a4,24(sp)
40004060:	c704ab03          	lw	s6,-912(s1)
40004064:	c744ab83          	lw	s7,-908(s1)
40004068:	00278413          	addi	s0,a5,2
4000406c:	00e78ab3          	add	s5,a5,a4
40004070:	0240006f          	j	40004094 <_dtoa_r+0x8a0>
40004074:	2ec070ef          	jal	ra,4000b360 <__muldf3>
40004078:	00000613          	li	a2,0
4000407c:	00000693          	li	a3,0
40004080:	00050913          	mv	s2,a0
40004084:	00058993          	mv	s3,a1
40004088:	00140413          	addi	s0,s0,1
4000408c:	040070ef          	jal	ra,4000b0cc <__eqdf2>
40004090:	e40506e3          	beqz	a0,40003edc <_dtoa_r+0x6e8>
40004094:	000c0613          	mv	a2,s8
40004098:	000c8693          	mv	a3,s9
4000409c:	00090513          	mv	a0,s2
400040a0:	00098593          	mv	a1,s3
400040a4:	6d0060ef          	jal	ra,4000a774 <__divdf3>
400040a8:	498080ef          	jal	ra,4000c540 <__fixdfsi>
400040ac:	00050493          	mv	s1,a0
400040b0:	514080ef          	jal	ra,4000c5c4 <__floatsidf>
400040b4:	000c0613          	mv	a2,s8
400040b8:	000c8693          	mv	a3,s9
400040bc:	2a4070ef          	jal	ra,4000b360 <__muldf3>
400040c0:	00050613          	mv	a2,a0
400040c4:	00058693          	mv	a3,a1
400040c8:	00090513          	mv	a0,s2
400040cc:	00098593          	mv	a1,s3
400040d0:	29d070ef          	jal	ra,4000bb6c <__subdf3>
400040d4:	03048793          	addi	a5,s1,48
400040d8:	fef40fa3          	sb	a5,-1(s0)
400040dc:	00050813          	mv	a6,a0
400040e0:	00058893          	mv	a7,a1
400040e4:	000b0613          	mv	a2,s6
400040e8:	000b8693          	mv	a3,s7
400040ec:	00040a13          	mv	s4,s0
400040f0:	f88a92e3          	bne	s5,s0,40004074 <_dtoa_r+0x880>
400040f4:	00080613          	mv	a2,a6
400040f8:	00088693          	mv	a3,a7
400040fc:	00080513          	mv	a0,a6
40004100:	00088593          	mv	a1,a7
40004104:	525050ef          	jal	ra,40009e28 <__adddf3>
40004108:	00050913          	mv	s2,a0
4000410c:	00058993          	mv	s3,a1
40004110:	00050613          	mv	a2,a0
40004114:	00058693          	mv	a3,a1
40004118:	000c0513          	mv	a0,s8
4000411c:	000c8593          	mv	a1,s9
40004120:	13c070ef          	jal	ra,4000b25c <__ledf2>
40004124:	02054263          	bltz	a0,40004148 <_dtoa_r+0x954>
40004128:	00090613          	mv	a2,s2
4000412c:	00098693          	mv	a3,s3
40004130:	000c0513          	mv	a0,s8
40004134:	000c8593          	mv	a1,s9
40004138:	795060ef          	jal	ra,4000b0cc <__eqdf2>
4000413c:	da0510e3          	bnez	a0,40003edc <_dtoa_r+0x6e8>
40004140:	0014f493          	andi	s1,s1,1
40004144:	d8048ce3          	beqz	s1,40003edc <_dtoa_r+0x6e8>
40004148:	fffa4403          	lbu	s0,-1(s4)
4000414c:	03900613          	li	a2,57
40004150:	02012783          	lw	a5,32(sp)
40004154:	0100006f          	j	40004164 <_dtoa_r+0x970>
40004158:	0af68ee3          	beq	a3,a5,40004a14 <_dtoa_r+0x1220>
4000415c:	fff6c403          	lbu	s0,-1(a3)
40004160:	00068a13          	mv	s4,a3
40004164:	fffa0693          	addi	a3,s4,-1
40004168:	fec408e3          	beq	s0,a2,40004158 <_dtoa_r+0x964>
4000416c:	00140713          	addi	a4,s0,1
40004170:	00e68023          	sb	a4,0(a3)
40004174:	d69ff06f          	j	40003edc <_dtoa_r+0x6e8>
40004178:	02412703          	lw	a4,36(sp)
4000417c:	16070263          	beqz	a4,400042e0 <_dtoa_r+0xaec>
40004180:	00100713          	li	a4,1
40004184:	59975263          	ble	s9,a4,40004708 <_dtoa_r+0xf14>
40004188:	01812783          	lw	a5,24(sp)
4000418c:	fff78913          	addi	s2,a5,-1
40004190:	7729ca63          	blt	s3,s2,40004904 <_dtoa_r+0x1110>
40004194:	41298933          	sub	s2,s3,s2
40004198:	01812703          	lw	a4,24(sp)
4000419c:	000c0a93          	mv	s5,s8
400041a0:	00070793          	mv	a5,a4
400041a4:	240742e3          	bltz	a4,40004be8 <_dtoa_r+0x13f4>
400041a8:	00100593          	li	a1,1
400041ac:	000d8513          	mv	a0,s11
400041b0:	00fc0c33          	add	s8,s8,a5
400041b4:	00fb8bb3          	add	s7,s7,a5
400041b8:	0a4020ef          	jal	ra,4000625c <__i2b>
400041bc:	00050493          	mv	s1,a0
400041c0:	01505e63          	blez	s5,400041dc <_dtoa_r+0x9e8>
400041c4:	01705c63          	blez	s7,400041dc <_dtoa_r+0x9e8>
400041c8:	000a8793          	mv	a5,s5
400041cc:	455bc663          	blt	s7,s5,40004618 <_dtoa_r+0xe24>
400041d0:	40fc0c33          	sub	s8,s8,a5
400041d4:	40fa8ab3          	sub	s5,s5,a5
400041d8:	40fb8bb3          	sub	s7,s7,a5
400041dc:	04098a63          	beqz	s3,40004230 <_dtoa_r+0xa3c>
400041e0:	02412783          	lw	a5,36(sp)
400041e4:	4e078263          	beqz	a5,400046c8 <_dtoa_r+0xed4>
400041e8:	05205063          	blez	s2,40004228 <_dtoa_r+0xa34>
400041ec:	00048593          	mv	a1,s1
400041f0:	00090613          	mv	a2,s2
400041f4:	000d8513          	mv	a0,s11
400041f8:	2e8020ef          	jal	ra,400064e0 <__pow5mult>
400041fc:	000d0613          	mv	a2,s10
40004200:	00050593          	mv	a1,a0
40004204:	00050493          	mv	s1,a0
40004208:	000d8513          	mv	a0,s11
4000420c:	084020ef          	jal	ra,40006290 <__multiply>
40004210:	02a12823          	sw	a0,48(sp)
40004214:	000d0593          	mv	a1,s10
40004218:	000d8513          	mv	a0,s11
4000421c:	499010ef          	jal	ra,40005eb4 <_Bfree>
40004220:	03012783          	lw	a5,48(sp)
40004224:	00078d13          	mv	s10,a5
40004228:	41298633          	sub	a2,s3,s2
4000422c:	4a061063          	bnez	a2,400046cc <_dtoa_r+0xed8>
40004230:	00100593          	li	a1,1
40004234:	000d8513          	mv	a0,s11
40004238:	024020ef          	jal	ra,4000625c <__i2b>
4000423c:	02c12783          	lw	a5,44(sp)
40004240:	00050993          	mv	s3,a0
40004244:	0cf05063          	blez	a5,40004304 <_dtoa_r+0xb10>
40004248:	00078613          	mv	a2,a5
4000424c:	00050593          	mv	a1,a0
40004250:	000d8513          	mv	a0,s11
40004254:	28c020ef          	jal	ra,400064e0 <__pow5mult>
40004258:	00100793          	li	a5,1
4000425c:	00050993          	mv	s3,a0
40004260:	3d97d063          	ble	s9,a5,40004620 <_dtoa_r+0xe2c>
40004264:	00000913          	li	s2,0
40004268:	0109a783          	lw	a5,16(s3)
4000426c:	00378793          	addi	a5,a5,3
40004270:	00279793          	slli	a5,a5,0x2
40004274:	00f987b3          	add	a5,s3,a5
40004278:	0047a503          	lw	a0,4(a5)
4000427c:	6b1010ef          	jal	ra,4000612c <__hi0bits>
40004280:	02000793          	li	a5,32
40004284:	40a787b3          	sub	a5,a5,a0
40004288:	0940006f          	j	4000431c <_dtoa_r+0xb28>
4000428c:	01012783          	lw	a5,16(sp)
40004290:	02012623          	sw	zero,44(sp)
40004294:	40fc0c33          	sub	s8,s8,a5
40004298:	40f009b3          	neg	s3,a5
4000429c:	839ff06f          	j	40003ad4 <_dtoa_r+0x2e0>
400042a0:	01012b83          	lw	s7,16(sp)
400042a4:	000b8513          	mv	a0,s7
400042a8:	31c080ef          	jal	ra,4000c5c4 <__floatsidf>
400042ac:	00050613          	mv	a2,a0
400042b0:	00058693          	mv	a3,a1
400042b4:	01812503          	lw	a0,24(sp)
400042b8:	01c12583          	lw	a1,28(sp)
400042bc:	611060ef          	jal	ra,4000b0cc <__eqdf2>
400042c0:	00a03533          	snez	a0,a0
400042c4:	40ab87b3          	sub	a5,s7,a0
400042c8:	00f12823          	sw	a5,16(sp)
400042cc:	f9cff06f          	j	40003a68 <_dtoa_r+0x274>
400042d0:	00100c13          	li	s8,1
400042d4:	412c0c33          	sub	s8,s8,s2
400042d8:	00000b93          	li	s7,0
400042dc:	fe4ff06f          	j	40003ac0 <_dtoa_r+0x2cc>
400042e0:	00098913          	mv	s2,s3
400042e4:	000c0a93          	mv	s5,s8
400042e8:	00000493          	li	s1,0
400042ec:	ed5ff06f          	j	400041c0 <_dtoa_r+0x9cc>
400042f0:	40e787b3          	sub	a5,a5,a4
400042f4:	00f49533          	sll	a0,s1,a5
400042f8:	c49ff06f          	j	40003f40 <_dtoa_r+0x74c>
400042fc:	02012423          	sw	zero,40(sp)
40004300:	fb0ff06f          	j	40003ab0 <_dtoa_r+0x2bc>
40004304:	00100793          	li	a5,1
40004308:	00000913          	li	s2,0
4000430c:	4997d663          	ble	s9,a5,40004798 <_dtoa_r+0xfa4>
40004310:	02c12703          	lw	a4,44(sp)
40004314:	00100793          	li	a5,1
40004318:	f40718e3          	bnez	a4,40004268 <_dtoa_r+0xa74>
4000431c:	017787b3          	add	a5,a5,s7
40004320:	01f7f793          	andi	a5,a5,31
40004324:	1a078663          	beqz	a5,400044d0 <_dtoa_r+0xcdc>
40004328:	02000713          	li	a4,32
4000432c:	40f70733          	sub	a4,a4,a5
40004330:	00400693          	li	a3,4
40004334:	20e6dce3          	ble	a4,a3,40004d4c <_dtoa_r+0x1558>
40004338:	01c00713          	li	a4,28
4000433c:	40f707b3          	sub	a5,a4,a5
40004340:	00fc0c33          	add	s8,s8,a5
40004344:	00fa8ab3          	add	s5,s5,a5
40004348:	00fb8bb3          	add	s7,s7,a5
4000434c:	01805c63          	blez	s8,40004364 <_dtoa_r+0xb70>
40004350:	000d0593          	mv	a1,s10
40004354:	000c0613          	mv	a2,s8
40004358:	000d8513          	mv	a0,s11
4000435c:	2cc020ef          	jal	ra,40006628 <__lshift>
40004360:	00050d13          	mv	s10,a0
40004364:	01705c63          	blez	s7,4000437c <_dtoa_r+0xb88>
40004368:	00098593          	mv	a1,s3
4000436c:	000b8613          	mv	a2,s7
40004370:	000d8513          	mv	a0,s11
40004374:	2b4020ef          	jal	ra,40006628 <__lshift>
40004378:	00050993          	mv	s3,a0
4000437c:	02812783          	lw	a5,40(sp)
40004380:	16079263          	bnez	a5,400044e4 <_dtoa_r+0xcf0>
40004384:	01812783          	lw	a5,24(sp)
40004388:	46f05663          	blez	a5,400047f4 <_dtoa_r+0x1000>
4000438c:	02412783          	lw	a5,36(sp)
40004390:	1a078463          	beqz	a5,40004538 <_dtoa_r+0xd44>
40004394:	01505c63          	blez	s5,400043ac <_dtoa_r+0xbb8>
40004398:	00048593          	mv	a1,s1
4000439c:	000a8613          	mv	a2,s5
400043a0:	000d8513          	mv	a0,s11
400043a4:	284020ef          	jal	ra,40006628 <__lshift>
400043a8:	00050493          	mv	s1,a0
400043ac:	00048b13          	mv	s6,s1
400043b0:	68091263          	bnez	s2,40004a34 <_dtoa_r+0x1240>
400043b4:	02012783          	lw	a5,32(sp)
400043b8:	01812703          	lw	a4,24(sp)
400043bc:	00a00b93          	li	s7,10
400043c0:	00178413          	addi	s0,a5,1
400043c4:	00e787b3          	add	a5,a5,a4
400043c8:	02f12623          	sw	a5,44(sp)
400043cc:	001a7793          	andi	a5,s4,1
400043d0:	02f12223          	sw	a5,36(sp)
400043d4:	00098593          	mv	a1,s3
400043d8:	000d0513          	mv	a0,s10
400043dc:	9e0ff0ef          	jal	ra,400035bc <quorem>
400043e0:	00050c13          	mv	s8,a0
400043e4:	00048593          	mv	a1,s1
400043e8:	000d0513          	mv	a0,s10
400043ec:	384020ef          	jal	ra,40006770 <__mcmp>
400043f0:	00050913          	mv	s2,a0
400043f4:	000b0613          	mv	a2,s6
400043f8:	00098593          	mv	a1,s3
400043fc:	000d8513          	mv	a0,s11
40004400:	3c8020ef          	jal	ra,400067c8 <__mdiff>
40004404:	00c52683          	lw	a3,12(a0)
40004408:	fff40713          	addi	a4,s0,-1
4000440c:	02e12423          	sw	a4,40(sp)
40004410:	00050793          	mv	a5,a0
40004414:	030c0a93          	addi	s5,s8,48
40004418:	00100a13          	li	s4,1
4000441c:	00069e63          	bnez	a3,40004438 <_dtoa_r+0xc44>
40004420:	00050593          	mv	a1,a0
40004424:	00a12c23          	sw	a0,24(sp)
40004428:	000d0513          	mv	a0,s10
4000442c:	344020ef          	jal	ra,40006770 <__mcmp>
40004430:	01812783          	lw	a5,24(sp)
40004434:	00050a13          	mv	s4,a0
40004438:	00078593          	mv	a1,a5
4000443c:	000d8513          	mv	a0,s11
40004440:	275010ef          	jal	ra,40005eb4 <_Bfree>
40004444:	019a67b3          	or	a5,s4,s9
40004448:	00079663          	bnez	a5,40004454 <_dtoa_r+0xc60>
4000444c:	02412783          	lw	a5,36(sp)
40004450:	2c078a63          	beqz	a5,40004724 <_dtoa_r+0xf30>
40004454:	2e094c63          	bltz	s2,4000474c <_dtoa_r+0xf58>
40004458:	01996933          	or	s2,s2,s9
4000445c:	00091663          	bnez	s2,40004468 <_dtoa_r+0xc74>
40004460:	02412783          	lw	a5,36(sp)
40004464:	2e078463          	beqz	a5,4000474c <_dtoa_r+0xf58>
40004468:	77404263          	bgtz	s4,40004bcc <_dtoa_r+0x13d8>
4000446c:	02c12783          	lw	a5,44(sp)
40004470:	ff540fa3          	sb	s5,-1(s0)
40004474:	00040a13          	mv	s4,s0
40004478:	76878263          	beq	a5,s0,40004bdc <_dtoa_r+0x13e8>
4000447c:	000d0593          	mv	a1,s10
40004480:	00000693          	li	a3,0
40004484:	000b8613          	mv	a2,s7
40004488:	000d8513          	mv	a0,s11
4000448c:	24d010ef          	jal	ra,40005ed8 <__multadd>
40004490:	00050d13          	mv	s10,a0
40004494:	00000693          	li	a3,0
40004498:	000b8613          	mv	a2,s7
4000449c:	00048593          	mv	a1,s1
400044a0:	000d8513          	mv	a0,s11
400044a4:	2f648e63          	beq	s1,s6,400047a0 <_dtoa_r+0xfac>
400044a8:	231010ef          	jal	ra,40005ed8 <__multadd>
400044ac:	000b0593          	mv	a1,s6
400044b0:	00050493          	mv	s1,a0
400044b4:	00000693          	li	a3,0
400044b8:	000b8613          	mv	a2,s7
400044bc:	000d8513          	mv	a0,s11
400044c0:	219010ef          	jal	ra,40005ed8 <__multadd>
400044c4:	00050b13          	mv	s6,a0
400044c8:	00140413          	addi	s0,s0,1
400044cc:	f09ff06f          	j	400043d4 <_dtoa_r+0xbe0>
400044d0:	01c00793          	li	a5,28
400044d4:	00fc0c33          	add	s8,s8,a5
400044d8:	00fa8ab3          	add	s5,s5,a5
400044dc:	00fb8bb3          	add	s7,s7,a5
400044e0:	e6dff06f          	j	4000434c <_dtoa_r+0xb58>
400044e4:	00098593          	mv	a1,s3
400044e8:	000d0513          	mv	a0,s10
400044ec:	284020ef          	jal	ra,40006770 <__mcmp>
400044f0:	e8055ae3          	bgez	a0,40004384 <_dtoa_r+0xb90>
400044f4:	000d0593          	mv	a1,s10
400044f8:	00000693          	li	a3,0
400044fc:	00a00613          	li	a2,10
40004500:	000d8513          	mv	a0,s11
40004504:	1d5010ef          	jal	ra,40005ed8 <__multadd>
40004508:	01012783          	lw	a5,16(sp)
4000450c:	00050d13          	mv	s10,a0
40004510:	fff78793          	addi	a5,a5,-1
40004514:	00f12823          	sw	a5,16(sp)
40004518:	02412783          	lw	a5,36(sp)
4000451c:	7e079463          	bnez	a5,40004d04 <_dtoa_r+0x1510>
40004520:	03812783          	lw	a5,56(sp)
40004524:	00f04863          	bgtz	a5,40004534 <_dtoa_r+0xd40>
40004528:	00200793          	li	a5,2
4000452c:	0197cae3          	blt	a5,s9,40004d40 <_dtoa_r+0x154c>
40004530:	03812783          	lw	a5,56(sp)
40004534:	00f12c23          	sw	a5,24(sp)
40004538:	02012b03          	lw	s6,32(sp)
4000453c:	00a00913          	li	s2,10
40004540:	01812a03          	lw	s4,24(sp)
40004544:	000b0413          	mv	s0,s6
40004548:	00c0006f          	j	40004554 <_dtoa_r+0xd60>
4000454c:	18d010ef          	jal	ra,40005ed8 <__multadd>
40004550:	00050d13          	mv	s10,a0
40004554:	00098593          	mv	a1,s3
40004558:	000d0513          	mv	a0,s10
4000455c:	860ff0ef          	jal	ra,400035bc <quorem>
40004560:	00140413          	addi	s0,s0,1
40004564:	03050a93          	addi	s5,a0,48
40004568:	ff540fa3          	sb	s5,-1(s0)
4000456c:	416407b3          	sub	a5,s0,s6
40004570:	00000693          	li	a3,0
40004574:	00090613          	mv	a2,s2
40004578:	000d0593          	mv	a1,s10
4000457c:	000d8513          	mv	a0,s11
40004580:	fd47c6e3          	blt	a5,s4,4000454c <_dtoa_r+0xd58>
40004584:	01812783          	lw	a5,24(sp)
40004588:	66f05663          	blez	a5,40004bf4 <_dtoa_r+0x1400>
4000458c:	02012703          	lw	a4,32(sp)
40004590:	00000413          	li	s0,0
40004594:	00f70a33          	add	s4,a4,a5
40004598:	000d0593          	mv	a1,s10
4000459c:	00100613          	li	a2,1
400045a0:	000d8513          	mv	a0,s11
400045a4:	084020ef          	jal	ra,40006628 <__lshift>
400045a8:	00098593          	mv	a1,s3
400045ac:	00050d13          	mv	s10,a0
400045b0:	1c0020ef          	jal	ra,40006770 <__mcmp>
400045b4:	12a05663          	blez	a0,400046e0 <_dtoa_r+0xeec>
400045b8:	fffa4683          	lbu	a3,-1(s4)
400045bc:	03900613          	li	a2,57
400045c0:	02012783          	lw	a5,32(sp)
400045c4:	0100006f          	j	400045d4 <_dtoa_r+0xde0>
400045c8:	28f70263          	beq	a4,a5,4000484c <_dtoa_r+0x1058>
400045cc:	fff74683          	lbu	a3,-1(a4)
400045d0:	00070a13          	mv	s4,a4
400045d4:	fffa0713          	addi	a4,s4,-1
400045d8:	fec688e3          	beq	a3,a2,400045c8 <_dtoa_r+0xdd4>
400045dc:	00168693          	addi	a3,a3,1
400045e0:	00d70023          	sb	a3,0(a4)
400045e4:	00098593          	mv	a1,s3
400045e8:	000d8513          	mv	a0,s11
400045ec:	0c9010ef          	jal	ra,40005eb4 <_Bfree>
400045f0:	8e0486e3          	beqz	s1,40003edc <_dtoa_r+0x6e8>
400045f4:	00040a63          	beqz	s0,40004608 <_dtoa_r+0xe14>
400045f8:	00940863          	beq	s0,s1,40004608 <_dtoa_r+0xe14>
400045fc:	00040593          	mv	a1,s0
40004600:	000d8513          	mv	a0,s11
40004604:	0b1010ef          	jal	ra,40005eb4 <_Bfree>
40004608:	00048593          	mv	a1,s1
4000460c:	000d8513          	mv	a0,s11
40004610:	0a5010ef          	jal	ra,40005eb4 <_Bfree>
40004614:	8c9ff06f          	j	40003edc <_dtoa_r+0x6e8>
40004618:	000b8793          	mv	a5,s7
4000461c:	bb5ff06f          	j	400041d0 <_dtoa_r+0x9dc>
40004620:	c40a12e3          	bnez	s4,40004264 <_dtoa_r+0xa70>
40004624:	00c41793          	slli	a5,s0,0xc
40004628:	00000913          	li	s2,0
4000462c:	ce0792e3          	bnez	a5,40004310 <_dtoa_r+0xb1c>
40004630:	7ff007b7          	lui	a5,0x7ff00
40004634:	00f47433          	and	s0,s0,a5
40004638:	cc040ce3          	beqz	s0,40004310 <_dtoa_r+0xb1c>
4000463c:	001c0c13          	addi	s8,s8,1
40004640:	001b8b93          	addi	s7,s7,1 # fe100001 <end+0xbe0ef221>
40004644:	00100913          	li	s2,1
40004648:	cc9ff06f          	j	40004310 <_dtoa_r+0xb1c>
4000464c:	00100793          	li	a5,1
40004650:	02f12223          	sw	a5,36(sp)
40004654:	2d605663          	blez	s6,40004920 <_dtoa_r+0x112c>
40004658:	000b0613          	mv	a2,s6
4000465c:	000b0813          	mv	a6,s6
40004660:	03612c23          	sw	s6,56(sp)
40004664:	01612c23          	sw	s6,24(sp)
40004668:	cccff06f          	j	40003b34 <_dtoa_r+0x340>
4000466c:	01812783          	lw	a5,24(sp)
40004670:	94f04ee3          	bgtz	a5,40003fcc <_dtoa_r+0x7d8>
40004674:	26079e63          	bnez	a5,400048f0 <_dtoa_r+0x10fc>
40004678:	4000e7b7          	lui	a5,0x4000e
4000467c:	c807a603          	lw	a2,-896(a5) # 4000dc80 <__clz_tab+0x14c>
40004680:	c847a683          	lw	a3,-892(a5)
40004684:	000c0513          	mv	a0,s8
40004688:	000c8593          	mv	a1,s9
4000468c:	4d5060ef          	jal	ra,4000b360 <__muldf3>
40004690:	000a0613          	mv	a2,s4
40004694:	00040693          	mv	a3,s0
40004698:	2c1060ef          	jal	ra,4000b158 <__gedf2>
4000469c:	00000993          	li	s3,0
400046a0:	00000493          	li	s1,0
400046a4:	18054463          	bltz	a0,4000482c <_dtoa_r+0x1038>
400046a8:	02012a03          	lw	s4,32(sp)
400046ac:	fffb4793          	not	a5,s6
400046b0:	00f12823          	sw	a5,16(sp)
400046b4:	00098593          	mv	a1,s3
400046b8:	000d8513          	mv	a0,s11
400046bc:	7f8010ef          	jal	ra,40005eb4 <_Bfree>
400046c0:	80048ee3          	beqz	s1,40003edc <_dtoa_r+0x6e8>
400046c4:	f45ff06f          	j	40004608 <_dtoa_r+0xe14>
400046c8:	00098613          	mv	a2,s3
400046cc:	000d0593          	mv	a1,s10
400046d0:	000d8513          	mv	a0,s11
400046d4:	60d010ef          	jal	ra,400064e0 <__pow5mult>
400046d8:	00050d13          	mv	s10,a0
400046dc:	b55ff06f          	j	40004230 <_dtoa_r+0xa3c>
400046e0:	00051663          	bnez	a0,400046ec <_dtoa_r+0xef8>
400046e4:	001afa93          	andi	s5,s5,1
400046e8:	ec0a98e3          	bnez	s5,400045b8 <_dtoa_r+0xdc4>
400046ec:	03000613          	li	a2,48
400046f0:	0080006f          	j	400046f8 <_dtoa_r+0xf04>
400046f4:	00070a13          	mv	s4,a4
400046f8:	fffa4783          	lbu	a5,-1(s4)
400046fc:	fffa0713          	addi	a4,s4,-1
40004700:	fec78ae3          	beq	a5,a2,400046f4 <_dtoa_r+0xf00>
40004704:	ee1ff06f          	j	400045e4 <_dtoa_r+0xdf0>
40004708:	4e0a8a63          	beqz	s5,40004bfc <_dtoa_r+0x1408>
4000470c:	43378793          	addi	a5,a5,1075
40004710:	00098913          	mv	s2,s3
40004714:	000c0a93          	mv	s5,s8
40004718:	a91ff06f          	j	400041a8 <_dtoa_r+0x9b4>
4000471c:	00100613          	li	a2,1
40004720:	c10ff06f          	j	40003b30 <_dtoa_r+0x33c>
40004724:	03900793          	li	a5,57
40004728:	04fa8863          	beq	s5,a5,40004778 <_dtoa_r+0xf84>
4000472c:	01205463          	blez	s2,40004734 <_dtoa_r+0xf40>
40004730:	031c0a93          	addi	s5,s8,49
40004734:	02812783          	lw	a5,40(sp)
40004738:	00048413          	mv	s0,s1
4000473c:	000b0493          	mv	s1,s6
40004740:	00178a13          	addi	s4,a5,1
40004744:	01578023          	sb	s5,0(a5)
40004748:	e9dff06f          	j	400045e4 <_dtoa_r+0xdf0>
4000474c:	ff4054e3          	blez	s4,40004734 <_dtoa_r+0xf40>
40004750:	000d0593          	mv	a1,s10
40004754:	00100613          	li	a2,1
40004758:	000d8513          	mv	a0,s11
4000475c:	6cd010ef          	jal	ra,40006628 <__lshift>
40004760:	00098593          	mv	a1,s3
40004764:	00050d13          	mv	s10,a0
40004768:	008020ef          	jal	ra,40006770 <__mcmp>
4000476c:	58a05463          	blez	a0,40004cf4 <_dtoa_r+0x1500>
40004770:	03900793          	li	a5,57
40004774:	fafa9ee3          	bne	s5,a5,40004730 <_dtoa_r+0xf3c>
40004778:	02812783          	lw	a5,40(sp)
4000477c:	03900713          	li	a4,57
40004780:	00048413          	mv	s0,s1
40004784:	00178a13          	addi	s4,a5,1
40004788:	00e78023          	sb	a4,0(a5)
4000478c:	000b0493          	mv	s1,s6
40004790:	03900693          	li	a3,57
40004794:	e29ff06f          	j	400045bc <_dtoa_r+0xdc8>
40004798:	b60a1ce3          	bnez	s4,40004310 <_dtoa_r+0xb1c>
4000479c:	e89ff06f          	j	40004624 <_dtoa_r+0xe30>
400047a0:	738010ef          	jal	ra,40005ed8 <__multadd>
400047a4:	00050493          	mv	s1,a0
400047a8:	00050b13          	mv	s6,a0
400047ac:	00140413          	addi	s0,s0,1
400047b0:	c25ff06f          	j	400043d4 <_dtoa_r+0xbe0>
400047b4:	00200793          	li	a5,2
400047b8:	02012223          	sw	zero,36(sp)
400047bc:	e8fc8ce3          	beq	s9,a5,40004654 <_dtoa_r+0xe60>
400047c0:	040da223          	sw	zero,68(s11)
400047c4:	00000593          	li	a1,0
400047c8:	000d8513          	mv	a0,s11
400047cc:	644010ef          	jal	ra,40005e10 <_Balloc>
400047d0:	fff00793          	li	a5,-1
400047d4:	02f12c23          	sw	a5,56(sp)
400047d8:	00f12c23          	sw	a5,24(sp)
400047dc:	00100793          	li	a5,1
400047e0:	02a12023          	sw	a0,32(sp)
400047e4:	04ada023          	sw	a0,64(s11)
400047e8:	00000b13          	li	s6,0
400047ec:	02f12223          	sw	a5,36(sp)
400047f0:	facff06f          	j	40003f9c <_dtoa_r+0x7a8>
400047f4:	00200793          	li	a5,2
400047f8:	b997dae3          	ble	s9,a5,4000438c <_dtoa_r+0xb98>
400047fc:	01812783          	lw	a5,24(sp)
40004800:	ea0794e3          	bnez	a5,400046a8 <_dtoa_r+0xeb4>
40004804:	00098593          	mv	a1,s3
40004808:	00000693          	li	a3,0
4000480c:	00500613          	li	a2,5
40004810:	000d8513          	mv	a0,s11
40004814:	6c4010ef          	jal	ra,40005ed8 <__multadd>
40004818:	00050993          	mv	s3,a0
4000481c:	00050593          	mv	a1,a0
40004820:	000d0513          	mv	a0,s10
40004824:	74d010ef          	jal	ra,40006770 <__mcmp>
40004828:	e8a050e3          	blez	a0,400046a8 <_dtoa_r+0xeb4>
4000482c:	02012783          	lw	a5,32(sp)
40004830:	03100713          	li	a4,49
40004834:	00178a13          	addi	s4,a5,1
40004838:	00e78023          	sb	a4,0(a5)
4000483c:	01012783          	lw	a5,16(sp)
40004840:	00178793          	addi	a5,a5,1
40004844:	00f12823          	sw	a5,16(sp)
40004848:	e6dff06f          	j	400046b4 <_dtoa_r+0xec0>
4000484c:	01012783          	lw	a5,16(sp)
40004850:	03100713          	li	a4,49
40004854:	00178793          	addi	a5,a5,1
40004858:	00f12823          	sw	a5,16(sp)
4000485c:	02012783          	lw	a5,32(sp)
40004860:	00e78023          	sb	a4,0(a5)
40004864:	d81ff06f          	j	400045e4 <_dtoa_r+0xdf0>
40004868:	02012223          	sw	zero,36(sp)
4000486c:	aa8ff06f          	j	40003b14 <_dtoa_r+0x320>
40004870:	00090513          	mv	a0,s2
40004874:	551070ef          	jal	ra,4000c5c4 <__floatsidf>
40004878:	03012603          	lw	a2,48(sp)
4000487c:	03412683          	lw	a3,52(sp)
40004880:	fcc004b7          	lui	s1,0xfcc00
40004884:	2dd060ef          	jal	ra,4000b360 <__muldf3>
40004888:	4000e7b7          	lui	a5,0x4000e
4000488c:	c787a603          	lw	a2,-904(a5) # 4000dc78 <__clz_tab+0x144>
40004890:	c7c7a683          	lw	a3,-900(a5)
40004894:	594050ef          	jal	ra,40009e28 <__adddf3>
40004898:	00050413          	mv	s0,a0
4000489c:	00b484b3          	add	s1,s1,a1
400048a0:	4000e7b7          	lui	a5,0x4000e
400048a4:	c807a603          	lw	a2,-896(a5) # 4000dc80 <__clz_tab+0x14c>
400048a8:	c847a683          	lw	a3,-892(a5)
400048ac:	03012503          	lw	a0,48(sp)
400048b0:	03412583          	lw	a1,52(sp)
400048b4:	2b8070ef          	jal	ra,4000bb6c <__subdf3>
400048b8:	00040613          	mv	a2,s0
400048bc:	00048693          	mv	a3,s1
400048c0:	02a12823          	sw	a0,48(sp)
400048c4:	02b12a23          	sw	a1,52(sp)
400048c8:	091060ef          	jal	ra,4000b158 <__gedf2>
400048cc:	2ea04a63          	bgtz	a0,40004bc0 <_dtoa_r+0x13cc>
400048d0:	800007b7          	lui	a5,0x80000
400048d4:	03012503          	lw	a0,48(sp)
400048d8:	03412583          	lw	a1,52(sp)
400048dc:	00f4c4b3          	xor	s1,s1,a5
400048e0:	00040613          	mv	a2,s0
400048e4:	00048693          	mv	a3,s1
400048e8:	175060ef          	jal	ra,4000b25c <__ledf2>
400048ec:	06055e63          	bgez	a0,40004968 <_dtoa_r+0x1174>
400048f0:	00000993          	li	s3,0
400048f4:	00000493          	li	s1,0
400048f8:	db1ff06f          	j	400046a8 <_dtoa_r+0xeb4>
400048fc:	02012503          	lw	a0,32(sp)
40004900:	fd5fe06f          	j	400038d4 <_dtoa_r+0xe0>
40004904:	02c12783          	lw	a5,44(sp)
40004908:	413909b3          	sub	s3,s2,s3
4000490c:	013787b3          	add	a5,a5,s3
40004910:	02f12623          	sw	a5,44(sp)
40004914:	00090993          	mv	s3,s2
40004918:	00000913          	li	s2,0
4000491c:	87dff06f          	j	40004198 <_dtoa_r+0x9a4>
40004920:	040da223          	sw	zero,68(s11)
40004924:	00000593          	li	a1,0
40004928:	000d8513          	mv	a0,s11
4000492c:	4e4010ef          	jal	ra,40005e10 <_Balloc>
40004930:	00100b13          	li	s6,1
40004934:	02a12023          	sw	a0,32(sp)
40004938:	04ada023          	sw	a0,64(s11)
4000493c:	03612c23          	sw	s6,56(sp)
40004940:	01612c23          	sw	s6,24(sp)
40004944:	a40ff06f          	j	40003b84 <_dtoa_r+0x390>
40004948:	000b0d93          	mv	s11,s6
4000494c:	05c12c03          	lw	s8,92(sp)
40004950:	06012983          	lw	s3,96(sp)
40004954:	06412b83          	lw	s7,100(sp)
40004958:	06812a83          	lw	s5,104(sp)
4000495c:	05812d03          	lw	s10,88(sp)
40004960:	06c12c83          	lw	s9,108(sp)
40004964:	04012b03          	lw	s6,64(sp)
40004968:	03c12a03          	lw	s4,60(sp)
4000496c:	04812403          	lw	s0,72(sp)
40004970:	e2cff06f          	j	40003f9c <_dtoa_r+0x7a8>
40004974:	01012783          	lw	a5,16(sp)
40004978:	02912823          	sw	s1,48(sp)
4000497c:	02812a23          	sw	s0,52(sp)
40004980:	00200913          	li	s2,2
40004984:	ac078e63          	beqz	a5,40003c60 <_dtoa_r+0x46c>
40004988:	40f007b3          	neg	a5,a5
4000498c:	00f7f713          	andi	a4,a5,15
40004990:	4000d6b7          	lui	a3,0x4000d
40004994:	79868693          	addi	a3,a3,1944 # 4000d798 <__mprec_tens>
40004998:	00371713          	slli	a4,a4,0x3
4000499c:	00d70733          	add	a4,a4,a3
400049a0:	00072603          	lw	a2,0(a4)
400049a4:	00472683          	lw	a3,4(a4)
400049a8:	00040593          	mv	a1,s0
400049ac:	00048513          	mv	a0,s1
400049b0:	4047d413          	srai	s0,a5,0x4
400049b4:	1ad060ef          	jal	ra,4000b360 <__muldf3>
400049b8:	02a12823          	sw	a0,48(sp)
400049bc:	02b12a23          	sw	a1,52(sp)
400049c0:	aa040063          	beqz	s0,40003c60 <_dtoa_r+0x46c>
400049c4:	4000e4b7          	lui	s1,0x4000e
400049c8:	88848493          	addi	s1,s1,-1912 # 4000d888 <__mprec_bigtens>
400049cc:	00050613          	mv	a2,a0
400049d0:	00058693          	mv	a3,a1
400049d4:	00147793          	andi	a5,s0,1
400049d8:	00060513          	mv	a0,a2
400049dc:	40145413          	srai	s0,s0,0x1
400049e0:	00068593          	mv	a1,a3
400049e4:	00078e63          	beqz	a5,40004a00 <_dtoa_r+0x120c>
400049e8:	0004a603          	lw	a2,0(s1)
400049ec:	0044a683          	lw	a3,4(s1)
400049f0:	00190913          	addi	s2,s2,1
400049f4:	16d060ef          	jal	ra,4000b360 <__muldf3>
400049f8:	00050613          	mv	a2,a0
400049fc:	00058693          	mv	a3,a1
40004a00:	00848493          	addi	s1,s1,8
40004a04:	fc0418e3          	bnez	s0,400049d4 <_dtoa_r+0x11e0>
40004a08:	02c12823          	sw	a2,48(sp)
40004a0c:	02d12a23          	sw	a3,52(sp)
40004a10:	a50ff06f          	j	40003c60 <_dtoa_r+0x46c>
40004a14:	02012783          	lw	a5,32(sp)
40004a18:	03000713          	li	a4,48
40004a1c:	00e78023          	sb	a4,0(a5) # 80000000 <end+0x3ffef220>
40004a20:	01012783          	lw	a5,16(sp)
40004a24:	fffa4403          	lbu	s0,-1(s4)
40004a28:	00178793          	addi	a5,a5,1
40004a2c:	00f12823          	sw	a5,16(sp)
40004a30:	f3cff06f          	j	4000416c <_dtoa_r+0x978>
40004a34:	0044a583          	lw	a1,4(s1)
40004a38:	000d8513          	mv	a0,s11
40004a3c:	3d4010ef          	jal	ra,40005e10 <_Balloc>
40004a40:	0104a603          	lw	a2,16(s1)
40004a44:	00050413          	mv	s0,a0
40004a48:	00c48593          	addi	a1,s1,12
40004a4c:	00260613          	addi	a2,a2,2
40004a50:	00261613          	slli	a2,a2,0x2
40004a54:	00c50513          	addi	a0,a0,12
40004a58:	a05fc0ef          	jal	ra,4000145c <memcpy>
40004a5c:	00100613          	li	a2,1
40004a60:	00040593          	mv	a1,s0
40004a64:	000d8513          	mv	a0,s11
40004a68:	3c1010ef          	jal	ra,40006628 <__lshift>
40004a6c:	00050b13          	mv	s6,a0
40004a70:	945ff06f          	j	400043b4 <_dtoa_r+0xbc0>
40004a74:	fff90793          	addi	a5,s2,-1
40004a78:	4000d737          	lui	a4,0x4000d
40004a7c:	79870713          	addi	a4,a4,1944 # 4000d798 <__mprec_tens>
40004a80:	00379793          	slli	a5,a5,0x3
40004a84:	00e787b3          	add	a5,a5,a4
40004a88:	0007a503          	lw	a0,0(a5)
40004a8c:	0047a583          	lw	a1,4(a5)
40004a90:	00040613          	mv	a2,s0
40004a94:	00048693          	mv	a3,s1
40004a98:	0c9060ef          	jal	ra,4000b360 <__muldf3>
40004a9c:	04a12023          	sw	a0,64(sp)
40004aa0:	04b12223          	sw	a1,68(sp)
40004aa4:	03012503          	lw	a0,48(sp)
40004aa8:	03412583          	lw	a1,52(sp)
40004aac:	4000e4b7          	lui	s1,0x4000e
40004ab0:	291070ef          	jal	ra,4000c540 <__fixdfsi>
40004ab4:	00050413          	mv	s0,a0
40004ab8:	30d070ef          	jal	ra,4000c5c4 <__floatsidf>
40004abc:	00050613          	mv	a2,a0
40004ac0:	00058693          	mv	a3,a1
40004ac4:	03012503          	lw	a0,48(sp)
40004ac8:	03412583          	lw	a1,52(sp)
40004acc:	03040413          	addi	s0,s0,48
40004ad0:	09c070ef          	jal	ra,4000bb6c <__subdf3>
40004ad4:	02012783          	lw	a5,32(sp)
40004ad8:	00100713          	li	a4,1
40004adc:	00050813          	mv	a6,a0
40004ae0:	00878023          	sb	s0,0(a5)
40004ae4:	00058893          	mv	a7,a1
40004ae8:	00e78a33          	add	s4,a5,a4
40004aec:	01278433          	add	s0,a5,s2
40004af0:	08e90063          	beq	s2,a4,40004b70 <_dtoa_r+0x137c>
40004af4:	c704a703          	lw	a4,-912(s1) # 4000dc70 <__clz_tab+0x13c>
40004af8:	c744a783          	lw	a5,-908(s1)
40004afc:	05612823          	sw	s6,80(sp)
40004b00:	02e12823          	sw	a4,48(sp)
40004b04:	000a8b13          	mv	s6,s5
40004b08:	02f12a23          	sw	a5,52(sp)
40004b0c:	00098a93          	mv	s5,s3
40004b10:	03012603          	lw	a2,48(sp)
40004b14:	03412683          	lw	a3,52(sp)
40004b18:	00080513          	mv	a0,a6
40004b1c:	00088593          	mv	a1,a7
40004b20:	041060ef          	jal	ra,4000b360 <__muldf3>
40004b24:	00058993          	mv	s3,a1
40004b28:	00050913          	mv	s2,a0
40004b2c:	215070ef          	jal	ra,4000c540 <__fixdfsi>
40004b30:	00050493          	mv	s1,a0
40004b34:	291070ef          	jal	ra,4000c5c4 <__floatsidf>
40004b38:	00050613          	mv	a2,a0
40004b3c:	00058693          	mv	a3,a1
40004b40:	00090513          	mv	a0,s2
40004b44:	00098593          	mv	a1,s3
40004b48:	001a0a13          	addi	s4,s4,1
40004b4c:	03048493          	addi	s1,s1,48
40004b50:	01c070ef          	jal	ra,4000bb6c <__subdf3>
40004b54:	fe9a0fa3          	sb	s1,-1(s4)
40004b58:	00050813          	mv	a6,a0
40004b5c:	00058893          	mv	a7,a1
40004b60:	fa8a18e3          	bne	s4,s0,40004b10 <_dtoa_r+0x131c>
40004b64:	000a8993          	mv	s3,s5
40004b68:	000b0a93          	mv	s5,s6
40004b6c:	05012b03          	lw	s6,80(sp)
40004b70:	4000e437          	lui	s0,0x4000e
40004b74:	c8842603          	lw	a2,-888(s0) # 4000dc88 <__clz_tab+0x154>
40004b78:	c8c42683          	lw	a3,-884(s0)
40004b7c:	04012503          	lw	a0,64(sp)
40004b80:	04412583          	lw	a1,68(sp)
40004b84:	03012823          	sw	a6,48(sp)
40004b88:	03112a23          	sw	a7,52(sp)
40004b8c:	29c050ef          	jal	ra,40009e28 <__adddf3>
40004b90:	03012803          	lw	a6,48(sp)
40004b94:	03412883          	lw	a7,52(sp)
40004b98:	00080613          	mv	a2,a6
40004b9c:	00088693          	mv	a3,a7
40004ba0:	6bc060ef          	jal	ra,4000b25c <__ledf2>
40004ba4:	03012803          	lw	a6,48(sp)
40004ba8:	03412883          	lw	a7,52(sp)
40004bac:	0e055263          	bgez	a0,40004c90 <_dtoa_r+0x149c>
40004bb0:	04c12783          	lw	a5,76(sp)
40004bb4:	fffa4403          	lbu	s0,-1(s4)
40004bb8:	00f12823          	sw	a5,16(sp)
40004bbc:	d90ff06f          	j	4000414c <_dtoa_r+0x958>
40004bc0:	00000993          	li	s3,0
40004bc4:	00000493          	li	s1,0
40004bc8:	c65ff06f          	j	4000482c <_dtoa_r+0x1038>
40004bcc:	03900793          	li	a5,57
40004bd0:	bafa84e3          	beq	s5,a5,40004778 <_dtoa_r+0xf84>
40004bd4:	001a8a93          	addi	s5,s5,1
40004bd8:	b5dff06f          	j	40004734 <_dtoa_r+0xf40>
40004bdc:	00048413          	mv	s0,s1
40004be0:	000b0493          	mv	s1,s6
40004be4:	9b5ff06f          	j	40004598 <_dtoa_r+0xda4>
40004be8:	40ec0ab3          	sub	s5,s8,a4
40004bec:	00000793          	li	a5,0
40004bf0:	db8ff06f          	j	400041a8 <_dtoa_r+0x9b4>
40004bf4:	00100793          	li	a5,1
40004bf8:	995ff06f          	j	4000458c <_dtoa_r+0xd98>
40004bfc:	07812703          	lw	a4,120(sp)
40004c00:	03600793          	li	a5,54
40004c04:	00098913          	mv	s2,s3
40004c08:	40e787b3          	sub	a5,a5,a4
40004c0c:	000c0a93          	mv	s5,s8
40004c10:	d98ff06f          	j	400041a8 <_dtoa_r+0x9b4>
40004c14:	01812783          	lw	a5,24(sp)
40004c18:	c4078ce3          	beqz	a5,40004870 <_dtoa_r+0x107c>
40004c1c:	03812a03          	lw	s4,56(sp)
40004c20:	d54054e3          	blez	s4,40004968 <_dtoa_r+0x1174>
40004c24:	4000e4b7          	lui	s1,0x4000e
40004c28:	01012783          	lw	a5,16(sp)
40004c2c:	c704a603          	lw	a2,-912(s1) # 4000dc70 <__clz_tab+0x13c>
40004c30:	c744a683          	lw	a3,-908(s1)
40004c34:	03012503          	lw	a0,48(sp)
40004c38:	03412583          	lw	a1,52(sp)
40004c3c:	fff78793          	addi	a5,a5,-1
40004c40:	04f12623          	sw	a5,76(sp)
40004c44:	71c060ef          	jal	ra,4000b360 <__muldf3>
40004c48:	00050413          	mv	s0,a0
40004c4c:	02a12823          	sw	a0,48(sp)
40004c50:	00190513          	addi	a0,s2,1
40004c54:	00058493          	mv	s1,a1
40004c58:	02b12a23          	sw	a1,52(sp)
40004c5c:	169070ef          	jal	ra,4000c5c4 <__floatsidf>
40004c60:	00040613          	mv	a2,s0
40004c64:	00048693          	mv	a3,s1
40004c68:	6f8060ef          	jal	ra,4000b360 <__muldf3>
40004c6c:	4000e7b7          	lui	a5,0x4000e
40004c70:	c787a603          	lw	a2,-904(a5) # 4000dc78 <__clz_tab+0x144>
40004c74:	c7c7a683          	lw	a3,-900(a5)
40004c78:	fcc004b7          	lui	s1,0xfcc00
40004c7c:	000a0913          	mv	s2,s4
40004c80:	1a8050ef          	jal	ra,40009e28 <__adddf3>
40004c84:	00050413          	mv	s0,a0
40004c88:	00b484b3          	add	s1,s1,a1
40004c8c:	840ff06f          	j	40003ccc <_dtoa_r+0x4d8>
40004c90:	04012603          	lw	a2,64(sp)
40004c94:	04412683          	lw	a3,68(sp)
40004c98:	c8842503          	lw	a0,-888(s0)
40004c9c:	c8c42583          	lw	a1,-884(s0)
40004ca0:	03012823          	sw	a6,48(sp)
40004ca4:	03112a23          	sw	a7,52(sp)
40004ca8:	6c5060ef          	jal	ra,4000bb6c <__subdf3>
40004cac:	03012803          	lw	a6,48(sp)
40004cb0:	03412883          	lw	a7,52(sp)
40004cb4:	00080613          	mv	a2,a6
40004cb8:	00088693          	mv	a3,a7
40004cbc:	49c060ef          	jal	ra,4000b158 <__gedf2>
40004cc0:	03000613          	li	a2,48
40004cc4:	00a04663          	bgtz	a0,40004cd0 <_dtoa_r+0x14dc>
40004cc8:	ca1ff06f          	j	40004968 <_dtoa_r+0x1174>
40004ccc:	00070a13          	mv	s4,a4
40004cd0:	fffa4783          	lbu	a5,-1(s4)
40004cd4:	fffa0713          	addi	a4,s4,-1
40004cd8:	fec78ae3          	beq	a5,a2,40004ccc <_dtoa_r+0x14d8>
40004cdc:	9f8ff06f          	j	40003ed4 <_dtoa_r+0x6e0>
40004ce0:	05812d03          	lw	s10,88(sp)
40004ce4:	000b0d93          	mv	s11,s6
40004ce8:	04c12783          	lw	a5,76(sp)
40004cec:	00f12823          	sw	a5,16(sp)
40004cf0:	c5cff06f          	j	4000414c <_dtoa_r+0x958>
40004cf4:	a40510e3          	bnez	a0,40004734 <_dtoa_r+0xf40>
40004cf8:	001af793          	andi	a5,s5,1
40004cfc:	a2078ce3          	beqz	a5,40004734 <_dtoa_r+0xf40>
40004d00:	a71ff06f          	j	40004770 <_dtoa_r+0xf7c>
40004d04:	00048593          	mv	a1,s1
40004d08:	00000693          	li	a3,0
40004d0c:	00a00613          	li	a2,10
40004d10:	000d8513          	mv	a0,s11
40004d14:	1c4010ef          	jal	ra,40005ed8 <__multadd>
40004d18:	03812783          	lw	a5,56(sp)
40004d1c:	00050493          	mv	s1,a0
40004d20:	00f05663          	blez	a5,40004d2c <_dtoa_r+0x1538>
40004d24:	00f12c23          	sw	a5,24(sp)
40004d28:	e6cff06f          	j	40004394 <_dtoa_r+0xba0>
40004d2c:	00200793          	li	a5,2
40004d30:	0197c863          	blt	a5,s9,40004d40 <_dtoa_r+0x154c>
40004d34:	03812783          	lw	a5,56(sp)
40004d38:	00f12c23          	sw	a5,24(sp)
40004d3c:	e58ff06f          	j	40004394 <_dtoa_r+0xba0>
40004d40:	03812783          	lw	a5,56(sp)
40004d44:	00f12c23          	sw	a5,24(sp)
40004d48:	ab5ff06f          	j	400047fc <_dtoa_r+0x1008>
40004d4c:	e0d70063          	beq	a4,a3,4000434c <_dtoa_r+0xb58>
40004d50:	03c00713          	li	a4,60
40004d54:	40f707b3          	sub	a5,a4,a5
40004d58:	f7cff06f          	j	400044d4 <_dtoa_r+0xce0>

40004d5c <__sflush_r>:
40004d5c:	00c59783          	lh	a5,12(a1)
40004d60:	fe010113          	addi	sp,sp,-32
40004d64:	00912a23          	sw	s1,20(sp)
40004d68:	01079713          	slli	a4,a5,0x10
40004d6c:	01075713          	srli	a4,a4,0x10
40004d70:	01312623          	sw	s3,12(sp)
40004d74:	00112e23          	sw	ra,28(sp)
40004d78:	00812c23          	sw	s0,24(sp)
40004d7c:	01212823          	sw	s2,16(sp)
40004d80:	00877693          	andi	a3,a4,8
40004d84:	00058493          	mv	s1,a1
40004d88:	00050993          	mv	s3,a0
40004d8c:	10069a63          	bnez	a3,40004ea0 <__sflush_r+0x144>
40004d90:	00001737          	lui	a4,0x1
40004d94:	80070713          	addi	a4,a4,-2048 # 800 <_stack_size>
40004d98:	0045a683          	lw	a3,4(a1)
40004d9c:	00e7e7b3          	or	a5,a5,a4
40004da0:	00f59623          	sh	a5,12(a1)
40004da4:	1ed05263          	blez	a3,40004f88 <__sflush_r+0x22c>
40004da8:	0284a803          	lw	a6,40(s1) # fcc00028 <end+0xbcbef248>
40004dac:	0c080a63          	beqz	a6,40004e80 <__sflush_r+0x124>
40004db0:	01079793          	slli	a5,a5,0x10
40004db4:	0107d793          	srli	a5,a5,0x10
40004db8:	0009a403          	lw	s0,0(s3)
40004dbc:	01379713          	slli	a4,a5,0x13
40004dc0:	0009a023          	sw	zero,0(s3)
40004dc4:	1c075863          	bgez	a4,40004f94 <__sflush_r+0x238>
40004dc8:	0504a603          	lw	a2,80(s1)
40004dcc:	41f65693          	srai	a3,a2,0x1f
40004dd0:	0047f793          	andi	a5,a5,4
40004dd4:	04078263          	beqz	a5,40004e18 <__sflush_r+0xbc>
40004dd8:	0044a783          	lw	a5,4(s1)
40004ddc:	0304a583          	lw	a1,48(s1)
40004de0:	40f60733          	sub	a4,a2,a5
40004de4:	41f7d793          	srai	a5,a5,0x1f
40004de8:	00e63533          	sltu	a0,a2,a4
40004dec:	40f686b3          	sub	a3,a3,a5
40004df0:	00070613          	mv	a2,a4
40004df4:	40a686b3          	sub	a3,a3,a0
40004df8:	02058063          	beqz	a1,40004e18 <__sflush_r+0xbc>
40004dfc:	03c4a783          	lw	a5,60(s1)
40004e00:	40f70733          	sub	a4,a4,a5
40004e04:	41f7d793          	srai	a5,a5,0x1f
40004e08:	00e635b3          	sltu	a1,a2,a4
40004e0c:	40f686b3          	sub	a3,a3,a5
40004e10:	00070613          	mv	a2,a4
40004e14:	40b686b3          	sub	a3,a3,a1
40004e18:	01c4a583          	lw	a1,28(s1)
40004e1c:	00000713          	li	a4,0
40004e20:	00098513          	mv	a0,s3
40004e24:	000800e7          	jalr	a6
40004e28:	fff00793          	li	a5,-1
40004e2c:	0ef50c63          	beq	a0,a5,40004f24 <__sflush_r+0x1c8>
40004e30:	00c4d783          	lhu	a5,12(s1)
40004e34:	fffff737          	lui	a4,0xfffff
40004e38:	7ff70713          	addi	a4,a4,2047 # fffff7ff <end+0xbffeea1f>
40004e3c:	00e7f7b3          	and	a5,a5,a4
40004e40:	0104a683          	lw	a3,16(s1)
40004e44:	01079793          	slli	a5,a5,0x10
40004e48:	4107d793          	srai	a5,a5,0x10
40004e4c:	00f49623          	sh	a5,12(s1)
40004e50:	0004a223          	sw	zero,4(s1)
40004e54:	00d4a023          	sw	a3,0(s1)
40004e58:	01379713          	slli	a4,a5,0x13
40004e5c:	12074263          	bltz	a4,40004f80 <__sflush_r+0x224>
40004e60:	0304a583          	lw	a1,48(s1)
40004e64:	0089a023          	sw	s0,0(s3)
40004e68:	00058c63          	beqz	a1,40004e80 <__sflush_r+0x124>
40004e6c:	04048793          	addi	a5,s1,64
40004e70:	00f58663          	beq	a1,a5,40004e7c <__sflush_r+0x120>
40004e74:	00098513          	mv	a0,s3
40004e78:	6cc000ef          	jal	ra,40005544 <_free_r>
40004e7c:	0204a823          	sw	zero,48(s1)
40004e80:	00000513          	li	a0,0
40004e84:	01c12083          	lw	ra,28(sp)
40004e88:	01812403          	lw	s0,24(sp)
40004e8c:	01412483          	lw	s1,20(sp)
40004e90:	01012903          	lw	s2,16(sp)
40004e94:	00c12983          	lw	s3,12(sp)
40004e98:	02010113          	addi	sp,sp,32
40004e9c:	00008067          	ret
40004ea0:	0105a903          	lw	s2,16(a1)
40004ea4:	fc090ee3          	beqz	s2,40004e80 <__sflush_r+0x124>
40004ea8:	0005a403          	lw	s0,0(a1)
40004eac:	00377713          	andi	a4,a4,3
40004eb0:	0125a023          	sw	s2,0(a1)
40004eb4:	41240433          	sub	s0,s0,s2
40004eb8:	00000793          	li	a5,0
40004ebc:	00071463          	bnez	a4,40004ec4 <__sflush_r+0x168>
40004ec0:	0145a783          	lw	a5,20(a1)
40004ec4:	00f4a423          	sw	a5,8(s1)
40004ec8:	00804863          	bgtz	s0,40004ed8 <__sflush_r+0x17c>
40004ecc:	fb5ff06f          	j	40004e80 <__sflush_r+0x124>
40004ed0:	00a90933          	add	s2,s2,a0
40004ed4:	fa8056e3          	blez	s0,40004e80 <__sflush_r+0x124>
40004ed8:	0244a783          	lw	a5,36(s1)
40004edc:	01c4a583          	lw	a1,28(s1)
40004ee0:	00040693          	mv	a3,s0
40004ee4:	00090613          	mv	a2,s2
40004ee8:	00098513          	mv	a0,s3
40004eec:	000780e7          	jalr	a5
40004ef0:	40a40433          	sub	s0,s0,a0
40004ef4:	fca04ee3          	bgtz	a0,40004ed0 <__sflush_r+0x174>
40004ef8:	00c4d783          	lhu	a5,12(s1)
40004efc:	01c12083          	lw	ra,28(sp)
40004f00:	fff00513          	li	a0,-1
40004f04:	0407e793          	ori	a5,a5,64
40004f08:	00f49623          	sh	a5,12(s1)
40004f0c:	01812403          	lw	s0,24(sp)
40004f10:	01412483          	lw	s1,20(sp)
40004f14:	01012903          	lw	s2,16(sp)
40004f18:	00c12983          	lw	s3,12(sp)
40004f1c:	02010113          	addi	sp,sp,32
40004f20:	00008067          	ret
40004f24:	f0a596e3          	bne	a1,a0,40004e30 <__sflush_r+0xd4>
40004f28:	0009a683          	lw	a3,0(s3)
40004f2c:	01d00793          	li	a5,29
40004f30:	fcd7e4e3          	bltu	a5,a3,40004ef8 <__sflush_r+0x19c>
40004f34:	204007b7          	lui	a5,0x20400
40004f38:	00178793          	addi	a5,a5,1 # 20400001 <_heap_size+0x203fe001>
40004f3c:	00d7d7b3          	srl	a5,a5,a3
40004f40:	fff7c793          	not	a5,a5
40004f44:	0017f793          	andi	a5,a5,1
40004f48:	fa0798e3          	bnez	a5,40004ef8 <__sflush_r+0x19c>
40004f4c:	00c4d783          	lhu	a5,12(s1)
40004f50:	fffff737          	lui	a4,0xfffff
40004f54:	7ff70713          	addi	a4,a4,2047 # fffff7ff <end+0xbffeea1f>
40004f58:	00e7f7b3          	and	a5,a5,a4
40004f5c:	0104a603          	lw	a2,16(s1)
40004f60:	01079793          	slli	a5,a5,0x10
40004f64:	4107d793          	srai	a5,a5,0x10
40004f68:	00f49623          	sh	a5,12(s1)
40004f6c:	0004a223          	sw	zero,4(s1)
40004f70:	00c4a023          	sw	a2,0(s1)
40004f74:	01379713          	slli	a4,a5,0x13
40004f78:	ee0754e3          	bgez	a4,40004e60 <__sflush_r+0x104>
40004f7c:	ee0692e3          	bnez	a3,40004e60 <__sflush_r+0x104>
40004f80:	04a4a823          	sw	a0,80(s1)
40004f84:	eddff06f          	j	40004e60 <__sflush_r+0x104>
40004f88:	03c5a703          	lw	a4,60(a1)
40004f8c:	e0e04ee3          	bgtz	a4,40004da8 <__sflush_r+0x4c>
40004f90:	ef1ff06f          	j	40004e80 <__sflush_r+0x124>
40004f94:	01c4a583          	lw	a1,28(s1)
40004f98:	00000613          	li	a2,0
40004f9c:	00000693          	li	a3,0
40004fa0:	00100713          	li	a4,1
40004fa4:	00098513          	mv	a0,s3
40004fa8:	000800e7          	jalr	a6
40004fac:	fff00793          	li	a5,-1
40004fb0:	00050613          	mv	a2,a0
40004fb4:	00058693          	mv	a3,a1
40004fb8:	00f50863          	beq	a0,a5,40004fc8 <__sflush_r+0x26c>
40004fbc:	00c4d783          	lhu	a5,12(s1)
40004fc0:	0284a803          	lw	a6,40(s1)
40004fc4:	e0dff06f          	j	40004dd0 <__sflush_r+0x74>
40004fc8:	fea59ae3          	bne	a1,a0,40004fbc <__sflush_r+0x260>
40004fcc:	0009a783          	lw	a5,0(s3)
40004fd0:	fe0786e3          	beqz	a5,40004fbc <__sflush_r+0x260>
40004fd4:	01d00713          	li	a4,29
40004fd8:	00e78663          	beq	a5,a4,40004fe4 <__sflush_r+0x288>
40004fdc:	01600713          	li	a4,22
40004fe0:	f0e79ce3          	bne	a5,a4,40004ef8 <__sflush_r+0x19c>
40004fe4:	0089a023          	sw	s0,0(s3)
40004fe8:	00000513          	li	a0,0
40004fec:	e99ff06f          	j	40004e84 <__sflush_r+0x128>

40004ff0 <_fflush_r>:
40004ff0:	fe010113          	addi	sp,sp,-32
40004ff4:	00812c23          	sw	s0,24(sp)
40004ff8:	00112e23          	sw	ra,28(sp)
40004ffc:	00050413          	mv	s0,a0
40005000:	00050663          	beqz	a0,4000500c <_fflush_r+0x1c>
40005004:	03852783          	lw	a5,56(a0)
40005008:	02078a63          	beqz	a5,4000503c <_fflush_r+0x4c>
4000500c:	00c59783          	lh	a5,12(a1)
40005010:	00079c63          	bnez	a5,40005028 <_fflush_r+0x38>
40005014:	01c12083          	lw	ra,28(sp)
40005018:	00000513          	li	a0,0
4000501c:	01812403          	lw	s0,24(sp)
40005020:	02010113          	addi	sp,sp,32
40005024:	00008067          	ret
40005028:	00040513          	mv	a0,s0
4000502c:	01c12083          	lw	ra,28(sp)
40005030:	01812403          	lw	s0,24(sp)
40005034:	02010113          	addi	sp,sp,32
40005038:	d25ff06f          	j	40004d5c <__sflush_r>
4000503c:	00b12623          	sw	a1,12(sp)
40005040:	380000ef          	jal	ra,400053c0 <__sinit>
40005044:	00c12583          	lw	a1,12(sp)
40005048:	fc5ff06f          	j	4000500c <_fflush_r+0x1c>

4000504c <fflush>:
4000504c:	00050593          	mv	a1,a0
40005050:	00050863          	beqz	a0,40005060 <fflush+0x14>
40005054:	4000e7b7          	lui	a5,0x4000e
40005058:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
4000505c:	f95ff06f          	j	40004ff0 <_fflush_r>
40005060:	4000e7b7          	lui	a5,0x4000e
40005064:	5807a503          	lw	a0,1408(a5) # 4000e580 <_global_impure_ptr>
40005068:	400055b7          	lui	a1,0x40005
4000506c:	ff058593          	addi	a1,a1,-16 # 40004ff0 <_fflush_r>
40005070:	0810006f          	j	400058f0 <_fwalk_reent>

40005074 <__fp_unlock>:
40005074:	00000513          	li	a0,0
40005078:	00008067          	ret

4000507c <_cleanup_r>:
4000507c:	400085b7          	lui	a1,0x40008
40005080:	47858593          	addi	a1,a1,1144 # 40008478 <_fclose_r>
40005084:	06d0006f          	j	400058f0 <_fwalk_reent>

40005088 <__sinit.part.1>:
40005088:	fe010113          	addi	sp,sp,-32
4000508c:	400057b7          	lui	a5,0x40005
40005090:	00112e23          	sw	ra,28(sp)
40005094:	00812c23          	sw	s0,24(sp)
40005098:	00912a23          	sw	s1,20(sp)
4000509c:	00452403          	lw	s0,4(a0)
400050a0:	01212823          	sw	s2,16(sp)
400050a4:	01312623          	sw	s3,12(sp)
400050a8:	01412423          	sw	s4,8(sp)
400050ac:	01512223          	sw	s5,4(sp)
400050b0:	01612023          	sw	s6,0(sp)
400050b4:	07c78793          	addi	a5,a5,124 # 4000507c <_cleanup_r>
400050b8:	02f52e23          	sw	a5,60(a0)
400050bc:	2ec50713          	addi	a4,a0,748
400050c0:	00300793          	li	a5,3
400050c4:	2ee52423          	sw	a4,744(a0)
400050c8:	2ef52223          	sw	a5,740(a0)
400050cc:	2e052023          	sw	zero,736(a0)
400050d0:	00400793          	li	a5,4
400050d4:	00050913          	mv	s2,a0
400050d8:	00f41623          	sh	a5,12(s0)
400050dc:	00800613          	li	a2,8
400050e0:	00000593          	li	a1,0
400050e4:	00042023          	sw	zero,0(s0)
400050e8:	00042223          	sw	zero,4(s0)
400050ec:	00042423          	sw	zero,8(s0)
400050f0:	06042223          	sw	zero,100(s0)
400050f4:	00041723          	sh	zero,14(s0)
400050f8:	00042823          	sw	zero,16(s0)
400050fc:	00042a23          	sw	zero,20(s0)
40005100:	00042c23          	sw	zero,24(s0)
40005104:	05c40513          	addi	a0,s0,92
40005108:	42d000ef          	jal	ra,40005d34 <memset>
4000510c:	40007b37          	lui	s6,0x40007
40005110:	00892483          	lw	s1,8(s2)
40005114:	40007ab7          	lui	s5,0x40007
40005118:	40007a37          	lui	s4,0x40007
4000511c:	400079b7          	lui	s3,0x40007
40005120:	010b0b13          	addi	s6,s6,16 # 40007010 <__sread>
40005124:	074a8a93          	addi	s5,s5,116 # 40007074 <__swrite>
40005128:	0f8a0a13          	addi	s4,s4,248 # 400070f8 <__sseek>
4000512c:	16c98993          	addi	s3,s3,364 # 4000716c <__sclose>
40005130:	03642023          	sw	s6,32(s0)
40005134:	03542223          	sw	s5,36(s0)
40005138:	03442423          	sw	s4,40(s0)
4000513c:	03342623          	sw	s3,44(s0)
40005140:	00842e23          	sw	s0,28(s0)
40005144:	00900793          	li	a5,9
40005148:	00f49623          	sh	a5,12(s1)
4000514c:	00100793          	li	a5,1
40005150:	00f49723          	sh	a5,14(s1)
40005154:	00800613          	li	a2,8
40005158:	00000593          	li	a1,0
4000515c:	0004a023          	sw	zero,0(s1)
40005160:	0004a223          	sw	zero,4(s1)
40005164:	0004a423          	sw	zero,8(s1)
40005168:	0604a223          	sw	zero,100(s1)
4000516c:	0004a823          	sw	zero,16(s1)
40005170:	0004aa23          	sw	zero,20(s1)
40005174:	0004ac23          	sw	zero,24(s1)
40005178:	05c48513          	addi	a0,s1,92
4000517c:	3b9000ef          	jal	ra,40005d34 <memset>
40005180:	00c92403          	lw	s0,12(s2)
40005184:	01200793          	li	a5,18
40005188:	0364a023          	sw	s6,32(s1)
4000518c:	0354a223          	sw	s5,36(s1)
40005190:	0344a423          	sw	s4,40(s1)
40005194:	0334a623          	sw	s3,44(s1)
40005198:	0094ae23          	sw	s1,28(s1)
4000519c:	00f41623          	sh	a5,12(s0)
400051a0:	00200793          	li	a5,2
400051a4:	00f41723          	sh	a5,14(s0)
400051a8:	00042023          	sw	zero,0(s0)
400051ac:	00042223          	sw	zero,4(s0)
400051b0:	00042423          	sw	zero,8(s0)
400051b4:	06042223          	sw	zero,100(s0)
400051b8:	00042823          	sw	zero,16(s0)
400051bc:	00042a23          	sw	zero,20(s0)
400051c0:	00042c23          	sw	zero,24(s0)
400051c4:	05c40513          	addi	a0,s0,92
400051c8:	00800613          	li	a2,8
400051cc:	00000593          	li	a1,0
400051d0:	365000ef          	jal	ra,40005d34 <memset>
400051d4:	01c12083          	lw	ra,28(sp)
400051d8:	03642023          	sw	s6,32(s0)
400051dc:	03542223          	sw	s5,36(s0)
400051e0:	03442423          	sw	s4,40(s0)
400051e4:	03342623          	sw	s3,44(s0)
400051e8:	00842e23          	sw	s0,28(s0)
400051ec:	00100793          	li	a5,1
400051f0:	02f92c23          	sw	a5,56(s2)
400051f4:	01812403          	lw	s0,24(sp)
400051f8:	01412483          	lw	s1,20(sp)
400051fc:	01012903          	lw	s2,16(sp)
40005200:	00c12983          	lw	s3,12(sp)
40005204:	00812a03          	lw	s4,8(sp)
40005208:	00412a83          	lw	s5,4(sp)
4000520c:	00012b03          	lw	s6,0(sp)
40005210:	02010113          	addi	sp,sp,32
40005214:	00008067          	ret

40005218 <__fp_lock>:
40005218:	00000513          	li	a0,0
4000521c:	00008067          	ret

40005220 <__sfmoreglue>:
40005220:	ff010113          	addi	sp,sp,-16
40005224:	01212023          	sw	s2,0(sp)
40005228:	00058913          	mv	s2,a1
4000522c:	00812423          	sw	s0,8(sp)
40005230:	06800593          	li	a1,104
40005234:	00050413          	mv	s0,a0
40005238:	fff90513          	addi	a0,s2,-1
4000523c:	00112623          	sw	ra,12(sp)
40005240:	00912223          	sw	s1,4(sp)
40005244:	46d070ef          	jal	ra,4000ceb0 <__mulsi3>
40005248:	07450593          	addi	a1,a0,116
4000524c:	00050493          	mv	s1,a0
40005250:	00040513          	mv	a0,s0
40005254:	abdfb0ef          	jal	ra,40000d10 <_malloc_r>
40005258:	00050413          	mv	s0,a0
4000525c:	02050063          	beqz	a0,4000527c <__sfmoreglue+0x5c>
40005260:	00c50513          	addi	a0,a0,12
40005264:	00042023          	sw	zero,0(s0)
40005268:	01242223          	sw	s2,4(s0)
4000526c:	00a42423          	sw	a0,8(s0)
40005270:	06848613          	addi	a2,s1,104
40005274:	00000593          	li	a1,0
40005278:	2bd000ef          	jal	ra,40005d34 <memset>
4000527c:	00c12083          	lw	ra,12(sp)
40005280:	00040513          	mv	a0,s0
40005284:	00412483          	lw	s1,4(sp)
40005288:	00812403          	lw	s0,8(sp)
4000528c:	00012903          	lw	s2,0(sp)
40005290:	01010113          	addi	sp,sp,16
40005294:	00008067          	ret

40005298 <__sfp>:
40005298:	fe010113          	addi	sp,sp,-32
4000529c:	4000e7b7          	lui	a5,0x4000e
400052a0:	01212823          	sw	s2,16(sp)
400052a4:	5807a903          	lw	s2,1408(a5) # 4000e580 <_global_impure_ptr>
400052a8:	01312623          	sw	s3,12(sp)
400052ac:	00112e23          	sw	ra,28(sp)
400052b0:	03892783          	lw	a5,56(s2)
400052b4:	00812c23          	sw	s0,24(sp)
400052b8:	00912a23          	sw	s1,20(sp)
400052bc:	01412423          	sw	s4,8(sp)
400052c0:	00050993          	mv	s3,a0
400052c4:	0a078c63          	beqz	a5,4000537c <__sfp+0xe4>
400052c8:	2e090913          	addi	s2,s2,736
400052cc:	fff00493          	li	s1,-1
400052d0:	00400a13          	li	s4,4
400052d4:	00492783          	lw	a5,4(s2)
400052d8:	00892403          	lw	s0,8(s2)
400052dc:	fff78793          	addi	a5,a5,-1
400052e0:	0007da63          	bgez	a5,400052f4 <__sfp+0x5c>
400052e4:	0880006f          	j	4000536c <__sfp+0xd4>
400052e8:	fff78793          	addi	a5,a5,-1
400052ec:	06840413          	addi	s0,s0,104
400052f0:	06978e63          	beq	a5,s1,4000536c <__sfp+0xd4>
400052f4:	00c41703          	lh	a4,12(s0)
400052f8:	fe0718e3          	bnez	a4,400052e8 <__sfp+0x50>
400052fc:	fff00793          	li	a5,-1
40005300:	00f41723          	sh	a5,14(s0)
40005304:	00100793          	li	a5,1
40005308:	00f41623          	sh	a5,12(s0)
4000530c:	06042223          	sw	zero,100(s0)
40005310:	00042023          	sw	zero,0(s0)
40005314:	00042423          	sw	zero,8(s0)
40005318:	00042223          	sw	zero,4(s0)
4000531c:	00042823          	sw	zero,16(s0)
40005320:	00042a23          	sw	zero,20(s0)
40005324:	00042c23          	sw	zero,24(s0)
40005328:	00800613          	li	a2,8
4000532c:	00000593          	li	a1,0
40005330:	05c40513          	addi	a0,s0,92
40005334:	201000ef          	jal	ra,40005d34 <memset>
40005338:	02042823          	sw	zero,48(s0)
4000533c:	02042a23          	sw	zero,52(s0)
40005340:	04042223          	sw	zero,68(s0)
40005344:	04042423          	sw	zero,72(s0)
40005348:	01c12083          	lw	ra,28(sp)
4000534c:	00040513          	mv	a0,s0
40005350:	01412483          	lw	s1,20(sp)
40005354:	01812403          	lw	s0,24(sp)
40005358:	01012903          	lw	s2,16(sp)
4000535c:	00c12983          	lw	s3,12(sp)
40005360:	00812a03          	lw	s4,8(sp)
40005364:	02010113          	addi	sp,sp,32
40005368:	00008067          	ret
4000536c:	00092503          	lw	a0,0(s2)
40005370:	00050c63          	beqz	a0,40005388 <__sfp+0xf0>
40005374:	00050913          	mv	s2,a0
40005378:	f5dff06f          	j	400052d4 <__sfp+0x3c>
4000537c:	00090513          	mv	a0,s2
40005380:	d09ff0ef          	jal	ra,40005088 <__sinit.part.1>
40005384:	f45ff06f          	j	400052c8 <__sfp+0x30>
40005388:	000a0593          	mv	a1,s4
4000538c:	00098513          	mv	a0,s3
40005390:	e91ff0ef          	jal	ra,40005220 <__sfmoreglue>
40005394:	00a92023          	sw	a0,0(s2)
40005398:	fc051ee3          	bnez	a0,40005374 <__sfp+0xdc>
4000539c:	00c00793          	li	a5,12
400053a0:	00f9a023          	sw	a5,0(s3)
400053a4:	00000413          	li	s0,0
400053a8:	fa1ff06f          	j	40005348 <__sfp+0xb0>

400053ac <_cleanup>:
400053ac:	4000e7b7          	lui	a5,0x4000e
400053b0:	5807a503          	lw	a0,1408(a5) # 4000e580 <_global_impure_ptr>
400053b4:	400085b7          	lui	a1,0x40008
400053b8:	47858593          	addi	a1,a1,1144 # 40008478 <_fclose_r>
400053bc:	5340006f          	j	400058f0 <_fwalk_reent>

400053c0 <__sinit>:
400053c0:	03852783          	lw	a5,56(a0)
400053c4:	00078463          	beqz	a5,400053cc <__sinit+0xc>
400053c8:	00008067          	ret
400053cc:	cbdff06f          	j	40005088 <__sinit.part.1>

400053d0 <__sfp_lock_acquire>:
400053d0:	00008067          	ret

400053d4 <__sfp_lock_release>:
400053d4:	00008067          	ret

400053d8 <__sinit_lock_acquire>:
400053d8:	00008067          	ret

400053dc <__sinit_lock_release>:
400053dc:	00008067          	ret

400053e0 <__fp_lock_all>:
400053e0:	4000e7b7          	lui	a5,0x4000e
400053e4:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
400053e8:	400055b7          	lui	a1,0x40005
400053ec:	21858593          	addi	a1,a1,536 # 40005218 <__fp_lock>
400053f0:	4500006f          	j	40005840 <_fwalk>

400053f4 <__fp_unlock_all>:
400053f4:	4000e7b7          	lui	a5,0x4000e
400053f8:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
400053fc:	400055b7          	lui	a1,0x40005
40005400:	07458593          	addi	a1,a1,116 # 40005074 <__fp_unlock>
40005404:	43c0006f          	j	40005840 <_fwalk>

40005408 <_malloc_trim_r>:
40005408:	fe010113          	addi	sp,sp,-32
4000540c:	01212823          	sw	s2,16(sp)
40005410:	4000e937          	lui	s2,0x4000e
40005414:	00812c23          	sw	s0,24(sp)
40005418:	00912a23          	sw	s1,20(sp)
4000541c:	01312623          	sw	s3,12(sp)
40005420:	01412423          	sw	s4,8(sp)
40005424:	00112e23          	sw	ra,28(sp)
40005428:	00058a13          	mv	s4,a1
4000542c:	00050993          	mv	s3,a0
40005430:	cd090913          	addi	s2,s2,-816 # 4000dcd0 <_etext>
40005434:	944fc0ef          	jal	ra,40001578 <__malloc_lock>
40005438:	00892703          	lw	a4,8(s2)
4000543c:	000017b7          	lui	a5,0x1
40005440:	fef78413          	addi	s0,a5,-17 # fef <_stack_start+0x637>
40005444:	00472483          	lw	s1,4(a4)
40005448:	41440433          	sub	s0,s0,s4
4000544c:	ffc4f493          	andi	s1,s1,-4
40005450:	00940433          	add	s0,s0,s1
40005454:	00c45413          	srli	s0,s0,0xc
40005458:	fff40413          	addi	s0,s0,-1
4000545c:	00c41413          	slli	s0,s0,0xc
40005460:	00f44e63          	blt	s0,a5,4000547c <_malloc_trim_r+0x74>
40005464:	00000593          	li	a1,0
40005468:	00098513          	mv	a0,s3
4000546c:	9acfc0ef          	jal	ra,40001618 <_sbrk_r>
40005470:	00892783          	lw	a5,8(s2)
40005474:	009787b3          	add	a5,a5,s1
40005478:	02f50863          	beq	a0,a5,400054a8 <_malloc_trim_r+0xa0>
4000547c:	00098513          	mv	a0,s3
40005480:	8fcfc0ef          	jal	ra,4000157c <__malloc_unlock>
40005484:	01c12083          	lw	ra,28(sp)
40005488:	00000513          	li	a0,0
4000548c:	01812403          	lw	s0,24(sp)
40005490:	01412483          	lw	s1,20(sp)
40005494:	01012903          	lw	s2,16(sp)
40005498:	00c12983          	lw	s3,12(sp)
4000549c:	00812a03          	lw	s4,8(sp)
400054a0:	02010113          	addi	sp,sp,32
400054a4:	00008067          	ret
400054a8:	408005b3          	neg	a1,s0
400054ac:	00098513          	mv	a0,s3
400054b0:	968fc0ef          	jal	ra,40001618 <_sbrk_r>
400054b4:	fff00793          	li	a5,-1
400054b8:	04f50863          	beq	a0,a5,40005508 <_malloc_trim_r+0x100>
400054bc:	40011737          	lui	a4,0x40011
400054c0:	db072783          	lw	a5,-592(a4) # 40010db0 <__malloc_current_mallinfo>
400054c4:	00892683          	lw	a3,8(s2)
400054c8:	408484b3          	sub	s1,s1,s0
400054cc:	0014e493          	ori	s1,s1,1
400054d0:	40878433          	sub	s0,a5,s0
400054d4:	00098513          	mv	a0,s3
400054d8:	0096a223          	sw	s1,4(a3)
400054dc:	da872823          	sw	s0,-592(a4)
400054e0:	89cfc0ef          	jal	ra,4000157c <__malloc_unlock>
400054e4:	01c12083          	lw	ra,28(sp)
400054e8:	00100513          	li	a0,1
400054ec:	01812403          	lw	s0,24(sp)
400054f0:	01412483          	lw	s1,20(sp)
400054f4:	01012903          	lw	s2,16(sp)
400054f8:	00c12983          	lw	s3,12(sp)
400054fc:	00812a03          	lw	s4,8(sp)
40005500:	02010113          	addi	sp,sp,32
40005504:	00008067          	ret
40005508:	00000593          	li	a1,0
4000550c:	00098513          	mv	a0,s3
40005510:	908fc0ef          	jal	ra,40001618 <_sbrk_r>
40005514:	00892703          	lw	a4,8(s2)
40005518:	00f00693          	li	a3,15
4000551c:	40e507b3          	sub	a5,a0,a4
40005520:	f4f6dee3          	ble	a5,a3,4000547c <_malloc_trim_r+0x74>
40005524:	4000e6b7          	lui	a3,0x4000e
40005528:	5786a683          	lw	a3,1400(a3) # 4000e578 <__malloc_sbrk_base>
4000552c:	0017e793          	ori	a5,a5,1
40005530:	00f72223          	sw	a5,4(a4)
40005534:	40d50533          	sub	a0,a0,a3
40005538:	400116b7          	lui	a3,0x40011
4000553c:	daa6a823          	sw	a0,-592(a3) # 40010db0 <__malloc_current_mallinfo>
40005540:	f3dff06f          	j	4000547c <_malloc_trim_r+0x74>

40005544 <_free_r>:
40005544:	0e058e63          	beqz	a1,40005640 <_free_r+0xfc>
40005548:	ff010113          	addi	sp,sp,-16
4000554c:	00812423          	sw	s0,8(sp)
40005550:	00912223          	sw	s1,4(sp)
40005554:	00058413          	mv	s0,a1
40005558:	00050493          	mv	s1,a0
4000555c:	00112623          	sw	ra,12(sp)
40005560:	818fc0ef          	jal	ra,40001578 <__malloc_lock>
40005564:	ffc42503          	lw	a0,-4(s0)
40005568:	ff840693          	addi	a3,s0,-8
4000556c:	4000e5b7          	lui	a1,0x4000e
40005570:	ffe57793          	andi	a5,a0,-2
40005574:	00f68633          	add	a2,a3,a5
40005578:	cd058593          	addi	a1,a1,-816 # 4000dcd0 <_etext>
4000557c:	00462703          	lw	a4,4(a2)
40005580:	0085a803          	lw	a6,8(a1)
40005584:	ffc77713          	andi	a4,a4,-4
40005588:	15060e63          	beq	a2,a6,400056e4 <_free_r+0x1a0>
4000558c:	00e62223          	sw	a4,4(a2)
40005590:	00157513          	andi	a0,a0,1
40005594:	02051663          	bnez	a0,400055c0 <_free_r+0x7c>
40005598:	ff842883          	lw	a7,-8(s0)
4000559c:	4000e537          	lui	a0,0x4000e
400055a0:	cd850513          	addi	a0,a0,-808 # 4000dcd8 <_etext+0x8>
400055a4:	411686b3          	sub	a3,a3,a7
400055a8:	0086a803          	lw	a6,8(a3)
400055ac:	011787b3          	add	a5,a5,a7
400055b0:	18a80863          	beq	a6,a0,40005740 <_free_r+0x1fc>
400055b4:	00c6a503          	lw	a0,12(a3)
400055b8:	00a82623          	sw	a0,12(a6)
400055bc:	01052423          	sw	a6,8(a0)
400055c0:	00e60533          	add	a0,a2,a4
400055c4:	00452503          	lw	a0,4(a0)
400055c8:	00157513          	andi	a0,a0,1
400055cc:	0e050263          	beqz	a0,400056b0 <_free_r+0x16c>
400055d0:	0017e713          	ori	a4,a5,1
400055d4:	00e6a223          	sw	a4,4(a3)
400055d8:	00f68733          	add	a4,a3,a5
400055dc:	00f72023          	sw	a5,0(a4)
400055e0:	1ff00713          	li	a4,511
400055e4:	06f76063          	bltu	a4,a5,40005644 <_free_r+0x100>
400055e8:	0037d793          	srli	a5,a5,0x3
400055ec:	00178713          	addi	a4,a5,1
400055f0:	00371713          	slli	a4,a4,0x3
400055f4:	0045a803          	lw	a6,4(a1)
400055f8:	00e58733          	add	a4,a1,a4
400055fc:	00072503          	lw	a0,0(a4)
40005600:	4027d613          	srai	a2,a5,0x2
40005604:	00100793          	li	a5,1
40005608:	00c797b3          	sll	a5,a5,a2
4000560c:	0107e7b3          	or	a5,a5,a6
40005610:	ff870613          	addi	a2,a4,-8
40005614:	00c6a623          	sw	a2,12(a3)
40005618:	00a6a423          	sw	a0,8(a3)
4000561c:	00f5a223          	sw	a5,4(a1)
40005620:	00d72023          	sw	a3,0(a4)
40005624:	00d52623          	sw	a3,12(a0)
40005628:	00048513          	mv	a0,s1
4000562c:	00c12083          	lw	ra,12(sp)
40005630:	00812403          	lw	s0,8(sp)
40005634:	00412483          	lw	s1,4(sp)
40005638:	01010113          	addi	sp,sp,16
4000563c:	f41fb06f          	j	4000157c <__malloc_unlock>
40005640:	00008067          	ret
40005644:	0097d713          	srli	a4,a5,0x9
40005648:	00400613          	li	a2,4
4000564c:	12e66663          	bltu	a2,a4,40005778 <_free_r+0x234>
40005650:	0067d713          	srli	a4,a5,0x6
40005654:	03970513          	addi	a0,a4,57
40005658:	03870613          	addi	a2,a4,56
4000565c:	00351513          	slli	a0,a0,0x3
40005660:	00a58533          	add	a0,a1,a0
40005664:	00052703          	lw	a4,0(a0)
40005668:	ff850513          	addi	a0,a0,-8
4000566c:	12e50263          	beq	a0,a4,40005790 <_free_r+0x24c>
40005670:	00472603          	lw	a2,4(a4)
40005674:	ffc67613          	andi	a2,a2,-4
40005678:	0cc7f063          	bleu	a2,a5,40005738 <_free_r+0x1f4>
4000567c:	00872703          	lw	a4,8(a4)
40005680:	fee518e3          	bne	a0,a4,40005670 <_free_r+0x12c>
40005684:	00c52783          	lw	a5,12(a0)
40005688:	00a6a423          	sw	a0,8(a3)
4000568c:	00f6a623          	sw	a5,12(a3)
40005690:	00d7a423          	sw	a3,8(a5)
40005694:	00d52623          	sw	a3,12(a0)
40005698:	00c12083          	lw	ra,12(sp)
4000569c:	00048513          	mv	a0,s1
400056a0:	00812403          	lw	s0,8(sp)
400056a4:	00412483          	lw	s1,4(sp)
400056a8:	01010113          	addi	sp,sp,16
400056ac:	ed1fb06f          	j	4000157c <__malloc_unlock>
400056b0:	00862503          	lw	a0,8(a2)
400056b4:	4000e837          	lui	a6,0x4000e
400056b8:	cd880813          	addi	a6,a6,-808 # 4000dcd8 <_etext+0x8>
400056bc:	00e787b3          	add	a5,a5,a4
400056c0:	0f050863          	beq	a0,a6,400057b0 <_free_r+0x26c>
400056c4:	00c62803          	lw	a6,12(a2)
400056c8:	0017e613          	ori	a2,a5,1
400056cc:	00f68733          	add	a4,a3,a5
400056d0:	01052623          	sw	a6,12(a0)
400056d4:	00a82423          	sw	a0,8(a6)
400056d8:	00c6a223          	sw	a2,4(a3)
400056dc:	00f72023          	sw	a5,0(a4)
400056e0:	f01ff06f          	j	400055e0 <_free_r+0x9c>
400056e4:	00157513          	andi	a0,a0,1
400056e8:	00e787b3          	add	a5,a5,a4
400056ec:	02051063          	bnez	a0,4000570c <_free_r+0x1c8>
400056f0:	ff842503          	lw	a0,-8(s0)
400056f4:	40a686b3          	sub	a3,a3,a0
400056f8:	00c6a703          	lw	a4,12(a3)
400056fc:	0086a603          	lw	a2,8(a3)
40005700:	00a787b3          	add	a5,a5,a0
40005704:	00e62623          	sw	a4,12(a2)
40005708:	00c72423          	sw	a2,8(a4)
4000570c:	4000e737          	lui	a4,0x4000e
40005710:	0017e613          	ori	a2,a5,1
40005714:	57c72703          	lw	a4,1404(a4) # 4000e57c <__malloc_trim_threshold>
40005718:	00c6a223          	sw	a2,4(a3)
4000571c:	00d5a423          	sw	a3,8(a1)
40005720:	f0e7e4e3          	bltu	a5,a4,40005628 <_free_r+0xe4>
40005724:	4000e7b7          	lui	a5,0x4000e
40005728:	5c47a583          	lw	a1,1476(a5) # 4000e5c4 <__malloc_top_pad>
4000572c:	00048513          	mv	a0,s1
40005730:	cd9ff0ef          	jal	ra,40005408 <_malloc_trim_r>
40005734:	ef5ff06f          	j	40005628 <_free_r+0xe4>
40005738:	00070513          	mv	a0,a4
4000573c:	f49ff06f          	j	40005684 <_free_r+0x140>
40005740:	00e605b3          	add	a1,a2,a4
40005744:	0045a583          	lw	a1,4(a1)
40005748:	0015f593          	andi	a1,a1,1
4000574c:	0e059263          	bnez	a1,40005830 <_free_r+0x2ec>
40005750:	00862583          	lw	a1,8(a2)
40005754:	00c62603          	lw	a2,12(a2)
40005758:	00f707b3          	add	a5,a4,a5
4000575c:	0017e713          	ori	a4,a5,1
40005760:	00c5a623          	sw	a2,12(a1)
40005764:	00b62423          	sw	a1,8(a2)
40005768:	00e6a223          	sw	a4,4(a3)
4000576c:	00f686b3          	add	a3,a3,a5
40005770:	00f6a023          	sw	a5,0(a3)
40005774:	eb5ff06f          	j	40005628 <_free_r+0xe4>
40005778:	01400613          	li	a2,20
4000577c:	04e66c63          	bltu	a2,a4,400057d4 <_free_r+0x290>
40005780:	05c70513          	addi	a0,a4,92
40005784:	05b70613          	addi	a2,a4,91
40005788:	00351513          	slli	a0,a0,0x3
4000578c:	ed5ff06f          	j	40005660 <_free_r+0x11c>
40005790:	0045a803          	lw	a6,4(a1)
40005794:	40265713          	srai	a4,a2,0x2
40005798:	00100793          	li	a5,1
4000579c:	00e797b3          	sll	a5,a5,a4
400057a0:	0107e7b3          	or	a5,a5,a6
400057a4:	00f5a223          	sw	a5,4(a1)
400057a8:	00050793          	mv	a5,a0
400057ac:	eddff06f          	j	40005688 <_free_r+0x144>
400057b0:	00d5aa23          	sw	a3,20(a1)
400057b4:	00d5a823          	sw	a3,16(a1)
400057b8:	0017e713          	ori	a4,a5,1
400057bc:	00a6a623          	sw	a0,12(a3)
400057c0:	00a6a423          	sw	a0,8(a3)
400057c4:	00e6a223          	sw	a4,4(a3)
400057c8:	00f686b3          	add	a3,a3,a5
400057cc:	00f6a023          	sw	a5,0(a3)
400057d0:	e59ff06f          	j	40005628 <_free_r+0xe4>
400057d4:	05400613          	li	a2,84
400057d8:	00e66c63          	bltu	a2,a4,400057f0 <_free_r+0x2ac>
400057dc:	00c7d713          	srli	a4,a5,0xc
400057e0:	06f70513          	addi	a0,a4,111
400057e4:	06e70613          	addi	a2,a4,110
400057e8:	00351513          	slli	a0,a0,0x3
400057ec:	e75ff06f          	j	40005660 <_free_r+0x11c>
400057f0:	15400613          	li	a2,340
400057f4:	00e66c63          	bltu	a2,a4,4000580c <_free_r+0x2c8>
400057f8:	00f7d713          	srli	a4,a5,0xf
400057fc:	07870513          	addi	a0,a4,120
40005800:	07770613          	addi	a2,a4,119
40005804:	00351513          	slli	a0,a0,0x3
40005808:	e59ff06f          	j	40005660 <_free_r+0x11c>
4000580c:	55400813          	li	a6,1364
40005810:	3f800513          	li	a0,1016
40005814:	07e00613          	li	a2,126
40005818:	e4e864e3          	bltu	a6,a4,40005660 <_free_r+0x11c>
4000581c:	0127d713          	srli	a4,a5,0x12
40005820:	07d70513          	addi	a0,a4,125
40005824:	07c70613          	addi	a2,a4,124
40005828:	00351513          	slli	a0,a0,0x3
4000582c:	e35ff06f          	j	40005660 <_free_r+0x11c>
40005830:	0017e713          	ori	a4,a5,1
40005834:	00e6a223          	sw	a4,4(a3)
40005838:	00f62023          	sw	a5,0(a2)
4000583c:	dedff06f          	j	40005628 <_free_r+0xe4>

40005840 <_fwalk>:
40005840:	fe010113          	addi	sp,sp,-32
40005844:	01512223          	sw	s5,4(sp)
40005848:	00112e23          	sw	ra,28(sp)
4000584c:	00812c23          	sw	s0,24(sp)
40005850:	00912a23          	sw	s1,20(sp)
40005854:	01212823          	sw	s2,16(sp)
40005858:	01312623          	sw	s3,12(sp)
4000585c:	01412423          	sw	s4,8(sp)
40005860:	01612023          	sw	s6,0(sp)
40005864:	2e050a93          	addi	s5,a0,736
40005868:	080a8063          	beqz	s5,400058e8 <_fwalk+0xa8>
4000586c:	00058b13          	mv	s6,a1
40005870:	00000a13          	li	s4,0
40005874:	00100993          	li	s3,1
40005878:	fff00913          	li	s2,-1
4000587c:	004aa483          	lw	s1,4(s5)
40005880:	008aa403          	lw	s0,8(s5)
40005884:	fff48493          	addi	s1,s1,-1
40005888:	0204c663          	bltz	s1,400058b4 <_fwalk+0x74>
4000588c:	00c45783          	lhu	a5,12(s0)
40005890:	fff48493          	addi	s1,s1,-1
40005894:	00f9fc63          	bleu	a5,s3,400058ac <_fwalk+0x6c>
40005898:	00e41783          	lh	a5,14(s0)
4000589c:	00040513          	mv	a0,s0
400058a0:	01278663          	beq	a5,s2,400058ac <_fwalk+0x6c>
400058a4:	000b00e7          	jalr	s6
400058a8:	00aa6a33          	or	s4,s4,a0
400058ac:	06840413          	addi	s0,s0,104
400058b0:	fd249ee3          	bne	s1,s2,4000588c <_fwalk+0x4c>
400058b4:	000aaa83          	lw	s5,0(s5)
400058b8:	fc0a92e3          	bnez	s5,4000587c <_fwalk+0x3c>
400058bc:	01c12083          	lw	ra,28(sp)
400058c0:	000a0513          	mv	a0,s4
400058c4:	01812403          	lw	s0,24(sp)
400058c8:	01412483          	lw	s1,20(sp)
400058cc:	01012903          	lw	s2,16(sp)
400058d0:	00c12983          	lw	s3,12(sp)
400058d4:	00812a03          	lw	s4,8(sp)
400058d8:	00412a83          	lw	s5,4(sp)
400058dc:	00012b03          	lw	s6,0(sp)
400058e0:	02010113          	addi	sp,sp,32
400058e4:	00008067          	ret
400058e8:	00000a13          	li	s4,0
400058ec:	fd1ff06f          	j	400058bc <_fwalk+0x7c>

400058f0 <_fwalk_reent>:
400058f0:	fd010113          	addi	sp,sp,-48
400058f4:	01612823          	sw	s6,16(sp)
400058f8:	02112623          	sw	ra,44(sp)
400058fc:	02812423          	sw	s0,40(sp)
40005900:	02912223          	sw	s1,36(sp)
40005904:	03212023          	sw	s2,32(sp)
40005908:	01312e23          	sw	s3,28(sp)
4000590c:	01412c23          	sw	s4,24(sp)
40005910:	01512a23          	sw	s5,20(sp)
40005914:	01712623          	sw	s7,12(sp)
40005918:	2e050b13          	addi	s6,a0,736
4000591c:	080b0663          	beqz	s6,400059a8 <_fwalk_reent+0xb8>
40005920:	00058b93          	mv	s7,a1
40005924:	00050a93          	mv	s5,a0
40005928:	00000a13          	li	s4,0
4000592c:	00100993          	li	s3,1
40005930:	fff00913          	li	s2,-1
40005934:	004b2483          	lw	s1,4(s6)
40005938:	008b2403          	lw	s0,8(s6)
4000593c:	fff48493          	addi	s1,s1,-1
40005940:	0204c863          	bltz	s1,40005970 <_fwalk_reent+0x80>
40005944:	00c45783          	lhu	a5,12(s0)
40005948:	fff48493          	addi	s1,s1,-1
4000594c:	00f9fe63          	bleu	a5,s3,40005968 <_fwalk_reent+0x78>
40005950:	00e41783          	lh	a5,14(s0)
40005954:	00040593          	mv	a1,s0
40005958:	000a8513          	mv	a0,s5
4000595c:	01278663          	beq	a5,s2,40005968 <_fwalk_reent+0x78>
40005960:	000b80e7          	jalr	s7
40005964:	00aa6a33          	or	s4,s4,a0
40005968:	06840413          	addi	s0,s0,104
4000596c:	fd249ce3          	bne	s1,s2,40005944 <_fwalk_reent+0x54>
40005970:	000b2b03          	lw	s6,0(s6)
40005974:	fc0b10e3          	bnez	s6,40005934 <_fwalk_reent+0x44>
40005978:	02c12083          	lw	ra,44(sp)
4000597c:	000a0513          	mv	a0,s4
40005980:	02812403          	lw	s0,40(sp)
40005984:	02412483          	lw	s1,36(sp)
40005988:	02012903          	lw	s2,32(sp)
4000598c:	01c12983          	lw	s3,28(sp)
40005990:	01812a03          	lw	s4,24(sp)
40005994:	01412a83          	lw	s5,20(sp)
40005998:	01012b03          	lw	s6,16(sp)
4000599c:	00c12b83          	lw	s7,12(sp)
400059a0:	03010113          	addi	sp,sp,48
400059a4:	00008067          	ret
400059a8:	00000a13          	li	s4,0
400059ac:	fcdff06f          	j	40005978 <_fwalk_reent+0x88>

400059b0 <_setlocale_r>:
400059b0:	ff010113          	addi	sp,sp,-16
400059b4:	00912223          	sw	s1,4(sp)
400059b8:	00112623          	sw	ra,12(sp)
400059bc:	00812423          	sw	s0,8(sp)
400059c0:	4000d4b7          	lui	s1,0x4000d
400059c4:	02060063          	beqz	a2,400059e4 <_setlocale_r+0x34>
400059c8:	4000d5b7          	lui	a1,0x4000d
400059cc:	77c58593          	addi	a1,a1,1916 # 4000d77c <zeroes.4139+0x68>
400059d0:	00060513          	mv	a0,a2
400059d4:	00060413          	mv	s0,a2
400059d8:	ca1fb0ef          	jal	ra,40001678 <strcmp>
400059dc:	4000d4b7          	lui	s1,0x4000d
400059e0:	00051e63          	bnez	a0,400059fc <_setlocale_r+0x4c>
400059e4:	77848513          	addi	a0,s1,1912 # 4000d778 <zeroes.4139+0x64>
400059e8:	00c12083          	lw	ra,12(sp)
400059ec:	00812403          	lw	s0,8(sp)
400059f0:	00412483          	lw	s1,4(sp)
400059f4:	01010113          	addi	sp,sp,16
400059f8:	00008067          	ret
400059fc:	77848593          	addi	a1,s1,1912
40005a00:	00040513          	mv	a0,s0
40005a04:	c75fb0ef          	jal	ra,40001678 <strcmp>
40005a08:	fc050ee3          	beqz	a0,400059e4 <_setlocale_r+0x34>
40005a0c:	4000d5b7          	lui	a1,0x4000d
40005a10:	2b858593          	addi	a1,a1,696 # 4000d2b8 <__clzsi2+0x330>
40005a14:	00040513          	mv	a0,s0
40005a18:	c61fb0ef          	jal	ra,40001678 <strcmp>
40005a1c:	fc0504e3          	beqz	a0,400059e4 <_setlocale_r+0x34>
40005a20:	00000513          	li	a0,0
40005a24:	fc5ff06f          	j	400059e8 <_setlocale_r+0x38>

40005a28 <__locale_charset>:
40005a28:	4000e537          	lui	a0,0x4000e
40005a2c:	50050513          	addi	a0,a0,1280 # 4000e500 <lc_ctype_charset>
40005a30:	00008067          	ret

40005a34 <__locale_mb_cur_max>:
40005a34:	4000e7b7          	lui	a5,0x4000e
40005a38:	5887a503          	lw	a0,1416(a5) # 4000e588 <__mb_cur_max>
40005a3c:	00008067          	ret

40005a40 <__locale_msgcharset>:
40005a40:	4000e537          	lui	a0,0x4000e
40005a44:	52050513          	addi	a0,a0,1312 # 4000e520 <lc_message_charset>
40005a48:	00008067          	ret

40005a4c <__locale_cjk_lang>:
40005a4c:	00000513          	li	a0,0
40005a50:	00008067          	ret

40005a54 <_localeconv_r>:
40005a54:	4000e537          	lui	a0,0x4000e
40005a58:	54050513          	addi	a0,a0,1344 # 4000e540 <lconv>
40005a5c:	00008067          	ret

40005a60 <setlocale>:
40005a60:	4000e7b7          	lui	a5,0x4000e
40005a64:	00058613          	mv	a2,a1
40005a68:	00050593          	mv	a1,a0
40005a6c:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
40005a70:	f41ff06f          	j	400059b0 <_setlocale_r>

40005a74 <localeconv>:
40005a74:	4000e537          	lui	a0,0x4000e
40005a78:	54050513          	addi	a0,a0,1344 # 4000e540 <lconv>
40005a7c:	00008067          	ret

40005a80 <__swhatbuf_r>:
40005a80:	f8010113          	addi	sp,sp,-128
40005a84:	06812c23          	sw	s0,120(sp)
40005a88:	00058413          	mv	s0,a1
40005a8c:	00e59583          	lh	a1,14(a1)
40005a90:	06912a23          	sw	s1,116(sp)
40005a94:	07212823          	sw	s2,112(sp)
40005a98:	06112e23          	sw	ra,124(sp)
40005a9c:	00060493          	mv	s1,a2
40005aa0:	00068913          	mv	s2,a3
40005aa4:	0405ca63          	bltz	a1,40005af8 <__swhatbuf_r+0x78>
40005aa8:	00810613          	addi	a2,sp,8
40005aac:	4bd020ef          	jal	ra,40008768 <_fstat_r>
40005ab0:	04054463          	bltz	a0,40005af8 <__swhatbuf_r+0x78>
40005ab4:	01812783          	lw	a5,24(sp)
40005ab8:	0000f737          	lui	a4,0xf
40005abc:	07c12083          	lw	ra,124(sp)
40005ac0:	00e7f7b3          	and	a5,a5,a4
40005ac4:	ffffe737          	lui	a4,0xffffe
40005ac8:	00e787b3          	add	a5,a5,a4
40005acc:	0017b793          	seqz	a5,a5
40005ad0:	00f92023          	sw	a5,0(s2)
40005ad4:	00001537          	lui	a0,0x1
40005ad8:	40000793          	li	a5,1024
40005adc:	00f4a023          	sw	a5,0(s1)
40005ae0:	80050513          	addi	a0,a0,-2048 # 800 <_stack_size>
40005ae4:	07812403          	lw	s0,120(sp)
40005ae8:	07412483          	lw	s1,116(sp)
40005aec:	07012903          	lw	s2,112(sp)
40005af0:	08010113          	addi	sp,sp,128
40005af4:	00008067          	ret
40005af8:	00c45783          	lhu	a5,12(s0)
40005afc:	00092023          	sw	zero,0(s2)
40005b00:	0807f793          	andi	a5,a5,128
40005b04:	02078463          	beqz	a5,40005b2c <__swhatbuf_r+0xac>
40005b08:	07c12083          	lw	ra,124(sp)
40005b0c:	04000793          	li	a5,64
40005b10:	00f4a023          	sw	a5,0(s1)
40005b14:	00000513          	li	a0,0
40005b18:	07812403          	lw	s0,120(sp)
40005b1c:	07412483          	lw	s1,116(sp)
40005b20:	07012903          	lw	s2,112(sp)
40005b24:	08010113          	addi	sp,sp,128
40005b28:	00008067          	ret
40005b2c:	07c12083          	lw	ra,124(sp)
40005b30:	40000793          	li	a5,1024
40005b34:	00f4a023          	sw	a5,0(s1)
40005b38:	00000513          	li	a0,0
40005b3c:	07812403          	lw	s0,120(sp)
40005b40:	07412483          	lw	s1,116(sp)
40005b44:	07012903          	lw	s2,112(sp)
40005b48:	08010113          	addi	sp,sp,128
40005b4c:	00008067          	ret

40005b50 <__smakebuf_r>:
40005b50:	00c5d703          	lhu	a4,12(a1)
40005b54:	fe010113          	addi	sp,sp,-32
40005b58:	00812c23          	sw	s0,24(sp)
40005b5c:	00112e23          	sw	ra,28(sp)
40005b60:	00912a23          	sw	s1,20(sp)
40005b64:	01212823          	sw	s2,16(sp)
40005b68:	00277713          	andi	a4,a4,2
40005b6c:	00058413          	mv	s0,a1
40005b70:	02070863          	beqz	a4,40005ba0 <__smakebuf_r+0x50>
40005b74:	04358713          	addi	a4,a1,67
40005b78:	00e5a023          	sw	a4,0(a1)
40005b7c:	00e5a823          	sw	a4,16(a1)
40005b80:	00100713          	li	a4,1
40005b84:	00e5aa23          	sw	a4,20(a1)
40005b88:	01c12083          	lw	ra,28(sp)
40005b8c:	01812403          	lw	s0,24(sp)
40005b90:	01412483          	lw	s1,20(sp)
40005b94:	01012903          	lw	s2,16(sp)
40005b98:	02010113          	addi	sp,sp,32
40005b9c:	00008067          	ret
40005ba0:	00c10693          	addi	a3,sp,12
40005ba4:	00810613          	addi	a2,sp,8
40005ba8:	00050493          	mv	s1,a0
40005bac:	ed5ff0ef          	jal	ra,40005a80 <__swhatbuf_r>
40005bb0:	00812583          	lw	a1,8(sp)
40005bb4:	00050913          	mv	s2,a0
40005bb8:	00048513          	mv	a0,s1
40005bbc:	954fb0ef          	jal	ra,40000d10 <_malloc_r>
40005bc0:	00c41783          	lh	a5,12(s0)
40005bc4:	06050663          	beqz	a0,40005c30 <__smakebuf_r+0xe0>
40005bc8:	40005737          	lui	a4,0x40005
40005bcc:	07c70713          	addi	a4,a4,124 # 4000507c <_cleanup_r>
40005bd0:	02e4ae23          	sw	a4,60(s1)
40005bd4:	00812703          	lw	a4,8(sp)
40005bd8:	00c12683          	lw	a3,12(sp)
40005bdc:	0807e793          	ori	a5,a5,128
40005be0:	00f41623          	sh	a5,12(s0)
40005be4:	00a42023          	sw	a0,0(s0)
40005be8:	00a42823          	sw	a0,16(s0)
40005bec:	00e42a23          	sw	a4,20(s0)
40005bf0:	02069263          	bnez	a3,40005c14 <__smakebuf_r+0xc4>
40005bf4:	01c12083          	lw	ra,28(sp)
40005bf8:	0127e7b3          	or	a5,a5,s2
40005bfc:	00f41623          	sh	a5,12(s0)
40005c00:	01412483          	lw	s1,20(sp)
40005c04:	01812403          	lw	s0,24(sp)
40005c08:	01012903          	lw	s2,16(sp)
40005c0c:	02010113          	addi	sp,sp,32
40005c10:	00008067          	ret
40005c14:	00e41583          	lh	a1,14(s0)
40005c18:	00048513          	mv	a0,s1
40005c1c:	064030ef          	jal	ra,40008c80 <_isatty_r>
40005c20:	00c41783          	lh	a5,12(s0)
40005c24:	fc0508e3          	beqz	a0,40005bf4 <__smakebuf_r+0xa4>
40005c28:	0017e793          	ori	a5,a5,1
40005c2c:	fc9ff06f          	j	40005bf4 <__smakebuf_r+0xa4>
40005c30:	2007f713          	andi	a4,a5,512
40005c34:	f4071ae3          	bnez	a4,40005b88 <__smakebuf_r+0x38>
40005c38:	0027e793          	ori	a5,a5,2
40005c3c:	04340713          	addi	a4,s0,67
40005c40:	00f41623          	sh	a5,12(s0)
40005c44:	00100793          	li	a5,1
40005c48:	00e42023          	sw	a4,0(s0)
40005c4c:	00e42823          	sw	a4,16(s0)
40005c50:	00f42a23          	sw	a5,20(s0)
40005c54:	f35ff06f          	j	40005b88 <__smakebuf_r+0x38>

40005c58 <memchr>:
40005c58:	00357793          	andi	a5,a0,3
40005c5c:	0ff5f813          	andi	a6,a1,255
40005c60:	0c078663          	beqz	a5,40005d2c <memchr+0xd4>
40005c64:	fff60793          	addi	a5,a2,-1
40005c68:	04060e63          	beqz	a2,40005cc4 <memchr+0x6c>
40005c6c:	00054703          	lbu	a4,0(a0)
40005c70:	fff00693          	li	a3,-1
40005c74:	01071c63          	bne	a4,a6,40005c8c <memchr+0x34>
40005c78:	0500006f          	j	40005cc8 <memchr+0x70>
40005c7c:	fff78793          	addi	a5,a5,-1
40005c80:	04d78263          	beq	a5,a3,40005cc4 <memchr+0x6c>
40005c84:	00054703          	lbu	a4,0(a0)
40005c88:	05070063          	beq	a4,a6,40005cc8 <memchr+0x70>
40005c8c:	00150513          	addi	a0,a0,1
40005c90:	00357713          	andi	a4,a0,3
40005c94:	fe0714e3          	bnez	a4,40005c7c <memchr+0x24>
40005c98:	00300713          	li	a4,3
40005c9c:	02f76863          	bltu	a4,a5,40005ccc <memchr+0x74>
40005ca0:	02078263          	beqz	a5,40005cc4 <memchr+0x6c>
40005ca4:	00054703          	lbu	a4,0(a0)
40005ca8:	03070063          	beq	a4,a6,40005cc8 <memchr+0x70>
40005cac:	00f507b3          	add	a5,a0,a5
40005cb0:	00c0006f          	j	40005cbc <memchr+0x64>
40005cb4:	00054703          	lbu	a4,0(a0)
40005cb8:	01070863          	beq	a4,a6,40005cc8 <memchr+0x70>
40005cbc:	00150513          	addi	a0,a0,1
40005cc0:	fea79ae3          	bne	a5,a0,40005cb4 <memchr+0x5c>
40005cc4:	00000513          	li	a0,0
40005cc8:	00008067          	ret
40005ccc:	000106b7          	lui	a3,0x10
40005cd0:	00859613          	slli	a2,a1,0x8
40005cd4:	fff68693          	addi	a3,a3,-1 # ffff <_heap_size+0xdfff>
40005cd8:	00d67633          	and	a2,a2,a3
40005cdc:	0ff5f593          	andi	a1,a1,255
40005ce0:	00b66633          	or	a2,a2,a1
40005ce4:	01061693          	slli	a3,a2,0x10
40005ce8:	feff0337          	lui	t1,0xfeff0
40005cec:	808088b7          	lui	a7,0x80808
40005cf0:	00d66633          	or	a2,a2,a3
40005cf4:	eff30313          	addi	t1,t1,-257 # fefefeff <end+0xbefdf11f>
40005cf8:	08088893          	addi	a7,a7,128 # 80808080 <end+0x407f72a0>
40005cfc:	00070593          	mv	a1,a4
40005d00:	00052703          	lw	a4,0(a0)
40005d04:	00e64733          	xor	a4,a2,a4
40005d08:	006706b3          	add	a3,a4,t1
40005d0c:	fff74713          	not	a4,a4
40005d10:	00e6f733          	and	a4,a3,a4
40005d14:	01177733          	and	a4,a4,a7
40005d18:	f80716e3          	bnez	a4,40005ca4 <memchr+0x4c>
40005d1c:	ffc78793          	addi	a5,a5,-4
40005d20:	00450513          	addi	a0,a0,4
40005d24:	fcf5eee3          	bltu	a1,a5,40005d00 <memchr+0xa8>
40005d28:	f79ff06f          	j	40005ca0 <memchr+0x48>
40005d2c:	00060793          	mv	a5,a2
40005d30:	f69ff06f          	j	40005c98 <memchr+0x40>

40005d34 <memset>:
40005d34:	00f00813          	li	a6,15
40005d38:	00050713          	mv	a4,a0
40005d3c:	02c87e63          	bleu	a2,a6,40005d78 <memset+0x44>
40005d40:	00f77793          	andi	a5,a4,15
40005d44:	0a079063          	bnez	a5,40005de4 <memset+0xb0>
40005d48:	08059263          	bnez	a1,40005dcc <memset+0x98>
40005d4c:	ff067693          	andi	a3,a2,-16
40005d50:	00f67613          	andi	a2,a2,15
40005d54:	00e686b3          	add	a3,a3,a4
40005d58:	00b72023          	sw	a1,0(a4)
40005d5c:	00b72223          	sw	a1,4(a4)
40005d60:	00b72423          	sw	a1,8(a4)
40005d64:	00b72623          	sw	a1,12(a4)
40005d68:	01070713          	addi	a4,a4,16
40005d6c:	fed766e3          	bltu	a4,a3,40005d58 <memset+0x24>
40005d70:	00061463          	bnez	a2,40005d78 <memset+0x44>
40005d74:	00008067          	ret
40005d78:	40c806b3          	sub	a3,a6,a2
40005d7c:	00269693          	slli	a3,a3,0x2
40005d80:	00000297          	auipc	t0,0x0
40005d84:	005686b3          	add	a3,a3,t0
40005d88:	00c68067          	jr	12(a3)
40005d8c:	00b70723          	sb	a1,14(a4)
40005d90:	00b706a3          	sb	a1,13(a4)
40005d94:	00b70623          	sb	a1,12(a4)
40005d98:	00b705a3          	sb	a1,11(a4)
40005d9c:	00b70523          	sb	a1,10(a4)
40005da0:	00b704a3          	sb	a1,9(a4)
40005da4:	00b70423          	sb	a1,8(a4)
40005da8:	00b703a3          	sb	a1,7(a4)
40005dac:	00b70323          	sb	a1,6(a4)
40005db0:	00b702a3          	sb	a1,5(a4)
40005db4:	00b70223          	sb	a1,4(a4)
40005db8:	00b701a3          	sb	a1,3(a4)
40005dbc:	00b70123          	sb	a1,2(a4)
40005dc0:	00b700a3          	sb	a1,1(a4)
40005dc4:	00b70023          	sb	a1,0(a4)
40005dc8:	00008067          	ret
40005dcc:	0ff5f593          	andi	a1,a1,255
40005dd0:	00859693          	slli	a3,a1,0x8
40005dd4:	00d5e5b3          	or	a1,a1,a3
40005dd8:	01059693          	slli	a3,a1,0x10
40005ddc:	00d5e5b3          	or	a1,a1,a3
40005de0:	f6dff06f          	j	40005d4c <memset+0x18>
40005de4:	00279693          	slli	a3,a5,0x2
40005de8:	00000297          	auipc	t0,0x0
40005dec:	005686b3          	add	a3,a3,t0
40005df0:	00008293          	mv	t0,ra
40005df4:	fa0680e7          	jalr	-96(a3)
40005df8:	00028093          	mv	ra,t0
40005dfc:	ff078793          	addi	a5,a5,-16
40005e00:	40f70733          	sub	a4,a4,a5
40005e04:	00f60633          	add	a2,a2,a5
40005e08:	f6c878e3          	bleu	a2,a6,40005d78 <memset+0x44>
40005e0c:	f3dff06f          	j	40005d48 <memset+0x14>

40005e10 <_Balloc>:
40005e10:	04c52783          	lw	a5,76(a0)
40005e14:	ff010113          	addi	sp,sp,-16
40005e18:	00812423          	sw	s0,8(sp)
40005e1c:	00912223          	sw	s1,4(sp)
40005e20:	00112623          	sw	ra,12(sp)
40005e24:	01212023          	sw	s2,0(sp)
40005e28:	00050413          	mv	s0,a0
40005e2c:	00058493          	mv	s1,a1
40005e30:	02078e63          	beqz	a5,40005e6c <_Balloc+0x5c>
40005e34:	00249513          	slli	a0,s1,0x2
40005e38:	00a787b3          	add	a5,a5,a0
40005e3c:	0007a503          	lw	a0,0(a5)
40005e40:	04050663          	beqz	a0,40005e8c <_Balloc+0x7c>
40005e44:	00052703          	lw	a4,0(a0)
40005e48:	00e7a023          	sw	a4,0(a5)
40005e4c:	00052823          	sw	zero,16(a0)
40005e50:	00052623          	sw	zero,12(a0)
40005e54:	00c12083          	lw	ra,12(sp)
40005e58:	00812403          	lw	s0,8(sp)
40005e5c:	00412483          	lw	s1,4(sp)
40005e60:	00012903          	lw	s2,0(sp)
40005e64:	01010113          	addi	sp,sp,16
40005e68:	00008067          	ret
40005e6c:	02100613          	li	a2,33
40005e70:	00400593          	li	a1,4
40005e74:	4e0020ef          	jal	ra,40008354 <_calloc_r>
40005e78:	04a42623          	sw	a0,76(s0)
40005e7c:	00050793          	mv	a5,a0
40005e80:	fa051ae3          	bnez	a0,40005e34 <_Balloc+0x24>
40005e84:	00000513          	li	a0,0
40005e88:	fcdff06f          	j	40005e54 <_Balloc+0x44>
40005e8c:	00100593          	li	a1,1
40005e90:	00959933          	sll	s2,a1,s1
40005e94:	00590613          	addi	a2,s2,5
40005e98:	00261613          	slli	a2,a2,0x2
40005e9c:	00040513          	mv	a0,s0
40005ea0:	4b4020ef          	jal	ra,40008354 <_calloc_r>
40005ea4:	fe0500e3          	beqz	a0,40005e84 <_Balloc+0x74>
40005ea8:	00952223          	sw	s1,4(a0)
40005eac:	01252423          	sw	s2,8(a0)
40005eb0:	f9dff06f          	j	40005e4c <_Balloc+0x3c>

40005eb4 <_Bfree>:
40005eb4:	02058063          	beqz	a1,40005ed4 <_Bfree+0x20>
40005eb8:	0045a703          	lw	a4,4(a1)
40005ebc:	04c52783          	lw	a5,76(a0)
40005ec0:	00271713          	slli	a4,a4,0x2
40005ec4:	00e787b3          	add	a5,a5,a4
40005ec8:	0007a703          	lw	a4,0(a5)
40005ecc:	00e5a023          	sw	a4,0(a1)
40005ed0:	00b7a023          	sw	a1,0(a5)
40005ed4:	00008067          	ret

40005ed8 <__multadd>:
40005ed8:	fd010113          	addi	sp,sp,-48
40005edc:	01312e23          	sw	s3,28(sp)
40005ee0:	0105a983          	lw	s3,16(a1)
40005ee4:	01812423          	sw	s8,8(sp)
40005ee8:	00010c37          	lui	s8,0x10
40005eec:	02812423          	sw	s0,40(sp)
40005ef0:	02912223          	sw	s1,36(sp)
40005ef4:	03212023          	sw	s2,32(sp)
40005ef8:	01412c23          	sw	s4,24(sp)
40005efc:	01512a23          	sw	s5,20(sp)
40005f00:	01612823          	sw	s6,16(sp)
40005f04:	02112623          	sw	ra,44(sp)
40005f08:	01712623          	sw	s7,12(sp)
40005f0c:	00058a13          	mv	s4,a1
40005f10:	00050a93          	mv	s5,a0
40005f14:	00060913          	mv	s2,a2
40005f18:	00068413          	mv	s0,a3
40005f1c:	01458493          	addi	s1,a1,20
40005f20:	00000b13          	li	s6,0
40005f24:	fffc0c13          	addi	s8,s8,-1 # ffff <_heap_size+0xdfff>
40005f28:	0004ab83          	lw	s7,0(s1)
40005f2c:	00090593          	mv	a1,s2
40005f30:	00448493          	addi	s1,s1,4
40005f34:	018bf533          	and	a0,s7,s8
40005f38:	779060ef          	jal	ra,4000ceb0 <__mulsi3>
40005f3c:	00850433          	add	s0,a0,s0
40005f40:	00090593          	mv	a1,s2
40005f44:	010bd513          	srli	a0,s7,0x10
40005f48:	769060ef          	jal	ra,4000ceb0 <__mulsi3>
40005f4c:	01045693          	srli	a3,s0,0x10
40005f50:	00d50533          	add	a0,a0,a3
40005f54:	01051693          	slli	a3,a0,0x10
40005f58:	01847433          	and	s0,s0,s8
40005f5c:	00868433          	add	s0,a3,s0
40005f60:	fe84ae23          	sw	s0,-4(s1)
40005f64:	001b0b13          	addi	s6,s6,1
40005f68:	01055413          	srli	s0,a0,0x10
40005f6c:	fb3b4ee3          	blt	s6,s3,40005f28 <__multadd+0x50>
40005f70:	02040263          	beqz	s0,40005f94 <__multadd+0xbc>
40005f74:	008a2783          	lw	a5,8(s4)
40005f78:	04f9d863          	ble	a5,s3,40005fc8 <__multadd+0xf0>
40005f7c:	00498793          	addi	a5,s3,4
40005f80:	00279793          	slli	a5,a5,0x2
40005f84:	00fa07b3          	add	a5,s4,a5
40005f88:	0087a223          	sw	s0,4(a5)
40005f8c:	00198993          	addi	s3,s3,1
40005f90:	013a2823          	sw	s3,16(s4)
40005f94:	02c12083          	lw	ra,44(sp)
40005f98:	000a0513          	mv	a0,s4
40005f9c:	02812403          	lw	s0,40(sp)
40005fa0:	02412483          	lw	s1,36(sp)
40005fa4:	02012903          	lw	s2,32(sp)
40005fa8:	01c12983          	lw	s3,28(sp)
40005fac:	01812a03          	lw	s4,24(sp)
40005fb0:	01412a83          	lw	s5,20(sp)
40005fb4:	01012b03          	lw	s6,16(sp)
40005fb8:	00c12b83          	lw	s7,12(sp)
40005fbc:	00812c03          	lw	s8,8(sp)
40005fc0:	03010113          	addi	sp,sp,48
40005fc4:	00008067          	ret
40005fc8:	004a2583          	lw	a1,4(s4)
40005fcc:	000a8513          	mv	a0,s5
40005fd0:	00158593          	addi	a1,a1,1
40005fd4:	e3dff0ef          	jal	ra,40005e10 <_Balloc>
40005fd8:	010a2603          	lw	a2,16(s4)
40005fdc:	00050493          	mv	s1,a0
40005fe0:	00ca0593          	addi	a1,s4,12
40005fe4:	00260613          	addi	a2,a2,2
40005fe8:	00c50513          	addi	a0,a0,12
40005fec:	00261613          	slli	a2,a2,0x2
40005ff0:	c6cfb0ef          	jal	ra,4000145c <memcpy>
40005ff4:	004a2703          	lw	a4,4(s4)
40005ff8:	04caa783          	lw	a5,76(s5)
40005ffc:	00271713          	slli	a4,a4,0x2
40006000:	00e787b3          	add	a5,a5,a4
40006004:	0007a703          	lw	a4,0(a5)
40006008:	00ea2023          	sw	a4,0(s4)
4000600c:	0147a023          	sw	s4,0(a5)
40006010:	00048a13          	mv	s4,s1
40006014:	f69ff06f          	j	40005f7c <__multadd+0xa4>

40006018 <__s2b>:
40006018:	fe010113          	addi	sp,sp,-32
4000601c:	00812c23          	sw	s0,24(sp)
40006020:	00912a23          	sw	s1,20(sp)
40006024:	00058413          	mv	s0,a1
40006028:	00050493          	mv	s1,a0
4000602c:	00900593          	li	a1,9
40006030:	00868513          	addi	a0,a3,8
40006034:	01212823          	sw	s2,16(sp)
40006038:	01312623          	sw	s3,12(sp)
4000603c:	01412423          	sw	s4,8(sp)
40006040:	00112e23          	sw	ra,28(sp)
40006044:	01512223          	sw	s5,4(sp)
40006048:	01612023          	sw	s6,0(sp)
4000604c:	00068a13          	mv	s4,a3
40006050:	00060993          	mv	s3,a2
40006054:	00070913          	mv	s2,a4
40006058:	67d060ef          	jal	ra,4000ced4 <__divsi3>
4000605c:	00100793          	li	a5,1
40006060:	00000593          	li	a1,0
40006064:	00a7d863          	ble	a0,a5,40006074 <__s2b+0x5c>
40006068:	00179793          	slli	a5,a5,0x1
4000606c:	00158593          	addi	a1,a1,1
40006070:	fea7cce3          	blt	a5,a0,40006068 <__s2b+0x50>
40006074:	00048513          	mv	a0,s1
40006078:	d99ff0ef          	jal	ra,40005e10 <_Balloc>
4000607c:	00100793          	li	a5,1
40006080:	00f52823          	sw	a5,16(a0)
40006084:	01252a23          	sw	s2,20(a0)
40006088:	00900793          	li	a5,9
4000608c:	0937da63          	ble	s3,a5,40006120 <__s2b+0x108>
40006090:	00f40b33          	add	s6,s0,a5
40006094:	01340ab3          	add	s5,s0,s3
40006098:	00a00913          	li	s2,10
4000609c:	000b0413          	mv	s0,s6
400060a0:	00140413          	addi	s0,s0,1
400060a4:	fff44683          	lbu	a3,-1(s0)
400060a8:	00050593          	mv	a1,a0
400060ac:	00090613          	mv	a2,s2
400060b0:	fd068693          	addi	a3,a3,-48
400060b4:	00048513          	mv	a0,s1
400060b8:	e21ff0ef          	jal	ra,40005ed8 <__multadd>
400060bc:	ff5412e3          	bne	s0,s5,400060a0 <__s2b+0x88>
400060c0:	ff898413          	addi	s0,s3,-8
400060c4:	008b0433          	add	s0,s6,s0
400060c8:	413a0933          	sub	s2,s4,s3
400060cc:	01240933          	add	s2,s0,s2
400060d0:	00a00a93          	li	s5,10
400060d4:	0349d263          	ble	s4,s3,400060f8 <__s2b+0xe0>
400060d8:	00140413          	addi	s0,s0,1
400060dc:	fff44683          	lbu	a3,-1(s0)
400060e0:	00050593          	mv	a1,a0
400060e4:	000a8613          	mv	a2,s5
400060e8:	fd068693          	addi	a3,a3,-48
400060ec:	00048513          	mv	a0,s1
400060f0:	de9ff0ef          	jal	ra,40005ed8 <__multadd>
400060f4:	fe8912e3          	bne	s2,s0,400060d8 <__s2b+0xc0>
400060f8:	01c12083          	lw	ra,28(sp)
400060fc:	01812403          	lw	s0,24(sp)
40006100:	01412483          	lw	s1,20(sp)
40006104:	01012903          	lw	s2,16(sp)
40006108:	00c12983          	lw	s3,12(sp)
4000610c:	00812a03          	lw	s4,8(sp)
40006110:	00412a83          	lw	s5,4(sp)
40006114:	00012b03          	lw	s6,0(sp)
40006118:	02010113          	addi	sp,sp,32
4000611c:	00008067          	ret
40006120:	00a40413          	addi	s0,s0,10
40006124:	00078993          	mv	s3,a5
40006128:	fa1ff06f          	j	400060c8 <__s2b+0xb0>

4000612c <__hi0bits>:
4000612c:	ffff0737          	lui	a4,0xffff0
40006130:	00e57733          	and	a4,a0,a4
40006134:	00050793          	mv	a5,a0
40006138:	00000513          	li	a0,0
4000613c:	00071663          	bnez	a4,40006148 <__hi0bits+0x1c>
40006140:	01079793          	slli	a5,a5,0x10
40006144:	01000513          	li	a0,16
40006148:	ff000737          	lui	a4,0xff000
4000614c:	00e7f733          	and	a4,a5,a4
40006150:	00071663          	bnez	a4,4000615c <__hi0bits+0x30>
40006154:	00850513          	addi	a0,a0,8
40006158:	00879793          	slli	a5,a5,0x8
4000615c:	f0000737          	lui	a4,0xf0000
40006160:	00e7f733          	and	a4,a5,a4
40006164:	00071663          	bnez	a4,40006170 <__hi0bits+0x44>
40006168:	00450513          	addi	a0,a0,4
4000616c:	00479793          	slli	a5,a5,0x4
40006170:	c0000737          	lui	a4,0xc0000
40006174:	00e7f733          	and	a4,a5,a4
40006178:	00071663          	bnez	a4,40006184 <__hi0bits+0x58>
4000617c:	00250513          	addi	a0,a0,2
40006180:	00279793          	slli	a5,a5,0x2
40006184:	0007c863          	bltz	a5,40006194 <__hi0bits+0x68>
40006188:	00179713          	slli	a4,a5,0x1
4000618c:	00074663          	bltz	a4,40006198 <__hi0bits+0x6c>
40006190:	02000513          	li	a0,32
40006194:	00008067          	ret
40006198:	00150513          	addi	a0,a0,1
4000619c:	00008067          	ret

400061a0 <__lo0bits>:
400061a0:	00052783          	lw	a5,0(a0)
400061a4:	0077f713          	andi	a4,a5,7
400061a8:	02070663          	beqz	a4,400061d4 <__lo0bits+0x34>
400061ac:	0017f693          	andi	a3,a5,1
400061b0:	00000713          	li	a4,0
400061b4:	00069c63          	bnez	a3,400061cc <__lo0bits+0x2c>
400061b8:	0027f713          	andi	a4,a5,2
400061bc:	08071663          	bnez	a4,40006248 <__lo0bits+0xa8>
400061c0:	0027d793          	srli	a5,a5,0x2
400061c4:	00f52023          	sw	a5,0(a0)
400061c8:	00200713          	li	a4,2
400061cc:	00070513          	mv	a0,a4
400061d0:	00008067          	ret
400061d4:	01079693          	slli	a3,a5,0x10
400061d8:	0106d693          	srli	a3,a3,0x10
400061dc:	00000713          	li	a4,0
400061e0:	00069663          	bnez	a3,400061ec <__lo0bits+0x4c>
400061e4:	0107d793          	srli	a5,a5,0x10
400061e8:	01000713          	li	a4,16
400061ec:	0ff7f693          	andi	a3,a5,255
400061f0:	00069663          	bnez	a3,400061fc <__lo0bits+0x5c>
400061f4:	00870713          	addi	a4,a4,8 # c0000008 <end+0x7ffef228>
400061f8:	0087d793          	srli	a5,a5,0x8
400061fc:	00f7f693          	andi	a3,a5,15
40006200:	00069663          	bnez	a3,4000620c <__lo0bits+0x6c>
40006204:	00470713          	addi	a4,a4,4
40006208:	0047d793          	srli	a5,a5,0x4
4000620c:	0037f693          	andi	a3,a5,3
40006210:	00069663          	bnez	a3,4000621c <__lo0bits+0x7c>
40006214:	00270713          	addi	a4,a4,2
40006218:	0027d793          	srli	a5,a5,0x2
4000621c:	0017f693          	andi	a3,a5,1
40006220:	00069e63          	bnez	a3,4000623c <__lo0bits+0x9c>
40006224:	0017d793          	srli	a5,a5,0x1
40006228:	00079863          	bnez	a5,40006238 <__lo0bits+0x98>
4000622c:	02000713          	li	a4,32
40006230:	00070513          	mv	a0,a4
40006234:	00008067          	ret
40006238:	00170713          	addi	a4,a4,1
4000623c:	00f52023          	sw	a5,0(a0)
40006240:	00070513          	mv	a0,a4
40006244:	00008067          	ret
40006248:	0017d793          	srli	a5,a5,0x1
4000624c:	00100713          	li	a4,1
40006250:	00f52023          	sw	a5,0(a0)
40006254:	00070513          	mv	a0,a4
40006258:	00008067          	ret

4000625c <__i2b>:
4000625c:	ff010113          	addi	sp,sp,-16
40006260:	00812423          	sw	s0,8(sp)
40006264:	00058413          	mv	s0,a1
40006268:	00100593          	li	a1,1
4000626c:	00112623          	sw	ra,12(sp)
40006270:	ba1ff0ef          	jal	ra,40005e10 <_Balloc>
40006274:	00c12083          	lw	ra,12(sp)
40006278:	00100713          	li	a4,1
4000627c:	00852a23          	sw	s0,20(a0)
40006280:	00e52823          	sw	a4,16(a0)
40006284:	00812403          	lw	s0,8(sp)
40006288:	01010113          	addi	sp,sp,16
4000628c:	00008067          	ret

40006290 <__multiply>:
40006290:	fb010113          	addi	sp,sp,-80
40006294:	04812423          	sw	s0,72(sp)
40006298:	04912223          	sw	s1,68(sp)
4000629c:	0105a403          	lw	s0,16(a1)
400062a0:	01062483          	lw	s1,16(a2)
400062a4:	03412c23          	sw	s4,56(sp)
400062a8:	03912223          	sw	s9,36(sp)
400062ac:	04112623          	sw	ra,76(sp)
400062b0:	05212023          	sw	s2,64(sp)
400062b4:	03312e23          	sw	s3,60(sp)
400062b8:	03512a23          	sw	s5,52(sp)
400062bc:	03612823          	sw	s6,48(sp)
400062c0:	03712623          	sw	s7,44(sp)
400062c4:	03812423          	sw	s8,40(sp)
400062c8:	03a12023          	sw	s10,32(sp)
400062cc:	01b12e23          	sw	s11,28(sp)
400062d0:	00058c93          	mv	s9,a1
400062d4:	00060a13          	mv	s4,a2
400062d8:	00945c63          	ble	s1,s0,400062f0 <__multiply+0x60>
400062dc:	00040713          	mv	a4,s0
400062e0:	00060c93          	mv	s9,a2
400062e4:	00048413          	mv	s0,s1
400062e8:	00058a13          	mv	s4,a1
400062ec:	00070493          	mv	s1,a4
400062f0:	008ca783          	lw	a5,8(s9)
400062f4:	004ca583          	lw	a1,4(s9)
400062f8:	00940bb3          	add	s7,s0,s1
400062fc:	0177a7b3          	slt	a5,a5,s7
40006300:	00f585b3          	add	a1,a1,a5
40006304:	b0dff0ef          	jal	ra,40005e10 <_Balloc>
40006308:	01450b13          	addi	s6,a0,20
4000630c:	002b9a93          	slli	s5,s7,0x2
40006310:	015b07b3          	add	a5,s6,s5
40006314:	00078713          	mv	a4,a5
40006318:	00f12023          	sw	a5,0(sp)
4000631c:	00a12623          	sw	a0,12(sp)
40006320:	000b0793          	mv	a5,s6
40006324:	00eb7a63          	bleu	a4,s6,40006338 <__multiply+0xa8>
40006328:	00012703          	lw	a4,0(sp)
4000632c:	0007a023          	sw	zero,0(a5)
40006330:	00478793          	addi	a5,a5,4
40006334:	fee7eae3          	bltu	a5,a4,40006328 <__multiply+0x98>
40006338:	00249493          	slli	s1,s1,0x2
4000633c:	014a0a13          	addi	s4,s4,20
40006340:	014c8793          	addi	a5,s9,20
40006344:	009a0733          	add	a4,s4,s1
40006348:	00241413          	slli	s0,s0,0x2
4000634c:	000104b7          	lui	s1,0x10
40006350:	00f12223          	sw	a5,4(sp)
40006354:	00e12423          	sw	a4,8(sp)
40006358:	008789b3          	add	s3,a5,s0
4000635c:	fff48493          	addi	s1,s1,-1 # ffff <_heap_size+0xdfff>
40006360:	10ea7663          	bleu	a4,s4,4000646c <__multiply+0x1dc>
40006364:	000a2d83          	lw	s11,0(s4)
40006368:	009df933          	and	s2,s11,s1
4000636c:	06090a63          	beqz	s2,400063e0 <__multiply+0x150>
40006370:	00412d03          	lw	s10,4(sp)
40006374:	000b0c13          	mv	s8,s6
40006378:	00000c93          	li	s9,0
4000637c:	000d2a83          	lw	s5,0(s10)
40006380:	000c2403          	lw	s0,0(s8)
40006384:	00090593          	mv	a1,s2
40006388:	009af533          	and	a0,s5,s1
4000638c:	325060ef          	jal	ra,4000ceb0 <__mulsi3>
40006390:	00947db3          	and	s11,s0,s1
40006394:	01b50db3          	add	s11,a0,s11
40006398:	00090593          	mv	a1,s2
4000639c:	010ad513          	srli	a0,s5,0x10
400063a0:	019d8db3          	add	s11,s11,s9
400063a4:	30d060ef          	jal	ra,4000ceb0 <__mulsi3>
400063a8:	01045413          	srli	s0,s0,0x10
400063ac:	00850533          	add	a0,a0,s0
400063b0:	010dd413          	srli	s0,s11,0x10
400063b4:	00850533          	add	a0,a0,s0
400063b8:	01051693          	slli	a3,a0,0x10
400063bc:	009dfdb3          	and	s11,s11,s1
400063c0:	004c0c13          	addi	s8,s8,4
400063c4:	01b6edb3          	or	s11,a3,s11
400063c8:	004d0d13          	addi	s10,s10,4
400063cc:	ffbc2e23          	sw	s11,-4(s8)
400063d0:	01055c93          	srli	s9,a0,0x10
400063d4:	fb3d64e3          	bltu	s10,s3,4000637c <__multiply+0xec>
400063d8:	019c2023          	sw	s9,0(s8)
400063dc:	000a2d83          	lw	s11,0(s4)
400063e0:	010ddd93          	srli	s11,s11,0x10
400063e4:	060d8c63          	beqz	s11,4000645c <__multiply+0x1cc>
400063e8:	000b2403          	lw	s0,0(s6)
400063ec:	00412c83          	lw	s9,4(sp)
400063f0:	000b0d13          	mv	s10,s6
400063f4:	00040913          	mv	s2,s0
400063f8:	00000c13          	li	s8,0
400063fc:	000ca503          	lw	a0,0(s9)
40006400:	000d8593          	mv	a1,s11
40006404:	01095913          	srli	s2,s2,0x10
40006408:	00957533          	and	a0,a0,s1
4000640c:	2a5060ef          	jal	ra,4000ceb0 <__mulsi3>
40006410:	01250933          	add	s2,a0,s2
40006414:	01890c33          	add	s8,s2,s8
40006418:	010c1513          	slli	a0,s8,0x10
4000641c:	00947433          	and	s0,s0,s1
40006420:	00856433          	or	s0,a0,s0
40006424:	004d0d13          	addi	s10,s10,4
40006428:	fe8d2e23          	sw	s0,-4(s10)
4000642c:	004c8c93          	addi	s9,s9,4
40006430:	000d2903          	lw	s2,0(s10)
40006434:	ffecd503          	lhu	a0,-2(s9)
40006438:	000d8593          	mv	a1,s11
4000643c:	00997433          	and	s0,s2,s1
40006440:	271060ef          	jal	ra,4000ceb0 <__mulsi3>
40006444:	010c5793          	srli	a5,s8,0x10
40006448:	00850433          	add	s0,a0,s0
4000644c:	00f40433          	add	s0,s0,a5
40006450:	01045c13          	srli	s8,s0,0x10
40006454:	fb3ce4e3          	bltu	s9,s3,400063fc <__multiply+0x16c>
40006458:	008d2023          	sw	s0,0(s10)
4000645c:	00812783          	lw	a5,8(sp)
40006460:	004a0a13          	addi	s4,s4,4
40006464:	004b0b13          	addi	s6,s6,4
40006468:	eefa6ee3          	bltu	s4,a5,40006364 <__multiply+0xd4>
4000646c:	03705663          	blez	s7,40006498 <__multiply+0x208>
40006470:	00012703          	lw	a4,0(sp)
40006474:	ffc72783          	lw	a5,-4(a4)
40006478:	ffc70a93          	addi	s5,a4,-4
4000647c:	00078863          	beqz	a5,4000648c <__multiply+0x1fc>
40006480:	0180006f          	j	40006498 <__multiply+0x208>
40006484:	000aa783          	lw	a5,0(s5)
40006488:	00079863          	bnez	a5,40006498 <__multiply+0x208>
4000648c:	fffb8b93          	addi	s7,s7,-1
40006490:	ffca8a93          	addi	s5,s5,-4
40006494:	fe0b98e3          	bnez	s7,40006484 <__multiply+0x1f4>
40006498:	00c12783          	lw	a5,12(sp)
4000649c:	04c12083          	lw	ra,76(sp)
400064a0:	04812403          	lw	s0,72(sp)
400064a4:	0177a823          	sw	s7,16(a5)
400064a8:	00078513          	mv	a0,a5
400064ac:	04412483          	lw	s1,68(sp)
400064b0:	04012903          	lw	s2,64(sp)
400064b4:	03c12983          	lw	s3,60(sp)
400064b8:	03812a03          	lw	s4,56(sp)
400064bc:	03412a83          	lw	s5,52(sp)
400064c0:	03012b03          	lw	s6,48(sp)
400064c4:	02c12b83          	lw	s7,44(sp)
400064c8:	02812c03          	lw	s8,40(sp)
400064cc:	02412c83          	lw	s9,36(sp)
400064d0:	02012d03          	lw	s10,32(sp)
400064d4:	01c12d83          	lw	s11,28(sp)
400064d8:	05010113          	addi	sp,sp,80
400064dc:	00008067          	ret

400064e0 <__pow5mult>:
400064e0:	fe010113          	addi	sp,sp,-32
400064e4:	00812c23          	sw	s0,24(sp)
400064e8:	01312623          	sw	s3,12(sp)
400064ec:	01412423          	sw	s4,8(sp)
400064f0:	00112e23          	sw	ra,28(sp)
400064f4:	00912a23          	sw	s1,20(sp)
400064f8:	01212823          	sw	s2,16(sp)
400064fc:	00367793          	andi	a5,a2,3
40006500:	00060413          	mv	s0,a2
40006504:	00050993          	mv	s3,a0
40006508:	00058a13          	mv	s4,a1
4000650c:	0c079463          	bnez	a5,400065d4 <__pow5mult+0xf4>
40006510:	40245413          	srai	s0,s0,0x2
40006514:	000a0913          	mv	s2,s4
40006518:	06040863          	beqz	s0,40006588 <__pow5mult+0xa8>
4000651c:	0489a483          	lw	s1,72(s3)
40006520:	0c048e63          	beqz	s1,400065fc <__pow5mult+0x11c>
40006524:	00147793          	andi	a5,s0,1
40006528:	000a0913          	mv	s2,s4
4000652c:	02079063          	bnez	a5,4000654c <__pow5mult+0x6c>
40006530:	40145413          	srai	s0,s0,0x1
40006534:	04040a63          	beqz	s0,40006588 <__pow5mult+0xa8>
40006538:	0004a503          	lw	a0,0(s1)
4000653c:	06050863          	beqz	a0,400065ac <__pow5mult+0xcc>
40006540:	00050493          	mv	s1,a0
40006544:	00147793          	andi	a5,s0,1
40006548:	fe0784e3          	beqz	a5,40006530 <__pow5mult+0x50>
4000654c:	00048613          	mv	a2,s1
40006550:	00090593          	mv	a1,s2
40006554:	00098513          	mv	a0,s3
40006558:	d39ff0ef          	jal	ra,40006290 <__multiply>
4000655c:	06090863          	beqz	s2,400065cc <__pow5mult+0xec>
40006560:	00492703          	lw	a4,4(s2)
40006564:	04c9a783          	lw	a5,76(s3)
40006568:	40145413          	srai	s0,s0,0x1
4000656c:	00271713          	slli	a4,a4,0x2
40006570:	00e787b3          	add	a5,a5,a4
40006574:	0007a703          	lw	a4,0(a5)
40006578:	00e92023          	sw	a4,0(s2)
4000657c:	0127a023          	sw	s2,0(a5)
40006580:	00050913          	mv	s2,a0
40006584:	fa041ae3          	bnez	s0,40006538 <__pow5mult+0x58>
40006588:	01c12083          	lw	ra,28(sp)
4000658c:	00090513          	mv	a0,s2
40006590:	01812403          	lw	s0,24(sp)
40006594:	01412483          	lw	s1,20(sp)
40006598:	01012903          	lw	s2,16(sp)
4000659c:	00c12983          	lw	s3,12(sp)
400065a0:	00812a03          	lw	s4,8(sp)
400065a4:	02010113          	addi	sp,sp,32
400065a8:	00008067          	ret
400065ac:	00048613          	mv	a2,s1
400065b0:	00048593          	mv	a1,s1
400065b4:	00098513          	mv	a0,s3
400065b8:	cd9ff0ef          	jal	ra,40006290 <__multiply>
400065bc:	00a4a023          	sw	a0,0(s1)
400065c0:	00052023          	sw	zero,0(a0)
400065c4:	00050493          	mv	s1,a0
400065c8:	f7dff06f          	j	40006544 <__pow5mult+0x64>
400065cc:	00050913          	mv	s2,a0
400065d0:	f61ff06f          	j	40006530 <__pow5mult+0x50>
400065d4:	fff78793          	addi	a5,a5,-1
400065d8:	4000d737          	lui	a4,0x4000d
400065dc:	78870713          	addi	a4,a4,1928 # 4000d788 <p05.2481>
400065e0:	00279793          	slli	a5,a5,0x2
400065e4:	00f707b3          	add	a5,a4,a5
400065e8:	0007a603          	lw	a2,0(a5)
400065ec:	00000693          	li	a3,0
400065f0:	8e9ff0ef          	jal	ra,40005ed8 <__multadd>
400065f4:	00050a13          	mv	s4,a0
400065f8:	f19ff06f          	j	40006510 <__pow5mult+0x30>
400065fc:	00100593          	li	a1,1
40006600:	00098513          	mv	a0,s3
40006604:	80dff0ef          	jal	ra,40005e10 <_Balloc>
40006608:	27100793          	li	a5,625
4000660c:	00f52a23          	sw	a5,20(a0)
40006610:	00100793          	li	a5,1
40006614:	00f52823          	sw	a5,16(a0)
40006618:	04a9a423          	sw	a0,72(s3)
4000661c:	00050493          	mv	s1,a0
40006620:	00052023          	sw	zero,0(a0)
40006624:	f01ff06f          	j	40006524 <__pow5mult+0x44>

40006628 <__lshift>:
40006628:	fe010113          	addi	sp,sp,-32
4000662c:	01412423          	sw	s4,8(sp)
40006630:	0105aa03          	lw	s4,16(a1)
40006634:	00812c23          	sw	s0,24(sp)
40006638:	0085a783          	lw	a5,8(a1)
4000663c:	40565413          	srai	s0,a2,0x5
40006640:	01440a33          	add	s4,s0,s4
40006644:	00912a23          	sw	s1,20(sp)
40006648:	01212823          	sw	s2,16(sp)
4000664c:	01312623          	sw	s3,12(sp)
40006650:	01512223          	sw	s5,4(sp)
40006654:	00112e23          	sw	ra,28(sp)
40006658:	001a0493          	addi	s1,s4,1
4000665c:	00058993          	mv	s3,a1
40006660:	00060913          	mv	s2,a2
40006664:	00050a93          	mv	s5,a0
40006668:	0045a583          	lw	a1,4(a1)
4000666c:	0097d863          	ble	s1,a5,4000667c <__lshift+0x54>
40006670:	00179793          	slli	a5,a5,0x1
40006674:	00158593          	addi	a1,a1,1
40006678:	fe97cce3          	blt	a5,s1,40006670 <__lshift+0x48>
4000667c:	000a8513          	mv	a0,s5
40006680:	f90ff0ef          	jal	ra,40005e10 <_Balloc>
40006684:	01450793          	addi	a5,a0,20
40006688:	0e805063          	blez	s0,40006768 <__lshift+0x140>
4000668c:	00241713          	slli	a4,s0,0x2
40006690:	00e78733          	add	a4,a5,a4
40006694:	00478793          	addi	a5,a5,4
40006698:	fe07ae23          	sw	zero,-4(a5)
4000669c:	fee79ce3          	bne	a5,a4,40006694 <__lshift+0x6c>
400066a0:	0109a803          	lw	a6,16(s3)
400066a4:	01498793          	addi	a5,s3,20
400066a8:	01f97613          	andi	a2,s2,31
400066ac:	00281813          	slli	a6,a6,0x2
400066b0:	01078833          	add	a6,a5,a6
400066b4:	08060463          	beqz	a2,4000673c <__lshift+0x114>
400066b8:	02000893          	li	a7,32
400066bc:	40c888b3          	sub	a7,a7,a2
400066c0:	00000593          	li	a1,0
400066c4:	0007a683          	lw	a3,0(a5)
400066c8:	00470713          	addi	a4,a4,4
400066cc:	00478793          	addi	a5,a5,4
400066d0:	00c696b3          	sll	a3,a3,a2
400066d4:	00b6e6b3          	or	a3,a3,a1
400066d8:	fed72e23          	sw	a3,-4(a4)
400066dc:	ffc7a683          	lw	a3,-4(a5)
400066e0:	0116d5b3          	srl	a1,a3,a7
400066e4:	ff07e0e3          	bltu	a5,a6,400066c4 <__lshift+0x9c>
400066e8:	00b72023          	sw	a1,0(a4)
400066ec:	00058463          	beqz	a1,400066f4 <__lshift+0xcc>
400066f0:	002a0493          	addi	s1,s4,2
400066f4:	0049a703          	lw	a4,4(s3)
400066f8:	04caa783          	lw	a5,76(s5)
400066fc:	fff48493          	addi	s1,s1,-1
40006700:	00271713          	slli	a4,a4,0x2
40006704:	00e787b3          	add	a5,a5,a4
40006708:	0007a703          	lw	a4,0(a5)
4000670c:	01c12083          	lw	ra,28(sp)
40006710:	00952823          	sw	s1,16(a0)
40006714:	00e9a023          	sw	a4,0(s3)
40006718:	0137a023          	sw	s3,0(a5)
4000671c:	01812403          	lw	s0,24(sp)
40006720:	01412483          	lw	s1,20(sp)
40006724:	01012903          	lw	s2,16(sp)
40006728:	00c12983          	lw	s3,12(sp)
4000672c:	00812a03          	lw	s4,8(sp)
40006730:	00412a83          	lw	s5,4(sp)
40006734:	02010113          	addi	sp,sp,32
40006738:	00008067          	ret
4000673c:	00478793          	addi	a5,a5,4
40006740:	ffc7a683          	lw	a3,-4(a5)
40006744:	00470713          	addi	a4,a4,4
40006748:	fed72e23          	sw	a3,-4(a4)
4000674c:	fb07f4e3          	bleu	a6,a5,400066f4 <__lshift+0xcc>
40006750:	00478793          	addi	a5,a5,4
40006754:	ffc7a683          	lw	a3,-4(a5)
40006758:	00470713          	addi	a4,a4,4
4000675c:	fed72e23          	sw	a3,-4(a4)
40006760:	fd07eee3          	bltu	a5,a6,4000673c <__lshift+0x114>
40006764:	f91ff06f          	j	400066f4 <__lshift+0xcc>
40006768:	00078713          	mv	a4,a5
4000676c:	f35ff06f          	j	400066a0 <__lshift+0x78>

40006770 <__mcmp>:
40006770:	01052683          	lw	a3,16(a0)
40006774:	0105a703          	lw	a4,16(a1)
40006778:	00050813          	mv	a6,a0
4000677c:	40e68533          	sub	a0,a3,a4
40006780:	04051263          	bnez	a0,400067c4 <__mcmp+0x54>
40006784:	00271713          	slli	a4,a4,0x2
40006788:	01480813          	addi	a6,a6,20
4000678c:	01458593          	addi	a1,a1,20
40006790:	00e807b3          	add	a5,a6,a4
40006794:	00e58733          	add	a4,a1,a4
40006798:	0080006f          	j	400067a0 <__mcmp+0x30>
4000679c:	02f87463          	bleu	a5,a6,400067c4 <__mcmp+0x54>
400067a0:	ffc78793          	addi	a5,a5,-4
400067a4:	ffc70713          	addi	a4,a4,-4
400067a8:	0007a683          	lw	a3,0(a5)
400067ac:	00072603          	lw	a2,0(a4)
400067b0:	fec686e3          	beq	a3,a2,4000679c <__mcmp+0x2c>
400067b4:	00c6b6b3          	sltu	a3,a3,a2
400067b8:	40d006b3          	neg	a3,a3
400067bc:	0016e513          	ori	a0,a3,1
400067c0:	00008067          	ret
400067c4:	00008067          	ret

400067c8 <__mdiff>:
400067c8:	fe010113          	addi	sp,sp,-32
400067cc:	01212823          	sw	s2,16(sp)
400067d0:	01062703          	lw	a4,16(a2)
400067d4:	0105a903          	lw	s2,16(a1)
400067d8:	01312623          	sw	s3,12(sp)
400067dc:	01412423          	sw	s4,8(sp)
400067e0:	00112e23          	sw	ra,28(sp)
400067e4:	00812c23          	sw	s0,24(sp)
400067e8:	00912a23          	sw	s1,20(sp)
400067ec:	40e90933          	sub	s2,s2,a4
400067f0:	00058993          	mv	s3,a1
400067f4:	00060a13          	mv	s4,a2
400067f8:	04091863          	bnez	s2,40006848 <__mdiff+0x80>
400067fc:	00271713          	slli	a4,a4,0x2
40006800:	01458313          	addi	t1,a1,20
40006804:	01460493          	addi	s1,a2,20
40006808:	00e307b3          	add	a5,t1,a4
4000680c:	00e48733          	add	a4,s1,a4
40006810:	0080006f          	j	40006818 <__mdiff+0x50>
40006814:	16f37863          	bleu	a5,t1,40006984 <__mdiff+0x1bc>
40006818:	ffc78793          	addi	a5,a5,-4
4000681c:	ffc70713          	addi	a4,a4,-4
40006820:	0007a583          	lw	a1,0(a5)
40006824:	00072683          	lw	a3,0(a4)
40006828:	fed586e3          	beq	a1,a3,40006814 <__mdiff+0x4c>
4000682c:	18d5f663          	bleu	a3,a1,400069b8 <__mdiff+0x1f0>
40006830:	00098793          	mv	a5,s3
40006834:	00030413          	mv	s0,t1
40006838:	000a0993          	mv	s3,s4
4000683c:	00100913          	li	s2,1
40006840:	00078a13          	mv	s4,a5
40006844:	0140006f          	j	40006858 <__mdiff+0x90>
40006848:	16094e63          	bltz	s2,400069c4 <__mdiff+0x1fc>
4000684c:	01498493          	addi	s1,s3,20
40006850:	014a0413          	addi	s0,s4,20
40006854:	00000913          	li	s2,0
40006858:	0049a583          	lw	a1,4(s3)
4000685c:	db4ff0ef          	jal	ra,40005e10 <_Balloc>
40006860:	0109ae03          	lw	t3,16(s3)
40006864:	010a2f03          	lw	t5,16(s4)
40006868:	00010637          	lui	a2,0x10
4000686c:	002e1e93          	slli	t4,t3,0x2
40006870:	002f1f13          	slli	t5,t5,0x2
40006874:	01252623          	sw	s2,12(a0)
40006878:	01d48eb3          	add	t4,s1,t4
4000687c:	01e40f33          	add	t5,s0,t5
40006880:	01450593          	addi	a1,a0,20
40006884:	00040893          	mv	a7,s0
40006888:	00048313          	mv	t1,s1
4000688c:	00000793          	li	a5,0
40006890:	fff60613          	addi	a2,a2,-1 # ffff <_heap_size+0xdfff>
40006894:	0080006f          	j	4000689c <__mdiff+0xd4>
40006898:	00080313          	mv	t1,a6
4000689c:	00032703          	lw	a4,0(t1)
400068a0:	0008a803          	lw	a6,0(a7)
400068a4:	00458593          	addi	a1,a1,4
400068a8:	00c776b3          	and	a3,a4,a2
400068ac:	00f686b3          	add	a3,a3,a5
400068b0:	00c877b3          	and	a5,a6,a2
400068b4:	40f686b3          	sub	a3,a3,a5
400068b8:	01085813          	srli	a6,a6,0x10
400068bc:	01075793          	srli	a5,a4,0x10
400068c0:	410787b3          	sub	a5,a5,a6
400068c4:	4106d713          	srai	a4,a3,0x10
400068c8:	00e787b3          	add	a5,a5,a4
400068cc:	01079713          	slli	a4,a5,0x10
400068d0:	00c6f6b3          	and	a3,a3,a2
400068d4:	00d766b3          	or	a3,a4,a3
400068d8:	00488893          	addi	a7,a7,4
400068dc:	fed5ae23          	sw	a3,-4(a1)
400068e0:	00430813          	addi	a6,t1,4
400068e4:	4107d793          	srai	a5,a5,0x10
400068e8:	fbe8e8e3          	bltu	a7,t5,40006898 <__mdiff+0xd0>
400068ec:	05d87e63          	bleu	t4,a6,40006948 <__mdiff+0x180>
400068f0:	00010f37          	lui	t5,0x10
400068f4:	00058893          	mv	a7,a1
400068f8:	ffff0f13          	addi	t5,t5,-1 # ffff <_heap_size+0xdfff>
400068fc:	00082703          	lw	a4,0(a6)
40006900:	00488893          	addi	a7,a7,4
40006904:	00480813          	addi	a6,a6,4
40006908:	01e77633          	and	a2,a4,t5
4000690c:	00f60633          	add	a2,a2,a5
40006910:	41065693          	srai	a3,a2,0x10
40006914:	01075793          	srli	a5,a4,0x10
40006918:	00d787b3          	add	a5,a5,a3
4000691c:	01079693          	slli	a3,a5,0x10
40006920:	01e67633          	and	a2,a2,t5
40006924:	00c6e6b3          	or	a3,a3,a2
40006928:	fed8ae23          	sw	a3,-4(a7)
4000692c:	4107d793          	srai	a5,a5,0x10
40006930:	fdd866e3          	bltu	a6,t4,400068fc <__mdiff+0x134>
40006934:	406e87b3          	sub	a5,t4,t1
40006938:	ffb78793          	addi	a5,a5,-5
4000693c:	ffc7f793          	andi	a5,a5,-4
40006940:	00478793          	addi	a5,a5,4
40006944:	00f585b3          	add	a1,a1,a5
40006948:	ffc58593          	addi	a1,a1,-4
4000694c:	00069a63          	bnez	a3,40006960 <__mdiff+0x198>
40006950:	ffc58593          	addi	a1,a1,-4
40006954:	0005a783          	lw	a5,0(a1)
40006958:	fffe0e13          	addi	t3,t3,-1
4000695c:	fe078ae3          	beqz	a5,40006950 <__mdiff+0x188>
40006960:	01c12083          	lw	ra,28(sp)
40006964:	01812403          	lw	s0,24(sp)
40006968:	01412483          	lw	s1,20(sp)
4000696c:	01012903          	lw	s2,16(sp)
40006970:	00c12983          	lw	s3,12(sp)
40006974:	00812a03          	lw	s4,8(sp)
40006978:	01c52823          	sw	t3,16(a0)
4000697c:	02010113          	addi	sp,sp,32
40006980:	00008067          	ret
40006984:	00000593          	li	a1,0
40006988:	c88ff0ef          	jal	ra,40005e10 <_Balloc>
4000698c:	01c12083          	lw	ra,28(sp)
40006990:	00100793          	li	a5,1
40006994:	01812403          	lw	s0,24(sp)
40006998:	01412483          	lw	s1,20(sp)
4000699c:	01012903          	lw	s2,16(sp)
400069a0:	00c12983          	lw	s3,12(sp)
400069a4:	00812a03          	lw	s4,8(sp)
400069a8:	00f52823          	sw	a5,16(a0)
400069ac:	00052a23          	sw	zero,20(a0)
400069b0:	02010113          	addi	sp,sp,32
400069b4:	00008067          	ret
400069b8:	00048413          	mv	s0,s1
400069bc:	00030493          	mv	s1,t1
400069c0:	e99ff06f          	j	40006858 <__mdiff+0x90>
400069c4:	01460493          	addi	s1,a2,20
400069c8:	01458413          	addi	s0,a1,20
400069cc:	00100913          	li	s2,1
400069d0:	00060993          	mv	s3,a2
400069d4:	00058a13          	mv	s4,a1
400069d8:	e81ff06f          	j	40006858 <__mdiff+0x90>

400069dc <__ulp>:
400069dc:	7ff007b7          	lui	a5,0x7ff00
400069e0:	00b7f5b3          	and	a1,a5,a1
400069e4:	fcc007b7          	lui	a5,0xfcc00
400069e8:	00f585b3          	add	a1,a1,a5
400069ec:	00b05863          	blez	a1,400069fc <__ulp+0x20>
400069f0:	00000793          	li	a5,0
400069f4:	00078513          	mv	a0,a5
400069f8:	00008067          	ret
400069fc:	40b005b3          	neg	a1,a1
40006a00:	4145d593          	srai	a1,a1,0x14
40006a04:	01300793          	li	a5,19
40006a08:	02b7d463          	ble	a1,a5,40006a30 <__ulp+0x54>
40006a0c:	fec58713          	addi	a4,a1,-20
40006a10:	01e00693          	li	a3,30
40006a14:	00000593          	li	a1,0
40006a18:	00100793          	li	a5,1
40006a1c:	fce6cce3          	blt	a3,a4,400069f4 <__ulp+0x18>
40006a20:	fff74713          	not	a4,a4
40006a24:	00e797b3          	sll	a5,a5,a4
40006a28:	00078513          	mv	a0,a5
40006a2c:	00008067          	ret
40006a30:	000807b7          	lui	a5,0x80
40006a34:	40b7d5b3          	sra	a1,a5,a1
40006a38:	fb9ff06f          	j	400069f0 <__ulp+0x14>

40006a3c <__b2d>:
40006a3c:	fe010113          	addi	sp,sp,-32
40006a40:	00812c23          	sw	s0,24(sp)
40006a44:	01052403          	lw	s0,16(a0)
40006a48:	00912a23          	sw	s1,20(sp)
40006a4c:	01450493          	addi	s1,a0,20
40006a50:	00241413          	slli	s0,s0,0x2
40006a54:	00848433          	add	s0,s1,s0
40006a58:	01212823          	sw	s2,16(sp)
40006a5c:	ffc42903          	lw	s2,-4(s0)
40006a60:	01312623          	sw	s3,12(sp)
40006a64:	01412423          	sw	s4,8(sp)
40006a68:	00090513          	mv	a0,s2
40006a6c:	00058a13          	mv	s4,a1
40006a70:	00112e23          	sw	ra,28(sp)
40006a74:	eb8ff0ef          	jal	ra,4000612c <__hi0bits>
40006a78:	02000713          	li	a4,32
40006a7c:	40a707b3          	sub	a5,a4,a0
40006a80:	00fa2023          	sw	a5,0(s4)
40006a84:	00a00793          	li	a5,10
40006a88:	ffc40993          	addi	s3,s0,-4
40006a8c:	04a7ce63          	blt	a5,a0,40006ae8 <__b2d+0xac>
40006a90:	00b00693          	li	a3,11
40006a94:	40a686b3          	sub	a3,a3,a0
40006a98:	3ff007b7          	lui	a5,0x3ff00
40006a9c:	00d95733          	srl	a4,s2,a3
40006aa0:	00f76733          	or	a4,a4,a5
40006aa4:	00000793          	li	a5,0
40006aa8:	0134f663          	bleu	s3,s1,40006ab4 <__b2d+0x78>
40006aac:	ff842783          	lw	a5,-8(s0)
40006ab0:	00d7d7b3          	srl	a5,a5,a3
40006ab4:	01550513          	addi	a0,a0,21
40006ab8:	00a91533          	sll	a0,s2,a0
40006abc:	00f567b3          	or	a5,a0,a5
40006ac0:	01c12083          	lw	ra,28(sp)
40006ac4:	00078513          	mv	a0,a5
40006ac8:	00070593          	mv	a1,a4
40006acc:	01812403          	lw	s0,24(sp)
40006ad0:	01412483          	lw	s1,20(sp)
40006ad4:	01012903          	lw	s2,16(sp)
40006ad8:	00c12983          	lw	s3,12(sp)
40006adc:	00812a03          	lw	s4,8(sp)
40006ae0:	02010113          	addi	sp,sp,32
40006ae4:	00008067          	ret
40006ae8:	ff550513          	addi	a0,a0,-11
40006aec:	0534f063          	bleu	s3,s1,40006b2c <__b2d+0xf0>
40006af0:	ff842783          	lw	a5,-8(s0)
40006af4:	04050063          	beqz	a0,40006b34 <__b2d+0xf8>
40006af8:	40a706b3          	sub	a3,a4,a0
40006afc:	00a91933          	sll	s2,s2,a0
40006b00:	3ff00737          	lui	a4,0x3ff00
40006b04:	00e96933          	or	s2,s2,a4
40006b08:	ff840613          	addi	a2,s0,-8
40006b0c:	00d7d733          	srl	a4,a5,a3
40006b10:	00e96733          	or	a4,s2,a4
40006b14:	04c4f063          	bleu	a2,s1,40006b54 <__b2d+0x118>
40006b18:	ff442603          	lw	a2,-12(s0)
40006b1c:	00a797b3          	sll	a5,a5,a0
40006b20:	00d656b3          	srl	a3,a2,a3
40006b24:	00f6e7b3          	or	a5,a3,a5
40006b28:	f99ff06f          	j	40006ac0 <__b2d+0x84>
40006b2c:	00000793          	li	a5,0
40006b30:	00051863          	bnez	a0,40006b40 <__b2d+0x104>
40006b34:	3ff00737          	lui	a4,0x3ff00
40006b38:	00e96733          	or	a4,s2,a4
40006b3c:	f85ff06f          	j	40006ac0 <__b2d+0x84>
40006b40:	00a91533          	sll	a0,s2,a0
40006b44:	3ff00737          	lui	a4,0x3ff00
40006b48:	00e56733          	or	a4,a0,a4
40006b4c:	00000793          	li	a5,0
40006b50:	f71ff06f          	j	40006ac0 <__b2d+0x84>
40006b54:	00a797b3          	sll	a5,a5,a0
40006b58:	f69ff06f          	j	40006ac0 <__b2d+0x84>

40006b5c <__d2b>:
40006b5c:	fd010113          	addi	sp,sp,-48
40006b60:	00100593          	li	a1,1
40006b64:	02812423          	sw	s0,40(sp)
40006b68:	02912223          	sw	s1,36(sp)
40006b6c:	00068413          	mv	s0,a3
40006b70:	03212023          	sw	s2,32(sp)
40006b74:	01312e23          	sw	s3,28(sp)
40006b78:	01412c23          	sw	s4,24(sp)
40006b7c:	01512a23          	sw	s5,20(sp)
40006b80:	00070a13          	mv	s4,a4
40006b84:	00060a93          	mv	s5,a2
40006b88:	00078993          	mv	s3,a5
40006b8c:	02112623          	sw	ra,44(sp)
40006b90:	a80ff0ef          	jal	ra,40005e10 <_Balloc>
40006b94:	00100737          	lui	a4,0x100
40006b98:	01445493          	srli	s1,s0,0x14
40006b9c:	fff70793          	addi	a5,a4,-1 # fffff <_heap_size+0xfdfff>
40006ba0:	7ff4f493          	andi	s1,s1,2047
40006ba4:	00050913          	mv	s2,a0
40006ba8:	000a8613          	mv	a2,s5
40006bac:	0087f6b3          	and	a3,a5,s0
40006bb0:	00048463          	beqz	s1,40006bb8 <__d2b+0x5c>
40006bb4:	00e6e6b3          	or	a3,a3,a4
40006bb8:	00d12623          	sw	a3,12(sp)
40006bbc:	08060263          	beqz	a2,40006c40 <__d2b+0xe4>
40006bc0:	00810513          	addi	a0,sp,8
40006bc4:	01512423          	sw	s5,8(sp)
40006bc8:	dd8ff0ef          	jal	ra,400061a0 <__lo0bits>
40006bcc:	00050793          	mv	a5,a0
40006bd0:	00c12703          	lw	a4,12(sp)
40006bd4:	0a051463          	bnez	a0,40006c7c <__d2b+0x120>
40006bd8:	00812683          	lw	a3,8(sp)
40006bdc:	00d92a23          	sw	a3,20(s2)
40006be0:	00e03433          	snez	s0,a4
40006be4:	00140413          	addi	s0,s0,1
40006be8:	00e92c23          	sw	a4,24(s2)
40006bec:	00892823          	sw	s0,16(s2)
40006bf0:	06049863          	bnez	s1,40006c60 <__d2b+0x104>
40006bf4:	00241713          	slli	a4,s0,0x2
40006bf8:	00e90733          	add	a4,s2,a4
40006bfc:	01072503          	lw	a0,16(a4)
40006c00:	bce78793          	addi	a5,a5,-1074 # 3feffbce <_heap_size+0x3fefdbce>
40006c04:	00fa2023          	sw	a5,0(s4)
40006c08:	d24ff0ef          	jal	ra,4000612c <__hi0bits>
40006c0c:	00541413          	slli	s0,s0,0x5
40006c10:	40a40433          	sub	s0,s0,a0
40006c14:	0089a023          	sw	s0,0(s3)
40006c18:	02c12083          	lw	ra,44(sp)
40006c1c:	00090513          	mv	a0,s2
40006c20:	02812403          	lw	s0,40(sp)
40006c24:	02412483          	lw	s1,36(sp)
40006c28:	02012903          	lw	s2,32(sp)
40006c2c:	01c12983          	lw	s3,28(sp)
40006c30:	01812a03          	lw	s4,24(sp)
40006c34:	01412a83          	lw	s5,20(sp)
40006c38:	03010113          	addi	sp,sp,48
40006c3c:	00008067          	ret
40006c40:	00c10513          	addi	a0,sp,12
40006c44:	d5cff0ef          	jal	ra,400061a0 <__lo0bits>
40006c48:	00c12783          	lw	a5,12(sp)
40006c4c:	00100413          	li	s0,1
40006c50:	00892823          	sw	s0,16(s2)
40006c54:	00f92a23          	sw	a5,20(s2)
40006c58:	02050793          	addi	a5,a0,32
40006c5c:	f8048ce3          	beqz	s1,40006bf4 <__d2b+0x98>
40006c60:	bcd48493          	addi	s1,s1,-1075
40006c64:	00f484b3          	add	s1,s1,a5
40006c68:	03500713          	li	a4,53
40006c6c:	009a2023          	sw	s1,0(s4)
40006c70:	40f707b3          	sub	a5,a4,a5
40006c74:	00f9a023          	sw	a5,0(s3)
40006c78:	fa1ff06f          	j	40006c18 <__d2b+0xbc>
40006c7c:	02000693          	li	a3,32
40006c80:	00812603          	lw	a2,8(sp)
40006c84:	40a686b3          	sub	a3,a3,a0
40006c88:	00d716b3          	sll	a3,a4,a3
40006c8c:	00c6e6b3          	or	a3,a3,a2
40006c90:	00a75733          	srl	a4,a4,a0
40006c94:	00d92a23          	sw	a3,20(s2)
40006c98:	00e12623          	sw	a4,12(sp)
40006c9c:	f45ff06f          	j	40006be0 <__d2b+0x84>

40006ca0 <__ratio>:
40006ca0:	fd010113          	addi	sp,sp,-48
40006ca4:	03212023          	sw	s2,32(sp)
40006ca8:	00058913          	mv	s2,a1
40006cac:	00810593          	addi	a1,sp,8
40006cb0:	02112623          	sw	ra,44(sp)
40006cb4:	02812423          	sw	s0,40(sp)
40006cb8:	02912223          	sw	s1,36(sp)
40006cbc:	01312e23          	sw	s3,28(sp)
40006cc0:	00050993          	mv	s3,a0
40006cc4:	d79ff0ef          	jal	ra,40006a3c <__b2d>
40006cc8:	00050493          	mv	s1,a0
40006ccc:	00058413          	mv	s0,a1
40006cd0:	00090513          	mv	a0,s2
40006cd4:	00c10593          	addi	a1,sp,12
40006cd8:	d65ff0ef          	jal	ra,40006a3c <__b2d>
40006cdc:	01092783          	lw	a5,16(s2)
40006ce0:	0109a703          	lw	a4,16(s3)
40006ce4:	00812683          	lw	a3,8(sp)
40006ce8:	40f70733          	sub	a4,a4,a5
40006cec:	00c12783          	lw	a5,12(sp)
40006cf0:	00571713          	slli	a4,a4,0x5
40006cf4:	40f686b3          	sub	a3,a3,a5
40006cf8:	00d707b3          	add	a5,a4,a3
40006cfc:	02f05e63          	blez	a5,40006d38 <__ratio+0x98>
40006d00:	01479793          	slli	a5,a5,0x14
40006d04:	00878433          	add	s0,a5,s0
40006d08:	00050613          	mv	a2,a0
40006d0c:	00058693          	mv	a3,a1
40006d10:	00048513          	mv	a0,s1
40006d14:	00040593          	mv	a1,s0
40006d18:	25d030ef          	jal	ra,4000a774 <__divdf3>
40006d1c:	02c12083          	lw	ra,44(sp)
40006d20:	02812403          	lw	s0,40(sp)
40006d24:	02412483          	lw	s1,36(sp)
40006d28:	02012903          	lw	s2,32(sp)
40006d2c:	01c12983          	lw	s3,28(sp)
40006d30:	03010113          	addi	sp,sp,48
40006d34:	00008067          	ret
40006d38:	01479713          	slli	a4,a5,0x14
40006d3c:	40e585b3          	sub	a1,a1,a4
40006d40:	fc9ff06f          	j	40006d08 <__ratio+0x68>

40006d44 <_mprec_log10>:
40006d44:	ff010113          	addi	sp,sp,-16
40006d48:	00812423          	sw	s0,8(sp)
40006d4c:	00112623          	sw	ra,12(sp)
40006d50:	01212223          	sw	s2,4(sp)
40006d54:	01312023          	sw	s3,0(sp)
40006d58:	01700793          	li	a5,23
40006d5c:	00050413          	mv	s0,a0
40006d60:	04a7d463          	ble	a0,a5,40006da8 <_mprec_log10+0x64>
40006d64:	4000e7b7          	lui	a5,0x4000e
40006d68:	c687a503          	lw	a0,-920(a5) # 4000dc68 <__clz_tab+0x134>
40006d6c:	c6c7a583          	lw	a1,-916(a5)
40006d70:	4000e7b7          	lui	a5,0x4000e
40006d74:	c707a903          	lw	s2,-912(a5) # 4000dc70 <__clz_tab+0x13c>
40006d78:	c747a983          	lw	s3,-908(a5)
40006d7c:	fff40413          	addi	s0,s0,-1
40006d80:	00090613          	mv	a2,s2
40006d84:	00098693          	mv	a3,s3
40006d88:	5d8040ef          	jal	ra,4000b360 <__muldf3>
40006d8c:	fe0418e3          	bnez	s0,40006d7c <_mprec_log10+0x38>
40006d90:	00c12083          	lw	ra,12(sp)
40006d94:	00812403          	lw	s0,8(sp)
40006d98:	00412903          	lw	s2,4(sp)
40006d9c:	00012983          	lw	s3,0(sp)
40006da0:	01010113          	addi	sp,sp,16
40006da4:	00008067          	ret
40006da8:	4000d7b7          	lui	a5,0x4000d
40006dac:	00c12083          	lw	ra,12(sp)
40006db0:	00351413          	slli	s0,a0,0x3
40006db4:	78878793          	addi	a5,a5,1928 # 4000d788 <p05.2481>
40006db8:	00878433          	add	s0,a5,s0
40006dbc:	01042503          	lw	a0,16(s0)
40006dc0:	01442583          	lw	a1,20(s0)
40006dc4:	00412903          	lw	s2,4(sp)
40006dc8:	00812403          	lw	s0,8(sp)
40006dcc:	00012983          	lw	s3,0(sp)
40006dd0:	01010113          	addi	sp,sp,16
40006dd4:	00008067          	ret

40006dd8 <__copybits>:
40006dd8:	01062683          	lw	a3,16(a2)
40006ddc:	fff58813          	addi	a6,a1,-1
40006de0:	40585813          	srai	a6,a6,0x5
40006de4:	00180813          	addi	a6,a6,1
40006de8:	01460793          	addi	a5,a2,20
40006dec:	00269693          	slli	a3,a3,0x2
40006df0:	00281813          	slli	a6,a6,0x2
40006df4:	00d786b3          	add	a3,a5,a3
40006df8:	01050833          	add	a6,a0,a6
40006dfc:	02d7f863          	bleu	a3,a5,40006e2c <__copybits+0x54>
40006e00:	00050713          	mv	a4,a0
40006e04:	00478793          	addi	a5,a5,4
40006e08:	ffc7a583          	lw	a1,-4(a5)
40006e0c:	00470713          	addi	a4,a4,4
40006e10:	feb72e23          	sw	a1,-4(a4)
40006e14:	fed7e8e3          	bltu	a5,a3,40006e04 <__copybits+0x2c>
40006e18:	40c687b3          	sub	a5,a3,a2
40006e1c:	feb78793          	addi	a5,a5,-21
40006e20:	ffc7f793          	andi	a5,a5,-4
40006e24:	00478793          	addi	a5,a5,4
40006e28:	00f50533          	add	a0,a0,a5
40006e2c:	01057863          	bleu	a6,a0,40006e3c <__copybits+0x64>
40006e30:	00450513          	addi	a0,a0,4
40006e34:	fe052e23          	sw	zero,-4(a0)
40006e38:	ff056ce3          	bltu	a0,a6,40006e30 <__copybits+0x58>
40006e3c:	00008067          	ret

40006e40 <__any_on>:
40006e40:	01052783          	lw	a5,16(a0)
40006e44:	4055d713          	srai	a4,a1,0x5
40006e48:	01450693          	addi	a3,a0,20
40006e4c:	02e7da63          	ble	a4,a5,40006e80 <__any_on+0x40>
40006e50:	00279793          	slli	a5,a5,0x2
40006e54:	00f687b3          	add	a5,a3,a5
40006e58:	06f6f263          	bleu	a5,a3,40006ebc <__any_on+0x7c>
40006e5c:	ffc7a503          	lw	a0,-4(a5)
40006e60:	ffc78793          	addi	a5,a5,-4
40006e64:	00051a63          	bnez	a0,40006e78 <__any_on+0x38>
40006e68:	04f6f863          	bleu	a5,a3,40006eb8 <__any_on+0x78>
40006e6c:	ffc78793          	addi	a5,a5,-4
40006e70:	0007a703          	lw	a4,0(a5)
40006e74:	fe070ae3          	beqz	a4,40006e68 <__any_on+0x28>
40006e78:	00100513          	li	a0,1
40006e7c:	00008067          	ret
40006e80:	02f75663          	ble	a5,a4,40006eac <__any_on+0x6c>
40006e84:	00271793          	slli	a5,a4,0x2
40006e88:	01f5f593          	andi	a1,a1,31
40006e8c:	00f687b3          	add	a5,a3,a5
40006e90:	fc0584e3          	beqz	a1,40006e58 <__any_on+0x18>
40006e94:	0007a603          	lw	a2,0(a5)
40006e98:	00100513          	li	a0,1
40006e9c:	00b65733          	srl	a4,a2,a1
40006ea0:	00b715b3          	sll	a1,a4,a1
40006ea4:	fab60ae3          	beq	a2,a1,40006e58 <__any_on+0x18>
40006ea8:	00008067          	ret
40006eac:	00271793          	slli	a5,a4,0x2
40006eb0:	00f687b3          	add	a5,a3,a5
40006eb4:	fa5ff06f          	j	40006e58 <__any_on+0x18>
40006eb8:	00008067          	ret
40006ebc:	00000513          	li	a0,0
40006ec0:	00008067          	ret

40006ec4 <cleanup_glue>:
40006ec4:	ff010113          	addi	sp,sp,-16
40006ec8:	00812423          	sw	s0,8(sp)
40006ecc:	00058413          	mv	s0,a1
40006ed0:	0005a583          	lw	a1,0(a1)
40006ed4:	00912223          	sw	s1,4(sp)
40006ed8:	00112623          	sw	ra,12(sp)
40006edc:	00050493          	mv	s1,a0
40006ee0:	00058463          	beqz	a1,40006ee8 <cleanup_glue+0x24>
40006ee4:	fe1ff0ef          	jal	ra,40006ec4 <cleanup_glue>
40006ee8:	00040593          	mv	a1,s0
40006eec:	00048513          	mv	a0,s1
40006ef0:	00c12083          	lw	ra,12(sp)
40006ef4:	00812403          	lw	s0,8(sp)
40006ef8:	00412483          	lw	s1,4(sp)
40006efc:	01010113          	addi	sp,sp,16
40006f00:	e44fe06f          	j	40005544 <_free_r>

40006f04 <_reclaim_reent>:
40006f04:	4000e7b7          	lui	a5,0x4000e
40006f08:	5847a783          	lw	a5,1412(a5) # 4000e584 <_impure_ptr>
40006f0c:	0ca78663          	beq	a5,a0,40006fd8 <_reclaim_reent+0xd4>
40006f10:	04c52703          	lw	a4,76(a0)
40006f14:	fe010113          	addi	sp,sp,-32
40006f18:	00912a23          	sw	s1,20(sp)
40006f1c:	00112e23          	sw	ra,28(sp)
40006f20:	00812c23          	sw	s0,24(sp)
40006f24:	01212823          	sw	s2,16(sp)
40006f28:	01312623          	sw	s3,12(sp)
40006f2c:	00050493          	mv	s1,a0
40006f30:	04070263          	beqz	a4,40006f74 <_reclaim_reent+0x70>
40006f34:	00000913          	li	s2,0
40006f38:	08000993          	li	s3,128
40006f3c:	012707b3          	add	a5,a4,s2
40006f40:	0007a583          	lw	a1,0(a5)
40006f44:	00058e63          	beqz	a1,40006f60 <_reclaim_reent+0x5c>
40006f48:	0005a403          	lw	s0,0(a1)
40006f4c:	00048513          	mv	a0,s1
40006f50:	df4fe0ef          	jal	ra,40005544 <_free_r>
40006f54:	00040593          	mv	a1,s0
40006f58:	fe0418e3          	bnez	s0,40006f48 <_reclaim_reent+0x44>
40006f5c:	04c4a703          	lw	a4,76(s1)
40006f60:	00490913          	addi	s2,s2,4
40006f64:	fd391ce3          	bne	s2,s3,40006f3c <_reclaim_reent+0x38>
40006f68:	00070593          	mv	a1,a4
40006f6c:	00048513          	mv	a0,s1
40006f70:	dd4fe0ef          	jal	ra,40005544 <_free_r>
40006f74:	0404a583          	lw	a1,64(s1)
40006f78:	00058663          	beqz	a1,40006f84 <_reclaim_reent+0x80>
40006f7c:	00048513          	mv	a0,s1
40006f80:	dc4fe0ef          	jal	ra,40005544 <_free_r>
40006f84:	1484a583          	lw	a1,328(s1)
40006f88:	02058063          	beqz	a1,40006fa8 <_reclaim_reent+0xa4>
40006f8c:	14c48913          	addi	s2,s1,332
40006f90:	01258c63          	beq	a1,s2,40006fa8 <_reclaim_reent+0xa4>
40006f94:	0005a403          	lw	s0,0(a1)
40006f98:	00048513          	mv	a0,s1
40006f9c:	da8fe0ef          	jal	ra,40005544 <_free_r>
40006fa0:	00040593          	mv	a1,s0
40006fa4:	fe8918e3          	bne	s2,s0,40006f94 <_reclaim_reent+0x90>
40006fa8:	0544a583          	lw	a1,84(s1)
40006fac:	00058663          	beqz	a1,40006fb8 <_reclaim_reent+0xb4>
40006fb0:	00048513          	mv	a0,s1
40006fb4:	d90fe0ef          	jal	ra,40005544 <_free_r>
40006fb8:	0384a783          	lw	a5,56(s1)
40006fbc:	02079063          	bnez	a5,40006fdc <_reclaim_reent+0xd8>
40006fc0:	01c12083          	lw	ra,28(sp)
40006fc4:	01812403          	lw	s0,24(sp)
40006fc8:	01412483          	lw	s1,20(sp)
40006fcc:	01012903          	lw	s2,16(sp)
40006fd0:	00c12983          	lw	s3,12(sp)
40006fd4:	02010113          	addi	sp,sp,32
40006fd8:	00008067          	ret
40006fdc:	03c4a783          	lw	a5,60(s1)
40006fe0:	00048513          	mv	a0,s1
40006fe4:	000780e7          	jalr	a5
40006fe8:	2e04a583          	lw	a1,736(s1)
40006fec:	fc058ae3          	beqz	a1,40006fc0 <_reclaim_reent+0xbc>
40006ff0:	00048513          	mv	a0,s1
40006ff4:	01c12083          	lw	ra,28(sp)
40006ff8:	01812403          	lw	s0,24(sp)
40006ffc:	01412483          	lw	s1,20(sp)
40007000:	01012903          	lw	s2,16(sp)
40007004:	00c12983          	lw	s3,12(sp)
40007008:	02010113          	addi	sp,sp,32
4000700c:	eb9ff06f          	j	40006ec4 <cleanup_glue>

40007010 <__sread>:
40007010:	ff010113          	addi	sp,sp,-16
40007014:	00812423          	sw	s0,8(sp)
40007018:	00058413          	mv	s0,a1
4000701c:	00e59583          	lh	a1,14(a1)
40007020:	00112623          	sw	ra,12(sp)
40007024:	645010ef          	jal	ra,40008e68 <_read_r>
40007028:	02054063          	bltz	a0,40007048 <__sread+0x38>
4000702c:	05042783          	lw	a5,80(s0)
40007030:	00c12083          	lw	ra,12(sp)
40007034:	00a787b3          	add	a5,a5,a0
40007038:	04f42823          	sw	a5,80(s0)
4000703c:	00812403          	lw	s0,8(sp)
40007040:	01010113          	addi	sp,sp,16
40007044:	00008067          	ret
40007048:	00c45783          	lhu	a5,12(s0)
4000704c:	fffff737          	lui	a4,0xfffff
40007050:	00c12083          	lw	ra,12(sp)
40007054:	fff70713          	addi	a4,a4,-1 # ffffefff <end+0xbffee21f>
40007058:	00e7f7b3          	and	a5,a5,a4
4000705c:	00f41623          	sh	a5,12(s0)
40007060:	00812403          	lw	s0,8(sp)
40007064:	01010113          	addi	sp,sp,16
40007068:	00008067          	ret

4000706c <__seofread>:
4000706c:	00000513          	li	a0,0
40007070:	00008067          	ret

40007074 <__swrite>:
40007074:	00c59783          	lh	a5,12(a1)
40007078:	fe010113          	addi	sp,sp,-32
4000707c:	00812c23          	sw	s0,24(sp)
40007080:	00912a23          	sw	s1,20(sp)
40007084:	01212823          	sw	s2,16(sp)
40007088:	01312623          	sw	s3,12(sp)
4000708c:	00112e23          	sw	ra,28(sp)
40007090:	1007f713          	andi	a4,a5,256
40007094:	00058413          	mv	s0,a1
40007098:	00050493          	mv	s1,a0
4000709c:	00060913          	mv	s2,a2
400070a0:	00068993          	mv	s3,a3
400070a4:	00070c63          	beqz	a4,400070bc <__swrite+0x48>
400070a8:	00e59583          	lh	a1,14(a1)
400070ac:	00200693          	li	a3,2
400070b0:	00000613          	li	a2,0
400070b4:	42d010ef          	jal	ra,40008ce0 <_lseek_r>
400070b8:	00c41783          	lh	a5,12(s0)
400070bc:	fffff737          	lui	a4,0xfffff
400070c0:	fff70713          	addi	a4,a4,-1 # ffffefff <end+0xbffee21f>
400070c4:	00e7f7b3          	and	a5,a5,a4
400070c8:	00e41583          	lh	a1,14(s0)
400070cc:	00f41623          	sh	a5,12(s0)
400070d0:	00098693          	mv	a3,s3
400070d4:	00090613          	mv	a2,s2
400070d8:	00048513          	mv	a0,s1
400070dc:	01c12083          	lw	ra,28(sp)
400070e0:	01812403          	lw	s0,24(sp)
400070e4:	01412483          	lw	s1,20(sp)
400070e8:	01012903          	lw	s2,16(sp)
400070ec:	00c12983          	lw	s3,12(sp)
400070f0:	02010113          	addi	sp,sp,32
400070f4:	1f40106f          	j	400082e8 <_write_r>

400070f8 <__sseek>:
400070f8:	ff010113          	addi	sp,sp,-16
400070fc:	00812423          	sw	s0,8(sp)
40007100:	00058413          	mv	s0,a1
40007104:	00e59583          	lh	a1,14(a1)
40007108:	00070693          	mv	a3,a4
4000710c:	00112623          	sw	ra,12(sp)
40007110:	3d1010ef          	jal	ra,40008ce0 <_lseek_r>
40007114:	fff00793          	li	a5,-1
40007118:	02f50663          	beq	a0,a5,40007144 <__sseek+0x4c>
4000711c:	00c45783          	lhu	a5,12(s0)
40007120:	00c12083          	lw	ra,12(sp)
40007124:	00001737          	lui	a4,0x1
40007128:	00e7e7b3          	or	a5,a5,a4
4000712c:	04a42823          	sw	a0,80(s0)
40007130:	00f41623          	sh	a5,12(s0)
40007134:	41f55593          	srai	a1,a0,0x1f
40007138:	00812403          	lw	s0,8(sp)
4000713c:	01010113          	addi	sp,sp,16
40007140:	00008067          	ret
40007144:	00c45783          	lhu	a5,12(s0)
40007148:	fffff737          	lui	a4,0xfffff
4000714c:	00c12083          	lw	ra,12(sp)
40007150:	fff70713          	addi	a4,a4,-1 # ffffefff <end+0xbffee21f>
40007154:	00e7f7b3          	and	a5,a5,a4
40007158:	00f41623          	sh	a5,12(s0)
4000715c:	41f55593          	srai	a1,a0,0x1f
40007160:	00812403          	lw	s0,8(sp)
40007164:	01010113          	addi	sp,sp,16
40007168:	00008067          	ret

4000716c <__sclose>:
4000716c:	00e59583          	lh	a1,14(a1)
40007170:	2a80106f          	j	40008418 <_close_r>

40007174 <strlen>:
40007174:	00357713          	andi	a4,a0,3
40007178:	00050793          	mv	a5,a0
4000717c:	00050693          	mv	a3,a0
40007180:	04071c63          	bnez	a4,400071d8 <strlen+0x64>
40007184:	7f7f8637          	lui	a2,0x7f7f8
40007188:	f7f60613          	addi	a2,a2,-129 # 7f7f7f7f <end+0x3f7e719f>
4000718c:	fff00593          	li	a1,-1
40007190:	00468693          	addi	a3,a3,4
40007194:	ffc6a703          	lw	a4,-4(a3)
40007198:	00c777b3          	and	a5,a4,a2
4000719c:	00c787b3          	add	a5,a5,a2
400071a0:	00c76733          	or	a4,a4,a2
400071a4:	00e7e7b3          	or	a5,a5,a4
400071a8:	feb784e3          	beq	a5,a1,40007190 <strlen+0x1c>
400071ac:	ffc6c703          	lbu	a4,-4(a3)
400071b0:	40a687b3          	sub	a5,a3,a0
400071b4:	ffd6c603          	lbu	a2,-3(a3)
400071b8:	ffe6c503          	lbu	a0,-2(a3)
400071bc:	04070063          	beqz	a4,400071fc <strlen+0x88>
400071c0:	02060a63          	beqz	a2,400071f4 <strlen+0x80>
400071c4:	00a03533          	snez	a0,a0
400071c8:	00f50533          	add	a0,a0,a5
400071cc:	ffe50513          	addi	a0,a0,-2
400071d0:	00008067          	ret
400071d4:	02068863          	beqz	a3,40007204 <strlen+0x90>
400071d8:	0007c703          	lbu	a4,0(a5)
400071dc:	00178793          	addi	a5,a5,1
400071e0:	0037f693          	andi	a3,a5,3
400071e4:	fe0718e3          	bnez	a4,400071d4 <strlen+0x60>
400071e8:	40a787b3          	sub	a5,a5,a0
400071ec:	fff78513          	addi	a0,a5,-1
400071f0:	00008067          	ret
400071f4:	ffd78513          	addi	a0,a5,-3
400071f8:	00008067          	ret
400071fc:	ffc78513          	addi	a0,a5,-4
40007200:	00008067          	ret
40007204:	00078693          	mv	a3,a5
40007208:	f7dff06f          	j	40007184 <strlen+0x10>

4000720c <__sprint_r.part.0>:
4000720c:	0645a783          	lw	a5,100(a1)
40007210:	fd010113          	addi	sp,sp,-48
40007214:	01612823          	sw	s6,16(sp)
40007218:	02112623          	sw	ra,44(sp)
4000721c:	02812423          	sw	s0,40(sp)
40007220:	02912223          	sw	s1,36(sp)
40007224:	03212023          	sw	s2,32(sp)
40007228:	01312e23          	sw	s3,28(sp)
4000722c:	01412c23          	sw	s4,24(sp)
40007230:	01512a23          	sw	s5,20(sp)
40007234:	01712623          	sw	s7,12(sp)
40007238:	01812423          	sw	s8,8(sp)
4000723c:	01279713          	slli	a4,a5,0x12
40007240:	00060b13          	mv	s6,a2
40007244:	0a075863          	bgez	a4,400072f4 <__sprint_r.part.0+0xe8>
40007248:	00862783          	lw	a5,8(a2)
4000724c:	00058a13          	mv	s4,a1
40007250:	00050a93          	mv	s5,a0
40007254:	00062b83          	lw	s7,0(a2)
40007258:	fff00913          	li	s2,-1
4000725c:	08078863          	beqz	a5,400072ec <__sprint_r.part.0+0xe0>
40007260:	004bac03          	lw	s8,4(s7)
40007264:	000ba483          	lw	s1,0(s7)
40007268:	00000413          	li	s0,0
4000726c:	002c5993          	srli	s3,s8,0x2
40007270:	00099863          	bnez	s3,40007280 <__sprint_r.part.0+0x74>
40007274:	0640006f          	j	400072d8 <__sprint_r.part.0+0xcc>
40007278:	00448493          	addi	s1,s1,4
4000727c:	04898c63          	beq	s3,s0,400072d4 <__sprint_r.part.0+0xc8>
40007280:	0004a583          	lw	a1,0(s1)
40007284:	000a0613          	mv	a2,s4
40007288:	000a8513          	mv	a0,s5
4000728c:	430010ef          	jal	ra,400086bc <_fputwc_r>
40007290:	00140413          	addi	s0,s0,1
40007294:	ff2512e3          	bne	a0,s2,40007278 <__sprint_r.part.0+0x6c>
40007298:	00090513          	mv	a0,s2
4000729c:	02c12083          	lw	ra,44(sp)
400072a0:	000b2423          	sw	zero,8(s6)
400072a4:	000b2223          	sw	zero,4(s6)
400072a8:	02812403          	lw	s0,40(sp)
400072ac:	02412483          	lw	s1,36(sp)
400072b0:	02012903          	lw	s2,32(sp)
400072b4:	01c12983          	lw	s3,28(sp)
400072b8:	01812a03          	lw	s4,24(sp)
400072bc:	01412a83          	lw	s5,20(sp)
400072c0:	01012b03          	lw	s6,16(sp)
400072c4:	00c12b83          	lw	s7,12(sp)
400072c8:	00812c03          	lw	s8,8(sp)
400072cc:	03010113          	addi	sp,sp,48
400072d0:	00008067          	ret
400072d4:	008b2783          	lw	a5,8(s6)
400072d8:	ffcc7c13          	andi	s8,s8,-4
400072dc:	418787b3          	sub	a5,a5,s8
400072e0:	00fb2423          	sw	a5,8(s6)
400072e4:	008b8b93          	addi	s7,s7,8
400072e8:	f6079ce3          	bnez	a5,40007260 <__sprint_r.part.0+0x54>
400072ec:	00000513          	li	a0,0
400072f0:	fadff06f          	j	4000729c <__sprint_r.part.0+0x90>
400072f4:	4dc010ef          	jal	ra,400087d0 <__sfvwrite_r>
400072f8:	fa5ff06f          	j	4000729c <__sprint_r.part.0+0x90>

400072fc <__sprint_r>:
400072fc:	00862703          	lw	a4,8(a2)
40007300:	00070463          	beqz	a4,40007308 <__sprint_r+0xc>
40007304:	f09ff06f          	j	4000720c <__sprint_r.part.0>
40007308:	00062223          	sw	zero,4(a2)
4000730c:	00000513          	li	a0,0
40007310:	00008067          	ret

40007314 <_vfiprintf_r>:
40007314:	f1010113          	addi	sp,sp,-240
40007318:	0d312e23          	sw	s3,220(sp)
4000731c:	0d512a23          	sw	s5,212(sp)
40007320:	0d612823          	sw	s6,208(sp)
40007324:	0e112623          	sw	ra,236(sp)
40007328:	0e812423          	sw	s0,232(sp)
4000732c:	0e912223          	sw	s1,228(sp)
40007330:	0f212023          	sw	s2,224(sp)
40007334:	0d412c23          	sw	s4,216(sp)
40007338:	0d712623          	sw	s7,204(sp)
4000733c:	0d812423          	sw	s8,200(sp)
40007340:	0d912223          	sw	s9,196(sp)
40007344:	0da12023          	sw	s10,192(sp)
40007348:	0bb12e23          	sw	s11,188(sp)
4000734c:	00d12623          	sw	a3,12(sp)
40007350:	00050a93          	mv	s5,a0
40007354:	00058993          	mv	s3,a1
40007358:	00060b13          	mv	s6,a2
4000735c:	00050663          	beqz	a0,40007368 <_vfiprintf_r+0x54>
40007360:	03852783          	lw	a5,56(a0)
40007364:	24078a63          	beqz	a5,400075b8 <_vfiprintf_r+0x2a4>
40007368:	00c99703          	lh	a4,12(s3)
4000736c:	01071793          	slli	a5,a4,0x10
40007370:	0107d793          	srli	a5,a5,0x10
40007374:	01279693          	slli	a3,a5,0x12
40007378:	0206c663          	bltz	a3,400073a4 <_vfiprintf_r+0x90>
4000737c:	0649a683          	lw	a3,100(s3)
40007380:	000027b7          	lui	a5,0x2
40007384:	00f767b3          	or	a5,a4,a5
40007388:	ffffe737          	lui	a4,0xffffe
4000738c:	fff70713          	addi	a4,a4,-1 # ffffdfff <end+0xbffed21f>
40007390:	00e6f733          	and	a4,a3,a4
40007394:	00f99623          	sh	a5,12(s3)
40007398:	01079793          	slli	a5,a5,0x10
4000739c:	06e9a223          	sw	a4,100(s3)
400073a0:	0107d793          	srli	a5,a5,0x10
400073a4:	0087f713          	andi	a4,a5,8
400073a8:	18070863          	beqz	a4,40007538 <_vfiprintf_r+0x224>
400073ac:	0109a703          	lw	a4,16(s3)
400073b0:	18070463          	beqz	a4,40007538 <_vfiprintf_r+0x224>
400073b4:	01a7f793          	andi	a5,a5,26
400073b8:	00a00713          	li	a4,10
400073bc:	18e78e63          	beq	a5,a4,40007558 <_vfiprintf_r+0x244>
400073c0:	4000ebb7          	lui	s7,0x4000e
400073c4:	07010c13          	addi	s8,sp,112
400073c8:	8b0b8793          	addi	a5,s7,-1872 # 4000d8b0 <__mprec_bigtens+0x28>
400073cc:	4000e337          	lui	t1,0x4000e
400073d0:	4000e8b7          	lui	a7,0x4000e
400073d4:	03812e23          	sw	s8,60(sp)
400073d8:	04012223          	sw	zero,68(sp)
400073dc:	04012023          	sw	zero,64(sp)
400073e0:	000c0413          	mv	s0,s8
400073e4:	00012e23          	sw	zero,28(sp)
400073e8:	00012423          	sw	zero,8(sp)
400073ec:	00f12823          	sw	a5,16(sp)
400073f0:	a1430c93          	addi	s9,t1,-1516 # 4000da14 <blanks.4081>
400073f4:	a2488b93          	addi	s7,a7,-1500 # 4000da24 <zeroes.4082>
400073f8:	000b4783          	lbu	a5,0(s6)
400073fc:	48078ee3          	beqz	a5,40008098 <_vfiprintf_r+0xd84>
40007400:	02500713          	li	a4,37
40007404:	000b0493          	mv	s1,s6
40007408:	00e79663          	bne	a5,a4,40007414 <_vfiprintf_r+0x100>
4000740c:	0540006f          	j	40007460 <_vfiprintf_r+0x14c>
40007410:	00e78863          	beq	a5,a4,40007420 <_vfiprintf_r+0x10c>
40007414:	00148493          	addi	s1,s1,1
40007418:	0004c783          	lbu	a5,0(s1)
4000741c:	fe079ae3          	bnez	a5,40007410 <_vfiprintf_r+0xfc>
40007420:	41648933          	sub	s2,s1,s6
40007424:	02090e63          	beqz	s2,40007460 <_vfiprintf_r+0x14c>
40007428:	04412703          	lw	a4,68(sp)
4000742c:	04012783          	lw	a5,64(sp)
40007430:	01642023          	sw	s6,0(s0)
40007434:	00e90733          	add	a4,s2,a4
40007438:	00178793          	addi	a5,a5,1 # 2001 <_heap_size+0x1>
4000743c:	01242223          	sw	s2,4(s0)
40007440:	04e12223          	sw	a4,68(sp)
40007444:	04f12023          	sw	a5,64(sp)
40007448:	00700693          	li	a3,7
4000744c:	00840413          	addi	s0,s0,8
40007450:	06f6ca63          	blt	a3,a5,400074c4 <_vfiprintf_r+0x1b0>
40007454:	00812783          	lw	a5,8(sp)
40007458:	012787b3          	add	a5,a5,s2
4000745c:	00f12423          	sw	a5,8(sp)
40007460:	0004c783          	lbu	a5,0(s1)
40007464:	120788e3          	beqz	a5,40007d94 <_vfiprintf_r+0xa80>
40007468:	fff00693          	li	a3,-1
4000746c:	00148493          	addi	s1,s1,1
40007470:	02010ba3          	sb	zero,55(sp)
40007474:	00000e93          	li	t4,0
40007478:	00000f93          	li	t6,0
4000747c:	00000913          	li	s2,0
40007480:	00000f13          	li	t5,0
40007484:	05800593          	li	a1,88
40007488:	00900513          	li	a0,9
4000748c:	02a00a13          	li	s4,42
40007490:	00068d93          	mv	s11,a3
40007494:	00100293          	li	t0,1
40007498:	02000d13          	li	s10,32
4000749c:	02b00393          	li	t2,43
400074a0:	0004c703          	lbu	a4,0(s1)
400074a4:	00148b13          	addi	s6,s1,1
400074a8:	fe070793          	addi	a5,a4,-32
400074ac:	6cf5e463          	bltu	a1,a5,40007b74 <_vfiprintf_r+0x860>
400074b0:	01012603          	lw	a2,16(sp)
400074b4:	00279793          	slli	a5,a5,0x2
400074b8:	00c787b3          	add	a5,a5,a2
400074bc:	0007a783          	lw	a5,0(a5)
400074c0:	00078067          	jr	a5
400074c4:	300710e3          	bnez	a4,40007fc4 <_vfiprintf_r+0xcb0>
400074c8:	04012023          	sw	zero,64(sp)
400074cc:	000c0413          	mv	s0,s8
400074d0:	f85ff06f          	j	40007454 <_vfiprintf_r+0x140>
400074d4:	010f6f13          	ori	t5,t5,16
400074d8:	000b0493          	mv	s1,s6
400074dc:	fc5ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
400074e0:	010f6f13          	ori	t5,t5,16
400074e4:	010f7793          	andi	a5,t5,16
400074e8:	66079a63          	bnez	a5,40007b5c <_vfiprintf_r+0x848>
400074ec:	040f7793          	andi	a5,t5,64
400074f0:	00c12703          	lw	a4,12(sp)
400074f4:	66078663          	beqz	a5,40007b60 <_vfiprintf_r+0x84c>
400074f8:	00075483          	lhu	s1,0(a4)
400074fc:	00470713          	addi	a4,a4,4
40007500:	00100793          	li	a5,1
40007504:	00e12623          	sw	a4,12(sp)
40007508:	5b00006f          	j	40007ab8 <_vfiprintf_r+0x7a4>
4000750c:	010f6f13          	ori	t5,t5,16
40007510:	010f7793          	andi	a5,t5,16
40007514:	62079863          	bnez	a5,40007b44 <_vfiprintf_r+0x830>
40007518:	040f7793          	andi	a5,t5,64
4000751c:	00c12703          	lw	a4,12(sp)
40007520:	62078463          	beqz	a5,40007b48 <_vfiprintf_r+0x834>
40007524:	00075483          	lhu	s1,0(a4)
40007528:	00470713          	addi	a4,a4,4
4000752c:	00000793          	li	a5,0
40007530:	00e12623          	sw	a4,12(sp)
40007534:	5840006f          	j	40007ab8 <_vfiprintf_r+0x7a4>
40007538:	00098593          	mv	a1,s3
4000753c:	000a8513          	mv	a0,s5
40007540:	f25fb0ef          	jal	ra,40003464 <__swsetup_r>
40007544:	06051ae3          	bnez	a0,40007db8 <_vfiprintf_r+0xaa4>
40007548:	00c9d783          	lhu	a5,12(s3)
4000754c:	00a00713          	li	a4,10
40007550:	01a7f793          	andi	a5,a5,26
40007554:	e6e796e3          	bne	a5,a4,400073c0 <_vfiprintf_r+0xac>
40007558:	00e99783          	lh	a5,14(s3)
4000755c:	e607c2e3          	bltz	a5,400073c0 <_vfiprintf_r+0xac>
40007560:	00c12683          	lw	a3,12(sp)
40007564:	000b0613          	mv	a2,s6
40007568:	00098593          	mv	a1,s3
4000756c:	000a8513          	mv	a0,s5
40007570:	4b9000ef          	jal	ra,40008228 <__sbprintf>
40007574:	00a12423          	sw	a0,8(sp)
40007578:	0ec12083          	lw	ra,236(sp)
4000757c:	00812503          	lw	a0,8(sp)
40007580:	0e812403          	lw	s0,232(sp)
40007584:	0e412483          	lw	s1,228(sp)
40007588:	0e012903          	lw	s2,224(sp)
4000758c:	0dc12983          	lw	s3,220(sp)
40007590:	0d812a03          	lw	s4,216(sp)
40007594:	0d412a83          	lw	s5,212(sp)
40007598:	0d012b03          	lw	s6,208(sp)
4000759c:	0cc12b83          	lw	s7,204(sp)
400075a0:	0c812c03          	lw	s8,200(sp)
400075a4:	0c412c83          	lw	s9,196(sp)
400075a8:	0c012d03          	lw	s10,192(sp)
400075ac:	0bc12d83          	lw	s11,188(sp)
400075b0:	0f010113          	addi	sp,sp,240
400075b4:	00008067          	ret
400075b8:	e09fd0ef          	jal	ra,400053c0 <__sinit>
400075bc:	dadff06f          	j	40007368 <_vfiprintf_r+0x54>
400075c0:	00c12783          	lw	a5,12(sp)
400075c4:	0007a903          	lw	s2,0(a5)
400075c8:	00478793          	addi	a5,a5,4
400075cc:	00f12623          	sw	a5,12(sp)
400075d0:	f00954e3          	bgez	s2,400074d8 <_vfiprintf_r+0x1c4>
400075d4:	41200933          	neg	s2,s2
400075d8:	004f6f13          	ori	t5,t5,4
400075dc:	000b0493          	mv	s1,s6
400075e0:	ec1ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
400075e4:	00028e93          	mv	t4,t0
400075e8:	00038f93          	mv	t6,t2
400075ec:	000b0493          	mv	s1,s6
400075f0:	eb1ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
400075f4:	080f6f13          	ori	t5,t5,128
400075f8:	000b0493          	mv	s1,s6
400075fc:	ea5ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
40007600:	00000913          	li	s2,0
40007604:	fd070793          	addi	a5,a4,-48
40007608:	001b0b13          	addi	s6,s6,1
4000760c:	00291613          	slli	a2,s2,0x2
40007610:	fffb4703          	lbu	a4,-1(s6)
40007614:	01260933          	add	s2,a2,s2
40007618:	00191913          	slli	s2,s2,0x1
4000761c:	01278933          	add	s2,a5,s2
40007620:	fd070793          	addi	a5,a4,-48
40007624:	fef572e3          	bleu	a5,a0,40007608 <_vfiprintf_r+0x2f4>
40007628:	e81ff06f          	j	400074a8 <_vfiprintf_r+0x194>
4000762c:	000b4703          	lbu	a4,0(s6)
40007630:	001b0493          	addi	s1,s6,1
40007634:	394706e3          	beq	a4,s4,400081c0 <_vfiprintf_r+0xeac>
40007638:	fd070793          	addi	a5,a4,-48
4000763c:	00048b13          	mv	s6,s1
40007640:	00000693          	li	a3,0
40007644:	e6f562e3          	bltu	a0,a5,400074a8 <_vfiprintf_r+0x194>
40007648:	001b0b13          	addi	s6,s6,1
4000764c:	00269493          	slli	s1,a3,0x2
40007650:	fffb4703          	lbu	a4,-1(s6)
40007654:	00d484b3          	add	s1,s1,a3
40007658:	00149493          	slli	s1,s1,0x1
4000765c:	00f486b3          	add	a3,s1,a5
40007660:	fd070793          	addi	a5,a4,-48
40007664:	fef572e3          	bleu	a5,a0,40007648 <_vfiprintf_r+0x334>
40007668:	e41ff06f          	j	400074a8 <_vfiprintf_r+0x194>
4000766c:	360e9ee3          	bnez	t4,400081e8 <_vfiprintf_r+0xed4>
40007670:	010f7793          	andi	a5,t5,16
40007674:	200794e3          	bnez	a5,4000807c <_vfiprintf_r+0xd68>
40007678:	040f7f13          	andi	t5,t5,64
4000767c:	200f00e3          	beqz	t5,4000807c <_vfiprintf_r+0xd68>
40007680:	00c12703          	lw	a4,12(sp)
40007684:	00072783          	lw	a5,0(a4)
40007688:	00470713          	addi	a4,a4,4
4000768c:	00e12623          	sw	a4,12(sp)
40007690:	00815703          	lhu	a4,8(sp)
40007694:	00e79023          	sh	a4,0(a5)
40007698:	d61ff06f          	j	400073f8 <_vfiprintf_r+0xe4>
4000769c:	00c12783          	lw	a5,12(sp)
400076a0:	02010ba3          	sb	zero,55(sp)
400076a4:	0007ad03          	lw	s10,0(a5)
400076a8:	00478493          	addi	s1,a5,4
400076ac:	2c0d02e3          	beqz	s10,40008170 <_vfiprintf_r+0xe5c>
400076b0:	fff00793          	li	a5,-1
400076b4:	26f680e3          	beq	a3,a5,40008114 <_vfiprintf_r+0xe00>
400076b8:	00068613          	mv	a2,a3
400076bc:	00000593          	li	a1,0
400076c0:	000d0513          	mv	a0,s10
400076c4:	01e12623          	sw	t5,12(sp)
400076c8:	00d12223          	sw	a3,4(sp)
400076cc:	d8cfe0ef          	jal	ra,40005c58 <memchr>
400076d0:	00412683          	lw	a3,4(sp)
400076d4:	00c12f03          	lw	t5,12(sp)
400076d8:	2c0504e3          	beqz	a0,400081a0 <_vfiprintf_r+0xe8c>
400076dc:	03714703          	lbu	a4,55(sp)
400076e0:	41a50db3          	sub	s11,a0,s10
400076e4:	00912623          	sw	s1,12(sp)
400076e8:	01e12223          	sw	t5,4(sp)
400076ec:	00000693          	li	a3,0
400076f0:	00068a13          	mv	s4,a3
400076f4:	01b6d463          	ble	s11,a3,400076fc <_vfiprintf_r+0x3e8>
400076f8:	000d8a13          	mv	s4,s11
400076fc:	00e03733          	snez	a4,a4
40007700:	00ea0a33          	add	s4,s4,a4
40007704:	00412783          	lw	a5,4(sp)
40007708:	0027f393          	andi	t2,a5,2
4000770c:	00038463          	beqz	t2,40007714 <_vfiprintf_r+0x400>
40007710:	002a0a13          	addi	s4,s4,2
40007714:	00412783          	lw	a5,4(sp)
40007718:	0847f293          	andi	t0,a5,132
4000771c:	4c029863          	bnez	t0,40007bec <_vfiprintf_r+0x8d8>
40007720:	414904b3          	sub	s1,s2,s4
40007724:	4c905463          	blez	s1,40007bec <_vfiprintf_r+0x8d8>
40007728:	01000f13          	li	t5,16
4000772c:	04412603          	lw	a2,68(sp)
40007730:	229f5ae3          	ble	s1,t5,40008164 <_vfiprintf_r+0xe50>
40007734:	04012503          	lw	a0,64(sp)
40007738:	00700f93          	li	t6,7
4000773c:	00100793          	li	a5,1
40007740:	0180006f          	j	40007758 <_vfiprintf_r+0x444>
40007744:	00250713          	addi	a4,a0,2
40007748:	00840413          	addi	s0,s0,8
4000774c:	00058513          	mv	a0,a1
40007750:	ff048493          	addi	s1,s1,-16
40007754:	029f5c63          	ble	s1,t5,4000778c <_vfiprintf_r+0x478>
40007758:	01060613          	addi	a2,a2,16
4000775c:	00150593          	addi	a1,a0,1
40007760:	01942023          	sw	s9,0(s0)
40007764:	01e42223          	sw	t5,4(s0)
40007768:	04c12223          	sw	a2,68(sp)
4000776c:	04b12023          	sw	a1,64(sp)
40007770:	fcbfdae3          	ble	a1,t6,40007744 <_vfiprintf_r+0x430>
40007774:	42061063          	bnez	a2,40007b94 <_vfiprintf_r+0x880>
40007778:	ff048493          	addi	s1,s1,-16
4000777c:	00000513          	li	a0,0
40007780:	00078713          	mv	a4,a5
40007784:	000c0413          	mv	s0,s8
40007788:	fc9f48e3          	blt	t5,s1,40007758 <_vfiprintf_r+0x444>
4000778c:	00c487b3          	add	a5,s1,a2
40007790:	01942023          	sw	s9,0(s0)
40007794:	00942223          	sw	s1,4(s0)
40007798:	04f12223          	sw	a5,68(sp)
4000779c:	04e12023          	sw	a4,64(sp)
400077a0:	00700613          	li	a2,7
400077a4:	6ee64063          	blt	a2,a4,40007e84 <_vfiprintf_r+0xb70>
400077a8:	03714583          	lbu	a1,55(sp)
400077ac:	00840413          	addi	s0,s0,8
400077b0:	00170613          	addi	a2,a4,1
400077b4:	44059663          	bnez	a1,40007c00 <_vfiprintf_r+0x8ec>
400077b8:	48038063          	beqz	t2,40007c38 <_vfiprintf_r+0x924>
400077bc:	03810713          	addi	a4,sp,56
400077c0:	00278793          	addi	a5,a5,2
400077c4:	00e42023          	sw	a4,0(s0)
400077c8:	00200713          	li	a4,2
400077cc:	00e42223          	sw	a4,4(s0)
400077d0:	04f12223          	sw	a5,68(sp)
400077d4:	04c12023          	sw	a2,64(sp)
400077d8:	00700713          	li	a4,7
400077dc:	6ec75a63          	ble	a2,a4,40007ed0 <_vfiprintf_r+0xbbc>
400077e0:	020794e3          	bnez	a5,40008008 <_vfiprintf_r+0xcf4>
400077e4:	08000593          	li	a1,128
400077e8:	00100613          	li	a2,1
400077ec:	00000713          	li	a4,0
400077f0:	000c0413          	mv	s0,s8
400077f4:	44b29663          	bne	t0,a1,40007c40 <_vfiprintf_r+0x92c>
400077f8:	414904b3          	sub	s1,s2,s4
400077fc:	44905263          	blez	s1,40007c40 <_vfiprintf_r+0x92c>
40007800:	01000f13          	li	t5,16
40007804:	1a9f5ae3          	ble	s1,t5,400081b8 <_vfiprintf_r+0xea4>
40007808:	00700f93          	li	t6,7
4000780c:	00100293          	li	t0,1
40007810:	0180006f          	j	40007828 <_vfiprintf_r+0x514>
40007814:	00270593          	addi	a1,a4,2
40007818:	00840413          	addi	s0,s0,8
4000781c:	00060713          	mv	a4,a2
40007820:	ff048493          	addi	s1,s1,-16
40007824:	029f5c63          	ble	s1,t5,4000785c <_vfiprintf_r+0x548>
40007828:	01078793          	addi	a5,a5,16
4000782c:	00170613          	addi	a2,a4,1
40007830:	01742023          	sw	s7,0(s0)
40007834:	01e42223          	sw	t5,4(s0)
40007838:	04f12223          	sw	a5,68(sp)
4000783c:	04c12023          	sw	a2,64(sp)
40007840:	fccfdae3          	ble	a2,t6,40007814 <_vfiprintf_r+0x500>
40007844:	5e079c63          	bnez	a5,40007e3c <_vfiprintf_r+0xb28>
40007848:	ff048493          	addi	s1,s1,-16
4000784c:	00028593          	mv	a1,t0
40007850:	00000713          	li	a4,0
40007854:	000c0413          	mv	s0,s8
40007858:	fc9f48e3          	blt	t5,s1,40007828 <_vfiprintf_r+0x514>
4000785c:	009787b3          	add	a5,a5,s1
40007860:	01742023          	sw	s7,0(s0)
40007864:	00942223          	sw	s1,4(s0)
40007868:	04f12223          	sw	a5,68(sp)
4000786c:	04b12023          	sw	a1,64(sp)
40007870:	00700713          	li	a4,7
40007874:	7cb74663          	blt	a4,a1,40008040 <_vfiprintf_r+0xd2c>
40007878:	41b684b3          	sub	s1,a3,s11
4000787c:	00840413          	addi	s0,s0,8
40007880:	00158613          	addi	a2,a1,1
40007884:	00058713          	mv	a4,a1
40007888:	3c904063          	bgtz	s1,40007c48 <_vfiprintf_r+0x934>
4000788c:	00fd87b3          	add	a5,s11,a5
40007890:	01a42023          	sw	s10,0(s0)
40007894:	01b42223          	sw	s11,4(s0)
40007898:	04f12223          	sw	a5,68(sp)
4000789c:	04c12023          	sw	a2,64(sp)
400078a0:	00700713          	li	a4,7
400078a4:	42c75e63          	ble	a2,a4,40007ce0 <_vfiprintf_r+0x9cc>
400078a8:	6e079e63          	bnez	a5,40007fa4 <_vfiprintf_r+0xc90>
400078ac:	00412703          	lw	a4,4(sp)
400078b0:	04012023          	sw	zero,64(sp)
400078b4:	00477d13          	andi	s10,a4,4
400078b8:	080d0863          	beqz	s10,40007948 <_vfiprintf_r+0x634>
400078bc:	414904b3          	sub	s1,s2,s4
400078c0:	000c0413          	mv	s0,s8
400078c4:	08905263          	blez	s1,40007948 <_vfiprintf_r+0x634>
400078c8:	01000d13          	li	s10,16
400078cc:	0c9d54e3          	ble	s1,s10,40008194 <_vfiprintf_r+0xe80>
400078d0:	04012683          	lw	a3,64(sp)
400078d4:	00700d93          	li	s11,7
400078d8:	00100e93          	li	t4,1
400078dc:	0180006f          	j	400078f4 <_vfiprintf_r+0x5e0>
400078e0:	00268613          	addi	a2,a3,2
400078e4:	00840413          	addi	s0,s0,8
400078e8:	00070693          	mv	a3,a4
400078ec:	ff048493          	addi	s1,s1,-16
400078f0:	029d5c63          	ble	s1,s10,40007928 <_vfiprintf_r+0x614>
400078f4:	01078793          	addi	a5,a5,16
400078f8:	00168713          	addi	a4,a3,1
400078fc:	01942023          	sw	s9,0(s0)
40007900:	01a42223          	sw	s10,4(s0)
40007904:	04f12223          	sw	a5,68(sp)
40007908:	04e12023          	sw	a4,64(sp)
4000790c:	fceddae3          	ble	a4,s11,400078e0 <_vfiprintf_r+0x5cc>
40007910:	4a079a63          	bnez	a5,40007dc4 <_vfiprintf_r+0xab0>
40007914:	ff048493          	addi	s1,s1,-16
40007918:	000e8613          	mv	a2,t4
4000791c:	00000693          	li	a3,0
40007920:	000c0413          	mv	s0,s8
40007924:	fc9d48e3          	blt	s10,s1,400078f4 <_vfiprintf_r+0x5e0>
40007928:	009787b3          	add	a5,a5,s1
4000792c:	01942023          	sw	s9,0(s0)
40007930:	00942223          	sw	s1,4(s0)
40007934:	04f12223          	sw	a5,68(sp)
40007938:	04c12023          	sw	a2,64(sp)
4000793c:	00700713          	li	a4,7
40007940:	3ac75c63          	ble	a2,a4,40007cf8 <_vfiprintf_r+0x9e4>
40007944:	7a079a63          	bnez	a5,400080f8 <_vfiprintf_r+0xde4>
40007948:	01495463          	ble	s4,s2,40007950 <_vfiprintf_r+0x63c>
4000794c:	000a0913          	mv	s2,s4
40007950:	00812783          	lw	a5,8(sp)
40007954:	012787b3          	add	a5,a5,s2
40007958:	00f12423          	sw	a5,8(sp)
4000795c:	3b40006f          	j	40007d10 <_vfiprintf_r+0x9fc>
40007960:	080e9ce3          	bnez	t4,400081f8 <_vfiprintf_r+0xee4>
40007964:	010f6f13          	ori	t5,t5,16
40007968:	010f7793          	andi	a5,t5,16
4000796c:	5a079863          	bnez	a5,40007f1c <_vfiprintf_r+0xc08>
40007970:	040f7793          	andi	a5,t5,64
40007974:	5a078463          	beqz	a5,40007f1c <_vfiprintf_r+0xc08>
40007978:	00c12783          	lw	a5,12(sp)
4000797c:	00079483          	lh	s1,0(a5)
40007980:	00478793          	addi	a5,a5,4
40007984:	00f12623          	sw	a5,12(sp)
40007988:	7004cc63          	bltz	s1,400080a0 <_vfiprintf_r+0xd8c>
4000798c:	fff00613          	li	a2,-1
40007990:	03714703          	lbu	a4,55(sp)
40007994:	00100793          	li	a5,1
40007998:	12c69863          	bne	a3,a2,40007ac8 <_vfiprintf_r+0x7b4>
4000799c:	44048e63          	beqz	s1,40007df8 <_vfiprintf_r+0xae4>
400079a0:	01e12223          	sw	t5,4(sp)
400079a4:	00100613          	li	a2,1
400079a8:	58c78e63          	beq	a5,a2,40007f44 <_vfiprintf_r+0xc30>
400079ac:	00200613          	li	a2,2
400079b0:	46c78063          	beq	a5,a2,40007e10 <_vfiprintf_r+0xafc>
400079b4:	000c0613          	mv	a2,s8
400079b8:	0080006f          	j	400079c0 <_vfiprintf_r+0x6ac>
400079bc:	000d0613          	mv	a2,s10
400079c0:	0074f793          	andi	a5,s1,7
400079c4:	03078793          	addi	a5,a5,48
400079c8:	fef60fa3          	sb	a5,-1(a2)
400079cc:	0034d493          	srli	s1,s1,0x3
400079d0:	fff60d13          	addi	s10,a2,-1
400079d4:	fe0494e3          	bnez	s1,400079bc <_vfiprintf_r+0x6a8>
400079d8:	00412583          	lw	a1,4(sp)
400079dc:	0015f593          	andi	a1,a1,1
400079e0:	44058a63          	beqz	a1,40007e34 <_vfiprintf_r+0xb20>
400079e4:	03000593          	li	a1,48
400079e8:	44b78663          	beq	a5,a1,40007e34 <_vfiprintf_r+0xb20>
400079ec:	ffe60613          	addi	a2,a2,-2
400079f0:	febd0fa3          	sb	a1,-1(s10)
400079f4:	40cc0db3          	sub	s11,s8,a2
400079f8:	00060d13          	mv	s10,a2
400079fc:	cf5ff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40007a00:	ac0f9ce3          	bnez	t6,400074d8 <_vfiprintf_r+0x1c4>
40007a04:	00028e93          	mv	t4,t0
40007a08:	000d0f93          	mv	t6,s10
40007a0c:	000b0493          	mv	s1,s6
40007a10:	a91ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
40007a14:	001f6f13          	ori	t5,t5,1
40007a18:	000b0493          	mv	s1,s6
40007a1c:	a85ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
40007a20:	00c12703          	lw	a4,12(sp)
40007a24:	00100a13          	li	s4,1
40007a28:	02010ba3          	sb	zero,55(sp)
40007a2c:	00072783          	lw	a5,0(a4)
40007a30:	000a0d93          	mv	s11,s4
40007a34:	04810d13          	addi	s10,sp,72
40007a38:	04f10423          	sb	a5,72(sp)
40007a3c:	00470793          	addi	a5,a4,4
40007a40:	00f12623          	sw	a5,12(sp)
40007a44:	01e12223          	sw	t5,4(sp)
40007a48:	00000693          	li	a3,0
40007a4c:	cb9ff06f          	j	40007704 <_vfiprintf_r+0x3f0>
40007a50:	f00e8ce3          	beqz	t4,40007968 <_vfiprintf_r+0x654>
40007a54:	03f10ba3          	sb	t6,55(sp)
40007a58:	f11ff06f          	j	40007968 <_vfiprintf_r+0x654>
40007a5c:	040f6f13          	ori	t5,t5,64
40007a60:	000b0493          	mv	s1,s6
40007a64:	a3dff06f          	j	400074a0 <_vfiprintf_r+0x18c>
40007a68:	7a0e9063          	bnez	t4,40008208 <_vfiprintf_r+0xef4>
40007a6c:	4000d7b7          	lui	a5,0x4000d
40007a70:	74878793          	addi	a5,a5,1864 # 4000d748 <zeroes.4139+0x34>
40007a74:	00f12e23          	sw	a5,28(sp)
40007a78:	010f7793          	andi	a5,t5,16
40007a7c:	4a079a63          	bnez	a5,40007f30 <_vfiprintf_r+0xc1c>
40007a80:	040f7793          	andi	a5,t5,64
40007a84:	4a078663          	beqz	a5,40007f30 <_vfiprintf_r+0xc1c>
40007a88:	00c12783          	lw	a5,12(sp)
40007a8c:	0007d483          	lhu	s1,0(a5)
40007a90:	00478793          	addi	a5,a5,4
40007a94:	00f12623          	sw	a5,12(sp)
40007a98:	001f7613          	andi	a2,t5,1
40007a9c:	00200793          	li	a5,2
40007aa0:	00060c63          	beqz	a2,40007ab8 <_vfiprintf_r+0x7a4>
40007aa4:	00048a63          	beqz	s1,40007ab8 <_vfiprintf_r+0x7a4>
40007aa8:	03000613          	li	a2,48
40007aac:	02c10c23          	sb	a2,56(sp)
40007ab0:	02e10ca3          	sb	a4,57(sp)
40007ab4:	00ff6f33          	or	t5,t5,a5
40007ab8:	02010ba3          	sb	zero,55(sp)
40007abc:	00000713          	li	a4,0
40007ac0:	fff00613          	li	a2,-1
40007ac4:	ecc68ce3          	beq	a3,a2,4000799c <_vfiprintf_r+0x688>
40007ac8:	f7ff7613          	andi	a2,t5,-129
40007acc:	00c12223          	sw	a2,4(sp)
40007ad0:	ec049ae3          	bnez	s1,400079a4 <_vfiprintf_r+0x690>
40007ad4:	32069063          	bnez	a3,40007df4 <_vfiprintf_r+0xae0>
40007ad8:	4c079063          	bnez	a5,40007f98 <_vfiprintf_r+0xc84>
40007adc:	001f7d93          	andi	s11,t5,1
40007ae0:	000c0d13          	mv	s10,s8
40007ae4:	c00d86e3          	beqz	s11,400076f0 <_vfiprintf_r+0x3dc>
40007ae8:	03000793          	li	a5,48
40007aec:	06f107a3          	sb	a5,111(sp)
40007af0:	06f10d13          	addi	s10,sp,111
40007af4:	bfdff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40007af8:	700e9463          	bnez	t4,40008200 <_vfiprintf_r+0xeec>
40007afc:	4000d7b7          	lui	a5,0x4000d
40007b00:	73478793          	addi	a5,a5,1844 # 4000d734 <zeroes.4139+0x20>
40007b04:	00f12e23          	sw	a5,28(sp)
40007b08:	f71ff06f          	j	40007a78 <_vfiprintf_r+0x764>
40007b0c:	00c12703          	lw	a4,12(sp)
40007b10:	03000793          	li	a5,48
40007b14:	02f10c23          	sb	a5,56(sp)
40007b18:	07800793          	li	a5,120
40007b1c:	02f10ca3          	sb	a5,57(sp)
40007b20:	00470793          	addi	a5,a4,4
40007b24:	00f12623          	sw	a5,12(sp)
40007b28:	4000d7b7          	lui	a5,0x4000d
40007b2c:	74878793          	addi	a5,a5,1864 # 4000d748 <zeroes.4139+0x34>
40007b30:	00f12e23          	sw	a5,28(sp)
40007b34:	00072483          	lw	s1,0(a4)
40007b38:	002f6f13          	ori	t5,t5,2
40007b3c:	00200793          	li	a5,2
40007b40:	f79ff06f          	j	40007ab8 <_vfiprintf_r+0x7a4>
40007b44:	00c12703          	lw	a4,12(sp)
40007b48:	00072483          	lw	s1,0(a4)
40007b4c:	00470713          	addi	a4,a4,4
40007b50:	00000793          	li	a5,0
40007b54:	00e12623          	sw	a4,12(sp)
40007b58:	f61ff06f          	j	40007ab8 <_vfiprintf_r+0x7a4>
40007b5c:	00c12703          	lw	a4,12(sp)
40007b60:	00072483          	lw	s1,0(a4)
40007b64:	00470713          	addi	a4,a4,4
40007b68:	00100793          	li	a5,1
40007b6c:	00e12623          	sw	a4,12(sp)
40007b70:	f49ff06f          	j	40007ab8 <_vfiprintf_r+0x7a4>
40007b74:	660e9663          	bnez	t4,400081e0 <_vfiprintf_r+0xecc>
40007b78:	20070e63          	beqz	a4,40007d94 <_vfiprintf_r+0xa80>
40007b7c:	00100a13          	li	s4,1
40007b80:	04e10423          	sb	a4,72(sp)
40007b84:	02010ba3          	sb	zero,55(sp)
40007b88:	000a0d93          	mv	s11,s4
40007b8c:	04810d13          	addi	s10,sp,72
40007b90:	eb5ff06f          	j	40007a44 <_vfiprintf_r+0x730>
40007b94:	03c10613          	addi	a2,sp,60
40007b98:	00098593          	mv	a1,s3
40007b9c:	000a8513          	mv	a0,s5
40007ba0:	02f12623          	sw	a5,44(sp)
40007ba4:	03f12423          	sw	t6,40(sp)
40007ba8:	03e12223          	sw	t5,36(sp)
40007bac:	02512023          	sw	t0,32(sp)
40007bb0:	00712c23          	sw	t2,24(sp)
40007bb4:	00d12a23          	sw	a3,20(sp)
40007bb8:	e54ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007bbc:	1e051863          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007bc0:	04012503          	lw	a0,64(sp)
40007bc4:	04412603          	lw	a2,68(sp)
40007bc8:	000c0413          	mv	s0,s8
40007bcc:	00150713          	addi	a4,a0,1
40007bd0:	02c12783          	lw	a5,44(sp)
40007bd4:	02812f83          	lw	t6,40(sp)
40007bd8:	02412f03          	lw	t5,36(sp)
40007bdc:	02012283          	lw	t0,32(sp)
40007be0:	01812383          	lw	t2,24(sp)
40007be4:	01412683          	lw	a3,20(sp)
40007be8:	b69ff06f          	j	40007750 <_vfiprintf_r+0x43c>
40007bec:	04012703          	lw	a4,64(sp)
40007bf0:	04412783          	lw	a5,68(sp)
40007bf4:	00170613          	addi	a2,a4,1
40007bf8:	03714583          	lbu	a1,55(sp)
40007bfc:	ba058ee3          	beqz	a1,400077b8 <_vfiprintf_r+0x4a4>
40007c00:	00100593          	li	a1,1
40007c04:	03710713          	addi	a4,sp,55
40007c08:	00b787b3          	add	a5,a5,a1
40007c0c:	00e42023          	sw	a4,0(s0)
40007c10:	00b42223          	sw	a1,4(s0)
40007c14:	04f12223          	sw	a5,68(sp)
40007c18:	04c12023          	sw	a2,64(sp)
40007c1c:	00700713          	li	a4,7
40007c20:	28c75463          	ble	a2,a4,40007ea8 <_vfiprintf_r+0xb94>
40007c24:	0e079c63          	bnez	a5,40007d1c <_vfiprintf_r+0xa08>
40007c28:	28039863          	bnez	t2,40007eb8 <_vfiprintf_r+0xba4>
40007c2c:	00000713          	li	a4,0
40007c30:	00100613          	li	a2,1
40007c34:	000c0413          	mv	s0,s8
40007c38:	08000593          	li	a1,128
40007c3c:	bab28ee3          	beq	t0,a1,400077f8 <_vfiprintf_r+0x4e4>
40007c40:	41b684b3          	sub	s1,a3,s11
40007c44:	c49054e3          	blez	s1,4000788c <_vfiprintf_r+0x578>
40007c48:	01000f13          	li	t5,16
40007c4c:	049f5a63          	ble	s1,t5,40007ca0 <_vfiprintf_r+0x98c>
40007c50:	00700f93          	li	t6,7
40007c54:	0180006f          	j	40007c6c <_vfiprintf_r+0x958>
40007c58:	00270613          	addi	a2,a4,2
40007c5c:	00840413          	addi	s0,s0,8
40007c60:	00068713          	mv	a4,a3
40007c64:	ff048493          	addi	s1,s1,-16
40007c68:	029f5c63          	ble	s1,t5,40007ca0 <_vfiprintf_r+0x98c>
40007c6c:	01078793          	addi	a5,a5,16
40007c70:	00170693          	addi	a3,a4,1
40007c74:	01742023          	sw	s7,0(s0)
40007c78:	01e42223          	sw	t5,4(s0)
40007c7c:	04f12223          	sw	a5,68(sp)
40007c80:	04d12023          	sw	a3,64(sp)
40007c84:	fcdfdae3          	ble	a3,t6,40007c58 <_vfiprintf_r+0x944>
40007c88:	0c079a63          	bnez	a5,40007d5c <_vfiprintf_r+0xa48>
40007c8c:	ff048493          	addi	s1,s1,-16
40007c90:	00100613          	li	a2,1
40007c94:	00000713          	li	a4,0
40007c98:	000c0413          	mv	s0,s8
40007c9c:	fc9f48e3          	blt	t5,s1,40007c6c <_vfiprintf_r+0x958>
40007ca0:	009787b3          	add	a5,a5,s1
40007ca4:	01742023          	sw	s7,0(s0)
40007ca8:	00942223          	sw	s1,4(s0)
40007cac:	04f12223          	sw	a5,68(sp)
40007cb0:	04c12023          	sw	a2,64(sp)
40007cb4:	00700713          	li	a4,7
40007cb8:	22c74463          	blt	a4,a2,40007ee0 <_vfiprintf_r+0xbcc>
40007cbc:	00840413          	addi	s0,s0,8
40007cc0:	00160613          	addi	a2,a2,1
40007cc4:	00fd87b3          	add	a5,s11,a5
40007cc8:	01a42023          	sw	s10,0(s0)
40007ccc:	01b42223          	sw	s11,4(s0)
40007cd0:	04f12223          	sw	a5,68(sp)
40007cd4:	04c12023          	sw	a2,64(sp)
40007cd8:	00700713          	li	a4,7
40007cdc:	bcc746e3          	blt	a4,a2,400078a8 <_vfiprintf_r+0x594>
40007ce0:	00840413          	addi	s0,s0,8
40007ce4:	00412703          	lw	a4,4(sp)
40007ce8:	00477d13          	andi	s10,a4,4
40007cec:	000d0663          	beqz	s10,40007cf8 <_vfiprintf_r+0x9e4>
40007cf0:	414904b3          	sub	s1,s2,s4
40007cf4:	bc904ae3          	bgtz	s1,400078c8 <_vfiprintf_r+0x5b4>
40007cf8:	01495463          	ble	s4,s2,40007d00 <_vfiprintf_r+0x9ec>
40007cfc:	000a0913          	mv	s2,s4
40007d00:	00812703          	lw	a4,8(sp)
40007d04:	01270733          	add	a4,a4,s2
40007d08:	00e12423          	sw	a4,8(sp)
40007d0c:	1e079c63          	bnez	a5,40007f04 <_vfiprintf_r+0xbf0>
40007d10:	04012023          	sw	zero,64(sp)
40007d14:	000c0413          	mv	s0,s8
40007d18:	ee0ff06f          	j	400073f8 <_vfiprintf_r+0xe4>
40007d1c:	03c10613          	addi	a2,sp,60
40007d20:	00098593          	mv	a1,s3
40007d24:	000a8513          	mv	a0,s5
40007d28:	02512023          	sw	t0,32(sp)
40007d2c:	00712c23          	sw	t2,24(sp)
40007d30:	00d12a23          	sw	a3,20(sp)
40007d34:	cd8ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007d38:	06051a63          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007d3c:	04012703          	lw	a4,64(sp)
40007d40:	04412783          	lw	a5,68(sp)
40007d44:	000c0413          	mv	s0,s8
40007d48:	00170613          	addi	a2,a4,1
40007d4c:	02012283          	lw	t0,32(sp)
40007d50:	01812383          	lw	t2,24(sp)
40007d54:	01412683          	lw	a3,20(sp)
40007d58:	a61ff06f          	j	400077b8 <_vfiprintf_r+0x4a4>
40007d5c:	03c10613          	addi	a2,sp,60
40007d60:	00098593          	mv	a1,s3
40007d64:	000a8513          	mv	a0,s5
40007d68:	01f12c23          	sw	t6,24(sp)
40007d6c:	01e12a23          	sw	t5,20(sp)
40007d70:	c9cff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007d74:	02051c63          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007d78:	04012703          	lw	a4,64(sp)
40007d7c:	04412783          	lw	a5,68(sp)
40007d80:	000c0413          	mv	s0,s8
40007d84:	00170613          	addi	a2,a4,1
40007d88:	01812f83          	lw	t6,24(sp)
40007d8c:	01412f03          	lw	t5,20(sp)
40007d90:	ed5ff06f          	j	40007c64 <_vfiprintf_r+0x950>
40007d94:	04412783          	lw	a5,68(sp)
40007d98:	00078a63          	beqz	a5,40007dac <_vfiprintf_r+0xa98>
40007d9c:	03c10613          	addi	a2,sp,60
40007da0:	00098593          	mv	a1,s3
40007da4:	000a8513          	mv	a0,s5
40007da8:	c64ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007dac:	00c9d783          	lhu	a5,12(s3)
40007db0:	0407f793          	andi	a5,a5,64
40007db4:	fc078263          	beqz	a5,40007578 <_vfiprintf_r+0x264>
40007db8:	fff00793          	li	a5,-1
40007dbc:	00f12423          	sw	a5,8(sp)
40007dc0:	fb8ff06f          	j	40007578 <_vfiprintf_r+0x264>
40007dc4:	03c10613          	addi	a2,sp,60
40007dc8:	00098593          	mv	a1,s3
40007dcc:	000a8513          	mv	a0,s5
40007dd0:	01d12223          	sw	t4,4(sp)
40007dd4:	c38ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007dd8:	fc051ae3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007ddc:	04012683          	lw	a3,64(sp)
40007de0:	04412783          	lw	a5,68(sp)
40007de4:	000c0413          	mv	s0,s8
40007de8:	00168613          	addi	a2,a3,1
40007dec:	00412e83          	lw	t4,4(sp)
40007df0:	afdff06f          	j	400078ec <_vfiprintf_r+0x5d8>
40007df4:	00412f03          	lw	t5,4(sp)
40007df8:	00100613          	li	a2,1
40007dfc:	1ec78a63          	beq	a5,a2,40007ff0 <_vfiprintf_r+0xcdc>
40007e00:	00200613          	li	a2,2
40007e04:	1cc79e63          	bne	a5,a2,40007fe0 <_vfiprintf_r+0xccc>
40007e08:	01e12223          	sw	t5,4(sp)
40007e0c:	00000493          	li	s1,0
40007e10:	000c0d13          	mv	s10,s8
40007e14:	01c12603          	lw	a2,28(sp)
40007e18:	00f4f793          	andi	a5,s1,15
40007e1c:	fffd0d13          	addi	s10,s10,-1
40007e20:	00f607b3          	add	a5,a2,a5
40007e24:	0007c783          	lbu	a5,0(a5)
40007e28:	0044d493          	srli	s1,s1,0x4
40007e2c:	00fd0023          	sb	a5,0(s10)
40007e30:	fe0492e3          	bnez	s1,40007e14 <_vfiprintf_r+0xb00>
40007e34:	41ac0db3          	sub	s11,s8,s10
40007e38:	8b9ff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40007e3c:	03c10613          	addi	a2,sp,60
40007e40:	00098593          	mv	a1,s3
40007e44:	000a8513          	mv	a0,s5
40007e48:	02512223          	sw	t0,36(sp)
40007e4c:	03f12023          	sw	t6,32(sp)
40007e50:	01e12c23          	sw	t5,24(sp)
40007e54:	00d12a23          	sw	a3,20(sp)
40007e58:	bb4ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007e5c:	f40518e3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007e60:	04012703          	lw	a4,64(sp)
40007e64:	04412783          	lw	a5,68(sp)
40007e68:	000c0413          	mv	s0,s8
40007e6c:	00170593          	addi	a1,a4,1
40007e70:	02412283          	lw	t0,36(sp)
40007e74:	02012f83          	lw	t6,32(sp)
40007e78:	01812f03          	lw	t5,24(sp)
40007e7c:	01412683          	lw	a3,20(sp)
40007e80:	9a1ff06f          	j	40007820 <_vfiprintf_r+0x50c>
40007e84:	22079a63          	bnez	a5,400080b8 <_vfiprintf_r+0xda4>
40007e88:	03714703          	lbu	a4,55(sp)
40007e8c:	d8070ee3          	beqz	a4,40007c28 <_vfiprintf_r+0x914>
40007e90:	00100793          	li	a5,1
40007e94:	03710713          	addi	a4,sp,55
40007e98:	00078613          	mv	a2,a5
40007e9c:	06e12823          	sw	a4,112(sp)
40007ea0:	06f12a23          	sw	a5,116(sp)
40007ea4:	000c0413          	mv	s0,s8
40007ea8:	00060713          	mv	a4,a2
40007eac:	00840413          	addi	s0,s0,8
40007eb0:	00160613          	addi	a2,a2,1
40007eb4:	905ff06f          	j	400077b8 <_vfiprintf_r+0x4a4>
40007eb8:	00200793          	li	a5,2
40007ebc:	03810713          	addi	a4,sp,56
40007ec0:	06e12823          	sw	a4,112(sp)
40007ec4:	06f12a23          	sw	a5,116(sp)
40007ec8:	00100613          	li	a2,1
40007ecc:	000c0413          	mv	s0,s8
40007ed0:	00060713          	mv	a4,a2
40007ed4:	00840413          	addi	s0,s0,8
40007ed8:	00160613          	addi	a2,a2,1
40007edc:	d5dff06f          	j	40007c38 <_vfiprintf_r+0x924>
40007ee0:	16079a63          	bnez	a5,40008054 <_vfiprintf_r+0xd40>
40007ee4:	00100713          	li	a4,1
40007ee8:	000d8793          	mv	a5,s11
40007eec:	07a12823          	sw	s10,112(sp)
40007ef0:	07b12a23          	sw	s11,116(sp)
40007ef4:	05b12223          	sw	s11,68(sp)
40007ef8:	04e12023          	sw	a4,64(sp)
40007efc:	000c0413          	mv	s0,s8
40007f00:	de1ff06f          	j	40007ce0 <_vfiprintf_r+0x9cc>
40007f04:	03c10613          	addi	a2,sp,60
40007f08:	00098593          	mv	a1,s3
40007f0c:	000a8513          	mv	a0,s5
40007f10:	afcff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007f14:	de050ee3          	beqz	a0,40007d10 <_vfiprintf_r+0x9fc>
40007f18:	e95ff06f          	j	40007dac <_vfiprintf_r+0xa98>
40007f1c:	00c12783          	lw	a5,12(sp)
40007f20:	0007a483          	lw	s1,0(a5)
40007f24:	00478793          	addi	a5,a5,4
40007f28:	00f12623          	sw	a5,12(sp)
40007f2c:	a5dff06f          	j	40007988 <_vfiprintf_r+0x674>
40007f30:	00c12783          	lw	a5,12(sp)
40007f34:	0007a483          	lw	s1,0(a5)
40007f38:	00478793          	addi	a5,a5,4
40007f3c:	00f12623          	sw	a5,12(sp)
40007f40:	b59ff06f          	j	40007a98 <_vfiprintf_r+0x784>
40007f44:	00900793          	li	a5,9
40007f48:	000c0d13          	mv	s10,s8
40007f4c:	00a00a13          	li	s4,10
40007f50:	0897fe63          	bleu	s1,a5,40007fec <_vfiprintf_r+0xcd8>
40007f54:	000a0593          	mv	a1,s4
40007f58:	00048513          	mv	a0,s1
40007f5c:	00e12c23          	sw	a4,24(sp)
40007f60:	00d12a23          	sw	a3,20(sp)
40007f64:	7c1040ef          	jal	ra,4000cf24 <__umodsi3>
40007f68:	03050513          	addi	a0,a0,48
40007f6c:	fffd0d13          	addi	s10,s10,-1
40007f70:	00ad0023          	sb	a0,0(s10)
40007f74:	000a0593          	mv	a1,s4
40007f78:	00048513          	mv	a0,s1
40007f7c:	761040ef          	jal	ra,4000cedc <__udivsi3>
40007f80:	00050493          	mv	s1,a0
40007f84:	01412683          	lw	a3,20(sp)
40007f88:	01812703          	lw	a4,24(sp)
40007f8c:	fc0514e3          	bnez	a0,40007f54 <_vfiprintf_r+0xc40>
40007f90:	41ac0db3          	sub	s11,s8,s10
40007f94:	f5cff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40007f98:	00000d93          	li	s11,0
40007f9c:	000c0d13          	mv	s10,s8
40007fa0:	f50ff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40007fa4:	03c10613          	addi	a2,sp,60
40007fa8:	00098593          	mv	a1,s3
40007fac:	000a8513          	mv	a0,s5
40007fb0:	a5cff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007fb4:	de051ce3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007fb8:	04412783          	lw	a5,68(sp)
40007fbc:	000c0413          	mv	s0,s8
40007fc0:	d25ff06f          	j	40007ce4 <_vfiprintf_r+0x9d0>
40007fc4:	03c10613          	addi	a2,sp,60
40007fc8:	00098593          	mv	a1,s3
40007fcc:	000a8513          	mv	a0,s5
40007fd0:	a3cff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40007fd4:	dc051ce3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40007fd8:	000c0413          	mv	s0,s8
40007fdc:	c78ff06f          	j	40007454 <_vfiprintf_r+0x140>
40007fe0:	01e12223          	sw	t5,4(sp)
40007fe4:	00000493          	li	s1,0
40007fe8:	9cdff06f          	j	400079b4 <_vfiprintf_r+0x6a0>
40007fec:	00412f03          	lw	t5,4(sp)
40007ff0:	03048493          	addi	s1,s1,48
40007ff4:	069107a3          	sb	s1,111(sp)
40007ff8:	01e12223          	sw	t5,4(sp)
40007ffc:	00100d93          	li	s11,1
40008000:	06f10d13          	addi	s10,sp,111
40008004:	eecff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40008008:	03c10613          	addi	a2,sp,60
4000800c:	00098593          	mv	a1,s3
40008010:	000a8513          	mv	a0,s5
40008014:	00512c23          	sw	t0,24(sp)
40008018:	00d12a23          	sw	a3,20(sp)
4000801c:	9f0ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40008020:	d80516e3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40008024:	04012703          	lw	a4,64(sp)
40008028:	04412783          	lw	a5,68(sp)
4000802c:	000c0413          	mv	s0,s8
40008030:	00170613          	addi	a2,a4,1
40008034:	01812283          	lw	t0,24(sp)
40008038:	01412683          	lw	a3,20(sp)
4000803c:	bfdff06f          	j	40007c38 <_vfiprintf_r+0x924>
40008040:	0e079a63          	bnez	a5,40008134 <_vfiprintf_r+0xe20>
40008044:	00100613          	li	a2,1
40008048:	00000713          	li	a4,0
4000804c:	000c0413          	mv	s0,s8
40008050:	bf1ff06f          	j	40007c40 <_vfiprintf_r+0x92c>
40008054:	03c10613          	addi	a2,sp,60
40008058:	00098593          	mv	a1,s3
4000805c:	000a8513          	mv	a0,s5
40008060:	9acff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40008064:	d40514e3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
40008068:	04012603          	lw	a2,64(sp)
4000806c:	04412783          	lw	a5,68(sp)
40008070:	000c0413          	mv	s0,s8
40008074:	00160613          	addi	a2,a2,1
40008078:	815ff06f          	j	4000788c <_vfiprintf_r+0x578>
4000807c:	00c12703          	lw	a4,12(sp)
40008080:	00072783          	lw	a5,0(a4)
40008084:	00470713          	addi	a4,a4,4
40008088:	00e12623          	sw	a4,12(sp)
4000808c:	00812703          	lw	a4,8(sp)
40008090:	00e7a023          	sw	a4,0(a5)
40008094:	b64ff06f          	j	400073f8 <_vfiprintf_r+0xe4>
40008098:	000b0493          	mv	s1,s6
4000809c:	bc4ff06f          	j	40007460 <_vfiprintf_r+0x14c>
400080a0:	02d00793          	li	a5,45
400080a4:	02f10ba3          	sb	a5,55(sp)
400080a8:	409004b3          	neg	s1,s1
400080ac:	02d00713          	li	a4,45
400080b0:	00100793          	li	a5,1
400080b4:	a0dff06f          	j	40007ac0 <_vfiprintf_r+0x7ac>
400080b8:	03c10613          	addi	a2,sp,60
400080bc:	00098593          	mv	a1,s3
400080c0:	000a8513          	mv	a0,s5
400080c4:	02512023          	sw	t0,32(sp)
400080c8:	00712c23          	sw	t2,24(sp)
400080cc:	00d12a23          	sw	a3,20(sp)
400080d0:	93cff0ef          	jal	ra,4000720c <__sprint_r.part.0>
400080d4:	cc051ce3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
400080d8:	04012703          	lw	a4,64(sp)
400080dc:	04412783          	lw	a5,68(sp)
400080e0:	000c0413          	mv	s0,s8
400080e4:	00170613          	addi	a2,a4,1
400080e8:	02012283          	lw	t0,32(sp)
400080ec:	01812383          	lw	t2,24(sp)
400080f0:	01412683          	lw	a3,20(sp)
400080f4:	b05ff06f          	j	40007bf8 <_vfiprintf_r+0x8e4>
400080f8:	03c10613          	addi	a2,sp,60
400080fc:	00098593          	mv	a1,s3
40008100:	000a8513          	mv	a0,s5
40008104:	908ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40008108:	ca0512e3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
4000810c:	04412783          	lw	a5,68(sp)
40008110:	be9ff06f          	j	40007cf8 <_vfiprintf_r+0x9e4>
40008114:	000d0513          	mv	a0,s10
40008118:	01e12223          	sw	t5,4(sp)
4000811c:	858ff0ef          	jal	ra,40007174 <strlen>
40008120:	00050d93          	mv	s11,a0
40008124:	03714703          	lbu	a4,55(sp)
40008128:	00912623          	sw	s1,12(sp)
4000812c:	00000693          	li	a3,0
40008130:	dc0ff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
40008134:	03c10613          	addi	a2,sp,60
40008138:	00098593          	mv	a1,s3
4000813c:	000a8513          	mv	a0,s5
40008140:	00d12a23          	sw	a3,20(sp)
40008144:	8c8ff0ef          	jal	ra,4000720c <__sprint_r.part.0>
40008148:	c60512e3          	bnez	a0,40007dac <_vfiprintf_r+0xa98>
4000814c:	04012703          	lw	a4,64(sp)
40008150:	04412783          	lw	a5,68(sp)
40008154:	000c0413          	mv	s0,s8
40008158:	00170613          	addi	a2,a4,1
4000815c:	01412683          	lw	a3,20(sp)
40008160:	ae1ff06f          	j	40007c40 <_vfiprintf_r+0x92c>
40008164:	04012703          	lw	a4,64(sp)
40008168:	00170713          	addi	a4,a4,1
4000816c:	e20ff06f          	j	4000778c <_vfiprintf_r+0x478>
40008170:	00600793          	li	a5,6
40008174:	00068d93          	mv	s11,a3
40008178:	00d7f463          	bleu	a3,a5,40008180 <_vfiprintf_r+0xe6c>
4000817c:	00078d93          	mv	s11,a5
40008180:	4000deb7          	lui	t4,0x4000d
40008184:	000d8a13          	mv	s4,s11
40008188:	00912623          	sw	s1,12(sp)
4000818c:	75ce8d13          	addi	s10,t4,1884 # 4000d75c <zeroes.4139+0x48>
40008190:	8b5ff06f          	j	40007a44 <_vfiprintf_r+0x730>
40008194:	04012603          	lw	a2,64(sp)
40008198:	00160613          	addi	a2,a2,1
4000819c:	f8cff06f          	j	40007928 <_vfiprintf_r+0x614>
400081a0:	00068d93          	mv	s11,a3
400081a4:	03714703          	lbu	a4,55(sp)
400081a8:	00912623          	sw	s1,12(sp)
400081ac:	01e12223          	sw	t5,4(sp)
400081b0:	00000693          	li	a3,0
400081b4:	d3cff06f          	j	400076f0 <_vfiprintf_r+0x3dc>
400081b8:	00060593          	mv	a1,a2
400081bc:	ea0ff06f          	j	4000785c <_vfiprintf_r+0x548>
400081c0:	00c12783          	lw	a5,12(sp)
400081c4:	0007a683          	lw	a3,0(a5)
400081c8:	00478b13          	addi	s6,a5,4
400081cc:	0206c263          	bltz	a3,400081f0 <_vfiprintf_r+0xedc>
400081d0:	01612623          	sw	s6,12(sp)
400081d4:	00048b13          	mv	s6,s1
400081d8:	000b0493          	mv	s1,s6
400081dc:	ac4ff06f          	j	400074a0 <_vfiprintf_r+0x18c>
400081e0:	03f10ba3          	sb	t6,55(sp)
400081e4:	995ff06f          	j	40007b78 <_vfiprintf_r+0x864>
400081e8:	03f10ba3          	sb	t6,55(sp)
400081ec:	c84ff06f          	j	40007670 <_vfiprintf_r+0x35c>
400081f0:	000d8693          	mv	a3,s11
400081f4:	fddff06f          	j	400081d0 <_vfiprintf_r+0xebc>
400081f8:	03f10ba3          	sb	t6,55(sp)
400081fc:	f68ff06f          	j	40007964 <_vfiprintf_r+0x650>
40008200:	03f10ba3          	sb	t6,55(sp)
40008204:	8f9ff06f          	j	40007afc <_vfiprintf_r+0x7e8>
40008208:	03f10ba3          	sb	t6,55(sp)
4000820c:	861ff06f          	j	40007a6c <_vfiprintf_r+0x758>

40008210 <vfiprintf>:
40008210:	4000e7b7          	lui	a5,0x4000e
40008214:	00060693          	mv	a3,a2
40008218:	00058613          	mv	a2,a1
4000821c:	00050593          	mv	a1,a0
40008220:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
40008224:	8f0ff06f          	j	40007314 <_vfiprintf_r>

40008228 <__sbprintf>:
40008228:	00c5d783          	lhu	a5,12(a1)
4000822c:	0645ae03          	lw	t3,100(a1)
40008230:	00e5d303          	lhu	t1,14(a1)
40008234:	01c5a883          	lw	a7,28(a1)
40008238:	0245a803          	lw	a6,36(a1)
4000823c:	b8010113          	addi	sp,sp,-1152
40008240:	ffd7f793          	andi	a5,a5,-3
40008244:	40000713          	li	a4,1024
40008248:	46812c23          	sw	s0,1144(sp)
4000824c:	00f11a23          	sh	a5,20(sp)
40008250:	00058413          	mv	s0,a1
40008254:	07010793          	addi	a5,sp,112
40008258:	00810593          	addi	a1,sp,8
4000825c:	46912a23          	sw	s1,1140(sp)
40008260:	47212823          	sw	s2,1136(sp)
40008264:	46112e23          	sw	ra,1148(sp)
40008268:	00050913          	mv	s2,a0
4000826c:	07c12623          	sw	t3,108(sp)
40008270:	00611b23          	sh	t1,22(sp)
40008274:	03112223          	sw	a7,36(sp)
40008278:	03012623          	sw	a6,44(sp)
4000827c:	00f12423          	sw	a5,8(sp)
40008280:	00f12c23          	sw	a5,24(sp)
40008284:	00e12823          	sw	a4,16(sp)
40008288:	00e12e23          	sw	a4,28(sp)
4000828c:	02012023          	sw	zero,32(sp)
40008290:	884ff0ef          	jal	ra,40007314 <_vfiprintf_r>
40008294:	00050493          	mv	s1,a0
40008298:	00054a63          	bltz	a0,400082ac <__sbprintf+0x84>
4000829c:	00810593          	addi	a1,sp,8
400082a0:	00090513          	mv	a0,s2
400082a4:	d4dfc0ef          	jal	ra,40004ff0 <_fflush_r>
400082a8:	02051c63          	bnez	a0,400082e0 <__sbprintf+0xb8>
400082ac:	01415783          	lhu	a5,20(sp)
400082b0:	0407f793          	andi	a5,a5,64
400082b4:	00078863          	beqz	a5,400082c4 <__sbprintf+0x9c>
400082b8:	00c45783          	lhu	a5,12(s0)
400082bc:	0407e793          	ori	a5,a5,64
400082c0:	00f41623          	sh	a5,12(s0)
400082c4:	47c12083          	lw	ra,1148(sp)
400082c8:	00048513          	mv	a0,s1
400082cc:	47812403          	lw	s0,1144(sp)
400082d0:	47412483          	lw	s1,1140(sp)
400082d4:	47012903          	lw	s2,1136(sp)
400082d8:	48010113          	addi	sp,sp,1152
400082dc:	00008067          	ret
400082e0:	fff00493          	li	s1,-1
400082e4:	fc9ff06f          	j	400082ac <__sbprintf+0x84>

400082e8 <_write_r>:
400082e8:	ff010113          	addi	sp,sp,-16
400082ec:	00058793          	mv	a5,a1
400082f0:	00812423          	sw	s0,8(sp)
400082f4:	00912223          	sw	s1,4(sp)
400082f8:	00060593          	mv	a1,a2
400082fc:	00050493          	mv	s1,a0
40008300:	40011437          	lui	s0,0x40011
40008304:	00078513          	mv	a0,a5
40008308:	00068613          	mv	a2,a3
4000830c:	00112623          	sw	ra,12(sp)
40008310:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40008314:	955f80ef          	jal	ra,40000c68 <write>
40008318:	fff00793          	li	a5,-1
4000831c:	00f50c63          	beq	a0,a5,40008334 <_write_r+0x4c>
40008320:	00c12083          	lw	ra,12(sp)
40008324:	00812403          	lw	s0,8(sp)
40008328:	00412483          	lw	s1,4(sp)
4000832c:	01010113          	addi	sp,sp,16
40008330:	00008067          	ret
40008334:	dd842783          	lw	a5,-552(s0)
40008338:	fe0784e3          	beqz	a5,40008320 <_write_r+0x38>
4000833c:	00c12083          	lw	ra,12(sp)
40008340:	00f4a023          	sw	a5,0(s1)
40008344:	00812403          	lw	s0,8(sp)
40008348:	00412483          	lw	s1,4(sp)
4000834c:	01010113          	addi	sp,sp,16
40008350:	00008067          	ret

40008354 <_calloc_r>:
40008354:	ff010113          	addi	sp,sp,-16
40008358:	00058793          	mv	a5,a1
4000835c:	00812423          	sw	s0,8(sp)
40008360:	00060593          	mv	a1,a2
40008364:	00050413          	mv	s0,a0
40008368:	00078513          	mv	a0,a5
4000836c:	00112623          	sw	ra,12(sp)
40008370:	341040ef          	jal	ra,4000ceb0 <__mulsi3>
40008374:	00050593          	mv	a1,a0
40008378:	00040513          	mv	a0,s0
4000837c:	995f80ef          	jal	ra,40000d10 <_malloc_r>
40008380:	00050413          	mv	s0,a0
40008384:	04050e63          	beqz	a0,400083e0 <_calloc_r+0x8c>
40008388:	ffc52603          	lw	a2,-4(a0)
4000838c:	02400713          	li	a4,36
40008390:	ffc67613          	andi	a2,a2,-4
40008394:	ffc60613          	addi	a2,a2,-4
40008398:	04c76e63          	bltu	a4,a2,400083f4 <_calloc_r+0xa0>
4000839c:	01300693          	li	a3,19
400083a0:	00050793          	mv	a5,a0
400083a4:	02c6f863          	bleu	a2,a3,400083d4 <_calloc_r+0x80>
400083a8:	00052023          	sw	zero,0(a0)
400083ac:	00052223          	sw	zero,4(a0)
400083b0:	01b00793          	li	a5,27
400083b4:	04c7fe63          	bleu	a2,a5,40008410 <_calloc_r+0xbc>
400083b8:	00052423          	sw	zero,8(a0)
400083bc:	00052623          	sw	zero,12(a0)
400083c0:	01050793          	addi	a5,a0,16
400083c4:	00e61863          	bne	a2,a4,400083d4 <_calloc_r+0x80>
400083c8:	00052823          	sw	zero,16(a0)
400083cc:	01850793          	addi	a5,a0,24
400083d0:	00052a23          	sw	zero,20(a0)
400083d4:	0007a023          	sw	zero,0(a5)
400083d8:	0007a223          	sw	zero,4(a5)
400083dc:	0007a423          	sw	zero,8(a5)
400083e0:	00c12083          	lw	ra,12(sp)
400083e4:	00040513          	mv	a0,s0
400083e8:	00812403          	lw	s0,8(sp)
400083ec:	01010113          	addi	sp,sp,16
400083f0:	00008067          	ret
400083f4:	00000593          	li	a1,0
400083f8:	93dfd0ef          	jal	ra,40005d34 <memset>
400083fc:	00c12083          	lw	ra,12(sp)
40008400:	00040513          	mv	a0,s0
40008404:	00812403          	lw	s0,8(sp)
40008408:	01010113          	addi	sp,sp,16
4000840c:	00008067          	ret
40008410:	00850793          	addi	a5,a0,8
40008414:	fc1ff06f          	j	400083d4 <_calloc_r+0x80>

40008418 <_close_r>:
40008418:	ff010113          	addi	sp,sp,-16
4000841c:	00812423          	sw	s0,8(sp)
40008420:	00912223          	sw	s1,4(sp)
40008424:	40011437          	lui	s0,0x40011
40008428:	00050493          	mv	s1,a0
4000842c:	00058513          	mv	a0,a1
40008430:	00112623          	sw	ra,12(sp)
40008434:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40008438:	fc8f80ef          	jal	ra,40000c00 <close>
4000843c:	fff00793          	li	a5,-1
40008440:	00f50c63          	beq	a0,a5,40008458 <_close_r+0x40>
40008444:	00c12083          	lw	ra,12(sp)
40008448:	00812403          	lw	s0,8(sp)
4000844c:	00412483          	lw	s1,4(sp)
40008450:	01010113          	addi	sp,sp,16
40008454:	00008067          	ret
40008458:	dd842783          	lw	a5,-552(s0)
4000845c:	fe0784e3          	beqz	a5,40008444 <_close_r+0x2c>
40008460:	00c12083          	lw	ra,12(sp)
40008464:	00f4a023          	sw	a5,0(s1)
40008468:	00812403          	lw	s0,8(sp)
4000846c:	00412483          	lw	s1,4(sp)
40008470:	01010113          	addi	sp,sp,16
40008474:	00008067          	ret

40008478 <_fclose_r>:
40008478:	ff010113          	addi	sp,sp,-16
4000847c:	00112623          	sw	ra,12(sp)
40008480:	00812423          	sw	s0,8(sp)
40008484:	00912223          	sw	s1,4(sp)
40008488:	01212023          	sw	s2,0(sp)
4000848c:	02058063          	beqz	a1,400084ac <_fclose_r+0x34>
40008490:	00050493          	mv	s1,a0
40008494:	00058413          	mv	s0,a1
40008498:	00050663          	beqz	a0,400084a4 <_fclose_r+0x2c>
4000849c:	03852783          	lw	a5,56(a0)
400084a0:	0a078c63          	beqz	a5,40008558 <_fclose_r+0xe0>
400084a4:	00c41783          	lh	a5,12(s0)
400084a8:	02079263          	bnez	a5,400084cc <_fclose_r+0x54>
400084ac:	00c12083          	lw	ra,12(sp)
400084b0:	00000913          	li	s2,0
400084b4:	00090513          	mv	a0,s2
400084b8:	00812403          	lw	s0,8(sp)
400084bc:	00412483          	lw	s1,4(sp)
400084c0:	00012903          	lw	s2,0(sp)
400084c4:	01010113          	addi	sp,sp,16
400084c8:	00008067          	ret
400084cc:	00040593          	mv	a1,s0
400084d0:	00048513          	mv	a0,s1
400084d4:	889fc0ef          	jal	ra,40004d5c <__sflush_r>
400084d8:	02c42783          	lw	a5,44(s0)
400084dc:	00050913          	mv	s2,a0
400084e0:	00078a63          	beqz	a5,400084f4 <_fclose_r+0x7c>
400084e4:	01c42583          	lw	a1,28(s0)
400084e8:	00048513          	mv	a0,s1
400084ec:	000780e7          	jalr	a5
400084f0:	06054863          	bltz	a0,40008560 <_fclose_r+0xe8>
400084f4:	00c45783          	lhu	a5,12(s0)
400084f8:	0807f793          	andi	a5,a5,128
400084fc:	06079663          	bnez	a5,40008568 <_fclose_r+0xf0>
40008500:	03042583          	lw	a1,48(s0)
40008504:	00058c63          	beqz	a1,4000851c <_fclose_r+0xa4>
40008508:	04040793          	addi	a5,s0,64
4000850c:	00f58663          	beq	a1,a5,40008518 <_fclose_r+0xa0>
40008510:	00048513          	mv	a0,s1
40008514:	830fd0ef          	jal	ra,40005544 <_free_r>
40008518:	02042823          	sw	zero,48(s0)
4000851c:	04442583          	lw	a1,68(s0)
40008520:	00058863          	beqz	a1,40008530 <_fclose_r+0xb8>
40008524:	00048513          	mv	a0,s1
40008528:	81cfd0ef          	jal	ra,40005544 <_free_r>
4000852c:	04042223          	sw	zero,68(s0)
40008530:	ea1fc0ef          	jal	ra,400053d0 <__sfp_lock_acquire>
40008534:	00041623          	sh	zero,12(s0)
40008538:	e9dfc0ef          	jal	ra,400053d4 <__sfp_lock_release>
4000853c:	00c12083          	lw	ra,12(sp)
40008540:	00090513          	mv	a0,s2
40008544:	00812403          	lw	s0,8(sp)
40008548:	00412483          	lw	s1,4(sp)
4000854c:	00012903          	lw	s2,0(sp)
40008550:	01010113          	addi	sp,sp,16
40008554:	00008067          	ret
40008558:	e69fc0ef          	jal	ra,400053c0 <__sinit>
4000855c:	f49ff06f          	j	400084a4 <_fclose_r+0x2c>
40008560:	fff00913          	li	s2,-1
40008564:	f91ff06f          	j	400084f4 <_fclose_r+0x7c>
40008568:	01042583          	lw	a1,16(s0)
4000856c:	00048513          	mv	a0,s1
40008570:	fd5fc0ef          	jal	ra,40005544 <_free_r>
40008574:	f8dff06f          	j	40008500 <_fclose_r+0x88>

40008578 <fclose>:
40008578:	4000e7b7          	lui	a5,0x4000e
4000857c:	00050593          	mv	a1,a0
40008580:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
40008584:	ef5ff06f          	j	40008478 <_fclose_r>

40008588 <__fputwc>:
40008588:	fc010113          	addi	sp,sp,-64
4000858c:	02812c23          	sw	s0,56(sp)
40008590:	03412423          	sw	s4,40(sp)
40008594:	03512223          	sw	s5,36(sp)
40008598:	02112e23          	sw	ra,60(sp)
4000859c:	02912a23          	sw	s1,52(sp)
400085a0:	03212823          	sw	s2,48(sp)
400085a4:	03312623          	sw	s3,44(sp)
400085a8:	03612023          	sw	s6,32(sp)
400085ac:	01712e23          	sw	s7,28(sp)
400085b0:	00050a13          	mv	s4,a0
400085b4:	00058a93          	mv	s5,a1
400085b8:	00060413          	mv	s0,a2
400085bc:	c78fd0ef          	jal	ra,40005a34 <__locale_mb_cur_max>
400085c0:	00100793          	li	a5,1
400085c4:	0cf50863          	beq	a0,a5,40008694 <__fputwc+0x10c>
400085c8:	00c10493          	addi	s1,sp,12
400085cc:	05c40693          	addi	a3,s0,92
400085d0:	000a8613          	mv	a2,s5
400085d4:	00048593          	mv	a1,s1
400085d8:	000a0513          	mv	a0,s4
400085dc:	7c5000ef          	jal	ra,400095a0 <_wcrtomb_r>
400085e0:	fff00793          	li	a5,-1
400085e4:	00050993          	mv	s3,a0
400085e8:	08f50e63          	beq	a0,a5,40008684 <__fputwc+0xfc>
400085ec:	0c050463          	beqz	a0,400086b4 <__fputwc+0x12c>
400085f0:	00c14703          	lbu	a4,12(sp)
400085f4:	00000913          	li	s2,0
400085f8:	fff00b93          	li	s7,-1
400085fc:	00a00b13          	li	s6,10
40008600:	0240006f          	j	40008624 <__fputwc+0x9c>
_ELIDABLE_INLINE int __sputc_r(struct _reent *_ptr, int _c, FILE *_p) {
#ifdef __SCLE
	if ((_p->_flags & __SCLE) && _c == '\n')
	  __sputc_r (_ptr, '\r', _p);
#endif
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
40008604:	00042783          	lw	a5,0(s0)
40008608:	00178693          	addi	a3,a5,1
		return (*_p->_p++ = _c);
4000860c:	00d42023          	sw	a3,0(s0)
40008610:	00e78023          	sb	a4,0(a5)
40008614:	00190913          	addi	s2,s2,1
40008618:	00148493          	addi	s1,s1,1
4000861c:	09397c63          	bleu	s3,s2,400086b4 <__fputwc+0x12c>
40008620:	0004c703          	lbu	a4,0(s1)
40008624:	00842783          	lw	a5,8(s0)
40008628:	fff78793          	addi	a5,a5,-1
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
4000862c:	00f42423          	sw	a5,8(s0)
40008630:	fc07dae3          	bgez	a5,40008604 <__fputwc+0x7c>
40008634:	01842683          	lw	a3,24(s0)
40008638:	00070593          	mv	a1,a4
4000863c:	00040613          	mv	a2,s0
	else
		return (__swbuf_r(_ptr, _c, _p));
40008640:	000a0513          	mv	a0,s4
40008644:	00d7c463          	blt	a5,a3,4000864c <__fputwc+0xc4>
40008648:	fb671ee3          	bne	a4,s6,40008604 <__fputwc+0x7c>
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
4000864c:	5c9000ef          	jal	ra,40009414 <__swbuf_r>
40008650:	fd7512e3          	bne	a0,s7,40008614 <__fputwc+0x8c>
		return (__swbuf_r(_ptr, _c, _p));
40008654:	000b8513          	mv	a0,s7
40008658:	03c12083          	lw	ra,60(sp)
4000865c:	03812403          	lw	s0,56(sp)
40008660:	03412483          	lw	s1,52(sp)
40008664:	03012903          	lw	s2,48(sp)
40008668:	02c12983          	lw	s3,44(sp)
4000866c:	02812a03          	lw	s4,40(sp)
40008670:	02412a83          	lw	s5,36(sp)
40008674:	02012b03          	lw	s6,32(sp)
40008678:	01c12b83          	lw	s7,28(sp)
4000867c:	04010113          	addi	sp,sp,64
40008680:	00008067          	ret
40008684:	00c45783          	lhu	a5,12(s0)
40008688:	0407e793          	ori	a5,a5,64
4000868c:	00f41623          	sh	a5,12(s0)
40008690:	fc9ff06f          	j	40008658 <__fputwc+0xd0>
40008694:	fffa8793          	addi	a5,s5,-1
40008698:	0fe00713          	li	a4,254
4000869c:	f2f766e3          	bltu	a4,a5,400085c8 <__fputwc+0x40>
400086a0:	0ffaf713          	andi	a4,s5,255
400086a4:	00e10623          	sb	a4,12(sp)
400086a8:	00050993          	mv	s3,a0
400086ac:	00c10493          	addi	s1,sp,12
400086b0:	f45ff06f          	j	400085f4 <__fputwc+0x6c>
400086b4:	000a8513          	mv	a0,s5
400086b8:	fa1ff06f          	j	40008658 <__fputwc+0xd0>

400086bc <_fputwc_r>:
400086bc:	00c61783          	lh	a5,12(a2)
400086c0:	000026b7          	lui	a3,0x2
400086c4:	01279713          	slli	a4,a5,0x12
400086c8:	00074c63          	bltz	a4,400086e0 <_fputwc_r+0x24>
400086cc:	06462703          	lw	a4,100(a2)
400086d0:	00d7e7b3          	or	a5,a5,a3
400086d4:	00f61623          	sh	a5,12(a2)
400086d8:	00d767b3          	or	a5,a4,a3
400086dc:	06f62223          	sw	a5,100(a2)
400086e0:	ea9ff06f          	j	40008588 <__fputwc>

400086e4 <fputwc>:
400086e4:	ff010113          	addi	sp,sp,-16
400086e8:	4000e7b7          	lui	a5,0x4000e
400086ec:	00912223          	sw	s1,4(sp)
400086f0:	5847a483          	lw	s1,1412(a5) # 4000e584 <_impure_ptr>
400086f4:	00812423          	sw	s0,8(sp)
400086f8:	01212023          	sw	s2,0(sp)
400086fc:	00112623          	sw	ra,12(sp)
40008700:	00050913          	mv	s2,a0
40008704:	00058413          	mv	s0,a1
40008708:	00048663          	beqz	s1,40008714 <fputwc+0x30>
4000870c:	0384a783          	lw	a5,56(s1)
40008710:	04078663          	beqz	a5,4000875c <fputwc+0x78>
40008714:	00c41783          	lh	a5,12(s0)
40008718:	000026b7          	lui	a3,0x2
4000871c:	01279713          	slli	a4,a5,0x12
40008720:	00074c63          	bltz	a4,40008738 <fputwc+0x54>
40008724:	06442703          	lw	a4,100(s0)
40008728:	00d7e7b3          	or	a5,a5,a3
4000872c:	00f41623          	sh	a5,12(s0)
40008730:	00d767b3          	or	a5,a4,a3
40008734:	06f42223          	sw	a5,100(s0)
40008738:	00040613          	mv	a2,s0
4000873c:	00090593          	mv	a1,s2
40008740:	00048513          	mv	a0,s1
40008744:	00c12083          	lw	ra,12(sp)
40008748:	00812403          	lw	s0,8(sp)
4000874c:	00412483          	lw	s1,4(sp)
40008750:	00012903          	lw	s2,0(sp)
40008754:	01010113          	addi	sp,sp,16
40008758:	e31ff06f          	j	40008588 <__fputwc>
4000875c:	00048513          	mv	a0,s1
40008760:	c61fc0ef          	jal	ra,400053c0 <__sinit>
40008764:	fb1ff06f          	j	40008714 <fputwc+0x30>

40008768 <_fstat_r>:
40008768:	ff010113          	addi	sp,sp,-16
4000876c:	00058793          	mv	a5,a1
40008770:	00812423          	sw	s0,8(sp)
40008774:	00912223          	sw	s1,4(sp)
40008778:	40011437          	lui	s0,0x40011
4000877c:	00050493          	mv	s1,a0
40008780:	00060593          	mv	a1,a2
40008784:	00078513          	mv	a0,a5
40008788:	00112623          	sw	ra,12(sp)
4000878c:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40008790:	c74f80ef          	jal	ra,40000c04 <fstat>
40008794:	fff00793          	li	a5,-1
40008798:	00f50c63          	beq	a0,a5,400087b0 <_fstat_r+0x48>
4000879c:	00c12083          	lw	ra,12(sp)
400087a0:	00812403          	lw	s0,8(sp)
400087a4:	00412483          	lw	s1,4(sp)
400087a8:	01010113          	addi	sp,sp,16
400087ac:	00008067          	ret
400087b0:	dd842783          	lw	a5,-552(s0)
400087b4:	fe0784e3          	beqz	a5,4000879c <_fstat_r+0x34>
400087b8:	00c12083          	lw	ra,12(sp)
400087bc:	00f4a023          	sw	a5,0(s1)
400087c0:	00812403          	lw	s0,8(sp)
400087c4:	00412483          	lw	s1,4(sp)
400087c8:	01010113          	addi	sp,sp,16
400087cc:	00008067          	ret

400087d0 <__sfvwrite_r>:
400087d0:	00862783          	lw	a5,8(a2)
400087d4:	1c078263          	beqz	a5,40008998 <__sfvwrite_r+0x1c8>
400087d8:	00c5d703          	lhu	a4,12(a1)
400087dc:	fc010113          	addi	sp,sp,-64
400087e0:	02812c23          	sw	s0,56(sp)
400087e4:	03412423          	sw	s4,40(sp)
400087e8:	03612023          	sw	s6,32(sp)
400087ec:	02112e23          	sw	ra,60(sp)
400087f0:	02912a23          	sw	s1,52(sp)
400087f4:	03212823          	sw	s2,48(sp)
400087f8:	03312623          	sw	s3,44(sp)
400087fc:	03512223          	sw	s5,36(sp)
40008800:	01712e23          	sw	s7,28(sp)
40008804:	01812c23          	sw	s8,24(sp)
40008808:	01912a23          	sw	s9,20(sp)
4000880c:	01a12823          	sw	s10,16(sp)
40008810:	01b12623          	sw	s11,12(sp)
40008814:	00877793          	andi	a5,a4,8
40008818:	00058413          	mv	s0,a1
4000881c:	00050b13          	mv	s6,a0
40008820:	00060a13          	mv	s4,a2
40008824:	0a078663          	beqz	a5,400088d0 <__sfvwrite_r+0x100>
40008828:	0105a783          	lw	a5,16(a1)
4000882c:	0a078263          	beqz	a5,400088d0 <__sfvwrite_r+0x100>
40008830:	00277793          	andi	a5,a4,2
40008834:	000a2483          	lw	s1,0(s4)
40008838:	0a078e63          	beqz	a5,400088f4 <__sfvwrite_r+0x124>
4000883c:	80000ab7          	lui	s5,0x80000
40008840:	00000993          	li	s3,0
40008844:	00000913          	li	s2,0
40008848:	c00aca93          	xori	s5,s5,-1024
4000884c:	00098613          	mv	a2,s3
40008850:	000b0513          	mv	a0,s6
40008854:	12090a63          	beqz	s2,40008988 <__sfvwrite_r+0x1b8>
40008858:	00090693          	mv	a3,s2
4000885c:	012af463          	bleu	s2,s5,40008864 <__sfvwrite_r+0x94>
40008860:	000a8693          	mv	a3,s5
40008864:	02442783          	lw	a5,36(s0)
40008868:	01c42583          	lw	a1,28(s0)
4000886c:	000780e7          	jalr	a5
40008870:	14a05263          	blez	a0,400089b4 <__sfvwrite_r+0x1e4>
40008874:	008a2783          	lw	a5,8(s4)
40008878:	00a989b3          	add	s3,s3,a0
4000887c:	40a90933          	sub	s2,s2,a0
40008880:	40a78533          	sub	a0,a5,a0
40008884:	00aa2423          	sw	a0,8(s4)
40008888:	fc0512e3          	bnez	a0,4000884c <__sfvwrite_r+0x7c>
4000888c:	00000793          	li	a5,0
40008890:	03c12083          	lw	ra,60(sp)
40008894:	00078513          	mv	a0,a5
40008898:	03812403          	lw	s0,56(sp)
4000889c:	03412483          	lw	s1,52(sp)
400088a0:	03012903          	lw	s2,48(sp)
400088a4:	02c12983          	lw	s3,44(sp)
400088a8:	02812a03          	lw	s4,40(sp)
400088ac:	02412a83          	lw	s5,36(sp)
400088b0:	02012b03          	lw	s6,32(sp)
400088b4:	01c12b83          	lw	s7,28(sp)
400088b8:	01812c03          	lw	s8,24(sp)
400088bc:	01412c83          	lw	s9,20(sp)
400088c0:	01012d03          	lw	s10,16(sp)
400088c4:	00c12d83          	lw	s11,12(sp)
400088c8:	04010113          	addi	sp,sp,64
400088cc:	00008067          	ret
400088d0:	00040593          	mv	a1,s0
400088d4:	000b0513          	mv	a0,s6
400088d8:	b8dfa0ef          	jal	ra,40003464 <__swsetup_r>
400088dc:	fff00793          	li	a5,-1
400088e0:	fa0518e3          	bnez	a0,40008890 <__sfvwrite_r+0xc0>
400088e4:	00c45703          	lhu	a4,12(s0)
400088e8:	000a2483          	lw	s1,0(s4)
400088ec:	00277793          	andi	a5,a4,2
400088f0:	f40796e3          	bnez	a5,4000883c <__sfvwrite_r+0x6c>
400088f4:	00177793          	andi	a5,a4,1
400088f8:	0c079863          	bnez	a5,400089c8 <__sfvwrite_r+0x1f8>
400088fc:	80000bb7          	lui	s7,0x80000
40008900:	00000c13          	li	s8,0
40008904:	00000913          	li	s2,0
40008908:	fffbcb93          	not	s7,s7
4000890c:	06090663          	beqz	s2,40008978 <__sfvwrite_r+0x1a8>
40008910:	20077793          	andi	a5,a4,512
40008914:	00842983          	lw	s3,8(s0)
40008918:	1a078263          	beqz	a5,40008abc <__sfvwrite_r+0x2ec>
4000891c:	27396663          	bltu	s2,s3,40008b88 <__sfvwrite_r+0x3b8>
40008920:	48077793          	andi	a5,a4,1152
40008924:	26079c63          	bnez	a5,40008b9c <__sfvwrite_r+0x3cc>
40008928:	00042503          	lw	a0,0(s0)
4000892c:	00090a93          	mv	s5,s2
40008930:	00098c93          	mv	s9,s3
40008934:	000c8613          	mv	a2,s9
40008938:	000c0593          	mv	a1,s8
4000893c:	410000ef          	jal	ra,40008d4c <memmove>
40008940:	00842783          	lw	a5,8(s0)
40008944:	00042603          	lw	a2,0(s0)
40008948:	413789b3          	sub	s3,a5,s3
4000894c:	01960633          	add	a2,a2,s9
40008950:	01342423          	sw	s3,8(s0)
40008954:	00c42023          	sw	a2,0(s0)
40008958:	008a2783          	lw	a5,8(s4)
4000895c:	015c0c33          	add	s8,s8,s5
40008960:	41590933          	sub	s2,s2,s5
40008964:	415789b3          	sub	s3,a5,s5
40008968:	013a2423          	sw	s3,8(s4)
4000896c:	f20980e3          	beqz	s3,4000888c <__sfvwrite_r+0xbc>
40008970:	00c45703          	lhu	a4,12(s0)
40008974:	f8091ee3          	bnez	s2,40008910 <__sfvwrite_r+0x140>
40008978:	0004ac03          	lw	s8,0(s1)
4000897c:	0044a903          	lw	s2,4(s1)
40008980:	00848493          	addi	s1,s1,8
40008984:	f89ff06f          	j	4000890c <__sfvwrite_r+0x13c>
40008988:	0004a983          	lw	s3,0(s1)
4000898c:	0044a903          	lw	s2,4(s1)
40008990:	00848493          	addi	s1,s1,8
40008994:	eb9ff06f          	j	4000884c <__sfvwrite_r+0x7c>
40008998:	00000793          	li	a5,0
4000899c:	00078513          	mv	a0,a5
400089a0:	00008067          	ret
400089a4:	00040593          	mv	a1,s0
400089a8:	000b0513          	mv	a0,s6
400089ac:	e44fc0ef          	jal	ra,40004ff0 <_fflush_r>
400089b0:	08050863          	beqz	a0,40008a40 <__sfvwrite_r+0x270>
400089b4:	00c41783          	lh	a5,12(s0)
400089b8:	0407e793          	ori	a5,a5,64
400089bc:	00f41623          	sh	a5,12(s0)
400089c0:	fff00793          	li	a5,-1
400089c4:	ecdff06f          	j	40008890 <__sfvwrite_r+0xc0>
400089c8:	00000913          	li	s2,0
400089cc:	00000993          	li	s3,0
400089d0:	00000513          	li	a0,0
400089d4:	00000d13          	li	s10,0
400089d8:	00a00c93          	li	s9,10
400089dc:	00100c13          	li	s8,1
400089e0:	06090e63          	beqz	s2,40008a5c <__sfvwrite_r+0x28c>
400089e4:	08050463          	beqz	a0,40008a6c <__sfvwrite_r+0x29c>
400089e8:	00098b93          	mv	s7,s3
400089ec:	01397463          	bleu	s3,s2,400089f4 <__sfvwrite_r+0x224>
400089f0:	00090b93          	mv	s7,s2
400089f4:	00042503          	lw	a0,0(s0)
400089f8:	01042783          	lw	a5,16(s0)
400089fc:	000b8a93          	mv	s5,s7
40008a00:	01442683          	lw	a3,20(s0)
40008a04:	00a7f863          	bleu	a0,a5,40008a14 <__sfvwrite_r+0x244>
40008a08:	00842d83          	lw	s11,8(s0)
40008a0c:	01b68db3          	add	s11,a3,s11
40008a10:	077dce63          	blt	s11,s7,40008a8c <__sfvwrite_r+0x2bc>
40008a14:	14dbc663          	blt	s7,a3,40008b60 <__sfvwrite_r+0x390>
40008a18:	02442783          	lw	a5,36(s0)
40008a1c:	01c42583          	lw	a1,28(s0)
40008a20:	000d0613          	mv	a2,s10
40008a24:	000b0513          	mv	a0,s6
40008a28:	000780e7          	jalr	a5
40008a2c:	00050a93          	mv	s5,a0
40008a30:	f8a052e3          	blez	a0,400089b4 <__sfvwrite_r+0x1e4>
40008a34:	415989b3          	sub	s3,s3,s5
40008a38:	000c0513          	mv	a0,s8
40008a3c:	f60984e3          	beqz	s3,400089a4 <__sfvwrite_r+0x1d4>
40008a40:	008a2783          	lw	a5,8(s4)
40008a44:	015d0d33          	add	s10,s10,s5
40008a48:	41590933          	sub	s2,s2,s5
40008a4c:	41578ab3          	sub	s5,a5,s5
40008a50:	015a2423          	sw	s5,8(s4)
40008a54:	e20a8ce3          	beqz	s5,4000888c <__sfvwrite_r+0xbc>
40008a58:	f80916e3          	bnez	s2,400089e4 <__sfvwrite_r+0x214>
40008a5c:	0044a903          	lw	s2,4(s1)
40008a60:	0004ad03          	lw	s10,0(s1)
40008a64:	00848493          	addi	s1,s1,8
40008a68:	fe090ae3          	beqz	s2,40008a5c <__sfvwrite_r+0x28c>
40008a6c:	00090613          	mv	a2,s2
40008a70:	000c8593          	mv	a1,s9
40008a74:	000d0513          	mv	a0,s10
40008a78:	9e0fd0ef          	jal	ra,40005c58 <memchr>
40008a7c:	1e050663          	beqz	a0,40008c68 <__sfvwrite_r+0x498>
40008a80:	00150513          	addi	a0,a0,1
40008a84:	41a509b3          	sub	s3,a0,s10
40008a88:	f61ff06f          	j	400089e8 <__sfvwrite_r+0x218>
40008a8c:	000d0593          	mv	a1,s10
40008a90:	000d8613          	mv	a2,s11
40008a94:	2b8000ef          	jal	ra,40008d4c <memmove>
40008a98:	00042783          	lw	a5,0(s0)
40008a9c:	00040593          	mv	a1,s0
40008aa0:	000b0513          	mv	a0,s6
40008aa4:	01b787b3          	add	a5,a5,s11
40008aa8:	00f42023          	sw	a5,0(s0)
40008aac:	d44fc0ef          	jal	ra,40004ff0 <_fflush_r>
40008ab0:	f00512e3          	bnez	a0,400089b4 <__sfvwrite_r+0x1e4>
40008ab4:	000d8a93          	mv	s5,s11
40008ab8:	f7dff06f          	j	40008a34 <__sfvwrite_r+0x264>
40008abc:	00042503          	lw	a0,0(s0)
40008ac0:	01042783          	lw	a5,16(s0)
40008ac4:	00a7e663          	bltu	a5,a0,40008ad0 <__sfvwrite_r+0x300>
40008ac8:	01442a83          	lw	s5,20(s0)
40008acc:	05597a63          	bleu	s5,s2,40008b20 <__sfvwrite_r+0x350>
40008ad0:	01397463          	bleu	s3,s2,40008ad8 <__sfvwrite_r+0x308>
40008ad4:	00090993          	mv	s3,s2
40008ad8:	00098613          	mv	a2,s3
40008adc:	000c0593          	mv	a1,s8
40008ae0:	26c000ef          	jal	ra,40008d4c <memmove>
40008ae4:	00842783          	lw	a5,8(s0)
40008ae8:	00042703          	lw	a4,0(s0)
40008aec:	413787b3          	sub	a5,a5,s3
40008af0:	01370733          	add	a4,a4,s3
40008af4:	00f42423          	sw	a5,8(s0)
40008af8:	00e42023          	sw	a4,0(s0)
40008afc:	00078663          	beqz	a5,40008b08 <__sfvwrite_r+0x338>
40008b00:	00098a93          	mv	s5,s3
40008b04:	e55ff06f          	j	40008958 <__sfvwrite_r+0x188>
40008b08:	00040593          	mv	a1,s0
40008b0c:	000b0513          	mv	a0,s6
40008b10:	ce0fc0ef          	jal	ra,40004ff0 <_fflush_r>
40008b14:	ea0510e3          	bnez	a0,400089b4 <__sfvwrite_r+0x1e4>
40008b18:	00098a93          	mv	s5,s3
40008b1c:	e3dff06f          	j	40008958 <__sfvwrite_r+0x188>
40008b20:	00090513          	mv	a0,s2
40008b24:	012bf463          	bleu	s2,s7,40008b2c <__sfvwrite_r+0x35c>
40008b28:	000b8513          	mv	a0,s7
40008b2c:	000a8593          	mv	a1,s5
40008b30:	3a4040ef          	jal	ra,4000ced4 <__divsi3>
40008b34:	000a8593          	mv	a1,s5
40008b38:	378040ef          	jal	ra,4000ceb0 <__mulsi3>
40008b3c:	01c42583          	lw	a1,28(s0)
40008b40:	02442783          	lw	a5,36(s0)
40008b44:	00050693          	mv	a3,a0
40008b48:	000c0613          	mv	a2,s8
40008b4c:	000b0513          	mv	a0,s6
40008b50:	000780e7          	jalr	a5
40008b54:	e6a050e3          	blez	a0,400089b4 <__sfvwrite_r+0x1e4>
40008b58:	00050a93          	mv	s5,a0
40008b5c:	dfdff06f          	j	40008958 <__sfvwrite_r+0x188>
40008b60:	000b8613          	mv	a2,s7
40008b64:	000d0593          	mv	a1,s10
40008b68:	1e4000ef          	jal	ra,40008d4c <memmove>
40008b6c:	00842703          	lw	a4,8(s0)
40008b70:	00042783          	lw	a5,0(s0)
40008b74:	41770733          	sub	a4,a4,s7
40008b78:	01778bb3          	add	s7,a5,s7
40008b7c:	00e42423          	sw	a4,8(s0)
40008b80:	01742023          	sw	s7,0(s0)
40008b84:	eb1ff06f          	j	40008a34 <__sfvwrite_r+0x264>
40008b88:	00042503          	lw	a0,0(s0)
40008b8c:	00090993          	mv	s3,s2
40008b90:	00090a93          	mv	s5,s2
40008b94:	00090c93          	mv	s9,s2
40008b98:	d9dff06f          	j	40008934 <__sfvwrite_r+0x164>
40008b9c:	01442783          	lw	a5,20(s0)
40008ba0:	01042583          	lw	a1,16(s0)
40008ba4:	00042a83          	lw	s5,0(s0)
40008ba8:	00179993          	slli	s3,a5,0x1
40008bac:	00f987b3          	add	a5,s3,a5
40008bb0:	01f7d993          	srli	s3,a5,0x1f
40008bb4:	40ba8ab3          	sub	s5,s5,a1
40008bb8:	00f989b3          	add	s3,s3,a5
40008bbc:	001a8793          	addi	a5,s5,1 # 80000001 <end+0x3ffef221>
40008bc0:	4019d993          	srai	s3,s3,0x1
40008bc4:	012787b3          	add	a5,a5,s2
40008bc8:	00098613          	mv	a2,s3
40008bcc:	00f9f663          	bleu	a5,s3,40008bd8 <__sfvwrite_r+0x408>
40008bd0:	00078993          	mv	s3,a5
40008bd4:	00078613          	mv	a2,a5
40008bd8:	40077713          	andi	a4,a4,1024
40008bdc:	04070e63          	beqz	a4,40008c38 <__sfvwrite_r+0x468>
40008be0:	00060593          	mv	a1,a2
40008be4:	000b0513          	mv	a0,s6
40008be8:	928f80ef          	jal	ra,40000d10 <_malloc_r>
40008bec:	00050c93          	mv	s9,a0
40008bf0:	08050063          	beqz	a0,40008c70 <__sfvwrite_r+0x4a0>
40008bf4:	01042583          	lw	a1,16(s0)
40008bf8:	000a8613          	mv	a2,s5
40008bfc:	861f80ef          	jal	ra,4000145c <memcpy>
40008c00:	00c45783          	lhu	a5,12(s0)
40008c04:	b7f7f793          	andi	a5,a5,-1153
40008c08:	0807e793          	ori	a5,a5,128
40008c0c:	00f41623          	sh	a5,12(s0)
40008c10:	015c8533          	add	a0,s9,s5
40008c14:	41598ab3          	sub	s5,s3,s5
40008c18:	01942823          	sw	s9,16(s0)
40008c1c:	01342a23          	sw	s3,20(s0)
40008c20:	01542423          	sw	s5,8(s0)
40008c24:	00a42023          	sw	a0,0(s0)
40008c28:	00090993          	mv	s3,s2
40008c2c:	00090a93          	mv	s5,s2
40008c30:	00090c93          	mv	s9,s2
40008c34:	d01ff06f          	j	40008934 <__sfvwrite_r+0x164>
40008c38:	000b0513          	mv	a0,s6
40008c3c:	298000ef          	jal	ra,40008ed4 <_realloc_r>
40008c40:	00050c93          	mv	s9,a0
40008c44:	fc0516e3          	bnez	a0,40008c10 <__sfvwrite_r+0x440>
40008c48:	01042583          	lw	a1,16(s0)
40008c4c:	000b0513          	mv	a0,s6
40008c50:	8f5fc0ef          	jal	ra,40005544 <_free_r>
40008c54:	00c41783          	lh	a5,12(s0)
40008c58:	00c00713          	li	a4,12
40008c5c:	00eb2023          	sw	a4,0(s6)
40008c60:	f7f7f793          	andi	a5,a5,-129
40008c64:	d55ff06f          	j	400089b8 <__sfvwrite_r+0x1e8>
40008c68:	00190993          	addi	s3,s2,1
40008c6c:	d7dff06f          	j	400089e8 <__sfvwrite_r+0x218>
40008c70:	00c00793          	li	a5,12
40008c74:	00fb2023          	sw	a5,0(s6)
40008c78:	00c41783          	lh	a5,12(s0)
40008c7c:	d3dff06f          	j	400089b8 <__sfvwrite_r+0x1e8>

40008c80 <_isatty_r>:
40008c80:	ff010113          	addi	sp,sp,-16
40008c84:	00812423          	sw	s0,8(sp)
40008c88:	00912223          	sw	s1,4(sp)
40008c8c:	40011437          	lui	s0,0x40011
40008c90:	00050493          	mv	s1,a0
40008c94:	00058513          	mv	a0,a1
40008c98:	00112623          	sw	ra,12(sp)
40008c9c:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40008ca0:	f6df70ef          	jal	ra,40000c0c <isatty>
40008ca4:	fff00793          	li	a5,-1
40008ca8:	00f50c63          	beq	a0,a5,40008cc0 <_isatty_r+0x40>
40008cac:	00c12083          	lw	ra,12(sp)
40008cb0:	00812403          	lw	s0,8(sp)
40008cb4:	00412483          	lw	s1,4(sp)
40008cb8:	01010113          	addi	sp,sp,16
40008cbc:	00008067          	ret
40008cc0:	dd842783          	lw	a5,-552(s0)
40008cc4:	fe0784e3          	beqz	a5,40008cac <_isatty_r+0x2c>
40008cc8:	00c12083          	lw	ra,12(sp)
40008ccc:	00f4a023          	sw	a5,0(s1)
40008cd0:	00812403          	lw	s0,8(sp)
40008cd4:	00412483          	lw	s1,4(sp)
40008cd8:	01010113          	addi	sp,sp,16
40008cdc:	00008067          	ret

40008ce0 <_lseek_r>:
40008ce0:	ff010113          	addi	sp,sp,-16
40008ce4:	00058793          	mv	a5,a1
40008ce8:	00812423          	sw	s0,8(sp)
40008cec:	00912223          	sw	s1,4(sp)
40008cf0:	00060593          	mv	a1,a2
40008cf4:	00050493          	mv	s1,a0
40008cf8:	40011437          	lui	s0,0x40011
40008cfc:	00078513          	mv	a0,a5
40008d00:	00068613          	mv	a2,a3
40008d04:	00112623          	sw	ra,12(sp)
40008d08:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40008d0c:	f09f70ef          	jal	ra,40000c14 <lseek>
40008d10:	fff00793          	li	a5,-1
40008d14:	00f50c63          	beq	a0,a5,40008d2c <_lseek_r+0x4c>
40008d18:	00c12083          	lw	ra,12(sp)
40008d1c:	00812403          	lw	s0,8(sp)
40008d20:	00412483          	lw	s1,4(sp)
40008d24:	01010113          	addi	sp,sp,16
40008d28:	00008067          	ret
40008d2c:	dd842783          	lw	a5,-552(s0)
40008d30:	fe0784e3          	beqz	a5,40008d18 <_lseek_r+0x38>
40008d34:	00c12083          	lw	ra,12(sp)
40008d38:	00f4a023          	sw	a5,0(s1)
40008d3c:	00812403          	lw	s0,8(sp)
40008d40:	00412483          	lw	s1,4(sp)
40008d44:	01010113          	addi	sp,sp,16
40008d48:	00008067          	ret

40008d4c <memmove>:
40008d4c:	02a5f663          	bleu	a0,a1,40008d78 <memmove+0x2c>
40008d50:	00c587b3          	add	a5,a1,a2
40008d54:	02f57263          	bleu	a5,a0,40008d78 <memmove+0x2c>
40008d58:	00c50733          	add	a4,a0,a2
40008d5c:	04060263          	beqz	a2,40008da0 <memmove+0x54>
40008d60:	fff78793          	addi	a5,a5,-1
40008d64:	0007c683          	lbu	a3,0(a5)
40008d68:	fff70713          	addi	a4,a4,-1
40008d6c:	00d70023          	sb	a3,0(a4)
40008d70:	fef598e3          	bne	a1,a5,40008d60 <memmove+0x14>
40008d74:	00008067          	ret
40008d78:	00f00893          	li	a7,15
40008d7c:	00050793          	mv	a5,a0
40008d80:	02c8e263          	bltu	a7,a2,40008da4 <memmove+0x58>
40008d84:	0c060a63          	beqz	a2,40008e58 <memmove+0x10c>
40008d88:	00c58633          	add	a2,a1,a2
40008d8c:	00158593          	addi	a1,a1,1
40008d90:	fff5c703          	lbu	a4,-1(a1)
40008d94:	00178793          	addi	a5,a5,1
40008d98:	fee78fa3          	sb	a4,-1(a5)
40008d9c:	feb618e3          	bne	a2,a1,40008d8c <memmove+0x40>
40008da0:	00008067          	ret
40008da4:	00a5e7b3          	or	a5,a1,a0
40008da8:	0037f793          	andi	a5,a5,3
40008dac:	0a079263          	bnez	a5,40008e50 <memmove+0x104>
40008db0:	00058713          	mv	a4,a1
40008db4:	00050793          	mv	a5,a0
40008db8:	00060693          	mv	a3,a2
40008dbc:	00072803          	lw	a6,0(a4)
40008dc0:	01078793          	addi	a5,a5,16
40008dc4:	01070713          	addi	a4,a4,16
40008dc8:	ff07a823          	sw	a6,-16(a5)
40008dcc:	ff472803          	lw	a6,-12(a4)
40008dd0:	ff068693          	addi	a3,a3,-16 # 1ff0 <_stack_start+0x1638>
40008dd4:	ff07aa23          	sw	a6,-12(a5)
40008dd8:	ff872803          	lw	a6,-8(a4)
40008ddc:	ff07ac23          	sw	a6,-8(a5)
40008de0:	ffc72803          	lw	a6,-4(a4)
40008de4:	ff07ae23          	sw	a6,-4(a5)
40008de8:	fcd8eae3          	bltu	a7,a3,40008dbc <memmove+0x70>
40008dec:	ff060713          	addi	a4,a2,-16
40008df0:	ff077713          	andi	a4,a4,-16
40008df4:	01070713          	addi	a4,a4,16
40008df8:	00f67e13          	andi	t3,a2,15
40008dfc:	00300313          	li	t1,3
40008e00:	00e507b3          	add	a5,a0,a4
40008e04:	00e585b3          	add	a1,a1,a4
40008e08:	05c37a63          	bleu	t3,t1,40008e5c <memmove+0x110>
40008e0c:	00058813          	mv	a6,a1
40008e10:	00078693          	mv	a3,a5
40008e14:	000e0713          	mv	a4,t3
40008e18:	00480813          	addi	a6,a6,4
40008e1c:	ffc82883          	lw	a7,-4(a6)
40008e20:	00468693          	addi	a3,a3,4
40008e24:	ffc70713          	addi	a4,a4,-4
40008e28:	ff16ae23          	sw	a7,-4(a3)
40008e2c:	fee366e3          	bltu	t1,a4,40008e18 <memmove+0xcc>
40008e30:	ffce0713          	addi	a4,t3,-4
40008e34:	ffc77713          	andi	a4,a4,-4
40008e38:	00470713          	addi	a4,a4,4
40008e3c:	00367613          	andi	a2,a2,3
40008e40:	00e585b3          	add	a1,a1,a4
40008e44:	00e787b3          	add	a5,a5,a4
40008e48:	f40610e3          	bnez	a2,40008d88 <memmove+0x3c>
40008e4c:	00c0006f          	j	40008e58 <memmove+0x10c>
40008e50:	00050793          	mv	a5,a0
40008e54:	f35ff06f          	j	40008d88 <memmove+0x3c>
40008e58:	00008067          	ret
40008e5c:	000e0613          	mv	a2,t3
40008e60:	f20614e3          	bnez	a2,40008d88 <memmove+0x3c>
40008e64:	ff5ff06f          	j	40008e58 <memmove+0x10c>

40008e68 <_read_r>:
40008e68:	ff010113          	addi	sp,sp,-16
40008e6c:	00058793          	mv	a5,a1
40008e70:	00812423          	sw	s0,8(sp)
40008e74:	00912223          	sw	s1,4(sp)
40008e78:	00060593          	mv	a1,a2
40008e7c:	00050493          	mv	s1,a0
40008e80:	40011437          	lui	s0,0x40011
40008e84:	00078513          	mv	a0,a5
40008e88:	00068613          	mv	a2,a3
40008e8c:	00112623          	sw	ra,12(sp)
40008e90:	dc042c23          	sw	zero,-552(s0) # 40010dd8 <errno>
40008e94:	d89f70ef          	jal	ra,40000c1c <read>
40008e98:	fff00793          	li	a5,-1
40008e9c:	00f50c63          	beq	a0,a5,40008eb4 <_read_r+0x4c>
40008ea0:	00c12083          	lw	ra,12(sp)
40008ea4:	00812403          	lw	s0,8(sp)
40008ea8:	00412483          	lw	s1,4(sp)
40008eac:	01010113          	addi	sp,sp,16
40008eb0:	00008067          	ret
40008eb4:	dd842783          	lw	a5,-552(s0)
40008eb8:	fe0784e3          	beqz	a5,40008ea0 <_read_r+0x38>
40008ebc:	00c12083          	lw	ra,12(sp)
40008ec0:	00f4a023          	sw	a5,0(s1)
40008ec4:	00812403          	lw	s0,8(sp)
40008ec8:	00412483          	lw	s1,4(sp)
40008ecc:	01010113          	addi	sp,sp,16
40008ed0:	00008067          	ret

40008ed4 <_realloc_r>:
40008ed4:	1e058c63          	beqz	a1,400090cc <_realloc_r+0x1f8>
40008ed8:	fd010113          	addi	sp,sp,-48
40008edc:	02812423          	sw	s0,40(sp)
40008ee0:	02912223          	sw	s1,36(sp)
40008ee4:	00058413          	mv	s0,a1
40008ee8:	03212023          	sw	s2,32(sp)
40008eec:	01312e23          	sw	s3,28(sp)
40008ef0:	01412c23          	sw	s4,24(sp)
40008ef4:	01512a23          	sw	s5,20(sp)
40008ef8:	00060493          	mv	s1,a2
40008efc:	02112623          	sw	ra,44(sp)
40008f00:	01612823          	sw	s6,16(sp)
40008f04:	01712623          	sw	s7,12(sp)
40008f08:	01812423          	sw	s8,8(sp)
40008f0c:	00050a13          	mv	s4,a0
40008f10:	e68f80ef          	jal	ra,40001578 <__malloc_lock>
40008f14:	ffc42783          	lw	a5,-4(s0)
40008f18:	00b48993          	addi	s3,s1,11
40008f1c:	01600713          	li	a4,22
40008f20:	ff840a93          	addi	s5,s0,-8
40008f24:	ffc7f913          	andi	s2,a5,-4
40008f28:	0b377c63          	bleu	s3,a4,40008fe0 <_realloc_r+0x10c>
40008f2c:	ff89f993          	andi	s3,s3,-8
40008f30:	00098713          	mv	a4,s3
40008f34:	1409c663          	bltz	s3,40009080 <_realloc_r+0x1ac>
40008f38:	1499e463          	bltu	s3,s1,40009080 <_realloc_r+0x1ac>
40008f3c:	0ae95863          	ble	a4,s2,40008fec <_realloc_r+0x118>
40008f40:	4000eb37          	lui	s6,0x4000e
40008f44:	cd0b0b13          	addi	s6,s6,-816 # 4000dcd0 <_etext>
40008f48:	008b2603          	lw	a2,8(s6)
40008f4c:	012a86b3          	add	a3,s5,s2
40008f50:	2cc68263          	beq	a3,a2,40009214 <_realloc_r+0x340>
40008f54:	0046a603          	lw	a2,4(a3)
40008f58:	ffe67593          	andi	a1,a2,-2
40008f5c:	00b685b3          	add	a1,a3,a1
40008f60:	0045a583          	lw	a1,4(a1)
40008f64:	0015f593          	andi	a1,a1,1
40008f68:	0e058863          	beqz	a1,40009058 <_realloc_r+0x184>
40008f6c:	0017f793          	andi	a5,a5,1
40008f70:	20078663          	beqz	a5,4000917c <_realloc_r+0x2a8>
40008f74:	00048593          	mv	a1,s1
40008f78:	000a0513          	mv	a0,s4
40008f7c:	d95f70ef          	jal	ra,40000d10 <_malloc_r>
40008f80:	00050493          	mv	s1,a0
40008f84:	08050c63          	beqz	a0,4000901c <_realloc_r+0x148>
40008f88:	ffc42783          	lw	a5,-4(s0)
40008f8c:	ff850713          	addi	a4,a0,-8
40008f90:	ffe7f793          	andi	a5,a5,-2
40008f94:	00fa87b3          	add	a5,s5,a5
40008f98:	3ef70463          	beq	a4,a5,40009380 <_realloc_r+0x4ac>
40008f9c:	ffc90613          	addi	a2,s2,-4
40008fa0:	02400793          	li	a5,36
40008fa4:	38c7ec63          	bltu	a5,a2,4000933c <_realloc_r+0x468>
40008fa8:	01300713          	li	a4,19
40008fac:	32c76663          	bltu	a4,a2,400092d8 <_realloc_r+0x404>
40008fb0:	00050793          	mv	a5,a0
40008fb4:	00040713          	mv	a4,s0
40008fb8:	00072683          	lw	a3,0(a4)
40008fbc:	00d7a023          	sw	a3,0(a5)
40008fc0:	00472683          	lw	a3,4(a4)
40008fc4:	00d7a223          	sw	a3,4(a5)
40008fc8:	00872703          	lw	a4,8(a4)
40008fcc:	00e7a423          	sw	a4,8(a5)
40008fd0:	00040593          	mv	a1,s0
40008fd4:	000a0513          	mv	a0,s4
40008fd8:	d6cfc0ef          	jal	ra,40005544 <_free_r>
40008fdc:	0400006f          	j	4000901c <_realloc_r+0x148>
40008fe0:	01000713          	li	a4,16
40008fe4:	00070993          	mv	s3,a4
40008fe8:	f51ff06f          	j	40008f38 <_realloc_r+0x64>
40008fec:	00040493          	mv	s1,s0
40008ff0:	413907b3          	sub	a5,s2,s3
40008ff4:	00f00713          	li	a4,15
40008ff8:	08f76c63          	bltu	a4,a5,40009090 <_realloc_r+0x1bc>
40008ffc:	004aa603          	lw	a2,4(s5)
40009000:	012a8733          	add	a4,s5,s2
40009004:	00167613          	andi	a2,a2,1
40009008:	01266933          	or	s2,a2,s2
4000900c:	012aa223          	sw	s2,4(s5)
40009010:	00472783          	lw	a5,4(a4)
40009014:	0017e793          	ori	a5,a5,1
40009018:	00f72223          	sw	a5,4(a4)
4000901c:	000a0513          	mv	a0,s4
40009020:	d5cf80ef          	jal	ra,4000157c <__malloc_unlock>
40009024:	02c12083          	lw	ra,44(sp)
40009028:	00048513          	mv	a0,s1
4000902c:	02812403          	lw	s0,40(sp)
40009030:	02412483          	lw	s1,36(sp)
40009034:	02012903          	lw	s2,32(sp)
40009038:	01c12983          	lw	s3,28(sp)
4000903c:	01812a03          	lw	s4,24(sp)
40009040:	01412a83          	lw	s5,20(sp)
40009044:	01012b03          	lw	s6,16(sp)
40009048:	00c12b83          	lw	s7,12(sp)
4000904c:	00812c03          	lw	s8,8(sp)
40009050:	03010113          	addi	sp,sp,48
40009054:	00008067          	ret
40009058:	ffc67613          	andi	a2,a2,-4
4000905c:	00c905b3          	add	a1,s2,a2
40009060:	06e5ca63          	blt	a1,a4,400090d4 <_realloc_r+0x200>
40009064:	00c6a783          	lw	a5,12(a3)
40009068:	0086a703          	lw	a4,8(a3)
4000906c:	00040493          	mv	s1,s0
40009070:	00058913          	mv	s2,a1
40009074:	00f72623          	sw	a5,12(a4)
40009078:	00e7a423          	sw	a4,8(a5)
4000907c:	f75ff06f          	j	40008ff0 <_realloc_r+0x11c>
40009080:	00c00793          	li	a5,12
40009084:	00fa2023          	sw	a5,0(s4)
40009088:	00000493          	li	s1,0
4000908c:	f99ff06f          	j	40009024 <_realloc_r+0x150>
40009090:	004aa703          	lw	a4,4(s5)
40009094:	013a85b3          	add	a1,s5,s3
40009098:	0017e793          	ori	a5,a5,1
4000909c:	00177713          	andi	a4,a4,1
400090a0:	013769b3          	or	s3,a4,s3
400090a4:	013aa223          	sw	s3,4(s5)
400090a8:	00f5a223          	sw	a5,4(a1)
400090ac:	012a8933          	add	s2,s5,s2
400090b0:	00492783          	lw	a5,4(s2)
400090b4:	00858593          	addi	a1,a1,8
400090b8:	000a0513          	mv	a0,s4
400090bc:	0017e793          	ori	a5,a5,1
400090c0:	00f92223          	sw	a5,4(s2)
400090c4:	c80fc0ef          	jal	ra,40005544 <_free_r>
400090c8:	f55ff06f          	j	4000901c <_realloc_r+0x148>
400090cc:	00060593          	mv	a1,a2
400090d0:	c41f706f          	j	40000d10 <_malloc_r>
400090d4:	0017f793          	andi	a5,a5,1
400090d8:	e8079ee3          	bnez	a5,40008f74 <_realloc_r+0xa0>
400090dc:	ff842b83          	lw	s7,-8(s0)
400090e0:	417a8bb3          	sub	s7,s5,s7
400090e4:	004ba783          	lw	a5,4(s7) # 80000004 <end+0x3ffef224>
400090e8:	ffc7f793          	andi	a5,a5,-4
400090ec:	00f60633          	add	a2,a2,a5
400090f0:	01260b33          	add	s6,a2,s2
400090f4:	08eb4c63          	blt	s6,a4,4000918c <_realloc_r+0x2b8>
400090f8:	00c6a783          	lw	a5,12(a3)
400090fc:	0086a703          	lw	a4,8(a3)
40009100:	ffc90613          	addi	a2,s2,-4
40009104:	02400693          	li	a3,36
40009108:	00f72623          	sw	a5,12(a4)
4000910c:	00e7a423          	sw	a4,8(a5)
40009110:	008ba703          	lw	a4,8(s7)
40009114:	00cba783          	lw	a5,12(s7)
40009118:	008b8493          	addi	s1,s7,8
4000911c:	00f72623          	sw	a5,12(a4)
40009120:	00e7a423          	sw	a4,8(a5)
40009124:	22c6e263          	bltu	a3,a2,40009348 <_realloc_r+0x474>
40009128:	01300793          	li	a5,19
4000912c:	1cc7f863          	bleu	a2,a5,400092fc <_realloc_r+0x428>
40009130:	00042703          	lw	a4,0(s0)
40009134:	01b00793          	li	a5,27
40009138:	00eba423          	sw	a4,8(s7)
4000913c:	00442703          	lw	a4,4(s0)
40009140:	00eba623          	sw	a4,12(s7)
40009144:	24c7f863          	bleu	a2,a5,40009394 <_realloc_r+0x4c0>
40009148:	00842703          	lw	a4,8(s0)
4000914c:	02400793          	li	a5,36
40009150:	00eba823          	sw	a4,16(s7)
40009154:	00c42703          	lw	a4,12(s0)
40009158:	00ebaa23          	sw	a4,20(s7)
4000915c:	08f61663          	bne	a2,a5,400091e8 <_realloc_r+0x314>
40009160:	01042683          	lw	a3,16(s0)
40009164:	020b8793          	addi	a5,s7,32
40009168:	01840713          	addi	a4,s0,24
4000916c:	00dbac23          	sw	a3,24(s7)
40009170:	01442683          	lw	a3,20(s0)
40009174:	00dbae23          	sw	a3,28(s7)
40009178:	0780006f          	j	400091f0 <_realloc_r+0x31c>
4000917c:	ff842b83          	lw	s7,-8(s0)
40009180:	417a8bb3          	sub	s7,s5,s7
40009184:	004ba783          	lw	a5,4(s7)
40009188:	ffc7f793          	andi	a5,a5,-4
4000918c:	00f90b33          	add	s6,s2,a5
40009190:	deeb42e3          	blt	s6,a4,40008f74 <_realloc_r+0xa0>
40009194:	00cba783          	lw	a5,12(s7)
40009198:	008ba703          	lw	a4,8(s7)
4000919c:	ffc90613          	addi	a2,s2,-4
400091a0:	02400693          	li	a3,36
400091a4:	00f72623          	sw	a5,12(a4)
400091a8:	00e7a423          	sw	a4,8(a5)
400091ac:	008b8493          	addi	s1,s7,8
400091b0:	18c6ec63          	bltu	a3,a2,40009348 <_realloc_r+0x474>
400091b4:	01300793          	li	a5,19
400091b8:	14c7f263          	bleu	a2,a5,400092fc <_realloc_r+0x428>
400091bc:	00042703          	lw	a4,0(s0)
400091c0:	01b00793          	li	a5,27
400091c4:	00eba423          	sw	a4,8(s7)
400091c8:	00442703          	lw	a4,4(s0)
400091cc:	00eba623          	sw	a4,12(s7)
400091d0:	1cc7f263          	bleu	a2,a5,40009394 <_realloc_r+0x4c0>
400091d4:	00842783          	lw	a5,8(s0)
400091d8:	00fba823          	sw	a5,16(s7)
400091dc:	00c42783          	lw	a5,12(s0)
400091e0:	00fbaa23          	sw	a5,20(s7)
400091e4:	f6d60ee3          	beq	a2,a3,40009160 <_realloc_r+0x28c>
400091e8:	018b8793          	addi	a5,s7,24
400091ec:	01040713          	addi	a4,s0,16
400091f0:	00072683          	lw	a3,0(a4)
400091f4:	000b0913          	mv	s2,s6
400091f8:	000b8a93          	mv	s5,s7
400091fc:	00d7a023          	sw	a3,0(a5)
40009200:	00472683          	lw	a3,4(a4)
40009204:	00d7a223          	sw	a3,4(a5)
40009208:	00872703          	lw	a4,8(a4)
4000920c:	00e7a423          	sw	a4,8(a5)
40009210:	de1ff06f          	j	40008ff0 <_realloc_r+0x11c>
40009214:	0046a683          	lw	a3,4(a3)
40009218:	01098613          	addi	a2,s3,16
4000921c:	ffc6f693          	andi	a3,a3,-4
40009220:	012686b3          	add	a3,a3,s2
40009224:	0ec6d263          	ble	a2,a3,40009308 <_realloc_r+0x434>
40009228:	0017f793          	andi	a5,a5,1
4000922c:	d40794e3          	bnez	a5,40008f74 <_realloc_r+0xa0>
40009230:	ff842b83          	lw	s7,-8(s0)
40009234:	417a8bb3          	sub	s7,s5,s7
40009238:	004ba783          	lw	a5,4(s7)
4000923c:	ffc7f793          	andi	a5,a5,-4
40009240:	00d78c33          	add	s8,a5,a3
40009244:	f4cc44e3          	blt	s8,a2,4000918c <_realloc_r+0x2b8>
40009248:	00cba783          	lw	a5,12(s7)
4000924c:	008ba703          	lw	a4,8(s7)
40009250:	ffc90613          	addi	a2,s2,-4
40009254:	02400693          	li	a3,36
40009258:	00f72623          	sw	a5,12(a4)
4000925c:	00e7a423          	sw	a4,8(a5)
40009260:	008b8493          	addi	s1,s7,8
40009264:	16c6e263          	bltu	a3,a2,400093c8 <_realloc_r+0x4f4>
40009268:	01300793          	li	a5,19
4000926c:	14c7f863          	bleu	a2,a5,400093bc <_realloc_r+0x4e8>
40009270:	00042703          	lw	a4,0(s0)
40009274:	01b00793          	li	a5,27
40009278:	00eba423          	sw	a4,8(s7)
4000927c:	00442703          	lw	a4,4(s0)
40009280:	00eba623          	sw	a4,12(s7)
40009284:	14c7ea63          	bltu	a5,a2,400093d8 <_realloc_r+0x504>
40009288:	010b8793          	addi	a5,s7,16
4000928c:	00840713          	addi	a4,s0,8
40009290:	00072683          	lw	a3,0(a4)
40009294:	00d7a023          	sw	a3,0(a5)
40009298:	00472683          	lw	a3,4(a4)
4000929c:	00d7a223          	sw	a3,4(a5)
400092a0:	00872703          	lw	a4,8(a4)
400092a4:	00e7a423          	sw	a4,8(a5)
400092a8:	013b8733          	add	a4,s7,s3
400092ac:	413c07b3          	sub	a5,s8,s3
400092b0:	00eb2423          	sw	a4,8(s6)
400092b4:	0017e793          	ori	a5,a5,1
400092b8:	00f72223          	sw	a5,4(a4)
400092bc:	004ba783          	lw	a5,4(s7)
400092c0:	000a0513          	mv	a0,s4
400092c4:	0017f793          	andi	a5,a5,1
400092c8:	0137e9b3          	or	s3,a5,s3
400092cc:	013ba223          	sw	s3,4(s7)
400092d0:	aacf80ef          	jal	ra,4000157c <__malloc_unlock>
400092d4:	d51ff06f          	j	40009024 <_realloc_r+0x150>
400092d8:	00042683          	lw	a3,0(s0)
400092dc:	01b00713          	li	a4,27
400092e0:	00d52023          	sw	a3,0(a0)
400092e4:	00442683          	lw	a3,4(s0)
400092e8:	00d52223          	sw	a3,4(a0)
400092ec:	06c76a63          	bltu	a4,a2,40009360 <_realloc_r+0x48c>
400092f0:	00850793          	addi	a5,a0,8
400092f4:	00840713          	addi	a4,s0,8
400092f8:	cc1ff06f          	j	40008fb8 <_realloc_r+0xe4>
400092fc:	00048793          	mv	a5,s1
40009300:	00040713          	mv	a4,s0
40009304:	eedff06f          	j	400091f0 <_realloc_r+0x31c>
40009308:	013a8ab3          	add	s5,s5,s3
4000930c:	413687b3          	sub	a5,a3,s3
40009310:	015b2423          	sw	s5,8(s6)
40009314:	0017e793          	ori	a5,a5,1
40009318:	00faa223          	sw	a5,4(s5)
4000931c:	ffc42783          	lw	a5,-4(s0)
40009320:	000a0513          	mv	a0,s4
40009324:	00040493          	mv	s1,s0
40009328:	0017f793          	andi	a5,a5,1
4000932c:	0137e9b3          	or	s3,a5,s3
40009330:	ff342e23          	sw	s3,-4(s0)
40009334:	a48f80ef          	jal	ra,4000157c <__malloc_unlock>
40009338:	cedff06f          	j	40009024 <_realloc_r+0x150>
4000933c:	00040593          	mv	a1,s0
40009340:	a0dff0ef          	jal	ra,40008d4c <memmove>
40009344:	c8dff06f          	j	40008fd0 <_realloc_r+0xfc>
40009348:	00040593          	mv	a1,s0
4000934c:	00048513          	mv	a0,s1
40009350:	9fdff0ef          	jal	ra,40008d4c <memmove>
40009354:	000b0913          	mv	s2,s6
40009358:	000b8a93          	mv	s5,s7
4000935c:	c95ff06f          	j	40008ff0 <_realloc_r+0x11c>
40009360:	00842703          	lw	a4,8(s0)
40009364:	00e52423          	sw	a4,8(a0)
40009368:	00c42703          	lw	a4,12(s0)
4000936c:	00e52623          	sw	a4,12(a0)
40009370:	02f60863          	beq	a2,a5,400093a0 <_realloc_r+0x4cc>
40009374:	01050793          	addi	a5,a0,16
40009378:	01040713          	addi	a4,s0,16
4000937c:	c3dff06f          	j	40008fb8 <_realloc_r+0xe4>
40009380:	ffc52783          	lw	a5,-4(a0)
40009384:	00040493          	mv	s1,s0
40009388:	ffc7f793          	andi	a5,a5,-4
4000938c:	00f90933          	add	s2,s2,a5
40009390:	c61ff06f          	j	40008ff0 <_realloc_r+0x11c>
40009394:	010b8793          	addi	a5,s7,16
40009398:	00840713          	addi	a4,s0,8
4000939c:	e55ff06f          	j	400091f0 <_realloc_r+0x31c>
400093a0:	01042683          	lw	a3,16(s0)
400093a4:	01850793          	addi	a5,a0,24
400093a8:	01840713          	addi	a4,s0,24
400093ac:	00d52823          	sw	a3,16(a0)
400093b0:	01442683          	lw	a3,20(s0)
400093b4:	00d52a23          	sw	a3,20(a0)
400093b8:	c01ff06f          	j	40008fb8 <_realloc_r+0xe4>
400093bc:	00048793          	mv	a5,s1
400093c0:	00040713          	mv	a4,s0
400093c4:	ecdff06f          	j	40009290 <_realloc_r+0x3bc>
400093c8:	00040593          	mv	a1,s0
400093cc:	00048513          	mv	a0,s1
400093d0:	97dff0ef          	jal	ra,40008d4c <memmove>
400093d4:	ed5ff06f          	j	400092a8 <_realloc_r+0x3d4>
400093d8:	00842783          	lw	a5,8(s0)
400093dc:	00fba823          	sw	a5,16(s7)
400093e0:	00c42783          	lw	a5,12(s0)
400093e4:	00fbaa23          	sw	a5,20(s7)
400093e8:	00d60863          	beq	a2,a3,400093f8 <_realloc_r+0x524>
400093ec:	018b8793          	addi	a5,s7,24
400093f0:	01040713          	addi	a4,s0,16
400093f4:	e9dff06f          	j	40009290 <_realloc_r+0x3bc>
400093f8:	01042683          	lw	a3,16(s0)
400093fc:	020b8793          	addi	a5,s7,32
40009400:	01840713          	addi	a4,s0,24
40009404:	00dbac23          	sw	a3,24(s7)
40009408:	01442683          	lw	a3,20(s0)
4000940c:	00dbae23          	sw	a3,28(s7)
40009410:	e81ff06f          	j	40009290 <_realloc_r+0x3bc>

40009414 <__swbuf_r>:
40009414:	fe010113          	addi	sp,sp,-32
40009418:	00812c23          	sw	s0,24(sp)
4000941c:	00912a23          	sw	s1,20(sp)
40009420:	01212823          	sw	s2,16(sp)
40009424:	00112e23          	sw	ra,28(sp)
40009428:	01312623          	sw	s3,12(sp)
4000942c:	00050913          	mv	s2,a0
40009430:	00058493          	mv	s1,a1
40009434:	00060413          	mv	s0,a2
40009438:	00050663          	beqz	a0,40009444 <__swbuf_r+0x30>
4000943c:	03852783          	lw	a5,56(a0)
40009440:	14078263          	beqz	a5,40009584 <__swbuf_r+0x170>
40009444:	00c41703          	lh	a4,12(s0)
40009448:	01842783          	lw	a5,24(s0)
4000944c:	01071693          	slli	a3,a4,0x10
40009450:	0106d693          	srli	a3,a3,0x10
40009454:	00f42423          	sw	a5,8(s0)
40009458:	0086f793          	andi	a5,a3,8
4000945c:	10078263          	beqz	a5,40009560 <__swbuf_r+0x14c>
40009460:	01042783          	lw	a5,16(s0)
40009464:	0e078e63          	beqz	a5,40009560 <__swbuf_r+0x14c>
40009468:	01269613          	slli	a2,a3,0x12
4000946c:	0ff4f993          	andi	s3,s1,255
40009470:	0ff4f493          	andi	s1,s1,255
40009474:	06065663          	bgez	a2,400094e0 <__swbuf_r+0xcc>
40009478:	00042703          	lw	a4,0(s0)
4000947c:	01442683          	lw	a3,20(s0)
40009480:	40f707b3          	sub	a5,a4,a5
40009484:	08d7d663          	ble	a3,a5,40009510 <__swbuf_r+0xfc>
40009488:	00842683          	lw	a3,8(s0)
4000948c:	00170613          	addi	a2,a4,1
40009490:	00c42023          	sw	a2,0(s0)
40009494:	fff68693          	addi	a3,a3,-1
40009498:	00d42423          	sw	a3,8(s0)
4000949c:	01370023          	sb	s3,0(a4)
400094a0:	01442703          	lw	a4,20(s0)
400094a4:	00178793          	addi	a5,a5,1
400094a8:	0af70063          	beq	a4,a5,40009548 <__swbuf_r+0x134>
400094ac:	00c45783          	lhu	a5,12(s0)
400094b0:	0017f793          	andi	a5,a5,1
400094b4:	00078663          	beqz	a5,400094c0 <__swbuf_r+0xac>
400094b8:	00a00793          	li	a5,10
400094bc:	08f48663          	beq	s1,a5,40009548 <__swbuf_r+0x134>
400094c0:	01c12083          	lw	ra,28(sp)
400094c4:	00048513          	mv	a0,s1
400094c8:	01812403          	lw	s0,24(sp)
400094cc:	01412483          	lw	s1,20(sp)
400094d0:	01012903          	lw	s2,16(sp)
400094d4:	00c12983          	lw	s3,12(sp)
400094d8:	02010113          	addi	sp,sp,32
400094dc:	00008067          	ret
400094e0:	06442683          	lw	a3,100(s0)
400094e4:	00002637          	lui	a2,0x2
400094e8:	00c76733          	or	a4,a4,a2
400094ec:	ffffe637          	lui	a2,0xffffe
400094f0:	fff60613          	addi	a2,a2,-1 # ffffdfff <end+0xbffed21f>
400094f4:	00c6f6b3          	and	a3,a3,a2
400094f8:	00e41623          	sh	a4,12(s0)
400094fc:	00042703          	lw	a4,0(s0)
40009500:	06d42223          	sw	a3,100(s0)
40009504:	01442683          	lw	a3,20(s0)
40009508:	40f707b3          	sub	a5,a4,a5
4000950c:	f6d7cee3          	blt	a5,a3,40009488 <__swbuf_r+0x74>
40009510:	00040593          	mv	a1,s0
40009514:	00090513          	mv	a0,s2
40009518:	ad9fb0ef          	jal	ra,40004ff0 <_fflush_r>
4000951c:	02051e63          	bnez	a0,40009558 <__swbuf_r+0x144>
40009520:	00042703          	lw	a4,0(s0)
40009524:	00842683          	lw	a3,8(s0)
40009528:	00100793          	li	a5,1
4000952c:	00170613          	addi	a2,a4,1
40009530:	fff68693          	addi	a3,a3,-1
40009534:	00c42023          	sw	a2,0(s0)
40009538:	00d42423          	sw	a3,8(s0)
4000953c:	01370023          	sb	s3,0(a4)
40009540:	01442703          	lw	a4,20(s0)
40009544:	f6f714e3          	bne	a4,a5,400094ac <__swbuf_r+0x98>
40009548:	00040593          	mv	a1,s0
4000954c:	00090513          	mv	a0,s2
40009550:	aa1fb0ef          	jal	ra,40004ff0 <_fflush_r>
40009554:	f60506e3          	beqz	a0,400094c0 <__swbuf_r+0xac>
40009558:	fff00493          	li	s1,-1
4000955c:	f65ff06f          	j	400094c0 <__swbuf_r+0xac>
40009560:	00040593          	mv	a1,s0
40009564:	00090513          	mv	a0,s2
40009568:	efdf90ef          	jal	ra,40003464 <__swsetup_r>
4000956c:	fe0516e3          	bnez	a0,40009558 <__swbuf_r+0x144>
40009570:	00c41703          	lh	a4,12(s0)
40009574:	01042783          	lw	a5,16(s0)
40009578:	01071693          	slli	a3,a4,0x10
4000957c:	0106d693          	srli	a3,a3,0x10
40009580:	ee9ff06f          	j	40009468 <__swbuf_r+0x54>
40009584:	e3dfb0ef          	jal	ra,400053c0 <__sinit>
40009588:	ebdff06f          	j	40009444 <__swbuf_r+0x30>

4000958c <__swbuf>:
4000958c:	4000e7b7          	lui	a5,0x4000e
40009590:	00058613          	mv	a2,a1
40009594:	00050593          	mv	a1,a0
40009598:	5847a503          	lw	a0,1412(a5) # 4000e584 <_impure_ptr>
4000959c:	e79ff06f          	j	40009414 <__swbuf_r>

400095a0 <_wcrtomb_r>:
400095a0:	fd010113          	addi	sp,sp,-48
400095a4:	02912223          	sw	s1,36(sp)
400095a8:	03212023          	sw	s2,32(sp)
400095ac:	02112623          	sw	ra,44(sp)
400095b0:	02812423          	sw	s0,40(sp)
400095b4:	01312e23          	sw	s3,28(sp)
400095b8:	01412c23          	sw	s4,24(sp)
400095bc:	00050493          	mv	s1,a0
400095c0:	00068913          	mv	s2,a3
400095c4:	06058263          	beqz	a1,40009628 <_wcrtomb_r+0x88>
400095c8:	4000e7b7          	lui	a5,0x4000e
400095cc:	58c7aa03          	lw	s4,1420(a5) # 4000e58c <__wctomb>
400095d0:	00058413          	mv	s0,a1
400095d4:	00060993          	mv	s3,a2
400095d8:	c50fc0ef          	jal	ra,40005a28 <__locale_charset>
400095dc:	00050693          	mv	a3,a0
400095e0:	00090713          	mv	a4,s2
400095e4:	00098613          	mv	a2,s3
400095e8:	00040593          	mv	a1,s0
400095ec:	00048513          	mv	a0,s1
400095f0:	000a00e7          	jalr	s4
400095f4:	fff00793          	li	a5,-1
400095f8:	00f51863          	bne	a0,a5,40009608 <_wcrtomb_r+0x68>
400095fc:	00092023          	sw	zero,0(s2)
40009600:	08a00793          	li	a5,138
40009604:	00f4a023          	sw	a5,0(s1)
40009608:	02c12083          	lw	ra,44(sp)
4000960c:	02812403          	lw	s0,40(sp)
40009610:	02412483          	lw	s1,36(sp)
40009614:	02012903          	lw	s2,32(sp)
40009618:	01c12983          	lw	s3,28(sp)
4000961c:	01812a03          	lw	s4,24(sp)
40009620:	03010113          	addi	sp,sp,48
40009624:	00008067          	ret
40009628:	4000e7b7          	lui	a5,0x4000e
4000962c:	58c7a403          	lw	s0,1420(a5) # 4000e58c <__wctomb>
40009630:	bf8fc0ef          	jal	ra,40005a28 <__locale_charset>
40009634:	00050693          	mv	a3,a0
40009638:	00090713          	mv	a4,s2
4000963c:	00000613          	li	a2,0
40009640:	00410593          	addi	a1,sp,4
40009644:	00048513          	mv	a0,s1
40009648:	000400e7          	jalr	s0
4000964c:	fa9ff06f          	j	400095f4 <_wcrtomb_r+0x54>

40009650 <wcrtomb>:
40009650:	fd010113          	addi	sp,sp,-48
40009654:	02912223          	sw	s1,36(sp)
40009658:	03212023          	sw	s2,32(sp)
4000965c:	4000e7b7          	lui	a5,0x4000e
40009660:	02112623          	sw	ra,44(sp)
40009664:	02812423          	sw	s0,40(sp)
40009668:	01312e23          	sw	s3,28(sp)
4000966c:	01412c23          	sw	s4,24(sp)
40009670:	00060913          	mv	s2,a2
40009674:	5847a483          	lw	s1,1412(a5) # 4000e584 <_impure_ptr>
40009678:	06050263          	beqz	a0,400096dc <wcrtomb+0x8c>
4000967c:	4000e7b7          	lui	a5,0x4000e
40009680:	58c7aa03          	lw	s4,1420(a5) # 4000e58c <__wctomb>
40009684:	00058993          	mv	s3,a1
40009688:	00050413          	mv	s0,a0
4000968c:	b9cfc0ef          	jal	ra,40005a28 <__locale_charset>
40009690:	00050693          	mv	a3,a0
40009694:	00090713          	mv	a4,s2
40009698:	00098613          	mv	a2,s3
4000969c:	00040593          	mv	a1,s0
400096a0:	00048513          	mv	a0,s1
400096a4:	000a00e7          	jalr	s4
400096a8:	fff00793          	li	a5,-1
400096ac:	00f51863          	bne	a0,a5,400096bc <wcrtomb+0x6c>
400096b0:	00092023          	sw	zero,0(s2)
400096b4:	08a00793          	li	a5,138
400096b8:	00f4a023          	sw	a5,0(s1)
400096bc:	02c12083          	lw	ra,44(sp)
400096c0:	02812403          	lw	s0,40(sp)
400096c4:	02412483          	lw	s1,36(sp)
400096c8:	02012903          	lw	s2,32(sp)
400096cc:	01c12983          	lw	s3,28(sp)
400096d0:	01812a03          	lw	s4,24(sp)
400096d4:	03010113          	addi	sp,sp,48
400096d8:	00008067          	ret
400096dc:	4000e7b7          	lui	a5,0x4000e
400096e0:	58c7a403          	lw	s0,1420(a5) # 4000e58c <__wctomb>
400096e4:	b44fc0ef          	jal	ra,40005a28 <__locale_charset>
400096e8:	00050693          	mv	a3,a0
400096ec:	00090713          	mv	a4,s2
400096f0:	00000613          	li	a2,0
400096f4:	00410593          	addi	a1,sp,4
400096f8:	00048513          	mv	a0,s1
400096fc:	000400e7          	jalr	s0
40009700:	fa9ff06f          	j	400096a8 <wcrtomb+0x58>

40009704 <__ascii_wctomb>:
40009704:	00058c63          	beqz	a1,4000971c <__ascii_wctomb+0x18>
40009708:	0ff00793          	li	a5,255
4000970c:	00c7ec63          	bltu	a5,a2,40009724 <__ascii_wctomb+0x20>
40009710:	00c58023          	sb	a2,0(a1)
40009714:	00100513          	li	a0,1
40009718:	00008067          	ret
4000971c:	00000513          	li	a0,0
40009720:	00008067          	ret
40009724:	08a00793          	li	a5,138
40009728:	00f52023          	sw	a5,0(a0)
4000972c:	fff00513          	li	a0,-1
40009730:	00008067          	ret

40009734 <_wctomb_r>:
40009734:	fe010113          	addi	sp,sp,-32
40009738:	4000e7b7          	lui	a5,0x4000e
4000973c:	00812c23          	sw	s0,24(sp)
40009740:	58c7a403          	lw	s0,1420(a5) # 4000e58c <__wctomb>
40009744:	00112e23          	sw	ra,28(sp)
40009748:	00912a23          	sw	s1,20(sp)
4000974c:	01212823          	sw	s2,16(sp)
40009750:	01312623          	sw	s3,12(sp)
40009754:	01412423          	sw	s4,8(sp)
40009758:	00050493          	mv	s1,a0
4000975c:	00068a13          	mv	s4,a3
40009760:	00058913          	mv	s2,a1
40009764:	00060993          	mv	s3,a2
40009768:	ac0fc0ef          	jal	ra,40005a28 <__locale_charset>
4000976c:	000a0713          	mv	a4,s4
40009770:	00050693          	mv	a3,a0
40009774:	00098613          	mv	a2,s3
40009778:	00090593          	mv	a1,s2
4000977c:	00048513          	mv	a0,s1
40009780:	00040313          	mv	t1,s0
40009784:	01c12083          	lw	ra,28(sp)
40009788:	01812403          	lw	s0,24(sp)
4000978c:	01412483          	lw	s1,20(sp)
40009790:	01012903          	lw	s2,16(sp)
40009794:	00c12983          	lw	s3,12(sp)
40009798:	00812a03          	lw	s4,8(sp)
4000979c:	02010113          	addi	sp,sp,32
400097a0:	00030067          	jr	t1

400097a4 <sbrk>:
400097a4:	4000e737          	lui	a4,0x4000e
400097a8:	5d472783          	lw	a5,1492(a4) # 4000e5d4 <heap_end.1376>
400097ac:	00078a63          	beqz	a5,400097c0 <sbrk+0x1c>
400097b0:	00a78533          	add	a0,a5,a0
400097b4:	5ca72a23          	sw	a0,1492(a4)
400097b8:	00078513          	mv	a0,a5
400097bc:	00008067          	ret
400097c0:	400117b7          	lui	a5,0x40011
400097c4:	de078793          	addi	a5,a5,-544 # 40010de0 <end>
400097c8:	00a78533          	add	a0,a5,a0
400097cc:	5ca72a23          	sw	a0,1492(a4)
400097d0:	00078513          	mv	a0,a5
400097d4:	00008067          	ret

400097d8 <__divsf3>:
400097d8:	fc010113          	addi	sp,sp,-64
400097dc:	02812c23          	sw	s0,56(sp)
400097e0:	01755793          	srli	a5,a0,0x17
400097e4:	00800437          	lui	s0,0x800
400097e8:	03412423          	sw	s4,40(sp)
400097ec:	03612023          	sw	s6,32(sp)
400097f0:	01f55a13          	srli	s4,a0,0x1f
400097f4:	fff40413          	addi	s0,s0,-1 # 7fffff <_heap_size+0x7fdfff>
400097f8:	02112e23          	sw	ra,60(sp)
400097fc:	02912a23          	sw	s1,52(sp)
40009800:	03212823          	sw	s2,48(sp)
40009804:	03312623          	sw	s3,44(sp)
40009808:	03512223          	sw	s5,36(sp)
4000980c:	01712e23          	sw	s7,28(sp)
40009810:	01812c23          	sw	s8,24(sp)
40009814:	01912a23          	sw	s9,20(sp)
40009818:	0ff7f793          	andi	a5,a5,255
4000981c:	00a47433          	and	s0,s0,a0
40009820:	000a0b13          	mv	s6,s4
40009824:	18078663          	beqz	a5,400099b0 <__divsf3+0x1d8>
40009828:	0ff00713          	li	a4,255
4000982c:	06e78e63          	beq	a5,a4,400098a8 <__divsf3+0xd0>
40009830:	00341413          	slli	s0,s0,0x3
40009834:	04000737          	lui	a4,0x4000
40009838:	00e46433          	or	s0,s0,a4
4000983c:	f8178993          	addi	s3,a5,-127
40009840:	00000493          	li	s1,0
40009844:	00000b93          	li	s7,0
40009848:	0175d513          	srli	a0,a1,0x17
4000984c:	00800937          	lui	s2,0x800
40009850:	fff90913          	addi	s2,s2,-1 # 7fffff <_heap_size+0x7fdfff>
40009854:	0ff57513          	andi	a0,a0,255
40009858:	00b97933          	and	s2,s2,a1
4000985c:	01f5da93          	srli	s5,a1,0x1f
40009860:	06050e63          	beqz	a0,400098dc <__divsf3+0x104>
40009864:	0ff00793          	li	a5,255
40009868:	18f50263          	beq	a0,a5,400099ec <__divsf3+0x214>
4000986c:	00391913          	slli	s2,s2,0x3
40009870:	040007b7          	lui	a5,0x4000
40009874:	00f96933          	or	s2,s2,a5
40009878:	f8150513          	addi	a0,a0,-127
4000987c:	00000713          	li	a4,0
40009880:	00e4e4b3          	or	s1,s1,a4
40009884:	4000e7b7          	lui	a5,0x4000e
40009888:	a3478793          	addi	a5,a5,-1484 # 4000da34 <zeroes.4082+0x10>
4000988c:	00249493          	slli	s1,s1,0x2
40009890:	00f484b3          	add	s1,s1,a5
40009894:	0004a683          	lw	a3,0(s1)
40009898:	015a47b3          	xor	a5,s4,s5
4000989c:	00078c13          	mv	s8,a5
400098a0:	40a984b3          	sub	s1,s3,a0
400098a4:	00068067          	jr	a3
400098a8:	00800493          	li	s1,8
400098ac:	00078993          	mv	s3,a5
400098b0:	00200b93          	li	s7,2
400098b4:	f8040ae3          	beqz	s0,40009848 <__divsf3+0x70>
400098b8:	0175d513          	srli	a0,a1,0x17
400098bc:	00800937          	lui	s2,0x800
400098c0:	fff90913          	addi	s2,s2,-1 # 7fffff <_heap_size+0x7fdfff>
400098c4:	0ff57513          	andi	a0,a0,255
400098c8:	00c00493          	li	s1,12
400098cc:	00300b93          	li	s7,3
400098d0:	00b97933          	and	s2,s2,a1
400098d4:	01f5da93          	srli	s5,a1,0x1f
400098d8:	f80516e3          	bnez	a0,40009864 <__divsf3+0x8c>
400098dc:	12091263          	bnez	s2,40009a00 <__divsf3+0x228>
400098e0:	00000513          	li	a0,0
400098e4:	00100713          	li	a4,1
400098e8:	00e4e4b3          	or	s1,s1,a4
400098ec:	4000e7b7          	lui	a5,0x4000e
400098f0:	a7478793          	addi	a5,a5,-1420 # 4000da74 <zeroes.4082+0x50>
400098f4:	00249493          	slli	s1,s1,0x2
400098f8:	00f484b3          	add	s1,s1,a5
400098fc:	0004a683          	lw	a3,0(s1)
40009900:	015a47b3          	xor	a5,s4,s5
40009904:	40a984b3          	sub	s1,s3,a0
40009908:	00068067          	jr	a3
4000990c:	0ff00513          	li	a0,255
40009910:	00000413          	li	s0,0
40009914:	00800737          	lui	a4,0x800
40009918:	fff70713          	addi	a4,a4,-1 # 7fffff <_heap_size+0x7fdfff>
4000991c:	00e47433          	and	s0,s0,a4
40009920:	01751713          	slli	a4,a0,0x17
40009924:	80800537          	lui	a0,0x80800
40009928:	fff50513          	addi	a0,a0,-1 # 807fffff <end+0x407ef21f>
4000992c:	00a47533          	and	a0,s0,a0
40009930:	03c12083          	lw	ra,60(sp)
40009934:	80000437          	lui	s0,0x80000
40009938:	fff44413          	not	s0,s0
4000993c:	00e56533          	or	a0,a0,a4
40009940:	00857533          	and	a0,a0,s0
40009944:	01f79793          	slli	a5,a5,0x1f
40009948:	00f56533          	or	a0,a0,a5
4000994c:	03812403          	lw	s0,56(sp)
40009950:	03412483          	lw	s1,52(sp)
40009954:	03012903          	lw	s2,48(sp)
40009958:	02c12983          	lw	s3,44(sp)
4000995c:	02812a03          	lw	s4,40(sp)
40009960:	02412a83          	lw	s5,36(sp)
40009964:	02012b03          	lw	s6,32(sp)
40009968:	01c12b83          	lw	s7,28(sp)
4000996c:	01812c03          	lw	s8,24(sp)
40009970:	01412c83          	lw	s9,20(sp)
40009974:	04010113          	addi	sp,sp,64
40009978:	00008067          	ret
4000997c:	00090413          	mv	s0,s2
40009980:	000a8b13          	mv	s6,s5
40009984:	00070b93          	mv	s7,a4
40009988:	00200793          	li	a5,2
4000998c:	30fb8e63          	beq	s7,a5,40009ca8 <__divsf3+0x4d0>
40009990:	00300793          	li	a5,3
40009994:	2efb8a63          	beq	s7,a5,40009c88 <__divsf3+0x4b0>
40009998:	00100793          	li	a5,1
4000999c:	28fb9263          	bne	s7,a5,40009c20 <__divsf3+0x448>
400099a0:	001b7793          	andi	a5,s6,1
400099a4:	00000513          	li	a0,0
400099a8:	00000413          	li	s0,0
400099ac:	f69ff06f          	j	40009914 <__divsf3+0x13c>
400099b0:	00400493          	li	s1,4
400099b4:	00000993          	li	s3,0
400099b8:	00100b93          	li	s7,1
400099bc:	e80406e3          	beqz	s0,40009848 <__divsf3+0x70>
400099c0:	00040513          	mv	a0,s0
400099c4:	00b12623          	sw	a1,12(sp)
400099c8:	5c0030ef          	jal	ra,4000cf88 <__clzsi2>
400099cc:	ffb50793          	addi	a5,a0,-5
400099d0:	00f41433          	sll	s0,s0,a5
400099d4:	f8a00793          	li	a5,-118
400099d8:	40a789b3          	sub	s3,a5,a0
400099dc:	00000493          	li	s1,0
400099e0:	00000b93          	li	s7,0
400099e4:	00c12583          	lw	a1,12(sp)
400099e8:	e61ff06f          	j	40009848 <__divsf3+0x70>
400099ec:	00091663          	bnez	s2,400099f8 <__divsf3+0x220>
400099f0:	00200713          	li	a4,2
400099f4:	ef5ff06f          	j	400098e8 <__divsf3+0x110>
400099f8:	00300713          	li	a4,3
400099fc:	e85ff06f          	j	40009880 <__divsf3+0xa8>
40009a00:	00090513          	mv	a0,s2
40009a04:	584030ef          	jal	ra,4000cf88 <__clzsi2>
40009a08:	ffb50793          	addi	a5,a0,-5
40009a0c:	00f91933          	sll	s2,s2,a5
40009a10:	f8a00793          	li	a5,-118
40009a14:	40a78533          	sub	a0,a5,a0
40009a18:	00000713          	li	a4,0
40009a1c:	e65ff06f          	j	40009880 <__divsf3+0xa8>
40009a20:	00800437          	lui	s0,0x800
40009a24:	00000793          	li	a5,0
40009a28:	fff40413          	addi	s0,s0,-1 # 7fffff <_heap_size+0x7fdfff>
40009a2c:	0ff00513          	li	a0,255
40009a30:	ee5ff06f          	j	40009914 <__divsf3+0x13c>
40009a34:	1e050a63          	beqz	a0,40009c28 <__divsf3+0x450>
40009a38:	00100793          	li	a5,1
40009a3c:	40a78533          	sub	a0,a5,a0
40009a40:	01b00793          	li	a5,27
40009a44:	1ea7d463          	ble	a0,a5,40009c2c <__divsf3+0x454>
40009a48:	001c7793          	andi	a5,s8,1
40009a4c:	00000513          	li	a0,0
40009a50:	00000413          	li	s0,0
40009a54:	ec1ff06f          	j	40009914 <__divsf3+0x13c>
40009a58:	00591a93          	slli	s5,s2,0x5
40009a5c:	010adb13          	srli	s6,s5,0x10
40009a60:	17247463          	bleu	s2,s0,40009bc8 <__divsf3+0x3f0>
40009a64:	00010a37          	lui	s4,0x10
40009a68:	000b0593          	mv	a1,s6
40009a6c:	fffa0a13          	addi	s4,s4,-1 # ffff <_heap_size+0xdfff>
40009a70:	00040513          	mv	a0,s0
40009a74:	468030ef          	jal	ra,4000cedc <__udivsi3>
40009a78:	014afa33          	and	s4,s5,s4
40009a7c:	00050593          	mv	a1,a0
40009a80:	00050993          	mv	s3,a0
40009a84:	000a0513          	mv	a0,s4
40009a88:	428030ef          	jal	ra,4000ceb0 <__mulsi3>
40009a8c:	00050b93          	mv	s7,a0
40009a90:	fff48493          	addi	s1,s1,-1
40009a94:	00040c93          	mv	s9,s0
40009a98:	00000913          	li	s2,0
40009a9c:	000b0593          	mv	a1,s6
40009aa0:	000c8513          	mv	a0,s9
40009aa4:	480030ef          	jal	ra,4000cf24 <__umodsi3>
40009aa8:	01051513          	slli	a0,a0,0x10
40009aac:	00a96533          	or	a0,s2,a0
40009ab0:	01757e63          	bleu	s7,a0,40009acc <__divsf3+0x2f4>
40009ab4:	01550533          	add	a0,a0,s5
40009ab8:	fff98793          	addi	a5,s3,-1
40009abc:	15556e63          	bltu	a0,s5,40009c18 <__divsf3+0x440>
40009ac0:	15757c63          	bleu	s7,a0,40009c18 <__divsf3+0x440>
40009ac4:	ffe98993          	addi	s3,s3,-2
40009ac8:	01550533          	add	a0,a0,s5
40009acc:	41750433          	sub	s0,a0,s7
40009ad0:	000b0593          	mv	a1,s6
40009ad4:	00040513          	mv	a0,s0
40009ad8:	404030ef          	jal	ra,4000cedc <__udivsi3>
40009adc:	000a0593          	mv	a1,s4
40009ae0:	00050b93          	mv	s7,a0
40009ae4:	3cc030ef          	jal	ra,4000ceb0 <__mulsi3>
40009ae8:	00050913          	mv	s2,a0
40009aec:	000b0593          	mv	a1,s6
40009af0:	00040513          	mv	a0,s0
40009af4:	430030ef          	jal	ra,4000cf24 <__umodsi3>
40009af8:	01051513          	slli	a0,a0,0x10
40009afc:	01257e63          	bleu	s2,a0,40009b18 <__divsf3+0x340>
40009b00:	01550533          	add	a0,a0,s5
40009b04:	fffb8793          	addi	a5,s7,-1
40009b08:	11556463          	bltu	a0,s5,40009c10 <__divsf3+0x438>
40009b0c:	11257263          	bleu	s2,a0,40009c10 <__divsf3+0x438>
40009b10:	ffeb8b93          	addi	s7,s7,-2
40009b14:	01550533          	add	a0,a0,s5
40009b18:	41250433          	sub	s0,a0,s2
40009b1c:	01099993          	slli	s3,s3,0x10
40009b20:	0179e533          	or	a0,s3,s7
40009b24:	00803433          	snez	s0,s0
40009b28:	00856433          	or	s0,a0,s0
40009b2c:	07f48513          	addi	a0,s1,127
40009b30:	f0a052e3          	blez	a0,40009a34 <__divsf3+0x25c>
40009b34:	00747793          	andi	a5,s0,7
40009b38:	00078a63          	beqz	a5,40009b4c <__divsf3+0x374>
40009b3c:	00f47793          	andi	a5,s0,15
40009b40:	00400713          	li	a4,4
40009b44:	00e78463          	beq	a5,a4,40009b4c <__divsf3+0x374>
40009b48:	00e40433          	add	s0,s0,a4
40009b4c:	00441793          	slli	a5,s0,0x4
40009b50:	0007da63          	bgez	a5,40009b64 <__divsf3+0x38c>
40009b54:	f80007b7          	lui	a5,0xf8000
40009b58:	fff78793          	addi	a5,a5,-1 # f7ffffff <end+0xb7fef21f>
40009b5c:	00f47433          	and	s0,s0,a5
40009b60:	08048513          	addi	a0,s1,128
40009b64:	0fe00793          	li	a5,254
40009b68:	04a7d663          	ble	a0,a5,40009bb4 <__divsf3+0x3dc>
40009b6c:	001c7793          	andi	a5,s8,1
40009b70:	0ff00513          	li	a0,255
40009b74:	00000413          	li	s0,0
40009b78:	d9dff06f          	j	40009914 <__divsf3+0x13c>
40009b7c:	00078b13          	mv	s6,a5
40009b80:	e21ff06f          	j	400099a0 <__divsf3+0x1c8>
40009b84:	00000913          	li	s2,0
40009b88:	01246933          	or	s2,s0,s2
40009b8c:	00991793          	slli	a5,s2,0x9
40009b90:	e807c8e3          	bltz	a5,40009a20 <__divsf3+0x248>
40009b94:	004007b7          	lui	a5,0x400
40009b98:	00f46433          	or	s0,s0,a5
40009b9c:	008007b7          	lui	a5,0x800
40009ba0:	fff78793          	addi	a5,a5,-1 # 7fffff <_heap_size+0x7fdfff>
40009ba4:	00f47433          	and	s0,s0,a5
40009ba8:	0ff00513          	li	a0,255
40009bac:	000a0793          	mv	a5,s4
40009bb0:	d65ff06f          	j	40009914 <__divsf3+0x13c>
40009bb4:	00641413          	slli	s0,s0,0x6
40009bb8:	00945413          	srli	s0,s0,0x9
40009bbc:	0ff57513          	andi	a0,a0,255
40009bc0:	001c7793          	andi	a5,s8,1
40009bc4:	d51ff06f          	j	40009914 <__divsf3+0x13c>
40009bc8:	00145c93          	srli	s9,s0,0x1
40009bcc:	00010a37          	lui	s4,0x10
40009bd0:	000b0593          	mv	a1,s6
40009bd4:	fffa0a13          	addi	s4,s4,-1 # ffff <_heap_size+0xdfff>
40009bd8:	000c8513          	mv	a0,s9
40009bdc:	300030ef          	jal	ra,4000cedc <__udivsi3>
40009be0:	014afa33          	and	s4,s5,s4
40009be4:	000a0593          	mv	a1,s4
40009be8:	00050993          	mv	s3,a0
40009bec:	2c4030ef          	jal	ra,4000ceb0 <__mulsi3>
40009bf0:	00050b93          	mv	s7,a0
40009bf4:	01f41513          	slli	a0,s0,0x1f
40009bf8:	01055913          	srli	s2,a0,0x10
40009bfc:	ea1ff06f          	j	40009a9c <__divsf3+0x2c4>
40009c00:	000a8b13          	mv	s6,s5
40009c04:	00070b93          	mv	s7,a4
40009c08:	00000413          	li	s0,0
40009c0c:	d7dff06f          	j	40009988 <__divsf3+0x1b0>
40009c10:	00078b93          	mv	s7,a5
40009c14:	f05ff06f          	j	40009b18 <__divsf3+0x340>
40009c18:	00078993          	mv	s3,a5
40009c1c:	eb1ff06f          	j	40009acc <__divsf3+0x2f4>
40009c20:	000b0c13          	mv	s8,s6
40009c24:	f09ff06f          	j	40009b2c <__divsf3+0x354>
40009c28:	00100513          	li	a0,1
40009c2c:	02000793          	li	a5,32
40009c30:	40a787b3          	sub	a5,a5,a0
40009c34:	00f417b3          	sll	a5,s0,a5
40009c38:	00a45533          	srl	a0,s0,a0
40009c3c:	00f037b3          	snez	a5,a5
40009c40:	00f567b3          	or	a5,a0,a5
40009c44:	0077f713          	andi	a4,a5,7
40009c48:	00070a63          	beqz	a4,40009c5c <__divsf3+0x484>
40009c4c:	00f7f713          	andi	a4,a5,15
40009c50:	00400693          	li	a3,4
40009c54:	00d70463          	beq	a4,a3,40009c5c <__divsf3+0x484>
40009c58:	00d787b3          	add	a5,a5,a3
40009c5c:	00579713          	slli	a4,a5,0x5
40009c60:	00075a63          	bgez	a4,40009c74 <__divsf3+0x49c>
40009c64:	001c7793          	andi	a5,s8,1
40009c68:	00100513          	li	a0,1
40009c6c:	00000413          	li	s0,0
40009c70:	ca5ff06f          	j	40009914 <__divsf3+0x13c>
40009c74:	00679413          	slli	s0,a5,0x6
40009c78:	00945413          	srli	s0,s0,0x9
40009c7c:	001c7793          	andi	a5,s8,1
40009c80:	00000513          	li	a0,0
40009c84:	c91ff06f          	j	40009914 <__divsf3+0x13c>
40009c88:	004007b7          	lui	a5,0x400
40009c8c:	00f46433          	or	s0,s0,a5
40009c90:	008007b7          	lui	a5,0x800
40009c94:	fff78793          	addi	a5,a5,-1 # 7fffff <_heap_size+0x7fdfff>
40009c98:	00f47433          	and	s0,s0,a5
40009c9c:	0ff00513          	li	a0,255
40009ca0:	001b7793          	andi	a5,s6,1
40009ca4:	c71ff06f          	j	40009914 <__divsf3+0x13c>
40009ca8:	001b7793          	andi	a5,s6,1
40009cac:	0ff00513          	li	a0,255
40009cb0:	00000413          	li	s0,0
40009cb4:	c61ff06f          	j	40009914 <__divsf3+0x13c>

40009cb8 <__floatsisf>:
40009cb8:	ff010113          	addi	sp,sp,-16
40009cbc:	00112623          	sw	ra,12(sp)
40009cc0:	00812423          	sw	s0,8(sp)
40009cc4:	00912223          	sw	s1,4(sp)
40009cc8:	0e050263          	beqz	a0,40009dac <__floatsisf+0xf4>
40009ccc:	00050413          	mv	s0,a0
40009cd0:	01f55493          	srli	s1,a0,0x1f
40009cd4:	0e054463          	bltz	a0,40009dbc <__floatsisf+0x104>
40009cd8:	00040513          	mv	a0,s0
40009cdc:	2ac030ef          	jal	ra,4000cf88 <__clzsi2>
40009ce0:	09e00713          	li	a4,158
40009ce4:	40a70733          	sub	a4,a4,a0
40009ce8:	09600793          	li	a5,150
40009cec:	06e7c463          	blt	a5,a4,40009d54 <__floatsisf+0x9c>
40009cf0:	40e787b3          	sub	a5,a5,a4
40009cf4:	008006b7          	lui	a3,0x800
40009cf8:	00f41533          	sll	a0,s0,a5
40009cfc:	fff68693          	addi	a3,a3,-1 # 7fffff <_heap_size+0x7fdfff>
40009d00:	00d57533          	and	a0,a0,a3
40009d04:	0ff77713          	andi	a4,a4,255
40009d08:	00048793          	mv	a5,s1
40009d0c:	008006b7          	lui	a3,0x800
40009d10:	fff68693          	addi	a3,a3,-1 # 7fffff <_heap_size+0x7fdfff>
40009d14:	00d57533          	and	a0,a0,a3
40009d18:	808006b7          	lui	a3,0x80800
40009d1c:	fff68693          	addi	a3,a3,-1 # 807fffff <end+0x407ef21f>
40009d20:	01771713          	slli	a4,a4,0x17
40009d24:	00d57533          	and	a0,a0,a3
40009d28:	00e56533          	or	a0,a0,a4
40009d2c:	00c12083          	lw	ra,12(sp)
40009d30:	80000737          	lui	a4,0x80000
40009d34:	fff74713          	not	a4,a4
40009d38:	01f79793          	slli	a5,a5,0x1f
40009d3c:	00e57533          	and	a0,a0,a4
40009d40:	00f56533          	or	a0,a0,a5
40009d44:	00812403          	lw	s0,8(sp)
40009d48:	00412483          	lw	s1,4(sp)
40009d4c:	01010113          	addi	sp,sp,16
40009d50:	00008067          	ret
40009d54:	09900793          	li	a5,153
40009d58:	08e7c263          	blt	a5,a4,40009ddc <__floatsisf+0x124>
40009d5c:	09900693          	li	a3,153
40009d60:	40e686b3          	sub	a3,a3,a4
40009d64:	00d05463          	blez	a3,40009d6c <__floatsisf+0xb4>
40009d68:	00d41433          	sll	s0,s0,a3
40009d6c:	fc0007b7          	lui	a5,0xfc000
40009d70:	fff78793          	addi	a5,a5,-1 # fbffffff <end+0xbbfef21f>
40009d74:	00747693          	andi	a3,s0,7
40009d78:	00f477b3          	and	a5,s0,a5
40009d7c:	00068a63          	beqz	a3,40009d90 <__floatsisf+0xd8>
40009d80:	00f47413          	andi	s0,s0,15
40009d84:	00400693          	li	a3,4
40009d88:	00d40463          	beq	s0,a3,40009d90 <__floatsisf+0xd8>
40009d8c:	00d787b3          	add	a5,a5,a3
40009d90:	00579693          	slli	a3,a5,0x5
40009d94:	0606c663          	bltz	a3,40009e00 <__floatsisf+0x148>
40009d98:	00679793          	slli	a5,a5,0x6
40009d9c:	0097d513          	srli	a0,a5,0x9
40009da0:	0ff77713          	andi	a4,a4,255
40009da4:	00048793          	mv	a5,s1
40009da8:	f65ff06f          	j	40009d0c <__floatsisf+0x54>
40009dac:	00000793          	li	a5,0
40009db0:	00000713          	li	a4,0
40009db4:	00000513          	li	a0,0
40009db8:	f55ff06f          	j	40009d0c <__floatsisf+0x54>
40009dbc:	40a00433          	neg	s0,a0
40009dc0:	00040513          	mv	a0,s0
40009dc4:	1c4030ef          	jal	ra,4000cf88 <__clzsi2>
40009dc8:	09e00713          	li	a4,158
40009dcc:	40a70733          	sub	a4,a4,a0
40009dd0:	09600793          	li	a5,150
40009dd4:	f8e7c0e3          	blt	a5,a4,40009d54 <__floatsisf+0x9c>
40009dd8:	f19ff06f          	j	40009cf0 <__floatsisf+0x38>
40009ddc:	0b900793          	li	a5,185
40009de0:	40e787b3          	sub	a5,a5,a4
40009de4:	00500693          	li	a3,5
40009de8:	00f417b3          	sll	a5,s0,a5
40009dec:	40a686b3          	sub	a3,a3,a0
40009df0:	00d45433          	srl	s0,s0,a3
40009df4:	00f037b3          	snez	a5,a5
40009df8:	00f46433          	or	s0,s0,a5
40009dfc:	f61ff06f          	j	40009d5c <__floatsisf+0xa4>
40009e00:	fc000737          	lui	a4,0xfc000
40009e04:	fff70713          	addi	a4,a4,-1 # fbffffff <end+0xbbfef21f>
40009e08:	00e7f7b3          	and	a5,a5,a4
40009e0c:	09f00713          	li	a4,159
40009e10:	40a70733          	sub	a4,a4,a0
40009e14:	00679793          	slli	a5,a5,0x6
40009e18:	0097d513          	srli	a0,a5,0x9
40009e1c:	0ff77713          	andi	a4,a4,255
40009e20:	00048793          	mv	a5,s1
40009e24:	ee9ff06f          	j	40009d0c <__floatsisf+0x54>

40009e28 <__adddf3>:
40009e28:	001007b7          	lui	a5,0x100
40009e2c:	fff78313          	addi	t1,a5,-1 # fffff <_heap_size+0xfdfff>
40009e30:	fe010113          	addi	sp,sp,-32
40009e34:	00b377b3          	and	a5,t1,a1
40009e38:	0145d713          	srli	a4,a1,0x14
40009e3c:	00d37eb3          	and	t4,t1,a3
40009e40:	0146de13          	srli	t3,a3,0x14
40009e44:	00379893          	slli	a7,a5,0x3
40009e48:	01d65f13          	srli	t5,a2,0x1d
40009e4c:	00912a23          	sw	s1,20(sp)
40009e50:	01312623          	sw	s3,12(sp)
40009e54:	01f5d813          	srli	a6,a1,0x1f
40009e58:	01d55793          	srli	a5,a0,0x1d
40009e5c:	003e9e93          	slli	t4,t4,0x3
40009e60:	7ff77493          	andi	s1,a4,2047
40009e64:	7ffe7e13          	andi	t3,t3,2047
40009e68:	00112e23          	sw	ra,28(sp)
40009e6c:	00812c23          	sw	s0,24(sp)
40009e70:	01212823          	sw	s2,16(sp)
40009e74:	01f6df93          	srli	t6,a3,0x1f
40009e78:	0117e7b3          	or	a5,a5,a7
40009e7c:	00080993          	mv	s3,a6
40009e80:	00351893          	slli	a7,a0,0x3
40009e84:	01df6eb3          	or	t4,t5,t4
40009e88:	00361613          	slli	a2,a2,0x3
40009e8c:	41c48733          	sub	a4,s1,t3
40009e90:	1bf80863          	beq	a6,t6,4000a040 <__adddf3+0x218>
40009e94:	30e05263          	blez	a4,4000a198 <__adddf3+0x370>
40009e98:	160e1063          	bnez	t3,40009ff8 <__adddf3+0x1d0>
40009e9c:	00cee6b3          	or	a3,t4,a2
40009ea0:	20068063          	beqz	a3,4000a0a0 <__adddf3+0x278>
40009ea4:	fff70693          	addi	a3,a4,-1
40009ea8:	3c069663          	bnez	a3,4000a274 <__adddf3+0x44c>
40009eac:	40c88933          	sub	s2,a7,a2
40009eb0:	41d787b3          	sub	a5,a5,t4
40009eb4:	0128b8b3          	sltu	a7,a7,s2
40009eb8:	411787b3          	sub	a5,a5,a7
40009ebc:	00100493          	li	s1,1
40009ec0:	00879713          	slli	a4,a5,0x8
40009ec4:	20075c63          	bgez	a4,4000a0dc <__adddf3+0x2b4>
40009ec8:	00800637          	lui	a2,0x800
40009ecc:	fff60613          	addi	a2,a2,-1 # 7fffff <_heap_size+0x7fdfff>
40009ed0:	00c7f433          	and	s0,a5,a2
40009ed4:	30040463          	beqz	s0,4000a1dc <__adddf3+0x3b4>
40009ed8:	00040513          	mv	a0,s0
40009edc:	0ac030ef          	jal	ra,4000cf88 <__clzsi2>
40009ee0:	ff850713          	addi	a4,a0,-8
40009ee4:	01f00793          	li	a5,31
40009ee8:	30e7c663          	blt	a5,a4,4000a1f4 <__adddf3+0x3cc>
40009eec:	02000793          	li	a5,32
40009ef0:	40e787b3          	sub	a5,a5,a4
40009ef4:	00f957b3          	srl	a5,s2,a5
40009ef8:	00e41633          	sll	a2,s0,a4
40009efc:	00c7e7b3          	or	a5,a5,a2
40009f00:	00e91933          	sll	s2,s2,a4
40009f04:	30974063          	blt	a4,s1,4000a204 <__adddf3+0x3dc>
40009f08:	40970733          	sub	a4,a4,s1
40009f0c:	00170613          	addi	a2,a4,1
40009f10:	01f00693          	li	a3,31
40009f14:	36c6c863          	blt	a3,a2,4000a284 <__adddf3+0x45c>
40009f18:	02000713          	li	a4,32
40009f1c:	40c70733          	sub	a4,a4,a2
40009f20:	00e916b3          	sll	a3,s2,a4
40009f24:	00c955b3          	srl	a1,s2,a2
40009f28:	00e79733          	sll	a4,a5,a4
40009f2c:	00b76733          	or	a4,a4,a1
40009f30:	00d036b3          	snez	a3,a3
40009f34:	00d76933          	or	s2,a4,a3
40009f38:	00c7d7b3          	srl	a5,a5,a2
40009f3c:	00797713          	andi	a4,s2,7
40009f40:	00098813          	mv	a6,s3
40009f44:	00000493          	li	s1,0
40009f48:	00090893          	mv	a7,s2
40009f4c:	02070063          	beqz	a4,40009f6c <__adddf3+0x144>
40009f50:	00f97713          	andi	a4,s2,15
40009f54:	00400693          	li	a3,4
40009f58:	00090893          	mv	a7,s2
40009f5c:	00d70863          	beq	a4,a3,40009f6c <__adddf3+0x144>
40009f60:	00d908b3          	add	a7,s2,a3
40009f64:	0128b6b3          	sltu	a3,a7,s2
40009f68:	00d787b3          	add	a5,a5,a3
40009f6c:	00879713          	slli	a4,a5,0x8
40009f70:	0e075a63          	bgez	a4,4000a064 <__adddf3+0x23c>
40009f74:	00148713          	addi	a4,s1,1
40009f78:	7ff00693          	li	a3,2047
40009f7c:	2ad70263          	beq	a4,a3,4000a220 <__adddf3+0x3f8>
40009f80:	ff8006b7          	lui	a3,0xff800
40009f84:	fff68693          	addi	a3,a3,-1 # ff7fffff <end+0xbf7ef21f>
40009f88:	00d7f7b3          	and	a5,a5,a3
40009f8c:	01d79693          	slli	a3,a5,0x1d
40009f90:	0038d893          	srli	a7,a7,0x3
40009f94:	00979793          	slli	a5,a5,0x9
40009f98:	0116e6b3          	or	a3,a3,a7
40009f9c:	00c7d793          	srli	a5,a5,0xc
40009fa0:	7ff77713          	andi	a4,a4,2047
40009fa4:	001005b7          	lui	a1,0x100
40009fa8:	fff58593          	addi	a1,a1,-1 # fffff <_heap_size+0xfdfff>
40009fac:	00b7f7b3          	and	a5,a5,a1
40009fb0:	801005b7          	lui	a1,0x80100
40009fb4:	fff58593          	addi	a1,a1,-1 # 800fffff <end+0x400ef21f>
40009fb8:	00b7f5b3          	and	a1,a5,a1
40009fbc:	01471713          	slli	a4,a4,0x14
40009fc0:	800007b7          	lui	a5,0x80000
40009fc4:	01c12083          	lw	ra,28(sp)
40009fc8:	00e5e5b3          	or	a1,a1,a4
40009fcc:	fff7c793          	not	a5,a5
40009fd0:	01f81813          	slli	a6,a6,0x1f
40009fd4:	00f5f5b3          	and	a1,a1,a5
40009fd8:	0105e5b3          	or	a1,a1,a6
40009fdc:	00068513          	mv	a0,a3
40009fe0:	01812403          	lw	s0,24(sp)
40009fe4:	01412483          	lw	s1,20(sp)
40009fe8:	01012903          	lw	s2,16(sp)
40009fec:	00c12983          	lw	s3,12(sp)
40009ff0:	02010113          	addi	sp,sp,32
40009ff4:	00008067          	ret
40009ff8:	008005b7          	lui	a1,0x800
40009ffc:	7ff00693          	li	a3,2047
4000a000:	00beeeb3          	or	t4,t4,a1
4000a004:	16d48663          	beq	s1,a3,4000a170 <__adddf3+0x348>
4000a008:	03800693          	li	a3,56
4000a00c:	0ae6c663          	blt	a3,a4,4000a0b8 <__adddf3+0x290>
4000a010:	01f00693          	li	a3,31
4000a014:	2ae6c463          	blt	a3,a4,4000a2bc <__adddf3+0x494>
4000a018:	02000593          	li	a1,32
4000a01c:	40e585b3          	sub	a1,a1,a4
4000a020:	00e65933          	srl	s2,a2,a4
4000a024:	00be96b3          	sll	a3,t4,a1
4000a028:	00b61633          	sll	a2,a2,a1
4000a02c:	0126e6b3          	or	a3,a3,s2
4000a030:	00c03933          	snez	s2,a2
4000a034:	0126e6b3          	or	a3,a3,s2
4000a038:	00eedeb3          	srl	t4,t4,a4
4000a03c:	0880006f          	j	4000a0c4 <__adddf3+0x29c>
4000a040:	1ee05663          	blez	a4,4000a22c <__adddf3+0x404>
4000a044:	0a0e1c63          	bnez	t3,4000a0fc <__adddf3+0x2d4>
4000a048:	00cee6b3          	or	a3,t4,a2
4000a04c:	32069063          	bnez	a3,4000a36c <__adddf3+0x544>
4000a050:	7ff00693          	li	a3,2047
4000a054:	36d70a63          	beq	a4,a3,4000a3c8 <__adddf3+0x5a0>
4000a058:	00070493          	mv	s1,a4
4000a05c:	00879713          	slli	a4,a5,0x8
4000a060:	f0074ae3          	bltz	a4,40009f74 <__adddf3+0x14c>
4000a064:	01d79693          	slli	a3,a5,0x1d
4000a068:	0038d893          	srli	a7,a7,0x3
4000a06c:	7ff00713          	li	a4,2047
4000a070:	00d8e6b3          	or	a3,a7,a3
4000a074:	0037d793          	srli	a5,a5,0x3
4000a078:	10e49663          	bne	s1,a4,4000a184 <__adddf3+0x35c>
4000a07c:	00f6e733          	or	a4,a3,a5
4000a080:	5a070c63          	beqz	a4,4000a638 <__adddf3+0x810>
4000a084:	00080737          	lui	a4,0x80
4000a088:	00e7e7b3          	or	a5,a5,a4
4000a08c:	00100737          	lui	a4,0x100
4000a090:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000a094:	00e7f7b3          	and	a5,a5,a4
4000a098:	00048713          	mv	a4,s1
4000a09c:	f09ff06f          	j	40009fa4 <__adddf3+0x17c>
4000a0a0:	7ff00693          	li	a3,2047
4000a0a4:	fad71ae3          	bne	a4,a3,4000a058 <__adddf3+0x230>
4000a0a8:	0117e6b3          	or	a3,a5,a7
4000a0ac:	32068263          	beqz	a3,4000a3d0 <__adddf3+0x5a8>
4000a0b0:	7ff00493          	li	s1,2047
4000a0b4:	eb9ff06f          	j	40009f6c <__adddf3+0x144>
4000a0b8:	00cee633          	or	a2,t4,a2
4000a0bc:	00c036b3          	snez	a3,a2
4000a0c0:	00000e93          	li	t4,0
4000a0c4:	40d88933          	sub	s2,a7,a3
4000a0c8:	41d787b3          	sub	a5,a5,t4
4000a0cc:	0128b8b3          	sltu	a7,a7,s2
4000a0d0:	411787b3          	sub	a5,a5,a7
4000a0d4:	00879713          	slli	a4,a5,0x8
4000a0d8:	de0748e3          	bltz	a4,40009ec8 <__adddf3+0xa0>
4000a0dc:	00797713          	andi	a4,s2,7
4000a0e0:	00098813          	mv	a6,s3
4000a0e4:	e60716e3          	bnez	a4,40009f50 <__adddf3+0x128>
4000a0e8:	01d79893          	slli	a7,a5,0x1d
4000a0ec:	00395693          	srli	a3,s2,0x3
4000a0f0:	0116e6b3          	or	a3,a3,a7
4000a0f4:	0037d793          	srli	a5,a5,0x3
4000a0f8:	0840006f          	j	4000a17c <__adddf3+0x354>
4000a0fc:	008005b7          	lui	a1,0x800
4000a100:	7ff00693          	li	a3,2047
4000a104:	00beeeb3          	or	t4,t4,a1
4000a108:	06d48463          	beq	s1,a3,4000a170 <__adddf3+0x348>
4000a10c:	03800693          	li	a3,56
4000a110:	28e6d463          	ble	a4,a3,4000a398 <__adddf3+0x570>
4000a114:	00cee633          	or	a2,t4,a2
4000a118:	00c036b3          	snez	a3,a2
4000a11c:	00000e93          	li	t4,0
4000a120:	01168933          	add	s2,a3,a7
4000a124:	00fe87b3          	add	a5,t4,a5
4000a128:	011938b3          	sltu	a7,s2,a7
4000a12c:	011787b3          	add	a5,a5,a7
4000a130:	00879713          	slli	a4,a5,0x8
4000a134:	fa0754e3          	bgez	a4,4000a0dc <__adddf3+0x2b4>
4000a138:	00148493          	addi	s1,s1,1
4000a13c:	7ff00713          	li	a4,2047
4000a140:	3ae48663          	beq	s1,a4,4000a4ec <__adddf3+0x6c4>
4000a144:	ff800737          	lui	a4,0xff800
4000a148:	fff70713          	addi	a4,a4,-1 # ff7fffff <end+0xbf7ef21f>
4000a14c:	00e7f7b3          	and	a5,a5,a4
4000a150:	00197693          	andi	a3,s2,1
4000a154:	00195713          	srli	a4,s2,0x1
4000a158:	00d766b3          	or	a3,a4,a3
4000a15c:	01f79913          	slli	s2,a5,0x1f
4000a160:	00d96933          	or	s2,s2,a3
4000a164:	0017d793          	srli	a5,a5,0x1
4000a168:	00797713          	andi	a4,s2,7
4000a16c:	dddff06f          	j	40009f48 <__adddf3+0x120>
4000a170:	0117e6b3          	or	a3,a5,a7
4000a174:	de069ce3          	bnez	a3,40009f6c <__adddf3+0x144>
4000a178:	00000793          	li	a5,0
4000a17c:	7ff00713          	li	a4,2047
4000a180:	eee48ee3          	beq	s1,a4,4000a07c <__adddf3+0x254>
4000a184:	00100737          	lui	a4,0x100
4000a188:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000a18c:	00e7f7b3          	and	a5,a5,a4
4000a190:	7ff4f713          	andi	a4,s1,2047
4000a194:	e11ff06f          	j	40009fa4 <__adddf3+0x17c>
4000a198:	14071a63          	bnez	a4,4000a2ec <__adddf3+0x4c4>
4000a19c:	00148713          	addi	a4,s1,1
4000a1a0:	7ff77713          	andi	a4,a4,2047
4000a1a4:	00100693          	li	a3,1
4000a1a8:	2ae6d663          	ble	a4,a3,4000a454 <__adddf3+0x62c>
4000a1ac:	40c88933          	sub	s2,a7,a2
4000a1b0:	0128b733          	sltu	a4,a7,s2
4000a1b4:	41d78433          	sub	s0,a5,t4
4000a1b8:	40e40433          	sub	s0,s0,a4
4000a1bc:	00841713          	slli	a4,s0,0x8
4000a1c0:	18075a63          	bgez	a4,4000a354 <__adddf3+0x52c>
4000a1c4:	41160933          	sub	s2,a2,a7
4000a1c8:	40fe87b3          	sub	a5,t4,a5
4000a1cc:	01263633          	sltu	a2,a2,s2
4000a1d0:	40c78433          	sub	s0,a5,a2
4000a1d4:	000f8993          	mv	s3,t6
4000a1d8:	d00410e3          	bnez	s0,40009ed8 <__adddf3+0xb0>
4000a1dc:	00090513          	mv	a0,s2
4000a1e0:	5a9020ef          	jal	ra,4000cf88 <__clzsi2>
4000a1e4:	02050513          	addi	a0,a0,32
4000a1e8:	ff850713          	addi	a4,a0,-8
4000a1ec:	01f00793          	li	a5,31
4000a1f0:	cee7dee3          	ble	a4,a5,40009eec <__adddf3+0xc4>
4000a1f4:	fd850793          	addi	a5,a0,-40
4000a1f8:	00f917b3          	sll	a5,s2,a5
4000a1fc:	00000913          	li	s2,0
4000a200:	d09754e3          	ble	s1,a4,40009f08 <__adddf3+0xe0>
4000a204:	40e484b3          	sub	s1,s1,a4
4000a208:	ff800737          	lui	a4,0xff800
4000a20c:	fff70713          	addi	a4,a4,-1 # ff7fffff <end+0xbf7ef21f>
4000a210:	00e7f7b3          	and	a5,a5,a4
4000a214:	00098813          	mv	a6,s3
4000a218:	00797713          	andi	a4,s2,7
4000a21c:	d2dff06f          	j	40009f48 <__adddf3+0x120>
4000a220:	00000793          	li	a5,0
4000a224:	00000693          	li	a3,0
4000a228:	d7dff06f          	j	40009fa4 <__adddf3+0x17c>
4000a22c:	26071e63          	bnez	a4,4000a4a8 <__adddf3+0x680>
4000a230:	00148593          	addi	a1,s1,1
4000a234:	7ff5f713          	andi	a4,a1,2047
4000a238:	00100693          	li	a3,1
4000a23c:	1ce6da63          	ble	a4,a3,4000a410 <__adddf3+0x5e8>
4000a240:	7ff00713          	li	a4,2047
4000a244:	30e58463          	beq	a1,a4,4000a54c <__adddf3+0x724>
4000a248:	00c88633          	add	a2,a7,a2
4000a24c:	011638b3          	sltu	a7,a2,a7
4000a250:	01d787b3          	add	a5,a5,t4
4000a254:	011787b3          	add	a5,a5,a7
4000a258:	01f79693          	slli	a3,a5,0x1f
4000a25c:	00165613          	srli	a2,a2,0x1
4000a260:	00c6e933          	or	s2,a3,a2
4000a264:	0017d793          	srli	a5,a5,0x1
4000a268:	00797713          	andi	a4,s2,7
4000a26c:	00058493          	mv	s1,a1
4000a270:	cd9ff06f          	j	40009f48 <__adddf3+0x120>
4000a274:	7ff00593          	li	a1,2047
4000a278:	e2b708e3          	beq	a4,a1,4000a0a8 <__adddf3+0x280>
4000a27c:	00068713          	mv	a4,a3
4000a280:	d89ff06f          	j	4000a008 <__adddf3+0x1e0>
4000a284:	fe170713          	addi	a4,a4,-31
4000a288:	02000593          	li	a1,32
4000a28c:	00e7d733          	srl	a4,a5,a4
4000a290:	00000693          	li	a3,0
4000a294:	00b60863          	beq	a2,a1,4000a2a4 <__adddf3+0x47c>
4000a298:	04000693          	li	a3,64
4000a29c:	40c686b3          	sub	a3,a3,a2
4000a2a0:	00d796b3          	sll	a3,a5,a3
4000a2a4:	00d966b3          	or	a3,s2,a3
4000a2a8:	00d036b3          	snez	a3,a3
4000a2ac:	00d76933          	or	s2,a4,a3
4000a2b0:	00000793          	li	a5,0
4000a2b4:	00000493          	li	s1,0
4000a2b8:	e25ff06f          	j	4000a0dc <__adddf3+0x2b4>
4000a2bc:	02000513          	li	a0,32
4000a2c0:	00eed6b3          	srl	a3,t4,a4
4000a2c4:	00000593          	li	a1,0
4000a2c8:	00a70863          	beq	a4,a0,4000a2d8 <__adddf3+0x4b0>
4000a2cc:	04000593          	li	a1,64
4000a2d0:	40e58733          	sub	a4,a1,a4
4000a2d4:	00ee95b3          	sll	a1,t4,a4
4000a2d8:	00c5e633          	or	a2,a1,a2
4000a2dc:	00c03933          	snez	s2,a2
4000a2e0:	0126e6b3          	or	a3,a3,s2
4000a2e4:	00000e93          	li	t4,0
4000a2e8:	dddff06f          	j	4000a0c4 <__adddf3+0x29c>
4000a2ec:	0e048863          	beqz	s1,4000a3dc <__adddf3+0x5b4>
4000a2f0:	008005b7          	lui	a1,0x800
4000a2f4:	7ff00693          	li	a3,2047
4000a2f8:	40e00733          	neg	a4,a4
4000a2fc:	00b7e7b3          	or	a5,a5,a1
4000a300:	22de0263          	beq	t3,a3,4000a524 <__adddf3+0x6fc>
4000a304:	03800693          	li	a3,56
4000a308:	22e6ca63          	blt	a3,a4,4000a53c <__adddf3+0x714>
4000a30c:	01f00693          	li	a3,31
4000a310:	38e6ca63          	blt	a3,a4,4000a6a4 <__adddf3+0x87c>
4000a314:	02000593          	li	a1,32
4000a318:	40e585b3          	sub	a1,a1,a4
4000a31c:	00b796b3          	sll	a3,a5,a1
4000a320:	00e8d533          	srl	a0,a7,a4
4000a324:	00b895b3          	sll	a1,a7,a1
4000a328:	00a6e6b3          	or	a3,a3,a0
4000a32c:	00b03933          	snez	s2,a1
4000a330:	0126e6b3          	or	a3,a3,s2
4000a334:	00e7d733          	srl	a4,a5,a4
4000a338:	40d60933          	sub	s2,a2,a3
4000a33c:	40ee87b3          	sub	a5,t4,a4
4000a340:	01263633          	sltu	a2,a2,s2
4000a344:	40c787b3          	sub	a5,a5,a2
4000a348:	000e0493          	mv	s1,t3
4000a34c:	000f8993          	mv	s3,t6
4000a350:	b71ff06f          	j	40009ec0 <__adddf3+0x98>
4000a354:	008966b3          	or	a3,s2,s0
4000a358:	b6069ee3          	bnez	a3,40009ed4 <__adddf3+0xac>
4000a35c:	00000793          	li	a5,0
4000a360:	00000813          	li	a6,0
4000a364:	00000493          	li	s1,0
4000a368:	e15ff06f          	j	4000a17c <__adddf3+0x354>
4000a36c:	fff70693          	addi	a3,a4,-1
4000a370:	08069863          	bnez	a3,4000a400 <__adddf3+0x5d8>
4000a374:	00c88933          	add	s2,a7,a2
4000a378:	01d787b3          	add	a5,a5,t4
4000a37c:	011938b3          	sltu	a7,s2,a7
4000a380:	011787b3          	add	a5,a5,a7
4000a384:	00879713          	slli	a4,a5,0x8
4000a388:	00100493          	li	s1,1
4000a38c:	d40758e3          	bgez	a4,4000a0dc <__adddf3+0x2b4>
4000a390:	00200493          	li	s1,2
4000a394:	db1ff06f          	j	4000a144 <__adddf3+0x31c>
4000a398:	01f00693          	li	a3,31
4000a39c:	0ce6ce63          	blt	a3,a4,4000a478 <__adddf3+0x650>
4000a3a0:	02000593          	li	a1,32
4000a3a4:	40e585b3          	sub	a1,a1,a4
4000a3a8:	00be96b3          	sll	a3,t4,a1
4000a3ac:	00e65533          	srl	a0,a2,a4
4000a3b0:	00b61633          	sll	a2,a2,a1
4000a3b4:	00a6e6b3          	or	a3,a3,a0
4000a3b8:	00c03933          	snez	s2,a2
4000a3bc:	0126e6b3          	or	a3,a3,s2
4000a3c0:	00eedeb3          	srl	t4,t4,a4
4000a3c4:	d5dff06f          	j	4000a120 <__adddf3+0x2f8>
4000a3c8:	0117e6b3          	or	a3,a5,a7
4000a3cc:	c80696e3          	bnez	a3,4000a058 <__adddf3+0x230>
4000a3d0:	00000793          	li	a5,0
4000a3d4:	00070493          	mv	s1,a4
4000a3d8:	da5ff06f          	j	4000a17c <__adddf3+0x354>
4000a3dc:	0117e6b3          	or	a3,a5,a7
4000a3e0:	10069c63          	bnez	a3,4000a4f8 <__adddf3+0x6d0>
4000a3e4:	7ff00793          	li	a5,2047
4000a3e8:	12fe0e63          	beq	t3,a5,4000a524 <__adddf3+0x6fc>
4000a3ec:	000f8813          	mv	a6,t6
4000a3f0:	000e8793          	mv	a5,t4
4000a3f4:	00060893          	mv	a7,a2
4000a3f8:	000e0493          	mv	s1,t3
4000a3fc:	b71ff06f          	j	40009f6c <__adddf3+0x144>
4000a400:	7ff00593          	li	a1,2047
4000a404:	fcb702e3          	beq	a4,a1,4000a3c8 <__adddf3+0x5a0>
4000a408:	00068713          	mv	a4,a3
4000a40c:	d01ff06f          	j	4000a10c <__adddf3+0x2e4>
4000a410:	0117e733          	or	a4,a5,a7
4000a414:	22049a63          	bnez	s1,4000a648 <__adddf3+0x820>
4000a418:	04070a63          	beqz	a4,4000a46c <__adddf3+0x644>
4000a41c:	00cee733          	or	a4,t4,a2
4000a420:	b40706e3          	beqz	a4,40009f6c <__adddf3+0x144>
4000a424:	00c88933          	add	s2,a7,a2
4000a428:	01d787b3          	add	a5,a5,t4
4000a42c:	011938b3          	sltu	a7,s2,a7
4000a430:	011787b3          	add	a5,a5,a7
4000a434:	00879713          	slli	a4,a5,0x8
4000a438:	ca0752e3          	bgez	a4,4000a0dc <__adddf3+0x2b4>
4000a43c:	ff800737          	lui	a4,0xff800
4000a440:	fff70713          	addi	a4,a4,-1 # ff7fffff <end+0xbf7ef21f>
4000a444:	00e7f7b3          	and	a5,a5,a4
4000a448:	00068493          	mv	s1,a3
4000a44c:	00797713          	andi	a4,s2,7
4000a450:	af9ff06f          	j	40009f48 <__adddf3+0x120>
4000a454:	0117e733          	or	a4,a5,a7
4000a458:	06049a63          	bnez	s1,4000a4cc <__adddf3+0x6a4>
4000a45c:	16071063          	bnez	a4,4000a5bc <__adddf3+0x794>
4000a460:	00cee6b3          	or	a3,t4,a2
4000a464:	22068a63          	beqz	a3,4000a698 <__adddf3+0x870>
4000a468:	000f8813          	mv	a6,t6
4000a46c:	000e8793          	mv	a5,t4
4000a470:	00060893          	mv	a7,a2
4000a474:	af9ff06f          	j	40009f6c <__adddf3+0x144>
4000a478:	02000513          	li	a0,32
4000a47c:	00eed6b3          	srl	a3,t4,a4
4000a480:	00000593          	li	a1,0
4000a484:	00a70863          	beq	a4,a0,4000a494 <__adddf3+0x66c>
4000a488:	04000593          	li	a1,64
4000a48c:	40e58733          	sub	a4,a1,a4
4000a490:	00ee95b3          	sll	a1,t4,a4
4000a494:	00c5e633          	or	a2,a1,a2
4000a498:	00c03933          	snez	s2,a2
4000a49c:	0126e6b3          	or	a3,a3,s2
4000a4a0:	00000e93          	li	t4,0
4000a4a4:	c7dff06f          	j	4000a120 <__adddf3+0x2f8>
4000a4a8:	0a049a63          	bnez	s1,4000a55c <__adddf3+0x734>
4000a4ac:	0117e6b3          	or	a3,a5,a7
4000a4b0:	22069263          	bnez	a3,4000a6d4 <__adddf3+0x8ac>
4000a4b4:	7ff00793          	li	a5,2047
4000a4b8:	24fe0263          	beq	t3,a5,4000a6fc <__adddf3+0x8d4>
4000a4bc:	000e8793          	mv	a5,t4
4000a4c0:	00060893          	mv	a7,a2
4000a4c4:	000e0493          	mv	s1,t3
4000a4c8:	aa5ff06f          	j	40009f6c <__adddf3+0x144>
4000a4cc:	12071663          	bnez	a4,4000a5f8 <__adddf3+0x7d0>
4000a4d0:	00cee7b3          	or	a5,t4,a2
4000a4d4:	22078a63          	beqz	a5,4000a708 <__adddf3+0x8e0>
4000a4d8:	000f8813          	mv	a6,t6
4000a4dc:	000e8793          	mv	a5,t4
4000a4e0:	00060893          	mv	a7,a2
4000a4e4:	7ff00493          	li	s1,2047
4000a4e8:	a85ff06f          	j	40009f6c <__adddf3+0x144>
4000a4ec:	00000793          	li	a5,0
4000a4f0:	00000693          	li	a3,0
4000a4f4:	c89ff06f          	j	4000a17c <__adddf3+0x354>
4000a4f8:	fff74713          	not	a4,a4
4000a4fc:	02071063          	bnez	a4,4000a51c <__adddf3+0x6f4>
4000a500:	41160933          	sub	s2,a2,a7
4000a504:	40fe87b3          	sub	a5,t4,a5
4000a508:	01263633          	sltu	a2,a2,s2
4000a50c:	40c787b3          	sub	a5,a5,a2
4000a510:	000e0493          	mv	s1,t3
4000a514:	000f8993          	mv	s3,t6
4000a518:	9a9ff06f          	j	40009ec0 <__adddf3+0x98>
4000a51c:	7ff00693          	li	a3,2047
4000a520:	dede12e3          	bne	t3,a3,4000a304 <__adddf3+0x4dc>
4000a524:	00cee6b3          	or	a3,t4,a2
4000a528:	000f8813          	mv	a6,t6
4000a52c:	f80698e3          	bnez	a3,4000a4bc <__adddf3+0x694>
4000a530:	00000793          	li	a5,0
4000a534:	000e0493          	mv	s1,t3
4000a538:	c45ff06f          	j	4000a17c <__adddf3+0x354>
4000a53c:	0117e7b3          	or	a5,a5,a7
4000a540:	00f036b3          	snez	a3,a5
4000a544:	00000713          	li	a4,0
4000a548:	df1ff06f          	j	4000a338 <__adddf3+0x510>
4000a54c:	00058493          	mv	s1,a1
4000a550:	00000793          	li	a5,0
4000a554:	00000693          	li	a3,0
4000a558:	c25ff06f          	j	4000a17c <__adddf3+0x354>
4000a55c:	008005b7          	lui	a1,0x800
4000a560:	7ff00693          	li	a3,2047
4000a564:	40e00733          	neg	a4,a4
4000a568:	00b7e7b3          	or	a5,a5,a1
4000a56c:	18de0863          	beq	t3,a3,4000a6fc <__adddf3+0x8d4>
4000a570:	03800693          	li	a3,56
4000a574:	1ae6c463          	blt	a3,a4,4000a71c <__adddf3+0x8f4>
4000a578:	01f00693          	li	a3,31
4000a57c:	1ce6c463          	blt	a3,a4,4000a744 <__adddf3+0x91c>
4000a580:	02000593          	li	a1,32
4000a584:	40e585b3          	sub	a1,a1,a4
4000a588:	00b796b3          	sll	a3,a5,a1
4000a58c:	00e8d533          	srl	a0,a7,a4
4000a590:	00b895b3          	sll	a1,a7,a1
4000a594:	00a6e6b3          	or	a3,a3,a0
4000a598:	00b03933          	snez	s2,a1
4000a59c:	0126e6b3          	or	a3,a3,s2
4000a5a0:	00e7d7b3          	srl	a5,a5,a4
4000a5a4:	00c68933          	add	s2,a3,a2
4000a5a8:	01d787b3          	add	a5,a5,t4
4000a5ac:	00c93633          	sltu	a2,s2,a2
4000a5b0:	00c787b3          	add	a5,a5,a2
4000a5b4:	000e0493          	mv	s1,t3
4000a5b8:	b79ff06f          	j	4000a130 <__adddf3+0x308>
4000a5bc:	00cee733          	or	a4,t4,a2
4000a5c0:	9a0706e3          	beqz	a4,40009f6c <__adddf3+0x144>
4000a5c4:	40c88933          	sub	s2,a7,a2
4000a5c8:	0128b6b3          	sltu	a3,a7,s2
4000a5cc:	41d78733          	sub	a4,a5,t4
4000a5d0:	40d70733          	sub	a4,a4,a3
4000a5d4:	00871693          	slli	a3,a4,0x8
4000a5d8:	0a06da63          	bgez	a3,4000a68c <__adddf3+0x864>
4000a5dc:	41160933          	sub	s2,a2,a7
4000a5e0:	40fe87b3          	sub	a5,t4,a5
4000a5e4:	01263633          	sltu	a2,a2,s2
4000a5e8:	40c787b3          	sub	a5,a5,a2
4000a5ec:	00797713          	andi	a4,s2,7
4000a5f0:	000f8813          	mv	a6,t6
4000a5f4:	955ff06f          	j	40009f48 <__adddf3+0x120>
4000a5f8:	00cee633          	or	a2,t4,a2
4000a5fc:	aa060ae3          	beqz	a2,4000a0b0 <__adddf3+0x288>
4000a600:	00feeeb3          	or	t4,t4,a5
4000a604:	009e9713          	slli	a4,t4,0x9
4000a608:	12074263          	bltz	a4,4000a72c <__adddf3+0x904>
4000a60c:	20000737          	lui	a4,0x20000
4000a610:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
4000a614:	01d79893          	slli	a7,a5,0x1d
4000a618:	00a77533          	and	a0,a4,a0
4000a61c:	00a8e533          	or	a0,a7,a0
4000a620:	ff87f793          	andi	a5,a5,-8
4000a624:	01d55713          	srli	a4,a0,0x1d
4000a628:	00e7e7b3          	or	a5,a5,a4
4000a62c:	00351893          	slli	a7,a0,0x3
4000a630:	7ff00493          	li	s1,2047
4000a634:	939ff06f          	j	40009f6c <__adddf3+0x144>
4000a638:	00000693          	li	a3,0
4000a63c:	00048713          	mv	a4,s1
4000a640:	00000793          	li	a5,0
4000a644:	961ff06f          	j	40009fa4 <__adddf3+0x17c>
4000a648:	e8070ae3          	beqz	a4,4000a4dc <__adddf3+0x6b4>
4000a64c:	00cee633          	or	a2,t4,a2
4000a650:	a60600e3          	beqz	a2,4000a0b0 <__adddf3+0x288>
4000a654:	00feeeb3          	or	t4,t4,a5
4000a658:	009e9713          	slli	a4,t4,0x9
4000a65c:	0c074863          	bltz	a4,4000a72c <__adddf3+0x904>
4000a660:	20000737          	lui	a4,0x20000
4000a664:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
4000a668:	01d79893          	slli	a7,a5,0x1d
4000a66c:	00a77533          	and	a0,a4,a0
4000a670:	00a8e533          	or	a0,a7,a0
4000a674:	01d55713          	srli	a4,a0,0x1d
4000a678:	ff87f793          	andi	a5,a5,-8
4000a67c:	00f767b3          	or	a5,a4,a5
4000a680:	00351893          	slli	a7,a0,0x3
4000a684:	7ff00493          	li	s1,2047
4000a688:	8e5ff06f          	j	40009f6c <__adddf3+0x144>
4000a68c:	00e966b3          	or	a3,s2,a4
4000a690:	00070793          	mv	a5,a4
4000a694:	a40694e3          	bnez	a3,4000a0dc <__adddf3+0x2b4>
4000a698:	00000793          	li	a5,0
4000a69c:	00000813          	li	a6,0
4000a6a0:	addff06f          	j	4000a17c <__adddf3+0x354>
4000a6a4:	02000513          	li	a0,32
4000a6a8:	00e7d6b3          	srl	a3,a5,a4
4000a6ac:	00000593          	li	a1,0
4000a6b0:	00a70863          	beq	a4,a0,4000a6c0 <__adddf3+0x898>
4000a6b4:	04000593          	li	a1,64
4000a6b8:	40e58733          	sub	a4,a1,a4
4000a6bc:	00e795b3          	sll	a1,a5,a4
4000a6c0:	0115e5b3          	or	a1,a1,a7
4000a6c4:	00b03933          	snez	s2,a1
4000a6c8:	0126e6b3          	or	a3,a3,s2
4000a6cc:	00000713          	li	a4,0
4000a6d0:	c69ff06f          	j	4000a338 <__adddf3+0x510>
4000a6d4:	fff74713          	not	a4,a4
4000a6d8:	00071e63          	bnez	a4,4000a6f4 <__adddf3+0x8cc>
4000a6dc:	00c88933          	add	s2,a7,a2
4000a6e0:	01d787b3          	add	a5,a5,t4
4000a6e4:	00c93633          	sltu	a2,s2,a2
4000a6e8:	00c787b3          	add	a5,a5,a2
4000a6ec:	000e0493          	mv	s1,t3
4000a6f0:	a41ff06f          	j	4000a130 <__adddf3+0x308>
4000a6f4:	7ff00693          	li	a3,2047
4000a6f8:	e6de1ce3          	bne	t3,a3,4000a570 <__adddf3+0x748>
4000a6fc:	00cee6b3          	or	a3,t4,a2
4000a700:	da069ee3          	bnez	a3,4000a4bc <__adddf3+0x694>
4000a704:	e2dff06f          	j	4000a530 <__adddf3+0x708>
4000a708:	00000813          	li	a6,0
4000a70c:	00030793          	mv	a5,t1
4000a710:	fff00693          	li	a3,-1
4000a714:	7ff00493          	li	s1,2047
4000a718:	a65ff06f          	j	4000a17c <__adddf3+0x354>
4000a71c:	0117e7b3          	or	a5,a5,a7
4000a720:	00f036b3          	snez	a3,a5
4000a724:	00000793          	li	a5,0
4000a728:	e7dff06f          	j	4000a5a4 <__adddf3+0x77c>
4000a72c:	008007b7          	lui	a5,0x800
4000a730:	00000813          	li	a6,0
4000a734:	ff800893          	li	a7,-8
4000a738:	fff78793          	addi	a5,a5,-1 # 7fffff <_heap_size+0x7fdfff>
4000a73c:	7ff00493          	li	s1,2047
4000a740:	82dff06f          	j	40009f6c <__adddf3+0x144>
4000a744:	02000513          	li	a0,32
4000a748:	00e7d6b3          	srl	a3,a5,a4
4000a74c:	00000593          	li	a1,0
4000a750:	00a70863          	beq	a4,a0,4000a760 <__adddf3+0x938>
4000a754:	04000593          	li	a1,64
4000a758:	40e58733          	sub	a4,a1,a4
4000a75c:	00e795b3          	sll	a1,a5,a4
4000a760:	0115e5b3          	or	a1,a1,a7
4000a764:	00b03933          	snez	s2,a1
4000a768:	0126e6b3          	or	a3,a3,s2
4000a76c:	00000793          	li	a5,0
4000a770:	e35ff06f          	j	4000a5a4 <__adddf3+0x77c>

4000a774 <__divdf3>:
4000a774:	fa010113          	addi	sp,sp,-96
4000a778:	04812c23          	sw	s0,88(sp)
4000a77c:	0145d793          	srli	a5,a1,0x14
4000a780:	00100437          	lui	s0,0x100
4000a784:	04912a23          	sw	s1,84(sp)
4000a788:	05412423          	sw	s4,72(sp)
4000a78c:	05612023          	sw	s6,64(sp)
4000a790:	03812c23          	sw	s8,56(sp)
4000a794:	00050493          	mv	s1,a0
4000a798:	01f5da13          	srli	s4,a1,0x1f
4000a79c:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
4000a7a0:	04112e23          	sw	ra,92(sp)
4000a7a4:	05212823          	sw	s2,80(sp)
4000a7a8:	05312623          	sw	s3,76(sp)
4000a7ac:	05512223          	sw	s5,68(sp)
4000a7b0:	03712e23          	sw	s7,60(sp)
4000a7b4:	03912a23          	sw	s9,52(sp)
4000a7b8:	03a12823          	sw	s10,48(sp)
4000a7bc:	03b12623          	sw	s11,44(sp)
4000a7c0:	7ff7f513          	andi	a0,a5,2047
4000a7c4:	00060c13          	mv	s8,a2
4000a7c8:	00b47433          	and	s0,s0,a1
4000a7cc:	000a0b13          	mv	s6,s4
4000a7d0:	1c050e63          	beqz	a0,4000a9ac <__divdf3+0x238>
4000a7d4:	7ff00793          	li	a5,2047
4000a7d8:	08f50a63          	beq	a0,a5,4000a86c <__divdf3+0xf8>
4000a7dc:	01d4da93          	srli	s5,s1,0x1d
4000a7e0:	008007b7          	lui	a5,0x800
4000a7e4:	00341413          	slli	s0,s0,0x3
4000a7e8:	00faeab3          	or	s5,s5,a5
4000a7ec:	00349913          	slli	s2,s1,0x3
4000a7f0:	008aeab3          	or	s5,s5,s0
4000a7f4:	c0150b93          	addi	s7,a0,-1023
4000a7f8:	00000493          	li	s1,0
4000a7fc:	00000c93          	li	s9,0
4000a800:	0146d513          	srli	a0,a3,0x14
4000a804:	00100437          	lui	s0,0x100
4000a808:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
4000a80c:	7ff57513          	andi	a0,a0,2047
4000a810:	00d47433          	and	s0,s0,a3
4000a814:	01f6d993          	srli	s3,a3,0x1f
4000a818:	08050463          	beqz	a0,4000a8a0 <__divdf3+0x12c>
4000a81c:	7ff00793          	li	a5,2047
4000a820:	1ef50263          	beq	a0,a5,4000aa04 <__divdf3+0x290>
4000a824:	01dc5793          	srli	a5,s8,0x1d
4000a828:	00800737          	lui	a4,0x800
4000a82c:	00341413          	slli	s0,s0,0x3
4000a830:	00e7e7b3          	or	a5,a5,a4
4000a834:	0087e433          	or	s0,a5,s0
4000a838:	003c1693          	slli	a3,s8,0x3
4000a83c:	c0150513          	addi	a0,a0,-1023
4000a840:	00000613          	li	a2,0
4000a844:	009667b3          	or	a5,a2,s1
4000a848:	4000e737          	lui	a4,0x4000e
4000a84c:	ab470713          	addi	a4,a4,-1356 # 4000dab4 <zeroes.4082+0x90>
4000a850:	00279793          	slli	a5,a5,0x2
4000a854:	00e787b3          	add	a5,a5,a4
4000a858:	0007a783          	lw	a5,0(a5) # 800000 <_heap_size+0x7fe000>
4000a85c:	013a4733          	xor	a4,s4,s3
4000a860:	00070c13          	mv	s8,a4
4000a864:	40ab8bb3          	sub	s7,s7,a0
4000a868:	00078067          	jr	a5
4000a86c:	00946ab3          	or	s5,s0,s1
4000a870:	1c0a9c63          	bnez	s5,4000aa48 <__divdf3+0x2d4>
4000a874:	00050b93          	mv	s7,a0
4000a878:	00100437          	lui	s0,0x100
4000a87c:	0146d513          	srli	a0,a3,0x14
4000a880:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
4000a884:	7ff57513          	andi	a0,a0,2047
4000a888:	00000913          	li	s2,0
4000a88c:	00800493          	li	s1,8
4000a890:	00200c93          	li	s9,2
4000a894:	00d47433          	and	s0,s0,a3
4000a898:	01f6d993          	srli	s3,a3,0x1f
4000a89c:	f80510e3          	bnez	a0,4000a81c <__divdf3+0xa8>
4000a8a0:	018466b3          	or	a3,s0,s8
4000a8a4:	16068a63          	beqz	a3,4000aa18 <__divdf3+0x2a4>
4000a8a8:	26040463          	beqz	s0,4000ab10 <__divdf3+0x39c>
4000a8ac:	00040513          	mv	a0,s0
4000a8b0:	6d8020ef          	jal	ra,4000cf88 <__clzsi2>
4000a8b4:	ff550713          	addi	a4,a0,-11
4000a8b8:	01c00793          	li	a5,28
4000a8bc:	24e7c263          	blt	a5,a4,4000ab00 <__divdf3+0x38c>
4000a8c0:	01d00793          	li	a5,29
4000a8c4:	ff850693          	addi	a3,a0,-8
4000a8c8:	40e787b3          	sub	a5,a5,a4
4000a8cc:	00d41433          	sll	s0,s0,a3
4000a8d0:	00fc57b3          	srl	a5,s8,a5
4000a8d4:	0087e433          	or	s0,a5,s0
4000a8d8:	00dc16b3          	sll	a3,s8,a3
4000a8dc:	c0d00793          	li	a5,-1011
4000a8e0:	40a78533          	sub	a0,a5,a0
4000a8e4:	00000613          	li	a2,0
4000a8e8:	f5dff06f          	j	4000a844 <__divdf3+0xd0>
4000a8ec:	7ff00793          	li	a5,2047
4000a8f0:	00000513          	li	a0,0
4000a8f4:	00000913          	li	s2,0
4000a8f8:	001006b7          	lui	a3,0x100
4000a8fc:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000a900:	00d57533          	and	a0,a0,a3
4000a904:	01479693          	slli	a3,a5,0x14
4000a908:	801007b7          	lui	a5,0x80100
4000a90c:	fff78793          	addi	a5,a5,-1 # 800fffff <end+0x400ef21f>
4000a910:	00f577b3          	and	a5,a0,a5
4000a914:	80000537          	lui	a0,0x80000
4000a918:	00d7e7b3          	or	a5,a5,a3
4000a91c:	fff54513          	not	a0,a0
4000a920:	05c12083          	lw	ra,92(sp)
4000a924:	00a7f7b3          	and	a5,a5,a0
4000a928:	01f71693          	slli	a3,a4,0x1f
4000a92c:	00d7e7b3          	or	a5,a5,a3
4000a930:	00090513          	mv	a0,s2
4000a934:	00078593          	mv	a1,a5
4000a938:	05812403          	lw	s0,88(sp)
4000a93c:	05412483          	lw	s1,84(sp)
4000a940:	05012903          	lw	s2,80(sp)
4000a944:	04c12983          	lw	s3,76(sp)
4000a948:	04812a03          	lw	s4,72(sp)
4000a94c:	04412a83          	lw	s5,68(sp)
4000a950:	04012b03          	lw	s6,64(sp)
4000a954:	03c12b83          	lw	s7,60(sp)
4000a958:	03812c03          	lw	s8,56(sp)
4000a95c:	03412c83          	lw	s9,52(sp)
4000a960:	03012d03          	lw	s10,48(sp)
4000a964:	02c12d83          	lw	s11,44(sp)
4000a968:	06010113          	addi	sp,sp,96
4000a96c:	00008067          	ret
4000a970:	00098b13          	mv	s6,s3
4000a974:	00040a93          	mv	s5,s0
4000a978:	00068913          	mv	s2,a3
4000a97c:	00060c93          	mv	s9,a2
4000a980:	00200793          	li	a5,2
4000a984:	70fc8a63          	beq	s9,a5,4000b098 <__divdf3+0x924>
4000a988:	00300793          	li	a5,3
4000a98c:	72fc8063          	beq	s9,a5,4000b0ac <__divdf3+0x938>
4000a990:	00100793          	li	a5,1
4000a994:	62fc9063          	bne	s9,a5,4000afb4 <__divdf3+0x840>
4000a998:	000b0713          	mv	a4,s6
4000a99c:	00000793          	li	a5,0
4000a9a0:	00000513          	li	a0,0
4000a9a4:	00000913          	li	s2,0
4000a9a8:	f51ff06f          	j	4000a8f8 <__divdf3+0x184>
4000a9ac:	00946ab3          	or	s5,s0,s1
4000a9b0:	080a8263          	beqz	s5,4000aa34 <__divdf3+0x2c0>
4000a9b4:	00d12623          	sw	a3,12(sp)
4000a9b8:	12040a63          	beqz	s0,4000aaec <__divdf3+0x378>
4000a9bc:	00040513          	mv	a0,s0
4000a9c0:	5c8020ef          	jal	ra,4000cf88 <__clzsi2>
4000a9c4:	00c12683          	lw	a3,12(sp)
4000a9c8:	ff550793          	addi	a5,a0,-11 # 7ffffff5 <end+0x3ffef215>
4000a9cc:	01c00713          	li	a4,28
4000a9d0:	10f74663          	blt	a4,a5,4000aadc <__divdf3+0x368>
4000a9d4:	01d00a93          	li	s5,29
4000a9d8:	ff850713          	addi	a4,a0,-8
4000a9dc:	40fa8ab3          	sub	s5,s5,a5
4000a9e0:	00e41433          	sll	s0,s0,a4
4000a9e4:	0154dab3          	srl	s5,s1,s5
4000a9e8:	008aeab3          	or	s5,s5,s0
4000a9ec:	00e49933          	sll	s2,s1,a4
4000a9f0:	c0d00b93          	li	s7,-1011
4000a9f4:	40ab8bb3          	sub	s7,s7,a0
4000a9f8:	00000493          	li	s1,0
4000a9fc:	00000c93          	li	s9,0
4000aa00:	e01ff06f          	j	4000a800 <__divdf3+0x8c>
4000aa04:	018466b3          	or	a3,s0,s8
4000aa08:	02069063          	bnez	a3,4000aa28 <__divdf3+0x2b4>
4000aa0c:	00000413          	li	s0,0
4000aa10:	00200613          	li	a2,2
4000aa14:	e31ff06f          	j	4000a844 <__divdf3+0xd0>
4000aa18:	00000413          	li	s0,0
4000aa1c:	00000513          	li	a0,0
4000aa20:	00100613          	li	a2,1
4000aa24:	e21ff06f          	j	4000a844 <__divdf3+0xd0>
4000aa28:	000c0693          	mv	a3,s8
4000aa2c:	00300613          	li	a2,3
4000aa30:	e15ff06f          	j	4000a844 <__divdf3+0xd0>
4000aa34:	00000913          	li	s2,0
4000aa38:	00400493          	li	s1,4
4000aa3c:	00000b93          	li	s7,0
4000aa40:	00100c93          	li	s9,1
4000aa44:	dbdff06f          	j	4000a800 <__divdf3+0x8c>
4000aa48:	00048913          	mv	s2,s1
4000aa4c:	00040a93          	mv	s5,s0
4000aa50:	00c00493          	li	s1,12
4000aa54:	00050b93          	mv	s7,a0
4000aa58:	00300c93          	li	s9,3
4000aa5c:	da5ff06f          	j	4000a800 <__divdf3+0x8c>
4000aa60:	00100537          	lui	a0,0x100
4000aa64:	00000713          	li	a4,0
4000aa68:	fff50513          	addi	a0,a0,-1 # fffff <_heap_size+0xfdfff>
4000aa6c:	fff00913          	li	s2,-1
4000aa70:	7ff00793          	li	a5,2047
4000aa74:	e85ff06f          	j	4000a8f8 <__divdf3+0x184>
4000aa78:	40f40433          	sub	s0,s0,a5
4000aa7c:	03800713          	li	a4,56
4000aa80:	58875a63          	ble	s0,a4,4000b014 <__divdf3+0x8a0>
4000aa84:	001c7713          	andi	a4,s8,1
4000aa88:	00000793          	li	a5,0
4000aa8c:	00000513          	li	a0,0
4000aa90:	00000913          	li	s2,0
4000aa94:	e65ff06f          	j	4000a8f8 <__divdf3+0x184>
4000aa98:	09546663          	bltu	s0,s5,4000ab24 <__divdf3+0x3b0>
4000aa9c:	088a8263          	beq	s5,s0,4000ab20 <__divdf3+0x3ac>
4000aaa0:	00090a13          	mv	s4,s2
4000aaa4:	fffb8b93          	addi	s7,s7,-1
4000aaa8:	00000913          	li	s2,0
4000aaac:	08c0006f          	j	4000ab38 <__divdf3+0x3c4>
4000aab0:	008ae433          	or	s0,s5,s0
4000aab4:	00c41793          	slli	a5,s0,0xc
4000aab8:	fa07c4e3          	bltz	a5,4000aa60 <__divdf3+0x2ec>
4000aabc:	000807b7          	lui	a5,0x80
4000aac0:	00fae533          	or	a0,s5,a5
4000aac4:	001007b7          	lui	a5,0x100
4000aac8:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000aacc:	00f57533          	and	a0,a0,a5
4000aad0:	000a0713          	mv	a4,s4
4000aad4:	7ff00793          	li	a5,2047
4000aad8:	e21ff06f          	j	4000a8f8 <__divdf3+0x184>
4000aadc:	fd850413          	addi	s0,a0,-40
4000aae0:	00849ab3          	sll	s5,s1,s0
4000aae4:	00000913          	li	s2,0
4000aae8:	f09ff06f          	j	4000a9f0 <__divdf3+0x27c>
4000aaec:	00048513          	mv	a0,s1
4000aaf0:	498020ef          	jal	ra,4000cf88 <__clzsi2>
4000aaf4:	02050513          	addi	a0,a0,32
4000aaf8:	00c12683          	lw	a3,12(sp)
4000aafc:	ecdff06f          	j	4000a9c8 <__divdf3+0x254>
4000ab00:	fd850413          	addi	s0,a0,-40
4000ab04:	008c1433          	sll	s0,s8,s0
4000ab08:	00000693          	li	a3,0
4000ab0c:	dd1ff06f          	j	4000a8dc <__divdf3+0x168>
4000ab10:	000c0513          	mv	a0,s8
4000ab14:	474020ef          	jal	ra,4000cf88 <__clzsi2>
4000ab18:	02050513          	addi	a0,a0,32
4000ab1c:	d99ff06f          	j	4000a8b4 <__divdf3+0x140>
4000ab20:	f8d960e3          	bltu	s2,a3,4000aaa0 <__divdf3+0x32c>
4000ab24:	01fa9a13          	slli	s4,s5,0x1f
4000ab28:	00195793          	srli	a5,s2,0x1
4000ab2c:	001ada93          	srli	s5,s5,0x1
4000ab30:	00fa6a33          	or	s4,s4,a5
4000ab34:	01f91913          	slli	s2,s2,0x1f
4000ab38:	0186dd13          	srli	s10,a3,0x18
4000ab3c:	00841413          	slli	s0,s0,0x8
4000ab40:	008d6d33          	or	s10,s10,s0
4000ab44:	010d5993          	srli	s3,s10,0x10
4000ab48:	00098593          	mv	a1,s3
4000ab4c:	010d1c93          	slli	s9,s10,0x10
4000ab50:	000a8513          	mv	a0,s5
4000ab54:	00869493          	slli	s1,a3,0x8
4000ab58:	010cdc93          	srli	s9,s9,0x10
4000ab5c:	380020ef          	jal	ra,4000cedc <__udivsi3>
4000ab60:	00050593          	mv	a1,a0
4000ab64:	00050d93          	mv	s11,a0
4000ab68:	000c8513          	mv	a0,s9
4000ab6c:	344020ef          	jal	ra,4000ceb0 <__mulsi3>
4000ab70:	00050b13          	mv	s6,a0
4000ab74:	00098593          	mv	a1,s3
4000ab78:	000a8513          	mv	a0,s5
4000ab7c:	3a8020ef          	jal	ra,4000cf24 <__umodsi3>
4000ab80:	01051513          	slli	a0,a0,0x10
4000ab84:	010a5793          	srli	a5,s4,0x10
4000ab88:	00a7e533          	or	a0,a5,a0
4000ab8c:	01657e63          	bleu	s6,a0,4000aba8 <__divdf3+0x434>
4000ab90:	01a50533          	add	a0,a0,s10
4000ab94:	fffd8793          	addi	a5,s11,-1
4000ab98:	35a56663          	bltu	a0,s10,4000aee4 <__divdf3+0x770>
4000ab9c:	35657463          	bleu	s6,a0,4000aee4 <__divdf3+0x770>
4000aba0:	ffed8d93          	addi	s11,s11,-2
4000aba4:	01a50533          	add	a0,a0,s10
4000aba8:	41650b33          	sub	s6,a0,s6
4000abac:	00098593          	mv	a1,s3
4000abb0:	000b0513          	mv	a0,s6
4000abb4:	328020ef          	jal	ra,4000cedc <__udivsi3>
4000abb8:	00050593          	mv	a1,a0
4000abbc:	00050a93          	mv	s5,a0
4000abc0:	000c8513          	mv	a0,s9
4000abc4:	2ec020ef          	jal	ra,4000ceb0 <__mulsi3>
4000abc8:	00a12623          	sw	a0,12(sp)
4000abcc:	00098593          	mv	a1,s3
4000abd0:	000b0513          	mv	a0,s6
4000abd4:	350020ef          	jal	ra,4000cf24 <__umodsi3>
4000abd8:	010a1a13          	slli	s4,s4,0x10
4000abdc:	00c12703          	lw	a4,12(sp)
4000abe0:	01051793          	slli	a5,a0,0x10
4000abe4:	010a5a13          	srli	s4,s4,0x10
4000abe8:	00fa67b3          	or	a5,s4,a5
4000abec:	00e7fe63          	bleu	a4,a5,4000ac08 <__divdf3+0x494>
4000abf0:	01a787b3          	add	a5,a5,s10
4000abf4:	fffa8693          	addi	a3,s5,-1
4000abf8:	2fa7e263          	bltu	a5,s10,4000aedc <__divdf3+0x768>
4000abfc:	2ee7f063          	bleu	a4,a5,4000aedc <__divdf3+0x768>
4000ac00:	ffea8a93          	addi	s5,s5,-2
4000ac04:	01a787b3          	add	a5,a5,s10
4000ac08:	00010337          	lui	t1,0x10
4000ac0c:	010d9513          	slli	a0,s11,0x10
4000ac10:	fff30a13          	addi	s4,t1,-1 # ffff <_heap_size+0xdfff>
4000ac14:	01556ab3          	or	s5,a0,s5
4000ac18:	014af833          	and	a6,s5,s4
4000ac1c:	0144fa33          	and	s4,s1,s4
4000ac20:	00080513          	mv	a0,a6
4000ac24:	000a0593          	mv	a1,s4
4000ac28:	40e78db3          	sub	s11,a5,a4
4000ac2c:	00612e23          	sw	t1,28(sp)
4000ac30:	01012c23          	sw	a6,24(sp)
4000ac34:	010ad413          	srli	s0,s5,0x10
4000ac38:	278020ef          	jal	ra,4000ceb0 <__mulsi3>
4000ac3c:	00a12a23          	sw	a0,20(sp)
4000ac40:	000a0593          	mv	a1,s4
4000ac44:	00040513          	mv	a0,s0
4000ac48:	268020ef          	jal	ra,4000ceb0 <__mulsi3>
4000ac4c:	0104db13          	srli	s6,s1,0x10
4000ac50:	00a12823          	sw	a0,16(sp)
4000ac54:	000b0593          	mv	a1,s6
4000ac58:	00040513          	mv	a0,s0
4000ac5c:	254020ef          	jal	ra,4000ceb0 <__mulsi3>
4000ac60:	01812803          	lw	a6,24(sp)
4000ac64:	00a12623          	sw	a0,12(sp)
4000ac68:	000b0513          	mv	a0,s6
4000ac6c:	00080593          	mv	a1,a6
4000ac70:	240020ef          	jal	ra,4000ceb0 <__mulsi3>
4000ac74:	01012603          	lw	a2,16(sp)
4000ac78:	01412683          	lw	a3,20(sp)
4000ac7c:	00c12883          	lw	a7,12(sp)
4000ac80:	00c50533          	add	a0,a0,a2
4000ac84:	0106d793          	srli	a5,a3,0x10
4000ac88:	00a78533          	add	a0,a5,a0
4000ac8c:	00c57663          	bleu	a2,a0,4000ac98 <__divdf3+0x524>
4000ac90:	01c12303          	lw	t1,28(sp)
4000ac94:	006888b3          	add	a7,a7,t1
4000ac98:	000107b7          	lui	a5,0x10
4000ac9c:	fff78793          	addi	a5,a5,-1 # ffff <_heap_size+0xdfff>
4000aca0:	01055713          	srli	a4,a0,0x10
4000aca4:	00f57433          	and	s0,a0,a5
4000aca8:	01041413          	slli	s0,s0,0x10
4000acac:	00f6f6b3          	and	a3,a3,a5
4000acb0:	01170733          	add	a4,a4,a7
4000acb4:	00d40433          	add	s0,s0,a3
4000acb8:	1cedec63          	bltu	s11,a4,4000ae90 <__divdf3+0x71c>
4000acbc:	40ed87b3          	sub	a5,s11,a4
4000acc0:	1ced8463          	beq	s11,a4,4000ae88 <__divdf3+0x714>
4000acc4:	40890433          	sub	s0,s2,s0
4000acc8:	00893933          	sltu	s2,s2,s0
4000accc:	41278933          	sub	s2,a5,s2
4000acd0:	252d0663          	beq	s10,s2,4000af1c <__divdf3+0x7a8>
4000acd4:	00098593          	mv	a1,s3
4000acd8:	00090513          	mv	a0,s2
4000acdc:	200020ef          	jal	ra,4000cedc <__udivsi3>
4000ace0:	00050593          	mv	a1,a0
4000ace4:	00a12623          	sw	a0,12(sp)
4000ace8:	000c8513          	mv	a0,s9
4000acec:	1c4020ef          	jal	ra,4000ceb0 <__mulsi3>
4000acf0:	00050d93          	mv	s11,a0
4000acf4:	00098593          	mv	a1,s3
4000acf8:	00090513          	mv	a0,s2
4000acfc:	228020ef          	jal	ra,4000cf24 <__umodsi3>
4000ad00:	01051513          	slli	a0,a0,0x10
4000ad04:	01045793          	srli	a5,s0,0x10
4000ad08:	00a7e533          	or	a0,a5,a0
4000ad0c:	00c12703          	lw	a4,12(sp)
4000ad10:	01b57e63          	bleu	s11,a0,4000ad2c <__divdf3+0x5b8>
4000ad14:	01a50533          	add	a0,a0,s10
4000ad18:	fff70793          	addi	a5,a4,-1
4000ad1c:	2ba56463          	bltu	a0,s10,4000afc4 <__divdf3+0x850>
4000ad20:	2bb57263          	bleu	s11,a0,4000afc4 <__divdf3+0x850>
4000ad24:	ffe70713          	addi	a4,a4,-2
4000ad28:	01a50533          	add	a0,a0,s10
4000ad2c:	41b50db3          	sub	s11,a0,s11
4000ad30:	00098593          	mv	a1,s3
4000ad34:	000d8513          	mv	a0,s11
4000ad38:	00e12823          	sw	a4,16(sp)
4000ad3c:	1a0020ef          	jal	ra,4000cedc <__udivsi3>
4000ad40:	00050593          	mv	a1,a0
4000ad44:	00050913          	mv	s2,a0
4000ad48:	000c8513          	mv	a0,s9
4000ad4c:	164020ef          	jal	ra,4000ceb0 <__mulsi3>
4000ad50:	00a12623          	sw	a0,12(sp)
4000ad54:	00098593          	mv	a1,s3
4000ad58:	000d8513          	mv	a0,s11
4000ad5c:	1c8020ef          	jal	ra,4000cf24 <__umodsi3>
4000ad60:	01041793          	slli	a5,s0,0x10
4000ad64:	00c12683          	lw	a3,12(sp)
4000ad68:	01051513          	slli	a0,a0,0x10
4000ad6c:	0107d793          	srli	a5,a5,0x10
4000ad70:	00a7e7b3          	or	a5,a5,a0
4000ad74:	01012703          	lw	a4,16(sp)
4000ad78:	00d7fe63          	bleu	a3,a5,4000ad94 <__divdf3+0x620>
4000ad7c:	01a787b3          	add	a5,a5,s10
4000ad80:	fff90613          	addi	a2,s2,-1
4000ad84:	23a7ec63          	bltu	a5,s10,4000afbc <__divdf3+0x848>
4000ad88:	22d7fa63          	bleu	a3,a5,4000afbc <__divdf3+0x848>
4000ad8c:	ffe90913          	addi	s2,s2,-2
4000ad90:	01a787b3          	add	a5,a5,s10
4000ad94:	01071713          	slli	a4,a4,0x10
4000ad98:	01276933          	or	s2,a4,s2
4000ad9c:	01091713          	slli	a4,s2,0x10
4000ada0:	01075713          	srli	a4,a4,0x10
4000ada4:	00070593          	mv	a1,a4
4000ada8:	000a0513          	mv	a0,s4
4000adac:	40d78433          	sub	s0,a5,a3
4000adb0:	00e12623          	sw	a4,12(sp)
4000adb4:	01095c93          	srli	s9,s2,0x10
4000adb8:	0f8020ef          	jal	ra,4000ceb0 <__mulsi3>
4000adbc:	000a0593          	mv	a1,s4
4000adc0:	00050993          	mv	s3,a0
4000adc4:	000c8513          	mv	a0,s9
4000adc8:	0e8020ef          	jal	ra,4000ceb0 <__mulsi3>
4000adcc:	00050d93          	mv	s11,a0
4000add0:	000c8593          	mv	a1,s9
4000add4:	000b0513          	mv	a0,s6
4000add8:	0d8020ef          	jal	ra,4000ceb0 <__mulsi3>
4000addc:	00c12703          	lw	a4,12(sp)
4000ade0:	00050a13          	mv	s4,a0
4000ade4:	000b0513          	mv	a0,s6
4000ade8:	00070593          	mv	a1,a4
4000adec:	0c4020ef          	jal	ra,4000ceb0 <__mulsi3>
4000adf0:	01b50533          	add	a0,a0,s11
4000adf4:	0109d793          	srli	a5,s3,0x10
4000adf8:	00a78533          	add	a0,a5,a0
4000adfc:	01b57663          	bleu	s11,a0,4000ae08 <__divdf3+0x694>
4000ae00:	000107b7          	lui	a5,0x10
4000ae04:	00fa0a33          	add	s4,s4,a5
4000ae08:	000106b7          	lui	a3,0x10
4000ae0c:	fff68693          	addi	a3,a3,-1 # ffff <_heap_size+0xdfff>
4000ae10:	01055713          	srli	a4,a0,0x10
4000ae14:	00d57533          	and	a0,a0,a3
4000ae18:	01051793          	slli	a5,a0,0x10
4000ae1c:	00d9f9b3          	and	s3,s3,a3
4000ae20:	01470733          	add	a4,a4,s4
4000ae24:	013787b3          	add	a5,a5,s3
4000ae28:	08e47a63          	bleu	a4,s0,4000aebc <__divdf3+0x748>
4000ae2c:	008d0433          	add	s0,s10,s0
4000ae30:	fff90693          	addi	a3,s2,-1
4000ae34:	19a47c63          	bleu	s10,s0,4000afcc <__divdf3+0x858>
4000ae38:	00068913          	mv	s2,a3
4000ae3c:	0ae40c63          	beq	s0,a4,4000aef4 <__divdf3+0x780>
4000ae40:	00196913          	ori	s2,s2,1
4000ae44:	3ffb8793          	addi	a5,s7,1023
4000ae48:	0ef05063          	blez	a5,4000af28 <__divdf3+0x7b4>
4000ae4c:	00797713          	andi	a4,s2,7
4000ae50:	14071263          	bnez	a4,4000af94 <__divdf3+0x820>
4000ae54:	007a9713          	slli	a4,s5,0x7
4000ae58:	00075a63          	bgez	a4,4000ae6c <__divdf3+0x6f8>
4000ae5c:	ff0007b7          	lui	a5,0xff000
4000ae60:	fff78793          	addi	a5,a5,-1 # feffffff <end+0xbefef21f>
4000ae64:	00fafab3          	and	s5,s5,a5
4000ae68:	400b8793          	addi	a5,s7,1024
4000ae6c:	7fe00713          	li	a4,2046
4000ae70:	08f75663          	ble	a5,a4,4000aefc <__divdf3+0x788>
4000ae74:	001c7713          	andi	a4,s8,1
4000ae78:	7ff00793          	li	a5,2047
4000ae7c:	00000513          	li	a0,0
4000ae80:	00000913          	li	s2,0
4000ae84:	a75ff06f          	j	4000a8f8 <__divdf3+0x184>
4000ae88:	00000793          	li	a5,0
4000ae8c:	e2897ce3          	bleu	s0,s2,4000acc4 <__divdf3+0x550>
4000ae90:	00990933          	add	s2,s2,s1
4000ae94:	009937b3          	sltu	a5,s2,s1
4000ae98:	01a787b3          	add	a5,a5,s10
4000ae9c:	01b787b3          	add	a5,a5,s11
4000aea0:	fffa8693          	addi	a3,s5,-1
4000aea4:	02fd7263          	bleu	a5,s10,4000aec8 <__divdf3+0x754>
4000aea8:	12e7ea63          	bltu	a5,a4,4000afdc <__divdf3+0x868>
4000aeac:	1cf70e63          	beq	a4,a5,4000b088 <__divdf3+0x914>
4000aeb0:	40e787b3          	sub	a5,a5,a4
4000aeb4:	00068a93          	mv	s5,a3
4000aeb8:	e0dff06f          	j	4000acc4 <__divdf3+0x550>
4000aebc:	f8e412e3          	bne	s0,a4,4000ae40 <__divdf3+0x6cc>
4000aec0:	f80782e3          	beqz	a5,4000ae44 <__divdf3+0x6d0>
4000aec4:	f69ff06f          	j	4000ae2c <__divdf3+0x6b8>
4000aec8:	fefd14e3          	bne	s10,a5,4000aeb0 <__divdf3+0x73c>
4000aecc:	fc997ee3          	bleu	s1,s2,4000aea8 <__divdf3+0x734>
4000aed0:	40ed07b3          	sub	a5,s10,a4
4000aed4:	00068a93          	mv	s5,a3
4000aed8:	dedff06f          	j	4000acc4 <__divdf3+0x550>
4000aedc:	00068a93          	mv	s5,a3
4000aee0:	d29ff06f          	j	4000ac08 <__divdf3+0x494>
4000aee4:	00078d93          	mv	s11,a5
4000aee8:	cc1ff06f          	j	4000aba8 <__divdf3+0x434>
4000aeec:	10f4e663          	bltu	s1,a5,4000aff8 <__divdf3+0x884>
4000aef0:	00068913          	mv	s2,a3
4000aef4:	f49796e3          	bne	a5,s1,4000ae40 <__divdf3+0x6cc>
4000aef8:	f4dff06f          	j	4000ae44 <__divdf3+0x6d0>
4000aefc:	00395713          	srli	a4,s2,0x3
4000af00:	009a9513          	slli	a0,s5,0x9
4000af04:	01da9913          	slli	s2,s5,0x1d
4000af08:	00e96933          	or	s2,s2,a4
4000af0c:	00c55513          	srli	a0,a0,0xc
4000af10:	7ff7f793          	andi	a5,a5,2047
4000af14:	001c7713          	andi	a4,s8,1
4000af18:	9e1ff06f          	j	4000a8f8 <__divdf3+0x184>
4000af1c:	3ffb8793          	addi	a5,s7,1023
4000af20:	fff00913          	li	s2,-1
4000af24:	06f04e63          	bgtz	a5,4000afa0 <__divdf3+0x82c>
4000af28:	00100413          	li	s0,1
4000af2c:	b40796e3          	bnez	a5,4000aa78 <__divdf3+0x304>
4000af30:	02000713          	li	a4,32
4000af34:	40870733          	sub	a4,a4,s0
4000af38:	00ea97b3          	sll	a5,s5,a4
4000af3c:	008956b3          	srl	a3,s2,s0
4000af40:	00e91733          	sll	a4,s2,a4
4000af44:	00e03733          	snez	a4,a4
4000af48:	00d7e7b3          	or	a5,a5,a3
4000af4c:	00e7e7b3          	or	a5,a5,a4
4000af50:	0077f713          	andi	a4,a5,7
4000af54:	008ad433          	srl	s0,s5,s0
4000af58:	02070063          	beqz	a4,4000af78 <__divdf3+0x804>
4000af5c:	00f7f713          	andi	a4,a5,15
4000af60:	00400693          	li	a3,4
4000af64:	00d70a63          	beq	a4,a3,4000af78 <__divdf3+0x804>
4000af68:	00478713          	addi	a4,a5,4
4000af6c:	00f737b3          	sltu	a5,a4,a5
4000af70:	00f40433          	add	s0,s0,a5
4000af74:	00070793          	mv	a5,a4
4000af78:	00841713          	slli	a4,s0,0x8
4000af7c:	0e075663          	bgez	a4,4000b068 <__divdf3+0x8f4>
4000af80:	001c7713          	andi	a4,s8,1
4000af84:	00100793          	li	a5,1
4000af88:	00000513          	li	a0,0
4000af8c:	00000913          	li	s2,0
4000af90:	969ff06f          	j	4000a8f8 <__divdf3+0x184>
4000af94:	00f97713          	andi	a4,s2,15
4000af98:	00400693          	li	a3,4
4000af9c:	ead70ce3          	beq	a4,a3,4000ae54 <__divdf3+0x6e0>
4000afa0:	00490693          	addi	a3,s2,4
4000afa4:	0126b733          	sltu	a4,a3,s2
4000afa8:	00ea8ab3          	add	s5,s5,a4
4000afac:	00068913          	mv	s2,a3
4000afb0:	ea5ff06f          	j	4000ae54 <__divdf3+0x6e0>
4000afb4:	000b0c13          	mv	s8,s6
4000afb8:	e8dff06f          	j	4000ae44 <__divdf3+0x6d0>
4000afbc:	00060913          	mv	s2,a2
4000afc0:	dd5ff06f          	j	4000ad94 <__divdf3+0x620>
4000afc4:	00078713          	mv	a4,a5
4000afc8:	d65ff06f          	j	4000ad2c <__divdf3+0x5b8>
4000afcc:	02e46663          	bltu	s0,a4,4000aff8 <__divdf3+0x884>
4000afd0:	f0870ee3          	beq	a4,s0,4000aeec <__divdf3+0x778>
4000afd4:	00068913          	mv	s2,a3
4000afd8:	e69ff06f          	j	4000ae40 <__divdf3+0x6cc>
4000afdc:	00990933          	add	s2,s2,s1
4000afe0:	009936b3          	sltu	a3,s2,s1
4000afe4:	01a686b3          	add	a3,a3,s10
4000afe8:	00f687b3          	add	a5,a3,a5
4000afec:	ffea8a93          	addi	s5,s5,-2
4000aff0:	40e787b3          	sub	a5,a5,a4
4000aff4:	cd1ff06f          	j	4000acc4 <__divdf3+0x550>
4000aff8:	00149613          	slli	a2,s1,0x1
4000affc:	009636b3          	sltu	a3,a2,s1
4000b000:	01a68d33          	add	s10,a3,s10
4000b004:	01a40433          	add	s0,s0,s10
4000b008:	ffe90693          	addi	a3,s2,-2
4000b00c:	00060493          	mv	s1,a2
4000b010:	e29ff06f          	j	4000ae38 <__divdf3+0x6c4>
4000b014:	01f00713          	li	a4,31
4000b018:	f0875ce3          	ble	s0,a4,4000af30 <__divdf3+0x7bc>
4000b01c:	fe100713          	li	a4,-31
4000b020:	40f707b3          	sub	a5,a4,a5
4000b024:	02000693          	li	a3,32
4000b028:	00fad7b3          	srl	a5,s5,a5
4000b02c:	00000713          	li	a4,0
4000b030:	00d40863          	beq	s0,a3,4000b040 <__divdf3+0x8cc>
4000b034:	04000713          	li	a4,64
4000b038:	40870433          	sub	s0,a4,s0
4000b03c:	008a9733          	sll	a4,s5,s0
4000b040:	01276733          	or	a4,a4,s2
4000b044:	00e03733          	snez	a4,a4
4000b048:	00e7e7b3          	or	a5,a5,a4
4000b04c:	0077f713          	andi	a4,a5,7
4000b050:	00000513          	li	a0,0
4000b054:	02070063          	beqz	a4,4000b074 <__divdf3+0x900>
4000b058:	00f7f713          	andi	a4,a5,15
4000b05c:	00400693          	li	a3,4
4000b060:	00000413          	li	s0,0
4000b064:	f0d712e3          	bne	a4,a3,4000af68 <__divdf3+0x7f4>
4000b068:	00941513          	slli	a0,s0,0x9
4000b06c:	01d41713          	slli	a4,s0,0x1d
4000b070:	00c55513          	srli	a0,a0,0xc
4000b074:	0037d793          	srli	a5,a5,0x3
4000b078:	00e7e933          	or	s2,a5,a4
4000b07c:	001c7713          	andi	a4,s8,1
4000b080:	00000793          	li	a5,0
4000b084:	875ff06f          	j	4000a8f8 <__divdf3+0x184>
4000b088:	f4896ae3          	bltu	s2,s0,4000afdc <__divdf3+0x868>
4000b08c:	00068a93          	mv	s5,a3
4000b090:	00000793          	li	a5,0
4000b094:	c31ff06f          	j	4000acc4 <__divdf3+0x550>
4000b098:	000b0713          	mv	a4,s6
4000b09c:	7ff00793          	li	a5,2047
4000b0a0:	00000513          	li	a0,0
4000b0a4:	00000913          	li	s2,0
4000b0a8:	851ff06f          	j	4000a8f8 <__divdf3+0x184>
4000b0ac:	000807b7          	lui	a5,0x80
4000b0b0:	00fae533          	or	a0,s5,a5
4000b0b4:	001007b7          	lui	a5,0x100
4000b0b8:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b0bc:	00f57533          	and	a0,a0,a5
4000b0c0:	000b0713          	mv	a4,s6
4000b0c4:	7ff00793          	li	a5,2047
4000b0c8:	831ff06f          	j	4000a8f8 <__divdf3+0x184>

4000b0cc <__eqdf2>:
4000b0cc:	0145d713          	srli	a4,a1,0x14
4000b0d0:	001007b7          	lui	a5,0x100
4000b0d4:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b0d8:	0146d813          	srli	a6,a3,0x14
4000b0dc:	7ff00893          	li	a7,2047
4000b0e0:	7ff77713          	andi	a4,a4,2047
4000b0e4:	00b7fe33          	and	t3,a5,a1
4000b0e8:	00050313          	mv	t1,a0
4000b0ec:	00d7f7b3          	and	a5,a5,a3
4000b0f0:	00050e93          	mv	t4,a0
4000b0f4:	01f5d593          	srli	a1,a1,0x1f
4000b0f8:	00060f13          	mv	t5,a2
4000b0fc:	01187833          	and	a6,a6,a7
4000b100:	01f6d693          	srli	a3,a3,0x1f
4000b104:	01170a63          	beq	a4,a7,4000b118 <__eqdf2+0x4c>
4000b108:	00100513          	li	a0,1
4000b10c:	01180463          	beq	a6,a7,4000b114 <__eqdf2+0x48>
4000b110:	03070063          	beq	a4,a6,4000b130 <__eqdf2+0x64>
4000b114:	00008067          	ret
4000b118:	00ae68b3          	or	a7,t3,a0
4000b11c:	00100513          	li	a0,1
4000b120:	fe089ae3          	bnez	a7,4000b114 <__eqdf2+0x48>
4000b124:	fee818e3          	bne	a6,a4,4000b114 <__eqdf2+0x48>
4000b128:	00c7e633          	or	a2,a5,a2
4000b12c:	fe0614e3          	bnez	a2,4000b114 <__eqdf2+0x48>
4000b130:	00100513          	li	a0,1
4000b134:	fefe10e3          	bne	t3,a5,4000b114 <__eqdf2+0x48>
4000b138:	fdee9ee3          	bne	t4,t5,4000b114 <__eqdf2+0x48>
4000b13c:	00000513          	li	a0,0
4000b140:	fcd58ae3          	beq	a1,a3,4000b114 <__eqdf2+0x48>
4000b144:	00100513          	li	a0,1
4000b148:	fc0716e3          	bnez	a4,4000b114 <__eqdf2+0x48>
4000b14c:	006e6533          	or	a0,t3,t1
4000b150:	00a03533          	snez	a0,a0
4000b154:	00008067          	ret

4000b158 <__gedf2>:
4000b158:	0145d713          	srli	a4,a1,0x14
4000b15c:	001007b7          	lui	a5,0x100
4000b160:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b164:	00050893          	mv	a7,a0
4000b168:	0146d813          	srli	a6,a3,0x14
4000b16c:	7ff00513          	li	a0,2047
4000b170:	7ff77713          	andi	a4,a4,2047
4000b174:	00b7f333          	and	t1,a5,a1
4000b178:	00088e93          	mv	t4,a7
4000b17c:	00d7f7b3          	and	a5,a5,a3
4000b180:	01f5d593          	srli	a1,a1,0x1f
4000b184:	00060f13          	mv	t5,a2
4000b188:	00a87833          	and	a6,a6,a0
4000b18c:	01f6d693          	srli	a3,a3,0x1f
4000b190:	06a70a63          	beq	a4,a0,4000b204 <__gedf2+0xac>
4000b194:	7ff00513          	li	a0,2047
4000b198:	04a80463          	beq	a6,a0,4000b1e0 <__gedf2+0x88>
4000b19c:	02071263          	bnez	a4,4000b1c0 <__gedf2+0x68>
4000b1a0:	011368b3          	or	a7,t1,a7
4000b1a4:	0018be13          	seqz	t3,a7
4000b1a8:	04081663          	bnez	a6,4000b1f4 <__gedf2+0x9c>
4000b1ac:	00c7e633          	or	a2,a5,a2
4000b1b0:	04061263          	bnez	a2,4000b1f4 <__gedf2+0x9c>
4000b1b4:	00000513          	li	a0,0
4000b1b8:	00089c63          	bnez	a7,4000b1d0 <__gedf2+0x78>
4000b1bc:	00008067          	ret
4000b1c0:	00081663          	bnez	a6,4000b1cc <__gedf2+0x74>
4000b1c4:	00c7e633          	or	a2,a5,a2
4000b1c8:	00060463          	beqz	a2,4000b1d0 <__gedf2+0x78>
4000b1cc:	04d58463          	beq	a1,a3,4000b214 <__gedf2+0xbc>
4000b1d0:	00b035b3          	snez	a1,a1
4000b1d4:	40b005b3          	neg	a1,a1
4000b1d8:	0015e513          	ori	a0,a1,1
4000b1dc:	00008067          	ret
4000b1e0:	00c7ee33          	or	t3,a5,a2
4000b1e4:	ffe00513          	li	a0,-2
4000b1e8:	fc0e1ae3          	bnez	t3,4000b1bc <__gedf2+0x64>
4000b1ec:	fc071ae3          	bnez	a4,4000b1c0 <__gedf2+0x68>
4000b1f0:	fb1ff06f          	j	4000b1a0 <__gedf2+0x48>
4000b1f4:	fff68513          	addi	a0,a3,-1
4000b1f8:	00156513          	ori	a0,a0,1
4000b1fc:	fc0e08e3          	beqz	t3,4000b1cc <__gedf2+0x74>
4000b200:	00008067          	ret
4000b204:	01136e33          	or	t3,t1,a7
4000b208:	ffe00513          	li	a0,-2
4000b20c:	f80e04e3          	beqz	t3,4000b194 <__gedf2+0x3c>
4000b210:	00008067          	ret
4000b214:	02e84063          	blt	a6,a4,4000b234 <__gedf2+0xdc>
4000b218:	01074863          	blt	a4,a6,4000b228 <__gedf2+0xd0>
4000b21c:	0067ec63          	bltu	a5,t1,4000b234 <__gedf2+0xdc>
4000b220:	02f30663          	beq	t1,a5,4000b24c <__gedf2+0xf4>
4000b224:	02f37063          	bleu	a5,t1,4000b244 <__gedf2+0xec>
4000b228:	fff58593          	addi	a1,a1,-1 # 7fffff <_heap_size+0x7fdfff>
4000b22c:	0015e513          	ori	a0,a1,1
4000b230:	00008067          	ret
4000b234:	00b035b3          	snez	a1,a1
4000b238:	40b007b3          	neg	a5,a1
4000b23c:	0017e513          	ori	a0,a5,1
4000b240:	00008067          	ret
4000b244:	00000513          	li	a0,0
4000b248:	00008067          	ret
4000b24c:	ffdf64e3          	bltu	t5,t4,4000b234 <__gedf2+0xdc>
4000b250:	00000513          	li	a0,0
4000b254:	fdeeeae3          	bltu	t4,t5,4000b228 <__gedf2+0xd0>
4000b258:	f65ff06f          	j	4000b1bc <__gedf2+0x64>

4000b25c <__ledf2>:
4000b25c:	0145d713          	srli	a4,a1,0x14
4000b260:	001007b7          	lui	a5,0x100
4000b264:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b268:	00050893          	mv	a7,a0
4000b26c:	0146d813          	srli	a6,a3,0x14
4000b270:	7ff00513          	li	a0,2047
4000b274:	7ff77713          	andi	a4,a4,2047
4000b278:	00b7f333          	and	t1,a5,a1
4000b27c:	00088e93          	mv	t4,a7
4000b280:	00d7f7b3          	and	a5,a5,a3
4000b284:	01f5d593          	srli	a1,a1,0x1f
4000b288:	00060f13          	mv	t5,a2
4000b28c:	00a87833          	and	a6,a6,a0
4000b290:	01f6d693          	srli	a3,a3,0x1f
4000b294:	06a70463          	beq	a4,a0,4000b2fc <__ledf2+0xa0>
4000b298:	7ff00513          	li	a0,2047
4000b29c:	04a80063          	beq	a6,a0,4000b2dc <__ledf2+0x80>
4000b2a0:	02071263          	bnez	a4,4000b2c4 <__ledf2+0x68>
4000b2a4:	011368b3          	or	a7,t1,a7
4000b2a8:	0018be13          	seqz	t3,a7
4000b2ac:	04081063          	bnez	a6,4000b2ec <__ledf2+0x90>
4000b2b0:	00c7e633          	or	a2,a5,a2
4000b2b4:	02061c63          	bnez	a2,4000b2ec <__ledf2+0x90>
4000b2b8:	00000513          	li	a0,0
4000b2bc:	00089863          	bnez	a7,4000b2cc <__ledf2+0x70>
4000b2c0:	00008067          	ret
4000b2c4:	04080463          	beqz	a6,4000b30c <__ledf2+0xb0>
4000b2c8:	04d58863          	beq	a1,a3,4000b318 <__ledf2+0xbc>
4000b2cc:	00b035b3          	snez	a1,a1
4000b2d0:	40b005b3          	neg	a1,a1
4000b2d4:	0015e513          	ori	a0,a1,1
4000b2d8:	00008067          	ret
4000b2dc:	00c7ee33          	or	t3,a5,a2
4000b2e0:	00200513          	li	a0,2
4000b2e4:	fa0e0ee3          	beqz	t3,4000b2a0 <__ledf2+0x44>
4000b2e8:	00008067          	ret
4000b2ec:	fff68513          	addi	a0,a3,-1
4000b2f0:	00156513          	ori	a0,a0,1
4000b2f4:	fc0e0ae3          	beqz	t3,4000b2c8 <__ledf2+0x6c>
4000b2f8:	00008067          	ret
4000b2fc:	01136e33          	or	t3,t1,a7
4000b300:	00200513          	li	a0,2
4000b304:	f80e0ae3          	beqz	t3,4000b298 <__ledf2+0x3c>
4000b308:	00008067          	ret
4000b30c:	00c7e633          	or	a2,a5,a2
4000b310:	fa061ce3          	bnez	a2,4000b2c8 <__ledf2+0x6c>
4000b314:	fb9ff06f          	j	4000b2cc <__ledf2+0x70>
4000b318:	02e84063          	blt	a6,a4,4000b338 <__ledf2+0xdc>
4000b31c:	01074863          	blt	a4,a6,4000b32c <__ledf2+0xd0>
4000b320:	0067ec63          	bltu	a5,t1,4000b338 <__ledf2+0xdc>
4000b324:	02f30663          	beq	t1,a5,4000b350 <__ledf2+0xf4>
4000b328:	02f37063          	bleu	a5,t1,4000b348 <__ledf2+0xec>
4000b32c:	fff58593          	addi	a1,a1,-1
4000b330:	0015e513          	ori	a0,a1,1
4000b334:	00008067          	ret
4000b338:	00b035b3          	snez	a1,a1
4000b33c:	40b007b3          	neg	a5,a1
4000b340:	0017e513          	ori	a0,a5,1
4000b344:	00008067          	ret
4000b348:	00000513          	li	a0,0
4000b34c:	00008067          	ret
4000b350:	ffdf64e3          	bltu	t5,t4,4000b338 <__ledf2+0xdc>
4000b354:	00000513          	li	a0,0
4000b358:	fdeeeae3          	bltu	t4,t5,4000b32c <__ledf2+0xd0>
4000b35c:	f65ff06f          	j	4000b2c0 <__ledf2+0x64>

4000b360 <__muldf3>:
4000b360:	fa010113          	addi	sp,sp,-96
4000b364:	04812c23          	sw	s0,88(sp)
4000b368:	0145d813          	srli	a6,a1,0x14
4000b36c:	00100437          	lui	s0,0x100
4000b370:	05212823          	sw	s2,80(sp)
4000b374:	05512223          	sw	s5,68(sp)
4000b378:	03712e23          	sw	s7,60(sp)
4000b37c:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
4000b380:	04112e23          	sw	ra,92(sp)
4000b384:	04912a23          	sw	s1,84(sp)
4000b388:	05312623          	sw	s3,76(sp)
4000b38c:	05412423          	sw	s4,72(sp)
4000b390:	05612023          	sw	s6,64(sp)
4000b394:	03812c23          	sw	s8,56(sp)
4000b398:	03912a23          	sw	s9,52(sp)
4000b39c:	03a12823          	sw	s10,48(sp)
4000b3a0:	03b12623          	sw	s11,44(sp)
4000b3a4:	7ff87813          	andi	a6,a6,2047
4000b3a8:	00050913          	mv	s2,a0
4000b3ac:	00060b93          	mv	s7,a2
4000b3b0:	00b47433          	and	s0,s0,a1
4000b3b4:	01f5da93          	srli	s5,a1,0x1f
4000b3b8:	1c080e63          	beqz	a6,4000b594 <__muldf3+0x234>
4000b3bc:	7ff00793          	li	a5,2047
4000b3c0:	08f80e63          	beq	a6,a5,4000b45c <__muldf3+0xfc>
4000b3c4:	01d55793          	srli	a5,a0,0x1d
4000b3c8:	00800737          	lui	a4,0x800
4000b3cc:	00341413          	slli	s0,s0,0x3
4000b3d0:	00e7e7b3          	or	a5,a5,a4
4000b3d4:	0087e433          	or	s0,a5,s0
4000b3d8:	00351b13          	slli	s6,a0,0x3
4000b3dc:	c0180993          	addi	s3,a6,-1023
4000b3e0:	00000913          	li	s2,0
4000b3e4:	00000c13          	li	s8,0
4000b3e8:	0146d513          	srli	a0,a3,0x14
4000b3ec:	001004b7          	lui	s1,0x100
4000b3f0:	fff48493          	addi	s1,s1,-1 # fffff <_heap_size+0xfdfff>
4000b3f4:	7ff57513          	andi	a0,a0,2047
4000b3f8:	00d4f4b3          	and	s1,s1,a3
4000b3fc:	01f6da13          	srli	s4,a3,0x1f
4000b400:	08050863          	beqz	a0,4000b490 <__muldf3+0x130>
4000b404:	7ff00793          	li	a5,2047
4000b408:	1ef50263          	beq	a0,a5,4000b5ec <__muldf3+0x28c>
4000b40c:	01dbd793          	srli	a5,s7,0x1d
4000b410:	00800737          	lui	a4,0x800
4000b414:	00349493          	slli	s1,s1,0x3
4000b418:	00e7e7b3          	or	a5,a5,a4
4000b41c:	0097e4b3          	or	s1,a5,s1
4000b420:	003b9693          	slli	a3,s7,0x3
4000b424:	c0150513          	addi	a0,a0,-1023
4000b428:	00000593          	li	a1,0
4000b42c:	00a98833          	add	a6,s3,a0
4000b430:	0125e7b3          	or	a5,a1,s2
4000b434:	00f00713          	li	a4,15
4000b438:	014acbb3          	xor	s7,s5,s4
4000b43c:	00180613          	addi	a2,a6,1
4000b440:	22f76663          	bltu	a4,a5,4000b66c <__muldf3+0x30c>
4000b444:	4000e737          	lui	a4,0x4000e
4000b448:	00279793          	slli	a5,a5,0x2
4000b44c:	af470713          	addi	a4,a4,-1292 # 4000daf4 <zeroes.4082+0xd0>
4000b450:	00e787b3          	add	a5,a5,a4
4000b454:	0007a783          	lw	a5,0(a5)
4000b458:	00078067          	jr	a5
4000b45c:	00a46b33          	or	s6,s0,a0
4000b460:	1a0b1a63          	bnez	s6,4000b614 <__muldf3+0x2b4>
4000b464:	0146d513          	srli	a0,a3,0x14
4000b468:	001004b7          	lui	s1,0x100
4000b46c:	fff48493          	addi	s1,s1,-1 # fffff <_heap_size+0xfdfff>
4000b470:	7ff57513          	andi	a0,a0,2047
4000b474:	00000413          	li	s0,0
4000b478:	00800913          	li	s2,8
4000b47c:	00080993          	mv	s3,a6
4000b480:	00200c13          	li	s8,2
4000b484:	00d4f4b3          	and	s1,s1,a3
4000b488:	01f6da13          	srli	s4,a3,0x1f
4000b48c:	f6051ce3          	bnez	a0,4000b404 <__muldf3+0xa4>
4000b490:	0174e6b3          	or	a3,s1,s7
4000b494:	18068a63          	beqz	a3,4000b628 <__muldf3+0x2c8>
4000b498:	56048863          	beqz	s1,4000ba08 <__muldf3+0x6a8>
4000b49c:	00048513          	mv	a0,s1
4000b4a0:	2e9010ef          	jal	ra,4000cf88 <__clzsi2>
4000b4a4:	ff550713          	addi	a4,a0,-11
4000b4a8:	01c00793          	li	a5,28
4000b4ac:	54e7c663          	blt	a5,a4,4000b9f8 <__muldf3+0x698>
4000b4b0:	01d00793          	li	a5,29
4000b4b4:	ff850693          	addi	a3,a0,-8
4000b4b8:	40e787b3          	sub	a5,a5,a4
4000b4bc:	00d494b3          	sll	s1,s1,a3
4000b4c0:	00fbd7b3          	srl	a5,s7,a5
4000b4c4:	0097e4b3          	or	s1,a5,s1
4000b4c8:	00db96b3          	sll	a3,s7,a3
4000b4cc:	c0d00793          	li	a5,-1011
4000b4d0:	40a78533          	sub	a0,a5,a0
4000b4d4:	00000593          	li	a1,0
4000b4d8:	f55ff06f          	j	4000b42c <__muldf3+0xcc>
4000b4dc:	000a0b93          	mv	s7,s4
4000b4e0:	00200793          	li	a5,2
4000b4e4:	10f58e63          	beq	a1,a5,4000b600 <__muldf3+0x2a0>
4000b4e8:	00300793          	li	a5,3
4000b4ec:	64f58e63          	beq	a1,a5,4000bb48 <__muldf3+0x7e8>
4000b4f0:	00100793          	li	a5,1
4000b4f4:	5af59863          	bne	a1,a5,4000baa4 <__muldf3+0x744>
4000b4f8:	00fbfab3          	and	s5,s7,a5
4000b4fc:	00000593          	li	a1,0
4000b500:	00000413          	li	s0,0
4000b504:	00000b13          	li	s6,0
4000b508:	001007b7          	lui	a5,0x100
4000b50c:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b510:	00f47433          	and	s0,s0,a5
4000b514:	01459793          	slli	a5,a1,0x14
4000b518:	801005b7          	lui	a1,0x80100
4000b51c:	fff58593          	addi	a1,a1,-1 # 800fffff <end+0x400ef21f>
4000b520:	00b475b3          	and	a1,s0,a1
4000b524:	05c12083          	lw	ra,92(sp)
4000b528:	80000437          	lui	s0,0x80000
4000b52c:	fff44413          	not	s0,s0
4000b530:	00f5e5b3          	or	a1,a1,a5
4000b534:	01fa9713          	slli	a4,s5,0x1f
4000b538:	0085f5b3          	and	a1,a1,s0
4000b53c:	000b0513          	mv	a0,s6
4000b540:	00e5e5b3          	or	a1,a1,a4
4000b544:	05812403          	lw	s0,88(sp)
4000b548:	05412483          	lw	s1,84(sp)
4000b54c:	05012903          	lw	s2,80(sp)
4000b550:	04c12983          	lw	s3,76(sp)
4000b554:	04812a03          	lw	s4,72(sp)
4000b558:	04412a83          	lw	s5,68(sp)
4000b55c:	04012b03          	lw	s6,64(sp)
4000b560:	03c12b83          	lw	s7,60(sp)
4000b564:	03812c03          	lw	s8,56(sp)
4000b568:	03412c83          	lw	s9,52(sp)
4000b56c:	03012d03          	lw	s10,48(sp)
4000b570:	02c12d83          	lw	s11,44(sp)
4000b574:	06010113          	addi	sp,sp,96
4000b578:	00008067          	ret
4000b57c:	00100437          	lui	s0,0x100
4000b580:	00000a93          	li	s5,0
4000b584:	fff40413          	addi	s0,s0,-1 # fffff <_heap_size+0xfdfff>
4000b588:	fff00b13          	li	s6,-1
4000b58c:	7ff00593          	li	a1,2047
4000b590:	f79ff06f          	j	4000b508 <__muldf3+0x1a8>
4000b594:	00a46b33          	or	s6,s0,a0
4000b598:	0a0b0663          	beqz	s6,4000b644 <__muldf3+0x2e4>
4000b59c:	00d12623          	sw	a3,12(sp)
4000b5a0:	48040463          	beqz	s0,4000ba28 <__muldf3+0x6c8>
4000b5a4:	00040513          	mv	a0,s0
4000b5a8:	1e1010ef          	jal	ra,4000cf88 <__clzsi2>
4000b5ac:	00c12683          	lw	a3,12(sp)
4000b5b0:	ff550793          	addi	a5,a0,-11
4000b5b4:	01c00713          	li	a4,28
4000b5b8:	46f74063          	blt	a4,a5,4000ba18 <__muldf3+0x6b8>
4000b5bc:	01d00713          	li	a4,29
4000b5c0:	ff850493          	addi	s1,a0,-8
4000b5c4:	40f70733          	sub	a4,a4,a5
4000b5c8:	00941433          	sll	s0,s0,s1
4000b5cc:	00e95733          	srl	a4,s2,a4
4000b5d0:	00876433          	or	s0,a4,s0
4000b5d4:	00991b33          	sll	s6,s2,s1
4000b5d8:	c0d00813          	li	a6,-1011
4000b5dc:	40a809b3          	sub	s3,a6,a0
4000b5e0:	00000913          	li	s2,0
4000b5e4:	00000c13          	li	s8,0
4000b5e8:	e01ff06f          	j	4000b3e8 <__muldf3+0x88>
4000b5ec:	0174e6b3          	or	a3,s1,s7
4000b5f0:	04069463          	bnez	a3,4000b638 <__muldf3+0x2d8>
4000b5f4:	00000493          	li	s1,0
4000b5f8:	00200593          	li	a1,2
4000b5fc:	e31ff06f          	j	4000b42c <__muldf3+0xcc>
4000b600:	001bfa93          	andi	s5,s7,1
4000b604:	7ff00593          	li	a1,2047
4000b608:	00000413          	li	s0,0
4000b60c:	00000b13          	li	s6,0
4000b610:	ef9ff06f          	j	4000b508 <__muldf3+0x1a8>
4000b614:	00050b13          	mv	s6,a0
4000b618:	00c00913          	li	s2,12
4000b61c:	00080993          	mv	s3,a6
4000b620:	00300c13          	li	s8,3
4000b624:	dc5ff06f          	j	4000b3e8 <__muldf3+0x88>
4000b628:	00000493          	li	s1,0
4000b62c:	00000513          	li	a0,0
4000b630:	00100593          	li	a1,1
4000b634:	df9ff06f          	j	4000b42c <__muldf3+0xcc>
4000b638:	000b8693          	mv	a3,s7
4000b63c:	00300593          	li	a1,3
4000b640:	dedff06f          	j	4000b42c <__muldf3+0xcc>
4000b644:	00000413          	li	s0,0
4000b648:	00400913          	li	s2,4
4000b64c:	00000993          	li	s3,0
4000b650:	00100c13          	li	s8,1
4000b654:	d95ff06f          	j	4000b3e8 <__muldf3+0x88>
4000b658:	00040493          	mv	s1,s0
4000b65c:	000b0693          	mv	a3,s6
4000b660:	000a8b93          	mv	s7,s5
4000b664:	000c0593          	mv	a1,s8
4000b668:	e79ff06f          	j	4000b4e0 <__muldf3+0x180>
4000b66c:	00010db7          	lui	s11,0x10
4000b670:	fffd8c93          	addi	s9,s11,-1 # ffff <_heap_size+0xdfff>
4000b674:	019b7933          	and	s2,s6,s9
4000b678:	0196fcb3          	and	s9,a3,s9
4000b67c:	000c8593          	mv	a1,s9
4000b680:	00090513          	mv	a0,s2
4000b684:	0106da13          	srli	s4,a3,0x10
4000b688:	00c12823          	sw	a2,16(sp)
4000b68c:	01012623          	sw	a6,12(sp)
4000b690:	010b5b13          	srli	s6,s6,0x10
4000b694:	01d010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b698:	00050993          	mv	s3,a0
4000b69c:	000c8593          	mv	a1,s9
4000b6a0:	000b0513          	mv	a0,s6
4000b6a4:	00d010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b6a8:	00050d13          	mv	s10,a0
4000b6ac:	000a0593          	mv	a1,s4
4000b6b0:	000b0513          	mv	a0,s6
4000b6b4:	7fc010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b6b8:	00050a93          	mv	s5,a0
4000b6bc:	00090593          	mv	a1,s2
4000b6c0:	000a0513          	mv	a0,s4
4000b6c4:	7ec010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b6c8:	01a50533          	add	a0,a0,s10
4000b6cc:	0109dc13          	srli	s8,s3,0x10
4000b6d0:	00ac0c33          	add	s8,s8,a0
4000b6d4:	00c12803          	lw	a6,12(sp)
4000b6d8:	01012603          	lw	a2,16(sp)
4000b6dc:	01ac7463          	bleu	s10,s8,4000b6e4 <__muldf3+0x384>
4000b6e0:	01ba8ab3          	add	s5,s5,s11
4000b6e4:	000106b7          	lui	a3,0x10
4000b6e8:	fff68793          	addi	a5,a3,-1 # ffff <_heap_size+0xdfff>
4000b6ec:	00f4fdb3          	and	s11,s1,a5
4000b6f0:	000d8593          	mv	a1,s11
4000b6f4:	00090513          	mv	a0,s2
4000b6f8:	00fc7d33          	and	s10,s8,a5
4000b6fc:	00f9f9b3          	and	s3,s3,a5
4000b700:	00c12c23          	sw	a2,24(sp)
4000b704:	01012a23          	sw	a6,20(sp)
4000b708:	00d12e23          	sw	a3,28(sp)
4000b70c:	7a4010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b710:	00a12823          	sw	a0,16(sp)
4000b714:	000d8593          	mv	a1,s11
4000b718:	000b0513          	mv	a0,s6
4000b71c:	794010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b720:	0104d493          	srli	s1,s1,0x10
4000b724:	010d1d13          	slli	s10,s10,0x10
4000b728:	00048593          	mv	a1,s1
4000b72c:	013d0d33          	add	s10,s10,s3
4000b730:	00050993          	mv	s3,a0
4000b734:	000b0513          	mv	a0,s6
4000b738:	778010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b73c:	00a12623          	sw	a0,12(sp)
4000b740:	00090593          	mv	a1,s2
4000b744:	00048513          	mv	a0,s1
4000b748:	768010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b74c:	01012703          	lw	a4,16(sp)
4000b750:	01350533          	add	a0,a0,s3
4000b754:	010c5c13          	srli	s8,s8,0x10
4000b758:	01075793          	srli	a5,a4,0x10
4000b75c:	00a78533          	add	a0,a5,a0
4000b760:	00c12883          	lw	a7,12(sp)
4000b764:	01412803          	lw	a6,20(sp)
4000b768:	01812603          	lw	a2,24(sp)
4000b76c:	01357663          	bleu	s3,a0,4000b778 <__muldf3+0x418>
4000b770:	01c12683          	lw	a3,28(sp)
4000b774:	00d888b3          	add	a7,a7,a3
4000b778:	000106b7          	lui	a3,0x10
4000b77c:	fff68793          	addi	a5,a3,-1 # ffff <_heap_size+0xdfff>
4000b780:	00f479b3          	and	s3,s0,a5
4000b784:	00f57b33          	and	s6,a0,a5
4000b788:	00f77733          	and	a4,a4,a5
4000b78c:	000c8593          	mv	a1,s9
4000b790:	01055913          	srli	s2,a0,0x10
4000b794:	010b1b13          	slli	s6,s6,0x10
4000b798:	00098513          	mv	a0,s3
4000b79c:	00eb0b33          	add	s6,s6,a4
4000b7a0:	00c12c23          	sw	a2,24(sp)
4000b7a4:	01012a23          	sw	a6,20(sp)
4000b7a8:	01190933          	add	s2,s2,a7
4000b7ac:	00d12e23          	sw	a3,28(sp)
4000b7b0:	01045413          	srli	s0,s0,0x10
4000b7b4:	6fc010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b7b8:	000c8593          	mv	a1,s9
4000b7bc:	00a12823          	sw	a0,16(sp)
4000b7c0:	00040513          	mv	a0,s0
4000b7c4:	6ec010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b7c8:	00a12623          	sw	a0,12(sp)
4000b7cc:	00040593          	mv	a1,s0
4000b7d0:	000a0513          	mv	a0,s4
4000b7d4:	6dc010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b7d8:	00050c93          	mv	s9,a0
4000b7dc:	00098593          	mv	a1,s3
4000b7e0:	000a0513          	mv	a0,s4
4000b7e4:	6cc010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b7e8:	00c12303          	lw	t1,12(sp)
4000b7ec:	01012703          	lw	a4,16(sp)
4000b7f0:	016c08b3          	add	a7,s8,s6
4000b7f4:	00650533          	add	a0,a0,t1
4000b7f8:	01075793          	srli	a5,a4,0x10
4000b7fc:	00a78533          	add	a0,a5,a0
4000b800:	01412803          	lw	a6,20(sp)
4000b804:	01812603          	lw	a2,24(sp)
4000b808:	00657663          	bleu	t1,a0,4000b814 <__muldf3+0x4b4>
4000b80c:	01c12683          	lw	a3,28(sp)
4000b810:	00dc8cb3          	add	s9,s9,a3
4000b814:	000106b7          	lui	a3,0x10
4000b818:	fff68593          	addi	a1,a3,-1 # ffff <_heap_size+0xdfff>
4000b81c:	00b57a33          	and	s4,a0,a1
4000b820:	01055793          	srli	a5,a0,0x10
4000b824:	00b77733          	and	a4,a4,a1
4000b828:	010a1a13          	slli	s4,s4,0x10
4000b82c:	000d8593          	mv	a1,s11
4000b830:	00098513          	mv	a0,s3
4000b834:	01978c33          	add	s8,a5,s9
4000b838:	01112c23          	sw	a7,24(sp)
4000b83c:	00c12a23          	sw	a2,20(sp)
4000b840:	01012823          	sw	a6,16(sp)
4000b844:	00ea0a33          	add	s4,s4,a4
4000b848:	00d12e23          	sw	a3,28(sp)
4000b84c:	664010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b850:	000d8593          	mv	a1,s11
4000b854:	00a12623          	sw	a0,12(sp)
4000b858:	00040513          	mv	a0,s0
4000b85c:	654010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b860:	00050d93          	mv	s11,a0
4000b864:	00040593          	mv	a1,s0
4000b868:	00048513          	mv	a0,s1
4000b86c:	644010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b870:	00050c93          	mv	s9,a0
4000b874:	00098593          	mv	a1,s3
4000b878:	00048513          	mv	a0,s1
4000b87c:	634010ef          	jal	ra,4000ceb0 <__mulsi3>
4000b880:	00c12703          	lw	a4,12(sp)
4000b884:	01b50533          	add	a0,a0,s11
4000b888:	01012803          	lw	a6,16(sp)
4000b88c:	01075793          	srli	a5,a4,0x10
4000b890:	00a787b3          	add	a5,a5,a0
4000b894:	01412603          	lw	a2,20(sp)
4000b898:	01812883          	lw	a7,24(sp)
4000b89c:	01b7f663          	bleu	s11,a5,4000b8a8 <__muldf3+0x548>
4000b8a0:	01c12683          	lw	a3,28(sp)
4000b8a4:	00dc8cb3          	add	s9,s9,a3
4000b8a8:	000106b7          	lui	a3,0x10
4000b8ac:	fff68693          	addi	a3,a3,-1 # ffff <_heap_size+0xdfff>
4000b8b0:	00d7f433          	and	s0,a5,a3
4000b8b4:	00d77733          	and	a4,a4,a3
4000b8b8:	01041413          	slli	s0,s0,0x10
4000b8bc:	011a8ab3          	add	s5,s5,a7
4000b8c0:	00e40433          	add	s0,s0,a4
4000b8c4:	016abb33          	sltu	s6,s5,s6
4000b8c8:	01240433          	add	s0,s0,s2
4000b8cc:	015a0ab3          	add	s5,s4,s5
4000b8d0:	008b05b3          	add	a1,s6,s0
4000b8d4:	014aba33          	sltu	s4,s5,s4
4000b8d8:	00bc06b3          	add	a3,s8,a1
4000b8dc:	00da0733          	add	a4,s4,a3
4000b8e0:	01243933          	sltu	s2,s0,s2
4000b8e4:	0165b433          	sltu	s0,a1,s6
4000b8e8:	0107d793          	srli	a5,a5,0x10
4000b8ec:	0186bc33          	sltu	s8,a3,s8
4000b8f0:	01473a33          	sltu	s4,a4,s4
4000b8f4:	00896433          	or	s0,s2,s0
4000b8f8:	00f40433          	add	s0,s0,a5
4000b8fc:	014c6a33          	or	s4,s8,s4
4000b900:	01440433          	add	s0,s0,s4
4000b904:	009a9693          	slli	a3,s5,0x9
4000b908:	01940433          	add	s0,s0,s9
4000b90c:	01775493          	srli	s1,a4,0x17
4000b910:	01a6e6b3          	or	a3,a3,s10
4000b914:	00941413          	slli	s0,s0,0x9
4000b918:	00d036b3          	snez	a3,a3
4000b91c:	017ada93          	srli	s5,s5,0x17
4000b920:	009464b3          	or	s1,s0,s1
4000b924:	0156e6b3          	or	a3,a3,s5
4000b928:	00971713          	slli	a4,a4,0x9
4000b92c:	00749793          	slli	a5,s1,0x7
4000b930:	00e6e6b3          	or	a3,a3,a4
4000b934:	0207d063          	bgez	a5,4000b954 <__muldf3+0x5f4>
4000b938:	0016d793          	srli	a5,a3,0x1
4000b93c:	0016f693          	andi	a3,a3,1
4000b940:	01f49713          	slli	a4,s1,0x1f
4000b944:	00d7e6b3          	or	a3,a5,a3
4000b948:	00e6e6b3          	or	a3,a3,a4
4000b94c:	0014d493          	srli	s1,s1,0x1
4000b950:	00060813          	mv	a6,a2
4000b954:	3ff80593          	addi	a1,a6,1023
4000b958:	0eb05063          	blez	a1,4000ba38 <__muldf3+0x6d8>
4000b95c:	0076f793          	andi	a5,a3,7
4000b960:	02078063          	beqz	a5,4000b980 <__muldf3+0x620>
4000b964:	00f6f793          	andi	a5,a3,15
4000b968:	00400713          	li	a4,4
4000b96c:	00e78a63          	beq	a5,a4,4000b980 <__muldf3+0x620>
4000b970:	00e687b3          	add	a5,a3,a4
4000b974:	00d7b6b3          	sltu	a3,a5,a3
4000b978:	00d484b3          	add	s1,s1,a3
4000b97c:	00078693          	mv	a3,a5
4000b980:	00749793          	slli	a5,s1,0x7
4000b984:	0007da63          	bgez	a5,4000b998 <__muldf3+0x638>
4000b988:	ff0007b7          	lui	a5,0xff000
4000b98c:	fff78793          	addi	a5,a5,-1 # feffffff <end+0xbefef21f>
4000b990:	00f4f4b3          	and	s1,s1,a5
4000b994:	40080593          	addi	a1,a6,1024
4000b998:	7fe00793          	li	a5,2046
4000b99c:	c6b7c2e3          	blt	a5,a1,4000b600 <__muldf3+0x2a0>
4000b9a0:	0036d693          	srli	a3,a3,0x3
4000b9a4:	01d49793          	slli	a5,s1,0x1d
4000b9a8:	00949413          	slli	s0,s1,0x9
4000b9ac:	00d7eb33          	or	s6,a5,a3
4000b9b0:	00c45413          	srli	s0,s0,0xc
4000b9b4:	7ff5f593          	andi	a1,a1,2047
4000b9b8:	001bfa93          	andi	s5,s7,1
4000b9bc:	b4dff06f          	j	4000b508 <__muldf3+0x1a8>
4000b9c0:	00040493          	mv	s1,s0
4000b9c4:	000b0693          	mv	a3,s6
4000b9c8:	000c0593          	mv	a1,s8
4000b9cc:	b15ff06f          	j	4000b4e0 <__muldf3+0x180>
4000b9d0:	009464b3          	or	s1,s0,s1
4000b9d4:	00c49793          	slli	a5,s1,0xc
4000b9d8:	ba07c2e3          	bltz	a5,4000b57c <__muldf3+0x21c>
4000b9dc:	000807b7          	lui	a5,0x80
4000b9e0:	00f46433          	or	s0,s0,a5
4000b9e4:	001007b7          	lui	a5,0x100
4000b9e8:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000b9ec:	00f47433          	and	s0,s0,a5
4000b9f0:	7ff00593          	li	a1,2047
4000b9f4:	b15ff06f          	j	4000b508 <__muldf3+0x1a8>
4000b9f8:	fd850493          	addi	s1,a0,-40
4000b9fc:	009b94b3          	sll	s1,s7,s1
4000ba00:	00000693          	li	a3,0
4000ba04:	ac9ff06f          	j	4000b4cc <__muldf3+0x16c>
4000ba08:	000b8513          	mv	a0,s7
4000ba0c:	57c010ef          	jal	ra,4000cf88 <__clzsi2>
4000ba10:	02050513          	addi	a0,a0,32
4000ba14:	a91ff06f          	j	4000b4a4 <__muldf3+0x144>
4000ba18:	fd850413          	addi	s0,a0,-40
4000ba1c:	00891433          	sll	s0,s2,s0
4000ba20:	00000b13          	li	s6,0
4000ba24:	bb5ff06f          	j	4000b5d8 <__muldf3+0x278>
4000ba28:	560010ef          	jal	ra,4000cf88 <__clzsi2>
4000ba2c:	02050513          	addi	a0,a0,32
4000ba30:	00c12683          	lw	a3,12(sp)
4000ba34:	b7dff06f          	j	4000b5b0 <__muldf3+0x250>
4000ba38:	00100713          	li	a4,1
4000ba3c:	06059863          	bnez	a1,4000baac <__muldf3+0x74c>
4000ba40:	02000793          	li	a5,32
4000ba44:	40e787b3          	sub	a5,a5,a4
4000ba48:	00f49633          	sll	a2,s1,a5
4000ba4c:	00e6d5b3          	srl	a1,a3,a4
4000ba50:	00f697b3          	sll	a5,a3,a5
4000ba54:	00f037b3          	snez	a5,a5
4000ba58:	00b666b3          	or	a3,a2,a1
4000ba5c:	00f6e6b3          	or	a3,a3,a5
4000ba60:	0076f793          	andi	a5,a3,7
4000ba64:	00e4d4b3          	srl	s1,s1,a4
4000ba68:	02078063          	beqz	a5,4000ba88 <__muldf3+0x728>
4000ba6c:	00f6f793          	andi	a5,a3,15
4000ba70:	00400713          	li	a4,4
4000ba74:	00e78a63          	beq	a5,a4,4000ba88 <__muldf3+0x728>
4000ba78:	00068793          	mv	a5,a3
4000ba7c:	00478693          	addi	a3,a5,4
4000ba80:	00f6b7b3          	sltu	a5,a3,a5
4000ba84:	00f484b3          	add	s1,s1,a5
4000ba88:	00849793          	slli	a5,s1,0x8
4000ba8c:	0807dc63          	bgez	a5,4000bb24 <__muldf3+0x7c4>
4000ba90:	001bfa93          	andi	s5,s7,1
4000ba94:	00100593          	li	a1,1
4000ba98:	00000413          	li	s0,0
4000ba9c:	00000b13          	li	s6,0
4000baa0:	a69ff06f          	j	4000b508 <__muldf3+0x1a8>
4000baa4:	00060813          	mv	a6,a2
4000baa8:	eadff06f          	j	4000b954 <__muldf3+0x5f4>
4000baac:	40b70733          	sub	a4,a4,a1
4000bab0:	03800793          	li	a5,56
4000bab4:	00e7dc63          	ble	a4,a5,4000bacc <__muldf3+0x76c>
4000bab8:	001bfa93          	andi	s5,s7,1
4000babc:	00000593          	li	a1,0
4000bac0:	00000413          	li	s0,0
4000bac4:	00000b13          	li	s6,0
4000bac8:	a41ff06f          	j	4000b508 <__muldf3+0x1a8>
4000bacc:	01f00793          	li	a5,31
4000bad0:	f6e7d8e3          	ble	a4,a5,4000ba40 <__muldf3+0x6e0>
4000bad4:	fe100793          	li	a5,-31
4000bad8:	40b787b3          	sub	a5,a5,a1
4000badc:	02000593          	li	a1,32
4000bae0:	00f4d7b3          	srl	a5,s1,a5
4000bae4:	00000613          	li	a2,0
4000bae8:	00b70863          	beq	a4,a1,4000baf8 <__muldf3+0x798>
4000baec:	04000613          	li	a2,64
4000baf0:	40e60733          	sub	a4,a2,a4
4000baf4:	00e49633          	sll	a2,s1,a4
4000baf8:	00d66733          	or	a4,a2,a3
4000bafc:	00e03733          	snez	a4,a4
4000bb00:	00e7e7b3          	or	a5,a5,a4
4000bb04:	0077f493          	andi	s1,a5,7
4000bb08:	00000413          	li	s0,0
4000bb0c:	02048463          	beqz	s1,4000bb34 <__muldf3+0x7d4>
4000bb10:	00f7f713          	andi	a4,a5,15
4000bb14:	00400693          	li	a3,4
4000bb18:	00000493          	li	s1,0
4000bb1c:	f6d710e3          	bne	a4,a3,4000ba7c <__muldf3+0x71c>
4000bb20:	00078693          	mv	a3,a5
4000bb24:	00949413          	slli	s0,s1,0x9
4000bb28:	00c45413          	srli	s0,s0,0xc
4000bb2c:	01d49493          	slli	s1,s1,0x1d
4000bb30:	00068793          	mv	a5,a3
4000bb34:	0037d793          	srli	a5,a5,0x3
4000bb38:	0097eb33          	or	s6,a5,s1
4000bb3c:	001bfa93          	andi	s5,s7,1
4000bb40:	00000593          	li	a1,0
4000bb44:	9c5ff06f          	j	4000b508 <__muldf3+0x1a8>
4000bb48:	000807b7          	lui	a5,0x80
4000bb4c:	00f4e433          	or	s0,s1,a5
4000bb50:	001007b7          	lui	a5,0x100
4000bb54:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000bb58:	00f47433          	and	s0,s0,a5
4000bb5c:	001bfa93          	andi	s5,s7,1
4000bb60:	00068b13          	mv	s6,a3
4000bb64:	7ff00593          	li	a1,2047
4000bb68:	9a1ff06f          	j	4000b508 <__muldf3+0x1a8>

4000bb6c <__subdf3>:
4000bb6c:	00100737          	lui	a4,0x100
4000bb70:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000bb74:	fe010113          	addi	sp,sp,-32
4000bb78:	00b777b3          	and	a5,a4,a1
4000bb7c:	00d778b3          	and	a7,a4,a3
4000bb80:	0146de13          	srli	t3,a3,0x14
4000bb84:	00379313          	slli	t1,a5,0x3
4000bb88:	01d65e93          	srli	t4,a2,0x1d
4000bb8c:	00912a23          	sw	s1,20(sp)
4000bb90:	01212823          	sw	s2,16(sp)
4000bb94:	0145d713          	srli	a4,a1,0x14
4000bb98:	01f5d813          	srli	a6,a1,0x1f
4000bb9c:	01d55793          	srli	a5,a0,0x1d
4000bba0:	00389893          	slli	a7,a7,0x3
4000bba4:	7ff00f13          	li	t5,2047
4000bba8:	00112e23          	sw	ra,28(sp)
4000bbac:	00812c23          	sw	s0,24(sp)
4000bbb0:	01312623          	sw	s3,12(sp)
4000bbb4:	7ffe7e13          	andi	t3,t3,2047
4000bbb8:	0067e7b3          	or	a5,a5,t1
4000bbbc:	01e774b3          	and	s1,a4,t5
4000bbc0:	00080913          	mv	s2,a6
4000bbc4:	00351313          	slli	t1,a0,0x3
4000bbc8:	01f6d693          	srli	a3,a3,0x1f
4000bbcc:	011ee8b3          	or	a7,t4,a7
4000bbd0:	00361613          	slli	a2,a2,0x3
4000bbd4:	0bee0a63          	beq	t3,t5,4000bc88 <__subdf3+0x11c>
4000bbd8:	0016c693          	xori	a3,a3,1
4000bbdc:	11068263          	beq	a3,a6,4000bce0 <__subdf3+0x174>
4000bbe0:	41c48eb3          	sub	t4,s1,t3
4000bbe4:	31d05663          	blez	t4,4000bef0 <__subdf3+0x384>
4000bbe8:	0a0e1863          	bnez	t3,4000bc98 <__subdf3+0x12c>
4000bbec:	00c8e733          	or	a4,a7,a2
4000bbf0:	10071a63          	bnez	a4,4000bd04 <__subdf3+0x198>
4000bbf4:	7ff00713          	li	a4,2047
4000bbf8:	000e8493          	mv	s1,t4
4000bbfc:	3eee8063          	beq	t4,a4,4000bfdc <__subdf3+0x470>
4000bc00:	00879713          	slli	a4,a5,0x8
4000bc04:	1c075863          	bgez	a4,4000bdd4 <__subdf3+0x268>
4000bc08:	00148713          	addi	a4,s1,1
4000bc0c:	7ff00693          	li	a3,2047
4000bc10:	36d70463          	beq	a4,a3,4000bf78 <__subdf3+0x40c>
4000bc14:	ff8006b7          	lui	a3,0xff800
4000bc18:	fff68693          	addi	a3,a3,-1 # ff7fffff <end+0xbf7ef21f>
4000bc1c:	00d7f7b3          	and	a5,a5,a3
4000bc20:	01d79693          	slli	a3,a5,0x1d
4000bc24:	00335313          	srli	t1,t1,0x3
4000bc28:	00979793          	slli	a5,a5,0x9
4000bc2c:	0066e533          	or	a0,a3,t1
4000bc30:	00c7d793          	srli	a5,a5,0xc
4000bc34:	7ff77713          	andi	a4,a4,2047
4000bc38:	001005b7          	lui	a1,0x100
4000bc3c:	fff58593          	addi	a1,a1,-1 # fffff <_heap_size+0xfdfff>
4000bc40:	00b7f7b3          	and	a5,a5,a1
4000bc44:	801005b7          	lui	a1,0x80100
4000bc48:	fff58593          	addi	a1,a1,-1 # 800fffff <end+0x400ef21f>
4000bc4c:	00b7f5b3          	and	a1,a5,a1
4000bc50:	01471713          	slli	a4,a4,0x14
4000bc54:	800007b7          	lui	a5,0x80000
4000bc58:	01c12083          	lw	ra,28(sp)
4000bc5c:	00e5e5b3          	or	a1,a1,a4
4000bc60:	fff7c793          	not	a5,a5
4000bc64:	01f81813          	slli	a6,a6,0x1f
4000bc68:	00f5f5b3          	and	a1,a1,a5
4000bc6c:	0105e5b3          	or	a1,a1,a6
4000bc70:	01812403          	lw	s0,24(sp)
4000bc74:	01412483          	lw	s1,20(sp)
4000bc78:	01012903          	lw	s2,16(sp)
4000bc7c:	00c12983          	lw	s3,12(sp)
4000bc80:	02010113          	addi	sp,sp,32
4000bc84:	00008067          	ret
4000bc88:	00c8e733          	or	a4,a7,a2
4000bc8c:	f40718e3          	bnez	a4,4000bbdc <__subdf3+0x70>
4000bc90:	0016c693          	xori	a3,a3,1
4000bc94:	f49ff06f          	j	4000bbdc <__subdf3+0x70>
4000bc98:	008006b7          	lui	a3,0x800
4000bc9c:	7ff00713          	li	a4,2047
4000bca0:	00d8e8b3          	or	a7,a7,a3
4000bca4:	22e48263          	beq	s1,a4,4000bec8 <__subdf3+0x35c>
4000bca8:	03800713          	li	a4,56
4000bcac:	17d74263          	blt	a4,t4,4000be10 <__subdf3+0x2a4>
4000bcb0:	01f00713          	li	a4,31
4000bcb4:	37d74863          	blt	a4,t4,4000c024 <__subdf3+0x4b8>
4000bcb8:	02000713          	li	a4,32
4000bcbc:	41d70733          	sub	a4,a4,t4
4000bcc0:	01d656b3          	srl	a3,a2,t4
4000bcc4:	00e899b3          	sll	s3,a7,a4
4000bcc8:	00e61633          	sll	a2,a2,a4
4000bccc:	00d9e9b3          	or	s3,s3,a3
4000bcd0:	00c036b3          	snez	a3,a2
4000bcd4:	00d9e6b3          	or	a3,s3,a3
4000bcd8:	01d8deb3          	srl	t4,a7,t4
4000bcdc:	1400006f          	j	4000be1c <__subdf3+0x2b0>
4000bce0:	41c48733          	sub	a4,s1,t3
4000bce4:	2ae05063          	blez	a4,4000bf84 <__subdf3+0x418>
4000bce8:	160e1663          	bnez	t3,4000be54 <__subdf3+0x2e8>
4000bcec:	00c8e6b3          	or	a3,a7,a2
4000bcf0:	3e069263          	bnez	a3,4000c0d4 <__subdf3+0x568>
4000bcf4:	7ff00693          	li	a3,2047
4000bcf8:	4ad70e63          	beq	a4,a3,4000c1b4 <__subdf3+0x648>
4000bcfc:	00070493          	mv	s1,a4
4000bd00:	f01ff06f          	j	4000bc00 <__subdf3+0x94>
4000bd04:	fffe8713          	addi	a4,t4,-1
4000bd08:	2c071263          	bnez	a4,4000bfcc <__subdf3+0x460>
4000bd0c:	40c309b3          	sub	s3,t1,a2
4000bd10:	411787b3          	sub	a5,a5,a7
4000bd14:	01333333          	sltu	t1,t1,s3
4000bd18:	406787b3          	sub	a5,a5,t1
4000bd1c:	00100493          	li	s1,1
4000bd20:	00879713          	slli	a4,a5,0x8
4000bd24:	10075863          	bgez	a4,4000be34 <__subdf3+0x2c8>
4000bd28:	00800637          	lui	a2,0x800
4000bd2c:	fff60613          	addi	a2,a2,-1 # 7fffff <_heap_size+0x7fdfff>
4000bd30:	00c7f433          	and	s0,a5,a2
4000bd34:	20040063          	beqz	s0,4000bf34 <__subdf3+0x3c8>
4000bd38:	00040513          	mv	a0,s0
4000bd3c:	24c010ef          	jal	ra,4000cf88 <__clzsi2>
4000bd40:	ff850713          	addi	a4,a0,-8
4000bd44:	01f00793          	li	a5,31
4000bd48:	20e7c263          	blt	a5,a4,4000bf4c <__subdf3+0x3e0>
4000bd4c:	02000793          	li	a5,32
4000bd50:	40e787b3          	sub	a5,a5,a4
4000bd54:	00f9d7b3          	srl	a5,s3,a5
4000bd58:	00e41633          	sll	a2,s0,a4
4000bd5c:	00c7e7b3          	or	a5,a5,a2
4000bd60:	00e999b3          	sll	s3,s3,a4
4000bd64:	1e974c63          	blt	a4,s1,4000bf5c <__subdf3+0x3f0>
4000bd68:	40970733          	sub	a4,a4,s1
4000bd6c:	00170613          	addi	a2,a4,1
4000bd70:	01f00693          	li	a3,31
4000bd74:	26c6cc63          	blt	a3,a2,4000bfec <__subdf3+0x480>
4000bd78:	02000713          	li	a4,32
4000bd7c:	40c70733          	sub	a4,a4,a2
4000bd80:	00e996b3          	sll	a3,s3,a4
4000bd84:	00c9d5b3          	srl	a1,s3,a2
4000bd88:	00e79733          	sll	a4,a5,a4
4000bd8c:	00b76733          	or	a4,a4,a1
4000bd90:	00d036b3          	snez	a3,a3
4000bd94:	00d769b3          	or	s3,a4,a3
4000bd98:	00c7d7b3          	srl	a5,a5,a2
4000bd9c:	0079f713          	andi	a4,s3,7
4000bda0:	00197813          	andi	a6,s2,1
4000bda4:	00000493          	li	s1,0
4000bda8:	00098313          	mv	t1,s3
4000bdac:	e4070ae3          	beqz	a4,4000bc00 <__subdf3+0x94>
4000bdb0:	00f9f713          	andi	a4,s3,15
4000bdb4:	00400693          	li	a3,4
4000bdb8:	00098313          	mv	t1,s3
4000bdbc:	e4d702e3          	beq	a4,a3,4000bc00 <__subdf3+0x94>
4000bdc0:	00d98333          	add	t1,s3,a3
4000bdc4:	013336b3          	sltu	a3,t1,s3
4000bdc8:	00d787b3          	add	a5,a5,a3
4000bdcc:	00879713          	slli	a4,a5,0x8
4000bdd0:	e2074ce3          	bltz	a4,4000bc08 <__subdf3+0x9c>
4000bdd4:	00335693          	srli	a3,t1,0x3
4000bdd8:	7ff00713          	li	a4,2047
4000bddc:	01d79313          	slli	t1,a5,0x1d
4000bde0:	0066e533          	or	a0,a3,t1
4000bde4:	0037d793          	srli	a5,a5,0x3
4000bde8:	0ee49a63          	bne	s1,a4,4000bedc <__subdf3+0x370>
4000bdec:	00f56733          	or	a4,a0,a5
4000bdf0:	5a070e63          	beqz	a4,4000c3ac <__subdf3+0x840>
4000bdf4:	00080737          	lui	a4,0x80
4000bdf8:	00e7e7b3          	or	a5,a5,a4
4000bdfc:	00100737          	lui	a4,0x100
4000be00:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000be04:	00e7f7b3          	and	a5,a5,a4
4000be08:	00048713          	mv	a4,s1
4000be0c:	e2dff06f          	j	4000bc38 <__subdf3+0xcc>
4000be10:	00c8e633          	or	a2,a7,a2
4000be14:	00c036b3          	snez	a3,a2
4000be18:	00000e93          	li	t4,0
4000be1c:	40d309b3          	sub	s3,t1,a3
4000be20:	41d787b3          	sub	a5,a5,t4
4000be24:	01333333          	sltu	t1,t1,s3
4000be28:	406787b3          	sub	a5,a5,t1
4000be2c:	00879713          	slli	a4,a5,0x8
4000be30:	ee074ce3          	bltz	a4,4000bd28 <__subdf3+0x1bc>
4000be34:	0079f713          	andi	a4,s3,7
4000be38:	00197813          	andi	a6,s2,1
4000be3c:	f6071ae3          	bnez	a4,4000bdb0 <__subdf3+0x244>
4000be40:	01d79313          	slli	t1,a5,0x1d
4000be44:	0039d693          	srli	a3,s3,0x3
4000be48:	0066e533          	or	a0,a3,t1
4000be4c:	0037d793          	srli	a5,a5,0x3
4000be50:	0840006f          	j	4000bed4 <__subdf3+0x368>
4000be54:	008005b7          	lui	a1,0x800
4000be58:	7ff00693          	li	a3,2047
4000be5c:	00b8e8b3          	or	a7,a7,a1
4000be60:	06d48463          	beq	s1,a3,4000bec8 <__subdf3+0x35c>
4000be64:	03800693          	li	a3,56
4000be68:	28e6dc63          	ble	a4,a3,4000c100 <__subdf3+0x594>
4000be6c:	00c8e633          	or	a2,a7,a2
4000be70:	00c036b3          	snez	a3,a2
4000be74:	00000893          	li	a7,0
4000be78:	006689b3          	add	s3,a3,t1
4000be7c:	00f887b3          	add	a5,a7,a5
4000be80:	0069b333          	sltu	t1,s3,t1
4000be84:	006787b3          	add	a5,a5,t1
4000be88:	00879713          	slli	a4,a5,0x8
4000be8c:	fa0754e3          	bgez	a4,4000be34 <__subdf3+0x2c8>
4000be90:	00148493          	addi	s1,s1,1
4000be94:	7ff00713          	li	a4,2047
4000be98:	3ce48463          	beq	s1,a4,4000c260 <__subdf3+0x6f4>
4000be9c:	ff800737          	lui	a4,0xff800
4000bea0:	fff70713          	addi	a4,a4,-1 # ff7fffff <end+0xbf7ef21f>
4000bea4:	00e7f7b3          	and	a5,a5,a4
4000bea8:	0019f693          	andi	a3,s3,1
4000beac:	0019d713          	srli	a4,s3,0x1
4000beb0:	00d766b3          	or	a3,a4,a3
4000beb4:	01f79993          	slli	s3,a5,0x1f
4000beb8:	00d9e9b3          	or	s3,s3,a3
4000bebc:	0017d793          	srli	a5,a5,0x1
4000bec0:	0079f713          	andi	a4,s3,7
4000bec4:	ee5ff06f          	j	4000bda8 <__subdf3+0x23c>
4000bec8:	0067e533          	or	a0,a5,t1
4000becc:	d2051ae3          	bnez	a0,4000bc00 <__subdf3+0x94>
4000bed0:	00000793          	li	a5,0
4000bed4:	7ff00713          	li	a4,2047
4000bed8:	f0e48ae3          	beq	s1,a4,4000bdec <__subdf3+0x280>
4000bedc:	00100737          	lui	a4,0x100
4000bee0:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000bee4:	00e7f7b3          	and	a5,a5,a4
4000bee8:	7ff4f713          	andi	a4,s1,2047
4000beec:	d4dff06f          	j	4000bc38 <__subdf3+0xcc>
4000bef0:	160e9263          	bnez	t4,4000c054 <__subdf3+0x4e8>
4000bef4:	00148713          	addi	a4,s1,1
4000bef8:	7ff77713          	andi	a4,a4,2047
4000befc:	00100593          	li	a1,1
4000bf00:	2ce5d463          	ble	a4,a1,4000c1c8 <__subdf3+0x65c>
4000bf04:	40c309b3          	sub	s3,t1,a2
4000bf08:	01333733          	sltu	a4,t1,s3
4000bf0c:	41178433          	sub	s0,a5,a7
4000bf10:	40e40433          	sub	s0,s0,a4
4000bf14:	00841713          	slli	a4,s0,0x8
4000bf18:	1a075263          	bgez	a4,4000c0bc <__subdf3+0x550>
4000bf1c:	406609b3          	sub	s3,a2,t1
4000bf20:	40f887b3          	sub	a5,a7,a5
4000bf24:	01363633          	sltu	a2,a2,s3
4000bf28:	40c78433          	sub	s0,a5,a2
4000bf2c:	00068913          	mv	s2,a3
4000bf30:	e00414e3          	bnez	s0,4000bd38 <__subdf3+0x1cc>
4000bf34:	00098513          	mv	a0,s3
4000bf38:	050010ef          	jal	ra,4000cf88 <__clzsi2>
4000bf3c:	02050513          	addi	a0,a0,32
4000bf40:	ff850713          	addi	a4,a0,-8
4000bf44:	01f00793          	li	a5,31
4000bf48:	e0e7d2e3          	ble	a4,a5,4000bd4c <__subdf3+0x1e0>
4000bf4c:	fd850793          	addi	a5,a0,-40
4000bf50:	00f997b3          	sll	a5,s3,a5
4000bf54:	00000993          	li	s3,0
4000bf58:	e09758e3          	ble	s1,a4,4000bd68 <__subdf3+0x1fc>
4000bf5c:	40e484b3          	sub	s1,s1,a4
4000bf60:	ff800737          	lui	a4,0xff800
4000bf64:	fff70713          	addi	a4,a4,-1 # ff7fffff <end+0xbf7ef21f>
4000bf68:	00e7f7b3          	and	a5,a5,a4
4000bf6c:	00197813          	andi	a6,s2,1
4000bf70:	0079f713          	andi	a4,s3,7
4000bf74:	e35ff06f          	j	4000bda8 <__subdf3+0x23c>
4000bf78:	00000793          	li	a5,0
4000bf7c:	00000513          	li	a0,0
4000bf80:	cb9ff06f          	j	4000bc38 <__subdf3+0xcc>
4000bf84:	28071c63          	bnez	a4,4000c21c <__subdf3+0x6b0>
4000bf88:	00148593          	addi	a1,s1,1
4000bf8c:	7ff5f713          	andi	a4,a1,2047
4000bf90:	00100693          	li	a3,1
4000bf94:	1ce6de63          	ble	a4,a3,4000c170 <__subdf3+0x604>
4000bf98:	7ff00713          	li	a4,2047
4000bf9c:	32e58263          	beq	a1,a4,4000c2c0 <__subdf3+0x754>
4000bfa0:	00c30633          	add	a2,t1,a2
4000bfa4:	00663333          	sltu	t1,a2,t1
4000bfa8:	011787b3          	add	a5,a5,a7
4000bfac:	006787b3          	add	a5,a5,t1
4000bfb0:	01f79693          	slli	a3,a5,0x1f
4000bfb4:	00165613          	srli	a2,a2,0x1
4000bfb8:	00c6e9b3          	or	s3,a3,a2
4000bfbc:	0017d793          	srli	a5,a5,0x1
4000bfc0:	0079f713          	andi	a4,s3,7
4000bfc4:	00058493          	mv	s1,a1
4000bfc8:	de1ff06f          	j	4000bda8 <__subdf3+0x23c>
4000bfcc:	7ff00693          	li	a3,2047
4000bfd0:	00de8663          	beq	t4,a3,4000bfdc <__subdf3+0x470>
4000bfd4:	00070e93          	mv	t4,a4
4000bfd8:	cd1ff06f          	j	4000bca8 <__subdf3+0x13c>
4000bfdc:	0067e533          	or	a0,a5,t1
4000bfe0:	14050863          	beqz	a0,4000c130 <__subdf3+0x5c4>
4000bfe4:	7ff00493          	li	s1,2047
4000bfe8:	c19ff06f          	j	4000bc00 <__subdf3+0x94>
4000bfec:	fe170713          	addi	a4,a4,-31
4000bff0:	02000593          	li	a1,32
4000bff4:	00e7d733          	srl	a4,a5,a4
4000bff8:	00000693          	li	a3,0
4000bffc:	00b60863          	beq	a2,a1,4000c00c <__subdf3+0x4a0>
4000c000:	04000693          	li	a3,64
4000c004:	40c686b3          	sub	a3,a3,a2
4000c008:	00d796b3          	sll	a3,a5,a3
4000c00c:	00d9e6b3          	or	a3,s3,a3
4000c010:	00d036b3          	snez	a3,a3
4000c014:	00d769b3          	or	s3,a4,a3
4000c018:	00000793          	li	a5,0
4000c01c:	00000493          	li	s1,0
4000c020:	e15ff06f          	j	4000be34 <__subdf3+0x2c8>
4000c024:	02000693          	li	a3,32
4000c028:	01d8d9b3          	srl	s3,a7,t4
4000c02c:	00000713          	li	a4,0
4000c030:	00de8863          	beq	t4,a3,4000c040 <__subdf3+0x4d4>
4000c034:	04000713          	li	a4,64
4000c038:	41d70eb3          	sub	t4,a4,t4
4000c03c:	01d89733          	sll	a4,a7,t4
4000c040:	00c76633          	or	a2,a4,a2
4000c044:	00c036b3          	snez	a3,a2
4000c048:	00d9e6b3          	or	a3,s3,a3
4000c04c:	00000e93          	li	t4,0
4000c050:	dcdff06f          	j	4000be1c <__subdf3+0x2b0>
4000c054:	0e048463          	beqz	s1,4000c13c <__subdf3+0x5d0>
4000c058:	008005b7          	lui	a1,0x800
4000c05c:	7ff00713          	li	a4,2047
4000c060:	41d00eb3          	neg	t4,t4
4000c064:	00b7e7b3          	or	a5,a5,a1
4000c068:	22ee0863          	beq	t3,a4,4000c298 <__subdf3+0x72c>
4000c06c:	03800713          	li	a4,56
4000c070:	25d74063          	blt	a4,t4,4000c2b0 <__subdf3+0x744>
4000c074:	01f00713          	li	a4,31
4000c078:	3bd74063          	blt	a4,t4,4000c418 <__subdf3+0x8ac>
4000c07c:	02000713          	li	a4,32
4000c080:	41d70733          	sub	a4,a4,t4
4000c084:	00e799b3          	sll	s3,a5,a4
4000c088:	01d355b3          	srl	a1,t1,t4
4000c08c:	00e31733          	sll	a4,t1,a4
4000c090:	00b9e9b3          	or	s3,s3,a1
4000c094:	00e03733          	snez	a4,a4
4000c098:	00e9e9b3          	or	s3,s3,a4
4000c09c:	01d7deb3          	srl	t4,a5,t4
4000c0a0:	413609b3          	sub	s3,a2,s3
4000c0a4:	41d887b3          	sub	a5,a7,t4
4000c0a8:	01363633          	sltu	a2,a2,s3
4000c0ac:	40c787b3          	sub	a5,a5,a2
4000c0b0:	000e0493          	mv	s1,t3
4000c0b4:	00068913          	mv	s2,a3
4000c0b8:	c69ff06f          	j	4000bd20 <__subdf3+0x1b4>
4000c0bc:	0089e533          	or	a0,s3,s0
4000c0c0:	c6051ae3          	bnez	a0,4000bd34 <__subdf3+0x1c8>
4000c0c4:	00000793          	li	a5,0
4000c0c8:	00000813          	li	a6,0
4000c0cc:	00000493          	li	s1,0
4000c0d0:	e05ff06f          	j	4000bed4 <__subdf3+0x368>
4000c0d4:	fff70693          	addi	a3,a4,-1
4000c0d8:	08069463          	bnez	a3,4000c160 <__subdf3+0x5f4>
4000c0dc:	00c309b3          	add	s3,t1,a2
4000c0e0:	011787b3          	add	a5,a5,a7
4000c0e4:	0069b333          	sltu	t1,s3,t1
4000c0e8:	006787b3          	add	a5,a5,t1
4000c0ec:	00879713          	slli	a4,a5,0x8
4000c0f0:	00100493          	li	s1,1
4000c0f4:	d40750e3          	bgez	a4,4000be34 <__subdf3+0x2c8>
4000c0f8:	00200493          	li	s1,2
4000c0fc:	da1ff06f          	j	4000be9c <__subdf3+0x330>
4000c100:	01f00693          	li	a3,31
4000c104:	0ee6c463          	blt	a3,a4,4000c1ec <__subdf3+0x680>
4000c108:	02000593          	li	a1,32
4000c10c:	40e585b3          	sub	a1,a1,a4
4000c110:	00b896b3          	sll	a3,a7,a1
4000c114:	00e65533          	srl	a0,a2,a4
4000c118:	00b61633          	sll	a2,a2,a1
4000c11c:	00a6e6b3          	or	a3,a3,a0
4000c120:	00c039b3          	snez	s3,a2
4000c124:	0136e6b3          	or	a3,a3,s3
4000c128:	00e8d8b3          	srl	a7,a7,a4
4000c12c:	d4dff06f          	j	4000be78 <__subdf3+0x30c>
4000c130:	00000793          	li	a5,0
4000c134:	000e8493          	mv	s1,t4
4000c138:	d9dff06f          	j	4000bed4 <__subdf3+0x368>
4000c13c:	0067e733          	or	a4,a5,t1
4000c140:	12071663          	bnez	a4,4000c26c <__subdf3+0x700>
4000c144:	7ff00793          	li	a5,2047
4000c148:	14fe0863          	beq	t3,a5,4000c298 <__subdf3+0x72c>
4000c14c:	00068813          	mv	a6,a3
4000c150:	00088793          	mv	a5,a7
4000c154:	00060313          	mv	t1,a2
4000c158:	000e0493          	mv	s1,t3
4000c15c:	aa5ff06f          	j	4000bc00 <__subdf3+0x94>
4000c160:	7ff00593          	li	a1,2047
4000c164:	04b70863          	beq	a4,a1,4000c1b4 <__subdf3+0x648>
4000c168:	00068713          	mv	a4,a3
4000c16c:	cf9ff06f          	j	4000be64 <__subdf3+0x2f8>
4000c170:	0067e733          	or	a4,a5,t1
4000c174:	24049463          	bnez	s1,4000c3bc <__subdf3+0x850>
4000c178:	06070463          	beqz	a4,4000c1e0 <__subdf3+0x674>
4000c17c:	00c8e733          	or	a4,a7,a2
4000c180:	a80700e3          	beqz	a4,4000bc00 <__subdf3+0x94>
4000c184:	00c309b3          	add	s3,t1,a2
4000c188:	011787b3          	add	a5,a5,a7
4000c18c:	0069b333          	sltu	t1,s3,t1
4000c190:	006787b3          	add	a5,a5,t1
4000c194:	00879713          	slli	a4,a5,0x8
4000c198:	c8075ee3          	bgez	a4,4000be34 <__subdf3+0x2c8>
4000c19c:	ff800737          	lui	a4,0xff800
4000c1a0:	fff70713          	addi	a4,a4,-1 # ff7fffff <end+0xbf7ef21f>
4000c1a4:	00e7f7b3          	and	a5,a5,a4
4000c1a8:	00068493          	mv	s1,a3
4000c1ac:	0079f713          	andi	a4,s3,7
4000c1b0:	bf9ff06f          	j	4000bda8 <__subdf3+0x23c>
4000c1b4:	0067e533          	or	a0,a5,t1
4000c1b8:	b40512e3          	bnez	a0,4000bcfc <__subdf3+0x190>
4000c1bc:	00000793          	li	a5,0
4000c1c0:	00070493          	mv	s1,a4
4000c1c4:	d11ff06f          	j	4000bed4 <__subdf3+0x368>
4000c1c8:	0067e733          	or	a4,a5,t1
4000c1cc:	06049a63          	bnez	s1,4000c240 <__subdf3+0x6d4>
4000c1d0:	16071063          	bnez	a4,4000c330 <__subdf3+0x7c4>
4000c1d4:	00c8e533          	or	a0,a7,a2
4000c1d8:	22050a63          	beqz	a0,4000c40c <__subdf3+0x8a0>
4000c1dc:	00068813          	mv	a6,a3
4000c1e0:	00088793          	mv	a5,a7
4000c1e4:	00060313          	mv	t1,a2
4000c1e8:	a19ff06f          	j	4000bc00 <__subdf3+0x94>
4000c1ec:	02000513          	li	a0,32
4000c1f0:	00e8d6b3          	srl	a3,a7,a4
4000c1f4:	00000593          	li	a1,0
4000c1f8:	00a70863          	beq	a4,a0,4000c208 <__subdf3+0x69c>
4000c1fc:	04000593          	li	a1,64
4000c200:	40e58733          	sub	a4,a1,a4
4000c204:	00e895b3          	sll	a1,a7,a4
4000c208:	00c5e633          	or	a2,a1,a2
4000c20c:	00c039b3          	snez	s3,a2
4000c210:	0136e6b3          	or	a3,a3,s3
4000c214:	00000893          	li	a7,0
4000c218:	c61ff06f          	j	4000be78 <__subdf3+0x30c>
4000c21c:	0a049a63          	bnez	s1,4000c2d0 <__subdf3+0x764>
4000c220:	0067e6b3          	or	a3,a5,t1
4000c224:	22069263          	bnez	a3,4000c448 <__subdf3+0x8dc>
4000c228:	7ff00793          	li	a5,2047
4000c22c:	24fe0263          	beq	t3,a5,4000c470 <__subdf3+0x904>
4000c230:	00088793          	mv	a5,a7
4000c234:	00060313          	mv	t1,a2
4000c238:	000e0493          	mv	s1,t3
4000c23c:	9c5ff06f          	j	4000bc00 <__subdf3+0x94>
4000c240:	12071663          	bnez	a4,4000c36c <__subdf3+0x800>
4000c244:	00c8e7b3          	or	a5,a7,a2
4000c248:	22078a63          	beqz	a5,4000c47c <__subdf3+0x910>
4000c24c:	00068813          	mv	a6,a3
4000c250:	00088793          	mv	a5,a7
4000c254:	00060313          	mv	t1,a2
4000c258:	7ff00493          	li	s1,2047
4000c25c:	9a5ff06f          	j	4000bc00 <__subdf3+0x94>
4000c260:	00000793          	li	a5,0
4000c264:	00000513          	li	a0,0
4000c268:	c6dff06f          	j	4000bed4 <__subdf3+0x368>
4000c26c:	fffece93          	not	t4,t4
4000c270:	020e9063          	bnez	t4,4000c290 <__subdf3+0x724>
4000c274:	406609b3          	sub	s3,a2,t1
4000c278:	40f887b3          	sub	a5,a7,a5
4000c27c:	01363633          	sltu	a2,a2,s3
4000c280:	40c787b3          	sub	a5,a5,a2
4000c284:	000e0493          	mv	s1,t3
4000c288:	00068913          	mv	s2,a3
4000c28c:	a95ff06f          	j	4000bd20 <__subdf3+0x1b4>
4000c290:	7ff00713          	li	a4,2047
4000c294:	dcee1ce3          	bne	t3,a4,4000c06c <__subdf3+0x500>
4000c298:	00c8e533          	or	a0,a7,a2
4000c29c:	00068813          	mv	a6,a3
4000c2a0:	f80518e3          	bnez	a0,4000c230 <__subdf3+0x6c4>
4000c2a4:	00000793          	li	a5,0
4000c2a8:	000e0493          	mv	s1,t3
4000c2ac:	c29ff06f          	j	4000bed4 <__subdf3+0x368>
4000c2b0:	0067e9b3          	or	s3,a5,t1
4000c2b4:	013039b3          	snez	s3,s3
4000c2b8:	00000e93          	li	t4,0
4000c2bc:	de5ff06f          	j	4000c0a0 <__subdf3+0x534>
4000c2c0:	00058493          	mv	s1,a1
4000c2c4:	00000793          	li	a5,0
4000c2c8:	00000513          	li	a0,0
4000c2cc:	c09ff06f          	j	4000bed4 <__subdf3+0x368>
4000c2d0:	008005b7          	lui	a1,0x800
4000c2d4:	7ff00693          	li	a3,2047
4000c2d8:	40e00733          	neg	a4,a4
4000c2dc:	00b7e7b3          	or	a5,a5,a1
4000c2e0:	18de0863          	beq	t3,a3,4000c470 <__subdf3+0x904>
4000c2e4:	03800693          	li	a3,56
4000c2e8:	1ae6c663          	blt	a3,a4,4000c494 <__subdf3+0x928>
4000c2ec:	01f00693          	li	a3,31
4000c2f0:	1ce6c663          	blt	a3,a4,4000c4bc <__subdf3+0x950>
4000c2f4:	02000593          	li	a1,32
4000c2f8:	40e585b3          	sub	a1,a1,a4
4000c2fc:	00b796b3          	sll	a3,a5,a1
4000c300:	00e35533          	srl	a0,t1,a4
4000c304:	00b315b3          	sll	a1,t1,a1
4000c308:	00a6e6b3          	or	a3,a3,a0
4000c30c:	00b039b3          	snez	s3,a1
4000c310:	0136e6b3          	or	a3,a3,s3
4000c314:	00e7d7b3          	srl	a5,a5,a4
4000c318:	00c689b3          	add	s3,a3,a2
4000c31c:	011787b3          	add	a5,a5,a7
4000c320:	00c9b633          	sltu	a2,s3,a2
4000c324:	00c787b3          	add	a5,a5,a2
4000c328:	000e0493          	mv	s1,t3
4000c32c:	b5dff06f          	j	4000be88 <__subdf3+0x31c>
4000c330:	00c8e733          	or	a4,a7,a2
4000c334:	8c0706e3          	beqz	a4,4000bc00 <__subdf3+0x94>
4000c338:	40c309b3          	sub	s3,t1,a2
4000c33c:	013335b3          	sltu	a1,t1,s3
4000c340:	41178733          	sub	a4,a5,a7
4000c344:	40b70733          	sub	a4,a4,a1
4000c348:	00871593          	slli	a1,a4,0x8
4000c34c:	0a05da63          	bgez	a1,4000c400 <__subdf3+0x894>
4000c350:	406609b3          	sub	s3,a2,t1
4000c354:	40f887b3          	sub	a5,a7,a5
4000c358:	01363633          	sltu	a2,a2,s3
4000c35c:	40c787b3          	sub	a5,a5,a2
4000c360:	0079f713          	andi	a4,s3,7
4000c364:	00068813          	mv	a6,a3
4000c368:	a41ff06f          	j	4000bda8 <__subdf3+0x23c>
4000c36c:	00c8e633          	or	a2,a7,a2
4000c370:	c6060ae3          	beqz	a2,4000bfe4 <__subdf3+0x478>
4000c374:	00f8e8b3          	or	a7,a7,a5
4000c378:	00989713          	slli	a4,a7,0x9
4000c37c:	12074463          	bltz	a4,4000c4a4 <__subdf3+0x938>
4000c380:	20000737          	lui	a4,0x20000
4000c384:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
4000c388:	01d79313          	slli	t1,a5,0x1d
4000c38c:	00a77533          	and	a0,a4,a0
4000c390:	00a36533          	or	a0,t1,a0
4000c394:	ff87f793          	andi	a5,a5,-8
4000c398:	01d55713          	srli	a4,a0,0x1d
4000c39c:	00e7e7b3          	or	a5,a5,a4
4000c3a0:	00351313          	slli	t1,a0,0x3
4000c3a4:	7ff00493          	li	s1,2047
4000c3a8:	859ff06f          	j	4000bc00 <__subdf3+0x94>
4000c3ac:	00000513          	li	a0,0
4000c3b0:	00048713          	mv	a4,s1
4000c3b4:	00000793          	li	a5,0
4000c3b8:	881ff06f          	j	4000bc38 <__subdf3+0xcc>
4000c3bc:	e8070ae3          	beqz	a4,4000c250 <__subdf3+0x6e4>
4000c3c0:	00c8e633          	or	a2,a7,a2
4000c3c4:	c20600e3          	beqz	a2,4000bfe4 <__subdf3+0x478>
4000c3c8:	00f8e8b3          	or	a7,a7,a5
4000c3cc:	00989713          	slli	a4,a7,0x9
4000c3d0:	0c074a63          	bltz	a4,4000c4a4 <__subdf3+0x938>
4000c3d4:	20000737          	lui	a4,0x20000
4000c3d8:	fff70713          	addi	a4,a4,-1 # 1fffffff <_heap_size+0x1fffdfff>
4000c3dc:	01d79313          	slli	t1,a5,0x1d
4000c3e0:	00a77533          	and	a0,a4,a0
4000c3e4:	00a36533          	or	a0,t1,a0
4000c3e8:	01d55713          	srli	a4,a0,0x1d
4000c3ec:	ff87f793          	andi	a5,a5,-8
4000c3f0:	00f767b3          	or	a5,a4,a5
4000c3f4:	00351313          	slli	t1,a0,0x3
4000c3f8:	7ff00493          	li	s1,2047
4000c3fc:	805ff06f          	j	4000bc00 <__subdf3+0x94>
4000c400:	00e9e533          	or	a0,s3,a4
4000c404:	00070793          	mv	a5,a4
4000c408:	a20516e3          	bnez	a0,4000be34 <__subdf3+0x2c8>
4000c40c:	00000793          	li	a5,0
4000c410:	00000813          	li	a6,0
4000c414:	ac1ff06f          	j	4000bed4 <__subdf3+0x368>
4000c418:	02000593          	li	a1,32
4000c41c:	01d7d9b3          	srl	s3,a5,t4
4000c420:	00000713          	li	a4,0
4000c424:	00be8863          	beq	t4,a1,4000c434 <__subdf3+0x8c8>
4000c428:	04000713          	li	a4,64
4000c42c:	41d70eb3          	sub	t4,a4,t4
4000c430:	01d79733          	sll	a4,a5,t4
4000c434:	006767b3          	or	a5,a4,t1
4000c438:	00f037b3          	snez	a5,a5
4000c43c:	00f9e9b3          	or	s3,s3,a5
4000c440:	00000e93          	li	t4,0
4000c444:	c5dff06f          	j	4000c0a0 <__subdf3+0x534>
4000c448:	fff74713          	not	a4,a4
4000c44c:	00071e63          	bnez	a4,4000c468 <__subdf3+0x8fc>
4000c450:	00c309b3          	add	s3,t1,a2
4000c454:	011787b3          	add	a5,a5,a7
4000c458:	00c9b633          	sltu	a2,s3,a2
4000c45c:	00c787b3          	add	a5,a5,a2
4000c460:	000e0493          	mv	s1,t3
4000c464:	a25ff06f          	j	4000be88 <__subdf3+0x31c>
4000c468:	7ff00693          	li	a3,2047
4000c46c:	e6de1ce3          	bne	t3,a3,4000c2e4 <__subdf3+0x778>
4000c470:	00c8e533          	or	a0,a7,a2
4000c474:	da051ee3          	bnez	a0,4000c230 <__subdf3+0x6c4>
4000c478:	e2dff06f          	j	4000c2a4 <__subdf3+0x738>
4000c47c:	001007b7          	lui	a5,0x100
4000c480:	00000813          	li	a6,0
4000c484:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000c488:	fff00513          	li	a0,-1
4000c48c:	7ff00493          	li	s1,2047
4000c490:	a45ff06f          	j	4000bed4 <__subdf3+0x368>
4000c494:	0067e7b3          	or	a5,a5,t1
4000c498:	00f036b3          	snez	a3,a5
4000c49c:	00000793          	li	a5,0
4000c4a0:	e79ff06f          	j	4000c318 <__subdf3+0x7ac>
4000c4a4:	008007b7          	lui	a5,0x800
4000c4a8:	00000813          	li	a6,0
4000c4ac:	ff800313          	li	t1,-8
4000c4b0:	fff78793          	addi	a5,a5,-1 # 7fffff <_heap_size+0x7fdfff>
4000c4b4:	7ff00493          	li	s1,2047
4000c4b8:	f48ff06f          	j	4000bc00 <__subdf3+0x94>
4000c4bc:	02000513          	li	a0,32
4000c4c0:	00e7d6b3          	srl	a3,a5,a4
4000c4c4:	00000593          	li	a1,0
4000c4c8:	00a70863          	beq	a4,a0,4000c4d8 <__subdf3+0x96c>
4000c4cc:	04000593          	li	a1,64
4000c4d0:	40e58733          	sub	a4,a1,a4
4000c4d4:	00e795b3          	sll	a1,a5,a4
4000c4d8:	0065e5b3          	or	a1,a1,t1
4000c4dc:	00b039b3          	snez	s3,a1
4000c4e0:	0136e6b3          	or	a3,a3,s3
4000c4e4:	00000793          	li	a5,0
4000c4e8:	e31ff06f          	j	4000c318 <__subdf3+0x7ac>

4000c4ec <__unorddf2>:
4000c4ec:	0145d713          	srli	a4,a1,0x14
4000c4f0:	001007b7          	lui	a5,0x100
4000c4f4:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000c4f8:	fff74713          	not	a4,a4
4000c4fc:	0146d813          	srli	a6,a3,0x14
4000c500:	00b7f5b3          	and	a1,a5,a1
4000c504:	00d7f7b3          	and	a5,a5,a3
4000c508:	01571693          	slli	a3,a4,0x15
4000c50c:	7ff87813          	andi	a6,a6,2047
4000c510:	02068063          	beqz	a3,4000c530 <__unorddf2+0x44>
4000c514:	7ff00713          	li	a4,2047
4000c518:	00000513          	li	a0,0
4000c51c:	00e80463          	beq	a6,a4,4000c524 <__unorddf2+0x38>
4000c520:	00008067          	ret
4000c524:	00c7e7b3          	or	a5,a5,a2
4000c528:	00f03533          	snez	a0,a5
4000c52c:	00008067          	ret
4000c530:	00a5e5b3          	or	a1,a1,a0
4000c534:	00100513          	li	a0,1
4000c538:	fc058ee3          	beqz	a1,4000c514 <__unorddf2+0x28>
4000c53c:	00008067          	ret

4000c540 <__fixdfsi>:
4000c540:	0145d793          	srli	a5,a1,0x14
4000c544:	001006b7          	lui	a3,0x100
4000c548:	fff68713          	addi	a4,a3,-1 # fffff <_heap_size+0xfdfff>
4000c54c:	7ff7f793          	andi	a5,a5,2047
4000c550:	3fe00613          	li	a2,1022
4000c554:	00b77733          	and	a4,a4,a1
4000c558:	01f5d593          	srli	a1,a1,0x1f
4000c55c:	04f65663          	ble	a5,a2,4000c5a8 <__fixdfsi+0x68>
4000c560:	41d00613          	li	a2,1053
4000c564:	02f64a63          	blt	a2,a5,4000c598 <__fixdfsi+0x58>
4000c568:	43300613          	li	a2,1075
4000c56c:	40f60633          	sub	a2,a2,a5
4000c570:	01f00813          	li	a6,31
4000c574:	00d76733          	or	a4,a4,a3
4000c578:	02c85c63          	ble	a2,a6,4000c5b0 <__fixdfsi+0x70>
4000c57c:	41300693          	li	a3,1043
4000c580:	40f687b3          	sub	a5,a3,a5
4000c584:	00f757b3          	srl	a5,a4,a5
4000c588:	40f00533          	neg	a0,a5
4000c58c:	02059063          	bnez	a1,4000c5ac <__fixdfsi+0x6c>
4000c590:	00078513          	mv	a0,a5
4000c594:	00008067          	ret
4000c598:	80000537          	lui	a0,0x80000
4000c59c:	fff54513          	not	a0,a0
4000c5a0:	00a58533          	add	a0,a1,a0
4000c5a4:	00008067          	ret
4000c5a8:	00000513          	li	a0,0
4000c5ac:	00008067          	ret
4000c5b0:	bed78793          	addi	a5,a5,-1043
4000c5b4:	00c55633          	srl	a2,a0,a2
4000c5b8:	00f717b3          	sll	a5,a4,a5
4000c5bc:	00c7e7b3          	or	a5,a5,a2
4000c5c0:	fc9ff06f          	j	4000c588 <__fixdfsi+0x48>

4000c5c4 <__floatsidf>:
4000c5c4:	ff010113          	addi	sp,sp,-16
4000c5c8:	00112623          	sw	ra,12(sp)
4000c5cc:	00812423          	sw	s0,8(sp)
4000c5d0:	00912223          	sw	s1,4(sp)
4000c5d4:	0c050663          	beqz	a0,4000c6a0 <__floatsidf+0xdc>
4000c5d8:	00050413          	mv	s0,a0
4000c5dc:	01f55493          	srli	s1,a0,0x1f
4000c5e0:	0c054a63          	bltz	a0,4000c6b4 <__floatsidf+0xf0>
4000c5e4:	00040513          	mv	a0,s0
4000c5e8:	1a1000ef          	jal	ra,4000cf88 <__clzsi2>
4000c5ec:	41e00713          	li	a4,1054
4000c5f0:	40a70733          	sub	a4,a4,a0
4000c5f4:	43300693          	li	a3,1075
4000c5f8:	40e686b3          	sub	a3,a3,a4
4000c5fc:	01f00793          	li	a5,31
4000c600:	06d7dc63          	ble	a3,a5,4000c678 <__floatsidf+0xb4>
4000c604:	41300793          	li	a5,1043
4000c608:	40e787b3          	sub	a5,a5,a4
4000c60c:	001006b7          	lui	a3,0x100
4000c610:	00f417b3          	sll	a5,s0,a5
4000c614:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000c618:	00d7f7b3          	and	a5,a5,a3
4000c61c:	7ff77713          	andi	a4,a4,2047
4000c620:	00048693          	mv	a3,s1
4000c624:	00000413          	li	s0,0
4000c628:	00100537          	lui	a0,0x100
4000c62c:	fff50513          	addi	a0,a0,-1 # fffff <_heap_size+0xfdfff>
4000c630:	80100637          	lui	a2,0x80100
4000c634:	00a7f7b3          	and	a5,a5,a0
4000c638:	fff60613          	addi	a2,a2,-1 # 800fffff <end+0x400ef21f>
4000c63c:	01471713          	slli	a4,a4,0x14
4000c640:	00c7f7b3          	and	a5,a5,a2
4000c644:	00e7e7b3          	or	a5,a5,a4
4000c648:	01f69713          	slli	a4,a3,0x1f
4000c64c:	800006b7          	lui	a3,0x80000
4000c650:	fff6c693          	not	a3,a3
4000c654:	00c12083          	lw	ra,12(sp)
4000c658:	00d7f7b3          	and	a5,a5,a3
4000c65c:	00e7e7b3          	or	a5,a5,a4
4000c660:	00040513          	mv	a0,s0
4000c664:	00078593          	mv	a1,a5
4000c668:	00812403          	lw	s0,8(sp)
4000c66c:	00412483          	lw	s1,4(sp)
4000c670:	01010113          	addi	sp,sp,16
4000c674:	00008067          	ret
4000c678:	00b00793          	li	a5,11
4000c67c:	40a787b3          	sub	a5,a5,a0
4000c680:	00f457b3          	srl	a5,s0,a5
4000c684:	00d41433          	sll	s0,s0,a3
4000c688:	001006b7          	lui	a3,0x100
4000c68c:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000c690:	00d7f7b3          	and	a5,a5,a3
4000c694:	7ff77713          	andi	a4,a4,2047
4000c698:	00048693          	mv	a3,s1
4000c69c:	f8dff06f          	j	4000c628 <__floatsidf+0x64>
4000c6a0:	00000693          	li	a3,0
4000c6a4:	00000713          	li	a4,0
4000c6a8:	00000793          	li	a5,0
4000c6ac:	00000413          	li	s0,0
4000c6b0:	f79ff06f          	j	4000c628 <__floatsidf+0x64>
4000c6b4:	40a00433          	neg	s0,a0
4000c6b8:	f2dff06f          	j	4000c5e4 <__floatsidf+0x20>

4000c6bc <__floatunsidf>:
4000c6bc:	ff010113          	addi	sp,sp,-16
4000c6c0:	00112623          	sw	ra,12(sp)
4000c6c4:	00812423          	sw	s0,8(sp)
4000c6c8:	0a050663          	beqz	a0,4000c774 <__floatunsidf+0xb8>
4000c6cc:	00050413          	mv	s0,a0
4000c6d0:	0b9000ef          	jal	ra,4000cf88 <__clzsi2>
4000c6d4:	41e00693          	li	a3,1054
4000c6d8:	40a686b3          	sub	a3,a3,a0
4000c6dc:	43300713          	li	a4,1075
4000c6e0:	40d70733          	sub	a4,a4,a3
4000c6e4:	01f00793          	li	a5,31
4000c6e8:	06e7d463          	ble	a4,a5,4000c750 <__floatunsidf+0x94>
4000c6ec:	41300793          	li	a5,1043
4000c6f0:	40d787b3          	sub	a5,a5,a3
4000c6f4:	00100737          	lui	a4,0x100
4000c6f8:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000c6fc:	00f417b3          	sll	a5,s0,a5
4000c700:	00e7f7b3          	and	a5,a5,a4
4000c704:	7ff6f693          	andi	a3,a3,2047
4000c708:	00000713          	li	a4,0
4000c70c:	00100537          	lui	a0,0x100
4000c710:	fff50513          	addi	a0,a0,-1 # fffff <_heap_size+0xfdfff>
4000c714:	80100637          	lui	a2,0x80100
4000c718:	00a7f7b3          	and	a5,a5,a0
4000c71c:	fff60613          	addi	a2,a2,-1 # 800fffff <end+0x400ef21f>
4000c720:	01469693          	slli	a3,a3,0x14
4000c724:	00c7f7b3          	and	a5,a5,a2
4000c728:	00d7e7b3          	or	a5,a5,a3
4000c72c:	00c12083          	lw	ra,12(sp)
4000c730:	800006b7          	lui	a3,0x80000
4000c734:	fff6c693          	not	a3,a3
4000c738:	00d7f7b3          	and	a5,a5,a3
4000c73c:	00070513          	mv	a0,a4
4000c740:	00078593          	mv	a1,a5
4000c744:	00812403          	lw	s0,8(sp)
4000c748:	01010113          	addi	sp,sp,16
4000c74c:	00008067          	ret
4000c750:	00b00793          	li	a5,11
4000c754:	40a787b3          	sub	a5,a5,a0
4000c758:	00100637          	lui	a2,0x100
4000c75c:	00f457b3          	srl	a5,s0,a5
4000c760:	fff60613          	addi	a2,a2,-1 # fffff <_heap_size+0xfdfff>
4000c764:	00e41733          	sll	a4,s0,a4
4000c768:	00c7f7b3          	and	a5,a5,a2
4000c76c:	7ff6f693          	andi	a3,a3,2047
4000c770:	f9dff06f          	j	4000c70c <__floatunsidf+0x50>
4000c774:	00000693          	li	a3,0
4000c778:	00000793          	li	a5,0
4000c77c:	00000713          	li	a4,0
4000c780:	f8dff06f          	j	4000c70c <__floatunsidf+0x50>

4000c784 <__extendsfdf2>:
4000c784:	01755713          	srli	a4,a0,0x17
4000c788:	ff010113          	addi	sp,sp,-16
4000c78c:	0ff77713          	andi	a4,a4,255
4000c790:	00812423          	sw	s0,8(sp)
4000c794:	00170693          	addi	a3,a4,1
4000c798:	00800437          	lui	s0,0x800
4000c79c:	00912223          	sw	s1,4(sp)
4000c7a0:	fff40413          	addi	s0,s0,-1 # 7fffff <_heap_size+0x7fdfff>
4000c7a4:	00112623          	sw	ra,12(sp)
4000c7a8:	0ff6f693          	andi	a3,a3,255
4000c7ac:	00100793          	li	a5,1
4000c7b0:	00a47433          	and	s0,s0,a0
4000c7b4:	01f55493          	srli	s1,a0,0x1f
4000c7b8:	06d7d863          	ble	a3,a5,4000c828 <__extendsfdf2+0xa4>
4000c7bc:	001006b7          	lui	a3,0x100
4000c7c0:	00345793          	srli	a5,s0,0x3
4000c7c4:	fff68693          	addi	a3,a3,-1 # fffff <_heap_size+0xfdfff>
4000c7c8:	00d7f7b3          	and	a5,a5,a3
4000c7cc:	01d41413          	slli	s0,s0,0x1d
4000c7d0:	38070693          	addi	a3,a4,896
4000c7d4:	00100737          	lui	a4,0x100
4000c7d8:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000c7dc:	00e7f7b3          	and	a5,a5,a4
4000c7e0:	7ff6f713          	andi	a4,a3,2047
4000c7e4:	801006b7          	lui	a3,0x80100
4000c7e8:	fff68693          	addi	a3,a3,-1 # 800fffff <end+0x400ef21f>
4000c7ec:	01471713          	slli	a4,a4,0x14
4000c7f0:	00d7f7b3          	and	a5,a5,a3
4000c7f4:	00e7e7b3          	or	a5,a5,a4
4000c7f8:	80000737          	lui	a4,0x80000
4000c7fc:	fff74713          	not	a4,a4
4000c800:	00c12083          	lw	ra,12(sp)
4000c804:	01f49513          	slli	a0,s1,0x1f
4000c808:	00e7f7b3          	and	a5,a5,a4
4000c80c:	00a7e7b3          	or	a5,a5,a0
4000c810:	00078593          	mv	a1,a5
4000c814:	00040513          	mv	a0,s0
4000c818:	00412483          	lw	s1,4(sp)
4000c81c:	00812403          	lw	s0,8(sp)
4000c820:	01010113          	addi	sp,sp,16
4000c824:	00008067          	ret
4000c828:	04071463          	bnez	a4,4000c870 <__extendsfdf2+0xec>
4000c82c:	06040863          	beqz	s0,4000c89c <__extendsfdf2+0x118>
4000c830:	00040513          	mv	a0,s0
4000c834:	754000ef          	jal	ra,4000cf88 <__clzsi2>
4000c838:	00a00793          	li	a5,10
4000c83c:	06a7c663          	blt	a5,a0,4000c8a8 <__extendsfdf2+0x124>
4000c840:	00b00713          	li	a4,11
4000c844:	40a70733          	sub	a4,a4,a0
4000c848:	01550793          	addi	a5,a0,21
4000c84c:	00e45733          	srl	a4,s0,a4
4000c850:	00f41433          	sll	s0,s0,a5
4000c854:	38900693          	li	a3,905
4000c858:	001007b7          	lui	a5,0x100
4000c85c:	40a686b3          	sub	a3,a3,a0
4000c860:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000c864:	00f777b3          	and	a5,a4,a5
4000c868:	7ff6f693          	andi	a3,a3,2047
4000c86c:	f69ff06f          	j	4000c7d4 <__extendsfdf2+0x50>
4000c870:	7ff00693          	li	a3,2047
4000c874:	00000793          	li	a5,0
4000c878:	f4040ee3          	beqz	s0,4000c7d4 <__extendsfdf2+0x50>
4000c87c:	00345713          	srli	a4,s0,0x3
4000c880:	000807b7          	lui	a5,0x80
4000c884:	00f767b3          	or	a5,a4,a5
4000c888:	00100737          	lui	a4,0x100
4000c88c:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000c890:	01d41413          	slli	s0,s0,0x1d
4000c894:	00e7f7b3          	and	a5,a5,a4
4000c898:	f3dff06f          	j	4000c7d4 <__extendsfdf2+0x50>
4000c89c:	00000693          	li	a3,0
4000c8a0:	00000793          	li	a5,0
4000c8a4:	f31ff06f          	j	4000c7d4 <__extendsfdf2+0x50>
4000c8a8:	ff550713          	addi	a4,a0,-11
4000c8ac:	00e41733          	sll	a4,s0,a4
4000c8b0:	00000413          	li	s0,0
4000c8b4:	fa1ff06f          	j	4000c854 <__extendsfdf2+0xd0>

4000c8b8 <__truncdfsf2>:
4000c8b8:	0145d693          	srli	a3,a1,0x14
4000c8bc:	001007b7          	lui	a5,0x100
4000c8c0:	7ff6f693          	andi	a3,a3,2047
4000c8c4:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000c8c8:	00b7f7b3          	and	a5,a5,a1
4000c8cc:	00168813          	addi	a6,a3,1
4000c8d0:	00379793          	slli	a5,a5,0x3
4000c8d4:	01d55713          	srli	a4,a0,0x1d
4000c8d8:	7ff87813          	andi	a6,a6,2047
4000c8dc:	00100313          	li	t1,1
4000c8e0:	01f5d593          	srli	a1,a1,0x1f
4000c8e4:	00f76633          	or	a2,a4,a5
4000c8e8:	00351893          	slli	a7,a0,0x3
4000c8ec:	0b035e63          	ble	a6,t1,4000c9a8 <__truncdfsf2+0xf0>
4000c8f0:	c8068813          	addi	a6,a3,-896
4000c8f4:	0fe00313          	li	t1,254
4000c8f8:	0ff00713          	li	a4,255
4000c8fc:	00000793          	li	a5,0
4000c900:	07034863          	blt	t1,a6,4000c970 <__truncdfsf2+0xb8>
4000c904:	13005263          	blez	a6,4000ca28 <__truncdfsf2+0x170>
4000c908:	00651513          	slli	a0,a0,0x6
4000c90c:	01d8d793          	srli	a5,a7,0x1d
4000c910:	00a03533          	snez	a0,a0
4000c914:	00f56533          	or	a0,a0,a5
4000c918:	00361793          	slli	a5,a2,0x3
4000c91c:	00a7e7b3          	or	a5,a5,a0
4000c920:	0077f713          	andi	a4,a5,7
4000c924:	00070a63          	beqz	a4,4000c938 <__truncdfsf2+0x80>
4000c928:	00f7f713          	andi	a4,a5,15
4000c92c:	00400693          	li	a3,4
4000c930:	00d70463          	beq	a4,a3,4000c938 <__truncdfsf2+0x80>
4000c934:	00478793          	addi	a5,a5,4
4000c938:	04000737          	lui	a4,0x4000
4000c93c:	00e7f733          	and	a4,a5,a4
4000c940:	16070463          	beqz	a4,4000caa8 <__truncdfsf2+0x1f0>
4000c944:	00180713          	addi	a4,a6,1
4000c948:	0ff00693          	li	a3,255
4000c94c:	0cd70a63          	beq	a4,a3,4000ca20 <__truncdfsf2+0x168>
4000c950:	1f8006b7          	lui	a3,0x1f800
4000c954:	fff68693          	addi	a3,a3,-1 # 1f7fffff <_heap_size+0x1f7fdfff>
4000c958:	0037d793          	srli	a5,a5,0x3
4000c95c:	00d7f7b3          	and	a5,a5,a3
4000c960:	008006b7          	lui	a3,0x800
4000c964:	fff68693          	addi	a3,a3,-1 # 7fffff <_heap_size+0x7fdfff>
4000c968:	00d7f7b3          	and	a5,a5,a3
4000c96c:	0ff77713          	andi	a4,a4,255
4000c970:	00800537          	lui	a0,0x800
4000c974:	fff50513          	addi	a0,a0,-1 # 7fffff <_heap_size+0x7fdfff>
4000c978:	00a7f7b3          	and	a5,a5,a0
4000c97c:	80800537          	lui	a0,0x80800
4000c980:	fff50513          	addi	a0,a0,-1 # 807fffff <end+0x407ef21f>
4000c984:	01771713          	slli	a4,a4,0x17
4000c988:	00a7f533          	and	a0,a5,a0
4000c98c:	800007b7          	lui	a5,0x80000
4000c990:	00e56533          	or	a0,a0,a4
4000c994:	fff7c793          	not	a5,a5
4000c998:	01f59593          	slli	a1,a1,0x1f
4000c99c:	00f57533          	and	a0,a0,a5
4000c9a0:	00b56533          	or	a0,a0,a1
4000c9a4:	00008067          	ret
4000c9a8:	02068463          	beqz	a3,4000c9d0 <__truncdfsf2+0x118>
4000c9ac:	011668b3          	or	a7,a2,a7
4000c9b0:	0ff00713          	li	a4,255
4000c9b4:	00000793          	li	a5,0
4000c9b8:	fa088ce3          	beqz	a7,4000c970 <__truncdfsf2+0xb8>
4000c9bc:	00361613          	slli	a2,a2,0x3
4000c9c0:	020007b7          	lui	a5,0x2000
4000c9c4:	00f667b3          	or	a5,a2,a5
4000c9c8:	00070813          	mv	a6,a4
4000c9cc:	f55ff06f          	j	4000c920 <__truncdfsf2+0x68>
4000c9d0:	011667b3          	or	a5,a2,a7
4000c9d4:	00078a63          	beqz	a5,4000c9e8 <__truncdfsf2+0x130>
4000c9d8:	00500793          	li	a5,5
4000c9dc:	0ff00713          	li	a4,255
4000c9e0:	0037d793          	srli	a5,a5,0x3
4000c9e4:	00e68c63          	beq	a3,a4,4000c9fc <__truncdfsf2+0x144>
4000c9e8:	00800737          	lui	a4,0x800
4000c9ec:	fff70713          	addi	a4,a4,-1 # 7fffff <_heap_size+0x7fdfff>
4000c9f0:	00e7f7b3          	and	a5,a5,a4
4000c9f4:	0ff6f713          	andi	a4,a3,255
4000c9f8:	f79ff06f          	j	4000c970 <__truncdfsf2+0xb8>
4000c9fc:	02078063          	beqz	a5,4000ca1c <__truncdfsf2+0x164>
4000ca00:	00400737          	lui	a4,0x400
4000ca04:	00e7e7b3          	or	a5,a5,a4
4000ca08:	00800737          	lui	a4,0x800
4000ca0c:	fff70713          	addi	a4,a4,-1 # 7fffff <_heap_size+0x7fdfff>
4000ca10:	00e7f7b3          	and	a5,a5,a4
4000ca14:	00068713          	mv	a4,a3
4000ca18:	f59ff06f          	j	4000c970 <__truncdfsf2+0xb8>
4000ca1c:	00068713          	mv	a4,a3
4000ca20:	00000793          	li	a5,0
4000ca24:	f4dff06f          	j	4000c970 <__truncdfsf2+0xb8>
4000ca28:	fe900793          	li	a5,-23
4000ca2c:	04f84063          	blt	a6,a5,4000ca6c <__truncdfsf2+0x1b4>
4000ca30:	01e00793          	li	a5,30
4000ca34:	00800537          	lui	a0,0x800
4000ca38:	410787b3          	sub	a5,a5,a6
4000ca3c:	01f00713          	li	a4,31
4000ca40:	00a66633          	or	a2,a2,a0
4000ca44:	02f74863          	blt	a4,a5,4000ca74 <__truncdfsf2+0x1bc>
4000ca48:	c8268693          	addi	a3,a3,-894
4000ca4c:	00d89733          	sll	a4,a7,a3
4000ca50:	00e03733          	snez	a4,a4
4000ca54:	00d61633          	sll	a2,a2,a3
4000ca58:	00f8d8b3          	srl	a7,a7,a5
4000ca5c:	00c767b3          	or	a5,a4,a2
4000ca60:	00f8e7b3          	or	a5,a7,a5
4000ca64:	00000813          	li	a6,0
4000ca68:	eb9ff06f          	j	4000c920 <__truncdfsf2+0x68>
4000ca6c:	00000693          	li	a3,0
4000ca70:	f69ff06f          	j	4000c9d8 <__truncdfsf2+0x120>
4000ca74:	ffe00713          	li	a4,-2
4000ca78:	41070733          	sub	a4,a4,a6
4000ca7c:	02000813          	li	a6,32
4000ca80:	00e65733          	srl	a4,a2,a4
4000ca84:	00000513          	li	a0,0
4000ca88:	01078663          	beq	a5,a6,4000ca94 <__truncdfsf2+0x1dc>
4000ca8c:	ca268693          	addi	a3,a3,-862
4000ca90:	00d61533          	sll	a0,a2,a3
4000ca94:	011567b3          	or	a5,a0,a7
4000ca98:	00f037b3          	snez	a5,a5
4000ca9c:	00f767b3          	or	a5,a4,a5
4000caa0:	00000813          	li	a6,0
4000caa4:	e7dff06f          	j	4000c920 <__truncdfsf2+0x68>
4000caa8:	00080693          	mv	a3,a6
4000caac:	f31ff06f          	j	4000c9dc <__truncdfsf2+0x124>

4000cab0 <__trunctfdf2>:
4000cab0:	00c52783          	lw	a5,12(a0) # 80000c <_heap_size+0x7fe00c>
4000cab4:	00852883          	lw	a7,8(a0)
4000cab8:	00452683          	lw	a3,4(a0)
4000cabc:	00052803          	lw	a6,0(a0)
4000cac0:	01079713          	slli	a4,a5,0x10
4000cac4:	fe010113          	addi	sp,sp,-32
4000cac8:	00088593          	mv	a1,a7
4000cacc:	01075713          	srli	a4,a4,0x10
4000cad0:	01112c23          	sw	a7,24(sp)
4000cad4:	00e12e23          	sw	a4,28(sp)
4000cad8:	01112423          	sw	a7,8(sp)
4000cadc:	00371713          	slli	a4,a4,0x3
4000cae0:	01010893          	addi	a7,sp,16
4000cae4:	01d5d593          	srli	a1,a1,0x1d
4000cae8:	00d12a23          	sw	a3,20(sp)
4000caec:	00d12223          	sw	a3,4(sp)
4000caf0:	01012823          	sw	a6,16(sp)
4000caf4:	00088693          	mv	a3,a7
4000caf8:	00b76733          	or	a4,a4,a1
4000cafc:	00179613          	slli	a2,a5,0x1
4000cb00:	00f12623          	sw	a5,12(sp)
4000cb04:	01f7d513          	srli	a0,a5,0x1f
4000cb08:	00e6a623          	sw	a4,12(a3)
4000cb0c:	01012023          	sw	a6,0(sp)
4000cb10:	00410793          	addi	a5,sp,4
4000cb14:	ffc68693          	addi	a3,a3,-4
4000cb18:	01165613          	srli	a2,a2,0x11
4000cb1c:	02d78263          	beq	a5,a3,4000cb40 <__trunctfdf2+0x90>
4000cb20:	00c6a703          	lw	a4,12(a3)
4000cb24:	0086a583          	lw	a1,8(a3)
4000cb28:	ffc68693          	addi	a3,a3,-4
4000cb2c:	00371713          	slli	a4,a4,0x3
4000cb30:	01d5d593          	srli	a1,a1,0x1d
4000cb34:	00b76733          	or	a4,a4,a1
4000cb38:	00e6a823          	sw	a4,16(a3)
4000cb3c:	fed792e3          	bne	a5,a3,4000cb20 <__trunctfdf2+0x70>
4000cb40:	01012683          	lw	a3,16(sp)
4000cb44:	00008837          	lui	a6,0x8
4000cb48:	00160593          	addi	a1,a2,1
4000cb4c:	00369793          	slli	a5,a3,0x3
4000cb50:	fff80813          	addi	a6,a6,-1 # 7fff <_heap_size+0x5fff>
4000cb54:	00f12823          	sw	a5,16(sp)
4000cb58:	0105f5b3          	and	a1,a1,a6
4000cb5c:	00100693          	li	a3,1
4000cb60:	10b6d063          	ble	a1,a3,4000cc60 <__trunctfdf2+0x1b0>
4000cb64:	ffffc5b7          	lui	a1,0xffffc
4000cb68:	40058593          	addi	a1,a1,1024 # ffffc400 <end+0xbffeb620>
4000cb6c:	00b60633          	add	a2,a2,a1
4000cb70:	7fe00593          	li	a1,2046
4000cb74:	04c5da63          	ble	a2,a1,4000cbc8 <__trunctfdf2+0x118>
4000cb78:	7ff00613          	li	a2,2047
4000cb7c:	00000793          	li	a5,0
4000cb80:	00000693          	li	a3,0
4000cb84:	00100737          	lui	a4,0x100
4000cb88:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000cb8c:	00e7f7b3          	and	a5,a5,a4
4000cb90:	80100737          	lui	a4,0x80100
4000cb94:	fff70713          	addi	a4,a4,-1 # 800fffff <end+0x400ef21f>
4000cb98:	00e7f7b3          	and	a5,a5,a4
4000cb9c:	01461613          	slli	a2,a2,0x14
4000cba0:	80000737          	lui	a4,0x80000
4000cba4:	00c7e7b3          	or	a5,a5,a2
4000cba8:	fff74713          	not	a4,a4
4000cbac:	01f51513          	slli	a0,a0,0x1f
4000cbb0:	00e7f7b3          	and	a5,a5,a4
4000cbb4:	00a7e7b3          	or	a5,a5,a0
4000cbb8:	00078593          	mv	a1,a5
4000cbbc:	00068513          	mv	a0,a3
4000cbc0:	02010113          	addi	sp,sp,32
4000cbc4:	00008067          	ret
4000cbc8:	16c05863          	blez	a2,4000cd38 <__trunctfdf2+0x288>
4000cbcc:	01412583          	lw	a1,20(sp)
4000cbd0:	01812803          	lw	a6,24(sp)
4000cbd4:	01c12703          	lw	a4,28(sp)
4000cbd8:	00459693          	slli	a3,a1,0x4
4000cbdc:	00f6e6b3          	or	a3,a3,a5
4000cbe0:	01c5d593          	srli	a1,a1,0x1c
4000cbe4:	00481793          	slli	a5,a6,0x4
4000cbe8:	00f5e5b3          	or	a1,a1,a5
4000cbec:	00d036b3          	snez	a3,a3
4000cbf0:	00471713          	slli	a4,a4,0x4
4000cbf4:	01c85813          	srli	a6,a6,0x1c
4000cbf8:	00b6e6b3          	or	a3,a3,a1
4000cbfc:	01076733          	or	a4,a4,a6
4000cc00:	0076f793          	andi	a5,a3,7
4000cc04:	0e078c63          	beqz	a5,4000ccfc <__trunctfdf2+0x24c>
4000cc08:	00f6f793          	andi	a5,a3,15
4000cc0c:	00400593          	li	a1,4
4000cc10:	0eb78663          	beq	a5,a1,4000ccfc <__trunctfdf2+0x24c>
4000cc14:	00468793          	addi	a5,a3,4
4000cc18:	00d7b6b3          	sltu	a3,a5,a3
4000cc1c:	00d70733          	add	a4,a4,a3
4000cc20:	008005b7          	lui	a1,0x800
4000cc24:	00b775b3          	and	a1,a4,a1
4000cc28:	06058063          	beqz	a1,4000cc88 <__trunctfdf2+0x1d8>
4000cc2c:	00160613          	addi	a2,a2,1
4000cc30:	7ff00693          	li	a3,2047
4000cc34:	0ed60c63          	beq	a2,a3,4000cd2c <__trunctfdf2+0x27c>
4000cc38:	ff8006b7          	lui	a3,0xff800
4000cc3c:	fff68693          	addi	a3,a3,-1 # ff7fffff <end+0xbf7ef21f>
4000cc40:	00d77733          	and	a4,a4,a3
4000cc44:	0037d793          	srli	a5,a5,0x3
4000cc48:	01d71693          	slli	a3,a4,0x1d
4000cc4c:	00971713          	slli	a4,a4,0x9
4000cc50:	00f6e6b3          	or	a3,a3,a5
4000cc54:	7ff67613          	andi	a2,a2,2047
4000cc58:	00c75793          	srli	a5,a4,0xc
4000cc5c:	f29ff06f          	j	4000cb84 <__trunctfdf2+0xd4>
4000cc60:	04061a63          	bnez	a2,4000ccb4 <__trunctfdf2+0x204>
4000cc64:	01812683          	lw	a3,24(sp)
4000cc68:	01412703          	lw	a4,20(sp)
4000cc6c:	00d76733          	or	a4,a4,a3
4000cc70:	01c12683          	lw	a3,28(sp)
4000cc74:	00d76733          	or	a4,a4,a3
4000cc78:	00f76733          	or	a4,a4,a5
4000cc7c:	18070263          	beqz	a4,4000ce00 <__trunctfdf2+0x350>
4000cc80:	00000713          	li	a4,0
4000cc84:	00500793          	li	a5,5
4000cc88:	01d71693          	slli	a3,a4,0x1d
4000cc8c:	0037d793          	srli	a5,a5,0x3
4000cc90:	7ff00593          	li	a1,2047
4000cc94:	00d7e6b3          	or	a3,a5,a3
4000cc98:	00375713          	srli	a4,a4,0x3
4000cc9c:	06b60863          	beq	a2,a1,4000cd0c <__trunctfdf2+0x25c>
4000cca0:	001007b7          	lui	a5,0x100
4000cca4:	fff78793          	addi	a5,a5,-1 # fffff <_heap_size+0xfdfff>
4000cca8:	00f777b3          	and	a5,a4,a5
4000ccac:	7ff67613          	andi	a2,a2,2047
4000ccb0:	ed5ff06f          	j	4000cb84 <__trunctfdf2+0xd4>
4000ccb4:	01412583          	lw	a1,20(sp)
4000ccb8:	01812803          	lw	a6,24(sp)
4000ccbc:	01c12703          	lw	a4,28(sp)
4000ccc0:	7ff00613          	li	a2,2047
4000ccc4:	0105e8b3          	or	a7,a1,a6
4000ccc8:	00e8e8b3          	or	a7,a7,a4
4000cccc:	00f8e6b3          	or	a3,a7,a5
4000ccd0:	00000793          	li	a5,0
4000ccd4:	ea0688e3          	beqz	a3,4000cb84 <__trunctfdf2+0xd4>
4000ccd8:	01c5d693          	srli	a3,a1,0x1c
4000ccdc:	00471713          	slli	a4,a4,0x4
4000cce0:	00481593          	slli	a1,a6,0x4
4000cce4:	01c85793          	srli	a5,a6,0x1c
4000cce8:	00e7e7b3          	or	a5,a5,a4
4000ccec:	00b6e6b3          	or	a3,a3,a1
4000ccf0:	00400737          	lui	a4,0x400
4000ccf4:	ff86f693          	andi	a3,a3,-8
4000ccf8:	00e7e733          	or	a4,a5,a4
4000ccfc:	008005b7          	lui	a1,0x800
4000cd00:	00b775b3          	and	a1,a4,a1
4000cd04:	00068793          	mv	a5,a3
4000cd08:	f21ff06f          	j	4000cc28 <__trunctfdf2+0x178>
4000cd0c:	00e6e7b3          	or	a5,a3,a4
4000cd10:	18078a63          	beqz	a5,4000cea4 <__trunctfdf2+0x3f4>
4000cd14:	000807b7          	lui	a5,0x80
4000cd18:	00f767b3          	or	a5,a4,a5
4000cd1c:	00100737          	lui	a4,0x100
4000cd20:	fff70713          	addi	a4,a4,-1 # fffff <_heap_size+0xfdfff>
4000cd24:	00e7f7b3          	and	a5,a5,a4
4000cd28:	e5dff06f          	j	4000cb84 <__trunctfdf2+0xd4>
4000cd2c:	00000793          	li	a5,0
4000cd30:	00000693          	li	a3,0
4000cd34:	e51ff06f          	j	4000cb84 <__trunctfdf2+0xd4>
4000cd38:	fcc00713          	li	a4,-52
4000cd3c:	0ce64663          	blt	a2,a4,4000ce08 <__trunctfdf2+0x358>
4000cd40:	03d00593          	li	a1,61
4000cd44:	01c12303          	lw	t1,28(sp)
4000cd48:	40c58633          	sub	a2,a1,a2
4000cd4c:	40565f13          	srai	t5,a2,0x5
4000cd50:	00080737          	lui	a4,0x80
4000cd54:	00e36333          	or	t1,t1,a4
4000cd58:	002f1813          	slli	a6,t5,0x2
4000cd5c:	01f67593          	andi	a1,a2,31
4000cd60:	01010713          	addi	a4,sp,16
4000cd64:	01010613          	addi	a2,sp,16
4000cd68:	00000693          	li	a3,0
4000cd6c:	00612e23          	sw	t1,28(sp)
4000cd70:	01070733          	add	a4,a4,a6
4000cd74:	00460613          	addi	a2,a2,4
4000cd78:	00f6e6b3          	or	a3,a3,a5
4000cd7c:	00c70a63          	beq	a4,a2,4000cd90 <__trunctfdf2+0x2e0>
4000cd80:	00062783          	lw	a5,0(a2)
4000cd84:	00460613          	addi	a2,a2,4
4000cd88:	00f6e6b3          	or	a3,a3,a5
4000cd8c:	fec71ae3          	bne	a4,a2,4000cd80 <__trunctfdf2+0x2d0>
4000cd90:	08059263          	bnez	a1,4000ce14 <__trunctfdf2+0x364>
4000cd94:	00400793          	li	a5,4
4000cd98:	41e787b3          	sub	a5,a5,t5
4000cd9c:	00279793          	slli	a5,a5,0x2
4000cda0:	01010713          	addi	a4,sp,16
4000cda4:	00f707b3          	add	a5,a4,a5
4000cda8:	00062703          	lw	a4,0(a2)
4000cdac:	00488893          	addi	a7,a7,4
4000cdb0:	00460613          	addi	a2,a2,4
4000cdb4:	fee8ae23          	sw	a4,-4(a7)
4000cdb8:	ff1798e3          	bne	a5,a7,4000cda8 <__trunctfdf2+0x2f8>
4000cdbc:	00400713          	li	a4,4
4000cdc0:	41e70733          	sub	a4,a4,t5
4000cdc4:	01010613          	addi	a2,sp,16
4000cdc8:	00271793          	slli	a5,a4,0x2
4000cdcc:	00f607b3          	add	a5,a2,a5
4000cdd0:	00400613          	li	a2,4
4000cdd4:	0007a023          	sw	zero,0(a5) # 80000 <_heap_size+0x7e000>
4000cdd8:	00170713          	addi	a4,a4,1 # 80001 <_heap_size+0x7e001>
4000cddc:	00478793          	addi	a5,a5,4
4000cde0:	fec71ae3          	bne	a4,a2,4000cdd4 <__trunctfdf2+0x324>
4000cde4:	01012783          	lw	a5,16(sp)
4000cde8:	00d036b3          	snez	a3,a3
4000cdec:	01412703          	lw	a4,20(sp)
4000cdf0:	00f6e6b3          	or	a3,a3,a5
4000cdf4:	0076f793          	andi	a5,a3,7
4000cdf8:	00000613          	li	a2,0
4000cdfc:	e09ff06f          	j	4000cc04 <__trunctfdf2+0x154>
4000ce00:	00000693          	li	a3,0
4000ce04:	e9dff06f          	j	4000cca0 <__trunctfdf2+0x1f0>
4000ce08:	00000713          	li	a4,0
4000ce0c:	00000613          	li	a2,0
4000ce10:	e05ff06f          	j	4000cc14 <__trunctfdf2+0x164>
4000ce14:	02010793          	addi	a5,sp,32
4000ce18:	01078833          	add	a6,a5,a6
4000ce1c:	ff082783          	lw	a5,-16(a6)
4000ce20:	02000e93          	li	t4,32
4000ce24:	40be8eb3          	sub	t4,t4,a1
4000ce28:	00300e13          	li	t3,3
4000ce2c:	01d797b3          	sll	a5,a5,t4
4000ce30:	41ee0e33          	sub	t3,t3,t5
4000ce34:	00f6e6b3          	or	a3,a3,a5
4000ce38:	060e0063          	beqz	t3,4000ce98 <__trunctfdf2+0x3e8>
4000ce3c:	00000713          	li	a4,0
4000ce40:	0080006f          	j	4000ce48 <__trunctfdf2+0x398>
4000ce44:	00080713          	mv	a4,a6
4000ce48:	00062783          	lw	a5,0(a2)
4000ce4c:	00462303          	lw	t1,4(a2)
4000ce50:	00170813          	addi	a6,a4,1
4000ce54:	00b7d7b3          	srl	a5,a5,a1
4000ce58:	01d31333          	sll	t1,t1,t4
4000ce5c:	0067e7b3          	or	a5,a5,t1
4000ce60:	00f8a023          	sw	a5,0(a7)
4000ce64:	00460613          	addi	a2,a2,4
4000ce68:	00488893          	addi	a7,a7,4
4000ce6c:	fd0e1ce3          	bne	t3,a6,4000ce44 <__trunctfdf2+0x394>
4000ce70:	01c12303          	lw	t1,28(sp)
4000ce74:	00270713          	addi	a4,a4,2
4000ce78:	00281793          	slli	a5,a6,0x2
4000ce7c:	02010613          	addi	a2,sp,32
4000ce80:	00f607b3          	add	a5,a2,a5
4000ce84:	00b355b3          	srl	a1,t1,a1
4000ce88:	feb7a823          	sw	a1,-16(a5)
4000ce8c:	00300793          	li	a5,3
4000ce90:	f2e7dae3          	ble	a4,a5,4000cdc4 <__trunctfdf2+0x314>
4000ce94:	f51ff06f          	j	4000cde4 <__trunctfdf2+0x334>
4000ce98:	00000813          	li	a6,0
4000ce9c:	00100713          	li	a4,1
4000cea0:	fd9ff06f          	j	4000ce78 <__trunctfdf2+0x3c8>
4000cea4:	00000693          	li	a3,0
4000cea8:	00000793          	li	a5,0
4000ceac:	cd9ff06f          	j	4000cb84 <__trunctfdf2+0xd4>

4000ceb0 <__mulsi3>:
4000ceb0:	00050613          	mv	a2,a0
4000ceb4:	00000513          	li	a0,0
4000ceb8:	0015f693          	andi	a3,a1,1
4000cebc:	00068463          	beqz	a3,4000cec4 <__mulsi3+0x14>
4000cec0:	00c50533          	add	a0,a0,a2
4000cec4:	0015d593          	srli	a1,a1,0x1
4000cec8:	00161613          	slli	a2,a2,0x1
4000cecc:	fe0596e3          	bnez	a1,4000ceb8 <__mulsi3+0x8>
4000ced0:	00008067          	ret

4000ced4 <__divsi3>:
4000ced4:	06054063          	bltz	a0,4000cf34 <__umodsi3+0x10>
4000ced8:	0605c663          	bltz	a1,4000cf44 <__umodsi3+0x20>

4000cedc <__udivsi3>:
4000cedc:	00058613          	mv	a2,a1
4000cee0:	00050593          	mv	a1,a0
4000cee4:	fff00513          	li	a0,-1
4000cee8:	02060c63          	beqz	a2,4000cf20 <__udivsi3+0x44>
4000ceec:	00100693          	li	a3,1
4000cef0:	00b67a63          	bleu	a1,a2,4000cf04 <__udivsi3+0x28>
4000cef4:	00c05863          	blez	a2,4000cf04 <__udivsi3+0x28>
4000cef8:	00161613          	slli	a2,a2,0x1
4000cefc:	00169693          	slli	a3,a3,0x1
4000cf00:	feb66ae3          	bltu	a2,a1,4000cef4 <__udivsi3+0x18>
4000cf04:	00000513          	li	a0,0
4000cf08:	00c5e663          	bltu	a1,a2,4000cf14 <__udivsi3+0x38>
4000cf0c:	40c585b3          	sub	a1,a1,a2
4000cf10:	00d56533          	or	a0,a0,a3
4000cf14:	0016d693          	srli	a3,a3,0x1
4000cf18:	00165613          	srli	a2,a2,0x1
4000cf1c:	fe0696e3          	bnez	a3,4000cf08 <__udivsi3+0x2c>
4000cf20:	00008067          	ret

4000cf24 <__umodsi3>:
4000cf24:	00008293          	mv	t0,ra
4000cf28:	fb5ff0ef          	jal	ra,4000cedc <__udivsi3>
4000cf2c:	00058513          	mv	a0,a1
4000cf30:	00028067          	jr	t0
4000cf34:	40a00533          	neg	a0,a0
4000cf38:	0005d863          	bgez	a1,4000cf48 <__umodsi3+0x24>
4000cf3c:	40b005b3          	neg	a1,a1
4000cf40:	f9dff06f          	j	4000cedc <__udivsi3>
4000cf44:	40b005b3          	neg	a1,a1
4000cf48:	00008293          	mv	t0,ra
4000cf4c:	f91ff0ef          	jal	ra,4000cedc <__udivsi3>
4000cf50:	40a00533          	neg	a0,a0
4000cf54:	00028067          	jr	t0

4000cf58 <__modsi3>:
4000cf58:	00008293          	mv	t0,ra
4000cf5c:	0005ca63          	bltz	a1,4000cf70 <__modsi3+0x18>
4000cf60:	00054c63          	bltz	a0,4000cf78 <__modsi3+0x20>
4000cf64:	f79ff0ef          	jal	ra,4000cedc <__udivsi3>
4000cf68:	00058513          	mv	a0,a1
4000cf6c:	00028067          	jr	t0
4000cf70:	40b005b3          	neg	a1,a1
4000cf74:	fe0558e3          	bgez	a0,4000cf64 <__modsi3+0xc>
4000cf78:	40a00533          	neg	a0,a0
4000cf7c:	f61ff0ef          	jal	ra,4000cedc <__udivsi3>
4000cf80:	40b00533          	neg	a0,a1
4000cf84:	00028067          	jr	t0

4000cf88 <__clzsi2>:
4000cf88:	000107b7          	lui	a5,0x10
4000cf8c:	02f57c63          	bleu	a5,a0,4000cfc4 <__clzsi2+0x3c>
4000cf90:	0ff00713          	li	a4,255
4000cf94:	01800693          	li	a3,24
4000cf98:	00800793          	li	a5,8
4000cf9c:	00a76663          	bltu	a4,a0,4000cfa8 <__clzsi2+0x20>
4000cfa0:	02000693          	li	a3,32
4000cfa4:	00000793          	li	a5,0
4000cfa8:	4000e737          	lui	a4,0x4000e
4000cfac:	00f557b3          	srl	a5,a0,a5
4000cfb0:	b3470713          	addi	a4,a4,-1228 # 4000db34 <__clz_tab>
4000cfb4:	00e787b3          	add	a5,a5,a4
4000cfb8:	0007c503          	lbu	a0,0(a5) # 10000 <_heap_size+0xe000>
4000cfbc:	40a68533          	sub	a0,a3,a0
4000cfc0:	00008067          	ret
4000cfc4:	01000737          	lui	a4,0x1000
4000cfc8:	00800693          	li	a3,8
4000cfcc:	01800793          	li	a5,24
4000cfd0:	fce57ce3          	bleu	a4,a0,4000cfa8 <__clzsi2+0x20>
4000cfd4:	01000693          	li	a3,16
4000cfd8:	00068793          	mv	a5,a3
4000cfdc:	4000e737          	lui	a4,0x4000e
4000cfe0:	00f557b3          	srl	a5,a0,a5
4000cfe4:	b3470713          	addi	a4,a4,-1228 # 4000db34 <__clz_tab>
4000cfe8:	00e787b3          	add	a5,a5,a4
4000cfec:	0007c503          	lbu	a0,0(a5)
4000cff0:	40a68533          	sub	a0,a3,a0
4000cff4:	00008067          	ret
4000cff8:	4844                	lw	s1,20(s0)
4000cffa:	5952                	lw	s2,52(sp)
4000cffc:	4e4f5453          	0x4e4f5453
4000d000:	2045                	jal	4000d0a0 <__clzsi2+0x118>
4000d002:	5250                	lw	a2,36(a2)
4000d004:	4152474f          	fnmadd.s	fa4,ft4,fs5,fs0,rmm
4000d008:	2c4d                	jal	4000d2ba <__clzsi2+0x332>
4000d00a:	5320                	lw	s0,96(a4)
4000d00c:	20454d4f          	fnmadd.s	fs10,fa0,ft4,ft4,rmm
4000d010:	49525453          	0x49525453
4000d014:	474e                	lw	a4,208(sp)
4000d016:	0000                	unimp
4000d018:	6844                	flw	fs1,20(s0)
4000d01a:	7972                	flw	fs2,60(sp)
4000d01c:	6e6f7473          	csrrci	s0,0x6e6,30
4000d020:	2065                	jal	4000d0c8 <__clzsi2+0x140>
4000d022:	6542                	flw	fa0,16(sp)
4000d024:	636e                	flw	ft6,216(sp)
4000d026:	6d68                	flw	fa0,92(a0)
4000d028:	7261                	lui	tp,0xffff8
4000d02a:	56202c6b          	0x56202c6b
4000d02e:	7265                	lui	tp,0xffff9
4000d030:	6e6f6973          	csrrsi	s2,0x6e6,30
4000d034:	3220                	fld	fs0,96(a2)
4000d036:	312e                	fld	ft2,232(sp)
4000d038:	2820                	fld	fs0,80(s0)
4000d03a:	614c                	flw	fa1,4(a0)
4000d03c:	676e                	flw	fa4,216(sp)
4000d03e:	6175                	addi	sp,sp,368
4000d040:	203a6567          	0x203a6567
4000d044:	000a2943          	fmadd.s	fs2,fs4,ft0,ft0,rdn
4000d048:	7250                	flw	fa2,36(a2)
4000d04a:	6172676f          	jal	a4,40033e60 <end+0x23080>
4000d04e:	206d                	jal	4000d0f8 <__clzsi2+0x170>
4000d050:	706d6f63          	bltu	s10,t1,4000d76e <zeroes.4139+0x5a>
4000d054:	6c69                	lui	s8,0x1a
4000d056:	6465                	lui	s0,0x19
4000d058:	7720                	flw	fs0,104(a4)
4000d05a:	7469                	lui	s0,0xffffa
4000d05c:	2068                	fld	fa0,192(s0)
4000d05e:	67657227          	0x67657227
4000d062:	7369                	lui	t1,0xffffa
4000d064:	6574                	flw	fa3,76(a0)
4000d066:	2772                	fld	fa4,280(sp)
4000d068:	6120                	flw	fs0,64(a0)
4000d06a:	7474                	flw	fa3,108(s0)
4000d06c:	6972                	flw	fs2,28(sp)
4000d06e:	7562                	flw	fa0,56(sp)
4000d070:	6574                	flw	fa3,76(a0)
4000d072:	000a                	0xa
4000d074:	7250                	flw	fa2,36(a2)
4000d076:	6172676f          	jal	a4,40033e8c <end+0x230ac>
4000d07a:	206d                	jal	4000d124 <__clzsi2+0x19c>
4000d07c:	706d6f63          	bltu	s10,t1,4000d79a <__mprec_tens+0x2>
4000d080:	6c69                	lui	s8,0x1a
4000d082:	6465                	lui	s0,0x19
4000d084:	7720                	flw	fs0,104(a4)
4000d086:	7469                	lui	s0,0xffffa
4000d088:	6f68                	flw	fa0,92(a4)
4000d08a:	7475                	lui	s0,0xffffd
4000d08c:	2720                	fld	fs0,72(a4)
4000d08e:	6572                	flw	fa0,28(sp)
4000d090:	74736967          	0x74736967
4000d094:	7265                	lui	tp,0xffff9
4000d096:	74612027          	fsw	ft6,1856(sp)
4000d09a:	7274                	flw	fa3,100(a2)
4000d09c:	6269                	lui	tp,0x1a
4000d09e:	7475                	lui	s0,0xffffd
4000d0a0:	0a65                	addi	s4,s4,25
4000d0a2:	0000                	unimp
4000d0a4:	6c50                	flw	fa2,28(s0)
4000d0a6:	6165                	addi	sp,sp,112
4000d0a8:	67206573          	csrrsi	a0,0x672,0
4000d0ac:	7669                	lui	a2,0xffffa
4000d0ae:	2065                	jal	4000d156 <__clzsi2+0x1ce>
4000d0b0:	6874                	flw	fa3,84(s0)
4000d0b2:	2065                	jal	4000d15a <__clzsi2+0x1d2>
4000d0b4:	756e                	flw	fa0,248(sp)
4000d0b6:	626d                	lui	tp,0x1b
4000d0b8:	7265                	lui	tp,0xffff9
4000d0ba:	6f20                	flw	fs0,88(a4)
4000d0bc:	2066                	fld	ft0,88(sp)
4000d0be:	7572                	flw	fa0,60(sp)
4000d0c0:	736e                	flw	ft6,248(sp)
4000d0c2:	7420                	flw	fs0,104(s0)
4000d0c4:	7268                	flw	fa0,100(a2)
4000d0c6:	6867756f          	jal	a0,4008474c <end+0x7396c>
4000d0ca:	7420                	flw	fs0,104(s0)
4000d0cc:	6568                	flw	fa0,76(a0)
4000d0ce:	6220                	flw	fs0,64(a2)
4000d0d0:	6e65                	lui	t3,0x19
4000d0d2:	616d6863          	bltu	s10,s6,4000d6e2 <__clzsi2+0x75a>
4000d0d6:	6b72                	flw	fs6,28(sp)
4000d0d8:	203a                	fld	ft0,392(sp)
4000d0da:	0000                	unimp
4000d0dc:	7845                	lui	a6,0xffff1
4000d0de:	6365                	lui	t1,0x19
4000d0e0:	7475                	lui	s0,0xffffd
4000d0e2:	6f69                	lui	t5,0x1a
4000d0e4:	206e                	fld	ft0,216(sp)
4000d0e6:	72617473          	csrrci	s0,0x726,2
4000d0ea:	7374                	flw	fa3,100(a4)
4000d0ec:	202c                	fld	fa1,64(s0)
4000d0ee:	6425                	lui	s0,0x9
4000d0f0:	7220                	flw	fs0,96(a2)
4000d0f2:	6e75                	lui	t3,0x1d
4000d0f4:	68742073          	csrs	0x687,s0
4000d0f8:	6f72                	flw	ft10,28(sp)
4000d0fa:	6775                	lui	a4,0x1d
4000d0fc:	2068                	fld	fa0,192(s0)
4000d0fe:	6844                	flw	fs1,20(s0)
4000d100:	7972                	flw	fs2,60(sp)
4000d102:	6e6f7473          	csrrci	s0,0x6e6,30
4000d106:	0a65                	addi	s4,s4,25
4000d108:	0000                	unimp
4000d10a:	0000                	unimp
4000d10c:	7845                	lui	a6,0xffff1
4000d10e:	6365                	lui	t1,0x19
4000d110:	7475                	lui	s0,0xffffd
4000d112:	6f69                	lui	t5,0x1a
4000d114:	206e                	fld	ft0,216(sp)
4000d116:	6e65                	lui	t3,0x19
4000d118:	7364                	flw	fs1,100(a4)
4000d11a:	000a                	0xa
4000d11c:	6946                	flw	fs2,80(sp)
4000d11e:	616e                	flw	ft2,216(sp)
4000d120:	206c                	fld	fa1,192(s0)
4000d122:	6176                	flw	ft2,92(sp)
4000d124:	756c                	flw	fa1,108(a0)
4000d126:	7365                	lui	t1,0xffff9
4000d128:	6f20                	flw	fs0,88(a4)
4000d12a:	2066                	fld	ft0,88(sp)
4000d12c:	6874                	flw	fa3,84(s0)
4000d12e:	2065                	jal	4000d1d6 <__clzsi2+0x24e>
4000d130:	6176                	flw	ft2,92(sp)
4000d132:	6972                	flw	fs2,28(sp)
4000d134:	6261                	lui	tp,0x18
4000d136:	656c                	flw	fa1,76(a0)
4000d138:	73752073          	csrs	0x737,a0
4000d13c:	6465                	lui	s0,0x19
4000d13e:	6920                	flw	fs0,80(a0)
4000d140:	206e                	fld	ft0,216(sp)
4000d142:	6874                	flw	fa3,84(s0)
4000d144:	2065                	jal	4000d1ec <__clzsi2+0x264>
4000d146:	6562                	flw	fa0,24(sp)
4000d148:	636e                	flw	ft6,216(sp)
4000d14a:	6d68                	flw	fa0,92(a0)
4000d14c:	7261                	lui	tp,0xffff8
4000d14e:	000a3a6b          	0xa3a6b
4000d152:	0000                	unimp
4000d154:	6e49                	lui	t3,0x12
4000d156:	5f74                	lw	a3,124(a4)
4000d158:	626f6c47          	fmsub.d	fs8,ft10,ft6,fa2,unknown
4000d15c:	203a                	fld	ft0,392(sp)
4000d15e:	2020                	fld	fs0,64(s0)
4000d160:	2020                	fld	fs0,64(s0)
4000d162:	2020                	fld	fs0,64(s0)
4000d164:	2020                	fld	fs0,64(s0)
4000d166:	2020                	fld	fs0,64(s0)
4000d168:	2520                	fld	fs0,72(a0)
4000d16a:	0a64                	addi	s1,sp,284
4000d16c:	0000                	unimp
4000d16e:	0000                	unimp
4000d170:	2020                	fld	fs0,64(s0)
4000d172:	2020                	fld	fs0,64(s0)
4000d174:	2020                	fld	fs0,64(s0)
4000d176:	2020                	fld	fs0,64(s0)
4000d178:	756f6873          	csrrsi	a6,0x756,30
4000d17c:	646c                	flw	fa1,76(s0)
4000d17e:	6220                	flw	fs0,64(a2)
4000d180:	3a65                	jal	4000cb38 <__trunctfdf2+0x88>
4000d182:	2020                	fld	fs0,64(s0)
4000d184:	2520                	fld	fs0,72(a0)
4000d186:	0a64                	addi	s1,sp,284
4000d188:	0000                	unimp
4000d18a:	0000                	unimp
4000d18c:	6f42                	flw	ft10,16(sp)
4000d18e:	475f6c6f          	jal	s8,40103e02 <end+0xf3022>
4000d192:	6f6c                	flw	fa1,92(a4)
4000d194:	3a62                	fld	fs4,56(sp)
4000d196:	2020                	fld	fs0,64(s0)
4000d198:	2020                	fld	fs0,64(s0)
4000d19a:	2020                	fld	fs0,64(s0)
4000d19c:	2020                	fld	fs0,64(s0)
4000d19e:	2020                	fld	fs0,64(s0)
4000d1a0:	2520                	fld	fs0,72(a0)
4000d1a2:	0a64                	addi	s1,sp,284
4000d1a4:	0000                	unimp
4000d1a6:	0000                	unimp
4000d1a8:	315f6843          	fmadd.s	fa6,ft10,fs5,ft6,unknown
4000d1ac:	475f 6f6c 3a62      	0x3a626f6c475f
4000d1b2:	2020                	fld	fs0,64(s0)
4000d1b4:	2020                	fld	fs0,64(s0)
4000d1b6:	2020                	fld	fs0,64(s0)
4000d1b8:	2020                	fld	fs0,64(s0)
4000d1ba:	2020                	fld	fs0,64(s0)
4000d1bc:	2520                	fld	fs0,72(a0)
4000d1be:	00000a63          	beqz	zero,4000d1d2 <__clzsi2+0x24a>
4000d1c2:	0000                	unimp
4000d1c4:	2020                	fld	fs0,64(s0)
4000d1c6:	2020                	fld	fs0,64(s0)
4000d1c8:	2020                	fld	fs0,64(s0)
4000d1ca:	2020                	fld	fs0,64(s0)
4000d1cc:	756f6873          	csrrsi	a6,0x756,30
4000d1d0:	646c                	flw	fa1,76(s0)
4000d1d2:	6220                	flw	fs0,64(a2)
4000d1d4:	3a65                	jal	4000cb8c <__trunctfdf2+0xdc>
4000d1d6:	2020                	fld	fs0,64(s0)
4000d1d8:	2520                	fld	fs0,72(a0)
4000d1da:	00000a63          	beqz	zero,4000d1ee <__clzsi2+0x266>
4000d1de:	0000                	unimp
4000d1e0:	325f6843          	fmadd.d	fa6,ft10,ft5,ft6,unknown
4000d1e4:	475f 6f6c 3a62      	0x3a626f6c475f
4000d1ea:	2020                	fld	fs0,64(s0)
4000d1ec:	2020                	fld	fs0,64(s0)
4000d1ee:	2020                	fld	fs0,64(s0)
4000d1f0:	2020                	fld	fs0,64(s0)
4000d1f2:	2020                	fld	fs0,64(s0)
4000d1f4:	2520                	fld	fs0,72(a0)
4000d1f6:	00000a63          	beqz	zero,4000d20a <__clzsi2+0x282>
4000d1fa:	0000                	unimp
4000d1fc:	7241                	lui	tp,0xffff0
4000d1fe:	5f72                	lw	t5,60(sp)
4000d200:	5f31                	li	t5,-20
4000d202:	626f6c47          	fmsub.d	fs8,ft10,ft6,fa2,unknown
4000d206:	3a5d385b          	0x3a5d385b
4000d20a:	2020                	fld	fs0,64(s0)
4000d20c:	2020                	fld	fs0,64(s0)
4000d20e:	2020                	fld	fs0,64(s0)
4000d210:	2520                	fld	fs0,72(a0)
4000d212:	0a64                	addi	s1,sp,284
4000d214:	0000                	unimp
4000d216:	0000                	unimp
4000d218:	7241                	lui	tp,0xffff0
4000d21a:	5f72                	lw	t5,60(sp)
4000d21c:	5f32                	lw	t5,44(sp)
4000d21e:	626f6c47          	fmsub.d	fs8,ft10,ft6,fa2,unknown
4000d222:	5b5d385b          	0x5b5d385b
4000d226:	203a5d37          	lui	s10,0x203a5
4000d22a:	2020                	fld	fs0,64(s0)
4000d22c:	2520                	fld	fs0,72(a0)
4000d22e:	0a64                	addi	s1,sp,284
4000d230:	0000                	unimp
4000d232:	0000                	unimp
4000d234:	2020                	fld	fs0,64(s0)
4000d236:	2020                	fld	fs0,64(s0)
4000d238:	2020                	fld	fs0,64(s0)
4000d23a:	2020                	fld	fs0,64(s0)
4000d23c:	756f6873          	csrrsi	a6,0x756,30
4000d240:	646c                	flw	fa1,76(s0)
4000d242:	6220                	flw	fs0,64(a2)
4000d244:	3a65                	jal	4000cbfc <__trunctfdf2+0x14c>
4000d246:	2020                	fld	fs0,64(s0)
4000d248:	4e20                	lw	s0,88(a2)
4000d24a:	6d75                	lui	s10,0x1d
4000d24c:	6562                	flw	fa0,24(sp)
4000d24e:	5f72                	lw	t5,60(sp)
4000d250:	525f664f          	fnmadd.d	fa2,ft10,ft5,fa0,unknown
4000d254:	6e75                	lui	t3,0x1d
4000d256:	202b2073          	csrs	0x202,s6
4000d25a:	3031                	jal	4000ca66 <__truncdfsf2+0x1ae>
4000d25c:	000a                	0xa
4000d25e:	0000                	unimp
4000d260:	7450                	flw	fa2,44(s0)
4000d262:	5f72                	lw	t5,60(sp)
4000d264:	626f6c47          	fmsub.d	fs8,ft10,ft6,fa2,unknown
4000d268:	3e2d                	jal	4000cda2 <__trunctfdf2+0x2f2>
4000d26a:	000a                	0xa
4000d26c:	2020                	fld	fs0,64(s0)
4000d26e:	7450                	flw	fa2,44(s0)
4000d270:	5f72                	lw	t5,60(sp)
4000d272:	706d6f43          	fmadd.s	ft10,fs10,ft6,fa4,unknown
4000d276:	203a                	fld	ft0,392(sp)
4000d278:	2020                	fld	fs0,64(s0)
4000d27a:	2020                	fld	fs0,64(s0)
4000d27c:	2020                	fld	fs0,64(s0)
4000d27e:	2020                	fld	fs0,64(s0)
4000d280:	2520                	fld	fs0,72(a0)
4000d282:	0a64                	addi	s1,sp,284
4000d284:	0000                	unimp
4000d286:	0000                	unimp
4000d288:	2020                	fld	fs0,64(s0)
4000d28a:	2020                	fld	fs0,64(s0)
4000d28c:	2020                	fld	fs0,64(s0)
4000d28e:	2020                	fld	fs0,64(s0)
4000d290:	756f6873          	csrrsi	a6,0x756,30
4000d294:	646c                	flw	fa1,76(s0)
4000d296:	6220                	flw	fs0,64(a2)
4000d298:	3a65                	jal	4000cc50 <__trunctfdf2+0x1a0>
4000d29a:	2020                	fld	fs0,64(s0)
4000d29c:	2820                	fld	fs0,80(s0)
4000d29e:	6d69                	lui	s10,0x1a
4000d2a0:	6c70                	flw	fa2,92(s0)
4000d2a2:	6d65                	lui	s10,0x19
4000d2a4:	6e65                	lui	t3,0x19
4000d2a6:	6174                	flw	fa3,68(a0)
4000d2a8:	6974                	flw	fa3,84(a0)
4000d2aa:	642d6e6f          	jal	t3,400e38ec <end+0xd2b0c>
4000d2ae:	7065                	0x7065
4000d2b0:	6e65                	lui	t3,0x19
4000d2b2:	6564                	flw	fs1,76(a0)
4000d2b4:	746e                	flw	fs0,248(sp)
4000d2b6:	0a29                	addi	s4,s4,10
4000d2b8:	0000                	unimp
4000d2ba:	0000                	unimp
4000d2bc:	2020                	fld	fs0,64(s0)
4000d2be:	6944                	flw	fs1,20(a0)
4000d2c0:	3a726373          	csrrsi	t1,0x3a7,4
4000d2c4:	2020                	fld	fs0,64(s0)
4000d2c6:	2020                	fld	fs0,64(s0)
4000d2c8:	2020                	fld	fs0,64(s0)
4000d2ca:	2020                	fld	fs0,64(s0)
4000d2cc:	2020                	fld	fs0,64(s0)
4000d2ce:	2020                	fld	fs0,64(s0)
4000d2d0:	2520                	fld	fs0,72(a0)
4000d2d2:	0a64                	addi	s1,sp,284
4000d2d4:	0000                	unimp
4000d2d6:	0000                	unimp
4000d2d8:	2020                	fld	fs0,64(s0)
4000d2da:	6e45                	lui	t3,0x11
4000d2dc:	6d75                	lui	s10,0x1d
4000d2de:	435f 6d6f 3a70      	0x3a706d6f435f
4000d2e4:	2020                	fld	fs0,64(s0)
4000d2e6:	2020                	fld	fs0,64(s0)
4000d2e8:	2020                	fld	fs0,64(s0)
4000d2ea:	2020                	fld	fs0,64(s0)
4000d2ec:	2520                	fld	fs0,72(a0)
4000d2ee:	0a64                	addi	s1,sp,284
4000d2f0:	0000                	unimp
4000d2f2:	0000                	unimp
4000d2f4:	2020                	fld	fs0,64(s0)
4000d2f6:	6e49                	lui	t3,0x12
4000d2f8:	5f74                	lw	a3,124(a4)
4000d2fa:	706d6f43          	fmadd.s	ft10,fs10,ft6,fa4,unknown
4000d2fe:	203a                	fld	ft0,392(sp)
4000d300:	2020                	fld	fs0,64(s0)
4000d302:	2020                	fld	fs0,64(s0)
4000d304:	2020                	fld	fs0,64(s0)
4000d306:	2020                	fld	fs0,64(s0)
4000d308:	2520                	fld	fs0,72(a0)
4000d30a:	0a64                	addi	s1,sp,284
4000d30c:	0000                	unimp
4000d30e:	0000                	unimp
4000d310:	2020                	fld	fs0,64(s0)
4000d312:	5f727453          	0x5f727453
4000d316:	706d6f43          	fmadd.s	ft10,fs10,ft6,fa4,unknown
4000d31a:	203a                	fld	ft0,392(sp)
4000d31c:	2020                	fld	fs0,64(s0)
4000d31e:	2020                	fld	fs0,64(s0)
4000d320:	2020                	fld	fs0,64(s0)
4000d322:	2020                	fld	fs0,64(s0)
4000d324:	2520                	fld	fs0,72(a0)
4000d326:	00000a73          	0xa73
4000d32a:	0000                	unimp
4000d32c:	2020                	fld	fs0,64(s0)
4000d32e:	2020                	fld	fs0,64(s0)
4000d330:	2020                	fld	fs0,64(s0)
4000d332:	2020                	fld	fs0,64(s0)
4000d334:	756f6873          	csrrsi	a6,0x756,30
4000d338:	646c                	flw	fa1,76(s0)
4000d33a:	6220                	flw	fs0,64(a2)
4000d33c:	3a65                	jal	4000ccf4 <__trunctfdf2+0x244>
4000d33e:	2020                	fld	fs0,64(s0)
4000d340:	4420                	lw	s0,72(s0)
4000d342:	5248                	lw	a0,36(a2)
4000d344:	5359                	li	t1,-10
4000d346:	4f54                	lw	a3,28(a4)
4000d348:	454e                	lw	a0,208(sp)
4000d34a:	5020                	lw	s0,96(s0)
4000d34c:	4f52                	lw	t5,20(sp)
4000d34e:	4d415247          	0x4d415247
4000d352:	202c                	fld	fa1,64(s0)
4000d354:	454d4f53          	0x454d4f53
4000d358:	5320                	lw	s0,96(a4)
4000d35a:	5254                	lw	a3,36(a2)
4000d35c:	4e49                	li	t3,18
4000d35e:	00000a47          	fmsub.s	fs4,ft0,ft0,ft0,rne
4000d362:	0000                	unimp
4000d364:	654e                	flw	fa0,208(sp)
4000d366:	7478                	flw	fa4,108(s0)
4000d368:	505f 7274 475f      	0x475f7274505f
4000d36e:	6f6c                	flw	fa1,92(a4)
4000d370:	2d62                	fld	fs10,24(sp)
4000d372:	0a3e                	slli	s4,s4,0xf
4000d374:	0000                	unimp
4000d376:	0000                	unimp
4000d378:	2020                	fld	fs0,64(s0)
4000d37a:	2020                	fld	fs0,64(s0)
4000d37c:	2020                	fld	fs0,64(s0)
4000d37e:	2020                	fld	fs0,64(s0)
4000d380:	756f6873          	csrrsi	a6,0x756,30
4000d384:	646c                	flw	fa1,76(s0)
4000d386:	6220                	flw	fs0,64(a2)
4000d388:	3a65                	jal	4000cd40 <__trunctfdf2+0x290>
4000d38a:	2020                	fld	fs0,64(s0)
4000d38c:	2820                	fld	fs0,80(s0)
4000d38e:	6d69                	lui	s10,0x1a
4000d390:	6c70                	flw	fa2,92(s0)
4000d392:	6d65                	lui	s10,0x19
4000d394:	6e65                	lui	t3,0x19
4000d396:	6174                	flw	fa3,68(a0)
4000d398:	6974                	flw	fa3,84(a0)
4000d39a:	642d6e6f          	jal	t3,400e39dc <end+0xd2bfc>
4000d39e:	7065                	0x7065
4000d3a0:	6e65                	lui	t3,0x19
4000d3a2:	6564                	flw	fs1,76(a0)
4000d3a4:	746e                	flw	fs0,248(sp)
4000d3a6:	2c29                	jal	4000d5c0 <__clzsi2+0x638>
4000d3a8:	7320                	flw	fs0,96(a4)
4000d3aa:	6d61                	lui	s10,0x18
4000d3ac:	2065                	jal	4000d454 <__clzsi2+0x4cc>
4000d3ae:	7361                	lui	t1,0xffff8
4000d3b0:	6120                	flw	fs0,64(a0)
4000d3b2:	6f62                	flw	ft10,24(sp)
4000d3b4:	6576                	flw	fa0,92(sp)
4000d3b6:	000a                	0xa
4000d3b8:	6e49                	lui	t3,0x12
4000d3ba:	5f74                	lw	a3,124(a4)
4000d3bc:	5f31                	li	t5,-20
4000d3be:	6f4c                	flw	fa1,28(a4)
4000d3c0:	20203a63          	0x20203a63
4000d3c4:	2020                	fld	fs0,64(s0)
4000d3c6:	2020                	fld	fs0,64(s0)
4000d3c8:	2020                	fld	fs0,64(s0)
4000d3ca:	2020                	fld	fs0,64(s0)
4000d3cc:	2520                	fld	fs0,72(a0)
4000d3ce:	0a64                	addi	s1,sp,284
4000d3d0:	0000                	unimp
4000d3d2:	0000                	unimp
4000d3d4:	6e49                	lui	t3,0x12
4000d3d6:	5f74                	lw	a3,124(a4)
4000d3d8:	5f32                	lw	t5,44(sp)
4000d3da:	6f4c                	flw	fa1,28(a4)
4000d3dc:	20203a63          	0x20203a63
4000d3e0:	2020                	fld	fs0,64(s0)
4000d3e2:	2020                	fld	fs0,64(s0)
4000d3e4:	2020                	fld	fs0,64(s0)
4000d3e6:	2020                	fld	fs0,64(s0)
4000d3e8:	2520                	fld	fs0,72(a0)
4000d3ea:	0a64                	addi	s1,sp,284
4000d3ec:	0000                	unimp
4000d3ee:	0000                	unimp
4000d3f0:	6e49                	lui	t3,0x12
4000d3f2:	5f74                	lw	a3,124(a4)
4000d3f4:	6f4c5f33          	0x6f4c5f33
4000d3f8:	20203a63          	0x20203a63
4000d3fc:	2020                	fld	fs0,64(s0)
4000d3fe:	2020                	fld	fs0,64(s0)
4000d400:	2020                	fld	fs0,64(s0)
4000d402:	2020                	fld	fs0,64(s0)
4000d404:	2520                	fld	fs0,72(a0)
4000d406:	0a64                	addi	s1,sp,284
4000d408:	0000                	unimp
4000d40a:	0000                	unimp
4000d40c:	6e45                	lui	t3,0x11
4000d40e:	6d75                	lui	s10,0x1d
4000d410:	4c5f 636f 203a      	0x203a636f4c5f
4000d416:	2020                	fld	fs0,64(s0)
4000d418:	2020                	fld	fs0,64(s0)
4000d41a:	2020                	fld	fs0,64(s0)
4000d41c:	2020                	fld	fs0,64(s0)
4000d41e:	2020                	fld	fs0,64(s0)
4000d420:	2520                	fld	fs0,72(a0)
4000d422:	0a64                	addi	s1,sp,284
4000d424:	0000                	unimp
4000d426:	0000                	unimp
4000d428:	5f727453          	0x5f727453
4000d42c:	5f31                	li	t5,-20
4000d42e:	6f4c                	flw	fa1,28(a4)
4000d430:	20203a63          	0x20203a63
4000d434:	2020                	fld	fs0,64(s0)
4000d436:	2020                	fld	fs0,64(s0)
4000d438:	2020                	fld	fs0,64(s0)
4000d43a:	2020                	fld	fs0,64(s0)
4000d43c:	2520                	fld	fs0,72(a0)
4000d43e:	00000a73          	0xa73
4000d442:	0000                	unimp
4000d444:	2020                	fld	fs0,64(s0)
4000d446:	2020                	fld	fs0,64(s0)
4000d448:	2020                	fld	fs0,64(s0)
4000d44a:	2020                	fld	fs0,64(s0)
4000d44c:	756f6873          	csrrsi	a6,0x756,30
4000d450:	646c                	flw	fa1,76(s0)
4000d452:	6220                	flw	fs0,64(a2)
4000d454:	3a65                	jal	4000ce0c <__trunctfdf2+0x35c>
4000d456:	2020                	fld	fs0,64(s0)
4000d458:	4420                	lw	s0,72(s0)
4000d45a:	5248                	lw	a0,36(a2)
4000d45c:	5359                	li	t1,-10
4000d45e:	4f54                	lw	a3,28(a4)
4000d460:	454e                	lw	a0,208(sp)
4000d462:	5020                	lw	s0,96(s0)
4000d464:	4f52                	lw	t5,20(sp)
4000d466:	4d415247          	0x4d415247
4000d46a:	202c                	fld	fa1,64(s0)
4000d46c:	2731                	jal	4000db78 <__clz_tab+0x44>
4000d46e:	53205453          	0x53205453
4000d472:	5254                	lw	a3,36(a2)
4000d474:	4e49                	li	t3,18
4000d476:	00000a47          	fmsub.s	fs4,ft0,ft0,ft0,rne
4000d47a:	0000                	unimp
4000d47c:	5f727453          	0x5f727453
4000d480:	5f32                	lw	t5,44(sp)
4000d482:	6f4c                	flw	fa1,28(a4)
4000d484:	20203a63          	0x20203a63
4000d488:	2020                	fld	fs0,64(s0)
4000d48a:	2020                	fld	fs0,64(s0)
4000d48c:	2020                	fld	fs0,64(s0)
4000d48e:	2020                	fld	fs0,64(s0)
4000d490:	2520                	fld	fs0,72(a0)
4000d492:	00000a73          	0xa73
4000d496:	0000                	unimp
4000d498:	2020                	fld	fs0,64(s0)
4000d49a:	2020                	fld	fs0,64(s0)
4000d49c:	2020                	fld	fs0,64(s0)
4000d49e:	2020                	fld	fs0,64(s0)
4000d4a0:	756f6873          	csrrsi	a6,0x756,30
4000d4a4:	646c                	flw	fa1,76(s0)
4000d4a6:	6220                	flw	fs0,64(a2)
4000d4a8:	3a65                	jal	4000ce60 <__trunctfdf2+0x3b0>
4000d4aa:	2020                	fld	fs0,64(s0)
4000d4ac:	4420                	lw	s0,72(s0)
4000d4ae:	5248                	lw	a0,36(a2)
4000d4b0:	5359                	li	t1,-10
4000d4b2:	4f54                	lw	a3,28(a4)
4000d4b4:	454e                	lw	a0,208(sp)
4000d4b6:	5020                	lw	s0,96(s0)
4000d4b8:	4f52                	lw	t5,20(sp)
4000d4ba:	4d415247          	0x4d415247
4000d4be:	202c                	fld	fa1,64(s0)
4000d4c0:	2732                	fld	fa4,264(sp)
4000d4c2:	444e                	lw	s0,208(sp)
4000d4c4:	5320                	lw	s0,96(a4)
4000d4c6:	5254                	lw	a3,36(a2)
4000d4c8:	4e49                	li	t3,18
4000d4ca:	00000a47          	fmsub.s	fs4,ft0,ft0,ft0,rne
4000d4ce:	0000                	unimp
4000d4d0:	654d                	lui	a0,0x13
4000d4d2:	7361                	lui	t1,0xffff8
4000d4d4:	7275                	lui	tp,0xffffd
4000d4d6:	6465                	lui	s0,0x19
4000d4d8:	7420                	flw	fs0,104(s0)
4000d4da:	6d69                	lui	s10,0x1a
4000d4dc:	2065                	jal	4000d584 <__clzsi2+0x5fc>
4000d4de:	6f74                	flw	fa3,92(a4)
4000d4e0:	6d73206f          	j	400403b6 <end+0x2f5d6>
4000d4e4:	6c61                	lui	s8,0x18
4000d4e6:	206c                	fld	fa1,192(s0)
4000d4e8:	6f74                	flw	fa3,92(a4)
4000d4ea:	6f20                	flw	fs0,88(a4)
4000d4ec:	7462                	flw	fs0,56(sp)
4000d4ee:	6961                	lui	s2,0x18
4000d4f0:	206e                	fld	ft0,216(sp)
4000d4f2:	656d                	lui	a0,0x1b
4000d4f4:	6e61                	lui	t3,0x18
4000d4f6:	6e69                	lui	t3,0x1a
4000d4f8:	6c756667          	0x6c756667
4000d4fc:	7220                	flw	fs0,96(a2)
4000d4fe:	7365                	lui	t1,0xffff9
4000d500:	6c75                	lui	s8,0x1d
4000d502:	7374                	flw	fa3,100(a4)
4000d504:	000a                	0xa
4000d506:	0000                	unimp
4000d508:	6c50                	flw	fa2,28(s0)
4000d50a:	6165                	addi	sp,sp,112
4000d50c:	69206573          	csrrsi	a0,0x692,0
4000d510:	636e                	flw	ft6,216(sp)
4000d512:	6572                	flw	fa0,28(sp)
4000d514:	7361                	lui	t1,0xffff8
4000d516:	2065                	jal	4000d5be <__clzsi2+0x636>
4000d518:	756e                	flw	fa0,248(sp)
4000d51a:	626d                	lui	tp,0x1b
4000d51c:	7265                	lui	tp,0xffff9
4000d51e:	6f20                	flw	fs0,88(a4)
4000d520:	2066                	fld	ft0,88(sp)
4000d522:	7572                	flw	fa0,60(sp)
4000d524:	736e                	flw	ft6,248(sp)
4000d526:	000a                	0xa
4000d528:	7355                	lui	t1,0xffff5
4000d52a:	7265                	lui	tp,0xffff9
4000d52c:	545f 6d69 3d65      	0x3d656d69545f
4000d532:	6425                	lui	s0,0x9
4000d534:	0a20                	addi	s0,sp,280
4000d536:	0000                	unimp
4000d538:	694d                	lui	s2,0x13
4000d53a:	736f7263          	bleu	s6,t5,4000dc5e <__clz_tab+0x12a>
4000d53e:	6365                	lui	t1,0x19
4000d540:	73646e6f          	jal	t3,40053c76 <end+0x42e96>
4000d544:	6620                	flw	fs0,72(a2)
4000d546:	6f20726f          	jal	tp,40014c38 <end+0x3e58>
4000d54a:	656e                	flw	fa0,216(sp)
4000d54c:	7220                	flw	fs0,96(a2)
4000d54e:	6e75                	lui	t3,0x1d
4000d550:	7420                	flw	fs0,104(s0)
4000d552:	7268                	flw	fa0,100(a2)
4000d554:	6867756f          	jal	a0,40084bda <end+0x73dfa>
4000d558:	4420                	lw	s0,72(s0)
4000d55a:	7268                	flw	fa0,100(a2)
4000d55c:	7379                	lui	t1,0xffffe
4000d55e:	6f74                	flw	fa3,92(a4)
4000d560:	656e                	flw	fa0,216(sp)
4000d562:	203a                	fld	ft0,392(sp)
4000d564:	0000                	unimp
4000d566:	0000                	unimp
4000d568:	3625                	jal	4000d090 <__clzsi2+0x108>
4000d56a:	312e                	fld	ft2,232(sp)
4000d56c:	2066                	fld	ft0,88(sp)
4000d56e:	000a                	0xa
4000d570:	6844                	flw	fs1,20(s0)
4000d572:	7972                	flw	fs2,60(sp)
4000d574:	6e6f7473          	csrrci	s0,0x6e6,30
4000d578:	7365                	lui	t1,0xffff9
4000d57a:	7020                	flw	fs0,96(s0)
4000d57c:	7265                	lui	tp,0xffff9
4000d57e:	5320                	lw	s0,96(a4)
4000d580:	6365                	lui	t1,0x19
4000d582:	3a646e6f          	jal	t3,40053928 <end+0x42b48>
4000d586:	2020                	fld	fs0,64(s0)
4000d588:	2020                	fld	fs0,64(s0)
4000d58a:	2020                	fld	fs0,64(s0)
4000d58c:	2020                	fld	fs0,64(s0)
4000d58e:	2020                	fld	fs0,64(s0)
4000d590:	2020                	fld	fs0,64(s0)
4000d592:	2020                	fld	fs0,64(s0)
4000d594:	2020                	fld	fs0,64(s0)
4000d596:	2020                	fld	fs0,64(s0)
4000d598:	2020                	fld	fs0,64(s0)
4000d59a:	2020                	fld	fs0,64(s0)
4000d59c:	0000                	unimp
4000d59e:	0000                	unimp
4000d5a0:	26b8                	fld	fa4,72(a3)
4000d5a2:	4000                	lw	s0,0(s0)
4000d5a4:	27c4                	fld	fs1,136(a5)
4000d5a6:	4000                	lw	s0,0(s0)
4000d5a8:	27c4                	fld	fs1,136(a5)
4000d5aa:	4000                	lw	s0,0(s0)
4000d5ac:	26b0                	fld	fa2,72(a3)
4000d5ae:	4000                	lw	s0,0(s0)
4000d5b0:	27c4                	fld	fs1,136(a5)
4000d5b2:	4000                	lw	s0,0(s0)
4000d5b4:	27c4                	fld	fs1,136(a5)
4000d5b6:	4000                	lw	s0,0(s0)
4000d5b8:	27c4                	fld	fs1,136(a5)
4000d5ba:	4000                	lw	s0,0(s0)
4000d5bc:	27c4                	fld	fs1,136(a5)
4000d5be:	4000                	lw	s0,0(s0)
4000d5c0:	27c4                	fld	fs1,136(a5)
4000d5c2:	4000                	lw	s0,0(s0)
4000d5c4:	27c4                	fld	fs1,136(a5)
4000d5c6:	4000                	lw	s0,0(s0)
4000d5c8:	1a7c                	addi	a5,sp,316
4000d5ca:	4000                	lw	s0,0(s0)
4000d5cc:	2440                	fld	fs0,136(s0)
4000d5ce:	4000                	lw	s0,0(s0)
4000d5d0:	27c4                	fld	fs1,136(a5)
4000d5d2:	4000                	lw	s0,0(s0)
4000d5d4:	1a94                	addi	a3,sp,368
4000d5d6:	4000                	lw	s0,0(s0)
4000d5d8:	2610                	fld	fa2,8(a2)
4000d5da:	4000                	lw	s0,0(s0)
4000d5dc:	27c4                	fld	fs1,136(a5)
4000d5de:	4000                	lw	s0,0(s0)
4000d5e0:	264c                	fld	fa1,136(a2)
4000d5e2:	4000                	lw	s0,0(s0)
4000d5e4:	2704                	fld	fs1,8(a4)
4000d5e6:	4000                	lw	s0,0(s0)
4000d5e8:	2704                	fld	fs1,8(a4)
4000d5ea:	4000                	lw	s0,0(s0)
4000d5ec:	2704                	fld	fs1,8(a4)
4000d5ee:	4000                	lw	s0,0(s0)
4000d5f0:	2704                	fld	fs1,8(a4)
4000d5f2:	4000                	lw	s0,0(s0)
4000d5f4:	2704                	fld	fs1,8(a4)
4000d5f6:	4000                	lw	s0,0(s0)
4000d5f8:	2704                	fld	fs1,8(a4)
4000d5fa:	4000                	lw	s0,0(s0)
4000d5fc:	2704                	fld	fs1,8(a4)
4000d5fe:	4000                	lw	s0,0(s0)
4000d600:	2704                	fld	fs1,8(a4)
4000d602:	4000                	lw	s0,0(s0)
4000d604:	2704                	fld	fs1,8(a4)
4000d606:	4000                	lw	s0,0(s0)
4000d608:	27c4                	fld	fs1,136(a5)
4000d60a:	4000                	lw	s0,0(s0)
4000d60c:	27c4                	fld	fs1,136(a5)
4000d60e:	4000                	lw	s0,0(s0)
4000d610:	27c4                	fld	fs1,136(a5)
4000d612:	4000                	lw	s0,0(s0)
4000d614:	27c4                	fld	fs1,136(a5)
4000d616:	4000                	lw	s0,0(s0)
4000d618:	27c4                	fld	fs1,136(a5)
4000d61a:	4000                	lw	s0,0(s0)
4000d61c:	27c4                	fld	fs1,136(a5)
4000d61e:	4000                	lw	s0,0(s0)
4000d620:	27c4                	fld	fs1,136(a5)
4000d622:	4000                	lw	s0,0(s0)
4000d624:	27c4                	fld	fs1,136(a5)
4000d626:	4000                	lw	s0,0(s0)
4000d628:	27c4                	fld	fs1,136(a5)
4000d62a:	4000                	lw	s0,0(s0)
4000d62c:	27c4                	fld	fs1,136(a5)
4000d62e:	4000                	lw	s0,0(s0)
4000d630:	24d8                	fld	fa4,136(s1)
4000d632:	4000                	lw	s0,0(s0)
4000d634:	2510                	fld	fa2,8(a0)
4000d636:	4000                	lw	s0,0(s0)
4000d638:	27c4                	fld	fs1,136(a5)
4000d63a:	4000                	lw	s0,0(s0)
4000d63c:	2510                	fld	fa2,8(a0)
4000d63e:	4000                	lw	s0,0(s0)
4000d640:	27c4                	fld	fs1,136(a5)
4000d642:	4000                	lw	s0,0(s0)
4000d644:	27c4                	fld	fs1,136(a5)
4000d646:	4000                	lw	s0,0(s0)
4000d648:	27c4                	fld	fs1,136(a5)
4000d64a:	4000                	lw	s0,0(s0)
4000d64c:	27c4                	fld	fs1,136(a5)
4000d64e:	4000                	lw	s0,0(s0)
4000d650:	2730                	fld	fa2,72(a4)
4000d652:	4000                	lw	s0,0(s0)
4000d654:	27c4                	fld	fs1,136(a5)
4000d656:	4000                	lw	s0,0(s0)
4000d658:	27c4                	fld	fs1,136(a5)
4000d65a:	4000                	lw	s0,0(s0)
4000d65c:	19e4                	addi	s1,sp,252
4000d65e:	4000                	lw	s0,0(s0)
4000d660:	27c4                	fld	fs1,136(a5)
4000d662:	4000                	lw	s0,0(s0)
4000d664:	27c4                	fld	fs1,136(a5)
4000d666:	4000                	lw	s0,0(s0)
4000d668:	27c4                	fld	fs1,136(a5)
4000d66a:	4000                	lw	s0,0(s0)
4000d66c:	27c4                	fld	fs1,136(a5)
4000d66e:	4000                	lw	s0,0(s0)
4000d670:	27c4                	fld	fs1,136(a5)
4000d672:	4000                	lw	s0,0(s0)
4000d674:	1a50                	addi	a2,sp,308
4000d676:	4000                	lw	s0,0(s0)
4000d678:	27c4                	fld	fs1,136(a5)
4000d67a:	4000                	lw	s0,0(s0)
4000d67c:	27c4                	fld	fs1,136(a5)
4000d67e:	4000                	lw	s0,0(s0)
4000d680:	2780                	fld	fs0,8(a5)
4000d682:	4000                	lw	s0,0(s0)
4000d684:	27c4                	fld	fs1,136(a5)
4000d686:	4000                	lw	s0,0(s0)
4000d688:	27c4                	fld	fs1,136(a5)
4000d68a:	4000                	lw	s0,0(s0)
4000d68c:	27c4                	fld	fs1,136(a5)
4000d68e:	4000                	lw	s0,0(s0)
4000d690:	27c4                	fld	fs1,136(a5)
4000d692:	4000                	lw	s0,0(s0)
4000d694:	27c4                	fld	fs1,136(a5)
4000d696:	4000                	lw	s0,0(s0)
4000d698:	27c4                	fld	fs1,136(a5)
4000d69a:	4000                	lw	s0,0(s0)
4000d69c:	27c4                	fld	fs1,136(a5)
4000d69e:	4000                	lw	s0,0(s0)
4000d6a0:	27c4                	fld	fs1,136(a5)
4000d6a2:	4000                	lw	s0,0(s0)
4000d6a4:	27c4                	fld	fs1,136(a5)
4000d6a6:	4000                	lw	s0,0(s0)
4000d6a8:	27c4                	fld	fs1,136(a5)
4000d6aa:	4000                	lw	s0,0(s0)
4000d6ac:	2738                	fld	fa4,72(a4)
4000d6ae:	4000                	lw	s0,0(s0)
4000d6b0:	2774                	fld	fa3,200(a4)
4000d6b2:	4000                	lw	s0,0(s0)
4000d6b4:	2510                	fld	fa2,8(a0)
4000d6b6:	4000                	lw	s0,0(s0)
4000d6b8:	2510                	fld	fa2,8(a0)
4000d6ba:	4000                	lw	s0,0(s0)
4000d6bc:	2510                	fld	fa2,8(a0)
4000d6be:	4000                	lw	s0,0(s0)
4000d6c0:	2654                	fld	fa3,136(a2)
4000d6c2:	4000                	lw	s0,0(s0)
4000d6c4:	2774                	fld	fa3,200(a4)
4000d6c6:	4000                	lw	s0,0(s0)
4000d6c8:	27c4                	fld	fs1,136(a5)
4000d6ca:	4000                	lw	s0,0(s0)
4000d6cc:	27c4                	fld	fs1,136(a5)
4000d6ce:	4000                	lw	s0,0(s0)
4000d6d0:	19dc                	addi	a5,sp,244
4000d6d2:	4000                	lw	s0,0(s0)
4000d6d4:	27c4                	fld	fs1,136(a5)
4000d6d6:	4000                	lw	s0,0(s0)
4000d6d8:	244c                	fld	fa1,136(s0)
4000d6da:	4000                	lw	s0,0(s0)
4000d6dc:	19e8                	addi	a0,sp,252
4000d6de:	4000                	lw	s0,0(s0)
4000d6e0:	26c8                	fld	fa0,136(a3)
4000d6e2:	4000                	lw	s0,0(s0)
4000d6e4:	19dc                	addi	a5,sp,244
4000d6e6:	4000                	lw	s0,0(s0)
4000d6e8:	27c4                	fld	fs1,136(a5)
4000d6ea:	4000                	lw	s0,0(s0)
4000d6ec:	247c                	fld	fa5,200(s0)
4000d6ee:	4000                	lw	s0,0(s0)
4000d6f0:	27c4                	fld	fs1,136(a5)
4000d6f2:	4000                	lw	s0,0(s0)
4000d6f4:	1a54                	addi	a3,sp,308
4000d6f6:	4000                	lw	s0,0(s0)
4000d6f8:	27c4                	fld	fs1,136(a5)
4000d6fa:	4000                	lw	s0,0(s0)
4000d6fc:	27c4                	fld	fs1,136(a5)
4000d6fe:	4000                	lw	s0,0(s0)
4000d700:	265c                	fld	fa5,136(a2)
4000d702:	4000                	lw	s0,0(s0)

4000d704 <blanks.4138>:
4000d704:	2020 2020 2020 2020 2020 2020 2020 2020                     

4000d714 <zeroes.4139>:
4000d714:	3030 3030 3030 3030 3030 3030 3030 3030     0000000000000000
4000d724:	4e49 0046 6e69 0066 414e 004e 616e 006e     INF.inf.NAN.nan.
4000d734:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF
4000d744:	0000 0000 3130 3332 3534 3736 3938 6261     ....0123456789ab
4000d754:	6463 6665 0000 0000 6e28 6c75 296c 0000     cdef....(null)..
4000d764:	0030 0000 6e49 6966 696e 7974 0000 0000     0...Infinity....
4000d774:	614e 004e 0043 0000 4f50 4953 0058 0000     NaN.C...POSIX...
4000d784:	002e 0000                                   ....

4000d788 <p05.2481>:
4000d788:	0005 0000 0019 0000 007d 0000 0000 0000     ........}.......

4000d798 <__mprec_tens>:
4000d798:	0000 0000 0000 3ff0 0000 0000 0000 4024     .......?......$@
4000d7a8:	0000 0000 0000 4059 0000 0000 4000 408f     ......Y@.....@.@
4000d7b8:	0000 0000 8800 40c3 0000 0000 6a00 40f8     .......@.....j.@
4000d7c8:	0000 0000 8480 412e 0000 0000 12d0 4163     .......A......cA
4000d7d8:	0000 0000 d784 4197 0000 0000 cd65 41cd     .......A....e..A
4000d7e8:	0000 2000 a05f 4202 0000 e800 4876 4237     ... _..B....vH7B
4000d7f8:	0000 a200 1a94 426d 0000 e540 309c 42a2     ......mB..@..0.B
4000d808:	0000 1e90 bcc4 42d6 0000 2634 6bf5 430c     .......B..4&.k.C
4000d818:	8000 37e0 c379 4341 a000 85d8 3457 4376     ...7y.AC....W4vC
4000d828:	c800 674e c16d 43ab 3d00 6091 58e4 43e1     ..Ngm..C.=.`.X.C
4000d838:	8c40 78b5 af1d 4415 ef50 d6e2 1ae4 444b     @..x...DP.....KD
4000d848:	d592 064d f0cf 4480 4af6 c7e1 2d02 44b5     ..M....D.J...-.D
4000d858:	9db4 79d9 7843 44ea                         ...yCx.D

4000d860 <__mprec_tinytens>:
4000d860:	89bc 97d8 d2b2 3c9c a733 d5a8 f623 3949     .......<3...#.I9
4000d870:	a73d 44f4 0ffd 32a5 979d cf8c ba08 255b     =..D...2......[%
4000d880:	6f43 64ac 0628 0ac8                         Co.d(...

4000d888 <__mprec_bigtens>:
4000d888:	8000 37e0 c379 4341 6e17 b505 b8b5 4693     ...7y.AC.n.....F
4000d898:	f9f5 e93f 4f03 4d38 1d32 f930 7748 5a82     ..?..O8M2.0.Hw.Z
4000d8a8:	bf3c 7f73 4fdd 7515 7a00 4000 7b74 4000     <.s..O.u.z.@t{.@
4000d8b8:	7b74 4000 7a14 4000 7b74 4000 7b74 4000     t{.@.z.@t{.@t{.@
4000d8c8:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d8d8:	75c0 4000 75e4 4000 7b74 4000 75d8 4000     .u.@.u.@t{.@.u.@
4000d8e8:	762c 4000 7b74 4000 75f4 4000 7600 4000     ,v.@t{.@.u.@.v.@
4000d8f8:	7600 4000 7600 4000 7600 4000 7600 4000     .v.@.v.@.v.@.v.@
4000d908:	7600 4000 7600 4000 7600 4000 7600 4000     .v.@.v.@.v.@.v.@
4000d918:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d928:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d938:	7b74 4000 7b74 4000 7960 4000 7b74 4000     t{.@t{.@`y.@t{.@
4000d948:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d958:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d968:	7b74 4000 750c 4000 7b74 4000 7b74 4000     t{.@.u.@t{.@t{.@
4000d978:	7b74 4000 7b74 4000 7b74 4000 74e0 4000     t{.@t{.@t{.@.t.@
4000d988:	7b74 4000 7b74 4000 7af8 4000 7b74 4000     t{.@t{.@.z.@t{.@
4000d998:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d9a8:	7b74 4000 7b74 4000 7b74 4000 7b74 4000     t{.@t{.@t{.@t{.@
4000d9b8:	7b74 4000 7a20 4000 7a50 4000 7b74 4000     t{.@ z.@Pz.@t{.@
4000d9c8:	7b74 4000 7b74 4000 7a5c 4000 7a50 4000     t{.@t{.@\z.@Pz.@
4000d9d8:	7b74 4000 7b74 4000 74d4 4000 7b74 4000     t{.@t{.@.t.@t{.@
4000d9e8:	766c 4000 7510 4000 7b0c 4000 74d4 4000     lv.@.u.@.{.@.t.@
4000d9f8:	7b74 4000 769c 4000 7b74 4000 74e4 4000     t{.@.v.@t{.@.t.@
4000da08:	7b74 4000 7b74 4000 7a68 4000               t{.@t{.@hz.@

4000da14 <blanks.4081>:
4000da14:	2020 2020 2020 2020 2020 2020 2020 2020                     

4000da24 <zeroes.4082>:
4000da24:	3030 3030 3030 3030 3030 3030 3030 3030     0000000000000000
4000da34:	9a58 4000 990c 4000 9a4c 4000 997c 4000     X..@...@L..@|..@
4000da44:	9a4c 4000 9a20 4000 9a4c 4000 997c 4000     L..@ ..@L..@|..@
4000da54:	990c 4000 990c 4000 9a20 4000 997c 4000     ...@...@ ..@|..@
4000da64:	9988 4000 9988 4000 9988 4000 9b88 4000     ...@...@...@...@
4000da74:	990c 4000 990c 4000 9b7c 4000 9c00 4000     ...@...@|..@...@
4000da84:	9b7c 4000 9a20 4000 9b7c 4000 9c00 4000     |..@ ..@|..@...@
4000da94:	990c 4000 990c 4000 9a20 4000 9c00 4000     ...@...@ ..@...@
4000daa4:	9988 4000 9988 4000 9988 4000 9b84 4000     ...@...@...@...@
4000dab4:	aa98 4000 a8ec 4000 aa88 4000 a970 4000     ...@...@...@p..@
4000dac4:	aa88 4000 aa60 4000 aa88 4000 a970 4000     ...@`..@...@p..@
4000dad4:	a8ec 4000 a8ec 4000 aa60 4000 a970 4000     ...@...@`..@p..@
4000dae4:	a980 4000 a980 4000 a980 4000 aab0 4000     ...@...@...@...@
4000daf4:	b66c 4000 b4e0 4000 b4e0 4000 b4dc 4000     l..@...@...@...@
4000db04:	b9c0 4000 b9c0 4000 b57c 4000 b4dc 4000     ...@...@|..@...@
4000db14:	b9c0 4000 b57c 4000 b9c0 4000 b4dc 4000     ...@|..@...@...@
4000db24:	b658 4000 b658 4000 b658 4000 b9d0 4000     X..@X..@X..@...@

4000db34 <__clz_tab>:
4000db34:	0100 0202 0303 0303 0404 0404 0404 0404     ................
4000db44:	0505 0505 0505 0505 0505 0505 0505 0505     ................
4000db54:	0606 0606 0606 0606 0606 0606 0606 0606     ................
4000db64:	0606 0606 0606 0606 0606 0606 0606 0606     ................
4000db74:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000db84:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000db94:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000dba4:	0707 0707 0707 0707 0707 0707 0707 0707     ................
4000dbb4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dbc4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dbd4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dbe4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dbf4:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dc04:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dc14:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dc24:	0808 0808 0808 0808 0808 0808 0808 0808     ................
4000dc34:	02f9 5095 432d eb1c 36e2 3f0a ffff ffff     ...P-C...6.?....
4000dc44:	ffff 7fef 0000 0000 0000 3ff8 4361 636f     ...........?aCoc
4000dc54:	87a7 3fd2 c8b3 8b60 8a28 3fc6 79fb 509f     ...?..`.(..?.y.P
4000dc64:	4413 3fd3 0000 0000 0000 3ff0 0000 0000     .D.?.......?....
4000dc74:	0000 4024 0000 0000 0000 401c 0000 0000     ..$@.......@....
4000dc84:	0000 4014 0000 0000 0000 3fe0 0010 0000     ...@.......?....
4000dc94:	0000 0000 7a03 0052 7c01 0101 0c1b 0002     .....zR..|......
4000dca4:	0028 0000 0018 0000 3020 ffff 0024 0000     (....... 0..$...
4000dcb4:	0400 0004 0000 100e 0404 0000 8100 0401     ................
4000dcc4:	0008 0000 04c1 0010 0000 000e               ............
