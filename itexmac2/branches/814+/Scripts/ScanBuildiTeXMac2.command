#!/bin/sh
# BuildiTeXMac2: use this to build iTeXMac2 from the command line
# XCode 2.2 compliant, version 1
DIR="$(dirname "$0")"
"$DIR/CleanSourceTree.command"
DIR="$(dirname "$DIR")"
cd "$DIR"
mkdir -p build
cd iTM3Foundation
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM3Foundation" -configuration "Development" clean build
cd ..
cd iTM2TeXFoundation
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM2TeXFoundation" -configuration "Development" clean build
cd iTM2TeXFoundationEngines
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "All" -configuration "Development" clean build
cd ..
cd ..
cd iTM2LaTeXKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM2LaTeXKit" -configuration "Development" clean build
cd iTM2LaTeXKitEngines
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "All" -configuration "Development" clean build
cd ..
cd ..
cd iTM2LaTeXSymbolsKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "All" -configuration "Development" clean build
cd ..
cd iTM2PDFKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM2PDFKit" -configuration "Development" clean build
cd ..
cd iTM2MetaPostKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM2MetaPostKit" -configuration "Development" clean build
cd ..
cd iTM2NewDocumentKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM2NewDocumentKit" -configuration "Development" clean build
cd ..
cd iTM2ConTeXtKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "iTM2ConTeXtKit" -configuration "Development" clean build
cd ..
cd iTM2BibTeXSupportKit
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "All" -configuration "Development" clean build
cd ..
cd iTeXMac2
/Developer/usr/checker/scan-build -o "$DIR"/build/scan-build.htmld xcodebuild -target "All" -configuration "Development" clean build
cd ..
