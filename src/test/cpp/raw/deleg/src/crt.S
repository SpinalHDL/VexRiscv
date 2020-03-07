.globl _start

#define TEST_ID x28
#define TRAP_OK x29
#define TRAP_RET x30

#include "encoding.h"

#define externalInterrupt(value) \
    li x1, 0xF0011000; \
    li x2, value; \
    sw x2, 0(x1); \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \


#define externalInterruptS(value) \
    li x1, 0xF0012000; \
    li x2, value; \
    sw x2, 0(x1); \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \
    nop; \



#define delay() \
    li x1, 100; \
1: \
    addi x1, x1, -1; \
    bgt x1, x0, 1b; \


#define setPriv(value) \
    li x1, 3 << 11; \
    li x2, value << 11; \
    csrc mstatus, x1; \
    csrs mstatus, x2; \
    auipc x1, 0;  \
    addi x1, x1, 20;  \
    csrw mepc, x1;  \
    mret; \
    j fail; \


ROM_SUPER_0:

_start:
    li TRAP_OK, 1
    la x1, mtrap
    csrw mtvec, x1
    la x1, strap
    csrw stvec, x1
    externalInterrupt(0);

test1:
    li TEST_ID, 1
    la TRAP_RET, test2
    ecall

test2: //simple ecall from user to machine
    li TEST_ID, 2
    setPriv(0)
    la TRAP_RET, test4
    ecall
    j fail

test3: //M mialigned load exception without deleg
    li TEST_ID, 3
    la TRAP_RET, test4
    lw x1, 1(x0)
    j fail
test4: //S mialigned load exception without deleg
    li TEST_ID, 4
    setPriv(1)
    la TRAP_RET, test5
    lw x1, 1(x0)
    j fail
test5: //U mialigned load exception without deleg
    li TEST_ID, 5
    setPriv(0)
    la TRAP_RET, test6
    lw x1, 1(x0)
    j fail

test6: // set medeleg
    li TEST_ID, 6
    li x1, 1 << CAUSE_MISALIGNED_LOAD
    csrw medeleg, x1

test7: //machine mode exception
    li TEST_ID, 7
    la TRAP_RET, test8
    lw x1, 1(x0)
    j fail

test8: //supervisor mode exception
    li TEST_ID, 8
    la TRAP_RET, test9
    setPriv(1)
    lw x1, 1(x0)
    j fail

test9: //user mode exception
    li TEST_ID, 9
    la TRAP_RET, test10
    setPriv(0)
    lw x1, 1(x0)
    j fail

test10: //M external interrupt
    li TEST_ID, 10
    la TRAP_RET, test11
    externalInterrupt(0)
    li x1, MSTATUS_MIE
    csrw mstatus, x1
    li x1, 1 << 11
    csrw mie, x1
    externalInterrupt(1)
    wfi
    j fail

test11: //S external interrupt
    li TEST_ID, 11
    la TRAP_RET, test12
    externalInterrupt(0)
    li x1, MSTATUS_MIE
    csrw mstatus, x1
    li x1, 1 << 11
    csrw mie, x1
    setPriv(1)
    externalInterrupt(1)
    wfi
    j fail

test12: //U external interrupt
    li TEST_ID, 12
    la TRAP_RET, test14
    externalInterrupt(0)
    li x1, MSTATUS_MIE
    csrw mstatus, x1
    li x1, 1 << 11
    csrw mie, x1
    setPriv(0)
    externalInterrupt(1)
    wfi
    j fail



test14: //M external interrupt S
    li x1, MSTATUS_SIE
    csrw sstatus, x1

    li TEST_ID, 14
    la TRAP_RET, test15
    externalInterruptS(0)
    li x1, MSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    li TRAP_OK, 0
    externalInterruptS(1)
    delay()

test15: //S external interrupt S
    li TEST_ID, 15
    la TRAP_RET, test16
    externalInterruptS(0)
    li x1, SSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    setPriv(1)
    li TRAP_OK, 1
    externalInterruptS(1)
    wfi
    j fail

test16: //U external interrupt S
    li TEST_ID, 16
    la TRAP_RET, test17
    externalInterruptS(0)
    li x1, SSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    setPriv(0)
    externalInterruptS(1)
    wfi
    j fail


test17:// set mideleg
    li TEST_ID, 17
    li x1, 1 << 9
    csrw mideleg, x1


    la TRAP_RET, test18
    externalInterruptS(0)
    li x1, MSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    li TRAP_OK, 0
    externalInterruptS(1)
    delay()

test18: //S external interrupt S with deleg
    li TEST_ID, 18
    la TRAP_RET, test19
    externalInterruptS(0)
    li x1, SSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    setPriv(1)
    li TRAP_OK, 1
    externalInterruptS(1)
    wfi
    j fail

test19: //U external interrupt S with deleg
    li TEST_ID, 19
    la TRAP_RET, test20
    externalInterruptS(0)
    li x1, SSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    setPriv(0)
    externalInterruptS(1)
    wfi
    j fail





test20:// M external interrupt S by software with deleg
    externalInterruptS(0)
    li TEST_ID, 20
    la TRAP_RET, test21
    li x1, MSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    li TRAP_OK, 0
    li x1, 1 << 9
    csrs sip, x1
    delay()

test21: //S external interrupt S by software with deleg
    li TEST_ID, 21
    la TRAP_RET, test22
    li x1, 1 << 9
    csrc sip, x1
    li x1, SSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    setPriv(1)
    li TRAP_OK, 1
    li x1, 1 << 9
    csrs sip, x1
    wfi
    j fail

test22: //U external interrupt S by software with deleg
    li TEST_ID, 22
    la TRAP_RET, test23
    li x1, 1 << 9
    csrc sip, x1
    li x1, SSTATUS_SIE
    csrw mstatus, x1
    li x1, 1 << 9
    csrw mie, x1
    li x1, 1 << 9
    csrs sip, x1
    setPriv(0)
    wfi
    j fail



test23: //Test software and hardware setting inettrupt
    li TEST_ID, 23
    li TRAP_OK, 0
    externalInterruptS(0)
    li x1, 1 << 9
    csrc sip, x1
    csrr x3, mip


    externalInterruptS(1)
    li x1, 1 << 9
    csrc sip, x1
    csrr x3, mip


    externalInterruptS(0)
    li x1, 1 << 9
    csrc sip, x1
    csrr x3, mip


    externalInterruptS(0)
    li x1, 1 << 9
    csrs sip, x1
    csrr x3, mip


    externalInterruptS(1)
    li x1, 1 << 9
    csrs sip, x1
    csrr x3, mip

    externalInterruptS(0)

test24: //test supervisor software interrupt
    li TEST_ID, 24
    li x1, 2
    csrs mie, x1
    csrs mip, x1
    csrs mstatus, x1

    li TRAP_OK, 1
    la TRAP_RET, test25
    setPriv(1)
test24_s:
    wfi
    j fail


test25: //test undelegated supervisor interrupt in machine mode (continue test24)
    li TEST_ID, 25
    la TRAP_RET, test26
    csrsi mstatus, 1 << 3 //mie
    wfi
    j fail


test26:

    j pass

fail:
    li x2, 0xF00FFF24
    sw TEST_ID, 0(x2)

pass:
    li x2, 0xF00FFF20
    sw x0, 0(x2)


mtrap:
    beq TRAP_OK, x0, fail
    csrr x1, mcause
    csrr x1, mepc
    csrr x1, mstatus
    csrr x1, mbadaddr
    li x1, MSTATUS_MPIE
    csrc mstatus, x1
    li x1, 2
    beq TRAP_OK, x1, pass
    li x1, 3 << 11
    csrs mstatus, x1
    csrw mepc, TRAP_RET
    mret


strap:
    beq TRAP_OK, x0, fail
    csrr x1, scause
    csrr x1, sepc
    csrr x1, sstatus
    csrr x1, sbadaddr
    ecall



    nop
    nop
    nop
    nop
    nop
    nop
