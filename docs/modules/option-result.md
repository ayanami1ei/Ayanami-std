# std — 聚合入口、Option 与 Result

```ayanami
import "std";
```

`std` 等价于同时导入 `io`、`string`、`math`、`list`、`linkedlist`、`arraylist`、`panic`，
并额外提供 `Option[T]`、`Result[T, E]` 与 `Error` 接口（定义在 `option` 模块，也可单独
`import "option"`）。

## Option[T]

| 构造 | 说明 |
|---|---|
| `Option::Some(v)` | 有值 |
| `Option::None()` | 空 |

| 方法 | 说明 |
|---|---|
| `o.is_some() -> bool` | 是否有值（消费 `self`） |
| `o.unwrap_or(default) -> T` | 有值取值，否则返回默认值（消费 `self`） |
| `o.or(other) -> Option[T]` | `Some` 返回自身，`None` 返回 `other` |
| `o.map[U](fn(T) -> U)` | `Some(v)` → `Some(f(v))`，`None` 不变 |
| `o.and_then[U](fn(T) -> Option[U])` | `Some(v)` → `f(v)`（链式），`None` 不变 |
| `o.filter(fn(T) -> bool)` | 谓词为假时变 `None` |

泛型实参由上下文推导，通常写在带返回类型的辅助函数里：

```ayanami
import "std"
import "io"

fn find(int x) -> Option[int] {
    if x > 0 { return Option::Some(x) }
    return Option::None()
}

fn main() -> int {
    println(find(5).unwrap_or(0))    // 5
    println(find(-1).unwrap_or(42))  // 42
    if !find(1).is_some() { return 1 }
    if find(-1).is_some() { return 2 }
    return 0
}
```

> 方法会消费 `Option`：同一值不要连续调用；每次用新的函数调用。

## Result[T, E]

| 方法 | 说明 |
|---|---|
| `r.is_ok()` / `r.is_err()` | 判断 |
| `r.unwrap_or(default) -> T` | `Ok` 取值，`Err` 返回默认值 |
| `r.ok() -> Option[T]` | `Ok(v)` → `Some(v)`，`Err` → `None` |
| `r.try_unwrap() -> T` | 兼容旧行为（`Err` → `0`） |

```ayanami
fn parse(int x) -> Result[int, int] {
    if x < 0 { return Result::Err(x) }
    return Result::Ok(x)
}
```

- 构造 `Result::Ok(v)` / `Result::Err(e)` 可用（泛型实参由返回类型推导）。
- `try_unwrap` 用 `match` 实现，`match` 观测可用。
- `Result.map` / `map_err` 待编译器修复后提供（主仓
  [#135](https://github.com/ayanami1ei/Ayanami-language/issues/135)）。

## 组合子示例

```ayanami
import "std"

fn find(int x) -> Option[int] {
    if x > 0 { return Option::Some(x) }
    return Option::None()
}

fn main() -> int {
    a = find(5).map((int x) { return x * 2 })            // Some(10)
    b = find(5).filter((int x) { return x > 2 })          // Some(5)
    c = find(5).and_then((int x) { return find(x + 1) })  // Some(6)
    if a.unwrap_or(0) != 10 { return 1 }
    if b.unwrap_or(0) != 5 { return 2 }
    if c.unwrap_or(0) != 6 { return 3 }
    return 0
}
```

> lambda 目前**不能捕获外部变量**（闭包捕获属主仓 M2）；组合子里只能使用参数与全局函数。

## Error 接口

```ayanami
pub interface Error {
    fn what(ref self) -> String;
}
```

接口是 Go 式结构匹配：类型只要具备 `what(ref self) -> String` 方法即可当作 `Error` 使用。

## 注意

- `Option` / `Result` 不是 Copy 值：赋值 / 传参会移动。
- `import "std"` 会把列出的模块全部编入程序（编译略慢）；只用一个模块时直接导入对应模块即可。
