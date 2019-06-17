export bench=$1

export cflags_innative="disable_tail_call check_int_division check_memory_access \
                        check_float_trunc check_indirect_call check_stack_overflow \
                        noinit sandbox strict"

wavm-disas ${bench}.wasm ${bench}.wast

innative-cmd ${bench}.wasm \
        -f o3 ${cflags_innative} \
        -o lib${bench}.so -r

gcc -O3 -o ${bench}_innative main_${bench}.c -L. -l${bench}

