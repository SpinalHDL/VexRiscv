.globl _start

#define TEST_ID x28
#define TRAP_OK x29
#define TRAP_RET x30


ROM_SUPER_0:

_start:
    li TRAP_OK, 0 //Do not allow trap
    la x1, trap
    csrw mtvec, x1

test1: //test ram
    li TEST_ID, 1
    la x1, ROM_2
    li x2, 0x27262524
    lw x1, 4(x1)
    bne x1, x2, fail

test2: //dummy mret
    li TEST_ID, 2
    la x1, test3
    csrw mepc, x1
    li x1, 0x1800
    csrw mstatus, x1
    mret
    j fail


test3: // jump to supervisor
    li TEST_ID, 3
    li x1, 0x0800
    csrw mstatus, x1
    la x1, test4
    csrw mepc, x1
    mret
    j fail



test4: //test ram mmu off
    li TEST_ID, 4
    la x1, ROM_3
    li x2, 0x37363534
    lw x1, 4(x1)
    bne x1, x2, fail

test5: //setup MMU

    li TEST_ID, 5
    la x1, MMU_TABLE_0 + 0x800
    la x2, MMU_TABLE_1
    srli x2, x2, 2
    ori x2, x2, 0x1
    sw x2, 0(x1)

    la x1, MMU_TABLE_1 + 0x000*4
    li x2, 0x80000000
    srli x2, x2, 2
    ori x2, x2, 0x0F | 0xC0
    sw x2, 0(x1)


    li TEST_ID, 5
    la x1, MMU_TABLE_0 + 0x900
    la x2, MMU_TABLE_2
    srli x2, x2, 2
    ori x2, x2, 0x01
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x00A*4
    la x2, ROM_4
    srli x2, x2, 2
    ori x2, x2, 0x1F | 0xC0
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x010*4 // Read Only
    la x2, ROM_5
    srli x2, x2, 2
    ori x2, x2, 0x11 + (0x1 << 1) | 0xC0
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x011*4 // Read Write
    la x2, ROM_5
    srli x2, x2, 2
    ori x2, x2, 0x11 + (0x3 << 1) | 0xC0
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x012*4 // Execute only
    la x2, ROM_5
    srli x2, x2, 2
    ori x2, x2, 0x11 + (0x4 << 1) | 0xC0
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x013*4 //Read Execute
    la x2, ROM_5
    srli x2, x2, 2
    ori x2, x2, 0x11 + (0x5 << 1) | 0xC0
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x014*4 //no user
    la x2, ROM_5
    srli x2, x2, 2
    ori x2, x2, 0x01 + (0x7 << 1) | 0xC0
    sw x2, 0(x1)

    li TEST_ID, 5
    la x1, MMU_TABLE_0 + 0xA00
    la x2, ROM_SUPER_0
    srli x2, x2, 2
    ori x2, x2, 0x1F | 0xC0
    sw x2, 0(x1)

    li TEST_ID, 5
    la x1, MMU_TABLE_0 + 0xB00
    sw x0, 0(x1)

    li x1, 1 << 18 //SUM
    csrs sstatus, x1

    la x1, MMU_TABLE_0
    srli x1, x1, 12
    li x2, 0x80000000
    or x1, x1, x2
    sfence.vma
    csrw satp, x1
    fence.i


test6: //read through MMU
    li TEST_ID, 6
    li x1, 0x9000A008
    li x2, 0x4B4A4948
    lw x1, 0(x1)
    bne x1, x2, fail



test7: //write-read through MMU
    li TEST_ID, 7
    li x1, 0x9000A360
    li x2, 0xAAEE0001
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail


test8: //read through MMU super page
    li TEST_ID, 8
    la x1, ROM_7 + 0x20000004
    li x2, 0x77767574
    lw x1, 0(x1)
    bne x1, x2, fail



test9: //write-read through MMU  super page
    li TEST_ID, 9
    li x1, 0xA000A360
    li x2, 0xAAEE0002
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail



test10: //check previously written value without the MMU
    li TEST_ID, 10
    csrwi satp, 0

    la x1, ROM_4 + 0x360
    li x2, 0xAAEE0001
    lw x1, 0(x1)
    bne x1, x2, fail


test11:
    li TEST_ID, 11
    la x1, ROM_SUPER_0 + 0xA360
    li x2, 0xAAEE0002
    lw x1, 0(x1)
    bne x1, x2, fail


    la x1, MMU_TABLE_0
    srli x1, x1, 12
    li x2, 0x80000000
    or x1, x1, x2
    csrw satp, x1


test12: //Dummy trap
    li TEST_ID, 12
    li TRAP_OK, 1 //Allow trap
    la TRAP_RET, test13 // trap return address
    ecall
    j fail


test13: //Trap load page fault
    li TEST_ID, 13
    la TRAP_RET, test14
    li x1, 0xB0000000
    lw x1, 8(x1)
    j fail


test14: //Trap store page fault
    li TEST_ID, 14
    la TRAP_RET, test15
    li x1, 0xB0000000
    sw x1, 8(x1)
    j fail


test15: //Trap instruction fetch
    li TEST_ID, 15
    la TRAP_RET, test15_end
    li x1, 0xB0000000
    jr x1
    j fail

test15_end:


test16: //Test limited read access
    li TEST_ID, 16
    li TRAP_OK, 0 //disable trap

    li x1, 0x90010008
    li x2, 0x5B5A5958
    lw x1, 0(x1)
    bne x1, x2, fail


    li x1, 0x90011008
    li x2, 0x5B5A5958
    lw x1, 0(x1)
    bne x1, x2, fail

    li x1, 0x90013008
    li x2, 0x5B5A5958
    lw x1, 0(x1)
    bne x1, x2, fail

test17: //Test limited write access
    li TEST_ID, 17

    li x1, 0x90011360
    li x2, 0xAAEE0003
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail

test18: //Test limited execute access
    li TEST_ID, 18
    li TRAP_OK, 1
    la TRAP_RET, test18_end
    li x2, 0x90012010
    jr x2
    j fail
test18_end:


test19: //exception by access limitations
    li TEST_ID, 19
    li TRAP_OK, 1 //Allow trap
    la TRAP_RET, test19_readTrap
    li x1, 0x90012010
    lw x1, 0(x1)
    j fail
test19_readTrap:
    la TRAP_RET, test19_writeTrap
    li x1, 0x90013010
    sw x1, 0(x1)
    j fail
test19_writeTrap:
    la TRAP_RET, test19_executeTrap
    li x1, 0x90011010
    jr x1
    j fail
test19_executeTrap:


test20: //mxr set, read executable
    li TEST_ID, 21
    li TRAP_OK, 0
    li x1, 1 << 19
    csrs sstatus, x1
    li x1, 0x90012008
    li x2, 0x5B5A5958
    lw x1, 0(x1)
    bne x1, x2, fail
    li x1, 1 << 19
    csrc sstatus, x1


test21: //supervisor accessing not user
    li TRAP_OK, 0
    li TEST_ID, 20
    li x1, 0x90014380
    li x2, 0xAAEE0005
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail


    li x1, 1 << 18 //clear SUM
    csrc sstatus, x1
    li TRAP_OK, 1
    la TRAP_RET, test21_pass
    li x1, 0x90011648
    sw x1, 0(x1)
    j fail

test21_pass:






test50:  //User mode setup
    li TEST_ID, 50
    li TRAP_OK, 0

    //set SUM
    li x1, 1 << 18
    csrs sstatus, x1

    //remap code tlb into userspace
    csrr x10, satp
    csrw satp, x0
    la x1, MMU_TABLE_1 + 0x00D*4 //test51
    li x2, 0x8000D000
    srli x2, x2, 2
    ori x2, x2, 0x1F | 0x40
    sw x2, 0(x1)
    csrw satp, x10

    li x1, 1 << 8
    csrc sstatus, x1 //clear SPP

    la x1, test51
    csrw sepc, x1
    sfence.vma
    sret
    j fail


fail: //TEST_ID => error code
    li TRAP_OK, 0
    la TRAP_RET, failFence
    ecall
failFence:
    li x2, 0xF00FFF24
    sw TEST_ID, 0(x2)

pass:
    li TRAP_OK, 1
    la TRAP_RET, passFence
    ecall
passFence:
    li x2, 0xF00FFF20
    sw x0, 0(x2)

.align 4
trap:
    beq TRAP_OK, x0, fail
    csrr x1, mcause
    csrr x1, mepc
    csrr x1, mstatus
    csrr x1, mbadaddr
    li x1, 2
    beq TRAP_OK, x1, pass
    csrw mepc, TRAP_RET
    mret


    nop
    nop
    nop
    nop
    nop
    nop


.align 12
MMU_TABLE_0:
.word 0

.align 12
MMU_TABLE_1:
.word 0

.align 12
MMU_TABLE_2:
.word 0

.align 12
MMU_TABLE_3:
.word 0

.align 12
ROM_0:
.word 0x03020100
.word 0x07060504
.word 0x0B0A0908
.word 0x0F0E0D0C

.align 12
ROM_1:
.word 0x13121110
.word 0x17161514
.word 0x1B1A1918
.word 0x1F1E1D1C

.align 12
ROM_2:
.word 0x23222120
.word 0x27262524
.word 0x2B2A2928
.word 0x2F2E2D2C

.align 12
ROM_3:
.word 0x33323130
.word 0x37363534
.word 0x3B3A3938
.word 0x3F3E3D3C

.align 12
ROM_4:
.word 0x43424140
.word 0x47464544
.word 0x4B4A4948
.word 0x4F4E4D4C

.align 12
ROM_5:
.word 0x53525150
.word 0x57565554
.word 0x5B5A5958
.word 0x5F5E5D5C
    jr x1

.align 12
ROM_6:
.word 0x63626160
.word 0x67666564
.word 0x6B6A6968
.word 0x6F6E6D6C

.align 12
ROM_7:
.word 0x73727170
.word 0x77767574
.word 0x7B7A7978
.word 0x7F7E7D7C


.align 12
test51: //user read/write
    li TEST_ID, 51
    li x1, 0x90011008
    li x2, 0x5B5A5958
    lw x1, 0(x1)
    bne x1, x2, fail

    li x1, 0xA000A324
    li x2, 0xAAEE0008
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail

test52: //user fetch
    li TEST_ID, 52
    la x1, test53
    li x2, 0x90012010
    jr x2
    j fail

test53: // user fetch page fault
    li TEST_ID, 53
    li TRAP_OK, 1
    la TRAP_RET, test54
    li x1, 0x90014390
    jr x1
    j fail

test54: //user load page fault
    li TEST_ID, 54
    li TRAP_OK, 1
    la TRAP_RET, test55
    li x1, 0x90014394
    lw x1, 0(x1)
    j fail

test55: //user store page fault
    li TEST_ID, 55
    li TRAP_OK, 1
    la TRAP_RET, test56
    li x1, 0x90014398
    sw x1, 0(x1)
    j fail

test56:

    li TRAP_OK, 2
    ecall
