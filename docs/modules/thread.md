# thread — 线程（S2）

```ayanami
import "thread";
```

并发设计见 `docs/dev/concurrency.md`（M7 `038.1`/#37）。当前阶段 **S2：线程**。

| API | 说明 |
|---|---|
| `Thread::spawn(Fn() -> void f) -> Thread` | 创建并启动线程；闭包**按值**搬入运行时（所有权转移） |
| `t.join()` | 等待线程结束；闭包已由运行时析构并释放（消费 `Thread`） |
| `current_id() -> int` | 当前线程的内核 tid（`gettid`） |
| `yield_now() -> int` | 让出 CPU（`sched_yield`） |

## 语义

- **所有权**：`spawn` 把闭包（`{env, vtable}` 两字）按值交给运行时；线程入口调用
  `trampoline(env)` 后调用 `drop(env)` 回收捕获值。std 不做 cell 分配，无悬垂风险。
- **join**：等待线程退出（`pthread_join`）。未 join 直接丢弃 `Thread` 只泄漏 pthread
  可连接状态，线程本身仍会完成并清理。
- **失败**：`spawn` 内部创建失败时 handle 为 0；`join(0)` 返回 -1。

## 示例

```ayanami
import "sync";
import "thread";

fn main() -> int {
    a = AtomicInt::new(0);
    unsafe {
        p = ref a as *AtomicInt
        t = Thread::spawn(() -> void { unsafe { (*p).fetch_add(1) } })
        t.join()
    }
    return a.load()
}
```

## 运行时

| 后端 | 实现 |
|---|---|
| C（`runtime/sys.c`） | `pthread_create` / `pthread_join`；`gettid`/`sched_yield` 经 `syscall` |
| 汇编（`runtime/backends/asm-x86_64/thread.s`） | 同上；入口/创建/等待全汇编（`malloc`/`pthread_*` 经 PLT），tid/yield 为 raw syscall |

## 待落地（见设计文档 §6）

- **S3 锁**：`Mutex[T]`（`with_lock` 回调式）、`RwLock[T]`（futex 等待）；
- **S4 通道**：`Channel[T]`（mpsc）；
- **S5 执行器**：`block_on` + 多线程执行器（衔接编译器 `docs/async.md`）。
