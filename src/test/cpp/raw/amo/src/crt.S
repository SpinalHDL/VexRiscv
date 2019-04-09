.globl _star
#define TEST_ID x28

_start:

#define assert(reg, value) \
    li x20, value; \
    bne x20, reg, fail;

test1:
    li TEST_ID, 1
    la x1, test1_data
    li x2, 45
    amoswap.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 45)
    assert(x3, 11)

test2:
    li TEST_ID, 2
    la x1, test2_data
    li x2, 55
    amoswap.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 55)
    assert(x3, 22)


test3:
    li TEST_ID,3
    la x1, test3_data
    li x2, 66
    amoadd.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 66+73)
    assert(x3, 73)

test4:
    li TEST_ID,4
    la x1, test4_data
    li x2, 87
    amoxor.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 87^58)
    assert(x3, 58)

test5:
    li TEST_ID,5
    la x1, test5_data
    li x2, 44
    amoand.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 44 & 56)
    assert(x3, 56)

test6:
    li TEST_ID,6
    la x1, test6_data
    li x2, 24
    amoor.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 24 | 75)
    assert(x3, 75)

test7:
    li TEST_ID,7
    la x1, test7_data
    li x2, 24
    amomin.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 24)
    assert(x3, 56)


test8:
    li TEST_ID,8
    la x1, test8_data
    li x2, 88
    amomin.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 83)
    assert(x3, 83)

test9:
    li TEST_ID,9
    la x1, test9_data
    li x2, -54
    amomin.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, -54)
    assert(x3, 33)

test10:
    li TEST_ID,10
    la x1, test10_data
    li x2, 52
    amomin.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, -65)
    assert(x3, -65)

test11:
    li TEST_ID,11
    la x1, test11_data
    li x2, -52
    amomax.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, -52)
    assert(x3, -87)

test12:
    li TEST_ID,12
    la x1, test12_data
    li x2, 52
    amomax.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 52)
    assert(x3, -55)


test13:
    li TEST_ID,13
    la x1, test13_data
    li x2, 0xFFFF0000
    amominu.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 0xFFFF0000)
    assert(x3, 0xFFFF0004)

    j pass


test14:
    li TEST_ID,14
    la x1, test14_data
    li x2, 0xFFFF000C
    amomaxu.w x3,x2,(x1)
    lw x4, 0(x1)
    assert(x4, 0xFFFF000C)
    assert(x3, 0xFFFF0005)

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


test1_data: .word 11
test2_data: .word 22
test3_data: .word 73
test4_data: .word 58
test5_data: .word 56
test6_data: .word 75
test7_data: .word 56
test8_data: .word 83
test9_data: .word 33
test10_data: .word -65
test11_data: .word -87
test12_data: .word -55
test13_data: .word 0xFFFF0004
test14_data: .word 0xFFFF0005