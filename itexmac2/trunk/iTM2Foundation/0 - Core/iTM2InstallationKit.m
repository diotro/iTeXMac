/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 10 22:45:25 GMT 2004.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2Invocation.h>
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@interface iTM2InstallerZombie: NSObject
@end
@implementation iTM2InstallerZombie
@end

@implementation iTM2MainInstaller
@end

@implementation iTM2Installer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInstallation
+ (void)completeInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2RuntimeBrowser cleanCache];
	[iTM2Application completeInstallation];
	NSPointerArray * refs = [iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2Installer class]];
	NSUInteger i = [refs count];
	while(i--)
	{
		Class C = [refs pointerAtIndex:i];
		if(C != self)
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Auto installation of class %@ START", NSStringFromClass(C));
			}
			NSInvocation * I;
			[[NSInvocation iTM2_getInvocation:&I withTarget:C retainArguments:NO] completeInstallation];
			[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser realClassSelectorsOfClass:C withSuffix:@"CompleteInstallation" signature:[I methodSignature] inherited:NO]];
			C->isa=[iTM2InstallerZombie class];
		}
	}
//iTM2_END;
    return;
}
@end

// trick to catch the creation of the SUD
// the delayed fix installation is used...

static NSMutableArray * _iTM2_FixInstallationQueue = nil;
static NSHashTable * _iTM2_CompleteInstallationQueue = nil;

@interface NSApplication_iTM2InstallationKit: NSApplication
@end

@implementation NSApplication(iTM2Installation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  completeInstallation
+ (void)completeInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	static BOOL already = NO;
	if(already)
		return;
	already = YES;
	NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] completeInstallation];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser realClassSelectorsOfClass:self withSuffix:@"CompleteInstallation" signature:[I methodSignature] inherited:YES]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSApplication iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Install_finishLaunching)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Install_finishLaunching
- (void)SWZ_iTM2Install_finishLaunching;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self  completeInstallation];
	[iTM2Installer completeInstallation];
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] SWZ_iTM2Install_finishLaunching];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser realInstanceSelectorsOfClass:[self class] withSuffix:@"WillFinishLaunching" signature:[I methodSignature] inherited:YES]];
	[self SWZ_iTM2Install_finishLaunching];// inherited
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] SWZ_iTM2Install_finishLaunching];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser realInstanceSelectorsOfClass:[self class] withSuffix:@"DidFinishLaunching" signature:[I methodSignature] inherited:YES]];
	[iTM2MileStone verifyRegisteredMileStones];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_applicationWillTerminateNotificatied:
- (void)iTM2_applicationWillTerminateNotificatied:(NSNotification *)theNotification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
@end

static NSMutableDictionary * __iTM2MileStone = nil;

@implementation iTM2MileStone
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
	if(!__iTM2MileStone)
	{
		__iTM2MileStone = [[NSMutableDictionary dictionary] retain];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  registerMileStone:forKey:
+ (void)registerMileStone:(NSString *)comment forKey:(NSString *)key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if([key length] && ![__iTM2MileStone objectForKey:key])
		[__iTM2MileStone setObject:comment forKey:key];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  putMileStoneForKey:
+ (void)putMileStoneForKey:(NSString *)key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(![key length])
		return;
	if([__iTM2MileStone objectForKey:key])
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"%@: properly installed", key);
		}
		[__iTM2MileStone removeObjectForKey:key];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  verifyRegisteredMileStones
+ (void)verifyRegisteredMileStones;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timedVerifyRegisteredMileStones:) userInfo:nil repeats:NO];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timedVerifyRegisteredMileStones:
+ (void)timedVerifyRegisteredMileStones:(NSTimer *)timer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [__iTM2MileStone keyEnumerator];
	NSString *K;
	while(K = [E nextObject])
	{
		iTM2_LOG(@".......... INSTALLATION ERROR %@: %@", K, [__iTM2MileStone objectForKey:K]);
	}
//iTM2_END;
    return;
}
@end

@implementation NSObject(iTM2InstallationKit)
#pragma mark =-=-=-=-=-  FIX INSTALLATIION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixInstallationOf:
+ (void)fixInstallationOf:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2_RELEASE_POOL;
	return;
//iTM2_START;
	if([iTM2RuntimeBrowser swizzleClassMethodSelector:_cmd
		replacement: @selector(otherFixInstallationOf:)
			forClass: [NSObject class]
				error:NULL])
	{
		iTM2_LOG(@"INFO: Delayed fix installation available.");
		if(!_iTM2_FixInstallationQueue)
			_iTM2_FixInstallationQueue = [NSHashTable hashTableWithWeakObjects];
		[self fixInstallationOf:target];
		return;
	}
	else
	{
		iTM2_LOG(@"***  HUGE PROBLEM: No delayed fix installation, things are broken...");
		exit(213);
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherFixInstallationOf:
+ (void)otherFixInstallationOf:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(target)
    {
        if(NSApp)
            [target fixInstallation];
        else
        {
			iTM2_LOG(@"INFO: Will fix installation of: %s, %#x", object_getClassName(target), target);
            [_iTM2_FixInstallationQueue addObject:target];
        }
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixAllInstallations
+ (void)fixAllInstallations;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![SUD boolForKey:@"iTM2NoAutoFixInstallation"])
	{
		iTM2_LOG(@"INFO: STARTED...");
		while([_iTM2_FixInstallationQueue count])
		{
			NSEnumerator * E = [_iTM2_FixInstallationQueue objectEnumerator];
			_iTM2_FixInstallationQueue = [NSHashTable hashTableWithWeakObjects];
			for(id O in E)
			{
				iTM2_LOG(@"INFO: Fix installation of: %s, %#x", object_getClassName(O), O);
				[O fixInstallation];
			}
		}
		iTM2_LOG(@"INFO: FINISHED.");
	}
    _iTM2_FixInstallationQueue = [NSHashTable hashTableWithWeakObjects];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixInstallation
+ (void)fixInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] fixInstallation];
	NSPointerArray * PA = [iTM2RuntimeBrowser realClassSelectorsOfClass:self withSuffix:@"FixInstallation" signature:[I methodSignature] inherited:YES];
	NSUInteger i = [PA count];
	while(i--)
	{
		SEL selector = (SEL)[PA pointerAtIndex:i];
        [I setSelector:selector];
        [I invoke];
		[iTM2RuntimeBrowser disableClassMethodSelector:selector forClass:self];
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixInstallation
- (void)fixInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] fixInstallation];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"FixInstallation" signature:[I methodSignature] inherited:YES]];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  COMPLETE INSTALLATIION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInstallationOf:
+ (void)completeInstallationOf:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if([iTM2RuntimeBrowser swizzleClassMethodSelector:_cmd
		replacement: @selector(otherCompleteInstallationOf:)
			forClass: [NSObject class]
				error:nil])
	{
		iTM2_LOG(@"INFO: Delayed complete installation available.");
		if(!_iTM2_CompleteInstallationQueue)
			_iTM2_CompleteInstallationQueue = [NSHashTable hashTableWithWeakObjects];
		[self completeInstallationOf:target];
		return;
	}
	else
	{
		iTM2_LOG(@"***  HUGE PROBLEM: No delayed complete installation, things are broken...");
		exit(213);
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherCompleteInstallationOf:
+ (void)otherCompleteInstallationOf:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(target)
    {
        if(NSApp)
            [target completeInstallation];
        else
        {
			iTM2_LOG(@"INFO: Will complete installation of: %s, %#x", object_getClassName(target), target);
            [_iTM2_CompleteInstallationQueue addObject:target];
        }
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeAllInstallations
+ (void)completeAllInstallations;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![SUD boolForKey:@"iTM2NoAutoFixInstallation"])
	{
		iTM2_LOG(@"INFO: STARTED...");
		[self fixAllInstallations];
		while([_iTM2_CompleteInstallationQueue count])
		{
			NSEnumerator * E = [_iTM2_CompleteInstallationQueue objectEnumerator];
			_iTM2_CompleteInstallationQueue = [NSHashTable hashTableWithWeakObjects];
			for(id O in E)
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Fix installation of: %@", O);
				}
				[O completeInstallation];
			}
			[self fixAllInstallations];
		}
		iTM2_LOG(@"INFO: FINISHED.");
	}
    _iTM2_CompleteInstallationQueue = [NSHashTable hashTableWithWeakObjects];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInstallation
+ (void)completeInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] completeInstallation];
	NSPointerArray * PA = [iTM2RuntimeBrowser realClassSelectorsOfClass:self withSuffix:@"CompleteInstallation" signature:[I methodSignature] inherited:YES];
	NSUInteger i = [PA count];
	while(i--)
	{
		SEL selector = (SEL)[PA pointerAtIndex:i];
        [I setSelector:selector];
        [I invoke];
		[iTM2RuntimeBrowser disableClassMethodSelector:selector forClass:self];
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInstallation
- (void)completeInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] completeInstallation];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser realInstanceSelectorsOfClass:isa withSuffix:@"CompleteInstallation" signature:[I methodSignature] inherited:YES]];
//iTM2_END;
    return;
}
@end
