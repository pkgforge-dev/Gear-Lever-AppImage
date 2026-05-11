#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm coreutils binutils gawk

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
make-aur-package dwarfs-bin
make-aur-package python-desktop-entry-lib
make-aur-package python-ftputil
VER=$(curl -s https://api.github.com/repos/mijorus/gearlever/releases/latest | jq -r .tag_name)
SHA=$(curl -L --silent https://github.com/mijorus/gearlever/archive/refs/tags/${VER}.tar.gz | sha256sum | awk '{print $1}')
PRE_BUILD_CMDS="sed -i \"s|pkgver=.*|pkgver=${VER}|g\" ./PKGBUILD && sed -i \"s|sha256sums=.*|sha256sums=('${SHA}')|g\" ./PKGBUILD" make-aur-package gearlever
