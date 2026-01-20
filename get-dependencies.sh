#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
pacman -Syu --noconfirm coreutils binutils gawk

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
make-aur-package dwarfs-bin
make-aur-package python-desktop-entry-lib
make-aur-package python-ftputil
make-aur-package gearlever
