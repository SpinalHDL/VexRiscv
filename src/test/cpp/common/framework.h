
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
#include "verilated_fst_c.h"

using namespace std;

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



class success : public std::exception { };
static uint32_t workspaceCycles = 0;
template <class T> class Workspace{
public:

	vector<TimeProcess*> timeProcesses;
	vector<SensitiveProcess*> checkProcesses;
	T* top;
	bool resetDone = false;
	double timeToSec = 1e-12;
	double speedFactor = 1.0;
	uint64_t allowedTime = 0;
	string name;
	uint64_t time = 0;
	#ifdef TRACE
	VerilatedFstC* tfp;
	#endif

	ofstream logTraces;

	Workspace(string name){
		this->name = name;
		top = new T;
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

	virtual void dump(uint64_t i){
		#ifdef TRACE
		if(i >= TRACE_START) tfp->dump(i);
		#endif
	}

	Workspace* run(uint32_t timeout = 5000){

		// init trace dump
		#ifdef TRACE
		Verilated::traceEverOn(true);
		tfp = new VerilatedFstC;
		top->trace(tfp, 99);
		tfp->open((string(name)+ ".fst").c_str());
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


