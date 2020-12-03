
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
80000020:	1f4f0f13          	addi	t5,t5,500 # 80000210 <fail>
80000024:	800000b7          	lui	ra,0x80000
80000028:	80008237          	lui	tp,0x80008
8000002c:	deadc137          	lui	sp,0xdeadc
80000030:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcd3>
80000034:	0020a023          	sw	sp,0(ra) # 80000000 <pass+0xfffffde4>
80000038:	00222023          	sw	sp,0(tp) # 80008000 <pass+0x7de4>
8000003c:	0000a183          	lw	gp,0(ra)
80000040:	1c311863          	bne	sp,gp,80000210 <fail>
80000044:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000048:	1c311463          	bne	sp,gp,80000210 <fail>
8000004c:	071212b7          	lui	t0,0x7121
80000050:	80828293          	addi	t0,t0,-2040 # 7120808 <_start-0x78edf7f8>
80000054:	3a029073          	csrw	pmpcfg0,t0
80000058:	191f02b7          	lui	t0,0x191f0
8000005c:	30428293          	addi	t0,t0,772 # 191f0304 <_start-0x66e0fcfc>
80000060:	3a129073          	csrw	pmpcfg1,t0
80000064:	01800293          	li	t0,24
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
800000c0:	200042b7          	lui	t0,0x20004
800000c4:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000c8:	3b729073          	csrw	pmpaddr7,t0
800000cc:	200042b7          	lui	t0,0x20004
800000d0:	fff28293          	addi	t0,t0,-1 # 20003fff <_start-0x5fffc001>
800000d4:	3b829073          	csrw	pmpaddr8,t0
800000d8:	00000293          	li	t0,0
800000dc:	3b929073          	csrw	pmpaddr9,t0
800000e0:	00000293          	li	t0,0
800000e4:	3ba29073          	csrw	pmpaddr10,t0
800000e8:	00000293          	li	t0,0
800000ec:	3bb29073          	csrw	pmpaddr11,t0
800000f0:	00000293          	li	t0,0
800000f4:	3bc29073          	csrw	pmpaddr12,t0
800000f8:	00000293          	li	t0,0
800000fc:	3bd29073          	csrw	pmpaddr13,t0
80000100:	00000293          	li	t0,0
80000104:	3be29073          	csrw	pmpaddr14,t0
80000108:	00000293          	li	t0,0
8000010c:	3bf29073          	csrw	pmpaddr15,t0
80000110:	00c10137          	lui	sp,0xc10
80000114:	fee10113          	addi	sp,sp,-18 # c0ffee <_start-0x7f3f0012>
80000118:	0020a023          	sw	sp,0(ra)
8000011c:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000120:	0000a183          	lw	gp,0(ra)
80000124:	0e311663          	bne	sp,gp,80000210 <fail>
80000128:	00000193          	li	gp,0
8000012c:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000130:	0e311063          	bne	sp,gp,80000210 <fail>

80000134 <test1>:
80000134:	00100e13          	li	t3,1
80000138:	00000f17          	auipc	t5,0x0
8000013c:	0d8f0f13          	addi	t5,t5,216 # 80000210 <fail>
80000140:	079212b7          	lui	t0,0x7921
80000144:	80828293          	addi	t0,t0,-2040 # 7920808 <_start-0x786df7f8>
80000148:	3a029073          	csrw	pmpcfg0,t0
8000014c:	deadc137          	lui	sp,0xdeadc
80000150:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcd3>
80000154:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
80000158:	00000f17          	auipc	t5,0x0
8000015c:	010f0f13          	addi	t5,t5,16 # 80000168 <test2>
80000160:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000164:	0ac0006f          	j	80000210 <fail>

80000168 <test2>:
80000168:	00200e13          	li	t3,2
8000016c:	00000f17          	auipc	t5,0x0
80000170:	0a4f0f13          	addi	t5,t5,164 # 80000210 <fail>
80000174:	071212b7          	lui	t0,0x7121
80000178:	80828293          	addi	t0,t0,-2040 # 7120808 <_start-0x78edf7f8>
8000017c:	3a029073          	csrw	pmpcfg0,t0
80000180:	deadc137          	lui	sp,0xdeadc
80000184:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcd3>
80000188:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
8000018c:	00000f17          	auipc	t5,0x0
80000190:	010f0f13          	addi	t5,t5,16 # 8000019c <test3>
80000194:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
80000198:	0780006f          	j	80000210 <fail>

8000019c <test3>:
8000019c:	00300e13          	li	t3,3
800001a0:	00000f17          	auipc	t5,0x0
800001a4:	070f0f13          	addi	t5,t5,112 # 80000210 <fail>
800001a8:	00000117          	auipc	sp,0x0
800001ac:	01010113          	addi	sp,sp,16 # 800001b8 <test4>
800001b0:	34111073          	csrw	mepc,sp
800001b4:	30200073          	mret

800001b8 <test4>:
800001b8:	00400e13          	li	t3,4
800001bc:	00000f17          	auipc	t5,0x0
800001c0:	054f0f13          	addi	t5,t5,84 # 80000210 <fail>
800001c4:	deadc137          	lui	sp,0xdeadc
800001c8:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcd3>
800001cc:	00222023          	sw	sp,0(tp) # 0 <_start-0x80000000>
800001d0:	00000f17          	auipc	t5,0x0
800001d4:	010f0f13          	addi	t5,t5,16 # 800001e0 <test5>
800001d8:	00022183          	lw	gp,0(tp) # 0 <_start-0x80000000>
800001dc:	0340006f          	j	80000210 <fail>

800001e0 <test5>:
800001e0:	00500e13          	li	t3,5
800001e4:	deadc137          	lui	sp,0xdeadc
800001e8:	eef10113          	addi	sp,sp,-273 # deadbeef <pass+0x5eadbcd3>
800001ec:	0020a023          	sw	sp,0(ra)
800001f0:	0000a183          	lw	gp,0(ra)
800001f4:	00311e63          	bne	sp,gp,80000210 <fail>

800001f8 <test6>:
800001f8:	00600e13          	li	t3,6
800001fc:	80010237          	lui	tp,0x80010
80000200:	00022183          	lw	gp,0(tp) # 80010000 <pass+0xfde4>
80000204:	00000f17          	auipc	t5,0x0
80000208:	018f0f13          	addi	t5,t5,24 # 8000021c <pass>
8000020c:	00322023          	sw	gp,0(tp) # 0 <_start-0x80000000>

80000210 <fail>:
80000210:	f0100137          	lui	sp,0xf0100
80000214:	f2410113          	addi	sp,sp,-220 # f00fff24 <pass+0x700ffd08>
80000218:	01c12023          	sw	t3,0(sp)

8000021c <pass>:
8000021c:	29a00e13          	li	t3,666
80000220:	f0100137          	lui	sp,0xf0100
80000224:	f2010113          	addi	sp,sp,-224 # f00fff20 <pass+0x700ffd04>
80000228:	00012023          	sw	zero,0(sp)
