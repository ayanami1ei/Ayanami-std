# panic.s — 运行时 panic / 契约失败 / 溢出检查助手（x86-64 Linux，无 libc 格式化）
#
# 与 runtime.c 的 C 实现同 ABI（纯文本输出；C 版 TTY 彩色未实现）：
#   void __ayanami_panic_print_msg(line, col, file*, file_len, msg*, msg_len)  退出码 101
#   void __ayanami_panic_at(line, col, file_view, msg_view)
#   void __ayanami_panic_bounds_at(line, col, file_view, index, len)
#   void __ayanami_require_fail / ensure_fail / invariant_fail(line, col)      abort
#   T    __ayanami_ovf_{add,sub,mul}_{i8,i16,i32,i64,u8,u16,u32,u64}(a,b,line,col,file_view)
#   void __ayanami_diag_emit(level, diag_buf)   弱符号空实现
#
# 溢出助手寄存器：rdi=a rsi=b rdx=line rcx=col r8=file.data r9=file.len
# 系统调用：write=1 exit_group=231

    .text

# ── 内部：stderr 写（rdi=ptr, rsi=len）──
    .type panic_stderr_write, @function
panic_stderr_write:
    testq %rsi, %rsi
    jle 1f
    movq %rsi, %rdx
    movq %rdi, %rsi
    movq $2, %rdi
    movq $1, %rax
    syscall
1:  ret
    .size panic_stderr_write, .-panic_stderr_write

# ── 内部：u64 十进制（rdi=value, rsi=buf_end）→ rax=起始 ──
    .type panic_dec_u64, @function
panic_dec_u64:
    movq %rsi, %r8
    movq $10, %rcx
1:  xorl %edx, %edx
    movq %rdi, %rax
    divq %rcx
    movq %rax, %rdi
    addb $48, %dl
    decq %r8
    movb %dl, (%r8)
    testq %rdi, %rdi
    jnz 1b
    movq %r8, %rax
    ret
    .size panic_dec_u64, .-panic_dec_u64

# ── 内部：NUL 串拷贝（rdi=dst, rsi=src）→ rax=dst_end ──
    .type panic_copy_str, @function
panic_copy_str:
    movq %rdi, %rax
1:  movb (%rsi), %dl
    testb %dl, %dl
    je 2f
    movb %dl, (%rax)
    incq %rax
    incq %rsi
    jmp 1b
2:  ret
    .size panic_copy_str, .-panic_copy_str

# ── 内部：n 字节拷贝（rdi=dst, rsi=src, rdx=n）→ rax=dst_end ──
    .type panic_copy_n, @function
panic_copy_n:
    movq %rdi, %rax
    movq %rdx, %rcx
    rep movsb
    addq %rdx, %rax
    ret
    .size panic_copy_n, .-panic_copy_n

# ── 内部：":<line>:<col>\n"（rdi=line, rsi=col）──
    .type panic_write_loc, @function
panic_write_loc:
    pushq %rbx
    subq $8, %rsp
    movq %rdi, %rbx
    movb $58, (%rsp)
    movq %rsp, %rdi
    movq $1, %rsi
    call panic_stderr_write
    movq %rbx, %rdi
    call panic_write_pair
    addq $8, %rsp
    popq %rbx
    ret
    .size panic_write_loc, .-panic_write_loc

# ── 内部："<line>:<col>\n"（rdi=line, rsi=col）──
    .type panic_write_pair, @function
panic_write_pair:
    pushq %rbx
    pushq %r12
    subq $56, %rsp
    movq %rdi, %rbx
    movq %rsi, %r12
    leaq 48(%rsp), %rsi
    movq %rbx, %rdi
    call panic_dec_u64
    movq %rax, %rdi
    leaq 48(%rsp), %rsi
    subq %rax, %rsi
    call panic_stderr_write
    movb $58, (%rsp)
    movq %rsp, %rdi
    movq $1, %rsi
    call panic_stderr_write
    leaq 48(%rsp), %rsi
    movq %r12, %rdi
    call panic_dec_u64
    movq %rax, %rdi
    leaq 48(%rsp), %rsi
    subq %rax, %rsi
    call panic_stderr_write
    movb $10, (%rsp)
    movq %rsp, %rdi
    movq $1, %rsi
    call panic_stderr_write
    addq $56, %rsp
    popq %r12
    popq %rbx
    ret
    .size panic_write_pair, .-panic_write_pair

# void __ayanami_panic_print_msg(line, col, file*, file_len, msg*, msg_len)
    .globl __ayanami_panic_print_msg
    .type  __ayanami_panic_print_msg, @function
__ayanami_panic_print_msg:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    subq $16, %rsp
    movq %rdi, %rbx
    movq %rsi, %r12
    movq %rdx, %r13
    movq %rcx, %r14
    movq %r8, %r15
    movq %r9, (%rsp)
    leaq panic_head(%rip), %rdi
    movq $26, %rsi                # "thread 'main' panicked at "
    call panic_stderr_write
    testq %rbx, %rbx
    jle .Lppm_noloc
    testq %r13, %r13
    je .Lppm_noloc
    testq %r14, %r14
    jle .Lppm_noloc
    movq %r14, %rsi
    cmpq $1000, %rsi
    jle 1f
    movq $1000, %rsi
1:  movq %r13, %rdi
    call panic_stderr_write
    movq %rbx, %rdi
    movq %r12, %rsi
    call panic_write_loc
    jmp .Lppm_msg
.Lppm_noloc:
    leaq panic_nl(%rip), %rdi
    movq $2, %rsi                 # ":\n"
    call panic_stderr_write
.Lppm_msg:
    movq %r15, %rdi
    movq (%rsp), %rsi
    call panic_stderr_write
    movb $10, 8(%rsp)
    leaq 8(%rsp), %rdi
    movq $1, %rsi
    call panic_stderr_write
    movq $231, %rax               # exit_group(101)
    movq $101, %rdi
    syscall
    hlt
    .size __ayanami_panic_print_msg, .-__ayanami_panic_print_msg

# void __ayanami_panic_at(line, col, file_view, msg_view)
    .globl __ayanami_panic_at
    .type  __ayanami_panic_at, @function
__ayanami_panic_at:
    jmp __ayanami_panic_print_msg
    .size __ayanami_panic_at, .-__ayanami_panic_at

# void __ayanami_panic_bounds_at(line, col, file_view, index, len)
    .globl __ayanami_panic_bounds_at
    .type  __ayanami_panic_bounds_at, @function
__ayanami_panic_bounds_at:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    subq $296, %rsp               # [rsp]=len [rsp+8]=index；消息 [rsp+16, 272)；数字区到 [rsp+272]
    movq %rdi, %rbx
    movq %rsi, %r12
    movq %rdx, %r13
    movq %rcx, %r14
    movq %r8, 8(%rsp)
    movq %r9, (%rsp)
    leaq 16(%rsp), %r15           # dst 游标
    movq %r15, %rdi
    leaq bounds_prefix(%rip), %rsi
    call panic_copy_str
    movq %rax, %r15
    leaq 272(%rsp), %rsi
    movq (%rsp), %rdi
    call panic_dec_u64
    movq %r15, %rdi
    movq %rax, %rsi
    leaq 272(%rsp), %rdx
    subq %rax, %rdx
    call panic_copy_n
    movq %rax, %r15
    movq %r15, %rdi
    leaq bounds_mid(%rip), %rsi
    call panic_copy_str
    movq %rax, %r15
    leaq 272(%rsp), %rsi
    movq 8(%rsp), %rdi
    call panic_dec_u64
    movq %r15, %rdi
    movq %rax, %rsi
    leaq 272(%rsp), %rdx
    subq %rax, %rdx
    call panic_copy_n
    movq %rax, %r15
    movq %rbx, %rdi
    movq %r12, %rsi
    movq %r13, %rdx
    movq %r14, %rcx
    leaq 16(%rsp), %r8
    movq %r15, %r9
    subq %r8, %r9                 # msglen
    call __ayanami_panic_print_msg
    hlt
    .size __ayanami_panic_bounds_at, .-__ayanami_panic_bounds_at

# ── 契约失败 ──
    .type contract_fail, @function
contract_fail:
    # rdi=文本指针, rsi=文本长度, rdx=line, rcx=col
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    subq $8, %rsp
    movq %rdx, %rbx
    movq %rcx, %r12
    call panic_stderr_write
    leaq cf_at(%rip), %rdi
    movq $4, %rsi                 # " at "
    call panic_stderr_write
    movq %rbx, %rdi
    movq %r12, %rsi
    call panic_write_pair
    call abort@PLT
    hlt
    .size contract_fail, .-contract_fail

    .globl __ayanami_require_fail
    .type  __ayanami_require_fail, @function
__ayanami_require_fail:
    movq %rdi, %rdx
    movq %rsi, %rcx
    leaq cf_require(%rip), %rdi
    movq $15, %rsi
    jmp contract_fail
    .size __ayanami_require_fail, .-__ayanami_require_fail

    .globl __ayanami_ensure_fail
    .type  __ayanami_ensure_fail, @function
__ayanami_ensure_fail:
    movq %rdi, %rdx
    movq %rsi, %rcx
    leaq cf_ensure(%rip), %rdi
    movq $14, %rsi
    jmp contract_fail
    .size __ayanami_ensure_fail, .-__ayanami_ensure_fail

    .globl __ayanami_invariant_fail
    .type  __ayanami_invariant_fail, @function
__ayanami_invariant_fail:
    movq %rdi, %rdx
    movq %rsi, %rcx
    leaq cf_invariant(%rip), %rdi
    movq $17, %rsi
    jmp contract_fail
    .size __ayanami_invariant_fail, .-__ayanami_invariant_fail

# ── 溢出检查助手（≤64 位；i128/u128 暂留 C） ──
#
# 宏：PROLOG 保存寄存器；OK 路径 free(file.data) 后返回 %r15；PANIC 路径输出消息并退出。

.macro OVF_PROLOG name
    .globl __ayanami_ovf_\name
    .type  __ayanami_ovf_\name, @function
__ayanami_ovf_\name:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq %rdx, %rbx               # line
    movq %rcx, %r12               # col
    movq %r8, %r13                # file.data
    movq %r9, %r14                # file.len
.endm

.macro OVF_TAIL name, msg, msglen
    jmp .Lovf_ok_\name
.Lovf_panic_\name:
    movq %rbx, %rdi
    movq %r12, %rsi
    movq %r13, %rdx
    movq %r14, %rcx
    leaq \msg(%rip), %r8
    movq $\msglen, %r9
    call __ayanami_panic_print_msg
    hlt
.Lovf_ok_\name:
    movq %r13, %rdi
    call __ayanami_unique_free
    movq %r15, %rax
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
    .size __ayanami_ovf_\name, .-__ayanami_ovf_\name
.endm

# add：窄位宽（8/16/32）先扩展再范围检查；64 位用 OF/CF
    OVF_PROLOG add_i8
    movsbq %dil, %rax
    movsbq %sil, %rcx
    addq %rcx, %rax
    cmpq $-128, %rax
    jl .Lovf_panic_add_i8
    cmpq $127, %rax
    jg .Lovf_panic_add_i8
    movq %rax, %r15
    OVF_TAIL add_i8, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_i16
    movswq %di, %rax
    movswq %si, %rcx
    addq %rcx, %rax
    cmpq $-32768, %rax
    jl .Lovf_panic_add_i16
    cmpq $32767, %rax
    jg .Lovf_panic_add_i16
    movq %rax, %r15
    OVF_TAIL add_i16, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_i32
    movslq %edi, %rax
    movslq %esi, %rcx
    addq %rcx, %rax
    movslq %eax, %rcx
    cmpq %rcx, %rax
    jne .Lovf_panic_add_i32
    movq %rax, %r15
    OVF_TAIL add_i32, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_i64
    movq %rdi, %rax
    addq %rsi, %rax
    jo .Lovf_panic_add_i64
    movq %rax, %r15
    OVF_TAIL add_i64, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_u8
    movzbq %dil, %rax
    movzbq %sil, %rcx
    addq %rcx, %rax
    cmpq $255, %rax
    ja .Lovf_panic_add_u8
    movq %rax, %r15
    OVF_TAIL add_u8, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_u16
    movzwq %di, %rax
    movzwq %si, %rcx
    addq %rcx, %rax
    cmpq $65535, %rax
    ja .Lovf_panic_add_u16
    movq %rax, %r15
    OVF_TAIL add_u16, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_u32
    movl %edi, %eax
    movl %esi, %ecx
    addq %rcx, %rax
    movq %rax, %rcx
    shrq $32, %rcx
    jnz .Lovf_panic_add_u32
    movq %rax, %r15
    OVF_TAIL add_u32, msg_ovf_add, msg_ovf_add_len

    OVF_PROLOG add_u64
    movq %rdi, %rax
    addq %rsi, %rax
    jc .Lovf_panic_add_u64
    movq %rax, %r15
    OVF_TAIL add_u64, msg_ovf_add, msg_ovf_add_len

# sub
    OVF_PROLOG sub_i8
    movsbq %dil, %rax
    movsbq %sil, %rcx
    subq %rcx, %rax
    cmpq $-128, %rax
    jl .Lovf_panic_sub_i8
    cmpq $127, %rax
    jg .Lovf_panic_sub_i8
    movq %rax, %r15
    OVF_TAIL sub_i8, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_i16
    movswq %di, %rax
    movswq %si, %rcx
    subq %rcx, %rax
    cmpq $-32768, %rax
    jl .Lovf_panic_sub_i16
    cmpq $32767, %rax
    jg .Lovf_panic_sub_i16
    movq %rax, %r15
    OVF_TAIL sub_i16, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_i32
    movslq %edi, %rax
    movslq %esi, %rcx
    subq %rcx, %rax
    movslq %eax, %rcx
    cmpq %rcx, %rax
    jne .Lovf_panic_sub_i32
    movq %rax, %r15
    OVF_TAIL sub_i32, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_i64
    movq %rdi, %rax
    subq %rsi, %rax
    jo .Lovf_panic_sub_i64
    movq %rax, %r15
    OVF_TAIL sub_i64, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_u8
    movzbq %dil, %rax
    movzbq %sil, %rcx
    subq %rcx, %rax
    js .Lovf_panic_sub_u8
    movq %rax, %r15
    OVF_TAIL sub_u8, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_u16
    movzwq %di, %rax
    movzwq %si, %rcx
    subq %rcx, %rax
    js .Lovf_panic_sub_u16
    movq %rax, %r15
    OVF_TAIL sub_u16, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_u32
    movl %edi, %eax
    movl %esi, %ecx
    subq %rcx, %rax
    js .Lovf_panic_sub_u32
    movq %rax, %r15
    OVF_TAIL sub_u32, msg_ovf_sub, msg_ovf_sub_len

    OVF_PROLOG sub_u64
    movq %rdi, %rax
    subq %rsi, %rax
    jc .Lovf_panic_sub_u64
    movq %rax, %r15
    OVF_TAIL sub_u64, msg_ovf_sub, msg_ovf_sub_len

# mul
    OVF_PROLOG mul_i8
    movsbq %dil, %rax
    movsbq %sil, %rcx
    imulq %rcx, %rax
    cmpq $-128, %rax
    jl .Lovf_panic_mul_i8
    cmpq $127, %rax
    jg .Lovf_panic_mul_i8
    movq %rax, %r15
    OVF_TAIL mul_i8, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_i16
    movswq %di, %rax
    movswq %si, %rcx
    imulq %rcx, %rax
    cmpq $-32768, %rax
    jl .Lovf_panic_mul_i16
    cmpq $32767, %rax
    jg .Lovf_panic_mul_i16
    movq %rax, %r15
    OVF_TAIL mul_i16, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_i32
    movslq %edi, %rax
    movslq %esi, %rcx
    imulq %rcx, %rax
    movslq %eax, %rcx
    cmpq %rcx, %rax
    jne .Lovf_panic_mul_i32
    movq %rax, %r15
    OVF_TAIL mul_i32, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_i64
    movq %rdi, %rax
    imulq %rsi, %rax
    jo .Lovf_panic_mul_i64
    movq %rax, %r15
    OVF_TAIL mul_i64, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_u8
    movzbq %dil, %rax
    movzbq %sil, %rcx
    imulq %rcx, %rax
    cmpq $255, %rax
    ja .Lovf_panic_mul_u8
    movq %rax, %r15
    OVF_TAIL mul_u8, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_u16
    movzwq %di, %rax
    movzwq %si, %rcx
    imulq %rcx, %rax
    cmpq $65535, %rax
    ja .Lovf_panic_mul_u16
    movq %rax, %r15
    OVF_TAIL mul_u16, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_u32
    movl %edi, %eax
    movl %esi, %ecx
    imulq %rcx, %rax
    movq %rax, %rcx
    shrq $32, %rcx
    jnz .Lovf_panic_mul_u32
    movq %rax, %r15
    OVF_TAIL mul_u32, msg_ovf_mul, msg_ovf_mul_len

    OVF_PROLOG mul_u64
    movq %rdi, %rax
    mulq %rsi
    testq %rdx, %rdx
    jnz .Lovf_panic_mul_u64
    movq %rax, %r15
    OVF_TAIL mul_u64, msg_ovf_mul, msg_ovf_mul_len

# ── 诊断通道弱符号（可执行文件中为 no-op；插件 shim 提供强定义） ──
    .weak __ayanami_diag_emit
    .type __ayanami_diag_emit, @function
__ayanami_diag_emit:
    ret
    .size __ayanami_diag_emit, .-__ayanami_diag_emit

    .section .rodata
panic_head:
    .ascii "thread 'main' panicked at "
panic_nl:
    .ascii ":\n"
bounds_prefix:
    .asciz "index out of bounds: the len is "
bounds_mid:
    .asciz " but the index is "
cf_require:
    .ascii "requires failed"
cf_ensure:
    .ascii "ensures failed"
cf_invariant:
    .ascii "invariant failed"
cf_at:
    .ascii " at "
msg_ovf_add:
    .ascii "attempt to add with overflow"
msg_ovf_sub:
    .ascii "attempt to subtract with overflow"
msg_ovf_mul:
    .ascii "attempt to multiply with overflow"
msg_ovf_add_len = . - msg_ovf_add
msg_ovf_sub_len = . - msg_ovf_sub
msg_ovf_mul_len = . - msg_ovf_mul

    .section .note.GNU-stack,"",@progbits
