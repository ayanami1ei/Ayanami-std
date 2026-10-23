# 运行时后端（backends）

运行时（`runtime/`）按**后端**组织：同一 ABI 契约（`runtime/abi.h` 的符号集 +
`AYANAMI_RUNTIME_ABI=1`）可有多个实现，经 `runtime/backend.sh` 自由切换。

## 目录

| 后端 | 实现 | 说明 |
|---|---|---|
| `c/` | `runtime.c`（含 `sys.c`） | 默认后端（C；gcc 编译） |
| `asm-x86_64/` | `core.s` + `arith.s`（手写汇编）+ 其余 C（`-DAYANAMI_ASM_PORT`） | x86-64 试验后端；已汇编部分：ABI、分配（默认/计数）、显式溢出算术 |

## 用法

```bash
./runtime/backend.sh list
./runtime/backend.sh build asm-x86_64        # → build/runtime/asm-x86_64/libruntime.a（含自检）

# 以指定后端运行命令（设置 AYANAMI_RUNTIME 环境变量）
./runtime/backend.sh run asm-x86_64 -- ayanami run examples/word_count.aya
./runtime/backend.sh run asm-x86_64 -- ./scripts/test.sh

# 或手动接入（等价）
AYANAMI_RUNTIME=$PWD/build/runtime/asm-x86_64/libruntime.a ayanami run prog.aya
```

项目级固定选择：`ayanami.toml`

```toml
[runtime]
path = "/path/to/libruntime.a"     # 支持 .c / .o / .a
```

## 契约

- 每个后端产出**统一归档** `libruntime.a`；编译器把归档作为链接输入（`AYANAMI_RUNTIME` / toml）。
- 符号集以 `runtime/abi.h` 为准；后端必须通过自带自检（`build.sh` 内运行）。
- 弱符号：`__ayanami_unique_alloc/free` 为弱定义，可被用户强定义覆盖（全局分配器；
  Ayanami 内定义当前被编译器限制阻断，见 std issue #195）。
- 新增后端：复制 `backends/<name>/` 结构（`build.sh` + 自检），保证 `build.sh` 产出
  `libruntime.a` 即可；不需要改动 `backend.sh`。

## 汇编后端说明（asm-x86_64）

- 目标平台：Linux x86-64（System V ABI）；调用前 16 字节栈对齐；实现走**原始系统调用**
  （read/write/openat/newfstatat/getdents64/clock_gettime/nanosleep/getrandom/exit_group 等）。
- 已汇编实现（本目录）：
  | 文件 | 内容 |
  |---|---|
  | `core.s` | `__ayanami_runtime_abi`、`default/unique/counted_alloc/free`、`live_allocs` |
  | `arith.s` | `wrapping_*`、`*_overflow`、`saturating_*`（std 已改用内联汇编，保留为 ABI 兼容层） |
  | `io.s` | `getchar/putchar/print_str/print_int（INT64_MIN 安全）/print_ln` |
  | `time.s` | `time_millis/micros/unix/sleep_ms`（EINTR 续睡） |
  | `rand.s` | `random_u64`（getrandom → /dev/urandom → rdtsc） |
  | `fs.s` | 路径助手、`fs_errno/errno_kind/strerror/cstr_len`、`size/mtime/is_file/is_dir/rename/remove/mkdir/rmdir` |
  | `fs_io.s` | `fs_read/write/append/copy/list_data/list_len` |
  | `args_env.s` | `arg_count/arg_len/arg_data`（/proc/self/cmdline）、`env_len/env_data`（environ） |
  | `panic.s` | `panic_print_msg/panic_at/panic_bounds_at`、契约失败、`ovf_{add,sub,mul}_{i8..i64,u8..u64,i128,u128}`、`diag_emit` 弱符号 |
  | `thread.s` / `futex.s` | 线程（pthread + raw syscall）、futex 等待/唤醒 |
- **零 C**：归档仅含上表汇编对象（含 128 位 `ovf_{add,sub,mul}_{i128,u128}` 助手：256 位乘积 + 有符号修正）。
- C 侧对应段以 `-DAYANAMI_ASM_PORT` 排除（`runtime.c`/`runtime/sys.c`）；C 后端不受影响。
- panic 输出为纯文本（C 版的 TTY 彩色未实现）。
