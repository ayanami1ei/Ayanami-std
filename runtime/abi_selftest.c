// abi_selftest.c — 运行时 ABI 一致性自检（C 侧）
#include "abi.h"
#include <assert.h>
#include <stdio.h>

int main(void) {
    assert(__ayanami_runtime_abi() == AYANAMI_RUNTIME_ABI);
    void *p = __ayanami_unique_alloc(16);
    assert(p != NULL);
    assert(__ayanami_live_allocs() == 1);
    __ayanami_unique_free(p);
    assert(__ayanami_live_allocs() == 0);
    assert(__ayanami_time_unix() > 0);
    (void)__ayanami_random_u64();
    printf("runtime self-test ok (ABI %lld)\n", (long long)__ayanami_runtime_abi());
    return 0;
}
