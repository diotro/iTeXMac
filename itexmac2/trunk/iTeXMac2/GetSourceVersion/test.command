#!/bin/sh
cd "$(dirname "$0")/../../build"
BUNDLE="iTeXMac2.app"
VERSION="$($BUNDLE/Contents/MacOS/GetSourceVersion)"
echo "$BUNDLE VERSION IS:$VERSION"
