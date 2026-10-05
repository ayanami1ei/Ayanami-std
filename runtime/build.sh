#!/usr/bin/env bash
# runtime/build.sh — 构建 libruntime.a；--test 跑 C 侧 ABI 自检
#
# 说明：当前编译器按单文件 runtime.c 链接（聚合入口）；
# 本脚本产出 libruntime.a，供替换实现/预编译链接（编译器侧支持见 issue/bead）。
set -euo pipefail
cd "$(dirname "$0")"
CC="${CC:-gcc}"

"$CC" -O2 -I. -c ../runtime.c -o runtime.o
ar rcs libruntime.a runtime.o
echo "built $(pwd)/libruntime.a"

if [[ "${1:-}" == "--test" ]]; then
    "$CC" -O2 -I. abi_selftest.c runtime.o -o /tmp/ayanami_runtime_selftest -lm
    /tmp/ayanami_runtime_selftest
fi
