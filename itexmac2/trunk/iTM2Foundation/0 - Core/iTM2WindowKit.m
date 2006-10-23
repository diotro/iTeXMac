/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>

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
@implementation NSWindow(iTM2WindowKit) 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameIdentifier
- (NSString *)frameIdentifier;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindowController * WC = [self windowController];
	NSString * result = [WC windowFrameIdentifier];
	if([result length])
		return result;
	id delegate = [self delegate];
	if([delegate respondsToSelector:@selector(frameIdentifierForWindow:)])
		return [delegate frameIdentifierForWindow:self];
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameAutosaveIdentifierForMode:
- (NSString *)frameAutosaveIdentifierForMode:(iTM2WindowFrameAutosaveMode)aMode;
/*"DF
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * frameIdentifier = [self frameIdentifier];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameAutosaveModeKey
- (NSString *)frameAutosaveModeKey;
/*"Subclasses must declare a default value for all the modes.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:@"%@ %@", [self frameIdentifier], iTM2AutosaveModeKeySuffix];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionShouldBeObserved
- (BOOL)positionShouldBeObserved;
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
    return ([delegate respondsToSelector:@selector(windowPositionShouldBeObserved:)]
						&& [delegate windowPositionShouldBeObserved:self])
				|| [WC windowPositionShouldBeObserved];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareUsingLevel:
- (NSComparisonResult)compareUsingLevel:(id)rhs;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowsMenuItemTitle
- (NSString *)windowsMenuItemTitle;
/*"Gives a default value, useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindowController * WC = [self windowController];
    NSString * DN = [[WC document] displayName];
    return DN? [WC windowsMenuItemTitleForDocumentDisplayName:DN]:[self title];
}
@end
#pragma mark >>>>  HUNTING
#endif

NSString * const iTM2DocumentEditedStatusNotification = @"iTM2DocumentEditedStatus";

#pragma mark <<<<  HUNTING
#ifndef HUNTING

@interface NSWindow_iTM2WindowKit: NSWindow
@end

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

@implementation NSWindow_iTM2WindowKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSWindow_iTM2WindowKit poseAsClass:[NSWindow class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setDocumentEdited:
- (void)setDocumentEdited:(BOOL)flag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"THIS IS A PATCHED METHOD");
	[super setDocumentEdited:flag];
	// got a EXC_BAD_ACCESS here when the pdf update call to context did change was not timed
	[INC postNotificationName:iTM2DocumentEditedStatusNotification object:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveFrameUsingName:
- (void)saveFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name is: %@", name);
    if([self positionShouldBeObserved])
    {
		iTM2WindowFrameAutosaveMode mode = [self contextIntegerForKey:[self frameAutosaveModeKey] domain:iTM2ContextAllDomainsMask];
		NSString * identifier = [self frameAutosaveIdentifierForMode:mode];
		if([identifier length])
		{
			[self takeContextValue:[self stringWithSavedFrame] forKey:[NSString stringWithFormat:@"Window Frame %@", identifier] domain:iTM2ContextAllDomainsMask];
			[self takeContextBool:NO forKey:@"iTM2ShouldCascadeWindows" domain:iTM2ContextAllDomainsMask];
		}
    }
	[super saveFrameUsingName:name];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setFrameUsingName:force:
- (BOOL)setFrameUsingName:(NSString *)name force:(BOOL)force;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name is: %@", name);
    if([self positionShouldBeObserved])
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
	return [super setFrameUsingName:name force:force];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setFrameUsingName:
- (BOOL)setFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name is: %@", name);
    if([self positionShouldBeObserved])
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
	return [super setFrameUsingName:name];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeFrameUsingName:
- (void)removeFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2WindowFrameAutosaveMode mode = [self contextIntegerForKey:[self frameAutosaveModeKey] domain:iTM2ContextAllDomainsMask];
    NSString * identifier = [self frameAutosaveIdentifierForMode:mode];
	[self takeContextValue:nil forKey:[NSString stringWithFormat:@"Window Frame %@:%@", identifier, NSStringFromSize([[NSScreen mainScreen] frame].size)] domain:iTM2ContextAllDomainsMask];
	[[self class] removeFrameUsingName:name];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameAutosaveName
- (NSString *)frameAutosaveName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * frameAutosaveName = [super frameAutosaveName];
    return [frameAutosaveName length]? frameAutosaveName:
		[self frameAutosaveIdentifierForMode:[self contextIntegerForKey:[self frameAutosaveModeKey] domain:iTM2ContextAllDomainsMask]];
}
#if __iTM2_DEVELOPMENT__
- (void)makeKeyAndOrderFront:(id)sender;
{iTM2_DIAGNOSTIC;
	[super makeKeyAndOrderFront:sender];
}
#endif
@end

@implementation NSWindowController(iTM2WindowKit_)
// the default windowFrameIdentifier is implemented in iTM2DocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Lazy initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
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
    iTM2_RELEASE_POOL;
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
    if ([W positionShouldBeObserved] && [W isVisible]) 
    {
        [W saveFrameUsingName:[W frameAutosaveIdentifierForMode:iTM2WindowFrameSavedMode]];
        [W saveFrameUsingName:[W frameAutosaveIdentifierForMode:iTM2WindowFrameCurrentMode]];
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
    NSString * frameIdentifier = [W frameIdentifier];
    if ([frameIdentifier length]>0) 
    {
        [[W class] removeFrameUsingName:frameIdentifier];
    }
    return;
}
@end
#pragma mark >>>>  HUNTING
#endif

#if 0
#warning DEBUGGGGGGGGGGGGGGGGGGGG
@interface NSMenu(PRIVATE1)
- (void)showItemWithKeyEquivalentForEvent:(NSEvent *)anEvent;
@end
@interface NSMenu_MOI: NSMenu
@end
@implementation NSMenu_MOI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSMenu_MOI poseAsClass:[NSMenu class]];
//iTM2_END;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"NSMenu_MOI is posed as NSMenu (NSApp is %@)", NSApp);
	}
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performKeyEquivalent:
- (BOOL)performKeyEquivalent:(NSEvent *)anEvent;
/*"DF.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = NO;
	NS_DURING
	result = [super performKeyEquivalent:anEvent];
//iTM2_LOG(@"MENU TITLE IS %@, anEvent is: %@, %@", [self title], anEvent, (result? @"YES":@"NO"));
	[self showItemWithKeyEquivalentForEvent:anEvent];
	NS_HANDLER
	iTM2_LOG(@"***  Exception catched %@", [localException reason]);
	NS_ENDHANDLER
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showItemWithKeyEquivalentForEvent:
- (void)showItemWithKeyEquivalentForEvent:(NSEvent *)anEvent;
/*"DF.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self itemArray] objectEnumerator];
	id MI;
	while(MI = [E nextObject])
	{
		if([MI hasSubmenu])
		{
			[[MI submenu] showItemWithKeyEquivalentForEvent:anEvent];
		}
		else if([[MI keyEquivalent] isEqual:[anEvent charactersIgnoringModifiers]])
		{
			iTM2_LOG(@"1 - Menu is: %@ and Menu item: %@, %#x, charactersIgnoringModifiers: %@", [self title], [MI title], [MI keyEquivalentModifierMask], [anEvent charactersIgnoringModifiers]);
		}
		else if([[MI keyEquivalent] isEqual:[anEvent characters]])
		{
			iTM2_LOG(@"2 - Menu is: %@ and Menu item: %@, %#x, characters: %@", [self title], [MI title], [MI keyEquivalentModifierMask], [anEvent characters]);
		}
		else if([[[MI keyEquivalent] lowercaseString] isEqual:[[anEvent charactersIgnoringModifiers] lowercaseString]])
		{
			iTM2_LOG(@"3 - Menu is: %@ and Menu item: %@, %#x, charactersIgnoringModifiers: %@", [self title], [MI title], [MI keyEquivalentModifierMask], [anEvent charactersIgnoringModifiers]);
		}
		else if([[[MI keyEquivalent] lowercaseString] isEqual:[[anEvent characters] lowercaseString]])
		{
			iTM2_LOG(@"4 - Menu is: %@ and Menu item: %@, %#x, characters: %@", [self title], [MI title], [MI keyEquivalentModifierMask], [anEvent characters]);
		}
	}
//iTM2_END;
	return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2WindowsObserver
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
@end
