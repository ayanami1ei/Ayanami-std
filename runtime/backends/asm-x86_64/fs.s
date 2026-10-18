# fs.s — 文件系统：元信息与简单操作（x86-64 Linux 系统调用，无 libc）
#
# 与 runtime/sys.c 的 C 实现同 ABI。失败约定：g_fs_errno = -syscall_ret，返回 -1 / NULL。
#
# 系统调用号：newfstatat=262 renameat=264 unlinkat=263 mkdirat=258
# AT_FDCWD=-100  AT_REMOVEDIR=0x200
# struct stat：st_mode=24(u32) st_size=48(i64) st_mtim.tv_sec=88(i64)
# S_IFMT=0xF000 S_IFREG=0x8000 S_IFDIR=0x4000 EINVAL=22

    .text

# int64_t __ayanami_fs_errno(void)
    .globl __ayanami_fs_errno
    .type  __ayanami_fs_errno, @function
__ayanami_fs_errno:
    movq g_fs_errno(%rip), %rax
    ret
    .size __ayanami_fs_errno, .-__ayanami_fs_errno

# int64_t __ayanami_fs_errno_kind(int64_t e)   errno → 稳定类别码（0..7）
    .globl __ayanami_fs_errno_kind
    .type  __ayanami_fs_errno_kind, @function
__ayanami_fs_errno_kind:
    leaq kind_table(%rip), %rsi
1:  movq (%rsi), %rax
    cmpq $-1, %rax
    je 3f
    cmpq %rdi, %rax
    je 2f
    addq $16, %rsi
    jmp 1b
2:  movq 8(%rsi), %rax
    ret
3:  movq $7, %rax
    ret
    .size __ayanami_fs_errno_kind, .-__ayanami_fs_errno_kind

# int64_t __ayanami_cstr_len(const char *s)
    .globl __ayanami_cstr_len
    .type  __ayanami_cstr_len, @function
__ayanami_cstr_len:
    xorl %eax, %eax
    testq %rdi, %rdi
    je 2f
1:  cmpb $0, (%rdi,%rax)
    je 2f
    incq %rax
    jmp 1b
2:  ret
    .size __ayanami_cstr_len, .-__ayanami_cstr_len

# char *__ayanami_fs_strerror(int64_t e)   unique_alloc 拷贝消息（NUL 结尾）
    .globl __ayanami_fs_strerror
    .type  __ayanami_fs_strerror, @function
__ayanami_fs_strerror:
    pushq %rbx
    pushq %r12
    pushq %r13
    # 查表
    leaq strerror_table(%rip), %rsi
1:  movq (%rsi), %rax
    cmpq $-1, %rax
    je 3f
    cmpq %rdi, %rax
    je 2f
    addq $16, %rsi
    jmp 1b
2:  movq 8(%rsi), %rbx           # 表内偏移
    leaq strerror_table(%rip), %rax
    addq %rax, %rbx                # → 消息地址
    jmp 4f
3:  leaq unknown_msg(%rip), %rbx
4:  xorl %r12d, %r12d              # len
5:  cmpb $0, (%rbx,%r12)
    je 6f
    incq %r12
    jmp 5b
6:  leaq 1(%r12), %rdi             # len + 1（含 NUL）
    call __ayanami_unique_alloc
    movq %rax, %r13
    testq %rax, %rax
    je 7f
    movq %rax, %rdi
    movq %rbx, %rsi
    leaq 1(%r12), %rcx
    rep movsb                      # 拷贝含 NUL
7:  movq %r13, %rax
    popq %r13
    popq %r12
    popq %rbx
    ret
    .size __ayanami_fs_strerror, .-__ayanami_fs_strerror

# int __ayanami_fs_path_cstr(rdi=data, rsi=len, rdx=out, rcx=cap)  跨文件复用
#   成功 1；失败 0（g_fs_errno = EINVAL）
    .globl __ayanami_fs_path_cstr
    .type  __ayanami_fs_path_cstr, @function
__ayanami_fs_path_cstr:
    cmpq $0, %rsi
    jle 2f
    cmpq %rcx, %rsi
    jge 2f
    movq %rsi, %r9
    movq %rdi, %rsi
    movq %rdx, %rdi
    movq %r9, %rcx
    rep movsb
    movb $0, (%rdi)
    movq $1, %rax
    ret
2:  movq $22, g_fs_errno(%rip)
    xorl %eax, %eax
    ret
    .size __ayanami_fs_path_cstr, .-__ayanami_fs_path_cstr

# int64_t __ayanami_fs_size(str_view path)   st_size；失败 -1
    .globl __ayanami_fs_size
    .type  __ayanami_fs_size, @function
__ayanami_fs_size:
    subq $4264, %rsp               # [rsp]=stat(144) [rsp+144]=path(4096)
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $262, %rax                # newfstatat(AT_FDCWD, path, &st, 0)
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    movq %rsp, %rdx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js 2f
    movq 48(%rsp), %rax            # st_size
    addq $4264, %rsp
    ret
2:  negq %rax
    movq %rax, g_fs_errno(%rip)
1:  movq $-1, %rax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_size, .-__ayanami_fs_size

# int64_t __ayanami_fs_mtime(str_view path)   st_mtim.tv_sec；失败 -1
    .globl __ayanami_fs_mtime
    .type  __ayanami_fs_mtime, @function
__ayanami_fs_mtime:
    subq $4264, %rsp
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $262, %rax
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    movq %rsp, %rdx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js 2f
    movq 88(%rsp), %rax            # st_mtim.tv_sec
    addq $4264, %rsp
    ret
2:  negq %rax
    movq %rax, g_fs_errno(%rip)
1:  movq $-1, %rax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_mtime, .-__ayanami_fs_mtime

# int64_t __ayanami_fs_is_file(str_view path)   1 普通文件 / 0（失败 0，不写 errno）
    .globl __ayanami_fs_is_file
    .type  __ayanami_fs_is_file, @function
__ayanami_fs_is_file:
    subq $4264, %rsp
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $262, %rax
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    movq %rsp, %rdx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js 1f
    movl 24(%rsp), %eax            # st_mode
    andl $0xF000, %eax
    cmpl $0x8000, %eax
    jne 1f
    movq $1, %rax
    addq $4264, %rsp
    ret
1:  xorl %eax, %eax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_is_file, .-__ayanami_fs_is_file

# int64_t __ayanami_fs_is_dir(str_view path)
    .globl __ayanami_fs_is_dir
    .type  __ayanami_fs_is_dir, @function
__ayanami_fs_is_dir:
    subq $4264, %rsp
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $262, %rax
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    movq %rsp, %rdx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js 1f
    movl 24(%rsp), %eax
    andl $0xF000, %eax
    cmpl $0x4000, %eax
    jne 1f
    movq $1, %rax
    addq $4264, %rsp
    ret
1:  xorl %eax, %eax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_is_dir, .-__ayanami_fs_is_dir

# int64_t __ayanami_fs_rename(str_view from, str_view to)
    .globl __ayanami_fs_rename
    .type  __ayanami_fs_rename, @function
__ayanami_fs_rename:
    pushq %rbx
    pushq %r12
    subq $8200, %rsp               # [rsp]=from(4096) [rsp+4096]=to(4096)（+8 对齐）
    movq %rdx, %rbx                # to.data（callee-saved）
    movq %rcx, %r12                # to.len
    leaq 4096(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr                 # from
    testl %eax, %eax
    je 1f
    movq %rbx, %rdi
    movq %r12, %rsi
    movq %rsp, %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr                 # to
    testl %eax, %eax
    je 1f
    movq $264, %rax                # renameat(AT_FDCWD, from, AT_FDCWD, to)
    movq $-100, %rdi
    leaq 4096(%rsp), %rsi          # from 在 [rsp+4096]
    movq $-100, %rdx
    movq %rsp, %r10                # to 在 [rsp]
    syscall
    testq %rax, %rax
    js 2f
    xorl %eax, %eax
    addq $8200, %rsp
    popq %r12
    popq %rbx
    ret
2:  negq %rax
    movq %rax, g_fs_errno(%rip)
1:  movq $-1, %rax
    addq $8200, %rsp
    popq %r12
    popq %rbx
    ret
    .size __ayanami_fs_rename, .-__ayanami_fs_rename

# int64_t __ayanami_fs_remove(str_view path)   unlinkat(..., 0)
    .globl __ayanami_fs_remove
    .type  __ayanami_fs_remove, @function
__ayanami_fs_remove:
    subq $4264, %rsp
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $263, %rax                # unlinkat(AT_FDCWD, path, 0)
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    xorl %edx, %edx
    syscall
    testq %rax, %rax
    js 2f
    xorl %eax, %eax
    addq $4264, %rsp
    ret
2:  negq %rax
    movq %rax, g_fs_errno(%rip)
1:  movq $-1, %rax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_remove, .-__ayanami_fs_remove

# int64_t __ayanami_fs_mkdir(str_view path)    mkdirat(AT_FDCWD, p, 0755)
    .globl __ayanami_fs_mkdir
    .type  __ayanami_fs_mkdir, @function
__ayanami_fs_mkdir:
    subq $4264, %rsp
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $258, %rax                # mkdirat(AT_FDCWD, path, 0755)
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    movq $0755, %rdx
    syscall
    testq %rax, %rax
    js 2f
    xorl %eax, %eax
    addq $4264, %rsp
    ret
2:  negq %rax
    movq %rax, g_fs_errno(%rip)
1:  movq $-1, %rax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_mkdir, .-__ayanami_fs_mkdir

# int64_t __ayanami_fs_rmdir(str_view path)    unlinkat(..., AT_REMOVEDIR)
    .globl __ayanami_fs_rmdir
    .type  __ayanami_fs_rmdir, @function
__ayanami_fs_rmdir:
    subq $4264, %rsp
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je 1f
    movq $263, %rax                # unlinkat(AT_FDCWD, path, AT_REMOVEDIR)
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    movq $0x200, %rdx
    syscall
    testq %rax, %rax
    js 2f
    xorl %eax, %eax
    addq $4264, %rsp
    ret
2:  negq %rax
    movq %rax, g_fs_errno(%rip)
1:  movq $-1, %rax
    addq $4264, %rsp
    ret
    .size __ayanami_fs_rmdir, .-__ayanami_fs_rmdir

    .bss
    .align 8
    .globl g_fs_errno
    .type  g_fs_errno, @object
    .size  g_fs_errno, 8
g_fs_errno:
    .quad 0

    .section .rodata
    .align 8
kind_table:
    .quad 2, 0
    .quad 13, 1
    .quad 1, 1
    .quad 17, 2
    .quad 20, 3
    .quad 21, 4
    .quad 39, 5
    .quad 22, 6
    .quad 36, 6
    .quad -1, 0

    .align 8
strerror_table:
    .quad 1, msg_eperm - strerror_table
    .quad 2, msg_enoent - strerror_table
    .quad 4, msg_eintr - strerror_table
    .quad 5, msg_eio - strerror_table
    .quad 9, msg_ebadf - strerror_table
    .quad 11, msg_eagain - strerror_table
    .quad 12, msg_enomem - strerror_table
    .quad 13, msg_eacces - strerror_table
    .quad 17, msg_eexist - strerror_table
    .quad 20, msg_enotdir - strerror_table
    .quad 21, msg_eisdir - strerror_table
    .quad 22, msg_einval - strerror_table
    .quad 28, msg_enospc - strerror_table
    .quad 30, msg_erofs - strerror_table
    .quad 36, msg_enametoolong - strerror_table
    .quad 39, msg_enotempty - strerror_table
    .quad 40, msg_eloop - strerror_table
    .quad -1, 0

msg_eperm:        .asciz "Operation not permitted"
msg_enoent:       .asciz "No such file or directory"
msg_eintr:        .asciz "Interrupted system call"
msg_eio:          .asciz "Input/output error"
msg_ebadf:        .asciz "Bad file descriptor"
msg_eagain:       .asciz "Resource temporarily unavailable"
msg_enomem:       .asciz "Cannot allocate memory"
msg_eacces:       .asciz "Permission denied"
msg_eexist:       .asciz "File exists"
msg_enotdir:      .asciz "Not a directory"
msg_eisdir:       .asciz "Is a directory"
msg_einval:       .asciz "Invalid argument"
msg_enospc:       .asciz "No space left on device"
msg_erofs:        .asciz "Read-only file system"
msg_enametoolong: .asciz "File name too long"
msg_enotempty:    .asciz "Directory not empty"
msg_eloop:        .asciz "Too many levels of symbolic links"
unknown_msg:      .asciz "Unknown error"

    .section .note.GNU-stack,"",@progbits
