#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/BIRD/bird.git
    cd bird/
    git checkout d6cf996151307d083c30e4ecde0f1d7449b19253
}

_build() {
    cd bird/
    names[0]="autoreconf" ; autoreconf  |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"  ; ./configure CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"       ; make -j`nproc`   |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
