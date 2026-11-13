# process.s — 进程控制（x86-64 Linux，raw syscall）
#
#   void __ayanami_exit(int64_t code)   立即退出进程（exit_group，不返回）
#   int64_t __ayanami_process_id(void)         getpid
#   int64_t __ayanami_parent_process_id(void)  getppid
#
# 系统调用：exit_group=231 getpid=39 getppid=110

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

    .section .note.GNU-stack,"",@progbits
