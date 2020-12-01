
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
80000018:	00014337          	lui	t1,0x14
8000001c:	30033073          	csrc	mstatus,t1
80000020:	20000313          	li	t1,512
80000024:	30032073          	csrs	mstatus,t1
80000028:	34109073          	csrw	mepc,ra
8000002c:	30200073          	mret

80000030 <test0>:
80000030:	00000e13          	li	t3,0
80000034:	00000f17          	auipc	t5,0x0
80000038:	1f0f0f13          	addi	t5,t5,496 # 80000224 <fail>
8000003c:	800002b7          	lui	t0,0x80000
80000040:	80008e37          	lui	t3,0x80008
80000044:	deadc337          	lui	t1,0xdeadc
80000048:	eef30313          	addi	t1,t1,-273 # deadbeef <pass+0x5eadbcbf>
8000004c:	0062a023          	sw	t1,0(t0) # 80000000 <pass+0xfffffdd0>
80000050:	006e2023          	sw	t1,0(t3) # 80008000 <pass+0x7dd0>
80000054:	0002a383          	lw	t2,0(t0)
80000058:	1c731663          	bne	t1,t2,80000224 <fail>
8000005c:	000e2383          	lw	t2,0(t3)
80000060:	1c731263          	bne	t1,t2,80000224 <fail>
80000064:	071a1f37          	lui	t5,0x71a1
80000068:	808f0f13          	addi	t5,t5,-2040 # 71a0808 <_start-0x78e5f7f8>
8000006c:	3a0f1073          	csrw	pmpcfg0,t5
80000070:	191c0f37          	lui	t5,0x191c0
80000074:	504f0f13          	addi	t5,t5,1284 # 191c0504 <_start-0x66e3fafc>
80000078:	3a1f1073          	csrw	pmpcfg1,t5
8000007c:	01800f13          	li	t5,24
80000080:	3a2f1073          	csrw	pmpcfg2,t5
80000084:	0f1e2f37          	lui	t5,0xf1e2
80000088:	900f0f13          	addi	t5,t5,-1792 # f1e1900 <_start-0x70e1e700>
8000008c:	3a3f1073          	csrw	pmpcfg3,t5
80000090:	20000f37          	lui	t5,0x20000
80000094:	3b0f1073          	csrw	pmpaddr0,t5
80000098:	fff00f13          	li	t5,-1
8000009c:	3b1f1073          	csrw	pmpaddr1,t5
800000a0:	20002f37          	lui	t5,0x20002
800000a4:	3b2f1073          	csrw	pmpaddr2,t5
800000a8:	20004f37          	lui	t5,0x20004
800000ac:	ffff0f13          	addi	t5,t5,-1 # 20003fff <_start-0x5fffc001>
800000b0:	3b3f1073          	csrw	pmpaddr3,t5
800000b4:	20004f37          	lui	t5,0x20004
800000b8:	ffff0f13          	addi	t5,t5,-1 # 20003fff <_start-0x5fffc001>
800000bc:	3b4f1073          	csrw	pmpaddr4,t5
800000c0:	20004f37          	lui	t5,0x20004
800000c4:	ffff0f13          	addi	t5,t5,-1 # 20003fff <_start-0x5fffc001>
800000c8:	3b5f1073          	csrw	pmpaddr5,t5
800000cc:	20002f37          	lui	t5,0x20002
800000d0:	ffff0f13          	addi	t5,t5,-1 # 20001fff <_start-0x5fffe001>
800000d4:	3b6f1073          	csrw	pmpaddr6,t5
800000d8:	20004f37          	lui	t5,0x20004
800000dc:	ffff0f13          	addi	t5,t5,-1 # 20003fff <_start-0x5fffc001>
800000e0:	3b7f1073          	csrw	pmpaddr7,t5
800000e4:	20004f37          	lui	t5,0x20004
800000e8:	ffff0f13          	addi	t5,t5,-1 # 20003fff <_start-0x5fffc001>
800000ec:	3b8f1073          	csrw	pmpaddr8,t5
800000f0:	00000f13          	li	t5,0
800000f4:	3b9f1073          	csrw	pmpaddr9,t5
800000f8:	00000f13          	li	t5,0
800000fc:	3baf1073          	csrw	pmpaddr10,t5
80000100:	00000f13          	li	t5,0
80000104:	3bbf1073          	csrw	pmpaddr11,t5
80000108:	00000f13          	li	t5,0
8000010c:	3bcf1073          	csrw	pmpaddr12,t5
80000110:	00000f13          	li	t5,0
80000114:	3bdf1073          	csrw	pmpaddr13,t5
80000118:	00000f13          	li	t5,0
8000011c:	3bef1073          	csrw	pmpaddr14,t5
80000120:	00000f13          	li	t5,0
80000124:	3bff1073          	csrw	pmpaddr15,t5
80000128:	00c10337          	lui	t1,0xc10
8000012c:	fee30313          	addi	t1,t1,-18 # c0ffee <_start-0x7f3f0012>
80000130:	0062a023          	sw	t1,0(t0)
80000134:	006e2023          	sw	t1,0(t3)
80000138:	0002a383          	lw	t2,0(t0)
8000013c:	0e731463          	bne	t1,t2,80000224 <fail>
80000140:	000e2383          	lw	t2,0(t3)
80000144:	0e731063          	bne	t1,t2,80000224 <fail>

80000148 <test1>:
80000148:	00100e13          	li	t3,1
8000014c:	00000f17          	auipc	t5,0x0
80000150:	0d8f0f13          	addi	t5,t5,216 # 80000224 <fail>
80000154:	079a1f37          	lui	t5,0x79a1
80000158:	808f0f13          	addi	t5,t5,-2040 # 79a0808 <_start-0x7865f7f8>
8000015c:	3a0f1073          	csrw	pmpcfg0,t5
80000160:	deadc337          	lui	t1,0xdeadc
80000164:	eef30313          	addi	t1,t1,-273 # deadbeef <pass+0x5eadbcbf>
80000168:	006e2023          	sw	t1,0(t3)
8000016c:	00000f17          	auipc	t5,0x0
80000170:	010f0f13          	addi	t5,t5,16 # 8000017c <test2>
80000174:	000e2383          	lw	t2,0(t3)
80000178:	0ac0006f          	j	80000224 <fail>

8000017c <test2>:
8000017c:	00200e13          	li	t3,2
80000180:	00000f17          	auipc	t5,0x0
80000184:	0a4f0f13          	addi	t5,t5,164 # 80000224 <fail>
80000188:	071a1f37          	lui	t5,0x71a1
8000018c:	808f0f13          	addi	t5,t5,-2040 # 71a0808 <_start-0x78e5f7f8>
80000190:	3a0f1073          	csrw	pmpcfg0,t5
80000194:	deadc337          	lui	t1,0xdeadc
80000198:	eef30313          	addi	t1,t1,-273 # deadbeef <pass+0x5eadbcbf>
8000019c:	006e2023          	sw	t1,0(t3)
800001a0:	00000f17          	auipc	t5,0x0
800001a4:	010f0f13          	addi	t5,t5,16 # 800001b0 <test3>
800001a8:	000e2383          	lw	t2,0(t3)
800001ac:	0780006f          	j	80000224 <fail>

800001b0 <test3>:
800001b0:	00300e13          	li	t3,3
800001b4:	00000f17          	auipc	t5,0x0
800001b8:	070f0f13          	addi	t5,t5,112 # 80000224 <fail>
800001bc:	00000097          	auipc	ra,0x0
800001c0:	00c08093          	addi	ra,ra,12 # 800001c8 <test4>
800001c4:	e55ff06f          	j	80000018 <to_user>

800001c8 <test4>:
800001c8:	00400e13          	li	t3,4
800001cc:	00000f17          	auipc	t5,0x0
800001d0:	058f0f13          	addi	t5,t5,88 # 80000224 <fail>
800001d4:	deadc337          	lui	t1,0xdeadc
800001d8:	eef30313          	addi	t1,t1,-273 # deadbeef <pass+0x5eadbcbf>
800001dc:	006e2023          	sw	t1,0(t3)
800001e0:	00000f17          	auipc	t5,0x0
800001e4:	010f0f13          	addi	t5,t5,16 # 800001f0 <test5>
800001e8:	000e2383          	lw	t2,0(t3)
800001ec:	0380006f          	j	80000224 <fail>

800001f0 <test5>:
800001f0:	00500e13          	li	t3,5
800001f4:	00000f17          	auipc	t5,0x0
800001f8:	03cf0f13          	addi	t5,t5,60 # 80000230 <pass>
800001fc:	80010e37          	lui	t3,0x80010
80000200:	deadc337          	lui	t1,0xdeadc
80000204:	eef30313          	addi	t1,t1,-273 # deadbeef <pass+0x5eadbcbf>
80000208:	0062a023          	sw	t1,0(t0)
8000020c:	0002a383          	lw	t2,0(t0)
80000210:	00731a63          	bne	t1,t2,80000224 <fail>
80000214:	000e2383          	lw	t2,0(t3) # 80010000 <pass+0xfdd0>
80000218:	00000f17          	auipc	t5,0x0
8000021c:	018f0f13          	addi	t5,t5,24 # 80000230 <pass>
80000220:	007e2023          	sw	t2,0(t3)

80000224 <fail>:
80000224:	f0100137          	lui	sp,0xf0100
80000228:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffcf4>
8000022c:	01c12023          	sw	t3,0(sp)

80000230 <pass>:
80000230:	f0100137          	lui	sp,0xf0100
80000234:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffcf0>
80000238:	00012023          	sw	zero,0(sp)
