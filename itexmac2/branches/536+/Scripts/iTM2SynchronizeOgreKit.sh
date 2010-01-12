#!/bin/sh
# iTM2SynchronizeOgreKit
PRODUCT_NAME=OgreKit
echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}"
pushd "`dirname "$0"`/.."
echo "iTM2 tree root: `pwd`"
find . -regex ".*${PRODUCT_NAME}/${PRODUCT_NAME}\.framework" -print
CANDIDATEs="`find . -regex \".*/build/.*/${PRODUCT_NAME}\.framework\" -print`"
for TEMP in ${CANDIDATEs}
do
	CANDIDATE="${TEMP}"
	break
done
echo CANDIDATE is ${CANDIDATE}
DESTINATION="build/${PRODUCT_NAME}.framework"
echo DESTINATION is ${DESTINATION}
if [ -L "${CANDIDATE}/${PRODUCT_NAME}" ]
then
	echo "warning: iTeXMac2 INFO, Importing ${PRODUCT_NAME}.framework"
	if [ -e "${DESTINATION}" ]
	then
	   rm -Rf "${DESTINATION}"
    else
        mkdir -p "`dirname "${DESTINATION}"`"
    fi
	cp -Rf "${CANDIDATE}" "${DESTINATION}"
	echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}... DONE"
	exit 0
else
	echo "warning: iTeXMac2 ERROR, Importing frameworks from ${CANDIDATE}... FAILED"
	echo "warning: iTeXMac2 ERROR, RUN the Scripts/BuildOgreKit.terminal by double clicking"
	exit -1
fi
