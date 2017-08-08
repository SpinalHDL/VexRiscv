.globl _start
_start:

#define r_type_insn(_f7, _rs2, _rs1, _f3, _rd, _opc) \
.word (((_f7) << 25) | ((_rs2) << 20) | ((_rs1) << 15) | ((_f3) << 12) | ((_rd) << 7) | ((_opc) << 0))

#define SIMD_ADD(_rd, _rs1, _rs2 ) \
r_type_insn(0b0000011, _rs2, _rs1, 0b000, _rd, 0b0110011)

//Test 1
    li x28, 1
    SIMD_ADD(1, 0, 0)
    bne x1, x0, fail

//Test 2
    li x28, 2
    li x1, 0x00000000
    li x2, 0x00000000
    SIMD_ADD(1, 1, 2)
    bne x1, x0, fail

//Test 3
    li x28, 3
    li x1, 0x01020304
    li x2, 0x00000000
    SIMD_ADD(3, 1, 2)
    bne x3, x1, fail

//Test 4
    li x28, 4
    li x4, 0x0306090C
    li x1, 0x01020304
    li x2, 0x02040608
    SIMD_ADD(3, 1, 2)
    bne x3, x4, fail

//Test 5
    li x28, 5
    li x4, 0xFF000102
    li x1, 0xFFFFFFFF
    li x2, 0x00010203
    SIMD_ADD(3, 1, 2)
    bne x3, x4, fail

//Test 5
    li x28, 6
    li x5, 0x00000006
    li x1, 0x00000001
    li x2, 0x00000002
    li x3, 0x00000003
    SIMD_ADD(1, 1, 2)
    SIMD_ADD(1, 1, 3)
    bne x1, x5, fail

    j pass

fail: //x28 => error code
    li x2, 0xF00FFF24
    sw x28, 0(x2)

pass:
    li x2, 0xF00FFF20
    sw x0, 0(x2)



    nop
    nop
    nop
    nop
    nop
    nop
