#include "VVexRiscv.h"
#include "VVexRiscv_VexRiscv.h"
#ifdef REF
#include "VVexRiscv_RiscvCore.h"
#endif
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <stdint.h>
#include <cstring>
#include <string.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <mutex>
#include <iomanip>
#include <queue>
#include <time.h>

using namespace std;

struct timespec timer_get(){
    struct timespec start_time;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start_time);
    return start_time;
}

class Memory{
public:
	uint8_t* mem[1 << 12];

	Memory(){
		for(uint32_t i = 0;i < (1 << 12);i++) mem[i] = NULL;
	}
	~Memory(){
		for(uint32_t i = 0;i < (1 << 12);i++) if(mem[i]) delete mem[i];
	}

	uint8_t* get(uint32_t address){
		if(mem[address >> 20] == NULL) {
			uint8_t* ptr = new uint8_t[1024*1024];
			for(uint32_t i = 0;i < 1024*1024;i+=4) {
				ptr[i + 0] = 0xFF;
				ptr[i + 1] = 0xFF;
				ptr[i + 2] = 0xFF;
				ptr[i + 3] = 0xFF;
			}
			mem[address >> 20] = ptr;
		}
		return &mem[address >> 20][address & 0xFFFFF];
	}

	void read(uint32_t address,uint32_t length, uint8_t *data){
		for(int i = 0;i < length;i++){
			data[i] = (*this)[address + i];
		}
	}

	void write(uint32_t address,uint32_t length, uint8_t *data){
		for(int i = 0;i < length;i++){
			(*this)[address + i] = data[i];
		}
	}

	uint8_t& operator [](uint32_t address) {
		return *get(address);
	}

	/*T operator [](uint32_t address) const {
		return get(address);
	}*/
};

//uint8_t memory[1024 * 1024];

uint32_t hti(char c) {
	if (c >= 'A' && c <= 'F')
		return c - 'A' + 10;
	if (c >= 'a' && c <= 'f')
		return c - 'a' + 10;
	return c - '0';
}

uint32_t hToI(char *c, uint32_t size) {
	uint32_t value = 0;
	for (uint32_t i = 0; i < size; i++) {
		value += hti(c[i]) << ((size - i - 1) * 4);
	}
	return value;
}

void loadHexImpl(string path,Memory* mem) {
	FILE *fp = fopen(&path[0], "r");
	if(fp == 0){
		cout << path << " not found" << endl;
	}
	//Preload 0x0 <-> 0x80000000 jumps
	((uint32_t*)mem->get(0))[0] = 0x800000b7;
	((uint32_t*)mem->get(0))[1] = 0x000080e7;
	((uint32_t*)mem->get(0x80000000))[0] = 0x00000097;

	fseek(fp, 0, SEEK_END);
	uint32_t size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	char* content = new char[size];
	fread(content, 1, size, fp);

	int offset = 0;
	char* line = content;
	while (1) {
		if (line[0] == ':') {
			uint32_t byteCount = hToI(line + 1, 2);
			uint32_t nextAddr = hToI(line + 3, 4) + offset;
			uint32_t key = hToI(line + 7, 2);
//			printf("%d %d %d\n", byteCount, nextAddr,key);
			switch (key) {
			case 0:
				for (uint32_t i = 0; i < byteCount; i++) {
					*(mem->get(nextAddr + i)) = hToI(line + 9 + i * 2, 2);
					//printf("%x %x %c%c\n",nextAddr + i,hToI(line + 9 + i*2,2),line[9 + i * 2],line[9 + i * 2+1]);
				}
				break;
			case 2:
//				cout << offset << endl;
				offset = hToI(line + 9, 4) << 4;
				break;
			case 4:
//				cout << offset << endl;
				offset = hToI(line + 9, 4) << 16;
				break;
			default:
//				cout << "??? " << key << endl;
				break;
			}
		}

		while (*line != '\n' && size != 0) {
			line++;
			size--;
		}
		if (size <= 1)
			break;
		line++;
		size--;
	}

	delete content;
}



#define TEXTIFY(A) #A

#define assertEq(x,ref) if(x != ref) {\
	printf("\n*** %s is %d but should be %d ***\n\n",TEXTIFY(x),x,ref);\
	throw std::exception();\
}

class success : public std::exception { };




#define MVENDORID  0xF11 // MRO Vendor ID.
#define MARCHID    0xF12 // MRO Architecture ID.
#define MIMPID     0xF13 // MRO Implementation ID.
#define MHARTID    0xF14 // MRO Hardware thread ID.Machine Trap Setup
#define MSTATUS    0x300 // MRW Machine status register.
#define MISA       0x301 // MRW ISA and extensions
#define MEDELEG    0x302 // MRW Machine exception delegation register.
#define MIDELEG    0x303 // MRW Machine interrupt delegation register.
#define MIE        0x304 // MRW Machine interrupt-enable register.
#define MTVEC      0x305 // MRW Machine trap-handler base address. Machine Trap Handling
#define MSCRATCH   0x340 // MRW Scratch register for machine trap handlers.
#define MEPC       0x341 // MRW Machine exception program counter.
#define MCAUSE     0x342 // MRW Machine trap cause.
#define MBADADDR   0x343 // MRW Machine bad address.
#define MIP        0x344 // MRW Machine interrupt pending.
#define MBASE      0x380 // MRW Base register.
#define MBOUND     0x381 // MRW Bound register.
#define MIBASE     0x382 // MRW Instruction base register.
#define MIBOUND    0x383 // MRW Instruction bound register.
#define MDBASE     0x384 // MRW Data base register.
#define MDBOUND    0x385 // MRW Data bound register.
#define MCYCLE     0xB00 // MRW Machine cycle counter.
#define MINSTRET   0xB02 // MRW Machine instructions-retired counter.
#define MCYCLEH    0xB80 // MRW Upper 32 bits of mcycle, RV32I only.
#define MINSTRETH  0xB82 // MRW Upper 32 bits of minstret, RV32I only.

class RiscvGolden {
public:
	int32_t pc;
	int32_t regs[32];

	union status {
		uint32_t raw;
		struct {
			uint32_t _1 : 3;
			uint32_t mie : 1;
			uint32_t _2 : 3;
			uint32_t mpie : 1;
			uint32_t _3 : 3;
			uint32_t mpp : 2;
		};
	}__attribute__((packed)) status;


	union mip {
		uint32_t raw;
		struct {
			uint32_t _1 : 3;
			uint32_t msip : 1;
			uint32_t _2 : 3;
			uint32_t mtip : 1;
			uint32_t _3 : 3;
			uint32_t meip : 2;
		};
	}__attribute__((packed)) mip;


	union mie {
		uint32_t raw;
		struct {
			uint32_t _1 : 3;
			uint32_t msie : 1;
			uint32_t _2 : 3;
			uint32_t mtie : 1;
			uint32_t _3 : 3;
			uint32_t meie : 2;
		};
	}__attribute__((packed)) mie;

	union mtvec {
		uint32_t raw;
		struct {
			uint32_t _1 : 2;
			uint32_t base : 30;
		};
	}__attribute__((packed)) mtvec;


	union mcause {
		uint32_t raw;
		struct {
			uint32_t exceptionCode : 31;
			uint32_t interrupt : 1;
		};
	}__attribute__((packed)) mcause;


    //Machine CSR
//    misaAccess(CSR.MISA, xlen-2 -> misa.base , 0 -> misa.extensions)
//    READ_ONLY(CSR.MIP, 11 -> mip.MEIP, 7 -> mip.MTIP)
//    READ_WRITE(CSR.MIP, 3 -> mip.MSIP)
//    READ_WRITE(CSR.MIE, 11 -> mie.MEIE, 7 -> mie.MTIE, 3 -> mie.MSIE)
//
//    mtvecAccess(CSR.MTVEC, mtvec)
//    mepcAccess(CSR.MEPC, mepc)
//    READ_WRITE(CSR.MSTATUS,11 -> mstatus.MPP, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
//    if(mscratchGen) READ_WRITE(CSR.MSCRATCH, mscratch)
//    mcauseAccess(CSR.MCAUSE, xlen-1 -> mcause.interrupt, 0 -> mcause.exceptionCode)
//    mbadaddrAccess(CSR.MBADADDR, mbadaddr)
    //READ_WRITE(CSR.MSTATUS,11 -> mstatus.MPP, 7 -> mstatus.MPIE, 3 -> mstatus.MIE)
	RiscvGolden() {
		pc = 0x80000000;
		regs[0] = 0;
		for (int i = 0; i < 32; i++)
			regs[i] = 0;

		status.raw = 0;
		mip.raw = 0;
		mie.raw = 0;
		mtvec.raw = 0;
		mcause.raw = 0;
		mbadaddr = 0;
		mepc = 0;
		status.mpp = 3;
	}

	virtual void rfWrite(int32_t address, int32_t data) {
		if (address != 0)
			regs[address] = data;
	}

	virtual void pcWrite(int32_t target) {
		pc = target;
	}
	uint32_t mbadaddr;
	uint32_t mepc;

	virtual bool iRead(int32_t address, uint32_t *data) = 0;
	virtual bool dRead(int32_t address, int32_t size, uint32_t *data) = 0;
	virtual void dWrite(int32_t address, int32_t size, uint32_t data) = 0;

	void exception(bool interrupt,int32_t cause) {
		mcause.interrupt = interrupt;
		mcause.exceptionCode = cause;
        status.mie  = false;
        status.mpie = status.mie;
        mepc = pc;
		pcWrite(mtvec.base << 2);
		if(interrupt) livenessInterrupt = 0;

        //status.MPP  := privilege
	}

	virtual void fail() {
	}
	virtual void decodingError() {
		cout << "decoding error" << endl;
		fail();
	}

	uint32_t* csrPtr(int32_t csr){
		switch(csr){
		case MSTATUS: return &status.raw; break;
		case MIP: return &mip.raw; break;
		case MIE: return &mie.raw; break;
		case MTVEC: return &mtvec.raw; break;
		case MCAUSE: return &mcause.raw; break;
		case MBADADDR: return &mbadaddr; break;
		case MEPC: return &mepc; break;
		default: fail(); break;
		}
	}

	virtual uint32_t csrRead(int32_t csr){
		return *csrPtr(csr);
	}

	virtual void csrWrite(int32_t csr, uint32_t value){
		*csrPtr(csr) = value;
	}

    
    int livenessStep = 0;
    int livenessInterrupt = 0;
    virtual void liveness(bool mIntTimer, bool mIntExt){
        livenessStep++;
        bool interruptRequest = (mie.mtie && mIntTimer);
        if(interruptRequest){
            if(status.mie){
                livenessInterrupt++;
            }
        } else {
             livenessInterrupt = 0;
        }

        if(livenessStep > 1000){
            cout << "Liveness step failure" << endl;
            fail();
        }
        
        if(livenessInterrupt > 1000){
            cout << "Liveness interrupt failure" << endl;
            fail();
        }
        
    }


	virtual void step() {
	    livenessStep = 0;
		#define rd32 ((i >> 7) & 0x1F)
		#define iBits(lo,  len) ((i >> lo) & ((1 << len)-1))
		#define iBitsSigned(lo, len) int32_t(i) << (32-lo-len) >> (32-len)
		#define iSign() iBitsSigned(31, 1)
		#define i32_rs1 regs[(i >> 15) & 0x1F]
		#define i32_rs2 regs[(i >> 20) & 0x1F]
		#define i32_i_imm (int32_t(i) >> 20)
		#define i32_s_imm  (iBits(7, 5) + (iBitsSigned(25, 7) << 5))
		#define i32_shamt ((i >> 20) & 0x1F)
		#define i32_sb_imm ((iBits(8, 4) << 1) + (iBits(25,6) << 5) + (iBits(7,1) << 11) + (iSign() << 12))
		#define i32_csr iBits(20, 12)
		#define i32_func3 iBits(12, 3)
		#define i16_addi4spn_imm ((iBits(6, 1) << 2) + (iBits(5, 1) << 3) + (iBits(11, 2) << 4) + (iBits(7, 4) << 6))
		#define i16_lw_imm ((iBits(6, 1) << 2) + (iBits(10, 3) << 3) + (iBits(5, 1) << 6))
		#define i16_addr2 (iBits(2,3) + 8)
		#define i16_addr1 (iBits(7,3) + 8)
		#define i16_rf1 regs[i16_addr1]
		#define i16_rf2 regs[i16_addr2]
		#define rf_sp regs[2]
		#define i16_imm (iBits(2, 5) + (iBitsSigned(12, 1) << 5))
		#define i16_j_imm ((iBits(3, 3) << 1) + (iBits(11, 1) << 4) + (iBits(2, 1) << 5) + (iBits(7, 1) << 6) + (iBits(6, 1) << 7) + (iBits(9, 2) << 8) + (iBits(8, 1) << 10) + (iBitsSigned(12, 1) << 11))
		#define i16_addi16sp_imm ((iBits(6, 1) << 4) + (iBits(2, 1) << 5) + (iBits(5, 1) << 6) + (iBits(3, 2) << 7) + (iBitsSigned(12, 1) << 9))
		#define i16_zimm (iBits(2, 5))
		#define i16_b_imm ((iBits(3, 2) << 1) + (iBits(10, 2) << 3) + (iBits(2, 1) << 5) + (iBits(5, 2) << 6) + (iBitsSigned(12, 1) << 8))
		#define i16_lwsp_imm ((iBits(4, 3) << 2) + (iBits(12, 1) << 5) + (iBits(2, 2) << 6))
		#define i16_swsp_imm ((iBits(9, 4) << 2) + (iBits(7, 2) << 6))
		uint32_t i;
		uint32_t u32Buf;
		if (pc & 2) {
			iRead(pc - 2, &i);
			i >>= 16;
			if (i & 3 == 3) {
				uint32_t u32Buf;
				iRead(pc + 2, &u32Buf);
				i |= u32Buf << 16;
			}
		} else {
			iRead(pc, &i);
		}
		if ((i & 0x3) == 0x3) {
			//32 bit
			switch (i & 0x7F) {
			case 0x37:rfWrite(rd32, i & 0xFFFFF000);pcWrite(pc + 4);break; // LUI
			case 0x17:rfWrite(rd32, (i & 0xFFFFF000) + pc);pcWrite(pc + 4);break; //AUIPC
			case 0x6F:rfWrite(rd32, pc + 4);pcWrite(pc + (iBits(21, 10) << 1) + (iBits(20, 1) << 11) + (iBits(12, 8) << 12) + (iSign() << 20));break; //JAL
			case 0x67:{
				uint32_t target = (i32_rs1 + i32_i_imm) & ~1;
				rfWrite(rd32, pc + 4);
				pcWrite(target);
			} break; //JALR
			case 0x63:
				switch ((i >> 12) & 0x7) {
				case 0x0:if (i32_rs1 == i32_rs2)pcWrite(pc + i32_sb_imm);else pcWrite(pc + 4);break;
				case 0x1:if (i32_rs1 != i32_rs2)pcWrite(pc + i32_sb_imm);else pcWrite(pc + 4);break;
				case 0x4:if (i32_rs1 < i32_rs2)pcWrite(pc + i32_sb_imm); else pcWrite(pc + 4);break;
				case 0x5:if (i32_rs1 >= i32_rs2)pcWrite(pc + i32_sb_imm);else pcWrite(pc + 4);break;
				case 0x6:if (uint32_t(i32_rs1) < uint32_t(i32_rs2)) pcWrite(pc + i32_sb_imm); else pcWrite(pc + 4);break;
				case 0x7:if (uint32_t(i32_rs1) >= uint32_t(i32_rs2))pcWrite(pc + i32_sb_imm); else pcWrite(pc + 4);break;
				}
				break;
			case 0x03: //LOADS
				uint32_t data;
				dRead(i32_rs1 + i32_i_imm, 1 << ((i >> 12) & 0x3), &data);
				switch ((i >> 12) & 0x7) {
				case 0x0:rfWrite(rd32, int8_t(data));pcWrite(pc + 4);break;
				case 0x1:rfWrite(rd32, int16_t(data));pcWrite(pc + 4);break;
				case 0x2:rfWrite(rd32, int32_t(data));pcWrite(pc + 4);break;
				case 0x4:rfWrite(rd32, uint8_t(data));pcWrite(pc + 4);break;
				case 0x5:rfWrite(rd32, uint16_t(data));pcWrite(pc + 4);break;
				}
				break;
			case 0x23: //STORE
				switch ((i >> 12) & 0x7) {
				case 0x0:dWrite(i32_rs1 + i32_s_imm, 1, i32_rs2);pcWrite(pc + 4);break;
				case 0x1:dWrite(i32_rs1 + i32_s_imm, 2, i32_rs2);pcWrite(pc + 4);break;
				case 0x2:dWrite(i32_rs1 + i32_s_imm, 4, i32_rs2);pcWrite(pc + 4);break;
				}
				break;
			case 0x13: //ALUi
				switch ((i >> 12) & 0x7) {
				case 0x0:rfWrite(rd32, i32_rs1 + i32_i_imm);pcWrite(pc + 4);break;
				case 0x1:
					switch ((i >> 25) & 0x7F) {
					case 0x00:rfWrite(rd32, i32_rs1 << i32_shamt);pcWrite(pc + 4);break;
					}
					break;
				case 0x2:rfWrite(rd32, i32_rs1 < i32_i_imm);pcWrite(pc + 4);break;
				case 0x3:rfWrite(rd32, uint32_t(i32_rs1) < uint32_t(i32_i_imm));pcWrite(pc + 4);break;
				case 0x4:rfWrite(rd32, i32_rs1 ^ i32_i_imm);pcWrite(pc + 4);break;
				case 0x5:
					switch ((i >> 25) & 0x7F) {
					case 0x00:rfWrite(rd32, uint32_t(i32_rs1) >> i32_shamt);pcWrite(pc + 4);break;
					case 0x20:rfWrite(rd32, i32_rs1 >> i32_shamt);pcWrite(pc + 4);break;
					}
					break;
				case 0x6:rfWrite(rd32, i32_rs1 | i32_i_imm);pcWrite(pc + 4);break;
				case 0x7:	rfWrite(rd32, i32_rs1 & i32_i_imm);pcWrite(pc + 4);break;
				}
				break;
			case 0x33: //ALU
				if (((i >> 25) & 0x7F) == 0x01) {
					switch ((i >> 12) & 0x7) {
					case 0x0:rfWrite(rd32, int32_t(i32_rs1) * int32_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x1:rfWrite(rd32,(int64_t(i32_rs1) * int64_t(i32_rs2)) >> 32);pcWrite(pc + 4);break;
					case 0x2:rfWrite(rd32,(int64_t(i32_rs1) * uint64_t(uint32_t(i32_rs2)))>> 32);pcWrite(pc + 4);break;
					case 0x3:rfWrite(rd32,(uint64_t(uint32_t(i32_rs1)) * uint64_t(uint32_t(i32_rs2))) >> 32);pcWrite(pc + 4);break;
					case 0x4:rfWrite(rd32,i32_rs2 == 0 ? -1 : int32_t(i32_rs1) / int32_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x5:rfWrite(rd32,i32_rs2 == 0 ? -1 : uint32_t(i32_rs1) / uint32_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x6:rfWrite(rd32,i32_rs2 == 0 ? i32_rs1 : int32_t(i32_rs1)% int32_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x7:rfWrite(rd32,i32_rs2 == 0 ? i32_rs1 : uint32_t(i32_rs1) % uint32_t(i32_rs2));pcWrite(pc + 4);break;
					}
				} else {
					switch ((i >> 12) & 0x7) {
					case 0x0:
						switch ((i >> 25) & 0x7F) {
						case 0x00:rfWrite(rd32, i32_rs1 + i32_rs2);pcWrite(pc + 4);break;
						case 0x20:rfWrite(rd32, i32_rs1 - i32_rs2);pcWrite(pc + 4);break;
						}
						break;
					case 0x1:rfWrite(rd32, i32_rs1 << (i32_rs2 & 0x1F));pcWrite(pc + 4);break;
					case 0x2:rfWrite(rd32, i32_rs1 < i32_rs2);pcWrite(pc + 4);break;
					case 0x3:rfWrite(rd32, uint32_t(i32_rs1) < uint32_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x4:rfWrite(rd32, i32_rs1 ^ i32_rs2);pcWrite(pc + 4);break;
					case 0x5:
						switch ((i >> 25) & 0x7F) {
						case 0x00:rfWrite(rd32, uint32_t(i32_rs1) >> (i32_rs2 & 0x1F));pcWrite(pc + 4);break;
						case 0x20:rfWrite(rd32, i32_rs1 >> (i32_rs2 & 0x1F));pcWrite(pc + 4);break;
						}
						break;
					case 0x6:rfWrite(rd32, i32_rs1 | i32_rs2);pcWrite(pc + 4);break;
					case 0x7:rfWrite(rd32, i32_rs1 & i32_rs2); pcWrite(pc + 4);break;
					}
				}
				break;
			case 0x73:{
				if(i32_func3 == 0){

					switch(i){
					case 0x30200073:{ //MRET
				          status.mie = status.mpie;
				          //privilege := mstatus.MPP
				          pcWrite(mepc);
						}break;
					}
				} else {
					//CSR
					uint32_t input = (i & 0x4000) ? ((i >> 15) & 0x1F) : i32_rs1;
					uint32_t clear, set;
					bool write;
					switch ((i >> 12) & 0x3) {
					case 1: clear = ~0; set = input; write = true; break;
					case 2: clear = 0; set = input; write = ((i >> 15) & 0x1F) != 0; break;
					case 3: clear = input; set = 0; write = ((i >> 15) & 0x1F) != 0; break;
					}
					uint32_t csrAddress = i32_csr;
					uint32_t old = csrRead(i32_csr);
					rfWrite(rd32, old);
					if(write) csrWrite(i32_csr, (old & ~clear) | set);
					pcWrite(pc + 4);
				}
				break;
			}
			default: decodingError(); break;
			}
		} else {
			switch((iBits(0, 2) << 3) + iBits(13, 3)){
			case 0: rfWrite(i16_addr2, rf_sp + i16_addi4spn_imm); pcWrite(pc + 2); break;
			case 2:  {
				uint32_t data;
				dRead(i16_rf1 + i16_lw_imm, 4, &data);
				rfWrite(i16_addr2, data); pcWrite(pc + 2);
				break;
			}
			case 6: dWrite(i16_rf1 + i16_lw_imm, 4, i16_rf2); pcWrite(pc + 2); break;
			case 8: rfWrite(rd32, regs[rd32] + i16_imm); pcWrite(pc + 2); break;
			case 9: rfWrite(1, pc + 2);pcWrite(pc + i16_j_imm); break;
			case 10: rfWrite(rd32, i16_imm);pcWrite(pc + 2); break;
			case 11:
				if(rd32 == 2) { rfWrite(2, rf_sp + i16_addi16sp_imm);pcWrite(pc + 2);  }
				else {  		rfWrite(rd32, i16_imm << 12);pcWrite(pc + 2);  } break;
			case 12:
				switch(iBits(10,2)){
				case 0: rfWrite(i16_addr1, uint32_t(i16_rf1) >> i16_zimm); pcWrite(pc + 2);break;
				case 1: rfWrite(i16_addr1, i16_rf1 >> i16_zimm); pcWrite(pc + 2);break;
				case 2: rfWrite(i16_addr1, i16_rf1 & i16_imm); pcWrite(pc + 2);break;
				case 3:
					switch(iBits(5,2)){
					case 0: rfWrite(i16_addr1, i16_rf1 - i16_rf2); pcWrite(pc + 2);break;
					case 1: rfWrite(i16_addr1, i16_rf1 ^ i16_rf2); pcWrite(pc + 2);break;
					case 2: rfWrite(i16_addr1, i16_rf1 | i16_rf2); pcWrite(pc + 2);break;
					case 3: rfWrite(i16_addr1, i16_rf1 & i16_rf2); pcWrite(pc + 2);break;
					}
					break;
				}
				break;
			case 13: pcWrite(pc + i16_j_imm); break;
			case 14: pcWrite(i16_rf1 == 0 ? pc + i16_b_imm : pc + 2); break;
			case 15: pcWrite(i16_rf1 != 0 ? pc + i16_b_imm : pc + 2); break;
			case 16: rfWrite(rd32, regs[rd32] << i16_zimm); pcWrite(pc + 2); break;
			case 18:{
				uint32_t data;
				dRead(rf_sp + i16_lwsp_imm, 4, &data);
				rfWrite(rd32, data); pcWrite(pc + 2);  break;
			}
			case 20:
				if(i & 0x1000){
					if(iBits(2,10) == 0){

					} else if(iBits(2,5) == 0){
						rfWrite(1, pc + 2); pcWrite(regs[rd32] & ~1);
					} else {
						rfWrite(rd32, regs[rd32] + regs[iBits(2,5)]); pcWrite(pc + 2);
					}
				} else {
					if(iBits(2,5) == 0){
						pcWrite(regs[rd32] & ~1);
					} else {
						rfWrite(rd32, regs[iBits(2,5)]); pcWrite(pc + 2);
					}
				}
				break;
			case 22: dWrite(rf_sp + i16_swsp_imm, 4, regs[iBits(2,5)]); pcWrite(pc + 2); break;
			}
		}
	}
};


class SimElement{
public:
	virtual ~SimElement(){}
	virtual void onReset(){}
	virtual void postReset(){}
	virtual void preCycle(){}
	virtual void postCycle(){}
};



class Workspace;

class Workspace{
public:
	static mutex staticMutex;
	static uint32_t testsCounter, successCounter;
	static uint64_t cycles;
	uint64_t instanceCycles = 0;
	vector<SimElement*> simElements;
	Memory mem;
	string name;
	uint64_t currentTime = 22;
	uint64_t mTimeCmp = 0;
	uint64_t mTime = 0;
	VVexRiscv* top;
	bool resetDone = false;
	bool riscvRefEnable = false;
	uint64_t i;
	double cyclesPerSecond = 10e6;
	double allowedCycles = 0.0;
	uint32_t bootPc = -1;
	uint32_t iStall = STALL,dStall = STALL;
	#ifdef TRACE
	VerilatedVcdC* tfp;
	#endif

	uint32_t seed;

	bool withInstructionReadCheck = true;
	void setIStall(bool enable) { iStall = enable; }
	void setDStall(bool enable) { dStall = enable; }

	ofstream regTraces;
	ofstream memTraces;
	ofstream logTraces;

	struct timespec start_time;

    class CpuRef : public RiscvGolden{
    public:
    	Memory mem;

    	class MemWrite {
    	public:
    		int32_t address, size;
    		uint32_t data;
    	};

    	class MemRead {
    	public:
    		int32_t address, size;
    		uint32_t data;
    		bool error;
    	};

        uint32_t periphWriteTimer = 0;
    	queue<MemWrite> periphWritesGolden;
    	queue<MemWrite> periphWrites;
    	queue<MemRead> periphRead;
    	Workspace *ws;
    	CpuRef(Workspace *ws){
			this->ws = ws;
    	}

    	virtual void fail() { ws->fail(); }

    	bool rfWriteValid;
    	int32_t rfWriteAddress;
    	int32_t rfWriteData;
        virtual void rfWrite(int32_t address, int32_t data){
        	rfWriteValid = address != 0;
        	rfWriteAddress = address;
        	rfWriteData = data;
        	RiscvGolden::rfWrite(address,data);
        }


        virtual bool iRead(int32_t address, uint32_t *data){
        	mem.read(address, 4, (uint8_t*)data);
        	bool error;
    		ws->iBusAccessPatch(address,data,&error);
        }
        virtual bool dRead(int32_t address, int32_t size, uint32_t *data){
            if(address & (size-1) != 0) cout << "Ref did a unaligned read" << endl;
    		if((address & 0xF0000000) == 0xF0000000){
				MemRead t = periphRead.front();
				if(t.address != address || t.size != size){
					fail();
				}
				*data = t.data;
				periphRead.pop();
    		}else {
            	mem.read(address, size, (uint8_t*)data);
    		}
        }
        virtual void dWrite(int32_t address, int32_t size, uint32_t data){
            if(address & (size-1) != 0) cout << "Ref did a unaligned write" << endl;
    		if((address & 0xF0000000) == 0xF0000000){
				MemWrite w;
				w.address = address;
				w.size = size;
				w.data = data;
				periphWritesGolden.push(w);
    		}else {
    			mem.write(address, size, (uint8_t*)&data);
    		}
        }


        void step() {
        	rfWriteValid = false;
        	RiscvGolden::step();

        	switch(periphWrites.empty() + uint32_t(periphWritesGolden.empty())*2){
        	case 3: periphWriteTimer = 0; break;
        	case 1: case 2: if(periphWriteTimer++ == 20){
        		cout << "periphWrite timout" << endl; fail();
        	} break;
        	case 0:
    			MemWrite t = periphWrites.front();
    			MemWrite t2 = periphWritesGolden.front();
    			if(t.address != t2.address || t.size != t2.size || t.data != t2.data){
    				cout << "periphWrite missmatch" << endl;
    				fail();
    			}
    			periphWrites.pop();
    			periphWritesGolden.pop();
    			periphWriteTimer = 0;
    			break;
        	}


        }
    };

	CpuRef riscvRef = CpuRef(this);

	Workspace(string name){
	    //seed = VL_RANDOM_I(32)^VL_RANDOM_I(32)^0x1093472;
	    //srand48(seed);
    //    setIStall(false);
   //     setDStall(false);
		staticMutex.lock();
		testsCounter++;
		staticMutex.unlock();
		this->name = name;
		top = new VVexRiscv;
		#ifdef TRACE_ACCESS
			regTraces.open (name + ".regTrace");
			memTraces.open (name + ".memTrace");
		#endif
		logTraces.open (name + ".logTrace");
		fillSimELements();
		clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start_time);
	}

	virtual ~Workspace(){
		delete top;
		#ifdef TRACE
		delete tfp;
		#endif

		for(SimElement* simElement : simElements) {
			delete simElement;
		}
	}

	Workspace* loadHex(string path){
		loadHexImpl(path,&mem);
		loadHexImpl(path,&riscvRef.mem);
		return this;
	}

	Workspace* setCyclesPerSecond(double value){
		cyclesPerSecond = value;
		return this;
	}

    Workspace* bootAt(uint32_t pc) {
    	bootPc = pc;
    	riscvRef.pc = pc;
		return this;
    }

    Workspace* withRiscvRef(){
    	riscvRefEnable = true;
		return this;
    }

	void iBusAccess(uint32_t addr, uint32_t *data, bool *error) {
		if(addr % 4 != 0) {
			//cout << "Warning, unaligned IBusAccess : " << addr << endl;
		//	fail();
		}
		*data =     (  (mem[addr + 0] << 0)
					 | (mem[addr + 1] << 8)
					 | (mem[addr + 2] << 16)
					 | (mem[addr + 3] << 24));
		*error = addr == 0xF00FFF60u;
		iBusAccessPatch(addr,data,error);
	}

	virtual void iBusAccessPatch(uint32_t addr, uint32_t *data, bool *error){}

	virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size,uint32_t mask, uint32_t *data, bool *error) {
		assertEq(addr % (1 << size), 0);
		*error = addr == 0xF00FFF60u;
		if(wr){
			memTraces <<
			#ifdef TRACE_WITH_TIME
			(currentTime
			#ifdef REF
			-2
			 #endif
			 ) <<
			 #endif
			 " : WRITE mem" << (1 << size) << "[" << addr << "] = " << *data << endl;
			for(uint32_t b = 0;b < (1 << size);b++){
				uint32_t offset = (addr+b)&0x3;
				if((mask >> offset) & 1 == 1)
					*mem.get(addr + b) = *data >> (offset*8);
			}

			switch(addr){
			case 0xF0010000u: {
				cout << mem[0xF0010000u];
				logTraces << (char)mem[0xF0010000u];
				break;
			}
			case 0xF00FFF00u: {
				cout << mem[0xF00FFF00u];
				logTraces << (char)mem[0xF00FFF00u];
				break;
			}
			#ifndef DEBUG_PLUGIN_EXTERNAL
			case 0xF00FFF20u:
				if(*data == 0)
					pass();
				else
					fail();
				break;
			case 0xF00FFF24u:
					cout << "TEST ERROR CODE " << *data << endl;
					fail();
				break;
			#endif
			case 0xF00FFF48u: mTimeCmp = (mTimeCmp & 0xFFFFFFFF00000000) | *data;break;
			case 0xF00FFF4Cu: mTimeCmp = (mTimeCmp & 0x00000000FFFFFFFF) | (((uint64_t)*data) << 32);  /*cout << "mTimeCmp <= " << mTimeCmp << endl; */break;
			}
		}else{
			*data = VL_RANDOM_I(32);
			for(uint32_t b = 0;b < (1 << size);b++){
				uint32_t offset = (addr+b)&0x3;
				*data &= ~(0xFF << (offset*8));
				*data |= mem[addr + b] << (offset*8);
			}
			switch(addr){
			case 0xF00FFF10u:
				*data = mTime;
				#ifdef REF_TIME
				mTime += 100000;
				#endif
				break;
			case 0xF00FFF40u: *data = mTime;		  break;
			case 0xF00FFF44u: *data = mTime >> 32;    break;
			case 0xF00FFF48u: *data = mTimeCmp;       break;
			case 0xF00FFF4Cu: *data = mTimeCmp >> 32; break;
			case 0xF0010004u: *data = ~0;		      break;
			}
			memTraces <<
			#ifdef TRACE_WITH_TIME
			(currentTime
			#ifdef REF
			-2
			 #endif
			 ) <<
			 #endif
			  " : READ  mem" << (1 << size) << "[" << addr << "] = " << *data << endl;

		}

		if((addr & 0xF0000000) == 0xF0000000){
			if(wr){
				CpuRef::MemWrite w;
				w.address = addr;
				w.size = 1 << size;
				w.data = *data;
				riscvRef.periphWrites.push(w);
			} else {
				CpuRef::MemRead r;
				r.address = addr;
				r.size = 1 << size;
				r.data = *data;
				r.error = *error;
				riscvRef.periphRead.push(r);
			}
		}
	}
	virtual void postReset() {}
	virtual void checks(){}
	virtual void pass(){ throw success();}
	virtual void fail(){ throw std::exception();}
    virtual void fillSimELements();
    Workspace* noInstructionReadCheck(){withInstructionReadCheck = false; return this;}
	void dump(int i){
		#ifdef TRACE
		if(i >= TRACE_START) tfp->dump(i);
		#endif
	}
	Workspace* run(uint64_t timeout = 5000){
//		cout << "Start " << name << endl;

		currentTime = 4;
		// init trace dump
		#ifdef TRACE
		Verilated::traceEverOn(true);
		tfp = new VerilatedVcdC;
		top->trace(tfp, 99);
		tfp->open((string(name)+ ".vcd").c_str());
		#endif

		// Reset
		top->clk = 0;
		top->reset = 0;


		top->eval(); currentTime = 3;
		for(SimElement* simElement : simElements) simElement->onReset();

		top->reset = 1;
		top->eval();
		top->clk = 1;
		top->eval();
		top->clk = 0;
		top->eval();
		#ifdef CSR
		top->timerInterrupt = 0;
		top->externalInterrupt = 1;
		#endif
		#ifdef DEBUG_PLUGIN_EXTERNAL
		top->timerInterrupt = 0;
		top->externalInterrupt = 0;
		#endif
		dump(0);
		top->reset = 0;
		for(SimElement* simElement : simElements) simElement->postReset();

		top->eval(); currentTime = 2;


		postReset();

        //Sync register file initial content
        for(int i = 1;i < 32;i++){
            riscvRef.regs[i] = top->VexRiscv->RegFilePlugin_regFile[i];
        }
		resetDone = true;

		#ifdef  REF
		if(bootPc != -1) top->VexRiscv->core->prefetch_pc = bootPc;
		#else
		if(bootPc != -1) {
		    #if defined(IBUS_SIMPLE) || defined(IBUS_SIMPLE_WISHBONE)
                top->VexRiscv->IBusSimplePlugin_fetchPc_pcReg = bootPc;
                #ifdef COMPRESSED
                top->VexRiscv->IBusSimplePlugin_decodePc_pcReg = bootPc;
                #endif
            #else
                top->VexRiscv->IBusCachedPlugin_fetchPc_pcReg = bootPc;
                #ifdef COMPRESSED
                top->VexRiscv->IBusCachedPlugin_decodePc_pcReg = bootPc;
                #endif
            #endif
		}
		#endif

        bool failed = false;
		try {
			// run simulation for 100 clock periods
			for (i = 16; i < timeout*2; i+=2) {
				while(allowedCycles <= 0.0){
					struct timespec end_time;
					clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_time);
					uint64_t diffInNanos = end_time.tv_sec*1e9 + end_time.tv_nsec -  start_time.tv_sec*1e9 - start_time.tv_nsec;
					start_time = end_time;
					double dt = diffInNanos*1e-9;
					allowedCycles += dt*cyclesPerSecond;
					if(allowedCycles > cyclesPerSecond/100) allowedCycles = cyclesPerSecond/100;
				}
				allowedCycles-=1.0;


				#ifndef REF_TIME
                #ifndef MTIME_INSTR_FACTOR
                mTime = i/2;
                #else
				mTime += top->VexRiscv->writeBack_arbitration_isFiring*MTIME_INSTR_FACTOR;
                #endif
				#endif
				#ifdef TIMER_INTERRUPT
				top->timerInterrupt = mTime >= mTimeCmp ? 1 : 0;
				//if(mTime == mTimeCmp) printf("SIM timer tick\n");
				#endif

				currentTime = i;




				// dump variables into VCD file and toggle clock

				dump(i);
				//top->eval();
				top->clk = 0;
				top->eval();

				#ifdef CSR
					if(top->VexRiscv->CsrPlugin_interruptJump){
						if(riscvRefEnable) riscvRef.exception(true, top->VexRiscv->CsrPlugin_interruptCode);
					}
				#endif
                if(top->VexRiscv->writeBack_arbitration_isFiring){
                   	if(riscvRefEnable && top->VexRiscv->writeBack_PC != riscvRef.pc){
						cout << " pc missmatch " << top->VexRiscv->writeBack_PC << " should be " << riscvRef.pc << endl;
						fail();
					}

                   	if(riscvRefEnable) {
                   	    riscvRef.step();
                   	    bool mIntTimer = false;
                   	    bool mIntExt = false;

#ifdef TIMER_INTERRUPT
                   	    mIntTimer = top->timerInterrupt;
#endif
#ifdef EXTERNAL_INTERRUPT
                   	    mIntExt = top->externalInterrupt;
#endif


                   	    riscvRef.liveness(mIntTimer, mIntExt);
                   	}



                	bool rfWriteValid = false;
                	int32_t rfWriteAddress;
                	int32_t rfWriteData;

                    if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
                    	rfWriteValid = true;
                    	rfWriteAddress = top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address;
                    	rfWriteData = top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data;
                        regTraces <<
                            #ifdef TRACE_WITH_TIME
                            currentTime <<
                             #endif
                             " PC " << hex << setw(8) <<  top->VexRiscv->writeBack_PC << " : reg[" << dec << setw(2) << (uint32_t)top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address << "] = " << hex << setw(8) << top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data << endl;
                    } else {
                        regTraces <<
                                #ifdef TRACE_WITH_TIME
                                currentTime <<
                                 #endif
                                 " PC " << hex << setw(8) <<  top->VexRiscv->writeBack_PC << endl;
                    }
					if(riscvRefEnable) if(rfWriteValid != riscvRef.rfWriteValid ||
						(rfWriteValid && (rfWriteAddress!= riscvRef.rfWriteAddress || rfWriteData!= riscvRef.rfWriteData))){
                    	cout << "regFile write missmatch at " << endl;
                    	fail();
                    }
                }

				for(SimElement* simElement : simElements) simElement->preCycle();

				dump(i + 1);

                #ifndef COMPRESSED
				if(withInstructionReadCheck){
					if(top->VexRiscv->decode_arbitration_isValid && !top->VexRiscv->decode_arbitration_haltItself && !top->VexRiscv->decode_arbitration_flushAll){
						uint32_t expectedData;
						bool dummy;
						iBusAccess(top->VexRiscv->decode_PC, &expectedData, &dummy);
						assertEq(top->VexRiscv->decode_INSTRUCTION,expectedData);
					}
				}
				#endif

				checks();
				//top->eval();
				top->clk = 1;
				top->eval();

				instanceCycles += 1;

				for(SimElement* simElement : simElements) simElement->postCycle();



				if (Verilated::gotFinish())
					exit(0);
			}
			cout << "timeout" << endl;
			fail();
		} catch (const success e) {
			staticMutex.lock();
			cout <<"SUCCESS " << name <<  endl;
			successCounter++;
			cycles += instanceCycles;
			staticMutex.unlock();
		} catch (const std::exception& e) {
			staticMutex.lock();
			cout << "FAIL " <<  name << " at PC=" << hex << setw(8) << top->VexRiscv->writeBack_PC << endl; //<<  " seed : " << seed <<
			cycles += instanceCycles;
			staticMutex.unlock();
			failed = true;
		}



		dump(i);
		dump(i+10);
		#ifdef TRACE
		tfp->close();
		#endif
        #ifdef STOP_ON_ERROR
            if(failed){
                sleep(1);
                exit(-1);
            }
        #endif
		return this;
	}
};



#ifdef IBUS_SIMPLE
class IBusSimple : public SimElement{
public:
	uint32_t pendings[256];
	uint32_t rPtr = 0, wPtr = 0;

	Workspace *ws;
	VVexRiscv* top;
	IBusSimple(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->iBus_cmd_ready = 1;
		top->iBus_rsp_valid = 0;
	}

	virtual void preCycle(){
		if (top->iBus_cmd_valid && top->iBus_cmd_ready) {
			//assertEq(top->iBus_cmd_payload_pc & 3,0);
			pendings[wPtr] = (top->iBus_cmd_payload_pc);
			wPtr = (wPtr + 1) & 0xFF;
			//ws->iBusAccess(top->iBus_cmd_payload_pc,&inst_next,&error_next);
		}
	}
	//TODO doesn't catch when instruction removed ?
	virtual void postCycle(){
		top->iBus_rsp_valid = 0;
		if(rPtr != wPtr && (!ws->iStall || VL_RANDOM_I(7) < 100)){
	        uint32_t inst_next;
	        bool error_next;
		    ws->iBusAccess(pendings[rPtr], &inst_next,&error_next);
        	rPtr = (rPtr + 1) & 0xFF;
			top->iBus_rsp_payload_inst = inst_next;
			top->iBus_rsp_valid = 1;
			top->iBus_rsp_payload_error = error_next;
		} else {
		    top->iBus_rsp_payload_inst = VL_RANDOM_I(32);
		    top->iBus_rsp_payload_error = VL_RANDOM_I(1);
		}
		if(ws->iStall) top->iBus_cmd_ready = VL_RANDOM_I(7) < 100;
	}
};
#endif

#ifdef IBUS_SIMPLE_AVALON

struct IBusSimpleAvalonRsp{
	uint32_t data;
	bool error;
};


class IBusSimpleAvalon : public SimElement{
public:
	queue<IBusSimpleAvalonRsp> rsps;

	Workspace *ws;
	VVexRiscv* top;
	IBusSimpleAvalon(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->iBusAvalon_waitRequestn = 1;
		top->iBusAvalon_readDataValid = 0;
	}

	virtual void preCycle(){
		if (top->iBusAvalon_read && top->iBusAvalon_waitRequestn) {
			IBusSimpleAvalonRsp rsp;
			ws->iBusAccess(top->iBusAvalon_address,&rsp.data,&rsp.error);
			rsps.push(rsp);
		}
	}
	//TODO doesn't catch when instruction removed ?
	virtual void postCycle(){
		if(!rsps.empty() && (!ws->iStall || VL_RANDOM_I(7) < 100)){
			IBusSimpleAvalonRsp rsp = rsps.front(); rsps.pop();
			top->iBusAvalon_readDataValid = 1;
			top->iBusAvalon_readData = rsp.data;
			top->iBusAvalon_response = rsp.error ? 3 : 0;
		} else {
			top->iBusAvalon_readDataValid = 0;
			top->iBusAvalon_readData = VL_RANDOM_I(32);
			top->iBusAvalon_response = VL_RANDOM_I(2);
		}
		if(ws->iStall)
			top->iBusAvalon_waitRequestn = VL_RANDOM_I(7) < 100;
	}
};
#endif


#ifdef IBUS_CACHED
class IBusCached : public SimElement{
public:
	bool error_next = false;
	uint32_t pendingCount = 0;
	uint32_t address;

	Workspace *ws;
	VVexRiscv* top;
	IBusCached(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}


	virtual void onReset(){
		top->iBus_cmd_ready = 1;
		top->iBus_rsp_valid = 0;
	}

	virtual void preCycle(){
		if (top->iBus_cmd_valid && top->iBus_cmd_ready && pendingCount == 0) {
			assertEq(top->iBus_cmd_payload_address & 3,0);
			pendingCount = (1 << top->iBus_cmd_payload_size)/4;
			address = top->iBus_cmd_payload_address;
		}
	}

	virtual void postCycle(){
		bool error;
		top->iBus_rsp_valid = 0;
		if(pendingCount != 0 && (!ws->iStall || VL_RANDOM_I(7) < 100)){
			ws->iBusAccess(address,&top->iBus_rsp_payload_data,&error);
			top->iBus_rsp_payload_error = error;
			pendingCount--;
			address = address + 4;
			top->iBus_rsp_valid = 1;
		}
		if(ws->iStall) top->iBus_cmd_ready = VL_RANDOM_I(7) < 100 && pendingCount == 0;
	}
};
#endif

#ifdef IBUS_CACHED_AVALON
#include <queue>

struct IBusCachedAvalonTask{
	uint32_t address;
	uint32_t pendingCount;
};

class IBusCachedAvalon : public SimElement{
public:
	uint32_t inst_next = VL_RANDOM_I(32);
	bool error_next = false;

	queue<IBusCachedAvalonTask> tasks;
	Workspace *ws;
	VVexRiscv* top;

	IBusCachedAvalon(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->iBusAvalon_waitRequestn = 1;
		top->iBusAvalon_readDataValid = 0;
	}

	virtual void preCycle(){
		if (top->iBusAvalon_read && top->iBusAvalon_waitRequestn) {
			assertEq(top->iBusAvalon_address & 3,0);
			IBusCachedAvalonTask task;
			task.address = top->iBusAvalon_address;
			task.pendingCount = top->iBusAvalon_burstCount;
			tasks.push(task);
		}
	}

	virtual void postCycle(){
		bool error;
		top->iBusAvalon_readDataValid = 0;
		if(!tasks.empty() && (!ws->iStall || VL_RANDOM_I(7) < 100)){
			uint32_t &address = tasks.front().address;
			uint32_t &pendingCount = tasks.front().pendingCount;
			bool error;
			ws->iBusAccess(address,&top->iBusAvalon_readData,&error);
			top->iBusAvalon_response = error ? 3 : 0;
			pendingCount--;
			address = (address & ~0x1F) + ((address + 4) & 0x1F);
			top->iBusAvalon_readDataValid = 1;
			if(pendingCount == 0)
				tasks.pop();
		}
		if(ws->iStall)
			top->iBusAvalon_waitRequestn = VL_RANDOM_I(7) < 100;
	}
};
#endif


#if defined(IBUS_CACHED_WISHBONE) || defined(IBUS_SIMPLE_WISHBONE)
#include <queue>

class IBusCachedWishbone : public SimElement{
public:

	Workspace *ws;
	VVexRiscv* top;

	IBusCachedWishbone(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->iBusWishbone_ACK = !ws->iStall;
		top->iBusWishbone_ERR = 0;
	}

	virtual void preCycle(){

	}

	virtual void postCycle(){

		if(ws->iStall)
			top->iBusWishbone_ACK = VL_RANDOM_I(7) < 100;

        top->iBusWishbone_DAT_MISO = VL_RANDOM_I(32);
        if (top->iBusWishbone_CYC && top->iBusWishbone_STB && top->iBusWishbone_ACK) {
            if(top->iBusWishbone_WE){

            } else {
                bool error;
                ws->iBusAccess(top->iBusWishbone_ADR << 2,&top->iBusWishbone_DAT_MISO,&error);
                top->iBusWishbone_ERR = error;
            }
        }
	}
};
#endif


#ifdef DBUS_SIMPLE
class DBusSimple : public SimElement{
public:
	uint32_t data_next = VL_RANDOM_I(32);
	bool error_next = false;
	bool pending = false;

	Workspace *ws;
	VVexRiscv* top;
	DBusSimple(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBus_cmd_ready = 1;
		top->dBus_rsp_ready = 1;
	}

	virtual void preCycle(){
		if (top->dBus_cmd_valid && top->dBus_cmd_ready) {
			pending = true;
			data_next = top->dBus_cmd_payload_data;
			ws->dBusAccess(top->dBus_cmd_payload_address,top->dBus_cmd_payload_wr,top->dBus_cmd_payload_size,0xF,&data_next,&error_next);
		}
	}

	virtual void postCycle(){
		top->dBus_rsp_ready = 0;
		if(pending && (!ws->dStall || VL_RANDOM_I(7) < 100)){
			pending = false;
			top->dBus_rsp_ready = 1;
			top->dBus_rsp_data = data_next;
			top->dBus_rsp_error = error_next;
		} else{
			top->dBus_rsp_data = VL_RANDOM_I(32);
		}

		if(ws->dStall) top->dBus_cmd_ready = VL_RANDOM_I(7) < 100 && !pending;
	}
};
#endif

#ifdef DBUS_SIMPLE_AVALON
#include <queue>
struct DBusSimpleAvalonRsp{
	uint32_t data;
	bool error;
};


class DBusSimpleAvalon : public SimElement{
public:
	queue<DBusSimpleAvalonRsp> rsps;

	Workspace *ws;
	VVexRiscv* top;
	DBusSimpleAvalon(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBusAvalon_waitRequestn = 1;
		top->dBusAvalon_readDataValid = 0;
	}

	virtual void preCycle(){
		if (top->dBusAvalon_write && top->dBusAvalon_waitRequestn) {
			bool dummy;
			ws->dBusAccess(top->dBusAvalon_address,1,2,top->dBusAvalon_byteEnable,&top->dBusAvalon_writeData,&dummy);
		}
		if (top->dBusAvalon_read && top->dBusAvalon_waitRequestn) {
			DBusSimpleAvalonRsp rsp;
			ws->dBusAccess(top->dBusAvalon_address,0,2,0xF,&rsp.data,&rsp.error);
			rsps.push(rsp);
		}
	}
	//TODO doesn't catch when instruction removed ?
	virtual void postCycle(){
		if(!rsps.empty() && (!ws->iStall || VL_RANDOM_I(7) < 100)){
			DBusSimpleAvalonRsp rsp = rsps.front(); rsps.pop();
			top->dBusAvalon_readDataValid = 1;
			top->dBusAvalon_readData = rsp.data;
			top->dBusAvalon_response = rsp.error ? 3 : 0;
		} else {
			top->dBusAvalon_readDataValid = 0;
			top->dBusAvalon_readData = VL_RANDOM_I(32);
			top->dBusAvalon_response = VL_RANDOM_I(2);
		}
		if(ws->iStall)
			top->dBusAvalon_waitRequestn = VL_RANDOM_I(7) < 100;
	}
};
#endif

#if defined(DBUS_CACHED_WISHBONE) || defined(DBUS_SIMPLE_WISHBONE)
#include <queue>


class DBusCachedWishbone : public SimElement{
public:

	Workspace *ws;
	VVexRiscv* top;

	DBusCachedWishbone(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBusWishbone_ACK = !ws->iStall;
		top->dBusWishbone_ERR = 0;
	}

	virtual void preCycle(){

	}

	virtual void postCycle(){
		if(ws->iStall)
			top->dBusWishbone_ACK = VL_RANDOM_I(7) < 100;
        top->dBusWishbone_DAT_MISO = VL_RANDOM_I(32);
        if (top->dBusWishbone_CYC && top->dBusWishbone_STB && top->dBusWishbone_ACK) {
            if(top->dBusWishbone_WE){
                bool dummy;
                ws->dBusAccess(top->dBusWishbone_ADR << 2 ,1,2,top->dBusWishbone_SEL,&top->dBusWishbone_DAT_MOSI,&dummy);
            } else {
                bool error;
                ws->dBusAccess(top->dBusWishbone_ADR << 2,0,2,0xF,&top->dBusWishbone_DAT_MISO,&error);
                top->dBusWishbone_ERR = error;
            }
        }
	}
};
#endif

#ifdef DBUS_CACHED

//#include "VVexRiscv_DataCache.h"

class DBusCached : public SimElement{
public:
	uint32_t address;
	bool error_next = false;
	uint32_t pendingCount = 0;
	bool wr;

	Workspace *ws;
	VVexRiscv* top;
	DBusCached(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBus_cmd_ready = 1;
		top->dBus_rsp_valid = 0;
	}

	virtual void preCycle(){
	    VL_IN8(io_cpu_execute_isValid,0,0);
	    VL_IN8(io_cpu_execute_isStuck,0,0);
	    VL_IN8(io_cpu_execute_args_kind,0,0);
	    VL_IN8(io_cpu_execute_args_wr,0,0);
	    VL_IN8(io_cpu_execute_args_size,1,0);
	    VL_IN8(io_cpu_execute_args_forceUncachedAccess,0,0);
	    VL_IN8(io_cpu_execute_args_clean,0,0);
	    VL_IN8(io_cpu_execute_args_invalidate,0,0);
	    VL_IN8(io_cpu_execute_args_way,0,0);

//		if(top->VexRiscv->dataCache_1->io_cpu_execute_isValid && !top->VexRiscv->dataCache_1->io_cpu_execute_isStuck
//				&& top->VexRiscv->dataCache_1->io_cpu_execute_args_wr){
//			if(top->VexRiscv->dataCache_1->io_cpu_execute_args_address == 0x80025978)
//				cout << "WR 0x80025978 = " << hex << setw(8) << top->VexRiscv->dataCache_1->io_cpu_execute_args_data << endl;
//			if(top->VexRiscv->dataCache_1->io_cpu_execute_args_address == 0x8002596c)
//				cout << "WR 0x8002596c = " << hex << setw(8) << top->VexRiscv->dataCache_1->io_cpu_execute_args_data << endl;
//		}
		if (top->dBus_cmd_valid && top->dBus_cmd_ready) {
			if(pendingCount == 0){
				pendingCount = top->dBus_cmd_payload_length+1;
				address = top->dBus_cmd_payload_address;
				wr = top->dBus_cmd_payload_wr;
			}
			if(top->dBus_cmd_payload_wr){
				ws->dBusAccess(address,top->dBus_cmd_payload_wr,2,top->dBus_cmd_payload_mask,&top->dBus_cmd_payload_data,&error_next);
				address += 4;
				pendingCount--;
			}
		}
	}

	virtual void postCycle(){
		if(pendingCount != 0 && !wr && (!ws->dStall || VL_RANDOM_I(7) < 100)){
			ws->dBusAccess(address,0,2,0,&top->dBus_rsp_payload_data,&error_next);
			top->dBus_rsp_payload_error = error_next;
			top->dBus_rsp_valid = 1;
			address += 4;
			pendingCount--;
		} else{
			top->dBus_rsp_valid = 0;
			top->dBus_rsp_payload_data = VL_RANDOM_I(32);
			top->dBus_rsp_payload_error = VL_RANDOM_I(1);
		}

		top->dBus_cmd_ready = (ws->dStall ? VL_RANDOM_I(7) < 100 : 1) && (pendingCount == 0 || wr);
	}
};
#endif

#ifdef DBUS_CACHED_AVALON
#include <queue>

struct DBusCachedAvalonTask{
	uint32_t data;
	bool error;
};

class DBusCachedAvalon : public SimElement{
public:
	uint32_t beatCounter = 0;
	queue<DBusCachedAvalonTask> rsps;

	Workspace *ws;
	VVexRiscv* top;
	DBusCachedAvalon(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBusAvalon_waitRequestn = 1;
		top->dBusAvalon_readDataValid = 0;
	}


	virtual void preCycle(){
		if ((top->dBusAvalon_read || top->dBusAvalon_write) && top->dBusAvalon_waitRequestn) {
			if(top->dBusAvalon_write){
				bool error_next = false;
				ws->dBusAccess(top->dBusAvalon_address + beatCounter * 4,1,2,top->dBusAvalon_byteEnable,&top->dBusAvalon_writeData,&error_next);
				beatCounter++;
				if(beatCounter == top->dBusAvalon_burstCount){
					beatCounter = 0;
				}
			} else {
				for(int beat = 0;beat < top->dBusAvalon_burstCount;beat++){
					DBusCachedAvalonTask rsp;
					ws->dBusAccess(top->dBusAvalon_address  + beat * 4,0,2,0,&rsp.data,&rsp.error);
					rsps.push(rsp);
				}
			}
		}
	}

	virtual void postCycle(){
		if(!rsps.empty() && (!ws->dStall || VL_RANDOM_I(7) < 100)){
			DBusCachedAvalonTask rsp = rsps.front();
			rsps.pop();
			top->dBusAvalon_response = rsp.error ? 3 : 0;
			top->dBusAvalon_readData = rsp.data;
			top->dBusAvalon_readDataValid = 1;
		} else{
			top->dBusAvalon_readDataValid = 0;
			top->dBusAvalon_readData = VL_RANDOM_I(32);
			top->dBusAvalon_response = VL_RANDOM_I(2); //TODO
		}

		top->dBusAvalon_waitRequestn = (ws->dStall ? VL_RANDOM_I(7) < 100 : 1);
	}
};
#endif


#ifdef DEBUG_PLUGIN
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <netinet/tcp.h>

/** Returns true on success, or false if there was an error */
bool SetSocketBlockingEnabled(int fd, bool blocking)
{
   if (fd < 0) return false;

#ifdef WIN32
   unsigned long mode = blocking ? 0 : 1;
   return (ioctlsocket(fd, FIONBIO, &mode) == 0) ? true : false;
#else
   int flags = fcntl(fd, F_GETFL, 0);
   if (flags < 0) return false;
   flags = blocking ? (flags&~O_NONBLOCK) : (flags|O_NONBLOCK);
   return (fcntl(fd, F_SETFL, flags) == 0) ? true : false;
#endif
}

struct DebugPluginTask{
	bool wr;
	uint32_t address;
	uint32_t data;
};

class DebugPlugin : public SimElement{
public:
	Workspace *ws;
	VVexRiscv* top;

	int serverSocket, clientHandle;
	struct sockaddr_in serverAddr;
	struct sockaddr_storage serverStorage;
	socklen_t addr_size;
	char buffer[1024];
	uint32_t timeSpacer = 0;
	bool taskValid = false;
	DebugPluginTask task;


	DebugPlugin(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;

		#ifdef DEBUG_PLUGIN_EXTERNAL
			ws->mTimeCmp = ~0;
		#endif
		top->debugReset = 0;



		//---- Create the socket. The three arguments are: ----//
		// 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) //
		serverSocket = socket(PF_INET, SOCK_STREAM, 0);
		assert(serverSocket != -1);
		SetSocketBlockingEnabled(serverSocket,0);
		int flag = 1;
		int result = setsockopt(serverSocket,            /* socket affected */
								 IPPROTO_TCP,     /* set option at TCP level */
								 TCP_NODELAY,     /* name of option */
								 (char *) &flag,  /* the cast is historical
														 cruft */
								 sizeof(int));    /* length of option value */

		//---- Configure settings of the server address struct ----//
		// Address family = Internet //
		serverAddr.sin_family = AF_INET;
		// Set port number, using htons function to use proper byte order //
		serverAddr.sin_port = htons(7893);
		// Set IP address to localhost //
		serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
		// Set all bits of the padding field to 0 //
		memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);

		//---- Bind the address struct to the socket ----//
		bind(serverSocket, (struct sockaddr *) &serverAddr, sizeof(serverAddr));

		//---- Listen on the socket, with 5 max connection requests queued ----//
		listen(serverSocket,1);

		//---- Accept call creates a new socket for the incoming connection ----//
		addr_size = sizeof serverStorage;

		clientHandle = -1;
	}

	virtual ~DebugPlugin(){
		if(clientHandle != -1) {
			shutdown(clientHandle,SHUT_RDWR);
			usleep(100);
		}
		if(serverSocket != -1) {
			close(serverSocket);
			usleep(100);
		}
	}

	virtual void onReset(){
		top->debugReset = 1;
	}



	virtual void postReset(){
		top->debugReset = 0;
	}

	void connectionReset(){
		printf("CONNECTION RESET\n");
		shutdown(clientHandle,SHUT_RDWR);
		clientHandle = -1;
	}


	virtual void preCycle(){

	}

	virtual void postCycle(){
		top->reset = top->debug_resetOut;
		if(timeSpacer == 0){
			if(clientHandle == -1){
				clientHandle = accept(serverSocket, (struct sockaddr *) &serverStorage, &addr_size);
				if(clientHandle != -1)
					printf("CONNECTED\n");
				timeSpacer = 1000;
			}


			if(clientHandle != -1 && taskValid == false){
				int requiredSize = 1 + 1 + 4 + 4;
				int n;
				timeSpacer = 20;
				if(ioctl(clientHandle,FIONREAD,&n) != 0){
					connectionReset();
				} else if(n >= requiredSize){
					if(requiredSize != read(clientHandle,buffer,requiredSize)){
						connectionReset();
					} else {
						bool wr = buffer[0];
						uint32_t size = buffer[1];
						uint32_t address = *((uint32_t*)(buffer + 2));
						uint32_t data = *((uint32_t*)(buffer + 6));

						if((address & ~ 0x4) == 0xF00F0000){
							assert(size == 2);
							timeSpacer = 100;

							taskValid = true;
							task.wr = wr;
							task.address = address;
							task.data = data;
						}
					}
				} else {
					int error = 0;
					socklen_t len = sizeof (error);
					int retval = getsockopt (clientHandle, SOL_SOCKET, SO_ERROR, &error, &len);
					if (retval != 0 || error != 0) {
						connectionReset();
					}
				}
			}
		} else {
			timeSpacer--;
		}
	}

	void sendRsp(uint32_t data){
		if(clientHandle != -1){
			if(send(clientHandle,&data,4,0) == -1) connectionReset();
		}
	}
};
#endif

#ifdef DEBUG_PLUGIN_STD
class DebugPluginStd : public DebugPlugin{
public:
	DebugPluginStd(Workspace* ws) : DebugPlugin(ws){

	}

	virtual void onReset(){
		DebugPlugin::onReset();
		top->debug_bus_cmd_valid = 0;
	}

	bool rspFire = false;

	virtual void preCycle(){
		DebugPlugin::preCycle();

		if(rspFire){
			sendRsp(top->debug_bus_rsp_data);
			rspFire = false;
		}

		if(top->debug_bus_cmd_valid && top->debug_bus_cmd_ready){
			taskValid = false;
			if(!top->debug_bus_cmd_payload_wr){
				rspFire = true;
			}
		}
	}

	virtual void postCycle(){
		DebugPlugin::postCycle();

		if(taskValid){
			top->debug_bus_cmd_valid = 1;
			top->debug_bus_cmd_payload_wr = task.wr;
			top->debug_bus_cmd_payload_address = task.address;
			top->debug_bus_cmd_payload_data = task.data;
		}else {
			top->debug_bus_cmd_valid = 0;
			top->debug_bus_cmd_payload_wr = VL_RANDOM_I(1);
			top->debug_bus_cmd_payload_address = VL_RANDOM_I(8);
			top->debug_bus_cmd_payload_data = VL_RANDOM_I(32);
		}
	}
};

#endif

#ifdef DEBUG_PLUGIN_AVALON
class DebugPluginAvalon : public DebugPlugin{
public:
	DebugPluginAvalon(Workspace* ws) : DebugPlugin(ws){

	}

	virtual void onReset(){
		DebugPlugin::onReset();
		top->debugBusAvalon_read = 0;
		top->debugBusAvalon_write = 0;
	}

	bool rspFire = false;

	virtual void preCycle(){
		DebugPlugin::preCycle();

		if(rspFire){
			sendRsp(top->debugBusAvalon_readData);
			rspFire = false;
		}

		if((top->debugBusAvalon_read || top->debugBusAvalon_write) && top->debugBusAvalon_waitRequestn){
			taskValid = false;
			if(top->debugBusAvalon_read){
				rspFire = true;
			}
		}
	}

	virtual void postCycle(){
		DebugPlugin::postCycle();

		if(taskValid){
			top->debugBusAvalon_write = task.wr;
			top->debugBusAvalon_read = !task.wr;
			top->debugBusAvalon_address = task.address;
			top->debugBusAvalon_writeData = task.data;
		}else {
			top->debugBusAvalon_write = 0;
			top->debugBusAvalon_read = 0;
			top->debugBusAvalon_address = VL_RANDOM_I(8);
			top->debugBusAvalon_writeData = VL_RANDOM_I(32);
		}
	}
};

#endif

void Workspace::fillSimELements(){
	#ifdef IBUS_SIMPLE
		simElements.push_back(new IBusSimple(this));
	#endif
	#ifdef IBUS_SIMPLE_AVALON
		simElements.push_back(new IBusSimpleAvalon(this));
	#endif
	#ifdef IBUS_CACHED
		simElements.push_back(new IBusCached(this));
	#endif
	#ifdef IBUS_CACHED_AVALON
		simElements.push_back(new IBusCachedAvalon(this));
	#endif
	#if defined(IBUS_CACHED_WISHBONE) || defined(IBUS_SIMPLE_WISHBONE)
		simElements.push_back(new IBusCachedWishbone(this));
	#endif
	#ifdef DBUS_SIMPLE
		simElements.push_back(new DBusSimple(this));
	#endif
	#ifdef DBUS_SIMPLE_AVALON
		simElements.push_back(new DBusSimpleAvalon(this));
	#endif
	#ifdef DBUS_CACHED
		simElements.push_back(new DBusCached(this));
	#endif
	#ifdef DBUS_CACHED_AVALON
		simElements.push_back(new DBusCachedAvalon(this));
	#endif
	#if defined(DBUS_CACHED_WISHBONE) || defined(DBUS_SIMPLE_WISHBONE)
		simElements.push_back(new DBusCachedWishbone(this));
	#endif
	#ifdef DEBUG_PLUGIN_STD
		simElements.push_back(new DebugPluginStd(this));
	#endif
	#ifdef DEBUG_PLUGIN_AVALON
		simElements.push_back(new DebugPluginAvalon(this));
	#endif
}

mutex Workspace::staticMutex;
uint64_t Workspace::cycles = 0;
uint32_t Workspace::testsCounter = 0, Workspace::successCounter = 0;

#ifndef REF
#define testA1ReagFileWriteRef {1,10},{2,20},{3,40},{4,60}
#define testA2ReagFileWriteRef {5,1},{7,3}
uint32_t regFileWriteRefArray[][2] = {
	testA1ReagFileWriteRef,
	testA1ReagFileWriteRef,
	testA2ReagFileWriteRef,
	testA2ReagFileWriteRef
};

class TestA : public Workspace{
public:


	uint32_t regFileWriteRefIndex = 0;

	TestA() : Workspace("testA") {
		loadHex("../../resources/hex/testA.hex");
	}

	virtual void checks(){
		if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address, regFileWriteRefArray[regFileWriteRefIndex][0]);
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data, regFileWriteRefArray[regFileWriteRefIndex][1]);
			//printf("%d\n",i);

			regFileWriteRefIndex++;
			if(regFileWriteRefIndex == sizeof(regFileWriteRefArray)/sizeof(regFileWriteRefArray[0])){
				pass();
			}
		}
	}
};

class TestX28 : public Workspace{
public:
	uint32_t refIndex = 0;
	uint32_t *ref;
	uint32_t refSize;

	TestX28(string name, uint32_t *ref, uint32_t refSize) : Workspace(name) {
		this->ref = ref;
		this->refSize = refSize;
		loadHex("../../resources/hex/" + name + ".hex");
	}

	virtual void checks(){
		if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address == 28){
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data, ref[refIndex]);
			//printf("%d\n",i);

			refIndex++;
			if(refIndex == refSize){
				pass();
			}
		}
	}
};


class RiscvTest : public Workspace{
public:
	RiscvTest(string name) : Workspace(name) {
		loadHex("../../resources/hex/" + name + ".hex");
		bootAt(0x800000bcu);
	}

	virtual void postReset() {
//		#ifdef CSR
//		top->VexRiscv->prefetch_PcManagerSimplePlugin_pcReg = 0x80000000u;
//		#else
//		#endif
	}

	virtual void checks(){
		if(top->VexRiscv->writeBack_arbitration_isFiring && top->VexRiscv->writeBack_INSTRUCTION == 0x00000013){
			uint32_t instruction;
			bool error;
			Workspace::mem.read(top->VexRiscv->writeBack_PC, 4, (uint8_t*)&instruction);
			//printf("%x => %x\n", top->VexRiscv->writeBack_PC, instruction );
			if(instruction == 0x00000073){
				uint32_t code = top->VexRiscv->RegFilePlugin_regFile[28];
				uint32_t code2 = top->VexRiscv->RegFilePlugin_regFile[3];
				if((code & 1) == 0 && (code2 & 1) == 0){
					cout << "Wrong error code"<< endl;
					fail();
				}
				if(code == 1 || code2 == 1){
					pass();
				}else{
					cout << "Error code " << code/2 << endl;
					fail();
				}
			}
		}
	}

	virtual void iBusAccessPatch(uint32_t addr, uint32_t *data, bool *error){
		if(*data == 0x0ff0000f) *data = 0x00000013;
		if(*data == 0x00000073) *data = 0x00000013;
	}
};
#endif
class Dhrystone : public Workspace{
public:
	string hexName;
	Dhrystone(string name,string hexName,bool iStall, bool dStall) : Workspace(name) {
		setIStall(iStall);
		setDStall(dStall);
		withRiscvRef();
		loadHex("../../resources/hex/" + hexName + ".hex");
		this->hexName = hexName;
	}

	virtual void checks(){

	}

	virtual void pass(){
		FILE *refFile = fopen((hexName + ".logRef").c_str(), "r");
    	fseek(refFile, 0, SEEK_END);
    	uint32_t refSize = ftell(refFile);
    	fseek(refFile, 0, SEEK_SET);
    	char* ref = new char[refSize];
    	fread(ref, 1, refSize, refFile);
    	

    	logTraces.flush();
		FILE *logFile = fopen((name + ".logTrace").c_str(), "r");
    	fseek(logFile, 0, SEEK_END);
    	uint32_t logSize = ftell(logFile);
    	fseek(logFile, 0, SEEK_SET);
    	char* log = new char[logSize];
    	fread(log, 1, logSize, logFile);
    	
    	if(refSize > logSize || memcmp(log,ref,refSize))
    		fail();
		else
			Workspace::pass();
	}
};

class Compliance : public Workspace{
public:
	string name;
	ofstream out32;
	int out32Counter = 0;
	Compliance(string name) : Workspace(name) {
		//withRiscvRef();
		loadHex("../../resources/hex/" + name + ".elf.hex");
		out32.open (name + ".out32");
		this->name = name;
		if(name == "I-FENCE.I-01") withInstructionReadCheck = false;
	}


    virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size,uint32_t mask, uint32_t *data, bool *error) {
        Workspace::dBusAccess(addr,wr,size,mask,data,error);
        if(wr && addr == 0xF00FFF2C){
            out32 << hex << setw(8) << std::setfill('0') << *data;
            if(++out32Counter % 4 == 0) out32 << "\n";
            *error = 0;
        }
    }

	virtual void checks(){

	}



	virtual void pass(){
		FILE *refFile = fopen((string("../../resources/ref/") + name + ".reference_output").c_str(), "r");
    	fseek(refFile, 0, SEEK_END);
    	uint32_t refSize = ftell(refFile);
    	fseek(refFile, 0, SEEK_SET);
    	char* ref = new char[refSize];
    	fread(ref, 1, refSize, refFile);


    	out32.flush();
		FILE *logFile = fopen((name + ".out32").c_str(), "r");
    	fseek(logFile, 0, SEEK_END);
    	uint32_t logSize = ftell(logFile);
    	fseek(logFile, 0, SEEK_SET);
    	char* log = new char[logSize];
    	fread(log, 1, logSize, logFile);

    	if(refSize > logSize || memcmp(log,ref,refSize))
    		fail();
		else
			Workspace::pass();
	}
};


#ifdef DEBUG_PLUGIN

#include<pthread.h>
#include<stdlib.h>
#include<unistd.h>
#include <netinet/tcp.h>

#define RISCV_SPINAL_FLAGS_RESET 1<<0
#define RISCV_SPINAL_FLAGS_HALT 1<<1
#define RISCV_SPINAL_FLAGS_PIP_BUSY 1<<2
#define RISCV_SPINAL_FLAGS_IS_IN_BREAKPOINT 1<<3
#define RISCV_SPINAL_FLAGS_STEP 1<<4
#define RISCV_SPINAL_FLAGS_PC_INC 1<<5

#define RISCV_SPINAL_FLAGS_RESET_SET 1<<16
#define RISCV_SPINAL_FLAGS_HALT_SET 1<<17

#define RISCV_SPINAL_FLAGS_RESET_CLEAR 1<<24
#define RISCV_SPINAL_FLAGS_HALT_CLEAR 1<<25

class DebugPluginTest : public Workspace{
public:
	pthread_t clientThreadId;
	char buffer[1024];
	bool clientSuccess = false, clientFail = false;

	static void* clientThreadWrapper(void *debugModule){
		((DebugPluginTest*)debugModule)->clientThread();
		return NULL;
	}

	int clientSocket;
	void accessCmd(bool wr, uint32_t size, uint32_t address, uint32_t data){
		buffer[0] = wr;
		buffer[1] = size;
		*((uint32_t*) (buffer + 2)) = address;
		*((uint32_t*) (buffer + 6)) = data;
		send(clientSocket,buffer,10,0);
	}

	void writeCmd(uint32_t size, uint32_t address, uint32_t data){
		accessCmd(true, 2, address, data);
	}


	uint32_t readCmd(uint32_t size, uint32_t address){
		accessCmd(false, 2, address, VL_RANDOM_I(32));
		int error;
		if((error = recv(clientSocket, buffer, 4, 0)) != 4){
			printf("Should read 4 bytes, had %d", error);
			while(1);
		}

		return *((uint32_t*) buffer);
	}



	void clientThread(){
		struct sockaddr_in serverAddr;

		//---- Create the socket. The three arguments are: ----//
		// 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) //
		clientSocket = socket(PF_INET, SOCK_STREAM, 0);
		int flag = 1;
		int result = setsockopt(clientSocket,            /* socket affected */
								 IPPROTO_TCP,     /* set option at TCP level */
								 TCP_NODELAY,     /* name of option */
								 (char *) &flag,  /* the cast is historical
														 cruft */
								 sizeof(int));    /* length of option value */

		//---- Configure settings of the server address struct ----//
		// Address family = Internet //
		serverAddr.sin_family = AF_INET;
		// Set port number, using htons function to use proper byte order //
		serverAddr.sin_port = htons(7893);
		// Set IP address to localhost //
		serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
		// Set all bits of the padding field to 0 //
		memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);

		//---- Connect the socket to the server using the address struct ----//
		socklen_t addr_size = sizeof serverAddr;
		int error = connect(clientSocket, (struct sockaddr *) &serverAddr, addr_size);
//		printf("!! %x\n",readCmd(2,0x8));
		uint32_t debugAddress = 0xF00F0000;
		uint32_t readValue;

		while(resetDone != true){usleep(100);}

		while((readCmd(2,debugAddress) & RISCV_SPINAL_FLAGS_HALT) == 0){usleep(100);}
		if((readValue = readCmd(2,debugAddress + 4)) != 0x8000000C){
			printf("wrong breakA PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (1 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 10){
			printf("wrong breakB PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (2 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 20){
			printf("wrong breakC PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (3 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 30){
			printf("wrong breakD PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (1 << 7) + (40 << 20)); //Write x1 with 40
		writeCmd(2, debugAddress + 4, 0x80000eb7); //Write x29 with 0x10
		writeCmd(2, debugAddress + 4, 0x010e8e93); //Write x29 with 0x10
		writeCmd(2, debugAddress + 4, 0x67 + (29 << 15)); //Branch x29
		writeCmd(2, debugAddress + 0, RISCV_SPINAL_FLAGS_HALT_CLEAR); //Run CPU

		while((readCmd(2,debugAddress) & RISCV_SPINAL_FLAGS_HALT) == 0){usleep(100);}
		if((readValue = readCmd(2,debugAddress + 4)) != 0x80000014){
			printf("wrong breakE PC 3 %x\n",readValue);
			clientFail = true; return;
		}


		writeCmd(2, debugAddress + 4, 0x13 + (3 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 60){
			printf("wrong x1 %x\n",readValue);
			clientFail = true; return;
		}


		writeCmd(2, debugAddress + 4, 0x80000eb7); //Write x29 with 0x10
		writeCmd(2, debugAddress + 4, 0x018e8e93); //Write x29 with 0x10
		writeCmd(2, debugAddress + 4, 0x67 + (29 << 15)); //Branch x29
		writeCmd(2, debugAddress + 0, RISCV_SPINAL_FLAGS_HALT_CLEAR); //Run CPU



		while((readCmd(2,debugAddress) & RISCV_SPINAL_FLAGS_HALT) == 0){usleep(100);}
		if((readValue = readCmd(2,debugAddress + 4)) != 0x80000024){
			printf("wrong breakF PC 3 %x\n",readValue);
			clientFail = true; return;
		}


		writeCmd(2, debugAddress + 4, 0x13 + (3 << 15)); //Read x3
		if((readValue = readCmd(2,debugAddress + 4)) != 171){
			printf("wrong x3 %x\n",readValue);
			clientFail = true; return;
		}


		clientSuccess = true;
	}


	DebugPluginTest() : Workspace("DebugPluginTest") {
		loadHex("../../resources/hex/debugPlugin.hex");
		 pthread_create(&clientThreadId, NULL, &clientThreadWrapper, this);
		 noInstructionReadCheck();
	}

	virtual ~DebugPluginTest(){
		if(clientSocket != -1) close(clientSocket);
	}

	virtual void checks(){
		if(clientSuccess) pass();
		if(clientFail) fail();
	}
};

#endif

string riscvTestMain[] = {
	//"rv32ui-p-simple",
	"rv32ui-p-lui",
	"rv32ui-p-auipc",
	"rv32ui-p-jal",
	"rv32ui-p-jalr",
	"rv32ui-p-beq",
	"rv32ui-p-bge",
	"rv32ui-p-bgeu",
	"rv32ui-p-blt",
	"rv32ui-p-bltu",
	"rv32ui-p-bne",
	"rv32ui-p-add",
	"rv32ui-p-addi",
	"rv32ui-p-and",
	"rv32ui-p-andi",
	"rv32ui-p-or",
	"rv32ui-p-ori",
	"rv32ui-p-sll",
	"rv32ui-p-slli",
	"rv32ui-p-slt",
	"rv32ui-p-slti",
	"rv32ui-p-sra",
	"rv32ui-p-srai",
	"rv32ui-p-srl",
	"rv32ui-p-srli",
	"rv32ui-p-sub",
	"rv32ui-p-xor",
	"rv32ui-p-xori"
};

string riscvTestMemory[] = {
	"rv32ui-p-lb",
	"rv32ui-p-lbu",
	"rv32ui-p-lh",
	"rv32ui-p-lhu",
	"rv32ui-p-lw",
	"rv32ui-p-sb",
	"rv32ui-p-sh",
	"rv32ui-p-sw"
};




string riscvTestMul[] = {
	"rv32um-p-mul",
	"rv32um-p-mulh",
	"rv32um-p-mulhsu",
	"rv32um-p-mulhu"
};

string riscvTestDiv[] = {
	"rv32um-p-div",
	"rv32um-p-divu",
	"rv32um-p-rem",
	"rv32um-p-remu"
};

string freeRtosTests[] = {
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1",
//    "test1","test1","test1","test1","test1","test1","test1","test1"

		"AltQTest", "AltBlock",  "AltPollQ", "blocktim", "countsem", "dead", "EventGroupsDemo", "flop", "integer", "QPeek",
		"QueueSet", "recmutex", "semtest", "TaskNotify", "BlockQ", "crhook", "dynamic",
		"GenQTest", "PollQ", "QueueOverwrite", "QueueSetPolling", "sp_flop", "test1"
		//"BlockQ","BlockQ","BlockQ","BlockQ","BlockQ","BlockQ","BlockQ","BlockQ"
//		"flop"
//		 "flop", "sp_flop" // <- Simple test
		 // "AltBlckQ" ???
};



string riscvComplianceMain[] = {
    "I-IO",
    "I-NOP-01",
    "I-LUI-01",
    "I-ADD-01",
    "I-ADDI-01",
    "I-AND-01",
    "I-ANDI-01",
    "I-SUB-01",
    "I-OR-01",
    "I-ORI-01",
    "I-XOR-01",
    "I-XORI-01",
    "I-SRA-01",
    "I-SRAI-01",
    "I-SRL-01",
    "I-SRLI-01",
    "I-SLL-01",
    "I-SLLI-01",
    "I-SLT-01",
    "I-SLTI-01",
    "I-SLTIU-01",
    "I-SLTU-01",
    "I-AUIPC-01",
    "I-BEQ-01",
    "I-BGE-01",
    "I-BGEU-01",
    "I-BLT-01",
    "I-BLTU-01",
    "I-BNE-01",
    "I-JAL-01",
    "I-JALR-01",
    "I-DELAY_SLOTS-01",
    "I-ENDIANESS-01",
    "I-RF_size-01",
    "I-RF_width-01",
    "I-RF_x0-01",
};



string complianceTestMemory[] = {
    "I-LB-01",
    "I-LBU-01",
    "I-LH-01",
    "I-LHU-01",
    "I-LW-01",
    "I-SB-01",
    "I-SH-01",
    "I-SW-01"
};


string complianceTestCsr[] = {
    "I-CSRRC-01",
    "I-CSRRCI-01",
    "I-CSRRS-01",
    "I-CSRRSI-01",
    "I-CSRRW-01",
    "I-CSRRWI-01",
    #ifndef COMPRESSED
    "I-MISALIGN_JMP-01", //Only apply for non RVC cores
    #endif
    "I-MISALIGN_LDST-01",
    "I-ECALL-01",
};


string complianceTestMul[] = {
    "MUL",
    "MULH",
    "MULHSU",
    "MULHU",
};

string complianceTestDiv[] = {
    "DIV",
    "DIVU",
    "REM",
    "REMU",
};


string complianceTestC[] = {
    "C.ADD",
    "C.ADDI16SP",
    "C.ADDI4SPN",
    "C.ADDI",
    "C.AND",
    "C.ANDI",
    "C.BEQZ",
    "C.BNEZ",
    "C.JAL",
    "C.JALR",
    "C.J",
    "C.JR",
    "C.LI",
    "C.LUI",
    "C.LW",
    "C.LWSP",
    "C.MV",
    "C.OR",
    "C.SLLI",
    "C.SRAI",
    "C.SRLI",
    "C.SUB",
    "C.SW",
    "C.SWSP",
    "C.XOR",
};




struct timespec timer_start(){
    struct timespec start_time;
    clock_gettime(CLOCK_REALTIME, &start_time); //CLOCK_PROCESS_CPUTIME_ID
    return start_time;
}

long timer_end(struct timespec start_time){
    struct timespec end_time;
    clock_gettime(CLOCK_REALTIME, &end_time);
    uint64_t diffInNanos = end_time.tv_sec*1e9 + end_time.tv_nsec -  start_time.tv_sec*1e9 - start_time.tv_nsec;
    return diffInNanos;
}

#define redo(count,that) for(uint32_t xxx = 0;xxx < count;xxx++) that
#include <pthread.h>
#include <queue>
#include <functional>
#include <thread>


static void multiThreading(queue<std::function<void()>> *lambdas, std::mutex *mutex){
    uint32_t counter = 0;
	while(true){
		mutex->lock();
		if(lambdas->empty()){
			mutex->unlock();
			break;
		}

        #ifdef SEED
            uint32_t seed = SEED + counter;
            counter++;
            srand48(seed);
            printf("FREERTOS_SEED=%d \n", seed);
        #endif
		std::function<void()> lambda = lambdas->front();
		lambdas->pop();
		mutex->unlock();

		lambda();
	}
}


static void multiThreadedExecute(queue<std::function<void()>> &lambdas){
	std::mutex mutex;
	std::thread * t[THREAD_COUNT];
	for(int id = 0;id < THREAD_COUNT;id++){
		t[id] = new thread(multiThreading,&lambdas,&mutex);
	}
	for(int id = 0;id < THREAD_COUNT;id++){
		t[id]->join();
		delete t[id];
	}
}


int main(int argc, char **argv, char **env) {
    #ifdef SEED
    srand48(SEED);
    #endif
	Verilated::randReset(2);
	Verilated::commandArgs(argc, argv);

	printf("BOOT\n");
	timespec startedAt = timer_start();

	for(int idx = 0;idx < 1;idx++){

		#if defined(DEBUG_PLUGIN_EXTERNAL) || defined(RUN_HEX)
		{
			Workspace w("run");
			#ifdef RUN_HEX
			//w.loadHex("/home/spinalvm/hdl/zephyr/zephyrSpinalHdl/samples/synchronization/build/zephyr/zephyr.hex");
			w.loadHex(RUN_HEX);
			#endif
			w.noInstructionReadCheck();
			//w.setIStall(false);
			//w.setDStall(false);

			#if defined(TRACE) || defined(TRACE_ACCESS)
				//w.setCyclesPerSecond(5e3);
				//printf("Speed reduced 5Khz\n");
			#endif
			w.run(0xFFFFFFFFFFFF);
		}
		#endif


		#ifdef ISA_TEST

		//	redo(REDO,TestA().run();)
			for(const string &name : riscvComplianceMain){
				redo(REDO, Compliance(name).run();)
			}
			for(const string &name : complianceTestMemory){
				redo(REDO, Compliance(name).run();)
			}

			#ifdef COMPRESSED
            for(const string &name : complianceTestC){
                redo(REDO, Compliance(name).run();)
            }
			#endif

			#ifdef MUL
			for(const string &name : complianceTestMul){
				redo(REDO, Compliance(name).run();)
			}
			#endif
			#ifdef DIV
			for(const string &name : complianceTestDiv){
				redo(REDO, Compliance(name).run();)
			}
			#endif
			#ifdef CSR
			for(const string &name : complianceTestCsr){
				redo(REDO, Compliance(name).run();)
			}
			#endif

            #ifdef FENCEI
            redo(REDO, Compliance("I-FENCE.I-01").run();)
			#endif
            #ifdef EBREAK
            redo(REDO, Compliance("I-EBREAK-01").run();)
			#endif

			for(const string &name : riscvTestMain){
				redo(REDO,RiscvTest(name).run();)
			}
			for(const string &name : riscvTestMemory){
				redo(REDO,RiscvTest(name).run();)
			}

			#ifdef MUL
			for(const string &name : riscvTestMul){
				redo(REDO,RiscvTest(name).run();)
			}
			#endif
			#ifdef DIV
			for(const string &name : riscvTestDiv){
				redo(REDO,RiscvTest(name).run();)
			}
			#endif

            #ifdef COMPRESSED
            redo(REDO,RiscvTest("rv32uc-p-rvc").bootAt(0x800000FCu)->run());
            #endif

			#ifdef CSR
			    #ifndef COMPRESSED
				    uint32_t machineCsrRef[] = {1,11,   2,0x80000003u,   3,0x80000007u,   4,0x8000000bu,   5,6,7,0x80000007u     ,
				    8,6,9,6,10,4,11,4,    12,13,0,   14,2,     15,5,16,17,1 };
				    redo(REDO,TestX28("machineCsr",machineCsrRef, sizeof(machineCsrRef)/4).noInstructionReadCheck()->run(10e4);)
                #else
				    uint32_t machineCsrRef[] = {1,11,   2,0x80000003u,   3,0x80000007u,   4,0x8000000bu,   5,6,7,0x80000007u     ,
				    8,6,9,6,10,4,11,4,    12,13,   14,2,     15,5,16,17,1 };
				    redo(REDO,TestX28("machineCsrCompressed",machineCsrRef, sizeof(machineCsrRef)/4).noInstructionReadCheck()->run(10e4);)
                #endif
			#endif
			#ifdef MMU
				uint32_t mmuRef[] = {1,2,3, 0x11111111, 0x11111111, 0x11111111, 0x22222222, 0x22222222, 0x22222222, 4, 0x11111111, 0x33333333, 0x33333333, 5,
					13, 0xC4000000,0x33333333, 6,7,
					1,2,3, 0x11111111, 0x11111111, 0x11111111, 0x22222222, 0x22222222, 0x22222222, 4, 0x11111111, 0x33333333, 0x33333333, 5,
					13, 0xC4000000,0x33333333, 6,7};
				redo(REDO,TestX28("mmu",mmuRef, sizeof(mmuRef)/4).noInstructionReadCheck()->run(4e4);)
			#endif

			#ifdef DEBUG_PLUGIN
				redo(REDO,DebugPluginTest().run(1e6););
			#endif
		#endif

		#ifdef CUSTOM_SIMD_ADD
			redo(REDO,Workspace("custom_simd_add").loadHex("../custom/simd_add/build/custom_simd_add.hex")->bootAt(0x00000000u)->run(50e3););
		#endif

		#ifdef CUSTOM_CSR
			redo(REDO,Workspace("custom_csr").loadHex("../custom/custom_csr/build/custom_csr.hex")->bootAt(0x00000000u)->run(50e3););
		#endif


		#ifdef ATOMIC
			redo(REDO,Workspace("atomic").loadHex("../custom/atomic/build/atomic.hex")->bootAt(0x00000000u)->run(10e3););
		#endif

		#ifdef DHRYSTONE
			Dhrystone("dhrystoneO3_Stall","dhrystoneO3",true,true).run(1.5e6);
			#if defined(COMPRESSED)
			    Dhrystone("dhrystoneO3C_Stall","dhrystoneO3C",true,true).run(1.5e6);
            #endif
			#if defined(MUL) && defined(DIV)
				Dhrystone("dhrystoneO3M_Stall","dhrystoneO3M",true,true).run(1.9e6);
				#if defined(COMPRESSED)
				    Dhrystone("dhrystoneO3MC_Stall","dhrystoneO3MC",true,true).run(1.9e6);
				#endif
			#endif
			Dhrystone("dhrystoneO3","dhrystoneO3",false,false).run(1.9e6);
			#if defined(COMPRESSED)
			Dhrystone("dhrystoneO3C","dhrystoneO3C",false,false).run(1.9e6);
            #endif
			#if defined(MUL) && defined(DIV)
				Dhrystone("dhrystoneO3M","dhrystoneO3M",false,false).run(1.9e6);
				#if defined(COMPRESSED)
				    Dhrystone("dhrystoneO3MC","dhrystoneO3MC",false,false).run(1.9e6);
				#endif
			#endif
		#endif


		#ifdef FREERTOS
		    #ifdef SEED
            srand48(SEED);
            #endif
			//redo(1,Workspace("freeRTOS_demo").loadHex("../../resources/hex/freeRTOS_demo.hex")->bootAt(0x80000000u)->run(100e6);)
			vector <std::function<void()>> tasks;

            /*for(int redo = 0;redo < 4;redo++)*/{
                for(const string &name : freeRtosTests){
                    tasks.push_back([=]() { Workspace(name + "_rv32i_O0").withRiscvRef()->loadHex("../../resources/freertos/" + name + "_rv32i_O0.hex")->bootAt(0x80000000u)->run(4e6*15);});
                    tasks.push_back([=]() { Workspace(name + "_rv32i_O3").withRiscvRef()->loadHex("../../resources/freertos/" + name + "_rv32i_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
                    #ifdef COMPRESSED
                        tasks.push_back([=]() { Workspace(name + "_rv32ic_O0").withRiscvRef()->loadHex("../../resources/freertos/" + name + "_rv32ic_O0.hex")->bootAt(0x80000000u)->run(5e6*15);});
                        tasks.push_back([=]() { Workspace(name + "_rv32ic_O3").withRiscvRef()->loadHex("../../resources/freertos/" + name + "_rv32ic_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
                    #endif
                    #if defined(MUL) && defined(DIV)
                        #ifdef COMPRESSED
                            tasks.push_back([=]() { Workspace(name + "_rv32imac_O3").withRiscvRef()->loadHex("../../resources/freertos/" + name + "_rv32imac_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
                        #else
                            tasks.push_back([=]() { Workspace(name + "_rv32im_O3").withRiscvRef()->loadHex("../../resources/freertos/" + name + "_rv32im_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
                        #endif
                    #endif
                }
			}

            while(tasks.size() > FREERTOS_COUNT){
                tasks.erase(tasks.begin() + (VL_RANDOM_I(32)%tasks.size()));
            }


            queue <std::function<void()>> tasksSelected(std::deque<std::function<void()>>(tasks.begin(), tasks.end()));
			multiThreadedExecute(tasksSelected);
		#endif
	}

	uint64_t duration = timer_end(startedAt);
	cout << endl << "****************************************************************" << endl;
	cout << "Had simulate " << Workspace::cycles << " clock cycles in " << duration*1e-9 << " s (" << Workspace::cycles / (duration*1e-6) << " Khz)" << endl;
	if(Workspace::successCounter == Workspace::testsCounter)
		cout << "SUCCESS " << Workspace::successCounter << "/" << Workspace::testsCounter << endl;
	else
		cout<< "FAILURE " << Workspace::testsCounter - Workspace::successCounter << "/"  << Workspace::testsCounter << endl;
	cout << "****************************************************************" << endl << endl;


	exit(0);
}
