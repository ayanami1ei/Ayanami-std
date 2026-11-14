#!/usr/bin/env bash
# check_abi_parity.sh — 校验 C / asm-x86_64 运行时都实现了 abi.h 声明的全部符号
#
# 用法：AYANAMI_BIN=/path/to/ayanami ./scripts/check_abi_parity.sh
set -euo pipefail
cd "$(dirname "$0")/.."

./runtime/backend.sh build c >/dev/null
./runtime/backend.sh build asm-x86_64 >/dev/null

python3 - <<'PY'
import re
import subprocess
import sys

abi = open("runtime/abi.h", encoding="utf-8").read()
want = set(re.findall(r'\b(__ayanami_[a-zA-Z0-9_]+)\s*\(', abi))

def defined(path):
    out = subprocess.run(
        ["nm", "-g", "--defined-only", path],
        capture_output=True, text=True, check=True,
    ).stdout
    syms = set()
    for line in out.splitlines():
        parts = line.split()
        if parts and re.fullmatch(r"__ayanami_[a-zA-Z0-9_]+", parts[-1]):
            syms.add(parts[-1])
    return syms

c = defined("build/runtime/c/libruntime.a")
a = defined("build/runtime/asm-x86_64/libruntime.a")

fail = False
for name, syms in (("c", c), ("asm-x86_64", a)):
    missing = sorted(want - syms)
    if missing:
        fail = True
        print(f"error: backend {name} missing {len(missing)} ABI symbol(s):")
        for m in missing:
            print(f"  {m}")

if fail:
    sys.exit(1)
print(f"ABI parity ok ({len(want)} symbols; c={len(c)}, asm={len(a)})")
PY
