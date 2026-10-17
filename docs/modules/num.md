# num — 显式溢出算术

```ayanami
import "num";
```

默认 `+` / `-` / `*` 溢出时 panic；本模块提供显式语义的替代（由运行时无检查算术助手实现）。

| API | 说明 |
|---|---|
| `wrapping_add/sub/mul/neg` | 环绕（溢出回绕） |
| `saturating_add/sub/mul/neg` | 饱和（溢出取 `int` 边界值；`saturating_neg(i64::MIN) == i64::MAX`） |
| `overflowing_add/sub/mul/neg -> Overflowing` | 环绕值 + 溢出标记（`{ value, overflow }`） |
| `checked_add/sub/mul/neg -> Option[int]` | 溢出返回 `None` |
| `add_overflow/sub_overflow/mul_overflow/neg_overflow -> bool` | 单独取溢出标记 |

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

## 实现

- x86-64：`core/arch_x86_64.aya` **内联汇编**（wrapping 直译寄存器运算；overflow 用 OF 标志；
  saturating 用条件跳转取边界值）。
- 运行时的同名 `__ayanami_{wrapping_*,*_overflow,saturating_*}` 保留为 ABI 兼容层（std 不再调用）。
