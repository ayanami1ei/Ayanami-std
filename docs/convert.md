# convert — 解析与转换

```ayanami
import "convert";
```

## 严格解析（`try_parse_*`）

| 方法 | 说明 |
|---|---|
| `s.try_parse_int() -> Option[int]` | 可选 `+/-`、全为数字；空白 / 非法 / 溢出 → `None` |
| `s.try_parse_float() -> Option[float]` | `[+/-] digits [. digits]`（无指数）；非法 → `None` |
| `s.try_parse_bool() -> Option[bool]` | 仅 `"true"` / `"false"` |
| `s.parse_float() -> float` | 宽松：失败返回 `0.0`（对齐 `parse_int`） |

严格版**不允许首尾空白**（与 Rust 一致）；需要容忍空白时先 `.trim()`。

## 便捷包装

| 函数 | 说明 |
|---|---|
| `parse_int_or(ref String, int fallback) -> int` | 严格解析，失败用 fallback |
| `parse_float_or(ref String, float fallback) -> float` | 同上 |
| `parse_bool_or(ref String, bool fallback) -> bool` | 同上 |

> 包装只是常用形态的快捷方式；也可以直接 `s.try_parse_int().unwrap_or(fallback)`。

## 转换（`to_*` 与 `into`）

| 表达式 | 结果 |
|---|---|
| `3.to_float()` / `3.into()` | `3.0`（`into` 的自然目标为 float） |
| `3.9.to_int()` / `-3.9.to_int()` | 截断向零：`3` / `-3` |
| `'A'.to_int()` / `'A'.into()` | `65` |
| `65.to_char()` | `'A'` |
| `true.to_int()` / `true.into()` | `1` |

## `Into[T]` 接口

```ayanami
pub interface Into[T] {
    fn into(self) -> T;
}
```

自然转换：`int -> float`、`char -> int`、`bool -> int`（每类型至多一个目标；显式目标用 `to_*`）。
泛型约束已可用：

```ayanami
fn as_float[U: Into[float]](U x) -> float {
    return x.into()
}
```

`Result` 版解析（`ParseError`）待编译器 #68/#69 修复后追加。

## 示例

```ayanami
import "convert"
import "io"

fn main() -> int {
    println(parse_int_or("42", 0))        // 42
    println(parse_float_or("2.5", 0.0))   // 2.5
    println(parse_bool_or("yes", true))   // true（解析失败用 fallback）
    println(3.9.to_int())                 // 3
    return 0
}
```

## 注意

- 溢出：`try_parse_int` 对超出 i64 范围的输入返回 `None`（`i64::MIN` 也按溢出处理）。
- 浮点解析无指数形式（`"1e3"` → `None`），需要时后续扩展。
- `parse_int`（宽松、前缀解析）仍在 `string` 模块；本模块提供严格版与浮点/布尔对应物。
