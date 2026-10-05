# collections — 集合

| 模块 | 类型 | 说明 |
|---|---|---|
| `list` | `List[T]` 接口 | 元素无约束 |
| `arraylist` | `ArrayList[T]` | 顺序表（`[T]` 缓冲，自动扩容） |
| `linkedlist` | `LinkedList[T]` | 与 `ArrayList` 同接口；当前为数组缓冲实现（行为等价顺序表） |

```ayanami
import "arraylist"
```

## List[T] 接口

```ayanami
pub interface List[T] {
    fn push(ref mut self, T val);
    fn index(ref self, usize index) -> T;
    fn len(ref self) -> usize;
    fn iter(ref self, fn(T) f);
}
```

元素类型**无约束**：任意类型（含未实现 `ToString` 的结构体/枚举）都能放入；
只有 `to_string` 要求元素实现 `ToString`（在带约束的 impl 块中提供）。

## ArrayList[T]

| 构造 / 方法 | 说明 |
|---|---|
| `ArrayList::new[T]()` | 空表 |
| `ArrayList::with_capacity[T](usize n)` | 预分配容量（`n == 0` 等价 `new`） |
| `a.push(v)` | 追加，自动扩容 |
| `a.index(i) -> T`（或 `a[i]`） | 取元素；越界 panic 101 |
| `a.len()` / `a.is_empty()` | 长度 / 是否为空 |
| `a.set(i, v)` | 改写；越界 panic 101 |
| `a.pop() -> T` | 弹出末元素；空表 panic 101 |
| `a.clear()` | 清空（保留底层缓冲） |
| `a.iter(f)` | 遍历（回调无捕获，见下） |
| `a.to_string()` | 形如 `"[1, 2]"`（要求 `T: ToString`） |

## LinkedList[T]

`LinkedList::new[T]()`，方法 `push` / `index` / `len` / `iter` / `to_string`，行为与 `ArrayList` 一致。

## 示例（输出即注释）

```ayanami
import "arraylist"
import "io"

fn main() -> int {
    a = ArrayList::new[int]()
    a.push(10)
    a.push(20)
    a.push(30)
    println(a.len())        // 3
    println(a.index(1))     // 20
    a.set(1, 99)
    println(a.pop())        // 30
    println(a.to_string())  // [10, 99]
    return 0
}
```

遍历（回调形如 `(类型 参数) { ... }`，**不能捕获外部变量**，可调用全局函数）：

```ayanami
import "arraylist"
import "io"

fn main() -> int {
    a = ArrayList::new[int]()
    a.push(1)
    a.push(2)
    a.iter((int x) { println(x) })   // 1 然后 2
    return 0
}
```

## 排序（`import "sort"`）

| 函数 | 说明 |
|---|---|
| `sort_int(ref mut ArrayList[int])` | 升序（插入排序，稳定） |
| `sort_string(ref mut ArrayList[String])` | 字典序升序 |

```ayanami
import "sort"

a = ArrayList::new[int]()
a.push(3)
a.push(1)
a.push(2)
sort_int(a)                  // [1, 2, 3]
```

> 泛型 `sort[T]` 待 Ord 型接口/约束能力就绪后提供。

## 注意

- 索引与长度统一为 `usize`（`index` / `len` / `set` / `pop` / `with_capacity`）；字面量会自动适配（`a.index(1)` 可直接写）。
- 越界 / 空表 `pop` 通过函数级 track_caller 指向**调用行**（`a.index(5)` 与 `a[5]` 均可）。
- `to_string` 只对实现了 `ToString` 的元素类型提供。
- 集合本身是拥有所有权的值：赋值 / 传参会移动；`ref` / `ref mut` 方法不消费。
