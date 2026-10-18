# time.s — 时间（x86-64 Linux 系统调用，无 libc）
#
# 与 runtime/sys.c 的 C 实现同 ABI：
#   int64_t __ayanami_time_millis(void)      CLOCK_MONOTONIC 毫秒
#   int64_t __ayanami_time_micros(void)      CLOCK_MONOTONIC 微秒
#   int64_t __ayanami_time_unix(void)        Unix 秒（CLOCK_REALTIME）
#   int64_t __ayanami_time_sleep_ms(int64_t) 睡眠毫秒（EINTR 续睡）
#
# 系统调用号：nanosleep=35 clock_gettime=228
# CLOCK_REALTIME=0 CLOCK_MONOTONIC=1

    .text

# int64_t __ayanami_time_millis(void)
    .globl __ayanami_time_millis
    .type  __ayanami_time_millis, @function
__ayanami_time_millis:
    subq $24, %rsp                # struct timespec {sec, nsec}
    movq $228, %rax               # clock_gettime
    movq $1, %rdi                 # CLOCK_MONOTONIC
    movq %rsp, %rsi
    syscall
    movq (%rsp), %r9              # sec
    movq 8(%rsp), %rax            # nsec
    xorl %edx, %edx
    movq $1000000, %rcx
    divq %rcx                     # nsec / 1e6
    imulq $1000, %r9, %r9
    addq %r9, %rax
    addq $24, %rsp
    ret
    .size __ayanami_time_millis, .-__ayanami_time_millis

# int64_t __ayanami_time_micros(void)
    .globl __ayanami_time_micros
    .type  __ayanami_time_micros, @function
__ayanami_time_micros:
    subq $24, %rsp
    movq $228, %rax
    movq $1, %rdi
    movq %rsp, %rsi
    syscall
    movq (%rsp), %r9
    movq 8(%rsp), %rax
    xorl %edx, %edx
    movq $1000, %rcx
    divq %rcx                     # nsec / 1000
    imulq $1000000, %r9, %r9
    addq %r9, %rax
    addq $24, %rsp
    ret
    .size __ayanami_time_micros, .-__ayanami_time_micros

# int64_t __ayanami_time_unix(void)
    .globl __ayanami_time_unix
    .type  __ayanami_time_unix, @function
__ayanami_time_unix:
    subq $24, %rsp
    movq $228, %rax
    xorl %edi, %edi               # CLOCK_REALTIME
    movq %rsp, %rsi
    syscall
    movq (%rsp), %rax
    addq $24, %rsp
    ret
    .size __ayanami_time_unix, .-__ayanami_time_unix

# int64_t __ayanami_time_sleep_ms(int64_t ms)   ms <= 0 直接返回 0
    .globl __ayanami_time_sleep_ms
    .type  __ayanami_time_sleep_ms, @function
__ayanami_time_sleep_ms:
    testq %rdi, %rdi
    jle 2f
    subq $24, %rsp
    movq %rdi, %rax
    xorl %edx, %edx
    movq $1000, %rcx
    divq %rcx                     # rax = 秒, rdx = 余毫秒
    movq %rax, (%rsp)
    imulq $1000000, %rdx, %rdx
    movq %rdx, 8(%rsp)
1:  movq $35, %rax                # nanosleep
    movq %rsp, %rdi
    xorl %esi, %esi               # 不关心剩余时间（循环续睡）
    syscall
    cmpq $-4, %rax                # EINTR → 继续
    je 1b
    addq $24, %rsp
2:  xorl %eax, %eax
    ret
    .size __ayanami_time_sleep_ms, .-__ayanami_time_sleep_ms

    .section .note.GNU-stack,"",@progbits
