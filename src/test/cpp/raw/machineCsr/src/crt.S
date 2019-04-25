  j _start

#define writeSoftwareInterrupt(value) \
    li x24, 0xF0013000; \
    li x25, value; \
    sw x25, 0(x24); \

.align 5
.global  trap_entry
trap_entry:
  csrr x28, mcause

  bnez x28, notICmdAlignementException
  li   x30, 0xFFFFFFFC
  csrr x29, mepc
  and  x29,x29,x30
  addi x29, x29, 4
  csrw mepc, x29
  j mepcFixed

notICmdAlignementException:
  li   x29, 0x80000000
  and  x30, x28, x29
  bnez x30, mepcFixed
  csrr x29, mepc
  addi x29, x29, 4
  csrw mepc, x29
mepcFixed:


  li   x29, 0x80000003u
  bne  x29, x28, noSoftwareInterrupt
  writeSoftwareInterrupt(0)

noSoftwareInterrupt:

  li   x29, 0x80000007u
  bne  x29, x28, noTimerInterrupt
  csrw mie, 0
noTimerInterrupt:

  li   x29, 0x8000000bu
  bne  x29, x28, noExernalInterrupt
  csrw mie, 0
noExernalInterrupt:

  mret


  .text
  .globl _start
_start:
  li x28, 1
  ecall

  li x28, 2
  li t0, 0x008
  csrs mstatus,t0
  li t0, 0x008
  csrw mie,t0
  writeSoftwareInterrupt(1)
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop


  li x28, 3
  li t0, 0x080
  csrw mie,t0
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  li x28, 4
  li t0, 0x800
  csrw mie,t0
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  li x28, 5
  li x3, 0xF00FFF40
  lw x4, 0(x3)
  lw x5, 4(x3)
  addi x4, x4, 1023
  sw x4, 8(x3)
  sw x5, 12(x3)
  li x28, 6
  li x4, 0x080
  csrw mie,x4
  li x28, 7
  wfi


  li x28, 8
  li x3, 1
  sw x4,0(x3)
  li x28, 9
  sh x4,0(x3)
  li x28, 10
  lw x4,0(x3)
  li x28, 11
  lh x4,0(x3)
  li x28, 12



  li x28, 13
  lw x1,0(x0)
#ifndef COMPRESSED
unalignedPcA:
  j unalignedPcA+2
#endif
  lw x1,0(x0)

  li x28, 14
  hret
  li x28, 15


  li x1, 0xF00FFF60
  lw x2, 0(x1)
  li x28, 16
  sw x2, 0(x1)
  li x28, 17
  jr  x1
