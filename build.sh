#!/bin/bash
set -e

mkdir -p armbian

BASE_OS="${BASE_OS:-trixie}"   # noble | trixie
VERSION="25.11.1"
KERNEL="6.12.58"

FILE_NAME="Armbian_${VERSION}_Uefi-x86_${BASE_OS}_current_${KERNEL}_minimal.img.xz"
BASE_URL="https://mirror.twds.com.tw/armbian-dl/uefi-x86/archive"
DOWNLOAD_URL="${BASE_URL}/${FILE_NAME}"
OUTPUT_PATH="armbian/armbian.img.xz"

echo "Base OS      : $BASE_OS"
echo "Downloading  : $DOWNLOAD_URL"

curl -fL -o "$OUTPUT_PATH" "$DOWNLOAD_URL"

echo "下载成功，检查文件："
file "$OUTPUT_PATH"

echo "解压 armbian.img"
xz -d "$OUTPUT_PATH"

ls -lh armbian/

echo "准备合成 armbian 安装器"

mkdir -p output
docker run --privileged --rm \
  -v "$(pwd)/output:/output" \
  -v "$(pwd)/supportFiles:/supportFiles:ro" \
  -v "$(pwd)/armbian/armbian.img:/mnt/armbian.img" \
  debian:buster \
  /supportFiles/build.sh
