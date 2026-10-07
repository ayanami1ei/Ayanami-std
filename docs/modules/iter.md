# iter — 迭代器与 for-in

```ayanami
import "iter";
```

`for x in it { ... }` 基于迭代器协议：任何具备以下方法的类型都可迭代（结构化，无需显式实现接口）：

```ayanami
fn next(ref mut self) -> Option[T]
```

- `for x in (start, end[, step])` 区间形式保持原有语义；
- 迭代器值移入循环临时量（拥有语义），随作用域释放；
- `break` / `continue` 与普通循环一致。

## 集合迭代器

| API | 说明 |
|---|---|
| `a.into_iter() -> ArrayListIter[T]` | 拥有型迭代器（消费 `a`） |
| `l.into_iter() -> LinkedListIter[T]` | 同上（LinkedList） |
| `Iterator[T]` 接口 | `fn next(ref mut self) -> Option[T]`；接口形参走虚调用 |

```ayanami
import "iter"
import "arraylist"

a = ArrayList::new[int]()
a.push(1)
a.push(2)
a.push(3)

s = 0
for x in a.into_iter() {
    s = s + x            // 6
}
```

自定义迭代器只需提供 `next`：

```ayanami
struct Countdown {
    int cur
}

impl Countdown {
    #[state]
    pub fn next(ref mut self) -> Option[int] {
        if self.cur <= 0 { return Option::None() }
        v = self.cur
        self.cur = self.cur - 1
        return Option::Some(v)
    }
}

fn sum(Iterator[int] it) -> int {
    s = 0
    for x in it { s = s + x }
    return s
}
```

## 适配器（待编译器修复）

`MapIter` / `FilterIter` / `TakeIter` 暂不提供：

- 参数化约束 `I: Iterator[T]` 的 impl 打包为 `.lcl` 后方法丢失（主仓
  [#159](https://github.com/ayanami1ei/Ayanami-language/issues/159)）；
- `for-in` 迭代接口值且迭代器持有 `ArrayList` 时堆损坏（主仓
  [#158](https://github.com/ayanami1ei/Ayanami-language/issues/158)）。

修复后可提供 `map/filter/take/zip/enumerate` 链式适配器。
