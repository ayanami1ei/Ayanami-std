# SYMBOLS.md — Ayanami-std 符号地图

> 本文件由 scripts/gen_symbols.sh 自动生成，请勿手改。重新生成：./scripts/gen_symbols.sh
> 查询：rg "关键词" SYMBOLS.md

src/collections/arraylist.aya:11: pub struct ArrayList[T]
src/collections/arraylist.aya:17: pub namespace ArrayList
src/collections/arraylist.aya:19: pub fn new[T]() -> ArrayList[T]
src/collections/arraylist.aya:24: pub fn with_capacity[T](usize cap) -> ArrayList[T]
src/collections/arraylist.aya:32: impl[T] ArrayList[T]
src/collections/arraylist.aya:35: fn expand(ref mut self)
src/collections/arraylist.aya:50: fn push(ref mut self, T val)
src/collections/arraylist.aya:57: fn index(ref self, usize index, int __line, int __col, String __file) -> T
src/collections/arraylist.aya:63: fn len(ref self) -> usize
src/collections/arraylist.aya:67: fn capacity(ref self) -> usize
src/collections/arraylist.aya:71: fn set(ref mut self, usize i, T v, int __line, int __col, String __file)
src/collections/arraylist.aya:80: fn pop(ref mut self, int __line, int __col, String __file) -> T
src/collections/arraylist.aya:87: fn is_empty(ref self) -> bool
src/collections/arraylist.aya:92: fn clear(ref mut self)
src/collections/arraylist.aya:95: fn iter(ref self, Fn(T) f)
src/collections/arraylist.aya:103: impl[T: ToString] ArrayList[T]
src/collections/arraylist.aya:106: fn to_string(ref self) -> String
src/collections/arraylist.aya:120: impl[T: Eq] ArrayList[T]
src/collections/arraylist.aya:122: fn contains(ref self, ref T v) -> bool
src/collections/arraylist.aya:133: fn index_of(ref self, ref T v) -> int
src/collections/arraylist.aya:144: fn last_index_of(ref self, ref T v) -> int
src/collections/arraylist.aya:159: fn dedup(ref mut self)
src/collections/arraylist.aya:176: fn remove(ref mut self, ref T v) -> bool
src/collections/arraylist.aya:194: impl[T] ArrayList[T]
src/collections/arraylist.aya:198: fn map[U](ref self, Fn(T)->U f) -> ArrayList[U]
src/collections/arraylist.aya:210: fn filter(ref self, Fn(T)->bool f) -> ArrayList[T]
src/collections/arraylist.aya:222: fn fold[U](ref self, U init, Fn(U,T)->U f) -> U
src/collections/arraylist.aya:232: fn any(ref self, Fn(T)->bool f) -> bool
src/collections/arraylist.aya:243: fn all(ref self, Fn(T)->bool f) -> bool
src/collections/arraylist.aya:254: fn find(ref self, Fn(T)->bool f) -> Option[T]
src/collections/arraylist.aya:266: fn retain(ref mut self, Fn(T)->bool f)
src/collections/arraylist.aya:279: fn position(ref self, Fn(T)->bool f) -> int
src/collections/arraylist.aya:290: fn count(ref self, Fn(T)->bool f) -> usize
src/collections/arraylist.aya:303: fn reverse(ref mut self)
src/collections/arraylist.aya:316: fn swap(ref mut self, usize i, usize j, int __line, int __col, String __file)
src/collections/arraylist.aya:330: fn insert_at(ref mut self, usize idx, T v, int __line, int __col, String __file)
src/collections/arraylist.aya:347: fn remove_at(ref mut self, usize idx, int __line, int __col, String __file)
src/collections/arraylist.aya:360: fn first(ref self, int __line, int __col, String __file) -> T
src/collections/arraylist.aya:368: fn last(ref self, int __line, int __col, String __file) -> T
src/collections/hash.aya:7: interface Hash
src/collections/hash.aya:8: fn hash(ref self) -> int;
src/collections/hash.aya:9: fn hash_eq(ref self, ref Self other) -> bool;
src/collections/hash.aya:12: impl String
src/collections/hash.aya:15: fn hash(ref self) -> int
src/collections/hash.aya:25: fn hash_eq(ref self, ref String other) -> bool
src/collections/hash.aya:30: impl int
src/collections/hash.aya:33: fn hash(ref self) -> int
src/collections/hash.aya:41: fn hash_eq(ref self, ref int other) -> bool
src/collections/hashmap.aya:15: pub struct HashMap[K: Hash, V]
src/collections/hashmap.aya:24: pub namespace HashMap
src/collections/hashmap.aya:25: pub fn new[K: Hash, V]() -> HashMap[K, V]
src/collections/hashmap.aya:30: pub fn with_capacity[K: Hash, V](usize cap) -> HashMap[K, V]
src/collections/hashmap.aya:38: impl[K: Hash, V] HashMap[K, V]
src/collections/hashmap.aya:41: fn grow(ref mut self)
src/collections/hashmap.aya:75: fn insert(ref mut self, K k, V v) -> bool
src/collections/hashmap.aya:105: fn get_or_insert(ref mut self, K k, V v) -> V
src/collections/hashmap.aya:132: fn get(ref self, ref K k) -> Option[V]
src/collections/hashmap.aya:152: fn contains_key(ref self, ref K k) -> bool
src/collections/hashmap.aya:173: fn remove_get(ref mut self, ref K k) -> Option[V]
src/collections/hashmap.aya:197: fn remove(ref mut self, ref K k) -> bool
src/collections/hashmap.aya:220: fn clear(ref mut self)
src/collections/hashmap.aya:232: fn merge(ref mut self, ref HashMap[K, V] other)
src/collections/hashmap.aya:245: fn retain(ref mut self, Fn(K,V)->bool f)
src/collections/hashmap.aya:258: fn for_each(ref self, Fn(K,V) f)
src/collections/hashmap.aya:268: fn fold[U](ref self, U init, Fn(U,K,V)->U f) -> U
src/collections/hashmap.aya:282: fn to_list(ref self) -> ArrayList[Pair[K, V]]
src/collections/hashmap.aya:298: fn keys(ref self) -> ArrayList[K]
src/collections/hashmap.aya:312: fn values(ref self) -> ArrayList[V]
src/collections/hashmap.aya:323: fn len(ref self) -> usize
src/collections/hashmap.aya:326: fn is_empty(ref self) -> bool
src/collections/hashmap.aya:332: impl[K: Hash + ToString, V: ToString] HashMap[K, V]
src/collections/hashmap.aya:335: fn to_string(ref self) -> String
src/collections/hashmap.aya:355: pub struct HashMapIter[K: Hash, V]
src/collections/hashmap.aya:360: impl[K: Hash, V] HashMapIter[K, V]
src/collections/hashmap.aya:362: fn next(ref mut self) -> Option[Pair[K, V]]
src/collections/hashmap.aya:376: impl[K: Hash, V] HashMap[K, V]
src/collections/hashmap.aya:378: fn into_iter(self) -> HashMapIter[K, V]
src/collections/hashmap.aya:384: impl[K: Hash, V: Eq] HashMap[K, V]
src/collections/hashmap.aya:386: fn contains_value(ref self, ref V v) -> bool
src/collections/hashmap.aya:402: impl[K: Hash + Ord, V] HashMap[K, V]
src/collections/hashmap.aya:406: fn sorted_keys(ref self) -> ArrayList[K]
src/collections/hashmap.aya:414: impl[K: Hash, V: Ord] HashMap[K, V]
src/collections/hashmap.aya:418: fn sorted_values(ref self) -> ArrayList[V]
src/collections/hashmap.aya:426: impl[K: Hash, V] HashMap[K, V]
src/collections/hashmap.aya:429: fn map_values[U](ref self, Fn(V)->U f) -> HashMap[K, U]
src/collections/hashmap.aya:445: impl[K: Hash, V] HashMap[K, V]
src/collections/hashmap.aya:447: fn any(ref self, Fn(K,V)->bool f) -> bool
src/collections/hashmap.aya:460: fn all(ref self, Fn(K,V)->bool f) -> bool
src/collections/hashmap.aya:473: fn count(ref self, Fn(K,V)->bool f) -> usize
src/collections/hashmap.aya:487: fn find(ref self, Fn(K,V)->bool f) -> Option[Pair[K, V]]
src/collections/hashset.aya:13: pub struct HashSet[K: Hash]
src/collections/hashset.aya:21: pub namespace HashSet
src/collections/hashset.aya:22: pub fn new[K: Hash]() -> HashSet[K]
src/collections/hashset.aya:27: pub fn with_capacity[K: Hash](usize cap) -> HashSet[K]
src/collections/hashset.aya:35: impl[K: Hash] HashSet[K]
src/collections/hashset.aya:38: fn grow(ref mut self)
src/collections/hashset.aya:68: fn insert(ref mut self, K k) -> bool
src/collections/hashset.aya:94: fn contains(ref self, ref K k) -> bool
src/collections/hashset.aya:115: fn take(ref mut self, ref K k) -> Option[K]
src/collections/hashset.aya:139: fn remove(ref mut self, ref K k) -> bool
src/collections/hashset.aya:162: fn retain(ref mut self, Fn(K)->bool f)
src/collections/hashset.aya:176: fn clear(ref mut self)
src/collections/hashset.aya:186: fn is_subset_of(ref self, ref HashSet[K] other) -> bool
src/collections/hashset.aya:200: fn is_superset_of(ref self, ref HashSet[K] other) -> bool
src/collections/hashset.aya:205: fn remove_all(ref mut self, ref HashSet[K] other)
src/collections/hashset.aya:220: fn retain_all(ref mut self, ref HashSet[K] other)
src/collections/hashset.aya:238: fn union(ref self, ref HashSet[K] other) -> HashSet[K]
src/collections/hashset.aya:259: fn intersection(ref self, ref HashSet[K] other) -> HashSet[K]
src/collections/hashset.aya:275: fn difference(ref self, ref HashSet[K] other) -> HashSet[K]
src/collections/hashset.aya:289: fn for_each(ref self, Fn(K) f)
src/collections/hashset.aya:299: fn fold[U](ref self, U init, Fn(U,K)->U f) -> U
src/collections/hashset.aya:313: fn to_list(ref self) -> ArrayList[K]
src/collections/hashset.aya:324: fn len(ref self) -> usize
src/collections/hashset.aya:327: fn is_empty(ref self) -> bool
src/collections/hashset.aya:333: impl[K: Hash + ToString] HashSet[K]
src/collections/hashset.aya:336: fn to_string(ref self) -> String
src/collections/hashset.aya:356: pub struct HashSetIter[K: Hash]
src/collections/hashset.aya:361: impl[K: Hash] HashSetIter[K]
src/collections/hashset.aya:363: fn next(ref mut self) -> Option[K]
src/collections/hashset.aya:376: impl[K: Hash] HashSet[K]
src/collections/hashset.aya:378: fn into_iter(self) -> HashSetIter[K]
src/collections/hashset.aya:384: impl[K: Hash] HashSet[K]
src/collections/hashset.aya:386: fn any(ref self, Fn(K)->bool f) -> bool
src/collections/hashset.aya:399: fn all(ref self, Fn(K)->bool f) -> bool
src/collections/hashset.aya:412: fn count(ref self, Fn(K)->bool f) -> usize
src/collections/hashset.aya:426: fn find(ref self, Fn(K)->bool f) -> Option[K]
src/collections/hashset.aya:441: impl[K: Hash + Ord] HashSet[K]
src/collections/hashset.aya:445: fn sorted_list(ref self) -> ArrayList[K]
src/collections/iter.aya:12: interface Iterator[T]
src/collections/iter.aya:13: fn next(ref mut self) -> Option[T];
src/collections/iter.aya:17: pub struct Pair[A, B]
src/collections/iter.aya:23: pub struct ArrayListIter[T]
src/collections/iter.aya:28: impl[T] ArrayListIter[T]
src/collections/iter.aya:30: fn next(ref mut self) -> Option[T]
src/collections/iter.aya:40: impl[T] ArrayList[T]
src/collections/iter.aya:42: fn into_iter(self) -> ArrayListIter[T]
src/collections/iter.aya:48: pub struct LinkedListIter[T]
src/collections/iter.aya:53: impl[T] LinkedListIter[T]
src/collections/iter.aya:55: fn next(ref mut self) -> Option[T]
src/collections/iter.aya:65: impl[T] LinkedList[T]
src/collections/iter.aya:67: fn into_iter(self) -> LinkedListIter[T]
src/collections/iter.aya:73: pub struct MapIter[T, U, I: Iterator[T]]
src/collections/iter.aya:78: pub namespace MapIter
src/collections/iter.aya:79: pub fn new[T, U, I: Iterator[T]](I inner, Fn(T)->U f) -> MapIter[T, U, I]
src/collections/iter.aya:84: impl[T, U, I: Iterator[T]] MapIter[T, U, I]
src/collections/iter.aya:86: fn next(ref mut self) -> Option[U]
src/collections/iter.aya:96: pub struct FilterIter[T, I: Iterator[T]]
src/collections/iter.aya:101: pub namespace FilterIter
src/collections/iter.aya:102: pub fn new[T, I: Iterator[T]](I inner, Fn(T)->bool pred) -> FilterIter[T, I]
src/collections/iter.aya:107: impl[T, I: Iterator[T]] FilterIter[T, I]
src/collections/iter.aya:109: fn next(ref mut self) -> Option[T]
src/collections/iter.aya:124: pub struct TakeIter[T, I: Iterator[T]]
src/collections/iter.aya:129: pub namespace TakeIter
src/collections/iter.aya:130: pub fn new[T, I: Iterator[T]](I inner, usize n) -> TakeIter[T, I]
src/collections/iter.aya:135: impl[T, I: Iterator[T]] TakeIter[T, I]
src/collections/iter.aya:137: fn next(ref mut self) -> Option[T]
src/collections/iter.aya:147: pub struct EnumerateIter[T, I: Iterator[T]]
src/collections/iter.aya:152: pub namespace EnumerateIter
src/collections/iter.aya:153: pub fn new[T, I: Iterator[T]](I inner) -> EnumerateIter[T, I]
src/collections/iter.aya:158: impl[T, I: Iterator[T]] EnumerateIter[T, I]
src/collections/iter.aya:160: fn next(ref mut self) -> Option[Pair[usize, T]]
src/collections/iter.aya:172: pub struct ZipIter[T, U, IA: Iterator[T], IB: Iterator[U]]
src/collections/iter.aya:177: pub namespace ZipIter
src/collections/iter.aya:178: pub fn new[T, U, IA: Iterator[T], IB: Iterator[U]](IA a, IB b) -> ZipIter[T, U, IA, IB]
src/collections/iter.aya:183: impl[T, U, IA: Iterator[T], IB: Iterator[U]] ZipIter[T, U, IA, IB]
src/collections/iter.aya:185: fn next(ref mut self) -> Option[Pair[T, U]]
src/collections/iter.aya:203: pub fn map[T, U, I: Iterator[T]](I it, Fn(T)->U f) -> MapIter[T, U, I]
src/collections/iter.aya:208: pub fn filter[T, I: Iterator[T]](I it, Fn(T)->bool pred) -> FilterIter[T, I]
src/collections/iter.aya:213: pub fn take[T, I: Iterator[T]](I it, usize n) -> TakeIter[T, I]
src/collections/iter.aya:218: pub fn enumerate[T, I: Iterator[T]](I it) -> EnumerateIter[T, I]
src/collections/iter.aya:223: pub fn zip[T, U, IA: Iterator[T], IB: Iterator[U]](IA a, IB b) -> ZipIter[T, U, IA, IB]
src/collections/linkedlist.aya:13: pub struct LinkedList[T]
src/collections/linkedlist.aya:19: pub namespace LinkedList
src/collections/linkedlist.aya:20: pub fn new[T]() -> LinkedList[T]
src/collections/linkedlist.aya:25: pub fn with_capacity[T](usize cap) -> LinkedList[T]
src/collections/linkedlist.aya:33: impl[T] LinkedList[T]
src/collections/linkedlist.aya:36: fn expand(ref mut self)
src/collections/linkedlist.aya:51: fn push(ref mut self, T val)
src/collections/linkedlist.aya:58: fn index(ref self, usize index, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:64: fn len(ref self) -> usize
src/collections/linkedlist.aya:68: fn capacity(ref self) -> usize
src/collections/linkedlist.aya:72: fn set(ref mut self, usize i, T v, int __line, int __col, String __file)
src/collections/linkedlist.aya:81: fn pop(ref mut self, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:88: fn is_empty(ref self) -> bool
src/collections/linkedlist.aya:93: fn clear(ref mut self)
src/collections/linkedlist.aya:96: fn iter(ref self, Fn(T) f)
src/collections/linkedlist.aya:104: impl[T: ToString] LinkedList[T]
src/collections/linkedlist.aya:107: fn to_string(ref self) -> String
src/collections/linkedlist.aya:121: impl[T: Eq] LinkedList[T]
src/collections/linkedlist.aya:123: fn contains(ref self, ref T v) -> bool
src/collections/linkedlist.aya:134: fn index_of(ref self, ref T v) -> int
src/collections/linkedlist.aya:145: fn last_index_of(ref self, ref T v) -> int
src/collections/linkedlist.aya:158: fn dedup(ref mut self)
src/collections/linkedlist.aya:175: fn remove(ref mut self, ref T v) -> bool
src/collections/linkedlist.aya:193: impl[T] LinkedList[T]
src/collections/linkedlist.aya:196: fn reverse(ref mut self)
src/collections/linkedlist.aya:209: fn swap(ref mut self, usize i, usize j, int __line, int __col, String __file)
src/collections/linkedlist.aya:223: fn insert_at(ref mut self, usize idx, T v, int __line, int __col, String __file)
src/collections/linkedlist.aya:240: fn remove_at(ref mut self, usize idx, int __line, int __col, String __file)
src/collections/linkedlist.aya:253: fn first(ref self, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:261: fn last(ref self, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:269: impl[T] LinkedList[T]
src/collections/linkedlist.aya:273: fn map[U](ref self, Fn(T)->U f) -> LinkedList[U]
src/collections/linkedlist.aya:285: fn filter(ref self, Fn(T)->bool f) -> LinkedList[T]
src/collections/linkedlist.aya:297: fn fold[U](ref self, U init, Fn(U,T)->U f) -> U
src/collections/linkedlist.aya:307: fn any(ref self, Fn(T)->bool f) -> bool
src/collections/linkedlist.aya:318: fn all(ref self, Fn(T)->bool f) -> bool
src/collections/linkedlist.aya:329: fn find(ref self, Fn(T)->bool f) -> Option[T]
src/collections/linkedlist.aya:340: fn position(ref self, Fn(T)->bool f) -> int
src/collections/linkedlist.aya:351: fn count(ref self, Fn(T)->bool f) -> usize
src/collections/linkedlist.aya:364: fn retain(ref mut self, Fn(T)->bool f)
src/collections/list.aya:2: interface List[T]
src/collections/list.aya:3: fn push(ref mut self, T val);
src/collections/list.aya:4: fn index(ref self, usize index) -> T;
src/collections/list.aya:5: fn len(ref self) -> usize;
src/collections/list.aya:6: fn iter(ref self, Fn(T) f);
src/collections/sort.aya:13: impl[T: Ord] ArrayList[T]
src/collections/sort.aya:15: fn min(ref self) -> Option[T]
src/collections/sort.aya:30: fn max(ref self) -> Option[T]
src/collections/sort.aya:45: fn is_sorted(ref self) -> bool
src/collections/sort.aya:58: fn binary_search(ref self, ref T v) -> int
src/collections/sort.aya:77: fn sort(ref mut self)
src/collections/sort.aya:100: pub fn sort[T: Ord](ref mut ArrayList[T] a)
src/collections/sort.aya:106: pub fn sort_int(ref mut ArrayList[int] a)
src/collections/sort.aya:112: pub fn sort_string(ref mut ArrayList[String] a)
src/collections/text.aya:11: pub struct Split
src/collections/text.aya:18: pub struct LinesIter
src/collections/text.aya:23: impl LinesIter
src/collections/text.aya:26: fn next(ref mut self) -> Option[String]
src/collections/text.aya:50: impl String
src/collections/text.aya:52: fn lines_iter(self) -> LinesIter
src/collections/text.aya:58: pub struct SplitWhitespaceIter
src/collections/text.aya:63: impl SplitWhitespaceIter
src/collections/text.aya:66: fn next(ref mut self) -> Option[String]
src/collections/text.aya:87: impl String
src/collections/text.aya:89: fn split_whitespace_iter(self) -> SplitWhitespaceIter
src/collections/text.aya:95: pub struct SplitIter
src/collections/text.aya:102: impl SplitIter
src/collections/text.aya:105: fn next(ref mut self) -> Option[String]
src/collections/text.aya:136: impl String
src/collections/text.aya:138: fn split_iter(self, String sep) -> SplitIter
src/collections/text.aya:148: pub fn split(ref String s, ref String sep) -> ArrayList[String]
src/collections/text.aya:159: pub fn join(ref ArrayList[String] list, ref String sep) -> String
src/collections/text.aya:176: pub fn replace(ref String s, ref String old, ref String new) -> String
src/collections/text.aya:211: pub fn pad_left(ref String s, usize width, char fill) -> String
src/collections/text.aya:229: pub fn pad_right(ref String s, usize width, char fill) -> String
src/collections/text.aya:248: pub fn lines(ref String s) -> ArrayList[String]
src/collections/text.aya:259: pub fn split_once(ref String s, ref String sep) -> Split
src/collections/text.aya:275: pub fn split_whitespace(ref String s) -> ArrayList[String]
src/collections/text.aya:285: pub fn count(ref String s, ref String needle) -> int
src/collections/text.aya:313: pub fn count_lines(ref String s) -> int
src/collections/text.aya:334: pub fn truncate(ref String s, usize n) -> String
src/core/arch_x86_64.aya:13: pub namespace ArchX86_64
src/core/arch_x86_64.aya:16: pub fn wrapping_add(int a, int b) -> int
src/core/arch_x86_64.aya:25: pub fn wrapping_sub(int a, int b) -> int
src/core/arch_x86_64.aya:34: pub fn wrapping_mul(int a, int b) -> int
src/core/arch_x86_64.aya:43: pub fn wrapping_neg(int a) -> int
src/core/arch_x86_64.aya:52: pub fn add_overflow(int a, int b) -> int
src/core/arch_x86_64.aya:61: pub fn sub_overflow(int a, int b) -> int
src/core/arch_x86_64.aya:70: pub fn mul_overflow(int a, int b) -> int
src/core/arch_x86_64.aya:79: pub fn saturating_add(int a, int b) -> int
src/core/arch_x86_64.aya:90: pub fn saturating_sub(int a, int b) -> int
src/core/arch_x86_64.aya:101: pub fn saturating_mul(int a, int b) -> int
src/core/arch_x86_64.aya:117: pub fn atomic_load(ref int p) -> int
src/core/arch_x86_64.aya:127: pub fn atomic_store(ref int p, int v)
src/core/arch_x86_64.aya:135: pub fn atomic_swap(ref int p, int v) -> int
src/core/arch_x86_64.aya:145: pub fn atomic_fetch_add(ref int p, int v) -> int
src/core/arch_x86_64.aya:155: pub fn atomic_fetch_sub(ref int p, int v) -> int
src/core/arch_x86_64.aya:165: pub fn atomic_compare_exchange(ref int p, int expected, int new) -> int
src/core/arch_x86_64.aya:175: pub fn fence()
src/core/arch_x86_64.aya:183: pub fn cpu_relax()
src/core/bitops.aya:4: pub fn popcount(int x) -> int
src/core/bitops.aya:18: pub fn leading_zeros(int x) -> int
src/core/bitops.aya:34: pub fn trailing_zeros(int x) -> int
src/core/bitops.aya:50: pub fn is_power_of_two(int x) -> bool
src/core/convert.aya:13: pub enum ParseError
src/core/convert.aya:19: impl ParseError
src/core/convert.aya:24: fn what(ref self) -> String
src/core/convert.aya:35: pub fn digit_value(char c) -> int
src/core/convert.aya:49: impl String
src/core/convert.aya:52: fn try_parse_int(ref self) -> Option[int]
src/core/convert.aya:104: fn try_parse_uint(ref self) -> Option[usize]
src/core/convert.aya:117: fn try_parse_float(ref self) -> Option[float]
src/core/convert.aya:177: fn try_parse_bool(ref self) -> Option[bool]
src/core/convert.aya:190: fn try_parse_int_radix(ref self, int base) -> Option[int]
src/core/convert.aya:241: fn parse_int_radix(ref self, int base) -> int
src/core/convert.aya:246: fn is_float(ref self) -> bool
src/core/convert.aya:251: fn parse_float(ref self) -> float
src/core/convert.aya:259: pub fn parse_int_result(ref String s) -> Result[int, ParseError]
src/core/convert.aya:276: pub fn parse_float_result(ref String s) -> Result[float, ParseError]
src/core/convert.aya:290: pub fn parse_bool_result(ref String s) -> Result[bool, ParseError]
src/core/convert.aya:304: pub fn parse_int_or(ref String s, int fallback) -> int
src/core/convert.aya:310: pub fn parse_float_or(ref String s, float fallback) -> float
src/core/convert.aya:317: pub fn parse_bool_or(ref String s, bool fallback) -> bool
src/core/convert.aya:322: impl int
src/core/convert.aya:324: fn to_float(self) -> float
src/core/convert.aya:328: fn to_char(self) -> char
src/core/convert.aya:333: impl float
src/core/convert.aya:336: fn to_int(self) -> int
src/core/convert.aya:341: impl char
src/core/convert.aya:343: fn to_int(self) -> int
src/core/convert.aya:348: impl bool
src/core/convert.aya:350: fn to_int(self) -> int
src/core/convert.aya:359: interface Into[T]
src/core/convert.aya:360: fn into(self) -> T;
src/core/convert.aya:363: impl int
src/core/convert.aya:365: fn into(self) -> float
src/core/convert.aya:370: impl char
src/core/convert.aya:372: fn into(self) -> int
src/core/convert.aya:377: impl bool
src/core/convert.aya:379: fn into(self) -> int
src/core/eq.aya:7: interface Eq
src/core/eq.aya:8: fn same(ref self, ref Self other) -> bool;
src/core/eq.aya:11: impl int
src/core/eq.aya:13: fn same(ref self, ref int other) -> bool
src/core/eq.aya:18: impl String
src/core/eq.aya:20: fn same(ref self, ref String other) -> bool
src/core/eq.aya:25: impl bool
src/core/eq.aya:27: fn same(ref self, ref bool other) -> bool
src/core/eq.aya:32: impl char
src/core/eq.aya:34: fn same(ref self, ref char other) -> bool
src/core/math.aya:4: pub fn abs(int x) -> int
src/core/math.aya:12: pub fn min(int a, int b) -> int
src/core/math.aya:20: pub fn max(int a, int b) -> int
src/core/math.aya:28: pub fn sign(int x) -> int
src/core/math.aya:39: pub fn clamp(int x, int lo, int hi) -> int
src/core/math.aya:50: pub fn min(usize a, usize b) -> usize
src/core/math.aya:58: pub fn max(usize a, usize b) -> usize
src/core/math.aya:66: pub fn clamp(usize x, usize lo, usize hi) -> usize
src/core/math.aya:78: pub fn pow(int base, int exp) -> int
src/core/math.aya:89: pub fn pi() -> float
src/core/math.aya:94: fn ln2() -> float
src/core/math.aya:99: fn two_pi() -> float
src/core/math.aya:104: fn half_pi() -> float
src/core/math.aya:109: fn quarter_pi() -> float
src/core/math.aya:114: pub fn abs(float x) -> float
src/core/math.aya:122: pub fn min(float a, float b) -> float
src/core/math.aya:130: pub fn max(float a, float b) -> float
src/core/math.aya:138: pub fn clamp(float x, float lo, float hi) -> float
src/core/math.aya:150: pub fn trunc(float x) -> float
src/core/math.aya:156: pub fn floor(float x) -> float
src/core/math.aya:170: pub fn ceil(float x) -> float
src/core/math.aya:184: pub fn round(float x) -> float
src/core/math.aya:193: pub fn sqrt(float x) -> float
src/core/math.aya:226: pub fn exp(float x) -> float
src/core/math.aya:270: pub fn ln(float x) -> float
src/core/math.aya:306: pub fn log10(float x) -> float
src/core/math.aya:312: pub fn sin(float x) -> float
src/core/math.aya:328: pub fn cos(float x) -> float
src/core/math.aya:344: pub fn tan(float x) -> float
src/core/math.aya:349: fn atan_series(float z) -> float
src/core/math.aya:363: fn atan1(float x) -> float
src/core/math.aya:379: pub fn atan2(float y, float x) -> float
src/core/math.aya:399: pub fn pow(float base, int exp) -> float
src/core/math.aya:419: pub fn gcd(int a, int b) -> int
src/core/math.aya:432: pub fn lcm(int a, int b) -> int
src/core/math.aya:444: pub fn is_prime(int n) -> bool
src/core/math.aya:462: impl int
src/core/math.aya:465: fn is_even(self) -> bool
src/core/math.aya:470: fn is_odd(self) -> bool
src/core/math.aya:475: impl float
src/core/math.aya:478: fn is_nan(self) -> bool
src/core/num.aya:10: pub struct Overflowing
src/core/num.aya:17: pub fn wrapping_add(int a, int b) -> int
src/core/num.aya:23: pub fn wrapping_sub(int a, int b) -> int
src/core/num.aya:29: pub fn wrapping_mul(int a, int b) -> int
src/core/num.aya:35: pub fn wrapping_neg(int a) -> int
src/core/num.aya:41: pub fn add_overflow(int a, int b) -> bool
src/core/num.aya:47: pub fn sub_overflow(int a, int b) -> bool
src/core/num.aya:53: pub fn mul_overflow(int a, int b) -> bool
src/core/num.aya:59: pub fn saturating_add(int a, int b) -> int
src/core/num.aya:65: pub fn saturating_sub(int a, int b) -> int
src/core/num.aya:71: pub fn saturating_mul(int a, int b) -> int
src/core/num.aya:77: pub fn overflowing_add(int a, int b) -> Overflowing
src/core/num.aya:83: pub fn overflowing_sub(int a, int b) -> Overflowing
src/core/num.aya:89: pub fn overflowing_mul(int a, int b) -> Overflowing
src/core/num.aya:95: pub fn neg_overflow(int a) -> bool
src/core/num.aya:101: pub fn saturating_neg(int a) -> int
src/core/num.aya:110: pub fn overflowing_neg(int a) -> Overflowing
src/core/num.aya:116: pub fn checked_neg(int a) -> Option[int]
src/core/num.aya:125: pub fn checked_add(int a, int b) -> Option[int]
src/core/num.aya:134: pub fn checked_sub(int a, int b) -> Option[int]
src/core/num.aya:143: pub fn checked_mul(int a, int b) -> Option[int]
src/core/option.aya:7: interface Error
src/core/option.aya:8: fn what(ref self) -> String;
src/core/option.aya:11: pub enum Result[T, E]
src/core/option.aya:16: pub enum Option[T]
src/core/option.aya:21: impl[T] Option[T]
src/core/option.aya:22: fn unwrap_or(self, T default) -> T
src/core/option.aya:28: fn is_some(ref self) -> bool
src/core/option.aya:31: fn is_none(ref self) -> bool
src/core/option.aya:35: fn or(self, Option[T] other) -> Option[T]
src/core/option.aya:43: fn unwrap(self, int __line, int __col, String __file) -> T
src/core/option.aya:52: fn expect(self, String msg, int __line, int __col, String __file) -> T
src/core/option.aya:60: fn unwrap_or_else(self, Fn()->T f) -> T
src/core/option.aya:67: fn map_or[U](self, U default, Fn(T)->U f) -> U
src/core/option.aya:74: fn map[U](self, Fn(T)->U f) -> Option[U]
src/core/option.aya:81: fn and_then[U](self, Fn(T)->Option[U] f) -> Option[U]
src/core/option.aya:88: fn filter(self, Fn(T)->bool f) -> Option[T]
src/core/option.aya:100: impl[T, E] Result[T, E]
src/core/option.aya:101: fn is_ok(ref self) -> bool
src/core/option.aya:104: fn is_err(ref self) -> bool
src/core/option.aya:108: fn unwrap_or(self, T default) -> T
src/core/option.aya:115: fn ok(self) -> Option[T]
src/core/option.aya:122: fn unwrap_or_else(self, Fn(E)->T f) -> T
src/core/option.aya:129: fn map_or[U](self, U default, Fn(T)->U f) -> U
src/core/option.aya:136: fn map[U](self, Fn(T)->U f) -> Result[U, E]
src/core/option.aya:143: fn map_err[F](self, Fn(E)->F f) -> Result[T, F]
src/core/option.aya:151: fn unwrap(self, int __line, int __col, String __file) -> T
src/core/option.aya:160: fn expect(self, String msg, int __line, int __col, String __file) -> T
src/core/ord.aya:7: interface Ord
src/core/ord.aya:8: fn cmp(ref self, ref Self other) -> int;
src/core/ord.aya:11: impl int
src/core/ord.aya:14: fn cmp(ref self, ref int other) -> int
src/core/ord.aya:25: impl String
src/core/ord.aya:28: fn cmp(ref self, ref String other) -> int
src/core/panic.aya:7: fn __ayanami_panic_at(int line, int col, String file, String msg) -> void;
src/core/panic.aya:11: pub fn panic_at(int line, int col, String file, String msg) -> void
src/core/panic.aya:20: pub fn panic(String input, String msg, int __line, int __col, String __file) -> String
src/core/panic.aya:36: pub fn panic_bounds(String input, String index, String len, int __line, int __col, String __file) -> String
src/core/string.aya:5: fn __ayanami_panic_at(int line, int col, String file, String msg) -> void;
src/core/string.aya:10: fn __ayanami_panic_bounds_at(int line, int col, String file, int index, int len) -> void;
src/core/string.aya:14: pub fn panic_bounds_at(int line, int col, String file, usize index, usize len) -> void
src/core/string.aya:18: pub fn char_code(char c) -> int
src/core/string.aya:22: pub struct String
src/core/string.aya:27: interface ToString
src/core/string.aya:28: fn to_string(self) -> String;
src/core/string.aya:31: impl int
src/core/string.aya:34: fn to_string(self) -> String
src/core/string.aya:72: fn to_base(self, int base, ref String digits) -> String
src/core/string.aya:107: fn to_hex(self) -> String
src/core/string.aya:113: fn to_hex_upper(self) -> String
src/core/string.aya:119: fn to_bin(self) -> String
src/core/string.aya:125: fn to_oct(self) -> String
src/core/string.aya:133: fn pow10(int n) -> int
src/core/string.aya:146: fn pad_int(int v, int width) -> String
src/core/string.aya:159: fn zeros(int n) -> String
src/core/string.aya:172: fn trim_zeros(ref String s) -> String
src/core/string.aya:186: fn fmt_g(float x) -> String
src/core/string.aya:260: impl float
src/core/string.aya:264: fn to_string(self) -> String
src/core/string.aya:270: fn to_fixed(self, int digits) -> String
src/core/string.aya:299: fn to_sci(self, int digits) -> String
src/core/string.aya:352: impl char
src/core/string.aya:355: fn to_string(self) -> String
src/core/string.aya:360: impl bool
src/core/string.aya:363: fn to_string(self) -> String
src/core/string.aya:372: impl int
src/core/string.aya:373: fn add(self, int other) -> int
src/core/string.aya:376: fn sub(self, int other) -> int
src/core/string.aya:379: fn mul(self, int other) -> int
src/core/string.aya:382: fn div(self, int other) -> int
src/core/string.aya:385: fn rem(self, int other) -> int
src/core/string.aya:388: fn eq(self, int other) -> bool
src/core/string.aya:391: fn ne(self, int other) -> bool
src/core/string.aya:394: fn lt(self, int other) -> bool
src/core/string.aya:397: fn gt(self, int other) -> bool
src/core/string.aya:400: fn le(self, int other) -> bool
src/core/string.aya:403: fn ge(self, int other) -> bool
src/core/string.aya:406: fn neg(self) -> int
src/core/string.aya:411: impl float
src/core/string.aya:412: fn add(self, float other) -> float
src/core/string.aya:415: fn sub(self, float other) -> float
src/core/string.aya:418: fn mul(self, float other) -> float
src/core/string.aya:421: fn div(self, float other) -> float
src/core/string.aya:424: fn eq(self, float other) -> bool
src/core/string.aya:427: fn ne(self, float other) -> bool
src/core/string.aya:430: fn lt(self, float other) -> bool
src/core/string.aya:433: fn gt(self, float other) -> bool
src/core/string.aya:436: fn le(self, float other) -> bool
src/core/string.aya:439: fn ge(self, float other) -> bool
src/core/string.aya:442: fn neg(self) -> float
src/core/string.aya:447: impl char
src/core/string.aya:448: fn eq(self, char other) -> bool
src/core/string.aya:451: fn ne(self, char other) -> bool
src/core/string.aya:454: fn lt(self, char other) -> bool
src/core/string.aya:457: fn gt(self, char other) -> bool
src/core/string.aya:460: fn le(self, char other) -> bool
src/core/string.aya:463: fn ge(self, char other) -> bool
src/core/string.aya:467: fn is_digit(self) -> bool
src/core/string.aya:472: fn is_alpha(self) -> bool
src/core/string.aya:483: fn is_alnum(self) -> bool
src/core/string.aya:490: fn is_space(self) -> bool
src/core/string.aya:501: fn is_upper(self) -> bool
src/core/string.aya:506: fn is_lower(self) -> bool
src/core/string.aya:511: fn to_digit(self) -> int
src/core/string.aya:516: fn to_upper(self) -> char
src/core/string.aya:524: fn to_lower(self) -> char
src/core/string.aya:533: impl bool
src/core/string.aya:534: fn eq(self, bool other) -> bool
src/core/string.aya:537: fn ne(self, bool other) -> bool
src/core/string.aya:542: pub namespace String
src/core/string.aya:544: pub fn empty() -> String
src/core/string.aya:548: pub fn new() -> String
src/core/string.aya:552: pub fn new([char] data, usize len) -> String
src/core/string.aya:557: impl String
src/core/string.aya:558: fn to_string(self) -> String
src/core/string.aya:561: fn index(ref self, usize i, int __line, int __col, String __file) -> char
src/core/string.aya:567: fn len(ref self) -> usize
src/core/string.aya:572: fn add(ref self, ref String other) -> String
src/core/string.aya:585: fn add[T: ToString](ref self, T a) -> String
src/core/string.aya:589: fn eq(ref self, ref String other) -> bool
src/core/string.aya:600: fn ne(ref self, ref String other) -> bool
src/core/string.aya:605: fn lt(ref self, ref String other) -> bool
src/core/string.aya:622: fn gt(ref self, ref String other) -> bool
src/core/string.aya:626: fn le(ref self, ref String other) -> bool
src/core/string.aya:630: fn ge(ref self, ref String other) -> bool
src/core/string.aya:635: fn copy(ref self) -> String
src/core/string.aya:643: fn is_empty(ref self) -> bool
src/core/string.aya:647: fn index_of(ref self, ref String needle) -> int
src/core/string.aya:670: fn contains(ref self, ref String needle) -> bool
src/core/string.aya:677: fn starts_with(ref self, ref String prefix) -> bool
src/core/string.aya:689: fn ends_with(ref self, ref String suffix) -> bool
src/core/string.aya:703: fn substring(ref self, usize start, usize end) -> String
src/core/string.aya:721: fn trim(ref self) -> String
src/core/string.aya:742: fn count_char(ref self, char c) -> int
src/core/string.aya:755: fn is_whitespace(ref self) -> bool
src/core/string.aya:771: fn remove_prefix(ref self, ref String prefix) -> String
src/core/string.aya:780: fn remove_suffix(ref self, ref String suffix) -> String
src/core/string.aya:789: fn trim_start(ref self) -> String
src/core/string.aya:803: fn trim_end(ref self) -> String
src/core/string.aya:816: fn to_upper(ref self) -> String
src/core/string.aya:825: fn to_lower(ref self) -> String
src/core/string.aya:834: fn repeat(ref self, usize times) -> String
src/core/string.aya:845: fn parse_int(ref self) -> int
src/core/string.aya:883: fn is_int(ref self) -> bool
src/dev/test.aya:26: pub fn test(String input) -> String
src/dev/test.aya:32: pub fn should_panic(String input) -> String
src/dev/test.aya:38: pub fn check(bool failed, int line, int col, String file, String msg) -> int
src/dev/test.aya:47: pub fn check_close(float a, float b, float eps, int line, int col, String file, String msg) -> int
src/dev/test.aya:63: fn escape_from(String s, usize i) -> String
src/dev/test.aya:80: fn escape(String s) -> String
src/dev/test.aya:89: pub fn assert_eq(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:123: pub fn assert(String input, String cond, int __line, int __col, String __file) -> String
src/dev/test.aya:149: pub fn assert_ne(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:183: pub fn assert_lt(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:217: pub fn assert_le(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:251: pub fn assert_gt(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:285: pub fn assert_ge(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:319: pub fn assert_contains(String input, String s, String sub, int __line, int __col, String __file) -> String
src/dev/test.aya:354: pub fn assert_some(String input, String opt, int __line, int __col, String __file) -> String
src/dev/test.aya:386: pub fn assert_none(String input, String opt, int __line, int __col, String __file) -> String
src/dev/test.aya:415: pub fn assert_close(String input, String a, String b, String eps, int __line, int __col, String __file) -> String
src/dev/test.aya:451: pub fn fail(String input, String msg, int __line, int __col, String __file) -> String
src/meta/macros.aya:25: pub struct Span
src/meta/macros.aya:32: pub struct Token
src/meta/macros.aya:39: pub struct TokenStream
src/meta/macros.aya:45: fn byte_at(ref String b, int i) -> int
src/meta/macros.aya:49: fn read_u32(ref String b, int i) -> int
src/meta/macros.aya:55: fn slice_string(ref String b, int start, int n) -> String
src/meta/macros.aya:71: fn chars_to_string(ref ArrayList[char] buf) -> String
src/meta/macros.aya:84: fn push_u32(ref mut ArrayList[char] buf, int v)
src/meta/macros.aya:91: pub namespace TokenStream
src/meta/macros.aya:94: pub fn new() -> TokenStream
src/meta/macros.aya:101: pub fn from_bytes(String bytes) -> TokenStream
src/meta/macros.aya:159: pub fn to_bytes(ref TokenStream ts) -> String
src/meta/macros.aya:182: pub fn to_source(ref TokenStream ts) -> String
src/meta/macros.aya:203: pub fn append(ref mut TokenStream ts, ref TokenStream other)
src/meta/macros.aya:211: pub fn len(ref TokenStream ts) -> usize
src/meta/macros.aya:216: pub fn index(ref TokenStream ts, usize i) -> Token
src/meta/macros.aya:222: pub fn push_ident(ref mut TokenStream ts, String name)
src/meta/macros.aya:229: pub fn push_literal(ref mut TokenStream ts, String text)
src/meta/macros.aya:236: pub fn push_punct(ref mut TokenStream ts, String p)
src/meta/macros.aya:243: pub fn push_keyword(ref mut TokenStream ts, String kw)
src/meta/macros.aya:250: pub fn push_group_open(ref mut TokenStream ts, String open)
src/meta/macros.aya:257: pub fn push_group_close(ref mut TokenStream ts, String close)
src/meta/macros.aya:264: pub fn is_ident(ref Token t) -> bool
src/meta/macros.aya:269: pub fn is_literal(ref Token t) -> bool
src/meta/macros.aya:274: pub fn is_punct(ref Token t) -> bool
src/meta/macros.aya:279: pub fn is_keyword(ref Token t) -> bool
src/meta/macros.aya:284: pub fn is_group_open(ref Token t) -> bool
src/meta/macros.aya:293: pub fn is_group_close(ref Token t) -> bool
src/meta/macros.aya:304: fn __ayanami_macro_diag(int level, String msg);
src/meta/macros.aya:307: fn __ayanami_macro_hygienic(String name) -> String;
src/meta/macros.aya:310: pub fn diag_warn(String msg)
src/meta/macros.aya:315: pub fn diag_error(String msg)
src/meta/macros.aya:321: pub fn hygienic_ident(String name) -> String
src/meta/mir.aya:17: pub struct MirFunction
src/meta/mir.aya:39: pub fn schema_version() -> int
src/meta/mir.aya:45: pub fn scan_effects(ref MirFunction f) -> bool
src/meta/mir.aya:67: fn __ayanami_diag_emit(int level, String msg);
src/meta/mir.aya:70: pub fn warn(String msg)
src/meta/mir.aya:75: pub fn error(String msg)
src/meta/mir.aya:82: pub fn replace_int(ref mut MirFunction f, int idx, int value)
src/meta/mir.aya:89: pub fn replace_float(ref mut MirFunction f, int idx, int bits)
src/meta/mir.aya:96: pub fn replace_bool(ref mut MirFunction f, int idx, int value)
src/meta/mir.aya:103: pub fn replace_char(ref mut MirFunction f, int idx, int code)
src/meta/mir.aya:110: pub fn replace_with(ref mut MirFunction f, int idx, int src)
src/meta/mir.aya:117: pub fn delete_stmt(ref mut MirFunction f, int idx)
src/meta/mir.aya:124: pub fn subtree_sizes(ref MirFunction f) -> [int]
src/meta/mir.aya:142: pub fn stmt_is_assign(int k) -> bool
src/meta/mir.aya:146: pub fn stmt_is_return(int k) -> bool
src/meta/mir.aya:150: pub fn stmt_is_if(int k) -> bool
src/meta/mir.aya:154: pub fn stmt_is_while(int k) -> bool
src/meta/mir.aya:158: pub fn stmt_is_break(int k) -> bool
src/meta/mir.aya:162: pub fn stmt_is_continue(int k) -> bool
src/meta/mir.aya:167: pub fn op_is_add(int op) -> bool
src/meta/mir.aya:171: pub fn op_is_sub(int op) -> bool
src/meta/mir.aya:175: pub fn op_is_mul(int op) -> bool
src/meta/mir.aya:179: pub fn op_is_eq(int op) -> bool
src/meta/mir.aya:183: pub fn op_is_neq(int op) -> bool
src/meta/mir.aya:187: pub fn op_is_lt(int op) -> bool
src/meta/mir.aya:191: pub fn op_is_gt(int op) -> bool
src/meta/mir.aya:197: pub fn is_int_literal(ref MirFunction f, int idx) -> bool
src/meta/mir.aya:205: pub fn folded_int(ref MirFunction f, int idx) -> int
src/system/alloc.aya:16: fn __ayanami_default_alloc(usize size) -> usize;
src/system/alloc.aya:19: fn __ayanami_default_free(usize addr);
src/system/alloc.aya:22: fn __ayanami_counted_alloc(usize size) -> usize;
src/system/alloc.aya:25: fn __ayanami_counted_free(usize addr);
src/system/alloc.aya:28: fn __ayanami_live_allocs() -> int;
src/system/alloc.aya:31: interface Allocator
src/system/alloc.aya:32: fn alloc(ref self, usize size) -> usize;
src/system/alloc.aya:33: fn free(ref self, usize addr);
src/system/alloc.aya:37: pub struct DefaultAllocator {}
src/system/alloc.aya:39: impl DefaultAllocator
src/system/alloc.aya:41: fn alloc(ref self, usize size) -> usize
src/system/alloc.aya:45: fn free(ref self, usize addr)
src/system/alloc.aya:51: pub fn live_allocs() -> int
src/system/alloc.aya:56: pub fn default_alloc(usize size) -> usize
src/system/alloc.aya:61: pub fn default_free(usize addr)
src/system/channel.aya:16: pub struct ChanState[T]
src/system/channel.aya:21: pub struct Channel[T]
src/system/channel.aya:30: pub namespace Channel
src/system/channel.aya:31: pub fn new[T]() -> Channel[T]
src/system/channel.aya:46: pub fn new_bounded[T](int cap) -> Channel[T]
src/system/channel.aya:65: impl[T] Channel[T]
src/system/channel.aya:69: pub fn send(ref self, T v) -> void
src/system/channel.aya:98: pub fn try_recv(ref mut self) -> Option[T]
src/system/channel.aya:116: pub fn recv(ref mut self) -> T
src/system/channel.aya:124: pub fn recv_opt(ref mut self) -> Option[T]
src/system/channel.aya:155: pub fn close(ref self) -> void
src/system/channel.aya:168: fn pop_front[T](ref mut ChanState[T] s) -> Option[T]
src/system/channel.aya:181: fn __ayanami_futex_wait(*int addr, int expected) -> int;
src/system/channel.aya:184: fn __ayanami_futex_wake(*int addr, int n) -> int;
src/system/env.aya:9: fn __ayanami_arg_count() -> int;
src/system/env.aya:12: fn __ayanami_arg_len(int i) -> int;
src/system/env.aya:15: fn __ayanami_arg_data(int i) -> [char];
src/system/env.aya:18: fn __ayanami_env_len(String name) -> int;
src/system/env.aya:21: fn __ayanami_env_data(String name) -> [char];
src/system/env.aya:25: pub fn arg_count() -> int
src/system/env.aya:31: pub fn arg(int i) -> String
src/system/env.aya:45: pub fn get_env(String name) -> Option[String]
src/system/env.aya:61: pub fn args() -> ArrayList[String]
src/system/env.aya:74: pub fn get_env_or(String name, String fallback) -> String
src/system/env.aya:84: pub fn has_env(String name) -> bool
src/system/fs.aya:11: fn __ayanami_fs_size(String path) -> int;
src/system/fs.aya:14: fn __ayanami_fs_read(String path) -> [char];
src/system/fs.aya:17: fn __ayanami_fs_write(String path, String data) -> int;
src/system/fs.aya:20: fn __ayanami_fs_append(String path, String data) -> int;
src/system/fs.aya:23: fn __ayanami_fs_remove(String path) -> int;
src/system/fs.aya:26: fn __ayanami_fs_copy(String src, String dst) -> int;
src/system/fs.aya:29: fn __ayanami_fs_rename(String from, String to) -> int;
src/system/fs.aya:32: fn __ayanami_fs_is_dir(String path) -> int;
src/system/fs.aya:35: fn __ayanami_fs_mkdir(String path) -> int;
src/system/fs.aya:38: fn __ayanami_fs_rmdir(String path) -> int;
src/system/fs.aya:41: fn __ayanami_fs_mtime(String path) -> int;
src/system/fs.aya:44: fn __ayanami_fs_is_file(String path) -> int;
src/system/fs.aya:47: fn __ayanami_fs_list_data(String path) -> [char];
src/system/fs.aya:50: fn __ayanami_fs_list_len() -> int;
src/system/fs.aya:54: pub fn exists(String path) -> bool
src/system/fs.aya:60: pub fn read_file(String path) -> Option[String]
src/system/fs.aya:74: pub fn write_file(String path, String data) -> bool
src/system/fs.aya:84: pub fn read_lines(String path) -> Option[ArrayList[String]]
src/system/fs.aya:95: pub fn append_file(String path, String data) -> bool
src/system/fs.aya:101: pub fn remove_file(String path) -> bool
src/system/fs.aya:107: pub fn is_dir(String path) -> bool
src/system/fs.aya:115: pub fn list_dir(String path) -> Option[ArrayList[String]]
src/system/fs.aya:128: pub fn mkdir(String path) -> bool
src/system/fs.aya:134: pub fn rmdir(String path) -> bool
src/system/fs.aya:140: pub fn mtime(String path) -> Option[int]
src/system/fs.aya:150: pub fn is_file(String path) -> bool
src/system/fs.aya:156: pub fn copy_file(String src, String dst) -> bool
src/system/fs.aya:162: pub fn rename_file(String from, String to) -> bool
src/system/fs.aya:168: pub fn size(String path) -> Option[int]
src/system/fs.aya:180: pub fn copy_tree(String src, String dst) -> int
src/system/fs.aya:184: fn copy_tree_impl(String src, String dst, int depth) -> int
src/system/fs.aya:224: fn __ayanami_fs_errno() -> int;
src/system/fs.aya:227: fn __ayanami_fs_errno_kind(int e) -> int;
src/system/fs.aya:230: fn __ayanami_fs_strerror(int e) -> [char];
src/system/fs.aya:233: fn __ayanami_cstr_len([char] s) -> int;
src/system/fs.aya:236: pub enum IoErrorKind
src/system/fs.aya:248: pub struct IoError
src/system/fs.aya:254: fn classify_kind(int code) -> IoErrorKind
src/system/fs.aya:267: impl IoError
src/system/fs.aya:271: fn message(ref self) -> String
src/system/fs.aya:280: fn what(ref self) -> String
src/system/fs.aya:287: pub fn last_error(String path) -> IoError
src/system/fs.aya:294: pub fn read_file_result(String path) -> Result[String, IoError]
src/system/io.aya:9: fn __ayanami_getchar() -> int;
src/system/io.aya:13: fn __ayanami_putchar(int c);
src/system/io.aya:17: fn __ayanami_print_str([char] s, int len);
src/system/io.aya:21: fn __ayanami_print_ln();
src/system/io.aya:24: pub fn getchar() -> int
src/system/io.aya:29: pub fn putchar(int c)
src/system/io.aya:35: pub fn print(ref String n)
src/system/io.aya:41: pub fn println()
src/system/io.aya:47: pub fn println(ref String s)
src/system/io.aya:55: fn __ayanami_print_int(int n);
src/system/io.aya:59: pub fn print(int n)
src/system/io.aya:65: pub fn print(usize n)
src/system/io.aya:72: pub fn print(float f)
src/system/io.aya:78: pub fn print(bool b)
src/system/io.aya:88: pub fn print(char c)
src/system/io.aya:95: pub fn println(int n)
src/system/io.aya:102: pub fn println(usize n)
src/system/io.aya:110: pub fn println(float f)
src/system/io.aya:117: pub fn println(bool b)
src/system/io.aya:124: pub fn println(char c)
src/system/io.aya:134: pub fn read_line() -> String
src/system/io.aya:152: pub fn read_int() -> int
src/system/io.aya:160: pub fn try_read_int() -> Option[int]
src/system/io.aya:168: pub fn read_float() -> float
src/system/io.aya:176: pub fn try_read_float() -> Option[float]
src/system/io.aya:184: pub fn read_bool() -> bool
src/system/io.aya:192: pub fn try_read_bool() -> Option[bool]
src/system/io.aya:200: pub fn try_read_uint() -> Option[usize]
src/system/path.aya:15: pub fn normalize(String path) -> String
src/system/path.aya:40: pub fn join(String base, String name) -> String
src/system/path.aya:57: pub fn basename(String path) -> String
src/system/path.aya:78: pub fn dirname(String path) -> String
src/system/path.aya:102: pub fn extension(String path) -> String
src/system/rand.aya:9: fn __ayanami_random_u64() -> int;
src/system/rand.aya:11: pub struct Rng
src/system/rand.aya:15: pub namespace Rng
src/system/rand.aya:18: pub fn from_entropy() -> Rng
src/system/rand.aya:22: pub fn new(int seed) -> Rng
src/system/rand.aya:34: impl Rng
src/system/rand.aya:37: fn next_int(ref mut self) -> int
src/system/rand.aya:43: fn next_range(ref mut self, int lo, int hi) -> int
src/system/rand.aya:53: fn next_bool(ref mut self) -> bool
src/system/rand.aya:59: fn next_float01(ref mut self) -> float
src/system/rand.aya:68: pub fn shuffle[T](ref mut ArrayList[T] a, ref mut Rng r)
src/system/sync.aya:12: pub struct AtomicInt
src/system/sync.aya:16: pub namespace AtomicInt
src/system/sync.aya:18: pub fn new(int v) -> AtomicInt
src/system/sync.aya:23: impl AtomicInt
src/system/sync.aya:26: pub fn load(ref self) -> int
src/system/sync.aya:32: pub fn store(ref self, int v)
src/system/sync.aya:38: pub fn swap(ref self, int v) -> int
src/system/sync.aya:44: pub fn fetch_add(ref self, int v) -> int
src/system/sync.aya:50: pub fn fetch_sub(ref self, int v) -> int
src/system/sync.aya:56: pub fn compare_exchange(ref self, int expected, int new) -> int
src/system/sync.aya:62: pub fn fetch_and(ref self, int v) -> int
src/system/sync.aya:73: pub fn fetch_or(ref self, int v) -> int
src/system/sync.aya:84: pub fn fetch_xor(ref self, int v) -> int
src/system/sync.aya:96: pub fn fence()
src/system/sync.aya:102: pub fn cpu_relax()
src/system/sync.aya:107: fn __ayanami_futex_wait(*int addr, int expected) -> int;
src/system/sync.aya:110: fn __ayanami_futex_wake(*int addr, int n) -> int;
src/system/sync.aya:115: pub struct Mutex[T]
src/system/sync.aya:120: pub namespace Mutex
src/system/sync.aya:121: pub fn new[T](T v) -> Mutex[T]
src/system/sync.aya:126: impl[T] Mutex[T]
src/system/sync.aya:130: pub fn with_lock[U](ref mut self, Fn(ref mut T) -> U f) -> U
src/system/sync.aya:140: pub fn try_with_lock[U](ref mut self, Fn(ref mut T) -> U f) -> Option[U]
src/system/sync.aya:152: pub fn lock(ref self) -> void
src/system/sync.aya:172: pub fn unlock(ref self) -> void
src/system/sync.aya:181: pub fn data(ref mut self) -> ref mut T
src/system/sync.aya:189: pub struct RwLock[T]
src/system/sync.aya:195: pub namespace RwLock
src/system/sync.aya:196: pub fn new[T](T v) -> RwLock[T]
src/system/sync.aya:201: impl[T] RwLock[T]
src/system/sync.aya:205: pub fn with_read[U](ref self, Fn(ref T) -> U f) -> U
src/system/sync.aya:215: pub fn with_write[U](ref mut self, Fn(ref mut T) -> U f) -> U
src/system/sync.aya:225: pub fn read_lock(ref self) -> void
src/system/sync.aya:232: pub fn read_unlock(ref self) -> void
src/system/sync.aya:239: pub fn write_lock(ref self) -> void
src/system/sync.aya:246: pub fn write_unlock(ref self) -> void
src/system/sync.aya:253: pub fn try_with_read[U](ref self, Fn(ref T) -> U f) -> Option[U]
src/system/sync.aya:269: pub fn try_with_write[U](ref mut self, Fn(ref mut T) -> U f) -> Option[U]
src/system/sync.aya:280: fn acquire_read(ref self) -> void
src/system/sync.aya:296: fn release_read(ref self) -> void
src/system/sync.aya:310: fn acquire_write(ref self) -> void
src/system/sync.aya:326: fn release_write(ref self) -> void
src/system/sync.aya:334: struct BarrierTicket
src/system/sync.aya:342: struct BarrierState
src/system/sync.aya:348: pub struct Barrier
src/system/sync.aya:353: pub namespace Barrier
src/system/sync.aya:355: pub fn new(int participants) -> Barrier
src/system/sync.aya:367: impl Barrier
src/system/sync.aya:371: pub fn wait(ref self) -> void
src/system/sync.aya:406: pub struct Once
src/system/sync.aya:410: pub namespace Once
src/system/sync.aya:411: pub fn new() -> Once
src/system/sync.aya:416: impl Once
src/system/sync.aya:419: pub fn call_once(ref self, Fn() -> void f) -> void
src/system/sync.aya:441: pub struct Condvar
src/system/sync.aya:445: pub namespace Condvar
src/system/sync.aya:446: pub fn new() -> Condvar
src/system/sync.aya:451: impl Condvar
src/system/sync.aya:455: pub fn wait[T](ref self, *Mutex[T] m) -> void
src/system/sync.aya:467: pub fn notify_one(ref self) -> void
src/system/sync.aya:477: pub fn notify_all(ref self) -> void
src/system/thread.aya:10: fn __ayanami_thread_spawn(Job job) -> usize;
src/system/thread.aya:13: fn __ayanami_thread_join(usize handle) -> int;
src/system/thread.aya:16: fn __ayanami_thread_id() -> int;
src/system/thread.aya:19: fn __ayanami_thread_yield() -> int;
src/system/thread.aya:22: struct Job
src/system/thread.aya:26: pub struct Thread
src/system/thread.aya:30: pub namespace Thread
src/system/thread.aya:33: pub fn spawn(Fn() -> void f) -> Thread
src/system/thread.aya:38: impl Thread
src/system/thread.aya:41: pub fn join(self) -> void
src/system/thread.aya:48: pub fn current_id() -> int
src/system/thread.aya:54: pub fn yield_now() -> int
src/system/time.aya:12: fn __ayanami_time_millis() -> int;
src/system/time.aya:15: fn __ayanami_time_micros() -> int;
src/system/time.aya:18: fn __ayanami_time_unix() -> int;
src/system/time.aya:21: fn __ayanami_time_sleep_ms(int ms);
src/system/time.aya:26: pub fn now_millis() -> int
src/system/time.aya:33: pub fn now_micros() -> int
src/system/time.aya:40: pub fn now_unix() -> int
src/system/time.aya:47: pub fn format_ms(int ms) -> String
src/system/time.aya:68: pub fn elapsed_ms(int start) -> int
src/system/time.aya:75: pub fn sleep_ms(int ms)
tests/bench/iter_chain.aya:26: fn build(int n, int seed) -> ArrayList[int]
tests/bench/iter_chain.aya:37: fn sum_index(ref ArrayList[int] a) -> int
tests/bench/iter_chain.aya:51: fn sum_iter(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:67: fn sum_chain(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:84: fn sum_chain_for(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:96: fn sum_deep(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:115: fn sum_map_only(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:131: fn sum_filter_only(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:146: fn twice(int v) -> int
tests/bench/iter_chain.aya:151: fn sum_named(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:165: fn sum_closure(ArrayList[int] a) -> int
tests/bench/iter_chain.aya:181: fn bench_build(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:194: fn bench_index(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:207: fn bench_iter(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:219: fn bench_chain(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:231: fn bench_chain_for(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:243: fn bench_deep(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:255: fn bench_map_only(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:267: fn bench_filter_only(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:279: fn bench_named(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:291: fn bench_closure(int n, int rounds) -> Pair[int, int]
tests/bench/iter_chain.aya:303: fn ns_per_elem(int us, int elems) -> int
tests/bench/iter_chain.aya:307: fn main() -> int
tests/compile_fail/missing_import.aya:3: fn main() -> int
tests/golden/callback_dispatch.aya:5: fn triple(int x) -> int
tests/golden/callback_dispatch.aya:9: fn main() -> int
tests/golden/checksum.aya:8: fn rolling_hash(ref String s) -> int
tests/golden/checksum.aya:18: fn main() -> int
tests/golden/custom_alloc.aya:13: fn __ayanami_default_alloc(usize size) -> usize;
tests/golden/custom_alloc.aya:16: fn __ayanami_default_free(usize addr);
tests/golden/custom_alloc.aya:19: fn __ayanami_unique_alloc(usize size) -> usize
tests/golden/custom_alloc.aya:24: fn __ayanami_unique_free(usize addr)
tests/golden/custom_alloc.aya:28: fn main() -> int
tests/golden/dir_copy.aya:10: fn main() -> int
tests/golden/dir_walk.aya:10: struct Counts
tests/golden/dir_walk.aya:15: fn walk(String path, int depth) -> Counts
tests/golden/dir_walk.aya:44: fn main() -> int
tests/golden/io_print.aya:3: fn main() -> int
tests/golden/log_stats.aya:14: fn main() -> int
tests/golden/math_ops.aya:5: fn main() -> int
tests/golden/num_format.aya:5: fn main() -> int
tests/golden/overflow_arith.aya:5: fn main() -> int
tests/golden/string_ops.aya:5: fn main() -> int
tests/golden/text_ops.aya:5: fn main() -> int
tests/golden/text_pipeline.aya:10: fn main() -> int
tests/golden/text_stats.aya:8: fn main() -> int
tests/golden/usize_print.aya:5: fn main() -> int
tests/golden/word_count.aya:7: fn main() -> int
tests/unit/alloc_test.aya:6: fn use_allocator[A: Allocator](ref A a, usize size) -> usize
tests/unit/alloc_test.aya:11: struct WrapperAlloc
tests/unit/alloc_test.aya:15: impl WrapperAlloc
tests/unit/alloc_test.aya:16: fn alloc(ref self, usize size) -> usize
tests/unit/alloc_test.aya:19: fn free(ref self, usize addr)
tests/unit/alloc_test.aya:25: fn test_default_allocator()
tests/unit/alloc_test.aya:36: fn test_allocator_interface()
tests/unit/alloc_test.aya:47: fn test_default_wrappers()
tests/unit/arraylist_test.aya:6: fn test_basic()
tests/unit/arraylist_test.aya:25: fn test_capacity()
tests/unit/arraylist_test.aya:33: fn test_capacity_boundary()
tests/unit/arraylist_test.aya:54: fn test_capacity_growth()
tests/unit/arraylist_test.aya:73: fn test_contains_index_of()
tests/unit/arraylist_test.aya:89: fn test_contains_string()
tests/unit/arraylist_test.aya:101: fn test_reverse()
tests/unit/arraylist_test.aya:116: fn test_insert_remove_at()
tests/unit/arraylist_test.aya:131: fn test_first_last()
tests/unit/arraylist_test.aya:140: fn test_map_filter()
tests/unit/arraylist_test.aya:159: fn test_fold_any_all_find()
tests/unit/arraylist_test.aya:191: fn test_capture_filter()
tests/unit/arraylist_test.aya:205: fn test_retain_position_count()
tests/unit/arraylist_test.aya:229: fn test_fold_string()
tests/unit/arraylist_test.aya:245: fn test_swap()
tests/unit/arraylist_test.aya:258: fn test_dedup()
tests/unit/arraylist_test.aya:281: fn test_last_index_of()
tests/unit/assert_fail_test.aya:5: fn some3() -> Option[int]
tests/unit/assert_fail_test.aya:10: fn test_lt_fail()
tests/unit/assert_fail_test.aya:15: fn test_contains_fail()
tests/unit/assert_fail_test.aya:20: fn test_none_fail()
tests/unit/assert_fail_test.aya:25: fn test_close_fail()
tests/unit/assert_fail_test.aya:30: fn test_fail_macro()
tests/unit/assert_test.aya:5: fn some3() -> Option[int]
tests/unit/assert_test.aya:9: fn none_opt() -> Option[int]
tests/unit/assert_test.aya:14: fn test_compare_asserts()
tests/unit/assert_test.aya:22: fn test_other_asserts()
tests/unit/barrier_test.aya:8: fn barrier_run() -> int
tests/unit/barrier_test.aya:37: fn test_barrier_rendezvous()
tests/unit/barrier_test.aya:42: fn barrier_two_rounds_run() -> int
tests/unit/barrier_test.aya:72: fn test_barrier_reusable()
tests/unit/bitops_test.aya:6: fn test_popcount()
tests/unit/bitops_test.aya:14: fn test_zeros()
tests/unit/bitops_test.aya:24: fn test_power_of_two()
tests/unit/channel_test.aya:10: fn test_channel_fifo()
tests/unit/channel_test.aya:23: fn test_channel_many_items()
tests/unit/channel_test.aya:40: fn test_channel_string_payload()
tests/unit/channel_test.aya:49: fn test_channel_recv_blocks_until_send()
tests/unit/channel_test.aya:70: fn test_channel_mpsc()
tests/unit/channel_test.aya:99: fn test_channel_close()
tests/unit/channel_test.aya:110: fn test_channel_close_wakes_recv()
tests/unit/channel_test.aya:133: fn test_channel_bounded()
tests/unit/channel_test.aya:143: fn bounded_backpressure_run() -> int
tests/unit/channel_test.aya:170: fn test_channel_bounded_backpressure()
tests/unit/char_test.aya:4: fn test_classify()
tests/unit/char_test.aya:17: fn test_convert()
tests/unit/condvar_test.aya:7: fn condvar_handoff_run() -> int
tests/unit/condvar_test.aya:51: fn test_condvar_handoff()
tests/unit/condvar_test.aya:55: fn condvar_many_run() -> int
tests/unit/condvar_test.aya:103: fn test_condvar_notify_all()
tests/unit/convert_test.aya:7: fn as_float[U: Into[float]](U x) -> float
tests/unit/convert_test.aya:12: fn test_parse_int()
tests/unit/convert_test.aya:32: fn test_parse_float()
tests/unit/convert_test.aya:46: fn test_parse_bool()
tests/unit/convert_test.aya:55: fn test_convert()
tests/unit/convert_test.aya:72: fn test_result_parse()
tests/unit/convert_test.aya:84: fn test_radix_parse()
tests/unit/convert_test.aya:104: fn test_is_float()
tests/unit/convert_test.aya:112: fn test_parse_uint()
tests/unit/env_test.aya:6: fn test_args()
tests/unit/env_test.aya:13: fn test_env()
tests/unit/env_test.aya:20: fn test_env_or_args()
tests/unit/env_test.aya:29: fn test_has_env()
tests/unit/fs_test.aya:10: fn test_roundtrip()
tests/unit/fs_test.aya:18: fn test_missing()
tests/unit/fs_test.aya:24: fn test_read_lines()
tests/unit/fs_test.aya:36: fn test_append()
tests/unit/fs_test.aya:44: fn test_remove()
tests/unit/fs_test.aya:53: fn test_dir_ops()
tests/unit/fs_test.aya:68: fn test_fs_more()
tests/unit/fs_test.aya:84: fn test_copy_rename()
tests/unit/fs_test.aya:99: fn test_size_copy_tree()
tests/unit/fs_test.aya:126: fn test_error_model()
tests/unit/hash_test.aya:6: fn test_hash()
tests/unit/hashmap_test.aya:6: fn test_map_basic()
tests/unit/hashmap_test.aya:20: fn test_map_grow()
tests/unit/hashmap_test.aya:35: fn test_map_string_value()
tests/unit/hashmap_test.aya:46: fn test_keys_values()
tests/unit/hashmap_test.aya:63: fn test_map_to_string()
tests/unit/hashmap_test.aya:77: fn test_map_fold()
tests/unit/hashmap_test.aya:92: fn test_map_retain()
tests/unit/hashmap_test.aya:107: fn test_map_into_iter()
tests/unit/hashmap_test.aya:119: fn test_contains_value()
tests/unit/hashmap_test.aya:128: fn test_map_clear()
tests/unit/hashmap_test.aya:139: fn test_with_capacity()
tests/unit/hashmap_test.aya:150: fn test_get_or_insert()
tests/unit/hashmap_test.aya:163: fn test_remove_get()
tests/unit/hashmap_test.aya:175: fn test_merge()
tests/unit/hashmap_test.aya:190: fn test_map_to_list()
tests/unit/hashmap_test.aya:207: fn test_sorted_views()
tests/unit/hashmap_test.aya:222: fn test_map_values()
tests/unit/hashmap_test.aya:236: fn test_map_predicates()
tests/unit/hashset_test.aya:6: fn test_set_basic()
tests/unit/hashset_test.aya:22: fn test_set_grow()
tests/unit/hashset_test.aya:37: fn test_set_tombstone()
tests/unit/hashset_test.aya:68: fn test_to_list()
tests/unit/hashset_test.aya:79: fn test_set_to_string()
tests/unit/hashset_test.aya:92: fn test_set_fold()
tests/unit/hashset_test.aya:103: fn test_set_retain()
tests/unit/hashset_test.aya:118: fn test_set_ops()
tests/unit/hashset_test.aya:142: fn test_set_into_iter()
tests/unit/hashset_test.aya:155: fn test_subset()
tests/unit/hashset_test.aya:171: fn test_clear()
tests/unit/hashset_test.aya:184: fn test_set_capacity()
tests/unit/hashset_test.aya:194: fn test_take_superset()
tests/unit/hashset_test.aya:213: fn test_set_predicates()
tests/unit/hashset_test.aya:245: fn test_inplace_set_ops()
tests/unit/hashset_test.aya:268: fn test_sorted_list()
tests/unit/io_test.aya:6: fn test_input()
tests/unit/iter_test.aya:11: struct Countdown
tests/unit/iter_test.aya:15: impl Countdown
tests/unit/iter_test.aya:17: fn next(ref mut self) -> Option[int]
tests/unit/iter_test.aya:27: fn sum_it(Iterator[int] it) -> int
tests/unit/iter_test.aya:36: fn test_for_in_arraylist()
tests/unit/iter_test.aya:49: fn test_for_in_linkedlist()
tests/unit/iter_test.aya:61: fn test_interface_param()
tests/unit/iter_test.aya:67: fn test_for_in_strings()
tests/unit/iter_test.aya:79: fn test_map_adapter()
tests/unit/iter_test.aya:95: fn test_filter_map_compose()
tests/unit/iter_test.aya:115: fn test_take_adapter()
tests/unit/iter_test.aya:130: fn test_map_filter_take()
tests/unit/iter_test.aya:152: fn test_enumerate_zip()
tests/unit/iter_test.aya:178: fn test_string_adapters()
tests/unit/iter_test.aya:195: fn test_method_chain_enumerate()
tests/unit/iter_test.aya:207: fn test_method_chain_map_filter()
tests/unit/iter_test.aya:224: fn test_method_chain_take_zip()
tests/unit/linkedlist_test.aya:6: fn test_basic()
tests/unit/linkedlist_test.aya:18: fn test_ll_eq_ops()
tests/unit/linkedlist_test.aya:31: fn test_ll_mut_ops()
tests/unit/linkedlist_test.aya:46: fn test_ll_misc()
tests/unit/linkedlist_test.aya:59: fn test_ll_capacity_boundary()
tests/unit/linkedlist_test.aya:84: fn test_ll_functional()
tests/unit/linkedlist_test.aya:123: fn test_ll_more()
tests/unit/macros_test.aya:11: fn push_byte(ref mut ArrayList[char] b, int v)
tests/unit/macros_test.aya:16: fn push_u32le(ref mut ArrayList[char] b, int v)
tests/unit/macros_test.aya:25: fn to_str(ref ArrayList[char] b) -> String
tests/unit/macros_test.aya:39: fn enc_token(int kind, int line, int col, String payload) -> String
tests/unit/macros_test.aya:55: fn test_decode_single_ident()
tests/unit/macros_test.aya:70: fn test_decode_group_flatten()
tests/unit/macros_test.aya:96: fn test_roundtrip()
tests/unit/macros_test.aya:122: fn test_truncated_prefix()
tests/unit/macros_test.aya:136: fn test_literal_and_punct()
tests/unit/math_test.aya:6: fn test_int_ops()
tests/unit/math_test.aya:17: fn test_float_ops()
tests/unit/math_test.aya:29: fn test_gcd_lcm()
tests/unit/math_test.aya:40: fn test_prime_even()
tests/unit/math_test.aya:54: fn test_nan()
tests/unit/math_test.aya:61: fn test_exp_log_round()
tests/unit/math_test.aya:73: fn test_trig()
tests/unit/math_test.aya:83: fn test_sign()
tests/unit/math_test.aya:90: fn test_pow_negative()
tests/unit/math_test.aya:97: fn test_usize_minmax()
tests/unit/math_test.aya:106: fn test_abs_min_panics()
tests/unit/math_test.aya:113: fn test_neg_min_panics()
tests/unit/math_test.aya:120: fn test_float_special()
tests/unit/mem_test.aya:20: fn __ayanami_live_allocs() -> int;
tests/unit/mem_test.aya:22: fn churn_list() -> int
tests/unit/mem_test.aya:39: fn churn_dedup() -> int
tests/unit/mem_test.aya:48: fn churn_filter_map() -> int
tests/unit/mem_test.aya:65: fn churn_linked() -> int
tests/unit/mem_test.aya:78: fn churn_sort() -> int
tests/unit/mem_test.aya:92: fn churn_map2() -> int
tests/unit/mem_test.aya:104: fn churn_map() -> int
tests/unit/mem_test.aya:124: fn churn_set() -> int
tests/unit/mem_test.aya:143: fn churn_nested() -> int
tests/unit/mem_test.aya:159: fn test_owned_cleanup()
tests/unit/mem_test.aya:167: fn test_owned_cleanup_cycles()
tests/unit/mir_test.aya:8: fn mk(int n) -> MirFunction
tests/unit/mir_test.aya:32: fn test_schema_version()
tests/unit/mir_test.aya:37: fn test_scan_effects()
tests/unit/mir_test.aya:59: fn test_subtree_sizes()
tests/unit/mir_test.aya:71: fn test_edit_helpers()
tests/unit/mir_test.aya:98: fn test_stmt_op_predicates()
tests/unit/mutex_test.aya:8: fn test_mutex_single_thread()
tests/unit/mutex_test.aya:16: fn test_mutex_explicit_lock_unlock()
tests/unit/mutex_test.aya:25: fn test_mutex_try_lock()
tests/unit/mutex_test.aya:41: fn test_mutex_string_payload()
tests/unit/mutex_test.aya:50: fn test_mutex_contention()
tests/unit/num_test.aya:6: fn test_wrapping()
tests/unit/num_test.aya:17: fn test_overflow_flags()
tests/unit/num_test.aya:29: fn test_saturating()
tests/unit/num_test.aya:42: fn test_checked_overflowing()
tests/unit/num_test.aya:58: fn test_neg_family()
tests/unit/once_test.aya:7: fn once_run() -> int
tests/unit/once_test.aya:33: fn test_once_runs_single_time()
tests/unit/once_test.aya:38: fn test_once_waits_for_completion()
tests/unit/option_test.aya:5: fn some_int(int v) -> Option[int]
tests/unit/option_test.aya:9: fn none_int() -> Option[int]
tests/unit/option_test.aya:13: fn seven() -> int
tests/unit/option_test.aya:18: fn test_option_map()
tests/unit/option_test.aya:32: fn test_option_chain()
tests/unit/option_test.aya:51: fn test_option_chained()
tests/unit/option_test.aya:60: fn ok_int(int v) -> Result[int, int]
tests/unit/option_test.aya:64: fn err_int(int v) -> Result[int, int]
tests/unit/option_test.aya:69: fn test_result_map()
tests/unit/option_test.aya:88: fn test_unwrap_or_else_map_or()
tests/unit/option_test.aya:106: fn test_result_unwrap_or_else_map_or()
tests/unit/option_test.aya:126: fn test_option_unwrap_expect()
tests/unit/option_test.aya:134: fn test_option_unwrap_none_panics()
tests/unit/option_test.aya:140: fn test_option_expect_none_panics()
tests/unit/option_test.aya:146: fn test_result_unwrap_expect()
tests/unit/option_test.aya:154: fn test_result_unwrap_err_panics()
tests/unit/option_test.aya:160: fn test_result_expect_err_panics()
tests/unit/panic_test.aya:6: fn test_index_oob()
tests/unit/panic_test.aya:13: fn test_pop_empty()
tests/unit/panic_test.aya:19: fn test_panic_macro()
tests/unit/path_test.aya:6: fn test_path_normalize()
tests/unit/path_test.aya:15: fn test_path_join()
tests/unit/path_test.aya:26: fn test_path_basename_dirname()
tests/unit/path_test.aya:37: fn test_path_extension()
tests/unit/rand_test.aya:10: fn test_range()
tests/unit/rand_test.aya:23: fn test_deterministic()
tests/unit/rand_test.aya:32: fn test_seed_variation()
tests/unit/rand_test.aya:39: fn test_negative_seed()
tests/unit/rand_test.aya:46: fn test_entropy()
tests/unit/rand_test.aya:54: fn test_next_bool_float()
tests/unit/rand_test.aya:72: fn test_shuffle()
tests/unit/rwlock_test.aya:8: fn test_rwlock_single_thread()
tests/unit/rwlock_test.aya:18: fn test_rwlock_try()
tests/unit/rwlock_test.aya:37: fn rw_write_run() -> int
tests/unit/rwlock_test.aya:61: fn test_rwlock_concurrent_writers()
tests/unit/rwlock_test.aya:65: fn rw_read_run() -> int
tests/unit/rwlock_test.aya:91: fn test_rwlock_concurrent_readers()
tests/unit/rwlock_test.aya:95: fn rw_mixed_run() -> int
tests/unit/rwlock_test.aya:133: fn test_rwlock_mixed_read_write()
tests/unit/sort_test.aya:6: fn test_sort_int()
tests/unit/sort_test.aya:18: fn test_sort_string()
tests/unit/sort_test.aya:30: fn test_sort_edge()
tests/unit/sort_test.aya:41: fn test_string_cmp()
tests/unit/sort_test.aya:49: struct Item
tests/unit/sort_test.aya:54: impl Item
tests/unit/sort_test.aya:56: fn cmp(ref self, ref Item other) -> int
tests/unit/sort_test.aya:68: fn test_cmp()
tests/unit/sort_test.aya:81: fn test_sort_generic_int()
tests/unit/sort_test.aya:99: fn test_sort_generic_string()
tests/unit/sort_test.aya:111: fn test_sort_custom_ord_stable()
tests/unit/sort_test.aya:125: fn test_min_max()
tests/unit/sort_test.aya:138: fn test_is_sorted()
tests/unit/sort_test.aya:151: fn test_binary_search()
tests/unit/std_test.aya:5: fn mk_some() -> Option[int]
tests/unit/std_test.aya:9: fn mk_none() -> Option[int]
tests/unit/std_test.aya:13: fn mk_ok() -> Result[int, int]
tests/unit/std_test.aya:17: fn mk_err() -> Result[int, int]
tests/unit/std_test.aya:22: fn test_aggregate()
tests/unit/std_test.aya:28: fn test_option()
tests/unit/std_test.aya:38: fn test_combinators()
tests/unit/string_test.aya:4: fn test_basic()
tests/unit/string_test.aya:15: fn test_search()
tests/unit/string_test.aya:24: fn test_transform()
tests/unit/string_test.aya:33: fn test_parse()
tests/unit/string_test.aya:41: fn test_tostring()
tests/unit/string_test.aya:48: fn test_bases()
tests/unit/string_test.aya:63: fn test_trim_edges()
tests/unit/string_test.aya:74: fn test_float_format()
tests/unit/string_test.aya:88: fn test_remove_affix()
tests/unit/string_test.aya:97: fn test_self_append()
tests/unit/string_test.aya:111: fn test_is_whitespace()
tests/unit/string_test.aya:119: fn test_count_char()
tests/unit/string_test.aya:126: fn test_int_format_edges()
tests/unit/sync_block_test.aya:7: fn test_sync_block_mutex()
tests/unit/sync_block_test.aya:25: fn early_value() -> int
tests/unit/sync_block_test.aya:36: fn test_sync_block_return_value()
tests/unit/sync_test.aya:6: fn test_atomic_load_store()
tests/unit/sync_test.aya:14: fn test_atomic_swap()
tests/unit/sync_test.aya:21: fn test_atomic_fetch_add_sub()
tests/unit/sync_test.aya:32: fn test_atomic_bitwise_cas()
tests/unit/sync_test.aya:47: fn test_atomic_field_of_struct()
tests/unit/sync_test.aya:54: fn test_fence_and_relax()
tests/unit/sync_test.aya:61: fn test_spinlock_from_swap()
tests/unit/sync_test.aya:74: struct Holder
tests/unit/text_test.aya:6: fn test_split()
tests/unit/text_test.aya:20: fn test_join()
tests/unit/text_test.aya:31: fn test_replace()
tests/unit/text_test.aya:39: fn test_pad()
tests/unit/text_test.aya:46: fn test_lines()
tests/unit/text_test.aya:63: fn test_split_once()
tests/unit/text_test.aya:79: fn test_split_whitespace()
tests/unit/text_test.aya:91: fn test_count()
tests/unit/text_test.aya:99: fn test_text_iters()
tests/unit/text_test.aya:118: fn test_split_iter()
tests/unit/text_test.aya:147: fn test_count_lines()
tests/unit/text_test.aya:156: fn test_truncate()
tests/unit/thread_test.aya:8: fn test_thread_spawn_join()
tests/unit/thread_test.aya:19: fn test_thread_current_id_and_yield()
tests/unit/thread_test.aya:33: fn test_thread_many()
tests/unit/thread_test.aya:48: fn test_thread_captured_string()
tests/unit/time_test.aya:6: fn test_time()
tests/unit/time_test.aya:14: fn test_sleep()
tests/unit/time_test.aya:22: fn test_elapsed()
tests/unit/time_test.aya:30: fn test_micros_format()
