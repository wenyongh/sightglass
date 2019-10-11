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

void memmove_setup(void *global_ctx, void **ctx_p);
void memmove_body(void *ctx);

unsigned app_main()
{
    void *p_ctx;

    memmove_setup(NULL, &p_ctx);
    memmove_body(p_ctx);
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

void memmove_WASM_innative_internal_init();
void memmove_WASM_innative_internal_exit();
unsigned memmove_WASM_app_main();
int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    memmove_WASM_innative_internal_init();

    ret = memmove_WASM_app_main();
    printf("##ret: %d\n", ret);

    memmove_WASM_innative_internal_exit();
}

#endif

