# process.s — 进程控制（x86-64 Linux，raw syscall）
#
#   void __ayanami_exit(int64_t code)   立即退出进程（exit_group，不返回）
#
# 系统调用：exit_group=231

    .text

    .globl __ayanami_exit
    .type  __ayanami_exit, @function
__ayanami_exit:
    movq $231, %rax
    syscall
    hlt
    .size __ayanami_exit, .-__ayanami_exit

    .section .note.GNU-stack,"",@progbits
