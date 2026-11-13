# bitops — 位操作

```ayanami
import "bitops";
```

| 函数 | 说明 |
|---|---|
| `popcount(int x) -> int` | 置位比特数 |
| `is_power_of_two(int x) -> bool` | 是否 2 的幂（`x > 0` 且仅一个置位） |
| `leading_zeros(int x) -> int` | 前导零个数（`0` → 64） |
| `trailing_zeros(int x) -> int` | 尾随零个数（`0` → 64） |
| `rotl(int x, int n) -> int` | 循环左移（64 位，`n` 对 64 取模） |
| `rotr(int x, int n) -> int` | 循环右移（64 位） |
| `bit_length(int x) -> int` | 有效位数（`0` → 0） |
| `reverse_bits(int x) -> int` | 按位反转（64 位） |
| `swap_bytes(int x) -> int` | 字节序翻转（bswap64） |
| `next_power_of_two(int n) -> int` | ≥ n 的最小 2 的幂（`n <= 1` → 1） |

```ayanami
import "bitops"
import "io"

println(popcount(255))          // 8
println(trailing_zeros(8))      // 3
println(leading_zeros(1))       // 63
```

> **纯 Ayanami 实现**（移位循环），不依赖 C 内置函数；负数按补码位模式处理（64 位）。
