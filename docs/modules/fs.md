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
| `remove_file(String path) -> bool` | 删除文件（成功 `true`） |
| `copy_file(String src, String dst) -> bool` | 复制文件（覆盖目标） |
| `rename_file(String from, String to) -> bool` | 重命名 / 移动文件 |
| `is_dir(String path) -> bool` | 是否目录 |
| `is_file(String path) -> bool` | 是否普通文件 |
| `mkdir(String path) -> bool` / `rmdir(String path) -> bool` | 创建 / 删除（空）目录 |
| `mtime(String path) -> Option[int]` | 修改时间（Unix 秒；失败 `None`） |
| `size(String path) -> Option[int]` | 文件字节数（失败 `None`） |
| `copy_tree(String src, String dst) -> int` | 递归复制目录树（返回文件数；失败 `-1`） |
| `list_dir(String path) -> Option[ArrayList[String]]` | 目录项（不含 `.` / `..`；失败 `None`） |

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
