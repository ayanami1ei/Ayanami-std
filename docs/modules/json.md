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
| `v.render_pretty() -> String` | 缩进（2 空格）序列化（不消费 `v`） |

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

## 解析

| 函数 | 说明 |
|---|---|
| `parse(ref String s) -> Option[Json]` | 解析 JSON 文本（严格） |

```ayanami
import "json";

fn main() -> int {
    v = parse("{\"a\":[1,2,3]}").unwrap();
    println(v.render());   // {"a":[1,2,3]}
    return 0
}
```

- 严格校验：非法字面量、尾逗号、缺值、前导零、多余尾随内容 → `Option::None()`；
- 字符串支持 `\uXXXX` 与代理对，非法转义/控制字符 → `None()`；
- 数字按是否含 `.` / 指数区分 `Json::Int` 与 `Json::Float`；
- 对象保持输入顺序；空数组/空对象正常解析。

## 访问器

复制式访问（字符串返回副本；不暴露内部引用）：

| 方法 | 说明 |
|---|---|
| `is_null()` | 是否 `null` |
| `as_int()` / `as_float()` / `as_bool()` / `as_str()` | 标量取值（类型不符 → None；`as_float` 接受 Int） |
| `len()` | 数组/对象元素数（其他类型 0） |
| `key_at(i)` | 对象第 i 个键（副本） |
| `get_int(key)` / `get_float(key)` / `get_bool(key)` / `get_str(key)` | 对象取值 |
| `get_tag(key)` | 目标值的变体 tag（-1 表示不存在；0=Null 1=Bool 2=Int 3=Float 4=Str 5=Array 6=Object） |
| `at_int(i)` / `at_float(i)` / `at_bool(i)` / `at_str(i)` | 数组元素取值 |
| `at_tag(i)` | 数组元素的变体 tag（越界 → -1） |

```ayanami
v = parse("{\"name\":\"aya\",\"n\":42}").unwrap();
println(v.get_str("name").unwrap());  // aya
println(v.get_int("n").unwrap());     // 42
```
