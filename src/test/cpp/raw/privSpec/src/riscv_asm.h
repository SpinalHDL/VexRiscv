#pragma once

//exceptions
#define CAUSE_ILLEGAL_INSTRUCTION 2
#define CAUSE_UCALL 8
#define CAUSE_SCALL 9

//interrupts
#define CAUSE_MACHINE_SOFTWARE 3
#define CAUSE_MACHINE_TIMER 7
#define CAUSE_MACHINE_EXTERNAL 11
#define CAUSE_SUPERVISOR_SOFTWARE 1
#define CAUSE_SUPERVISOR_TIMER 5
#define CAUSE_SUPERVISOR_EXTERNAL 9


#define MIE_MTIE (1 << CAUSE_MACHINE_TIMER)
#define MIE_MEIE (1 << CAUSE_MACHINE_EXTERNAL)
#define MIE_MSIE (1 << CAUSE_MACHINE_SOFTWARE)
#define MIE_SEIE (1 << CAUSE_SUPERVISOR_EXTERNAL)

#define MEDELEG_INSTRUCTION_PAGE_FAULT (1 << 12)
#define MEDELEG_LOAD_PAGE_FAULT (1 << 13)
#define MEDELEG_STORE_PAGE_FAULT (1 << 15)
#define MEDELEG_USER_ENVIRONNEMENT_CALL (1 << 8)
#define MIDELEG_SUPERVISOR_SOFTWARE (1 << 1)
#define MIDELEG_SUPERVISOR_TIMER (1 << 5)
#define MIDELEG_SUPERVISOR_EXTERNAL (1 << 9)


#define MSTATUS_UIE         0x00000001
#define MSTATUS_SIE         0x00000002
#define MSTATUS_HIE         0x00000004
#define MSTATUS_MIE         0x00000008
#define MSTATUS_UPIE        0x00000010
#define MSTATUS_SPIE        0x00000020
#define MSTATUS_HPIE        0x00000040
#define MSTATUS_MPIE        0x00000080
#define MSTATUS_SPP         0x00000100
#define MSTATUS_HPP         0x00000600
#define MSTATUS_MPP         0x00001800
#define MSTATUS_FS          0x00006000
#define MSTATUS_XS          0x00018000
#define MSTATUS_MPRV        0x00020000
#define MSTATUS_SUM         0x00040000
#define MSTATUS_MXR         0x00080000
#define MSTATUS_TVM         0x00100000
#define MSTATUS_TW          0x00200000
#define MSTATUS_TSR         0x00400000
#define MSTATUS32_SD        0x80000000
#define MSTATUS_UXL         0x0000000300000000
#define MSTATUS_SXL         0x0000000C00000000
#define MSTATUS64_SD        0x8000000000000000
#define MSTATUS_FS_INITIAL (1 << 13)
#define MSTATUS_FS_CLEAN (2 << 13)
#define MSTATUS_FS_DIRTY (3 << 13)
#define MSTATUS_FS_MASK (3 << 13)


#define MSTATUS_MPP_SUPERVISOR         0x00000800
#define MSTATUS_MPP_USER               0x00000000

#define SSTATUS_UIE         0x00000001
#define SSTATUS_SIE         0x00000002
#define SSTATUS_UPIE        0x00000010
#define SSTATUS_SPIE        0x00000020
#define SSTATUS_SPP         0x00000100
#define SSTATUS_FS          0x00006000
#define SSTATUS_XS          0x00018000
#define SSTATUS_SUM         0x00040000
#define SSTATUS_MXR         0x00080000
#define SSTATUS32_SD        0x80000000
#define SSTATUS_UXL         0x0000000300000000
#define SSTATUS64_SD        0x8000000000000000


#define PMP_R     0x01
#define PMP_W     0x02
#define PMP_X     0x04
#define PMP_A     0x18
#define PMP_L     0x80
#define PMP_SHIFT 2

#define PMP_TOR   0x08
#define PMP_NA4   0x10
#define PMP_NAPOT 0x18

#define RDCYCLE 0xC00 //Read-only cycle Cycle counter for RDCYCLE instruction.
#define RDTIME 0xC01 //Read-only time Timer for RDTIME instruction.
#define RDINSTRET 0xC02 //Read-only instret Instructions-retired counter for RDINSTRET instruction.
#define RDCYCLEH 0xC80 //Read-only cycleh Upper 32 bits of cycle, RV32I only.
#define RDTIMEH 0xC81 //Read-only timeh Upper 32 bits of time, RV32I only.
#define RDINSTRETH 0xC82 //Read-only instreth Upper 32 bits of instret, RV32I only.

