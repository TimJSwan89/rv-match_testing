#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libreadline-dev
    sudo apt -y install libc-ares-dev
    sudo apt -y install texinfo
}

_download() {
    git clone https://github.com/Quagga/quagga.git
    cd quagga/
    git checkout 88d6516676cbcefb6ecdc1828cf59ba3a6e5fe7b
}

_build() {
    cd quagga/
    names[0]="bootstrap" ; bash bootstrap.sh |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="configure" ; ./configure       |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    names[2]="make"      ; make              |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
}

_test() {
    :
}

init