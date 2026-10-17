# bitops — 位操作

```ayanami
import "bitops";
```

| 函数 | 说明 |
|---|---|
| `popcount(int x) -> int` | 置位比特数 |
| `leading_zeros(int x) -> int` | 前导零个数（`0` → 64） |
| `trailing_zeros(int x) -> int` | 尾随零个数（`0` → 64） |

```ayanami
import "bitops"
import "io"

println(popcount(255))          // 8
println(trailing_zeros(8))      // 3
println(leading_zeros(1))       // 63
```

> 由运行时 `__builtin_*` 提供（64 位）；负数按补码位模式处理。
