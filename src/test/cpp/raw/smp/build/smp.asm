
build/smp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	f1402a73          	csrr	s4,mhartid
80000004:	00000517          	auipc	a0,0x0
80000008:	07850513          	addi	a0,a0,120 # 8000007c <test1_data>
8000000c:	00000513          	li	a0,0
80000010:	00a52023          	sw	a0,0(a0)

80000014 <count_thread_start>:
80000014:	00100513          	li	a0,1
80000018:	00000597          	auipc	a1,0x0
8000001c:	05c58593          	addi	a1,a1,92 # 80000074 <thread_count>
80000020:	00a5a02f          	amoadd.w	zero,a0,(a1)

80000024 <count_thread_wait>:
80000024:	00000417          	auipc	s0,0x0
80000028:	05042403          	lw	s0,80(s0) # 80000074 <thread_count>
8000002c:	0c800513          	li	a0,200
80000030:	038000ef          	jal	ra,80000068 <sleep>
80000034:	00000497          	auipc	s1,0x0
80000038:	0404a483          	lw	s1,64(s1) # 80000074 <thread_count>
8000003c:	fe8494e3          	bne	s1,s0,80000024 <count_thread_wait>
80000040:	00000513          	li	a0,0
80000044:	00952023          	sw	s1,0(a0)
80000048:	0040006f          	j	8000004c <success>

8000004c <success>:
8000004c:	00800513          	li	a0,8
80000050:	00052023          	sw	zero,0(a0)
80000054:	0100006f          	j	80000064 <end>

80000058 <failure>:
80000058:	00c00513          	li	a0,12
8000005c:	00052023          	sw	zero,0(a0)
80000060:	0040006f          	j	80000064 <end>

80000064 <end>:
80000064:	0000006f          	j	80000064 <end>

80000068 <sleep>:
80000068:	fff50513          	addi	a0,a0,-1
8000006c:	fe051ee3          	bnez	a0,80000068 <sleep>
80000070:	00008067          	ret

80000074 <thread_count>:
80000074:	0000                	unimp
	...

80000078 <shared_memory_1>:
80000078:	0000                	unimp
	...

8000007c <test1_data>:
8000007c:	0000000b          	0xb

80000080 <test2_data>:
80000080:	0016                	c.slli	zero,0x5
	...

80000084 <test3_data>:
80000084:	0049                	c.nop	18
	...

80000088 <test4_data>:
80000088:	003a                	c.slli	zero,0xe
	...

8000008c <test5_data>:
8000008c:	0038                	addi	a4,sp,8
	...

80000090 <test6_data>:
80000090:	0000004b          	fnmsub.s	ft0,ft0,ft0,ft0,rne

80000094 <test7_data>:
80000094:	0038                	addi	a4,sp,8
	...

80000098 <test8_data>:
80000098:	00000053          	fadd.s	ft0,ft0,ft0,rne

8000009c <test9_data>:
8000009c:	0021                	c.nop	8
	...

800000a0 <test10_data>:
800000a0:	ffffffbf  	0xffffffbf

800000a4 <test11_data>:
800000a4:	ffa9                	bnez	a5,7ffffffe <_start-0x2>
800000a6:	ffff                	0xffff

800000a8 <test12_data>:
800000a8:	ffc9                	bnez	a5,80000042 <count_thread_wait+0x1e>
800000aa:	ffff                	0xffff

800000ac <test13_data>:
800000ac:	0004                	0x4
800000ae:	ffff                	0xffff

800000b0 <test14_data>:
800000b0:	0005                	c.nop	1
800000b2:	ffff                	0xffff
