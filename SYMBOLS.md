# SYMBOLS.md — Ayanami-std 符号地图

> 本文件由 scripts/gen_symbols.sh 自动生成，请勿手改。重新生成：./scripts/gen_symbols.sh
> 查询：rg "关键词" SYMBOLS.md

src/arraylist.aya:5: pub struct ArrayList[T]
src/arraylist.aya:11: pub namespace ArrayList
src/arraylist.aya:13: pub fn new[T]() -> ArrayList[T]
src/arraylist.aya:18: pub fn with_capacity[T](usize cap) -> ArrayList[T]
src/arraylist.aya:26: impl[T] ArrayList[T]
src/arraylist.aya:29: fn expand(ref mut self)
src/arraylist.aya:43: pub fn push(ref mut self, T val)
src/arraylist.aya:49: pub fn index(ref self, usize index, int __line, int __col, String __file)->T
src/arraylist.aya:53: pub fn len(ref self)->usize{ return self.len }
src/arraylist.aya:56: pub fn set(ref mut self, usize i, T v, int __line, int __col, String __file)
src/arraylist.aya:64: pub fn pop(ref mut self, int __line, int __col, String __file) -> T
src/arraylist.aya:70: pub fn is_empty(ref self) -> bool
src/arraylist.aya:76: pub fn clear(ref mut self)
src/arraylist.aya:80: pub fn iter(ref self, fn(T) f)
src/arraylist.aya:88: impl[T:ToString] ArrayList[T]
src/arraylist.aya:91: pub fn to_string(ref self)->String
src/convert.aya:12: pub enum ParseError
src/convert.aya:18: impl String
src/convert.aya:21: pub fn try_parse_int(ref self) -> Option[int]
src/convert.aya:65: pub fn try_parse_float(ref self) -> Option[float]
src/convert.aya:125: pub fn try_parse_bool(ref self) -> Option[bool]
src/convert.aya:139: pub fn parse_float(ref self) -> float
src/convert.aya:148: pub fn parse_int_or(ref String s, int fallback) -> int
src/convert.aya:154: pub fn parse_float_or(ref String s, float fallback) -> float
src/convert.aya:160: pub fn parse_bool_or(ref String s, bool fallback) -> bool
src/convert.aya:166: impl int
src/convert.aya:168: pub fn to_float(self) -> float { return self as float }
src/convert.aya:171: pub fn to_char(self) -> char { return self as char }
src/convert.aya:174: impl float
src/convert.aya:177: pub fn to_int(self) -> int { return self as int }
src/convert.aya:180: impl char
src/convert.aya:182: pub fn to_int(self) -> int { return self as int }
src/convert.aya:185: impl bool
src/convert.aya:187: pub fn to_int(self) -> int
src/convert.aya:197: pub interface Into[T]
src/convert.aya:198: fn into(self) -> T;
src/convert.aya:201: impl int
src/convert.aya:203: pub fn into(self) -> float { return self as float }
src/convert.aya:206: impl char
src/convert.aya:208: pub fn into(self) -> int { return self as int }
src/convert.aya:211: impl bool
src/convert.aya:213: pub fn into(self) -> int
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
src/linkedlist.aya:42: pub fn index(ref self, usize index, int __line, int __col, String __file)->T
src/linkedlist.aya:47: pub fn len(ref self)->usize{ return self.len }
src/linkedlist.aya:49: pub fn iter(ref self, fn(T) f)
src/linkedlist.aya:58: impl[T:ToString] LinkedList[T]
src/linkedlist.aya:61: pub fn to_string(ref self) -> String
src/list.aya:2: pub interface List[T]
src/list.aya:3: fn push(ref mut self, T val);
src/list.aya:4: fn index(ref self, usize index)->T;
src/list.aya:5: fn len(ref self)->usize;
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
src/std.aya:36: pub fn is_none(self) -> bool
src/std.aya:41: impl[T, E] Result[T, E]
src/std.aya:42: pub fn try_unwrap(self) -> T
src/string.aya:13: pub fn panic_bounds_at(int line, int col, String file, usize index, usize len) -> void
src/string.aya:19: pub fn char_code(char c) -> int
src/string.aya:23: pub struct String
src/string.aya:28: interface ToString
src/string.aya:29: fn to_string(self) -> String;
src/string.aya:32: impl int
src/string.aya:35: pub fn to_string(self) -> String
src/string.aya:74: impl float
src/string.aya:75: pub fn to_string(self) -> String
src/string.aya:82: impl char
src/string.aya:85: pub fn to_string(self) -> String
src/string.aya:90: impl bool
src/string.aya:93: pub fn to_string(self) -> String
src/string.aya:102: impl int
src/string.aya:103: pub fn add(self, int other) -> int
src/string.aya:106: pub fn sub(self, int other) -> int
src/string.aya:109: pub fn mul(self, int other) -> int
src/string.aya:112: pub fn div(self, int other) -> int
src/string.aya:115: pub fn rem(self, int other) -> int
src/string.aya:118: pub fn eq(self, int other) -> bool
src/string.aya:121: pub fn ne(self, int other) -> bool
src/string.aya:124: pub fn lt(self, int other) -> bool
src/string.aya:127: pub fn gt(self, int other) -> bool
src/string.aya:130: pub fn le(self, int other) -> bool
src/string.aya:133: pub fn ge(self, int other) -> bool
src/string.aya:136: pub fn neg(self) -> int
src/string.aya:141: impl float
src/string.aya:142: pub fn add(self, float other) -> float
src/string.aya:145: pub fn sub(self, float other) -> float
src/string.aya:148: pub fn mul(self, float other) -> float
src/string.aya:151: pub fn div(self, float other) -> float
src/string.aya:154: pub fn eq(self, float other) -> bool
src/string.aya:157: pub fn ne(self, float other) -> bool
src/string.aya:160: pub fn lt(self, float other) -> bool
src/string.aya:163: pub fn gt(self, float other) -> bool
src/string.aya:166: pub fn le(self, float other) -> bool
src/string.aya:169: pub fn ge(self, float other) -> bool
src/string.aya:172: pub fn neg(self) -> float
src/string.aya:177: impl char
src/string.aya:178: pub fn eq(self, char other) -> bool
src/string.aya:181: pub fn ne(self, char other) -> bool
src/string.aya:184: pub fn lt(self, char other) -> bool
src/string.aya:187: pub fn gt(self, char other) -> bool
src/string.aya:190: pub fn le(self, char other) -> bool
src/string.aya:193: pub fn ge(self, char other) -> bool
src/string.aya:197: pub fn is_digit(self) -> bool
src/string.aya:202: pub fn is_alpha(self) -> bool
src/string.aya:213: pub fn is_alnum(self) -> bool
src/string.aya:220: pub fn is_space(self) -> bool
src/string.aya:231: pub fn is_upper(self) -> bool
src/string.aya:236: pub fn is_lower(self) -> bool
src/string.aya:241: pub fn to_digit(self) -> int
src/string.aya:246: pub fn to_upper(self) -> char
src/string.aya:254: pub fn to_lower(self) -> char
src/string.aya:263: impl bool
src/string.aya:264: pub fn eq(self, bool other) -> bool
src/string.aya:267: pub fn ne(self, bool other) -> bool
src/string.aya:272: pub namespace String
src/string.aya:274: pub fn empty() -> String
src/string.aya:278: pub fn new() -> String
src/string.aya:282: pub fn new([char] data, usize len) -> String
src/string.aya:287: impl String
src/string.aya:288: pub fn to_string(self) -> String
src/string.aya:291: pub fn index(ref self, usize i, int __line, int __col, String __file) -> char
src/string.aya:295: pub fn len(ref self) -> usize
src/string.aya:300: pub fn add(ref self, ref String other) -> String
src/string.aya:313: pub fn add[T: ToString](ref self, T a) -> String
src/string.aya:317: pub fn eq(ref self, ref String other) -> bool
src/string.aya:328: pub fn ne(ref self, ref String other) -> bool
src/string.aya:333: pub fn copy(ref self) -> String
src/string.aya:341: pub fn is_empty(ref self) -> bool
src/string.aya:345: pub fn index_of(ref self, ref String needle) -> int
src/string.aya:368: pub fn contains(ref self, ref String needle) -> bool
src/string.aya:375: pub fn starts_with(ref self, ref String prefix) -> bool
src/string.aya:387: pub fn ends_with(ref self, ref String suffix) -> bool
src/string.aya:401: pub fn substring(ref self, usize start, usize end) -> String
src/string.aya:419: pub fn trim(ref self) -> String
src/string.aya:440: pub fn to_upper(ref self) -> String
src/string.aya:449: pub fn to_lower(ref self) -> String
src/string.aya:458: pub fn repeat(ref self, usize times) -> String
src/string.aya:469: pub fn parse_int(ref self) -> int
src/string.aya:505: pub fn is_int(ref self) -> bool
src/test.aya:23: pub fn test(String input) -> String { return input }
src/test.aya:27: pub fn should_panic(String input) -> String { return input }
src/test.aya:32: pub fn check(bool failed, int line, int col, String file, String msg) -> int
src/test.aya:41: pub fn check_close(float a, float b, float eps, int line, int col, String file, String msg) -> int
src/test.aya:58: fn loc(int line, int col) -> String
src/test.aya:65: fn escape_from(String s, usize i) -> String
src/test.aya:82: fn escape(String s) -> String
src/test.aya:92: pub fn assert(String input, String cond, int __line, int __col, String __file) -> String
src/test.aya:101: pub fn assert_eq(String input, String a, String b, int __line, int __col, String __file) -> String
src/test.aya:110: pub fn assert_ne(String input, String a, String b, int __line, int __col, String __file) -> String
src/test.aya:119: pub fn assert_lt(String input, String a, String b, int __line, int __col, String __file) -> String
src/test.aya:127: pub fn assert_le(String input, String a, String b, int __line, int __col, String __file) -> String
src/test.aya:135: pub fn assert_gt(String input, String a, String b, int __line, int __col, String __file) -> String
src/test.aya:143: pub fn assert_ge(String input, String a, String b, int __line, int __col, String __file) -> String
src/test.aya:152: pub fn assert_contains(String input, String s, String sub, int __line, int __col, String __file) -> String
src/test.aya:161: pub fn assert_some(String input, String opt, int __line, int __col, String __file) -> String
src/test.aya:169: pub fn assert_none(String input, String opt, int __line, int __col, String __file) -> String
src/test.aya:178: pub fn assert_close(String input, String a, String b, String eps, int __line, int __col, String __file) -> String
src/test.aya:187: pub fn fail(String input, String msg, int __line, int __col, String __file) -> String
tests/compile_fail/missing_import.aya:3: fn main() -> int
tests/unit/arraylist_test.aya:5: fn test_basic() -> int
tests/unit/arraylist_test.aya:25: fn test_capacity() -> int
tests/unit/assert_fail_test.aya:4: fn some3() -> Option[int]
tests/unit/assert_fail_test.aya:9: fn test_lt_fail() -> int
tests/unit/assert_fail_test.aya:15: fn test_contains_fail() -> int
tests/unit/assert_fail_test.aya:21: fn test_none_fail() -> int
tests/unit/assert_fail_test.aya:27: fn test_close_fail() -> int
tests/unit/assert_fail_test.aya:33: fn test_fail_macro() -> int
tests/unit/assert_test.aya:4: fn some3() -> Option[int]
tests/unit/assert_test.aya:8: fn none_opt() -> Option[int]
tests/unit/assert_test.aya:13: fn test_compare_asserts() -> int
tests/unit/assert_test.aya:22: fn test_other_asserts() -> int
tests/unit/char_test.aya:4: fn test_classify() -> int
tests/unit/char_test.aya:18: fn test_convert() -> int
tests/unit/convert_test.aya:5: fn as_float[U: Into[float]](U x) -> float
tests/unit/convert_test.aya:10: fn test_parse_int() -> int
tests/unit/convert_test.aya:25: fn test_parse_float() -> int
tests/unit/convert_test.aya:40: fn test_parse_bool() -> int
tests/unit/convert_test.aya:50: fn test_convert() -> int
tests/unit/linkedlist_test.aya:5: fn test_basic() -> int
tests/unit/math_test.aya:5: fn test_int_ops() -> int
tests/unit/math_test.aya:17: fn test_float_ops() -> int
tests/unit/panic_test.aya:5: fn test_index_oob() -> int
tests/unit/panic_test.aya:13: fn test_pop_empty() -> int
tests/unit/panic_test.aya:20: fn test_panic_macro() -> int
tests/unit/std_test.aya:4: fn mk_some() -> Option[int]
tests/unit/std_test.aya:8: fn mk_none() -> Option[int]
tests/unit/std_test.aya:13: fn test_aggregate() -> int
tests/unit/std_test.aya:20: fn test_option() -> int
tests/unit/string_test.aya:4: fn test_basic() -> int
tests/unit/string_test.aya:16: fn test_search() -> int
tests/unit/string_test.aya:26: fn test_transform() -> int
tests/unit/string_test.aya:36: fn test_parse() -> int
tests/unit/string_test.aya:44: fn test_tostring() -> int
