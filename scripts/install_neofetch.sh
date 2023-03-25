#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)

_SCRATCHDIR=$(mktemp -d -t install-btop-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT
cd "${_SCRATCHDIR}"


install_neofetch()
{
    git clone https://github.com/dylanaraps/neofetch.git
    cd neofetch
    git checkout $(git tag --list | tail -n 1) &>/dev/null
    make
    sudo make PREFIX=/usr/local install
}

install_neofetch
