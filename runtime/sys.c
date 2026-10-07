// sys.c — 系统扩展（熵源 / 时间）
// 由 runtime.c 聚合包含（单编译单元，保持编译器链接路径不变）。
#ifndef AYANAMI_RUNTIME_SYS_C
#define AYANAMI_RUNTIME_SYS_C

#include <time.h>
#include <errno.h>
#include <sys/stat.h>
#if defined(__linux__)
#include <sys/random.h>
#endif

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

// ── 文件 ──

static int path_cstr(__ayanami_str_view path, char *out, size_t cap) {
    if (path.len <= 0 || path.len >= (long)cap) return 0;
    memcpy(out, path.data, (size_t)path.len);
    out[path.len] = 0;
    return 1;
}

int64_t __ayanami_fs_size(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return -1;
    struct stat st;
    if (stat(p, &st) != 0) return -1;
    return (int64_t)st.st_size;
}

char *__ayanami_fs_read(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return NULL;
    FILE *f = fopen(p, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    fseek(f, 0, SEEK_SET);
    if (n < 0) { fclose(f); return NULL; }
    char *buf = (char *)__ayanami_unique_alloc((size_t)n + 1);
    if (!buf) { fclose(f); return NULL; }
    size_t r = fread(buf, 1, (size_t)n, f);
    fclose(f);
    buf[r] = 0;
    return buf;
}

int64_t __ayanami_fs_write(__ayanami_str_view path, __ayanami_str_view data) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return -1;
    FILE *f = fopen(p, "wb");
    if (!f) return -1;
    size_t w = fwrite(data.data, 1, (size_t)data.len, f);
    fclose(f);
    return (w == (size_t)data.len) ? 0 : -1;
}

int64_t __ayanami_fs_append(__ayanami_str_view path, __ayanami_str_view data) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return -1;
    FILE *f = fopen(p, "ab");
    if (!f) return -1;
    size_t w = fwrite(data.data, 1, (size_t)data.len, f);
    fclose(f);
    return (w == (size_t)data.len) ? 0 : -1;
}

int64_t __ayanami_fs_remove(__ayanami_str_view path) {
    char p[4096];
    if (!path_cstr(path, p, sizeof p)) return -1;
    return remove(p) == 0 ? 0 : -1;
}

// ── 命令行参数（/proc/self/cmdline，惰性解析） ──

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

#endif
