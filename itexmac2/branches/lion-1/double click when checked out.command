#!/usr/bin/env sh
# run this script to create the user xcode project files
#
find . -name "*-template" -print | sed 's/\(.*\)-template/ditto "\1-template" "\1"/'|sh
find . -name "*.pbxuser" -exec svn propset svn:ignore *.pbxuser "$(dirname "{}")" \;
find . -name "*.mode1v3" -exec svn propset svn:ignore *.mode1v3 "$(dirname "{}")" \;
find . -name "build" -exec svn propset svn:ignore build "$(dirname "{}")" \;
