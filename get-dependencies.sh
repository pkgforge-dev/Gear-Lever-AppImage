#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
make-aur-package parallel-hashmap # for dwarfs
make-aur-package dwarfs
make-aur-package python-desktop-entry-lib
make-aur-package python-ftputil
make-aur-package gearlever
pacman -Syu --noconfirm coreutils binutils gawk

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
