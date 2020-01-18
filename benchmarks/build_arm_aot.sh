#!/bin/bash

CUR_DIR=$PWD
OUT_DIR=$CUR_DIR/out

CASES="base64 fib2 gimli heapsort memmove nestedloop nestedloop2 nestedloop3 \
       random seqhash sieve strchr switch2 fib pollard snappy"

rm -rf $OUT_DIR
cp -a wasm-files $OUT_DIR

cd $OUT_DIR
for t in $CASES
do
    echo "build $t ..."
    wamrc --target=armv7 --target-abi=gnueabihf -o $t.aot $t.wasm
done

