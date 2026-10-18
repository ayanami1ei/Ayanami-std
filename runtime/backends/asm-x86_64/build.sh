#!/usr/bin/env bash
# build.sh — asm-x86_64 后端：手写汇编（core/arith）+ 其余 C（-DAYANAMI_ASM_PORT）
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

# 其余 C 运行时（排除已汇编实现的部分）
$CC -O2 -DAYANAMI_ASM_PORT -c runtime.c -o "$OUT/c_rest.o"

ar rcs "$OUT/libruntime.a" "$OUT/core.o" "$OUT/arith.o" "$OUT/io.o" "$OUT/time.o" "$OUT/rand.o" "$OUT/c_rest.o"

# 自检（汇编实现 + 其余 C）
$CC -O2 -DAYANAMI_ASM_PORT runtime/backends/asm-x86_64/selftest.c \
    "$OUT/core.o" "$OUT/arith.o" "$OUT/io.o" "$OUT/time.o" "$OUT/rand.o" "$OUT/c_rest.o" -o "$OUT/selftest"
"$OUT/selftest"
echo "backend asm-x86_64: $OUT/libruntime.a"
