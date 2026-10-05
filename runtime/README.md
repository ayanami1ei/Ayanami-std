# runtime — C 运行时（项目化 + 替换指南）

## 结构

- `../runtime.c`：**聚合入口**——编译器链接的就是它，内部 `#include` `abi.h` 与各实现文件
- `abi.h`：**ABI 唯一真源**（版本宏 + 全部 `__ayanami_*` 声明与类型约定）
- `sys.c`：系统扩展（系统熵源 / 时间），被聚合包含
- `build.sh`：构建 `libruntime.a`；`--test` 跑 C 侧 ABI 自检
- `abi_selftest.c`：ABI 一致性自检（版本、分配计数、时间）

## 替换方式

1. **今天可用**：实现同名 ABI 的 `runtime.c` 放到**可执行文件同目录**（编译器查找优先级最高）；
2. 编译器侧排期中：`ayanami.toml [runtime] path`、`AYANAMI_RUNTIME` 环境变量、直接链接 `libruntime.a`
   （需要 `-lm`）。

## ABI 约定

- 整型统一 64 位（`int64_t`）；字符串用「指针 + 长度」视图，不保证 NUL 结尾；
- panic 输出 stderr、退出码 101；`__ayanami_runtime_abi()` 返回 `AYANAMI_RUNTIME_ABI`；
- 校验：`./runtime/build.sh --test` + 标准库 `./scripts/test.sh`（panic/io/集合行为）。

## 修改运行时

改 `runtime.c` / `runtime/sys.c` 后**无需重编编译器**：下一次链接程序即生效。
新增符号请先加进 `abi.h`，并在 `abi_selftest.c` 或标准库测试中覆盖。
