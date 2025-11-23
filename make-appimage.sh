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
export ANYLINUX_LIB=1
export DEPLOY_LOCALE=1
export STARTUPWMCLASS=gearlever # For Wayland, this is 'it.mijorus.gearlever', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

# Deploy dependencies
quick-sharun /usr/bin/gearlever \
             /usr/share/gearlever \
             /usr/lib/libgirepository* \
             /usr/bin/unsquashfs \
             /usr/bin/dwarfsextract \
             /usr/bin/dwarfsck \
             /usr/bin/od \
             /usr/bin/awk \
             /usr/bin/cat \
             /usr/bin/readelf \
             /usr/bin/chmod
             # bundling 'file' doesn't work due to Arch's upstream bug, so I'll skip it, so it will be used from the host if available
             # https://bbs.archlinux.org/viewtopic.php?pid=2274027#p2274027
             #
             # bundling 'uname' doesn't make sense, this should be done in Python directly, idk why's this used from the host
             # bundling '7zip' doesn't work for extracting AppImages, but simple squashfs, dwarfs and AppImage extract works, so idk why this is used at all, anyway, this will get used from the host if available
             
# Patch Gear Lever to use AppImage's directory
sed -i '/^pkgdatadir/c\pkgdatadir = os.getenv("SHARUN_DIR", "/usr") + "/share/gearlever"' ./AppDir/bin/gearlever
sed -i '/^localedir/c\localedir = os.getenv("SHARUN_DIR", "/usr") + "/share/locale"' ./AppDir/bin/gearlever
# Patch AUR's modification back to use 'get_appimage_offset' in PATH
cp -v ./get_appimage_offset ./AppDir/bin/get_appimage_offset
chmod +x ./AppDir/bin/get_appimage_offset
sed -i 's|/usr/lib/gearlever/get_appimage_offset|get_appimage_offset|g' ./AppDir/share/gearlever/gearlever/providers/AppImageProvider.py

# Turn AppDir into AppImage
quick-sharun --make-appimage
