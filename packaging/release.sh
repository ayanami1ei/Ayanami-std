#!/usr/bin/env bash
# packaging/release.sh — 生成 std 分发归档（.lcl + runtime 源 + 文档）
#
#   AYANAMI_BIN=... ./packaging/release.sh [输出目录（默认 build）]
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="${1:-build}"
AYANAMI_BIN="${AYANAMI_BIN:-ayanami}"
./packaging/build.sh

REL="$OUT/release"
rm -rf "$REL"
mkdir -p "$REL/lcl" "$REL/runtime"
cp build/lcl/*.lcl "$REL/lcl/"
cp runtime.c "$REL/"
cp runtime/abi.h runtime/sys.c "$REL/runtime/"
cp README.md "$REL/"

date=$(date +%Y%m%d)
tar czf "$OUT/ayanami-std-$date.tar.gz" -C "$REL" .
echo "release: $OUT/ayanami-std-$date.tar.gz"
