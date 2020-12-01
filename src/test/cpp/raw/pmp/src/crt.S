/*
 * Copyright (c) 2020 Samuel Lindemer <samuel.lindemer@ri.se>
 *
 * SPDX-License-Identifier: MIT
 */

#define TEST_ID    x28
#define TRAP_RA    x30

#define PMPCFG0    0x071a0808
#define PMPCFG0_   0x079a0808 // lock region 2
#define PMPCFG1    0x191c0504
#define PMPCFG2    0x00000018
#define PMPCFG3    0x0f1e1900

#define PMPADDR0   0x20000000 // TOR
#define PMPADDR1   0xffffffff // TOR
#define PMPADDR2   0x20002000 // NA4    W
#define PMPADDR3   0x20003fff // OFF   RWX
#define PMPADDR4   0x20003fff // OFF     X
#define PMPADDR5   0x20003fff // OFF   RW
#define PMPADDR6   0x20001fff // NAPOT RWX
#define PMPADDR7   0x20003fff // NAPOT R
#define PMPADDR8   0x20003fff // NAPOT
#define PMPADDR9   0x00000000 // OFF
#define PMPADDR10  0x00000000 // OFF
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

.global to_user
to_user:
    li t1, 0x14000
    csrc mstatus, t1
    li t1, 0x200
    csrs mstatus, t1
    csrw mepc, ra
    mret

// configure PMP, attempt read/write from machine mode
test0:
    li TEST_ID, 0
    la TRAP_RA, fail

    li t0, 0x80000000
    li t3, 0x80008000
    li t1, 0xdeadbeef
    sw t1, 0x0(t0)
    sw t1, 0x0(t3)
    lw t2, 0x0(t0)
    bne t1, t2, fail
    lw t2, 0x0(t3)
    bne t1, t2, fail

    li t5, PMPCFG0
    csrw pmpcfg0, t5
    li t5, PMPCFG1
    csrw pmpcfg1, t5
    li t5, PMPCFG2
    csrw pmpcfg2, t5
    li t5, PMPCFG3
    csrw pmpcfg3, t5
    li t5, PMPADDR0
    csrw pmpaddr0, t5
    li t5, PMPADDR1
    csrw pmpaddr1, t5
    li t5, PMPADDR2
    csrw pmpaddr2, t5
    li t5, PMPADDR3
    csrw pmpaddr3, t5
    li t5, PMPADDR4
    csrw pmpaddr4, t5
    li t5, PMPADDR5
    csrw pmpaddr5, t5
    li t5, PMPADDR6
    csrw pmpaddr6, t5
    li t5, PMPADDR7
    csrw pmpaddr7, t5
    li t5, PMPADDR8
    csrw pmpaddr8, t5
    li t5, PMPADDR9
    csrw pmpaddr9, t5
    li t5, PMPADDR10
    csrw pmpaddr10, t5
    li t5, PMPADDR11
    csrw pmpaddr11, t5
    li t5, PMPADDR12
    csrw pmpaddr12, t5
    li t5, PMPADDR13
    csrw pmpaddr13, t5
    li t5, PMPADDR14
    csrw pmpaddr14, t5
    li t5, PMPADDR15
    csrw pmpaddr15, t5

    li t1, 0x00c0ffee
    sw t1, 0x0(t0)
    sw t1, 0x0(t3)
    lw t2, 0x0(t0)
    bne t1, t2, fail
    lw t2, 0x0(t3)
    bne t1, t2, fail

// lock region 2, attempt read/write from machine mode
test1:
    li TEST_ID, 1
    la TRAP_RA, fail 
    li t5, PMPCFG0_
    csrw pmpcfg0, t5            // lock region 2
    li t1, 0xdeadbeef
    sw t1, 0x0(t3)              // should be OK (write 0x80008000)
    la TRAP_RA, test2
    lw t2, 0x0(t3)              // should fault (read 0x80008000)
    j fail

// "unlock" region 2, attempt read/write from machine mode
test2:
    li TEST_ID, 2
    la TRAP_RA, fail 
    li t5, PMPCFG0
    csrw pmpcfg0, t5            // "unlock" region 2
    li t1, 0xdeadbeef
    sw t1, 0x0(t3)              // should still be OK (write 0x80008000)
    la TRAP_RA, test3
    lw t2, 0x0(t3)              // should still fault (read 0x80008000)
    j fail

// jump into user mode
test3:
    li TEST_ID, 3
    la TRAP_RA, fail
    la ra, test4
    j to_user

// attempt to read/write region 2 from user mode
test4:
    li TEST_ID, 4
    la TRAP_RA, fail 
    li t1, 0xdeadbeef
    sw t1, 0x0(t3)              // should be OK (write 0x80008000)
    la TRAP_RA, test5
    lw t2, 0x0(t3)              // should fault (read 0x80008000)
    j fail

// attempt to read/write other regions from user mode
test5:
    li TEST_ID, 5
    la TRAP_RA, pass
    li t3, 0x80010000
    li t1, 0xdeadbeef
    sw t1, 0x0(t0)
    lw t2, 0x0(t0)
    bne t1, t2, fail            // should be OK
    lw t2, 0x0(t3)              // should be OK (read 0x80010000)
    la TRAP_RA, pass
    sw t2, 0x0(t3)              // should fault (write 0x80010000)
    
fail:
    li x2, 0xf00fff24
    sw TEST_ID, 0(x2)

pass:
    li x2, 0xf00fff20
    sw x0, 0(x2)
