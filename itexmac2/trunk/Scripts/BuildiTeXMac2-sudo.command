#!/bin/sh
# BuildiTeXMac2-sudo: use this to build iTeXMac2 from the command line
# XCode 2.2 compliant, version 1
DIR="$(dirname "$0")"
TEMP_LOG="$DIR/../build/iTM2.build.log"
rm -f "$TEMP_LOG"
sudo "$(echo "$0" | sed 's/-sudo\././')" > "$TEMP_LOG"
VERSION="$($DIR/../build/iTeXMac2.app/Contents/MacOS/GetSourceVersion)"
LOG="$DIR/../build/iTM2_$VERSION.build.log"
mv -f "$TEMP_LOG" "$LOG"
cat "$TEMP_LOG"
echo "=================
SUMMARY:
"
grep -s "In function" "$LOG"
