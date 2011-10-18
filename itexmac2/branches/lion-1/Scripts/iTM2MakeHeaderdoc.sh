#!/bin/sh
echo "warning: iTeXMac2 INFO, Make the ${PROJECT} header documentation"
if [ "${CONFIGURATION}" != "Deployment" ]
then
	echo "warning: iTeXMac2 INFO, SKIPPING"
	echo "warning: iTeXMac2 INFO, Make the ${PROJECT} header documentation... DONE"
	exit 0	
fi
iTM2_OUTPUT="${TARGET_BUILD_DIR}/${DOCUMENTATION_FOLDER_PATH}"
if ! [ -d "${iTM2_OUTPUT}" ]
then
	mkdir "${iTM2_OUTPUT}"
	if ! [ -d "${iTM2_OUTPUT}" ]
	then
		echo "warning: iTeXMac2 INFO, Make the ${PROJECT} header documentation... FAILED"
		exit 1
	fi
fi
find . -name "*.h" -exec headerdoc2html -o "${iTM2_OUTPUT}" {} \;
find . -name "*.hdoc" -exec headerdoc2html -o "${iTM2_OUTPUT}" {} \;
gatherheaderdoc "${iTM2_OUTPUT}"
chown -R root:wheel "${iTM2_OUTPUT}"
echo "warning: iTeXMac2 INFO, Make the ${PROJECT} header documentation... DONE"
exit 0
