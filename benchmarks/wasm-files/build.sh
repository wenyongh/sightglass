export bench=$1

wamrc -o ${bench}.ll --format=llvmir-unopt --target=thumbv4t ${bench}.wasm

wamrc -o ${bench}.aot --format=aot --target=thumbv4t ${bench}.wasm

jeffdump -o test_wasm.h -n wasm_test_file ${bench}.aot

cp -a test_wasm.h ~/WASM/zephyr/samples/simple/src/
