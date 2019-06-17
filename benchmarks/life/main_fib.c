#include <stdio.h>
#include <stdlib.h>

void fib_WASM_innative_internal_init();
void fib_WASM_innative_internal_exit();
unsigned fib_WASM_app_main();

int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    fib_WASM_innative_internal_init();

    ret = fib_WASM_app_main();
    printf("##ret: %d\n", ret);

    fib_WASM_innative_internal_exit();
}


