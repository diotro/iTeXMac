#!/bin/sh
# iTM2SynchronizeCamelBones
PRODUCT_NAME=CamelBones
echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}"
pushd "`dirname "$0"`/.."
echo "iTM2 tree root: `pwd`"
CANDIDATE="/Developer/${PRODUCT_NAME}/Frameworks/${PRODUCT_NAME}.framework"
echo "warning: iTeXMac2 INFO, CANDIDATE is ${CANDIDATE}"
DESTINATION="build/${PRODUCT_NAME}.framework"
echo "warning: iTeXMac2 INFO, DESTINATION is ${DESTINATION}"
if [ -L "${CANDIDATE}/${PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 INFO, Importing ${PRODUCT_NAME}.framework"
	rm -Rf "${DESTINATION}"
	cp -Rf "${CANDIDATE}" "${DESTINATION}"
	echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}... DONE"
	exit 0
else
	echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}... FAILED"
	exit -1
fi
