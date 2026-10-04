#!/usr/bin/env python3
"""Ayanami 标准库测试运行器。

约定：
- tests/unit/*_test.aya：用例文件，函数用 `#[test]`（应通过）或 `#[should_panic]`（应 panic 101）标注；
  每个用例函数写 `-> int` 且末尾 `return 0`（规避编译器 void 尾语句缺陷 #85）。
- tests/compile_fail/*.aya + 同名 .expected：编译期负例（每行一个候选子串）。
- tests/golden/*.aya + 同名 .out：stdout 黄金输出对比。

用法：
    python3 scripts/run_tests.py --bin <ayanami 路径> [--filter 关键字]
"""
import argparse
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UNIT = os.path.join(ROOT, "tests", "unit")
CF = os.path.join(ROOT, "tests", "compile_fail")
GOLD = os.path.join(ROOT, "tests", "golden")

ANN_RE = re.compile(r"^\s*#\[(?:[A-Za-z_][\w]*::)?(test|should_panic)\]\s*$")
FN_RE = re.compile(r"^\s*(?:pub\s+)?fn\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(")

GREEN = "\033[32m"
RED = "\033[31m"
DIM = "\033[2m"
RESET = "\033[0m"
if not sys.stdout.isatty() or os.environ.get("NO_COLOR"):
    GREEN = RED = DIM = RESET = ""


def discover():
    """返回 [(module_stem, fn_name, expect_panic)]。"""
    tests = []
    if not os.path.isdir(UNIT):
        return tests
    for name in sorted(os.listdir(UNIT)):
        if not name.endswith("_test.aya"):
            continue
        stem = name[:-4]
        pending = None
        with open(os.path.join(UNIT, name), encoding="utf-8") as f:
            for line in f:
                m = ANN_RE.match(line)
                if m:
                    pending = m.group(1) == "should_panic"
                    continue
                m2 = FN_RE.match(line)
                if m2 and pending is not None:
                    tests.append((stem, m2.group(1), pending))
                    pending = None
                elif m2:
                    pending = None
    return tests


def run_case(binary, stem, fn_name, timeout=120):
    driver = os.path.join(UNIT, ".driver.aya")
    with open(driver, "w", encoding="utf-8") as f:
        f.write(f'import "{stem}"\n\nfn main() -> int {{\n    {fn_name}()\n    return 0\n}}\n')
    try:
        p = subprocess.run(
            [binary, "run", os.path.relpath(driver, ROOT)],
            cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=timeout,
        )
    finally:
        try:
            os.remove(driver)
        except OSError:
            pass
    out = (p.stdout + p.stderr).decode("utf-8", "replace").strip()
    return p.returncode, out


def first_line(text):
    for line in text.splitlines():
        if line.strip():
            return line.strip()
    return ""


def run_unit(binary, flt, failures):
    tests = discover()
    if flt:
        tests = [t for t in tests if flt in f"{t[0]}::{t[1]}"]
    print(f"running {len(tests)} unit tests")
    passed = 0
    for stem, fn_name, expect_panic in tests:
        code, out = run_case(binary, stem, fn_name)
        ok = (code == 101) if expect_panic else (code == 0)
        label = f"{stem}::{fn_name}"
        if ok:
            passed += 1
            print(f"  {GREEN}ok{RESET}   {label}")
        else:
            want = 101 if expect_panic else 0
            print(f"  {RED}FAIL{RESET} {label}  (exit {code}, want {want})")
            line = first_line(out)
            if line:
                print(f"       {DIM}{line}{RESET}")
            failures.append(label)
    return passed, len(tests)


def run_compile_fail(binary, failures):
    if not os.path.isdir(CF):
        return 0
    files = sorted(f for f in os.listdir(CF) if f.endswith(".aya"))
    print(f"running {len(files)} compile-fail tests")
    passed = 0
    for name in files:
        path = os.path.join(CF, name)
        expected = path[:-4] + ".expected"
        label = f"compile_fail/{name}"
        if not os.path.exists(expected):
            print(f"  {RED}FAIL{RESET} {label}  (missing .expected)")
            failures.append(label)
            continue
        p = subprocess.run(
            [binary, "check", os.path.relpath(path, ROOT)],
            cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=60,
        )
        out = (p.stdout + p.stderr).decode("utf-8", "replace")
        with open(expected, encoding="utf-8") as f:
            pats = [ln for ln in (l.strip() for l in f) if ln]
        if any(pat in out for pat in pats):
            passed += 1
            print(f"  {GREEN}ok{RESET}   {label}")
        else:
            print(f"  {RED}FAIL{RESET} {label}  (expected substrings not found)")
            for pat in pats:
                print(f"       {DIM}- {pat}{RESET}")
            failures.append(label)
    return passed, len(files)


def run_golden(binary, failures):
    if not os.path.isdir(GOLD):
        return 0, 0
    files = sorted(f for f in os.listdir(GOLD) if f.endswith(".aya"))
    if not files:
        return 0, 0
    print(f"running {len(files)} golden-output tests")
    passed = 0
    for name in files:
        path = os.path.join(GOLD, name)
        expect_file = path[:-4] + ".out"
        label = f"golden/{name}"
        p = subprocess.run(
            [binary, "run", os.path.relpath(path, ROOT)],
            cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=120,
        )
        got = p.stdout.decode("utf-8", "replace").rstrip("\n")
        want = ""
        if os.path.exists(expect_file):
            with open(expect_file, encoding="utf-8") as f:
                want = f.read().rstrip("\n")
        if p.returncode == 0 and got == want:
            passed += 1
            print(f"  {GREEN}ok{RESET}   {label}")
        else:
            print(f"  {RED}FAIL{RESET} {label}  (exit {p.returncode})")
            if got != want:
                print(f"       want: {want!r}")
                print(f"       got:  {got!r}")
            failures.append(label)
    return passed, len(files)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--bin", required=True)
    ap.add_argument("--filter", default="")
    args = ap.parse_args()
    binary = os.path.abspath(args.bin)
    if not os.access(binary, os.X_OK):
        print(f"error: 编译器不可执行: {binary}", file=sys.stderr)
        sys.exit(2)

    failures = []
    up, ut = run_unit(binary, args.filter, failures)
    cp, ct = run_compile_fail(binary, failures)
    gp, gt = run_golden(binary, failures)
    total = ut + ct + gt
    passed = up + cp + gp
    if failures:
        print(f"{RED}test result: FAILED{RESET}. {passed}/{total} passed; failures={len(failures)}")
        sys.exit(1)
    print(f"{GREEN}test result: ok{RESET}. {passed}/{total} passed")


if __name__ == "__main__":
    main()
