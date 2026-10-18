# rand.s — 系统熵源（x86-64 Linux 系统调用，无 libc）
#
#   int64_t __ayanami_random_u64(void)
#   优先 getrandom；失败退回 /dev/urandom；再失败退回 rdtsc（时间戳）。
#
# 系统调用号：read=0 close=3 openat=257 getrandom=318
# AT_FDCWD=-100  O_RDONLY=0

    .text

    .globl __ayanami_random_u64
    .type  __ayanami_random_u64, @function
__ayanami_random_u64:
    subq $24, %rsp
    movq $318, %rax               # getrandom
    movq %rsp, %rdi
    movq $8, %rsi
    xorl %edx, %edx
    syscall
    cmpq $8, %rax
    jne 1f
    movq (%rsp), %rax
    addq $24, %rsp
    ret
1:  movq $257, %rax               # openat(AT_FDCWD, "/dev/urandom", O_RDONLY)
    movq $-100, %rdi
    leaq urandom_path(%rip), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js 3f
    movq %rax, %rdi               # fd
    xorl %eax, %eax               # read(fd, buf, 8)
    movq %rsp, %rsi
    movq $8, %rdx
    syscall
    cmpq $8, %rax
    jne 2f
    movq (%rsp), %r8              # 取回随机值（close 会破坏 rax）
    movq $3, %rax                 # close(fd)
    syscall
    movq %r8, %rax
    addq $24, %rsp
    ret
2:  movq $3, %rax                 # close(fd)
    syscall
3:  rdtsc                         # 最后回退：时间戳计数器
    shlq $32, %rdx
    orq %rdx, %rax
    addq $24, %rsp
    ret
    .size __ayanami_random_u64, .-__ayanami_random_u64

    .section .rodata
urandom_path:
    .asciz "/dev/urandom"

    .section .note.GNU-stack,"",@progbits
