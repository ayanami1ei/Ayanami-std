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
| `m.into_iter() -> HashMapIter[K, V]` | 产出 `Pair[K, V]`（HashMap） |
| `s.into_iter() -> HashSetIter[K]` | 产出元素（HashSet） |
| `s.lines_iter()` / `s.split_whitespace_iter()` | 文本惰性迭代器（见 [text.md](text.md)） |
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

## 适配器

| 构造 | 说明 |
|---|---|
| `MapIter::new(it, f)` | 映射 |
| `FilterIter::new(it, pred)` | 过滤 |
| `TakeIter::new(it, n)` | 最多前 `n` 个 |
| `EnumerateIter::new(it)` | 产出 `Pair[usize, T]`（下标从 0 起） |
| `ZipIter::new(a, b)` | 逐对产出 `Pair[T, U]`，任一耗尽即结束 |

```ayanami
a = ArrayList::new[int]()
a.push(1)
a.push(2)
a.push(3)
a.push(4)

m = MapIter::new(a.into_iter(), (int x) -> int { return x * 10 })
f = FilterIter::new(m, (int x) -> bool { return x > 20 })
t = TakeIter::new(f, 2usize)

s = 0
for x in t { s = s + x }        // 30 + 40 = 70
```

> 适配器可任意嵌套（内层迭代器满足 `Iterator[T]` 即可），拥有类型（如 `String`）正常。
> `Pair[A, B] { first, second }` 用于 zip / enumerate 的元素。
