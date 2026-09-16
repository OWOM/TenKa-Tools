# TenKa-Tools 工具资源仓库

TenKa MCP 工具链的按需下载资源库（GitHub 版，子目录结构）。

## 📁 目录结构

```
TenKa-Tools/
├─ README.md              ← 本文件 (仓库索引)
├─ blutter/               ← Blutter 引擎库 (Flutter 逆向)
│  ├─ README.md           ← Blutter 说明
│  ├─ RESTORE_GUIDE.md    ← 恢复指南
│  ├─ engines.json        ← 引擎清单 (76 版本)
│  ├─ engines/            ← 各版本引擎
│  ├─ framework.tar.gz    ← 框架 (blutter.sh/lib/脚本)
│  ├─ restore_blutter.sh  ← 一键恢复脚本
│  └─ zips/               ← 按大版本 zip 分组
└─ termux/                ← Termux 完全版 (APK 签名等)
   ├─ README.md           ← Termux 说明
   ├─ RESTORE_GUIDE.md    ← 恢复指南
   ├─ manifest.json       ← 文件清单 + sha256
   ├─ restore_termux.sh   ← 一键恢复脚本
   ├─ bootstrap-aarch64.zip  ← Termux 基础环境 (29MB)
   └─ pool/               ← .deb 包 (openjdk-21 + apksigner + 依赖)
```

## 📦 各工具说明

### Blutter 引擎库 (`blutter/`)
- Flutter APK 逆向分析工具链（76 个 Dart 引擎）
- 下载: TenKa 的 `blutter_download_engine` 读 `engines.json`
- 缺哪个版本 → 找对应 zip → 下载 → sha256 校验 → 解压
- `builtin: true` 的 6 个版本已固化在 APK，无需下载

### Termux 完全版 (`termux/`)
- 完整 Termux 环境（基础 + openjdk-21 + apksigner），用于 APK 签名等
- 总大小 133MB (aarch64)
- 恢复: `bash restore_termux.sh`（自动部署 + 验证）
- 组件: bootstrap-aarch64.zip + openjdk-21.deb + apksigner.deb + 依赖

## 🔄 下载规则

1. TenKa 按需下载（不固化进 APK，保持 APK 小巧）
2. 每个工具自带清单（engines.json / manifest.json）+ 恢复脚本
3. 换设备: 装 APK → 需要时下载 → 恢复脚本部署

## ⚠️ 注意

- 大文件用 GitHub Release / LFS（网页上传限制 25MB）
- Gitee 镜像 (miman666/ten-ka-tools) 为扁平结构备用
