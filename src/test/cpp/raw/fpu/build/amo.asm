
build/amo.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	00100e13          	li	t3,1
80000004:	00000097          	auipc	ra,0x0
80000008:	27408093          	addi	ra,ra,628 # 80000278 <test1_data>
8000000c:	02d00113          	li	sp,45
80000010:	0820a1af          	amoswap.w	gp,sp,(ra)
80000014:	0000a203          	lw	tp,0(ra)
80000018:	02d00a13          	li	s4,45
8000001c:	224a1663          	bne	s4,tp,80000248 <fail>
80000020:	00b00a13          	li	s4,11
80000024:	223a1263          	bne	s4,gp,80000248 <fail>

80000028 <test2>:
80000028:	00200e13          	li	t3,2
8000002c:	00000097          	auipc	ra,0x0
80000030:	25008093          	addi	ra,ra,592 # 8000027c <test2_data>
80000034:	03700113          	li	sp,55
80000038:	0820a1af          	amoswap.w	gp,sp,(ra)
8000003c:	0000a203          	lw	tp,0(ra)
80000040:	03700a13          	li	s4,55
80000044:	204a1263          	bne	s4,tp,80000248 <fail>
80000048:	01600a13          	li	s4,22
8000004c:	1e3a1e63          	bne	s4,gp,80000248 <fail>

80000050 <test3>:
80000050:	00300e13          	li	t3,3
80000054:	00000097          	auipc	ra,0x0
80000058:	22c08093          	addi	ra,ra,556 # 80000280 <test3_data>
8000005c:	04200113          	li	sp,66
80000060:	0020a1af          	amoadd.w	gp,sp,(ra)
80000064:	0000a203          	lw	tp,0(ra)
80000068:	08b00a13          	li	s4,139
8000006c:	1c4a1e63          	bne	s4,tp,80000248 <fail>
80000070:	04900a13          	li	s4,73
80000074:	1c3a1a63          	bne	s4,gp,80000248 <fail>

80000078 <test4>:
80000078:	00400e13          	li	t3,4
8000007c:	00000097          	auipc	ra,0x0
80000080:	20808093          	addi	ra,ra,520 # 80000284 <test4_data>
80000084:	05700113          	li	sp,87
80000088:	2020a1af          	amoxor.w	gp,sp,(ra)
8000008c:	0000a203          	lw	tp,0(ra)
80000090:	06d00a13          	li	s4,109
80000094:	1a4a1a63          	bne	s4,tp,80000248 <fail>
80000098:	03a00a13          	li	s4,58
8000009c:	1a3a1663          	bne	s4,gp,80000248 <fail>

800000a0 <test5>:
800000a0:	00500e13          	li	t3,5
800000a4:	00000097          	auipc	ra,0x0
800000a8:	1e408093          	addi	ra,ra,484 # 80000288 <test5_data>
800000ac:	02c00113          	li	sp,44
800000b0:	6020a1af          	amoand.w	gp,sp,(ra)
800000b4:	0000a203          	lw	tp,0(ra)
800000b8:	02800a13          	li	s4,40
800000bc:	184a1663          	bne	s4,tp,80000248 <fail>
800000c0:	03800a13          	li	s4,56
800000c4:	183a1263          	bne	s4,gp,80000248 <fail>

800000c8 <test6>:
800000c8:	00600e13          	li	t3,6
800000cc:	00000097          	auipc	ra,0x0
800000d0:	1c008093          	addi	ra,ra,448 # 8000028c <test6_data>
800000d4:	01800113          	li	sp,24
800000d8:	4020a1af          	amoor.w	gp,sp,(ra)
800000dc:	0000a203          	lw	tp,0(ra)
800000e0:	05b00a13          	li	s4,91
800000e4:	164a1263          	bne	s4,tp,80000248 <fail>
800000e8:	04b00a13          	li	s4,75
800000ec:	143a1e63          	bne	s4,gp,80000248 <fail>

800000f0 <test7>:
800000f0:	00700e13          	li	t3,7
800000f4:	00000097          	auipc	ra,0x0
800000f8:	19c08093          	addi	ra,ra,412 # 80000290 <test7_data>
800000fc:	01800113          	li	sp,24
80000100:	8020a1af          	amomin.w	gp,sp,(ra)
80000104:	0000a203          	lw	tp,0(ra)
80000108:	01800a13          	li	s4,24
8000010c:	124a1e63          	bne	s4,tp,80000248 <fail>
80000110:	03800a13          	li	s4,56
80000114:	123a1a63          	bne	s4,gp,80000248 <fail>

80000118 <test8>:
80000118:	00800e13          	li	t3,8
8000011c:	00000097          	auipc	ra,0x0
80000120:	17808093          	addi	ra,ra,376 # 80000294 <test8_data>
80000124:	05800113          	li	sp,88
80000128:	8020a1af          	amomin.w	gp,sp,(ra)
8000012c:	0000a203          	lw	tp,0(ra)
80000130:	05300a13          	li	s4,83
80000134:	104a1a63          	bne	s4,tp,80000248 <fail>
80000138:	05300a13          	li	s4,83
8000013c:	103a1663          	bne	s4,gp,80000248 <fail>

80000140 <test9>:
80000140:	00900e13          	li	t3,9
80000144:	00000097          	auipc	ra,0x0
80000148:	15408093          	addi	ra,ra,340 # 80000298 <test9_data>
8000014c:	fca00113          	li	sp,-54
80000150:	8020a1af          	amomin.w	gp,sp,(ra)
80000154:	0000a203          	lw	tp,0(ra)
80000158:	fca00a13          	li	s4,-54
8000015c:	0e4a1663          	bne	s4,tp,80000248 <fail>
80000160:	02100a13          	li	s4,33
80000164:	0e3a1263          	bne	s4,gp,80000248 <fail>

80000168 <test10>:
80000168:	00a00e13          	li	t3,10
8000016c:	00000097          	auipc	ra,0x0
80000170:	13008093          	addi	ra,ra,304 # 8000029c <test10_data>
80000174:	03400113          	li	sp,52
80000178:	8020a1af          	amomin.w	gp,sp,(ra)
8000017c:	0000a203          	lw	tp,0(ra)
80000180:	fbf00a13          	li	s4,-65
80000184:	0c4a1263          	bne	s4,tp,80000248 <fail>
80000188:	fbf00a13          	li	s4,-65
8000018c:	0a3a1e63          	bne	s4,gp,80000248 <fail>

80000190 <test11>:
80000190:	00b00e13          	li	t3,11
80000194:	00000097          	auipc	ra,0x0
80000198:	10c08093          	addi	ra,ra,268 # 800002a0 <test11_data>
8000019c:	fcc00113          	li	sp,-52
800001a0:	a020a1af          	amomax.w	gp,sp,(ra)
800001a4:	0000a203          	lw	tp,0(ra)
800001a8:	fcc00a13          	li	s4,-52
800001ac:	084a1e63          	bne	s4,tp,80000248 <fail>
800001b0:	fa900a13          	li	s4,-87
800001b4:	083a1a63          	bne	s4,gp,80000248 <fail>

800001b8 <test12>:
800001b8:	00c00e13          	li	t3,12
800001bc:	00000097          	auipc	ra,0x0
800001c0:	0e808093          	addi	ra,ra,232 # 800002a4 <test12_data>
800001c4:	03400113          	li	sp,52
800001c8:	a020a1af          	amomax.w	gp,sp,(ra)
800001cc:	0000a203          	lw	tp,0(ra)
800001d0:	03400a13          	li	s4,52
800001d4:	064a1a63          	bne	s4,tp,80000248 <fail>
800001d8:	fc900a13          	li	s4,-55
800001dc:	063a1663          	bne	s4,gp,80000248 <fail>

800001e0 <test13>:
800001e0:	00d00e13          	li	t3,13
800001e4:	00000097          	auipc	ra,0x0
800001e8:	0c408093          	addi	ra,ra,196 # 800002a8 <test13_data>
800001ec:	ffff0137          	lui	sp,0xffff0
800001f0:	c020a1af          	amominu.w	gp,sp,(ra)
800001f4:	0000a203          	lw	tp,0(ra)
800001f8:	ffff0a37          	lui	s4,0xffff0
800001fc:	044a1663          	bne	s4,tp,80000248 <fail>
80000200:	ffff0a37          	lui	s4,0xffff0
80000204:	004a0a13          	addi	s4,s4,4 # ffff0004 <test14_data+0x7ffefd58>
80000208:	043a1063          	bne	s4,gp,80000248 <fail>
8000020c:	0480006f          	j	80000254 <pass>

80000210 <test14>:
80000210:	00e00e13          	li	t3,14
80000214:	00000097          	auipc	ra,0x0
80000218:	09808093          	addi	ra,ra,152 # 800002ac <test14_data>
8000021c:	ffff0137          	lui	sp,0xffff0
80000220:	00c10113          	addi	sp,sp,12 # ffff000c <test14_data+0x7ffefd60>
80000224:	e020a1af          	amomaxu.w	gp,sp,(ra)
80000228:	0000a203          	lw	tp,0(ra)
8000022c:	ffff0a37          	lui	s4,0xffff0
80000230:	00ca0a13          	addi	s4,s4,12 # ffff000c <test14_data+0x7ffefd60>
80000234:	004a1a63          	bne	s4,tp,80000248 <fail>
80000238:	ffff0a37          	lui	s4,0xffff0
8000023c:	005a0a13          	addi	s4,s4,5 # ffff0005 <test14_data+0x7ffefd59>
80000240:	003a1463          	bne	s4,gp,80000248 <fail>
80000244:	0100006f          	j	80000254 <pass>

80000248 <fail>:
80000248:	f0100137          	lui	sp,0xf0100
8000024c:	f2410113          	addi	sp,sp,-220 # f00fff24 <test14_data+0x700ffc78>
80000250:	01c12023          	sw	t3,0(sp)

80000254 <pass>:
80000254:	f0100137          	lui	sp,0xf0100
80000258:	f2010113          	addi	sp,sp,-224 # f00fff20 <test14_data+0x700ffc74>
8000025c:	00012023          	sw	zero,0(sp)
80000260:	00000013          	nop
80000264:	00000013          	nop
80000268:	00000013          	nop
8000026c:	00000013          	nop
80000270:	00000013          	nop
80000274:	00000013          	nop

80000278 <test1_data>:
80000278:	0000000b          	0xb

8000027c <test2_data>:
8000027c:	0016                	c.slli	zero,0x5
	...

80000280 <test3_data>:
80000280:	0049                	c.nop	18
	...

80000284 <test4_data>:
80000284:	003a                	c.slli	zero,0xe
	...

80000288 <test5_data>:
80000288:	0038                	addi	a4,sp,8
	...

8000028c <test6_data>:
8000028c:	0000004b          	fnmsub.s	ft0,ft0,ft0,ft0,rne

80000290 <test7_data>:
80000290:	0038                	addi	a4,sp,8
	...

80000294 <test8_data>:
80000294:	00000053          	fadd.s	ft0,ft0,ft0,rne

80000298 <test9_data>:
80000298:	0021                	c.nop	8
	...

8000029c <test10_data>:
8000029c:	ffffffbf  	0xffffffbf

800002a0 <test11_data>:
800002a0:	ffa9                	bnez	a5,800001fa <test13+0x1a>
800002a2:	ffff                	0xffff

800002a4 <test12_data>:
800002a4:	ffc9                	bnez	a5,8000023e <test14+0x2e>
800002a6:	ffff                	0xffff

800002a8 <test13_data>:
800002a8:	0004                	0x4
800002aa:	ffff                	0xffff

800002ac <test14_data>:
800002ac:	0005                	c.nop	1
800002ae:	ffff                	0xffff
