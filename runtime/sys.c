// sys.c — 系统扩展（熵源 / 时间）
// 由 runtime.c 聚合包含（单编译单元，保持编译器链接路径不变）。
#ifndef AYANAMI_RUNTIME_SYS_C
#define AYANAMI_RUNTIME_SYS_C

#include <time.h>
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

#endif
