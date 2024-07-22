#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)

_SCRATCHDIR=$(mktemp -d -t install-lua-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT
cd "$_SCRATCHDIR"

install_lua() {
    sudo apt install -y lua5.4 liblua5.4-dev

    # https://luarocks.org/
    wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
    tar zxpf luarocks-3.11.1.tar.gz
    cd luarocks-3.11.1
    ./configure && make && sudo make install
}

install_lua
