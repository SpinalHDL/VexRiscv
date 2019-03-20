.globl _start


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

//Test 1  SC on unreserved area should fail and not write memory
    li x28, 1



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
