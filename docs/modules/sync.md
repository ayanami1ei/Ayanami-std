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
| `a.fetch_and/or/xor(int v) -> int` | 原子位运算（CAS 循环），返回旧值 |
| `a.compare_exchange(int expected, int new) -> int` | 原子比较交换，返回旧值（`old == expected` 成功） |
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
| `Mutex::new[T](T v)` | 新建 |
| `m.with_lock((ref mut T v) -> U { ... }) -> U` | 加锁 → 回调 → 解锁；返回回调结果（void 可作语句） |
| `m.try_with_lock(...) -> Option[U]` | 尝试加锁（不阻塞）；已被占用 → `None` |
| `m.lock()` / `m.unlock()` | 显式加锁/解锁（必须配对） |
| `m.data() -> ref mut T` | 载荷（仅持锁期间使用） |

实现：futex（0 空闲 / 1 占用 / 2 有等待者）。示例：

```ayanami
m = Mutex::new[int](0);
m.with_lock((ref mut int v) -> void { *v = *v + 1 });
v = m.with_lock((ref mut int v) -> int { *v });
```

## 读写锁（S3）

| API | 说明 |
|---|---|
| `RwLock::new[T](T v)` | 新建 |
| `l.with_read((ref T v) -> U { ... }) -> U` | 读锁（多读者并发） |
| `l.with_write((ref mut T v) -> U { ... }) -> U` | 写锁（独占） |
| `l.try_with_read/try_with_write(...) -> Option[U]` | 尝试加锁（不阻塞） |
| `l.lock_read()/unlock_read()`、`l.lock_write()/unlock_write()` | 显式加解锁（必须配对） |

状态字：`0` 空闲 / `n>0` 读者数 / `-1` 写者持有；另有 `writers` 原子计数登记等待写者。
**写者优先**：存在等待写者时新读者等待（`try_with_read` 同样返回 `None`），
读者释放最后一个时唤醒全部（写者可竞争获取），写者释放时唤醒全部。

```ayanami
l = RwLock::new[int](5);
v = l.with_read((ref int x) -> int { *x });
l.with_write((ref mut int x) -> void { *x = *x + 1 });
```

## 待落地（见设计文档 §6）

- **S4 通道**：`Channel[T]`（mpsc）；
- **S5 执行器**：`block_on` + 多线程执行器（衔接编译器 `docs/async.md`）；
- `fetch_and/or/xor`（cmpxchg 循环）；写者饥饿策略（公平锁）。
