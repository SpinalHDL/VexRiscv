.globl _start

ROM_SUPER_0:

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
    j fail
    mret

_start:
    la x1, fail
    csrw mtvec, x1
    csrw stvec, x1

test1: //test ram
    li x28, 1
    la x1, ROM_2
    li x2, 0x27262524
    lw x1, 4(x1)
    bne x1, x2, fail

test2: //dummy mret
    li x28, 2
    la x1, test3
    csrw mepc, x1
    li x1, 0x1800
    csrw mstatus, x1
    mret
    j fail


test3: // jump to supervisor
    li x28, 3
    li x1, 0x0800
    csrw mstatus, x1
    la x1, test4
    csrw mepc, x1
    mret
    j fail



test4: //test ram mmu off
    li x28, 4
    la x1, ROM_3
    li x2, 0x37363534
    lw x1, 4(x1)
    bne x1, x2, fail

test5: //setup MMU

    li x28, 5
    la x1, MMU_TABLE_0 + 0x800
    la x2, MMU_TABLE_1
    srli x2, x2, 2
    ori x2, x2, 0x11
    sw x2, 0(x1)

    la x1, MMU_TABLE_1 + 0x000*4
    li x2, 0x80000000
    srli x2, x2, 2
    ori x2, x2, 0x1F
    sw x2, 0(x1)


    li x28, 5
    la x1, MMU_TABLE_0 + 0x900
    la x2, MMU_TABLE_2
    srli x2, x2, 2
    ori x2, x2, 0x11
    sw x2, 0(x1)

    la x1, MMU_TABLE_2 + 0x00A*4
    la x2, ROM_4
    srli x2, x2, 2
    ori x2, x2, 0x1F
    sw x2, 0(x1)

    li x28, 5
    la x1, MMU_TABLE_0 + 0xA00
    la x2, ROM_SUPER_0
    srli x2, x2, 2
    ori x2, x2, 0x1F
    sw x2, 0(x1)


    la x1, MMU_TABLE_0
    srli x1, x1, 12
    li x2, 0x80000000
    or x1, x1, x2
    csrw satp, x1


test6: //read through MMU
    li x28, 6
    li x1, 0x9000A008
    li x2, 0x4B4A4948
    lw x1, 0(x1)
    bne x1, x2, fail



test7: //write-read through MMU
    li x28, 7
    li x1, 0x9000A360
    li x2, 0xAAEE0001
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail


test8: //read through MMU super page
    li x28, 8
    la x1, ROM_7 + 0x20000004
    li x2, 0x77767574
    lw x1, 0(x1)
    bne x1, x2, fail



test9: //write-read through MMU  super page
    li x28, 9
    li x1, 0xA000A360
    li x2, 0xAAEE0002
    sw x2, 0(x1)
    lw x1, 0(x1)
    bne x1, x2, fail



test10: //check previously written value without the MMU
    li x28, 10
    csrwi satp, 0

    la x1, ROM_4 + 0x360
    li x2, 0xAAEE0001
    lw x1, 0(x1)
    bne x1, x2, fail


    la x1, ROM_SUPER_0 + 0xA360
    li x2, 0xAAEE0002
    lw x1, 0(x1)
    bne x1, x2, fail










    j pass

fail: //x28 => error code
    csrwi satp, 0
    j failFence
failFence:
    li x2, 0xF00FFF24
    sw x28, 0(x2)

pass:
    csrwi satp, 0
    j passFence
passFence:
    li x2, 0xF00FFF20
    sw x0, 0(x2)



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

/*
.align 22
ROM_SUPER_0:
.word 0x83828180
.word 0x87868584
.word 0x8B8A8988
.word 0x8F8E8D8C

.align 12
ROM_SUPER_1:
.word 0x93929190
.word 0x97969594
.word 0x9B9A9998
.word 0x9F9E9D9C*/


