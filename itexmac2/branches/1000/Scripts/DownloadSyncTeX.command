#!/bin/sh
# Download synctexdir from texlive Buil directory
# XCode 2.2 compliant, version 1
cd "$(dirname "$0")/.."
mkdir -p SyncTeX_TeX_Live
cd SyncTeX_TeX_Live
svn co svn://tug.org/texlive/trunk/Build/source/texk/web2c/synctexdir
exit 0
