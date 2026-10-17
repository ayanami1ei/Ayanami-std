# num — 显式溢出算术

```ayanami
import "num";
```

默认 `+` / `-` / `*` 溢出时 panic；本模块提供显式语义的替代（由运行时无检查算术助手实现）。

| API | 说明 |
|---|---|
| `wrapping_add/sub/mul/neg` | 环绕（溢出回绕） |
| `saturating_add/sub/mul` | 饱和（溢出取 `int` 边界值） |
| `overflowing_add/sub/mul -> Overflowing` | 环绕值 + 溢出标记（`{ value, overflow }`） |
| `checked_add/sub/mul -> Option[int]` | 溢出返回 `None` |
| `add_overflow/sub_overflow/mul_overflow -> bool` | 单独取溢出标记 |

```ayanami
import "num"
import "io"

fn main() -> int {
    max = 9223372036854775807
    println(wrapping_add(max, 1))            // -9223372036854775808（回绕）
    println(saturating_add(max, 1))          // 9223372036854775807（饱和）
    println(checked_add(max, 1).is_none())   // true
    return 0
}
```
