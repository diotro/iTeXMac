#!/usr/bin/env perl
# PrepareBuildNumber.pl
# © Laurens'Tribune, vendredi 2 Novembre 2007, Leopard
printf "warning: Updating the build number\n";
$CONFIGURATION = "$ENV{CONFIGURATION}";
$TARGET_BUILD_DIR = "$ENV{TARGET_BUILD_DIR}";
$REVISION=0;
if($CONFIGURATION =~ m/Deployment/)
{
printf "Getting the svn revision number (CONFIGURATION is Deployment)...";
	@CANDIDATES=split('\0', `find .. -regex ".*iTM2.*" -not -regex ".*\.svn.*" -not -regex ".*/build.*" -not -regex ".*~.*" -print0`);
	while(my $FILE = shift(@CANDIDATES))
	{
		$revision=`/usr/bin/svn info "$FILE"`;
		if( $revision =~ m/.*Revision: (\d*).*/s )
		{
			$revision="$1";
			if($revision > $REVISION)
			{
				printf "\n$revision:$FILE";
				$REVISION = $revision;
			}
		}
	}
}
else
{
	$REVISION = "97531";
}
$INFOPLIST_PREFIX_HEADER="$TARGET_BUILD_DIR/INFOPLIST_PREFIX_HEADER";
printf "\nUpdating $INFOPLIST_PREFIX_HEADER";
open OUTPUT, "> $INFOPLIST_PREFIX_HEADER" or die "Can't open $INFOPLIST_PREFIX_HEADER : $!";
print OUTPUT "#define SVN_BUILD_NUMBER $REVISION\n";
$DATE=`date -u`;
print OUTPUT "#define SVN_BUILD_DATE $DATE\n";
close OUTPUT;
printf "\nwarning: Updating the build number to revision $REVISION... DONE\n";
exit 0;

#