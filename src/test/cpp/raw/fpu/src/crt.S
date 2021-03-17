.globl _star
#define TEST_ID x28

_start:

#define assert(reg, value) \
    li x20, value; \
    bne x20, reg, fail;


test1:
    li TEST_ID, 1
    nop
    nop
    nop
    nop
    fadd.s f2, f0, f1
    nop
    nop
    nop
    nop
    j test2

.align 6
test2:
    li TEST_ID, 2
    lw x1, test1_data
    fadd.s f2, f0, f1
    nop
    nop
    nop
    nop

    j test3


.align 6
test3:
    li TEST_ID, 3
    nop
    nop
    nop
    nop
    j skip
    fadd.s f2, f0, f1
skip:
    j test4



.align 6
test4:
    li TEST_ID, 4
    nop
    nop
    nop
    nop
    la x1, test1_data
    flw f2, 0(x1)
    nop
    nop
    nop
    nop

    j test5

.align 6
test5:
    li TEST_ID, 5
    nop
    nop
    nop
    nop
    la x1, test1_data
    la x2, test2_data
    flw f1, 0(x1)
    flw f2, 0(x2)
    fadd.s f3, f1, f2
    nop
    nop
    nop
    nop
    j test6

.align 6
test6:
    li TEST_ID, 6
    nop
    nop
    nop
    nop
    la x1, test3_data
    fsw f3, 0(x1)
    nop
    nop
    nop
    nop
    j test7

.align 6
test7:
    li TEST_ID, 7
    la x1, test3_data
    la x2, test4_data
    la x3, test5_data
    la x4, test6_data
    flw f4, 0(x1)
    fadd.s f4, f4, f4
    fadd.s f5, f1, f4
    fsw f4, 0(x2)
    fsw f5, 0(x3)
    fsw f1, 0(x4)
    nop
    nop
    nop
    nop
    j test8

.align 6
test8:
    li TEST_ID, 8
    fcvt.wu.s x1, f3
    nop
    nop
    nop
    nop
    j test9

.align 6
test9:
    li TEST_ID, 9
    fle.s x1, f2, f3
    fle.s x2, f3, f2
    fle.s x3, f3, f3
    nop
    nop
    nop
    nop
    j test10

.align 6
test10:
    li TEST_ID, 10
    li x1, 16
    fcvt.s.wu f1, x1
    li x2, 18
    li x3, 512
    fcvt.s.wu f2, x2
    fcvt.s.wu f3, x3
    lw x4, test10_data
    fcvt.s.wu f5, x4
    nop
    nop
    nop
    nop

  /*  la x1, test1_data
    li x2, 45
    amoswap.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 45)
    assert(x3, 11)*/




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


test1_data: .word 0x3fc00000 //1.5f
test2_data: .word 0x40a00000 //5.0f
test3_data: .word 73
test4_data: .word 58
test5_data: .word 56
test6_data: .word 75
.align 6
test10_data: .word 468
