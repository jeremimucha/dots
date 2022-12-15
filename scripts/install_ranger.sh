#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
_WORKDIR=$(pwd)


# https://github.com/ranger/ranger

exec python3 -m pip install ranger-fm
