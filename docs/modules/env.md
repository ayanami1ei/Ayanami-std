# env — 命令行参数与环境变量

```ayanami
import "env";
```

| 函数 | 说明 |
|---|---|
| `arg_count() -> int` | 参数个数（含程序名，下标 0） |
| `arg(int i) -> String` | 第 i 个参数；越界返回空串 |
| `get_env(String name) -> Option[String]` | 环境变量；缺失 → `None` |

## 示例

```ayanami
import "env"
import "io"

fn main() -> int {
    println(arg(0))                          // 程序路径
    if arg_count() > 1 { println(arg(1)) }
    println(get_env("PATH").unwrap_or("(unset)"))
    return 0
}
```

## 注意

- 参数来自 `/proc/self/cmdline`（Linux），无需修改 `main` 签名。
- 字符串为运行时分配的拷贝，String 接管所有权。
