#define CONSISTENCY_REDO_COUNT 50


#define REPORT_OFFSET 0xF8000000
#define REPORT_THREAD_ID 0x00
#define REPORT_THREAD_COUNT 0x04
#define REPORT_END 0x08
#define REPORT_BARRIER_START 0x0C
#define REPORT_BARRIER_END   0x10
#define REPORT_CONSISTENCY_VALUES   0x14

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
    li a0, 400
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


    lw gp, barrier_allocator

consistancy_test1:
    la t0, consistancy_init_load
    sw t0, consistancy_init_call, t1
    la t0, consistancy_do_simple_fence
    sw t0, consistancy_do_call, t1
    la t0, consistancy_test2
    sw t0, consistancy_done_call, t1
    j consistancy_start

consistancy_test2:
    la t0, consistancy_init_load
    sw t0, consistancy_init_call, t1
    la t0, consistancy_do_rl_fence
    sw t0, consistancy_do_call, t1
    la t0, success
    sw t0, consistancy_done_call, t1
    j consistancy_start


consistancy_init_load:
    lw s3, (s1) //Help getting the cache loaded for the consistancy check
    j consistancy_do_init_done

consistancy_do_simple_fence:
    //Consistancy check : write to read ordering on two thread
    sw s2, (s0)
    fence w,r
    lw s3, (s1)
    sw s3, 64(s0)
    j consistancy_join

consistancy_do_rl_fence:
    //Consistancy check : write to read ordering on two thread
    sw s2, (s0)
    lr.w.rl s3, (s1)
    sw s3, 64(s0)
    j consistancy_join


consistancy_start:
    mv a0, gp
    addi gp, gp, 1
    call barrier_lrsc
    sw x0, consistancy_all_tested, t0
consistancy_loop:
    //Sync
    mv a0, gp
    addi gp, gp, 1
    call barrier_lrsc

    //all passed ?
    lw t0, consistancy_all_tested
    li t1, CONSISTENCY_REDO_COUNT
    bge t0, t1, consistancy_passed

    //identify who is A, who is B
    lw t0, consistancy_a_hart
    lw t1, consistancy_b_hart
    beq t0, t1, consistancy_join
    csrr t0, mhartid
    lw t1, consistancy_a_hart
    la s0, consistancy_a_value
    la s1, consistancy_b_value
    beq t0, t1, consistancy_do
    lw t1, consistancy_b_hart
    la s0, consistancy_b_value
    la s1, consistancy_a_value
    beq t0, t1, consistancy_do

consistancy_hart_not_involved:
    mv a0, gp
    addi gp, gp, 1
    call barrier_lrsc
    j consistancy_join

consistancy_do:
    lw t0, consistancy_init_call
    jalr t0
consistancy_do_init_done:
    li s2, 666
    mv a0, gp
    addi gp, gp, 1
    call barrier_lrsc


    lw t0, consistancy_do_call
    jalr t0

consistancy_join:
    fence rw, rw //ensure updated values
    mv a0, gp
    addi gp, gp, 1
    call barrier_lrsc
    csrr t0, mhartid
    bnez t0, consistancy_loop

consistancy_assert:
    lw t0, consistancy_a_hart
    lw t1, consistancy_b_hart
    beq t0, t1, consistancy_increment
    lw a0, consistancy_a_readed
    report(a0, REPORT_CONSISTENCY_VALUES)
    lw a0, consistancy_b_readed
    report(a0, REPORT_CONSISTENCY_VALUES)

consistancy_increment:
    csrr t0, mhartid
    bnez t0, consistancy_loop
    sw x0, (consistancy_a_value), t0
    sw x0, (consistancy_b_value), t0
    lw s0,thread_count
    lw t0,consistancy_b_hart
    addi t0, t0, 1
    sw t0, consistancy_b_hart, t1
    bne t0, s0, consistancy_increment_fence
    sw x0, consistancy_b_hart, t1
    lw t0,consistancy_a_hart
    addi t0, t0, 1
    sw t0, consistancy_a_hart, t1
    bne t0, s0, consistancy_increment_fence
    sw x0, consistancy_a_hart, t1
    lw t0, consistancy_all_tested
    addi t0, t0, 1
    sw t0, consistancy_all_tested, t1
consistancy_increment_fence:
    fence w, rw
    j consistancy_loop

consistancy_passed:
    lw s0, consistancy_done_call
    mv a0, gp
    addi gp, gp, 1
    call barrier_lrsc
    jalr s0



#define ENTRY_PHASE t4
barrier_amo:
    report(a0, REPORT_BARRIER_START)
    lw ENTRY_PHASE, barrier_phase
    la t0, barrier_value
    li t1, 1
    amoadd.w t0, t1, (t0)
    addi t0, t0, 1
    lw t1, thread_count
    bne t0, t1, barrier_amo_wait
    addi t0,ENTRY_PHASE,1
    sw x0, barrier_value, t1
    sw t0, barrier_phase, t1
barrier_amo_wait:
    lw t0, barrier_phase
    beq t0, ENTRY_PHASE, barrier_amo_wait
    report(a0, REPORT_BARRIER_END)
    ret

barrier_lrsc:
    report(a0, REPORT_BARRIER_START)
    lw ENTRY_PHASE, barrier_phase
    la t0, barrier_value
barrier_lrsc_try:
    lr.w t1, (t0)
    addi t1, t1, 1
    sc.w t2, t1, (t0)
    bnez t2, barrier_lrsc_try
    lw t0, thread_count
    bne t0, t1, barrier_lrsc_wait
    addi t0,ENTRY_PHASE,1
    sw x0, barrier_value, t1
    sw t0, barrier_phase, t1
barrier_lrsc_wait:
    lw t0, barrier_phase
    beq t0, ENTRY_PHASE, barrier_lrsc_wait
    report(a0, REPORT_BARRIER_END)
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

.align   6 //Same cache line
barrier_value: .word 0
barrier_phase: .word 0
barrier_allocator: .word 0x1000

consistancy_a_hart: .word 0
consistancy_b_hart: .word 0
consistancy_all_tested: .word 0


nop;nop;nop;nop;nop;nop;nop;nop;
nop;nop;nop;nop;nop;nop;nop;nop;
.align   6 //Same cache line
consistancy_a_value: .word 0
consistancy_b_value: .word 0

.align   6 //Same cache line
consistancy_b_readed: .word 0
consistancy_a_readed: .word 0

.align   6 //Same cache line
consistancy_init_call: .word 0
consistancy_do_call: .word 0
consistancy_done_call: .word 0