#!/usr/bin/perl
# iTM2CreateMacroIndex.pl
# XCode 2.2 compliant, version 1
# Create a ls-R.plist file for macros
# Create the ls-R at the given path.
# Parse the directory at the given path and create the ls-R.plist.
# The ls-R.plist contains a dictionary.
# The keys are identifier, values are the paths of files where the actions are defined.
# The paths are relative to the directory containing the ls-R.plist file.
# Some files need to be parsed because they can contain more than one macro action.
# The old macro files and new perl files are one of them.
# Perl files (with file extensions "pl") can contain different macro actions, as subroutines.
# To make the difference between subroutines as macro actions and utility subroutines,
# we assume that macro action subroutine names have iTM2_ prefix.
# Then the relative identifier of this subroutine is the name without the iTM2_ prefix.
# The identifier is relative to the identifier of the containing file.
# The identifier of a file is meant extensionless.
# It is possible to have at the same time a myMacros.pl and a myMacros.plist file.
# If a macro action is defined in both files with the same identifier, only one will be kept.
# Which one is undefined.
# © Laurens'Tribune, Mercredi 01 février 2006
use Devel::Peek;
use Foundation;
use Getopt::Long;
use Cwd 'abs_path';
GetOptions( "directory=s"  => \$DIRECTORY,
            "help!" => \$HELP,
            "verbose!" => \$VERBOSE,
            "callback!" => \$CALLBACK);
if ($HELP)
{
    print "Usage: iTM2CreateMacroIndex.pl --directory /my/foo/dir --help --verbose --callback";
    exit 0;
}
die "ERROR: I wish I had a directory 0x213\nUsage: iTM2CreateMacroIndex.pl --directory /my/foo/dir --help --verbose --callback\n" unless defined $DIRECTORY or ($DIRECTORY = $ENV{"iTM2_DIRECTORY"} and defined $DIRECTORY) or ($DIRECTORY = $ENV{"PWD"} and defined $DIRECTORY);
$CALLBACK = 0 unless defined $CALLBACK or ($CALLBACK = $ENV{"iTM2_CALLBACK"} and defined $CALLBACK);
$VERBOSE = 0 unless defined $VERBOSE or ($VERBOSE = $ENV{"iTM2_VERBOSE"} and defined $VERBOSE);
$VERBOSE = $VERBOSE and ! $CALLBACK;
print "Working on the directory $DIRECTORY\n" if $VERBOSE;
@MACROS_FILES=split('\0', `find "$DIRECTORY" -type f -regex ".*/Macros/.*" -print0`);
my $all_the_macros;
while(my $FILE = shift(@MACROS_FILES))
{
    next if $FILE =~ m|.*\.iTM2MacroIndex|;
    $FILE = abs_path($FILE);
    next unless $FILE =~ m|(.*/Macros/)(.*)\.(.*)|;
    my $BASE_PATH = $1;
    my $RELATIVE_PATH = "$2";
    my $EXTENSION = $3;
	# what are the domain and category
	
    my $macros = $all_the_macros->{$BASE_PATH};
    if ($EXTENSION eq "pl")
    {
        if ( open(INPUT, "<$FILE" ) )
        {
            print "Parsing perl file $FILE\n" if $VERBOSE;
            while(my $LINE = <INPUT>)
            {
                next unless $LINE =~ m/^# *iTM2: *(.*)$/;
                my $description = $1;
                #
				while(my $LINE = <INPUT>)
				{
					next unless $LINE =~ m/sub *(.*)(\W|#)/;
					my $identifier = $1;
					my $macro;
					$macro->{"PATH"} = "./$RELATIVE_PATH";
					$macro->{"NAME"} = $identifier;
					$macro->{"DESCRIPTION"} = $description;
					print "macro identifier: $RELATIVE_PATH/$identifier\n" if $VERBOSE;
					$macros->{"$RELATIVE_PATH/$identifier"} = $macro;
					#
				}
            }
        }
        else
        {
            print "warning: Could not open file $FILE\n";
        }
    }
    elsif($EXTENSION eq "plist")
    {
        print "Parsing property list $FILE\n" if $VERBOSE;
		$path =~ m|.*/Macros/(.*)|;
        my $RELATIVE_PATH = $1;
        my $dictionary = NSDictionary->dictionaryWithContentsOfFile_($path);
        my $keyEnumerator = $dictionary->keyEnumerator;
		my $name;
        while ($key = $keyEnumerator->nextObject and $$key)
        {
			my $dict = $dictionary->objectForKey_($key);
			my $description = "Description Forthcoming";
			my ($volume,$directories,$basename) = File::Spec->splitpath( $key->description->UTF8String );
            my $identifier = $basename;
			my $name = $1;
			if ($dict->isKindOfClass_(NSDictionary->class))
			{
				my $desc = $dict->objectForKey_("DESCRIPTION");
				$description = $desc if defined $desc;
				my $na = $dict->objectForKey_("NAME");
				$name = $na if defined $na;
			}
			my $macro;
			$macro->{"PATH"} = "./$RELATIVE_PATH";
			$macro->{"NAME"} = $name;
			$macro->{"DESCRIPTION"} = $description;
			$macros->{"$RELATIVE_PATH/$identifier"} = $macro;
        }
    }
    else
    {
        print "ignoring file $FILE\n" if $VERBOSE;
    }
    $all_the_macros{$BASE_PATH} = $macros;
}
if ($CALLBACK)
{
    my $data = NSPropertyListSerialization->dataFromPropertyList_format_errorDescription_($all_the_macros, 100, 0);
    my $string = NSString->alloc->initWithData_encoding_($data, 4);
    print $string->UTF8String;
	$string->release;
}
else
{
	while ( my ($BASE_PATH, $dictionary) = each(%$all_the_macros) )
	{
        my $path = "$BASE_PATH/INDEX".".iTM2MacroIndex";
        print "Writing ".$path."\n" if $VERBOSE;
		open OUTPUT, ">$path" or die "unable to open $path $!";
		print "Parsing perl file $FILE\n" if $VERBOSE;
		print OUTPUT
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".
"<!DOCTYPE INDEX [\n".
"    <!ELEMENT INDEX (KEYPREFIX?, (KEY, PATH)*)>\n".
"    <!ELEMENT KEYPREFIX (#PCDATA)>\n".
"    <!ELEMENT KEY (#PCDATA)>\n".
"    <!ELEMENT PATH (#PCDATA)>\n".
"]>\n".
"<INDEX>\n";
		while ( my ($key, $value) = each(%$all_the_macros) )
		{
			print $OUTPUT
"	<KEY>$key</KEY>\n".
"	<PATH>$value</PATH>\n";			
		}
		print OUTPUT
"</INDEX>\n";
    }
}
print "Cinq clous verts y moches\n" if $VERBOSE;
exit 0;
