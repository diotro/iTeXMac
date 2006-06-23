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
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

Class iTM2NamedClassPoseAs(const char * imposterName, const char * originalName)
{
	struct objc_class * imposter;
	imposter = (struct objc_class *)objc_getClass(imposterName);
	struct objc_class * original;
	original = (struct objc_class *)objc_getClass(originalName);
	Class result = class_poseAs(imposter, original);
	if(!result)
	{
		NSLog(@"*** ERROR: cannot pose %s as %s", imposterName, originalName);
	}
	return result;
}

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
	NSEnumerator * E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2Installer class]] objectEnumerator];
	Class C;
	while(C = (Class)[[E nextObject] nonretainedObjectValue])
		if(C != self)
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Auto installation of class %@ START", NSStringFromClass(C));
			}
			NSMethodSignature * signature = [iTM2Installer methodSignatureForSelector:_cmd];
			NSEnumerator * e = [[iTM2RuntimeBrowser realClassSelectorsOfClass:C withSuffix:@"CompleteInstallation" signature:signature inherited:NO] objectEnumerator];
			// Transforming to a zombie...
			((struct objc_class *)C) -> super_class = [iTM2InstallerZombie class];
			SEL selector;
			while(selector = (SEL)[[e nextObject] pointerValue])
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Performing %@", NSStringFromSelector(selector));
				}
				NS_DURING
				[(id)C performSelector:selector withObject:nil];
				NS_HANDLER
				iTM2_LOG(@"***  ERROR: Exception catched while performing %@\n%@", NSStringFromSelector(selector), [localException reason]);
				NS_ENDHANDLER
			}
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Auto installation of class %@ END", NSStringFromClass(C));
			}
		}
//iTM2_END;
    return;
}
@end

// trick to catch the creation of the SUD
// the delayed fix installation is used...

static NSMutableArray * _iTM2_FixInstallationQueue = nil;
static NSMutableArray * _iTM2_CompleteInstallationQueue = nil;

@interface NSApplication_iTM2InstallationKit: NSApplication
@end

@implementation NSApplication_iTM2InstallationKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSApplication_iTM2InstallationKit poseAsClass:[NSApplication class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  finishLaunching
- (void)finishLaunching;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self  completeInstallation];
	[iTM2Installer completeInstallation];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    NSArray * selectors = [iTM2RuntimeBrowser realInstanceSelectorsOfClass:isa withSuffix:@"WillFinishLaunching" signature:sig0 inherited:YES];
    [I setTarget:self];
    NSEnumerator * E = [selectors objectEnumerator];
    SEL action;
    while(action = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:action];
        [I invoke];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing: %@", NSStringFromSelector(action));
        }
    }
	[super finishLaunching];
    selectors = [iTM2RuntimeBrowser realInstanceSelectorsOfClass:isa withSuffix:@"DidFinishLaunching" signature:sig0 inherited:YES];
    E = [selectors objectEnumerator];
    while(action = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:action];
        [I invoke];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing: %@", NSStringFromSelector(action));
        }
    }
	[iTM2MileStone verifyRegisteredMileStones];
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

@implementation NSApplication(_iTM2InstallationKit)
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
	NSMethodSignature * signature = [self methodSignatureForSelector:_cmd];
	NSEnumerator * e = [[iTM2RuntimeBrowser realClassSelectorsOfClass:self withSuffix:@"CompleteInstallation" signature:signature inherited:YES] objectEnumerator];
	SEL selector;
	while(selector = (SEL)[[e nextObject] pointerValue])
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Performing %@", NSStringFromSelector(selector));
		}
		NS_DURING
		[self performSelector:selector withObject:nil];
		NS_HANDLER
		iTM2_LOG(@"***  ERROR: Exception catched while performing %@\n%@", NSStringFromSelector(selector), [localException reason]);
		NS_ENDHANDLER
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Auto installation END");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
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
			forClass: [NSObject class]])
	{
		iTM2_LOG(@"INFO: Delayed fix installation available.");
		if(!_iTM2_FixInstallationQueue)
			_iTM2_FixInstallationQueue = [[NSMutableArray array] retain];
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
            [_iTM2_FixInstallationQueue addObject:[NSValue valueWithNonretainedObject:target]];
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
			NSEnumerator * E = [[[_iTM2_FixInstallationQueue copy] autorelease] objectEnumerator];
			[_iTM2_FixInstallationQueue autorelease];
			_iTM2_FixInstallationQueue = [[NSMutableArray array] retain];
			id O;
			while(O = [[E nextObject] nonretainedObjectValue])
			{
				iTM2_LOG(@"INFO: Fix installation of: %s, %#x", object_getClassName(O), O);
				[O fixInstallation];
			}
		}
		iTM2_LOG(@"INFO: FINISHED.");
	}
    [_iTM2_FixInstallationQueue autorelease];
    _iTM2_FixInstallationQueue = [[NSMutableArray array] retain];
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
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSArray * selectors = [iTM2RuntimeBrowser realClassSelectorsOfClass:self withSuffix:@"FixInstallation" signature:sig0 inherited:YES];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    NSEnumerator * E = [selectors objectEnumerator];
    SEL action;
    while(action = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:action];
        [I invoke];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing: %@", NSStringFromSelector(action));
        }
		[iTM2RuntimeBrowser disableClassMethodSelector:action forClass:self];
    }
	if(iTM2DebugEnabled>99 && ![selectors count])
	{
		iTM2_LOG(@"No need to ...FixInstallation");
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
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSArray * selectors = [iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"FixInstallation" signature:sig0 inherited:YES];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    NSEnumerator * E = [selectors objectEnumerator];
    SEL action;
    while(action = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:action];
        [I invoke];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing: %@", NSStringFromSelector(action));
        }
    }
	if(iTM2DebugEnabled>99 && ![selectors count])
	{
		iTM2_LOG(@"No need to ...FixInstallation");
	}
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
			forClass: [NSObject class]])
	{
		iTM2_LOG(@"INFO: Delayed complete installation available.");
		if(!_iTM2_CompleteInstallationQueue)
			_iTM2_CompleteInstallationQueue = [[NSMutableArray array] retain];
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
            [_iTM2_CompleteInstallationQueue addObject:[NSValue valueWithNonretainedObject:target]];
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
			NSEnumerator * E = [[[_iTM2_CompleteInstallationQueue copy] autorelease] objectEnumerator];
			[_iTM2_CompleteInstallationQueue autorelease];
			_iTM2_CompleteInstallationQueue = [[NSMutableArray array] retain];
			id O;
			while(O = [[E nextObject] nonretainedObjectValue])
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
    [_iTM2_CompleteInstallationQueue autorelease];
    _iTM2_CompleteInstallationQueue = [[NSMutableArray array] retain];
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
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSArray * selectors = [iTM2RuntimeBrowser realClassSelectorsOfClass:self withSuffix:@"CompleteInstallation" signature:sig0 inherited:YES];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    NSEnumerator * E = [selectors objectEnumerator];
    SEL action;
    while(action = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:action];
        [I invoke];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing: %@", NSStringFromSelector(action));
        }
		[iTM2RuntimeBrowser disableClassMethodSelector:action forClass:self];
    }
	if(iTM2DebugEnabled>99 && ![selectors count])
	{
		iTM2_LOG(@"No need to ...CompleteInstallation");
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
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSArray * selectors = [iTM2RuntimeBrowser realInstanceSelectorsOfClass:isa withSuffix:@"CompleteInstallation" signature:sig0 inherited:YES];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    NSEnumerator * E = [selectors objectEnumerator];
    SEL action;
    while(action = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:action];
        [I invoke];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing: %@", NSStringFromSelector(action));
        }
    }
	if(iTM2DebugEnabled>99 && ![selectors count])
	{
		iTM2_LOG(@"No need to ...CompleteInstallation");
	}
//iTM2_END;
    return;
}
@end

