
build/pmp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00000097          	auipc	ra,0x0
80000004:	01008093          	addi	ra,ra,16 # 80000010 <trap>
80000008:	30509073          	csrw	mtvec,ra
8000000c:	00c0006f          	j	80000018 <test0>

80000010 <trap>:
80000010:	341f1073          	csrw	mepc,t5
80000014:	30200073          	mret

80000018 <test0>:
80000018:	00000e13          	li	t3,0
8000001c:	00000f17          	auipc	t5,0x0
80000020:	27cf0f13          	addi	t5,t5,636 # 80000298 <fail>
80000024:	800000b7          	lui	ra,0x80000
80000028:	80008237          	lui	tp,0x80008
8000002c:	deadc137          	lui	sp,0xdeadc
80000030:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc4b>
80000034:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffd5c>
80000038:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7d5c>
8000003c:	0000a183          	lw	gp,0(ra)
80000040:	24311c63          	bne	sp,gp,80000298 <fail>
80000044:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000048:	24311863          	bne	sp,gp,80000298 <fail>
8000004c:	071202b7          	lui	t0,0x7120
80000050:	3a029073          	csrw	pmpcfg0,t0
80000054:	3a002373          	csrr	t1,pmpcfg0
80000058:	24629063          	bne	t0,t1,80000298 <fail>
8000005c:	191f02b7          	lui	t0,0x191f0
80000060:	30428293          	addi	t0,t0,772 # 191f0304 <_start-0x66e0fcfc>
80000064:	3a129073          	csrw	pmpcfg1,t0
80000068:	000f02b7          	lui	t0,0xf0
8000006c:	50628293          	addi	t0,t0,1286 # f0506 <_start-0x7ff0fafa>
80000070:	3a229073          	csrw	pmpcfg2,t0
80000074:	0f1e22b7          	lui	t0,0xf1e2
80000078:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
8000007c:	3a329073          	csrw	pmpcfg3,t0
80000080:	200002b7          	lui	t0,0x20000
80000084:	3b029073          	csrw	pmpaddr0,t0
80000088:	3b002373          	csrr	t1,pmpaddr0
8000008c:	20629663          	bne	t0,t1,80000298 <fail>
80000090:	fff00293          	li	t0,-1
80000094:	3b129073          	csrw	pmpaddr1,t0
80000098:	200022b7          	lui	t0,0x20002
8000009c:	3b229073          	csrw	pmpaddr2,t0
800000a0:	200042b7          	lui	t0,0x20004
800000a4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000a8:	3b329073          	csrw	pmpaddr3,t0
800000ac:	200042b7          	lui	t0,0x20004
800000b0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000b4:	3b429073          	csrw	pmpaddr4,t0
800000b8:	200042b7          	lui	t0,0x20004
800000bc:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c0:	3b529073          	csrw	pmpaddr5,t0
800000c4:	200022b7          	lui	t0,0x20002
800000c8:	fff28293          	addi	t0,t0,-1 # 20001fff <_start-0x5fffe001>
800000cc:	3b629073          	csrw	pmpaddr6,t0
800000d0:	200062b7          	lui	t0,0x20006
800000d4:	fff28293          	addi	t0,t0,-1 # 20005fff <_start-0x5fffa001>
800000d8:	3b729073          	csrw	pmpaddr7,t0
800000dc:	2000c2b7          	lui	t0,0x2000c
800000e0:	3b829073          	csrw	pmpaddr8,t0
800000e4:	2000d2b7          	lui	t0,0x2000d
800000e8:	3b929073          	csrw	pmpaddr9,t0
800000ec:	fff00293          	li	t0,-1
800000f0:	3ba29073          	csrw	pmpaddr10,t0
800000f4:	00000293          	li	t0,0
800000f8:	3bb29073          	csrw	pmpaddr11,t0
800000fc:	00000293          	li	t0,0
80000100:	3bc29073          	csrw	pmpaddr12,t0
80000104:	00000293          	li	t0,0
80000108:	3bd29073          	csrw	pmpaddr13,t0
8000010c:	00000293          	li	t0,0
80000110:	3be29073          	csrw	pmpaddr14,t0
80000114:	00000293          	li	t0,0
80000118:	3bf29073          	csrw	pmpaddr15,t0
8000011c:	00c10137          	lui	sp,0xc10
80000120:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000124:	0020a023          	sw	sp,0(ra)
80000128:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
8000012c:	0000a183          	lw	gp,0(ra)
80000130:	16311463          	bne	sp,gp,80000298 <fail>
80000134:	00000193          	li	gp,0
80000138:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
8000013c:	14311e63          	bne	sp,gp,80000298 <fail>

80000140 <test1>:
80000140:	00100e13          	li	t3,1
80000144:	00000f17          	auipc	t5,0x0
80000148:	154f0f13          	addi	t5,t5,340 # 80000298 <fail>
8000014c:	079212b7          	lui	t0,0x7921
80000150:	80828293          	addi	t0,t0,-2040 # 7920808 <_start-0x786df7f8>
80000154:	3a029073          	csrw	pmpcfg0,t0
80000158:	3a002373          	csrr	t1,pmpcfg0
8000015c:	12629e63          	bne	t0,t1,80000298 <fail>
80000160:	800080b7          	lui	ra,0x80008
80000164:	deadc137          	lui	sp,0xdeadc
80000168:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc4b>
8000016c:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7d5c>
80000170:	00000f17          	auipc	t5,0x0
80000174:	010f0f13          	addi	t5,t5,16 # 80000180 <test2>
80000178:	0000a183          	lw	gp,0(ra)
8000017c:	11c0006f          	j	80000298 <fail>

80000180 <test2>:
80000180:	00200e13          	li	t3,2
80000184:	00000f17          	auipc	t5,0x0
80000188:	114f0f13          	addi	t5,t5,276 # 80000298 <fail>
8000018c:	071202b7          	lui	t0,0x7120
80000190:	3a029073          	csrw	pmpcfg0,t0
80000194:	3a002373          	csrr	t1,pmpcfg0
80000198:	3b205073          	csrwi	pmpaddr2,0
8000019c:	3b202373          	csrr	t1,pmpaddr2
800001a0:	0e030c63          	beqz	t1,80000298 <fail>
800001a4:	0e628a63          	beq	t0,t1,80000298 <fail>
800001a8:	800080b7          	lui	ra,0x80008
800001ac:	deadc137          	lui	sp,0xdeadc
800001b0:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc4b>
800001b4:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7d5c>
800001b8:	00000f17          	auipc	t5,0x0
800001bc:	010f0f13          	addi	t5,t5,16 # 800001c8 <test3>
800001c0:	0000a183          	lw	gp,0(ra)
800001c4:	0d40006f          	j	80000298 <fail>

800001c8 <test3>:
800001c8:	00300e13          	li	t3,3
800001cc:	00000f17          	auipc	t5,0x0
800001d0:	0ccf0f13          	addi	t5,t5,204 # 80000298 <fail>
800001d4:	00000117          	auipc	sp,0x0
800001d8:	01010113          	addi	sp,sp,16 # 800001e4 <test4>
800001dc:	34111073          	csrw	mepc,sp
800001e0:	30200073          	mret

800001e4 <test4>:
800001e4:	00400e13          	li	t3,4
800001e8:	00000f17          	auipc	t5,0x0
800001ec:	0b0f0f13          	addi	t5,t5,176 # 80000298 <fail>
800001f0:	deadc137          	lui	sp,0xdeadc
800001f4:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc4b>
800001f8:	800080b7          	lui	ra,0x80008
800001fc:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7d5c>
80000200:	00000f17          	auipc	t5,0x0
80000204:	010f0f13          	addi	t5,t5,16 # 80000210 <test5>
80000208:	0000a183          	lw	gp,0(ra)
8000020c:	08c0006f          	j	80000298 <fail>

80000210 <test5>:
80000210:	00500e13          	li	t3,5
80000214:	deadc137          	lui	sp,0xdeadc
80000218:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc4b>
8000021c:	800000b7          	lui	ra,0x80000
80000220:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffd5c>
80000224:	0000a183          	lw	gp,0(ra)
80000228:	06311863          	bne	sp,gp,80000298 <fail>

8000022c <test6>:
8000022c:	00600e13          	li	t3,6
80000230:	800100b7          	lui	ra,0x80010
80000234:	0000a183          	lw	gp,0(ra) # 80010000 <pass+0xfd5c>
80000238:	00000f17          	auipc	t5,0x0
8000023c:	06cf0f13          	addi	t5,t5,108 # 800002a4 <pass>
80000240:	0030a023          	sw	gp,0(ra)
80000244:	0540006f          	j	80000298 <fail>

80000248 <test7>:
80000248:	00700e13          	li	t3,7
8000024c:	00000f17          	auipc	t5,0x0
80000250:	04cf0f13          	addi	t5,t5,76 # 80000298 <fail>
80000254:	deadc137          	lui	sp,0xdeadc
80000258:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc4b>
8000025c:	800300b7          	lui	ra,0x80030
80000260:	ff808093          	addi	ra,ra,-8 # 8002fff8 <pass+0x2fd54>
80000264:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000268:	00000f17          	auipc	t5,0x0
8000026c:	fa8f0f13          	addi	t5,t5,-88 # 80000210 <test5>
80000270:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000274:	0240006f          	j	80000298 <fail>

80000278 <test8>:
80000278:	00800e13          	li	t3,8
8000027c:	800400b7          	lui	ra,0x80040
80000280:	ff808093          	addi	ra,ra,-8 # 8003fff8 <pass+0x3fd54>
80000284:	0000a183          	lw	gp,0(ra)
80000288:	00000f17          	auipc	t5,0x0
8000028c:	01cf0f13          	addi	t5,t5,28 # 800002a4 <pass>
80000290:	0030a023          	sw	gp,0(ra)
80000294:	0040006f          	j	80000298 <fail>

80000298 <fail>:
80000298:	f0100137          	lui	sp,0xf0100
8000029c:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffc80>
800002a0:	01c12023          	sw	t3,0(sp)

800002a4 <pass>:
800002a4:	f0100137          	lui	sp,0xf0100
800002a8:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffc7c>
800002ac:	00012023          	sw	zero,0(sp)
