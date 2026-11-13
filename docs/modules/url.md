# url — URL 百分号编码与查询串解析

```ayanami
import "url";
```

| 函数 | 说明 |
|---|---|
| `percent_encode(ref String s) -> String` | 百分号编码（RFC 3986 unreserved 之外全部编码，空格 → `%20`） |
| `percent_decode(ref String s) -> Option[String]` | 严格百分号解码（非法 `%` 序列 → None；`+` 不特殊处理） |
| `form_decode(ref String s) -> Option[String]` | 表单解码：`+` → 空格，再百分号解码 |
| `query_get(ref String query, ref String key) -> Option[String]` | 从查询串取参数（键值均按表单规则解码） |

示例：

```ayanami
import "url";
import "io";

fn main() -> int {
    println(percent_encode(ref "a b&c"));   // a%20b%26c
    println(percent_decode(ref "a%20b").unwrap());  // a b
    println(query_get(ref "?name=hello%20world&n=1", ref "name").unwrap());
    // hello world
    return 0
}
```

约定：

- `percent_encode` 保留 `A-Z a-z 0-9 - . _ ~`，其余字节编码为大写十六进制；
- `percent_decode` / `form_decode` 遇到不完整或非法的 `%` 序列返回 `Option::None()`；
- `query_get` 的 `query` 可带前导 `?`；无 `=` 的参数视为空值；
- 输入按字节处理（UTF-8 字符串编码后解码可还原原有字节）。
