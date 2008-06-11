#!/bin/sh
# DownloadLuaObjcBridge
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Lua"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
cvs -d :pserver:anonymous@cvs.luaforge.net:/cvsroot/luaobjc checkout trunk
exit 0
