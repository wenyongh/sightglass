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

void base64_body(void *ctx);

unsigned app_main()
{
    void *p_ctx;

    base64_body(p_ctx);
    return get_res();
}

#ifndef INNATIVE_WASM
int main(int argc, char **argv)
{
    unsigned ret = app_main();
    printf("##ret: %d\n", ret);
    return 0;
}
#endif /* end of INNATIVE_WASM */

#else /* else of INNATIVE_NATIVE */

void base64_WASM_innative_internal_init();
void base64_WASM_innative_internal_exit();
unsigned base64_WASM_app_main();
int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    base64_WASM_innative_internal_init();

    ret = base64_WASM_app_main();
    printf("##ret: %d\n", ret);

    base64_WASM_innative_internal_exit();
}

#endif /* end of INNATIVE_NATIVE */

