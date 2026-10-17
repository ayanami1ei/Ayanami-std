# arith.s — x86-64 显式溢出算术（std core/num.aya 的运行时助手）
#
# wrapping_*：无检查回绕（不影响标志位的形态）
# *_overflow：由 OF 标志取溢出位
# saturating_*：溢出取边界值（add/sub: a>0 → MAX 否则 MIN；mul: 符号异或判定方向）

    .text

# int64_t __ayanami_wrapping_add(int64_t a, int64_t b)
    .globl __ayanami_wrapping_add
    .type  __ayanami_wrapping_add, @function
__ayanami_wrapping_add:
    leaq (%rdi,%rsi), %rax        # lea 不写标志位，天然回绕
    ret
    .size __ayanami_wrapping_add, .-__ayanami_wrapping_add

# int64_t __ayanami_wrapping_sub(int64_t a, int64_t b)
    .globl __ayanami_wrapping_sub
    .type  __ayanami_wrapping_sub, @function
__ayanami_wrapping_sub:
    movq %rdi, %rax
    subq %rsi, %rax
    ret
    .size __ayanami_wrapping_sub, .-__ayanami_wrapping_sub

# int64_t __ayanami_wrapping_mul(int64_t a, int64_t b)
    .globl __ayanami_wrapping_mul
    .type  __ayanami_wrapping_mul, @function
__ayanami_wrapping_mul:
    movq %rdi, %rax
    imulq %rsi, %rax              # 双操作数 imul：低 64 位回绕
    ret
    .size __ayanami_wrapping_mul, .-__ayanami_wrapping_mul

# int64_t __ayanami_wrapping_neg(int64_t a)
    .globl __ayanami_wrapping_neg
    .type  __ayanami_wrapping_neg, @function
__ayanami_wrapping_neg:
    xorl %eax, %eax
    subq %rdi, %rax
    ret
    .size __ayanami_wrapping_neg, .-__ayanami_wrapping_neg

# int64_t __ayanami_add_overflow(int64_t a, int64_t b)
    .globl __ayanami_add_overflow
    .type  __ayanami_add_overflow, @function
__ayanami_add_overflow:
    addq %rsi, %rdi               # 设置 OF
    seto %al
    movzbl %al, %eax
    ret
    .size __ayanami_add_overflow, .-__ayanami_add_overflow

# int64_t __ayanami_sub_overflow(int64_t a, int64_t b)
    .globl __ayanami_sub_overflow
    .type  __ayanami_sub_overflow, @function
__ayanami_sub_overflow:
    subq %rsi, %rdi
    seto %al
    movzbl %al, %eax
    ret
    .size __ayanami_sub_overflow, .-__ayanami_sub_overflow

# int64_t __ayanami_mul_overflow(int64_t a, int64_t b)
    .globl __ayanami_mul_overflow
    .type  __ayanami_mul_overflow, @function
__ayanami_mul_overflow:
    imulq %rsi, %rdi              # 有符号溢出 → OF=1
    seto %al
    movzbl %al, %eax
    ret
    .size __ayanami_mul_overflow, .-__ayanami_mul_overflow

# int64_t __ayanami_saturating_add(int64_t a, int64_t b)
    .globl __ayanami_saturating_add
    .type  __ayanami_saturating_add, @function
__ayanami_saturating_add:
    movq %rdi, %rax
    addq %rsi, %rax
    jno 1f
    movabsq $0x7fffffffffffffff, %rax
    testq %rdi, %rdi              # a > 0 → 正溢出（MAX），否则 MIN
    jg 1f
    movabsq $0x8000000000000000, %rax
1:  ret
    .size __ayanami_saturating_add, .-__ayanami_saturating_add

# int64_t __ayanami_saturating_sub(int64_t a, int64_t b)
    .globl __ayanami_saturating_sub
    .type  __ayanami_saturating_sub, @function
__ayanami_saturating_sub:
    movq %rdi, %rax
    subq %rsi, %rax
    jno 1f
    movabsq $0x7fffffffffffffff, %rax
    testq %rdi, %rdi
    jg 1f
    movabsq $0x8000000000000000, %rax
1:  ret
    .size __ayanami_saturating_sub, .-__ayanami_saturating_sub

# int64_t __ayanami_saturating_mul(int64_t a, int64_t b)
    .globl __ayanami_saturating_mul
    .type  __ayanami_saturating_mul, @function
__ayanami_saturating_mul:
    movq %rdi, %rax
    imulq %rsi, %rax
    jno 1f
    movq %rdi, %rcx
    xorq %rsi, %rcx               # 符号位 = sign(a) xor sign(b)
    js 2f
    movabsq $0x7fffffffffffffff, %rax
    ret
2:  movabsq $0x8000000000000000, %rax
1:  ret
    .size __ayanami_saturating_mul, .-__ayanami_saturating_mul

    .section .note.GNU-stack,"",@progbits
