#!/usr/bin/env bash
# runtime/build.sh — 构建 libruntime.a（产物输出到 build/runtime/）；--test 跑 C 侧 ABI 自检
set -euo pipefail
cd "$(dirname "$0")"
CC="${CC:-gcc}"

OUT="../build/runtime"
mkdir -p "$OUT"
"$CC" -O2 -I. -c ../runtime.c -o "$OUT/runtime.o"
ar rcs "$OUT/libruntime.a" "$OUT/runtime.o"
echo "built $(cd "$OUT" && pwd)/libruntime.a"

if [[ "${1:-}" == "--test" ]]; then
    "$CC" -O2 -I. abi_selftest.c "$OUT/runtime.o" -o "$OUT/abi_selftest"
    "$OUT/abi_selftest"
fi
