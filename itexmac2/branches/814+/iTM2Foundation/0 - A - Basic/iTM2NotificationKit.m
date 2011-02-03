/*
//
//  @version Subversion: $Id: iTM2NotificationKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Dec 03 2001.
//  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
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

#import "iTM2NotificationKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSNotificationCenter(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSNotificationCenter(iTeXMac2)
static NSNotificationCenter * _giTeXMac2NotificationCenter = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTeXMac2Center
+ (id)iTeXMac2Center;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Sep 26 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!_giTeXMac2NotificationCenter)
        _giTeXMac2NotificationCenter = [[NSNotificationCenter alloc] init];
    return _giTeXMac2NotificationCenter;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSNotification(iTeXMac2)
NSString * const iTM2StatusTimeOutKey = @"iTM2StatusTimeOut";
NSString * const iTM2StatusNotificationName = @"iTM2StatusNotificationName";
NSString * const iTM2SNStatusKey = @"status";

@interface iTM2StatusNotificationCenter : NSNotificationCenter
{
@private
    NSString * _CurrentStatus;
    NSString * _CurrentToolTip;
    NSTimer * _Timer;
}
/*"Class methods"*/
+ (id)defaultCenter;
/*"Setters and Getters"*/
/*"Main methods"*/
- (void)addObserver:(id)observer;
- (void)postNotificationWithStatus4iTM3:(NSString *)aStatus;
- (void)postNotificationWithToolTip4iTM3:(NSString *)aToolTip;
- (void)cleanStatusNotified:(NSNotification *)aNotification;
- (void)cleanToolTipNotified:(NSNotification *)aNotification;
@property (copy) NSString * currentStatus;
@property (copy) NSString * currentToolTip;
@property (retain) NSTimer * timer;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StatusNotificationCenter
/*"Description forthcoming."*/
@implementation iTM2StatusNotificationCenter
static id _giTM2StatusNotificationCenter;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCenter
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithFloat:180],  iTM2StatusTimeOutKey,
            nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCenter
+ (id)defaultCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _giTM2StatusNotificationCenter? _giTM2StatusNotificationCenter:
                            (_giTM2StatusNotificationCenter = [self.alloc init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"The first object inited is the shared one.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_giTM2StatusNotificationCenter)
    {
        if (![self isEqual:_giTM2StatusNotificationCenter])
            self.release;
        return [_giTM2StatusNotificationCenter retain];
    }
    else
    {
//NSLog(@"status notification center has been inited");
        return _giTM2StatusNotificationCenter = [super init];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timer
- (NSTimer *)timer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Timer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTimer:
- (void)setTimer:(NSTimer *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSTimer class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSTimer argument expected:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        [_Timer invalidate];
        [_Timer autorelease];
        _Timer = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addObserver:
- (void)addObserver:(id)observer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    SEL statusNotified = @selector(statusNotified:);
    NSAssert1([observer respondsToSelector:statusNotified], @"%@ must respond to statusNotified:message.", observer);
    [self addObserver:observer selector:statusNotified name:iTM2StatusNotificationName object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus4iTM3:
- (void)postNotificationWithStatus4iTM3:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self postNotificationWithStatus4iTM3:aStatus object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus4iTM3:object:
- (void)postNotificationWithStatus4iTM3:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger length = aStatus.length;
    self.currentStatus=(length? aStatus:@"");
    if (!self.currentToolTip.length)
    {
        [self postNotificationName:iTM2StatusNotificationName
            object: object
                userInfo: [NSDictionary dictionaryWithObject:self.currentStatus forKey:iTM2SNStatusKey]];
        if (length)
            self.timer=[NSTimer scheduledTimerWithTimeInterval:
                                [[NSUserDefaults standardUserDefaults] floatForKey:iTM2StatusTimeOutKey]
                target: self
                    selector: @selector(cleanStatusNotified:)
                        userInfo: nil
                            repeats: NO];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip4iTM3:
- (void)postNotificationWithToolTip4iTM3:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self postNotificationWithToolTip4iTM3:aToolTip object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip4iTM3:object:
- (void)postNotificationWithToolTip4iTM3:(NSString *)aToolTip object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger length = aToolTip.length;
    self.currentToolTip=(length? aToolTip:@"");
    [self postNotificationName:iTM2StatusNotificationName
        object: object
            userInfo: [NSDictionary dictionaryWithObject:self.currentToolTip forKey:iTM2SNStatusKey]];
    if (length)
        self.timer=[NSTimer scheduledTimerWithTimeInterval:
                            [[NSUserDefaults standardUserDefaults] floatForKey:iTM2StatusTimeOutKey]
            target: self
                selector: @selector(cleanToolTipNotified:)
                    userInfo: nil
                        repeats: NO];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanStatusNotified:
- (void)cleanStatusNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.timer=nil;
    [self postNotificationWithStatus4iTM3:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanToolTipNotified:
- (void)cleanToolTipNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.timer=nil;
    [self postNotificationWithToolTip4iTM3:nil];
    [self postNotificationWithStatus4iTM3:self.currentStatus];
    return;
}
@synthesize currentStatus=_CurrentStatus;
@synthesize currentToolTip=_CurrentToolTip;
@end

@implementation iTM2StatusField
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)aFrame;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithFrame:aFrame]))
    {
        [[iTM2StatusNotificationCenter defaultCenter] addObserver:self];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)decoder;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithCoder:decoder]))
    {
        [[iTM2StatusNotificationCenter defaultCenter] addObserver:self];
        [self setStringValue:[[iTM2StatusNotificationCenter defaultCenter] currentStatus]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  statusNotified:
- (void)statusNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id O = [aNotification object];
    if ([O isKindOfClass:[NSWindow class]] && (O != self.window))
        return;
    NS_DURING
NSLog(@"statusNotified: %@", [[aNotification userInfo] objectForKey:iTM2SNStatusKey]);
    [self setStringValue:[[aNotification userInfo] objectForKey:iTM2SNStatusKey]];
    NS_HANDLER
    LOG4iTM3(@"***  EXCEPTION CATCHED: %@", [localException reason]);
    NS_ENDHANDLER
    self.display;
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StatusNotificationCenter

@implementation NSObject(iTM2Status)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus4iTM3:
+ (void)postNotificationWithStatus4iTM3:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus4iTM3:aStatus];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus4iTM3:
- (void)postNotificationWithStatus4iTM3:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus4iTM3:aStatus];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip4iTM3:
+ (void)postNotificationWithToolTip4iTM3:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip4iTM3:aToolTip];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip4iTM3:
- (void)postNotificationWithToolTip4iTM3:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip4iTM3:aToolTip];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus4iTM3:object:
+ (void)postNotificationWithStatus4iTM3:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus4iTM3:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus4iTM3:object:
- (void)postNotificationWithStatus4iTM3:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus4iTM3:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip4iTM3:object:
+ (void)postNotificationWithToolTip4iTM3:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip4iTM3:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip4iTM3:object:
- (void)postNotificationWithToolTip4iTM3:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip4iTM3:aStatus object:object];
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSNotificationCenter(iTM2Status)

