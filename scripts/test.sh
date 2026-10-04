#!/usr/bin/env bash
# test.sh — 标准库正/panic/负回归
#
#   正例：tests/*.aya，按 tests/positive_exit.txt（<文件> <退出码>）校验
#   panic：tests/panic_exit.txt（<文件> <退出码> <输出子串>）
#   负例：tests/compile_fail/*.aya，按同名 .expected（每行一个候选子串）校验
#
# 用法：
#   AYANAMI_BIN=<主仓>/target/debug/ayanami ./scripts/test.sh
#   ./scripts/test.sh --no-install   # 不重建 .lcl（需已安装到编译器 std 目录）
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

if [[ "${1:-}" != "--no-install" ]]; then
    AYANAMI_BIN="$BIN" ./scripts/build.sh --install "$(dirname "$BIN")/std" || exit 1
fi

fail=0 pos=0 pan=0 neg=0

while read -r name code; do
    [[ -z "${name:-}" || "$name" == \#* ]] && continue
    pos=$((pos + 1))
    timeout 120 "$BIN" run "tests/$name" >/dev/null 2>&1
    got=$?
    if [[ "$got" != "$code" ]]; then
        echo "FAIL tests/$name: exit $got, want $code"
        fail=$((fail + 1))
    fi
done < tests/positive_exit.txt

while read -r name code pat; do
    [[ -z "${name:-}" || "$name" == \#* ]] && continue
    pan=$((pan + 1))
    out=$(timeout 60 "$BIN" run "tests/$name" 2>&1)
    got=$?
    if [[ "$got" != "$code" ]]; then
        echo "FAIL tests/$name: exit $got, want $code"
        fail=$((fail + 1))
    elif [[ -n "${pat:-}" ]] && ! grep -qF -- "$pat" <<<"$out"; then
        echo "FAIL tests/$name: output missing: $pat"
        fail=$((fail + 1))
    fi
done < tests/panic_exit.txt

for f in tests/compile_fail/*.aya; do
    [[ -e "$f" ]] || continue
    neg=$((neg + 1))
    base="${f%.aya}"
    if [[ ! -f "$base.expected" ]]; then
        echo "FAIL $f: missing $base.expected"
        fail=$((fail + 1))
        continue
    fi
    out=$(timeout 60 "$BIN" check "$f" 2>&1)
    hit=0
    while IFS= read -r pat; do
        [[ -z "$pat" ]] && continue
        if grep -qF -- "$pat" <<<"$out"; then
            hit=1
            break
        fi
    done < "$base.expected"
    if [[ "$hit" != 1 ]]; then
        echo "FAIL $f: none of the expected substrings found:"
        sed 's/^/  - /' "$base.expected"
        fail=$((fail + 1))
    fi
done

echo "std tests: positive=$pos panic=$pan negative=$neg failures=$fail"
[[ "$fail" -eq 0 ]]
