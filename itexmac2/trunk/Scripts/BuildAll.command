#!/bin/sh
# BuildAll: use this to build iTeXMac2 and its required frameworks from the command line
# XCode 2.2 compliant, version 1
pushd "`dirname "$0"`"
echo "Building Sparkle"
./BuildSparkle.command
if [ $? -ne 0 ]
then
    popd
    exit 1
fi
echo "Building OgreKit"
./BuildOgreKit.command
if [ $? -ne 0 ]
then
    popd
    exit 2
fi
echo "Building iTeXMac2"
./BuildiTeXMac2.command
if [ $? -ne 0 ]
then
    popd
    exit 3
fi
