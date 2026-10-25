#!/usr/bin/env bash
# packaging/build.sh — 打包标准库为 .lcl（产物统一输出到 build/lcl/）
#
# 用法：
#   ./packaging/build.sh                    # 构建到 build/lcl/*.lcl
#   ./packaging/build.sh --install <DIR>    # 每模块构建后立即安装（支持冷构建）
#   AYANAMI_BIN=/path/to/ayanami ./packaging/build.sh --install /path/std
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
    core/string core/panic core/ord core/eq core/option core/math core/bitops core/arch_x86_64 core/num
    collections/list collections/arraylist collections/linkedlist collections/iter collections/text collections/sort collections/hash collections/hashmap collections/hashset
    core/convert dev/test
    system/alloc system/io system/path system/fs system/env system/process system/time system/rand system/sync system/thread system/channel
    meta/macros meta/fmt meta/mir
    std
)

# 构建产物统一在 build/ 下：扁平暂存 build/stage，输出 build/lcl
BUILD=build
LCL="$BUILD/lcl"
STAGE="$BUILD/stage"
rm -rf "$LCL" "$STAGE"
mkdir -p "$LCL" "$STAGE"
find src -name '*.aya' -exec cp {} "$STAGE/" \;

n=0
for m in "${MODULES[@]}"; do
    stem=$(basename "$m")
    "$BIN" package "$STAGE/$stem.aya" >/dev/null
    cp "$STAGE/$stem.lcl" "$LCL/$stem.lcl"
    if [[ -n "$INSTALL" ]]; then
        cp "$LCL/$stem.lcl" "$INSTALL/"
    fi
    n=$((n + 1))
done
rm -rf "$STAGE"
if [[ -n "$INSTALL" ]]; then
    echo "built $n modules -> $LCL（已安装到 $INSTALL）"
else
    echo "built $n modules -> $LCL"
fi
