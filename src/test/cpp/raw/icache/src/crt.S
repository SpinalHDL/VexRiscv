.globl _star
#define TEST_ID x28

_start:
    la x1, fail
  //  csrw mtvec, x1

test1: //Dummy test
    li TEST_ID, 1
    li x1, 1
    li x2, 3
    addi x1, x1, 2
    bne x1, x2, fail

test2:
    li TEST_ID, 2
    li x1, 0x13 //nop
    la x2, test2_trigger
    j test2_aligned
.align(4)
test2_aligned:
    sw x1, 0(x2)
    fence.i
    j test2_trigger
test2_trigger:
    j fail


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
