#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install openssl
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://source.isc.org/git/bind9.git
    cd bind9/
    git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
}

_build() {
    cd bind9/
    autoreconf
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors" LD=kcc --disable-threads --disable-atomic --disable-shared |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    else
        ./configure CC=$compiler --disable-threads --disable-atomic --disable-shared |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    fi
    gcc -Ilib/isc/include -o lib/dns/gen lib/dns/gen.c
    ulimit -s
    bash $base_dir/timeout.sh -t 8000 make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

init
