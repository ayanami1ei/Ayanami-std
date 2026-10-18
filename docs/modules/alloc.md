# alloc — 全局分配器（可替换后端）

```ayanami
import "alloc";
```

默认实现由运行时提供（`malloc`/`free` + `live_allocs` 计数）。用户可在程序中导出
同名 `#[extern]` 定义**覆盖**运行时弱符号：整个程序（含编译器生成的分配调用——
`String` 拼接、数组、集合缓冲等）都会走自定义实现。这是 Rust `#[global_allocator]`
在 Ayanami 的对应物。

## 契约（C ABI）

| 符号 | 说明 |
|---|---|
| `usize __ayanami_default_alloc(usize size)` | 默认分配原语（`malloc`；不计数） |
| `void __ayanami_default_free(usize addr)` | 默认释放原语（`free`；0 安全） |
| `usize __ayanami_counted_alloc(usize size)` | 计数分配（std 入口；转发 `unique_alloc`） |
| `void __ayanami_counted_free(usize addr)` | 计数释放（std 入口；转发 `unique_free`） |
| `int __ayanami_live_allocs()` | 存活分配数（计数分配维护） |

> 编译器生成的分配调用走 `__ayanami_unique_alloc/free`（**弱符号**）。
> 在 Ayanami 内导出同名 `#[extern]` 定义即可覆盖；C/汇编实现可经 runtime 归档覆盖。

## 自定义分配器

在程序中导出同名定义即可（无需注册；链接期强符号覆盖弱符号）：

```ayanami
// 转发默认实现（例如做记账/池化的基础）
#[extern]
fn __ayanami_default_alloc(usize size) -> usize;
#[extern]
fn __ayanami_default_free(usize addr);

#[extern]
fn __ayanami_unique_alloc(usize size) -> usize {
    return __ayanami_default_alloc(size)
}

#[extern]
fn __ayanami_unique_free(usize addr) {
    __ayanami_default_free(addr)
}
```

完整可运行示例：`tests/golden/custom_alloc.aya`（Ayanami 内定义覆盖，绕过计数 → `live_allocs` 差值为 0）。

带状态的分配器（统计/arena）可用 C 或汇编实现后与运行时一并归档，经 `AYANAMI_RUNTIME`
接入（见 `runtime/backends/README.md`）；Ayanami 侧无全局可变状态，暂只适合无状态转发/包装。

## std 级接口

```ayanami
fn use_allocator[A: Allocator](ref A a, usize size) -> usize {
    return a.alloc(size)
}
```

| 项 | 说明 |
|---|---|
| `interface Allocator` | `alloc(ref self, usize) -> usize` / `free(ref self, usize)` |
| `DefaultAllocator { }` | 默认实现（运行时计数分配） |
| `live_allocs() -> int` | 存活分配数（诊断/测试） |
| `default_alloc(size) -> usize` / `default_free(addr)` | 默认原语包装 |

## 注意

- 地址用 `usize` 表示（0 = 空/失败）；当前语言无裸指针类型，`usize` 是稳定的 ABI 视图。
- 覆盖后 `live_allocs` 由自定义实现决定是否维护（不维护则为 0）。
- 分配/释放必须配对：`__ayanami_unique_*` 与 `__ayanami_default_*` 不要交叉（覆盖实现内部转发时保持一致）。
