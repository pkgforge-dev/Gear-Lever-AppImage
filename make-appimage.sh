#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gearlever | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/it.mijorus.gearlever.svg
export DESKTOP=/usr/share/applications/it.mijorus.gearlever.desktop
export DEPLOY_SYS_PYTHON=1
export DEPLOY_OPENGL=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export PATH_MAPPING='/usr/share/gearlever:${SHARUN_DIR}/share/gearlever'
export EXEC_WRAPPER=1
export DEPLOY_LOCALE=1
export STARTUPWMCLASS=gearlever # For Wayland, this is 'it.mijorus.gearlever', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

# Deploy dependencies
quick-sharun /usr/bin/gearlever \
             /usr/lib/libgirepository* \
             /usr/bin/dwarfs \
             /usr/bin/mkdwarfs \
             /usr/bin/dwarfsextract \
             /usr/bin/dwarfsck \
             /usr/share/icons/hicolor # Icons are missing on Fedora, so deploying all icons gets rid of this problem

# Turn AppDir into AppImage
quick-sharun --make-appimage
