# Termux 完全版恢复指南

## 前提
- 已下载全部文件 (bootstrap-aarch64.zip + 所有 .deb)
- 目标目录: /data/local/tmp/TenKa/termux/ (运行副本)
- 需 root

## 步骤

### 1. 部署文件
```bash
# 把下载的 termux/ 整个目录放到运行副本
cp -r <下载目录>/termux /data/local/tmp/TenKa/termux
```

### 2. 解压 bootstrap (基础环境)
```bash
cd /data/local/tmp/TenKa/termux
# bootstrap-aarch64.zip 解压出 usr/ 目录结构
unzip -q bootstrap-aarch64.zip -d termux_root
# 预期: termux_root/usr/bin, termux_root/usr/lib 等
```

### 3. 安装 .deb 包 (openjdk + apksigner + 依赖)
```bash
# 用 dpkg 安装 (Termux 的 dpkg 在 bootstrap 里)
export PATH=/data/local/tmp/TenKa/termux/termux_root/usr/bin:$PATH
cd /data/local/tmp/TenKa/termux
# 先装依赖 (顺序: lib → openjdk → apksigner)
dpkg -i pool/main/liba/libandroid-shmem/*.deb
dpkg -i pool/main/liba/libandroid-spawn/*.deb
dpkg -i pool/main/libi/libiconv/*.deb
dpkg -i pool/main/z/zlib/*.deb
dpkg -i pool/main/libj/libjpeg-turbo/*.deb
dpkg -i pool/main/l/littlecms/*.deb
dpkg -i pool/main/a/alsa-plugins/*.deb
dpkg -i pool/main/c/ca-certificates/*.deb
dpkg -i pool/main/c/ca-certificates-java/*.deb
dpkg -i pool/main/o/openjdk-21/*.deb
dpkg -i pool/main/a/apksigner/*.deb
```

### 4. 验证
```bash
export PATH=<termux_root>/usr/bin:$PATH
java -version   # 应显示 openjdk 21
apksigner --help
```

### 5. 签名 APK 示例
```bash
apksigner sign --ks <keystore> --ks-pass pass:<密码> --out out.apk in.apk
```

## 注意
- .deb 是 Termux 格式 (aarch64), 不能直接用系统 dpkg (没有)
- 全部文件校验: 对照 manifest.json 的 sha256
- 换设备: 重新下载即可 (不固化进 APK)
