#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/uber/h3.git
    cd h3/
    git checkout 8b02a95cd93530cb83ea3bd84a3d60c0cad6c9cd
}

_build() {
    cd h3/
    CC=$compiler LD=$compiler cmake . |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
