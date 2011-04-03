#!/bin/sh
# iTM2SynchronizeFramework
# XCode 2.2 compliant, version 1
BASE_PRODUCT_NAME="${1}"
if [ ${#BASE_PRODUCT_NAME} -eq 0 ]
then
    echo "warning: iTeXMac2 ERROR, Usage is \"iTM2SynchronizeFramework.sh framework_name\""
    exit -1
fi
FULL_PRODUCT_NAME="${BASE_PRODUCT_NAME}.${WRAPPER_EXTENSION}"
pushd "`dirname "$0"`"/..
SRC_TREE_ROOT="`pwd`"
echo "iTM2 tree root: ${SRC_TREE_ROOT}"
FULL_PRODUCT_DIR="${SRC_TREE_ROOT}/build"
echo "warning: iTeXMac2 INFO, Synchronizing ${FULL_PRODUCT_NAME}..."
echo "warning: iTeXMac2 INFO, expected library:"
echo "warning: ${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}/${BASE_PRODUCT_NAME}"
if [ -d "${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}" ]
then
	if [ -L "${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}/${BASE_PRODUCT_NAME}" ]
	then
		echo "warning: iTeXMac2 INFO, ${FULL_PRODUCT_NAME} already available"
		echo "warning: iTeXMac2 INFO, Synchronizing ${FULL_PRODUCT_NAME}... DONE"
		if [ -L "${SYMROOT}/${FULL_PRODUCT_NAME}" ] || ! [ -d "${SYMROOT}/${FULL_PRODUCT_NAME}" ]
		then
			rm -f "${SYMROOT}/${FULL_PRODUCT_NAME}"
			ln -s "${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}" "${SYMROOT}"
		fi
		exit 0
	fi
	echo "warning: iTeXMac2 INFO, corrupted ${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}"
fi
echo "warning: iTeXMac2 INFO, building ${FULL_PRODUCT_NAME}"
PROJECT="${BASE_PRODUCT_NAME}/${BASE_PRODUCT_NAME}.xcodeproj"
echo "xcodebuild -project ${PROJECT} -target All -configuration ${CONFIGURATION} clean build"
xcodebuild -project "${PROJECT}" -target "All" -configuration "${CONFIGURATION}" clean build
STATUS=$?
if [ ${STATUS} -gt 0 ]
then
	echo "warning: iTeXMac2 INFO, building ${FULL_PRODUCT_NAME} if needed... FAILED with error ${STATUS}"
	exit 1
elif [ -L "${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}/${BASE_PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 INFO, building ${FULL_PRODUCT_NAME} if needed... SUCCEEDED"
	if [ -L "${SYMROOT}/${FULL_PRODUCT_NAME}" ] || ! [ -d "${SYMROOT}/${FULL_PRODUCT_NAME}" ]
	then
		rm -f "${SYMROOT}/${FULL_PRODUCT_NAME}"
		ln -s "${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}" "${SYMROOT}"
	fi
	exit 0
else
	echo "warning: iTeXMac2 INFO, building ${FULL_PRODUCT_NAME} if needed... FAILED with missing Link"
	echo "warning: ${FULL_PRODUCT_DIR}/${FULL_PRODUCT_NAME}/${BASE_PRODUCT_NAME}"
	exit 2
fi
