#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)

# https://github.com/alacritty/alacritty/blob/master/INSTALL.md

install_rust()
{
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup override set stable
    rustup update stable
}

install_dependencies()
{
    sudo apt-get update -yq && \
    sudo apt-get install -yq \
        libfreetype6-dev \
        libfontconfig1-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev
        # cmake \
        # pkg-config \
        # python3
}

install_allacrity()
{
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    cargo build --release
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    cd ../
    rm -rf alacritty
}

install_completions()
{
    fish -c "mkdir -p \$fish_complete_path[1] && cp extra/completions/alacritty.fish \$fish_complete_path[1]/alacritty.fish"
}

install_rust
install_dependencies
install_allacrity
install_completions
