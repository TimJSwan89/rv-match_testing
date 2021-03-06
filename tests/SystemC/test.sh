#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/ArchC/SystemC.git
    cd SystemC/
    git checkout 778e7c6b45564494a98e6c1526f492b271c5696e
    # This is a different repository than the official, which is tracked in another project.
}

_build() {
    # Note: C++ project
    cd SystemC/
    names[0]="autoreconf" ; autoreconf -i |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure" ; ./configure CC=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"      ; make -j`nproc` |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
