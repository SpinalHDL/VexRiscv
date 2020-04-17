
build/smp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	f1402473          	csrr	s0,mhartid
80000004:	f80002b7          	lui	t0,0xf8000
80000008:	f1402373          	csrr	t1,mhartid
8000000c:	01031313          	slli	t1,t1,0x10
80000010:	006282b3          	add	t0,t0,t1
80000014:	0082a023          	sw	s0,0(t0) # f8000000 <barrier_phase+0x77fffe0c>

80000018 <count_thread_start>:
80000018:	00100513          	li	a0,1
8000001c:	00000597          	auipc	a1,0x0
80000020:	1d058593          	addi	a1,a1,464 # 800001ec <thread_count>
80000024:	00a5a02f          	amoadd.w	zero,a0,(a1)

80000028 <count_thread_wait>:
80000028:	00000417          	auipc	s0,0x0
8000002c:	1c442403          	lw	s0,452(s0) # 800001ec <thread_count>
80000030:	19000513          	li	a0,400
80000034:	1ac000ef          	jal	ra,800001e0 <sleep>
80000038:	00000497          	auipc	s1,0x0
8000003c:	1b44a483          	lw	s1,436(s1) # 800001ec <thread_count>
80000040:	fe8494e3          	bne	s1,s0,80000028 <count_thread_wait>
80000044:	f80002b7          	lui	t0,0xf8000
80000048:	00428293          	addi	t0,t0,4 # f8000004 <barrier_phase+0x77fffe10>
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
80000078:	0a4000ef          	jal	ra,8000011c <barrier_lrsc>
8000007c:	00500513          	li	a0,5
80000080:	09c000ef          	jal	ra,8000011c <barrier_lrsc>
80000084:	00600513          	li	a0,6
80000088:	094000ef          	jal	ra,8000011c <barrier_lrsc>
8000008c:	00700513          	li	a0,7
80000090:	010000ef          	jal	ra,800000a0 <barrier_amo>
80000094:	00800513          	li	a0,8
80000098:	084000ef          	jal	ra,8000011c <barrier_lrsc>
8000009c:	1000006f          	j	8000019c <success>

800000a0 <barrier_amo>:
800000a0:	f80002b7          	lui	t0,0xf8000
800000a4:	00c28293          	addi	t0,t0,12 # f800000c <barrier_phase+0x77fffe18>
800000a8:	f1402373          	csrr	t1,mhartid
800000ac:	01031313          	slli	t1,t1,0x10
800000b0:	006282b3          	add	t0,t0,t1
800000b4:	00a2a023          	sw	a0,0(t0)
800000b8:	00000e97          	auipc	t4,0x0
800000bc:	13ceae83          	lw	t4,316(t4) # 800001f4 <barrier_phase>
800000c0:	00000297          	auipc	t0,0x0
800000c4:	13028293          	addi	t0,t0,304 # 800001f0 <barrier_value>
800000c8:	00100313          	li	t1,1
800000cc:	0062a2af          	amoadd.w	t0,t1,(t0)
800000d0:	00128293          	addi	t0,t0,1
800000d4:	00000317          	auipc	t1,0x0
800000d8:	11832303          	lw	t1,280(t1) # 800001ec <thread_count>
800000dc:	00629c63          	bne	t0,t1,800000f4 <barrier_amo_wait>
800000e0:	001e8293          	addi	t0,t4,1
800000e4:	00000317          	auipc	t1,0x0
800000e8:	10032623          	sw	zero,268(t1) # 800001f0 <barrier_value>
800000ec:	00000317          	auipc	t1,0x0
800000f0:	10532423          	sw	t0,264(t1) # 800001f4 <barrier_phase>

800000f4 <barrier_amo_wait>:
800000f4:	00000297          	auipc	t0,0x0
800000f8:	1002a283          	lw	t0,256(t0) # 800001f4 <barrier_phase>
800000fc:	ffd28ce3          	beq	t0,t4,800000f4 <barrier_amo_wait>
80000100:	f80002b7          	lui	t0,0xf8000
80000104:	01028293          	addi	t0,t0,16 # f8000010 <barrier_phase+0x77fffe1c>
80000108:	f1402373          	csrr	t1,mhartid
8000010c:	01031313          	slli	t1,t1,0x10
80000110:	006282b3          	add	t0,t0,t1
80000114:	00a2a023          	sw	a0,0(t0)
80000118:	00008067          	ret

8000011c <barrier_lrsc>:
8000011c:	f80002b7          	lui	t0,0xf8000
80000120:	00c28293          	addi	t0,t0,12 # f800000c <barrier_phase+0x77fffe18>
80000124:	f1402373          	csrr	t1,mhartid
80000128:	01031313          	slli	t1,t1,0x10
8000012c:	006282b3          	add	t0,t0,t1
80000130:	00a2a023          	sw	a0,0(t0)
80000134:	00000e97          	auipc	t4,0x0
80000138:	0c0eae83          	lw	t4,192(t4) # 800001f4 <barrier_phase>
8000013c:	00000297          	auipc	t0,0x0
80000140:	0b428293          	addi	t0,t0,180 # 800001f0 <barrier_value>

80000144 <barrier_lrsc_try>:
80000144:	1002a32f          	lr.w	t1,(t0)
80000148:	00130313          	addi	t1,t1,1
8000014c:	1862a3af          	sc.w	t2,t1,(t0)
80000150:	fe039ae3          	bnez	t2,80000144 <barrier_lrsc_try>
80000154:	00000297          	auipc	t0,0x0
80000158:	0982a283          	lw	t0,152(t0) # 800001ec <thread_count>
8000015c:	00629c63          	bne	t0,t1,80000174 <barrier_lrsc_wait>
80000160:	001e8293          	addi	t0,t4,1
80000164:	00000317          	auipc	t1,0x0
80000168:	08032623          	sw	zero,140(t1) # 800001f0 <barrier_value>
8000016c:	00000317          	auipc	t1,0x0
80000170:	08532423          	sw	t0,136(t1) # 800001f4 <barrier_phase>

80000174 <barrier_lrsc_wait>:
80000174:	00000297          	auipc	t0,0x0
80000178:	0802a283          	lw	t0,128(t0) # 800001f4 <barrier_phase>
8000017c:	ffd28ce3          	beq	t0,t4,80000174 <barrier_lrsc_wait>
80000180:	f80002b7          	lui	t0,0xf8000
80000184:	01028293          	addi	t0,t0,16 # f8000010 <barrier_phase+0x77fffe1c>
80000188:	f1402373          	csrr	t1,mhartid
8000018c:	01031313          	slli	t1,t1,0x10
80000190:	006282b3          	add	t0,t0,t1
80000194:	00a2a023          	sw	a0,0(t0)
80000198:	00008067          	ret

8000019c <success>:
8000019c:	00000413          	li	s0,0
800001a0:	f80002b7          	lui	t0,0xf8000
800001a4:	00828293          	addi	t0,t0,8 # f8000008 <barrier_phase+0x77fffe14>
800001a8:	f1402373          	csrr	t1,mhartid
800001ac:	01031313          	slli	t1,t1,0x10
800001b0:	006282b3          	add	t0,t0,t1
800001b4:	0082a023          	sw	s0,0(t0)
800001b8:	0240006f          	j	800001dc <end>

800001bc <failure>:
800001bc:	00100413          	li	s0,1
800001c0:	f80002b7          	lui	t0,0xf8000
800001c4:	00828293          	addi	t0,t0,8 # f8000008 <barrier_phase+0x77fffe14>
800001c8:	f1402373          	csrr	t1,mhartid
800001cc:	01031313          	slli	t1,t1,0x10
800001d0:	006282b3          	add	t0,t0,t1
800001d4:	0082a023          	sw	s0,0(t0)
800001d8:	0040006f          	j	800001dc <end>

800001dc <end>:
800001dc:	0000006f          	j	800001dc <end>

800001e0 <sleep>:
800001e0:	fff50513          	addi	a0,a0,-1
800001e4:	fe051ee3          	bnez	a0,800001e0 <sleep>
800001e8:	00008067          	ret

800001ec <thread_count>:
800001ec:	0000                	unimp
	...

800001f0 <barrier_value>:
800001f0:	0000                	unimp
	...

800001f4 <barrier_phase>:
800001f4:	0000                	unimp
	...
