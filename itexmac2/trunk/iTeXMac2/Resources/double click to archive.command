#!/usr/bin/perl
# run this script to compress some resource folders before archiving to CVS or so.
# You can put a soft link to this script in someResource folder with a .terminal name
# such that double click will automatically compress the Macros and New Documents folders below
#
use Cwd;
use Getopt::Long;
use Cwd 'abs_path';
use File::Basename;
my $old_dir = dirname $0;
$old_dir = abs_path($old_dir);
chdir $old_dir;
my $dir = "$old_dir";
do
{
    @CANDIDATES=split('\0', `find "$dir" -regex ".*/double\ click\ to\ archive.pl" -print0`);
    while(my $FILE = shift(@CANDIDATES))
    {
        $FILE  = abs_path($FILE);
        chdir $old_dir;
        print "Executing $FILE\n";
        require $FILE;
        exit 0;
    }
    chdir "..";
    $dir = getcwd;
}
while(length $dir > 1 && (!m|.*/|));
exit 0;