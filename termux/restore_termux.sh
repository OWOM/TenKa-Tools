#!/system/bin/sh
# Termux 完全版一键恢复脚本 (Android sh)
# 用法: sh restore_termux.sh [源目录]
# 源默认: 脚本所在目录
# 已验证: bootstrap + openjdk-21 + apksigner 完整部署 + 签名 APK Success

SRC="${1:-$(dirname "$0")}"
DST="/data/local/tmp/TenKa/termux"
D="$DST/termux_root"

echo "=== Termux 完全版恢复 ==="
echo "源: $SRC | 目标: $DST"

# 1. 检查文件
echo ""
echo "[1/6] 检查文件..."
REQ="bootstrap-aarch64.zip pool/main/o/openjdk-21/parts/openjdk-21.part_aa pool/main/o/openjdk-21/parts/openjdk-21.part_ab pool/main/a/apksigner/apksigner_37.0.0_all.deb"
for f in $REQ; do
  [ -f "$SRC/$f" ] && echo "  ✅ $f" || { echo "  ❌ 缺 $f"; exit 1; }
done

# 2. 部署
echo ""
echo "[2/6] 部署到 $DST..."
mkdir -p "$DST"
cp -r "$SRC/pool" "$SRC/bootstrap-aarch64.zip" "$DST/"
echo "  ✅ 已复制"

# 3. 解压 bootstrap
echo ""
echo "[3/6] 解压 bootstrap..."
cd "$DST"
rm -rf termux_root data
mkdir -p termux_root
export LD_LIBRARY_PATH=/data/local/tmp/TenKa/python_rt/lib
/data/local/tmp/TenKa/python_rt/bin/python3 -c "
import zipfile
z = zipfile.ZipFile('bootstrap-aarch64.zip')
z.extractall('termux_root')
z.close()
print('  ✅ bootstrap 解压')
"
# 加执行权限
chmod -R 755 "$D/bin" "$D/libexec" 2>/dev/null
echo "  ✅ bin 权限"
# 建 SYMLINKS
/data/local/tmp/TenKa/python_rt/bin/python3 -c "
import os
D = '$D'
n = 0
with open(os.path.join(D, 'SYMLINKS.txt')) as f:
    for line in f:
        line = line.strip()
        if not line or '\u2190' not in line: continue
        target, link = line.split('\u2190')
        link = link.strip().lstrip('./')
        target = target.strip()
        if target.startswith('lib/'): target = target[4:]
        if target.startswith('bin/'): target = target[4:]
        lp = os.path.join(D, link)
        tp = os.path.join(D, os.path.dirname(link), target)
        if not os.path.exists(lp) and os.path.exists(tp):
            os.makedirs(os.path.dirname(lp), exist_ok=True)
            os.symlink(target, lp); n += 1
print(f'  ✅ {n} 软链')
"
# 4. 解包所有 .deb 到 termux_root/usr (Termux 前缀 data/data/com.termux/files/usr)
echo ""
echo "[4/6] 解包依赖 + openjdk + apksigner..."
/data/local/tmp/TenKa/python_rt/bin/python3 << 'PYEOF'
import subprocess, os, shutil, glob
D = '/data/local/tmp/TenKa/termux/termux_root'
POOL = '/data/local/tmp/TenKa/termux'
env = {'PATH': D + '/bin:/system/bin', 'LD_LIBRARY_PATH': D + '/lib'}
DPKG = D + '/bin/dpkg-deb'
os.makedirs(D + '/usr/bin', exist_ok=True)
os.makedirs(D + '/usr/share/java', exist_ok=True)

def extract(deb, label):
    tmp = D + '/deb_tmp'
    shutil.rmtree(tmp, ignore_errors=True); os.makedirs(tmp)
    r = subprocess.run([DPKG, '-x', deb, tmp], capture_output=True, env=env)
    if r.returncode != 0:
        print(f'  ⚠️ {label}: 解包失败'); shutil.rmtree(tmp, ignore_errors=True); return
    # 找 usr (Termux 前缀 .../files/usr 或直接 usr)
    usr = None
    for root, dirs, files in os.walk(tmp):
        if root.endswith('/files/usr'): usr = root; break
    if not usr and os.path.isdir(tmp + '/usr'): usr = tmp + '/usr'
    if usr:
        n = 0
        for root, dirs, files in os.walk(usr):
            rel = os.path.relpath(root, usr)
            tgt = os.path.join(D, 'usr', rel) if rel != '.' else D + '/usr'
            os.makedirs(tgt, exist_ok=True)
            for f in files:
                try:
                    shutil.copy2(os.path.join(root, f), os.path.join(tgt, f)); n += 1
                except: pass
        print(f'  ✅ {label}: {n} 文件')
    else:
        print(f'  ⚠️ {label}: 无 usr')
    shutil.rmtree(tmp, ignore_errors=True)

# 依赖 (排除 openjdk/apksigner)
for deb in sorted(glob.glob(POOL + '/pool/main/**/*.deb', recursive=True)):
    if 'openjdk' in deb or 'apksigner' in deb: continue
    extract(deb, os.path.basename(deb).split('_')[0])
# openjdk + apksigner (openjdk 分卷先合并)
openjdk_parts = sorted(glob.glob(POOL + '/pool/main/o/openjdk-21/parts/*'))
openjdk_deb = POOL + '/pool/main/o/openjdk-21/openjdk-21_21.0.12_aarch64.deb'
if openjdk_parts and not os.path.exists(openjdk_deb):
    with open(openjdk_deb, 'wb') as out:
        for part in openjdk_parts:
            with open(part, 'rb') as f:
                out.write(f.read())
    print(f"  ✅ openjdk 分卷合并: {len(openjdk_parts)} 卷")
extract(openjdk_deb, 'openjdk-21')
extract(POOL + '/pool/main/a/apksigner/apksigner_37.0.0_all.deb', 'apksigner')

# 5. 建 java/keytool/jarsigner 软链 + apksigner 包装
for t in ['java','javac','keytool','jarsigner']:
    src = D + '/usr/lib/jvm/java-21-openjdk/bin/' + t
    if os.path.exists(src) and not os.path.exists(D + '/bin/' + t):
        os.symlink('../usr/lib/jvm/java-21-openjdk/bin/' + t, D + '/bin/' + t)
print('  ✅ java 工具链软链')
PYEOF

# apksigner 包装脚本 (本地路径)
mkdir -p "$D/usr/bin"
cat > "$D/usr/bin/apksigner" << 'EOF'
#!/system/bin/sh
TUX=/data/local/tmp/TenKa/termux/termux_root
export LD_LIBRARY_PATH=$TUX/lib:$TUX/usr/lib
exec $TUX/usr/lib/jvm/java-21-openjdk/bin/java -jar $TUX/usr/share/java/apksigner.jar "$@"
EOF
chmod 755 "$D/usr/bin/apksigner"
echo "  ✅ apksigner 包装"

# 5. 验证
echo ""
echo "[5/6] 验证..."
export LD_LIBRARY_PATH="$D/lib:$D/usr/lib"
echo -n "  java: "; "$D/bin/java" -version 2>&1 | head -1
echo -n "  apksigner: "; sh "$D/usr/bin/apksigner" --version 2>&1 | head -1

echo ""
echo "[6/6] 完成!"
echo "Termux 路径: $D"
echo "用: export PATH=$D/bin:\$PATH  LD_LIBRARY_PATH=$D/lib:$D/usr/lib"
