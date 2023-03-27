#pragma once


#include "riscv_asm.h"

#define trap_setup         \
    la x1, 1f;              \
    csrw mtvec, x1;         \
    addi x1, x1, 0x123;      \
    csrw mtval, x1;         \

#define trap_handle        \
    j fail;                 \
    j fail;                 \
    j fail;                 \
    j fail;                 \
.align 4;  \
1:                         \
    csrr x1, mepc;          \
    csrr x1, mcause;        \
    csrr x1, mstatus;       \
    csrr x1, mtval;           \
    csrr x1, mip;           \

#define trap_handle_setup \
    trap_handle    \
    trap_setup     \



#define supervisor_read \
    csrr x1, sepc;          \
    csrr x1, scause;        \
    csrr x1, sstatus;       \
    csrr x1, stval;           \
    csrr x1, sip;

#define machine_read  \
    csrr x1, mepc;          \
    csrr x1, mcause;        \
    csrr x1, mstatus;       \
    csrr x1, mtval;           \
    csrr x1, mip;           \
    supervisor_read

#define user_read

#define machine_to_supervisor       \
    la x1,1f                       ;\
    csrw mepc, x1                  ;\
    li x1, MSTATUS_MPP_SUPERVISOR  ;\
    csrw mstatus, x1               ;\
    mret                           ;\
    j fail                         ;\
    j fail                         ;\
    j fail                         ;\
    j fail                         ;\
1:                                 ;\
    supervisor_read

#define machine_to_supervisor_x1       \
    csrw mepc, x1                  ;\
    li x1, MSTATUS_MPP_SUPERVISOR  ;\
    csrw mstatus, x1               ;\
    mret                           ;\
    j fail                         ;\
    j fail                         ;\
    j fail                         ;\
    j fail                         ;\



#define machine_to_user       \
    la x1,1f                       ;\
    csrw mepc, x1                  ;\
    li x1, MSTATUS_MPP_USER        ;\
    csrw mstatus, x1               ;\
    mret                           ;\
    j fail                         ;\
    j fail                         ;\
    j fail                         ;\
    j fail                         ;\
1:                                 ;\
    user_read

#define machine_setup_trap \
    la x1, 2f              ;\
    csrw mtvec,x1;

#define machine_handle_trap \
    j fail              ;\
.align 4                ;\
2:                      ;\
    machine_read

#define supervisor_setup_trap \
    la x1, 3f              ;\
    csrw stvec,x1;


#define supervisor_handle_trap \
    j fail              ;\
.align 4                ;\
3:                      ;\
    supervisor_read



#define supervisor_check \
    supervisor_setup_trap \
    csrr x1, mstatus;      \
    supervisor_handle_trap \
    supervisor_read

#define supervisor_external_interrupt_set \
    li x1, SUPERVISOR_EXTERNAL_INTERRUPT_CTRL; \
    li x2, 1; \
    sw x2, 0(x1);

#define supervisor_external_interrupt_clear  \
    li x1, SUPERVISOR_EXTERNAL_INTERRUPT_CTRL; \
    sw x0, 0(x1);

#define wait_interrupt  nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;j fail;
#define delay_long  nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;nop;


#define machine_enable_supervisor_external_interrupt  \
    li x1, 1 << CAUSE_SUPERVISOR_EXTERNAL;             \
    csrw mie, x1;                                      \
    li x1, MSTATUS_MIE ;                               \
    csrw mstatus, x1 ;

#define supervisor_enable_supervisor_external_interrupt  \
    li x1, 1 << CAUSE_SUPERVISOR_EXTERNAL;             \
    csrw sie, x1;                                      \
    li x1, MSTATUS_SIE ;                               \
    csrw sstatus, x1 ;


#define machine_trap_failure \
    la x1, 1f;               \
    csrw mtvec, x1;          \
    j 4f                     \
1:                           \
    nop;                     \
    j fail;                  \
4:

#define supervisor_trap_failure \
    la x1, 1f;                  \
    csrw stvec, x1;             \
    j 4f;                        \
.align 4;                      \
1:                              \
    nop;                        \
    j fail;                     \
4:

