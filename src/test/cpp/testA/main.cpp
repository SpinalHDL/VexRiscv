#include "VVexRiscv.h"
#include "VVexRiscv_VexRiscv.h"
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

//#define REF
//#define TRACE

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
			for(uint32_t i = 0;i < 1024*1024;i++) ptr[i] = 0xFF;
			mem[address >> 20] = ptr;
		}
		return &mem[address >> 20][address & 0xFFFFF];
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

uint32_t testsCounter = 0, successCounter = 0;

uint64_t currentTime = 22;
double sc_time_stamp(){
	return currentTime;
}


class Workspace{
public:
	static uint32_t cycles;
	Memory mem;
	string name;
	VVexRiscv* top;
	int i;
	uint32_t iStall = 1,dStall = 1;
	#ifdef TRACE
	VerilatedVcdC* tfp;
	#endif

	void setIStall(bool enable) { iStall = enable; }
	void setDStall(bool enable) { dStall = enable; }

	ofstream regTraces;
	ofstream memTraces;
	ofstream logTraces;


	Workspace(string name){
		testsCounter++;
		this->name = name;
		top = new VVexRiscv;
		regTraces.open (name + ".regTrace");
		memTraces.open (name + ".memTrace");
		logTraces.open (name + ".logTrace");
	}

	virtual ~Workspace(){
		delete top;
		#ifdef TRACE
		delete tfp;
		#endif
	}

	Workspace* loadHex(string path){
		loadHexImpl(path,&mem);
		return this;
	}

	virtual void postReset() {}
	virtual void checks(){}
	virtual void pass(){ throw success();}
	virtual void fail(){ throw std::exception();}
	void dump(int i){
		#ifdef TRACE
		tfp->dump(i);
		#endif
	}
	Workspace* run(uint32_t timeout = 5000){
//		cout << "Start " << name << endl;
		currentTime = 4;
		// init trace dump
		Verilated::traceEverOn(true);
		#ifdef TRACE
		tfp = new VerilatedVcdC;
		top->trace(tfp, 99);
		tfp->open((string(name)+ ".vcd").c_str());
		#endif

		// Reset
		top->clk = 0;
		top->reset = 0;
		top->iCmd_ready = 1;
		top->dCmd_ready = 1;
		top->eval(); currentTime = 3;
		top->reset = 1;
		top->eval();
		dump(0);
		top->reset = 0;
		top->eval(); currentTime = 2;
		top->clk = 1;

		postReset();

		try {
			// run simulation for 100 clock periods
			for (i = 16; i < timeout*2; i+=2) {
				currentTime = i;
				uint32_t iRsp_inst_next = top->iRsp_inst;
				uint32_t dRsp_inst_next = VL_RANDOM_I(32);


				if (top->iCmd_valid && top->iCmd_ready) {
					assertEq(top->iCmd_payload_pc & 3,0);
					//printf("%d\n",top->iCmd_payload_pc);

					iRsp_inst_next =  (mem[top->iCmd_payload_pc + 0] << 0)
									| (mem[top->iCmd_payload_pc + 1] << 8)
									| (mem[top->iCmd_payload_pc + 2] << 16)
									| (mem[top->iCmd_payload_pc + 3] << 24);
				}

				if (top->dCmd_valid && top->dCmd_ready) {
//					assertEq(top->iCmd_payload_pc & 3,0);
					//printf("%d\n",top->iCmd_payload_pc);

					uint32_t addr = top->dCmd_payload_address;
					if(top->dCmd_payload_wr){
						memTraces << (currentTime
						#ifdef REF
						-2
						 #endif
						 ) << " : WRITE mem" << (1 << top->dCmd_payload_size) << "[" << addr << "] = " << top->dCmd_payload_data << endl;
						for(uint32_t b = 0;b < (1 << top->dCmd_payload_size);b++){
							uint32_t offset = (addr+b)&0x3;
							*mem.get(addr + b) = top->dCmd_payload_data >> (offset*8);
						}

						switch(addr){
						case 0xF00FFF00u: {
							cout << mem[0xF00FFF00u];
							logTraces << (char)mem[0xF00FFF00u];
							break;
						}
						case 0xF00FFF20u: pass(); break;
						}
					}else{
						for(uint32_t b = 0;b < (1 << top->dCmd_payload_size);b++){
							uint32_t offset = (addr+b)&0x3;
							dRsp_inst_next &= ~(0xFF << (offset*8));
							dRsp_inst_next |= mem[addr + b] << (offset*8);
						}
						switch(addr){
						case 0xF00FFF10u:
							dRsp_inst_next = i/2;
							break;
						}
						memTraces << (currentTime
						#ifdef REF
						-2
						#endif
						) << " : READ  mem" << (1 << top->dCmd_payload_size) << "[" << addr << "] = " << dRsp_inst_next << endl;

					}
				}





				// dump variables into VCD file and toggle clock
				for (uint32_t clk = 0; clk < 2; clk++) {
					dump(i+ clk);
					top->clk = !top->clk;

					top->eval();
					if(top->clk == 0){
						if(iStall) top->iCmd_ready = VL_RANDOM_I(1);
						if(dStall) top->dCmd_ready = VL_RANDOM_I(1);
						if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
							regTraces << currentTime << " : reg[" << (uint32_t)top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address << "] = " << top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data << endl;
						}
						checks();
					}
				}
				cycles += 1;


				top->iRsp_inst = iRsp_inst_next;
				top->dRsp_data = dRsp_inst_next;

				if (Verilated::gotFinish())
					exit(0);
			}
			cout << "timeout" << endl;
			fail();
		} catch (const success e) {
			cout <<"SUCCESS " << name <<  endl;
			successCounter++;
		} catch (const std::exception& e) {
			cout << "FAIL " <<  name << endl;
		}



		dump(i);
		dump(i+1);
		#ifdef TRACE
		tfp->close();
		#endif
		return this;
	}
};
uint32_t Workspace::cycles = 0;

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
	}

	virtual void postReset() {
		top->VexRiscv->prefetch_PcManagerSimplePlugin_pcReg = 0x800000bcu;
	}

	virtual void checks(){
		if(top->VexRiscv->writeBack_arbitration_isValid == 1 && top->VexRiscv->writeBack_INSTRUCTION == 0x00000073){
			uint32_t code = top->VexRiscv->RegFilePlugin_regFile[28];
			if((code & 1) == 0){
				cout << "Wrong error code"<< endl;
				fail();
			}
			if(code == 1){
				pass();
			}else{
				cout << "Error code " << code/2 << endl;
				fail();
			}
		}
	}
};
#endif
class Dhrystone : public Workspace{
public:

	Dhrystone(string name,bool iStall, bool dStall) : Workspace(name) {
		setIStall(iStall);
		setDStall(dStall);
		loadHex("../../resources/hex/" + name + ".hex");
	}

	virtual void checks(){

	}

	virtual void pass(){
		FILE *refFile = fopen((name + ".logRef").c_str(), "r");
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


string riscvTestMain[] = {
	"rv32ui-p-simple",
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

#include <time.h>

struct timespec timer_start(){
    struct timespec start_time;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start_time);
    return start_time;
}

long timer_end(struct timespec start_time){
    struct timespec end_time;
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_time);
    uint64_t diffInNanos = end_time.tv_sec*1e9 + end_time.tv_nsec -  start_time.tv_sec*1e9 - start_time.tv_nsec;
    return diffInNanos;
}

#define redo(count,that) for(uint32_t xxx = 0;xxx < count;xxx++) that

int main(int argc, char **argv, char **env) {
	Verilated::randReset(2);
	Verilated::commandArgs(argc, argv);
	printf("BOOT\n");
	timespec startedAt = timer_start();

	for(int idx = 0;idx < 1;idx++){
		#ifndef  REF
		TestA().run();
		for(const string &name : riscvTestMain){
			redo(REDO,RiscvTest(name).run();)
		}
		for(const string &name : riscvTestMemory){
			redo(REDO,RiscvTest(name).run();)
		}
		for(const string &name : riscvTestMul){
			redo(REDO,RiscvTest(name).run();)
		}
		for(const string &name : riscvTestDiv){
			redo(REDO,RiscvTest(name).run();)
		}
		#endif
		#ifdef DHRYSTONE
		Dhrystone("dhrystoneO3",true,true).run(1e6);
		Dhrystone("dhrystoneO3M",true,true).run(0.8e6);
		Dhrystone("dhrystoneO3M",false,false).run(0.8e6);
//		Dhrystone("dhrystoneO3ML",false,false).run(8e6);
//		Dhrystone("dhrystoneO3MLL",false,false).run(80e6);
		#endif
		#ifdef CSR
		uint32_t machineCsrRef[] = {1,11,   2,0x80000003u,   3};
		TestX28("machineCsr",machineCsrRef, sizeof(machineCsrRef)/4).run(2e3);
		#endif

	}

	uint64_t duration = timer_end(startedAt);
	cout << endl << "****************************************************************" << endl;
	cout << "Had simulate " << Workspace::cycles << " clock cycles in " << duration*1e-9 << " s (" << Workspace::cycles / (duration*1e-9) << " Khz)" << endl;
	if(successCounter == testsCounter)
		cout << "SUCCESS " << successCounter << "/" << testsCounter << endl;
	else
		cout<< "FAILURE " << testsCounter - successCounter << "/"  << testsCounter << endl;
	cout << "****************************************************************" << endl << endl;


	exit(0);
}
