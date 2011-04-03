#!/usr/bin/env perl
# PrepareBuildNumber.pl
# © Laurens'Tribune, Mardi 26 Septembre 2006
printf "message: Updating the build number\n";
$CONFIGURATION = "$ENV{CONFIGURATION}";
$TARGET_BUILD_DIR = "$ENV{TARGET_BUILD_DIR}";
$REVISION=0;
if($CONFIGURATION =~ m/Deployment/)
{
printf "Getting the svn revision number (CONFIGURATION is Deployment)...";
	$REVISION=`/usr/bin/svn log -r HEAD ..`;
	printf "\n/usr/bin/svn log -r HEAD:<$REVISION\n>";
	if( $REVISION =~ m/.*r(\d+) /s )
	{
		$REVISION="$1";
	}
	else
	{
		$REVISION = "ERROR";
		exit -1;
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
printf "\nmessage: Updating the build number to revision $REVISION... DONE\n";
exit 0;

#