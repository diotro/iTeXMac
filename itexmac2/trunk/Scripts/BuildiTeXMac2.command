#!/bin/sh
# BuildiTeXMac2: use this to build iTeXMac2 from the command line
# XCode 2.2 compliant, version 1
DIR="$(dirname "$0")/.."
cd "$DIR"
mkdir -p build
TEMP_LOG="$DIR/build/iTM2.build.log"
rm -f "$TEMP_LOG"
echo "iTM2 tree root: $(pwd)"
cd iTeXMac2
if [ ${#} -gt 0 ]
then
    echo "xcodebuild -target All -configuration $1 clean build"
    xcodebuild -target "All" -configuration "$1" clean build > "$TEMP_LOG"
elif [ "${USER}" = "root" ]
then
    echo "xcodebuild -target \"All\" -configuration \"Deployment\" clean build"
    xcodebuild -target "All" -configuration "Deployment" clean build > "$TEMP_LOG"
else
    echo "xcodebuild -target \"All\" -configuration \"Development\" clean build"
    xcodebuild -target "All" -configuration "Development" clean build > "$TEMP_LOG"
fi
VERSION="$($DIR/build/iTeXMac2.app/Contents/MacOS/GetSourceVersion)"
LOG="$DIR/build/iTM2_$VERSION.build.log"
mv -f "$TEMP_LOG" "$LOG"
cat "$LOG"
echo "=================
SUMMARY:
"
grep -s "warning" "$LOG"
echo "POSSIBLE ERRORS:"
grep -s "In function" "$LOG"
grep -s "reference to undefined" "$LOG"
grep -s "FAILED" "$LOG"
