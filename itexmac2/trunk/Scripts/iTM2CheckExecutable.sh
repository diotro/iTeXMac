#!/bin/sh
# iTM2CheckExecutable
# XCode 2.2 compliant, version 1
echo "warning: iTeXMac2 diagnostic for 'x'ecutable files."
pushd "${TARGET_BUILD_DIR}"
echo "warning: Removing the 'x'ecutable bit from all the files with a path extension not in a bin directory."
# thx Andrew Moore
find . -type f -perm -0001 -regex ".*/[^\/]*\.[^\/]*" -not -regex ".*/bin/.*" -exec chmod a-x {} \; -print
echo "warning: checking the 'x'ecutable bit of all the files in a bin directory."
TARGETS="`find . -regex ".*/bin/[^/\.][^/]*" -print`"
echo "TARGETS are: ${TARGETS}\n.............................."
IFS='
'
for ITEM in ${TARGETS}
do
	if [ -x "${ITEM}" ]
	then
		echo "'x'ecutable: <${ITEM}>"
	else
		echo "warning: ERROR, ${ITEM} is not 'x'ecutable."
		echo "warning: iTeXMac2 diagnostic for 'x'ecutable files... FAILED"
		exit 1
	fi
done
echo "warning: iTeXMac2 diagnostic for 'x'ecutable files... DONE"
