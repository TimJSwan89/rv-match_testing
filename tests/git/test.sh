#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install curl
    sudo apt -y install openssl
}

_download() {
    git clone https://github.com/git/git.git
    cd git/
    git checkout 2512f15446149235156528dafbe75930c712b29e
}

_build() {
    cd git/ ; results[0]="$?" ; postup 0
    make -j`nproc` CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
