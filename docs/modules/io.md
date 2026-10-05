# io — 输入输出

```ayanami
import "io";
```

| 函数 | 说明 |
|---|---|
| `print(ref String s)` | 输出字符串（借用，不消费） |
| `print(int n)` / `print(float f)` / `print(bool b)` / `print(char c)` | 常用类型重载 |
| `println(...)` | 同上并追加换行；`println()` 只输出换行 |
| `putchar(int c)` | 输出一个字符 |
| `getchar() -> int` | 读取一个字符的编码（`int`） |
| `read_line() -> String` | 读取一行（不含换行；EOF 返回空串） |
| `read_int() -> int` | 读取一行并宽松解析（`trim` + `parse_int`，失败 `0`） |
| `try_read_int() -> Option[int]` | 读取一行并严格解析（失败 `None`） |
| `read_float() -> float` | 读取一行并宽松解析（`trim` + `parse_float`，失败 `0.0`） |
| `try_read_float() -> Option[float]` | 读取一行并严格解析（失败 `None`） |
| `read_bool() -> bool` | 读取一行并宽松解析（失败 `false`） |
| `try_read_bool() -> Option[bool]` | 读取一行并严格解析（失败 `None`） |

## 示例（输出即注释）

```ayanami
import "io"

fn main() -> int {
    println("hello")     // hello
    println(42)          // 42
    println(3.5)         // 3.5
    println(true)        // true
    println('x')         // x
    print("a")
    print("b")           // ab（无换行）
    println()
    putchar(65)          // A
    println()
    return 0
}
```

## 行输入

```ayanami
import "io"

fn main() -> int {
    n = read_int()        // 读一行并解析（失败 0）
    println(n)
    return 0
}
```

- `read_line` 为纯 Ayanami 实现（`[char]` 缓冲倍增，不依赖 runtime 扩展）；EOF 返回空串，
  行尾 `\r\n` 会去掉 `\r`。
- `read_int` = `read_line().trim().parse_int()`（宽松）；严格版 `try_read_int()` 返回 `Option[int]`。

## 注意

- 五种重载按实参类型选择：`String` / `int` / `float` / `bool` / `char`；
  其他类型先 `.to_string()`，例如 `a.to_string()`。
- 字符串参数是 `ref String`（不消费原值）。
- 输出走 stdout；运行时 panic 走 stderr（见 [panic.md](panic.md)）。
- 浮点按最短可读形式打印：`println(3.5)` → `3.5`，`println(sqrt(9.0))` → `3`（整值不带 `.0`）。
