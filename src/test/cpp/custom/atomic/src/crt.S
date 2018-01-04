.globl _start
_start:


//Test 1  SC on unreserved area should fail and not write memory
    li x28, 1
    li a0, 0x10000000
    li a1, 100
    li a2, 101
    li a3, 102
    sw a3, 0(a0)
    sc.w a2, a1, (a0)
    beq a2, x0, fail
    lw a4, 0(a0)
    bne a3, a4, fail

//Test 2  retrying SC on unreserved area should fail and not write memory
    li x28, 2
    li a0, 0x10000000
    li a1, 100
    li a2, 101
    li a3, 102
    sw a3, 0(a0)
    sc.w a2, a1, (a0)
    beq a2, x0, fail
    lw a4, 0(a0)
    bne a3, a4, fail



    j pass



fail: //x28 => error code
    li x2, 0xF00FFF24
    sw x28, 0(x2)

pass:
    li x2, 0xF00FFF20
    sw x0, 0(x2)



    nop
    nop
    nop
    nop
    nop
    nop
