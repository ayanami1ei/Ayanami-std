#!/usr/bin/env bash
# build.sh — asm-x86_64 后端：纯手写汇编运行时（零 C 源）
# 产物：build/runtime/asm-x86_64/libruntime.a（与 C 后端同 ABI，可互换）
set -euo pipefail
cd "$(dirname "$0")/../../.."          # std 根
OUT=build/runtime/asm-x86_64
CC=${CC:-cc}
mkdir -p "$OUT"

# 汇编部分（x86-64 SysV）
$CC -c runtime/backends/asm-x86_64/core.s -o "$OUT/core.o"
$CC -c runtime/backends/asm-x86_64/arith.s -o "$OUT/arith.o"
$CC -c runtime/backends/asm-x86_64/io.s -o "$OUT/io.o"
$CC -c runtime/backends/asm-x86_64/time.s -o "$OUT/time.o"
$CC -c runtime/backends/asm-x86_64/rand.s -o "$OUT/rand.o"
$CC -c runtime/backends/asm-x86_64/fs.s -o "$OUT/fs.o"
$CC -c runtime/backends/asm-x86_64/fs_io.s -o "$OUT/fs_io.o"
$CC -c runtime/backends/asm-x86_64/args_env.s -o "$OUT/args_env.o"
$CC -c runtime/backends/asm-x86_64/panic.s -o "$OUT/panic.o"
$CC -c runtime/backends/asm-x86_64/thread.s -o "$OUT/thread.o"
$CC -c runtime/backends/asm-x86_64/futex.s -o "$OUT/futex.o"

# 纯汇编运行时：无 C 对象（原 c_rest.o 已随 i128 助手汇编化而清空）
rm -f "$OUT/libruntime.a"
ar rcs "$OUT/libruntime.a" "$OUT/core.o" "$OUT/arith.o" "$OUT/io.o" "$OUT/time.o" "$OUT/rand.o" "$OUT/fs.o" "$OUT/fs_io.o" "$OUT/args_env.o" "$OUT/panic.o" "$OUT/thread.o" "$OUT/futex.o"

# 自检（纯汇编运行时）
$CC -O2 -DAYANAMI_ASM_PORT runtime/backends/asm-x86_64/selftest.c \
    "$OUT/core.o" "$OUT/arith.o" "$OUT/io.o" "$OUT/time.o" "$OUT/rand.o" "$OUT/fs.o" "$OUT/fs_io.o" "$OUT/args_env.o" "$OUT/panic.o" "$OUT/thread.o" "$OUT/futex.o" -o "$OUT/selftest"
AYANAMI_ASM_SELFTEST=42 "$OUT/selftest"
echo "backend asm-x86_64: $OUT/libruntime.a"
