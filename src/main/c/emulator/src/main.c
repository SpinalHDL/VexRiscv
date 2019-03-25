#include <stdint.h>
#include "riscv.h"
#include "config.h"

extern const unsigned int _sp;
extern void trapEntry();

void init() {
	csr_write(mtvec, trapEntry);

    unsigned int sp = (unsigned int) (&_sp);
	csr_write(mscratch, sp -32*4);
	csr_write(mstatus, 0x0800);
	csr_write(mepc, OS_CALL);
	csr_write(medeleg, MDELEG_INSTRUCTION_PAGE_FAULT | MDELEG_LOAD_PAGE_FAULT | MDELEG_STORE_PAGE_FAULT);
}

int readRegister(int id){
    unsigned int sp = (unsigned int) (&_sp);
	return ((int*) sp)[id-32];
}
void writeRegister(int id, int value){
    unsigned int sp = (unsigned int) (&_sp);
	((int*) sp)[id-32] = value;
}


void stopSim(){
	*((volatile int*) SIM_STOP) = 0;
}

void putC(char c){
	*((volatile int*) PUTC) = c;
}


void redirectTrap(){
	stopSim();
	csr_write(sbadaddr, csr_read(mbadaddr));
	csr_write(sepc,     csr_read(mepc));
	csr_write(scause,   csr_read(mcause));
}

#define max(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a > _b ? _a : _b; })


#define min(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; })

void trap(){
	int cause = csr_read(mcause);
	if(cause < 0){
		redirectTrap();
	} else {
		switch(cause){
		case CAUSE_ILLEGAL_INSTRUCTION:{
			int instruction = csr_read(mbadaddr);
			int opcode = instruction & 0x7F;
			int funct3 = (instruction >> 12) & 0x7;
			switch(opcode){
			case 0x2F: //Atomic
				switch(funct3){
				case 0x2:{
					int sel = instruction >> 27;
					int*addr = (int*)readRegister((instruction >> 15) & 0x1F);
					int src = readRegister((instruction >> 20) & 0x1F);
					int rd = (instruction >> 7) & 0x1F;
					int readValue = *addr;
					int writeValue;
					switch(sel){
					case 0x0:  writeValue = src + readValue; break;
					case 0x1:  writeValue = src; break;
					case 0x4:  writeValue = src ^ readValue; break;
					case 0xC:  writeValue = src & readValue; break;
					case 0x8:  writeValue = src | readValue; break;
					case 0x10: writeValue = min(src, readValue); break;
					case 0x14: writeValue = max(src, readValue); break;
					case 0x18: writeValue = min((unsigned int)src, (unsigned int)readValue); break;
					case 0x1C: writeValue = max((unsigned int)src, (unsigned int)readValue); break;
					default: redirectTrap(); return; break;
					}
					writeRegister(rd, readValue);
					*addr = writeValue;
					csr_write(mepc, csr_read(mepc) + 4);
				}break;
				default: redirectTrap(); break;
				}
			}
		}break;
		case CAUSE_SCALL:{
			int which = readRegister(17);
			switch(which){
			case 1:{
				putC(readRegister(10));
				csr_write(mepc, csr_read(mepc) + 4);
			}break;
			default: stopSim(); break;
			}
		}break;
		default: redirectTrap(); break;
		}
	}

}
