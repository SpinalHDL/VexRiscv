
build/dhrystone.elf:     file format elf32-littleriscv


Disassembly of section .vector:

80000000 <crtStart>:
.global crtStart
.global main
.global irqCallback

crtStart:
  j crtInit
80000000:	a8ad                	j	8000007a <crtInit>
  nop
80000002:	0001                	nop
  nop
80000004:	0001                	nop
  nop
80000006:	0001                	nop
  nop
80000008:	0001                	nop
  nop
8000000a:	0001                	nop
  nop
8000000c:	0001                	nop
  nop
8000000e:	0001                	nop

80000010 <trap_entry>:

.global  trap_entry
trap_entry:
  sw x1,  - 1*4(sp)
80000010:	fe112e23          	sw	ra,-4(sp)
  sw x5,  - 2*4(sp)
80000014:	fe512c23          	sw	t0,-8(sp)
  sw x6,  - 3*4(sp)
80000018:	fe612a23          	sw	t1,-12(sp)
  sw x7,  - 4*4(sp)
8000001c:	fe712823          	sw	t2,-16(sp)
  sw x10, - 5*4(sp)
80000020:	fea12623          	sw	a0,-20(sp)
  sw x11, - 6*4(sp)
80000024:	feb12423          	sw	a1,-24(sp)
  sw x12, - 7*4(sp)
80000028:	fec12223          	sw	a2,-28(sp)
  sw x13, - 8*4(sp)
8000002c:	fed12023          	sw	a3,-32(sp)
  sw x14, - 9*4(sp)
80000030:	fce12e23          	sw	a4,-36(sp)
  sw x15, -10*4(sp)
80000034:	fcf12c23          	sw	a5,-40(sp)
  sw x16, -11*4(sp)
80000038:	fd012a23          	sw	a6,-44(sp)
  sw x17, -12*4(sp)
8000003c:	fd112823          	sw	a7,-48(sp)
  sw x28, -13*4(sp)
80000040:	fdc12623          	sw	t3,-52(sp)
  sw x29, -14*4(sp)
80000044:	fdd12423          	sw	t4,-56(sp)
  sw x30, -15*4(sp)
80000048:	fde12223          	sw	t5,-60(sp)
  sw x31, -16*4(sp)
8000004c:	fdf12023          	sw	t6,-64(sp)
  addi sp,sp,-16*4
80000050:	7139                	addi	sp,sp,-64
  call irqCallback
80000052:	28ad                	jal	800000cc <irqCallback>
  lw x1 , 15*4(sp)
80000054:	50f2                	lw	ra,60(sp)
  lw x5,  14*4(sp)
80000056:	52e2                	lw	t0,56(sp)
  lw x6,  13*4(sp)
80000058:	5352                	lw	t1,52(sp)
  lw x7,  12*4(sp)
8000005a:	53c2                	lw	t2,48(sp)
  lw x10, 11*4(sp)
8000005c:	5532                	lw	a0,44(sp)
  lw x11, 10*4(sp)
8000005e:	55a2                	lw	a1,40(sp)
  lw x12,  9*4(sp)
80000060:	5612                	lw	a2,36(sp)
  lw x13,  8*4(sp)
80000062:	5682                	lw	a3,32(sp)
  lw x14,  7*4(sp)
80000064:	4772                	lw	a4,28(sp)
  lw x15,  6*4(sp)
80000066:	47e2                	lw	a5,24(sp)
  lw x16,  5*4(sp)
80000068:	4852                	lw	a6,20(sp)
  lw x17,  4*4(sp)
8000006a:	48c2                	lw	a7,16(sp)
  lw x28,  3*4(sp)
8000006c:	4e32                	lw	t3,12(sp)
  lw x29,  2*4(sp)
8000006e:	4ea2                	lw	t4,8(sp)
  lw x30,  1*4(sp)
80000070:	4f12                	lw	t5,4(sp)
  lw x31,  0*4(sp)
80000072:	4f82                	lw	t6,0(sp)
  addi sp,sp,16*4
80000074:	6121                	addi	sp,sp,64
  mret
80000076:	30200073          	mret

8000007a <crtInit>:


crtInit:
  .option push
  .option norelax
  la gp, __global_pointer$
8000007a:	00004197          	auipc	gp,0x4
8000007e:	c2618193          	addi	gp,gp,-986 # 80003ca0 <__global_pointer$>
  .option pop
  la sp, _stack_start
80000082:	00006117          	auipc	sp,0x6
80000086:	44e10113          	addi	sp,sp,1102 # 800064d0 <_stack_start>

8000008a <bss_init>:

bss_init:
  la a0, _bss_start
8000008a:	81c18513          	addi	a0,gp,-2020 # 800034bc <Dhrystones_Per_Second>
  la a1, _bss_end
8000008e:	00006597          	auipc	a1,0x6
80000092:	03658593          	addi	a1,a1,54 # 800060c4 <_bss_end>

80000096 <bss_loop>:
bss_loop:
  beq a0,a1,bss_done
80000096:	00b50663          	beq	a0,a1,800000a2 <bss_done>
  sw zero,0(a0)
8000009a:	00052023          	sw	zero,0(a0)
  add a0,a0,4
8000009e:	0511                	addi	a0,a0,4
  j bss_loop
800000a0:	bfdd                	j	80000096 <bss_loop>

800000a2 <bss_done>:
bss_done:

ctors_init:
  la a0, _ctors_start
800000a2:	00003517          	auipc	a0,0x3
800000a6:	3fa50513          	addi	a0,a0,1018 # 8000349c <_ctors_end>
  addi sp,sp,-4
800000aa:	1171                	addi	sp,sp,-4

800000ac <ctors_loop>:
ctors_loop:
  la a1, _ctors_end
800000ac:	00003597          	auipc	a1,0x3
800000b0:	3f058593          	addi	a1,a1,1008 # 8000349c <_ctors_end>
  beq a0,a1,ctors_done
800000b4:	00b50863          	beq	a0,a1,800000c4 <ctors_done>
  lw a3,0(a0)
800000b8:	4114                	lw	a3,0(a0)
  add a0,a0,4
800000ba:	0511                	addi	a0,a0,4
  sw a0,0(sp)
800000bc:	c02a                	sw	a0,0(sp)
  jalr  a3
800000be:	9682                	jalr	a3
  lw a0,0(sp)
800000c0:	4502                	lw	a0,0(sp)
  j ctors_loop
800000c2:	b7ed                	j	800000ac <ctors_loop>

800000c4 <ctors_done>:
ctors_done:
  addi sp,sp,4
800000c4:	0111                	addi	sp,sp,4
  //li a0, 0x880     //880 enable timer + external interrupts
  //csrw mie,a0
  //li a0, 0x1808     //1808 enable interrupts
  //csrw mstatus,a0

  call main
800000c6:	407020ef          	jal	ra,80002ccc <end>

800000ca <infinitLoop>:
infinitLoop:
  j infinitLoop
800000ca:	a001                	j	800000ca <infinitLoop>

Disassembly of section .memory:

800000cc <irqCallback>:
}


void irqCallback(int irq){

}
800000cc:	8082                	ret

800000ce <Proc_2>:
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
800000ce:	8351c703          	lbu	a4,-1995(gp) # 800034d5 <Ch_1_Glob>
800000d2:	04100793          	li	a5,65
800000d6:	00f70363          	beq	a4,a5,800000dc <Proc_2+0xe>
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */
800000da:	8082                	ret
      Int_Loc -= 1;
800000dc:	411c                	lw	a5,0(a0)
      *Int_Par_Ref = Int_Loc - Int_Glob;
800000de:	83c1a703          	lw	a4,-1988(gp) # 800034dc <Int_Glob>
      Int_Loc -= 1;
800000e2:	07a5                	addi	a5,a5,9
      *Int_Par_Ref = Int_Loc - Int_Glob;
800000e4:	8f99                	sub	a5,a5,a4
800000e6:	c11c                	sw	a5,0(a0)
} /* Proc_2 */
800000e8:	8082                	ret

800000ea <Proc_3>:
    /* Ptr_Ref_Par becomes Ptr_Glob */

Rec_Pointer *Ptr_Ref_Par;

{
  if (Ptr_Glob != Null)
800000ea:	8441a603          	lw	a2,-1980(gp) # 800034e4 <Ptr_Glob>
800000ee:	c609                	beqz	a2,800000f8 <Proc_3+0xe>
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
800000f0:	4218                	lw	a4,0(a2)
800000f2:	c118                	sw	a4,0(a0)
800000f4:	8441a603          	lw	a2,-1980(gp) # 800034e4 <Ptr_Glob>
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
800000f8:	83c1a583          	lw	a1,-1988(gp) # 800034dc <Int_Glob>
800000fc:	0631                	addi	a2,a2,12
800000fe:	4529                	li	a0,10
80000100:	6d80006f          	j	800007d8 <Proc_7>

80000104 <Proc_1>:
{
80000104:	1141                	addi	sp,sp,-16
80000106:	c04a                	sw	s2,0(sp)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000108:	8441a783          	lw	a5,-1980(gp) # 800034e4 <Ptr_Glob>
{
8000010c:	c422                	sw	s0,8(sp)
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
8000010e:	4100                	lw	s0,0(a0)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000110:	4398                	lw	a4,0(a5)
{
80000112:	c226                	sw	s1,4(sp)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000114:	0047ae83          	lw	t4,4(a5)
80000118:	0087ae03          	lw	t3,8(a5)
8000011c:	0107a303          	lw	t1,16(a5)
80000120:	0147a883          	lw	a7,20(a5)
80000124:	0187a803          	lw	a6,24(a5)
80000128:	538c                	lw	a1,32(a5)
8000012a:	53d0                	lw	a2,36(a5)
8000012c:	5794                	lw	a3,40(a5)
{
8000012e:	c606                	sw	ra,12(sp)
80000130:	84aa                	mv	s1,a0
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000132:	4fc8                	lw	a0,28(a5)
80000134:	57dc                	lw	a5,44(a5)
80000136:	c018                	sw	a4,0(s0)
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
80000138:	4098                	lw	a4,0(s1)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
8000013a:	cc48                	sw	a0,28(s0)
8000013c:	d45c                	sw	a5,44(s0)
8000013e:	01d42223          	sw	t4,4(s0)
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
80000142:	4795                	li	a5,5
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000144:	01c42423          	sw	t3,8(s0)
80000148:	00642823          	sw	t1,16(s0)
8000014c:	01142a23          	sw	a7,20(s0)
80000150:	01042c23          	sw	a6,24(s0)
80000154:	d00c                	sw	a1,32(s0)
80000156:	d050                	sw	a2,36(s0)
80000158:	d414                	sw	a3,40(s0)
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
8000015a:	c4dc                	sw	a5,12(s1)
        = Ptr_Val_Par->variant.var_1.Int_Comp;
8000015c:	c45c                	sw	a5,12(s0)
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
8000015e:	c018                	sw	a4,0(s0)
  Proc_3 (&Next_Record->Ptr_Comp);
80000160:	8522                	mv	a0,s0
80000162:	3761                	jal	800000ea <Proc_3>
  if (Next_Record->Discr == Ident_1)
80000164:	405c                	lw	a5,4(s0)
80000166:	cfb1                	beqz	a5,800001c2 <Proc_1+0xbe>
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
80000168:	409c                	lw	a5,0(s1)
} /* Proc_1 */
8000016a:	40b2                	lw	ra,12(sp)
8000016c:	4422                	lw	s0,8(sp)
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
8000016e:	0007af83          	lw	t6,0(a5)
80000172:	0047af03          	lw	t5,4(a5)
80000176:	0087ae83          	lw	t4,8(a5)
8000017a:	00c7ae03          	lw	t3,12(a5)
8000017e:	0107a303          	lw	t1,16(a5)
80000182:	0147a883          	lw	a7,20(a5)
80000186:	0187a803          	lw	a6,24(a5)
8000018a:	4fcc                	lw	a1,28(a5)
8000018c:	5390                	lw	a2,32(a5)
8000018e:	53d4                	lw	a3,36(a5)
80000190:	5798                	lw	a4,40(a5)
80000192:	57dc                	lw	a5,44(a5)
80000194:	01f4a023          	sw	t6,0(s1)
80000198:	01e4a223          	sw	t5,4(s1)
8000019c:	01d4a423          	sw	t4,8(s1)
800001a0:	01c4a623          	sw	t3,12(s1)
800001a4:	0064a823          	sw	t1,16(s1)
800001a8:	0114aa23          	sw	a7,20(s1)
800001ac:	0104ac23          	sw	a6,24(s1)
800001b0:	cccc                	sw	a1,28(s1)
800001b2:	d090                	sw	a2,32(s1)
800001b4:	d0d4                	sw	a3,36(s1)
800001b6:	d498                	sw	a4,40(s1)
800001b8:	d4dc                	sw	a5,44(s1)
} /* Proc_1 */
800001ba:	4902                	lw	s2,0(sp)
800001bc:	4492                	lw	s1,4(sp)
800001be:	0141                	addi	sp,sp,16
800001c0:	8082                	ret
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
800001c2:	4488                	lw	a0,8(s1)
    Next_Record->variant.var_1.Int_Comp = 6;
800001c4:	4799                	li	a5,6
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
800001c6:	00840593          	addi	a1,s0,8
    Next_Record->variant.var_1.Int_Comp = 6;
800001ca:	c45c                	sw	a5,12(s0)
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
800001cc:	6d0000ef          	jal	ra,8000089c <Proc_6>
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
800001d0:	8441a783          	lw	a5,-1980(gp) # 800034e4 <Ptr_Glob>
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
800001d4:	4448                	lw	a0,12(s0)
800001d6:	00c40613          	addi	a2,s0,12
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
800001da:	439c                	lw	a5,0(a5)
} /* Proc_1 */
800001dc:	40b2                	lw	ra,12(sp)
800001de:	4492                	lw	s1,4(sp)
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
800001e0:	c01c                	sw	a5,0(s0)
} /* Proc_1 */
800001e2:	4422                	lw	s0,8(sp)
800001e4:	4902                	lw	s2,0(sp)
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
800001e6:	45a9                	li	a1,10
} /* Proc_1 */
800001e8:	0141                	addi	sp,sp,16
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
800001ea:	5ee0006f          	j	800007d8 <Proc_7>

800001ee <Proc_4>:
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
800001ee:	8351c783          	lbu	a5,-1995(gp) # 800034d5 <Ch_1_Glob>
  Bool_Glob = Bool_Loc | Bool_Glob;
800001f2:	8381a683          	lw	a3,-1992(gp) # 800034d8 <Bool_Glob>
  Bool_Loc = Ch_1_Glob == 'A';
800001f6:	fbf78793          	addi	a5,a5,-65
800001fa:	0017b793          	seqz	a5,a5
  Bool_Glob = Bool_Loc | Bool_Glob;
800001fe:	8fd5                	or	a5,a5,a3
80000200:	82f1ac23          	sw	a5,-1992(gp) # 800034d8 <Bool_Glob>
  Ch_2_Glob = 'B';
80000204:	04200713          	li	a4,66
80000208:	82e18a23          	sb	a4,-1996(gp) # 800034d4 <Ch_2_Glob>
} /* Proc_4 */
8000020c:	8082                	ret

8000020e <Proc_5>:

Proc_5 () /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
8000020e:	04100713          	li	a4,65
80000212:	82e18aa3          	sb	a4,-1995(gp) # 800034d5 <Ch_1_Glob>
  Bool_Glob = false;
80000216:	8201ac23          	sw	zero,-1992(gp) # 800034d8 <Bool_Glob>
} /* Proc_5 */
8000021a:	8082                	ret

8000021c <main2>:
{
8000021c:	7135                	addi	sp,sp,-160
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
8000021e:	03000513          	li	a0,48
{
80000222:	cf06                	sw	ra,156(sp)
80000224:	cd22                	sw	s0,152(sp)
80000226:	dce2                	sw	s8,120(sp)
80000228:	d6ee                	sw	s11,108(sp)
8000022a:	cb26                	sw	s1,148(sp)
8000022c:	c94a                	sw	s2,144(sp)
8000022e:	c74e                	sw	s3,140(sp)
80000230:	c552                	sw	s4,136(sp)
80000232:	c356                	sw	s5,132(sp)
80000234:	c15a                	sw	s6,128(sp)
80000236:	dede                	sw	s7,124(sp)
80000238:	dae6                	sw	s9,116(sp)
8000023a:	d8ea                	sw	s10,112(sp)
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
8000023c:	74e000ef          	jal	ra,8000098a <malloc>
80000240:	84a1a023          	sw	a0,-1984(gp) # 800034e0 <Next_Ptr_Glob>
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
80000244:	03000513          	li	a0,48
80000248:	742000ef          	jal	ra,8000098a <malloc>
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
8000024c:	8401a783          	lw	a5,-1984(gp) # 800034e0 <Next_Ptr_Glob>
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
80000250:	84a1a223          	sw	a0,-1980(gp) # 800034e4 <Ptr_Glob>
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
80000254:	c11c                	sw	a5,0(a0)
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
80000256:	4789                	li	a5,2
80000258:	c51c                	sw	a5,8(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
8000025a:	800035b7          	lui	a1,0x80003
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
8000025e:	02800793          	li	a5,40
80000262:	c55c                	sw	a5,12(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
80000264:	467d                	li	a2,31
80000266:	ce458593          	addi	a1,a1,-796 # 80002ce4 <_stack_start+0xffffc814>
  Ptr_Glob->Discr                       = Ident_1;
8000026a:	00052223          	sw	zero,4(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
8000026e:	0541                	addi	a0,a0,16
80000270:	01d000ef          	jal	ra,80000a8c <memcpy>
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
80000274:	80003737          	lui	a4,0x80003
80000278:	24c70793          	addi	a5,a4,588 # 8000324c <_stack_start+0xffffcd7c>
8000027c:	24c72e03          	lw	t3,588(a4)
80000280:	0047a303          	lw	t1,4(a5)
80000284:	0087a883          	lw	a7,8(a5)
80000288:	00c7a803          	lw	a6,12(a5)
8000028c:	4b8c                	lw	a1,16(a5)
8000028e:	4bd0                	lw	a2,20(a5)
80000290:	4f94                	lw	a3,24(a5)
80000292:	01c7d703          	lhu	a4,28(a5)
80000296:	01e7c783          	lbu	a5,30(a5)
  Arr_2_Glob [8][7] = 10;
8000029a:	80003db7          	lui	s11,0x80003
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
8000029e:	02e11e23          	sh	a4,60(sp)
800002a2:	02f10f23          	sb	a5,62(sp)
  Arr_2_Glob [8][7] = 10;
800002a6:	5b4d8713          	addi	a4,s11,1460 # 800035b4 <_stack_start+0xffffd0e4>
800002aa:	47a9                	li	a5,10
  printf ("\n");
800002ac:	4529                	li	a0,10
  Arr_2_Glob [8][7] = 10;
800002ae:	64f72e23          	sw	a5,1628(a4)
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
800002b2:	d072                	sw	t3,32(sp)
800002b4:	d21a                	sw	t1,36(sp)
800002b6:	d446                	sw	a7,40(sp)
800002b8:	d642                	sw	a6,44(sp)
800002ba:	d82e                	sw	a1,48(sp)
800002bc:	da32                	sw	a2,52(sp)
800002be:	dc36                	sw	a3,56(sp)
  printf ("\n");
800002c0:	7b8000ef          	jal	ra,80000a78 <putchar>
  printf ("Dhrystone Benchmark, Version 2.1 (Language: C)\n");
800002c4:	80003537          	lui	a0,0x80003
800002c8:	d0450513          	addi	a0,a0,-764 # 80002d04 <_stack_start+0xffffc834>
800002cc:	786000ef          	jal	ra,80000a52 <puts>
  printf ("\n");
800002d0:	4529                	li	a0,10
800002d2:	7a6000ef          	jal	ra,80000a78 <putchar>
  if (Reg)
800002d6:	8301a783          	lw	a5,-2000(gp) # 800034d0 <Reg>
800002da:	4c078663          	beqz	a5,800007a6 <main2+0x58a>
    printf ("Program compiled with 'register' attribute\n");
800002de:	80003537          	lui	a0,0x80003
800002e2:	d3450513          	addi	a0,a0,-716 # 80002d34 <_stack_start+0xffffc864>
800002e6:	76c000ef          	jal	ra,80000a52 <puts>
    printf ("\n");
800002ea:	4529                	li	a0,10
800002ec:	78c000ef          	jal	ra,80000a78 <putchar>
  printf ("Please give the number of runs through the benchmark: ");
800002f0:	80003537          	lui	a0,0x80003
800002f4:	d9050513          	addi	a0,a0,-624 # 80002d90 <_stack_start+0xffffc8c0>
800002f8:	6b4000ef          	jal	ra,800009ac <printf>
  printf ("\n");
800002fc:	4529                	li	a0,10
800002fe:	77a000ef          	jal	ra,80000a78 <putchar>
  printf ("Execution starts, %d runs through Dhrystone\n", Number_Of_Runs);
80000302:	80003537          	lui	a0,0x80003
80000306:	0c800593          	li	a1,200
8000030a:	dc850513          	addi	a0,a0,-568 # 80002dc8 <_stack_start+0xffffc8f8>
8000030e:	69e000ef          	jal	ra,800009ac <printf>
  Begin_Time = clock();
80000312:	770000ef          	jal	ra,80000a82 <clock>
80000316:	80003437          	lui	s0,0x80003
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
8000031a:	26c42783          	lw	a5,620(s0) # 8000326c <_stack_start+0xffffcd9c>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
8000031e:	80003d37          	lui	s10,0x80003
80000322:	28cd2b83          	lw	s7,652(s10) # 8000328c <_stack_start+0xffffcdbc>
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000326:	c43e                	sw	a5,8(sp)
  Begin_Time = clock();
80000328:	82a1a623          	sw	a0,-2004(gp) # 800034cc <Begin_Time>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
8000032c:	4985                	li	s3,1
8000032e:	26c40413          	addi	s0,s0,620
    Int_1_Loc = 2;
80000332:	4489                	li	s1,2
    Proc_5();
80000334:	3de9                	jal	8000020e <Proc_5>
    Proc_4();
80000336:	3d65                	jal	800001ee <Proc_4>
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000338:	01e44783          	lbu	a5,30(s0)
8000033c:	4850                	lw	a2,20(s0)
8000033e:	00442e03          	lw	t3,4(s0)
80000342:	00842303          	lw	t1,8(s0)
80000346:	00c42883          	lw	a7,12(s0)
8000034a:	01042803          	lw	a6,16(s0)
8000034e:	4c14                	lw	a3,24(s0)
80000350:	01c45703          	lhu	a4,28(s0)
80000354:	4ea2                	lw	t4,8(sp)
80000356:	04f10f23          	sb	a5,94(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
8000035a:	008c                	addi	a1,sp,64
    Enum_Loc = Ident_2;
8000035c:	4785                	li	a5,1
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
8000035e:	1008                	addi	a0,sp,32
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000360:	cab2                	sw	a2,84(sp)
    Enum_Loc = Ident_2;
80000362:	ce3e                	sw	a5,28(sp)
    Int_1_Loc = 2;
80000364:	ca26                	sw	s1,20(sp)
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000366:	c0f6                	sw	t4,64(sp)
80000368:	c2f2                	sw	t3,68(sp)
8000036a:	c49a                	sw	t1,72(sp)
8000036c:	c6c6                	sw	a7,76(sp)
8000036e:	c8c2                	sw	a6,80(sp)
80000370:	ccb6                	sw	a3,88(sp)
80000372:	04e11e23          	sh	a4,92(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
80000376:	21dd                	jal	8000085c <Func_2>
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
80000378:	4652                	lw	a2,20(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
8000037a:	00153513          	seqz	a0,a0
8000037e:	82a1ac23          	sw	a0,-1992(gp) # 800034d8 <Bool_Glob>
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
80000382:	02c4c063          	blt	s1,a2,800003a2 <main2+0x186>
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
80000386:	00261793          	slli	a5,a2,0x2
8000038a:	97b2                	add	a5,a5,a2
8000038c:	17f5                	addi	a5,a5,-3
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
8000038e:	8532                	mv	a0,a2
80000390:	458d                	li	a1,3
80000392:	0830                	addi	a2,sp,24
      Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
80000394:	cc3e                	sw	a5,24(sp)
      Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
80000396:	2189                	jal	800007d8 <Proc_7>
      Int_1_Loc += 1;
80000398:	4652                	lw	a2,20(sp)
8000039a:	0605                	addi	a2,a2,1
8000039c:	ca32                	sw	a2,20(sp)
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
8000039e:	fec4d4e3          	ble	a2,s1,80000386 <main2+0x16a>
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
800003a2:	46e2                	lw	a3,24(sp)
800003a4:	84c18513          	addi	a0,gp,-1972 # 800034ec <Arr_1_Glob>
800003a8:	5b4d8593          	addi	a1,s11,1460
800003ac:	2915                	jal	800007e0 <Proc_8>
    Proc_1 (Ptr_Glob);
800003ae:	8441a503          	lw	a0,-1980(gp) # 800034e4 <Ptr_Glob>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003b2:	04100a93          	li	s5,65
    Int_2_Loc = 3;
800003b6:	4a0d                	li	s4,3
    Proc_1 (Ptr_Glob);
800003b8:	33b1                	jal	80000104 <Proc_1>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003ba:	8341c703          	lbu	a4,-1996(gp) # 800034d4 <Ch_2_Glob>
800003be:	04000793          	li	a5,64
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
800003c2:	28cd0c93          	addi	s9,s10,652
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003c6:	02e7f163          	bleu	a4,a5,800003e8 <main2+0x1cc>
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
800003ca:	8556                	mv	a0,s5
800003cc:	04300593          	li	a1,67
800003d0:	2995                	jal	80000844 <Func_1>
800003d2:	47f2                	lw	a5,28(sp)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003d4:	001a8713          	addi	a4,s5,1
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
800003d8:	36f50e63          	beq	a0,a5,80000754 <main2+0x538>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003dc:	8341c783          	lbu	a5,-1996(gp) # 800034d4 <Ch_2_Glob>
800003e0:	0ff77a93          	andi	s5,a4,255
800003e4:	ff57f3e3          	bleu	s5,a5,800003ca <main2+0x1ae>
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
800003e8:	45d2                	lw	a1,20(sp)
800003ea:	8552                	mv	a0,s4
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
800003ec:	0985                	addi	s3,s3,1
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
800003ee:	7ba020ef          	jal	ra,80002ba8 <__mulsi3>
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
800003f2:	4ae2                	lw	s5,24(sp)
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
800003f4:	c62a                	sw	a0,12(sp)
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
800003f6:	85d6                	mv	a1,s5
800003f8:	7d4020ef          	jal	ra,80002bcc <__divsi3>
800003fc:	8a2a                	mv	s4,a0
    Proc_2 (&Int_1_Loc);
800003fe:	0848                	addi	a0,sp,20
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
80000400:	ca52                	sw	s4,20(sp)
    Proc_2 (&Int_1_Loc);
80000402:	31f1                	jal	800000ce <Proc_2>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
80000404:	0c900793          	li	a5,201
80000408:	f2f996e3          	bne	s3,a5,80000334 <main2+0x118>
  End_Time = clock();
8000040c:	676000ef          	jal	ra,80000a82 <clock>
80000410:	82a1a423          	sw	a0,-2008(gp) # 800034c8 <End_Time>
  printf ("Execution ends\n");
80000414:	80003537          	lui	a0,0x80003
80000418:	df850513          	addi	a0,a0,-520 # 80002df8 <_stack_start+0xffffc928>
8000041c:	636000ef          	jal	ra,80000a52 <puts>
  printf ("\n");
80000420:	4529                	li	a0,10
80000422:	656000ef          	jal	ra,80000a78 <putchar>
  printf ("Final values of the variables used in the benchmark:\n");
80000426:	80003537          	lui	a0,0x80003
8000042a:	e0850513          	addi	a0,a0,-504 # 80002e08 <_stack_start+0xffffc938>
8000042e:	624000ef          	jal	ra,80000a52 <puts>
  printf ("\n");
80000432:	4529                	li	a0,10
80000434:	644000ef          	jal	ra,80000a78 <putchar>
  printf ("Int_Glob:            %d\n", Int_Glob);
80000438:	83c1a583          	lw	a1,-1988(gp) # 800034dc <Int_Glob>
8000043c:	80003537          	lui	a0,0x80003
80000440:	e4050513          	addi	a0,a0,-448 # 80002e40 <_stack_start+0xffffc970>
  printf ("        should be:   %d\n", 5);
80000444:	80003437          	lui	s0,0x80003
  printf ("Int_Glob:            %d\n", Int_Glob);
80000448:	564000ef          	jal	ra,800009ac <printf>
  printf ("        should be:   %d\n", 5);
8000044c:	4595                	li	a1,5
8000044e:	e5c40513          	addi	a0,s0,-420 # 80002e5c <_stack_start+0xffffc98c>
80000452:	55a000ef          	jal	ra,800009ac <printf>
  printf ("Bool_Glob:           %d\n", Bool_Glob);
80000456:	8381a583          	lw	a1,-1992(gp) # 800034d8 <Bool_Glob>
8000045a:	80003537          	lui	a0,0x80003
8000045e:	e7850513          	addi	a0,a0,-392 # 80002e78 <_stack_start+0xffffc9a8>
80000462:	54a000ef          	jal	ra,800009ac <printf>
  printf ("        should be:   %d\n", 1);
80000466:	4585                	li	a1,1
80000468:	e5c40513          	addi	a0,s0,-420
8000046c:	540000ef          	jal	ra,800009ac <printf>
  printf ("Ch_1_Glob:           %c\n", Ch_1_Glob);
80000470:	8351c583          	lbu	a1,-1995(gp) # 800034d5 <Ch_1_Glob>
80000474:	80003537          	lui	a0,0x80003
80000478:	e9450513          	addi	a0,a0,-364 # 80002e94 <_stack_start+0xffffc9c4>
8000047c:	2b05                	jal	800009ac <printf>
  printf ("        should be:   %c\n", 'A');
8000047e:	800034b7          	lui	s1,0x80003
80000482:	04100593          	li	a1,65
80000486:	eb048513          	addi	a0,s1,-336 # 80002eb0 <_stack_start+0xffffc9e0>
8000048a:	230d                	jal	800009ac <printf>
  printf ("Ch_2_Glob:           %c\n", Ch_2_Glob);
8000048c:	8341c583          	lbu	a1,-1996(gp) # 800034d4 <Ch_2_Glob>
80000490:	80003537          	lui	a0,0x80003
80000494:	ecc50513          	addi	a0,a0,-308 # 80002ecc <_stack_start+0xffffc9fc>
80000498:	2b11                	jal	800009ac <printf>
  printf ("        should be:   %c\n", 'B');
8000049a:	04200593          	li	a1,66
8000049e:	eb048513          	addi	a0,s1,-336
800004a2:	2329                	jal	800009ac <printf>
  printf ("Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
800004a4:	84c18793          	addi	a5,gp,-1972 # 800034ec <Arr_1_Glob>
800004a8:	538c                	lw	a1,32(a5)
800004aa:	80003537          	lui	a0,0x80003
800004ae:	ee850513          	addi	a0,a0,-280 # 80002ee8 <_stack_start+0xffffca18>
800004b2:	29ed                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 7);
800004b4:	459d                	li	a1,7
800004b6:	e5c40513          	addi	a0,s0,-420
800004ba:	29cd                	jal	800009ac <printf>
  printf ("Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
800004bc:	800037b7          	lui	a5,0x80003
800004c0:	5b478793          	addi	a5,a5,1460 # 800035b4 <_stack_start+0xffffd0e4>
800004c4:	65c7a583          	lw	a1,1628(a5)
800004c8:	80003537          	lui	a0,0x80003
800004cc:	f0450513          	addi	a0,a0,-252 # 80002f04 <_stack_start+0xffffca34>
800004d0:	29f1                	jal	800009ac <printf>
  printf ("        should be:   Number_Of_Runs + 10\n");
800004d2:	80003537          	lui	a0,0x80003
800004d6:	f2050513          	addi	a0,a0,-224 # 80002f20 <_stack_start+0xffffca50>
800004da:	578000ef          	jal	ra,80000a52 <puts>
  printf ("Ptr_Glob->\n");
800004de:	80003537          	lui	a0,0x80003
800004e2:	f4c50513          	addi	a0,a0,-180 # 80002f4c <_stack_start+0xffffca7c>
800004e6:	56c000ef          	jal	ra,80000a52 <puts>
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
800004ea:	8441a783          	lw	a5,-1980(gp) # 800034e4 <Ptr_Glob>
800004ee:	80003db7          	lui	s11,0x80003
800004f2:	f58d8513          	addi	a0,s11,-168 # 80002f58 <_stack_start+0xffffca88>
800004f6:	438c                	lw	a1,0(a5)
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
800004f8:	80003cb7          	lui	s9,0x80003
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
800004fc:	80003bb7          	lui	s7,0x80003
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
80000500:	2175                	jal	800009ac <printf>
  printf ("        should be:   (implementation-dependent)\n");
80000502:	80003537          	lui	a0,0x80003
80000506:	f7450513          	addi	a0,a0,-140 # 80002f74 <_stack_start+0xffffcaa4>
8000050a:	548000ef          	jal	ra,80000a52 <puts>
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
8000050e:	8441a783          	lw	a5,-1980(gp) # 800034e4 <Ptr_Glob>
80000512:	fa4c8513          	addi	a0,s9,-92 # 80002fa4 <_stack_start+0xffffcad4>
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
80000516:	80003b37          	lui	s6,0x80003
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
8000051a:	43cc                	lw	a1,4(a5)
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
8000051c:	800039b7          	lui	s3,0x80003
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
80000520:	80003937          	lui	s2,0x80003
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
80000524:	2161                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 0);
80000526:	4581                	li	a1,0
80000528:	e5c40513          	addi	a0,s0,-420
8000052c:	2141                	jal	800009ac <printf>
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
8000052e:	8441a783          	lw	a5,-1980(gp) # 800034e4 <Ptr_Glob>
80000532:	fc0b8513          	addi	a0,s7,-64 # 80002fc0 <_stack_start+0xffffcaf0>
80000536:	478c                	lw	a1,8(a5)
80000538:	2995                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 2);
8000053a:	4589                	li	a1,2
8000053c:	e5c40513          	addi	a0,s0,-420
80000540:	21b5                	jal	800009ac <printf>
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
80000542:	8441a783          	lw	a5,-1980(gp) # 800034e4 <Ptr_Glob>
80000546:	fdcb0513          	addi	a0,s6,-36 # 80002fdc <_stack_start+0xffffcb0c>
8000054a:	47cc                	lw	a1,12(a5)
8000054c:	2185                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 17);
8000054e:	45c5                	li	a1,17
80000550:	e5c40513          	addi	a0,s0,-420
80000554:	29a1                	jal	800009ac <printf>
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
80000556:	8441a583          	lw	a1,-1980(gp) # 800034e4 <Ptr_Glob>
8000055a:	ff898513          	addi	a0,s3,-8 # 80002ff8 <_stack_start+0xffffcb28>
8000055e:	05c1                	addi	a1,a1,16
80000560:	21b1                	jal	800009ac <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
80000562:	01490513          	addi	a0,s2,20 # 80003014 <_stack_start+0xffffcb44>
80000566:	21f5                	jal	80000a52 <puts>
  printf ("Next_Ptr_Glob->\n");
80000568:	80003537          	lui	a0,0x80003
8000056c:	04850513          	addi	a0,a0,72 # 80003048 <_stack_start+0xffffcb78>
80000570:	21cd                	jal	80000a52 <puts>
  printf ("  Ptr_Comp:          %d\n", (int) Next_Ptr_Glob->Ptr_Comp);
80000572:	8401a783          	lw	a5,-1984(gp) # 800034e0 <Next_Ptr_Glob>
80000576:	f58d8513          	addi	a0,s11,-168
8000057a:	438c                	lw	a1,0(a5)
8000057c:	2905                	jal	800009ac <printf>
  printf ("        should be:   (implementation-dependent), same as above\n");
8000057e:	80003537          	lui	a0,0x80003
80000582:	05850513          	addi	a0,a0,88 # 80003058 <_stack_start+0xffffcb88>
80000586:	21f1                	jal	80000a52 <puts>
  printf ("  Discr:             %d\n", Next_Ptr_Glob->Discr);
80000588:	8401a783          	lw	a5,-1984(gp) # 800034e0 <Next_Ptr_Glob>
8000058c:	fa4c8513          	addi	a0,s9,-92
80000590:	43cc                	lw	a1,4(a5)
80000592:	2929                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 0);
80000594:	4581                	li	a1,0
80000596:	e5c40513          	addi	a0,s0,-420
8000059a:	2909                	jal	800009ac <printf>
  printf ("  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
8000059c:	8401a783          	lw	a5,-1984(gp) # 800034e0 <Next_Ptr_Glob>
800005a0:	fc0b8513          	addi	a0,s7,-64
800005a4:	478c                	lw	a1,8(a5)
800005a6:	2119                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 1);
800005a8:	4585                	li	a1,1
800005aa:	e5c40513          	addi	a0,s0,-420
800005ae:	2efd                	jal	800009ac <printf>
  printf ("  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
800005b0:	8401a783          	lw	a5,-1984(gp) # 800034e0 <Next_Ptr_Glob>
800005b4:	fdcb0513          	addi	a0,s6,-36
800005b8:	47cc                	lw	a1,12(a5)
800005ba:	2ecd                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 18);
800005bc:	45c9                	li	a1,18
800005be:	e5c40513          	addi	a0,s0,-420
800005c2:	26ed                	jal	800009ac <printf>
  printf ("  Str_Comp:          %s\n",
800005c4:	8401a583          	lw	a1,-1984(gp) # 800034e0 <Next_Ptr_Glob>
800005c8:	ff898513          	addi	a0,s3,-8
800005cc:	05c1                	addi	a1,a1,16
800005ce:	2ef9                	jal	800009ac <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
800005d0:	01490513          	addi	a0,s2,20
800005d4:	29bd                	jal	80000a52 <puts>
  printf ("Int_1_Loc:           %d\n", Int_1_Loc);
800005d6:	45d2                	lw	a1,20(sp)
800005d8:	80003537          	lui	a0,0x80003
800005dc:	09850513          	addi	a0,a0,152 # 80003098 <_stack_start+0xffffcbc8>
800005e0:	26f1                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 5);
800005e2:	4595                	li	a1,5
800005e4:	e5c40513          	addi	a0,s0,-420
800005e8:	26d1                	jal	800009ac <printf>
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
800005ea:	47b2                	lw	a5,12(sp)
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
800005ec:	80003537          	lui	a0,0x80003
800005f0:	0b450513          	addi	a0,a0,180 # 800030b4 <_stack_start+0xffffcbe4>
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
800005f4:	41578ab3          	sub	s5,a5,s5
800005f8:	003a9793          	slli	a5,s5,0x3
800005fc:	41578ab3          	sub	s5,a5,s5
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
80000600:	414a85b3          	sub	a1,s5,s4
80000604:	2665                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 13);
80000606:	45b5                	li	a1,13
80000608:	e5c40513          	addi	a0,s0,-420
8000060c:	2645                	jal	800009ac <printf>
  printf ("Int_3_Loc:           %d\n", Int_3_Loc);
8000060e:	45e2                	lw	a1,24(sp)
80000610:	80003537          	lui	a0,0x80003
80000614:	0d050513          	addi	a0,a0,208 # 800030d0 <_stack_start+0xffffcc00>
80000618:	2e51                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 7);
8000061a:	459d                	li	a1,7
8000061c:	e5c40513          	addi	a0,s0,-420
80000620:	2671                	jal	800009ac <printf>
  printf ("Enum_Loc:            %d\n", Enum_Loc);
80000622:	45f2                	lw	a1,28(sp)
80000624:	80003537          	lui	a0,0x80003
80000628:	0ec50513          	addi	a0,a0,236 # 800030ec <_stack_start+0xffffcc1c>
8000062c:	2641                	jal	800009ac <printf>
  printf ("        should be:   %d\n", 1);
8000062e:	4585                	li	a1,1
80000630:	e5c40513          	addi	a0,s0,-420
80000634:	2ea5                	jal	800009ac <printf>
  printf ("Str_1_Loc:           %s\n", Str_1_Loc);
80000636:	80003537          	lui	a0,0x80003
8000063a:	100c                	addi	a1,sp,32
8000063c:	10850513          	addi	a0,a0,264 # 80003108 <_stack_start+0xffffcc38>
80000640:	26b5                	jal	800009ac <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
80000642:	80003537          	lui	a0,0x80003
80000646:	12450513          	addi	a0,a0,292 # 80003124 <_stack_start+0xffffcc54>
8000064a:	2121                	jal	80000a52 <puts>
  printf ("Str_2_Loc:           %s\n", Str_2_Loc);
8000064c:	80003537          	lui	a0,0x80003
80000650:	008c                	addi	a1,sp,64
80000652:	15850513          	addi	a0,a0,344 # 80003158 <_stack_start+0xffffcc88>
80000656:	2e99                	jal	800009ac <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
80000658:	80003537          	lui	a0,0x80003
8000065c:	17450513          	addi	a0,a0,372 # 80003174 <_stack_start+0xffffcca4>
80000660:	2ecd                	jal	80000a52 <puts>
  printf ("\n");
80000662:	4529                	li	a0,10
80000664:	2911                	jal	80000a78 <putchar>
  User_Time = End_Time - Begin_Time;
80000666:	82c1a703          	lw	a4,-2004(gp) # 800034cc <Begin_Time>
8000066a:	8281a583          	lw	a1,-2008(gp) # 800034c8 <End_Time>
  if (User_Time < Too_Small_Time)
8000066e:	1f300793          	li	a5,499
  User_Time = End_Time - Begin_Time;
80000672:	8d99                	sub	a1,a1,a4
80000674:	82b1a223          	sw	a1,-2012(gp) # 800034c4 <User_Time>
  if (User_Time < Too_Small_Time)
80000678:	12b7df63          	ble	a1,a5,800007b6 <main2+0x59a>
    printf ("Clock cycles=%d \n", User_Time);
8000067c:	80003537          	lui	a0,0x80003
80000680:	20050513          	addi	a0,a0,512 # 80003200 <_stack_start+0xffffcd30>
80000684:	2625                	jal	800009ac <printf>
    Microseconds = (float) User_Time * Mic_secs_Per_Second 
80000686:	8241a503          	lw	a0,-2012(gp) # 800034c4 <User_Time>
8000068a:	156020ef          	jal	ra,800027e0 <__floatsisf>
8000068e:	842a                	mv	s0,a0
80000690:	274020ef          	jal	ra,80002904 <__extendsfdf2>
80000694:	800037b7          	lui	a5,0x80003
80000698:	4a07a603          	lw	a2,1184(a5) # 800034a0 <_stack_start+0xffffcfd0>
8000069c:	4a47a683          	lw	a3,1188(a5)
800006a0:	661000ef          	jal	ra,80001500 <__muldf3>
                        / ((float) CORE_HZ * ((float) Number_Of_Runs));
800006a4:	800037b7          	lui	a5,0x80003
800006a8:	4a87a603          	lw	a2,1192(a5) # 800034a8 <_stack_start+0xffffcfd8>
800006ac:	4ac7a683          	lw	a3,1196(a5)
800006b0:	640000ef          	jal	ra,80000cf0 <__divdf3>
800006b4:	35c020ef          	jal	ra,80002a10 <__truncdfsf2>
800006b8:	82a1a023          	sw	a0,-2016(gp) # 800034c0 <Microseconds>
                        / (float) User_Time;
800006bc:	800037b7          	lui	a5,0x80003
800006c0:	4b07a503          	lw	a0,1200(a5) # 800034b0 <_stack_start+0xffffcfe0>
800006c4:	85a2                	mv	a1,s0
800006c6:	52a010ef          	jal	ra,80001bf0 <__divsf3>
    Dhrystones_Per_Second = ((float) CORE_HZ * (float) Number_Of_Runs)
800006ca:	80a1ae23          	sw	a0,-2020(gp) # 800034bc <Dhrystones_Per_Second>
    printf ("DMIPS per Mhz:                              ");
800006ce:	80003537          	lui	a0,0x80003
800006d2:	21450513          	addi	a0,a0,532 # 80003214 <_stack_start+0xffffcd44>
800006d6:	2cd9                	jal	800009ac <printf>
    float dmips = (1e6f/1757.0f) * Number_Of_Runs / User_Time;
800006d8:	8241a503          	lw	a0,-2012(gp) # 800034c4 <User_Time>
800006dc:	104020ef          	jal	ra,800027e0 <__floatsisf>
800006e0:	800037b7          	lui	a5,0x80003
800006e4:	85aa                	mv	a1,a0
800006e6:	4b47a503          	lw	a0,1204(a5) # 800034b4 <_stack_start+0xffffcfe4>
800006ea:	506010ef          	jal	ra,80001bf0 <__divsf3>
800006ee:	842a                	mv	s0,a0
    int dmipsNatural = dmips;
800006f0:	080020ef          	jal	ra,80002770 <__fixsfsi>
800006f4:	84aa                	mv	s1,a0
    int dmipsReal = (dmips - dmipsNatural)*100.0f;
800006f6:	0ea020ef          	jal	ra,800027e0 <__floatsisf>
800006fa:	85aa                	mv	a1,a0
800006fc:	8522                	mv	a0,s0
800006fe:	3fb010ef          	jal	ra,800022f8 <__subsf3>
80000702:	800037b7          	lui	a5,0x80003
80000706:	4b87a583          	lw	a1,1208(a5) # 800034b8 <_stack_start+0xffffcfe8>
8000070a:	07f010ef          	jal	ra,80001f88 <__mulsf3>
8000070e:	062020ef          	jal	ra,80002770 <__fixsfsi>
80000712:	842a                	mv	s0,a0
    printf ("%d.", dmipsNatural);
80000714:	80003537          	lui	a0,0x80003
80000718:	85a6                	mv	a1,s1
8000071a:	24450513          	addi	a0,a0,580 # 80003244 <_stack_start+0xffffcd74>
8000071e:	2479                	jal	800009ac <printf>
    if(dmipsReal < 10) printf("0");
80000720:	47a5                	li	a5,9
80000722:	0a87d763          	ble	s0,a5,800007d0 <main2+0x5b4>
    printf ("%d", dmipsReal);
80000726:	80003537          	lui	a0,0x80003
8000072a:	85a2                	mv	a1,s0
8000072c:	24850513          	addi	a0,a0,584 # 80003248 <_stack_start+0xffffcd78>
80000730:	2cb5                	jal	800009ac <printf>
    printf ("\n");
80000732:	4529                	li	a0,10
80000734:	2691                	jal	80000a78 <putchar>
}
80000736:	40fa                	lw	ra,156(sp)
80000738:	446a                	lw	s0,152(sp)
8000073a:	44da                	lw	s1,148(sp)
8000073c:	494a                	lw	s2,144(sp)
8000073e:	49ba                	lw	s3,140(sp)
80000740:	4a2a                	lw	s4,136(sp)
80000742:	4a9a                	lw	s5,132(sp)
80000744:	4b0a                	lw	s6,128(sp)
80000746:	5bf6                	lw	s7,124(sp)
80000748:	5c66                	lw	s8,120(sp)
8000074a:	5cd6                	lw	s9,116(sp)
8000074c:	5d46                	lw	s10,112(sp)
8000074e:	5db6                	lw	s11,108(sp)
80000750:	610d                	addi	sp,sp,160
80000752:	8082                	ret
        Proc_6 (Ident_1, &Enum_Loc);
80000754:	086c                	addi	a1,sp,28
80000756:	4501                	li	a0,0
80000758:	2291                	jal	8000089c <Proc_6>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
8000075a:	004cae03          	lw	t3,4(s9)
8000075e:	008ca303          	lw	t1,8(s9)
80000762:	00cca883          	lw	a7,12(s9)
80000766:	010ca803          	lw	a6,16(s9)
8000076a:	014ca503          	lw	a0,20(s9)
8000076e:	018ca583          	lw	a1,24(s9)
80000772:	01ccd603          	lhu	a2,28(s9)
80000776:	01ecc703          	lbu	a4,30(s9)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
8000077a:	8341c783          	lbu	a5,-1996(gp) # 800034d4 <Ch_2_Glob>
8000077e:	0a85                	addi	s5,s5,1
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
80000780:	c0de                	sw	s7,64(sp)
80000782:	c2f2                	sw	t3,68(sp)
80000784:	c49a                	sw	t1,72(sp)
80000786:	c6c6                	sw	a7,76(sp)
80000788:	c8c2                	sw	a6,80(sp)
8000078a:	caaa                	sw	a0,84(sp)
8000078c:	ccae                	sw	a1,88(sp)
8000078e:	04c11e23          	sh	a2,92(sp)
80000792:	04e10f23          	sb	a4,94(sp)
        Int_Glob = Run_Index;
80000796:	8331ae23          	sw	s3,-1988(gp) # 800034dc <Int_Glob>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
8000079a:	0ffafa93          	andi	s5,s5,255
8000079e:	8a4e                	mv	s4,s3
800007a0:	c357f5e3          	bleu	s5,a5,800003ca <main2+0x1ae>
800007a4:	b191                	j	800003e8 <main2+0x1cc>
    printf ("Program compiled without 'register' attribute\n");
800007a6:	80003537          	lui	a0,0x80003
800007aa:	d6050513          	addi	a0,a0,-672 # 80002d60 <_stack_start+0xffffc890>
800007ae:	2455                	jal	80000a52 <puts>
    printf ("\n");
800007b0:	4529                	li	a0,10
800007b2:	24d9                	jal	80000a78 <putchar>
800007b4:	be35                	j	800002f0 <main2+0xd4>
    printf ("Measured time too small to obtain meaningful results\n");
800007b6:	80003537          	lui	a0,0x80003
800007ba:	1a850513          	addi	a0,a0,424 # 800031a8 <_stack_start+0xffffccd8>
800007be:	2c51                	jal	80000a52 <puts>
    printf ("Please increase number of runs\n");
800007c0:	80003537          	lui	a0,0x80003
800007c4:	1e050513          	addi	a0,a0,480 # 800031e0 <_stack_start+0xffffcd10>
800007c8:	2469                	jal	80000a52 <puts>
    printf ("\n");
800007ca:	4529                	li	a0,10
800007cc:	2475                	jal	80000a78 <putchar>
800007ce:	b7a5                	j	80000736 <main2+0x51a>
    if(dmipsReal < 10) printf("0");
800007d0:	03000513          	li	a0,48
800007d4:	2455                	jal	80000a78 <putchar>
800007d6:	bf81                	j	80000726 <main2+0x50a>

800007d8 <Proc_7>:
One_Fifty       Int_2_Par_Val;
One_Fifty      *Int_Par_Ref;
{
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 2;
800007d8:	0509                	addi	a0,a0,2
  *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
800007da:	95aa                	add	a1,a1,a0
800007dc:	c20c                	sw	a1,0(a2)
} /* Proc_7 */
800007de:	8082                	ret

800007e0 <Proc_8>:
    /* Int_Par_Val_2 == 7 */
Arr_1_Dim       Arr_1_Par_Ref;
Arr_2_Dim       Arr_2_Par_Ref;
int             Int_1_Par_Val;
int             Int_2_Par_Val;
{
800007e0:	1101                	addi	sp,sp,-32
800007e2:	c64e                	sw	s3,12(sp)
  REG One_Fifty Int_Index;
  REG One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 5;
800007e4:	00560993          	addi	s3,a2,5
{
800007e8:	ca26                	sw	s1,20(sp)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
800007ea:	00299493          	slli	s1,s3,0x2
{
800007ee:	cc22                	sw	s0,24(sp)
800007f0:	c84a                	sw	s2,16(sp)
800007f2:	ce06                	sw	ra,28(sp)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
800007f4:	94aa                	add	s1,s1,a0
{
800007f6:	8932                	mv	s2,a2
800007f8:	842e                	mv	s0,a1
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
800007fa:	0734ac23          	sw	s3,120(s1)
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
800007fe:	c094                	sw	a3,0(s1)
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
80000800:	c0d4                	sw	a3,4(s1)
  for (Int_Index = Int_Loc; Int_Index <= Int_Loc+1; ++Int_Index)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
80000802:	854e                	mv	a0,s3
80000804:	0c800593          	li	a1,200
80000808:	3a0020ef          	jal	ra,80002ba8 <__mulsi3>
8000080c:	090a                	slli	s2,s2,0x2
8000080e:	012507b3          	add	a5,a0,s2
80000812:	97a2                	add	a5,a5,s0
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
80000814:	4b98                	lw	a4,16(a5)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
80000816:	0137aa23          	sw	s3,20(a5)
8000081a:	0137ac23          	sw	s3,24(a5)
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
8000081e:	0705                	addi	a4,a4,1
80000820:	cb98                	sw	a4,16(a5)
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
80000822:	409c                	lw	a5,0(s1)
80000824:	942a                	add	s0,s0,a0
80000826:	944a                	add	s0,s0,s2
80000828:	6605                	lui	a2,0x1
8000082a:	9432                	add	s0,s0,a2
8000082c:	faf42a23          	sw	a5,-76(s0)
  Int_Glob = 5;
} /* Proc_8 */
80000830:	40f2                	lw	ra,28(sp)
80000832:	4462                	lw	s0,24(sp)
  Int_Glob = 5;
80000834:	4715                	li	a4,5
80000836:	82e1ae23          	sw	a4,-1988(gp) # 800034dc <Int_Glob>
} /* Proc_8 */
8000083a:	44d2                	lw	s1,20(sp)
8000083c:	4942                	lw	s2,16(sp)
8000083e:	49b2                	lw	s3,12(sp)
80000840:	6105                	addi	sp,sp,32
80000842:	8082                	ret

80000844 <Func_1>:
    /* second call:     Ch_1_Par_Val == 'A', Ch_2_Par_Val == 'C'    */
    /* third call:      Ch_1_Par_Val == 'B', Ch_2_Par_Val == 'C'    */

Capital_Letter   Ch_1_Par_Val;
Capital_Letter   Ch_2_Par_Val;
{
80000844:	0ff57513          	andi	a0,a0,255
80000848:	0ff5f593          	andi	a1,a1,255
  Capital_Letter        Ch_1_Loc;
  Capital_Letter        Ch_2_Loc;

  Ch_1_Loc = Ch_1_Par_Val;
  Ch_2_Loc = Ch_1_Loc;
  if (Ch_2_Loc != Ch_2_Par_Val)
8000084c:	00b50463          	beq	a0,a1,80000854 <Func_1+0x10>
    /* then, executed */
    return (Ident_1);
80000850:	4501                	li	a0,0
  else  /* not executed */
  {
    Ch_1_Glob = Ch_1_Loc;
    return (Ident_2);
   }
} /* Func_1 */
80000852:	8082                	ret
    Ch_1_Glob = Ch_1_Loc;
80000854:	82a18aa3          	sb	a0,-1995(gp) # 800034d5 <Ch_1_Glob>
    return (Ident_2);
80000858:	4505                	li	a0,1
8000085a:	8082                	ret

8000085c <Func_2>:
    /* Str_1_Par_Ref == "DHRYSTONE PROGRAM, 1'ST STRING" */
    /* Str_2_Par_Ref == "DHRYSTONE PROGRAM, 2'ND STRING" */

Str_30  Str_1_Par_Ref;
Str_30  Str_2_Par_Ref;
{
8000085c:	1141                	addi	sp,sp,-16
8000085e:	c422                	sw	s0,8(sp)
80000860:	c226                	sw	s1,4(sp)
80000862:	c606                	sw	ra,12(sp)
80000864:	842a                	mv	s0,a0
80000866:	84ae                	mv	s1,a1
  REG One_Thirty        Int_Loc;
      Capital_Letter    Ch_Loc;

  Int_Loc = 2;
  while (Int_Loc <= 2) /* loop body executed once */
    if (Func_1 (Str_1_Par_Ref[Int_Loc],
80000868:	0034c583          	lbu	a1,3(s1)
8000086c:	00244503          	lbu	a0,2(s0)
80000870:	3fd1                	jal	80000844 <Func_1>
80000872:	f97d                	bnez	a0,80000868 <Func_2+0xc>
  if (Ch_Loc == 'R')
    /* then, not executed */
    return (true);
  else /* executed */
  {
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
80000874:	85a6                	mv	a1,s1
80000876:	8522                	mv	a0,s0
80000878:	2cf5                	jal	80000b74 <strcmp>
      Int_Loc += 7;
      Int_Glob = Int_Loc;
      return (true);
    }
    else /* executed */
      return (false);
8000087a:	4781                	li	a5,0
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
8000087c:	00a05663          	blez	a0,80000888 <Func_2+0x2c>
      Int_Glob = Int_Loc;
80000880:	4729                	li	a4,10
80000882:	82e1ae23          	sw	a4,-1988(gp) # 800034dc <Int_Glob>
      return (true);
80000886:	4785                	li	a5,1
  } /* if Ch_Loc */
} /* Func_2 */
80000888:	40b2                	lw	ra,12(sp)
8000088a:	4422                	lw	s0,8(sp)
8000088c:	4492                	lw	s1,4(sp)
8000088e:	853e                	mv	a0,a5
80000890:	0141                	addi	sp,sp,16
80000892:	8082                	ret

80000894 <Func_3>:
Enumeration Enum_Par_Val;
{
  Enumeration Enum_Loc;

  Enum_Loc = Enum_Par_Val;
  if (Enum_Loc == Ident_3)
80000894:	1579                	addi	a0,a0,-2
    /* then, executed */
    return (true);
  else /* not executed */
    return (false);
} /* Func_3 */
80000896:	00153513          	seqz	a0,a0
8000089a:	8082                	ret

8000089c <Proc_6>:
{
8000089c:	1141                	addi	sp,sp,-16
8000089e:	c422                	sw	s0,8(sp)
800008a0:	c226                	sw	s1,4(sp)
800008a2:	c606                	sw	ra,12(sp)
800008a4:	842a                	mv	s0,a0
800008a6:	84ae                	mv	s1,a1
  if (! Func_3 (Enum_Val_Par))
800008a8:	37f5                	jal	80000894 <Func_3>
800008aa:	c115                	beqz	a0,800008ce <Proc_6+0x32>
  *Enum_Ref_Par = Enum_Val_Par;
800008ac:	c080                	sw	s0,0(s1)
  switch (Enum_Val_Par)
800008ae:	4785                	li	a5,1
800008b0:	02f40463          	beq	s0,a5,800008d8 <Proc_6+0x3c>
800008b4:	c805                	beqz	s0,800008e4 <Proc_6+0x48>
800008b6:	4709                	li	a4,2
800008b8:	02e40d63          	beq	s0,a4,800008f2 <Proc_6+0x56>
800008bc:	4791                	li	a5,4
800008be:	00f41363          	bne	s0,a5,800008c4 <Proc_6+0x28>
      *Enum_Ref_Par = Ident_3;
800008c2:	c098                	sw	a4,0(s1)
} /* Proc_6 */
800008c4:	40b2                	lw	ra,12(sp)
800008c6:	4422                	lw	s0,8(sp)
800008c8:	4492                	lw	s1,4(sp)
800008ca:	0141                	addi	sp,sp,16
800008cc:	8082                	ret
    *Enum_Ref_Par = Ident_4;
800008ce:	478d                	li	a5,3
800008d0:	c09c                	sw	a5,0(s1)
  switch (Enum_Val_Par)
800008d2:	4785                	li	a5,1
800008d4:	fef410e3          	bne	s0,a5,800008b4 <Proc_6+0x18>
      if (Int_Glob > 100)
800008d8:	83c1a703          	lw	a4,-1988(gp) # 800034dc <Int_Glob>
800008dc:	06400793          	li	a5,100
800008e0:	00e7df63          	ble	a4,a5,800008fe <Proc_6+0x62>
} /* Proc_6 */
800008e4:	40b2                	lw	ra,12(sp)
800008e6:	4422                	lw	s0,8(sp)
      *Enum_Ref_Par = Ident_1;
800008e8:	0004a023          	sw	zero,0(s1)
} /* Proc_6 */
800008ec:	4492                	lw	s1,4(sp)
800008ee:	0141                	addi	sp,sp,16
800008f0:	8082                	ret
800008f2:	40b2                	lw	ra,12(sp)
800008f4:	4422                	lw	s0,8(sp)
      *Enum_Ref_Par = Ident_2;
800008f6:	c09c                	sw	a5,0(s1)
} /* Proc_6 */
800008f8:	4492                	lw	s1,4(sp)
800008fa:	0141                	addi	sp,sp,16
800008fc:	8082                	ret
800008fe:	40b2                	lw	ra,12(sp)
80000900:	4422                	lw	s0,8(sp)
      else *Enum_Ref_Par = Ident_4;
80000902:	478d                	li	a5,3
80000904:	c09c                	sw	a5,0(s1)
} /* Proc_6 */
80000906:	4492                	lw	s1,4(sp)
80000908:	0141                	addi	sp,sp,16
8000090a:	8082                	ret

8000090c <printf_s>:
{
	putchar(c);
}

static void printf_s(char *p)
{
8000090c:	1141                	addi	sp,sp,-16
8000090e:	c422                	sw	s0,8(sp)
80000910:	c606                	sw	ra,12(sp)
80000912:	842a                	mv	s0,a0
	while (*p)
80000914:	00054503          	lbu	a0,0(a0)
80000918:	c511                	beqz	a0,80000924 <printf_s+0x18>
		putchar(*(p++));
8000091a:	0405                	addi	s0,s0,1
8000091c:	2ab1                	jal	80000a78 <putchar>
	while (*p)
8000091e:	00044503          	lbu	a0,0(s0)
80000922:	fd65                	bnez	a0,8000091a <printf_s+0xe>
}
80000924:	40b2                	lw	ra,12(sp)
80000926:	4422                	lw	s0,8(sp)
80000928:	0141                	addi	sp,sp,16
8000092a:	8082                	ret

8000092c <printf_c>:
	putchar(c);
8000092c:	a2b1                	j	80000a78 <putchar>

8000092e <printf_d>:

static void printf_d(int val)
{
8000092e:	7179                	addi	sp,sp,-48
80000930:	d226                	sw	s1,36(sp)
80000932:	d606                	sw	ra,44(sp)
80000934:	d422                	sw	s0,40(sp)
80000936:	d04a                	sw	s2,32(sp)
80000938:	84aa                	mv	s1,a0
	char buffer[32];
	char *p = buffer;
	if (val < 0) {
8000093a:	04054263          	bltz	a0,8000097e <printf_d+0x50>
{
8000093e:	890a                	mv	s2,sp
80000940:	844a                	mv	s0,s2
80000942:	a829                	j	8000095c <printf_d+0x2e>
		printf_c('-');
		val = -val;
	}
	while (val || p == buffer) {
		*(p++) = '0' + val % 10;
80000944:	30c020ef          	jal	ra,80002c50 <__modsi3>
80000948:	03050793          	addi	a5,a0,48
8000094c:	0405                	addi	s0,s0,1
		val = val / 10;
8000094e:	8526                	mv	a0,s1
80000950:	45a9                	li	a1,10
		*(p++) = '0' + val % 10;
80000952:	fef40fa3          	sb	a5,-1(s0)
		val = val / 10;
80000956:	276020ef          	jal	ra,80002bcc <__divsi3>
8000095a:	84aa                	mv	s1,a0
		*(p++) = '0' + val % 10;
8000095c:	45a9                	li	a1,10
8000095e:	8526                	mv	a0,s1
	while (val || p == buffer) {
80000960:	f0f5                	bnez	s1,80000944 <printf_d+0x16>
80000962:	ff2401e3          	beq	s0,s2,80000944 <printf_d+0x16>
	}
	while (p != buffer)
		printf_c(*(--p));
80000966:	147d                	addi	s0,s0,-1
80000968:	00044503          	lbu	a0,0(s0)
8000096c:	37c1                	jal	8000092c <printf_c>
	while (p != buffer)
8000096e:	ff241ce3          	bne	s0,s2,80000966 <printf_d+0x38>
}
80000972:	50b2                	lw	ra,44(sp)
80000974:	5422                	lw	s0,40(sp)
80000976:	5492                	lw	s1,36(sp)
80000978:	5902                	lw	s2,32(sp)
8000097a:	6145                	addi	sp,sp,48
8000097c:	8082                	ret
		printf_c('-');
8000097e:	02d00513          	li	a0,45
80000982:	376d                	jal	8000092c <printf_c>
		val = -val;
80000984:	409004b3          	neg	s1,s1
80000988:	bf5d                	j	8000093e <printf_d+0x10>

8000098a <malloc>:
	char *p = heap_memory + heap_memory_used;
8000098a:	8481a703          	lw	a4,-1976(gp) # 800034e8 <heap_memory_used>
	heap_memory_used += size;
8000098e:	00a707b3          	add	a5,a4,a0
	char *p = heap_memory + heap_memory_used;
80000992:	80006537          	lui	a0,0x80006
	heap_memory_used += size;
80000996:	84f1a423          	sw	a5,-1976(gp) # 800034e8 <heap_memory_used>
	char *p = heap_memory + heap_memory_used;
8000099a:	cc450513          	addi	a0,a0,-828 # 80005cc4 <_stack_start+0xfffff7f4>
	if (heap_memory_used > 1024)
8000099e:	40000693          	li	a3,1024
	char *p = heap_memory + heap_memory_used;
800009a2:	953a                	add	a0,a0,a4
	if (heap_memory_used > 1024)
800009a4:	00f6d363          	ble	a5,a3,800009aa <malloc+0x20>
		asm volatile ("ebreak");
800009a8:	9002                	ebreak
}
800009aa:	8082                	ret

800009ac <printf>:

int printf(const char *format, ...)
{
800009ac:	715d                	addi	sp,sp,-80
800009ae:	cc52                	sw	s4,24(sp)
800009b0:	d606                	sw	ra,44(sp)
800009b2:	d422                	sw	s0,40(sp)
800009b4:	d226                	sw	s1,36(sp)
800009b6:	d04a                	sw	s2,32(sp)
800009b8:	ce4e                	sw	s3,28(sp)
800009ba:	ca56                	sw	s5,20(sp)
800009bc:	8a2a                	mv	s4,a0
	int i;
	va_list ap;

	va_start(ap, format);

	for (i = 0; format[i]; i++)
800009be:	00054503          	lbu	a0,0(a0)
{
800009c2:	c2be                	sw	a5,68(sp)
	va_start(ap, format);
800009c4:	185c                	addi	a5,sp,52
{
800009c6:	da2e                	sw	a1,52(sp)
800009c8:	dc32                	sw	a2,56(sp)
800009ca:	de36                	sw	a3,60(sp)
800009cc:	c0ba                	sw	a4,64(sp)
800009ce:	c4c2                	sw	a6,72(sp)
800009d0:	c6c6                	sw	a7,76(sp)
	va_start(ap, format);
800009d2:	c63e                	sw	a5,12(sp)
	for (i = 0; format[i]; i++)
800009d4:	c11d                	beqz	a0,800009fa <printf+0x4e>
800009d6:	4401                	li	s0,0
		if (format[i] == '%') {
800009d8:	02500a93          	li	s5,37
			while (format[++i]) {
				if (format[i] == 'c') {
800009dc:	06300493          	li	s1,99
					printf_c(va_arg(ap,int));
					break;
				}
				if (format[i] == 's') {
800009e0:	07300913          	li	s2,115
					printf_s(va_arg(ap,char*));
					break;
				}
				if (format[i] == 'd') {
800009e4:	06400993          	li	s3,100
		if (format[i] == '%') {
800009e8:	03550263          	beq	a0,s5,80000a0c <printf+0x60>
					printf_d(va_arg(ap,int));
					break;
				}
			}
		} else
			printf_c(format[i]);
800009ec:	3781                	jal	8000092c <printf_c>
	for (i = 0; format[i]; i++)
800009ee:	0405                	addi	s0,s0,1
800009f0:	008a07b3          	add	a5,s4,s0
800009f4:	0007c503          	lbu	a0,0(a5)
800009f8:	f965                	bnez	a0,800009e8 <printf+0x3c>

	va_end(ap);
}
800009fa:	50b2                	lw	ra,44(sp)
800009fc:	5422                	lw	s0,40(sp)
800009fe:	5492                	lw	s1,36(sp)
80000a00:	5902                	lw	s2,32(sp)
80000a02:	49f2                	lw	s3,28(sp)
80000a04:	4a62                	lw	s4,24(sp)
80000a06:	4ad2                	lw	s5,20(sp)
80000a08:	6161                	addi	sp,sp,80
80000a0a:	8082                	ret
80000a0c:	00140693          	addi	a3,s0,1
80000a10:	00da0733          	add	a4,s4,a3
80000a14:	a031                	j	80000a20 <printf+0x74>
				if (format[i] == 's') {
80000a16:	03278263          	beq	a5,s2,80000a3a <printf+0x8e>
				if (format[i] == 'd') {
80000a1a:	03378663          	beq	a5,s3,80000a46 <printf+0x9a>
80000a1e:	0685                	addi	a3,a3,1
			while (format[++i]) {
80000a20:	00074783          	lbu	a5,0(a4)
80000a24:	8436                	mv	s0,a3
80000a26:	0705                	addi	a4,a4,1
80000a28:	d3f9                	beqz	a5,800009ee <printf+0x42>
				if (format[i] == 'c') {
80000a2a:	fe9796e3          	bne	a5,s1,80000a16 <printf+0x6a>
					printf_c(va_arg(ap,int));
80000a2e:	47b2                	lw	a5,12(sp)
80000a30:	4388                	lw	a0,0(a5)
80000a32:	0791                	addi	a5,a5,4
80000a34:	c63e                	sw	a5,12(sp)
80000a36:	3ddd                	jal	8000092c <printf_c>
					break;
80000a38:	bf5d                	j	800009ee <printf+0x42>
					printf_s(va_arg(ap,char*));
80000a3a:	47b2                	lw	a5,12(sp)
80000a3c:	4388                	lw	a0,0(a5)
80000a3e:	0791                	addi	a5,a5,4
80000a40:	c63e                	sw	a5,12(sp)
80000a42:	35e9                	jal	8000090c <printf_s>
					break;
80000a44:	b76d                	j	800009ee <printf+0x42>
					printf_d(va_arg(ap,int));
80000a46:	47b2                	lw	a5,12(sp)
80000a48:	4388                	lw	a0,0(a5)
80000a4a:	0791                	addi	a5,a5,4
80000a4c:	c63e                	sw	a5,12(sp)
80000a4e:	35c5                	jal	8000092e <printf_d>
					break;
80000a50:	bf79                	j	800009ee <printf+0x42>

80000a52 <puts>:


int puts(char *s){
80000a52:	1141                	addi	sp,sp,-16
80000a54:	c422                	sw	s0,8(sp)
80000a56:	c606                	sw	ra,12(sp)
80000a58:	842a                	mv	s0,a0
  while (*s) {
80000a5a:	00054503          	lbu	a0,0(a0)
80000a5e:	c511                	beqz	a0,80000a6a <puts+0x18>
    putchar(*s);
    s++;
80000a60:	0405                	addi	s0,s0,1
    putchar(*s);
80000a62:	2819                	jal	80000a78 <putchar>
  while (*s) {
80000a64:	00044503          	lbu	a0,0(s0)
80000a68:	fd65                	bnez	a0,80000a60 <puts+0xe>
  }
  putchar('\n');
80000a6a:	4529                	li	a0,10
80000a6c:	2031                	jal	80000a78 <putchar>
  return 0;
}
80000a6e:	40b2                	lw	ra,12(sp)
80000a70:	4422                	lw	s0,8(sp)
80000a72:	4501                	li	a0,0
80000a74:	0141                	addi	sp,sp,16
80000a76:	8082                	ret

80000a78 <putchar>:

void putchar(char c){
	TEST_COM_BASE[0] = c;
80000a78:	f01007b7          	lui	a5,0xf0100
80000a7c:	f0a7a023          	sw	a0,-256(a5) # f00fff00 <_stack_start+0x700f9a30>
}
80000a80:	8082                	ret

80000a82 <clock>:

#include <time.h>
clock_t	clock(){
  return TEST_COM_BASE[4];
80000a82:	f01007b7          	lui	a5,0xf0100
80000a86:	f107a503          	lw	a0,-240(a5) # f00fff10 <_stack_start+0x700f9a40>
}
80000a8a:	8082                	ret

80000a8c <memcpy>:
80000a8c:	00a5c7b3          	xor	a5,a1,a0
80000a90:	0037f793          	andi	a5,a5,3
80000a94:	00c50733          	add	a4,a0,a2
80000a98:	00079663          	bnez	a5,80000aa4 <memcpy+0x18>
80000a9c:	00300793          	li	a5,3
80000aa0:	02c7e463          	bltu	a5,a2,80000ac8 <memcpy+0x3c>
80000aa4:	00050793          	mv	a5,a0
80000aa8:	00e56c63          	bltu	a0,a4,80000ac0 <memcpy+0x34>
80000aac:	00008067          	ret
80000ab0:	0005c683          	lbu	a3,0(a1)
80000ab4:	00178793          	addi	a5,a5,1
80000ab8:	00158593          	addi	a1,a1,1
80000abc:	fed78fa3          	sb	a3,-1(a5)
80000ac0:	fee7e8e3          	bltu	a5,a4,80000ab0 <memcpy+0x24>
80000ac4:	00008067          	ret
80000ac8:	00357793          	andi	a5,a0,3
80000acc:	08079263          	bnez	a5,80000b50 <memcpy+0xc4>
80000ad0:	00050793          	mv	a5,a0
80000ad4:	ffc77693          	andi	a3,a4,-4
80000ad8:	fe068613          	addi	a2,a3,-32
80000adc:	08c7f663          	bleu	a2,a5,80000b68 <memcpy+0xdc>
80000ae0:	0005a383          	lw	t2,0(a1)
80000ae4:	0045a283          	lw	t0,4(a1)
80000ae8:	0085af83          	lw	t6,8(a1)
80000aec:	00c5af03          	lw	t5,12(a1)
80000af0:	0105ae83          	lw	t4,16(a1)
80000af4:	0145ae03          	lw	t3,20(a1)
80000af8:	0185a303          	lw	t1,24(a1)
80000afc:	01c5a883          	lw	a7,28(a1)
80000b00:	02458593          	addi	a1,a1,36
80000b04:	02478793          	addi	a5,a5,36
80000b08:	ffc5a803          	lw	a6,-4(a1)
80000b0c:	fc77ae23          	sw	t2,-36(a5)
80000b10:	fe57a023          	sw	t0,-32(a5)
80000b14:	fff7a223          	sw	t6,-28(a5)
80000b18:	ffe7a423          	sw	t5,-24(a5)
80000b1c:	ffd7a623          	sw	t4,-20(a5)
80000b20:	ffc7a823          	sw	t3,-16(a5)
80000b24:	fe67aa23          	sw	t1,-12(a5)
80000b28:	ff17ac23          	sw	a7,-8(a5)
80000b2c:	ff07ae23          	sw	a6,-4(a5)
80000b30:	fadff06f          	j	80000adc <memcpy+0x50>
80000b34:	0005c683          	lbu	a3,0(a1)
80000b38:	00178793          	addi	a5,a5,1
80000b3c:	00158593          	addi	a1,a1,1
80000b40:	fed78fa3          	sb	a3,-1(a5)
80000b44:	0037f693          	andi	a3,a5,3
80000b48:	fe0696e3          	bnez	a3,80000b34 <memcpy+0xa8>
80000b4c:	f89ff06f          	j	80000ad4 <memcpy+0x48>
80000b50:	00050793          	mv	a5,a0
80000b54:	ff1ff06f          	j	80000b44 <memcpy+0xb8>
80000b58:	0005a603          	lw	a2,0(a1)
80000b5c:	00478793          	addi	a5,a5,4
80000b60:	00458593          	addi	a1,a1,4
80000b64:	fec7ae23          	sw	a2,-4(a5)
80000b68:	fed7e8e3          	bltu	a5,a3,80000b58 <memcpy+0xcc>
80000b6c:	f4e7eae3          	bltu	a5,a4,80000ac0 <memcpy+0x34>
80000b70:	00008067          	ret

80000b74 <strcmp>:
80000b74:	00b56733          	or	a4,a0,a1
80000b78:	fff00393          	li	t2,-1
80000b7c:	00377713          	andi	a4,a4,3
80000b80:	10071063          	bnez	a4,80000c80 <strcmp+0x10c>
80000b84:	7f7f87b7          	lui	a5,0x7f7f8
80000b88:	f7f78793          	addi	a5,a5,-129 # 7f7f7f7f <_stack_size+0x7f7f7b7f>
80000b8c:	00052603          	lw	a2,0(a0)
80000b90:	0005a683          	lw	a3,0(a1)
80000b94:	00f672b3          	and	t0,a2,a5
80000b98:	00f66333          	or	t1,a2,a5
80000b9c:	00f282b3          	add	t0,t0,a5
80000ba0:	0062e2b3          	or	t0,t0,t1
80000ba4:	10729263          	bne	t0,t2,80000ca8 <strcmp+0x134>
80000ba8:	08d61663          	bne	a2,a3,80000c34 <strcmp+0xc0>
80000bac:	00452603          	lw	a2,4(a0)
80000bb0:	0045a683          	lw	a3,4(a1)
80000bb4:	00f672b3          	and	t0,a2,a5
80000bb8:	00f66333          	or	t1,a2,a5
80000bbc:	00f282b3          	add	t0,t0,a5
80000bc0:	0062e2b3          	or	t0,t0,t1
80000bc4:	0c729e63          	bne	t0,t2,80000ca0 <strcmp+0x12c>
80000bc8:	06d61663          	bne	a2,a3,80000c34 <strcmp+0xc0>
80000bcc:	00852603          	lw	a2,8(a0)
80000bd0:	0085a683          	lw	a3,8(a1)
80000bd4:	00f672b3          	and	t0,a2,a5
80000bd8:	00f66333          	or	t1,a2,a5
80000bdc:	00f282b3          	add	t0,t0,a5
80000be0:	0062e2b3          	or	t0,t0,t1
80000be4:	0c729863          	bne	t0,t2,80000cb4 <strcmp+0x140>
80000be8:	04d61663          	bne	a2,a3,80000c34 <strcmp+0xc0>
80000bec:	00c52603          	lw	a2,12(a0)
80000bf0:	00c5a683          	lw	a3,12(a1)
80000bf4:	00f672b3          	and	t0,a2,a5
80000bf8:	00f66333          	or	t1,a2,a5
80000bfc:	00f282b3          	add	t0,t0,a5
80000c00:	0062e2b3          	or	t0,t0,t1
80000c04:	0c729263          	bne	t0,t2,80000cc8 <strcmp+0x154>
80000c08:	02d61663          	bne	a2,a3,80000c34 <strcmp+0xc0>
80000c0c:	01052603          	lw	a2,16(a0)
80000c10:	0105a683          	lw	a3,16(a1)
80000c14:	00f672b3          	and	t0,a2,a5
80000c18:	00f66333          	or	t1,a2,a5
80000c1c:	00f282b3          	add	t0,t0,a5
80000c20:	0062e2b3          	or	t0,t0,t1
80000c24:	0a729c63          	bne	t0,t2,80000cdc <strcmp+0x168>
80000c28:	01450513          	addi	a0,a0,20
80000c2c:	01458593          	addi	a1,a1,20
80000c30:	f4d60ee3          	beq	a2,a3,80000b8c <strcmp+0x18>
80000c34:	01061713          	slli	a4,a2,0x10
80000c38:	01069793          	slli	a5,a3,0x10
80000c3c:	00f71e63          	bne	a4,a5,80000c58 <strcmp+0xe4>
80000c40:	01065713          	srli	a4,a2,0x10
80000c44:	0106d793          	srli	a5,a3,0x10
80000c48:	40f70533          	sub	a0,a4,a5
80000c4c:	0ff57593          	andi	a1,a0,255
80000c50:	02059063          	bnez	a1,80000c70 <strcmp+0xfc>
80000c54:	00008067          	ret
80000c58:	01075713          	srli	a4,a4,0x10
80000c5c:	0107d793          	srli	a5,a5,0x10
80000c60:	40f70533          	sub	a0,a4,a5
80000c64:	0ff57593          	andi	a1,a0,255
80000c68:	00059463          	bnez	a1,80000c70 <strcmp+0xfc>
80000c6c:	00008067          	ret
80000c70:	0ff77713          	andi	a4,a4,255
80000c74:	0ff7f793          	andi	a5,a5,255
80000c78:	40f70533          	sub	a0,a4,a5
80000c7c:	00008067          	ret
80000c80:	00054603          	lbu	a2,0(a0)
80000c84:	0005c683          	lbu	a3,0(a1)
80000c88:	00150513          	addi	a0,a0,1
80000c8c:	00158593          	addi	a1,a1,1
80000c90:	00d61463          	bne	a2,a3,80000c98 <strcmp+0x124>
80000c94:	fe0616e3          	bnez	a2,80000c80 <strcmp+0x10c>
80000c98:	40d60533          	sub	a0,a2,a3
80000c9c:	00008067          	ret
80000ca0:	00450513          	addi	a0,a0,4
80000ca4:	00458593          	addi	a1,a1,4
80000ca8:	fcd61ce3          	bne	a2,a3,80000c80 <strcmp+0x10c>
80000cac:	00000513          	li	a0,0
80000cb0:	00008067          	ret
80000cb4:	00850513          	addi	a0,a0,8
80000cb8:	00858593          	addi	a1,a1,8
80000cbc:	fcd612e3          	bne	a2,a3,80000c80 <strcmp+0x10c>
80000cc0:	00000513          	li	a0,0
80000cc4:	00008067          	ret
80000cc8:	00c50513          	addi	a0,a0,12
80000ccc:	00c58593          	addi	a1,a1,12
80000cd0:	fad618e3          	bne	a2,a3,80000c80 <strcmp+0x10c>
80000cd4:	00000513          	li	a0,0
80000cd8:	00008067          	ret
80000cdc:	01050513          	addi	a0,a0,16
80000ce0:	01058593          	addi	a1,a1,16
80000ce4:	f8d61ee3          	bne	a2,a3,80000c80 <strcmp+0x10c>
80000ce8:	00000513          	li	a0,0
80000cec:	00008067          	ret

80000cf0 <__divdf3>:
80000cf0:	fb010113          	addi	sp,sp,-80
80000cf4:	04812423          	sw	s0,72(sp)
80000cf8:	03412c23          	sw	s4,56(sp)
80000cfc:	00100437          	lui	s0,0x100
80000d00:	0145da13          	srli	s4,a1,0x14
80000d04:	05212023          	sw	s2,64(sp)
80000d08:	03312e23          	sw	s3,60(sp)
80000d0c:	03512a23          	sw	s5,52(sp)
80000d10:	03812423          	sw	s8,40(sp)
80000d14:	fff40413          	addi	s0,s0,-1 # fffff <_stack_size+0xffbff>
80000d18:	04112623          	sw	ra,76(sp)
80000d1c:	04912223          	sw	s1,68(sp)
80000d20:	03612823          	sw	s6,48(sp)
80000d24:	03712623          	sw	s7,44(sp)
80000d28:	03912223          	sw	s9,36(sp)
80000d2c:	03a12023          	sw	s10,32(sp)
80000d30:	01b12e23          	sw	s11,28(sp)
80000d34:	7ffa7a13          	andi	s4,s4,2047
80000d38:	00050913          	mv	s2,a0
80000d3c:	00060c13          	mv	s8,a2
80000d40:	00068a93          	mv	s5,a3
80000d44:	00b47433          	and	s0,s0,a1
80000d48:	01f5d993          	srli	s3,a1,0x1f
80000d4c:	0a0a0663          	beqz	s4,80000df8 <__divdf3+0x108>
80000d50:	7ff00793          	li	a5,2047
80000d54:	10fa0463          	beq	s4,a5,80000e5c <__divdf3+0x16c>
80000d58:	00341413          	slli	s0,s0,0x3
80000d5c:	008007b7          	lui	a5,0x800
80000d60:	00f46433          	or	s0,s0,a5
80000d64:	01d55b13          	srli	s6,a0,0x1d
80000d68:	008b6b33          	or	s6,s6,s0
80000d6c:	00351493          	slli	s1,a0,0x3
80000d70:	c01a0a13          	addi	s4,s4,-1023
80000d74:	00000b93          	li	s7,0
80000d78:	014ad513          	srli	a0,s5,0x14
80000d7c:	00100937          	lui	s2,0x100
80000d80:	fff90913          	addi	s2,s2,-1 # fffff <_stack_size+0xffbff>
80000d84:	7ff57513          	andi	a0,a0,2047
80000d88:	01597933          	and	s2,s2,s5
80000d8c:	000c0593          	mv	a1,s8
80000d90:	01fada93          	srli	s5,s5,0x1f
80000d94:	10050263          	beqz	a0,80000e98 <__divdf3+0x1a8>
80000d98:	7ff00793          	li	a5,2047
80000d9c:	16f50263          	beq	a0,a5,80000f00 <__divdf3+0x210>
80000da0:	00800437          	lui	s0,0x800
80000da4:	00391913          	slli	s2,s2,0x3
80000da8:	00896933          	or	s2,s2,s0
80000dac:	01dc5413          	srli	s0,s8,0x1d
80000db0:	01246433          	or	s0,s0,s2
80000db4:	003c1593          	slli	a1,s8,0x3
80000db8:	c0150513          	addi	a0,a0,-1023
80000dbc:	00000793          	li	a5,0
80000dc0:	002b9713          	slli	a4,s7,0x2
80000dc4:	00f76733          	or	a4,a4,a5
80000dc8:	fff70713          	addi	a4,a4,-1
80000dcc:	00e00693          	li	a3,14
80000dd0:	0159c933          	xor	s2,s3,s5
80000dd4:	40aa0a33          	sub	s4,s4,a0
80000dd8:	16e6e063          	bltu	a3,a4,80000f38 <__divdf3+0x248>
80000ddc:	00002697          	auipc	a3,0x2
80000de0:	4d068693          	addi	a3,a3,1232 # 800032ac <end+0x5e0>
80000de4:	00271713          	slli	a4,a4,0x2
80000de8:	00d70733          	add	a4,a4,a3
80000dec:	00072703          	lw	a4,0(a4)
80000df0:	00d70733          	add	a4,a4,a3
80000df4:	00070067          	jr	a4
80000df8:	00a46b33          	or	s6,s0,a0
80000dfc:	060b0e63          	beqz	s6,80000e78 <__divdf3+0x188>
80000e00:	04040063          	beqz	s0,80000e40 <__divdf3+0x150>
80000e04:	00040513          	mv	a0,s0
80000e08:	679010ef          	jal	ra,80002c80 <__clzsi2>
80000e0c:	ff550793          	addi	a5,a0,-11
80000e10:	01c00713          	li	a4,28
80000e14:	02f74c63          	blt	a4,a5,80000e4c <__divdf3+0x15c>
80000e18:	01d00b13          	li	s6,29
80000e1c:	ff850493          	addi	s1,a0,-8
80000e20:	40fb0b33          	sub	s6,s6,a5
80000e24:	00941433          	sll	s0,s0,s1
80000e28:	01695b33          	srl	s6,s2,s6
80000e2c:	008b6b33          	or	s6,s6,s0
80000e30:	009914b3          	sll	s1,s2,s1
80000e34:	c0d00a13          	li	s4,-1011
80000e38:	40aa0a33          	sub	s4,s4,a0
80000e3c:	f39ff06f          	j	80000d74 <__divdf3+0x84>
80000e40:	641010ef          	jal	ra,80002c80 <__clzsi2>
80000e44:	02050513          	addi	a0,a0,32
80000e48:	fc5ff06f          	j	80000e0c <__divdf3+0x11c>
80000e4c:	fd850413          	addi	s0,a0,-40
80000e50:	00891b33          	sll	s6,s2,s0
80000e54:	00000493          	li	s1,0
80000e58:	fddff06f          	j	80000e34 <__divdf3+0x144>
80000e5c:	00a46b33          	or	s6,s0,a0
80000e60:	020b0463          	beqz	s6,80000e88 <__divdf3+0x198>
80000e64:	00050493          	mv	s1,a0
80000e68:	00040b13          	mv	s6,s0
80000e6c:	7ff00a13          	li	s4,2047
80000e70:	00300b93          	li	s7,3
80000e74:	f05ff06f          	j	80000d78 <__divdf3+0x88>
80000e78:	00000493          	li	s1,0
80000e7c:	00000a13          	li	s4,0
80000e80:	00100b93          	li	s7,1
80000e84:	ef5ff06f          	j	80000d78 <__divdf3+0x88>
80000e88:	00000493          	li	s1,0
80000e8c:	7ff00a13          	li	s4,2047
80000e90:	00200b93          	li	s7,2
80000e94:	ee5ff06f          	j	80000d78 <__divdf3+0x88>
80000e98:	01896433          	or	s0,s2,s8
80000e9c:	06040e63          	beqz	s0,80000f18 <__divdf3+0x228>
80000ea0:	04090063          	beqz	s2,80000ee0 <__divdf3+0x1f0>
80000ea4:	00090513          	mv	a0,s2
80000ea8:	5d9010ef          	jal	ra,80002c80 <__clzsi2>
80000eac:	ff550793          	addi	a5,a0,-11
80000eb0:	01c00713          	li	a4,28
80000eb4:	02f74e63          	blt	a4,a5,80000ef0 <__divdf3+0x200>
80000eb8:	01d00413          	li	s0,29
80000ebc:	ff850593          	addi	a1,a0,-8
80000ec0:	40f40433          	sub	s0,s0,a5
80000ec4:	00b91933          	sll	s2,s2,a1
80000ec8:	008c5433          	srl	s0,s8,s0
80000ecc:	01246433          	or	s0,s0,s2
80000ed0:	00bc15b3          	sll	a1,s8,a1
80000ed4:	c0d00713          	li	a4,-1011
80000ed8:	40a70533          	sub	a0,a4,a0
80000edc:	ee1ff06f          	j	80000dbc <__divdf3+0xcc>
80000ee0:	000c0513          	mv	a0,s8
80000ee4:	59d010ef          	jal	ra,80002c80 <__clzsi2>
80000ee8:	02050513          	addi	a0,a0,32
80000eec:	fc1ff06f          	j	80000eac <__divdf3+0x1bc>
80000ef0:	fd850413          	addi	s0,a0,-40
80000ef4:	008c1433          	sll	s0,s8,s0
80000ef8:	00000593          	li	a1,0
80000efc:	fd9ff06f          	j	80000ed4 <__divdf3+0x1e4>
80000f00:	01896433          	or	s0,s2,s8
80000f04:	02040263          	beqz	s0,80000f28 <__divdf3+0x238>
80000f08:	00090413          	mv	s0,s2
80000f0c:	7ff00513          	li	a0,2047
80000f10:	00300793          	li	a5,3
80000f14:	eadff06f          	j	80000dc0 <__divdf3+0xd0>
80000f18:	00000593          	li	a1,0
80000f1c:	00000513          	li	a0,0
80000f20:	00100793          	li	a5,1
80000f24:	e9dff06f          	j	80000dc0 <__divdf3+0xd0>
80000f28:	00000593          	li	a1,0
80000f2c:	7ff00513          	li	a0,2047
80000f30:	00200793          	li	a5,2
80000f34:	e8dff06f          	j	80000dc0 <__divdf3+0xd0>
80000f38:	01646663          	bltu	s0,s6,80000f44 <__divdf3+0x254>
80000f3c:	488b1263          	bne	s6,s0,800013c0 <__divdf3+0x6d0>
80000f40:	48b4e063          	bltu	s1,a1,800013c0 <__divdf3+0x6d0>
80000f44:	01fb1693          	slli	a3,s6,0x1f
80000f48:	0014d713          	srli	a4,s1,0x1
80000f4c:	01f49c13          	slli	s8,s1,0x1f
80000f50:	001b5b13          	srli	s6,s6,0x1
80000f54:	00e6e4b3          	or	s1,a3,a4
80000f58:	00841413          	slli	s0,s0,0x8
80000f5c:	0185dc93          	srli	s9,a1,0x18
80000f60:	008cecb3          	or	s9,s9,s0
80000f64:	010cda93          	srli	s5,s9,0x10
80000f68:	010c9793          	slli	a5,s9,0x10
80000f6c:	0107d793          	srli	a5,a5,0x10
80000f70:	00859d13          	slli	s10,a1,0x8
80000f74:	000b0513          	mv	a0,s6
80000f78:	000a8593          	mv	a1,s5
80000f7c:	00f12223          	sw	a5,4(sp)
80000f80:	455010ef          	jal	ra,80002bd4 <__udivsi3>
80000f84:	00050593          	mv	a1,a0
80000f88:	00050b93          	mv	s7,a0
80000f8c:	010c9513          	slli	a0,s9,0x10
80000f90:	01055513          	srli	a0,a0,0x10
80000f94:	415010ef          	jal	ra,80002ba8 <__mulsi3>
80000f98:	00050413          	mv	s0,a0
80000f9c:	000a8593          	mv	a1,s5
80000fa0:	000b0513          	mv	a0,s6
80000fa4:	479010ef          	jal	ra,80002c1c <__umodsi3>
80000fa8:	01051513          	slli	a0,a0,0x10
80000fac:	0104d713          	srli	a4,s1,0x10
80000fb0:	00a76533          	or	a0,a4,a0
80000fb4:	000b8993          	mv	s3,s7
80000fb8:	00857e63          	bleu	s0,a0,80000fd4 <__divdf3+0x2e4>
80000fbc:	01950533          	add	a0,a0,s9
80000fc0:	fffb8993          	addi	s3,s7,-1
80000fc4:	01956863          	bltu	a0,s9,80000fd4 <__divdf3+0x2e4>
80000fc8:	00857663          	bleu	s0,a0,80000fd4 <__divdf3+0x2e4>
80000fcc:	ffeb8993          	addi	s3,s7,-2
80000fd0:	01950533          	add	a0,a0,s9
80000fd4:	40850433          	sub	s0,a0,s0
80000fd8:	000a8593          	mv	a1,s5
80000fdc:	00040513          	mv	a0,s0
80000fe0:	3f5010ef          	jal	ra,80002bd4 <__udivsi3>
80000fe4:	00050593          	mv	a1,a0
80000fe8:	00050b93          	mv	s7,a0
80000fec:	010c9513          	slli	a0,s9,0x10
80000ff0:	01055513          	srli	a0,a0,0x10
80000ff4:	3b5010ef          	jal	ra,80002ba8 <__mulsi3>
80000ff8:	00050b13          	mv	s6,a0
80000ffc:	000a8593          	mv	a1,s5
80001000:	00040513          	mv	a0,s0
80001004:	419010ef          	jal	ra,80002c1c <__umodsi3>
80001008:	01049d93          	slli	s11,s1,0x10
8000100c:	01051513          	slli	a0,a0,0x10
80001010:	010ddd93          	srli	s11,s11,0x10
80001014:	00adedb3          	or	s11,s11,a0
80001018:	000b8713          	mv	a4,s7
8000101c:	016dfe63          	bleu	s6,s11,80001038 <__divdf3+0x348>
80001020:	019d8db3          	add	s11,s11,s9
80001024:	fffb8713          	addi	a4,s7,-1
80001028:	019de863          	bltu	s11,s9,80001038 <__divdf3+0x348>
8000102c:	016df663          	bleu	s6,s11,80001038 <__divdf3+0x348>
80001030:	ffeb8713          	addi	a4,s7,-2
80001034:	019d8db3          	add	s11,s11,s9
80001038:	01099693          	slli	a3,s3,0x10
8000103c:	000104b7          	lui	s1,0x10
80001040:	00e6e6b3          	or	a3,a3,a4
80001044:	416d8db3          	sub	s11,s11,s6
80001048:	fff48b13          	addi	s6,s1,-1 # ffff <_stack_size+0xfbff>
8000104c:	0166f733          	and	a4,a3,s6
80001050:	016d7b33          	and	s6,s10,s6
80001054:	00070513          	mv	a0,a4
80001058:	000b0593          	mv	a1,s6
8000105c:	0106d413          	srli	s0,a3,0x10
80001060:	00d12623          	sw	a3,12(sp)
80001064:	00e12423          	sw	a4,8(sp)
80001068:	341010ef          	jal	ra,80002ba8 <__mulsi3>
8000106c:	00a12223          	sw	a0,4(sp)
80001070:	000b0593          	mv	a1,s6
80001074:	00040513          	mv	a0,s0
80001078:	331010ef          	jal	ra,80002ba8 <__mulsi3>
8000107c:	010d5b93          	srli	s7,s10,0x10
80001080:	00050993          	mv	s3,a0
80001084:	000b8593          	mv	a1,s7
80001088:	00040513          	mv	a0,s0
8000108c:	31d010ef          	jal	ra,80002ba8 <__mulsi3>
80001090:	00812703          	lw	a4,8(sp)
80001094:	00050413          	mv	s0,a0
80001098:	000b8513          	mv	a0,s7
8000109c:	00070593          	mv	a1,a4
800010a0:	309010ef          	jal	ra,80002ba8 <__mulsi3>
800010a4:	00412603          	lw	a2,4(sp)
800010a8:	01350533          	add	a0,a0,s3
800010ac:	00c12683          	lw	a3,12(sp)
800010b0:	01065713          	srli	a4,a2,0x10
800010b4:	00a70733          	add	a4,a4,a0
800010b8:	01377463          	bleu	s3,a4,800010c0 <__divdf3+0x3d0>
800010bc:	00940433          	add	s0,s0,s1
800010c0:	00010537          	lui	a0,0x10
800010c4:	fff50513          	addi	a0,a0,-1 # ffff <_stack_size+0xfbff>
800010c8:	01075493          	srli	s1,a4,0x10
800010cc:	00a779b3          	and	s3,a4,a0
800010d0:	01099993          	slli	s3,s3,0x10
800010d4:	00a67633          	and	a2,a2,a0
800010d8:	008484b3          	add	s1,s1,s0
800010dc:	00c989b3          	add	s3,s3,a2
800010e0:	009de863          	bltu	s11,s1,800010f0 <__divdf3+0x400>
800010e4:	00068413          	mv	s0,a3
800010e8:	049d9463          	bne	s11,s1,80001130 <__divdf3+0x440>
800010ec:	053c7263          	bleu	s3,s8,80001130 <__divdf3+0x440>
800010f0:	01ac0c33          	add	s8,s8,s10
800010f4:	01ac3733          	sltu	a4,s8,s10
800010f8:	01970733          	add	a4,a4,s9
800010fc:	00ed8db3          	add	s11,s11,a4
80001100:	fff68413          	addi	s0,a3,-1
80001104:	01bce663          	bltu	s9,s11,80001110 <__divdf3+0x420>
80001108:	03bc9463          	bne	s9,s11,80001130 <__divdf3+0x440>
8000110c:	03ac6263          	bltu	s8,s10,80001130 <__divdf3+0x440>
80001110:	009de663          	bltu	s11,s1,8000111c <__divdf3+0x42c>
80001114:	01b49e63          	bne	s1,s11,80001130 <__divdf3+0x440>
80001118:	013c7c63          	bleu	s3,s8,80001130 <__divdf3+0x440>
8000111c:	01ac0c33          	add	s8,s8,s10
80001120:	01ac3733          	sltu	a4,s8,s10
80001124:	01970733          	add	a4,a4,s9
80001128:	ffe68413          	addi	s0,a3,-2
8000112c:	00ed8db3          	add	s11,s11,a4
80001130:	413c09b3          	sub	s3,s8,s3
80001134:	409d84b3          	sub	s1,s11,s1
80001138:	013c37b3          	sltu	a5,s8,s3
8000113c:	40f484b3          	sub	s1,s1,a5
80001140:	fff00593          	li	a1,-1
80001144:	1a9c8863          	beq	s9,s1,800012f4 <__divdf3+0x604>
80001148:	000a8593          	mv	a1,s5
8000114c:	00048513          	mv	a0,s1
80001150:	285010ef          	jal	ra,80002bd4 <__udivsi3>
80001154:	00050593          	mv	a1,a0
80001158:	00a12423          	sw	a0,8(sp)
8000115c:	010c9513          	slli	a0,s9,0x10
80001160:	01055513          	srli	a0,a0,0x10
80001164:	245010ef          	jal	ra,80002ba8 <__mulsi3>
80001168:	00a12223          	sw	a0,4(sp)
8000116c:	000a8593          	mv	a1,s5
80001170:	00048513          	mv	a0,s1
80001174:	2a9010ef          	jal	ra,80002c1c <__umodsi3>
80001178:	00812683          	lw	a3,8(sp)
8000117c:	00412703          	lw	a4,4(sp)
80001180:	01051513          	slli	a0,a0,0x10
80001184:	0109d793          	srli	a5,s3,0x10
80001188:	00a7e533          	or	a0,a5,a0
8000118c:	00068d93          	mv	s11,a3
80001190:	00e57e63          	bleu	a4,a0,800011ac <__divdf3+0x4bc>
80001194:	01950533          	add	a0,a0,s9
80001198:	fff68d93          	addi	s11,a3,-1
8000119c:	01956863          	bltu	a0,s9,800011ac <__divdf3+0x4bc>
800011a0:	00e57663          	bleu	a4,a0,800011ac <__divdf3+0x4bc>
800011a4:	ffe68d93          	addi	s11,a3,-2
800011a8:	01950533          	add	a0,a0,s9
800011ac:	40e504b3          	sub	s1,a0,a4
800011b0:	000a8593          	mv	a1,s5
800011b4:	00048513          	mv	a0,s1
800011b8:	21d010ef          	jal	ra,80002bd4 <__udivsi3>
800011bc:	00050593          	mv	a1,a0
800011c0:	00a12223          	sw	a0,4(sp)
800011c4:	010c9513          	slli	a0,s9,0x10
800011c8:	01055513          	srli	a0,a0,0x10
800011cc:	1dd010ef          	jal	ra,80002ba8 <__mulsi3>
800011d0:	00050c13          	mv	s8,a0
800011d4:	000a8593          	mv	a1,s5
800011d8:	00048513          	mv	a0,s1
800011dc:	241010ef          	jal	ra,80002c1c <__umodsi3>
800011e0:	01099993          	slli	s3,s3,0x10
800011e4:	00412703          	lw	a4,4(sp)
800011e8:	01051513          	slli	a0,a0,0x10
800011ec:	0109d993          	srli	s3,s3,0x10
800011f0:	00a9e533          	or	a0,s3,a0
800011f4:	00070793          	mv	a5,a4
800011f8:	01857e63          	bleu	s8,a0,80001214 <__divdf3+0x524>
800011fc:	01950533          	add	a0,a0,s9
80001200:	fff70793          	addi	a5,a4,-1
80001204:	01956863          	bltu	a0,s9,80001214 <__divdf3+0x524>
80001208:	01857663          	bleu	s8,a0,80001214 <__divdf3+0x524>
8000120c:	ffe70793          	addi	a5,a4,-2
80001210:	01950533          	add	a0,a0,s9
80001214:	010d9493          	slli	s1,s11,0x10
80001218:	00f4e4b3          	or	s1,s1,a5
8000121c:	01049793          	slli	a5,s1,0x10
80001220:	0107d793          	srli	a5,a5,0x10
80001224:	000b0593          	mv	a1,s6
80001228:	418509b3          	sub	s3,a0,s8
8000122c:	00078513          	mv	a0,a5
80001230:	00f12223          	sw	a5,4(sp)
80001234:	0104dd93          	srli	s11,s1,0x10
80001238:	171010ef          	jal	ra,80002ba8 <__mulsi3>
8000123c:	000b0593          	mv	a1,s6
80001240:	00050a93          	mv	s5,a0
80001244:	000d8513          	mv	a0,s11
80001248:	161010ef          	jal	ra,80002ba8 <__mulsi3>
8000124c:	00050c13          	mv	s8,a0
80001250:	000d8593          	mv	a1,s11
80001254:	000b8513          	mv	a0,s7
80001258:	151010ef          	jal	ra,80002ba8 <__mulsi3>
8000125c:	00412783          	lw	a5,4(sp)
80001260:	00050b13          	mv	s6,a0
80001264:	000b8513          	mv	a0,s7
80001268:	00078593          	mv	a1,a5
8000126c:	13d010ef          	jal	ra,80002ba8 <__mulsi3>
80001270:	01850533          	add	a0,a0,s8
80001274:	010ad793          	srli	a5,s5,0x10
80001278:	00a78533          	add	a0,a5,a0
8000127c:	01857663          	bleu	s8,a0,80001288 <__divdf3+0x598>
80001280:	000107b7          	lui	a5,0x10
80001284:	00fb0b33          	add	s6,s6,a5
80001288:	000106b7          	lui	a3,0x10
8000128c:	fff68693          	addi	a3,a3,-1 # ffff <_stack_size+0xfbff>
80001290:	01055793          	srli	a5,a0,0x10
80001294:	00d57733          	and	a4,a0,a3
80001298:	01071713          	slli	a4,a4,0x10
8000129c:	00dafab3          	and	s5,s5,a3
800012a0:	016787b3          	add	a5,a5,s6
800012a4:	01570733          	add	a4,a4,s5
800012a8:	00f9e863          	bltu	s3,a5,800012b8 <__divdf3+0x5c8>
800012ac:	00048593          	mv	a1,s1
800012b0:	04f99063          	bne	s3,a5,800012f0 <__divdf3+0x600>
800012b4:	04070063          	beqz	a4,800012f4 <__divdf3+0x604>
800012b8:	013c8533          	add	a0,s9,s3
800012bc:	fff48593          	addi	a1,s1,-1
800012c0:	03956463          	bltu	a0,s9,800012e8 <__divdf3+0x5f8>
800012c4:	00f56663          	bltu	a0,a5,800012d0 <__divdf3+0x5e0>
800012c8:	02f51463          	bne	a0,a5,800012f0 <__divdf3+0x600>
800012cc:	02ed7063          	bleu	a4,s10,800012ec <__divdf3+0x5fc>
800012d0:	001d1693          	slli	a3,s10,0x1
800012d4:	01a6bd33          	sltu	s10,a3,s10
800012d8:	019d0cb3          	add	s9,s10,s9
800012dc:	ffe48593          	addi	a1,s1,-2
800012e0:	01950533          	add	a0,a0,s9
800012e4:	00068d13          	mv	s10,a3
800012e8:	00f51463          	bne	a0,a5,800012f0 <__divdf3+0x600>
800012ec:	01a70463          	beq	a4,s10,800012f4 <__divdf3+0x604>
800012f0:	0015e593          	ori	a1,a1,1
800012f4:	3ffa0713          	addi	a4,s4,1023
800012f8:	12e05263          	blez	a4,8000141c <__divdf3+0x72c>
800012fc:	0075f793          	andi	a5,a1,7
80001300:	02078063          	beqz	a5,80001320 <__divdf3+0x630>
80001304:	00f5f793          	andi	a5,a1,15
80001308:	00400693          	li	a3,4
8000130c:	00d78a63          	beq	a5,a3,80001320 <__divdf3+0x630>
80001310:	00458693          	addi	a3,a1,4
80001314:	00b6b5b3          	sltu	a1,a3,a1
80001318:	00b40433          	add	s0,s0,a1
8000131c:	00068593          	mv	a1,a3
80001320:	00741793          	slli	a5,s0,0x7
80001324:	0007da63          	bgez	a5,80001338 <__divdf3+0x648>
80001328:	ff0007b7          	lui	a5,0xff000
8000132c:	fff78793          	addi	a5,a5,-1 # feffffff <_stack_start+0x7eff9b2f>
80001330:	00f47433          	and	s0,s0,a5
80001334:	400a0713          	addi	a4,s4,1024
80001338:	7fe00793          	li	a5,2046
8000133c:	1ae7c263          	blt	a5,a4,800014e0 <__divdf3+0x7f0>
80001340:	01d41793          	slli	a5,s0,0x1d
80001344:	0035d593          	srli	a1,a1,0x3
80001348:	00b7e7b3          	or	a5,a5,a1
8000134c:	00345413          	srli	s0,s0,0x3
80001350:	001006b7          	lui	a3,0x100
80001354:	fff68693          	addi	a3,a3,-1 # fffff <_stack_size+0xffbff>
80001358:	00d47433          	and	s0,s0,a3
8000135c:	801006b7          	lui	a3,0x80100
80001360:	7ff77713          	andi	a4,a4,2047
80001364:	fff68693          	addi	a3,a3,-1 # 800fffff <_stack_start+0xf9b2f>
80001368:	01471713          	slli	a4,a4,0x14
8000136c:	00d47433          	and	s0,s0,a3
80001370:	01f91913          	slli	s2,s2,0x1f
80001374:	00e46433          	or	s0,s0,a4
80001378:	01246733          	or	a4,s0,s2
8000137c:	04c12083          	lw	ra,76(sp)
80001380:	04812403          	lw	s0,72(sp)
80001384:	04412483          	lw	s1,68(sp)
80001388:	04012903          	lw	s2,64(sp)
8000138c:	03c12983          	lw	s3,60(sp)
80001390:	03812a03          	lw	s4,56(sp)
80001394:	03412a83          	lw	s5,52(sp)
80001398:	03012b03          	lw	s6,48(sp)
8000139c:	02c12b83          	lw	s7,44(sp)
800013a0:	02812c03          	lw	s8,40(sp)
800013a4:	02412c83          	lw	s9,36(sp)
800013a8:	02012d03          	lw	s10,32(sp)
800013ac:	01c12d83          	lw	s11,28(sp)
800013b0:	00078513          	mv	a0,a5
800013b4:	00070593          	mv	a1,a4
800013b8:	05010113          	addi	sp,sp,80
800013bc:	00008067          	ret
800013c0:	fffa0a13          	addi	s4,s4,-1
800013c4:	00000c13          	li	s8,0
800013c8:	b91ff06f          	j	80000f58 <__divdf3+0x268>
800013cc:	00098913          	mv	s2,s3
800013d0:	000b0413          	mv	s0,s6
800013d4:	00048593          	mv	a1,s1
800013d8:	000b8793          	mv	a5,s7
800013dc:	00200713          	li	a4,2
800013e0:	10e78063          	beq	a5,a4,800014e0 <__divdf3+0x7f0>
800013e4:	00300713          	li	a4,3
800013e8:	0ee78263          	beq	a5,a4,800014cc <__divdf3+0x7dc>
800013ec:	00100713          	li	a4,1
800013f0:	f0e792e3          	bne	a5,a4,800012f4 <__divdf3+0x604>
800013f4:	00000413          	li	s0,0
800013f8:	00000793          	li	a5,0
800013fc:	0940006f          	j	80001490 <__divdf3+0x7a0>
80001400:	000a8913          	mv	s2,s5
80001404:	fd9ff06f          	j	800013dc <__divdf3+0x6ec>
80001408:	00080437          	lui	s0,0x80
8000140c:	00000593          	li	a1,0
80001410:	00000913          	li	s2,0
80001414:	00300793          	li	a5,3
80001418:	fc5ff06f          	j	800013dc <__divdf3+0x6ec>
8000141c:	00100693          	li	a3,1
80001420:	40e686b3          	sub	a3,a3,a4
80001424:	03800793          	li	a5,56
80001428:	fcd7c6e3          	blt	a5,a3,800013f4 <__divdf3+0x704>
8000142c:	01f00793          	li	a5,31
80001430:	06d7c463          	blt	a5,a3,80001498 <__divdf3+0x7a8>
80001434:	41ea0a13          	addi	s4,s4,1054
80001438:	014417b3          	sll	a5,s0,s4
8000143c:	00d5d733          	srl	a4,a1,a3
80001440:	01459a33          	sll	s4,a1,s4
80001444:	00e7e7b3          	or	a5,a5,a4
80001448:	01403a33          	snez	s4,s4
8000144c:	0147e7b3          	or	a5,a5,s4
80001450:	00d45433          	srl	s0,s0,a3
80001454:	0077f713          	andi	a4,a5,7
80001458:	02070063          	beqz	a4,80001478 <__divdf3+0x788>
8000145c:	00f7f713          	andi	a4,a5,15
80001460:	00400693          	li	a3,4
80001464:	00d70a63          	beq	a4,a3,80001478 <__divdf3+0x788>
80001468:	00478713          	addi	a4,a5,4
8000146c:	00f737b3          	sltu	a5,a4,a5
80001470:	00f40433          	add	s0,s0,a5
80001474:	00070793          	mv	a5,a4
80001478:	00841713          	slli	a4,s0,0x8
8000147c:	06074a63          	bltz	a4,800014f0 <__divdf3+0x800>
80001480:	01d41713          	slli	a4,s0,0x1d
80001484:	0037d793          	srli	a5,a5,0x3
80001488:	00f767b3          	or	a5,a4,a5
8000148c:	00345413          	srli	s0,s0,0x3
80001490:	00000713          	li	a4,0
80001494:	ebdff06f          	j	80001350 <__divdf3+0x660>
80001498:	fe100793          	li	a5,-31
8000149c:	40e787b3          	sub	a5,a5,a4
800014a0:	02000713          	li	a4,32
800014a4:	00f457b3          	srl	a5,s0,a5
800014a8:	00000513          	li	a0,0
800014ac:	00e68663          	beq	a3,a4,800014b8 <__divdf3+0x7c8>
800014b0:	43ea0a13          	addi	s4,s4,1086
800014b4:	01441533          	sll	a0,s0,s4
800014b8:	00b56a33          	or	s4,a0,a1
800014bc:	01403a33          	snez	s4,s4
800014c0:	0147e7b3          	or	a5,a5,s4
800014c4:	00000413          	li	s0,0
800014c8:	f8dff06f          	j	80001454 <__divdf3+0x764>
800014cc:	00080437          	lui	s0,0x80
800014d0:	00000793          	li	a5,0
800014d4:	7ff00713          	li	a4,2047
800014d8:	00000913          	li	s2,0
800014dc:	e75ff06f          	j	80001350 <__divdf3+0x660>
800014e0:	00000413          	li	s0,0
800014e4:	00000793          	li	a5,0
800014e8:	7ff00713          	li	a4,2047
800014ec:	e65ff06f          	j	80001350 <__divdf3+0x660>
800014f0:	00000413          	li	s0,0
800014f4:	00000793          	li	a5,0
800014f8:	00100713          	li	a4,1
800014fc:	e55ff06f          	j	80001350 <__divdf3+0x660>

80001500 <__muldf3>:
80001500:	fa010113          	addi	sp,sp,-96
80001504:	04812c23          	sw	s0,88(sp)
80001508:	05312623          	sw	s3,76(sp)
8000150c:	00100437          	lui	s0,0x100
80001510:	0145d993          	srli	s3,a1,0x14
80001514:	04912a23          	sw	s1,84(sp)
80001518:	05612023          	sw	s6,64(sp)
8000151c:	03712e23          	sw	s7,60(sp)
80001520:	03812c23          	sw	s8,56(sp)
80001524:	fff40413          	addi	s0,s0,-1 # fffff <_stack_size+0xffbff>
80001528:	04112e23          	sw	ra,92(sp)
8000152c:	05212823          	sw	s2,80(sp)
80001530:	05412423          	sw	s4,72(sp)
80001534:	05512223          	sw	s5,68(sp)
80001538:	03912a23          	sw	s9,52(sp)
8000153c:	03a12823          	sw	s10,48(sp)
80001540:	03b12623          	sw	s11,44(sp)
80001544:	7ff9f993          	andi	s3,s3,2047
80001548:	00050493          	mv	s1,a0
8000154c:	00060b93          	mv	s7,a2
80001550:	00068c13          	mv	s8,a3
80001554:	00b47433          	and	s0,s0,a1
80001558:	01f5db13          	srli	s6,a1,0x1f
8000155c:	0a098863          	beqz	s3,8000160c <__muldf3+0x10c>
80001560:	7ff00793          	li	a5,2047
80001564:	10f98663          	beq	s3,a5,80001670 <__muldf3+0x170>
80001568:	00800937          	lui	s2,0x800
8000156c:	00341413          	slli	s0,s0,0x3
80001570:	01246433          	or	s0,s0,s2
80001574:	01d55913          	srli	s2,a0,0x1d
80001578:	00896933          	or	s2,s2,s0
8000157c:	00351d13          	slli	s10,a0,0x3
80001580:	c0198993          	addi	s3,s3,-1023
80001584:	00000c93          	li	s9,0
80001588:	014c5513          	srli	a0,s8,0x14
8000158c:	00100a37          	lui	s4,0x100
80001590:	fffa0a13          	addi	s4,s4,-1 # fffff <_stack_size+0xffbff>
80001594:	7ff57513          	andi	a0,a0,2047
80001598:	018a7a33          	and	s4,s4,s8
8000159c:	000b8493          	mv	s1,s7
800015a0:	01fc5c13          	srli	s8,s8,0x1f
800015a4:	10050463          	beqz	a0,800016ac <__muldf3+0x1ac>
800015a8:	7ff00793          	li	a5,2047
800015ac:	16f50463          	beq	a0,a5,80001714 <__muldf3+0x214>
800015b0:	00800437          	lui	s0,0x800
800015b4:	003a1a13          	slli	s4,s4,0x3
800015b8:	008a6a33          	or	s4,s4,s0
800015bc:	01dbd413          	srli	s0,s7,0x1d
800015c0:	01446433          	or	s0,s0,s4
800015c4:	003b9493          	slli	s1,s7,0x3
800015c8:	c0150513          	addi	a0,a0,-1023
800015cc:	00000793          	li	a5,0
800015d0:	002c9713          	slli	a4,s9,0x2
800015d4:	00f76733          	or	a4,a4,a5
800015d8:	00a989b3          	add	s3,s3,a0
800015dc:	fff70713          	addi	a4,a4,-1
800015e0:	00e00693          	li	a3,14
800015e4:	018b4bb3          	xor	s7,s6,s8
800015e8:	00198a93          	addi	s5,s3,1
800015ec:	16e6e063          	bltu	a3,a4,8000174c <__muldf3+0x24c>
800015f0:	00002697          	auipc	a3,0x2
800015f4:	cf868693          	addi	a3,a3,-776 # 800032e8 <end+0x61c>
800015f8:	00271713          	slli	a4,a4,0x2
800015fc:	00d70733          	add	a4,a4,a3
80001600:	00072703          	lw	a4,0(a4)
80001604:	00d70733          	add	a4,a4,a3
80001608:	00070067          	jr	a4
8000160c:	00a46933          	or	s2,s0,a0
80001610:	06090e63          	beqz	s2,8000168c <__muldf3+0x18c>
80001614:	04040063          	beqz	s0,80001654 <__muldf3+0x154>
80001618:	00040513          	mv	a0,s0
8000161c:	664010ef          	jal	ra,80002c80 <__clzsi2>
80001620:	ff550793          	addi	a5,a0,-11
80001624:	01c00713          	li	a4,28
80001628:	02f74c63          	blt	a4,a5,80001660 <__muldf3+0x160>
8000162c:	01d00913          	li	s2,29
80001630:	ff850d13          	addi	s10,a0,-8
80001634:	40f90933          	sub	s2,s2,a5
80001638:	01a41433          	sll	s0,s0,s10
8000163c:	0124d933          	srl	s2,s1,s2
80001640:	00896933          	or	s2,s2,s0
80001644:	01a49d33          	sll	s10,s1,s10
80001648:	c0d00993          	li	s3,-1011
8000164c:	40a989b3          	sub	s3,s3,a0
80001650:	f35ff06f          	j	80001584 <__muldf3+0x84>
80001654:	62c010ef          	jal	ra,80002c80 <__clzsi2>
80001658:	02050513          	addi	a0,a0,32
8000165c:	fc5ff06f          	j	80001620 <__muldf3+0x120>
80001660:	fd850913          	addi	s2,a0,-40
80001664:	01249933          	sll	s2,s1,s2
80001668:	00000d13          	li	s10,0
8000166c:	fddff06f          	j	80001648 <__muldf3+0x148>
80001670:	00a46933          	or	s2,s0,a0
80001674:	02090463          	beqz	s2,8000169c <__muldf3+0x19c>
80001678:	00050d13          	mv	s10,a0
8000167c:	00040913          	mv	s2,s0
80001680:	7ff00993          	li	s3,2047
80001684:	00300c93          	li	s9,3
80001688:	f01ff06f          	j	80001588 <__muldf3+0x88>
8000168c:	00000d13          	li	s10,0
80001690:	00000993          	li	s3,0
80001694:	00100c93          	li	s9,1
80001698:	ef1ff06f          	j	80001588 <__muldf3+0x88>
8000169c:	00000d13          	li	s10,0
800016a0:	7ff00993          	li	s3,2047
800016a4:	00200c93          	li	s9,2
800016a8:	ee1ff06f          	j	80001588 <__muldf3+0x88>
800016ac:	017a6433          	or	s0,s4,s7
800016b0:	06040e63          	beqz	s0,8000172c <__muldf3+0x22c>
800016b4:	040a0063          	beqz	s4,800016f4 <__muldf3+0x1f4>
800016b8:	000a0513          	mv	a0,s4
800016bc:	5c4010ef          	jal	ra,80002c80 <__clzsi2>
800016c0:	ff550793          	addi	a5,a0,-11
800016c4:	01c00713          	li	a4,28
800016c8:	02f74e63          	blt	a4,a5,80001704 <__muldf3+0x204>
800016cc:	01d00413          	li	s0,29
800016d0:	ff850493          	addi	s1,a0,-8
800016d4:	40f40433          	sub	s0,s0,a5
800016d8:	009a1a33          	sll	s4,s4,s1
800016dc:	008bd433          	srl	s0,s7,s0
800016e0:	01446433          	or	s0,s0,s4
800016e4:	009b94b3          	sll	s1,s7,s1
800016e8:	c0d00793          	li	a5,-1011
800016ec:	40a78533          	sub	a0,a5,a0
800016f0:	eddff06f          	j	800015cc <__muldf3+0xcc>
800016f4:	000b8513          	mv	a0,s7
800016f8:	588010ef          	jal	ra,80002c80 <__clzsi2>
800016fc:	02050513          	addi	a0,a0,32
80001700:	fc1ff06f          	j	800016c0 <__muldf3+0x1c0>
80001704:	fd850413          	addi	s0,a0,-40
80001708:	008b9433          	sll	s0,s7,s0
8000170c:	00000493          	li	s1,0
80001710:	fd9ff06f          	j	800016e8 <__muldf3+0x1e8>
80001714:	017a6433          	or	s0,s4,s7
80001718:	02040263          	beqz	s0,8000173c <__muldf3+0x23c>
8000171c:	000a0413          	mv	s0,s4
80001720:	7ff00513          	li	a0,2047
80001724:	00300793          	li	a5,3
80001728:	ea9ff06f          	j	800015d0 <__muldf3+0xd0>
8000172c:	00000493          	li	s1,0
80001730:	00000513          	li	a0,0
80001734:	00100793          	li	a5,1
80001738:	e99ff06f          	j	800015d0 <__muldf3+0xd0>
8000173c:	00000493          	li	s1,0
80001740:	7ff00513          	li	a0,2047
80001744:	00200793          	li	a5,2
80001748:	e89ff06f          	j	800015d0 <__muldf3+0xd0>
8000174c:	00010737          	lui	a4,0x10
80001750:	fff70a13          	addi	s4,a4,-1 # ffff <_stack_size+0xfbff>
80001754:	010d5c13          	srli	s8,s10,0x10
80001758:	0104dd93          	srli	s11,s1,0x10
8000175c:	014d7d33          	and	s10,s10,s4
80001760:	0144f4b3          	and	s1,s1,s4
80001764:	000d0593          	mv	a1,s10
80001768:	00048513          	mv	a0,s1
8000176c:	00e12823          	sw	a4,16(sp)
80001770:	438010ef          	jal	ra,80002ba8 <__mulsi3>
80001774:	00050c93          	mv	s9,a0
80001778:	00048593          	mv	a1,s1
8000177c:	000c0513          	mv	a0,s8
80001780:	428010ef          	jal	ra,80002ba8 <__mulsi3>
80001784:	00a12623          	sw	a0,12(sp)
80001788:	000d8593          	mv	a1,s11
8000178c:	000c0513          	mv	a0,s8
80001790:	418010ef          	jal	ra,80002ba8 <__mulsi3>
80001794:	00050b13          	mv	s6,a0
80001798:	000d0593          	mv	a1,s10
8000179c:	000d8513          	mv	a0,s11
800017a0:	408010ef          	jal	ra,80002ba8 <__mulsi3>
800017a4:	00c12683          	lw	a3,12(sp)
800017a8:	010cd793          	srli	a5,s9,0x10
800017ac:	00d50533          	add	a0,a0,a3
800017b0:	00a78533          	add	a0,a5,a0
800017b4:	00d57663          	bleu	a3,a0,800017c0 <__muldf3+0x2c0>
800017b8:	01012703          	lw	a4,16(sp)
800017bc:	00eb0b33          	add	s6,s6,a4
800017c0:	01055693          	srli	a3,a0,0x10
800017c4:	01457533          	and	a0,a0,s4
800017c8:	014cfcb3          	and	s9,s9,s4
800017cc:	01051513          	slli	a0,a0,0x10
800017d0:	019507b3          	add	a5,a0,s9
800017d4:	01045c93          	srli	s9,s0,0x10
800017d8:	01447433          	and	s0,s0,s4
800017dc:	000d0593          	mv	a1,s10
800017e0:	00040513          	mv	a0,s0
800017e4:	00d12a23          	sw	a3,20(sp)
800017e8:	00f12623          	sw	a5,12(sp)
800017ec:	3bc010ef          	jal	ra,80002ba8 <__mulsi3>
800017f0:	00a12823          	sw	a0,16(sp)
800017f4:	00040593          	mv	a1,s0
800017f8:	000c0513          	mv	a0,s8
800017fc:	3ac010ef          	jal	ra,80002ba8 <__mulsi3>
80001800:	00050a13          	mv	s4,a0
80001804:	000c8593          	mv	a1,s9
80001808:	000c0513          	mv	a0,s8
8000180c:	39c010ef          	jal	ra,80002ba8 <__mulsi3>
80001810:	00050c13          	mv	s8,a0
80001814:	000d0593          	mv	a1,s10
80001818:	000c8513          	mv	a0,s9
8000181c:	38c010ef          	jal	ra,80002ba8 <__mulsi3>
80001820:	01012703          	lw	a4,16(sp)
80001824:	01450533          	add	a0,a0,s4
80001828:	01412683          	lw	a3,20(sp)
8000182c:	01075793          	srli	a5,a4,0x10
80001830:	00a78533          	add	a0,a5,a0
80001834:	01457663          	bleu	s4,a0,80001840 <__muldf3+0x340>
80001838:	000107b7          	lui	a5,0x10
8000183c:	00fc0c33          	add	s8,s8,a5
80001840:	00010637          	lui	a2,0x10
80001844:	01055793          	srli	a5,a0,0x10
80001848:	01878c33          	add	s8,a5,s8
8000184c:	fff60793          	addi	a5,a2,-1 # ffff <_stack_size+0xfbff>
80001850:	00f57a33          	and	s4,a0,a5
80001854:	00f77733          	and	a4,a4,a5
80001858:	010a1a13          	slli	s4,s4,0x10
8000185c:	01095d13          	srli	s10,s2,0x10
80001860:	00ea0a33          	add	s4,s4,a4
80001864:	00f97933          	and	s2,s2,a5
80001868:	01468733          	add	a4,a3,s4
8000186c:	00090593          	mv	a1,s2
80001870:	00048513          	mv	a0,s1
80001874:	00e12823          	sw	a4,16(sp)
80001878:	00c12e23          	sw	a2,28(sp)
8000187c:	32c010ef          	jal	ra,80002ba8 <__mulsi3>
80001880:	00048593          	mv	a1,s1
80001884:	00a12c23          	sw	a0,24(sp)
80001888:	000d0513          	mv	a0,s10
8000188c:	31c010ef          	jal	ra,80002ba8 <__mulsi3>
80001890:	00a12a23          	sw	a0,20(sp)
80001894:	000d0593          	mv	a1,s10
80001898:	000d8513          	mv	a0,s11
8000189c:	30c010ef          	jal	ra,80002ba8 <__mulsi3>
800018a0:	00050493          	mv	s1,a0
800018a4:	00090593          	mv	a1,s2
800018a8:	000d8513          	mv	a0,s11
800018ac:	2fc010ef          	jal	ra,80002ba8 <__mulsi3>
800018b0:	01412683          	lw	a3,20(sp)
800018b4:	01812703          	lw	a4,24(sp)
800018b8:	00d50533          	add	a0,a0,a3
800018bc:	01075793          	srli	a5,a4,0x10
800018c0:	00a78533          	add	a0,a5,a0
800018c4:	00d57663          	bleu	a3,a0,800018d0 <__muldf3+0x3d0>
800018c8:	01c12603          	lw	a2,28(sp)
800018cc:	00c484b3          	add	s1,s1,a2
800018d0:	000106b7          	lui	a3,0x10
800018d4:	fff68793          	addi	a5,a3,-1 # ffff <_stack_size+0xfbff>
800018d8:	01055d93          	srli	s11,a0,0x10
800018dc:	009d84b3          	add	s1,s11,s1
800018e0:	00f57db3          	and	s11,a0,a5
800018e4:	00f77733          	and	a4,a4,a5
800018e8:	00090593          	mv	a1,s2
800018ec:	00040513          	mv	a0,s0
800018f0:	010d9d93          	slli	s11,s11,0x10
800018f4:	00ed8db3          	add	s11,s11,a4
800018f8:	00d12c23          	sw	a3,24(sp)
800018fc:	2ac010ef          	jal	ra,80002ba8 <__mulsi3>
80001900:	00040593          	mv	a1,s0
80001904:	00a12a23          	sw	a0,20(sp)
80001908:	000d0513          	mv	a0,s10
8000190c:	29c010ef          	jal	ra,80002ba8 <__mulsi3>
80001910:	000d0593          	mv	a1,s10
80001914:	00050413          	mv	s0,a0
80001918:	000c8513          	mv	a0,s9
8000191c:	28c010ef          	jal	ra,80002ba8 <__mulsi3>
80001920:	00050d13          	mv	s10,a0
80001924:	00090593          	mv	a1,s2
80001928:	000c8513          	mv	a0,s9
8000192c:	27c010ef          	jal	ra,80002ba8 <__mulsi3>
80001930:	01412703          	lw	a4,20(sp)
80001934:	00850533          	add	a0,a0,s0
80001938:	01075793          	srli	a5,a4,0x10
8000193c:	00a78533          	add	a0,a5,a0
80001940:	00857663          	bleu	s0,a0,8000194c <__muldf3+0x44c>
80001944:	01812683          	lw	a3,24(sp)
80001948:	00dd0d33          	add	s10,s10,a3
8000194c:	01012783          	lw	a5,16(sp)
80001950:	000106b7          	lui	a3,0x10
80001954:	fff68693          	addi	a3,a3,-1 # ffff <_stack_size+0xfbff>
80001958:	00fb0b33          	add	s6,s6,a5
8000195c:	00d577b3          	and	a5,a0,a3
80001960:	00d77733          	and	a4,a4,a3
80001964:	01079793          	slli	a5,a5,0x10
80001968:	00e787b3          	add	a5,a5,a4
8000196c:	014b3a33          	sltu	s4,s6,s4
80001970:	018787b3          	add	a5,a5,s8
80001974:	01478433          	add	s0,a5,s4
80001978:	01bb0b33          	add	s6,s6,s11
8000197c:	00940733          	add	a4,s0,s1
80001980:	01bb3db3          	sltu	s11,s6,s11
80001984:	01b706b3          	add	a3,a4,s11
80001988:	0187bc33          	sltu	s8,a5,s8
8000198c:	01443433          	sltu	s0,s0,s4
80001990:	01055793          	srli	a5,a0,0x10
80001994:	00973733          	sltu	a4,a4,s1
80001998:	008c6433          	or	s0,s8,s0
8000199c:	01b6bdb3          	sltu	s11,a3,s11
800019a0:	00f40433          	add	s0,s0,a5
800019a4:	01b76db3          	or	s11,a4,s11
800019a8:	01b40433          	add	s0,s0,s11
800019ac:	01a40433          	add	s0,s0,s10
800019b0:	0176d793          	srli	a5,a3,0x17
800019b4:	00941413          	slli	s0,s0,0x9
800019b8:	00f46433          	or	s0,s0,a5
800019bc:	00c12783          	lw	a5,12(sp)
800019c0:	009b1493          	slli	s1,s6,0x9
800019c4:	017b5b13          	srli	s6,s6,0x17
800019c8:	00f4e4b3          	or	s1,s1,a5
800019cc:	009034b3          	snez	s1,s1
800019d0:	00969793          	slli	a5,a3,0x9
800019d4:	0164e4b3          	or	s1,s1,s6
800019d8:	00f4e4b3          	or	s1,s1,a5
800019dc:	00741793          	slli	a5,s0,0x7
800019e0:	1207d263          	bgez	a5,80001b04 <__muldf3+0x604>
800019e4:	0014d793          	srli	a5,s1,0x1
800019e8:	0014f493          	andi	s1,s1,1
800019ec:	0097e4b3          	or	s1,a5,s1
800019f0:	01f41793          	slli	a5,s0,0x1f
800019f4:	00f4e4b3          	or	s1,s1,a5
800019f8:	00145413          	srli	s0,s0,0x1
800019fc:	3ffa8713          	addi	a4,s5,1023
80001a00:	10e05663          	blez	a4,80001b0c <__muldf3+0x60c>
80001a04:	0074f793          	andi	a5,s1,7
80001a08:	02078063          	beqz	a5,80001a28 <__muldf3+0x528>
80001a0c:	00f4f793          	andi	a5,s1,15
80001a10:	00400693          	li	a3,4
80001a14:	00d78a63          	beq	a5,a3,80001a28 <__muldf3+0x528>
80001a18:	00448793          	addi	a5,s1,4
80001a1c:	0097b4b3          	sltu	s1,a5,s1
80001a20:	00940433          	add	s0,s0,s1
80001a24:	00078493          	mv	s1,a5
80001a28:	00741793          	slli	a5,s0,0x7
80001a2c:	0007da63          	bgez	a5,80001a40 <__muldf3+0x540>
80001a30:	ff0007b7          	lui	a5,0xff000
80001a34:	fff78793          	addi	a5,a5,-1 # feffffff <_stack_start+0x7eff9b2f>
80001a38:	00f47433          	and	s0,s0,a5
80001a3c:	400a8713          	addi	a4,s5,1024
80001a40:	7fe00793          	li	a5,2046
80001a44:	18e7c663          	blt	a5,a4,80001bd0 <__muldf3+0x6d0>
80001a48:	0034da93          	srli	s5,s1,0x3
80001a4c:	01d41493          	slli	s1,s0,0x1d
80001a50:	0154e4b3          	or	s1,s1,s5
80001a54:	00345413          	srli	s0,s0,0x3
80001a58:	001007b7          	lui	a5,0x100
80001a5c:	fff78793          	addi	a5,a5,-1 # fffff <_stack_size+0xffbff>
80001a60:	00f47433          	and	s0,s0,a5
80001a64:	7ff77793          	andi	a5,a4,2047
80001a68:	80100737          	lui	a4,0x80100
80001a6c:	fff70713          	addi	a4,a4,-1 # 800fffff <_stack_start+0xf9b2f>
80001a70:	01479793          	slli	a5,a5,0x14
80001a74:	00e47433          	and	s0,s0,a4
80001a78:	01fb9b93          	slli	s7,s7,0x1f
80001a7c:	00f46433          	or	s0,s0,a5
80001a80:	017467b3          	or	a5,s0,s7
80001a84:	05c12083          	lw	ra,92(sp)
80001a88:	05812403          	lw	s0,88(sp)
80001a8c:	00048513          	mv	a0,s1
80001a90:	05012903          	lw	s2,80(sp)
80001a94:	05412483          	lw	s1,84(sp)
80001a98:	04c12983          	lw	s3,76(sp)
80001a9c:	04812a03          	lw	s4,72(sp)
80001aa0:	04412a83          	lw	s5,68(sp)
80001aa4:	04012b03          	lw	s6,64(sp)
80001aa8:	03c12b83          	lw	s7,60(sp)
80001aac:	03812c03          	lw	s8,56(sp)
80001ab0:	03412c83          	lw	s9,52(sp)
80001ab4:	03012d03          	lw	s10,48(sp)
80001ab8:	02c12d83          	lw	s11,44(sp)
80001abc:	00078593          	mv	a1,a5
80001ac0:	06010113          	addi	sp,sp,96
80001ac4:	00008067          	ret
80001ac8:	000b0b93          	mv	s7,s6
80001acc:	00090413          	mv	s0,s2
80001ad0:	000d0493          	mv	s1,s10
80001ad4:	000c8793          	mv	a5,s9
80001ad8:	00200713          	li	a4,2
80001adc:	0ee78a63          	beq	a5,a4,80001bd0 <__muldf3+0x6d0>
80001ae0:	00300713          	li	a4,3
80001ae4:	0ce78c63          	beq	a5,a4,80001bbc <__muldf3+0x6bc>
80001ae8:	00100713          	li	a4,1
80001aec:	f0e798e3          	bne	a5,a4,800019fc <__muldf3+0x4fc>
80001af0:	00000413          	li	s0,0
80001af4:	00000493          	li	s1,0
80001af8:	0880006f          	j	80001b80 <__muldf3+0x680>
80001afc:	000c0b93          	mv	s7,s8
80001b00:	fd9ff06f          	j	80001ad8 <__muldf3+0x5d8>
80001b04:	00098a93          	mv	s5,s3
80001b08:	ef5ff06f          	j	800019fc <__muldf3+0x4fc>
80001b0c:	00100693          	li	a3,1
80001b10:	40e686b3          	sub	a3,a3,a4
80001b14:	03800793          	li	a5,56
80001b18:	fcd7cce3          	blt	a5,a3,80001af0 <__muldf3+0x5f0>
80001b1c:	01f00793          	li	a5,31
80001b20:	06d7c463          	blt	a5,a3,80001b88 <__muldf3+0x688>
80001b24:	41ea8a93          	addi	s5,s5,1054
80001b28:	015417b3          	sll	a5,s0,s5
80001b2c:	00d4d733          	srl	a4,s1,a3
80001b30:	015494b3          	sll	s1,s1,s5
80001b34:	00e7e7b3          	or	a5,a5,a4
80001b38:	009034b3          	snez	s1,s1
80001b3c:	0097e4b3          	or	s1,a5,s1
80001b40:	00d45433          	srl	s0,s0,a3
80001b44:	0074f793          	andi	a5,s1,7
80001b48:	02078063          	beqz	a5,80001b68 <__muldf3+0x668>
80001b4c:	00f4f793          	andi	a5,s1,15
80001b50:	00400713          	li	a4,4
80001b54:	00e78a63          	beq	a5,a4,80001b68 <__muldf3+0x668>
80001b58:	00448793          	addi	a5,s1,4
80001b5c:	0097b4b3          	sltu	s1,a5,s1
80001b60:	00940433          	add	s0,s0,s1
80001b64:	00078493          	mv	s1,a5
80001b68:	00841793          	slli	a5,s0,0x8
80001b6c:	0607ca63          	bltz	a5,80001be0 <__muldf3+0x6e0>
80001b70:	01d41793          	slli	a5,s0,0x1d
80001b74:	0034d493          	srli	s1,s1,0x3
80001b78:	0097e4b3          	or	s1,a5,s1
80001b7c:	00345413          	srli	s0,s0,0x3
80001b80:	00000713          	li	a4,0
80001b84:	ed5ff06f          	j	80001a58 <__muldf3+0x558>
80001b88:	fe100793          	li	a5,-31
80001b8c:	40e787b3          	sub	a5,a5,a4
80001b90:	02000613          	li	a2,32
80001b94:	00f457b3          	srl	a5,s0,a5
80001b98:	00000713          	li	a4,0
80001b9c:	00c68663          	beq	a3,a2,80001ba8 <__muldf3+0x6a8>
80001ba0:	43ea8a93          	addi	s5,s5,1086
80001ba4:	01541733          	sll	a4,s0,s5
80001ba8:	009764b3          	or	s1,a4,s1
80001bac:	009034b3          	snez	s1,s1
80001bb0:	0097e4b3          	or	s1,a5,s1
80001bb4:	00000413          	li	s0,0
80001bb8:	f8dff06f          	j	80001b44 <__muldf3+0x644>
80001bbc:	00080437          	lui	s0,0x80
80001bc0:	00000493          	li	s1,0
80001bc4:	7ff00713          	li	a4,2047
80001bc8:	00000b93          	li	s7,0
80001bcc:	e8dff06f          	j	80001a58 <__muldf3+0x558>
80001bd0:	00000413          	li	s0,0
80001bd4:	00000493          	li	s1,0
80001bd8:	7ff00713          	li	a4,2047
80001bdc:	e7dff06f          	j	80001a58 <__muldf3+0x558>
80001be0:	00000413          	li	s0,0
80001be4:	00000493          	li	s1,0
80001be8:	00100713          	li	a4,1
80001bec:	e6dff06f          	j	80001a58 <__muldf3+0x558>

80001bf0 <__divsf3>:
80001bf0:	fd010113          	addi	sp,sp,-48
80001bf4:	02912223          	sw	s1,36(sp)
80001bf8:	01512a23          	sw	s5,20(sp)
80001bfc:	01755493          	srli	s1,a0,0x17
80001c00:	00800ab7          	lui	s5,0x800
80001c04:	03212023          	sw	s2,32(sp)
80001c08:	01612823          	sw	s6,16(sp)
80001c0c:	fffa8a93          	addi	s5,s5,-1 # 7fffff <_stack_size+0x7ffbff>
80001c10:	02112623          	sw	ra,44(sp)
80001c14:	02812423          	sw	s0,40(sp)
80001c18:	01312e23          	sw	s3,28(sp)
80001c1c:	01412c23          	sw	s4,24(sp)
80001c20:	01712623          	sw	s7,12(sp)
80001c24:	01812423          	sw	s8,8(sp)
80001c28:	0ff4f493          	andi	s1,s1,255
80001c2c:	00058b13          	mv	s6,a1
80001c30:	00aafab3          	and	s5,s5,a0
80001c34:	01f55913          	srli	s2,a0,0x1f
80001c38:	08048863          	beqz	s1,80001cc8 <__divsf3+0xd8>
80001c3c:	0ff00793          	li	a5,255
80001c40:	0af48463          	beq	s1,a5,80001ce8 <__divsf3+0xf8>
80001c44:	003a9a93          	slli	s5,s5,0x3
80001c48:	040007b7          	lui	a5,0x4000
80001c4c:	00faeab3          	or	s5,s5,a5
80001c50:	f8148493          	addi	s1,s1,-127
80001c54:	00000b93          	li	s7,0
80001c58:	017b5513          	srli	a0,s6,0x17
80001c5c:	00800437          	lui	s0,0x800
80001c60:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80001c64:	0ff57513          	andi	a0,a0,255
80001c68:	01647433          	and	s0,s0,s6
80001c6c:	01fb5b13          	srli	s6,s6,0x1f
80001c70:	08050c63          	beqz	a0,80001d08 <__divsf3+0x118>
80001c74:	0ff00793          	li	a5,255
80001c78:	0af50863          	beq	a0,a5,80001d28 <__divsf3+0x138>
80001c7c:	00341413          	slli	s0,s0,0x3
80001c80:	040007b7          	lui	a5,0x4000
80001c84:	00f46433          	or	s0,s0,a5
80001c88:	f8150513          	addi	a0,a0,-127
80001c8c:	00000793          	li	a5,0
80001c90:	002b9713          	slli	a4,s7,0x2
80001c94:	00f76733          	or	a4,a4,a5
80001c98:	fff70713          	addi	a4,a4,-1
80001c9c:	00e00693          	li	a3,14
80001ca0:	016949b3          	xor	s3,s2,s6
80001ca4:	40a48a33          	sub	s4,s1,a0
80001ca8:	0ae6e063          	bltu	a3,a4,80001d48 <__divsf3+0x158>
80001cac:	00001697          	auipc	a3,0x1
80001cb0:	67868693          	addi	a3,a3,1656 # 80003324 <end+0x658>
80001cb4:	00271713          	slli	a4,a4,0x2
80001cb8:	00d70733          	add	a4,a4,a3
80001cbc:	00072703          	lw	a4,0(a4)
80001cc0:	00d70733          	add	a4,a4,a3
80001cc4:	00070067          	jr	a4
80001cc8:	020a8a63          	beqz	s5,80001cfc <__divsf3+0x10c>
80001ccc:	000a8513          	mv	a0,s5
80001cd0:	7b1000ef          	jal	ra,80002c80 <__clzsi2>
80001cd4:	ffb50793          	addi	a5,a0,-5
80001cd8:	f8a00493          	li	s1,-118
80001cdc:	00fa9ab3          	sll	s5,s5,a5
80001ce0:	40a484b3          	sub	s1,s1,a0
80001ce4:	f71ff06f          	j	80001c54 <__divsf3+0x64>
80001ce8:	0ff00493          	li	s1,255
80001cec:	00200b93          	li	s7,2
80001cf0:	f60a84e3          	beqz	s5,80001c58 <__divsf3+0x68>
80001cf4:	00300b93          	li	s7,3
80001cf8:	f61ff06f          	j	80001c58 <__divsf3+0x68>
80001cfc:	00000493          	li	s1,0
80001d00:	00100b93          	li	s7,1
80001d04:	f55ff06f          	j	80001c58 <__divsf3+0x68>
80001d08:	02040a63          	beqz	s0,80001d3c <__divsf3+0x14c>
80001d0c:	00040513          	mv	a0,s0
80001d10:	771000ef          	jal	ra,80002c80 <__clzsi2>
80001d14:	ffb50793          	addi	a5,a0,-5
80001d18:	00f41433          	sll	s0,s0,a5
80001d1c:	f8a00793          	li	a5,-118
80001d20:	40a78533          	sub	a0,a5,a0
80001d24:	f69ff06f          	j	80001c8c <__divsf3+0x9c>
80001d28:	0ff00513          	li	a0,255
80001d2c:	00200793          	li	a5,2
80001d30:	f60400e3          	beqz	s0,80001c90 <__divsf3+0xa0>
80001d34:	00300793          	li	a5,3
80001d38:	f59ff06f          	j	80001c90 <__divsf3+0xa0>
80001d3c:	00000513          	li	a0,0
80001d40:	00100793          	li	a5,1
80001d44:	f4dff06f          	j	80001c90 <__divsf3+0xa0>
80001d48:	00541b13          	slli	s6,s0,0x5
80001d4c:	128af663          	bleu	s0,s5,80001e78 <__divsf3+0x288>
80001d50:	fffa0a13          	addi	s4,s4,-1
80001d54:	00000913          	li	s2,0
80001d58:	010b5b93          	srli	s7,s6,0x10
80001d5c:	00010437          	lui	s0,0x10
80001d60:	000b8593          	mv	a1,s7
80001d64:	fff40413          	addi	s0,s0,-1 # ffff <_stack_size+0xfbff>
80001d68:	000a8513          	mv	a0,s5
80001d6c:	669000ef          	jal	ra,80002bd4 <__udivsi3>
80001d70:	008b7433          	and	s0,s6,s0
80001d74:	00050593          	mv	a1,a0
80001d78:	00050c13          	mv	s8,a0
80001d7c:	00040513          	mv	a0,s0
80001d80:	629000ef          	jal	ra,80002ba8 <__mulsi3>
80001d84:	00050493          	mv	s1,a0
80001d88:	000b8593          	mv	a1,s7
80001d8c:	000a8513          	mv	a0,s5
80001d90:	68d000ef          	jal	ra,80002c1c <__umodsi3>
80001d94:	01095913          	srli	s2,s2,0x10
80001d98:	01051513          	slli	a0,a0,0x10
80001d9c:	00a96533          	or	a0,s2,a0
80001da0:	000c0913          	mv	s2,s8
80001da4:	00957e63          	bleu	s1,a0,80001dc0 <__divsf3+0x1d0>
80001da8:	01650533          	add	a0,a0,s6
80001dac:	fffc0913          	addi	s2,s8,-1
80001db0:	01656863          	bltu	a0,s6,80001dc0 <__divsf3+0x1d0>
80001db4:	00957663          	bleu	s1,a0,80001dc0 <__divsf3+0x1d0>
80001db8:	ffec0913          	addi	s2,s8,-2
80001dbc:	01650533          	add	a0,a0,s6
80001dc0:	409504b3          	sub	s1,a0,s1
80001dc4:	000b8593          	mv	a1,s7
80001dc8:	00048513          	mv	a0,s1
80001dcc:	609000ef          	jal	ra,80002bd4 <__udivsi3>
80001dd0:	00050593          	mv	a1,a0
80001dd4:	00050c13          	mv	s8,a0
80001dd8:	00040513          	mv	a0,s0
80001ddc:	5cd000ef          	jal	ra,80002ba8 <__mulsi3>
80001de0:	00050a93          	mv	s5,a0
80001de4:	000b8593          	mv	a1,s7
80001de8:	00048513          	mv	a0,s1
80001dec:	631000ef          	jal	ra,80002c1c <__umodsi3>
80001df0:	01051513          	slli	a0,a0,0x10
80001df4:	000c0413          	mv	s0,s8
80001df8:	01557e63          	bleu	s5,a0,80001e14 <__divsf3+0x224>
80001dfc:	01650533          	add	a0,a0,s6
80001e00:	fffc0413          	addi	s0,s8,-1
80001e04:	01656863          	bltu	a0,s6,80001e14 <__divsf3+0x224>
80001e08:	01557663          	bleu	s5,a0,80001e14 <__divsf3+0x224>
80001e0c:	ffec0413          	addi	s0,s8,-2
80001e10:	01650533          	add	a0,a0,s6
80001e14:	01091913          	slli	s2,s2,0x10
80001e18:	41550533          	sub	a0,a0,s5
80001e1c:	00896933          	or	s2,s2,s0
80001e20:	00a03533          	snez	a0,a0
80001e24:	00a96433          	or	s0,s2,a0
80001e28:	07fa0713          	addi	a4,s4,127
80001e2c:	0ae05063          	blez	a4,80001ecc <__divsf3+0x2dc>
80001e30:	00747793          	andi	a5,s0,7
80001e34:	00078a63          	beqz	a5,80001e48 <__divsf3+0x258>
80001e38:	00f47793          	andi	a5,s0,15
80001e3c:	00400693          	li	a3,4
80001e40:	00d78463          	beq	a5,a3,80001e48 <__divsf3+0x258>
80001e44:	00440413          	addi	s0,s0,4
80001e48:	00441793          	slli	a5,s0,0x4
80001e4c:	0007da63          	bgez	a5,80001e60 <__divsf3+0x270>
80001e50:	f80007b7          	lui	a5,0xf8000
80001e54:	fff78793          	addi	a5,a5,-1 # f7ffffff <_stack_start+0x77ff9b2f>
80001e58:	00f47433          	and	s0,s0,a5
80001e5c:	080a0713          	addi	a4,s4,128
80001e60:	0fe00793          	li	a5,254
80001e64:	00345413          	srli	s0,s0,0x3
80001e68:	0ce7d263          	ble	a4,a5,80001f2c <__divsf3+0x33c>
80001e6c:	00000413          	li	s0,0
80001e70:	0ff00713          	li	a4,255
80001e74:	0b80006f          	j	80001f2c <__divsf3+0x33c>
80001e78:	01fa9913          	slli	s2,s5,0x1f
80001e7c:	001ada93          	srli	s5,s5,0x1
80001e80:	ed9ff06f          	j	80001d58 <__divsf3+0x168>
80001e84:	00090993          	mv	s3,s2
80001e88:	000a8413          	mv	s0,s5
80001e8c:	000b8793          	mv	a5,s7
80001e90:	00200713          	li	a4,2
80001e94:	fce78ce3          	beq	a5,a4,80001e6c <__divsf3+0x27c>
80001e98:	00300713          	li	a4,3
80001e9c:	08e78263          	beq	a5,a4,80001f20 <__divsf3+0x330>
80001ea0:	00100713          	li	a4,1
80001ea4:	f8e792e3          	bne	a5,a4,80001e28 <__divsf3+0x238>
80001ea8:	00000413          	li	s0,0
80001eac:	00000713          	li	a4,0
80001eb0:	07c0006f          	j	80001f2c <__divsf3+0x33c>
80001eb4:	000b0993          	mv	s3,s6
80001eb8:	fd9ff06f          	j	80001e90 <__divsf3+0x2a0>
80001ebc:	00400437          	lui	s0,0x400
80001ec0:	00000993          	li	s3,0
80001ec4:	00300793          	li	a5,3
80001ec8:	fc9ff06f          	j	80001e90 <__divsf3+0x2a0>
80001ecc:	00100793          	li	a5,1
80001ed0:	40e787b3          	sub	a5,a5,a4
80001ed4:	01b00713          	li	a4,27
80001ed8:	fcf748e3          	blt	a4,a5,80001ea8 <__divsf3+0x2b8>
80001edc:	09ea0513          	addi	a0,s4,158
80001ee0:	00f457b3          	srl	a5,s0,a5
80001ee4:	00a41433          	sll	s0,s0,a0
80001ee8:	00803433          	snez	s0,s0
80001eec:	0087e433          	or	s0,a5,s0
80001ef0:	00747793          	andi	a5,s0,7
80001ef4:	00078a63          	beqz	a5,80001f08 <__divsf3+0x318>
80001ef8:	00f47793          	andi	a5,s0,15
80001efc:	00400713          	li	a4,4
80001f00:	00e78463          	beq	a5,a4,80001f08 <__divsf3+0x318>
80001f04:	00440413          	addi	s0,s0,4 # 400004 <_stack_size+0x3ffc04>
80001f08:	00541793          	slli	a5,s0,0x5
80001f0c:	00345413          	srli	s0,s0,0x3
80001f10:	f807dee3          	bgez	a5,80001eac <__divsf3+0x2bc>
80001f14:	00000413          	li	s0,0
80001f18:	00100713          	li	a4,1
80001f1c:	0100006f          	j	80001f2c <__divsf3+0x33c>
80001f20:	00400437          	lui	s0,0x400
80001f24:	0ff00713          	li	a4,255
80001f28:	00000993          	li	s3,0
80001f2c:	00800537          	lui	a0,0x800
80001f30:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80001f34:	00a47433          	and	s0,s0,a0
80001f38:	80800537          	lui	a0,0x80800
80001f3c:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9b2f>
80001f40:	0ff77713          	andi	a4,a4,255
80001f44:	00a47433          	and	s0,s0,a0
80001f48:	01771713          	slli	a4,a4,0x17
80001f4c:	01f99513          	slli	a0,s3,0x1f
80001f50:	00e46433          	or	s0,s0,a4
80001f54:	00a46533          	or	a0,s0,a0
80001f58:	02c12083          	lw	ra,44(sp)
80001f5c:	02812403          	lw	s0,40(sp)
80001f60:	02412483          	lw	s1,36(sp)
80001f64:	02012903          	lw	s2,32(sp)
80001f68:	01c12983          	lw	s3,28(sp)
80001f6c:	01812a03          	lw	s4,24(sp)
80001f70:	01412a83          	lw	s5,20(sp)
80001f74:	01012b03          	lw	s6,16(sp)
80001f78:	00c12b83          	lw	s7,12(sp)
80001f7c:	00812c03          	lw	s8,8(sp)
80001f80:	03010113          	addi	sp,sp,48
80001f84:	00008067          	ret

80001f88 <__mulsf3>:
80001f88:	fd010113          	addi	sp,sp,-48
80001f8c:	02912223          	sw	s1,36(sp)
80001f90:	03212023          	sw	s2,32(sp)
80001f94:	008004b7          	lui	s1,0x800
80001f98:	01755913          	srli	s2,a0,0x17
80001f9c:	01312e23          	sw	s3,28(sp)
80001fa0:	01712623          	sw	s7,12(sp)
80001fa4:	fff48493          	addi	s1,s1,-1 # 7fffff <_stack_size+0x7ffbff>
80001fa8:	02112623          	sw	ra,44(sp)
80001fac:	02812423          	sw	s0,40(sp)
80001fb0:	01412c23          	sw	s4,24(sp)
80001fb4:	01512a23          	sw	s5,20(sp)
80001fb8:	01612823          	sw	s6,16(sp)
80001fbc:	01812423          	sw	s8,8(sp)
80001fc0:	01912223          	sw	s9,4(sp)
80001fc4:	0ff97913          	andi	s2,s2,255
80001fc8:	00058b93          	mv	s7,a1
80001fcc:	00a4f4b3          	and	s1,s1,a0
80001fd0:	01f55993          	srli	s3,a0,0x1f
80001fd4:	08090a63          	beqz	s2,80002068 <__mulsf3+0xe0>
80001fd8:	0ff00793          	li	a5,255
80001fdc:	0af90663          	beq	s2,a5,80002088 <__mulsf3+0x100>
80001fe0:	00349493          	slli	s1,s1,0x3
80001fe4:	040007b7          	lui	a5,0x4000
80001fe8:	00f4e4b3          	or	s1,s1,a5
80001fec:	f8190913          	addi	s2,s2,-127 # 7fff81 <_stack_size+0x7ffb81>
80001ff0:	00000b13          	li	s6,0
80001ff4:	017bd513          	srli	a0,s7,0x17
80001ff8:	00800437          	lui	s0,0x800
80001ffc:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002000:	0ff57513          	andi	a0,a0,255
80002004:	01747433          	and	s0,s0,s7
80002008:	01fbdb93          	srli	s7,s7,0x1f
8000200c:	08050e63          	beqz	a0,800020a8 <__mulsf3+0x120>
80002010:	0ff00793          	li	a5,255
80002014:	0af50a63          	beq	a0,a5,800020c8 <__mulsf3+0x140>
80002018:	00341413          	slli	s0,s0,0x3
8000201c:	040007b7          	lui	a5,0x4000
80002020:	00f46433          	or	s0,s0,a5
80002024:	f8150513          	addi	a0,a0,-127
80002028:	00000693          	li	a3,0
8000202c:	002b1793          	slli	a5,s6,0x2
80002030:	00d7e7b3          	or	a5,a5,a3
80002034:	00a90933          	add	s2,s2,a0
80002038:	fff78793          	addi	a5,a5,-1 # 3ffffff <_stack_size+0x3fffbff>
8000203c:	00e00713          	li	a4,14
80002040:	0179ca33          	xor	s4,s3,s7
80002044:	00190a93          	addi	s5,s2,1
80002048:	0af76063          	bltu	a4,a5,800020e8 <__mulsf3+0x160>
8000204c:	00001717          	auipc	a4,0x1
80002050:	31470713          	addi	a4,a4,788 # 80003360 <end+0x694>
80002054:	00279793          	slli	a5,a5,0x2
80002058:	00e787b3          	add	a5,a5,a4
8000205c:	0007a783          	lw	a5,0(a5)
80002060:	00e787b3          	add	a5,a5,a4
80002064:	00078067          	jr	a5
80002068:	02048a63          	beqz	s1,8000209c <__mulsf3+0x114>
8000206c:	00048513          	mv	a0,s1
80002070:	411000ef          	jal	ra,80002c80 <__clzsi2>
80002074:	ffb50793          	addi	a5,a0,-5
80002078:	f8a00913          	li	s2,-118
8000207c:	00f494b3          	sll	s1,s1,a5
80002080:	40a90933          	sub	s2,s2,a0
80002084:	f6dff06f          	j	80001ff0 <__mulsf3+0x68>
80002088:	0ff00913          	li	s2,255
8000208c:	00200b13          	li	s6,2
80002090:	f60482e3          	beqz	s1,80001ff4 <__mulsf3+0x6c>
80002094:	00300b13          	li	s6,3
80002098:	f5dff06f          	j	80001ff4 <__mulsf3+0x6c>
8000209c:	00000913          	li	s2,0
800020a0:	00100b13          	li	s6,1
800020a4:	f51ff06f          	j	80001ff4 <__mulsf3+0x6c>
800020a8:	02040a63          	beqz	s0,800020dc <__mulsf3+0x154>
800020ac:	00040513          	mv	a0,s0
800020b0:	3d1000ef          	jal	ra,80002c80 <__clzsi2>
800020b4:	ffb50793          	addi	a5,a0,-5
800020b8:	00f41433          	sll	s0,s0,a5
800020bc:	f8a00793          	li	a5,-118
800020c0:	40a78533          	sub	a0,a5,a0
800020c4:	f65ff06f          	j	80002028 <__mulsf3+0xa0>
800020c8:	0ff00513          	li	a0,255
800020cc:	00200693          	li	a3,2
800020d0:	f4040ee3          	beqz	s0,8000202c <__mulsf3+0xa4>
800020d4:	00300693          	li	a3,3
800020d8:	f55ff06f          	j	8000202c <__mulsf3+0xa4>
800020dc:	00000513          	li	a0,0
800020e0:	00100693          	li	a3,1
800020e4:	f49ff06f          	j	8000202c <__mulsf3+0xa4>
800020e8:	00010c37          	lui	s8,0x10
800020ec:	fffc0b13          	addi	s6,s8,-1 # ffff <_stack_size+0xfbff>
800020f0:	0104db93          	srli	s7,s1,0x10
800020f4:	01045c93          	srli	s9,s0,0x10
800020f8:	0164f4b3          	and	s1,s1,s6
800020fc:	01647433          	and	s0,s0,s6
80002100:	00040593          	mv	a1,s0
80002104:	00048513          	mv	a0,s1
80002108:	2a1000ef          	jal	ra,80002ba8 <__mulsi3>
8000210c:	00040593          	mv	a1,s0
80002110:	00050993          	mv	s3,a0
80002114:	000b8513          	mv	a0,s7
80002118:	291000ef          	jal	ra,80002ba8 <__mulsi3>
8000211c:	00050413          	mv	s0,a0
80002120:	000c8593          	mv	a1,s9
80002124:	000b8513          	mv	a0,s7
80002128:	281000ef          	jal	ra,80002ba8 <__mulsi3>
8000212c:	00050b93          	mv	s7,a0
80002130:	00048593          	mv	a1,s1
80002134:	000c8513          	mv	a0,s9
80002138:	271000ef          	jal	ra,80002ba8 <__mulsi3>
8000213c:	00850533          	add	a0,a0,s0
80002140:	0109d793          	srli	a5,s3,0x10
80002144:	00a78533          	add	a0,a5,a0
80002148:	00857463          	bleu	s0,a0,80002150 <__mulsf3+0x1c8>
8000214c:	018b8bb3          	add	s7,s7,s8
80002150:	016577b3          	and	a5,a0,s6
80002154:	01079793          	slli	a5,a5,0x10
80002158:	0169f9b3          	and	s3,s3,s6
8000215c:	013787b3          	add	a5,a5,s3
80002160:	00679413          	slli	s0,a5,0x6
80002164:	00803433          	snez	s0,s0
80002168:	01a7d793          	srli	a5,a5,0x1a
8000216c:	01055513          	srli	a0,a0,0x10
80002170:	00f467b3          	or	a5,s0,a5
80002174:	01750433          	add	s0,a0,s7
80002178:	00641413          	slli	s0,s0,0x6
8000217c:	00f46433          	or	s0,s0,a5
80002180:	00441793          	slli	a5,s0,0x4
80002184:	0e07d663          	bgez	a5,80002270 <__mulsf3+0x2e8>
80002188:	00145793          	srli	a5,s0,0x1
8000218c:	00147413          	andi	s0,s0,1
80002190:	0087e433          	or	s0,a5,s0
80002194:	07fa8713          	addi	a4,s5,127
80002198:	0ee05063          	blez	a4,80002278 <__mulsf3+0x2f0>
8000219c:	00747793          	andi	a5,s0,7
800021a0:	00078a63          	beqz	a5,800021b4 <__mulsf3+0x22c>
800021a4:	00f47793          	andi	a5,s0,15
800021a8:	00400693          	li	a3,4
800021ac:	00d78463          	beq	a5,a3,800021b4 <__mulsf3+0x22c>
800021b0:	00440413          	addi	s0,s0,4
800021b4:	00441793          	slli	a5,s0,0x4
800021b8:	0007da63          	bgez	a5,800021cc <__mulsf3+0x244>
800021bc:	f80007b7          	lui	a5,0xf8000
800021c0:	fff78793          	addi	a5,a5,-1 # f7ffffff <_stack_start+0x77ff9b2f>
800021c4:	00f47433          	and	s0,s0,a5
800021c8:	080a8713          	addi	a4,s5,128
800021cc:	0fe00793          	li	a5,254
800021d0:	10e7c463          	blt	a5,a4,800022d8 <__mulsf3+0x350>
800021d4:	00345793          	srli	a5,s0,0x3
800021d8:	0300006f          	j	80002208 <__mulsf3+0x280>
800021dc:	00098a13          	mv	s4,s3
800021e0:	00048413          	mv	s0,s1
800021e4:	000b0693          	mv	a3,s6
800021e8:	00200793          	li	a5,2
800021ec:	0ef68663          	beq	a3,a5,800022d8 <__mulsf3+0x350>
800021f0:	00300793          	li	a5,3
800021f4:	0cf68a63          	beq	a3,a5,800022c8 <__mulsf3+0x340>
800021f8:	00100613          	li	a2,1
800021fc:	00000793          	li	a5,0
80002200:	00000713          	li	a4,0
80002204:	f8c698e3          	bne	a3,a2,80002194 <__mulsf3+0x20c>
80002208:	00800437          	lui	s0,0x800
8000220c:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002210:	80800537          	lui	a0,0x80800
80002214:	0087f7b3          	and	a5,a5,s0
80002218:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9b2f>
8000221c:	02c12083          	lw	ra,44(sp)
80002220:	02812403          	lw	s0,40(sp)
80002224:	0ff77713          	andi	a4,a4,255
80002228:	00a7f7b3          	and	a5,a5,a0
8000222c:	01771713          	slli	a4,a4,0x17
80002230:	01fa1513          	slli	a0,s4,0x1f
80002234:	00e7e7b3          	or	a5,a5,a4
80002238:	02412483          	lw	s1,36(sp)
8000223c:	02012903          	lw	s2,32(sp)
80002240:	01c12983          	lw	s3,28(sp)
80002244:	01812a03          	lw	s4,24(sp)
80002248:	01412a83          	lw	s5,20(sp)
8000224c:	01012b03          	lw	s6,16(sp)
80002250:	00c12b83          	lw	s7,12(sp)
80002254:	00812c03          	lw	s8,8(sp)
80002258:	00412c83          	lw	s9,4(sp)
8000225c:	00a7e533          	or	a0,a5,a0
80002260:	03010113          	addi	sp,sp,48
80002264:	00008067          	ret
80002268:	000b8a13          	mv	s4,s7
8000226c:	f7dff06f          	j	800021e8 <__mulsf3+0x260>
80002270:	00090a93          	mv	s5,s2
80002274:	f21ff06f          	j	80002194 <__mulsf3+0x20c>
80002278:	00100793          	li	a5,1
8000227c:	40e787b3          	sub	a5,a5,a4
80002280:	01b00713          	li	a4,27
80002284:	06f74063          	blt	a4,a5,800022e4 <__mulsf3+0x35c>
80002288:	09ea8a93          	addi	s5,s5,158
8000228c:	00f457b3          	srl	a5,s0,a5
80002290:	01541433          	sll	s0,s0,s5
80002294:	00803433          	snez	s0,s0
80002298:	0087e433          	or	s0,a5,s0
8000229c:	00747793          	andi	a5,s0,7
800022a0:	00078a63          	beqz	a5,800022b4 <__mulsf3+0x32c>
800022a4:	00f47793          	andi	a5,s0,15
800022a8:	00400713          	li	a4,4
800022ac:	00e78463          	beq	a5,a4,800022b4 <__mulsf3+0x32c>
800022b0:	00440413          	addi	s0,s0,4
800022b4:	00541793          	slli	a5,s0,0x5
800022b8:	0207ca63          	bltz	a5,800022ec <__mulsf3+0x364>
800022bc:	00345793          	srli	a5,s0,0x3
800022c0:	00000713          	li	a4,0
800022c4:	f45ff06f          	j	80002208 <__mulsf3+0x280>
800022c8:	004007b7          	lui	a5,0x400
800022cc:	0ff00713          	li	a4,255
800022d0:	00000a13          	li	s4,0
800022d4:	f35ff06f          	j	80002208 <__mulsf3+0x280>
800022d8:	00000793          	li	a5,0
800022dc:	0ff00713          	li	a4,255
800022e0:	f29ff06f          	j	80002208 <__mulsf3+0x280>
800022e4:	00000793          	li	a5,0
800022e8:	fd9ff06f          	j	800022c0 <__mulsf3+0x338>
800022ec:	00000793          	li	a5,0
800022f0:	00100713          	li	a4,1
800022f4:	f15ff06f          	j	80002208 <__mulsf3+0x280>

800022f8 <__subsf3>:
800022f8:	008007b7          	lui	a5,0x800
800022fc:	fff78793          	addi	a5,a5,-1 # 7fffff <_stack_size+0x7ffbff>
80002300:	ff010113          	addi	sp,sp,-16
80002304:	00a7f733          	and	a4,a5,a0
80002308:	01755693          	srli	a3,a0,0x17
8000230c:	0175d613          	srli	a2,a1,0x17
80002310:	00b7f7b3          	and	a5,a5,a1
80002314:	00912223          	sw	s1,4(sp)
80002318:	01212023          	sw	s2,0(sp)
8000231c:	0ff6f693          	andi	a3,a3,255
80002320:	00371813          	slli	a6,a4,0x3
80002324:	0ff67613          	andi	a2,a2,255
80002328:	00112623          	sw	ra,12(sp)
8000232c:	00812423          	sw	s0,8(sp)
80002330:	0ff00713          	li	a4,255
80002334:	01f55493          	srli	s1,a0,0x1f
80002338:	00068913          	mv	s2,a3
8000233c:	00060513          	mv	a0,a2
80002340:	01f5d593          	srli	a1,a1,0x1f
80002344:	00379793          	slli	a5,a5,0x3
80002348:	00e61463          	bne	a2,a4,80002350 <__subsf3+0x58>
8000234c:	00079463          	bnez	a5,80002354 <__subsf3+0x5c>
80002350:	0015c593          	xori	a1,a1,1
80002354:	40c68733          	sub	a4,a3,a2
80002358:	1a959a63          	bne	a1,s1,8000250c <__subsf3+0x214>
8000235c:	0ae05663          	blez	a4,80002408 <__subsf3+0x110>
80002360:	06061663          	bnez	a2,800023cc <__subsf3+0xd4>
80002364:	00079c63          	bnez	a5,8000237c <__subsf3+0x84>
80002368:	0ff00793          	li	a5,255
8000236c:	04f68c63          	beq	a3,a5,800023c4 <__subsf3+0xcc>
80002370:	00080793          	mv	a5,a6
80002374:	00068513          	mv	a0,a3
80002378:	14c0006f          	j	800024c4 <__subsf3+0x1cc>
8000237c:	fff70713          	addi	a4,a4,-1
80002380:	02071e63          	bnez	a4,800023bc <__subsf3+0xc4>
80002384:	010787b3          	add	a5,a5,a6
80002388:	00068513          	mv	a0,a3
8000238c:	00579713          	slli	a4,a5,0x5
80002390:	12075a63          	bgez	a4,800024c4 <__subsf3+0x1cc>
80002394:	00150513          	addi	a0,a0,1
80002398:	0ff00713          	li	a4,255
8000239c:	32e50e63          	beq	a0,a4,800026d8 <__subsf3+0x3e0>
800023a0:	7e000737          	lui	a4,0x7e000
800023a4:	0017f693          	andi	a3,a5,1
800023a8:	fff70713          	addi	a4,a4,-1 # 7dffffff <_stack_size+0x7dfffbff>
800023ac:	0017d793          	srli	a5,a5,0x1
800023b0:	00e7f7b3          	and	a5,a5,a4
800023b4:	00d7e7b3          	or	a5,a5,a3
800023b8:	10c0006f          	j	800024c4 <__subsf3+0x1cc>
800023bc:	0ff00613          	li	a2,255
800023c0:	00c69e63          	bne	a3,a2,800023dc <__subsf3+0xe4>
800023c4:	00080793          	mv	a5,a6
800023c8:	0740006f          	j	8000243c <__subsf3+0x144>
800023cc:	0ff00613          	li	a2,255
800023d0:	fec68ae3          	beq	a3,a2,800023c4 <__subsf3+0xcc>
800023d4:	04000637          	lui	a2,0x4000
800023d8:	00c7e7b3          	or	a5,a5,a2
800023dc:	01b00613          	li	a2,27
800023e0:	00e65663          	ble	a4,a2,800023ec <__subsf3+0xf4>
800023e4:	00100793          	li	a5,1
800023e8:	f9dff06f          	j	80002384 <__subsf3+0x8c>
800023ec:	02000613          	li	a2,32
800023f0:	40e60633          	sub	a2,a2,a4
800023f4:	00e7d5b3          	srl	a1,a5,a4
800023f8:	00c797b3          	sll	a5,a5,a2
800023fc:	00f037b3          	snez	a5,a5
80002400:	00f5e7b3          	or	a5,a1,a5
80002404:	f81ff06f          	j	80002384 <__subsf3+0x8c>
80002408:	08070063          	beqz	a4,80002488 <__subsf3+0x190>
8000240c:	02069c63          	bnez	a3,80002444 <__subsf3+0x14c>
80002410:	00081863          	bnez	a6,80002420 <__subsf3+0x128>
80002414:	0ff00713          	li	a4,255
80002418:	0ae61663          	bne	a2,a4,800024c4 <__subsf3+0x1cc>
8000241c:	0200006f          	j	8000243c <__subsf3+0x144>
80002420:	fff00693          	li	a3,-1
80002424:	00d71663          	bne	a4,a3,80002430 <__subsf3+0x138>
80002428:	010787b3          	add	a5,a5,a6
8000242c:	f61ff06f          	j	8000238c <__subsf3+0x94>
80002430:	0ff00693          	li	a3,255
80002434:	fff74713          	not	a4,a4
80002438:	02d61063          	bne	a2,a3,80002458 <__subsf3+0x160>
8000243c:	0ff00513          	li	a0,255
80002440:	0840006f          	j	800024c4 <__subsf3+0x1cc>
80002444:	0ff00693          	li	a3,255
80002448:	fed60ae3          	beq	a2,a3,8000243c <__subsf3+0x144>
8000244c:	040006b7          	lui	a3,0x4000
80002450:	40e00733          	neg	a4,a4
80002454:	00d86833          	or	a6,a6,a3
80002458:	01b00693          	li	a3,27
8000245c:	00e6d663          	ble	a4,a3,80002468 <__subsf3+0x170>
80002460:	00100713          	li	a4,1
80002464:	01c0006f          	j	80002480 <__subsf3+0x188>
80002468:	02000693          	li	a3,32
8000246c:	00e85633          	srl	a2,a6,a4
80002470:	40e68733          	sub	a4,a3,a4
80002474:	00e81733          	sll	a4,a6,a4
80002478:	00e03733          	snez	a4,a4
8000247c:	00e66733          	or	a4,a2,a4
80002480:	00e787b3          	add	a5,a5,a4
80002484:	f09ff06f          	j	8000238c <__subsf3+0x94>
80002488:	00168513          	addi	a0,a3,1 # 4000001 <_stack_size+0x3fffc01>
8000248c:	0ff57613          	andi	a2,a0,255
80002490:	00100713          	li	a4,1
80002494:	06c74263          	blt	a4,a2,800024f8 <__subsf3+0x200>
80002498:	04069463          	bnez	a3,800024e0 <__subsf3+0x1e8>
8000249c:	00000513          	li	a0,0
800024a0:	02080263          	beqz	a6,800024c4 <__subsf3+0x1cc>
800024a4:	22078663          	beqz	a5,800026d0 <__subsf3+0x3d8>
800024a8:	010787b3          	add	a5,a5,a6
800024ac:	00579713          	slli	a4,a5,0x5
800024b0:	00075a63          	bgez	a4,800024c4 <__subsf3+0x1cc>
800024b4:	fc000737          	lui	a4,0xfc000
800024b8:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9b2f>
800024bc:	00e7f7b3          	and	a5,a5,a4
800024c0:	00100513          	li	a0,1
800024c4:	0077f713          	andi	a4,a5,7
800024c8:	20070a63          	beqz	a4,800026dc <__subsf3+0x3e4>
800024cc:	00f7f713          	andi	a4,a5,15
800024d0:	00400693          	li	a3,4
800024d4:	20d70463          	beq	a4,a3,800026dc <__subsf3+0x3e4>
800024d8:	00478793          	addi	a5,a5,4
800024dc:	2000006f          	j	800026dc <__subsf3+0x3e4>
800024e0:	f4080ee3          	beqz	a6,8000243c <__subsf3+0x144>
800024e4:	ee0780e3          	beqz	a5,800023c4 <__subsf3+0xcc>
800024e8:	020007b7          	lui	a5,0x2000
800024ec:	0ff00513          	li	a0,255
800024f0:	00000493          	li	s1,0
800024f4:	1e80006f          	j	800026dc <__subsf3+0x3e4>
800024f8:	0ff00713          	li	a4,255
800024fc:	1ce50e63          	beq	a0,a4,800026d8 <__subsf3+0x3e0>
80002500:	00f80733          	add	a4,a6,a5
80002504:	00175793          	srli	a5,a4,0x1
80002508:	fbdff06f          	j	800024c4 <__subsf3+0x1cc>
8000250c:	08e05063          	blez	a4,8000258c <__subsf3+0x294>
80002510:	04061663          	bnez	a2,8000255c <__subsf3+0x264>
80002514:	e4078ae3          	beqz	a5,80002368 <__subsf3+0x70>
80002518:	fff70713          	addi	a4,a4,-1
8000251c:	02071463          	bnez	a4,80002544 <__subsf3+0x24c>
80002520:	40f807b3          	sub	a5,a6,a5
80002524:	00068513          	mv	a0,a3
80002528:	00579713          	slli	a4,a5,0x5
8000252c:	f8075ce3          	bgez	a4,800024c4 <__subsf3+0x1cc>
80002530:	04000437          	lui	s0,0x4000
80002534:	fff40413          	addi	s0,s0,-1 # 3ffffff <_stack_size+0x3fffbff>
80002538:	0087f433          	and	s0,a5,s0
8000253c:	00050913          	mv	s2,a0
80002540:	1380006f          	j	80002678 <__subsf3+0x380>
80002544:	0ff00613          	li	a2,255
80002548:	e6c68ee3          	beq	a3,a2,800023c4 <__subsf3+0xcc>
8000254c:	01b00613          	li	a2,27
80002550:	02e65063          	ble	a4,a2,80002570 <__subsf3+0x278>
80002554:	00100793          	li	a5,1
80002558:	fc9ff06f          	j	80002520 <__subsf3+0x228>
8000255c:	0ff00613          	li	a2,255
80002560:	e6c682e3          	beq	a3,a2,800023c4 <__subsf3+0xcc>
80002564:	04000637          	lui	a2,0x4000
80002568:	00c7e7b3          	or	a5,a5,a2
8000256c:	fe1ff06f          	j	8000254c <__subsf3+0x254>
80002570:	02000613          	li	a2,32
80002574:	00e7d5b3          	srl	a1,a5,a4
80002578:	40e60733          	sub	a4,a2,a4
8000257c:	00e797b3          	sll	a5,a5,a4
80002580:	00f037b3          	snez	a5,a5
80002584:	00f5e7b3          	or	a5,a1,a5
80002588:	f99ff06f          	j	80002520 <__subsf3+0x228>
8000258c:	08070263          	beqz	a4,80002610 <__subsf3+0x318>
80002590:	02069e63          	bnez	a3,800025cc <__subsf3+0x2d4>
80002594:	00081863          	bnez	a6,800025a4 <__subsf3+0x2ac>
80002598:	0ff00713          	li	a4,255
8000259c:	00058493          	mv	s1,a1
800025a0:	e79ff06f          	j	80002418 <__subsf3+0x120>
800025a4:	fff00693          	li	a3,-1
800025a8:	00d71863          	bne	a4,a3,800025b8 <__subsf3+0x2c0>
800025ac:	410787b3          	sub	a5,a5,a6
800025b0:	00058493          	mv	s1,a1
800025b4:	f75ff06f          	j	80002528 <__subsf3+0x230>
800025b8:	0ff00693          	li	a3,255
800025bc:	fff74713          	not	a4,a4
800025c0:	02d61063          	bne	a2,a3,800025e0 <__subsf3+0x2e8>
800025c4:	00058493          	mv	s1,a1
800025c8:	e75ff06f          	j	8000243c <__subsf3+0x144>
800025cc:	0ff00693          	li	a3,255
800025d0:	fed60ae3          	beq	a2,a3,800025c4 <__subsf3+0x2cc>
800025d4:	040006b7          	lui	a3,0x4000
800025d8:	40e00733          	neg	a4,a4
800025dc:	00d86833          	or	a6,a6,a3
800025e0:	01b00693          	li	a3,27
800025e4:	00e6d663          	ble	a4,a3,800025f0 <__subsf3+0x2f8>
800025e8:	00100713          	li	a4,1
800025ec:	01c0006f          	j	80002608 <__subsf3+0x310>
800025f0:	02000693          	li	a3,32
800025f4:	00e85633          	srl	a2,a6,a4
800025f8:	40e68733          	sub	a4,a3,a4
800025fc:	00e81733          	sll	a4,a6,a4
80002600:	00e03733          	snez	a4,a4
80002604:	00e66733          	or	a4,a2,a4
80002608:	40e787b3          	sub	a5,a5,a4
8000260c:	fa5ff06f          	j	800025b0 <__subsf3+0x2b8>
80002610:	00168713          	addi	a4,a3,1 # 4000001 <_stack_size+0x3fffc01>
80002614:	0ff77713          	andi	a4,a4,255
80002618:	00100613          	li	a2,1
8000261c:	04e64463          	blt	a2,a4,80002664 <__subsf3+0x36c>
80002620:	02069c63          	bnez	a3,80002658 <__subsf3+0x360>
80002624:	00081863          	bnez	a6,80002634 <__subsf3+0x33c>
80002628:	12079863          	bnez	a5,80002758 <__subsf3+0x460>
8000262c:	00000513          	li	a0,0
80002630:	ec1ff06f          	j	800024f0 <__subsf3+0x1f8>
80002634:	12078663          	beqz	a5,80002760 <__subsf3+0x468>
80002638:	40f80733          	sub	a4,a6,a5
8000263c:	00571693          	slli	a3,a4,0x5
80002640:	410787b3          	sub	a5,a5,a6
80002644:	1006ca63          	bltz	a3,80002758 <__subsf3+0x460>
80002648:	00070793          	mv	a5,a4
8000264c:	06071063          	bnez	a4,800026ac <__subsf3+0x3b4>
80002650:	00000793          	li	a5,0
80002654:	fd9ff06f          	j	8000262c <__subsf3+0x334>
80002658:	e80816e3          	bnez	a6,800024e4 <__subsf3+0x1ec>
8000265c:	f60794e3          	bnez	a5,800025c4 <__subsf3+0x2cc>
80002660:	e89ff06f          	j	800024e8 <__subsf3+0x1f0>
80002664:	40f80433          	sub	s0,a6,a5
80002668:	00541713          	slli	a4,s0,0x5
8000266c:	04075463          	bgez	a4,800026b4 <__subsf3+0x3bc>
80002670:	41078433          	sub	s0,a5,a6
80002674:	00058493          	mv	s1,a1
80002678:	00040513          	mv	a0,s0
8000267c:	604000ef          	jal	ra,80002c80 <__clzsi2>
80002680:	ffb50513          	addi	a0,a0,-5
80002684:	00a41433          	sll	s0,s0,a0
80002688:	03254a63          	blt	a0,s2,800026bc <__subsf3+0x3c4>
8000268c:	41250533          	sub	a0,a0,s2
80002690:	00150513          	addi	a0,a0,1
80002694:	02000713          	li	a4,32
80002698:	00a457b3          	srl	a5,s0,a0
8000269c:	40a70533          	sub	a0,a4,a0
800026a0:	00a41433          	sll	s0,s0,a0
800026a4:	00803433          	snez	s0,s0
800026a8:	0087e7b3          	or	a5,a5,s0
800026ac:	00000513          	li	a0,0
800026b0:	e15ff06f          	j	800024c4 <__subsf3+0x1cc>
800026b4:	f8040ee3          	beqz	s0,80002650 <__subsf3+0x358>
800026b8:	fc1ff06f          	j	80002678 <__subsf3+0x380>
800026bc:	fc0007b7          	lui	a5,0xfc000
800026c0:	fff78793          	addi	a5,a5,-1 # fbffffff <_stack_start+0x7bff9b2f>
800026c4:	40a90533          	sub	a0,s2,a0
800026c8:	00f477b3          	and	a5,s0,a5
800026cc:	df9ff06f          	j	800024c4 <__subsf3+0x1cc>
800026d0:	00080793          	mv	a5,a6
800026d4:	df1ff06f          	j	800024c4 <__subsf3+0x1cc>
800026d8:	00000793          	li	a5,0
800026dc:	00579713          	slli	a4,a5,0x5
800026e0:	00075e63          	bgez	a4,800026fc <__subsf3+0x404>
800026e4:	00150513          	addi	a0,a0,1
800026e8:	0ff00713          	li	a4,255
800026ec:	06e50e63          	beq	a0,a4,80002768 <__subsf3+0x470>
800026f0:	fc000737          	lui	a4,0xfc000
800026f4:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9b2f>
800026f8:	00e7f7b3          	and	a5,a5,a4
800026fc:	0ff00713          	li	a4,255
80002700:	0037d793          	srli	a5,a5,0x3
80002704:	00e51863          	bne	a0,a4,80002714 <__subsf3+0x41c>
80002708:	00078663          	beqz	a5,80002714 <__subsf3+0x41c>
8000270c:	004007b7          	lui	a5,0x400
80002710:	00000493          	li	s1,0
80002714:	00800737          	lui	a4,0x800
80002718:	fff70713          	addi	a4,a4,-1 # 7fffff <_stack_size+0x7ffbff>
8000271c:	0ff57513          	andi	a0,a0,255
80002720:	00e7f7b3          	and	a5,a5,a4
80002724:	01751713          	slli	a4,a0,0x17
80002728:	80800537          	lui	a0,0x80800
8000272c:	00c12083          	lw	ra,12(sp)
80002730:	00812403          	lw	s0,8(sp)
80002734:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9b2f>
80002738:	00a7f533          	and	a0,a5,a0
8000273c:	01f49493          	slli	s1,s1,0x1f
80002740:	00e56533          	or	a0,a0,a4
80002744:	00956533          	or	a0,a0,s1
80002748:	00012903          	lw	s2,0(sp)
8000274c:	00412483          	lw	s1,4(sp)
80002750:	01010113          	addi	sp,sp,16
80002754:	00008067          	ret
80002758:	00058493          	mv	s1,a1
8000275c:	f51ff06f          	j	800026ac <__subsf3+0x3b4>
80002760:	00080793          	mv	a5,a6
80002764:	f49ff06f          	j	800026ac <__subsf3+0x3b4>
80002768:	00000793          	li	a5,0
8000276c:	f91ff06f          	j	800026fc <__subsf3+0x404>

80002770 <__fixsfsi>:
80002770:	00800637          	lui	a2,0x800
80002774:	01755713          	srli	a4,a0,0x17
80002778:	fff60793          	addi	a5,a2,-1 # 7fffff <_stack_size+0x7ffbff>
8000277c:	0ff77713          	andi	a4,a4,255
80002780:	07e00593          	li	a1,126
80002784:	00a7f7b3          	and	a5,a5,a0
80002788:	01f55693          	srli	a3,a0,0x1f
8000278c:	04e5f663          	bleu	a4,a1,800027d8 <__fixsfsi+0x68>
80002790:	09d00593          	li	a1,157
80002794:	00e5fa63          	bleu	a4,a1,800027a8 <__fixsfsi+0x38>
80002798:	80000537          	lui	a0,0x80000
8000279c:	fff54513          	not	a0,a0
800027a0:	00a68533          	add	a0,a3,a0
800027a4:	00008067          	ret
800027a8:	00c7e533          	or	a0,a5,a2
800027ac:	09500793          	li	a5,149
800027b0:	00e7dc63          	ble	a4,a5,800027c8 <__fixsfsi+0x58>
800027b4:	f6a70713          	addi	a4,a4,-150
800027b8:	00e51533          	sll	a0,a0,a4
800027bc:	02068063          	beqz	a3,800027dc <__fixsfsi+0x6c>
800027c0:	40a00533          	neg	a0,a0
800027c4:	00008067          	ret
800027c8:	09600793          	li	a5,150
800027cc:	40e78733          	sub	a4,a5,a4
800027d0:	00e55533          	srl	a0,a0,a4
800027d4:	fe9ff06f          	j	800027bc <__fixsfsi+0x4c>
800027d8:	00000513          	li	a0,0
800027dc:	00008067          	ret

800027e0 <__floatsisf>:
800027e0:	ff010113          	addi	sp,sp,-16
800027e4:	00112623          	sw	ra,12(sp)
800027e8:	00812423          	sw	s0,8(sp)
800027ec:	00912223          	sw	s1,4(sp)
800027f0:	10050263          	beqz	a0,800028f4 <__floatsisf+0x114>
800027f4:	00050413          	mv	s0,a0
800027f8:	01f55493          	srli	s1,a0,0x1f
800027fc:	00055463          	bgez	a0,80002804 <__floatsisf+0x24>
80002800:	40a00433          	neg	s0,a0
80002804:	00040513          	mv	a0,s0
80002808:	478000ef          	jal	ra,80002c80 <__clzsi2>
8000280c:	09e00793          	li	a5,158
80002810:	40a787b3          	sub	a5,a5,a0
80002814:	09600713          	li	a4,150
80002818:	06f74063          	blt	a4,a5,80002878 <__floatsisf+0x98>
8000281c:	00800713          	li	a4,8
80002820:	00a75663          	ble	a0,a4,8000282c <__floatsisf+0x4c>
80002824:	ff850513          	addi	a0,a0,-8 # 7ffffff8 <_stack_start+0xffff9b28>
80002828:	00a41433          	sll	s0,s0,a0
8000282c:	00800537          	lui	a0,0x800
80002830:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80002834:	0ff7f793          	andi	a5,a5,255
80002838:	00a47433          	and	s0,s0,a0
8000283c:	01779513          	slli	a0,a5,0x17
80002840:	808007b7          	lui	a5,0x80800
80002844:	fff78793          	addi	a5,a5,-1 # 807fffff <_stack_start+0x7f9b2f>
80002848:	00f47433          	and	s0,s0,a5
8000284c:	800007b7          	lui	a5,0x80000
80002850:	00a46433          	or	s0,s0,a0
80002854:	fff7c793          	not	a5,a5
80002858:	01f49513          	slli	a0,s1,0x1f
8000285c:	00f47433          	and	s0,s0,a5
80002860:	00a46533          	or	a0,s0,a0
80002864:	00c12083          	lw	ra,12(sp)
80002868:	00812403          	lw	s0,8(sp)
8000286c:	00412483          	lw	s1,4(sp)
80002870:	01010113          	addi	sp,sp,16
80002874:	00008067          	ret
80002878:	09900713          	li	a4,153
8000287c:	02f75063          	ble	a5,a4,8000289c <__floatsisf+0xbc>
80002880:	00500713          	li	a4,5
80002884:	40a70733          	sub	a4,a4,a0
80002888:	01b50693          	addi	a3,a0,27
8000288c:	00e45733          	srl	a4,s0,a4
80002890:	00d41433          	sll	s0,s0,a3
80002894:	00803433          	snez	s0,s0
80002898:	00876433          	or	s0,a4,s0
8000289c:	00500713          	li	a4,5
800028a0:	00a75663          	ble	a0,a4,800028ac <__floatsisf+0xcc>
800028a4:	ffb50713          	addi	a4,a0,-5
800028a8:	00e41433          	sll	s0,s0,a4
800028ac:	fc000737          	lui	a4,0xfc000
800028b0:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9b2f>
800028b4:	00747693          	andi	a3,s0,7
800028b8:	00e47733          	and	a4,s0,a4
800028bc:	00068a63          	beqz	a3,800028d0 <__floatsisf+0xf0>
800028c0:	00f47413          	andi	s0,s0,15
800028c4:	00400693          	li	a3,4
800028c8:	00d40463          	beq	s0,a3,800028d0 <__floatsisf+0xf0>
800028cc:	00470713          	addi	a4,a4,4
800028d0:	00571693          	slli	a3,a4,0x5
800028d4:	0006dc63          	bgez	a3,800028ec <__floatsisf+0x10c>
800028d8:	fc0007b7          	lui	a5,0xfc000
800028dc:	fff78793          	addi	a5,a5,-1 # fbffffff <_stack_start+0x7bff9b2f>
800028e0:	00f77733          	and	a4,a4,a5
800028e4:	09f00793          	li	a5,159
800028e8:	40a787b3          	sub	a5,a5,a0
800028ec:	00375413          	srli	s0,a4,0x3
800028f0:	f3dff06f          	j	8000282c <__floatsisf+0x4c>
800028f4:	00000413          	li	s0,0
800028f8:	00000793          	li	a5,0
800028fc:	00000493          	li	s1,0
80002900:	f2dff06f          	j	8000282c <__floatsisf+0x4c>

80002904 <__extendsfdf2>:
80002904:	01755793          	srli	a5,a0,0x17
80002908:	ff010113          	addi	sp,sp,-16
8000290c:	0ff7f793          	andi	a5,a5,255
80002910:	00812423          	sw	s0,8(sp)
80002914:	00178713          	addi	a4,a5,1
80002918:	00800437          	lui	s0,0x800
8000291c:	00912223          	sw	s1,4(sp)
80002920:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002924:	00112623          	sw	ra,12(sp)
80002928:	0ff77713          	andi	a4,a4,255
8000292c:	00100693          	li	a3,1
80002930:	00a47433          	and	s0,s0,a0
80002934:	01f55493          	srli	s1,a0,0x1f
80002938:	06e6d263          	ble	a4,a3,8000299c <__extendsfdf2+0x98>
8000293c:	38078513          	addi	a0,a5,896
80002940:	00345793          	srli	a5,s0,0x3
80002944:	01d41413          	slli	s0,s0,0x1d
80002948:	00100737          	lui	a4,0x100
8000294c:	fff70713          	addi	a4,a4,-1 # fffff <_stack_size+0xffbff>
80002950:	00e7f7b3          	and	a5,a5,a4
80002954:	80100737          	lui	a4,0x80100
80002958:	fff70713          	addi	a4,a4,-1 # 800fffff <_stack_start+0xf9b2f>
8000295c:	7ff57513          	andi	a0,a0,2047
80002960:	01451513          	slli	a0,a0,0x14
80002964:	00e7f7b3          	and	a5,a5,a4
80002968:	80000737          	lui	a4,0x80000
8000296c:	00a7e7b3          	or	a5,a5,a0
80002970:	fff74713          	not	a4,a4
80002974:	01f49513          	slli	a0,s1,0x1f
80002978:	00e7f7b3          	and	a5,a5,a4
8000297c:	00a7e733          	or	a4,a5,a0
80002980:	00c12083          	lw	ra,12(sp)
80002984:	00040513          	mv	a0,s0
80002988:	00812403          	lw	s0,8(sp)
8000298c:	00412483          	lw	s1,4(sp)
80002990:	00070593          	mv	a1,a4
80002994:	01010113          	addi	sp,sp,16
80002998:	00008067          	ret
8000299c:	04079463          	bnez	a5,800029e4 <__extendsfdf2+0xe0>
800029a0:	06040263          	beqz	s0,80002a04 <__extendsfdf2+0x100>
800029a4:	00040513          	mv	a0,s0
800029a8:	2d8000ef          	jal	ra,80002c80 <__clzsi2>
800029ac:	00a00793          	li	a5,10
800029b0:	02a7c263          	blt	a5,a0,800029d4 <__extendsfdf2+0xd0>
800029b4:	00b00793          	li	a5,11
800029b8:	40a787b3          	sub	a5,a5,a0
800029bc:	01550713          	addi	a4,a0,21
800029c0:	00f457b3          	srl	a5,s0,a5
800029c4:	00e41433          	sll	s0,s0,a4
800029c8:	38900713          	li	a4,905
800029cc:	40a70533          	sub	a0,a4,a0
800029d0:	f79ff06f          	j	80002948 <__extendsfdf2+0x44>
800029d4:	ff550793          	addi	a5,a0,-11
800029d8:	00f417b3          	sll	a5,s0,a5
800029dc:	00000413          	li	s0,0
800029e0:	fe9ff06f          	j	800029c8 <__extendsfdf2+0xc4>
800029e4:	00000793          	li	a5,0
800029e8:	00040a63          	beqz	s0,800029fc <__extendsfdf2+0xf8>
800029ec:	00345793          	srli	a5,s0,0x3
800029f0:	00080737          	lui	a4,0x80
800029f4:	01d41413          	slli	s0,s0,0x1d
800029f8:	00e7e7b3          	or	a5,a5,a4
800029fc:	7ff00513          	li	a0,2047
80002a00:	f49ff06f          	j	80002948 <__extendsfdf2+0x44>
80002a04:	00000793          	li	a5,0
80002a08:	00000513          	li	a0,0
80002a0c:	f3dff06f          	j	80002948 <__extendsfdf2+0x44>

80002a10 <__truncdfsf2>:
80002a10:	00100637          	lui	a2,0x100
80002a14:	fff60613          	addi	a2,a2,-1 # fffff <_stack_size+0xffbff>
80002a18:	00b67633          	and	a2,a2,a1
80002a1c:	0145d813          	srli	a6,a1,0x14
80002a20:	01d55793          	srli	a5,a0,0x1d
80002a24:	7ff87813          	andi	a6,a6,2047
80002a28:	00361613          	slli	a2,a2,0x3
80002a2c:	00c7e633          	or	a2,a5,a2
80002a30:	00180793          	addi	a5,a6,1
80002a34:	7ff7f793          	andi	a5,a5,2047
80002a38:	00100693          	li	a3,1
80002a3c:	01f5d593          	srli	a1,a1,0x1f
80002a40:	00351713          	slli	a4,a0,0x3
80002a44:	0af6d663          	ble	a5,a3,80002af0 <__truncdfsf2+0xe0>
80002a48:	c8080693          	addi	a3,a6,-896
80002a4c:	0fe00793          	li	a5,254
80002a50:	0cd7c263          	blt	a5,a3,80002b14 <__truncdfsf2+0x104>
80002a54:	08d04063          	bgtz	a3,80002ad4 <__truncdfsf2+0xc4>
80002a58:	fe900793          	li	a5,-23
80002a5c:	12f6c463          	blt	a3,a5,80002b84 <__truncdfsf2+0x174>
80002a60:	008007b7          	lui	a5,0x800
80002a64:	01e00513          	li	a0,30
80002a68:	00f66633          	or	a2,a2,a5
80002a6c:	40d50533          	sub	a0,a0,a3
80002a70:	01f00793          	li	a5,31
80002a74:	02a7c863          	blt	a5,a0,80002aa4 <__truncdfsf2+0x94>
80002a78:	c8280813          	addi	a6,a6,-894
80002a7c:	010717b3          	sll	a5,a4,a6
80002a80:	00f037b3          	snez	a5,a5
80002a84:	01061633          	sll	a2,a2,a6
80002a88:	00a75533          	srl	a0,a4,a0
80002a8c:	00c7e7b3          	or	a5,a5,a2
80002a90:	00f567b3          	or	a5,a0,a5
80002a94:	00000693          	li	a3,0
80002a98:	0077f713          	andi	a4,a5,7
80002a9c:	08070063          	beqz	a4,80002b1c <__truncdfsf2+0x10c>
80002aa0:	0ec0006f          	j	80002b8c <__truncdfsf2+0x17c>
80002aa4:	ffe00793          	li	a5,-2
80002aa8:	40d786b3          	sub	a3,a5,a3
80002aac:	02000793          	li	a5,32
80002ab0:	00d656b3          	srl	a3,a2,a3
80002ab4:	00000893          	li	a7,0
80002ab8:	00f50663          	beq	a0,a5,80002ac4 <__truncdfsf2+0xb4>
80002abc:	ca280813          	addi	a6,a6,-862
80002ac0:	010618b3          	sll	a7,a2,a6
80002ac4:	00e8e7b3          	or	a5,a7,a4
80002ac8:	00f037b3          	snez	a5,a5
80002acc:	00f6e7b3          	or	a5,a3,a5
80002ad0:	fc5ff06f          	j	80002a94 <__truncdfsf2+0x84>
80002ad4:	00651513          	slli	a0,a0,0x6
80002ad8:	00a03533          	snez	a0,a0
80002adc:	00361613          	slli	a2,a2,0x3
80002ae0:	01d75793          	srli	a5,a4,0x1d
80002ae4:	00c56633          	or	a2,a0,a2
80002ae8:	00f667b3          	or	a5,a2,a5
80002aec:	fadff06f          	j	80002a98 <__truncdfsf2+0x88>
80002af0:	00e667b3          	or	a5,a2,a4
80002af4:	00081663          	bnez	a6,80002b00 <__truncdfsf2+0xf0>
80002af8:	00f037b3          	snez	a5,a5
80002afc:	f99ff06f          	j	80002a94 <__truncdfsf2+0x84>
80002b00:	0ff00693          	li	a3,255
80002b04:	00078c63          	beqz	a5,80002b1c <__truncdfsf2+0x10c>
80002b08:	00361613          	slli	a2,a2,0x3
80002b0c:	020007b7          	lui	a5,0x2000
80002b10:	fd9ff06f          	j	80002ae8 <__truncdfsf2+0xd8>
80002b14:	00000793          	li	a5,0
80002b18:	0ff00693          	li	a3,255
80002b1c:	00579713          	slli	a4,a5,0x5
80002b20:	00075e63          	bgez	a4,80002b3c <__truncdfsf2+0x12c>
80002b24:	00168693          	addi	a3,a3,1
80002b28:	0ff00713          	li	a4,255
80002b2c:	06e68a63          	beq	a3,a4,80002ba0 <__truncdfsf2+0x190>
80002b30:	fc000737          	lui	a4,0xfc000
80002b34:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9b2f>
80002b38:	00e7f7b3          	and	a5,a5,a4
80002b3c:	0ff00713          	li	a4,255
80002b40:	0037d793          	srli	a5,a5,0x3
80002b44:	00e69863          	bne	a3,a4,80002b54 <__truncdfsf2+0x144>
80002b48:	00078663          	beqz	a5,80002b54 <__truncdfsf2+0x144>
80002b4c:	004007b7          	lui	a5,0x400
80002b50:	00000593          	li	a1,0
80002b54:	00800537          	lui	a0,0x800
80002b58:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80002b5c:	00a7f7b3          	and	a5,a5,a0
80002b60:	80800537          	lui	a0,0x80800
80002b64:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9b2f>
80002b68:	0ff6f693          	andi	a3,a3,255
80002b6c:	01769693          	slli	a3,a3,0x17
80002b70:	00a7f7b3          	and	a5,a5,a0
80002b74:	01f59593          	slli	a1,a1,0x1f
80002b78:	00d7e7b3          	or	a5,a5,a3
80002b7c:	00b7e533          	or	a0,a5,a1
80002b80:	00008067          	ret
80002b84:	00100793          	li	a5,1
80002b88:	00000693          	li	a3,0
80002b8c:	00f7f713          	andi	a4,a5,15
80002b90:	00400613          	li	a2,4
80002b94:	f8c704e3          	beq	a4,a2,80002b1c <__truncdfsf2+0x10c>
80002b98:	00478793          	addi	a5,a5,4 # 400004 <_stack_size+0x3ffc04>
80002b9c:	f81ff06f          	j	80002b1c <__truncdfsf2+0x10c>
80002ba0:	00000793          	li	a5,0
80002ba4:	f99ff06f          	j	80002b3c <__truncdfsf2+0x12c>

80002ba8 <__mulsi3>:
80002ba8:	00050613          	mv	a2,a0
80002bac:	00000513          	li	a0,0
80002bb0:	0015f693          	andi	a3,a1,1
80002bb4:	00068463          	beqz	a3,80002bbc <__mulsi3+0x14>
80002bb8:	00c50533          	add	a0,a0,a2
80002bbc:	0015d593          	srli	a1,a1,0x1
80002bc0:	00161613          	slli	a2,a2,0x1
80002bc4:	fe0596e3          	bnez	a1,80002bb0 <__mulsi3+0x8>
80002bc8:	00008067          	ret

80002bcc <__divsi3>:
80002bcc:	06054063          	bltz	a0,80002c2c <__umodsi3+0x10>
80002bd0:	0605c663          	bltz	a1,80002c3c <__umodsi3+0x20>

80002bd4 <__udivsi3>:
80002bd4:	00058613          	mv	a2,a1
80002bd8:	00050593          	mv	a1,a0
80002bdc:	fff00513          	li	a0,-1
80002be0:	02060c63          	beqz	a2,80002c18 <__udivsi3+0x44>
80002be4:	00100693          	li	a3,1
80002be8:	00b67a63          	bleu	a1,a2,80002bfc <__udivsi3+0x28>
80002bec:	00c05863          	blez	a2,80002bfc <__udivsi3+0x28>
80002bf0:	00161613          	slli	a2,a2,0x1
80002bf4:	00169693          	slli	a3,a3,0x1
80002bf8:	feb66ae3          	bltu	a2,a1,80002bec <__udivsi3+0x18>
80002bfc:	00000513          	li	a0,0
80002c00:	00c5e663          	bltu	a1,a2,80002c0c <__udivsi3+0x38>
80002c04:	40c585b3          	sub	a1,a1,a2
80002c08:	00d56533          	or	a0,a0,a3
80002c0c:	0016d693          	srli	a3,a3,0x1
80002c10:	00165613          	srli	a2,a2,0x1
80002c14:	fe0696e3          	bnez	a3,80002c00 <__udivsi3+0x2c>
80002c18:	00008067          	ret

80002c1c <__umodsi3>:
80002c1c:	00008293          	mv	t0,ra
80002c20:	fb5ff0ef          	jal	ra,80002bd4 <__udivsi3>
80002c24:	00058513          	mv	a0,a1
80002c28:	00028067          	jr	t0
80002c2c:	40a00533          	neg	a0,a0
80002c30:	0005d863          	bgez	a1,80002c40 <__umodsi3+0x24>
80002c34:	40b005b3          	neg	a1,a1
80002c38:	f9dff06f          	j	80002bd4 <__udivsi3>
80002c3c:	40b005b3          	neg	a1,a1
80002c40:	00008293          	mv	t0,ra
80002c44:	f91ff0ef          	jal	ra,80002bd4 <__udivsi3>
80002c48:	40a00533          	neg	a0,a0
80002c4c:	00028067          	jr	t0

80002c50 <__modsi3>:
80002c50:	00008293          	mv	t0,ra
80002c54:	0005ca63          	bltz	a1,80002c68 <__modsi3+0x18>
80002c58:	00054c63          	bltz	a0,80002c70 <__modsi3+0x20>
80002c5c:	f79ff0ef          	jal	ra,80002bd4 <__udivsi3>
80002c60:	00058513          	mv	a0,a1
80002c64:	00028067          	jr	t0
80002c68:	40b005b3          	neg	a1,a1
80002c6c:	fe0558e3          	bgez	a0,80002c5c <__modsi3+0xc>
80002c70:	40a00533          	neg	a0,a0
80002c74:	f61ff0ef          	jal	ra,80002bd4 <__udivsi3>
80002c78:	40b00533          	neg	a0,a1
80002c7c:	00028067          	jr	t0

80002c80 <__clzsi2>:
80002c80:	000107b7          	lui	a5,0x10
80002c84:	02f57a63          	bleu	a5,a0,80002cb8 <__clzsi2+0x38>
80002c88:	0ff00793          	li	a5,255
80002c8c:	00a7b7b3          	sltu	a5,a5,a0
80002c90:	00379793          	slli	a5,a5,0x3
80002c94:	02000713          	li	a4,32
80002c98:	40f70733          	sub	a4,a4,a5
80002c9c:	00f557b3          	srl	a5,a0,a5
80002ca0:	00000517          	auipc	a0,0x0
80002ca4:	6fc50513          	addi	a0,a0,1788 # 8000339c <__clz_tab>
80002ca8:	00f507b3          	add	a5,a0,a5
80002cac:	0007c503          	lbu	a0,0(a5) # 10000 <_stack_size+0xfc00>
80002cb0:	40a70533          	sub	a0,a4,a0
80002cb4:	00008067          	ret
80002cb8:	01000737          	lui	a4,0x1000
80002cbc:	01000793          	li	a5,16
80002cc0:	fce56ae3          	bltu	a0,a4,80002c94 <__clzsi2+0x14>
80002cc4:	01800793          	li	a5,24
80002cc8:	fcdff06f          	j	80002c94 <__clzsi2+0x14>

Disassembly of section .text.startup:

80002ccc <main>:
int main() {
80002ccc:	1141                	addi	sp,sp,-16
80002cce:	c606                	sw	ra,12(sp)
	main2();
80002cd0:	d4cfd0ef          	jal	ra,8000021c <main2>
}
80002cd4:	40b2                	lw	ra,12(sp)
	TEST_COM_BASE[8] = 0;
80002cd6:	f01007b7          	lui	a5,0xf0100
80002cda:	f207a023          	sw	zero,-224(a5) # f00fff20 <_stack_start+0x700f9a50>
}
80002cde:	4501                	li	a0,0
80002ce0:	0141                	addi	sp,sp,16
80002ce2:	8082                	ret
