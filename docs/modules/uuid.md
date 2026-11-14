# uuid — UUID v4

```ayanami
import "uuid";
```

| 函数 | 说明 |
|---|---|
| `v4() -> String` | 生成随机 UUID v4（小写、带连字符） |

示例：

```ayanami
import "uuid";
import "io";

fn main() -> int {
    println(v4());   // 形如 f47ac10b-58cc-4372-a567-0e02b2c3d479
    return 0
}
```

约定：

- 版本位/变体位按 RFC 4122（第 13 个十六进制字符恒为 `4`，第 17 个为 `8/9/a/b`）；
- 随机源为 `Rng::from_entropy()`（系统熵），不保证密码学强度之外的用途；
- 输出为 36 字符：`8-4-4-4-12`。
