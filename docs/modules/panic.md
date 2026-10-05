# panic — 运行时错误

```ayanami
import "panic";
```

| 形式 | 说明 |
|---|---|
| `#panic("消息")` | 函数宏：在调用点展开，自动带上 `__line / __col / __file` |
| `panic_at(line, col, file, msg)` | 底层函数（宏与库内部使用） |
| `panic_bounds_at(line, col, file, index, len)` | 越界专用（集合/字符串边界检查使用） |

运行时输出（stderr）：

```
thread 'main' panicked at main.aya:4:5: boom
```

退出码 **101**。

## 示例

```ayanami
import "panic"

fn main() -> int {
    #panic("boom");   // thread 'main' panicked at main.aya:4:5: boom
    return 0
}
```

## 标准库的自动 panic

| 场景 | 消息 |
|---|---|
| `arr[i]` / `a.index(i)` / `s[i]` 越界 | `index out of bounds: the len is 1 but the index is 5` |
| 空表 `a.pop()` | `pop from empty ArrayList` |

越界检查位于标准库内部，但位置通过函数级 track_caller 指向**用户调用行**。

## 注意

- 语言没有 `try/catch`：panic 即终止进程，不能捕获。
- 手动调用 `panic_at` 时行 / 列 / 文件由调用方提供；一般直接用 `#panic` 宏。
- 测试里用 `tests/panic_exit.txt` 校验 `101` + 消息子串（见 [testing.md](../dev/testing.md)）。
