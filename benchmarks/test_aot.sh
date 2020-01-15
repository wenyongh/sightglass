#!/bin/bash

CUR_DIR=$PWD
OUT_DIR=$CUR_DIR/out
REPORT=$CUR_DIR/report.txt
TIME=/usr/bin/time

BENCH_NAME_MAX_LEN=16
SHOOTOUT_CASES="base64 fib2 gimli heapsort memmove nestedloop nestedloop2 nestedloop3 \
                random seqhash sieve strchr switch2"
LIFE_CASES="fib pollard snappy"

rm -f $REPORT
touch $REPORT
rm -rf $OUT_DIR
mkdir -p $OUT_DIR


#build shootout benchmarks
cd $CUR_DIR/shootout
for t in $SHOOTOUT_CASES
do
        echo "build $t ..."
        ./build.sh $t
done

cp out/* $OUT_DIR

#build life benchmarks
cd $CUR_DIR/life
for t in $LIFE_CASES
do
        echo "build $t ..."
        ./build.sh $t
done
cp * $OUT_DIR

function print_bench_name()
{
        name=$1
        echo -en "$name" >> $REPORT
        name_len=${#name}
        if [ $name_len -lt $BENCH_NAME_MAX_LEN ]
        then
                spaces=$(( $BENCH_NAME_MAX_LEN - $name_len ))
                for i in $(eval echo "{1..$spaces}"); do echo -n " " >> $REPORT; done
        fi
}

#run benchmarks
cd $OUT_DIR
echo -en "\t\t\t\t\tnativeg\tnativec\tiwasm-j\tiwasm-a\twavm-j\twavm-a\tlucet-a\twamtime\tinnative\n" >> $REPORT
for t in $SHOOTOUT_CASES $LIFE_CASES
do
        print_bench_name $t

        echo "run $t by native gcc ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" ./${t}_native_gcc 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by native clang ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" ./${t}_native 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by iwasm jit..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" iwasm -f app_main ${t}.wasm 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by iwasm aot..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" iwasm -f app_main ${t}.iwasm-aot 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by wavm jit ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" wavm run --function=app_main ${t}.wasm 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by wavm aot ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" wavm run --precompiled --function=app_main ${t}.wavm-aot 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by lucet ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" lucet-wasi --entrypoint app_main lib${t}_lucet.so 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by wasmtime ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" wasmtime -o --invoke=app_main ${t}.wasm 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo "run $t by innative ..."
        echo -en "\t" >> $REPORT
        $TIME -f "real-%e-time" ./${t}_innative 2>&1 | grep "real-.*-time" | awk -F '-' '{ORS=""; print $2}' >> $REPORT

        echo -en "\n" >> $REPORT
done

