#include <stdio.h>
#include <stdlib.h>

void snappy_WASM_innative_internal_init();
void snappy_WASM_innative_internal_exit();
unsigned snappy_WASM_app_main();

int main(int argc, char **argv)
{
    unsigned ret = 0;
   
    snappy_WASM_innative_internal_init();

    ret = snappy_WASM_app_main();
    printf("##ret: %d\n", ret);

    snappy_WASM_innative_internal_exit();
}


