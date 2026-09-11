# TenKa-Tools 工具资源仓库

TenKa MCP 工具链的按需下载资源库。仓库为**扁平结构**（Gitee 网页上传限制，无法建子目录）。

## 当前内容：Blutter 引擎库

- `blutter_*.zip` × 15 — Blutter Android arm64 引擎（按大版本分组，Dart 2.19.6 + 3.0~3.13.1）
- `engines.json` — 清单（版本 / zip / 大小 / sha256 / builtin）

## 下载规则

1. TenKa 的 `blutter_download_engine` 读 `engines.json`
2. 缺哪个版本 → 找到对应 `zip` → 下载 → sha256 校验 → 解压拿引擎
3. `builtin: true` 的 6 个版本（2.19.6/2.19.2/3.7.2/3.11.5/3.12.2/3.13.1）已固化在 APK，无需下载

## 未来加其他工具

Gitee 网页无法建目录时，约定：
- 工具前缀命名文件（如 `edbg_*.zip`）
- 各自带清单 `<工具>.json`
- 根 README 加一行索引
