#define REPORT_OFFSET 0xF8000000
#define REPORT_THREAD_ID 0x00
#define REPORT_THREAD_COUNT 0x04
#define REPORT_END 0x08
#define REPORT_BARRIER_START 0x0C
#define REPORT_BARRIER_END   0x10

#define report(reg, id) \
    li t0, REPORT_OFFSET+id; \
    csrr t1, mhartid; \
    slli t1, t1, 16; \
    add t0, t0, t1; \
    sw reg, 0(t0); \

_start:
    csrr s0, mhartid
    report(s0, REPORT_THREAD_ID)


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
    report(s1, REPORT_THREAD_COUNT)


barrier_amo_test:
    li a0, 1
    call barrier_amo
    li a0, 2
    call barrier_amo
    li a0, 3
    call barrier_amo

    li a0, 4
    call barrier_lrsc
    li a0, 5
    call barrier_lrsc
    li a0, 6
    call barrier_lrsc

    li a0, 7
    call barrier_amo
    li a0, 8
    call barrier_lrsc


    j success




barrier_amo:
    report(a0, REPORT_BARRIER_START)
    la t0, barrier_amo_value
    li t1, 1
    amoadd.w x0, t1, (t0)
    lw t1, thread_count
barrier_amo_wait:
    lw t2, (t0)
    bne t2, t1, barrier_amo_wait
    report(a0, REPORT_BARRIER_END)
barrier_amo_reset:
    csrr t0, mhartid
    bnez t0, barrier_amo_reset_wait
    sw x0, barrier_amo_value, t0
    ret
barrier_amo_reset_wait:
    lw t0, barrier_amo_value
    bnez t0, barrier_amo_reset_wait
    ret
    
barrier_lrsc:
    report(a0, REPORT_BARRIER_START)
    la t0, barrier_lrsc_value
barrier_lrsc_try:
    lr.w t1, (t0)
    addi t1, t1, 1
    sc.w t1, t1, (t0)
    bnez t1, barrier_lrsc_try
    lw t1, thread_count
barrier_lrsc_wait:
    lw t2, (t0)
    bne t2, t1, barrier_lrsc_wait
    report(a0, REPORT_BARRIER_END)
barrier_lrsc_reset:
    csrr t0, mhartid
    bnez t0, barrier_lrsc_reset_wait
    sw x0, barrier_lrsc_value, t0
    ret
barrier_lrsc_reset_wait:
    lw t0, barrier_lrsc_value
    bnez t0, barrier_lrsc_reset_wait
    ret



success:
    li s0, 0
    report(s0, REPORT_END)
    j end

failure:
    li s0, 1
    report(s0, REPORT_END)
    j end

end:
    j end


sleep:
    addi a0, a0, -1
    bnez a0, sleep
    ret


thread_count: .word 0
shared_memory_1: .word 0
barrier_amo_value: .word 0
barrier_lrsc_value: .word 0
