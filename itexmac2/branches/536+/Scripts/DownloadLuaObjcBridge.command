#!/bin/sh
# DownloadLuaObjcBridge
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Lua"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
PRODUCT_NAME="LuaObjcBridge"
TARBALL="${PRODUCT_NAME}-v1.4.2.tgz"
echo "warning: iTeXMac2 INFO, Downloading ${PRODUCT_NAME}..."
echo "curl \"http://www.pixelballistics.com/Software/LuaObjCBridge/LuaObjCBridge-v1.4.2.tgz\" --output LuaObjCBridge-v1.4.2.tgz"
curl "http://www.pixelballistics.com/Software/LuaObjCBridge/LuaObjCBridge-v1.4.2.tgz" --output LuaObjCBridge-v1.4.2.tgz
mkdir -p LuaObjCBridge-v1.4.2
tar --directory LuaObjCBridge-v1.4.2 -xvzf LuaObjCBridge-v1.4.2.tgz
exit 0
