#ifndef INTERRUPTCTRL_H_
#define INTERRUPTCTRL_H_

#include <stdint.h>

typedef struct
{
  volatile uint32_t PENDINGS;
  volatile uint32_t MASKS;
} InterruptCtrl_Reg;

static void interruptCtrl_init(InterruptCtrl_Reg* reg){
	reg->MASKS = 0;
	reg->PENDINGS = 0xFFFFFFFF;
}

#endif /* INTERRUPTCTRL_H_ */
