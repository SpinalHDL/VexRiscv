#include <stdint.h>
#include "riscv.h"
#include "config.h"
#include "hal.h"

extern const uint32_t _sp;
extern void trapEntry();
extern void emulationTrap();

void putString(char* s){
	while(*s){
		putC(*s);
		s++;
	}
}

//Affect mtvec
void setup_pmp(void)
{
  // Set up a PMP to permit access to all of memory.
  // Ignore the illegal-instruction trap if PMPs aren't supported.
  uintptr_t pmpc = PMP_NAPOT | PMP_R | PMP_W | PMP_X;
  asm volatile ("la t0, 1f\n\t"
                "csrw mtvec, t0\n\t"
                "csrw pmpaddr0, %1\n\t"
                "csrw pmpcfg0, %0\n\t"
                ".align 2\n\t"
                "1:"
                : : "r" (pmpc), "r" (-1UL) : "t0");
}

void init() {
	setup_pmp();
	halInit();
	putString("*** VexRiscv BIOS ***\n");
	uint32_t sp = (uint32_t) (&_sp);
	csr_write(mtvec, trapEntry);
	csr_write(mscratch, sp -32*4);
	csr_write(mstatus, 0x0800 | MSTATUS_MPIE);
	csr_write(mie, 0);
	csr_write(mepc, OS_CALL);
	//In future it would probably need to manage missaligned stuff, now it will stop the simulation
	csr_write(medeleg, MEDELEG_INSTRUCTION_PAGE_FAULT | MEDELEG_LOAD_PAGE_FAULT | MEDELEG_STORE_PAGE_FAULT | MEDELEG_USER_ENVIRONNEMENT_CALL);
	csr_write(mideleg, MIDELEG_SUPERVISOR_TIMER | MIDELEG_SUPERVISOR_EXTERNAL | MIDELEG_SUPERVISOR_SOFTWARE);
	csr_write(sbadaddr, 0); //Used to avoid simulation missmatch

	putString("*** Supervisor ***\n");
}

int readRegister(uint32_t id){
    unsigned int sp = (unsigned int) (&_sp);
	return ((int*) sp)[id-32];
}
void writeRegister(uint32_t id, int value){
	uint32_t sp = (uint32_t) (&_sp);
	((uint32_t*) sp)[id-32] = value;
}


//Currently, this should not happen, unless kernel things are going wrong
void redirectTrap(){
	stopSim();
	csr_write(sbadaddr, csr_read(mbadaddr));
	csr_write(sepc,     csr_read(mepc));
	csr_write(scause,   csr_read(mcause));
	csr_write(mepc,		csr_read(stvec));
}

void emulationTrapToSupervisorTrap(uint32_t sepc, uint32_t mstatus){
	csr_write(mtvec, trapEntry);
	csr_write(sbadaddr, csr_read(mbadaddr));
	csr_write(scause, csr_read(mcause));
	csr_write(sepc, sepc);
	csr_write(mepc,	csr_read(stvec));
	csr_write(mstatus,
			  (mstatus & ~(MSTATUS_SPP | MSTATUS_MPP | MSTATUS_SIE | MSTATUS_SPIE))
			| ((mstatus >> 3) & MSTATUS_SPP)
			| (0x0800 | MSTATUS_MPIE)
			| ((mstatus & MSTATUS_SIE) << 4)
	);
}

#define max(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a > _b ? _a : _b; })


#define min(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; })



//Will modify MTVEC
int32_t readWord(uint32_t address, int32_t *data){
	int32_t result, tmp;
	int32_t failed;
	__asm__ __volatile__ (
		"  	li       %[tmp],  0x00020000\n"
		"	csrs     mstatus,  %[tmp]\n"
		"  	la       %[tmp],  1f\n"
		"	csrw     mtvec,  %[tmp]\n"
		"	li       %[failed], 1\n"
		"	lw       %[result], 0(%[address])\n"
		"	li       %[failed], 0\n"
		"1:\n"
		"  	li       %[tmp],  0x00020000\n"
		"	csrc     mstatus,  %[tmp]\n"
		: [result]"=&r" (result), [failed]"=&r" (failed), [tmp]"=&r" (tmp)
		: [address]"r" (address)
		: "memory"
	);

	*data = result;
	return failed;
}

//Will modify MTVEC
int32_t writeWord(uint32_t address, int32_t data){
	int32_t result, tmp;
	int32_t failed;
	__asm__ __volatile__ (
		"  	li       %[tmp],  0x00020000\n"
		"	csrs     mstatus,  %[tmp]\n"
		"  	la       %[tmp],  1f\n"
		"	csrw     mtvec,  %[tmp]\n"
		"	li       %[failed], 1\n"
		"	sw       %[data], 0(%[address])\n"
		"	li       %[failed], 0\n"
		"1:\n"
		"  	li       %[tmp],  0x00020000\n"
		"	csrc     mstatus,  %[tmp]\n"
		: [failed]"=&r" (failed), [tmp]"=&r" (tmp)
		: [address]"r" (address), [data]"r" (data)
		: "memory"
	);

	return failed;
}




void trap(){
	int32_t cause = csr_read(mcause);
	if(cause < 0){ //interrupt
		switch(cause & 0xFF){
		case CAUSE_MACHINE_TIMER:{
			csr_set(sip, MIP_STIP);
			csr_clear(mie, MIE_MTIE);
		}break;
		default: redirectTrap(); break;
		}
	} else { //exception
		switch(cause){
		case CAUSE_ILLEGAL_INSTRUCTION:{
			uint32_t mepc = csr_read(mepc);
			uint32_t mstatus = csr_read(mstatus);
#ifdef SIM
			uint32_t instruction = csr_read(mbadaddr);
#endif
#if defined(QEMU) || defined(LITEX)
			uint32_t instruction = 0;
			uint32_t i;
			if (mepc & 2) {
				readWord(mepc - 2, &i);
				i >>= 16;
				if (i & 3 == 3) {
					uint32_t u32Buf;
					readWord(mepc+2, &u32Buf);
					i |= u32Buf << 16;
				}
			} else {
				readWord(mepc, &i);
			}
			instruction = i;
			csr_write(mtvec, trapEntry); //Restore mtvec
#endif

			uint32_t opcode = instruction & 0x7F;
			uint32_t funct3 = (instruction >> 12) & 0x7;
			switch(opcode){
			case 0x2F: //Atomic
				switch(funct3){
				case 0x2:{
					uint32_t sel = instruction >> 27;
					uint32_t addr = readRegister((instruction >> 15) & 0x1F);
					int32_t  src = readRegister((instruction >> 20) & 0x1F);
					uint32_t rd = (instruction >> 7) & 0x1F;
					int32_t readValue;
					if(readWord(addr, &readValue)){
						emulationTrapToSupervisorTrap(mepc, mstatus);
						return;
					}
					int writeValue;
					switch(sel){
					case 0x0:  writeValue = src + readValue; break;
					case 0x1:  writeValue = src; break;
//LR SC done in hardware (cheap), and require to keep track of context switches
//					case 0x2:{ //LR
//					}break;
//					case 0x3:{ //SC
//					}break;
					case 0x4:  writeValue = src ^ readValue; break;
					case 0xC:  writeValue = src & readValue; break;
					case 0x8:  writeValue = src | readValue; break;
					case 0x10: writeValue = min(src, readValue); break;
					case 0x14: writeValue = max(src, readValue); break;
					case 0x18: writeValue = min((unsigned int)src, (unsigned int)readValue); break;
					case 0x1C: writeValue = max((unsigned int)src, (unsigned int)readValue); break;
					default: redirectTrap(); return; break;
					}
					if(writeWord(addr, writeValue)){
						emulationTrapToSupervisorTrap(mepc, mstatus);
						return;
					}
					writeRegister(rd, readValue);
					csr_write(mepc, mepc + 4);
					csr_write(mtvec, trapEntry); //Restore mtvec
				}break;
				default: redirectTrap(); break;
				} break;
				case 0x73:{
					//CSR
					uint32_t input = (instruction & 0x4000) ? ((instruction >> 15) & 0x1F) : readRegister((instruction >> 15) & 0x1F);;
					uint32_t clear, set;
					uint32_t write;
					switch (funct3 & 0x3) {
					case 0: redirectTrap(); break;
					case 1: clear = ~0; set = input; write = 1; break;
					case 2: clear = 0; set = input; write = ((instruction >> 15) & 0x1F) != 0; break;
					case 3: clear = input; set = 0; write = ((instruction >> 15) & 0x1F) != 0; break;
					}
					uint32_t csrAddress = instruction >> 20;
					uint32_t old;
					switch(csrAddress){
					case RDCYCLE :
					case RDINSTRET:
					case RDTIME  : old = rdtime(); break;
					case RDCYCLEH :
					case RDINSTRETH:
					case RDTIMEH : old = rdtimeh(); break;
					default: redirectTrap(); break;
					}
					if(write) {
						uint32_t newValue = (old & ~clear) | set;
						switch(csrAddress){
						default: redirectTrap(); break;
						}
					}

					writeRegister((instruction >> 7) & 0x1F, old);
					csr_write(mepc, mepc + 4);

				}break;
				default: redirectTrap();  break;
			}
		}break;
		case CAUSE_SCALL:{
			uint32_t which = readRegister(17);
			uint32_t a0 = readRegister(10);
			uint32_t a1 = readRegister(11);
			uint32_t a2 = readRegister(12);
			switch(which){
			case SBI_CONSOLE_PUTCHAR:{
				putC(a0);
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			case SBI_CONSOLE_GETCHAR:{
				writeRegister(10, getC()); //no char
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			case SBI_SET_TIMER:{
				setMachineTimerCmp(a0, a1);
				csr_set(mie, MIE_MTIE);
				csr_clear(sip, MIP_STIP);
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			default: stopSim(); break;
			}
		}break;
		default: redirectTrap(); break;
		}
	}

}
