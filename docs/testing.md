# 测试框架

标准库用例写在 `tests/unit/*_test.aya`，使用 `import "test"` 提供的标注与断言宏；
`scripts/test.sh` 负责构建、安装并运行全部测试。

## 运行

```bash
# 重建并安装 .lcl 后运行（默认编译器 ../target/debug/ayanami）
AYANAMI_BIN=<主仓>/target/debug/ayanami ./scripts/test.sh
./scripts/test.sh --no-install        # 跳过重建
./scripts/test.sh --filter string     # 只跑名字含 string 的用例
```

输出示例：

```
running 17 unit tests
  ok   string_test::test_basic
  ...
running 1 compile-fail tests
  ok   compile_fail/missing_import.aya
test result: ok. 18/18 passed
```

## 写用例（类似 Rust 的 `#[test]`）

```ayanami
import "test"

#[test]
fn test_add() -> int {
    #assert(1 + 1 == 2)
    #assert_eq(2 + 2, 4)
    #assert_ne(1, 2)
    return 0
}

#[should_panic]
fn test_oob() -> int {
    a = ArrayList::new[int]()
    x = a.index(5)      // 期望 panic（退出码 101）
    return 0
}
```

- 一个函数只写一个标注：`#[test]`（应通过）或 `#[should_panic]`（应 panic）。
- 用例函数暂写 `-> int` 且末尾 `return 0`：规避编译器“块尾表达式语句丢失”缺陷
  （ayanami1ei/Ayanami-language#85）；修复后可写成 `fn test_add()`。
- 断言失败会 panic，并打印 `文件名:行:列` + 消息；`should_panic` 用例只要退出码 101 即通过。
- 可用断言：`#assert(cond)` / `#assert_eq(a, b)` / `#assert_ne(a, b)`。
  复杂条件可先赋值到局部变量，再 `#assert`。

## 已知限制（编译器侧）

- 带标注的用例中，断言报出的行列可能偏移（源文本宏的卫生性问题）；以文件与消息为准。
- 用例文件只 `import "test"` 加本用例直接使用的模块：同一模块“直接 + 经 test 传递”重复导入
  可能触发重复符号链接错误。
- 宏名在多重导入下可能歧义（如 `#panic` 经 test 与 panic 两条路径可见）；
  标准库自身测试用 `panic_at` 直接调用，避免歧义。

## 目录约定

| 路径 | 说明 |
|---|---|
| `tests/unit/*_test.aya` | 单元用例（`#[test]` / `#[should_panic]`） |
| `tests/compile_fail/*.aya` + `.expected` | 编译期负例：`.expected` 每行一个候选子串，命中任意一行即通过 |
| `tests/golden/*.aya` + `.out` | stdout 黄金输出（精确对比；启用受 #85 阻塞） |

## 运行器实现

`scripts/run_tests.py`：

1. 扫描 `tests/unit/*_test.aya`，按标注发现用例函数；
2. 为每个用例生成最小 driver（`import "<模块>"` 后调用该函数），独立进程运行（panic 隔离）；
3. 按退出码判定（`0` 通过；`should_panic` 期望 `101`），失败打印首行错误；
4. 再运行编译期负例与黄金输出对比。

`scripts/test.sh` 负责 `build.sh --install` 与参数转发。
