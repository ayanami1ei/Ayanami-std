#!/usr/bin/env bash
# shims.sh — 生成根目录 <模块>.aya → src/<模块>.aya 的符号链接
#
# 开发态编译器按短名 import 时优先回溯源码（std 目录下的 .aya）；
# 新增/重命名 src/ 模块后跑一次本脚本。
set -euo pipefail
cd "$(dirname "$0")/.."
n=0
for f in src/*.aya; do
    stem=$(basename "$f" .aya)
    ln -sf "$f" "$stem.aya"
    n=$((n + 1))
done
echo "shims: $n modules -> root *.aya"
