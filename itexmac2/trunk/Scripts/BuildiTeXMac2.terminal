#!/bin/sh
# iTM2Build: use this to build iTeXMac2 from the command line
# XCode 2.2 compliant, version 1
pushd "`dirname "$0"`/.."
echo "iTM2 tree root: `pwd`"
cd iTeXMac2
if [ ${#} -gt 0 ]
then
    echo "xcodebuild -target All -configuration $1 clean build"
    xcodebuild -target "All" -configuration "$1" clean build
else
    echo "xcodebuild -target All clean build"
    xcodebuild -target "All" clean build
fi