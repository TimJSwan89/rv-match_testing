#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    # https://github.com/runtimeverification/toyota-itc-benchmarks
    # https://github.com/regehr/itc-benchmarks
    # https://github.com/Toyota-ITC-SSD/Software-Analysis-Benchmark
    git clone https://github.com/Toyota-ITC-SSD/Software-Analysis-Benchmark.git
    cd Software-Analysis-Benchmark/
    git checkout c146ccab82e401b2dfeef85b8e1e9368ae5dd8fd
}

_build() {
    cd Software-Analysis-Benchmark/
    autoreconf
    automake --add-missing --force-missing
    autoreconf
    ./configure CC=$compiler LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    :
}

init
