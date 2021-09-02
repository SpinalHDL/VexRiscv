#include "VVexRiscv.h"
#include "VVexRiscv_VexRiscv.h"
#ifdef REF
#include "VVexRiscv_RiscvCore.h"
#endif
#include "verilated.h"
#include "verilated_fst_c.h"
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
#include "encoding.h"

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
		for(uint32_t i = 0;i < (1 << 12);i++) if(mem[i]) delete [] mem[i];
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
	fclose(fp);

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

	delete [] content;
}

void loadBinImpl(string path,Memory* mem, uint32_t offset) {
	FILE *fp = fopen(&path[0], "r");
	if(fp == 0){
		cout << path << " not found" << endl;
	}

	fseek(fp, 0, SEEK_END);
	uint32_t size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	char* content = new char[size];
	fread(content, 1, size, fp);
	fclose(fp);

	for(int byteId = 0; byteId < size;byteId++){
		*(mem->get(offset + byteId)) = content[byteId];
	}

	delete [] content;
}



#define TEXTIFY(A) #A

void breakMe(){
    int a = 0;
}
#define assertEq(x,ref) if(x != ref) {\
	printf("\n*** %s is %d but should be %d ***\n\n",TEXTIFY(x),x,ref);\
	breakMe();\
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


#define SSTATUS 0x100
#define SIE 0x104
#define STVEC 0x105
#define SCOUNTEREN 0x106
#define SSCRATCH 0x140
#define SEPC 0x141
#define SCAUSE 0x142
#define STVAL 0x143
#define SIP 0x144
#define SATP 0x180

#define UTIME    0xC01 // rdtime
#define UTIMEH   0xC81

#define SSTATUS_SIE         0x00000002
#define SSTATUS_SPIE        0x00000020
#define SSTATUS_SPP         0x00000100

#ifdef SUPERVISOR
#define MSTATUS_READ_MASK 0xFFFFFFFF
#else
#define MSTATUS_READ_MASK 0x7888
#endif

#ifdef RVF
#define STATUS_FS_MASK 0x6000
#else
#define STATUS_FS_MASK 0x0000
#endif

#define FFLAGS 0x1
#define FRM    0x2
#define FCSR   0x3

#define u32 uint32_t
#define u64 uint64_t

class FpuRsp{
public:
	u32 flags;
	u64 value;
};

class FpuCommit{
public:
	u64 value;
};

class FpuCompletion{
public:
	u32 flags;
};


bool fpuCommitLut[32] = {true,true,true,true,true,true,false,false,true,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,true,false};
bool fpuRspLut[32] = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,true,false,false,false,true,false,false,false};
bool fpuRs1Lut[32] = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,true,false};
class RiscvGolden {
public:
	int32_t pc, lastPc;
	uint32_t lastInstruction;
	int32_t regs[32];
	uint64_t stepCounter;

	uint32_t mscratch, sscratch;
	uint32_t misa;
	uint32_t privilege;

    uint32_t medeleg;
	uint32_t mideleg;

    queue<FpuRsp> fpuRsp;
    queue<FpuCommit> fpuCommit;
    queue<FpuCompletion> fpuCompletion;

	union status {
		uint32_t raw;
		struct {
			uint32_t _1a : 1;
			uint32_t sie : 1;
			uint32_t _1b : 1;
			uint32_t mie : 1;
			uint32_t _2a : 1;
			uint32_t spie : 1;
			uint32_t _2b : 1;
			uint32_t mpie : 1;
			uint32_t spp : 1;
			uint32_t _3 : 2;
			uint32_t mpp : 2;
			uint32_t fs : 2;
			uint32_t _4 : 2;
			uint32_t mprv : 1;
			uint32_t sum : 1;
			uint32_t mxr : 1;
		};
	}__attribute__((packed)) status;



	uint32_t ipInput;
	uint32_t ipSoft;
	union IpOr {
		uint32_t raw;
		struct {
			uint32_t _1a : 1;
			uint32_t ssip : 1;
			uint32_t _1b : 1;
			uint32_t msip : 1;
			uint32_t _2a : 1;
			uint32_t stip : 1;
			uint32_t _2b : 1;
			uint32_t mtip : 1;
			uint32_t _3a : 1;
			uint32_t seip : 1;
			uint32_t _3b : 1;
			uint32_t meip : 1;
		};
	}__attribute__((packed));

	IpOr getIp(){
		IpOr ret;
		ret.raw = ipSoft | ipInput;
		return ret;
	}

	union mie {
		uint32_t raw;
		struct {
			uint32_t _1a : 1;
			uint32_t ssie : 1;
			uint32_t _1b : 1;
			uint32_t msie : 1;
			uint32_t _2a : 1;
			uint32_t stie : 1;
			uint32_t _2b : 1;
			uint32_t mtie : 1;
			uint32_t _3a : 1;
			uint32_t seie : 1;
			uint32_t _3b : 1;
			uint32_t meie : 1;
		};
	}__attribute__((packed)) ie;

	union Xtvec {
		uint32_t raw;
		struct __attribute__((packed)) {
			uint32_t _1 : 2;
			uint32_t base : 30;
		};
	};

	Xtvec mtvec, stvec;



	union mcause {
		uint32_t raw;
		struct __attribute__((packed)) {
			uint32_t exceptionCode : 31;
			uint32_t interrupt : 1;
		};
	} mcause;


	union scause {
		uint32_t raw;
		struct __attribute__((packed)){
			uint32_t exceptionCode : 31;
			uint32_t interrupt : 1;
		};
	} scause;

	union satp {
		uint32_t raw;
		struct __attribute__((packed)){
			uint32_t ppn : 22;
			uint32_t _x : 9;
			uint32_t mode : 1;
		};
	}satp;

	union Tlb {
		uint32_t raw;
		struct __attribute__((packed)){
			uint32_t v : 1;
			uint32_t r : 1;
			uint32_t w : 1;
			uint32_t x : 1;
			uint32_t u : 1;
			uint32_t _dummy : 5;
			uint32_t ppn : 22;
		};
		struct __attribute__((packed)){
			uint32_t _dummyX : 10;
			uint32_t ppn0 : 10;
			uint32_t ppn1 : 12;
		};
	};

	union fcsr {
		uint32_t raw;
		struct __attribute__((packed)){
			uint32_t flags : 5;
			uint32_t frm : 3;
		};
	}fcsr;


	bool lrscReserved;
	uint32_t lrscReservedAddress;
    u32 fpuCompletionTockens;
    u32 dutRfWriteValue;

	RiscvGolden() {
		pc = 0x80000000;
		regs[0] = 0;
		for (int i = 0; i < 32; i++)
			regs[i] = 0;

		ie.raw = 0;
		mtvec.raw = 0x80000020;
		mcause.raw = 0;
		mbadaddr = 0;
		mepc = 0;
		misa = 0x40041101; //TODO
		status.raw = 0;
		status.mpp = 3;
		status.spp = 1;
		#ifdef RVF
		status.fs = 1;
		misa |= 1 << 5;
		#endif
		#ifdef RVD
		misa |= 1 << 3;
		#endif
		fcsr.flags = 0;
		fcsr.frm = 0;
		privilege = 3;
		medeleg = 0;
		mideleg = 0;
		satp.mode = 0;
		ipSoft = 0;
		ipInput = 0;
		stepCounter = 0;
		sbadaddr = 42;
		lrscReserved = false;
		fpuCompletionTockens = 0;
	}

	virtual void rfWrite(int32_t address, int32_t data) {
		if (address != 0)
			regs[address] = data;
	}

	virtual void pcWrite(int32_t target) {
		if(isPcAligned(target)){
			lastPc = pc;
			pc = target;
		} else {
			trap(0, 0, target);
		}
	}
	uint32_t mbadaddr, sbadaddr;
	uint32_t mepc, sepc;

	virtual bool iRead(int32_t address, uint32_t *data) = 0;
	virtual bool dRead(int32_t address, int32_t size, uint8_t *data) = 0;
	virtual void dWrite(int32_t address, int32_t size, uint8_t *data) = 0;

	enum AccessKind {READ,WRITE,EXECUTE,READ_WRITE};
	virtual bool isMmuRegion(uint32_t v) = 0;
	bool v2p(uint32_t v, uint32_t *p, AccessKind kind){
	    uint32_t effectivePrivilege = status.mprv && kind != EXECUTE ? status.mpp : privilege;
		if(effectivePrivilege == 3 || satp.mode == 0 || !isMmuRegion(v)){
			*p = v;
		} else {
			Tlb tlb;
			dRead((satp.ppn << 12) | ((v >> 22) << 2), 4, (uint8_t*)&tlb.raw);
			if(!tlb.v) return true;
			bool superPage = true;
			if(!tlb.x && !tlb.r && !tlb.w){
				dRead((tlb.ppn << 12) | (((v >> 12) & 0x3FF) << 2), 4, (uint8_t*)&tlb.raw);
				if(!tlb.v) return true;
				superPage = false;
			}
			if(!tlb.u && effectivePrivilege == 0) return true;
			if( tlb.u && effectivePrivilege == 1 && !status.sum) return true;
			if(superPage && tlb.ppn0 != 0) return true;
			if(kind == READ || kind == READ_WRITE) if(!tlb.r && !(status.mxr && tlb.x)) return true;
			if(kind == WRITE || kind == READ_WRITE) if(!tlb.w) return true;
			if(kind == EXECUTE) if(!tlb.x) return true;

			*p = (tlb.ppn1 << 22) | (superPage ? v & 0x3FF000 : tlb.ppn0 << 12) | (v & 0xFFF);
		}
		return false;
	}

    void trap(bool interrupt,int32_t cause) {
        trap(interrupt, cause, false, 0);
    }
    void trap(bool interrupt,int32_t cause, uint32_t value) {
        trap(interrupt, cause, true, value);
    }
	void trap(bool interrupt,int32_t cause, bool valueWrite, uint32_t value) {
#ifdef FLOW_INFO
//	    cout << "TRAP " << (interrupt ? "interrupt" : "exception") << " cause=" << cause << " PC=0x" << hex << pc << " val=0x" << hex << value << dec << endl;
//	    if(cause == 9){
//	        cout << hex <<  " a7=0x" << regs[17] << " a0=0x" << regs[10] << " a1=0x" << regs[11] << " a2=0x" << regs[12] << dec << endl;
//	    }
#endif
		//Check leguality of the interrupt
		if(interrupt) {
			bool hit = false;
			for(int i = 0;i < 5;i++){
				if(pendingInterrupts[i] == 1 << cause){
					hit = true;
					break;
				}
			}
			if(!hit){
				cout << "DUT had trigger an interrupts which wasn't by the REF" << endl;
				fail();
			}
		}

		uint32_t deleg = interrupt ? mideleg : medeleg;
		uint32_t targetPrivilege = 3;
		if(deleg & (1 << cause)) targetPrivilege = 1;
		targetPrivilege = max(targetPrivilege, privilege);
		Xtvec xtvec = targetPrivilege == 3 ? mtvec : stvec;



		switch(targetPrivilege){
		case 3:
		    if(valueWrite) mbadaddr = value;
			mcause.interrupt = interrupt;
			mcause.exceptionCode = cause;
	        status.mpie = status.mie;
	        status.mie  = false;
	        status.mpp = privilege;
	        mepc = pc;
			break;
		case 1:
			if(valueWrite) sbadaddr = value;
			scause.interrupt = interrupt;
			scause.exceptionCode = cause;
	        status.spie = status.sie;
	        status.sie  = false;
	        status.spp  = privilege;
	        sepc = pc;
			break;
		}

		privilege = targetPrivilege;
		pcWrite(xtvec.base << 2);
		if(interrupt) livenessInterrupt = 0;

//		if(!interrupt) step(); //As VexRiscv instruction which trap do not reach writeback stage fire
	}

    uint32_t currentInstruction;
	void ilegalInstruction(){
		trap(0, 2, currentInstruction);
	}

	virtual void fail() {
	}



	virtual bool csrRead(int32_t csr, uint32_t *value){
		if(((csr >> 8) & 0x3) > privilege) return true;
		switch(csr){
		case MSTATUS: *value = (status.raw | (((status.raw & 0x6000) == 0x6000) ? 0x80000000 : 0)) & MSTATUS_READ_MASK;  break;
		case MIP: *value = getIp().raw; break;
		case MIE: *value = ie.raw; break;
		case MTVEC: *value = mtvec.raw; break;
		case MCAUSE: *value = mcause.raw; break;
		case MBADADDR: *value = mbadaddr; break;
		case MEPC: *value = mepc; break;
		case MSCRATCH: *value = mscratch; break;
		case MISA: *value = misa; break;
		case MEDELEG: *value = medeleg; break;
		case MIDELEG: *value = mideleg; break;
		case MHARTID: *value = 0; break;

		case SSTATUS: *value = (status.raw | (((status.raw & 0x6000) == 0x6000) ? 0x80000000 : 0)) & (0x800C0133 | STATUS_FS_MASK); break;
		case SIP: *value = getIp().raw & 0x333; break;
		case SIE: *value = ie.raw & 0x333; break;
		case STVEC: *value = stvec.raw; break;
		case SCAUSE: *value = scause.raw; break;
		case STVAL: *value = sbadaddr; break;
		case SEPC: *value = sepc; break;
		case SSCRATCH: *value = sscratch; break;
		case SATP: *value = satp.raw; break;

		#ifdef RVF
		case FCSR: *value = fcsr.raw; break;
		case FRM: *value = fcsr.frm; break;
		case FFLAGS: *value = fcsr.flags; break;
		#endif

        #ifdef UTIME_INPUT
		case UTIME: *value  = dutRfWriteValue; break;
		case UTIMEH: *value  = dutRfWriteValue; break;
		#endif

		default: return true; break;
		}
		return false;
	}

	virtual uint32_t csrReadToWriteOverride(int32_t csr, uint32_t value){
		if(((csr >> 8) & 0x3) > privilege) return true;
		switch(csr){
		case MIP: return ipSoft; break;
		case SIP: return ipSoft & 0x333; break;
		};
		return value;
	}

	#define maskedWrite(dst, src, mask) dst=((dst) & ~(mask))|((src) & (mask));

	virtual bool csrWrite(int32_t csr, uint32_t value){
		if(((csr >> 8) & 0x3) > privilege) return true;
		switch(csr){
		case MSTATUS: status.raw = value & 0x7FFFFFFF; break;
		case MIP: ipSoft = value; break;
		case MIE: ie.raw = value; break;
		case MTVEC: mtvec.raw = value; break;
		case MCAUSE: mcause.raw = value; break;
		case MBADADDR: mbadaddr = value; break;
		case MEPC: mepc = value; break;
		case MSCRATCH: mscratch = value; break;
		case MISA: misa = value; break;
		case MEDELEG: medeleg = value & (~0x8); break;
		case MIDELEG: mideleg = value; break;

		case SSTATUS: maskedWrite(status.raw, value, 0xC0133 | STATUS_FS_MASK);  break;
		case SIP: maskedWrite(ipSoft, value,0x333); break;
		case SIE: maskedWrite(ie.raw, value,0x333); break;
		case STVEC: stvec.raw = value; break;
		case SCAUSE: scause.raw = value; break;
		case STVAL: sbadaddr = value; break;
		case SEPC: sepc = value; break;
		case SSCRATCH: sscratch = value; break;
		case SATP: satp.raw = value;  break;

		#ifdef RVF
		case FCSR: fcsr.raw = value & 0x7F; break;
		case FRM: fcsr.frm = value; break;
		case FFLAGS: fcsr.flags = value; break;
		#endif

		default: ilegalInstruction(); return true; break;
		}
		return false;
	}

    
    int livenessStep = 0;
    int livenessInterrupt = 0;
    uint32_t pendingInterruptsPtr = 0;
    uint32_t pendingInterrupts[5] = {0,0,0,0,0};
    virtual void liveness(bool inWfi){
    	uint32_t pendingInterrupt = getPendingInterrupt();
    	pendingInterrupts[pendingInterruptsPtr++] = getPendingInterrupt();
    	if(pendingInterruptsPtr >= 5) pendingInterruptsPtr = 0;
        if(pendingInterrupt) livenessInterrupt++; else livenessInterrupt = 0;
        if(!inWfi) livenessStep++; else livenessStep = 0;

        if(livenessStep > 10000){
            cout << "Liveness step failure" << endl;
            fail();
        }
        
        if(livenessInterrupt > 1000){
            cout << "Liveness interrupt failure" << endl;
            fail();
        }
    }


    uint32_t getPendingInterrupt(){
    	uint32_t mEnabled = status.mie && privilege == 3 || privilege < 3;
    	uint32_t sEnabled = status.sie && privilege == 1 || privilege < 1;

    	uint32_t masked = getIp().raw & ~mideleg & -mEnabled & ie.raw;
		if (masked == 0)
			masked = getIp().raw & mideleg & -sEnabled & ie.raw & 0x333;

		if (masked) {
			if (masked & MIP_MEIP)
				masked &= MIP_MEIP;
			else if (masked & MIP_MSIP)
				masked &= MIP_MSIP;
			else if (masked & MIP_MTIP)
				masked &= MIP_MTIP;
			else if (masked & MIP_SEIP)
                masked &= MIP_SEIP;
            else if (masked & MIP_SSIP)
                masked &= MIP_SSIP;
            else if (masked & MIP_STIP)
                masked &= MIP_STIP;
            else
			  fail();
		}

		return masked;
    }


    bool isPcAligned(uint32_t pc){
#ifdef COMPRESSED
    	return (pc & 1) == 0;
#else
    	return (pc & 3) == 0;
#endif
    }



	virtual void step() {
	    stepCounter++;
	    livenessStep = 0;

	    while(fpuCompletionTockens != 0 && !fpuCompletion.empty()){
            FpuCompletion completion = fpuCompletion.front(); fpuCompletion.pop();
            fcsr.flags |= completion.flags;
            fpuCompletionTockens -= 1;
        }


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
		#define i32_func7 iBits(25, 7)
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
		uint32_t pAddr;
		if (pc & 2) {
			if(v2p(pc - 2, &pAddr, EXECUTE)){ trap(0, 12, pc - 2); return; }
			if(iRead(pAddr, &i)){
				trap(0, 1, 0);
				return;
			}
			i >>= 16;
			if ((i & 3) == 3) {
				uint32_t u32Buf;
				if(v2p(pc + 2, &pAddr, EXECUTE)){ trap(0, 12, pc + 2); return; }
				if(iRead(pAddr, &u32Buf)){
					trap(0, 1, 0);
					return;
				}
				i |= u32Buf << 16;
			}
		} else {
			if(v2p(pc, &pAddr, EXECUTE)){ trap(0, 12, pc); return; }
			if(iRead(pAddr, &i)){
				trap(0, 1, 0);
				return;
			}
		}
		lastInstruction = i;
		currentInstruction = i;
		if ((i & 0x3) == 0x3) {
			//32 bit
			switch (i & 0x7F) {
			#ifdef RVF
			case 0x43:// RVFD
			case 0x47:
			case 0x4B:
			case 0x4F:
			case 0x53: {
			    u32 format = iBits(25,2);
			    u32 opcode = iBits(27,5);
			    bool withCommit = fpuCommitLut[opcode];
			    bool withRsp = fpuRspLut[opcode];
			    bool withRs1 = fpuRs1Lut[opcode];
			    if((i & 0x7F) != 0x53) { // FMADD
			        withCommit = true;
			        withRsp = false;
			    }
			    #ifdef RVD
			    if(format > 1) ilegalInstruction();
			    #else
			    if(format > 0) ilegalInstruction();
			    #endif

			    if(withCommit){
			        FpuCommit commit = fpuCommit.front(); fpuCommit.pop();
			        fpuCompletionTockens += 1;
//			        cout << "withRs1 " << withRs1 << " " << opcode << endl;
                    if(withRs1 && memcmp(&i32_rs1, &commit.value, 4)){
                        cout << "FPU commit missmatch DUT=" << hex << commit.value << " REF=" << i32_rs1 << dec << endl;
                        fail();
                        return;
                    }
			    }
			    if(withRsp){
			        auto rsp = fpuRsp.front(); fpuRsp.pop();
			        fcsr.flags |= rsp.flags;
			        rfWrite(rd32, (u32)rsp.value);
			    }
                status.fs = 3;
                pcWrite(pc + 4);
			} break;
			case 0x07: { //Fpu load
                uint32_t size = 1 << ((i >> 12) & 0x3);
                if(size < 4) ilegalInstruction();
                #ifdef RVD
                if(size > 8) ilegalInstruction();
                #else
                if(format > 4) ilegalInstruction();
                #endif
                auto commit = fpuCommit.front();  fpuCommit.pop();
                fpuCompletionTockens += 1;


                uint64_t data = 0;
                uint32_t address = i32_rs1 + i32_i_imm;
                if(address & (size-1)){
                    trap(0, 4, address);
                } else {
                    if(v2p(address, &pAddr, READ)){ trap(0, 13, address); return; }
                    if(dRead(pAddr, size, (uint8_t*)&data)){
                        trap(0, 5, address);
                    } else {
                        if(memcmp(&data, &commit.value, size)){
                            cout << "FPU load missmatch DUT=" << hex << commit.value << " REF=" << data << dec << endl;
                            fail();
                        } else {
                            status.fs = 3;
                            pcWrite(pc + 4);
                        }
                    }
                }
			} break;
			case 0x27: { //Fpu store
                uint32_t size = 1 << ((i >> 12) & 0x3);
                if(size < 4) ilegalInstruction();
                #ifdef RVD
                if(size > 8) ilegalInstruction();
                #else
                if(format > 4) ilegalInstruction();
                #endif

                auto rsp = fpuRsp.front(); fpuRsp.pop();
                fcsr.flags |= rsp.flags;
                uint32_t address = i32_rs1 + i32_s_imm;
                if(address & (size-1)){
                    trap(0, 6, address);
                } else {
                    if(v2p(address, &pAddr, WRITE)){ trap(0, 15, address); return; }
                    dWrite(pAddr, size, (uint8_t*) &rsp.value);
                    status.fs = 3;
                    pcWrite(pc + 4);
                }
			} break;
			#endif
			case 0x37:rfWrite(rd32, i & 0xFFFFF000);pcWrite(pc + 4);break; // LUI
			case 0x17:rfWrite(rd32, (i & 0xFFFFF000) + pc);pcWrite(pc + 4);break; //AUIPC
			case 0x6F:rfWrite(rd32, pc + 4);pcWrite(pc + (iBits(21, 10) << 1) + (iBits(20, 1) << 11) + (iBits(12, 8) << 12) + (iSign() << 20));break; //JAL
			case 0x67:{
				uint32_t target = (i32_rs1 + i32_i_imm) & ~1;
				if(isPcAligned(target)) rfWrite(rd32, pc + 4);
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
			case 0x03:{ //LOADS
				uint32_t data;
				uint32_t address = i32_rs1 + i32_i_imm;
				uint32_t size = 1 << ((i >> 12) & 0x3);
				if(address & (size-1)){
					trap(0, 4, address);
				} else {
					if(v2p(address, &pAddr, READ)){ trap(0, 13, address); return; }
					if(dRead(pAddr, size, (uint8_t*)&data)){
					    trap(0, 5, address);
					} else {
                        switch ((i >> 12) & 0x7) {
                        case 0x0:rfWrite(rd32, int8_t(data));pcWrite(pc + 4);break;
                        case 0x1:rfWrite(rd32, int16_t(data));pcWrite(pc + 4);break;
                        case 0x2:rfWrite(rd32, int32_t(data));pcWrite(pc + 4);break;
                        case 0x4:rfWrite(rd32, uint8_t(data));pcWrite(pc + 4);break;
                        case 0x5:rfWrite(rd32, uint16_t(data));pcWrite(pc + 4);break;
                        }
					}
				}
			}break;
			case 0x23: { //STORE
				uint32_t address = i32_rs1 + i32_s_imm;
				uint32_t size = 1 << ((i >> 12) & 0x3);
				if(address & (size-1)){
					trap(0, 6, address);
				} else {
					if(v2p(address, &pAddr, WRITE)){ trap(0, 15, address); return; }
					dWrite(pAddr, size, (uint8_t*)&i32_rs2);
					pcWrite(pc + 4);
				}
			}break;
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
					case 0x4:rfWrite(rd32,i32_rs2 == 0 ? -1 : int64_t(i32_rs1) / int64_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x5:rfWrite(rd32,i32_rs2 == 0 ? -1 : uint32_t(i32_rs1) / uint32_t(i32_rs2));pcWrite(pc + 4);break;
					case 0x6:rfWrite(rd32,i32_rs2 == 0 ? i32_rs1 : int64_t(i32_rs1)% int64_t(i32_rs2));pcWrite(pc + 4);break;
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
						if(privilege < 3){ ilegalInstruction(); return;}
						privilege = status.mpp;
						status.mie = status.mpie;
						status.mpie = 1;
						status.mpp = 0;
						pcWrite(mepc);
					}break;
					case 0x10200073:{ //SRET
						if(privilege < 1){ ilegalInstruction(); return;}
						privilege = status.spp;
						status.sie = status.spie;
						status.spie = 1;
						status.spp = 0;
						pcWrite(sepc);
					}break;
					case 0x00000073:{ //ECALL
						trap(0, 8+privilege, 0x00000073); //To follow the VexRiscv area saving implementation
					}break;
					case 0x10500073:{ //WFI
						pcWrite(pc + 4);
					}break;
					default:
						if((i & 0xFE007FFF) == 0x12000073){ //SFENCE.VMA
							pcWrite(pc + 4);
						}else {
							ilegalInstruction();
						}
					break;
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
					uint32_t old;
					if(csrRead(i32_csr, &old)) { ilegalInstruction();return; }
					if(write) if(csrWrite(i32_csr, (csrReadToWriteOverride(i32_csr, old) & ~clear) | set)) { ilegalInstruction();return; }
					rfWrite(rd32, old);
					pcWrite(pc + 4);
				}
				break;
			}
			case 0x2F: // Atomic stuff
				switch(i32_func3){
				case 0x2:
					switch(iBits(27,5)){
					case 0x2:{ //LR
						uint32_t data;
						uint32_t address = i32_rs1;
						if(address & 3){
							trap(0, 4, address);
						} else {
							if(v2p(address, &pAddr, READ)){ trap(0, 13, address); return; }
							if(dRead(pAddr, 4, (uint8_t*)&data)){
							    trap(0, 5, address);
							} else {
								lrscReserved = true;
								lrscReservedAddress = pAddr;
								rfWrite(rd32, data);
								pcWrite(pc + 4);
							}
						}
					}	break;
					case 0x3:{ //SC
						uint32_t address = i32_rs1;
						if(address & 3){
							trap(0, 6, address);
						} else {
							if(v2p(address, &pAddr, WRITE)){ trap(0, 15, address); return; }
							#ifdef DBUS_EXCLUSIVE
                            bool hit = lrscReserved && lrscReservedAddress == pAddr;
                            #else
                            bool hit = lrscReserved;
                            #endif
							if(hit){
								dWrite(pAddr, 4, (uint8_t*)&i32_rs2);
							}
							lrscReserved = false;
							rfWrite(rd32, !hit);
							pcWrite(pc + 4);
						}
					}	break;
					default: {
                        #ifndef AMO
                        ilegalInstruction();
                        #else
                        uint32_t sel = (i >> 27) & 0x1F;
                        uint32_t addr = i32_rs1;
                        int32_t  src = i32_rs2;
                        int32_t readValue;

                        #ifdef DBUS_EXCLUSIVE
                        lrscReserved = false;
                        #endif

                        uint32_t pAddr;
						if(v2p(addr, &pAddr, READ_WRITE)){ trap(0, 15, addr); return; }
                        if(dRead(pAddr, 4, (uint8_t*)&readValue)){
                        	trap(0, 15, addr); return;
                            return;
                        }
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
                        default: ilegalInstruction(); return; break;
                        }
                        dWrite(pAddr, 4, (uint8_t*)&writeValue);
						rfWrite(rd32, readValue);
						pcWrite(pc + 4);
                        #endif
					 } break;
					}
					break;
				default: ilegalInstruction(); break;
				}
				break;
				case 0x0f:
				    if(i == 0x100F || (i & 0xF00FFFFF) == 0x000F){ // FENCE FENCE.I
							pcWrite(pc + 4);
				    } else{
				        ilegalInstruction();
				    }
				break;
			default: ilegalInstruction(); break;
			}
		} else {
			#ifndef COMPRESSED
			cout << "ERROR : RiscvGolden got a RVC instruction while the CPU isn't RVC ready" << endl;
	        ilegalInstruction(); return;
			#endif
			switch((iBits(0, 2) << 3) + iBits(13, 3)){
			case 0: rfWrite(i16_addr2, rf_sp + i16_addi4spn_imm); pcWrite(pc + 2); break;
			case 2:  {
				uint32_t data;
				uint32_t address = i16_rf1 + i16_lw_imm;
				if(address & 0x3){
					trap(0, 4, address);
				} else {
					if(v2p(address, &pAddr, READ)){ trap(0, 13, address); return; }
					if(dRead(pAddr, 4, (uint8_t*)&data)) {
					    trap(0, 5, address);
					} else {
					    rfWrite(i16_addr2, data); pcWrite(pc + 2);
                    }
				}
			} break;
			case 6: {
				uint32_t address = i16_rf1 + i16_lw_imm;
				if(address & 0x3){
					trap(0, 6, address);
				} else {
					if(v2p(address, &pAddr, WRITE)){ trap(0, 15, address); return; }
					dWrite(pAddr, 4, (uint8_t*)&i16_rf2);
                    pcWrite(pc + 2);
				}
			}break;
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
				uint32_t address = rf_sp + i16_lwsp_imm;
				if(address & 0x3){
					trap(0, 4, address);
				} else {
					if(v2p(address, &pAddr, READ)){ trap(0, 13, address); return; }
				    if(dRead(pAddr, 4,(uint8_t*) &data)){
					    trap(0, 5, address);
                    } else {
					    rfWrite(rd32, data); pcWrite(pc + 2);
                    }
				}
			}break;
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
			case 22: {
				uint32_t address = rf_sp + i16_swsp_imm;
				if(address & 3){
					trap(0,6, address);
				} else {
					if(v2p(address, &pAddr, WRITE)){ trap(0, 15, address); return; }
					dWrite(pAddr, 4, (uint8_t*)&regs[iBits(2,5)]); pcWrite(pc + 2);
				}
			}break;
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
	VerilatedFstC* tfp;
	#endif
	bool allowInvalidate = true;

	uint32_t seed;

	Workspace* setIStall(bool enable) { iStall = enable; return this; }
	Workspace* setDStall(bool enable) { dStall = enable; return this; }

	ofstream regTraces;
	ofstream memTraces;
	ofstream logTraces;
	ofstream debugLog;

	struct timespec start_time;

    class CpuRef : public RiscvGolden{
    public:
    	Memory mem;

    	class MemWrite {
    	public:
    		int32_t address, size;
    		uint8_t data42[64];
    	};

    	class MemRead {
    	public:
    		int32_t address, size;
    		uint8_t data42[64];
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


	    virtual bool isMmuRegion(uint32_t v) {return ws->isMmuRegion(v);}

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
        	bool error;
        	ws->iBusAccess(address, data, &error);
//    		ws->iBusAccessPatch(address,data,&error);
    		return error;
        }

        virtual bool dRead(int32_t address, int32_t size, uint8_t *data){
            if(size < 1 || size > 8){
                cout << "dRead size=" << size << endl;
                fail();
            }
            if((address & (size-1)) != 0)
            	cout << "Ref did a unaligned read" << endl;
    		if(ws->isPerifRegion(address)){
				MemRead t = periphRead.front();
				if(t.address != address || t.size != size){
					cout << "DRead missmatch" << hex <<  endl;
					cout << " REF : address=" << address << " size=" << size << endl;
					cout << " DUT : address=" << t.address  << " size=" << t.size << endl;
					fail();
				}

                for(int i = 0; i < size; i++){
                    data[i] = t.data42[i];
                }
				periphRead.pop();
				return t.error;
    		}else {
            	mem.read(address, size, data);
    		}
    		return false;
        }
        virtual void dWrite(int32_t address, int32_t size, uint8_t *data){
            if(address & (size-1) != 0)
            	cout << "Ref did a unaligned write" << endl;

    		if(!ws->isPerifRegion(address)){
    			mem.write(address, size, data);
    		}
    		if(ws->isDBusCheckedRegion(address)){
				MemWrite w;
				w.address = address;
				w.size = size;
                for(int i = 0; i < size; i++){
				    w.data42[i] = data[i];
				}
				periphWritesGolden.push(w);
				if(periphWritesGolden.size() > 10){
				    cout << "??? periphWritesGolden" << endl;
				    fail();
				}
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
    			bool dataMatch = true;
    			for(int i = 0;i < min(t.size, t2.size);i++) dataMatch &= t.data42[i] == t2.data42[i];
    			if(t.address != t2.address || t.size != t2.size || !dataMatch){
    				cout << hex << "periphWrite missmatch" << endl;
    				cout << " DUT address=" << t.address << " size=" << t.size  << " data=" << *((uint32_t*)t.data42) << endl;
    				cout << " REF address=" << t2.address << " size=" << t2.size  << " data=" << *((uint32_t*)t2.data42) << endl;
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
    string vcdName;
    Workspace* setVcdName(string name){
        vcdName = name;
        return this;
    }
	Workspace(string name){
	    vcdName = name;
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
		debugLog.open (name + ".debugTrace");
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

    Workspace* loadBin(string path, uint32_t offset){
    	loadBinImpl(path,&mem, offset);
    	loadBinImpl(path,&riscvRef.mem, offset);
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
        #ifdef WITH_RISCV_REF
    	riscvRefEnable = true;
        #endif
		return this;
    }

    Workspace* withInvalidation(){
        allowInvalidate = true;
        return this;
    }
    Workspace* withoutInvalidation(){
        allowInvalidate = false;
        return this;
    }
    Workspace* writeWord(uint32_t address, uint32_t data){
        mem.write(address, 4, (uint8_t*)&data);
        riscvRef.mem.write(address, 4, (uint8_t*)&data);
        return this;
    }

    virtual bool isPerifRegion(uint32_t addr) { return false; }
    virtual bool isMmuRegion(uint32_t addr) { return true;}
    virtual void iBusAccess(uint32_t addr, uint32_t *data, bool *error) {
		if(addr % 4 != 0) {
			cout << "Warning, unaligned IBusAccess : " << addr << endl;
			fail();
		}
		*data =     (  (mem[addr + 0] << 0)
					 | (mem[addr + 1] << 8)
					 | (mem[addr + 2] << 16)
					 | (mem[addr + 3] << 24));
		*error = false;
	}


    virtual bool isDBusCheckedRegion(uint32_t address){ return isPerifRegion(address);}
	virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size, uint8_t *data, bool *error) {
		assertEq(addr % size, 0);
		if(!isPerifRegion(addr)) {
			if(wr){
				for(uint32_t b = 0;b < size;b++){
                    *mem.get(addr + b) = ((uint8_t*)data)[b];
				}

			}else{
                uint32_t innerOffset = addr & (DBUS_LOAD_DATA_WIDTH/8-1);
				for(uint32_t b = 0;b < size;b++){
					((uint8_t*)data)[b] = mem[addr + b];
				}
			}
		}


		if(wr){
			if(isDBusCheckedRegion(addr)){
				CpuRef::MemWrite w;
				w.address = addr;
				w.size = size;
				for(uint32_t b = 0;b < size;b++){
				    w.data42[b] = data[b];
				}
				riscvRef.periphWrites.push(w);
			}
		} else {
			if(isPerifRegion(addr)){
				CpuRef::MemRead r;
				r.address = addr;
				r.size = size;
				for(uint32_t b = 0;b < size;b++){
				    r.data42[b] = data[b];
				}
				r.error = *error;
				riscvRef.periphRead.push(r);
			}
		}
	}

//	void periphAccess(uint32_t addr,bool wr, uint32_t size,uint32_t mask, uint32_t *data, bool *error){
//		if(wr){
//			CpuRef::MemWrite w;
//			w.address = addr;
//			w.size = 1 << size;
//			w.data = *data;
//			riscvRef.periphWrites.push(w);
//		} else {
//			CpuRef::MemRead r;
//			r.address = addr;
//			r.size = 1 << size;
//			r.data = *data;
//			r.error = *error;
//			riscvRef.periphRead.push(r);
//		}
//	}

	virtual void postReset() {}
	virtual void checks(){}
	virtual void pass(){ throw success();}
	virtual void fail(){ throw std::exception();}
    virtual void fillSimELements();
	void dump(uint64_t i){
		#ifdef TRACE
		if(i == TRACE_START && i != 0) cout << "**" << endl << "**" << endl << "**" << endl << "**" << endl << "**" << endl << "START TRACE" << endl;
		if(i >= TRACE_START) tfp->dump(i);
		#ifdef TRACE_SPORADIC
		else if(i % 1000000 < 100) tfp->dump(i);
		#endif
		#endif
	}

	uint64_t privilegeCounters[4] = {0,0,0,0};
	Workspace* run(uint64_t timeout = 5000){
//		cout << "Start " << name << endl;
		if(timeout == 0) timeout = 0x7FFFFFFFFFFFFFFF;

		currentTime = 4;
		// init trace dump
		#ifdef TRACE
		Verilated::traceEverOn(true);
		tfp = new VerilatedFstC;
		top->trace(tfp, 99);
		tfp->open((vcdName + ".fst").c_str());
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
		top->softwareInterrupt = 0;
		#endif
		#ifdef SUPERVISOR
		top->externalInterruptS = 0;
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
		    #if defined(IBUS_SIMPLE) || defined(IBUS_SIMPLE_WISHBONE) || defined(IBUS_SIMPLE_AHBLITE3)
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
				/*while(allowedCycles <= 0.0){
					struct timespec end_time;
					clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_time);
					uint64_t diffInNanos = end_time.tv_sec*1e9 + end_time.tv_nsec -  start_time.tv_sec*1e9 - start_time.tv_nsec;
					start_time = end_time;
					double dt = diffInNanos*1e-9;
					allowedCycles += dt*cyclesPerSecond;
					if(allowedCycles > cyclesPerSecond/100) allowedCycles = cyclesPerSecond/100;
				}
				allowedCycles-=1.0;*/


				#ifndef REF_TIME
                #ifndef MTIME_INSTR_FACTOR
                mTime = i/2;
                #else
				mTime += top->VexRiscv->lastStageIsFiring*MTIME_INSTR_FACTOR;
                #endif
				#endif
				#ifdef TIMER_INTERRUPT
				top->timerInterrupt = mTime >= mTimeCmp ? 1 : 0;
				//if(mTime == mTimeCmp) printf("SIM timer tick\n");
				#endif


				#ifdef UTIME_INPUT
				top->utime = mTime;
				#endif

				currentTime = i;

                #ifdef FLOW_INFO
                    if(i % 5000000 == 0) cout << endl << "**" << endl << "**"  << endl << "PROGRESS TRACE_START=" << i << endl;
                #endif


				// dump variables into VCD file and toggle clock

				dump(i);
				//top->eval();
				top->clk = 0;
				top->eval();

				#ifdef CSR
				    if(riscvRefEnable) {
                        riscvRef.ipInput = 0;
    #ifdef TIMER_INTERRUPT
                        riscvRef.ipInput |= top->timerInterrupt << 7;
    #endif
    #ifdef EXTERNAL_INTERRUPT
                        riscvRef.ipInput |= top->externalInterrupt << 11;
    #endif
    #ifdef CSR
                        riscvRef.ipInput |= top->softwareInterrupt << 3;
    #endif
    #ifdef SUPERVISOR
    //					riscvRef.ipInput |= top->timerInterruptS << 5;
                        riscvRef.ipInput |= top->externalInterruptS << 9;
    #endif

                        riscvRef.liveness(top->VexRiscv->CsrPlugin_inWfi);
                        if(top->VexRiscv->CsrPlugin_interruptJump){
                            if(riscvRefEnable) riscvRef.trap(true, top->VexRiscv->CsrPlugin_interrupt_code);
                        }
                    }
				#endif

                #ifdef RVF
                if(riscvRefEnable) {
                    if(top->VexRiscv->writeBack_FpuPlugin_commit_valid && top->VexRiscv->writeBack_FpuPlugin_commit_ready && top->VexRiscv->writeBack_FpuPlugin_commit_payload_write){
                        FpuCommit c;
                        c.value = top->VexRiscv->writeBack_FpuPlugin_commit_payload_value;
                        riscvRef.fpuCommit.push(c);
                    }

                    if(top->VexRiscv->FpuPlugin_port_rsp_valid && top->VexRiscv->FpuPlugin_port_rsp_ready && top->VexRiscv->lastStageIsFiring){
                        FpuRsp c;
                        c.value = top->VexRiscv->FpuPlugin_port_rsp_payload_value;
                        c.flags = (top->VexRiscv->FpuPlugin_port_rsp_payload_NX << 0) |
                                  (top->VexRiscv->FpuPlugin_port_rsp_payload_NV << 4);
                        riscvRef.fpuRsp.push(c);
                    }

                    if(top->VexRiscv->FpuPlugin_port_completion_valid && top->VexRiscv->FpuPlugin_port_completion_payload_written){
                        FpuCompletion c;
                        c.flags = (top->VexRiscv->FpuPlugin_port_completion_payload_flags_NX << 0) |
                                  (top->VexRiscv->FpuPlugin_port_completion_payload_flags_UF << 1) |
                                  (top->VexRiscv->FpuPlugin_port_completion_payload_flags_OF << 2) |
                                  (top->VexRiscv->FpuPlugin_port_completion_payload_flags_DZ << 3) |
                                  (top->VexRiscv->FpuPlugin_port_completion_payload_flags_NV << 4);
                        riscvRef.fpuCompletion.push(c);
                    }
                }
                #endif



                if(top->VexRiscv->lastStageIsFiring){
                   	if(riscvRefEnable) {
//                        privilegeCounters[riscvRef.privilege]++;
//                        if((riscvRef.stepCounter & 0xFFFFF) == 0){
//                            cout << "privilege report" << endl;
//                            cout << "- U " << privilegeCounters[0] << endl;
//                            cout << "- S " << privilegeCounters[1] << endl;
//                            cout << "- M " << privilegeCounters[3] << endl;
//                        }
                        riscvRef.dutRfWriteValue = top->VexRiscv->lastStageRegFileWrite_payload_data;
                   	    riscvRef.step();
                   	    bool mIntTimer = false;
                   	    bool mIntExt = false;
                   	}

                   	if(riscvRefEnable && top->VexRiscv->lastStagePc != riscvRef.lastPc){
						cout << hex << " pc missmatch " << top->VexRiscv->lastStagePc << " should be " << riscvRef.lastPc << dec << endl;
						fail();
					}


                	bool rfWriteValid = false;
                	int32_t rfWriteAddress;
                	int32_t rfWriteData;

                    if(top->VexRiscv->lastStageRegFileWrite_valid == 1 && top->VexRiscv->lastStageRegFileWrite_payload_address != 0){
                    	rfWriteValid = true;
                    	rfWriteAddress = top->VexRiscv->lastStageRegFileWrite_payload_address;
                    	rfWriteData = top->VexRiscv->lastStageRegFileWrite_payload_data;
                    	#ifdef TRACE_ACCESS
                        regTraces <<
                            #ifdef TRACE_WITH_TIME
                            currentTime <<
                             #endif
                             " PC " << hex << setw(8) <<  top->VexRiscv->lastStagePc << " : reg[" << dec << setw(2) << (uint32_t)top->VexRiscv->lastStageRegFileWrite_payload_address << "] = " << hex << setw(8) << top->VexRiscv->lastStageRegFileWrite_payload_data <<  dec << endl;
                        #endif
                    } else {
                        #ifdef TRACE_ACCESS
                        regTraces <<
                                #ifdef TRACE_WITH_TIME
                                currentTime <<
                                 #endif
                                 " PC " << hex << setw(8) <<  top->VexRiscv->lastStagePc << dec << endl;
                        #endif
                    }
					if(riscvRefEnable) if(rfWriteValid != riscvRef.rfWriteValid ||
						(rfWriteValid && (rfWriteAddress!= riscvRef.rfWriteAddress || rfWriteData!= riscvRef.rfWriteData))){
                    	cout << "regFile write missmatch :" << endl;
                    	if(rfWriteValid) cout << " REF: RF[" << riscvRef.rfWriteAddress << "] = 0x" << hex << riscvRef.rfWriteData << dec << endl;
                    	if(rfWriteValid) cout << " DUT: RF[" << rfWriteAddress << "] = 0x" << hex << rfWriteData << dec << endl;
                    	fail();
                    }
                }

                #ifdef CSR
                    if(top->VexRiscv->CsrPlugin_hadException){
                        if(riscvRefEnable) {
                            riscvRef.step();
                        }
                    }
                #endif

				for(SimElement* simElement : simElements) simElement->preCycle();

				dump(i + 1);

				checks();
				//top->eval();
				top->clk = 1;
				top->eval();

				instanceCycles += 1;

				for(SimElement* simElement : simElements) simElement->postCycle();
				#ifdef RVF
				top->fpuCmdHalt = VL_RANDOM_I(1);
                top->fpuCommitHalt = VL_RANDOM_I(1);
                top->fpuRspHalt = VL_RANDOM_I(1);
                #endif



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

			cout << "FAIL " <<  name << " at PC=" << hex << setw(8) << top->VexRiscv->lastStagePc << dec; //<<  " seed : " << seed <<
			if(riscvRefEnable) cout << hex << " REF PC=" << riscvRef.lastPc << " REF I=" << riscvRef.lastInstruction << dec;
			cout << " time=" << i;
			cout << endl;

			cycles += instanceCycles;
			staticMutex.unlock();
			failed = true;
		}



		dump(i+2);
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


class WorkspaceRegression : public Workspace {
public:

	WorkspaceRegression(string name) : Workspace(name){

	}

	virtual bool isPerifRegion(uint32_t addr) { return (addr & 0xF0000000) == 0xF0000000;}


	virtual void iBusAccess(uint32_t addr, uint32_t *data, bool *error){
		Workspace::iBusAccess(addr,data,error);
		*error = addr == 0xF00FFF60u;
	}

	virtual void dutPutChar(char c){}

	virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size, uint8_t *dataBytes, bool *error) {
        uint32_t *data = ((uint32_t*)dataBytes);
		if(wr){
			switch(addr){
			case 0xF0010000u: {
				cout << (char)*data;
				logTraces << (char)*data;
				dutPutChar((char)*data);
				break;
			}
#ifdef EXTERNAL_INTERRUPT
			case 0xF0011000u: top->externalInterrupt = *data & 1; break;
#endif
#ifdef SUPERVISOR
			case 0xF0012000u: top->externalInterruptS = *data & 1; break;
#endif
#ifdef CSR
			case 0xF0013000u: top->softwareInterrupt = *data & 1; break;
#endif
			case 0xF00FFF00u: {
				cout << (char)*data;
				logTraces << (char)*data;
				dutPutChar((char)*data);
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
			case 0xF00FFF4Cu: mTimeCmp = (mTimeCmp & 0x00000000FFFFFFFF) | (((uint64_t)*data) << 32); break;
			case 0xF00FFF50u: cout << "mTime " << *data << " : " << mTime << endl;
			}
			if((addr & 0xFFFFF000) == 0xF5670000){
			    uint32_t t = 0x900FF000 | (addr & 0xFFF);
			    uint32_t old = (*mem.get(t + 3) << 24) | (*mem.get(t + 2) << 16)  | (*mem.get(t + 1) << 8)  | (*mem.get(t + 0) << 0);
			    old++;
			    *mem.get(t + 0) = old & 0xFF; old >>= 8;
			    *mem.get(t + 1) = old & 0xFF; old >>= 8;
			    *mem.get(t + 2) = old & 0xFF; old >>= 8;
			    *mem.get(t + 3) = old & 0xFF; old >>= 8;
			}
		}else{
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
		}

		*error = addr == 0xF00FFF60u;
		Workspace::dBusAccess(addr,wr,size,dataBytes,error);
	}



};



class ZephyrRegression : public WorkspaceRegression{
public:


	uint32_t regFileWriteRefIndex = 0;
	const char *target = "PROJECT EXECUTION SUCCESSFUL";
	const char *hit = target;

	ZephyrRegression(string name) : WorkspaceRegression(name) {
            cout << endl << endl;

	}

    virtual void dutPutChar(char c){
        if(*hit == c) hit++; else hit = target;
        if(*hit == 0) {
            cout  << endl << "T=" << i <<endl;
            cout << endl;
            pass();
        }
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


#ifdef IBUS_TC

class IBusTc : public SimElement{
public:

    uint32_t nextData;

	Workspace *ws;
	VVexRiscv* top;
	IBusTc(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
	}

	virtual void preCycle(){
		if (top->iBusTc_enable) {
		    if((top->iBusTc_address & 0x70000000) != 0){
		        printf("IBusTc access out of range\n");
		        ws->fail();
		    }
	        bool error_next;
		    ws->iBusAccess(top->iBusTc_address, &nextData,&error_next);
		}
	}

	virtual void postCycle(){
		top->iBusTc_data = nextData;
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



#ifdef IBUS_SIMPLE_AHBLITE3
class IBusSimpleAhbLite3 : public SimElement{
public:
	Workspace *ws;
	VVexRiscv* top;

	uint32_t iBusAhbLite3_HRDATA;
	bool iBusAhbLite3_HRESP;
	bool pending;

	IBusSimpleAhbLite3(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
	    pending = false;
		top->iBusAhbLite3_HREADY = 1;
		top->iBusAhbLite3_HRESP = 0;
	}

	virtual void preCycle(){
        if (top->iBusAhbLite3_HTRANS == 2 && top->iBusAhbLite3_HREADY && !top->iBusAhbLite3_HWRITE) {
            ws->iBusAccess(top->iBusAhbLite3_HADDR,&iBusAhbLite3_HRDATA,&iBusAhbLite3_HRESP);
            pending = true;
        }
	}

	virtual void postCycle(){
		if(ws->iStall)
			top->iBusAhbLite3_HREADY = (!ws->iStall || VL_RANDOM_I(7) < 100);

		if(pending && top->iBusAhbLite3_HREADY){
			top->iBusAhbLite3_HRDATA = iBusAhbLite3_HRDATA;
			top->iBusAhbLite3_HRESP  = iBusAhbLite3_HRESP;
			pending = false;
		} else {
			top->iBusAhbLite3_HRDATA = VL_RANDOM_I(32);
			top->iBusAhbLite3_HRESP = VL_RANDOM_I(1);
		}
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
			assertEq((top->iBus_cmd_payload_address & 3),0);
			pendingCount = (1 << top->iBus_cmd_payload_size)/4;
			address = top->iBus_cmd_payload_address;
		}
	}

	virtual void postCycle(){
		bool error;
		top->iBus_rsp_valid = 0;
		if(pendingCount != 0 && (!ws->iStall || VL_RANDOM_I(7) < 100)){
		    #ifdef IBUS_TC
            if((address & 0x70000000) == 0){
                printf("IBUS_CACHED access out of range\n");
                ws->fail();
            }
            #endif
            error = false;
            for(int idx = 0;idx < IBUS_DATA_WIDTH/32;idx++){
                bool localError = false;
			    ws->iBusAccess(address+idx*4,((uint32_t*)&top->iBus_rsp_payload_data)+idx,&localError);
			    error |= localError;
            }
			top->iBus_rsp_payload_error = error;
			pendingCount-=IBUS_DATA_WIDTH/32;
			address = address + IBUS_DATA_WIDTH/8;
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
			ws->dBusAccess(top->dBus_cmd_payload_address,top->dBus_cmd_payload_wr,1 << top->dBus_cmd_payload_size,((uint8_t*)&data_next) + (top->dBus_cmd_payload_address & 3),&error_next);
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



#ifdef DBUS_SIMPLE_AHBLITE3
class DBusSimpleAhbLite3 : public SimElement{
public:
	Workspace *ws;
	VVexRiscv* top;

    uint32_t dBusAhbLite3_HADDR, dBusAhbLite3_HSIZE, dBusAhbLite3_HTRANS, dBusAhbLite3_HWRITE;

	DBusSimpleAhbLite3(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBusAhbLite3_HREADY = 1;
		top->dBusAhbLite3_HRESP = 0;
		dBusAhbLite3_HTRANS = 0;
	}

	virtual void preCycle(){
        if(top->dBusAhbLite3_HREADY && dBusAhbLite3_HTRANS == 2 && dBusAhbLite3_HWRITE){
            uint32_t data = top->dBusAhbLite3_HWDATA;
            bool error;
            ws->dBusAccess(dBusAhbLite3_HADDR, 1, dBusAhbLite3_HSIZE, ((1 << (1 << dBusAhbLite3_HSIZE))-1) << (dBusAhbLite3_HADDR & 0x3),&data,&error);
        }

        if(top->dBusAhbLite3_HREADY){
	        dBusAhbLite3_HADDR = top->dBusAhbLite3_HADDR ;
	        dBusAhbLite3_HSIZE = top->dBusAhbLite3_HSIZE ;
	        dBusAhbLite3_HTRANS = top->dBusAhbLite3_HTRANS ;
	        dBusAhbLite3_HWRITE = top->dBusAhbLite3_HWRITE ;
        }
	}

	virtual void postCycle(){
		if(ws->iStall)
			top->dBusAhbLite3_HREADY = (!ws->iStall || VL_RANDOM_I(7) < 100);

        top->dBusAhbLite3_HRDATA = VL_RANDOM_I(32);
        top->dBusAhbLite3_HRESP = VL_RANDOM_I(1);

		if(top->dBusAhbLite3_HREADY && dBusAhbLite3_HTRANS == 2 && !dBusAhbLite3_HWRITE){

		    bool error;
		    ws->dBusAccess(dBusAhbLite3_HADDR, 0, dBusAhbLite3_HSIZE, ((1 << (1 << dBusAhbLite3_HSIZE))-1) << (dBusAhbLite3_HADDR & 0x3),&top->dBusAhbLite3_HRDATA,&error);
            top->dBusAhbLite3_HRESP  = error;
		}
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
#include <queue>

struct DBusCachedTask{
	char data[DBUS_LOAD_DATA_WIDTH/8];
	bool error;
	bool last;
	bool exclusive;
};

class DBusCached : public SimElement{
public:
	queue<DBusCachedTask> rsps;
	queue<uint32_t> invalidationHint;

	bool reservationValid = false;
	uint32_t reservationAddress;
	uint32_t pendingSync = 0;

	Workspace *ws;
	VVexRiscv* top;
    DBusCachedTask rsp;

	DBusCached(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->dBus_cmd_ready = 1;
		top->dBus_rsp_valid = 0;
		#ifdef DBUS_AGGREGATION
		top->dBus_rsp_payload_aggregated = 0;
		#endif
		#ifdef DBUS_INVALIDATE
		top->dBus_inv_valid = 0;
		top->dBus_ack_ready = 0;
		top->dBus_sync_valid = 0;
		#ifdef DBUS_AGGREGATION
		top->dBus_sync_payload_aggregated = 0;
		#endif
		#endif
	}

	virtual void preCycle(){
		if (top->dBus_cmd_valid && top->dBus_cmd_ready) {
            if(top->dBus_cmd_payload_wr){
                int size = 1 << top->dBus_cmd_payload_size;
                #ifdef DBUS_INVALIDATE
                    pendingSync += 1;
                #endif
                #ifndef DBUS_EXCLUSIVE
                    bool error;
                    int shift = top->dBus_cmd_payload_address & (DBUS_STORE_DATA_WIDTH/8-1);
                    ws->dBusAccess(top->dBus_cmd_payload_address,1,size,((uint8_t*)&top->dBus_cmd_payload_data) + shift,&error);
                #else
                    bool cancel = false, error = false;
                    if(top->dBus_cmd_payload_exclusive){
                        bool hit = reservationValid && reservationAddress == top->dBus_cmd_payload_address;
                        rsp.exclusive = hit;
                        cancel = !hit;
                        reservationValid = false;
                    }
                    if(!cancel) {
                        for(int idx = 0;idx < 1;idx++){
                            bool localError = false;
                            int shift = top->dBus_cmd_payload_address & (DBUS_STORE_DATA_WIDTH/8-1);
                            ws->dBusAccess(top->dBus_cmd_payload_address,1,size,((uint8_t*)&top->dBus_cmd_payload_data) + shift,&localError);
                            error |= localError;
                        }
                    }

                    rsp.last = true;
                    rsp.error = error;
                    rsps.push(rsp);
                #endif
            } else {
                bool error = false;
                uint32_t beatCount = (((1 << top->dBus_cmd_payload_size)*8+DBUS_LOAD_DATA_WIDTH-1) / DBUS_LOAD_DATA_WIDTH)-1;
                uint32_t startAt = top->dBus_cmd_payload_address;
                uint32_t endAt = top->dBus_cmd_payload_address + (1 << top->dBus_cmd_payload_size);
                uint32_t address = top->dBus_cmd_payload_address & ~(DBUS_LOAD_DATA_WIDTH/8-1);
                uint8_t buffer[64];
                ws->dBusAccess(top->dBus_cmd_payload_address,0,1 << top->dBus_cmd_payload_size,buffer, &error);
                for(int beat = 0;beat <= beatCount;beat++){
                    for(int i = 0;i < DBUS_LOAD_DATA_WIDTH/8;i++){
                        rsp.data[i] = (address >= startAt && address < endAt) ? buffer[address-top->dBus_cmd_payload_address] : VL_RANDOM_I(8);
                        address += 1;
                    }
                    rsp.last = beat == beatCount;
                    #ifdef DBUS_EXCLUSIVE
                        if(top->dBus_cmd_payload_exclusive){
                            rsp.exclusive = true;
                            reservationValid = true;
                            reservationAddress = top->dBus_cmd_payload_address;
                        }
                    #endif
                    rsp.error = error;
                    rsps.push(rsp);
                }

                #ifdef DBUS_INVALIDATE
                    if(ws->allowInvalidate){
                        if(VL_RANDOM_I(7) < 10){
                            invalidationHint.push(top->dBus_cmd_payload_address + VL_RANDOM_I(5));
                        }
                    }
                #endif
            }
		}
		#ifdef DBUS_INVALIDATE
            if(top->dBus_sync_valid && top->dBus_sync_ready){
                pendingSync -= 1;
            }
        #endif
	}

	virtual void postCycle(){

		if(!rsps.empty() && (!ws->dStall || VL_RANDOM_I(7) < 100)){
			DBusCachedTask rsp = rsps.front();
			rsps.pop();
			top->dBus_rsp_valid = 1;
			top->dBus_rsp_payload_error = rsp.error;
            for(int idx = 0;idx < DBUS_LOAD_DATA_WIDTH/32;idx++){
                ((uint32_t*)&top->dBus_rsp_payload_data)[idx] = ((uint32_t*)rsp.data)[idx];
            }
			top->dBus_rsp_payload_last = rsp.last;
            #ifdef DBUS_EXCLUSIVE
            top->dBus_rsp_payload_exclusive = rsp.exclusive;
            #endif
		} else{
			top->dBus_rsp_valid = 0;
            for(int idx = 0;idx < DBUS_LOAD_DATA_WIDTH/32;idx++){
			    ((uint32_t*)&top->dBus_rsp_payload_data)[idx] = VL_RANDOM_I(32);
			}
			top->dBus_rsp_payload_error = VL_RANDOM_I(1);
			top->dBus_rsp_payload_last = VL_RANDOM_I(1);
            #ifdef DBUS_EXCLUSIVE
            top->dBus_rsp_payload_exclusive = VL_RANDOM_I(1);
            #endif
		}
		top->dBus_cmd_ready = (ws->dStall ? VL_RANDOM_I(7) < 100 : 1);

        #ifdef DBUS_INVALIDATE
            if(ws->allowInvalidate){
                if(top->dBus_inv_ready) top->dBus_inv_valid = 0;
                if(top->dBus_inv_valid == 0 && VL_RANDOM_I(7) < 5){
                    top->dBus_inv_valid = 1;
                    top->dBus_inv_payload_fragment_enable = VL_RANDOM_I(7) < 100;
                    if(!invalidationHint.empty()){
                        top->dBus_inv_payload_fragment_address = invalidationHint.front();
                        invalidationHint.pop();
                    } else {
                        top->dBus_inv_payload_fragment_address = VL_RANDOM_I(32);
                    }
                }
            }
		    top->dBus_ack_ready = (ws->dStall ? VL_RANDOM_I(7) < 100 : 1);
		    if(top->dBus_sync_ready) top->dBus_sync_valid = 0;
		    if(top->dBus_sync_valid == 0 && pendingSync != 0 && (ws->dStall ? VL_RANDOM_I(7) < 80 : 1) ){
		        top->dBus_sync_valid = 1;
            }
        #endif

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
                uint32_t size = __builtin_popcount(top->dBusAvalon_byteEnable);
                uint32_t offset = ffs(top->dBusAvalon_byteEnable)-1;
				bool error_next = false;
				ws->dBusAccess(top->dBusAvalon_address + beatCounter * 4 + offset,1,size,((uint8_t*)&top->dBusAvalon_writeData)+offset,&error_next);
				beatCounter++;
				if(beatCounter == top->dBusAvalon_burstCount){
					beatCounter = 0;
				}
			} else {
				for(int beat = 0;beat < top->dBusAvalon_burstCount;beat++){
					DBusCachedAvalonTask rsp;
					ws->dBusAccess(top->dBusAvalon_address  + beat * 4 ,0,4,((uint8_t*)&rsp.data),&rsp.error);
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
    #ifdef IBUS_SIMPLE_AHBLITE3
        simElements.push_back(new IBusSimpleAhbLite3(this));
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

	#ifdef IBUS_TC
		simElements.push_back(new IBusTc(this));
	#endif

	#ifdef DBUS_SIMPLE
		simElements.push_back(new DBusSimple(this));
	#endif
	#ifdef DBUS_SIMPLE_AVALON
		simElements.push_back(new DBusSimpleAvalon(this));
	#endif
    #ifdef DBUS_SIMPLE_AHBLITE3
        simElements.push_back(new DBusSimpleAhbLite3(this));
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

class TestA : public WorkspaceRegression{
public:


	uint32_t regFileWriteRefIndex = 0;

	TestA() : WorkspaceRegression("testA") {
		loadHex(string(REGRESSION_PATH) + "../../resources/hex/testA.hex");
	}

	virtual void checks(){
		if(top->VexRiscv->lastStageRegFileWrite_valid == 1 && top->VexRiscv->lastStageRegFileWrite_payload_address != 0){
			assertEq(top->VexRiscv->lastStageRegFileWrite_payload_address, regFileWriteRefArray[regFileWriteRefIndex][0]);
			assertEq(top->VexRiscv->lastStageRegFileWrite_payload_data, regFileWriteRefArray[regFileWriteRefIndex][1]);
			//printf("%d\n",i);

			regFileWriteRefIndex++;
			if(regFileWriteRefIndex == sizeof(regFileWriteRefArray)/sizeof(regFileWriteRefArray[0])){
				pass();
			}
		}
	}
};

class TestX28 : public WorkspaceRegression{
public:
	uint32_t refIndex = 0;
	uint32_t *ref;
	uint32_t refSize;

	TestX28(string name, uint32_t *ref, uint32_t refSize) : WorkspaceRegression(name) {
		this->ref = ref;
		this->refSize = refSize;
		loadHex(string(REGRESSION_PATH) + "../../resources/hex/" + name + ".hex");
	}

	virtual void checks(){
		if(top->VexRiscv->lastStageRegFileWrite_valid == 1 && top->VexRiscv->lastStageRegFileWrite_payload_address == 28){
			assertEq(top->VexRiscv->lastStageRegFileWrite_payload_data, ref[refIndex]);
			//printf("%d\n",i);

			refIndex++;
			if(refIndex == refSize){
				pass();
			}
		}
	}
};


class RiscvTest : public WorkspaceRegression{
public:
	RiscvTest(string name) : WorkspaceRegression(name) {
		loadHex(string(REGRESSION_PATH) + "../../resources/hex/" + name + ".hex");
		bootAt(0x800000bcu);
	}

	virtual void postReset() {
//		#ifdef CSR
//		top->VexRiscv->prefetch_PcManagerSimplePlugin_pcReg = 0x80000000u;
//		#else
//		#endif
	}

	virtual void checks(){
		if(top->VexRiscv->lastStageIsFiring && top->VexRiscv->lastStageInstruction == 0x00000013){
			uint32_t instruction;
			bool error;
			Workspace::mem.read(top->VexRiscv->lastStagePc, 4, (uint8_t*)&instruction);
			//printf("%x => %x\n", top->VexRiscv->lastStagePc, instruction );
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
					cout << "Error code " << code2/2 << endl;
					fail();
				}
			}
		}
	}

	virtual void iBusAccess(uint32_t addr, uint32_t *data, bool *error){
		WorkspaceRegression::iBusAccess(addr,data,error);
		if(*data == 0x0ff0000f) *data = 0x00000013;
		if(*data == 0x00000073) *data = 0x00000013;
	}
};
#endif
class Dhrystone : public WorkspaceRegression{
public:
	string hexName;
	Dhrystone(string name,string hexName,bool iStall, bool dStall) : WorkspaceRegression(name) {
		setIStall(iStall);
		setDStall(dStall);
		withRiscvRef();
		loadHex(string(REGRESSION_PATH) + "../../resources/hex/" + hexName + ".hex");
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
    	fclose(refFile);
    	

    	logTraces.flush();
    	logTraces.close();

		FILE *logFile = fopen((name + ".logTrace").c_str(), "r");
    	fseek(logFile, 0, SEEK_END);
    	uint32_t logSize = ftell(logFile);
    	fseek(logFile, 0, SEEK_SET);
    	char* log = new char[logSize];
    	fread(log, 1, logSize, logFile);
    	fclose(logFile);
    	
    	if(refSize > logSize || memcmp(log,ref,refSize))
    		fail();
		else
			Workspace::pass();
	}
};

class Compliance : public WorkspaceRegression{
public:
	string name;
	ofstream out32;
	int out32Counter = 0;
	Compliance(string name) : WorkspaceRegression(name) {
		withRiscvRef();
		loadHex(string(REGRESSION_PATH) + "../../resources/hex/" + name + ".elf.hex");
		out32.open (name + ".out32");
		this->name = name;
	}


    virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size, uint8_t *dataBytes, bool *error) {
        if(wr && addr == 0xF00FFF2C){
            uint32_t *data = (uint32_t*)dataBytes;
            out32 << hex << setw(8) << std::setfill('0') << *data << dec;
            if(++out32Counter % 4 == 0) out32 << "\n";
        }
    	WorkspaceRegression::dBusAccess(addr,wr,size,dataBytes,error);
    }

	virtual void checks(){

	}



	virtual void pass(){
		FILE *refFile = fopen((string(REGRESSION_PATH) + string("../../resources/ref/") + name + ".reference_output").c_str(), "r");
    	fseek(refFile, 0, SEEK_END);
    	uint32_t refSize = ftell(refFile);
    	fseek(refFile, 0, SEEK_SET);
    	char* ref = new char[refSize];
    	fread(ref, 1, refSize, refFile);
    	fclose(refFile);


    	out32.flush();
    	out32.close();

		FILE *logFile = fopen((name + ".out32").c_str(), "r");
    	fseek(logFile, 0, SEEK_END);
    	uint32_t logSize = ftell(logFile);
    	fseek(logFile, 0, SEEK_SET);
    	char* log = new char[logSize];
    	fread(log, 1, logSize, logFile);
    	fclose(logFile);

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

class DebugPluginTest : public WorkspaceRegression{
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


	DebugPluginTest() : WorkspaceRegression("DebugPluginTest") {
		loadHex(string(REGRESSION_PATH) + "../../resources/hex/debugPlugin.hex");
		 pthread_create(&clientThreadId, NULL, &clientThreadWrapper, this);
	}

	virtual ~DebugPluginTest(){
		if(clientSocket != -1) close(clientSocket);
	}

	virtual void checks(){
		if(clientSuccess) pass();
		if(clientFail) fail();
	}

    virtual void postReset(){
        Workspace::postReset();
        top->VexRiscv->DebugPlugin_debugUsed = 1;
    }
};

#endif


//#ifdef LITEX
//class LitexSoC : public Workspace{
//public:
//
//	LitexSoC(string name) : Workspace(name) {
//
//	}
//	virtual bool isDBusCheckedRegion(uint32_t address){ return true;}
//	virtual bool isPerifRegion(uint32_t addr) { return (addr & 0xF0000000) == 0xB0000000 || (addr & 0xE0000000) == 0xE0000000;}
//    virtual bool isMmuRegion(uint32_t addr) { return (addr & 0xFF000000) != 0x81000000;}
//
//    virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size,uint32_t mask, uint32_t *data, bool *error) {
//        if(isPerifRegion(addr)) switch(addr){
//    		//TODO Emulate peripherals here
//    		case 0xFFFFFFE0: if(wr) fail(); else *data = mTime; break;
//    		case 0xFFFFFFE4: if(wr) fail(); else *data = mTime >> 32; break;
//    		case 0xFFFFFFE8: if(wr) mTimeCmp = (mTimeCmp & 0xFFFFFFFF00000000) | *data; else *data = mTimeCmp; break;
//    		case 0xFFFFFFEC: if(wr) mTimeCmp = (mTimeCmp & 0x00000000FFFFFFFF) | (((uint64_t)*data) << 32); else *data = mTimeCmp >> 32; break;
//    		case 0xFFFFFFF8:
//    		    if(wr){
//                    cout << (char)*data;
//                    logTraces << (char)*data;
//                    logTraces.flush();
//				} else fail();
//				break;
//    		case 0xFFFFFFFC: fail(); break; //Simulation end
//    		default: cout << "Unmapped peripheral access : addr=0x" << hex << addr << " wr=" << wr << " mask=0x" << mask << " data=0x" << data << dec << endl; fail(); break;
//    	}
//
//    	Workspace::dBusAccess(addr,wr,size,mask,data,error);
//    }
//};
//#endif



#include <unistd.h>
#include <termios.h>
#include <fcntl.h>
termios stdinRestoreSettings;
void stdinNonBuffered(){
	static struct termios old, new1;
    tcgetattr(STDIN_FILENO, &old); // grab old terminal i/o settings
    new1 = old; // make new settings same as old settings
    new1.c_lflag &= ~ICANON; // disable buffered i/o
    new1.c_lflag &= ~ECHO;
    tcsetattr(STDIN_FILENO, TCSANOW, &new1); // use these new terminal i/o settings now
    setvbuf(stdin, NULL, _IONBF, 0);
    stdinRestoreSettings = old;
}


bool stdinNonEmpty(){
  struct timeval tv;
  fd_set fds;
  tv.tv_sec = 0;
  tv.tv_usec = 0;
  FD_ZERO(&fds);
  FD_SET(STDIN_FILENO, &fds);
  select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
  return (FD_ISSET(0, &fds));
}


void stdoutNonBuffered(){
    setvbuf(stdout, NULL, _IONBF, 0);
}

void stdinRestore(){
    tcsetattr(STDIN_FILENO, TCSANOW, &stdinRestoreSettings);
}



void my_handler(int s){
   printf("Caught signal %d\n",s);
   stdinRestore();
   exit(1);
}
#include <signal.h>

void captureCtrlC(){
    struct sigaction sigIntHandler;

    sigIntHandler.sa_handler = my_handler;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;

    sigaction(SIGINT, &sigIntHandler, NULL);
}




#if defined(LINUX_SOC) || defined(LINUX_REGRESSION)
#include <queue>
class LinuxSoc : public Workspace{
public:
    queue <char> customCin;
    void pushCin(string m){
        for(char& c : m) {
            customCin.push(c);
        }
    }

	LinuxSoc(string name) : Workspace(name) {
	    #ifdef WITH_USER_IO
		stdinNonBuffered();
		captureCtrlC();
	    #endif
		stdoutNonBuffered();
	}

	virtual ~LinuxSoc(){
	    #ifdef WITH_USER_IO
	    stdinRestore();
	    #endif
	}
	virtual bool isDBusCheckedRegion(uint32_t address){ return true;}
	virtual bool isPerifRegion(uint32_t addr) { return (addr & 0xF0000000) == 0xF0000000 || (addr & 0xE0000000) == 0xE0000000;}
    virtual bool isMmuRegion(uint32_t addr) { return true; }



    virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size,uint8_t *dataBytes, bool *error) {
        uint32_t *data = (uint32_t*)dataBytes;

        if(isPerifRegion(addr)) {
            switch(addr){
                case 0xFFFFFFE0: if(wr) fail(); else *data = mTime; break;
                case 0xFFFFFFE4: if(wr) fail(); else *data = mTime >> 32; break;
                case 0xFFFFFFE8: if(wr) mTimeCmp = (mTimeCmp & 0xFFFFFFFF00000000) | *data; else *data = mTimeCmp; break;
                case 0xFFFFFFEC: if(wr) mTimeCmp = (mTimeCmp & 0x00000000FFFFFFFF) | (((uint64_t)*data) << 32); else *data = mTimeCmp >> 32; break;
                case 0xFFFFFFF8:
                    if(wr){
                        char c = (char)*data;
                        cout << c;
                        logTraces << c;
                        logTraces.flush();
                        onStdout(c);
                    } else {
                        #ifdef WITH_USER_IO
                        if(stdinNonEmpty()){
                            char c;
                            read(0, &c, 1);
                            *data = c;
                        } else
                        #endif
                        if(!customCin.empty()){
                            *data = customCin.front();
                            customCin.pop();
                        } else {
                            *data = -1;
                        }
                    }
                    break;
                case 0xFFFFFFFC: fail(); break; //Simulation end
                default: cout << "Unmapped peripheral access : addr=0x" << hex << addr << " wr=" << wr << " mask=0x"  << " data=0x" << data << dec << endl; fail(); break;
    		}
    	}
        Workspace::dBusAccess(addr,wr,size,dataBytes,error);
    }

    virtual void onStdout(char c){

    }
};

class LinuxRegression: public LinuxSoc{
public:
    string pendingLine = "";
    bool pendingLineContain(string m) {
        return strstr(pendingLine.c_str(), m.c_str()) != NULL;
    }

    enum State{LOGIN, ECHO_FILE, HEXDUMP, HEXDUMP_CHECK, PASS};
    State state = LOGIN;
	LinuxRegression(string name) : LinuxSoc(name) {

	}

    ~LinuxRegression() {
    }


    virtual void onStdout(char c){
        pendingLine += c;
        switch(state){
        case LOGIN: if (pendingLineContain("buildroot login:")) { pushCin("root\n"); state = ECHO_FILE; } break;
        case ECHO_FILE: if (pendingLineContain("# ")) { pushCin("echo \"miaou\" > test.txt\n"); state = HEXDUMP; pendingLine = "";} break;
        case HEXDUMP: if (pendingLineContain("# ")) { pushCin("hexdump -C test.txt\n"); state = HEXDUMP_CHECK; pendingLine = "";} break;
        case HEXDUMP_CHECK: if (pendingLineContain("00000000  6d 69 61 6f 75 0a  ")) { pushCin(""); state = PASS; pendingLine = "";} break;
        case PASS: if (pendingLineContain("# ")) { pass(); } break;
        }
        if(c == '\n' || pendingLine.length() > 200) pendingLine = "";
    }
};

#endif

#ifdef LINUX_SOC_SMP

class LinuxSocSmp : public Workspace{
public:
    queue <char> customCin;
    void pushCin(string m){
        for(char& c : m) {
            customCin.push(c);
        }
    }

	LinuxSocSmp(string name) : Workspace(name) {
	    #ifdef WITH_USER_IO
		stdinNonBuffered();
		captureCtrlC();
	    #endif
		stdoutNonBuffered();
	}

	virtual ~LinuxSocSmp(){
	    #ifdef WITH_USER_IO
	    stdinRestore();
	    #endif
	}
	virtual bool isDBusCheckedRegion(uint32_t address){ return true;}
	virtual bool isPerifRegion(uint32_t addr) { return (addr & 0xF0000000) == 0xF0000000;}
    virtual bool isMmuRegion(uint32_t addr) { return true; }



    virtual void dBusAccess(uint32_t addr,bool wr, uint32_t size, uint8_t *dataBytes, bool *error) {
        uint32_t *data = (uint32_t*)dataBytes;
        if(isPerifRegion(addr)) switch(addr){
    		case 0xF0010000: if(wr && *data != 0) fail(); else *data = 0;  break;
    		case 0xF001BFF8: if(wr) fail(); else *data = mTime; break;
    		case 0xF001BFFC: if(wr) fail(); else *data = mTime >> 32; break;
    		case 0xF0014000: if(wr) mTimeCmp = (mTimeCmp & 0xFFFFFFFF00000000) | *data; else fail(); break;
    		case 0xF0014004: if(wr) mTimeCmp = (mTimeCmp & 0x00000000FFFFFFFF) | (((uint64_t)*data) << 32); else fail(); break;
    		case 0xF0000000:
    		    if(wr){
    		        char c = (char)*data;
                    cout << c;
                    logTraces << c;
                    logTraces.flush();
                    onStdout(c);
				}
            case 0xF0000004:
    		    if(!wr){
				    #ifdef WITH_USER_IO
					if(stdinNonEmpty()){
						char c;
						read(0, &c, 1);
						*data = c;
					} else
					#endif
					if(!customCin.empty()){
					    *data = customCin.front();
                        customCin.pop();
					} else {
						*data = -1;
					}
				}
				break;
    		default: cout << "Unmapped peripheral access : addr=0x" << hex << addr << " wr=" << wr << " data=0x" << data << dec << endl; fail(); break;
    	}
        Workspace::dBusAccess(addr,wr,size,dataBytes,error);
    }

    virtual void onStdout(char c){

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


string riscvTestFloat[] = {
    "rv32uf-p-fmadd",
    "rv32uf-p-fadd",
    "rv32uf-p-fcmp",
    "rv32uf-p-fcvt_w",
    "rv32uf-p-ldst",
    "rv32uf-p-recoding",
    "rv32uf-p-fclass",
    "rv32uf-p-fcvt",
    "rv32uf-p-fdiv",
    "rv32uf-p-fmin",
    "rv32uf-p-move"
};


string riscvTestDouble[] = {
    "rv32ud-p-fmadd",
    "rv32ud-p-fadd",
    "rv32ud-p-fcvt",
    "rv32ud-p-recoding",
    "rv32ud-p-fclass",
    "rv32ud-p-fcvt_w",
    "rv32ud-p-fmin",
    "rv32ud-p-fcmp",
    "rv32ud-p-fdiv",
    "rv32ud-p-ldst"
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
		"QueueSet", "recmutex", "semtest", "TaskNotify", "crhook", "dynamic",
		"GenQTest", "PollQ", "QueueOverwrite", "QueueSetPolling", "sp_flop", "test1"
		//"BlockQ","BlockQ","BlockQ","BlockQ","BlockQ","BlockQ","BlockQ","BlockQ"
//		"flop"
//		 "flop", "sp_flop" // <- Simple test
		 // "AltBlckQ" ???

};


string zephyrTests[] = {
    "tests_kernel_stack_stack_api",
    "tests_kernel_context",
//    "tests_kernel_critical",  //Too long
    "tests_kernel_fifo_fifo_api",
    "tests_kernel_mbox_mbox_usage",
//    "tests_kernel_mem_pool_mem_pool_threadsafe", //Too long
    "tests_kernel_sleep"
//    "tests_kernel_timer_timer_api" //Lock like if the CPU is too slow, it will make it fail
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
            printf("MT_SEED=%d \n", seed);
        #endif
		std::function<void()> lambda = lambdas->front();
		lambdas->pop();
		mutex->unlock();

		lambda();
	}
}


static void multiThreadedExecute(queue<std::function<void()>> &lambdas){
    std::mutex mutex;
    if(THREAD_COUNT == 1){
        multiThreading(&lambdas, &mutex);
    } else {
        std::thread * t[THREAD_COUNT];
        for(int id = 0;id < THREAD_COUNT;id++){
            t[id] = new thread(multiThreading,&lambdas,&mutex);
        }
        for(int id = 0;id < THREAD_COUNT;id++){
            t[id]->join();
            delete t[id];
        }
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


#ifdef LINUX_SOC_SMP
    {

	    LinuxSocSmp soc("linuxSmp");
	    #ifndef DEBUG_PLUGIN_EXTERNAL
	    soc.withRiscvRef();
		soc.loadBin(EMULATOR, 0x80000000);
		soc.loadBin(VMLINUX,  0x80400000);
		soc.loadBin(DTB,      0x80FF0000);
		soc.loadBin(RAMDISK,  0x81000000);
		#endif
		//soc.setIStall(true);
		//soc.setDStall(true);
		soc.bootAt(0x80000000);
		soc.run(0);
//		soc.run((496300000l + 2000000) / 2);
//		soc.run(438700000l/2);
        return -1;
    }
#endif



    #ifdef RVF
    for(const string &name : riscvTestFloat){
        redo(REDO,RiscvTest(name).withRiscvRef()->bootAt(0x80000188u)->writeWord(0x80000184u, 0x00305073)->run();)
    }
    #endif
    #ifdef RVD
    for(const string &name : riscvTestDouble){
        redo(REDO,RiscvTest(name).withRiscvRef()->bootAt(0x80000188u)->writeWord(0x80000184u, 0x00305073)->run();)
    }
    #endif
    //return 0;

//#ifdef LITEX
//	LitexSoC("linux")
//		.withRiscvRef()
//		->loadBin(EMULATOR, 0x80000000)
//		->loadBin(DTB,      0x81000000)
//		->loadBin(VMLINUX,  0xc0000000)
//		->loadBin(RAMDISK,  0xc2000000)
//		->setIStall(false) //TODO It currently improve speed but should be removed later
//		->setDStall(false)
//		->bootAt(0x80000000)
//		->run(0);
//#endif

//	{
//		static struct termios old, new1;
//	    tcgetattr(0, &old); /* grab old terminal i/o settings */
//	    new1 = old; /* make new settings same as old settings */
//	    new1.c_lflag &= ~ICANON; /* disable buffered i/o */
//	    new1.c_lflag &= ~ECHO;
//	    tcsetattr(0, TCSANOW, &new1); /* use these new terminal i/o settings now */
//	}
//
//	   std::string initialCommand;
//
//	   while(true){
//	     if(!inputAvailable()) {
//	       std::cout << "Waiting for input (Ctrl-C to cancel)..." << std::endl;
//	       sleep(1);
//	     } else {
//	     char c;
//	     read(0, &c, 1); printf("%d\n", c);
////	     std::getline(std::cin, initialCommand);
//	     }
//	   }
//

//	char c;
//    while (1) { read(0, &c, 1); printf("%d\n", c); }
//	while(true){
//		char c = getchar();
//		if(c > 0)
//		{
//			putchar(c);
//		} else {
//			putchar('*');
//			sleep(500);
//		}
//	}

#ifdef LINUX_SOC
    {

	    LinuxSoc soc("linux");
	    #ifndef DEBUG_PLUGIN_EXTERNAL
	    soc.withRiscvRef();
		soc.loadBin(EMULATOR, 0x80000000);
		soc.loadBin(VMLINUX,  0xC0000000);
		soc.loadBin(DTB,      0xC3000000);
		soc.loadBin(RAMDISK,  0xC2000000);
		#endif
		//soc.setIStall(true);
		//soc.setDStall(true);
		soc.bootAt(0x80000000);
		soc.run(0);
//		soc.run((496300000l + 2000000) / 2);
//		soc.run(438700000l/2);
        return -1;
    }
#endif





//    #ifdef MMU
//        redo(REDO,WorkspaceRegression("mmu").withRiscvRef()->loadHex("../raw/mmu/build/mmu.hex")->bootAt(0x80000000u)->run(50e3););
//    #endif
//     redo(REDO,WorkspaceRegression("deleg").withRiscvRef()->loadHex("../raw/deleg/build/deleg.hex")->bootAt(0x80000000u)->run(50e3););
//    return 0;


	for(int idx = 0;idx < 1;idx++){

		#if defined(DEBUG_PLUGIN_EXTERNAL) || defined(RUN_HEX)
		{
			WorkspaceRegression w("run");
			#ifdef RUN_HEX
			//w.loadHex("/home/spinalvm/hdl/zephyr/zephyrSpinalHdl/samples/synchronization/build/zephyr/zephyr.hex");
			w.loadHex(RUN_HEX);
			w.withRiscvRef();
			#endif
			w.setIStall(false);
			w.setDStall(false);

			#if defined(TRACE) || defined(TRACE_ACCESS)
				//w.setCyclesPerSecond(5e3);
				//printf("Speed reduced 5Khz\n");
			#endif
			w.run(0xFFFFFFFFFFFF);
			exit(0);
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
			#if defined(CSR) && !defined(CSR_SKIP_TEST)
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
				redo(REDO,RiscvTest(name).withRiscvRef()->run();)
			}
			for(const string &name : riscvTestMemory){
				redo(REDO,RiscvTest(name).withRiscvRef()->run();)
			}


			#ifdef MUL
			for(const string &name : riscvTestMul){
				redo(REDO,RiscvTest(name).withRiscvRef()->run();)
			}
			#endif
			#ifdef DIV
			for(const string &name : riscvTestDiv){
				redo(REDO,RiscvTest(name).withRiscvRef()->run();)
			}
			#endif

            #ifdef COMPRESSED
            redo(REDO,RiscvTest("rv32uc-p-rvc").withRiscvRef()->bootAt(0x800000FCu)->run());
            #endif

			#if defined(CSR) && !defined(CSR_SKIP_TEST)
			    #ifndef COMPRESSED
				    uint32_t machineCsrRef[] = {1,11,   2,0x80000003u,   3,0x80000007u,   4,0x8000000bu,   5,6,7,0x80000007u     ,
				    8,6,9,6,10,4,11,4,    12,13,0,   14,2,     15,5,16,17,1 };
				    redo(REDO,TestX28("../../cpp/raw/machineCsr/build/machineCsr",machineCsrRef, sizeof(machineCsrRef)/4).withRiscvRef()->setVcdName("machineCsr")->run(10e4);)
                #else
				    uint32_t machineCsrRef[] = {1,11,   2,0x80000003u,   3,0x80000007u,   4,0x8000000bu,   5,6,7,0x80000007u     ,
				    8,6,9,6,10,4,11,4,    12,13,   14,2,     15,5,16,17,1 };
				    redo(REDO,TestX28("../../cpp/raw/machineCsr/build/machineCsrCompressed",machineCsrRef, sizeof(machineCsrRef)/4).withRiscvRef()->setVcdName("machineCsrCompressed")->run(10e4);)
                #endif
			#endif
//			#ifdef MMU
//				uint32_t mmuRef[] = {1,2,3, 0x11111111, 0x11111111, 0x11111111, 0x22222222, 0x22222222, 0x22222222, 4, 0x11111111, 0x33333333, 0x33333333, 5,
//					13, 0xC4000000,0x33333333, 6,7,
//					1,2,3, 0x11111111, 0x11111111, 0x11111111, 0x22222222, 0x22222222, 0x22222222, 4, 0x11111111, 0x33333333, 0x33333333, 5,
//					13, 0xC4000000,0x33333333, 6,7};
//				redo(REDO,TestX28("mmu",mmuRef, sizeof(mmuRef)/4).noInstructionReadCheck()->run(4e4);)
//			#endif

            #ifdef IBUS_CACHED
                redo(REDO,WorkspaceRegression("icache").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../raw/icache/build/icache.hex")->bootAt(0x80000000u)->run(50e3););
            #endif
            #ifdef DBUS_CACHED
                redo(REDO,WorkspaceRegression("dcache").loadHex(string(REGRESSION_PATH) + "../raw/dcache/build/dcache.hex")->bootAt(0x80000000u)->run(2500e3););
            #endif

            #ifdef MMU
                redo(REDO,WorkspaceRegression("mmu").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../raw/mmu/build/mmu.hex")->bootAt(0x80000000u)->run(50e3););
            #endif
            #ifdef SUPERVISOR
                redo(REDO,WorkspaceRegression("deleg").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../raw/deleg/build/deleg.hex")->bootAt(0x80000000u)->run(50e3););
            #endif

			#ifdef DEBUG_PLUGIN
			#ifndef CONCURRENT_OS_EXECUTIONS
				redo(REDO,DebugPluginTest().run(1e6););
            #endif
			#endif
		#endif

		#ifdef CUSTOM_SIMD_ADD
			redo(REDO,WorkspaceRegression("custom_simd_add").loadHex(string(REGRESSION_PATH) + "../custom/simd_add/build/custom_simd_add.hex")->bootAt(0x00000000u)->run(50e3););
		#endif

		#ifdef CUSTOM_CSR
			redo(REDO,WorkspaceRegression("custom_csr").loadHex(string(REGRESSION_PATH) + "../custom/custom_csr/build/custom_csr.hex")->bootAt(0x00000000u)->run(50e3););
		#endif


		#ifdef LRSC
			redo(REDO,WorkspaceRegression("lrsc").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../raw/lrsc/build/lrsc.hex")->bootAt(0x00000000u)->run(10e3););
		#endif

		#ifdef PMP
			redo(REDO,WorkspaceRegression("pmp").loadHex(string(REGRESSION_PATH) + "../raw/pmp/build/pmp.hex")->bootAt(0x80000000u)->run(10e3););
		#endif

		#ifdef AMO
			redo(REDO,WorkspaceRegression("amo").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../raw/amo/build/amo.hex")->bootAt(0x00000000u)->run(10e3););
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
			#if defined(COMPRESSED)
			Dhrystone("dhrystoneO3C","dhrystoneO3C",false,false).run(1.9e6);
            #endif
			Dhrystone("dhrystoneO3","dhrystoneO3",false,false).run(1.9e6);
			#if defined(MUL) && defined(DIV)
				#if defined(COMPRESSED)
				    Dhrystone("dhrystoneO3MC","dhrystoneO3MC",false,false).run(1.9e6);
				#endif
				Dhrystone("dhrystoneO3M","dhrystoneO3M",false,false).run(1.9e6);
			#endif
		#endif

        #ifdef COREMARK
            for(int withStall = 1; true ;withStall--){
                string rv = "rv32i";
                #if defined(MUL) && defined(DIV)
                    rv += "m";
                #endif
                #if defined(COMPRESSED)
                    if(withStall == -2) break;
                    if(withStall != -1) rv += "c";
                #else
                    if(withStall == -1) break;
                #endif
                WorkspaceRegression("coremark_" + rv + (withStall  > 0 ? "_stall" : "_nostall")).withRiscvRef()
                ->loadBin(string(REGRESSION_PATH) + "../../resources/bin/coremark_" + rv + ".bin", 0x80000000)
                ->bootAt(0x80000000)
                ->setIStall(withStall > 0)
                ->setDStall(withStall > 0)
                ->run(50e6);
            }
        #endif



		#ifdef FREERTOS
		{
		    #ifdef SEED
            srand48(SEED);
            #endif
			//redo(1,WorkspaceRegression("freeRTOS_demo").loadHex("../../resources/hex/freeRTOS_demo.hex")->bootAt(0x80000000u)->run(100e6);)
			vector <std::function<void()>> tasks;

            /*for(int redo = 0;redo < 4;redo++)*/{
                for(const string &name : freeRtosTests){
                    tasks.push_back([=]() { WorkspaceRegression(name + "_rv32i_O0").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/freertos/" + name + "_rv32i_O0.hex")->bootAt(0x80000000u)->run(4e6*15);});
                    tasks.push_back([=]() { WorkspaceRegression(name + "_rv32i_O3").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/freertos/" + name + "_rv32i_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
                    #ifdef COMPRESSED
//                        tasks.push_back([=]() { WorkspaceRegression(name + "_rv32ic_O0").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/freertos/" + name + "_rv32ic_O0.hex")->bootAt(0x80000000u)->run(5e6*15);});
                        tasks.push_back([=]() { WorkspaceRegression(name + "_rv32ic_O3").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/freertos/" + name + "_rv32ic_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
                    #endif
                    #if defined(MUL) && defined(DIV)
//                        #ifdef COMPRESSED
//                            tasks.push_back([=]() { WorkspaceRegression(name + "_rv32imac_O3").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/freertos/" + name + "_rv32imac_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
//                        #else
                            tasks.push_back([=]() { WorkspaceRegression(name + "_rv32im_O3").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/freertos/" + name + "_rv32im_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
//                        #endif
                    #endif
                }
			}

            while(tasks.size() > FREERTOS_COUNT){
                tasks.erase(tasks.begin() + (VL_RANDOM_I(32)%tasks.size()));
            }


            queue <std::function<void()>> tasksSelected(std::deque<std::function<void()>>(tasks.begin(), tasks.end()));
			multiThreadedExecute(tasksSelected);
        }
		#endif

        #ifdef ZEPHYR
        {
            #ifdef SEED
            srand48(SEED);
            #endif
            //redo(1,WorkspaceRegression("freeRTOS_demo").loadHex("../../resources/hex/freeRTOS_demo.hex")->bootAt(0x80000000u)->run(100e6);)
            vector <std::function<void()>> tasks;

            /*for(int redo = 0;redo < 4;redo++)*/{
                for(const string &name : zephyrTests){
                    #ifdef COMPRESSED
                        tasks.push_back([=]() { ZephyrRegression(name + "_rv32ic").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/VexRiscvRegressionData/sim/zephyr/" + name + "_rv32ic.hex")->bootAt(0x80000000u)->run(180e6);});
                    #else
                        tasks.push_back([=]() { ZephyrRegression(name + "_rv32i").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/VexRiscvRegressionData/sim/zephyr/" + name + "_rv32i.hex")->bootAt(0x80000000u)->run(180e6);});
                    #endif
                    #if defined(MUL) && defined(DIV)
                            tasks.push_back([=]() { ZephyrRegression(name + "_rv32im").withRiscvRef()->loadHex(string(REGRESSION_PATH) + "../../resources/VexRiscvRegressionData/sim/zephyr/" + name + "_rv32im.hex")->bootAt(0x80000000u)->run(180e6);});
                    #endif
                }
            }

            while(tasks.size() > ZEPHYR_COUNT){
                tasks.erase(tasks.begin() + (VL_RANDOM_I(32)%tasks.size()));
            }


            queue <std::function<void()>> tasksSelected(std::deque<std::function<void()>>(tasks.begin(), tasks.end()));
            multiThreadedExecute(tasksSelected);
        }
        #endif

		#if defined(LINUX_REGRESSION)
            {

        	    LinuxRegression soc("linux");
        	    #ifndef DEBUG_PLUGIN_EXTERNAL
        	    soc.withRiscvRef();
        		soc.loadBin(string(REGRESSION_PATH) + EMULATOR, 0x80000000);
        		soc.loadBin(string(REGRESSION_PATH) + VMLINUX,  0xC0000000);
        		soc.loadBin(string(REGRESSION_PATH) + DTB,      0xC3000000);
        		soc.loadBin(string(REGRESSION_PATH) + RAMDISK,  0xC2000000);
        		#endif
        		//soc.setIStall(true);
        		//soc.setDStall(true);
        		soc.bootAt(0x80000000);
        		soc.run(153995602l*9);
//        		soc.run((470000000l + 2000000) / 2);
//        		soc.run(438700000l/2);
            }
        #endif

	}

	uint64_t duration = timer_end(startedAt);
	cout << endl << "****************************************************************" << endl;
	cout << "Had simulate " << Workspace::cycles << " clock cycles in " << duration*1e-9 << " s (" << Workspace::cycles / (duration*1e-6) << " Khz)" << endl;
	if(Workspace::successCounter == Workspace::testsCounter)
		cout << "REGRESSION SUCCESS " << Workspace::successCounter << "/" << Workspace::testsCounter << endl;
	else
		cout<< "REGRESSION FAILURE " << Workspace::testsCounter - Workspace::successCounter << "/"  << Workspace::testsCounter << endl;
	cout << "****************************************************************" << endl << endl;


	exit(0);
}
