/*
//  list menu controller tutorial
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2EventKit.h>
#import <Carbon/Carbon.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2EventObserver
/*"Description forthcoming."*/
@implementation iTM2EventObserver
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isAlternateKeyDown
+ (BOOL)isAlternateKeyDown;
/*"Description forthcoming."*/
{iTM2_DIAGNOSTIC;
    return [self isKeyDown:34];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isAlternateKeyDown
+ (BOOL)isKeyDown:(char)keyNumber;
/*"Description forthcoming."*/
{iTM2_DIAGNOSTIC;
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

#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

NSString * const iTM2FlagsDidChangeNotification = @"iTM2FlagsDidChangeNotification";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2FlagsChangedResponder  =-=-=-=-=-=-=-=-=-=-=-=-=-

#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>

@interface iTM2FlagsChangedResponder: iTM2AutoInstallResponder
@end

@implementation NSApplication(iTM2EventKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2FlagsChangedResponder"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2FlagsChangedResponderDidFinishLaunching
- (void)iTM2FlagsChangedResponderDidFinishLaunching;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([NSApp targetForAction:@selector(flagsChanged:)])
		[iTM2MileStone putMileStoneForKey:@"iTM2FlagsChangedResponder"];
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSApp keyWindow])
		[INC postNotificationName:iTM2FlagsDidChangeNotification object:nil userInfo:nil];
    [super flagsChanged:theEvent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:nil name:nil object:self];
    [super dealloc];
//iTM2_END;
    return;
}
@end

#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

@interface NSWindow_iTeXMac2_FlagsChanged: NSWindow
@end

@implementation NSWindow_iTeXMac2_FlagsChanged
//=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"The receiver posts a iTM2FlagsChangedNotification with no object nor user info."
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSWindow_iTeXMac2_FlagsChanged poseAsClass:[NSWindow class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-= flagsChanged:
- (void)flagsChanged:(NSEvent *)theEvent
/*"The receiver posts a iTM2FlagsChangedNotification with itself as object but no user info.
Beware, some objects will probably receive twice such a notification.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC postNotificationName:iTM2FlagsDidChangeNotification object:self userInfo:nil];
    [super flagsChanged:theEvent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:nil name:nil object:self];
    [super dealloc];
//iTM2_END;
    return;
}
@end
