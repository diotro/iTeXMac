#!/bin/sh
# iTM2SynchronizePlugIns
# XCode 2.2 compliant, version 1
cd "`dirname "$0"`"/..
X="`find . -regex ".*/build" -print`"
if [ ${#X} -gt 0 ]
then
    find . -regex ".*/build" -print0|xargs -0 rm -Rf
fi