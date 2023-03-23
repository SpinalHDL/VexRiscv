.globl _star
#define TEST_ID x28

#include "privileged.h"



_start:
    la x1, fail
    csrw mtvec, x1

test1:
    li TEST_ID, 1
    csrw misa, x0

    //Test xtvec mode
    li x1, 1
    csrw mtvec, x1
    csrr x2, mtvec
    bnez x2, fail
    csrw stvec, x1
    csrr x2, stvec
    bnez x2, fail

    la x1, fail
    csrw mtvec, x1

    li x1, 9
    csrw mcause, x1
    csrr x2, mcause
    bne x2, x1, fail

    /*csrr x0, pmpcfg0
    csrw pmpcfg0, x0

    csrr x0, pmpcfg3
    csrw pmpcfg3, x0

    csrr x0, pmpaddr0
    csrw pmpaddr0, x0

    csrr x0, pmpaddr15
    csrw pmpaddr15, x0*/

    li TEST_ID, 2
    csrr x1, mcycle
    csrr x2, mcycle
    bge x1, x2, fail

    csrr x1, minstret
    csrr x2, minstret
    bge x1, x2, fail

    csrr x1, cycle
    csrr x2, cycle
    bge x1, x2, fail

    csrr x1, instret
    csrr x2, instret
    bge x1, x2, fail

    csrr x1, time
    csrr x2, time
    bge x1, x2, fail

    //Test access to counters in supervisor
    machine_setup_trap
    machine_to_supervisor
    li TEST_ID, 3

    csrr x1, cycle
    csrr x2, cycle
    bge x1, x2, fail

    csrr x1, instret
    csrr x2, instret
    bge x1, x2, fail

    csrr x1, time
    csrr x2, time
    bge x1, x2, fail

    ecall
    machine_handle_trap

    //Test access to counters in user
    machine_setup_trap
    machine_to_user
    li TEST_ID, 4

    csrr x1, cycle
    csrr x2, cycle
    bge x1, x2, fail

    csrr x1, instret
    csrr x2, instret
    bge x1, x2, fail

    csrr x1, time
    csrr x2, time
    bge x1, x2, fail
    ecall
    machine_handle_trap

    //Remove user access to counters
    li x1, -1
    csrw mcounteren, x1
    li x1, 0
    csrw scounteren, x1

    machine_setup_trap
    machine_to_supervisor
    li TEST_ID, 3

    csrr x1, cycle
    csrr x2, cycle
    bge x1, x2, fail

    csrr x1, instret
    csrr x2, instret
    bge x1, x2, fail

    csrr x1, time
    csrr x2, time
    bge x1, x2, fail

    ecall
    machine_handle_trap

    machine_setup_trap
    machine_to_user
    csrr x1, cycle
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_user
    csrr x1, instret
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_user
    csrr x1, time
    j fail
    machine_handle_trap


    //Remove supervisor access to counters
    li x1, 0
    csrw mcounteren, x1
    li x1, -1
    csrw scounteren, x1

    machine_setup_trap
    machine_to_supervisor
    csrr x1, cycle
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_supervisor
    csrr x1, instret
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_supervisor
    csrr x1, time
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_user
    csrr x1, cycle
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_user
    csrr x1, instret
    j fail
    machine_handle_trap

    machine_setup_trap
    machine_to_user
    csrr x1, time
    j fail
    machine_handle_trap



    j pass

fail:
    li x2, 0xF00FFF24
    sw TEST_ID, 0(x2)

pass:
    li x2, 0xF00FFF20
    sw x0, 0(x2)

    nop
    nop
    nop
    nop
    nop
    nop
