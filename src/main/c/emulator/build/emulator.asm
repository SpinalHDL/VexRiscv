
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
80000004:	f3810113          	addi	sp,sp,-200 # 80000f38 <_sp>


	/* Load data section */
	la a0, _data_lma
80000008:	00000517          	auipc	a0,0x0
8000000c:	6b850513          	addi	a0,a0,1720 # 800006c0 <__init_array_end>
	la a1, _data
80000010:	00000597          	auipc	a1,0x0
80000014:	6b058593          	addi	a1,a1,1712 # 800006c0 <__init_array_end>
	la a2, _edata
80000018:	00000617          	auipc	a2,0x0
8000001c:	72060613          	addi	a2,a2,1824 # 80000738 <__bss_start>
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
8000003c:	70050513          	addi	a0,a0,1792 # 80000738 <__bss_start>
	la a1, _end
80000040:	00000597          	auipc	a1,0x0
80000044:	6f858593          	addi	a1,a1,1784 # 80000738 <__bss_start>
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
80000058:	5d0000ef          	jal	ra,80000628 <__libc_init_array>
	call init
8000005c:	128000ef          	jal	ra,80000184 <init>
	la ra, done
80000060:	00000097          	auipc	ra,0x0
80000064:	01408093          	addi	ra,ra,20 # 80000074 <done>
	li a0, 0
80000068:	00000513          	li	a0,0
	li a1, DTB
8000006c:	810005b7          	lui	a1,0x81000
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
800000fc:	1ec000ef          	jal	ra,800002e8 <trap>
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
	uint32_t sp = (uint32_t) (&_sp);
	csr_write(mtvec, trapEntry);
80000184:	800007b7          	lui	a5,0x80000
80000188:	07c78793          	addi	a5,a5,124 # 8000007c <_sp+0xfffff144>
8000018c:	30579073          	csrw	mtvec,a5
	csr_write(mscratch, sp -32*4);
80000190:	800017b7          	lui	a5,0x80001
80000194:	f3878793          	addi	a5,a5,-200 # 80000f38 <_sp+0x0>
80000198:	f8078793          	addi	a5,a5,-128
8000019c:	34079073          	csrw	mscratch,a5
	csr_write(mstatus, 0x0800 | MSTATUS_MPIE);
800001a0:	000017b7          	lui	a5,0x1
800001a4:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x80>
800001a8:	30079073          	csrw	mstatus,a5
	csr_write(mie, 0);
800001ac:	30405073          	csrwi	mie,0
	csr_write(mepc, OS_CALL);
800001b0:	c00007b7          	lui	a5,0xc0000
800001b4:	34179073          	csrw	mepc,a5
	csr_write(medeleg, MEDELEG_INSTRUCTION_PAGE_FAULT | MEDELEG_LOAD_PAGE_FAULT | MEDELEG_STORE_PAGE_FAULT);
800001b8:	0000b7b7          	lui	a5,0xb
800001bc:	30279073          	csrw	medeleg,a5
	csr_write(mideleg, MIDELEG_SUPERVISOR_TIMER);
800001c0:	02000793          	li	a5,32
800001c4:	30379073          	csrw	mideleg,a5
	csr_write(sbadaddr, 0); //Used to avoid simulation missmatch
800001c8:	14305073          	csrwi	sbadaddr,0
}
800001cc:	00008067          	ret

800001d0 <readRegister>:

int readRegister(uint32_t id){
    unsigned int sp = (unsigned int) (&_sp);
	return ((int*) sp)[id-32];
800001d0:	00251513          	slli	a0,a0,0x2
800001d4:	800017b7          	lui	a5,0x80001
800001d8:	f3878793          	addi	a5,a5,-200 # 80000f38 <_sp+0x0>
800001dc:	00f50533          	add	a0,a0,a5
}
800001e0:	f8052503          	lw	a0,-128(a0)
800001e4:	00008067          	ret

800001e8 <writeRegister>:
void writeRegister(uint32_t id, int value){
	uint32_t sp = (uint32_t) (&_sp);
	((uint32_t*) sp)[id-32] = value;
800001e8:	00251513          	slli	a0,a0,0x2
800001ec:	800017b7          	lui	a5,0x80001
800001f0:	f3878793          	addi	a5,a5,-200 # 80000f38 <_sp+0x0>
800001f4:	00f50533          	add	a0,a0,a5
800001f8:	f8b52023          	sw	a1,-128(a0)
}
800001fc:	00008067          	ret

80000200 <redirectTrap>:



void redirectTrap(){
80000200:	ff010113          	addi	sp,sp,-16
80000204:	00112623          	sw	ra,12(sp)
	stopSim();
80000208:	3e8000ef          	jal	ra,800005f0 <stopSim>
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
	csr_set(mstatus, 0x8000 | MSTATUS_MPIE);
80000274:	000087b7          	lui	a5,0x8
80000278:	08078793          	addi	a5,a5,128 # 8080 <__stack_size+0x7880>
8000027c:	3007a073          	csrs	mstatus,a5
}
80000280:	00008067          	ret

80000284 <readWord>:

//Will modify MEPC
int32_t readWord(uint32_t address, int32_t *data){
	int32_t result, tmp;
	int32_t failed;
	__asm__ __volatile__ (
80000284:	00020737          	lui	a4,0x20
80000288:	30072073          	csrs	mstatus,a4
8000028c:	00000717          	auipc	a4,0x0
80000290:	01870713          	addi	a4,a4,24 # 800002a4 <readWord+0x20>
80000294:	34171073          	csrw	mepc,a4
80000298:	00100693          	li	a3,1
8000029c:	00052783          	lw	a5,0(a0)
800002a0:	00000693          	li	a3,0
800002a4:	00020737          	lui	a4,0x20
800002a8:	30073073          	csrc	mstatus,a4
800002ac:	00068513          	mv	a0,a3
		: [result]"=&r" (result), [failed]"=&r" (failed), [tmp]"=&r" (tmp)
		: [address]"r" (address)
		: "memory"
	);

	*data = result;
800002b0:	00f5a023          	sw	a5,0(a1) # 81000000 <_sp+0xfff0c8>
	return failed;
}
800002b4:	00008067          	ret

800002b8 <writeWord>:

//Will modify MEPC
int32_t writeWord(uint32_t address, int32_t data){
	int32_t result, tmp;
	int32_t failed;
	__asm__ __volatile__ (
800002b8:	00020737          	lui	a4,0x20
800002bc:	30072073          	csrs	mstatus,a4
800002c0:	00000717          	auipc	a4,0x0
800002c4:	01870713          	addi	a4,a4,24 # 800002d8 <writeWord+0x20>
800002c8:	34171073          	csrw	mepc,a4
800002cc:	00100793          	li	a5,1
800002d0:	00b52023          	sw	a1,0(a0)
800002d4:	00000793          	li	a5,0
800002d8:	00020737          	lui	a4,0x20
800002dc:	30073073          	csrc	mstatus,a4
800002e0:	00078513          	mv	a0,a5
		: [address]"r" (address), [data]"r" (data)
		: "memory"
	);

	return failed;
}
800002e4:	00008067          	ret

800002e8 <trap>:




void trap(){
800002e8:	fd010113          	addi	sp,sp,-48
800002ec:	02112623          	sw	ra,44(sp)
800002f0:	02812423          	sw	s0,40(sp)
800002f4:	02912223          	sw	s1,36(sp)
800002f8:	03212023          	sw	s2,32(sp)
800002fc:	01312e23          	sw	s3,28(sp)
80000300:	01412c23          	sw	s4,24(sp)
80000304:	01512a23          	sw	s5,20(sp)
	int32_t cause = csr_read(mcause);
80000308:	342027f3          	csrr	a5,mcause
	if(cause < 0){ //interrupt
8000030c:	0007ce63          	bltz	a5,80000328 <trap+0x40>
			csr_clear(mie, MIE_MTIE);
		}break;
		default: redirectTrap(); break;
		}
	} else { //exception
		switch(cause){
80000310:	00200713          	li	a4,2
80000314:	04e78e63          	beq	a5,a4,80000370 <trap+0x88>
80000318:	00900713          	li	a4,9
8000031c:	24e78e63          	beq	a5,a4,80000578 <trap+0x290>
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			default: stopSim(); break;
			}
		}break;
		default: redirectTrap(); break;
80000320:	ee1ff0ef          	jal	ra,80000200 <redirectTrap>
80000324:	0200006f          	j	80000344 <trap+0x5c>
		switch(cause & 0xFF){
80000328:	0ff7f793          	andi	a5,a5,255
8000032c:	00700713          	li	a4,7
80000330:	02e79c63          	bne	a5,a4,80000368 <trap+0x80>
			csr_set(sip, MIP_STIP);
80000334:	02000793          	li	a5,32
80000338:	1447a073          	csrs	sip,a5
			csr_clear(mie, MIE_MTIE);
8000033c:	08000793          	li	a5,128
80000340:	3047b073          	csrc	mie,a5
		}
	}

}
80000344:	02c12083          	lw	ra,44(sp)
80000348:	02812403          	lw	s0,40(sp)
8000034c:	02412483          	lw	s1,36(sp)
80000350:	02012903          	lw	s2,32(sp)
80000354:	01c12983          	lw	s3,28(sp)
80000358:	01812a03          	lw	s4,24(sp)
8000035c:	01412a83          	lw	s5,20(sp)
80000360:	03010113          	addi	sp,sp,48
80000364:	00008067          	ret
		default: redirectTrap(); break;
80000368:	e99ff0ef          	jal	ra,80000200 <redirectTrap>
8000036c:	fd9ff06f          	j	80000344 <trap+0x5c>
			uint32_t mepc = csr_read(mepc);
80000370:	341024f3          	csrr	s1,mepc
			uint32_t mstatus = csr_read(mstatus);
80000374:	30002a73          	csrr	s4,mstatus
			uint32_t instruction = csr_read(mbadaddr);
80000378:	34302473          	csrr	s0,mbadaddr
			uint32_t opcode = instruction & 0x7F;
8000037c:	07f47713          	andi	a4,s0,127
			uint32_t funct3 = (instruction >> 12) & 0x7;
80000380:	00c45793          	srli	a5,s0,0xc
80000384:	0077f613          	andi	a2,a5,7
			switch(opcode){
80000388:	02f00693          	li	a3,47
8000038c:	00d70a63          	beq	a4,a3,800003a0 <trap+0xb8>
80000390:	07300693          	li	a3,115
80000394:	12d70a63          	beq	a4,a3,800004c8 <trap+0x1e0>
				default: redirectTrap();  break;
80000398:	e69ff0ef          	jal	ra,80000200 <redirectTrap>
8000039c:	fa9ff06f          	j	80000344 <trap+0x5c>
				switch(funct3){
800003a0:	00200793          	li	a5,2
800003a4:	10f61e63          	bne	a2,a5,800004c0 <trap+0x1d8>
					uint32_t sel = instruction >> 27;
800003a8:	01b45913          	srli	s2,s0,0x1b
					uint32_t addr = readRegister((instruction >> 15) & 0x1F);
800003ac:	00f45513          	srli	a0,s0,0xf
800003b0:	01f57513          	andi	a0,a0,31
800003b4:	e1dff0ef          	jal	ra,800001d0 <readRegister>
800003b8:	00050a93          	mv	s5,a0
					int32_t  src = readRegister((instruction >> 20) & 0x1F);
800003bc:	01445513          	srli	a0,s0,0x14
800003c0:	01f57513          	andi	a0,a0,31
800003c4:	e0dff0ef          	jal	ra,800001d0 <readRegister>
800003c8:	00050993          	mv	s3,a0
					uint32_t rd = (instruction >> 7) & 0x1F;
800003cc:	00745413          	srli	s0,s0,0x7
800003d0:	01f47413          	andi	s0,s0,31
					if(readWord(addr, &readValue)){
800003d4:	00c10593          	addi	a1,sp,12
800003d8:	000a8513          	mv	a0,s5
800003dc:	ea9ff0ef          	jal	ra,80000284 <readWord>
800003e0:	02051263          	bnez	a0,80000404 <trap+0x11c>
					switch(sel){
800003e4:	01c00793          	li	a5,28
800003e8:	0d27e063          	bltu	a5,s2,800004a8 <trap+0x1c0>
800003ec:	00291913          	slli	s2,s2,0x2
800003f0:	800007b7          	lui	a5,0x80000
800003f4:	6c078793          	addi	a5,a5,1728 # 800006c0 <_sp+0xfffff788>
800003f8:	00f90933          	add	s2,s2,a5
800003fc:	00092783          	lw	a5,0(s2)
80000400:	00078067          	jr	a5
						emulationTrapToSupervisorTrap(mepc, mstatus);
80000404:	000a0593          	mv	a1,s4
80000408:	00048513          	mv	a0,s1
8000040c:	e2dff0ef          	jal	ra,80000238 <emulationTrapToSupervisorTrap>
						return;
80000410:	f35ff06f          	j	80000344 <trap+0x5c>
					case 0x0:  writeValue = src + readValue; break;
80000414:	00c12783          	lw	a5,12(sp)
80000418:	00f989b3          	add	s3,s3,a5
					writeRegister(rd, readValue);
8000041c:	00c12583          	lw	a1,12(sp)
80000420:	00040513          	mv	a0,s0
80000424:	dc5ff0ef          	jal	ra,800001e8 <writeRegister>
					if(writeWord(addr, writeValue)){
80000428:	00098593          	mv	a1,s3
8000042c:	000a8513          	mv	a0,s5
80000430:	e89ff0ef          	jal	ra,800002b8 <writeWord>
80000434:	06051e63          	bnez	a0,800004b0 <trap+0x1c8>
					csr_write(mepc, mepc + 4);
80000438:	00448493          	addi	s1,s1,4
8000043c:	34149073          	csrw	mepc,s1
				}break;
80000440:	f05ff06f          	j	80000344 <trap+0x5c>
					case 0x4:  writeValue = src ^ readValue; break;
80000444:	00c12783          	lw	a5,12(sp)
80000448:	00f9c9b3          	xor	s3,s3,a5
8000044c:	fd1ff06f          	j	8000041c <trap+0x134>
					case 0xC:  writeValue = src & readValue; break;
80000450:	00c12783          	lw	a5,12(sp)
80000454:	00f9f9b3          	and	s3,s3,a5
80000458:	fc5ff06f          	j	8000041c <trap+0x134>
					case 0x8:  writeValue = src | readValue; break;
8000045c:	00c12783          	lw	a5,12(sp)
80000460:	00f9e9b3          	or	s3,s3,a5
80000464:	fb9ff06f          	j	8000041c <trap+0x134>
					case 0x10: writeValue = min(src, readValue); break;
80000468:	00c12783          	lw	a5,12(sp)
8000046c:	fb37d8e3          	ble	s3,a5,8000041c <trap+0x134>
80000470:	00078993          	mv	s3,a5
80000474:	fa9ff06f          	j	8000041c <trap+0x134>
					case 0x14: writeValue = max(src, readValue); break;
80000478:	00c12783          	lw	a5,12(sp)
8000047c:	faf9d0e3          	ble	a5,s3,8000041c <trap+0x134>
80000480:	00078993          	mv	s3,a5
80000484:	f99ff06f          	j	8000041c <trap+0x134>
					case 0x18: writeValue = min((unsigned int)src, (unsigned int)readValue); break;
80000488:	00c12783          	lw	a5,12(sp)
8000048c:	f937f8e3          	bleu	s3,a5,8000041c <trap+0x134>
80000490:	00078993          	mv	s3,a5
80000494:	f89ff06f          	j	8000041c <trap+0x134>
					case 0x1C: writeValue = max((unsigned int)src, (unsigned int)readValue); break;
80000498:	00c12783          	lw	a5,12(sp)
8000049c:	f8f9f0e3          	bleu	a5,s3,8000041c <trap+0x134>
800004a0:	00078993          	mv	s3,a5
800004a4:	f79ff06f          	j	8000041c <trap+0x134>
					default: redirectTrap(); return; break;
800004a8:	d59ff0ef          	jal	ra,80000200 <redirectTrap>
800004ac:	e99ff06f          	j	80000344 <trap+0x5c>
						emulationTrapToSupervisorTrap(mepc, mstatus);
800004b0:	000a0593          	mv	a1,s4
800004b4:	00048513          	mv	a0,s1
800004b8:	d81ff0ef          	jal	ra,80000238 <emulationTrapToSupervisorTrap>
						return;
800004bc:	e89ff06f          	j	80000344 <trap+0x5c>
				default: redirectTrap(); break;
800004c0:	d41ff0ef          	jal	ra,80000200 <redirectTrap>
800004c4:	e81ff06f          	j	80000344 <trap+0x5c>
					switch (funct3 & 0x3) {
800004c8:	0037f793          	andi	a5,a5,3
800004cc:	00100713          	li	a4,1
800004d0:	06e78263          	beq	a5,a4,80000534 <trap+0x24c>
800004d4:	02078c63          	beqz	a5,8000050c <trap+0x224>
800004d8:	00200713          	li	a4,2
800004dc:	02e78c63          	beq	a5,a4,80000514 <trap+0x22c>
800004e0:	00300713          	li	a4,3
800004e4:	04e78063          	beq	a5,a4,80000524 <trap+0x23c>
					uint32_t csrAddress = instruction >> 20;
800004e8:	01445713          	srli	a4,s0,0x14
					switch(csrAddress){
800004ec:	000017b7          	lui	a5,0x1
800004f0:	c0178793          	addi	a5,a5,-1023 # c01 <__stack_size+0x401>
800004f4:	04f70463          	beq	a4,a5,8000053c <trap+0x254>
800004f8:	000017b7          	lui	a5,0x1
800004fc:	c8178793          	addi	a5,a5,-895 # c81 <__stack_size+0x481>
80000500:	06f70263          	beq	a4,a5,80000564 <trap+0x27c>
					default: redirectTrap(); break;
80000504:	cfdff0ef          	jal	ra,80000200 <redirectTrap>
80000508:	03c0006f          	j	80000544 <trap+0x25c>
					case 0: redirectTrap(); break;
8000050c:	cf5ff0ef          	jal	ra,80000200 <redirectTrap>
80000510:	fd9ff06f          	j	800004e8 <trap+0x200>
					case 2: clear = 0; set = input; write = ((instruction >> 15) & 0x1F) != 0; break;
80000514:	00f45993          	srli	s3,s0,0xf
80000518:	01f9f993          	andi	s3,s3,31
8000051c:	013039b3          	snez	s3,s3
80000520:	fc9ff06f          	j	800004e8 <trap+0x200>
					case 3: clear = input; set = 0; write = ((instruction >> 15) & 0x1F) != 0; break;
80000524:	00f45993          	srli	s3,s0,0xf
80000528:	01f9f993          	andi	s3,s3,31
8000052c:	013039b3          	snez	s3,s3
80000530:	fb9ff06f          	j	800004e8 <trap+0x200>
					case 1: clear = ~0; set = input; write = 1; break;
80000534:	00100993          	li	s3,1
80000538:	fb1ff06f          	j	800004e8 <trap+0x200>
					case RDTIME  : old = rdtime(); break;
8000053c:	0c4000ef          	jal	ra,80000600 <rdtime>
80000540:	00050913          	mv	s2,a0
					if(write) {
80000544:	02099663          	bnez	s3,80000570 <trap+0x288>
					writeRegister((instruction >> 7) & 0x1F, old);
80000548:	00745513          	srli	a0,s0,0x7
8000054c:	00090593          	mv	a1,s2
80000550:	01f57513          	andi	a0,a0,31
80000554:	c95ff0ef          	jal	ra,800001e8 <writeRegister>
					csr_write(mepc, mepc + 4);
80000558:	00448493          	addi	s1,s1,4
8000055c:	34149073          	csrw	mepc,s1
				}break;
80000560:	de5ff06f          	j	80000344 <trap+0x5c>
					case RDTIMEH : old = rdtimeh(); break;
80000564:	0a4000ef          	jal	ra,80000608 <rdtimeh>
80000568:	00050913          	mv	s2,a0
8000056c:	fd9ff06f          	j	80000544 <trap+0x25c>
						default: redirectTrap(); break;
80000570:	c91ff0ef          	jal	ra,80000200 <redirectTrap>
80000574:	fd5ff06f          	j	80000548 <trap+0x260>
			uint32_t which = readRegister(17);
80000578:	01100513          	li	a0,17
8000057c:	c55ff0ef          	jal	ra,800001d0 <readRegister>
80000580:	00050413          	mv	s0,a0
			uint32_t a0 = readRegister(10);
80000584:	00a00513          	li	a0,10
80000588:	c49ff0ef          	jal	ra,800001d0 <readRegister>
8000058c:	00050493          	mv	s1,a0
			uint32_t a1 = readRegister(11);
80000590:	00b00513          	li	a0,11
80000594:	c3dff0ef          	jal	ra,800001d0 <readRegister>
			switch(which){
80000598:	02040263          	beqz	s0,800005bc <trap+0x2d4>
8000059c:	00100793          	li	a5,1
800005a0:	04f41463          	bne	s0,a5,800005e8 <trap+0x300>
				putC(a0);
800005a4:	0ff4f513          	andi	a0,s1,255
800005a8:	050000ef          	jal	ra,800005f8 <putC>
				csr_write(mepc, csr_read(mepc) + 4);
800005ac:	341027f3          	csrr	a5,mepc
800005b0:	00478793          	addi	a5,a5,4
800005b4:	34179073          	csrw	mepc,a5
			}break;
800005b8:	d8dff06f          	j	80000344 <trap+0x5c>
				setMachineTimerCmp(a0, a1);
800005bc:	00050593          	mv	a1,a0
800005c0:	00048513          	mv	a0,s1
800005c4:	04c000ef          	jal	ra,80000610 <setMachineTimerCmp>
				csr_set(mie, MIE_MTIE);
800005c8:	08000793          	li	a5,128
800005cc:	3047a073          	csrs	mie,a5
				csr_clear(sip, MIP_STIP);
800005d0:	02000793          	li	a5,32
800005d4:	1447b073          	csrc	sip,a5
				csr_write(mepc, csr_read(mepc) + 4);
800005d8:	341027f3          	csrr	a5,mepc
800005dc:	00478793          	addi	a5,a5,4
800005e0:	34179073          	csrw	mepc,a5
			}break;
800005e4:	d61ff06f          	j	80000344 <trap+0x5c>
			default: stopSim(); break;
800005e8:	008000ef          	jal	ra,800005f0 <stopSim>
800005ec:	d59ff06f          	j	80000344 <trap+0x5c>

800005f0 <stopSim>:
#include "hal.h"

void stopSim(){
	*((volatile uint32_t*) 0xFFFFFFFC) = 0;
800005f0:	fe002e23          	sw	zero,-4(zero) # fffffffc <_sp+0x7ffff0c4>
}
800005f4:	00008067          	ret

800005f8 <putC>:

void putC(char c){
	*((volatile uint32_t*) 0xFFFFFFF8) = c;
800005f8:	fea02c23          	sw	a0,-8(zero) # fffffff8 <_sp+0x7ffff0c0>
}
800005fc:	00008067          	ret

80000600 <rdtime>:

uint32_t rdtime(){
	return *((volatile uint32_t*) 0xFFFFFFE0);
80000600:	fe002503          	lw	a0,-32(zero) # ffffffe0 <_sp+0x7ffff0a8>
}
80000604:	00008067          	ret

80000608 <rdtimeh>:

uint32_t rdtimeh(){
	return *((volatile uint32_t*) 0xFFFFFFE4);
80000608:	fe402503          	lw	a0,-28(zero) # ffffffe4 <_sp+0x7ffff0ac>
}
8000060c:	00008067          	ret

80000610 <setMachineTimerCmp>:


void setMachineTimerCmp(uint32_t low, uint32_t high){
	volatile uint32_t* base = (volatile uint32_t*) 0xFFFFFFE8;
	base[1] = 0xffffffff;
80000610:	fec00793          	li	a5,-20
80000614:	fff00713          	li	a4,-1
80000618:	00e7a023          	sw	a4,0(a5)
	base[0] = low;
8000061c:	fea02423          	sw	a0,-24(zero) # ffffffe8 <_sp+0x7ffff0b0>
	base[1] = high;
80000620:	00b7a023          	sw	a1,0(a5)
}
80000624:	00008067          	ret

80000628 <__libc_init_array>:
80000628:	ff010113          	addi	sp,sp,-16
8000062c:	00812423          	sw	s0,8(sp)
80000630:	00912223          	sw	s1,4(sp)
80000634:	00000417          	auipc	s0,0x0
80000638:	08c40413          	addi	s0,s0,140 # 800006c0 <__init_array_end>
8000063c:	00000497          	auipc	s1,0x0
80000640:	08448493          	addi	s1,s1,132 # 800006c0 <__init_array_end>
80000644:	408484b3          	sub	s1,s1,s0
80000648:	01212023          	sw	s2,0(sp)
8000064c:	00112623          	sw	ra,12(sp)
80000650:	4024d493          	srai	s1,s1,0x2
80000654:	00000913          	li	s2,0
80000658:	04991063          	bne	s2,s1,80000698 <__libc_init_array+0x70>
8000065c:	00000417          	auipc	s0,0x0
80000660:	06440413          	addi	s0,s0,100 # 800006c0 <__init_array_end>
80000664:	00000497          	auipc	s1,0x0
80000668:	05c48493          	addi	s1,s1,92 # 800006c0 <__init_array_end>
8000066c:	408484b3          	sub	s1,s1,s0
80000670:	a09ff0ef          	jal	ra,80000078 <_init>
80000674:	4024d493          	srai	s1,s1,0x2
80000678:	00000913          	li	s2,0
8000067c:	02991863          	bne	s2,s1,800006ac <__libc_init_array+0x84>
80000680:	00c12083          	lw	ra,12(sp)
80000684:	00812403          	lw	s0,8(sp)
80000688:	00412483          	lw	s1,4(sp)
8000068c:	00012903          	lw	s2,0(sp)
80000690:	01010113          	addi	sp,sp,16
80000694:	00008067          	ret
80000698:	00042783          	lw	a5,0(s0)
8000069c:	00190913          	addi	s2,s2,1
800006a0:	00440413          	addi	s0,s0,4
800006a4:	000780e7          	jalr	a5
800006a8:	fb1ff06f          	j	80000658 <__libc_init_array+0x30>
800006ac:	00042783          	lw	a5,0(s0)
800006b0:	00190913          	addi	s2,s2,1
800006b4:	00440413          	addi	s0,s0,4
800006b8:	000780e7          	jalr	a5
800006bc:	fc1ff06f          	j	8000067c <__libc_init_array+0x54>
