#!/bin/sh
# iTM2BuildOgreKit
# XCode 2.2 compliant, version 1
PRODUCT_NAME="OgreKit"
echo "warning: iTeXMac2 INFO, Building ${PRODUCT_NAME}..."
pushd "`dirname "$0"`/.."
echo "iTM2 tree root: `pwd`"
cd "${PRODUCT_NAME}"
PROJECT_DIR="`pwd`"
OGREKIT_FRAMEWORK="${PROJECT_DIR}/${PRODUCT_NAME}.framework"
echo "warning: iTeXMac2 INFO, creating ${OGREKIT_FRAMEWORK}..."
# finding the archive to expand
IFS='
'
OGREKIT_TGZ=`find "${PROJECT_DIR}/../OgreKit" -regex ".*/${PRODUCT_NAME}[0-9_]*\.tar\.gz" -print`
if [ ${#OGREKIT_TGZ} -eq 0 ]
then
	echo "warning: iTeXMac2 ERROR, Missing ${PRODUCT_NAME}?.tar.gz in ${PROJECT_DIR}"
	echo "warning: iTeXMac2 ERROR, You are expected to download there an OgreKit tarball"
	echo "warning: iTeXMac2 ERROR, connect to http://www8.ocn.ne.jp/~sonoisa/OgreKit/#Download"
	exit 1
fi
for TEMP in ${OGREKIT_TGZ}
do
	OGREKIT_TGZ="${TEMP}"
	break
done
echo "warning: iTeXMac2 INFO, Expanding ${OGREKIT_TGZ}..."
TARGET_BUILD_DIR="${PROJECT_DIR}/build"
mkdir -p "${TARGET_BUILD_DIR}"
tar -C "${TARGET_BUILD_DIR}" -xzf "${OGREKIT_TGZ}"
ls "${TARGET_BUILD_DIR}"
OGREKIT_XCODE=`find "${TARGET_BUILD_DIR}" -regex ".*/.*${PRODUCT_NAME}.*\.xcodeproj"`
if [ ${#OGREKIT_XCODE} -eq 0 ]
then
	echo "warning: iTeXMac2 ERROR, Missing ${PRODUCT_NAME}?.xcodeproj inside ${TARGET_BUILD_DIR}..."
	exit 2
fi
echo "warning: iTeXMac2 INFO, Project found ${OGREKIT_XCODE}..."
OGREKIT_DIRECTORY="`dirname "${OGREKIT_XCODE}"`"
echo "warning: iTeXMac2 INFO, Project directory ${OGREKIT_DIRECTORY}..."
pushd "${OGREKIT_DIRECTORY}"
echo "warning: iTeXMac2 INFO, Fixing ${PRODUCT_NAME}..."
pwd
"${PROJECT_DIR}/../Scripts/FixOgreKit.pl" --directory="${PROJECT_DIR}"
echo "warning: iTeXMac2 INFO, Start building ${PRODUCT_NAME}..."
CONFIGURATION="Release"
xcodebuild -target All -configuration "$CONFIGURATION" clean build
STATUS=$?
if [ ${STATUS} -ne 0 ]
then
    echo "warning: iTeXMac2 INFO, Building ${PRODUCT_NAME} complete... FAILED (${STATUS})"
    exit -1
fi
popd
rm -Rf "${OGREKIT_FRAMEWORK}"
echo "current directory is:"
pwd
OGREKIT_BUILT_FRAMEWORK="`find . -regex "./.*/build/$CONFIGURATION/OgreKit.framework" -print`"
echo OGREKIT_BUILT_FRAMEWORK is "${OGREKIT_BUILT_FRAMEWORK}"
mv "${OGREKIT_BUILT_FRAMEWORK}" .
echo "warning: iTeXMac2 INFO, Moving around ${PRODUCT_NAME}.framework complete..."
if [ -L "${OGREKIT_FRAMEWORK}/${PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 INFO, `pwd`/${PRODUCT_NAME} properly built..."
	exit 0 
else
	echo "warning: iTeXMac2 ERROR, could not move the ${PRODUCT_NAME}.framework..."
	exit 4
fi
exit 0