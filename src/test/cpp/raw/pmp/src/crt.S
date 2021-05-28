/*
 * Copyright (c) 2020 Samuel Lindemer <samuel.lindemer@ri.se>
 *
 * SPDX-License-Identifier: MIT
 */

#define TEST_ID     x28
#define TRAP_RETURN x30
#define TRAP_EXIT   x9

#define PMPCFG0    0x071a0000
#define PMPCFG0_   0x079a0808
#define PMPCFG1    0x1a190304
#define PMPCFG2    0x000f090a
#define PMPCFG3    0x1c1e1900

#define PMPADDR0   0x20000000 // OFF (test0) -> TOR (test1) -> OFF (test2)
#define PMPADDR1   0xffffffff // OFF (test0) -> TOR (test1) -> OFF (test2)
#define PMPADDR2   0x20200000 // NAPOT  W
#define PMPADDR3   0x20003fff // OFF   RWX -> 0x00000000 OFF RWX (test2)
#define PMPADDR4   0x20003fff // OFF     X
#define PMPADDR5   0x20003fff // OFF   RW
#define PMPADDR6   0x22ffffff // NAPOT R
#define PMPADDR7   0x2203ffff // NAPOT  W
#define PMPADDR8   0x200d0000 // TOR    W
#define PMPADDR9   0x200e0000 // TOR   R
#define PMPADDR10  0xffffffff // TOR   RWX
#define PMPADDR11  0x00000000 // OFF
#define PMPADDR12  0x00000000 // OFF
#define PMPADDR13  0x00000000 // NAPOT R
#define PMPADDR14  0x00000000 // NAPOT  WX
#define PMPADDR15  0xffffffff // NAPOT   X

.global _start
_start:
    li TRAP_EXIT, 0x0
    la x1, trap
    csrw mtvec, x1
    j test0

.global trap
trap:
    csrw mepc, TRAP_RETURN
    bnez TRAP_EXIT, trap_exit
    mret

// return from trap, but stay in M-mode
trap_exit:
    jr TRAP_RETURN

// configure PMP, attempt read/write from machine mode
test0:
    li TEST_ID, 0
    la TRAP_RETURN, fail

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
    csrr x6, pmpcfg2
    bne x5, x6, fail
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
    la TRAP_RETURN, fail 
    li x5, PMPCFG0_
    csrw pmpcfg0, x5            // lock region 2
    csrr x6, pmpcfg0
    bne x5, x6, fail
    li x1, 0x80800000
    li x2, 0xdeadbeef
    sw x2, 0x0(x1)              // should be OK (write region 2)
    la TRAP_RETURN, test2
    lw x3, 0x0(x1)              // should fault (read region 2)
    j fail

// "unlock" region 2, attempt read/write from machine mode
test2:
    li TEST_ID, 2
    la TRAP_RETURN, fail 
    li x5, PMPCFG0
    csrw pmpcfg0, x5            // "unlock" region 2
    csrr x6, pmpcfg0
    beq x5, x6, fail
    csrwi pmpaddr3, 0x0
    csrr x6, pmpaddr3
    bnez x6, fail
    csrwi pmpaddr2, 0x0
    csrr x6, pmpaddr2
    beqz x6, fail
    li x1, 0x80800000
    li x2, 0xdeadbeef
    sw x2, 0x0(x1)              // should still be OK (write region 2)
    la TRAP_RETURN, test3
    lw x3, 0x0(x1)              // should still fault (read region 2)
    j fail

// verify masked CSR read/write operations
test3:
    li TEST_ID, 3
    la TRAP_RETURN, fail
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
    li x5, 0x079a0000
    bne x5, x6, fail
    li x5, 0x00ff0707
    csrs pmpcfg0, x5
    csrr x6, pmpcfg0
    li x5, 0x079a0707
    bne x5, x6, fail

// jump into U-mode
test4:
    li TEST_ID, 4
    la TRAP_RETURN, fail
    la x2, test5
    csrw mepc, x2
    mret

// attempt to read/write the locked region from U-mode
test5:
    li TEST_ID, 5
    la TRAP_RETURN, fail 
    li x2, 0xdeadbeef
    li x1, 0x80800000
    sw x2, 0x0(x1)              // should be OK (write region 2)
    la TRAP_RETURN, test6
    lw x3, 0x0(x1)              // should fault (read region 2)
    j fail

// attempt to read/write overlapping regions from U-mode
test6:
    li TEST_ID, 6
    la TRAP_RETURN, fail 
    li x2, 0xdeadbeef
    li x1, 0x88000000
    sw x2, 0x0(x1)              // should be OK (write region 6/7)
    lw x3, 0x0(x1)              // should be OK (write region 6/7)

test7:
    li TEST_ID, 7
    la TRAP_RETURN, fail
    li x1, 0x88fffff0
    lw x3, 0x0(x1)              // should be OK (read region 6)
    la TRAP_RETURN, test8a
    sw x3, 0x0(x1)              // should fault (write region 6)
    j fail

// attempt to write a pmpcfg# register from U-mode
test8a:
    li TEST_ID, 8
    la TRAP_RETURN, test8b
    li TRAP_EXIT, 0x1
    csrwi pmpcfg3, 0x0
    j fail

// check the result from M-mode
test8b:
    li TEST_ID, 8
    li x5, PMPCFG3
    csrr x6, pmpcfg3
    bne x5, x6, fail

// jump back into U-mode
test9a:
    li TEST_ID, 9
    la TRAP_RETURN, fail
    li TRAP_EXIT, 0x0
    la x2, test9b
    csrw mepc, x2
    mret

// attempt to write a pmpaddr# register from U-mode
test9b:
    li TEST_ID, 9
    la TRAP_RETURN, test9c
    li TRAP_EXIT, 0x1
    csrwi pmpaddr10, 0x0
    j fail

// check the result from M-mode
test9c:
    li TEST_ID, 9
    li x5, PMPADDR10
    csrr x6, pmpaddr10
    beq x5, x6, pass

fail:
    li x2, 0xf00fff24
    sw TEST_ID, 0(x2)

pass:
    li x2, 0xf00fff20
    sw x0, 0(x2)