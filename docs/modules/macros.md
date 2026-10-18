# macros — 宏 TokenStream API

```ayanami
import "macros";
```

编译器宏系统（`#[macro(tokens)]`，ABI v6）的 std 侧：把宏收到的**编码字节流**解码为
可读的 token 列表，改完再编码回去。编解码与编译器
`compiler/macro_expand/token_stream.rs` 逐字节一致。

## 编码（ABI v6，小端）

每个 token：`[kind:u8][file:u32][line:u32][col:u32][len:u32][payload...]`（头 17 字节）。

| kind | 含义 | payload |
|---|---|---|
| 0 | 标识符 | 文本字节 |
| 1 | 字面量 | 文本字节（字符串含引号） |
| 2 | 标点 | 文本字节 |
| 3 | 关键字 | 文本字节 |
| 4 | 分组 | `[code:u8]` + 递归子流（code：0=`(` 1=`[` 2=`{` 3=其他） |

**扁平视图**：解码时分组展开为「开符 + 子 token + 闭符」（均为 kind=2 标点）；
编码为扁平形式（每个 token 独立编码）。

## API

| 项 | 说明 |
|---|---|
| `TokenStream::from_bytes(String) -> TokenStream` | 解码（非法/截断处停止，返回前缀） |
| `TokenStream::to_bytes(ref TokenStream) -> String` | 编码（扁平） |
| `TokenStream::to_source(ref TokenStream) -> String` | 还原源码文本（单空格连接） |
| `TokenStream::new()` / `len` / `index` | 构造与访问 |
| `push_ident/literal/punct/keyword/group_open/group_close` | 追加 token（span 为 0） |
| `is_ident/literal/punct/keyword/group_open/group_close(ref Token)` | 种类判断 |
| `diag_warn(String)` / `diag_error(String)` | 宏诊断（error 使编译失败；调用点由编译器附加） |
| `hygienic_ident(String) -> String` | 宏内定义名加后缀（不捕获/不泄漏） |

## 示例（token 宏）

```ayanami
import "macros"

#[alloc]
#[state]
#[macro(tokens)]
pub fn twice(String input) -> String {
    ts = TokenStream::from_bytes(input)
    one = TokenStream::to_bytes(ts)
    return one + one
}
```

调用：`#[twice] v = v + 1;`（语句级展开为两条）。

```ayanami
// 检查/改写：把第一个标识符改名
ts = TokenStream::from_bytes(input)
t = TokenStream::index(ts, 0usize)
if is_ident(t) {
    diag_warn("first token is ident: " + t.text)
}
return TokenStream::to_bytes(ts)
```

## std 自用

`dev/test.aya` 的标注与断言宏（`#[test]` / `#[should_panic]` / `#assert*` / `#fail`）
已迁移为 token 宏，实参经本模块解码、拼接后编码输出——宏内不再拼源码文本。

## 注意

- 宏库（插件）需 `#[alloc]`/`#[state]` 标注（含分配/状态调用）；`.so` 由编译器构建。
- 文本宏（`#[macro]`）不受影响；token 宏与文本宏可在同一包混用。
- `Span.file` 为预留索引（当前恒为 0）；宏内新建 token 的 span 全 0。
