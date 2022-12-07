#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)


install_neofetch()
{
    mkdir ${_WORKDIR}/neofetchtmp
    cd ${_WORKDIR}/neofetchtmp
    git clone https://github.com/dylanaraps/neofetch.git
    cd neofetch
    git checkout $(git tag --list | tail -n 1) &>/dev/null
    make
    sudo make PREFIX=/usr/local install
    cd ../..
    rm -rf neofetchtmp
}

install_neofetch
