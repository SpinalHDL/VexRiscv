#include "VBriey.h"
#include "VBriey_Briey.h"
#ifdef REF
#include "VBriey_RiscvCore.h"
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
#include <iomanip>
#include <time.h>
#include <unistd.h>

#include "VBriey_VexRiscv.h"


class SimElement{
public:
	virtual ~SimElement(){}
	virtual void onReset(){}
	virtual void postReset(){}
	virtual void preCycle(){}
	virtual void postCycle(){}
};

//#include <functional>
class TimeProcess{
public:
	uint64_t wakeDelay = 0;
	bool wakeEnable = false;
//	std::function<int(double)> lambda;
	virtual ~TimeProcess(){}
	virtual void schedule(uint64_t delay){
		wakeDelay = delay;
		wakeEnable = true;
	}
	virtual void tick(){
//		lambda = [this](double x) { return x+1 + this->wakeDelay; };
//		lambda(1.0);
	}
};


class SensitiveProcess{
public:

	virtual ~SensitiveProcess(){}
	virtual void tick(uint64_t time){

	}
};

class ClockDomain : public TimeProcess{
public:
	CData* clk;
	CData* reset;
	uint64_t tooglePeriod;
	vector<SimElement*> simElements;
	ClockDomain(CData *clk, CData *reset, uint64_t period, uint64_t delay){
		this->clk = clk;
		this->reset = reset;
		*clk = 0;
		this->tooglePeriod = period/2;
		schedule(delay);
	}


	bool postCycle = false;
	virtual void tick(){
		if(*clk == 0){
			for(SimElement* simElement : simElements){
				simElement->preCycle();
			}
			postCycle = true;
			*clk = 1;
			schedule(0);
		}else{
			if(postCycle){
				postCycle = false;
				for(SimElement* simElement : simElements){
					simElement->postCycle();
				}
			}else{
				*clk = 0;
			}
			schedule(tooglePeriod);
		}

	}

	void add(SimElement *that){
		simElements.push_back(that);
	}

};

class AsyncReset : public TimeProcess{
public:
	CData* reset;
	uint32_t state;
	uint64_t duration;
	AsyncReset(CData *reset, uint64_t duration){
		this->reset = reset;
		*reset = 0;
		state = 0;
		this->duration = duration;
		schedule(0);
	}

	virtual void tick(){
		switch(state){
		case 0:
			*reset = 1;
			state = 1;
			schedule(duration);
			break;
		case 1:
			*reset = 0;
			state = 2;
			break;
		}
	}

};

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

class Jtag : public TimeProcess{
public:
	CData *tms, *tdi, *tdo, *tck;
	enum State {reset};
	uint32_t state;

	int serverSocket, clientHandle;
	struct sockaddr_in serverAddr;
	struct sockaddr_storage serverStorage;
	socklen_t addr_size;
	uint64_t tooglePeriod;
//	char buffer[1024];

	Jtag(CData *tms, CData *tdi, CData *tdo, CData* tck,uint64_t period){
		this->tms = tms;
		this->tdi = tdi;
		this->tdo = tdo;
		this->tck = tck;
		this->tooglePeriod = period/2;
		*tms = 0;
		*tdi = 0;
		*tdo = 0;
		*tck = 0;
		state = 0;
		schedule(0);

		//---- Create the socket. The three arguments are: ----//
		// 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) //
		serverSocket = socket(PF_INET, SOCK_STREAM, 0);
		assert(serverSocket != -1);
		int flag = 1;
		setsockopt(  serverSocket,            /* socket affected */
					 IPPROTO_TCP,     /* set option at TCP level */
					 TCP_NODELAY,     /* name of option */
					 (char *) &flag,  /* the cast is historical
											 cruft */
					 sizeof(int));    /* length of option value */

		/*int a = 0xFFF;
		if (setsockopt(serverSocket, SOL_SOCKET, SO_RCVBUF, &a, sizeof(int)) == -1) {
		    fprintf(stderr, "Error setting socket opts: %s\n", strerror(errno));
		}
		a = 0xFFFFFF;
		if (setsockopt(serverSocket, SOL_SOCKET, SO_SNDBUF, &a, sizeof(int)) == -1) {
		    fprintf(stderr, "Error setting socket opts: %s\n", strerror(errno));
		}*/

		SetSocketBlockingEnabled(serverSocket,0);


		//---- Configure settings of the server address struct ----//
		// Address family = Internet //
		serverAddr.sin_family = AF_INET;
		serverAddr.sin_port = htons(7894);
		serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
		memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);

		//---- Bind the address struct to the socket ----//
		bind(serverSocket, (struct sockaddr *) &serverAddr, sizeof(serverAddr));

		//---- Listen on the socket, with 5 max connection requests queued ----//
		listen(serverSocket,1);

		//---- Accept call creates a new socket for the incoming connection ----//
		addr_size = sizeof serverStorage;
		clientHandle = -1;

	}
	void connectionReset(){
		printf("CONNECTION RESET\n");
		shutdown(clientHandle,SHUT_RDWR);
		clientHandle = -1;
	}


	virtual ~Jtag(){
		if(clientHandle != -1) {
			shutdown(clientHandle,SHUT_RDWR);
			usleep(100);
		}
		if(serverSocket != -1) {
			close(serverSocket);
			usleep(100);
		}
	}

	uint32_t selfSleep = 0;
	uint32_t checkNewConnectionsTimer = 0;
	uint8_t rxBuffer[100];
	int32_t rxBufferSize = 0;
	int32_t rxBufferRemaining = 0;
	virtual void tick(){
		checkNewConnectionsTimer++;
		if(checkNewConnectionsTimer == 5000){
			checkNewConnectionsTimer = 0;
			int newclientHandle = accept(serverSocket, (struct sockaddr *) &serverStorage, &addr_size);
			if(newclientHandle != -1){
				if(clientHandle != -1){
					connectionReset();
				}
				clientHandle = newclientHandle;
				printf("CONNECTED\n");
			}
			else{
				if(clientHandle == -1)
					selfSleep = 1000;
			}
		}
		if(selfSleep)
			selfSleep--;
		else{
			if(clientHandle != -1){
				uint8_t buffer;
				int n;

				if(rxBufferRemaining == 0){
					if(ioctl(clientHandle,FIONREAD,&n) != 0)
						connectionReset();
					else if(n >= 1){
						rxBufferSize = read(clientHandle,&rxBuffer,100);
						if(rxBufferSize < 0){
							connectionReset();
						}else {
							rxBufferRemaining = rxBufferSize;
						}
					}else {
						selfSleep = 30;
					}
				}

				if(rxBufferRemaining != 0){
					uint8_t buffer = rxBuffer[rxBufferSize - (rxBufferRemaining--)];
					*tms = (buffer & 1) != 0;
					*tdi = (buffer & 2) != 0;
					*tck = (buffer & 8) != 0;
					if(buffer & 4){
						buffer = (*tdo != 0);
						//printf("TDO=%d\n",buffer);
						if(-1 == send(clientHandle,&buffer,1,0))
							connectionReset();
					}else {

					//	printf("\n");
					}
				}
			}
		}
		schedule(tooglePeriod);
	}

};


class success : public std::exception { };

class Workspace{
public:
	static uint32_t cycles;
	vector<TimeProcess*> timeProcesses;
	vector<SensitiveProcess*> checkProcesses;
	VBriey* top;
	bool resetDone = false;
	double timeToSec = 1e-12;
	double speedFactor = 1.0;
	uint64_t allowedTime = 0;
	string name;
	uint64_t time = 0;
	#ifdef TRACE
	VerilatedVcdC* tfp;
	#endif

	ofstream logTraces;

	Workspace(string name){
		this->name = name;
		top = new VBriey;
		logTraces.open (name + ".logTrace");
	}

	virtual ~Workspace(){
		delete top;
		#ifdef TRACE
		delete tfp;
		#endif

		for(auto* p : timeProcesses) delete p;
		for(auto* p : checkProcesses) delete p;

	}

	Workspace* setSpeedFactor(double value){
		speedFactor = value;
		return this;
	}


	virtual void postReset() {}
	virtual void checks(){}
	virtual void pass(){ throw success();}
	virtual void fail(){ throw std::exception();}
    virtual void fillSimELements();

	void dump(uint64_t i){
		#ifdef TRACE
		if(i >= TRACE_START) tfp->dump(i);
		#endif
	}

	Workspace* run(uint32_t timeout = 5000){

		fillSimELements();
		// init trace dump
		#ifdef TRACE
		Verilated::traceEverOn(true);
		tfp = new VerilatedVcdC;
		top->trace(tfp, 99);
		tfp->open((string(name)+ ".vcd").c_str());
		#endif

		struct timespec start_time,tick_time;
		uint64_t tickLastSimTime = 0;
		top->eval();

		clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start_time);
		clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &tick_time);

		uint32_t flushCounter = 0;
		try {
			while(1){
				uint64_t delay = ~0l;
				for(TimeProcess* p : timeProcesses)
					if(p->wakeEnable && p->wakeDelay < delay)
						delay = p->wakeDelay;

				if(delay == ~0l){
					fail();
				}
				if(delay != 0){
					dump(time);
				}
				for(TimeProcess* p : timeProcesses) {
					p->wakeDelay -= delay;
					if(p->wakeDelay == 0){
						p->wakeEnable = false;
						p->tick();
					}
				}

				top->eval();
				for(auto* p : checkProcesses) p->tick(time);

				if(delay != 0){
					if(time - tickLastSimTime > 1000*400000 || time - tickLastSimTime > 1.0*speedFactor/timeToSec){
						struct timespec end_time;
						clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_time);
						uint64_t diffInNanos = end_time.tv_sec*1e9 + end_time.tv_nsec -  tick_time.tv_sec*1e9 - tick_time.tv_nsec;
						tick_time = end_time;
						double dt = diffInNanos*1e-9;
						#ifdef PRINT_PERF
							printf("Simulation speed : %f ms/realTime\n",(time - tickLastSimTime)/dt*timeToSec*1e3);
						#endif
						tickLastSimTime = time;
					}
					time += delay;
					while(allowedTime < delay){
						struct timespec end_time;
						clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end_time);
						uint64_t diffInNanos = end_time.tv_sec*1e9 + end_time.tv_nsec -  start_time.tv_sec*1e9 - start_time.tv_nsec;
						start_time = end_time;
						double dt = diffInNanos*1e-9;
						allowedTime += dt*speedFactor/timeToSec;
						if(allowedTime > 0.01*speedFactor/timeToSec)
							allowedTime = 0.01*speedFactor/timeToSec;

					}
					allowedTime-=delay;

					flushCounter++;
					if(flushCounter > 100000){
						#ifdef TRACE
						tfp->flush();
						//printf("flush\n");
						#endif
						flushCounter = 0;
					}
				}


				if (Verilated::gotFinish())
					exit(0);
			}
			cout << "timeout" << endl;
			fail();
		} catch (const success e) {
			cout <<"SUCCESS " << name <<  endl;
		} catch (const std::exception& e) {
			cout << "FAIL " <<  name << endl;
		}



		dump(time);
		dump(time+10);
		#ifdef TRACE
		tfp->close();
		#endif
		return this;
	}
};




void Workspace::fillSimELements(){

}


uint32_t Workspace::cycles = 0;
/*class SimElement{
public:
	virtual ~SimElement(){}
	virtual void onReset(){}
	virtual void postReset(){}
	virtual void preCycle(){}
	virtual void postCycle(){}
};*/

class SdramConfig{
public:
	uint32_t byteCount;
	uint32_t bankCount;
	uint32_t rowSize;
	uint32_t colSize;

	SdramConfig(uint32_t byteCount,
			uint32_t bankCount,
			uint32_t rowSize,
			uint32_t colSize){
		this->byteCount = byteCount;
		this->bankCount = bankCount;
		this->rowSize = rowSize;
		this->colSize = colSize;
	}
};

class SdramIo{
public:
	CData *BA;
	CData *DQM;
	CData *CASn;
	CData *CKE;
	CData *CSn;
	CData *RASn;
	CData *WEn;
	SData *ADDR;
	CData *DQ_read;
	CData *DQ_write;
	CData *DQ_writeEnable;
};

class Sdram : public SimElement{
public:

	SdramConfig *config;
	SdramIo *io;

	uint32_t CAS;
	uint32_t burstLength;

	class Bank{
	public:
		uint8_t *data;
		SdramConfig *config;

		bool opened;
		uint32_t openedRow;
		void init(SdramConfig *config){
			this->config = config;
			data = new uint8_t[config->rowSize * config->colSize * config->byteCount];
			opened = false;
		}

		virtual ~Bank(){
			delete data;
		}

		void activate(uint32_t row){
			if(opened)
				cout << "SDRAM error open unclosed bank" << endl;
			openedRow = row;
			opened = true;
		}

		void precharge(){
			opened = false;
		}

		void write(uint32_t column, CData byteId, CData data){
			if(!opened)
				cout << "SDRAM : write in closed bank" << endl;
			uint32_t addr = byteId + (column + openedRow * config->colSize) * config->byteCount;
			//printf("SDRAM : Write A=%08x D=%02x\n",addr,data);
			this->data[addr] = data;

		}

		CData read(uint32_t column, CData byteId){
			if(!opened)
				cout << "SDRAM : write in closed bank" << endl;
			uint32_t addr = byteId + (column + openedRow * config->colSize) * config->byteCount;
			//printf("SDRAM : Read A=%08x D=%02x\n",addr,data[addr]);
			return data[addr];
		}
	};

	Bank* banks;

	CData * readShifter;

	Sdram(SdramConfig *config,SdramIo* io){
		this->config = config;
		this->io = io;
		banks = new Bank[config->bankCount];
		for(uint32_t bankId = 0;bankId < config->bankCount;bankId++) banks[bankId].init(config);
		readShifter = new CData[config->byteCount*3];
	}

	virtual ~Sdram(){
		delete banks;
		delete readShifter;
	}


	uint8_t ckeLast = 0;


	virtual void postCycle(){
		if(CAS >= 2 && CAS <=3){
			for(uint32_t byteId = 0;byteId != config->byteCount;byteId++){
				io->DQ_read[byteId] = readShifter[byteId + (CAS-1)*config->byteCount];
			}
			for(uint32_t latency = CAS-1;latency != 0;latency--){  //missing CKE
				for(uint32_t byteId = 0;byteId != config->byteCount;byteId++){
					readShifter[byteId+latency*config->byteCount] = readShifter[byteId+(latency-1)*config->byteCount];
				}
			}
		}
	}

	virtual void preCycle(){
		if(!*io->CSn && ckeLast){
			uint32_t code = ((*io->RASn) << 2) | ((*io->CASn) << 1) | ((*io->WEn) << 0);
			switch(code){
			case 0: //Mode register set
				if(*io->BA == 0 && (*io->ADDR & 0x400) == 0){
					CAS = ((*io->ADDR) >> 4) & 0x7;
					burstLength = ((*io->ADDR) >> 0) & 0x7;
					if((*io->ADDR & 0x388) != 0)
						cout << "SDRAM : ???" << endl;
					printf("SDRAM : MODE REGISTER DEFINITION CAS=%d burstLength=%d\n",CAS,burstLength);
				}
				break;
			case 2: //Bank precharge
				if((*io->ADDR & 0x400) != 0){ //all
					for(uint32_t bankId = 0;bankId < config->bankCount;bankId++)
						banks[bankId].precharge();
				} else { //single
					banks[*io->BA].precharge();
				}
				break;
			case 3: //Bank activate
				banks[*io->BA].activate(*io->ADDR & 0x7FF);
				break;
			case 4: //Write
				if((*io->ADDR & 0x400) != 0)
					cout << "SDRAM : Write autoprecharge not supported" << endl;

				if(*io->DQ_writeEnable == 0)
					cout << "SDRAM : Write Wrong DQ direction" << endl;

				for(uint32_t byteId = 0;byteId < config->byteCount;byteId++){
					if(((*io->DQM >> byteId) & 1) == 0)
						banks[*io->BA].write(*io->ADDR, byteId ,io->DQ_write[byteId]);
				}
				break;

			case 5: //Read
				if((*io->ADDR & 0x400) != 0)
					cout << "SDRAM : READ autoprecharge not supported" << endl;

				if(*io->DQ_writeEnable != 0)
					cout << "SDRAM : READ Wrong DQ direction" << endl;

				//if(*io->DQM !=  config->byteCount-1)
					//cout << "SDRAM : READ wrong DQM" << endl;

				for(uint32_t byteId = 0;byteId < config->byteCount;byteId++){
					readShifter[byteId] = banks[*io->BA].read(*io->ADDR, byteId);
				}
				break;
			case 1: // Self refresh
				break;
			case 7: // NOP
				break;
			default:
				cout << "SDRAM : unknown code" << endl;
				break;
			}
		}
		ckeLast = *io->CKE;
	}
};

class UartRx : public SensitiveProcess{
public:

	CData *rx;
	uint32_t uartTimeRate;
	UartRx(CData *rx, uint32_t uartTimeRate){
		this->rx = rx;
		this->uartTimeRate = uartTimeRate;
	}

	enum State {START, DATA, STOP,START_SUCCESS};
	State state = START;
	uint64_t holdTime = 0;
	CData holdValue;
	char data;
	uint32_t counter;
	virtual void tick(uint64_t time){
		if(time < holdTime){
			if(*rx != holdValue){
				cout << "UART RX FRAME ERROR" << endl;
				holdTime = time;
				state = START;
			}
		}else{
			switch(state){
			case START:
			case START_SUCCESS:
				if(state == START_SUCCESS){
					cout << data << flush;
					state = START;
				}
				if(*rx == 0 && time > uartTimeRate){
					holdTime = time + uartTimeRate;
					holdValue = *rx;
					state = DATA;
					counter = 0;
					data = 0;
				}
				break;
			case DATA:
				data |= (*rx) << counter++;
				if(counter == 8){
					state = STOP;
				}
				holdValue = *rx;
				holdTime = time + uartTimeRate;
				break;
			case STOP:
				holdTime = time + uartTimeRate;
				holdValue = 1;
				state = START_SUCCESS;
				break;
			}
		}
	}
};

class VexRiscvTracer : public SimElement{
public:
	VBriey_VexRiscv *cpu;
	ofstream instructionTraces;
	ofstream regTraces;

	VexRiscvTracer(VBriey_VexRiscv *cpu){
		this->cpu = cpu;
#ifdef TRACE_INSTRUCTION
	instructionTraces.open ("instructionTrace.log");
#endif
#ifdef TRACE_REG
	regTraces.open ("regTraces.log");
#endif
	}



	virtual void preCycle(){
#ifdef TRACE_INSTRUCTION
		if(cpu->writeBack_arbitration_isFiring){
			instructionTraces <<  hex << setw(8) <<  cpu->writeBack_INSTRUCTION << endl;
		}
#endif
#ifdef TRACE_REG
		if(cpu->writeBack_RegFilePlugin_regFileWrite_valid == 1 && cpu->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
			regTraces << " PC " << hex << setw(8) <<  cpu->writeBack_PC << " : reg[" << dec << setw(2) << (uint32_t)cpu->writeBack_RegFilePlugin_regFileWrite_payload_address << "] = " << hex << setw(8) << cpu->writeBack_RegFilePlugin_regFileWrite_payload_data << endl;
		}

#endif
	}
};

class BrieyWorkspace : public Workspace{
public:
	BrieyWorkspace() : Workspace("Briey"){
		ClockDomain *axiClk = new ClockDomain(&top->io_axiClk,NULL,20000,100000);
		ClockDomain *vgaClk = new ClockDomain(&top->io_vgaClk,NULL,40000,100000);
		AsyncReset *asyncReset = new AsyncReset(&top->io_asyncReset,50000);
		Jtag *jtag = new Jtag(&top->io_jtag_tms,&top->io_jtag_tdi,&top->io_jtag_tdo,&top->io_jtag_tck,80000);
		UartRx *uartRx = new UartRx(&top->io_uart_txd,(50000000/8/115200)*8*axiClk->tooglePeriod*2);
		timeProcesses.push_back(axiClk);
		timeProcesses.push_back(vgaClk);
		timeProcesses.push_back(asyncReset);
		timeProcesses.push_back(jtag);
		checkProcesses.push_back(uartRx);

		SdramConfig *sdramConfig = new SdramConfig(
			2,  //byteCount
			4,  //bankCount
			1 << 13, //rowSize
			1 << 10  //colSize
		);
		SdramIo *sdramIo = new SdramIo();
		sdramIo->BA              = &top->io_sdram_BA             ;
		sdramIo->DQM             = &top->io_sdram_DQM            ;
		sdramIo->CASn            = &top->io_sdram_CASn           ;
		sdramIo->CKE             = &top->io_sdram_CKE            ;
		sdramIo->CSn             = &top->io_sdram_CSn            ;
		sdramIo->RASn            = &top->io_sdram_RASn           ;
		sdramIo->WEn             = &top->io_sdram_WEn            ;
		sdramIo->ADDR            = &top->io_sdram_ADDR           ;
		sdramIo->DQ_read         = (CData*)&top->io_sdram_DQ_read        ;
		sdramIo->DQ_write        = (CData*)&top->io_sdram_DQ_write       ;
		sdramIo->DQ_writeEnable = &top->io_sdram_DQ_writeEnable;
		Sdram *sdram = new Sdram(sdramConfig, sdramIo);

		axiClk->add(sdram);
		#ifdef TRACE
		//speedFactor = 100e-6;
		//cout << "Simulation caped to " << timeToSec << " of real time"<< endl;
		#endif

		axiClk->add(new VexRiscvTracer(top->Briey->axi_core_cpu));
	}


};


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




/*
#include <boost/coroutine2/all.hpp>
#include <functional>
#include <iostream>

using boost::coroutines2::coroutine;

void cooperative(coroutine<int>::push_type &sink, int i)
{
  int j = i;
  sink(++j);
  sink(++j);
  std::cout << "end\n";
}

int main2()
{
  using std::placeholders::_1;
  coroutine<int>::pull_type source{std::bind(cooperative, _1, 0)};
  std::cout << source.get() << '\n';
  source();
  std::cout << source.get() << '\n';
  source();
}*/

int main(int argc, char **argv, char **env) {

	Verilated::randReset(2);
	Verilated::commandArgs(argc, argv);

	printf("BOOT\n");
	timespec startedAt = timer_start();

	BrieyWorkspace().run(100e6);

	uint64_t duration = timer_end(startedAt);
	cout << endl << "****************************************************************" << endl;
	cout << "Had simulate " << Workspace::cycles << " clock cycles in " << duration*1e-9 << " s (" << Workspace::cycles / (duration*1e-9) << " Khz)" << endl;
	/*if(successCounter == testsCounter)
		cout << "SUCCESS " << successCounter << "/" << testsCounter << endl;
	else
		cout<< "FAILURE " << testsCounter - successCounter << "/"  << testsCounter << endl;*/
	cout << "****************************************************************" << endl << endl;


	exit(0);
}
