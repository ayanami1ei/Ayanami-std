// selftest.c — asm-x86_64 后端自检（汇编实现的正确性）
//
// 覆盖：ABI 版本、默认/计数分配、wrapping / overflow / saturating 边界。
#include <assert.h>
#include <stdint.h>
#include <stdio.h>

#include "../../abi.h"

int main(void) {
    assert(__ayanami_runtime_abi() == AYANAMI_RUNTIME_ABI);

    // 分配：默认原语（不计数）与计数分配
    void *p = __ayanami_default_alloc(16);
    assert(p != NULL);
    assert(__ayanami_live_allocs() == 0);        // 默认原语不计计数
    __ayanami_default_free(p);

    void *q = __ayanami_counted_alloc(24);
    assert(q != NULL);
    assert(__ayanami_live_allocs() == 1);
    __ayanami_counted_free(q);
    assert(__ayanami_live_allocs() == 0);
    __ayanami_counted_free(NULL);                // NULL 安全
    assert(__ayanami_live_allocs() == 0);

    // wrapping
    assert(__ayanami_wrapping_add(INT64_MAX, 1) == INT64_MIN);
    assert(__ayanami_wrapping_sub(INT64_MIN, 1) == INT64_MAX);
    assert(__ayanami_wrapping_mul(INT64_MAX, 2) == -2);
    assert(__ayanami_wrapping_neg(INT64_MIN) == INT64_MIN);
    assert(__ayanami_wrapping_add(3, 4) == 7);

    // overflow 标志
    assert(__ayanami_add_overflow(INT64_MAX, 1) == 1);
    assert(__ayanami_add_overflow(1, 2) == 0);
    assert(__ayanami_add_overflow(INT64_MIN, -1) == 1);
    assert(__ayanami_sub_overflow(INT64_MIN, 1) == 1);
    assert(__ayanami_sub_overflow(1, 2) == 0);
    assert(__ayanami_mul_overflow(INT64_MAX, 2) == 1);
    assert(__ayanami_mul_overflow(3, 4) == 0);

    // saturating
    assert(__ayanami_saturating_add(INT64_MAX, 1) == INT64_MAX);
    assert(__ayanami_saturating_add(INT64_MIN, -1) == INT64_MIN);
    assert(__ayanami_saturating_add(1, 2) == 3);
    assert(__ayanami_saturating_sub(INT64_MIN, 1) == INT64_MIN);
    assert(__ayanami_saturating_sub(INT64_MAX, -1) == INT64_MAX);
    assert(__ayanami_saturating_mul(INT64_MAX, 2) == INT64_MAX);
    assert(__ayanami_saturating_mul(INT64_MIN, 2) == INT64_MIN);
    assert(__ayanami_saturating_mul(INT64_MAX, -2) == INT64_MIN);

    printf("asm-x86_64 runtime self-test ok (ABI %lld)\n",
           (long long)__ayanami_runtime_abi());
    return 0;
}
