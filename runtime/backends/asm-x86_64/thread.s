# thread.s — 线程（x86-64 Linux；pthread 创建/等待 + gettid/sched_yield 系统调用）
#
# 与 runtime/sys.c 的 C 实现同 ABI：
#   int64_t __ayanami_thread_spawn(Job job)         Job={env, vtable} 按值传入 →
#                                                   运行时接管所有权；返回 handle；失败 0
#   int64_t __ayanami_thread_join(int64_t handle)   0 成功 / -1
#   int64_t __ayanami_thread_id(void)               内核 tid
#   int64_t __ayanami_thread_yield(void)            sched_yield
#
# 所有权：spawn 把 {env, vtable} 拷进 malloc 的 slot；线程入口调用
# trampoline(env)（vtable[1]）→ drop(env)（vtable[0]，回收捕获值）→ free(slot)。
#
# 系统调用：sched_yield=24 gettid=186

    .text

# 线程入口：rdi = slot（16 字节 {env, vtable}）
    .type ayanami_thread_entry, @function
ayanami_thread_entry:
    pushq %rbx                     # slot
    pushq %r12                     # env
    pushq %r13                     # vtable
    movq %rdi, %rbx
    movq (%rbx), %r12
    movq 8(%rbx), %r13
    movq %r12, %rdi
    call *8(%r13)                  # trampoline(env)
    movq %r12, %rdi
    call *(%r13)                   # drop(env)（闭包析构）
    movq %rbx, %rdi
    call free@PLT
    xorl %eax, %eax
    popq %r13
    popq %r12
    popq %rbx
    ret
    .size ayanami_thread_entry, .-ayanami_thread_entry

# int64_t __ayanami_thread_spawn(Job job)   rdi=env, rsi=vtable
    .globl __ayanami_thread_spawn
    .type  __ayanami_thread_spawn, @function
__ayanami_thread_spawn:
    pushq %rbx
    pushq %r12
    pushq %r13
    subq $16, %rsp                 # [rsp] = pthread_t 槽
    movq %rdi, %rbx                # env
    movq %rsi, %r12                # vtable
    movq $16, %rdi                 # slot = malloc(16)
    call malloc@PLT
    testq %rax, %rax
    je 2f
    movq %rbx, (%rax)
    movq %r12, 8(%rax)
    movq %rax, %r13                # slot
    movq %rsp, %rdi                # &t
    xorl %esi, %esi                # attr = NULL
    leaq ayanami_thread_entry(%rip), %rdx
    movq %r13, %rcx                # arg = slot
    call pthread_create@PLT
    testl %eax, %eax
    jne 1f
    movq (%rsp), %rax              # handle
    addq $16, %rsp
    popq %r13
    popq %r12
    popq %rbx
    ret
1:  movq %r13, %rdi                # 创建失败：释放 slot
    call free@PLT
2:  xorl %eax, %eax
    addq $16, %rsp
    popq %r13
    popq %r12
    popq %rbx
    ret
    .size __ayanami_thread_spawn, .-__ayanami_thread_spawn

# int64_t __ayanami_thread_join(int64_t handle)
    .globl __ayanami_thread_join
    .type  __ayanami_thread_join, @function
__ayanami_thread_join:
    subq $8, %rsp
    xorl %esi, %esi                # retval = NULL
    call pthread_join@PLT
    addq $8, %rsp
    testl %eax, %eax
    jne 1f
    xorl %eax, %eax
    ret
1:  movq $-1, %rax
    ret
    .size __ayanami_thread_join, .-__ayanami_thread_join

# int64_t __ayanami_thread_id(void)   gettid
    .globl __ayanami_thread_id
    .type  __ayanami_thread_id, @function
__ayanami_thread_id:
    movq $186, %rax
    syscall
    ret
    .size __ayanami_thread_id, .-__ayanami_thread_id

# int64_t __ayanami_thread_yield(void)   sched_yield
    .globl __ayanami_thread_yield
    .type  __ayanami_thread_yield, @function
__ayanami_thread_yield:
    movq $24, %rax
    syscall
    ret
    .size __ayanami_thread_yield, .-__ayanami_thread_yield

    .section .note.GNU-stack,"",@progbits
