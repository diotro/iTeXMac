#!/bin/sh
# DownloadLuaObjcBridge
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Lua"
DIR="$(dirname "$0")/../${PRODUCT_NAME}/luaobjc"
mkdir -p "$DIR"
cd "$DIR"
echo "Downloading luaobjc bridge."
if test -f "$HOME/.cvspass"
then
	cvs -d :pserver:anonymous@cvs.luaforge.net:/cvsroot/luaobjc checkout trunk
	exit 0
else
	cvs -d :pserver:anonymous@cvs.luaforge.net:/cvsroot/luaobjc login
	echo "Please, rerun the downloader."
	exit 1
fi
