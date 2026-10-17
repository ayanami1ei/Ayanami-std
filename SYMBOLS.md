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
src/collections/arraylist.aya:67: fn set(ref mut self, usize i, T v, int __line, int __col, String __file)
src/collections/arraylist.aya:76: fn pop(ref mut self, int __line, int __col, String __file) -> T
src/collections/arraylist.aya:83: fn is_empty(ref self) -> bool
src/collections/arraylist.aya:88: fn clear(ref mut self)
src/collections/arraylist.aya:91: fn iter(ref self, Fn(T) f)
src/collections/arraylist.aya:99: impl[T: ToString] ArrayList[T]
src/collections/arraylist.aya:102: fn to_string(ref self) -> String
src/collections/arraylist.aya:116: impl[T: Eq] ArrayList[T]
src/collections/arraylist.aya:118: fn contains(ref self, ref T v) -> bool
src/collections/arraylist.aya:129: fn index_of(ref self, ref T v) -> int
src/collections/arraylist.aya:140: fn last_index_of(ref self, ref T v) -> int
src/collections/arraylist.aya:153: fn dedup(ref mut self)
src/collections/arraylist.aya:172: fn remove(ref mut self, ref T v) -> bool
src/collections/arraylist.aya:190: impl[T] ArrayList[T]
src/collections/arraylist.aya:194: fn map[U](ref self, Fn(T)->U f) -> ArrayList[U]
src/collections/arraylist.aya:206: fn filter(ref self, Fn(T)->bool f) -> ArrayList[T]
src/collections/arraylist.aya:218: fn fold[U](ref self, U init, Fn(U,T)->U f) -> U
src/collections/arraylist.aya:228: fn any(ref self, Fn(T)->bool f) -> bool
src/collections/arraylist.aya:239: fn all(ref self, Fn(T)->bool f) -> bool
src/collections/arraylist.aya:250: fn find(ref self, Fn(T)->bool f) -> Option[T]
src/collections/arraylist.aya:262: fn retain(ref mut self, Fn(T)->bool f)
src/collections/arraylist.aya:275: fn position(ref self, Fn(T)->bool f) -> int
src/collections/arraylist.aya:286: fn count(ref self, Fn(T)->bool f) -> usize
src/collections/arraylist.aya:299: fn reverse(ref mut self)
src/collections/arraylist.aya:312: fn swap(ref mut self, usize i, usize j, int __line, int __col, String __file)
src/collections/arraylist.aya:326: fn insert_at(ref mut self, usize idx, T v, int __line, int __col, String __file)
src/collections/arraylist.aya:343: fn remove_at(ref mut self, usize idx, int __line, int __col, String __file)
src/collections/arraylist.aya:355: fn first(ref self, int __line, int __col, String __file) -> T
src/collections/arraylist.aya:362: fn last(ref self, int __line, int __col, String __file) -> T
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
src/collections/hashset.aya:276: fn difference(ref self, ref HashSet[K] other) -> HashSet[K]
src/collections/hashset.aya:291: fn for_each(ref self, Fn(K) f)
src/collections/hashset.aya:301: fn fold[U](ref self, U init, Fn(U,K)->U f) -> U
src/collections/hashset.aya:315: fn to_list(ref self) -> ArrayList[K]
src/collections/hashset.aya:326: fn len(ref self) -> usize
src/collections/hashset.aya:329: fn is_empty(ref self) -> bool
src/collections/hashset.aya:335: impl[K: Hash + ToString] HashSet[K]
src/collections/hashset.aya:338: fn to_string(ref self) -> String
src/collections/hashset.aya:358: pub struct HashSetIter[K: Hash]
src/collections/hashset.aya:363: impl[K: Hash] HashSetIter[K]
src/collections/hashset.aya:365: fn next(ref mut self) -> Option[K]
src/collections/hashset.aya:378: impl[K: Hash] HashSet[K]
src/collections/hashset.aya:380: fn into_iter(self) -> HashSetIter[K]
src/collections/hashset.aya:386: impl[K: Hash] HashSet[K]
src/collections/hashset.aya:388: fn any(ref self, Fn(K)->bool f) -> bool
src/collections/hashset.aya:401: fn all(ref self, Fn(K)->bool f) -> bool
src/collections/hashset.aya:414: fn count(ref self, Fn(K)->bool f) -> usize
src/collections/hashset.aya:428: fn find(ref self, Fn(K)->bool f) -> Option[K]
src/collections/hashset.aya:443: impl[K: Hash + Ord] HashSet[K]
src/collections/hashset.aya:447: fn sorted_list(ref self) -> ArrayList[K]
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
src/collections/linkedlist.aya:13: pub struct LinkedList[T]
src/collections/linkedlist.aya:19: pub namespace LinkedList
src/collections/linkedlist.aya:20: pub fn new[T]() -> LinkedList[T]
src/collections/linkedlist.aya:25: pub fn with_capacity[T](usize cap) -> LinkedList[T]
src/collections/linkedlist.aya:33: impl[T] LinkedList[T]
src/collections/linkedlist.aya:36: fn expand(ref mut self)
src/collections/linkedlist.aya:51: fn push(ref mut self, T val)
src/collections/linkedlist.aya:58: fn index(ref self, usize index, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:64: fn len(ref self) -> usize
src/collections/linkedlist.aya:68: fn set(ref mut self, usize i, T v, int __line, int __col, String __file)
src/collections/linkedlist.aya:77: fn pop(ref mut self, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:84: fn is_empty(ref self) -> bool
src/collections/linkedlist.aya:89: fn clear(ref mut self)
src/collections/linkedlist.aya:92: fn iter(ref self, Fn(T) f)
src/collections/linkedlist.aya:100: impl[T: ToString] LinkedList[T]
src/collections/linkedlist.aya:103: fn to_string(ref self) -> String
src/collections/linkedlist.aya:117: impl[T: Eq] LinkedList[T]
src/collections/linkedlist.aya:119: fn contains(ref self, ref T v) -> bool
src/collections/linkedlist.aya:130: fn index_of(ref self, ref T v) -> int
src/collections/linkedlist.aya:141: fn last_index_of(ref self, ref T v) -> int
src/collections/linkedlist.aya:154: fn dedup(ref mut self)
src/collections/linkedlist.aya:173: fn remove(ref mut self, ref T v) -> bool
src/collections/linkedlist.aya:191: impl[T] LinkedList[T]
src/collections/linkedlist.aya:194: fn reverse(ref mut self)
src/collections/linkedlist.aya:207: fn swap(ref mut self, usize i, usize j, int __line, int __col, String __file)
src/collections/linkedlist.aya:221: fn insert_at(ref mut self, usize idx, T v, int __line, int __col, String __file)
src/collections/linkedlist.aya:238: fn remove_at(ref mut self, usize idx, int __line, int __col, String __file)
src/collections/linkedlist.aya:250: fn first(ref self, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:257: fn last(ref self, int __line, int __col, String __file) -> T
src/collections/linkedlist.aya:265: impl[T] LinkedList[T]
src/collections/linkedlist.aya:269: fn map[U](ref self, Fn(T)->U f) -> LinkedList[U]
src/collections/linkedlist.aya:281: fn filter(ref self, Fn(T)->bool f) -> LinkedList[T]
src/collections/linkedlist.aya:293: fn fold[U](ref self, U init, Fn(U,T)->U f) -> U
src/collections/linkedlist.aya:303: fn any(ref self, Fn(T)->bool f) -> bool
src/collections/linkedlist.aya:314: fn all(ref self, Fn(T)->bool f) -> bool
src/collections/linkedlist.aya:325: fn find(ref self, Fn(T)->bool f) -> Option[T]
src/collections/linkedlist.aya:336: fn position(ref self, Fn(T)->bool f) -> int
src/collections/linkedlist.aya:347: fn count(ref self, Fn(T)->bool f) -> usize
src/collections/linkedlist.aya:360: fn retain(ref mut self, Fn(T)->bool f)
src/collections/list.aya:2: interface List[T]
src/collections/list.aya:3: fn push(ref mut self, T val);
src/collections/list.aya:4: fn index(ref self, usize index) -> T;
src/collections/list.aya:5: fn len(ref self) -> usize;
src/collections/list.aya:6: fn iter(ref self, Fn(T) f);
src/collections/sort.aya:13: impl[T: Ord] ArrayList[T]
src/collections/sort.aya:15: fn min(ref self) -> Option[T]
src/collections/sort.aya:31: fn max(ref self) -> Option[T]
src/collections/sort.aya:47: fn is_sorted(ref self) -> bool
src/collections/sort.aya:60: fn binary_search(ref self, ref T v) -> int
src/collections/sort.aya:79: fn sort(ref mut self)
src/collections/sort.aya:102: pub fn sort[T: Ord](ref mut ArrayList[T] a)
src/collections/sort.aya:108: pub fn sort_int(ref mut ArrayList[int] a)
src/collections/sort.aya:114: pub fn sort_string(ref mut ArrayList[String] a)
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
src/core/bitops.aya:4: pub fn popcount(int x) -> int
src/core/bitops.aya:18: pub fn leading_zeros(int x) -> int
src/core/bitops.aya:34: pub fn trailing_zeros(int x) -> int
src/core/bitops.aya:50: pub fn is_power_of_two(int x) -> bool
src/core/convert.aya:13: pub enum ParseError
src/core/convert.aya:21: pub fn digit_value(char c) -> int
src/core/convert.aya:35: impl String
src/core/convert.aya:38: fn try_parse_int(ref self) -> Option[int]
src/core/convert.aya:90: fn try_parse_uint(ref self) -> Option[usize]
src/core/convert.aya:103: fn try_parse_float(ref self) -> Option[float]
src/core/convert.aya:163: fn try_parse_bool(ref self) -> Option[bool]
src/core/convert.aya:176: fn try_parse_int_radix(ref self, int base) -> Option[int]
src/core/convert.aya:227: fn parse_int_radix(ref self, int base) -> int
src/core/convert.aya:232: fn is_float(ref self) -> bool
src/core/convert.aya:237: fn parse_float(ref self) -> float
src/core/convert.aya:245: pub fn parse_int_result(ref String s) -> Result[int, ParseError]
src/core/convert.aya:258: pub fn parse_float_result(ref String s) -> Result[float, ParseError]
src/core/convert.aya:272: pub fn parse_bool_result(ref String s) -> Result[bool, ParseError]
src/core/convert.aya:286: pub fn parse_int_or(ref String s, int fallback) -> int
src/core/convert.aya:292: pub fn parse_float_or(ref String s, float fallback) -> float
src/core/convert.aya:299: pub fn parse_bool_or(ref String s, bool fallback) -> bool
src/core/convert.aya:304: impl int
src/core/convert.aya:306: fn to_float(self) -> float
src/core/convert.aya:310: fn to_char(self) -> char
src/core/convert.aya:315: impl float
src/core/convert.aya:318: fn to_int(self) -> int
src/core/convert.aya:323: impl char
src/core/convert.aya:325: fn to_int(self) -> int
src/core/convert.aya:330: impl bool
src/core/convert.aya:332: fn to_int(self) -> int
src/core/convert.aya:341: interface Into[T]
src/core/convert.aya:342: fn into(self) -> T;
src/core/convert.aya:345: impl int
src/core/convert.aya:347: fn into(self) -> float
src/core/convert.aya:352: impl char
src/core/convert.aya:354: fn into(self) -> int
src/core/convert.aya:359: impl bool
src/core/convert.aya:361: fn into(self) -> int
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
src/core/math.aya:13: pub fn min(int a, int b) -> int
src/core/math.aya:21: pub fn max(int a, int b) -> int
src/core/math.aya:29: pub fn sign(int x) -> int
src/core/math.aya:40: pub fn clamp(int x, int lo, int hi) -> int
src/core/math.aya:51: pub fn min(usize a, usize b) -> usize
src/core/math.aya:59: pub fn max(usize a, usize b) -> usize
src/core/math.aya:67: pub fn clamp(usize x, usize lo, usize hi) -> usize
src/core/math.aya:79: pub fn pow(int base, int exp) -> int
src/core/math.aya:90: pub fn pi() -> float
src/core/math.aya:95: fn ln2() -> float
src/core/math.aya:100: fn two_pi() -> float
src/core/math.aya:105: fn half_pi() -> float
src/core/math.aya:110: fn quarter_pi() -> float
src/core/math.aya:115: pub fn abs(float x) -> float
src/core/math.aya:123: pub fn min(float a, float b) -> float
src/core/math.aya:131: pub fn max(float a, float b) -> float
src/core/math.aya:139: pub fn clamp(float x, float lo, float hi) -> float
src/core/math.aya:151: pub fn trunc(float x) -> float
src/core/math.aya:157: pub fn floor(float x) -> float
src/core/math.aya:171: pub fn ceil(float x) -> float
src/core/math.aya:185: pub fn round(float x) -> float
src/core/math.aya:194: pub fn sqrt(float x) -> float
src/core/math.aya:227: pub fn exp(float x) -> float
src/core/math.aya:271: pub fn ln(float x) -> float
src/core/math.aya:307: pub fn log10(float x) -> float
src/core/math.aya:313: pub fn sin(float x) -> float
src/core/math.aya:329: pub fn cos(float x) -> float
src/core/math.aya:345: pub fn tan(float x) -> float
src/core/math.aya:350: fn atan_series(float z) -> float
src/core/math.aya:364: fn atan1(float x) -> float
src/core/math.aya:380: pub fn atan2(float y, float x) -> float
src/core/math.aya:400: pub fn pow(float base, int exp) -> float
src/core/math.aya:420: pub fn gcd(int a, int b) -> int
src/core/math.aya:433: pub fn lcm(int a, int b) -> int
src/core/math.aya:445: pub fn is_prime(int n) -> bool
src/core/math.aya:463: impl int
src/core/math.aya:466: fn is_even(self) -> bool
src/core/math.aya:471: fn is_odd(self) -> bool
src/core/math.aya:476: impl float
src/core/math.aya:479: fn is_nan(self) -> bool
src/core/num.aya:48: pub struct Overflowing
src/core/num.aya:55: pub fn wrapping_add(int a, int b) -> int
src/core/num.aya:61: pub fn wrapping_sub(int a, int b) -> int
src/core/num.aya:67: pub fn wrapping_mul(int a, int b) -> int
src/core/num.aya:73: pub fn wrapping_neg(int a) -> int
src/core/num.aya:79: pub fn add_overflow(int a, int b) -> bool
src/core/num.aya:85: pub fn sub_overflow(int a, int b) -> bool
src/core/num.aya:91: pub fn mul_overflow(int a, int b) -> bool
src/core/num.aya:97: pub fn saturating_add(int a, int b) -> int
src/core/num.aya:103: pub fn saturating_sub(int a, int b) -> int
src/core/num.aya:109: pub fn saturating_mul(int a, int b) -> int
src/core/num.aya:115: pub fn overflowing_add(int a, int b) -> Overflowing
src/core/num.aya:121: pub fn overflowing_sub(int a, int b) -> Overflowing
src/core/num.aya:127: pub fn overflowing_mul(int a, int b) -> Overflowing
src/core/num.aya:133: pub fn neg_overflow(int a) -> bool
src/core/num.aya:139: pub fn saturating_neg(int a) -> int
src/core/num.aya:148: pub fn overflowing_neg(int a) -> Overflowing
src/core/num.aya:154: pub fn checked_neg(int a) -> Option[int]
src/core/num.aya:163: pub fn checked_add(int a, int b) -> Option[int]
src/core/num.aya:172: pub fn checked_sub(int a, int b) -> Option[int]
src/core/num.aya:181: pub fn checked_mul(int a, int b) -> Option[int]
src/core/option.aya:5: interface Error
src/core/option.aya:6: fn what(ref self) -> String;
src/core/option.aya:9: pub enum Result[T, E]
src/core/option.aya:14: pub enum Option[T]
src/core/option.aya:19: impl[T] Option[T]
src/core/option.aya:20: fn unwrap_or(self, T default) -> T
src/core/option.aya:26: fn is_some(self) -> bool
src/core/option.aya:29: fn is_none(self) -> bool
src/core/option.aya:33: fn or(self, Option[T] other) -> Option[T]
src/core/option.aya:40: fn unwrap_or_else(self, Fn()->T f) -> T
src/core/option.aya:47: fn map_or[U](self, U default, Fn(T)->U f) -> U
src/core/option.aya:54: fn map[U](self, Fn(T)->U f) -> Option[U]
src/core/option.aya:61: fn and_then[U](self, Fn(T)->Option[U] f) -> Option[U]
src/core/option.aya:68: fn filter(self, Fn(T)->bool f) -> Option[T]
src/core/option.aya:80: impl[T, E] Result[T, E]
src/core/option.aya:81: fn is_ok(self) -> bool
src/core/option.aya:84: fn is_err(self) -> bool
src/core/option.aya:88: fn unwrap_or(self, T default) -> T
src/core/option.aya:95: fn ok(self) -> Option[T]
src/core/option.aya:102: fn unwrap_or_else(self, Fn(E)->T f) -> T
src/core/option.aya:109: fn map_or[U](self, U default, Fn(T)->U f) -> U
src/core/option.aya:116: fn map[U](self, Fn(T)->U f) -> Result[U, E]
src/core/option.aya:123: fn map_err[F](self, Fn(E)->F f) -> Result[T, F]
src/core/option.aya:129: fn try_unwrap(self) -> T
src/core/ord.aya:7: interface Ord
src/core/ord.aya:8: fn cmp(ref self, ref Self other) -> int;
src/core/ord.aya:11: impl int
src/core/ord.aya:14: fn cmp(ref self, ref int other) -> int
src/core/ord.aya:25: impl String
src/core/ord.aya:28: fn cmp(ref self, ref String other) -> int
src/core/panic.aya:10: pub fn panic_at(int line, int col, String file, String msg) -> void
src/core/panic.aya:19: pub fn panic(String input, String msg, int __line, int __col, String __file) -> String
src/core/panic.aya:35: pub fn panic_bounds(String input, String index, String len, int __line, int __col, String __file) -> String
src/core/string.aya:12: pub fn panic_bounds_at(int line, int col, String file, usize index, usize len) -> void
src/core/string.aya:16: pub fn char_code(char c) -> int
src/core/string.aya:20: pub struct String
src/core/string.aya:25: interface ToString
src/core/string.aya:26: fn to_string(self) -> String;
src/core/string.aya:29: impl int
src/core/string.aya:32: fn to_string(self) -> String
src/core/string.aya:70: fn to_base(self, int base, ref String digits) -> String
src/core/string.aya:105: fn to_hex(self) -> String
src/core/string.aya:111: fn to_hex_upper(self) -> String
src/core/string.aya:117: fn to_bin(self) -> String
src/core/string.aya:123: fn to_oct(self) -> String
src/core/string.aya:131: fn pow10(int n) -> int
src/core/string.aya:144: fn pad_int(int v, int width) -> String
src/core/string.aya:157: fn zeros(int n) -> String
src/core/string.aya:170: fn trim_zeros(ref String s) -> String
src/core/string.aya:184: fn fmt_g(float x) -> String
src/core/string.aya:258: impl float
src/core/string.aya:262: fn to_string(self) -> String
src/core/string.aya:268: fn to_fixed(self, int digits) -> String
src/core/string.aya:297: fn to_sci(self, int digits) -> String
src/core/string.aya:350: impl char
src/core/string.aya:353: fn to_string(self) -> String
src/core/string.aya:358: impl bool
src/core/string.aya:361: fn to_string(self) -> String
src/core/string.aya:370: impl int
src/core/string.aya:371: fn add(self, int other) -> int
src/core/string.aya:374: fn sub(self, int other) -> int
src/core/string.aya:377: fn mul(self, int other) -> int
src/core/string.aya:380: fn div(self, int other) -> int
src/core/string.aya:383: fn rem(self, int other) -> int
src/core/string.aya:386: fn eq(self, int other) -> bool
src/core/string.aya:389: fn ne(self, int other) -> bool
src/core/string.aya:392: fn lt(self, int other) -> bool
src/core/string.aya:395: fn gt(self, int other) -> bool
src/core/string.aya:398: fn le(self, int other) -> bool
src/core/string.aya:401: fn ge(self, int other) -> bool
src/core/string.aya:404: fn neg(self) -> int
src/core/string.aya:410: impl float
src/core/string.aya:411: fn add(self, float other) -> float
src/core/string.aya:414: fn sub(self, float other) -> float
src/core/string.aya:417: fn mul(self, float other) -> float
src/core/string.aya:420: fn div(self, float other) -> float
src/core/string.aya:423: fn eq(self, float other) -> bool
src/core/string.aya:426: fn ne(self, float other) -> bool
src/core/string.aya:429: fn lt(self, float other) -> bool
src/core/string.aya:432: fn gt(self, float other) -> bool
src/core/string.aya:435: fn le(self, float other) -> bool
src/core/string.aya:438: fn ge(self, float other) -> bool
src/core/string.aya:441: fn neg(self) -> float
src/core/string.aya:446: impl char
src/core/string.aya:447: fn eq(self, char other) -> bool
src/core/string.aya:450: fn ne(self, char other) -> bool
src/core/string.aya:453: fn lt(self, char other) -> bool
src/core/string.aya:456: fn gt(self, char other) -> bool
src/core/string.aya:459: fn le(self, char other) -> bool
src/core/string.aya:462: fn ge(self, char other) -> bool
src/core/string.aya:466: fn is_digit(self) -> bool
src/core/string.aya:471: fn is_alpha(self) -> bool
src/core/string.aya:482: fn is_alnum(self) -> bool
src/core/string.aya:489: fn is_space(self) -> bool
src/core/string.aya:500: fn is_upper(self) -> bool
src/core/string.aya:505: fn is_lower(self) -> bool
src/core/string.aya:510: fn to_digit(self) -> int
src/core/string.aya:515: fn to_upper(self) -> char
src/core/string.aya:523: fn to_lower(self) -> char
src/core/string.aya:532: impl bool
src/core/string.aya:533: fn eq(self, bool other) -> bool
src/core/string.aya:536: fn ne(self, bool other) -> bool
src/core/string.aya:541: pub namespace String
src/core/string.aya:543: pub fn empty() -> String
src/core/string.aya:547: pub fn new() -> String
src/core/string.aya:551: pub fn new([char] data, usize len) -> String
src/core/string.aya:556: impl String
src/core/string.aya:557: fn to_string(self) -> String
src/core/string.aya:560: fn index(ref self, usize i, int __line, int __col, String __file) -> char
src/core/string.aya:566: fn len(ref self) -> usize
src/core/string.aya:571: fn add(ref self, ref String other) -> String
src/core/string.aya:584: fn add[T: ToString](ref self, T a) -> String
src/core/string.aya:588: fn eq(ref self, ref String other) -> bool
src/core/string.aya:599: fn ne(ref self, ref String other) -> bool
src/core/string.aya:604: fn lt(ref self, ref String other) -> bool
src/core/string.aya:621: fn gt(ref self, ref String other) -> bool
src/core/string.aya:625: fn le(ref self, ref String other) -> bool
src/core/string.aya:629: fn ge(ref self, ref String other) -> bool
src/core/string.aya:634: fn copy(ref self) -> String
src/core/string.aya:642: fn is_empty(ref self) -> bool
src/core/string.aya:646: fn index_of(ref self, ref String needle) -> int
src/core/string.aya:669: fn contains(ref self, ref String needle) -> bool
src/core/string.aya:676: fn starts_with(ref self, ref String prefix) -> bool
src/core/string.aya:688: fn ends_with(ref self, ref String suffix) -> bool
src/core/string.aya:702: fn substring(ref self, usize start, usize end) -> String
src/core/string.aya:720: fn trim(ref self) -> String
src/core/string.aya:741: fn count_char(ref self, char c) -> int
src/core/string.aya:754: fn is_whitespace(ref self) -> bool
src/core/string.aya:770: fn remove_prefix(ref self, ref String prefix) -> String
src/core/string.aya:779: fn remove_suffix(ref self, ref String suffix) -> String
src/core/string.aya:788: fn trim_start(ref self) -> String
src/core/string.aya:802: fn trim_end(ref self) -> String
src/core/string.aya:815: fn to_upper(ref self) -> String
src/core/string.aya:824: fn to_lower(ref self) -> String
src/core/string.aya:833: fn repeat(ref self, usize times) -> String
src/core/string.aya:844: fn parse_int(ref self) -> int
src/core/string.aya:882: fn is_int(ref self) -> bool
src/dev/test.aya:24: pub fn test(String input) -> String
src/dev/test.aya:30: pub fn should_panic(String input) -> String
src/dev/test.aya:36: pub fn check(bool failed, int line, int col, String file, String msg) -> int
src/dev/test.aya:45: pub fn check_close(float a, float b, float eps, int line, int col, String file, String msg) -> int
src/dev/test.aya:61: fn loc(int line, int col) -> String
src/dev/test.aya:68: fn escape_from(String s, usize i) -> String
src/dev/test.aya:85: fn escape(String s) -> String
src/dev/test.aya:94: pub fn assert(String input, String cond, int __line, int __col, String __file) -> String
src/dev/test.aya:102: pub fn assert_eq(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:110: pub fn assert_ne(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:118: pub fn assert_lt(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:125: pub fn assert_le(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:132: pub fn assert_gt(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:139: pub fn assert_ge(String input, String a, String b, int __line, int __col, String __file) -> String
src/dev/test.aya:147: pub fn assert_contains(String input, String s, String sub, int __line, int __col, String __file) -> String
src/dev/test.aya:155: pub fn assert_some(String input, String opt, int __line, int __col, String __file) -> String
src/dev/test.aya:162: pub fn assert_none(String input, String opt, int __line, int __col, String __file) -> String
src/dev/test.aya:170: pub fn assert_close(String input, String a, String b, String eps, int __line, int __col, String __file) -> String
src/dev/test.aya:178: pub fn fail(String input, String msg, int __line, int __col, String __file) -> String
src/meta/mir.aya:13: pub struct MirFunction
src/meta/mir.aya:36: pub fn scan_effects(ref MirFunction f) -> bool
src/meta/mir.aya:60: pub fn warn(String msg)
src/meta/mir.aya:65: pub fn error(String msg)
src/meta/mir.aya:72: pub fn replace_int(ref mut MirFunction f, int idx, int value)
src/meta/mir.aya:79: pub fn replace_float(ref mut MirFunction f, int idx, int bits)
src/meta/mir.aya:86: pub fn replace_bool(ref mut MirFunction f, int idx, int value)
src/meta/mir.aya:93: pub fn replace_char(ref mut MirFunction f, int idx, int code)
src/meta/mir.aya:100: pub fn replace_with(ref mut MirFunction f, int idx, int src)
src/meta/mir.aya:107: pub fn delete_stmt(ref mut MirFunction f, int idx)
src/meta/mir.aya:114: pub fn subtree_sizes(ref MirFunction f) -> [int]
src/meta/mir.aya:132: pub fn stmt_is_assign(int k) -> bool
src/meta/mir.aya:136: pub fn stmt_is_return(int k) -> bool
src/meta/mir.aya:140: pub fn stmt_is_if(int k) -> bool
src/meta/mir.aya:144: pub fn stmt_is_while(int k) -> bool
src/meta/mir.aya:148: pub fn stmt_is_break(int k) -> bool
src/meta/mir.aya:152: pub fn stmt_is_continue(int k) -> bool
src/meta/mir.aya:157: pub fn op_is_add(int op) -> bool
src/meta/mir.aya:161: pub fn op_is_sub(int op) -> bool
src/meta/mir.aya:165: pub fn op_is_mul(int op) -> bool
src/meta/mir.aya:169: pub fn op_is_eq(int op) -> bool
src/meta/mir.aya:173: pub fn op_is_neq(int op) -> bool
src/meta/mir.aya:177: pub fn op_is_lt(int op) -> bool
src/meta/mir.aya:181: pub fn op_is_gt(int op) -> bool
src/meta/mir.aya:187: pub fn is_int_literal(ref MirFunction f, int idx) -> bool
src/meta/mir.aya:195: pub fn folded_int(ref MirFunction f, int idx) -> int
src/system/env.aya:20: pub fn arg_count() -> int
src/system/env.aya:26: pub fn arg(int i) -> String
src/system/env.aya:40: pub fn get_env(String name) -> Option[String]
src/system/env.aya:56: pub fn args() -> ArrayList[String]
src/system/env.aya:69: pub fn get_env_or(String name, String fallback) -> String
src/system/env.aya:79: pub fn has_env(String name) -> bool
src/system/fs.aya:40: pub fn exists(String path) -> bool
src/system/fs.aya:46: pub fn read_file(String path) -> Option[String]
src/system/fs.aya:60: pub fn write_file(String path, String data) -> bool
src/system/fs.aya:70: pub fn read_lines(String path) -> Option[ArrayList[String]]
src/system/fs.aya:81: pub fn append_file(String path, String data) -> bool
src/system/fs.aya:87: pub fn remove_file(String path) -> bool
src/system/fs.aya:93: pub fn is_dir(String path) -> bool
src/system/fs.aya:101: pub fn list_dir(String path) -> Option[ArrayList[String]]
src/system/fs.aya:114: pub fn mkdir(String path) -> bool
src/system/fs.aya:120: pub fn rmdir(String path) -> bool
src/system/fs.aya:126: pub fn mtime(String path) -> Option[int]
src/system/fs.aya:136: pub fn is_file(String path) -> bool
src/system/fs.aya:142: pub fn copy_file(String src, String dst) -> bool
src/system/fs.aya:148: pub fn rename_file(String from, String to) -> bool
src/system/fs.aya:154: pub fn size(String path) -> Option[int]
src/system/fs.aya:166: pub fn copy_tree(String src, String dst) -> int
src/system/fs.aya:170: fn copy_tree_impl(String src, String dst, int depth) -> int
src/system/io.aya:20: pub fn getchar() -> int
src/system/io.aya:25: pub fn putchar(int c)
src/system/io.aya:31: pub fn print(ref String n)
src/system/io.aya:37: pub fn println()
src/system/io.aya:43: pub fn println(ref String s)
src/system/io.aya:54: pub fn print(int n)
src/system/io.aya:60: pub fn print(usize n)
src/system/io.aya:67: pub fn print(float f)
src/system/io.aya:73: pub fn print(bool b)
src/system/io.aya:83: pub fn print(char c)
src/system/io.aya:90: pub fn println(int n)
src/system/io.aya:97: pub fn println(usize n)
src/system/io.aya:105: pub fn println(float f)
src/system/io.aya:112: pub fn println(bool b)
src/system/io.aya:119: pub fn println(char c)
src/system/io.aya:129: pub fn read_line() -> String
src/system/io.aya:147: pub fn read_int() -> int
src/system/io.aya:155: pub fn try_read_int() -> Option[int]
src/system/io.aya:163: pub fn read_float() -> float
src/system/io.aya:171: pub fn try_read_float() -> Option[float]
src/system/io.aya:179: pub fn read_bool() -> bool
src/system/io.aya:187: pub fn try_read_bool() -> Option[bool]
src/system/io.aya:195: pub fn try_read_uint() -> Option[usize]
src/system/rand.aya:10: pub struct Rng
src/system/rand.aya:14: pub namespace Rng
src/system/rand.aya:17: pub fn from_entropy() -> Rng
src/system/rand.aya:21: pub fn new(int seed) -> Rng
src/system/rand.aya:33: impl Rng
src/system/rand.aya:36: fn next_int(ref mut self) -> int
src/system/rand.aya:42: fn next_range(ref mut self, int lo, int hi) -> int
src/system/rand.aya:52: fn next_bool(ref mut self) -> bool
src/system/rand.aya:58: fn next_float01(ref mut self) -> float
src/system/rand.aya:67: pub fn shuffle[T](ref mut ArrayList[T] a, ref mut Rng r)
src/system/time.aya:21: pub fn now_millis() -> int
src/system/time.aya:27: pub fn now_micros() -> int
src/system/time.aya:33: pub fn now_unix() -> int
src/system/time.aya:40: pub fn format_ms(int ms) -> String
src/system/time.aya:60: pub fn elapsed_ms(int start) -> int
src/system/time.aya:66: pub fn sleep_ms(int ms)
tests/compile_fail/missing_import.aya:3: fn main() -> int
tests/golden/callback_dispatch.aya:5: fn triple(int x) -> int
tests/golden/callback_dispatch.aya:9: fn main() -> int
tests/golden/checksum.aya:8: fn rolling_hash(ref String s) -> int
tests/golden/checksum.aya:18: fn main() -> int
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
tests/unit/arraylist_test.aya:6: fn test_basic()
tests/unit/arraylist_test.aya:25: fn test_capacity()
tests/unit/arraylist_test.aya:33: fn test_contains_index_of()
tests/unit/arraylist_test.aya:49: fn test_contains_string()
tests/unit/arraylist_test.aya:61: fn test_reverse()
tests/unit/arraylist_test.aya:76: fn test_insert_remove_at()
tests/unit/arraylist_test.aya:91: fn test_first_last()
tests/unit/arraylist_test.aya:100: fn test_map_filter()
tests/unit/arraylist_test.aya:119: fn test_fold_any_all_find()
tests/unit/arraylist_test.aya:151: fn test_capture_filter()
tests/unit/arraylist_test.aya:165: fn test_retain_position_count()
tests/unit/arraylist_test.aya:189: fn test_fold_string()
tests/unit/arraylist_test.aya:205: fn test_swap()
tests/unit/arraylist_test.aya:218: fn test_dedup()
tests/unit/arraylist_test.aya:241: fn test_last_index_of()
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
tests/unit/bitops_test.aya:6: fn test_popcount()
tests/unit/bitops_test.aya:14: fn test_zeros()
tests/unit/bitops_test.aya:24: fn test_power_of_two()
tests/unit/char_test.aya:4: fn test_classify()
tests/unit/char_test.aya:17: fn test_convert()
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
tests/unit/linkedlist_test.aya:6: fn test_basic()
tests/unit/linkedlist_test.aya:18: fn test_ll_eq_ops()
tests/unit/linkedlist_test.aya:31: fn test_ll_mut_ops()
tests/unit/linkedlist_test.aya:46: fn test_ll_misc()
tests/unit/linkedlist_test.aya:59: fn test_ll_functional()
tests/unit/linkedlist_test.aya:98: fn test_ll_more()
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
tests/unit/num_test.aya:6: fn test_wrapping()
tests/unit/num_test.aya:17: fn test_overflow_flags()
tests/unit/num_test.aya:29: fn test_saturating()
tests/unit/num_test.aya:42: fn test_checked_overflowing()
tests/unit/num_test.aya:58: fn test_neg_family()
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
tests/unit/panic_test.aya:6: fn test_index_oob()
tests/unit/panic_test.aya:13: fn test_pop_empty()
tests/unit/panic_test.aya:19: fn test_panic_macro()
tests/unit/rand_test.aya:10: fn test_range()
tests/unit/rand_test.aya:23: fn test_deterministic()
tests/unit/rand_test.aya:32: fn test_seed_variation()
tests/unit/rand_test.aya:39: fn test_negative_seed()
tests/unit/rand_test.aya:46: fn test_entropy()
tests/unit/rand_test.aya:54: fn test_next_bool_float()
tests/unit/rand_test.aya:72: fn test_shuffle()
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
tests/unit/time_test.aya:6: fn test_time()
tests/unit/time_test.aya:14: fn test_sleep()
tests/unit/time_test.aya:22: fn test_elapsed()
tests/unit/time_test.aya:30: fn test_micros_format()
