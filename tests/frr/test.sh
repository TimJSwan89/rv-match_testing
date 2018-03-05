#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    frrdownloaddir=$(pwd)
    git clone https://github.com/FRRouting/frr.git
    cd frr/
    git checkout 6768912110483ced636141838f9e040715dece8f
    cd $frrdownloaddir
    git clone https://github.com/FRRouting/topotests.git
    cd topotests/
    git checkout a24f1765db1735c2901c286f9095aa7779c42bf3
}

_build() {
    cd frr/
    names[0]="add missing" ; automake --add-missing |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="autoreconf"  ; autoreconf  |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    names[2]="configure"   ; ./configure CC=$compiler LD=$compiler |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
    names[3]="make"        ; make        |& tee kcc_build_3.txt ; results[3]="$?" ; process_kcc_config 3
}

_test() {
    :
}

init