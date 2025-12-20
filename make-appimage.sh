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
export STARTUPWMCLASS=it.mijorus.gearlever # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1

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

# Bundle static 7zip and file, as stracing it through quick-sharun doesn't give desired results
wget --retry-connrefused --tries=30 "https://pkgs.pkgforge.dev/dl/bincache/$ARCH-linux/7z/official/7z/raw.dl" -O ./AppDir/bin/7z
chmod +x ./AppDir/bin/7z
wget --retry-connrefused --tries=30 "https://pkgs.pkgforge.dev/dl/pkgcache/$ARCH-linux/file/appimage/ppkg/stable/file/raw.dl" -O ./AppDir/bin/file
chmod +x ./AppDir/bin/file

# Patch Gear Lever to use AppImage's directory
sed -i '/^pkgdatadir/c\pkgdatadir = os.getenv("SHARUN_DIR", "/usr") + "/share/gearlever"' ./AppDir/bin/gearlever
sed -i '/^localedir/c\localedir = os.getenv("SHARUN_DIR", "/usr") + "/share/locale"' ./AppDir/bin/gearlever
# Patch AUR's modification back to use 'get_appimage_offset' in PATH
sed -i 's|/usr/lib/gearlever/get_appimage_offset|get_appimage_offset|g' ./AppDir/share/gearlever/gearlever/providers/AppImageProvider.py
# Copy get_appimage_offset script
cp -v /usr/lib/gearlever/get_appimage_offset ./AppDir/bin/get_appimage_offset
chmod +x ./AppDir/bin/get_appimage_offset

# Turn AppDir into AppImage
quick-sharun --make-appimage
