#!/usr/bin/env bash
# check_warnings.sh — 零告警门禁：逐模块打包，任何 warning 即失败
#
#   AYANAMI_BIN=<主仓>/target/debug/ayanami ./scripts/check_warnings.sh
#
# 扁平暂存所有 src/**/*.aya 后逐个 package；汇总并打印告警位置。
set -uo pipefail
cd "$(dirname "$0")/.."

BIN="${AYANAMI_BIN:-../target/debug/ayanami}"
if [[ "$BIN" != */* ]]; then
    BIN="$(command -v "$BIN" || true)"
fi
if [[ -z "$BIN" || ! -x "$BIN" ]]; then
    echo "error: 找不到编译器（设 AYANAMI_BIN）" >&2
    exit 1
fi

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
find src -name '*.aya' -exec cp {} "$STAGE/" \;

fail=0
count=0
for f in "$STAGE"/*.aya; do
    count=$((count + 1))
    out=$("$BIN" package "$f" 2>&1)
    if grep -qi 'warning' <<<"$out"; then
        echo "WARN $(basename "$f")"
        grep -i -B1 -A3 'warning' <<<"$out" | head -6
        fail=1
    fi
done

if [[ $fail -eq 0 ]]; then
    echo "no warnings ($count modules)"
else
    echo "warnings found (see above)"
fi
exit $fail
