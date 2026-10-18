# io.s — 标准 IO（x86-64 Linux 系统调用，无 libc）
#
# 与 runtime.c 的 C 实现同 ABI：
#   int64_t __ayanami_getchar(void)               读 1 字节；EOF/失败 → -1
#   void    __ayanami_putchar(int c)              写 1 字节到 stdout
#   void    __ayanami_print_int(int64_t n)        十进制（无换行）
#   void    __ayanami_print_str(const char*, int64_t len)
#   void    __ayanami_print_ln(void)              换行
#
# 系统调用号：read=0 write=1

    .text

# int64_t __ayanami_getchar(void)
    .globl __ayanami_getchar
    .type  __ayanami_getchar, @function
__ayanami_getchar:
    subq $24, %rsp                # [rsp] = 1 字节缓冲
    xorl %eax, %eax               # read
    xorl %edi, %edi               # fd 0 (stdin)
    movq %rsp, %rsi
    movq $1, %rdx
    syscall
    cmpq $1, %rax
    jne 1f
    movzbq (%rsp), %rax
    addq $24, %rsp
    ret
1:  movq $-1, %rax                # EOF / 错误
    addq $24, %rsp
    ret
    .size __ayanami_getchar, .-__ayanami_getchar

# void __ayanami_putchar(int c)
    .globl __ayanami_putchar
    .type  __ayanami_putchar, @function
__ayanami_putchar:
    subq $24, %rsp
    movb %dil, (%rsp)
    movq $1, %rax                 # write
    movq $1, %rdi                 # fd 1 (stdout)
    movq %rsp, %rsi
    movq $1, %rdx
    syscall
    addq $24, %rsp
    ret
    .size __ayanami_putchar, .-__ayanami_putchar

# void __ayanami_print_str(const char *s, int64_t len)
    .globl __ayanami_print_str
    .type  __ayanami_print_str, @function
__ayanami_print_str:
    movq %rsi, %rdx               # len
    movq %rdi, %rsi               # buf
    movq $1, %rdi                 # fd 1
    movq $1, %rax                 # write
    syscall
    ret
    .size __ayanami_print_str, .-__ayanami_print_str

# void __ayanami_print_ln(void)
    .globl __ayanami_print_ln
    .type  __ayanami_print_ln, @function
__ayanami_print_ln:
    subq $24, %rsp
    movb $10, (%rsp)
    movq $1, %rax
    movq $1, %rdi
    movq %rsp, %rsi
    movq $1, %rdx
    syscall
    addq $24, %rsp
    ret
    .size __ayanami_print_ln, .-__ayanami_print_ln

# void __ayanami_print_int(int64_t n)   十进制（含负号；INT64_MIN 安全：无符号取幅值）
    .globl __ayanami_print_int
    .type  __ayanami_print_int, @function
__ayanami_print_int:
    subq $40, %rsp
    leaq 32(%rsp), %rsi           # 缓冲尾（向前写）
    movq %rdi, %rax
    xorl %r8d, %r8d               # 负号标记
    testq %rax, %rax
    jns 1f
    movl $1, %r8d
    negq %rax                     # 幅值（MIN 回绕为 0x8000000000000000，按无符号即 2^63 ✓）
1:  movq $10, %rcx
2:  xorl %edx, %edx
    divq %rcx                     # rax = 商, rdx = 余
    addb $48, %dl
    decq %rsi
    movb %dl, (%rsi)
    testq %rax, %rax
    jnz 2b
    testl %r8d, %r8d
    jz 3f
    decq %rsi
    movb $45, (%rsi)              # '-'
3:  leaq 32(%rsp), %rdx
    subq %rsi, %rdx               # 长度
    movq $1, %rax                 # write
    movq $1, %rdi                 # fd 1
    syscall
    addq $40, %rsp
    ret
    .size __ayanami_print_int, .-__ayanami_print_int

    .section .note.GNU-stack,"",@progbits
