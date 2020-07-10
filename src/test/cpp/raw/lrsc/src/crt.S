.globl _start


  j _start
  nop
  nop
  nop
  nop
  nop
  nop
  nop

.global  trap_entry
trap_entry:
    csrr x29, mstatus
    and x29, x29, 0x080
    beqz x29, notExternalInterrupt
    li x29, 0x1800     //000 disable interrupts
    csrw mstatus,x29
    mret

notExternalInterrupt:
    csrr x29, mepc
    addi x29, x29, 4
    csrw mepc, x29
    mret

flush:
    li t0, 0x20000000
    li t1,     0x1000
    li t2,         32
flushLoop:
    lw t3, 0(t0)
    add t0, t0, t1
    addi t2,t2,-1
    bnez  t2, flushLoop
    ret

_start:
test1: //Test 1  SC on unreserved area should fail and not write memory
    li x28, 1
    li a0, 0x10000000
    li a1, 100
    li a2, 101
    li a3, 102
    sw a3, 0(a0)
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a3, a4, fail

test2: //Test 2 SC on another unreserved area should fail and not write memory
    li x28, 2
    li a0, 0x10000004
    li a1, 103
    li a2, 104
    li a3, 105
    sw a3, 0(a0)
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a3, a4, fail
    call flush
    lw a4, 0(a0)
    bne a3, a4, fail


test3: //Test 3 retrying SC on unreserved area should fail and not write memory
    li x28, 3
    li a0, 0x10000004
    li a1, 103
    li a2, 104
    li a3, 105
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a3, a4, fail
    call flush
    lw a4, 0(a0)
    bne a3, a4, fail


test4: //Test 4  SC on reserved area should pass and should be written write memory
    li x28, 4
    li a0, 0x10000008
    li a1, 106
    li a2, 107
    li a3, 108
    sw a3, 0(a0)
    lr.w a5, (a0)
    sc.w a2, a1, (a0)
    bne a5, a3, fail
    bne a2, x0, fail
    lw a4, 0(a0)
    bne a1, a4, fail
    call flush
    lw a4, 0(a0)
    bne a1, a4, fail


test5: //Test 5  redo SC on reserved area should fail
    li x28, 5
    li a0, 0x10000008
    li a1, 109
    li a2, 110
    li a3, 111
    sw a3, 0(a0)
    sc.w a2, a1, (a0)
    beq a2, x0, fail
    lw a4, 0(a0)
    bne a3, a4, fail
    call flush
    lw a4, 0(a0)
    bne a3, a4, fail


//Test 7  do a lot of allocation to clear the entries
    li x28, 7
    li a0, 0x10000014
    li a1, 120
    li a2, 121
    li a3, 122
    li x29, 16
test7:
    sw a3, 0(a0)
    lr.w a5, (a0)
    sc.w a2, a1, (a0)
    bne a5, a3, fail
    bne a2, x0, fail
    lw a4, 0(a0)
    bne a1, a4, fail
    add x29, x29, -1
    add a0, a0, 4
    add a1, a1, 3
    add a2, a2, 3
    add a3, a3, 3
    bnez x29, test7


//Test 8  SC on discarded entries should fail
 /*   li x28, 8
    li a0, 0x10000018
    li a1, 120
    li a2, 121
    li a3, 122
    lw a5, 0(a0)
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a5, a4, fail*/


test9: //Test 9  SC should pass after a context switching
    li x28, 9
    li a0, 0x10000100
    li a1, 123
    li a2, 124
    li a3, 125
    sw a3, 0(a0)
    lr.w a5, (a0)
    scall
    sc.w a5, a1, (a0)
    li a4, 0
    bne a5, a4, fail
    lw a4, 0(a0)
    bne a1, a4, fail
    call flush
    lw a4, 0(a0)
    bne a1, a4, fail



//Test 10  SC should fail if the address doesn't match
 /*   li x28, 10
    li a0, 0x10000200
    li a6, 0x10000204
    li a1, 126
    li a2, 127
    li a3, 128
    li a7, 129
    sw a3, 0(a0)
    sw a7, 0(a6)
    lr.w a5, (a6)
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a6)
    bne a7, a4, fail*/


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
