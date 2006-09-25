#!/usr/bin/env perl
# iTM2UpdateInfoPList.pl
# © Laurens'Tribune, Dimanche 24 Septembre 2006
printf "warning: Updating the build number\n";
printf "Getting the svn revision number...";
$TARGET_BUILD_DIR = "$ENV{TARGET_BUILD_DIR}";
$REVISION=`/usr/local/bin/svn info "$TARGET_BUILD_DIR/../History.txt"`;
if( $REVISION =~ m/.*Revision: (\d*).*/s )
{
	$REVISION="$1";
	printf "REVISION: $REVISION";
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
		printf "\nwarning: Updating the build number... DONE\n";
	}
	else
	{
		printf "\nwarning: Updating the build number... FAILED\n";
	}
}
else
{
	printf "\nwarning: Updating the build number... SKIPPED\n";
}
exit 0;
