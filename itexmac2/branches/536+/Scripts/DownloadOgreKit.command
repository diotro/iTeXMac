#!/bin/sh
# DownloadOgreKit
# XCode 2.2 compliant, version 1
PRODUCT_NAME="OgreKit"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
TARBALL="${PRODUCT_NAME}_2_1_2.tar.gz"
echo "warning: iTeXMac2 INFO, Downloading ${PRODUCT_NAME}..."
echo "curl http://www8.ocn.ne.jp/~sonoisa/OgreKit/${TARBALL} --output ${TARBALL}"
curl "http://www8.ocn.ne.jp/~sonoisa/OgreKit/${TARBALL}" --output "${TARBALL}"
exit 0