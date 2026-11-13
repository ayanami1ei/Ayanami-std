# json — JSON 工具（字符串转义 / 值模型 / 解析）

```ayanami
import "json";
```

纯 Ayanami 实现；`char` 即字节，非 ASCII 内容按 UTF-8 原样处理。

## 字符串转义

| 函数 | 说明 |
|---|---|
| `escape(ref String s) -> String` | 转义 JSON 字符串内容（不含外层引号） |
| `quote(ref String s) -> String` | `escape` 并加外层引号 |
| `unescape(ref String s) -> Option[String]` | 反转义（支持 `\uXXXX`、代理对；非法 → None） |

```ayanami
println(quote("say \"hi\""));       // "say \"hi\""
println(unescape("\\u4f60\\u597d").unwrap());  // 你好
```

- 控制字符输出为 `\b` `\f` `\n` `\r` `\t` 或 `\u00XX`；
- `unescape` 严格校验：不完整/非法转义、孤立代理对 → `Option::None()`。
