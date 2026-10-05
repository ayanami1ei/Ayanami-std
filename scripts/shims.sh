#!/usr/bin/env bash
# shims.sh — 生成根目录 <模块>.aya → src/**/<模块>.aya 的符号链接
#
# 开发态编译器按短名 import 时优先回溯源码；新增/移动 src/ 模块后跑一次。
set -euo pipefail
cd "$(dirname "$0")/.."
n=0
while IFS= read -r f; do
    stem=$(basename "$f" .aya)
    ln -sf "$f" "$stem.aya"
    n=$((n + 1))
done < <(find src -name '*.aya' | sort)
echo "shims: $n modules -> root *.aya"
