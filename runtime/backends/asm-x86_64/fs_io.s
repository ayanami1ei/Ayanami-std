# fs_io.s — 文件系统：读写与目录列举（x86-64 Linux 系统调用，无 libc）
#
# 与 runtime/sys.c 的 C 实现同 ABI。失败：g_fs_errno = -syscall_ret，返回 -1 / NULL。
# 依赖 fs.s 的 __ayanami_fs_path_cstr 与 g_fs_errno。
#
# 系统调用号：read=0 write=1 close=3 openat=257 newfstatat=262 getdents64=217
# AT_FDCWD=-100  O_RDONLY=0  O_WRONLY|O_CREAT|O_TRUNC=577  O_WRONLY|O_CREAT|O_APPEND=1089
# O_DIRECTORY=0x10000  AT_EMPTY_PATH=0x1000
# struct stat：st_size=48(i64)
# dirent64：d_reclen=16(u16)  d_name=19

    .text

# char *__ayanami_fs_read(str_view path)
    .globl __ayanami_fs_read
    .type  __ayanami_fs_read, @function
__ayanami_fs_read:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    subq $4216, %rsp               # [rsp]=stat(144) [rsp+144]=path(4096)
    leaq 144(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je .Lread_null
    movq $257, %rax                # openat(AT_FDCWD, path, O_RDONLY)
    movq $-100, %rdi
    leaq 144(%rsp), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js .Lread_errno
    movq %rax, %rbx                # fd
    movq $262, %rax                # newfstatat(fd, "", &st, AT_EMPTY_PATH)
    movq %rbx, %rdi
    leaq empty_str(%rip), %rsi
    movq %rsp, %rdx
    movq $0x1000, %r10
    syscall
    testq %rax, %rax
    js .Lread_close_errno
    movq 48(%rsp), %r12            # st_size
    leaq 1(%r12), %rdi             # size + 1
    call __ayanami_unique_alloc
    testq %rax, %rax
    je .Lread_close_errno
    movq %rax, %r13                # buf
    xorl %r14d, %r14d              # 已读
.Lread_loop:
    cmpq %r12, %r14
    jge .Lread_done
    xorl %eax, %eax                # read(fd, buf+off, size-off)
    movq %rbx, %rdi
    leaq (%r13,%r14), %rsi
    movq %r12, %rdx
    subq %r14, %rdx
    syscall
    testq %rax, %rax
    jle .Lread_free_errno
    addq %rax, %r14
    jmp .Lread_loop
.Lread_done:
    movb $0, (%r13,%r12)           # NUL
    movq $3, %rax                  # close(fd)
    movq %rbx, %rdi
    syscall
    movq %r13, %rax
    addq $4216, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Lread_free_errno:
    testq %rax, %rax
    js 1f
    movq $5, %rax                  # EOF 短读 → EIO
1:  negq %rax
    movq %rax, g_fs_errno(%rip)
    movq %r13, %rdi
    call free@PLT
    jmp .Lread_close_ret
.Lread_close_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
.Lread_close_ret:
    movq $3, %rax
    movq %rbx, %rdi
    syscall
    xorl %eax, %eax
    addq $4216, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Lread_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
.Lread_null:
    xorl %eax, %eax
    addq $4216, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
    .size __ayanami_fs_read, .-__ayanami_fs_read

# int64_t __ayanami_fs_write(str_view path, str_view data)
    .globl __ayanami_fs_write
    .type  __ayanami_fs_write, @function
__ayanami_fs_write:
    movq $577, %r8                 # O_WRONLY|O_CREAT|O_TRUNC
    jmp fs_write_common
    .size __ayanami_fs_write, .-__ayanami_fs_write

# int64_t __ayanami_fs_append(str_view path, str_view data)
    .globl __ayanami_fs_append
    .type  __ayanami_fs_append, @function
__ayanami_fs_append:
    movq $1089, %r8                # O_WRONLY|O_CREAT|O_APPEND
    jmp fs_write_common
    .size __ayanami_fs_append, .-__ayanami_fs_append

# 共用体：rdi/rsi = path，rdx/rcx = data，r8 = flags
    .type fs_write_common, @function
fs_write_common:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    subq $4200, %rsp               # [rsp]=path(4096)（+8 对齐）
    movq %rdx, %r12                # data 指针
    movq %rcx, %r13                # data 长度
    movq %r8, %r14                 # flags
    movq %rsp, %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je .Lwrite_fail
    movq $257, %rax                # openat(AT_FDCWD, path, flags, 0644)
    movq $-100, %rdi
    movq %rsp, %rsi
    movq %r14, %rdx
    movq $0644, %r10
    syscall
    testq %rax, %rax
    js .Lwrite_errno
    movq %rax, %rbx                # fd
    xorl %r14d, %r14d              # 已写
.Lwrite_loop:
    cmpq %r13, %r14
    jge .Lwrite_done
    movq $1, %rax                  # write(fd, data+off, len-off)
    movq %rbx, %rdi
    leaq (%r12,%r14), %rsi
    movq %r13, %rdx
    subq %r14, %rdx
    syscall
    testq %rax, %rax
    jle .Lwrite_close_errno
    addq %rax, %r14
    jmp .Lwrite_loop
.Lwrite_done:
    movq $3, %rax
    movq %rbx, %rdi
    syscall
    xorl %eax, %eax
    addq $4200, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Lwrite_close_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
    movq $3, %rax
    movq %rbx, %rdi
    syscall
.Lwrite_fail:
    movq $-1, %rax
    addq $4200, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Lwrite_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
    jmp .Lwrite_fail
    .size fs_write_common, .-fs_write_common

# int64_t __ayanami_fs_copy(str_view src, str_view dst)
    .globl __ayanami_fs_copy
    .type  __ayanami_fs_copy, @function
__ayanami_fs_copy:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    subq $16408, %rsp              # [rsp]=src(4096) [rsp+4096]=dst(4096) [rsp+8192]=buf(8192)（+8 对齐）
    movq %rdx, %r12                # dst.data
    movq %rcx, %r13                # dst.len
    leaq 4096(%rsp), %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr    # src
    testl %eax, %eax
    je .Lcopy_fail
    movq %r12, %rdi
    movq %r13, %rsi
    movq %rsp, %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr    # dst
    testl %eax, %eax
    je .Lcopy_fail
    movq $257, %rax                # in = openat(AT_FDCWD, src, O_RDONLY)
    movq $-100, %rdi
    leaq 4096(%rsp), %rsi
    xorl %edx, %edx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js .Lcopy_errno
    movq %rax, %rbx                # in
    movq $257, %rax                # out = openat(AT_FDCWD, dst, 577, 0644)
    movq $-100, %rdi
    movq %rsp, %rsi
    movq $577, %rdx
    movq $0644, %r10
    syscall
    testq %rax, %rax
    js .Lcopy_close_in_errno
    movq %rax, %r12                # out
.Lcopy_loop:
    xorl %eax, %eax                # read(in, buf, 8192)
    movq %rbx, %rdi
    leaq 8192(%rsp), %rsi
    movq $8192, %rdx
    syscall
    testq %rax, %rax
    js .Lcopy_close_both_errno
    jz .Lcopy_done                 # EOF
    movq %rax, %r13                # n
    xorl %r14d, %r14d              # 已写
.Lcopy_wloop:
    cmpq %r13, %r14
    jge .Lcopy_loop
    movq $1, %rax                  # write(out, buf+off, n-off)
    movq %r12, %rdi
    leaq 8192(%rsp,%r14), %rsi
    movq %r13, %rdx
    subq %r14, %rdx
    syscall
    testq %rax, %rax
    jle .Lcopy_close_both_errno
    addq %rax, %r14
    jmp .Lcopy_wloop
.Lcopy_done:
    movq $3, %rax                  # close(in)
    movq %rbx, %rdi
    syscall
    movq $3, %rax                  # close(out)
    movq %r12, %rdi
    syscall
    xorl %eax, %eax
    addq $16408, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Lcopy_close_both_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
    movq $3, %rax                  # close(out)
    movq %r12, %rdi
    syscall
    movq $3, %rax                  # close(in)
    movq %rbx, %rdi
    syscall
    jmp .Lcopy_fail
.Lcopy_close_in_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
    movq $3, %rax                  # close(in)
    movq %rbx, %rdi
    syscall
    jmp .Lcopy_fail
.Lcopy_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
.Lcopy_fail:
    movq $-1, %rax
    addq $16408, %rsp
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
    .size __ayanami_fs_copy, .-__ayanami_fs_copy

# int64_t __ayanami_fs_list_len(void)
    .globl __ayanami_fs_list_len
    .type  __ayanami_fs_list_len, @function
__ayanami_fs_list_len:
    movq g_list_len(%rip), %rax
    ret
    .size __ayanami_fs_list_len, .-__ayanami_fs_list_len

# char *__ayanami_fs_list_data(str_view path)   目录项 '\n' 连接（调用方接管）
    .globl __ayanami_fs_list_data
    .type  __ayanami_fs_list_data, @function
__ayanami_fs_list_data:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    subq $8240, %rsp               # [rsp]=path(4096) [rsp+4096]=dents(4096)
    movq %rsp, %rdx
    movq $4096, %rcx
    call __ayanami_fs_path_cstr
    testl %eax, %eax
    je .Llist_null
    movq $257, %rax                # fd = openat(AT_FDCWD, path, O_RDONLY|O_DIRECTORY)
    movq $-100, %rdi
    movq %rsp, %rsi
    movq $0x10000, %rdx
    xorl %r10d, %r10d
    syscall
    testq %rax, %rax
    js .Llist_errno
    movq %rax, %rbx                # fd
    movq $256, %rdi                # buf = malloc(256)
    call malloc@PLT
    testq %rax, %rax
    je .Llist_close_null
    movq %rax, %r12                # buf
    movq $256, %r13                # cap
    xorl %r14d, %r14d              # off
.Llist_outer:
    movq $217, %rax                # n = getdents64(fd, dents, 4096)
    movq %rbx, %rdi
    leaq 4096(%rsp), %rsi
    movq $4096, %rdx
    syscall
    testq %rax, %rax
    js .Llist_free_errno
    jz .Llist_finish
    movq %rax, %r15                # 本批字节数
    xorl %r10d, %r10d              # pos（本批内不再 syscall）
.Llist_entry:
    cmpq %r15, %r10
    jge .Llist_outer
    leaq 4096(%rsp), %r8
    addq %r10, %r8                 # entry
    movzwq 16(%r8), %r9            # reclen
    leaq 19(%r8), %rdi             # name
    cmpb $46, (%rdi)               # '.'
    jne .Llist_name
    cmpb $0, 1(%rdi)
    je .Llist_next
    cmpb $46, 1(%rdi)
    jne .Llist_name
    cmpb $0, 2(%rdi)
    je .Llist_next
.Llist_name:
    xorl %ecx, %ecx                # namelen
1:  cmpb $0, (%rdi,%rcx)
    je 2f
    incq %rcx
    jmp 1b
2:  leaq 2(%r14,%rcx), %rax        # off + namelen + 2
    cmpq %r13, %rax
    jle .Llist_have
3:  shlq $1, %r13                  # cap *= 2
    cmpq %r13, %rax
    jg 3b
    movq %r12, %rdi                # buf = realloc(buf, cap)
    movq %r13, %rsi
    pushq %r10                     # 保护：pos / reclen / namelen / name
    pushq %r9
    pushq %rcx
    pushq %rdi
    call realloc@PLT
    popq %rdi
    popq %rcx
    popq %r9
    popq %r10
    testq %rax, %rax
    je .Llist_free_errno
    movq %rax, %r12
.Llist_have:
    movq %rdi, %rsi                # 源 = name
    leaq (%r12,%r14), %rdi         # 目的 = buf + off
    rep movsb                      # 拷贝名字（rcx = namelen；rdi → buf+off+namelen）
    movb $10, (%rdi)               # '\n'
    leaq 1(%rdi), %r14             # off = (buf+off+namelen) + 1
    subq %r12, %r14
.Llist_next:
    addq %r9, %r10                 # pos += reclen
    jmp .Llist_entry
.Llist_finish:
    movb $0, (%r12,%r14)           # NUL
    movq %r14, g_list_len(%rip)
    movq $3, %rax                  # close(fd)
    movq %rbx, %rdi
    syscall
    movq %r12, %rax
    addq $8240, %rsp
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Llist_free_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
    movq %r12, %rdi
    call free@PLT
    jmp .Llist_close_null
.Llist_close_null:
    movq $3, %rax
    movq %rbx, %rdi
    syscall
.Llist_null:
    xorl %eax, %eax
    addq $8240, %rsp
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    ret
.Llist_errno:
    negq %rax
    movq %rax, g_fs_errno(%rip)
    jmp .Llist_null
    .size __ayanami_fs_list_data, .-__ayanami_fs_list_data

    .bss
    .align 8
    .type g_list_len, @object
    .size g_list_len, 8
g_list_len:
    .quad 0

    .section .rodata
empty_str:
    .asciz ""

    .section .note.GNU-stack,"",@progbits
