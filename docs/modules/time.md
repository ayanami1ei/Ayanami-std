# time — 时间

```ayanami
import "time";
```

| 函数 | 说明 |
|---|---|
| `now_millis() -> int` | 单调毫秒（`CLOCK_MONOTONIC`），适合计时/差值 |
| `now_unix() -> int` | Unix 秒（墙上时钟） |
| `now_unix_ms() -> int` | Unix 毫秒（墙上时钟，毫秒精度） |
| `now_micros() -> int` | 单调微秒（计时用） |
| `format_ms(int ms) -> String` | 毫秒格式化 `HH:MM:SS.mmm` |
| `elapsed_ms(int start) -> int` | 自 `start`（来自 `now_millis`）起的毫秒差 |
| `sleep_ms(int ms)` | 睡眠 `ms` 毫秒（`<= 0` 直接返回；`nanosleep`，被信号打断自动续睡） |
| `sleep_us(int us)` | 睡眠 `us` 微秒（同上） |
| `DateTime::from_unix(int unix) -> DateTime` | Unix 秒 → UTC 分解（年月日时分秒 + 星期） |
| `format_unix(int unix) -> String` | Unix 秒 → `YYYY-MM-DD HH:MM:SS`（UTC） |
| `format_date(int unix) -> String` | Unix 秒 → `YYYY-MM-DD`（UTC） |

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

## 示例：日期时间（UTC）

```ayanami
import "time"
import "io"

fn main() -> int {
    d = DateTime::from_unix(1709210096)
    println(d.year)          // 2024
    println(d.month)         // 2
    println(d.day)           // 29
    println(d.weekday)       // 4（0=周日）
    println(format_unix(0))  // 1970-01-01 00:00:00
    println(format_date(1709210096))  // 2024-02-29
    return 0
}
```

> `DateTime` 分解为纯 Ayanami 实现（civil_from_days），不依赖系统时区；目前均按 UTC。
> `weekday`：0=周日、1=周一 … 6=周六。

## 示例：耗时格式化

```ayanami
import "time"
import "io"

fn main() -> int {
    t0 = now_millis()
    sleep_ms(20)
    println(format_ms(now_millis() - t0))   // 形如 00:00:00.020
    println(format_ms(3723004))             // 01:02:03.004
    return 0
}
```
