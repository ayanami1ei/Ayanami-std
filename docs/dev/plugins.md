# 插件契约（MIR pass / check 与标注）

> 适用范围：用 std `mir` API 编写的 **MIR 优化 pass / 检查 check** 插件，以及自定义标注。
> 编译器侧的标注设计见主仓 `docs/annotations.md`；本文件是插件作者与编译器之间的接口契约。

## 1. 角色与注册

| 角色 | 载体 | 声明方式 |
|---|---|---|
| pass | 包内函数 `fn name(ref mut MirFunction)` | `#[pass]`（编译进 .lcl 的 Pass 符号） |
| check | 包内函数 `fn name(ref MirFunction)`（只读） | `#[check]` |
| 宏 | 包内函数（A5 宏系统） | `#[macro]` |

使用方：

```ayanami
import "myopt";

#[myopt::fast_math]          // 全限定；或裸名 #[fast_math]（跨已导入包唯一时）
fn compute(int x) -> int { ... }
```

- 注解表来自**已导入包**导出的 Macro/Pass/Check 符号（`AnnotationTables::collect`）。
- 裸名跨所有已导入包查找：0 个 → 未知注解报错；多个 → 歧义错误。
- 内建效应标注（`#[pure]` 等）优先于插件表解析。

## 2. 标注验证责任

| 类别 | 验证方 | 行为 |
|---|---|---|
| 效应标注 `#[pure]` `#[no_error]` `#[alloc]` `#[state]` `#[io]` `#[throws(..)]` | **编译器**（效应推断核对） | hard discrepancy：编译失败；pub 接口缺失：警告建议 |
| 内建语义标注（`#[macro]` `#[pass]` `#[check]` `#[test]` 等） | **编译器** | 注册/语义由编译器实现 |
| 插件标注的**参数形状与语义** | **插件自身** | 插件必须自行校验参数并经诊断通道上报；编译器不校验 |
| 优化承诺（如 `pure`/`no_error` 改写） | **插件作者** | 承诺即契约；误改导致错误优化，编译器不兜底 |

规则：

1. 插件不得假设编译器验证过其注解参数；缺参/类型错/语义冲突都应 `error(...)`。
2. 诊断通道 `__ayanami_diag_emit(level, msg)` 是**弱符号**：普通可执行文件中为 no-op，
   插件 shim 中为强定义；`level=1` warning、`level=2` error（导致编译失败）。
3. 编译器只对效应标注做核对（pure/no_error 等）；其余标注语义由插件负责。

## 3. Schema 版本

- 唯一真源：编译器 `pass_plugin.rs::SCHEMA_VERSION`（当前 **3**）；MIR blob 首 8 字节 = 版本号。
- std `mir.schema_version()` 返回同一版本；插件可 `if schema_version() != 3 { error(...) }` 断言。
- 布局：`pure/no_error/node_count` + 15 个 `[int]` 数组（preorder），与 `std/src/meta/mir.aya`
  的 `MirFunction` 字段一一对应；`int` 一律 i64。
- **版本变更流程**（布局或语义变化时）：
  1. 递增 `SCHEMA_VERSION`；
  2. 同步 `std/src/meta/mir.aya` 布局与 `schema_version()`；
  3. 更新本文件；
  4. 更新/新增回归测试（见 §5）。
- 编译器与插件版本不匹配时：**必须显式失败**（拒绝运行/编译报错），不得静默继续。

## 4. 变换合法性

pass 允许：

- 改写 `pure` / `no_error` 字段（声明式承诺，编译器据此优化）。
- 通过编辑数组表达 body 变换（`edit_kind` / `edit_i64`）：

| `edit_kind` | 语义 | 辅助函数 |
|---|---|---|
| 1 | 替换为 int 字面量 | `replace_int(f, idx, value)` |
| 2 | 替换为 float 字面量（位模式） | `replace_float(f, idx, bits)` |
| 3 | 替换为 bool 字面量 | `replace_bool(f, idx, value)` |
| 4 | 替换为 char 字面量（编码） | `replace_char(f, idx, code)` |
| 5 | 克隆第 src 个节点替换（类型须一致） | `replace_with(f, idx, src)` |
| 6 | 删除语句节点（替换为空块） | `delete_stmt(f, idx)` |

pass 禁止（契约）：

- 修改 `node_count`、只读数组（`kinds`/`is_*`/`child_counts`/`ops`/`lit_*`/`stmt_kinds`/`var_ids`）
  或越界索引；
- 依赖“未被重编码的写入”（shim 会整体重编码，但只保证上述编辑语义）；
- 假设编辑绕过安全检查：**编译器应用编辑后会重跑借用检查**，非法编辑按编译错误处理。

执行模型：

- pass 按源码顺序在函数 MIR 上**定点迭代**（上限 8 轮）；不收敛 → 编译错误（冲突 pass）。
- check 在 pass 收敛后运行（只读），用于验证与诊断。
- 每次迭代：序列化 → 插件处理 → 反序列化 → 应用编辑 → 更新 pure/no_error。

## 5. 回归测试要求

任何契约 / API / schema 变更必须附带：

1. **std 侧**：`tests/unit/mir_test.aya` 覆盖纯逻辑（`scan_effects`、`subtree_sizes`、
   编辑辅助、编码谓词）；schema 版本号断言同步更新。
2. **编译器侧**：至少一个样例 pass 的端到端测试（构建插件 → 调用 → 应用编辑 → 断言结果），
   含收敛与不收敛路径。
3. **诊断路径**：`warn`/`error` 能出现在编译器诊断输出中（error 使编译失败）。
4. **版本防护**：版本不匹配的拒绝路径有测试（或明确记录为待实现）。

## 6. 现状与差距（跟踪）

- 编译器 `pass_plugin.rs` 顶部注释仍写 “schema v0”（实际 `SCHEMA_VERSION = 3`）；
  std `mir.aya` 原写 v1 已对齐为 v3 —— 注释同步已在编译器 issue 跟踪。
- 编辑类型目前覆盖字面量替换与语句删除；更多变换（语句重排/变量替换）按实际需求扩展。
- pass 的“定点迭代”语义对多 pass 组合的顺序敏感，冲突时以不收敛报错（见 §4）。
