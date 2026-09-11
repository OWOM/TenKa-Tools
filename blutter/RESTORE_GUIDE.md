# Blutter 完整工具链备份 (Gitee)

更新：2026-09-11

## 用途
Blutter 工具链的完整备份，防止再次丢失（2026-09-11 曾因目录整理丢失主链）。

## 备份内容
```
blutter/engines/           76 个引擎 gz（Dart 2.19.6 + 3.0~3.13.1）
blutter/zips/              15 个 zip（按大版本分组，批量备用）
blutter/engines.json       引擎清单（版本/sha256/builtin）
blutter/framework.tar.gz   框架包（blutter.sh + lib/ 运行库）← 新增, 防框架丢失
blutter/README.md          说明
```

## 恢复步骤（主链丢失时）
```
1. 下载 76 引擎 gz → 解压 = 引擎文件
2. 下载 framework.tar.gz → 解压 = blutter.sh + lib/
3. 组装:
   /storage/emulated/0/Android/data/com.TenkaS.myapp/TenKa/blutter_android/
   ├─ blutter.sh  (chmod 755)
   ├─ blutter_dartvm<版本>_android_arm64  ×76 (chmod 755)
   └─ lib/  (运行库)
4. 修复权限: chown -R u0_a891:u0_a891 + chmod 755 目录/644 文件
5. 验证: blutter_analyze 或命令行 blutter.sh -i libapp.so -o out
```

## 框架关键点
- blutter.sh 是重建版（2026-09-11），Method2 用 strings+grep 检测版本（不依赖 blutter-detect）
- 引擎调用格式: loader + BINARY -i infile -o outdir
- lib/ 是 ICU74 版本（旧版 2.19.x 若需要 ICU70 需另备）

## 上传要求
- framework.tar.gz 必须和 engines/ 一起保持（缺一不可）
- 恢复时先恢复框架再恢复引擎
