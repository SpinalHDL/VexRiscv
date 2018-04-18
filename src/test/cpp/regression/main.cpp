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





class SimElement{
public:
	virtual ~SimElement(){}
	virtual void onReset(){}
	virtual void postReset(){}
	virtual void preCycle(){}
	virtual void postCycle(){}
};




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
	uint64_t i;
	double cyclesPerSecond = 10e6;
	double allowedCycles = 0.0;
	uint32_t bootPc = -1;
	uint32_t iStall = 1,dStall = 1;
	#ifdef TRACE
	VerilatedVcdC* tfp;
	#endif

	bool withInstructionReadCheck = true;
	void setIStall(bool enable) { iStall = enable; }
	void setDStall(bool enable) { dStall = enable; }

	ofstream regTraces;
	ofstream memTraces;
	ofstream logTraces;

	struct timespec start_time;


	Workspace(string name){
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
		return this;
	}

	Workspace* setCyclesPerSecond(double value){
		cyclesPerSecond = value;
		return this;
	}

    Workspace* bootAt(uint32_t pc) { bootPc = pc;}


	virtual void iBusAccess(uint32_t addr, uint32_t *data, bool *error) {
		if(addr % 4 != 0) {
			cout << "Warning, unaligned IBusAccess : " << addr << endl;
		//	fail();
		}
		*data =     (  (mem[addr + 0] << 0)
					 | (mem[addr + 1] << 8)
					 | (mem[addr + 2] << 16)
					 | (mem[addr + 3] << 24));
		*error = addr == 0xF00FFF60u;
	}
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
	}
	virtual void postReset() {}
	virtual void checks(){}
	virtual void pass(){ throw success();}
	virtual void fail(){ throw std::exception();}
    virtual void fillSimELements();
    Workspace* noInstructionReadCheck(){withInstructionReadCheck = false; return this;}
	void dump(int i){
		#ifdef TRACE
		if(i/2 >= TRACE_START) tfp->dump(i);
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

		resetDone = true;

		#ifdef  REF
		if(bootPc != -1) top->VexRiscv->core->prefetch_pc = bootPc;
		#else
		if(bootPc != -1) top->VexRiscv->prefetch_PcManagerSimplePlugin_pcReg = bootPc;
		#endif


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
				#ifdef CSR
				top->timerInterrupt = mTime >= mTimeCmp ? 1 : 0;
				//if(mTime == mTimeCmp) printf("SIM timer tick\n");
				#endif

				currentTime = i;




				// dump variables into VCD file and toggle clock

				dump(i);
				//top->eval();
				top->clk = 0;
				top->eval();


				dump(i + 1);



				if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
					regTraces <<
						#ifdef TRACE_WITH_TIME
						currentTime <<
						 #endif
						 " PC " << hex << setw(8) <<  top->VexRiscv->writeBack_PC << " : reg[" << dec << setw(2) << (uint32_t)top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address << "] = " << hex << setw(8) << top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data << endl;
				}

				for(SimElement* simElement : simElements) simElement->preCycle();

				if(withInstructionReadCheck){
					if(top->VexRiscv->decode_arbitration_isValid && !top->VexRiscv->decode_arbitration_haltItself && !top->VexRiscv->decode_arbitration_flushAll){
						uint32_t expectedData;
						bool dummy;
						iBusAccess(top->VexRiscv->decode_PC, &expectedData, &dummy);
						assertEq(top->VexRiscv->decode_INSTRUCTION,expectedData);
					}
				}

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
			cout << "FAIL " <<  name << endl;
			cycles += instanceCycles;
			staticMutex.unlock();
		}



		dump(i);
		dump(i+10);
		#ifdef TRACE
		tfp->close();
		#endif
		return this;
	}
};



#ifdef IBUS_SIMPLE
class IBusSimple : public SimElement{
public:
	uint32_t inst_next = VL_RANDOM_I(32);
	bool error_next = false;
	bool pending = false;

	Workspace *ws;
	VVexRiscv* top;
	IBusSimple(Workspace* ws){
		this->ws = ws;
		this->top = ws->top;
	}

	virtual void onReset(){
		top->iBus_cmd_ready = 1;
		top->iBus_rsp_ready = 1;
	}

	virtual void preCycle(){
		if (top->iBus_cmd_valid && top->iBus_cmd_ready && !pending) {
			//assertEq(top->iBus_cmd_payload_pc & 3,0);
			pending = true;
			ws->iBusAccess(top->iBus_cmd_payload_pc,&inst_next,&error_next);
		}
	}
	//TODO doesn't catch when instruction removed ?
	virtual void postCycle(){
		top->iBus_rsp_ready = !pending;
		if(pending && (!ws->iStall || VL_RANDOM_I(7) < 100)){
			top->iBus_rsp_inst = inst_next;
			pending = false;
			top->iBus_rsp_ready = 1;
			top->iBus_rsp_error = error_next;
		}
		if(ws->iStall) top->iBus_cmd_ready = VL_RANDOM_I(7) < 100 && !pending;
	}
};
#endif

#ifdef IBUS_SIMPLE_AVALON
#include <queue>
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


#ifdef IBUS_CACHED_WISHBONE
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
	    top->iBusWishbone_DAT_MISO = VL_RANDOM_I(32);
		if (top->iBusWishbone_CYC && top->iBusWishbone_STB && top->iBusWishbone_ACK) {
			assertEq(top->iBusWishbone_ADR & 3,0);
			if(top->iBusWishbone_WE){

			} else {
		        bool error;
			    ws->iBusAccess(top->iBusWishbone_ADR,&top->iBusWishbone_DAT_MISO,&error);
			    top->iBusWishbone_ERR = error;
			}
		}
	}

	virtual void postCycle(){
		if(ws->iStall)
			top->iBusWishbone_ACK = VL_RANDOM_I(7) < 100;
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

#ifdef DBUS_CACHED_WISHBONE
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
	    top->dBusWishbone_DAT_MISO = VL_RANDOM_I(32);
		if (top->dBusWishbone_CYC && top->dBusWishbone_STB && top->dBusWishbone_ACK) {
			assertEq(top->dBusWishbone_ADR & 3,0);
			if(top->dBusWishbone_WE){
			    bool dummy;
                ws->dBusAccess(top->dBusWishbone_ADR,1,2,top->dBusWishbone_SEL,&top->dBusWishbone_DAT_MOSI,&dummy);
			} else {
			    bool error;
			    ws->dBusAccess(top->dBusWishbone_ADR,0,2,0xF,&top->dBusWishbone_DAT_MISO,&error);
                top->dBusWishbone_ERR = error;
			}
		}
	}

	virtual void postCycle(){
		if(ws->iStall)
			top->dBusWishbone_ACK = VL_RANDOM_I(7) < 100;
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
	#ifdef IBUS_CACHED_WISHBONE
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
	#ifdef DBUS_CACHED_WISHBONE
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
		if(top->VexRiscv->writeBack_INSTRUCTION == 0x00000073){
			uint32_t instruction;
			bool error;
			iBusAccess(top->VexRiscv->writeBack_PC, &instruction, &error);
			if(instruction == 0x00000073){
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
	}

	virtual void iBusAccess(uint32_t addr, uint32_t *data, bool *error){
		Workspace::iBusAccess(addr,data,error);
		if(*data == 0x0ff0000f) *data = 0x00000013;
	}
};
#endif
class Dhrystone : public Workspace{
public:
	string hexName;
	Dhrystone(string name,string hexName,bool iStall, bool dStall) : Workspace(name) {
		setIStall(iStall);
		setDStall(dStall);
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
		if(recv(clientSocket, buffer, 4, 0) != 4){
			printf("Should read 4 bytes");
			fail();
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
			printf("wrong break PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (1 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 10){
			printf("wrong break PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (2 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 20){
			printf("wrong break PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (3 << 15)); //Read regfile
		if((readValue = readCmd(2,debugAddress + 4)) != 30){
			printf("wrong break PC %x\n",readValue);
			clientFail = true; return;
		}

		writeCmd(2, debugAddress + 4, 0x13 + (1 << 7) + (40 << 20)); //Write x1 with 40
		writeCmd(2, debugAddress + 4, 0x80000eb7); //Write x29 with 0x10
		writeCmd(2, debugAddress + 4, 0x010e8e93); //Write x29 with 0x10
		writeCmd(2, debugAddress + 4, 0x67 + (29 << 15)); //Branch x29
		writeCmd(2, debugAddress + 0, RISCV_SPINAL_FLAGS_HALT_CLEAR); //Run CPU

		while((readCmd(2,debugAddress) & RISCV_SPINAL_FLAGS_HALT) == 0){usleep(100);}
		if((readValue = readCmd(2,debugAddress + 4)) != 0x80000014){
			printf("wrong break PC 2 %x\n",readValue);
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
			printf("wrong break PC 2 %x\n",readValue);
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

string freeRtosTests[] = {
		"AltBlock", "AltQTest", "AltPollQ", "blocktim", "countsem", "dead", "EventGroupsDemo", "flop", "integer", "QPeek",
		"QueueSet", "recmutex", "semtest", "TaskNotify", "BlockQ", "crhook", "dynamic",
		"GenQTest", "PollQ", "QueueOverwrite", "QueueSetPolling", "sp_flop", "test1"
		 //"flop", "sp_flop" // <- Simple test
		 // "AltBlckQ" ???
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
	while(true){
		mutex->lock();
		if(lambdas->empty()){
			mutex->unlock();
			break;
		}
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
	Verilated::randReset(2);
	Verilated::commandArgs(argc, argv);

	printf("BOOT\n");
	timespec startedAt = timer_start();

	for(int idx = 0;idx < 1;idx++){

		#ifdef DEBUG_PLUGIN_EXTERNAL
		{
			Workspace w("debugPluginExternal");
			w.loadHex("../../resources/hex/debugPluginExternal.hex");
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

//			redo(REDO,TestA().run();)



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

			#ifdef CSR
				uint32_t machineCsrRef[] = {1,11,   2,0x80000003u,   3,0x80000007u,   4,0x8000000bu,   5,6,7,0x80000007u     ,
				8,6,9,6,10,4,11,4,    12,13,0,   14,2,     15,5,16,17,1 };
				redo(REDO,TestX28("machineCsr",machineCsrRef, sizeof(machineCsrRef)/4).noInstructionReadCheck()->run(10e4);)
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
			#if defined(MUL) && defined(DIV)
				Dhrystone("dhrystoneO3M_Stall","dhrystoneO3M",true,true).run(1.9e6);
			#endif
			Dhrystone("dhrystoneO3","dhrystoneO3",false,false).run(1.9e6);
			#if defined(MUL) && defined(DIV)
				Dhrystone("dhrystoneO3M","dhrystoneO3M",false,false).run(1.9e6);
			#endif
		#endif


		#ifdef FREERTOS
			//redo(1,Workspace("freeRTOS_demo").loadHex("../../resources/hex/freeRTOS_demo.hex")->bootAt(0x80000000u)->run(100e6);)
			queue<std::function<void()>> tasks;

			for(const string &name : freeRtosTests){
				tasks.push([=]() { Workspace(name + "_rv32i_O0").loadHex("../../resources/freertos/" + name + "_rv32i_O0.hex")->bootAt(0x80000000u)->run(4e6*15);});
				tasks.push([=]() { Workspace(name + "_rv32i_O3").loadHex("../../resources/freertos/" + name + "_rv32i_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
				#if defined(MUL) && defined(DIV)
				tasks.push([=]() { Workspace(name + "_rv32im_O0").loadHex("../../resources/freertos/" + name + "_rv32im_O0.hex")->bootAt(0x80000000u)->run(4e6*15);});
				tasks.push([=]() { Workspace(name + "_rv32im_O3").loadHex("../../resources/freertos/" + name + "_rv32im_O3.hex")->bootAt(0x80000000u)->run(4e6*15);});
				#endif
			}

			multiThreadedExecute(tasks);
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
