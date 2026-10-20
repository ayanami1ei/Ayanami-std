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

## 互斥锁（S3）

| API | 说明 |
|---|---|
| `Mutex::new[T](T v)` | 新建（载荷存入 `Slot[T]`） |
| `m.with_lock((ref mut Slot[T] s) -> void { ... })` | 加锁 → 回调 → 解锁 |
| `m.with_lock_get[U]((ref mut Slot[T] s) -> U { ... }) -> U` | 同上，返回回调结果（读取用） |
| `m.lock()` / `m.unlock()` | 显式加锁/解锁（必须配对） |
| `s.get() -> ref T` | 载荷读（值上下文自动解引用） |
| `s.set(T v)` | 替换载荷（旧值 drop） |

实现：futex（0 空闲 / 1 占用 / 2 有等待者）。示例：

```ayanami
m = Mutex::new[int](0);
m.with_lock((ref mut Slot[int] s) -> void { s.set(s.get() + 1) });
v = m.with_lock_get((ref mut Slot[int] s) -> int { s.get() });
```

> `ref mut` 形参只支持字段写（不支持 `*v = ...` 整体写），故载荷用 `Slot.get/set`；
> 闭包按值捕获，读取结果经 `with_lock_get` 返回。

## 待落地（见设计文档 §6）

- **S4 通道**：`Channel[T]`（mpsc）；
- **S5 执行器**：`block_on` + 多线程执行器（衔接编译器 `docs/async.md`）；
- `RwLock[T]`（`with_read`/`with_write` 回调式）与 `fetch_and/or/xor`（cmpxchg 循环）。
