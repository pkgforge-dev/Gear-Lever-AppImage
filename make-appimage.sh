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
export PATH_MAPPING='
       /usr/lib/gearlever:${SHARUN_DIR}/lib/gearlever
'
export EXEC_WRAPPER=1
export DEPLOY_LOCALE=1
export STARTUPWMCLASS=gearlever # For Wayland, this is 'it.mijorus.gearlever', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

# Deploy dependencies
quick-sharun /usr/bin/gearlever \
             /usr/lib/gearlever \
             /usr/share/gearlever \
             /usr/lib/libgirepository* \
             /usr/bin/mksquashfs \
             /usr/bin/unsquashfs \
             /usr/bin/sqfscat \
             /usr/bin/sqfstar \
             /usr/bin/dwarfs \
             /usr/bin/mkdwarfs \
             /usr/bin/dwarfsextract \
             /usr/bin/dwarfsck \
             /usr/bin/od \
             /usr/bin/awk \
             /usr/bin/cat \
             /usr/bin/readelf \
             /usr/bin/file \
             /usr/bin/chmod \
             /usr/bin/arch \
             /usr/bin/7z

# For some reason, Gear Lever calls 7z - 7zz, so just link it to 7zz to make it compatible
ln -sf ./AppDir/bin/7zz ./AppDir/bin/7z

# Patch Gear Lever to use AppImage's directory
sed -i '/^pkgdatadir/c\pkgdatadir = os.getenv("SHARUN_DIR", "/usr") + "/share/gearlever"' ./AppDir/bin/gearlever
sed -i '/^localedir/c\localedir = os.getenv("SHARUN_DIR", "/usr") + "/share/locale"' ./AppDir/bin/gearlever

# Gear lever uses a bash script to get offset that depends on readelf
# Replace it for a POSIX alternative that does not need bash
cp -v ./get_appimage_offset ./AppDir/lib/gearlever
chmod +x ./AppDir/lib/gearlever/get_appimage_offset
rm -f ./AppDir/bin/get_appimage_offset

# Turn AppDir into AppImage
quick-sharun --make-appimage
