#!/usr/bin/env bash
# 兼容转发：打包脚本已迁移到 packaging/build.sh（本文件保留给旧引用）
exec "$(dirname "$0")/../packaging/build.sh" "$@"
