
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
80000020:	250f0f13          	addi	t5,t5,592 # 8000026c <fail>
80000024:	800000b7          	lui	ra,0x80000
80000028:	80008237          	lui	tp,0x80008
8000002c:	deadc137          	lui	sp,0xdeadc
80000030:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc77>
80000034:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffd88>
80000038:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7d88>
8000003c:	0000a183          	lw	gp,0(ra)
80000040:	22311663          	bne	sp,gp,8000026c <fail>
80000044:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000048:	22311263          	bne	sp,gp,8000026c <fail>
8000004c:	071202b7          	lui	t0,0x7120
80000050:	3a029073          	csrw	pmpcfg0,t0
80000054:	191f02b7          	lui	t0,0x191f0
80000058:	30428293          	addi	t0,t0,772 # 191f0304 <_start-0x66e0fcfc>
8000005c:	3a129073          	csrw	pmpcfg1,t0
80000060:	000f02b7          	lui	t0,0xf0
80000064:	50628293          	addi	t0,t0,1286 # f0506 <_start-0x7ff0fafa>
80000068:	3a229073          	csrw	pmpcfg2,t0
8000006c:	0f1e22b7          	lui	t0,0xf1e2
80000070:	90028293          	addi	t0,t0,-1792 # f1e1900 <_start-0x70e1e700>
80000074:	3a329073          	csrw	pmpcfg3,t0
80000078:	200002b7          	lui	t0,0x20000
8000007c:	3b029073          	csrw	pmpaddr0,t0
80000080:	fff00293          	li	t0,-1
80000084:	3b129073          	csrw	pmpaddr1,t0
80000088:	200022b7          	lui	t0,0x20002
8000008c:	3b229073          	csrw	pmpaddr2,t0
80000090:	200042b7          	lui	t0,0x20004
80000094:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
80000098:	3b329073          	csrw	pmpaddr3,t0
8000009c:	200042b7          	lui	t0,0x20004
800000a0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000a4:	3b429073          	csrw	pmpaddr4,t0
800000a8:	200042b7          	lui	t0,0x20004
800000ac:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000b0:	3b529073          	csrw	pmpaddr5,t0
800000b4:	200022b7          	lui	t0,0x20002
800000b8:	fff28293          	addi	t0,t0,-1 # 20001fff <_start-0x5fffe001>
800000bc:	3b629073          	csrw	pmpaddr6,t0
800000c0:	200062b7          	lui	t0,0x20006
800000c4:	fff28293          	addi	t0,t0,-1 # 20005fff <_start-0x5fffa001>
800000c8:	3b729073          	csrw	pmpaddr7,t0
800000cc:	2000c2b7          	lui	t0,0x2000c
800000d0:	3b829073          	csrw	pmpaddr8,t0
800000d4:	2000d2b7          	lui	t0,0x2000d
800000d8:	3b929073          	csrw	pmpaddr9,t0
800000dc:	fff00293          	li	t0,-1
800000e0:	3ba29073          	csrw	pmpaddr10,t0
800000e4:	00000293          	li	t0,0
800000e8:	3bb29073          	csrw	pmpaddr11,t0
800000ec:	00000293          	li	t0,0
800000f0:	3bc29073          	csrw	pmpaddr12,t0
800000f4:	00000293          	li	t0,0
800000f8:	3bd29073          	csrw	pmpaddr13,t0
800000fc:	00000293          	li	t0,0
80000100:	3be29073          	csrw	pmpaddr14,t0
80000104:	00000293          	li	t0,0
80000108:	3bf29073          	csrw	pmpaddr15,t0
8000010c:	00c10137          	lui	sp,0xc10
80000110:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000114:	0020a023          	sw	sp,0(ra)
80000118:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
8000011c:	0000a183          	lw	gp,0(ra)
80000120:	14311663          	bne	sp,gp,8000026c <fail>
80000124:	00000193          	li	gp,0
80000128:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
8000012c:	14311063          	bne	sp,gp,8000026c <fail>

80000130 <test1>:
80000130:	00100e13          	li	t3,1
80000134:	00000f17          	auipc	t5,0x0
80000138:	138f0f13          	addi	t5,t5,312 # 8000026c <fail>
8000013c:	079212b7          	lui	t0,0x7921
80000140:	80828293          	addi	t0,t0,-2040 # 7920808 <_start-0x786df7f8>
80000144:	3a029073          	csrw	pmpcfg0,t0
80000148:	800080b7          	lui	ra,0x80008
8000014c:	deadc137          	lui	sp,0xdeadc
80000150:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc77>
80000154:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7d88>
80000158:	00000f17          	auipc	t5,0x0
8000015c:	010f0f13          	addi	t5,t5,16 # 80000168 <test2>
80000160:	0000a183          	lw	gp,0(ra)
80000164:	1080006f          	j	8000026c <fail>

80000168 <test2>:
80000168:	00200e13          	li	t3,2
8000016c:	00000f17          	auipc	t5,0x0
80000170:	100f0f13          	addi	t5,t5,256 # 8000026c <fail>
80000174:	071202b7          	lui	t0,0x7120
80000178:	3a029073          	csrw	pmpcfg0,t0
8000017c:	800080b7          	lui	ra,0x80008
80000180:	deadc137          	lui	sp,0xdeadc
80000184:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc77>
80000188:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7d88>
8000018c:	00000f17          	auipc	t5,0x0
80000190:	010f0f13          	addi	t5,t5,16 # 8000019c <test3>
80000194:	0000a183          	lw	gp,0(ra)
80000198:	0d40006f          	j	8000026c <fail>

8000019c <test3>:
8000019c:	00300e13          	li	t3,3
800001a0:	00000f17          	auipc	t5,0x0
800001a4:	0ccf0f13          	addi	t5,t5,204 # 8000026c <fail>
800001a8:	00000117          	auipc	sp,0x0
800001ac:	01010113          	addi	sp,sp,16 # 800001b8 <test4>
800001b0:	34111073          	csrw	mepc,sp
800001b4:	30200073          	mret

800001b8 <test4>:
800001b8:	00400e13          	li	t3,4
800001bc:	00000f17          	auipc	t5,0x0
800001c0:	0b0f0f13          	addi	t5,t5,176 # 8000026c <fail>
800001c4:	deadc137          	lui	sp,0xdeadc
800001c8:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc77>
800001cc:	800080b7          	lui	ra,0x80008
800001d0:	0020a023          	sw	sp,0(ra) # 80008000 <pass+0x7d88>
800001d4:	00000f17          	auipc	t5,0x0
800001d8:	010f0f13          	addi	t5,t5,16 # 800001e4 <test5>
800001dc:	0000a183          	lw	gp,0(ra)
800001e0:	08c0006f          	j	8000026c <fail>

800001e4 <test5>:
800001e4:	00500e13          	li	t3,5
800001e8:	deadc137          	lui	sp,0xdeadc
800001ec:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc77>
800001f0:	800000b7          	lui	ra,0x80000
800001f4:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffd88>
800001f8:	0000a183          	lw	gp,0(ra)
800001fc:	06311863          	bne	sp,gp,8000026c <fail>

80000200 <test6>:
80000200:	00600e13          	li	t3,6
80000204:	800100b7          	lui	ra,0x80010
80000208:	0000a183          	lw	gp,0(ra) # 80010000 <pass+0xfd88>
8000020c:	00000f17          	auipc	t5,0x0
80000210:	06cf0f13          	addi	t5,t5,108 # 80000278 <pass>
80000214:	0030a023          	sw	gp,0(ra)
80000218:	0540006f          	j	8000026c <fail>

8000021c <test7>:
8000021c:	00700e13          	li	t3,7
80000220:	00000f17          	auipc	t5,0x0
80000224:	04cf0f13          	addi	t5,t5,76 # 8000026c <fail>
80000228:	deadc137          	lui	sp,0xdeadc
8000022c:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbc77>
80000230:	800300b7          	lui	ra,0x80030
80000234:	ff808093          	addi	ra,ra,-8 # 8002fff8 <pass+0x2fd80>
80000238:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
8000023c:	00000f17          	auipc	t5,0x0
80000240:	fa8f0f13          	addi	t5,t5,-88 # 800001e4 <test5>
80000244:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000248:	0240006f          	j	8000026c <fail>

8000024c <test8>:
8000024c:	00800e13          	li	t3,8
80000250:	800400b7          	lui	ra,0x80040
80000254:	ff808093          	addi	ra,ra,-8 # 8003fff8 <pass+0x3fd80>
80000258:	0000a183          	lw	gp,0(ra)
8000025c:	00000f17          	auipc	t5,0x0
80000260:	01cf0f13          	addi	t5,t5,28 # 80000278 <pass>
80000264:	0030a023          	sw	gp,0(ra)
80000268:	0040006f          	j	8000026c <fail>

8000026c <fail>:
8000026c:	f0100137          	lui	sp,0xf0100
80000270:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffcac>
80000274:	01c12023          	sw	t3,0(sp)

80000278 <pass>:
80000278:	f0100137          	lui	sp,0xf0100
8000027c:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffca8>
80000280:	00012023          	sw	zero,0(sp)
