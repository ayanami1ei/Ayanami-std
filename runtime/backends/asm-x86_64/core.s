# core.s — x86-64（System V ABI，Linux）运行时核心
#
# 试验分支 asm-x86：以手写汇编替换 runtime.c 的机器相关部分。
# 本文件：ABI 版本号、默认分配原语、计数分配（弱符号，可被用户强定义覆盖）。
#
# 约定：与 runtime/abi.h 一致；int64 返回值放 %rax；调用前 rsp 16 字节对齐。
# 与 C 侧同名实现互斥：C 运行时以 -DAYANAMI_ASM_PORT 编译时排除这些函数。

    .text

# int64_t __ayanami_runtime_abi(void)
    .globl __ayanami_runtime_abi
    .type  __ayanami_runtime_abi, @function
__ayanami_runtime_abi:
    movl $1, %eax                 # AYANAMI_RUNTIME_ABI = 1
    ret
    .size __ayanami_runtime_abi, .-__ayanami_runtime_abi

# void *__ayanami_default_alloc(size_t size)   默认分配原语（malloc）
    .globl __ayanami_default_alloc
    .type  __ayanami_default_alloc, @function
__ayanami_default_alloc:
    subq $8, %rsp                 # 入口 rsp ≡ 8 (mod 16)，调用前对齐
    call malloc@PLT
    addq $8, %rsp
    ret
    .size __ayanami_default_alloc, .-__ayanami_default_alloc

# void __ayanami_default_free(void *ptr)
    .globl __ayanami_default_free
    .type  __ayanami_default_free, @function
__ayanami_default_free:
    jmp free@PLT                  # 尾调用（free(NULL) 安全）
    .size __ayanami_default_free, .-__ayanami_default_free

# void *__ayanami_unique_alloc(size_t size)    弱符号：用户强定义可覆盖
    .weak __ayanami_unique_alloc
    .type __ayanami_unique_alloc, @function
__ayanami_unique_alloc:
    subq $8, %rsp
    call __ayanami_default_alloc
    addq $8, %rsp
    testq %rax, %rax
    je 1f
    incq live_allocs(%rip)
1:  ret
    .size __ayanami_unique_alloc, .-__ayanami_unique_alloc

# void __ayanami_unique_free(void *ptr)        弱符号：用户强定义可覆盖
    .weak __ayanami_unique_free
    .type __ayanami_unique_free, @function
__ayanami_unique_free:
    testq %rdi, %rdi
    je 1f
    decq live_allocs(%rip)
    jmp __ayanami_default_free
1:  ret
    .size __ayanami_unique_free, .-__ayanami_unique_free

# void *__ayanami_counted_alloc(size_t size)   计数分配（std 入口）
    .globl __ayanami_counted_alloc
    .type  __ayanami_counted_alloc, @function
__ayanami_counted_alloc:
    jmp __ayanami_unique_alloc
    .size __ayanami_counted_alloc, .-__ayanami_counted_alloc

# void __ayanami_counted_free(void *ptr)       计数释放（std 入口）
    .globl __ayanami_counted_free
    .type  __ayanami_counted_free, @function
__ayanami_counted_free:
    jmp __ayanami_unique_free
    .size __ayanami_counted_free, .-__ayanami_counted_free

# int64_t __ayanami_live_allocs(void)
    .globl __ayanami_live_allocs
    .type  __ayanami_live_allocs, @function
__ayanami_live_allocs:
    movq live_allocs(%rip), %rax
    ret
    .size __ayanami_live_allocs, .-__ayanami_live_allocs

    .bss
    .align 8
    .type live_allocs, @object
    .size live_allocs, 8
live_allocs:
    .quad 0

    .section .note.GNU-stack,"",@progbits
