# rand — 伪随机数

```ayanami
import "rand";
```

纯 Ayanami LCG：**确定性**（相同种子 → 相同序列），**非加密**用途。

| API | 说明 |
|---|---|
| `Rng::new(int seed)` | 以种子创建（归一化到 `[1, 2^31)`；`0 → 1`） |
| `r.next_int() -> int` | 步进并返回新状态（`[0, 2^31)`） |
| `r.next_range(int lo, int hi) -> int` | `[lo, hi)` 内的整数；`hi <= lo` 时返回 `lo` |

## 示例（猜数字）

```ayanami
import "rand"
import "io"

fn main() -> int {
    rng = Rng::new(42)              // 固定种子；也可用用户输入作种子
    secret = rng.next_range(0, 100)
    println("Guess the number (0-99):")
    guess = read_int()
    if guess == secret { println("Correct!") }
    return 0
}
```

## 注意

- 相同种子序列相同（可复现，便于测试）；需要不同序列时用不同种子。
- 当前无系统熵源（后续 runtime 扩展会提供 `from_entropy` 类接口）。
- 状态保持在 `[1, 2^31)`，乘法不会溢出（不依赖 wrapping API）。
