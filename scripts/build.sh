#!/usr/bin/env bash
# build.sh — 构建标准库为 .lcl，并可选安装到编译器 std 目录
#
# 用法：
#   ./scripts/build.sh                        # 构建到 src/**/*.lcl
#   ./scripts/build.sh --install <DIR>        # 每模块构建后立即安装（支持冷构建）
#   AYANAMI_BIN=/path/to/ayanami ./scripts/build.sh --install /path/target/debug/std
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
    mkdir -p "$INSTALL"
fi

# 依赖顺序：被依赖者在前；每模块构建后立即安装，支持冷构建
MODULES=(
    core/string core/option core/math core/panic
    collections/list collections/arraylist collections/linkedlist collections/text collections/sort collections/hash collections/hashmap collections/hashset
    core/convert dev/test
    system/io system/fs system/env system/time system/rand
    meta/mir
    std
)

# 扁平暂存：模块间用短名互相导入，编译器按同级目录解析；
# 构建产物回写到 src/ 原目录并可选安装。
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
find src -name '*.aya' -exec cp {} "$STAGE/" \;

n=0
for m in "${MODULES[@]}"; do
    stem=$(basename "$m")
    "$BIN" package "$STAGE/$stem.aya" >/dev/null
    cp "$STAGE/$stem.lcl" "src/$m.lcl"
    if [[ -n "$INSTALL" ]]; then
        cp "$STAGE/$stem.lcl" "$INSTALL/"
    fi
    n=$((n + 1))
done
if [[ -n "$INSTALL" ]]; then
    echo "built $n modules -> $INSTALL"
else
    echo "built $n modules (src/**/*.lcl)"
fi
