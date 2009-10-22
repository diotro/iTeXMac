/*
//
//  @version Subversion: $Id: iTM2WindowKit.m 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jul 12 2001.
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
//
//  Version history:
//  * initial content on Thu Jul 12 2001

*/

#import "iTM2WindowKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2ContextKit.h"
#import "iTM2BundleKit.h"

NSString * const iTM2FrameSavedWindowKey = @"Saved";
NSString * const iTM2FrameFixedWindowKey = @"Fixed";
NSString * const iTM2FrameCurrentWindowKey = @"Current";
NSString * const iTM2AutosaveModeKeySuffix = @"Autosave Mode";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindow (iTeXMac2) 
/*"It registers in the default database the position of the window on screen. The volatile registration domain is used. This is useful when the user wants new windows to open at the same position of the current one. Different kinds of windows are dealt with a programmatic identifying key. To use this feature, you simply need to override the #{+frameIdentifier} message to return your own string, and to send the NSWindow class object the #{+observeWindowPosition} message, for example in your #{windowControllerDidLoadNib} message or event better in your #{+initialize} method.
This is a class wide manager: you must subclass NSWindow each time you want a different management."*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindowController(iTM2WindowKit)



#pragma mark <<<<  HUNTING
#ifndef HUNTING
#import "iTM2Runtime.h"

@implementation NSWindow(iTM2WindowKit) 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_frameIdentifier
- (NSString *)iTM2_frameIdentifier;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindowController * WC = [self windowController];
	NSString * result = [WC iTM2_windowFrameIdentifier];
	if([result length])
		return result;
	id delegate = [self delegate];
	if([delegate respondsToSelector:@selector(iTM2_frameIdentifierForWindow:)])
		return [delegate iTM2_frameIdentifierForWindow:self];
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_frameAutosaveIdentifierForMode:
- (NSString *)iTM2_frameAutosaveIdentifierForMode:(iTM2WindowFrameAutosaveMode)aMode;
/*"DF
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * frameIdentifier = [self iTM2_frameIdentifier];
    if ([frameIdentifier length]) 
    {
        switch(aMode) 
        {
            case iTM2WindowFrameFixedMode:
                return [NSString stringWithFormat:@"%@ %@:%@", iTM2FrameFixedWindowKey, frameIdentifier, NSStringFromSize([[NSScreen mainScreen] frame].size)];
            case iTM2WindowFrameCurrentMode:
                return [NSString stringWithFormat:@"%@ %@:%@", iTM2FrameCurrentWindowKey, frameIdentifier, NSStringFromSize([[NSScreen mainScreen] frame].size)];
//            case iTM2WindowFrameSavedMode:
			default:
                return [NSString stringWithFormat:@"%@ %@", iTM2FrameSavedWindowKey, frameIdentifier];
        }
    }
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_frameAutosaveModeKey
- (NSString *)iTM2_frameAutosaveModeKey;
/*"Subclasses must declare a default value for all the modes.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:@"%@ %@", [self iTM2_frameIdentifier], iTM2AutosaveModeKeySuffix];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_positionShouldBeObserved
- (BOOL)iTM2_positionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id WC = [self windowController];
	id delegate = [self delegate];
//iTM2_END;
    return ([delegate respondsToSelector:@selector(iTM2_windowPositionShouldBeObserved:)]
						&& [delegate iTM2_windowPositionShouldBeObserved:self])
				|| [WC iTM2_windowPositionShouldBeObserved];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_compareUsingLevel:
- (NSComparisonResult)iTM2_compareUsingLevel:(id)rhs;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![rhs isKindOfClass:[NSWindow class]])
	return NSOrderedDescending;
    if([self level] < [rhs level])
	return NSOrderedAscending;
    if([self level] > [rhs level])
	return NSOrderedDescending;
//iTM2_END;
    return NSOrderedSame;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_orderBelowFront:
- (void)iTM2_orderBelowFront:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * mainWindow = [NSApp mainWindow];
	NSWindow * parentWindow;
	while(parentWindow = [mainWindow parentWindow])
	{
		mainWindow = parentWindow;
	}
	NSWindow * keyWindow = [NSApp keyWindow];
	while(parentWindow = [keyWindow parentWindow])
	{
		keyWindow = parentWindow;
	}
	NSArray * orderedWindows = [NSApp orderedWindows];
	int WN;
	if(mainWindow)
	{
		if(keyWindow)
		{
			if([orderedWindows indexOfObject:keyWindow] > [orderedWindows indexOfObject:mainWindow])
			{
				WN = [keyWindow windowNumber];
			}
			else
			{
				WN = [mainWindow windowNumber];
			}
		}
		else
		{
			WN = [mainWindow windowNumber];
		}
	}
	else if(keyWindow)
	{
		WN = [keyWindow windowNumber];
	}
	else
	{
		NSEnumerator * E = [orderedWindows objectEnumerator];
		NSWindow * frontWindow = [E nextObject];
		while(parentWindow = [frontWindow parentWindow])
		{
			frontWindow = parentWindow;
		}
		WN = [frontWindow windowNumber];
	}
	[self orderWindow:NSWindowBelow relativeTo:WN];
	[self displayIfNeeded];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_windowsMenuItemTitle
- (NSString *)iTM2_windowsMenuItemTitle;
/*"Gives a default value, useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindowController * WC = [self windowController];
    NSString * DN = [[WC document] displayName];
    return DN? [WC iTM2_windowsMenuItemTitleForDocumentDisplayName:DN]:[self title];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_setDocumentEdited:
- (void)SWZ_iTM2_setDocumentEdited:(BOOL)flag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"THIS IS A PATCHED METHOD");
	[self SWZ_iTM2_setDocumentEdited:flag];
	// got a EXC_BAD_ACCESS here when the pdf update call to context did change was not timed
	[INC postNotificationName:iTM2DocumentEditedStatusNotification object:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_saveFrameUsingName:
- (void)SWZ_iTM2_saveFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name is: %@", name);
    if([self iTM2_positionShouldBeObserved])
    {
		iTM2WindowFrameAutosaveMode mode = [self contextIntegerForKey:[self iTM2_frameAutosaveModeKey] domain:iTM2ContextAllDomainsMask];
		NSString * identifier = [self iTM2_frameAutosaveIdentifierForMode:mode];
		if([identifier length])
		{
			[self takeContextValue:[self stringWithSavedFrame] forKey:[NSString stringWithFormat:@"Window Frame %@", identifier] domain:iTM2ContextAllDomainsMask];
			[self takeContextBool:NO forKey:@"iTM2ShouldCascadeWindows" domain:iTM2ContextAllDomainsMask];
		}
    }
	[self SWZ_iTM2_saveFrameUsingName:name];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_setFrameUsingName:force:
- (BOOL)SWZ_iTM2_setFrameUsingName:(NSString *)name force:(BOOL)force;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name is: %@", name);
    if([self iTM2_positionShouldBeObserved])
	{
		NSString * S;
		S = [self contextStringForKey:[NSString stringWithFormat:@"Window Frame %@", name] domain:iTM2ContextAllDomainsMask];
		if([S length])
		{
			[self setFrameFromString:S];
//iTM2_END;
			return YES;
		}
	}
//iTM2_END;
	return [self SWZ_iTM2_setFrameUsingName:name force:force];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_setFrameUsingName:
- (BOOL)SWZ_iTM2_setFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name is: %@", name);
    if([self iTM2_positionShouldBeObserved])
	{
		NSString * S;
		S = [self contextStringForKey:[NSString stringWithFormat:@"Window Frame %@:%@", name, NSStringFromSize([[NSScreen mainScreen] frame].size)] domain:iTM2ContextAllDomainsMask];
		if([S length])
		{
			[self setFrameFromString:S];
//iTM2_END;
			return YES;
		}
		S = [self contextStringForKey:[NSString stringWithFormat:@"Window Frame %@", name] domain:iTM2ContextAllDomainsMask];
		if([S length])
		{
			[self setFrameFromString:S];
//iTM2_END;
			return YES;
		}
	}
//iTM2_END;
	return [self SWZ_iTM2_setFrameUsingName:name];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_removeFrameUsingName:
- (void)iTM2_removeFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2WindowFrameAutosaveMode mode = [self contextIntegerForKey:[self iTM2_frameAutosaveModeKey] domain:iTM2ContextAllDomainsMask];
    NSString * identifier = [self iTM2_frameAutosaveIdentifierForMode:mode];
	[self takeContextValue:nil forKey:[NSString stringWithFormat:@"Window Frame %@:%@", identifier, NSStringFromSize([[NSScreen mainScreen] frame].size)] domain:iTM2ContextAllDomainsMask];
	[[self class] removeFrameUsingName:name];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_frameAutosaveName
- (NSString *)SWZ_iTM2_frameAutosaveName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * frameAutosaveName = [self SWZ_iTM2_frameAutosaveName];
    return [frameAutosaveName length]? frameAutosaveName:
		[self iTM2_frameAutosaveIdentifierForMode:[self contextIntegerForKey:[self iTM2_frameAutosaveModeKey] domain:iTM2ContextAllDomainsMask]];
}
@end
#pragma mark >>>>  HUNTING
#endif

NSString * const iTM2DocumentEditedStatusNotification = @"iTM2DocumentEditedStatus";

#pragma mark <<<<  HUNTING
#ifndef HUNTING

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

@implementation NSWindowController(iTM2WindowKit_)
// the default iTM2_windowFrameIdentifier is implemented in iTM2DocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_windowPositionShouldBeObserved
- (BOOL)iTM2_windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)iTM2_windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self windowTitleForDocumentDisplayName:displayName];
}
@end

@interface iTM2WindowsObserver: NSObject
@end

@implementation iTM2WindowsObserver
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Lazy initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!DNC)
	{
		iTM2_LOG(@"..........  ERROR: DNC should not be nil, the windows are not observed...");
	}
    #define OBSERVE(SELECTOR, NOTIFICATION)\
        [DNC addObserver:self\
            selector:@selector(SELECTOR) \
                name: NOTIFICATION\
                    object: nil];
    OBSERVE(rememberCurrentWindowPosition:, NSWindowDidBecomeKeyNotification);
    OBSERVE(rememberCurrentWindowPosition:, NSWindowDidBecomeMainNotification);
    OBSERVE(rememberCurrentWindowPosition:, NSWindowDidDeminiaturizeNotification);
    OBSERVE(rememberCurrentWindowPosition:, NSWindowDidMoveNotification);
    OBSERVE(rememberCurrentWindowPosition:, NSWindowDidResizeNotification);
    OBSERVE(forgetCurrentWindowPosition:, NSWindowDidMiniaturizeNotification);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rememberCurrentWindowPosition:
+ (void)rememberCurrentWindowPosition:(NSNotification *)aNotification;
/*"Subclasses should not need to override this method. Registers in the registration domain of the user defaults database the frame of aNotification object. The key used is the class frameIdentifier of this object.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [aNotification object];
    if ([W iTM2_positionShouldBeObserved] && [W isVisible]) 
    {
        [W saveFrameUsingName:[W iTM2_frameAutosaveIdentifierForMode:iTM2WindowFrameSavedMode]];
        [W saveFrameUsingName:[W iTM2_frameAutosaveIdentifierForMode:iTM2WindowFrameCurrentMode]];
        [SUD synchronize];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forgetCurrentWindowPosition:
+ (void)forgetCurrentWindowPosition:(NSNotification *)aNotification;
/*"Subclasses should not need to override this method. The key used is the class frameIdentifier of this object but the registered frame is a zero rect.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [aNotification object];
    NSString * frameIdentifier = [W iTM2_frameIdentifier];
    if ([frameIdentifier length]>0) 
    {
        [[W class] removeFrameUsingName:frameIdentifier];
    }
    return;
}
@end
#pragma mark >>>>  HUNTING
#endif

@implementation iTM2Window
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
//iTM2_END;
    return;
}
@synthesize _Implementation;
@end

@implementation iTM2MainInstaller(WindowKit)
+ (void)prepareWindowKitCompleteInstallation;
{
	if([NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_setDocumentEdited:)]
		&& [NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_saveFrameUsingName:)]
		&& [NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_setFrameUsingName:force:)]
		&& [NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_setFrameUsingName:)]
		&& [NSWindow iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_frameAutosaveName)])
	{
		iTM2_MILESTONE((@"NSWindow(iTM2WindowKit)"),(@"No custom window frame management"));
	}

}
@end

//