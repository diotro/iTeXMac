#!/bin/sh
if ! test -z "$1"
then
	find . \( -name "*.m" -or -name "*.h" \) -exec grep -q "$1" "{}" \; -print -exec perl -i.bak -pe "s/\b$1\b/iTM2_$1/g" "{}" \;
fi
