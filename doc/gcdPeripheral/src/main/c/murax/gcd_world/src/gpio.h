#ifndef GPIO_H_
#define GPIO_H_


typedef struct
{
  volatile uint32_t INPUT;
  volatile uint32_t OUTPUT;
  volatile uint32_t OUTPUT_ENABLE;
} Gpio_Reg;


#endif /* GPIO_H_ */


