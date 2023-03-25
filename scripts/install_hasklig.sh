#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRATCHDIR=$(mktemp -d -t install-btop-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT
cd "${_SCRATCHDIR}"


ensure_dependencies()
{
    if ! [ -x $(command -v unzip) ]
    then
        sudo apt update && sudo apt install unzip
    fi
}

# https://github.com/i-tu/Hasklig
install_hasklig()
{
    curl -sL https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip -o hasklig_tmp.zip
    unzip hasklig_tmp.zip -d ./hasklig_tmp
    sudo cp -r './hasklig_tmp/OTF/' /usr/local/share/fonts/hasklig/

    sudo fc-cache -f -v
}

ensure_dependencies
install_hasklig
