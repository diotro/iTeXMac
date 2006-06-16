/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Dec 03 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2NotificationKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSNotificationCenter(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSNotificationCenter(iTeXMac2)
static NSNotificationCenter * _giTeXMac2NotificationCenter = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTeXMac2Center
+(id)iTeXMac2Center;
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
+(id)defaultCenter;
/*"Setters and Getters"*/
-(NSString *)currentStatus;
-(void)setCurrentStatus:(NSString *)argument;
-(NSString *)currentToolTip;
-(void)setCurrentToolTip:(NSString *)argument;
-(NSTimer *)timer;
-(void)setTimer:(NSTimer *)argument;
/*"Main methods"*/
-(void)addObserver:(id)observer;
-(void)postNotificationWithStatus:(NSString *)aStatus;
-(void)postNotificationWithToolTip:(NSString *)aToolTip;
-(void)cleanStatusNotified:(NSNotification *)aNotification;
-(void)cleanToolTipNotified:(NSNotification *)aNotification;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StatusNotificationCenter
/*"Description forthcoming."*/
@implementation iTM2StatusNotificationCenter
static id _giTM2StatusNotificationCenter;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCenter
+(void)initialize;
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
+(id)defaultCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _giTM2StatusNotificationCenter? _giTM2StatusNotificationCenter:
                            (_giTM2StatusNotificationCenter = [[self allocWithZone:[NSApp zone]] init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
-(id)init;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
-(void)dealloc;
/*"Description Forhcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setCurrentStatus:nil];
    [self setCurrentToolTip:nil];
    [self setTimer:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timer
-(NSTimer *)timer;
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
-(void)setTimer:(NSTimer *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSTimer class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSTimer argument expected:%@.",
            __PRETTY_FUNCTION__, argument];
    else
    {
        [_Timer invalidate];
        [_Timer autorelease];
        _Timer = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentStatus
-(NSString *)currentStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_CurrentStatus length]? [[_CurrentStatus copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentStatus:
-(void)setCurrentStatus:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __PRETTY_FUNCTION__, argument];
    else if(_CurrentStatus != argument)
    {
        [_CurrentStatus autorelease];
        _CurrentStatus = [argument copy];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentToolTip
-(NSString *)currentToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 09/20/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_CurrentToolTip length]? [[_CurrentToolTip copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentToolTip:
-(void)setCurrentToolTip:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 09/20/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __PRETTY_FUNCTION__, argument];
    else if(_CurrentToolTip != argument)
    {
        [_CurrentToolTip autorelease];
        _CurrentToolTip = [argument copy];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addObserver:
-(void)addObserver:(id)observer;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus:
-(void)postNotificationWithStatus:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self postNotificationWithStatus:aStatus object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus:object:
-(void)postNotificationWithStatus:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int length = [aStatus length];
    [self setCurrentStatus:(length? aStatus:nil)];
    if(![[self currentToolTip] length])
    {
        [self postNotificationName:iTM2StatusNotificationName
            object: object
                userInfo: [NSDictionary dictionaryWithObject:[self currentStatus] forKey:iTM2SNStatusKey]];
        if(length)
            [self setTimer:[NSTimer scheduledTimerWithTimeInterval:
                                [[NSUserDefaults standardUserDefaults] floatForKey:iTM2StatusTimeOutKey]
                target: self
                    selector: @selector(cleanStatusNotified:)
                        userInfo: nil
                            repeats: NO]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip:
-(void)postNotificationWithToolTip:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self postNotificationWithToolTip:aToolTip object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip:object:
-(void)postNotificationWithToolTip:(NSString *)aToolTip object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int length = [aToolTip length];
    [self setCurrentToolTip:(length? aToolTip:nil)];
    [self postNotificationName:iTM2StatusNotificationName
        object: object
            userInfo: [NSDictionary dictionaryWithObject:[self currentToolTip] forKey:iTM2SNStatusKey]];
    if(length)
        [self setTimer:[NSTimer scheduledTimerWithTimeInterval:
                            [[NSUserDefaults standardUserDefaults] floatForKey:iTM2StatusTimeOutKey]
            target: self
                selector: @selector(cleanToolTipNotified:)
                    userInfo: nil
                        repeats: NO]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanStatusNotified:
-(void)cleanStatusNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setTimer:nil];
    [self postNotificationWithStatus:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanToolTipNotified:
-(void)cleanToolTipNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setTimer:nil];
    [self postNotificationWithToolTip:nil];
    [self postNotificationWithStatus:[self currentStatus]];
    return;
}
@end

@implementation iTM2StatusField
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
-(id)initWithFrame:(NSRect)aFrame;
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
-(id)initWithCoder:(NSCoder *)decoder;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
-(void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  statusNotified:
-(void)statusNotified:(NSNotification *)aNotification;
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
//NSLog(@"statusNotified: %@", [[aNotification userInfo] objectForKey:iTM2SNStatusKey]);
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus:
+(void)postNotificationWithStatus:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus:aStatus];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus:
-(void)postNotificationWithStatus:(NSString *)aStatus;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus:aStatus];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip:
+(void)postNotificationWithToolTip:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip:aToolTip];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip:
-(void)postNotificationWithToolTip:(NSString *)aToolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip:aToolTip];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus:object:
+(void)postNotificationWithStatus:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithStatus:object:
-(void)postNotificationWithStatus:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithStatus:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip:object:
+(void)postNotificationWithToolTip:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip:aStatus object:object];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  postNotificationWithToolTip:object:
-(void)postNotificationWithToolTip:(NSString *)aStatus object:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[iTM2StatusNotificationCenter defaultCenter] postNotificationWithToolTip:aStatus object:object];
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSNotificationCenter(iTM2Status)

