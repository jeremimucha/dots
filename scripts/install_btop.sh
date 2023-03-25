#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# https://github.com/aristocratos/btop#installation
# https://github.com/aristocratos/btop/releases

_SCRATCHDIR=$(mktemp -d -t install-btop-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT


install_btop()
{
    curl -sL https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz -o btop_installer.tbz
    tar -xvf btop_installer.tbz
    cd btop
    sudo make install
    sudo make setuid
}

cd "$_SCRATCHDIR"
install_btop
