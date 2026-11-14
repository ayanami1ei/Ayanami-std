# checksum — CRC-32

```ayanami
import "checksum";
```

纯 Ayanami 实现（IEEE 802.3，反射多项式 `0xedb88320`）。

| 函数 | 说明 |
|---|---|
| `crc32(ref String data) -> int` | CRC-32（0..2^32-1） |
| `crc32_hex(ref String data) -> String` | 8 位小写十六进制 |

示例：

```ayanami
import "checksum";
import "io";

fn main() -> int {
    println(crc32("123456789"));      // 3421780262（0xcbf43926）
    println(crc32_hex("hello"));      // 3610a686
    return 0
}
```

- 输入按字节处理（不做 UTF-8 校验）；
- 标准向量：`crc32("") = 0`、`crc32("123456789") = 0xcbf43926`。
