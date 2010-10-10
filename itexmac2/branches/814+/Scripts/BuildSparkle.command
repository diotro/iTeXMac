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
	../Scripts/DownloadSparkle.command
fi
if ! [ -d "${PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 ERROR, I can't download Sparkle Sources"
	exit 1
fi
cd "${PRODUCT_NAME}"
IFS='
'
FRAMEWORKS=$(find . -name "*.framework" -print)
if test -z "$FRAMEWORKS"
then
	xcodebuild -target "${PRODUCT_NAME}" -configuration "$CONFIGURATION" clean build
	STATUS=$?
	if [ ${STATUS} -ne 0 ]
	then
		echo "warning: iTeXMac2 INFO, Building ${PRODUCT_NAME} complete... FAILED (${STATUS})"
		exit ${STATUS}
	fi
	FRAMEWORKS=$(find . -name "*.framework" -print)
fi
for BUILD in $FRAMEWORKS
do
	break
done
FRAMEWORK="${PRODUCT_NAME}.framework"
rm -Rf ../*.framework
cp -R "$BUILD" "../$FRAMEWORK"
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
