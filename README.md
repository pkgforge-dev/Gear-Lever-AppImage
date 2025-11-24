# Gear-Lever-AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/pkgforge-dev/Gear-Lever-AppImage/total?logo=github&label=GitHub%20Downloads)](https://github.com/pkgforge-dev/Gear-Lever-AppImage/releases/latest)
[![CI Build Status](https://github.com//pkgforge-dev/Gear-Lever-AppImage/actions/workflows/appimage.yml/badge.svg)](https://github.com/pkgforge-dev/Gear-Lever-AppImage/releases/latest)

<p align="center">
  <img src="https://raw.githubusercontent.com/mijorus/gearlever/refs/heads/master/data/icons/hicolor/scalable/apps/it.mijorus.gearlever.svg" width="128" />
</p>

* [Latest Stable Release](https://github.com/pkgforge-dev/Gear-Lever-AppImage/releases/latest)

---

AppImage made using [sharun](https://github.com/VHSgunzo/sharun), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks. 

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.**

It is possible that this appimage may fail to work with appimagelauncher, I recommend these alternatives instead: 

* [AM](https://github.com/ivan-hc/AM) `am -i gearlever` or `appman -i gearlever`

* [dbin](https://github.com/xplshn/dbin) `dbin install gearlever.appimage`

* [soar](https://github.com/pkgforge/soar) `soar install gearlever`

This appimage works without fuse2 as it can use fuse3 instead, it can also work without fuse at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/29576c50-b39c-46c3-8c16-a54999438646" alt="Inspiration Image">
  </a>
</details>

---

More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/)
