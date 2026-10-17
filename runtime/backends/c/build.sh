#!/usr/bin/env bash
# build.sh — C 后端（默认）：runtime.c（含 sys.c）→ 统一产物 build/runtime/c/libruntime.a
set -euo pipefail
cd "$(dirname "$0")/../../.."          # std 根
OUT=build/runtime/c
CC=${CC:-cc}
mkdir -p "$OUT"

$CC -O2 -c runtime.c -o "$OUT/runtime.o"
ar rcs "$OUT/libruntime.a" "$OUT/runtime.o"

# 自检（ABI + 分配计数 + 时间/熵）
$CC -O2 runtime/abi_selftest.c "$OUT/runtime.o" -o "$OUT/selftest"
"$OUT/selftest"
echo "backend c: $OUT/libruntime.a"
