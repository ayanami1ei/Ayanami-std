#!/usr/bin/env bash
# backend.sh — 运行时后端选择接口（C / asm-x86_64）
#
#   ./runtime/backend.sh list                     列出可用后端
#   ./runtime/backend.sh build <backend>          构建后端 → build/runtime/<backend>/libruntime.a
#   ./runtime/backend.sh env <backend>            输出 AYANAMI_RUNTIME=<归档>（可 eval）
#   ./runtime/backend.sh run <backend> -- <cmd...>  以指定后端运行命令
#
# 契约：所有后端实现同一 ABI（runtime/abi.h 符号集 + AYANAMI_RUNTIME_ABI=1），
# 产物统一为静态库；编译器经 AYANAMI_RUNTIME（env）或 ayanami.toml [runtime] path 接入。
# 后端目录：runtime/backends/<name>/（build.sh 负责产出统一归档）。
set -euo pipefail
cd "$(dirname "$0")/.."                 # std 根
BACKENDS_DIR=runtime/backends

usage() {
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
}

list_backends() {
    for d in "$BACKENDS_DIR"/*/; do
        [ -f "$d/build.sh" ] || continue
        basename "$d"
    done
}

build_backend() {
    local name=$1
    local dir="$BACKENDS_DIR/$name"
    if [ ! -f "$dir/build.sh" ]; then
        echo "error: unknown backend '$name'（可用：$(list_backends | tr '\n' ' ')）" >&2
        exit 1
    fi
    bash "$dir/build.sh"
}

archive_of() {
    echo "$PWD/build/runtime/$1/libruntime.a"
}

cmd=${1:-}
case "$cmd" in
list)
    list_backends
    ;;
build)
    [ $# -eq 2 ] || usage
    build_backend "$2"
    ;;
env)
    [ $# -eq 2 ] || usage
    a=$(archive_of "$2")
    [ -f "$a" ] || build_backend "$2" >/dev/null
    echo "AYANAMI_RUNTIME=$a"
    ;;
run)
    [ $# -ge 4 ] || usage
    name=$2
    shift 2
    [ "$1" = "--" ] || usage
    shift
    a=$(archive_of "$name")
    [ -f "$a" ] || build_backend "$name" >/dev/null
    AYANAMI_RUNTIME="$a" "$@"
    ;;
*)
    usage
    ;;
esac
