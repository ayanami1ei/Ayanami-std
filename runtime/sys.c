// sys.c — 系统扩展（熵源 / 时间）
// 由 runtime.c 聚合包含（单编译单元，保持编译器链接路径不变）。
#ifndef AYANAMI_RUNTIME_SYS_C
#define AYANAMI_RUNTIME_SYS_C

#include <time.h>
#include <errno.h>
#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/stat.h>
#include <dirent.h>
#if defined(__linux__)
#include <sys/random.h>
#endif

#ifndef AYANAMI_ASM_PORT
// ── 文件操作 errno 捕获（std fs 错误模型） ──（汇编后端提供：fs.s）
//
// 约定：g_fs_errno 记录最近一次 fs 调用的失败 errno（成功后不保证清零，
// 调用方仅在失败分支读取）。

static int64_t g_fs_errno = 0;

int64_t __ayanami_fs_errno(void) {
    return g_fs_errno;
}

static int64_t fs_fail(void) {
    g_fs_errno = errno;
    return -1;
}

static char *fs_fail_null(void) {
    g_fs_errno = errno;
    return NULL;
}

// errno → 稳定类别码（0 未找到 / 1 权限 / 2 已存在 / 3 非目录 / 4 是目录 /
// 5 目录非空 / 6 非法输入 / 7 其他）
int64_t __ayanami_fs_errno_kind(int64_t e) {
    switch (e) {
    case ENOENT: return 0;
    case EACCES: case EPERM: return 1;
    case EEXIST: return 2;
    case ENOTDIR: return 3;
    case EISDIR: return 4;
    case ENOTEMPTY: return 5;
    case EINVAL: case ENAMETOOLONG: return 6;
    default: return 7;
    }
}

// 系统错误消息（strerror 的 unique_alloc 拷贝，NUL 结尾；调用方拥有）
char *__ayanami_fs_strerror(int64_t e) {
    const char *m = strerror((int)e);
    if (!m) m = "unknown error";
    size_t n = strlen(m);
    char *buf = (char *)__ayanami_unique_alloc(n + 1);
    if (!buf) return NULL;
    memcpy(buf, m, n + 1);
    return buf;
}

int64_t __ayanami_cstr_len(const char *s) {
    return s ? (int64_t)strlen(s) : 0;
}


// 系统熵源：优先 getrandom，退回 /dev/urandom，最后退回 time()
int64_t __ayanami_random_u64(void) {
    uint64_t v = 0;
#if defined(__linux__)
    ssize_t n = getrandom(&v, sizeof v, 0);
    if (n == (ssize_t)sizeof v) {
        return (int64_t)v;
    }
#endif
    FILE *f = fopen("/dev/urandom", "rb");
    if (f) {
        size_t r = fread(&v, 1, sizeof v, f);
        fclose(f);
        if (r == sizeof v) {
            return (int64_t)v;
        }
    }
    return (int64_t)time(NULL);
}

// 单调毫秒（CLOCK_MONOTONIC；用于计时/差值）
int64_t __ayanami_time_millis(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000 + (int64_t)(ts.tv_nsec / 1000000);
}

// 单调微秒
int64_t __ayanami_time_micros(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000 + (int64_t)(ts.tv_nsec / 1000);
}

// Unix 秒
int64_t __ayanami_time_unix(void) {
    return (int64_t)time(NULL);
}

// 睡眠毫秒（nanosleep；被信号打断时按剩余时间继续）
int64_t __ayanami_time_sleep_ms(int64_t ms) {
    if (ms <= 0) return 0;
    struct timespec ts;
    ts.tv_sec = ms / 1000;
    ts.tv_nsec = (ms % 1000) * 1000000;
    while (nanosleep(&ts, &ts) != 0 && errno == EINTR) {
    }
    return 0;
}

#endif // AYANAMI_ASM_PORT（熵源与时间由汇编后端提供）

// ── 线程（pthread；Job 按值传入，运行时接管闭包所有权） ──
#ifndef AYANAMI_ASM_PORT

static void *ayanami_thread_entry(void *jobp) {
    __ayanami_thread_job *job = (__ayanami_thread_job *)jobp;
    void *env = job->env;
    void **vt = (void **)job->vtable;
    void (*trampoline)(void *) = (void (*)(void *))vt[1];
    void (*drop)(void *) = (void (*)(void *))vt[0];
    trampoline(env);
    drop(env);
    free(job);
    return NULL;
}

int64_t __ayanami_thread_spawn(__ayanami_thread_job job) {
    __ayanami_thread_job *slot = (__ayanami_thread_job *)malloc(sizeof *slot);
    if (!slot) return 0;
    *slot = job;
    pthread_t t;
    if (pthread_create(&t, NULL, ayanami_thread_entry, slot) != 0) {
        free(slot);
        return 0;
    }
    return (int64_t)(unsigned long)t;
}

int64_t __ayanami_thread_join(int64_t handle) {
    return pthread_join((pthread_t)(unsigned long)handle, NULL) == 0 ? 0 : -1;
}

int64_t __ayanami_thread_id(void) {
    return (int64_t)syscall(SYS_gettid);
}

int64_t __ayanami_thread_yield(void) {
    return (int64_t)sched_yield();
}

#endif // AYANAMI_ASM_PORT（线程由汇编后端提供）

// ── 进程（C 后端：exit） ──
#ifndef AYANAMI_ASM_PORT
void __ayanami_exit(int64_t code) {
    exit((int)code);
}
#endif // AYANAMI_ASM_PORT（进程退出由汇编后端提供）

// ── futex（C 后端：syscall(2)；EINTR 视为 0，由调用方重查状态） ──
#ifndef AYANAMI_ASM_PORT
#include <linux/futex.h>

int64_t __ayanami_futex_wait(int32_t *addr, int32_t expected) {
    long r = syscall(SYS_futex, addr, FUTEX_WAIT, expected, NULL, NULL, 0);
    if (r == -1 && errno == EINTR) return 0;
    return r == 0 ? 0 : -1;
}

int64_t __ayanami_futex_wake(int32_t *addr, int32_t n) {
    long r = syscall(SYS_futex, addr, FUTEX_WAKE, n, NULL, NULL, 0);
    return r < 0 ? -1 : (int64_t)r;
}
#endif // AYANAMI_ASM_PORT（futex 由汇编后端提供）

static int path_cstr(__ayanami_str_view path, char *out, size_t cap) {
    if (path.len <= 0 || path.len >= (long)cap) { errno = EINVAL; return 0; }
    memcpy(out, path.data, (size_t)path.len);
    out[path.len] = 0;
    return 1;
}

// ── 文件 ──（汇编后端提供：runtime/backends/asm-x86_64/fs.s + fs_io.s）

#ifndef AYANAMI_ASM_PORT

int64_t __ayanami_fs_size(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    struct stat st;
    if (stat(p, &st) != 0) return fs_fail();
    return (int64_t)st.st_size;
}

char *__ayanami_fs_read(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail_null();
    FILE *f = fopen(p, "rb");
    if (!f) return fs_fail_null();
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (n < 0) { fclose(f); return fs_fail_null(); }
    char *buf = (char *)__ayanami_unique_alloc((size_t)n + 1);
    if (!buf) { fclose(f); return fs_fail_null(); }
    size_t r = fread(buf, 1, (size_t)n, f);
    int bad = (r != (size_t)n) || ferror(f);
    fclose(f);
    if (bad) {
        __ayanami_unique_free(buf);
        return fs_fail_null();
    }
    buf[r] = 0;
    return buf;
}

int64_t __ayanami_fs_write(__ayanami_str_view path, __ayanami_str_view data) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    FILE *f = fopen(p, "wb");
    if (!f) return fs_fail();
    size_t w = fwrite(data.data, 1, (size_t)data.len, f);
    fclose(f);
    return (w == (size_t)data.len) ? 0 : fs_fail();
}

int64_t __ayanami_fs_append(__ayanami_str_view path, __ayanami_str_view data) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    FILE *f = fopen(p, "ab");
    if (!f) return fs_fail();
    size_t w = fwrite(data.data, 1, (size_t)data.len, f);
    fclose(f);
    return (w == (size_t)data.len) ? 0 : fs_fail();
}

int64_t __ayanami_fs_copy(__ayanami_str_view src, __ayanami_str_view dst) {
    char ps[4096], pd[4096];
    if (!path_cstr(src, ps, sizeof ps)) return fs_fail();
    if (!path_cstr(dst, pd, sizeof pd)) return fs_fail();
    FILE *in = fopen(ps, "rb");
    if (!in) return fs_fail();
    FILE *out = fopen(pd, "wb");
    if (!out) { fclose(in); return fs_fail(); }
    char buf[8192];
    size_t n;
    int64_t rc = 0;
    while ((n = fread(buf, 1, sizeof buf, in)) > 0) {
        if (fwrite(buf, 1, n, out) != n) { rc = -1; break; }
    }
    if (ferror(in)) rc = -1;
    fclose(in);
    fclose(out);
    return rc == 0 ? 0 : fs_fail();
}

int64_t __ayanami_fs_rename(__ayanami_str_view from, __ayanami_str_view to) {
    char pf[4096], pt[4096];
    if (!path_cstr(from, pf, sizeof pf)) return fs_fail();
    if (!path_cstr(to, pt, sizeof pt)) return fs_fail();
    return rename(pf, pt) == 0 ? 0 : fs_fail();
}

int64_t __ayanami_fs_remove(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    return remove(p) == 0 ? 0 : fs_fail();
}

int64_t __ayanami_fs_mkdir(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    return mkdir(p, 0755) == 0 ? 0 : fs_fail();
}

int64_t __ayanami_fs_rmdir(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    return rmdir(p) == 0 ? 0 : fs_fail();
}

int64_t __ayanami_fs_mtime(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return fs_fail();
    struct stat st;
    if (stat(p, &st) != 0) return fs_fail();
    return (int64_t)st.st_mtime;
}

int64_t __ayanami_fs_is_file(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return 0;
    struct stat st;
    if (stat(p, &st) != 0) return 0;
    return S_ISREG(st.st_mode) ? 1 : 0;
}

int64_t __ayanami_fs_is_dir(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return 0;
    struct stat st;
    if (stat(p, &st) != 0) return 0;
    return S_ISDIR(st.st_mode) ? 1 : 0;
}

// 最近一次 list_data 的字节长度（调用方随后读取）
static int64_t g_list_len = 0;

int64_t __ayanami_fs_list_len(void) {
    return g_list_len;
}

// 目录项（跳过 . / ..；'\n' 连接、NUL 结尾）——单趟 realloc
char *__ayanami_fs_list_data(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return NULL;
    DIR *d = opendir(p);
    if (!d) return NULL;
    size_t cap = 256, off = 0;
    char *buf = (char *)__ayanami_unique_alloc(cap);
    if (!buf) { closedir(d); return NULL; }
    struct dirent *e;
    while ((e = readdir(d)) != NULL) {
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
        size_t n = strlen(e->d_name);
        if (off + n + 2 > cap) {
            size_t ncap = cap * 2;
            while (off + n + 2 > ncap) ncap *= 2;
            char *nb = (char *)realloc(buf, ncap);
            if (!nb) { __ayanami_unique_free(buf); closedir(d); return NULL; }
            buf = nb;
            cap = ncap;
        }
        memcpy(buf + off, e->d_name, n);
        off += n;
        buf[off++] = '\n';
    }
    buf[off] = 0;
    g_list_len = (int64_t)off;
    closedir(d);
    return buf;
}

#endif // AYANAMI_ASM_PORT（文件系统由汇编后端提供）

// ── 命令行参数（/proc/self/cmdline，惰性解析） ──（汇编后端提供：args_env.s）

#ifndef AYANAMI_ASM_PORT

static char **g_args = NULL;
static int64_t g_argc = 0;
static int g_args_loaded = 0;

static void load_args(void) {
    if (g_args_loaded) return;
    g_args_loaded = 1;
    FILE *f = fopen("/proc/self/cmdline", "rb");
    if (!f) return;
    size_t cap = 4096, len = 0;
    char *buf = (char *)malloc(cap);
    if (!buf) { fclose(f); return; }
    for (;;) {
        if (len + 4096 > cap) {
            cap *= 2;
            char *nb = (char *)realloc(buf, cap);
            if (!nb) break;
            buf = nb;
        }
        size_t r = fread(buf + len, 1, 4096, f);
        len += r;
        if (r < 4096) break;
    }
    fclose(f);
    int64_t count = 0;
    for (size_t i = 0; i < len; i++) {
        if (buf[i] == 0) count++;
    }
    if (count == 0) { free(buf); return; }
    g_args = (char **)malloc(sizeof(char *) * (size_t)count);
    if (!g_args) { free(buf); return; }
    size_t start = 0;
    for (size_t i = 0; i < len && g_argc < count; i++) {
        if (buf[i] == 0) {
            g_args[g_argc++] = buf + start;
            start = i + 1;
        }
    }
}

int64_t __ayanami_arg_count(void) {
    load_args();
    return g_argc;
}

int64_t __ayanami_arg_len(int64_t i) {
    load_args();
    if (i < 0 || i >= g_argc) return -1;
    return (int64_t)strlen(g_args[i]);
}

char *__ayanami_arg_data(int64_t i) {
    load_args();
    if (i < 0 || i >= g_argc) return NULL;
    const char *s = g_args[i];
    size_t n = strlen(s);
    char *copy = (char *)__ayanami_unique_alloc(n + 1);
    if (!copy) return NULL;
    memcpy(copy, s, n + 1);
    return copy;
}

// ── 环境变量 ──

int64_t __ayanami_env_len(__ayanami_str_view name) {
    char key[1025];
    if (!path_cstr(name, key, sizeof key)) return -1;
    const char *v = getenv(key);
    if (!v) return -1;
    return (int64_t)strlen(v);
}

char *__ayanami_env_data(__ayanami_str_view name) {
    char key[1025];
    if (!path_cstr(name, key, sizeof key)) return NULL;
    const char *v = getenv(key);
    if (!v) return NULL;
    size_t n = strlen(v);
    char *copy = (char *)__ayanami_unique_alloc(n + 1);
    if (!copy) return NULL;
    memcpy(copy, v, n + 1);
    return copy;
}

#endif // AYANAMI_ASM_PORT（参数与环境变量由汇编后端提供）

#endif