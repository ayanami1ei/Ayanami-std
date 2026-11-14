# encoding — 十六进制与 Base64 编解码

```ayanami
import "encoding";
```

纯 Ayanami 实现（`char` 即字节，0..255），无机器相关依赖。

| 函数 | 说明 |
|---|---|
| `hex_encode(ref String s) -> String` | 字节串 → 小写十六进制 |
| `hex_encode_upper(ref String s) -> String` | 字节串 → 大写十六进制 |
| `hex_decode(ref String s) -> Option[String]` | 十六进制 → 字节串（大小写均可） |
| `base64_encode(ref String s) -> String` | 字节串 → Base64（标准字母表，含 `=` 填充） |
| `base64_decode(ref String s) -> Option[String]` | Base64 → 字节串（严格校验） |
| `base32_encode(ref String s) -> String` | 字节串 → Base32（RFC 4648，含 `=` 填充） |
| `base32_decode(ref String s) -> Option[String]` | Base32 → 字节串（严格校验） |

示例：

```ayanami
import "encoding";

println(hex_encode("Hi"));            // 4869
println(base64_encode("hello"));      // aGVsbG8=
println(base32_encode("foobar"));     // MZXW6YTBOI======
println(hex_decode("deadBEEF").unwrap());  // 4 字节
```

约定：

- 解码失败返回 `Option::None()`：非法字符、奇数长度（hex）、长度非 4 的倍数 /
  填充位置错误（Base64）；
- 空串可正常编码/解码（结果为 `""`）；
- 输入按字节处理，不做 UTF-8 校验（`String` 本身是字节缓冲）。

## 实现

1. hex 解码逐字节查表（`0-9` / `a-f` / `A-F`），编码用 `[char; n*2]` 缓冲一次性填充；
2. Base64 每 3 字节编码为 4 字符，末尾按剩余 1/2 字节补 `=`；
3. 解码按 4 字符一组校验：`=` 只能出现在末组，且 `xx==` / `xxx=` 之外的形式报错。
4. Base32 以 5 位为一组编码（5 字节 → 8 字符），解码校验长度、字符、填充位置与尾部零位。
