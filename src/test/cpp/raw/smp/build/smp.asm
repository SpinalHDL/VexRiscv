
build/smp.elf:     file format elf32-littleriscv


Disassembly of section .crt_section:

80000000 <_start>:
80000000:	f1402473          	csrr	s0,mhartid
80000004:	f80002b7          	lui	t0,0xf8000
80000008:	f1402373          	csrr	t1,mhartid
8000000c:	01031313          	slli	t1,t1,0x10
80000010:	006282b3          	add	t0,t0,t1
80000014:	0082a023          	sw	s0,0(t0) # f8000000 <consistancy_a_readed+0x77fffbbc>

80000018 <count_thread_start>:
80000018:	00100513          	li	a0,1
8000001c:	00000597          	auipc	a1,0x0
80000020:	36058593          	addi	a1,a1,864 # 8000037c <thread_count>
80000024:	00a5a02f          	amoadd.w	zero,a0,(a1)

80000028 <count_thread_wait>:
80000028:	00000417          	auipc	s0,0x0
8000002c:	35442403          	lw	s0,852(s0) # 8000037c <thread_count>
80000030:	19000513          	li	a0,400
80000034:	33c000ef          	jal	ra,80000370 <sleep>
80000038:	00000497          	auipc	s1,0x0
8000003c:	3444a483          	lw	s1,836(s1) # 8000037c <thread_count>
80000040:	fe8494e3          	bne	s1,s0,80000028 <count_thread_wait>
80000044:	f80002b7          	lui	t0,0xf8000
80000048:	00428293          	addi	t0,t0,4 # f8000004 <consistancy_a_readed+0x77fffbc0>
8000004c:	f1402373          	csrr	t1,mhartid
80000050:	01031313          	slli	t1,t1,0x10
80000054:	006282b3          	add	t0,t0,t1
80000058:	0092a023          	sw	s1,0(t0)

8000005c <barrier_amo_test>:
8000005c:	00100513          	li	a0,1
80000060:	1d0000ef          	jal	ra,80000230 <barrier_amo>
80000064:	00200513          	li	a0,2
80000068:	1c8000ef          	jal	ra,80000230 <barrier_amo>
8000006c:	00300513          	li	a0,3
80000070:	1c0000ef          	jal	ra,80000230 <barrier_amo>
80000074:	00400513          	li	a0,4
80000078:	234000ef          	jal	ra,800002ac <barrier_lrsc>
8000007c:	00500513          	li	a0,5
80000080:	22c000ef          	jal	ra,800002ac <barrier_lrsc>
80000084:	00600513          	li	a0,6
80000088:	224000ef          	jal	ra,800002ac <barrier_lrsc>
8000008c:	00700513          	li	a0,7
80000090:	1a0000ef          	jal	ra,80000230 <barrier_amo>
80000094:	00800513          	li	a0,8
80000098:	214000ef          	jal	ra,800002ac <barrier_lrsc>
8000009c:	00000197          	auipc	gp,0x0
800000a0:	2ec1a183          	lw	gp,748(gp) # 80000388 <barrier_allocator>

800000a4 <consistancy_loop>:
800000a4:	00018513          	mv	a0,gp
800000a8:	00118193          	addi	gp,gp,1
800000ac:	200000ef          	jal	ra,800002ac <barrier_lrsc>
800000b0:	00000297          	auipc	t0,0x0
800000b4:	2e42a283          	lw	t0,740(t0) # 80000394 <consistancy_all_tested>
800000b8:	00a00313          	li	t1,10
800000bc:	1662d863          	bge	t0,t1,8000022c <consistancy_passed>
800000c0:	00000297          	auipc	t0,0x0
800000c4:	2cc2a283          	lw	t0,716(t0) # 8000038c <consistancy_a_hart>
800000c8:	00000317          	auipc	t1,0x0
800000cc:	2c832303          	lw	t1,712(t1) # 80000390 <consistancy_b_hart>
800000d0:	06628a63          	beq	t0,t1,80000144 <consistancy_join>
800000d4:	f14022f3          	csrr	t0,mhartid
800000d8:	00000317          	auipc	t1,0x0
800000dc:	2b432303          	lw	t1,692(t1) # 8000038c <consistancy_a_hart>
800000e0:	00000417          	auipc	s0,0x0
800000e4:	32040413          	addi	s0,s0,800 # 80000400 <consistancy_a_value>
800000e8:	00000497          	auipc	s1,0x0
800000ec:	31c48493          	addi	s1,s1,796 # 80000404 <consistancy_b_value>
800000f0:	02628863          	beq	t0,t1,80000120 <consistancy_do>
800000f4:	00000317          	auipc	t1,0x0
800000f8:	29c32303          	lw	t1,668(t1) # 80000390 <consistancy_b_hart>
800000fc:	00000417          	auipc	s0,0x0
80000100:	30840413          	addi	s0,s0,776 # 80000404 <consistancy_b_value>
80000104:	00000497          	auipc	s1,0x0
80000108:	2fc48493          	addi	s1,s1,764 # 80000400 <consistancy_a_value>
8000010c:	00628a63          	beq	t0,t1,80000120 <consistancy_do>

80000110 <consistancy_hart_not_involved>:
80000110:	00018513          	mv	a0,gp
80000114:	00118193          	addi	gp,gp,1
80000118:	194000ef          	jal	ra,800002ac <barrier_lrsc>
8000011c:	0280006f          	j	80000144 <consistancy_join>

80000120 <consistancy_do>:
80000120:	29a00913          	li	s2,666
80000124:	00018513          	mv	a0,gp
80000128:	00118193          	addi	gp,gp,1
8000012c:	0004a983          	lw	s3,0(s1)
80000130:	17c000ef          	jal	ra,800002ac <barrier_lrsc>
80000134:	01242023          	sw	s2,0(s0)
80000138:	0120000f          	fence	w,r
8000013c:	0004a983          	lw	s3,0(s1)
80000140:	05342023          	sw	s3,64(s0)

80000144 <consistancy_join>:
80000144:	0330000f          	fence	rw,rw
80000148:	00018513          	mv	a0,gp
8000014c:	00118193          	addi	gp,gp,1
80000150:	15c000ef          	jal	ra,800002ac <barrier_lrsc>
80000154:	f14022f3          	csrr	t0,mhartid
80000158:	f40296e3          	bnez	t0,800000a4 <consistancy_loop>

8000015c <consistancy_assert>:
8000015c:	00000297          	auipc	t0,0x0
80000160:	2302a283          	lw	t0,560(t0) # 8000038c <consistancy_a_hart>
80000164:	00000317          	auipc	t1,0x0
80000168:	22c32303          	lw	t1,556(t1) # 80000390 <consistancy_b_hart>
8000016c:	04628263          	beq	t0,t1,800001b0 <consistancy_increment>
80000170:	00000517          	auipc	a0,0x0
80000174:	2d452503          	lw	a0,724(a0) # 80000444 <consistancy_a_readed>
80000178:	f80002b7          	lui	t0,0xf8000
8000017c:	01428293          	addi	t0,t0,20 # f8000014 <consistancy_a_readed+0x77fffbd0>
80000180:	f1402373          	csrr	t1,mhartid
80000184:	01031313          	slli	t1,t1,0x10
80000188:	006282b3          	add	t0,t0,t1
8000018c:	00a2a023          	sw	a0,0(t0)
80000190:	00000517          	auipc	a0,0x0
80000194:	2b052503          	lw	a0,688(a0) # 80000440 <consistancy_b_readed>
80000198:	f80002b7          	lui	t0,0xf8000
8000019c:	01428293          	addi	t0,t0,20 # f8000014 <consistancy_a_readed+0x77fffbd0>
800001a0:	f1402373          	csrr	t1,mhartid
800001a4:	01031313          	slli	t1,t1,0x10
800001a8:	006282b3          	add	t0,t0,t1
800001ac:	00a2a023          	sw	a0,0(t0)

800001b0 <consistancy_increment>:
800001b0:	f14022f3          	csrr	t0,mhartid
800001b4:	ee0298e3          	bnez	t0,800000a4 <consistancy_loop>
800001b8:	00000297          	auipc	t0,0x0
800001bc:	2402a423          	sw	zero,584(t0) # 80000400 <consistancy_a_value>
800001c0:	00000297          	auipc	t0,0x0
800001c4:	2402a223          	sw	zero,580(t0) # 80000404 <consistancy_b_value>
800001c8:	00000417          	auipc	s0,0x0
800001cc:	1b442403          	lw	s0,436(s0) # 8000037c <thread_count>
800001d0:	00000297          	auipc	t0,0x0
800001d4:	1c02a283          	lw	t0,448(t0) # 80000390 <consistancy_b_hart>
800001d8:	00128293          	addi	t0,t0,1
800001dc:	00000317          	auipc	t1,0x0
800001e0:	1a532a23          	sw	t0,436(t1) # 80000390 <consistancy_b_hart>
800001e4:	04829063          	bne	t0,s0,80000224 <consistancy_increment_fence>
800001e8:	00000317          	auipc	t1,0x0
800001ec:	1a032423          	sw	zero,424(t1) # 80000390 <consistancy_b_hart>
800001f0:	00000297          	auipc	t0,0x0
800001f4:	19c2a283          	lw	t0,412(t0) # 8000038c <consistancy_a_hart>
800001f8:	00128293          	addi	t0,t0,1
800001fc:	00000317          	auipc	t1,0x0
80000200:	18532823          	sw	t0,400(t1) # 8000038c <consistancy_a_hart>
80000204:	02829063          	bne	t0,s0,80000224 <consistancy_increment_fence>
80000208:	00000317          	auipc	t1,0x0
8000020c:	18032223          	sw	zero,388(t1) # 8000038c <consistancy_a_hart>
80000210:	00000297          	auipc	t0,0x0
80000214:	1842a283          	lw	t0,388(t0) # 80000394 <consistancy_all_tested>
80000218:	00128293          	addi	t0,t0,1
8000021c:	00000317          	auipc	t1,0x0
80000220:	16532c23          	sw	t0,376(t1) # 80000394 <consistancy_all_tested>

80000224 <consistancy_increment_fence>:
80000224:	0130000f          	fence	w,rw
80000228:	e7dff06f          	j	800000a4 <consistancy_loop>

8000022c <consistancy_passed>:
8000022c:	1000006f          	j	8000032c <success>

80000230 <barrier_amo>:
80000230:	f80002b7          	lui	t0,0xf8000
80000234:	00c28293          	addi	t0,t0,12 # f800000c <consistancy_a_readed+0x77fffbc8>
80000238:	f1402373          	csrr	t1,mhartid
8000023c:	01031313          	slli	t1,t1,0x10
80000240:	006282b3          	add	t0,t0,t1
80000244:	00a2a023          	sw	a0,0(t0)
80000248:	00000e97          	auipc	t4,0x0
8000024c:	13ceae83          	lw	t4,316(t4) # 80000384 <barrier_phase>
80000250:	00000297          	auipc	t0,0x0
80000254:	13028293          	addi	t0,t0,304 # 80000380 <barrier_value>
80000258:	00100313          	li	t1,1
8000025c:	0062a2af          	amoadd.w	t0,t1,(t0)
80000260:	00128293          	addi	t0,t0,1
80000264:	00000317          	auipc	t1,0x0
80000268:	11832303          	lw	t1,280(t1) # 8000037c <thread_count>
8000026c:	00629c63          	bne	t0,t1,80000284 <barrier_amo_wait>
80000270:	001e8293          	addi	t0,t4,1
80000274:	00000317          	auipc	t1,0x0
80000278:	10032623          	sw	zero,268(t1) # 80000380 <barrier_value>
8000027c:	00000317          	auipc	t1,0x0
80000280:	10532423          	sw	t0,264(t1) # 80000384 <barrier_phase>

80000284 <barrier_amo_wait>:
80000284:	00000297          	auipc	t0,0x0
80000288:	1002a283          	lw	t0,256(t0) # 80000384 <barrier_phase>
8000028c:	ffd28ce3          	beq	t0,t4,80000284 <barrier_amo_wait>
80000290:	f80002b7          	lui	t0,0xf8000
80000294:	01028293          	addi	t0,t0,16 # f8000010 <consistancy_a_readed+0x77fffbcc>
80000298:	f1402373          	csrr	t1,mhartid
8000029c:	01031313          	slli	t1,t1,0x10
800002a0:	006282b3          	add	t0,t0,t1
800002a4:	00a2a023          	sw	a0,0(t0)
800002a8:	00008067          	ret

800002ac <barrier_lrsc>:
800002ac:	f80002b7          	lui	t0,0xf8000
800002b0:	00c28293          	addi	t0,t0,12 # f800000c <consistancy_a_readed+0x77fffbc8>
800002b4:	f1402373          	csrr	t1,mhartid
800002b8:	01031313          	slli	t1,t1,0x10
800002bc:	006282b3          	add	t0,t0,t1
800002c0:	00a2a023          	sw	a0,0(t0)
800002c4:	00000e97          	auipc	t4,0x0
800002c8:	0c0eae83          	lw	t4,192(t4) # 80000384 <barrier_phase>
800002cc:	00000297          	auipc	t0,0x0
800002d0:	0b428293          	addi	t0,t0,180 # 80000380 <barrier_value>

800002d4 <barrier_lrsc_try>:
800002d4:	1002a32f          	lr.w	t1,(t0)
800002d8:	00130313          	addi	t1,t1,1
800002dc:	1862a3af          	sc.w	t2,t1,(t0)
800002e0:	fe039ae3          	bnez	t2,800002d4 <barrier_lrsc_try>
800002e4:	00000297          	auipc	t0,0x0
800002e8:	0982a283          	lw	t0,152(t0) # 8000037c <thread_count>
800002ec:	00629c63          	bne	t0,t1,80000304 <barrier_lrsc_wait>
800002f0:	001e8293          	addi	t0,t4,1
800002f4:	00000317          	auipc	t1,0x0
800002f8:	08032623          	sw	zero,140(t1) # 80000380 <barrier_value>
800002fc:	00000317          	auipc	t1,0x0
80000300:	08532423          	sw	t0,136(t1) # 80000384 <barrier_phase>

80000304 <barrier_lrsc_wait>:
80000304:	00000297          	auipc	t0,0x0
80000308:	0802a283          	lw	t0,128(t0) # 80000384 <barrier_phase>
8000030c:	ffd28ce3          	beq	t0,t4,80000304 <barrier_lrsc_wait>
80000310:	f80002b7          	lui	t0,0xf8000
80000314:	01028293          	addi	t0,t0,16 # f8000010 <consistancy_a_readed+0x77fffbcc>
80000318:	f1402373          	csrr	t1,mhartid
8000031c:	01031313          	slli	t1,t1,0x10
80000320:	006282b3          	add	t0,t0,t1
80000324:	00a2a023          	sw	a0,0(t0)
80000328:	00008067          	ret

8000032c <success>:
8000032c:	00000413          	li	s0,0
80000330:	f80002b7          	lui	t0,0xf8000
80000334:	00828293          	addi	t0,t0,8 # f8000008 <consistancy_a_readed+0x77fffbc4>
80000338:	f1402373          	csrr	t1,mhartid
8000033c:	01031313          	slli	t1,t1,0x10
80000340:	006282b3          	add	t0,t0,t1
80000344:	0082a023          	sw	s0,0(t0)
80000348:	0240006f          	j	8000036c <end>

8000034c <failure>:
8000034c:	00100413          	li	s0,1
80000350:	f80002b7          	lui	t0,0xf8000
80000354:	00828293          	addi	t0,t0,8 # f8000008 <consistancy_a_readed+0x77fffbc4>
80000358:	f1402373          	csrr	t1,mhartid
8000035c:	01031313          	slli	t1,t1,0x10
80000360:	006282b3          	add	t0,t0,t1
80000364:	0082a023          	sw	s0,0(t0)
80000368:	0040006f          	j	8000036c <end>

8000036c <end>:
8000036c:	0000006f          	j	8000036c <end>

80000370 <sleep>:
80000370:	fff50513          	addi	a0,a0,-1
80000374:	fe051ee3          	bnez	a0,80000370 <sleep>
80000378:	00008067          	ret

8000037c <thread_count>:
8000037c:	0000                	unimp
	...

80000380 <barrier_value>:
80000380:	0000                	unimp
	...

80000384 <barrier_phase>:
80000384:	0000                	unimp
	...

80000388 <barrier_allocator>:
80000388:	1000                	addi	s0,sp,32
	...

8000038c <consistancy_a_hart>:
8000038c:	0000                	unimp
	...

80000390 <consistancy_b_hart>:
80000390:	0000                	unimp
	...

80000394 <consistancy_all_tested>:
80000394:	0000                	unimp
80000396:	0000                	unimp
80000398:	00000013          	nop
8000039c:	00000013          	nop
800003a0:	00000013          	nop
800003a4:	00000013          	nop
800003a8:	00000013          	nop
800003ac:	00000013          	nop
800003b0:	00000013          	nop
800003b4:	00000013          	nop
800003b8:	00000013          	nop
800003bc:	00000013          	nop
800003c0:	00000013          	nop
800003c4:	00000013          	nop
800003c8:	00000013          	nop
800003cc:	00000013          	nop
800003d0:	00000013          	nop
800003d4:	00000013          	nop
800003d8:	00000013          	nop
800003dc:	00000013          	nop
800003e0:	00000013          	nop
800003e4:	00000013          	nop
800003e8:	00000013          	nop
800003ec:	00000013          	nop
800003f0:	00000013          	nop
800003f4:	00000013          	nop
800003f8:	00000013          	nop
800003fc:	00000013          	nop

80000400 <consistancy_a_value>:
80000400:	0000                	unimp
	...

80000404 <consistancy_b_value>:
80000404:	0000                	unimp
80000406:	0000                	unimp
80000408:	00000013          	nop
8000040c:	00000013          	nop
80000410:	00000013          	nop
80000414:	00000013          	nop
80000418:	00000013          	nop
8000041c:	00000013          	nop
80000420:	00000013          	nop
80000424:	00000013          	nop
80000428:	00000013          	nop
8000042c:	00000013          	nop
80000430:	00000013          	nop
80000434:	00000013          	nop
80000438:	00000013          	nop
8000043c:	00000013          	nop

80000440 <consistancy_b_readed>:
80000440:	0000                	unimp
	...

80000444 <consistancy_a_readed>:
	...
