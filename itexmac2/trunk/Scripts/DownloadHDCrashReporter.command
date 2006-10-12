#!/bin/sh
# DownloadHDCrashReporter
# XCode 2.2 compliant, version 1
PRODUCT_NAME="HDCrashReporter"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
echo "warning: iTeXMac2 INFO, Downloading ${PRODUCT_NAME}..."
echo "curl http://www.profcast.com/developers/downloads/HDCrashReporter.zip --output HDCrashReporter.zip"
curl "http://www.profcast.com/developers/downloads/HDCrashReporter.zip" --output HDCrashReporter.zip
exit 0