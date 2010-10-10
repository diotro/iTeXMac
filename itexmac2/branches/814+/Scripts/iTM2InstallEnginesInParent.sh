#!/bin/sh
# iTM2InstallPlugInsInParent
# XCode 2.2 compliant, version 1
FULL_PRODUCT_NAME=`find .. -regex "../[^/]*\.xcodeproj" -print`
echo "warning: iTeXMac2 INFO, finish building ${FULL_PRODUCT_NAME%.*}..."
xcodebuild -project "${FULL_PRODUCT_NAME}" -target "Install Engines" clean build
STATUS="$?"
if [ ${STATUS} -gt 0 ]
then
	echo "warning: iTeXMac2 INFO, building ${FULL_PRODUCT_NAME%.*} if needed... FAILED with error ${STATUS}"
	exit 1
else
	echo "warning: iTeXMac2 INFO, building ${FULL_PRODUCT_NAME%.*} if needed... DONE"
	exit 0
fi
