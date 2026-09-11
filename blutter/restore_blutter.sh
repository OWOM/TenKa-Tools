#!/bin/sh
# ============================================================
# Blutter 工具链「从 Gitee 备份完全恢复」脚本
# 适用: 主链丢失/损坏/换设备/卸载重装后 (Android/data 被清)
# 用法: sh restore_blutter.sh
# 依赖: Gitee 备份目录完整 (engines/ + framework.tar.gz + engines.json)
# ============================================================
set -e

# 配置
GITEE_BACKUP="/storage/emulated/0/KKY/MT2/mcp/Gitee/blutter"
TC="/storage/emulated/0/Android/data/com.TenkaS.myapp/TenKa/blutter_android"
WORK="/data/local/tmp/TenKa/restore_work"

echo "=== Blutter 从 Gitee 备份恢复 ==="
echo "备份源: $GITEE_BACKUP"
echo "目标:   $TC"

# 0) 校验备份存在
[ -d "$GITEE_BACKUP/engines" ] || { echo "❌ 备份缺失: engines/"; exit 1; }
[ -f "$GITEE_BACKUP/framework.tar.gz" ] || { echo "❌ 备份缺失: framework.tar.gz"; exit 1; }
echo "✅ 备份源完整"

# 1) 重建目标目录
rm -rf "$TC" "$WORK"
mkdir -p "$TC/lib" "$WORK"
echo "✅ 目录已建: $TC"

# 2) 解压 76 引擎 (gz → 引擎)
echo "解压引擎..."
CNT=0
for gz in "$GITEE_BACKUP"/engines/*.gz; do
    gunzip -c "$gz" > "$WORK/$(basename "${gz%.gz}")"
    CNT=$((CNT+1))
done
echo "✅ 引擎解压: $CNT 个"
cp "$WORK"/blutter_dartvm*_android_arm64 "$TC/"

# 3) 解压框架 (blutter.sh + blutter-detect + frida.template.js + lib/)
echo "解压框架..."
tar -xzf "$GITEE_BACKUP/framework.tar.gz" -C "$WORK"
cp "$WORK/framework/blutter.sh" "$WORK/framework/blutter-detect" "$WORK/framework/frida.template.js" "$TC/"
cp "$WORK/framework/lib/"* "$TC/lib/"

# 4) 权限
chmod -R 755 "$TC"
chmod 755 "$TC/blutter.sh" "$TC/blutter-detect"
chmod 644 "$TC/frida.template.js"
echo "✅ 权限设置完成"

# 5) 清理临时
rm -rf "$WORK"
echo ""
echo "=== 恢复完成! ==="
echo "引擎: $(ls "$TC"/blutter_dartvm*_android_arm64 | wc -l) 个"
echo "lib: $(ls "$TC/lib" | wc -l) 个"
echo "框架: $(ls "$TC/blutter.sh" "$TC/blutter-detect" "$TC/frida.template.js" 2>/dev/null | wc -l) 个"
echo ""
echo "⚠️ 若 App 重启后报权限错误, 执行:"
echo "   chown -R <app_uid>:<app_uid> $TC"
echo "   (查询: dumpsys package com.TenkaS.myapp | grep userId)"
