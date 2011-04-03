#! /usr/bin/env sh
# this is used only while developing
# parses all the .m files and extracts the code sections included into  macros

THIS IS NOT COMPLETE

my_PROJECT_DIR="$1"
my_DIR_ROOT="$2"
# create the directory where all the test files are built
my_EMBEDDED_DIR="$my_DIR_ROOT/EmbeddedTests"
mkdir -p "$my_EMBEDDED_DIR"
# create the tool to build the test files
my_PARSER="$my_EMBEDDED_DIR/parser.command"
cat - <<EOF >>"$my_PARSER"
#! /usr/bin/env sh
# $1: file to parse
$my_DESTINATION="$(dirname "$0")"

EOF
exit 0
myBase="$(basename "$my_PROJECT_DIR")"
function create_test_file {
#   $1 source folder
    echo "#warning iTeXMac2 INFO, registering the dynamic tests of directory $1"
    find "$1" -name "*.m" -exec perl -ne 'print "$1\n$2" if /$\#\s*ifdef __EMBEDED_TEST__\s*(\w*?).*?$(.*?)$\#\s%endif/sm' "{}" \;
}
function create_header_file {
#   $1 source folder
    echo "#warning iTeXMac2 INFO, registering the dynamic tests of directory $1"
    find "$1" -name "*.m" -exec perl -ne 'print "match" if m/\#\s*ifdef __EMBEDED_TEST__(.*)endif/s' "{}" \;
}
WHERE="$my_DIR_ROOT/EmbeddedTests/${myBase}TestCases"
mkdir -p "$(dirname "$WHERE")"
create_test_file "$my_PROJECT_DIR" > "$WHERE.m"
create_header_file "$my_PROJECT_DIR" > "$WHERE.h"
exit 0


