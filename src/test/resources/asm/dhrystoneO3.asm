
build/dhrystone.elf:     file format elf32-littleriscv


Disassembly of section .vector:

80000000 <crtStart>:
.global crtStart
.global main
.global irqCallback

crtStart:
  j crtInit
80000000:	0b00006f          	j	800000b0 <crtInit>
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
  sw x1,  - 1*4(sp)
80000020:	fe112e23          	sw	ra,-4(sp)
  sw x5,  - 2*4(sp)
80000024:	fe512c23          	sw	t0,-8(sp)
  sw x6,  - 3*4(sp)
80000028:	fe612a23          	sw	t1,-12(sp)
  sw x7,  - 4*4(sp)
8000002c:	fe712823          	sw	t2,-16(sp)
  sw x10, - 5*4(sp)
80000030:	fea12623          	sw	a0,-20(sp)
  sw x11, - 6*4(sp)
80000034:	feb12423          	sw	a1,-24(sp)
  sw x12, - 7*4(sp)
80000038:	fec12223          	sw	a2,-28(sp)
  sw x13, - 8*4(sp)
8000003c:	fed12023          	sw	a3,-32(sp)
  sw x14, - 9*4(sp)
80000040:	fce12e23          	sw	a4,-36(sp)
  sw x15, -10*4(sp)
80000044:	fcf12c23          	sw	a5,-40(sp)
  sw x16, -11*4(sp)
80000048:	fd012a23          	sw	a6,-44(sp)
  sw x17, -12*4(sp)
8000004c:	fd112823          	sw	a7,-48(sp)
  sw x28, -13*4(sp)
80000050:	fdc12623          	sw	t3,-52(sp)
  sw x29, -14*4(sp)
80000054:	fdd12423          	sw	t4,-56(sp)
  sw x30, -15*4(sp)
80000058:	fde12223          	sw	t5,-60(sp)
  sw x31, -16*4(sp)
8000005c:	fdf12023          	sw	t6,-64(sp)
  addi sp,sp,-16*4
80000060:	fc010113          	addi	sp,sp,-64
  call irqCallback
80000064:	0b4000ef          	jal	ra,80000118 <irqCallback>
  lw x1 , 15*4(sp)
80000068:	03c12083          	lw	ra,60(sp)
  lw x5,  14*4(sp)
8000006c:	03812283          	lw	t0,56(sp)
  lw x6,  13*4(sp)
80000070:	03412303          	lw	t1,52(sp)
  lw x7,  12*4(sp)
80000074:	03012383          	lw	t2,48(sp)
  lw x10, 11*4(sp)
80000078:	02c12503          	lw	a0,44(sp)
  lw x11, 10*4(sp)
8000007c:	02812583          	lw	a1,40(sp)
  lw x12,  9*4(sp)
80000080:	02412603          	lw	a2,36(sp)
  lw x13,  8*4(sp)
80000084:	02012683          	lw	a3,32(sp)
  lw x14,  7*4(sp)
80000088:	01c12703          	lw	a4,28(sp)
  lw x15,  6*4(sp)
8000008c:	01812783          	lw	a5,24(sp)
  lw x16,  5*4(sp)
80000090:	01412803          	lw	a6,20(sp)
  lw x17,  4*4(sp)
80000094:	01012883          	lw	a7,16(sp)
  lw x28,  3*4(sp)
80000098:	00c12e03          	lw	t3,12(sp)
  lw x29,  2*4(sp)
8000009c:	00812e83          	lw	t4,8(sp)
  lw x30,  1*4(sp)
800000a0:	00412f03          	lw	t5,4(sp)
  lw x31,  0*4(sp)
800000a4:	00012f83          	lw	t6,0(sp)
  addi sp,sp,16*4
800000a8:	04010113          	addi	sp,sp,64
  mret
800000ac:	30200073          	mret

800000b0 <crtInit>:


crtInit:
  .option push
  .option norelax
  la gp, __global_pointer$
800000b0:	00004197          	auipc	gp,0x4
800000b4:	03018193          	addi	gp,gp,48 # 800040e0 <__global_pointer$>
  .option pop
  la sp, _stack_start
800000b8:	00007117          	auipc	sp,0x7
800000bc:	85810113          	addi	sp,sp,-1960 # 80006910 <_stack_start>

800000c0 <bss_init>:

bss_init:
  la a0, _bss_start
800000c0:	81c18513          	addi	a0,gp,-2020 # 800038fc <Dhrystones_Per_Second>
  la a1, _bss_end
800000c4:	00006597          	auipc	a1,0x6
800000c8:	44058593          	addi	a1,a1,1088 # 80006504 <_bss_end>

800000cc <bss_loop>:
bss_loop:
  beq a0,a1,bss_done
800000cc:	00b50863          	beq	a0,a1,800000dc <bss_done>
  sw zero,0(a0)
800000d0:	00052023          	sw	zero,0(a0)
  add a0,a0,4
800000d4:	00450513          	addi	a0,a0,4
  j bss_loop
800000d8:	ff5ff06f          	j	800000cc <bss_loop>

800000dc <bss_done>:
bss_done:

ctors_init:
  la a0, _ctors_start
800000dc:	00004517          	auipc	a0,0x4
800000e0:	80050513          	addi	a0,a0,-2048 # 800038dc <_ctors_end>
  addi sp,sp,-4
800000e4:	ffc10113          	addi	sp,sp,-4

800000e8 <ctors_loop>:
ctors_loop:
  la a1, _ctors_end
800000e8:	00003597          	auipc	a1,0x3
800000ec:	7f458593          	addi	a1,a1,2036 # 800038dc <_ctors_end>
  beq a0,a1,ctors_done
800000f0:	00b50e63          	beq	a0,a1,8000010c <ctors_done>
  lw a3,0(a0)
800000f4:	00052683          	lw	a3,0(a0)
  add a0,a0,4
800000f8:	00450513          	addi	a0,a0,4
  sw a0,0(sp)
800000fc:	00a12023          	sw	a0,0(sp)
  jalr  a3
80000100:	000680e7          	jalr	a3
  lw a0,0(sp)
80000104:	00012503          	lw	a0,0(sp)
  j ctors_loop
80000108:	fe1ff06f          	j	800000e8 <ctors_loop>

8000010c <ctors_done>:
ctors_done:
  addi sp,sp,4
8000010c:	00410113          	addi	sp,sp,4
  //li a0, 0x880     //880 enable timer + external interrupts
  //csrw mie,a0
  //li a0, 0x1808     //1808 enable interrupts
  //csrw mstatus,a0

  call main
80000110:	7f1020ef          	jal	ra,80003100 <end>

80000114 <infinitLoop>:
infinitLoop:
  j infinitLoop
80000114:	0000006f          	j	80000114 <infinitLoop>

Disassembly of section .memory:

80000118 <irqCallback>:
}


void irqCallback(int irq){

}
80000118:	00008067          	ret

8000011c <Proc_2>:
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
8000011c:	8351c703          	lbu	a4,-1995(gp) # 80003915 <Ch_1_Glob>
80000120:	04100793          	li	a5,65
80000124:	00f70463          	beq	a4,a5,8000012c <Proc_2+0x10>
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */
80000128:	00008067          	ret
      Int_Loc -= 1;
8000012c:	00052783          	lw	a5,0(a0)
      *Int_Par_Ref = Int_Loc - Int_Glob;
80000130:	83c1a703          	lw	a4,-1988(gp) # 8000391c <Int_Glob>
      Int_Loc -= 1;
80000134:	00978793          	addi	a5,a5,9
      *Int_Par_Ref = Int_Loc - Int_Glob;
80000138:	40e787b3          	sub	a5,a5,a4
8000013c:	00f52023          	sw	a5,0(a0)
} /* Proc_2 */
80000140:	00008067          	ret

80000144 <Proc_3>:
    /* Ptr_Ref_Par becomes Ptr_Glob */

Rec_Pointer *Ptr_Ref_Par;

{
  if (Ptr_Glob != Null)
80000144:	8441a603          	lw	a2,-1980(gp) # 80003924 <Ptr_Glob>
80000148:	00060863          	beqz	a2,80000158 <Proc_3+0x14>
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
8000014c:	00062703          	lw	a4,0(a2)
80000150:	00e52023          	sw	a4,0(a0)
80000154:	8441a603          	lw	a2,-1980(gp) # 80003924 <Ptr_Glob>
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
80000158:	83c1a583          	lw	a1,-1988(gp) # 8000391c <Int_Glob>
8000015c:	00c60613          	addi	a2,a2,12
80000160:	00a00513          	li	a0,10
80000164:	0fd0006f          	j	80000a60 <Proc_7>

80000168 <Proc_1>:
{
80000168:	ff010113          	addi	sp,sp,-16
8000016c:	01212023          	sw	s2,0(sp)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000170:	8441a783          	lw	a5,-1980(gp) # 80003924 <Ptr_Glob>
{
80000174:	00812423          	sw	s0,8(sp)
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
80000178:	00052403          	lw	s0,0(a0)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
8000017c:	0007a703          	lw	a4,0(a5)
{
80000180:	00912223          	sw	s1,4(sp)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000184:	0047ae83          	lw	t4,4(a5)
80000188:	0087ae03          	lw	t3,8(a5)
8000018c:	0107a303          	lw	t1,16(a5)
80000190:	0147a883          	lw	a7,20(a5)
80000194:	0187a803          	lw	a6,24(a5)
80000198:	0207a583          	lw	a1,32(a5)
8000019c:	0247a603          	lw	a2,36(a5)
800001a0:	0287a683          	lw	a3,40(a5)
{
800001a4:	00112623          	sw	ra,12(sp)
800001a8:	00050493          	mv	s1,a0
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
800001ac:	01c7a503          	lw	a0,28(a5)
800001b0:	02c7a783          	lw	a5,44(a5)
800001b4:	00e42023          	sw	a4,0(s0)
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
800001b8:	0004a703          	lw	a4,0(s1)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
800001bc:	00a42e23          	sw	a0,28(s0)
800001c0:	02f42623          	sw	a5,44(s0)
800001c4:	01d42223          	sw	t4,4(s0)
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
800001c8:	00500793          	li	a5,5
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
800001cc:	01c42423          	sw	t3,8(s0)
800001d0:	00642823          	sw	t1,16(s0)
800001d4:	01142a23          	sw	a7,20(s0)
800001d8:	01042c23          	sw	a6,24(s0)
800001dc:	02b42023          	sw	a1,32(s0)
800001e0:	02c42223          	sw	a2,36(s0)
800001e4:	02d42423          	sw	a3,40(s0)
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
800001e8:	00f4a623          	sw	a5,12(s1)
        = Ptr_Val_Par->variant.var_1.Int_Comp;
800001ec:	00f42623          	sw	a5,12(s0)
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
800001f0:	00e42023          	sw	a4,0(s0)
  Proc_3 (&Next_Record->Ptr_Comp);
800001f4:	00040513          	mv	a0,s0
800001f8:	f4dff0ef          	jal	ra,80000144 <Proc_3>
  if (Next_Record->Discr == Ident_1)
800001fc:	00442783          	lw	a5,4(s0)
80000200:	08078063          	beqz	a5,80000280 <Proc_1+0x118>
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
80000204:	0004a783          	lw	a5,0(s1)
} /* Proc_1 */
80000208:	00c12083          	lw	ra,12(sp)
8000020c:	00812403          	lw	s0,8(sp)
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
80000210:	0007af83          	lw	t6,0(a5)
80000214:	0047af03          	lw	t5,4(a5)
80000218:	0087ae83          	lw	t4,8(a5)
8000021c:	00c7ae03          	lw	t3,12(a5)
80000220:	0107a303          	lw	t1,16(a5)
80000224:	0147a883          	lw	a7,20(a5)
80000228:	0187a803          	lw	a6,24(a5)
8000022c:	01c7a583          	lw	a1,28(a5)
80000230:	0207a603          	lw	a2,32(a5)
80000234:	0247a683          	lw	a3,36(a5)
80000238:	0287a703          	lw	a4,40(a5)
8000023c:	02c7a783          	lw	a5,44(a5)
80000240:	01f4a023          	sw	t6,0(s1)
80000244:	01e4a223          	sw	t5,4(s1)
80000248:	01d4a423          	sw	t4,8(s1)
8000024c:	01c4a623          	sw	t3,12(s1)
80000250:	0064a823          	sw	t1,16(s1)
80000254:	0114aa23          	sw	a7,20(s1)
80000258:	0104ac23          	sw	a6,24(s1)
8000025c:	00b4ae23          	sw	a1,28(s1)
80000260:	02c4a023          	sw	a2,32(s1)
80000264:	02d4a223          	sw	a3,36(s1)
80000268:	02e4a423          	sw	a4,40(s1)
8000026c:	02f4a623          	sw	a5,44(s1)
} /* Proc_1 */
80000270:	00012903          	lw	s2,0(sp)
80000274:	00412483          	lw	s1,4(sp)
80000278:	01010113          	addi	sp,sp,16
8000027c:	00008067          	ret
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
80000280:	0084a503          	lw	a0,8(s1)
    Next_Record->variant.var_1.Int_Comp = 6;
80000284:	00600793          	li	a5,6
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
80000288:	00840593          	addi	a1,s0,8
    Next_Record->variant.var_1.Int_Comp = 6;
8000028c:	00f42623          	sw	a5,12(s0)
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
80000290:	10d000ef          	jal	ra,80000b9c <Proc_6>
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
80000294:	8441a783          	lw	a5,-1980(gp) # 80003924 <Ptr_Glob>
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
80000298:	00c42503          	lw	a0,12(s0)
8000029c:	00c40613          	addi	a2,s0,12
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
800002a0:	0007a783          	lw	a5,0(a5)
} /* Proc_1 */
800002a4:	00c12083          	lw	ra,12(sp)
800002a8:	00412483          	lw	s1,4(sp)
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
800002ac:	00f42023          	sw	a5,0(s0)
} /* Proc_1 */
800002b0:	00812403          	lw	s0,8(sp)
800002b4:	00012903          	lw	s2,0(sp)
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
800002b8:	00a00593          	li	a1,10
} /* Proc_1 */
800002bc:	01010113          	addi	sp,sp,16
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
800002c0:	7a00006f          	j	80000a60 <Proc_7>

800002c4 <Proc_4>:
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
800002c4:	8351c783          	lbu	a5,-1995(gp) # 80003915 <Ch_1_Glob>
  Bool_Glob = Bool_Loc | Bool_Glob;
800002c8:	8381a683          	lw	a3,-1992(gp) # 80003918 <Bool_Glob>
  Bool_Loc = Ch_1_Glob == 'A';
800002cc:	fbf78793          	addi	a5,a5,-65
800002d0:	0017b793          	seqz	a5,a5
  Bool_Glob = Bool_Loc | Bool_Glob;
800002d4:	00d7e7b3          	or	a5,a5,a3
800002d8:	82f1ac23          	sw	a5,-1992(gp) # 80003918 <Bool_Glob>
  Ch_2_Glob = 'B';
800002dc:	04200713          	li	a4,66
800002e0:	82e18a23          	sb	a4,-1996(gp) # 80003914 <Ch_2_Glob>
} /* Proc_4 */
800002e4:	00008067          	ret

800002e8 <Proc_5>:

Proc_5 () /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
800002e8:	04100713          	li	a4,65
800002ec:	82e18aa3          	sb	a4,-1995(gp) # 80003915 <Ch_1_Glob>
  Bool_Glob = false;
800002f0:	8201ac23          	sw	zero,-1992(gp) # 80003918 <Bool_Glob>
} /* Proc_5 */
800002f4:	00008067          	ret

800002f8 <main2>:
{
800002f8:	f6010113          	addi	sp,sp,-160
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
800002fc:	03000513          	li	a0,48
{
80000300:	08112e23          	sw	ra,156(sp)
80000304:	08812c23          	sw	s0,152(sp)
80000308:	07812c23          	sw	s8,120(sp)
8000030c:	07b12623          	sw	s11,108(sp)
80000310:	08912a23          	sw	s1,148(sp)
80000314:	09212823          	sw	s2,144(sp)
80000318:	09312623          	sw	s3,140(sp)
8000031c:	09412423          	sw	s4,136(sp)
80000320:	09512223          	sw	s5,132(sp)
80000324:	09612023          	sw	s6,128(sp)
80000328:	07712e23          	sw	s7,124(sp)
8000032c:	07912a23          	sw	s9,116(sp)
80000330:	07a12823          	sw	s10,112(sp)
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
80000334:	1f5000ef          	jal	ra,80000d28 <malloc>
80000338:	84a1a023          	sw	a0,-1984(gp) # 80003920 <Next_Ptr_Glob>
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
8000033c:	03000513          	li	a0,48
80000340:	1e9000ef          	jal	ra,80000d28 <malloc>
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
80000344:	8401a783          	lw	a5,-1984(gp) # 80003920 <Next_Ptr_Glob>
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
80000348:	84a1a223          	sw	a0,-1980(gp) # 80003924 <Ptr_Glob>
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
8000034c:	00f52023          	sw	a5,0(a0)
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
80000350:	00200793          	li	a5,2
80000354:	00f52423          	sw	a5,8(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
80000358:	800035b7          	lui	a1,0x80003
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
8000035c:	02800793          	li	a5,40
80000360:	00f52623          	sw	a5,12(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
80000364:	01f00613          	li	a2,31
80000368:	12458593          	addi	a1,a1,292 # 80003124 <_stack_start+0xffffc814>
  Ptr_Glob->Discr                       = Ident_1;
8000036c:	00052223          	sw	zero,4(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
80000370:	01050513          	addi	a0,a0,16
80000374:	34d000ef          	jal	ra,80000ec0 <memcpy>
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
80000378:	80003737          	lui	a4,0x80003
8000037c:	68c70793          	addi	a5,a4,1676 # 8000368c <_stack_start+0xffffcd7c>
80000380:	68c72e03          	lw	t3,1676(a4)
80000384:	0047a303          	lw	t1,4(a5)
80000388:	0087a883          	lw	a7,8(a5)
8000038c:	00c7a803          	lw	a6,12(a5)
80000390:	0107a583          	lw	a1,16(a5)
80000394:	0147a603          	lw	a2,20(a5)
80000398:	0187a683          	lw	a3,24(a5)
8000039c:	01c7d703          	lhu	a4,28(a5)
800003a0:	01e7c783          	lbu	a5,30(a5)
  Arr_2_Glob [8][7] = 10;
800003a4:	80004db7          	lui	s11,0x80004
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
800003a8:	02e11e23          	sh	a4,60(sp)
800003ac:	02f10f23          	sb	a5,62(sp)
  Arr_2_Glob [8][7] = 10;
800003b0:	9f4d8713          	addi	a4,s11,-1548 # 800039f4 <_stack_start+0xffffd0e4>
800003b4:	00a00793          	li	a5,10
  printf ("\n");
800003b8:	00a00513          	li	a0,10
  Arr_2_Glob [8][7] = 10;
800003bc:	64f72e23          	sw	a5,1628(a4)
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
800003c0:	03c12023          	sw	t3,32(sp)
800003c4:	02612223          	sw	t1,36(sp)
800003c8:	03112423          	sw	a7,40(sp)
800003cc:	03012623          	sw	a6,44(sp)
800003d0:	02b12823          	sw	a1,48(sp)
800003d4:	02c12a23          	sw	a2,52(sp)
800003d8:	02d12c23          	sw	a3,56(sp)
  printf ("\n");
800003dc:	2cd000ef          	jal	ra,80000ea8 <putchar>
  printf ("Dhrystone Benchmark, Version 2.1 (Language: C)\n");
800003e0:	80003537          	lui	a0,0x80003
800003e4:	14450513          	addi	a0,a0,324 # 80003144 <_stack_start+0xffffc834>
800003e8:	27d000ef          	jal	ra,80000e64 <puts>
  printf ("\n");
800003ec:	00a00513          	li	a0,10
800003f0:	2b9000ef          	jal	ra,80000ea8 <putchar>
  if (Reg)
800003f4:	8301a783          	lw	a5,-2000(gp) # 80003910 <Reg>
800003f8:	62078063          	beqz	a5,80000a18 <main2+0x720>
    printf ("Program compiled with 'register' attribute\n");
800003fc:	80003537          	lui	a0,0x80003
80000400:	17450513          	addi	a0,a0,372 # 80003174 <_stack_start+0xffffc864>
80000404:	261000ef          	jal	ra,80000e64 <puts>
    printf ("\n");
80000408:	00a00513          	li	a0,10
8000040c:	29d000ef          	jal	ra,80000ea8 <putchar>
  printf ("Please give the number of runs through the benchmark: ");
80000410:	80003537          	lui	a0,0x80003
80000414:	1d050513          	addi	a0,a0,464 # 800031d0 <_stack_start+0xffffc8c0>
80000418:	139000ef          	jal	ra,80000d50 <printf>
  printf ("\n");
8000041c:	00a00513          	li	a0,10
80000420:	289000ef          	jal	ra,80000ea8 <putchar>
  printf ("Execution starts, %d runs through Dhrystone\n", Number_Of_Runs);
80000424:	80003537          	lui	a0,0x80003
80000428:	0c800593          	li	a1,200
8000042c:	20850513          	addi	a0,a0,520 # 80003208 <_stack_start+0xffffc8f8>
80000430:	121000ef          	jal	ra,80000d50 <printf>
  Begin_Time = clock();
80000434:	281000ef          	jal	ra,80000eb4 <clock>
80000438:	80003437          	lui	s0,0x80003
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
8000043c:	6ac42783          	lw	a5,1708(s0) # 800036ac <_stack_start+0xffffcd9c>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
80000440:	80003d37          	lui	s10,0x80003
80000444:	6ccd2b83          	lw	s7,1740(s10) # 800036cc <_stack_start+0xffffcdbc>
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000448:	00f12423          	sw	a5,8(sp)
  Begin_Time = clock();
8000044c:	82a1a623          	sw	a0,-2004(gp) # 8000390c <Begin_Time>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
80000450:	00100993          	li	s3,1
80000454:	6ac40413          	addi	s0,s0,1708
    Int_1_Loc = 2;
80000458:	00200493          	li	s1,2
    Proc_5();
8000045c:	e8dff0ef          	jal	ra,800002e8 <Proc_5>
    Proc_4();
80000460:	e65ff0ef          	jal	ra,800002c4 <Proc_4>
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000464:	01e44783          	lbu	a5,30(s0)
80000468:	01442603          	lw	a2,20(s0)
8000046c:	00442e03          	lw	t3,4(s0)
80000470:	00842303          	lw	t1,8(s0)
80000474:	00c42883          	lw	a7,12(s0)
80000478:	01042803          	lw	a6,16(s0)
8000047c:	01842683          	lw	a3,24(s0)
80000480:	01c45703          	lhu	a4,28(s0)
80000484:	00812e83          	lw	t4,8(sp)
80000488:	04f10f23          	sb	a5,94(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
8000048c:	04010593          	addi	a1,sp,64
    Enum_Loc = Ident_2;
80000490:	00100793          	li	a5,1
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
80000494:	02010513          	addi	a0,sp,32
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000498:	04c12a23          	sw	a2,84(sp)
    Enum_Loc = Ident_2;
8000049c:	00f12e23          	sw	a5,28(sp)
    Int_1_Loc = 2;
800004a0:	00912a23          	sw	s1,20(sp)
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
800004a4:	05d12023          	sw	t4,64(sp)
800004a8:	05c12223          	sw	t3,68(sp)
800004ac:	04612423          	sw	t1,72(sp)
800004b0:	05112623          	sw	a7,76(sp)
800004b4:	05012823          	sw	a6,80(sp)
800004b8:	04d12c23          	sw	a3,88(sp)
800004bc:	04e11e23          	sh	a4,92(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
800004c0:	670000ef          	jal	ra,80000b30 <Func_2>
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
800004c4:	01412603          	lw	a2,20(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
800004c8:	00153513          	seqz	a0,a0
800004cc:	82a1ac23          	sw	a0,-1992(gp) # 80003918 <Bool_Glob>
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
800004d0:	02c4ca63          	blt	s1,a2,80000504 <main2+0x20c>
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
800004d4:	00261793          	slli	a5,a2,0x2
800004d8:	00c787b3          	add	a5,a5,a2
800004dc:	ffd78793          	addi	a5,a5,-3
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
800004e0:	00060513          	mv	a0,a2
800004e4:	00300593          	li	a1,3
800004e8:	01810613          	addi	a2,sp,24
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
800004ec:	00f12c23          	sw	a5,24(sp)
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
800004f0:	570000ef          	jal	ra,80000a60 <Proc_7>
      Int_1_Loc += 1;
800004f4:	01412603          	lw	a2,20(sp)
800004f8:	00160613          	addi	a2,a2,1
800004fc:	00c12a23          	sw	a2,20(sp)
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
80000500:	fcc4dae3          	ble	a2,s1,800004d4 <main2+0x1dc>
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
80000504:	01812683          	lw	a3,24(sp)
80000508:	84c18513          	addi	a0,gp,-1972 # 8000392c <Arr_1_Glob>
8000050c:	9f4d8593          	addi	a1,s11,-1548
80000510:	560000ef          	jal	ra,80000a70 <Proc_8>
    Proc_1 (Ptr_Glob);
80000514:	8441a503          	lw	a0,-1980(gp) # 80003924 <Ptr_Glob>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
80000518:	04100a93          	li	s5,65
    Int_2_Loc = 3;
8000051c:	00300a13          	li	s4,3
    Proc_1 (Ptr_Glob);
80000520:	c49ff0ef          	jal	ra,80000168 <Proc_1>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
80000524:	8341c703          	lbu	a4,-1996(gp) # 80003914 <Ch_2_Glob>
80000528:	04000793          	li	a5,64
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
8000052c:	6ccd0c93          	addi	s9,s10,1740
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
80000530:	02e7f463          	bleu	a4,a5,80000558 <main2+0x260>
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
80000534:	000a8513          	mv	a0,s5
80000538:	04300593          	li	a1,67
8000053c:	5d4000ef          	jal	ra,80000b10 <Func_1>
80000540:	01c12783          	lw	a5,28(sp)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
80000544:	001a8713          	addi	a4,s5,1
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
80000548:	46f50263          	beq	a0,a5,800009ac <main2+0x6b4>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
8000054c:	8341c783          	lbu	a5,-1996(gp) # 80003914 <Ch_2_Glob>
80000550:	0ff77a93          	andi	s5,a4,255
80000554:	ff57f0e3          	bleu	s5,a5,80000534 <main2+0x23c>
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
80000558:	01412583          	lw	a1,20(sp)
8000055c:	000a0513          	mv	a0,s4
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
80000560:	00198993          	addi	s3,s3,1
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
80000564:	279020ef          	jal	ra,80002fdc <__mulsi3>
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
80000568:	01812a83          	lw	s5,24(sp)
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
8000056c:	00a12623          	sw	a0,12(sp)
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
80000570:	000a8593          	mv	a1,s5
80000574:	28d020ef          	jal	ra,80003000 <__divsi3>
80000578:	00050a13          	mv	s4,a0
    Proc_2 (&Int_1_Loc);
8000057c:	01410513          	addi	a0,sp,20
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
80000580:	01412a23          	sw	s4,20(sp)
    Proc_2 (&Int_1_Loc);
80000584:	b99ff0ef          	jal	ra,8000011c <Proc_2>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
80000588:	0c900793          	li	a5,201
8000058c:	ecf998e3          	bne	s3,a5,8000045c <main2+0x164>
  End_Time = clock();
80000590:	125000ef          	jal	ra,80000eb4 <clock>
80000594:	82a1a423          	sw	a0,-2008(gp) # 80003908 <End_Time>
  printf ("Execution ends\n");
80000598:	80003537          	lui	a0,0x80003
8000059c:	23850513          	addi	a0,a0,568 # 80003238 <_stack_start+0xffffc928>
800005a0:	0c5000ef          	jal	ra,80000e64 <puts>
  printf ("\n");
800005a4:	00a00513          	li	a0,10
800005a8:	101000ef          	jal	ra,80000ea8 <putchar>
  printf ("Final values of the variables used in the benchmark:\n");
800005ac:	80003537          	lui	a0,0x80003
800005b0:	24850513          	addi	a0,a0,584 # 80003248 <_stack_start+0xffffc938>
800005b4:	0b1000ef          	jal	ra,80000e64 <puts>
  printf ("\n");
800005b8:	00a00513          	li	a0,10
800005bc:	0ed000ef          	jal	ra,80000ea8 <putchar>
  printf ("Int_Glob:            %d\n", Int_Glob);
800005c0:	83c1a583          	lw	a1,-1988(gp) # 8000391c <Int_Glob>
800005c4:	80003537          	lui	a0,0x80003
800005c8:	28050513          	addi	a0,a0,640 # 80003280 <_stack_start+0xffffc970>
  printf ("        should be:   %d\n", 5);
800005cc:	80003437          	lui	s0,0x80003
  printf ("Int_Glob:            %d\n", Int_Glob);
800005d0:	780000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 5);
800005d4:	00500593          	li	a1,5
800005d8:	29c40513          	addi	a0,s0,668 # 8000329c <_stack_start+0xffffc98c>
800005dc:	774000ef          	jal	ra,80000d50 <printf>
  printf ("Bool_Glob:           %d\n", Bool_Glob);
800005e0:	8381a583          	lw	a1,-1992(gp) # 80003918 <Bool_Glob>
800005e4:	80003537          	lui	a0,0x80003
800005e8:	2b850513          	addi	a0,a0,696 # 800032b8 <_stack_start+0xffffc9a8>
800005ec:	764000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 1);
800005f0:	00100593          	li	a1,1
800005f4:	29c40513          	addi	a0,s0,668
800005f8:	758000ef          	jal	ra,80000d50 <printf>
  printf ("Ch_1_Glob:           %c\n", Ch_1_Glob);
800005fc:	8351c583          	lbu	a1,-1995(gp) # 80003915 <Ch_1_Glob>
80000600:	80003537          	lui	a0,0x80003
80000604:	2d450513          	addi	a0,a0,724 # 800032d4 <_stack_start+0xffffc9c4>
80000608:	748000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %c\n", 'A');
8000060c:	800034b7          	lui	s1,0x80003
80000610:	04100593          	li	a1,65
80000614:	2f048513          	addi	a0,s1,752 # 800032f0 <_stack_start+0xffffc9e0>
80000618:	738000ef          	jal	ra,80000d50 <printf>
  printf ("Ch_2_Glob:           %c\n", Ch_2_Glob);
8000061c:	8341c583          	lbu	a1,-1996(gp) # 80003914 <Ch_2_Glob>
80000620:	80003537          	lui	a0,0x80003
80000624:	30c50513          	addi	a0,a0,780 # 8000330c <_stack_start+0xffffc9fc>
80000628:	728000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %c\n", 'B');
8000062c:	04200593          	li	a1,66
80000630:	2f048513          	addi	a0,s1,752
80000634:	71c000ef          	jal	ra,80000d50 <printf>
  printf ("Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
80000638:	84c18793          	addi	a5,gp,-1972 # 8000392c <Arr_1_Glob>
8000063c:	0207a583          	lw	a1,32(a5)
80000640:	80003537          	lui	a0,0x80003
80000644:	32850513          	addi	a0,a0,808 # 80003328 <_stack_start+0xffffca18>
80000648:	708000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 7);
8000064c:	00700593          	li	a1,7
80000650:	29c40513          	addi	a0,s0,668
80000654:	6fc000ef          	jal	ra,80000d50 <printf>
  printf ("Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
80000658:	800047b7          	lui	a5,0x80004
8000065c:	9f478793          	addi	a5,a5,-1548 # 800039f4 <_stack_start+0xffffd0e4>
80000660:	65c7a583          	lw	a1,1628(a5)
80000664:	80003537          	lui	a0,0x80003
80000668:	34450513          	addi	a0,a0,836 # 80003344 <_stack_start+0xffffca34>
8000066c:	6e4000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   Number_Of_Runs + 10\n");
80000670:	80003537          	lui	a0,0x80003
80000674:	36050513          	addi	a0,a0,864 # 80003360 <_stack_start+0xffffca50>
80000678:	7ec000ef          	jal	ra,80000e64 <puts>
  printf ("Ptr_Glob->\n");
8000067c:	80003537          	lui	a0,0x80003
80000680:	38c50513          	addi	a0,a0,908 # 8000338c <_stack_start+0xffffca7c>
80000684:	7e0000ef          	jal	ra,80000e64 <puts>
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
80000688:	8441a783          	lw	a5,-1980(gp) # 80003924 <Ptr_Glob>
8000068c:	80003db7          	lui	s11,0x80003
80000690:	398d8513          	addi	a0,s11,920 # 80003398 <_stack_start+0xffffca88>
80000694:	0007a583          	lw	a1,0(a5)
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
80000698:	80003cb7          	lui	s9,0x80003
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
8000069c:	80003bb7          	lui	s7,0x80003
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
800006a0:	6b0000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   (implementation-dependent)\n");
800006a4:	80003537          	lui	a0,0x80003
800006a8:	3b450513          	addi	a0,a0,948 # 800033b4 <_stack_start+0xffffcaa4>
800006ac:	7b8000ef          	jal	ra,80000e64 <puts>
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
800006b0:	8441a783          	lw	a5,-1980(gp) # 80003924 <Ptr_Glob>
800006b4:	3e4c8513          	addi	a0,s9,996 # 800033e4 <_stack_start+0xffffcad4>
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
800006b8:	80003b37          	lui	s6,0x80003
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
800006bc:	0047a583          	lw	a1,4(a5)
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
800006c0:	800039b7          	lui	s3,0x80003
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
800006c4:	80003937          	lui	s2,0x80003
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
800006c8:	688000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 0);
800006cc:	00000593          	li	a1,0
800006d0:	29c40513          	addi	a0,s0,668
800006d4:	67c000ef          	jal	ra,80000d50 <printf>
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
800006d8:	8441a783          	lw	a5,-1980(gp) # 80003924 <Ptr_Glob>
800006dc:	400b8513          	addi	a0,s7,1024 # 80003400 <_stack_start+0xffffcaf0>
800006e0:	0087a583          	lw	a1,8(a5)
800006e4:	66c000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 2);
800006e8:	00200593          	li	a1,2
800006ec:	29c40513          	addi	a0,s0,668
800006f0:	660000ef          	jal	ra,80000d50 <printf>
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
800006f4:	8441a783          	lw	a5,-1980(gp) # 80003924 <Ptr_Glob>
800006f8:	41cb0513          	addi	a0,s6,1052 # 8000341c <_stack_start+0xffffcb0c>
800006fc:	00c7a583          	lw	a1,12(a5)
80000700:	650000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 17);
80000704:	01100593          	li	a1,17
80000708:	29c40513          	addi	a0,s0,668
8000070c:	644000ef          	jal	ra,80000d50 <printf>
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
80000710:	8441a583          	lw	a1,-1980(gp) # 80003924 <Ptr_Glob>
80000714:	43898513          	addi	a0,s3,1080 # 80003438 <_stack_start+0xffffcb28>
80000718:	01058593          	addi	a1,a1,16
8000071c:	634000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
80000720:	45490513          	addi	a0,s2,1108 # 80003454 <_stack_start+0xffffcb44>
80000724:	740000ef          	jal	ra,80000e64 <puts>
  printf ("Next_Ptr_Glob->\n");
80000728:	80003537          	lui	a0,0x80003
8000072c:	48850513          	addi	a0,a0,1160 # 80003488 <_stack_start+0xffffcb78>
80000730:	734000ef          	jal	ra,80000e64 <puts>
  printf ("  Ptr_Comp:          %d\n", (int) Next_Ptr_Glob->Ptr_Comp);
80000734:	8401a783          	lw	a5,-1984(gp) # 80003920 <Next_Ptr_Glob>
80000738:	398d8513          	addi	a0,s11,920
8000073c:	0007a583          	lw	a1,0(a5)
80000740:	610000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   (implementation-dependent), same as above\n");
80000744:	80003537          	lui	a0,0x80003
80000748:	49850513          	addi	a0,a0,1176 # 80003498 <_stack_start+0xffffcb88>
8000074c:	718000ef          	jal	ra,80000e64 <puts>
  printf ("  Discr:             %d\n", Next_Ptr_Glob->Discr);
80000750:	8401a783          	lw	a5,-1984(gp) # 80003920 <Next_Ptr_Glob>
80000754:	3e4c8513          	addi	a0,s9,996
80000758:	0047a583          	lw	a1,4(a5)
8000075c:	5f4000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 0);
80000760:	00000593          	li	a1,0
80000764:	29c40513          	addi	a0,s0,668
80000768:	5e8000ef          	jal	ra,80000d50 <printf>
  printf ("  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
8000076c:	8401a783          	lw	a5,-1984(gp) # 80003920 <Next_Ptr_Glob>
80000770:	400b8513          	addi	a0,s7,1024
80000774:	0087a583          	lw	a1,8(a5)
80000778:	5d8000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 1);
8000077c:	00100593          	li	a1,1
80000780:	29c40513          	addi	a0,s0,668
80000784:	5cc000ef          	jal	ra,80000d50 <printf>
  printf ("  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
80000788:	8401a783          	lw	a5,-1984(gp) # 80003920 <Next_Ptr_Glob>
8000078c:	41cb0513          	addi	a0,s6,1052
80000790:	00c7a583          	lw	a1,12(a5)
80000794:	5bc000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 18);
80000798:	01200593          	li	a1,18
8000079c:	29c40513          	addi	a0,s0,668
800007a0:	5b0000ef          	jal	ra,80000d50 <printf>
  printf ("  Str_Comp:          %s\n",
800007a4:	8401a583          	lw	a1,-1984(gp) # 80003920 <Next_Ptr_Glob>
800007a8:	43898513          	addi	a0,s3,1080
800007ac:	01058593          	addi	a1,a1,16
800007b0:	5a0000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
800007b4:	45490513          	addi	a0,s2,1108
800007b8:	6ac000ef          	jal	ra,80000e64 <puts>
  printf ("Int_1_Loc:           %d\n", Int_1_Loc);
800007bc:	01412583          	lw	a1,20(sp)
800007c0:	80003537          	lui	a0,0x80003
800007c4:	4d850513          	addi	a0,a0,1240 # 800034d8 <_stack_start+0xffffcbc8>
800007c8:	588000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 5);
800007cc:	00500593          	li	a1,5
800007d0:	29c40513          	addi	a0,s0,668
800007d4:	57c000ef          	jal	ra,80000d50 <printf>
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
800007d8:	00c12783          	lw	a5,12(sp)
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
800007dc:	80003537          	lui	a0,0x80003
800007e0:	4f450513          	addi	a0,a0,1268 # 800034f4 <_stack_start+0xffffcbe4>
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
800007e4:	41578ab3          	sub	s5,a5,s5
800007e8:	003a9793          	slli	a5,s5,0x3
800007ec:	41578ab3          	sub	s5,a5,s5
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
800007f0:	414a85b3          	sub	a1,s5,s4
800007f4:	55c000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 13);
800007f8:	00d00593          	li	a1,13
800007fc:	29c40513          	addi	a0,s0,668
80000800:	550000ef          	jal	ra,80000d50 <printf>
  printf ("Int_3_Loc:           %d\n", Int_3_Loc);
80000804:	01812583          	lw	a1,24(sp)
80000808:	80003537          	lui	a0,0x80003
8000080c:	51050513          	addi	a0,a0,1296 # 80003510 <_stack_start+0xffffcc00>
80000810:	540000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 7);
80000814:	00700593          	li	a1,7
80000818:	29c40513          	addi	a0,s0,668
8000081c:	534000ef          	jal	ra,80000d50 <printf>
  printf ("Enum_Loc:            %d\n", Enum_Loc);
80000820:	01c12583          	lw	a1,28(sp)
80000824:	80003537          	lui	a0,0x80003
80000828:	52c50513          	addi	a0,a0,1324 # 8000352c <_stack_start+0xffffcc1c>
8000082c:	524000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   %d\n", 1);
80000830:	00100593          	li	a1,1
80000834:	29c40513          	addi	a0,s0,668
80000838:	518000ef          	jal	ra,80000d50 <printf>
  printf ("Str_1_Loc:           %s\n", Str_1_Loc);
8000083c:	80003537          	lui	a0,0x80003
80000840:	02010593          	addi	a1,sp,32
80000844:	54850513          	addi	a0,a0,1352 # 80003548 <_stack_start+0xffffcc38>
80000848:	508000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
8000084c:	80003537          	lui	a0,0x80003
80000850:	56450513          	addi	a0,a0,1380 # 80003564 <_stack_start+0xffffcc54>
80000854:	610000ef          	jal	ra,80000e64 <puts>
  printf ("Str_2_Loc:           %s\n", Str_2_Loc);
80000858:	80003537          	lui	a0,0x80003
8000085c:	04010593          	addi	a1,sp,64
80000860:	59850513          	addi	a0,a0,1432 # 80003598 <_stack_start+0xffffcc88>
80000864:	4ec000ef          	jal	ra,80000d50 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
80000868:	80003537          	lui	a0,0x80003
8000086c:	5b450513          	addi	a0,a0,1460 # 800035b4 <_stack_start+0xffffcca4>
80000870:	5f4000ef          	jal	ra,80000e64 <puts>
  printf ("\n");
80000874:	00a00513          	li	a0,10
80000878:	630000ef          	jal	ra,80000ea8 <putchar>
  User_Time = End_Time - Begin_Time;
8000087c:	82c1a703          	lw	a4,-2004(gp) # 8000390c <Begin_Time>
80000880:	8281a583          	lw	a1,-2008(gp) # 80003908 <End_Time>
  if (User_Time < Too_Small_Time)
80000884:	1f300793          	li	a5,499
  User_Time = End_Time - Begin_Time;
80000888:	40e585b3          	sub	a1,a1,a4
8000088c:	82b1a223          	sw	a1,-2012(gp) # 80003904 <User_Time>
  if (User_Time < Too_Small_Time)
80000890:	1ab7d063          	ble	a1,a5,80000a30 <main2+0x738>
    printf ("Clock cycles=%d \n", User_Time);
80000894:	80003537          	lui	a0,0x80003
80000898:	64050513          	addi	a0,a0,1600 # 80003640 <_stack_start+0xffffcd30>
8000089c:	4b4000ef          	jal	ra,80000d50 <printf>
    Microseconds = (float) User_Time * Mic_secs_Per_Second 
800008a0:	8241a503          	lw	a0,-2012(gp) # 80003904 <User_Time>
800008a4:	370020ef          	jal	ra,80002c14 <__floatsisf>
800008a8:	00050413          	mv	s0,a0
800008ac:	48c020ef          	jal	ra,80002d38 <__extendsfdf2>
800008b0:	800047b7          	lui	a5,0x80004
800008b4:	8e07a603          	lw	a2,-1824(a5) # 800038e0 <_stack_start+0xffffcfd0>
800008b8:	8e47a683          	lw	a3,-1820(a5)
800008bc:	078010ef          	jal	ra,80001934 <__muldf3>
                        / ((float) CORE_HZ * ((float) Number_Of_Runs));
800008c0:	800047b7          	lui	a5,0x80004
800008c4:	8e87a603          	lw	a2,-1816(a5) # 800038e8 <_stack_start+0xffffcfd8>
800008c8:	8ec7a683          	lw	a3,-1812(a5)
800008cc:	059000ef          	jal	ra,80001124 <__divdf3>
800008d0:	574020ef          	jal	ra,80002e44 <__truncdfsf2>
800008d4:	82a1a023          	sw	a0,-2016(gp) # 80003900 <Microseconds>
                        / (float) User_Time;
800008d8:	800047b7          	lui	a5,0x80004
800008dc:	8f07a503          	lw	a0,-1808(a5) # 800038f0 <_stack_start+0xffffcfe0>
800008e0:	00040593          	mv	a1,s0
800008e4:	740010ef          	jal	ra,80002024 <__divsf3>
    Dhrystones_Per_Second = ((float) CORE_HZ * (float) Number_Of_Runs)
800008e8:	80a1ae23          	sw	a0,-2020(gp) # 800038fc <Dhrystones_Per_Second>
    printf ("DMIPS per Mhz:                              ");
800008ec:	80003537          	lui	a0,0x80003
800008f0:	65450513          	addi	a0,a0,1620 # 80003654 <_stack_start+0xffffcd44>
800008f4:	45c000ef          	jal	ra,80000d50 <printf>
    float dmips = (1e6f/1757.0f) * Number_Of_Runs / User_Time;
800008f8:	8241a503          	lw	a0,-2012(gp) # 80003904 <User_Time>
800008fc:	318020ef          	jal	ra,80002c14 <__floatsisf>
80000900:	800047b7          	lui	a5,0x80004
80000904:	00050593          	mv	a1,a0
80000908:	8f47a503          	lw	a0,-1804(a5) # 800038f4 <_stack_start+0xffffcfe4>
8000090c:	718010ef          	jal	ra,80002024 <__divsf3>
80000910:	00050413          	mv	s0,a0
    int dmipsNatural = dmips;
80000914:	290020ef          	jal	ra,80002ba4 <__fixsfsi>
80000918:	00050493          	mv	s1,a0
    int dmipsReal = (dmips - dmipsNatural)*100.0f;
8000091c:	2f8020ef          	jal	ra,80002c14 <__floatsisf>
80000920:	00050593          	mv	a1,a0
80000924:	00040513          	mv	a0,s0
80000928:	605010ef          	jal	ra,8000272c <__subsf3>
8000092c:	800047b7          	lui	a5,0x80004
80000930:	8f87a583          	lw	a1,-1800(a5) # 800038f8 <_stack_start+0xffffcfe8>
80000934:	289010ef          	jal	ra,800023bc <__mulsf3>
80000938:	26c020ef          	jal	ra,80002ba4 <__fixsfsi>
8000093c:	00050413          	mv	s0,a0
    printf ("%d.", dmipsNatural);
80000940:	80003537          	lui	a0,0x80003
80000944:	00048593          	mv	a1,s1
80000948:	68450513          	addi	a0,a0,1668 # 80003684 <_stack_start+0xffffcd74>
8000094c:	404000ef          	jal	ra,80000d50 <printf>
    if(dmipsReal < 10) printf("0");
80000950:	00900793          	li	a5,9
80000954:	1087d063          	ble	s0,a5,80000a54 <main2+0x75c>
    printf ("%d", dmipsReal);
80000958:	80003537          	lui	a0,0x80003
8000095c:	00040593          	mv	a1,s0
80000960:	68850513          	addi	a0,a0,1672 # 80003688 <_stack_start+0xffffcd78>
80000964:	3ec000ef          	jal	ra,80000d50 <printf>
    printf ("\n");
80000968:	00a00513          	li	a0,10
8000096c:	53c000ef          	jal	ra,80000ea8 <putchar>
}
80000970:	09c12083          	lw	ra,156(sp)
80000974:	09812403          	lw	s0,152(sp)
80000978:	09412483          	lw	s1,148(sp)
8000097c:	09012903          	lw	s2,144(sp)
80000980:	08c12983          	lw	s3,140(sp)
80000984:	08812a03          	lw	s4,136(sp)
80000988:	08412a83          	lw	s5,132(sp)
8000098c:	08012b03          	lw	s6,128(sp)
80000990:	07c12b83          	lw	s7,124(sp)
80000994:	07812c03          	lw	s8,120(sp)
80000998:	07412c83          	lw	s9,116(sp)
8000099c:	07012d03          	lw	s10,112(sp)
800009a0:	06c12d83          	lw	s11,108(sp)
800009a4:	0a010113          	addi	sp,sp,160
800009a8:	00008067          	ret
        Proc_6 (Ident_1, &Enum_Loc);
800009ac:	01c10593          	addi	a1,sp,28
800009b0:	00000513          	li	a0,0
800009b4:	1e8000ef          	jal	ra,80000b9c <Proc_6>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
800009b8:	004cae03          	lw	t3,4(s9)
800009bc:	008ca303          	lw	t1,8(s9)
800009c0:	00cca883          	lw	a7,12(s9)
800009c4:	010ca803          	lw	a6,16(s9)
800009c8:	014ca503          	lw	a0,20(s9)
800009cc:	018ca583          	lw	a1,24(s9)
800009d0:	01ccd603          	lhu	a2,28(s9)
800009d4:	01ecc703          	lbu	a4,30(s9)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800009d8:	8341c783          	lbu	a5,-1996(gp) # 80003914 <Ch_2_Glob>
800009dc:	001a8a93          	addi	s5,s5,1
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
800009e0:	05712023          	sw	s7,64(sp)
800009e4:	05c12223          	sw	t3,68(sp)
800009e8:	04612423          	sw	t1,72(sp)
800009ec:	05112623          	sw	a7,76(sp)
800009f0:	05012823          	sw	a6,80(sp)
800009f4:	04a12a23          	sw	a0,84(sp)
800009f8:	04b12c23          	sw	a1,88(sp)
800009fc:	04c11e23          	sh	a2,92(sp)
80000a00:	04e10f23          	sb	a4,94(sp)
        Int_Glob = Run_Index;
80000a04:	8331ae23          	sw	s3,-1988(gp) # 8000391c <Int_Glob>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
80000a08:	0ffafa93          	andi	s5,s5,255
80000a0c:	00098a13          	mv	s4,s3
80000a10:	b357f2e3          	bleu	s5,a5,80000534 <main2+0x23c>
80000a14:	b45ff06f          	j	80000558 <main2+0x260>
    printf ("Program compiled without 'register' attribute\n");
80000a18:	80003537          	lui	a0,0x80003
80000a1c:	1a050513          	addi	a0,a0,416 # 800031a0 <_stack_start+0xffffc890>
80000a20:	444000ef          	jal	ra,80000e64 <puts>
    printf ("\n");
80000a24:	00a00513          	li	a0,10
80000a28:	480000ef          	jal	ra,80000ea8 <putchar>
80000a2c:	9e5ff06f          	j	80000410 <main2+0x118>
    printf ("Measured time too small to obtain meaningful results\n");
80000a30:	80003537          	lui	a0,0x80003
80000a34:	5e850513          	addi	a0,a0,1512 # 800035e8 <_stack_start+0xffffccd8>
80000a38:	42c000ef          	jal	ra,80000e64 <puts>
    printf ("Please increase number of runs\n");
80000a3c:	80003537          	lui	a0,0x80003
80000a40:	62050513          	addi	a0,a0,1568 # 80003620 <_stack_start+0xffffcd10>
80000a44:	420000ef          	jal	ra,80000e64 <puts>
    printf ("\n");
80000a48:	00a00513          	li	a0,10
80000a4c:	45c000ef          	jal	ra,80000ea8 <putchar>
80000a50:	f21ff06f          	j	80000970 <main2+0x678>
    if(dmipsReal < 10) printf("0");
80000a54:	03000513          	li	a0,48
80000a58:	450000ef          	jal	ra,80000ea8 <putchar>
80000a5c:	efdff06f          	j	80000958 <main2+0x660>

80000a60 <Proc_7>:
One_Fifty       Int_2_Par_Val;
One_Fifty      *Int_Par_Ref;
{
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 2;
80000a60:	00250513          	addi	a0,a0,2
  *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
80000a64:	00b505b3          	add	a1,a0,a1
80000a68:	00b62023          	sw	a1,0(a2)
} /* Proc_7 */
80000a6c:	00008067          	ret

80000a70 <Proc_8>:
    /* Int_Par_Val_2 == 7 */
Arr_1_Dim       Arr_1_Par_Ref;
Arr_2_Dim       Arr_2_Par_Ref;
int             Int_1_Par_Val;
int             Int_2_Par_Val;
{
80000a70:	fe010113          	addi	sp,sp,-32
80000a74:	01312623          	sw	s3,12(sp)
  REG One_Fifty Int_Index;
  REG One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 5;
80000a78:	00560993          	addi	s3,a2,5
{
80000a7c:	00912a23          	sw	s1,20(sp)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
80000a80:	00299493          	slli	s1,s3,0x2
{
80000a84:	00812c23          	sw	s0,24(sp)
80000a88:	01212823          	sw	s2,16(sp)
80000a8c:	00112e23          	sw	ra,28(sp)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
80000a90:	009504b3          	add	s1,a0,s1
{
80000a94:	00060913          	mv	s2,a2
80000a98:	00058413          	mv	s0,a1
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
80000a9c:	0734ac23          	sw	s3,120(s1)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
80000aa0:	00d4a023          	sw	a3,0(s1)
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
80000aa4:	00d4a223          	sw	a3,4(s1)
  for (Int_Index = Int_Loc; Int_Index <= Int_Loc+1; ++Int_Index)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
80000aa8:	00098513          	mv	a0,s3
80000aac:	0c800593          	li	a1,200
80000ab0:	52c020ef          	jal	ra,80002fdc <__mulsi3>
80000ab4:	00291913          	slli	s2,s2,0x2
80000ab8:	012507b3          	add	a5,a0,s2
80000abc:	00f407b3          	add	a5,s0,a5
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
80000ac0:	0107a703          	lw	a4,16(a5)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
80000ac4:	0137aa23          	sw	s3,20(a5)
80000ac8:	0137ac23          	sw	s3,24(a5)
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
80000acc:	00170713          	addi	a4,a4,1
80000ad0:	00e7a823          	sw	a4,16(a5)
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
80000ad4:	0004a783          	lw	a5,0(s1)
80000ad8:	00a40433          	add	s0,s0,a0
80000adc:	01240433          	add	s0,s0,s2
80000ae0:	00001637          	lui	a2,0x1
80000ae4:	00860433          	add	s0,a2,s0
80000ae8:	faf42a23          	sw	a5,-76(s0)
  Int_Glob = 5;
} /* Proc_8 */
80000aec:	01c12083          	lw	ra,28(sp)
80000af0:	01812403          	lw	s0,24(sp)
  Int_Glob = 5;
80000af4:	00500713          	li	a4,5
80000af8:	82e1ae23          	sw	a4,-1988(gp) # 8000391c <Int_Glob>
} /* Proc_8 */
80000afc:	01412483          	lw	s1,20(sp)
80000b00:	01012903          	lw	s2,16(sp)
80000b04:	00c12983          	lw	s3,12(sp)
80000b08:	02010113          	addi	sp,sp,32
80000b0c:	00008067          	ret

80000b10 <Func_1>:
    /* second call:     Ch_1_Par_Val == 'A', Ch_2_Par_Val == 'C'    */
    /* third call:      Ch_1_Par_Val == 'B', Ch_2_Par_Val == 'C'    */

Capital_Letter   Ch_1_Par_Val;
Capital_Letter   Ch_2_Par_Val;
{
80000b10:	0ff57513          	andi	a0,a0,255
80000b14:	0ff5f593          	andi	a1,a1,255
  Capital_Letter        Ch_1_Loc;
  Capital_Letter        Ch_2_Loc;

  Ch_1_Loc = Ch_1_Par_Val;
  Ch_2_Loc = Ch_1_Loc;
  if (Ch_2_Loc != Ch_2_Par_Val)
80000b18:	00b50663          	beq	a0,a1,80000b24 <Func_1+0x14>
    /* then, executed */
    return (Ident_1);
80000b1c:	00000513          	li	a0,0
  else  /* not executed */
  {
    Ch_1_Glob = Ch_1_Loc;
    return (Ident_2);
   }
} /* Func_1 */
80000b20:	00008067          	ret
    Ch_1_Glob = Ch_1_Loc;
80000b24:	82a18aa3          	sb	a0,-1995(gp) # 80003915 <Ch_1_Glob>
    return (Ident_2);
80000b28:	00100513          	li	a0,1
80000b2c:	00008067          	ret

80000b30 <Func_2>:
    /* Str_1_Par_Ref == "DHRYSTONE PROGRAM, 1'ST STRING" */
    /* Str_2_Par_Ref == "DHRYSTONE PROGRAM, 2'ND STRING" */

Str_30  Str_1_Par_Ref;
Str_30  Str_2_Par_Ref;
{
80000b30:	ff010113          	addi	sp,sp,-16
80000b34:	00812423          	sw	s0,8(sp)
80000b38:	00912223          	sw	s1,4(sp)
80000b3c:	00112623          	sw	ra,12(sp)
80000b40:	00050413          	mv	s0,a0
80000b44:	00058493          	mv	s1,a1
  REG One_Thirty        Int_Loc;
      Capital_Letter    Ch_Loc;

  Int_Loc = 2;
  while (Int_Loc <= 2) /* loop body executed once */
    if (Func_1 (Str_1_Par_Ref[Int_Loc],
80000b48:	0034c583          	lbu	a1,3(s1)
80000b4c:	00244503          	lbu	a0,2(s0)
80000b50:	fc1ff0ef          	jal	ra,80000b10 <Func_1>
80000b54:	fe051ae3          	bnez	a0,80000b48 <Func_2+0x18>
  if (Ch_Loc == 'R')
    /* then, not executed */
    return (true);
  else /* executed */
  {
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
80000b58:	00048593          	mv	a1,s1
80000b5c:	00040513          	mv	a0,s0
80000b60:	448000ef          	jal	ra,80000fa8 <strcmp>
      Int_Loc += 7;
      Int_Glob = Int_Loc;
      return (true);
    }
    else /* executed */
      return (false);
80000b64:	00000793          	li	a5,0
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
80000b68:	00a05863          	blez	a0,80000b78 <Func_2+0x48>
      Int_Glob = Int_Loc;
80000b6c:	00a00713          	li	a4,10
80000b70:	82e1ae23          	sw	a4,-1988(gp) # 8000391c <Int_Glob>
      return (true);
80000b74:	00100793          	li	a5,1
  } /* if Ch_Loc */
} /* Func_2 */
80000b78:	00c12083          	lw	ra,12(sp)
80000b7c:	00812403          	lw	s0,8(sp)
80000b80:	00412483          	lw	s1,4(sp)
80000b84:	00078513          	mv	a0,a5
80000b88:	01010113          	addi	sp,sp,16
80000b8c:	00008067          	ret

80000b90 <Func_3>:
Enumeration Enum_Par_Val;
{
  Enumeration Enum_Loc;

  Enum_Loc = Enum_Par_Val;
  if (Enum_Loc == Ident_3)
80000b90:	ffe50513          	addi	a0,a0,-2
    /* then, executed */
    return (true);
  else /* not executed */
    return (false);
} /* Func_3 */
80000b94:	00153513          	seqz	a0,a0
80000b98:	00008067          	ret

80000b9c <Proc_6>:
{
80000b9c:	ff010113          	addi	sp,sp,-16
80000ba0:	00812423          	sw	s0,8(sp)
80000ba4:	00912223          	sw	s1,4(sp)
80000ba8:	00112623          	sw	ra,12(sp)
80000bac:	00050413          	mv	s0,a0
80000bb0:	00058493          	mv	s1,a1
  if (! Func_3 (Enum_Val_Par))
80000bb4:	fddff0ef          	jal	ra,80000b90 <Func_3>
80000bb8:	02050e63          	beqz	a0,80000bf4 <Proc_6+0x58>
  *Enum_Ref_Par = Enum_Val_Par;
80000bbc:	0084a023          	sw	s0,0(s1)
  switch (Enum_Val_Par)
80000bc0:	00100793          	li	a5,1
80000bc4:	04f40063          	beq	s0,a5,80000c04 <Proc_6+0x68>
80000bc8:	04040463          	beqz	s0,80000c10 <Proc_6+0x74>
80000bcc:	00200713          	li	a4,2
80000bd0:	04e40c63          	beq	s0,a4,80000c28 <Proc_6+0x8c>
80000bd4:	00400793          	li	a5,4
80000bd8:	00f41463          	bne	s0,a5,80000be0 <Proc_6+0x44>
      *Enum_Ref_Par = Ident_3;
80000bdc:	00e4a023          	sw	a4,0(s1)
} /* Proc_6 */
80000be0:	00c12083          	lw	ra,12(sp)
80000be4:	00812403          	lw	s0,8(sp)
80000be8:	00412483          	lw	s1,4(sp)
80000bec:	01010113          	addi	sp,sp,16
80000bf0:	00008067          	ret
    *Enum_Ref_Par = Ident_4;
80000bf4:	00300793          	li	a5,3
80000bf8:	00f4a023          	sw	a5,0(s1)
  switch (Enum_Val_Par)
80000bfc:	00100793          	li	a5,1
80000c00:	fcf414e3          	bne	s0,a5,80000bc8 <Proc_6+0x2c>
      if (Int_Glob > 100)
80000c04:	83c1a703          	lw	a4,-1988(gp) # 8000391c <Int_Glob>
80000c08:	06400793          	li	a5,100
80000c0c:	02e7da63          	ble	a4,a5,80000c40 <Proc_6+0xa4>
} /* Proc_6 */
80000c10:	00c12083          	lw	ra,12(sp)
80000c14:	00812403          	lw	s0,8(sp)
      *Enum_Ref_Par = Ident_1;
80000c18:	0004a023          	sw	zero,0(s1)
} /* Proc_6 */
80000c1c:	00412483          	lw	s1,4(sp)
80000c20:	01010113          	addi	sp,sp,16
80000c24:	00008067          	ret
80000c28:	00c12083          	lw	ra,12(sp)
80000c2c:	00812403          	lw	s0,8(sp)
      *Enum_Ref_Par = Ident_2;
80000c30:	00f4a023          	sw	a5,0(s1)
} /* Proc_6 */
80000c34:	00412483          	lw	s1,4(sp)
80000c38:	01010113          	addi	sp,sp,16
80000c3c:	00008067          	ret
80000c40:	00c12083          	lw	ra,12(sp)
80000c44:	00812403          	lw	s0,8(sp)
      else *Enum_Ref_Par = Ident_4;
80000c48:	00300793          	li	a5,3
80000c4c:	00f4a023          	sw	a5,0(s1)
} /* Proc_6 */
80000c50:	00412483          	lw	s1,4(sp)
80000c54:	01010113          	addi	sp,sp,16
80000c58:	00008067          	ret

80000c5c <printf_s>:
{
	putchar(c);
}

static void printf_s(char *p)
{
80000c5c:	ff010113          	addi	sp,sp,-16
80000c60:	00812423          	sw	s0,8(sp)
80000c64:	00112623          	sw	ra,12(sp)
80000c68:	00050413          	mv	s0,a0
	while (*p)
80000c6c:	00054503          	lbu	a0,0(a0)
80000c70:	00050a63          	beqz	a0,80000c84 <printf_s+0x28>
		putchar(*(p++));
80000c74:	00140413          	addi	s0,s0,1
80000c78:	230000ef          	jal	ra,80000ea8 <putchar>
	while (*p)
80000c7c:	00044503          	lbu	a0,0(s0)
80000c80:	fe051ae3          	bnez	a0,80000c74 <printf_s+0x18>
}
80000c84:	00c12083          	lw	ra,12(sp)
80000c88:	00812403          	lw	s0,8(sp)
80000c8c:	01010113          	addi	sp,sp,16
80000c90:	00008067          	ret

80000c94 <printf_c>:
	putchar(c);
80000c94:	2140006f          	j	80000ea8 <putchar>

80000c98 <printf_d>:

static void printf_d(int val)
{
80000c98:	fd010113          	addi	sp,sp,-48
80000c9c:	02912223          	sw	s1,36(sp)
80000ca0:	02112623          	sw	ra,44(sp)
80000ca4:	02812423          	sw	s0,40(sp)
80000ca8:	03212023          	sw	s2,32(sp)
80000cac:	00050493          	mv	s1,a0
	char buffer[32];
	char *p = buffer;
	if (val < 0) {
80000cb0:	06054463          	bltz	a0,80000d18 <printf_d+0x80>
{
80000cb4:	00010913          	mv	s2,sp
80000cb8:	00090413          	mv	s0,s2
80000cbc:	0240006f          	j	80000ce0 <printf_d+0x48>
		printf_c('-');
		val = -val;
	}
	while (val || p == buffer) {
		*(p++) = '0' + val % 10;
80000cc0:	3c4020ef          	jal	ra,80003084 <__modsi3>
80000cc4:	03050793          	addi	a5,a0,48
80000cc8:	00140413          	addi	s0,s0,1
		val = val / 10;
80000ccc:	00048513          	mv	a0,s1
80000cd0:	00a00593          	li	a1,10
		*(p++) = '0' + val % 10;
80000cd4:	fef40fa3          	sb	a5,-1(s0)
		val = val / 10;
80000cd8:	328020ef          	jal	ra,80003000 <__divsi3>
80000cdc:	00050493          	mv	s1,a0
		*(p++) = '0' + val % 10;
80000ce0:	00a00593          	li	a1,10
80000ce4:	00048513          	mv	a0,s1
	while (val || p == buffer) {
80000ce8:	fc049ce3          	bnez	s1,80000cc0 <printf_d+0x28>
80000cec:	fd240ae3          	beq	s0,s2,80000cc0 <printf_d+0x28>
	}
	while (p != buffer)
		printf_c(*(--p));
80000cf0:	fff40413          	addi	s0,s0,-1
80000cf4:	00044503          	lbu	a0,0(s0)
80000cf8:	f9dff0ef          	jal	ra,80000c94 <printf_c>
	while (p != buffer)
80000cfc:	ff241ae3          	bne	s0,s2,80000cf0 <printf_d+0x58>
}
80000d00:	02c12083          	lw	ra,44(sp)
80000d04:	02812403          	lw	s0,40(sp)
80000d08:	02412483          	lw	s1,36(sp)
80000d0c:	02012903          	lw	s2,32(sp)
80000d10:	03010113          	addi	sp,sp,48
80000d14:	00008067          	ret
		printf_c('-');
80000d18:	02d00513          	li	a0,45
80000d1c:	f79ff0ef          	jal	ra,80000c94 <printf_c>
		val = -val;
80000d20:	409004b3          	neg	s1,s1
80000d24:	f91ff06f          	j	80000cb4 <printf_d+0x1c>

80000d28 <malloc>:
	char *p = heap_memory + heap_memory_used;
80000d28:	8481a703          	lw	a4,-1976(gp) # 80003928 <heap_memory_used>
	heap_memory_used += size;
80000d2c:	00a707b3          	add	a5,a4,a0
	char *p = heap_memory + heap_memory_used;
80000d30:	80006537          	lui	a0,0x80006
	heap_memory_used += size;
80000d34:	84f1a423          	sw	a5,-1976(gp) # 80003928 <heap_memory_used>
	char *p = heap_memory + heap_memory_used;
80000d38:	10450513          	addi	a0,a0,260 # 80006104 <_stack_start+0xfffff7f4>
	if (heap_memory_used > 1024)
80000d3c:	40000693          	li	a3,1024
	char *p = heap_memory + heap_memory_used;
80000d40:	00e50533          	add	a0,a0,a4
	if (heap_memory_used > 1024)
80000d44:	00f6d463          	ble	a5,a3,80000d4c <malloc+0x24>
		asm volatile ("ebreak");
80000d48:	00100073          	ebreak
}
80000d4c:	00008067          	ret

80000d50 <printf>:

int printf(const char *format, ...)
{
80000d50:	fb010113          	addi	sp,sp,-80
80000d54:	01412c23          	sw	s4,24(sp)
80000d58:	02112623          	sw	ra,44(sp)
80000d5c:	02812423          	sw	s0,40(sp)
80000d60:	02912223          	sw	s1,36(sp)
80000d64:	03212023          	sw	s2,32(sp)
80000d68:	01312e23          	sw	s3,28(sp)
80000d6c:	01512a23          	sw	s5,20(sp)
80000d70:	00050a13          	mv	s4,a0
	int i;
	va_list ap;

	va_start(ap, format);

	for (i = 0; format[i]; i++)
80000d74:	00054503          	lbu	a0,0(a0)
{
80000d78:	04f12223          	sw	a5,68(sp)
	va_start(ap, format);
80000d7c:	03410793          	addi	a5,sp,52
{
80000d80:	02b12a23          	sw	a1,52(sp)
80000d84:	02c12c23          	sw	a2,56(sp)
80000d88:	02d12e23          	sw	a3,60(sp)
80000d8c:	04e12023          	sw	a4,64(sp)
80000d90:	05012423          	sw	a6,72(sp)
80000d94:	05112623          	sw	a7,76(sp)
	va_start(ap, format);
80000d98:	00f12623          	sw	a5,12(sp)
	for (i = 0; format[i]; i++)
80000d9c:	02050863          	beqz	a0,80000dcc <printf+0x7c>
80000da0:	00000413          	li	s0,0
		if (format[i] == '%') {
80000da4:	02500a93          	li	s5,37
			while (format[++i]) {
				if (format[i] == 'c') {
80000da8:	06300493          	li	s1,99
					printf_c(va_arg(ap,int));
					break;
				}
				if (format[i] == 's') {
80000dac:	07300913          	li	s2,115
					printf_s(va_arg(ap,char*));
					break;
				}
				if (format[i] == 'd') {
80000db0:	06400993          	li	s3,100
		if (format[i] == '%') {
80000db4:	03550e63          	beq	a0,s5,80000df0 <printf+0xa0>
					printf_d(va_arg(ap,int));
					break;
				}
			}
		} else
			printf_c(format[i]);
80000db8:	eddff0ef          	jal	ra,80000c94 <printf_c>
	for (i = 0; format[i]; i++)
80000dbc:	00140413          	addi	s0,s0,1
80000dc0:	008a07b3          	add	a5,s4,s0
80000dc4:	0007c503          	lbu	a0,0(a5)
80000dc8:	fe0516e3          	bnez	a0,80000db4 <printf+0x64>

	va_end(ap);
}
80000dcc:	02c12083          	lw	ra,44(sp)
80000dd0:	02812403          	lw	s0,40(sp)
80000dd4:	02412483          	lw	s1,36(sp)
80000dd8:	02012903          	lw	s2,32(sp)
80000ddc:	01c12983          	lw	s3,28(sp)
80000de0:	01812a03          	lw	s4,24(sp)
80000de4:	01412a83          	lw	s5,20(sp)
80000de8:	05010113          	addi	sp,sp,80
80000dec:	00008067          	ret
80000df0:	00140693          	addi	a3,s0,1
80000df4:	00da0733          	add	a4,s4,a3
80000df8:	0100006f          	j	80000e08 <printf+0xb8>
				if (format[i] == 's') {
80000dfc:	03278c63          	beq	a5,s2,80000e34 <printf+0xe4>
				if (format[i] == 'd') {
80000e00:	05378663          	beq	a5,s3,80000e4c <printf+0xfc>
80000e04:	00168693          	addi	a3,a3,1
			while (format[++i]) {
80000e08:	00074783          	lbu	a5,0(a4)
80000e0c:	00068413          	mv	s0,a3
80000e10:	00170713          	addi	a4,a4,1
80000e14:	fa0784e3          	beqz	a5,80000dbc <printf+0x6c>
				if (format[i] == 'c') {
80000e18:	fe9792e3          	bne	a5,s1,80000dfc <printf+0xac>
					printf_c(va_arg(ap,int));
80000e1c:	00c12783          	lw	a5,12(sp)
80000e20:	0007a503          	lw	a0,0(a5)
80000e24:	00478793          	addi	a5,a5,4
80000e28:	00f12623          	sw	a5,12(sp)
80000e2c:	e69ff0ef          	jal	ra,80000c94 <printf_c>
					break;
80000e30:	f8dff06f          	j	80000dbc <printf+0x6c>
					printf_s(va_arg(ap,char*));
80000e34:	00c12783          	lw	a5,12(sp)
80000e38:	0007a503          	lw	a0,0(a5)
80000e3c:	00478793          	addi	a5,a5,4
80000e40:	00f12623          	sw	a5,12(sp)
80000e44:	e19ff0ef          	jal	ra,80000c5c <printf_s>
					break;
80000e48:	f75ff06f          	j	80000dbc <printf+0x6c>
					printf_d(va_arg(ap,int));
80000e4c:	00c12783          	lw	a5,12(sp)
80000e50:	0007a503          	lw	a0,0(a5)
80000e54:	00478793          	addi	a5,a5,4
80000e58:	00f12623          	sw	a5,12(sp)
80000e5c:	e3dff0ef          	jal	ra,80000c98 <printf_d>
					break;
80000e60:	f5dff06f          	j	80000dbc <printf+0x6c>

80000e64 <puts>:


int puts(char *s){
80000e64:	ff010113          	addi	sp,sp,-16
80000e68:	00812423          	sw	s0,8(sp)
80000e6c:	00112623          	sw	ra,12(sp)
80000e70:	00050413          	mv	s0,a0
  while (*s) {
80000e74:	00054503          	lbu	a0,0(a0)
80000e78:	00050a63          	beqz	a0,80000e8c <puts+0x28>
    putchar(*s);
    s++;
80000e7c:	00140413          	addi	s0,s0,1
    putchar(*s);
80000e80:	028000ef          	jal	ra,80000ea8 <putchar>
  while (*s) {
80000e84:	00044503          	lbu	a0,0(s0)
80000e88:	fe051ae3          	bnez	a0,80000e7c <puts+0x18>
  }
  putchar('\n');
80000e8c:	00a00513          	li	a0,10
80000e90:	018000ef          	jal	ra,80000ea8 <putchar>
  return 0;
}
80000e94:	00c12083          	lw	ra,12(sp)
80000e98:	00812403          	lw	s0,8(sp)
80000e9c:	00000513          	li	a0,0
80000ea0:	01010113          	addi	sp,sp,16
80000ea4:	00008067          	ret

80000ea8 <putchar>:

void putchar(char c){
	TEST_COM_BASE[0] = c;
80000ea8:	f01007b7          	lui	a5,0xf0100
80000eac:	f0a7a023          	sw	a0,-256(a5) # f00fff00 <_stack_start+0x700f95f0>
}
80000eb0:	00008067          	ret

80000eb4 <clock>:

#include <time.h>
clock_t	clock(){
  return TEST_COM_BASE[4];
80000eb4:	f01007b7          	lui	a5,0xf0100
80000eb8:	f107a503          	lw	a0,-240(a5) # f00fff10 <_stack_start+0x700f9600>
}
80000ebc:	00008067          	ret

80000ec0 <memcpy>:
80000ec0:	00a5c7b3          	xor	a5,a1,a0
80000ec4:	0037f793          	andi	a5,a5,3
80000ec8:	00c50733          	add	a4,a0,a2
80000ecc:	00079663          	bnez	a5,80000ed8 <memcpy+0x18>
80000ed0:	00300793          	li	a5,3
80000ed4:	02c7e463          	bltu	a5,a2,80000efc <memcpy+0x3c>
80000ed8:	00050793          	mv	a5,a0
80000edc:	00e56c63          	bltu	a0,a4,80000ef4 <memcpy+0x34>
80000ee0:	00008067          	ret
80000ee4:	0005c683          	lbu	a3,0(a1)
80000ee8:	00178793          	addi	a5,a5,1
80000eec:	00158593          	addi	a1,a1,1
80000ef0:	fed78fa3          	sb	a3,-1(a5)
80000ef4:	fee7e8e3          	bltu	a5,a4,80000ee4 <memcpy+0x24>
80000ef8:	00008067          	ret
80000efc:	00357793          	andi	a5,a0,3
80000f00:	08079263          	bnez	a5,80000f84 <memcpy+0xc4>
80000f04:	00050793          	mv	a5,a0
80000f08:	ffc77693          	andi	a3,a4,-4
80000f0c:	fe068613          	addi	a2,a3,-32
80000f10:	08c7f663          	bleu	a2,a5,80000f9c <memcpy+0xdc>
80000f14:	0005a383          	lw	t2,0(a1)
80000f18:	0045a283          	lw	t0,4(a1)
80000f1c:	0085af83          	lw	t6,8(a1)
80000f20:	00c5af03          	lw	t5,12(a1)
80000f24:	0105ae83          	lw	t4,16(a1)
80000f28:	0145ae03          	lw	t3,20(a1)
80000f2c:	0185a303          	lw	t1,24(a1)
80000f30:	01c5a883          	lw	a7,28(a1)
80000f34:	02458593          	addi	a1,a1,36
80000f38:	02478793          	addi	a5,a5,36
80000f3c:	ffc5a803          	lw	a6,-4(a1)
80000f40:	fc77ae23          	sw	t2,-36(a5)
80000f44:	fe57a023          	sw	t0,-32(a5)
80000f48:	fff7a223          	sw	t6,-28(a5)
80000f4c:	ffe7a423          	sw	t5,-24(a5)
80000f50:	ffd7a623          	sw	t4,-20(a5)
80000f54:	ffc7a823          	sw	t3,-16(a5)
80000f58:	fe67aa23          	sw	t1,-12(a5)
80000f5c:	ff17ac23          	sw	a7,-8(a5)
80000f60:	ff07ae23          	sw	a6,-4(a5)
80000f64:	fadff06f          	j	80000f10 <memcpy+0x50>
80000f68:	0005c683          	lbu	a3,0(a1)
80000f6c:	00178793          	addi	a5,a5,1
80000f70:	00158593          	addi	a1,a1,1
80000f74:	fed78fa3          	sb	a3,-1(a5)
80000f78:	0037f693          	andi	a3,a5,3
80000f7c:	fe0696e3          	bnez	a3,80000f68 <memcpy+0xa8>
80000f80:	f89ff06f          	j	80000f08 <memcpy+0x48>
80000f84:	00050793          	mv	a5,a0
80000f88:	ff1ff06f          	j	80000f78 <memcpy+0xb8>
80000f8c:	0005a603          	lw	a2,0(a1)
80000f90:	00478793          	addi	a5,a5,4
80000f94:	00458593          	addi	a1,a1,4
80000f98:	fec7ae23          	sw	a2,-4(a5)
80000f9c:	fed7e8e3          	bltu	a5,a3,80000f8c <memcpy+0xcc>
80000fa0:	f4e7eae3          	bltu	a5,a4,80000ef4 <memcpy+0x34>
80000fa4:	00008067          	ret

80000fa8 <strcmp>:
80000fa8:	00b56733          	or	a4,a0,a1
80000fac:	fff00393          	li	t2,-1
80000fb0:	00377713          	andi	a4,a4,3
80000fb4:	10071063          	bnez	a4,800010b4 <strcmp+0x10c>
80000fb8:	7f7f87b7          	lui	a5,0x7f7f8
80000fbc:	f7f78793          	addi	a5,a5,-129 # 7f7f7f7f <_stack_size+0x7f7f7b7f>
80000fc0:	00052603          	lw	a2,0(a0)
80000fc4:	0005a683          	lw	a3,0(a1)
80000fc8:	00f672b3          	and	t0,a2,a5
80000fcc:	00f66333          	or	t1,a2,a5
80000fd0:	00f282b3          	add	t0,t0,a5
80000fd4:	0062e2b3          	or	t0,t0,t1
80000fd8:	10729263          	bne	t0,t2,800010dc <strcmp+0x134>
80000fdc:	08d61663          	bne	a2,a3,80001068 <strcmp+0xc0>
80000fe0:	00452603          	lw	a2,4(a0)
80000fe4:	0045a683          	lw	a3,4(a1)
80000fe8:	00f672b3          	and	t0,a2,a5
80000fec:	00f66333          	or	t1,a2,a5
80000ff0:	00f282b3          	add	t0,t0,a5
80000ff4:	0062e2b3          	or	t0,t0,t1
80000ff8:	0c729e63          	bne	t0,t2,800010d4 <strcmp+0x12c>
80000ffc:	06d61663          	bne	a2,a3,80001068 <strcmp+0xc0>
80001000:	00852603          	lw	a2,8(a0)
80001004:	0085a683          	lw	a3,8(a1)
80001008:	00f672b3          	and	t0,a2,a5
8000100c:	00f66333          	or	t1,a2,a5
80001010:	00f282b3          	add	t0,t0,a5
80001014:	0062e2b3          	or	t0,t0,t1
80001018:	0c729863          	bne	t0,t2,800010e8 <strcmp+0x140>
8000101c:	04d61663          	bne	a2,a3,80001068 <strcmp+0xc0>
80001020:	00c52603          	lw	a2,12(a0)
80001024:	00c5a683          	lw	a3,12(a1)
80001028:	00f672b3          	and	t0,a2,a5
8000102c:	00f66333          	or	t1,a2,a5
80001030:	00f282b3          	add	t0,t0,a5
80001034:	0062e2b3          	or	t0,t0,t1
80001038:	0c729263          	bne	t0,t2,800010fc <strcmp+0x154>
8000103c:	02d61663          	bne	a2,a3,80001068 <strcmp+0xc0>
80001040:	01052603          	lw	a2,16(a0)
80001044:	0105a683          	lw	a3,16(a1)
80001048:	00f672b3          	and	t0,a2,a5
8000104c:	00f66333          	or	t1,a2,a5
80001050:	00f282b3          	add	t0,t0,a5
80001054:	0062e2b3          	or	t0,t0,t1
80001058:	0a729c63          	bne	t0,t2,80001110 <strcmp+0x168>
8000105c:	01450513          	addi	a0,a0,20
80001060:	01458593          	addi	a1,a1,20
80001064:	f4d60ee3          	beq	a2,a3,80000fc0 <strcmp+0x18>
80001068:	01061713          	slli	a4,a2,0x10
8000106c:	01069793          	slli	a5,a3,0x10
80001070:	00f71e63          	bne	a4,a5,8000108c <strcmp+0xe4>
80001074:	01065713          	srli	a4,a2,0x10
80001078:	0106d793          	srli	a5,a3,0x10
8000107c:	40f70533          	sub	a0,a4,a5
80001080:	0ff57593          	andi	a1,a0,255
80001084:	02059063          	bnez	a1,800010a4 <strcmp+0xfc>
80001088:	00008067          	ret
8000108c:	01075713          	srli	a4,a4,0x10
80001090:	0107d793          	srli	a5,a5,0x10
80001094:	40f70533          	sub	a0,a4,a5
80001098:	0ff57593          	andi	a1,a0,255
8000109c:	00059463          	bnez	a1,800010a4 <strcmp+0xfc>
800010a0:	00008067          	ret
800010a4:	0ff77713          	andi	a4,a4,255
800010a8:	0ff7f793          	andi	a5,a5,255
800010ac:	40f70533          	sub	a0,a4,a5
800010b0:	00008067          	ret
800010b4:	00054603          	lbu	a2,0(a0)
800010b8:	0005c683          	lbu	a3,0(a1)
800010bc:	00150513          	addi	a0,a0,1
800010c0:	00158593          	addi	a1,a1,1
800010c4:	00d61463          	bne	a2,a3,800010cc <strcmp+0x124>
800010c8:	fe0616e3          	bnez	a2,800010b4 <strcmp+0x10c>
800010cc:	40d60533          	sub	a0,a2,a3
800010d0:	00008067          	ret
800010d4:	00450513          	addi	a0,a0,4
800010d8:	00458593          	addi	a1,a1,4
800010dc:	fcd61ce3          	bne	a2,a3,800010b4 <strcmp+0x10c>
800010e0:	00000513          	li	a0,0
800010e4:	00008067          	ret
800010e8:	00850513          	addi	a0,a0,8
800010ec:	00858593          	addi	a1,a1,8
800010f0:	fcd612e3          	bne	a2,a3,800010b4 <strcmp+0x10c>
800010f4:	00000513          	li	a0,0
800010f8:	00008067          	ret
800010fc:	00c50513          	addi	a0,a0,12
80001100:	00c58593          	addi	a1,a1,12
80001104:	fad618e3          	bne	a2,a3,800010b4 <strcmp+0x10c>
80001108:	00000513          	li	a0,0
8000110c:	00008067          	ret
80001110:	01050513          	addi	a0,a0,16
80001114:	01058593          	addi	a1,a1,16
80001118:	f8d61ee3          	bne	a2,a3,800010b4 <strcmp+0x10c>
8000111c:	00000513          	li	a0,0
80001120:	00008067          	ret

80001124 <__divdf3>:
80001124:	fb010113          	addi	sp,sp,-80
80001128:	04812423          	sw	s0,72(sp)
8000112c:	03412c23          	sw	s4,56(sp)
80001130:	00100437          	lui	s0,0x100
80001134:	0145da13          	srli	s4,a1,0x14
80001138:	05212023          	sw	s2,64(sp)
8000113c:	03312e23          	sw	s3,60(sp)
80001140:	03512a23          	sw	s5,52(sp)
80001144:	03812423          	sw	s8,40(sp)
80001148:	fff40413          	addi	s0,s0,-1 # fffff <_stack_size+0xffbff>
8000114c:	04112623          	sw	ra,76(sp)
80001150:	04912223          	sw	s1,68(sp)
80001154:	03612823          	sw	s6,48(sp)
80001158:	03712623          	sw	s7,44(sp)
8000115c:	03912223          	sw	s9,36(sp)
80001160:	03a12023          	sw	s10,32(sp)
80001164:	01b12e23          	sw	s11,28(sp)
80001168:	7ffa7a13          	andi	s4,s4,2047
8000116c:	00050913          	mv	s2,a0
80001170:	00060c13          	mv	s8,a2
80001174:	00068a93          	mv	s5,a3
80001178:	00b47433          	and	s0,s0,a1
8000117c:	01f5d993          	srli	s3,a1,0x1f
80001180:	0a0a0663          	beqz	s4,8000122c <__divdf3+0x108>
80001184:	7ff00793          	li	a5,2047
80001188:	10fa0463          	beq	s4,a5,80001290 <__divdf3+0x16c>
8000118c:	00341413          	slli	s0,s0,0x3
80001190:	008007b7          	lui	a5,0x800
80001194:	00f46433          	or	s0,s0,a5
80001198:	01d55b13          	srli	s6,a0,0x1d
8000119c:	008b6b33          	or	s6,s6,s0
800011a0:	00351493          	slli	s1,a0,0x3
800011a4:	c01a0a13          	addi	s4,s4,-1023
800011a8:	00000b93          	li	s7,0
800011ac:	014ad513          	srli	a0,s5,0x14
800011b0:	00100937          	lui	s2,0x100
800011b4:	fff90913          	addi	s2,s2,-1 # fffff <_stack_size+0xffbff>
800011b8:	7ff57513          	andi	a0,a0,2047
800011bc:	01597933          	and	s2,s2,s5
800011c0:	000c0593          	mv	a1,s8
800011c4:	01fada93          	srli	s5,s5,0x1f
800011c8:	10050263          	beqz	a0,800012cc <__divdf3+0x1a8>
800011cc:	7ff00793          	li	a5,2047
800011d0:	16f50263          	beq	a0,a5,80001334 <__divdf3+0x210>
800011d4:	00800437          	lui	s0,0x800
800011d8:	00391913          	slli	s2,s2,0x3
800011dc:	00896933          	or	s2,s2,s0
800011e0:	01dc5413          	srli	s0,s8,0x1d
800011e4:	01246433          	or	s0,s0,s2
800011e8:	003c1593          	slli	a1,s8,0x3
800011ec:	c0150513          	addi	a0,a0,-1023
800011f0:	00000793          	li	a5,0
800011f4:	002b9713          	slli	a4,s7,0x2
800011f8:	00f76733          	or	a4,a4,a5
800011fc:	fff70713          	addi	a4,a4,-1
80001200:	00e00693          	li	a3,14
80001204:	0159c933          	xor	s2,s3,s5
80001208:	40aa0a33          	sub	s4,s4,a0
8000120c:	16e6e063          	bltu	a3,a4,8000136c <__divdf3+0x248>
80001210:	00002697          	auipc	a3,0x2
80001214:	4dc68693          	addi	a3,a3,1244 # 800036ec <end+0x5ec>
80001218:	00271713          	slli	a4,a4,0x2
8000121c:	00d70733          	add	a4,a4,a3
80001220:	00072703          	lw	a4,0(a4)
80001224:	00d70733          	add	a4,a4,a3
80001228:	00070067          	jr	a4
8000122c:	00a46b33          	or	s6,s0,a0
80001230:	060b0e63          	beqz	s6,800012ac <__divdf3+0x188>
80001234:	04040063          	beqz	s0,80001274 <__divdf3+0x150>
80001238:	00040513          	mv	a0,s0
8000123c:	679010ef          	jal	ra,800030b4 <__clzsi2>
80001240:	ff550793          	addi	a5,a0,-11
80001244:	01c00713          	li	a4,28
80001248:	02f74c63          	blt	a4,a5,80001280 <__divdf3+0x15c>
8000124c:	01d00b13          	li	s6,29
80001250:	ff850493          	addi	s1,a0,-8
80001254:	40fb0b33          	sub	s6,s6,a5
80001258:	00941433          	sll	s0,s0,s1
8000125c:	01695b33          	srl	s6,s2,s6
80001260:	008b6b33          	or	s6,s6,s0
80001264:	009914b3          	sll	s1,s2,s1
80001268:	c0d00a13          	li	s4,-1011
8000126c:	40aa0a33          	sub	s4,s4,a0
80001270:	f39ff06f          	j	800011a8 <__divdf3+0x84>
80001274:	641010ef          	jal	ra,800030b4 <__clzsi2>
80001278:	02050513          	addi	a0,a0,32
8000127c:	fc5ff06f          	j	80001240 <__divdf3+0x11c>
80001280:	fd850413          	addi	s0,a0,-40
80001284:	00891b33          	sll	s6,s2,s0
80001288:	00000493          	li	s1,0
8000128c:	fddff06f          	j	80001268 <__divdf3+0x144>
80001290:	00a46b33          	or	s6,s0,a0
80001294:	020b0463          	beqz	s6,800012bc <__divdf3+0x198>
80001298:	00050493          	mv	s1,a0
8000129c:	00040b13          	mv	s6,s0
800012a0:	7ff00a13          	li	s4,2047
800012a4:	00300b93          	li	s7,3
800012a8:	f05ff06f          	j	800011ac <__divdf3+0x88>
800012ac:	00000493          	li	s1,0
800012b0:	00000a13          	li	s4,0
800012b4:	00100b93          	li	s7,1
800012b8:	ef5ff06f          	j	800011ac <__divdf3+0x88>
800012bc:	00000493          	li	s1,0
800012c0:	7ff00a13          	li	s4,2047
800012c4:	00200b93          	li	s7,2
800012c8:	ee5ff06f          	j	800011ac <__divdf3+0x88>
800012cc:	01896433          	or	s0,s2,s8
800012d0:	06040e63          	beqz	s0,8000134c <__divdf3+0x228>
800012d4:	04090063          	beqz	s2,80001314 <__divdf3+0x1f0>
800012d8:	00090513          	mv	a0,s2
800012dc:	5d9010ef          	jal	ra,800030b4 <__clzsi2>
800012e0:	ff550793          	addi	a5,a0,-11
800012e4:	01c00713          	li	a4,28
800012e8:	02f74e63          	blt	a4,a5,80001324 <__divdf3+0x200>
800012ec:	01d00413          	li	s0,29
800012f0:	ff850593          	addi	a1,a0,-8
800012f4:	40f40433          	sub	s0,s0,a5
800012f8:	00b91933          	sll	s2,s2,a1
800012fc:	008c5433          	srl	s0,s8,s0
80001300:	01246433          	or	s0,s0,s2
80001304:	00bc15b3          	sll	a1,s8,a1
80001308:	c0d00713          	li	a4,-1011
8000130c:	40a70533          	sub	a0,a4,a0
80001310:	ee1ff06f          	j	800011f0 <__divdf3+0xcc>
80001314:	000c0513          	mv	a0,s8
80001318:	59d010ef          	jal	ra,800030b4 <__clzsi2>
8000131c:	02050513          	addi	a0,a0,32
80001320:	fc1ff06f          	j	800012e0 <__divdf3+0x1bc>
80001324:	fd850413          	addi	s0,a0,-40
80001328:	008c1433          	sll	s0,s8,s0
8000132c:	00000593          	li	a1,0
80001330:	fd9ff06f          	j	80001308 <__divdf3+0x1e4>
80001334:	01896433          	or	s0,s2,s8
80001338:	02040263          	beqz	s0,8000135c <__divdf3+0x238>
8000133c:	00090413          	mv	s0,s2
80001340:	7ff00513          	li	a0,2047
80001344:	00300793          	li	a5,3
80001348:	eadff06f          	j	800011f4 <__divdf3+0xd0>
8000134c:	00000593          	li	a1,0
80001350:	00000513          	li	a0,0
80001354:	00100793          	li	a5,1
80001358:	e9dff06f          	j	800011f4 <__divdf3+0xd0>
8000135c:	00000593          	li	a1,0
80001360:	7ff00513          	li	a0,2047
80001364:	00200793          	li	a5,2
80001368:	e8dff06f          	j	800011f4 <__divdf3+0xd0>
8000136c:	01646663          	bltu	s0,s6,80001378 <__divdf3+0x254>
80001370:	488b1263          	bne	s6,s0,800017f4 <__divdf3+0x6d0>
80001374:	48b4e063          	bltu	s1,a1,800017f4 <__divdf3+0x6d0>
80001378:	01fb1693          	slli	a3,s6,0x1f
8000137c:	0014d713          	srli	a4,s1,0x1
80001380:	01f49c13          	slli	s8,s1,0x1f
80001384:	001b5b13          	srli	s6,s6,0x1
80001388:	00e6e4b3          	or	s1,a3,a4
8000138c:	00841413          	slli	s0,s0,0x8
80001390:	0185dc93          	srli	s9,a1,0x18
80001394:	008cecb3          	or	s9,s9,s0
80001398:	010cda93          	srli	s5,s9,0x10
8000139c:	010c9793          	slli	a5,s9,0x10
800013a0:	0107d793          	srli	a5,a5,0x10
800013a4:	00859d13          	slli	s10,a1,0x8
800013a8:	000b0513          	mv	a0,s6
800013ac:	000a8593          	mv	a1,s5
800013b0:	00f12223          	sw	a5,4(sp)
800013b4:	455010ef          	jal	ra,80003008 <__udivsi3>
800013b8:	00050593          	mv	a1,a0
800013bc:	00050b93          	mv	s7,a0
800013c0:	010c9513          	slli	a0,s9,0x10
800013c4:	01055513          	srli	a0,a0,0x10
800013c8:	415010ef          	jal	ra,80002fdc <__mulsi3>
800013cc:	00050413          	mv	s0,a0
800013d0:	000a8593          	mv	a1,s5
800013d4:	000b0513          	mv	a0,s6
800013d8:	479010ef          	jal	ra,80003050 <__umodsi3>
800013dc:	01051513          	slli	a0,a0,0x10
800013e0:	0104d713          	srli	a4,s1,0x10
800013e4:	00a76533          	or	a0,a4,a0
800013e8:	000b8993          	mv	s3,s7
800013ec:	00857e63          	bleu	s0,a0,80001408 <__divdf3+0x2e4>
800013f0:	01950533          	add	a0,a0,s9
800013f4:	fffb8993          	addi	s3,s7,-1
800013f8:	01956863          	bltu	a0,s9,80001408 <__divdf3+0x2e4>
800013fc:	00857663          	bleu	s0,a0,80001408 <__divdf3+0x2e4>
80001400:	ffeb8993          	addi	s3,s7,-2
80001404:	01950533          	add	a0,a0,s9
80001408:	40850433          	sub	s0,a0,s0
8000140c:	000a8593          	mv	a1,s5
80001410:	00040513          	mv	a0,s0
80001414:	3f5010ef          	jal	ra,80003008 <__udivsi3>
80001418:	00050593          	mv	a1,a0
8000141c:	00050b93          	mv	s7,a0
80001420:	010c9513          	slli	a0,s9,0x10
80001424:	01055513          	srli	a0,a0,0x10
80001428:	3b5010ef          	jal	ra,80002fdc <__mulsi3>
8000142c:	00050b13          	mv	s6,a0
80001430:	000a8593          	mv	a1,s5
80001434:	00040513          	mv	a0,s0
80001438:	419010ef          	jal	ra,80003050 <__umodsi3>
8000143c:	01049d93          	slli	s11,s1,0x10
80001440:	01051513          	slli	a0,a0,0x10
80001444:	010ddd93          	srli	s11,s11,0x10
80001448:	00adedb3          	or	s11,s11,a0
8000144c:	000b8713          	mv	a4,s7
80001450:	016dfe63          	bleu	s6,s11,8000146c <__divdf3+0x348>
80001454:	019d8db3          	add	s11,s11,s9
80001458:	fffb8713          	addi	a4,s7,-1
8000145c:	019de863          	bltu	s11,s9,8000146c <__divdf3+0x348>
80001460:	016df663          	bleu	s6,s11,8000146c <__divdf3+0x348>
80001464:	ffeb8713          	addi	a4,s7,-2
80001468:	019d8db3          	add	s11,s11,s9
8000146c:	01099693          	slli	a3,s3,0x10
80001470:	000104b7          	lui	s1,0x10
80001474:	00e6e6b3          	or	a3,a3,a4
80001478:	416d8db3          	sub	s11,s11,s6
8000147c:	fff48b13          	addi	s6,s1,-1 # ffff <_stack_size+0xfbff>
80001480:	0166f733          	and	a4,a3,s6
80001484:	016d7b33          	and	s6,s10,s6
80001488:	00070513          	mv	a0,a4
8000148c:	000b0593          	mv	a1,s6
80001490:	0106d413          	srli	s0,a3,0x10
80001494:	00d12623          	sw	a3,12(sp)
80001498:	00e12423          	sw	a4,8(sp)
8000149c:	341010ef          	jal	ra,80002fdc <__mulsi3>
800014a0:	00a12223          	sw	a0,4(sp)
800014a4:	000b0593          	mv	a1,s6
800014a8:	00040513          	mv	a0,s0
800014ac:	331010ef          	jal	ra,80002fdc <__mulsi3>
800014b0:	010d5b93          	srli	s7,s10,0x10
800014b4:	00050993          	mv	s3,a0
800014b8:	000b8593          	mv	a1,s7
800014bc:	00040513          	mv	a0,s0
800014c0:	31d010ef          	jal	ra,80002fdc <__mulsi3>
800014c4:	00812703          	lw	a4,8(sp)
800014c8:	00050413          	mv	s0,a0
800014cc:	000b8513          	mv	a0,s7
800014d0:	00070593          	mv	a1,a4
800014d4:	309010ef          	jal	ra,80002fdc <__mulsi3>
800014d8:	00412603          	lw	a2,4(sp)
800014dc:	01350533          	add	a0,a0,s3
800014e0:	00c12683          	lw	a3,12(sp)
800014e4:	01065713          	srli	a4,a2,0x10
800014e8:	00a70733          	add	a4,a4,a0
800014ec:	01377463          	bleu	s3,a4,800014f4 <__divdf3+0x3d0>
800014f0:	00940433          	add	s0,s0,s1
800014f4:	00010537          	lui	a0,0x10
800014f8:	fff50513          	addi	a0,a0,-1 # ffff <_stack_size+0xfbff>
800014fc:	01075493          	srli	s1,a4,0x10
80001500:	00a779b3          	and	s3,a4,a0
80001504:	01099993          	slli	s3,s3,0x10
80001508:	00a67633          	and	a2,a2,a0
8000150c:	008484b3          	add	s1,s1,s0
80001510:	00c989b3          	add	s3,s3,a2
80001514:	009de863          	bltu	s11,s1,80001524 <__divdf3+0x400>
80001518:	00068413          	mv	s0,a3
8000151c:	049d9463          	bne	s11,s1,80001564 <__divdf3+0x440>
80001520:	053c7263          	bleu	s3,s8,80001564 <__divdf3+0x440>
80001524:	01ac0c33          	add	s8,s8,s10
80001528:	01ac3733          	sltu	a4,s8,s10
8000152c:	01970733          	add	a4,a4,s9
80001530:	00ed8db3          	add	s11,s11,a4
80001534:	fff68413          	addi	s0,a3,-1
80001538:	01bce663          	bltu	s9,s11,80001544 <__divdf3+0x420>
8000153c:	03bc9463          	bne	s9,s11,80001564 <__divdf3+0x440>
80001540:	03ac6263          	bltu	s8,s10,80001564 <__divdf3+0x440>
80001544:	009de663          	bltu	s11,s1,80001550 <__divdf3+0x42c>
80001548:	01b49e63          	bne	s1,s11,80001564 <__divdf3+0x440>
8000154c:	013c7c63          	bleu	s3,s8,80001564 <__divdf3+0x440>
80001550:	01ac0c33          	add	s8,s8,s10
80001554:	01ac3733          	sltu	a4,s8,s10
80001558:	01970733          	add	a4,a4,s9
8000155c:	ffe68413          	addi	s0,a3,-2
80001560:	00ed8db3          	add	s11,s11,a4
80001564:	413c09b3          	sub	s3,s8,s3
80001568:	409d84b3          	sub	s1,s11,s1
8000156c:	013c37b3          	sltu	a5,s8,s3
80001570:	40f484b3          	sub	s1,s1,a5
80001574:	fff00593          	li	a1,-1
80001578:	1a9c8863          	beq	s9,s1,80001728 <__divdf3+0x604>
8000157c:	000a8593          	mv	a1,s5
80001580:	00048513          	mv	a0,s1
80001584:	285010ef          	jal	ra,80003008 <__udivsi3>
80001588:	00050593          	mv	a1,a0
8000158c:	00a12423          	sw	a0,8(sp)
80001590:	010c9513          	slli	a0,s9,0x10
80001594:	01055513          	srli	a0,a0,0x10
80001598:	245010ef          	jal	ra,80002fdc <__mulsi3>
8000159c:	00a12223          	sw	a0,4(sp)
800015a0:	000a8593          	mv	a1,s5
800015a4:	00048513          	mv	a0,s1
800015a8:	2a9010ef          	jal	ra,80003050 <__umodsi3>
800015ac:	00812683          	lw	a3,8(sp)
800015b0:	00412703          	lw	a4,4(sp)
800015b4:	01051513          	slli	a0,a0,0x10
800015b8:	0109d793          	srli	a5,s3,0x10
800015bc:	00a7e533          	or	a0,a5,a0
800015c0:	00068d93          	mv	s11,a3
800015c4:	00e57e63          	bleu	a4,a0,800015e0 <__divdf3+0x4bc>
800015c8:	01950533          	add	a0,a0,s9
800015cc:	fff68d93          	addi	s11,a3,-1
800015d0:	01956863          	bltu	a0,s9,800015e0 <__divdf3+0x4bc>
800015d4:	00e57663          	bleu	a4,a0,800015e0 <__divdf3+0x4bc>
800015d8:	ffe68d93          	addi	s11,a3,-2
800015dc:	01950533          	add	a0,a0,s9
800015e0:	40e504b3          	sub	s1,a0,a4
800015e4:	000a8593          	mv	a1,s5
800015e8:	00048513          	mv	a0,s1
800015ec:	21d010ef          	jal	ra,80003008 <__udivsi3>
800015f0:	00050593          	mv	a1,a0
800015f4:	00a12223          	sw	a0,4(sp)
800015f8:	010c9513          	slli	a0,s9,0x10
800015fc:	01055513          	srli	a0,a0,0x10
80001600:	1dd010ef          	jal	ra,80002fdc <__mulsi3>
80001604:	00050c13          	mv	s8,a0
80001608:	000a8593          	mv	a1,s5
8000160c:	00048513          	mv	a0,s1
80001610:	241010ef          	jal	ra,80003050 <__umodsi3>
80001614:	01099993          	slli	s3,s3,0x10
80001618:	00412703          	lw	a4,4(sp)
8000161c:	01051513          	slli	a0,a0,0x10
80001620:	0109d993          	srli	s3,s3,0x10
80001624:	00a9e533          	or	a0,s3,a0
80001628:	00070793          	mv	a5,a4
8000162c:	01857e63          	bleu	s8,a0,80001648 <__divdf3+0x524>
80001630:	01950533          	add	a0,a0,s9
80001634:	fff70793          	addi	a5,a4,-1
80001638:	01956863          	bltu	a0,s9,80001648 <__divdf3+0x524>
8000163c:	01857663          	bleu	s8,a0,80001648 <__divdf3+0x524>
80001640:	ffe70793          	addi	a5,a4,-2
80001644:	01950533          	add	a0,a0,s9
80001648:	010d9493          	slli	s1,s11,0x10
8000164c:	00f4e4b3          	or	s1,s1,a5
80001650:	01049793          	slli	a5,s1,0x10
80001654:	0107d793          	srli	a5,a5,0x10
80001658:	000b0593          	mv	a1,s6
8000165c:	418509b3          	sub	s3,a0,s8
80001660:	00078513          	mv	a0,a5
80001664:	00f12223          	sw	a5,4(sp)
80001668:	0104dd93          	srli	s11,s1,0x10
8000166c:	171010ef          	jal	ra,80002fdc <__mulsi3>
80001670:	000b0593          	mv	a1,s6
80001674:	00050a93          	mv	s5,a0
80001678:	000d8513          	mv	a0,s11
8000167c:	161010ef          	jal	ra,80002fdc <__mulsi3>
80001680:	00050c13          	mv	s8,a0
80001684:	000d8593          	mv	a1,s11
80001688:	000b8513          	mv	a0,s7
8000168c:	151010ef          	jal	ra,80002fdc <__mulsi3>
80001690:	00412783          	lw	a5,4(sp)
80001694:	00050b13          	mv	s6,a0
80001698:	000b8513          	mv	a0,s7
8000169c:	00078593          	mv	a1,a5
800016a0:	13d010ef          	jal	ra,80002fdc <__mulsi3>
800016a4:	01850533          	add	a0,a0,s8
800016a8:	010ad793          	srli	a5,s5,0x10
800016ac:	00a78533          	add	a0,a5,a0
800016b0:	01857663          	bleu	s8,a0,800016bc <__divdf3+0x598>
800016b4:	000107b7          	lui	a5,0x10
800016b8:	00fb0b33          	add	s6,s6,a5
800016bc:	000106b7          	lui	a3,0x10
800016c0:	fff68693          	addi	a3,a3,-1 # ffff <_stack_size+0xfbff>
800016c4:	01055793          	srli	a5,a0,0x10
800016c8:	00d57733          	and	a4,a0,a3
800016cc:	01071713          	slli	a4,a4,0x10
800016d0:	00dafab3          	and	s5,s5,a3
800016d4:	016787b3          	add	a5,a5,s6
800016d8:	01570733          	add	a4,a4,s5
800016dc:	00f9e863          	bltu	s3,a5,800016ec <__divdf3+0x5c8>
800016e0:	00048593          	mv	a1,s1
800016e4:	04f99063          	bne	s3,a5,80001724 <__divdf3+0x600>
800016e8:	04070063          	beqz	a4,80001728 <__divdf3+0x604>
800016ec:	013c8533          	add	a0,s9,s3
800016f0:	fff48593          	addi	a1,s1,-1
800016f4:	03956463          	bltu	a0,s9,8000171c <__divdf3+0x5f8>
800016f8:	00f56663          	bltu	a0,a5,80001704 <__divdf3+0x5e0>
800016fc:	02f51463          	bne	a0,a5,80001724 <__divdf3+0x600>
80001700:	02ed7063          	bleu	a4,s10,80001720 <__divdf3+0x5fc>
80001704:	001d1693          	slli	a3,s10,0x1
80001708:	01a6bd33          	sltu	s10,a3,s10
8000170c:	019d0cb3          	add	s9,s10,s9
80001710:	ffe48593          	addi	a1,s1,-2
80001714:	01950533          	add	a0,a0,s9
80001718:	00068d13          	mv	s10,a3
8000171c:	00f51463          	bne	a0,a5,80001724 <__divdf3+0x600>
80001720:	01a70463          	beq	a4,s10,80001728 <__divdf3+0x604>
80001724:	0015e593          	ori	a1,a1,1
80001728:	3ffa0713          	addi	a4,s4,1023
8000172c:	12e05263          	blez	a4,80001850 <__divdf3+0x72c>
80001730:	0075f793          	andi	a5,a1,7
80001734:	02078063          	beqz	a5,80001754 <__divdf3+0x630>
80001738:	00f5f793          	andi	a5,a1,15
8000173c:	00400693          	li	a3,4
80001740:	00d78a63          	beq	a5,a3,80001754 <__divdf3+0x630>
80001744:	00458693          	addi	a3,a1,4
80001748:	00b6b5b3          	sltu	a1,a3,a1
8000174c:	00b40433          	add	s0,s0,a1
80001750:	00068593          	mv	a1,a3
80001754:	00741793          	slli	a5,s0,0x7
80001758:	0007da63          	bgez	a5,8000176c <__divdf3+0x648>
8000175c:	ff0007b7          	lui	a5,0xff000
80001760:	fff78793          	addi	a5,a5,-1 # feffffff <_stack_start+0x7eff96ef>
80001764:	00f47433          	and	s0,s0,a5
80001768:	400a0713          	addi	a4,s4,1024
8000176c:	7fe00793          	li	a5,2046
80001770:	1ae7c263          	blt	a5,a4,80001914 <__divdf3+0x7f0>
80001774:	01d41793          	slli	a5,s0,0x1d
80001778:	0035d593          	srli	a1,a1,0x3
8000177c:	00b7e7b3          	or	a5,a5,a1
80001780:	00345413          	srli	s0,s0,0x3
80001784:	001006b7          	lui	a3,0x100
80001788:	fff68693          	addi	a3,a3,-1 # fffff <_stack_size+0xffbff>
8000178c:	00d47433          	and	s0,s0,a3
80001790:	801006b7          	lui	a3,0x80100
80001794:	7ff77713          	andi	a4,a4,2047
80001798:	fff68693          	addi	a3,a3,-1 # 800fffff <_stack_start+0xf96ef>
8000179c:	01471713          	slli	a4,a4,0x14
800017a0:	00d47433          	and	s0,s0,a3
800017a4:	01f91913          	slli	s2,s2,0x1f
800017a8:	00e46433          	or	s0,s0,a4
800017ac:	01246733          	or	a4,s0,s2
800017b0:	04c12083          	lw	ra,76(sp)
800017b4:	04812403          	lw	s0,72(sp)
800017b8:	04412483          	lw	s1,68(sp)
800017bc:	04012903          	lw	s2,64(sp)
800017c0:	03c12983          	lw	s3,60(sp)
800017c4:	03812a03          	lw	s4,56(sp)
800017c8:	03412a83          	lw	s5,52(sp)
800017cc:	03012b03          	lw	s6,48(sp)
800017d0:	02c12b83          	lw	s7,44(sp)
800017d4:	02812c03          	lw	s8,40(sp)
800017d8:	02412c83          	lw	s9,36(sp)
800017dc:	02012d03          	lw	s10,32(sp)
800017e0:	01c12d83          	lw	s11,28(sp)
800017e4:	00078513          	mv	a0,a5
800017e8:	00070593          	mv	a1,a4
800017ec:	05010113          	addi	sp,sp,80
800017f0:	00008067          	ret
800017f4:	fffa0a13          	addi	s4,s4,-1
800017f8:	00000c13          	li	s8,0
800017fc:	b91ff06f          	j	8000138c <__divdf3+0x268>
80001800:	00098913          	mv	s2,s3
80001804:	000b0413          	mv	s0,s6
80001808:	00048593          	mv	a1,s1
8000180c:	000b8793          	mv	a5,s7
80001810:	00200713          	li	a4,2
80001814:	10e78063          	beq	a5,a4,80001914 <__divdf3+0x7f0>
80001818:	00300713          	li	a4,3
8000181c:	0ee78263          	beq	a5,a4,80001900 <__divdf3+0x7dc>
80001820:	00100713          	li	a4,1
80001824:	f0e792e3          	bne	a5,a4,80001728 <__divdf3+0x604>
80001828:	00000413          	li	s0,0
8000182c:	00000793          	li	a5,0
80001830:	0940006f          	j	800018c4 <__divdf3+0x7a0>
80001834:	000a8913          	mv	s2,s5
80001838:	fd9ff06f          	j	80001810 <__divdf3+0x6ec>
8000183c:	00080437          	lui	s0,0x80
80001840:	00000593          	li	a1,0
80001844:	00000913          	li	s2,0
80001848:	00300793          	li	a5,3
8000184c:	fc5ff06f          	j	80001810 <__divdf3+0x6ec>
80001850:	00100693          	li	a3,1
80001854:	40e686b3          	sub	a3,a3,a4
80001858:	03800793          	li	a5,56
8000185c:	fcd7c6e3          	blt	a5,a3,80001828 <__divdf3+0x704>
80001860:	01f00793          	li	a5,31
80001864:	06d7c463          	blt	a5,a3,800018cc <__divdf3+0x7a8>
80001868:	41ea0a13          	addi	s4,s4,1054
8000186c:	014417b3          	sll	a5,s0,s4
80001870:	00d5d733          	srl	a4,a1,a3
80001874:	01459a33          	sll	s4,a1,s4
80001878:	00e7e7b3          	or	a5,a5,a4
8000187c:	01403a33          	snez	s4,s4
80001880:	0147e7b3          	or	a5,a5,s4
80001884:	00d45433          	srl	s0,s0,a3
80001888:	0077f713          	andi	a4,a5,7
8000188c:	02070063          	beqz	a4,800018ac <__divdf3+0x788>
80001890:	00f7f713          	andi	a4,a5,15
80001894:	00400693          	li	a3,4
80001898:	00d70a63          	beq	a4,a3,800018ac <__divdf3+0x788>
8000189c:	00478713          	addi	a4,a5,4
800018a0:	00f737b3          	sltu	a5,a4,a5
800018a4:	00f40433          	add	s0,s0,a5
800018a8:	00070793          	mv	a5,a4
800018ac:	00841713          	slli	a4,s0,0x8
800018b0:	06074a63          	bltz	a4,80001924 <__divdf3+0x800>
800018b4:	01d41713          	slli	a4,s0,0x1d
800018b8:	0037d793          	srli	a5,a5,0x3
800018bc:	00f767b3          	or	a5,a4,a5
800018c0:	00345413          	srli	s0,s0,0x3
800018c4:	00000713          	li	a4,0
800018c8:	ebdff06f          	j	80001784 <__divdf3+0x660>
800018cc:	fe100793          	li	a5,-31
800018d0:	40e787b3          	sub	a5,a5,a4
800018d4:	02000713          	li	a4,32
800018d8:	00f457b3          	srl	a5,s0,a5
800018dc:	00000513          	li	a0,0
800018e0:	00e68663          	beq	a3,a4,800018ec <__divdf3+0x7c8>
800018e4:	43ea0a13          	addi	s4,s4,1086
800018e8:	01441533          	sll	a0,s0,s4
800018ec:	00b56a33          	or	s4,a0,a1
800018f0:	01403a33          	snez	s4,s4
800018f4:	0147e7b3          	or	a5,a5,s4
800018f8:	00000413          	li	s0,0
800018fc:	f8dff06f          	j	80001888 <__divdf3+0x764>
80001900:	00080437          	lui	s0,0x80
80001904:	00000793          	li	a5,0
80001908:	7ff00713          	li	a4,2047
8000190c:	00000913          	li	s2,0
80001910:	e75ff06f          	j	80001784 <__divdf3+0x660>
80001914:	00000413          	li	s0,0
80001918:	00000793          	li	a5,0
8000191c:	7ff00713          	li	a4,2047
80001920:	e65ff06f          	j	80001784 <__divdf3+0x660>
80001924:	00000413          	li	s0,0
80001928:	00000793          	li	a5,0
8000192c:	00100713          	li	a4,1
80001930:	e55ff06f          	j	80001784 <__divdf3+0x660>

80001934 <__muldf3>:
80001934:	fa010113          	addi	sp,sp,-96
80001938:	04812c23          	sw	s0,88(sp)
8000193c:	05312623          	sw	s3,76(sp)
80001940:	00100437          	lui	s0,0x100
80001944:	0145d993          	srli	s3,a1,0x14
80001948:	04912a23          	sw	s1,84(sp)
8000194c:	05612023          	sw	s6,64(sp)
80001950:	03712e23          	sw	s7,60(sp)
80001954:	03812c23          	sw	s8,56(sp)
80001958:	fff40413          	addi	s0,s0,-1 # fffff <_stack_size+0xffbff>
8000195c:	04112e23          	sw	ra,92(sp)
80001960:	05212823          	sw	s2,80(sp)
80001964:	05412423          	sw	s4,72(sp)
80001968:	05512223          	sw	s5,68(sp)
8000196c:	03912a23          	sw	s9,52(sp)
80001970:	03a12823          	sw	s10,48(sp)
80001974:	03b12623          	sw	s11,44(sp)
80001978:	7ff9f993          	andi	s3,s3,2047
8000197c:	00050493          	mv	s1,a0
80001980:	00060b93          	mv	s7,a2
80001984:	00068c13          	mv	s8,a3
80001988:	00b47433          	and	s0,s0,a1
8000198c:	01f5db13          	srli	s6,a1,0x1f
80001990:	0a098863          	beqz	s3,80001a40 <__muldf3+0x10c>
80001994:	7ff00793          	li	a5,2047
80001998:	10f98663          	beq	s3,a5,80001aa4 <__muldf3+0x170>
8000199c:	00800937          	lui	s2,0x800
800019a0:	00341413          	slli	s0,s0,0x3
800019a4:	01246433          	or	s0,s0,s2
800019a8:	01d55913          	srli	s2,a0,0x1d
800019ac:	00896933          	or	s2,s2,s0
800019b0:	00351d13          	slli	s10,a0,0x3
800019b4:	c0198993          	addi	s3,s3,-1023
800019b8:	00000c93          	li	s9,0
800019bc:	014c5513          	srli	a0,s8,0x14
800019c0:	00100a37          	lui	s4,0x100
800019c4:	fffa0a13          	addi	s4,s4,-1 # fffff <_stack_size+0xffbff>
800019c8:	7ff57513          	andi	a0,a0,2047
800019cc:	018a7a33          	and	s4,s4,s8
800019d0:	000b8493          	mv	s1,s7
800019d4:	01fc5c13          	srli	s8,s8,0x1f
800019d8:	10050463          	beqz	a0,80001ae0 <__muldf3+0x1ac>
800019dc:	7ff00793          	li	a5,2047
800019e0:	16f50463          	beq	a0,a5,80001b48 <__muldf3+0x214>
800019e4:	00800437          	lui	s0,0x800
800019e8:	003a1a13          	slli	s4,s4,0x3
800019ec:	008a6a33          	or	s4,s4,s0
800019f0:	01dbd413          	srli	s0,s7,0x1d
800019f4:	01446433          	or	s0,s0,s4
800019f8:	003b9493          	slli	s1,s7,0x3
800019fc:	c0150513          	addi	a0,a0,-1023
80001a00:	00000793          	li	a5,0
80001a04:	002c9713          	slli	a4,s9,0x2
80001a08:	00f76733          	or	a4,a4,a5
80001a0c:	00a989b3          	add	s3,s3,a0
80001a10:	fff70713          	addi	a4,a4,-1
80001a14:	00e00693          	li	a3,14
80001a18:	018b4bb3          	xor	s7,s6,s8
80001a1c:	00198a93          	addi	s5,s3,1
80001a20:	16e6e063          	bltu	a3,a4,80001b80 <__muldf3+0x24c>
80001a24:	00002697          	auipc	a3,0x2
80001a28:	d0468693          	addi	a3,a3,-764 # 80003728 <end+0x628>
80001a2c:	00271713          	slli	a4,a4,0x2
80001a30:	00d70733          	add	a4,a4,a3
80001a34:	00072703          	lw	a4,0(a4)
80001a38:	00d70733          	add	a4,a4,a3
80001a3c:	00070067          	jr	a4
80001a40:	00a46933          	or	s2,s0,a0
80001a44:	06090e63          	beqz	s2,80001ac0 <__muldf3+0x18c>
80001a48:	04040063          	beqz	s0,80001a88 <__muldf3+0x154>
80001a4c:	00040513          	mv	a0,s0
80001a50:	664010ef          	jal	ra,800030b4 <__clzsi2>
80001a54:	ff550793          	addi	a5,a0,-11
80001a58:	01c00713          	li	a4,28
80001a5c:	02f74c63          	blt	a4,a5,80001a94 <__muldf3+0x160>
80001a60:	01d00913          	li	s2,29
80001a64:	ff850d13          	addi	s10,a0,-8
80001a68:	40f90933          	sub	s2,s2,a5
80001a6c:	01a41433          	sll	s0,s0,s10
80001a70:	0124d933          	srl	s2,s1,s2
80001a74:	00896933          	or	s2,s2,s0
80001a78:	01a49d33          	sll	s10,s1,s10
80001a7c:	c0d00993          	li	s3,-1011
80001a80:	40a989b3          	sub	s3,s3,a0
80001a84:	f35ff06f          	j	800019b8 <__muldf3+0x84>
80001a88:	62c010ef          	jal	ra,800030b4 <__clzsi2>
80001a8c:	02050513          	addi	a0,a0,32
80001a90:	fc5ff06f          	j	80001a54 <__muldf3+0x120>
80001a94:	fd850913          	addi	s2,a0,-40
80001a98:	01249933          	sll	s2,s1,s2
80001a9c:	00000d13          	li	s10,0
80001aa0:	fddff06f          	j	80001a7c <__muldf3+0x148>
80001aa4:	00a46933          	or	s2,s0,a0
80001aa8:	02090463          	beqz	s2,80001ad0 <__muldf3+0x19c>
80001aac:	00050d13          	mv	s10,a0
80001ab0:	00040913          	mv	s2,s0
80001ab4:	7ff00993          	li	s3,2047
80001ab8:	00300c93          	li	s9,3
80001abc:	f01ff06f          	j	800019bc <__muldf3+0x88>
80001ac0:	00000d13          	li	s10,0
80001ac4:	00000993          	li	s3,0
80001ac8:	00100c93          	li	s9,1
80001acc:	ef1ff06f          	j	800019bc <__muldf3+0x88>
80001ad0:	00000d13          	li	s10,0
80001ad4:	7ff00993          	li	s3,2047
80001ad8:	00200c93          	li	s9,2
80001adc:	ee1ff06f          	j	800019bc <__muldf3+0x88>
80001ae0:	017a6433          	or	s0,s4,s7
80001ae4:	06040e63          	beqz	s0,80001b60 <__muldf3+0x22c>
80001ae8:	040a0063          	beqz	s4,80001b28 <__muldf3+0x1f4>
80001aec:	000a0513          	mv	a0,s4
80001af0:	5c4010ef          	jal	ra,800030b4 <__clzsi2>
80001af4:	ff550793          	addi	a5,a0,-11
80001af8:	01c00713          	li	a4,28
80001afc:	02f74e63          	blt	a4,a5,80001b38 <__muldf3+0x204>
80001b00:	01d00413          	li	s0,29
80001b04:	ff850493          	addi	s1,a0,-8
80001b08:	40f40433          	sub	s0,s0,a5
80001b0c:	009a1a33          	sll	s4,s4,s1
80001b10:	008bd433          	srl	s0,s7,s0
80001b14:	01446433          	or	s0,s0,s4
80001b18:	009b94b3          	sll	s1,s7,s1
80001b1c:	c0d00793          	li	a5,-1011
80001b20:	40a78533          	sub	a0,a5,a0
80001b24:	eddff06f          	j	80001a00 <__muldf3+0xcc>
80001b28:	000b8513          	mv	a0,s7
80001b2c:	588010ef          	jal	ra,800030b4 <__clzsi2>
80001b30:	02050513          	addi	a0,a0,32
80001b34:	fc1ff06f          	j	80001af4 <__muldf3+0x1c0>
80001b38:	fd850413          	addi	s0,a0,-40
80001b3c:	008b9433          	sll	s0,s7,s0
80001b40:	00000493          	li	s1,0
80001b44:	fd9ff06f          	j	80001b1c <__muldf3+0x1e8>
80001b48:	017a6433          	or	s0,s4,s7
80001b4c:	02040263          	beqz	s0,80001b70 <__muldf3+0x23c>
80001b50:	000a0413          	mv	s0,s4
80001b54:	7ff00513          	li	a0,2047
80001b58:	00300793          	li	a5,3
80001b5c:	ea9ff06f          	j	80001a04 <__muldf3+0xd0>
80001b60:	00000493          	li	s1,0
80001b64:	00000513          	li	a0,0
80001b68:	00100793          	li	a5,1
80001b6c:	e99ff06f          	j	80001a04 <__muldf3+0xd0>
80001b70:	00000493          	li	s1,0
80001b74:	7ff00513          	li	a0,2047
80001b78:	00200793          	li	a5,2
80001b7c:	e89ff06f          	j	80001a04 <__muldf3+0xd0>
80001b80:	00010737          	lui	a4,0x10
80001b84:	fff70a13          	addi	s4,a4,-1 # ffff <_stack_size+0xfbff>
80001b88:	010d5c13          	srli	s8,s10,0x10
80001b8c:	0104dd93          	srli	s11,s1,0x10
80001b90:	014d7d33          	and	s10,s10,s4
80001b94:	0144f4b3          	and	s1,s1,s4
80001b98:	000d0593          	mv	a1,s10
80001b9c:	00048513          	mv	a0,s1
80001ba0:	00e12823          	sw	a4,16(sp)
80001ba4:	438010ef          	jal	ra,80002fdc <__mulsi3>
80001ba8:	00050c93          	mv	s9,a0
80001bac:	00048593          	mv	a1,s1
80001bb0:	000c0513          	mv	a0,s8
80001bb4:	428010ef          	jal	ra,80002fdc <__mulsi3>
80001bb8:	00a12623          	sw	a0,12(sp)
80001bbc:	000d8593          	mv	a1,s11
80001bc0:	000c0513          	mv	a0,s8
80001bc4:	418010ef          	jal	ra,80002fdc <__mulsi3>
80001bc8:	00050b13          	mv	s6,a0
80001bcc:	000d0593          	mv	a1,s10
80001bd0:	000d8513          	mv	a0,s11
80001bd4:	408010ef          	jal	ra,80002fdc <__mulsi3>
80001bd8:	00c12683          	lw	a3,12(sp)
80001bdc:	010cd793          	srli	a5,s9,0x10
80001be0:	00d50533          	add	a0,a0,a3
80001be4:	00a78533          	add	a0,a5,a0
80001be8:	00d57663          	bleu	a3,a0,80001bf4 <__muldf3+0x2c0>
80001bec:	01012703          	lw	a4,16(sp)
80001bf0:	00eb0b33          	add	s6,s6,a4
80001bf4:	01055693          	srli	a3,a0,0x10
80001bf8:	01457533          	and	a0,a0,s4
80001bfc:	014cfcb3          	and	s9,s9,s4
80001c00:	01051513          	slli	a0,a0,0x10
80001c04:	019507b3          	add	a5,a0,s9
80001c08:	01045c93          	srli	s9,s0,0x10
80001c0c:	01447433          	and	s0,s0,s4
80001c10:	000d0593          	mv	a1,s10
80001c14:	00040513          	mv	a0,s0
80001c18:	00d12a23          	sw	a3,20(sp)
80001c1c:	00f12623          	sw	a5,12(sp)
80001c20:	3bc010ef          	jal	ra,80002fdc <__mulsi3>
80001c24:	00a12823          	sw	a0,16(sp)
80001c28:	00040593          	mv	a1,s0
80001c2c:	000c0513          	mv	a0,s8
80001c30:	3ac010ef          	jal	ra,80002fdc <__mulsi3>
80001c34:	00050a13          	mv	s4,a0
80001c38:	000c8593          	mv	a1,s9
80001c3c:	000c0513          	mv	a0,s8
80001c40:	39c010ef          	jal	ra,80002fdc <__mulsi3>
80001c44:	00050c13          	mv	s8,a0
80001c48:	000d0593          	mv	a1,s10
80001c4c:	000c8513          	mv	a0,s9
80001c50:	38c010ef          	jal	ra,80002fdc <__mulsi3>
80001c54:	01012703          	lw	a4,16(sp)
80001c58:	01450533          	add	a0,a0,s4
80001c5c:	01412683          	lw	a3,20(sp)
80001c60:	01075793          	srli	a5,a4,0x10
80001c64:	00a78533          	add	a0,a5,a0
80001c68:	01457663          	bleu	s4,a0,80001c74 <__muldf3+0x340>
80001c6c:	000107b7          	lui	a5,0x10
80001c70:	00fc0c33          	add	s8,s8,a5
80001c74:	00010637          	lui	a2,0x10
80001c78:	01055793          	srli	a5,a0,0x10
80001c7c:	01878c33          	add	s8,a5,s8
80001c80:	fff60793          	addi	a5,a2,-1 # ffff <_stack_size+0xfbff>
80001c84:	00f57a33          	and	s4,a0,a5
80001c88:	00f77733          	and	a4,a4,a5
80001c8c:	010a1a13          	slli	s4,s4,0x10
80001c90:	01095d13          	srli	s10,s2,0x10
80001c94:	00ea0a33          	add	s4,s4,a4
80001c98:	00f97933          	and	s2,s2,a5
80001c9c:	01468733          	add	a4,a3,s4
80001ca0:	00090593          	mv	a1,s2
80001ca4:	00048513          	mv	a0,s1
80001ca8:	00e12823          	sw	a4,16(sp)
80001cac:	00c12e23          	sw	a2,28(sp)
80001cb0:	32c010ef          	jal	ra,80002fdc <__mulsi3>
80001cb4:	00048593          	mv	a1,s1
80001cb8:	00a12c23          	sw	a0,24(sp)
80001cbc:	000d0513          	mv	a0,s10
80001cc0:	31c010ef          	jal	ra,80002fdc <__mulsi3>
80001cc4:	00a12a23          	sw	a0,20(sp)
80001cc8:	000d0593          	mv	a1,s10
80001ccc:	000d8513          	mv	a0,s11
80001cd0:	30c010ef          	jal	ra,80002fdc <__mulsi3>
80001cd4:	00050493          	mv	s1,a0
80001cd8:	00090593          	mv	a1,s2
80001cdc:	000d8513          	mv	a0,s11
80001ce0:	2fc010ef          	jal	ra,80002fdc <__mulsi3>
80001ce4:	01412683          	lw	a3,20(sp)
80001ce8:	01812703          	lw	a4,24(sp)
80001cec:	00d50533          	add	a0,a0,a3
80001cf0:	01075793          	srli	a5,a4,0x10
80001cf4:	00a78533          	add	a0,a5,a0
80001cf8:	00d57663          	bleu	a3,a0,80001d04 <__muldf3+0x3d0>
80001cfc:	01c12603          	lw	a2,28(sp)
80001d00:	00c484b3          	add	s1,s1,a2
80001d04:	000106b7          	lui	a3,0x10
80001d08:	fff68793          	addi	a5,a3,-1 # ffff <_stack_size+0xfbff>
80001d0c:	01055d93          	srli	s11,a0,0x10
80001d10:	009d84b3          	add	s1,s11,s1
80001d14:	00f57db3          	and	s11,a0,a5
80001d18:	00f77733          	and	a4,a4,a5
80001d1c:	00090593          	mv	a1,s2
80001d20:	00040513          	mv	a0,s0
80001d24:	010d9d93          	slli	s11,s11,0x10
80001d28:	00ed8db3          	add	s11,s11,a4
80001d2c:	00d12c23          	sw	a3,24(sp)
80001d30:	2ac010ef          	jal	ra,80002fdc <__mulsi3>
80001d34:	00040593          	mv	a1,s0
80001d38:	00a12a23          	sw	a0,20(sp)
80001d3c:	000d0513          	mv	a0,s10
80001d40:	29c010ef          	jal	ra,80002fdc <__mulsi3>
80001d44:	000d0593          	mv	a1,s10
80001d48:	00050413          	mv	s0,a0
80001d4c:	000c8513          	mv	a0,s9
80001d50:	28c010ef          	jal	ra,80002fdc <__mulsi3>
80001d54:	00050d13          	mv	s10,a0
80001d58:	00090593          	mv	a1,s2
80001d5c:	000c8513          	mv	a0,s9
80001d60:	27c010ef          	jal	ra,80002fdc <__mulsi3>
80001d64:	01412703          	lw	a4,20(sp)
80001d68:	00850533          	add	a0,a0,s0
80001d6c:	01075793          	srli	a5,a4,0x10
80001d70:	00a78533          	add	a0,a5,a0
80001d74:	00857663          	bleu	s0,a0,80001d80 <__muldf3+0x44c>
80001d78:	01812683          	lw	a3,24(sp)
80001d7c:	00dd0d33          	add	s10,s10,a3
80001d80:	01012783          	lw	a5,16(sp)
80001d84:	000106b7          	lui	a3,0x10
80001d88:	fff68693          	addi	a3,a3,-1 # ffff <_stack_size+0xfbff>
80001d8c:	00fb0b33          	add	s6,s6,a5
80001d90:	00d577b3          	and	a5,a0,a3
80001d94:	00d77733          	and	a4,a4,a3
80001d98:	01079793          	slli	a5,a5,0x10
80001d9c:	00e787b3          	add	a5,a5,a4
80001da0:	014b3a33          	sltu	s4,s6,s4
80001da4:	018787b3          	add	a5,a5,s8
80001da8:	01478433          	add	s0,a5,s4
80001dac:	01bb0b33          	add	s6,s6,s11
80001db0:	00940733          	add	a4,s0,s1
80001db4:	01bb3db3          	sltu	s11,s6,s11
80001db8:	01b706b3          	add	a3,a4,s11
80001dbc:	0187bc33          	sltu	s8,a5,s8
80001dc0:	01443433          	sltu	s0,s0,s4
80001dc4:	01055793          	srli	a5,a0,0x10
80001dc8:	00973733          	sltu	a4,a4,s1
80001dcc:	008c6433          	or	s0,s8,s0
80001dd0:	01b6bdb3          	sltu	s11,a3,s11
80001dd4:	00f40433          	add	s0,s0,a5
80001dd8:	01b76db3          	or	s11,a4,s11
80001ddc:	01b40433          	add	s0,s0,s11
80001de0:	01a40433          	add	s0,s0,s10
80001de4:	0176d793          	srli	a5,a3,0x17
80001de8:	00941413          	slli	s0,s0,0x9
80001dec:	00f46433          	or	s0,s0,a5
80001df0:	00c12783          	lw	a5,12(sp)
80001df4:	009b1493          	slli	s1,s6,0x9
80001df8:	017b5b13          	srli	s6,s6,0x17
80001dfc:	00f4e4b3          	or	s1,s1,a5
80001e00:	009034b3          	snez	s1,s1
80001e04:	00969793          	slli	a5,a3,0x9
80001e08:	0164e4b3          	or	s1,s1,s6
80001e0c:	00f4e4b3          	or	s1,s1,a5
80001e10:	00741793          	slli	a5,s0,0x7
80001e14:	1207d263          	bgez	a5,80001f38 <__muldf3+0x604>
80001e18:	0014d793          	srli	a5,s1,0x1
80001e1c:	0014f493          	andi	s1,s1,1
80001e20:	0097e4b3          	or	s1,a5,s1
80001e24:	01f41793          	slli	a5,s0,0x1f
80001e28:	00f4e4b3          	or	s1,s1,a5
80001e2c:	00145413          	srli	s0,s0,0x1
80001e30:	3ffa8713          	addi	a4,s5,1023
80001e34:	10e05663          	blez	a4,80001f40 <__muldf3+0x60c>
80001e38:	0074f793          	andi	a5,s1,7
80001e3c:	02078063          	beqz	a5,80001e5c <__muldf3+0x528>
80001e40:	00f4f793          	andi	a5,s1,15
80001e44:	00400693          	li	a3,4
80001e48:	00d78a63          	beq	a5,a3,80001e5c <__muldf3+0x528>
80001e4c:	00448793          	addi	a5,s1,4
80001e50:	0097b4b3          	sltu	s1,a5,s1
80001e54:	00940433          	add	s0,s0,s1
80001e58:	00078493          	mv	s1,a5
80001e5c:	00741793          	slli	a5,s0,0x7
80001e60:	0007da63          	bgez	a5,80001e74 <__muldf3+0x540>
80001e64:	ff0007b7          	lui	a5,0xff000
80001e68:	fff78793          	addi	a5,a5,-1 # feffffff <_stack_start+0x7eff96ef>
80001e6c:	00f47433          	and	s0,s0,a5
80001e70:	400a8713          	addi	a4,s5,1024
80001e74:	7fe00793          	li	a5,2046
80001e78:	18e7c663          	blt	a5,a4,80002004 <__muldf3+0x6d0>
80001e7c:	0034da93          	srli	s5,s1,0x3
80001e80:	01d41493          	slli	s1,s0,0x1d
80001e84:	0154e4b3          	or	s1,s1,s5
80001e88:	00345413          	srli	s0,s0,0x3
80001e8c:	001007b7          	lui	a5,0x100
80001e90:	fff78793          	addi	a5,a5,-1 # fffff <_stack_size+0xffbff>
80001e94:	00f47433          	and	s0,s0,a5
80001e98:	7ff77793          	andi	a5,a4,2047
80001e9c:	80100737          	lui	a4,0x80100
80001ea0:	fff70713          	addi	a4,a4,-1 # 800fffff <_stack_start+0xf96ef>
80001ea4:	01479793          	slli	a5,a5,0x14
80001ea8:	00e47433          	and	s0,s0,a4
80001eac:	01fb9b93          	slli	s7,s7,0x1f
80001eb0:	00f46433          	or	s0,s0,a5
80001eb4:	017467b3          	or	a5,s0,s7
80001eb8:	05c12083          	lw	ra,92(sp)
80001ebc:	05812403          	lw	s0,88(sp)
80001ec0:	00048513          	mv	a0,s1
80001ec4:	05012903          	lw	s2,80(sp)
80001ec8:	05412483          	lw	s1,84(sp)
80001ecc:	04c12983          	lw	s3,76(sp)
80001ed0:	04812a03          	lw	s4,72(sp)
80001ed4:	04412a83          	lw	s5,68(sp)
80001ed8:	04012b03          	lw	s6,64(sp)
80001edc:	03c12b83          	lw	s7,60(sp)
80001ee0:	03812c03          	lw	s8,56(sp)
80001ee4:	03412c83          	lw	s9,52(sp)
80001ee8:	03012d03          	lw	s10,48(sp)
80001eec:	02c12d83          	lw	s11,44(sp)
80001ef0:	00078593          	mv	a1,a5
80001ef4:	06010113          	addi	sp,sp,96
80001ef8:	00008067          	ret
80001efc:	000b0b93          	mv	s7,s6
80001f00:	00090413          	mv	s0,s2
80001f04:	000d0493          	mv	s1,s10
80001f08:	000c8793          	mv	a5,s9
80001f0c:	00200713          	li	a4,2
80001f10:	0ee78a63          	beq	a5,a4,80002004 <__muldf3+0x6d0>
80001f14:	00300713          	li	a4,3
80001f18:	0ce78c63          	beq	a5,a4,80001ff0 <__muldf3+0x6bc>
80001f1c:	00100713          	li	a4,1
80001f20:	f0e798e3          	bne	a5,a4,80001e30 <__muldf3+0x4fc>
80001f24:	00000413          	li	s0,0
80001f28:	00000493          	li	s1,0
80001f2c:	0880006f          	j	80001fb4 <__muldf3+0x680>
80001f30:	000c0b93          	mv	s7,s8
80001f34:	fd9ff06f          	j	80001f0c <__muldf3+0x5d8>
80001f38:	00098a93          	mv	s5,s3
80001f3c:	ef5ff06f          	j	80001e30 <__muldf3+0x4fc>
80001f40:	00100693          	li	a3,1
80001f44:	40e686b3          	sub	a3,a3,a4
80001f48:	03800793          	li	a5,56
80001f4c:	fcd7cce3          	blt	a5,a3,80001f24 <__muldf3+0x5f0>
80001f50:	01f00793          	li	a5,31
80001f54:	06d7c463          	blt	a5,a3,80001fbc <__muldf3+0x688>
80001f58:	41ea8a93          	addi	s5,s5,1054
80001f5c:	015417b3          	sll	a5,s0,s5
80001f60:	00d4d733          	srl	a4,s1,a3
80001f64:	015494b3          	sll	s1,s1,s5
80001f68:	00e7e7b3          	or	a5,a5,a4
80001f6c:	009034b3          	snez	s1,s1
80001f70:	0097e4b3          	or	s1,a5,s1
80001f74:	00d45433          	srl	s0,s0,a3
80001f78:	0074f793          	andi	a5,s1,7
80001f7c:	02078063          	beqz	a5,80001f9c <__muldf3+0x668>
80001f80:	00f4f793          	andi	a5,s1,15
80001f84:	00400713          	li	a4,4
80001f88:	00e78a63          	beq	a5,a4,80001f9c <__muldf3+0x668>
80001f8c:	00448793          	addi	a5,s1,4
80001f90:	0097b4b3          	sltu	s1,a5,s1
80001f94:	00940433          	add	s0,s0,s1
80001f98:	00078493          	mv	s1,a5
80001f9c:	00841793          	slli	a5,s0,0x8
80001fa0:	0607ca63          	bltz	a5,80002014 <__muldf3+0x6e0>
80001fa4:	01d41793          	slli	a5,s0,0x1d
80001fa8:	0034d493          	srli	s1,s1,0x3
80001fac:	0097e4b3          	or	s1,a5,s1
80001fb0:	00345413          	srli	s0,s0,0x3
80001fb4:	00000713          	li	a4,0
80001fb8:	ed5ff06f          	j	80001e8c <__muldf3+0x558>
80001fbc:	fe100793          	li	a5,-31
80001fc0:	40e787b3          	sub	a5,a5,a4
80001fc4:	02000613          	li	a2,32
80001fc8:	00f457b3          	srl	a5,s0,a5
80001fcc:	00000713          	li	a4,0
80001fd0:	00c68663          	beq	a3,a2,80001fdc <__muldf3+0x6a8>
80001fd4:	43ea8a93          	addi	s5,s5,1086
80001fd8:	01541733          	sll	a4,s0,s5
80001fdc:	009764b3          	or	s1,a4,s1
80001fe0:	009034b3          	snez	s1,s1
80001fe4:	0097e4b3          	or	s1,a5,s1
80001fe8:	00000413          	li	s0,0
80001fec:	f8dff06f          	j	80001f78 <__muldf3+0x644>
80001ff0:	00080437          	lui	s0,0x80
80001ff4:	00000493          	li	s1,0
80001ff8:	7ff00713          	li	a4,2047
80001ffc:	00000b93          	li	s7,0
80002000:	e8dff06f          	j	80001e8c <__muldf3+0x558>
80002004:	00000413          	li	s0,0
80002008:	00000493          	li	s1,0
8000200c:	7ff00713          	li	a4,2047
80002010:	e7dff06f          	j	80001e8c <__muldf3+0x558>
80002014:	00000413          	li	s0,0
80002018:	00000493          	li	s1,0
8000201c:	00100713          	li	a4,1
80002020:	e6dff06f          	j	80001e8c <__muldf3+0x558>

80002024 <__divsf3>:
80002024:	fd010113          	addi	sp,sp,-48
80002028:	02912223          	sw	s1,36(sp)
8000202c:	01512a23          	sw	s5,20(sp)
80002030:	01755493          	srli	s1,a0,0x17
80002034:	00800ab7          	lui	s5,0x800
80002038:	03212023          	sw	s2,32(sp)
8000203c:	01612823          	sw	s6,16(sp)
80002040:	fffa8a93          	addi	s5,s5,-1 # 7fffff <_stack_size+0x7ffbff>
80002044:	02112623          	sw	ra,44(sp)
80002048:	02812423          	sw	s0,40(sp)
8000204c:	01312e23          	sw	s3,28(sp)
80002050:	01412c23          	sw	s4,24(sp)
80002054:	01712623          	sw	s7,12(sp)
80002058:	01812423          	sw	s8,8(sp)
8000205c:	0ff4f493          	andi	s1,s1,255
80002060:	00058b13          	mv	s6,a1
80002064:	00aafab3          	and	s5,s5,a0
80002068:	01f55913          	srli	s2,a0,0x1f
8000206c:	08048863          	beqz	s1,800020fc <__divsf3+0xd8>
80002070:	0ff00793          	li	a5,255
80002074:	0af48463          	beq	s1,a5,8000211c <__divsf3+0xf8>
80002078:	003a9a93          	slli	s5,s5,0x3
8000207c:	040007b7          	lui	a5,0x4000
80002080:	00faeab3          	or	s5,s5,a5
80002084:	f8148493          	addi	s1,s1,-127
80002088:	00000b93          	li	s7,0
8000208c:	017b5513          	srli	a0,s6,0x17
80002090:	00800437          	lui	s0,0x800
80002094:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002098:	0ff57513          	andi	a0,a0,255
8000209c:	01647433          	and	s0,s0,s6
800020a0:	01fb5b13          	srli	s6,s6,0x1f
800020a4:	08050c63          	beqz	a0,8000213c <__divsf3+0x118>
800020a8:	0ff00793          	li	a5,255
800020ac:	0af50863          	beq	a0,a5,8000215c <__divsf3+0x138>
800020b0:	00341413          	slli	s0,s0,0x3
800020b4:	040007b7          	lui	a5,0x4000
800020b8:	00f46433          	or	s0,s0,a5
800020bc:	f8150513          	addi	a0,a0,-127
800020c0:	00000793          	li	a5,0
800020c4:	002b9713          	slli	a4,s7,0x2
800020c8:	00f76733          	or	a4,a4,a5
800020cc:	fff70713          	addi	a4,a4,-1
800020d0:	00e00693          	li	a3,14
800020d4:	016949b3          	xor	s3,s2,s6
800020d8:	40a48a33          	sub	s4,s1,a0
800020dc:	0ae6e063          	bltu	a3,a4,8000217c <__divsf3+0x158>
800020e0:	00001697          	auipc	a3,0x1
800020e4:	68468693          	addi	a3,a3,1668 # 80003764 <end+0x664>
800020e8:	00271713          	slli	a4,a4,0x2
800020ec:	00d70733          	add	a4,a4,a3
800020f0:	00072703          	lw	a4,0(a4)
800020f4:	00d70733          	add	a4,a4,a3
800020f8:	00070067          	jr	a4
800020fc:	020a8a63          	beqz	s5,80002130 <__divsf3+0x10c>
80002100:	000a8513          	mv	a0,s5
80002104:	7b1000ef          	jal	ra,800030b4 <__clzsi2>
80002108:	ffb50793          	addi	a5,a0,-5
8000210c:	f8a00493          	li	s1,-118
80002110:	00fa9ab3          	sll	s5,s5,a5
80002114:	40a484b3          	sub	s1,s1,a0
80002118:	f71ff06f          	j	80002088 <__divsf3+0x64>
8000211c:	0ff00493          	li	s1,255
80002120:	00200b93          	li	s7,2
80002124:	f60a84e3          	beqz	s5,8000208c <__divsf3+0x68>
80002128:	00300b93          	li	s7,3
8000212c:	f61ff06f          	j	8000208c <__divsf3+0x68>
80002130:	00000493          	li	s1,0
80002134:	00100b93          	li	s7,1
80002138:	f55ff06f          	j	8000208c <__divsf3+0x68>
8000213c:	02040a63          	beqz	s0,80002170 <__divsf3+0x14c>
80002140:	00040513          	mv	a0,s0
80002144:	771000ef          	jal	ra,800030b4 <__clzsi2>
80002148:	ffb50793          	addi	a5,a0,-5
8000214c:	00f41433          	sll	s0,s0,a5
80002150:	f8a00793          	li	a5,-118
80002154:	40a78533          	sub	a0,a5,a0
80002158:	f69ff06f          	j	800020c0 <__divsf3+0x9c>
8000215c:	0ff00513          	li	a0,255
80002160:	00200793          	li	a5,2
80002164:	f60400e3          	beqz	s0,800020c4 <__divsf3+0xa0>
80002168:	00300793          	li	a5,3
8000216c:	f59ff06f          	j	800020c4 <__divsf3+0xa0>
80002170:	00000513          	li	a0,0
80002174:	00100793          	li	a5,1
80002178:	f4dff06f          	j	800020c4 <__divsf3+0xa0>
8000217c:	00541b13          	slli	s6,s0,0x5
80002180:	128af663          	bleu	s0,s5,800022ac <__divsf3+0x288>
80002184:	fffa0a13          	addi	s4,s4,-1
80002188:	00000913          	li	s2,0
8000218c:	010b5b93          	srli	s7,s6,0x10
80002190:	00010437          	lui	s0,0x10
80002194:	000b8593          	mv	a1,s7
80002198:	fff40413          	addi	s0,s0,-1 # ffff <_stack_size+0xfbff>
8000219c:	000a8513          	mv	a0,s5
800021a0:	669000ef          	jal	ra,80003008 <__udivsi3>
800021a4:	008b7433          	and	s0,s6,s0
800021a8:	00050593          	mv	a1,a0
800021ac:	00050c13          	mv	s8,a0
800021b0:	00040513          	mv	a0,s0
800021b4:	629000ef          	jal	ra,80002fdc <__mulsi3>
800021b8:	00050493          	mv	s1,a0
800021bc:	000b8593          	mv	a1,s7
800021c0:	000a8513          	mv	a0,s5
800021c4:	68d000ef          	jal	ra,80003050 <__umodsi3>
800021c8:	01095913          	srli	s2,s2,0x10
800021cc:	01051513          	slli	a0,a0,0x10
800021d0:	00a96533          	or	a0,s2,a0
800021d4:	000c0913          	mv	s2,s8
800021d8:	00957e63          	bleu	s1,a0,800021f4 <__divsf3+0x1d0>
800021dc:	01650533          	add	a0,a0,s6
800021e0:	fffc0913          	addi	s2,s8,-1
800021e4:	01656863          	bltu	a0,s6,800021f4 <__divsf3+0x1d0>
800021e8:	00957663          	bleu	s1,a0,800021f4 <__divsf3+0x1d0>
800021ec:	ffec0913          	addi	s2,s8,-2
800021f0:	01650533          	add	a0,a0,s6
800021f4:	409504b3          	sub	s1,a0,s1
800021f8:	000b8593          	mv	a1,s7
800021fc:	00048513          	mv	a0,s1
80002200:	609000ef          	jal	ra,80003008 <__udivsi3>
80002204:	00050593          	mv	a1,a0
80002208:	00050c13          	mv	s8,a0
8000220c:	00040513          	mv	a0,s0
80002210:	5cd000ef          	jal	ra,80002fdc <__mulsi3>
80002214:	00050a93          	mv	s5,a0
80002218:	000b8593          	mv	a1,s7
8000221c:	00048513          	mv	a0,s1
80002220:	631000ef          	jal	ra,80003050 <__umodsi3>
80002224:	01051513          	slli	a0,a0,0x10
80002228:	000c0413          	mv	s0,s8
8000222c:	01557e63          	bleu	s5,a0,80002248 <__divsf3+0x224>
80002230:	01650533          	add	a0,a0,s6
80002234:	fffc0413          	addi	s0,s8,-1
80002238:	01656863          	bltu	a0,s6,80002248 <__divsf3+0x224>
8000223c:	01557663          	bleu	s5,a0,80002248 <__divsf3+0x224>
80002240:	ffec0413          	addi	s0,s8,-2
80002244:	01650533          	add	a0,a0,s6
80002248:	01091913          	slli	s2,s2,0x10
8000224c:	41550533          	sub	a0,a0,s5
80002250:	00896933          	or	s2,s2,s0
80002254:	00a03533          	snez	a0,a0
80002258:	00a96433          	or	s0,s2,a0
8000225c:	07fa0713          	addi	a4,s4,127
80002260:	0ae05063          	blez	a4,80002300 <__divsf3+0x2dc>
80002264:	00747793          	andi	a5,s0,7
80002268:	00078a63          	beqz	a5,8000227c <__divsf3+0x258>
8000226c:	00f47793          	andi	a5,s0,15
80002270:	00400693          	li	a3,4
80002274:	00d78463          	beq	a5,a3,8000227c <__divsf3+0x258>
80002278:	00440413          	addi	s0,s0,4
8000227c:	00441793          	slli	a5,s0,0x4
80002280:	0007da63          	bgez	a5,80002294 <__divsf3+0x270>
80002284:	f80007b7          	lui	a5,0xf8000
80002288:	fff78793          	addi	a5,a5,-1 # f7ffffff <_stack_start+0x77ff96ef>
8000228c:	00f47433          	and	s0,s0,a5
80002290:	080a0713          	addi	a4,s4,128
80002294:	0fe00793          	li	a5,254
80002298:	00345413          	srli	s0,s0,0x3
8000229c:	0ce7d263          	ble	a4,a5,80002360 <__divsf3+0x33c>
800022a0:	00000413          	li	s0,0
800022a4:	0ff00713          	li	a4,255
800022a8:	0b80006f          	j	80002360 <__divsf3+0x33c>
800022ac:	01fa9913          	slli	s2,s5,0x1f
800022b0:	001ada93          	srli	s5,s5,0x1
800022b4:	ed9ff06f          	j	8000218c <__divsf3+0x168>
800022b8:	00090993          	mv	s3,s2
800022bc:	000a8413          	mv	s0,s5
800022c0:	000b8793          	mv	a5,s7
800022c4:	00200713          	li	a4,2
800022c8:	fce78ce3          	beq	a5,a4,800022a0 <__divsf3+0x27c>
800022cc:	00300713          	li	a4,3
800022d0:	08e78263          	beq	a5,a4,80002354 <__divsf3+0x330>
800022d4:	00100713          	li	a4,1
800022d8:	f8e792e3          	bne	a5,a4,8000225c <__divsf3+0x238>
800022dc:	00000413          	li	s0,0
800022e0:	00000713          	li	a4,0
800022e4:	07c0006f          	j	80002360 <__divsf3+0x33c>
800022e8:	000b0993          	mv	s3,s6
800022ec:	fd9ff06f          	j	800022c4 <__divsf3+0x2a0>
800022f0:	00400437          	lui	s0,0x400
800022f4:	00000993          	li	s3,0
800022f8:	00300793          	li	a5,3
800022fc:	fc9ff06f          	j	800022c4 <__divsf3+0x2a0>
80002300:	00100793          	li	a5,1
80002304:	40e787b3          	sub	a5,a5,a4
80002308:	01b00713          	li	a4,27
8000230c:	fcf748e3          	blt	a4,a5,800022dc <__divsf3+0x2b8>
80002310:	09ea0513          	addi	a0,s4,158
80002314:	00f457b3          	srl	a5,s0,a5
80002318:	00a41433          	sll	s0,s0,a0
8000231c:	00803433          	snez	s0,s0
80002320:	0087e433          	or	s0,a5,s0
80002324:	00747793          	andi	a5,s0,7
80002328:	00078a63          	beqz	a5,8000233c <__divsf3+0x318>
8000232c:	00f47793          	andi	a5,s0,15
80002330:	00400713          	li	a4,4
80002334:	00e78463          	beq	a5,a4,8000233c <__divsf3+0x318>
80002338:	00440413          	addi	s0,s0,4 # 400004 <_stack_size+0x3ffc04>
8000233c:	00541793          	slli	a5,s0,0x5
80002340:	00345413          	srli	s0,s0,0x3
80002344:	f807dee3          	bgez	a5,800022e0 <__divsf3+0x2bc>
80002348:	00000413          	li	s0,0
8000234c:	00100713          	li	a4,1
80002350:	0100006f          	j	80002360 <__divsf3+0x33c>
80002354:	00400437          	lui	s0,0x400
80002358:	0ff00713          	li	a4,255
8000235c:	00000993          	li	s3,0
80002360:	00800537          	lui	a0,0x800
80002364:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80002368:	00a47433          	and	s0,s0,a0
8000236c:	80800537          	lui	a0,0x80800
80002370:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f96ef>
80002374:	0ff77713          	andi	a4,a4,255
80002378:	00a47433          	and	s0,s0,a0
8000237c:	01771713          	slli	a4,a4,0x17
80002380:	01f99513          	slli	a0,s3,0x1f
80002384:	00e46433          	or	s0,s0,a4
80002388:	00a46533          	or	a0,s0,a0
8000238c:	02c12083          	lw	ra,44(sp)
80002390:	02812403          	lw	s0,40(sp)
80002394:	02412483          	lw	s1,36(sp)
80002398:	02012903          	lw	s2,32(sp)
8000239c:	01c12983          	lw	s3,28(sp)
800023a0:	01812a03          	lw	s4,24(sp)
800023a4:	01412a83          	lw	s5,20(sp)
800023a8:	01012b03          	lw	s6,16(sp)
800023ac:	00c12b83          	lw	s7,12(sp)
800023b0:	00812c03          	lw	s8,8(sp)
800023b4:	03010113          	addi	sp,sp,48
800023b8:	00008067          	ret

800023bc <__mulsf3>:
800023bc:	fd010113          	addi	sp,sp,-48
800023c0:	02912223          	sw	s1,36(sp)
800023c4:	03212023          	sw	s2,32(sp)
800023c8:	008004b7          	lui	s1,0x800
800023cc:	01755913          	srli	s2,a0,0x17
800023d0:	01312e23          	sw	s3,28(sp)
800023d4:	01712623          	sw	s7,12(sp)
800023d8:	fff48493          	addi	s1,s1,-1 # 7fffff <_stack_size+0x7ffbff>
800023dc:	02112623          	sw	ra,44(sp)
800023e0:	02812423          	sw	s0,40(sp)
800023e4:	01412c23          	sw	s4,24(sp)
800023e8:	01512a23          	sw	s5,20(sp)
800023ec:	01612823          	sw	s6,16(sp)
800023f0:	01812423          	sw	s8,8(sp)
800023f4:	01912223          	sw	s9,4(sp)
800023f8:	0ff97913          	andi	s2,s2,255
800023fc:	00058b93          	mv	s7,a1
80002400:	00a4f4b3          	and	s1,s1,a0
80002404:	01f55993          	srli	s3,a0,0x1f
80002408:	08090a63          	beqz	s2,8000249c <__mulsf3+0xe0>
8000240c:	0ff00793          	li	a5,255
80002410:	0af90663          	beq	s2,a5,800024bc <__mulsf3+0x100>
80002414:	00349493          	slli	s1,s1,0x3
80002418:	040007b7          	lui	a5,0x4000
8000241c:	00f4e4b3          	or	s1,s1,a5
80002420:	f8190913          	addi	s2,s2,-127 # 7fff81 <_stack_size+0x7ffb81>
80002424:	00000b13          	li	s6,0
80002428:	017bd513          	srli	a0,s7,0x17
8000242c:	00800437          	lui	s0,0x800
80002430:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002434:	0ff57513          	andi	a0,a0,255
80002438:	01747433          	and	s0,s0,s7
8000243c:	01fbdb93          	srli	s7,s7,0x1f
80002440:	08050e63          	beqz	a0,800024dc <__mulsf3+0x120>
80002444:	0ff00793          	li	a5,255
80002448:	0af50a63          	beq	a0,a5,800024fc <__mulsf3+0x140>
8000244c:	00341413          	slli	s0,s0,0x3
80002450:	040007b7          	lui	a5,0x4000
80002454:	00f46433          	or	s0,s0,a5
80002458:	f8150513          	addi	a0,a0,-127
8000245c:	00000693          	li	a3,0
80002460:	002b1793          	slli	a5,s6,0x2
80002464:	00d7e7b3          	or	a5,a5,a3
80002468:	00a90933          	add	s2,s2,a0
8000246c:	fff78793          	addi	a5,a5,-1 # 3ffffff <_stack_size+0x3fffbff>
80002470:	00e00713          	li	a4,14
80002474:	0179ca33          	xor	s4,s3,s7
80002478:	00190a93          	addi	s5,s2,1
8000247c:	0af76063          	bltu	a4,a5,8000251c <__mulsf3+0x160>
80002480:	00001717          	auipc	a4,0x1
80002484:	32070713          	addi	a4,a4,800 # 800037a0 <end+0x6a0>
80002488:	00279793          	slli	a5,a5,0x2
8000248c:	00e787b3          	add	a5,a5,a4
80002490:	0007a783          	lw	a5,0(a5)
80002494:	00e787b3          	add	a5,a5,a4
80002498:	00078067          	jr	a5
8000249c:	02048a63          	beqz	s1,800024d0 <__mulsf3+0x114>
800024a0:	00048513          	mv	a0,s1
800024a4:	411000ef          	jal	ra,800030b4 <__clzsi2>
800024a8:	ffb50793          	addi	a5,a0,-5
800024ac:	f8a00913          	li	s2,-118
800024b0:	00f494b3          	sll	s1,s1,a5
800024b4:	40a90933          	sub	s2,s2,a0
800024b8:	f6dff06f          	j	80002424 <__mulsf3+0x68>
800024bc:	0ff00913          	li	s2,255
800024c0:	00200b13          	li	s6,2
800024c4:	f60482e3          	beqz	s1,80002428 <__mulsf3+0x6c>
800024c8:	00300b13          	li	s6,3
800024cc:	f5dff06f          	j	80002428 <__mulsf3+0x6c>
800024d0:	00000913          	li	s2,0
800024d4:	00100b13          	li	s6,1
800024d8:	f51ff06f          	j	80002428 <__mulsf3+0x6c>
800024dc:	02040a63          	beqz	s0,80002510 <__mulsf3+0x154>
800024e0:	00040513          	mv	a0,s0
800024e4:	3d1000ef          	jal	ra,800030b4 <__clzsi2>
800024e8:	ffb50793          	addi	a5,a0,-5
800024ec:	00f41433          	sll	s0,s0,a5
800024f0:	f8a00793          	li	a5,-118
800024f4:	40a78533          	sub	a0,a5,a0
800024f8:	f65ff06f          	j	8000245c <__mulsf3+0xa0>
800024fc:	0ff00513          	li	a0,255
80002500:	00200693          	li	a3,2
80002504:	f4040ee3          	beqz	s0,80002460 <__mulsf3+0xa4>
80002508:	00300693          	li	a3,3
8000250c:	f55ff06f          	j	80002460 <__mulsf3+0xa4>
80002510:	00000513          	li	a0,0
80002514:	00100693          	li	a3,1
80002518:	f49ff06f          	j	80002460 <__mulsf3+0xa4>
8000251c:	00010c37          	lui	s8,0x10
80002520:	fffc0b13          	addi	s6,s8,-1 # ffff <_stack_size+0xfbff>
80002524:	0104db93          	srli	s7,s1,0x10
80002528:	01045c93          	srli	s9,s0,0x10
8000252c:	0164f4b3          	and	s1,s1,s6
80002530:	01647433          	and	s0,s0,s6
80002534:	00040593          	mv	a1,s0
80002538:	00048513          	mv	a0,s1
8000253c:	2a1000ef          	jal	ra,80002fdc <__mulsi3>
80002540:	00040593          	mv	a1,s0
80002544:	00050993          	mv	s3,a0
80002548:	000b8513          	mv	a0,s7
8000254c:	291000ef          	jal	ra,80002fdc <__mulsi3>
80002550:	00050413          	mv	s0,a0
80002554:	000c8593          	mv	a1,s9
80002558:	000b8513          	mv	a0,s7
8000255c:	281000ef          	jal	ra,80002fdc <__mulsi3>
80002560:	00050b93          	mv	s7,a0
80002564:	00048593          	mv	a1,s1
80002568:	000c8513          	mv	a0,s9
8000256c:	271000ef          	jal	ra,80002fdc <__mulsi3>
80002570:	00850533          	add	a0,a0,s0
80002574:	0109d793          	srli	a5,s3,0x10
80002578:	00a78533          	add	a0,a5,a0
8000257c:	00857463          	bleu	s0,a0,80002584 <__mulsf3+0x1c8>
80002580:	018b8bb3          	add	s7,s7,s8
80002584:	016577b3          	and	a5,a0,s6
80002588:	01079793          	slli	a5,a5,0x10
8000258c:	0169f9b3          	and	s3,s3,s6
80002590:	013787b3          	add	a5,a5,s3
80002594:	00679413          	slli	s0,a5,0x6
80002598:	00803433          	snez	s0,s0
8000259c:	01a7d793          	srli	a5,a5,0x1a
800025a0:	01055513          	srli	a0,a0,0x10
800025a4:	00f467b3          	or	a5,s0,a5
800025a8:	01750433          	add	s0,a0,s7
800025ac:	00641413          	slli	s0,s0,0x6
800025b0:	00f46433          	or	s0,s0,a5
800025b4:	00441793          	slli	a5,s0,0x4
800025b8:	0e07d663          	bgez	a5,800026a4 <__mulsf3+0x2e8>
800025bc:	00145793          	srli	a5,s0,0x1
800025c0:	00147413          	andi	s0,s0,1
800025c4:	0087e433          	or	s0,a5,s0
800025c8:	07fa8713          	addi	a4,s5,127
800025cc:	0ee05063          	blez	a4,800026ac <__mulsf3+0x2f0>
800025d0:	00747793          	andi	a5,s0,7
800025d4:	00078a63          	beqz	a5,800025e8 <__mulsf3+0x22c>
800025d8:	00f47793          	andi	a5,s0,15
800025dc:	00400693          	li	a3,4
800025e0:	00d78463          	beq	a5,a3,800025e8 <__mulsf3+0x22c>
800025e4:	00440413          	addi	s0,s0,4
800025e8:	00441793          	slli	a5,s0,0x4
800025ec:	0007da63          	bgez	a5,80002600 <__mulsf3+0x244>
800025f0:	f80007b7          	lui	a5,0xf8000
800025f4:	fff78793          	addi	a5,a5,-1 # f7ffffff <_stack_start+0x77ff96ef>
800025f8:	00f47433          	and	s0,s0,a5
800025fc:	080a8713          	addi	a4,s5,128
80002600:	0fe00793          	li	a5,254
80002604:	10e7c463          	blt	a5,a4,8000270c <__mulsf3+0x350>
80002608:	00345793          	srli	a5,s0,0x3
8000260c:	0300006f          	j	8000263c <__mulsf3+0x280>
80002610:	00098a13          	mv	s4,s3
80002614:	00048413          	mv	s0,s1
80002618:	000b0693          	mv	a3,s6
8000261c:	00200793          	li	a5,2
80002620:	0ef68663          	beq	a3,a5,8000270c <__mulsf3+0x350>
80002624:	00300793          	li	a5,3
80002628:	0cf68a63          	beq	a3,a5,800026fc <__mulsf3+0x340>
8000262c:	00100613          	li	a2,1
80002630:	00000793          	li	a5,0
80002634:	00000713          	li	a4,0
80002638:	f8c698e3          	bne	a3,a2,800025c8 <__mulsf3+0x20c>
8000263c:	00800437          	lui	s0,0x800
80002640:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002644:	80800537          	lui	a0,0x80800
80002648:	0087f7b3          	and	a5,a5,s0
8000264c:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f96ef>
80002650:	02c12083          	lw	ra,44(sp)
80002654:	02812403          	lw	s0,40(sp)
80002658:	0ff77713          	andi	a4,a4,255
8000265c:	00a7f7b3          	and	a5,a5,a0
80002660:	01771713          	slli	a4,a4,0x17
80002664:	01fa1513          	slli	a0,s4,0x1f
80002668:	00e7e7b3          	or	a5,a5,a4
8000266c:	02412483          	lw	s1,36(sp)
80002670:	02012903          	lw	s2,32(sp)
80002674:	01c12983          	lw	s3,28(sp)
80002678:	01812a03          	lw	s4,24(sp)
8000267c:	01412a83          	lw	s5,20(sp)
80002680:	01012b03          	lw	s6,16(sp)
80002684:	00c12b83          	lw	s7,12(sp)
80002688:	00812c03          	lw	s8,8(sp)
8000268c:	00412c83          	lw	s9,4(sp)
80002690:	00a7e533          	or	a0,a5,a0
80002694:	03010113          	addi	sp,sp,48
80002698:	00008067          	ret
8000269c:	000b8a13          	mv	s4,s7
800026a0:	f7dff06f          	j	8000261c <__mulsf3+0x260>
800026a4:	00090a93          	mv	s5,s2
800026a8:	f21ff06f          	j	800025c8 <__mulsf3+0x20c>
800026ac:	00100793          	li	a5,1
800026b0:	40e787b3          	sub	a5,a5,a4
800026b4:	01b00713          	li	a4,27
800026b8:	06f74063          	blt	a4,a5,80002718 <__mulsf3+0x35c>
800026bc:	09ea8a93          	addi	s5,s5,158
800026c0:	00f457b3          	srl	a5,s0,a5
800026c4:	01541433          	sll	s0,s0,s5
800026c8:	00803433          	snez	s0,s0
800026cc:	0087e433          	or	s0,a5,s0
800026d0:	00747793          	andi	a5,s0,7
800026d4:	00078a63          	beqz	a5,800026e8 <__mulsf3+0x32c>
800026d8:	00f47793          	andi	a5,s0,15
800026dc:	00400713          	li	a4,4
800026e0:	00e78463          	beq	a5,a4,800026e8 <__mulsf3+0x32c>
800026e4:	00440413          	addi	s0,s0,4
800026e8:	00541793          	slli	a5,s0,0x5
800026ec:	0207ca63          	bltz	a5,80002720 <__mulsf3+0x364>
800026f0:	00345793          	srli	a5,s0,0x3
800026f4:	00000713          	li	a4,0
800026f8:	f45ff06f          	j	8000263c <__mulsf3+0x280>
800026fc:	004007b7          	lui	a5,0x400
80002700:	0ff00713          	li	a4,255
80002704:	00000a13          	li	s4,0
80002708:	f35ff06f          	j	8000263c <__mulsf3+0x280>
8000270c:	00000793          	li	a5,0
80002710:	0ff00713          	li	a4,255
80002714:	f29ff06f          	j	8000263c <__mulsf3+0x280>
80002718:	00000793          	li	a5,0
8000271c:	fd9ff06f          	j	800026f4 <__mulsf3+0x338>
80002720:	00000793          	li	a5,0
80002724:	00100713          	li	a4,1
80002728:	f15ff06f          	j	8000263c <__mulsf3+0x280>

8000272c <__subsf3>:
8000272c:	008007b7          	lui	a5,0x800
80002730:	fff78793          	addi	a5,a5,-1 # 7fffff <_stack_size+0x7ffbff>
80002734:	ff010113          	addi	sp,sp,-16
80002738:	00a7f733          	and	a4,a5,a0
8000273c:	01755693          	srli	a3,a0,0x17
80002740:	0175d613          	srli	a2,a1,0x17
80002744:	00b7f7b3          	and	a5,a5,a1
80002748:	00912223          	sw	s1,4(sp)
8000274c:	01212023          	sw	s2,0(sp)
80002750:	0ff6f693          	andi	a3,a3,255
80002754:	00371813          	slli	a6,a4,0x3
80002758:	0ff67613          	andi	a2,a2,255
8000275c:	00112623          	sw	ra,12(sp)
80002760:	00812423          	sw	s0,8(sp)
80002764:	0ff00713          	li	a4,255
80002768:	01f55493          	srli	s1,a0,0x1f
8000276c:	00068913          	mv	s2,a3
80002770:	00060513          	mv	a0,a2
80002774:	01f5d593          	srli	a1,a1,0x1f
80002778:	00379793          	slli	a5,a5,0x3
8000277c:	00e61463          	bne	a2,a4,80002784 <__subsf3+0x58>
80002780:	00079463          	bnez	a5,80002788 <__subsf3+0x5c>
80002784:	0015c593          	xori	a1,a1,1
80002788:	40c68733          	sub	a4,a3,a2
8000278c:	1a959a63          	bne	a1,s1,80002940 <__subsf3+0x214>
80002790:	0ae05663          	blez	a4,8000283c <__subsf3+0x110>
80002794:	06061663          	bnez	a2,80002800 <__subsf3+0xd4>
80002798:	00079c63          	bnez	a5,800027b0 <__subsf3+0x84>
8000279c:	0ff00793          	li	a5,255
800027a0:	04f68c63          	beq	a3,a5,800027f8 <__subsf3+0xcc>
800027a4:	00080793          	mv	a5,a6
800027a8:	00068513          	mv	a0,a3
800027ac:	14c0006f          	j	800028f8 <__subsf3+0x1cc>
800027b0:	fff70713          	addi	a4,a4,-1
800027b4:	02071e63          	bnez	a4,800027f0 <__subsf3+0xc4>
800027b8:	010787b3          	add	a5,a5,a6
800027bc:	00068513          	mv	a0,a3
800027c0:	00579713          	slli	a4,a5,0x5
800027c4:	12075a63          	bgez	a4,800028f8 <__subsf3+0x1cc>
800027c8:	00150513          	addi	a0,a0,1
800027cc:	0ff00713          	li	a4,255
800027d0:	32e50e63          	beq	a0,a4,80002b0c <__subsf3+0x3e0>
800027d4:	7e000737          	lui	a4,0x7e000
800027d8:	0017f693          	andi	a3,a5,1
800027dc:	fff70713          	addi	a4,a4,-1 # 7dffffff <_stack_size+0x7dfffbff>
800027e0:	0017d793          	srli	a5,a5,0x1
800027e4:	00e7f7b3          	and	a5,a5,a4
800027e8:	00d7e7b3          	or	a5,a5,a3
800027ec:	10c0006f          	j	800028f8 <__subsf3+0x1cc>
800027f0:	0ff00613          	li	a2,255
800027f4:	00c69e63          	bne	a3,a2,80002810 <__subsf3+0xe4>
800027f8:	00080793          	mv	a5,a6
800027fc:	0740006f          	j	80002870 <__subsf3+0x144>
80002800:	0ff00613          	li	a2,255
80002804:	fec68ae3          	beq	a3,a2,800027f8 <__subsf3+0xcc>
80002808:	04000637          	lui	a2,0x4000
8000280c:	00c7e7b3          	or	a5,a5,a2
80002810:	01b00613          	li	a2,27
80002814:	00e65663          	ble	a4,a2,80002820 <__subsf3+0xf4>
80002818:	00100793          	li	a5,1
8000281c:	f9dff06f          	j	800027b8 <__subsf3+0x8c>
80002820:	02000613          	li	a2,32
80002824:	40e60633          	sub	a2,a2,a4
80002828:	00e7d5b3          	srl	a1,a5,a4
8000282c:	00c797b3          	sll	a5,a5,a2
80002830:	00f037b3          	snez	a5,a5
80002834:	00f5e7b3          	or	a5,a1,a5
80002838:	f81ff06f          	j	800027b8 <__subsf3+0x8c>
8000283c:	08070063          	beqz	a4,800028bc <__subsf3+0x190>
80002840:	02069c63          	bnez	a3,80002878 <__subsf3+0x14c>
80002844:	00081863          	bnez	a6,80002854 <__subsf3+0x128>
80002848:	0ff00713          	li	a4,255
8000284c:	0ae61663          	bne	a2,a4,800028f8 <__subsf3+0x1cc>
80002850:	0200006f          	j	80002870 <__subsf3+0x144>
80002854:	fff00693          	li	a3,-1
80002858:	00d71663          	bne	a4,a3,80002864 <__subsf3+0x138>
8000285c:	010787b3          	add	a5,a5,a6
80002860:	f61ff06f          	j	800027c0 <__subsf3+0x94>
80002864:	0ff00693          	li	a3,255
80002868:	fff74713          	not	a4,a4
8000286c:	02d61063          	bne	a2,a3,8000288c <__subsf3+0x160>
80002870:	0ff00513          	li	a0,255
80002874:	0840006f          	j	800028f8 <__subsf3+0x1cc>
80002878:	0ff00693          	li	a3,255
8000287c:	fed60ae3          	beq	a2,a3,80002870 <__subsf3+0x144>
80002880:	040006b7          	lui	a3,0x4000
80002884:	40e00733          	neg	a4,a4
80002888:	00d86833          	or	a6,a6,a3
8000288c:	01b00693          	li	a3,27
80002890:	00e6d663          	ble	a4,a3,8000289c <__subsf3+0x170>
80002894:	00100713          	li	a4,1
80002898:	01c0006f          	j	800028b4 <__subsf3+0x188>
8000289c:	02000693          	li	a3,32
800028a0:	00e85633          	srl	a2,a6,a4
800028a4:	40e68733          	sub	a4,a3,a4
800028a8:	00e81733          	sll	a4,a6,a4
800028ac:	00e03733          	snez	a4,a4
800028b0:	00e66733          	or	a4,a2,a4
800028b4:	00e787b3          	add	a5,a5,a4
800028b8:	f09ff06f          	j	800027c0 <__subsf3+0x94>
800028bc:	00168513          	addi	a0,a3,1 # 4000001 <_stack_size+0x3fffc01>
800028c0:	0ff57613          	andi	a2,a0,255
800028c4:	00100713          	li	a4,1
800028c8:	06c74263          	blt	a4,a2,8000292c <__subsf3+0x200>
800028cc:	04069463          	bnez	a3,80002914 <__subsf3+0x1e8>
800028d0:	00000513          	li	a0,0
800028d4:	02080263          	beqz	a6,800028f8 <__subsf3+0x1cc>
800028d8:	22078663          	beqz	a5,80002b04 <__subsf3+0x3d8>
800028dc:	010787b3          	add	a5,a5,a6
800028e0:	00579713          	slli	a4,a5,0x5
800028e4:	00075a63          	bgez	a4,800028f8 <__subsf3+0x1cc>
800028e8:	fc000737          	lui	a4,0xfc000
800028ec:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff96ef>
800028f0:	00e7f7b3          	and	a5,a5,a4
800028f4:	00100513          	li	a0,1
800028f8:	0077f713          	andi	a4,a5,7
800028fc:	20070a63          	beqz	a4,80002b10 <__subsf3+0x3e4>
80002900:	00f7f713          	andi	a4,a5,15
80002904:	00400693          	li	a3,4
80002908:	20d70463          	beq	a4,a3,80002b10 <__subsf3+0x3e4>
8000290c:	00478793          	addi	a5,a5,4
80002910:	2000006f          	j	80002b10 <__subsf3+0x3e4>
80002914:	f4080ee3          	beqz	a6,80002870 <__subsf3+0x144>
80002918:	ee0780e3          	beqz	a5,800027f8 <__subsf3+0xcc>
8000291c:	020007b7          	lui	a5,0x2000
80002920:	0ff00513          	li	a0,255
80002924:	00000493          	li	s1,0
80002928:	1e80006f          	j	80002b10 <__subsf3+0x3e4>
8000292c:	0ff00713          	li	a4,255
80002930:	1ce50e63          	beq	a0,a4,80002b0c <__subsf3+0x3e0>
80002934:	00f80733          	add	a4,a6,a5
80002938:	00175793          	srli	a5,a4,0x1
8000293c:	fbdff06f          	j	800028f8 <__subsf3+0x1cc>
80002940:	08e05063          	blez	a4,800029c0 <__subsf3+0x294>
80002944:	04061663          	bnez	a2,80002990 <__subsf3+0x264>
80002948:	e4078ae3          	beqz	a5,8000279c <__subsf3+0x70>
8000294c:	fff70713          	addi	a4,a4,-1
80002950:	02071463          	bnez	a4,80002978 <__subsf3+0x24c>
80002954:	40f807b3          	sub	a5,a6,a5
80002958:	00068513          	mv	a0,a3
8000295c:	00579713          	slli	a4,a5,0x5
80002960:	f8075ce3          	bgez	a4,800028f8 <__subsf3+0x1cc>
80002964:	04000437          	lui	s0,0x4000
80002968:	fff40413          	addi	s0,s0,-1 # 3ffffff <_stack_size+0x3fffbff>
8000296c:	0087f433          	and	s0,a5,s0
80002970:	00050913          	mv	s2,a0
80002974:	1380006f          	j	80002aac <__subsf3+0x380>
80002978:	0ff00613          	li	a2,255
8000297c:	e6c68ee3          	beq	a3,a2,800027f8 <__subsf3+0xcc>
80002980:	01b00613          	li	a2,27
80002984:	02e65063          	ble	a4,a2,800029a4 <__subsf3+0x278>
80002988:	00100793          	li	a5,1
8000298c:	fc9ff06f          	j	80002954 <__subsf3+0x228>
80002990:	0ff00613          	li	a2,255
80002994:	e6c682e3          	beq	a3,a2,800027f8 <__subsf3+0xcc>
80002998:	04000637          	lui	a2,0x4000
8000299c:	00c7e7b3          	or	a5,a5,a2
800029a0:	fe1ff06f          	j	80002980 <__subsf3+0x254>
800029a4:	02000613          	li	a2,32
800029a8:	00e7d5b3          	srl	a1,a5,a4
800029ac:	40e60733          	sub	a4,a2,a4
800029b0:	00e797b3          	sll	a5,a5,a4
800029b4:	00f037b3          	snez	a5,a5
800029b8:	00f5e7b3          	or	a5,a1,a5
800029bc:	f99ff06f          	j	80002954 <__subsf3+0x228>
800029c0:	08070263          	beqz	a4,80002a44 <__subsf3+0x318>
800029c4:	02069e63          	bnez	a3,80002a00 <__subsf3+0x2d4>
800029c8:	00081863          	bnez	a6,800029d8 <__subsf3+0x2ac>
800029cc:	0ff00713          	li	a4,255
800029d0:	00058493          	mv	s1,a1
800029d4:	e79ff06f          	j	8000284c <__subsf3+0x120>
800029d8:	fff00693          	li	a3,-1
800029dc:	00d71863          	bne	a4,a3,800029ec <__subsf3+0x2c0>
800029e0:	410787b3          	sub	a5,a5,a6
800029e4:	00058493          	mv	s1,a1
800029e8:	f75ff06f          	j	8000295c <__subsf3+0x230>
800029ec:	0ff00693          	li	a3,255
800029f0:	fff74713          	not	a4,a4
800029f4:	02d61063          	bne	a2,a3,80002a14 <__subsf3+0x2e8>
800029f8:	00058493          	mv	s1,a1
800029fc:	e75ff06f          	j	80002870 <__subsf3+0x144>
80002a00:	0ff00693          	li	a3,255
80002a04:	fed60ae3          	beq	a2,a3,800029f8 <__subsf3+0x2cc>
80002a08:	040006b7          	lui	a3,0x4000
80002a0c:	40e00733          	neg	a4,a4
80002a10:	00d86833          	or	a6,a6,a3
80002a14:	01b00693          	li	a3,27
80002a18:	00e6d663          	ble	a4,a3,80002a24 <__subsf3+0x2f8>
80002a1c:	00100713          	li	a4,1
80002a20:	01c0006f          	j	80002a3c <__subsf3+0x310>
80002a24:	02000693          	li	a3,32
80002a28:	00e85633          	srl	a2,a6,a4
80002a2c:	40e68733          	sub	a4,a3,a4
80002a30:	00e81733          	sll	a4,a6,a4
80002a34:	00e03733          	snez	a4,a4
80002a38:	00e66733          	or	a4,a2,a4
80002a3c:	40e787b3          	sub	a5,a5,a4
80002a40:	fa5ff06f          	j	800029e4 <__subsf3+0x2b8>
80002a44:	00168713          	addi	a4,a3,1 # 4000001 <_stack_size+0x3fffc01>
80002a48:	0ff77713          	andi	a4,a4,255
80002a4c:	00100613          	li	a2,1
80002a50:	04e64463          	blt	a2,a4,80002a98 <__subsf3+0x36c>
80002a54:	02069c63          	bnez	a3,80002a8c <__subsf3+0x360>
80002a58:	00081863          	bnez	a6,80002a68 <__subsf3+0x33c>
80002a5c:	12079863          	bnez	a5,80002b8c <__subsf3+0x460>
80002a60:	00000513          	li	a0,0
80002a64:	ec1ff06f          	j	80002924 <__subsf3+0x1f8>
80002a68:	12078663          	beqz	a5,80002b94 <__subsf3+0x468>
80002a6c:	40f80733          	sub	a4,a6,a5
80002a70:	00571693          	slli	a3,a4,0x5
80002a74:	410787b3          	sub	a5,a5,a6
80002a78:	1006ca63          	bltz	a3,80002b8c <__subsf3+0x460>
80002a7c:	00070793          	mv	a5,a4
80002a80:	06071063          	bnez	a4,80002ae0 <__subsf3+0x3b4>
80002a84:	00000793          	li	a5,0
80002a88:	fd9ff06f          	j	80002a60 <__subsf3+0x334>
80002a8c:	e80816e3          	bnez	a6,80002918 <__subsf3+0x1ec>
80002a90:	f60794e3          	bnez	a5,800029f8 <__subsf3+0x2cc>
80002a94:	e89ff06f          	j	8000291c <__subsf3+0x1f0>
80002a98:	40f80433          	sub	s0,a6,a5
80002a9c:	00541713          	slli	a4,s0,0x5
80002aa0:	04075463          	bgez	a4,80002ae8 <__subsf3+0x3bc>
80002aa4:	41078433          	sub	s0,a5,a6
80002aa8:	00058493          	mv	s1,a1
80002aac:	00040513          	mv	a0,s0
80002ab0:	604000ef          	jal	ra,800030b4 <__clzsi2>
80002ab4:	ffb50513          	addi	a0,a0,-5
80002ab8:	00a41433          	sll	s0,s0,a0
80002abc:	03254a63          	blt	a0,s2,80002af0 <__subsf3+0x3c4>
80002ac0:	41250533          	sub	a0,a0,s2
80002ac4:	00150513          	addi	a0,a0,1
80002ac8:	02000713          	li	a4,32
80002acc:	00a457b3          	srl	a5,s0,a0
80002ad0:	40a70533          	sub	a0,a4,a0
80002ad4:	00a41433          	sll	s0,s0,a0
80002ad8:	00803433          	snez	s0,s0
80002adc:	0087e7b3          	or	a5,a5,s0
80002ae0:	00000513          	li	a0,0
80002ae4:	e15ff06f          	j	800028f8 <__subsf3+0x1cc>
80002ae8:	f8040ee3          	beqz	s0,80002a84 <__subsf3+0x358>
80002aec:	fc1ff06f          	j	80002aac <__subsf3+0x380>
80002af0:	fc0007b7          	lui	a5,0xfc000
80002af4:	fff78793          	addi	a5,a5,-1 # fbffffff <_stack_start+0x7bff96ef>
80002af8:	40a90533          	sub	a0,s2,a0
80002afc:	00f477b3          	and	a5,s0,a5
80002b00:	df9ff06f          	j	800028f8 <__subsf3+0x1cc>
80002b04:	00080793          	mv	a5,a6
80002b08:	df1ff06f          	j	800028f8 <__subsf3+0x1cc>
80002b0c:	00000793          	li	a5,0
80002b10:	00579713          	slli	a4,a5,0x5
80002b14:	00075e63          	bgez	a4,80002b30 <__subsf3+0x404>
80002b18:	00150513          	addi	a0,a0,1
80002b1c:	0ff00713          	li	a4,255
80002b20:	06e50e63          	beq	a0,a4,80002b9c <__subsf3+0x470>
80002b24:	fc000737          	lui	a4,0xfc000
80002b28:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff96ef>
80002b2c:	00e7f7b3          	and	a5,a5,a4
80002b30:	0ff00713          	li	a4,255
80002b34:	0037d793          	srli	a5,a5,0x3
80002b38:	00e51863          	bne	a0,a4,80002b48 <__subsf3+0x41c>
80002b3c:	00078663          	beqz	a5,80002b48 <__subsf3+0x41c>
80002b40:	004007b7          	lui	a5,0x400
80002b44:	00000493          	li	s1,0
80002b48:	00800737          	lui	a4,0x800
80002b4c:	fff70713          	addi	a4,a4,-1 # 7fffff <_stack_size+0x7ffbff>
80002b50:	0ff57513          	andi	a0,a0,255
80002b54:	00e7f7b3          	and	a5,a5,a4
80002b58:	01751713          	slli	a4,a0,0x17
80002b5c:	80800537          	lui	a0,0x80800
80002b60:	00c12083          	lw	ra,12(sp)
80002b64:	00812403          	lw	s0,8(sp)
80002b68:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f96ef>
80002b6c:	00a7f533          	and	a0,a5,a0
80002b70:	01f49493          	slli	s1,s1,0x1f
80002b74:	00e56533          	or	a0,a0,a4
80002b78:	00956533          	or	a0,a0,s1
80002b7c:	00012903          	lw	s2,0(sp)
80002b80:	00412483          	lw	s1,4(sp)
80002b84:	01010113          	addi	sp,sp,16
80002b88:	00008067          	ret
80002b8c:	00058493          	mv	s1,a1
80002b90:	f51ff06f          	j	80002ae0 <__subsf3+0x3b4>
80002b94:	00080793          	mv	a5,a6
80002b98:	f49ff06f          	j	80002ae0 <__subsf3+0x3b4>
80002b9c:	00000793          	li	a5,0
80002ba0:	f91ff06f          	j	80002b30 <__subsf3+0x404>

80002ba4 <__fixsfsi>:
80002ba4:	00800637          	lui	a2,0x800
80002ba8:	01755713          	srli	a4,a0,0x17
80002bac:	fff60793          	addi	a5,a2,-1 # 7fffff <_stack_size+0x7ffbff>
80002bb0:	0ff77713          	andi	a4,a4,255
80002bb4:	07e00593          	li	a1,126
80002bb8:	00a7f7b3          	and	a5,a5,a0
80002bbc:	01f55693          	srli	a3,a0,0x1f
80002bc0:	04e5f663          	bleu	a4,a1,80002c0c <__fixsfsi+0x68>
80002bc4:	09d00593          	li	a1,157
80002bc8:	00e5fa63          	bleu	a4,a1,80002bdc <__fixsfsi+0x38>
80002bcc:	80000537          	lui	a0,0x80000
80002bd0:	fff54513          	not	a0,a0
80002bd4:	00a68533          	add	a0,a3,a0
80002bd8:	00008067          	ret
80002bdc:	00c7e533          	or	a0,a5,a2
80002be0:	09500793          	li	a5,149
80002be4:	00e7dc63          	ble	a4,a5,80002bfc <__fixsfsi+0x58>
80002be8:	f6a70713          	addi	a4,a4,-150
80002bec:	00e51533          	sll	a0,a0,a4
80002bf0:	02068063          	beqz	a3,80002c10 <__fixsfsi+0x6c>
80002bf4:	40a00533          	neg	a0,a0
80002bf8:	00008067          	ret
80002bfc:	09600793          	li	a5,150
80002c00:	40e78733          	sub	a4,a5,a4
80002c04:	00e55533          	srl	a0,a0,a4
80002c08:	fe9ff06f          	j	80002bf0 <__fixsfsi+0x4c>
80002c0c:	00000513          	li	a0,0
80002c10:	00008067          	ret

80002c14 <__floatsisf>:
80002c14:	ff010113          	addi	sp,sp,-16
80002c18:	00112623          	sw	ra,12(sp)
80002c1c:	00812423          	sw	s0,8(sp)
80002c20:	00912223          	sw	s1,4(sp)
80002c24:	10050263          	beqz	a0,80002d28 <__floatsisf+0x114>
80002c28:	00050413          	mv	s0,a0
80002c2c:	01f55493          	srli	s1,a0,0x1f
80002c30:	00055463          	bgez	a0,80002c38 <__floatsisf+0x24>
80002c34:	40a00433          	neg	s0,a0
80002c38:	00040513          	mv	a0,s0
80002c3c:	478000ef          	jal	ra,800030b4 <__clzsi2>
80002c40:	09e00793          	li	a5,158
80002c44:	40a787b3          	sub	a5,a5,a0
80002c48:	09600713          	li	a4,150
80002c4c:	06f74063          	blt	a4,a5,80002cac <__floatsisf+0x98>
80002c50:	00800713          	li	a4,8
80002c54:	00a75663          	ble	a0,a4,80002c60 <__floatsisf+0x4c>
80002c58:	ff850513          	addi	a0,a0,-8 # 7ffffff8 <_stack_start+0xffff96e8>
80002c5c:	00a41433          	sll	s0,s0,a0
80002c60:	00800537          	lui	a0,0x800
80002c64:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80002c68:	0ff7f793          	andi	a5,a5,255
80002c6c:	00a47433          	and	s0,s0,a0
80002c70:	01779513          	slli	a0,a5,0x17
80002c74:	808007b7          	lui	a5,0x80800
80002c78:	fff78793          	addi	a5,a5,-1 # 807fffff <_stack_start+0x7f96ef>
80002c7c:	00f47433          	and	s0,s0,a5
80002c80:	800007b7          	lui	a5,0x80000
80002c84:	00a46433          	or	s0,s0,a0
80002c88:	fff7c793          	not	a5,a5
80002c8c:	01f49513          	slli	a0,s1,0x1f
80002c90:	00f47433          	and	s0,s0,a5
80002c94:	00a46533          	or	a0,s0,a0
80002c98:	00c12083          	lw	ra,12(sp)
80002c9c:	00812403          	lw	s0,8(sp)
80002ca0:	00412483          	lw	s1,4(sp)
80002ca4:	01010113          	addi	sp,sp,16
80002ca8:	00008067          	ret
80002cac:	09900713          	li	a4,153
80002cb0:	02f75063          	ble	a5,a4,80002cd0 <__floatsisf+0xbc>
80002cb4:	00500713          	li	a4,5
80002cb8:	40a70733          	sub	a4,a4,a0
80002cbc:	01b50693          	addi	a3,a0,27
80002cc0:	00e45733          	srl	a4,s0,a4
80002cc4:	00d41433          	sll	s0,s0,a3
80002cc8:	00803433          	snez	s0,s0
80002ccc:	00876433          	or	s0,a4,s0
80002cd0:	00500713          	li	a4,5
80002cd4:	00a75663          	ble	a0,a4,80002ce0 <__floatsisf+0xcc>
80002cd8:	ffb50713          	addi	a4,a0,-5
80002cdc:	00e41433          	sll	s0,s0,a4
80002ce0:	fc000737          	lui	a4,0xfc000
80002ce4:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff96ef>
80002ce8:	00747693          	andi	a3,s0,7
80002cec:	00e47733          	and	a4,s0,a4
80002cf0:	00068a63          	beqz	a3,80002d04 <__floatsisf+0xf0>
80002cf4:	00f47413          	andi	s0,s0,15
80002cf8:	00400693          	li	a3,4
80002cfc:	00d40463          	beq	s0,a3,80002d04 <__floatsisf+0xf0>
80002d00:	00470713          	addi	a4,a4,4
80002d04:	00571693          	slli	a3,a4,0x5
80002d08:	0006dc63          	bgez	a3,80002d20 <__floatsisf+0x10c>
80002d0c:	fc0007b7          	lui	a5,0xfc000
80002d10:	fff78793          	addi	a5,a5,-1 # fbffffff <_stack_start+0x7bff96ef>
80002d14:	00f77733          	and	a4,a4,a5
80002d18:	09f00793          	li	a5,159
80002d1c:	40a787b3          	sub	a5,a5,a0
80002d20:	00375413          	srli	s0,a4,0x3
80002d24:	f3dff06f          	j	80002c60 <__floatsisf+0x4c>
80002d28:	00000413          	li	s0,0
80002d2c:	00000793          	li	a5,0
80002d30:	00000493          	li	s1,0
80002d34:	f2dff06f          	j	80002c60 <__floatsisf+0x4c>

80002d38 <__extendsfdf2>:
80002d38:	01755793          	srli	a5,a0,0x17
80002d3c:	ff010113          	addi	sp,sp,-16
80002d40:	0ff7f793          	andi	a5,a5,255
80002d44:	00812423          	sw	s0,8(sp)
80002d48:	00178713          	addi	a4,a5,1
80002d4c:	00800437          	lui	s0,0x800
80002d50:	00912223          	sw	s1,4(sp)
80002d54:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002d58:	00112623          	sw	ra,12(sp)
80002d5c:	0ff77713          	andi	a4,a4,255
80002d60:	00100693          	li	a3,1
80002d64:	00a47433          	and	s0,s0,a0
80002d68:	01f55493          	srli	s1,a0,0x1f
80002d6c:	06e6d263          	ble	a4,a3,80002dd0 <__extendsfdf2+0x98>
80002d70:	38078513          	addi	a0,a5,896
80002d74:	00345793          	srli	a5,s0,0x3
80002d78:	01d41413          	slli	s0,s0,0x1d
80002d7c:	00100737          	lui	a4,0x100
80002d80:	fff70713          	addi	a4,a4,-1 # fffff <_stack_size+0xffbff>
80002d84:	00e7f7b3          	and	a5,a5,a4
80002d88:	80100737          	lui	a4,0x80100
80002d8c:	fff70713          	addi	a4,a4,-1 # 800fffff <_stack_start+0xf96ef>
80002d90:	7ff57513          	andi	a0,a0,2047
80002d94:	01451513          	slli	a0,a0,0x14
80002d98:	00e7f7b3          	and	a5,a5,a4
80002d9c:	80000737          	lui	a4,0x80000
80002da0:	00a7e7b3          	or	a5,a5,a0
80002da4:	fff74713          	not	a4,a4
80002da8:	01f49513          	slli	a0,s1,0x1f
80002dac:	00e7f7b3          	and	a5,a5,a4
80002db0:	00a7e733          	or	a4,a5,a0
80002db4:	00c12083          	lw	ra,12(sp)
80002db8:	00040513          	mv	a0,s0
80002dbc:	00812403          	lw	s0,8(sp)
80002dc0:	00412483          	lw	s1,4(sp)
80002dc4:	00070593          	mv	a1,a4
80002dc8:	01010113          	addi	sp,sp,16
80002dcc:	00008067          	ret
80002dd0:	04079463          	bnez	a5,80002e18 <__extendsfdf2+0xe0>
80002dd4:	06040263          	beqz	s0,80002e38 <__extendsfdf2+0x100>
80002dd8:	00040513          	mv	a0,s0
80002ddc:	2d8000ef          	jal	ra,800030b4 <__clzsi2>
80002de0:	00a00793          	li	a5,10
80002de4:	02a7c263          	blt	a5,a0,80002e08 <__extendsfdf2+0xd0>
80002de8:	00b00793          	li	a5,11
80002dec:	40a787b3          	sub	a5,a5,a0
80002df0:	01550713          	addi	a4,a0,21
80002df4:	00f457b3          	srl	a5,s0,a5
80002df8:	00e41433          	sll	s0,s0,a4
80002dfc:	38900713          	li	a4,905
80002e00:	40a70533          	sub	a0,a4,a0
80002e04:	f79ff06f          	j	80002d7c <__extendsfdf2+0x44>
80002e08:	ff550793          	addi	a5,a0,-11
80002e0c:	00f417b3          	sll	a5,s0,a5
80002e10:	00000413          	li	s0,0
80002e14:	fe9ff06f          	j	80002dfc <__extendsfdf2+0xc4>
80002e18:	00000793          	li	a5,0
80002e1c:	00040a63          	beqz	s0,80002e30 <__extendsfdf2+0xf8>
80002e20:	00345793          	srli	a5,s0,0x3
80002e24:	00080737          	lui	a4,0x80
80002e28:	01d41413          	slli	s0,s0,0x1d
80002e2c:	00e7e7b3          	or	a5,a5,a4
80002e30:	7ff00513          	li	a0,2047
80002e34:	f49ff06f          	j	80002d7c <__extendsfdf2+0x44>
80002e38:	00000793          	li	a5,0
80002e3c:	00000513          	li	a0,0
80002e40:	f3dff06f          	j	80002d7c <__extendsfdf2+0x44>

80002e44 <__truncdfsf2>:
80002e44:	00100637          	lui	a2,0x100
80002e48:	fff60613          	addi	a2,a2,-1 # fffff <_stack_size+0xffbff>
80002e4c:	00b67633          	and	a2,a2,a1
80002e50:	0145d813          	srli	a6,a1,0x14
80002e54:	01d55793          	srli	a5,a0,0x1d
80002e58:	7ff87813          	andi	a6,a6,2047
80002e5c:	00361613          	slli	a2,a2,0x3
80002e60:	00c7e633          	or	a2,a5,a2
80002e64:	00180793          	addi	a5,a6,1
80002e68:	7ff7f793          	andi	a5,a5,2047
80002e6c:	00100693          	li	a3,1
80002e70:	01f5d593          	srli	a1,a1,0x1f
80002e74:	00351713          	slli	a4,a0,0x3
80002e78:	0af6d663          	ble	a5,a3,80002f24 <__truncdfsf2+0xe0>
80002e7c:	c8080693          	addi	a3,a6,-896
80002e80:	0fe00793          	li	a5,254
80002e84:	0cd7c263          	blt	a5,a3,80002f48 <__truncdfsf2+0x104>
80002e88:	08d04063          	bgtz	a3,80002f08 <__truncdfsf2+0xc4>
80002e8c:	fe900793          	li	a5,-23
80002e90:	12f6c463          	blt	a3,a5,80002fb8 <__truncdfsf2+0x174>
80002e94:	008007b7          	lui	a5,0x800
80002e98:	01e00513          	li	a0,30
80002e9c:	00f66633          	or	a2,a2,a5
80002ea0:	40d50533          	sub	a0,a0,a3
80002ea4:	01f00793          	li	a5,31
80002ea8:	02a7c863          	blt	a5,a0,80002ed8 <__truncdfsf2+0x94>
80002eac:	c8280813          	addi	a6,a6,-894
80002eb0:	010717b3          	sll	a5,a4,a6
80002eb4:	00f037b3          	snez	a5,a5
80002eb8:	01061633          	sll	a2,a2,a6
80002ebc:	00a75533          	srl	a0,a4,a0
80002ec0:	00c7e7b3          	or	a5,a5,a2
80002ec4:	00f567b3          	or	a5,a0,a5
80002ec8:	00000693          	li	a3,0
80002ecc:	0077f713          	andi	a4,a5,7
80002ed0:	08070063          	beqz	a4,80002f50 <__truncdfsf2+0x10c>
80002ed4:	0ec0006f          	j	80002fc0 <__truncdfsf2+0x17c>
80002ed8:	ffe00793          	li	a5,-2
80002edc:	40d786b3          	sub	a3,a5,a3
80002ee0:	02000793          	li	a5,32
80002ee4:	00d656b3          	srl	a3,a2,a3
80002ee8:	00000893          	li	a7,0
80002eec:	00f50663          	beq	a0,a5,80002ef8 <__truncdfsf2+0xb4>
80002ef0:	ca280813          	addi	a6,a6,-862
80002ef4:	010618b3          	sll	a7,a2,a6
80002ef8:	00e8e7b3          	or	a5,a7,a4
80002efc:	00f037b3          	snez	a5,a5
80002f00:	00f6e7b3          	or	a5,a3,a5
80002f04:	fc5ff06f          	j	80002ec8 <__truncdfsf2+0x84>
80002f08:	00651513          	slli	a0,a0,0x6
80002f0c:	00a03533          	snez	a0,a0
80002f10:	00361613          	slli	a2,a2,0x3
80002f14:	01d75793          	srli	a5,a4,0x1d
80002f18:	00c56633          	or	a2,a0,a2
80002f1c:	00f667b3          	or	a5,a2,a5
80002f20:	fadff06f          	j	80002ecc <__truncdfsf2+0x88>
80002f24:	00e667b3          	or	a5,a2,a4
80002f28:	00081663          	bnez	a6,80002f34 <__truncdfsf2+0xf0>
80002f2c:	00f037b3          	snez	a5,a5
80002f30:	f99ff06f          	j	80002ec8 <__truncdfsf2+0x84>
80002f34:	0ff00693          	li	a3,255
80002f38:	00078c63          	beqz	a5,80002f50 <__truncdfsf2+0x10c>
80002f3c:	00361613          	slli	a2,a2,0x3
80002f40:	020007b7          	lui	a5,0x2000
80002f44:	fd9ff06f          	j	80002f1c <__truncdfsf2+0xd8>
80002f48:	00000793          	li	a5,0
80002f4c:	0ff00693          	li	a3,255
80002f50:	00579713          	slli	a4,a5,0x5
80002f54:	00075e63          	bgez	a4,80002f70 <__truncdfsf2+0x12c>
80002f58:	00168693          	addi	a3,a3,1
80002f5c:	0ff00713          	li	a4,255
80002f60:	06e68a63          	beq	a3,a4,80002fd4 <__truncdfsf2+0x190>
80002f64:	fc000737          	lui	a4,0xfc000
80002f68:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff96ef>
80002f6c:	00e7f7b3          	and	a5,a5,a4
80002f70:	0ff00713          	li	a4,255
80002f74:	0037d793          	srli	a5,a5,0x3
80002f78:	00e69863          	bne	a3,a4,80002f88 <__truncdfsf2+0x144>
80002f7c:	00078663          	beqz	a5,80002f88 <__truncdfsf2+0x144>
80002f80:	004007b7          	lui	a5,0x400
80002f84:	00000593          	li	a1,0
80002f88:	00800537          	lui	a0,0x800
80002f8c:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80002f90:	00a7f7b3          	and	a5,a5,a0
80002f94:	80800537          	lui	a0,0x80800
80002f98:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f96ef>
80002f9c:	0ff6f693          	andi	a3,a3,255
80002fa0:	01769693          	slli	a3,a3,0x17
80002fa4:	00a7f7b3          	and	a5,a5,a0
80002fa8:	01f59593          	slli	a1,a1,0x1f
80002fac:	00d7e7b3          	or	a5,a5,a3
80002fb0:	00b7e533          	or	a0,a5,a1
80002fb4:	00008067          	ret
80002fb8:	00100793          	li	a5,1
80002fbc:	00000693          	li	a3,0
80002fc0:	00f7f713          	andi	a4,a5,15
80002fc4:	00400613          	li	a2,4
80002fc8:	f8c704e3          	beq	a4,a2,80002f50 <__truncdfsf2+0x10c>
80002fcc:	00478793          	addi	a5,a5,4 # 400004 <_stack_size+0x3ffc04>
80002fd0:	f81ff06f          	j	80002f50 <__truncdfsf2+0x10c>
80002fd4:	00000793          	li	a5,0
80002fd8:	f99ff06f          	j	80002f70 <__truncdfsf2+0x12c>

80002fdc <__mulsi3>:
80002fdc:	00050613          	mv	a2,a0
80002fe0:	00000513          	li	a0,0
80002fe4:	0015f693          	andi	a3,a1,1
80002fe8:	00068463          	beqz	a3,80002ff0 <__mulsi3+0x14>
80002fec:	00c50533          	add	a0,a0,a2
80002ff0:	0015d593          	srli	a1,a1,0x1
80002ff4:	00161613          	slli	a2,a2,0x1
80002ff8:	fe0596e3          	bnez	a1,80002fe4 <__mulsi3+0x8>
80002ffc:	00008067          	ret

80003000 <__divsi3>:
80003000:	06054063          	bltz	a0,80003060 <__umodsi3+0x10>
80003004:	0605c663          	bltz	a1,80003070 <__umodsi3+0x20>

80003008 <__udivsi3>:
80003008:	00058613          	mv	a2,a1
8000300c:	00050593          	mv	a1,a0
80003010:	fff00513          	li	a0,-1
80003014:	02060c63          	beqz	a2,8000304c <__udivsi3+0x44>
80003018:	00100693          	li	a3,1
8000301c:	00b67a63          	bleu	a1,a2,80003030 <__udivsi3+0x28>
80003020:	00c05863          	blez	a2,80003030 <__udivsi3+0x28>
80003024:	00161613          	slli	a2,a2,0x1
80003028:	00169693          	slli	a3,a3,0x1
8000302c:	feb66ae3          	bltu	a2,a1,80003020 <__udivsi3+0x18>
80003030:	00000513          	li	a0,0
80003034:	00c5e663          	bltu	a1,a2,80003040 <__udivsi3+0x38>
80003038:	40c585b3          	sub	a1,a1,a2
8000303c:	00d56533          	or	a0,a0,a3
80003040:	0016d693          	srli	a3,a3,0x1
80003044:	00165613          	srli	a2,a2,0x1
80003048:	fe0696e3          	bnez	a3,80003034 <__udivsi3+0x2c>
8000304c:	00008067          	ret

80003050 <__umodsi3>:
80003050:	00008293          	mv	t0,ra
80003054:	fb5ff0ef          	jal	ra,80003008 <__udivsi3>
80003058:	00058513          	mv	a0,a1
8000305c:	00028067          	jr	t0
80003060:	40a00533          	neg	a0,a0
80003064:	0005d863          	bgez	a1,80003074 <__umodsi3+0x24>
80003068:	40b005b3          	neg	a1,a1
8000306c:	f9dff06f          	j	80003008 <__udivsi3>
80003070:	40b005b3          	neg	a1,a1
80003074:	00008293          	mv	t0,ra
80003078:	f91ff0ef          	jal	ra,80003008 <__udivsi3>
8000307c:	40a00533          	neg	a0,a0
80003080:	00028067          	jr	t0

80003084 <__modsi3>:
80003084:	00008293          	mv	t0,ra
80003088:	0005ca63          	bltz	a1,8000309c <__modsi3+0x18>
8000308c:	00054c63          	bltz	a0,800030a4 <__modsi3+0x20>
80003090:	f79ff0ef          	jal	ra,80003008 <__udivsi3>
80003094:	00058513          	mv	a0,a1
80003098:	00028067          	jr	t0
8000309c:	40b005b3          	neg	a1,a1
800030a0:	fe0558e3          	bgez	a0,80003090 <__modsi3+0xc>
800030a4:	40a00533          	neg	a0,a0
800030a8:	f61ff0ef          	jal	ra,80003008 <__udivsi3>
800030ac:	40b00533          	neg	a0,a1
800030b0:	00028067          	jr	t0

800030b4 <__clzsi2>:
800030b4:	000107b7          	lui	a5,0x10
800030b8:	02f57a63          	bleu	a5,a0,800030ec <__clzsi2+0x38>
800030bc:	0ff00793          	li	a5,255
800030c0:	00a7b7b3          	sltu	a5,a5,a0
800030c4:	00379793          	slli	a5,a5,0x3
800030c8:	02000713          	li	a4,32
800030cc:	40f70733          	sub	a4,a4,a5
800030d0:	00f557b3          	srl	a5,a0,a5
800030d4:	00000517          	auipc	a0,0x0
800030d8:	70850513          	addi	a0,a0,1800 # 800037dc <__clz_tab>
800030dc:	00f507b3          	add	a5,a0,a5
800030e0:	0007c503          	lbu	a0,0(a5) # 10000 <_stack_size+0xfc00>
800030e4:	40a70533          	sub	a0,a4,a0
800030e8:	00008067          	ret
800030ec:	01000737          	lui	a4,0x1000
800030f0:	01000793          	li	a5,16
800030f4:	fce56ae3          	bltu	a0,a4,800030c8 <__clzsi2+0x14>
800030f8:	01800793          	li	a5,24
800030fc:	fcdff06f          	j	800030c8 <__clzsi2+0x14>

Disassembly of section .text.startup:

80003100 <main>:
int main() {
80003100:	ff010113          	addi	sp,sp,-16
80003104:	00112623          	sw	ra,12(sp)
	main2();
80003108:	9f0fd0ef          	jal	ra,800002f8 <main2>
}
8000310c:	00c12083          	lw	ra,12(sp)
	TEST_COM_BASE[8] = 0;
80003110:	f01007b7          	lui	a5,0xf0100
80003114:	f207a023          	sw	zero,-224(a5) # f00fff20 <_stack_start+0x700f9610>
}
80003118:	00000513          	li	a0,0
8000311c:	01010113          	addi	sp,sp,16
80003120:	00008067          	ret
