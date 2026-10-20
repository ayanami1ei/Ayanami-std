# futex.s — futex 等待/唤醒（x86-64 Linux，raw syscall 202）
#
#   int64_t __ayanami_futex_wait(int32_t *addr, int32_t expected)  0（含 EINTR）/ -1
#   int64_t __ayanami_futex_wake(int32_t *addr, int32_t n)          唤醒数 / -1
#
# FUTEX_WAIT=0 FUTEX_WAKE=1 EINTR=-4

    .text

# int64_t __ayanami_futex_wait(int32_t *addr, int32_t expected)
    .globl __ayanami_futex_wait
    .type  __ayanami_futex_wait, @function
__ayanami_futex_wait:
    movq %rsi, %rdx                # expected
    xorl %esi, %esi                # FUTEX_WAIT
    xorl %r10d, %r10d              # timeout = NULL
    xorl %r8d, %r8d                # uaddr2 = NULL
    xorl %r9d, %r9d
    movq $202, %rax
    syscall
    testq %rax, %rax
    js 1f
    xorl %eax, %eax
    ret
1:  cmpq $-4, %rax                 # EINTR → 0（调用方重查状态）
    jne 2f
    xorl %eax, %eax
    ret
2:  movq $-1, %rax
    ret
    .size __ayanami_futex_wait, .-__ayanami_futex_wait

# int64_t __ayanami_futex_wake(int32_t *addr, int32_t n)
    .globl __ayanami_futex_wake
    .type  __ayanami_futex_wake, @function
__ayanami_futex_wake:
    movq %rsi, %rdx                # n
    movq $1, %rsi                  # FUTEX_WAKE
    xorl %r10d, %r10d
    xorl %r8d, %r8d
    xorl %r9d, %r9d
    movq $202, %rax
    syscall
    testq %rax, %rax
    js 1f
    ret
1:  movq $-1, %rax
    ret
    .size __ayanami_futex_wake, .-__ayanami_futex_wake

    .section .note.GNU-stack,"",@progbits
