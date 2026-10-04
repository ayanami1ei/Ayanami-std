#!/usr/bin/env bash
# gen_symbols.sh — 生成/校验标准库符号地图 SYMBOLS.md
#
#   ./scripts/gen_symbols.sh           # 重新生成
#   ./scripts/gen_symbols.sh --check   # 校验是否过期（过期退出 1）
#
# 查询：rg "关键词" SYMBOLS.md
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v rg &> /dev/null; then
    echo "Error: ripgrep (rg) is required but not found." >&2
    exit 1
fi

check_mode=false
[[ "${1:-}" == "--check" ]] && check_mode=true

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

{
    echo "# SYMBOLS.md — Ayanami-std 符号地图"
    echo ""
    echo "> 本文件由 scripts/gen_symbols.sh 自动生成，请勿手改。重新生成：./scripts/gen_symbols.sh"
    echo "> 查询：rg \"关键词\" SYMBOLS.md"
    echo ""
} > "$tmpfile"

rg --line-number --sort path --no-heading --color never \
    '^[[:space:]]*(pub[[:space:]]+)?(fn|struct|enum|interface|impl|type|namespace)([^A-Za-z0-9_]|$)' \
    --glob '*.aya' \
    src tests \
    | sed -E 's/^([^:]+:[0-9]+:)[[:space:]]*/\1 /; s/[[:space:]]+$//; s/[[:space:]]*\{$//' \
    >> "$tmpfile" || true

if [[ "$check_mode" == true ]]; then
    if [[ ! -f "SYMBOLS.md" ]]; then
        echo "Error: SYMBOLS.md 不存在，跑 ./scripts/gen_symbols.sh" >&2
        exit 1
    fi
    diff -u "SYMBOLS.md" "$tmpfile" >&2 || {
        echo "Error: SYMBOLS.md 已过期，跑 ./scripts/gen_symbols.sh" >&2
        exit 1
    }
    echo "SYMBOLS.md is up to date"
else
    cp "$tmpfile" SYMBOLS.md
    chmod 644 SYMBOLS.md
    echo "SYMBOLS.md updated ($(wc -l < SYMBOLS.md) lines)"
fi
