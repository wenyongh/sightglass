mkdir -p out

export bench=$1

export cflags_innative="check_int_division check_memory_access \
                        check_float_trunc check_indirect_call check_stack_overflow"

gcc -O3 -o out/${bench}_native -Dblack_box=set_res \
        -Dbench=${bench} \
        -I../../include ${bench}.c main/main_${bench}.c

clang-8 -O3 --target=wasm32 -nostdlib \
        -Dblack_box=set_res \
        -DINNATIVE_WASM \
        -I../../include \
        -Wl,--initial-memory=131072,--allow-undefined \
        -Wl,--no-threads,--strip-all,--no-entry \
        -o out/${bench}.wasm \
        -Wl,--export=app_main \
        ${bench}.c main/main_${bench}.c

wavm-disas out/${bench}.wasm out/${bench}.wast

innative-cmd out/${bench}.wasm \
        -f o3 ${cflags_innative} \
        -o out/lib${bench}.so -r

gcc -O3 -DINNATIVE_NATIVE -o out/${bench}_innative main/main_${bench}.c -Lout -l${bench}

