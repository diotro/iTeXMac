/*
//  iTeXMac2.m
//
//  @version Subversion: $Id: iTeXMac2.m 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri May 14 10:44:03 GMT 2004.
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

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>
#import "iTM2Runtime.h"
#import <ExceptionHandling/ExceptionHandling.h>

NSString * const iTM2DebugEnabledKey = @"iTM2DebugEnabled";
NSString * const iTM2CurrentVersionNumberKey = @"iTM2CurrentVersionNumber";
NSString * const iTM2FoundationErrorDomain = @"iTM2 Foundation Error Domain";

NSInteger iTM2DebugEnabled_FLAGS = 0;

void iTM2Beep(void);

void iTM2Beep(void)
{
#if __iTM2_BUG_TRACKING__
#warning *** BUG TRACKING
//NSLog(@"iTM2Beep");
#endif
	NSBeep();
}

NSInteger iTM2DebugEnabled = 0;

@implementation NSApplication(iTMFoundationVersion)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= createDocumentController4iTM3
+ (void)createDocumentController4iTM3;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
Latest Revision: Tue Oct 19 06:55:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentFoundationVersion4iTM3
+ (NSInteger)currentFoundationVersion4iTM3;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return 1;// iTM2 preview 5
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentVersion4iTM3
+ (NSInteger)currentVersion4iTM3;
/*"This is the build number. OLD STUFF
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
    return 56;// iTM2 preview 11, there is a gap
}
@end

#import <ExceptionHandling/NSExceptionHandler.h>

@interface NSResponder(iTM2EventCatcher)
- (BOOL)catchEvent4iTM3:(NSEvent *)event;// see sendEvent: below
@end

@implementation NSResponder(PRIVATE)
- (BOOL)catchEvent4iTM3:(NSEvent *)event;// see sendEvent: below
{
	return NO;
}
@end

//#import "iTM2DocumentControllerKit.h"
static char * iTM2Application_sendApplicationDefinedEvent = nil;
@implementation iTM2Application
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Registers some defaults: initialize iTM2DefaultsController.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
	iTM2DebugEnabled = [SUD integerForKey:iTM2DebugEnabledKey];
	if (iTM2DebugEnabled)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:@"NSScriptingDebugLogLevel"]];
	}
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInteger:0], iTM2CurrentVersionNumberKey,
                                nil]];
	self.createDocumentController4iTM3;
	const char * name = "sendApplicationDefinedEventOfSubtypeXX:";
	iTM2Application_sendApplicationDefinedEvent = (char *)NSAllocateCollectable(strlen(name)+1, 0);
	strncpy(iTM2Application_sendApplicationDefinedEvent,name,strlen(name));
	iTM2Application_sendApplicationDefinedEvent[strlen(name)+1]='\0';
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= exceptionHandlerCompleteDidFinishLaunching4iTM3
- (void)exceptionHandlerCompleteDidFinishLaunching4iTM3;
/*"Install the event handler.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 2.0
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSExceptionHandler *handler = [NSExceptionHandler defaultExceptionHandler];
	[handler setExceptionHandlingMask:NSLogAndHandleEveryExceptionMask];
	[handler setDelegate: self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSZombieEnabledCompleteDidFinishLaunching4iTM3
- (void)NSZombieEnabledCompleteDidFinishLaunching4iTM3;
/*"Install the event handler.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 2.0
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		NSLog(@"#warning YOUR ATTENTION PLEASE: NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
//END4iTM3;
    return;
}
- (BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldLogException:(NSException *)exception mask:(NSUInteger)aMask;
// mask is NSLog<exception type>Mask, exception's userInfo has stack trace for key NSStackTraceKey
{
	LOG4iTM3(@"An exception was raised:%@",exception);
    NSLog(@"Please report the following call stack symbols as BUG:");
    for (NSString *symbol in exception.callStackSymbols) {
        NSLog(@"%@",symbol);
    }
    NSLog(@"End of report.");
	if (iTM2DebugEnabled
	/*The next awful patch ignores some execptions sent by the instanceMethodForSelector */
            && ![[exception description] hasPrefix:@"NSGetSizeAndAlignment"]) {
		[self presentError:
            [NSError errorWithDomain:@"iTM2Exception" code:-1 userInfo:
                [NSDictionary dictionaryWithObject:[exception description] forKey:NSLocalizedDescriptionKey]]];
	}
	return YES;
}
- (BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldHandleException:(NSException *)exception mask:(NSUInteger)aMask;
// mask is NSHandle<exception type>Mask, exception's userInfo has stack trace for key NSStackTraceKey
{
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sendEvent:
-(void)sendEvent:(NSEvent*)event;
/*"Catches application defined events.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 2.0
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.keyWindow.firstResponder catchEvent4iTM3:event])
	{
		// this is used by the key bindings pref pane (text field to enter the key bindings)
		return;
	}
	else if ([event type] == NSApplicationDefined)
	{
		if (iTM2Application_sendApplicationDefinedEvent)
		{
			short subtype = [event subtype];
			strncpy(iTM2Application_sendApplicationDefinedEvent+strlen("sendApplicationDefinedEventOfSubtype"),(const char*)&subtype,2);
			SEL action = sel_getUid(iTM2Application_sendApplicationDefinedEvent);
			LOG4iTM3(@"CATCHED event:%s",iTM2Application_sendApplicationDefinedEvent);
			if (![self tryToPerform:action with:event])
			{
				[super sendEvent:event];
			}
			strncpy(iTM2Application_sendApplicationDefinedEvent+strlen("sendApplicationDefinedEventOfSubtype"),"__",2);
			LOG4iTM3(@"END:%s",iTM2Application_sendApplicationDefinedEvent);
			return;
		}
	}
	[super sendEvent:event];
//END4iTM3;
	return;
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  FIXING MAC OSX BUGS
/*
** If we do not override performActionForItemAtIndex:, some messages are not sent.
** More precisely, the inspector menu items won't see their message sent if they have a lower level.
** For example, if the current project window is the document window, I can switch to the terminal window and both default and advanced settings window.
** But once I have reached one of the settings window I can't switch any longer to a settings window, even through another inspector...
** It appears that the toggleInspector: message is sent once and no more, only for submenu items!
*/
#warning IS IT STILL A BUG
#if 0
static id _iTM2_DEBUG_LastTarget = nil;
static id _iTM2_DEBUG_LastSender = nil;
static SEL _iTM2_DEBUG_LastAction = NULL;

@implementation NSMenu(iTM2DEBUG)
+ (void)load;
{
	INIT_POOL4iTM3;
	iTM2RedirectNSLogOutput();
	if ([SUD boolForKey:@"iTM2PatchPerformActionForItemAtIndex"])
	{
		[NSMenu swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2DEBUG_performActionForItemAtIndex:) error:NULL];
		[NSApplication swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2DEBUG_sendAction:to:from:) error:NULL];
	}
	RELEASE_POOL4iTM3;
	return;
}
- (void)SWZ_iTM2DEBUG_performActionForItemAtIndex:(NSInteger)index;
{
	_iTM2_DEBUG_LastAction = NULL;
	_iTM2_DEBUG_LastTarget = nil;
	_iTM2_DEBUG_LastSender = nil;
	NSMenuItem * MI = [[[self itemAtIndex:index] retain] autorelease];
	[self SWZ_iTM2DEBUG_performActionForItemAtIndex:(NSInteger)index];
	if (MI.action == _iTM2_DEBUG_LastAction)
		return;
	LOG4iTM3(@"....  WARNING: This is fix of Tiger bug, the action would not be performed otherwise, but is it really safe?");
	[NSApp sendAction:MI.action to:MI.target from:MI];
	return;
}
@end

@implementation NSApplication(iTM2DEBUG)
- (BOOL)SWZ_iTM2DEBUG_sendAction:(SEL)theAction to:(id)theTarget from:(id)sender;
{
if (_iTM2_DEBUG_LastAction == nil)
{
	_iTM2_DEBUG_LastAction = theAction;
	_iTM2_DEBUG_LastTarget = theTarget;
	_iTM2_DEBUG_LastSender = sender;
}
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"sender: %@, target: %@, action: %@", sender, theTarget, NSStringFromSelector(theAction));
	}
	if ([self SWZ_iTM2DEBUG_sendAction:(SEL)theAction to:(id)theTarget from:(id)sender])
		return YES;
	else
		return NO;
}
@end
#endif

@implementation NSPointerArray(iTeXMac2)
- (void) addPointerIfAbsent4iTM3:(void *)pointer;
{
	NSUInteger i = self.count;
	while(i--)
		if ([self pointerAtIndex:i] == pointer)
			return;
	[self addPointer:pointer];
}
@end

@implementation NSNumber(iTeXMac2)
- (CGFloat) CGFloatValue4iTM3;
{
#if CGFLOAT_IS_DOUBLE
    return self.doubleValue;
#else
    return self.floatValue;
#endif
}
- (NSNumber *) initWithCGFloat4iTM3:(CGFloat)value;
{
#if CGFLOAT_IS_DOUBLE
    return [self initWithDouble:(double)value];
#else
    return [self initWithFloat:(CGFloat)value];
#endif
}
+ (NSNumber *) numberWithCGFloat4iTM3:(CGFloat)value;
{
#if CGFLOAT_IS_DOUBLE
    return [self numberWithDouble:(double)value];
#else
    return [self numberWithFloat:(CGFloat)value];
#endif
}
@end

NSRange iTM3UnionRange(NSRange range1, NSRange range2)
{
    NSRange r;
    if ((r.location = iTM3MaxRange(range1))>(r.length = iTM3MaxRange(range2))) r.length = r.location;
    r.location = range1.location<range2.location?range1.location:range2.location;
    r.length -= r.location;
    return r;
}

NSRange iTM3IntersectionRange(NSRange range1, NSRange range2)
{
    NSRange r;
    if ((r.location = iTM3MaxRange(range1))<(r.length = iTM3MaxRange(range2))) r.length = r.location;
    r.location = range1.location>range2.location?range1.location:range2.location;
    if (r.length >= r.location) {// Do not change this! [0 10] \cap [11 20] = [11 0]
        r.length -= r.location;
    } else {
        r.location = NSNotFound;// Do not change this! [0 10] \cap [12 20] = [NSNotFound 0]
        r.length = 0;
    }
    return r;
}

NSRange iTM3ProjectionRange(NSRange destinationRange, NSRange range)
{
    NSUInteger maxDestinationRange = iTM3MaxRange(destinationRange);
    NSUInteger maxRange = iTM3MaxRange(range);
    //  compute the min of the max ranges
    if(maxDestinationRange<=range.location) {
        return NSMakeRange(maxDestinationRange,0);
    } else if(maxRange<=destinationRange.location){
        return NSMakeRange(destinationRange.location,0);
    } else if (/*maxDestinationRange>*/range.location>=destinationRange.location) {
        if(maxDestinationRange<=maxRange) {
            return NSMakeRange(range.location,maxDestinationRange-range.location);
        } else /* if (maxDestinationRange>maxRange>=range.location>=destinationRange.location) */{
            return range;
        }
    } else if (maxDestinationRange >= maxRange/*>destinationRange.location>range.location*/) {
        return NSMakeRange(destinationRange.location,maxRange-destinationRange.location);
    } else /*if (maxRange>maxDestinationRange>=destinationRange.location>range.location) */ {
        return destinationRange;
    }
}

NSRange iTM3ShiftRange(NSRange range, NSInteger off7) {
    if (off7 < 0) {
        off7 *= -1;
        if (range.location >= off7) {
            range.location -= off7;
        } else {
            range.location = 0;
        }
    } else if (range.location < NSUIntegerMax - off7) {
        range.location += off7;
        if (range.length > NSUIntegerMax - range.location) {
            range.length = NSUIntegerMax - range.location;
        }
    } else {
        range.location = NSUIntegerMax;
        range.length = 0;
    }
    return range;
}

NSRange iTM3ScaleRange(NSRange range, NSInteger delta) {
    if (delta < 0) {
        delta *= -1;
        if (delta < range.length) {
            range.length -= delta;
        } else {
            range.length = 0;
        }
    } else if (range.length < NSUIntegerMax - delta) {
        range.length += delta;
    } else {
        range.length = NSUIntegerMax - range.location;
    }
    if (range.location > NSUIntegerMax - range.length) {
        range.length = NSUIntegerMax - range.location;
    }
    return range;
}


