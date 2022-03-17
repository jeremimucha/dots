#!/usr/bin/env bash

function register_gcc_version {
    local version=$1
    local priority=$2

    update-alternatives \
        --install /usr/bin/gcc          gcc         /usr/bin/gcc-${version} ${priority} \
        --slave   /usr/bin/g++          g++         /usr/bin/g++-${version}  \
        --slave   /usr/bin/gcc-ar       gcc-ar      /usr/bin/gcc-ar-${version} \
        --slave   /usr/bin/gcc-nm       gcc-nm      /usr/bin/gcc-nm-${version} \
        --slave   /usr/bin/gcc-ranlib   gcc-ranlib  /usr/bin/gcc-ranlib-${version}

    # update-alternatives \
    #     --install   /usr/bin/cpp          cpp         /usr/bin/cpp-${version}  ${priority}

    update-alternatives \
        --install /usr/bin/gcov              gcov           /usr/bin/gcov-${version} ${priority} \
        --slave   /usr/bin/gcov-dump         gcov-dump      /usr/bin/gcov-dump-${version} \
        --slave   /usr/bin/gcov-tool         gcov-tool      /usr/bin/gcov-tool-${version}
}

register_gcc_version $1 $2
