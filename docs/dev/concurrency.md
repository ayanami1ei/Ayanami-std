# 并发（多线程）设计 — std 侧

> 状态：**设计提案（Proposed）**（2026-10-19）。关联：bd `038.1`/`038.2`、GitHub #37；
> 异步侧见编译器仓 `docs/async.md`（`038.4`/#63——编译器只提供 `Future`/`Poll`/`Waker` 协议，
> 执行器与原语归 std/用户）。
>
> 本文冻结 **std 公开接口形态**；实现按 §6 分阶段落地（S1 已实现）。

## 1. 语言现状约束（决定接口形态）

| 能力 | 现状 | 对设计的影响 |
|---|---|---|
| `Drop` | 无 | **不能做 RAII 守卫**（无 `MutexGuard`）→ 回调式 `with_lock` 或显式 `lock/unlock` |
| 生命周期 | 无 | 不从 `lock()` 返回借用 `ref mut T` → 载荷经回调参数传递 |
| 闭包 | `Fn(T) -> U` 接口（`{env, vtable}` 两字）✓ | `spawn`/`with_lock` 接收闭包；跨线程搬运闭包 = 搬两字 |
| 裸指针 | `*T` + `unsafe` 转换/`bits::reinterpret` ✓ | 运行时边界经 `usize`/`*T` 传递 |
| 内联汇编 | `in/out(reg)` ✓；**无 clobber**（#200） | 原子只用声明操作数完成（`xchg`/`lock xadd`）；`cmpxchg`（固定 `%rax`）待 #200 |
| `Send`/`Sync` | 无类型系统 | §5 规则 + 文档约定；标记接口见 `038.2` |

## 2. 目标与非目标

- 目标：**可用、可验证、可替换**的最小并发面：原子、线程、互斥/读写锁、通道；
  全部实现只依赖语言自身 + 机器层（系统调用/内联汇编），不引入第三方运行时。
- 非目标：协程栈、跨进程共享内存、信号、异步语法（编译器侧 `038.4`）、
  `Send`/`Sync` 类型系统（`038.2` 另行）。

## 3. 公开接口（std）

### 3.1 原子 — `system/sync.aya`（机器层 `core/arch_x86_64.aya`）

```ayanami
pub struct AtomicInt { int value }

impl AtomicInt {
    pub fn new(int v) -> AtomicInt
    pub fn load(ref self) -> int                 // 顺序一致
    pub fn store(ref self, int v)
    pub fn swap(ref self, int v) -> int          // 返回旧值
    pub fn fetch_add(ref self, int v) -> int     // 返回旧值
    pub fn fetch_sub(ref self, int v) -> int
    // compare_exchange / fetch_and / fetch_or / fetch_xor：待 #200（cmpxchg 需 %rax）
}

pub fn fence()      // 全内存栅栏（mfence）
pub fn cpu_relax()  // 自旋提示（pause）
```

- 内存序：**默认顺序一致**（seq_cst）。x86-64 上普通对齐读写即原子；
  `xchg`/`lock xadd` 自带全栅栏。分层 `Ordering` 枚举在 `038.2` 一并定。
- 自旋锁可由 `swap` 直接构造（`while swap(lock, 1) != 0 { cpu_relax() }`）。

### 3.2 线程 — `system/thread.aya`

```ayanami
pub struct Thread { usize handle; usize cell }

impl Thread {
    pub fn spawn[F: Fn() -> void](F f) -> Thread   // 闭包按值搬入线程
    pub fn join(self) -> void                       // 等待 + 析构闭包（值 drop）
}

pub fn current_id() -> int      // 线程 id（内核 tid）
pub fn yield_now()              // sched_yield
pub fn sleep_ms(int)            // 复用 system/time
```

### 3.3 互斥/读写锁 — `system/sync.aya`

```ayanami
pub struct Mutex[T] { int state; T payload }

impl[T] Mutex[T] {
    pub fn new(T v) -> Mutex[T]
    pub fn with_lock[F: Fn(ref mut T) -> void](ref self, F f)   // 回调式（推荐）
    pub fn lock(ref self)        // 显式式（无 Drop 的折中）
    pub fn unlock(ref self)
    pub fn data(ref mut self) -> ref mut T                      // 仅持锁期间调用（文档约定）
}

pub struct RwLock[T] { int state; T payload }
// with_read[F: Fn(ref T) -> void] / with_write[F: Fn(ref mut T) -> void]
```

### 3.4 通道 — `system/channel.aya`（后续）

```ayanami
pub struct Channel[T] { ... }       // mpsc：多生产者单消费者
pub fn send(ref self, T v)          // 阻塞（缓冲满时）
pub fn recv(ref self) -> T          // 阻塞（空时）
pub fn try_recv(ref self) -> Option[T]
```

## 4. 机器层与运行时 ABI

### 4.1 原子（内联汇编，无运行时依赖）

| 操作 | 模板（`$0`=输出、`$1..`=输入） |
|---|---|
| load | `movq ($1), $0` |
| store | `movq $1, ($0)`（无输出） |
| swap | `movq $2, $0` + `xchgq $0, ($1)`（`out(early reg)`） |
| fetch_add | `movq $2, $0` + `lock xaddq $0, ($1)` |
| fetch_sub | `movq $2, $0` + `negq $0` + `lock xaddq $0, ($1)` |
| fence / relax | `mfence` / `pause`（零操作数 asm ✓） |

`cmpxchg`（固定 `%rax`）与 `syscall`（破坏 `%rcx/%r11`）需 clobber 支持（#200）。

### 4.2 futex（锁/通道/唤醒的等待原语）

```c
int64_t __ayanami_futex_wait(int32_t *addr, int32_t expected);  // FUTEX_WAIT
int64_t __ayanami_futex_wake(int32_t *addr, int32_t n);         // FUTEX_WAKE
```

- C 后端：`syscall(SYS_futex, ...)`；汇编后端：raw syscall（202）。EINTR 返回 0（调用方自旋重查）。
- std 侧封装：`wait(state, expected)` / `wake(n)`（`ref int` → 地址经 `*T`/`reinterpret`）。

### 4.3 线程（`clone` + futex，或 pthread 兜底）

```c
usize __ayanami_thread_spawn(usize cell);   // 新线程运行 cell 中的闭包；返回 handle（tid）
int64_t __ayanami_thread_join(usize handle); // 等待退出（futex on exit word）
int64_t __ayanami_thread_id(void);           // gettid
int64_t __ayanami_thread_yield(void);        // sched_yield
```

**闭包 cell 约定**（std 与运行时的唯一契约）：

1. std `spawn[F]` 用 `Ptr::new(f)`（或分配器）把闭包按值放到堆上，cell 起始即闭包值
   `{env, vtable}`（16 字节；捕获型 env = 堆环境指针）；
2. 运行时入口（汇编）读取 `env = [cell]`、`trampoline = [[cell+8]+8]`，调用
   `trampoline(env)`（即闭包调用约定），随后写 exit word + futex wake；
3. **析构归 std**：`join` 后把 cell 中的闭包按值 drop（捕获值回收），再释放 cell。
   运行时不需要知道 `F`，也不需要 drop glue。

> 说明：`extern "C"` 签名可写裸 `fn(...)` 且实参支持直接函数名（`docs/closures.md`），
> 因此 `spawn` 内部可把入口函数名传给运行时；cell 指针经 `Ptr[T].as_ptr()` + `ptrtoint` 传递。

### 4.4 内存序与可见性

- x86-64 TSO：普通对齐 load/store 不重排（load-load、store-store 有序），
  `lock` 前缀操作 = 全栅栏；跨核可见性由 `lock`/`mfence` 保证。
- std 默认 seq_cst；放松序（Relaxed/Acquire/Release）随 `038.2` 引入。

## 5. Send / Sync-lite 规则（文档约定，类型系统见 038.2）

- **值语义移动即 Send**：`spawn`/`send` 按值搬入（所有权唯一）✓。
- **共享可变状态必须经 `AtomicInt`/`Mutex[T]`**：语言无 `ref` 存储 → 不存在隐式别名，
  这是“默认无数据竞争”的结构性保证。
- **不可跨线程**：`ref T`/`ref mut T`（调用栈借用）、裸指针 `*T`（除非 `unsafe` 显式转移）。
- `Mutex[T]` 的 `T` 应为 Send（按上述规则，值类型天然满足）；`AtomicInt` 自身可共享。
- 未来（`038.2`）：`Send`/`Sync` 作为标记接口 + 效应标注（如 `#[thread_safe]`）纳入类型检查。

## 6. 阶段与验收

| 阶段 | 内容 | 验收 | 状态 |
|---|---|---|---|
| **S1** | `AtomicInt` + `fence`/`cpu_relax`（纯内联汇编） | 单线程语义测试（load/store/swap/fetch_*/自旋锁）；零运行时依赖 | ✅ 本批 |
| **S2** | 线程：`spawn`/`join`/`current_id`/`yield_now`（运行时 `clone`+futex，asm 后端 raw syscall） | 多线程计数器（原子累加）、闭包捕获析构、join 语义、`thread_test` | 待做 |
| **S3** | `Mutex[T]`/`RwLock[T]`（futex + 自旋退化） | 多线程互斥累加、`with_lock` 回调、争用基准 | 待做 |
| **S4** | `Channel[T]`（mpsc；Mutex + futex 等待队列） | 生产者/消费者、关闭语义、`try_recv` | 待做 |
| **S5** | 最简 `block_on` + 多线程执行器（衔接 `038.4`） | 跨线程轮询、`Waker` = 原子 + futex wake | 待做（依赖编译器 async） |

约定：每阶段含 `tests/unit/*_test.aya` + `docs/modules/*.md`；汇编后端与 C 后端行为一致
（`runtime/backends/` 同步补 `__ayanami_futex_*`/`__ayanami_thread_*`）；SYMBOLS 门禁与零告警门禁照常。

## 7. 与异步（`038.4`）的衔接

- `Waker`（`docs/async.md` §3.2）最小实现 = `AtomicInt`（就绪标记）+ `futex_wake`；
  单线程 `block_on` = 轮询 + `cpu_relax`/`yield`，多线程执行器 = `Thread` + `Channel`。
- 状态机是普通值 → 可搬进线程轮询（`Send` 规则同上）；执行器经 `env::runtime` 注入
  （`docs/env-injection.md`），std 执行器只是可选默认实现。
