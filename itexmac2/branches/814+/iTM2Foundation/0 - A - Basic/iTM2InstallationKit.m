/*
//
//  @version Subversion: $Id: iTM2InstallationKit.m 798 2009-10-12 19:32:06Z jlaurens $ 
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


#import "iTM2Runtime.h"
#import "iTM2Invocation.h"
#import "iTM2InstallationKit.h"
#import <objc/objc-runtime.h>

#ifndef ___1
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2Application completeInstallation];
	NSPointerArray * refs = [iTM2Runtime subclassReferencesOfClass:[iTM2Installer class]];
	NSUInteger i = refs.count;
	while(i--)
	{
		Class C = [refs pointerAtIndex:i];
		if (C != self)
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"Auto installation of class %@ START", NSStringFromClass(C));
			}
			NSInvocation * I;
			[[NSInvocation getInvocation4iTM3:&I withTarget:C retainArguments:NO] completeInstallation];
			[I invokeWithSelectors4iTM3:[iTM2Runtime realClassSelectorsOfClass:C withSuffix:@"CompleteInstallation4iTM3" signature:[I methodSignature] inherited:NO]];
			object_setClass(C,[iTM2InstallerZombie class]);
		}
	}
	[iTM2Runtime flushCache];
//END4iTM3;
    return;
}
@end

// trick to catch the creation of the SUD
// the delayed fix installation is used...

static NSMutableArray * _iTM2_FixInstallationQueue = nil;
static NSHashTable * _iTM2_CompleteInstallation4iTM3Queue = nil;

static NSMutableDictionary * __iTM2MileStone = nil;

@implementation iTM2MileStone
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
	if (!__iTM2MileStone)
	{
		__iTM2MileStone = [[NSMutableDictionary dictionary] retain];
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  registerMileStone:forKey:
+ (void)registerMileStone:(NSString *)comment forKey:(NSString *)key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	if (key.length && ![__iTM2MileStone objectForKey:key])
		[__iTM2MileStone setObject:comment forKey:key];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  putMileStoneForKey:
+ (void)putMileStoneForKey:(NSString *)key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	if (!key.length)
		return;
	if ([__iTM2MileStone objectForKey:key])
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"%@: properly installed", key);
		}
		[__iTM2MileStone removeObjectForKey:key];
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  verifyRegisteredMileStones
+ (void)verifyRegisteredMileStones;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timedVerifyRegisteredMileStones:) userInfo:nil repeats:NO];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timedVerifyRegisteredMileStones:
+ (void)timedVerifyRegisteredMileStones:(NSTimer *)timer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSEnumerator * E = [__iTM2MileStone keyEnumerator];
	NSString *K;
	while(K = E.nextObject)
	{
		LOG4iTM3(@".......... INSTALLATION ERROR %@: %@", K, [__iTM2MileStone objectForKey:K]);
	}
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
	RELEASE_POOL4iTM3;
	return;
//START4iTM3;
	if ([iTM2Runtime swizzleClassMethodSelector:_cmd
		replacement: @selector(otherFixInstallationOf:)
			forClass: [NSObject class]
				error:NULL])
	{
		LOG4iTM3(@"INFO: Delayed fix installation available.");
		if (!_iTM2_FixInstallationQueue)
			_iTM2_FixInstallationQueue = [NSHashTable hashTableWithWeakObjects];
		[self fixInstallationOf:target];
		return;
	}
	else
	{
		LOG4iTM3(@"***  HUGE PROBLEM: No delayed fix installation, things are broken...");
		exit(213);
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherFixInstallationOf:
+ (void)otherFixInstallationOf:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	if (target)
    {
        if (NSApp)
            [target fixInstallation];
        else
        {
			LOG4iTM3(@"INFO: Will fix installation of: %s, %#x", object_getClassName(target), target);
            [_iTM2_FixInstallationQueue addObject:target];
        }
    }
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixAllInstallations
+ (void)fixAllInstallations;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![SUD boolForKey:@"iTM2NoAutoFixInstallation"])
	{
		LOG4iTM3(@"INFO: STARTED...");
		while(_iTM2_FixInstallationQueue.count)
		{
			NSEnumerator * E = [_iTM2_FixInstallationQueue objectEnumerator];
			_iTM2_FixInstallationQueue = [NSHashTable hashTableWithWeakObjects];
			for(id O in E)
			{
				LOG4iTM3(@"INFO: Fix installation of: %s, %#x", object_getClassName(O), O);
				[O fixInstallation];
			}
		}
		LOG4iTM3(@"INFO: FINISHED.");
	}
    _iTM2_FixInstallationQueue = [NSHashTable hashTableWithWeakObjects];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixInstallation
+ (void)fixInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] fixInstallation];
	NSPointerArray * PA = [iTM2Runtime realClassSelectorsOfClass:self withSuffix:@"FixInstallation4iTM3" signature:[I methodSignature] inherited:YES];
	NSUInteger i = PA.count;
	while(i--)
	{
		SEL selector = (SEL)[PA pointerAtIndex:i];
        [I setSelector:selector];
        [I invoke];
		[iTM2Runtime disableClassMethodSelector:selector forClass:self];
    }
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixInstallation
- (void)fixInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] fixInstallation];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"FixInstallation4iTM3" signature:[I methodSignature] inherited:YES]];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	if ([iTM2Runtime swizzleClassMethodSelector:_cmd
		replacement: @selector(otherCompleteInstallation4iTM3Of:)
			forClass: [NSObject class]
				error:nil])
	{
		LOG4iTM3(@"INFO: Delayed complete installation available.");
		if (!_iTM2_CompleteInstallation4iTM3Queue)
			_iTM2_CompleteInstallation4iTM3Queue = [NSHashTable hashTableWithWeakObjects];
		[self completeInstallationOf:target];
		return;
	}
	else
	{
		LOG4iTM3(@"***  HUGE PROBLEM: No delayed complete installation, things are broken...");
		exit(213);
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherCompleteInstallation4iTM3Of:
+ (void)otherCompleteInstallation4iTM3Of:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	if (target)
    {
        if (NSApp)
            [target completeInstallation];
        else
        {
			LOG4iTM3(@"INFO: Will complete installation of: %s, %#x", object_getClassName(target), target);
            [_iTM2_CompleteInstallation4iTM3Queue addObject:target];
        }
    }
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeAllInstallations
+ (void)completeAllInstallations;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![SUD boolForKey:@"iTM2NoAutoFixInstallation"])
	{
		LOG4iTM3(@"INFO: STARTED...");
		self.fixAllInstallations;
		while(_iTM2_CompleteInstallation4iTM3Queue.count)
		{
			NSEnumerator * E = [_iTM2_CompleteInstallation4iTM3Queue objectEnumerator];
			_iTM2_CompleteInstallation4iTM3Queue = [NSHashTable hashTableWithWeakObjects];
			for(id O in E)
			{
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"Fix installation of: %@", O);
				}
				[O completeInstallation];
			}
			self.fixAllInstallations;
		}
		LOG4iTM3(@"INFO: FINISHED.");
	}
    _iTM2_CompleteInstallation4iTM3Queue = [NSHashTable hashTableWithWeakObjects];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInstallation
+ (void)completeInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] completeInstallation];
	NSPointerArray * PA = [iTM2Runtime realClassSelectorsOfClass:self withSuffix:@"CompleteInstallation4iTM3" signature:[I methodSignature] inherited:YES];
	NSUInteger i = PA.count;
	while(i--)
	{
		SEL selector = (SEL)[PA pointerAtIndex:i];
        [I setSelector:selector];
        [I invoke];
		[iTM2Runtime disableClassMethodSelector:selector forClass:self];
    }
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInstallation
- (void)completeInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] completeInstallation];
	[I invokeWithSelectors4iTM3:[iTM2Runtime realInstanceSelectorsOfClass:self.class withSuffix:@"CompleteInstallation4iTM3" signature:[I methodSignature] inherited:YES]];
//END4iTM3;
    return;
}
@end
@implementation iTM2Application(Runtime)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  completeInstallation
+ (void)completeInstallation;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	static BOOL already = NO;
	if (already)
		return;
	already = YES;
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] completeInstallation];
	[I invokeWithSelectors4iTM3:[iTM2Runtime realClassSelectorsOfClass:self withSuffix:@"CompleteInstallation4iTM3" signature:[I methodSignature] inherited:YES]];
	//END4iTM3;
    return;
}
- (void)finishLaunching;
{
	[iTM2Installer completeInstallation];
	[self  completeInstallation];
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] finishLaunching];
	[I invokeWithSelectors4iTM3:[iTM2Runtime realInstanceSelectorsOfClass:self.class withSuffix:@"CompleteWillFinishLaunching4iTM3" signature:[I methodSignature] inherited:YES]];
	[super finishLaunching];
	[I invokeWithSelectors4iTM3:[iTM2Runtime realInstanceSelectorsOfClass:self.class withSuffix:@"CompleteDidFinishLaunching4iTM3" signature:[I methodSignature] inherited:YES]];
	[iTM2MileStone verifyRegisteredMileStones];
}

@end
#endif