export bench=$1

readonly WAMRC_CMD="wamrc"

wavm disassemble ${bench}.wasm ${bench}.wast
wavm compile ${bench}.wasm ${bench}.wavm-aot

lucetc --opt-level 2 -o lib${bench}_lucet.so ${bench}.wasm

$WAMRC_CMD -o ${bench}.iwasm-aot ${bench}.wasm

