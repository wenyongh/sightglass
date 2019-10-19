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

void matrix_setup(void *global_ctx, void **ctx_p);
void matrix_body(void *ctx);

unsigned app_main()
{
    void *p_ctx;

    matrix_setup(NULL, &p_ctx);
    matrix_body(p_ctx);
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

void matrix_WASM_innative_internal_init();
void matrix_WASM_innative_internal_exit();
unsigned matrix_WASM_app_main();
int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    matrix_WASM_innative_internal_init();

    ret = matrix_WASM_app_main();
    printf("##ret: %d\n", ret);

    matrix_WASM_innative_internal_exit();
}

#endif

