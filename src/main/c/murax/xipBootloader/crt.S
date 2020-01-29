#define CTRL_BASE 0xF001F000
#define XIP_BASE 0xE0040000
#define CTRL_DATA 0x00
#define CTRL_STATUS 0x04
#define CTRL_MODE 0x08
#define CTRL_RATE 0x20
#define CTRL_SS_SETUP 0x24
#define CTRL_SS_HOLD 0x28
#define CTRL_SS_DISABLE 0x2C

#define CTRL_XIP_CONFIG 0x40
#define CTRL_XIP_MODE 0x44

.global crtStart
.global main

#define CTRL x31

crtStart:
  li x31, CTRL_BASE
  sw x0, CTRL_MODE(CTRL)
  li t0, 2
  sw t0, CTRL_RATE(CTRL)
  li t0, 4
  sw t0, CTRL_SS_SETUP(CTRL)
  sw t0, CTRL_SS_HOLD(CTRL)
  sw t0, CTRL_SS_DISABLE(CTRL)


  li a0, 0x880
  call spiWrite
  li a0, 0x181
  call spiWrite
  li a0, 0x183
  call spiWrite
  li a0, 0x800
  call spiWrite


  li t0, 0x00FF010B
  sw t0, CTRL_XIP_MODE(CTRL)
  li t0, 0x1
  sw t0, CTRL_XIP_CONFIG(CTRL)
  li t0, XIP_BASE
  jr t0


spiWrite:
  sw    a0,CTRL_DATA(CTRL)
spiWrite_wait:
  lw	t0,CTRL_STATUS(CTRL)
  srli	t0,t0,0x10
  beqz	t0,spiWrite_wait
  ret
