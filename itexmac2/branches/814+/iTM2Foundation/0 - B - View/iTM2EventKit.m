/*
//  list menu controller tutorial
//
//  @version Subversion: $Id: iTM2EventKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "iTM2EventKit.h"
#import "iTM2BundleKit.h"
#import <Carbon/Carbon.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2EventObserver
/*"Description forthcoming."*/
@implementation iTM2EventObserver
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isAlternateKeyDown
+ (BOOL)isAlternateKeyDown;
/*"Description forthcoming."*/
{DIAGNOSTIC4iTM3;
    return [self isKeyDown:34];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isAlternateKeyDown
+ (BOOL)isKeyDown:(char)keyNumber;
/*"Description forthcoming."*/
{DIAGNOSTIC4iTM3;
    long q = keyNumber/32;
    long r = keyNumber % 32;
    //keyNumber = 32 * q + r
    KeyMap theKeys;
    GetKeys ( theKeys );
#if (__LITTLE_ENDIAN__)
   UInt32 keys = CFSwapInt32BigToHost( theKeys[q].bigEndianValue );
#else
   UInt32 keys = theKeys[q];
#endif
    return keys&(1<<r);
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2EventObserver

#import "iTM2NotificationKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

NSString * const iTM2FlagsDidChangeNotification = @"iTM2FlagsDidChangeNotification";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2FlagsChangedResponder  =-=-=-=-=-=-=-=-=-=-=-=-=-

#import "iTM2ResponderKit.h"
#import "iTM2InstallationKit.h"

@interface iTM2FlagsChangedResponder: iTM2AutoInstallResponder
@end

@implementation NSApplication(iTM2EventKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  eventManagementCompleteDidFinishLaunching4iTM3
- (void)eventManagementCompleteDidFinishLaunching4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([NSApp targetForAction:@selector(flagsChanged:)])
	{
		MILESTONE4iTM3((@"iTM2FlagsChangedResponder"),(@"No flags changed responder available"));
	}
    [self postNotificationWithStatus4iTM3:[NSString string]];
    [DNC postNotificationName:NSAppleEventManagerWillProcessFirstEventNotification
            object: nil];// see ND
//END4iTM3;
	return;
}
@end

@implementation iTM2FlagsChangedResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-= flagsChanged:
- (void)flagsChanged:(NSEvent *)theEvent
/*"If there is no key window, the receiver posts a iTM2FlagsChangedNotification with no object nor user info."
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![NSApp keyWindow])
		[INC postNotificationName:iTM2FlagsDidChangeNotification object:nil userInfo:nil];
    [super flagsChanged:theEvent];
//END4iTM3;
	return;
}
@end

#import <objc/objc-class.h>
#import <objc/objc-runtime.h>
#import "iTM2Runtime.h"


@implementation NSResponder(iTM2FlagsChanged)
//=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_flagsChanged:
- (void)SWZ_iTM2_flagsChanged:(NSEvent *)theEvent
/*"The receiver posts a iTM2FlagsChangedNotification with itself as object but no user info.
Beware, some objects will probably receive twice such a notification.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self SWZ_iTM2_flagsChanged:theEvent];
    [INC postNotificationName:iTM2FlagsDidChangeNotification object:self userInfo:nil];
//END4iTM3;
    return;
}
@end

void iTM2EventLoopIdleTimerProc( EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *timer );


static EventLoopIdleTimerUPP iTM2EventLoopIdleTimerUPP = NULL;

@implementation iTM2IdleTimer
+(void)initialize;
{
	if ( !iTM2EventLoopIdleTimerUPP ) {
		[super initialize];
		iTM2EventLoopIdleTimerUPP = NewEventLoopIdleTimerUPP(iTM2EventLoopIdleTimerProc);
	}
	return;
}
- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)inInterval target:(id)target userInfo:(id)userInfo;
{
	if ((self = [super init])) {
		EventLoopRef inEventLoop = GetCurrentEventLoop();
		NSTimeInterval inDelay = [date timeIntervalSinceNow];
		OSStatus status =  InstallEventLoopIdleTimer(
			  inEventLoop,
			  inDelay,
			  inInterval,
			  iTM2EventLoopIdleTimerUPP,//EventLoopIdleTimerUPP   inTimerProc,
			  self,//void *                  inTimerData,
			  &timer);//EventLoopTimerRef *     outTimer);
		if ( status != noErr )
		{
			self.release;
			return nil;
		}
		[info release];
		info = [userInfo retain];
	}
	return self;
}
-(void) finalize
{
	RemoveEventLoopTimer(timer);
	[super finalize];
	return;
}
-(id)target;
{
	return target;
}
-(id)userInfo;
{
	return info;
}
@synthesize timer;
@synthesize info;
@end

@interface iTM2IdleTimer(PRIVATE)
-(id)target;
@end

void iTM2EventLoopIdleTimerProc( EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *timer )
{
	id target = [(iTM2IdleTimer*)timer target];
	switch( inState )
	{
		case kEventLoopIdleTimerStarted:
			if ([target respondsToSelector: @selector(idleTimerStarted:)])
			{
				[target idleTimerStarted:timer];
			}
			return;
		
		case kEventLoopIdleTimerIdling:
			if ([target respondsToSelector: @selector(idleTimerIdling:)])
			{
				[target idleTimerIdling:timer];
			}
			return;

		case kEventLoopIdleTimerStopped:
			if ([target respondsToSelector: @selector(idleTimerStopped:)])
			{
				[target idleTimerStopped:timer];
			}
			return;
	}
}

@implementation iTM2MainInstaller(EventKit)
+ (void)prepareEventKitCompleteInstallation4iTM3;
{
	if ([NSResponder swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_flagsChanged:) error:NULL])
	{
		MILESTONE4iTM3((@"NSResponder(iTM2FlagsChanged)"),(@"****  HUGE ERROR: No swizzling for NSWindow(iTM2FlagsChanged)"));
	}
}
@end

//