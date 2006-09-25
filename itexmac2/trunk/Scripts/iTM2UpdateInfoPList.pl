#!/usr/bin/env perl
# iTM2UpdateInfoPList.pl
# © Laurens'Tribune, Mardi 26 Septembre 2006
printf "warning: Updating the build number\n";
printf "Getting the svn revision number...";
$TARGET_BUILD_DIR = "$ENV{TARGET_BUILD_DIR}";
$REVISION=0;
@CANDIDATES=split('\0', `find "$TARGET_BUILD_DIR/.." -regex ".*\.mode1" -print0`);
while(my $FILE = shift(@CANDIDATES))
{
	printf "\n$FILE";
	$revision=`/usr/local/bin/svn info "$FILE"`;
	if( $revision =~ m/.*Revision: (\d*).*/s )
	{
		$revision="$1";
		if($revision > $REVISION)
		{
			$REVISION = $revision;
		}
	}
}
$FULL_INFOPLIST_PATH="$TARGET_BUILD_DIR/$ENV{INFOPLIST_PATH}";
printf "\nUpdating $FULL_INFOPLIST_PATH";
open INPUT, "< $FULL_INFOPLIST_PATH" or die "Can't open $FULL_INFOPLIST_PATH : $!";
$content = do { local $/; <INPUT> };
close INPUT;
if( $content =~ s/__\(REVISION\)__/$REVISION/g )
{
	open OUTPUT, "> $FULL_INFOPLIST_PATH" or die "Can't open $FULL_INFOPLIST_PATH : $!";
	print OUTPUT "$content";
	close OUTPUT;
	printf "\nwarning: Updating the build number to revision $REVISION... DONE\n";
}
else
{
	printf "\nwarning: Updating the build number... FAILED\n";
}
exit 0;

#