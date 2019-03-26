#include "hal.h"

void stopSim(){
	*((volatile uint32_t*) 0xFFFFFFFC) = 0;
}

void putC(char c){
	*((volatile uint32_t*) 0xFFFFFFF8) = c;
}

uint32_t rdtime(){
	return *((volatile uint32_t*) 0xFFFFFFE0);
}

uint32_t rdtimeh(){
	return *((volatile uint32_t*) 0xFFFFFFE4);
}


void setMachineTimerCmp(uint32_t low, uint32_t high){
	volatile uint32_t* base = (volatile uint32_t*) 0xFFFFFFE8;
	base[1] = 0xffffffff;
	base[0] = low;
	base[1] = high;
}
