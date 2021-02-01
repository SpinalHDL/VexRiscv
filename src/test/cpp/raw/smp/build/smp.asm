
build/smp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	f1402473          	csrr	s0,mhartid
80000004:	f80002b7          	lui	t0,0xf8000
80000008:	f1402373          	csrr	t1,mhartid
8000000c:	01031313          	slli	t1,t1,0x10
80000010:	006282b3          	add	t0,t0,t1
80000014:	0082a023          	sw	s0,0(t0) # f8000000 <consistancy_done_call+0x77fffab8>

80000018 <count_thread_start>:
80000018:	00100513          	li	a0,1
8000001c:	00000597          	auipc	a1,0x0
80000020:	42058593          	addi	a1,a1,1056 # 8000043c <thread_count>
80000024:	00a5a02f          	amoadd.w	zero,a0,(a1)

80000028 <count_thread_wait>:
80000028:	00000417          	auipc	s0,0x0
8000002c:	41442403          	lw	s0,1044(s0) # 8000043c <thread_count>
80000030:	19000513          	li	a0,400
80000034:	3fc000ef          	jal	ra,80000430 <sleep>
80000038:	00000497          	auipc	s1,0x0
8000003c:	4044a483          	lw	s1,1028(s1) # 8000043c <thread_count>
80000040:	fe8494e3          	bne	s1,s0,80000028 <count_thread_wait>
80000044:	f80002b7          	lui	t0,0xf8000
80000048:	00428293          	addi	t0,t0,4 # f8000004 <consistancy_done_call+0x77fffabc>
8000004c:	f1402373          	csrr	t1,mhartid
80000050:	01031313          	slli	t1,t1,0x10
80000054:	006282b3          	add	t0,t0,t1
80000058:	0092a023          	sw	s1,0(t0)

8000005c <barrier_amo_test>:
8000005c:	00100513          	li	a0,1
80000060:	290000ef          	jal	ra,800002f0 <barrier_amo>
80000064:	00200513          	li	a0,2
80000068:	288000ef          	jal	ra,800002f0 <barrier_amo>
8000006c:	00300513          	li	a0,3
80000070:	280000ef          	jal	ra,800002f0 <barrier_amo>
80000074:	00400513          	li	a0,4
80000078:	2f4000ef          	jal	ra,8000036c <barrier_lrsc>
8000007c:	00500513          	li	a0,5
80000080:	2ec000ef          	jal	ra,8000036c <barrier_lrsc>
80000084:	00600513          	li	a0,6
80000088:	2e4000ef          	jal	ra,8000036c <barrier_lrsc>
8000008c:	00700513          	li	a0,7
80000090:	260000ef          	jal	ra,800002f0 <barrier_amo>
80000094:	00800513          	li	a0,8
80000098:	2d4000ef          	jal	ra,8000036c <barrier_lrsc>
8000009c:	00000197          	auipc	gp,0x0
800000a0:	3ac1a183          	lw	gp,940(gp) # 80000448 <barrier_allocator>

800000a4 <consistancy_test1>:
800000a4:	00000297          	auipc	t0,0x0
800000a8:	06828293          	addi	t0,t0,104 # 8000010c <consistancy_init_load>
800000ac:	00000317          	auipc	t1,0x0
800000b0:	48532a23          	sw	t0,1172(t1) # 80000540 <consistancy_init_call>
800000b4:	00000297          	auipc	t0,0x0
800000b8:	06028293          	addi	t0,t0,96 # 80000114 <consistancy_do_simple_fence>
800000bc:	00000317          	auipc	t1,0x0
800000c0:	48532423          	sw	t0,1160(t1) # 80000544 <consistancy_do_call>
800000c4:	00000297          	auipc	t0,0x0
800000c8:	01428293          	addi	t0,t0,20 # 800000d8 <consistancy_test2>
800000cc:	00000317          	auipc	t1,0x0
800000d0:	46532e23          	sw	t0,1148(t1) # 80000548 <consistancy_done_call>
800000d4:	0640006f          	j	80000138 <consistancy_start>

800000d8 <consistancy_test2>:
800000d8:	00000297          	auipc	t0,0x0
800000dc:	03428293          	addi	t0,t0,52 # 8000010c <consistancy_init_load>
800000e0:	00000317          	auipc	t1,0x0
800000e4:	46532023          	sw	t0,1120(t1) # 80000540 <consistancy_init_call>
800000e8:	00000297          	auipc	t0,0x0
800000ec:	04028293          	addi	t0,t0,64 # 80000128 <consistancy_do_rl_fence>
800000f0:	00000317          	auipc	t1,0x0
800000f4:	44532a23          	sw	t0,1108(t1) # 80000544 <consistancy_do_call>
800000f8:	00000297          	auipc	t0,0x0
800000fc:	2f428293          	addi	t0,t0,756 # 800003ec <success>
80000100:	00000317          	auipc	t1,0x0
80000104:	44532423          	sw	t0,1096(t1) # 80000548 <consistancy_done_call>
80000108:	0300006f          	j	80000138 <consistancy_start>

8000010c <consistancy_init_load>:
8000010c:	0004a983          	lw	s3,0(s1)
80000110:	0c40006f          	j	800001d4 <consistancy_do_init_done>

80000114 <consistancy_do_simple_fence>:
80000114:	01242023          	sw	s2,0(s0)
80000118:	0120000f          	fence	w,r
8000011c:	0004a983          	lw	s3,0(s1)
80000120:	05342023          	sw	s3,64(s0)
80000124:	0cc0006f          	j	800001f0 <consistancy_join>

80000128 <consistancy_do_rl_fence>:
80000128:	01242023          	sw	s2,0(s0)
8000012c:	1204a9af          	lr.w.rl	s3,(s1)
80000130:	05342023          	sw	s3,64(s0)
80000134:	0bc0006f          	j	800001f0 <consistancy_join>

80000138 <consistancy_start>:
80000138:	00018513          	mv	a0,gp
8000013c:	00118193          	addi	gp,gp,1
80000140:	22c000ef          	jal	ra,8000036c <barrier_lrsc>
80000144:	00000297          	auipc	t0,0x0
80000148:	3002a823          	sw	zero,784(t0) # 80000454 <consistancy_all_tested>

8000014c <consistancy_loop>:
8000014c:	00018513          	mv	a0,gp
80000150:	00118193          	addi	gp,gp,1
80000154:	218000ef          	jal	ra,8000036c <barrier_lrsc>
80000158:	00000297          	auipc	t0,0x0
8000015c:	2fc2a283          	lw	t0,764(t0) # 80000454 <consistancy_all_tested>
80000160:	03200313          	li	t1,50
80000164:	1662da63          	bge	t0,t1,800002d8 <consistancy_passed>
80000168:	00000297          	auipc	t0,0x0
8000016c:	2e42a283          	lw	t0,740(t0) # 8000044c <consistancy_a_hart>
80000170:	00000317          	auipc	t1,0x0
80000174:	2e032303          	lw	t1,736(t1) # 80000450 <consistancy_b_hart>
80000178:	06628c63          	beq	t0,t1,800001f0 <consistancy_join>
8000017c:	f14022f3          	csrr	t0,mhartid
80000180:	00000317          	auipc	t1,0x0
80000184:	2cc32303          	lw	t1,716(t1) # 8000044c <consistancy_a_hart>
80000188:	00000417          	auipc	s0,0x0
8000018c:	33840413          	addi	s0,s0,824 # 800004c0 <consistancy_a_value>
80000190:	00000497          	auipc	s1,0x0
80000194:	33448493          	addi	s1,s1,820 # 800004c4 <consistancy_b_value>
80000198:	02628863          	beq	t0,t1,800001c8 <consistancy_do>
8000019c:	00000317          	auipc	t1,0x0
800001a0:	2b432303          	lw	t1,692(t1) # 80000450 <consistancy_b_hart>
800001a4:	00000417          	auipc	s0,0x0
800001a8:	32040413          	addi	s0,s0,800 # 800004c4 <consistancy_b_value>
800001ac:	00000497          	auipc	s1,0x0
800001b0:	31448493          	addi	s1,s1,788 # 800004c0 <consistancy_a_value>
800001b4:	00628a63          	beq	t0,t1,800001c8 <consistancy_do>

800001b8 <consistancy_hart_not_involved>:
800001b8:	00018513          	mv	a0,gp
800001bc:	00118193          	addi	gp,gp,1
800001c0:	1ac000ef          	jal	ra,8000036c <barrier_lrsc>
800001c4:	02c0006f          	j	800001f0 <consistancy_join>

800001c8 <consistancy_do>:
800001c8:	00000297          	auipc	t0,0x0
800001cc:	3782a283          	lw	t0,888(t0) # 80000540 <consistancy_init_call>
800001d0:	000280e7          	jalr	t0

800001d4 <consistancy_do_init_done>:
800001d4:	29a00913          	li	s2,666
800001d8:	00018513          	mv	a0,gp
800001dc:	00118193          	addi	gp,gp,1
800001e0:	18c000ef          	jal	ra,8000036c <barrier_lrsc>
800001e4:	00000297          	auipc	t0,0x0
800001e8:	3602a283          	lw	t0,864(t0) # 80000544 <consistancy_do_call>
800001ec:	000280e7          	jalr	t0

800001f0 <consistancy_join>:
800001f0:	0330000f          	fence	rw,rw
800001f4:	00018513          	mv	a0,gp
800001f8:	00118193          	addi	gp,gp,1
800001fc:	170000ef          	jal	ra,8000036c <barrier_lrsc>
80000200:	f14022f3          	csrr	t0,mhartid
80000204:	f40294e3          	bnez	t0,8000014c <consistancy_loop>

80000208 <consistancy_assert>:
80000208:	00000297          	auipc	t0,0x0
8000020c:	2442a283          	lw	t0,580(t0) # 8000044c <consistancy_a_hart>
80000210:	00000317          	auipc	t1,0x0
80000214:	24032303          	lw	t1,576(t1) # 80000450 <consistancy_b_hart>
80000218:	04628263          	beq	t0,t1,8000025c <consistancy_increment>
8000021c:	00000517          	auipc	a0,0x0
80000220:	2e852503          	lw	a0,744(a0) # 80000504 <consistancy_a_readed>
80000224:	f80002b7          	lui	t0,0xf8000
80000228:	01428293          	addi	t0,t0,20 # f8000014 <consistancy_done_call+0x77fffacc>
8000022c:	f1402373          	csrr	t1,mhartid
80000230:	01031313          	slli	t1,t1,0x10
80000234:	006282b3          	add	t0,t0,t1
80000238:	00a2a023          	sw	a0,0(t0)
8000023c:	00000517          	auipc	a0,0x0
80000240:	2c452503          	lw	a0,708(a0) # 80000500 <consistancy_b_readed>
80000244:	f80002b7          	lui	t0,0xf8000
80000248:	01428293          	addi	t0,t0,20 # f8000014 <consistancy_done_call+0x77fffacc>
8000024c:	f1402373          	csrr	t1,mhartid
80000250:	01031313          	slli	t1,t1,0x10
80000254:	006282b3          	add	t0,t0,t1
80000258:	00a2a023          	sw	a0,0(t0)

8000025c <consistancy_increment>:
8000025c:	f14022f3          	csrr	t0,mhartid
80000260:	ee0296e3          	bnez	t0,8000014c <consistancy_loop>
80000264:	00000297          	auipc	t0,0x0
80000268:	2402ae23          	sw	zero,604(t0) # 800004c0 <consistancy_a_value>
8000026c:	00000297          	auipc	t0,0x0
80000270:	2402ac23          	sw	zero,600(t0) # 800004c4 <consistancy_b_value>
80000274:	00000417          	auipc	s0,0x0
80000278:	1c842403          	lw	s0,456(s0) # 8000043c <thread_count>
8000027c:	00000297          	auipc	t0,0x0
80000280:	1d42a283          	lw	t0,468(t0) # 80000450 <consistancy_b_hart>
80000284:	00128293          	addi	t0,t0,1
80000288:	00000317          	auipc	t1,0x0
8000028c:	1c532423          	sw	t0,456(t1) # 80000450 <consistancy_b_hart>
80000290:	04829063          	bne	t0,s0,800002d0 <consistancy_increment_fence>
80000294:	00000317          	auipc	t1,0x0
80000298:	1a032e23          	sw	zero,444(t1) # 80000450 <consistancy_b_hart>
8000029c:	00000297          	auipc	t0,0x0
800002a0:	1b02a283          	lw	t0,432(t0) # 8000044c <consistancy_a_hart>
800002a4:	00128293          	addi	t0,t0,1
800002a8:	00000317          	auipc	t1,0x0
800002ac:	1a532223          	sw	t0,420(t1) # 8000044c <consistancy_a_hart>
800002b0:	02829063          	bne	t0,s0,800002d0 <consistancy_increment_fence>
800002b4:	00000317          	auipc	t1,0x0
800002b8:	18032c23          	sw	zero,408(t1) # 8000044c <consistancy_a_hart>
800002bc:	00000297          	auipc	t0,0x0
800002c0:	1982a283          	lw	t0,408(t0) # 80000454 <consistancy_all_tested>
800002c4:	00128293          	addi	t0,t0,1
800002c8:	00000317          	auipc	t1,0x0
800002cc:	18532623          	sw	t0,396(t1) # 80000454 <consistancy_all_tested>

800002d0 <consistancy_increment_fence>:
800002d0:	0130000f          	fence	w,rw
800002d4:	e79ff06f          	j	8000014c <consistancy_loop>

800002d8 <consistancy_passed>:
800002d8:	00000417          	auipc	s0,0x0
800002dc:	27042403          	lw	s0,624(s0) # 80000548 <consistancy_done_call>
800002e0:	00018513          	mv	a0,gp
800002e4:	00118193          	addi	gp,gp,1
800002e8:	084000ef          	jal	ra,8000036c <barrier_lrsc>
800002ec:	000400e7          	jalr	s0

800002f0 <barrier_amo>:
800002f0:	f80002b7          	lui	t0,0xf8000
800002f4:	00c28293          	addi	t0,t0,12 # f800000c <consistancy_done_call+0x77fffac4>
800002f8:	f1402373          	csrr	t1,mhartid
800002fc:	01031313          	slli	t1,t1,0x10
80000300:	006282b3          	add	t0,t0,t1
80000304:	00a2a023          	sw	a0,0(t0)
80000308:	00000e97          	auipc	t4,0x0
8000030c:	13ceae83          	lw	t4,316(t4) # 80000444 <barrier_phase>
80000310:	00000297          	auipc	t0,0x0
80000314:	13028293          	addi	t0,t0,304 # 80000440 <barrier_value>
80000318:	00100313          	li	t1,1
8000031c:	0062a2af          	amoadd.w	t0,t1,(t0)
80000320:	00128293          	addi	t0,t0,1
80000324:	00000317          	auipc	t1,0x0
80000328:	11832303          	lw	t1,280(t1) # 8000043c <thread_count>
8000032c:	00629c63          	bne	t0,t1,80000344 <barrier_amo_wait>
80000330:	001e8293          	addi	t0,t4,1
80000334:	00000317          	auipc	t1,0x0
80000338:	10032623          	sw	zero,268(t1) # 80000440 <barrier_value>
8000033c:	00000317          	auipc	t1,0x0
80000340:	10532423          	sw	t0,264(t1) # 80000444 <barrier_phase>

80000344 <barrier_amo_wait>:
80000344:	00000297          	auipc	t0,0x0
80000348:	1002a283          	lw	t0,256(t0) # 80000444 <barrier_phase>
8000034c:	ffd28ce3          	beq	t0,t4,80000344 <barrier_amo_wait>
80000350:	f80002b7          	lui	t0,0xf8000
80000354:	01028293          	addi	t0,t0,16 # f8000010 <consistancy_done_call+0x77fffac8>
80000358:	f1402373          	csrr	t1,mhartid
8000035c:	01031313          	slli	t1,t1,0x10
80000360:	006282b3          	add	t0,t0,t1
80000364:	00a2a023          	sw	a0,0(t0)
80000368:	00008067          	ret

8000036c <barrier_lrsc>:
8000036c:	f80002b7          	lui	t0,0xf8000
80000370:	00c28293          	addi	t0,t0,12 # f800000c <consistancy_done_call+0x77fffac4>
80000374:	f1402373          	csrr	t1,mhartid
80000378:	01031313          	slli	t1,t1,0x10
8000037c:	006282b3          	add	t0,t0,t1
80000380:	00a2a023          	sw	a0,0(t0)
80000384:	00000e97          	auipc	t4,0x0
80000388:	0c0eae83          	lw	t4,192(t4) # 80000444 <barrier_phase>
8000038c:	00000297          	auipc	t0,0x0
80000390:	0b428293          	addi	t0,t0,180 # 80000440 <barrier_value>

80000394 <barrier_lrsc_try>:
80000394:	1002a32f          	lr.w	t1,(t0)
80000398:	00130313          	addi	t1,t1,1
8000039c:	1862a3af          	sc.w	t2,t1,(t0)
800003a0:	fe039ae3          	bnez	t2,80000394 <barrier_lrsc_try>
800003a4:	00000297          	auipc	t0,0x0
800003a8:	0982a283          	lw	t0,152(t0) # 8000043c <thread_count>
800003ac:	00629c63          	bne	t0,t1,800003c4 <barrier_lrsc_wait>
800003b0:	001e8293          	addi	t0,t4,1
800003b4:	00000317          	auipc	t1,0x0
800003b8:	08032623          	sw	zero,140(t1) # 80000440 <barrier_value>
800003bc:	00000317          	auipc	t1,0x0
800003c0:	08532423          	sw	t0,136(t1) # 80000444 <barrier_phase>

800003c4 <barrier_lrsc_wait>:
800003c4:	00000297          	auipc	t0,0x0
800003c8:	0802a283          	lw	t0,128(t0) # 80000444 <barrier_phase>
800003cc:	ffd28ce3          	beq	t0,t4,800003c4 <barrier_lrsc_wait>
800003d0:	f80002b7          	lui	t0,0xf8000
800003d4:	01028293          	addi	t0,t0,16 # f8000010 <consistancy_done_call+0x77fffac8>
800003d8:	f1402373          	csrr	t1,mhartid
800003dc:	01031313          	slli	t1,t1,0x10
800003e0:	006282b3          	add	t0,t0,t1
800003e4:	00a2a023          	sw	a0,0(t0)
800003e8:	00008067          	ret

800003ec <success>:
800003ec:	00000413          	li	s0,0
800003f0:	f80002b7          	lui	t0,0xf8000
800003f4:	00828293          	addi	t0,t0,8 # f8000008 <consistancy_done_call+0x77fffac0>
800003f8:	f1402373          	csrr	t1,mhartid
800003fc:	01031313          	slli	t1,t1,0x10
80000400:	006282b3          	add	t0,t0,t1
80000404:	0082a023          	sw	s0,0(t0)
80000408:	0240006f          	j	8000042c <end>

8000040c <failure>:
8000040c:	00100413          	li	s0,1
80000410:	f80002b7          	lui	t0,0xf8000
80000414:	00828293          	addi	t0,t0,8 # f8000008 <consistancy_done_call+0x77fffac0>
80000418:	f1402373          	csrr	t1,mhartid
8000041c:	01031313          	slli	t1,t1,0x10
80000420:	006282b3          	add	t0,t0,t1
80000424:	0082a023          	sw	s0,0(t0)
80000428:	0040006f          	j	8000042c <end>

8000042c <end>:
8000042c:	0000006f          	j	8000042c <end>

80000430 <sleep>:
80000430:	fff50513          	addi	a0,a0,-1
80000434:	fe051ee3          	bnez	a0,80000430 <sleep>
80000438:	00008067          	ret

8000043c <thread_count>:
8000043c:	0000                	unimp
	...

80000440 <barrier_value>:
80000440:	0000                	unimp
	...

80000444 <barrier_phase>:
80000444:	0000                	unimp
	...

80000448 <barrier_allocator>:
80000448:	1000                	addi	s0,sp,32
	...

8000044c <consistancy_a_hart>:
8000044c:	0000                	unimp
	...

80000450 <consistancy_b_hart>:
80000450:	0000                	unimp
	...

80000454 <consistancy_all_tested>:
80000454:	0000                	unimp
80000456:	0000                	unimp
80000458:	00000013          	nop
8000045c:	00000013          	nop
80000460:	00000013          	nop
80000464:	00000013          	nop
80000468:	00000013          	nop
8000046c:	00000013          	nop
80000470:	00000013          	nop
80000474:	00000013          	nop
80000478:	00000013          	nop
8000047c:	00000013          	nop
80000480:	00000013          	nop
80000484:	00000013          	nop
80000488:	00000013          	nop
8000048c:	00000013          	nop
80000490:	00000013          	nop
80000494:	00000013          	nop
80000498:	00000013          	nop
8000049c:	00000013          	nop
800004a0:	00000013          	nop
800004a4:	00000013          	nop
800004a8:	00000013          	nop
800004ac:	00000013          	nop
800004b0:	00000013          	nop
800004b4:	00000013          	nop
800004b8:	00000013          	nop
800004bc:	00000013          	nop

800004c0 <consistancy_a_value>:
800004c0:	0000                	unimp
	...

800004c4 <consistancy_b_value>:
800004c4:	0000                	unimp
800004c6:	0000                	unimp
800004c8:	00000013          	nop
800004cc:	00000013          	nop
800004d0:	00000013          	nop
800004d4:	00000013          	nop
800004d8:	00000013          	nop
800004dc:	00000013          	nop
800004e0:	00000013          	nop
800004e4:	00000013          	nop
800004e8:	00000013          	nop
800004ec:	00000013          	nop
800004f0:	00000013          	nop
800004f4:	00000013          	nop
800004f8:	00000013          	nop
800004fc:	00000013          	nop

80000500 <consistancy_b_readed>:
80000500:	0000                	unimp
	...

80000504 <consistancy_a_readed>:
80000504:	0000                	unimp
80000506:	0000                	unimp
80000508:	00000013          	nop
8000050c:	00000013          	nop
80000510:	00000013          	nop
80000514:	00000013          	nop
80000518:	00000013          	nop
8000051c:	00000013          	nop
80000520:	00000013          	nop
80000524:	00000013          	nop
80000528:	00000013          	nop
8000052c:	00000013          	nop
80000530:	00000013          	nop
80000534:	00000013          	nop
80000538:	00000013          	nop
8000053c:	00000013          	nop

80000540 <consistancy_init_call>:
80000540:	0000                	unimp
	...

80000544 <consistancy_do_call>:
80000544:	0000                	unimp
	...

80000548 <consistancy_done_call>:
	...
