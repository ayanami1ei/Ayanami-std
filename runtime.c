// Ayanami runtime support library.
// Provides reference counting and I/O utilities.

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "runtime/abi.h"

#define RC_HEADER(ptr)  (((int64_t *)(ptr)) - 1)

// ──────────────────────────────────────────────
//  Unique ownership (Box-like)
// ──────────────────────────────────────────────

#ifndef AYANAMI_ASM_PORT
static int64_t live_allocs = 0;

int64_t __ayanami_runtime_abi(void) { return AYANAMI_RUNTIME_ABI; }

/* A6：标准库辅助 —— 数学与位操作已迁移为纯 Ayanami 实现
 * （std/src/core/math.aya、std/src/core/bitops.aya）；
 * 运行时仅保留机器相关的基础件（内存/IO/系统调用/浮点格式化）。 */

// ── 显式溢出算术（std core/num.aya：wrapping / saturating / overflowing / checked） ──

int64_t __ayanami_wrapping_add(int64_t a, int64_t b) { return (int64_t)((uint64_t)a + (uint64_t)b); }
int64_t __ayanami_wrapping_sub(int64_t a, int64_t b) { return (int64_t)((uint64_t)a - (uint64_t)b); }
int64_t __ayanami_wrapping_mul(int64_t a, int64_t b) { return (int64_t)((uint64_t)a * (uint64_t)b); }
int64_t __ayanami_wrapping_neg(int64_t a) { return (int64_t)(0u - (uint64_t)a); }

int64_t __ayanami_add_overflow(int64_t a, int64_t b) {
    int64_t r;
    return __builtin_add_overflow(a, b, &r) ? 1 : 0;
}
int64_t __ayanami_sub_overflow(int64_t a, int64_t b) {
    int64_t r;
    return __builtin_sub_overflow(a, b, &r) ? 1 : 0;
}
int64_t __ayanami_mul_overflow(int64_t a, int64_t b) {
    int64_t r;
    return __builtin_mul_overflow(a, b, &r) ? 1 : 0;
}

int64_t __ayanami_saturating_add(int64_t a, int64_t b) {
    int64_t r;
    if (__builtin_add_overflow(a, b, &r)) return a > 0 ? INT64_MAX : INT64_MIN;
    return r;
}
int64_t __ayanami_saturating_sub(int64_t a, int64_t b) {
    int64_t r;
    if (__builtin_sub_overflow(a, b, &r)) return a > 0 ? INT64_MAX : INT64_MIN;
    return r;
}
int64_t __ayanami_saturating_mul(int64_t a, int64_t b) {
    int64_t r;
    if (__builtin_mul_overflow(a, b, &r)) {
        int neg = (a < 0) != (b < 0);
        return neg ? INT64_MIN : INT64_MAX;
    }
    return r;
}

#endif // AYANAMI_ASM_PORT（算术助手由汇编后端提供）

#ifndef AYANAMI_ASM_PORT
/* A5d-3b：诊断通道弱符号（可执行文件里为 no-op；插件 shim 提供强定义） */
__attribute__((weak)) void __ayanami_diag_emit(long long level, __ayanami_diag_buf msg) {
    (void)level;
    (void)msg;
}
#endif // AYANAMI_ASM_PORT（弱符号空实现由汇编后端提供）

#ifndef AYANAMI_ASM_PORT
// 默认分配原语（供自定义分配器包装；不经计数）
void *__ayanami_default_alloc(size_t size) { return malloc(size); }
void __ayanami_default_free(void *ptr) { free(ptr); }

// 计数分配（弱符号：用户程序可导出同名强定义覆盖，见 std/src/system/alloc.aya）
__attribute__((weak)) void *__ayanami_unique_alloc(size_t size) {
    void *p = __ayanami_default_alloc(size);
    if (p) live_allocs++;
    return p;
}

__attribute__((weak)) void __ayanami_unique_free(void *ptr) {
    if (!ptr) return;
    live_allocs--;
    __ayanami_default_free(ptr);
}

// 计数分配的标准库入口（编译器内建声明只覆盖 unique_*，std 经此调用避免重复声明）
void *__ayanami_counted_alloc(size_t size) { return __ayanami_unique_alloc(size); }
void __ayanami_counted_free(void *ptr) { __ayanami_unique_free(ptr); }

int64_t __ayanami_live_allocs(void) {
    return live_allocs;
}
#endif // AYANAMI_ASM_PORT（分配与 ABI 由汇编后端提供）

// ──────────────────────────────────────────────
//  A5c-2：运行时 panic（退出码 101，Rust 风格输出）
// ──────────────────────────────────────────────

#ifndef AYANAMI_ASM_PORT
static void __ayanami_print_view(const char* data, long len) {
    if (data && len > 0) fwrite(data, 1, (size_t)len, stderr);
}

/// 是否给 stderr 上色（TTY 且未设置 NO_COLOR）
static int __ayanami_color_stderr(void) {
    const char* no = getenv("NO_COLOR");
    if (no && *no) return 0;
    return isatty(2);
}

/// Rust 风格 panic：`thread 'main' panicked at file:line:col:`（红色）+ 消息，退出 101
void __ayanami_panic_print_msg(long long line, long long col,
                                  const char* file, long file_len,
                                  const char* msg, long msg_len) {
    fflush(stdout);
    int color = __ayanami_color_stderr();
    if (line > 0 && file && file_len > 0) {
        char loc[1200];
        int n = (int)(file_len < 1000 ? file_len : 1000);
        snprintf(loc, sizeof loc, "%.*s:%lld:%lld", n, file, line, col);
        if (color) {
            fprintf(stderr, "\x1b[1;31mthread 'main' panicked at %s:\x1b[0m\n", loc);
        } else {
            fprintf(stderr, "thread 'main' panicked at %s:\n", loc);
        }
    } else if (color) {
        fputs("\x1b[1;31mthread 'main' panicked:\x1b[0m\n", stderr);
    } else {
        fputs("thread 'main' panicked:\n", stderr);
    }
    __ayanami_print_view(msg, msg_len);
    fputc('\n', stderr);
    exit(101);
}

void __ayanami_panic_at(long long line, long long col, __ayanami_str_view file, __ayanami_str_view msg) {
    __ayanami_panic_print_msg(line, col, file.data, file.len, msg.data, msg.len);
}

void __ayanami_panic_bounds_at(long long line, long long col, __ayanami_str_view file,
                               long long index, long long len) {
    char buf[160];
    snprintf(buf, sizeof buf, "index out of bounds: the len is %lld but the index is %lld", len, index);
    __ayanami_panic_print_msg(line, col, file.data, file.len, buf, (long)strlen(buf));
}


#endif // AYANAMI_ASM_PORT（panic 由汇编后端提供）

// ──────────────────────────────────────────────
//  Overflow checks (M1.7, debug builds)
//  `a + b` 等降级为 __ayanami_ovf_{add,sub,mul}_{iN,uN}(a, b, line, col, file)
// ──────────────────────────────────────────────
#define __AYANAMI_OVF(name, T, op, msg) \
    T __ayanami_ovf_##name(T a, T b, long long line, long long col, __ayanami_str_view file) { \
        T r; \
        if (__builtin_##op##_overflow(a, b, &r)) { \
            __ayanami_panic_print_msg(line, col, file.data, file.len, msg, (long)strlen(msg)); \
        } \
        __ayanami_unique_free((void*)file.data); \
        return r; \
    }

#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_i8, int8_t, add, "attempt to add with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_i16, int16_t, add, "attempt to add with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_i32, int32_t, add, "attempt to add with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_i64, int64_t, add, "attempt to add with overflow")
#endif
__AYANAMI_OVF(add_i128, __int128, add, "attempt to add with overflow")
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_u8, uint8_t, add, "attempt to add with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_u16, uint16_t, add, "attempt to add with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_u32, uint32_t, add, "attempt to add with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(add_u64, uint64_t, add, "attempt to add with overflow")
#endif
__AYANAMI_OVF(add_u128, unsigned __int128, add, "attempt to add with overflow")

#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_i8, int8_t, sub, "attempt to subtract with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_i16, int16_t, sub, "attempt to subtract with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_i32, int32_t, sub, "attempt to subtract with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_i64, int64_t, sub, "attempt to subtract with overflow")
#endif
__AYANAMI_OVF(sub_i128, __int128, sub, "attempt to subtract with overflow")
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_u8, uint8_t, sub, "attempt to subtract with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_u16, uint16_t, sub, "attempt to subtract with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_u32, uint32_t, sub, "attempt to subtract with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(sub_u64, uint64_t, sub, "attempt to subtract with overflow")
#endif
__AYANAMI_OVF(sub_u128, unsigned __int128, sub, "attempt to subtract with overflow")

#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_i8, int8_t, mul, "attempt to multiply with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_i16, int16_t, mul, "attempt to multiply with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_i32, int32_t, mul, "attempt to multiply with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_i64, int64_t, mul, "attempt to multiply with overflow")
#endif
__AYANAMI_OVF(mul_i128, __int128, mul, "attempt to multiply with overflow")
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_u8, uint8_t, mul, "attempt to multiply with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_u16, uint16_t, mul, "attempt to multiply with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_u32, uint32_t, mul, "attempt to multiply with overflow")
#endif
#ifndef AYANAMI_ASM_PORT
__AYANAMI_OVF(mul_u64, uint64_t, mul, "attempt to multiply with overflow")
#endif
__AYANAMI_OVF(mul_u128, unsigned __int128, mul, "attempt to multiply with overflow")

#undef __AYANAMI_OVF

// ──────────────────────────────────────────────
//  Contracts (A2d)
// ──────────────────────────────────────────────

#ifndef AYANAMI_ASM_PORT
void __ayanami_require_fail(int64_t line, int64_t col) {
    fprintf(stderr, "requires failed at %ld:%ld\n", (long)line, (long)col);
    abort();
}

void __ayanami_ensure_fail(int64_t line, int64_t col) {
    fprintf(stderr, "ensures failed at %ld:%ld\n", (long)line, (long)col);
    abort();
}

void __ayanami_invariant_fail(int64_t line, int64_t col) {
    fprintf(stderr, "invariant failed at %ld:%ld\n", (long)line, (long)col);
    abort();
}
#endif // AYANAMI_ASM_PORT（契约失败由汇编后端提供）

// ──────────────────────────────────────────────
//  I/O
// ──────────────────────────────────────────────

#ifndef AYANAMI_ASM_PORT
int64_t __ayanami_getchar(void) {
    // 返回 int64 与 Ayanami 的 `int`（i64）ABI 对齐；-1（EOF）必须符号扩展。
    // 注意：不要调用 libc 的 `getchar`（历史符号插入问题），用 fgetc(stdin)。
    return (int64_t)fgetc(stdin);
}

void __ayanami_putchar(int c) {
    putchar(c);
}

void __ayanami_print_int(int64_t n) {
    printf("%ld", (long)n);
}

void __ayanami_print_str(const char *s, int64_t len) {
    fwrite(s, 1, len, stdout);
}

void __ayanami_print_ln(void) {
    printf("\n");
}
#endif // AYANAMI_ASM_PORT（I/O 由汇编后端提供）

// 浮点格式化已迁移为纯 Ayanami 实现（std/src/core/string.aya：fmt_g/to_fixed/to_sci）。

#include "runtime/sys.c"
