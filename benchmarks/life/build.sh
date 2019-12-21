export bench=$1

export cflags_innative="disable_tail_call check_int_division check_memory_access \
                        check_float_trunc check_indirect_call check_stack_overflow \
                        noinit sandbox strict"

export cflags_innative1="sandbox noinit library"

wavm disassemble ${bench}.wasm ${bench}.wast
wavm compile ${bench}.wasm ${bench}.wavm-aot

innative-cmd ${bench}.wasm \
        -f o3 ${cflags_innative1} \
        -o lib${bench}.so

gcc -O3 -o ${bench}_innative main_${bench}.c -L. -l${bench}

wamrc -o ${bench}.iwasm-aot ${bench}.wasm

