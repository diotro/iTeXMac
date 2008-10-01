#!/bin/sh
# iTM2SynchronizeSparkle
PRODUCT_NAME="Sparkle"
echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}"
pushd "$(dirname "$0")/.."
echo "iTM2 tree root: $(pwd)"
DESTINATION="build/${PRODUCT_NAME}.framework"
echo DESTINATION is ${DESTINATION}
if ! [ -L "${DESTINATION}/${PRODUCT_NAME}" ]
then
	CANDIDATEs="$(find . -regex "./${PRODUCT_NAME}/${PRODUCT_NAME}/${PRODUCT_NAME}\.framework" -print)"
	for CANDIDATE in ${CANDIDATEs}
	do
		break
	done
	echo CANDIDATE is ${CANDIDATE}
	if ! [ -L "${CANDIDATE}/${PRODUCT_NAME}" ]
	then
		echo expanding the zip
		pushd "$PRODUCT_NAME"
		unzip "$PRODUCT_NAME.zip"
		popd
		CANDIDATEs="$(find . -regex "./${PRODUCT_NAME}/${PRODUCT_NAME}/${PRODUCT_NAME}\.framework" -print)"
		for CANDIDATE in ${CANDIDATEs}
		do
			break
		done
	fi
	echo CANDIDATE is ${CANDIDATE}
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
fi
