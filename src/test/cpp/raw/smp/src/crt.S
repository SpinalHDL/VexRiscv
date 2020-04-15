#define REPORT_OFFSET 0xF0000000
#define REPORT_THREAD_ID 0
#define REPORT_THREAD_COUNT 1
#define REPORT_SUCCESS 2
#define REPORT_FAILURE 3

#define report(reg, id) \
    li a0, id*4; \
    sw reg, 0(a0); \

_start:

    #define HART_ID x20
    csrr HART_ID, mhartid
    la a0, test1_data
    report(a0, REPORT_THREAD_ID)


count_thread_start:
    //Count up threads
    li a0, 1
    la a1, thread_count
    amoadd.w x0, a0, (a1)

count_thread_wait:
    //Wait everybody
    lw s0, thread_count
    li a0, 200
    call sleep
    lw s1, thread_count
    bne s1, s0, count_thread_wait
    report(s1, REPORT_THREAD_ID)

    j success

success:
    report(x0, REPORT_SUCCESS)
    j end

failure:
    report(x0, REPORT_FAILURE)
    j end

end:
    j end


sleep:
    addi a0, a0, -1
    bnez a0, sleep
    ret


thread_count: .word 0
shared_memory_1: .word 0

test1_data: .word 11
test2_data: .word 22
test3_data: .word 73
test4_data: .word 58
test5_data: .word 56
test6_data: .word 75
test7_data: .word 56
test8_data: .word 83
test9_data: .word 33
test10_data: .word -65
test11_data: .word -87
test12_data: .word -55
test13_data: .word 0xFFFF0004
test14_data: .word 0xFFFF0005