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

    .section .rodata
sh_path:
    .asciz "/bin/sh"
sh_dash_c:
    .asciz "-c"
    .previous

    .section .note.GNU-stack,"",@progbits
