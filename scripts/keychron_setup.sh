#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# https://github.com/Kurgol/keychron/blob/master/k2.md#f-keys-on-ubuntu

echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u
