#!/bin/sh
cd "$(dirname "$0")/../ICU"
echo "download icu source to have the headers"
curl "ftp://ftp.software.ibm.com/software/globalization/icu/3.2.1/icu4c-3.2.1.tgz" --output "icu4c-3.2.1-src.tgz"
rm -Rf icu
open "icu4c-3.2.1-src.tgz"
