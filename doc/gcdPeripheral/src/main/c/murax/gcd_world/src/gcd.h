#ifndef GCD_H_
#define GCD_H_

typedef struct
{
  volatile uint32_t A;
  volatile uint32_t B;
  volatile uint32_t RES;
  volatile uint32_t READY;
  volatile uint32_t VALID;
} Gcd_Reg;

#endif /* GCD_H_ */
