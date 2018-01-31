.globl _start
_start:

//Test 1
    li x28, 1
    csrr x1, 0xB04
    csrr x2, 0xB04
    csrr x3, 0xB04
    add x1, x1, 2
    add x2, x2, 1
    bne x1, x3, fail
    bne x2, x3, fail


//Test 2
    li x28, 2
    li x1, 6142346
    csrw 0xB04, x1
    csrr x2, 0xB04
    bne x1, x2, fail


//Test 3
    li x28, 3
    csrr x1, 0xB05
    csrr x2, 0xB05
    csrr x3, 0xB05
    bge x1, x2, fail
    bge x2, x3, fail

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
