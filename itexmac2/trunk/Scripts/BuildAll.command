#!/bin/sh
# BuildAll: use this to build iTeXMac2 and its required frameworks from the command line
# XCode 2.2 compliant, version 1
DIR="$(dirname "$0")"
echo "Building Sparkle"
"$DIR"/BuildSparkle.command
if [ $? -ne 0 ]
then
    exit 1
fi
echo "Building OgreKit"
"$DIR"/BuildOgreKit.command
if [ $? -ne 0 ]
then
    exit 2
fi
echo "Building iTeXMac2"
"$DIR"/BuildiTeXMac2.command
if [ $? -ne 0 ]
then
    exit 3
fi
