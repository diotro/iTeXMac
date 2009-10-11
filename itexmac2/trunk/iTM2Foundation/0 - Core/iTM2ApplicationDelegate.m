/*
//
//  @version Subversion: $Id$ 
//
//  Created by dirk on Tue Jan 23 2001.
//  Modified by jlaurens AT users DOT sourceforge DOT net on Tue Jun 26 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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
//
//  Version history: (format "- date:contribution(contributor)") 
//  original method by dirk Holmes
//  jlaurens AT users DOT sourceforge DOT net (07/12/2001):
//    -applicationWillFinishLaunching: modified
//    -applicationOpenUntitledFile: added
//  To Do List: (format "- proposition(percentage actually done)")
*/

//
#import <iTM2Foundation/iTM2ApplicationDelegate.h>
#import <iTM2Foundation/iTM2DocumentControllerKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2Invocation.h>

NSString * const iTM2MakeEmptyDocumentKey = @"iTM2MakeEmptyDocument";

/*" This class is registered as the delegate of the iTeXMac2 NSApplication object. We do various stuff here, e.g. registering factory defaults, etc.
"*/

#include <iTM2Foundation/iTM2RuntimeBrowser.h>
#include <iTM2Foundation/iTM2PathUtilities.h>

@interface NSDocumentController(iTM2ApplicationDelegate)
- (id)prepareOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL;
@end
@implementation iTM2ApplicationDelegate
#ifndef HUNTING
#warning <<<<  HUNTING
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
                    [NSNumber numberWithBool:NO], iTM2MakeEmptyDocumentKey,
                                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
#warning DEBUGGGGGGGGGG: NO APPLICATION DOCK MENU YET
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applicationDockMenu:
- (NSMenu *)applicationDockMenu:(id)sender;
/*"Lazy initializer and message.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List: Nothing at first glance
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setApplicationDockMenu:
- (void)setApplicationDockMenu:(NSMenu *)argument;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List: Nothing at first glance
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![_ADM isEqual:argument])
    {
        if(argument && ![argument isKindOfClass:[NSMenu class]])
            [NSException raise:NSInvalidArgumentException format:@"-[%@ %@] NSMenu argument expected:%@.",
                [self class], NSStringFromSelector(_cmd), argument];
        else
        {
            [_ADM release];
            _ADM = [argument retain];
        }
    }
    return;
}
#warning =-=-=-=-=-=-=-=-=-=-  DELEGATE METHODS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applicationOpenUntitledFile:
- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
I really don't know why but this simple method could replace the previous one. Nevertheless, I prefer what I can understand...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ![SUD boolForKey:iTM2MakeEmptyDocumentKey];
}
#warning >>>>  HUNTING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= application:openFile:
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename;
/*"Updates the templates and macros menus.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
To Do: problem when there is no UI.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SDC respondsToSelector:@selector(prepareOpenDocumentWithContentsOfURL:)])
	{
		NSURL * absoluteURL = [[NSURL fileURLWithPath:filename] iTM2_normalizedURL];
		[SDC prepareOpenDocumentWithContentsOfURL:absoluteURL];
	}
//iTM2_END;
    return NO;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applicationShouldTerminate:
- (NSApplicationTerminateReply)applicationShouldTerminate:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSApplicationTerminateReply reply;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] applicationShouldTerminate:sender];
    NSHashEnumerator HE = NSEnumerateHashTable([iTM2RuntimeBrowser realInstanceSelectorsOfClass:isa withSuffix:@"ApplicationShouldTerminate:" signature:[I methodSignature] inherited:YES]);
	SEL selector;
	while(selector = (SEL)NSNextHashEnumeratorItem(&HE))
	{
        [I setSelector:selector];
        [I invoke];
		[I getReturnValue:&reply];
		if((reply == NSTerminateCancel)
			||(reply == NSTerminateLater))
		{
			return reply;
		}
    }
//iTM2_END;
    return NSTerminateNow;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applicationWillTerminate:
- (void)applicationWillTerminate:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] applicationWillTerminate:notification];
    [I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser realInstanceSelectorsOfClass:isa withSuffix:@"ApplicationWillTerminate:" signature:[I methodSignature] inherited:YES]];
//iTM2_END;
    return;
}
@synthesize _ADM;
@end

