# time — 时间

```ayanami
import "time";
```

| 函数 | 说明 |
|---|---|
| `now_millis() -> int` | 单调毫秒（`CLOCK_MONOTONIC`），适合计时/差值 |
| `now_unix() -> int` | Unix 秒（墙上时钟） |
| `elapsed_ms(int start) -> int` | 自 `start`（来自 `now_millis`）起的毫秒差 |
| `sleep_ms(int ms)` | 睡眠 `ms` 毫秒（`<= 0` 直接返回；`nanosleep`，被信号打断自动续睡） |

## 示例

```ayanami
import "time"
import "io"

fn main() -> int {
    t0 = now_millis()
    // ... 工作 ...
    println(now_millis() - t0)   // 毫秒差
    return 0
}
```

## 注意

- 单调时钟不受系统时间调整影响，适合计时；`now_unix` 是墙上时钟。
- 精度为毫秒（运行时不保证纳秒）。
- 由 C 运行时提供（`runtime/sys.c`）；替换运行时实现时需保持同名 ABI。
