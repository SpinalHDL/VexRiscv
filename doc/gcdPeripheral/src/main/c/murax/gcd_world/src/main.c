//#include "stddefs.h"
#include <stdint.h>

#include "murax.h"

#include "main.h"

#define DEBUG 0

uint32_t gcd(uint32_t a, uint32_t b){
	GCD->A = a;
	GCD->B = b;
	GCD->VALID = 0x00000001;
	uint32_t rdyFlag = 0;
	do{
		rdyFlag = GCD->READY;
	}while(!rdyFlag);
	return GCD->RES;
}

void calcPrintGCD(uint32_t a, uint32_t b){
	uint32_t myGCD = 0;
	char buf[5] = { 0x00 };
	char aBuf[11] = { 0x00 };
	char bBuf[11] = { 0x00 }; 
	itoa(a, aBuf, 10);
	itoa(b, bBuf, 10);
	print("gcd(");print(aBuf);print(",");print(bBuf);println("):");
	myGCD = gcd(a,b);
	itoa(myGCD, buf, 10);
	println(buf);
}

void main() {
    GPIO_A->OUTPUT_ENABLE = 0x0000000F;
	GPIO_A->OUTPUT = 0x00000001;
    println("hello gcd world");
    const int nleds = 4;
	const int nloops = 2000000;

	GCD->VALID = 0x00000000;
	while(GCD->READY);

	calcPrintGCD(1, 123913);
	calcPrintGCD(461952, 116298);
	calcPrintGCD(461952, 116298);
	calcPrintGCD(461952, 116298);

	while(1){
    	for(unsigned int i=0;i<nleds-1;i++){
    		GPIO_A->OUTPUT = 1<<i;
    		delay(nloops);
    	}
    	for(unsigned int i=0;i<nleds-1;i++){
			GPIO_A->OUTPUT = (1<<(nleds-1))>>i;
			delay(nloops);
		}
    }
}

void irqCallback(){
}
