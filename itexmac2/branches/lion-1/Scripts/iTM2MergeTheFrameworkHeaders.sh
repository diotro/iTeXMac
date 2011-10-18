#!/bin/sh
# this is only while developping
cd "${TARGET_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}"
pwd
chmod -R u+w .
header="${PRODUCT_NAME}.h"
echo "warning: iTeXMac2 INFO, merging the ${PRODUCT_NAME} headers into ${header}"
if [ -f "${header}" ]
then
		rm -Rf "${header}"
fi
targets="`ls -1 -R *.h`$IFS"
echo "// ${PRODUCT_NAME} merged headers" > "${header}"
echo "// Automatically created when building project ${PROJECT_NAME}" >> "${header}"
echo "// $(date "+Created on %m/%d/%y at %H:%M:%S")" >> "${header}"
for var in ${targets}
do
	echo "#import <${PRODUCT_NAME}/$var>" >> "${header}"
done
find . -name "*.h" -exec chmod a-w {} \;
echo "warning: iTeXMac2 INFO, merging the ${PRODUCT_NAME} headers... DONE"
exit 0
