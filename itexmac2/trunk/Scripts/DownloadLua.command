#!/bin/sh
# DownloadLuaObjcBridge
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Lua"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
TARBALL="${PRODUCT_NAME}-5.1.2.tar.gz"
echo "warning: iTeXMac2 INFO, Downloading ${PRODUCT_NAME}..."
echo "http://www.lua.org/ftp/lua-5.1.2.tar.gz --output ${TARBALL}"
curl "http://www.lua.org/ftp/lua-5.1.2.tar.gz" --output "${TARBALL}"
exit 0
