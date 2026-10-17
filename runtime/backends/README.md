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

- 目标平台：Linux x86-64（System V ABI）；调用前 16 字节栈对齐。
- `core.s`：`__ayanami_runtime_abi`、`__ayanami_default_alloc/free`（malloc/free）、
  `__ayanami_unique_alloc/free`（弱符号，计数）、`__ayanami_counted_alloc/free`、`__ayanami_live_allocs`。
- `arith.s`：`wrapping_*`（回绕）、`*_overflow`（OF 标志）、`saturating_*`（边界值）。
- 其余部分暂用 C（`runtime.c` 以 `-DAYANAMI_ASM_PORT` 排除已汇编段），按需继续迁移
  （panic/IO/fs/时间/熵）。
