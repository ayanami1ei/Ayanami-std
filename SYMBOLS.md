# SYMBOLS.md — Ayanami-std 符号地图

> 本文件由 scripts/gen_symbols.sh 自动生成，请勿手改。重新生成：./scripts/gen_symbols.sh
> 查询：rg "关键词" SYMBOLS.md

src/arraylist.aya:5: pub struct ArrayList[T]
src/arraylist.aya:11: pub namespace ArrayList
src/arraylist.aya:13: pub fn new[T]() -> ArrayList[T]
src/arraylist.aya:18: pub fn with_capacity[T](int cap) -> ArrayList[T]
src/arraylist.aya:26: impl[T] ArrayList[T]
src/arraylist.aya:29: fn expand(ref mut self)
src/arraylist.aya:43: pub fn push(ref mut self, T val)
src/arraylist.aya:49: pub fn index(ref self, int index, int __line, int __col, String __file)->T
src/arraylist.aya:53: pub fn len(ref self)->int{ return self.len }
src/arraylist.aya:56: pub fn set(ref mut self, int i, T v, int __line, int __col, String __file)
src/arraylist.aya:64: pub fn pop(ref mut self, int __line, int __col, String __file) -> T
src/arraylist.aya:70: pub fn is_empty(ref self) -> bool
src/arraylist.aya:76: pub fn clear(ref mut self)
src/arraylist.aya:80: pub fn iter(ref self, fn(T) f)
src/arraylist.aya:88: impl[T:ToString] ArrayList[T]
src/arraylist.aya:91: pub fn to_string(ref self)->String
src/io.aya:13: pub fn getchar() -> int
src/io.aya:17: pub fn putchar(int c)
src/io.aya:22: pub fn print(ref String n)
src/io.aya:27: pub fn println()
src/io.aya:32: pub fn println(ref String s)
src/io.aya:48: pub fn print(int n)
src/io.aya:54: pub fn print(float f)
src/io.aya:62: pub fn print(bool b)
src/io.aya:72: pub fn print(char c)
src/io.aya:79: pub fn println(int n)
src/io.aya:86: pub fn println(float f)
src/io.aya:93: pub fn println(bool b)
src/io.aya:100: pub fn println(char c)
src/linkedlist.aya:7: pub struct LinkedList[T]
src/linkedlist.aya:13: pub namespace LinkedList
src/linkedlist.aya:14: pub fn new[T]()->LinkedList[T]
src/linkedlist.aya:19: impl[T] LinkedList[T]
src/linkedlist.aya:22: fn expand(ref mut self)
src/linkedlist.aya:36: pub fn push(ref mut self, T val)
src/linkedlist.aya:42: pub fn index(ref self, int index, int __line, int __col, String __file)->T
src/linkedlist.aya:47: pub fn len(ref self)->int{ return self.len }
src/linkedlist.aya:49: pub fn iter(ref self, fn(T) f)
src/linkedlist.aya:58: impl[T:ToString] LinkedList[T]
src/linkedlist.aya:61: pub fn to_string(ref self) -> String
src/list.aya:2: pub interface List[T]
src/list.aya:3: fn push(ref mut self, T val);
src/list.aya:4: fn index(ref self, int index)->T;
src/list.aya:5: fn len(ref self)->int;
src/list.aya:6: fn iter(ref self, fn(T) f);
src/math.aya:5: pub fn abs(int x) -> int
src/math.aya:11: pub fn min(int a, int b) -> int
src/math.aya:17: pub fn max(int a, int b) -> int
src/math.aya:23: pub fn clamp(int x, int lo, int hi) -> int
src/math.aya:30: pub fn pow(int base, int exp) -> int
src/math.aya:45: pub fn abs(float x) -> float
src/math.aya:51: pub fn min(float a, float b) -> float
src/math.aya:57: pub fn max(float a, float b) -> float
src/math.aya:63: pub fn clamp(float x, float lo, float hi) -> float
src/math.aya:70: pub fn sqrt(float x) -> float { return __ayanami_sqrt(x) }
src/math.aya:73: pub fn floor(float x) -> float { return __ayanami_floor(x) }
src/math.aya:76: pub fn ceil(float x) -> float { return __ayanami_ceil(x) }
src/math.aya:79: pub fn pow(float base, int exp) -> float
src/mir.aya:14: pub struct MirFunction
src/mir.aya:37: pub fn scan_effects(ref MirFunction f) -> bool
src/mir.aya:54: pub fn warn(String msg)
src/mir.aya:59: pub fn error(String msg)
src/mir.aya:67: pub fn replace_int(ref mut MirFunction f, int idx, int value)
src/mir.aya:74: pub fn replace_float(ref mut MirFunction f, int idx, int bits)
src/mir.aya:81: pub fn replace_bool(ref mut MirFunction f, int idx, int value)
src/mir.aya:88: pub fn replace_char(ref mut MirFunction f, int idx, int code)
src/mir.aya:95: pub fn replace_with(ref mut MirFunction f, int idx, int src)
src/mir.aya:102: pub fn delete_stmt(ref mut MirFunction f, int idx)
src/mir.aya:109: pub fn subtree_sizes(ref MirFunction f) -> [int]
src/mir.aya:128: pub fn stmt_is_assign(int k) -> bool { return k == 1 }
src/mir.aya:129: pub fn stmt_is_return(int k) -> bool { return k == 4 }
src/mir.aya:130: pub fn stmt_is_if(int k) -> bool { return k == 5 }
src/mir.aya:131: pub fn stmt_is_while(int k) -> bool { return k == 6 }
src/mir.aya:132: pub fn stmt_is_break(int k) -> bool { return k == 7 }
src/mir.aya:133: pub fn stmt_is_continue(int k) -> bool { return k == 8 }
src/mir.aya:137: pub fn op_is_add(int op) -> bool { return op == 1 }
src/mir.aya:138: pub fn op_is_sub(int op) -> bool { return op == 2 }
src/mir.aya:139: pub fn op_is_mul(int op) -> bool { return op == 3 }
src/mir.aya:140: pub fn op_is_eq(int op) -> bool { return op == 6 }
src/mir.aya:141: pub fn op_is_neq(int op) -> bool { return op == 7 }
src/mir.aya:142: pub fn op_is_lt(int op) -> bool { return op == 8 }
src/mir.aya:143: pub fn op_is_gt(int op) -> bool { return op == 9 }
src/mir.aya:148: pub fn is_int_literal(ref MirFunction f, int idx) -> bool
src/mir.aya:154: pub fn folded_int(ref MirFunction f, int idx) -> int
src/panic.aya:11: pub fn panic_at(int line, int col, String file, String msg) -> void
src/panic.aya:20: pub fn panic(String input, String msg, int __line, int __col, String __file) -> String
src/panic.aya:36: pub fn panic_bounds(String input, String index, String len, int __line, int __col, String __file) -> String
src/std.aya:10: pub interface Error
src/std.aya:11: fn what(ref self) -> String;
src/std.aya:14: pub enum Result[T, E]
src/std.aya:19: pub enum Option[T]
src/std.aya:24: impl[T] Option[T]
src/std.aya:25: pub fn unwrap_or(self, T default) -> T
src/std.aya:32: pub fn is_some(self) -> bool
src/std.aya:37: impl[T, E] Result[T, E]
src/std.aya:38: pub fn try_unwrap(self) -> T
src/string.aya:13: pub fn panic_bounds_at(int line, int col, String file, int index, int len) -> void
src/string.aya:19: pub fn char_code(char c) -> int
src/string.aya:23: pub struct String
src/string.aya:28: interface ToString
src/string.aya:29: fn to_string(self) -> String;
src/string.aya:32: impl int
src/string.aya:35: pub fn to_string(self) -> String
src/string.aya:72: impl float
src/string.aya:73: pub fn to_string(self) -> String
src/string.aya:80: impl char
src/string.aya:83: pub fn to_string(self) -> String
src/string.aya:88: impl bool
src/string.aya:91: pub fn to_string(self) -> String
src/string.aya:100: impl int
src/string.aya:101: pub fn add(self, int other) -> int
src/string.aya:104: pub fn sub(self, int other) -> int
src/string.aya:107: pub fn mul(self, int other) -> int
src/string.aya:110: pub fn div(self, int other) -> int
src/string.aya:113: pub fn rem(self, int other) -> int
src/string.aya:116: pub fn eq(self, int other) -> bool
src/string.aya:119: pub fn ne(self, int other) -> bool
src/string.aya:122: pub fn lt(self, int other) -> bool
src/string.aya:125: pub fn gt(self, int other) -> bool
src/string.aya:128: pub fn le(self, int other) -> bool
src/string.aya:131: pub fn ge(self, int other) -> bool
src/string.aya:134: pub fn neg(self) -> int
src/string.aya:139: impl float
src/string.aya:140: pub fn add(self, float other) -> float
src/string.aya:143: pub fn sub(self, float other) -> float
src/string.aya:146: pub fn mul(self, float other) -> float
src/string.aya:149: pub fn div(self, float other) -> float
src/string.aya:152: pub fn eq(self, float other) -> bool
src/string.aya:155: pub fn ne(self, float other) -> bool
src/string.aya:158: pub fn lt(self, float other) -> bool
src/string.aya:161: pub fn gt(self, float other) -> bool
src/string.aya:164: pub fn le(self, float other) -> bool
src/string.aya:167: pub fn ge(self, float other) -> bool
src/string.aya:170: pub fn neg(self) -> float
src/string.aya:175: impl char
src/string.aya:176: pub fn eq(self, char other) -> bool
src/string.aya:179: pub fn ne(self, char other) -> bool
src/string.aya:182: pub fn lt(self, char other) -> bool
src/string.aya:185: pub fn gt(self, char other) -> bool
src/string.aya:188: pub fn le(self, char other) -> bool
src/string.aya:191: pub fn ge(self, char other) -> bool
src/string.aya:195: pub fn is_digit(self) -> bool
src/string.aya:200: pub fn is_alpha(self) -> bool
src/string.aya:211: pub fn is_alnum(self) -> bool
src/string.aya:218: pub fn is_space(self) -> bool
src/string.aya:229: pub fn is_upper(self) -> bool
src/string.aya:234: pub fn is_lower(self) -> bool
src/string.aya:239: pub fn to_digit(self) -> int
src/string.aya:244: pub fn to_upper(self) -> char
src/string.aya:252: pub fn to_lower(self) -> char
src/string.aya:261: impl bool
src/string.aya:262: pub fn eq(self, bool other) -> bool
src/string.aya:265: pub fn ne(self, bool other) -> bool
src/string.aya:270: pub namespace String
src/string.aya:272: pub fn empty() -> String
src/string.aya:276: pub fn new() -> String
src/string.aya:280: pub fn new([char] data, int len) -> String
src/string.aya:285: impl String
src/string.aya:286: pub fn to_string(self) -> String
src/string.aya:289: pub fn index(ref self, int i, int __line, int __col, String __file) -> char
src/string.aya:293: pub fn len(ref self) -> int
src/string.aya:298: pub fn add(ref self, ref String other) -> String
src/string.aya:311: pub fn add[T: ToString](ref self, T a) -> String
src/string.aya:315: pub fn eq(ref self, ref String other) -> bool
src/string.aya:326: pub fn ne(ref self, ref String other) -> bool
src/string.aya:331: pub fn copy(ref self) -> String
src/string.aya:339: pub fn is_empty(ref self) -> bool
src/string.aya:343: pub fn index_of(ref self, ref String needle) -> int
src/string.aya:366: pub fn contains(ref self, ref String needle) -> bool
src/string.aya:373: pub fn starts_with(ref self, ref String prefix) -> bool
src/string.aya:385: pub fn ends_with(ref self, ref String suffix) -> bool
src/string.aya:399: pub fn substring(ref self, int start, int end) -> String
src/string.aya:420: pub fn trim(ref self) -> String
src/string.aya:441: pub fn to_upper(ref self) -> String
src/string.aya:450: pub fn to_lower(ref self) -> String
src/string.aya:459: pub fn repeat(ref self, int times) -> String
src/string.aya:470: pub fn parse_int(ref self) -> int
src/string.aya:506: pub fn is_int(ref self) -> bool
tests/compile_fail/missing_import.aya:3: fn main() -> int
tests/test_arraylist.aya:3: fn main() -> int
tests/test_char.aya:3: fn main() -> int
tests/test_linkedlist.aya:3: fn main() -> int
tests/test_math.aya:3: fn main() -> int
tests/test_panic_bounds.aya:3: fn main() -> int
tests/test_panic_empty.aya:3: fn main() -> int
tests/test_panic_macro.aya:3: fn main() -> int
tests/test_std.aya:3: fn mk_some() -> Option[int]
tests/test_std.aya:7: fn mk_none() -> Option[int]
tests/test_std.aya:11: fn main() -> int
tests/test_string.aya:3: fn main() -> int
