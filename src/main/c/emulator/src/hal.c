#include "hal.h"
#include "config.h"

#ifdef SIM
void stopSim(){
	*((volatile uint32_t*) 0xFFFFFFFC) = 0;
	while(1);
}

void putC(char c){
	*((volatile uint32_t*) 0xFFFFFFF8) = c;
}

int32_t getC(){
	return *((volatile int32_t*) 0xFFFFFFF8);
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


void halInit(){
//	putC('*');
//	putC('*');
//	putC('*');
//	while(1){
//		int32_t c = getC();
//		if(c > 0) putC(c);
//	}
}
#endif

#ifdef QEMU
#define VIRT_CLINT 0x2000000
#define SIFIVE_TIMECMP_BASE (VIRT_CLINT + 0x4000)
#define SIFIVE_TIME_BASE (VIRT_CLINT + 0xBFF8)
#define NS16550A_UART0_CTRL_ADDR 0x10000000
#define UART0_CLOCK_FREQ  32000000
#define UART0_BAUD_RATE  115200
enum {
    UART_RBR      = 0x00,  /* Receive Buffer Register */
    UART_THR      = 0x00,  /* Transmit Hold Register */
    UART_IER      = 0x01,  /* Interrupt Enable Register */
    UART_DLL      = 0x00,  /* Divisor LSB (LCR_DLAB) */
    UART_DLM      = 0x01,  /* Divisor MSB (LCR_DLAB) */
    UART_FCR      = 0x02,  /* FIFO Control Register */
    UART_LCR      = 0x03,  /* Line Control Register */
    UART_MCR      = 0x04,  /* Modem Control Register */
    UART_LSR      = 0x05,  /* Line Status Register */
    UART_MSR      = 0x06,  /* Modem Status Register */
    UART_SCR      = 0x07,  /* Scratch Register */

    UART_LCR_DLAB = 0x80,  /* Divisor Latch Bit */
    UART_LCR_8BIT = 0x03,  /* 8-bit */
    UART_LCR_PODD = 0x08,  /* Parity Odd */

    UART_LSR_DA   = 0x01,  /* Data Available */
    UART_LSR_OE   = 0x02,  /* Overrun Error */
    UART_LSR_PE   = 0x04,  /* Parity Error */
    UART_LSR_FE   = 0x08,  /* Framing Error */
    UART_LSR_BI   = 0x10,  /* Break indicator */
    UART_LSR_RE   = 0x20,  /* THR is empty */
    UART_LSR_RI   = 0x40,  /* THR is empty and line is idle */
    UART_LSR_EF   = 0x80,  /* Erroneous data in FIFO */
};

static volatile uint8_t *uart;

static void ns16550a_init()
{
	uart = (uint8_t *)(void *)(NS16550A_UART0_CTRL_ADDR);
	uint32_t uart_freq = (UART0_CLOCK_FREQ);
	uint32_t baud_rate = (UART0_BAUD_RATE);
    uint32_t divisor = uart_freq / (16 * baud_rate);
    uart[UART_LCR] = UART_LCR_DLAB;
    uart[UART_DLL] = divisor & 0xff;
    uart[UART_DLM] = (divisor >> 8) & 0xff;
    uart[UART_LCR] = UART_LCR_PODD | UART_LCR_8BIT;
}

//static int ns16550a_getchar()
//{
//    if (uart[UART_LSR] & UART_LSR_DA) {
//        return uart[UART_RBR];
//    } else {
//        return -1;
//    }
//}
//
//static int ns16550a_putchar(int ch)
//{
//    while ((uart[UART_LSR] & UART_LSR_RI) == 0);
//    return uart[UART_THR] = ch & 0xff;
//}

void stopSim(){
	while(1);
}

void putC(char ch){
    while ((uart[UART_LSR] & UART_LSR_RI) == 0);
    uart[UART_THR] = ch & 0xff;
}

int32_t getC(){
	if (uart[UART_LSR] & UART_LSR_DA) {
		return uart[UART_RBR];
	} else {
		return -1;
	}
}


uint32_t rdtime(){
	return *((volatile uint32_t*) SIFIVE_TIME_BASE);
}

uint32_t rdtimeh(){
	return *((volatile uint32_t*) (SIFIVE_TIME_BASE + 4));
}

void setMachineTimerCmp(uint32_t low, uint32_t high){
	volatile uint32_t* base = (volatile uint32_t*) SIFIVE_TIMECMP_BASE;
	base[1] = 0xffffffff;
	base[0] = low;
	base[1] = high;
}

void halInit(){
	ns16550a_init();
}
#endif




