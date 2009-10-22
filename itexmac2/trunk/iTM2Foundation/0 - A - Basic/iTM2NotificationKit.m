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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_giTeXMac2NotificationCenter)
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
- (void)iTM2_postNotificationWithStatus:(NSString *)aStatus;
- (void)iTM2_postNotificationWithToolTip:(NSString *)aToolTip;
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
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithFloat:180],  iTM2StatusTimeOutKey,
            nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCenter
+ (id)defaultCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _giTM2StatusNotificationCenter? _giTM2StatusNotificationCenter:
                            (_giTM2StatusNotificationCenter = [[self alloc] init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"The first object inited is the shared one.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_giTM2StatusNotificationCenter)
    {
        if(![self isEqual:_giTM2StatusNotificationCenter])
            [self release];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Timer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTimer:
- (void)setTimer:(NSTimer *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSTimer class]])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    SEL statusNotified = @selector(statusNotified:);
    NSAssert1([observer respondsToSelector:statusNotified], @"%@ must respond to statusNotified:message.", observer);
    [self addObserver:observer selector:statusNotified name:iTM2StatusNotificationName object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithStatus:
- (void)iTM2_postNotificationWithStatus:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self iTM2_postNotificationWithStatus:aStatus object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithStatus:object:
- (void)iTM2_postNotificationWithStatus:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger length = [aStatus length];
    self.currentStatus=(length? aStatus:@"");
    if(![self.currentToolTip length])
    {
        [self postNotificationName:iTM2StatusNotificationName
            object: object
                userInfo: [NSDictionary dictionaryWithObject:self.currentStatus forKey:iTM2SNStatusKey]];
        if(length)
            self.timer=[NSTimer scheduledTimerWithTimeInterval:
                                [[NSUserDefaults standardUserDefaults] floatForKey:iTM2StatusTimeOutKey]
                target: self
                    selector: @selector(cleanStatusNotified:)
                        userInfo: nil
                            repeats: NO];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithToolTip:
- (void)iTM2_postNotificationWithToolTip:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self iTM2_postNotificationWithToolTip:aToolTip object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithToolTip:object:
- (void)iTM2_postNotificationWithToolTip:(NSString *)aToolTip object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger length = [aToolTip length];
    self.currentToolTip=(length? aToolTip:@"");
    [self postNotificationName:iTM2StatusNotificationName
        object: object
            userInfo: [NSDictionary dictionaryWithObject:self.currentToolTip forKey:iTM2SNStatusKey]];
    if(length)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    self.timer=nil;
    [self iTM2_postNotificationWithStatus:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanToolTipNotified:
- (void)cleanToolTipNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    self.timer=nil;
    [self iTM2_postNotificationWithToolTip:nil];
    [self iTM2_postNotificationWithStatus:self.currentStatus];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:aFrame])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithCoder:decoder])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id O = [aNotification object];
    if([O isKindOfClass:[NSWindow class]] && (O != [self window]))
        return;
    NS_DURING
NSLog(@"statusNotified: %@", [[aNotification userInfo] objectForKey:iTM2SNStatusKey]);
    [self setStringValue:[[aNotification userInfo] objectForKey:iTM2SNStatusKey]];
    NS_HANDLER
    iTM2_LOG(@"***  EXCEPTION CATCHED: %@", [localException reason]);
    NS_ENDHANDLER
    [self display];
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StatusNotificationCenter

@implementation NSObject(iTM2Status)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithStatus:
+ (void)iTM2_postNotificationWithStatus:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithStatus:aStatus];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithStatus:
- (void)iTM2_postNotificationWithStatus:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithStatus:aStatus];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithToolTip:
+ (void)iTM2_postNotificationWithToolTip:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithToolTip:aToolTip];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithToolTip:
- (void)iTM2_postNotificationWithToolTip:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithToolTip:aToolTip];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithStatus:object:
+ (void)iTM2_postNotificationWithStatus:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithStatus:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithStatus:object:
- (void)iTM2_postNotificationWithStatus:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithStatus:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithToolTip:object:
+ (void)iTM2_postNotificationWithToolTip:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithToolTip:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_postNotificationWithToolTip:object:
- (void)iTM2_postNotificationWithToolTip:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] iTM2_postNotificationWithToolTip:aStatus object:object];
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSNotificationCenter(iTM2Status)

