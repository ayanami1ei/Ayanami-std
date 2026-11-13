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

## 值模型与序列化

```ayanami
pub enum Json {
    Null,
    Bool(bool),
    Int(int),
    Float(float),
    Str(String),
    Array(ArrayList[Json]),
    Object(ArrayList[JsonField]),
}

pub struct JsonField { String key; Json value }
```

| 构造 | 说明 |
|---|---|
| `Json::Null` / `Json::Bool(b)` / `Json::Int(v)` / `Json::Float(f)` / `Json::Str(s)` | 标量 |
| `Json::Array(ArrayList[Json])` | 数组 |
| `Json::Object(ArrayList[JsonField])` | 对象（保持插入顺序） |
| `JsonField::new(key, value)` | 对象成员 |

| 方法 | 说明 |
|---|---|
| `v.render() -> String` | 序列化为 JSON 文本（按引用遍历，不消费 `v`） |

```ayanami
import "json";
import "arraylist";
import "io";

fn main() -> int {
    fields = ArrayList::new[JsonField]();
    fields.push(JsonField::new("name", Json::Str("ayanami")));
    fields.push(JsonField::new("ok", Json::Bool(true)));
    println(Json::Object(fields).render());  // {"name":"ayanami","ok":true}
    return 0
}
```

- `Float` 的 NaN / Inf 输出 `null`（避免非法 JSON）；
- `render` 不消费值，可重复调用。
