#!/usr/bin/env perl
# run this script while building any bundle containing New Documents, projects, macros...
use File::Basename;
use Cwd;
$FULL_PRODUCT_NAME="$ENV{FULL_PRODUCT_NAME}";
$CONTENTS_FOLDER_PATH="$ENV{CONTENTS_FOLDER_PATH}";
$TARGET_BUILD_DIR="$ENV{TARGET_BUILD_DIR}";
$PROJECT_DIR="$ENV{PROJECT_DIR}";
$UNLOCALIZED_RESOURCES_FOLDER_PATH="$ENV{UNLOCALIZED_RESOURCES_FOLDER_PATH}";
my $FULL_UNLOCALIZED_RESOURCES_FOLDER_PATH="$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH";
my $FOLDER="$TARGET_BUILD_DIR/$CONTENTS_FOLDER_PATH";
print "warning: iTeXMac2 INFO Expanding resources at $FOLDER...\n";
@CANDIDATES=split('\0', `find "$FOLDER" -regex ".*\.resources\.tgz" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Expanding compressed resource:\n$FILE...\n";
    my $dir = dirname($FILE);
    `tar -xvzf "$FILE" --directory "$dir";rm "$FILE"`;
    print "Expanding $FILE... DONE\n";
}
print "warning: iTeXMac2 INFO Creating the Macros summaries...\n";
if(-d "$PROJECT_DIR/../Scripts")
{
	@CANDIDATES=split('\0', `find "$PROJECT_DIR/../Scripts" -regex ".*/iTM2MakeMacrosSummary" -print0`);
}
elsif(-d "$PROJECT_DIR/../../Scripts")
{
	@CANDIDATES=split('\0', `find "$PROJECT_DIR/../../Scripts" -regex ".*/iTM2MakeMacrosSummary" -print0`);
}
elsif(-d "$PROJECT_DIR/../../../Scripts")
{
	@CANDIDATES=split('\0', `find "$PROJECT_DIR/../../../Scripts" -regex ".*/iTM2MakeMacrosSummary" -print0`);
}
if( $iTM2MakeMacrosSummary = shift @CANDIDATES )
{
# damn where is the appropriate DTD?
	my $DTD = "$ENV{SOURCE_ROOT}/../iTM3Foundation/DTDs/Actions.DTD";
	@CANDIDATES=split('\0', `find "$FULL_UNLOCALIZED_RESOURCES_FOLDER_PATH" -regex ".*/Actions\.xml" -print0`);
	while(my $FILE = shift(@CANDIDATES))
	{
		print "Summarizing $FILE...";
		`"$iTM2MakeMacrosSummary" --source "$FILE" --dtd "$DTD"`;
		print "DONE\n";
	}
	print "warning: iTeXMac2 INFO Creating the Macros summaries... DONE\n";
	print "warning: iTeXMac2 INFO Expanding resources at $FULL_UNLOCALIZED_RESOURCES_FOLDER_PATH... DONE\n";
}
else
{
	die "warning: iTeXMac2 ERROR Creating the Macros summaries... FAILED\n";
}
