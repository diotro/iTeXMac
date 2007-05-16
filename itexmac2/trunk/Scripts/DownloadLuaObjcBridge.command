#!/bin/sh
# DownloadLuaObjcBridge
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Lua"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
PRODUCT_NAME="LuaObjcBridge"
TARBALL="${PRODUCT_NAME}-v1.4.2.tgz"
echo "warning: iTeXMac2 INFO, Downloading ${PRODUCT_NAME}..."
echo "http://www.pixelballistics.com/Software/LuaObjCBridge/${TARBALL} --output ${TARBALL}"
curl "http://www.pixelballistics.com/Software/LuaObjCBridge/${TARBALL}" --output "${TARBALL}"
exit 0