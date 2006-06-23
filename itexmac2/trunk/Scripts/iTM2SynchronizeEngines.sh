#!/bin/sh
# iTM2SynchronizeEngines
# XCode 2.2 compliant, version 1
BASE_PRODUCT_NAME="${1}"
if [ ${#BASE_PRODUCT_NAME} -eq 0 ]
then
    echo "warning: iTeXMac2 ERROR, Usage is \"iTM2SynchronizeEngines.sh framework_name engines_repository\""
    exit -1
fi
FULL_PRODUCT_NAME="${BASE_PRODUCT_NAME}.framework"
ENGINES_REPOSITORY="${2}"
if [ ${#ENGINES_REPOSITORY} -eq 0 ]
then
    echo "warning: iTeXMac2 ERROR, Usage is \"iTM2SynchronizeEngines.sh framework_name engines_name\""
    exit -2
fi
pushd "${ENGINES_REPOSITORY}"
ENGINES_REPOSITORY="`pwd`"
popd
pushd "`dirname "$0"`"/..
SRC_TREE_ROOT="`pwd`"
echo "iTM2 tree root: ${SRC_TREE_ROOT}"
FULL_PRODUCT_DIR="${SRC_TREE_ROOT}/build"
echo "warning: iTeXMac2 INFO, Synchronize plug-ins for ${FULL_PRODUCT_NAME}..."
iTM2_PLUGINS_FOLDER_PATH="build/${FULL_PRODUCT_NAME}/PlugIns"
if ! [ -d "${iTM2_PLUGINS_FOLDER_PATH}" ]
then
	mkdir -p "${iTM2_PLUGINS_FOLDER_PATH}"
	echo "Creating ${iTM2_PLUGINS_FOLDER_PATH}"
	if ! [ -d "${iTM2_PLUGINS_FOLDER_PATH}" ]
	then
        echo "warning: iTeXMac2 INFO, Synchronize engines for ${FULL_PRODUCT_NAME}... FAILED(1)"
		exit 1
	fi
fi
pushd "${ENGINES_REPOSITORY}"
echo "warning: iTeXMac2 INFO, list of engines in `pwd`..."
# copier tout ce qui se termine par iTM2
IFS='
'
iTM2_TARGETS="`find . -regex ".*/build/[^/]*\.iTM2" -print`"
popd
echo "...${iTM2_TARGETS}"
for iTM2_VAR in ${iTM2_TARGETS}
do
	rm -Rf "${iTM2_PLUGINS_FOLDER_PATH}/${iTM2_VAR}"
	cp -Rf "${ENGINES_REPOSITORY}/${iTM2_VAR}" "${iTM2_PLUGINS_FOLDER_PATH}"
	if [ -d "${iTM2_PLUGINS_FOLDER_PATH}/${iTM2_VAR##*/}" ]
	then
		echo "warning: iTeXMac2 INFO, ${iTM2_VAR} plug-in copied"
	else
		echo "warning: iTeXMac2 INFO, Copying ${iTM2_VAR} plug-in... FAILED(2)"
		exit 2
	fi
done
# copier tout ce qui se termine par prefPane
IFS='
'
iTM2_TARGETS="`find . -regex ".*/build/[^/]*\.prefPane" -print`"
for iTM2_VAR in ${iTM2_TARGETS}
do
	rm -Rf "${iTM2_PLUGINS_FOLDER_PATH}/${iTM2_VAR}"
	cp -Rf "${iTM2_VAR}" "${iTM2_PLUGINS_FOLDER_PATH}"
	if [ -d "${iTM2_PLUGINS_FOLDER_PATH}/${iTM2_VAR##*/}" ]
	then
		echo "warning: iTeXMac2 INFO, ${iTM2_VAR} preference wrapper copied"
	else
		echo "warning: iTeXMac2 INFO, Copying ${iTM2_VAR} preference wrapper... FAILED(3)"
		exit 3
	fi
done
echo "warning: iTeXMac2 INFO, Copying the plug-ins... DONE"
