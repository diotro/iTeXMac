#!/bin/sh
cd "$(dirname "$0")/../ICU"
pushd icu/source
echo "./configure"
./configure
echo "make"
make
echo "Is there a platform.h file?"
if ! [ -f "common/unicode/platform.h" ]
then
	echo "#warning: missing platform.h"
	exit 2
fi
popd
REGEX="$(find . -name "regex.h" -print)"
echo "Header $REGEX"
cp -f "$REGEX" regex_public.h
perl -p -i -e 's/private:/public:/g' regex_public.h
