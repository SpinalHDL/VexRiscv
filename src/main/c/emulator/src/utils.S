#include "riscv.h"
/*

    .section .init
    .globl readMemory
    .type readMemory,@function
readWord:
	csrr a4, mepc
	li a2, MSTATUS_MPRV
	csrs mstatus, a2
	li a3, emulationTrap
	csrw mepc, a3
	lw a0, 0(a0)
	li a3, trapEntry
	csrw mepc, a3
	csrc mstatus, a2

writeWord:
	csrr a4, mepc
	li a2, MSTATUS_MPRV
	csrs mstatus, a2
	li a3, emulationTrap
	csrw mepc, a3
	sw a1, 0(a0)
	li a3, trapEntry
	csrw mepc, a3
	csrc mstatus, a2
*/
//Redirect trap to supervisor
/*
    .section .init
    .globl emulationTrap
    .type emulationTrap,@function
emulationTrap:
	li a0, MSTATUS_MPRV
	csrc mstatus, a0

	la sp, _sp
	csrw sepc, a4
	csrr a0, mcause
	csrw scause, a0
	csrr a0, mbadaddr
	csrw sbadaddr, a0

	call init
	mret
*/
