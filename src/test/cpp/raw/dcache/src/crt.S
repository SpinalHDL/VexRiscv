.globl _star
#define TEST_ID x28

_start:
    la x1, fail
    //csrw mtvec, x1

test1: //Dummy test
    li TEST_ID, 1
    li x1, 1
    li x2, 3
    addi x1, x1, 2
    bne x1, x2, fail

test2: //No invalidate, without load => new one
    li TEST_ID, 2
    li x1, 0xF5670000
    li x2, 0x900FF000
    li x6, 4096/4
test2_repeat:
    la x3, 1
    la x5, 2
    add x7, x6, x6
    add x3, x3, x7
    add x5, x5, x7
    sw x3, 0(x2)
    sw x0, 0(x1)
    lw x4, 0(x2)
    bne x5,x4, fail
    addi x6, x6, -4
    addi x1, x1, 16
    addi x2, x2, 16
.word 0x000500F // dcache flush
    bnez x6, test2_repeat

test3: //with invalidate, with preload
    li TEST_ID, 3
    li x1, 0xF5670000
    li x2, 0x900FF000
    li x6, 4096/4
test3_repeat:
    la x3, 2
    la x5, 3
    add x7, x6, x6
    add x3, x3, x7
    add x5, x5, x7
    lw x4, 0(x2)
    sw x3, 0(x2)
    sw x0, 0(x1)
.word 0x000500F // dcache flush
    lw x4, 0(x2)
    bne x5,x4, fail
    addi x6, x6, -4
    addi x1, x1, 16
    addi x2, x2, 16
    bnez x6, test3_repeat



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
