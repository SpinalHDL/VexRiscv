
build/smp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	f1402473          	csrr	s0,mhartid
80000004:	f80002b7          	lui	t0,0xf8000
80000008:	f1402373          	csrr	t1,mhartid
8000000c:	01031313          	slli	t1,t1,0x10
80000010:	006282b3          	add	t0,t0,t1
80000014:	0082a023          	sw	s0,0(t0) # f8000000 <barrier_lrsc_value+0x77fffe14>

80000018 <count_thread_start>:
80000018:	00100513          	li	a0,1
8000001c:	00000597          	auipc	a1,0x0
80000020:	1c458593          	addi	a1,a1,452 # 800001e0 <thread_count>
80000024:	00a5a02f          	amoadd.w	zero,a0,(a1)

80000028 <count_thread_wait>:
80000028:	00000417          	auipc	s0,0x0
8000002c:	1b842403          	lw	s0,440(s0) # 800001e0 <thread_count>
80000030:	0c800513          	li	a0,200
80000034:	1a0000ef          	jal	ra,800001d4 <sleep>
80000038:	00000497          	auipc	s1,0x0
8000003c:	1a84a483          	lw	s1,424(s1) # 800001e0 <thread_count>
80000040:	fe8494e3          	bne	s1,s0,80000028 <count_thread_wait>
80000044:	f80002b7          	lui	t0,0xf8000
80000048:	00428293          	addi	t0,t0,4 # f8000004 <barrier_lrsc_value+0x77fffe18>
8000004c:	f1402373          	csrr	t1,mhartid
80000050:	01031313          	slli	t1,t1,0x10
80000054:	006282b3          	add	t0,t0,t1
80000058:	0092a023          	sw	s1,0(t0)

8000005c <barrier_amo_test>:
8000005c:	00100513          	li	a0,1
80000060:	040000ef          	jal	ra,800000a0 <barrier_amo>
80000064:	00200513          	li	a0,2
80000068:	038000ef          	jal	ra,800000a0 <barrier_amo>
8000006c:	00300513          	li	a0,3
80000070:	030000ef          	jal	ra,800000a0 <barrier_amo>
80000074:	00400513          	li	a0,4
80000078:	09c000ef          	jal	ra,80000114 <barrier_lrsc>
8000007c:	00500513          	li	a0,5
80000080:	094000ef          	jal	ra,80000114 <barrier_lrsc>
80000084:	00600513          	li	a0,6
80000088:	08c000ef          	jal	ra,80000114 <barrier_lrsc>
8000008c:	00700513          	li	a0,7
80000090:	010000ef          	jal	ra,800000a0 <barrier_amo>
80000094:	00800513          	li	a0,8
80000098:	07c000ef          	jal	ra,80000114 <barrier_lrsc>
8000009c:	0f40006f          	j	80000190 <success>

800000a0 <barrier_amo>:
800000a0:	f80002b7          	lui	t0,0xf8000
800000a4:	00c28293          	addi	t0,t0,12 # f800000c <barrier_lrsc_value+0x77fffe20>
800000a8:	f1402373          	csrr	t1,mhartid
800000ac:	01031313          	slli	t1,t1,0x10
800000b0:	006282b3          	add	t0,t0,t1
800000b4:	00a2a023          	sw	a0,0(t0)
800000b8:	00000297          	auipc	t0,0x0
800000bc:	13028293          	addi	t0,t0,304 # 800001e8 <barrier_amo_value>
800000c0:	00100313          	li	t1,1
800000c4:	0062a02f          	amoadd.w	zero,t1,(t0)
800000c8:	00000317          	auipc	t1,0x0
800000cc:	11832303          	lw	t1,280(t1) # 800001e0 <thread_count>

800000d0 <barrier_amo_wait>:
800000d0:	0002a383          	lw	t2,0(t0)
800000d4:	fe639ee3          	bne	t2,t1,800000d0 <barrier_amo_wait>
800000d8:	f80002b7          	lui	t0,0xf8000
800000dc:	01028293          	addi	t0,t0,16 # f8000010 <barrier_lrsc_value+0x77fffe24>
800000e0:	f1402373          	csrr	t1,mhartid
800000e4:	01031313          	slli	t1,t1,0x10
800000e8:	006282b3          	add	t0,t0,t1
800000ec:	00a2a023          	sw	a0,0(t0)

800000f0 <barrier_amo_reset>:
800000f0:	f14022f3          	csrr	t0,mhartid
800000f4:	00029863          	bnez	t0,80000104 <barrier_amo_reset_wait>
800000f8:	00000297          	auipc	t0,0x0
800000fc:	0e02a823          	sw	zero,240(t0) # 800001e8 <barrier_amo_value>
80000100:	00008067          	ret

80000104 <barrier_amo_reset_wait>:
80000104:	00000297          	auipc	t0,0x0
80000108:	0e42a283          	lw	t0,228(t0) # 800001e8 <barrier_amo_value>
8000010c:	fe029ce3          	bnez	t0,80000104 <barrier_amo_reset_wait>
80000110:	00008067          	ret

80000114 <barrier_lrsc>:
80000114:	f80002b7          	lui	t0,0xf8000
80000118:	00c28293          	addi	t0,t0,12 # f800000c <barrier_lrsc_value+0x77fffe20>
8000011c:	f1402373          	csrr	t1,mhartid
80000120:	01031313          	slli	t1,t1,0x10
80000124:	006282b3          	add	t0,t0,t1
80000128:	00a2a023          	sw	a0,0(t0)
8000012c:	00000297          	auipc	t0,0x0
80000130:	0c028293          	addi	t0,t0,192 # 800001ec <barrier_lrsc_value>

80000134 <barrier_lrsc_try>:
80000134:	1002a32f          	lr.w	t1,(t0)
80000138:	00130313          	addi	t1,t1,1
8000013c:	1862a32f          	sc.w	t1,t1,(t0)
80000140:	fe031ae3          	bnez	t1,80000134 <barrier_lrsc_try>
80000144:	00000317          	auipc	t1,0x0
80000148:	09c32303          	lw	t1,156(t1) # 800001e0 <thread_count>

8000014c <barrier_lrsc_wait>:
8000014c:	0002a383          	lw	t2,0(t0)
80000150:	fe639ee3          	bne	t2,t1,8000014c <barrier_lrsc_wait>
80000154:	f80002b7          	lui	t0,0xf8000
80000158:	01028293          	addi	t0,t0,16 # f8000010 <barrier_lrsc_value+0x77fffe24>
8000015c:	f1402373          	csrr	t1,mhartid
80000160:	01031313          	slli	t1,t1,0x10
80000164:	006282b3          	add	t0,t0,t1
80000168:	00a2a023          	sw	a0,0(t0)

8000016c <barrier_lrsc_reset>:
8000016c:	f14022f3          	csrr	t0,mhartid
80000170:	00029863          	bnez	t0,80000180 <barrier_lrsc_reset_wait>
80000174:	00000297          	auipc	t0,0x0
80000178:	0602ac23          	sw	zero,120(t0) # 800001ec <barrier_lrsc_value>
8000017c:	00008067          	ret

80000180 <barrier_lrsc_reset_wait>:
80000180:	00000297          	auipc	t0,0x0
80000184:	06c2a283          	lw	t0,108(t0) # 800001ec <barrier_lrsc_value>
80000188:	fe029ce3          	bnez	t0,80000180 <barrier_lrsc_reset_wait>
8000018c:	00008067          	ret

80000190 <success>:
80000190:	00000413          	li	s0,0
80000194:	f80002b7          	lui	t0,0xf8000
80000198:	00828293          	addi	t0,t0,8 # f8000008 <barrier_lrsc_value+0x77fffe1c>
8000019c:	f1402373          	csrr	t1,mhartid
800001a0:	01031313          	slli	t1,t1,0x10
800001a4:	006282b3          	add	t0,t0,t1
800001a8:	0082a023          	sw	s0,0(t0)
800001ac:	0240006f          	j	800001d0 <end>

800001b0 <failure>:
800001b0:	00100413          	li	s0,1
800001b4:	f80002b7          	lui	t0,0xf8000
800001b8:	00828293          	addi	t0,t0,8 # f8000008 <barrier_lrsc_value+0x77fffe1c>
800001bc:	f1402373          	csrr	t1,mhartid
800001c0:	01031313          	slli	t1,t1,0x10
800001c4:	006282b3          	add	t0,t0,t1
800001c8:	0082a023          	sw	s0,0(t0)
800001cc:	0040006f          	j	800001d0 <end>

800001d0 <end>:
800001d0:	0000006f          	j	800001d0 <end>

800001d4 <sleep>:
800001d4:	fff50513          	addi	a0,a0,-1
800001d8:	fe051ee3          	bnez	a0,800001d4 <sleep>
800001dc:	00008067          	ret

800001e0 <thread_count>:
800001e0:	0000                	unimp
	...

800001e4 <shared_memory_1>:
800001e4:	0000                	unimp
	...

800001e8 <barrier_amo_value>:
800001e8:	0000                	unimp
	...

800001ec <barrier_lrsc_value>:
800001ec:	0000                	unimp
	...
