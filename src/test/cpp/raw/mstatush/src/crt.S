/*
 * mstatush CSR Test Program
 *
 * Tests the mstatush CSR (0x310) implementation in VexRiscv.
 * mstatush represents the upper 32 bits of the 64-bit mstatus register.
 *
 * For RV32 little-endian systems without hypervisor extension or
 * big-endian support, mstatush should be hardwired to zero.
 *
 * Test coverage:
 * - Basic read operations returning zero
 * - Write operations (behavior depends on readOnly parameter)
 * - CSR instruction variants (CSRRW, CSRRS, CSRRC, immediate forms)
 * - Interaction with mstatus (lower 32 bits)
 */

#define MSTATUSH 0x310
#define MSTATUS  0x300

// Trap handler entry point
.align 5
.global trap_entry
trap_entry:
    csrr x29, mcause
    csrr x30, mepc

    // For illegal instruction exceptions, skip the faulting instruction
    li   x28, 0x02
    beq  x28, x29, illegal_instruction_handler

    // For other exceptions, just skip instruction
    addi x30, x30, 4
    csrw mepc, x30
    mret

illegal_instruction_handler:
    // Illegal instruction - this is expected for some tests
    // Set flag in x31 to indicate exception occurred
    li   x31, 1
    addi x30, x30, 4
    csrw mepc, x30
    mret

.text
.globl _start
_start:
    // Initialize test ID register
    li x28, 0
    // Initialize exception flag
    li x31, 0

    //=================================================================
    // Test 1: Basic read - verify mstatush returns zero
    //=================================================================
test1:
    li x28, 1
    csrr x1, MSTATUSH
    bnez x1, fail           // Should be zero

    //=================================================================
    // Test 2: Multiple consecutive reads should all return zero
    //=================================================================
test2:
    li x28, 2
    csrr x1, MSTATUSH
    csrr x2, MSTATUSH
    csrr x3, MSTATUSH
    bne x1, x2, fail        // All three should match
    bne x2, x3, fail
    bnez x1, fail           // And all should be zero

    //=================================================================
    // Test 3: Read after modifying mstatus (lower 32 bits)
    // mstatush should remain zero regardless of mstatus changes
    //=================================================================
test3:
    li x28, 3
    li x4, 0x1888           // MIE=1, MPIE=1, MPP=11
    csrw MSTATUS, x4        // Modify mstatus
    csrr x5, MSTATUS        // Verify mstatus changed
    csrr x6, MSTATUSH       // mstatush should still be zero
    bnez x6, fail

    //=================================================================
    // Test 4: CSRRW - Read old value and write new (atomic swap)
    // For readOnly=true: may trap with illegal instruction
    // For readOnly=false: write accepted but has no effect
    //=================================================================
test4:
    li x28, 4
    li x31, 0               // Clear exception flag
    li x1, 0xDEADBEEF       // Value to write
    csrrw x2, MSTATUSH, x1  // Swap: x2 = old mstatush, mstatush = x1

    // Check if exception occurred
    li x3, 1
    beq x31, x3, test4_exception

    // No exception - verify behavior
    bnez x2, fail           // Old value should be zero
    csrr x3, MSTATUSH       // Read current value
    bnez x3, fail           // Should still be zero (write has no effect)
    j test5

test4_exception:
    // Exception occurred (expected for readOnly=true)
    // Continue to next test
    li x31, 0               // Clear exception flag

    //=================================================================
    // Test 5: CSRRS - Read and set bits
    //=================================================================
test5:
    li x28, 5
    li x31, 0
    li x1, 0xAAAAAAAA       // Bits to set
    csrrs x2, MSTATUSH, x1  // x2 = old value, set bits from x1

    li x3, 1
    beq x31, x3, test5_exception

    bnez x2, fail           // Old value should be zero
    csrr x3, MSTATUSH
    bnez x3, fail           // Should still be zero (bits don't stick)
    j test6

test5_exception:
    li x31, 0

    //=================================================================
    // Test 6: CSRRC - Read and clear bits
    //=================================================================
test6:
    li x28, 6
    li x31, 0
    li x1, 0x55555555       // Bits to clear
    csrrc x2, MSTATUSH, x1  // x2 = old value, clear bits from x1

    li x3, 1
    beq x31, x3, test6_exception

    bnez x2, fail           // Old value should be zero
    csrr x3, MSTATUSH
    bnez x3, fail           // Should still be zero
    j test7

test6_exception:
    li x31, 0

    //=================================================================
    // Test 7: CSRRWI - Write immediate value
    //=================================================================
test7:
    li x28, 7
    li x31, 0
    csrrwi x1, MSTATUSH, 31 // Write immediate value 31 (max 5-bit)

    li x2, 1
    beq x31, x2, test7_exception

    bnez x1, fail           // Old value should be zero
    csrr x2, MSTATUSH
    bnez x2, fail           // Should still be zero
    j test8

test7_exception:
    li x31, 0

    //=================================================================
    // Test 8: CSRRSI - Set bits immediate
    //=================================================================
test8:
    li x28, 8
    li x31, 0
    csrrsi x1, MSTATUSH, 21 // Set bits from immediate

    li x2, 1
    beq x31, x2, test8_exception

    bnez x1, fail
    csrr x2, MSTATUSH
    bnez x2, fail
    j test9

test8_exception:
    li x31, 0

    //=================================================================
    // Test 9: CSRRCI - Clear bits immediate
    //=================================================================
test9:
    li x28, 9
    li x31, 0
    csrrci x1, MSTATUSH, 10 // Clear bits from immediate

    li x2, 1
    beq x31, x2, test9_exception

    bnez x1, fail
    csrr x2, MSTATUSH
    bnez x2, fail
    j test10

test9_exception:
    li x31, 0

    //=================================================================
    // Test 10: CSRW - Write (no read)
    //=================================================================
test10:
    li x28, 10
    li x31, 0
    li x1, 0x12345678
    csrw MSTATUSH, x1       // Write value

    li x2, 1
    beq x31, x2, test10_exception

    csrr x2, MSTATUSH
    bnez x2, fail           // Should still be zero
    j test11

test10_exception:
    li x31, 0

    //=================================================================
    // Test 11: CSRS - Set bits (no read)
    //=================================================================
test11:
    li x28, 11
    li x31, 0
    li x1, 0xFFFFFFFF
    csrs MSTATUSH, x1       // Set all bits

    li x2, 1
    beq x31, x2, test11_exception

    csrr x2, MSTATUSH
    bnez x2, fail           // Should still be zero
    j test12

test11_exception:
    li x31, 0

    //=================================================================
    // Test 12: CSRC - Clear bits (no read)
    //=================================================================
test12:
    li x28, 12
    li x31, 0
    li x1, 0xFFFFFFFF
    csrc MSTATUSH, x1       // Clear all bits

    li x2, 1
    beq x31, x2, test12_exception

    csrr x2, MSTATUSH
    bnez x2, fail           // Should still be zero
    j test13

test12_exception:
    li x31, 0

    //=================================================================
    // Test 13: Verify mstatush and mstatus are independent
    // Writing to mstatush should not affect mstatus
    //=================================================================
test13:
    li x28, 13
    li x31, 0

    // Set mstatus to a known value
    li x1, 0x1888
    csrw MSTATUS, x1
    csrr x2, MSTATUS

    // Try to write mstatush
    li x3, 0xFFFFFFFF
    csrw MSTATUSH, x3       // May or may not trap

    // Verify mstatus unchanged
    csrr x4, MSTATUS
    bne x2, x4, fail        // mstatus should be unchanged

    //=================================================================
    // All tests passed!
    //=================================================================
success:
    li x28, 0xFF            // Success indicator
    li x1, 1
    li x3, 0xF00FFF60       // Success address
    sw x1, 0(x3)
    j .                     // Infinite loop

fail:
    // x28 contains the test ID that failed
    li x3, 0xF00FFF60
    sw x28, 0(x3)           // Write failure test ID
    j .                     // Infinite loop
