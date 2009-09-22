#!/bin/sh
# DownloadLua
# XCode 2.2 compliant, version 1
PRODUCT_NAME="Lua"
cd "$(dirname "$0")/../${PRODUCT_NAME}"
BASE=http://www.lua.org
LUA_SITE=$(curl $BASE/download.html)
LUA_SRCE="$(echo $LUA_SITE|perl -nle 'if(m/="ftp\/(lua[^"]+?)"/){print "$1"}')"
echo "Downloading $LUA_SRCE"
LUA_URL="$(echo $LUA_SITE|perl -nle 'if(m/="(ftp\/lua[^"]+?)"/){print "$1"}')"
echo "From $BASE/$LUA_URL"
LUA_SHA1="$(echo $LUA_SITE|perl -nle 'if(m/="(ftp\/sha1[^"]+?)"/){print "$1"}')"
LUA_SHA1=$(curl $BASE/$LUA_SHA1)
LUA_SHA1=$(echo $LUA_SHA1|perl -nle "if(m/([a-f0-9]+) $LUA_SRCE/){print \"\$1\"}")
echo "Expected sha1: $LUA_SHA1"
curl -o "$LUA_SRCE" "$BASE/$LUA_URL"
LOCAL_SHA1=$(/usr/bin/openssl sha1 "$LUA_SRCE")
LOCAL_SHA1=$(echo $LOCAL_SHA1|perl -nle "if(m/([a-f0-9]+)$/){print \"\$1\"}")
echo "Local sha1: $LUA_SHA1"
if [ "$LOCAL_SHA1"=="$LUA_SHA1" ]
then
	echo "Download successful"
	exit 0
else
	echo "Download FAILED"
	exit 1
fi
