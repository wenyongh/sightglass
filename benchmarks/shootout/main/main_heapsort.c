#include <stdio.h>
#include <stdlib.h>

#ifdef __ZEPHYR__
#include <zephyr.h>
#include <sys/printk.h>
#endif

#ifndef INNATIVE_NATIVE
static unsigned res = 0;

void set_res(void *x)
{
    res = *(unsigned*)x;
}

unsigned get_res()
{
    return res;
}

void heapsort_setup(void *global_ctx, void **ctx_p);
void heapsort_body(void *ctx);

unsigned app_main()
{
    void *p_ctx;

    heapsort_setup(NULL, &p_ctx);
    heapsort_body(p_ctx);
    return get_res();
}

#ifndef INNATIVE_WASM
int main(int argc, char **argv)
{
#ifdef __ZEPHYR__
        int start, end;
    start = k_uptime_get_32();
#endif
    unsigned ret = app_main();
    printf("##ret: %u\n", ret);
#ifdef __ZEPHYR__
    end = k_uptime_get_32();
    printf("elpase: %d\n", (end - start));
#endif
    return 0;
}
#endif

#else

void heapsort_WASM_innative_internal_init();
void heapsort_WASM_innative_internal_exit();
unsigned heapsort_WASM_app_main();
int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    heapsort_WASM_innative_internal_init();

    ret = heapsort_WASM_app_main();
    printf("##ret: %d\n", ret);

    heapsort_WASM_innative_internal_exit();
}

#endif

