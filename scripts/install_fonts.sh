#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRATCHDIR=$(mktemp -d -t install-fonts-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT

ensure_dependencies()
{
    if ! [ -x $(command -v unzip) ]
    then
        sudo apt-get update && sudo apt-get install unzip
    fi
}

ensure_fonts()
{
    mkdir -p $HOME/.fonts
}

# https://github.com/i-tu/Hasklig
install_hasklig()
{
    curl -sL https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip -o hasklig_tmp.zip
    unzip hasklig_tmp.zip -d ./hasklig_tmp
    cp -r './hasklig_tmp/OTF/' $HOME/.fonts/hasklig/
}

install_nerdfonts()
{
    local nerdfonts_url="https://github.com/ryanoasis/nerd-fonts/releases"
    local nerdfonts_version="v3.0.1"
    local nerdfonts_to_install=("Hasklig" "FiraCode" "SourceCodePro")

    for font in "${nerdfonts_to_install[@]}"; do
        curl -sL "${nerdfonts_url}/download/${nerdfonts_version}/${font}.zip" -o "${font}.zip"
        unzip "${font}.zip" -d "./${font}"
        mkdir -p "$HOME/.testfonts/${font}"
        cp -r "./${font}/" $HOME/.testfonts/${font}/
    done
}

ensure_dependencies
ensure_fonts

cd "$_SCRATCHDIR"
install_hasklig
install_nerdfonts
sudo fc-cache -f -v
