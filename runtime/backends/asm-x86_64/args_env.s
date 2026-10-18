# args_env.s — 命令行参数与环境变量（x86-64 Linux，无 libc 文件 API）
#
# 与 runtime/sys.c 的 C 实现同 ABI：
#   int64_t __ayanami_arg_count(void)        参数个数（含程序名）
#   int64_t __ayanami_arg_len(int64_t i)     第 i 个参数长度；越界 -1
#   char   *__ayanami_arg_data(int64_t i)    第 i 个参数副本（unique_alloc；越界 NULL）
#   int64_t __ayanami_env_len(str_view name)  环境变量值长度；无 -1
#   char   *__ayanami_env_data(str_view name) 环境变量值副本（unique_alloc；无 NULL）
#
# 参数来源：/proc/self/cmdline（NUL 分隔，惰性加载一次）。
# 环境变量：libc 的 environ（GOT 相对访问）。
#
# 系统调用号：read=0 close=3 openat=257；AT_FDCWD=-100；O_RDONLY=0

    .text

# ── 惰性加载 /proc/self/cmdline ──
    .type load_args, @function
load_args:
    movq g_args_loaded(%rip), %rax
    testq %rax, %rax
    jne .Lload_ret
    movq $1, g_args_loaded(%rip)
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    subq $24, %rsp
    movq $257, %rax                # openat(AT_FDCWD, "/proc/self/cmdline", O_RDONLY)
    movq $-100, %rdi
    leaq cmdline_path(%rip), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js .Lload_done                 # 打开失败：无参数
    movq %rax, %rbx                # fd
    movq $4096, %rdi               # buf = malloc(4096)
    call malloc@PLT
    testq %rax, %rax
    je .Lload_close                # 分配失败
    movq %rax, %r12                # buf
    movq $4096, %r13               # cap
    xorl %r14d, %r14d              # len
.Lload_read:
    leaq 4096(%r14), %rax          # len + 4096 > cap ?
    cmpq %r13, %rax
    jle .Lload_read_go
    shlq $1, %r13                  # cap *= 2
    movq %r12, %rdi
    movq %r13, %rsi
    call realloc@PLT
    testq %rax, %rax
    je .Lload_parse                # realloc 失败：用已有内容
    movq %rax, %r12
    jmp .Lload_read
.Lload_read_go:
    xorl %eax, %eax                # read(fd, buf+len, 4096)
    movq %rbx, %rdi
    leaq (%r12,%r14), %rsi
    movq $4096, %rdx
    syscall
    testq %rax, %rax
    jle .Lload_parse
    addq %rax, %r14
    cmpq $4096, %rax
    jl .Lload_parse
    jmp .Lload_read
.Lload_parse:
    movq $3, %rax                  # close(fd)
    movq %rbx, %rdi
    syscall
    # count = buf 中的 NUL 个数
    xorl %r9d, %r9d
    xorl %ecx, %ecx
.Lload_count:
    cmpq %r14, %rcx
    jge .Lload_count_done
    cmpb $0, (%r12,%rcx)
    jne .Lload_count_next
    incq %r9
.Lload_count_next:
    incq %rcx
    jmp .Lload_count
.Lload_count_done:
    testq %r9, %r9
    je .Lload_free                 # 无 NUL → 无参数
    movq %r9, (%rsp)               # 暂存 count（帧内槽，保持对齐）
    leaq 0(,%r9,8), %rdi           # g_args = malloc(count * 8)
    call malloc@PLT
    movq (%rsp), %r9
    testq %rax, %rax
    je .Lload_free
    movq %rax, g_args(%rip)
    xorl %r8d, %r8d                # argc
    xorl %ecx, %ecx                # i
    xorl %edx, %edx                # start
.Lload_fill:
    cmpq %r14, %rcx
    jge .Lload_store
    cmpb $0, (%r12,%rcx)
    jne .Lload_fill_next
    leaq (%r12,%rdx), %rax         # g_args[argc++] = buf + start
    movq g_args(%rip), %rsi
    movq %rax, (%rsi,%r8,8)
    incq %r8
    leaq 1(%rcx), %rdx             # start = i + 1
.Lload_fill_next:
    incq %rcx
    jmp .Lload_fill
.Lload_store:
    movq %r8, g_argc(%rip)
    jmp .Lload_done
.Lload_free:
    movq %r12, %rdi
    call free@PLT
    jmp .Lload_done
.Lload_close:
    movq $3, %rax
    movq %rbx, %rdi
    syscall
.Lload_done:
    addq $24, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
.Lload_ret:
    ret
    .size load_args, .-load_args

# int64_t __ayanami_arg_count(void)
    .globl __ayanami_arg_count
    .type  __ayanami_arg_count, @function
__ayanami_arg_count:
    subq $8, %rsp
    call load_args
    addq $8, %rsp
    movq g_argc(%rip), %rax
    ret
    .size __ayanami_arg_count, .-__ayanami_arg_count

# int64_t __ayanami_arg_len(int64_t i)
    .globl __ayanami_arg_len
    .type  __ayanami_arg_len, @function
__ayanami_arg_len:
    pushq %rbx
    movq %rdi, %rbx
    call load_args
    testq %rbx, %rbx
    js .Larg_len_bad
    cmpq g_argc(%rip), %rbx
    jge .Larg_len_bad
    movq g_args(%rip), %rax
    movq (%rax,%rbx,8), %rdi       # 参数指针
    call __ayanami_cstr_len
    popq %rbx
    ret
.Larg_len_bad:
    movq $-1, %rax
    popq %rbx
    ret
    .size __ayanami_arg_len, .-__ayanami_arg_len

# char *__ayanami_arg_data(int64_t i)   副本（unique_alloc）
    .globl __ayanami_arg_data
    .type  __ayanami_arg_data, @function
__ayanami_arg_data:
    pushq %rbx
    pushq %r12
    subq $8, %rsp
    movq %rdi, %rbx
    call load_args
    testq %rbx, %rbx
    js .Larg_data_null
    cmpq g_argc(%rip), %rbx
    jge .Larg_data_null
    movq g_args(%rip), %rax
    movq (%rax,%rbx,8), %r12       # src
    movq %r12, %rdi
    call __ayanami_cstr_len
    movq %rax, %rbx                # n
    leaq 1(%rax), %rdi
    call __ayanami_unique_alloc
    testq %rax, %rax
    je .Larg_data_null
    movq %rax, %rdi                # dst
    movq %r12, %rsi                # src
    leaq 1(%rbx), %rcx             # n + 1（含 NUL）
    rep movsb
    addq $8, %rsp
    popq %r12
    popq %rbx
    ret
.Larg_data_null:
    xorl %eax, %eax
    addq $8, %rsp
    popq %r12
    popq %rbx
    ret
    .size __ayanami_arg_data, .-__ayanami_arg_data

# ── 环境变量（libc environ） ──

# static const char *env_find(rdi=key, rsi=klen) -> rax = 值指针 或 NULL
    .type env_find, @function
env_find:
    movq environ@GOTPCREL(%rip), %rax
    movq (%rax), %r8               # char **e
    testq %r8, %r8
    je .Lenv_none
.Lenv_next:
    movq (%r8), %r9                # *e
    testq %r9, %r9
    je .Lenv_none
    # 比较前 klen 字节
    xorl %ecx, %ecx
.Lenv_cmp:
    cmpq %rsi, %rcx
    jge .Lenv_eqcheck
    movzbl (%r9,%rcx), %eax
    movzbl (%rdi,%rcx), %edx
    cmpb %dl, %al
    jne .Lenv_skip
    incq %rcx
    jmp .Lenv_cmp
.Lenv_eqcheck:
    cmpb $61, (%r9,%rcx)           # '='
    jne .Lenv_skip
    leaq 1(%r9,%rcx), %rax         # 值指针
    ret
.Lenv_skip:
    addq $8, %r8
    jmp .Lenv_next
.Lenv_none:
    xorl %eax, %eax
    ret
    .size env_find, .-env_find

# int64_t __ayanami_env_len(str_view name)
    .globl __ayanami_env_len
    .type  __ayanami_env_len, @function
__ayanami_env_len:
    pushq %rbx
    pushq %r12
    movq %rdi, %rbx                # data
    movq %rsi, %r12                # len
    movq %rbx, %rdi
    movq %r12, %rsi
    subq $8, %rsp
    call __ayanami_cstr_len
    movq %rax, %rsi                # klen
    movq %rbx, %rdi
    call env_find
    testq %rax, %rax
    je .Lenv_len_bad
    movq %rax, %rdi
    call __ayanami_cstr_len
    addq $8, %rsp
    popq %r12
    popq %rbx
    ret
.Lenv_len_bad:
    movq $-1, %rax
    addq $8, %rsp
    popq %r12
    popq %rbx
    ret
    .size __ayanami_env_len, .-__ayanami_env_len

# char *__ayanami_env_data(str_view name)
    .globl __ayanami_env_data
    .type  __ayanami_env_data, @function
__ayanami_env_data:
    pushq %rbx
    pushq %r12
    movq %rdi, %rbx
    movq %rsi, %r12
    movq %rbx, %rdi
    movq %r12, %rsi
    subq $8, %rsp
    call __ayanami_cstr_len
    movq %rax, %rsi
    movq %rbx, %rdi
    call env_find
    testq %rax, %rax
    je .Lenv_data_null
    movq %rax, %rbx                # 值指针
    movq %rax, %rdi
    call __ayanami_cstr_len
    movq %rax, %r12                # n
    leaq 1(%rax), %rdi
    call __ayanami_unique_alloc
    testq %rax, %rax
    je .Lenv_data_null
    movq %rax, %rdi
    movq %rbx, %rsi
    leaq 1(%r12), %rcx
    rep movsb
    addq $8, %rsp
    popq %r12
    popq %rbx
    ret
.Lenv_data_null:
    xorl %eax, %eax
    addq $8, %rsp
    popq %r12
    popq %rbx
    ret
    .size __ayanami_env_data, .-__ayanami_env_data

    .bss
    .align 8
    .type g_args, @object
    .size g_args, 8
g_args:
    .quad 0
    .type g_argc, @object
    .size g_argc, 8
g_argc:
    .quad 0
    .type g_args_loaded, @object
    .size g_args_loaded, 8
g_args_loaded:
    .quad 0

    .section .rodata
cmdline_path:
    .asciz "/proc/self/cmdline"

    .section .note.GNU-stack,"",@progbits
