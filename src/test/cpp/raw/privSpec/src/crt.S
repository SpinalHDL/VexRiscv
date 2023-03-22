.globl _star
#define TEST_ID x28

_start:
    la x1, fail
    csrw mtvec, x1

test1:
    li TEST_ID, 1
    csrw misa, x0

    //Test xtvec mode
    li x1, 1
    csrw mtvec, x1
    csrr x2, mtvec
    bnez x2, fail
    csrw stvec, x1
    csrr x2, stvec
    bnez x2, fail

    li x1, 9
    csrw mcause, x1
    csrr x2, mcause
    bne x2, x1, fail

    csrr x0, pmpcfg0
    csrw pmpcfg0, x0

    csrr x0, pmpcfg3
    csrw pmpcfg3, x0

    csrr x0, pmpaddr0
    csrw pmpaddr0, x0

    csrr x0, pmpaddr15
    csrw pmpaddr15, x0


    j pass

fail:
    li x2, 0xF00FFF24
    sw TEST_ID, 0(x2)

pass:
    li x2, 0xF00FFF20
    sw x0, 0(x2)

    nop
    nop
    nop
    nop
    nop
    nop
