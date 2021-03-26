/*
 * Copyright (c) 2020 Samuel Lindemer <samuel.lindemer@ri.se>
 *
 * SPDX-License-Identifier: MIT
 */

#define TEST_ID    x28
#define TRAP_RA    x30

#define PMPCFG0    0x07120000
#define PMPCFG0_   0x07920808
#define PMPCFG1    0x191f0304
#define PMPCFG2    0x000f090a
#define PMPCFG3    0x0f1e1900

#define PMPADDR0   0x20000000 // OFF (test0) -> TOR (test1) -> OFF (test2)
#define PMPADDR1   0xffffffff // OFF (test0) -> TOR (test1) -> OFF (test2)
#define PMPADDR2   0x20002000 // NA4    W
#define PMPADDR3   0x20003fff // OFF   RWX -> 0x00000000 OFF RWX (test2)
#define PMPADDR4   0x20003fff // OFF     X
#define PMPADDR5   0x20003fff // OFF   RW
#define PMPADDR6   0x20001fff // NAPOT RWX
#define PMPADDR7   0x20005fff // NAPOT R
#define PMPADDR8   0x2000c000 // TOR    W
#define PMPADDR9   0x2000d000 // TOR   R
#define PMPADDR10  0xffffffff // TOR   RWX
#define PMPADDR11  0x00000000 // OFF
#define PMPADDR12  0x00000000 // OFF
#define PMPADDR13  0x00000000 // NAPOT R
#define PMPADDR14  0x00000000 // NAPOT  WX
#define PMPADDR15  0x00000000 // TOR   RWX

.global _start
_start:
    la x1, trap
    csrw mtvec, x1
    j test0

.global trap
trap:
    csrw mepc, TRAP_RA
    mret

// configure PMP, attempt read/write from machine mode
test0:
    li TEST_ID, 0
    la TRAP_RA, fail

    li x1, 0x80000000
    li x4, 0x80008000
    li x2, 0xdeadbeef
    sw x2, 0x0(x1)
    sw x2, 0x0(x4)
    lw x3, 0x0(x1)
    bne x2, x3, fail
    lw x3, 0x0(x4)
    bne x2, x3, fail

    li x5, PMPCFG0
    csrw pmpcfg0, x5
    csrr x6, pmpcfg0
    bne x5, x6, fail
    li x5, PMPCFG1
    csrw pmpcfg1, x5
    li x5, PMPCFG2
    csrw pmpcfg2, x5
    li x5, PMPCFG3
    csrw pmpcfg3, x5
    li x5, PMPADDR0
    csrw pmpaddr0, x5
    csrr x6, pmpaddr0
    bne x5, x6, fail
    li x5, PMPADDR1
    csrw pmpaddr1, x5
    li x5, PMPADDR2
    csrw pmpaddr2, x5
    li x5, PMPADDR3
    csrw pmpaddr3, x5
    li x5, PMPADDR4
    csrw pmpaddr4, x5
    li x5, PMPADDR5
    csrw pmpaddr5, x5
    li x5, PMPADDR6
    csrw pmpaddr6, x5
    li x5, PMPADDR7
    csrw pmpaddr7, x5
    li x5, PMPADDR8
    csrw pmpaddr8, x5
    li x5, PMPADDR9
    csrw pmpaddr9, x5
    li x5, PMPADDR10
    csrw pmpaddr10, x5
    li x5, PMPADDR11
    csrw pmpaddr11, x5
    li x5, PMPADDR12
    csrw pmpaddr12, x5
    li x5, PMPADDR13
    csrw pmpaddr13, x5
    li x5, PMPADDR14
    csrw pmpaddr14, x5
    li x5, PMPADDR15
    csrw pmpaddr15, x5

    li x2, 0xc0ffee
    sw x2, 0x0(x1)
    sw x2, 0x0(x4)
    lw x3, 0x0(x1)
    bne x2, x3, fail
    li x3, 0x0
    lw x3, 0x0(x4)
    bne x2, x3, fail

// lock region 2, attempt read/write from machine mode
test1:
    li TEST_ID, 1
    la TRAP_RA, fail 
    li x5, PMPCFG0_
    csrw pmpcfg0, x5            // lock region 2
    csrr x6, pmpcfg0
    bne x5, x6, fail
    li x1, 0x80008000
    li x2, 0xdeadbeef
    sw x2, 0x0(x1)              // should be OK (write 0x80008000)
    la TRAP_RA, test2
    lw x3, 0x0(x1)              // should fault (read 0x80008000)
    j fail

// "unlock" region 2, attempt read/write from machine mode
test2:
    li TEST_ID, 2
    la TRAP_RA, fail 
    li x5, PMPCFG0
    csrw pmpcfg0, x5            // "unlock" region 2
    csrr x6, pmpcfg0
    beq x5, x6, fail
    li x5, PMPADDR3
    csrwi pmpaddr3, 0x0
    csrr x6, pmpaddr3
    bnez x6, fail 
    beq x5, x6, fail
    li x5, PMPADDR2
    csrwi pmpaddr2, 0x0
    csrr x6, pmpaddr2
    beqz x6, fail 
    bne x5, x6, fail
    li x1, 0x80008000
    li x2, 0xdeadbeef
    sw x2, 0x0(x1)              // should still be OK (write 0x80008000)
    la TRAP_RA, test3
    lw x3, 0x0(x1)              // should still fault (read 0x80008000)
    j fail

// verify masked CSR read/write operations
test3:
    li TEST_ID, 3
    la TRAP_RA, fail
    li x5, 0x00ff0000
    csrs pmpaddr3, x5
    csrr x6, pmpaddr3
    bne x5, x6, fail
    li x5, 0x000000ff
    csrs pmpaddr3, x5
    csrr x6, pmpaddr3
    li x5, 0x00ff00ff
    bne x5, x6, fail
    li x5, 0x00ff0000
    csrc pmpaddr3, x5
    csrr x6, pmpaddr3
    li x5, 0x000000ff
    bne x5, x6, fail
    li x5, 0x00ff00ff
    csrc pmpcfg0, x5
    csrr x6, pmpcfg0
    li x5, 0x07920000
    bne x5, x6, fail
    li x5, 0x00ff0707
    csrs pmpcfg0, x5
    csrr x6, pmpcfg0
    li x5, 0x07920707
    bne x5, x6, fail

// jump into user mode
test4:
    li TEST_ID, 4
    la TRAP_RA, fail
    la x2, test5
    csrw mepc, x2
    mret

// attempt to read/write region 2 from user mode
test5:
    li TEST_ID, 5
    la TRAP_RA, fail 
    li x2, 0xdeadbeef
    li x1, 0x80008000
    sw x2, 0x0(x1)              // should be OK (write 0x80008000)
    la TRAP_RA, test6
    lw x3, 0x0(x1)              // should fault (read 0x80008000)
    j fail

// attempt to read/write other regions from user mode
test6:
    li TEST_ID, 6
    la TRAP_RA, fail
    li x2, 0xdeadbeef
    li x1, 0x80000000
    sw x2, 0x0(x1)
    lw x3, 0x0(x1)
    bne x2, x3, fail            // should be OK (read/write 0x80000000)

test7:
    li TEST_ID, 7
    la TRAP_RA, fail
    li x1, 0x80040000
    lw x3, 0x0(x1)              // should be OK (read 0x80040000)
    la TRAP_RA, pass
    sw x3, 0x0(x1)              // should fault (write 0x80040000)
    j fail
    
test8:
    li TEST_ID, 8
    la TRAP_RA, fail 
    li x2, 0xdeadbeef
    li x1, 0x8002fff8
    sw x2, 0x0(x4)              // should be OK (write 0x8002fff8)
    la TRAP_RA, test9
    lw x3, 0x0(x4)              // should fault (read 0x8002fff8)
    j fail

test9:
    li TEST_ID, 9
    la TRAP_RA, fail
    li x1, 0x8003fff8
    lw x3, 0x0(x1)              // should be OK (read 0x8003fff8)
    la TRAP_RA, pass
    sw x3, 0x0(x1)              // should fault (write 0x8003fff8)
    j fail
    
fail:
    li x2, 0xf00fff24
    sw TEST_ID, 0(x2)

pass:
    li x2, 0xf00fff20
    sw x0, 0(x2)
