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

void seqhash_body(void *ctx);

unsigned app_main()
{
    void *p_ctx;

    seqhash_body(p_ctx);
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

void seqhash_WASM_innative_internal_init();
void seqhash_WASM_innative_internal_exit();
unsigned seqhash_WASM_app_main();
int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    seqhash_WASM_innative_internal_init();

    ret = seqhash_WASM_app_main();
    printf("##ret: %d\n", ret);

    seqhash_WASM_innative_internal_exit();
}

#endif

