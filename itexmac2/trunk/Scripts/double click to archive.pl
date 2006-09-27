#!/usr/bin/perl
# run this script to compress some resource folders before archiving to CVS or so.
# You can put a soft link to this script in someResource folder with a .terminal name
# such that double click will automatically compress the Macros and New Documents folders below
#
use Cwd;
use Getopt::Long;
GetOptions( "directory=s"  => \$DIRECTORY,
            "help!" => \$HELP);
if($HELP)
{
    print "Usage: double click to archive.pl --directory /my/foo/dir --help --verbose --callback";
    exit 0;
}
die "ERROR: I wish I had a directory 0x213\nUsage: iTM2CreateMacroIndex.pl [--directory /my/foo/dir] [--help]\n" unless defined $DIRECTORY or ($DIRECTORY = $ENV{"iTM2_DIRECTORY"} and defined $DIRECTORY) or ($DIRECTORY = getcwd and defined $DIRECTORY);

print "warning: iTeXMac2 INFO Compressing some folders in $DIRECTORY\n";
$UNCOMPRESSED="New Documents.localized";
$COMPRESSED="NewDocuments.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Styles.localized";
$COMPRESSED="Styles.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Base Projects.localized";
$COMPRESSED="BaseProjects.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Text Editor.localized";
$COMPRESSED="TextEditor.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Macros.localized";
$COMPRESSED="Macros.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Templates For Regular Expressions.localized";
$COMPRESSED="ARETemplates.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Key Bindings.localized";
$COMPRESSED="KeyBindings.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Completion.localized";
$COMPRESSED="Completion.resources.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="gimp related sources";
$COMPRESSED="gimp.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
$UNCOMPRESSED="Localize iTeXMac2.pages";
$COMPRESSED="LocalizeiTeXMac2.tgz";
@CANDIDATES=split('\0', `find "$DIRECTORY" -regex ".*/$UNCOMPRESSED" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Compressing $FILE\n";
    my $old_dir = getcwd;
    my $new_dir = $old_dir;
    $FILE  =~ m|(.*)/.*|;
    print $new_dir."\n";
    chdir $1;
    print getcwd."\n";
    `rm -f "$COMPRESSED";tar -czf "$COMPRESSED" "$UNCOMPRESSED";rm -Rf "$UNCOMPRESSED"`;
    chdir $old_dir;
    print "Compressing $FILE... DONE\n";
}
print "warning: iTeXMac2 INFO Compressing some folders in $DIRECTORY... DONE\n";
