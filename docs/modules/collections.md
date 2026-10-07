# collections — 集合

| 模块 | 类型 | 说明 |
|---|---|---|
| `list` | `List[T]` 接口 | 元素无约束 |
| `arraylist` | `ArrayList[T]` | 顺序表（`[T]` 缓冲，自动扩容） |
| `linkedlist` | `LinkedList[T]` | 与 `ArrayList` 同接口；当前为数组缓冲实现（行为等价顺序表） |
| `hash` | `Hash` 接口 | `int` / `String` 哈希与键相等 |
| `hashset` | `HashSet[K: Hash]` | 哈希集合（开放寻址） |
| `hashmap` | `HashMap[K: Hash, V]` | 哈希表（开放寻址） |

```ayanami
import "arraylist"
```

`contains` / `index_of` / `remove` 要求元素实现 `Eq`：

```ayanami
pub interface Eq {
    fn same(ref self, ref Self other) -> bool;
}
```

内置 `Eq`：`int`、`String`、`bool`、`char`；自定义类型提供
`same(ref self, ref Self other) -> bool` 即满足约束。

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
| `a.contains(v)`（`T: Eq`） | 是否包含（线性查找） |
| `a.index_of(v) -> int`（`T: Eq`） | 首次出现下标；未找到 `-1` |
| `a.remove(v) -> bool`（`T: Eq`） | 删除首个等于 `v` 的元素 |
| `a.reverse()` | 原地反转 |
| `a.insert_at(i, v)` / `a.remove_at(i)` | 指定位置插入 / 删除；越界 panic 101 |
| `a.first()` / `a.last() -> T` | 首 / 末元素；空表 panic 101 |
| `a.map[U](Fn(T) -> U)` | 映射为新表 |
| `a.filter(Fn(T) -> bool)` | 过滤为新表 |
| `a.fold[U](init, Fn(U, T) -> U)` | 折叠 |
| `a.any(Fn(T) -> bool)` / `a.all(...)` | 存在 / 全部满足 |
| `a.find(Fn(T) -> bool) -> Option[T]` | 首个满足谓词的元素 |
| `a.position(Fn(T) -> bool) -> int` / `a.count(Fn(T) -> bool) -> usize` | 首个满足的下标（无 `-1`）/ 个数 |
| `a.retain(Fn(T) -> bool)` | 原地保留满足谓词的元素 |
| `a.iter(f)` | 遍历（回调可捕获，见下） |
| `a.to_string()` | 形如 `"[1, 2]"`（要求 `T: ToString`） |

## LinkedList[T]

方法集与 `ArrayList` 对齐：`push` / `index` / `set` / `pop` / `clear` / `is_empty` /
`contains` / `index_of` / `remove` / `reverse` / `insert_at` / `remove_at` / `first` / `last` /
`iter` / `to_string`，另有 `LinkedList::with_capacity[T](n)`；行为等价顺序表。

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

遍历与捕获（回调形如 `(类型 参数) -> U { ... }`，支持按值捕获，M2）：

```ayanami
import "arraylist"
import "io"

fn main() -> int {
    a = ArrayList::new[int]()
    a.push(1)
    a.push(2)
    a.iter((int x) { println(x) })   // 1 然后 2

    limit = 1
    b = a.filter((int x) -> bool { return x > limit })   // [2]（按值捕获 limit）
    println(b.len())                 // 1
    return 0
}
```

## 排序（`import "sort"`）

排序按 `Ord` 接口（三态比较）约束：

```ayanami
pub interface Ord {
    fn cmp(ref self, ref Self other) -> int;   // <0 / 0 / >0
}
```

| 入口 | 说明 |
|---|---|
| `a.sort()`（`impl[T: Ord] ArrayList[T]`） | 泛型升序（插入排序，稳定） |
| `sort(a)` | `a.sort()` 的自由函数形式 |
| `sort_int(a)` / `sort_string(a)` | `a.sort()` 的兼容包装 |
| `a.min()` / `a.max() -> Option[T]` | 最小 / 最大元素（空表 `None`） |
| `a.is_sorted() -> bool` | 是否已升序 |
| `a.binary_search(v) -> int` | 二分查找（要求已升序）；未找到 `-1` |

内置 `Ord`：`int`、`String`（字典序）。自定义类型提供
`cmp(ref self, ref Self other) -> int` 即满足约束：

```ayanami
import "sort"

struct Item {
    int key
}

impl Item {
    pub fn cmp(ref self, ref Item other) -> int {
        if self.key < other.key { return 0 - 1 }
        if self.key > other.key { return 1 }
        return 0
    }
}

a = ArrayList::new[int]()
a.push(3)
a.push(1)
a.push(2)
a.sort()                     // [1, 2, 3]
```

> 插入排序在相等元素上不交换，**稳定**。

## 哈希集合 / 哈希表（`import "hashset"` / `"hashmap"`）

开放寻址 + 线性探测；装填因子超过 0.5 自动扩容（扩容顺带清理墓碑），探测必然终止。
键类型需实现 `Hash` 接口（内置 `String` 与 `int`）：

```ayanami
pub interface Hash {
    fn hash(ref self) -> int;                    // 确定性、非负
    fn hash_eq(ref self, ref Self other) -> bool;
}
```

| 方法 | 说明 |
|---|---|
| `HashSet::new[K]()` | 空集合 |
| `s.insert(k) -> bool` | 插入；已存在返回 false |
| `s.contains(k) -> bool` | 是否包含 |
| `s.remove(k) -> bool` | 删除；不存在返回 false |
| `s.to_list() -> ArrayList[K]` | 所有元素（浅拷贝，顺序为实现相关） |
| `s.for_each(Fn(K))` / `s.fold[U](init, Fn(U, K) -> U)` | 遍历 / 折叠（顺序为实现相关） |
| `s.retain(Fn(K) -> bool)` | 原地保留满足谓词的元素 |
| `s.to_string()`（`K: ToString`） | 形如 `{a, b}`（顺序为实现相关） |
| `s.len()` / `s.is_empty()` | 长度 / 是否为空 |

| 方法 | 说明 |
|---|---|
| `HashMap::new[K, V]()` | 空表 |
| `m.insert(k, v) -> bool` | 插入；新增返回 true，覆盖旧值返回 false |
| `m.get(k) -> Option[V]` | 取值（浅拷贝，与 `ArrayList.index` 一致） |
| `m.contains_key(k) -> bool` | 是否包含键 |
| `m.keys()` / `m.values() -> ArrayList[K]/ArrayList[V]` | 所有键 / 值（浅拷贝，顺序为实现相关） |
| `m.for_each(Fn(K, V))` / `m.fold[U](init, Fn(U, K, V) -> U)` | 遍历 / 折叠（顺序为实现相关） |
| `m.retain(Fn(K, V) -> bool)` | 原地保留满足谓词的键值对 |
| `m.to_string()`（`K/V: ToString`） | 形如 `{a: 1, b: 2}`（顺序为实现相关） |
| `m.remove(k) -> bool` | 删除；不存在返回 false |
| `m.len()` / `m.is_empty()` | 长度 / 是否为空 |

```ayanami
import "hashmap"
import "hashset"

s = HashSet::new[String]()
s.insert("a")             // true
s.contains("a")           // true
s.remove("a")             // true

m = HashMap::new[String, int]()
m.insert("x", 1)
m.insert("x", 2)          // false（覆盖）
m.get("x").unwrap_or(0)   // 2
```

> 值读取为浅拷贝；需要深拷贝时对结果调用 `.copy()`。
> 扩展键类型：为新类型提供 `hash` + `hash_eq` 两个方法即满足 `Hash`。

## 注意

- 索引与长度统一为 `usize`（`index` / `len` / `set` / `pop` / `with_capacity`）；字面量会自动适配（`a.index(1)` 可直接写）。
- 越界 / 空表 `pop` 通过函数级 track_caller 指向**调用行**（`a.index(5)` 与 `a[5]` 均可）。
- `to_string` 只对实现了 `ToString` 的元素类型提供。
- 集合本身是拥有所有权的值：赋值 / 传参会移动；`ref` / `ref mut` 方法不消费。
