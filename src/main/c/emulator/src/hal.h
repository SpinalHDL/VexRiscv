
#ifndef HAL_H
#define HAL_H

#include <stdint.h>

#define SBI_SET_TIMER 0
#define SBI_CONSOLE_PUTCHAR 1
#define SBI_CONSOLE_GETCHAR 2
#define SBI_CLEAR_IPI 3
#define SBI_SEND_IPI 4
#define SBI_REMOTE_FENCE_I 5
#define SBI_REMOTE_SFENCE_VMA 6
#define SBI_REMOTE_SFENCE_VMA_ASID 7
#define SBI_SHUTDOWN 8

void halInit();
void stopSim();
void putC(char c);
int32_t getC();
uint32_t rdtime();
uint32_t rdtimeh();
void setMachineTimerCmp(uint32_t low, uint32_t high);

#endif
