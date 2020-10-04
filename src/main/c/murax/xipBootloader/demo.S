#define GPIO_BASE 0xF0000000
#define GPIO_OUTPUT 4
#define GPIO_OUTPUT_ENABLE 8


.global crtStart

crtStart:

  li x31, 0x12340000 // magic word expected by bootloader
  
  li x31, GPIO_BASE
  li t0, 0x000000FF
  sw t0, GPIO_OUTPUT_ENABLE(x31)

  li t0,1
redo:
  sw t0, GPIO_OUTPUT(x31)
  li t1,10000
  slli t0,t0,1
  andi t0,t0,0xFF
  bnez t0, loop
  li t0,1
loop:
  addi t1,t1,-1
  bnez t1, loop
  j redo
