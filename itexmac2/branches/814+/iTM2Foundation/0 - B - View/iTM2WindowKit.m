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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameIdentifier4iTM3
- (NSString *)frameIdentifier4iTM3;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindowController * WC = self.windowController;
	NSString * result = [WC windowFrameIdentifier4iTM3];
	if (result.length)
		return result;
	id delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(frameIdentifierForWindow4iTM3:)])
		return [delegate frameIdentifierForWindow4iTM3:self];
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameAutosaveIdentifierForMode4iTM3:
- (NSString *)frameAutosaveIdentifierForMode4iTM3:(iTM2WindowFrameAutosaveMode)aMode;
/*"DF
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * frameIdentifier = self.frameIdentifier4iTM3;
    if (frameIdentifier.length) 
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameAutosaveModeKey4iTM3
- (NSString *)frameAutosaveModeKey4iTM3;
/*"Subclasses must declare a default value for all the modes.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSString stringWithFormat:@"%@ %@", self.frameIdentifier4iTM3, iTM2AutosaveModeKeySuffix];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionShouldBeObserved4iTM3
- (BOOL)positionShouldBeObserved4iTM3;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id WC = self.windowController;
	id delegate = self.delegate;
//END4iTM3;
    return ([delegate respondsToSelector:@selector(windowPositionShouldBeObserved4iTM3:)]
						&& [delegate windowPositionShouldBeObserved4iTM3:self])
				|| [WC windowPositionShouldBeObserved4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareUsingLevel4iTM3:
- (NSComparisonResult)compareUsingLevel4iTM3:(id)rhs;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![rhs isKindOfClass:[NSWindow class]])
	return NSOrderedDescending;
    if (self.level < [rhs level])
	return NSOrderedAscending;
    if (self.level > [rhs level])
	return NSOrderedDescending;
//END4iTM3;
    return NSOrderedSame;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderBelowFront4iTM3:
- (void)orderBelowFront4iTM3:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * mainWindow = [NSApp mainWindow];
	NSWindow * parentWindow;
	while (parentWindow = [mainWindow parentWindow]) {
		mainWindow = parentWindow;
	}
	NSWindow * keyWindow = [NSApp keyWindow];
	while (parentWindow = [keyWindow parentWindow]) {
		keyWindow = parentWindow;
	}
	NSArray * orderedWindows = [NSApp orderedWindows];
	NSInteger WN = ZER0;
	if (mainWindow) {
		if (keyWindow) {
			if ([orderedWindows indexOfObject:keyWindow] > [orderedWindows indexOfObject:mainWindow]) {
				WN = [keyWindow windowNumber];
			} else {
				WN = [mainWindow windowNumber];
			}
		} else {
			WN = [mainWindow windowNumber];
		}
	} else if (keyWindow) {
		WN = [keyWindow windowNumber];
	} else {
		NSWindow * frontWindow = orderedWindows.objectEnumerator.nextObject;
		while((parentWindow = [frontWindow parentWindow])) {
			frontWindow = parentWindow;
		}
		WN = [frontWindow windowNumber];
	}
	[self orderWindow:NSWindowBelow relativeTo:WN];
	self.displayIfNeeded;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowsMenuItemTitle4iTM3
- (NSString *)windowsMenuItemTitle4iTM3;
/*"Gives a default value, useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindowController * WC = self.windowController;
    NSString * DN = [WC.document displayName];
    return DN? [WC windowsMenuItemTitleForDocumentDisplayName4iTM3:DN]:self.title;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_setDocumentEdited:
- (void)SWZ_iTM2_setDocumentEdited:(BOOL)flag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"THIS IS A PATCHED METHOD");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"name is: %@", name);
    if (self.positionShouldBeObserved4iTM3) {
		iTM2WindowFrameAutosaveMode mode = [self context4iTM3IntegerForKey:self.frameAutosaveModeKey4iTM3 domain:iTM2ContextAllDomainsMask];
		NSString * identifier = [self frameAutosaveIdentifierForMode4iTM3:mode];
		if (identifier.length) {
			[self takeContext4iTM3Value:self.stringWithSavedFrame forKey:[NSString stringWithFormat:@"Window Frame %@", identifier] domain:iTM2ContextAllDomainsMask error:self.RORef4iTM3];
			[self takeContext4iTM3Bool:NO forKey:@"iTM2ShouldCascadeWindows" domain:iTM2ContextAllDomainsMask];
		}
    }
	[self SWZ_iTM2_saveFrameUsingName:name];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_setFrameUsingName:force:
- (BOOL)SWZ_iTM2_setFrameUsingName:(NSString *)name force:(BOOL)force;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"name is: %@", name);
    if (self.positionShouldBeObserved4iTM3)
	{
		NSString * S;
		S = [self context4iTM3StringForKey:[NSString stringWithFormat:@"Window Frame %@", name] domain:iTM2ContextAllDomainsMask];
		if (S.length)
		{
			[self setFrameFromString:S];
//END4iTM3;
			return YES;
		}
	}
//END4iTM3;
	return [self SWZ_iTM2_setFrameUsingName:name force:force];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_setFrameUsingName:
- (BOOL)SWZ_iTM2_setFrameUsingName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"name is: %@", name);
    if (self.positionShouldBeObserved4iTM3)
	{
		NSString * S;
		S = [self context4iTM3StringForKey:[NSString stringWithFormat:@"Window Frame %@:%@", name, NSStringFromSize([[NSScreen mainScreen] frame].size)] domain:iTM2ContextAllDomainsMask];
		if (S.length)
		{
			[self setFrameFromString:S];
//END4iTM3;
			return YES;
		}
		S = [self context4iTM3StringForKey:[NSString stringWithFormat:@"Window Frame %@", name] domain:iTM2ContextAllDomainsMask];
		if (S.length)
		{
			[self setFrameFromString:S];
//END4iTM3;
			return YES;
		}
	}
//END4iTM3;
	return [self SWZ_iTM2_setFrameUsingName:name];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeFrameUsingName4iTM3:
- (void)removeFrameUsingName4iTM3:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2WindowFrameAutosaveMode mode = [self context4iTM3IntegerForKey:self.frameAutosaveModeKey4iTM3 domain:iTM2ContextAllDomainsMask];
    NSString * identifier = [self frameAutosaveIdentifierForMode4iTM3:mode];
	[self takeContext4iTM3Value:nil forKey:[NSString stringWithFormat:@"Window Frame %@:%@", identifier, NSStringFromSize([[NSScreen mainScreen] frame].size)] domain:iTM2ContextAllDomainsMask error:self.RORef4iTM3];
	[self.class removeFrameUsingName:name];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_frameAutosaveName
- (NSString *)SWZ_iTM2_frameAutosaveName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * frameAutosaveName = [self SWZ_iTM2_frameAutosaveName];
    return frameAutosaveName.length? frameAutosaveName:
		[self frameAutosaveIdentifierForMode4iTM3:[self context4iTM3IntegerForKey:self.frameAutosaveModeKey4iTM3 domain:iTM2ContextAllDomainsMask]];
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
// the default windowFrameIdentifier4iTM3 is implemented in iTM2DocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName4iTM3:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!DNC)
	{
		LOG4iTM3(@"..........  ERROR: DNC should not be nil, the windows are not observed...");
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
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rememberCurrentWindowPosition:
+ (void)rememberCurrentWindowPosition:(NSNotification *)aNotification;
/*"Subclasses should not need to override this method. Registers in the registration domain of the user defaults database the frame of aNotification object. The key used is the class frameIdentifier of this object.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindow * W = [aNotification object];
    if ([W positionShouldBeObserved4iTM3] && [W isVisible]) 
    {
        [W saveFrameUsingName:[W frameAutosaveIdentifierForMode4iTM3:iTM2WindowFrameSavedMode]];
        [W saveFrameUsingName:[W frameAutosaveIdentifierForMode4iTM3:iTM2WindowFrameCurrentMode]];
        [SUD synchronize];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forgetCurrentWindowPosition:
+ (void)forgetCurrentWindowPosition:(NSNotification *)aNotification;
/*"Subclasses should not need to override this method. The key used is the class frameIdentifier of this object but the registered frame is a zero rect.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * W = [aNotification object];
    NSString * frameIdentifier = [W frameIdentifier4iTM3];
    if (frameIdentifier.length>ZER0) 
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
//END4iTM3;
    return;
}
@synthesize _Implementation;
@end

@implementation iTM2MainInstaller(WindowKit)
+ (void)prepareWindowKitCompleteInstallation4iTM3;
{
	if ([NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_setDocumentEdited:) error:NULL]
		&& [NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_saveFrameUsingName:) error:NULL]
		&& [NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_setFrameUsingName:force:) error:NULL]
		&& [NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_setFrameUsingName:) error:NULL]
		&& [NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_frameAutosaveName) error:NULL])
	{
		MILESTONE4iTM3((@"NSWindow(iTM2WindowKit)"),(@"No custom window frame management"));
	}
}
@end

//