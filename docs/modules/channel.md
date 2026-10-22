# channel — 多生产者单消费者通道（S4）

```ayanami
import "channel";
```

并发设计见 `docs/dev/concurrency.md`（M7 `038.1`/#37）。当前阶段 **S4：通道（mpsc）**。

| API | 说明 |
|---|---|
| `Channel::new[T]()` | 新建 |
| `c.send(T v)` | 发送（多生产者安全；唤醒一个等待接收者） |
| `c.recv() -> T` | 阻塞接收（无数据时 futex 等待） |
| `c.try_recv() -> Option[T]` | 非阻塞接收（无数据 → `None`） |

## 语义

- **顺序**：FIFO（双栈队列，均摊 O(1)：send 入 `in_stack`，recv 时倒到 `out_stack`）。
- **多生产者**：`send` 经 `Mutex` 保护，任意线程可并发发送；接收端单消费者。
- **唤醒**：`Channel` 内 `seq` 原子字，send 后递增并 `futex_wake`；recv 采样的顺序为
  「先取队列 → 再采样 seq → 等待」，避免丢失唤醒。
- **关闭**：暂不提供 `close`（recv 阻塞至有数据）；`try_recv` 区分“空”。

## 示例

```ayanami
import "channel";
import "thread";

fn main() -> int {
    c = Channel::new[int]();
    unsafe {
        pc = ref c as *Channel[int]
        Thread::spawn(() -> void { unsafe { (*pc).send(42) } });
    }
    return c.recv()      // 42
}
```

## 运行时

仅依赖 `sync` 的 futex 原语（`__ayanami_futex_wait/wake`，C/汇编两后端均已实现）。

## 待落地（见设计文档 §6）

- **S5 执行器**：`block_on` + 多线程执行器（衔接编译器 `docs/async.md`）；
- `close()` 与 `recv` 的关闭语义；有界通道 / 背压。
