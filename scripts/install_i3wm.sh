#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)

_SCRATCHDIR=$(mktemp -d -t install-i3wm-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT
cd "${_SCRATCHDIR}"

install_build_essentials() {
  sudo apt update && sudo apt install -y \
        autoconf \
        ninja \
        meson  
}

install_utils() {
    sudo apt update && sudo apt install -y \
        xdg-utils \
        sensible-utils \
        alsa-utils \
        flameshot
}

install_dunst() {
    sudo apt update && sudo apt install -y \
        dunst
}

install_i3wm()
{
    # All i3wm packages are available natively for ubuntu
    sudo apt update && sudo apt install -y \
        i3 \
        i3lock-fancy \
        xwallpaper \
        rofi \
        xautolock \
        numlockx \
        fonts-font-awesome \
        fonts-firacode
}

# i3-gaps requires most dependencies to be built from source

i3gaps_dependencies()
{
    sudo apt update && sudo apt install -y \
        libxcb1-dev \
        libxcb-keysyms1-dev \
        libpango1.0-dev \
        libxcb-util0-dev \
        libxcb-icccm4-dev \
        libyajl-dev \
        libstartup-notification0-dev \
        libxcb-randr0-dev \
        libev-dev \
        libxcb-cursor-dev \
        libxcb-xinerama0-dev \
        libxcb-xkb-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        compton \
        nitrogen \
        rofi \
        xutils-dev \
        rxvt-unicode \
        libxcb-shape0-dev
}

install_xrm()
{
    git clone https://github.com/Airblader/xcb-util-xrm
    cd xcb-util-xrm
    git submodule update --init
    ./autogen.sh --prefix=/usr
    make
    sudo make install
}


refresh_shared_libraries() {
    sudo ldconfig
    sudo ldconfig -p
}

install_i3_gaps() {

    git clone https://www.github.com/Airblader/i3.git i3-gaps
    # shellcheck disable=SC2164
    cd i3-gaps
    rm -Rf build/
    mkdir build
    # shellcheck disable=SC2164
    cd build/
    meson ..
    sudo ninja install
    # which i3
    # ls -l /usr/bin/i3
    cd ../..
    rm -fr i3-gaps

}

install_sway() {

}

install_sway_dependencies() {

}

install_polybar_dependencies()
{
    sudo apt update && sudo apt install -y \
        libcairo2-dev \
        libxcb1-dev \
        libxcb-ewmh-dev \
        libxcb-icccm4-dev \
        libxcb-image0-dev \
        libxcb-randr0-dev \
        libxcb-util0-dev \
        libxcb-xkb-dev \
        pkg-config \
        python3-xcbgen \
        xcb-proto \
        libxcb-xrm-dev \
        i3-wm \
        libasound2-dev \
        libmpdclient-dev \
        libiw-dev \
        libcurl4-openssl-dev \
        libpulse-dev \
        libxcb-composite0-dev \
        libjsoncpp-dev \
        python3-sphinx \
        libuv1-dev

    # sudo ln -s /usr/include/jsoncpp/json/ /usr/include/json
}

install_polybar() {
    sudo apt update -yq && sudo apt install -y \
      pkg-config \
      python3-sphinx \
      python3-packaging \
      libuv1-dev \
      libcairo2-dev \
      libxcb1-dev \
      libxcb-util0-dev \
      libxcb-randr0-dev \
      libxcb-composite0-dev \
      python3-xcbgen \
      xcb-proto \
      libxcb-image0-dev \
      libxcb-ewmh-dev \
      libxcb-icccm4-dev

    sudo apt install -y \
      libxcb-xkb-dev \
      libxcb-xrm-dev \
      libxcb-cursor-dev \
      libasound2-dev \
      libpulse-dev \
      libjsoncpp-dev \
      libmpdclient-dev \
      libcurl4-openssl-dev \
      libnl-genl-3-dev

    git clone https://github.com/jaagr/polybar.git
    # shellcheck disable=SC2164
    cd polybar
    # shellcheck disable=SC2164
    env USE_GCC=ON ENABLE_I3=ON ENABLE_ALSA=ON ENABLE_PULSEAUDIO=ON ENABLE_NETWORK=ON ENABLE_MPD=ON ENABLE_CURL=ON ENABLE_IPC_MSG=ON INSTALL=OFF INSTALL_CONF=OFF ./build.sh -f
    # shellcheck disable=SC2164
    cd build
    sudo make install
    # make userconfig
    cd ../..
    rm -fr polybar
}

create_config_files() {
    # File didn't exist for me, so test and touch
    if [ -e "$HOME"/.Xresources ]; then
      echo "... .Xresources found."
    else
      touch "$HOME"/.Xresources
    fi

    # File didn't exist for me, so test and touch
    if [ -e "$HOME"/.config/nitrogen/bg-saved.cfg ]; then
      echo "... .bg-saved.cfg found."
    else
      mkdir "$HOME"/.config/nitrogen
      touch "$HOME"/.config/nitrogen/bg-saved.cfg
    fi

    # File didn't excist for me, so test and touch
    if [ -e "$HOME"/.config/polybar/config ]; then
      echo "... polybar/config found."
    else
      mkdir "$HOME"/.config/polybar
      touch "$HOME"/.config/polybar/config
    fi

    # File didn't excist for me, so test and touch
    if [ -e "$HOME"/.config/i3/config ]; then
      echo "... i3/config found."
    else
      mkdir "$HOME"/.config/i3
      touch "$HOME"/.config/i3/config
    fi

    # Compton config file doesn't come by default
    if [ -e "$HOME"/.config/compton.conf ]; then
        echo "... compton.conf found"
    else
        cp "/usr/share/doc/compton/examples/compton.sample.conf" "$HOME/.config/compton.conf"
    fi

}

install_i3_gaps_all()
{
    i3gaps_dependencies
    install_xrm
    refresh_shared_libraries
    install_i3_gaps
    install_polybar
    create_config_files
}


# Instal just regular i3wm for now.
# TODO: Handle choice between i3wm and i3gaps
# install_i3wm
install_polybar
