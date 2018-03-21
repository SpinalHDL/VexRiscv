
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
8000007e:	82e18193          	addi	gp,gp,-2002 # 800038a8 <__global_pointer$>
  .option pop
  la sp, _stack_start
80000082:	00006117          	auipc	sp,0x6
80000086:	04e10113          	addi	sp,sp,78 # 800060d0 <_stack_start>

8000008a <bss_init>:

bss_init:
  la a0, _bss_start
8000008a:	81c18513          	addi	a0,gp,-2020 # 800030c4 <Dhrystones_Per_Second>
  la a1, _bss_end
8000008e:	00006597          	auipc	a1,0x6
80000092:	c3e58593          	addi	a1,a1,-962 # 80005ccc <_bss_end>

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
800000a6:	00250513          	addi	a0,a0,2 # 800030a4 <_ctors_end>
  addi sp,sp,-4
800000aa:	1171                	addi	sp,sp,-4

800000ac <ctors_loop>:
ctors_loop:
  la a1, _ctors_end
800000ac:	00003597          	auipc	a1,0x3
800000b0:	ff858593          	addi	a1,a1,-8 # 800030a4 <_ctors_end>
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
800000c6:	00f020ef          	jal	ra,800028d4 <end>

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
800000ce:	8351c703          	lbu	a4,-1995(gp) # 800030dd <Ch_1_Glob>
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
800000de:	83c1a703          	lw	a4,-1988(gp) # 800030e4 <Int_Glob>
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
800000ea:	8441a603          	lw	a2,-1980(gp) # 800030ec <Ptr_Glob>
800000ee:	c609                	beqz	a2,800000f8 <Proc_3+0xe>
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
800000f0:	4218                	lw	a4,0(a2)
800000f2:	c118                	sw	a4,0(a0)
800000f4:	8441a603          	lw	a2,-1980(gp) # 800030ec <Ptr_Glob>
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
800000f8:	83c1a583          	lw	a1,-1988(gp) # 800030e4 <Int_Glob>
800000fc:	0631                	addi	a2,a2,12
800000fe:	4529                	li	a0,10
80000100:	6c80006f          	j	800007c8 <Proc_7>

80000104 <Proc_1>:
{
80000104:	1141                	addi	sp,sp,-16
80000106:	c04a                	sw	s2,0(sp)
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
80000108:	8441a783          	lw	a5,-1980(gp) # 800030ec <Ptr_Glob>
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
800001cc:	69e000ef          	jal	ra,8000086a <Proc_6>
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
800001d0:	8441a783          	lw	a5,-1980(gp) # 800030ec <Ptr_Glob>
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
800001ea:	5de0006f          	j	800007c8 <Proc_7>

800001ee <Proc_4>:
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
800001ee:	8351c783          	lbu	a5,-1995(gp) # 800030dd <Ch_1_Glob>
  Bool_Glob = Bool_Loc | Bool_Glob;
800001f2:	8381a683          	lw	a3,-1992(gp) # 800030e0 <Bool_Glob>
  Bool_Loc = Ch_1_Glob == 'A';
800001f6:	fbf78793          	addi	a5,a5,-65
800001fa:	0017b793          	seqz	a5,a5
  Bool_Glob = Bool_Loc | Bool_Glob;
800001fe:	8fd5                	or	a5,a5,a3
80000200:	82f1ac23          	sw	a5,-1992(gp) # 800030e0 <Bool_Glob>
  Ch_2_Glob = 'B';
80000204:	04200713          	li	a4,66
80000208:	82e18a23          	sb	a4,-1996(gp) # 800030dc <Ch_2_Glob>
} /* Proc_4 */
8000020c:	8082                	ret

8000020e <Proc_5>:

Proc_5 () /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
8000020e:	04100713          	li	a4,65
80000212:	82e18aa3          	sb	a4,-1995(gp) # 800030dd <Ch_1_Glob>
  Bool_Glob = false;
80000216:	8201ac23          	sw	zero,-1992(gp) # 800030e0 <Bool_Glob>
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
80000226:	dae6                	sw	s9,116(sp)
80000228:	d6ee                	sw	s11,108(sp)
8000022a:	cb26                	sw	s1,148(sp)
8000022c:	c94a                	sw	s2,144(sp)
8000022e:	c74e                	sw	s3,140(sp)
80000230:	c552                	sw	s4,136(sp)
80000232:	c356                	sw	s5,132(sp)
80000234:	c15a                	sw	s6,128(sp)
80000236:	dede                	sw	s7,124(sp)
80000238:	dce2                	sw	s8,120(sp)
8000023a:	d8ea                	sw	s10,112(sp)
  Next_Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
8000023c:	714000ef          	jal	ra,80000950 <malloc>
80000240:	84a1a023          	sw	a0,-1984(gp) # 800030e8 <Next_Ptr_Glob>
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
80000244:	03000513          	li	a0,48
80000248:	708000ef          	jal	ra,80000950 <malloc>
  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
8000024c:	8401a783          	lw	a5,-1984(gp) # 800030e8 <Next_Ptr_Glob>
  Ptr_Glob = (Rec_Pointer) malloc (sizeof (Rec_Type));
80000250:	84a1a223          	sw	a0,-1980(gp) # 800030ec <Ptr_Glob>
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
80000266:	8ec58593          	addi	a1,a1,-1812 # 800028ec <_stack_start+0xffffc81c>
  Ptr_Glob->Discr                       = Ident_1;
8000026a:	00052223          	sw	zero,4(a0)
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
8000026e:	0541                	addi	a0,a0,16
80000270:	7e4000ef          	jal	ra,80000a54 <memcpy>
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
80000274:	80003737          	lui	a4,0x80003
80000278:	e5470793          	addi	a5,a4,-428 # 80002e54 <_stack_start+0xffffcd84>
8000027c:	e5472e03          	lw	t3,-428(a4)
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
800002a6:	1bcd8713          	addi	a4,s11,444 # 800031bc <_stack_start+0xffffd0ec>
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
800002c0:	77e000ef          	jal	ra,80000a3e <putchar>
  printf ("Dhrystone Benchmark, Version 2.1 (Language: C)\n");
800002c4:	80003537          	lui	a0,0x80003
800002c8:	90c50513          	addi	a0,a0,-1780 # 8000290c <_stack_start+0xffffc83c>
800002cc:	74c000ef          	jal	ra,80000a18 <puts>
  printf ("\n");
800002d0:	4529                	li	a0,10
800002d2:	76c000ef          	jal	ra,80000a3e <putchar>
  if (Reg)
800002d6:	8301a783          	lw	a5,-2000(gp) # 800030d8 <Reg>
800002da:	4a078e63          	beqz	a5,80000796 <main2+0x57a>
    printf ("Program compiled with 'register' attribute\n");
800002de:	80003537          	lui	a0,0x80003
800002e2:	93c50513          	addi	a0,a0,-1732 # 8000293c <_stack_start+0xffffc86c>
800002e6:	732000ef          	jal	ra,80000a18 <puts>
    printf ("\n");
800002ea:	4529                	li	a0,10
800002ec:	752000ef          	jal	ra,80000a3e <putchar>
  printf ("Please give the number of runs through the benchmark: ");
800002f0:	80003537          	lui	a0,0x80003
800002f4:	99850513          	addi	a0,a0,-1640 # 80002998 <_stack_start+0xffffc8c8>
800002f8:	67a000ef          	jal	ra,80000972 <printf>
  printf ("\n");
800002fc:	4529                	li	a0,10
800002fe:	740000ef          	jal	ra,80000a3e <putchar>
  printf ("Execution starts, %d runs through Dhrystone\n", Number_Of_Runs);
80000302:	80003537          	lui	a0,0x80003
80000306:	0c800593          	li	a1,200
8000030a:	9d050513          	addi	a0,a0,-1584 # 800029d0 <_stack_start+0xffffc900>
8000030e:	664000ef          	jal	ra,80000972 <printf>
  Begin_Time = clock();
80000312:	736000ef          	jal	ra,80000a48 <clock>
80000316:	80003437          	lui	s0,0x80003
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
8000031a:	e7442783          	lw	a5,-396(s0) # 80002e74 <_stack_start+0xffffcda4>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
8000031e:	80003d37          	lui	s10,0x80003
80000322:	e94d2c03          	lw	s8,-364(s10) # 80002e94 <_stack_start+0xffffcdc4>
    strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
80000326:	c63e                	sw	a5,12(sp)
  Begin_Time = clock();
80000328:	82a1a623          	sw	a0,-2004(gp) # 800030d4 <Begin_Time>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
8000032c:	4985                	li	s3,1
8000032e:	e7440413          	addi	s0,s0,-396
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
80000354:	4eb2                	lw	t4,12(sp)
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
80000376:	2955                	jal	8000082a <Func_2>
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
80000378:	4652                	lw	a2,20(sp)
    Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
8000037a:	00153513          	seqz	a0,a0
8000037e:	82a1ac23          	sw	a0,-1992(gp) # 800030e0 <Bool_Glob>
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
80000396:	290d                	jal	800007c8 <Proc_7>
      Int_1_Loc += 1;
80000398:	4652                	lw	a2,20(sp)
8000039a:	0605                	addi	a2,a2,1
8000039c:	ca32                	sw	a2,20(sp)
    while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
8000039e:	fec4d4e3          	ble	a2,s1,80000386 <main2+0x16a>
    Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
800003a2:	46e2                	lw	a3,24(sp)
800003a4:	84c18513          	addi	a0,gp,-1972 # 800030f4 <Arr_1_Glob>
800003a8:	1bcd8593          	addi	a1,s11,444
800003ac:	2115                	jal	800007d0 <Proc_8>
    Proc_1 (Ptr_Glob);
800003ae:	8441a503          	lw	a0,-1980(gp) # 800030ec <Ptr_Glob>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003b2:	04100a93          	li	s5,65
    Int_2_Loc = 3;
800003b6:	4a0d                	li	s4,3
    Proc_1 (Ptr_Glob);
800003b8:	33b1                	jal	80000104 <Proc_1>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003ba:	8341c703          	lbu	a4,-1996(gp) # 800030dc <Ch_2_Glob>
800003be:	04000793          	li	a5,64
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
800003c2:	e94d0b13          	addi	s6,s10,-364
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003c6:	02e7f163          	bleu	a4,a5,800003e8 <main2+0x1cc>
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
800003ca:	8556                	mv	a0,s5
800003cc:	04300593          	li	a1,67
800003d0:	2189                	jal	80000812 <Func_1>
800003d2:	47f2                	lw	a5,28(sp)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003d4:	001a8713          	addi	a4,s5,1
      if (Enum_Loc == Func_1 (Ch_Index, 'C'))
800003d8:	36f50663          	beq	a0,a5,80000744 <main2+0x528>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
800003dc:	8341c783          	lbu	a5,-1996(gp) # 800030dc <Ch_2_Glob>
800003e0:	0ff77a93          	andi	s5,a4,255
800003e4:	ff57f3e3          	bleu	s5,a5,800003ca <main2+0x1ae>
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
800003e8:	47d2                	lw	a5,20(sp)
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
800003ea:	4b62                	lw	s6,24(sp)
    Proc_2 (&Int_1_Loc);
800003ec:	0848                	addi	a0,sp,20
    Int_2_Loc = Int_2_Loc * Int_1_Loc;
800003ee:	02fa0a33          	mul	s4,s4,a5
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
800003f2:	0985                	addi	s3,s3,1
    Int_1_Loc = Int_2_Loc / Int_3_Loc;
800003f4:	036a4ab3          	div	s5,s4,s6
800003f8:	ca56                	sw	s5,20(sp)
    Proc_2 (&Int_1_Loc);
800003fa:	39d1                	jal	800000ce <Proc_2>
  for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
800003fc:	0c900793          	li	a5,201
80000400:	f2f99ae3          	bne	s3,a5,80000334 <main2+0x118>
  End_Time = clock();
80000404:	644000ef          	jal	ra,80000a48 <clock>
80000408:	82a1a423          	sw	a0,-2008(gp) # 800030d0 <End_Time>
  printf ("Execution ends\n");
8000040c:	80003537          	lui	a0,0x80003
80000410:	a0050513          	addi	a0,a0,-1536 # 80002a00 <_stack_start+0xffffc930>
80000414:	604000ef          	jal	ra,80000a18 <puts>
  printf ("\n");
80000418:	4529                	li	a0,10
8000041a:	624000ef          	jal	ra,80000a3e <putchar>
  printf ("Final values of the variables used in the benchmark:\n");
8000041e:	80003537          	lui	a0,0x80003
80000422:	a1050513          	addi	a0,a0,-1520 # 80002a10 <_stack_start+0xffffc940>
80000426:	5f2000ef          	jal	ra,80000a18 <puts>
  printf ("\n");
8000042a:	4529                	li	a0,10
8000042c:	612000ef          	jal	ra,80000a3e <putchar>
  printf ("Int_Glob:            %d\n", Int_Glob);
80000430:	83c1a583          	lw	a1,-1988(gp) # 800030e4 <Int_Glob>
80000434:	80003537          	lui	a0,0x80003
80000438:	a4850513          	addi	a0,a0,-1464 # 80002a48 <_stack_start+0xffffc978>
  printf ("        should be:   %d\n", 5);
8000043c:	80003437          	lui	s0,0x80003
  printf ("Int_Glob:            %d\n", Int_Glob);
80000440:	2b0d                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 5);
80000442:	4595                	li	a1,5
80000444:	a6440513          	addi	a0,s0,-1436 # 80002a64 <_stack_start+0xffffc994>
80000448:	232d                	jal	80000972 <printf>
  printf ("Bool_Glob:           %d\n", Bool_Glob);
8000044a:	8381a583          	lw	a1,-1992(gp) # 800030e0 <Bool_Glob>
8000044e:	80003537          	lui	a0,0x80003
80000452:	a8050513          	addi	a0,a0,-1408 # 80002a80 <_stack_start+0xffffc9b0>
80000456:	2b31                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 1);
80000458:	4585                	li	a1,1
8000045a:	a6440513          	addi	a0,s0,-1436
8000045e:	2b11                	jal	80000972 <printf>
  printf ("Ch_1_Glob:           %c\n", Ch_1_Glob);
80000460:	8351c583          	lbu	a1,-1995(gp) # 800030dd <Ch_1_Glob>
80000464:	80003537          	lui	a0,0x80003
80000468:	a9c50513          	addi	a0,a0,-1380 # 80002a9c <_stack_start+0xffffc9cc>
8000046c:	2319                	jal	80000972 <printf>
  printf ("        should be:   %c\n", 'A');
8000046e:	800034b7          	lui	s1,0x80003
80000472:	04100593          	li	a1,65
80000476:	ab848513          	addi	a0,s1,-1352 # 80002ab8 <_stack_start+0xffffc9e8>
8000047a:	29e5                	jal	80000972 <printf>
  printf ("Ch_2_Glob:           %c\n", Ch_2_Glob);
8000047c:	8341c583          	lbu	a1,-1996(gp) # 800030dc <Ch_2_Glob>
80000480:	80003537          	lui	a0,0x80003
80000484:	ad450513          	addi	a0,a0,-1324 # 80002ad4 <_stack_start+0xffffca04>
80000488:	21ed                	jal	80000972 <printf>
  printf ("        should be:   %c\n", 'B');
8000048a:	04200593          	li	a1,66
8000048e:	ab848513          	addi	a0,s1,-1352
80000492:	21c5                	jal	80000972 <printf>
  printf ("Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
80000494:	84c18793          	addi	a5,gp,-1972 # 800030f4 <Arr_1_Glob>
80000498:	538c                	lw	a1,32(a5)
8000049a:	80003537          	lui	a0,0x80003
8000049e:	af050513          	addi	a0,a0,-1296 # 80002af0 <_stack_start+0xffffca20>
800004a2:	29c1                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 7);
800004a4:	459d                	li	a1,7
800004a6:	a6440513          	addi	a0,s0,-1436
800004aa:	21e1                	jal	80000972 <printf>
  printf ("Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
800004ac:	800037b7          	lui	a5,0x80003
800004b0:	1bc78793          	addi	a5,a5,444 # 800031bc <_stack_start+0xffffd0ec>
800004b4:	65c7a583          	lw	a1,1628(a5)
800004b8:	80003537          	lui	a0,0x80003
800004bc:	b0c50513          	addi	a0,a0,-1268 # 80002b0c <_stack_start+0xffffca3c>
800004c0:	294d                	jal	80000972 <printf>
  printf ("        should be:   Number_Of_Runs + 10\n");
800004c2:	80003537          	lui	a0,0x80003
800004c6:	b2850513          	addi	a0,a0,-1240 # 80002b28 <_stack_start+0xffffca58>
800004ca:	54e000ef          	jal	ra,80000a18 <puts>
  printf ("Ptr_Glob->\n");
800004ce:	80003537          	lui	a0,0x80003
800004d2:	b5450513          	addi	a0,a0,-1196 # 80002b54 <_stack_start+0xffffca84>
800004d6:	542000ef          	jal	ra,80000a18 <puts>
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
800004da:	8441a703          	lw	a4,-1980(gp) # 800030ec <Ptr_Glob>
800004de:	800037b7          	lui	a5,0x80003
800004e2:	b6078513          	addi	a0,a5,-1184 # 80002b60 <_stack_start+0xffffca90>
800004e6:	430c                	lw	a1,0(a4)
800004e8:	c63e                	sw	a5,12(sp)
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
800004ea:	80003d37          	lui	s10,0x80003
  printf ("  Ptr_Comp:          %d\n", (int) Ptr_Glob->Ptr_Comp);
800004ee:	2151                	jal	80000972 <printf>
  printf ("        should be:   (implementation-dependent)\n");
800004f0:	80003537          	lui	a0,0x80003
800004f4:	b7c50513          	addi	a0,a0,-1156 # 80002b7c <_stack_start+0xffffcaac>
800004f8:	2305                	jal	80000a18 <puts>
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
800004fa:	8441a703          	lw	a4,-1980(gp) # 800030ec <Ptr_Glob>
800004fe:	bacd0513          	addi	a0,s10,-1108 # 80002bac <_stack_start+0xffffcadc>
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
80000502:	80003c37          	lui	s8,0x80003
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
80000506:	434c                	lw	a1,4(a4)
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
80000508:	80003bb7          	lui	s7,0x80003
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
8000050c:	800039b7          	lui	s3,0x80003
  printf ("  Discr:             %d\n", Ptr_Glob->Discr);
80000510:	218d                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 0);
80000512:	4581                	li	a1,0
80000514:	a6440513          	addi	a0,s0,-1436
80000518:	29a9                	jal	80000972 <printf>
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
8000051a:	8441a703          	lw	a4,-1980(gp) # 800030ec <Ptr_Glob>
8000051e:	bc8c0513          	addi	a0,s8,-1080 # 80002bc8 <_stack_start+0xffffcaf8>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
80000522:	80003937          	lui	s2,0x80003
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
80000526:	470c                	lw	a1,8(a4)
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
80000528:	416a0a33          	sub	s4,s4,s6
  printf ("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
8000052c:	2199                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 2);
8000052e:	4589                	li	a1,2
80000530:	a6440513          	addi	a0,s0,-1436
80000534:	293d                	jal	80000972 <printf>
  printf ("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
80000536:	8441a703          	lw	a4,-1980(gp) # 800030ec <Ptr_Glob>
8000053a:	be4b8513          	addi	a0,s7,-1052 # 80002be4 <_stack_start+0xffffcb14>
8000053e:	474c                	lw	a1,12(a4)
80000540:	290d                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 17);
80000542:	45c5                	li	a1,17
80000544:	a6440513          	addi	a0,s0,-1436
80000548:	212d                	jal	80000972 <printf>
  printf ("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
8000054a:	8441a583          	lw	a1,-1980(gp) # 800030ec <Ptr_Glob>
8000054e:	c0098513          	addi	a0,s3,-1024 # 80002c00 <_stack_start+0xffffcb30>
80000552:	05c1                	addi	a1,a1,16
80000554:	2939                	jal	80000972 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
80000556:	c1c90513          	addi	a0,s2,-996 # 80002c1c <_stack_start+0xffffcb4c>
8000055a:	297d                	jal	80000a18 <puts>
  printf ("Next_Ptr_Glob->\n");
8000055c:	80003537          	lui	a0,0x80003
80000560:	c5050513          	addi	a0,a0,-944 # 80002c50 <_stack_start+0xffffcb80>
80000564:	2955                	jal	80000a18 <puts>
  printf ("  Ptr_Comp:          %d\n", (int) Next_Ptr_Glob->Ptr_Comp);
80000566:	8401a703          	lw	a4,-1984(gp) # 800030e8 <Next_Ptr_Glob>
8000056a:	47b2                	lw	a5,12(sp)
8000056c:	430c                	lw	a1,0(a4)
8000056e:	b6078513          	addi	a0,a5,-1184
80000572:	2101                	jal	80000972 <printf>
  printf ("        should be:   (implementation-dependent), same as above\n");
80000574:	80003537          	lui	a0,0x80003
80000578:	c6050513          	addi	a0,a0,-928 # 80002c60 <_stack_start+0xffffcb90>
8000057c:	2971                	jal	80000a18 <puts>
  printf ("  Discr:             %d\n", Next_Ptr_Glob->Discr);
8000057e:	8401a783          	lw	a5,-1984(gp) # 800030e8 <Next_Ptr_Glob>
80000582:	bacd0513          	addi	a0,s10,-1108
80000586:	43cc                	lw	a1,4(a5)
80000588:	26ed                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 0);
8000058a:	4581                	li	a1,0
8000058c:	a6440513          	addi	a0,s0,-1436
80000590:	26cd                	jal	80000972 <printf>
  printf ("  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
80000592:	8401a783          	lw	a5,-1984(gp) # 800030e8 <Next_Ptr_Glob>
80000596:	bc8c0513          	addi	a0,s8,-1080
8000059a:	478c                	lw	a1,8(a5)
8000059c:	2ed9                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 1);
8000059e:	4585                	li	a1,1
800005a0:	a6440513          	addi	a0,s0,-1436
800005a4:	26f9                	jal	80000972 <printf>
  printf ("  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
800005a6:	8401a783          	lw	a5,-1984(gp) # 800030e8 <Next_Ptr_Glob>
800005aa:	be4b8513          	addi	a0,s7,-1052
800005ae:	47cc                	lw	a1,12(a5)
800005b0:	26c9                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 18);
800005b2:	45c9                	li	a1,18
800005b4:	a6440513          	addi	a0,s0,-1436
800005b8:	2e6d                	jal	80000972 <printf>
  printf ("  Str_Comp:          %s\n",
800005ba:	8401a583          	lw	a1,-1984(gp) # 800030e8 <Next_Ptr_Glob>
800005be:	c0098513          	addi	a0,s3,-1024
800005c2:	05c1                	addi	a1,a1,16
800005c4:	267d                	jal	80000972 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
800005c6:	c1c90513          	addi	a0,s2,-996
800005ca:	21b9                	jal	80000a18 <puts>
  printf ("Int_1_Loc:           %d\n", Int_1_Loc);
800005cc:	45d2                	lw	a1,20(sp)
800005ce:	80003537          	lui	a0,0x80003
800005d2:	ca050513          	addi	a0,a0,-864 # 80002ca0 <_stack_start+0xffffcbd0>
800005d6:	2e71                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 5);
800005d8:	4595                	li	a1,5
800005da:	a6440513          	addi	a0,s0,-1436
800005de:	2e51                	jal	80000972 <printf>
    Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
800005e0:	003a1793          	slli	a5,s4,0x3
800005e4:	41478a33          	sub	s4,a5,s4
  printf ("Int_2_Loc:           %d\n", Int_2_Loc);
800005e8:	80003537          	lui	a0,0x80003
800005ec:	415a05b3          	sub	a1,s4,s5
800005f0:	cbc50513          	addi	a0,a0,-836 # 80002cbc <_stack_start+0xffffcbec>
800005f4:	2ebd                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 13);
800005f6:	45b5                	li	a1,13
800005f8:	a6440513          	addi	a0,s0,-1436
800005fc:	2e9d                	jal	80000972 <printf>
  printf ("Int_3_Loc:           %d\n", Int_3_Loc);
800005fe:	45e2                	lw	a1,24(sp)
80000600:	80003537          	lui	a0,0x80003
80000604:	cd850513          	addi	a0,a0,-808 # 80002cd8 <_stack_start+0xffffcc08>
80000608:	26ad                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 7);
8000060a:	459d                	li	a1,7
8000060c:	a6440513          	addi	a0,s0,-1436
80000610:	268d                	jal	80000972 <printf>
  printf ("Enum_Loc:            %d\n", Enum_Loc);
80000612:	45f2                	lw	a1,28(sp)
80000614:	80003537          	lui	a0,0x80003
80000618:	cf450513          	addi	a0,a0,-780 # 80002cf4 <_stack_start+0xffffcc24>
8000061c:	2e99                	jal	80000972 <printf>
  printf ("        should be:   %d\n", 1);
8000061e:	4585                	li	a1,1
80000620:	a6440513          	addi	a0,s0,-1436
80000624:	26b9                	jal	80000972 <printf>
  printf ("Str_1_Loc:           %s\n", Str_1_Loc);
80000626:	80003537          	lui	a0,0x80003
8000062a:	100c                	addi	a1,sp,32
8000062c:	d1050513          	addi	a0,a0,-752 # 80002d10 <_stack_start+0xffffcc40>
80000630:	2689                	jal	80000972 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
80000632:	80003537          	lui	a0,0x80003
80000636:	d2c50513          	addi	a0,a0,-724 # 80002d2c <_stack_start+0xffffcc5c>
8000063a:	2ef9                	jal	80000a18 <puts>
  printf ("Str_2_Loc:           %s\n", Str_2_Loc);
8000063c:	80003537          	lui	a0,0x80003
80000640:	008c                	addi	a1,sp,64
80000642:	d6050513          	addi	a0,a0,-672 # 80002d60 <_stack_start+0xffffcc90>
80000646:	2635                	jal	80000972 <printf>
  printf ("        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
80000648:	80003537          	lui	a0,0x80003
8000064c:	d7c50513          	addi	a0,a0,-644 # 80002d7c <_stack_start+0xffffccac>
80000650:	26e1                	jal	80000a18 <puts>
  printf ("\n");
80000652:	4529                	li	a0,10
80000654:	26ed                	jal	80000a3e <putchar>
  User_Time = End_Time - Begin_Time;
80000656:	82c1a703          	lw	a4,-2004(gp) # 800030d4 <Begin_Time>
8000065a:	8281a583          	lw	a1,-2008(gp) # 800030d0 <End_Time>
  if (User_Time < Too_Small_Time)
8000065e:	1f300793          	li	a5,499
  User_Time = End_Time - Begin_Time;
80000662:	8d99                	sub	a1,a1,a4
80000664:	82b1a223          	sw	a1,-2012(gp) # 800030cc <User_Time>
  if (User_Time < Too_Small_Time)
80000668:	12b7df63          	ble	a1,a5,800007a6 <main2+0x58a>
    printf ("Clock cycles=%d \n", User_Time);
8000066c:	80003537          	lui	a0,0x80003
80000670:	e0850513          	addi	a0,a0,-504 # 80002e08 <_stack_start+0xffffcd38>
80000674:	2cfd                	jal	80000972 <printf>
    Microseconds = (float) User_Time * Mic_secs_Per_Second 
80000676:	8241a503          	lw	a0,-2012(gp) # 800030cc <User_Time>
8000067a:	647010ef          	jal	ra,800024c0 <__floatsisf>
8000067e:	842a                	mv	s0,a0
80000680:	765010ef          	jal	ra,800025e4 <__extendsfdf2>
80000684:	800037b7          	lui	a5,0x80003
80000688:	0a87a603          	lw	a2,168(a5) # 800030a8 <_stack_start+0xffffcfd8>
8000068c:	0ac7a683          	lw	a3,172(a5)
80000690:	509000ef          	jal	ra,80001398 <__muldf3>
                        / ((float) CORE_HZ * ((float) Number_Of_Runs));
80000694:	800037b7          	lui	a5,0x80003
80000698:	0b07a603          	lw	a2,176(a5) # 800030b0 <_stack_start+0xffffcfe0>
8000069c:	0b47a683          	lw	a3,180(a5)
800006a0:	618000ef          	jal	ra,80000cb8 <__divdf3>
800006a4:	04c020ef          	jal	ra,800026f0 <__truncdfsf2>
800006a8:	82a1a023          	sw	a0,-2016(gp) # 800030c8 <Microseconds>
                        / (float) User_Time;
800006ac:	800037b7          	lui	a5,0x80003
800006b0:	0b87a503          	lw	a0,184(a5) # 800030b8 <_stack_start+0xffffcfe8>
800006b4:	85a2                	mv	a1,s0
800006b6:	2be010ef          	jal	ra,80001974 <__divsf3>
    Dhrystones_Per_Second = ((float) CORE_HZ * (float) Number_Of_Runs)
800006ba:	80a1ae23          	sw	a0,-2020(gp) # 800030c4 <Dhrystones_Per_Second>
    printf ("DMIPS per Mhz:                              ");
800006be:	80003537          	lui	a0,0x80003
800006c2:	e1c50513          	addi	a0,a0,-484 # 80002e1c <_stack_start+0xffffcd4c>
800006c6:	2475                	jal	80000972 <printf>
    float dmips = (1e6f/1757.0f) * Number_Of_Runs / User_Time;
800006c8:	8241a503          	lw	a0,-2012(gp) # 800030cc <User_Time>
800006cc:	5f5010ef          	jal	ra,800024c0 <__floatsisf>
800006d0:	800037b7          	lui	a5,0x80003
800006d4:	85aa                	mv	a1,a0
800006d6:	0bc7a503          	lw	a0,188(a5) # 800030bc <_stack_start+0xffffcfec>
800006da:	29a010ef          	jal	ra,80001974 <__divsf3>
800006de:	842a                	mv	s0,a0
    int dmipsNatural = dmips;
800006e0:	571010ef          	jal	ra,80002450 <__fixsfsi>
800006e4:	84aa                	mv	s1,a0
    int dmipsReal = (dmips - dmipsNatural)*100.0f;
800006e6:	5db010ef          	jal	ra,800024c0 <__floatsisf>
800006ea:	85aa                	mv	a1,a0
800006ec:	8522                	mv	a0,s0
800006ee:	0eb010ef          	jal	ra,80001fd8 <__subsf3>
800006f2:	800037b7          	lui	a5,0x80003
800006f6:	0c07a583          	lw	a1,192(a5) # 800030c0 <_stack_start+0xffffcff0>
800006fa:	5ba010ef          	jal	ra,80001cb4 <__mulsf3>
800006fe:	553010ef          	jal	ra,80002450 <__fixsfsi>
80000702:	842a                	mv	s0,a0
    printf ("%d.", dmipsNatural);
80000704:	80003537          	lui	a0,0x80003
80000708:	85a6                	mv	a1,s1
8000070a:	e4c50513          	addi	a0,a0,-436 # 80002e4c <_stack_start+0xffffcd7c>
8000070e:	2495                	jal	80000972 <printf>
    if(dmipsReal < 10) printf("0");
80000710:	47a5                	li	a5,9
80000712:	0a87d763          	ble	s0,a5,800007c0 <main2+0x5a4>
    printf ("%d", dmipsReal);
80000716:	80003537          	lui	a0,0x80003
8000071a:	85a2                	mv	a1,s0
8000071c:	e5050513          	addi	a0,a0,-432 # 80002e50 <_stack_start+0xffffcd80>
80000720:	2c89                	jal	80000972 <printf>
    printf ("\n");
80000722:	4529                	li	a0,10
80000724:	2e29                	jal	80000a3e <putchar>
}
80000726:	40fa                	lw	ra,156(sp)
80000728:	446a                	lw	s0,152(sp)
8000072a:	44da                	lw	s1,148(sp)
8000072c:	494a                	lw	s2,144(sp)
8000072e:	49ba                	lw	s3,140(sp)
80000730:	4a2a                	lw	s4,136(sp)
80000732:	4a9a                	lw	s5,132(sp)
80000734:	4b0a                	lw	s6,128(sp)
80000736:	5bf6                	lw	s7,124(sp)
80000738:	5c66                	lw	s8,120(sp)
8000073a:	5cd6                	lw	s9,116(sp)
8000073c:	5d46                	lw	s10,112(sp)
8000073e:	5db6                	lw	s11,108(sp)
80000740:	610d                	addi	sp,sp,160
80000742:	8082                	ret
        Proc_6 (Ident_1, &Enum_Loc);
80000744:	086c                	addi	a1,sp,28
80000746:	4501                	li	a0,0
80000748:	220d                	jal	8000086a <Proc_6>
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
8000074a:	004b2303          	lw	t1,4(s6)
8000074e:	008b2883          	lw	a7,8(s6)
80000752:	00cb2803          	lw	a6,12(s6)
80000756:	010b2503          	lw	a0,16(s6)
8000075a:	014b2583          	lw	a1,20(s6)
8000075e:	018b2603          	lw	a2,24(s6)
80000762:	01cb5683          	lhu	a3,28(s6)
80000766:	01eb4703          	lbu	a4,30(s6)
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
8000076a:	8341c783          	lbu	a5,-1996(gp) # 800030dc <Ch_2_Glob>
8000076e:	0a85                	addi	s5,s5,1
        strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
80000770:	c0e2                	sw	s8,64(sp)
80000772:	c29a                	sw	t1,68(sp)
80000774:	c4c6                	sw	a7,72(sp)
80000776:	c6c2                	sw	a6,76(sp)
80000778:	c8aa                	sw	a0,80(sp)
8000077a:	caae                	sw	a1,84(sp)
8000077c:	ccb2                	sw	a2,88(sp)
8000077e:	04d11e23          	sh	a3,92(sp)
80000782:	04e10f23          	sb	a4,94(sp)
        Int_Glob = Run_Index;
80000786:	8331ae23          	sw	s3,-1988(gp) # 800030e4 <Int_Glob>
    for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
8000078a:	0ffafa93          	andi	s5,s5,255
8000078e:	8a4e                	mv	s4,s3
80000790:	c357fde3          	bleu	s5,a5,800003ca <main2+0x1ae>
80000794:	b991                	j	800003e8 <main2+0x1cc>
    printf ("Program compiled without 'register' attribute\n");
80000796:	80003537          	lui	a0,0x80003
8000079a:	96850513          	addi	a0,a0,-1688 # 80002968 <_stack_start+0xffffc898>
8000079e:	2cad                	jal	80000a18 <puts>
    printf ("\n");
800007a0:	4529                	li	a0,10
800007a2:	2c71                	jal	80000a3e <putchar>
800007a4:	b6b1                	j	800002f0 <main2+0xd4>
    printf ("Measured time too small to obtain meaningful results\n");
800007a6:	80003537          	lui	a0,0x80003
800007aa:	db050513          	addi	a0,a0,-592 # 80002db0 <_stack_start+0xffffcce0>
800007ae:	24ad                	jal	80000a18 <puts>
    printf ("Please increase number of runs\n");
800007b0:	80003537          	lui	a0,0x80003
800007b4:	de850513          	addi	a0,a0,-536 # 80002de8 <_stack_start+0xffffcd18>
800007b8:	2485                	jal	80000a18 <puts>
    printf ("\n");
800007ba:	4529                	li	a0,10
800007bc:	2449                	jal	80000a3e <putchar>
800007be:	b7a5                	j	80000726 <main2+0x50a>
    if(dmipsReal < 10) printf("0");
800007c0:	03000513          	li	a0,48
800007c4:	2cad                	jal	80000a3e <putchar>
800007c6:	bf81                	j	80000716 <main2+0x4fa>

800007c8 <Proc_7>:
One_Fifty       Int_2_Par_Val;
One_Fifty      *Int_Par_Ref;
{
  One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 2;
800007c8:	0509                	addi	a0,a0,2
  *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
800007ca:	95aa                	add	a1,a1,a0
800007cc:	c20c                	sw	a1,0(a2)
} /* Proc_7 */
800007ce:	8082                	ret

800007d0 <Proc_8>:
int             Int_2_Par_Val;
{
  REG One_Fifty Int_Index;
  REG One_Fifty Int_Loc;

  Int_Loc = Int_1_Par_Val + 5;
800007d0:	00560713          	addi	a4,a2,5
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
  for (Int_Index = Int_Loc; Int_Index <= Int_Loc+1; ++Int_Index)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
800007d4:	0c800813          	li	a6,200
800007d8:	03070833          	mul	a6,a4,a6
800007dc:	060a                	slli	a2,a2,0x2
  Arr_1_Par_Ref [Int_Loc] = Int_2_Par_Val;
800007de:	00271793          	slli	a5,a4,0x2
800007e2:	953e                	add	a0,a0,a5
800007e4:	c114                	sw	a3,0(a0)
  Arr_1_Par_Ref [Int_Loc+30] = Int_Loc;
800007e6:	dd38                	sw	a4,120(a0)
  Arr_1_Par_Ref [Int_Loc+1] = Arr_1_Par_Ref [Int_Loc];
800007e8:	c154                	sw	a3,4(a0)
800007ea:	00c807b3          	add	a5,a6,a2
800007ee:	97ae                	add	a5,a5,a1
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
800007f0:	4b94                	lw	a3,16(a5)
    Arr_2_Par_Ref [Int_Loc] [Int_Index] = Int_Loc;
800007f2:	cbd8                	sw	a4,20(a5)
800007f4:	cf98                	sw	a4,24(a5)
  Arr_2_Par_Ref [Int_Loc] [Int_Loc-1] += 1;
800007f6:	00168713          	addi	a4,a3,1
800007fa:	cb98                	sw	a4,16(a5)
  Arr_2_Par_Ref [Int_Loc+20] [Int_Loc] = Arr_1_Par_Ref [Int_Loc];
800007fc:	411c                	lw	a5,0(a0)
800007fe:	95c2                	add	a1,a1,a6
80000800:	95b2                	add	a1,a1,a2
80000802:	6605                	lui	a2,0x1
80000804:	95b2                	add	a1,a1,a2
80000806:	faf5aa23          	sw	a5,-76(a1)
  Int_Glob = 5;
8000080a:	4715                	li	a4,5
8000080c:	82e1ae23          	sw	a4,-1988(gp) # 800030e4 <Int_Glob>
} /* Proc_8 */
80000810:	8082                	ret

80000812 <Func_1>:
    /* second call:     Ch_1_Par_Val == 'A', Ch_2_Par_Val == 'C'    */
    /* third call:      Ch_1_Par_Val == 'B', Ch_2_Par_Val == 'C'    */

Capital_Letter   Ch_1_Par_Val;
Capital_Letter   Ch_2_Par_Val;
{
80000812:	0ff57513          	andi	a0,a0,255
80000816:	0ff5f593          	andi	a1,a1,255
  Capital_Letter        Ch_1_Loc;
  Capital_Letter        Ch_2_Loc;

  Ch_1_Loc = Ch_1_Par_Val;
  Ch_2_Loc = Ch_1_Loc;
  if (Ch_2_Loc != Ch_2_Par_Val)
8000081a:	00b50463          	beq	a0,a1,80000822 <Func_1+0x10>
    /* then, executed */
    return (Ident_1);
8000081e:	4501                	li	a0,0
  else  /* not executed */
  {
    Ch_1_Glob = Ch_1_Loc;
    return (Ident_2);
   }
} /* Func_1 */
80000820:	8082                	ret
    Ch_1_Glob = Ch_1_Loc;
80000822:	82a18aa3          	sb	a0,-1995(gp) # 800030dd <Ch_1_Glob>
    return (Ident_2);
80000826:	4505                	li	a0,1
80000828:	8082                	ret

8000082a <Func_2>:
    /* Str_1_Par_Ref == "DHRYSTONE PROGRAM, 1'ST STRING" */
    /* Str_2_Par_Ref == "DHRYSTONE PROGRAM, 2'ND STRING" */

Str_30  Str_1_Par_Ref;
Str_30  Str_2_Par_Ref;
{
8000082a:	1141                	addi	sp,sp,-16
8000082c:	c422                	sw	s0,8(sp)
8000082e:	c226                	sw	s1,4(sp)
80000830:	c606                	sw	ra,12(sp)
80000832:	842a                	mv	s0,a0
80000834:	84ae                	mv	s1,a1
  REG One_Thirty        Int_Loc;
      Capital_Letter    Ch_Loc;

  Int_Loc = 2;
  while (Int_Loc <= 2) /* loop body executed once */
    if (Func_1 (Str_1_Par_Ref[Int_Loc],
80000836:	0034c583          	lbu	a1,3(s1)
8000083a:	00244503          	lbu	a0,2(s0)
8000083e:	3fd1                	jal	80000812 <Func_1>
80000840:	f97d                	bnez	a0,80000836 <Func_2+0xc>
  if (Ch_Loc == 'R')
    /* then, not executed */
    return (true);
  else /* executed */
  {
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
80000842:	85a6                	mv	a1,s1
80000844:	8522                	mv	a0,s0
80000846:	2cdd                	jal	80000b3c <strcmp>
      Int_Loc += 7;
      Int_Glob = Int_Loc;
      return (true);
    }
    else /* executed */
      return (false);
80000848:	4781                	li	a5,0
    if (strcmp (Str_1_Par_Ref, Str_2_Par_Ref) > 0)
8000084a:	00a05663          	blez	a0,80000856 <Func_2+0x2c>
      Int_Glob = Int_Loc;
8000084e:	4729                	li	a4,10
80000850:	82e1ae23          	sw	a4,-1988(gp) # 800030e4 <Int_Glob>
      return (true);
80000854:	4785                	li	a5,1
  } /* if Ch_Loc */
} /* Func_2 */
80000856:	40b2                	lw	ra,12(sp)
80000858:	4422                	lw	s0,8(sp)
8000085a:	4492                	lw	s1,4(sp)
8000085c:	853e                	mv	a0,a5
8000085e:	0141                	addi	sp,sp,16
80000860:	8082                	ret

80000862 <Func_3>:
Enumeration Enum_Par_Val;
{
  Enumeration Enum_Loc;

  Enum_Loc = Enum_Par_Val;
  if (Enum_Loc == Ident_3)
80000862:	1579                	addi	a0,a0,-2
    /* then, executed */
    return (true);
  else /* not executed */
    return (false);
} /* Func_3 */
80000864:	00153513          	seqz	a0,a0
80000868:	8082                	ret

8000086a <Proc_6>:
{
8000086a:	1141                	addi	sp,sp,-16
8000086c:	c422                	sw	s0,8(sp)
8000086e:	c226                	sw	s1,4(sp)
80000870:	c606                	sw	ra,12(sp)
80000872:	842a                	mv	s0,a0
80000874:	84ae                	mv	s1,a1
  if (! Func_3 (Enum_Val_Par))
80000876:	37f5                	jal	80000862 <Func_3>
80000878:	c115                	beqz	a0,8000089c <Proc_6+0x32>
  *Enum_Ref_Par = Enum_Val_Par;
8000087a:	c080                	sw	s0,0(s1)
  switch (Enum_Val_Par)
8000087c:	4785                	li	a5,1
8000087e:	02f40463          	beq	s0,a5,800008a6 <Proc_6+0x3c>
80000882:	c805                	beqz	s0,800008b2 <Proc_6+0x48>
80000884:	4709                	li	a4,2
80000886:	02e40d63          	beq	s0,a4,800008c0 <Proc_6+0x56>
8000088a:	4791                	li	a5,4
8000088c:	00f41363          	bne	s0,a5,80000892 <Proc_6+0x28>
      *Enum_Ref_Par = Ident_3;
80000890:	c098                	sw	a4,0(s1)
} /* Proc_6 */
80000892:	40b2                	lw	ra,12(sp)
80000894:	4422                	lw	s0,8(sp)
80000896:	4492                	lw	s1,4(sp)
80000898:	0141                	addi	sp,sp,16
8000089a:	8082                	ret
    *Enum_Ref_Par = Ident_4;
8000089c:	478d                	li	a5,3
8000089e:	c09c                	sw	a5,0(s1)
  switch (Enum_Val_Par)
800008a0:	4785                	li	a5,1
800008a2:	fef410e3          	bne	s0,a5,80000882 <Proc_6+0x18>
      if (Int_Glob > 100)
800008a6:	83c1a703          	lw	a4,-1988(gp) # 800030e4 <Int_Glob>
800008aa:	06400793          	li	a5,100
800008ae:	00e7df63          	ble	a4,a5,800008cc <Proc_6+0x62>
} /* Proc_6 */
800008b2:	40b2                	lw	ra,12(sp)
800008b4:	4422                	lw	s0,8(sp)
      *Enum_Ref_Par = Ident_1;
800008b6:	0004a023          	sw	zero,0(s1)
} /* Proc_6 */
800008ba:	4492                	lw	s1,4(sp)
800008bc:	0141                	addi	sp,sp,16
800008be:	8082                	ret
800008c0:	40b2                	lw	ra,12(sp)
800008c2:	4422                	lw	s0,8(sp)
      *Enum_Ref_Par = Ident_2;
800008c4:	c09c                	sw	a5,0(s1)
} /* Proc_6 */
800008c6:	4492                	lw	s1,4(sp)
800008c8:	0141                	addi	sp,sp,16
800008ca:	8082                	ret
800008cc:	40b2                	lw	ra,12(sp)
800008ce:	4422                	lw	s0,8(sp)
      else *Enum_Ref_Par = Ident_4;
800008d0:	478d                	li	a5,3
800008d2:	c09c                	sw	a5,0(s1)
} /* Proc_6 */
800008d4:	4492                	lw	s1,4(sp)
800008d6:	0141                	addi	sp,sp,16
800008d8:	8082                	ret

800008da <printf_s>:
{
	putchar(c);
}

static void printf_s(char *p)
{
800008da:	1141                	addi	sp,sp,-16
800008dc:	c422                	sw	s0,8(sp)
800008de:	c606                	sw	ra,12(sp)
800008e0:	842a                	mv	s0,a0
	while (*p)
800008e2:	00054503          	lbu	a0,0(a0)
800008e6:	c511                	beqz	a0,800008f2 <printf_s+0x18>
		putchar(*(p++));
800008e8:	0405                	addi	s0,s0,1
800008ea:	2a91                	jal	80000a3e <putchar>
	while (*p)
800008ec:	00044503          	lbu	a0,0(s0)
800008f0:	fd65                	bnez	a0,800008e8 <printf_s+0xe>
}
800008f2:	40b2                	lw	ra,12(sp)
800008f4:	4422                	lw	s0,8(sp)
800008f6:	0141                	addi	sp,sp,16
800008f8:	8082                	ret

800008fa <printf_c>:
	putchar(c);
800008fa:	a291                	j	80000a3e <putchar>

800008fc <printf_d>:

static void printf_d(int val)
{
800008fc:	7179                	addi	sp,sp,-48
800008fe:	d226                	sw	s1,36(sp)
80000900:	d606                	sw	ra,44(sp)
80000902:	d422                	sw	s0,40(sp)
80000904:	d04a                	sw	s2,32(sp)
80000906:	84aa                	mv	s1,a0
	char buffer[32];
	char *p = buffer;
	if (val < 0) {
80000908:	02054e63          	bltz	a0,80000944 <printf_d+0x48>
{
8000090c:	890a                	mv	s2,sp
8000090e:	844a                	mv	s0,s2
		printf_c('-');
		val = -val;
	}
	while (val || p == buffer) {
		*(p++) = '0' + val % 10;
80000910:	4729                	li	a4,10
	while (val || p == buffer) {
80000912:	e099                	bnez	s1,80000918 <printf_d+0x1c>
80000914:	01241c63          	bne	s0,s2,8000092c <printf_d+0x30>
		*(p++) = '0' + val % 10;
80000918:	02e4e7b3          	rem	a5,s1,a4
8000091c:	0405                	addi	s0,s0,1
8000091e:	03078793          	addi	a5,a5,48
		val = val / 10;
80000922:	02e4c4b3          	div	s1,s1,a4
		*(p++) = '0' + val % 10;
80000926:	fef40fa3          	sb	a5,-1(s0)
8000092a:	b7e5                	j	80000912 <printf_d+0x16>
	}
	while (p != buffer)
		printf_c(*(--p));
8000092c:	147d                	addi	s0,s0,-1
8000092e:	00044503          	lbu	a0,0(s0)
80000932:	37e1                	jal	800008fa <printf_c>
	while (p != buffer)
80000934:	ff241ce3          	bne	s0,s2,8000092c <printf_d+0x30>
}
80000938:	50b2                	lw	ra,44(sp)
8000093a:	5422                	lw	s0,40(sp)
8000093c:	5492                	lw	s1,36(sp)
8000093e:	5902                	lw	s2,32(sp)
80000940:	6145                	addi	sp,sp,48
80000942:	8082                	ret
		printf_c('-');
80000944:	02d00513          	li	a0,45
80000948:	3f4d                	jal	800008fa <printf_c>
		val = -val;
8000094a:	409004b3          	neg	s1,s1
8000094e:	bf7d                	j	8000090c <printf_d+0x10>

80000950 <malloc>:
	char *p = heap_memory + heap_memory_used;
80000950:	8481a703          	lw	a4,-1976(gp) # 800030f0 <heap_memory_used>
	heap_memory_used += size;
80000954:	00a707b3          	add	a5,a4,a0
	char *p = heap_memory + heap_memory_used;
80000958:	80006537          	lui	a0,0x80006
	heap_memory_used += size;
8000095c:	84f1a423          	sw	a5,-1976(gp) # 800030f0 <heap_memory_used>
	char *p = heap_memory + heap_memory_used;
80000960:	8cc50513          	addi	a0,a0,-1844 # 800058cc <_stack_start+0xfffff7fc>
	if (heap_memory_used > 1024)
80000964:	40000693          	li	a3,1024
	char *p = heap_memory + heap_memory_used;
80000968:	953a                	add	a0,a0,a4
	if (heap_memory_used > 1024)
8000096a:	00f6d363          	ble	a5,a3,80000970 <malloc+0x20>
		asm volatile ("ebreak");
8000096e:	9002                	ebreak
}
80000970:	8082                	ret

80000972 <printf>:

int printf(const char *format, ...)
{
80000972:	715d                	addi	sp,sp,-80
80000974:	cc52                	sw	s4,24(sp)
80000976:	d606                	sw	ra,44(sp)
80000978:	d422                	sw	s0,40(sp)
8000097a:	d226                	sw	s1,36(sp)
8000097c:	d04a                	sw	s2,32(sp)
8000097e:	ce4e                	sw	s3,28(sp)
80000980:	ca56                	sw	s5,20(sp)
80000982:	8a2a                	mv	s4,a0
	int i;
	va_list ap;

	va_start(ap, format);

	for (i = 0; format[i]; i++)
80000984:	00054503          	lbu	a0,0(a0)
{
80000988:	c2be                	sw	a5,68(sp)
	va_start(ap, format);
8000098a:	185c                	addi	a5,sp,52
{
8000098c:	da2e                	sw	a1,52(sp)
8000098e:	dc32                	sw	a2,56(sp)
80000990:	de36                	sw	a3,60(sp)
80000992:	c0ba                	sw	a4,64(sp)
80000994:	c4c2                	sw	a6,72(sp)
80000996:	c6c6                	sw	a7,76(sp)
	va_start(ap, format);
80000998:	c63e                	sw	a5,12(sp)
	for (i = 0; format[i]; i++)
8000099a:	c11d                	beqz	a0,800009c0 <printf+0x4e>
8000099c:	4401                	li	s0,0
		if (format[i] == '%') {
8000099e:	02500a93          	li	s5,37
			while (format[++i]) {
				if (format[i] == 'c') {
800009a2:	06300493          	li	s1,99
					printf_c(va_arg(ap,int));
					break;
				}
				if (format[i] == 's') {
800009a6:	07300913          	li	s2,115
					printf_s(va_arg(ap,char*));
					break;
				}
				if (format[i] == 'd') {
800009aa:	06400993          	li	s3,100
		if (format[i] == '%') {
800009ae:	03550263          	beq	a0,s5,800009d2 <printf+0x60>
					printf_d(va_arg(ap,int));
					break;
				}
			}
		} else
			printf_c(format[i]);
800009b2:	37a1                	jal	800008fa <printf_c>
	for (i = 0; format[i]; i++)
800009b4:	0405                	addi	s0,s0,1
800009b6:	008a07b3          	add	a5,s4,s0
800009ba:	0007c503          	lbu	a0,0(a5)
800009be:	f965                	bnez	a0,800009ae <printf+0x3c>

	va_end(ap);
}
800009c0:	50b2                	lw	ra,44(sp)
800009c2:	5422                	lw	s0,40(sp)
800009c4:	5492                	lw	s1,36(sp)
800009c6:	5902                	lw	s2,32(sp)
800009c8:	49f2                	lw	s3,28(sp)
800009ca:	4a62                	lw	s4,24(sp)
800009cc:	4ad2                	lw	s5,20(sp)
800009ce:	6161                	addi	sp,sp,80
800009d0:	8082                	ret
800009d2:	00140693          	addi	a3,s0,1
800009d6:	00da0733          	add	a4,s4,a3
800009da:	a031                	j	800009e6 <printf+0x74>
				if (format[i] == 's') {
800009dc:	03278263          	beq	a5,s2,80000a00 <printf+0x8e>
				if (format[i] == 'd') {
800009e0:	03378663          	beq	a5,s3,80000a0c <printf+0x9a>
800009e4:	0685                	addi	a3,a3,1
			while (format[++i]) {
800009e6:	00074783          	lbu	a5,0(a4)
800009ea:	8436                	mv	s0,a3
800009ec:	0705                	addi	a4,a4,1
800009ee:	d3f9                	beqz	a5,800009b4 <printf+0x42>
				if (format[i] == 'c') {
800009f0:	fe9796e3          	bne	a5,s1,800009dc <printf+0x6a>
					printf_c(va_arg(ap,int));
800009f4:	47b2                	lw	a5,12(sp)
800009f6:	4388                	lw	a0,0(a5)
800009f8:	0791                	addi	a5,a5,4
800009fa:	c63e                	sw	a5,12(sp)
800009fc:	3dfd                	jal	800008fa <printf_c>
					break;
800009fe:	bf5d                	j	800009b4 <printf+0x42>
					printf_s(va_arg(ap,char*));
80000a00:	47b2                	lw	a5,12(sp)
80000a02:	4388                	lw	a0,0(a5)
80000a04:	0791                	addi	a5,a5,4
80000a06:	c63e                	sw	a5,12(sp)
80000a08:	3dc9                	jal	800008da <printf_s>
					break;
80000a0a:	b76d                	j	800009b4 <printf+0x42>
					printf_d(va_arg(ap,int));
80000a0c:	47b2                	lw	a5,12(sp)
80000a0e:	4388                	lw	a0,0(a5)
80000a10:	0791                	addi	a5,a5,4
80000a12:	c63e                	sw	a5,12(sp)
80000a14:	35e5                	jal	800008fc <printf_d>
					break;
80000a16:	bf79                	j	800009b4 <printf+0x42>

80000a18 <puts>:


int puts(char *s){
80000a18:	1141                	addi	sp,sp,-16
80000a1a:	c422                	sw	s0,8(sp)
80000a1c:	c606                	sw	ra,12(sp)
80000a1e:	842a                	mv	s0,a0
  while (*s) {
80000a20:	00054503          	lbu	a0,0(a0)
80000a24:	c511                	beqz	a0,80000a30 <puts+0x18>
    putchar(*s);
    s++;
80000a26:	0405                	addi	s0,s0,1
    putchar(*s);
80000a28:	2819                	jal	80000a3e <putchar>
  while (*s) {
80000a2a:	00044503          	lbu	a0,0(s0)
80000a2e:	fd65                	bnez	a0,80000a26 <puts+0xe>
  }
  putchar('\n');
80000a30:	4529                	li	a0,10
80000a32:	2031                	jal	80000a3e <putchar>
  return 0;
}
80000a34:	40b2                	lw	ra,12(sp)
80000a36:	4422                	lw	s0,8(sp)
80000a38:	4501                	li	a0,0
80000a3a:	0141                	addi	sp,sp,16
80000a3c:	8082                	ret

80000a3e <putchar>:

void putchar(char c){
	TEST_COM_BASE[0] = c;
80000a3e:	f01007b7          	lui	a5,0xf0100
80000a42:	f0a7a023          	sw	a0,-256(a5) # f00fff00 <_stack_start+0x700f9e30>
}
80000a46:	8082                	ret

80000a48 <clock>:

#include <time.h>
clock_t	clock(){
  return TEST_COM_BASE[4];
80000a48:	f01007b7          	lui	a5,0xf0100
80000a4c:	f107a503          	lw	a0,-240(a5) # f00fff10 <_stack_start+0x700f9e40>
}
80000a50:	8082                	ret
	...

80000a54 <memcpy>:
80000a54:	00a5c7b3          	xor	a5,a1,a0
80000a58:	0037f793          	andi	a5,a5,3
80000a5c:	00c50733          	add	a4,a0,a2
80000a60:	00079663          	bnez	a5,80000a6c <memcpy+0x18>
80000a64:	00300793          	li	a5,3
80000a68:	02c7e463          	bltu	a5,a2,80000a90 <memcpy+0x3c>
80000a6c:	00050793          	mv	a5,a0
80000a70:	00e56c63          	bltu	a0,a4,80000a88 <memcpy+0x34>
80000a74:	00008067          	ret
80000a78:	0005c683          	lbu	a3,0(a1)
80000a7c:	00178793          	addi	a5,a5,1
80000a80:	00158593          	addi	a1,a1,1
80000a84:	fed78fa3          	sb	a3,-1(a5)
80000a88:	fee7e8e3          	bltu	a5,a4,80000a78 <memcpy+0x24>
80000a8c:	00008067          	ret
80000a90:	00357793          	andi	a5,a0,3
80000a94:	08079263          	bnez	a5,80000b18 <memcpy+0xc4>
80000a98:	00050793          	mv	a5,a0
80000a9c:	ffc77693          	andi	a3,a4,-4
80000aa0:	fe068613          	addi	a2,a3,-32
80000aa4:	08c7f663          	bleu	a2,a5,80000b30 <memcpy+0xdc>
80000aa8:	0005a383          	lw	t2,0(a1)
80000aac:	0045a283          	lw	t0,4(a1)
80000ab0:	0085af83          	lw	t6,8(a1)
80000ab4:	00c5af03          	lw	t5,12(a1)
80000ab8:	0105ae83          	lw	t4,16(a1)
80000abc:	0145ae03          	lw	t3,20(a1)
80000ac0:	0185a303          	lw	t1,24(a1)
80000ac4:	01c5a883          	lw	a7,28(a1)
80000ac8:	02458593          	addi	a1,a1,36
80000acc:	02478793          	addi	a5,a5,36
80000ad0:	ffc5a803          	lw	a6,-4(a1)
80000ad4:	fc77ae23          	sw	t2,-36(a5)
80000ad8:	fe57a023          	sw	t0,-32(a5)
80000adc:	fff7a223          	sw	t6,-28(a5)
80000ae0:	ffe7a423          	sw	t5,-24(a5)
80000ae4:	ffd7a623          	sw	t4,-20(a5)
80000ae8:	ffc7a823          	sw	t3,-16(a5)
80000aec:	fe67aa23          	sw	t1,-12(a5)
80000af0:	ff17ac23          	sw	a7,-8(a5)
80000af4:	ff07ae23          	sw	a6,-4(a5)
80000af8:	fadff06f          	j	80000aa4 <memcpy+0x50>
80000afc:	0005c683          	lbu	a3,0(a1)
80000b00:	00178793          	addi	a5,a5,1
80000b04:	00158593          	addi	a1,a1,1
80000b08:	fed78fa3          	sb	a3,-1(a5)
80000b0c:	0037f693          	andi	a3,a5,3
80000b10:	fe0696e3          	bnez	a3,80000afc <memcpy+0xa8>
80000b14:	f89ff06f          	j	80000a9c <memcpy+0x48>
80000b18:	00050793          	mv	a5,a0
80000b1c:	ff1ff06f          	j	80000b0c <memcpy+0xb8>
80000b20:	0005a603          	lw	a2,0(a1)
80000b24:	00478793          	addi	a5,a5,4
80000b28:	00458593          	addi	a1,a1,4
80000b2c:	fec7ae23          	sw	a2,-4(a5)
80000b30:	fed7e8e3          	bltu	a5,a3,80000b20 <memcpy+0xcc>
80000b34:	f4e7eae3          	bltu	a5,a4,80000a88 <memcpy+0x34>
80000b38:	00008067          	ret

80000b3c <strcmp>:
80000b3c:	00b56733          	or	a4,a0,a1
80000b40:	fff00393          	li	t2,-1
80000b44:	00377713          	andi	a4,a4,3
80000b48:	10071063          	bnez	a4,80000c48 <strcmp+0x10c>
80000b4c:	7f7f87b7          	lui	a5,0x7f7f8
80000b50:	f7f78793          	addi	a5,a5,-129 # 7f7f7f7f <_stack_size+0x7f7f7b7f>
80000b54:	00052603          	lw	a2,0(a0)
80000b58:	0005a683          	lw	a3,0(a1)
80000b5c:	00f672b3          	and	t0,a2,a5
80000b60:	00f66333          	or	t1,a2,a5
80000b64:	00f282b3          	add	t0,t0,a5
80000b68:	0062e2b3          	or	t0,t0,t1
80000b6c:	10729263          	bne	t0,t2,80000c70 <strcmp+0x134>
80000b70:	08d61663          	bne	a2,a3,80000bfc <strcmp+0xc0>
80000b74:	00452603          	lw	a2,4(a0)
80000b78:	0045a683          	lw	a3,4(a1)
80000b7c:	00f672b3          	and	t0,a2,a5
80000b80:	00f66333          	or	t1,a2,a5
80000b84:	00f282b3          	add	t0,t0,a5
80000b88:	0062e2b3          	or	t0,t0,t1
80000b8c:	0c729e63          	bne	t0,t2,80000c68 <strcmp+0x12c>
80000b90:	06d61663          	bne	a2,a3,80000bfc <strcmp+0xc0>
80000b94:	00852603          	lw	a2,8(a0)
80000b98:	0085a683          	lw	a3,8(a1)
80000b9c:	00f672b3          	and	t0,a2,a5
80000ba0:	00f66333          	or	t1,a2,a5
80000ba4:	00f282b3          	add	t0,t0,a5
80000ba8:	0062e2b3          	or	t0,t0,t1
80000bac:	0c729863          	bne	t0,t2,80000c7c <strcmp+0x140>
80000bb0:	04d61663          	bne	a2,a3,80000bfc <strcmp+0xc0>
80000bb4:	00c52603          	lw	a2,12(a0)
80000bb8:	00c5a683          	lw	a3,12(a1)
80000bbc:	00f672b3          	and	t0,a2,a5
80000bc0:	00f66333          	or	t1,a2,a5
80000bc4:	00f282b3          	add	t0,t0,a5
80000bc8:	0062e2b3          	or	t0,t0,t1
80000bcc:	0c729263          	bne	t0,t2,80000c90 <strcmp+0x154>
80000bd0:	02d61663          	bne	a2,a3,80000bfc <strcmp+0xc0>
80000bd4:	01052603          	lw	a2,16(a0)
80000bd8:	0105a683          	lw	a3,16(a1)
80000bdc:	00f672b3          	and	t0,a2,a5
80000be0:	00f66333          	or	t1,a2,a5
80000be4:	00f282b3          	add	t0,t0,a5
80000be8:	0062e2b3          	or	t0,t0,t1
80000bec:	0a729c63          	bne	t0,t2,80000ca4 <strcmp+0x168>
80000bf0:	01450513          	addi	a0,a0,20
80000bf4:	01458593          	addi	a1,a1,20
80000bf8:	f4d60ee3          	beq	a2,a3,80000b54 <strcmp+0x18>
80000bfc:	01061713          	slli	a4,a2,0x10
80000c00:	01069793          	slli	a5,a3,0x10
80000c04:	00f71e63          	bne	a4,a5,80000c20 <strcmp+0xe4>
80000c08:	01065713          	srli	a4,a2,0x10
80000c0c:	0106d793          	srli	a5,a3,0x10
80000c10:	40f70533          	sub	a0,a4,a5
80000c14:	0ff57593          	andi	a1,a0,255
80000c18:	02059063          	bnez	a1,80000c38 <strcmp+0xfc>
80000c1c:	00008067          	ret
80000c20:	01075713          	srli	a4,a4,0x10
80000c24:	0107d793          	srli	a5,a5,0x10
80000c28:	40f70533          	sub	a0,a4,a5
80000c2c:	0ff57593          	andi	a1,a0,255
80000c30:	00059463          	bnez	a1,80000c38 <strcmp+0xfc>
80000c34:	00008067          	ret
80000c38:	0ff77713          	andi	a4,a4,255
80000c3c:	0ff7f793          	andi	a5,a5,255
80000c40:	40f70533          	sub	a0,a4,a5
80000c44:	00008067          	ret
80000c48:	00054603          	lbu	a2,0(a0)
80000c4c:	0005c683          	lbu	a3,0(a1)
80000c50:	00150513          	addi	a0,a0,1
80000c54:	00158593          	addi	a1,a1,1
80000c58:	00d61463          	bne	a2,a3,80000c60 <strcmp+0x124>
80000c5c:	fe0616e3          	bnez	a2,80000c48 <strcmp+0x10c>
80000c60:	40d60533          	sub	a0,a2,a3
80000c64:	00008067          	ret
80000c68:	00450513          	addi	a0,a0,4
80000c6c:	00458593          	addi	a1,a1,4
80000c70:	fcd61ce3          	bne	a2,a3,80000c48 <strcmp+0x10c>
80000c74:	00000513          	li	a0,0
80000c78:	00008067          	ret
80000c7c:	00850513          	addi	a0,a0,8
80000c80:	00858593          	addi	a1,a1,8
80000c84:	fcd612e3          	bne	a2,a3,80000c48 <strcmp+0x10c>
80000c88:	00000513          	li	a0,0
80000c8c:	00008067          	ret
80000c90:	00c50513          	addi	a0,a0,12
80000c94:	00c58593          	addi	a1,a1,12
80000c98:	fad618e3          	bne	a2,a3,80000c48 <strcmp+0x10c>
80000c9c:	00000513          	li	a0,0
80000ca0:	00008067          	ret
80000ca4:	01050513          	addi	a0,a0,16
80000ca8:	01058593          	addi	a1,a1,16
80000cac:	f8d61ee3          	bne	a2,a3,80000c48 <strcmp+0x10c>
80000cb0:	00000513          	li	a0,0
80000cb4:	00008067          	ret

80000cb8 <__divdf3>:
80000cb8:	fd010113          	addi	sp,sp,-48
80000cbc:	02812423          	sw	s0,40(sp)
80000cc0:	02912223          	sw	s1,36(sp)
80000cc4:	01612823          	sw	s6,16(sp)
80000cc8:	00050413          	mv	s0,a0
80000ccc:	00050b13          	mv	s6,a0
80000cd0:	001004b7          	lui	s1,0x100
80000cd4:	0145d513          	srli	a0,a1,0x14
80000cd8:	03212023          	sw	s2,32(sp)
80000cdc:	01312e23          	sw	s3,28(sp)
80000ce0:	01712623          	sw	s7,12(sp)
80000ce4:	fff48493          	addi	s1,s1,-1 # fffff <_stack_size+0xffbff>
80000ce8:	02112623          	sw	ra,44(sp)
80000cec:	01412c23          	sw	s4,24(sp)
80000cf0:	01512a23          	sw	s5,20(sp)
80000cf4:	7ff57513          	andi	a0,a0,2047
80000cf8:	00060b93          	mv	s7,a2
80000cfc:	00068993          	mv	s3,a3
80000d00:	00b4f4b3          	and	s1,s1,a1
80000d04:	01f5d913          	srli	s2,a1,0x1f
80000d08:	0a050663          	beqz	a0,80000db4 <__divdf3+0xfc>
80000d0c:	7ff00793          	li	a5,2047
80000d10:	10f50663          	beq	a0,a5,80000e1c <__divdf3+0x164>
80000d14:	00349493          	slli	s1,s1,0x3
80000d18:	008006b7          	lui	a3,0x800
80000d1c:	00d4e4b3          	or	s1,s1,a3
80000d20:	01db5a93          	srli	s5,s6,0x1d
80000d24:	009aeab3          	or	s5,s5,s1
80000d28:	003b1413          	slli	s0,s6,0x3
80000d2c:	c0150a13          	addi	s4,a0,-1023
80000d30:	00000b13          	li	s6,0
80000d34:	0149d513          	srli	a0,s3,0x14
80000d38:	001004b7          	lui	s1,0x100
80000d3c:	fff48493          	addi	s1,s1,-1 # fffff <_stack_size+0xffbff>
80000d40:	7ff57513          	andi	a0,a0,2047
80000d44:	0134f4b3          	and	s1,s1,s3
80000d48:	000b8f93          	mv	t6,s7
80000d4c:	01f9d993          	srli	s3,s3,0x1f
80000d50:	10050263          	beqz	a0,80000e54 <__divdf3+0x19c>
80000d54:	7ff00793          	li	a5,2047
80000d58:	16f50263          	beq	a0,a5,80000ebc <__divdf3+0x204>
80000d5c:	008007b7          	lui	a5,0x800
80000d60:	00349493          	slli	s1,s1,0x3
80000d64:	00f4e4b3          	or	s1,s1,a5
80000d68:	01dbd793          	srli	a5,s7,0x1d
80000d6c:	0097e7b3          	or	a5,a5,s1
80000d70:	003b9f93          	slli	t6,s7,0x3
80000d74:	c0150513          	addi	a0,a0,-1023
80000d78:	00000713          	li	a4,0
80000d7c:	002b1693          	slli	a3,s6,0x2
80000d80:	00e6e6b3          	or	a3,a3,a4
80000d84:	fff68693          	addi	a3,a3,-1 # 7fffff <_stack_size+0x7ffbff>
80000d88:	00e00593          	li	a1,14
80000d8c:	01394633          	xor	a2,s2,s3
80000d90:	40aa0533          	sub	a0,s4,a0
80000d94:	16d5e063          	bltu	a1,a3,80000ef4 <__divdf3+0x23c>
80000d98:	00002597          	auipc	a1,0x2
80000d9c:	11c58593          	addi	a1,a1,284 # 80002eb4 <end+0x5e0>
80000da0:	00269693          	slli	a3,a3,0x2
80000da4:	00b686b3          	add	a3,a3,a1
80000da8:	0006a683          	lw	a3,0(a3)
80000dac:	00b686b3          	add	a3,a3,a1
80000db0:	00068067          	jr	a3
80000db4:	0164eab3          	or	s5,s1,s6
80000db8:	060a8e63          	beqz	s5,80000e34 <__divdf3+0x17c>
80000dbc:	04048063          	beqz	s1,80000dfc <__divdf3+0x144>
80000dc0:	00048513          	mv	a0,s1
80000dc4:	2c5010ef          	jal	ra,80002888 <__clzsi2>
80000dc8:	ff550793          	addi	a5,a0,-11
80000dcc:	01c00713          	li	a4,28
80000dd0:	02f74e63          	blt	a4,a5,80000e0c <__divdf3+0x154>
80000dd4:	01d00a93          	li	s5,29
80000dd8:	ff850413          	addi	s0,a0,-8
80000ddc:	40fa8ab3          	sub	s5,s5,a5
80000de0:	008494b3          	sll	s1,s1,s0
80000de4:	015b5ab3          	srl	s5,s6,s5
80000de8:	009aeab3          	or	s5,s5,s1
80000dec:	008b1433          	sll	s0,s6,s0
80000df0:	c0d00a13          	li	s4,-1011
80000df4:	40aa0a33          	sub	s4,s4,a0
80000df8:	f39ff06f          	j	80000d30 <__divdf3+0x78>
80000dfc:	000b0513          	mv	a0,s6
80000e00:	289010ef          	jal	ra,80002888 <__clzsi2>
80000e04:	02050513          	addi	a0,a0,32
80000e08:	fc1ff06f          	j	80000dc8 <__divdf3+0x110>
80000e0c:	fd850493          	addi	s1,a0,-40
80000e10:	009b1ab3          	sll	s5,s6,s1
80000e14:	00000413          	li	s0,0
80000e18:	fd9ff06f          	j	80000df0 <__divdf3+0x138>
80000e1c:	0164eab3          	or	s5,s1,s6
80000e20:	020a8263          	beqz	s5,80000e44 <__divdf3+0x18c>
80000e24:	00048a93          	mv	s5,s1
80000e28:	7ff00a13          	li	s4,2047
80000e2c:	00300b13          	li	s6,3
80000e30:	f05ff06f          	j	80000d34 <__divdf3+0x7c>
80000e34:	00000413          	li	s0,0
80000e38:	00000a13          	li	s4,0
80000e3c:	00100b13          	li	s6,1
80000e40:	ef5ff06f          	j	80000d34 <__divdf3+0x7c>
80000e44:	00000413          	li	s0,0
80000e48:	7ff00a13          	li	s4,2047
80000e4c:	00200b13          	li	s6,2
80000e50:	ee5ff06f          	j	80000d34 <__divdf3+0x7c>
80000e54:	0174e7b3          	or	a5,s1,s7
80000e58:	06078e63          	beqz	a5,80000ed4 <__divdf3+0x21c>
80000e5c:	04048063          	beqz	s1,80000e9c <__divdf3+0x1e4>
80000e60:	00048513          	mv	a0,s1
80000e64:	225010ef          	jal	ra,80002888 <__clzsi2>
80000e68:	ff550713          	addi	a4,a0,-11
80000e6c:	01c00793          	li	a5,28
80000e70:	02e7ce63          	blt	a5,a4,80000eac <__divdf3+0x1f4>
80000e74:	01d00793          	li	a5,29
80000e78:	ff850f93          	addi	t6,a0,-8
80000e7c:	40e787b3          	sub	a5,a5,a4
80000e80:	01f494b3          	sll	s1,s1,t6
80000e84:	00fbd7b3          	srl	a5,s7,a5
80000e88:	0097e7b3          	or	a5,a5,s1
80000e8c:	01fb9fb3          	sll	t6,s7,t6
80000e90:	c0d00613          	li	a2,-1011
80000e94:	40a60533          	sub	a0,a2,a0
80000e98:	ee1ff06f          	j	80000d78 <__divdf3+0xc0>
80000e9c:	000b8513          	mv	a0,s7
80000ea0:	1e9010ef          	jal	ra,80002888 <__clzsi2>
80000ea4:	02050513          	addi	a0,a0,32
80000ea8:	fc1ff06f          	j	80000e68 <__divdf3+0x1b0>
80000eac:	fd850793          	addi	a5,a0,-40
80000eb0:	00fb97b3          	sll	a5,s7,a5
80000eb4:	00000f93          	li	t6,0
80000eb8:	fd9ff06f          	j	80000e90 <__divdf3+0x1d8>
80000ebc:	0174e7b3          	or	a5,s1,s7
80000ec0:	02078263          	beqz	a5,80000ee4 <__divdf3+0x22c>
80000ec4:	00048793          	mv	a5,s1
80000ec8:	7ff00513          	li	a0,2047
80000ecc:	00300713          	li	a4,3
80000ed0:	eadff06f          	j	80000d7c <__divdf3+0xc4>
80000ed4:	00000f93          	li	t6,0
80000ed8:	00000513          	li	a0,0
80000edc:	00100713          	li	a4,1
80000ee0:	e9dff06f          	j	80000d7c <__divdf3+0xc4>
80000ee4:	00000f93          	li	t6,0
80000ee8:	7ff00513          	li	a0,2047
80000eec:	00200713          	li	a4,2
80000ef0:	e8dff06f          	j	80000d7c <__divdf3+0xc4>
80000ef4:	0157e663          	bltu	a5,s5,80000f00 <__divdf3+0x248>
80000ef8:	36fa9063          	bne	s5,a5,80001258 <__divdf3+0x5a0>
80000efc:	35f46e63          	bltu	s0,t6,80001258 <__divdf3+0x5a0>
80000f00:	01fa9593          	slli	a1,s5,0x1f
80000f04:	00145693          	srli	a3,s0,0x1
80000f08:	01f41713          	slli	a4,s0,0x1f
80000f0c:	001ada93          	srli	s5,s5,0x1
80000f10:	00d5e433          	or	s0,a1,a3
80000f14:	00879793          	slli	a5,a5,0x8
80000f18:	018fd813          	srli	a6,t6,0x18
80000f1c:	00f86833          	or	a6,a6,a5
80000f20:	01085e93          	srli	t4,a6,0x10
80000f24:	03dad5b3          	divu	a1,s5,t4
80000f28:	01081e13          	slli	t3,a6,0x10
80000f2c:	010e5e13          	srli	t3,t3,0x10
80000f30:	01045693          	srli	a3,s0,0x10
80000f34:	008f9893          	slli	a7,t6,0x8
80000f38:	03daf4b3          	remu	s1,s5,t4
80000f3c:	00058f93          	mv	t6,a1
80000f40:	02be07b3          	mul	a5,t3,a1
80000f44:	01049493          	slli	s1,s1,0x10
80000f48:	0096e6b3          	or	a3,a3,s1
80000f4c:	00f6fe63          	bleu	a5,a3,80000f68 <__divdf3+0x2b0>
80000f50:	010686b3          	add	a3,a3,a6
80000f54:	fff58f93          	addi	t6,a1,-1
80000f58:	0106e863          	bltu	a3,a6,80000f68 <__divdf3+0x2b0>
80000f5c:	00f6f663          	bleu	a5,a3,80000f68 <__divdf3+0x2b0>
80000f60:	ffe58f93          	addi	t6,a1,-2
80000f64:	010686b3          	add	a3,a3,a6
80000f68:	40f686b3          	sub	a3,a3,a5
80000f6c:	03d6d333          	divu	t1,a3,t4
80000f70:	01041413          	slli	s0,s0,0x10
80000f74:	01045413          	srli	s0,s0,0x10
80000f78:	03d6f6b3          	remu	a3,a3,t4
80000f7c:	00030793          	mv	a5,t1
80000f80:	026e05b3          	mul	a1,t3,t1
80000f84:	01069693          	slli	a3,a3,0x10
80000f88:	00d466b3          	or	a3,s0,a3
80000f8c:	00b6fe63          	bleu	a1,a3,80000fa8 <__divdf3+0x2f0>
80000f90:	010686b3          	add	a3,a3,a6
80000f94:	fff30793          	addi	a5,t1,-1
80000f98:	0106e863          	bltu	a3,a6,80000fa8 <__divdf3+0x2f0>
80000f9c:	00b6f663          	bleu	a1,a3,80000fa8 <__divdf3+0x2f0>
80000fa0:	ffe30793          	addi	a5,t1,-2
80000fa4:	010686b3          	add	a3,a3,a6
80000fa8:	40b68433          	sub	s0,a3,a1
80000fac:	010f9f93          	slli	t6,t6,0x10
80000fb0:	000105b7          	lui	a1,0x10
80000fb4:	00ffefb3          	or	t6,t6,a5
80000fb8:	fff58313          	addi	t1,a1,-1 # ffff <_stack_size+0xfbff>
80000fbc:	010fd693          	srli	a3,t6,0x10
80000fc0:	006ff7b3          	and	a5,t6,t1
80000fc4:	0108df13          	srli	t5,a7,0x10
80000fc8:	0068f333          	and	t1,a7,t1
80000fcc:	026783b3          	mul	t2,a5,t1
80000fd0:	026684b3          	mul	s1,a3,t1
80000fd4:	02ff07b3          	mul	a5,t5,a5
80000fd8:	03e682b3          	mul	t0,a3,t5
80000fdc:	009786b3          	add	a3,a5,s1
80000fe0:	0103d793          	srli	a5,t2,0x10
80000fe4:	00d787b3          	add	a5,a5,a3
80000fe8:	0097f463          	bleu	s1,a5,80000ff0 <__divdf3+0x338>
80000fec:	00b282b3          	add	t0,t0,a1
80000ff0:	0107d693          	srli	a3,a5,0x10
80000ff4:	005686b3          	add	a3,a3,t0
80000ff8:	000102b7          	lui	t0,0x10
80000ffc:	fff28293          	addi	t0,t0,-1 # ffff <_stack_size+0xfbff>
80001000:	0057f5b3          	and	a1,a5,t0
80001004:	01059593          	slli	a1,a1,0x10
80001008:	0053f3b3          	and	t2,t2,t0
8000100c:	007585b3          	add	a1,a1,t2
80001010:	00d46863          	bltu	s0,a3,80001020 <__divdf3+0x368>
80001014:	000f8793          	mv	a5,t6
80001018:	04d41463          	bne	s0,a3,80001060 <__divdf3+0x3a8>
8000101c:	04b77263          	bleu	a1,a4,80001060 <__divdf3+0x3a8>
80001020:	01170733          	add	a4,a4,a7
80001024:	011732b3          	sltu	t0,a4,a7
80001028:	010282b3          	add	t0,t0,a6
8000102c:	00540433          	add	s0,s0,t0
80001030:	ffff8793          	addi	a5,t6,-1
80001034:	00886663          	bltu	a6,s0,80001040 <__divdf3+0x388>
80001038:	02881463          	bne	a6,s0,80001060 <__divdf3+0x3a8>
8000103c:	03176263          	bltu	a4,a7,80001060 <__divdf3+0x3a8>
80001040:	00d46663          	bltu	s0,a3,8000104c <__divdf3+0x394>
80001044:	00869e63          	bne	a3,s0,80001060 <__divdf3+0x3a8>
80001048:	00b77c63          	bleu	a1,a4,80001060 <__divdf3+0x3a8>
8000104c:	01170733          	add	a4,a4,a7
80001050:	ffef8793          	addi	a5,t6,-2
80001054:	01173fb3          	sltu	t6,a4,a7
80001058:	010f8fb3          	add	t6,t6,a6
8000105c:	01f40433          	add	s0,s0,t6
80001060:	40b705b3          	sub	a1,a4,a1
80001064:	40d40433          	sub	s0,s0,a3
80001068:	00b73733          	sltu	a4,a4,a1
8000106c:	40e40433          	sub	s0,s0,a4
80001070:	fff00f93          	li	t6,-1
80001074:	12880463          	beq	a6,s0,8000119c <__divdf3+0x4e4>
80001078:	03d452b3          	divu	t0,s0,t4
8000107c:	0105d693          	srli	a3,a1,0x10
80001080:	03d47433          	remu	s0,s0,t4
80001084:	00028713          	mv	a4,t0
80001088:	025e0fb3          	mul	t6,t3,t0
8000108c:	01041413          	slli	s0,s0,0x10
80001090:	0086e433          	or	s0,a3,s0
80001094:	01f47e63          	bleu	t6,s0,800010b0 <__divdf3+0x3f8>
80001098:	01040433          	add	s0,s0,a6
8000109c:	fff28713          	addi	a4,t0,-1
800010a0:	01046863          	bltu	s0,a6,800010b0 <__divdf3+0x3f8>
800010a4:	01f47663          	bleu	t6,s0,800010b0 <__divdf3+0x3f8>
800010a8:	ffe28713          	addi	a4,t0,-2
800010ac:	01040433          	add	s0,s0,a6
800010b0:	41f40433          	sub	s0,s0,t6
800010b4:	03d456b3          	divu	a3,s0,t4
800010b8:	01059593          	slli	a1,a1,0x10
800010bc:	0105d593          	srli	a1,a1,0x10
800010c0:	03d47433          	remu	s0,s0,t4
800010c4:	02de0e33          	mul	t3,t3,a3
800010c8:	01041413          	slli	s0,s0,0x10
800010cc:	0085e433          	or	s0,a1,s0
800010d0:	00068593          	mv	a1,a3
800010d4:	01c47e63          	bleu	t3,s0,800010f0 <__divdf3+0x438>
800010d8:	01040433          	add	s0,s0,a6
800010dc:	fff68593          	addi	a1,a3,-1
800010e0:	01046863          	bltu	s0,a6,800010f0 <__divdf3+0x438>
800010e4:	01c47663          	bleu	t3,s0,800010f0 <__divdf3+0x438>
800010e8:	ffe68593          	addi	a1,a3,-2
800010ec:	01040433          	add	s0,s0,a6
800010f0:	01071713          	slli	a4,a4,0x10
800010f4:	00b765b3          	or	a1,a4,a1
800010f8:	01059713          	slli	a4,a1,0x10
800010fc:	01075713          	srli	a4,a4,0x10
80001100:	41c40433          	sub	s0,s0,t3
80001104:	0105de13          	srli	t3,a1,0x10
80001108:	02670eb3          	mul	t4,a4,t1
8000110c:	026e0333          	mul	t1,t3,t1
80001110:	03cf0e33          	mul	t3,t5,t3
80001114:	02ef0f33          	mul	t5,t5,a4
80001118:	010ed713          	srli	a4,t4,0x10
8000111c:	006f0f33          	add	t5,t5,t1
80001120:	01e70733          	add	a4,a4,t5
80001124:	00677663          	bleu	t1,a4,80001130 <__divdf3+0x478>
80001128:	000106b7          	lui	a3,0x10
8000112c:	00de0e33          	add	t3,t3,a3
80001130:	01075313          	srli	t1,a4,0x10
80001134:	01c30333          	add	t1,t1,t3
80001138:	00010e37          	lui	t3,0x10
8000113c:	fffe0e13          	addi	t3,t3,-1 # ffff <_stack_size+0xfbff>
80001140:	01c776b3          	and	a3,a4,t3
80001144:	01069693          	slli	a3,a3,0x10
80001148:	01cefeb3          	and	t4,t4,t3
8000114c:	01d686b3          	add	a3,a3,t4
80001150:	00646863          	bltu	s0,t1,80001160 <__divdf3+0x4a8>
80001154:	00058f93          	mv	t6,a1
80001158:	04641063          	bne	s0,t1,80001198 <__divdf3+0x4e0>
8000115c:	04068063          	beqz	a3,8000119c <__divdf3+0x4e4>
80001160:	00880433          	add	s0,a6,s0
80001164:	fff58f93          	addi	t6,a1,-1
80001168:	03046463          	bltu	s0,a6,80001190 <__divdf3+0x4d8>
8000116c:	00646663          	bltu	s0,t1,80001178 <__divdf3+0x4c0>
80001170:	02641463          	bne	s0,t1,80001198 <__divdf3+0x4e0>
80001174:	02d8f063          	bleu	a3,a7,80001194 <__divdf3+0x4dc>
80001178:	00189713          	slli	a4,a7,0x1
8000117c:	011738b3          	sltu	a7,a4,a7
80001180:	01088833          	add	a6,a7,a6
80001184:	ffe58f93          	addi	t6,a1,-2
80001188:	01040433          	add	s0,s0,a6
8000118c:	00070893          	mv	a7,a4
80001190:	00641463          	bne	s0,t1,80001198 <__divdf3+0x4e0>
80001194:	01168463          	beq	a3,a7,8000119c <__divdf3+0x4e4>
80001198:	001fef93          	ori	t6,t6,1
8000119c:	3ff50693          	addi	a3,a0,1023
800011a0:	10d05a63          	blez	a3,800012b4 <__divdf3+0x5fc>
800011a4:	007ff713          	andi	a4,t6,7
800011a8:	02070063          	beqz	a4,800011c8 <__divdf3+0x510>
800011ac:	00fff713          	andi	a4,t6,15
800011b0:	00400593          	li	a1,4
800011b4:	00b70a63          	beq	a4,a1,800011c8 <__divdf3+0x510>
800011b8:	004f8593          	addi	a1,t6,4
800011bc:	01f5bfb3          	sltu	t6,a1,t6
800011c0:	01f787b3          	add	a5,a5,t6
800011c4:	00058f93          	mv	t6,a1
800011c8:	00779713          	slli	a4,a5,0x7
800011cc:	00075a63          	bgez	a4,800011e0 <__divdf3+0x528>
800011d0:	ff000737          	lui	a4,0xff000
800011d4:	fff70713          	addi	a4,a4,-1 # feffffff <_stack_start+0x7eff9f2f>
800011d8:	00e7f7b3          	and	a5,a5,a4
800011dc:	40050693          	addi	a3,a0,1024
800011e0:	7fe00713          	li	a4,2046
800011e4:	18d74a63          	blt	a4,a3,80001378 <__divdf3+0x6c0>
800011e8:	01d79713          	slli	a4,a5,0x1d
800011ec:	003fdf93          	srli	t6,t6,0x3
800011f0:	01f76733          	or	a4,a4,t6
800011f4:	0037d793          	srli	a5,a5,0x3
800011f8:	001005b7          	lui	a1,0x100
800011fc:	fff58593          	addi	a1,a1,-1 # fffff <_stack_size+0xffbff>
80001200:	00b7f7b3          	and	a5,a5,a1
80001204:	801005b7          	lui	a1,0x80100
80001208:	fff58593          	addi	a1,a1,-1 # 800fffff <_stack_start+0xf9f2f>
8000120c:	7ff6f693          	andi	a3,a3,2047
80001210:	01469693          	slli	a3,a3,0x14
80001214:	00b7f7b3          	and	a5,a5,a1
80001218:	02c12083          	lw	ra,44(sp)
8000121c:	02812403          	lw	s0,40(sp)
80001220:	01f61613          	slli	a2,a2,0x1f
80001224:	00d7e7b3          	or	a5,a5,a3
80001228:	00c7e6b3          	or	a3,a5,a2
8000122c:	02412483          	lw	s1,36(sp)
80001230:	02012903          	lw	s2,32(sp)
80001234:	01c12983          	lw	s3,28(sp)
80001238:	01812a03          	lw	s4,24(sp)
8000123c:	01412a83          	lw	s5,20(sp)
80001240:	01012b03          	lw	s6,16(sp)
80001244:	00c12b83          	lw	s7,12(sp)
80001248:	00070513          	mv	a0,a4
8000124c:	00068593          	mv	a1,a3
80001250:	03010113          	addi	sp,sp,48
80001254:	00008067          	ret
80001258:	fff50513          	addi	a0,a0,-1
8000125c:	00000713          	li	a4,0
80001260:	cb5ff06f          	j	80000f14 <__divdf3+0x25c>
80001264:	00090613          	mv	a2,s2
80001268:	000a8793          	mv	a5,s5
8000126c:	00040f93          	mv	t6,s0
80001270:	000b0713          	mv	a4,s6
80001274:	00200693          	li	a3,2
80001278:	10d70063          	beq	a4,a3,80001378 <__divdf3+0x6c0>
8000127c:	00300693          	li	a3,3
80001280:	0ed70263          	beq	a4,a3,80001364 <__divdf3+0x6ac>
80001284:	00100693          	li	a3,1
80001288:	f0d71ae3          	bne	a4,a3,8000119c <__divdf3+0x4e4>
8000128c:	00000793          	li	a5,0
80001290:	00000713          	li	a4,0
80001294:	0940006f          	j	80001328 <__divdf3+0x670>
80001298:	00098613          	mv	a2,s3
8000129c:	fd9ff06f          	j	80001274 <__divdf3+0x5bc>
800012a0:	000807b7          	lui	a5,0x80
800012a4:	00000f93          	li	t6,0
800012a8:	00000613          	li	a2,0
800012ac:	00300713          	li	a4,3
800012b0:	fc5ff06f          	j	80001274 <__divdf3+0x5bc>
800012b4:	00100593          	li	a1,1
800012b8:	40d585b3          	sub	a1,a1,a3
800012bc:	03800713          	li	a4,56
800012c0:	fcb746e3          	blt	a4,a1,8000128c <__divdf3+0x5d4>
800012c4:	01f00713          	li	a4,31
800012c8:	06b74463          	blt	a4,a1,80001330 <__divdf3+0x678>
800012cc:	41e50513          	addi	a0,a0,1054
800012d0:	00a79733          	sll	a4,a5,a0
800012d4:	00bfd6b3          	srl	a3,t6,a1
800012d8:	00af9533          	sll	a0,t6,a0
800012dc:	00d76733          	or	a4,a4,a3
800012e0:	00a03533          	snez	a0,a0
800012e4:	00a76733          	or	a4,a4,a0
800012e8:	00b7d7b3          	srl	a5,a5,a1
800012ec:	00777693          	andi	a3,a4,7
800012f0:	02068063          	beqz	a3,80001310 <__divdf3+0x658>
800012f4:	00f77693          	andi	a3,a4,15
800012f8:	00400593          	li	a1,4
800012fc:	00b68a63          	beq	a3,a1,80001310 <__divdf3+0x658>
80001300:	00470693          	addi	a3,a4,4
80001304:	00e6b733          	sltu	a4,a3,a4
80001308:	00e787b3          	add	a5,a5,a4
8000130c:	00068713          	mv	a4,a3
80001310:	00879693          	slli	a3,a5,0x8
80001314:	0606ca63          	bltz	a3,80001388 <__divdf3+0x6d0>
80001318:	01d79693          	slli	a3,a5,0x1d
8000131c:	00375713          	srli	a4,a4,0x3
80001320:	00e6e733          	or	a4,a3,a4
80001324:	0037d793          	srli	a5,a5,0x3
80001328:	00000693          	li	a3,0
8000132c:	ecdff06f          	j	800011f8 <__divdf3+0x540>
80001330:	fe100713          	li	a4,-31
80001334:	40d70733          	sub	a4,a4,a3
80001338:	02000813          	li	a6,32
8000133c:	00e7d733          	srl	a4,a5,a4
80001340:	00000693          	li	a3,0
80001344:	01058663          	beq	a1,a6,80001350 <__divdf3+0x698>
80001348:	43e50513          	addi	a0,a0,1086
8000134c:	00a796b3          	sll	a3,a5,a0
80001350:	01f6e533          	or	a0,a3,t6
80001354:	00a03533          	snez	a0,a0
80001358:	00a76733          	or	a4,a4,a0
8000135c:	00000793          	li	a5,0
80001360:	f8dff06f          	j	800012ec <__divdf3+0x634>
80001364:	000807b7          	lui	a5,0x80
80001368:	00000713          	li	a4,0
8000136c:	7ff00693          	li	a3,2047
80001370:	00000613          	li	a2,0
80001374:	e85ff06f          	j	800011f8 <__divdf3+0x540>
80001378:	00000793          	li	a5,0
8000137c:	00000713          	li	a4,0
80001380:	7ff00693          	li	a3,2047
80001384:	e75ff06f          	j	800011f8 <__divdf3+0x540>
80001388:	00000793          	li	a5,0
8000138c:	00000713          	li	a4,0
80001390:	00100693          	li	a3,1
80001394:	e65ff06f          	j	800011f8 <__divdf3+0x540>

80001398 <__muldf3>:
80001398:	fd010113          	addi	sp,sp,-48
8000139c:	03212023          	sw	s2,32(sp)
800013a0:	01512a23          	sw	s5,20(sp)
800013a4:	00100937          	lui	s2,0x100
800013a8:	0145da93          	srli	s5,a1,0x14
800013ac:	01312e23          	sw	s3,28(sp)
800013b0:	01412c23          	sw	s4,24(sp)
800013b4:	01612823          	sw	s6,16(sp)
800013b8:	01712623          	sw	s7,12(sp)
800013bc:	fff90913          	addi	s2,s2,-1 # fffff <_stack_size+0xffbff>
800013c0:	02112623          	sw	ra,44(sp)
800013c4:	02812423          	sw	s0,40(sp)
800013c8:	02912223          	sw	s1,36(sp)
800013cc:	7ffafa93          	andi	s5,s5,2047
800013d0:	00050b13          	mv	s6,a0
800013d4:	00060b93          	mv	s7,a2
800013d8:	00068a13          	mv	s4,a3
800013dc:	00b97933          	and	s2,s2,a1
800013e0:	01f5d993          	srli	s3,a1,0x1f
800013e4:	0a0a8863          	beqz	s5,80001494 <__muldf3+0xfc>
800013e8:	7ff00793          	li	a5,2047
800013ec:	10fa8663          	beq	s5,a5,800014f8 <__muldf3+0x160>
800013f0:	00800437          	lui	s0,0x800
800013f4:	00391913          	slli	s2,s2,0x3
800013f8:	00896933          	or	s2,s2,s0
800013fc:	01d55413          	srli	s0,a0,0x1d
80001400:	01246433          	or	s0,s0,s2
80001404:	00351493          	slli	s1,a0,0x3
80001408:	c01a8a93          	addi	s5,s5,-1023
8000140c:	00000b13          	li	s6,0
80001410:	014a5513          	srli	a0,s4,0x14
80001414:	00100937          	lui	s2,0x100
80001418:	fff90913          	addi	s2,s2,-1 # fffff <_stack_size+0xffbff>
8000141c:	7ff57513          	andi	a0,a0,2047
80001420:	01497933          	and	s2,s2,s4
80001424:	000b8713          	mv	a4,s7
80001428:	01fa5a13          	srli	s4,s4,0x1f
8000142c:	10050463          	beqz	a0,80001534 <__muldf3+0x19c>
80001430:	7ff00793          	li	a5,2047
80001434:	16f50463          	beq	a0,a5,8000159c <__muldf3+0x204>
80001438:	008007b7          	lui	a5,0x800
8000143c:	00391913          	slli	s2,s2,0x3
80001440:	00f96933          	or	s2,s2,a5
80001444:	01dbd793          	srli	a5,s7,0x1d
80001448:	0127e7b3          	or	a5,a5,s2
8000144c:	003b9713          	slli	a4,s7,0x3
80001450:	c0150513          	addi	a0,a0,-1023
80001454:	00000693          	li	a3,0
80001458:	002b1593          	slli	a1,s6,0x2
8000145c:	00d5e5b3          	or	a1,a1,a3
80001460:	00aa8533          	add	a0,s5,a0
80001464:	fff58593          	addi	a1,a1,-1
80001468:	00e00893          	li	a7,14
8000146c:	0149c633          	xor	a2,s3,s4
80001470:	00150813          	addi	a6,a0,1
80001474:	16b8e063          	bltu	a7,a1,800015d4 <__muldf3+0x23c>
80001478:	00002517          	auipc	a0,0x2
8000147c:	a7850513          	addi	a0,a0,-1416 # 80002ef0 <end+0x61c>
80001480:	00259593          	slli	a1,a1,0x2
80001484:	00a585b3          	add	a1,a1,a0
80001488:	0005a583          	lw	a1,0(a1)
8000148c:	00a585b3          	add	a1,a1,a0
80001490:	00058067          	jr	a1
80001494:	00a96433          	or	s0,s2,a0
80001498:	06040e63          	beqz	s0,80001514 <__muldf3+0x17c>
8000149c:	04090063          	beqz	s2,800014dc <__muldf3+0x144>
800014a0:	00090513          	mv	a0,s2
800014a4:	3e4010ef          	jal	ra,80002888 <__clzsi2>
800014a8:	ff550793          	addi	a5,a0,-11
800014ac:	01c00713          	li	a4,28
800014b0:	02f74c63          	blt	a4,a5,800014e8 <__muldf3+0x150>
800014b4:	01d00413          	li	s0,29
800014b8:	ff850493          	addi	s1,a0,-8
800014bc:	40f40433          	sub	s0,s0,a5
800014c0:	00991933          	sll	s2,s2,s1
800014c4:	008b5433          	srl	s0,s6,s0
800014c8:	01246433          	or	s0,s0,s2
800014cc:	009b14b3          	sll	s1,s6,s1
800014d0:	c0d00a93          	li	s5,-1011
800014d4:	40aa8ab3          	sub	s5,s5,a0
800014d8:	f35ff06f          	j	8000140c <__muldf3+0x74>
800014dc:	3ac010ef          	jal	ra,80002888 <__clzsi2>
800014e0:	02050513          	addi	a0,a0,32
800014e4:	fc5ff06f          	j	800014a8 <__muldf3+0x110>
800014e8:	fd850413          	addi	s0,a0,-40
800014ec:	008b1433          	sll	s0,s6,s0
800014f0:	00000493          	li	s1,0
800014f4:	fddff06f          	j	800014d0 <__muldf3+0x138>
800014f8:	00a96433          	or	s0,s2,a0
800014fc:	02040463          	beqz	s0,80001524 <__muldf3+0x18c>
80001500:	00050493          	mv	s1,a0
80001504:	00090413          	mv	s0,s2
80001508:	7ff00a93          	li	s5,2047
8000150c:	00300b13          	li	s6,3
80001510:	f01ff06f          	j	80001410 <__muldf3+0x78>
80001514:	00000493          	li	s1,0
80001518:	00000a93          	li	s5,0
8000151c:	00100b13          	li	s6,1
80001520:	ef1ff06f          	j	80001410 <__muldf3+0x78>
80001524:	00000493          	li	s1,0
80001528:	7ff00a93          	li	s5,2047
8000152c:	00200b13          	li	s6,2
80001530:	ee1ff06f          	j	80001410 <__muldf3+0x78>
80001534:	017967b3          	or	a5,s2,s7
80001538:	06078e63          	beqz	a5,800015b4 <__muldf3+0x21c>
8000153c:	04090063          	beqz	s2,8000157c <__muldf3+0x1e4>
80001540:	00090513          	mv	a0,s2
80001544:	344010ef          	jal	ra,80002888 <__clzsi2>
80001548:	ff550693          	addi	a3,a0,-11
8000154c:	01c00793          	li	a5,28
80001550:	02d7ce63          	blt	a5,a3,8000158c <__muldf3+0x1f4>
80001554:	01d00793          	li	a5,29
80001558:	ff850713          	addi	a4,a0,-8
8000155c:	40d787b3          	sub	a5,a5,a3
80001560:	00e91933          	sll	s2,s2,a4
80001564:	00fbd7b3          	srl	a5,s7,a5
80001568:	0127e7b3          	or	a5,a5,s2
8000156c:	00eb9733          	sll	a4,s7,a4
80001570:	c0d00693          	li	a3,-1011
80001574:	40a68533          	sub	a0,a3,a0
80001578:	eddff06f          	j	80001454 <__muldf3+0xbc>
8000157c:	000b8513          	mv	a0,s7
80001580:	308010ef          	jal	ra,80002888 <__clzsi2>
80001584:	02050513          	addi	a0,a0,32
80001588:	fc1ff06f          	j	80001548 <__muldf3+0x1b0>
8000158c:	fd850793          	addi	a5,a0,-40
80001590:	00fb97b3          	sll	a5,s7,a5
80001594:	00000713          	li	a4,0
80001598:	fd9ff06f          	j	80001570 <__muldf3+0x1d8>
8000159c:	017967b3          	or	a5,s2,s7
800015a0:	02078263          	beqz	a5,800015c4 <__muldf3+0x22c>
800015a4:	00090793          	mv	a5,s2
800015a8:	7ff00513          	li	a0,2047
800015ac:	00300693          	li	a3,3
800015b0:	ea9ff06f          	j	80001458 <__muldf3+0xc0>
800015b4:	00000713          	li	a4,0
800015b8:	00000513          	li	a0,0
800015bc:	00100693          	li	a3,1
800015c0:	e99ff06f          	j	80001458 <__muldf3+0xc0>
800015c4:	00000713          	li	a4,0
800015c8:	7ff00513          	li	a0,2047
800015cc:	00200693          	li	a3,2
800015d0:	e89ff06f          	j	80001458 <__muldf3+0xc0>
800015d4:	00010fb7          	lui	t6,0x10
800015d8:	ffff8f13          	addi	t5,t6,-1 # ffff <_stack_size+0xfbff>
800015dc:	0104d693          	srli	a3,s1,0x10
800015e0:	01075313          	srli	t1,a4,0x10
800015e4:	01e4f4b3          	and	s1,s1,t5
800015e8:	01e77733          	and	a4,a4,t5
800015ec:	029308b3          	mul	a7,t1,s1
800015f0:	029705b3          	mul	a1,a4,s1
800015f4:	02e682b3          	mul	t0,a3,a4
800015f8:	00588e33          	add	t3,a7,t0
800015fc:	0105d893          	srli	a7,a1,0x10
80001600:	01c888b3          	add	a7,a7,t3
80001604:	02668eb3          	mul	t4,a3,t1
80001608:	0058f463          	bleu	t0,a7,80001610 <__muldf3+0x278>
8000160c:	01fe8eb3          	add	t4,t4,t6
80001610:	0108d913          	srli	s2,a7,0x10
80001614:	01e8f8b3          	and	a7,a7,t5
80001618:	0107df93          	srli	t6,a5,0x10
8000161c:	01e5f5b3          	and	a1,a1,t5
80001620:	01e7f3b3          	and	t2,a5,t5
80001624:	01089893          	slli	a7,a7,0x10
80001628:	00b888b3          	add	a7,a7,a1
8000162c:	027687b3          	mul	a5,a3,t2
80001630:	029385b3          	mul	a1,t2,s1
80001634:	029f84b3          	mul	s1,t6,s1
80001638:	00f48e33          	add	t3,s1,a5
8000163c:	0105d493          	srli	s1,a1,0x10
80001640:	01c484b3          	add	s1,s1,t3
80001644:	03f686b3          	mul	a3,a3,t6
80001648:	00f4f663          	bleu	a5,s1,80001654 <__muldf3+0x2bc>
8000164c:	000107b7          	lui	a5,0x10
80001650:	00f686b3          	add	a3,a3,a5
80001654:	0104df13          	srli	t5,s1,0x10
80001658:	000109b7          	lui	s3,0x10
8000165c:	00df0f33          	add	t5,t5,a3
80001660:	fff98693          	addi	a3,s3,-1 # ffff <_stack_size+0xfbff>
80001664:	00d4f4b3          	and	s1,s1,a3
80001668:	00d5f5b3          	and	a1,a1,a3
8000166c:	01045793          	srli	a5,s0,0x10
80001670:	01049493          	slli	s1,s1,0x10
80001674:	00d47433          	and	s0,s0,a3
80001678:	00b484b3          	add	s1,s1,a1
8000167c:	028706b3          	mul	a3,a4,s0
80001680:	00990933          	add	s2,s2,s1
80001684:	02e78e33          	mul	t3,a5,a4
80001688:	028305b3          	mul	a1,t1,s0
8000168c:	02f30733          	mul	a4,t1,a5
80001690:	01c58333          	add	t1,a1,t3
80001694:	0106d593          	srli	a1,a3,0x10
80001698:	006585b3          	add	a1,a1,t1
8000169c:	01c5f463          	bleu	t3,a1,800016a4 <__muldf3+0x30c>
800016a0:	01370733          	add	a4,a4,s3
800016a4:	0105d313          	srli	t1,a1,0x10
800016a8:	000109b7          	lui	s3,0x10
800016ac:	00e302b3          	add	t0,t1,a4
800016b0:	fff98713          	addi	a4,s3,-1 # ffff <_stack_size+0xfbff>
800016b4:	00e5f5b3          	and	a1,a1,a4
800016b8:	00e6f6b3          	and	a3,a3,a4
800016bc:	02838333          	mul	t1,t2,s0
800016c0:	01059593          	slli	a1,a1,0x10
800016c4:	00d585b3          	add	a1,a1,a3
800016c8:	02778733          	mul	a4,a5,t2
800016cc:	028f8433          	mul	s0,t6,s0
800016d0:	02ff8e33          	mul	t3,t6,a5
800016d4:	00e40433          	add	s0,s0,a4
800016d8:	01035793          	srli	a5,t1,0x10
800016dc:	00878433          	add	s0,a5,s0
800016e0:	00e47463          	bleu	a4,s0,800016e8 <__muldf3+0x350>
800016e4:	013e0e33          	add	t3,t3,s3
800016e8:	000107b7          	lui	a5,0x10
800016ec:	fff78793          	addi	a5,a5,-1 # ffff <_stack_size+0xfbff>
800016f0:	00f476b3          	and	a3,s0,a5
800016f4:	00f37333          	and	t1,t1,a5
800016f8:	01069693          	slli	a3,a3,0x10
800016fc:	012e8eb3          	add	t4,t4,s2
80001700:	006686b3          	add	a3,a3,t1
80001704:	009eb4b3          	sltu	s1,t4,s1
80001708:	01e686b3          	add	a3,a3,t5
8000170c:	009687b3          	add	a5,a3,s1
80001710:	00be8eb3          	add	t4,t4,a1
80001714:	00beb5b3          	sltu	a1,t4,a1
80001718:	00578333          	add	t1,a5,t0
8000171c:	00b30fb3          	add	t6,t1,a1
80001720:	01e6b6b3          	sltu	a3,a3,t5
80001724:	0097b7b3          	sltu	a5,a5,s1
80001728:	00f6e7b3          	or	a5,a3,a5
8000172c:	01045413          	srli	s0,s0,0x10
80001730:	00533333          	sltu	t1,t1,t0
80001734:	00bfb5b3          	sltu	a1,t6,a1
80001738:	008787b3          	add	a5,a5,s0
8000173c:	00b365b3          	or	a1,t1,a1
80001740:	00b787b3          	add	a5,a5,a1
80001744:	01c787b3          	add	a5,a5,t3
80001748:	017fd713          	srli	a4,t6,0x17
8000174c:	00979793          	slli	a5,a5,0x9
80001750:	00e7e7b3          	or	a5,a5,a4
80001754:	009e9713          	slli	a4,t4,0x9
80001758:	01176733          	or	a4,a4,a7
8000175c:	00e03733          	snez	a4,a4
80001760:	017ede93          	srli	t4,t4,0x17
80001764:	009f9693          	slli	a3,t6,0x9
80001768:	01d76733          	or	a4,a4,t4
8000176c:	00d76733          	or	a4,a4,a3
80001770:	00779693          	slli	a3,a5,0x7
80001774:	1006da63          	bgez	a3,80001888 <__muldf3+0x4f0>
80001778:	00175693          	srli	a3,a4,0x1
8000177c:	00177713          	andi	a4,a4,1
80001780:	00e6e733          	or	a4,a3,a4
80001784:	01f79693          	slli	a3,a5,0x1f
80001788:	00d76733          	or	a4,a4,a3
8000178c:	0017d793          	srli	a5,a5,0x1
80001790:	3ff80593          	addi	a1,a6,1023
80001794:	0eb05e63          	blez	a1,80001890 <__muldf3+0x4f8>
80001798:	00777693          	andi	a3,a4,7
8000179c:	02068063          	beqz	a3,800017bc <__muldf3+0x424>
800017a0:	00f77693          	andi	a3,a4,15
800017a4:	00400513          	li	a0,4
800017a8:	00a68a63          	beq	a3,a0,800017bc <__muldf3+0x424>
800017ac:	00470693          	addi	a3,a4,4
800017b0:	00e6b733          	sltu	a4,a3,a4
800017b4:	00e787b3          	add	a5,a5,a4
800017b8:	00068713          	mv	a4,a3
800017bc:	00779693          	slli	a3,a5,0x7
800017c0:	0006da63          	bgez	a3,800017d4 <__muldf3+0x43c>
800017c4:	ff0006b7          	lui	a3,0xff000
800017c8:	fff68693          	addi	a3,a3,-1 # feffffff <_stack_start+0x7eff9f2f>
800017cc:	00d7f7b3          	and	a5,a5,a3
800017d0:	40080593          	addi	a1,a6,1024
800017d4:	7fe00693          	li	a3,2046
800017d8:	16b6ce63          	blt	a3,a1,80001954 <__muldf3+0x5bc>
800017dc:	00375693          	srli	a3,a4,0x3
800017e0:	01d79713          	slli	a4,a5,0x1d
800017e4:	00d76733          	or	a4,a4,a3
800017e8:	0037d793          	srli	a5,a5,0x3
800017ec:	001006b7          	lui	a3,0x100
800017f0:	fff68693          	addi	a3,a3,-1 # fffff <_stack_size+0xffbff>
800017f4:	00d7f7b3          	and	a5,a5,a3
800017f8:	7ff5f693          	andi	a3,a1,2047
800017fc:	801005b7          	lui	a1,0x80100
80001800:	fff58593          	addi	a1,a1,-1 # 800fffff <_stack_start+0xf9f2f>
80001804:	01469693          	slli	a3,a3,0x14
80001808:	00b7f7b3          	and	a5,a5,a1
8000180c:	02c12083          	lw	ra,44(sp)
80001810:	02812403          	lw	s0,40(sp)
80001814:	01f61613          	slli	a2,a2,0x1f
80001818:	00d7e7b3          	or	a5,a5,a3
8000181c:	00c7e6b3          	or	a3,a5,a2
80001820:	02412483          	lw	s1,36(sp)
80001824:	02012903          	lw	s2,32(sp)
80001828:	01c12983          	lw	s3,28(sp)
8000182c:	01812a03          	lw	s4,24(sp)
80001830:	01412a83          	lw	s5,20(sp)
80001834:	01012b03          	lw	s6,16(sp)
80001838:	00c12b83          	lw	s7,12(sp)
8000183c:	00070513          	mv	a0,a4
80001840:	00068593          	mv	a1,a3
80001844:	03010113          	addi	sp,sp,48
80001848:	00008067          	ret
8000184c:	00098613          	mv	a2,s3
80001850:	00040793          	mv	a5,s0
80001854:	00048713          	mv	a4,s1
80001858:	000b0693          	mv	a3,s6
8000185c:	00200593          	li	a1,2
80001860:	0eb68a63          	beq	a3,a1,80001954 <__muldf3+0x5bc>
80001864:	00300593          	li	a1,3
80001868:	0cb68c63          	beq	a3,a1,80001940 <__muldf3+0x5a8>
8000186c:	00100593          	li	a1,1
80001870:	f2b690e3          	bne	a3,a1,80001790 <__muldf3+0x3f8>
80001874:	00000793          	li	a5,0
80001878:	00000713          	li	a4,0
8000187c:	0880006f          	j	80001904 <__muldf3+0x56c>
80001880:	000a0613          	mv	a2,s4
80001884:	fd9ff06f          	j	8000185c <__muldf3+0x4c4>
80001888:	00050813          	mv	a6,a0
8000188c:	f05ff06f          	j	80001790 <__muldf3+0x3f8>
80001890:	00100513          	li	a0,1
80001894:	40b50533          	sub	a0,a0,a1
80001898:	03800693          	li	a3,56
8000189c:	fca6cce3          	blt	a3,a0,80001874 <__muldf3+0x4dc>
800018a0:	01f00693          	li	a3,31
800018a4:	06a6c463          	blt	a3,a0,8000190c <__muldf3+0x574>
800018a8:	41e80813          	addi	a6,a6,1054
800018ac:	010796b3          	sll	a3,a5,a6
800018b0:	00a755b3          	srl	a1,a4,a0
800018b4:	01071733          	sll	a4,a4,a6
800018b8:	00b6e6b3          	or	a3,a3,a1
800018bc:	00e03733          	snez	a4,a4
800018c0:	00e6e733          	or	a4,a3,a4
800018c4:	00a7d7b3          	srl	a5,a5,a0
800018c8:	00777693          	andi	a3,a4,7
800018cc:	02068063          	beqz	a3,800018ec <__muldf3+0x554>
800018d0:	00f77693          	andi	a3,a4,15
800018d4:	00400593          	li	a1,4
800018d8:	00b68a63          	beq	a3,a1,800018ec <__muldf3+0x554>
800018dc:	00470693          	addi	a3,a4,4
800018e0:	00e6b733          	sltu	a4,a3,a4
800018e4:	00e787b3          	add	a5,a5,a4
800018e8:	00068713          	mv	a4,a3
800018ec:	00879693          	slli	a3,a5,0x8
800018f0:	0606ca63          	bltz	a3,80001964 <__muldf3+0x5cc>
800018f4:	01d79693          	slli	a3,a5,0x1d
800018f8:	00375713          	srli	a4,a4,0x3
800018fc:	00e6e733          	or	a4,a3,a4
80001900:	0037d793          	srli	a5,a5,0x3
80001904:	00000593          	li	a1,0
80001908:	ee5ff06f          	j	800017ec <__muldf3+0x454>
8000190c:	fe100693          	li	a3,-31
80001910:	40b686b3          	sub	a3,a3,a1
80001914:	02000893          	li	a7,32
80001918:	00d7d6b3          	srl	a3,a5,a3
8000191c:	00000593          	li	a1,0
80001920:	01150663          	beq	a0,a7,8000192c <__muldf3+0x594>
80001924:	43e80813          	addi	a6,a6,1086
80001928:	010795b3          	sll	a1,a5,a6
8000192c:	00e5e733          	or	a4,a1,a4
80001930:	00e03733          	snez	a4,a4
80001934:	00e6e733          	or	a4,a3,a4
80001938:	00000793          	li	a5,0
8000193c:	f8dff06f          	j	800018c8 <__muldf3+0x530>
80001940:	000807b7          	lui	a5,0x80
80001944:	00000713          	li	a4,0
80001948:	7ff00593          	li	a1,2047
8000194c:	00000613          	li	a2,0
80001950:	e9dff06f          	j	800017ec <__muldf3+0x454>
80001954:	00000793          	li	a5,0
80001958:	00000713          	li	a4,0
8000195c:	7ff00593          	li	a1,2047
80001960:	e8dff06f          	j	800017ec <__muldf3+0x454>
80001964:	00000793          	li	a5,0
80001968:	00000713          	li	a4,0
8000196c:	00100593          	li	a1,1
80001970:	e7dff06f          	j	800017ec <__muldf3+0x454>

80001974 <__divsf3>:
80001974:	fe010113          	addi	sp,sp,-32
80001978:	00912a23          	sw	s1,20(sp)
8000197c:	01312623          	sw	s3,12(sp)
80001980:	01755493          	srli	s1,a0,0x17
80001984:	008009b7          	lui	s3,0x800
80001988:	01212823          	sw	s2,16(sp)
8000198c:	01412423          	sw	s4,8(sp)
80001990:	fff98993          	addi	s3,s3,-1 # 7fffff <_stack_size+0x7ffbff>
80001994:	00112e23          	sw	ra,28(sp)
80001998:	00812c23          	sw	s0,24(sp)
8000199c:	01512223          	sw	s5,4(sp)
800019a0:	0ff4f493          	andi	s1,s1,255
800019a4:	00058a13          	mv	s4,a1
800019a8:	00a9f9b3          	and	s3,s3,a0
800019ac:	01f55913          	srli	s2,a0,0x1f
800019b0:	08048863          	beqz	s1,80001a40 <__divsf3+0xcc>
800019b4:	0ff00793          	li	a5,255
800019b8:	0af48463          	beq	s1,a5,80001a60 <__divsf3+0xec>
800019bc:	00399993          	slli	s3,s3,0x3
800019c0:	040007b7          	lui	a5,0x4000
800019c4:	00f9e9b3          	or	s3,s3,a5
800019c8:	f8148493          	addi	s1,s1,-127
800019cc:	00000a93          	li	s5,0
800019d0:	017a5513          	srli	a0,s4,0x17
800019d4:	00800437          	lui	s0,0x800
800019d8:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
800019dc:	0ff57513          	andi	a0,a0,255
800019e0:	01447433          	and	s0,s0,s4
800019e4:	01fa5a13          	srli	s4,s4,0x1f
800019e8:	08050c63          	beqz	a0,80001a80 <__divsf3+0x10c>
800019ec:	0ff00793          	li	a5,255
800019f0:	0af50863          	beq	a0,a5,80001aa0 <__divsf3+0x12c>
800019f4:	00341413          	slli	s0,s0,0x3
800019f8:	040007b7          	lui	a5,0x4000
800019fc:	00f46433          	or	s0,s0,a5
80001a00:	f8150513          	addi	a0,a0,-127
80001a04:	00000793          	li	a5,0
80001a08:	002a9693          	slli	a3,s5,0x2
80001a0c:	00f6e6b3          	or	a3,a3,a5
80001a10:	fff68693          	addi	a3,a3,-1
80001a14:	00e00713          	li	a4,14
80001a18:	01494633          	xor	a2,s2,s4
80001a1c:	40a48533          	sub	a0,s1,a0
80001a20:	0ad76063          	bltu	a4,a3,80001ac0 <__divsf3+0x14c>
80001a24:	00001597          	auipc	a1,0x1
80001a28:	50858593          	addi	a1,a1,1288 # 80002f2c <end+0x658>
80001a2c:	00269693          	slli	a3,a3,0x2
80001a30:	00b686b3          	add	a3,a3,a1
80001a34:	0006a703          	lw	a4,0(a3)
80001a38:	00b70733          	add	a4,a4,a1
80001a3c:	00070067          	jr	a4
80001a40:	02098a63          	beqz	s3,80001a74 <__divsf3+0x100>
80001a44:	00098513          	mv	a0,s3
80001a48:	641000ef          	jal	ra,80002888 <__clzsi2>
80001a4c:	ffb50793          	addi	a5,a0,-5
80001a50:	f8a00493          	li	s1,-118
80001a54:	00f999b3          	sll	s3,s3,a5
80001a58:	40a484b3          	sub	s1,s1,a0
80001a5c:	f71ff06f          	j	800019cc <__divsf3+0x58>
80001a60:	0ff00493          	li	s1,255
80001a64:	00200a93          	li	s5,2
80001a68:	f60984e3          	beqz	s3,800019d0 <__divsf3+0x5c>
80001a6c:	00300a93          	li	s5,3
80001a70:	f61ff06f          	j	800019d0 <__divsf3+0x5c>
80001a74:	00000493          	li	s1,0
80001a78:	00100a93          	li	s5,1
80001a7c:	f55ff06f          	j	800019d0 <__divsf3+0x5c>
80001a80:	02040a63          	beqz	s0,80001ab4 <__divsf3+0x140>
80001a84:	00040513          	mv	a0,s0
80001a88:	601000ef          	jal	ra,80002888 <__clzsi2>
80001a8c:	ffb50793          	addi	a5,a0,-5
80001a90:	00f41433          	sll	s0,s0,a5
80001a94:	f8a00793          	li	a5,-118
80001a98:	40a78533          	sub	a0,a5,a0
80001a9c:	f69ff06f          	j	80001a04 <__divsf3+0x90>
80001aa0:	0ff00513          	li	a0,255
80001aa4:	00200793          	li	a5,2
80001aa8:	f60400e3          	beqz	s0,80001a08 <__divsf3+0x94>
80001aac:	00300793          	li	a5,3
80001ab0:	f59ff06f          	j	80001a08 <__divsf3+0x94>
80001ab4:	00000513          	li	a0,0
80001ab8:	00100793          	li	a5,1
80001abc:	f4dff06f          	j	80001a08 <__divsf3+0x94>
80001ac0:	00541813          	slli	a6,s0,0x5
80001ac4:	0e89f663          	bleu	s0,s3,80001bb0 <__divsf3+0x23c>
80001ac8:	fff50513          	addi	a0,a0,-1
80001acc:	00000693          	li	a3,0
80001ad0:	01085413          	srli	s0,a6,0x10
80001ad4:	0289d333          	divu	t1,s3,s0
80001ad8:	000107b7          	lui	a5,0x10
80001adc:	fff78793          	addi	a5,a5,-1 # ffff <_stack_size+0xfbff>
80001ae0:	00f877b3          	and	a5,a6,a5
80001ae4:	0106d693          	srli	a3,a3,0x10
80001ae8:	0289f733          	remu	a4,s3,s0
80001aec:	00030593          	mv	a1,t1
80001af0:	026788b3          	mul	a7,a5,t1
80001af4:	01071713          	slli	a4,a4,0x10
80001af8:	00e6e733          	or	a4,a3,a4
80001afc:	01177e63          	bleu	a7,a4,80001b18 <__divsf3+0x1a4>
80001b00:	01070733          	add	a4,a4,a6
80001b04:	fff30593          	addi	a1,t1,-1
80001b08:	01076863          	bltu	a4,a6,80001b18 <__divsf3+0x1a4>
80001b0c:	01177663          	bleu	a7,a4,80001b18 <__divsf3+0x1a4>
80001b10:	ffe30593          	addi	a1,t1,-2
80001b14:	01070733          	add	a4,a4,a6
80001b18:	41170733          	sub	a4,a4,a7
80001b1c:	028758b3          	divu	a7,a4,s0
80001b20:	02877733          	remu	a4,a4,s0
80001b24:	031786b3          	mul	a3,a5,a7
80001b28:	01071793          	slli	a5,a4,0x10
80001b2c:	00088713          	mv	a4,a7
80001b30:	00d7fe63          	bleu	a3,a5,80001b4c <__divsf3+0x1d8>
80001b34:	010787b3          	add	a5,a5,a6
80001b38:	fff88713          	addi	a4,a7,-1
80001b3c:	0107e863          	bltu	a5,a6,80001b4c <__divsf3+0x1d8>
80001b40:	00d7f663          	bleu	a3,a5,80001b4c <__divsf3+0x1d8>
80001b44:	ffe88713          	addi	a4,a7,-2
80001b48:	010787b3          	add	a5,a5,a6
80001b4c:	01059413          	slli	s0,a1,0x10
80001b50:	40d787b3          	sub	a5,a5,a3
80001b54:	00e46433          	or	s0,s0,a4
80001b58:	00f037b3          	snez	a5,a5
80001b5c:	00f46433          	or	s0,s0,a5
80001b60:	07f50713          	addi	a4,a0,127
80001b64:	0ae05063          	blez	a4,80001c04 <__divsf3+0x290>
80001b68:	00747793          	andi	a5,s0,7
80001b6c:	00078a63          	beqz	a5,80001b80 <__divsf3+0x20c>
80001b70:	00f47793          	andi	a5,s0,15
80001b74:	00400693          	li	a3,4
80001b78:	00d78463          	beq	a5,a3,80001b80 <__divsf3+0x20c>
80001b7c:	00440413          	addi	s0,s0,4
80001b80:	00441793          	slli	a5,s0,0x4
80001b84:	0007da63          	bgez	a5,80001b98 <__divsf3+0x224>
80001b88:	f80007b7          	lui	a5,0xf8000
80001b8c:	fff78793          	addi	a5,a5,-1 # f7ffffff <_stack_start+0x77ff9f2f>
80001b90:	00f47433          	and	s0,s0,a5
80001b94:	08050713          	addi	a4,a0,128
80001b98:	0fe00793          	li	a5,254
80001b9c:	00345413          	srli	s0,s0,0x3
80001ba0:	0ce7d263          	ble	a4,a5,80001c64 <__divsf3+0x2f0>
80001ba4:	00000413          	li	s0,0
80001ba8:	0ff00713          	li	a4,255
80001bac:	0b80006f          	j	80001c64 <__divsf3+0x2f0>
80001bb0:	01f99693          	slli	a3,s3,0x1f
80001bb4:	0019d993          	srli	s3,s3,0x1
80001bb8:	f19ff06f          	j	80001ad0 <__divsf3+0x15c>
80001bbc:	00090613          	mv	a2,s2
80001bc0:	00098413          	mv	s0,s3
80001bc4:	000a8793          	mv	a5,s5
80001bc8:	00200713          	li	a4,2
80001bcc:	fce78ce3          	beq	a5,a4,80001ba4 <__divsf3+0x230>
80001bd0:	00300713          	li	a4,3
80001bd4:	08e78263          	beq	a5,a4,80001c58 <__divsf3+0x2e4>
80001bd8:	00100713          	li	a4,1
80001bdc:	f8e792e3          	bne	a5,a4,80001b60 <__divsf3+0x1ec>
80001be0:	00000413          	li	s0,0
80001be4:	00000713          	li	a4,0
80001be8:	07c0006f          	j	80001c64 <__divsf3+0x2f0>
80001bec:	000a0613          	mv	a2,s4
80001bf0:	fd9ff06f          	j	80001bc8 <__divsf3+0x254>
80001bf4:	00400437          	lui	s0,0x400
80001bf8:	00000613          	li	a2,0
80001bfc:	00300793          	li	a5,3
80001c00:	fc9ff06f          	j	80001bc8 <__divsf3+0x254>
80001c04:	00100793          	li	a5,1
80001c08:	40e787b3          	sub	a5,a5,a4
80001c0c:	01b00713          	li	a4,27
80001c10:	fcf748e3          	blt	a4,a5,80001be0 <__divsf3+0x26c>
80001c14:	09e50513          	addi	a0,a0,158
80001c18:	00f457b3          	srl	a5,s0,a5
80001c1c:	00a41433          	sll	s0,s0,a0
80001c20:	00803433          	snez	s0,s0
80001c24:	0087e433          	or	s0,a5,s0
80001c28:	00747793          	andi	a5,s0,7
80001c2c:	00078a63          	beqz	a5,80001c40 <__divsf3+0x2cc>
80001c30:	00f47793          	andi	a5,s0,15
80001c34:	00400713          	li	a4,4
80001c38:	00e78463          	beq	a5,a4,80001c40 <__divsf3+0x2cc>
80001c3c:	00440413          	addi	s0,s0,4 # 400004 <_stack_size+0x3ffc04>
80001c40:	00541793          	slli	a5,s0,0x5
80001c44:	00345413          	srli	s0,s0,0x3
80001c48:	f807dee3          	bgez	a5,80001be4 <__divsf3+0x270>
80001c4c:	00000413          	li	s0,0
80001c50:	00100713          	li	a4,1
80001c54:	0100006f          	j	80001c64 <__divsf3+0x2f0>
80001c58:	00400437          	lui	s0,0x400
80001c5c:	0ff00713          	li	a4,255
80001c60:	00000613          	li	a2,0
80001c64:	00800537          	lui	a0,0x800
80001c68:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80001c6c:	00a47433          	and	s0,s0,a0
80001c70:	80800537          	lui	a0,0x80800
80001c74:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9f2f>
80001c78:	0ff77713          	andi	a4,a4,255
80001c7c:	00a47433          	and	s0,s0,a0
80001c80:	01771713          	slli	a4,a4,0x17
80001c84:	00e46433          	or	s0,s0,a4
80001c88:	01f61513          	slli	a0,a2,0x1f
80001c8c:	00a46533          	or	a0,s0,a0
80001c90:	01c12083          	lw	ra,28(sp)
80001c94:	01812403          	lw	s0,24(sp)
80001c98:	01412483          	lw	s1,20(sp)
80001c9c:	01012903          	lw	s2,16(sp)
80001ca0:	00c12983          	lw	s3,12(sp)
80001ca4:	00812a03          	lw	s4,8(sp)
80001ca8:	00412a83          	lw	s5,4(sp)
80001cac:	02010113          	addi	sp,sp,32
80001cb0:	00008067          	ret

80001cb4 <__mulsf3>:
80001cb4:	fe010113          	addi	sp,sp,-32
80001cb8:	00912a23          	sw	s1,20(sp)
80001cbc:	01212823          	sw	s2,16(sp)
80001cc0:	008004b7          	lui	s1,0x800
80001cc4:	01755913          	srli	s2,a0,0x17
80001cc8:	01312623          	sw	s3,12(sp)
80001ccc:	01512223          	sw	s5,4(sp)
80001cd0:	fff48493          	addi	s1,s1,-1 # 7fffff <_stack_size+0x7ffbff>
80001cd4:	00112e23          	sw	ra,28(sp)
80001cd8:	00812c23          	sw	s0,24(sp)
80001cdc:	01412423          	sw	s4,8(sp)
80001ce0:	0ff97913          	andi	s2,s2,255
80001ce4:	00058a93          	mv	s5,a1
80001ce8:	00a4f4b3          	and	s1,s1,a0
80001cec:	01f55993          	srli	s3,a0,0x1f
80001cf0:	08090a63          	beqz	s2,80001d84 <__mulsf3+0xd0>
80001cf4:	0ff00793          	li	a5,255
80001cf8:	0af90663          	beq	s2,a5,80001da4 <__mulsf3+0xf0>
80001cfc:	00349493          	slli	s1,s1,0x3
80001d00:	040007b7          	lui	a5,0x4000
80001d04:	00f4e4b3          	or	s1,s1,a5
80001d08:	f8190913          	addi	s2,s2,-127
80001d0c:	00000a13          	li	s4,0
80001d10:	017ad513          	srli	a0,s5,0x17
80001d14:	00800437          	lui	s0,0x800
80001d18:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80001d1c:	0ff57513          	andi	a0,a0,255
80001d20:	01547433          	and	s0,s0,s5
80001d24:	01fada93          	srli	s5,s5,0x1f
80001d28:	08050e63          	beqz	a0,80001dc4 <__mulsf3+0x110>
80001d2c:	0ff00793          	li	a5,255
80001d30:	0af50a63          	beq	a0,a5,80001de4 <__mulsf3+0x130>
80001d34:	00341413          	slli	s0,s0,0x3
80001d38:	040007b7          	lui	a5,0x4000
80001d3c:	00f46433          	or	s0,s0,a5
80001d40:	f8150513          	addi	a0,a0,-127
80001d44:	00000693          	li	a3,0
80001d48:	002a1793          	slli	a5,s4,0x2
80001d4c:	00d7e7b3          	or	a5,a5,a3
80001d50:	00a90533          	add	a0,s2,a0
80001d54:	fff78793          	addi	a5,a5,-1 # 3ffffff <_stack_size+0x3fffbff>
80001d58:	00e00713          	li	a4,14
80001d5c:	0159c633          	xor	a2,s3,s5
80001d60:	00150813          	addi	a6,a0,1
80001d64:	0af76063          	bltu	a4,a5,80001e04 <__mulsf3+0x150>
80001d68:	00001717          	auipc	a4,0x1
80001d6c:	20070713          	addi	a4,a4,512 # 80002f68 <end+0x694>
80001d70:	00279793          	slli	a5,a5,0x2
80001d74:	00e787b3          	add	a5,a5,a4
80001d78:	0007a783          	lw	a5,0(a5)
80001d7c:	00e787b3          	add	a5,a5,a4
80001d80:	00078067          	jr	a5
80001d84:	02048a63          	beqz	s1,80001db8 <__mulsf3+0x104>
80001d88:	00048513          	mv	a0,s1
80001d8c:	2fd000ef          	jal	ra,80002888 <__clzsi2>
80001d90:	ffb50793          	addi	a5,a0,-5
80001d94:	f8a00913          	li	s2,-118
80001d98:	00f494b3          	sll	s1,s1,a5
80001d9c:	40a90933          	sub	s2,s2,a0
80001da0:	f6dff06f          	j	80001d0c <__mulsf3+0x58>
80001da4:	0ff00913          	li	s2,255
80001da8:	00200a13          	li	s4,2
80001dac:	f60482e3          	beqz	s1,80001d10 <__mulsf3+0x5c>
80001db0:	00300a13          	li	s4,3
80001db4:	f5dff06f          	j	80001d10 <__mulsf3+0x5c>
80001db8:	00000913          	li	s2,0
80001dbc:	00100a13          	li	s4,1
80001dc0:	f51ff06f          	j	80001d10 <__mulsf3+0x5c>
80001dc4:	02040a63          	beqz	s0,80001df8 <__mulsf3+0x144>
80001dc8:	00040513          	mv	a0,s0
80001dcc:	2bd000ef          	jal	ra,80002888 <__clzsi2>
80001dd0:	ffb50793          	addi	a5,a0,-5
80001dd4:	00f41433          	sll	s0,s0,a5
80001dd8:	f8a00793          	li	a5,-118
80001ddc:	40a78533          	sub	a0,a5,a0
80001de0:	f65ff06f          	j	80001d44 <__mulsf3+0x90>
80001de4:	0ff00513          	li	a0,255
80001de8:	00200693          	li	a3,2
80001dec:	f4040ee3          	beqz	s0,80001d48 <__mulsf3+0x94>
80001df0:	00300693          	li	a3,3
80001df4:	f55ff06f          	j	80001d48 <__mulsf3+0x94>
80001df8:	00000513          	li	a0,0
80001dfc:	00100693          	li	a3,1
80001e00:	f49ff06f          	j	80001d48 <__mulsf3+0x94>
80001e04:	000107b7          	lui	a5,0x10
80001e08:	fff78313          	addi	t1,a5,-1 # ffff <_stack_size+0xfbff>
80001e0c:	0104d713          	srli	a4,s1,0x10
80001e10:	01045693          	srli	a3,s0,0x10
80001e14:	0064f4b3          	and	s1,s1,t1
80001e18:	00647433          	and	s0,s0,t1
80001e1c:	028488b3          	mul	a7,s1,s0
80001e20:	028705b3          	mul	a1,a4,s0
80001e24:	02d70433          	mul	s0,a4,a3
80001e28:	029686b3          	mul	a3,a3,s1
80001e2c:	0108d493          	srli	s1,a7,0x10
80001e30:	00b686b3          	add	a3,a3,a1
80001e34:	00d484b3          	add	s1,s1,a3
80001e38:	00b4f463          	bleu	a1,s1,80001e40 <__mulsf3+0x18c>
80001e3c:	00f40433          	add	s0,s0,a5
80001e40:	0064f7b3          	and	a5,s1,t1
80001e44:	01079793          	slli	a5,a5,0x10
80001e48:	0068f8b3          	and	a7,a7,t1
80001e4c:	011787b3          	add	a5,a5,a7
80001e50:	00679713          	slli	a4,a5,0x6
80001e54:	0104d493          	srli	s1,s1,0x10
80001e58:	00e03733          	snez	a4,a4
80001e5c:	01a7d793          	srli	a5,a5,0x1a
80001e60:	00848433          	add	s0,s1,s0
80001e64:	00f767b3          	or	a5,a4,a5
80001e68:	00641413          	slli	s0,s0,0x6
80001e6c:	00f46433          	or	s0,s0,a5
80001e70:	00441793          	slli	a5,s0,0x4
80001e74:	0c07de63          	bgez	a5,80001f50 <__mulsf3+0x29c>
80001e78:	00145793          	srli	a5,s0,0x1
80001e7c:	00147413          	andi	s0,s0,1
80001e80:	0087e433          	or	s0,a5,s0
80001e84:	07f80713          	addi	a4,a6,127
80001e88:	0ce05863          	blez	a4,80001f58 <__mulsf3+0x2a4>
80001e8c:	00747793          	andi	a5,s0,7
80001e90:	00078a63          	beqz	a5,80001ea4 <__mulsf3+0x1f0>
80001e94:	00f47793          	andi	a5,s0,15
80001e98:	00400693          	li	a3,4
80001e9c:	00d78463          	beq	a5,a3,80001ea4 <__mulsf3+0x1f0>
80001ea0:	00440413          	addi	s0,s0,4
80001ea4:	00441793          	slli	a5,s0,0x4
80001ea8:	0007da63          	bgez	a5,80001ebc <__mulsf3+0x208>
80001eac:	f80007b7          	lui	a5,0xf8000
80001eb0:	fff78793          	addi	a5,a5,-1 # f7ffffff <_stack_start+0x77ff9f2f>
80001eb4:	00f47433          	and	s0,s0,a5
80001eb8:	08080713          	addi	a4,a6,128
80001ebc:	0fe00793          	li	a5,254
80001ec0:	0ee7cc63          	blt	a5,a4,80001fb8 <__mulsf3+0x304>
80001ec4:	00345793          	srli	a5,s0,0x3
80001ec8:	0300006f          	j	80001ef8 <__mulsf3+0x244>
80001ecc:	00098613          	mv	a2,s3
80001ed0:	00048413          	mv	s0,s1
80001ed4:	000a0693          	mv	a3,s4
80001ed8:	00200793          	li	a5,2
80001edc:	0cf68e63          	beq	a3,a5,80001fb8 <__mulsf3+0x304>
80001ee0:	00300793          	li	a5,3
80001ee4:	0cf68263          	beq	a3,a5,80001fa8 <__mulsf3+0x2f4>
80001ee8:	00100593          	li	a1,1
80001eec:	00000793          	li	a5,0
80001ef0:	00000713          	li	a4,0
80001ef4:	f8b698e3          	bne	a3,a1,80001e84 <__mulsf3+0x1d0>
80001ef8:	00800437          	lui	s0,0x800
80001efc:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80001f00:	80800537          	lui	a0,0x80800
80001f04:	0087f7b3          	and	a5,a5,s0
80001f08:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9f2f>
80001f0c:	01c12083          	lw	ra,28(sp)
80001f10:	01812403          	lw	s0,24(sp)
80001f14:	0ff77713          	andi	a4,a4,255
80001f18:	00a7f7b3          	and	a5,a5,a0
80001f1c:	01771713          	slli	a4,a4,0x17
80001f20:	01f61513          	slli	a0,a2,0x1f
80001f24:	00e7e7b3          	or	a5,a5,a4
80001f28:	01412483          	lw	s1,20(sp)
80001f2c:	01012903          	lw	s2,16(sp)
80001f30:	00c12983          	lw	s3,12(sp)
80001f34:	00812a03          	lw	s4,8(sp)
80001f38:	00412a83          	lw	s5,4(sp)
80001f3c:	00a7e533          	or	a0,a5,a0
80001f40:	02010113          	addi	sp,sp,32
80001f44:	00008067          	ret
80001f48:	000a8613          	mv	a2,s5
80001f4c:	f8dff06f          	j	80001ed8 <__mulsf3+0x224>
80001f50:	00050813          	mv	a6,a0
80001f54:	f31ff06f          	j	80001e84 <__mulsf3+0x1d0>
80001f58:	00100793          	li	a5,1
80001f5c:	40e787b3          	sub	a5,a5,a4
80001f60:	01b00713          	li	a4,27
80001f64:	06f74063          	blt	a4,a5,80001fc4 <__mulsf3+0x310>
80001f68:	09e80813          	addi	a6,a6,158
80001f6c:	00f457b3          	srl	a5,s0,a5
80001f70:	01041433          	sll	s0,s0,a6
80001f74:	00803433          	snez	s0,s0
80001f78:	0087e433          	or	s0,a5,s0
80001f7c:	00747793          	andi	a5,s0,7
80001f80:	00078a63          	beqz	a5,80001f94 <__mulsf3+0x2e0>
80001f84:	00f47793          	andi	a5,s0,15
80001f88:	00400713          	li	a4,4
80001f8c:	00e78463          	beq	a5,a4,80001f94 <__mulsf3+0x2e0>
80001f90:	00440413          	addi	s0,s0,4
80001f94:	00541793          	slli	a5,s0,0x5
80001f98:	0207ca63          	bltz	a5,80001fcc <__mulsf3+0x318>
80001f9c:	00345793          	srli	a5,s0,0x3
80001fa0:	00000713          	li	a4,0
80001fa4:	f55ff06f          	j	80001ef8 <__mulsf3+0x244>
80001fa8:	004007b7          	lui	a5,0x400
80001fac:	0ff00713          	li	a4,255
80001fb0:	00000613          	li	a2,0
80001fb4:	f45ff06f          	j	80001ef8 <__mulsf3+0x244>
80001fb8:	00000793          	li	a5,0
80001fbc:	0ff00713          	li	a4,255
80001fc0:	f39ff06f          	j	80001ef8 <__mulsf3+0x244>
80001fc4:	00000793          	li	a5,0
80001fc8:	fd9ff06f          	j	80001fa0 <__mulsf3+0x2ec>
80001fcc:	00000793          	li	a5,0
80001fd0:	00100713          	li	a4,1
80001fd4:	f25ff06f          	j	80001ef8 <__mulsf3+0x244>

80001fd8 <__subsf3>:
80001fd8:	008007b7          	lui	a5,0x800
80001fdc:	fff78793          	addi	a5,a5,-1 # 7fffff <_stack_size+0x7ffbff>
80001fe0:	ff010113          	addi	sp,sp,-16
80001fe4:	00a7f733          	and	a4,a5,a0
80001fe8:	01755693          	srli	a3,a0,0x17
80001fec:	0175d613          	srli	a2,a1,0x17
80001ff0:	00b7f7b3          	and	a5,a5,a1
80001ff4:	00912223          	sw	s1,4(sp)
80001ff8:	01212023          	sw	s2,0(sp)
80001ffc:	0ff6f693          	andi	a3,a3,255
80002000:	00371813          	slli	a6,a4,0x3
80002004:	0ff67613          	andi	a2,a2,255
80002008:	00112623          	sw	ra,12(sp)
8000200c:	00812423          	sw	s0,8(sp)
80002010:	0ff00713          	li	a4,255
80002014:	01f55493          	srli	s1,a0,0x1f
80002018:	00068913          	mv	s2,a3
8000201c:	00060513          	mv	a0,a2
80002020:	01f5d593          	srli	a1,a1,0x1f
80002024:	00379793          	slli	a5,a5,0x3
80002028:	00e61463          	bne	a2,a4,80002030 <__subsf3+0x58>
8000202c:	00079463          	bnez	a5,80002034 <__subsf3+0x5c>
80002030:	0015c593          	xori	a1,a1,1
80002034:	40c68733          	sub	a4,a3,a2
80002038:	1a959a63          	bne	a1,s1,800021ec <__subsf3+0x214>
8000203c:	0ae05663          	blez	a4,800020e8 <__subsf3+0x110>
80002040:	06061663          	bnez	a2,800020ac <__subsf3+0xd4>
80002044:	00079c63          	bnez	a5,8000205c <__subsf3+0x84>
80002048:	0ff00793          	li	a5,255
8000204c:	04f68c63          	beq	a3,a5,800020a4 <__subsf3+0xcc>
80002050:	00080793          	mv	a5,a6
80002054:	00068513          	mv	a0,a3
80002058:	14c0006f          	j	800021a4 <__subsf3+0x1cc>
8000205c:	fff70713          	addi	a4,a4,-1
80002060:	02071e63          	bnez	a4,8000209c <__subsf3+0xc4>
80002064:	010787b3          	add	a5,a5,a6
80002068:	00068513          	mv	a0,a3
8000206c:	00579713          	slli	a4,a5,0x5
80002070:	12075a63          	bgez	a4,800021a4 <__subsf3+0x1cc>
80002074:	00150513          	addi	a0,a0,1
80002078:	0ff00713          	li	a4,255
8000207c:	32e50e63          	beq	a0,a4,800023b8 <__subsf3+0x3e0>
80002080:	7e000737          	lui	a4,0x7e000
80002084:	0017f693          	andi	a3,a5,1
80002088:	fff70713          	addi	a4,a4,-1 # 7dffffff <_stack_size+0x7dfffbff>
8000208c:	0017d793          	srli	a5,a5,0x1
80002090:	00e7f7b3          	and	a5,a5,a4
80002094:	00d7e7b3          	or	a5,a5,a3
80002098:	10c0006f          	j	800021a4 <__subsf3+0x1cc>
8000209c:	0ff00613          	li	a2,255
800020a0:	00c69e63          	bne	a3,a2,800020bc <__subsf3+0xe4>
800020a4:	00080793          	mv	a5,a6
800020a8:	0740006f          	j	8000211c <__subsf3+0x144>
800020ac:	0ff00613          	li	a2,255
800020b0:	fec68ae3          	beq	a3,a2,800020a4 <__subsf3+0xcc>
800020b4:	04000637          	lui	a2,0x4000
800020b8:	00c7e7b3          	or	a5,a5,a2
800020bc:	01b00613          	li	a2,27
800020c0:	00e65663          	ble	a4,a2,800020cc <__subsf3+0xf4>
800020c4:	00100793          	li	a5,1
800020c8:	f9dff06f          	j	80002064 <__subsf3+0x8c>
800020cc:	02000613          	li	a2,32
800020d0:	40e60633          	sub	a2,a2,a4
800020d4:	00e7d5b3          	srl	a1,a5,a4
800020d8:	00c797b3          	sll	a5,a5,a2
800020dc:	00f037b3          	snez	a5,a5
800020e0:	00f5e7b3          	or	a5,a1,a5
800020e4:	f81ff06f          	j	80002064 <__subsf3+0x8c>
800020e8:	08070063          	beqz	a4,80002168 <__subsf3+0x190>
800020ec:	02069c63          	bnez	a3,80002124 <__subsf3+0x14c>
800020f0:	00081863          	bnez	a6,80002100 <__subsf3+0x128>
800020f4:	0ff00713          	li	a4,255
800020f8:	0ae61663          	bne	a2,a4,800021a4 <__subsf3+0x1cc>
800020fc:	0200006f          	j	8000211c <__subsf3+0x144>
80002100:	fff00693          	li	a3,-1
80002104:	00d71663          	bne	a4,a3,80002110 <__subsf3+0x138>
80002108:	010787b3          	add	a5,a5,a6
8000210c:	f61ff06f          	j	8000206c <__subsf3+0x94>
80002110:	0ff00693          	li	a3,255
80002114:	fff74713          	not	a4,a4
80002118:	02d61063          	bne	a2,a3,80002138 <__subsf3+0x160>
8000211c:	0ff00513          	li	a0,255
80002120:	0840006f          	j	800021a4 <__subsf3+0x1cc>
80002124:	0ff00693          	li	a3,255
80002128:	fed60ae3          	beq	a2,a3,8000211c <__subsf3+0x144>
8000212c:	040006b7          	lui	a3,0x4000
80002130:	40e00733          	neg	a4,a4
80002134:	00d86833          	or	a6,a6,a3
80002138:	01b00693          	li	a3,27
8000213c:	00e6d663          	ble	a4,a3,80002148 <__subsf3+0x170>
80002140:	00100713          	li	a4,1
80002144:	01c0006f          	j	80002160 <__subsf3+0x188>
80002148:	02000693          	li	a3,32
8000214c:	00e85633          	srl	a2,a6,a4
80002150:	40e68733          	sub	a4,a3,a4
80002154:	00e81733          	sll	a4,a6,a4
80002158:	00e03733          	snez	a4,a4
8000215c:	00e66733          	or	a4,a2,a4
80002160:	00e787b3          	add	a5,a5,a4
80002164:	f09ff06f          	j	8000206c <__subsf3+0x94>
80002168:	00168513          	addi	a0,a3,1 # 4000001 <_stack_size+0x3fffc01>
8000216c:	0ff57613          	andi	a2,a0,255
80002170:	00100713          	li	a4,1
80002174:	06c74263          	blt	a4,a2,800021d8 <__subsf3+0x200>
80002178:	04069463          	bnez	a3,800021c0 <__subsf3+0x1e8>
8000217c:	00000513          	li	a0,0
80002180:	02080263          	beqz	a6,800021a4 <__subsf3+0x1cc>
80002184:	22078663          	beqz	a5,800023b0 <__subsf3+0x3d8>
80002188:	010787b3          	add	a5,a5,a6
8000218c:	00579713          	slli	a4,a5,0x5
80002190:	00075a63          	bgez	a4,800021a4 <__subsf3+0x1cc>
80002194:	fc000737          	lui	a4,0xfc000
80002198:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9f2f>
8000219c:	00e7f7b3          	and	a5,a5,a4
800021a0:	00100513          	li	a0,1
800021a4:	0077f713          	andi	a4,a5,7
800021a8:	20070a63          	beqz	a4,800023bc <__subsf3+0x3e4>
800021ac:	00f7f713          	andi	a4,a5,15
800021b0:	00400693          	li	a3,4
800021b4:	20d70463          	beq	a4,a3,800023bc <__subsf3+0x3e4>
800021b8:	00478793          	addi	a5,a5,4
800021bc:	2000006f          	j	800023bc <__subsf3+0x3e4>
800021c0:	f4080ee3          	beqz	a6,8000211c <__subsf3+0x144>
800021c4:	ee0780e3          	beqz	a5,800020a4 <__subsf3+0xcc>
800021c8:	020007b7          	lui	a5,0x2000
800021cc:	0ff00513          	li	a0,255
800021d0:	00000493          	li	s1,0
800021d4:	1e80006f          	j	800023bc <__subsf3+0x3e4>
800021d8:	0ff00713          	li	a4,255
800021dc:	1ce50e63          	beq	a0,a4,800023b8 <__subsf3+0x3e0>
800021e0:	00f80733          	add	a4,a6,a5
800021e4:	00175793          	srli	a5,a4,0x1
800021e8:	fbdff06f          	j	800021a4 <__subsf3+0x1cc>
800021ec:	08e05063          	blez	a4,8000226c <__subsf3+0x294>
800021f0:	04061663          	bnez	a2,8000223c <__subsf3+0x264>
800021f4:	e4078ae3          	beqz	a5,80002048 <__subsf3+0x70>
800021f8:	fff70713          	addi	a4,a4,-1
800021fc:	02071463          	bnez	a4,80002224 <__subsf3+0x24c>
80002200:	40f807b3          	sub	a5,a6,a5
80002204:	00068513          	mv	a0,a3
80002208:	00579713          	slli	a4,a5,0x5
8000220c:	f8075ce3          	bgez	a4,800021a4 <__subsf3+0x1cc>
80002210:	04000437          	lui	s0,0x4000
80002214:	fff40413          	addi	s0,s0,-1 # 3ffffff <_stack_size+0x3fffbff>
80002218:	0087f433          	and	s0,a5,s0
8000221c:	00050913          	mv	s2,a0
80002220:	1380006f          	j	80002358 <__subsf3+0x380>
80002224:	0ff00613          	li	a2,255
80002228:	e6c68ee3          	beq	a3,a2,800020a4 <__subsf3+0xcc>
8000222c:	01b00613          	li	a2,27
80002230:	02e65063          	ble	a4,a2,80002250 <__subsf3+0x278>
80002234:	00100793          	li	a5,1
80002238:	fc9ff06f          	j	80002200 <__subsf3+0x228>
8000223c:	0ff00613          	li	a2,255
80002240:	e6c682e3          	beq	a3,a2,800020a4 <__subsf3+0xcc>
80002244:	04000637          	lui	a2,0x4000
80002248:	00c7e7b3          	or	a5,a5,a2
8000224c:	fe1ff06f          	j	8000222c <__subsf3+0x254>
80002250:	02000613          	li	a2,32
80002254:	00e7d5b3          	srl	a1,a5,a4
80002258:	40e60733          	sub	a4,a2,a4
8000225c:	00e797b3          	sll	a5,a5,a4
80002260:	00f037b3          	snez	a5,a5
80002264:	00f5e7b3          	or	a5,a1,a5
80002268:	f99ff06f          	j	80002200 <__subsf3+0x228>
8000226c:	08070263          	beqz	a4,800022f0 <__subsf3+0x318>
80002270:	02069e63          	bnez	a3,800022ac <__subsf3+0x2d4>
80002274:	00081863          	bnez	a6,80002284 <__subsf3+0x2ac>
80002278:	0ff00713          	li	a4,255
8000227c:	00058493          	mv	s1,a1
80002280:	e79ff06f          	j	800020f8 <__subsf3+0x120>
80002284:	fff00693          	li	a3,-1
80002288:	00d71863          	bne	a4,a3,80002298 <__subsf3+0x2c0>
8000228c:	410787b3          	sub	a5,a5,a6
80002290:	00058493          	mv	s1,a1
80002294:	f75ff06f          	j	80002208 <__subsf3+0x230>
80002298:	0ff00693          	li	a3,255
8000229c:	fff74713          	not	a4,a4
800022a0:	02d61063          	bne	a2,a3,800022c0 <__subsf3+0x2e8>
800022a4:	00058493          	mv	s1,a1
800022a8:	e75ff06f          	j	8000211c <__subsf3+0x144>
800022ac:	0ff00693          	li	a3,255
800022b0:	fed60ae3          	beq	a2,a3,800022a4 <__subsf3+0x2cc>
800022b4:	040006b7          	lui	a3,0x4000
800022b8:	40e00733          	neg	a4,a4
800022bc:	00d86833          	or	a6,a6,a3
800022c0:	01b00693          	li	a3,27
800022c4:	00e6d663          	ble	a4,a3,800022d0 <__subsf3+0x2f8>
800022c8:	00100713          	li	a4,1
800022cc:	01c0006f          	j	800022e8 <__subsf3+0x310>
800022d0:	02000693          	li	a3,32
800022d4:	00e85633          	srl	a2,a6,a4
800022d8:	40e68733          	sub	a4,a3,a4
800022dc:	00e81733          	sll	a4,a6,a4
800022e0:	00e03733          	snez	a4,a4
800022e4:	00e66733          	or	a4,a2,a4
800022e8:	40e787b3          	sub	a5,a5,a4
800022ec:	fa5ff06f          	j	80002290 <__subsf3+0x2b8>
800022f0:	00168713          	addi	a4,a3,1 # 4000001 <_stack_size+0x3fffc01>
800022f4:	0ff77713          	andi	a4,a4,255
800022f8:	00100613          	li	a2,1
800022fc:	04e64463          	blt	a2,a4,80002344 <__subsf3+0x36c>
80002300:	02069c63          	bnez	a3,80002338 <__subsf3+0x360>
80002304:	00081863          	bnez	a6,80002314 <__subsf3+0x33c>
80002308:	12079863          	bnez	a5,80002438 <__subsf3+0x460>
8000230c:	00000513          	li	a0,0
80002310:	ec1ff06f          	j	800021d0 <__subsf3+0x1f8>
80002314:	12078663          	beqz	a5,80002440 <__subsf3+0x468>
80002318:	40f80733          	sub	a4,a6,a5
8000231c:	00571693          	slli	a3,a4,0x5
80002320:	410787b3          	sub	a5,a5,a6
80002324:	1006ca63          	bltz	a3,80002438 <__subsf3+0x460>
80002328:	00070793          	mv	a5,a4
8000232c:	06071063          	bnez	a4,8000238c <__subsf3+0x3b4>
80002330:	00000793          	li	a5,0
80002334:	fd9ff06f          	j	8000230c <__subsf3+0x334>
80002338:	e80816e3          	bnez	a6,800021c4 <__subsf3+0x1ec>
8000233c:	f60794e3          	bnez	a5,800022a4 <__subsf3+0x2cc>
80002340:	e89ff06f          	j	800021c8 <__subsf3+0x1f0>
80002344:	40f80433          	sub	s0,a6,a5
80002348:	00541713          	slli	a4,s0,0x5
8000234c:	04075463          	bgez	a4,80002394 <__subsf3+0x3bc>
80002350:	41078433          	sub	s0,a5,a6
80002354:	00058493          	mv	s1,a1
80002358:	00040513          	mv	a0,s0
8000235c:	52c000ef          	jal	ra,80002888 <__clzsi2>
80002360:	ffb50513          	addi	a0,a0,-5
80002364:	00a41433          	sll	s0,s0,a0
80002368:	03254a63          	blt	a0,s2,8000239c <__subsf3+0x3c4>
8000236c:	41250533          	sub	a0,a0,s2
80002370:	00150513          	addi	a0,a0,1
80002374:	02000713          	li	a4,32
80002378:	00a457b3          	srl	a5,s0,a0
8000237c:	40a70533          	sub	a0,a4,a0
80002380:	00a41433          	sll	s0,s0,a0
80002384:	00803433          	snez	s0,s0
80002388:	0087e7b3          	or	a5,a5,s0
8000238c:	00000513          	li	a0,0
80002390:	e15ff06f          	j	800021a4 <__subsf3+0x1cc>
80002394:	f8040ee3          	beqz	s0,80002330 <__subsf3+0x358>
80002398:	fc1ff06f          	j	80002358 <__subsf3+0x380>
8000239c:	fc0007b7          	lui	a5,0xfc000
800023a0:	fff78793          	addi	a5,a5,-1 # fbffffff <_stack_start+0x7bff9f2f>
800023a4:	40a90533          	sub	a0,s2,a0
800023a8:	00f477b3          	and	a5,s0,a5
800023ac:	df9ff06f          	j	800021a4 <__subsf3+0x1cc>
800023b0:	00080793          	mv	a5,a6
800023b4:	df1ff06f          	j	800021a4 <__subsf3+0x1cc>
800023b8:	00000793          	li	a5,0
800023bc:	00579713          	slli	a4,a5,0x5
800023c0:	00075e63          	bgez	a4,800023dc <__subsf3+0x404>
800023c4:	00150513          	addi	a0,a0,1
800023c8:	0ff00713          	li	a4,255
800023cc:	06e50e63          	beq	a0,a4,80002448 <__subsf3+0x470>
800023d0:	fc000737          	lui	a4,0xfc000
800023d4:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9f2f>
800023d8:	00e7f7b3          	and	a5,a5,a4
800023dc:	0ff00713          	li	a4,255
800023e0:	0037d793          	srli	a5,a5,0x3
800023e4:	00e51863          	bne	a0,a4,800023f4 <__subsf3+0x41c>
800023e8:	00078663          	beqz	a5,800023f4 <__subsf3+0x41c>
800023ec:	004007b7          	lui	a5,0x400
800023f0:	00000493          	li	s1,0
800023f4:	00800737          	lui	a4,0x800
800023f8:	fff70713          	addi	a4,a4,-1 # 7fffff <_stack_size+0x7ffbff>
800023fc:	0ff57513          	andi	a0,a0,255
80002400:	00e7f7b3          	and	a5,a5,a4
80002404:	01751713          	slli	a4,a0,0x17
80002408:	80800537          	lui	a0,0x80800
8000240c:	00c12083          	lw	ra,12(sp)
80002410:	00812403          	lw	s0,8(sp)
80002414:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9f2f>
80002418:	00a7f533          	and	a0,a5,a0
8000241c:	01f49493          	slli	s1,s1,0x1f
80002420:	00e56533          	or	a0,a0,a4
80002424:	00956533          	or	a0,a0,s1
80002428:	00012903          	lw	s2,0(sp)
8000242c:	00412483          	lw	s1,4(sp)
80002430:	01010113          	addi	sp,sp,16
80002434:	00008067          	ret
80002438:	00058493          	mv	s1,a1
8000243c:	f51ff06f          	j	8000238c <__subsf3+0x3b4>
80002440:	00080793          	mv	a5,a6
80002444:	f49ff06f          	j	8000238c <__subsf3+0x3b4>
80002448:	00000793          	li	a5,0
8000244c:	f91ff06f          	j	800023dc <__subsf3+0x404>

80002450 <__fixsfsi>:
80002450:	00800637          	lui	a2,0x800
80002454:	01755713          	srli	a4,a0,0x17
80002458:	fff60793          	addi	a5,a2,-1 # 7fffff <_stack_size+0x7ffbff>
8000245c:	0ff77713          	andi	a4,a4,255
80002460:	07e00593          	li	a1,126
80002464:	00a7f7b3          	and	a5,a5,a0
80002468:	01f55693          	srli	a3,a0,0x1f
8000246c:	04e5f663          	bleu	a4,a1,800024b8 <__fixsfsi+0x68>
80002470:	09d00593          	li	a1,157
80002474:	00e5fa63          	bleu	a4,a1,80002488 <__fixsfsi+0x38>
80002478:	80000537          	lui	a0,0x80000
8000247c:	fff54513          	not	a0,a0
80002480:	00a68533          	add	a0,a3,a0
80002484:	00008067          	ret
80002488:	00c7e533          	or	a0,a5,a2
8000248c:	09500793          	li	a5,149
80002490:	00e7dc63          	ble	a4,a5,800024a8 <__fixsfsi+0x58>
80002494:	f6a70713          	addi	a4,a4,-150
80002498:	00e51533          	sll	a0,a0,a4
8000249c:	02068063          	beqz	a3,800024bc <__fixsfsi+0x6c>
800024a0:	40a00533          	neg	a0,a0
800024a4:	00008067          	ret
800024a8:	09600793          	li	a5,150
800024ac:	40e78733          	sub	a4,a5,a4
800024b0:	00e55533          	srl	a0,a0,a4
800024b4:	fe9ff06f          	j	8000249c <__fixsfsi+0x4c>
800024b8:	00000513          	li	a0,0
800024bc:	00008067          	ret

800024c0 <__floatsisf>:
800024c0:	ff010113          	addi	sp,sp,-16
800024c4:	00112623          	sw	ra,12(sp)
800024c8:	00812423          	sw	s0,8(sp)
800024cc:	00912223          	sw	s1,4(sp)
800024d0:	10050263          	beqz	a0,800025d4 <__floatsisf+0x114>
800024d4:	00050413          	mv	s0,a0
800024d8:	01f55493          	srli	s1,a0,0x1f
800024dc:	00055463          	bgez	a0,800024e4 <__floatsisf+0x24>
800024e0:	40a00433          	neg	s0,a0
800024e4:	00040513          	mv	a0,s0
800024e8:	3a0000ef          	jal	ra,80002888 <__clzsi2>
800024ec:	09e00793          	li	a5,158
800024f0:	40a787b3          	sub	a5,a5,a0
800024f4:	09600713          	li	a4,150
800024f8:	06f74063          	blt	a4,a5,80002558 <__floatsisf+0x98>
800024fc:	00800713          	li	a4,8
80002500:	00a75663          	ble	a0,a4,8000250c <__floatsisf+0x4c>
80002504:	ff850513          	addi	a0,a0,-8 # 7ffffff8 <_stack_start+0xffff9f28>
80002508:	00a41433          	sll	s0,s0,a0
8000250c:	00800537          	lui	a0,0x800
80002510:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
80002514:	0ff7f793          	andi	a5,a5,255
80002518:	00a47433          	and	s0,s0,a0
8000251c:	01779513          	slli	a0,a5,0x17
80002520:	808007b7          	lui	a5,0x80800
80002524:	fff78793          	addi	a5,a5,-1 # 807fffff <_stack_start+0x7f9f2f>
80002528:	00f47433          	and	s0,s0,a5
8000252c:	800007b7          	lui	a5,0x80000
80002530:	00a46433          	or	s0,s0,a0
80002534:	fff7c793          	not	a5,a5
80002538:	01f49513          	slli	a0,s1,0x1f
8000253c:	00f47433          	and	s0,s0,a5
80002540:	00a46533          	or	a0,s0,a0
80002544:	00c12083          	lw	ra,12(sp)
80002548:	00812403          	lw	s0,8(sp)
8000254c:	00412483          	lw	s1,4(sp)
80002550:	01010113          	addi	sp,sp,16
80002554:	00008067          	ret
80002558:	09900713          	li	a4,153
8000255c:	02f75063          	ble	a5,a4,8000257c <__floatsisf+0xbc>
80002560:	00500713          	li	a4,5
80002564:	40a70733          	sub	a4,a4,a0
80002568:	01b50693          	addi	a3,a0,27
8000256c:	00e45733          	srl	a4,s0,a4
80002570:	00d41433          	sll	s0,s0,a3
80002574:	00803433          	snez	s0,s0
80002578:	00876433          	or	s0,a4,s0
8000257c:	00500713          	li	a4,5
80002580:	00a75663          	ble	a0,a4,8000258c <__floatsisf+0xcc>
80002584:	ffb50713          	addi	a4,a0,-5
80002588:	00e41433          	sll	s0,s0,a4
8000258c:	fc000737          	lui	a4,0xfc000
80002590:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9f2f>
80002594:	00747693          	andi	a3,s0,7
80002598:	00e47733          	and	a4,s0,a4
8000259c:	00068a63          	beqz	a3,800025b0 <__floatsisf+0xf0>
800025a0:	00f47413          	andi	s0,s0,15
800025a4:	00400693          	li	a3,4
800025a8:	00d40463          	beq	s0,a3,800025b0 <__floatsisf+0xf0>
800025ac:	00470713          	addi	a4,a4,4
800025b0:	00571693          	slli	a3,a4,0x5
800025b4:	0006dc63          	bgez	a3,800025cc <__floatsisf+0x10c>
800025b8:	fc0007b7          	lui	a5,0xfc000
800025bc:	fff78793          	addi	a5,a5,-1 # fbffffff <_stack_start+0x7bff9f2f>
800025c0:	00f77733          	and	a4,a4,a5
800025c4:	09f00793          	li	a5,159
800025c8:	40a787b3          	sub	a5,a5,a0
800025cc:	00375413          	srli	s0,a4,0x3
800025d0:	f3dff06f          	j	8000250c <__floatsisf+0x4c>
800025d4:	00000413          	li	s0,0
800025d8:	00000793          	li	a5,0
800025dc:	00000493          	li	s1,0
800025e0:	f2dff06f          	j	8000250c <__floatsisf+0x4c>

800025e4 <__extendsfdf2>:
800025e4:	01755793          	srli	a5,a0,0x17
800025e8:	ff010113          	addi	sp,sp,-16
800025ec:	0ff7f793          	andi	a5,a5,255
800025f0:	00812423          	sw	s0,8(sp)
800025f4:	00178713          	addi	a4,a5,1
800025f8:	00800437          	lui	s0,0x800
800025fc:	00912223          	sw	s1,4(sp)
80002600:	fff40413          	addi	s0,s0,-1 # 7fffff <_stack_size+0x7ffbff>
80002604:	00112623          	sw	ra,12(sp)
80002608:	0ff77713          	andi	a4,a4,255
8000260c:	00100693          	li	a3,1
80002610:	00a47433          	and	s0,s0,a0
80002614:	01f55493          	srli	s1,a0,0x1f
80002618:	06e6d263          	ble	a4,a3,8000267c <__extendsfdf2+0x98>
8000261c:	38078513          	addi	a0,a5,896
80002620:	00345793          	srli	a5,s0,0x3
80002624:	01d41413          	slli	s0,s0,0x1d
80002628:	00100737          	lui	a4,0x100
8000262c:	fff70713          	addi	a4,a4,-1 # fffff <_stack_size+0xffbff>
80002630:	00e7f7b3          	and	a5,a5,a4
80002634:	80100737          	lui	a4,0x80100
80002638:	fff70713          	addi	a4,a4,-1 # 800fffff <_stack_start+0xf9f2f>
8000263c:	7ff57513          	andi	a0,a0,2047
80002640:	01451513          	slli	a0,a0,0x14
80002644:	00e7f7b3          	and	a5,a5,a4
80002648:	80000737          	lui	a4,0x80000
8000264c:	00a7e7b3          	or	a5,a5,a0
80002650:	fff74713          	not	a4,a4
80002654:	01f49513          	slli	a0,s1,0x1f
80002658:	00e7f7b3          	and	a5,a5,a4
8000265c:	00a7e733          	or	a4,a5,a0
80002660:	00c12083          	lw	ra,12(sp)
80002664:	00040513          	mv	a0,s0
80002668:	00812403          	lw	s0,8(sp)
8000266c:	00412483          	lw	s1,4(sp)
80002670:	00070593          	mv	a1,a4
80002674:	01010113          	addi	sp,sp,16
80002678:	00008067          	ret
8000267c:	04079463          	bnez	a5,800026c4 <__extendsfdf2+0xe0>
80002680:	06040263          	beqz	s0,800026e4 <__extendsfdf2+0x100>
80002684:	00040513          	mv	a0,s0
80002688:	200000ef          	jal	ra,80002888 <__clzsi2>
8000268c:	00a00793          	li	a5,10
80002690:	02a7c263          	blt	a5,a0,800026b4 <__extendsfdf2+0xd0>
80002694:	00b00793          	li	a5,11
80002698:	40a787b3          	sub	a5,a5,a0
8000269c:	01550713          	addi	a4,a0,21
800026a0:	00f457b3          	srl	a5,s0,a5
800026a4:	00e41433          	sll	s0,s0,a4
800026a8:	38900713          	li	a4,905
800026ac:	40a70533          	sub	a0,a4,a0
800026b0:	f79ff06f          	j	80002628 <__extendsfdf2+0x44>
800026b4:	ff550793          	addi	a5,a0,-11
800026b8:	00f417b3          	sll	a5,s0,a5
800026bc:	00000413          	li	s0,0
800026c0:	fe9ff06f          	j	800026a8 <__extendsfdf2+0xc4>
800026c4:	00000793          	li	a5,0
800026c8:	00040a63          	beqz	s0,800026dc <__extendsfdf2+0xf8>
800026cc:	00345793          	srli	a5,s0,0x3
800026d0:	00080737          	lui	a4,0x80
800026d4:	01d41413          	slli	s0,s0,0x1d
800026d8:	00e7e7b3          	or	a5,a5,a4
800026dc:	7ff00513          	li	a0,2047
800026e0:	f49ff06f          	j	80002628 <__extendsfdf2+0x44>
800026e4:	00000793          	li	a5,0
800026e8:	00000513          	li	a0,0
800026ec:	f3dff06f          	j	80002628 <__extendsfdf2+0x44>

800026f0 <__truncdfsf2>:
800026f0:	00100637          	lui	a2,0x100
800026f4:	fff60613          	addi	a2,a2,-1 # fffff <_stack_size+0xffbff>
800026f8:	00b67633          	and	a2,a2,a1
800026fc:	0145d813          	srli	a6,a1,0x14
80002700:	01d55793          	srli	a5,a0,0x1d
80002704:	7ff87813          	andi	a6,a6,2047
80002708:	00361613          	slli	a2,a2,0x3
8000270c:	00c7e633          	or	a2,a5,a2
80002710:	00180793          	addi	a5,a6,1
80002714:	7ff7f793          	andi	a5,a5,2047
80002718:	00100693          	li	a3,1
8000271c:	01f5d593          	srli	a1,a1,0x1f
80002720:	00351713          	slli	a4,a0,0x3
80002724:	0af6d663          	ble	a5,a3,800027d0 <__truncdfsf2+0xe0>
80002728:	c8080693          	addi	a3,a6,-896
8000272c:	0fe00793          	li	a5,254
80002730:	0cd7c263          	blt	a5,a3,800027f4 <__truncdfsf2+0x104>
80002734:	08d04063          	bgtz	a3,800027b4 <__truncdfsf2+0xc4>
80002738:	fe900793          	li	a5,-23
8000273c:	12f6c463          	blt	a3,a5,80002864 <__truncdfsf2+0x174>
80002740:	008007b7          	lui	a5,0x800
80002744:	01e00513          	li	a0,30
80002748:	00f66633          	or	a2,a2,a5
8000274c:	40d50533          	sub	a0,a0,a3
80002750:	01f00793          	li	a5,31
80002754:	02a7c863          	blt	a5,a0,80002784 <__truncdfsf2+0x94>
80002758:	c8280813          	addi	a6,a6,-894
8000275c:	010717b3          	sll	a5,a4,a6
80002760:	00f037b3          	snez	a5,a5
80002764:	01061633          	sll	a2,a2,a6
80002768:	00a75533          	srl	a0,a4,a0
8000276c:	00c7e7b3          	or	a5,a5,a2
80002770:	00f567b3          	or	a5,a0,a5
80002774:	00000693          	li	a3,0
80002778:	0077f713          	andi	a4,a5,7
8000277c:	08070063          	beqz	a4,800027fc <__truncdfsf2+0x10c>
80002780:	0ec0006f          	j	8000286c <__truncdfsf2+0x17c>
80002784:	ffe00793          	li	a5,-2
80002788:	40d786b3          	sub	a3,a5,a3
8000278c:	02000793          	li	a5,32
80002790:	00d656b3          	srl	a3,a2,a3
80002794:	00000893          	li	a7,0
80002798:	00f50663          	beq	a0,a5,800027a4 <__truncdfsf2+0xb4>
8000279c:	ca280813          	addi	a6,a6,-862
800027a0:	010618b3          	sll	a7,a2,a6
800027a4:	00e8e7b3          	or	a5,a7,a4
800027a8:	00f037b3          	snez	a5,a5
800027ac:	00f6e7b3          	or	a5,a3,a5
800027b0:	fc5ff06f          	j	80002774 <__truncdfsf2+0x84>
800027b4:	00651513          	slli	a0,a0,0x6
800027b8:	00a03533          	snez	a0,a0
800027bc:	00361613          	slli	a2,a2,0x3
800027c0:	01d75793          	srli	a5,a4,0x1d
800027c4:	00c56633          	or	a2,a0,a2
800027c8:	00f667b3          	or	a5,a2,a5
800027cc:	fadff06f          	j	80002778 <__truncdfsf2+0x88>
800027d0:	00e667b3          	or	a5,a2,a4
800027d4:	00081663          	bnez	a6,800027e0 <__truncdfsf2+0xf0>
800027d8:	00f037b3          	snez	a5,a5
800027dc:	f99ff06f          	j	80002774 <__truncdfsf2+0x84>
800027e0:	0ff00693          	li	a3,255
800027e4:	00078c63          	beqz	a5,800027fc <__truncdfsf2+0x10c>
800027e8:	00361613          	slli	a2,a2,0x3
800027ec:	020007b7          	lui	a5,0x2000
800027f0:	fd9ff06f          	j	800027c8 <__truncdfsf2+0xd8>
800027f4:	00000793          	li	a5,0
800027f8:	0ff00693          	li	a3,255
800027fc:	00579713          	slli	a4,a5,0x5
80002800:	00075e63          	bgez	a4,8000281c <__truncdfsf2+0x12c>
80002804:	00168693          	addi	a3,a3,1
80002808:	0ff00713          	li	a4,255
8000280c:	06e68a63          	beq	a3,a4,80002880 <__truncdfsf2+0x190>
80002810:	fc000737          	lui	a4,0xfc000
80002814:	fff70713          	addi	a4,a4,-1 # fbffffff <_stack_start+0x7bff9f2f>
80002818:	00e7f7b3          	and	a5,a5,a4
8000281c:	0ff00713          	li	a4,255
80002820:	0037d793          	srli	a5,a5,0x3
80002824:	00e69863          	bne	a3,a4,80002834 <__truncdfsf2+0x144>
80002828:	00078663          	beqz	a5,80002834 <__truncdfsf2+0x144>
8000282c:	004007b7          	lui	a5,0x400
80002830:	00000593          	li	a1,0
80002834:	00800537          	lui	a0,0x800
80002838:	fff50513          	addi	a0,a0,-1 # 7fffff <_stack_size+0x7ffbff>
8000283c:	00a7f7b3          	and	a5,a5,a0
80002840:	80800537          	lui	a0,0x80800
80002844:	fff50513          	addi	a0,a0,-1 # 807fffff <_stack_start+0x7f9f2f>
80002848:	0ff6f693          	andi	a3,a3,255
8000284c:	01769693          	slli	a3,a3,0x17
80002850:	00a7f7b3          	and	a5,a5,a0
80002854:	01f59593          	slli	a1,a1,0x1f
80002858:	00d7e7b3          	or	a5,a5,a3
8000285c:	00b7e533          	or	a0,a5,a1
80002860:	00008067          	ret
80002864:	00100793          	li	a5,1
80002868:	00000693          	li	a3,0
8000286c:	00f7f713          	andi	a4,a5,15
80002870:	00400613          	li	a2,4
80002874:	f8c704e3          	beq	a4,a2,800027fc <__truncdfsf2+0x10c>
80002878:	00478793          	addi	a5,a5,4 # 400004 <_stack_size+0x3ffc04>
8000287c:	f81ff06f          	j	800027fc <__truncdfsf2+0x10c>
80002880:	00000793          	li	a5,0
80002884:	f99ff06f          	j	8000281c <__truncdfsf2+0x12c>

80002888 <__clzsi2>:
80002888:	000107b7          	lui	a5,0x10
8000288c:	02f57a63          	bleu	a5,a0,800028c0 <__clzsi2+0x38>
80002890:	0ff00793          	li	a5,255
80002894:	00a7b7b3          	sltu	a5,a5,a0
80002898:	00379793          	slli	a5,a5,0x3
8000289c:	02000713          	li	a4,32
800028a0:	40f70733          	sub	a4,a4,a5
800028a4:	00f557b3          	srl	a5,a0,a5
800028a8:	00000517          	auipc	a0,0x0
800028ac:	6fc50513          	addi	a0,a0,1788 # 80002fa4 <__clz_tab>
800028b0:	00f507b3          	add	a5,a0,a5
800028b4:	0007c503          	lbu	a0,0(a5) # 10000 <_stack_size+0xfc00>
800028b8:	40a70533          	sub	a0,a4,a0
800028bc:	00008067          	ret
800028c0:	01000737          	lui	a4,0x1000
800028c4:	01000793          	li	a5,16
800028c8:	fce56ae3          	bltu	a0,a4,8000289c <__clzsi2+0x14>
800028cc:	01800793          	li	a5,24
800028d0:	fcdff06f          	j	8000289c <__clzsi2+0x14>

Disassembly of section .text.startup:

800028d4 <main>:
int main() {
800028d4:	1141                	addi	sp,sp,-16
800028d6:	c606                	sw	ra,12(sp)
	main2();
800028d8:	945fd0ef          	jal	ra,8000021c <main2>
}
800028dc:	40b2                	lw	ra,12(sp)
	TEST_COM_BASE[8] = 0;
800028de:	f01007b7          	lui	a5,0xf0100
800028e2:	f207a023          	sw	zero,-224(a5) # f00fff20 <_stack_start+0x700f9e50>
}
800028e6:	4501                	li	a0,0
800028e8:	0141                	addi	sp,sp,16
800028ea:	8082                	ret
