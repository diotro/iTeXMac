#!/bin/sh
# BuildHDCrashReporter
# XCode 2.2 compliant, version 1
PRODUCT_NAME="HDCrashReporter"
echo "warning: iTeXMac2 INFO, Building ${PRODUCT_NAME}..."
pushd "`dirname "$0"`/.."
echo "iTM2 tree root: `pwd`"
cd "${PRODUCT_NAME}"
PROJECT_DIR="`pwd`"
REPORTER_FRAMEWORK="${PROJECT_DIR}/${PRODUCT_NAME}.framework"
echo "warning: iTeXMac2 INFO, creating ${REPORTER_FRAMEWORK}..."
# finding the archive to expand
IFS='
'
REPORTER_ZIP=`find "${PROJECT_DIR}/../${PRODUCT_NAME}" -regex ".*/${PRODUCT_NAME}[0-9_]*\.zip" -print`
if [ ${#REPORTER_ZIP} -eq 0 ]
then
	echo "warning: iTeXMac2 ERROR, Missing ${PRODUCT_NAME}?.zip in ${PROJECT_DIR}/../../${PRODUCT_NAME} zip archive"
	echo "warning: iTeXMac2 ERROR, You are expected to download there an REPORTER zipped archive"
	echo "warning: iTeXMac2 ERROR, connect to http://www.profcast.com/developers/downloads/HDCrashReporter.zip"
	echo "warning: iTeXMac2 ERROR, OR launch the DownloadHDCrashReporter.command in the HDCrashReporter folder"
	exit 1
fi
for TEMP in ${REPORTER_ZIP}
do
	REPORTER_ZIP="${TEMP}"
	break
done
echo "warning: iTeXMac2 INFO, Expanding ${REPORTER_ZIP}..."
TARGET_BUILD_DIR="${PROJECT_DIR}/build"
mkdir -p "${TARGET_BUILD_DIR}"
unzip -o -d "${TARGET_BUILD_DIR}" "${REPORTER_ZIP}"
ls "${TARGET_BUILD_DIR}"
REPORTER_XCODE=`find "${TARGET_BUILD_DIR}" -regex ".*/.*${PRODUCT_NAME}.*\.xcodeproj"`
if [ ${#REPORTER_XCODE} -eq 0 ]
then
	echo "warning: iTeXMac2 ERROR, Missing ${PRODUCT_NAME}?.xcodeproj inside ${TARGET_BUILD_DIR}..."
	exit 2
fi
echo "warning: iTeXMac2 INFO, Project found ${REPORTER_XCODE}..."
REPORTER_DIRECTORY="`dirname "${REPORTER_XCODE}"`"
echo "warning: iTeXMac2 INFO, Project directory ${REPORTER_DIRECTORY}..."
pushd "${REPORTER_DIRECTORY}"
echo "warning: iTeXMac2 INFO, Start building ${PRODUCT_NAME}..."
CONFIGURATION="Release"
xcodebuild -target "${PRODUCT_NAME}" -configuration "$CONFIGURATION" clean build
STATUS=$?
if [ ${STATUS} -ne 0 ]
then
    echo "warning: iTeXMac2 INFO, Building ${PRODUCT_NAME} complete... FAILED (${STATUS})"
    exit -1
fi
popd
rm -Rf "${REPORTER_FRAMEWORK}"
echo "current directory is:"
pwd
REPORTER_BUILT_FRAMEWORK="`find . -regex "./build/${PRODUCT_NAME}/.*/${PRODUCT_NAME}.framework" -print`"
echo REPORTER_BUILT_FRAMEWORK is "${REPORTER_BUILT_FRAMEWORK}"
mv "${REPORTER_BUILT_FRAMEWORK}" .
echo "warning: iTeXMac2 INFO, Moving around ${PRODUCT_NAME}.framework complete..."
if [ -L "${REPORTER_FRAMEWORK}/${PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 INFO, `pwd`/${PRODUCT_NAME} properly built..."
	exit 0 
else
	echo "warning: iTeXMac2 ERROR, could not move the ${PRODUCT_NAME}.framework..."
	exit 4
fi
exit 0