# text — 文本处理

```ayanami
import "text";
```

| 函数 | 说明 |
|---|---|
| `split(ref String s, ref String sep) -> ArrayList[String]` | 按分隔符切分；`sep` 为空时返回只含原串的列表 |
| `join(ref ArrayList[String] list, ref String sep) -> String` | 连接元素；空列表 → 空串 |
| `replace(ref String s, ref String old, ref String new) -> String` | 替换全部出现；`old` 为空时返回原串拷贝 |
| `pad_left(ref String s, usize width, char fill) -> String` | 左侧填充到 `width` |
| `pad_right(ref String s, usize width, char fill) -> String` | 右侧填充到 `width` |
| `lines(ref String s) -> ArrayList[String]` | 按行拆分（`\n`，兼容 `\r\n`；末尾换行不产生空行） |
| `split_whitespace(ref String s) -> ArrayList[String]` | 按空白拆分（连续空白视为一个；忽略首尾） |
| `count(ref String s, ref String needle) -> int` | 非重叠出现次数（needle 为空返回 0） |
| `split_once(ref String s, ref String sep) -> Split` | 在首个分隔符处切分；`Split { found, before, after }` |

## 示例

```ayanami
import "text"
import "io"

fn main() -> int {
    parts = split("a,b,c", ",")
    println(join(parts, "-"))                 // a-b-c
    println(replace("a-b-c", "-", "+"))       // a+b+c
    println(pad_left("42", 5, '0'))           // 00042
    return 0
}
```

## 注意

- 依赖 `string` + `arraylist`；内部过程式实现（单趟扫描），对外声明式调用。
- `split` 结果元素为拥有所有权的 `String`；`join` 会复制元素。
