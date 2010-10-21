#!/bin/sh
# iTM2BuildSparkleKit
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Sparkle"
echo "warning: iTeXMac2 INFO, Building ${PRODUCT_NAME}..."
pushd "$(dirname "$0")/.."
echo "iTM2 tree root: $(pwd)"
cd "${PRODUCT_NAME}"
PROJECT_DIR="$(pwd)"
if ! [ -d "${PRODUCT_NAME}" ]
then
    if ! [ -f "${PRODUCT_NAME}.zip" ]
    then
        ../Scripts/DownloadSparkle.command
    fi
    unzip -oq "${PRODUCT_NAME}.zip" -d "${PRODUCT_NAME}"
    find "${PRODUCT_NAME}" -name ".svn" -exec rm -Rf "{}" \;
    if ! [ -d "${PRODUCT_NAME}" ]
    then
        echo "error: iTeXMac2 ERROR, I can't download Sparkle Sources"
        exit 1
    fi
fi
if ! [ -d "${PRODUCT_NAME}" ]
then
	echo "error: iTeXMac2 ERROR, I can't download Sparkle Sources"
	exit 1
fi
cd "${PRODUCT_NAME}"
IFS='
'
FRAMEWORK="${PRODUCT_NAME}.framework"
FRAMEWORKS=$(find . -regex ".*Garbage.*${FRAMEWORK}/${PRODUCT_NAME}" -print)
if test -z "$FRAMEWORKS"
then
	echo "error: iTeXMac2 ERROR, I can't find Sparkle Framework"
	exit 1
fi
for BUILD in $FRAMEWORKS
do
	break
done
rm -Rf ../*.framework
BUILD="$(dirname "$BUILD")"
echo copy "$BUILD" to "../$FRAMEWORK"
ditto "$BUILD" "../$FRAMEWORK"
cd ..
if [ -L "${FRAMEWORK}/${PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 INFO, `pwd`/${PRODUCT_NAME} properly built..."
	exit 0 
else
	echo "warning: iTeXMac2 ERROR, could not move the $FRAMEWORK..."
	exit 4
fi
exit 0
