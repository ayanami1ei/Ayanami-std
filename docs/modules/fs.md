# fs — 文件读写

```ayanami
import "fs";
```

| 函数 | 说明 |
|---|---|
| `exists(String path) -> bool` | 文件是否存在 |
| `read_file(String path) -> Option[String]` | 读取整个文件（失败 `None`） |
| `write_file(String path, String data) -> bool` | 覆盖写入（成功 `true`） |
| `read_lines(String path) -> Option[ArrayList[String]]` | 按行拆分（`\r\n` 兼容；失败 `None`） |
| `append_file(String path, String data) -> bool` | 追加写入（不存在则创建） |

## 示例

```ayanami
import "fs"
import "io"

fn main() -> int {
    if write_file("/tmp/a.txt", "hello") {
        s = read_file("/tmp/a.txt").unwrap_or("")
        println(s)              // hello
    }
    return 0
}
```

## 注意

- 由 C 运行时提供（`runtime/sys.c`）；读取缓冲由 `unique_alloc` 分配，String 接管所有权。
- 按字节读写（二进制安全）。
