# path — 路径字符串工具

```ayanami
import "path";
```

**纯字符串运算**，不访问文件系统（不解析 `..` / `.`，交给文件系统）；约定 Unix 风格 `/`。

| API | 说明 |
|---|---|
| `normalize(String) -> String` | 折叠重复 `/`，去掉末尾 `/`（根 `/` 保留） |
| `join(String base, String name) -> String` | 拼接；`name` 为绝对路径时覆盖 `base` |
| `basename(String) -> String` | 最后一段（根 → `/`，空 → `""`） |
| `dirname(String) -> String` | 目录部分（无目录 → `.`，根 → `/`） |
| `extension(String) -> String` | 扩展名（无 → `""`，不含点） |
| `is_absolute(String) -> bool` | 是否以 `/` 开头 |
| `file_stem(String) -> String` | 文件名去扩展名（点文件 `.bashrc` 视为无扩展名） |
| `with_extension(String, String) -> String` | 替换/添加扩展名（空扩展名表示去掉） |

示例：

```ayanami
normalize("a//b///c")         // "a/b/c"
join("/data", "x.txt")        // "/data/x.txt"
join("/data", "/abs/y")       // "/abs/y"
basename("/a/b/c.txt")        // "c.txt"
dirname("/a/b/c.txt")         // "/a/b"
extension("archive.tar.gz")   // "gz"
file_stem("/a/b/c.txt")       // "c"
with_extension("/a/b/c.txt", "md")  // "/a/b/c.md"
is_absolute("/a/b")           // true
```
