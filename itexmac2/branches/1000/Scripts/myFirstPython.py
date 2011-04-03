#!/usr/bin/env python
 # -*- coding: utf-8 -*-

import sys, os
from optparse import OptionParser

#os.execv("/usr/bin/find", spcmd)
def main():
    TRUC = os.execl("/bin/sh", "-c", "ls")
    print "TRUC is: %" % TRUC
    usage = "usage: %prog [options] arg"
    parser = OptionParser(usage)

    value = os.environ.get('iTM2_Index_Engine')
    if not value: value="makeindex"
    parser.add_option("-e", "--engine", dest="engine", action="store", type="string", default=value,
        help="use the given indexing engine [default: "+value+"]")

    value = os.environ.get('iTM2_Index_RunSilently')
    if value == "YES":
        action = "store_true"
    else:
        action = "store_false"
        value="NO"
    parser.add_option("-q", "--quiet", action=action, default=value,
        dest="is_quiet", help="runs silently [default: "+value+"]")

    value = os.environ.get('iTM2_Index_CompressBlanks')
    if value == "YES":
        action = "store_true"
    else:
        action = "store_false"
        value="NO"
    parser.add_option("-c", "--compress-intermediate-blanks", action=action, default=value,
        dest="is_compress", help="By default, blanks in the index key are retained [default: "+value+"]")

    value = os.environ.get('iTM2_Index_GermanOrdering')
    if value == "YES":
        action = "store_true"
    else:
        action = "store_false"
        value="NO"
    parser.add_option("-g", "--german-ordering", action=action, default=value,
        dest="is_german", help="in accord with rules set forth in DIN 5007.\
            see makeindex manual for problems with German TeX commands like \"a, \"o... [default: "+value+"]")

    value = os.environ.get('iTM2_Index_LetterOrdering')
    if value == "YES":
        action = "store_true"
    else:
        action = "store_false"
        value="NO"
    parser.add_option("-l", "--letter-ordering", action=action, default=value,
        dest="is_letter", help="blanks don't count [default: "+value+"]")

    value = os.environ.get('iTM2_Index_NoImplicitPageRange')
    if value == "YES":
        action = "store_true"
    else:
        action = "store_false"
        value="NO"
    parser.add_option("-r", "--no-implicit-page-range", action=action, default=value,
        dest="is_implicit", help="disable implicit page range formation [default: "+value+"]")

    if os.environ.get('iTM2_Index_UseOutput') == "YES":
        value = os.environ.get('iTM2_Index_Output')
        if not value: value="any"
    else:
        value="any"
    parser.add_option("-o", "--output", action="store", type="string", default=value,
        dest="output", help="a number or one of any, odd, even [default: "+value+"]")

    if os.environ.get('iTM2_Index_UseStyle') == "YES":
        value = os.environ.get('iTM2_Index_Style')
        if value:
            parser.add_option("-s", "--style", action="store", type="string", default=value,
                dest="style", help="use a custom style file [default: "+value+"]")
    else:
        parser.add_option("-s", "--style", action="store", type="string",
            dest="style", help="use a custom style file [default: None]")

    if os.environ.get('iTM2_Index_UseLog') == "YES":
        value = os.environ.get('iTM2_Index_Log')
        if value:
            parser.add_option("-t", "--log-file", action="store", type="string", default=value,
                dest="log", help="use a custom log file [default: "+value+"]")
    else:
        parser.add_option("-t", "--log-file", action="store", type="string",
            dest="log", help="use a custom log file [default: None]")


    parser.set_defaults(verbose=True)

    parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose")
    (options, args) = parser.parse_args()
    if len(args) != 1:
        parser.error("incorrect number of arguments")

    print "options are %s:" % options
    print "args are %s:" % args

if __name__ == "__main__":
    sys.exit(main())

"""

		-p|--startingPageNumber)
			iTM2_Index_IsSeparate="YES"
                        shift 1
                        case $1 in
                                any|even|odd)
                                        iTM2_Index_SeparateMode="$1"
                                ;;
                                *)
                                        iTM2_Index_SeparateStart="$1"
                        esac
		;;
		*)
			if [ ${#iTM2_Index_Targets} -gt 0 ]
			then
				iTM2_Index_Targets="$iTM2_Index_Targets$IFS"
			fi
			if [ -d ${1} ]
			then
				iTM2_Index_Targets="$iTM2_Index_Targets`find "$1" -regex ".*\.idx" -print`"
#				iTM2_Index_Targets="$iTM2_Index_Targets`ls -1 -R $1`"
			else
				iTM2_Index_Targets="$iTM2_Index_Targets$1"
			fi


iTM2_INDEX_USAGE="Welcome to `basename "$0"` version ${iTM2_Index_Version}
This is iTeXMac2 built in script to make the index with MakeIndex
© 2005 jlaurens@users.sourceforge.net
Usage: `basename "$0"` options input where options are
       -h, --help: print this message and return.
       -p, --startingPageNumber: a number or one of any, odd, even.
       -q, --quiet: runs silently.
       -L: not available.
       -T: not available.
       The options given override some environment variables."


import sys, os
print "COUCOU"

find "$1" -regex ".*\.idx" -print
os.execl("/usr/local/teTeX/bin/powerpc-apple-darwin-current/tex", "hello\\bye")
import os
filename = os.environ.get('PYTHONSTARTUP')
if filename and os.path.isfile(filename):
    execfile(filename)

class Basic:
    def __init__(self, name):
        self.name = name
    def show(self):
        print 'Basic -- name: %s' % self.name

class Special(Basic):
    def __init__(self, name, edible):
        Basic.__init__(self, name)
        self.upper = name.upper()
        self.edible = edible
    def show(self):
        Basic.show(self)
        print 'Special -- upper name: %s.' % self.upper,
        if self.edible:
            print "It's edible."
        else:
            print "It's not edible."
    def edible(self):
        return self.edible

obj1 = Basic('Apricot')
obj1.show()
print '=' * 30
obj2 = Special('Peach', 1)
obj2.show()

from optparse import OptionParser

[...]

def main():
    usage = "usage: %prog [options] arg"
    parser = OptionParser(usage)
    parser.add_option("-f", "--file", type="string", dest="filename",
                      help="read data from FILENAME")
    parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose")
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose")
    [... more options ...]

    (options, args) = parser.parse_args()
    if len(args) != 1:
        parser.error("incorrect number of arguments")

    if options.verbose:
        print "reading %s..." % options.filename

    [... go to work ...]


if __name__ == "__main__":
    main()


# cut here
import os
filename = os.environ.get('PYTHONSTARTUP')
if filename and os.path.isfile(filename):
    execfile(filename)


#parse the arguments
from optparse import OptionParser
[...]
parser = OptionParser()
parser.add_option("-f", "--file", dest="filename",
                  help="write report to FILE", metavar="FILE")
parser.add_option("-q", "--quiet",
                  action="store_false", dest="verbose", default=True,
                  help="don't print status messages to stdout")

(options, args) = parser.parse_args()

os.system('/path/to/your/script -and -some -args')

"""