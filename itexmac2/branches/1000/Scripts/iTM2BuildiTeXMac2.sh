#!/bin/sh
# iTM2SynchronizeFramework
# XCode 2.2 compliant, version 1
echo "warning: iTeXMac2 INFO, build iTeXMac2 for testing"
pushd "`dirname "$0"`"/..
SRC_TREE_ROOT="`pwd`"
echo "iTM2 tree root: ${SRC_TREE_ROOT}"
xcodebuild -target "iTeXMac2" -project iTeXMac2/iTeXMac2.xcodeproj -configuration "${CONFIGURATION}" build
STATUS=$?
if [ $STATUS -gt 0 ]
then
	echo "warning: iTeXMac2 INFO, build iTeXMac2 for testing... FAILED ($STATUS)"
	exit 1
else
	echo "warning: iTeXMac2 INFO, build iTeXMac2 for testing... DONE"
	exit 0
fi
