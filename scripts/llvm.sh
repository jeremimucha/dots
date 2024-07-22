#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)

_SCRATCHDIR=$(mktemp -d -t install-llvm-tmp-XXXXXXXXXX)
function cleanup {
  rm -rvf "$_SCRATCHDIR"
}
trap cleanup EXIT
cd "$_SCRATCHDIR"

install_latest_llvm() {
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    sudo ./llvm.sh all
}

install_latest_llvm
