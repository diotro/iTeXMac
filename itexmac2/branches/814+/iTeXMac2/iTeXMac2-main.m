//
//  iTeXMac2-main.m
//  iTM2
//
//  @version Subversion: $Id$ 
//
//  Created by Coder on 14/02/05.
//  Copyright Laurens'Tribune 2005. All rights reserved.
//


int main(int argc, char *argv[])
{
	NSLog(@"This is %s speaking... soon entering main", argv[0]);
    return NSApplicationMain(argc, (const char **) argv);
}

@implementation NSApplication(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentVersion
+ (NSInteger)currentVersion4iTM3;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    return 1;// 11/21/2002
//    return 2;// 11/29/2002
//    return 3;// 12/07/2002-1.2.4
//    return 4;// 01/06/2003-1.2.5
//    return 5;// 01/24/2003-1.2.6
//    return 6;// 01/24/2003-1.2.7
//    return 7;// 02/10/2003-1.2.8
//    return 8;// 02/18/2003-1.2.9
//    return 9;// 03/07/2003-1.2.10
//    return 10;// 03/21/2003-1.2.11
//    return 11;// 04/11/2003-1.2.12
//    return 12;// 05/02/2003-1.3.RC
//    return 13;// 05/16/2003-1.3.RC1
//    return 14;// 05/16/2003-1.3.RC2
//    return 15;// 09/09/2003-1.3.GM
//    return 16;// 09/22/2003-1.3 JAGUAR_BRANCH
//    return 17;// 09/30/2003-1.3.1 JAGUAR_BRANCH
//    return 18;// 09/30/2003-1.3.2 JAGUAR_BRANCH
//    return 19;// 09/30/2003-1.3.3 JAGUAR_BRANCH
//    return 20;// 10/23/2003-1.3.5 JAGUAR_BRANCH PANTHER RELEASE
//    return 21;// 10/28/2003-1.3.6 JAGUAR_BRANCH
//    return 22;// 10/28/2003-1.3.7 JAGUAR_BRANCH
//    return 23;// 11/10/2003-1.3.8 JAGUAR_BRANCH
//    return 24;// 11/21/2003-1.3.9 JAGUAR_BRANCH
//    return 25;// 12/02/2003-1.3.10 JAGUAR_BRANCH
//    return 26;// 12/02/2003-1.3.10-a JAGUAR_BRANCH
//    return 27;// 12/02/2003-1.3.10-b JAGUAR_BRANCH
//    return 28;// 12/02/2003-1.3.10-c JAGUAR_BRANCH
//    return 29;// 18/02/2003-1.3.10-d JAGUAR_BRANCH
//    return 30;// 19/20/2003-1.3.10-e JAGUAR_BRANCH
//    return 31;// 12/20/2003-1.3.10-f JAGUAR_BRANCH
//    return 32;// 12/20/2003-1.3.11 JAGUAR_BRANCH
//    return 33;// 02/10/2004-1.3.14 JAGUAR_BRANCH
//    return 34;// 02/10/2004-1.3.15 JAGUAR_BRANCH
//    return 35;// 03/21/2004-1.3.16 JAGUAR_BRANCH
//    return 36;// 03/21/2004-1.4 JAGUAR_BRANCH
//    return 53;// iTM2 preview 3
//    return 54;// iTM2 preview 4
//    return 55;// iTM2 preview 5
//    return 56;// iTM2 preview 6
//    return 60;// iTM2 preview 11
//    return 61;// iTM2 preview 12
    return 62;// iTM2 preview 16
}
@end
#if 0
#import <OgreKit/OgreKit.h>
@interface NSObject(OgreKit)
- (void)setShouldHackFindMenu:(BOOL)yorn;
- (void)setUseStylesInFindPanel:(BOOL)yorn;
- (NSMenu *)findMenu4iTM3;
@end
@implementation NSApplication(OgreKit)
- (void)ogreKitWillHackFindMenu:(id)textFinder
{
	NSMenuItem * mi = [self.mainMenu deepItemWithAction4iTM3:@selector(OgreFindMenuItemAction:)];
	if(mi)
	{
		NSMenu * menu = [textFinder findMenu4iTM3];// this does not work any longer in tiger
		if(menu = [[menu copy] autorelease])
		{
			mi.action = NULL;
			[mi.menu setSubmenu:menu forItem:mi];
		}
	}
	else
	{
		LOG4iTM3(@"No OgreKit panel installed because there is no menu item with action OgreFindMenuItemAction: in %@", self.mainMenu);
	}
	return;
}
- (void)ogreKitShouldUseStylesInFindPanel:(id)textFinder
{
	[textFinder setUseStylesInFindPanel:NO];
}
- (void)OgreKit_CompleteDidFinishLaunching4iTM3;
{
	id textFinder = [[OgreTextFinder alloc] init];
	if(textFinder)// beware of the bug
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"iTM2UseOgreKitFindPanel"]];
//LOG4iTM3(@"setShouldHackFindMenu: %@",([SUD boolForKey:@"iTM2UseOgreKitFindPanel"]?@"yes":@"no"));
		[textFinder setShouldHackFindMenu:[SUD boolForKey:@"iTM2UseOgreKitFindPanel"]];
		LOG4iTM3(@"OgreKit Properly installed");
	}
	else
	{
		LOG4iTM3(@"OgreKit not installed");
	}
	return;
}
@end

@implementation OgreTextFinder(OgreKit)
- (NSMenu *)findMenu4iTM3;
{
	return findMenu;
}
@end
#endif

#import "iTM2CrashReportKit.h"

@implementation NSApplication(iTM2Welcome)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepare0000000000WelcomeCompleteInstallation4iTM3
+ (void)prepare0000000000WelcomeCompleteInstallation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: // :jlaurens:20040514 
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	MILESTONE4iTM3((@"iTeXMac2 Welcome"),(@"No Welcome"));
	[NSBundle reportCrashIfNeeded];
    NSInteger CVN = [SUD integerForKey:iTM2CurrentVersionNumberKey];
    NSInteger CCV = self.currentVersion4iTM3;
    if (!CVN) {
        [SUD setInteger:CCV forKey:iTM2CurrentVersionNumberKey];
        [iTM2Application showWelcomeNotes:self];
    } else if(CVN < CCV) {
        [SUD setInteger:CCV forKey:iTM2CurrentVersionNumberKey];
        [iTM2Application showReleaseNotes:self];
    } else if(![SUD boolForKey:iTM2DontShowTipsKey]) {
        [iTM2Application showReleaseNotes:self];
    }
//END4iTM3;
    return;
}
@end


NSString *SUScheduledCheckIntervalKey4iTM3 = @"SUScheduledCheckInterval";

@implementation iTM2MainInstaller(SoftwareUpdatePrefPane)
+ (void)iTM2SoftwareUpdatePrefPane_CompleteInstallation4iTM3;
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
	NSDictionary * D = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:86400],SUScheduledCheckIntervalKey4iTM3,nil];
	[SUD registerDefaults:D];
	RELEASE_POOL4iTM3;
	return;
}
@end

@interface iTM2SoftwareUpdatePrefPane: iTM2PreferencePane
@end

@implementation iTM2SoftwareUpdatePrefPane: iTM2PreferencePane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return @"0.SU";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frequency
- (NSInteger)frequency;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger frequency = [SUD integerForKey:SUScheduledCheckIntervalKey4iTM3];
	if (frequency<2) {
		[SUD setInteger:1 forKey:SUScheduledCheckIntervalKey4iTM3];
		return 0;
	}
	if (frequency<86401) {
		[SUD setInteger:86400 forKey:SUScheduledCheckIntervalKey4iTM3];
		return 1;
	}
	if (frequency<592201) {
		[SUD setInteger:592200 forKey:SUScheduledCheckIntervalKey4iTM3];
		return 2;
	}
	if (frequency<17766001) {
		[SUD setInteger:17766000 forKey:SUScheduledCheckIntervalKey4iTM3];
		return 3;
	}
	[SUD setInteger:UINT_MAX forKey:SUScheduledCheckIntervalKey4iTM3];
//END4iTM3;
    return 4;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setFrequency
- (void)setFrequency:(NSInteger)value;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self willChangeValueForKey:@"frequency"];
	switch(value)
	{
		case 0:
			[SUD setInteger:1 forKey:SUScheduledCheckIntervalKey4iTM3];
		break;
		case 1:
			[SUD setInteger:84600 forKey:SUScheduledCheckIntervalKey4iTM3];
		break;
		case 2:
			[SUD setInteger:592200 forKey:SUScheduledCheckIntervalKey4iTM3];
		break;
		case 3:
			[SUD setInteger:17766000 forKey:SUScheduledCheckIntervalKey4iTM3];
		break;
		default:
			[SUD setInteger:INT_MAX forKey:SUScheduledCheckIntervalKey4iTM3];
		break;
	}
	[self didChangeValueForKey:@"frequency"];
//END4iTM3;
    return;
}
@end

@implementation iTM2TextStorage(OVERRIDE)
-(void)_antialiasThresholdChanged:(NSNotification *)notification;
{
	LOG4iTM3(@"notification:%@",notification);
//	[super _antialiasThresholdChanged:object];
	return;
}
@end

#ifdef __iTM3_DEVELOPMENT__
#warning Runtime TEST Unit
@implementation iTM2Application(iTM2TPDK)
- (void)testTeXPackageAtURLCompleteDidFinishLaunching4iTM3;
{
    LOG4iTM3(@"LSRegisterURL:%lu",LSRegisterURL((CFURLRef)[[NSBundle mainBundle] bundleURL],NO));
    // create a temporary directory
    NSURL * tempURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL * url = [tempURL URLByAppendingPathComponent:@"foo.texd"];
    BOOL yorn = NO;
    NSError * ROR = nil;
    NSAssert(([DFM fileExistsAtPath:url.path isDirectory:&yorn] && yorn)
        || [DFM createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:&ROR],@"MISSED");
    NSString * theType = [SDC typeForContentsOfURL:url error:&ROR];
    CFDictionaryRef D = UTTypeCopyDeclaration((CFStringRef) theType);
    CFURLRef URL = UTTypeCopyDeclaringBundleURL((CFStringRef) theType);
    LOG4iTM3(@"Type:%@\nDeclaration:%@,from bundle:%@",theType,D,URL);
    NSAssert([theType conformsToUTType4iTM3:iTM2UTTypeTeXWrapper] || [theType conformsToUTType4iTM3:iTM3UTTypeTeXWrapper],@"MISSED TeX Wrapper");
    url = [tempURL URLByAppendingPathComponent:@"foo.texp"];
    NSAssert(([DFM fileExistsAtPath:url.path isDirectory:&yorn] && yorn)
        || [DFM createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:&ROR],@"MISSED");
    theType = [SDC typeForContentsOfURL:url error:&ROR];
    D = UTTypeCopyDeclaration((CFStringRef) theType);
    URL = UTTypeCopyDeclaringBundleURL((CFStringRef) theType);
    LOG4iTM3(@"Type:%@\nDeclaration:%@,from bundle:%@",theType,D,URL);
    NSAssert([theType conformsToUTType4iTM3:iTM2UTTypeTeXProject] || [theType conformsToUTType4iTM3:iTM3UTTypeTeXProject],@"MISSED TeX Project");
}
@end
#endif

#include "../build/Milestones/iTeXMac2.m"
