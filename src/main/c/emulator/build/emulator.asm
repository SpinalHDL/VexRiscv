
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
80000004:	dd810113          	addi	sp,sp,-552 # 80000dd8 <_sp>


	/* Load data section */
	la a0, _data_lma
80000008:	00000517          	auipc	a0,0x0
8000000c:	55c50513          	addi	a0,a0,1372 # 80000564 <__init_array_end>
	la a1, _data
80000010:	00000597          	auipc	a1,0x0
80000014:	55458593          	addi	a1,a1,1364 # 80000564 <__init_array_end>
	la a2, _edata
80000018:	00000617          	auipc	a2,0x0
8000001c:	5c060613          	addi	a2,a2,1472 # 800005d8 <__bss_start>
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
8000003c:	5a050513          	addi	a0,a0,1440 # 800005d8 <__bss_start>
	la a1, _end
80000040:	00000597          	auipc	a1,0x0
80000044:	59858593          	addi	a1,a1,1432 # 800005d8 <__bss_start>
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
80000058:	474000ef          	jal	ra,800004cc <__libc_init_array>
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
800000fc:	1e8000ef          	jal	ra,800002e4 <trap>
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
extern void trapEntry();
extern void emulationTrap();

void init() {
    unsigned int sp = (unsigned int) (&_sp);
	csr_write(mtvec, trapEntry);
80000184:	800007b7          	lui	a5,0x80000
80000188:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff2a4>
8000018c:	30579073          	csrw	mtvec,a5
	csr_write(mscratch, sp -32*4);
80000190:	800017b7          	lui	a5,0x80001
80000194:	dd878793          	addi	a5,a5,-552 # 80000dd8 <_sp+0x0>
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
800001c8:	dd878793          	addi	a5,a5,-552 # 80000dd8 <_sp+0x0>
800001cc:	00f50533          	add	a0,a0,a5
}
800001d0:	f8052503          	lw	a0,-128(a0) # 80ffff80 <_sp+0xfff1a8>
800001d4:	00008067          	ret

800001d8 <writeRegister>:
void writeRegister(int id, int value){
    unsigned int sp = (unsigned int) (&_sp);
	((int*) sp)[id-32] = value;
800001d8:	00251513          	slli	a0,a0,0x2
800001dc:	800017b7          	lui	a5,0x80001
800001e0:	dd878793          	addi	a5,a5,-552 # 80000dd8 <_sp+0x0>
800001e4:	00f50533          	add	a0,a0,a5
800001e8:	f8b52023          	sw	a1,-128(a0)
}
800001ec:	00008067          	ret

800001f0 <stopSim>:


void stopSim(){
	*((volatile int*) SIM_STOP) = 0;
800001f0:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7ffff224>
}
800001f4:	00008067          	ret

800001f8 <putC>:

void putC(char c){
	*((volatile int*) PUTC) = c;
800001f8:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7ffff220>
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
	csr_write(mepc,		csr_read(stvec));
80000224:	105027f3          	csrr	a5,stvec
80000228:	34179073          	csrw	mepc,a5
}
8000022c:	00c12083          	lw	ra,12(sp)
80000230:	01010113          	addi	sp,sp,16
80000234:	00008067          	ret

80000238 <emulationTrapToSupervisorTrap>:

void emulationTrapToSupervisorTrap(uint32_t sepc, uint32_t mstatus){
	csr_write(sbadaddr, csr_read(mbadaddr));
80000238:	343027f3          	csrr	a5,mbadaddr
8000023c:	14379073          	csrw	sbadaddr,a5
	csr_write(scause, csr_read(mcause));
80000240:	342027f3          	csrr	a5,mcause
80000244:	14279073          	csrw	scause,a5
	csr_write(sepc, sepc);
80000248:	14151073          	csrw	sepc,a0
	csr_write(mepc,		csr_read(stvec));
8000024c:	105027f3          	csrr	a5,stvec
80000250:	34179073          	csrw	mepc,a5
	csr_clear(sstatus, MSTATUS_SPP);
80000254:	10000793          	li	a5,256
80000258:	1007b073          	csrc	sstatus,a5
	csr_set(sstatus, (mstatus >> 3) & MSTATUS_SPP);
8000025c:	0035d593          	srli	a1,a1,0x3
80000260:	1005f593          	andi	a1,a1,256
80000264:	1005a073          	csrs	sstatus,a1
	csr_clear(mstatus, MSTATUS_MPP);
80000268:	000027b7          	lui	a5,0x2
8000026c:	80078793          	addi	a5,a5,-2048 # 1800 <__stack_size+0x1000>
80000270:	3007b073          	csrc	mstatus,a5
	csr_set(mstatus, 0x8000);
80000274:	000087b7          	lui	a5,0x8
80000278:	3007a073          	csrs	mstatus,a5
}
8000027c:	00008067          	ret

80000280 <readWord>:

//Will modify MEPC
int readWord(int address, int *data){
	int result, tmp;
	int failed;
	__asm__ __volatile__ (
80000280:	00020737          	lui	a4,0x20
80000284:	30072073          	csrs	mstatus,a4
80000288:	00000717          	auipc	a4,0x0
8000028c:	01870713          	addi	a4,a4,24 # 800002a0 <readWord+0x20>
80000290:	34171073          	csrw	mepc,a4
80000294:	00100693          	li	a3,1
80000298:	00052783          	lw	a5,0(a0)
8000029c:	00000693          	li	a3,0
800002a0:	00020737          	lui	a4,0x20
800002a4:	30073073          	csrc	mstatus,a4
800002a8:	00068513          	mv	a0,a3
		: [result]"=&r" (result), [failed]"=&r" (failed), [tmp]"=&r" (tmp)
		: [address]"r" (address)
		: "memory"
	);

	*data = result;
800002ac:	00f5a023          	sw	a5,0(a1)
	return failed;
}
800002b0:	00008067          	ret

800002b4 <writeWord>:

//Will modify MEPC
int writeWord(uint32_t address, uint32_t data){
	int result, tmp;
	int failed;
	__asm__ __volatile__ (
800002b4:	00020737          	lui	a4,0x20
800002b8:	30072073          	csrs	mstatus,a4
800002bc:	00000717          	auipc	a4,0x0
800002c0:	01870713          	addi	a4,a4,24 # 800002d4 <writeWord+0x20>
800002c4:	34171073          	csrw	mepc,a4
800002c8:	00100793          	li	a5,1
800002cc:	00b52023          	sw	a1,0(a0)
800002d0:	00000793          	li	a5,0
800002d4:	00020737          	lui	a4,0x20
800002d8:	30073073          	csrc	mstatus,a4
800002dc:	00078513          	mv	a0,a5
		: [address]"r" (address), [data]"r" (data)
		: "memory"
	);

	return failed;
}
800002e0:	00008067          	ret

800002e4 <trap>:





void trap(){
800002e4:	fd010113          	addi	sp,sp,-48
800002e8:	02112623          	sw	ra,44(sp)
800002ec:	02812423          	sw	s0,40(sp)
800002f0:	02912223          	sw	s1,36(sp)
800002f4:	03212023          	sw	s2,32(sp)
800002f8:	01312e23          	sw	s3,28(sp)
800002fc:	01412c23          	sw	s4,24(sp)
80000300:	01512a23          	sw	s5,20(sp)
	int cause = csr_read(mcause);
80000304:	342027f3          	csrr	a5,mcause
	if(cause < 0){
80000308:	0207ce63          	bltz	a5,80000344 <trap+0x60>
		redirectTrap();
	} else {
		switch(cause){
8000030c:	00200713          	li	a4,2
80000310:	02e78e63          	beq	a5,a4,8000034c <trap+0x68>
80000314:	00900713          	li	a4,9
80000318:	16e78e63          	beq	a5,a4,80000494 <trap+0x1b0>
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			default: stopSim(); break;
			}
		}break;
		default: redirectTrap(); break;
8000031c:	ee5ff0ef          	jal	ra,80000200 <redirectTrap>
		}
	}

}
80000320:	02c12083          	lw	ra,44(sp)
80000324:	02812403          	lw	s0,40(sp)
80000328:	02412483          	lw	s1,36(sp)
8000032c:	02012903          	lw	s2,32(sp)
80000330:	01c12983          	lw	s3,28(sp)
80000334:	01812a03          	lw	s4,24(sp)
80000338:	01412a83          	lw	s5,20(sp)
8000033c:	03010113          	addi	sp,sp,48
80000340:	00008067          	ret
		redirectTrap();
80000344:	ebdff0ef          	jal	ra,80000200 <redirectTrap>
80000348:	fd9ff06f          	j	80000320 <trap+0x3c>
			int mepc = csr_read(mepc);
8000034c:	341024f3          	csrr	s1,mepc
			int mstatus = csr_read(mstatus);
80000350:	300029f3          	csrr	s3,mstatus
			int instruction = csr_read(mbadaddr);
80000354:	34302473          	csrr	s0,mbadaddr
			int opcode = instruction & 0x7F;
80000358:	07f47693          	andi	a3,s0,127
			int funct3 = (instruction >> 12) & 0x7;
8000035c:	40c45793          	srai	a5,s0,0xc
80000360:	0077f793          	andi	a5,a5,7
			switch(opcode){
80000364:	02f00713          	li	a4,47
80000368:	fae69ce3          	bne	a3,a4,80000320 <trap+0x3c>
				switch(funct3){
8000036c:	00200713          	li	a4,2
80000370:	10e79e63          	bne	a5,a4,8000048c <trap+0x1a8>
					int sel = instruction >> 27;
80000374:	41b45913          	srai	s2,s0,0x1b
					int addr = readRegister((instruction >> 15) & 0x1F);
80000378:	40f45513          	srai	a0,s0,0xf
8000037c:	01f57513          	andi	a0,a0,31
80000380:	e41ff0ef          	jal	ra,800001c0 <readRegister>
80000384:	00050a93          	mv	s5,a0
					int src = readRegister((instruction >> 20) & 0x1F);
80000388:	41445513          	srai	a0,s0,0x14
8000038c:	01f57513          	andi	a0,a0,31
80000390:	e31ff0ef          	jal	ra,800001c0 <readRegister>
80000394:	00050a13          	mv	s4,a0
					int rd = (instruction >> 7) & 0x1F;
80000398:	40745413          	srai	s0,s0,0x7
8000039c:	01f47413          	andi	s0,s0,31
					if(readWord(addr, &readValue)){
800003a0:	00c10593          	addi	a1,sp,12
800003a4:	000a8513          	mv	a0,s5
800003a8:	ed9ff0ef          	jal	ra,80000280 <readWord>
800003ac:	02051263          	bnez	a0,800003d0 <trap+0xec>
					switch(sel){
800003b0:	01c00793          	li	a5,28
800003b4:	0d27e063          	bltu	a5,s2,80000474 <trap+0x190>
800003b8:	00291913          	slli	s2,s2,0x2
800003bc:	800007b7          	lui	a5,0x80000
800003c0:	56478793          	addi	a5,a5,1380 # 80000564 <_sp+0xfffff78c>
800003c4:	00f90933          	add	s2,s2,a5
800003c8:	00092783          	lw	a5,0(s2)
800003cc:	00078067          	jr	a5
						emulationTrapToSupervisorTrap(mepc, mstatus);
800003d0:	00098593          	mv	a1,s3
800003d4:	00048513          	mv	a0,s1
800003d8:	e61ff0ef          	jal	ra,80000238 <emulationTrapToSupervisorTrap>
						return;
800003dc:	f45ff06f          	j	80000320 <trap+0x3c>
					case 0x0:  writeValue = src + readValue; break;
800003e0:	00c12783          	lw	a5,12(sp)
800003e4:	00fa0a33          	add	s4,s4,a5
					writeRegister(rd, readValue);
800003e8:	00c12583          	lw	a1,12(sp)
800003ec:	00040513          	mv	a0,s0
800003f0:	de9ff0ef          	jal	ra,800001d8 <writeRegister>
					if(writeWord(addr, writeValue)){
800003f4:	000a0593          	mv	a1,s4
800003f8:	000a8513          	mv	a0,s5
800003fc:	eb9ff0ef          	jal	ra,800002b4 <writeWord>
80000400:	06051e63          	bnez	a0,8000047c <trap+0x198>
					csr_write(mepc, mepc + 4);
80000404:	00448493          	addi	s1,s1,4
80000408:	34149073          	csrw	mepc,s1
				}break;
8000040c:	f15ff06f          	j	80000320 <trap+0x3c>
					case 0x4:  writeValue = src ^ readValue; break;
80000410:	00c12783          	lw	a5,12(sp)
80000414:	00fa4a33          	xor	s4,s4,a5
80000418:	fd1ff06f          	j	800003e8 <trap+0x104>
					case 0xC:  writeValue = src & readValue; break;
8000041c:	00c12783          	lw	a5,12(sp)
80000420:	00fa7a33          	and	s4,s4,a5
80000424:	fc5ff06f          	j	800003e8 <trap+0x104>
					case 0x8:  writeValue = src | readValue; break;
80000428:	00c12783          	lw	a5,12(sp)
8000042c:	00fa6a33          	or	s4,s4,a5
80000430:	fb9ff06f          	j	800003e8 <trap+0x104>
					case 0x10: writeValue = min(src, readValue); break;
80000434:	00c12783          	lw	a5,12(sp)
80000438:	fb47d8e3          	ble	s4,a5,800003e8 <trap+0x104>
8000043c:	00078a13          	mv	s4,a5
80000440:	fa9ff06f          	j	800003e8 <trap+0x104>
					case 0x14: writeValue = max(src, readValue); break;
80000444:	00c12783          	lw	a5,12(sp)
80000448:	fafa50e3          	ble	a5,s4,800003e8 <trap+0x104>
8000044c:	00078a13          	mv	s4,a5
80000450:	f99ff06f          	j	800003e8 <trap+0x104>
					case 0x18: writeValue = min((unsigned int)src, (unsigned int)readValue); break;
80000454:	00c12783          	lw	a5,12(sp)
80000458:	f947f8e3          	bleu	s4,a5,800003e8 <trap+0x104>
8000045c:	00078a13          	mv	s4,a5
80000460:	f89ff06f          	j	800003e8 <trap+0x104>
					case 0x1C: writeValue = max((unsigned int)src, (unsigned int)readValue); break;
80000464:	00c12783          	lw	a5,12(sp)
80000468:	f8fa70e3          	bleu	a5,s4,800003e8 <trap+0x104>
8000046c:	00078a13          	mv	s4,a5
80000470:	f79ff06f          	j	800003e8 <trap+0x104>
					default: redirectTrap(); return; break;
80000474:	d8dff0ef          	jal	ra,80000200 <redirectTrap>
80000478:	ea9ff06f          	j	80000320 <trap+0x3c>
						emulationTrapToSupervisorTrap(mepc, mstatus);
8000047c:	00098593          	mv	a1,s3
80000480:	00048513          	mv	a0,s1
80000484:	db5ff0ef          	jal	ra,80000238 <emulationTrapToSupervisorTrap>
						return;
80000488:	e99ff06f          	j	80000320 <trap+0x3c>
				default: redirectTrap(); break;
8000048c:	d75ff0ef          	jal	ra,80000200 <redirectTrap>
80000490:	e91ff06f          	j	80000320 <trap+0x3c>
			int which = readRegister(17);
80000494:	01100513          	li	a0,17
80000498:	d29ff0ef          	jal	ra,800001c0 <readRegister>
			switch(which){
8000049c:	00100793          	li	a5,1
800004a0:	02f51263          	bne	a0,a5,800004c4 <trap+0x1e0>
				putC(readRegister(10));
800004a4:	00a00513          	li	a0,10
800004a8:	d19ff0ef          	jal	ra,800001c0 <readRegister>
800004ac:	0ff57513          	andi	a0,a0,255
800004b0:	d49ff0ef          	jal	ra,800001f8 <putC>
				csr_write(mepc, csr_read(mepc) + 4);
800004b4:	341027f3          	csrr	a5,mepc
800004b8:	00478793          	addi	a5,a5,4
800004bc:	34179073          	csrw	mepc,a5
			}break;
800004c0:	e61ff06f          	j	80000320 <trap+0x3c>
			default: stopSim(); break;
800004c4:	d2dff0ef          	jal	ra,800001f0 <stopSim>
800004c8:	e59ff06f          	j	80000320 <trap+0x3c>

800004cc <__libc_init_array>:
800004cc:	ff010113          	addi	sp,sp,-16
800004d0:	00812423          	sw	s0,8(sp)
800004d4:	00912223          	sw	s1,4(sp)
800004d8:	00000417          	auipc	s0,0x0
800004dc:	08c40413          	addi	s0,s0,140 # 80000564 <__init_array_end>
800004e0:	00000497          	auipc	s1,0x0
800004e4:	08448493          	addi	s1,s1,132 # 80000564 <__init_array_end>
800004e8:	408484b3          	sub	s1,s1,s0
800004ec:	01212023          	sw	s2,0(sp)
800004f0:	00112623          	sw	ra,12(sp)
800004f4:	4024d493          	srai	s1,s1,0x2
800004f8:	00000913          	li	s2,0
800004fc:	04991063          	bne	s2,s1,8000053c <__libc_init_array+0x70>
80000500:	00000417          	auipc	s0,0x0
80000504:	06440413          	addi	s0,s0,100 # 80000564 <__init_array_end>
80000508:	00000497          	auipc	s1,0x0
8000050c:	05c48493          	addi	s1,s1,92 # 80000564 <__init_array_end>
80000510:	408484b3          	sub	s1,s1,s0
80000514:	b65ff0ef          	jal	ra,80000078 <_init>
80000518:	4024d493          	srai	s1,s1,0x2
8000051c:	00000913          	li	s2,0
80000520:	02991863          	bne	s2,s1,80000550 <__libc_init_array+0x84>
80000524:	00c12083          	lw	ra,12(sp)
80000528:	00812403          	lw	s0,8(sp)
8000052c:	00412483          	lw	s1,4(sp)
80000530:	00012903          	lw	s2,0(sp)
80000534:	01010113          	addi	sp,sp,16
80000538:	00008067          	ret
8000053c:	00042783          	lw	a5,0(s0)
80000540:	00190913          	addi	s2,s2,1
80000544:	00440413          	addi	s0,s0,4
80000548:	000780e7          	jalr	a5
8000054c:	fb1ff06f          	j	800004fc <__libc_init_array+0x30>
80000550:	00042783          	lw	a5,0(s0)
80000554:	00190913          	addi	s2,s2,1
80000558:	00440413          	addi	s0,s0,4
8000055c:	000780e7          	jalr	a5
80000560:	fc1ff06f          	j	80000520 <__libc_init_array+0x54>
