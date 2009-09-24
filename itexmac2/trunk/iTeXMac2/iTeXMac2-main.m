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

@implementation iTM2Application(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentVersion
+ (int)currentVersion;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
- (NSMenu *)iTM2_findMenu;
@end
@implementation NSApplication(OgreKit)
- (void)ogreKitWillHackFindMenu:(id)textFinder
{
	NSMenuItem * mi = [[self mainMenu] deepItemWithAction:@selector(OgreFindMenuItemAction:)];
	if(mi)
	{
		NSMenu * menu = [textFinder iTM2_findMenu];// this does not work any longer in tiger
		if(menu = [[menu copy] autorelease])
		{
			[mi setAction:NULL];
			[[mi menu] setSubmenu:menu forItem:mi];
		}
	}
	else
	{
		iTM2_LOG(@"No OgreKit panel installed because there is no menu item with action OgreFindMenuItemAction: in %@", [self mainMenu]);
	}
	return;
}
- (void)ogreKitShouldUseStylesInFindPanel:(id)textFinder
{
	[textFinder setUseStylesInFindPanel:NO];
}
- (void)OgreKit_DidFinishLaunching;
{
	id textFinder = [[OgreTextFinder alloc] init];
	if(textFinder)// beware of the bug
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"iTM2UseOgreKitFindPanel"]];
//iTM2_LOG(@"setShouldHackFindMenu: %@",([SUD boolForKey:@"iTM2UseOgreKitFindPanel"]?@"yes":@"no"));
		[textFinder setShouldHackFindMenu:[SUD boolForKey:@"iTM2UseOgreKitFindPanel"]];
		iTM2_LOG(@"OgreKit Properly installed");
	}
	else
	{
		iTM2_LOG(@"OgreKit not installed");
	}
	return;
}
@end

@implementation OgreTextFinder(OgreKit)
- (NSMenu *)iTM2_findMenu;
{
	return findMenu;
}
@end
#endif

#import "iTM2CrashReportKit.h"

@implementation NSApplication(iTM2Welcome)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: // :jlaurens:20040514 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No Welcome" forKey:@"iTeXMac2 Welcome"];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepare0000000000WelcomeCompleteInstallation
+ (void)prepare0000000000WelcomeCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: // :jlaurens:20040514 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2MileStone putMileStoneForKey:@"iTeXMac2 Welcome"];
	[NSBundle reportCrashIfNeeded];
    int CVN = [SUD integerForKey:iTM2CurrentVersionNumberKey];
    int CCV = [self currentVersion];
    if(!CVN)
    {
        [SUD setInteger:CCV forKey:iTM2CurrentVersionNumberKey];
        [iTM2Application showWelcomeNotes:self];
    }
    else if(CVN < CCV)
    {
        [SUD setInteger:CCV forKey:iTM2CurrentVersionNumberKey];
        [iTM2Application showReleaseNotes:self];
    }
    else if(![SUD boolForKey:iTM2DontShowTipsKey])
    {
        [iTM2Application showReleaseNotes:self];
    }
//iTM2_END;
    return;
}
@end

#if 0
@implementation NSApplication(iTeXMac2_main)
+ (void)load;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
	[NSApplication iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2MAIN_sendEvent:)];
	iTM2_RELEASE_POOL;
	return;
}
- (void)SWZ_iTM2MAIN_sendEvent:(NSEvent *)theEvent;
{iTM2_DIAGNOSTIC;
//NSLog(@"theEvent is: %@", theEvent);
	[self SWZ_iTM2MAIN_sendEvent:theEvent];
}
@end
#endif

#if 0

#import <Sparkle/Sparkle.h>

@interface SUUnarchiver(iTeXMac2_PUBLIC)
- (BOOL)_extractZIP:(NSString *)archivePath;
- (BOOL)_extractDMG:(NSString *)archivePath;
@end

@implementation SUUnarchiver(iTeXMac2)
+ (void)load;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
	[SUUnarchiver iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2__extractZIP:)];
	iTM2_RELEASE_POOL;
}
- (BOOL)SWZ_iTM2__extractZIP:(NSString *)archivePath
{
	if([self SWZ_iTM2__extractZIP:archivePath])
	{
		archivePath = [archivePath stringByDeletingPathExtension];
		archivePath = [archivePath stringByAppendingPathExtension:@"dmg"];
		if([DFM fileExistsAtPath:archivePath])
		{
			return [self _extractDMG:archivePath];
		}
		else
		{
			return YES;
		}
	}
	return NO;
}
@end

#endif

NSString *iTM2_SUScheduledCheckIntervalKey = @"SUScheduledCheckInterval";

@implementation iTM2MainInstaller(iTM2SoftwareUpdatePrefPane)
+ (void)iTM2SoftwareUpdatePrefPane_CompleteInstallation;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	NSDictionary * D = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:86400],iTM2_SUScheduledCheckIntervalKey,nil];
	[SUD registerDefaults:D];
	iTM2_RELEASE_POOL;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"0.SU";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frequency
- (int)frequency;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int frequency = [SUD integerForKey:iTM2_SUScheduledCheckIntervalKey];
	if(frequency<2)
	{
		[SUD setInteger:1 forKey:iTM2_SUScheduledCheckIntervalKey];
		return 0;
	}
	if(frequency<86401)
	{
		[SUD setInteger:86400 forKey:iTM2_SUScheduledCheckIntervalKey];
		return 1;
	}
	if(frequency<592201)
	{
		[SUD setInteger:592200 forKey:iTM2_SUScheduledCheckIntervalKey];
		return 2;
	}
	if(frequency<17766001)
	{
		[SUD setInteger:17766000 forKey:iTM2_SUScheduledCheckIntervalKey];
		return 3;
	}
	[SUD setInteger:UINT_MAX forKey:iTM2_SUScheduledCheckIntervalKey];
//iTM2_END;
    return 4;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setFrequency
- (void)setFrequency:(int)value;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willChangeValueForKey:@"frequency"];
	switch(value)
	{
		case 0:
			[SUD setInteger:1 forKey:iTM2_SUScheduledCheckIntervalKey];
		break;
		case 1:
			[SUD setInteger:84600 forKey:iTM2_SUScheduledCheckIntervalKey];
		break;
		case 2:
			[SUD setInteger:592200 forKey:iTM2_SUScheduledCheckIntervalKey];
		break;
		case 3:
			[SUD setInteger:17766000 forKey:iTM2_SUScheduledCheckIntervalKey];
		break;
		default:
			[SUD setInteger:INT_MAX forKey:iTM2_SUScheduledCheckIntervalKey];
		break;
	}
	[self didChangeValueForKey:@"frequency"];
//iTM2_END;
    return;
}
@end

@implementation iTM2TextStorage(OVERRIDE)
-(void)_antialiasThresholdChanged:(NSNotification *)notification;
{
	iTM2_LOG(@"notification:%@",notification);
//	[super _antialiasThresholdChanged:object];
	return;
}
@end
