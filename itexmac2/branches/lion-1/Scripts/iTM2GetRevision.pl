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
printf "$REVISION";
exit 0;
#