# 测试框架（scripts/test.sh）

标准库自带三类回归：正例、运行时 panic、编译期负例。全部用真实编译器执行。

## 运行

```bash
# 在主仓构建编译器后（默认读取 ../target/debug/ayanami）
AYANAMI_BIN=<主仓>/target/debug/ayanami ./scripts/test.sh

# 已安装过 .lcl、不想重建
./scripts/test.sh --no-install
```

脚本先调用 `scripts/build.sh --install` 把 `src/*.aya` 重新打包安装到
**编译器二进制同目录的 `std/`**（`cargo` 开发态为 `target/debug/std/`），再依次执行：

| 类别 | 来源 | 判定 |
|---|---|---|
| 正例 | `tests/positive_exit.txt`（`<文件> <退出码>`） | 运行退出码一致 |
| panic | `tests/panic_exit.txt`（`<文件> <退出码> <输出子串>`） | 退出码一致，且输出含子串 |
| 负例 | `tests/compile_fail/*.aya` + 同名 `.expected` | `check` 输出命中任一子串行 |

最后打印 `std tests: positive=N panic=N negative=N failures=N`；有失败时退出码非 0。

## 新增用例

### 正例

1. 新建 `tests/test_xxx.aya`：`fn main() -> int`，每个检查失败返回**不同的非 0 码**，全过 `return 0`。
2. 在 `tests/positive_exit.txt` 加一行 `test_xxx.aya 0`。

```ayanami
import "math"

fn main() -> int {
    if abs(-5) != 5 { return 1 }
    if pow(2, 10) != 1024 { return 2 }
    return 0
}
```

### 运行时 panic

1. 新建用例触发 panic（如越界）；语言没有 `try/catch`，不需要处理。
2. 在 `tests/panic_exit.txt` 加 `test_xxx.aya 101 <输出子串>`。

```ayanami
import "arraylist"

fn main() -> int {
    a = ArrayList::new[int]()
    a.push(1)
    x = a.index(5)      // panic：index out of bounds...
    return 0
}
```

### 编译期负例

1. `tests/compile_fail/<名>.aya` 写必然报错的代码。
2. `<名>.expected` 每行一个候选子串，命中任意一行即通过。

## 约定与提示

- 正例不要 `print`（只看退出码）；要验证输出内容用 panic 类别的子串匹配。
- 失败码从 1 递增，便于定位失败检查点；每个用例 ≤ 60 行，不依赖交互输入。
- 改动 `src/` 后必须跑本脚本；符号地图用 `./scripts/gen_symbols.sh --check` 校验。
- 已知编译器 bug（暂不覆盖）：泛型枚举 `Result` 的方法与 `match`
 （主仓 issue #68 / #69）。
