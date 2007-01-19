//
//  iTeXMac2-main.m
//  iTM2
//
//  @version Subversion: $Id$ 
//
//  Created by Coder on 14/02/05.
//  Copyright Laurens'Tribune 2005. All rights reserved.
//

#import <Foundation/NSDebug.h>

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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= logWelcomeMessage
+ (void)logWelcomeMessage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 2.0: 2007
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * executable = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
    NSLog(@"Welcome to %@ version %@", executable, [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]);
    if(iTM2DebugEnabled)
    {
		NSLog(@"RUNNING IN DEBUG LEVEL %i: more comments are available, at the cost of a performance degradation", iTM2DebugEnabled);
        NSLog(@"Please, set the iTM2DebugEnabled defaults value to '0' if you want to come back to the normal behaviour use one of");
        NSLog(@"terminal%% defaults write comp.text.TeX.iTeXMac2 iTM2DebugEnabled '0'");
        NSLog(@"terminal%% defaults delete comp.text.TeX.iTeXMac2 iTM2DebugEnabled");
		NSLog(@"Cocoa debug flags: NSDebugEnabled: %@, NSZombieEnabled: %@, NSHangOnUncaughtException: %@",
			(NSDebugEnabled? @"Y": @"N"), (NSZombieEnabled? @"Y": @"N"), (NSHangOnUncaughtException? @"Y": @"N"));
	}
	else
    {
		NSLog(@"RUNNING IN 0 DEBUG LEVEL. To have more comments available for debugging purpose");
        NSLog(@"Please, set the iTM2DebugEnabled defaults value to some positive (the higher the more precise):");
        NSLog(@"terminal%% defaults write comp.text.TeX.iTeXMac2 iTM2DebugEnabled '10000'");
	}
//iTM2_END
	return;
}
@end
#import <OgreKit/OgreKit.h>
#import <HDCrashReporter/crashReporter.h>
@interface NSObject(OgreKit)
- (void)setShouldHackFindMenu:(BOOL)yorn;
- (void)setUseStylesInFindPanel:(BOOL)yorn;
- (NSMenu *)findMenu;
@end
@implementation NSApplication(OgreKit)
- (void)ogreKitWillHackFindMenu:(id)textFinder
{
	NSMenuItem * mi = [[self mainMenu] deepItemWithAction:@selector(OgreFindMenuItemAction:)];
	if(mi)
	{
		NSMenu * menu = [textFinder findMenu];
		menu = [[menu copy] autorelease];
		[mi setAction:NULL];
		[[mi menu] setSubmenu:menu forItem:mi];
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
		[textFinder setShouldHackFindMenu:NO];
		iTM2_LOG(@"OgreKit Properly installed");
	}
	else
	{
		iTM2_LOG(@"OgreKit not installed");
	}
	return;
}
- (void)crashReporter_DidFinishLaunching;
{
	//do crash recovery
	//
	return;
}
@end

@implementation OgreTextFinder(OgreKit)
- (NSMenu *)findMenu;
{
	return findMenu;
}
@end

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
	[NSBundle redirectNSLogOutput];
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
@interface NSApplication_DEBUG: NSApplication
@end
@implementation NSApplication_DEBUG
+ (void)load;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
	[self poseAsClass:[NSApplication class]];
	iTM2_RELEASE_POOL;
	return;
}
- (void)sendEvent:(NSEvent *)theEvent;
{iTM2_DIAGNOSTIC;
//NSLog(@"theEvent is: %@", theEvent);
	[super sendEvent:theEvent];
}
@end
#endif

#if 0
#import <iTM2Foundation/iTM2Foundation.h>
@implementation iTM2Application(IIUOP)
+ (void)load;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
	NSEnumerator * E = [[iTM2RuntimeBrowser realInstanceSelectorsOfClass:[NSAutoreleasePool class] withSuffix:@"" signature:nil inherited:NO] objectEnumerator];
	SEL selector;
	while(selector = (SEL)[[E nextObject] pointerValue])
		NSLog(NSStringFromSelector(selector));
	iTM2_RELEASE_POOL;
}
@end

#endif

#if 0
@interface NSAutoreleasePool_DEBUG: NSAutoreleasePool
- (void)swizzled_AddObject:(id)object;
@end
static NSMutableDictionary * NSAutoreleasePool_Recorder = nil;
static BOOL NSAutoreleasePool_Swizzled = NO;
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
@implementation iTM2MainInstaller(NSAutoreleasePool_DEBUG)
+ (void)NSAutoreleasePool_CompleteInstallationX;
{iTM2_DIAGNOSTIC;
	[iTM2RuntimeBrowser swizzleClassMethodSelector:@selector(addObject:) replacement:@selector(swizzled_addObject:) forClass:[NSAutoreleasePool class]];
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(dealloc) replacement:@selector(swizzled_dealloc) forClass:[NSAutoreleasePool class]];
	return;
}
+ (void)xload;
{iTM2_DIAGNOSTIC;
	NSAutoreleasePool * P = [[NSAutoreleasePool alloc] init];
	[NSBundle redirectNSLogOutput];
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(release) replacement:@selector(swizzled_release) forClass:[NSAutoreleasePool class]];
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(release) replacement:@selector(swizzled_NSObject_release) forClass:[NSObject class]];
	[P release];
	return;
}
@end
#import <objc/objc.h>
@implementation NSObject(iTeXMac2_DEBUG)
- (void)swizzled_NSObject_release;
{iTM2_DIAGNOSTIC;
	printf("=-=-=-=-=-=-=-=-=-=-  object release: %#x %s %i START", self, object_getClassName(self), [self retainCount]);
	[self swizzled_NSObject_release];
	printf("=-=-=-=-=-=-=-=-=-=-  object release: %#x END\n", self);
	return;
}
@end
@implementation NSAutoreleasePool(iTeXMac2_DEBUG)
- (void)swizzled_release;
{iTM2_DIAGNOSTIC;
//	[isa showPools];
	printf("=-=-=-=-=-=-=-=-=-=-  AP release: %#x START", self);
	[self swizzled_release];
	printf("=-=-=-=-=-=-=-=-=-=-  AP release: %#x END\n", self);
	return;
}
@end
#elif 0
#pragma mark =-=-=-=-=-  BUG HUNTING
@interface NSAutoreleasePool_DEBUG: NSAutoreleasePool
- (void)swizzled_AddObject:(id)object;
@end
static NSMutableDictionary * NSAutoreleasePool_Recorder = nil;
static BOOL NSAutoreleasePool_Swizzled = NO;
@implementation iTM2MainInstaller(NSAutoreleasePool_Recorder)
+ (void)NSAutoreleasePool_Recorder_CompleteInstallation;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	if([SUD boolForKey:@"NSAutoreleasePool_Recorder"])
	{
		NSAutoreleasePool_Recorder = [[NSMutableDictionary dictionary] retain];
		[NSAutoreleasePool_DEBUG poseAsClass:[NSAutoreleasePool class]];
//		[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(addObject:) replacement:@selector(swizzled_addObject:) forClass:[NSAutoreleasePool class]];
	}
	iTM2_RELEASE_POOL;
	return;
}
@end
@implementation NSAutoreleasePool_DEBUG
- (void)swizzled_AddObject:(id)object;
{iTM2_DIAGNOSTIC;
	if(NSAutoreleasePool_Swizzled)
	{
		[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(addObject:) replacement:@selector(swizzled_addObject:) forClass:[self class]];
		NSAutoreleasePool_Swizzled = NO;
	}
	NSValue * K = [NSValue valueWithNonretainedObject:self];
	NSMutableDictionary * MD = [NSAutoreleasePool_Recorder objectForKey:K];
	if(! MD)
	{
		MD = [NSMutableDictionary dictionary];
		[NSAutoreleasePool_Recorder setObject:MD forKey:K];
	}
	[MD setObject:[object description] forKey:[NSValue valueWithNonretainedObject:object]];
	if(!NSAutoreleasePool_Swizzled)
	{
		[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(addObject:) replacement:@selector(swizzled_addObject:) forClass:[self class]];
		NSAutoreleasePool_Swizzled = YES;
	}
	[self swizzled_AddObject:object];
	return;
}
- (id)initWithCapacity:(unsigned)numItems;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(addObject:) replacement:@selector(swizzled_addObject:) forClass:[self class]];
	return [self initWithCapacity:numItems];
}
- (void)dealloc:(id)object;
{iTM2_DIAGNOSTIC;
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(addObject:) replacement:@selector(swizzled_addObject:) forClass:[self class]];
	iTM2_INIT_POOL;
//NSLog(@"Deallocating autorelease pool");
	id K = [NSValue valueWithNonretainedObject:self];
	NSDictionary * D = [NSAutoreleasePool_Recorder objectForKey:K];
	NSEnumerator * E = [D keyEnumerator];
	NSValue * key;
	id O;
	while(key = [E nextObject])
	{
		NS_DURING
		if([[key nonretainedObjectValue] retainCount]<2)
			NSLog(@"Bad retain count? %@", [D objectForKey:key]);
		NS_HANDLER
			NSLog(@"***  HUGE PROBLEM WITH OBJECT: %@", [D objectForKey:key]);
			[localException raise];
		NS_ENDHANDLER
	}
	iTM2_RELEASE_POOL;
//NSLog(@"Done deallocating autorelease pool");
	[super dealloc];
	return;
}
@end
#else
@interface NSAutoreleasePool_DEBUG: NSAutoreleasePool
@end
#import <objc/objc.h>
@implementation NSAutoreleasePool_DEBUG
+ (void)load;{[self poseAsClass:[NSAutoreleasePool class]];}
- (void)addObject:(id)object;
{iTM2_DIAGNOSTIC;
#if 0
	const char * name = object_getClassName(object);
	if(strncmp(name, "iTM2", 3))
	{
		printf("AP addObject: %s\n", name);
//		printf("AP addObject: %s, %#x\n", name, object);
	}
#endif
	[super addObject:object];
	return;
}
- (void)dealloc;
{iTM2_DIAGNOSTIC;
	printf("=-=-=-=-=-=-=-=-=-=-  AP dealloc: %#x START", self);
	[super dealloc];
	printf("=-=-=-=-=-=-=-=-=-=-  AP dealloc: %#x END\n", self);
	return;
}
@end
#endif
