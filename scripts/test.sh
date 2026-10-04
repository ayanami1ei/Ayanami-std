#!/usr/bin/env bash
# test.sh — 标准库回归测试入口
#
#   ./scripts/test.sh [--no-install] [--filter 关键字]
#
# 先经 build.sh 重建并安装 .lcl 到编译器同目录 std/，再运行：
#   - tests/unit/*_test.aya      #[test] / #[should_panic] 用例
#   - tests/compile_fail/*.aya   编译期负例（.expected 子串匹配）
#   - tests/golden/*.aya         stdout 黄金输出（.out 精确对比）
#
# 默认编译器：../target/debug/ayanami（可用 AYANAMI_BIN 覆盖）
set -uo pipefail
cd "$(dirname "$0")/.."

BIN="${AYANAMI_BIN:-../target/debug/ayanami}"
if [[ "$BIN" != */* ]]; then
    BIN="$(command -v "$BIN" || true)"
fi
if [[ -z "$BIN" || ! -x "$BIN" ]]; then
    echo "error: 找不到编译器（设 AYANAMI_BIN，或默认 ../target/debug/ayanami）" >&2
    exit 1
fi
BIN="$(cd "$(dirname "$BIN")" && pwd)/$(basename "$BIN")"

ARGS=()
for arg in "$@"; do
    if [[ "$arg" == "--no-install" ]]; then
        SKIP_INSTALL=1
    else
        ARGS+=("$arg")
    fi
done

if [[ "${SKIP_INSTALL:-0}" != "1" ]]; then
    AYANAMI_BIN="$BIN" ./scripts/build.sh --install "$(dirname "$BIN")/std" || exit 1
fi

exec python3 scripts/run_tests.py --bin "$BIN" "${ARGS[@]}"
