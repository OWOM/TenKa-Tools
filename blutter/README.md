# Blutter 引擎库

Flutter 逆向工具 Blutter 的 Android arm64 引擎集合（Dart 2.19.6 + 3.0.0 ~ 3.13.1 全系列）。

## 内容
- `engines/` — 76 个引擎 gz（每个约 1.5MB）
- `engines.json` — 清单（版本 / 文件名 / 大小 / sha256 / builtin）

## 下载单个引擎
```
wget <仓库URL>/blutter/engines/blutter_dartvm<版本>_android_arm64.gz
gunzip blutter_dartvm<版本>_android_arm64.gz
chmod +x blutter_dartvm<版本>_android_arm64
# 放入 /storage/emulated/0/KKY/MT2/mcp/blutter_android/ 即可
```

## 校验
```
sha256sum blutter_dartvm<版本>_android_arm64.gz   # 与 engines.json 的 sha256 比对
```

## builtin 6 个（TenKa APK 内置，无需下载）
2.19.6 / 2.19.2 / 3.7.2 / 3.11.5 / 3.12.2 / 3.13.1

## 版本覆盖
2.19.6, 3.0.0~3.0.7, 3.1.0~3.1.5, 3.2.0~3.2.6, 3.3.0~3.3.4,
3.4.0~3.4.4, 3.5.0~3.5.4, 3.6.0~3.6.2, 3.7.0~3.7.3, 3.8.0~3.8.3,
3.9.0~3.9.4, 3.10.0~3.10.9, 3.11.0~3.11.6, 3.12.0~3.12.2, 3.13.0~3.13.1
