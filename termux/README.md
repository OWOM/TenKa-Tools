# Termux 完全版 (按需下载)

Flutter/TenKa 工具链的 Termux 完全版运行环境。
含基础环境 (bootstrap) + openjdk-21 + apksigner，可跑 APK 签名等需要完整 Linux 环境的操作。

## 文件清单

| 文件 | 大小 | 说明 |
|---|---|---|
| bootstrap-aarch64.zip | 29.3MB | Termux 基础环境 (busybox/apt/coreutils 等) |
| pool/main/o/openjdk-21/openjdk-21_21.0.12_aarch64.deb | 101.2MB | Java 21 运行时 (apksigner 依赖) |
| pool/main/a/apksigner/apksigner_37.0.0_all.deb | 1.0MB | APK 签名工具 |
| pool/main/* (其余 .deb) | ~1.5MB | openjdk 依赖 (libandroid-shmem/spawn/iconv/jpeg/zlib/littlecms/alsa/ca-certificates) |
| manifest.json | - | 文件清单 + sha256 校验 |

## 总大小
133 MB (aarch64)

## 用途
- APK 签名 (apksigner)
- 完整 Linux 命令行环境 (Termux 包管理)
- 需要 Java 的工具链

## 来源
- bootstrap: termux-packages release `bootstrap-2026.03.01-r1+apt.android-7`
- openjdk-21/apksigner/依赖: packages.termux.dev 官方仓库 (aarch64)

## 部署
见 RESTORE_GUIDE.md (或直接 `bash restore_termux.sh` 需已下载全部文件)
