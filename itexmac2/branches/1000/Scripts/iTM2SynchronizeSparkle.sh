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
	CANDIDATE="$(find . -regex "./${PRODUCT_NAME}/${PRODUCT_NAME}/.*Garbage.*/${PRODUCT_NAME}\.framework/${PRODUCT_NAME}" -print)"
	echo CANDIDATE is "${CANDIDATE}"
	if ! [ -L "${CANDIDATE}" ]
	then
		echo expanding the zip
		pushd "$PRODUCT_NAME"
		unzip -oq "$PRODUCT_NAME.zip" -d "$PRODUCT_NAME"
        find "$PRODUCT_NAME" -name ".svn" -exec rm -Rf "{}" \;
		popd
		CANDIDATE="$(find . -regex "./${PRODUCT_NAME}/${PRODUCT_NAME}/.*Garbage.*/${PRODUCT_NAME}\.framework/${PRODUCT_NAME}" -print)"
	fi
    CANDIDATE="$(dirname "${CANDIDATE}")"
	echo CANDIDATE is "${CANDIDATE}"
	echo "warning: iTeXMac2 INFO, Importing ${PRODUCT_NAME}.framework"
	if [ -e "${DESTINATION}" ]
	then
	   rm -Rf "${DESTINATION}"
    else
        mkdir -p "$(dirname "${DESTINATION}")"
    fi
	cp -R "${CANDIDATE}" "$(dirname ${DESTINATION})"
	echo "warning: iTeXMac2 INFO, Importing frameworks from ${PRODUCT_NAME}... DONE"
	exit 0
fi
