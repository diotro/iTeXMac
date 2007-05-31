#!/bin/sh
cd "$(dirname "$0")/../ICU"
pushd icu/source
echo "./configure"
./configure
echo "make"
make
popd
REGEX="$(find . -name "regex.h" -print)"
echo "Header $REGEX"
cp -f "$REGEX" regex_public.h
perl -p -i -e 's/private:/public:/g' regex_public.h
