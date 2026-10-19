# sync — 并发原语（S1：原子）

```ayanami
import "sync";
```

并发设计见 `docs/dev/concurrency.md`（M7 `038.1`/#37）。当前阶段 **S1：原子**，
纯内联汇编实现（`core/arch_x86_64.aya`），**无运行时依赖**。

| API | 说明 |
|---|---|
| `AtomicInt::new(int v)` | 新建（初值） |
| `a.load() -> int` | 原子加载（顺序一致） |
| `a.store(int v)` | 原子存储 |
| `a.swap(int v) -> int` | 原子交换，返回旧值 |
| `a.fetch_add(int v) -> int` | 原子加，返回旧值 |
| `a.fetch_sub(int v) -> int` | 原子减，返回旧值 |
| `fence()` | 全内存栅栏（`mfence`） |
| `cpu_relax()` | 自旋提示（`pause`） |

## 内存序

- 默认**顺序一致**（seq_cst）：x86-64 TSO 下普通对齐读写即原子，
  `xchg`/`lock xadd` 自带全栅栏；分层 `Ordering` 随 `038.2` 引入。
- `AtomicInt` 的操作均需 `ref self`（可取地址的值）；共享时经 `ref` 传递。

## 自旋锁

```ayanami
lock = AtomicInt::new(0);
while lock.swap(1) != 0 {
    cpu_relax();
}
// 临界区
lock.store(0);
```

## 待落地（见设计文档 §6）

- **S2 线程**：`Thread::spawn/join`、`current_id`、`yield_now`（运行时 `clone`+futex）；
- **S3 锁**：`Mutex[T]`（`with_lock` 回调式，无 Drop 约束）、`RwLock[T]`；
- **S4 通道**：`Channel[T]`（mpsc）；
- `compare_exchange`/`fetch_and` 等需 clobber 支持（编译器 issue #200）。
