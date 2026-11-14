# process.s — 进程控制（x86-64 Linux，raw syscall）
#
#   void __ayanami_exit(int64_t code)   立即退出进程（exit_group，不返回）
#   int64_t __ayanami_process_id(void)         getpid
#   int64_t __ayanami_parent_process_id(void)  getppid
#   int64_t __ayanami_process_run(str_view)    /bin/sh -c；退出码 / 128+sig / -1
#
# 系统调用：exit_group=231 getpid=39 getppid=110 fork=57 execve=59 wait4=61

    .text

    .globl __ayanami_exit
    .type  __ayanami_exit, @function
__ayanami_exit:
    movq $231, %rax
    syscall
    hlt
    .size __ayanami_exit, .-__ayanami_exit

# int64_t __ayanami_process_id(void)
    .globl __ayanami_process_id
    .type  __ayanami_process_id, @function
__ayanami_process_id:
    movq $39, %rax
    syscall
    ret
    .size __ayanami_process_id, .-__ayanami_process_id

# int64_t __ayanami_parent_process_id(void)
    .globl __ayanami_parent_process_id
    .type  __ayanami_parent_process_id, @function
__ayanami_parent_process_id:
    movq $110, %rax
    syscall
    ret
    .size __ayanami_parent_process_id, .-__ayanami_parent_process_id

# int64_t __ayanami_process_run(str_view command)   fork + execve(/bin/sh -c) + wait4
    .globl __ayanami_process_run
    .type  __ayanami_process_run, @function
__ayanami_process_run:
    pushq %rbx
    pushq %r12
    subq $4136, %rsp              # [0,4096) cmd cstr + [4096,4136) argv/status
    leaq 0(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 9f
    movq $57, %rax                # fork
    syscall
    testq %rax, %rax
    js 9f
    jz 1f
    movq %rax, %rbx               # pid
2:  movq $61, %rax                # wait4(pid, &status, 0, NULL)
    movq %rbx, %rdi
    leaq 4096(%rsp), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    cmpq $-4, %rax                # EINTR
    je 2b
    testq %rax, %rax
    js 9f
    movl 4096(%rsp), %eax         # wait status
    movl %eax, %ecx
    andl $0x7f, %ecx
    testl %ecx, %ecx
    jne 3f
    shrl $8, %eax                 # WEXITSTATUS
    andl $0xff, %eax
    jmp 8f
3:  movl %eax, %ecx
    andl $0x7f, %ecx              # signal
    addl $128, %ecx               # 128 + sig
    movl %ecx, %eax
    jmp 8f
1:  # child: argv = {"/bin/sh", "-c", cmd, NULL}
    leaq sh_path(%rip), %rax
    movq %rax, 4096(%rsp)
    leaq sh_dash_c(%rip), %rax
    movq %rax, 4104(%rsp)
    movq %rsp, %rax
    movq %rax, 4112(%rsp)
    movq $0, 4120(%rsp)
    movq $59, %rax                # execve
    leaq sh_path(%rip), %rdi
    leaq 4096(%rsp), %rsi
    movq environ@GOTPCREL(%rip), %rdx
    movq (%rdx), %rdx
    syscall
    movq $231, %rax               # exec 失败 → _exit(127)
    movq $127, %rdi
    syscall
    hlt
8:  addq $4136, %rsp
    popq %r12
    popq %rbx
    ret
9:  movq $-1, %rax
    addq $4136, %rsp
    popq %r12
    popq %rbx
    ret
    .size __ayanami_process_run, .-__ayanami_process_run

# char *__ayanami_process_output(str_view command)   /bin/sh -c，捕获 stdout
# 返回 unique_alloc(NUL 结尾)；失败 NULL
# 系统调用：pipe=22 fork=57 execve=59 wait4=61 read=0 close=3 dup2=33
    .globl __ayanami_process_output
    .type  __ayanami_process_output, @function
__ayanami_process_output:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    subq $4160, %rsp
    # [0,4096) cmd cstr | [4096,4104) pipefd | [4104,4112) status
    # [4112,4144) argv | [4144,4152) ncap | [4152,4160) old buf
    leaq 0(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 9f
    movq $22, %rax                # pipe
    leaq 4096(%rsp), %rdi
    syscall
    testq %rax, %rax
    js 9f
    movq $57, %rax                # fork
    syscall
    testq %rax, %rax
    js 8f
    jz 1f
    movq %rax, %rbx               # pid
    movl 4100(%rsp), %edi         # close write end
    movq $3, %rax
    syscall
    movl 4096(%rsp), %r12d        # read fd
    movq $4096, %r14              # cap
    movq $4096, %rdi
    call __ayanami_unique_alloc
    testq %rax, %rax
    jz 7f
    movq %rax, %r13               # buf
    xorl %r15d, %r15d             # off
2:  movq %r14, %rdx
    subq %r15, %rdx
    decq %rdx                     # cap - off - 1
    testq %rdx, %rdx
    jle 4f
    movq $0, %rax                 # read
    movq %r12, %rdi
    leaq (%r13,%r15), %rsi
    syscall
    cmpq $-4, %rax                # EINTR
    je 2b
    testq %rax, %rax
    js 6f
    jz 3f                         # EOF
    addq %rax, %r15
    movq %r14, %rax
    subq %r15, %rax
    cmpq $4096, %rax
    jae 2b
4:  movq %r14, %rax               # grow
    shlq $1, %rax
    movq %rax, 4144(%rsp)         # ncap
    movq %r13, 4152(%rsp)         # old buf
    movq %rax, %rdi
    call __ayanami_unique_alloc
    testq %rax, %rax
    jz 5f
    movq %rax, %rdi
    movq %r13, %rsi
    movq %r15, %rcx
    rep movsb
    movq %rax, %r13
    movq 4144(%rsp), %r14
    movq 4152(%rsp), %rdi
    call __ayanami_unique_free
    jmp 2b
5:  movq %r13, %rdi               # grow fail
    call __ayanami_unique_free
    jmp 7f
6:  movq %r13, %rdi               # read error
    call __ayanami_unique_free
    jmp 7f
3:  movb $0, (%r13,%r15)          # NUL 结尾
    movq %r12, %rdi
    movq $3, %rax
    syscall
10: movq $61, %rax                # wait4(pid, &status, 0, NULL)
    movq %rbx, %rdi
    leaq 4104(%rsp), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    cmpq $-4, %rax
    je 10b
    movq %r13, %rax
    jmp 11f
7:  movq %r12, %rdi               # failure：close + wait，返回 NULL
    movq $3, %rax
    syscall
    movq $61, %rax
    movq %rbx, %rdi
    leaq 4104(%rsp), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    xorl %eax, %eax
    jmp 11f
8:  movl 4096(%rsp), %edi         # fork fail：close 两端
    movq $3, %rax
    syscall
    movl 4100(%rsp), %edi
    movq $3, %rax
    syscall
9:  xorl %eax, %eax
11: addq $4160, %rsp
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
1:  movl 4096(%rsp), %edi         # child：close read，dup2(write, 1)
    movq $3, %rax
    syscall
    movl 4100(%rsp), %edi
    movq $33, %rax
    movq $1, %rsi
    syscall
    movl 4100(%rsp), %edi
    movq $3, %rax
    syscall
    leaq sh_path(%rip), %rax      # argv = {"/bin/sh", "-c", cmd, NULL}
    movq %rax, 4112(%rsp)
    leaq sh_dash_c(%rip), %rax
    movq %rax, 4120(%rsp)
    leaq 0(%rsp), %rax
    movq %rax, 4128(%rsp)
    movq $0, 4136(%rsp)
    movq $59, %rax                # execve
    leaq sh_path(%rip), %rdi
    leaq 4112(%rsp), %rsi
    movq environ@GOTPCREL(%rip), %rdx
    movq (%rdx), %rdx
    syscall
    movq $231, %rax               # exec 失败 → _exit(127)
    movq $127, %rdi
    syscall
    hlt
    .size __ayanami_process_output, .-__ayanami_process_output

    .section .rodata
sh_path:
    .asciz "/bin/sh"
sh_dash_c:
    .asciz "-c"
    .previous

    .section .note.GNU-stack,"",@progbits
