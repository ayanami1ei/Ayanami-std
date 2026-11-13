# csv — CSV 解析与生成

```ayanami
import "csv";
```

RFC 4180 风格，纯 Ayanami 实现。

| 函数 | 说明 |
|---|---|
| `parse(ref String s) -> ArrayList[ArrayList[String]]` | 解析为行 × 字段 |
| `encode(ref ArrayList[ArrayList[String]] rows) -> String` | 生成 CSV 文本（每行 `\n` 结尾） |

示例：

```ayanami
import "csv";
import "io";

fn main() -> int {
    rows = parse("a,\"b,c\",d\n1,2,3");
    println(rows.index(0).index(1));   // b,c
    println(encode(rows));
    return 0
}
```

支持：

- 逗号分隔、双引号包裹字段；
- 引号内 `""` 表示一个字面量 `"`；
- 引号内允许逗号与换行；
- 行尾兼容 `\n` / `\r\n`；
- `encode` 对含 `,` / `"` / 换行的字段自动加引号并转义。

约定：

- 空输入 → 0 行；
- 空字段保留（`a,,c` → 3 个字段）；
- 末尾换行不产生多余空行；
- 未闭合引号按读到结尾处理（宽松解析）。
