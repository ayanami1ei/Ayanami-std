#!/usr/bin/env bash
# build.sh — 构建标准库为 .lcl，并可选安装到编译器 std 目录
#
# 用法：
#   ./scripts/build.sh                        # 构建到 src/*.lcl
#   ./scripts/build.sh --install <DIR>        # 重建并复制到 <DIR>
#   AYANAMI_BIN=/path/to/ayanami ./scripts/build.sh --install /path/target/debug/std
#
# 说明：cargo 构建的编译器在开发态读取 <exe_dir>/std/*.lcl
# （即 target/debug/std），单测/回归前先把本仓库构建结果安装过去。
set -euo pipefail
cd "$(dirname "$0")/.."

BIN="${AYANAMI_BIN:-ayanami}"
if ! command -v "$BIN" >/dev/null 2>&1 && [[ ! -x "$BIN" ]]; then
    echo "error: 找不到编译器 '$BIN'（用 AYANAMI_BIN 指定路径）" >&2
    exit 1
fi

INSTALL=""
if [[ "${1:-}" == "--install" ]]; then
    INSTALL="${2:?用法: $0 --install <std 目录>}"
fi

for f in src/*.aya; do
    "$BIN" package "$f" >/dev/null
done
n=$(ls src/*.lcl | wc -l)
if [[ -n "$INSTALL" ]]; then
    mkdir -p "$INSTALL"
    cp src/*.lcl "$INSTALL/"
    echo "built $n modules -> $INSTALL"
else
    echo "built $n modules (src/*.lcl)"
fi
