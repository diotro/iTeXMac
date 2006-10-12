#!/bin/sh
# DownloadHDCrashReporter
# XCode 2.2 compliant, version 1
PRODUCT_NAME="HDCrashReporter"
echo "warning: iTeXMac2 INFO, Downloading ${PRODUCT_NAME}..."
echo "http://www.profcast.com/developers/downloads/HDCrashReporter.zip --output HDCrashReporter.zip"
curl "http://www.profcast.com/developers/downloads/HDCrashReporter.zip" --output HDCrashReporter.zip
exit 0