// abi.h — Ayanami 运行时 ABI 唯一真源（版本 + 全部对外符号声明）
//
// 替换实现时：提供同名符号并保持本头文件的约定即可；用 __ayanami_runtime_abi()
// 校验版本（AYANAMI_RUNTIME_ABI）。
#ifndef AYANAMI_RUNTIME_ABI_H
#define AYANAMI_RUNTIME_ABI_H

#include <stddef.h>
#include <stdint.h>

#define AYANAMI_RUNTIME_ABI 1

// 字符串视图：指针 + 长度（不保证 NUL 结尾）
typedef struct { const char* data; long len; } __ayanami_str_view;
// 诊断缓冲（插件 shim 使用；可写）
typedef struct { char* data; long len; } __ayanami_diag_buf;

int64_t __ayanami_runtime_abi(void);

// ── 分配（唯一所有权） ──
void *__ayanami_default_alloc(size_t size);   // 默认分配原语（malloc；不计计数）
void __ayanami_default_free(void *ptr);       // 默认释放原语（free；NULL 安全）
void *__ayanami_unique_alloc(size_t size);    // 计数分配（弱符号：用户强定义可覆盖）
void __ayanami_unique_free(void *ptr);        // 计数释放（弱符号：用户强定义可覆盖）
void *__ayanami_counted_alloc(size_t size);   // 计数分配（std 入口；转发 unique_alloc）
void __ayanami_counted_free(void *ptr);       // 计数释放（std 入口；转发 unique_free）
int64_t __ayanami_live_allocs(void);

// ── panic（退出码 101） ──
// 底层打印入口（file 以裸指针+长度传入；panic_at/bounds/ovf 均经由它）
void __ayanami_panic_print_msg(long long line, long long col, const char *file, long file_len,
                               const char *msg, long msg_len);
void __ayanami_panic_at(long long line, long long col, __ayanami_str_view file, __ayanami_str_view msg);
void __ayanami_panic_bounds_at(long long line, long long col, __ayanami_str_view file,
                               long long index, long long len);

// ── 契约失败（abort） ──
void __ayanami_require_fail(int64_t line, int64_t col);
void __ayanami_ensure_fail(int64_t line, int64_t col);
void __ayanami_invariant_fail(int64_t line, int64_t col);

// ── I/O ──
int64_t __ayanami_getchar(void);
void __ayanami_putchar(int c);
void __ayanami_print_int(int64_t n);
void __ayanami_print_str(const char *s, int64_t len);
void __ayanami_print_ln(void);
char *__ayanami_float_str(double n, int64_t out_len);
char *__ayanami_float_fixed_str(double n, int64_t digits, int64_t out_len);
char *__ayanami_float_sci_str(double n, int64_t digits, int64_t out_len);

// ── 数学 ──

// ── 诊断通道（弱符号；插件 shim 可提供强定义） ──
void __ayanami_diag_emit(long long level, __ayanami_diag_buf msg);

// ── 溢出检查（M1.7；编译器在 debug 构建下调用） ──
#define __AYANAMI_OVF_DECL(name, T) \
    T __ayanami_ovf_##name(T a, T b, long long line, long long col, __ayanami_str_view file);
__AYANAMI_OVF_DECL(add_i8, int8_t)
__AYANAMI_OVF_DECL(add_i16, int16_t)
__AYANAMI_OVF_DECL(add_i32, int32_t)
__AYANAMI_OVF_DECL(add_i64, int64_t)
__AYANAMI_OVF_DECL(add_i128, __int128)
__AYANAMI_OVF_DECL(add_u8, uint8_t)
__AYANAMI_OVF_DECL(add_u16, uint16_t)
__AYANAMI_OVF_DECL(add_u32, uint32_t)
__AYANAMI_OVF_DECL(add_u64, uint64_t)
__AYANAMI_OVF_DECL(add_u128, unsigned __int128)
__AYANAMI_OVF_DECL(sub_i8, int8_t)
__AYANAMI_OVF_DECL(sub_i16, int16_t)
__AYANAMI_OVF_DECL(sub_i32, int32_t)
__AYANAMI_OVF_DECL(sub_i64, int64_t)
__AYANAMI_OVF_DECL(sub_i128, __int128)
__AYANAMI_OVF_DECL(sub_u8, uint8_t)
__AYANAMI_OVF_DECL(sub_u16, uint16_t)
__AYANAMI_OVF_DECL(sub_u32, uint32_t)
__AYANAMI_OVF_DECL(sub_u64, uint64_t)
__AYANAMI_OVF_DECL(sub_u128, unsigned __int128)
__AYANAMI_OVF_DECL(mul_i8, int8_t)
__AYANAMI_OVF_DECL(mul_i16, int16_t)
__AYANAMI_OVF_DECL(mul_i32, int32_t)
__AYANAMI_OVF_DECL(mul_i64, int64_t)
__AYANAMI_OVF_DECL(mul_i128, __int128)
__AYANAMI_OVF_DECL(mul_u8, uint8_t)
__AYANAMI_OVF_DECL(mul_u16, uint16_t)
__AYANAMI_OVF_DECL(mul_u32, uint32_t)
__AYANAMI_OVF_DECL(mul_u64, uint64_t)
__AYANAMI_OVF_DECL(mul_u128, unsigned __int128)
#undef __AYANAMI_OVF_DECL

// ── 系统扩展 ──
int64_t __ayanami_random_u64(void);   // 系统熵源（getrandom / /dev/urandom）
int64_t __ayanami_time_millis(void);  // 单调毫秒（计时用）
int64_t __ayanami_time_unix(void);
int64_t __ayanami_time_micros(void);    // Unix 秒

// ── 文件（缓冲区由 unique_alloc 分配，调用方用 unique_free 释放） ──
int64_t __ayanami_fs_size(__ayanami_str_view path);   // 字节数；-1 不存在/出错
char *__ayanami_fs_read(__ayanami_str_view path);     // unique_alloc 缓冲（NUL 结尾）；NULL 出错
int64_t __ayanami_fs_write(__ayanami_str_view path, __ayanami_str_view data); // 0 成功 / -1
int64_t __ayanami_fs_append(__ayanami_str_view path, __ayanami_str_view data); // 追加；0 成功 / -1
int64_t __ayanami_fs_remove(__ayanami_str_view path); // 删除文件；0 成功 / -1
int64_t __ayanami_fs_copy(__ayanami_str_view src, __ayanami_str_view dst); // 复制文件；0 成功 / -1
int64_t __ayanami_fs_rename(__ayanami_str_view from, __ayanami_str_view to); // 重命名/移动；0 成功 / -1
int64_t __ayanami_fs_mkdir(__ayanami_str_view path); // 创建目录；0 成功 / -1
int64_t __ayanami_fs_rmdir(__ayanami_str_view path); // 删除空目录；0 成功 / -1
int64_t __ayanami_fs_mtime(__ayanami_str_view path); // 修改时间（Unix 秒）；-1 失败
int64_t __ayanami_fs_is_file(__ayanami_str_view path); // 1 普通文件 / 0 否
int64_t __ayanami_fs_is_dir(__ayanami_str_view path); // 1 目录 / 0 否
char *__ayanami_fs_list_data(__ayanami_str_view path); // 目录项 '\n' 连接（unique_alloc、NUL 结尾）；NULL 失败
int64_t __ayanami_fs_list_len(void); // 最近一次 list_data 的字节长度

// ── 文件错误信息（std fs 错误模型） ──
int64_t __ayanami_fs_errno(void);            // 最近一次 fs 失败 errno
int64_t __ayanami_fs_errno_kind(int64_t e);  // errno → 稳定类别码（0..7，见 sys.c）
char *__ayanami_fs_strerror(int64_t e);      // strerror 拷贝（unique_alloc，调用方拥有）
int64_t __ayanami_cstr_len(const char *s);   // C 串长度（NULL → 0）

// ── 命令行参数 / 环境变量（返回值为 unique_alloc 拷贝） ──
int64_t __ayanami_arg_count(void);                    // argc（含程序名）
int64_t __ayanami_arg_len(int64_t i);                 // 第 i 个参数长度；-1 越界
char *__ayanami_arg_data(int64_t i);                  // unique_alloc 拷贝；NULL 越界
int64_t __ayanami_env_len(__ayanami_str_view name);   // 值长度；-1 缺失
char *__ayanami_env_data(__ayanami_str_view name);    // unique_alloc 拷贝；NULL 缺失

#endif

// ── 显式溢出算术（std core/num.aya） ──
int64_t __ayanami_wrapping_add(int64_t a, int64_t b);
int64_t __ayanami_wrapping_sub(int64_t a, int64_t b);
int64_t __ayanami_wrapping_mul(int64_t a, int64_t b);
int64_t __ayanami_wrapping_neg(int64_t a);
int64_t __ayanami_add_overflow(int64_t a, int64_t b);
int64_t __ayanami_sub_overflow(int64_t a, int64_t b);
int64_t __ayanami_mul_overflow(int64_t a, int64_t b);
int64_t __ayanami_saturating_add(int64_t a, int64_t b);
int64_t __ayanami_saturating_sub(int64_t a, int64_t b);
int64_t __ayanami_saturating_mul(int64_t a, int64_t b);
