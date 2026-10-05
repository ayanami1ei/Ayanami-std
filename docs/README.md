# Ayanami 标准库文档

面向使用者的分模块教程式文档（语言语法见主仓教程）。符号定位：根目录 `SYMBOLS.md`
（`rg "关键词" SYMBOLS.md`）。

设计标准：[design.md](design.md)（对外声明式、对内过程式、整体面向对象）。

| 文档 | 内容 |
|---|---|
| [design.md](design.md) | 设计标准：对外声明式、对内过程式、整体面向对象 |
| [io.md](io.md) | 输入输出：`print` / `println` / `putchar` / `getchar` |
| [math.md](math.md) | 数学函数：整型与浮点重载 |
| [string.md](string.md) | 字符串与字符：`String` 方法、`char` 工具、`ToString` |
| [convert.md](convert.md) | 解析与转换：`try_parse_*`、`parse_*_or`、`to_*`、`Into[T]` |
| [rand.md](rand.md) | 伪随机数：`Rng`（LCG，确定性） |
| [time.md](time.md) | 时间：`now_millis`（单调）/ `now_unix` |
| [fs.md](fs.md) | 文件读写：`exists` / `read_file` / `write_file` |
| [env.md](env.md) | 命令行参数与环境变量 |
| [collections.md](collections.md) | 集合：`List` 接口、`ArrayList`、`LinkedList` |
| [option-result.md](option-result.md) | `std` 聚合：`Option`、`Result`、`Error` 接口 |
| [panic.md](panic.md) | 运行时 panic：`#panic`、越界与空表行为 |
| [runtime.md](runtime.md) | C 运行时：ABI、约定与扩展步骤 |
| [testing.md](testing.md) | 测试框架：运行方式与新增用例 |

## 引入与运行

用 `import "模块名"` 自动查找并链接标准库：

```ayanami
import "io"
import "arraylist"

fn main() -> int {
    println("hello")
    a = ArrayList::new[int]()
    a.push(1)
    println(a.to_string())
    return 0
}
```

## 开发者入口

本仓库是编译器主仓的 `std/` 子模块。开发态改完 `src/` 后重建并安装，再跑回归：

```bash
AYANAMI_BIN=<主仓>/target/debug/ayanami ./scripts/build.sh --install <主仓>/target/debug/std
AYANAMI_BIN=<主仓>/target/debug/ayanami ./scripts/test.sh
```

- 源码在 `src/`；根目录 `*.aya` 是指向 `src/*.aya` 的符号链接
- 构建产物 `.lcl` 不入库；`SYMBOLS.md` 由 `./scripts/gen_symbols.sh` 生成
- 越界/空表等运行时错误的退出码为 **101**（见 [panic.md](panic.md)）
