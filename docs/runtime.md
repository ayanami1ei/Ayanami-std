# runtime — C 运行时

`runtime.c` 是标准库的底层运行时（C 源码）：唯一所有权分配、运行时 panic、契约失败、
字符 / 整数 / 浮点 I/O。它不是预编译库——每个程序在链接阶段由 `gcc` 把它与编译器产出的
目标文件一起编译。

## 谁在用它

- 编译器 driver 按顺序查找 runtime：可执行文件同目录 →（开发态）向上找到 `Cargo.toml` 后取
  `src/runtime.c` → 报错。
- 主仓的 `src/runtime.c` 是指向本仓库 `runtime.c` 的**符号链接**；发布打包会把它复制到
  `install/runtime.c`。
- 修改本文件后**无需重编编译器**：下一次链接程序时生效。

## 对外符号（ABI，`extern "C"`）

| 符号 | 说明 |
|---|---|
| `__ayanami_unique_alloc(size) -> void*` | 堆分配（计入 live_allocs） |
| `__ayanami_unique_free(ptr)` | 释放 |
| `__ayanami_live_allocs() -> int64_t` | 存活分配计数（测试用） |
| `__ayanami_panic_at(line, col, file, msg)` | Rust 风格 panic，退出码 101 |
| `__ayanami_panic_bounds_at(line, col, file, index, len)` | 越界 panic |
| `__ayanami_require_fail / ensure_fail / invariant_fail(line, col)` | 契约失败：打印后 `abort()` |
| `__ayanami_getchar()` / `__ayanami_putchar(c)` | 字符 I/O |
| `__ayanami_print_int(n)` / `__ayanami_print_str(data, len)` / `__ayanami_print_ln()` | 输出 |
| `__ayanami_float_len(n)` / `__ayanami_float_str(n, len)` | `%g` 格式化浮点 |
| `__ayanami_int_to_char(n) -> char` | int → char |
| `__ayanami_sqrt / floor / ceil(x) -> double` | 数学（libm） |
| `__ayanami_diag_emit(level, {data, len})` | 诊断通道**弱符号**（插件 shim 可提供强定义覆盖） |

## 约定

- 字符串跨 FFI 用「指针 + 长度」视图，不保证 NUL 结尾（如 `print_str(data, len)`）。
- 整型统一 64 位（`int64_t` / `long long`）。
- panic 输出到 stderr；`NO_COLOR` 设置或非 TTY 时不着色。
- 只依赖 libc + libm。

## 扩展步骤

1. 在 `runtime.c` 增加 `__ayanami_*` 函数（保持 C ABI 与 64 位整型约定）。
2. 在相应 std 模块中 `extern "C" fn __ayanami_xxx(...)` 声明，再包一层 `pub fn`。
3. 跑 `./scripts/test.sh` 回归；新增用例按 [testing.md](testing.md) 登记。

> 规划中的运行时扩展（随教程需要排期）：文件 IO、时间、随机熵源、命令行参数 / 环境变量。
> 这些属于标准库自身的演进，不再需要编译器仓改动。

## 项目结构（2026-10）

- `runtime.c`：**聚合入口**（编译器链接此文件）；`runtime/abi.h`：ABI 唯一真源；
  `runtime/sys.c`：系统扩展（熵源 / 时间）；`runtime/build.sh`：构建 `libruntime.a` 与 C 自检。
- 替换：把实现同名 ABI 的 `runtime.c` 放到**可执行文件同目录**（编译器查找优先级最高）；
  用 `__ayanami_runtime_abi()` 校验版本（当前 `1`）。
- 系统扩展：`__ayanami_random_u64()`、`__ayanami_time_millis()`、`__ayanami_time_unix()`；
  文件 `__ayanami_fs_size/read/write`；参数与环境 `__ayanami_arg_count/arg_len/arg_data`、`__ayanami_env_len/env_data`。
