#!/bin/sh
cd "$(dirname "$0")/../ICU"
echo "download icu source to have the headers"
curl "ftp://ftp.software.ibm.com/software/globalization/icu/3.6/icu4c-3_6-src.tgz" --output "icu4c-3_6-src.tgz"
echo "extracting from the archive"
rm -Rf icu
tar -xzf "icu4c-3_6-src.tgz"
echo "make some changes due to cpp/obj-c compatibility problems"
cp "platform.h" "icu/source/common/unicode/platform.h"
cp "icu/source/i18n/unicode/regex.h" "regex_public.h"
perl -p -i -e 's/^private:/public:/g' "regex_public.h"
