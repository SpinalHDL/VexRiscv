.globl _start
_start:

//Test 1
    li x28, 1
    csrr x1, 0xB04
    csrr x2, 0xB04
    csrr x3, 0xB04
    blt x2, x1, fail
    blt x3, x2, fail


//Test 2
    li x28, 2
    li x1, 6142346
    csrw 0xB04, x1
    csrr x2, 0xB04
    blt x2, x1, fail


//Test 3
    li x28, 3
    csrr x1, 0xB05
    csrr x2, 0xB05
    csrr x3, 0xB05
    bge x1, x2, fail
    bge x2, x3, fail



//Test 4
    li x28, 4
    csrw 0xB06, x1
    csrr x1, 0xB04
    li x2, 0x100
    bgeu x1, x2, fail

//Test 5
    li x28, 5
    csrr x1, 0xB07
    csrr x1, 0xB04
    li x2, 0x40000100
    li x3, 0x40000000
    bgeu x1, x2, fail
    bltu x1, x3, fail

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
