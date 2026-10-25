// selftest.c — asm-x86_64 后端自检（汇编实现的正确性）
//
// 覆盖：ABI 版本、默认/计数分配、wrapping / overflow / saturating 边界。
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>

#include "../../abi.h"

static int g_child_ran = 0;
static int64_t g_child_tid = 0;

static void selftest_tramp(void *env) {
    (void)env;
    g_child_tid = __ayanami_thread_id();
    g_child_ran = 1;
}

// 闭包 vtable：[drop, trampoline]
static void *g_selftest_vtable[2];

static void selftest_drop(void *env) {
    (void)env;
}


// 128 位溢出用例：子进程执行（panic → exit 101）
static int ovf_child_exits_101(void (*fn)(void)) {
    pid_t pid = fork();
    if (pid == 0) {
        int devnull = open("/dev/null", 1);
        if (devnull >= 0) { dup2(devnull, 2); }
        fn();
        _exit(0);
    }
    int st = 0;
    if (waitpid(pid, &st, 0) < 0) return 0;
    return WIFEXITED(st) && WEXITSTATUS(st) == 101;
}

static void ovf_case_add_i128(void) {
    __int128 m = (__int128)(((unsigned __int128)1 << 127) - 1);
    __ayanami_str_view f = { (char *)__ayanami_unique_alloc(1), 1 };
    (void)__ayanami_ovf_add_i128(m, 1, 0, 0, f);
}
static void ovf_case_sub_i128(void) {
    __int128 m = -(__int128)((unsigned __int128)1 << 127);
    __ayanami_str_view f = { (char *)__ayanami_unique_alloc(1), 1 };
    (void)__ayanami_ovf_sub_i128(m, 1, 0, 0, f);
}
static void ovf_case_mul_i128(void) {
    __int128 a = (__int128)1 << 100;
    __ayanami_str_view f = { (char *)__ayanami_unique_alloc(1), 1 };
    (void)__ayanami_ovf_mul_i128(a, a, 0, 0, f);
}
static void ovf_case_add_u128(void) {
    unsigned __int128 m = ~(unsigned __int128)0;
    __ayanami_str_view f = { (char *)__ayanami_unique_alloc(1), 1 };
    (void)__ayanami_ovf_add_u128(m, 1, 0, 0, f);
}
static void ovf_case_sub_u128(void) {
    __ayanami_str_view f = { (char *)__ayanami_unique_alloc(1), 1 };
    (void)__ayanami_ovf_sub_u128(0, 1, 0, 0, f);
}
static void ovf_case_mul_u128(void) {
    unsigned __int128 a = (unsigned __int128)1 << 100;
    __ayanami_str_view f = { (char *)__ayanami_unique_alloc(1), 1 };
    (void)__ayanami_ovf_mul_u128(a, a, 0, 0, f);
}

static int exit_child_code(void) {
    pid_t pid = fork();
    if (pid == 0) {
        __ayanami_exit(7);
        _exit(0);
    }
    int st = 0;
    if (waitpid(pid, &st, 0) < 0) return -1;
    return WIFEXITED(st) ? WEXITSTATUS(st) : -1;
}

int main(void) {
    assert(__ayanami_runtime_abi() == AYANAMI_RUNTIME_ABI);

    // 分配：默认原语（不计数）与计数分配
    void *p = __ayanami_default_alloc(16);
    assert(p != NULL);
    assert(__ayanami_live_allocs() == 0);        // 默认原语不计计数
    __ayanami_default_free(p);

    void *q = __ayanami_counted_alloc(24);
    assert(q != NULL);
    assert(__ayanami_live_allocs() == 1);
    __ayanami_counted_free(q);
    assert(__ayanami_live_allocs() == 0);
    __ayanami_counted_free(NULL);                // NULL 安全
    assert(__ayanami_live_allocs() == 0);

    // wrapping
    assert(__ayanami_wrapping_add(INT64_MAX, 1) == INT64_MIN);
    assert(__ayanami_wrapping_sub(INT64_MIN, 1) == INT64_MAX);
    assert(__ayanami_wrapping_mul(INT64_MAX, 2) == -2);
    assert(__ayanami_wrapping_neg(INT64_MIN) == INT64_MIN);
    assert(__ayanami_wrapping_add(3, 4) == 7);

    // overflow 标志
    assert(__ayanami_add_overflow(INT64_MAX, 1) == 1);
    assert(__ayanami_add_overflow(1, 2) == 0);
    assert(__ayanami_add_overflow(INT64_MIN, -1) == 1);
    assert(__ayanami_sub_overflow(INT64_MIN, 1) == 1);
    assert(__ayanami_sub_overflow(1, 2) == 0);
    assert(__ayanami_mul_overflow(INT64_MAX, 2) == 1);
    assert(__ayanami_mul_overflow(3, 4) == 0);

    // saturating
    assert(__ayanami_saturating_add(INT64_MAX, 1) == INT64_MAX);
    assert(__ayanami_saturating_add(INT64_MIN, -1) == INT64_MIN);
    assert(__ayanami_saturating_add(1, 2) == 3);
    assert(__ayanami_saturating_sub(INT64_MIN, 1) == INT64_MIN);
    assert(__ayanami_saturating_sub(INT64_MAX, -1) == INT64_MAX);
    assert(__ayanami_saturating_mul(INT64_MAX, 2) == INT64_MAX);
    assert(__ayanami_saturating_mul(INT64_MIN, 2) == INT64_MIN);
    assert(__ayanami_saturating_mul(INT64_MAX, -2) == INT64_MIN);

    // io：print_str / print_int / putchar / print_ln（冒烟：不崩溃即可）
    __ayanami_print_str("io: ", 4);
    __ayanami_print_int(12345);
    __ayanami_putchar(' ');
    __ayanami_print_int(-42);
    __ayanami_print_ln();

    // time：单调 + unix + sleep
    int64_t t1 = __ayanami_time_millis();
    int64_t t2 = __ayanami_time_millis();
    assert(t2 >= t1);
    assert(__ayanami_time_micros() > 0);
    assert(__ayanami_time_unix() > 1600000000);
    assert(__ayanami_time_sleep_ms(0) == 0);
    __ayanami_time_sleep_ms(5);
    assert(__ayanami_time_millis() - t2 >= 3);

    // rand：非零且两次不同
    int64_t r1 = __ayanami_random_u64();
    int64_t r2 = __ayanami_random_u64();
    assert(r1 != 0 && r2 != 0);
    assert(r1 != r2);

    // fs：写/追加/读/复制/重命名/删除 + errno + 目录列举
    {
        const char *fp = "/tmp/ayanami_asm_fs.txt";
        __ayanami_str_view path = { fp, (long)strlen(fp) };
        __ayanami_str_view data = { "hello ", 6 };
        __ayanami_str_view more = { "world", 5 };
        assert(__ayanami_fs_write(path, data) == 0);
        assert(__ayanami_fs_append(path, more) == 0);
        assert(__ayanami_fs_size(path) == 11);
        char *content = __ayanami_fs_read(path);
        assert(content != NULL);
        assert(__ayanami_cstr_len(content) == 11);
        assert(content[0] == 'h' && content[10] == 'd');
        __ayanami_unique_free(content);
        assert(__ayanami_fs_is_file(path) == 1);
        assert(__ayanami_fs_is_dir(path) == 0);
        assert(__ayanami_fs_mtime(path) > 0);

        const char *cp = "/tmp/ayanami_asm_fs_copy.txt";
        __ayanami_str_view copy = { cp, (long)strlen(cp) };
        assert(__ayanami_fs_copy(path, copy) == 0);
        assert(__ayanami_fs_size(copy) == 11);
        const char *rp = "/tmp/ayanami_asm_fs_rn.txt";
        __ayanami_str_view renamed = { rp, (long)strlen(rp) };
        assert(__ayanami_fs_rename(copy, renamed) == 0);
        assert(__ayanami_fs_size(copy) == -1);
        assert(__ayanami_fs_remove(renamed) == 0);
        assert(__ayanami_fs_remove(path) == 0);

        const char *mp = "/tmp/ayanami_no_such_xyz";
        __ayanami_str_view missing = { mp, (long)strlen(mp) };
        assert(__ayanami_fs_read(missing) == NULL);
        assert(__ayanami_fs_errno() == 2);
        assert(__ayanami_fs_errno_kind(2) == 0);
        assert(__ayanami_fs_errno_kind(13) == 1);
        assert(__ayanami_fs_errno_kind(999) == 7);
        char *emsg = __ayanami_fs_strerror(2);
        assert(emsg != NULL && __ayanami_cstr_len(emsg) > 0);
        __ayanami_unique_free(emsg);

        const char *dp = "/tmp/ayanami_asm_dir";
        __ayanami_str_view dir = { dp, (long)strlen(dp) };
        assert(__ayanami_fs_mkdir(dir) == 0);
        assert(__ayanami_fs_is_dir(dir) == 1);
        const char *ip = "/tmp/ayanami_asm_dir/a.txt";
        __ayanami_str_view inner = { ip, (long)strlen(ip) };
        assert(__ayanami_fs_write(inner, data) == 0);
        char *list = __ayanami_fs_list_data(dir);
        assert(list != NULL);
        assert(__ayanami_fs_list_len() > 0);
        assert(strstr(list, "a.txt") != NULL);
        __ayanami_unique_free(list);
        assert(__ayanami_fs_remove(inner) == 0);
        assert(__ayanami_fs_rmdir(dir) == 0);
    }

    // args：argv[0] 存在
    assert(__ayanami_arg_count() >= 1);
    assert(__ayanami_arg_len(0) > 0);
    assert(__ayanami_arg_len(-1) == -1);
    assert(__ayanami_arg_len(999999) == -1);
    char *arg0 = __ayanami_arg_data(0);
    assert(arg0 != NULL && __ayanami_cstr_len(arg0) > 0);
    __ayanami_unique_free(arg0);
    assert(__ayanami_arg_data(999999) == NULL);

    // env：AYANAMI_ASM_SELFTEST（build.sh 导出）
    {
        const char *en = "AYANAMI_ASM_SELFTEST";
        __ayanami_str_view key = { en, (long)strlen(en) };
        assert(__ayanami_env_len(key) == 2);
        char *v = __ayanami_env_data(key);
        assert(v != NULL && v[0] == '4' && v[1] == '2' && v[2] == 0);
        __ayanami_unique_free(v);
    }

    // ovf：非溢出路径（溢出路径由 std 的 should_panic 用例覆盖；助手负责释放 file 缓冲）
    {
        char *fb = (char *)__ayanami_unique_alloc(8);
        assert(fb != NULL);
        __ayanami_str_view fv = { fb, 8 };
        assert(__ayanami_ovf_add_i64(2, 3, 0, 0, fv) == 5);
        char *fb2 = (char *)__ayanami_unique_alloc(8);
        __ayanami_str_view fv2 = { fb2, 8 };
        assert(__ayanami_ovf_mul_u8(20, 10, 0, 0, fv2) == 200);
        char *fb3 = (char *)__ayanami_unique_alloc(8);
        __ayanami_str_view fv3 = { fb3, 8 };
        assert(__ayanami_ovf_sub_i32(100, 58, 0, 0, fv3) == 42);
    }

    // thread：spawn → 子线程运行 trampoline → join；tid 与主线程不同
    {
        __ayanami_thread_job job;
        g_selftest_vtable[0] = (void *)selftest_drop;
        g_selftest_vtable[1] = (void *)selftest_tramp;
        job.env = (void *)0;
        job.vtable = (void *)g_selftest_vtable;
        int64_t h = __ayanami_thread_spawn(job);
        assert(h != 0);
        assert(__ayanami_thread_join(h) == 0);
        assert(g_child_ran == 1);
        assert(g_child_tid != 0);
        assert(g_child_tid != __ayanami_thread_id());
        assert(__ayanami_thread_yield() == 0);
    }

    // futex：值不匹配立即返回 -1（EAGAIN）；无等待者时 wake 返回 0
    {
        static int32_t fw = 0;
        assert(__ayanami_futex_wait(&fw, 1) == -1);
        assert(__ayanami_futex_wake(&fw, 1) == 0);
    }

    // 128 位溢出助手：与 C __int128 语义对照（非溢出）+ 溢出 exit 101
    {
        __int128 a = ((__int128)1 << 60) + 7;
        __int128 b = ((__int128)1 << 50) + 11;
        __int128 na = -a;
        __ayanami_str_view f1 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_add_i128(a, b, 0, 0, f1) == a + b);
        __ayanami_str_view f2 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_sub_i128(a, b, 0, 0, f2) == a - b);
        __ayanami_str_view f3 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_mul_i128(a, b, 0, 0, f3) == a * b);
        __ayanami_str_view f4 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_mul_i128(na, b, 0, 0, f4) == na * b);
        __ayanami_str_view f5 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_add_i128(na, b, 0, 0, f5) == na + b);
        unsigned __int128 ua = ((unsigned __int128)1 << 100) + 7;
        unsigned __int128 ub = ((unsigned __int128)1 << 20) + 3;
        __ayanami_str_view f6 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_mul_u128(ua, ub, 0, 0, f6) == ua * ub);
        __ayanami_str_view f7 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_add_u128(ua, ub, 0, 0, f7) == ua + ub);
        __ayanami_str_view f8 = { (char *)__ayanami_unique_alloc(1), 1 };
        assert(__ayanami_ovf_sub_u128(ua, ub, 0, 0, f8) == ua - ub);
        assert(ovf_child_exits_101(ovf_case_add_i128));
        assert(ovf_child_exits_101(ovf_case_sub_i128));
        assert(ovf_child_exits_101(ovf_case_mul_i128));
        assert(ovf_child_exits_101(ovf_case_add_u128));
        assert(ovf_child_exits_101(ovf_case_sub_u128));
        assert(ovf_child_exits_101(ovf_case_mul_u128));
    }

    // process：exit(code) 退出码正确（子进程）
    assert(exit_child_code() == 7);

    printf("asm-x86_64 runtime self-test ok (ABI %lld)\n",
           (long long)__ayanami_runtime_abi());
    return 0;
}
