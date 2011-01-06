#!/bin/sh
# this is used only while developing
# parses all the .m files and extracts the MILESTONE4iTM3 macros
my_PROJECT_DIR="$1"
my_DIR_ROOT="$2"
myBase="$(basename "$my_PROJECT_DIR")"
function create_milestone_file {
#   $1 source folder
    echo "#warning iTeXMac2 INFO, registering the milestones of directory $1"
    echo "@implementation iTM2Application(${myBase}Milestones)"
    echo "+(void)prepareMilestones4${myBase}CompleteInstallation4iTM3; {"
    find "$1" -name "*.m" -exec perl -ne 'print "ENOTSELIM4iTM3$1\n" if /MILESTONE4iTM3(.*?\)\w*;)/' "{}" \;
    echo "} @end"
}
WHERE="$my_DIR_ROOT/${myBase}Milestones.m"
mkdir -p "$(dirname "$WHERE")"
create_milestone_file "$my_PROJECT_DIR" > "$WHERE"
exit 0


