mkdir -p out

export bench=$1

readonly WAMRC_CMD="wamrc"

gcc -O3 -o out/${bench}_native -Dblack_box=set_res \
        -Dbench=${bench} \
        -I../../include ${bench}.c main/main_${bench}.c main/my_libc.c

emcc -O3 -s WASM=1 \
        -o out/${bench}_node.html \
        -o out/${bench}_node.js \
        -Dblack_box=set_res -Dbench=${bench} \
        -I../../include ${bench}.c main/main_${bench}.c main/my_libc.c

/opt/wasi-sdk/bin/clang -O3 -nostdlib \
        -Wno-unknown-attributes \
        -Dblack_box=set_res \
        -DINNATIVE_WASM \
        -I../../include \
        -Wl,--initial-memory=1310720,--allow-undefined \
        -Wl,--strip-all,--no-entry \
        -o out/${bench}.wasm \
        -Wl,--export=app_main \
        ${bench}.c main/main_${bench}.c main/my_libc.c

wavm disassemble out/${bench}.wasm out/${bench}.wast
wavm compile out/${bench}.wasm out/${bench}.wavm-aot

lucetc --opt-level 2 -o out/lib${bench}_lucet.so out/${bench}.wasm

if [[ $2 == "--sgx" ]];then
    $WAMRC_CMD -sgx -o out/${bench}.iwasm-aot out/${bench}.wasm
else
    $WAMRC_CMD -o out/${bench}.iwasm-aot out/${bench}.wasm
fi

