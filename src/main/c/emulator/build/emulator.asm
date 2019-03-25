
build/emulator.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
.option push
.option norelax
	la gp, __global_pointer$
.option pop
#endif*/
	la sp, _sp
80000000:	00001117          	auipc	sp,0x1
80000004:	cb010113          	addi	sp,sp,-848 # 80000cb0 <_sp>


	/* Load data section */
	la a0, _data_lma
80000008:	00000517          	auipc	a0,0x0
8000000c:	43450513          	addi	a0,a0,1076 # 8000043c <__init_array_end>
	la a1, _data
80000010:	00000597          	auipc	a1,0x0
80000014:	42c58593          	addi	a1,a1,1068 # 8000043c <__init_array_end>
	la a2, _edata
80000018:	00000617          	auipc	a2,0x0
8000001c:	49860613          	addi	a2,a2,1176 # 800004b0 <__bss_start>
	bgeu a1, a2, 2f
80000020:	00c5fc63          	bleu	a2,a1,80000038 <_start+0x38>
1:
	lw t0, (a0)
80000024:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
80000028:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
8000002c:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
80000030:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
80000034:	fec5e8e3          	bltu	a1,a2,80000024 <_start+0x24>
2:

	/* Clear bss section */
	la a0, __bss_start
80000038:	00000517          	auipc	a0,0x0
8000003c:	47850513          	addi	a0,a0,1144 # 800004b0 <__bss_start>
	la a1, _end
80000040:	00000597          	auipc	a1,0x0
80000044:	47058593          	addi	a1,a1,1136 # 800004b0 <__bss_start>
	bgeu a0, a1, 2f
80000048:	00b57863          	bleu	a1,a0,80000058 <_start+0x58>
1:
	sw zero, (a0)
8000004c:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
80000050:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
80000054:	feb56ce3          	bltu	a0,a1,8000004c <_start+0x4c>
2:

	call __libc_init_array
80000058:	34c000ef          	jal	ra,800003a4 <__libc_init_array>
	call init
8000005c:	128000ef          	jal	ra,80000184 <init>
	la ra, done
80000060:	00000097          	auipc	ra,0x0
80000064:	01408093          	addi	ra,ra,20 # 80000074 <done>
	li a0, DTB
80000068:	81000537          	lui	a0,0x81000
	li a1, 0
8000006c:	00000593          	li	a1,0
	mret
80000070:	30200073          	mret

80000074 <done>:
done:
    j done
80000074:	0000006f          	j	80000074 <done>

80000078 <_init>:


	.globl _init
_init:
    ret
80000078:	00008067          	ret

8000007c <trapEntry>:
    .section .init
    .globl trapEntry
    .type trapEntry,@function

trapEntry:
	csrrw sp, mscratch, sp
8000007c:	34011173          	csrrw	sp,mscratch,sp
	sw x0,   0*4(sp)
80000080:	00012023          	sw	zero,0(sp)
	sw x1,   1*4(sp)
80000084:	00112223          	sw	ra,4(sp)
	sw x3,   3*4(sp)
80000088:	00312623          	sw	gp,12(sp)
	sw x4,   4*4(sp)
8000008c:	00412823          	sw	tp,16(sp)
	sw x5,   5*4(sp)
80000090:	00512a23          	sw	t0,20(sp)
	sw x6,   6*4(sp)
80000094:	00612c23          	sw	t1,24(sp)
	sw x7,   7*4(sp)
80000098:	00712e23          	sw	t2,28(sp)
	sw x8,   8*4(sp)
8000009c:	02812023          	sw	s0,32(sp)
	sw x9,   9*4(sp)
800000a0:	02912223          	sw	s1,36(sp)
	sw x10,   10*4(sp)
800000a4:	02a12423          	sw	a0,40(sp)
	sw x11,   11*4(sp)
800000a8:	02b12623          	sw	a1,44(sp)
	sw x12,   12*4(sp)
800000ac:	02c12823          	sw	a2,48(sp)
	sw x13,   13*4(sp)
800000b0:	02d12a23          	sw	a3,52(sp)
	sw x14,   14*4(sp)
800000b4:	02e12c23          	sw	a4,56(sp)
	sw x15,   15*4(sp)
800000b8:	02f12e23          	sw	a5,60(sp)
	sw x16,   16*4(sp)
800000bc:	05012023          	sw	a6,64(sp)
	sw x17,   17*4(sp)
800000c0:	05112223          	sw	a7,68(sp)
	sw x18,   18*4(sp)
800000c4:	05212423          	sw	s2,72(sp)
	sw x19,   19*4(sp)
800000c8:	05312623          	sw	s3,76(sp)
	sw x20,   20*4(sp)
800000cc:	05412823          	sw	s4,80(sp)
	sw x21,   21*4(sp)
800000d0:	05512a23          	sw	s5,84(sp)
	sw x22,   22*4(sp)
800000d4:	05612c23          	sw	s6,88(sp)
	sw x23,   23*4(sp)
800000d8:	05712e23          	sw	s7,92(sp)
	sw x24,   24*4(sp)
800000dc:	07812023          	sw	s8,96(sp)
	sw x25,   25*4(sp)
800000e0:	07912223          	sw	s9,100(sp)
	sw x26,   26*4(sp)
800000e4:	07a12423          	sw	s10,104(sp)
	sw x27,   27*4(sp)
800000e8:	07b12623          	sw	s11,108(sp)
	sw x28,   28*4(sp)
800000ec:	07c12823          	sw	t3,112(sp)
	sw x29,   29*4(sp)
800000f0:	07d12a23          	sw	t4,116(sp)
	sw x30,   30*4(sp)
800000f4:	07e12c23          	sw	t5,120(sp)
	sw x31,   31*4(sp)
800000f8:	07f12e23          	sw	t6,124(sp)
	call trap
800000fc:	134000ef          	jal	ra,80000230 <trap>
	lw x0,   0*4(sp)
80000100:	00012003          	lw	zero,0(sp)
	lw x1,   1*4(sp)
80000104:	00412083          	lw	ra,4(sp)
	lw x3,   3*4(sp)
80000108:	00c12183          	lw	gp,12(sp)
	lw x4,   4*4(sp)
8000010c:	01012203          	lw	tp,16(sp)
	lw x5,   5*4(sp)
80000110:	01412283          	lw	t0,20(sp)
	lw x6,   6*4(sp)
80000114:	01812303          	lw	t1,24(sp)
	lw x7,   7*4(sp)
80000118:	01c12383          	lw	t2,28(sp)
	lw x8,   8*4(sp)
8000011c:	02012403          	lw	s0,32(sp)
	lw x9,   9*4(sp)
80000120:	02412483          	lw	s1,36(sp)
	lw x10,   10*4(sp)
80000124:	02812503          	lw	a0,40(sp)
	lw x11,   11*4(sp)
80000128:	02c12583          	lw	a1,44(sp)
	lw x12,   12*4(sp)
8000012c:	03012603          	lw	a2,48(sp)
	lw x13,   13*4(sp)
80000130:	03412683          	lw	a3,52(sp)
	lw x14,   14*4(sp)
80000134:	03812703          	lw	a4,56(sp)
	lw x15,   15*4(sp)
80000138:	03c12783          	lw	a5,60(sp)
	lw x16,   16*4(sp)
8000013c:	04012803          	lw	a6,64(sp)
	lw x17,   17*4(sp)
80000140:	04412883          	lw	a7,68(sp)
	lw x18,   18*4(sp)
80000144:	04812903          	lw	s2,72(sp)
	lw x19,   19*4(sp)
80000148:	04c12983          	lw	s3,76(sp)
	lw x20,   20*4(sp)
8000014c:	05012a03          	lw	s4,80(sp)
	lw x21,   21*4(sp)
80000150:	05412a83          	lw	s5,84(sp)
	lw x22,   22*4(sp)
80000154:	05812b03          	lw	s6,88(sp)
	lw x23,   23*4(sp)
80000158:	05c12b83          	lw	s7,92(sp)
	lw x24,   24*4(sp)
8000015c:	06012c03          	lw	s8,96(sp)
	lw x25,   25*4(sp)
80000160:	06412c83          	lw	s9,100(sp)
	lw x26,   26*4(sp)
80000164:	06812d03          	lw	s10,104(sp)
	lw x27,   27*4(sp)
80000168:	06c12d83          	lw	s11,108(sp)
	lw x28,   28*4(sp)
8000016c:	07012e03          	lw	t3,112(sp)
	lw x29,   29*4(sp)
80000170:	07412e83          	lw	t4,116(sp)
	lw x30,   30*4(sp)
80000174:	07812f03          	lw	t5,120(sp)
	lw x31,   31*4(sp)
80000178:	07c12f83          	lw	t6,124(sp)
	csrrw sp, mscratch, sp
8000017c:	34011173          	csrrw	sp,mscratch,sp
	mret
80000180:	30200073          	mret

Disassembly of section .text:

80000184 <init>:

extern const unsigned int _sp;
extern void trapEntry();

void init() {
	csr_write(mtvec, trapEntry);
80000184:	800007b7          	lui	a5,0x80000
80000188:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff3cc>
8000018c:	30579073          	csrw	mtvec,a5

    unsigned int sp = (unsigned int) (&_sp);
80000190:	800017b7          	lui	a5,0x80001
80000194:	cb078793          	addi	a5,a5,-848 # 80000cb0 <_sp+0x0>
	csr_write(mscratch, sp -32*4);
80000198:	f8078793          	addi	a5,a5,-128
8000019c:	34079073          	csrw	mscratch,a5
	csr_write(mstatus, 0x0800);
800001a0:	000017b7          	lui	a5,0x1
800001a4:	80078793          	addi	a5,a5,-2048 # 800 <__stack_size>
800001a8:	30079073          	csrw	mstatus,a5
	csr_write(mepc, OS_CALL);
800001ac:	c00007b7          	lui	a5,0xc0000
800001b0:	34179073          	csrw	mepc,a5
	csr_write(medeleg, MDELEG_INSTRUCTION_PAGE_FAULT | MDELEG_LOAD_PAGE_FAULT | MDELEG_STORE_PAGE_FAULT);
800001b4:	0000b7b7          	lui	a5,0xb
800001b8:	30279073          	csrw	medeleg,a5
}
800001bc:	00008067          	ret

800001c0 <readRegister>:

int readRegister(int id){
    unsigned int sp = (unsigned int) (&_sp);
	return ((int*) sp)[id-32];
800001c0:	00251513          	slli	a0,a0,0x2
800001c4:	800017b7          	lui	a5,0x80001
800001c8:	cb078793          	addi	a5,a5,-848 # 80000cb0 <_sp+0x0>
800001cc:	00f50533          	add	a0,a0,a5
}
800001d0:	f8052503          	lw	a0,-128(a0) # 80ffff80 <_sp+0xfff2d0>
800001d4:	00008067          	ret

800001d8 <writeRegister>:
void writeRegister(int id, int value){
    unsigned int sp = (unsigned int) (&_sp);
	((int*) sp)[id-32] = value;
800001d8:	00251513          	slli	a0,a0,0x2
800001dc:	800017b7          	lui	a5,0x80001
800001e0:	cb078793          	addi	a5,a5,-848 # 80000cb0 <_sp+0x0>
800001e4:	00f50533          	add	a0,a0,a5
800001e8:	f8b52023          	sw	a1,-128(a0)
}
800001ec:	00008067          	ret

800001f0 <stopSim>:


void stopSim(){
	*((volatile int*) SIM_STOP) = 0;
800001f0:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7ffff34c>
}
800001f4:	00008067          	ret

800001f8 <putC>:

void putC(char c){
	*((volatile int*) PUTC) = c;
800001f8:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7ffff348>
}
800001fc:	00008067          	ret

80000200 <redirectTrap>:


void redirectTrap(){
80000200:	ff010113          	addi	sp,sp,-16
80000204:	00112623          	sw	ra,12(sp)
	stopSim();
80000208:	fe9ff0ef          	jal	ra,800001f0 <stopSim>
	csr_write(sbadaddr, csr_read(mbadaddr));
8000020c:	343027f3          	csrr	a5,mbadaddr
80000210:	14379073          	csrw	sbadaddr,a5
	csr_write(sepc,     csr_read(mepc));
80000214:	341027f3          	csrr	a5,mepc
80000218:	14179073          	csrw	sepc,a5
	csr_write(scause,   csr_read(mcause));
8000021c:	342027f3          	csrr	a5,mcause
80000220:	14279073          	csrw	scause,a5
}
80000224:	00c12083          	lw	ra,12(sp)
80000228:	01010113          	addi	sp,sp,16
8000022c:	00008067          	ret

80000230 <trap>:
#define min(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; })

void trap(){
80000230:	fe010113          	addi	sp,sp,-32
80000234:	00112e23          	sw	ra,28(sp)
80000238:	00812c23          	sw	s0,24(sp)
8000023c:	00912a23          	sw	s1,20(sp)
80000240:	01212823          	sw	s2,16(sp)
80000244:	01312623          	sw	s3,12(sp)
	int cause = csr_read(mcause);
80000248:	342027f3          	csrr	a5,mcause
	if(cause < 0){
8000024c:	0207ca63          	bltz	a5,80000280 <trap+0x50>
		redirectTrap();
	} else {
		switch(cause){
80000250:	00200713          	li	a4,2
80000254:	02e78a63          	beq	a5,a4,80000288 <trap+0x58>
80000258:	00900713          	li	a4,9
8000025c:	10e78863          	beq	a5,a4,8000036c <trap+0x13c>
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			default: stopSim(); break;
			}
		}break;
		default: redirectTrap(); break;
80000260:	fa1ff0ef          	jal	ra,80000200 <redirectTrap>
		}
	}

}
80000264:	01c12083          	lw	ra,28(sp)
80000268:	01812403          	lw	s0,24(sp)
8000026c:	01412483          	lw	s1,20(sp)
80000270:	01012903          	lw	s2,16(sp)
80000274:	00c12983          	lw	s3,12(sp)
80000278:	02010113          	addi	sp,sp,32
8000027c:	00008067          	ret
		redirectTrap();
80000280:	f81ff0ef          	jal	ra,80000200 <redirectTrap>
80000284:	fe1ff06f          	j	80000264 <trap+0x34>
			int instruction = csr_read(mbadaddr);
80000288:	34302473          	csrr	s0,mbadaddr
			int opcode = instruction & 0x7F;
8000028c:	07f47693          	andi	a3,s0,127
			int funct3 = (instruction >> 12) & 0x7;
80000290:	40c45793          	srai	a5,s0,0xc
80000294:	0077f793          	andi	a5,a5,7
			switch(opcode){
80000298:	02f00713          	li	a4,47
8000029c:	fce694e3          	bne	a3,a4,80000264 <trap+0x34>
				switch(funct3){
800002a0:	00200713          	li	a4,2
800002a4:	0ce79063          	bne	a5,a4,80000364 <trap+0x134>
					int sel = instruction >> 27;
800002a8:	41b45493          	srai	s1,s0,0x1b
					int*addr = (int*)readRegister((instruction >> 15) & 0x1F);
800002ac:	40f45513          	srai	a0,s0,0xf
800002b0:	01f57513          	andi	a0,a0,31
800002b4:	f0dff0ef          	jal	ra,800001c0 <readRegister>
800002b8:	00050993          	mv	s3,a0
					int src = readRegister((instruction >> 20) & 0x1F);
800002bc:	41445513          	srai	a0,s0,0x14
800002c0:	01f57513          	andi	a0,a0,31
800002c4:	efdff0ef          	jal	ra,800001c0 <readRegister>
800002c8:	00050913          	mv	s2,a0
					int rd = (instruction >> 7) & 0x1F;
800002cc:	40745413          	srai	s0,s0,0x7
800002d0:	01f47513          	andi	a0,s0,31
					int readValue = *addr;
800002d4:	0009a583          	lw	a1,0(s3)
					switch(sel){
800002d8:	01c00793          	li	a5,28
800002dc:	0897e063          	bltu	a5,s1,8000035c <trap+0x12c>
800002e0:	00249493          	slli	s1,s1,0x2
800002e4:	800007b7          	lui	a5,0x80000
800002e8:	43c78793          	addi	a5,a5,1084 # 8000043c <_sp+0xfffff78c>
800002ec:	00f484b3          	add	s1,s1,a5
800002f0:	0004a783          	lw	a5,0(s1)
800002f4:	00078067          	jr	a5
					case 0x0:  writeValue = src + readValue; break;
800002f8:	00b90933          	add	s2,s2,a1
					writeRegister(rd, readValue);
800002fc:	eddff0ef          	jal	ra,800001d8 <writeRegister>
					*addr = writeValue;
80000300:	0129a023          	sw	s2,0(s3)
					csr_write(mepc, csr_read(mepc) + 4);
80000304:	341027f3          	csrr	a5,mepc
80000308:	00478793          	addi	a5,a5,4
8000030c:	34179073          	csrw	mepc,a5
				}break;
80000310:	f55ff06f          	j	80000264 <trap+0x34>
					case 0x4:  writeValue = src ^ readValue; break;
80000314:	00b94933          	xor	s2,s2,a1
80000318:	fe5ff06f          	j	800002fc <trap+0xcc>
					case 0xC:  writeValue = src & readValue; break;
8000031c:	00b97933          	and	s2,s2,a1
80000320:	fddff06f          	j	800002fc <trap+0xcc>
					case 0x8:  writeValue = src | readValue; break;
80000324:	00b96933          	or	s2,s2,a1
80000328:	fd5ff06f          	j	800002fc <trap+0xcc>
					case 0x10: writeValue = min(src, readValue); break;
8000032c:	fd25d8e3          	ble	s2,a1,800002fc <trap+0xcc>
80000330:	00058913          	mv	s2,a1
80000334:	fc9ff06f          	j	800002fc <trap+0xcc>
					case 0x14: writeValue = max(src, readValue); break;
80000338:	fcb952e3          	ble	a1,s2,800002fc <trap+0xcc>
8000033c:	00058913          	mv	s2,a1
80000340:	fbdff06f          	j	800002fc <trap+0xcc>
					case 0x18: writeValue = min((unsigned int)src, (unsigned int)readValue); break;
80000344:	fb25fce3          	bleu	s2,a1,800002fc <trap+0xcc>
80000348:	00058913          	mv	s2,a1
8000034c:	fb1ff06f          	j	800002fc <trap+0xcc>
					case 0x1C: writeValue = max((unsigned int)src, (unsigned int)readValue); break;
80000350:	fab976e3          	bleu	a1,s2,800002fc <trap+0xcc>
80000354:	00058913          	mv	s2,a1
80000358:	fa5ff06f          	j	800002fc <trap+0xcc>
					default: redirectTrap(); return; break;
8000035c:	ea5ff0ef          	jal	ra,80000200 <redirectTrap>
80000360:	f05ff06f          	j	80000264 <trap+0x34>
				default: redirectTrap(); break;
80000364:	e9dff0ef          	jal	ra,80000200 <redirectTrap>
80000368:	efdff06f          	j	80000264 <trap+0x34>
			int which = readRegister(17);
8000036c:	01100513          	li	a0,17
80000370:	e51ff0ef          	jal	ra,800001c0 <readRegister>
			switch(which){
80000374:	00100793          	li	a5,1
80000378:	02f51263          	bne	a0,a5,8000039c <trap+0x16c>
				putC(readRegister(10));
8000037c:	00a00513          	li	a0,10
80000380:	e41ff0ef          	jal	ra,800001c0 <readRegister>
80000384:	0ff57513          	andi	a0,a0,255
80000388:	e71ff0ef          	jal	ra,800001f8 <putC>
				csr_write(mepc, csr_read(mepc) + 4);
8000038c:	341027f3          	csrr	a5,mepc
80000390:	00478793          	addi	a5,a5,4
80000394:	34179073          	csrw	mepc,a5
			}break;
80000398:	ecdff06f          	j	80000264 <trap+0x34>
			default: stopSim(); break;
8000039c:	e55ff0ef          	jal	ra,800001f0 <stopSim>
800003a0:	ec5ff06f          	j	80000264 <trap+0x34>

800003a4 <__libc_init_array>:
800003a4:	ff010113          	addi	sp,sp,-16
800003a8:	00812423          	sw	s0,8(sp)
800003ac:	00912223          	sw	s1,4(sp)
800003b0:	00000417          	auipc	s0,0x0
800003b4:	08c40413          	addi	s0,s0,140 # 8000043c <__init_array_end>
800003b8:	00000497          	auipc	s1,0x0
800003bc:	08448493          	addi	s1,s1,132 # 8000043c <__init_array_end>
800003c0:	408484b3          	sub	s1,s1,s0
800003c4:	01212023          	sw	s2,0(sp)
800003c8:	00112623          	sw	ra,12(sp)
800003cc:	4024d493          	srai	s1,s1,0x2
800003d0:	00000913          	li	s2,0
800003d4:	04991063          	bne	s2,s1,80000414 <__libc_init_array+0x70>
800003d8:	00000417          	auipc	s0,0x0
800003dc:	06440413          	addi	s0,s0,100 # 8000043c <__init_array_end>
800003e0:	00000497          	auipc	s1,0x0
800003e4:	05c48493          	addi	s1,s1,92 # 8000043c <__init_array_end>
800003e8:	408484b3          	sub	s1,s1,s0
800003ec:	c8dff0ef          	jal	ra,80000078 <_init>
800003f0:	4024d493          	srai	s1,s1,0x2
800003f4:	00000913          	li	s2,0
800003f8:	02991863          	bne	s2,s1,80000428 <__libc_init_array+0x84>
800003fc:	00c12083          	lw	ra,12(sp)
80000400:	00812403          	lw	s0,8(sp)
80000404:	00412483          	lw	s1,4(sp)
80000408:	00012903          	lw	s2,0(sp)
8000040c:	01010113          	addi	sp,sp,16
80000410:	00008067          	ret
80000414:	00042783          	lw	a5,0(s0)
80000418:	00190913          	addi	s2,s2,1
8000041c:	00440413          	addi	s0,s0,4
80000420:	000780e7          	jalr	a5
80000424:	fb1ff06f          	j	800003d4 <__libc_init_array+0x30>
80000428:	00042783          	lw	a5,0(s0)
8000042c:	00190913          	addi	s2,s2,1
80000430:	00440413          	addi	s0,s0,4
80000434:	000780e7          	jalr	a5
80000438:	fc1ff06f          	j	800003f8 <__libc_init_array+0x54>
