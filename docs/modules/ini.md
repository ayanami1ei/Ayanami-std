# ini — INI 配置解析

```ayanami
import "ini";
```

纯 Ayanami 实现。

| 函数 | 说明 |
|---|---|
| `parse(ref String text) -> Ini` | 解析 INI 文本 |
| `Ini::len()` | 配置项数量 |
| `Ini::get(section, key) -> Option[String]` | 取值（重复键以最后一次为准） |
| `Ini::get_or(section, key, fallback) -> String` | 取值或默认值 |
| `Ini::has(section, key) -> bool` | 是否存在 |
| `Ini::sections() -> ArrayList[String]` | 段名（去重、首次出现顺序） |
| `Ini::keys(section) -> ArrayList[String]` | 段内键（去重、首次出现顺序） |

语法约定：

- `[section]` 分段；顶层键的 section 为 `""`；
- `key = value`：以首个 `=` 分隔，两侧去空白，值可包含 `=`；
- `;` / `#` 开头为注释，空行忽略；
- 重复键以最后一次为准；无 `=` 的行忽略；
- 行尾兼容 `\n` / `\r\n`。

示例：

```ayanami
import "ini";
import "io";

fn main() -> int {
    text = "[server]\nhost = 127.0.0.1\nport = 8080\n";
    c = parse(ref text);
    println(c.get(ref "server", ref "host").unwrap());  // 127.0.0.1
    println(c.get_or(ref "server", ref "timeout", "30")); // 30
    return 0
}
```
