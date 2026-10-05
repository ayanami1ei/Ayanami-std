# math — 数学函数

```ayanami
import "math";
```

## 整型

| 函数 | 说明 |
|---|---|
| `abs(int x)` | 绝对值 |
| `min(int a, int b)` / `max(int a, int b)` | 最小 / 最大 |
| `clamp(int x, int lo, int hi)` | 夹取到 `[lo, hi]` |
| `pow(int base, int exp)` | 整数幂（循环乘法，`exp >= 0`） |
| `gcd(int a, int b)` / `lcm(int a, int b)` | 最大公约数 / 最小公倍数（0 的约定见下） |
| `is_prime(int n)` | 是否素数（`n < 2` 为 `false`） |

## 浮点

| 函数 | 说明 |
|---|---|
| `abs(float x)` / `min` / `max` / `clamp` | 与整型同名重载 |
| `sqrt(float x)` | 平方根 |
| `floor(float x)` / `ceil(float x)` | 向下 / 向上取整 |
| `pow(float base, int exp)` | 浮点幂 |

## 示例（输出即注释）

```ayanami
import "math"
import "io"

fn main() -> int {
    println(abs(-5))          // 5
    println(min(3, 7))        // 3
    println(max(3, 7))        // 7
    println(clamp(10, 0, 5))  // 5
    println(pow(2, 10))       // 1024
    println(sqrt(9.0))        // 3
    println(floor(1.9))       // 1
    println(ceil(1.1))        // 2
    return 0
}
```

## 方法（`impl int` / `impl float`）

| 方法 | 说明 |
|---|---|
| `n.is_even()` / `n.is_odd()` | 奇偶判断（负数按数值判断，如 `-3` 为奇） |
| `f.is_nan()` | 是否 NaN（runtime `isnan`） |

## 注意

- 整型 / 浮点同名重载按实参类型选择：`abs(-5)` 选整型，`abs(-1.5)` 选浮点。
- `gcd(0, 0) == 0`；`lcm` 任一参数为 0 返回 0。
- `sqrt` / `floor` / `ceil` 由运行时 libm 提供；数学域行为（如 `sqrt(-1.0)`）暂不做诊断。
- 浮点比较是精确比较，涉及误差时自行处理容差。
