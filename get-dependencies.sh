#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
make-aur-package dwarfs-bin
make-aur-package gearlever
pacman -Syu --noconfirm coreutils binutils gawk 7zip
# Upstream 'file' is bugged in not respecting the GCONV_PATH and not working
pacman -Rsndd --noconfirm file
make-aur-package file-git

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
