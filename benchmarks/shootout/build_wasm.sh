mkdir -p out

export bench=$1

clang-8 -O3 --target=wasm32 -nostdlib \
        -Wno-unknown-attributes \
        -Dblack_box=set_res \
        -DINNATIVE_WASM -DTEST_INTERPRETER \
        -I../../include \
        -Wl,--initial-memory=1310720,--allow-undefined \
        -Wl,--strip-all,--no-entry \
        -o out/${bench}.wasm \
        -Wl,--export=app_main \
        ${bench}.c main/main_${bench}.c main/my_libc.c

