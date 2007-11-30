/*
//  iTeXMac2.m
//
//  @version Subversion: $Id$ 
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
#import <iTM2Foundation/iTM2BundleKit.h>

NSString * const iTM2DebugEnabledKey = @"iTM2DebugEnabled";
NSString * const iTM2CurrentVersionNumberKey = @"iTM2CurrentVersionNumber";
NSString * const iTM2FoundationErrorDomain = @"iTM2 Foundation Error Domain";

int iTM2DebugEnabled_FLAGS = 0;

BOOL iTM2IsClassObject(id O)
{
#if __iTM2_BUG_TRACKING__
#warning *** BUG TRACKING
//NSLog(@"iTM2IsClassObject");
#endif
	struct objc_class * C;
	C = (struct objc_class *)O;
    return strcmp(object_getClassName(C), object_getClassName(C->isa)) != 0;
}

/*
truc = [NSObject self];
object->isa==truc->isa && truc != object
*/

void iTM2Beep(void);

void iTM2Beep(void)
{
#if __iTM2_BUG_TRACKING__
#warning *** BUG TRACKING
//NSLog(@"iTM2Beep");
#endif
	NSBeep();
}

#if 0
void iTM2_LOG(NSString *fmt, ...)
{iTM2_DIAGNOSTIC;
    va_list vl;
    va_start(vl, fmt);
    NSLog(@"%s %#x", __PRETTY_FUNCTION__, self);
    NSLogv(fmt, vl);
    va_end(vl);
}
#endif

#import <ExceptionHandling/NSExceptionHandler.h>

@interface NSResponder(iTM2EventCatcher)
- (BOOL)iTM2_catchEvent:(NSEvent *)event;// see sendEvent: below
@end

@implementation NSResponder(PRIVATE)
- (BOOL)iTM2_catchEvent:(NSEvent *)event;// see sendEvent: below
{
	return NO;
}
@end

//#import <iTM2Foundation/iTM2DocumentControllerKit.h>
static char * iTM2Application_sendApplicationDefinedEvent = nil;
@implementation iTM2Application
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Registers some defaults: initialize iTM2DefaultsController.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:0], iTM2CurrentVersionNumberKey,
                                nil]];
	Class C = NSClassFromString(@"iTM2DocumentController");// trick to avoid file dependency
	id sdc = [[[C alloc] init] autorelease];
	NSAssert(sdc==SDC,@"*** BUG: the document controller is not what is expected");// creates the document controller
	const char * name = "sendApplicationDefinedEventOfSubtypeXX:";
	iTM2Application_sendApplicationDefinedEvent = (char *)NSZoneMalloc(NSDefaultMallocZone(),strlen(name)+1);
	strncpy(iTM2Application_sendApplicationDefinedEvent,name,strlen(name));
	iTM2Application_sendApplicationDefinedEvent[strlen(name)+1]='\0';
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= exceptionHandlerDidFinishLaunching
- (void)exceptionHandlerDidFinishLaunching;
/*"Install the event handler.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSExceptionHandler *handler = [NSExceptionHandler defaultExceptionHandler];
	[handler setExceptionHandlingMask:NSLogAndHandleEveryExceptionMask];
	[handler setDelegate: self];
//iTM2_END;
    return;
}
- (BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldLogException:(NSException *)exception mask:(unsigned int)aMask;
// mask is NSLog<exception type>Mask, exception's userInfo has stack trace for key NSStackTraceKey
{
	NSDictionary * userInfo = [exception userInfo];
	NSArray * stackTrace = [userInfo objectForKey:NSStackTraceKey];
	iTM2_LOG(@"\nStack Trace:%@",stackTrace);
#if 0
// smorr AT indev DOT ca (Debugging an ignored exception on cocoa-dev)
NSLog(@"Error: %@",exception);
fprintf(stderr, "------ STACK TRACE ------\n");
id trace;
if (trace = [[exception userInfo] objectForKey:NSStackTraceKey])
{
NSString* str = [NSString stringWithFormat:@"/usr/bin/atos -p %d %@ | tail -n +4 | c++filt | cat -n", getpid(), trace];
FILE* fp;
if(fp = popen([str UTF8String], "r"))
{
unsigned char resBuf[512];
size_t len;
while( len = fread(resBuf, 1, sizeof(resBuf), fp))
fwrite(resBuf, 1, len, stderr);
pclose(fp);
}
}
fprintf(stderr, "-------------------------\n");

	NSLog(@"Error: %@",exception);
	fprintf(stderr, "------ STACK TRACE ------\n");	
	id trace;
	if (trace = [[exception userInfo] objectForKey:NSStackTraceKey])
	{
		NSString* str = [NSString stringWithFormat:@"/usr/bin/atos -p %d %@ | tail -n +4 | c++filt | cat -n", getpid(), trace];
		FILE* fp;
		if(fp = popen([str UTF8String], "r"))
		{
			unsigned char resBuf[512];
			size_t len;
			while( len = fread(resBuf, 1, sizeof(resBuf), fp))
				fwrite(resBuf, 1, len, stderr);
			pclose(fp);
		}
	}
	fprintf(stderr, "-------------------------\n");
#endif
	return YES;
}
- (BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldHandleException:(NSException *)exception mask:(unsigned int)aMask;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[[self keyWindow] firstResponder] iTM2_catchEvent:event])
	{
		// this is used by the key bindings pref pane (text field to enter the key bindings)
		return;
	}
	else if([event type] == NSApplicationDefined)
	{
		if(iTM2Application_sendApplicationDefinedEvent)
		{
			int subtype = [event subtype];
			strncpy(iTM2Application_sendApplicationDefinedEvent+strlen("sendApplicationDefinedEventOfSubtype"),(const char*)&subtype,2);
			SEL action = sel_getUid(iTM2Application_sendApplicationDefinedEvent);
			iTM2_LOG(@"CATCHED event:%s",iTM2Application_sendApplicationDefinedEvent);
			if(![self tryToPerform:action with:event])
			{
				[super sendEvent:event];
			}
			strncpy(iTM2Application_sendApplicationDefinedEvent+strlen("sendApplicationDefinedEventOfSubtype"),"__",2);
			iTM2_LOG(@"END:%s",iTM2Application_sendApplicationDefinedEvent);
			return;
		}
	}
	[super sendEvent:event];
//iTM2_END;
	return;
}
@end

int iTM2DebugEnabled;

@implementation NSApplication(iTMFoundationVersion)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	iTM2DebugEnabled = [SUD integerForKey:iTM2DebugEnabledKey];
	if(iTM2DebugEnabled)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"NSScriptingDebugLogLevel"]];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentFoundationVersion
+ (int)currentFoundationVersion;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return 1;// iTM2 preview 5
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentVersion
+ (int)currentVersion;
/*"This is the build number. OLD STUFF
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
    return 56;// iTM2 preview 11, there is a gap
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
static id _iTM2_DEBUG_LastTarget = nil;
static id _iTM2_DEBUG_LastSender = nil;
static SEL _iTM2_DEBUG_LastAction = NULL;

@interface NSMenu_iTM2DEBUG: NSMenu
@end
@interface NSApplication_iTM2DEBUG: NSApplication
@end
@implementation NSMenu_iTM2DEBUG
+ (void)load;
{
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
	if([SUD boolForKey:@"iTM2PatchPerformActionForItemAtIndex"])
	{
		[self poseAsClass:[NSMenu class]];
		[NSApplication_iTM2DEBUG poseAsClass:[NSApplication class]];
	}
	iTM2_RELEASE_POOL;
	return;
}
- (void)performActionForItemAtIndex:(int)index;
{
	_iTM2_DEBUG_LastAction = NULL;
	_iTM2_DEBUG_LastTarget = nil;
	_iTM2_DEBUG_LastSender = nil;
	NSMenuItem * MI = [[[self itemAtIndex:index] retain] autorelease];
	[super performActionForItemAtIndex:(int)index];
	if([MI action] == _iTM2_DEBUG_LastAction)
		return;
	iTM2_LOG(@"....  WARNING: This is fix of Tiger bug, the action would not be performed otherwise, but is it really safe?");
	[NSApp sendAction:[MI action] to:[MI target] from:MI];
	return;
}
@end
@implementation NSApplication_iTM2DEBUG
- (BOOL)sendAction:(SEL)theAction to:(id)theTarget from:(id)sender;
{
if(_iTM2_DEBUG_LastAction == nil)
{
	_iTM2_DEBUG_LastAction = theAction;
	_iTM2_DEBUG_LastTarget = theTarget;
	_iTM2_DEBUG_LastSender = sender;
}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"sender: %@, target: %@, action: %@", sender, theTarget, NSStringFromSelector(theAction));
	}
	if([super sendAction:(SEL)theAction to:(id)theTarget from:(id)sender])
		return YES;
	else
		return NO;
}
@end

