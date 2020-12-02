
build/pmp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	01008093          	addi	ra,ra,16 # 80000010 <trap>
80000008:	30509073          	csrw	mtvec,ra
8000000c:	0240006f          	j	80000030 <test0>

80000010 <trap>:
80000010:	341f1073          	csrw	mepc,t5
80000014:	30200073          	mret

80000018 <to_user>:
80000018:	00014137          	lui	sp,0x14
8000001c:	30013073          	csrc	mstatus,sp
80000020:	20000113          	li	sp,512
80000024:	30012073          	csrs	mstatus,sp
80000028:	341e9073          	csrw	mepc,t4
8000002c:	30200073          	mret

80000030 <test0>:
80000030:	00000e13          	li	t3,0
80000034:	00000f17          	auipc	t5,0x0
80000038:	1f0f0f13          	addi	t5,t5,496 # 80000224 <fail>
8000003c:	800000b7          	lui	ra,0x80000
80000040:	80008237          	lui	tp,0x80008
80000044:	deadc137          	lui	sp,0xdeadc
80000048:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcbf>
8000004c:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffdd0>
80000050:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7dd0>
80000054:	0000a183          	lw	gp,0(ra)
80000058:	1c311663          	bne	sp,gp,80000224 <fail>
8000005c:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000060:	1c311263          	bne	sp,gp,80000224 <fail>
80000064:	071a12b7          	lui	t0,0x71a1
80000068:	80828293          	addi	t0,t0,-2040 # 71a0808 <_start-0x78e5f7f8>
8000006c:	3a029073          	csrw	pmpcfg0,t0
80000070:	191c02b7          	lui	t0,0x191c0
80000074:	50428293          	addi	t0,t0,1284 # 191c0504 <_start-0x66e3fafc>
80000078:	3a129073          	csrw	pmpcfg1,t0
8000007c:	01800293          	li	t0,24
80000080:	3a229073          	csrw	pmpcfg2,t0
80000084:	0f1e22b7          	lui	t0,0xf1e2
80000088:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
8000008c:	3a329073          	csrw	pmpcfg3,t0
80000090:	200002b7          	lui	t0,0x20000
80000094:	3b029073          	csrw	pmpaddr0,t0
80000098:	fff00293          	li	t0,-1
8000009c:	3b129073          	csrw	pmpaddr1,t0
800000a0:	200022b7          	lui	t0,0x20002
800000a4:	3b229073          	csrw	pmpaddr2,t0
800000a8:	200042b7          	lui	t0,0x20004
800000ac:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000b0:	3b329073          	csrw	pmpaddr3,t0
800000b4:	200042b7          	lui	t0,0x20004
800000b8:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000bc:	3b429073          	csrw	pmpaddr4,t0
800000c0:	200042b7          	lui	t0,0x20004
800000c4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c8:	3b529073          	csrw	pmpaddr5,t0
800000cc:	200022b7          	lui	t0,0x20002
800000d0:	fff28293          	addi	t0,t0,-1 # 20001fff <_start-0x5fffe001>
800000d4:	3b629073          	csrw	pmpaddr6,t0
800000d8:	200042b7          	lui	t0,0x20004
800000dc:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000e0:	3b729073          	csrw	pmpaddr7,t0
800000e4:	200042b7          	lui	t0,0x20004
800000e8:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000ec:	3b829073          	csrw	pmpaddr8,t0
800000f0:	00000293          	li	t0,0
800000f4:	3b929073          	csrw	pmpaddr9,t0
800000f8:	00000293          	li	t0,0
800000fc:	3ba29073          	csrw	pmpaddr10,t0
80000100:	00000293          	li	t0,0
80000104:	3bb29073          	csrw	pmpaddr11,t0
80000108:	00000293          	li	t0,0
8000010c:	3bc29073          	csrw	pmpaddr12,t0
80000110:	00000293          	li	t0,0
80000114:	3bd29073          	csrw	pmpaddr13,t0
80000118:	00000293          	li	t0,0
8000011c:	3be29073          	csrw	pmpaddr14,t0
80000120:	00000293          	li	t0,0
80000124:	3bf29073          	csrw	pmpaddr15,t0
80000128:	00c10137          	lui	sp,0xc10
8000012c:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000130:	0020a023          	sw	sp,0(ra)
80000134:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000138:	0000a183          	lw	gp,0(ra)
8000013c:	0e311463          	bne	sp,gp,80000224 <fail>
80000140:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000144:	0e311063          	bne	sp,gp,80000224 <fail>

80000148 <test1>:
80000148:	00100e13          	li	t3,1
8000014c:	00000f17          	auipc	t5,0x0
80000150:	0d8f0f13          	addi	t5,t5,216 # 80000224 <fail>
80000154:	079a12b7          	lui	t0,0x79a1
80000158:	80828293          	addi	t0,t0,-2040 # 79a0808 <_start-0x7865f7f8>
8000015c:	3a029073          	csrw	pmpcfg0,t0
80000160:	deadc137          	lui	sp,0xdeadc
80000164:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcbf>
80000168:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
8000016c:	00000f17          	auipc	t5,0x0
80000170:	010f0f13          	addi	t5,t5,16 # 8000017c <test2>
80000174:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000178:	0ac0006f          	j	80000224 <fail>

8000017c <test2>:
8000017c:	00200e13          	li	t3,2
80000180:	00000f17          	auipc	t5,0x0
80000184:	0a4f0f13          	addi	t5,t5,164 # 80000224 <fail>
80000188:	071a12b7          	lui	t0,0x71a1
8000018c:	80828293          	addi	t0,t0,-2040 # 71a0808 <_start-0x78e5f7f8>
80000190:	3a029073          	csrw	pmpcfg0,t0
80000194:	deadc137          	lui	sp,0xdeadc
80000198:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcbf>
8000019c:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
800001a0:	00000f17          	auipc	t5,0x0
800001a4:	010f0f13          	addi	t5,t5,16 # 800001b0 <test3>
800001a8:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
800001ac:	0780006f          	j	80000224 <fail>

800001b0 <test3>:
800001b0:	00300e13          	li	t3,3
800001b4:	00000f17          	auipc	t5,0x0
800001b8:	070f0f13          	addi	t5,t5,112 # 80000224 <fail>
800001bc:	00000e97          	auipc	t4,0x0
800001c0:	00ce8e93          	addi	t4,t4,12 # 800001c8 <test4>
800001c4:	e55ff06f          	j	80000018 <to_user>

800001c8 <test4>:
800001c8:	00400e13          	li	t3,4
800001cc:	00000f17          	auipc	t5,0x0
800001d0:	058f0f13          	addi	t5,t5,88 # 80000224 <fail>
800001d4:	deadc137          	lui	sp,0xdeadc
800001d8:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcbf>
800001dc:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
800001e0:	00000f17          	auipc	t5,0x0
800001e4:	010f0f13          	addi	t5,t5,16 # 800001f0 <test5>
800001e8:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
800001ec:	0380006f          	j	80000224 <fail>

800001f0 <test5>:
800001f0:	00500e13          	li	t3,5
800001f4:	00000f17          	auipc	t5,0x0
800001f8:	03cf0f13          	addi	t5,t5,60 # 80000230 <pass>
800001fc:	80010237          	lui	tp,0x80010
80000200:	deadc137          	lui	sp,0xdeadc
80000204:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcbf>
80000208:	0020a023          	sw	sp,0(ra)
8000020c:	0000a183          	lw	gp,0(ra)
80000210:	00311a63          	bne	sp,gp,80000224 <fail>
80000214:	00022183          	lw	gp,0(tp) # 80010000 <pass+0xfdd0>
80000218:	00000f17          	auipc	t5,0x0
8000021c:	018f0f13          	addi	t5,t5,24 # 80000230 <pass>
80000220:	00322023          	sw	gp,0(tp) # 0 <_start-0x80000000>

80000224 <fail>:
80000224:	f0100137          	lui	sp,0xf0100
80000228:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffcf4>
8000022c:	01c12023          	sw	t3,0(sp)

80000230 <pass>:
80000230:	f0100137          	lui	sp,0xf0100
80000234:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffcf0>
80000238:	00012023          	sw	zero,0(sp)
