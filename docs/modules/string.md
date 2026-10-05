# string — 字符串与字符

```ayanami
import "string";
```

`String` 是拥有所有权的值（`{ data: [char], len: int }`）；源码里的 `"..."` 字面量就是 `String`。

## 构造

| 构造 | 说明 |
|---|---|
| `String::empty()` / `String::new()` | 空串 |
| `String::new([char] data, int len)` | 从拥有所有权的字符缓冲构造（`len` 由调用方保证不超过缓冲长度） |

## 方法

| 方法 | 说明 |
|---|---|
| `s.len() -> usize` | 长度 |
| `s.index(usize i) -> char`（或 `s[i]`） | 取字符；越界 panic 101，指向调用行 |
| `s.add(ref String other) -> String` | 拼接；运算符 `+` 等价 |
| `s.eq / s.ne(ref String) -> bool` | 比较；`==` / `!=` 等价 |
| `s.lt / s.gt / s.le / s.ge(ref String) -> bool` | 字典序比较；`<` `>` `<=` `>=` 等价 |
| `s.copy() -> String` | 深拷贝 |
| `s.to_string() -> String` | 返回自身（实现 `ToString`） |
| `s.is_empty() -> bool` | 是否空串 |
| `s.index_of(ref String) -> int` | 子串位置；未找到 `-1` |
| `s.contains / starts_with / ends_with(ref String) -> bool` | 子串 / 前缀 / 后缀 |
| `s.substring(usize start, usize end) -> String` | 区间 `[start, end)`，越界自动夹取 |
| `s.trim() -> String` | 去掉首尾空白 |
| `s.to_upper() / s.to_lower() -> String` | 大小写转换 |
| `s.repeat(usize n) -> String` | 重复 `n` 次 |
| `s.parse_int() -> int` | 解析整数（前缀式，见下） |
| `s.is_int() -> bool` | 整个串是否为合法十进制整数 |

## 常用类型 → String（`ToString`）

| 表达式 | 结果 |
|---|---|
| `42.to_string()` | `"42"` |
| `3.5.to_string()` | `"3.5"` |
| `true.to_string()` | `"true"` |
| `'x'.to_string()` | `"x"` |
| `s.to_string()` | `s` 自身 |

## char 工具

| 方法 | 说明 |
|---|---|
| `c.is_digit()` / `c.is_alpha()` / `c.is_alnum()` / `c.is_space()` | 分类判断 |
| `c.is_upper()` / `c.is_lower()` | 大小写判断 |
| `c.to_upper() / c.to_lower() -> char` | 大小写转换 |
| `c.to_digit() -> int` | 数字字符 → 数值 |
| `char_code(c) -> int` | 字符编码：`char_code('A') == 65` |

## 示例（输出即注释）

```ayanami
import "string"
import "io"

fn main() -> int {
    s = "Hello, Ayanami"
    println(s.len())                  // 14
    println(s.to_upper())             // HELLO, AYANAMI
    println(s.substring(7, 14))       // Ayanami
    println(" 42 ".trim().parse_int() + 1)  // 43
    if !s.contains("Ayanami") { return 1 }
    if s.index(0) != 'H' { return 2 }
    if "42".is_int() == false { return 3 }
    return 0
}
```

构造字符缓冲：

```ayanami
s = String::new(['h', 'i'], 2)   // "hi"
```

## 注意

- 字符串是拥有所有权的值：赋值 / 传参会移动；`ref` 参数不消费。需要保留原值用 `.copy()`。
- 索引与长度统一为 `usize`（`len` / `index` / `substring` / `repeat`）；`index_of` 仍返回 `int`（`-1` 为未找到哨兵）。
- `substring(a, b)` 左闭右开；`b > len` 夹到 `len`，`b < a` 返回空串；参数为 `usize`，不再接受负数。
- 越界 `s.index(i)` / `s[i]` 会 panic（退出码 101），位置通过 track_caller 指向你的调用行。
- `parse_int` 跳过前导空白与正负号、遇非数字停止（`"12a".parse_int() == 12`）；
  要求整个串合法请用 `is_int()`。
