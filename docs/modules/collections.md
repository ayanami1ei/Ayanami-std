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
| `s.len()` / `s.is_empty()` | 长度 / 是否为空 |

| 方法 | 说明 |
|---|---|
| `HashMap::new[K, V]()` | 空表 |
| `m.insert(k, v) -> bool` | 插入；新增返回 true，覆盖旧值返回 false |
| `m.get(k) -> Option[V]` | 取值（浅拷贝，与 `ArrayList.index` 一致） |
| `m.contains_key(k) -> bool` | 是否包含键 |
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
