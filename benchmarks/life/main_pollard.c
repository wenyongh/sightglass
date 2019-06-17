#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void pollard_WASM_innative_internal_init();
void pollard_WASM_innative_internal_exit();
int64_t pollard_WASM_app_main();

int main(int argc, char **argv)
{
    int64_t ret = 0;
   
    pollard_WASM_innative_internal_init();

    ret = pollard_WASM_app_main();
    printf("##ret: %lld\n", ret);

    pollard_WASM_innative_internal_exit();
}


