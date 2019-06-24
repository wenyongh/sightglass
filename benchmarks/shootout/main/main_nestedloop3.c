#include <stdio.h>
#include <stdlib.h>

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

void nestedloop3_setup(void *global_ctx, void **ctx_p);
void nestedloop3_body(void *ctx);

unsigned app_main()
{
    void *p_ctx;

    nestedloop3_setup(NULL, &p_ctx);
    nestedloop3_body(p_ctx);
    return get_res();
}

#ifndef INNATIVE_WASM
int main(int argc, char **argv)
{
    unsigned ret = app_main();
    printf("##ret: %d\n", ret);
    return 0;
}
#endif

#else

void nestedloop3_WASM_innative_internal_init();
void nestedloop3_WASM_innative_internal_exit();
unsigned nestedloop3_WASM_app_main();
int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    nestedloop3_WASM_innative_internal_init();

    ret = nestedloop3_WASM_app_main();
    printf("##ret: %d\n", ret);

    nestedloop3_WASM_innative_internal_exit();
}

#endif

