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

_start:
//Test 1  SC on unreserved area should fail and not write memory
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

//Test 2 SC on another unreserved area should fail and not write memory
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


//Test 3 retrying SC on unreserved area should fail and not write memory
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


//Test 4  SC on reserved area should pass and should be written write memory
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


//Test 5  redo SC on reserved area should pass and should be written write memory
    li x28, 5
    li a0, 0x10000008
    li a1, 109
    li a2, 110
    li a3, 111
    sw a3, 0(a0)
    sc.w a2, a1, (a0)
    bne a2, x0, fail
    lw a4, 0(a0)
    bne a1, a4, fail

//Test 6  Allow two entries at the same time
    li x28, 6
    li a0, 0x1000000C
    li a1, 112
    li a2, 113
    li a3, 114
    li s0, 0x10000010
    li s1, 115
    li s2, 116
    li s3, 117

    sw a3, 0(a0)
    sw s3, 0(s0)
    lr.w a5, (a0)
    lr.w s5, (s0)
    sc.w a2, a1, (a0)
    sc.w s2, s1, (s0)
    bne a5, a3, fail
    bne a2, x0, fail
    lw a4, 0(a0)
    bne a1, a4, fail

    bne s5, s3, fail
    bne s2, x0, fail
    lw s4, 0(s0)
    bne s1, s4, fail

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
    li x28, 8
    li a0, 0x10000018
    li a1, 120
    li a2, 121
    li a3, 122
    lw a5, 0(a0)
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a5, a4, fail


//Test 9  SC should fail after a context switching
    li x28, 9
    li a0, 0x10000100
    li a1, 123
    li a2, 124
    li a3, 125
    sw a3, 0(a0)
    lr.w a5, (a0)
    scall
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a3, a4, fail



//Test 10  SC should fail if the address doesn't match
    li x28, 10
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
    bne a7, a4, fail



//Test 11  SC should fail after a external interrupt context switching
    li x28, 11
    li a0, 0x10000300
    li a1, 130
    li a2, 131
    li a3, 132
    sw a3, 0(a0)
    li x29, 0x800     //800  external interrupts
    csrw mie,x29
    li x29, 0x008     //008 enable interrupts
    lr.w a5, (a0)
    csrw mstatus,x29 //Enable external interrupt (will jump instantly due to testbench setup)
    nop
    nop
    nop
    nop
    nop
    nop
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
    lw a4, 0(a0)
    bne a3, a4, fail


//Test 12  SC should fail after a external interrupt context switching (callback on lr)
    li x28, 12
    li a0, 0x10000400
    li a1, 140
    li a2, 141
    li a3, 142
    sw a3, 0(a0)
    li x29, 0x800     //800  external interrupts
    csrw mie,x29
    li x29, 0x1808     //008 enable interrupts
    lr.w a5, (a0)
    csrw mstatus,x29 //Enable external interrupt (will jump instantly due to testbench setup)
    nop
    nop
    nop
    nop
    nop
    nop
    sc.w a2, a1, (a0)
    li a4, 1
    bne a2, a4, fail
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
